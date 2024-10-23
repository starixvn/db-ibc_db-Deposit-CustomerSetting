/*<info serverAlias="DBCUST-CustDB" executers="asv_cust" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[API_CustomerIns_Member]
	@CustID INT,
	@UserName VARCHAR(30),
	@UserName2 VARCHAR(50),
	@DepositUserID INT, 
	@recommend INT,
	@Password VARCHAR(40), 
	@OddsType VARCHAR(5), 
	@Country NVARCHAR(50) = '', 
	@SubsidiaryID INT = 0, 
	@AffiliateID INT = NULL,
	@DefaultComms VARCHAR(MAX)  = '',
	@GroupDiscountID INT = 0,
	--@BonusCode VARCHAR(20) = NULL,
	@Site VARCHAR(10), --12Bet, Spondemo ...
	@ErrCode INT = 0 OUTPUT,
	@ErrMsg NVARCHAR(2000) = '' OUTPUT,
	@currency INT = 0 OUTPUT,
	@ErrExtraInfo VARCHAR(MAX) = '' OUTPUT -- Log DB
AS
/*
	Created: 20240705@Eden  
	Task : First Deposit --> Validate data before insert new customer
	DB:  DBCUST-CustDB
	Original sp: 
	
	Revisions: 
		- 20240705@Eden  : Scale out DBCUST - Licensee Customer in GlobCustDB [redmine: #207474] 
		- 20240920@Helios  : Scale out DBCUST - Licensee Customer in GlobCustDB - Modified BEGIN TRY - CATCH [redmine: #207474]

	Param's Explanation: 
		DECLARE @ErrCode INT = 0 ,
				@ErrMsg NVARCHAR(2000) = '' 
		EXEC [API_CustomerIns_Member]
			 @CustID			= 123
			,@UserName			= '12BETTB01S51869'
			,@UserName2			= '12Bet$Edentest'
			,@DepositUserID		= 111
			,@recommend			= 836210
			,@Password			= 'xxxx'
			,@OddsType			= 'Boping'
			,@Country			= ''
			,@SubsidiaryID		= 0
			,@AffiliateID		= 0
			--,@BonusCode			= NULL
			,@Site				= '12Bet'
			,@ErrCode			= @ErrCode OUTPUT
			,@ErrMsg			= @ErrMsg OUTPUT

		SELECT  @ErrCode		AS ErrCode		
				,@ErrMsg		AS ErrMsg
*/			   				
BEGIN
	SET NOCOUNT ON
	-------------------------------------  
	 DECLARE @mrecommend INT,      
			@srecommend INT,       
			@pwdexpiry DATETIME,      
			@ugroup VARCHAR(5) = 'a', -- Default ugroup
			@matchlimit SMALLMONEY,      
			@virtualmultiplier SMALLMONEY 

	SELECT @srecommend = ci.srecommend,      
		   @mrecommend = ci.mrecommend,          
		   @currency = ci.currency,                    
		   @matchlimit   = ci.matchlimit,      
		   @virtualmultiplier = ci.virtualmultiplier  
	FROM custinfo ci WITH(NOLOCK)
	WHERE ci.CustID = @recommend 
	
	SELECT @ugroup = Ugroup FROM Dep_DefaultOddGroup WITH(NOLOCK) WHERE AgentID = @recommend AND IsActive=1 
	SELECT @pwdexpiry = dateadd(dd, 30, getdate())   

	BEGIN TRY
		--Insert general data       
		EXEC dbo.Dot_Dep_CustomerInsUserInfo  
			@custid = @custid,         
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
			@matchlimit = @matchlimit,      
			@virtualmultiplier = @virtualmultiplier,           
			@IP = '',      
			@Language = 'E',      
			@ErrCode = @ErrCode OUTPUT,      
			@ErrMsg = @ErrMsg OUTPUT,
			@SubsidiaryID = @SubsidiaryID,
			@username2 = @username2,
			@refcode2 = @DepositUserID,
			@BonusWalletFlag = 0,
			@ErrExtraInfo = @ErrExtraInfo OUTPUT
  
		IF @ErrCode <> 0      
			RETURN     
	END TRY
	BEGIN CATCH
		--Error occur  
		SELECT @ErrCode = 911 ,
			@ErrMsg = 'Create customer failed. Please try again.',
			@ErrExtraInfo = 'Dot_Dep_CustomerInsUserInfo: ' + CAST( @ErrMsg AS  VARCHAR(20))

		-- ROLLBACK MANUALLY       

		EXEC Acc_Dep_CustomerInsSetting_Rollback @CustID = @CustID, @RoleID = 1
		EXEC Acc_Dep_CustomerInsUserInfo_Rollback @CustID = @CustID
		RETURN  
	END CATCH
		   
	BEGIN TRY
		DECLARE @DCSErrCode INT = 0  
		EXEC dbo.Acc_Dep_DynamicCustSetting_00  
			  @CustID = @CustID  
			, @SuperID = @srecommend  
			, @MasterID = @mrecommend  
			, @AgentID = @recommend  
			, @RoleID = 1  
			, @ProductID = NULL  
			, @ErrCode = @DCSErrCode OUTPUT  
   
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

	--Set default Group comm if exists
	IF @DefaultComms <> '' AND @GroupDiscountID <> 0
	BEGIN
		EXEC API_CustomerIns_DefaultComm_MainDB
			 @DefaultComms	= @DefaultComms
			,@Recommend		= @Recommend
			,@CustID		= @CustID
			,@ErrCode		= @ErrCode OUTPUT
			,@ErrMsg		= @ErrMsg OUTPUT
	END

	BEGIN TRY
		--Set default bet setting of AG Casino    
		EXEC Lrf_AGC_Customer_SetDefaultSetting      
			@CustID = @CustID,    
			@SuperID = @recommend,      
			@ErrCode = @ErrCode,      
			@ErrMsg = @ErrMsg    
	END TRY
	BEGIN CATCH
		SELECT @ErrCode	= 952
			   ,@ErrMsg	= ERROR_MESSAGE()
	END CATCH

	BEGIN TRY
		--Set default bet setting of 3rd Product    
		EXEC dbo.Lrf_3rdProductCustomerSetDefaultSetting      
			@CustID = @CustID,    
			@SuperID = @srecommend,      
			@ErrCode = @ErrCode,      
			@ErrMsg = @ErrMsg    
	END TRY
	BEGIN CATCH
		SELECT @ErrCode	= 953
			   ,@ErrMsg	= ERROR_MESSAGE()
	END CATCH
	    
	--Write log info
	DECLARE @LogInfo_Tbl TABLE(UserID INT, CustID INT, ActionID INT, TrackingValue VARCHAR(MAX), TrackingValue2 VARCHAR(MAX))
	DECLARE @TrackingValue VARCHAR(MAX), @TrackingValue2 VARCHAR(MAX)

	DECLARE @MinBet MONEY,@MaxBet MONEY,@MaxPerMatch MONEY,@MaxPayoutPermatch MONEY -- Bet setting of representative sport type = 1 , bettype = 1
	DECLARE @Discount DECIMAL(9,8) = 0 -- Commission of representative sport type = 1 , bettype = 1
	DECLARE @PT smallmoney -- Position taking of representative sport type = 1 , bettype = 1

	--PT
	IF EXISTS(SELECT 1 FROM Dep_CustSettingMode WITH(NOLOCK) WHERE custid = @CustID AND IsGroupedPT = 1)
	BEGIN
		SELECT @PT = AgentPT/100 FROM Dep_CustPTGroupSetting_Member WITH(NOLOCK) WHERE AgentID = @recommend AND SportType = 1 AND BetType = 1
	END
	ELSE
	BEGIN
		SELECT @PT = AgentPT/100 FROM Dep_CustPTSetting_Member WITH(NOLOCK) WHERE CustID = @CustID AND SportType = 1 AND BetType = 1
	END

	--Comm
	IF EXISTS(SELECT 1 FROM Dep_CustSettingMode WITH(NOLOCK) WHERE custid = @CustID AND IsGroupedComm = 1)
	BEGIN
		SELECT @Discount = AgentDiscount FROM Dep_CustDiscountGroupSetting_Member WITH(NOLOCK) WHERE AgentID = @recommend AND SportType = 1 AND BetType = 1
	END
	ELSE
	BEGIN
		SELECT @Discount = AgentDiscount FROM Dep_CustDiscountSetting_Member WITH(NOLOCK) WHERE CustID = @CustID AND SportType = 1 AND BetType = 1
	END

	--Bet Setting
	IF EXISTS(SELECT 1 FROM Dep_CustSettingMode WITH(NOLOCK) WHERE custid = @CustID AND IsGroupedBetLimit = 1)
	BEGIN
		SELECT @MinBet = MinBet, @MaxBet= MaxBet, @MaxPerMatch = MaxPerMatch, @MaxPayoutPermatch = MaxPayoutPerMatch 
		FROM Dep_CustBetSettingGameGroup_Member WITH(NOLOCK) WHERE AgentID = @recommend AND SportType = 1 AND BetType = 1
	END
	ELSE
	BEGIN
		SELECT @MinBet = MinBet, @MaxBet= MaxBet, @MaxPerMatch = MaxPerMatch, @MaxPayoutPermatch = MaxPayoutPerMatch 
		FROM Dep_CustBetSettingGame_Member WITH(NOLOCK) WHERE CustID = @CustID AND SportType = 1 AND BetType = 1
	END
	
	DECLARE @xml XML

	SET @xml = (
					SELECT	@custid							AS '@custid',
							dbo.f_FomatNumericToChar(@PT)	AS '@AgentPT',
							@Discount						AS '@Discount',
							@MinBet							AS '@MinBet',
							@MaxBet							AS '@MaxBet',
							@MaxPerMatch					AS '@MaxPerMatch',
							@MaxPayoutPermatch				AS '@MaxPayoutPermatch',
							@CustID							AS '@Creator',
							@AffiliateID					AS '@AffiliateID',
							@username						AS '@Username',
							@SubsidiaryID					AS '@SubsidiaryID',
							@recommend						AS '@AgentID',
							@UserName2						AS '@DepositUserName',
							@DepositUserID					AS '@DepositUserID',
							@OddsType						AS '@OddsType',
							@ugroup							AS '@ugroup',
							@GroupDiscountID				AS '@GroupDiscountID',
							@ErrCode						AS '@ErrCode',
							@ErrMsg							AS '@ErrMsg',
							(
								SELECT	t.SportType								AS '@SportType',
									t.BetType									AS '@BetType',
									t.PlayerDiscount							AS '@PlayerDiscount'
								FROM Dep_CustDiscountSetting_Member t WITH(NOLOCK)
								WHERE CustID = @CustID 
								FOR XML PATH('Comm'),
								TYPE
			
							)
					FOR XML PATH('R'),
					TYPE
				)

	SET @TrackingValue = REPLACE(CONVERT(VARCHAR(MAX), @xml), '" />', '"/"')

	INSERT INTO @LogInfo_Tbl(UserID, CustID,ActionID,TrackingValue)
	SELECT @CustID, @CustID, 271000, @TrackingValue

	SELECT UserID, CustID,ActionID,TrackingValue 
	FROM @LogInfo_Tbl
END	
GO