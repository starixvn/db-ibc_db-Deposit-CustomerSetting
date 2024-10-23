/*<info serverAlias="DBCUST-CUSTDB" executers="" viewers="" isFunction="0" isNested="1"></info>*/
ALTER PROCEDURE [dbo].[Dot_Dep_Customer_Archive_InsertCustomerInfo]
	@custid INT,
	@firstname NVARCHAR(50),
	@lastname NVARCHAR(50),
	@creator INT,
	@username VARCHAR(30),
	@userpwd VARCHAR(40),
	@pwdexpiry DATETIME,
	@currency INT,
	@site NVARCHAR(50),
	@ugroup VARCHAR(5) = NULL,
	@createDate SMALLDATETIME, --20181011@Kean: Support for reactivation of member
	@birthday SMALLDATETIME,
	@refcode1	NVARCHAR(50),
	@remark NVARCHAR(50),
	@refcode2 NVARCHAR(50),
	@username2 VARCHAR(50),

	@srecommend INT,
	@mrecommend INT,
	@recommend INT,
	@roleid INT = 1,
	
	@Danger TINYINT = 0,
	@Danger2 TINYINT = 0,
	@Danger3 TINYINT = 0,
	@Danger4 TINYINT = 0,
	@Danger5 TINYINT = 0,

	@Abnormal TINYINT = 0,
	
	@phone NVARCHAR(50),
	@mobilephone NVARCHAR(50),
	@email NVARCHAR(50),
	@fax NVARCHAR(50),
	@address NVARCHAR(80),
	@city NVARCHAR(50),
	@state NVARCHAR(50),
	@country NVARCHAR(50),
	@postal NVARCHAR(50),
	@TransferOption VARCHAR(8) = NULL, --pass value (not NULL) in case direct master add new agent
	@suspended BIT = NULL,

	@closed BIT = NULL,	
	@DisableOutright BIT = 0,
	@matchlimit SMALLMONEY,
	@virtualmultiplier SMALLMONEY,
	@DisableAutoMPT BIT = 1,
	@IsInternal BIT = 0,
	
	@autosuspend BIT = 0,
	@autosuspend2 BIT = 0,

	@DisableSuperLive BIT = 0,
	@maxcredit MONEY = 0,
	@isSearchAndCopy BIT = 0,
	@copyFromCustID INT = 0,
	
	@IP VARCHAR(15)='',
	@TransferOption_dec TINYINT,
	@SystemID	TINYINT=1,
	@Language VARCHAR(2)= 'E',
	@ErrCode INT = 0 OUTPUT,
	@ErrMsg NVARCHAR(4000) = '' OUTPUT,
	@SubsidiaryID INT = 0, 
	@BonusWalletFlag BIT = 0,
	@ErrExtraInfo VARCHAR(MAX) = '' OUTPUT -- Log DB
AS

