/*
	Created: 20170626@Helen
	Task: insert the Setting of BetradarVS of new licensees into the DCS database.
	Redmine: https://redmine.nexcel.vn/issues/77274
	DB: DBCUST/CUSTDB
*/ 

DECLARE @SportType_VSSoccer INT = 180

CREATE TABLE #tblCust_SMA (custid INT,SportType SMALLINT, Bettype SMALLINT,  minbet MONEY, maxbet MONEY, maxpermatch180 MONEY, ID INT IDENTITY(1,1))

CREATE TABLE #tblCust_member (custid INT,SportType SMALLINT, Bettype SMALLINT,  minbet MONEY, maxbet MONEY, maxpermatch180 MONEY, ID INT IDENTITY(1,1))

-------------------------------------DATA PREPARATION --------------------------------------------	
INSERT INTO #tblCust_SMA (custid,SportType,Bettype, minbet, maxbet, maxpermatch180 )			
SELECT CBS.CustID,CBS.SportType,CBS.BetType, CS.minbet, CS.maxbet, CI.maxpermatch180
FROM Dep_CustBetSetting_Agent CBS WITH (NOLOCK) 
	INNER JOIN custInfo CI WITH (NOLOCK) ON CBS.CustID = ci.custid 
	INNER JOIN Dep_CustSetting3rd cs WITH(NOLOCK) ON CBS.CustID = CS.custid AND CS.sporttype = @SportType_VSSoccer
WHERE cbs.SportType IN (190,191,199)
	AND (CBS.MinBet <> CS.minbet OR CBS.MaxBet <> CS.maxbet OR CBS.MaxPerMatch <> CI.maxpermatch180)

INSERT INTO #tblCust_member (custid,SportType,Bettype, minbet, maxbet, maxpermatch180 )			
SELECT CBS.CustID,CBS.SportType,CBS.BetType, CS.minbet, CS.maxbet, CI.maxpermatch180
FROM Dep_CustBetSetting_Agent CBS WITH (NOLOCK) 
	INNER JOIN custInfo CI WITH (NOLOCK) ON CBS.CustID = ci.custid 
	INNER JOIN Dep_CustSetting3rd cs WITH(NOLOCK) ON CBS.CustID = CS.custid AND CS.sporttype = @SportType_VSSoccer
WHERE cbs.SportType IN (190,191,199)
	AND (CBS.MinBet <> CS.minbet OR CBS.MaxBet <> CS.maxbet OR CBS.MaxPerMatch <> CI.maxpermatch180)

-------------------------------------ADJUST BET SETTING --------------------------------------------		
DECLARE @StartRow INT = 1, @MaxRow INT,@Threshold INT = 1000, @StopRow INT
-- SMA Adjust
SET @MaxRow = (SELECT MAX(ID) FROM #tblCust_SMA)

IF @MaxRow > 0
BEGIN
	IF @MaxRow <= 1000
	BEGIN
		UPDATE cbs
					SET minbet = CI.minbet
					, maxbet = CI.maxbet
					, maxpermatch = CI.maxpermatch180
				FROM Dep_CustBetSetting_Agent CBS WITH (ROWLOCK,UPDLOCK) 
					INNER JOIN #tblCust_SMA CI WITH (NOLOCK) ON CBS.CustID = ci.custid AND CBS.SportType = CI.SportType AND CBS.BetType = CI.Bettype
	END
	ELSE -- RUN Batch by Batch, maximum of 1000 rows for each batch to make sure it's not affect to replication
	BEGIN
		IF @Threshold >= @MaxRow
			SET @Threshold = @MaxRow

		SET @StopRow = @Threshold

		IF EXISTS( SELECT 1 FROM #tblCust_SMA)
		BEGIN
			WHILE (1=1)
			BEGIN
				/* FOR debug
				PRINT @StartRow
				PRINT @StopRow
				*/
				
				UPDATE cbs
					SET minbet = CI.minbet
					, maxbet = CI.maxbet
					, maxpermatch = CI.maxpermatch180
				FROM Dep_CustBetSetting_Agent CBS WITH (ROWLOCK,UPDLOCK) 
					INNER JOIN #tblCust_SMA CI WITH (NOLOCK) ON CBS.CustID = ci.custid AND CBS.SportType = CI.SportType AND CBS.BetType = CI.Bettype
				WHERE  CI.ID >= @StartRow AND CI.ID <= @StopRow
				
				IF @StopRow = @MaxRow BREAK
				
				SET @StartRow = @StopRow + 1
				
				SET @StopRow =  @StopRow + 1 + @Threshold
				
				IF @StopRow >= @MaxRow
					SET @StopRow = @MaxRow
				
			END
		END	
	END
END
-- Member Adjust
SET @StartRow  = 1

SET @Threshold  = 1000

SET @MaxRow = (SELECT MAX(ID) FROM #tblCust_member)

IF @MaxRow > 0

BEGIN
	IF @MaxRow <= 1000
	BEGIN
		UPDATE cbs
			SET minbet = CI.minbet
				, maxbet = CI.maxbet
				, maxpermatch = CI.maxpermatch180
		FROM Dep_CustBetSetting_Member CBS WITH (ROWLOCK,UPDLOCK) 
			INNER JOIN #tblCust_member CI WITH (NOLOCK) ON CBS.CustID = ci.custid AND CBS.SportType = CI.SportType AND CBS.BetType = CI.Bettype
	END
	ELSE -- RUN Batch by Batch, maximum of 1000 rows for each batch to make sure it's not affect to replication
	BEGIN
		IF @Threshold >= @MaxRow
			SET @Threshold = @MaxRow

		SET @StopRow = @Threshold

		IF EXISTS( SELECT 1 FROM #tblCust_member)
		BEGIN
			WHILE (1=1)
			BEGIN
				/* FOR debug
				PRINT @StartRow
				PRINT @StopRow
				*/
				
				UPDATE cbs
					SET minbet = CI.minbet
						, maxbet = CI.maxbet
						, maxpermatch = CI.maxpermatch180
				FROM Dep_CustBetSetting_Member CBS WITH (ROWLOCK,UPDLOCK) 
					INNER JOIN #tblCust_member CI WITH (NOLOCK) ON CBS.CustID = ci.custid AND CBS.SportType = CI.SportType AND CBS.BetType = CI.Bettype
				WHERE  CI.ID >= @StartRow AND CI.ID <= @StopRow
				
				IF @StopRow = @MaxRow BREAK
				
				SET @StartRow = @StopRow + 1
				
				SET @StopRow =  @StopRow + 1 + @Threshold
				
				IF @StopRow >= @MaxRow
					SET @StopRow = @MaxRow
				
			END
		END	
	END
END
	
DROP TABLE #tblCust_SMA
DROP TABLE #tblCust_member

