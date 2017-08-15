/*
	Created: 20170626@Helen
	Task: insert the Setting of VS of new licensees into the DCS database.
	Redmine: https://redmine.nexcel.vn/issues/77274
	DB: DBCUST/CUSTDB
*/ 
-- BEGIN STEP 1: Deploy this SP at DBCUST.CustDB, Run only in the FIRST running
------------------------------------------------------

ALTER PROCEDURE [dbo].[Acc_Dep_DynamicCustSetting_09]
 	 @srecommend INT
	, @currency INT
	, @max_custid INT
	, @target VARCHAR(20)
	
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
	
	DECLARE @ProductProfileList VARCHAR(200) = '12,13,14'
	, @ProductID INT = 27 -- VS
	, @SportType SMALLINT = 190
	-- For ProductStatus param
	, @bitmapOrder INT
	, @IsProductStatus BIT = 1
	, @IsDisable BIT = 0
	, @IsHidden BIT = 0
	
	-- For PT param
	, @IsPTSetting BIT = 1
	, @SuperPT SMALLMONEY = 87.5
	-- For StakelevelGroup params
	--, @IsStakeLevelGroup BIT = 1
	-- For Betting Limit
	, @IsBetLimit BIT = 1
	
	SET @bitmapOrder = (SELECT bitmapOrder FROM dbo.Dep_ProductStatusProfile WITH(NOLOCK) WHERE Sporttype =  @SportType )
	
	CREATE TABLE #tblCust_member (custid INT PRIMARY KEY,maxpermatch180 MONEY, ID INT IDENTITY (1,1))
	
	CREATE TABLE #tblCust_sma (custid INT PRIMARY KEY,maxpermatch180 MONEY, roleID INT)

	CREATE NONCLUSTERED INDEX inx_tmp ON #tblCust_member (ID)								   
	
	INSERT INTO #tblCust_member (custid,maxpermatch180)			
	SELECT custid,maxpermatch180
	FROM dbo.custInfo WITH(NOLOCK)
	WHERE srecommend =@srecommend
		AND mrecommend NOT IN (SELECT custid FROM custinfo WITH(NOLOCK)
							   WHERE srecommend=@srecommend and username like '%Acc%' and roleid=3)
		AND custid <= @max_custid
		AND roleid = 1
	
	INSERT INTO #tblCust_sma (custid,roleID, maxpermatch180)			
	SELECT custid,roleID, maxpermatch180
	FROM dbo.custInfo WITH(NOLOCK)
	WHERE srecommend =@srecommend
		AND mrecommend NOT IN (SELECT custid FROM custinfo WITH(NOLOCK)
							   WHERE srecommend=@srecommend and username like '%Acc%' and roleid=3)
		AND custid <= @max_custid
		AND roleid IN (2,3,4)
		
		
	-- Licensee profile list
	IF NOT EXISTS (SELECT 1 
				   FROM dbo.Dep_LicenseeProductSetting lps WITH (NOLOCK)
						INNER JOIN dbo.Dep_ProductSetting ps WITH (NOLOCK) ON lps.ProductSettingID = ps.ProductSettingID
				   WHERE CustID = @srecommend AND ps.ProductID= @ProductID)
	BEGIN
		INSERT INTO Dep_LicenseeProductSetting (CustID,ProductSettingID)
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
	IF EXISTS (SELECT 1 FROM #ProductSettingDetail_tmp WHERE SettingType = 1) AND @IsPTSetting = 1
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
			INSERT INTO Dep_CustPTGroupSetting_Member (AgentID,SportType,BetType,IsLive,SuperPT,MasterPT,AgentPT)				
			SELECT ci.custid,psd.SportType,psd.BetType,0,0,0,@SuperPT
			FROM #tblCust_SMA ci WITH (NOLOCK)
				CROSS JOIN #ProductSettingDetail_tmp psd WITH (NOLOCK)
			WHERE psd.SettingType = 1 
				AND ci.roleid = 2					
			
		END
	END	

	-- Product Status for SMA
	UPDATE T 
			SET bitmapIsDisabled = (SELECT NewBitmap FROM f_CustSetting_GenerateProductStatus (t.bitmapIsDisabled, @bitmapOrder,0)) 
									
			, bitmapIsHidden = (SELECT NewBitmap FROM f_CustSetting_GenerateProductStatus (t.bitmapIsHidden, @bitmapOrder,0))
		
	FROM [dbo].[Dep_CustProductStatus] T WITH (ROWLOCK,UPDLOCK)
		INNER JOIN #tblCust_sma C WITH (NOLOCK) ON C.custid = T.custid
		
	
	-- Betting Limit for SMA
	INSERT INTO dbo.Dep_CustBetSetting_Agent(CustID, SportType, BetType, MinBet, MaxBet, MaxPerMatch)
	SELECT ci.custid, psd.sporttype, psd.bettype, cs.minbet, cs.maxbet, ci.maxpermatch180					 
	FROM dbo.Dep_CustSetting3rd cs WITH (NOLOCK)
	   INNER JOIN #tblCust_sma ci WITH(NOLOCK) ON cs.CustID = ci.custid AND cs.sporttype = 180
       CROSS JOIN #ProductSettingDetail_tmp psd WITH (NOLOCK)
	WHERE psd.SettingType = 2 

	---------------------------------- END OF PROCESSING FOR SMA ONLY---------------------------------------------------------------
			
	---------------------------------- START BATCH BY BATCH PROCESSING ---------------------------------------------------------------
	CREATE TABLE  #CustSetting3rd (custID INT, minbet MONEY, maxbet MONEY,maxpermatch180 MONEY, PRIMARY KEY (CustID))
	
	DECLARE @StartRow INT = 1, @MaxRow INT,@Threshold INT = 50000, @StopRow INT
	SET @MaxRow = (SELECT MAX(ID) FROM #tblCust_member)
	
	-- Return in case there is members under this srecommend in the table custinfo
	IF @MaxRow IS NULL 
	BEGIN
		PRINT 'There is no members under this srecommend in the table custinfo. RETURN'
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
		/*
		-- Starting to process data --
		WHERE  CI.ID >= @StartRow AND CI.ID <= @StopRow
		*/
		
		-- 1. Product Status
		UPDATE T 
				SET bitmapIsDisabled = (SELECT NewBitmap FROM f_CustSetting_GenerateProductStatus (t.bitmapIsDisabled, @bitmapOrder,0)) 
									
				, bitmapIsHidden = (SELECT NewBitmap FROM f_CustSetting_GenerateProductStatus (t.bitmapIsHidden, @bitmapOrder,0))
			
		FROM [dbo].[Dep_CustProductStatus] T (ROWLOCK)
			INNER JOIN #tblCust_member C WITH (NOLOCK) ON C.custid = T.custid
		WHERE  C.ID >= @StartRow AND C.ID <= @StopRow
		
		-- 2. Betting Limit
		INSERT INTO #CustSetting3rd (custID,minbet,maxbet,maxpermatch180)
		SELECT ci.custid, cs.minbet, cs.maxbet, ci.maxpermatch180
		FROM dbo.Dep_CustSetting3rd cs WITH(NOLOCK)
			INNER JOIN #tblCust_member ci WITH(NOLOCK) ON cs.CustID = ci.custid 
		WHERE cs.bettype = 1201 AND sporttype = 180 AND CI.ID >= @StartRow AND CI.ID <= @StopRow
				
		--Member Level
		INSERT INTO dbo.Dep_CustBetSetting_Member(CustID, SportType, BetType, MinBet, MaxBet, MaxPerMatch)
		SELECT cs.custid, 190, 2701, cs.minbet, cs.maxbet, cs.maxpermatch180					 
		FROM #CustSetting3rd cs WITH (NOLOCK)
		
		INSERT INTO dbo.Dep_CustBetSetting_Member(CustID, SportType, BetType, MinBet, MaxBet, MaxPerMatch)
		SELECT cs.custid, 191, 2701, cs.minbet, cs.maxbet, cs.maxpermatch180					 
		FROM #CustSetting3rd cs WITH (NOLOCK)
		
		INSERT INTO dbo.Dep_CustBetSetting_Member(CustID, SportType, BetType, MinBet, MaxBet, MaxPerMatch)
		SELECT cs.custid, 199, 2799, cs.minbet, cs.maxbet, cs.maxpermatch180					 
		FROM #CustSetting3rd cs WITH (NOLOCK)
		
		-- Starting to process data --
		IF @StopRow = @MaxRow BREAK
		
		SET @StartRow = @StopRow + 1
		
		SET @StopRow =  @StopRow + 1 + @Threshold
		
		IF @StopRow >= @MaxRow
			SET @StopRow = @MaxRow
		
		TRUNCATE TABLE #CustSetting3rd
		
		WAITFOR DELAY '00:00:00.200'
		
	END

	DROP TABLE #ProductSettingDetail_tmp
	DROP TABLE #tblCust_sma
	DROP TABLE #tblCust_member
	DROP TABLE #CustSetting3rd

END	
GO
-- END STEP 1: DEPLOY THIS SP @ DBCUST.CustDB -------

------------------------------------------------------	
-- BEGIN STEP 2: Run this SP at replicated DB -----
--------------------------------------------------------------------------------------
DECLARE @ProductID INT = 27

CREATE TABLE #Supers_Offered (custid INT)
INSERT INTO #Supers_Offered (custid)
SELECT lds.CustID
FROM Dep_LicenseeProductSetting lds WITH (NOLOCK)
	INNER JOIN Dep_CustSuper c WITH (NOLOCK) on c.custid = lds.CustID 
	INNER JOIN Dep_ProductSetting ps WITH (NOLOCK) ON lds.ProductSettingID = PS.ProductSettingID AND ps.ProductID= @ProductID
	INNER JOIN Dep_ProductSettingDetail psd WITH (NOLOCK) ON psd.ProductSettingID = ps.ProductSettingID
WHERE PSD.SportType IN (190,191,199)
 
CREATE TABLE #supers (custid INT, currency INT, isfinished BIT DEFAULT(0))

DECLARE @max_custid INT, @srecommend INT, @site varchar (50), @currency INT 
SELECT  @max_custid= xxx ---input maxcustid

INSERT INTO #supers(custid,currency)
SELECT custid,currency
FROM  Dep_CustSuper with(nolock) 
WHERE custid NOT IN (SELECT custid FROM #Supers_Offered)
	AND site in ('HAIFA')
	AND custid <= @max_custid
	AND currency NOT IN (27) -- Currency H - it is just test currency, used once in a while 


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
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
	
	SET @index = @index + 1
	
	RAISERROR (@msg, 0, 1,@index, @srecommend) WITH NOWAIT
	
	EXEC dbo.[Acc_Dep_DynamicCustSetting_09] @srecommend = @srecommend, @currency=@currency, @max_custid=@max_custid,@target = 'REPLICATED' 	
				
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
DECLARE @ProductID INT = 27

CREATE TABLE #Supers_Offered (custid INT)

INSERT INTO #Supers_Offered (custid)
SELECT lds.CustID
FROM Dep_LicenseeProductSetting lds WITH (NOLOCK)
	INNER JOIN Dep_CustSuper c WITH (NOLOCK) on c.custid = lds.CustID 
	INNER JOIN Dep_ProductSetting ps WITH (NOLOCK) ON lds.ProductSettingID = PS.ProductSettingID AND ps.ProductID= @ProductID
	INNER JOIN Dep_ProductSettingDetail psd WITH (NOLOCK) ON psd.ProductSettingID = ps.ProductSettingID
WHERE PSD.SportType IN (190,191,199)
 
CREATE TABLE #supers (custid INT, currency INT, isfinished BIT DEFAULT(0))

DECLARE @max_custid INT, @srecommend INT, @site varchar (50), @currency INT 
SELECT  @max_custid= xxx ---input maxcustid

INSERT INTO #supers(custid,currency)
SELECT custid,currency
FROM  Dep_CustSuper WITH (NOLOCK) 
WHERE custid NOT IN (SELECT custid FROM #Supers_Offered)
	AND site in ('HAIFA')
	AND custid <= @max_custid
	AND currency NOT IN (27) -- Currency H - it is just test currency, used once in a while 


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
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
	
	SET @index = @index + 1
	
	RAISERROR (@msg, 0, 1,@index, @srecommend) WITH NOWAIT
	
	EXEC dbo.[Acc_Dep_DynamicCustSetting_09] @srecommend = @srecommend, @currency=@currency, @max_custid=@max_custid,@target = 'DBCUST'
		
	--WAITFOR DELAY '00:00:00.280'			
END	

DROP TABLE #supers	
DROP TABLE #Supers_Offered	
GO		


-- END STEP 3: Run this SP at DBCust -----
-------------------------------------------------

