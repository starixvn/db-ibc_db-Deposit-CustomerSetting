/*<info serverAlias="DBACC-bodb02" executers="" viewers="vnteam" isFunction="0"></info>*/
ALTER PROCEDURE [Task_Dep_Customer_Archive_ScanCustomer]
	 @agentID INT, 
	 @minBalance MONEY, 
	 @minDays INT,
	 @custIDBalanceDummy INT,
	 @CheckStatement_DaysPerBatch INT = 10,
	 @CheckBettrans_CustPerBatch INT = 2000
AS
/*
	Created: 20180911@Kean
	Task: Scan Dormant Customer By Conditions
	DB: DBACC/bodb02
	Original: Task_Dep_Customer_Archive_ScanCustomer

	Revisions:
		- 20180911@Kean: First commit
		- 20190118@Dominic: Improve performance
		- 20190304@Dominic: Delete existing dormant members
		- 20190312@Dominic: Improve performance - #109528

	Param's Explanation:
		- @CheckStatement_DaysPerBatch: Number of cutomers in a batch which will be checked if they have bet tickets in statement
		- @CheckBettrans_CustPerBatch: Number of cutomers in a batch which will be checked if they have bet tickets in bettrans/translog..
*/
BEGIN
		TRUNCATE TABLE bodb_Report.dbo.Tmp_Dep_Customer_Archived

		SET NOCOUNT ON
		DECLARE @MinBettingDate DATETIME

		SET @MinBettingDate = DATEADD(dd, -@minDays, CAST(GETDATE() AS DATE))
		CREATE TABLE #Member 
		(
			custid int PRIMARY KEY, username varchar(50), username2 varchar(50), memberBalance MONEY default 0, isProcessed INT default 0
		)

		CREATE TABLE #BettingMember 
		(
			custid INT
		)

		CREATE TABLE #tmpMember 
		(
			custid INT
		)

	-- 1.Get infor of all customer in Customer and custinfo table
		INSERT INTO #Member (custid, username, username2)
		SELECT cust.custid, cust.username, cust.username2
		FROM customer cust WITH (NOLOCK)
		INNER JOIN custInfo ci (NOLOCK) ON cust.custid = ci.custid
		WHERE cust.roleid = 1
			AND cust.recommend = @agentID
			AND (cust.creatdate < @MinBettingDate)
			AND cust.srecommend IN (SELECT custid FROM Dep_CustSuper (NOLOCK))
			AND ISNULL(BonusWalletFlag,0) = 0
		

		DELETE FROM #Member
		WHERE custid IN (SELECT custid FROM DBCUST.CustDB.dbo.Dep_Customer_Archived_Exception WITH (NOLOCK))

		DELETE FROM #Member
		WHERE custid IN (SELECT custid FROM bodb02.dbo.Dep_Customer_Archived WITH (NOLOCK))

		-- Remove CustIDBalanceDummy out of the list betting member if exist
		DELETE FROM #Member
		WHERE custid = @custIDBalanceDummy
		-- Remove account like BetTrade and CashOut, ClearBal
		DELETE FROM #Member
		WHERE  username LIKE '%BetTrade%' OR username LIKE '%CashOut%' OR username LIKE '%ClearBal%'

		IF EXISTS(SELECT 1 FROM #Member)
		BEGIN
			-- 2. Get List Member have bet ticket in #Member table (can apply batch processing)
			-- Apply loop by date for bodb_Report.dbo.STATEMENT table

			DECLARE @fromDate_e DATETIME, @toDate_e DATETIME, @toDate DATETIME

			SET @fromDate_e = @MinBettingDate
			SET @toDate_e = DATEADD(DAY, @CheckStatement_DaysPerBatch, @fromDate_e)

			SET @toDate = CAST(GETDATE() AS DATE)
	
			IF @toDate_e > @toDate SELECT @toDate_e = @toDate
	
			WHILE @fromDate_e <= @toDate	
			BEGIN

				INSERT INTO #BettingMember (custid)	
				SELECT DISTINCT custid 
						FROM bodb_Report.dbo.STATEMENT st WITH  (NOLOCK, FORCESEEK)
						WHERE accDate >= @fromDate_e AND accDate < @toDate_e
						AND TransType <> N'bal' 
						AND st.custid IN ( SELECT custid 
										   FROM #Member m)
				
				DELETE FROM #Member
				WHERE custid IN (SELECT custid FROM #BettingMember)
				
				TRUNCATE TABLE #BettingMember

				IF @toDate_e = @toDate
							BREAK;

				SELECT @fromDate_e = @toDate_e
				SELECT @toDate_e = DATEADD(DAY, @CheckStatement_DaysPerBatch, @fromDate_e)
				IF @toDate_e > @toDate SELECT @toDate_e = @toDate
			 END
	
			WHILE(1=1)
			BEGIN
				TRUNCATE TABLE #tmpMember

				INSERT INTO #tmpMember
				SELECT TOP (@CheckBettrans_CustPerBatch) custid
				FROM #Member WHERE isProcessed = 0	
				IF (@@ROWCOUNT = 0) BREAK

				INSERT INTO #BettingMember (custid)
				SELECT custid 
				FROM #tmpMember m
				WHERE EXISTS (
						SELECT custid
						FROM bettrans b with (NOLOCK)
						WHERE bettype <> 20000 AND b.custid = m.custid
					)

				INSERT INTO #BettingMember (custid)
				SELECT custid 
				FROM #tmpMember m
				WHERE EXISTS (
					SELECT custid
					FROM translog b with (NOLOCK)
					WHERE b.custid = m.custid
					)

				INSERT INTO #BettingMember (custid)
				SELECT custid 
				FROM #tmpMember m
				where EXISTS (
					SELECT custid
					FROM bettransRNG b with (NOLOCK)
					WHERE b.custid = m.custid
					)
			
				INSERT INTO #BettingMember (custid)
				SELECT custid 
				FROM #tmpMember m
				WHERE EXISTS (
						SELECT custid
						FROM bettransLC b with (NOLOCK)
						WHERE b.custid = m.custid
					)

				UPDATE #Member
				SET isProcessed = 1
				WHERE custid IN (SELECT custid FROM #tmpMember)

			END
	
			DELETE FROM #Member
			WHERE custid IN (SELECT custid FROM #BettingMember)

		-- 3. Update balance of all member in #Member (can apply batch processing)

			WHILE(1=1)
			BEGIN
				TRUNCATE TABLE #tmpMember -- Reuse #tmpMember table for updating balance

				INSERT INTO #tmpMember
				SELECT TOP (@CheckBettrans_CustPerBatch) custid
				FROM #Member WHERE isProcessed = 1
				IF (@@ROWCOUNT = 0) BREAK

				UPDATE #Member SET memberBalance = b.MemberBalance
				FROM #Member
				INNER JOIN (
					SELECT custid, ISNULL(SUM(winlost-actual_stake+playercomm),0) as MemberBalance
					FROM bettrans WITH (NOLOCK)
					WHERE custid IN (SELECT custid FROM #tmpMember)
					GROUP BY custid
					) b ON #Member.custid = b.custid

				UPDATE #Member
				SET isProcessed = 2
				WHERE custid IN (SELECT custid FROM #tmpMember)

			END
	
		END

	-- 4. Get member in #Member table and exclude Bettrade, CashOut account
	INSERT INTO bodb_Report.dbo.Tmp_Dep_Customer_Archived(ArchivedDate, CustID, username, username2, recommend, ClosingBalance, CustIDBalanceDummy, status)
	SELECT GetDate() ArchivedDate, m.custid, m.username, m.username2, c.recommend,memberBalance, @custIDBalanceDummy CustIDBalanceDummy, 'waiting' Status
	FROM #Member m
	INNER JOIN Customer c (NOLOCK)
		ON m.custid = c.custid
	WHERE memberBalance <= @minBalance


	DROP TABLE #tmpMember
	DROP TABLE #BettingMember
	DROP TABLE #Member
END
