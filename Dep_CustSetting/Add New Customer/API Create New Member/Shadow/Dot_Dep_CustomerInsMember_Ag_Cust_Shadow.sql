/*<info serverAlias="DBCUST-CUSTDB" executers="asv_cust " viewers="" isFunction="0" isNested="0"></info>*/
ALTER PROCEDURE [dbo].[Dot_Dep_CustomerInsMember_Ag_Cust_Shadow]     
	@CustID INT,    
	@Username VARCHAR(30),
	@AgentID INT,    
	@ErrCode INT = 0 OUTPUT,    
	@ErrMsg NVARCHAR(2000) = '' OUTPUT,
	@ErrExtraInfo VARCHAR(MAX) = '' OUTPUT -- Log DB     
AS   
/*    
	Created: 20240404@Tacy 
	Task : Create new shadow account 
	DB: DBCUST/CustDB    
	Refer: Dot_Dep_CustomerInsMember_Ag_Cust_Main
	    
	Revisions:    
		- 20240404@Tacy: Deposit - Integrate Saba Coin Wallet [Redmine: #202273] 
		- 20240604@Tacy: Change format Username [Redmine: #202273] 
		- 20240705@Eden  : Scale out DBCUST - Licensee Customer in GlobCustDB [redmine: #207474]
		- 20240920@Helios  : Scale out DBCUST - Licensee Customer in GlobCustDB - Modified WriteLog , BEGIN TRY - CATCH [redmine: #207474]
		- 20241219@Tacy: SabaCoins - Phase 02 [redmine: #215807]

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
	    
	DECLARE	 @currency INT,
		@recommend INT,    
		@mrecommend INT,    
		@srecommend INT,     
		@site VARCHAR(30), 
		@Password VARCHAR(40),
		@pwdexpiry DATETIME,
		@matchlimit SMALLMONEY,    
		@virtualmultiplier SMALLMONEY
	   
	SELECT @Password='8058095B7DDB08A608811097E5DB8D'
		, @pwdexpiry = dateadd(dd, 30, getdate()) 

	--Init param    
	SELECT @ErrCode = 0, @ErrMsg = ''

	SELECT    
		 @srecommend = ci.srecommend,    
		 @mrecommend = ci.mrecommend,     
		 @recommend = ci.custID,    
		 @currency = ci.currency,        
		 @site    = c.site,     
		 @matchlimit   = matchlimit,    
		 @virtualmultiplier = virtualmultiplier
	FROM custinfo ci WITH(NOLOCK)     
		INNER JOIN customer c WITH(NOLOCK) ON ci.custid = c.custid    
	WHERE ci.CustID = @AgentID AND ci.roleid = 2 
		AND c.site='SabaCoins' 
		AND c.currency IN (213	--SBC
						  , 72 )--YNG : for TEST
	-----------------------------------------------    
	--Insert general data     
	EXEC dbo.Dot_Dep_CustomerInsUserInfo
		@custid = @custid,       
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
		@country = '',      
		@matchlimit = @matchlimit,    
		@virtualmultiplier = @virtualmultiplier,    	  	 
		@IP = '',    
		@Language = 'E',    
		@ErrCode = @ErrCode OUTPUT,    
		@ErrMsg = @ErrMsg OUTPUT,
		@username2 = NULL,
		@ErrExtraInfo = @ErrExtraInfo OUTPUT

	IF @ErrCode <> 0    
		RETURN    
  
	BEGIN TRY
		--SportBook Setting
		DECLARE @DCSErrCode INT = 0
		EXEC dbo.Acc_Dep_DynamicCustSetting_00
				  @CustID			= @CustID
				, @SuperID			= @srecommend
				, @MasterID			= @mrecommend
				, @AgentID			= @recommend
				, @RoleID			= 1
				, @ProductID		= 1
				, @ErrCode			= @DCSErrCode OUTPUT
				
		IF @DCSErrCode <> 0 
		BEGIN
			--Error occur
			SELECT @ErrCode = 911 ,
				@ErrMsg = 'Create customer failed. Please try again.',
				@ErrExtraInfo = 'Acc_Dep_DynamicCustSetting_00: ' + CAST( @DCSErrCode AS  VARCHAR(20))

			-- ROLLBACK MANUALLY     
			EXEC Acc_Dep_CustomerInsSetting_Rollback @CustID = @CustID, @RoleID = 1
			EXEC Acc_Dep_CustomerInsUserInfo_Rollback @CustID = @CustID
			RETURN         
		END
	END TRY

	BEGIN CATCH
			--Error occur
			SELECT @ErrCode = 911 ,
				@ErrMsg = 'Create customer failed. Please try again.',
				@ErrExtraInfo = 'Acc_Dep_DynamicCustSetting_00: ' + CAST( @DCSErrCode AS  VARCHAR(20))

			-- ROLLBACK MANUALLY     
			EXEC Acc_Dep_CustomerInsSetting_Rollback @CustID = @CustID, @RoleID = 1
			EXEC Acc_Dep_CustomerInsUserInfo_Rollback @CustID = @CustID
			RETURN       
	END CATCH

	--Write log info
	DECLARE @LogInfo_Tbl TABLE(UserID INT, CustID INT, ActionID INT, TrackingValue VARCHAR(MAX), TrackingValue2 VARCHAR(MAX))
	DECLARE @TrackingValue VARCHAR(MAX), @TrackingValue2 VARCHAR(MAX)

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

	--Writelog Generalinfo
	SELECT @TrackingValue = '<Dot_Dep_CustomerInsMember_Ag_Cust_Shadow custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +    
	'AgentID="'+ coalesce(cast(@AgentID as varchar(50)),space(1)) + '" ' +   
	'AgentPT="'+ coalesce(dbo.f_FomatNumericToChar(@PT),space(1)) + '" ' +   
	'MinBet="'+ coalesce(cast(@MinBet as varchar(50)),space(1)) + '" ' +    
	'MaxBet="'+ coalesce(cast(@MaxBet as varchar(50)),space(1)) + '" ' +    
	'MaxPerMatch="'+ coalesce(cast(@MaxPerMatch as varchar(50)),space(1))+ '" ' + 
	'MaxPayoutPerMatch="'+ coalesce(cast(@MaxPayoutPermatch as varchar(50)),space(1)) + '" ' +
	'creator="'+ coalesce(cast(@recommend as varchar(50)),space(1)) + '" ' +    
	'ErrCode="'+ coalesce(cast(@ErrCode as varchar(50)),space(1)) + '" ' +    
	'username="'+ coalesce(cast(@username as varchar(30)),space(1)) + '" ' +    
	'ErrMsg="'+ coalesce(cast(@ErrMsg as varchar(4000)),space(1)) + '" />'    

	INSERT INTO @LogInfo_Tbl(UserID, CustID,ActionID,TrackingValue)
	SELECT @CustID, @CustID, 271005, @TrackingValue
	     
	SELECT * FROM @LogInfo_Tbl
END
GO 