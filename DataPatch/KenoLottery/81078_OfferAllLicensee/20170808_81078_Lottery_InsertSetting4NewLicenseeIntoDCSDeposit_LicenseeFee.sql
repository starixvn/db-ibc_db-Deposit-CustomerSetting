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
	, @isOfferedDCS BIT
	, @max_custid INT
	, @target VARCHAR(20)
	
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
	
	DECLARE @ProductProfileList VARCHAR(200) 
		-- For ProductStatus param
		, @bitmapOrder INT
		, @bitmap_0 BINARY(32)
		-- For PT param
		, @SuperPT SMALLMONEY 
		-- For Sport Info
		, @SportType SMALLINT 
		, @Bettype SMALLINT
		, @SportTypeRef SMALLINT 
		, @GameTypeIDRef INT 
		, @ProductID INT 
	
	DECLARE @StartRow INT, @MaxRow INT,@Threshold INT, @StopRow INT
	
	CREATE TABLE #tblCust_member (custid INT PRIMARY KEY, ID INT IDENTITY (1,1))
	
	CREATE TABLE #tblCust_sma (custid INT PRIMARY KEY, roleID INT)

	CREATE NONCLUSTERED INDEX inx_tmp ON #tblCust_member (ID)								   
	
	SET @ProductProfileList  = '15,16,17'
	SET @SuperPT = 90
	SET @SportType = 220
	SET @Bettype = 1021
	SET @SportTypeRef = 202
	SET @GameTypeIDRef = 1
	SET @ProductID = 28
	
	SET @bitmapOrder = (SELECT bitmapOrder FROM dbo.Dep_ProductStatusProfile WITH(NOLOCK) WHERE Sporttype =  @SportType )
	-- Calculating bitmap value 
	SET @bitmap_0 =  dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, @bitmapOrder,0)
	
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
			
		-- PT Group Member: Insert Setting for Agent 
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
					SET bitmapIsDisabled = (SELECT NewBitmap FROM dbo.f_CustSetting_GenerateProductStatus (t.bitmapIsDisabled, @bitmapOrder,0)) 
											
					, bitmapIsHidden = (SELECT NewBitmap FROM dbo.f_CustSetting_GenerateProductStatus (t.bitmapIsHidden, @bitmapOrder,0))
				
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
	SET @MaxRow = (SELECT MAX(ID) FROM #tblCust_member WITH (NOLOCK))		
	
	SET @StartRow = 1
	SET @Threshold = 50000
	
	-- Return in case There is no members to process. RETURN
	IF @MaxRow IS NULL 
	BEGIN
		PRINT 'There is no members to process. RETURN'
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
		OPTION (MAXDOP 1)   
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
	

END	
GO
-- END STEP 1: DEPLOY THIS SP @ DBCUST.CustDB -------

------------------------------------------------------	
-- BEGIN STEP 2: Run this SP at replicated DB -----
--------------------------------------------------------------------------------------
DECLARE @ProductID INT, @SportType SMALLINT 

DECLARE @max_custid INT, @srecommend INT, @site varchar (50),  @isOfferedDCS BIT 
DECLARE @super_cnt INT, @index INT = 0

CREATE TABLE #Supers_Offered (custid INT)
CREATE TABLE #supers (custid INT, isOfferedDCS BIT, isfinished BIT DEFAULT(0))

SET @max_custid= xxx ---input maxcustid
SET @ProductID = 28
SET @SportType = 220

INSERT INTO #Supers_Offered (custid)
SELECT lds.CustID
FROM dbo.Dep_LicenseeProductSetting lds WITH (NOLOCK)
	INNER JOIN dbo.Dep_CustSuper c WITH (NOLOCK) on c.custid = lds.CustID 
	INNER JOIN dbo.Dep_ProductSetting ps WITH (NOLOCK) ON lds.ProductSettingID = PS.ProductSettingID AND ps.ProductID= @ProductID
	INNER JOIN dbo.Dep_ProductSettingDetail psd WITH (NOLOCK) ON psd.ProductSettingID = ps.ProductSettingID
WHERE PSD.SportType = @SportType AND C.site in ('12Bet', '9bet', 'ABB688', 'Ae88', 'Allbetclub', 'Aoncash', 'Aragon88', 'BE7', 'BetStar', 'Bolanation', 'GooBet', 'iBET', 'Indowin', 'IONclub', 'ITCBet', 'M8bola', 'Macaubet', 'NBCbet', 'Newhonbet', 'Q8bola', 'sbcbet', 'Taipanbet', 'Unobet', 'Uwoniwin', 'Leon' )

INSERT INTO #supers(custid,isOfferedDCS)
SELECT DISTINCT CS.custid, CASE WHEN LPS.CustID IS NOT NULL THEN 1 ELSE 0 END AS isOfferedDCS
FROM  dbo.Dep_CustSuper CS WITH (NOLOCK) 
	LEFT JOIN dbo.Dep_LicenseeProductSetting LPS WITH (NOLOCK) ON CS.custid = LPS.CustID
WHERE CS.custid NOT IN (SELECT custid FROM #Supers_Offered)
	AND site in ('12Bet', '9bet', 'ABB688', 'Ae88', 'Allbetclub', 'Aoncash', 'Aragon88', 'BE7', 'BetStar', 'Bolanation', 'GooBet', 'iBET', 'Indowin', 'IONclub', 'ITCBet', 'M8bola', 'Macaubet', 'NBCbet', 'Newhonbet', 'Q8bola', 'sbcbet', 'Taipanbet', 'Unobet', 'Uwoniwin', 'Leon' )
	AND CS.custid <= @max_custid
	AND CS.currency NOT IN (27) -- Currency H - it is just test currency, used once in a while 

-- For deployer info
SET @super_cnt = (SELECT COUNT(*) FROM #supers )

DECLARE @msg NVARCHAR(200) = 'Currently at order %d, SuperID: %d.'

DECLARE @msg_total NVARCHAR(200) = 'Total of supers: %d.'

RAISERROR (@msg_total, 0, 1, @super_cnt) WITH NOWAIT

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #supers
	SET isfinished = 1
		,@srecommend = custid
		,@isOfferedDCS= isOfferedDCS
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
	
	SET @index = @index + 1
	
	RAISERROR (@msg, 0, 1,@index, @srecommend) WITH NOWAIT
	
	EXEC dbo.[Acc_Dep_DynamicCustSetting_09] @srecommend = @srecommend, @isOfferedDCS= @isOfferedDCS, @max_custid=@max_custid,@target = 'REPLICATED' 	
				
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
DECLARE @ProductID INT, @SportType SMALLINT 

DECLARE @max_custid INT, @srecommend INT, @site varchar (50),  @isOfferedDCS BIT 
DECLARE @super_cnt INT, @index INT = 0

CREATE TABLE #Supers_Offered (custid INT)
CREATE TABLE #supers (custid INT, isOfferedDCS BIT, isfinished BIT DEFAULT(0))

SET @max_custid= xxx ---input maxcustid
SET @ProductID = 28
SET @SportType = 220

INSERT INTO #Supers_Offered (custid)
SELECT lds.CustID
FROM dbo.Dep_LicenseeProductSetting lds WITH (NOLOCK)
	INNER JOIN dbo.Dep_CustSuper c WITH (NOLOCK) on c.custid = lds.CustID 
	INNER JOIN dbo.Dep_ProductSetting ps WITH (NOLOCK) ON lds.ProductSettingID = PS.ProductSettingID AND ps.ProductID= @ProductID
	INNER JOIN dbo.Dep_ProductSettingDetail psd WITH (NOLOCK) ON psd.ProductSettingID = ps.ProductSettingID
WHERE PSD.SportType = @SportType AND C.site in ('12Bet', '9bet', 'ABB688', 'Ae88', 'Allbetclub', 'Aoncash', 'Aragon88', 'BE7', 'BetStar', 'Bolanation', 'GooBet', 'iBET', 'Indowin', 'IONclub', 'ITCBet', 'M8bola', 'Macaubet', 'NBCbet', 'Newhonbet', 'Q8bola', 'sbcbet', 'Taipanbet', 'Unobet', 'Uwoniwin', 'Leon' )

INSERT INTO #supers(custid,isOfferedDCS)
SELECT DISTINCT CS.custid, CASE WHEN LPS.CustID IS NOT NULL THEN 1 ELSE 0 END AS isOfferedDCS
FROM  dbo.Dep_CustSuper CS WITH (NOLOCK) 
	LEFT JOIN dbo.Dep_LicenseeProductSetting LPS WITH (NOLOCK) ON CS.custid = LPS.CustID 
WHERE CS.custid NOT IN (SELECT custid FROM #Supers_Offered)
	AND site in ('12Bet', '9bet', 'ABB688', 'Ae88', 'Allbetclub', 'Aoncash', 'Aragon88', 'BE7', 'BetStar', 'Bolanation', 'GooBet', 'iBET', 'Indowin', 'IONclub', 'ITCBet', 'M8bola', 'Macaubet', 'NBCbet', 'Newhonbet', 'Q8bola', 'sbcbet', 'Taipanbet', 'Unobet', 'Uwoniwin', 'Leon' )
	AND CS.custid <= @max_custid
	AND CS.currency NOT IN (27) -- Currency H - it is just test currency, used once in a while 

-- For deployer info
SET @super_cnt = (SELECT COUNT(*) FROM #supers WITH (NOLOCK))

DECLARE @msg NVARCHAR(200) = 'Currently at order %d, SuperID: %d.'

DECLARE @msg_total NVARCHAR(200) = 'Total of supers: %d.'

RAISERROR (@msg_total, 0, 1, @super_cnt) WITH NOWAIT

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #supers
	SET isfinished = 1
		,@srecommend = custid
		,@isOfferedDCS = isOfferedDCS		
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
	
	SET @index = @index + 1
	
	RAISERROR (@msg, 0, 1,@index, @srecommend) WITH NOWAIT
	
	EXEC dbo.[Acc_Dep_DynamicCustSetting_09] @srecommend = @srecommend,@isOfferedDCS = @isOfferedDCS, @max_custid=@max_custid,@target = 'DBCUST'
		
	--WAITFOR DELAY '00:00:00.280'			
END	

DROP TABLE #supers	
DROP TABLE #Supers_Offered

GO		


-- END STEP 3: Run this SP at DBCust -----
-------------------------------------------------

