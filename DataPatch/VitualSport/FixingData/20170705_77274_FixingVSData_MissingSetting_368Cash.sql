/*
	Created: 20170626@Helen
	Task: insert the Setting of VS of new licensees into the DCS database.
	Redmine: https://redmine.nexcel.vn/issues/77274
	DB: DBCUST/CUSTDB
*/ 


 DECLARE @srecommend INT
	, @max_custid INT 

SET @srecommend = 13682916
SET @max_custid = 26866929

CREATE TABLE #missing_setting (CustID INT)

CREATE TABLE #memberList (CustID INT)

INSERT INTO #memberList (CustID)
SELECT cii.custid
FROM Custinfo cii (nolock)
WHERE srecommend = @srecommend
	AND mrecommend NOT IN (SELECT custid FROM custinfo WITH(NOLOCK)
							   WHERE srecommend=@srecommend and username like '%Acc%' and roleid=3)
	AND custid <= @max_custid
	AND roleid = 1

INSERT INTO #missing_setting (CustID)	
SELECT t.custid
FROM #memberList t
	INNER JOIN dbo.Dep_CustBetSetting_member cba WITH (NOLOCK) ON cba.CustID = t.CustID
WHERE cba.SportType in (180,181,182,183,184,185,186)
GROUP BY t.custid
HAVING COUNT(1) < 7

INSERT INTO dbo.Dep_CustBetSetting_Member(CustID, SportType, BetType, MinBet, MaxBet, MaxPerMatch)
SELECT cs.custid, 183, cs.bettype, cs.minbet, cs.maxbet, ci.maxpermatch180					 
FROM dbo.Dep_CustSetting3rd cs WITH(NOLOCK)
	INNER JOIN custInfo CI WITH (NOLOCK) ON CS.custid = CI.custid
	INNER JOIN #missing_setting ms WITH(NOLOCK) ON ms.CustID = ci.custid 
WHERE cs.bettype = 1201 AND cs.sporttype = 180


INSERT INTO dbo.Dep_CustBetSetting_Member(CustID, SportType, BetType, MinBet, MaxBet, MaxPerMatch)
SELECT cs.custid, 185, cs.bettype, cs.minbet, cs.maxbet, ci.maxpermatch180					 
FROM dbo.Dep_CustSetting3rd cs WITH(NOLOCK)
	INNER JOIN custInfo CI WITH (NOLOCK) ON CS.custid = CI.custid
	INNER JOIN #missing_setting ms WITH(NOLOCK) ON ms.CustID = ci.custid 
WHERE cs.bettype = 1201 AND cs.sporttype = 180

DROP TABLE #memberList
DROP TABLE #missing_setting

	
