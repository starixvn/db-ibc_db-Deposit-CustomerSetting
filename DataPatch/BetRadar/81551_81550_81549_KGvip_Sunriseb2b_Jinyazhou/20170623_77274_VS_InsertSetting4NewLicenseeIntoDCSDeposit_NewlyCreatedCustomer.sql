/*
	Created: 20170626@Helen
	Task: insert the Setting of Voidbridge of new licensees into the DCS database.
	Redmine: https://redmine.nexcel.vn/issues/77274
	DB: DBCUST/CUSTDB
*/  
------------------------------------------------------
DECLARE @ProductID INT 
DECLARE @max_custid INT, @srecommend INT,  @currency int ,@SportType INT , @bitmapOrder INT
DECLARE @bitmap_0 BINARY(32)
-- Calculating bitmap value 
SELECT  @max_custid= xxx ---input maxcustid
SET @ProductID = 27
SET @SportType = 190

SET @bitmapOrder = (SELECT bitmapOrder FROM Dep_ProductStatusProfile WITH(NOLOCK) WHERE Sporttype =  @SportType )

SET @bitmap_0 =  dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, @bitmapOrder,0)

CREATE TABLE #supers (custid int, currency int, isfinished bit default(0))
CREATE TABLE #tblCust_member (custid int,agentid int, roleid int,currency INT,srecommend INT,site VARCHAR(200)) 
CREATE TABLE #Betsetting (Site VARCHAR(50), minbet MONEY, maxbet MONEY, maxpermatch MONEY, exchangeID INT)

INSERT INTO #Betsetting (Site, minbet , maxbet , maxpermatch, exchangeID )
VALUES
('KGvip',20,100000,1000000,13), -- RMB
('KGvip',1,100,1000,20),       -- UUS

('Sunriseb2b',1,3000,10000,13), -- RMB
('Sunriseb2b',1,500,1500,3),   -- US$
('Sunriseb2b',1,500,1500,6), -- EUR
('Sunriseb2b',1,1500,5000,2),  -- RM
('Sunriseb2b',1,500,1500,20) , -- UUS

('Jinyazhou',10,3000,10000,13),  -- RMB
('Jinyazhou',10,1000,10000,20)  -- UUS

SELECT psd.SportType,psd.BetType
INTO #ProductSettingDetail_tmp
FROM dbo.Dep_ProductSetting ps WITH (NOLOCK) 
	INNER JOIN dbo.Dep_ProductSettingDetail psd WITH (NOLOCK) ON psd.ProductSettingID = ps.ProductSettingID
WHERE ps.ProductID= @ProductID AND SettingType = 2

INSERT INTO #tblCust_member (custid,agentid,roleid,currency,srecommend,site)			
SELECT ci.custid,ci.recommend,roleid,ci.currency, ci.srecommend, site
FROM dbo.custInfo CI WITH(NOLOCK)
	INNER JOIN dbo.Dep_CustSuper CS WITH(NOLOCK) ON ci.srecommend = cs.custid
WHERE ci.mrecommend NOT IN (SELECT custid FROM dbo.custinfo cs1 WITH(NOLOCK)
						   WHERE cs1.srecommend=ci.srecommend and cs1.username like '%Acc%' and cs1.roleid=3 )
	AND ci.custid > @max_custid
	AND cs.site in ('KGvip','Sunriseb2b','Jinyazhou')
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
	SET bitmapIsDisabled = (SELECT NewBitmap FROM dbo.f_CustSetting_GenerateProductStatus (t.bitmapIsDisabled, @bitmapOrder,0)) 
		, bitmapIsHidden = (SELECT NewBitmap FROM dbo.f_CustSetting_GenerateProductStatus (t.bitmapIsHidden, @bitmapOrder,0))
FROM [dbo].[Dep_CustProductStatus] T (ROWLOCK)
	INNER JOIN #tblCust_member C WITH (NOLOCK) ON C.custid = T.custid

-- Insert new	
INSERT INTO [dbo].[Dep_CustProductStatus](CustID,bitmapIsDisabled,bitmapIsHidden)
SELECT	c.custid
		, @bitmap_0 AS bitmapIsDisabled
		, @bitmap_0  AS bitmapIsHidden
FROM #tblCust_member C
WHERE NOT EXISTS (SELECT 1 FROM [dbo].[Dep_CustProductStatus] T (NOLOCK) WHERE t.custid = c.custid)

PRINT 'Betting Limit'

INSERT INTO Dep_CustBetSetting_Member (CustID, SportType, BetType, MinBet, MaxBet, MaxPerMatch)
SELECT c.custid, csla.sporttype, csla.bettype, BS.minbet, BS.maxbet, BS.MaxPerMatch
FROM #tblCust_member C WITH (NOLOCK)
	INNER JOIN #Betsetting AS BS WITH (NOLOCK) ON BS.Site = C.site AND BS.exchangeID = C.currency
	CROSS JOIN #ProductSettingDetail_tmp csla
WHERE NOT EXISTS (SELECT 1 FROM Dep_CustBetSetting_Member cslm WITH (NOLOCK) WHERE cslm.CustID = C.custid AND cslm.SportType = csla.SportType AND cslm.BetType = csla.BetType)
	
DROP TABLE #tblCust_member

