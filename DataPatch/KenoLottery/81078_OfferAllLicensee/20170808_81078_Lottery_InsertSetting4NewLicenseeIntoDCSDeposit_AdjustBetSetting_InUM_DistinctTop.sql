/*
	Created: 20170808@Helen
	Task: [Lottery]-Initialize data for Deposit 
	Redmine: https://nexdev.net/issues/81078
	DB: DBCUST/CUSTDB
	
	Executed Date: 
*/ 

ALTER PROCEDURE [dbo].[Acc_DynamicCustSetting3rd_09]
AS
BEGIN
	SET NOCOUNT ON
	
	IF dbo.f_CheckRepTable('CustInfo') = 0 RETURN
	IF dbo.f_CheckRepTable('Dep_CustBetSetting_Agent') = 0 RETURN
	IF dbo.f_CheckRepTable('Dep_CustBetSetting_Member') = 0 RETURN


	DECLARE @msgDone NVARCHAR(200) = 'Done for sporttype %d, bettype %d.'
	
	DECLARE @GameTypeIDRef INT = 1
		, @SportType SMALLINT = 220
		, @Bettype SMALLINT = 1021
	
	
	CREATE TABLE #tblCust_SMA (custid INT,SportType SMALLINT, Bettype SMALLINT,  minbet MONEY, maxbet MONEY, maxpermatch MONEY)				
	CREATE TABLE #tblCust_member (custid INT,SportType SMALLINT, Bettype SMALLINT,  minbet MONEY, maxbet MONEY, maxpermatch MONEY)
	CREATE TABLE #tblCustNew (custid INT PRIMARY KEY,SportType SMALLINT, Bettype SMALLINT,  minbet MONEY, maxbet MONEY, maxpermatch MONEY)	
	CREATE TABLE #tblCustOld (custid INT PRIMARY KEY,SportType SMALLINT, Bettype SMALLINT,  minbet MONEY, maxbet MONEY, maxpermatch MONEY)
	CREATE TABLE #Super_adjust (custid INT PRIMARY KEY)
	
	INSERT INTO #Super_adjust (custid)
	SELECT CS.custid
	FROM dbo.Dep_CustSuper CS WITH (NOLOCK)
	WHERE CS.site IN ('12Bet', '9bet', 'ABB688', 'Ae88', 'Allbetclub', 'Aoncash', 'Aragon88', 'BE7', 'BetStar', 'Bolanation', 'GooBet', 'iBET', 'Indowin', 'IONclub', 'ITCBet', 'M8bola', 'Macaubet', 'NBCbet', 'Newhonbet', 'Q8bola', 'sbcbet', 'Taipanbet', 'Unobet', 'Uwoniwin', 'Leon' )
	--SMA Level
	-------------------------------------DATA PREPARATION --------------------------------------------	
	INSERT INTO #tblCust_SMA (custid,SportType,Bettype, minbet, maxbet, maxpermatch)			
	SELECT CBS.CustID,CBS.SportType,CBS.BetType, CS.minbet, CS.maxbet, cs.MaxPerGameType
	FROM dbo.Dep_CustBetSetting_Agent CBS WITH (NOLOCK) 
		INNER JOIN dbo.custInfo C WITH (NOLOCK) ON C.custid = CBS.CustID
		INNER JOIN dbo.CustGameType CS WITH(NOLOCK) ON CBS.CustID = CS.custid AND CS.GameTypeID = @GameTypeIDRef
	WHERE (cbs.MinBet <> cs.minbet OR cbs.MaxBet <> cs.maxbet OR cbs.MaxPerMatch <> cs.MaxPerGameType)
		AND CBS.SportType = @SportType AND BetType = @Bettype
		AND EXISTS (SELECT 1 FROM #Super_adjust WITH (NOLOCK) WHERE CustID = C.srecommend)

	--Adjust for SMA Level
	UPDATE cbs
	SET minbet = CI.minbet
		, maxbet = CI.maxbet
		, maxpermatch = CI.maxpermatch
	FROM dbo.Dep_CustBetSetting_Agent CBS WITH (ROWLOCK,UPDLOCK) 
		INNER JOIN #tblCust_SMA CI WITH (NOLOCK) ON CI.custid = CBS.CustID AND CBS.SportType = CI.SportType AND CBS.BetType = CI.Bettype

	--Member Level
		
	DECLARE  @Threshold INT = 1000000
	DECLARE @MaxCustID INT = 0, @MinCustID INT = 0		

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

		SELECT @MaxCustID = MAX(CustID) FROM #tblCustNew WITH (NOLOCK)

		INSERT INTO #tblCustOld (custid,SportType,Bettype, minbet, maxbet, maxpermatch)			
		SELECT DISTINCT cs.CustID,@SportType,@Bettype, cs.minbet, cs.maxbet, cs.MaxPerGameType
		FROM dbo.CustGameType cs WITH (NOLOCK) 
			INNER JOIN dbo.custInfo c WITH (NOLOCK) ON c.custid = cs.CustID 
		WHERE cs.GameTypeID = @GameTypeIDRef
			AND EXISTS (SELECT 1 FROM #Super_adjust WITH (NOLOCK) WHERE CustID = C.srecommend)
			AND cs.CustID > @MinCustID AND cs.custid <= @MaxCustID
			
		ORDER BY cs.custid

		INSERT INTO #tblCust_member (custid,SportType,Bettype, minbet, maxbet, maxpermatch )			
		SELECT co.CustID,co.SportType,co.BetType, co.minbet, co.maxbet, co.maxpermatch
		FROM #tblCustNew cn WITH (NOLOCK)
			INNER JOIN #tblCustOld co WITH (NOLOCK) ON co.custid = cn.custid AND co.SportType = cn.SportType AND cn.Bettype = co.Bettype
		WHERE (cn.MinBet <> co.minbet OR cn.MaxBet <> co.maxbet OR cn.MaxPerMatch <> co.maxpermatch)
	
		--Adjust for member Level
		UPDATE cs
		SET minbet = CI.minbet
			, maxbet = CI.maxbet
			, maxpermatch = CI.maxpermatch
		FROM dbo.Dep_CustBetSetting_Member cs WITH (ROWLOCK,UPDLOCK) 
			INNER JOIN #tblCust_member ci WITH (NOLOCK) ON ci.custid = cs.CustID AND cs.SportType = ci.SportType AND cs.BetType = ci.Bettype
		WHERE cs.SportType = @SportType 

		SELECT @MinCustID = @MaxCustID			

		RAISERROR(@msgDone, 0, 1, @SportType, @BetType)  WITH NOWAIT

		TRUNCATE TABLE #tblCust_member
		TRUNCATE TABLE #tblCustNew
		TRUNCATE TABLE #tblCustOld
		
	END

	DROP TABLE #tblCust_SMA
	DROP TABLE #Super_adjust
	DROP TABLE #tblCustNew
	DROP TABLE #tblCustOld
	DROP TABLE #tblCust_member
	
END
GO
------------ run on DBCUST/CustDB ----------------------
EXEC Acc_DynamicCustSetting3rd_09




