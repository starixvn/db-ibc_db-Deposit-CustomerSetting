DECLARE @srecommend INT = 8067174
	, @ProductProfileList VARCHAR(200) = '1,2,3'
	, @ProductID INT = 22 -- VB
	-- For ProductStatus param
	, @IsProductStatus BIT = 1
	, @IsDisable BIT = 0
	, @IsHidden BIT = 0
	
	-- For PT param
	, @IsPTSetting BIT = 1
	, @SuperPT SMALLINT = 93
	
	-- For StakelevelGroup params
	, @IsStakeLevelGroup BIT = 1
	, @StakeLevelList_sma VARCHAR(500) = '1'
	, @StakeLevelList_player VARCHAR(200) = '1'
	, @currency INT = 20
		
CREATE TABLE #tblCust (custid int,agentid int, roleid int) 

INSERT INTO #tblCust			
SELECT custid,recommend,roleid
FROM custInfo WITH(NOLOCK)
WHERE srecommend =@srecommend
	AND mrecommend NOT IN (SELECT custid FROM custinfo WITH(NOLOCK)
						   WHERE srecommend=@srecommend and username like '%Acc%' and roleid=3)

SELECT * FROM #tblCust						   

SELECT @currency = (SELECT Currency FROM custInfo WITH (NOLOCK) WHERE custid = @srecommend)

-- Licensee profile list
IF NOT EXISTS (SELECT 1 
			   FROM Dep_LicenseeProductSetting lps WITH (NOLOCK)
					INNER JOIN Dep_ProductSetting ps WITH (NOLOCK) ON lps.ProductSettingID = ps.ProductSettingID
			   WHERE CustID = @srecommend AND ps.ProductID= @ProductID)
BEGIN
	INSERT INTO Dep_LicenseeProductSetting (CustID,ProductSettingID)
	SELECT @srecommend, t.Data
	FROM dbo.Split(@ProductProfileList,',') t
END	

SELECT ps.SettingType,psd.SportType,psd.BetType
INTO #ProductSettingDetail_tmp
FROM Dep_LicenseeProductSetting lds WITH (NOLOCK)
	INNER JOIN Dep_ProductSetting ps WITH (NOLOCK) ON lds.ProductSettingID = PS.ProductSettingID
	INNER JOIN Dep_ProductSettingDetail psd WITH (NOLOCK) ON psd.ProductSettingID = ps.ProductSettingID
WHERE lds.CustID =@srecommend AND ps.ProductID= @ProductID

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
		,CASE WHEN ci.roleid IN (1,2,4) THEN @SuperPT ELSE 0 END AS AgentPT
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
	SELECT DISTINCT psd.SportType,psd.Bettype, psd.SettingType,@IsDisable AS IsDisabled,@IsHidden AS IsHidden,pbs.bitmapOrder 
	INTO #SportBettypeFilter4
	FROM #ProductSettingDetail_tmp psd WITH(NOLOCK)  
		INNER JOIN ProductStatusProfile pbs WITH (NOLOCK) ON pbs.[SportType] = psd.[SportType] AND pbs.[BetType] = psd.[BetType]
	WHERE psd.SettingType = 4
	
	--select * from #SportBettypeFilter4
	
	IF EXISTS(SELECT TOP 1 1 FROM #SportBettypeFilter4)
	BEGIN
						
		DECLARE @xmlStrDisabled XML
		DECLARE @xmlStrHidden XML
	
		SET @xmlStrDisabled = (
				SELECT (
						SELECT ft.bitmapOrder	AS '@b'
							, ft.IsDisabled	AS '@s'
						FROM #SportBettypeFilter4 ft 	
						FOR XML PATH('r')
							, TYPE
						)
				FOR XML PATH('root')
					, TYPE
				)
			
		SET @xmlStrHidden = (
				SELECT (
						SELECT ft.bitmapOrder	AS '@b'
							, ft.IsHidden	AS '@s'
						FROM #SportBettypeFilter4 ft 	
						FOR XML PATH('r')
							, TYPE
						)
				FOR XML PATH('root')
					, TYPE
				)
				
		
		INSERT INTO [dbo].[Dep_CustProductStatus]([CustID],bitmapIsDisabled,bitmapIsHidden)
		SELECT	c.custid
				, (select bitmap from dbo.f_GenerateProductStatus_multiple (0, CONVERT(VARCHAR(MAX),@xmlStrDisabled)))	
				, (select bitmap from dbo.f_GenerateProductStatus_multiple (0, CONVERT(VARCHAR(MAX),@xmlStrHidden)))
		FROM #tblCust C
		
	END	
END	

-- StakeLevelGroup
IF EXISTS (SELECT 1 FROM #ProductSettingDetail_tmp WHERE SettingType = 8) AND @IsStakeLevelGroup = 1
BEGIN
	PRINT 'StakeLevelGroup'
	
	-- Insert NEW for level 1
	
	INSERT INTO Dep_CustStakeLevel_Agent (CustID,SportType,BetType,StakeLevelList)
	SELECT C.custid,T.SportType,T.BetType,StakeLevelListID
	FROM #tblCust C
		CROSS JOIN (SELECT T.SportType,t.BetType AS Bettype, STUFF(T1.StakeLevelList,1,1,'') AS StakeLevelListID
					FROM #ProductSettingDetail_tmp T
					CROSS APPLY ( SELECT ',' + CONVERT(VARCHAR(20),sl.StakeLevelID)
									FROM GameGroup G (NOLOCK) 
										INNER JOIN Dep_StakeLevel SL (NOLOCK) ON SL.GameGroupID = G.GameGroupID AND sl.ExchangeID = @currency
								WHERE T.SportType = G.RefSportType AND g.GroupName = 'Level 1' AND SL.GameTypeID = T.BetType
								FOR XML PATH('')
								) AS T1 (StakeLevelList)
					WHERE SettingType = 8 ) AS T
	WHERE C.roleid IN (2,3,4)				
	
	
	INSERT INTO Dep_CustStakeLevel_member (CustID,SportType,BetType,StakeLevelList)
	SELECT C.custid,T.SportType,T.BetType,StakeLevelListID
	FROM #tblCust C
		CROSS JOIN (SELECT T.SportType,t.BetType AS Bettype, STUFF(T1.StakeLevelList,1,1,'') AS StakeLevelListID
					FROM #ProductSettingDetail_tmp T
					CROSS APPLY ( SELECT ',' + CONVERT(VARCHAR(20),sl.StakeLevelID)
									FROM GameGroup G (NOLOCK) 
										INNER JOIN Dep_StakeLevel SL (NOLOCK) ON SL.GameGroupID = G.GameGroupID AND sl.ExchangeID = @currency
								WHERE T.SportType = G.RefSportType AND g.GroupName = 'Level 1' AND SL.GameTypeID = T.BetType
								FOR XML PATH ('')
								) AS T1 (StakeLevelList)
					WHERE SettingType = 8 ) AS T
	WHERE C.roleid = 1				
	
END

DROP TABLE #ProductSettingDetail_tmp
DROP TABLE #SportBettypeFilter4
DROP TABLE #tblCust


