/*
	Created: 20170626@Helen
	Task: insert the Setting of BetradarVS of new licensees into the DCS database.
	Redmine: https://redmine.nexcel.vn/issues/77274
	DB: DBCUST/CUSTDB
*/ 

DECLARE @SportType_VSSoccer INT = 180

CREATE TABLE #tblCust (custid INT PRIMARY KEY, roleid INT, maxpermatch180 MONEY	)
	
INSERT INTO #tblCust (custid,roleid, maxpermatch180)			
SELECT custid,roleid, maxpermatch180
FROM custInfo WITH(NOLOCK)
WHERE custid IN (xxx) -- GET LIST based on LOG CHANGED

-- SMA Adjust
UPDATE cbs
	SET minbet = cs.minbet
	, maxbet = cs.maxbet
	, maxpermatch = CI.maxpermatch180
FROM Dep_CustBetSetting_Agent CBS WITH (ROWLOCK,UPDLOCK) 
	INNER JOIN #tblCust CI WITH (NOLOCK) ON CBS.CustID = ci.custid 
	INNER JOIN Dep_CustSetting3rd cs WITH(NOLOCK) ON CBS.CustID = CS.custid AND CS.sporttype = @SportType_VSSoccer
WHERE CI.roleid IN (2,3,4) AND cbs.SportType IN (190,191,199)
	AND (CBS.MinBet <> CS.minbet OR CBS.MaxBet <> CS.maxbet OR CBS.MaxPerMatch <> CI.maxpermatch180)

-- Member Adjust
UPDATE cbs
	SET minbet = CS.minbet
	, maxbet = CS.maxbet
	, maxpermatch = CI.maxpermatch180
FROM Dep_CustBetSetting_Member cbs WITH (ROWLOCK,UPDLOCK) 
	INNER JOIN #tblCust CI WITH (NOLOCK) ON cbs.CustID = ci.custid 
	INNER JOIN Dep_CustSetting3rd CS WITH(NOLOCK) ON CBS.CustID = CS.custid AND CS.sporttype = @SportType_VSSoccer
WHERE CI.roleid = 1 AND cbs.SportType IN (190,191,199)
	AND (CBS.MinBet <> CS.minbet OR CBS.MaxBet <> CS.maxbet OR CBS.MaxPerMatch <> CI.maxpermatch180)

TRUNCATE TABLE #tblCust

DROP TABLE #tblCust