/*
	Created: 20181010@Kean
	Task :	Insert general customer's Informatioin for supporting reactivation old deposit member
			Table related: customer, custinfo and CustVirtualSetting
	DB: DBCUST/CustDB
	Original: Reuse Acc_CustomerInsUserInfo SP and edit

	Revisions:    
		- 20181010@Dominic: First commit
		- 20181228@Dominic: Insert data into table Customer by using Dep_Customer_Archive_InsCustomer_WithCustID
		- 20190909@Eden: 3rd party products - Remove InActive Products Phase 2 [Redmine: #118699]
		- 20220112@Eden: LAP - RNG Casino - Implement DCS Settings [Redmine: #166217] 
		- 20220301@Eden: Deposit - Sportsbook - Revise customer settings [Redmine: #167898] 
		- 20220907@Tacy: NAP - Set Dangerous Level of member following upline (Agent) [Redmine: #176518]
		- 20220913@Tacy: Customer Setting - Set Danger level (Saba Sports) for newly created members [RedmineID: #177464]
		- 20220930@Eden: Reactive - Enhance to prevent lacking settings [redmine: #178439]
		- 20221207@Tacy: Remove columns and code used by Colossus Bets, GD product [RedmineID: #188096]
		- 20240701@Winfred: Scale Out DBCUST - Apply In-house Replication for Virtual Rate Setting  [redmine: #207029]
		- 20240705@Eden  : Scale out DBCUST - Licensee Customer in GlobCustDB [redmine: #207474]
		- 20240920@Helios  : Scale out DBCUST - Licensee Customer in GlobCustDB - Modified BEGIN TRY - CATCH [redmine: #207474]

	Param's Explanation:
	- @ErrCode:
		= 0: Insert successfully.
		> 0: Specific Error.
  
	- @ErrMsg: Error description.
*/
BEGIN
    SET NOCOUNT ON 
	
	BEGIN TRY

		EXEC  Acc_CustomerIns 
			@custid=@custid,
			@firstname=@firstname,
			@lastname=@lastname,
			@creator=@creator,
			@username=@username,
			@userpwd=@userpwd,
			@pwdexpiry=@pwdexpiry,
			@currency=@currency,
			@site=@site,
			@ugroup=@ugroup,
			@createDate=@createDate,
			@birthday=@birthday,
			@refcode1=@refcode1,
			@remark=@remark,
			@refcode2=@refcode2,
			@username2=@username2,
			@srecommend=@srecommend,
			@mrecommend=@mrecommend,
			@recommend=@recommend,
			@roleid=@roleid,
			@phone=@phone,
			@mobilephone=@mobilephone,
			@email=@email,
			@fax=@fax,
			@address=@address,
			@city=@city,
			@state=@state,
			@country=@country,
			@postal=@postal,
			@ErrCode = @ErrCode OUTPUT,    
			@ErrMsg = @ErrMsg OUTPUT
	
	    IF @ErrCode <> 0
	    BEGIN
				SELECT   @ErrExtraInfo = @ErrMsg
						,@ErrMsg = CASE @Language 
							 WHEN 'E' THEN 'Create customer failed. Please try again.'
							 ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
						     END
						,@ErrCode = 111
    		
				RETURN
	    END
	END TRY

	BEGIN CATCH
				SELECT   @ErrExtraInfo = @ErrMsg
							,@ErrMsg = CASE @Language 
								 WHEN 'E' THEN 'Create customer failed. Please try again.'
								 ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
							     END
							,@ErrCode = 111
    		
				RETURN
	END CATCH
	
	BEGIN TRY
		DECLARE	@DangerLevel BIGINT = NULL	 
	
		INSERT INTO [dbo].[CustVirtualSetting] (custid, seqNo, bitmapVirtual,RepUpdateTime)
		SELECT @Custid, seqNo, bitmapVirtual, [dbo].[f_GetDateTime2]() as RepUpdateTime
		FROM CustVirtualSetting WITH(NOLOCK)
		WHERE custid = @recommend  
		
		IF NOT EXISTS (SELECT 1 FROM dbo.CustLoginInfo_Member WITH(NOLOCK) WHERE custid = @custid)
		BEGIN
			INSERT INTO CustLoginInfo_Member([CustID],[SecurityCode],[IP],[LastChangedID],[LastChangedDate])
			VALUES(@custid,NULL,@IP,@creator,GETDATE())
		END

		--Set DangerLevel
		SELECT	@DangerLevel=DangerLevel
		FROM dbo.f_Dep_CustSetting_DangerLevel(@site, @currency)
    
		INSERT INTO [dbo].[custinfo]
		(
			custid, currency
		  , roleid, srecommend, mrecommend, recommend, dangercust, autosuspend, autosuspend2, reject, credit, closed, username
		  , MatchLimit, VirtualMultiplier
		  , DisableOutright
		  , danger, danger2, danger3, Danger4, Danger5
		  , Abnormal	 
		  , DoubleCommLosing	
		  , DisableSuperLive
		  , DangerLevel
		  , BonusWalletFlag
		  )
		VALUES
		(
			@custid, @currency
		  , @roleid, @srecommend, @mrecommend, @recommend, 0, @autosuspend, @autosuspend2, ISNULL(@suspended, 0), 0, ISNULL(@closed, 0), @username
		  , @matchlimit, @virtualmultiplier
		  , @DisableOutright
		  , @danger, @danger2, @danger3, @Danger4, @Danger5
		  , @Abnormal
		  , 0
		  , @DisableSuperLive
		  , @DangerLevel
		  , @BonusWalletFlag
		)

		IF @SubsidiaryID<>0
		BEGIN
			IF EXISTS (SELECT 1 FROM dbo.DepositCustomer WITH (NOLOCK) WHERE custid=@CustID)
			BEGIN
				UPDATE dbo.DepositCustomer WITH (ROWLOCK, UPDLOCK)
				SET SubsidiaryID=@SubsidiaryID
				WHERE custid=@CustID
			END
			ELSE
			BEGIN
				INSERT INTO dbo.DepositCustomer (custid, SubsidiaryID)
				VALUES (@CustID, @SubsidiaryID)
			END
		END

	END TRY
    BEGIN CATCH
	    SELECT @ErrMsg = CASE @Language 
					       WHEN 'E' THEN 'Create customer failed. Please try again.'
					       ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
					     END
		     , @ErrCode = 112
			 , @ErrExtraInfo = ERROR_MESSAGE ()

		--SELECT ERROR_MESSAGE() ErrorMessage ,ERROR_LINE() AS ErrorLine

	    -- ROLLBACK MANUALLY
	    EXEC Acc_Dep_CustomerInsSetting_Rollback @CustID = @CustID, @RoleID = 1
		EXEC Acc_Dep_CustomerInsUserInfo_Rollback @CustID = @CustID
	    RETURN
    END	CATCH
END


GO

