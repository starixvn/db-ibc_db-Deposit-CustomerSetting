/*
	Created: 20170808@Helen
	Task: [Lottery]-Initialize data for Deposit 
	Redmine: https://nexdev.net/issues/81078
	DB: DBCUST/CUSTDB
	
	Executed Date: 
*/ 
-- BEGIN STEP 1: Deploy this SP at DBCUST.CustDB, Run only in the FIRST running
------------------------------------------------------

ALTER PROCEDURE [dbo].[Acc_Dep_DynamicCustSetting_09]
( 	 
 	 @srecommend INT
	, @currency INT
	, @isOfferedDCS BIT
	, @max_custid INT
	, @target VARCHAR(20)
	
	, @SportType SMALLINT = 220
	, @Bettype SMALLINT = 1021
	, @SportTypeRef SMALLINT = 202
	, @GameTypeIDRef INT = 1
	, @ProductID INT = 28 -- Lottery
)	
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
	
	DECLARE @ProductProfileList VARCHAR(200) = '15,16,17'
		-- For ProductStatus param
		, @bitmapOrder INT
		, @bitmap_0 BINARY(32)
		-- For PT param
		, @SuperPT SMALLMONEY = 90
	
	SET @bitmapOrder = (SELECT bitmapOrder FROM dbo.Dep_ProductStatusProfile WITH(NOLOCK) WHERE Sporttype =  @SportType )
	
	-- Calculating bitmap value 
	SET @bitmap_0 =  dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, @bitmapOrder,0)

	CREATE TABLE #tblCust_member (custid INT PRIMARY KEY, ID INT IDENTITY (1,1))
	
	CREATE TABLE #tblCust_sma (custid INT PRIMARY KEY, roleID INT)

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
		
	CREATE NONCLUSTERED INDEX inx_tmp ON #tblCust_member (ID)								   
	
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
	
	-- PT processing
	IF EXISTS (SELECT 1 FROM #ProductSettingDetail_tmp WITH (NOLOCK) WHERE SettingType = 1) 
	BEGIN
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
			
		-- For Member
		IF EXISTS (SELECT 1 FROM #tblCust_sma WITH (NOLOCK) WHERE roleid = 2)
		BEGIN
			--Insert new PT Group
			INSERT INTO dbo.Dep_CustPTGroupSetting_Member (AgentID,SportType,BetType,IsLive,SuperPT,MasterPT,AgentPT)				
			SELECT ci.custid,psd.SportType,psd.BetType,0,0,0,@SuperPT
			FROM #tblCust_SMA ci WITH (NOLOCK)
				CROSS JOIN #ProductSettingDetail_tmp psd WITH (NOLOCK)
			WHERE psd.SettingType = 1 
				AND ci.roleid = 2					
		END
	END	
	-- Product Status for SMA
	IF EXISTS (SELECT 1 FROM #ProductSettingDetail_tmp WITH (NOLOCK) WHERE SettingType = 4) 
	BEGIN
		IF @isOfferedDCS = 1
		BEGIN
			UPDATE T 
					SET bitmapIsDisabled = (SELECT NewBitmap FROM f_CustSetting_GenerateProductStatus (t.bitmapIsDisabled, @bitmapOrder,0)) 
											
					, bitmapIsHidden = (SELECT NewBitmap FROM f_CustSetting_GenerateProductStatus (t.bitmapIsHidden, @bitmapOrder,0))
				
			FROM [dbo].[Dep_CustProductStatus] T WITH (ROWLOCK,UPDLOCK)
				INNER JOIN #tblCust_sma C WITH (NOLOCK) ON C.custid = T.custid
		
		END
		ELSE
		BEGIN
			INSERT INTO [dbo].[Dep_CustProductStatus](CustID,bitmapIsDisabled,bitmapIsHidden)
			SELECT	c.custid
					, @bitmap_0 bitmapIsDisabled
					, @bitmap_0  AS bitmapIsHidden 
			FROM #tblCust_sma C WITH(NOLOCK)
				
		END
	END	
	-- Betting Limit for SMA
	IF EXISTS (SELECT 1 FROM #ProductSettingDetail_tmp WITH (NOLOCK) WHERE SettingType = 2) 
	BEGIN
		INSERT INTO dbo.Dep_CustBetSetting_Agent(CustID, SportType, BetType, MinBet, MaxBet, MaxPerMatch)
		SELECT ci.custid, psd.sporttype, psd.bettype, cs.minbet, cs.maxbet, cs.MaxPerGameType					 
		FROM dbo.CustGameType cs WITH (NOLOCK)
		   INNER JOIN #tblCust_sma ci WITH(NOLOCK) ON cs.CustID = ci.custid AND cs.GameTypeID = @GameTypeIDRef
		   CROSS JOIN #ProductSettingDetail_tmp psd WITH (NOLOCK)
		WHERE psd.SettingType = 2 
	END	
	---------------------------------- END OF PROCESSING FOR SMA ONLY---------------------------------------------------------------
			
	---------------------------------- START BATCH BY BATCH PROCESSING ---------------------------------------------------------------
	CREATE TABLE  #CustSetting (custID INT, minbet MONEY, maxbet MONEY,maxpermatch MONEY, PRIMARY KEY (CustID))
	
	DECLARE @StartRow INT = 1, @MaxRow INT,@Threshold INT = 50000, @StopRow INT
	SET @MaxRow = (SELECT MAX(ID) FROM #tblCust_member WITH (NOLOCK))
	
	-- Return in case there is no members under this srecommend in the table custinfo
	IF @MaxRow IS NULL 
	BEGIN
		PRINT 'There is No members under this srecommend in the table custinfo. RETURN'
		RETURN
	END
	
	IF @Threshold >= @MaxRow
		SET @Threshold = @MaxRow

	SET @StopRow = @Threshold

	WHILE (1=1)
	BEGIN
		
		/* FOR debug
		PRINT @StartRow
		PRINT @StopRow
		*/
		-- 1. Product Status & PT
		IF @isOfferedDCS = 1
		BEGIN
			UPDATE T 
					SET bitmapIsDisabled = (SELECT NewBitmap FROM dbo.f_CustSetting_GenerateProductStatus (t.bitmapIsDisabled, @bitmapOrder,0)) 
					, bitmapIsHidden = (SELECT NewBitmap FROM dbo.f_CustSetting_GenerateProductStatus (t.bitmapIsHidden, @bitmapOrder,0))
			
			FROM [dbo].[Dep_CustProductStatus] T WITH (ROWLOCK,UPDLOCK)
				INNER JOIN #tblCust_member C WITH (NOLOCK) ON C.custid = T.custid
			WHERE  C.ID >= @StartRow AND C.ID <= @StopRow
		END
		ELSE
		BEGIN
			-- 0. PT Group for Members
			INSERT INTO dbo.Dep_CustSettingMode (CustID,IsGroupedPT)
			SELECT c.custid,1
			FROM #tblCust_member C WITH (NOLOCK)
			WHERE C.ID >= @StartRow AND C.ID <= @StopRow						

			-- 1. Product Status
			-- Insert new	
			INSERT INTO [dbo].[Dep_CustProductStatus](CustID,bitmapIsDisabled,bitmapIsHidden)
			SELECT	c.custid
					, @bitmap_0 AS bitmapIsDisabled
					, @bitmap_0  AS bitmapIsHidden 
			FROM #tblCust_member C WITH(NOLOCK)
			WHERE C.ID >= @StartRow AND C.ID <= @StopRow

		END
		-- 2. Betting Limit
		--Member Level
		INSERT INTO dbo.Dep_CustBetSetting_Member(CustID, SportType, BetType, MinBet, MaxBet, MaxPerMatch)
		SELECT cs.custid, psd.SportType, psd.BetType, cs.minbet, cs.maxbet, cs.MaxPerGameType					 
		FROM #tblCust_member ci WITH (NOLOCK)
			INNER JOIN dbo.CustGameType cs WITH(NOLOCK) ON cs.CustID = ci.custid AND cs.GameTypeID = @GameTypeIDRef
			CROSS JOIN #ProductSettingDetail_tmp psd WITH (NOLOCK)
		WHERE psd.SettingType = 2 AND CI.ID >= @StartRow AND CI.ID <= @StopRow  
		   
		-- Starting to process data --
		IF @StopRow = @MaxRow BREAK
		
		SET @StartRow = @StopRow + 1
		
		SET @StopRow =  @StopRow + 1 + @Threshold
		
		IF @StopRow >= @MaxRow
			SET @StopRow = @MaxRow
		
		WAITFOR DELAY '00:00:00.200'
		
	END

	DROP TABLE #ProductSettingDetail_tmp
	DROP TABLE #tblCust_sma
	DROP TABLE #tblCust_member
	DROP TABLE #CustSetting

END	
GO
-- END STEP 1: DEPLOY THIS SP @ DBCUST.CustDB -------

------------------------------------------------------	
-- BEGIN STEP 2: Run this SP at replicated DB -----
--------------------------------------------------------------------------------------
DECLARE @ProductID INT = 28, @SportType SMALLINT = 220

CREATE TABLE #Supers_Offered (custid INT)

INSERT INTO #Supers_Offered (custid)
SELECT lds.CustID
FROM dbo.Dep_LicenseeProductSetting lds WITH (NOLOCK)
	INNER JOIN dbo.Dep_CustSuper c WITH (NOLOCK) on c.custid = lds.CustID 
	INNER JOIN dbo.Dep_ProductSetting ps WITH (NOLOCK) ON lds.ProductSettingID = PS.ProductSettingID AND ps.ProductID= @ProductID
	INNER JOIN dbo.Dep_ProductSettingDetail psd WITH (NOLOCK) ON psd.ProductSettingID = ps.ProductSettingID
WHERE PSD.SportType = @SportType
 
CREATE TABLE #supers (custid INT, currency INT,isOfferedDCS BIT, isfinished BIT DEFAULT(0))

DECLARE @max_custid INT, @srecommend INT, @site varchar (50), @currency INT, @isOfferedDCS BIT 
SELECT  @max_custid= xxx ---input maxcustid

INSERT INTO #supers(custid,currency,isOfferedDCS)
SELECT CS.custid,CS.currency, CASE WHEN LPS.CustID IS NOT NULL THEN 1 ELSE 0 END AS isOfferedDCS
FROM  dbo.Dep_CustSuper CS WITH (NOLOCK) 
	LEFT JOIN dbo.Dep_LicenseeProductSetting LPS WITH (NOLOCK) ON CS.custid = LPS.CustID
WHERE CS.custid NOT IN (SELECT custid FROM #Supers_Offered)
	AND site in ('12Bet', '9bet', 'ABB688', 'Ae88', 'Allbetclub', 'Aoncash', 'Aragon88', 'BE7', 'BetStar', 'Bolanation', 'GooBet', 'iBET', 'Indowin', 'IONclub', 'ITCBet', 'M8bola', 'Macaubet', 'NBCbet', 'Newhonbet', 'Q8bola', 'sbcbet', 'Taipanbet', 'Unobet', 'Uwoniwin', 'Leon' )
	AND CS.custid <= @max_custid
	AND CS.currency NOT IN (27) -- Currency H - it is just test currency, used once in a while 

-- For deployer info
DECLARE @super_cnt INT, @index INT = 0

SET @super_cnt = (SELECT COUNT(*) FROM #supers )

DECLARE @msg NVARCHAR(200) = 'Currently at order %d, SuperID: %d.'

DECLARE @msg_total NVARCHAR(200) = 'Total of supers: %d.'

RAISERROR (@msg_total, 0, 1, @super_cnt) WITH NOWAIT

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #supers
	SET isfinished = 1
		,@srecommend = custid
		,@currency=currency	
		,@isOfferedDCS= isOfferedDCS
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
	
	SET @index = @index + 1
	
	RAISERROR (@msg, 0, 1,@index, @srecommend) WITH NOWAIT
	
	EXEC dbo.[Acc_Dep_DynamicCustSetting_09] @srecommend = @srecommend, @currency=@currency,@isOfferedDCS= isOfferedDCS, @max_custid=@max_custid,@target = 'REPLICATED' 	
				
	--WAITFOR DELAY '00:00:00.280'			
END	

DROP TABLE #supers
DROP TABLE #Supers_Offered		

GO		

-- END STEP 2: Run this SP at replicated DB -----
-----------------------------------------------------------------------------------

---
-- BEGIN STEP 3: Run this SP at DBCust -----
-------------------------------------------------
DECLARE @ProductID INT = 28, @SportType SMALLINT = 220

CREATE TABLE #Supers_Offered (custid INT)

INSERT INTO #Supers_Offered (custid)
SELECT lds.CustID
FROM dbo.Dep_LicenseeProductSetting lds WITH (NOLOCK)
	INNER JOIN dbo.Dep_CustSuper c WITH (NOLOCK) on c.custid = lds.CustID 
	INNER JOIN dbo.Dep_ProductSetting ps WITH (NOLOCK) ON lds.ProductSettingID = PS.ProductSettingID AND ps.ProductID= @ProductID
	INNER JOIN dbo.Dep_ProductSettingDetail psd WITH (NOLOCK) ON psd.ProductSettingID = ps.ProductSettingID
WHERE PSD.SportType = @SportType
 
CREATE TABLE #supers (custid INT, currency INT,isOfferedDCS BIT, isfinished BIT DEFAULT(0))

DECLARE @max_custid INT, @srecommend INT, @site varchar (50), @currency INT, @isOfferedDCS BIT 
SELECT  @max_custid= xxx ---input maxcustid

INSERT INTO #supers(custid,currency,isOfferedDCS)
SELECT CS.custid,CS.currency, CASE WHEN LPS.CustID IS NOT NULL THEN 1 ELSE 0 END AS isOfferedDCS
FROM  dbo.Dep_CustSuper CS WITH (NOLOCK) 
	LEFT JOIN dbo.Dep_LicenseeProductSetting LPS WITH (NOLOCK) ON CS.custid = LPS.CustID
WHERE CS.custid NOT IN (SELECT custid FROM #Supers_Offered)
	AND site in ('12Bet', '9bet', 'ABB688', 'Ae88', 'Allbetclub', 'Aoncash', 'Aragon88', 'BE7', 'BetStar', 'Bolanation', 'GooBet', 'iBET', 'Indowin', 'IONclub', 'ITCBet', 'M8bola', 'Macaubet', 'NBCbet', 'Newhonbet', 'Q8bola', 'sbcbet', 'Taipanbet', 'Unobet', 'Uwoniwin', 'Leon' )
	AND CS.custid <= @max_custid
	AND CS.currency NOT IN (27) -- Currency H - it is just test currency, used once in a while 


-- For deployer info
DECLARE @super_cnt INT, @index INT = 0

SET @super_cnt = (SELECT COUNT(*) FROM #supers )

DECLARE @msg NVARCHAR(200) = 'Currently at order %d, SuperID: %d.'

DECLARE @msg_total NVARCHAR(200) = 'Total of supers: %d.'

RAISERROR (@msg_total, 0, 1, @super_cnt) WITH NOWAIT

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #supers
	SET isfinished = 1
		,@srecommend = custid
		,@currency=currency	
		,@isOfferedDCS = isOfferedDCS		
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
	
	SET @index = @index + 1
	
	RAISERROR (@msg, 0, 1,@index, @srecommend) WITH NOWAIT
	
	EXEC dbo.[Acc_Dep_DynamicCustSetting_09] @srecommend = @srecommend, @currency=@currency,@isOfferedDCS = @isOfferedDCS, @max_custid=@max_custid,@target = 'DBCUST'
		
	--WAITFOR DELAY '00:00:00.280'			
END	

DROP TABLE #supers	
DROP TABLE #Supers_Offered

GO		


-- END STEP 3: Run this SP at DBCust -----
-------------------------------------------------

