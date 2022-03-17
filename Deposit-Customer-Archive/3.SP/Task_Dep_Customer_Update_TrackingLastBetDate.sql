/*<info serverAlias="DBACC-bodb02" executers="" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [Task_Dep_Customer_Update_TrackingLastBetDate]
AS
/*
	Created: 20200218@Eden
	Task: Job daily scan to Update LastBetDate for Cust_TrackingLastBetDate ( use for Scan Dormant Customer )
	DB: DBACC/bodb02

	Revisions:
		- 20200218@Eden: First commit  [#RM:125823]
		- 20201210@Eden: LAP - Split Transfer out of bettrans [#RM:164301]

	Param's Explanation:
*/

BEGIN
	DECLARE @CheckBettrans_CustPerBatch  INT = 5000
	DECLARE @ScanDate DATE = GETDATE() - 1

	CREATE TABLE #DeletedCust (custid int)
	CREATE TABLE #Agent (AgentID int)

	CREATE NONCLUSTERED INDEX ix_TmpAgent_AgentID ON #Agent(AgentID)
	CREATE NONCLUSTERED INDEX ix_TmpDeletedCust_custid ON #DeletedCust(custid)

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

	--> get all real deposit agents 
	INSERT INTO #Agent (AgentID)
	SELECT cust.custid
	FROM customer cust WITH (NOLOCK)
		INNER JOIN custInfo ci (NOLOCK) ON cust.custid = ci.custid
	WHERE cust.roleid = 2
		AND cust.srecommend IN (SELECT custid FROM Dep_CustSuper (NOLOCK))
		AND cust.username NOT LIKE '%ACC%' 

	--> Get all deposit members (distinct) have bet ticket from yesterday to today (on all bettrans tables)
	INSERT INTO #BettingMember(custid)
	SELECT b.custid
	FROM Dep_CustSuper c WITH(NOLOCK)
		INNER JOIN transfer b with (NOLOCK,forceseek) ON c.CustID = b.srecommend
	WHERE bettype NOT IN(19999, 20000) 
		AND b.transdate >= @ScanDate
	UNION
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
	
	--> remove exclude members
	DELETE 
	FROM #BettingMember 
	WHERE custid IN ( SELECT custid FROM DBCUST.CustDB.dbo.Dep_Customer_Archived_Exception WITH (NOLOCK))

	--> Get all deposit members have ticket and the last bet ticket date before updated 
	INSERT INTO #Cust_TrackingLastBetDate(custid, LastBetDate)
	SELECT b.custid, ISNULL(c.LastBetDate,'1900/01/01') AS LastBetDate
	FROM #BettingMember b 
		INNER JOIN custInfo ci WITH(NOLOCK) ON ci.custid = b.custid AND ci.roleid = 1
		LEFT JOIN Cust_TrackingLastBetDate c WITH(NOLOCK) ON c.CustID = b.custid

	--> Scan to update Cust_TrackingLastBetDate.LastBetDate( and insert if not exists yet)
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

		--> scan ticket from transfer
		TRUNCATE TABLE #BettingMember
		INSERT INTO #BettingMember(custid,LastBetDate)
		SELECT b.custid, MAX(b.transdate) AS transdate
		FROM transfer b with (NOLOCK)
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

		UPDATE a
		SET a.LastBetDate = b.LastBetDate
		FROM Cust_TrackingLastBetDate a WITH(ROWLOCK)
			INNER JOIN #tmpMember b ON a.custID = b.custid
		WHERE b.IsUpdate = 1

		INSERT INTO Cust_TrackingLastBetDate(CustID,LastBetDate)
		SELECT t.CustID, t.LastBetDate 
		FROM #tmpMember t
			LEFT JOIN Cust_TrackingLastBetDate b WITH(NOLOCK)
				ON t.custid = b.CustID
		WHERE b.CustID IS NULL
	END

	--> Process scan DBPTCS.bodb_PlaytechCS tables, Get all deposit members (distinct) have bet ticket from yesterday to today
	TRUNCATE TABLE #BettingMember
	INSERT INTO #BettingMember(custid,LastBetDate)
	SELECT custid, transdate
	FROM OPENQUERY (DBPTCS, ';WITH TMP AS(
								SELECT b.custid, b.transdate
								FROM bodb_PlaytechCS.dbo.bettrans_AGCasino b with (NOLOCK)
								WHERE transdate >= CONVERT(DATE,GETDATE() - 1)
								UNION ALL
								SELECT b.custid, b.transdate
								FROM bodb_PlaytechCS.dbo.bettrans_GoldDeluxe b with (NOLOCK)
								WHERE transdate >= CONVERT(DATE,GETDATE() - 1)
							)
							SELECT CustID, MAX(transdate) AS transdate 
							FROM tmp
							GROUP BY CustID')

	--> Scan to update Cust_TrackingLastBetDate.LastBetDate( and insert if not exists yet)
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

			INSERT INTO Cust_TrackingLastBetDate(CustID,LastBetDate)
			SELECT t.CustID, t.LastBetDate 
			FROM #tmpMember t
				LEFT JOIN Cust_TrackingLastBetDate b WITH(NOLOCK)
					ON t.custid = b.CustID
			WHERE b.CustID IS NULL
		END
	END

	--Deleted from Cust_TrackingLastBetDate if customers are archived
	INSERT INTO #DeletedCust(custid)
	SELECT DISTINCT a.CustID --void dirty read
	FROM Cust_TrackingLastBetDate a WITH(NOLOCK)
	WHERE a.CustID IN (SELECT CustID FROM bodb02.dbo.Dep_Customer_Archived WITH (NOLOCK) WHERE status IN ('archived','completed'))

	WHILE 1 = 1
	BEGIN
		TRUNCATE TABLE #tmpMember

		DELETE TOP (@CheckBettrans_CustPerBatch) a
		OUTPUT deleted.custid INTO #tmpMember(custid)
		FROM #DeletedCust a

		IF (@@ROWCOUNT = 0) 
			BREAK

		DELETE c
		FROM #tmpMember a
			INNER JOIN Cust_TrackingLastBetDate c WITH(ROWLOCK,UPDLOCK)
				ON a.custid = c.CustID
		WHERE a.CustID IN (SELECT CustID FROM bodb02.dbo.Dep_Customer_Archived WITH (NOLOCK) WHERE status IN ('archived','completed'))
	END

	DROP TABLE #BettingMember
	DROP TABLE #Cust_TrackingLastBetDate
	DROP TABLE #tmpMember
	DROP TABLE #Agent
	DROP TABLE #DeletedCust
END
GO