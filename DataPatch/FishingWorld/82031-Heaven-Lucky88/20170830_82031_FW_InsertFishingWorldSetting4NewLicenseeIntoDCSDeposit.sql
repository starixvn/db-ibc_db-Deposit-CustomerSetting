/*
	Created: 20170831@Helen
	Task: DCS Deposit for Fishing World - [Redmine:82031]
	Redmine: https://nexdev.net/issues/82031
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
	
	   )
		RETURN
	
	DECLARE @ProductProfileList VARCHAR(200)
		, @ProductID INT 
		-- For PT param
		, @SuperPT SMALLMONEY 
	
	DECLARE @bitmap_0 BINARY(32)
	DECLARE @SportType SMALLINT, @BetType SMALLINT ,  @bitmapOrder INT 

	CREATE TABLE #tblCust (custid int,agentid int, roleid int) 
	
	SET @ProductProfileList = '7,8'
	SET @SportType = 219
	SET @BetType = 1011
	SET @SuperPT = 90
	SET @ProductID = 24 -- Fishing World
	
	SET @bitmapOrder = (SELECT bitmapOrder FROM dbo.Dep_ProductStatusProfile WITH (NOLOCK) WHERE Sporttype = @SportType AND Bettype = @BetType)
	-- Calculating bitmap value 
	SET @bitmap_0 =  dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, @bitmapOrder,0)

	INSERT INTO #tblCust (custid,agentid,roleid)			
	SELECT custid,recommend,roleid
	FROM dbo.custInfo WITH(NOLOCK)
	WHERE srecommend =@srecommend
		AND mrecommend NOT IN (SELECT custid FROM dbo.custinfo WITH(NOLOCK)
							   WHERE srecommend=@srecommend and username like '%Acc%' and roleid=3)
		AND custid <= @max_custid
							   
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
	WHERE lds.CustID = @srecommend  AND ps.ProductID= @ProductID

	-- PT processing
	
	IF EXISTS (SELECT 1 FROM #ProductSettingDetail_tmp WITH (NOLOCK) WHERE SettingType = 1) 
	BEGIN
		RAISERROR ('PT Processing', 0, 1) WITH NOWAIT
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
		FROM #tblCust ci WITH (NOLOCK)
			CROSS JOIN #ProductSettingDetail_tmp psd WITH (NOLOCK)
		WHERE psd.SettingType = 1 
			AND ci.roleid IN (2,3,4)
			
		-- For Member
		--Insert new PT Group
		INSERT INTO dbo.Dep_CustPTGroupSetting_Member (AgentID,SportType,BetType,IsLive,SuperPT,MasterPT,AgentPT)				
		SELECT ci.agentid,psd.SportType,psd.BetType,0,0,0,@SuperPT
		FROM #tblCust ci WITH (NOLOCK)
				CROSS JOIN #ProductSettingDetail_tmp psd WITH (NOLOCK) 
		WHERE psd.SettingType = 1 
			AND ci.roleid = 2					
		
		-- Insert New
		INSERT INTO dbo.Dep_CustSettingMode (CustID,IsGroupedPT)
		SELECT c.custid,1
		FROM #tblCust C WITH (NOLOCK)
		WHERE C.roleid = 1 AND NOT EXISTS (SELECT 1 FROM dbo.Dep_CustSettingMode C1 (NOLOCK) WHERE c1.CustID = c.Custid)
		
	END	

	-- Status Process
	IF EXISTS (SELECT 1 FROM #ProductSettingDetail_tmp WITH (NOLOCK) WHERE SettingType = 4) 
	BEGIN
	
		RAISERROR ('Status Processing', 0, 1) WITH NOWAIT
		-- Update if exists
		UPDATE T 
				SET bitmapIsDisabled = (SELECT NewBitmap FROM dbo.f_CustSetting_GenerateProductStatus (t.bitmapIsDisabled, @bitmapOrder,0))	
					, bitmapIsHidden = (SELECT NewBitmap FROM dbo.f_CustSetting_GenerateProductStatus (t.bitmapIsDisabled, @bitmapOrder,0))
		FROM [dbo].[Dep_CustProductStatus] T WITH (ROWLOCK,UPDLOCK)
			INNER JOIN #tblCust C ON C.custid = T.custid
		
		-- Insert new	
		INSERT INTO [dbo].[Dep_CustProductStatus](CustID,bitmapIsDisabled,bitmapIsHidden)
		SELECT	c.custid
				, @bitmap_0 AS bitmapIsDisabled
				, @bitmap_0  AS bitmapIsHidden
		FROM #tblCust C
		WHERE NOT EXISTS (SELECT 1 FROM [dbo].[Dep_CustProductStatus] T WITH (NOLOCK) WHERE t.custid = c.custid)
		
	END	

	DROP TABLE #ProductSettingDetail_tmp
	DROP TABLE #tblCust

END	

GO
-- END STEP 1: DEPLOY THIS SP @ DBCUST.CustDB -------

------------------------------------------------------	
-- BEGIN STEP 2: Run this SP at replicated DB -----
--------------------------------------------------------------------------------------
DECLARE @ProductID INT, @SportType INT 
DECLARE @max_custid INT, @srecommend INT, @site varchar (50), @currency int 

DECLARE @super_cnt INT, @index INT 
DECLARE @msg nvarchar(200) 
DECLARE @msg_total nvarchar(200)

CREATE TABLE #Supers_Offered (custid int)
CREATE TABLE #supers (custid int, isfinished bit default(0))

SET @ProductID = 24
SET @SportType = 219
SET @index = 0

SET @msg = 'Currently at order %d, SuperID: %d.'
SET @msg_total = 'Total of supers: %d.'

SELECT  @max_custid= xxx ---input maxcustid

INSERT INTO #Supers_Offered (custid)
SELECT lds.CustID
FROM dbo.Dep_LicenseeProductSetting lds WITH (NOLOCK)
	INNER JOIN dbo.Dep_CustSuper c WITH (NOLOCK) ON c.custid = lds.CustID 
	INNER JOIN dbo.Dep_ProductSetting ps WITH (NOLOCK) ON lds.ProductSettingID = PS.ProductSettingID AND ps.ProductID= @ProductID
	INNER JOIN dbo.Dep_ProductSettingDetail psd WITH (NOLOCK) ON psd.ProductSettingID = ps.ProductSettingID
WHERE PSD.SportType = @SportType AND C.site in ('Heaven','Lucky88')

INSERT INTO #supers(custid)
SELECT custid
FROM  dbo.Dep_CustSuper with(nolock) 
WHERE custid NOT IN (SELECT custid FROM #Supers_Offered WITH (NOLOCK))
	AND site in ('Heaven','Lucky88')
	AND currency NOT IN (27) -- Currency H - it is just test currency, used once in a while 
	AND custid <= @max_custid

SET @super_cnt = (SELECT COUNT(*) FROM #supers WITH (NOLOCK))

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
	
	EXEC dbo.[Acc_Dep_DynamicCustSetting_09] @srecommend = @srecommend, @max_custid=@max_custid,@target = 'REPLICATED' 	
				
	WAITFOR DELAY '00:00:00.280'			
END	

DROP TABLE #supers	
DROP TABLE #Supers_Offered
	
GO		

-- END STEP 2: Run this SP at replicated DB-----
-----------------------------------------------------------------------------------
-- BEGIN STEP 3: Run this SP at DBCust -----
-------------------------------------------------
DECLARE @ProductID INT, @SportType INT 
DECLARE @max_custid INT, @srecommend INT, @site varchar (50), @currency int 

DECLARE @super_cnt INT, @index INT 
DECLARE @msg nvarchar(200) 
DECLARE @msg_total nvarchar(200)

CREATE TABLE #Supers_Offered (custid int)
CREATE TABLE #supers (custid int, isfinished bit default(0))

SET @ProductID = 24
SET @SportType = 219
SET @index = 0

SET @msg = 'Currently at order %d, SuperID: %d.'
SET @msg_total = 'Total of supers: %d.'

SELECT  @max_custid= xxx ---input maxcustid

INSERT INTO #Supers_Offered (custid)
SELECT lds.CustID
FROM dbo.Dep_LicenseeProductSetting lds WITH (NOLOCK)
	INNER JOIN dbo.Dep_CustSuper c WITH (NOLOCK) ON c.custid = lds.CustID 
	INNER JOIN dbo.Dep_ProductSetting ps WITH (NOLOCK) ON lds.ProductSettingID = PS.ProductSettingID AND ps.ProductID= @ProductID
	INNER JOIN dbo.Dep_ProductSettingDetail psd WITH (NOLOCK) ON psd.ProductSettingID = ps.ProductSettingID
WHERE PSD.SportType = @SportType AND C.site in ('Heaven','Lucky88')

INSERT INTO #supers(custid)
SELECT custid
FROM  dbo.Dep_CustSuper with(nolock) 
WHERE custid NOT IN (SELECT custid FROM #Supers_Offered WITH (NOLOCK))
	AND site in ('Heaven','Lucky88')
	AND currency NOT IN (27) -- Currency H - it is just test currency, used once in a while 
	AND custid <= @max_custid

SET @super_cnt = (SELECT COUNT(*) FROM #supers WITH (NOLOCK))

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
	
	EXEC dbo.[Acc_Dep_DynamicCustSetting_09] @srecommend = @srecommend, @max_custid=@max_custid,@target = 'DBCUST'
		
	WAITFOR DELAY '00:00:00.280'			
END	

DROP TABLE #supers		
DROP TABLE #Supers_Offered
GO		

-- END STEP 3: Run this SP at DBCust -----
-------------------------------------------------