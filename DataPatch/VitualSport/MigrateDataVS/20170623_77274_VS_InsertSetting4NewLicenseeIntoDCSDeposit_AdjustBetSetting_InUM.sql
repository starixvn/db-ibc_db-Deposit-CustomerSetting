/*
	Created: 20170626@Helen
	Task: insert the Setting of VS of new licensees into the DCS database.
	Redmine: https://redmine.nexcel.vn/issues/77274
	DB: DBCUST/CUSTDB
*/ 

DECLARE @ProductID INT = 5, @SettingType INT = 2, @srecommend INT

SELECT ps.SettingType,psd.SportType,psd.BetType
INTO #ProductSettingDetail_tmp
FROM Dep_ProductSetting ps WITH (NOLOCK) 
	INNER JOIN Dep_ProductSettingDetail psd WITH (NOLOCK) ON psd.ProductSettingID = ps.ProductSettingID
WHERE ps.ProductID= @ProductID AND PS.SettingType = @SettingType
	
CREATE TABLE #supers (custid INT,site VARCHAR(200),isfinished BIT DEFAULT(0))
INSERT INTO #supers(custid,site)
SELECT custid,Site
FROM  Dep_CustSuper WITH(NOLOCK) 
WHERE  site in (
					-- Licensee fee 0.85
					'12Bet', 'asiabet88', 'mansion88', 'alog', 'spondemo', 'TLC', 'SunGame', 'MayFair', 'Zzun88', 'Bodog', 'Vwin', 'Macaubet', 'VCasia', 'Aoncash', 'Bwinning', 'ITCBet', 'i668bet', 'Avia', 'W88', '9bet', '67BET', '3star88', 'SLC88', 'Bet2day', 'OLE777', 'Winner99', '88Macao', 'Boma365', 'Hbobet', 'Mgm88', 'Saloncs', 'Salon365', 'Ae88', 'Hengcai88', 'Senibet', 'Allbetclub', 'Happy1668', 'AG', 'M8bola', 'THBET', '9Club', 'XTD3', '28BET', 'HONBET', 'Q8bola', 'BE7', 'iBET', 'MarvelDH', 'DAYWIN', 'GooBet', 'ISC888', 'KaiHao', 'Liga', 'RYB95', 'SHABAING', 'NBCbet', '666VIP', 'Inbet', 'HonorW', 'DEWA', 'IBO', 'YHY1980', 'Empire555', 'Unobet', 'GamingSoft', 'Newhonbet', '21Cash', 'DUOLE', 'Hecbet', 'DBP', 'Asianbet', 'Baobet', 'HL8', 'Abcasino', 'TGO', 'Lexibet', 'King10', '365online', 'CQ11', 'Uwin18', 'Bolanation', 'KhmerG', 'Gampag', 'IONclub', 'Sun988', 'Mayayule', 'HuangMa', 'Webet138', 'webet88', 'Emmyo', 'BigGaming', 'Boying', 'GDC', 'MrCat', 'TCL', 'Aragon88', 'PKbet', 'VCBA', 'Taipanbet', 'Indowin', 'FLC', 'BetStar', 'Dawoo', 'Ty777', 'Kasking88', 'ABB688', 'Star99', 'BuyWin', 'Uwoniwin', 'Sunrise', 'yq355', 'XTD1', 'XTD2', 'Wawabet', 'BlueOcean', 'Lambo777', 'Deebet', 'Citibet', 'BE7TH', 'Starnet', '12betco', 'sbcbet', 'Brown888', 'CGame', 'IGPTech', 'TGame', 'LZYQ', 'May88', 'Swin', 'LongBao', 'UN168', 'PanguGame', 'K8VN', 'ECLBET', 'Lucky88', 'GPIGAME', '818Bet','SSSSEA'
					-- Licensee fee 0.875
					, 'HAIFA'
					)
		AND currency NOT IN (27) -- Currency H - it is just test currency, used once in a while 

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

CREATE TABLE #tblCust (custid INT, roleid INT
							, maxpermatch180 MONEY
							, maxpermatch181 MONEY
							, maxpermatch182 MONEY
							, maxpermatch183 MONEY
							, maxpermatch184 MONEY
							, maxpermatch185 MONEY
							, maxpermatch186 MONEY
						)



-- For deployer info
DECLARE @super_cnt INT, @index INT = 0

