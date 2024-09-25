/*<info serverAlias="DBCUST-CUSTDB" executers="svc_tig" viewers="" isFunction="0" isNested="1"></info>*/
ALTER PROCEDURE [dbo].[Dot_Dep_CustomerInsMember_Ag_Cust_Main]     
	@FirstName NVARCHAR(50),    
	@LastName NVARCHAR(50),    
	@Email NVARCHAR(50),    
	@DepositUserName VARCHAR(50),    
	@DepositUserID INT,    
	@Password VARCHAR(40),    
	@OddsType VARCHAR(5),      
	@AgentID INT,    
	@AffiliateID INT = NULL,    
	@BonusCode VARCHAR(20) = NULL,    
	@Country NVARCHAR(50) = '',
	@SubsidiaryID INT = 0,
	@CustID INT = 0 OUTPUT,    
	@Username VARCHAR(50) ='' OUTPUT,    
	@ErrCode INT = 0 OUTPUT,    
	@ErrMsg NVARCHAR(2000) = '' OUTPUT     
AS   
/*    
	Created: 20200907@Eden 
	Task : Clone from Dot_Dep_CustomerInsMember_Ag
	DB: DBCUST/CustDB    
	Original:    
	User: NON API Licensee/API Licensee/12Bet    
	    
	Revisions:    
	 - 20200907@Eden: Minimize UM Time - 1st Deposit [Redmine: #136741]
	 - 20201005@Winfred: Add new OddsAdj dummy customers [redmine:#142952] 
	 - 20201214@Winfred: Adjust PT value with 4 decimal places for SB  [redmine: #146574]
	 - 20210319@Eden: Correct comm group - bettype = 20  [redmine: #151213]
	 - 20220505@Tacy: Add @SubsidiaryID to Insert into DepositCustomer [Redmine: #171861]
	 - 20220301@Eden: Deposit - Sportsbook - Revise customer settings [Redmine: #167898] 
	 - 20220722@Eden: LAP - Scale Out DBTrans  [redmine: #158293/#175297]
	 - 20240404@Tacy: Return - Error when add Subsidiary [Redmine: #202273] 
	 - 20240710@Johnson: Apply In-house Replication for Customer Setting [redmine:#207025]	
	 - 20240911@Tacy: OddsBoostAdj dummy customers [redmine:#210621]
	Param's Explanation:    
	? @CustID: return new 12bet Player Cust ID    
	? @Username: return new 12bet Player User name    
	    
	? @ErrCode:    
	 = 0: Transaction recorded successfully.    
	 > 0: Specific Error.    
	     
	? @ErrMsg: Error description.    
*/ 
BEGIN
	SET NOCOUNT ON    
	    
	DECLARE @startRun DATETIME, @endRun DATETIME, @duration int    
	SET @startRun = getdate()       
	    
	---------------------------------    
	--20100922@Thien:   1st phrase - Get rid of members' information for Licensee site (first name, last name, email).    
	--                  Will remove these params once Brian's side removes the calling from Web code.    
	SELECT  @FirstName = '',    
			@LastName = '',    
			@Email = ''    
	---------------------------------    
	    
	DECLARE	 @currency INT,    
			 @recommend INT,    
			 @mrecommend INT,    
			 @srecommend INT,     
			 @agusername VARCHAR(30),    
			 @site VARCHAR(30),    
			 @pwdexpiry DATETIME,    
			 @ugroup VARCHAR(5)
	    
	DECLARE	 @Aclosed bit,    
			 @Asuspended bit,           
			 @suspended BIT = 0,    
			 @matchlimit SMALLMONEY,    
			 @virtualmultiplier SMALLMONEY    
	    
	--Init param    
	SELECT @ErrCode = 0, @ErrMsg = '', @pwdexpiry = dateadd(dd, 30, getdate())  
	    
	----------------Affiliate Bonus Code---------------------    
	IF (ISNULL(@AffiliateID, 0) = 0 AND @BonusCode is not null)     
	BEGIN     
		 SELECT @AffiliateID = AffID FROM DBAFF12BET.[Affiliate_12Bet].dbo.AffDetail WITH(NOLOCK) WHERE bonuscode = @BonusCode     
		 IF ISNULL(@AffiliateID,0) > 0 -- @bonuscode is valid, change currency agent from [..]01 --> [..]02    
		 BEGIN    
			DECLARE @_currAgentName VARCHAR(20)    
			SELECT @_currAgentName =username FROM Custinfo WITH(NOLOCK) WHERE custid=@AgentID         
			SELECT @AgentID = CustID FROM CustInfo WITH(NOLOCK) WHERE username = Replace(@_currAgentName, '01', '02')     
		 END     
	END    
	-------------------------------------------------------    
	SELECT    
		 @srecommend = ci.srecommend,    
		 @mrecommend = ci.mrecommend,     
		 @recommend = ci.custID,    
		 @agusername = ci.username,    
		 @currency = ci.currency,        
		 @site    = c.site,    
		 @Aclosed   = closed,    
		 @Asuspended   = reject,    
		 @matchlimit   = matchlimit,    
		 @virtualmultiplier = virtualmultiplier
	FROM custinfo ci WITH(NOLOCK)     
		INNER JOIN customer c WITH(NOLOCK) ON ci.custid = c.custid    
	WHERE ci.CustID = @AgentID AND ci.roleid = 2    
	     
	--check valid agent here    
	if @recommend IS NULL    
	BEGIN    
		SELECT @ErrMsg = 'Invalid agent.', @ErrCode = 10    
		RETURN    
	END      
	    
	--20110426@Thien: rollback for DELA, set to group A again    
	SELECT @ugroup = 'a'    

	IF EXISTS (SELECT TOP 1 1 FROM Dep_DefaultOddGroup WITH(NOLOCK) WHERE AgentID=@AgentID AND IsActive=1)
		SELECT @ugroup = Ugroup FROM Dep_DefaultOddGroup WITH(NOLOCK) WHERE AgentID=@AgentID AND IsActive=1
	    
	--Position Taking get from Affilate Account    
	IF ISNULL(@AffiliateID,0) > 0    
	BEGIN    
		IF NOT exists(select 1 from DBAFF12BET.[Affiliate_12Bet].dbo.AffInfo with(nolock) where AffID = @AffiliateID)      
		BEGIN    
			Select @ErrMsg = 'Invalid Affiliate agent.', @ErrCode = 12    
			RETURN    
		END     
	END        
	     
	SELECT @ErrCode = 0 , @ErrMsg = ''   	   	  

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
		RETURN
		 
	SELECT @ErrCode = 0 , @ErrMsg = ''   	   	  

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
		RETURN
	    
	select @pwdexpiry = dateadd(dd, 30, getdate())    
	    
	if @Aclosed = 1    
	BEGIN    
	 SELECT     
	  @ErrMsg = 'Your account was closed. Cannot add member.',     
	  @ErrCode=211    
	 return    
	END    
	    
	--check suspended of Agent     
	if @Asuspended = 1   
	BEGIN    
		SET @suspended =1    
	END    
	    	
	--20140812: Change rule generate username    
	IF (@UserName NOT LIKE '%BetTrade%' AND  @UserName NOT LIKE '%CashOut%' AND  @UserName NOT LIKE '%ClearBal%' 
		AND  @UserName NOT LIKE '%01OddsAdj%' AND  @UserName NOT LIKE '%01OddsBoostAdj%') 
		OR @UserName IS NULL
	BEGIN  
	SELECT @UserName = dbo.f_LAS_GenerateUsername(@recommend)    
	IF @UserName = ''    
	BEGIN    
	 SELECT @ErrMsg = 'Can not generate username.'    
	  ,@ErrCode = 11    
	    
	 RETURN    
	END    
	END  
	--20080623: Add sitename prefix to the DepositUsername    
	SELECT @DepositUserName = @site + '$' + @DepositUserName    
	     
	DECLARE @IsExistsUsername BIT
	EXEC Acc_Dep_CustomerCheckExists @username = @DepositUserName, @IsExists = @IsExistsUsername OUTPUT

	--Check the unique username2
	IF @IsExistsUsername = 1
	BEGIN    
		SELECT @ErrMsg = 'The username is not available.', @ErrCode = 11    
		RETURN    
	END    
	-----------------------------------------------    
	--reset the @site param    
	select @site=case when @ugroup like 'indo_' then 'INDO' else '' end,    
	 @ugroup = case when @ugroup like 'indo_' then right(@ugroup,1) else @ugroup end    
	    
	--Insert general data     
	EXEC dbo.Dot_Dep_CustomerInsUserInfo
		@custid = @custid OUTPUT,    
		@firstname = @firstname,    
		@lastname = @lastname,    
		@creator = @recommend,    
		@username = @username,    
		@userpwd = @Password,    
		@pwdexpiry = @pwdexpiry,    
		@currency = @currency,    
		@site = @site,    
		@ugroup = @ugroup,    
		@srecommend = @srecommend,    
		@mrecommend = @mrecommend,    
		@recommend = @recommend,    
		@roleid = 1, 
		@country = @Country,    
		@suspended = @suspended,    
		@matchlimit = @matchlimit,    
		@virtualmultiplier = @virtualmultiplier,    	  	 
		@IP = '',    
		@Language = 'E',    
		@ErrCode = @ErrCode OUTPUT,    
		@ErrMsg = @ErrMsg OUTPUT    

	IF @ErrCode <> 0    
		RETURN    

	--Insert SubsidiaryID
	IF @SubsidiaryID<>0
	BEGIN
		INSERT INTO dbo.DepositCustomer (custid, SubsidiaryID)
		VALUES (@CustID, @SubsidiaryID)
	END
	
	IF @@ERROR <> 0
	BEGIN
		 DELETE DepositCustomer	WITH(ROWLOCK,UPDLOCK) WHERE CustID = @CustID
		 EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID

		 RETURN
	END

	---------------------------------------------------------------------------------    
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
		 EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID  
		 EXEC Acc_Dep_CustomerInsSetting_Rollback @CustID = @CustID, @RoleID = 1
		 RETURN    
	END
	/*HELEN-CUSTOMER SETTING RENOVATION-END*/    
	    
	---------------------------------------------------------------------------------    
	UPDATE customer WITH (ROWLOCK, UPDLOCK) 
	SET  username2 = @DepositUserName,    
		 refcode2 = @DepositUserID    
	WHERE custID = @custID    
	--Bonus
	UPDATE custInfo WITH (ROWLOCK, UPDLOCK) 
	SET BonusWalletFlag=0
	WHERE custID = @custID  
	    
	SELECT @site = site FROM customer (NOLOCK) WHERE CustID = @AgentID  
	  
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
	    
	IF @AffiliateID is not NULL    
	EXEC DBAFF12BET.Affiliate_12BET.dbo.Aff_CustomerInsMember     
	 @IbcCustID = @CustID,    
	 @AffID = @AffiliateID,    
	 @Username = @DepositUserName,    
	 @IBCUsername = @Username,     
	 @DepositCustID = @DepositUserID,    
	 @FirstName = @FirstName,    
	 @LastName = @LastName,    
	 @Currency = @currency,    
	 @Recommend = @recommend,    
	 @Email = @Email    
	    
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
	    
	set @endRun = getdate()    
	set @duration  = datediff (millisecond,@startRun,@endRun)    
	    
	Declare @LogSPData nvarchar(4000)    
	    
	Select @LogSPData = '<Dot_Dep_CustomerInsMember_Ag_Cust custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +    
	'fname="'+ dbo.f_EncodeXMLValue(coalesce(cast(@firstname as nvarchar(50)),space(1))) + '" ' +    
	'lname="'+ dbo.f_EncodeXMLValue(coalesce(cast(@lastname as nvarchar(50)),space(1))) + '" ' +    
	'creator="'+ coalesce(cast(@CustID as varchar(50)),space(1)) + '" ' +    
	'username="'+ coalesce(cast(@username as varchar(30)),space(1)) + '" ' +    
	'Email="'+ dbo.f_EncodeXMLValue(coalesce(cast(@Email as nvarchar(50)),space(1))) + '" ' +    
	'DepositUserName="'+ coalesce(cast(@DepositUserName as varchar(50)),space(1)) + '" ' +    
	'DepositUserID="'+ coalesce(cast(@DepositUserID as varchar(50)),space(1)) + '" ' +    
	'OddsType="'+ coalesce(cast(@OddsType as varchar(5)),space(1)) + '" ' +   
	'SubsidiaryID="'+ coalesce(cast(@SubsidiaryID as varchar(50)),space(1)) + '" ' +
	'AgentID="'+ coalesce(cast(@AgentID as varchar(50)),space(1)) + '" ' +    
	'AffiliateID="'+ coalesce(cast(@AffiliateID as varchar(50)),space(1)) + '" ' +    
	'BonusCode="'+ coalesce(cast(@BonusCode as varchar(20)),space(1)) + '" ' +    
	'recommend="'+ coalesce(cast(@recommend as varchar(50)),space(1)) + '" ' +    
	'ugroup="'+ coalesce(cast(@ugroup as varchar(5)),space(1)) + '" ' + 
	'ErrCode="'+ coalesce(cast(@ErrCode as varchar(50)),space(1)) + '" ' +    
	'ErrMsg="'+ coalesce(cast(@ErrMsg as varchar(4000)),space(1)) + '" />'    
	 
	EXEC dbo.Acc_WriteLog_UserLog_RunSP_Wrapper    
	  @UserID = @CustID,    
	  @CustID = @CustID,    
	  @ActionID = 617,    
	  @TrackingValue = @LogSPData,    
	  @duration = @duration    	

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
	   
	--Write commission log    
	Select @LogSPData = '<Dot_Dep_CustomerInsMember_Ag_Cust custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +    
	'discount="'+ coalesce(cast(@Discount as varchar(50)),space(1)) + '" />'    
	EXEC dbo.Acc_WriteLog_UserLog_RunSP_Wrapper    
	  @UserID = @CustID,    
	  @CustID = @CustID,    
	  @ActionID = 216,    
	  @TrackingValue = @LogSPData,    
	  @duration = @duration    	
	     
	--Write betsetting log    
	Select @LogSPData = '<Dot_Dep_CustomerInsMember_Ag_Cust custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +    
	'MinBet="'+ coalesce(cast(@MinBet as varchar(50)),space(1)) + '" ' +    
	'MaxBet="'+ coalesce(cast(@MaxBet as varchar(50)),space(1)) + '" ' +    
	'MaxPerMatch="'+ coalesce(cast(@MaxPerMatch as varchar(50)),space(1))+ '" ' + 
	'MaxPayoutPerMatch="'+ coalesce(cast(@MaxPayoutPermatch as varchar(50)),space(1)) + '" />'    
	   
	EXEC dbo.Acc_WriteLog_UserLog_RunSP_Wrapper     
	  @UserID = @CustID,    
	  @CustID = @CustID,    
	  @ActionID = 315,    
	  @TrackingValue = @LogSPData,    
	  @duration = @duration    	
	     
	--Write PT log    
	Select @LogSPData = '<Dot_Dep_CustomerInsMember_Ag_Cust custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +    
	'AgentPT="'+ coalesce(dbo.f_FomatNumericToChar(@PT),space(1)) + '" />'    
	
	EXEC dbo.Acc_WriteLog_UserLog_RunSP_Wrapper     
	  @UserID = @CustID,    
	  @CustID = @CustID,    
	  @ActionID = 422,    
	  @TrackingValue = @LogSPData,    
	  @duration = @duration    

	--Write Statuses log     
	Select @LogSPData = '<Dot_Dep_CustomerInsMember_Ag_Cust custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +    
	'suspended="'+ coalesce(cast(@suspended as varchar(50)),space(1)) + '" />'    

	EXEC dbo.Acc_WriteLog_UserLog_RunSP_Wrapper      
	  @UserID = @CustID,    
	  @CustID = @CustID,    
	  @ActionID = 1118,    
	  @TrackingValue = @LogSPData,    
	  @duration = @duration    	
END

GO 

