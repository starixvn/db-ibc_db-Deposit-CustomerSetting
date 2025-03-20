/*<info serverAlias="DBGLOB-GlobCustDB" executers="wsv_nap" viewers="" isFunction="0" isNested="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_Initial_DCS_SettingConfig_Check]
	@ProductID TINYINT,
	@SportTypeList VARCHAR(MAX), 
	@BetTypeList VARCHAR(MAX),
	@Site VARCHAR(MAX),
	@Currency VARCHAR(MAX),
	@StartTime DATETIME,
	@IsTest	BIT,
	@XMLConfig VARCHAR(MAX) = '',
	@BetSettingXML VARCHAR(MAX) = '',
	@ConfigID INT = NULL,
	@IsWarning BIT = 0 OUTPUT,
	@IsConfirmed BIT = 0
AS
/*
	Created: 20220913@Eden
	Task : Validate when insert update Initial Setting config
	DB: DBGLOB-GlobCustDB
	Original:

	Revisions:  
	- 20220913@Eden: Flexible Initializing Deposit Customer Setting [RedmineID: #169648]
	- 20250120@Tacy: Move to GlobCustDB [RedmineID: #216870]

	Parameter Definition

	Example: 
		DECLARE @IsWarning BIT = 0
		EXEC [Acc_Dep_Initial_DCS_SettingConfig_Check] 
			@ProductID		= 1,
			@SportTypeList = '1,2,43,5,8',
			@BetTypeList = '1,2',
			@Site = '0',
			@Currency = '20',
			@StartTime = '2022/09/18 09:00:00',
			@IsTest = 0,
			@Remark = '',
			@IP = '1.1.1.1',
			@UserId = 8,
			@XMLConfig = '<ROOT>
							  <R ID="1" SportType="1" BetType="1" IsLive="0" SettingType="1" IsDefault="1" DefaultValueSuper="90.00000000" DefaultValueMaster="90.00000000" DefaultValueAgent="90.00000000" DefaultValueMember="90.00000000"/>
							  <R ID="2" SportType="2" BetType="2" IsLive="0" SettingType="1" IsDefault="1" DefaultValueSuper="90.00000000" DefaultValueMaster="90.00000000" DefaultValueAgent="90.00000000" DefaultValueMember="90.00000000" />
							  <R ID="3" SportType="1" BetType="1" IsLive="0" SettingType="10" IsDefault="1" />
							  <R ID="4" SportType="43" BetType="1" IsLive="0" SettingType="10" IsDefault="1" />
							</ROOT>'
			,@BetSettingXML = '<BS>
								  <R ID="1" SportType="1" BetType="1" MinBet="10.0000" MaxBet="100.0000" MaxPerMatch="1000.0000" MaxPayoutPerMatch="10000.0000" Currency="20" SettingType ="10"/>
								  <R ID="2" SportType="43" BetType="1" MinBet="20.0000" MaxBet="200.0000" MaxPerMatch="2000.0000" MaxPayoutPerMatch="20000.0000" Currency="20" SettingType ="10"/>
								</BS>'
			,@IsWarning = @IsWarning OUT
			,@IsConfirmed = 0
			SELECT @IsWarning

	*/
