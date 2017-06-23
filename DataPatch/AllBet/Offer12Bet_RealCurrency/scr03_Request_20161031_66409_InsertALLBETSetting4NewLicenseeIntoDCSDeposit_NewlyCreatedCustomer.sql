/*
	Created: 20160801@Helen
	Task: insert the Setting of Allbet of new licensees into the DCS database.
	Redmine: https://nexdev.net/issues/59624
	DB:DBCUST/CustDB
*/ 
------------------------------------------------------
DECLARE @ProductID INT = 21 -- Allbet

CREATE TABLE #supers (custid int, currency int, isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT, @site varchar (50), @currency int 
SELECT   @site='12Bet',
		 @max_custid= xxx ---input maxcustid

CREATE TABLE #tblCust (custid int,agentid int, roleid int,currency INT,srecommend INT) 

INSERT INTO #tblCust (custid,agentid,roleid,currency,srecommend)			
SELECT ci.custid,ci.recommend,roleid,ci.currency, ci.srecommend
FROM custInfo CI WITH(NOLOCK)
	INNER JOIN Dep_CustSuper CS with(nolock) ON ci.srecommend = cs.custid
WHERE ci.mrecommend NOT IN (SELECT custid FROM custinfo cs1 WITH(NOLOCK)
						   WHERE cs1.srecommend=ci.srecommend and cs1.username like '%Acc%' and cs1.roleid=3 )
	AND ci.custid > @max_custid
	AND cs.site=@site 
	AND cs.currency in (
	--Sheet 1
	3,13,2
	--,71,70
	,51,15,4,61,45
	-- Sheet 2
	,12,6,9
	)
	
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
UPDATE T 
		SET bitmapIsDisabled = dbo.f_GenerateProductStatus (t.bitmapIsDisabled, 2,0)		
			, bitmapIsHidden = dbo.f_GenerateProductStatus(t.bitmapIsHidden , 2,0)
FROM [dbo].[Dep_CustProductStatus] T (ROWLOCK)
	INNER JOIN #tblCust C ON C.custid = T.custid

-- Insert new	
INSERT INTO [dbo].[Dep_CustProductStatus](CustID,bitmapIsDisabled,bitmapIsHidden)
SELECT	c.custid
		, dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, 2,0) AS bitmapIsDisabled
		, dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, 2,0)  AS bitmapIsHidden
FROM #tblCust C
WHERE NOT EXISTS (SELECT 1 FROM [dbo].[Dep_CustProductStatus] T (NOLOCK) WHERE t.custid = c.custid)


PRINT 'StakeLevel'
INSERT INTO Dep_CustStakeLevel_member (CustID,SportType,BetType,StakeLevelList)
SELECT C.custid,211,2401, t.StakeLevelID
FROM #tblCust C
	CROSS APPLY (SELECT TOP 1 StakeLevelID
				 FROM Dep_StakeLevel WITH(NOLOCK) 
				 WHERE ExchangeId = C.currency AND GameTypeID = 2401
				 ORDER BY MaxStake, MinStake
				) AS T

UNION ALL
SELECT C.custid,211,2402, T2.StakeLevelID
FROM #tblCust C
	CROSS APPLY (SELECT TOP 1 StakeLevelID
					 FROM Dep_StakeLevel WITH(NOLOCK) 
					 WHERE ExchangeId = C.currency AND GameTypeID = 2402
					 ORDER BY MaxStake, MinStake
					) AS T2
	
DROP TABLE #tblCust

