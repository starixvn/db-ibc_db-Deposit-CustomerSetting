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
		- 20220928@Eden: Remove scanning on bettrans_GoldDeluxe, scan bettrans_AGCasino based on winlostdate instead of transdate [#RM:178300]
		- 20241121@Eden: Remove PK of #tmpMember, fix dirty read issue  [#RM:125823]
		- 20250610@Tacy: Check Exchange ticket  [#RM:230025]
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
		custid INT,
		LastBetDate DATETIME,
		IsUpdate BIT default 0
	)

	CREATE CLUSTERED INDEX IX_tmpMember  ON #tmpMember(custid ASC)

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
	FROM OPENQUERY (DBPTCS, ' SELECT b.custid, MAX(b.Winlostdate) AS transdate
							  FROM bodb_PlaytechCS.dbo.bettrans_AGCasino b with (NOLOCK)
							  WHERE Winlostdate >= CONVERT(DATE,GETDATE() - 1)
							  GROUP BY custid')

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

	--> Process scan Bettrans_Exchange
	TRUNCATE TABLE #BettingMember

	INSERT INTO #BettingMember(custid,LastBetDate)
	SELECT custid, DATEADD(HOUR, -12, transdate)
	FROM OPENQUERY (DBLIC, ' SELECT b.custid AS custid
									, MAX(b.betPlaced) AS transdate
							  FROM bodb_3rdProduct.dbo.Bettrans_Exchange b with (NOLOCK)
							  WHERE betPlaced >= CONVERT(DATE, DATEADD(HOUR, 12, GETDATE()) - 1) -- convert: GMT-4 --> GMT+8
							  GROUP BY b.custid')

	DELETE b
	FROM #BettingMember b
	LEFT JOIN bodb02..Customer c WITH (NOLOCK) ON b.custid=c.custid
	WHERE c.custid IS NULL

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