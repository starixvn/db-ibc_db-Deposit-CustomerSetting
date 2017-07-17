/*
	Created: 20170626@Helen
	Task: insert the Setting of BetradarVS of new licensees into the DCS database.
	Redmine: https://redmine.nexcel.vn/issues/77274
	DB: DBCUST/CUSTDB
*/ 

DECLARE @ProductID INT = 27, @SettingType INT = 2, @srecommend INT, @SportType_VSSoccer INT = 180

SELECT ps.SettingType,psd.SportType,psd.BetType
INTO #ProductSettingDetail_tmp
FROM Dep_ProductSetting ps WITH (NOLOCK) 
	INNER JOIN Dep_ProductSettingDetail psd WITH (NOLOCK) ON psd.ProductSettingID = ps.ProductSettingID
WHERE ps.ProductID= @ProductID AND PS.SettingType = @SettingType
	
CREATE TABLE #supers (custid INT,site VARCHAR(200),isfinished BIT DEFAULT(0))
INSERT INTO #supers(custid,site)
SELECT custid,Site
FROM  Dep_CustSuper WITH(NOLOCK) 
WHERE  site in ('12Bet')
	AND currency NOT IN (27) -- Currency H - it is just test currency, used once in a while 


CREATE TABLE #tblCust (custid INT, roleid INT
							, maxpermatch180 MONEY
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
	
	INSERT INTO #tblCust (custid,roleid, maxpermatch180)			
	SELECT custid,roleid, maxpermatch180
	FROM custInfo WITH(NOLOCK)
	WHERE srecommend =@srecommend
		AND mrecommend NOT IN (SELECT custid FROM custinfo WITH(NOLOCK)
							   WHERE srecommend=@srecommend and username like '%Acc%' and roleid=3)
	-- SMA Adjust
	UPDATE cbs
		SET minbet = cs.minbet
		, maxbet = cs.maxbet
		, maxpermatch = CI.maxpermatch180
	FROM Dep_CustBetSetting_Agent cbs WITH (ROWLOCK,UPDLOCK) 
		INNER JOIN #tblCust CI WITH (NOLOCK) ON cbs.CustID = ci.custid 
		INNER JOIN Dep_CustSetting3rd cs WITH(NOLOCK) ON cbs.CustID = cs.custid AND cs.sporttype = @SportType_VSSoccer
		INNER JOIN #ProductSettingDetail_tmp dest WITH(NOLOCK) ON  cbs.bettype = dest.BetType AND cbs.sporttype = dest.SportType
	WHERE ci.roleid IN (2,3,4) AND cbs.SportType IN (190,191,199)
		AND (cbs.MinBet <> cs.minbet OR cbs.MaxBet <> cs.maxbet OR cbs.MaxPerMatch <> CI.maxpermatch180)
	
	-- Member Adjust
	UPDATE cbs
		SET minbet = cs.minbet
		, maxbet = cs.maxbet
		, maxpermatch = CI.maxpermatch180
	FROM Dep_CustBetSetting_Member cbs WITH (ROWLOCK,UPDLOCK) 
		INNER JOIN #tblCust CI WITH (NOLOCK) ON cbs.CustID = ci.custid 
		INNER JOIN Dep_CustSetting3rd cs WITH(NOLOCK) ON cbs.CustID = cs.custid AND cs.sporttype = @SportType_VSSoccer
		INNER JOIN #ProductSettingDetail_tmp dest WITH(NOLOCK) ON  cbs.bettype = dest.BetType AND cbs.sporttype = dest.SportType
	WHERE ci.roleid = 1 AND cbs.SportType IN (190,191,199)
		AND (cbs.MinBet <> cs.minbet OR cbs.MaxBet <> cs.maxbet OR cbs.MaxPerMatch <> CI.maxpermatch180)
	
	TRUNCATE TABLE #tblCust
	
END

DROP TABLE #ProductSettingDetail_tmp
DROP TABLE #supers
DROP TABLE #tblCust