SET @super_cnt = (SELECT COUNT(*) FROM #supers )

DECLARE @msg NVARCHAR(200) = 'Currently at order %d, SuperID: %d.'

DECLARE @msg_total NVARCHAR(200) = 'Total of supers: %d.'

RAISERROR (@msg_total, 0, 1, @super_cnt) WITH NOWAIT

WHILE (1=1)					 
BEGIN
	
	UPDATE TOP (1) #supers
	SET isfinished = 1
		,@srecommend = custid
	WHERE isfinished = 0 
	
	IF @@ROWCOUNT = 0 BREAK
	
	SET @index = @index + 1
	
	RAISERROR (@msg, 0, 1,@index, @srecommend) WITH NOWAIT
	
	INSERT INTO #tblCust (custid,roleid, maxpermatch180, maxpermatch181 , maxpermatch182,  maxpermatch183, maxpermatch184, maxpermatch185, maxpermatch186 )			
	SELECT custid,roleid, maxpermatch180, maxpermatch181 , maxpermatch182,  maxpermatch183, maxpermatch184, maxpermatch185, maxpermatch186 
	FROM custInfo WITH(NOLOCK)
	WHERE srecommend =@srecommend
		AND mrecommend NOT IN (SELECT custid FROM custinfo WITH(NOLOCK)
							   WHERE srecommend=@srecommend and username LIKE '%Acc%' AND roleid=3)
	
	-- SMA Adjust
	UPDATE cbs
		SET minbet = cs.minbet
		, maxbet = cs.maxbet
		, maxpermatch = a.maxpermatch
	FROM Dep_CustBetSetting_Agent cbs WITH (ROWLOCK,UPDLOCK) 
		INNER JOIN #tblCust CI WITH (NOLOCK) ON cbs.CustID = ci.custid 
		INNER JOIN Dep_CustSetting3rd cs WITH(NOLOCK) ON cbs.CustID = cs.custid AND cbs.SportType = cs.sporttype AND cbs.BetType = cs.bettype
		INNER JOIN #ProductSettingDetail_tmp dest WITH(NOLOCK) ON  cs.bettype = dest.BetType AND cs.sporttype = dest.SportType
		CROSS APPLY( VALUES
				('maxpermatch180',ci.maxpermatch180),
				('maxpermatch181',ci.maxpermatch181),
				('maxpermatch182',ci.maxpermatch182),
				('maxpermatch183',ci.maxpermatch183),
				('maxpermatch184',ci.maxpermatch184),
				('maxpermatch185',ci.maxpermatch185),
				('maxpermatch186',ci.maxpermatch186)
		 ) AS A(columnname, maxpermatch)
	   
	   INNER JOIN #SportTypeCheck S ON S.MaxPerMatchName = A.columnname AND dest.SportType = s.SportType AND dest.BetType = s.BetType

	WHERE ci.roleid IN (2,3,4) AND (cbs.MinBet <> cs.minbet OR cbs.MaxBet <> cs.maxbet OR cbs.MaxPerMatch <> a.maxpermatch)
	
	-- Member Adjust
	UPDATE cbs
		SET minbet = cs.minbet
		, maxbet = cs.maxbet
		, maxpermatch = a.maxpermatch
	
	FROM Dep_CustBetSetting_Member cbs WITH (ROWLOCK,UPDLOCK) 
		INNER JOIN Dep_CustSetting3rd cs WITH(NOLOCK) ON cbs.CustID = cs.custid AND cbs.SportType = cs.sporttype AND cbs.BetType = cs.bettype
		INNER JOIN #tblCust CI WITH (NOLOCK) ON cbs.CustID = ci.custid 
		INNER JOIN #ProductSettingDetail_tmp dest WITH(NOLOCK) ON  cs.bettype = dest.BetType AND cs.sporttype = dest.SportType
		CROSS APPLY( VALUES
				('maxpermatch180',ci.maxpermatch180),
				('maxpermatch181',ci.maxpermatch181),
				('maxpermatch182',ci.maxpermatch182),
				('maxpermatch183',ci.maxpermatch183),
				('maxpermatch184',ci.maxpermatch184),
				('maxpermatch185',ci.maxpermatch185),
				('maxpermatch186',ci.maxpermatch186)
		 ) AS A(columnname, maxpermatch)
	   
	   INNER JOIN #SportTypeCheck S ON S.MaxPerMatchName = A.columnname AND dest.SportType = s.SportType AND dest.BetType = s.BetType

	WHERE ci.roleid = 1 AND (cbs.MinBet <> cs.minbet OR cbs.MaxBet <> cs.maxbet OR cbs.MaxPerMatch <> a.maxpermatch)
	
	TRUNCATE TABLE #tblCust
	
END

DROP TABLE #ProductSettingDetail_tmp
DROP TABLE #SportTypeCheck
DROP TABLE #supers
DROP TABLE #tblCust
