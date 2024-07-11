/*<info serverAlias="DBCust-CustDB" executers="wsv_nap,svc_tig" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_CustomerInsMember_Com]
(
	@custid INT OUTPUT,
	@creator INT,
	@username VARCHAR(30),
	@userpwd VARCHAR(40) = '123qwe',
	@site NVARCHAR(50), 
	@currency INT, 
	@IP VARCHAR(15)='',
	@Language VARCHAR(2)= 'E',
	@ErrCode INT = 0 OUTPUT,
	@ErrMsg NVARCHAR(2000) = '' OUTPUT
)	
AS
--@Source Control
/*
Created: 20120314@Dom
Task : Company create Super in Deposite site
DB: DBCUST-CUSTDB
Original:
Revisions:
    - 20121128@Elodie: Get an error message from f_Get_MsgNameByMsgID function by language
    - 20130604@Daniel: Change default P2P param value to "Disable P2P"
    - 20130607@Daniel: Exclude created member from Balance checking
    - 20130731@Elodie: Apply progressive bonus
	- 20130919@Don: Supporting save log of Number Game PT with format such as "0.995", "0.925", ...
	- 20131014@Francis: Support adding new virtual sports with settings via XML param
	- 20140505@Florent: Add sport HR Fix Odds
	- 20140509@Florent: Add new sport: 202 Keno
	- 20140605@Florent: Remove checking for Super
	- 20150309@Johnson: Disable virtual rate as default [RedmineID: #31927]
    - 20150609@David: Separate CustDB to DBCUST server (Use temp table for sports, bettype, GameType table, call some SPs by link server)
	- 20151028@Jim:Implement Muay's Setting for Deposit Customer [Redmine: #45491]
    - 20160830@Winnie: #63151  Add ColossusBet Agent commRate
    - 20170302@Helen: Betradar Virtual Sports  -Integration for Cash [Redmine: 77274]
    - 20170808@Winnie: Change Data Type of Sporttype [RedmineID: #73545]	
    - 20180125@Winnie: Hide inactive products [RedmineID: #86086]
	- 20181002@Dominic: Check existing username/username2 in archived DB  [Redmine:99882]  
	- 20190326@Winnie: Update PT of Sportsbook for All Licensee. [RedmineID: #110111]
	- 20190422@Elodie: Offer unique nickname for CN88 [Redmine:112287]
	- 20190726@Winnie: Remove Muay Thai. [RedmineID: #117501]
	- 20190905@Eden: 3rd party products - Remove InActive Products Phase 2 [Redmine: #118699]
	- 20200622@Johnson: add Soccer Parlay bet limit [redmine: #135261]
	- 20200617@Eden: Virtual Rate for Basketball - New IBO dummy super must have VR setting = 0%  [Redmine: #134978] 
	- 20201214@Winfred: Adjust PT value with 4 decimal places for SB  [redmine: #146574]
	- 20210520@Eden: Apply default VR Setting which is -90% whenever there is new LICENSEE Supers creation [Redmine:#153411]
	- 20220112@Eden: LAP - RNG Casino - Implement DCS Settings [Redmine: #166217] 
	- 20220617@Johnson: define temp table to avoid dump db [redmine:#174035]
	- 20220301@Eden: Deposit - Sportsbook - Revise customer settings [Redmine: #167898] 
	- 20221207@Tacy: Remove columns and code used by Colossus Bets, GD product [RedmineID: #188096]
	- 20230303@Johnson: Return Basketball VR to its original state [redmine: #184339]
	- 20240710@Johnson: Apply In-house Replication for Deposit Customer Setting [redmine:#207025]
	
Param's Explanation:
• @ErrCode:
    = 0: Create super successfully.
    > 0: Specific Error.
  
• @ErrMsg: Error description.

*/
BEGIN
	SET NOCOUNT ON
	DECLARE @startRun DATETIME , @endRun DATETIME , @duration INT
	SET @startRun = GETDATE()

	SELECT @ErrCode = 0

	If Not Exists(Select 1 From Exchange (nolock) Where ExchangeID = @Currency)
	Begin
		Select @ErrCode = 5
		Select @ErrMsg = 	case @Language 
							when 'E' then 'Invalid currency.'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](40015,@Language)
					end
		return
	End

	
	DECLARE @IsExists BIT 
	EXEC Age_CustomerCheckExists @username = @username, @IsExists = @IsExists OUTPUT

	IF @IsExists = 1
	BEGIN
		SELECT @ErrMsg = CASE @Language 
							WHEN 'E' THEN 'This username is not available.'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](40001,@Language)
						END
		SELECT @ErrCode = 101		
		RETURN
	END

	--Insert general info
	EXEC dbo.Acc_Dep_CustomerInsUserInfo
		@custid = @custid OUTPUT,
		@creator = @creator,
		@username = @username,
		@userpwd = @userpwd,
		@pwdexpiry = NULL,
		@currency = @currency,
		@site = @site,
		@srecommend = 0,
		@mrecommend = 0,
		@recommend = 0,
		@roleid = 4,
		@TransferOption = NULL,
		@suspended = 0,
		
		@matchlimit = 1,
		--20150309@Johnson: disable virtual rate as default --> #RM153411 : Enabled VR as default
		@virtualmultiplier = 1,	

		@credit = 0,
		@maxcredit = NULL,
		@IP = @IP,
		@isinternal = 0,
		@TransferOption_dec = NULL,
		@Language = @Language,
		@ErrCode = @ErrCode OUTPUT,
		@ErrMsg = @ErrMsg OUTPUT
	--Error occurs
	IF @ErrCode <> 0
		RETURN

	----------------------CHECK Error

	IF @@ERROR <> 0
	BEGIN
		DELETE FROM Dep_CustSuper WITH(ROWLOCK) 
		OUTPUT DELETED.custid, SYSDATETIME()
		INTO Dep_CustSuper_Del_InHouse(custid,RepUpdateTime)
		WHERE custId = @CustID
		
		EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
 		RETURN 
	END  
	
	--Insert ProductSetting of SportBooks for Super:
	INSERT INTO dbo.Dep_LicenseeProductSetting(CustID, ProductSettingID,RepUpdateTime)
	SELECT @custid, p.ProductSettingID, SYSDATETIME()
	FROM dbo.Dep_ProductSetting p WITH (NOLOCK) 
		LEFT JOIN Dep_LicenseeProductSetting dp WITH(NOLOCK) 
			ON p.ProductSettingID = dp.ProductSettingID 
			AND dp.CustID = @custid
	WHERE p.ProductID = 1 
		AND p.SettingType = 9
		AND dp.CustID IS NULL

	IF @@ERROR <> 0
	BEGIN
		DELETE VRCustSetting WITH (ROWLOCK) WHERE custId  =@custid
		DELETE FROM Dep_CustSuper WITH(ROWLOCK) 
		OUTPUT DELETED.custid, SYSDATETIME()
		INTO Dep_CustSuper_Del_InHouse(custid,RepUpdateTime)
		WHERE custId = @CustID
		
		EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
		DELETE Dep_LicenseeProductSetting WITH(ROWLOCK) 
		OUTPUT DELETED.custid, DELETED.ProductSettingID,SYSDATETIME()
		INTO Dep_LicenseeProductSetting_Del_InHouse(custid,ProductSettingID,RepUpdateTime)
		WHERE custid = @custid
		RETURN 
	END  

	----------------------------END INSERT------------------------------------
		
	SET @endRun = GETDATE()
	SET @duration  = DATEDIFF (millisecond,@startRun,@endRun)

	DECLARE @LogSPData VARCHAR(MAX)
	--Write general info
	SELECT @LogSPData = '<Acc_Dep_CustomerInsMember_Com custid="'+ COALESCE(CAST(@custid AS VARCHAR(50)),SPACE(1)) + '" ' +
	'creator="'+ COALESCE(CAST(@creator AS VARCHAR(50)),SPACE(1)) + '" ' +
	'username="'+ COALESCE(CAST(@username AS VARCHAR(20)),SPACE(1)) + '" ' +
	'site="'+ COALESCE(CAST(@site AS VARCHAR(100)),SPACE(1)) + '" ' +
	'currency="'+ COALESCE(CAST(@currency AS VARCHAR(50)),SPACE(1)) + '" ' +
	'IP="'+ COALESCE(CAST(@IP AS VARCHAR(15)),SPACE(1)) + '" ' +
	'Language="'+ COALESCE(CAST(@Language AS VARCHAR(2)),SPACE(1)) + '" ' +
	'ErrCode="'+ COALESCE(CAST(@ErrCode AS VARCHAR(50)),SPACE(1)) + '" ' +
	'ErrMsg="'+ COALESCE(CAST(@ErrMsg AS VARCHAR(4000)),SPACE(1)) + '" />'

	EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP 
		@UserID = @Creator,
		@CustID = @CustID,
		@ActionID = 2412,
		@TrackingValue = @LogSPData,
		@duration = @duration
END
GO
