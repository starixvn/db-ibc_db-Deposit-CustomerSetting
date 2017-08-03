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
	
	DECLARE @msgDone NVARCHAR(200) = 'Done for sporttype %d, bettype %d.'

	CREATE TABLE #SportTypeList (SportType SMALLINT, Bettype SMALLINT, IsFinished BIT)	
	INSERT INTO #SportTypeList 
	VALUES (190, 2701, 0), (191, 2701, 0), (199, 2799, 0)

	CREATE TABLE #tblCust_SMA (custid INT,SportType SMALLINT, Bettype SMALLINT,  minbet MONEY, maxbet MONEY, maxpermatch MONEY)				
	CREATE TABLE #tblCust_member (custid INT,SportType SMALLINT, Bettype SMALLINT,  minbet MONEY, maxbet MONEY, maxpermatch MONEY)
	CREATE TABLE #tblCustNew (custid INT PRIMARY KEY,SportType SMALLINT, Bettype SMALLINT,  minbet MONEY, maxbet MONEY, maxpermatch MONEY)	
	CREATE TABLE #tblCustOld (custid INT PRIMARY KEY,SportType SMALLINT, Bettype SMALLINT,  minbet MONEY, maxbet MONEY, maxpermatch MONEY)

	--SMA Level
	-------------------------------------DATA PREPARATION --------------------------------------------	
	INSERT INTO #tblCust_SMA (custid,SportType,Bettype, minbet, maxbet, maxpermatch)			
	SELECT CBS.CustID,CBS.SportType,CBS.BetType, CS.minbet, CS.maxbet, c.maxpermatch180
	FROM Dep_CustBetSetting_Agent CBS WITH (NOLOCK) 
		INNER JOIN custInfo C WITH (NOLOCK) ON C.custid = CBS.CustID
		INNER JOIN Dep_CustSetting3rd CS WITH(NOLOCK) ON CBS.CustID = CS.custid AND CBS.SportType = CS.sporttype AND CBS.BetType = CS.bettype
	WHERE (cbs.MinBet <> cs.minbet OR cbs.MaxBet <> cs.maxbet OR cbs.MaxPerMatch <> c.maxpermatch180)
		AND CBS.SportType IN (190,191,199)

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
			WHERE cs.SportType = @SportType AND cs.BetType = @Bettype
				AND cs.CustID > @MinCustID
			ORDER BY cs.custid

			IF @@ROWCOUNT = 0 
				BREAK

			SELECT @MaxCustID = MAX(CustID) FROM #tblCustNew

			INSERT INTO #tblCustOld (custid,SportType,Bettype, minbet, maxbet, maxpermatch)			
			SELECT DISTINCT cs.CustID,cs.SportType,cs.BetType, CS.minbet, CS.maxbet, c.maxpermatch180
			FROM Dep_CustSetting3rd cs WITH (NOLOCK) 
				INNER JOIN custInfo c WITH (NOLOCK) ON c.custid = cs.CustID 
			WHERE cs.SportType = @SportType AND cs.BetType = @Bettype
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
	
END
GO






