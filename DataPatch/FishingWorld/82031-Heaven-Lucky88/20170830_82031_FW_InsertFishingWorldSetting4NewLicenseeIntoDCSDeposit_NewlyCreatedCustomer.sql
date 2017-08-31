/*
	Created: 20170831@Helen
	Task: DCS Deposit for Fishing World - [Redmine:82031]
	Redmine: https://nexdev.net/issues/82031
*/ 
------------------------------------------------------
DECLARE @ProductID INT 
DECLARE @max_custid INT, @srecommend INT,  @currency int ,@SportType INT,@BetType INT, @bitmapOrder INT 
DECLARE @bitmap_0 BINARY(32)

CREATE TABLE #supers (custid int, currency int, isfinished bit default(0))
CREATE TABLE #tblCust_member (custid int,agentid int, roleid int,srecommend INT) 

SET @max_custid= xxx ---input maxcustid

SET @ProductID = 24 -- Fishing World
SET @SportType = 219
SET @BetType = 1011

SET @bitmapOrder = (SELECT bitmapOrder FROM dbo.Dep_ProductStatusProfile WITH (NOLOCK) WHERE Sporttype = @SportType AND Bettype = @BetType)

-- Calculating bitmap value 
SET @bitmap_0 =  dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, @bitmapOrder,0)

INSERT INTO #tblCust_member (custid,roleid,srecommend)			
SELECT ci.custid,roleid,ci.srecommend
FROM dbo.custInfo CI WITH(NOLOCK)
	INNER JOIN dbo.Dep_CustSuper CS with(NOLOCK) ON ci.srecommend = cs.custid
WHERE ci.mrecommend NOT IN (SELECT custid FROM dbo.custinfo cs1 WITH(NOLOCK)
						   WHERE cs1.srecommend=ci.srecommend and cs1.username like '%Acc%' and cs1.roleid=3 )
	AND ci.custid > @max_custid
	AND cs.site in ('Heaven','Lucky88')
	AND ci.roleid = 1
	AND CS.currency NOT IN (27) -- Currency H - it is just test currency, used once in a while 
						   
-- PT processing
PRINT 'PT'
-- For Member
INSERT INTO dbo.Dep_CustSettingMode (CustID,IsGroupedPT)
SELECT c.custid,1
FROM #tblCust_member C WITH (NOLOCK)
WHERE C.roleid = 1 AND NOT EXISTS (SELECT 1 FROM dbo.Dep_CustSettingMode C1 (NOLOCK) WHERE c1.CustID = c.Custid)
	
PRINT 'Status'
-- Update if exists
UPDATE T 
		SET bitmapIsDisabled =  (SELECT NewBitmap FROM dbo.f_CustSetting_GenerateProductStatus (t.bitmapIsDisabled, @bitmapOrder,0)) 
			, bitmapIsHidden =  (SELECT NewBitmap FROM dbo.f_CustSetting_GenerateProductStatus (t.bitmapIsDisabled, @bitmapOrder,0)) 
FROM [dbo].[Dep_CustProductStatus] T WITH (ROWLOCK,UPDLOCK)
	INNER JOIN #tblCust_member C ON C.custid = T.custid

-- Insert new	
INSERT INTO [dbo].[Dep_CustProductStatus](CustID,bitmapIsDisabled,bitmapIsHidden)
SELECT	c.custid
		, @bitmap_0 AS bitmapIsDisabled
		, @bitmap_0 AS bitmapIsHidden
FROM #tblCust_member C WITH (NOLOCK)
WHERE NOT EXISTS (SELECT 1 FROM [dbo].[Dep_CustProductStatus] T WITH (NOLOCK) WHERE t.custid = c.custid)

DROP TABLE #tblCust_member

