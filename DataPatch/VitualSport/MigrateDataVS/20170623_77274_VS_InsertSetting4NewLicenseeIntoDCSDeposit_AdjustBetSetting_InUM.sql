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
	
CREATE TABLE #supers (custid INT,isfinished BIT DEFAULT(0))
INSERT INTO #supers(custid)
SELECT custid
FROM  Dep_CustSuper WITH(NOLOCK) 
WHERE  custid in (1) -- get srecomeend based on list change setting from userlog_runsp

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

CREATE TABLE #tblCust (custid INT, roleid INT)



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
	
	INSERT INTO #tblCust (custid,roleid )			
	SELECT custid,roleid
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
		INNER JOIN custInfo C WITH (NOLOCK) ON cbs.CustID = C.custid
		INNER JOIN #tblCust CI WITH (NOLOCK) ON cbs.CustID = ci.custid 
		INNER JOIN Dep_CustSetting3rd cs WITH(NOLOCK) ON cbs.CustID = cs.custid AND cbs.SportType = cs.sporttype AND cbs.BetType = cs.bettype
		INNER JOIN #ProductSettingDetail_tmp dest WITH(NOLOCK) ON  cs.bettype = dest.BetType AND cs.sporttype = dest.SportType
		CROSS APPLY( VALUES
				('maxpermatch180',C.maxpermatch180),
				('maxpermatch181',C.maxpermatch181),
				('maxpermatch182',C.maxpermatch182),
				('maxpermatch183',C.maxpermatch183),
				('maxpermatch184',C.maxpermatch184),
				('maxpermatch185',C.maxpermatch185),
				('maxpermatch186',C.maxpermatch186)
		 ) AS A(columnname, maxpermatch)
	   
	   INNER JOIN #SportTypeCheck S ON S.MaxPerMatchName = A.columnname AND dest.SportType = s.SportType AND dest.BetType = s.BetType

	WHERE ci.roleid IN (2,3,4) AND (cbs.MinBet <> cs.minbet OR cbs.MaxBet <> cs.maxbet OR cbs.MaxPerMatch <> a.maxpermatch)
	
	-- Member Adjust
	UPDATE cbs
		SET minbet = cs.minbet
		, maxbet = cs.maxbet
		, maxpermatch = a.maxpermatch
	
	FROM Dep_CustBetSetting_Member cbs WITH (ROWLOCK,UPDLOCK) 
		INNER JOIN custInfo C WITH (NOLOCK) ON cbs.CustID = C.custid
		INNER JOIN Dep_CustSetting3rd cs WITH(NOLOCK) ON cbs.CustID = cs.custid AND cbs.SportType = cs.sporttype AND cbs.BetType = cs.bettype
		INNER JOIN #tblCust CI WITH (NOLOCK) ON cbs.CustID = ci.custid 
		INNER JOIN #ProductSettingDetail_tmp dest WITH(NOLOCK) ON  cs.bettype = dest.BetType AND cs.sporttype = dest.SportType
		CROSS APPLY( VALUES
				('maxpermatch180',C.maxpermatch180),
				('maxpermatch181',C.maxpermatch181),
				('maxpermatch182',C.maxpermatch182),
				('maxpermatch183',C.maxpermatch183),
				('maxpermatch184',C.maxpermatch184),
				('maxpermatch185',C.maxpermatch185),
				('maxpermatch186',C.maxpermatch186)
		 ) AS A(columnname, maxpermatch)
	   
	   INNER JOIN #SportTypeCheck S ON S.MaxPerMatchName = A.columnname AND dest.SportType = s.SportType AND dest.BetType = s.BetType

	WHERE ci.roleid = 1 AND (cbs.MinBet <> cs.minbet OR cbs.MaxBet <> cs.maxbet OR cbs.MaxPerMatch <> a.maxpermatch)
	
	TRUNCATE TABLE #tblCust
	
END

DROP TABLE #ProductSettingDetail_tmp
DROP TABLE #SportTypeCheck
DROP TABLE #supers
DROP TABLE #tblCust
