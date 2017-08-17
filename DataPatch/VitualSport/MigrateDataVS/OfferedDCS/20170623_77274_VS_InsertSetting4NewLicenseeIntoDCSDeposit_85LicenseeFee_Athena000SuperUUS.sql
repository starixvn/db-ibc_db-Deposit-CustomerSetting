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
	
	DECLARE @ProductProfileList VARCHAR(200) = '9,10,11'
	, @ProductID INT = 5 -- VS
	, @SportType SMALLINT = 180
	-- For ProductStatus param
	, @bitmapOrder INT
	, @IsProductStatus BIT = 1
	, @IsDisable BIT = 0
	, @IsHidden BIT = 0
	
	-- For PT param
	, @IsPTSetting BIT = 1
	, @SuperPT SMALLMONEY = 85
	-- For StakelevelGroup params
	--, @IsStakeLevelGroup BIT = 1
	-- For Betting Limit
	, @IsBetLimit BIT = 1
	
	SET @bitmapOrder = (SELECT bitmapOrder FROM Dep_ProductStatusProfile WITH(NOLOCK) WHERE Sporttype =  @SportType )
	
	CREATE TABLE #tblCust_member (custid INT PRIMARY KEY, ID INT IDENTITY (1,1))
	
	CREATE TABLE #tblCust_sma (custid INT PRIMARY KEY,roleID INT)

	CREATE NONCLUSTERED INDEX inx_tmp ON #tblCust_member (ID)					   
	
	INSERT INTO #tblCust_member (custid)			
	SELECT custid
	FROM custInfo WITH(NOLOCK)
	WHERE srecommend =@srecommend
		AND mrecommend NOT IN (SELECT custid FROM custinfo WITH(NOLOCK)
							   WHERE srecommend=@srecommend and username like '%Acc%' and roleid=3)
		AND custid <= @max_custid
		AND roleid = 1
	
	INSERT INTO #tblCust_sma (custid,roleID)			
	SELECT custid,roleID
	FROM custInfo WITH(NOLOCK)
	WHERE srecommend =@srecommend
		AND mrecommend NOT IN (SELECT custid FROM custinfo WITH(NOLOCK)
							   WHERE srecommend=@srecommend and username like '%Acc%' and roleid=3)
		AND custid <= @max_custid
		AND roleid IN (2,3,4)
		
	
	
	-- Licensee profile list
	IF NOT EXISTS (SELECT 1 
				   FROM Dep_LicenseeProductSetting lps WITH (NOLOCK)
						INNER JOIN Dep_ProductSetting ps WITH (NOLOCK) ON lps.ProductSettingID = ps.ProductSettingID
				   WHERE CustID = @srecommend AND ps.ProductID= @ProductID)
	BEGIN
		INSERT INTO Dep_LicenseeProductSetting (CustID,ProductSettingID)
		SELECT @srecommend, t.val
		FROM dbo.strSplit(@ProductProfileList,',') t
	END	

	SELECT ps.SettingType,psd.SportType,psd.BetType
	INTO #ProductSettingDetail_tmp
	FROM Dep_LicenseeProductSetting lds WITH (NOLOCK)
		INNER JOIN Dep_ProductSetting ps WITH (NOLOCK) ON lds.ProductSettingID = PS.ProductSettingID
		INNER JOIN Dep_ProductSettingDetail psd WITH (NOLOCK) ON psd.ProductSettingID = ps.ProductSettingID
	WHERE lds.CustID =@srecommend AND ps.ProductID= @ProductID

	---------------------------------- START PROCESSING FOR SMA ONLY---------------------------------------------------------------
	-- PT for SMA

	CREATE TABLE #SportTypeCheck (SportType SMALLINT, MaxPerMatchName VARCHAR(200), PRIMARY KEY (SportType) )	
	INSERT INTO #SportTypeCheck 
	VALUES
		(180,'maxpermatch180'),
		(181,'maxpermatch181'),
		(182,'maxpermatch182'),
		(183,'maxpermatch183'),
		(184,'maxpermatch184'),
		(185,'maxpermatch185'),
		(186,'maxpermatch186')
			
	IF EXISTS (SELECT 1 FROM #ProductSettingDetail_tmp WITH (NOLOCK) WHERE SettingType = 1) AND @IsPTSetting = 1
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
			FROM #tblCust_sma ci WITH (NOLOCK)
				CROSS JOIN #ProductSettingDetail_tmp psd WITH (NOLOCK)
			WHERE psd.SettingType = 1 
				AND ci.roleid = 2					
			
		END
	END	
	-- Product Status for SMA
	UPDATE T 
				SET bitmapIsDisabled = CASE 
											WHEN CI.DisableVirtualSports = 0 THEN (SELECT NewBitmap FROM f_CustSetting_GenerateProductStatus (t.bitmapIsDisabled, @bitmapOrder,0)) 
											ELSE (SELECT NewBitmap FROM f_CustSetting_GenerateProductStatus (t.bitmapIsDisabled, @bitmapOrder,1)) 
										END --dbo.f_GenerateProductStatus (t.bitmapIsDisabled, 1,0)		
				, bitmapIsHidden = (SELECT NewBitmap FROM f_CustSetting_GenerateProductStatus (t.bitmapIsHidden, @bitmapOrder,0))--dbo.f_GenerateProductStatus(t.bitmapIsHidden , 1,0)
			
	FROM [dbo].[Dep_CustProductStatus] T WITH (ROWLOCK,UPDLOCK)
		INNER JOIN #tblCust_sma C  WITH (NOLOCK) ON C.custid = T.custid
		INNER JOIN custInfo CI WITH (NOLOCK) ON C.custid = CI.custid
	
	-- Betting Setting for SMA
	-- SMA Level	
	INSERT INTO dbo.Dep_CustBetSetting_Agent(CustID, SportType, BetType, MinBet, MaxBet, MaxPerMatch)
	SELECT CS.custid, dest.sporttype, dest.bettype, cs.minbet, cs.maxbet, A.maxpermatch
	FROM dbo.Dep_CustSetting3rd cs WITH (NOLOCK)
		INNER JOIN #tblCust_sma tbc WITH(NOLOCK) ON cs.CustID = tbc.custid
		INNER JOIN #ProductSettingDetail_tmp dest WITH(NOLOCK) ON dest.SettingType = 2 AND cs.sporttype = dest.SportType
		INNER JOIN dbo.custInfo CI WITH (NOLOCK) ON cs.custID = CI.custid
		CROSS APPLY( VALUES
				('maxpermatch180',CI.maxpermatch180),
				('maxpermatch181',CI.maxpermatch181),
				('maxpermatch182',CI.maxpermatch182),
				('maxpermatch183',CI.maxpermatch183),
				('maxpermatch184',CI.maxpermatch184),
				('maxpermatch185',CI.maxpermatch185),
				('maxpermatch186',CI.maxpermatch186)
         ) AS A(columnname, maxpermatch)
        INNER JOIN #SportTypeCheck S  WITH (NOLOCK) ON S.MaxPerMatchName = A.columnname AND dest.SportType = S.SportType 
	
		
	---------------------------------- START BATCH BY BATCH PROCESSING ---------------------------------------------------------------
	CREATE TABLE  #CustSetting3rd (custID INT, SportType SMALLINT, BetType SMALLINT, minbet MONEY, maxbet MONEY, PRIMARY KEY (CustID,sporttype))
	
	
	DECLARE @StartRow INT = 1, @MaxRow INT,@Threshold INT = 50000, @StopRow INT
	SET @MaxRow = (SELECT MAX(ID) FROM #tblCust_member WITH (NOLOCK))
	
	-- Return in case There is NO members under this srecommend in the table custinfo
	IF @MaxRow IS NULL 
	BEGIN
		PRINT 'There is NO members under this srecommend in the table custinfo. RETURN'
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
				SET bitmapIsDisabled = CASE 
											WHEN CI.DisableVirtualSports = 0 THEN (SELECT NewBitmap FROM f_CustSetting_GenerateProductStatus (t.bitmapIsDisabled, @bitmapOrder,0)) 
											ELSE (SELECT NewBitmap FROM f_CustSetting_GenerateProductStatus (t.bitmapIsDisabled, @bitmapOrder,1)) 
										END --dbo.f_GenerateProductStatus (t.bitmapIsDisabled, 1,0)		
				, bitmapIsHidden = (SELECT NewBitmap FROM f_CustSetting_GenerateProductStatus (t.bitmapIsHidden, @bitmapOrder,0))--dbo.f_GenerateProductStatus(t.bitmapIsHidden , 1,0)
			
		FROM [dbo].[Dep_CustProductStatus] T WITH (ROWLOCK,UPDLOCK)
			INNER JOIN #tblCust_member C  WITH (NOLOCK) ON C.custid = T.custid
			INNER JOIN custInfo CI WITH (NOLOCK) ON C.custid = CI.custid
		WHERE  C.ID >= @StartRow AND C.ID <= @StopRow
		
		-- 2. Betting Limit
					
		INSERT INTO #CustSetting3rd (custID,SportType,BetType,minbet,maxbet)
		SELECT c.custid, cs.sporttype,cs.BetType,  cs.minbet, cs.maxbet
		FROM dbo.Dep_CustSetting3rd cs WITH(NOLOCK)
			INNER JOIN #tblCust_member c WITH(NOLOCK) ON cs.CustID = c.custid 
		WHERE cs.bettype IN (1201,1220,1231) AND C.ID >= @StartRow AND C.ID <= @StopRow	
		
		--Member Level
		INSERT INTO dbo.Dep_CustBetSetting_Member(CustID, SportType, BetType, MinBet, MaxBet, MaxPerMatch)
		SELECT CS.custid, cs.sporttype, cs.bettype, cs.minbet, cs.maxbet, maxpermatch180
		FROM #CustSetting3rd cs  WITH (NOLOCK) 
			INNER JOIN custInfo CI WITH (NOLOCK) ON cs.custID = CI.custid
		WHERE  cs.SportType = 180
		
		INSERT INTO dbo.Dep_CustBetSetting_Member(CustID, SportType, BetType, MinBet, MaxBet, MaxPerMatch)
		SELECT CS.custid, cs.sporttype, cs.bettype, cs.minbet, cs.maxbet, maxpermatch181
		FROM #CustSetting3rd cs  WITH (NOLOCK) 
			INNER JOIN custInfo CI WITH (NOLOCK) ON cs.custID = CI.custid
		WHERE cs.SportType = 181
		
		INSERT INTO dbo.Dep_CustBetSetting_Member(CustID, SportType, BetType, MinBet, MaxBet, MaxPerMatch)
		SELECT CS.custid, cs.sporttype, cs.bettype, cs.minbet, cs.maxbet, maxpermatch182
		FROM #CustSetting3rd cs  WITH (NOLOCK) 
			INNER JOIN custInfo CI WITH (NOLOCK) ON cs.custID = CI.custid
		WHERE cs.SportType = 182
		
		INSERT INTO dbo.Dep_CustBetSetting_Member(CustID, SportType, BetType, MinBet, MaxBet, MaxPerMatch)
		SELECT CS.custid, cs.sporttype, cs.bettype, cs.minbet, cs.maxbet, maxpermatch183
		FROM #CustSetting3rd cs  WITH (NOLOCK) 
			INNER JOIN custInfo CI WITH (NOLOCK) ON cs.custID = CI.custid
		WHERE cs.SportType = 183
		
		INSERT INTO dbo.Dep_CustBetSetting_Member(CustID, SportType, BetType, MinBet, MaxBet, MaxPerMatch)
		SELECT CS.custid, cs.sporttype, cs.bettype, cs.minbet, cs.maxbet, maxpermatch184
		FROM #CustSetting3rd cs WITH (NOLOCK)
			INNER JOIN custInfo CI WITH (NOLOCK) ON cs.custID = CI.custid
		WHERE cs.SportType = 184
		
		INSERT INTO dbo.Dep_CustBetSetting_Member(CustID, SportType, BetType, MinBet, MaxBet, MaxPerMatch)
		SELECT CS.custid, cs.sporttype, cs.bettype, cs.minbet, cs.maxbet, maxpermatch185
		FROM #CustSetting3rd cs  WITH (NOLOCK) 
			INNER JOIN custInfo CI WITH (NOLOCK) ON cs.custID = CI.custid
		WHERE cs.SportType = 185
		
		INSERT INTO dbo.Dep_CustBetSetting_Member(CustID, SportType, BetType, MinBet, MaxBet, MaxPerMatch)
		SELECT CS.custid, cs.sporttype, cs.bettype, cs.minbet, cs.maxbet, maxpermatch186
		FROM #CustSetting3rd cs  WITH (NOLOCK) 
			INNER JOIN custInfo CI WITH (NOLOCK) ON cs.custID = CI.custid
		WHERE cs.SportType = 186
		
		-- Starting to process data --
		IF @StopRow = @MaxRow BREAK
		
		SET @StartRow = @StopRow + 1
		
		SET @StopRow =  @StopRow + 1 + @Threshold
		
		IF @StopRow >= @MaxRow
			SET @StopRow = @MaxRow
		
		TRUNCATE TABLE #CustSetting3rd
		
		WAITFOR DELAY '00:00:00.200'
		
	END
	---------------------------------- END OF BATCH BY BATCH PROCESSING ---------------------------------------------------------------
	DROP TABLE #ProductSettingDetail_tmp
	DROP TABLE #tblCust_member
	DROP TABLE #tblCust_sma
	DROP TABLE #SportTypeCheck
	DROP TABLE #CustSetting3rd

END	
GO
-- END STEP 1: DEPLOY THIS SP @ DBCUST.CustDB -------

------------------------------------------------------	
-- BEGIN STEP 2: Run this SP at replicated DB -----
--------------------------------------------------------------------------------------
DECLARE @ProductID INT = 5

CREATE TABLE #supers (custid INT, currency INT, isfinished BIT DEFAULT(0))

DECLARE @max_custid INT, @srecommend INT, @site varchar (50)
SELECT  @max_custid= xxx ---input maxcustid

INSERT INTO #supers(custid)
SELECT custid
FROM  Dep_CustSuper WITH (NOLOCK) 
WHERE custid = 10063437 -- Athena000SuperUUS


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
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
	
	SET @index = @index + 1
	
	RAISERROR (@msg, 0, 1,@index, @srecommend) WITH NOWAIT
	
	EXEC dbo.[Acc_Dep_DynamicCustSetting_09] @srecommend = @srecommend,  @max_custid=@max_custid,@target = 'REPLICATED' 	
				
	--WAITFOR DELAY '00:00:00.280'			
END	
DROP TABLE #supers

GO		

-- END STEP 2: Run this SP at replicated DB -----
-----------------------------------------------------------------------------------

---
-- BEGIN STEP 3: Run this SP at DBCust -----
-------------------------------------------------
DECLARE @ProductID INT = 5

CREATE TABLE #supers (custid INT, currency INT, isfinished BIT DEFAULT(0))

DECLARE @max_custid INT, @srecommend INT, @site varchar (50)
SELECT  @max_custid= xxx ---input maxcustid

INSERT INTO #supers(custid)
SELECT custid
FROM  Dep_CustSuper WITH (NOLOCK) 
WHERE custid = 10063437 -- Athena000SuperUUS

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
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
	
	SET @index = @index + 1
	
	RAISERROR (@msg, 0, 1,@index, @srecommend) WITH NOWAIT
	
	EXEC dbo.[Acc_Dep_DynamicCustSetting_09] @srecommend = @srecommend,  @max_custid=@max_custid,@target = 'DBCUST'
		
	--WAITFOR DELAY '00:00:00.280'			
END	

DROP TABLE #supers	

GO		


-- END STEP 3: Run this SP at DBCust -----
-------------------------------------------------

