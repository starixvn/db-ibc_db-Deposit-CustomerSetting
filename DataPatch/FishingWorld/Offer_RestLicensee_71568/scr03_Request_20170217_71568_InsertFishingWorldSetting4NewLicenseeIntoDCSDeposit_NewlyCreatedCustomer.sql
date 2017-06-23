/*
	Created: 20170217@Helen
	Task: DCS Deposit for Fishing World - [Redmine:71568]
	Redmine: https://nexdev.net/issues/71568
*/ 
------------------------------------------------------
DECLARE @ProductID INT = 24 -- Fishing World

CREATE TABLE #supers (custid int, currency int, isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT,  @currency int ,@SportType INT = 219,@BetType INT = 1011

DECLARE @bitmapOrder INT 

SET @bitmapOrder = (SELECT bitmapOrder FROM Dep_ProductStatusProfile WITH (NOLOCK) WHERE Sporttype = @SportType AND Bettype = @BetType)

SET @max_custid= xxx ---input maxcustid

CREATE TABLE #tblCust_member (custid int,agentid int, roleid int,currency INT,srecommend INT) 

INSERT INTO #tblCust_member (custid,agentid,roleid,currency,srecommend)			
SELECT ci.custid,ci.recommend,roleid,ci.currency, ci.srecommend
FROM custInfo CI WITH(NOLOCK)
	INNER JOIN Dep_CustSuper CS with(NOLOCK) ON ci.srecommend = cs.custid
WHERE ci.mrecommend NOT IN (SELECT custid FROM custinfo cs1 WITH(NOLOCK)
						   WHERE cs1.srecommend=ci.srecommend and cs1.username like '%Acc%' and cs1.roleid=3 )
	AND ci.custid > @max_custid
	AND cs.site in ('Athena000','Macaubet','Aoncash','ITCBET','9Bet','Allbetclub','m8bola','Q8Bola','BE7','Goobet','NBCbet','Bolanation','SBCbet','Unobet','BE7TH','Aragon88','May88','ISC888'  -- Athena
					,'Spondemo','12bet','Indowin','Brown888','ABB688' -- API
					)
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
		SET bitmapIsDisabled = dbo.f_GenerateProductStatus (t.bitmapIsDisabled, @bitmapOrder,0)		
			, bitmapIsHidden = dbo.f_GenerateProductStatus(t.bitmapIsHidden , @bitmapOrder,0)
FROM [dbo].[Dep_CustProductStatus] T (ROWLOCK)
	INNER JOIN #tblCust_member C ON C.custid = T.custid

-- Insert new	
INSERT INTO [dbo].[Dep_CustProductStatus](CustID,bitmapIsDisabled,bitmapIsHidden)
SELECT	c.custid
		, dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, @bitmapOrder,0) AS bitmapIsDisabled
		, dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, @bitmapOrder,0)  AS bitmapIsHidden
FROM #tblCust_member C
WHERE NOT EXISTS (SELECT 1 FROM [dbo].[Dep_CustProductStatus] T WITH (NOLOCK) WHERE t.custid = c.custid)

DROP TABLE #tblCust_member

