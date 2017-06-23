/*
	Created: 20170217@Helen
	Task: DCS Deposit for Fishing World - [Redmine:71568]
	Redmine: https://nexdev.net/issues/71568
*/ 
-- BEGIN STEP 1: Deploy this SP at DBCUST.CustDB, Run only in the FIRST running
------------------------------------------------------
ALTER PROCEDURE [dbo].[Acc_Dep_DynamicCustSetting_09]
 	 @srecommend INT
	, @currency int
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
	
	DECLARE @ProductProfileList VARCHAR(200) = '7,8'
	, @ProductID INT = 24 -- Fishing World
	-- For ProductStatus param
	, @IsProductStatus BIT = 1
	, @IsDisable BIT = 0
	, @IsHidden BIT = 0
	
	-- For PT param
	, @IsPTSetting BIT = 1
	, @SuperPT SMALLINT = 92
	-- For StakelevelGroup params
	--, @IsStakeLevel BIT = 1
	
	DECLARE @SportType SMALLINT = 219, @BetType SMALLINT = 1011,  @bitmapOrder INT 

	SET @bitmapOrder = (SELECT bitmapOrder FROM Dep_ProductStatusProfile WITH (NOLOCK) WHERE Sporttype = @SportType AND Bettype = @BetType)
	
	CREATE TABLE #tblCust (custid int,agentid int, roleid int) 

	INSERT INTO #tblCust			
	SELECT custid,recommend,roleid
	FROM custInfo WITH(NOLOCK)
	WHERE srecommend =@srecommend
		AND mrecommend NOT IN (SELECT custid FROM custinfo WITH(NOLOCK)
							   WHERE srecommend=@srecommend and username like '%Acc%' and roleid=3)
		AND custid <= @max_custid
							   
	SELECT @currency = (SELECT Currency FROM custInfo WITH (NOLOCK) WHERE custid = @srecommend)

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
	WHERE lds.CustID = @srecommend  AND ps.ProductID= @ProductID

	-- PT processing
	
	IF EXISTS (SELECT 1 FROM #ProductSettingDetail_tmp WHERE SettingType = 1) AND @IsPTSetting = 1
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
		FROM #tblCust ci
			CROSS JOIN #ProductSettingDetail_tmp psd 
		WHERE psd.SettingType = 1 
			AND ci.roleid IN (2,3,4)
			
		-- For Member
		IF EXISTS (SELECT 1 FROM #tblCust WHERE roleid = 1)
		BEGIN
			
			--Insert new PT Group
			INSERT INTO Dep_CustPTGroupSetting_Member (AgentID,SportType,BetType,IsLive,SuperPT,MasterPT,AgentPT)				
			SELECT ci.agentid,psd.SportType,psd.BetType,0,0,0,@SuperPT
			FROM #tblCust ci
					CROSS JOIN #ProductSettingDetail_tmp psd 
			WHERE psd.SettingType = 1 
				AND ci.roleid = 2					
			
			-- Insert New
			
			INSERT INTO Dep_CustSettingMode (CustID,IsGroupedPT)
			SELECT c.custid,1
			FROM #tblCust C
			WHERE C.roleid = 1 AND NOT EXISTS (SELECT 1 FROM Dep_CustSettingMode C1 (NOLOCK) WHERE c1.CustID = c.Custid)
			
		END
	END	

	-- Status Process
	IF EXISTS (SELECT 1 FROM #ProductSettingDetail_tmp WHERE SettingType = 4) AND @IsProductStatus = 1	
	BEGIN
	
		RAISERROR ('Status Processing', 0, 1) WITH NOWAIT
		-- Update if exists
		UPDATE T 
				SET bitmapIsDisabled = dbo.f_GenerateProductStatus (t.bitmapIsDisabled, @bitmapOrder,0)		
					, bitmapIsHidden = dbo.f_GenerateProductStatus(t.bitmapIsHidden , @bitmapOrder,0)
		FROM [dbo].[Dep_CustProductStatus] T (ROWLOCK)
			INNER JOIN #tblCust C ON C.custid = T.custid
		
		-- Insert new	
		INSERT INTO [dbo].[Dep_CustProductStatus](CustID,bitmapIsDisabled,bitmapIsHidden)
		SELECT	c.custid
				, dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, @bitmapOrder,0) AS bitmapIsDisabled
				, dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, @bitmapOrder,0)  AS bitmapIsHidden
		FROM #tblCust C
		WHERE NOT EXISTS (SELECT 1 FROM [dbo].[Dep_CustProductStatus] T (NOLOCK) WHERE t.custid = c.custid)
		
	END	

	DROP TABLE #ProductSettingDetail_tmp
	DROP TABLE #tblCust

END	

GO
-- END STEP 1: DEPLOY THIS SP @ DBCUST.CustDB -------

------------------------------------------------------	
-- BEGIN STEP 2: Run this SP at replicated DB: DB06, DBTP -----
--------------------------------------------------------------------------------------
DECLARE @ProductID INT = 24, @SportType INT = 219
CREATE TABLE #Supers_Offered (custid int)

INSERT INTO #Supers_Offered (custid)
SELECT lds.CustID
FROM Dep_LicenseeProductSetting lds WITH (NOLOCK)
	INNER JOIN Dep_CustSuper c WITH (NOLOCK) ON c.custid = lds.CustID 
	INNER JOIN Dep_ProductSetting ps WITH (NOLOCK) ON lds.ProductSettingID = PS.ProductSettingID AND ps.ProductID= @ProductID
	INNER JOIN Dep_ProductSettingDetail psd WITH (NOLOCK) ON psd.ProductSettingID = ps.ProductSettingID
WHERE PSD.SportType = @SportType AND C.site in ('Webet138')
 
CREATE TABLE #supers (custid int, currency int, isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT, @site varchar (50), @currency int 
SELECT  @max_custid= xxx ---input maxcustid

INSERT INTO #supers(custid,currency)
SELECT custid,currency
FROM  Dep_CustSuper with(nolock) 
WHERE custid NOT IN (SELECT custid FROM #Supers_Offered)
	AND site in ('Webet138')
	AND currency NOT IN (27,20) -- Currency H - it is just test currency, used once in a while 
	AND custid <= @max_custid


DECLARE @super_cnt INT, @index INT = 0

SET @super_cnt = (SELECT COUNT(*) FROM #supers )

DECLARE @msg nvarchar(200) = 'Currently at order %d, SuperID: %d.'

DECLARE @msg_total nvarchar(200) = 'Total of supers: %d.'

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
				
	WAITFOR DELAY '00:00:00.280'			
END	

DROP TABLE #supers		
GO		

-- END STEP 2: Run this SP at replicated DB: DB06, DBTP -----
-----------------------------------------------------------------------------------
-- BEGIN STEP 3: Run this SP at DBCust -----
-------------------------------------------------
DECLARE @ProductID INT = 24, @SportType INT = 219

CREATE TABLE #Supers_Offered (custid int)

INSERT INTO #Supers_Offered (custid)
SELECT lds.CustID
FROM Dep_LicenseeProductSetting lds WITH (NOLOCK)
	INNER JOIN Dep_CustSuper c WITH (NOLOCK) ON c.custid = lds.CustID 
	INNER JOIN Dep_ProductSetting ps WITH (NOLOCK) ON lds.ProductSettingID = PS.ProductSettingID AND ps.ProductID= @ProductID
	INNER JOIN Dep_ProductSettingDetail psd WITH (NOLOCK) ON psd.ProductSettingID = ps.ProductSettingID
WHERE PSD.SportType = @SportType AND C.site in ('Webet138')
 
CREATE TABLE #supers (custid int, currency int, isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT, @site varchar (50), @currency int 
SELECT  @max_custid= xxx ---input maxcustid

INSERT INTO #supers(custid,currency)
SELECT custid,currency
FROM  Dep_CustSuper with(nolock) 
WHERE custid NOT IN (SELECT custid FROM #Supers_Offered)
	AND site in ('Webet138')
	AND currency NOT IN (27,20) -- Currency H - it is just test currency, used once in a while 
	AND custid <= @max_custid


DECLARE @super_cnt INT, @index INT = 0

SET @super_cnt = (SELECT COUNT(*) FROM #supers )

DECLARE @msg nvarchar(200) = 'Currently at order %d, SuperID: %d.'

DECLARE @msg_total nvarchar(200) = 'Total of supers: %d.'

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
		
	WAITFOR DELAY '00:00:00.280'			
END	

DROP TABLE #supers		
GO		


-- END STEP 3: Run this SP at DBCust -----
-------------------------------------------------