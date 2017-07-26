/*
	Created: 20170626@Helen
	Task: insert the Setting of BetradarVS of new licensees into the DCS database.
	Redmine: https://redmine.nexcel.vn/issues/77274
	DB: DBCUST/CUSTDB
*/ 

DECLARE @SportType_VSSoccer INT = 180

CREATE TABLE #tblCust_SMA (custid INT,SportType SMALLINT, Bettype SMALLINT,  minbet MONEY, maxbet MONEY, maxpermatch180 MONEY)

CREATE TABLE #tblCust_member (custid INT,SportType SMALLINT, Bettype SMALLINT,  minbet MONEY, maxbet MONEY, maxpermatch180 MONEY)

-------------------------------------DATA PREPARATION --------------------------------------------	
INSERT INTO #tblCust_SMA (custid,SportType,Bettype, minbet, maxbet, maxpermatch180 )			
SELECT CBS.CustID,CBS.SportType,CBS.BetType, CS.minbet, CS.maxbet, CI.maxpermatch180
FROM Dep_CustBetSetting_Agent CBS WITH (ROWLOCK,UPDLOCK) 
	INNER JOIN custInfo CI WITH (NOLOCK) ON CBS.CustID = ci.custid 
	INNER JOIN Dep_CustSetting3rd cs WITH(NOLOCK) ON CBS.CustID = CS.custid AND CS.sporttype = @SportType_VSSoccer
WHERE cbs.SportType IN (190,191,199)
	AND (CBS.MinBet <> CS.minbet OR CBS.MaxBet <> CS.maxbet OR CBS.MaxPerMatch <> CI.maxpermatch180)

INSERT INTO #tblCust_member (custid,SportType,Bettype, minbet, maxbet, maxpermatch180 )			
SELECT CBS.CustID,CBS.SportType,CBS.BetType, CS.minbet, CS.maxbet, CI.maxpermatch180
FROM Dep_CustBetSetting_Agent CBS WITH (ROWLOCK,UPDLOCK) 
	INNER JOIN custInfo CI WITH (NOLOCK) ON CBS.CustID = ci.custid 
	INNER JOIN Dep_CustSetting3rd cs WITH(NOLOCK) ON CBS.CustID = CS.custid AND CS.sporttype = @SportType_VSSoccer
WHERE cbs.SportType IN (190,191,199)
	AND (CBS.MinBet <> CS.minbet OR CBS.MaxBet <> CS.maxbet OR CBS.MaxPerMatch <> CI.maxpermatch180)

-------------------------------------ADJUST BET SETTING --------------------------------------------		
-- SMA Adjust
UPDATE cbs
	SET minbet = CI.minbet
	, maxbet = CI.maxbet
	, maxpermatch = CI.maxpermatch180
FROM Dep_CustBetSetting_Agent CBS WITH (ROWLOCK,UPDLOCK) 
	INNER JOIN #tblCust_SMA CI WITH (NOLOCK) ON CBS.CustID = ci.custid AND CBS.SportType = CI.SportType AND CBS.BetType = CI.Bettype

-- Member Adjust
UPDATE cbs
	SET minbet = CI.minbet
	, maxbet = CI.maxbet
	, maxpermatch = CI.maxpermatch180
FROM Dep_CustBetSetting_Member CBS WITH (ROWLOCK,UPDLOCK) 
	INNER JOIN #tblCust_member CI WITH (NOLOCK) ON CBS.CustID = ci.custid AND CBS.SportType = CI.SportType AND CBS.BetType = CI.Bettype
	
DROP TABLE #tblCust_SMA
DROP TABLE #tblCust_member

