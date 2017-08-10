/*
	Created: 20170626@Helen
	Task: insert the Setting of VS of new licensees into the DCS database.
	Redmine: https://redmine.nexcel.vn/issues/77274
	DB: DBCUST/CUSTDB
*/ 

ALTER PROCEDURE [dbo].[Acc_DynamicCustSetting3rd_09]
AS
BEGIN
	SET NOCOUNT ON
	
	IF dbo.f_CheckRepTable('CustInfo') = 0 RETURN
	IF dbo.f_CheckRepTable('Dep_CustBetSetting_Agent') = 0 RETURN
	IF dbo.f_CheckRepTable('Dep_CustBetSetting_Member') = 0 RETURN
	
	DECLARE @msgDone NVARCHAR(200) = 'Done for sporttype %d, bettype %d.'

	CREATE TABLE #SportTypeCheck (SportType SMALLINT, BetType SMALLINT, MaxPerMatchName VARCHAR(200), PRIMARY KEY (SportType,Bettype) )	
	INSERT INTO #SportTypeCheck 
	VALUES
		(180,1201,'maxpermatch180'),
		(181,1231,'maxpermatch181'),
		(182,1231,'maxpermatch182'),
		(183,1231,'maxpermatch183'),
		(184,1231,'maxpermatch184'),
		(185,1231,'maxpermatch185'),
		(186,1220,'maxpermatch186')

	CREATE TABLE #SportTypeList (SportType SMALLINT, Bettype SMALLINT, IsFinished BIT)	
	INSERT INTO #SportTypeList 
	VALUES (180, 1201, 0), (181, 1231, 0), (182, 1231, 0), (183, 1231, 0), (184, 1231, 0), (185, 1231, 0), (186, 1220, 0)

	CREATE TABLE #tblCust_SMA (custid INT,SportType SMALLINT, Bettype SMALLINT,  minbet MONEY, maxbet MONEY, maxpermatch MONEY)				
	CREATE TABLE #tblCust_member (custid INT,SportType SMALLINT, Bettype SMALLINT,  minbet MONEY, maxbet MONEY, maxpermatch MONEY)
	CREATE TABLE #tblCustNew (custid INT PRIMARY KEY,SportType SMALLINT, Bettype SMALLINT,  minbet MONEY, maxbet MONEY, maxpermatch MONEY)	
	CREATE TABLE #tblCustOld (custid INT PRIMARY KEY,SportType SMALLINT, Bettype SMALLINT,  minbet MONEY, maxbet MONEY, maxpermatch MONEY)
	
	CREATE TABLE #Super_adjust (custid INT PRIMARY KEY)
	
	INSERT INTO #Super_adjust (custid)
	SELECT CS.custid
	FROM dbo.Dep_CustSuper CS WITH (NOLOCK)
	WHERE CS.site IN ('368Cash','OPEBET','Leon','12Bet', 'asiabet88', 'mansion88', 'alog','TLC', 'SunGame', 'MayFair', 'Zzun88', 'HAIFA', 'Bodog', 'Vwin', 'Macaubet', 'VCasia', 'Aoncash', 'Bwinning', 'ITCBet', 'yq355', 'i668bet', 'Avia', 'W88', '9bet', '67BET', '3star88', 'SLC88', 'Bet2day', 'OLE777', 'Winner99', 'XTD1', 'XTD2', '88Macao', 'Boma365', 'Hbobet', 'Wawabet', 'Mgm88', 'Saloncs', 'Salon365', 'Ae88', 'Hengcai88', 'Senibet', 'Allbetclub', 'BlueOcean', 'Happy1668', 'AG', 'M8bola', 'THBET', 'Lambo777', '9Club', 'XTD3', '28BET', 'HONBET', 'Q8bola', 'BE7', 'iBET', 'MarvelDH', 'DAYWIN', 'GooBet', 'ISC888', 'KaiHao', 'Liga', 'RYB95', 'SHABAING', 'Deebet', 'NBCbet', '666VIP', 'Inbet', 'HonorW', 'DEWA', 'IBO', 'YHY1980', 'Empire555', 'Unobet', 'GamingSoft', 'Citibet', 'Newhonbet', '21Cash', 'DUOLE', 'Hecbet', 'DBP', 'Asianbet', 'Baobet', 'HL8', 'Abcasino', 'TGO', 'BE7TH', 'Lexibet', 'King10', 'Starnet', '365online', 'CQ11', 'Uwin18', '12betco', 'Bolanation', 'sbcbet', 'KhmerG', 'Gampag', 'IONclub', 'Sun988', 'Mayayule', 'HuangMa', 'Webet138', 'webet88', 'Emmyo', 'BigGaming', 'Boying', 'GDC', 'Brown888', 'MrCat', 'TCL', 'Aragon88', 'CGame', 'PKbet', 'VCBA', 'Taipanbet', 'Leon', 'Indowin', 'FLC', 'IGPTech', 'BetStar', 'TGame', 'Dawoo', 'Ty777', 'Kasking88', 'LZYQ', 'ABB688', 'May88', 'Star99', 'BuyWin', 'Uwoniwin', 'Sunrise', 'Swin', 'LongBao', 'UN168', 'PanguGame', 'K8VN', 'ECLBET', 'Lucky88', 'GPIGAME', '818Bet', 'SSSSEA', 'Heaven', 'GOAB88', 'Bobo88')
			
	--SMA Level
	-------------------------------------DATA PREPARATION --------------------------------------------	
	INSERT INTO #tblCust_SMA (custid,SportType,Bettype, minbet, maxbet, maxpermatch)			
	SELECT CBS.CustID,CBS.SportType,CBS.BetType, CS.minbet, CS.maxbet, A.maxpermatch
	FROM Dep_CustBetSetting_Agent CBS WITH (NOLOCK) 
		INNER JOIN custInfo C WITH (NOLOCK) ON C.custid = CBS.CustID
		INNER JOIN Dep_CustSetting3rd CS WITH(NOLOCK) ON CBS.CustID = CS.custid AND CBS.SportType = CS.sporttype AND CBS.BetType = CS.bettype
		CROSS APPLY( VALUES
				('maxpermatch180',C.maxpermatch180),
				('maxpermatch181',C.maxpermatch181),
				('maxpermatch182',C.maxpermatch182),
				('maxpermatch183',C.maxpermatch183),
				('maxpermatch184',C.maxpermatch184),
				('maxpermatch185',C.maxpermatch185),
				('maxpermatch186',C.maxpermatch186)
		 ) AS A(columnname, maxpermatch)
	   INNER JOIN #SportTypeCheck S ON S.MaxPerMatchName = A.columnname AND CS.SportType = S.SportType AND CS.BetType = S.BetType
	WHERE (cbs.MinBet <> cs.minbet OR cbs.MaxBet <> cs.maxbet OR cbs.MaxPerMatch <> a.maxpermatch)
		AND CBS.SportType IN (180,181,182,183,184,185,186)
		AND EXISTS (SELECT 1 FROM #Super_adjust WITH (NOLOCK) WHERE CustID = C.srecommend)

	--Adjust for SMA Level
	UPDATE cbs
	SET minbet = CI.minbet
		, maxbet = CI.maxbet
		, maxpermatch = CI.maxpermatch
	FROM Dep_CustBetSetting_Agent CBS WITH (ROWLOCK,UPDLOCK) 
		INNER JOIN #tblCust_SMA CI WITH (NOLOCK) ON CI.custid = CBS.CustID AND CBS.SportType = CI.SportType AND CBS.BetType = CI.Bettype

	--Member Level
	WHILE (1 = 1 )
	BEGIN	
		DECLARE @SportType SMALLINT, @Bettype SMALLINT, @Threshold INT = 1000000
		DECLARE @MaxCustID INT = 0, @MinCustID INT = 0		

		UPDATE TOP (1) #SportTypeList
		SET IsFinished = 1
			,@SportType = SportType	
			,@Bettype = Bettype
		WHERE IsFinished = 0

		IF @@ROWCOUNT = 0 BREAK

		WHILE (1 = 1 )
		BEGIN
			INSERT INTO #tblCustNew (custid,SportType,Bettype, minbet, maxbet, maxpermatch)			
			SELECT DISTINCT TOP (@Threshold) cs.CustID,cs.SportType,cs.BetType, CS.minbet, CS.maxbet, cs.maxpermatch
			FROM dbo.Dep_CustBetSetting_Member cs WITH (NOLOCK)
				INNER JOIN dbo.custInfo C WITH (NOLOCK) ON cs.CustID = C.custid			 			
			WHERE cs.SportType = @SportType AND cs.BetType = @Bettype
				AND EXISTS (SELECT 1 FROM #Super_adjust WITH (NOLOCK) WHERE CustID = C.srecommend)
				AND cs.CustID > @MinCustID
			ORDER BY cs.custid

			IF @@ROWCOUNT = 0 
				BREAK

			SELECT @MaxCustID = MAX(CustID) FROM #tblCustNew

			INSERT INTO #tblCustOld (custid,SportType,Bettype, minbet, maxbet, maxpermatch)			
			SELECT DISTINCT cs.CustID,cs.SportType,cs.BetType, CS.minbet, CS.maxbet, a.maxpermatch
			FROM Dep_CustSetting3rd cs WITH (NOLOCK) 
				INNER JOIN custInfo c WITH (NOLOCK) ON c.custid = cs.CustID 
				CROSS APPLY( VALUES
						('maxpermatch180',C.maxpermatch180),
						('maxpermatch181',C.maxpermatch181),
						('maxpermatch182',C.maxpermatch182),
						('maxpermatch183',C.maxpermatch183),
						('maxpermatch184',C.maxpermatch184),
						('maxpermatch185',C.maxpermatch185),
						('maxpermatch186',C.maxpermatch186)
				 ) AS A(columnname, maxpermatch)
			   INNER JOIN #SportTypeCheck S ON S.MaxPerMatchName = A.columnname AND CS.SportType = S.SportType AND CS.BetType = S.BetType
			WHERE cs.SportType = @SportType AND cs.BetType = @Bettype
				AND EXISTS (SELECT 1 FROM #Super_adjust WITH (NOLOCK) WHERE CustID = C.srecommend)
				AND cs.CustID > @MinCustID AND cs.custid <= @MaxCustID
			ORDER BY cs.custid

			INSERT INTO #tblCust_member (custid,SportType,Bettype, minbet, maxbet, maxpermatch )			
			SELECT co.CustID,co.SportType,co.BetType, co.minbet, co.maxbet, co.maxpermatch
			FROM #tblCustNew cn
				INNER JOIN #tblCustOld co ON co.custid = cn.custid AND co.SportType = cn.SportType AND cn.Bettype = co.Bettype
			WHERE (cn.MinBet <> co.minbet OR cn.MaxBet <> co.maxbet OR cn.MaxPerMatch <> co.maxpermatch)
		
			--Adjust for member Level
			UPDATE cs
			SET minbet = CI.minbet
				, maxbet = CI.maxbet
				, maxpermatch = CI.maxpermatch
			FROM Dep_CustBetSetting_Member cs WITH (ROWLOCK,UPDLOCK) 
				INNER JOIN #tblCust_member ci WITH (NOLOCK) ON ci.custid = cs.CustID AND cs.SportType = ci.SportType AND cs.BetType = ci.Bettype

			SELECT @MinCustID = @MaxCustID			

			

			RAISERROR(@msgDone, 0, 1, @SportType, @BetType)  WITH NOWAIT

			TRUNCATE TABLE #tblCust_member
			TRUNCATE TABLE #tblCustNew
			TRUNCATE TABLE #tblCustOld
		END

	END

	DROP TABLE #tblCust_SMA
	DROP TABLE #SportTypeCheck
END
GO






