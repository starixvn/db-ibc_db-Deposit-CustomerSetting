/*<info serverAlias="DBCUST-CUSTDB" executers="" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_Initial_DCS_ProcessConfigStep]
	@ConfigID INT,
	@StepID TINYINT,
	@MaxCustID INT = NULL
AS
/*
	Created: 20220913@Eden
	Task : Process initial Step on main DB
	DB: DBCUST/CUSTDB
	Original:

	Revisions:  
	- 20220913@Eden: Flexible Initializing Deposit Customer Setting [RedmineID: #169648]
	- 20240916@Johnson: Apply In-house Replication for Customer Setting [redmine:#207025]
	- 20250213@Virgil.Phan: Drop BA functions [RedmineID: #216882]

	Parameter Definition
		StepID = :
			3: Insert setting for new customer
			....

	Example: 
	EXEC [Acc_Dep_Initial_DCS_ProcessConfigStep]
		@ConfigID = 6
		,@StepID = 3
		,@MaxCustID = 1000000000
	
	*/
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @Site VARCHAR(MAX), @Currency VARCHAR(MAX)
	DECLARE @TBL_site TABLE(SiteID INT, Site NVARCHAR(50) PRIMARY KEY)
	DECLARE @TBL_Currency TABLE(Currency INT PRIMARY KEY)
	DECLARE @Bitmap0 BINARY(32) = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF

	CREATE TABLE #Supers(SuperID INT PRIMARY KEY, Site NVARCHAR(50))

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
		[IsFinished] [bit] default 0
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

	SELECT @Site = Site, @Currency = Currency
	FROM Dep_Initial_ProductConfig WITH(NOLOCK)
	WHERE ConfigID = @ConfigID
		AND Status = 1 --Running

	IF @Site IS NULL OR @Currency IS NULL
		RETURN

	--> Get List of Site/Currency by config
	INSERT INTO @TBL_site(SiteID,Site)
	SELECT DISTINCT s.siteid, s.site
	FROM Site s WITH(NOLOCK)
		INNER JOIN STRING_SPLIT(@Site,',') t ON s.siteid = t.value OR @Site = '0'
	WHERE s.isActive = 1
		AND s.isLicensee = 1

	INSERT INTO @TBL_Currency(Currency)
	SELECT DISTINCT e.ExchangeId
	FROM exchange e WITH(NOLOCK)
		INNER JOIN STRING_SPLIT(@Currency,',') t ON e.ExchangeId = t.value OR @Currency = '0'
	WHERE e.IsActive = 1

	INSERT INTO #Supers(SuperID,Site)
	SELECT ci.custid, ci.site
	FROM customer ci WITH (NOLOCK) 
		INNER JOIN @TBL_Currency ex ON ci.currency = ex.Currency
		INNER JOIN @TBL_site s ON ci.Site = s.Site
		INNER JOIN Dep_custsuper cs WITH (NOLOCK) ON ci.custid = cs.custid
		INNER JOIN custInfo c WITH(NOLOCK) ON c.custid = ci.custid
	WHERE ci.roleid = 4  
		AND ci.username NOT LIKE '3rdSuper%'
		AND c.Enabled = 1

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
		,SettingName = CASE WHEN data.SettingType IN (10,12) THEN 'Bet Setting Game' 
							WHEN data.SettingType IN (8) THEN 'Stake Level Group'
							ELSE tp.SettingName END
	FROM Dep_Initial_ProductConfig_Detail Data WITH(NOLOCK)
		INNER JOIN Dep_ProductSettingType tp WITH(NOLOCK) ON data.SettingType = tp.SettingType
	WHERE data.ConfigID = @ConfigID

	INSERT INTO #TempBetSetting(
		 SportType				
		,BetType				
		,Currency				
		,MinBet					
		,MaxBet					
		,MaxPerMatch			
		,MaxPerNumber			
		,MaxPayoutPerMatch		
	)
	SELECT	 SportType				
			,BetType				
			,Currency				
			,MinBet					
			,MaxBet					
			,MaxPerMatch			
			,MaxPerNumber			
			,MaxPayoutPerMatch		
	FROM Dep_Initial_BetSetting	WITH(NOLOCK)
	WHERE ConfigID = @ConfigID

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

	--> Get ProductID
	DECLARE @ProductID TINYINT
	SELECT @ProductID = ProductID FROM Dep_Initial_ProductConfig WITH(NOLOCK) WHERE ConfigID = @ConfigID

	
	CREATE TABLE #Dummy	(CustID INT PRIMARY KEY)
	CREATE TABLE #MemberTemp(CustID INT PRIMARY KEY, recommend INT, Currency INT, Site NVARCHAR(50), isfinished BIT DEFAULT(0))
	CREATE TABLE #SMATemp(CustID INT PRIMARY KEY, Currency INT, Site NVARCHAR(50), RoleID TINYINT, isfinished BIT DEFAULT(0))
	CREATE TABLE #tmpSTList (Sporttype INT, BettypeID INT, currency INT, Site NVARCHAR(50), StakeLevelList VARCHAR(500),Min_StakeLevel VARCHAR(10))
	CREATE TABLE #CustTempBatch(CustID INT, Currency INT, Site NVARCHAR(50))
	CREATE TABLE #CustSettingTmp(CustID INT, Sporttype SMALLINT, Bettype SMALLINT,IsLive BIT)
	CREATE TABLE #CustSettingTmpBatch(CustID INT, Sporttype SMALLINT, Bettype SMALLINT,IsLive BIT)
	-----------------------

	DECLARE @MaxCustID2 INT
	SELECT  TOP (1) @MaxCustID2 = c.Custid 
	FROM custInfo c WITH(NOLOCK)
	ORDER BY c.CustID DESC

	INSERT INTO #Dummy(CustID)
	SELECT CustID 
	FROM Customer WITH(NOLOCK) 
	WHERE srecommend IN( SELECT SuperID FROM #supers)
		AND roleid=3 AND (username LIKE '%Acc%' OR username LIKE '%LocalBank%' OR username LIKE '%AFF%' OR username LIKE 'AB88'+'CAS%')

	INSERT INTO #MemberTemp(CustID,recommend,Currency,Site)
	SELECT ci.CustID,ci.recommend,ci.currency,cu.site
	FROM custInfo ci WITH(NOLOCK)
		INNER JOIN customer cu WITH(NOLOCK) ON ci.custid = cu.custid
	WHERE ci.srecommend IN( SELECT SuperID FROM #supers)
		AND ci.roleid = 1 
		AND ci.Enabled=1
		AND ci.mrecommend NOT IN (SELECT custid FROM #Dummy)
		AND ci.custid > @MaxCustID AND ci.custid <= @MaxCustID2

	INSERT INTO #SMATemp(CustID,RoleID,Currency,Site)
	SELECT ci.CustID,ci.roleid,ci.currency,cu.site
	FROM custInfo ci WITH(NOLOCK)
		INNER JOIN customer cu WITH(NOLOCK) ON ci.custid = cu.custid
	WHERE ci.srecommend IN( SELECT SuperID FROM #supers)
		AND ci.roleid IN (2,3,4) 
		AND ci.Enabled=1
		AND ci.mrecommend NOT IN (SELECT custid FROM #Dummy)
		AND ci.custid > @MaxCustID AND ci.custid <= @MaxCustID2

	DECLARE @CurrentDTS DATETIME = GETDATE()
	DECLARE @MaxBatch INT = 2000
	DECLARE @BatchNum INT = 2000
	DECLARE @BitMapOrder TINYINT
	DECLARE @IsDisabled BIT
	
	IF @StepID = 3 --Insert setting for new customers
	BEGIN
		----------START : DELETE REDUDANT SETTING----------------------------------------
		BEGIN
			IF EXISTS( SELECT 1 FROM #TempConfig WHERE SettingName = 'Position Taking')
			BEGIN
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
				OUTPUT DELETED.CustID, DELETED.SportType, DELETED.BetType, DELETED.IsLive, dbo.f_GetDateTime2()
				INTO Dep_CustPTSetting_Agent_Del_InHouse(CustID,SportType,BetType,IsLive,RepUpdateTime)
				FROM Dep_CustPTSetting_Agent s WITH(ROWLOCK,UPDLOCK)
					INNER JOIN #CustSettingTmp t 
						ON s.CustID = t.CustID
						AND s.SportType = t.SportType 
						AND s.BetType = t.BetType
						AND s.IsLive = t.IsLive

				DELETE s
				OUTPUT DELETED.AgentID, DELETED.SportType, DELETED.BetType, DELETED.IsLive, dbo.f_GetDateTime2()
				INTO Dep_CustPTGroupSetting_Member_Del_InHouse(AgentID,SportType,BetType,IsLive,RepUpdateTime)
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
					OUTPUT DELETED.CustID, DELETED.SportType, DELETED.BetType, DELETED.IsLive, dbo.f_GetDateTime2()
					INTO Dep_CustPTSetting_Member_Del_InHouse(CustID,SportType,BetType,IsLive,RepUpdateTime)
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
				OUTPUT DELETED.CustID, DELETED.SportType, DELETED.BetType, dbo.f_GetDateTime2()
				INTO Dep_CustBetSetting_Agent_Del_InHouse(CustID,SportType,BetType,RepUpdateTime)
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
					OUTPUT DELETED.CustID, DELETED.SportType, DELETED.BetType, dbo.f_GetDateTime2()
					INTO Dep_CustBetSetting_Member_Del_InHouse(CustID,SportType,BetType,RepUpdateTime)
					FROM Dep_CustBetSetting_Member s WITH(ROWLOCK,UPDLOCK)
						INNER JOIN #CustSettingTmpBatch t 
							ON s.CustID = t.CustID
							AND s.SportType = t.SportType 
							AND s.BetType = t.BetType
				END
			END

			IF EXISTS( SELECT 1 FROM #TempConfig WHERE SettingName = 'Bet Setting Game')
			BEGIN
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
				OUTPUT DELETED.CustID, DELETED.SportType, DELETED.BetType, dbo.f_GetDateTime2()
				INTO Dep_CustBetSettingGame_Agent_Del_InHouse(CustID,SportType,BetType,RepUpdateTime)
				FROM Dep_CustBetSettingGame_Agent s WITH(ROWLOCK,UPDLOCK)
					INNER JOIN #CustSettingTmp t 
						ON s.CustID = t.CustID
						AND s.SportType = t.SportType 
						AND s.BetType = t.BetType

				DELETE s
				OUTPUT DELETED.AgentID, DELETED.SportType, DELETED.BetType, dbo.f_GetDateTime2()
				INTO Dep_CustBetSettingGameGroup_Member_Del_InHouse(AgentID,SportType,BetType,RepUpdateTime)
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
					OUTPUT DELETED.CustID, DELETED.SportType, DELETED.BetType, dbo.f_GetDateTime2()
					INTO Dep_CustBetSettingGame_Member_Del_InHouse(CustID,SportType,BetType,RepUpdateTime)
					FROM Dep_CustBetSettingGame_Member s WITH(ROWLOCK,UPDLOCK)
						INNER JOIN #CustSettingTmpBatch t 
							ON s.CustID = t.CustID
							AND s.SportType = t.SportType 
							AND s.BetType = t.BetType
				END
			END

			IF EXISTS( SELECT 1 FROM #TempConfig WHERE SettingName IN ('Stake Level','Stake Level Group'))
			BEGIN
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
				OUTPUT DELETED.CustID, DELETED.SportType, DELETED.BetType, dbo.f_GetDateTime2()
				INTO Dep_CustStakeLevel_Agent_Del_InHouse(CustID,SportType,BetType,RepUpdateTime)
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
					OUTPUT DELETED.CustID, DELETED.SportType, DELETED.BetType, dbo.f_GetDateTime2()
					INTO Dep_CustStakeLevel_Member_Del_InHouse(CustID,SportType,BetType,RepUpdateTime)
					FROM Dep_CustStakeLevel_Member s WITH(ROWLOCK,UPDLOCK)
						INNER JOIN #CustSettingTmpBatch t 
							ON s.CustID = t.CustID
							AND s.SportType = t.SportType 
							AND s.BetType = t.BetType
				END
			END
		END
		----------END : DELETE REDUDANT SETTING------------------------------------------

		---------------------------------------START : INSERT SETTING--------------------
		-----------------------PT--------
		IF EXISTS( SELECT 1 FROM #TempConfig WHERE SettingName = 'Position Taking' AND IsDefault = 1)
		BEGIN
			INSERT INTO Dep_LicenseeProductSetting(CustID,ProductSettingID,RepUpdateTime)
			SELECT DISTINCT t.CustID,d.ProductSettingID, dbo.f_GetDateTime2()
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

			INSERT INTO dbo.Dep_CustPTSetting_Agent(CustID,SportType,BetType,IsLive,SuperPT,MasterPT,AgentPT,RepUpdateTime)
			SELECT t.CustID,tc.SportType,tc.BetType,tc.IsLive
				,CASE WHEN t.RoleID = 4 THEN tc.DefaultValueSuper ELSE 0 END
				,CASE WHEN t.RoleID IN(3, 4) THEN tc.DefaultValueSuper ELSE 0 END
				,CASE WHEN t.RoleID IN(2, 4) THEN tc.DefaultValueSuper ELSE 0 END
				,dbo.f_GetDateTime2()
			FROM #SMATemp t
				CROSS JOIN #TempConfig tc 
			WHERE tc.SettingName = 'Position Taking'
				AND tc.IsDefault = 1

			INSERT INTO dbo.Dep_CustPTGroupSetting_Member(AgentID,SportType,BetType,IsLive,SuperPT,MasterPT,AgentPT,RepUpdateTime)
			SELECT t.CustID,tc.SportType,tc.BetType,tc.IsLive,0,0
				,AgentPT = tc.DefaultValueSuper
				,dbo.f_GetDateTime2()
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

				INSERT INTO dbo.Dep_CustPTSetting_Member(CustID,SportType,BetType,IsLive,SuperPT,MasterPT,AgentPT,RepUpdateTime)
				SELECT t.CustID,tc.SportType,tc.BetType,tc.IsLive,0,0,tc.DefaultValueSuper,dbo.f_GetDateTime2()
				FROM #CustTempBatch t
					CROSS JOIN #TempConfig tc 
					INNER JOIN Dep_CustSettingMode m WITH(NOLOCK) 
						ON t.CustID = m.CustID 
						AND m.IsGroupedPT = 0
				WHERE tc.SettingName = 'Position Taking'
					AND tc.IsDefault = 1

			END
		END

		-----------------------Bet Setting--------
		IF EXISTS( SELECT 1 FROM #TempConfig WHERE SettingName = 'Bet Setting' AND IsDefault = 1)
		BEGIN
			INSERT INTO Dep_LicenseeProductSetting(CustID,ProductSettingID,RepUpdateTime)
			SELECT DISTINCT t.CustID,d.ProductSettingID,dbo.f_GetDateTime2()
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

			INSERT INTO dbo.Dep_CustBetSetting_Agent(CustID, SportType, BetType, MinBet, MaxBet, MaxPerMatch, RepUpdateTime)
			SELECT c.CustID, t.SportType, t.BetType, bs.MinBet, bs.MaxBet, bs.MaxPerMatch,dbo.f_GetDateTime2()
			FROM #SMATemp c
				CROSS JOIN #TempConfig t 
				INNER JOIN #TempBetSetting bs 
					ON t.SportType = bs.SportType
					AND t.BetType = bs.BetType
					AND c.Currency = bs.Currency
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
				OUTPUT deleted.custid, deleted.Currency INTO #CustTempBatch(custid,Currency)
				FROM #MemberTemp t
				WHERE t.IsFinished = 0

				IF @@ROWCOUNT = 0
					BREAK

				INSERT INTO dbo.Dep_CustBetSetting_Member(CustID, SportType, BetType, MinBet, MaxBet, MaxPerMatch, RepUpdateTime)
				SELECT c.CustID, t.SportType, t.BetType, bs.MinBet, bs.MaxBet, bs.MaxPerMatch,dbo.f_GetDateTime2()
				FROM #CustTempBatch c
					CROSS JOIN #TempConfig t 
					INNER JOIN #TempBetSetting bs 
						ON t.SportType = bs.SportType
						AND t.BetType = bs.BetType
						AND c.Currency = bs.Currency
				WHERE t.SettingName = 'Bet Setting'
					AND t.IsDefault = 1
			END
		END

		-----------------------Bet Setting Game--------
		IF EXISTS( SELECT 1 FROM #TempConfig WHERE SettingName = 'Bet Setting Game' AND IsDefault = 1)
		BEGIN
			INSERT INTO Dep_LicenseeProductSetting(CustID,ProductSettingID,RepUpdateTime)
			SELECT DISTINCT t.CustID,d.ProductSettingID,dbo.f_GetDateTime2()
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

			INSERT INTO dbo.Dep_CustBetSettingGame_Agent(CustID, SportType, BetType, MinBet, MaxBet, MaxPerMatch, MaxPerNumber, MaxPayoutPerMatch,RepUpdateTime)
			SELECT c.CustID, t.SportType, t.BetType, bs.MinBet, bs.MaxBet, bs.MaxPerMatch, bs.MaxPerNumber, bs.MaxPayoutPerMatch,dbo.f_GetDateTime2()
			FROM #SMATemp c
				CROSS JOIN #TempConfig t 
				INNER JOIN #TempBetSetting bs 
					ON t.SportType = bs.SportType
					AND t.BetType = bs.BetType
					AND c.Currency = bs.Currency
			WHERE t.SettingName = 'Bet Setting Game'
				AND t.IsDefault = 1

			INSERT INTO dbo.Dep_CustBetSettingGameGroup_Member(AgentID, SportType, BetType, MinBet, MaxBet, MaxPerMatch, MaxPerNumber, MaxPayoutPerMatch,RepUpdateTime)
			SELECT c.CustID, t.SportType, t.BetType, bs.MinBet, bs.MaxBet, bs.MaxPerMatch, bs.MaxPerNumber, bs.MaxPayoutPerMatch,dbo.f_GetDateTime2()
			FROM #SMATemp c
				CROSS JOIN #TempConfig t 
				INNER JOIN #TempBetSetting bs 
					ON t.SportType = bs.SportType
					AND t.BetType = bs.BetType
					AND c.Currency = bs.Currency
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
				OUTPUT deleted.custid, deleted.Currency INTO #CustTempBatch(custid,Currency)
				FROM #MemberTemp t
				WHERE t.IsFinished = 0

				IF @@ROWCOUNT = 0
					BREAK

				INSERT INTO dbo.Dep_CustBetSettingGame_Member(CustID, SportType, BetType, MinBet, MaxBet, MaxPerMatch, MaxPerNumber, MaxPayoutPerMatch,RepUpdateTime)
				SELECT c.CustID, t.SportType, t.BetType, bs.MinBet, bs.MaxBet, bs.MaxPerMatch, bs.MaxPerNumber, bs.MaxPayoutPerMatch,dbo.f_GetDateTime2()
				FROM #CustTempBatch c
					INNER JOIN Dep_CustSettingMode m WITH(NOLOCK) 
						ON c.CustID = m.CustID 
						AND m.IsGroupedBetLimit = 0
					CROSS JOIN #TempConfig t 
					INNER JOIN #TempBetSetting bs 
						ON t.SportType = bs.SportType
						AND t.BetType = bs.BetType
						AND c.Currency = bs.Currency
				WHERE t.SettingName = 'Bet Setting Game'
					AND t.IsDefault = 1
			END		
		END
		
		-----------------------Stake Level-------------------------------------------------------
		IF EXISTS( SELECT 1 FROM #TempConfig WHERE SettingName = 'Stake Level Group' AND IsDefault = 1)
		BEGIN
			INSERT INTO Dep_LicenseeProductSetting(CustID,ProductSettingID,RepUpdateTime)
			SELECT DISTINCT t.CustID,d.ProductSettingID,dbo.f_GetDateTime2()
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

			INSERT INTO #tmpSTList(Sporttype, BettypeID, Currency, StakelevelList, Min_StakeLevel)
			SELECT DISTINCT t.SportType,t.BetType,cu.Currency
				, CAST (STUFF (STL, 1,1, '') AS VARCHAR(500)) as StakeLevelList
				, CAST (M.StakeLevelID AS VARCHAR(10)) as Min_StakeLevel
			FROM #TempConfig t
				CROSS APPLY @TBL_Currency cu
				CROSS APPLY (SELECT ',' + CAST(StakeLevelID AS VARCHAR(10))
							FROM Dep_StakeLevel S WITH (NOLOCK)
							WHERE S.GameTypeID = t.BetType AND S.ExchangeId = cu.Currency
							FOR XML PATH ('') 
							) AS A(STL)
				CROSS APPLY (SELECT TOP 1 StakeLevelID
							FROM Dep_StakeLevel S WITH (NOLOCK)
								LEFT JOIN GameGroup gg WITH(NOLOCK) 
									ON s.GameGroupID = gg.GameGroupID
							WHERE S.GameTypeID = t.BetType AND S.ExchangeId = cu.Currency
							ORDER BY s.MaxStake ASC, s.MinStake ASC, gg.GroupName ASC
							) AS M
			WHERE t.SettingName = 'Stake Level Group' AND t.IsDefault = 1
			
			--SMA Level
			INSERT INTO dbo.Dep_CustStakeLevel_Agent ([CustID],[SportType],[BetType],[StakeLevelList],RepUpdateTime) 
			SELECT t.custid, tb.Sporttype, tb.BettypeID, tb.StakeLevelList,dbo.f_GetDateTime2()
			FROM  #tmpSTList tb
				INNER JOIN  #SMATemp t ON tb.currency = t.Currency

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
				OUTPUT deleted.custid, deleted.Currency INTO #CustTempBatch(custid,Currency)
				FROM #MemberTemp t
				WHERE t.IsFinished = 0

				IF @@ROWCOUNT = 0
					BREAK

				--Member Level
				INSERT INTO dbo.Dep_CustStakeLevel_Member ([CustID],[SportType],[BetType],[StakeLevelList],LastUpdated,RepUpdateTime) 
				SELECT t.custid, tb.Sporttype, tb.BettypeID, tb.Min_StakeLevel,@CurrentDTS,dbo.f_GetDateTime2()
				FROM  #tmpSTList tb
					INNER JOIN  #CustTempBatch t ON tb.currency = t.Currency
			END		
		END

		IF EXISTS( SELECT 1 FROM #TempConfig WHERE SettingName = 'Stake Level' AND IsDefault = 1)
		BEGIN
			INSERT INTO Dep_LicenseeProductSetting(CustID,ProductSettingID,RepUpdateTime)
			SELECT DISTINCT t.CustID,d.ProductSettingID,dbo.f_GetDateTime2()
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

			INSERT INTO #tmpSTList(Sporttype, BettypeID, Currency, Site, StakelevelList, Min_StakeLevel)
			SELECT DISTINCT t.SportType, t.BetType, cu.Currency, si.Site
				, CAST (STUFF (STL, 1,1, '') AS VARCHAR(500)) as StakeLevelList
				, CAST (M.StakeLevelID AS VARCHAR(10)) as Min_StakeLevel
			FROM #TempConfig t
				CROSS APPLY @TBL_Currency cu
				CROSS APPLY @TBL_site si
				CROSS APPLY (SELECT ',' + CAST(StakeLevelID AS VARCHAR(10))
							FROM Dep_StakeLevel S WITH (NOLOCK)
							WHERE S.GameTypeID = t.BetType AND S.ExchangeId = cu.Currency AND s.SiteID = si.SiteID
							FOR XML PATH ('') 
							) AS A(STL)
				CROSS APPLY (SELECT TOP 1 StakeLevelID
							FROM Dep_StakeLevel S WITH (NOLOCK)
								LEFT JOIN GameGroup gg WITH(NOLOCK) 
									ON s.GameGroupID = gg.GameGroupID
							WHERE S.GameTypeID = t.BetType AND S.ExchangeId = cu.Currency AND s.SiteID = si.SiteID
							ORDER BY s.MaxStake ASC, s.MinStake ASC, gg.GroupName ASC
							) AS M
			WHERE t.SettingName = 'Stake Level' AND t.IsDefault = 1
			
			--SMA Level
			INSERT INTO dbo.Dep_CustStakeLevel_Agent ([CustID],[SportType],[BetType],[StakeLevelList],RepUpdateTime) 
			SELECT t.custid, tb.Sporttype, tb.BettypeID, tb.StakeLevelList,dbo.f_GetDateTime2()
			FROM  #tmpSTList tb
				INNER JOIN  #SMATemp t ON tb.currency = t.Currency AND t.Site = tb.Site

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
				OUTPUT deleted.custid, deleted.Currency, deleted.Site INTO #CustTempBatch(custid,Currency,Site)
				FROM #MemberTemp t
				WHERE t.IsFinished = 0

				IF @@ROWCOUNT = 0
					BREAK

				--Member Level
				INSERT INTO dbo.Dep_CustStakeLevel_Member ([CustID],[SportType],[BetType],[StakeLevelList],LastUpdated,RepUpdateTime) 
				SELECT t.custid, tb.Sporttype, tb.BettypeID, tb.Min_StakeLevel,@CurrentDTS,dbo.f_GetDateTime2()
				FROM  #tmpSTList tb
					INNER JOIN  #CustTempBatch t ON tb.currency = t.Currency AND t.Site = tb.Site
			END		

			
		END
		---------------------------------------END : INSERT SETTING----------------------
		------------------Update Status--------------------------------------------------
		IF EXISTS( SELECT 1 FROM #TempConfig WHERE SettingName = 'Product Status' AND IsDefault = 1)
		BEGIN
			INSERT INTO Dep_LicenseeProductSetting(CustID,ProductSettingID,RepUpdateTime)
			SELECT DISTINCT t.CustID,d.ProductSettingID,dbo.f_GetDateTime2()
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
					bitmapIsDisabled = dis.NewBitmap,
					RepUpdateTime = dbo.f_GetDateTime2()
				FROM [dbo].[Dep_CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
					INNER JOIN #SMATemp ci ON cs.CustID = ci.CustID
					CROSS APPLY dbo.f_CustSetting_GenerateProductStatus(cs.bitmapIsHidden,@BitMapOrder,0) as Hid
					CROSS APPLY dbo.f_CustSetting_GenerateProductStatus(cs.bitmapIsDisabled,@BitMapOrder,@IsDisabled) as Dis

				INSERT INTO Dep_CustProductStatus (CustID,bitmapIsDisabled,bitmapIsHidden,RepUpdateTime)
				SELECT	ci.custid, dis.NewBitmap, hid.NewBitmap,dbo.f_GetDateTime2()
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
						bitmapIsDisabled = dis.NewBitmap,
						RepUpdateTime = dbo.f_GetDateTime2()
					FROM [dbo].[Dep_CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
						INNER JOIN #CustTempBatch ci ON cs.CustID = ci.CustID
						CROSS APPLY dbo.f_CustSetting_GenerateProductStatus(cs.bitmapIsHidden,@BitMapOrder,0) as Hid
						CROSS APPLY dbo.f_CustSetting_GenerateProductStatus(cs.bitmapIsDisabled,@BitMapOrder,@IsDisabled) as Dis
				END

				INSERT INTO Dep_CustProductStatus (CustID,bitmapIsDisabled,bitmapIsHidden,RepUpdateTime)
				SELECT	ci.custid, dis.NewBitmap, hid.NewBitmap, dbo.f_GetDateTime2()
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
	DROP TABLE #Supers
	DROP TABLE #TempBetSetting
	DROP TABLE #tmpSTList
	DROP TABLE #CustSettingTmp
	DROP TABLE #CustSettingTmpBatch
END
GO


