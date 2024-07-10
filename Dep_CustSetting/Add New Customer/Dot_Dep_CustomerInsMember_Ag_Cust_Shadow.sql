/*<info serverAlias="DBCUST-CUSTDB" executers="svc_tig" viewers="" isFunction="0" isNested="0"></info>*/
ALTER PROCEDURE [dbo].[Dot_Dep_CustomerInsMember_Ag_Cust_Shadow]     
	@CustID INT = 0 OUTPUT,    
	@Username VARCHAR(50) ='' OUTPUT,  
	@RealCustID INT,    
	@AgentID INT,    
	@ErrCode INT = 0 OUTPUT,    
	@ErrMsg NVARCHAR(2000) = '' OUTPUT     
AS   
/*    
	Created: 20240404@Tacy 
	Task : Create new shadow account 
	DB: DBCUST/CustDB    
	Refer: Dot_Dep_CustomerInsMember_Ag_Cust_Main
	    
	Revisions:    
		 - 20240404@Tacy: Deposit - Integrate Saba Coin Wallet [Redmine: #202273] 
		 - 20240604@Tacy: Change format Username [Redmine: #202273] 
		 - 20240710@Johnson: Apply In-house Replication for Customer Setting [redmine:#207025]
	Param's Explanation:    
		* For TEST: Real Currency --> create shadow SBC
					UUS Currency  --> create shadow YNG

		? @CustID: return new Cust ID    
		? @Username: return new User name    
	    
		? @ErrCode:    
		 = 0: Transaction recorded successfully.    
		 > 0: specific Error.    
	     
		? @ErrMsg: Error description.    
*/ 
BEGIN
	SET NOCOUNT ON;    
	    
	DECLARE @startRun DATETIME, @endRun DATETIME, @duration INT    
	SET @startRun = getdate()       

	---------------------------------    
	DECLARE @FirstName NVARCHAR(50),    
			@LastName NVARCHAR(50),    
			@Email NVARCHAR(50),
			@Country NVARCHAR(50)

	SELECT  @FirstName = '',    
			@LastName = '',    
			@Email = '',
			@Country=''
	---------------------------------    
	    
	DECLARE	 @currency INT,
			 @CustCurrency INT,	--currency's real cust
			 @recommend INT,    
			 @mrecommend INT,    
			 @srecommend INT,     
			 @site VARCHAR(30), 
			 @Password VARCHAR(40),
			 @pwdexpiry DATETIME,
			 @recommendUsername VARCHAR(30)
	    
	DECLARE	 @Aclosed bit,    
			 @Asuspended bit,           
			 @matchlimit SMALLMONEY,    
			 @virtualmultiplier SMALLMONEY  
	    
	--Init param    
	SELECT @ErrCode = 0, @ErrMsg = ''
	    
	SELECT @RealCustID = custid 
		, @Password=userpwd
		, @pwdexpiry = dateadd(dd, 30, getdate())  
		, @CustCurrency=currency
	FROM Customer c WITH (NOLOCK)
	WHERE custid=@RealCustID
	AND roleid=1 AND site<>'SabaCoins'

	IF @RealCustID IS NULL
	BEGIN
		SET @ErrCode=99
		SET @ErrMsg='Invalid member.'
		
		RETURN
	END

	IF EXISTS (SELECT 1 FROM custInfo WITH (NOLOCK) WHERE custid=@RealCustID AND closed=1)   
	BEGIN    
		SELECT     
			@ErrMsg = 'Memeber was closed.',     
			@ErrCode=210    

		RETURN    
	END

	SELECT    
		 @srecommend = ci.srecommend,    
		 @mrecommend = ci.mrecommend,     
		 @recommend = ci.custID,    
		 @recommendUsername = ci.username,
		 @currency = ci.currency,        
		 @site    = c.site,    
		 @Aclosed   = ci.closed,    
		 @Asuspended   = reject,    
		 @matchlimit   = matchlimit,    
		 @virtualmultiplier = virtualmultiplier
	FROM custinfo ci WITH(NOLOCK)     
		INNER JOIN customer c WITH(NOLOCK) ON ci.custid = c.custid    
	WHERE ci.CustID = @AgentID AND ci.roleid = 2 
		AND c.site='SabaCoins' 
		AND c.currency= CASE WHEN @CustCurrency<>20 THEN 213 --SBC
							 ELSE 72 END	--YNG : for TEST
	     
	--check valid agent here    
	IF @recommend IS NULL    
	BEGIN    
		SELECT @ErrMsg = 'Invalid agent.', @ErrCode = 10    
		RETURN    
	END      
	    
	--SELECT @ErrCode = 0 , @ErrMsg = ''   	   	  

	----> Check Betlimit SB
	--EXEC dbo.Acc_Dep_CustSetting_Game_Check    
	--	 @custid	= @custid,    
	--	 @AgentID	= @AgentID,    
	--	 @Site		= @Site,    
	--	 @Currency	= @Currency,    
	--	 @ProductID = 1,    
	--	 @SuperID	= @srecommend,    
	--	 @ErrCode	= @ErrCode OUTPUT,    	   
	--	 @ErrMsg	= @ErrMsg OUTPUT

	--IF @ErrCode<>0
	--	RETURN
		 
	SELECT @ErrCode = 0 , @ErrMsg = ''   	   	  
	    
	IF @Aclosed = 1    
	BEGIN    
		SELECT     
			@ErrMsg = 'Your account was closed. Cannot add member.',     
			@ErrCode=211    

		RETURN    
	END    
	    	
	DECLARE @IsExistsUsername BIT = 0
	
	--Generate username    
	BEGIN  
		SELECT @UserName = @recommendUsername + 'S' + CAST(@RealCustID AS varchar(30))  
		
		EXEC Acc_Dep_CustomerCheckExists @username = @UserName, @IsExists = @IsExistsUsername OUTPUT

		--Check the unique username
		IF @IsExistsUsername = 1
		BEGIN    
			SELECT @ErrMsg = 'The username is not available.', @ErrCode = 11    
			RETURN    
		END 
	END  

	--Generate @UserName2    
	DECLARE @UserName2 NVARCHAR(50)

	SELECT @UserName2 = @site  + '$' + CAST(@RealCustID AS varchar(30))    

	EXEC Acc_Dep_CustomerCheckExists @username = @UserName2, @IsExists = @IsExistsUsername OUTPUT

	--Check the unique username2
	IF @IsExistsUsername = 1
	BEGIN    
		SELECT @ErrMsg = 'The username is not available.', @ErrCode = 12    
		RETURN    
	END 
	
	-----------------------------------------------    
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
		@srecommend = @srecommend,    
		@mrecommend = @mrecommend,    
		@recommend = @recommend,    
		@roleid = 1, 
		@country = @Country,    
		@suspended = @Asuspended,    
		@matchlimit = @matchlimit,    
		@virtualmultiplier = @virtualmultiplier,    	  	 
		@IP = '',    
		@Language = 'E',    
		@ErrCode = @ErrCode OUTPUT,    
		@ErrMsg = @ErrMsg OUTPUT    

	IF @ErrCode <> 0    
		RETURN    

	---------------------------------------------------------------------------------    
	--SportBook Setting
	DECLARE @DCSErrCode INT = 0
	EXEC dbo.Acc_Dep_CustSetting_AllInfoIns
			@CustID				= @CustID
			, @SuperID			= @srecommend
			, @MasterID			= @mrecommend
			, @AgentID			= @recommend
			, @RoleID			= 1
			, @ProductID		= 1
			, @ErrCode			= @DCSErrCode OUTPUT
				
	IF @DCSErrCode <> 0 
	BEGIN
		 --Error occur
		 SET @ErrCode = 911
		 -- ROLLBACK MANUALLY     
		 EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID  
		 RETURN    
	END
	    
	---------------------------------------------------------------------------------    
	UPDATE customer WITH (ROWLOCK, UPDLOCK) 
	SET  username2 = @UserName2
	WHERE custID = @custID    
	  
	---------------------------------------------------------------------------------    
	--Writelog
	SET @endRun = getdate()    
	SET @duration  = datediff (millisecond,@startRun,@endRun)    
	    
	Declare @LogSPData nvarchar(4000)    
	    
	SELECT @LogSPData = '<Dot_Dep_CustomerInsMember_Ag_Cust_Shadow custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +    
	'creator="'+ coalesce(cast(@recommend as varchar(50)),space(1)) + '" ' +    
	'username="'+ coalesce(cast(@username as varchar(30)),space(1)) + '" ' +    
	'username2="'+ coalesce(cast(@UserName2 as varchar(50)),space(1)) + '" ' +    
	'AgentID="'+ coalesce(cast(@AgentID as varchar(50)),space(1)) + '" ' +    
	'ErrCode="'+ coalesce(cast(@ErrCode as varchar(50)),space(1)) + '" ' +    
	'ErrMsg="'+ coalesce(cast(@ErrMsg as varchar(4000)),space(1)) + '" />'    
	 
	EXEC dbo.Acc_WriteLog_UserLog_RunSP_Wrapper    
	  @UserID = @CustID,    
	  @CustID = @CustID,    
	  @ActionID = 2421,    
	  @TrackingValue = @LogSPData,    
	  @duration = @duration    	

	DECLARE @MinBet MONEY,@MaxBet MONEY,@MaxPerMatch MONEY,@MaxPayoutPermatch MONEY -- Bet Setting of representative sport type = 1 , bettype = 1
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
	     
	--Write BetSetting log    
	SELECT @LogSPData = '<Dot_Dep_CustomerInsMember_Ag_Cust_Shadow custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +    
	'MinBet="'+ coalesce(cast(@MinBet as varchar(50)),space(1)) + '" ' +    
	'MaxBet="'+ coalesce(cast(@MaxBet as varchar(50)),space(1)) + '" ' +    
	'MaxPerMatch="'+ coalesce(cast(@MaxPerMatch as varchar(50)),space(1))+ '" ' + 
	'MaxPayoutPerMatch="'+ coalesce(cast(@MaxPayoutPermatch as varchar(50)),space(1)) + '" />'    
	   
	EXEC dbo.Acc_WriteLog_UserLog_RunSP_Wrapper     
	  @UserID = @CustID,    
	  @CustID = @CustID,    
	  @ActionID = 2049,    
	  @TrackingValue = @LogSPData,    
	  @duration = @duration    	
	     
	--Write PT log    
	SELECT @LogSPData = '<Dot_Dep_CustomerInsMember_Ag_Cust_Shadow custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +    
	'AgentPT="'+ coalesce(dbo.f_FomatNumericToChar(@PT),space(1)) + '" />'    
	
	EXEC dbo.Acc_WriteLog_UserLog_RunSP_Wrapper     
	  @UserID = @CustID,    
	  @CustID = @CustID,    
	  @ActionID = 2719,    
	  @TrackingValue = @LogSPData,    
	  @duration = @duration    

	--Write Statuses log     
	SELECT @LogSPData = '<Dot_Dep_CustomerInsMember_Ag_Cust_Shadow custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +    
	'suspended="'+ coalesce(cast(@Asuspended as varchar(50)),space(1)) + '" />'    

	EXEC dbo.Acc_WriteLog_UserLog_RunSP_Wrapper      
	  @UserID = @CustID,    
	  @CustID = @CustID,    
	  @ActionID = 2221,    
	  @TrackingValue = @LogSPData,    
	  @duration = @duration    	
END
GO 