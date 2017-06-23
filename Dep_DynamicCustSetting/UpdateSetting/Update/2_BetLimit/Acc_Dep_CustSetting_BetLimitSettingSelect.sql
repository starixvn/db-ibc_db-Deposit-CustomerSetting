/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet,bodbExtAccNet,bodbDownlineNet,bodbLicenseeNet" viewers="vnteam" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_CustSetting_BetLimitSettingSelect] 
	  @CustID		INT
	, @ProductID	TINYINT
AS
/*
	Created: 20170615@Helen
	Task: Check Customer's Bet Limits
	DB: DBCUST/CustDB
	Original:

	Revision:
		- 20170302@Helen: Betradar Virtual Sports  -Integration for Cash [Redmine: 77274]
		
		
	Param's Explanation:

	
	*/
BEGIN
	
	DECLARE @Currency TINYINT, @RoleID INT, @srecommend INT, @mrecommend INT, @recommend INT, @UplineID INT
	
	CREATE TABLE #SportBettypeFilter (productID INT,SportType SMALLINT,Bettype SMALLINT,IsLive BIT)
	
	INSERT INTO #SportBettypeFilter (productID,SportType,Bettype,IsLive)
	SELECT  ps.ProductID ProductID, SportType,Bettype,IsLive
	FROM dbo.f_Dep_CustSetting_SportBetTypeSettingSelect(@ProductID,2) AS ps
	
	IF EXISTS (SELECT 1 FROM #SportBettypeFilter)
	BEGIN
	
		SELECT @Currency = Currency, @RoleID = roleid, @srecommend = srecommend, @mrecommend = mrecommend, @recommend = @recommend
		FROM dbo.Customer c WITH(NOLOCK)
		WHERE c.custID = @CustID
	
		IF @RoleID = 3
			SET @UplineID = @srecommend
		ELSE IF @RoleID = 2
			SET @UplineID = @mrecommend
		ELSE IF @RoleID = 1
			SET @UplineID = @recommend		
		
		IF @RoleID = 4
		BEGIN
			SELECT ft.SportType  
				, ft.BetType  
				, bl.MinBet  
				, bl.MaxBet  
				, bl.MaxPerMatch  
				, pbs.MinBet AS MinBetMin  
				, pbs.maxbet AS MaxBetMax  
				, pbs.maxpermatch AS MaxPerMatchMax
			FROM #SportBettypeFilter ft 
				INNER JOIN dbo.Dep_CustBetSetting_Agent bl WITH (NOLOCK) ON ft.SportType = bl.sporttype AND ft.BetType = bl.bettype 
				INNER JOIN dbo.Dep_ProductBetSetting pbs WITH (NOLOCK) ON pbs.SportType = bl.sporttype AND pbs.BetType = bl.bettype AND pbs.Currency = @Currency
			WHERE bl.custid = @CustID
		END
		
		ELSE IF @RoleID IN (2,3)
		BEGIN
			SELECT ft.SportType  
				, ft.BetType  
				, bl.MinBet  
				, bl.MaxBet  
				, bl.MaxPerMatch  
				, CASE  WHEN sbl.minbet > pbs.MinBet  THEN sbl.minbet  ELSE pbs.MinBet  END AS MinBetMin  
				, sbl.maxbet AS MaxBetMax  
				, sbl.maxpermatch AS MaxPerMatchMax
			FROM #SportBettypeFilter ft 
				INNER JOIN dbo.Dep_CustBetSetting_Agent bl WITH (NOLOCK) ON ft.SportType = bl.sporttype AND ft.BetType = bl.bettype 
				INNER JOIN dbo.Dep_ProductBetSetting pbs WITH (NOLOCK) ON pbs.SportType = bl.sporttype AND pbs.BetType = bl.bettype AND pbs.Currency = @Currency
				INNER JOIN dbo.Dep_CustBetSetting_Agent sbl WITH (NOLOCK)  ON ft.SportType = sbl.sporttype  AND ft.BetType = sbl.bettype AND sbl.custid = @UplineID  
				
			WHERE bl.custid = @CustID
			
			
		END
		ELSE IF @RoleID = 1
		BEGIN
			SELECT ft.SportType  
				, ft.BetType  
				, bl.MinBet  
				, bl.MaxBet  
				, bl.MaxPerMatch  
				, CASE  WHEN sbl.minbet > pbs.MinBet  THEN sbl.minbet  ELSE pbs.MinBet  END AS MinBetMin  
				, sbl.maxbet AS MaxBetMax  
				, sbl.maxpermatch AS MaxPerMatchMax
			FROM #SportBettypeFilter ft 
				INNER JOIN dbo.Dep_CustBetSetting_Member bl WITH (NOLOCK) ON ft.SportType = bl.sporttype AND ft.BetType = bl.bettype 
				INNER JOIN dbo.Dep_ProductBetSetting pbs WITH (NOLOCK) ON pbs.SportType = bl.sporttype AND pbs.BetType = bl.bettype AND pbs.Currency = @Currency
				INNER JOIN dbo.Dep_CustBetSetting_Agent sbl WITH (NOLOCK)  ON ft.SportType = sbl.sporttype  AND ft.BetType = sbl.bettype AND sbl.custid = @UplineID  
			WHERE bl.custid = @CustID
		END
	END
	
	DROP TABLE #SportBettypeFilter
END

GO
GRANT EXECUTE ON [dbo].[Acc_Dep_CustSetting_BetLimitSettingSelect] TO [bodbadminNet]
GO
GRANT EXECUTE ON [dbo].[Acc_Dep_CustSetting_BetLimitSettingSelect] TO [bodbDownlineNet]
GO
GRANT EXECUTE ON [dbo].[Acc_Dep_CustSetting_BetLimitSettingSelect] TO [bodbExtAccNet]
GO
GRANT EXECUTE ON [dbo].[Acc_Dep_CustSetting_BetLimitSettingSelect] TO [bodbLicenseeNet]


