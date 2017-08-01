/*
	Created: 20170626@Helen
	Task: insert the Setting of VS of new licensees into the DCS database.
	Redmine: https://redmine.nexcel.vn/issues/77274
	DB: DBCUST/CUSTDB
*/ 

CREATE TABLE #SportTypeCheck (SportType SMALLINT, BetType SMALLINT, MaxPerMatchName VARCHAR(200), PRIMARY KEY (SportType,Bettype) )	
INSERT INTO #SportTypeCheck 
VALUES
	(180,1201,'maxpermatch180'),
	(181,1231,'maxpermatch181'),
	(182,1231,'maxpermatch182'),
	(183,1231,'maxpermatch183'),
	(184,1231,'maxpermatch184'),
	(185,1231,'maxpermatch185'),
	(186,1220,'maxpermatch186')

CREATE TABLE #tblCust_SMA (custid INT,SportType SMALLINT, Bettype SMALLINT,  minbet MONEY, maxbet MONEY, maxpermatch MONEY, ID INT IDENTITY(1,1))

CREATE TABLE #tblCust_member (custid INT,SportType SMALLINT, Bettype SMALLINT,  minbet MONEY, maxbet MONEY, maxpermatch MONEY, ID INT IDENTITY(1,1))

-------------------------------------DATA PREPARATION --------------------------------------------	
INSERT INTO #tblCust_SMA (custid,SportType,Bettype, minbet, maxbet, maxpermatch)			
SELECT CBS.CustID,CBS.SportType,CBS.BetType, CS.minbet, CS.maxbet, A.maxpermatch
FROM Dep_CustBetSetting_Agent CBS WITH (NOLOCK) 
	INNER JOIN custInfo C WITH (NOLOCK) ON C.custid = CBS.CustID
	INNER JOIN Dep_CustSetting3rd CS WITH(NOLOCK) ON CBS.CustID = CS.custid AND CBS.SportType = CS.sporttype AND CBS.BetType = CS.bettype
	CROSS APPLY( VALUES
			('maxpermatch180',C.maxpermatch180),
			('maxpermatch181',C.maxpermatch181),
			('maxpermatch182',C.maxpermatch182),
			('maxpermatch183',C.maxpermatch183),
			('maxpermatch184',C.maxpermatch184),
			('maxpermatch185',C.maxpermatch185),
			('maxpermatch186',C.maxpermatch186)
	 ) AS A(columnname, maxpermatch)
   INNER JOIN #SportTypeCheck S ON S.MaxPerMatchName = A.columnname AND CS.SportType = S.SportType AND CS.BetType = S.BetType
WHERE (cbs.MinBet <> cs.minbet OR cbs.MaxBet <> cs.maxbet OR cbs.MaxPerMatch <> a.maxpermatch)
	AND CBS.SportType IN (180,181,182,183,184,185,186)

INSERT INTO #tblCust_member (custid,SportType,Bettype, minbet, maxbet, maxpermatch )			
SELECT CBS.CustID,CBS.SportType,CBS.BetType, CS.minbet, CS.maxbet, A.maxpermatch
FROM Dep_CustBetSetting_Member CBS WITH (NOLOCK) 
	INNER JOIN custInfo C WITH (NOLOCK) ON C.custid = CBS.CustID 
	INNER JOIN Dep_CustSetting3rd CS WITH(NOLOCK) ON CBS.CustID = CS.custid AND CBS.SportType = CS.sporttype AND CBS.BetType = CS.bettype
	CROSS APPLY( VALUES
			('maxpermatch180',C.maxpermatch180),
			('maxpermatch181',C.maxpermatch181),
			('maxpermatch182',C.maxpermatch182),
			('maxpermatch183',C.maxpermatch183),
			('maxpermatch184',C.maxpermatch184),
			('maxpermatch185',C.maxpermatch185),
			('maxpermatch186',C.maxpermatch186)
	 ) AS A(columnname, maxpermatch)
   INNER JOIN #SportTypeCheck S ON S.MaxPerMatchName = A.columnname AND CS.SportType = S.SportType AND CS.BetType = S.BetType
WHERE (cbs.MinBet <> cs.minbet OR cbs.MaxBet <> cs.maxbet OR cbs.MaxPerMatch <> a.maxpermatch)
	AND CBS.SportType IN (180,181,182,183,184,185,186)

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
			, maxpermatch = CI.maxpermatch
		FROM Dep_CustBetSetting_Agent CBS WITH (ROWLOCK,UPDLOCK) 
			INNER JOIN #tblCust_SMA CI WITH (NOLOCK) ON CI.custid = CBS.CustID AND CBS.SportType = CI.SportType AND CBS.BetType = CI.Bettype
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
						, maxpermatch = CI.maxpermatch
				FROM Dep_CustBetSetting_Agent CBS WITH (ROWLOCK,UPDLOCK) 
					INNER JOIN #tblCust_SMA CI WITH (NOLOCK) ON CI.custid = CBS.CustID AND CBS.SportType = CI.SportType AND CBS.BetType = CI.Bettype
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
				, maxpermatch = CI.maxpermatch
		FROM Dep_CustBetSetting_Member CBS WITH (ROWLOCK,UPDLOCK) 
			INNER JOIN #tblCust_member CI WITH (NOLOCK) ON CI.custid = CBS.CustID AND CBS.SportType = CI.SportType AND CBS.BetType = CI.Bettype
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
					, maxpermatch = CI.maxpermatch
				FROM Dep_CustBetSetting_Member CBS WITH (ROWLOCK,UPDLOCK) 
					INNER JOIN #tblCust_member CI WITH (NOLOCK) ON CI.custid = CBS.CustID AND CBS.SportType = CI.SportType AND CBS.BetType = CI.Bettype
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
DROP TABLE #SportTypeCheck



