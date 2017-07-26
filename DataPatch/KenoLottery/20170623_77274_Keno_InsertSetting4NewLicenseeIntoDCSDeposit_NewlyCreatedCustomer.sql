/*
	Created: 20170626@Helen
	Task: insert the Setting of Voidbridge of new licensees into the DCS database.
	Redmine: https://redmine.nexcel.vn/issues/77274
	DB: DBCUST/CUSTDB
*/  
------------------------------------------------------
DECLARE @ProductID INT = 28 -- VS

CREATE TABLE #supers (custid int, currency int, isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT,  @currency int ,@SportType INT = 220, @bitmapOrder INT
SELECT   @max_custid= xxx ---input maxcustid

SET @bitmapOrder = (SELECT bitmapOrder FROM Dep_ProductStatusProfile WITH(NOLOCK) WHERE Sporttype =  @SportType )
CREATE TABLE #tblCust_member (custid int,agentid int, roleid int,currency INT,srecommend INT) 

INSERT INTO #tblCust_member (custid,agentid,roleid,currency,srecommend)			
SELECT ci.custid,ci.recommend,roleid,ci.currency, ci.srecommend
FROM custInfo CI WITH(NOLOCK)
	INNER JOIN Dep_CustSuper CS with(nolock) ON ci.srecommend = cs.custid
WHERE ci.mrecommend NOT IN (SELECT custid FROM custinfo cs1 WITH(NOLOCK)
						   WHERE cs1.srecommend=ci.srecommend and cs1.username like '%Acc%' and cs1.roleid=3 )
	AND ci.custid > @max_custid
	AND cs.site in ('spondemo')
	AND ci.roleid = 1
	AND CS.currency NOT IN (27) -- Currency H - it is just test currency, used once in a while 
						   
-- PT processing
PRINT 'PT'
-- For Member
INSERT INTO Dep_CustSettingMode (CustID,IsGroupedPT)
SELECT c.custid,1
FROM #tblCust_member C
WHERE C.roleid = 1 AND NOT EXISTS (SELECT 1 FROM Dep_CustSettingMode C1 (NOLOCK) WHERE c1.CustID = c.Custid)
	
PRINT 'Status'
-- Update if exists
UPDATE T 
		SET bitmapIsDisabled = (SELECT * FROM f_CustSetting_GenerateProductStatus (t.bitmapIsDisabled, @bitmapOrder,0)) --dbo.f_GenerateProductStatus (t.bitmapIsDisabled, 1,0)		
			, bitmapIsHidden = (SELECT * FROM f_CustSetting_GenerateProductStatus (t.bitmapIsHidden, @bitmapOrder,0))--dbo.f_GenerateProductStatus(t.bitmapIsHidden , 1,0)
FROM [dbo].[Dep_CustProductStatus] T (ROWLOCK)
	INNER JOIN #tblCust_member C ON C.custid = T.custid

-- Insert new	
INSERT INTO [dbo].[Dep_CustProductStatus](CustID,bitmapIsDisabled,bitmapIsHidden)
SELECT	c.custid
		, dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, @bitmapOrder,0) AS bitmapIsDisabled
		, dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, @bitmapOrder,0)  AS bitmapIsHidden
FROM #tblCust_member C
WHERE NOT EXISTS (SELECT 1 FROM [dbo].[Dep_CustProductStatus] T (NOLOCK) WHERE t.custid = c.custid)

PRINT 'Betting Limit'

INSERT INTO Dep_CustBetSetting_Member (CustID, SportType, BetType, MinBet, MaxBet, MaxPerMatch)
SELECT c.custid, csla.sporttype, csla.bettype, csla.minbet, csla.maxbet, csla.MaxPerMatch
FROM #tblCust_member C
	INNER JOIN dbo.Dep_CustBetSetting_Agent AS csla WITH (NOLOCK) ON C.agentid = csla.CustID  
WHERE csla.SportType IN (190,191,199)
	AND NOT EXISTS (SELECT 1 FROM Dep_CustBetSetting_Member cslm WITH (NOLOCK) WHERE cslm.CustID = C.custid AND cslm.SportType = csla.SportType AND cslm.BetType = csla.BetType)
	
DROP TABLE #tblCust_member

