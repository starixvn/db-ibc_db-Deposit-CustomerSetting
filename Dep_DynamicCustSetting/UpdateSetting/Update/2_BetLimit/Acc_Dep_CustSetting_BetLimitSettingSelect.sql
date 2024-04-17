/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet,bodbExtAccNet,bodbDownlineNet,wsv_lap" viewers="" isFunction="0"></info>*/
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
	
		SELECT @Currency = Currency, @RoleID = roleid, @srecommend = srecommend, @mrecommend = mrecommend, @recommend = recommend
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
				, bl.MinBet AS MinBetMin  
				, bl.maxbet AS MaxBetMax  
				, bl.maxpermatch AS MaxPerMatchMax
			FROM #SportBettypeFilter ft 
				INNER JOIN dbo.Dep_CustBetSetting_Agent bl WITH (NOLOCK) ON ft.SportType = bl.sporttype AND ft.BetType = bl.bettype 
			WHERE bl.custid = @CustID
		END
		
		ELSE IF @RoleID = 3
		BEGIN
			SELECT ft.SportType  
				, ft.BetType  
				, bl.MinBet  
				, bl.MaxBet  
				, bl.MaxPerMatch  
				, sbl.minbet AS MinBetMin  
				, sbl.maxbet AS MaxBetMax  
				, sbl.maxpermatch AS MaxPerMatchMax
			FROM #SportBettypeFilter ft 
				INNER JOIN dbo.Dep_CustBetSetting_Agent bl WITH (NOLOCK) ON ft.SportType = bl.sporttype AND ft.BetType = bl.bettype 
				INNER JOIN dbo.Dep_CustBetSetting_Agent sbl WITH (NOLOCK)  ON ft.SportType = sbl.sporttype  AND ft.BetType = sbl.bettype AND sbl.custid = @srecommend
			WHERE bl.custid = @CustID
			
		END
		ELSE IF @RoleID = 2
		BEGIN
			SELECT ft.SportType  
				, ft.BetType  
				, bl.MinBet  
				, bl.MaxBet  
				, bl.MaxPerMatch  
				, MAX(sbl.minbet) AS MinBetMin  
				, MIN(sbl.maxbet) AS MaxBetMax  
				, MIN(sbl.maxpermatch) AS MaxPerMatchMax
			FROM #SportBettypeFilter ft 
				INNER JOIN dbo.Dep_CustBetSetting_Agent bl WITH (NOLOCK) ON ft.SportType = bl.sporttype AND ft.BetType = bl.bettype 
				INNER JOIN dbo.Dep_CustBetSetting_Agent sbl WITH (NOLOCK)  ON ft.SportType = sbl.sporttype  AND ft.BetType = sbl.bettype AND sbl.custid IN (@srecommend,@mrecommend)  
			WHERE bl.custid = @CustID
			GROUP BY ft.SportType  
					, ft.BetType  
					, bl.MinBet  
					, bl.MaxBet  
					, bl.MaxPerMatch
			
			
		END
		
		ELSE IF @RoleID = 1
		BEGIN
			SELECT ft.SportType  
				, ft.BetType  
				, bl.MinBet  
				, bl.MaxBet  
				, bl.MaxPerMatch  
				, MAX(sbl.minbet) AS MinBetMin  
				, MIN(sbl.maxbet) AS MaxBetMax  
				, MIN(sbl.maxpermatch) AS MaxPerMatchMax
			FROM #SportBettypeFilter ft 
				INNER JOIN dbo.Dep_CustBetSetting_Member bl WITH (NOLOCK) ON ft.SportType = bl.sporttype AND ft.BetType = bl.bettype 
				INNER JOIN dbo.Dep_CustBetSetting_Agent sbl WITH (NOLOCK)  ON ft.SportType = sbl.sporttype  AND ft.BetType = sbl.bettype AND sbl.custid IN (@srecommend,@mrecommend,@recommend)  
			WHERE bl.custid = @CustID
			GROUP BY ft.SportType  
					, ft.BetType  
					, bl.MinBet  
					, bl.MaxBet  
					, bl.MaxPerMatch
		END
	END
	
	DROP TABLE #SportBettypeFilter
END

GO


