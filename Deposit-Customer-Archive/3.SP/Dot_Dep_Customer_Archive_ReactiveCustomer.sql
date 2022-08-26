/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet,bodbDownlineNet,bodbExtAccNet,Dot_Member" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Dot_Dep_Customer_Archive_ReactiveCustomer]     
	@CustID int = 0,  
	@ReinitOldBalance BIT = 1,
	@CheckUniqueUsername2 BIT = 1,
	@SubsidiaryID INT = 0,
	@ErrCode int = 0 OUTPUT,    
	@ErrMsg nvarchar(2000) = '' OUTPUT     
AS       
/*    
	Created: 20181010@Kean    
	Task :  The reactivation of archived deposit member include customer info and settings  [Redmind: #99882]
	DB: DBCUST/CustDB    
	Original: Reuse first deposit SP [Dot_Dep_CustomerInsMember_Ag_Cust] and edit  
	    
	Revisions:    
		- 20181010@Kean: First commit
		- 20181119@Dominic: Check betsetting Esports [Redmine: 100721]
		- 20181227@Dominic: Check if dormant member is archived completely
		- 20190305@Dominic: Add @CheckUniqueUsername2
		- 20190909@Eden: 3rd party products - Remove InActive Products Phase 2 [Redmine: #118699]
		- 20210317@Eden: Licensee - Soccer Parlay Max Per Match is incorrect with reactivated customer [Redmine: #151846]
		- 20210319@Eden: Correct comm group - bettype = 20  [redmine: #151213]
		- 20220401@Eden: Hotfix- Licensees - Process deposit conflicts with process Reactivation of archived member causes wrong balance [redmine: #170791]
		- 20220517@Tacy: Add @SubsidiaryID to Insert into DepositCustomer [Redmine: #171861]
		- 20220301@Eden: Deposit - Sportsbook - Revise customer settings [Redmine: #167898] 

	Param's Explanation:    
	? @CustID: return old deposit member CustID    
	? @ReinitOldBalance: flag to reinit old balance   
	    
	? @ErrCode:    
	 = 0: Transaction recorded successfully.    
	 > 0: Specific Error.    
	     
	? @ErrMsg: Error description.    
*/ 
BEGIN
	SET NOCOUNT ON    
	    
	declare @startRun datetime    
	declare @endRun datetime    
	declare @duration int    
	set @startRun = getdate()    
	    
	declare @currency int,    
	 @recommend int,    
	 @mrecommend int,    
	 @srecommend int,     
	 @agusername varchar(30),    
	 @site varchar(30),    
	    
	 @pwdexpiry datetime,    
	 @ugroup varchar(5),
	    
	 @Aclosed bit,     
	 @Asuspended bit,      
	 @suspended bit = 0,    
	 @matchlimit smallmoney,    
	 @virtualmultiplier smallmoney    
	    
	--Init param    
	select @ErrCode = 0,    
	 @ErrMsg = '',    
	 @pwdexpiry = dateadd(dd, 30, getdate())  

	---------------------------------
	--20181011@Kean: Support for reactivation of member
	DECLARE @FirstName nvarchar(50),    
			@LastName nvarchar(50),    
			@Email nvarchar(50),    
			@username2 varchar(50),    
			@refcode2 nvarchar(50),    
			@Password varchar(40),
			@AgentID int,
			@Country nvarchar(50),
			@Username varchar(50) ='',
			@phone nvarchar(50),
			@mobilephone nvarchar(50),
			@fax nvarchar(50),
			@address nvarchar(50),
			@city nvarchar(50),   
			@state nvarchar(50),
			@postal nvarchar(50),
			@birthday smalldatetime,
			@refcode1	nvarchar(50),
			@remark nvarchar(50),
			@createDate smalldatetime,
			-- Use for reinit old balance
			@CustIDBalanceDummy INT,
			@ClosingBalance MONEY

	EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @CustID = @CustID
			, @Action='REACTIVATION'
			, @Status='OnProgress'
			, @Message= 'Start reactivating customer'

	SELECT @FirstName = firstname,
				@Lastname = lastname,
				@Username = username,
				@Password = userpwd,
				@pwdexpiry = pwdexpiry,
				@phone = phone,
				@mobilephone = mobilephone,
				@Email = email,
				@fax = fax,
				@address = address,
				@city = city,
				@state = state,
				@Country = country,
				@postal = postal,
				@birthday = birthday,
				@refcode1 = refcode1,
				@remark = remark,
				@createDate = creatdate,
				@username2 = username2,
				@refcode2 = refcode2,
				@AgentID = recommend
	 FROM DBARCCUST.Bodb_Archive_Customer_Licensee.dbo.Customer WITH(NOLOCK)
	 WHERE custid = @CustID

	--Check exist custid
	IF ISNULL(@Username,'') = ''      
	BEGIN    
		SELECT @ErrMsg = 'This account is not a dormant member.', @ErrCode = 7
		
		EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @CustID = @CustID
				, @Action='REACTIVATION'
				, @Status='Failed'
				, @Message= 'This member does not exist in Archive DB'

		RETURN    
	END 

	--Check if this member is archived completely
	IF NOT EXISTS(SELECT 1 FROM Dep_Customer_Archived (NOLOCK) WHERE CustID=@CustID AND Status='completed')
	BEGIN    
		SELECT @ErrMsg = 'This account is locked for Archive Process now. Please try again after few minutes.', @ErrCode = 8
		
		EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @CustID = @CustID
				, @Action='REACTIVATION'
				, @Status='Failed'
				, @Message= 'This member is not archived completely, can not be reactivated.'

		RETURN    
	END 

	--Check if this member is reactivated by someone else
	IF EXISTS (SELECT 1 FROM Customer (NOLOCK) WHERE CustID=@CustID)
	OR EXISTS (SELECT 1 FROM Custinfo (NOLOCK) WHERE CustID=@CustID)
	BEGIN
		SELECT @ErrMsg = 'This account has been reactivated by someone else.', @ErrCode = 9
		
		EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @CustID = @CustID
				, @Action='REACTIVATION'
				, @Status='Failed'
				, @Message= 'This member is existing in Main DB.'

		RETURN    
	END
	---------------------------------
	    
	select    
	 @srecommend = ci.srecommend,    
	 @mrecommend = ci.mrecommend,     
	 @recommend = ci.custID,    
	 @agusername = ci.username,    
	 @currency = ci.currency,     
	 ----- add more    
	 @site    = c.site,       
	 @Aclosed   = closed,    
	 @Asuspended   = reject,    
	 @matchlimit   = matchlimit,    
	 @virtualmultiplier = virtualmultiplier
	FROM custinfo ci WITH(NOLOCK)     
	 inner join customer c WITH(NOLOCK) ON ci.custid = c.custid    
	WHERE ci.CustID = @AgentID    
	 and ci.roleid = 2    
	     
	--check valid agent here    
	IF @recommend is null    
	BEGIN    
		SELECT @ErrMsg = 'Invalid agent.', @ErrCode = 10    
	 
		EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @CustID = @CustID
				, @Action='REACTIVATION'
				, @Status='Failed'
				, @Message= 'Agent of this member does not exist in custinfo in main DB'

		RETURN    
	END    
	    
	--20110426@Thien: rollback for DELA, set to group A again    
	SELECT @ugroup = 'a'    

	IF EXISTS (SELECT TOP 1 1 FROM Dep_DefaultOddGroup WITH(NOLOCK) WHERE AgentID=@AgentID AND IsActive=1)
		SELECT @ugroup = Ugroup FROM Dep_DefaultOddGroup WITH(NOLOCK) WHERE AgentID=@AgentID AND IsActive=1
	
	SELECT @ErrCode = 0, @ErrMsg = ''
	
	--> Check Betlimit SB + NG
	EXEC dbo.Acc_Dep_CustSetting_Game_Check    
		 @custid	= @custid,    
		 @AgentID	= @AgentID,    
		 @Site		= @Site,    
		 @Currency	= @Currency,    
		 @ProductID = NULL,    
		 @SuperID	= @srecommend,    
		 @ErrCode	= @ErrCode OUTPUT,    	   
		 @ErrMsg	= @ErrMsg OUTPUT  

	IF @ErrCode<>0
	BEGIN
		SELECT @ErrMsg = 'Check Customer''s Bet Limits: ' + @ErrMsg
		
		EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @CustID = @CustID
				, @Action='REACTIVATION'
				, @Status='Failed'
				, @Message= @ErrMsg
		RETURN
	END
	  
	--> Check Betlimit Other DCS Products
	EXEC dbo.Acc_Dep_CustSetting_Check    
	 @custid	= @custid,    
	 @AgentID	= @AgentID,    
	 @Site		= @Site,    
	 @Currency	= @Currency,    
	 @ProductID = NULL,    
	 @SuperID	= @srecommend,    
	 @ErrCode	= @ErrCode OUTPUT,    	   
	 @ErrMsg	= @ErrMsg OUTPUT

	IF @ErrCode<>0
	BEGIN
		SELECT @ErrMsg = 'Check Customer''s Bet Limits: ' + @ErrMsg
		
		EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @CustID = @CustID
				, @Action='REACTIVATION'
				, @Status='Failed'
				, @Message= @ErrMsg
		RETURN
	END
	    
	IF @Aclosed = 1    
	BEGIN    
		SELECT     
		@ErrMsg = 'Agent was closed. Cannot reactivate its member.',     
		@ErrCode=211    

		EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @CustID = @CustID
				, @Action='REACTIVATION'
				, @Status='Failed'
				, @Message= @ErrMsg

		RETURN    
	END    
	    
	--check suspended of Agent     
	if @Asuspended =1 
	BEGIN    
	 set @suspended =1    
	END    
	    
	--Check the unique username    
	if exists (select 1 from customer c with (NOLOCK)        
	   where @CheckUniqueUsername2=1  AND c.username2 = @username2
		)    
	 or exists (select 1 from customer with(NOLOCK) where username = @UserName)    
	 or exists (select 1 from custsub with(NOLOCK) where username = @UserName)    
	BEGIN    
		SELECT @ErrMsg = 'The username is not available.', @ErrCode = 11
		
		EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @CustID = @CustID
				, @Action='REACTIVATION'
				, @Status='Failed'
				, @Message= 'The username is already existing in customer'
				    
		RETURN    

	END    
	-----------------------------------------------    
	--reset the @site param    
	select @site=case when @ugroup like 'indo_' then 'INDO' else '' end,    
	 @ugroup = case when @ugroup like 'indo_' then right(@ugroup,1) else @ugroup end    
	
	IF EXISTS(SELECT 1 FROM customer (NOLOCK) WHERE custid = @CustID)
	BEGIN
		SELECT @ErrMsg = 'This member has been reactivated by someone else.'
		SELECT @ErrCode = 22

		EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @CustID = @CustID
				, @Action='REACTIVATION'
				, @Status='Failed'
				, @Message= @ErrMsg

		RETURN
	END   

	--Insert general data     
	EXEC dbo.Dot_Dep_Customer_Archive_InsertCustomerInfo    
	 @custid = @custid,    
	 @firstname = @firstname,    
	 @lastname = @lastname,    
	 @creator = @recommend,    
	 @username = @username,    
	 @userpwd = @Password,    
	 @pwdexpiry = @pwdexpiry,    
	 @currency = @currency,    
	 @site = @site,    
	 @ugroup = @ugroup,
	 @createDate = @createDate, --20181011@Kean: Support for reactivation of member
	 @birthday = @birthday,
	 @refcode1 = @refcode1,
	 @remark = @remark,
	 @refcode2 = @refcode2,
	 @username2 = @username2,    
	 @srecommend = @srecommend,    
	 @mrecommend = @mrecommend,    
	 @recommend = @recommend,    
	 @roleid = 1,    
	 @phone = @phone,    
	 @mobilephone = @mobilephone,    
	 @email = @Email,    
	 @fax = @fax,    
	 @address = @address,    
	 @city = @city,    
	 @state = @state,    
	 @country = @Country,    
	 @postal = @postal,
	 @TransferOption = null,    
	 @suspended = @suspended,    

	 @matchlimit = @matchlimit,    
	 @virtualmultiplier = @virtualmultiplier,    
       
	 @IP = '',    
	 @TransferOption_dec = null,    
	 @Language = 'E',    
	 @ErrCode = @ErrCode OUTPUT,    
	 @ErrMsg = @ErrMsg OUTPUT    
	
	IF @ErrCode <> 0 
	BEGIN   
		SELECT @ErrMsg = 'Failed to insert customer/custinfo: ' + @ErrMsg
		EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @CustID = @CustID
				, @Action='REACTIVATION'
				, @Status='Failed'
				, @Message= @ErrMsg
		
		RETURN  
	END  
	------------
	--Insert SubsidiaryID
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

		IF @@ERROR <> 0
		BEGIN
			 DELETE DepositCustomer	WITH(ROWLOCK,UPDLOCK) WHERE CustID = @CustID
			 EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
		END
	END

	------------------------------------------------------------------------    
	---- Create balance for new customer    
	--EXEC DBTXN.bodb02.dbo.Dot_BalanceInsCredit @CustID = @CustID  
	IF NOT EXISTS( SELECT TOP 1 1 FROM DBTXN.bodb02.dbo.BalCreditSports WITH(NOLOCK) WHERE custid = @CustID)
	BEGIN
		EXEC DBTXN.bodb02.dbo.Dot_BalanceCreditInitialize @CustID = @CustID, @errCode = @ErrCode OUTPUT
	 
	    
		IF @ErrCode <> 0    
		BEGIN     
		 --Error occurs    
		 SELECT     
		  @ErrMsg = 'Add member fail. Please try again',    
		  @ErrCode=215    
	     
		 -- MANUALLY ROLLBACK    
		 EXEC DBTXN.bodb02.dbo.Dot_BalanceCreditRemove @CustID = @CustID
		 EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID  
		 DELETE DepositCustomer	WITH(ROWLOCK,UPDLOCK) WHERE CustID = @CustID
	 
		 EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @CustID = @CustID
					, @Action='REACTIVATION'
					, @Status='Failed'
					, @Message= 'Failed to insert credit balance tables'
				  
		 RETURN    
		END 
	END   
	   
	IF NOT EXISTS( SELECT TOP 1 1 FROM DBTXN.bodb02.dbo.BalDebitSports WITH(NOLOCK) WHERE custid = @CustID)
	BEGIN 
		EXEC DBTXN.bodb02.dbo.Dot_BalanceDebitInitialize @CustID = @CustID, @errCode = @ErrCode OUTPUT    
	    
		IF @ErrCode <> 0    
		BEGIN     
		 --Error occurs    
		 SELECT     
		  @ErrMsg = 'Add member fail. Please try again',    
		  @ErrCode=215    
	     
		 -- MANUALLY ROLLBACK      
		 EXEC DBTXN.bodb02.dbo.Dot_BalanceCreditRemove @CustID = @CustID 
		 EXEC DBTXN.bodb02.dbo.Dot_BalanceDebitRemove @CustID = @CustID
		 EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID  
		 DELETE DepositCustomer	WITH(ROWLOCK,UPDLOCK) WHERE CustID = @CustID

		 EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @CustID = @CustID
					, @Action='REACTIVATION'
					, @Status='Failed'
					, @Message= 'Failed to insert debit balance tables'

		 RETURN    
		END
	END

	/*HELEN-CUSTOMER SETTING DCS DEPOSIT-START*/
	DECLARE @DCSErrCode INT = 0
	EXEC dbo.Acc_Dep_DynamicCustSetting_00
			@CustID				= @CustID
			, @SuperID			= @srecommend
			, @MasterID			= @mrecommend
			, @AgentID			= @recommend
			, @RoleID			= 1
			, @ProductID		= NULL
			, @ErrCode			= @DCSErrCode OUTPUT
				
	IF @DCSErrCode <> 0 
	BEGIN
		 --Error occur
		 SET @ErrCode = 911
		 -- ROLLBACK MANUALLY    
		 EXEC DBTXN.bodb02.dbo.Dot_BalanceCreditRemove @CustID = @CustID 
		 EXEC DBTXN.bodb02.dbo.Dot_BalanceDebitRemove @CustID = @CustID   
		 EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID   
		 DELETE DepositCustomer	WITH(ROWLOCK,UPDLOCK) WHERE CustID = @CustID

		 EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @CustID = @CustID
				, @Action='REACTIVATION'
				, @Status='Failed'
				, @Message= 'Acc_Dep_DynamicCustSetting_00 is failed'
				 
		 RETURN    
	END
	/*HELEN-CUSTOMER SETTING RENOVATION-END*/

	--20181011@Kean: Support for reactivation of deposit member, reinit old balance
	 IF @ReinitOldBalance = 1
	 BEGIN
		SELECT TOP 1 @CustIDBalanceDummy = CustIDBalanceDummy
				   , @ClosingBalance = ClosingBalance
		FROM dbo.Dep_Customer_Archived WITH(NOLOCK)
		WHERE Status = 'completed' AND CustID = @CustID

		IF @ClosingBalance <> 0
		BEGIN
			IF @ClosingBalance > 0
			BEGIN
				EXEC DBTXN.bodb02.dbo.Dot_Int_BettransInsTransactionWithoutLog_Cust
						@custid=@CustID,
						@amount= @ClosingBalance,
						@bal_custid=@CustIDBalanceDummy,
						@Bettype = 23203,
						@transdesc = 'Reinit old member balance in deposit reactivation process',
						@ErrCode= @ErrCode OUTPUT,
						@ErrMsg= @ErrMsg OUTPUT
			END
			ELSE
			BEGIN
				EXEC DBTXN.bodb02.dbo.Dot_Int_BettransInsTransactionWithoutLog_Cust
						@custid=@CustID,
						@amount= @ClosingBalance,
						@bal_custid=@CustIDBalanceDummy,
						@Bettype = 23203,
						@transdesc = 'Reinit old member balance in deposit reactivation process',
						@IsCharge = 1, --Not check negative balance
						@ErrCode= @ErrCode OUTPUT,
						@ErrMsg= @ErrMsg OUTPUT
			END

			IF @ErrCode <> 0 
			 BEGIN
				 --Error occur
				 SELECT 
				 @ErrMsg = 'Failed to transfer closing balance: ' + @ErrMsg ,    
				 @ErrCode=215  
				 -- MANUALLY ROLLBACK
				 DELETE FROM Dep_CustPTSetting_Member WITH(ROWLOCK,UPDLOCK) WHERE CustID = @CustID
				 DELETE FROM Dep_CustSettingMode WITH(ROWLOCK,UPDLOCK) WHERE CustID = @CustID
				 DELETE FROM Dep_CustStakeLevel_member WITH(ROWLOCK,UPDLOCK) WHERE CustID = @CustID
				 DELETE FROM Dep_CustBetSetting_Member WITH(ROWLOCK,UPDLOCK) WHERE CustID = @CustID
				 DELETE FROM Dep_CustProductStatus WITH(ROWLOCK,UPDLOCK) WHERE CustID = @CustID
				 DELETE FROM Dep_CustBetSettingGame_Member WITH(ROWLOCK,UPDLOCK) WHERE CustID = @CustID
				 DELETE DepositCustomer	WITH(ROWLOCK,UPDLOCK) WHERE CustID = @CustID
		      
				 EXEC DBTXN.bodb02.dbo.Dot_BalanceCreditRemove @CustID = @CustID --EXEC DBTXN.bodb02.dbo.Dot_BalanceDelCredit @CustID = @CustID
				 EXEC DBTXN.bodb02.dbo.Dot_BalanceDebitRemove @CustID = @CustID --EXEC DBTXN.bodb02.dbo.Dot_BalanceDelDebit @CustID = @CustID    
				 EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID    

				 EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @CustID = @CustID
				, @Action='REACTIVATION'
				, @Status='Failed'
				, @Message= @ErrMsg

				 RETURN    
			 END
		END
	 END 
	---------------------------------------------------------------------------------    
	--Bonus
	UPDATE custInfo WITH (ROWLOCK, UPDLOCK) 
	SET BonusWalletFlag=0
	WHERE custID = @custID  
	    
	select @site = site from customer (NOLOCK)    
	WHERE CustID = @AgentID 
	   
	--For Dela, turn member to BA    
	if @site = 'DELA'    
	BEGIN    
	 SET @ErrMsg=''    
	 SET @ErrCode=0    
	     
		IF (SELECT EnableBA FROM bodb_licensee.dbo.LicenseeBAConfig WITH (NOLOCK) WHERE LicenseeID = 7) = 1    
		BEGIN    
			EXEC [Lrf_CustomerUpdMemberBAStatus]    
			@LicenseeID=7,--Dela    
			@CustID = @CustID,    
			@ModifyBy = 1, --dbaThien    
			@IsBA = 1,    
			@IP = '',    
			@ErrCode = @ErrCode OUTPUT,    
			@ErrMsg = @ErrMsg OUTPUT    
		END    
	END    
	--For Asiabet88, turn USD&EUR players   to BA : 20131230@Jim    
	    
	IF (@site = 'Asiabet88')    
	BEGIN    
		IF EXISTS (SELECT 1 FROM dbo.Customer WITH (NOLOCK) WHERE CustID=@CustID AND Currency IN (3,6))    
		BEGIN     
			SET @ErrMsg=''    
			SET @ErrCode=0    
	      
			IF (SELECT EnableBA FROM bodb_licensee.dbo.LicenseeBAConfig WITH (NOLOCK) WHERE LicenseeID = 2) = 1    
			BEGIN    
				EXEC [Lrf_CustomerUpdMemberBAStatus]    
					@LicenseeID=2,--Asiabet88    
					@CustID = @CustID,    
					@ModifyBy = 3, --pgmviet    
					@IsBA = 1,    
					@IP = '',    
					@ErrCode = @ErrCode OUTPUT,    
					@ErrMsg = @ErrMsg OUTPUT    
			END    
		END    
	END
	         
	--Set default player comm    
	EXEC bodb_Licensee.dbo.Lrf_CustomerSetDefaultComm    
	 @LicenseeName=@site,    
	 @CustID = @CustID,    
	 @ErrCode = @ErrCode OUTPUT,    
	 @ErrMsg = @ErrMsg OUTPUT     
	    
	--Set default bet setting of AG Casino    
	EXEC Lrf_AGC_Customer_SetDefaultSetting      
	 @CustID = @CustID,    
	 @SuperID = @recommend,      
	 @ErrCode = @ErrCode OUTPUT,      
	 @ErrMsg = @ErrMsg OUTPUT    
	    
	--Set default bet setting of 3rd Product    
	EXEC dbo.Lrf_3rdProductCustomerSetDefaultSetting      
	 @CustID = @CustID,    
	 @SuperID = @srecommend,      
	 @ErrCode = @ErrCode OUTPUT,      
	 @ErrMsg = @ErrMsg OUTPUT    
 
	 --Update Dep_Customer_Archived.status = reactivation
	EXEC dbo.Acc_CustomerInfo_Execrep_10 @CustID=@CustID, @ActionID=4    

	EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @CustID = @CustID
			, @Action='REACTIVATION'
			, @Status='Done'
			, @Message= 'Finish reactivating customer'

	set @endRun = getdate()    
	set @duration  = datediff (millisecond,@startRun,@endRun)    
	    
	Declare @LogSPData nvarchar(4000)    
	DECLARE @MinBet MONEY,@MaxBet MONEY,@MaxPerMatch MONEY,@MaxPayoutPermatch MONEY -- Bet setting of representative sport type = 1 , bettype = 1
	DECLARE @Discount DECIMAL(9,8) = 0 -- Commission of representative sport type = 1 , bettype = 1
	DECLARE @PT smallmoney -- Position taking of representative sport type = 1 , bettype = 1

	--PT
	IF EXISTS(SELECT 1 FROM Dep_CustSettingMode WITH(NOLOCK) WHERE custid = @CustID AND IsGroupedPT = 1)
	BEGIN
		SELECT @PT = AgentPT/100 FROM Dep_CustPTGroupSetting_Member WITH(NOLOCK) WHERE AgentID = @AgentID AND SportType = 1 AND BetType = 1
	END
	ELSE
	BEGIN
		SELECT @PT = AgentPT/100 FROM Dep_CustPTSetting_Member WITH(NOLOCK) WHERE CustID = @CustID AND SportType = 1 AND BetType = 1
	END

	--Comm
	IF EXISTS(SELECT 1 FROM Dep_CustSettingMode WITH(NOLOCK) WHERE custid = @CustID AND IsGroupedComm = 1)
	BEGIN
		SELECT @Discount = AgentDiscount FROM Dep_CustDiscountGroupSetting_Member WITH(NOLOCK) WHERE AgentID = @AgentID AND SportType = 1 AND BetType = 1
	END
	ELSE
	BEGIN
		SELECT @Discount = AgentDiscount FROM Dep_CustDiscountSetting_Member WITH(NOLOCK) WHERE CustID = @CustID AND SportType = 1 AND BetType = 1
	END

	--Bet Setting
	IF EXISTS(SELECT 1 FROM Dep_CustSettingMode WITH(NOLOCK) WHERE custid = @CustID AND IsGroupedBetLimit = 1)
	BEGIN
		SELECT @MinBet = MinBet, @MaxBet= MaxBet, @MaxPerMatch = MaxPerMatch, @MaxPayoutPermatch = MaxPayoutPerMatch 
		FROM Dep_CustBetSettingGameGroup_Member WITH(NOLOCK) WHERE AgentID = @AgentID AND SportType = 1 AND BetType = 1
	END
	ELSE
	BEGIN
		SELECT @MinBet = MinBet, @MaxBet= MaxBet, @MaxPerMatch = MaxPerMatch, @MaxPayoutPermatch = MaxPayoutPerMatch 
		FROM Dep_CustBetSettingGame_Member WITH(NOLOCK) WHERE CustID = @CustID AND SportType = 1 AND BetType = 1
	END
	    
	Select @LogSPData = '<Dot_Dep_Customer_Archive_ReactiveCustomer custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +    
	'fname="'+ dbo.f_EncodeXMLValue(coalesce(cast(@firstname as nvarchar(50)),space(1))) + '" ' +    
	'lname="'+ dbo.f_EncodeXMLValue(coalesce(cast(@lastname as nvarchar(50)),space(1))) + '" ' +    
	'creator="'+ coalesce(cast(@CustID as varchar(50)),space(1)) + '" ' +    
	'username="'+ coalesce(cast(@username as varchar(30)),space(1)) + '" ' +    
	'Email="'+ dbo.f_EncodeXMLValue(coalesce(cast(@Email as nvarchar(50)),space(1))) + '" ' +  
	'SubsidiaryID="'+ coalesce(cast(@SubsidiaryID as varchar(50)),space(1)) + '" ' +
	'AgentID="'+ coalesce(cast(@AgentID as varchar(50)),space(1)) + '" ' +   
	'recommend="'+ coalesce(cast(@recommend as varchar(50)),space(1)) + '" ' +    
	'ugroup="'+ coalesce(cast(@ugroup as varchar(5)),space(1)) + '" ' +
	'discount="'+ coalesce(cast(@discount as varchar(50)),space(1)) + '" ' +		 -- Write commission log
	'MinBet="'+ coalesce(cast(@MinBet as varchar(50)),space(1)) + '" ' +			 -- Write betsetting log 
	'MaxBet="'+ coalesce(cast(@MaxBet as varchar(50)),space(1)) + '" ' +    
	'MaxPerMatch="'+ coalesce(cast(@MaxPerMatch as varchar(50)),space(1)) + '" ' + 
	'MaxPayoutPermatch="'+ coalesce(cast(@MaxPayoutPermatch as varchar(50)),space(1)) + '" ' + 
	'AgentPT="'+ coalesce(dbo.f_FomatNumericToChar(@PT),space(1)) + '" ' + -- Write PT log
	'suspended="'+ coalesce(cast(@suspended as varchar(50)),space(1)) + '" ' +       -- Write Statuses log
	'ErrCode="'+ coalesce(cast(@ErrCode as varchar(50)),space(1)) + '" ' +    
	'ErrMsg="'+ coalesce(cast(@ErrMsg as varchar(4000)),space(1)) + '" />'    
	BEGIN TRY    
	 EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP    
	  @UserID = @CustID,    
	  @CustID = @CustID,    
	  @ActionID = 1505,    
	  @TrackingValue = @LogSPData,    
	  @duration = @duration    
	END TRY    
	BEGIN CATCH    
	 EXEC bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP    
	  @UserID = @CustID,    
	    
	  @CustID = @CustID,    
	  @ActionID = 1505,    
	  @TrackingValue = @LogSPData,    
	  @duration = @duration    
	END CATCH
END
GO 

