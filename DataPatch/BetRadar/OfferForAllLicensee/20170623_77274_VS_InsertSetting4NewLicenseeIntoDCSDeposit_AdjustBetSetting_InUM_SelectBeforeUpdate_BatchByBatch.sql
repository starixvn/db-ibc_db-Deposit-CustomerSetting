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

	CREATE TABLE #tblCust_SMA (custid INT,SportType SMALLINT, Bettype SMALLINT,  minbet MONEY, maxbet MONEY, maxpermatch180 MONEY, ID INT IDENTITY(1,1))

	CREATE TABLE #tblCust_member (custid INT,SportType SMALLINT, Bettype SMALLINT,  minbet MONEY, maxbet MONEY, maxpermatch180 MONEY, ID INT IDENTITY(1,1))

	CREATE TABLE #supers (custid INT,totaldownline INT)

	INSERT INTO #supers(custid,totaldownline)
	SELECT cs.custid, COUNT(1)
	FROM  Dep_CustSuper CS WITH (NOLOCK) 
		INNER JOIN custInfo CI WITH (NOLOCK) ON CS.custid = CI.srecommend
	WHERE cs.site in ('12Bet','asiabet88','mansion88','alog','spondemo','TLC','DELA','SunGame','MayFair','Zzun88','HAIFA','Bodog','Vwin','Macaubet','Aoncash','ITCBet','Avia','W88','9bet','3star88','OLE777','88Macao','Boma365','Salon365','Ae88','Hengcai88','368Cash','Senibet','Allbetclub','Happy1668','AG','M8bola','KeenOcean','9Club','XTD3','HONBET','Q8bola','BE7','iBET','GooBet','Liga','NBCbet','HonorW','DEWA','IBO','Unobet','GamingSoft','Newhonbet','Hecbet','DBP','HL8','Abcasino','TGO','365online','CQ11','Bolanation','KhmerG','Gampag','IONclub','Sun988','Mayayule','HuangMa','Webet138','webet88','Emmyo','BigGaming','Boying','MrCat','TCL','Aragon88','PKbet','VCBA','Taipanbet','Indowin','FLC','BetStar','Dawoo','Ty777','ABB688','BuyWin','Uwoniwin','Sunrise','sbcbet','LZYQ','May88','ECLBET','PanguGame')
		AND cs.currency NOT IN (27) -- Currency H - it is just test currency, used once in a while 
	GROUP BY CS.custid	
	
	--------------------------- SCAN ALL FOR SMA -------------------------------------------------------------------------------
	INSERT INTO #tblCust_SMA (custid,SportType,Bettype, minbet, maxbet, maxpermatch180 )			
	SELECT CBS.CustID,CBS.SportType,CBS.BetType, CS.minbet, CS.maxbet, CI.maxpermatch180
	FROM Dep_CustBetSetting_Agent CBS WITH (NOLOCK) 
		INNER JOIN custInfo CI WITH (NOLOCK) ON CBS.CustID = ci.custid 
		INNER JOIN Dep_CustSetting3rd cs WITH(NOLOCK) ON CBS.CustID = CS.custid AND CS.sporttype = @SportType_VSSoccer
	WHERE cbs.SportType IN (190,191,199)
		AND (CBS.MinBet <> CS.minbet OR CBS.MaxBet <> CS.maxbet OR CBS.MaxPerMatch <> CI.maxpermatch180)
		
	------------------------- STARTING: line < 200K: scan all ------------------------------------------------------------------
		
	INSERT INTO #tblCust_member (custid,SportType,Bettype, minbet, maxbet, maxpermatch180 )			
	SELECT CBS.CustID,CBS.SportType,CBS.BetType, CS.minbet, CS.maxbet, CI.maxpermatch180
	FROM Dep_CustBetSetting_Member CBS WITH (NOLOCK) 
		INNER JOIN custInfo CI WITH (NOLOCK) ON CBS.CustID = ci.custid 
		INNER JOIN Dep_CustSetting3rd cs WITH(NOLOCK) ON CBS.CustID = CS.custid AND CS.sporttype = @SportType_VSSoccer
	WHERE cbs.SportType IN (190,191,199)
		AND (CBS.MinBet <> CS.minbet OR CBS.MaxBet <> CS.maxbet OR CBS.MaxPerMatch <> CI.maxpermatch180)
		AND srecommend IN (SELECT custid FROM #supers WHERE totaldownline <= @Threshold_superLine)
		
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
		
		INSERT INTO #tblCust_member (custid,SportType,Bettype, minbet, maxbet, maxpermatch180 )			
		SELECT CBS.CustID,CBS.SportType,CBS.BetType, CS.minbet, CS.maxbet, CI.maxpermatch180
		FROM Dep_CustBetSetting_Agent CBS WITH (NOLOCK) 
			INNER JOIN custInfo CI WITH (NOLOCK) ON CBS.CustID = ci.custid 
			INNER JOIN Dep_CustSetting3rd cs WITH(NOLOCK) ON CBS.CustID = CS.custid AND CS.sporttype = @SportType_VSSoccer
		WHERE cbs.SportType = 190
			AND (CBS.MinBet <> CS.minbet OR CBS.MaxBet <> CS.maxbet OR CBS.MaxPerMatch <> CI.maxpermatch180)
			AND srecommend = @srecommend
		
		INSERT INTO #tblCust_member (custid,SportType,Bettype, minbet, maxbet, maxpermatch180 )			
		SELECT CBS.CustID,CBS.SportType,CBS.BetType, CS.minbet, CS.maxbet, CI.maxpermatch180
		FROM Dep_CustBetSetting_Agent CBS WITH (NOLOCK) 
			INNER JOIN custInfo CI WITH (NOLOCK) ON CBS.CustID = ci.custid 
			INNER JOIN Dep_CustSetting3rd cs WITH(NOLOCK) ON CBS.CustID = CS.custid AND CS.sporttype = @SportType_VSSoccer
		WHERE cbs.SportType  = 191
			AND (CBS.MinBet <> CS.minbet OR CBS.MaxBet <> CS.maxbet OR CBS.MaxPerMatch <> CI.maxpermatch180)
			AND srecommend = @srecommend
			
		INSERT INTO #tblCust_member (custid,SportType,Bettype, minbet, maxbet, maxpermatch180 )			
		SELECT CBS.CustID,CBS.SportType,CBS.BetType, CS.minbet, CS.maxbet, CI.maxpermatch180
		FROM Dep_CustBetSetting_Agent CBS WITH (NOLOCK) 
			INNER JOIN custInfo CI WITH (NOLOCK) ON CBS.CustID = ci.custid 
			INNER JOIN Dep_CustSetting3rd cs WITH(NOLOCK) ON CBS.CustID = CS.custid AND CS.sporttype = @SportType_VSSoccer
		WHERE cbs.SportType  = 199
			AND (CBS.MinBet <> CS.minbet OR CBS.MaxBet <> CS.maxbet OR CBS.MaxPerMatch <> CI.maxpermatch180)
			AND srecommend = @srecommend
			
	END	

	-------------------------------------DATA PREPARATION --------------------------------------------	

	-------------------------------------ADJUST BET SETTING --------------------------------------------		
	
	UPDATE cbs
		SET minbet = CI.minbet
		, maxbet = CI.maxbet
		, maxpermatch = CI.maxpermatch180
	FROM Dep_CustBetSetting_Agent CBS WITH (ROWLOCK,UPDLOCK) 
		INNER JOIN #tblCust_SMA CI WITH (NOLOCK) ON CBS.CustID = ci.custid AND CBS.SportType = CI.SportType AND CBS.BetType = CI.Bettype
					
	UPDATE cbs
		SET minbet = CI.minbet
			, maxbet = CI.maxbet
			, maxpermatch = CI.maxpermatch180
	FROM Dep_CustBetSetting_Member CBS WITH (ROWLOCK,UPDLOCK) 
		INNER JOIN #tblCust_member CI WITH (NOLOCK) ON CBS.CustID = ci.custid AND CBS.SportType = CI.SportType AND CBS.BetType = CI.Bettype
	
	DROP TABLE #supers
	DROP TABLE #supers_bigline
	DROP TABLE #tblCust_SMA
	DROP TABLE #tblCust_member						

END
GO
EXEC Acc_Dep_DynamicCustSetting_09