/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet,Dot_member" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_CustomerInsMember_Ag]
(
	@custid		int OUTPUT,
	@creator	int,
	@username	varchar(30),
	@userpwd	varchar(40) = '123qwe',
	@recommend	int, -- Agent ID
	@IP										varchar(15)='',
	@Language								varchar(2)= 'E',
	@SubAccID								int = 0, --Sub-AccountID
	@ErrCode								int = 0 OUTPUT,
	@ErrMsg									nvarchar(4000) = '' OUTPUT
)	
AS

--@Source Control
/*
Created: 20120322@Dom
Task : Agent create dummy account
DB: DBTRANS.bodb02
Original:

Revisions:
    - 20121128@Elodie: Get an error message from f_Get_MsgNameByMsgID function by language
    - 20130604@Daniel: Change default P2P param value to "Disable P2P"
    - 20130607@Daniel: Exclude created member from Balance checking
    - 20130731@Elodie: Apply progressive bonus
	- 20130919@Don: Supporting save log of Number Game PT with format such as "0.995", "0.925", ...
	- 20131014@Francis: Support adding new virtual sports with settings via XML param
	- 20131108@Elodie: Splitting bodb02 into CustDB (Insert Task_Cust_CheckBalance_Exception by link database)	
	- 20140505@Florent: Add sport HR Fix Odds
	- 20140512@Florent: Add new sport: 202 Keno
    - 20150309@Johnson: Disable virtual rate as default [RedmineID: #31927]
    - 20150610@Kathy: Migrate custDB to new server DBCust (temp GameType table, call Task_Cust_CheckBalance_Exception_Ins by linked server) [Redmine:#36216]
    - 20151028@Jim:Implement Muay's Setting for Deposit Customer [Redmine: #45491]
    - 20170302@Helen: Betradar Virtual Sports  -Integration for Cash [Redmine: 77274]
    - 20170808@Winnie: Change Data Type of Sporttype [RedmineID: #73545]	
    - 20180125@Winnie: Hide inactive products [RedmineID: #86086]
	- 20181002@Dominic: Check existing username/username2 in archived DB  [Redmine:99882]
	- 20190326@Winnie: Update PT of Sportsbook for All Licensee. [RedmineID: #110111]
	- 20190422@Elodie: Offer unique nickname for CN88 [Redmine:112287]
	- 20190429@Elodie: Insert VR setting get from Upline for new customer [RedmineID: #112657]
	- 20190726@Winnie: Remove Muay Thai. [RedmineID: #117501]
	- 20190905@Eden: 3rd party products - Remove InActive Products Phase 2 [Redmine: #118699]
	- 20200622@Johnson: add Soccer Parlay bet limit [redmine: #135261]
	- 20201214@Winfred: Adjust PT value with 4 decimal places for SB  [redmine: #146574]
	- 20220112@Eden: LAP - RNG Casino - Implement DCS Settings [Redmine: #166217] 
	- 20220617@Johnson: define temp table to avoid dump db [redmine:#174035]
	- 20220301@Eden: Deposit - Sportsbook - Revise customer settings [Redmine: #167898] 
Param's Explanation:
• @ErrCode:
    = 0: Create member successfully.
    > 0: Specific Error.
  
• @ErrMsg: Error description.

*/
BEGIN
	SET NOCOUNT ON

	declare @startRun datetime
	declare @endRun datetime
	declare @duration int
	set @startRun = getdate()

	--Check an account disabled or not 
	EXEC dbo.Acc_CustomerSelCheckEnable @custid = @recommend, @ErrCode=@ErrCode output,@ErrMsg=@ErrMsg output 
	if @ErrCode <>0		
		return 

	declare 
		@currency int, @pwdexpiry datetime,
		@srecommend int, @mrecommend int,	 
		@matchlimit smallmoney,
		@UplineClosed bit,
		@DisableOutright bit,
		@VirtualMultiplier SMALLMONEY

	select 
		@currency = currency, 
		@UplineClosed = closed,
		@srecommend = srecommend,
		@mrecommend = mrecommend,
		@matchlimit = matchlimit,
		@DisableOutright = DisableOutright,
		@VirtualMultiplier = ci.VirtualMultiplier
	from CustInfo as ci with (NOLOCK) 
	where CustID = @recommend

	Select @ErrCode = 0

	SELECT @username = rtrim(ltrim(@username))

	DECLARE @IsExists BIT 
	EXEC Age_CustomerCheckExists @username = @username, @IsExists = @IsExists OUTPUT

	IF @IsExists = 1
	BEGIN
		SELECT @ErrMsg = CASE @Language 
								WHEN 'E' THEN 'This username is not available.'
								ELSE [dbo].[f_Get_MsgNamebyMsgID](40001,@Language)
						END,
			@ErrCode = 101		
		RETURN
	END
	SELECT @pwdexpiry = dateadd(dd, 30, getdate())

	--Insert general data 
	EXEC dbo.Acc_Dep_CustomerInsUserInfo
		@custid = @custid OUTPUT,
		@creator = @creator,
		@username = @username,
		@userpwd = @userpwd,
		@pwdexpiry = @pwdexpiry,
		@currency = @currency,
		@site = NULL,
		@srecommend = @srecommend,
		@mrecommend = @mrecommend,
		@recommend = @recommend,
		@roleid = 1,
		@TransferOption = NULL,
		@suspended = 0,
		@closed=@UplineClosed,
		@DisableOutright = @DisableOutright,		
		@matchlimit = @matchlimit,
		@virtualmultiplier = @VirtualMultiplier,
		@IsInternal = 0,	
		@credit = 0,
		@maxcredit = 0,
		@IP = @IP,
		@TransferOption_dec = 0,
		@Language = @Language,
		@ErrCode = @ErrCode OUTPUT,
		@ErrMsg = @ErrMsg OUTPUT

	if @ErrCode <> 0
		return

	--Exclude created member from Balance checking
	--INSERT INTO dbo.Task_Cust_CheckBalance_Exception(custid, remark) values(@custid, @username)
	EXEC DBTXN.bodb02.dbo.Task_Cust_CheckBalance_Exception_Ins @custid = @custid, @username = @username
	IF @@ERROR <> 0
	BEGIN
		--Error occur
		SELECT @ErrMsg = case @Language 
								when 'E' then 'Exclude customer from balance checking failed.'
								else N'Exclude customer from balance checking failed.'
							end,
			@ErrCode = 211		
		RETURN
	END

	set @endRun = getdate()
	set @duration  = datediff (millisecond,@startRun,@endRun)

	Declare @LogSPData varchar(MAX)
	--Log customer info
	Select @LogSPData = '<Acc_Dep_CustomerInsMember_Ag custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +
	'creator="'+ coalesce(cast(@creator as varchar(50)),space(1)) + '" ' +
	'username="'+ coalesce(cast(@username as varchar(30)),space(1)) + '" ' +
	'recommend="'+ coalesce(cast(@recommend as varchar(50)),space(1)) + '" ' +
	'IP="'+ coalesce(cast(@IP as varchar(15)),space(1)) + '" ' +
	'Language="'+ coalesce(cast(@Language as varchar(2)),space(1)) + '" ' +
	'SubAccName="'+ coalesce(cast(dbo.f_GetSubUsername(@SubAccID) as varchar(30)),space(1)) + '" ' +
	'ErrCode="'+ coalesce(cast(@ErrCode as varchar(50)),space(1)) + '" ' +
	'ErrMsg="'+ coalesce(cast(@ErrMsg as varchar(4000)),space(1)) + '" />'

	EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP 
		@UserID = @Creator,
		@CustID = @CustID,
		@ActionID = 2415,
		@TrackingValue = @LogSPData,
		@duration = @duration		
	 
	--Log Status
	Select @LogSPData = '<Acc_Dep_CustomerInsMember_Ag custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +
	'closed="'+ coalesce(cast(@UplineClosed as varchar(1)),space(1)) + '" ' +
	'DisableOutright="'+ coalesce(cast(@DisableOutright as varchar(1)),space(1)) + '" />'

	EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP 
		@UserID = @Creator,
		@CustID = @CustID,
		@ActionID = 2205,
		@TrackingValue = @LogSPData,
		@duration = @duration
END
GO
GO
