/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet,bodbDownlineNet,bodbExtAccNet,wsv_lap,Dot_member" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE dbo.Acc_Dep_CustSetting_Game_BetLimitFullLineSettingSelect 
	  @SuperID		INT
	, @ProductID	TINYINT	
	, @AgentID		INT
AS
/*
	Created: 20220301@Eden
	Task: Select Customer's Bet Limits - Licensee DCS Setting
	DB: DBCUST/CustDB
	Original:

	Revision:
		- 20220301@Eden: Deposit - Sportsbook - Revise customer settings [Redmine: #167898] 
		- 20220921@Winfred: Licensee DCS setting - HF Get multiple bet limit . [Feature #178013]
		
	Param's Explanation:
		
	*/
BEGIN
	DECLARE @Currency TINYINT, @RoleID INT, @srecommend INT, @mrecommend INT, @recommend INT, @UplineID INT	
	CREATE TABLE #SportBettypeFilter (productID INT,SportType INT,Bettype INT,IsLive BIT)

	INSERT INTO #SportBettypeFilter (productID,SportType,Bettype,IsLive)
	SELECT DISTINCT ProductID, SportType,Bettype,IsLive 
	FROM Dep_ProductSetting ps WITH(NOLOCK) 
		INNER JOIN Dep_ProductSettingDetail d WITH(NOLOCK) ON ps.ProductSettingID=d.ProductSettingID  
	WHERE ProductID = @ProductID AND SettingType IN (10,12)	

	IF @AgentID = 0
	BEGIN
		SET @AgentID = @SuperID
	END

	SELECT ft.SportType  
		, ft.BetType  
		, bl.MinBet  
		, bl.MaxBet  
		, bl.MaxPerMatch  
		, bl.MaxPerNumber  
		, bl.MaxPayoutPerMatch 
	FROM #SportBettypeFilter ft 
		INNER JOIN dbo.Dep_CustBetSettingGame_Agent bl WITH (NOLOCK) ON ft.SportType = bl.sporttype AND ft.BetType = bl.bettype 
	WHERE bl.custid = @SuperID
	UNION 	
	SELECT ft.SportType  
		, ft.BetType  
		, 0 AS MinBet  
		, 0 AS MaxBet  
		, 0 AS MaxPerMatch 		
		, 0 AS MaxPerNumber  
		, 0 AS MaxPayoutPerMatch 				
	FROM #SportBettypeFilter ft 
		WHERE NOT EXISTS (SELECT 1 FROM #SportBettypeFilter f 
											INNER JOIN dbo.Dep_CustBetSettingGame_Agent bl WITH (NOLOCK) ON f.SportType = bl.sporttype AND f.BetType = bl.bettype 
											WHERE bl.custid =@SuperID AND ft.SportType=f.SportType AND ft.Bettype=f.Bettype)

	SELECT ft.SportType  
		, ft.BetType  
		, bl.MinBet  
		, bl.MaxBet  
		, bl.MaxPerMatch  
		, bl.MaxPerNumber  
		, bl.MaxPayoutPerMatch
	FROM #SportBettypeFilter ft 
		INNER JOIN dbo.Dep_CustBetSettingGame_Agent bl WITH (NOLOCK) ON ft.SportType = bl.sporttype AND ft.BetType = bl.bettype 
	WHERE bl.custid = @AgentID
	UNION 	
	SELECT ft.SportType  
		, ft.BetType  
		, 0 AS MinBet  
		, 0 AS MaxBet  
		, 0 AS MaxPerMatch 	
		, 0 AS MaxPerNumber  
		, 0 AS MaxPayoutPerMatch				
	FROM #SportBettypeFilter ft 
		WHERE NOT EXISTS (SELECT 1 FROM #SportBettypeFilter f 
											INNER JOIN dbo.Dep_CustBetSettingGame_Agent bl WITH (NOLOCK) ON f.SportType = bl.sporttype AND f.BetType = bl.bettype 
											WHERE bl.custid =@AgentID AND ft.SportType=f.SportType AND ft.Bettype=f.Bettype)
	DROP TABLE #SportBettypeFilter
END
GO
