/*<info serverAlias="DBCUST-CUSTDB" executers="" viewers="" isFunction="0" isNested="1"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_DynamicCustSetting_02]
	 @CustID				INT
	,@BetLimit				VARCHAR(MAX) =''
	,@SettingType			SMALLINT = 2
	,@Mode					VARCHAR(20)= 'BetLimit'
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
		- 20220301@Eden: Deposit - Sportsbook - Revise customer settings [Redmine: #167898]
		- 20220802@Tacy: Insert history of member bet setting for Number Game [RedmineID: 170739]
		- 20240705@Johnson: Apply In-house Replication for Deposit Customer Setting [redmine:#207025]
		- 20240925@Johnson: Add DBKLC1 [redmine: #207025]
	Param's Explanation:
	-- @SettingType : 2 Bet Limit , 11  New Bet limit
*/
BEGIN
	IF @@SERVERNAME NOT IN ('DBKLC1','DBCUST','DBSPARE','SITDBCUST','TESTDBCUST','DB-60\DEVDBCUST')
		RETURN;
		
	SET NOCOUNT ON
	DECLARE @CustList	VARCHAR(MAX),
			@ErrMsg		NVARCHAR(MAX)

	CREATE TABLE #tempMem(ID INT IDENTITY (1,1) PRIMARY KEY,
						CustID			INT ,
						SportType		INT ,
						BetType			INT,
						MinBet			MONEY,
						MaxBet			MONEY,
						MaxPerMatch		MONEY,
						MaxPerNumber		MONEY,
						MaxPayoutPerMatch	MONEY
						)
	CREATE NONCLUSTERED INDEX IDX_tempMem ON #tempMem(CustID,Sporttype,bettype)
	DECLARE @StartRow	INT, 
			@MaxRow		INT,
			@Threshold	INT, 
			@StopRow INT			
	SET @StartRow=1
	SET @Threshold=2000

	DECLARE @NewBetLimitTbl TABLE (
		SportType			INT
		, BetType			INT
		, MinBet			MONEY
		, MaxBet			MONEY
		, MaxPerMatch		MONEY
		, MaxPerNumber		MONEY
		, MaxPayoutPerMatch	MONEY
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

	IF @Mode = 'BetLimit'
	BEGIN		
		EXEC sp_xml_preparedocument @iDoc OUTPUT
			, @BetLimit

		IF @SettingType = 2
		BEGIN
			INSERT @NewBetLimitTbl(SportType,BetType,MinBet,MaxBet,MaxPerMatch)
			SELECT SportType,BetType,MinBet,MaxBet,MaxPerMatch
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
					DELETE FROM @History_BetLimitTbl
					
					UPDATE main
					SET main.minbet			= tmp.MinBet
						, main.maxbet		= tmp.MaxBet
						, main.maxpermatch	= tmp.MaxperMatch
						, main.RepUpdateTime = dbo.f_GetDateTime2()
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

					DELETE t 
					FROM #tempMem t 
					INNER JOIN Dep_CustBetSetting_Member cs on t.custid = cs.custid AND cs.sporttype = t.Sporttype AND cs.bettype = t.Bettype
						WHERE ID >= @StartRow AND ID <= @StopRow

					INSERT INTO dbo.Dep_CustBetSetting_Member(CustID,SportType,BetType,MinBet,MaxBet,MaxPerMatch,RepUpdateTime)
					SELECT CustID,SportType,BetType,MinBet,MaxBet,MaxPerMatch,dbo.f_GetDateTime2()
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
					DELETE FROM @History_BetLimitTbl
					
					UPDATE main
					SET main.minbet			= tmp.MinBet
						, main.maxbet		= tmp.MaxBet
						, main.RepUpdateTime = dbo.f_GetDateTime2()
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
					
					DELETE t 
					FROM #tempMem t 
					INNER JOIN Dep_CustBetSetting_Member cs on t.custid = cs.custid AND cs.sporttype = t.Sporttype AND cs.bettype = t.Bettype
						WHERE ID >= @StartRow AND ID <= @StopRow

					INSERT INTO dbo.Dep_CustBetSetting_Member(CustID,SportType,BetType,MinBet,MaxBet,RepUpdateTime)
					SELECT CustID,SportType,BetType,MinBet,MaxBet,dbo.f_GetDateTime2()
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
	END
	ELSE IF @Mode = 'GameBetLimit'
	BEGIN
		EXEC sp_xml_preparedocument @iDoc OUTPUT
			, @BetLimit

		INSERT @NewBetLimitTbl(SportType,BetType,MinBet,MaxBet,MaxPerMatch,MaxPerNumber,MaxPayoutPerMatch)
		SELECT SportType,BetType,MinBet,MaxBet,MaxPerMatch,MaxPerNumber,MaxPayoutPerMatch
		FROM OPENXML(@iDoc, '/ROOT/BetLimit', 1) WITH (
				SportType		INT
				, BetType		INT
				, MinBet		MONEY
				, MaxBet		MONEY
				, MaxPerMatch	MONEY
				, MaxPerNumber		MONEY
				, MaxPayoutPerMatch	MONEY
				)

		EXEC sp_xml_removedocument @iDoc

		INSERT INTO #tempMem(CustID,SportType,BetType,MinBet,MaxBet,MaxPerMatch,MaxPerNumber,MaxPayoutPerMatch)
		SELECT c.CustID,s.SportType,s.BetType,s.MinBet,s.MaxBet,s.MaxPerMatch,s.MaxPerNumber,s.MaxPayoutPerMatch
		FROM Customer c WITH(NOLOCK)				
			CROSS APPLY @NewBetLimitTbl s
			LEFT JOIN Dep_CustSettingMode m WITH(NOLOCK) ON c.custid = m.CustID
		WHERE c.recommend=@CustID 
			AND c.roleid =1	
			AND ISNULL(m.IsGroupedBetLimit,0) = 0

		IF EXISTS(SELECT 1 FROM #tempMem)
		BEGIN
			
			SET @MaxRow = (SELECT MAX(ID) FROM #tempMem)
			
			IF	@Threshold >= @MaxRow
			SET	@Threshold = @MaxRow
			
			SET @StopRow = @Threshold

			WHILE (0 = 0)
			BEGIN	
				DELETE FROM @History_BetLimitTbl
				
				UPDATE main
				SET main.minbet			= tmp.MinBet
					, main.maxbet		= tmp.MaxBet
					, main.maxpermatch	= tmp.MaxperMatch
					, main.MaxPerNumber		= tmp.MaxPerNumber
					, main.MaxPayoutPerMatch	= tmp.MaxPayoutPerMatch
					, main.RepUpdateTime = dbo.f_GetDateTime2()
				OUTPUT deleted.CustID, deleted.SportType, deleted.BetType, deleted.MaxBet, deleted.MaxPerMatch, GETDATE()
					INTO @History_BetLimitTbl
				FROM dbo.Dep_CustBetSettingGame_Member main WITH(ROWLOCK)
					INNER JOIN #tempMem tmp	ON main.CustID=tmp.CustID AND tmp.SportType = main.sporttype AND tmp.BetType = main.bettype
				WHERE ID >= @StartRow AND ID <= @StopRow
					AND	(main.minbet		<> tmp.MinBet
						OR main.maxbet		<> tmp.MaxBet
						OR main.maxpermatch <> tmp.MaxperMatch
						OR main.MaxPerNumber <> tmp.MaxPerNumber
						OR main.MaxPayoutPerMatch <> tmp.MaxPayoutPerMatch
						)

				--update MinBet only and be not NG
				DELETE FROM @History_BetLimitTbl WHERE SportType<>161

				DELETE old
				FROM @History_BetLimitTbl old
					INNER JOIN #tempMem new ON new.CustID=old.CustID
											AND new.SportType=old.SportType
											AND new.BetType=old.BetType
											AND new.MaxBet=old.MaxBet
											AND new.MaxPerMatch=old.MaxPerMatch

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
				
				DELETE t 
				FROM #tempMem t 
				INNER JOIN Dep_CustBetSettingGame_Member cs on t.custid = cs.custid AND cs.sporttype = t.Sporttype AND cs.bettype = t.Bettype
					WHERE ID >= @StartRow AND ID <= @StopRow

				INSERT INTO dbo.Dep_CustBetSettingGame_Member(CustID,SportType,BetType,MinBet,MaxBet,MaxPerMatch,MaxPerNumber,MaxPayoutPerMatch,RepUpdateTime)
				SELECT CustID,SportType,BetType,MinBet,MaxBet,MaxPerMatch,MaxPerNumber,MaxPayoutPerMatch,dbo.f_GetDateTime2()
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
	
END

GO
