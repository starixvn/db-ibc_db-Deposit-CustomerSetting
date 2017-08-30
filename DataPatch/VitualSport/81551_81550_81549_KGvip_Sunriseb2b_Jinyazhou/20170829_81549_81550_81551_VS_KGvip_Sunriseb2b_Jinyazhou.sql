/*
	Created: 20180825@Helen
	Task: insert the Setting of VS of new licensees into the DCS database.
	Redmine: https://nexdev.net/issues/81549
			 https://nexdev.net/issues/81550
			 https://nexdev.net/issues/81551
	DB: DBCUST/CUSTDB
*/ 
-- BEGIN STEP 1: Deploy this SP at DBCUST.CustDB, Run only in the FIRST running
------------------------------------------------------
ALTER PROCEDURE [dbo].[Acc_Dep_DynamicCustSetting_09]
 	 @srecommend INT
	, @max_custid INT 
	, @target VARCHAR(20) 
	, @minbet MONEY
	, @maxbet MONEY
	, @maxpermatch MONEY
	
AS
BEGIN	
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at DBCUST only
		
	IF (dbo.f_CheckRepTable('Dep_CustSettingMode') = 0
		OR dbo.f_CheckRepTable('Dep_CustPTSetting_Member') = 0
		OR dbo.f_CheckRepTable('Dep_CustPTSetting_Agent') = 0
		OR dbo.f_CheckRepTable('Dep_CustPTGroupSetting_Member') = 0
		
		OR dbo.f_CheckRepTable('Dep_ProductSetting') = 0
		OR dbo.f_CheckRepTable('Dep_ProductSettingDetail') = 0
		OR dbo.f_CheckRepTable('Dep_LicenseeProductSetting') = 0 
		
		OR dbo.f_CheckRepTable('Dep_ProductStatusProfile') = 0 
		OR dbo.f_CheckRepTable('Dep_CustProductStatus') = 0 
	
		OR dbo.f_CheckRepTable('Dep_CustBetSetting_Agent') = 0 
		OR dbo.f_CheckRepTable('Dep_CustBetSetting_Member') = 0 
			
	   )
		RETURN
	
	DECLARE @ProductProfileList VARCHAR(200) 
		, @ProductID INT 
		, @SportType SMALLINT 
		-- For ProductStatus param
		, @bitmapOrder INT
		-- For PT param
		, @SuperPT SMALLMONEY
	
	DECLARE @bitmap_0 BINARY(32)
	
	SET @ProductProfileList  = '9,10,11'
	SET @ProductID = 5 -- VS
	SET @SportType  = 180
	SET @SuperPT  = 85
	
	SET @bitmapOrder = (SELECT bitmapOrder FROM dbo.Dep_ProductStatusProfile WITH(NOLOCK) WHERE Sporttype =  @SportType )
			
	-- Calculating bitmap value 
	SET @bitmap_0 =  dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, @bitmapOrder,0)
		
	CREATE TABLE #tblCust_member (custid INT PRIMARY KEY, ID INT IDENTITY (1,1))
	
	CREATE TABLE #tblCust_sma (custid INT PRIMARY KEY,roleID INT)

	INSERT INTO #tblCust_member (custid)			
	SELECT custid
	FROM dbo.custInfo WITH(NOLOCK)
	WHERE srecommend =@srecommend
		AND mrecommend NOT IN (SELECT custid FROM dbo.custinfo WITH(NOLOCK)
							   WHERE srecommend=@srecommend and username like '%Acc%' and roleid=3)
		AND custid <= @max_custid
		AND roleid = 1
	
	INSERT INTO #tblCust_sma (custid,roleID)			
	SELECT custid,roleID
	FROM dbo.custInfo WITH(NOLOCK)
	WHERE srecommend =@srecommend
		AND mrecommend NOT IN (SELECT custid FROM dbo.custinfo WITH(NOLOCK)
							   WHERE srecommend=@srecommend and username like '%Acc%' and roleid=3)
		AND custid <= @max_custid
		AND roleid IN (2,3,4)
	
	-- Licensee profile list
	IF NOT EXISTS (SELECT 1 
				   FROM dbo.Dep_LicenseeProductSetting lps WITH (NOLOCK)
						INNER JOIN dbo.Dep_ProductSetting ps WITH (NOLOCK) ON lps.ProductSettingID = ps.ProductSettingID
				   WHERE CustID = @srecommend AND ps.ProductID= @ProductID)
	BEGIN
		INSERT INTO dbo.Dep_LicenseeProductSetting (CustID,ProductSettingID)
		SELECT @srecommend, t.val
		FROM dbo.strSplit(@ProductProfileList,',') t
	END	

	SELECT ps.SettingType,psd.SportType,psd.BetType
	INTO #ProductSettingDetail_tmp
	FROM dbo.Dep_LicenseeProductSetting lds WITH (NOLOCK)
		INNER JOIN dbo.Dep_ProductSetting ps WITH (NOLOCK) ON lds.ProductSettingID = PS.ProductSettingID
		INNER JOIN dbo.Dep_ProductSettingDetail psd WITH (NOLOCK) ON psd.ProductSettingID = ps.ProductSettingID
	WHERE lds.CustID =@srecommend AND ps.ProductID= @ProductID

	---------------------------------- START PROCESSING FOR SMA ONLY---------------------------------------------------------------
	-- PT processing for SMA

	PRINT 'PT'
	-- For SMA
	INSERT INTO [dbo].[Dep_CustPTSetting_Agent]
			   ([CustID]
			   ,[SportType]
			   ,[BetType]
			   ,[IsLive]
			   ,[SuperPT]
			   ,[MasterPT]
			   ,[AgentPT]
			  )
	SELECT 
		ci.custid
		,psd.SportType
		,psd.BetType
		,0
		,CASE WHEN ci.roleid = 4 THEN @SuperPT ELSE 0 END AS SuperPT
		,CASE WHEN ci.roleid IN (3,4) THEN @SuperPT ELSE 0 END AS MasterPT
		,CASE WHEN ci.roleid IN (2,4) THEN @SuperPT ELSE 0 END AS AgentPT
	FROM #tblCust_sma ci WITH (NOLOCK)
		CROSS JOIN #ProductSettingDetail_tmp psd WITH (NOLOCK)
	WHERE psd.SettingType = 1 
		AND ci.roleid IN (2,3,4)
		
	-- For Member
	IF EXISTS (SELECT 1 FROM #tblCust_sma WITH (NOLOCK) WHERE roleid = 2)
	BEGIN
		
		--Insert new PT Group
		INSERT INTO dbo.Dep_CustPTGroupSetting_Member (AgentID,SportType,BetType,IsLive,SuperPT,MasterPT,AgentPT)				
		SELECT ci.custid,psd.SportType,psd.BetType,0,0,0,@SuperPT
		FROM #tblCust_sma ci WITH (NOLOCK)
			CROSS JOIN #ProductSettingDetail_tmp psd WITH (NOLOCK)
		WHERE psd.SettingType = 1 
			AND ci.roleid = 2
	END
		
	-- Product Status for SMA
	UPDATE T 
		SET bitmapIsDisabled = (SELECT NewBitmap FROM dbo.f_CustSetting_GenerateProductStatus (t.bitmapIsDisabled, @bitmapOrder,0)) 
									
		, bitmapIsHidden = (SELECT NewBitmap FROM dbo.f_CustSetting_GenerateProductStatus (t.bitmapIsHidden, @bitmapOrder,0))
			
	FROM [dbo].[Dep_CustProductStatus] T WITH (ROWLOCK,UPDLOCK)
		INNER JOIN #tblCust_sma C  WITH (NOLOCK) ON C.custid = T.custid
		
	INSERT INTO [dbo].[Dep_CustProductStatus](CustID,bitmapIsDisabled,bitmapIsHidden)
	SELECT	c.custid
			, @bitmap_0 AS bitmapIsDisabled
			, @bitmap_0 AS bitmapIsHidden 
	FROM #tblCust_sma C WITH (NOLOCK)
	WHERE NOT EXISTS (SELECT 1 FROM [dbo].[Dep_CustProductStatus] C1 WITH (NOLOCK) WHERE C1.CustID = C.custid)
	
	INSERT INTO dbo.Dep_CustBetSetting_Agent(CustID, SportType, BetType, MinBet, MaxBet, MaxPerMatch)
	SELECT ci.custid, psd.sporttype, psd.bettype, @Minbet,@Maxbet,@MaxPerMatch					 
	FROM #tblCust_sma ci WITH (NOLOCK)
       CROSS JOIN #ProductSettingDetail_tmp psd WITH (NOLOCK)
	WHERE psd.SettingType = 2 
	---------------------------------- END OF PROCESSING FOR SMA ONLY---------------------------------------------------------------
		
	-- 0. PT Group for Members
	INSERT INTO Dep_CustSettingMode (CustID,IsGroupedPT)
	SELECT c.custid,1
	FROM #tblCust_member C WITH (NOLOCK)
	WHERE NOT EXISTS (SELECT 1 FROM dbo.Dep_CustSettingMode C1 WITH (NOLOCK) WHERE C1.CustID = C.custid)

	-- 1. Product Status
	UPDATE T 
		SET bitmapIsDisabled = (SELECT NewBitmap FROM dbo.f_CustSetting_GenerateProductStatus (t.bitmapIsDisabled, @bitmapOrder,0)) 
									
		, bitmapIsHidden = (SELECT NewBitmap FROM dbo.f_CustSetting_GenerateProductStatus (t.bitmapIsHidden, @bitmapOrder,0))
			
	FROM [dbo].[Dep_CustProductStatus] T WITH (ROWLOCK,UPDLOCK)
		INNER JOIN #tblCust_member C  WITH (NOLOCK) ON C.custid = T.custid
		
	INSERT INTO [dbo].[Dep_CustProductStatus](CustID,bitmapIsDisabled,bitmapIsHidden)
	SELECT	c.custid
		, @bitmap_0 AS bitmapIsDisabled
		, @bitmap_0 AS bitmapIsHidden -- Always Hide = 0 for Betradar VS
	FROM #tblCust_member C WITH (NOLOCK)
	WHERE NOT EXISTS (SELECT 1 FROM [dbo].[Dep_CustProductStatus] C1 WITH (NOLOCK) WHERE C1.CustID = C.custid)
	
	-- 2. Betting Limit
	--Member Level
	
	INSERT INTO dbo.Dep_CustBetSetting_Member(CustID, SportType, BetType, MinBet, MaxBet, MaxPerMatch)
	SELECT ci.custid, psd.sporttype, psd.bettype, @Minbet,@Maxbet,@MaxPerMatch					 
	FROM #tblCust_member ci WITH (NOLOCK)
	  CROSS JOIN #ProductSettingDetail_tmp psd WITH (NOLOCK)
	WHERE psd.SettingType = 2 
			   
	---------------------------------- END OF BATCH BY BATCH PROCESSING ---------------------------------------------------------------
	DROP TABLE #ProductSettingDetail_tmp
	DROP TABLE #tblCust_member
	DROP TABLE #tblCust_sma

END
GO
-- END STEP 1: DEPLOY THIS SP @ DBCUST.CustDB -------

------------------------------------------------------	
-- BEGIN STEP 2: Run this SP at replicated DB -----
--------------------------------------------------------------------------------------
DECLARE @ProductID INT 
DECLARE @super_cnt INT, @index INT 
DECLARE @max_custid INT, @srecommend INT, @minbet MONEY, @maxbet MONEY, @maxpermatch MONEY
DECLARE @msg NVARCHAR(200) 
DECLARE @msg_total NVARCHAR(200) 

CREATE TABLE #supers (custid INT,  minbet MONEY, maxbet MONEY, maxpermatch MONEY, isfinished BIT DEFAULT(0))
CREATE TABLE #Betsetting (Site VARCHAR(50), minbet MONEY, maxbet MONEY, maxpermatch MONEY, exchangeID INT)
CREATE TABLE #Supers_Offered (custid INT)

SELECT  @max_custid= xxx ---input maxcustid

SET @index = 0
SET @ProductID = 5

SET @msg = 'Currently at order %d, SuperID: %d.'
SET @msg_total = 'Total of supers: %d.'

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

INSERT INTO #Supers_Offered (custid)
SELECT lds.CustID
FROM dbo.Dep_LicenseeProductSetting lds WITH (NOLOCK)
	INNER JOIN dbo.Dep_CustSuper c WITH (NOLOCK) on c.custid = lds.CustID 
	INNER JOIN dbo.Dep_ProductSetting ps WITH (NOLOCK) ON lds.ProductSettingID = PS.ProductSettingID AND ps.ProductID= @ProductID
	INNER JOIN dbo.Dep_ProductSettingDetail psd WITH (NOLOCK) ON psd.ProductSettingID = ps.ProductSettingID
WHERE PSD.SportType IN (180,181,182,183,184,185,186) AND C.site in ('KGvip','Sunriseb2b','Jinyazhou')

INSERT INTO #supers(custid, minbet , maxbet , maxpermatch)
SELECT CS.custid, BS.minbet , BS.maxbet , BS.maxpermatch
FROM  dbo.Dep_CustSuper CS WITH(NOLOCK) 
	INNER JOIN #Betsetting BS WITH (NOLOCK) ON CS.site = BS.Site AND CS.currency = BS.exchangeID
WHERE custid NOT IN (SELECT custid FROM #Supers_Offered)
	AND CS.site in ('KGvip','Sunriseb2b','Jinyazhou')
	AND CS.custid <= @max_custid
	AND CS.currency NOT IN (27) -- Currency H - it is just test currency, used once in a while 

-- For deployer info
SET @super_cnt = (SELECT COUNT(*) FROM #supers WITH (NOLOCK))

RAISERROR (@msg_total, 0, 1, @super_cnt) WITH NOWAIT

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #supers
	SET isfinished = 1
		,@srecommend = custid
		,@minbet = minbet
		,@maxbet = maxbet
		,@maxpermatch = maxpermatch
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
	
	SET @index = @index + 1
	
	RAISERROR (@msg, 0, 1,@index, @srecommend) WITH NOWAIT
	
	EXEC dbo.[Acc_Dep_DynamicCustSetting_09] @srecommend = @srecommend, @minbet=@minbet, @maxbet = @maxbet, @maxpermatch = @maxpermatch,@max_custid=@max_custid,@target = 'REPLICATED' 	
				
	WAITFOR DELAY '00:00:00.280'			
END	
DROP TABLE #supers
DROP TABLE #Supers_Offered	
DROP TABLE #Betsetting	
GO		

-- END STEP 2: Run this SP at replicated DB -----
-----------------------------------------------------------------------------------

---
-- BEGIN STEP 3: Run this SP at DBCust -----
-------------------------------------------------
DECLARE @ProductID INT 
DECLARE @super_cnt INT, @index INT 
DECLARE @max_custid INT, @srecommend INT, @minbet MONEY, @maxbet MONEY, @maxpermatch MONEY
DECLARE @msg NVARCHAR(200) 
DECLARE @msg_total NVARCHAR(200) 

CREATE TABLE #supers (custid INT,  minbet MONEY, maxbet MONEY, maxpermatch MONEY, isfinished BIT DEFAULT(0))
CREATE TABLE #Betsetting (Site VARCHAR(50), minbet MONEY, maxbet MONEY, maxpermatch MONEY, exchangeID INT)
CREATE TABLE #Supers_Offered (custid INT)

SELECT  @max_custid= xxx ---input maxcustid

SET @index = 0
SET @ProductID = 5

SET @msg = 'Currently at order %d, SuperID: %d.'
SET @msg_total = 'Total of supers: %d.'

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

INSERT INTO #Supers_Offered (custid)
SELECT lds.CustID
FROM dbo.Dep_LicenseeProductSetting lds WITH (NOLOCK)
	INNER JOIN dbo.Dep_CustSuper c WITH (NOLOCK) on c.custid = lds.CustID 
	INNER JOIN dbo.Dep_ProductSetting ps WITH (NOLOCK) ON lds.ProductSettingID = PS.ProductSettingID AND ps.ProductID= @ProductID
	INNER JOIN dbo.Dep_ProductSettingDetail psd WITH (NOLOCK) ON psd.ProductSettingID = ps.ProductSettingID
WHERE PSD.SportType IN (180,181,182,183,184,185,186) AND C.site in ('KGvip','Sunriseb2b','Jinyazhou')

INSERT INTO #supers(custid, minbet , maxbet , maxpermatch)
SELECT CS.custid, BS.minbet , BS.maxbet , BS.maxpermatch
FROM  dbo.Dep_CustSuper CS WITH(NOLOCK) 
	INNER JOIN #Betsetting BS WITH (NOLOCK) ON CS.site = BS.Site AND CS.currency = BS.exchangeID
WHERE custid NOT IN (SELECT custid FROM #Supers_Offered)
	AND CS.site in ('KGvip','Sunriseb2b','Jinyazhou')
	AND CS.custid <= @max_custid
	AND CS.currency NOT IN (27) -- Currency H - it is just test currency, used once in a while 

-- For deployer info
SET @super_cnt = (SELECT COUNT(*) FROM #supers WITH (NOLOCK))

RAISERROR (@msg_total, 0, 1, @super_cnt) WITH NOWAIT

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #supers
	SET isfinished = 1
		,@srecommend = custid
		,@minbet = minbet
		,@maxbet = maxbet
		,@maxpermatch = maxpermatch
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
	
	SET @index = @index + 1
	
	RAISERROR (@msg, 0, 1,@index, @srecommend) WITH NOWAIT
	
	EXEC dbo.[Acc_Dep_DynamicCustSetting_09] @srecommend = @srecommend, @minbet=@minbet, @maxbet = @maxbet, @maxpermatch = @maxpermatch,@max_custid=@max_custid,@target = 'DBCUST' 	
		
	WAITFOR DELAY '00:00:00.280'			
END	

DROP TABLE #supers	
DROP TABLE #Supers_Offered	
DROP TABLE #Betsetting	
GO		

