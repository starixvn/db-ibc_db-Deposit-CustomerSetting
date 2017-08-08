/*
	Created: 20170808@Helen
	Task: [Lottery]-Initialize data for Deposit 
	Redmine: https://nexdev.net/issues/81078
	DB: DBCUST/CUSTDB
	
	Executed Date: 
*/  
-------------------------------------------------------- DATA PREPARATION ---------------------------------------------------------------
DECLARE @ProductID INT = 28 -- Lottery

CREATE TABLE #supers (custid INT, currency INT, isfinished BIT DEFAULT(0))
CREATE TABLE #tblCust_member (custid INT,agentid INT, roleid INT,currency INT,srecommend INT) 

DECLARE @max_custid INT, @srecommend INT,  @currency INT ,@SportType INT = 220, @bitmapOrder INT, @GameTypeIDRef INT = 1
DECLARE @bitmap_0 BINARY(32)

SELECT   @max_custid= xxx ---input maxcustid
	
SET @bitmapOrder = (SELECT bitmapOrder FROM dbo.Dep_ProductStatusProfile WITH(NOLOCK) WHERE Sporttype =  @SportType )

-- Calculating bitmap value 
SET @bitmap_0 =  dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, @bitmapOrder,0)

INSERT INTO #tblCust_member (custid)			
SELECT ci.custid
FROM dbo.custInfo CI WITH(NOLOCK)
	INNER JOIN dbo.Dep_CustSuper CS WITH(NOLOCK) ON ci.srecommend = cs.custid
WHERE ci.mrecommend NOT IN (SELECT custid FROM dbo.custinfo cs1 WITH(NOLOCK)
						   WHERE cs1.srecommend=ci.srecommend and cs1.username like '%Acc%' and cs1.roleid=3 )
	AND ci.custid > @max_custid
	AND cs.site in ('12Bet', '9bet', 'ABB688', 'Ae88', 'Allbetclub', 'Aoncash', 'Aragon88', 'BE7', 'BetStar', 'Bolanation', 'GooBet', 'iBET', 'Indowin', 'IONclub', 'ITCBet', 'M8bola', 'Macaubet', 'NBCbet', 'Newhonbet', 'Q8bola', 'sbcbet', 'Taipanbet', 'Unobet', 'Uwoniwin', 'Leon' )
	AND ci.roleid = 1
	AND CS.currency NOT IN (27) -- Currency H - it is just test currency, used once in a while 

SELECT ps.SettingType,psd.SportType,psd.BetType
INTO #ProductSettingDetail_tmp
FROM dbo.Dep_ProductSetting ps WITH (NOLOCK) 
	INNER JOIN dbo.Dep_ProductSettingDetail psd WITH (NOLOCK) ON psd.ProductSettingID = ps.ProductSettingID
WHERE ps.ProductID= @ProductID AND ps.SettingType = 2
--------------------------------------------------------END OF DATA PREPARATION ---------------------------------------------------------------							   
------------------------------------------------------- SETTING PROCESSING ----------------------------------------------------------------------------
-- PT processing
PRINT 'PT'
-- For Member
INSERT INTO Dep_CustSettingMode (CustID,IsGroupedPT)
SELECT c.custid,1
FROM #tblCust_member C
WHERE C.roleid = 1 AND NOT EXISTS (SELECT 1 FROM dbo.Dep_CustSettingMode C1 (NOLOCK) WHERE c1.CustID = c.Custid)
	
PRINT 'Status'
-- Update if exists
UPDATE T 
		SET bitmapIsDisabled = (SELECT NewBitmap FROM dbo.f_CustSetting_GenerateProductStatus (t.bitmapIsDisabled, @bitmapOrder,0)) 
			, bitmapIsHidden = (SELECT NewBitmap FROM dbo.f_CustSetting_GenerateProductStatus (t.bitmapIsHidden, @bitmapOrder,0))
FROM dbo.Dep_CustProductStatus T WITH (ROWLOCK)
	INNER JOIN #tblCust_member C WITH (ROWLOCK) ON C.custid = T.custid

-- Insert new	
INSERT INTO dbo.Dep_CustProductStatus(CustID,bitmapIsDisabled,bitmapIsHidden)
SELECT	c.custid
		, @bitmap_0 AS bitmapIsDisabled
		, @bitmap_0  AS bitmapIsHidden
FROM #tblCust_member C WITH (NOLOCK)
WHERE NOT EXISTS (SELECT 1 FROM dbo.Dep_CustProductStatus T WITH (NOLOCK) WHERE t.custid = c.custid)

PRINT 'Betting Limit'

INSERT INTO dbo.Dep_CustBetSetting_Member (CustID, SportType, BetType, MinBet, MaxBet, MaxPerMatch)
SELECT c.custid, psd.sporttype, psd.bettype, cs.minbet, cs.maxbet, cs.MaxPerGameType
FROM #tblCust_member c WITH (NOLOCK)
	INNER JOIN dbo.CustGameType AS cs WITH (NOLOCK) ON cs.custid = c.CustID  AND cs.GameTypeID = @GameTypeIDRef
	CROSS JOIN #ProductSettingDetail_tmp psd WITH (NOLOCK)
WHERE NOT EXISTS (SELECT 1 FROM dbo.Dep_CustBetSetting_Member cslm WITH (NOLOCK) WHERE cslm.CustID = C.custid AND psd.SportType = cslm.SportType AND psd.BetType = cslm.BetType)
			
DROP TABLE #tblCust_member
DROP TABLE #ProductSettingDetail_tmp
DROP TABLE #supers
------------------------------------------------------- END OF SETTING PROCESSING ----------------------------------------------------------------------------