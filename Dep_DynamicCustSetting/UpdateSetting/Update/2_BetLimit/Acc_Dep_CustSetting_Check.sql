/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet,bodbDownlineNet,bodbExtAccNet,wsv_lap" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_CustSetting_Check] 
	  @CustID			INT	
	, @AgentID			INT
	, @Site				VARCHAR(10)
	, @Currency			INT
	, @ProductID		INT=NULL
	, @SuperID			INT
	, @ErrCode			INT				= 0		OUTPUT	
	, @ErrMsg			NVARCHAR(200)	= ''	OUTPUT
AS
/*
	Created: 20181119@Winnie
	Task: Check Customer's Bet Limits
	DB: DBCUST/CustDB
	Original:

	Revision:
		- 20181119@Winnie: Check betsetting Esports [Redmine: 100721]	
		- 20220218@Winfred: LG VS3  - Licensee DCS setting for new BetLimit  [Redmine: 168395]	
		- 20230224@Winfred: NAP LM - Enhance Bet Setting function for AM to use [redmine:#178105] 		
		- 20240111@Tacy: LAP - Merge VS1, VS2, VS3 as Virtual Sports [Redmine: #199523]

	Param's Explanation:
	
	*/

BEGIN
	SET NOCOUNT ON

	DECLARE @ErrType NVARCHAR(200)

	CREATE TABLE #ProductSettingDetail(	
		[SportType]		SMALLINT NOT NULL,
		[BetType]		SMALLINT NOT NULL,		
		SportName		NVARCHAR(50),
		SettingType		TINYINT
		PRIMARY KEY(SportType,BetType)		
	)

		
	INSERT INTO #ProductSettingDetail (SportType,BetType,SettingType)
	SELECT DISTINCT psd.SportType,psd.BetType,ps.SettingType
	FROM Dep_LicenseeProductSetting lds WITH (NOLOCK)
		INNER JOIN Dep_ProductSetting ps WITH (NOLOCK) ON lds.ProductSettingID = PS.ProductSettingID
		INNER JOIN Dep_ProductSettingDetail psd WITH (NOLOCK) ON psd.ProductSettingID = ps.ProductSettingID
	WHERE lds.CustID =@SuperID AND (@ProductID IS NULL OR ps.ProductID = @ProductID) AND ps.SettingType IN (2,11)

	UPDATE t
	 SET t.SportName=s.SportName
	FROM #ProductSettingDetail t
		INNER JOIN DBEXT.bodb02.dbo.Sports s WITH(NOLOCK) ON t.SportType=s.SportType
	
	IF(EXISTS(SELECT top 1 1 FROM Dep_CustBetLimit_Special WITH(NOLOCK) WHERE AgentID = @AgentID))  
	BEGIN
		SELECT @ErrType=''
		SELECT @ErrType = @ErrType + sportname + ', '   	
		FROM dbo.Dep_CustBetSetting_Agent smcs WITH (NOLOCK)
			INNER JOIN #ProductSettingDetail s ON s.SportType = smcs.SportType AND s.Bettype = smcs.BetType
			INNER JOIN Dep_CustBetLimit_Special CBS WITH(NOLOCK) 
					ON  CBS.SportType = S.SportType
					AND CBS.Bettype=S.Bettype 
					AND CBS.AgentID=@AgentID
					AND Site=@site 
					AND CurrencyID=@currency 
		WHERE (CBS.Minbet<smcs.Minbet) AND smcs.CustID=@AgentID

		IF @ErrType <>''    
		BEGIN    
		 SELECT    
		  @ErrMsg = 'Sorry, Min bet must be equal to or greater than Master/Agent min bet ('+@ErrType+').',    
		  @ErrCode = 107    
		 return    
		END   

		SELECT @ErrType=''
		SELECT @ErrType = @ErrType + sportname + ', '   	
		FROM dbo.Dep_CustBetSetting_Agent smcs WITH (NOLOCK)
			INNER JOIN #ProductSettingDetail s ON s.SportType = smcs.SportType AND s.Bettype = smcs.BetType
			INNER JOIN Dep_CustBetLimit_Special CBS WITH(NOLOCK) 
					ON  CBS.SportType = S.SportType
					AND CBS.Bettype=S.Bettype
					AND CBS.AgentID=@AgentID
					AND Site=@site 
					AND CurrencyID=@currency 
		WHERE (CBS.MaxBet>smcs.MaxBet) AND smcs.CustID=@AgentID

		IF @ErrType <>''    
		BEGIN    
		 SELECT    
		  @ErrMsg = 'Sorry, max bet must be equal to or less than Master/Agent max bet ('+@ErrType+').',    
		  @ErrCode = 107    
		 return    
		END   

		SELECT @ErrType=''
		SELECT @ErrType = @ErrType + sportname + ', '   	
		FROM dbo.Dep_CustBetSetting_Agent smcs WITH (NOLOCK)
			INNER JOIN #ProductSettingDetail s ON s.SportType = smcs.SportType AND s.Bettype = smcs.BetType 
			INNER JOIN Dep_CustBetLimit_Special CBS WITH(NOLOCK) 
					ON  CBS.SportType = S.SportType
					AND  CBS.Bettype=S.Bettype 
					AND CBS.AgentID=@AgentID
					AND Site=@site 
					AND CurrencyID=@currency  
					AND s.SettingType  <> 11
		WHERE (CBS.MaxPerMatch>smcs.MaxPerMatch) AND smcs.CustID=@AgentID

		IF @ErrType <>''    
		BEGIN    
		 SELECT    
		  @ErrMsg = 'Sorry, Max Per Match must be equal to or less than Master/Agent Max Per Match ('+@ErrType+').',    
		  @ErrCode = 107    
		 return    
		END   
	END
	ELSE
	BEGIN
		SELECT @ErrType=''
		SELECT @ErrType = @ErrType + sportname + ', '   	
		FROM dbo.Dep_CustBetSetting_Agent smcs WITH (NOLOCK)
			INNER JOIN #ProductSettingDetail s ON s.SportType = smcs.SportType AND s.Bettype = smcs.BetType
			INNER JOIN Dep_CustBetLimit_Special CBS WITH(NOLOCK) 
					ON  CBS.SportType = S.SportType
					 AND CBS.Bettype=S.Bettype 
					AND CBS.AgentID IS NULL
					AND Site=@site 
					AND CurrencyID=@currency 
		WHERE (CBS.Minbet<smcs.Minbet) AND smcs.CustID=@AgentID

		IF @ErrType <>''    
		BEGIN    
		 SELECT    
		  @ErrMsg = 'Sorry, min bet must be equal to or greater than Master/Agent min bet ('+@ErrType+').',    
		  @ErrCode = 107    
		 return    
		END   

		SELECT @ErrType=''
		SELECT @ErrType = @ErrType + sportname + ', '   	
		FROM dbo.Dep_CustBetSetting_Agent smcs WITH (NOLOCK)
			INNER JOIN #ProductSettingDetail s ON s.SportType = smcs.SportType AND s.Bettype = smcs.BetType
			INNER JOIN Dep_CustBetLimit_Special CBS WITH(NOLOCK) 
					ON  CBS.SportType = S.SportType
					 AND CBS.Bettype=S.Bettype 
					AND CBS.AgentID IS NULL
					AND Site=@site 
					AND CurrencyID=@currency 
		WHERE (CBS.MaxBet>smcs.MaxBet) AND smcs.CustID=@AgentID

		IF @ErrType <>''    
		BEGIN    
		 SELECT    
		  @ErrMsg = 'Sorry, max bet must be equal to or less than Master/Agent max bet ('+@ErrType+').',    
		  @ErrCode = 107    
		 return    
		END   

		SELECT @ErrType=''
		SELECT @ErrType = @ErrType + sportname + ', '   	
		FROM dbo.Dep_CustBetSetting_Agent smcs WITH (NOLOCK)
			INNER JOIN #ProductSettingDetail s ON s.SportType = smcs.SportType AND s.Bettype = smcs.BetType 
			INNER JOIN Dep_CustBetLimit_Special CBS WITH(NOLOCK) 
					ON  CBS.SportType = S.SportType
					AND CBS.Bettype=S.Bettype 
					AND CBS.AgentID IS NULL
					AND Site=@site 
					AND CurrencyID=@currency  
					AND s.SettingType <> 11
		WHERE (CBS.MaxPerMatch>smcs.MaxPerMatch) AND smcs.CustID=@AgentID

		IF @ErrType <>''    
		BEGIN    
		 SELECT    
		  @ErrMsg = 'Sorry, Max Per Match must be equal to or less than Master/Agent Max Per Match ('+@ErrType+').',    
		  @ErrCode = 107    
		 return    
		END   
	END				
END

GO
