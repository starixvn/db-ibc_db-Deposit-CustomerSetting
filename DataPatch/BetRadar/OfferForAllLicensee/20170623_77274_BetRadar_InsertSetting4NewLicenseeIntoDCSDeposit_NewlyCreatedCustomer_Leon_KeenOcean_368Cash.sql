/*
	Created: 20170626@Helen
	Task: insert the Setting of BetradarVS of new licensees into the DCS database.
	Redmine: https://redmine.nexcel.vn/issues/77274
	DB: DBCUST/CUSTDB
*/  
------------------------------------------------------
DECLARE @ProductID INT = 27 -- Betradar

CREATE TABLE #supers (custid INT, currency INT, isfinished BIT DEFAULT(0))

DECLARE @max_custid INT, @srecommend INT,  @currency INT ,@SportType INT = 190, @bitmapOrder INT

SELECT   @max_custid= xxx ---input maxcustid

SET @bitmapOrder = (SELECT bitmapOrder FROM Dep_ProductStatusProfile WITH(NOLOCK) WHERE Sporttype =  @SportType )

CREATE TABLE #tblCust_member (custid INT,agentid INT, roleid INT,currency INT,srecommend INT,site VARCHAR(200)) 

INSERT INTO #tblCust_member (custid,agentid,roleid,currency,srecommend,site)			
SELECT ci.custid,ci.recommend,roleid,ci.currency, ci.srecommend,CS.site
FROM custInfo CI WITH(NOLOCK)
	INNER JOIN Dep_CustSuper CS WITH(NOLOCK) ON ci.srecommend = cs.custid
WHERE ci.mrecommend NOT IN (SELECT custid FROM custinfo cs1 WITH(NOLOCK)
						   WHERE cs1.srecommend=ci.srecommend and cs1.username like '%Acc%' and cs1.roleid=3 )
	AND ci.custid > @max_custid
	AND cs.site in ('KeenOcean', '368Cash', 'Leon')
	AND ci.roleid = 1
	AND CS.currency NOT IN (27) -- Currency H - it is just test currency, used once in a while 

SELECT ps.SettingType,psd.SportType,psd.BetType
INTO #ProductSettingDetail_tmp
FROM Dep_ProductSetting ps WITH (NOLOCK) 
	INNER JOIN Dep_ProductSettingDetail psd WITH (NOLOCK) ON psd.ProductSettingID = ps.ProductSettingID
WHERE ps.ProductID= @ProductID AND ps.SettingType = 2

CREATE TABLE #Betsetting (Site VARCHAR(50), minbet MONEY, maxbet MONEY, maxpermatch MONEY, exchangeID INT)

INSERT INTO #Betsetting (Site, minbet , maxbet , maxpermatch, exchangeID )
VALUES
('KeenOcean',10,3000,10000,66),
('KeenOcean',50,10000,50000,51),
('KeenOcean',1,100,1000,20),
('368Cash',1,3000,10000,13),
('368Cash',1,500,1500,3),
('368Cash',1,1500,5000,2),
('368Cash',1,500000,1500000,45),
('368Cash',1,15000,50000,4),
('368Cash',1,5000,15000,15),
('368Cash',1,10000,50000,51),
('368Cash',1,100,1000,20),
('Leon',1,3000,5000,13),
('Leon',1,500,500,3),
('Leon',1,100,1000,20)
							   
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

INSERT INTO dbo.Dep_CustBetSetting_Member(CustID, SportType, BetType, MinBet, MaxBet, MaxPerMatch)
SELECT CI.custid, psd.SportType, psd.BetType, BS.minbet,BS.maxbet,BS.maxpermatch					 
FROM #tblCust_member CI WITH (NOLOCK)
	INNER JOIN #Betsetting BS WITH (NOLOCK) ON CI.currency = BS.exchangeID AND BS.Site = CI.site
	CROSS JOIN #ProductSettingDetail_tmp psd WITH (NOLOCK)
WHERE NOT EXISTS (SELECT 1 FROM Dep_CustBetSetting_Member cslm WITH (NOLOCK) WHERE cslm.CustID = CI.custid AND psd.SportType = cslm.SportType AND psd.BetType = cslm.BetType)
			
DROP TABLE #tblCust_member

DROP TABLE #Betsetting

DROP TABLE #ProductSettingDetail_tmp

