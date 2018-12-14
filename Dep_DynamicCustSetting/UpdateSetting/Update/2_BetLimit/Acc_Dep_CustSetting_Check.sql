/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet,bodbDownlineNet,bodbExtAccNet,bodbLicenseeNet" viewers="" isFunction="0"></info>*/
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
	Param's Explanation:
	
	*/

BEGIN
	SET NOCOUNT ON

	DECLARE @ErrType NVARCHAR(200)

	CREATE TABLE #ProductSettingDetail(	
		[SportType]		SMALLINT NOT NULL,
		[BetType]		SMALLINT NOT NULL,		
		SportName		NVARCHAR(50)
		PRIMARY KEY(SportType,BetType)		
	)

		
	INSERT INTO #ProductSettingDetail (SportType,BetType)
	SELECT DISTINCT psd.SportType,psd.BetType
	FROM Dep_LicenseeProductSetting lds WITH (NOLOCK)
		INNER JOIN Dep_ProductSetting ps WITH (NOLOCK) ON lds.ProductSettingID = PS.ProductSettingID
		INNER JOIN Dep_ProductSettingDetail psd WITH (NOLOCK) ON psd.ProductSettingID = ps.ProductSettingID
	WHERE lds.CustID =@SuperID AND (@ProductID IS NULL OR ps.ProductID = @ProductID) AND ps.SettingType=2

	UPDATE t
	 SET t.SportName=s.SportName
	FROM #ProductSettingDetail t
		INNER JOIN DBEXT.bodb02.dbo.Sports s WITH(NOLOCK) ON t.SportType=s.SportType

	SELECT @ErrType=''
	SELECT @ErrType = @ErrType + sportname + ', '   	
	FROM dbo.Dep_CustBetSetting_Agent smcs WITH (NOLOCK)
		INNER JOIN #ProductSettingDetail s ON s.SportType = smcs.SportType AND s.Bettype = smcs.BetType
		INNER JOIN Dep_CustBetLimit_Special CBS WITH(NOLOCK) 
			ON  CBS.SportType = S.SportType AND CBS.Bettype=(CASE WHEN S.SportType IN (180,181,182,183,184,185,186) THEN 1 ELSE S.Bettype END) 
											AND (CBS.AgentID IS NULL OR CBS.AgentID=@AgentID) AND Site=@site AND CurrencyID=@currency 
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
			ON  CBS.SportType = S.SportType AND CBS.Bettype=(CASE WHEN S.SportType IN (180,181,182,183,184,185,186) THEN 1 ELSE S.Bettype END) 
											AND (CBS.AgentID IS NULL OR CBS.AgentID=@AgentID) AND Site=@site AND CurrencyID=@currency 
	WHERE (CBS.MaxPerMatch>smcs.MaxPerMatch) AND smcs.CustID=@AgentID

	IF @ErrType <>''    
	BEGIN    
	 SELECT    
	  @ErrMsg = 'Sorry, Max Per Match must be equal to or less than Master/Agent Max Per Match ('+@ErrType+').',    
	  @ErrCode = 107    
	 return    
	END   
					
END

GO
