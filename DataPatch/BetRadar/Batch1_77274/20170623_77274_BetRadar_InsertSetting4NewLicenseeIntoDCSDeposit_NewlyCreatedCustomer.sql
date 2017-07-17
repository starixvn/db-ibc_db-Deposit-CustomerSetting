/*
	Created: 20170626@Helen
	Task: insert the Setting of Voidbridge of new licensees into the DCS database.
	Redmine: https://redmine.nexcel.vn/issues/77274
	DB: DBCUST/CUSTDB
*/  
------------------------------------------------------
DECLARE @ProductID INT = 27 -- VS

CREATE TABLE #supers (custid INT, currency INT, isfinished BIT DEFAULT(0))

DECLARE @max_custid INT, @srecommend INT,  @currency INT ,@SportType INT = 190, @bitmapOrder INT

SELECT   @max_custid= xxx ---input maxcustid

SET @bitmapOrder = (SELECT bitmapOrder FROM Dep_ProductStatusProfile WITH(NOLOCK) WHERE Sporttype =  @SportType )

CREATE TABLE #tblCust_member (custid INT,agentid INT, roleid INT,currency INT,srecommend INT,maxpermatch180 MONEY) 

INSERT INTO #tblCust_member (custid,agentid,roleid,currency,srecommend,maxpermatch180)			
SELECT ci.custid,ci.recommend,roleid,ci.currency, ci.srecommend,CI.maxpermatch180
FROM custInfo CI WITH(NOLOCK)
	INNER JOIN Dep_CustSuper CS WITH(NOLOCK) ON ci.srecommend = cs.custid
WHERE ci.mrecommend NOT IN (SELECT custid FROM custinfo cs1 WITH(NOLOCK)
						   WHERE cs1.srecommend=ci.srecommend and cs1.username like '%Acc%' and cs1.roleid=3 )
	AND ci.custid > @max_custid
	AND cs.site in ('12Bet')
	AND ci.roleid = 1
	AND CS.currency NOT IN (27) -- Currency H - it is just test currency, used once in a while 


SELECT ps.SettingType,psd.SportType,psd.BetType
INTO #ProductSettingDetail_tmp
FROM Dep_ProductSetting ps WITH (NOLOCK) 
	INNER JOIN Dep_ProductSettingDetail psd WITH (NOLOCK) ON psd.ProductSettingID = ps.ProductSettingID
WHERE ps.ProductID= @ProductID AND ps.SettingType = 2
							   
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
WHERE NOT EXISTS (SELECT 1 FROM [dbo].[Dep_CustProductStatus] T WITH (NOLOCK) WHERE t.custid = c.custid)

PRINT 'Betting Limit'

INSERT INTO Dep_CustBetSetting_Member (CustID, SportType, BetType, MinBet, MaxBet, MaxPerMatch)
SELECT c.custid, psd.sporttype, psd.bettype, cs.minbet, cs.maxbet, c.maxpermatch180
FROM #tblCust_member c
	INNER JOIN dbo.Dep_CustSetting3rd AS cs WITH (NOLOCK) ON cs.custid = c.CustID  AND cs.sporttype = 180
	CROSS JOIN #ProductSettingDetail_tmp psd
WHERE NOT EXISTS (SELECT 1 FROM Dep_CustBetSetting_Member cslm WITH (NOLOCK) WHERE cslm.CustID = C.custid AND psd.SportType = cslm.SportType AND psd.BetType = cslm.BetType)
			
DROP TABLE #tblCust_member

