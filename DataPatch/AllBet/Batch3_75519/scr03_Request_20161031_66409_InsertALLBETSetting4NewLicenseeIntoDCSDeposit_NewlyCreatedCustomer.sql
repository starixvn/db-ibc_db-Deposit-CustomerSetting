/*
	Created: 20160801@Helen
	Task: insert the Setting of Allbet of new licensees into the DCS database.
	Redmine: https://nexdev.net/issues/59624
	DB:DBCUST/CustDB
*/ 
------------------------------------------------------
DECLARE @ProductID INT = 21, @SportType SMALLINT = 211, @Bettype_2401 SMALLINT = 2401, @Bettype_2402 SMALLINT = 2402, @BitmapOrder INT = 2  -- Allbet

CREATE TABLE #supers (custid int, currency int, isfinished bit default(0))
CREATE TABLE #tblCust (custid int,agentid int, roleid int,currency INT,srecommend INT,SiteID INT) 
CREATE TABLE #Licensee_Currency (LicenseeName VARCHAR(200), exchangeID INT)

DECLARE @max_custid INT, @srecommend INT, @site varchar (50), @currency int 
SELECT  @max_custid= xxx ---input maxcustid

INSERT INTO #Licensee_Currency (LicenseeName,exchangeID)
VALUES 
('Emmyo',2),
('Emmyo',3),
('Emmyo',4),
('Emmyo',6),
('Emmyo',13),
('Emmyo',15),
('May88',51),
('TCL',13),
('Webet138',13)


INSERT INTO #tblCust (custid,agentid,roleid,currency,srecommend,SiteID)			
SELECT ci.custid,ci.recommend,roleid,ci.currency, ci.srecommend,s.siteid
FROM custInfo CI WITH(NOLOCK)
	INNER JOIN Dep_CustSuper CS with(nolock) ON ci.srecommend = cs.custid
	INNER JOIN #Licensee_Currency LIC ON LIC.LicenseeName = CS.site AND LIC.exchangeID = CS.currency
	INNER JOIN Site s WITH (NOLOCK)  ON S.site = cs.site
WHERE ci.mrecommend NOT IN (SELECT custid FROM custinfo cs1 WITH(NOLOCK)
						   WHERE cs1.srecommend=ci.srecommend and cs1.username like '%Acc%' and cs1.roleid=3 )
	AND ci.custid > @max_custid
	AND ci.roleid = 1
						   
-- PT processing
PRINT 'PT'
-- For Member
INSERT INTO Dep_CustSettingMode (CustID,IsGroupedPT)
SELECT c.custid,1
FROM #tblCust C
WHERE C.roleid = 1 AND NOT EXISTS (SELECT 1 FROM Dep_CustSettingMode C1 (NOLOCK) WHERE c1.CustID = c.Custid)
	
PRINT 'Status'

-- Update if exists
SET @BitmapOrder = (SELECT bitmapOrder FROM Dep_ProductStatusProfile WITH (NOLOCK) WHERE Sporttype = @SportType AND Bettype = @Bettype_2401 )

UPDATE T 
		SET bitmapIsDisabled = dbo.f_GenerateProductStatus (t.bitmapIsDisabled, @BitmapOrder,0)		
			, bitmapIsHidden = dbo.f_GenerateProductStatus(t.bitmapIsHidden , @BitmapOrder,0)
FROM [dbo].[Dep_CustProductStatus] T (ROWLOCK)
	INNER JOIN #tblCust C ON C.custid = T.custid

-- Insert new	
INSERT INTO [dbo].[Dep_CustProductStatus](CustID,bitmapIsDisabled,bitmapIsHidden)
SELECT	c.custid
		, dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, @BitmapOrder,0) AS bitmapIsDisabled
		, dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, @BitmapOrder,0)  AS bitmapIsHidden
FROM #tblCust C
WHERE NOT EXISTS (SELECT 1 FROM [dbo].[Dep_CustProductStatus] T (NOLOCK) WHERE t.custid = c.custid)

PRINT 'StakeLevel'
INSERT INTO Dep_CustStakeLevel_member (CustID,SportType,BetType,StakeLevelList)
SELECT C.custid,211,2401, t.StakeLevelID
FROM #tblCust C
	CROSS APPLY (SELECT TOP 1 StakeLevelID
				 FROM Dep_StakeLevel WITH(NOLOCK) 
				 WHERE ExchangeId = C.currency AND GameTypeID = @Bettype_2401 AND SiteID = c.SiteID 
				 ORDER BY MaxStake, MinStake
				) AS T
WHERE NOT EXISTS (SELECT 1 FROM Dep_CustStakeLevel_Member M WITH (NOLOCK) WHERE M.CustID = C.custid AND M.SportType = @SportType AND M.BetType= @Bettype_2401)

UNION ALL

SELECT D.custid,211,2402, T2.StakeLevelID
FROM #tblCust D
	CROSS APPLY (SELECT TOP 1 StakeLevelID
					 FROM Dep_StakeLevel WITH(NOLOCK) 
					 WHERE ExchangeId = D.currency AND GameTypeID = @Bettype_2402 AND SiteID = D.SiteID
					 ORDER BY MaxStake, MinStake
					) AS T2
WHERE NOT EXISTS (SELECT 1 FROM Dep_CustStakeLevel_Member M WITH (NOLOCK) WHERE M.CustID = D.custid AND M.SportType = @SportType AND M.BetType= @Bettype_2402)	

DROP TABLE #tblCust
DROP TABLE #Licensee_Currency
DROP TABLE #supers


