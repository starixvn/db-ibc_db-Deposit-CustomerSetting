/*<info serverAlias="DBCUST-CUSTDB" executers="" viewers="vnteam" isFunction="0" isNested="1"></info>*/
USE CustDB
GO

ALTER PROCEDURE [dbo].[Acc_Dep_DynamicCustSetting_02]
 @CustID				INT
,@BetLimit				VARCHAR(MAX) =''
,@SettingType			SMALLINT = 2
AS
/*
	Created: 20170928@Winnie
	Task : Insert Settings Into DCS Structure - Redmine: 82346
	DB:  DBCUST/CustDB
	Original:
	Revision
		Revision
		- 20170928@Winnie: Insert Settings Into DCS Structure - Redmine: 82346
		- 20180719@Winnie: Licensee DCS setting - Support insert/edit setting for sub_licensee - Redmine: 88700	
		- 20220218@Winfred: LG VS3  - Licensee DCS setting for new BetLimit  [Redmine: 168395]	
		- 20220517@Tacy: Insert history of member bet setting [RedmineID: 170739]

	Param's Explanation:
	-- @SettingType : 2 Bet Limit , 11  New Bet limit
*/
BEGIN
	IF(dbo.f_CheckRepTable('Dep_CustBetSetting_Agent') = 0
		OR dbo.f_CheckRepTable('Dep_CustBetSetting_Member') = 0	
		OR dbo.f_CheckRepTable('Customer') = 0	
	   )
		RETURN
		
	SET NOCOUNT ON

	DECLARE @CustList	VARCHAR(MAX),
			@ErrMsg		NVARCHAR(MAX)

	CREATE TABLE #tempMem(ID INT IDENTITY (1,1) PRIMARY KEY,
						CustID			INT ,
						SportType		INT ,
						BetType			INT,
						MinBet			MONEY,
						MaxBet			MONEY,
						MaxPerMatch		MONEY)
		
	CREATE NONCLUSTERED INDEX IDX_tempMem ON #tempMem(CustID,Sporttype,bettype)
		
	DECLARE @StartRow	INT, 
			@MaxRow		INT,
			@Threshold	INT, 
			@StopRow INT			
		
	SET @StartRow=1
	SET @Threshold=3000

	DECLARE @NewBetLimitTbl TABLE (
		SportType			INT
		, BetType			INT
		, MinBet			MONEY
		, MaxBet			MONEY
		, MaxPerMatch		MONEY
		)

	DECLARE @History_BetLimitTbl TABLE (
		CustID				INT
		, SportType			INT
		, BetType			INT
		, MaxBet			MONEY
		, MaxPerMatch		MONEY
		, UpdateTime		DATETIME
		)

	--Parse XML	
	DECLARE @iDoc INT
	EXEC sp_xml_preparedocument @iDoc OUTPUT
		, @BetLimit

	IF @SettingType = 2
	BEGIN
		INSERT @NewBetLimitTbl
		SELECT *
		FROM OPENXML(@iDoc, '/ROOT/BetLimit', 1) WITH (
				SportType		INT
				, BetType		INT
				, MinBet		MONEY
				, MaxBet		MONEY
				, MaxPerMatch	MONEY
				)

		EXEC sp_xml_removedocument @iDoc

		INSERT INTO #tempMem(CustID,SportType,BetType,MinBet,MaxBet,MaxPerMatch)
		SELECT c.CustID,s.SportType,s.BetType,s.MinBet,s.MaxBet,s.MaxPerMatch
		FROM Customer c WITH(NOLOCK)				
			CROSS APPLY @NewBetLimitTbl s
		WHERE c.recommend=@CustID AND c.roleid =1	

		IF EXISTS(SELECT 1 FROM #tempMem)
		BEGIN
				
			SET @MaxRow = (SELECT MAX(ID) FROM #tempMem)
				
			IF	@Threshold >= @MaxRow
			SET	@Threshold = @MaxRow
				
			SET @StopRow = @Threshold

			WHILE (0 = 0)
			BEGIN	
					
				UPDATE main
				SET main.minbet			= tmp.MinBet
					, main.maxbet		= tmp.MaxBet
					, main.maxpermatch	= tmp.MaxperMatch
				OUTPUT deleted.CustID, deleted.SportType, deleted.BetType, deleted.MaxBet, deleted.MaxPerMatch, GETDATE()
					INTO @History_BetLimitTbl
				FROM dbo.Dep_CustBetSetting_Member main WITH(ROWLOCK)
					INNER JOIN #tempMem tmp	ON main.CustID=tmp.CustID AND tmp.SportType = main.sporttype AND tmp.BetType = main.bettype
				WHERE ID >= @StartRow AND ID <= @StopRow
					AND	(main.minbet		<> tmp.MinBet
						OR main.maxbet		<> tmp.MaxBet
						OR main.maxpermatch <> tmp.MaxperMatch
						)

				--update MinBet only
				DELETE old
				FROM @History_BetLimitTbl old
					INNER JOIN #tempMem new ON new.CustID=old.CustID
											AND new.SportType=old.SportType
											AND new.BetType=old.BetType
											AND new.MaxBet=old.MaxBet
											AND new.MaxPerMatch=old.MaxPerMatch

				DELETE t 
				FROM #tempMem t 
				INNER JOIN Dep_CustBetSetting_Member cs on t.custid = cs.custid AND cs.sporttype = t.Sporttype AND cs.bettype = t.Bettype
					WHERE ID >= @StartRow AND ID <= @StopRow

				INSERT INTO dbo.Dep_CustBetSetting_Member(CustID,SportType,BetType,MinBet,MaxBet,MaxPerMatch)
				SELECT CustID,SportType,BetType,MinBet,MaxBet,MaxPerMatch
				FROM #tempMem t
				WHERE ID >= @StartRow AND ID <= @StopRow
		
				IF	@StopRow = @MaxRow 
					BREAK
							
				SET	@StartRow = @StopRow + 1
							
				SET	@StopRow = 1 + @StopRow + @Threshold
							
				IF	@StopRow >= @MaxRow
					SET	@StopRow = @MaxRow
											
			END;
		END;	
	END
	ELSE IF @SettingType = 11
	BEGIN
		INSERT @NewBetLimitTbl(SportType,BetType,MinBet,MaxBet)
		SELECT SportType,BetType,MinBet,MaxBet
		FROM OPENXML(@iDoc, '/ROOT/BetLimit', 1) WITH (
				SportType		INT
				, BetType		INT
				, MinBet		MONEY
				, MaxBet		MONEY
				)

		EXEC sp_xml_removedocument @iDoc

		INSERT INTO #tempMem(CustID,SportType,BetType,MinBet,MaxBet)
		SELECT c.CustID,s.SportType,s.BetType,s.MinBet,s.MaxBet
		FROM Customer c WITH(NOLOCK)				
			CROSS APPLY @NewBetLimitTbl s
		WHERE c.recommend=@CustID AND c.roleid =1	

		IF EXISTS(SELECT 1 FROM #tempMem)
		BEGIN
				
			SET @MaxRow = (SELECT MAX(ID) FROM #tempMem)
				
			IF	@Threshold >= @MaxRow
			SET	@Threshold = @MaxRow
				
			SET @StopRow = @Threshold

			WHILE (0 = 0)
			BEGIN	
					
				UPDATE main
				SET main.minbet			= tmp.MinBet
					, main.maxbet		= tmp.MaxBet
				OUTPUT deleted.CustID, deleted.SportType, deleted.BetType, deleted.MaxBet, deleted.MaxPerMatch, GETDATE()
					INTO @History_BetLimitTbl
				FROM dbo.Dep_CustBetSetting_Member main WITH(ROWLOCK)
					INNER JOIN #tempMem tmp	ON main.CustID=tmp.CustID AND tmp.SportType = main.sporttype AND tmp.BetType = main.bettype
				WHERE ID >= @StartRow AND ID <= @StopRow
					AND	(main.minbet		<> tmp.MinBet
						OR main.maxbet		<> tmp.MaxBet
						)
				
				--update MinBet only
				DELETE old
				FROM @History_BetLimitTbl old
					INNER JOIN #tempMem new ON new.CustID=old.CustID
											AND new.SportType=old.SportType
											AND new.BetType=old.BetType
											AND new.MaxBet=old.MaxBet
											AND new.MaxPerMatch=old.MaxPerMatch

				DELETE t 
				FROM #tempMem t 
				INNER JOIN Dep_CustBetSetting_Member cs on t.custid = cs.custid AND cs.sporttype = t.Sporttype AND cs.bettype = t.Bettype
					WHERE ID >= @StartRow AND ID <= @StopRow

				INSERT INTO dbo.Dep_CustBetSetting_Member(CustID,SportType,BetType,MinBet,MaxBet)
				SELECT CustID,SportType,BetType,MinBet,MaxBet
				FROM #tempMem t
				WHERE ID >= @StartRow AND ID <= @StopRow
		
				IF	@StopRow = @MaxRow 
					BREAK
							
				SET	@StartRow = @StopRow + 1
							
				SET	@StopRow = 1 + @StopRow + @Threshold
							
				IF	@StopRow >= @MaxRow
					SET	@StopRow = @MaxRow
											
			END;
		END;	
	END

	--Insert history bet setting
	IF EXISTS (SELECT 1 FROM @History_BetLimitTbl)
	BEGIN
		SET @CustList = (SELECT CustID		AS '@CustID',
								SportType	AS '@SportType',
								BetType		AS '@BetType',
								MaxBet		AS '@MaxBet',
								MaxPerMatch	AS '@MaxPerMatch',
								'NULL'		AS '@StakeLevelList',
								UpdateTime	AS '@UpdateTime'
						 FROM @History_BetLimitTbl
						 FOR XML PATH ('r'), ROOT ('root')
						 )

		EXECUTE Acc_Dep_DynamicCustSetting_07 @CustList=@CustList, @ErrMsg=@ErrMsg OUTPUT

		IF @ErrMsg<>''
			RETURN
	END
END
GO