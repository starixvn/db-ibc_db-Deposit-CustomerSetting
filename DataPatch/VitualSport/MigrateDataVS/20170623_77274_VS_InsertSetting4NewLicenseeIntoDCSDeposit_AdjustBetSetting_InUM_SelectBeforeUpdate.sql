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

CREATE TABLE #tblCust_SMA (custid INT,SportType SMALLINT, Bettype SMALLINT,  minbet MONEY, maxbet MONEY, maxpermatch MONEY)

CREATE TABLE #tblCust_member (custid INT,SportType SMALLINT, Bettype SMALLINT,  minbet MONEY, maxbet MONEY, maxpermatch MONEY)

-------------------------------------DATA PREPARATION --------------------------------------------	
INSERT INTO #tblCust_SMA (custid,SportType,Bettype, minbet, maxbet, maxpermatch )			
SELECT CBS.CustID,CBS.SportType,CBS.BetType, CS.minbet, CS.maxbet, A.maxpermatch
FROM Dep_CustBetSetting_Agent CBS WITH (ROWLOCK,UPDLOCK) 
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
FROM Dep_CustBetSetting_Member CBS WITH (ROWLOCK,UPDLOCK) 
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
-- SMA Adjust
UPDATE cbs
	SET minbet = CI.minbet
	, maxbet = CI.maxbet
	, maxpermatch = CI.maxpermatch
FROM Dep_CustBetSetting_Agent CBS WITH (ROWLOCK,UPDLOCK) 
	INNER JOIN #tblCust_SMA CI WITH (NOLOCK) ON CI.custid = CBS.CustID AND CBS.SportType = CI.SportType AND CBS.BetType = CI.Bettype

-- Member Adjust
UPDATE cbs
	SET minbet = CI.minbet
	, maxbet = CI.maxbet
	, maxpermatch = CI.maxpermatch
FROM Dep_CustBetSetting_Member CBS WITH (ROWLOCK,UPDLOCK) 
	INNER JOIN #tblCust_member CI WITH (NOLOCK) ON CI.custid = CBS.CustID AND CBS.SportType = CI.SportType AND CBS.BetType = CI.Bettype

DROP TABLE #SportTypeCheck
DROP TABLE #tblCust_SMA
DROP TABLE #tblCust_member


