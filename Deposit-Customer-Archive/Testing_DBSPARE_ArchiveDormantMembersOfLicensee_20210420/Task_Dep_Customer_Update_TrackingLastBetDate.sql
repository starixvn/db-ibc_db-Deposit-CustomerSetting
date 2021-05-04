/*<info serverAlias="DBSPARE-bodb02" executers="" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [Task_Dep_Customer_Update_TrackingLastBetDate]
AS
/*
	Created: 20200218@Eden
	Task: Job daily scan to Update LastBetDate for Cust_TrackingLastBetDate ( use for Scan Dormant Customer )
	DB: DBACC/bodb02

	Revisions:
		- 20200218@Eden: First commit  [#RM:125823]

	Param's Explanation:
*/
BEGIN

	-- simulate run date based on test data version
	declare @currentDate smalldatetime 
	select @currentDate = VValue from bodb02.dbo.Systemsettings with (nolock) where VName = 'aa_TestDate'

	DECLARE @CheckBettrans_CustPerBatch  INT = 5000
	DECLARE @ScanDate DATE = @currentDate - 1

	CREATE TABLE #Cust (custid int primary key)
	CREATE TABLE #Agent (AgentID int PRIMARY KEY)

	CREATE TABLE #Cust_TrackingLastBetDate 
	(
		  custid int 
		, LastBetDate DATETIME
	)

	CREATE TABLE #tmpMember 
	(
		custid INT PRIMARY KEY,
		LastBetDate DATETIME,
		IsUpdate BIT default 0
	)

	CREATE TABLE #BettingMember 
	(
		custid INT PRIMARY KEY
		,LastBetDate DATETIME 
	)

	INSERT INTO #Agent (AgentID)
	SELECT cust.custid
	FROM customer cust WITH (NOLOCK)
		INNER JOIN custInfo ci (NOLOCK) ON cust.custid = ci.custid
	WHERE cust.roleid = 2
		AND cust.srecommend IN (SELECT custid FROM Dep_CustSuper (NOLOCK))
		AND cust.username NOT LIKE '%ACC%' 
	
	INSERT INTO #Cust(custid)
	SELECT cust.custid
	FROM customer cust WITH (NOLOCK)
		INNER JOIN custInfo ci WITH (NOLOCK) ON cust.custid = ci.custid
		INNER JOIN #Agent ag ON ag.AgentID = ci.recommend
	WHERE cust.roleid = 1
		AND ci.username NOT LIKE '%BetTrade%' 
		AND ci.username NOT LIKE '%CashOut%' 
		AND ci.username NOT LIKE '%ClearBal%'
		AND ci.username NOT LIKE '%01OddsAdj%'

	DELETE 
	FROM #Cust 
	WHERE custid IN ( SELECT CustID FROM custdb.dbo.Dep_Customer_Archived WITH (NOLOCK) WHERE status IN ('archived','completed') )
	
	DELETE 
	FROM #Cust 
	WHERE custid IN ( SELECT custid FROM CustDB.dbo.Dep_Customer_Archived_Exception WITH (NOLOCK))

	INSERT INTO Cust_TrackingLastBetDate(CustID)
	SELECT CustID 
	FROM #Cust
	WHERE custid NOT IN ( SELECT custid FROM dbo.Cust_TrackingLastBetDate WITH (NOLOCK))

	INSERT INTO #BettingMember(custid)
	SELECT b.custid
	FROM Dep_CustSuper c WITH(NOLOCK)
		INNER JOIN bettrans b with (NOLOCK,forceseek) ON c.CustID = b.srecommend
	WHERE bettype NOT IN(19999, 20000) 
		AND b.transdate >= @ScanDate
	UNION
	SELECT  b.custid
	FROM #Agent c
		INNER JOIN bettransRnG b with (NOLOCK) ON c.AgentID = b.recommend
	WHERE b.transdate >= @ScanDate
	UNION
	SELECT b.custid
	FROM #Agent c
		INNER JOIN bettransLC b with (NOLOCK) ON c.AgentID = b.recommend
	WHERE b.transdate >= @ScanDate
	UNION
	SELECT b.custid
	FROM #Agent c
		INNER JOIN translog b with (NOLOCK) ON c.AgentID = b.recommend
	WHERE b.transdate >= @ScanDate
	--UNION
	--SELECT b.custid
	--FROM #Agent c
	--	INNER JOIN DBPTCS.bodb02.dbo.bettrans_AGCasino b with (NOLOCK) ON c.AgentID = b.recommend
	--WHERE b.transdate >= @ScanDate
	--UNION
	--SELECT b.custid
	--FROM #Agent c
	--	INNER JOIN DBPTCS.bodb02.dbo.bettrans_GoldDeluxe b with (NOLOCK) ON c.AgentID = b.recommend
	--WHERE b.transdate >= @ScanDate

	INSERT INTO #Cust_TrackingLastBetDate(custid, LastBetDate)
	SELECT c.custid, ISNULL(c.LastBetDate,'1900/01/01') AS LastBetDate
	FROM Cust_TrackingLastBetDate c WITH(NOLOCK)
		INNER JOIN #BettingMember b ON c.CustID = b.custid

	WHILE ( 1 = 1 )
	BEGIN
		TRUNCATE TABLE #tmpMember

		DELETE TOP (@CheckBettrans_CustPerBatch) a
		OUTPUT deleted.custid,deleted.LastBetDate INTO #tmpMember(custid,LastBetDate)
		FROM #Cust_TrackingLastBetDate a
		
		IF (@@ROWCOUNT = 0) 
			BREAK

		--> scan ticket from bettrans
		TRUNCATE TABLE #BettingMember
		INSERT INTO #BettingMember(custid,LastBetDate)
		SELECT b.custid, MAX(b.transdate) AS transdate
		FROM bettrans b with (NOLOCK)
			INNER JOIN #tmpMember t ON t.custid = b.custid
		WHERE bettype NOT IN(19999, 20000)
			AND b.transdate > t.LastBetDate 
			AND b.transdate >= @ScanDate
		GROUP BY b.custid

		UPDATE a
		SET  a.LastBetDate = b.LastBetDate
			,a.IsUpdate = 1
		FROM #tmpMember a
			INNER JOIN #BettingMember b ON a.custID = b.custid

		--> scan ticket from bettransRNG
		TRUNCATE TABLE #BettingMember
		INSERT INTO #BettingMember(custid,LastBetDate)
		SELECT b.custid, MAX(b.transdate) AS transdate
		FROM bettransRNG b with (NOLOCK)
			INNER JOIN #tmpMember t ON t.custid = b.custid
		WHERE b.transdate > t.LastBetDate 
			AND b.transdate >= @ScanDate
		GROUP BY b.custid

		UPDATE a
		SET  a.LastBetDate = b.LastBetDate
			,a.IsUpdate = 1
		FROM #tmpMember a
			INNER JOIN #BettingMember b ON a.custID = b.custid

		----> scan ticket from bettransLC
		TRUNCATE TABLE #BettingMember
		INSERT INTO #BettingMember(custid,LastBetDate)
		SELECT b.custid, MAX(b.transdate) AS transdate
		FROM bettransLC b with (NOLOCK)
			INNER JOIN #tmpMember t ON t.custid = b.custid
		WHERE b.transdate > t.LastBetDate 
			AND b.transdate >= @ScanDate
		GROUP BY b.custid

		UPDATE a
		SET  a.LastBetDate = b.LastBetDate
			,a.IsUpdate = 1
		FROM #tmpMember a
			INNER JOIN #BettingMember b ON a.custID = b.custid

		----> scan ticket from translog
		TRUNCATE TABLE #BettingMember
		INSERT INTO #BettingMember(custid,LastBetDate)
		SELECT b.custid, MAX(b.transdate) AS transdate
		FROM translog b with (NOLOCK)
			INNER JOIN #tmpMember t ON t.custid = b.custid
		WHERE b.transdate > t.LastBetDate 
			AND b.transdate >= @ScanDate
		GROUP BY b.custid

		UPDATE a
		SET  a.LastBetDate = b.LastBetDate
			,a.IsUpdate = 1
		FROM #tmpMember a
			INNER JOIN #BettingMember b ON a.custID = b.custid

		------> scan ticket from DBPTCS.bodb02.dbo.bettrans_AGCasino
		--TRUNCATE TABLE #BettingMember
		--INSERT INTO #BettingMember(custid,LastBetDate)
		--SELECT b.custid, MAX(b.transdate) AS transdate
		--FROM DBPTCS.bodb02.dbo.bettrans_AGCasino b with (NOLOCK)
		--	INNER JOIN #tmpMember t ON t.custid = b.custid
		--WHERE b.transdate > t.LastBetDate 
		--	AND b.transdate >= @ScanDate
		--GROUP BY b.custid

		--UPDATE a
		--SET  a.LastBetDate = b.LastBetDate
		--	,a.IsUpdate = 1
		--FROM #tmpMember a
		--	INNER JOIN #BettingMember b ON a.custID = b.custid

		------> scan ticket from DBPTCS.bodb02.dbo.bettrans_GoldDeluxe
		--TRUNCATE TABLE #BettingMember
		--INSERT INTO #BettingMember(custid,LastBetDate)
		--SELECT b.custid, MAX(b.transdate) AS transdate
		--FROM DBPTCS.bodb02.dbo.bettrans_GoldDeluxe b with (NOLOCK)
		--	INNER JOIN #tmpMember t ON t.custid = b.custid
		--WHERE b.transdate > t.LastBetDate 
		--	AND b.transdate >= @ScanDate
		--GROUP BY b.custid

		--UPDATE a
		--SET  a.LastBetDate = b.LastBetDate
		--	,a.IsUpdate = 1
		--FROM #tmpMember a
		--	INNER JOIN #BettingMember b ON a.custID = b.custid

		UPDATE a
		SET a.LastBetDate = b.LastBetDate
		FROM Cust_TrackingLastBetDate a WITH(ROWLOCK)
			INNER JOIN #tmpMember b ON a.custID = b.custid
		WHERE b.IsUpdate = 1

	END

	--> Process scan DBPTCS.bodb02 tables
	TRUNCATE TABLE #BettingMember
	INSERT INTO #BettingMember(custid,LastBetDate)
	SELECT custid, transdate
	FROM OPENQUERY (DBNOTI, ';WITH TMP AS(
								SELECT b.custid, b.transdate
								FROM bodb02.dbo.bettrans_AGCasino b with (NOLOCK)
								WHERE transdate >= CONVERT(DATE, getdate() - 1)
								UNION ALL
								SELECT b.custid, b.transdate
								FROM bodb02.dbo.bettrans_GoldDeluxe b with (NOLOCK)
								WHERE transdate >= CONVERT(DATE, getdate() - 1)
							)
							SELECT CustID, MAX(transdate) AS transdate 
							FROM tmp
							GROUP BY CustID')

	IF EXISTS( SELECT 1 FROM #BettingMember)
		BEGIN
		WHILE ( 1 = 1 )
		BEGIN
			TRUNCATE TABLE #tmpMember

			DELETE TOP (@CheckBettrans_CustPerBatch) a
			OUTPUT deleted.custid,deleted.LastBetDate INTO #tmpMember(custid,LastBetDate)
			FROM #BettingMember a
		
			IF (@@ROWCOUNT = 0) 
				BREAK

			UPDATE a
			SET a.LastBetDate = b.LastBetDate
			FROM Cust_TrackingLastBetDate a WITH(ROWLOCK)
				INNER JOIN #tmpMember b ON a.custID = b.custid
			WHERE b.LastBetDate > ISNULL(a.LastBetDate, '1900/01/01') 
		END
	END

	DELETE a
	FROM Cust_TrackingLastBetDate a WITH(ROWLOCK)
	WHERE a.CustID IN (SELECT CustID FROM custdb.dbo.Dep_Customer_Archived WITH (NOLOCK) WHERE status IN ('archived','completed'))

	DROP TABLE #BettingMember
	DROP TABLE #Cust
	DROP TABLE #Cust_TrackingLastBetDate
	DROP TABLE #tmpMember
	DROP TABLE #Agent
END
GO