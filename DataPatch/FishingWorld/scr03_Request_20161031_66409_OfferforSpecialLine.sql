DECLARE @ProductProfileList VARCHAR(200) = '7,8'
	, @ProductID INT = 24 -- Fishing World
	-- For ProductStatus param
	, @IsProductStatus BIT = 1
	, @IsDisable BIT = 0
	, @IsHidden BIT = 0
	
	-- For PT param
	, @IsPTSetting BIT = 1
	, @SuperPT SMALLINT = 93
	-- For StakelevelGroup params
	--, @IsStakeLevel BIT = 1
	, @srecommend int = 1015419
	, @currency int
	
	CREATE TABLE #tblCust (custid int,agentid int, roleid int) 

	INSERT INTO #tblCust			
	SELECT custid,recommend,roleid
	FROM custInfo WITH(NOLOCK)
	WHERE srecommend =@srecommend
		AND mrecommend NOT IN (SELECT custid FROM custinfo WITH(NOLOCK)
							   WHERE srecommend=@srecommend and username like '%Acc%' and roleid=3)
		--AND custid <= @max_custid
							   
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
		PRINT 'Status'
					
		-- Update if exists
		UPDATE T 
				SET bitmapIsDisabled = dbo.f_GenerateProductStatus (t.bitmapIsDisabled, 3,0)		
					, bitmapIsHidden = dbo.f_GenerateProductStatus(t.bitmapIsHidden , 3,0)
		FROM [dbo].[Dep_CustProductStatus] T (ROWLOCK)
			INNER JOIN #tblCust C ON C.custid = T.custid
		
		-- Insert new	
		INSERT INTO [dbo].[Dep_CustProductStatus](CustID,bitmapIsDisabled,bitmapIsHidden)
		SELECT	c.custid
				, dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, 3,0) AS bitmapIsDisabled
				, dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, 3,0)  AS bitmapIsHidden
		FROM #tblCust C
		WHERE NOT EXISTS (SELECT 1 FROM [dbo].[Dep_CustProductStatus] T (NOLOCK) WHERE t.custid = c.custid)
		
	END	

drop table #tblCust
drop table #ProductSettingDetail_tmp

-