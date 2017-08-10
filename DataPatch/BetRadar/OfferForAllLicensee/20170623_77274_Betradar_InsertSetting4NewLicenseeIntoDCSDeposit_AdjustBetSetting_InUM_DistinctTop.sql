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
	
	DECLARE @SportType_VirtualSoccer INT = 180, @Bettype_Soccer INT = 1201

	CREATE TABLE #tblCust_SMA (custid INT,SportType SMALLINT, Bettype SMALLINT,  minbet MONEY, maxbet MONEY, maxpermatch MONEY)				
	CREATE TABLE #tblCust_member (custid INT,SportType SMALLINT, Bettype SMALLINT,  minbet MONEY, maxbet MONEY, maxpermatch MONEY)
	CREATE TABLE #tblCustNew (custid INT PRIMARY KEY,SportType SMALLINT, Bettype SMALLINT,  minbet MONEY, maxbet MONEY, maxpermatch MONEY)	
	CREATE TABLE #tblCustOld (custid INT PRIMARY KEY,SportType SMALLINT, Bettype SMALLINT,  minbet MONEY, maxbet MONEY, maxpermatch MONEY)
	CREATE TABLE #Super_adjust (custid INT PRIMARY KEY)
	
	INSERT INTO #Super_adjust (custid)
	SELECT CS.custid
	FROM dbo.Dep_CustSuper CS WITH (NOLOCK)
	WHERE CS.site IN ('368Cash','12Bet', 'asiabet88', 'mansion88', 'alog', 'TLC', 'SunGame', 'MayFair', 'Zzun88', 'HAIFA', 'Bodog', 'Vwin', 'Macaubet', 'Aoncash', 'ITCBet', 'Avia', 'W88', '9bet', '3star88', 'OLE777', '88Macao', 'Boma365', 'Salon365', 'Ae88', 'Hengcai88', 'Senibet', 'Allbetclub', 'Happy1668', 'AG', 'M8bola', '9Club', 'XTD3', 'HONBET', 'Q8bola', 'BE7', 'iBET', 'GooBet', 'Liga', 'NBCbet', 'HonorW', 'DEWA', 'IBO', 'Unobet', 'GamingSoft', 'Newhonbet', 'Hecbet', 'DBP', 'HL8', 'Abcasino', 'TGO', '365online', 'CQ11', 'Bolanation', 'KhmerG', 'Gampag', 'IONclub', 'Sun988', 'Mayayule', 'HuangMa', 'Webet138', 'webet88', 'Emmyo', 'BigGaming', 'Boying', 'MrCat', 'TCL', 'Aragon88', 'PKbet', 'VCBA', 'Taipanbet', 'Indowin', 'FLC', 'BetStar', 'Dawoo', 'Ty777', 'ABB688', 'BuyWin', 'Uwoniwin', 'Sunrise', 'sbcbet', 'LZYQ', 'May88', 'ECLBET', 'PanguGame')
	--SMA Level
	-------------------------------------DATA PREPARATION --------------------------------------------	
	INSERT INTO #tblCust_SMA (custid,SportType,Bettype, minbet, maxbet, maxpermatch)			
	SELECT CBS.CustID,CBS.SportType,CBS.BetType, CS.minbet, CS.maxbet, c.maxpermatch180
	FROM Dep_CustBetSetting_Agent CBS WITH (NOLOCK) 
		INNER JOIN custInfo C WITH (NOLOCK) ON C.custid = CBS.CustID
		INNER JOIN Dep_CustSetting3rd CS WITH(NOLOCK) ON CBS.CustID = CS.custid AND CS.sporttype = @SportType_VirtualSoccer AND CS.bettype = @Bettype_Soccer
	WHERE (cbs.MinBet <> cs.minbet OR cbs.MaxBet <> cs.maxbet OR cbs.MaxPerMatch <> c.maxpermatch180)
		AND CBS.SportType IN (190,191,199)
		AND EXISTS (SELECT 1 FROM #Super_adjust WITH (NOLOCK) WHERE CustID = C.srecommend)

	--Adjust for SMA Level
	UPDATE cbs
	SET minbet = CI.minbet
		, maxbet = CI.maxbet
		, maxpermatch = CI.maxpermatch
	FROM Dep_CustBetSetting_Agent CBS WITH (ROWLOCK,UPDLOCK) 
		INNER JOIN #tblCust_SMA CI WITH (NOLOCK) ON CI.custid = CBS.CustID AND CBS.SportType = CI.SportType AND CBS.BetType = CI.Bettype

	--Member Level
		
	DECLARE @SportType SMALLINT, @Bettype SMALLINT, @Threshold INT = 1000000
	DECLARE @MaxCustID INT = 0, @MinCustID INT = 0		

	WHILE (1 = 1 )
	BEGIN
		INSERT INTO #tblCustNew (custid,SportType,Bettype, minbet, maxbet, maxpermatch)			
		SELECT DISTINCT TOP (@Threshold) cs.CustID,cs.SportType,cs.BetType, CS.minbet, CS.maxbet, cs.maxpermatch
		FROM dbo.Dep_CustBetSetting_Member cs WITH (NOLOCK) 
			INNER JOIN dbo.custInfo C WITH (NOLOCK) ON cs.CustID = C.custid			
		WHERE cs.SportType = 190 AND cs.BetType = 2701
			AND EXISTS (SELECT 1 FROM #Super_adjust WITH (NOLOCK) WHERE CustID = C.srecommend)
			AND cs.CustID > @MinCustID
			
		ORDER BY cs.custid

		IF @@ROWCOUNT = 0 
			BREAK

		SELECT @MaxCustID = MAX(CustID) FROM #tblCustNew

		INSERT INTO #tblCustOld (custid,SportType,Bettype, minbet, maxbet, maxpermatch)			
		SELECT DISTINCT cs.CustID,cs.SportType,cs.BetType, CS.minbet, CS.maxbet, c.maxpermatch180
		FROM Dep_CustSetting3rd cs WITH (NOLOCK) 
			INNER JOIN custInfo c WITH (NOLOCK) ON c.custid = cs.CustID 
		WHERE CS.sporttype = @SportType_VirtualSoccer AND cs.BetType = @Bettype_Soccer
			AND EXISTS (SELECT 1 FROM #Super_adjust WITH (NOLOCK) WHERE CustID = C.srecommend)
			AND cs.CustID > @MinCustID AND cs.custid <= @MaxCustID
			
		ORDER BY cs.custid

		INSERT INTO #tblCust_member (custid,SportType,Bettype, minbet, maxbet, maxpermatch )			
		SELECT co.CustID,co.SportType,co.BetType, co.minbet, co.maxbet, co.maxpermatch
		FROM #tblCustNew cn
			INNER JOIN #tblCustOld co ON co.custid = cn.custid --AND co.SportType = cn.SportType AND cn.Bettype = co.Bettype
		WHERE (cn.MinBet <> co.minbet OR cn.MaxBet <> co.maxbet OR cn.MaxPerMatch <> co.maxpermatch)
	
		--Adjust for member Level
		UPDATE cs
		SET minbet = CI.minbet
			, maxbet = CI.maxbet
			, maxpermatch = CI.maxpermatch
		FROM Dep_CustBetSetting_Member cs WITH (ROWLOCK,UPDLOCK) 
			INNER JOIN #tblCust_member ci WITH (NOLOCK) ON ci.custid = cs.CustID 
		WHERE cs.SportType IN (190,191,199)	

		SELECT @MinCustID = @MaxCustID			

		RAISERROR(@msgDone, 0, 1, @SportType, @BetType)  WITH NOWAIT

		TRUNCATE TABLE #tblCust_member
		TRUNCATE TABLE #tblCustNew
		TRUNCATE TABLE #tblCustOld
	END


	DROP TABLE #tblCust_SMA
	
END
GO