BEGIN
	SET NOCOUNT ON

	DECLARE @ErrType VARCHAR(MAX) = ''

	DECLARE @SporttypeTbl TABLE(SportType SMALLINT)
	DECLARE @BettypeTbl TABLE(BetType SMALLINT)
	DECLARE @TBL_site TABLE(SiteID INT,Site NVARCHAR(50) PRIMARY KEY)
	DECLARE @TBL_Currency TABLE(Currency INT PRIMARY KEY)

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
			,ID
		)
		SELECT Data.SportType
			,Data.BetType
			,ISNULL(Data.IsLive,0)
			,Data.SettingType
			,Data.IsDefault
			,Data.DefaultValueSuper
			,Data.DefaultValueMaster
			,Data.DefaultValueAgent
			,Data.DefaultValueMember
			,Data.SpecialRequirement
			,Data.ID
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
			[ID] [INT]
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
			,[ID]	
			,SettingType
		)
		SELECT Data.SportType			
			,Data.BetType			
			,Data.MinBet				
			,Data.MaxBet				
			,Data.MaxPerMatch		
			,Data.MaxPerNumber		
			,Data.MaxPayoutPerMatch	
			,Data.Currency			
			,Data.[ID]	
			,Data.SettingType	
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
			,[ID] [INT]
			,SettingType TINYINT
		) AS Data

		EXEC sp_xml_removedocument @DocHandler
		-- end read xml	
	END	

	INSERT INTO @SporttypeTbl(SportType)
	SELECT value 
	FROM STRING_SPLIT(@SportTypeList,',') t
	WHERE value <> ''

	INSERT INTO @BettypeTbl(BetType)
	SELECT value 
	FROM STRING_SPLIT(@BetTypeList,',') t
	WHERE value <> ''

	--> Wrong Config
	IF EXISTS(	SELECT 1 
				FROM #TempConfig t
					LEFT JOIN @SporttypeTbl sp
						ON t.SportType = sp.SportType
				WHERE sp.SportType IS NULL
			) 
	BEGIN
		INSERT INTO #ErrorTbl(ID,ErrorCode,ErrorMsg)
		SELECT t.ID
			,ErrCode = 101
			,ErrMsg = 'Wrong sporttype(s): '
		FROM #TempConfig t
			LEFT JOIN @SporttypeTbl sp
				ON t.SportType = sp.SportType
		WHERE sp.SportType IS NULL

		RETURN
	END

	--> Wrong Config
	IF EXISTS(	SELECT 1 
				FROM #TempConfig t
					LEFT JOIN @BettypeTbl sp
						ON t.BetType = sp.BetType
				WHERE sp.BetType IS NULL
			) 
	BEGIN
		INSERT INTO #ErrorTbl(ID,ErrorCode,ErrorMsg)
		SELECT t.ID
			,ErrCode = 102
			,ErrMsg = 'Wrong bettype(s): '
		FROM #TempConfig t
			LEFT JOIN @BettypeTbl sp
				ON t.BetType = sp.BetType
		WHERE sp.BetType IS NULL

		RETURN
	END

	--> Sporttype(s) do not have any config
	SET @ErrType = ''

	SELECT @ErrType =  @ErrType + ', ' + ISNULL(s.SportName,'Sporttype ' + CONVERT(VARCHAR,sp.SportType))
	FROM @SporttypeTbl sp
		LEFT JOIN DBACC.bodb02.dbo.Sports S WITH(NOLOCK) 
			ON sp.SportType = s.SportType
		LEFT JOIN #TempConfig t
			ON t.SportType = sp.SportType
	WHERE t.SportType IS NULL

	IF @ErrType <> ''
	BEGIN
		INSERT INTO #ErrorTbl(ErrorCode,ErrorMsg)
		SELECT ErrCode = 103
			,ErrMsg = 'Sport Type(s) ' + STUFF(@ErrType,1,2,'')+ ' have not been configured. Please config it or remove them.'

		RETURN
	END

	--> Bettype(s) do not have any config
	SET @ErrType = ''

	SELECT @ErrType =  @ErrType + ', ' + CONVERT(VARCHAR,sp.bettype) + '(' + ISNULL(s.typenamee,'Bettype ' + CONVERT(VARCHAR,sp.bettype)) + ')'
	FROM @BettypeTbl sp
		LEFT JOIN DBACC.bodb02.dbo.Bettype S WITH(NOLOCK) 
			ON sp.bettype = s.typeid
		LEFT JOIN #TempConfig t
			ON t.bettype = sp.bettype
	WHERE t.bettype IS NULL

	IF @ErrType <> ''
	BEGIN
		INSERT INTO #ErrorTbl(ErrorCode,ErrorMsg)
		SELECT ErrCode = 104
			,ErrMsg = 'Bettype(s) ' + STUFF(@ErrType,1,2,'')+ ' have not been configured. Please config it or remove them.'

		RETURN
	END

	UPDATE t
	SET t.SettingName = pt.SettingName
	FROM #TempConfig t
		INNER JOIN Dep_ProductSettingType pt WITH(NOLOCK)
			ON t.SettingType = pt.SettingType

	UPDATE t
	SET  DefaultValueSuper = DefaultValueSuper * 100
		,DefaultValueMaster = DefaultValueMaster * 100
		,DefaultValueAgent = DefaultValueAgent * 100
		,DefaultValueMember = DefaultValueMember * 100
	FROM #TempConfig t
	WHERE SettingName = 'Position Taking'

	--> Invalid Setting Type ID
	IF EXISTS(	SELECT 1
				FROM #TempConfig t
				WHERE t.SettingName IS NULL
				)
	BEGIN
		INSERT INTO #ErrorTbl(ID,ErrorCode,ErrorMsg)
		SELECT t.ID
			,ErrCode = 1
			,ErrMsg = 'Invalid Setting Type ID(s): '
		FROM #TempConfig t
		WHERE t.SettingName IS NULL

		RETURN
	END
	
	--> Wrong Config
	IF EXISTS(	SELECT 1
				FROM #TempConfig t
					OUTER APPLY(
						SELECT  p.ProductSettingID 
						FROM Dep_ProductSettingDetail dt WITH(NOLOCK)
							INNER JOIN Dep_ProductSetting p WITH(NOLOCK)
							ON dt.ProductSettingID = p.ProductSettingID
						WHERE t.SportType = dt.SportType
							AND t.BetType= dt.BetType
							AND t.IsLive = dt.IsLive
							AND t.SettingType = p.SettingType
							AND p.ProductID = @ProductID
					) f
				WHERE f.ProductSettingID IS NULL
				)
	BEGIN
		INSERT INTO #ErrorTbl(ID,ErrorCode,ErrorMsg)
		SELECT t.ID
			,ErrCode = 2
			,ErrMsg = 'Wrong Config(s): '
		FROM #TempConfig t
					OUTER APPLY(
						SELECT p.ProductSettingID 
						FROM Dep_ProductSettingDetail dt WITH(NOLOCK)
							INNER JOIN Dep_ProductSetting p WITH(NOLOCK)
							ON dt.ProductSettingID = p.ProductSettingID
						WHERE t.SportType = dt.SportType
							AND t.BetType= dt.BetType
							AND t.IsLive = dt.IsLive
							AND t.SettingType = p.SettingType
							AND p.ProductID = @ProductID
					) f
		WHERE f.ProductSettingID IS NULL

		RETURN
	END

	--> Wrong Config ( Not support default <> 0 yet)
	IF EXISTS(	SELECT 1
				FROM #TempConfig t
				WHERE t.IsDefault = 0
				)
	BEGIN
		INSERT INTO #ErrorTbl(ID,ErrorCode,ErrorMsg)
		SELECT t.ID
			,ErrCode = 2
			,ErrMsg = 'Wrong Config(s): '
		FROM #TempConfig t
		WHERE t.IsDefault = 0

		RETURN
	END
				
	-------------------Other Validation----------------------------
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

	----------Validate Starttime-----------------------------
	IF EXISTS( SELECT 1 FROM Dep_Initial_ProductConfig WITH(NOLOCK) WHERE StartTime = @StartTime AND ConfigID <> ISNULL(@ConfigID,0))
	BEGIN
		INSERT INTO #ErrorTbl(ID,ErrorCode,ErrorMsg)
		SELECT NULL
			,ErrCode = 202
			,ErrMsg = 'There already exists a row with the same time, please choose another time again.'

		RETURN
	END

	IF ISNULL(@site,'') = '' 
	BEGIN
		INSERT INTO #ErrorTbl(ID,ErrorCode,ErrorMsg)
		SELECT NULL
			,ErrCode = 204
			,ErrMsg = 'Site cannot be null.'

		RETURN
	END

	IF ISNULL(@Currency,'') = '' 
	BEGIN
		INSERT INTO #ErrorTbl(ID,ErrorCode,ErrorMsg)
		SELECT NULL
			,ErrCode = 205
			,ErrMsg = 'Currency cannot be null.'

		RETURN
	END

	-------------------Bet Setting Validation----------------------
	IF EXISTS(	SELECT 1
				FROM #TempConfig t
					CROSS JOIN @TBL_Currency c
					LEFT JOIN #TempBetSetting bs 
						ON t.sporttype = bs.sporttype
						AND t.bettype = bs.bettype
						AND t.SettingType= bs.SettingType
						AND c.Currency= bs.Currency
				WHERE bs.sporttype IS NULL
					AND t.settingname = 'Bet Setting'
					)

	BEGIN
		INSERT INTO #BetSettingErrorTbl(ConfigRowID,sporttype,bettype,Currency,ErrCode)
		SELECT t.ID
			,t.sporttype
			,t.bettype
			,c.Currency
			,ErrCode = 401
		FROM #TempConfig t
			CROSS JOIN @TBL_Currency c
			LEFT JOIN #TempBetSetting bs 
				ON t.sporttype = bs.sporttype
				AND t.bettype = bs.bettype
				AND t.SettingType= bs.SettingType
				AND c.Currency= bs.Currency
		WHERE bs.sporttype IS NULL
			AND t.settingname = 'Bet Setting'

		INSERT INTO #ErrorTbl(ErrorCode, ErrorMsg)
		SELECT ErrCode = 401
			,ErrMsg = 'Row <ConfigRowID>: missing row, currency name <currencyname>. Please check again.'

		RETURN
	END
	
	IF EXISTS (	SELECT 1
				FROM #TempBetSetting bs
							OUTER APPLY(
								SELECT t.ID
								FROM #TempConfig t
									CROSS JOIN @TBL_Currency c
								WHERE t.SportType = bs.SportType
									AND t.BetType= bs.BetType
									AND t.SettingType= bs.SettingType
									AND c.Currency = bs.Currency
									AND t.settingname = 'Bet Setting'
							) f
				WHERE f.ID IS NULL
			)
	BEGIN
		INSERT INTO #BetSettingErrorTbl(BSRowID, SettingType, ErrCode)
		SELECT bs.ID
			,bs.SettingType
			,ErrCode = 402
		FROM #TempBetSetting bs
					OUTER APPLY(
						SELECT t.ID
						FROM #TempConfig t
							CROSS JOIN @TBL_Currency c
						WHERE t.SportType = bs.SportType
							AND t.BetType= bs.BetType
							AND t.SettingType= bs.SettingType
							AND c.Currency = bs.Currency
							AND t.settingname = 'Bet Setting'
					) f
		WHERE f.ID IS NULL

		INSERT INTO #ErrorTbl(ErrorCode,ErrorMsg)
		SELECT ErrCode = 402
			,ErrMsg = 'Row <rowID>: invalid. Please check again.'

		RETURN
	END
	
	DECLARE @Dup_BetSetting TABLE(BSRowID INT, ConfigRowID INT, SettingType INT)
	;WITH tmp AS (
		SELECT bs.ID AS BSRowID, t.ID AS ConfigRowID, bs.SettingType, ROW_NUMBER() OVER( PARTITION BY bs.SportType, bs.BetType, bs.Currency, bs.SettingType ORDER BY bs.ID) AS RN
		FROM #TempBetSetting bs
			INNER JOIN #TempConfig t 
				ON t.sporttype = bs.sporttype
				AND t.bettype = bs.bettype
				AND t.SettingType= bs.SettingType
		WHERE t.settingname = 'Bet Setting'
	) 
	INSERT INTO @Dup_BetSetting(BSRowID, ConfigRowID, SettingType)
	SELECT BSRowID, ConfigRowID, SettingType FROM tmp WHERE RN > 1

	IF EXISTS (	SELECT 1 FROM @Dup_BetSetting)
	BEGIN
		INSERT INTO #BetSettingErrorTbl(ConfigRowID, BSRowID, sporttype, bettype, Currency, ErrCode, SettingType)
		SELECT t.ConfigRowID
			,t.BSRowID
			,bs.sporttype
			,bs.bettype
			,bs.Currency
			,ErrCode = 403
			,bs.SettingType
		FROM @Dup_BetSetting t
			INNER JOIN #TempBetSetting bs 
				ON t.BSRowID = bs.ID
				AND t.SettingType= bs.SettingType

		INSERT INTO #ErrorTbl(ErrorCode, ErrorMsg)
		SELECT ErrCode = 403
			,ErrMsg = 'Row <rowID> are duplicated. Please check again.'

		RETURN
	END
	
	--- validate by BetSettingType = 10
	IF EXISTS(	SELECT 1
				FROM #TempConfig t
					CROSS JOIN @TBL_Currency c
					INNER JOIN #TempBetSetting bs 
						ON t.sporttype = bs.sporttype
						AND t.bettype = bs.bettype
						AND t.SettingType= bs.SettingType
						AND c.Currency= bs.Currency
				WHERE t.settingname = 'Bet Setting'
					AND t.settingtype = 10
					AND (bs.MinBet IS NULL OR bs.MaxBet IS NULL OR bs.MaxPerMatch IS NULL OR bs.MaxPayoutPerMatch IS NULL)
		)
	BEGIN
		INSERT INTO #BetSettingErrorTbl(ConfigRowID, BSRowID, sporttype, bettype, Currency, ErrCode, SettingType)
		SELECT t.ID
			,bs.ID
			,t.sporttype
			,t.bettype
			,c.Currency
			,ErrCode = 411
			,t.SettingType
		FROM #TempConfig t
			CROSS JOIN @TBL_Currency c
			INNER JOIN #TempBetSetting bs 
				ON t.sporttype = bs.sporttype
				AND t.bettype = bs.bettype
				AND t.SettingType= bs.SettingType
				AND c.Currency= bs.Currency
		WHERE t.settingname = 'Bet Setting'
			AND t.settingtype = 10
			AND (bs.MinBet IS NULL OR bs.MaxBet IS NULL OR bs.MaxPerMatch IS NULL OR bs.MaxPayoutPerMatch IS NULL)

		INSERT INTO #ErrorTbl(ErrorCode, ErrorMsg)
		SELECT ErrCode = 411
			,ErrMsg = 'Row <rowID>: Sport Type/Bet Type/Currency Name/Min Bet/Max Bet/Max per Match/Max Payout per Match is required info. Please check again.'

		RETURN
	END
	
	IF EXISTS(	SELECT 1
				FROM #TempConfig t
					CROSS JOIN @TBL_Currency c
					INNER JOIN #TempBetSetting bs 
						ON t.sporttype = bs.sporttype
						AND t.bettype = bs.bettype
						AND t.SettingType= bs.SettingType
						AND c.Currency= bs.Currency
				WHERE t.settingname = 'Bet Setting'
					AND t.settingtype = 10
					AND (bs.MinBet < 0 
						 OR bs.MinBet > bs.MaxBet 
						 OR bs.MaxBet > bs.MaxPerMatch 
						 OR bs.MaxPerMatch > bs.MaxPayoutPerMatch)
		)
	BEGIN
		INSERT INTO #BetSettingErrorTbl(ConfigRowID, BSRowID, sporttype, bettype, Currency, ErrCode, SettingType)
		SELECT t.ID
			,bs.ID
			,t.sporttype
			,t.bettype
			,c.Currency
			,ErrCode = 412
			,t.SettingType
		FROM #TempConfig t
			CROSS JOIN @TBL_Currency c
			INNER JOIN #TempBetSetting bs 
				ON t.sporttype = bs.sporttype
				AND t.bettype = bs.bettype
				AND t.SettingType= bs.SettingType
				AND c.Currency= bs.Currency
		WHERE t.settingname = 'Bet Setting'
			AND t.settingtype = 10
			AND (bs.MinBet < 0 
				OR bs.MinBet > bs.MaxBet 
				OR bs.MaxBet > bs.MaxPerMatch 
				OR bs.MaxPerMatch > bs.MaxPayoutPerMatch)

		INSERT INTO #ErrorTbl(ErrorCode, ErrorMsg)
		SELECT ErrCode = 412
			,ErrMsg = 'Row <rowID>: please follow the format "0 <= Min Bet <= Max Bet <= Max per Match <= Max Payout per Match".'
		
		RETURN
	END
	
	IF EXISTS(	SELECT 1
				FROM #TempConfig t
					CROSS JOIN @TBL_Currency c
					INNER JOIN #TempBetSetting bs 
						ON t.sporttype = bs.sporttype
						AND t.bettype = bs.bettype
						AND t.SettingType= bs.SettingType
						AND c.Currency= bs.Currency
				WHERE t.settingname = 'Bet Setting'
					AND t.settingtype = 10
					AND bs.MaxPerNumber IS NOT NULL
		)
	BEGIN
		INSERT INTO #BetSettingErrorTbl(ConfigRowID, BSRowID, sporttype, bettype, Currency, ErrCode, SettingType)
		SELECT t.ID
			,bs.ID
			,t.sporttype
			,t.bettype
			,c.Currency
			,ErrCode = 413
			,t.SettingType
		FROM #TempConfig t
			CROSS JOIN @TBL_Currency c
			INNER JOIN #TempBetSetting bs 
				ON t.sporttype = bs.sporttype
				AND t.bettype = bs.bettype
				AND t.SettingType= bs.SettingType
				AND c.Currency= bs.Currency
		WHERE t.settingname = 'Bet Setting'
			AND t.settingtype = 10
			AND bs.MaxPerNumber IS NOT NULL

		INSERT INTO #ErrorTbl(ErrorCode, ErrorMsg)
		SELECT ErrCode = 413
			,ErrMsg = 'Row <rowID>: only need data for Sport Type, Bet Type, Currency Name, Min Bet, Max Bet, Max per Match, Max Payout per Match. Please check again.'

		RETURN
	END

	--- validate by BetSettingType = 12
	IF EXISTS(	SELECT 1
				FROM #TempConfig t
					CROSS JOIN @TBL_Currency c
					INNER JOIN #TempBetSetting bs 
						ON t.sporttype = bs.sporttype
						AND t.bettype = bs.bettype
						AND t.SettingType= bs.SettingType
						AND c.Currency= bs.Currency
				WHERE t.settingname = 'Bet Setting'
					AND t.settingtype = 12
					AND (bs.MinBet IS NULL OR bs.MaxBet IS NULL OR bs.MaxPerMatch IS NULL OR bs.MaxPerNumber IS NULL)
		)
	BEGIN
		INSERT INTO #BetSettingErrorTbl(ConfigRowID, BSRowID, sporttype, bettype, Currency, ErrCode, SettingType)
		SELECT t.ID
			,bs.ID
			,t.sporttype
			,t.bettype
			,c.Currency
			,ErrCode = 421
			,t.SettingType
		FROM #TempConfig t
			CROSS JOIN @TBL_Currency c
			INNER JOIN #TempBetSetting bs 
				ON t.sporttype = bs.sporttype
				AND t.bettype = bs.bettype
				AND t.SettingType= bs.SettingType
				AND c.Currency= bs.Currency
		WHERE t.settingname = 'Bet Setting'
			AND t.settingtype = 12
			AND (bs.MinBet IS NULL OR bs.MaxBet IS NULL OR bs.MaxPerMatch IS NULL OR bs.MaxPerNumber IS NULL)

		INSERT INTO #ErrorTbl(ErrorCode, ErrorMsg)
		SELECT ErrCode = 421
			,ErrMsg = 'Row <rowID>: Sport Type/Bet Type/Currency Name/Min Bet/Max Bet/Max per Match/Max per Number is required info. Please check again.'

		RETURN
	END
	
	IF EXISTS(	SELECT 1
				FROM #TempConfig t
					CROSS JOIN @TBL_Currency c
					INNER JOIN #TempBetSetting bs 
						ON t.sporttype = bs.sporttype
						AND t.bettype = bs.bettype
						AND t.SettingType= bs.SettingType
						AND c.Currency= bs.Currency
				WHERE t.settingname = 'Bet Setting'
					AND t.settingtype = 12
					AND (bs.MinBet < 0 
						 OR bs.MinBet > bs.MaxBet 
						 OR bs.MaxBet > bs.MaxPerNumber 
						 OR bs.MaxPerNumber > bs.MaxPerMatch)
		)
	BEGIN
		INSERT INTO #BetSettingErrorTbl(ConfigRowID, BSRowID, sporttype, bettype, Currency, ErrCode, SettingType)
		SELECT t.ID
			,bs.ID
			,t.sporttype
			,t.bettype
			,c.Currency
			,ErrCode = 422
			,t.SettingType
		FROM #TempConfig t
			CROSS JOIN @TBL_Currency c
			INNER JOIN #TempBetSetting bs 
				ON t.sporttype = bs.sporttype
				AND t.bettype = bs.bettype
				AND t.SettingType= bs.SettingType
				AND c.Currency= bs.Currency
		WHERE t.settingname = 'Bet Setting'
			AND t.settingtype = 12
			AND (bs.MinBet < 0 
				OR bs.MinBet > bs.MaxBet 
				OR bs.MaxBet > bs.MaxPerNumber 
				OR bs.MaxPerNumber > bs.MaxPerMatch)

		INSERT INTO #ErrorTbl(ErrorCode, ErrorMsg)
		SELECT ErrCode = 422
			,ErrMsg = 'Row <rowID>: please follow the format "0 <= Min Bet <= Max Bet <= Max per Number <= Max per Match".'
		
		RETURN
	END
	
	IF EXISTS(	SELECT 1
				FROM #TempConfig t
					CROSS JOIN @TBL_Currency c
					INNER JOIN #TempBetSetting bs 
						ON t.sporttype = bs.sporttype
						AND t.bettype = bs.bettype
						AND t.SettingType= bs.SettingType
						AND c.Currency= bs.Currency
				WHERE t.settingname = 'Bet Setting'
					AND t.settingtype = 12
					AND bs.MaxPayoutPerMatch IS NOT NULL
		)
	BEGIN
		INSERT INTO #BetSettingErrorTbl(ConfigRowID, BSRowID, sporttype, bettype, Currency, ErrCode, SettingType)
		SELECT t.ID
			,bs.ID
			,t.sporttype
			,t.bettype
			,c.Currency
			,ErrCode = 423
			,t.SettingType
		FROM #TempConfig t
			CROSS JOIN @TBL_Currency c
			INNER JOIN #TempBetSetting bs 
				ON t.sporttype = bs.sporttype
				AND t.bettype = bs.bettype
				AND t.SettingType= bs.SettingType
				AND c.Currency= bs.Currency
		WHERE t.settingname = 'Bet Setting'
			AND t.settingtype = 12
			AND bs.MaxPayoutPerMatch IS NOT NULL

		INSERT INTO #ErrorTbl(ErrorCode, ErrorMsg)
		SELECT ErrCode = 423
			,ErrMsg = 'Row <rowID>: only need data for Sport Type, Bet Type, Currency Name, Min Bet, Max Bet, Max per Match, Max per Number. Please check again.'

		RETURN
	END

	--- validate by BetSettingType = 2
	IF EXISTS(	SELECT 1
				FROM #TempConfig t
					CROSS JOIN @TBL_Currency c
					INNER JOIN #TempBetSetting bs 
						ON t.sporttype = bs.sporttype
						AND t.bettype = bs.bettype
						AND t.SettingType= bs.SettingType
						AND c.Currency= bs.Currency
				WHERE t.settingname = 'Bet Setting'
					AND t.settingtype = 2
					AND (bs.MinBet IS NULL OR bs.MaxBet IS NULL OR bs.MaxPerMatch IS NULL)
		)
	BEGIN
		INSERT INTO #BetSettingErrorTbl(ConfigRowID, BSRowID, sporttype, bettype, Currency, ErrCode, SettingType)
		SELECT t.ID
			,bs.ID
			,t.sporttype
			,t.bettype
			,c.Currency
			,ErrCode = 431
			,t.SettingType
		FROM #TempConfig t
			CROSS JOIN @TBL_Currency c
			INNER JOIN #TempBetSetting bs 
				ON t.sporttype = bs.sporttype
				AND t.bettype = bs.bettype
				AND t.SettingType= bs.SettingType
				AND c.Currency= bs.Currency
		WHERE t.settingname = 'Bet Setting'
			AND t.settingtype = 2
			AND (bs.MinBet IS NULL OR bs.MaxBet IS NULL OR bs.MaxPerMatch IS NULL)

		INSERT INTO #ErrorTbl(ErrorCode, ErrorMsg)
		SELECT ErrCode = 431
			,ErrMsg = 'Row <rowID>: Sport Type/Bet Type/Currency Name/Min Bet/Max Bet/Max per Match is required info. Please check again.'

		RETURN
	END
	
	IF EXISTS(	SELECT 1
				FROM #TempConfig t
					CROSS JOIN @TBL_Currency c
					INNER JOIN #TempBetSetting bs 
						ON t.sporttype = bs.sporttype
						AND t.bettype = bs.bettype
						AND t.SettingType= bs.SettingType
						AND c.Currency= bs.Currency
				WHERE t.settingname = 'Bet Setting'
					AND t.settingtype = 2
					AND (bs.MinBet < 0 
						 OR bs.MinBet > bs.MaxBet 
						 OR bs.MaxBet > bs.MaxPerMatch)
		)
	BEGIN
		INSERT INTO #BetSettingErrorTbl(ConfigRowID, BSRowID, sporttype, bettype, Currency, ErrCode, SettingType)
		SELECT t.ID
			,bs.ID
			,t.sporttype
			,t.bettype
			,c.Currency
			,ErrCode = 432
			,t.SettingType
		FROM #TempConfig t
			CROSS JOIN @TBL_Currency c
			INNER JOIN #TempBetSetting bs 
				ON t.sporttype = bs.sporttype
				AND t.bettype = bs.bettype
				AND t.SettingType= bs.SettingType
				AND c.Currency= bs.Currency
		WHERE t.settingname = 'Bet Setting'
			AND t.settingtype = 2
			AND (bs.MinBet < 0 
				OR bs.MinBet > bs.MaxBet 
				OR bs.MaxBet > bs.MaxPerMatch )

		INSERT INTO #ErrorTbl(ErrorCode, ErrorMsg)
		SELECT ErrCode = 432
			,ErrMsg = 'Row <rowID>: please follow the format "0 <= Min Bet <= Max Bet <= Max per Match".'
		
		RETURN
	END
	
	IF EXISTS(	SELECT 1
				FROM #TempConfig t
					CROSS JOIN @TBL_Currency c
					INNER JOIN #TempBetSetting bs 
						ON t.sporttype = bs.sporttype
						AND t.bettype = bs.bettype
						AND t.SettingType= bs.SettingType
						AND c.Currency= bs.Currency
				WHERE t.settingname = 'Bet Setting'
					AND t.settingtype = 2
					AND (bs.MaxPayoutPerMatch IS NOT NULL OR bs.MaxPerNumber IS NOT NULL)

		)
	BEGIN
		INSERT INTO #BetSettingErrorTbl(ConfigRowID, BSRowID, sporttype, bettype, Currency, ErrCode, SettingType)
		SELECT t.ID
			,bs.ID
			,t.sporttype
			,t.bettype
			,c.Currency
			,ErrCode = 433
			,t.SettingType
		FROM #TempConfig t
			CROSS JOIN @TBL_Currency c
			INNER JOIN #TempBetSetting bs 
				ON t.sporttype = bs.sporttype
				AND t.bettype = bs.bettype
				AND t.SettingType= bs.SettingType
				AND c.Currency= bs.Currency
		WHERE t.settingname = 'Bet Setting'
			AND t.settingtype = 2
			AND (bs.MaxPayoutPerMatch IS NOT NULL OR bs.MaxPerNumber IS NOT NULL)

		INSERT INTO #ErrorTbl(ErrorCode, ErrorMsg)
		SELECT ErrCode = 433
			,ErrMsg = 'Row <rowID>: only need data for Sport Type, Bet Type, Currency Name, Min Bet, Max Bet, Max per Match. Please check again.'

		RETURN
	END

	--- validate by BetSettingType = 11
	IF EXISTS(	SELECT 1
				FROM #TempConfig t
					CROSS JOIN @TBL_Currency c
					INNER JOIN #TempBetSetting bs 
						ON t.sporttype = bs.sporttype
						AND t.bettype = bs.bettype
						AND t.SettingType= bs.SettingType
						AND c.Currency= bs.Currency
				WHERE t.settingname = 'Bet Setting'
					AND t.settingtype = 11
					AND (bs.MinBet IS NULL OR bs.MaxBet IS NULL)
		)
	BEGIN
		INSERT INTO #BetSettingErrorTbl(ConfigRowID, BSRowID, sporttype, bettype, Currency, ErrCode, SettingType)
		SELECT t.ID
			,bs.ID
			,t.sporttype
			,t.bettype
			,c.Currency
			,ErrCode = 441
			,t.SettingType
		FROM #TempConfig t
			CROSS JOIN @TBL_Currency c
			INNER JOIN #TempBetSetting bs 
				ON t.sporttype = bs.sporttype
				AND t.bettype = bs.bettype
				AND t.SettingType= bs.SettingType
				AND c.Currency= bs.Currency
		WHERE t.settingname = 'Bet Setting'
			AND t.settingtype = 11
			AND (bs.MinBet IS NULL OR bs.MaxBet IS NULL)

		INSERT INTO #ErrorTbl(ErrorCode, ErrorMsg)
		SELECT ErrCode = 441
			,ErrMsg = 'Row <rowID>: Sport Type/Bet Type/Currency Name/Min Bet/Max Bet is required info. Please check again.'

		RETURN
	END
	
	IF EXISTS(	SELECT 1
				FROM #TempConfig t
					CROSS JOIN @TBL_Currency c
					INNER JOIN #TempBetSetting bs 
						ON t.sporttype = bs.sporttype
						AND t.bettype = bs.bettype
						AND t.SettingType= bs.SettingType
						AND c.Currency= bs.Currency
				WHERE t.settingname = 'Bet Setting'
					AND t.settingtype = 11
					AND (bs.MinBet < 0 
						 OR bs.MinBet > bs.MaxBet )
		)
	BEGIN
		INSERT INTO #BetSettingErrorTbl(ConfigRowID, BSRowID, sporttype, bettype, Currency, ErrCode, SettingType)
		SELECT t.ID
			,bs.ID
			,t.sporttype
			,t.bettype
			,c.Currency
			,ErrCode = 442
			,t.SettingType
		FROM #TempConfig t
			CROSS JOIN @TBL_Currency c
			INNER JOIN #TempBetSetting bs 
				ON t.sporttype = bs.sporttype
				AND t.bettype = bs.bettype
				AND t.SettingType= bs.SettingType
				AND c.Currency= bs.Currency
		WHERE t.settingname = 'Bet Setting'
			AND t.settingtype = 11
			AND (bs.MinBet < 0 
				OR bs.MinBet > bs.MaxBet)

		INSERT INTO #ErrorTbl(ErrorCode, ErrorMsg)
		SELECT ErrCode = 442
			,ErrMsg = 'Row <rowID>: please follow the format "0 <= Min Bet <= Max Bet".'
		
		RETURN
	END
	
	IF EXISTS(	SELECT 1
				FROM #TempConfig t
					CROSS JOIN @TBL_Currency c
					INNER JOIN #TempBetSetting bs 
						ON t.sporttype = bs.sporttype
						AND t.bettype = bs.bettype
						AND t.SettingType= bs.SettingType
						AND c.Currency= bs.Currency
				WHERE t.settingname = 'Bet Setting'
					AND t.settingtype = 11
					AND (bs.MaxPayoutPerMatch IS NOT NULL OR bs.MaxPerNumber IS NOT NULL OR bs.MaxPerMatch IS NOT NULL)

		)
	BEGIN
		INSERT INTO #BetSettingErrorTbl(ConfigRowID, BSRowID, sporttype, bettype, Currency, ErrCode, SettingType)
		SELECT t.ID
			,bs.ID
			,t.sporttype
			,t.bettype
			,c.Currency
			,ErrCode = 443
			,t.SettingType
		FROM #TempConfig t
			CROSS JOIN @TBL_Currency c
			INNER JOIN #TempBetSetting bs 
				ON t.sporttype = bs.sporttype
				AND t.bettype = bs.bettype
				AND t.SettingType= bs.SettingType
				AND c.Currency= bs.Currency
		WHERE t.settingname = 'Bet Setting'
			AND t.settingtype = 11
			AND (bs.MaxPayoutPerMatch IS NOT NULL OR bs.MaxPerNumber IS NOT NULL OR bs.MaxPerMatch IS NOT NULL)

		INSERT INTO #ErrorTbl(ErrorCode, ErrorMsg)
		SELECT ErrCode = 443
			,ErrMsg = 'Row <rowID>: only need data for Sport Type, Bet Type, Currency Name, Min Bet, Max Bet. Please check again.'

		RETURN
	END
	----------Validate duplicate config-----------------------------
	DECLARE @ExistingConfig TABLE( ConfigID INT PRIMARY KEY)
	DECLARE @TmpStatus TINYINT
	SET @IsWarning = 0

	INSERT INTO @ExistingConfig(ConfigID)
	SELECT DISTINCT d.ConfigID
	FROM Dep_Initial_ProductConfig_Detail d WITH(NOLOCK)
		INNER JOIN #TempConfig t 
			ON t.SportType = d.SportType
			AND t.BetType = d.BetType
			AND t.SettingType = d.SettingType
			AND ConfigID <> ISNULL(@ConfigID,0)

	IF EXISTS( SELECT 1 FROM @ExistingConfig)
	BEGIN 
			SELECT TOP(1) @TmpStatus = cf.Status
			FROM Dep_Initial_ProductConfig cf WITH(NOLOCK)
				INNER JOIN @ExistingConfig t ON cf.ConfigID = t.ConfigID
				CROSS APPLY STRING_SPLIT(cf.Site,',') s 
				INNER JOIN @TBL_site ts ON s.value = ts.SiteID OR cf.Site = '0'
				CROSS APPLY STRING_SPLIT(cf.Currency,',') cr 
				INNER JOIN @TBL_Currency tcr ON cr.value = tcr.Currency OR cf.Currency = '0'
			ORDER BY cf.Status
			OPTION (MAXRECURSION 0)
	
			IF @TmpStatus IN (0,1) --Planned, Running
			BEGIN
				INSERT INTO #ErrorTbl(ID,ErrorCode,ErrorMsg)
				SELECT NULL
					,ErrCode = 203
					,ErrMsg = 'This product with the same Site, Currency, Sport, Bet Type, Setting Type already exists. Please change them again.'

				RETURN
			END
			ELSE IF @IsConfirmed = 0 AND @TmpStatus = 2 -- completed
			BEGIN
				SET @IsWarning = 1
			END
	END 
	----------------------------------------------------------------
	
END
GO


