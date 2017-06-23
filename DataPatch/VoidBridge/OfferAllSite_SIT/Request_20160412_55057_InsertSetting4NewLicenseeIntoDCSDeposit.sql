/*
	Created: 20160405@Helen
	Task: insert the Setting of Voidbridge of new licensees into the DCS database.
	Redmine: https://redmine.nexcel.vn/issues/71312
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
	
		OR dbo.f_CheckRepTable('GameGroup') = 0
		OR dbo.f_CheckRepTable('Dep_StakeLevel') = 0
		OR dbo.f_CheckRepTable('Dep_CustStakeLevel_Agent') = 0 
		OR dbo.f_CheckRepTable('Dep_CustStakeLevel_Member') = 0 
			
	   )
		RETURN
	
	DECLARE @ProductProfileList VARCHAR(200) = '1,2,3'
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
	
	CREATE TABLE #tblCust (custid int,agentid int, roleid int) 

	INSERT INTO #tblCust			
	SELECT custid,recommend,roleid
	FROM custInfo WITH(NOLOCK)
	WHERE srecommend =@srecommend
		AND mrecommend NOT IN (SELECT custid FROM custinfo WITH(NOLOCK)
							   WHERE srecommend=@srecommend and username like '%Acc%' and roleid=3)
		AND custid <= @max_custid
							   
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
				SET bitmapIsDisabled = dbo.f_GenerateProductStatus (t.bitmapIsDisabled, 1,0)		
					, bitmapIsHidden = dbo.f_GenerateProductStatus(t.bitmapIsHidden , 1,0)
		FROM [dbo].[Dep_CustProductStatus] T (ROWLOCK)
			INNER JOIN #tblCust C ON C.custid = T.custid
		
		-- Insert new	
		INSERT INTO [dbo].[Dep_CustProductStatus](CustID,bitmapIsDisabled,bitmapIsHidden)
		SELECT	c.custid
				, dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, 1,0) AS bitmapIsDisabled
				, dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, 1,0)  AS bitmapIsHidden
		FROM #tblCust C
		WHERE NOT EXISTS (SELECT 1 FROM [dbo].[Dep_CustProductStatus] T (NOLOCK) WHERE t.custid = c.custid)
		
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
										WHERE T.SportType = G.RefSportType AND SL.GameTypeID = T.BetType AND g.IsDeposit = 1 AND g.GroupName = 'Level 1'
										FOR XML PATH('')
										) AS T1 (StakeLevelList)
						WHERE T.SettingType = 8 ) AS T
		WHERE C.roleid= 4
		
		INSERT INTO Dep_CustStakeLevel_Agent (CustID,SportType,BetType,StakeLevelList)
		SELECT C.custid,T.SportType,T.BetType, T.StakeLevelList
		FROM #tblCust C
			CROSS JOIN (SELECT csla.SportType,csla.BetType,csla.StakeLevelList
						 FROM dbo.Dep_CustStakeLevel_Agent AS csla WITH (NOLOCK) 
							INNER JOIN #ProductSettingDetail_tmp T ON csla.SportType = t.SportType AND T.BetType = CSLA.BetType AND T.SettingType = 8
						 WHERE CustID = @srecommend) AS T
		WHERE c.roleid IN (2,3)
		
		INSERT INTO Dep_CustStakeLevel_member (CustID,SportType,BetType,StakeLevelList)
		SELECT C.custid,csla.SportType,csla.BetType, L.list
		FROM #tblCust C
			INNER JOIN dbo.Dep_CustStakeLevel_Agent AS csla WITH (NOLOCK) ON C.agentid = csla.CustID
			INNER JOIN #ProductSettingDetail_tmp T ON csla.SportType = t.SportType AND T.BetType = CSLA.BetType AND T.SettingType = 8			 
			
			CROSS APPLY(SELECT TOP 1 ss.val list
						FROM 	dbo.strSplit(csla.StakeLevelList, ',') AS ss
							INNER JOIN Dep_StakeLevel sl WITH (NOLOCK) ON ss.val = sl.StakeLevelID  
						ORDER BY sl.MaxStake, sl.MinStake, SL.GameGroupID
						) AS L					
		WHERE C.roleid = 1				
		
	END

	DROP TABLE #ProductSettingDetail_tmp
	DROP TABLE #tblCust

END	

GO
-- END STEP 1: DEPLOY THIS SP @ DBCUST.CustDB -------

------------------------------------------------------	
-- BEGIN STEP 2: Run this SP at replicated DB -----
--------------------------------------------------------------------------------------
DECLARE @ProductID INT = 22, @SportType INT = 212

CREATE TABLE #Supers_Offered (custid int)
INSERT INTO #Supers_Offered (custid)
SELECT lds.CustID
FROM Dep_LicenseeProductSetting lds WITH (NOLOCK)
	INNER JOIN Customer c (nolock) on c.custid = lds.CustID and c.roleid = 4
	INNER JOIN Dep_ProductSetting ps WITH (NOLOCK) ON lds.ProductSettingID = PS.ProductSettingID AND ps.ProductID= @ProductID
	INNER JOIN Dep_ProductSettingDetail psd WITH (NOLOCK) ON psd.ProductSettingID = ps.ProductSettingID
WHERE PSD.SportType = @SportType
 
CREATE TABLE #supers (custid int, currency int, isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT, @site varchar (50), @currency int 
SELECT  @max_custid= xxx ---input maxcustid

INSERT INTO #supers(custid,currency)
SELECT custid,currency
FROM  Dep_CustSuper with(nolock) 
WHERE custid NOT IN (SELECT custid FROM #Supers_Offered)
	AND site in ('Spondemo','Athena000','ITCbet','Aoncash','Macaubet','9Bet','M8bola','Q8bola','BE7','GooBet','NBCbet','Unobet','BE7th','Bolanation','sbcbet','Allbetclub','Aragon88','indowin','May88')
	AND custid <= @max_custid
	AND currency NOT IN (27) -- Currency H - it is just test currency, used once in a while 

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #supers
	SET isfinished = 1
		,@srecommend = custid
		,@currency=currency			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_Dep_DynamicCustSetting_09] @srecommend = @srecommend, @currency=@currency, @max_custid=@max_custid,@target = 'REPLICATED' 	
				
	WAITFOR DELAY '00:00:00.280'			
END	
DROP TABLE #supers
DROP TABLE #Supers_Offered		
GO		

-- END STEP 2: Run this SP at replicated DB -----
-----------------------------------------------------------------------------------

---
-- BEGIN STEP 3: Run this SP at DBCust -----
-------------------------------------------------
DECLARE @ProductID INT = 22, @SportType INT = 212

CREATE TABLE #Supers_Offered (custid int)

INSERT INTO #Supers_Offered (custid)
SELECT lds.CustID
FROM Dep_LicenseeProductSetting lds WITH (NOLOCK)
	INNER JOIN Customer c (nolock) on c.custid = lds.CustID and c.roleid = 4
	INNER JOIN Dep_ProductSetting ps WITH (NOLOCK) ON lds.ProductSettingID = PS.ProductSettingID AND ps.ProductID= @ProductID
	INNER JOIN Dep_ProductSettingDetail psd WITH (NOLOCK) ON psd.ProductSettingID = ps.ProductSettingID
WHERE PSD.SportType = @SportType
 
CREATE TABLE #supers (custid int, currency int, isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT, @site varchar (50), @currency int 
SELECT  @max_custid= xxx ---input maxcustid

INSERT INTO #supers(custid,currency)
SELECT custid,currency
FROM  Dep_CustSuper with(nolock) 
WHERE custid NOT IN (SELECT custid FROM #Supers_Offered)
	AND site in ('Spondemo','Athena000','ITCbet','Aoncash','Macaubet','9Bet','M8bola','Q8bola','BE7','GooBet','NBCbet','Unobet','BE7th','Bolanation','sbcbet','Allbetclub','Aragon88','indowin','May88')
	AND custid <= @max_custid
	AND currency NOT IN (27) -- Currency H - it is just test currency, used once in a while 

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #supers
	SET isfinished = 1
		,@srecommend = custid
		,@currency=currency			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
	
	EXEC dbo.[Acc_Dep_DynamicCustSetting_09] @srecommend = @srecommend, @currency=@currency, @max_custid=@max_custid,@target = 'DBCUST'
		
	WAITFOR DELAY '00:00:00.280'			
END	

DROP TABLE #supers	
DROP TABLE #Supers_Offered	
GO		


-- END STEP 3: Run this SP at DBCust -----
-------------------------------------------------

