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
	
	CREATE TABLE #tblCust (custid INT,roleID INT)

	INSERT INTO #tblCust (custid,roleID)			
	SELECT custid,roleID
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
			SELECT ci.custid,psd.SportType,psd.BetType,0,0,0,@SuperPT
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
				SET bitmapIsDisabled = CASE 
											WHEN CI.DisableVirtualSports = 0 THEN (SELECT * FROM f_CustSetting_GenerateProductStatus (t.bitmapIsDisabled, @bitmapOrder,0)) 
											ELSE (SELECT * FROM f_CustSetting_GenerateProductStatus (t.bitmapIsDisabled, @bitmapOrder,1)) 
										END --dbo.f_GenerateProductStatus (t.bitmapIsDisabled, 1,0)		
				, bitmapIsHidden = (SELECT * FROM f_CustSetting_GenerateProductStatus (t.bitmapIsHidden, @bitmapOrder,0))--dbo.f_GenerateProductStatus(t.bitmapIsHidden , 1,0)
			
		FROM [dbo].[Dep_CustProductStatus] T (ROWLOCK)
			INNER JOIN #tblCust C ON C.custid = T.custid
			INNER JOIN custInfo CI WITH (NOLOCK) ON C.custid = CI.custid
			
		 	
		
		-- Insert new	
		INSERT INTO [dbo].[Dep_CustProductStatus](CustID,bitmapIsDisabled,bitmapIsHidden)
		SELECT	c.custid
				
				, CASE 
						WHEN CI.DisableVirtualSports = 0 THEN dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, @bitmapOrder,0)
						ELSE dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, @bitmapOrder,1) 
				 END AS bitmapIsDisabled
				
				, dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, @bitmapOrder,0)  AS bitmapIsHidden
		FROM #tblCust C
			INNER JOIN custInfo CI WITH (NOLOCK) ON C.custid = CI.custid
		WHERE NOT EXISTS (SELECT 1 FROM [dbo].[Dep_CustProductStatus] T (NOLOCK) WHERE t.custid = c.custid)
		
	END	

	-- Betting Limit
	CREATE TABLE  #CustSetting3rd (custID INT, SportType SMALLINT, BetType SMALLINT, minbet MONEY, maxbet MONEY, PRIMARY KEY (CustID,sporttype))
	
	IF EXISTS (SELECT 1 FROM #ProductSettingDetail_tmp WHERE SettingType = 2) AND @IsBetLimit = 1
	BEGIN
		
		INSERT INTO #CustSetting3rd (custID,SportType,BetType,minbet,maxbet)
		SELECT ci.custid, cs.sporttype,cs.BetType,  cs.minbet, cs.maxbet
		FROM dbo.Dep_CustSetting3rd cs WITH(NOLOCK)
			INNER JOIN #tblCust ci WITH(NOLOCK) ON cs.CustID = ci.custid 
		WHERE cs.bettype IN (1201,1220,1231)	
		
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
			
			
		INSERT INTO dbo.Dep_CustBetSetting_Agent(CustID, SportType, BetType, MinBet, MaxBet, MaxPerMatch)
		SELECT CS.custid, dest.sporttype, dest.bettype, cs.minbet, cs.maxbet, A.maxpermatch
		FROM #CustSetting3rd cs 
			INNER JOIN #tblCust tbc WITH(NOLOCK) ON cs.CustID = tbc.custid
			INNER JOIN #ProductSettingDetail_tmp dest WITH(NOLOCK) ON dest.SettingType = 2 AND cs.sporttype = dest.SportType
			INNER JOIN custInfo CI WITH (NOLOCK) ON cs.custID = CI.custid
			CROSS APPLY( VALUES
					('maxpermatch180',CI.maxpermatch180),
					('maxpermatch181',CI.maxpermatch181),
					('maxpermatch182',CI.maxpermatch182),
					('maxpermatch183',CI.maxpermatch183),
					('maxpermatch184',CI.maxpermatch184),
					('maxpermatch185',CI.maxpermatch185),
					('maxpermatch186',CI.maxpermatch186)
             ) AS A(columnname, maxpermatch)
            INNER JOIN #SportTypeCheck S ON S.MaxPerMatchName = A.columnname AND dest.SportType = S.SportType 
		WHERE tbc.roleid IN (2,3,4)
		
		--Member Level
		INSERT INTO dbo.Dep_CustBetSetting_Member(CustID, SportType, BetType, MinBet, MaxBet, MaxPerMatch)
		SELECT CS.custid, cs.sporttype, cs.bettype, cs.minbet, cs.maxbet, maxpermatch180
		FROM #CustSetting3rd cs 
			INNER JOIN #tblCust tbc WITH(NOLOCK) ON cs.CustID = tbc.custid
			INNER JOIN custInfo CI WITH (NOLOCK) ON cs.custID = CI.custid
		WHERE tbc.roleID = 1 AND cs.SportType = 180
		
		INSERT INTO dbo.Dep_CustBetSetting_Member(CustID, SportType, BetType, MinBet, MaxBet, MaxPerMatch)
		SELECT CS.custid, cs.sporttype, cs.bettype, cs.minbet, cs.maxbet, maxpermatch181
		FROM #CustSetting3rd cs 
			INNER JOIN #tblCust tbc WITH(NOLOCK) ON cs.CustID = tbc.custid
			INNER JOIN custInfo CI WITH (NOLOCK) ON cs.custID = CI.custid
		WHERE tbc.roleID = 1 AND cs.SportType = 181
		
		INSERT INTO dbo.Dep_CustBetSetting_Member(CustID, SportType, BetType, MinBet, MaxBet, MaxPerMatch)
		SELECT CS.custid, cs.sporttype, cs.bettype, cs.minbet, cs.maxbet, maxpermatch182
		FROM #CustSetting3rd cs 
			INNER JOIN #tblCust tbc WITH(NOLOCK) ON cs.CustID = tbc.custid
			INNER JOIN custInfo CI WITH (NOLOCK) ON cs.custID = CI.custid
		WHERE tbc.roleID = 1 AND cs.SportType = 182
		
		INSERT INTO dbo.Dep_CustBetSetting_Member(CustID, SportType, BetType, MinBet, MaxBet, MaxPerMatch)
		SELECT CS.custid, cs.sporttype, cs.bettype, cs.minbet, cs.maxbet, maxpermatch183
		FROM #CustSetting3rd cs 
			INNER JOIN #tblCust tbc WITH(NOLOCK) ON cs.CustID = tbc.custid
			INNER JOIN custInfo CI WITH (NOLOCK) ON cs.custID = CI.custid
		WHERE tbc.roleID = 1 AND cs.SportType = 183
		
		INSERT INTO dbo.Dep_CustBetSetting_Member(CustID, SportType, BetType, MinBet, MaxBet, MaxPerMatch)
		SELECT CS.custid, cs.sporttype, cs.bettype, cs.minbet, cs.maxbet, maxpermatch184
		FROM #CustSetting3rd cs 
			INNER JOIN #tblCust tbc WITH(NOLOCK) ON cs.CustID = tbc.custid
			INNER JOIN custInfo CI WITH (NOLOCK) ON cs.custID = CI.custid
		WHERE tbc.roleID = 1 AND cs.SportType = 184
		
		INSERT INTO dbo.Dep_CustBetSetting_Member(CustID, SportType, BetType, MinBet, MaxBet, MaxPerMatch)
		SELECT CS.custid, cs.sporttype, cs.bettype, cs.minbet, cs.maxbet, maxpermatch185
		FROM #CustSetting3rd cs 
			INNER JOIN #tblCust tbc WITH(NOLOCK) ON cs.CustID = tbc.custid
			INNER JOIN custInfo CI WITH (NOLOCK) ON cs.custID = CI.custid
		WHERE tbc.roleID = 1 AND cs.SportType = 185
		
		INSERT INTO dbo.Dep_CustBetSetting_Member(CustID, SportType, BetType, MinBet, MaxBet, MaxPerMatch)
		SELECT CS.custid, cs.sporttype, cs.bettype, cs.minbet, cs.maxbet, maxpermatch186
		FROM #CustSetting3rd cs 
			INNER JOIN #tblCust tbc WITH(NOLOCK) ON cs.CustID = tbc.custid
			INNER JOIN custInfo CI WITH (NOLOCK) ON cs.custID = CI.custid
		WHERE tbc.roleID = 1 AND cs.SportType = 186
					
	END

	DROP TABLE #ProductSettingDetail_tmp
	DROP TABLE #tblCust
	DROP TABLE #SportTypeCheck
	DROP TABLE #CustSetting3rd

END	

GO
-- END STEP 1: DEPLOY THIS SP @ DBCUST.CustDB -------

------------------------------------------------------	
-- BEGIN STEP 2: Run this SP at replicated DB -----
--------------------------------------------------------------------------------------
DECLARE @ProductID INT = 5

CREATE TABLE #Supers_Offered (custid INT)
INSERT INTO #Supers_Offered (custid)
SELECT lds.CustID
FROM Dep_LicenseeProductSetting lds WITH (NOLOCK)
	INNER JOIN Dep_CustSuper c WITH (NOLOCK) on c.custid = lds.CustID 
	INNER JOIN Dep_ProductSetting ps WITH (NOLOCK) ON lds.ProductSettingID = PS.ProductSettingID AND ps.ProductID= @ProductID
	INNER JOIN Dep_ProductSettingDetail psd WITH (NOLOCK) ON psd.ProductSettingID = ps.ProductSettingID
WHERE PSD.SportType IN (180,181,182,183,184,185,186)
 
CREATE TABLE #supers (custid INT, currency INT, isfinished BIT DEFAULT(0), IsOfferedDCS BIT DEFAULT (1))

DECLARE @max_custid INT, @srecommend INT, @site varchar (50), @currency INT 
SELECT  @max_custid= xxx ---input maxcustid

INSERT INTO #supers(custid,currency)
SELECT custid,currency
FROM  Dep_CustSuper with(nolock) 
WHERE custid NOT IN (SELECT custid FROM #Supers_Offered)
	AND site in ('12Bet','asiabet88','mansion88','alog','spondemo','TLC','SunGame','MayFair','Zzun88','Bodog','Vwin','Macaubet','VCasia','Aoncash','Bwinning','ITCBet','i668bet','Avia','W88','9bet','67BET','3star88','SLC88','Bet2day','OLE777','Winner99','88Macao','Boma365','Hbobet','Mgm88','Saloncs','Salon365','Ae88','Hengcai88','Senibet','Allbetclub','Happy1668','AG','M8bola','THBET','9Club','XTD3','28BET','HONBET','Q8bola','BE7','iBET','MarvelDH','DAYWIN','GooBet','ISC888','KaiHao','Liga','RYB95','SHABAING','NBCbet','666VIP','Inbet','HonorW','DEWA','IBO','YHY1980','Empire555','Unobet','GamingSoft','Newhonbet','21Cash','DUOLE','Hecbet','DBP','Asianbet','Baobet','HL8','Abcasino','TGO','Lexibet','King10','365online','CQ11','Uwin18','Bolanation','KhmerG','Gampag','IONclub','Sun988','Mayayule','HuangMa','Webet138','webet88','Emmyo','BigGaming','Boying','GDC','MrCat','TCL','Aragon88','PKbet','VCBA','Taipanbet','Indowin','FLC','BetStar','Dawoo','Ty777','Kasking88','ABB688','Star99','BuyWin','Uwoniwin','Sunrise','Citibet','BE7TH','Starnet','12betco','sbcbet','Brown888','CGame','IGPTech','TGame','LZYQ','May88','Swin','LongBao','UN168','PanguGame','K8VN','ECLBET','Lucky88','GPIGAME','818Bet','SSSSEA')
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
DECLARE @ProductID INT = 5

CREATE TABLE #Supers_Offered (custid INT)

INSERT INTO #Supers_Offered (custid)
SELECT lds.CustID
FROM Dep_LicenseeProductSetting lds WITH (NOLOCK)
	INNER JOIN Dep_CustSuper c WITH (NOLOCK) on c.custid = lds.CustID 
	INNER JOIN Dep_ProductSetting ps WITH (NOLOCK) ON lds.ProductSettingID = PS.ProductSettingID AND ps.ProductID= @ProductID
	INNER JOIN Dep_ProductSettingDetail psd WITH (NOLOCK) ON psd.ProductSettingID = ps.ProductSettingID
WHERE PSD.SportType IN (180,181,182,183,184,185,186)
 
CREATE TABLE #supers (custid INT, currency INT, isfinished BIT DEFAULT(0))

DECLARE @max_custid INT, @srecommend INT, @site varchar (50), @currency INT 
SELECT  @max_custid= xxx ---input maxcustid

INSERT INTO #supers(custid,currency)
SELECT custid,currency
FROM  Dep_CustSuper WITH (NOLOCK) 
WHERE custid NOT IN (SELECT custid FROM #Supers_Offered)
	AND site in ('12Bet','asiabet88','mansion88','alog','spondemo','TLC','SunGame','MayFair','Zzun88','Bodog','Vwin','Macaubet','VCasia','Aoncash','Bwinning','ITCBet','i668bet','Avia','W88','9bet','67BET','3star88','SLC88','Bet2day','OLE777','Winner99','88Macao','Boma365','Hbobet','Mgm88','Saloncs','Salon365','Ae88','Hengcai88','Senibet','Allbetclub','Happy1668','AG','M8bola','THBET','9Club','XTD3','28BET','HONBET','Q8bola','BE7','iBET','MarvelDH','DAYWIN','GooBet','ISC888','KaiHao','Liga','RYB95','SHABAING','NBCbet','666VIP','Inbet','HonorW','DEWA','IBO','YHY1980','Empire555','Unobet','GamingSoft','Newhonbet','21Cash','DUOLE','Hecbet','DBP','Asianbet','Baobet','HL8','Abcasino','TGO','Lexibet','King10','365online','CQ11','Uwin18','Bolanation','KhmerG','Gampag','IONclub','Sun988','Mayayule','HuangMa','Webet138','webet88','Emmyo','BigGaming','Boying','GDC','MrCat','TCL','Aragon88','PKbet','VCBA','Taipanbet','Indowin','FLC','BetStar','Dawoo','Ty777','Kasking88','ABB688','Star99','BuyWin','Uwoniwin','Sunrise','Citibet','BE7TH','Starnet','12betco','sbcbet','Brown888','CGame','IGPTech','TGame','LZYQ','May88','Swin','LongBao','UN168','PanguGame','K8VN','ECLBET','Lucky88','GPIGAME','818Bet','SSSSEA')
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
		
	WAITFOR DELAY '00:00:00.280'			
END	

DROP TABLE #supers	
DROP TABLE #Supers_Offered	
GO		


-- END STEP 3: Run this SP at DBCust -----
-------------------------------------------------

