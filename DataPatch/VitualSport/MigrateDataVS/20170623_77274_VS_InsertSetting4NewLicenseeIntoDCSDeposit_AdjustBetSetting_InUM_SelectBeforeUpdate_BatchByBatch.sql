/*
	Created: 20170626@Helen
	Task: insert the Setting of VS of new licensees into the DCS database.
	Redmine: https://redmine.nexcel.vn/issues/77274
	DB: DBCUST/CUSTDB
*/ 
ALTER PROCEDURE [dbo].[Acc_Dep_DynamicCustSetting_09]
/*
	
	-- line < 200K: scan all
	-- line > 200K
	-- Batch: by line, by sport,  

*/	

AS
BEGIN	

	SET NOCOUNT ON

	DECLARE @SportType_VSSoccer INT = 180, @Threshold_superLine INT = 200000, @srecommend INT 

	CREATE TABLE #tblCust_SMA (custid INT,SportType SMALLINT, Bettype SMALLINT,  minbet MONEY, maxbet MONEY, maxpermatch MONEY, ID INT IDENTITY(1,1))

	CREATE TABLE #tblCust_member (custid INT,SportType SMALLINT, Bettype SMALLINT,  minbet MONEY, maxbet MONEY, maxpermatch MONEY, ID INT IDENTITY(1,1))

	CREATE TABLE #supers (custid INT,totaldownline INT)

	INSERT INTO #supers(custid,totaldownline)
	SELECT cs.custid, COUNT(1)
	FROM  dbo.Dep_CustSuper CS WITH (NOLOCK) 
		INNER JOIN dbo.custInfo CI WITH (NOLOCK) ON CS.custid = CI.srecommend
	WHERE cs.site in (
					-- Licensee fee 0.85
					'12Bet','asiabet88','mansion88','alog','spondemo','TLC','SunGame','MayFair','Zzun88','Bodog','Vwin','Macaubet','VCasia','Aoncash','Bwinning','ITCBet','i668bet','Avia','W88','9bet','67BET','3star88','SLC88','Bet2day','OLE777','Winner99','88Macao','Boma365','Hbobet','Mgm88','Saloncs','Salon365','Ae88','Hengcai88','Senibet','Allbetclub','Happy1668','AG','M8bola','THBET','9Club','XTD3','28BET','HONBET','Q8bola','BE7','iBET','MarvelDH','DAYWIN','GooBet','ISC888','KaiHao','Liga','RYB95','SHABAING','NBCbet','666VIP','Inbet','HonorW','DEWA','IBO','YHY1980','Empire555','Unobet','GamingSoft','Newhonbet','21Cash','DUOLE','Hecbet','DBP','Asianbet','Baobet','HL8','Abcasino','TGO','Lexibet','King10','365online','CQ11','Uwin18','Bolanation','KhmerG','Gampag','IONclub','Sun988','Mayayule','HuangMa','Webet138','webet88','Emmyo','BigGaming','Boying','GDC','MrCat','TCL','Aragon88','PKbet','VCBA','Taipanbet','Indowin','FLC','BetStar','Dawoo','Ty777','Kasking88','ABB688','Star99','BuyWin','Uwoniwin','Sunrise','Citibet','BE7TH','Starnet','12betco','sbcbet','Brown888','CGame','IGPTech','TGame','LZYQ','May88','Swin','LongBao','UN168','PanguGame','K8VN','ECLBET','Lucky88','GPIGAME','818Bet','SSSSEA'
					-- Licensee fee 0.875
					, 'HAIFA'
					)

		AND cs.currency NOT IN (27) -- Currency H - it is just test currency, used once in a while 
	GROUP BY CS.custid	
		
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

	--------------------------- SCAN ALL FOR SMA -------------------------------------------------------------------------------
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
		AND C.srecommend IN (SELECT custid FROM #supers WITH (NOLOCK))
		
	------------------------ FOR member ---------------------------------------------------------------------------------------	
	------------------------- STARTING: line < 200K: scan all ------------------------------------------------------------------
		
	INSERT INTO #tblCust_member (custid,SportType,Bettype, minbet, maxbet, maxpermatch )			
	SELECT CBS.CustID,CBS.SportType,CBS.BetType, CS.minbet, CS.maxbet, A.maxpermatch
	FROM dbo.Dep_CustBetSetting_Member CBS WITH (NOLOCK) 
		INNER JOIN dbo.custInfo C WITH (NOLOCK) ON C.custid = CBS.CustID 
		INNER JOIN dbo.Dep_CustSetting3rd CS WITH(NOLOCK) ON CBS.CustID = CS.custid AND CBS.SportType = CS.sporttype AND CBS.BetType = CS.bettype
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
		AND c.srecommend IN (SELECT custid FROM #supers WHERE totaldownline <= @Threshold_superLine)
		
	-------------------------END OF PROCESSING: line < 200K: scan all ----------------------------------------------------------

	------------------------ line > 200K: Batch: by line, by sport ------------------------------------------------------------  
	CREATE TABLE #supers_bigline (custid INT, isfinished BIT DEFAULT(0) )
	INSERT INTO #supers_bigline (custid)
	SELECT custid
	FROM #supers WITH (NOLOCK)
	WHERE totaldownline > @Threshold_superLine
	
	-- For deployer info
	DECLARE @super_cnt INT, @index INT = 0

	SET @super_cnt = (SELECT COUNT(*) FROM #supers_bigline )

	DECLARE @msg NVARCHAR(200) = 'Currently at order %d, SuperID: %d.'

	DECLARE @msg_total NVARCHAR(200) = 'Total of supers: %d.'

	RAISERROR (@msg_total, 0, 1, @super_cnt) WITH NOWAIT

	WHILE (1 = 1)
	BEGIN
		UPDATE TOP (1) #supers_bigline
		SET isfinished = 1
			,@srecommend = custid
		WHERE isfinished = 0
		
		IF @@ROWCOUNT = 0 BREAK
		
		SET @index = @index + 1
		
		RAISERROR (@msg, 0, 1,@index, @srecommend) WITH NOWAIT
			
		INSERT INTO #tblCust_member (custid,SportType,Bettype, minbet, maxbet, maxpermatch )			
		SELECT CBS.CustID,CBS.SportType,CBS.BetType, CS.minbet, CS.maxbet, c.maxpermatch180
		FROM dbo.Dep_CustBetSetting_Member CBS WITH (NOLOCK) 
			INNER JOIN custInfo C WITH (NOLOCK) ON C.custid = CBS.CustID 
			INNER JOIN Dep_CustSetting3rd CS WITH(NOLOCK) ON CBS.CustID = CS.custid AND CBS.SportType = CS.sporttype AND CBS.BetType = CS.bettype
		WHERE (cbs.MinBet <> cs.minbet OR cbs.MaxBet <> cs.maxbet OR cbs.MaxPerMatch <> c.maxpermatch180)
			AND CBS.SportType = 180
			AND C.srecommend = @srecommend

		INSERT INTO #tblCust_member (custid,SportType,Bettype, minbet, maxbet, maxpermatch )			
		SELECT CBS.CustID,CBS.SportType,CBS.BetType, CS.minbet, CS.maxbet, c.maxpermatch181
		FROM dbo.Dep_CustBetSetting_Member CBS WITH (NOLOCK) 
			INNER JOIN dbo.custInfo C WITH (NOLOCK) ON C.custid = CBS.CustID 
			INNER JOIN dbo.Dep_CustSetting3rd CS WITH(NOLOCK) ON CBS.CustID = CS.custid AND CBS.SportType = CS.sporttype AND CBS.BetType = CS.bettype
		WHERE (cbs.MinBet <> cs.minbet OR cbs.MaxBet <> cs.maxbet OR cbs.MaxPerMatch <> c.maxpermatch181)
			AND CBS.SportType = 181
			AND C.srecommend = @srecommend
			
		INSERT INTO #tblCust_member (custid,SportType,Bettype, minbet, maxbet, maxpermatch )			
		SELECT CBS.CustID,CBS.SportType,CBS.BetType, CS.minbet, CS.maxbet, c.maxpermatch182
		FROM dbo.Dep_CustBetSetting_Member CBS WITH (NOLOCK) 
			INNER JOIN dbo.custInfo C WITH (NOLOCK) ON C.custid = CBS.CustID 
			INNER JOIN dbo.Dep_CustSetting3rd CS WITH(NOLOCK) ON CBS.CustID = CS.custid AND CBS.SportType = CS.sporttype AND CBS.BetType = CS.bettype
		WHERE (cbs.MinBet <> cs.minbet OR cbs.MaxBet <> cs.maxbet OR cbs.MaxPerMatch <> c.maxpermatch182)
			AND CBS.SportType = 182
			AND C.srecommend = @srecommend
		
		INSERT INTO #tblCust_member (custid,SportType,Bettype, minbet, maxbet, maxpermatch )			
		SELECT CBS.CustID,CBS.SportType,CBS.BetType, CS.minbet, CS.maxbet, c.maxpermatch183
		FROM dbo.Dep_CustBetSetting_Member CBS WITH (NOLOCK) 
			INNER JOIN dbo.custInfo C WITH (NOLOCK) ON C.custid = CBS.CustID 
			INNER JOIN dbo.Dep_CustSetting3rd CS WITH(NOLOCK) ON CBS.CustID = CS.custid AND CBS.SportType = CS.sporttype AND CBS.BetType = CS.bettype
		WHERE (cbs.MinBet <> cs.minbet OR cbs.MaxBet <> cs.maxbet OR cbs.MaxPerMatch <> c.maxpermatch183)
			AND CBS.SportType = 183
			AND C.srecommend = @srecommend
				
		INSERT INTO #tblCust_member (custid,SportType,Bettype, minbet, maxbet, maxpermatch )			
		SELECT CBS.CustID,CBS.SportType,CBS.BetType, CS.minbet, CS.maxbet, c.maxpermatch184
		FROM Dep_CustBetSetting_Member CBS WITH (NOLOCK) 
			INNER JOIN custInfo C WITH (NOLOCK) ON C.custid = CBS.CustID 
			INNER JOIN Dep_CustSetting3rd CS WITH(NOLOCK) ON CBS.CustID = CS.custid AND CBS.SportType = CS.sporttype AND CBS.BetType = CS.bettype
		WHERE (cbs.MinBet <> cs.minbet OR cbs.MaxBet <> cs.maxbet OR cbs.MaxPerMatch <> c.maxpermatch184)
			AND CBS.SportType = 184
			AND C.srecommend = @srecommend
		
		INSERT INTO #tblCust_member (custid,SportType,Bettype, minbet, maxbet, maxpermatch )			
		SELECT CBS.CustID,CBS.SportType,CBS.BetType, CS.minbet, CS.maxbet, c.maxpermatch185
		FROM dbo.Dep_CustBetSetting_Member CBS WITH (NOLOCK) 
			INNER JOIN dbo.custInfo C WITH (NOLOCK) ON C.custid = CBS.CustID 
			INNER JOIN dbo.Dep_CustSetting3rd CS WITH(NOLOCK) ON CBS.CustID = CS.custid AND CBS.SportType = CS.sporttype AND CBS.BetType = CS.bettype
		WHERE (cbs.MinBet <> cs.minbet OR cbs.MaxBet <> cs.maxbet OR cbs.MaxPerMatch <> c.maxpermatch185)
			AND CBS.SportType = 185
			AND C.srecommend = @srecommend
		
		INSERT INTO #tblCust_member (custid,SportType,Bettype, minbet, maxbet, maxpermatch )			
		SELECT CBS.CustID,CBS.SportType,CBS.BetType, CS.minbet, CS.maxbet, c.maxpermatch186
		FROM dbo.Dep_CustBetSetting_Member CBS WITH (NOLOCK) 
			INNER JOIN dbo.custInfo C WITH (NOLOCK) ON C.custid = CBS.CustID 
			INNER JOIN dbo.Dep_CustSetting3rd CS WITH(NOLOCK) ON CBS.CustID = CS.custid AND CBS.SportType = CS.sporttype AND CBS.BetType = CS.bettype
		WHERE (cbs.MinBet <> cs.minbet OR cbs.MaxBet <> cs.maxbet OR cbs.MaxPerMatch <> c.maxpermatch186)
			AND CBS.SportType = 186
			AND C.srecommend = @srecommend
		
	END	
	-------------------------------------DATA PREPARATION --------------------------------------------	
	-------------------------------------ADJUST BET SETTING --------------------------------------------		
	UPDATE cbs
			SET minbet = CI.minbet
			, maxbet = CI.maxbet
			, maxpermatch = CI.maxpermatch
		FROM Dep_CustBetSetting_Agent CBS WITH (ROWLOCK,UPDLOCK) 
			INNER JOIN #tblCust_SMA CI WITH (NOLOCK) ON CI.custid = CBS.CustID AND CBS.SportType = CI.SportType AND CBS.BetType = CI.Bettype
					
	UPDATE cbs
			SET minbet = CI.minbet
				, maxbet = CI.maxbet
				, maxpermatch = CI.maxpermatch
		FROM Dep_CustBetSetting_Member CBS WITH (ROWLOCK,UPDLOCK) 
			INNER JOIN #tblCust_member CI WITH (NOLOCK) ON CI.custid = CBS.CustID AND CBS.SportType = CI.SportType AND CBS.BetType = CI.Bettype
	
	DROP TABLE #supers
	DROP TABLE #supers_bigline
	DROP TABLE #tblCust_SMA
	DROP TABLE #tblCust_member						

END
	
GO

EXEC Acc_Dep_DynamicCustSetting_09