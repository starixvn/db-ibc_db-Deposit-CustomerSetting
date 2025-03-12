/*<info serverAlias="DBCUST-CUSTDB" executers="" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].Acc_Dep_DynamicCustSetting_08
	 @srecommend INT
	,@MaxCustID INT
	,@Target VARCHAR(20)
	,@XMLConfig VARCHAR(MAX) = NULL
	,@StepID TINYINT = 0
	,@BetSettingXML VARCHAR(MAX)	
AS
/*
	Created: 20220913@Eden
	Task : execrep sp to initial setting on all replication servers( pub custinfo)
	DB: DBCUST/CUSTDB
	Original:

	Revisions:  
	- 20220913@Eden: Flexible Initializing Deposit Customer Setting [RedmineID: #169648]
	- 20240916@Johnson: Apply In-house Replication for Customer Setting [redmine:#207025]
	- 20250303@Johnson: remove f_CheckRepTable for customer/custinfo [RedmineID: #212684]
	Parameter Definition
		StepID = :
			1: Delete existing customer setting
			2: Insert customer setting
			...
	
	*/
BEGIN
	SET NOCOUNT ON;
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME IN ('DBCUST','SITDBCUST','TESTDBCUST','DB-60\DevDBcust','DBSPARE','DBBACKUP2')) RETURN -- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME NOT IN ('DBCUST','SITDBCUST','TESTDBCUST','DB-60\DevDBcust','DBSPARE','DBBACKUP2')) RETURN -- run at dbcust only
	
	IF OBJECT_ID('CustInfo') IS NULL RETURN
	IF OBJECT_ID('Customer') IS NULL RETURN 
	IF OBJECT_ID('Dep_CustPTSetting_Agent') IS NULL RETURN
	IF OBJECT_ID('Dep_CustPTGroupSetting_Member') IS NULL RETURN
	IF OBJECT_ID('Dep_CustPTSetting_Member') IS NULL RETURN
	IF OBJECT_ID('Dep_CustBetSetting_Agent') IS NULL RETURN
	IF OBJECT_ID('Dep_CustBetSetting_Member') IS NULL RETURN
	IF OBJECT_ID('Dep_CustBetSettingGame_Agent') IS NULL RETURN
	IF OBJECT_ID('Dep_CustBetSettingGameGroup_Member') IS NULL RETURN
	IF OBJECT_ID('Dep_CustBetSettingGame_Member') IS NULL RETURN
	IF OBJECT_ID('Dep_CustStakeLevel_Agent') IS NULL RETURN
	IF OBJECT_ID('Dep_CustStakeLevel_Member') IS NULL RETURN
	IF OBJECT_ID('Dep_CustProductStatus') IS NULL RETURN
	IF OBJECT_ID('Dep_ProductSetting') IS NULL RETURN
	IF OBJECT_ID('Dep_LicenseeProductSetting') IS NULL RETURN
	IF OBJECT_ID('Dep_ProductStatusProfile') IS NULL RETURN
	
	CREATE TABLE #TempConfig(
		[SportType] [smallint],
		[BetType] [smallint],
		[IsLive] [bit],
		[SettingType] [tinyint],
		[IsDefault] [bit],
		[DefaultValueSuper] [decimal](11,8),
		[DefaultValueMaster] [decimal](11,8),
		[DefaultValueAgent] [decimal](11,8),
		[DefaultValueMember] [decimal](11,8),
		[SpecialRequirement] [varchar](MAX),
		[SettingName] [varchar](30),
		[bitmapOrder] [tinyint],
		[IsFinished] [bit] default 0,
		[IsApplyBA] [bit]
	)

	CREATE TABLE #TempBetSetting(
		 SportType			smallint
		,BetType			smallint
		,MinBet				money
		,MaxBet				money
		,MaxPerMatch		money
		,MaxPerNumber		money
		,MaxPayoutPerMatch	money
		,Currency			INT
	)

	DECLARE @Site NVARCHAR(50), @Currency INT, @SiteID INT, @IsBA_PTLogic BIT
	SELECT @Site = site, @Currency = currency FROM Customer WITH(NOLOCK) WHERE  custid = @srecommend
	SELECT @SiteID = siteid FROM  site WITH(NOLOCK) WHERE site = @Site

	DECLARE @Bitmap0 BINARY(32) = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
	
	DECLARE @DocHandler INT	
	IF ISNULL(@XMLConfig,'') <> ''
	BEGIN
		-- For read xml					
		EXEC sp_xml_preparedocument @DocHandler OUTPUT, @XMLConfig
		INSERT INTO #TempConfig (
			 SportType
			,BetType
			,IsLive
			,SettingType
			,IsDefault
			,DefaultValueSuper
			,DefaultValueMaster
			,DefaultValueAgent
			,DefaultValueMember
			,SpecialRequirement
			,SettingName
		)
		SELECT Data.SportType
			,Data.BetType
			,Data.IsLive
			,Data.SettingType
			,Data.IsDefault
			,Data.DefaultValueSuper
			,Data.DefaultValueMaster
			,Data.DefaultValueAgent
			,Data.DefaultValueMember
			,Data.SpecialRequirement
			,Data.SettingName
		FROM OPENXML (@DocHandler, '/ROOT/R',1) 
		WITH (
			[SportType] [smallint],
			[BetType] [smallint],
			[IsLive] [bit],
			[SettingType] [tinyint],
			[IsDefault] [bit],
			[DefaultValueSuper] [decimal](11,8),
			[DefaultValueMaster] [decimal](11,8),
			[DefaultValueAgent] [decimal](11,8),
			[DefaultValueMember] [decimal](11,8),
			[SpecialRequirement] [varchar](MAX),
			[SettingName] [varchar](30)
		) AS Data

		EXEC sp_xml_removedocument @DocHandler
		-- end read xml	
	END	

	IF ISNULL(@BetSettingXML,'') <> ''
	BEGIN
		-- For read xml					
		EXEC sp_xml_preparedocument @DocHandler OUTPUT, @BetSettingXML
		INSERT INTO #TempBetSetting (
			 SportType			
			,BetType			
			,MinBet				
			,MaxBet				
			,MaxPerMatch		
			,MaxPerNumber		
			,MaxPayoutPerMatch	
			,Currency			
		)
		SELECT Data.SportType			
			,Data.BetType			
			,Data.MinBet				
			,Data.MaxBet				
			,Data.MaxPerMatch		
			,Data.MaxPerNumber		
			,Data.MaxPayoutPerMatch	
			,Data.Currency				
		FROM OPENXML (@DocHandler, '/BS/R',1) 
		WITH (
			 SportType	smallint
			,BetType	smallint
			,MinBet	money
			,MaxBet	money
			,MaxPerMatch	money
			,MaxPerNumber	money
			,MaxPayoutPerMatch	money
			,Currency INT
		) AS Data
		WHERE Data.Currency = @Currency

		EXEC sp_xml_removedocument @DocHandler
		-- end read xml	
	END	

	UPDATE t
	SET t.SettingName = CASE WHEN t.SettingType IN (10,12) THEN 'Bet Setting Game' 
							WHEN t.SettingType IN (8) THEN 'Stake Level Group'
						ELSE t.SettingName END
	FROM #TempConfig t

	--> Update default Values for IsDisabled Status
	UPDATE t
	SET t.DefaultValueSuper = CASE WHEN t.DefaultValueSuper = 1 THEN 0 ELSE 1 END,
		t.DefaultValueMaster = CASE WHEN t.DefaultValueMaster = 1 THEN 0 ELSE 1 END,
		t.DefaultValueAgent = CASE WHEN t.DefaultValueAgent = 1 THEN 0 ELSE 1 END,
		t.DefaultValueMember = CASE WHEN t.DefaultValueMember = 1 THEN 0 ELSE 1 END
	FROM #TempConfig t
	WHERE t.SettingName = 'Product Status'

	--> Get bitmapOrder
	UPDATE t
	SET t.bitmapOrder = p.bitmapOrder
	FROM #TempConfig t
		INNER JOIN Dep_ProductStatusProfile p WITH(NOLOCK) 
			ON t.SportType = p.Sporttype
			AND t.BetType = p.Bettype
	WHERE t.SettingName = 'Product Status'

	--> Get IsApplyBA
	UPDATE t
	SET t.IsApplyBA = p.IsApplyBA
	FROM #TempConfig t
		INNER JOIN Dep_ProductSettingDetail p WITH(NOLOCK) 
			ON t.SportType = p.Sporttype
			AND t.BetType = p.Bettype
			AND t.IsLive = p.IsLive


	IF EXISTS( SELECT 1 FROM #TempConfig WHERE IsApplyBA = 1 AND SettingName = 'Position Taking')
		SET @IsBA_PTLogic = 1
	ELSE
		SET @IsBA_PTLogic = 0

	--> Get ProductID
	DECLARE @ProductID TINYINT
	SELECT TOP(1) @ProductID = d.ProductID 
	FROM #TempConfig t WITH(NOLOCK)
		INNER JOIN Dep_ProductSettingDetail p WITH(NOLOCK) 
			ON t.SportType = p.SportType AND t.BetType = p.BetType
		INNER JOIN Dep_ProductSetting d  WITH(NOLOCK) 
			ON d.ProductSettingID = p.ProductSettingID

	CREATE TABLE #Dummy	(CustID INT PRIMARY KEY)
	CREATE TABLE #MemberTemp(CustID INT PRIMARY KEY, isfinished BIT DEFAULT(0))
	CREATE TABLE #SMATemp(CustID INT PRIMARY KEY, RoleID TINYINT, isfinished BIT DEFAULT(0))
	CREATE TABLE #tmpSTList (Sporttype INT, BettypeID INT, StakeLevelList VARCHAR(500),Min_StakeLevel VARCHAR(10))
	CREATE TABLE #CustTempBatch(CustID INT)
	CREATE TABLE #CustSettingTmp(CustID INT, Sporttype SMALLINT, Bettype SMALLINT,IsLive BIT)
	CREATE TABLE #CustSettingTmpBatch(CustID INT, Sporttype SMALLINT, Bettype SMALLINT,IsLive BIT)
	-----------------------

	INSERT INTO #Dummy(CustID)
	SELECT CustID 
	FROM Customer WITH(NOLOCK) 
	WHERE srecommend = @srecommend
		AND roleid=3 AND (username LIKE '%Acc%' OR username LIKE '%LocalBank%' OR username LIKE '%AFF%' OR username LIKE 'AB88'+'CAS%')

	INSERT INTO #MemberTemp(CustID)
	SELECT ci.CustID
	FROM custInfo ci WITH(NOLOCK)
		INNER JOIN customer cu WITH(NOLOCK) ON ci.custid = cu.custid
	WHERE ci.srecommend = @srecommend
		AND ci.roleid = 1 
		AND ci.Enabled=1
		AND ci.mrecommend NOT IN (SELECT custid FROM #Dummy)
		AND ci.custid <= @MaxCustID

	INSERT INTO #SMATemp(CustID,RoleID)
	SELECT ci.CustID,ci.roleid
	FROM custInfo ci WITH(NOLOCK)
		INNER JOIN customer cu WITH(NOLOCK) ON ci.custid = cu.custid
	WHERE ci.srecommend = @srecommend
		AND ci.roleid IN (2,3,4) 
		AND ci.Enabled=1
		AND ci.mrecommend NOT IN (SELECT custid FROM #Dummy)
		AND ci.custid <= @MaxCustID

	DECLARE @CurrentDTS DATETIME = GETDATE()
	DECLARE @MaxBatch INT = 5000
	DECLARE @BatchNum INT = 5000
	DECLARE @BitMapOrder TINYINT
	DECLARE @IsDisabled BIT
	
	IF @StepID = 1 --Delete existing customer setting
	BEGIN
		IF EXISTS( SELECT 1 FROM #TempConfig WHERE SettingName = 'Position Taking')
		BEGIN
			DELETE dl
			FROM Dep_ProductSetting d WITH(NOLOCK)
				INNER JOIN Dep_LicenseeProductSetting dl WITH(ROWLOCK,UPDLOCK) 
					ON d.ProductSettingID = dl.ProductSettingID
				INNER JOIN #TempConfig cf 
					ON d.SettingType = cf.SettingType 
					AND cf.SettingName = 'Position Taking' 
			WHERE d.ProductID = @ProductID
				AND dl.CustID = @srecommend

			INSERT INTO #CustSettingTmp(CustID,Sporttype,Bettype,IsLive)
			SELECT c.CustID,c.SportType,c.BetType,c.IsLive
			FROM Dep_CustPTSetting_Agent c WITH(NOLOCK)
				INNER JOIN #SMATemp t ON c.CustID = t.CustID
				INNER JOIN #TempConfig tc 
					ON c.SportType = tc.SportType 
					AND c.BetType = tc.BetType
					AND c.IsLive = tc.IsLive
			WHERE tc.SettingName = 'Position Taking'

			DELETE s
			FROM Dep_CustPTSetting_Agent s WITH(ROWLOCK,UPDLOCK)
				INNER JOIN #CustSettingTmp t 
					ON s.CustID = t.CustID
					AND s.SportType = t.SportType 
					AND s.BetType = t.BetType
					AND s.IsLive = t.IsLive

			DELETE s
			FROM Dep_CustPTGroupSetting_Member s WITH(ROWLOCK,UPDLOCK)
				INNER JOIN #CustSettingTmp t 
					ON s.AgentID = t.CustID
					AND s.SportType = t.SportType 
					AND s.BetType = t.BetType
					AND s.IsLive = t.IsLive

			TRUNCATE TABLE #CustSettingTmp

			INSERT INTO #CustSettingTmp(CustID,Sporttype,Bettype,IsLive)
			SELECT c.CustID,c.SportType,c.BetType,c.IsLive
			FROM Dep_CustPTSetting_Member c WITH(NOLOCK)
				INNER JOIN #MemberTemp t ON c.CustID = t.CustID
				INNER JOIN #TempConfig tc 
					ON c.SportType = tc.SportType 
					AND c.BetType = tc.BetType
					AND c.IsLive = tc.IsLive
			WHERE tc.SettingName = 'Position Taking'

			WHILE 1 = 1
			BEGIN 
				TRUNCATE TABLE #CustSettingTmpBatch

				DELETE TOP(@BatchNum) t
				OUTPUT deleted.custid
					,deleted.Sporttype
					,deleted.Bettype
					,deleted.IsLive 
				INTO #CustSettingTmpBatch(custid,Sporttype,Bettype,IsLive)
				FROM #CustSettingTmp t

				IF @@ROWCOUNT = 0
					BREAK

				DELETE s
				FROM Dep_CustPTSetting_Member s WITH(ROWLOCK,UPDLOCK)
					INNER JOIN #CustSettingTmpBatch t 
						ON s.CustID = t.CustID
						AND s.SportType = t.SportType 
						AND s.BetType = t.BetType
						AND s.IsLive = t.IsLive
			END
		END

		IF EXISTS( SELECT 1 FROM #TempConfig WHERE SettingName = 'Bet Setting')
		BEGIN
			DELETE dl
			FROM Dep_ProductSetting d WITH(NOLOCK)
				INNER JOIN Dep_LicenseeProductSetting dl WITH(ROWLOCK,UPDLOCK) 
					ON d.ProductSettingID = dl.ProductSettingID
				INNER JOIN #TempConfig cf 
					ON d.SettingType = cf.SettingType 
					AND cf.SettingName = 'Bet Setting' 
			WHERE d.ProductID = @ProductID
				AND dl.CustID = @srecommend

			TRUNCATE TABLE #CustSettingTmp

			INSERT INTO #CustSettingTmp(CustID,Sporttype,Bettype)
			SELECT c.CustID,c.SportType,c.BetType
			FROM Dep_CustBetSetting_Agent c WITH(NOLOCK)
				INNER JOIN #SMATemp t ON c.CustID = t.CustID
				INNER JOIN #TempConfig tc 
					ON c.SportType = tc.SportType 
					AND c.BetType = tc.BetType
			WHERE tc.SettingName = 'Bet Setting'

			DELETE s
			FROM Dep_CustBetSetting_Agent s WITH(ROWLOCK,UPDLOCK)
				INNER JOIN #CustSettingTmp t 
					ON s.CustID = t.CustID
					AND s.SportType = t.SportType 
					AND s.BetType = t.BetType

			TRUNCATE TABLE #CustSettingTmp

			INSERT INTO #CustSettingTmp(CustID,Sporttype,Bettype)
			SELECT c.CustID,c.SportType,c.BetType
			FROM Dep_CustBetSetting_Member c WITH(NOLOCK)
				INNER JOIN #MemberTemp t ON c.CustID = t.CustID
				INNER JOIN #TempConfig tc 
					ON c.SportType = tc.SportType 
					AND c.BetType = tc.BetType
			WHERE tc.SettingName = 'Bet Setting'

			WHILE 1 = 1
			BEGIN 
				TRUNCATE TABLE #CustSettingTmpBatch

				DELETE TOP(@BatchNum) t
				OUTPUT deleted.custid
					,deleted.Sporttype
					,deleted.Bettype
					,deleted.IsLive 
				INTO #CustSettingTmpBatch(custid,Sporttype,Bettype,IsLive)
				FROM #CustSettingTmp t

				IF @@ROWCOUNT = 0
					BREAK

				DELETE s
				FROM Dep_CustBetSetting_Member s WITH(ROWLOCK,UPDLOCK)
					INNER JOIN #CustSettingTmpBatch t 
						ON s.CustID = t.CustID
						AND s.SportType = t.SportType 
						AND s.BetType = t.BetType
			END
		END

		IF EXISTS( SELECT 1 FROM #TempConfig WHERE SettingName = 'Bet Setting Game')
		BEGIN
			DELETE dl
			FROM Dep_ProductSetting d WITH(NOLOCK)
				INNER JOIN Dep_LicenseeProductSetting dl WITH(ROWLOCK,UPDLOCK) 
					ON d.ProductSettingID = dl.ProductSettingID
				INNER JOIN #TempConfig cf 
					ON d.SettingType = cf.SettingType 
					AND cf.SettingName = 'Bet Setting Game' 
			WHERE d.ProductID = @ProductID
				AND dl.CustID = @srecommend

			TRUNCATE TABLE #CustSettingTmp

			INSERT INTO #CustSettingTmp(CustID,Sporttype,Bettype)
			SELECT c.CustID,c.SportType,c.BetType
			FROM Dep_CustBetSettingGame_Agent c WITH(NOLOCK)
				INNER JOIN #SMATemp t ON c.CustID = t.CustID
				INNER JOIN #TempConfig tc 
					ON c.SportType = tc.SportType 
					AND c.BetType = tc.BetType
			WHERE tc.SettingName = 'Bet Setting Game'

			DELETE s
			FROM Dep_CustBetSettingGame_Agent s WITH(ROWLOCK,UPDLOCK)
				INNER JOIN #CustSettingTmp t 
					ON s.CustID = t.CustID
					AND s.SportType = t.SportType 
					AND s.BetType = t.BetType

			DELETE s
			FROM Dep_CustBetSettingGameGroup_Member s WITH(ROWLOCK,UPDLOCK)
				INNER JOIN #CustSettingTmp t 
					ON s.AgentID = t.CustID
					AND s.SportType = t.SportType 
					AND s.BetType = t.BetType

			TRUNCATE TABLE #CustSettingTmp

			INSERT INTO #CustSettingTmp(CustID,Sporttype,Bettype)
			SELECT c.CustID,c.SportType,c.BetType
			FROM Dep_CustBetSettingGame_Member c WITH(NOLOCK)
				INNER JOIN #MemberTemp t ON c.CustID = t.CustID
				INNER JOIN #TempConfig tc 
					ON c.SportType = tc.SportType 
					AND c.BetType = tc.BetType
			WHERE tc.SettingName = 'Bet Setting Game'

			WHILE 1 = 1
			BEGIN 
				TRUNCATE TABLE #CustSettingTmpBatch

				DELETE TOP(@BatchNum) t
				OUTPUT deleted.custid
					,deleted.Sporttype
					,deleted.Bettype
					,deleted.IsLive 
				INTO #CustSettingTmpBatch(custid,Sporttype,Bettype,IsLive)
				FROM #CustSettingTmp t

				IF @@ROWCOUNT = 0
					BREAK

				DELETE s
				FROM Dep_CustBetSettingGame_Member s WITH(ROWLOCK,UPDLOCK)
					INNER JOIN #CustSettingTmpBatch t 
						ON s.CustID = t.CustID
						AND s.SportType = t.SportType 
						AND s.BetType = t.BetType
			END
		END

		IF EXISTS( SELECT 1 FROM #TempConfig WHERE SettingName IN ('Stake Level','Stake Level Group'))
		BEGIN
			DELETE dl
			FROM Dep_ProductSetting d WITH(NOLOCK)
				INNER JOIN Dep_LicenseeProductSetting dl WITH(ROWLOCK,UPDLOCK) 
					ON d.ProductSettingID = dl.ProductSettingID
				INNER JOIN #TempConfig cf 
					ON d.SettingType = cf.SettingType 
					AND cf.SettingName IN ('Stake Level','Stake Level Group')
			WHERE d.ProductID = @ProductID
				AND dl.CustID = @srecommend

			TRUNCATE TABLE #CustSettingTmp

			INSERT INTO #CustSettingTmp(CustID,Sporttype,Bettype)
			SELECT c.CustID,c.SportType,c.BetType
			FROM Dep_CustStakeLevel_Agent c WITH(NOLOCK)
				INNER JOIN #SMATemp t ON c.CustID = t.CustID
				INNER JOIN #TempConfig tc 
					ON c.SportType = tc.SportType 
					AND c.BetType = tc.BetType
			WHERE tc.SettingName IN ('Stake Level','Stake Level Group')

			DELETE s
			FROM Dep_CustStakeLevel_Agent s WITH(ROWLOCK,UPDLOCK)
				INNER JOIN #CustSettingTmp t 
					ON s.CustID = t.CustID
					AND s.SportType = t.SportType 
					AND s.BetType = t.BetType

			TRUNCATE TABLE #CustSettingTmp

			INSERT INTO #CustSettingTmp(CustID,Sporttype,Bettype)
			SELECT c.CustID,c.SportType,c.BetType
			FROM Dep_CustStakeLevel_Member c WITH(NOLOCK)
				INNER JOIN #MemberTemp t ON c.CustID = t.CustID
				INNER JOIN #TempConfig tc 
					ON c.SportType = tc.SportType 
					AND c.BetType = tc.BetType
			WHERE tc.SettingName IN ('Stake Level','Stake Level Group')

			WHILE 1 = 1
			BEGIN 
				TRUNCATE TABLE #CustSettingTmpBatch

				DELETE TOP(@BatchNum) t
				OUTPUT deleted.custid
					,deleted.Sporttype
					,deleted.Bettype
					,deleted.IsLive 
				INTO #CustSettingTmpBatch(custid,Sporttype,Bettype,IsLive)
				FROM #CustSettingTmp t

				IF @@ROWCOUNT = 0
					BREAK

				DELETE s
				FROM Dep_CustStakeLevel_Member s WITH(ROWLOCK,UPDLOCK)
					INNER JOIN #CustSettingTmpBatch t 
						ON s.CustID = t.CustID
						AND s.SportType = t.SportType 
						AND s.BetType = t.BetType
			END
		END

		IF EXISTS( SELECT 1 FROM #TempConfig WHERE SettingName = 'Product Status')
		BEGIN
			DELETE dl
			FROM Dep_ProductSetting d WITH(NOLOCK)
				INNER JOIN Dep_LicenseeProductSetting dl WITH(ROWLOCK,UPDLOCK) 
					ON d.ProductSettingID = dl.ProductSettingID
				INNER JOIN #TempConfig cf 
					ON d.SettingType = cf.SettingType 
					AND cf.SettingName = 'Product Status'
			WHERE d.ProductID = @ProductID
				AND dl.CustID = @srecommend
		END
	END
	ELSE IF @StepID = 2 --Insert setting
	BEGIN
		---------------------------------------START : INSERT SETTING--------------------
		-----------------------PT--------
		IF EXISTS( SELECT 1 FROM #TempConfig WHERE SettingName = 'Position Taking' AND IsDefault = 1)
		BEGIN
			INSERT INTO Dep_LicenseeProductSetting(CustID,ProductSettingID)
			SELECT DISTINCT t.CustID,d.ProductSettingID
			FROM Dep_ProductSetting d WITH(NOLOCK)
				CROSS JOIN #SMATemp t 
				INNER JOIN #TempConfig cf 
					ON d.SettingType = cf.SettingType 
					AND cf.SettingName = 'Position Taking' 
					AND cf.IsDefault = 1 
				LEFT JOIN Dep_LicenseeProductSetting dl WITH(NOLOCK) 
					ON d.ProductSettingID = dl.ProductSettingID
					AND dl.CustID = t.CustID
			WHERE d.ProductID = @ProductID
				AND t.RoleID = 4
				AND dl.CustID IS NULL

			INSERT INTO dbo.Dep_CustPTSetting_Agent(CustID,SportType,BetType,IsLive,SuperPT,MasterPT,AgentPT)
			SELECT t.CustID,tc.SportType,tc.BetType,tc.IsLive
				,CASE WHEN t.RoleID = 4 THEN tc.DefaultValueSuper ELSE 0 END
				,CASE WHEN t.RoleID IN(3, 4) THEN tc.DefaultValueSuper ELSE 0 END
				,CASE WHEN t.RoleID IN(2, 4) THEN tc.DefaultValueSuper ELSE 0 END
			FROM #SMATemp t
				CROSS JOIN #TempConfig tc 
			WHERE tc.SettingName = 'Position Taking'
				AND tc.IsDefault = 1

			INSERT INTO dbo.Dep_CustPTGroupSetting_Member(AgentID,SportType,BetType,IsLive,SuperPT,MasterPT,AgentPT)
			SELECT t.CustID,tc.SportType,tc.BetType,tc.IsLive,0,0
				,AgentPT = CASE WHEN @Site='asiabet88' AND @Currency IN(3,6) AND tc.IsApplyBA = 1 THEN 0 ELSE tc.DefaultValueSuper END
			FROM #SMATemp t
				CROSS JOIN #TempConfig tc 
			WHERE tc.SettingName = 'Position Taking'
				AND t.RoleID = 2
				AND tc.IsDefault = 1
				AND NOT EXISTS( SELECT 1 
								FROM Dep_CustPTGroupSetting_Member c WITH(NOLOCK) 
								WHERE c.AgentID = t.CustID 
									AND c.SportType = tc.SportType 
									AND c.BetType = tc.BetType 
									AND c.IsLive = tc.IsLive
								)

			UPDATE #MemberTemp SET IsFinished = 0

			SELECT @BatchNum = @MaxBatch/COUNT(1) 
			FROM #TempConfig tc  
			WHERE tc.SettingName = 'Position Taking' AND tc.IsDefault = 1

			--Member level
			WHILE 1 = 1
			BEGIN
				TRUNCATE TABLE #CustTempBatch

				UPDATE TOP(@BatchNum) t
				SET t.IsFinished = 1
				OUTPUT deleted.custid INTO #CustTempBatch(custid)
				FROM #MemberTemp t
				WHERE t.IsFinished = 0

				IF @@ROWCOUNT = 0
					BREAK

				IF @IsBA_PTLogic = 0
				BEGIN
					INSERT INTO dbo.Dep_CustPTSetting_Member(CustID,SportType,BetType,IsLive,SuperPT,MasterPT,AgentPT)
					SELECT t.CustID,tc.SportType,tc.BetType,tc.IsLive,0,0,tc.DefaultValueSuper
					FROM #CustTempBatch t
						CROSS JOIN #TempConfig tc 
						INNER JOIN Dep_CustSettingMode m WITH(NOLOCK) 
							ON t.CustID = m.CustID 
							AND m.IsGroupedPT = 0
					WHERE tc.SettingName = 'Position Taking'
						AND tc.IsDefault = 1
				END
				ELSE  --Aplly BA PT
				BEGIN
					INSERT INTO dbo.Dep_CustPTSetting_Member(CustID,SportType,BetType,IsLive,SuperPT,MasterPT,AgentPT)
					SELECT t.CustID,tc.SportType,tc.BetType,tc.IsLive,0,0
						,CASE WHEN tc.IsApplyBA = 1 AND ba.CustId IS NOT NULL THEN 0 ELSE tc.DefaultValueSuper END
					FROM #CustTempBatch t
						CROSS JOIN #TempConfig tc 
						INNER JOIN Dep_CustSettingMode m WITH(NOLOCK) 
							ON t.CustID = m.CustID 
							AND m.IsGroupedPT = 0
						LEFT JOIN Dep_CustBAActive ba WITH(NOLOCK) 
							ON t.CustID = ba.CustId
					WHERE tc.SettingName = 'Position Taking'
						AND tc.IsDefault = 1
				END
			END
		END

		-----------------------Bet Setting--------
		IF EXISTS( SELECT 1 FROM #TempConfig WHERE SettingName = 'Bet Setting' AND IsDefault = 1)
		BEGIN
			INSERT INTO Dep_LicenseeProductSetting(CustID,ProductSettingID)
			SELECT DISTINCT t.CustID,d.ProductSettingID
			FROM Dep_ProductSetting d WITH(NOLOCK)
				CROSS JOIN #SMATemp t 
				INNER JOIN #TempConfig cf 
					ON d.SettingType = cf.SettingType 
					AND cf.SettingName = 'Bet Setting' 
					AND cf.IsDefault = 1 
				LEFT JOIN Dep_LicenseeProductSetting dl WITH(NOLOCK) 
					ON d.ProductSettingID = dl.ProductSettingID
					AND dl.CustID = t.CustID
			WHERE d.ProductID = @ProductID
				AND t.RoleID = 4
				AND dl.CustID IS NULL

			INSERT INTO dbo.Dep_CustBetSetting_Agent(CustID, SportType, BetType, MinBet, MaxBet, MaxPerMatch)
			SELECT c.CustID, t.SportType, t.BetType, bs.MinBet, bs.MaxBet, bs.MaxPerMatch
			FROM #SMATemp c
				CROSS JOIN #TempConfig t 
				INNER JOIN #TempBetSetting bs 
					ON t.SportType = bs.SportType
					AND t.BetType = bs.BetType
			WHERE t.SettingName = 'Bet Setting'
				AND t.IsDefault = 1

			UPDATE #MemberTemp SET IsFinished = 0

			SELECT @BatchNum = @MaxBatch/COUNT(1) 
			FROM #TempConfig tc  
			WHERE tc.SettingName = 'Bet Setting' AND tc.IsDefault = 1

			--Member level
			WHILE 1 = 1
			BEGIN
				TRUNCATE TABLE #CustTempBatch

				UPDATE TOP(@BatchNum) t
				SET t.IsFinished = 1
				OUTPUT deleted.custid INTO #CustTempBatch(custid)
				FROM #MemberTemp t
				WHERE t.IsFinished = 0

				IF @@ROWCOUNT = 0
					BREAK

				INSERT INTO dbo.Dep_CustBetSetting_Member(CustID, SportType, BetType, MinBet, MaxBet, MaxPerMatch)
				SELECT c.CustID, t.SportType, t.BetType, bs.MinBet, bs.MaxBet, bs.MaxPerMatch
				FROM #CustTempBatch c
					CROSS JOIN #TempConfig t 
					INNER JOIN #TempBetSetting bs 
						ON t.SportType = bs.SportType
						AND t.BetType = bs.BetType
				WHERE t.SettingName = 'Bet Setting'
					AND t.IsDefault = 1
			END
		END

		-----------------------Bet Setting Game--------
		IF EXISTS( SELECT 1 FROM #TempConfig WHERE SettingName = 'Bet Setting Game' AND IsDefault = 1)
		BEGIN
			INSERT INTO Dep_LicenseeProductSetting(CustID,ProductSettingID)
			SELECT DISTINCT t.CustID,d.ProductSettingID
			FROM Dep_ProductSetting d WITH(NOLOCK)
				CROSS JOIN #SMATemp t 
				INNER JOIN #TempConfig cf 
					ON d.SettingType = cf.SettingType 
					AND cf.SettingName = 'Bet Setting Game' 
					AND cf.IsDefault = 1
				LEFT JOIN Dep_LicenseeProductSetting dl WITH(NOLOCK) 
					ON d.ProductSettingID = dl.ProductSettingID
					AND dl.CustID = t.CustID
			WHERE d.ProductID = @ProductID
				AND t.RoleID = 4
				AND dl.CustID IS NULL

			INSERT INTO dbo.Dep_CustBetSettingGame_Agent(CustID, SportType, BetType, MinBet, MaxBet, MaxPerMatch, MaxPerNumber, MaxPayoutPerMatch)
			SELECT c.CustID, t.SportType, t.BetType, bs.MinBet, bs.MaxBet, bs.MaxPerMatch, bs.MaxPerNumber, bs.MaxPayoutPerMatch
			FROM #SMATemp c
				CROSS JOIN #TempConfig t 
				INNER JOIN #TempBetSetting bs 
					ON t.SportType = bs.SportType
					AND t.BetType = bs.BetType
			WHERE t.SettingName = 'Bet Setting Game'
				AND t.IsDefault = 1

			INSERT INTO dbo.Dep_CustBetSettingGameGroup_Member(AgentID, SportType, BetType, MinBet, MaxBet, MaxPerMatch, MaxPerNumber, MaxPayoutPerMatch)
			SELECT c.CustID, t.SportType, t.BetType, bs.MinBet, bs.MaxBet, bs.MaxPerMatch, bs.MaxPerNumber, bs.MaxPayoutPerMatch
			FROM #SMATemp c
				CROSS JOIN #TempConfig t 
				INNER JOIN #TempBetSetting bs 
					ON t.SportType = bs.SportType
					AND t.BetType = bs.BetType
			WHERE t.SettingName = 'Bet Setting Game'
				AND t.IsDefault = 1
				AND c.RoleID = 2
				AND NOT EXISTS( SELECT 1 
								FROM Dep_CustBetSettingGameGroup_Member c1 WITH(NOLOCK) 
								WHERE c1.AgentID = c.CustID 
									AND c1.SportType = t.SportType 
									AND c1.BetType = t.BetType 
								)

			UPDATE #MemberTemp SET IsFinished = 0

			SELECT @BatchNum = @MaxBatch/COUNT(1) 
			FROM #TempConfig tc  
			WHERE tc.SettingName = 'Bet Setting Game' AND tc.IsDefault = 1

			--Member level
			WHILE 1 = 1
			BEGIN
				TRUNCATE TABLE #CustTempBatch

				UPDATE TOP(@BatchNum) t
				SET t.IsFinished = 1
				OUTPUT deleted.custid INTO #CustTempBatch(custid)
				FROM #MemberTemp t
				WHERE t.IsFinished = 0

				IF @@ROWCOUNT = 0
					BREAK

				INSERT INTO dbo.Dep_CustBetSettingGame_Member(CustID, SportType, BetType, MinBet, MaxBet, MaxPerMatch, MaxPerNumber, MaxPayoutPerMatch)
				SELECT c.CustID, t.SportType, t.BetType, bs.MinBet, bs.MaxBet, bs.MaxPerMatch, bs.MaxPerNumber, bs.MaxPayoutPerMatch
				FROM #CustTempBatch c
					INNER JOIN Dep_CustSettingMode m WITH(NOLOCK) 
						ON c.CustID = m.CustID 
						AND m.IsGroupedBetLimit = 0
					CROSS JOIN #TempConfig t 
					INNER JOIN #TempBetSetting bs 
						ON t.SportType = bs.SportType
						AND t.BetType = bs.BetType
				WHERE t.SettingName = 'Bet Setting Game'
					AND t.IsDefault = 1
			END		
		END
		
		-----------------------Stake Level-------------------------------------------------------
		IF EXISTS( SELECT 1 FROM #TempConfig WHERE SettingName = 'Stake Level Group' AND IsDefault = 1)
		BEGIN
			INSERT INTO Dep_LicenseeProductSetting(CustID,ProductSettingID)
			SELECT DISTINCT t.CustID,d.ProductSettingID
			FROM Dep_ProductSetting d WITH(NOLOCK)
				CROSS JOIN #SMATemp t 
				INNER JOIN #TempConfig cf 
					ON d.SettingType = cf.SettingType 
					AND cf.SettingName = 'Stake Level Group' 
					AND cf.IsDefault = 1 
				LEFT JOIN Dep_LicenseeProductSetting dl WITH(NOLOCK) 
					ON d.ProductSettingID = dl.ProductSettingID
					AND dl.CustID = t.CustID
			WHERE d.ProductID = @ProductID
				AND t.RoleID = 4
				AND dl.CustID IS NULL

			INSERT INTO #tmpSTList(Sporttype, BettypeID, StakelevelList, Min_StakeLevel)
			SELECT DISTINCT t.SportType,t.BetType
				, CAST (STUFF (STL, 1,1, '') AS VARCHAR(500)) as StakeLevelList
				, CAST (M.StakeLevelID AS VARCHAR(10)) as Min_StakeLevel
			FROM #TempConfig t
				CROSS APPLY (SELECT ',' + CAST(StakeLevelID AS VARCHAR(10))
							FROM Dep_StakeLevel S WITH (NOLOCK)
							WHERE S.GameTypeID = t.BetType AND S.ExchangeId = @Currency
							FOR XML PATH ('') 
							) AS A(STL)
				CROSS APPLY (SELECT TOP 1 StakeLevelID
							FROM Dep_StakeLevel S WITH (NOLOCK)
								LEFT JOIN GameGroup gg WITH(NOLOCK) 
									ON s.GameGroupID = gg.GameGroupID
							WHERE S.GameTypeID = t.BetType AND S.ExchangeId = @Currency
							ORDER BY s.MaxStake ASC, s.MinStake ASC, gg.GroupName ASC
							) AS M
			WHERE t.SettingName = 'Stake Level Group' AND t.IsDefault = 1
			
			--SMA Level
			INSERT INTO dbo.Dep_CustStakeLevel_Agent ([CustID],[SportType],[BetType],[StakeLevelList]) 
			SELECT t.custid, tb.Sporttype, tb.BettypeID, tb.StakeLevelList
			FROM  #tmpSTList tb
				CROSS JOIN  #SMATemp t

			UPDATE #MemberTemp SET IsFinished = 0

			SELECT @BatchNum = @MaxBatch/COUNT(1) 
			FROM #TempConfig tc  
			WHERE tc.SettingName = 'Stake Level Group' AND tc.IsDefault = 1

			--Member level
			WHILE 1 = 1
			BEGIN
				TRUNCATE TABLE #CustTempBatch

				UPDATE TOP(@BatchNum) t
				SET t.IsFinished = 1
				OUTPUT deleted.custid INTO #CustTempBatch(custid)
				FROM #MemberTemp t
				WHERE t.IsFinished = 0

				IF @@ROWCOUNT = 0
					BREAK

				--Member Level
				INSERT INTO dbo.Dep_CustStakeLevel_Member ([CustID],[SportType],[BetType],[StakeLevelList],LastUpdated) 
				SELECT t.custid, tb.Sporttype, tb.BettypeID, tb.Min_StakeLevel,@CurrentDTS
				FROM  #tmpSTList tb
					CROSS JOIN  #CustTempBatch t
			END		
		END

		IF EXISTS( SELECT 1 FROM #TempConfig WHERE SettingName = 'Stake Level' AND IsDefault = 1)
		BEGIN
			INSERT INTO Dep_LicenseeProductSetting(CustID,ProductSettingID)
			SELECT DISTINCT t.CustID,d.ProductSettingID
			FROM Dep_ProductSetting d WITH(NOLOCK)
				CROSS JOIN #SMATemp t 
				INNER JOIN #TempConfig cf 
					ON d.SettingType = cf.SettingType 
					AND cf.SettingName = 'Stake Level' 
					AND cf.IsDefault = 1 
				LEFT JOIN Dep_LicenseeProductSetting dl WITH(NOLOCK) 
					ON d.ProductSettingID = dl.ProductSettingID
					AND dl.CustID = t.CustID
			WHERE d.ProductID = @ProductID
				AND t.RoleID = 4
				AND dl.CustID IS NULL

			INSERT INTO #tmpSTList(Sporttype, BettypeID, StakelevelList, Min_StakeLevel)
			SELECT DISTINCT t.SportType, t.BetType
				, CAST (STUFF (STL, 1,1, '') AS VARCHAR(500)) as StakeLevelList
				, CAST (M.StakeLevelID AS VARCHAR(10)) as Min_StakeLevel
			FROM #TempConfig t
				CROSS APPLY (SELECT ',' + CAST(StakeLevelID AS VARCHAR(10))
							FROM Dep_StakeLevel S WITH (NOLOCK)
							WHERE S.GameTypeID = t.BetType AND S.ExchangeId = @Currency AND s.SiteID = @SiteID
							FOR XML PATH ('') 
							) AS A(STL)
				CROSS APPLY (SELECT TOP 1 StakeLevelID
							FROM Dep_StakeLevel S WITH (NOLOCK)
								LEFT JOIN GameGroup gg WITH(NOLOCK) 
									ON s.GameGroupID = gg.GameGroupID
							WHERE S.GameTypeID = t.BetType AND S.ExchangeId = @Currency AND s.SiteID = @SiteID
							ORDER BY s.MaxStake ASC, s.MinStake ASC, gg.GroupName ASC
							) AS M
			WHERE t.SettingName = 'Stake Level' AND t.IsDefault = 1
			
			--SMA Level
			INSERT INTO dbo.Dep_CustStakeLevel_Agent ([CustID],[SportType],[BetType],[StakeLevelList]) 
			SELECT t.custid, tb.Sporttype, tb.BettypeID, tb.StakeLevelList
			FROM  #tmpSTList tb
				CROSS JOIN  #SMATemp t

			UPDATE #MemberTemp SET IsFinished = 0

			SELECT @BatchNum = @MaxBatch/COUNT(1) 
			FROM #TempConfig tc  
			WHERE tc.SettingName = 'Stake Level' AND tc.IsDefault = 1

			--Member level
			WHILE 1 = 1
			BEGIN
				TRUNCATE TABLE #CustTempBatch

				UPDATE TOP(@BatchNum) t
				SET t.IsFinished = 1
				OUTPUT deleted.custid INTO #CustTempBatch(custid)
				FROM #MemberTemp t
				WHERE t.IsFinished = 0

				IF @@ROWCOUNT = 0
					BREAK

				--Member Level
				INSERT INTO dbo.Dep_CustStakeLevel_Member ([CustID],[SportType],[BetType],[StakeLevelList],LastUpdated) 
				SELECT t.custid, tb.Sporttype, tb.BettypeID, tb.Min_StakeLevel,@CurrentDTS
				FROM  #tmpSTList tb
					CROSS JOIN  #CustTempBatch t
			END		

			
		END
		---------------------------------------END : INSERT SETTING----------------------
		------------------Update Status--------------------------------------------------
		IF EXISTS( SELECT 1 FROM #TempConfig WHERE SettingName = 'Product Status' AND IsDefault = 1)
		BEGIN
			INSERT INTO Dep_LicenseeProductSetting(CustID,ProductSettingID)
			SELECT DISTINCT t.CustID,d.ProductSettingID
			FROM Dep_ProductSetting d WITH(NOLOCK)
				CROSS JOIN #SMATemp t 
				INNER JOIN #TempConfig cf 
					ON d.SettingType = cf.SettingType 
					AND cf.SettingName = 'Product Status' 
					AND cf.IsDefault = 1 
				LEFT JOIN Dep_LicenseeProductSetting dl WITH(NOLOCK) 
					ON d.ProductSettingID = dl.ProductSettingID
					AND dl.CustID = t.CustID
			WHERE d.ProductID = @ProductID
				AND t.RoleID = 4
				AND dl.CustID IS NULL

			SELECT @BatchNum = 5000
			
			UPDATE #TempConfig SET IsFinished = 0

			WHILE 1 = 1
			BEGIN 
				UPDATE TOP (1) t
				SET t.IsFinished = 1,
					@BitMapOrder = t.bitmapOrder,
					@IsDisabled = t.DefaultValueSuper
				FROM #TempConfig t
				WHERE t.IsFinished = 0
					AND t.IsDefault = 1
					AND t.SettingName = 'Product Status'

				IF @@ROWCOUNT = 0
					BREAK

				UPDATE #MemberTemp SET IsFinished = 0
			
				--SMA level
				UPDATE cs
				SET cs.bitmapIsHidden = hid.NewBitmap,
					bitmapIsDisabled = dis.NewBitmap	
				FROM [dbo].[Dep_CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
					INNER JOIN #SMATemp ci ON cs.CustID = ci.CustID
					CROSS APPLY dbo.f_CustSetting_GenerateProductStatus(cs.bitmapIsHidden,@BitMapOrder,0) as Hid
					CROSS APPLY dbo.f_CustSetting_GenerateProductStatus(cs.bitmapIsDisabled,@BitMapOrder,@IsDisabled) as Dis

				INSERT INTO Dep_CustProductStatus (CustID,bitmapIsDisabled,bitmapIsHidden)
				SELECT	ci.custid, dis.NewBitmap, hid.NewBitmap
				FROM #SMATemp ci
					CROSS APPLY dbo.f_CustSetting_GenerateProductStatus(@Bitmap0,@BitMapOrder,0) as Hid
					CROSS APPLY dbo.f_CustSetting_GenerateProductStatus(@Bitmap0,@BitMapOrder,@IsDisabled) as Dis
				WHERE NOT EXISTS (SELECT 1 FROM Dep_CustProductStatus WITH (NOLOCK) WHERE CustID = ci.CustID)

				--Member level
				WHILE 1 = 1
				BEGIN
					TRUNCATE TABLE #CustTempBatch

					UPDATE TOP(@BatchNum) t
					SET t.IsFinished = 1
					OUTPUT deleted.custid INTO #CustTempBatch(custid)
					FROM #MemberTemp t
					WHERE t.IsFinished = 0

					IF @@ROWCOUNT = 0
						BREAK

					--Member level
					UPDATE cs
					SET cs.bitmapIsHidden = hid.NewBitmap,
						bitmapIsDisabled = dis.NewBitmap	
					FROM [dbo].[Dep_CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
						INNER JOIN #CustTempBatch ci ON cs.CustID = ci.CustID
						CROSS APPLY dbo.f_CustSetting_GenerateProductStatus(cs.bitmapIsHidden,@BitMapOrder,0) as Hid
						CROSS APPLY dbo.f_CustSetting_GenerateProductStatus(cs.bitmapIsDisabled,@BitMapOrder,@IsDisabled) as Dis
				END

				INSERT INTO Dep_CustProductStatus (CustID,bitmapIsDisabled,bitmapIsHidden)
				SELECT	ci.custid, dis.NewBitmap, hid.NewBitmap
				FROM #MemberTemp ci
					CROSS APPLY dbo.f_CustSetting_GenerateProductStatus(@Bitmap0,@BitMapOrder,0) as Hid
					CROSS APPLY dbo.f_CustSetting_GenerateProductStatus(@Bitmap0,@BitMapOrder,@IsDisabled) as Dis
				WHERE NOT EXISTS (SELECT 1 FROM Dep_CustProductStatus WITH (NOLOCK) WHERE CustID = ci.CustID)
			END
		END
	END

	DROP TABLE #TempConfig
	DROP TABLE #MemberTemp
	DROP TABLE #SMATemp
	DROP TABLE #CustTempBatch
	DROP TABLE #Dummy
	DROP TABLE #TempBetSetting
	DROP TABLE #tmpSTList
	DROP TABLE #CustSettingTmp
	DROP TABLE #CustSettingTmpBatch
END
GO


