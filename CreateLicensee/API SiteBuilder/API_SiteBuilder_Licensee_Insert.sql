/*<info serverAlias="DBCUST-CustDB" executers="asv_cust" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[API_SiteBuilder_Licensee_Insert]
	@Customers_List		VARCHAR(MAX) = NULL,
	@ProductBetSetting	VARCHAR(MAX)= NULL,
	@ProductPT			VARCHAR(MAX)= NULL,
	@ProductStakeLevel	VARCHAR(MAX)= NULL,
	@ProductComm		VARCHAR(MAX)= NULL,
	@Creator			VARCHAR(20),
	@IP					VARCHAR(50),	
	@IsCreateSub		BIT,
	@LicenseeType		VARCHAR(50),
	@IsChinaView		BIT = NULL,
	@sitename			VARCHAR(10)= NULL,
	@SiteID				INT = NULL,
	@SpecialPlatform	TINYINT = NULL,
	@Mode				TINYINT = 1, -- 1: New Licensee, 2: New Currency
	@ErrCode			INT = 0	OUTPUT,
	@ErrMsg				NVARCHAR(MAX) = ''	OUTPUT,
	@ErrExtraInfo VARCHAR(MAX) = '' OUTPUT, -- Log DB
	@InsBalExceptCustList VARCHAR(MAX) = '' OUTPUT, --List dummy account need to add to exception balance table
	@FailedCurrencies VARCHAR(MAX) = '' OUTPUT, --List failed currency show to TW
	@ListSuperRollBack VARCHAR(MAX) = '' OUTPUT, --List super need to rollback data globcustDB
	@ProductList VARCHAR(MAX) = '' OUTPUT, --List product need to init data on db licensee
	@CurrencyList VARCHAR(MAX) = '' OUTPUT, --List currency need to init data on db licensee
	@PT_Sportsbook	SMALLMONEY = 0 OUTPUT,
	@AgentList VARCHAR(MAX) = '' OUTPUT, -- List Agent01 need to create dummy 
	@SettingStatus TINYINT = 0
AS
/*
	Created: 20240705@Eden  
	Task : SiteBuider --> Insert customer setting on maindb
	DB:  DBCUST-CustDB
	Original sp: 
	
	Revisions: 
		- 20240705@Eden  : Scale out DBCUST - Licensee Customer in GlobCustDB [redmine: #207474]
		- 20241009@Helios  : Scale out DBCUST - Licensee Customer in GlobCustDB [redmine: #207474]

	Param's Explanation: 
	Sample:
		DECLARE @ErrCode INT = 0 , @ErrMsg NVARCHAR(2000) = ''
			,@FailedCurrencies VARCHAR(MAX) = '' ,@ListSuperRollBack VARCHAR(MAX) = '',@InsBalExceptCustList varchar(MAX) = ''
		EXEC [API_SiteBuilder_Licensee_Insert]
			  @Customers_List = '[{"CustID":148596221,"username":"Edentest1SuperGBP","recommend":0,"mrecommend":0,"srecommend":148596221,"roleid":4,"Currency":12,"CurrencyName":"GBP"}
								,{"CustID":148596222,"username":"Edentest1GBP","recommend":0,"mrecommend":148596222,"srecommend":148596221,"roleid":3,"Currency":12,"CurrencyName":"GBP"}
								,{"CustID":148596223,"username":"Edentest1GBP01","recommend":148596223,"mrecommend":148596222,"srecommend":148596221,"roleid":2,"Currency":12,"CurrencyName":"GBP"}
								,{"CustID":148596224,"username":"Edentest1ACCGBP","recommend":0,"mrecommend":148596224,"srecommend":148596221,"roleid":3,"Currency":12,"CurrencyName":"GBP"}
								,{"CustID":148596225,"username":"Edentest1ACCGBP01","recommend":148596225,"mrecommend":148596224,"srecommend":148596221,"roleid":2,"Currency":12,"CurrencyName":"GBP"}
								,{"CustID":148596226,"username":"Edentest1GBP01ClearBal","recommend":148596223,"mrecommend":148596222,"srecommend":148596221,"roleid":1,"Currency":12,"CurrencyName":"GBP"}
								,{"CustID":148596227,"username":"Edentest1TransferGBP","recommend":148596225,"mrecommend":148596224,"srecommend":148596221,"roleid":1,"Currency":12,"CurrencyName":"GBP"}
								,{"CustID":148596228,"username":"Edentest1ChargesGBP","recommend":148596225,"mrecommend":148596224,"srecommend":148596221,"roleid":1,"Currency":12,"CurrencyName":"GBP"}
								,{"CustID":148596229,"username":"Edentest1BonusGBP","recommend":148596225,"mrecommend":148596224,"srecommend":148596221,"roleid":1,"Currency":12,"CurrencyName":"GBP"}
								,{"CustID":148596230,"username":"Edentest1Bonus02GBP","recommend":148596225,"mrecommend":148596224,"srecommend":148596221,"roleid":1,"Currency":12,"CurrencyName":"GBP"}
								,{"CustID":148596231,"username":"Edentest1WithdrawalGBP","recommend":148596225,"mrecommend":148596224,"srecommend":148596221,"roleid":1,"Currency":12,"CurrencyName":"GBP"}
								,{"CustID":148596232,"username":"Edentest1Dummy3rdGBP","recommend":148596225,"mrecommend":148596224,"srecommend":148596221,"roleid":1,"Currency":12,"CurrencyName":"GBP"}
								,{"CustID":148596233,"username":"Edentest1GBP02","recommend":148596233,"mrecommend":148596222,"srecommend":148596221,"roleid":2,"Currency":12,"CurrencyName":"GBP"}
								,{"CustID":148596234,"username":"Edentest1GBP03","recommend":148596234,"mrecommend":148596222,"srecommend":148596221,"roleid":2,"Currency":12,"CurrencyName":"GBP"}
								,{"CustID":148596235,"username":"Edentest1GBP04","recommend":148596235,"mrecommend":148596222,"srecommend":148596221,"roleid":2,"Currency":12,"CurrencyName":"GBP"}
								,{"CustID":148596236,"username":"Edentest1GBP05","recommend":148596236,"mrecommend":148596222,"srecommend":148596221,"roleid":2,"Currency":12,"CurrencyName":"GBP"}
								,{"CustID":148596237,"username":"Edentest1GBP06","recommend":148596237,"mrecommend":148596222,"srecommend":148596221,"roleid":2,"Currency":12,"CurrencyName":"GBP"}
								,{"CustID":148596238,"username":"Edentest1GBP07","recommend":148596238,"mrecommend":148596222,"srecommend":148596221,"roleid":2,"Currency":12,"CurrencyName":"GBP"}
								,{"CustID":148596239,"username":"Edentest1GBP08","recommend":148596239,"mrecommend":148596222,"srecommend":148596221,"roleid":2,"Currency":12,"CurrencyName":"GBP"}
								,{"CustID":148596240,"username":"Edentest1GBP09","recommend":148596240,"mrecommend":148596222,"srecommend":148596221,"roleid":2,"Currency":12,"CurrencyName":"GBP"}
								,{"CustID":148596241,"username":"Edentest1GBP10","recommend":148596241,"mrecommend":148596222,"srecommend":148596221,"roleid":2,"Currency":12,"CurrencyName":"GBP"}
								,{"CustID":148596242,"username":"Edentest1GBP11","recommend":148596242,"mrecommend":148596222,"srecommend":148596221,"roleid":2,"Currency":12,"CurrencyName":"GBP"}
								,{"CustID":148596243,"username":"Edentest1SuperTB","recommend":0,"mrecommend":0,"srecommend":148596243,"roleid":4,"Currency":4,"CurrencyName":"TB"}
								,{"CustID":148596244,"username":"Edentest1TB","recommend":0,"mrecommend":148596244,"srecommend":148596243,"roleid":3,"Currency":4,"CurrencyName":"TB"},{"CustID":148596245,"username":"Edentest1TB01","recommend":148596245,"mrecommend":148596244,"srecommend":148596243,"roleid":2,"Currency":4,"CurrencyName":"TB"},{"CustID":148596246,"username":"Edentest1ACCTB","recommend":0,"mrecommend":148596246,"srecommend":148596243,"roleid":3,"Currency":4,"CurrencyName":"TB"},{"CustID":148596247,"username":"Edentest1ACCTB01","recommend":148596247,"mrecommend":148596246,"srecommend":148596243,"roleid":2,"Currency":4,"CurrencyName":"TB"},{"CustID":148596248,"username":"Edentest1TB01ClearBal","recommend":148596245,"mrecommend":148596244,"srecommend":148596243,"roleid":1,"Currency":4,"CurrencyName":"TB"},{"CustID":148596249,"username":"Edentest1TransferTB","recommend":148596247,"mrecommend":148596246,"srecommend":148596243,"roleid":1,"Currency":4,"CurrencyName":"TB"},{"CustID":148596250,"username":"Edentest1ChargesTB","recommend":148596247,"mrecommend":148596246,"srecommend":148596243,"roleid":1,"Currency":4,"CurrencyName":"TB"},{"CustID":148596251,"username":"Edentest1BonusTB","recommend":148596247,"mrecommend":148596246,"srecommend":148596243,"roleid":1,"Currency":4,"CurrencyName":"TB"},{"CustID":148596252,"username":"Edentest1Bonus02TB","recommend":148596247,"mrecommend":148596246,"srecommend":148596243,"roleid":1,"Currency":4,"CurrencyName":"TB"},{"CustID":148596253,"username":"Edentest1WithdrawalTB","recommend":148596247,"mrecommend":148596246,"srecommend":148596243,"roleid":1,"Currency":4,"CurrencyName":"TB"},{"CustID":148596254,"username":"Edentest1Dummy3rdTB","recommend":148596247,"mrecommend":148596246,"srecommend":148596243,"roleid":1,"Currency":4,"CurrencyName":"TB"},{"CustID":148596255,"username":"Edentest1TB02","recommend":148596255,"mrecommend":148596244,"srecommend":148596243,"roleid":2,"Currency":4,"CurrencyName":"TB"},{"CustID":148596256,"username":"Edentest1TB03","recommend":148596256,"mrecommend":148596244,"srecommend":148596243,"roleid":2,"Currency":4,"CurrencyName":"TB"},{"CustID":148596257,"username":"Edentest1TB04","recommend":148596257,"mrecommend":148596244,"srecommend":148596243,"roleid":2,"Currency":4,"CurrencyName":"TB"},{"CustID":148596258,"username":"Edentest1TB05","recommend":148596258,"mrecommend":148596244,"srecommend":148596243,"roleid":2,"Currency":4,"CurrencyName":"TB"},{"CustID":148596259,"username":"Edentest1TB06","recommend":148596259,"mrecommend":148596244,"srecommend":148596243,"roleid":2,"Currency":4,"CurrencyName":"TB"},{"CustID":148596260,"username":"Edentest1TB07","recommend":148596260,"mrecommend":148596244,"srecommend":148596243,"roleid":2,"Currency":4,"CurrencyName":"TB"},{"CustID":148596261,"username":"Edentest1TB08","recommend":148596261,"mrecommend":148596244,"srecommend":148596243,"roleid":2,"Currency":4,"CurrencyName":"TB"},{"CustID":148596262,"username":"Edentest1TB09","recommend":148596262,"mrecommend":148596244,"srecommend":148596243,"roleid":2,"Currency":4,"CurrencyName":"TB"},{"CustID":148596263,"username":"Edentest1TB10","recommend":148596263,"mrecommend":148596244,"srecommend":148596243,"roleid":2,"Currency":4,"CurrencyName":"TB"}
								,{"CustID":148596264,"username":"Edentest1TB11","recommend":148596264,"mrecommend":148596244,"srecommend":148596243,"roleid":2,"Currency":4,"CurrencyName":"TB"}
								]'
			,@sitename = 'Edentest1'
			,@IP = '1.1.1.1'
			,@ProductBetSetting = ''
			,@ProductPT = ''
			,@ProductStakeLevel = ''
			,@Creator = 'Edentest'
			,@IsCreateSub = 1
			,@LicenseeType = 'Boping'
			,@IsChinaView = 1
			,@SpecialPlatform = 0
			,@ErrCode			= @ErrCode OUTPUT
			,@ErrMsg			= @ErrMsg OUTPUT
			,@FailedCurrencies = @FailedCurrencies OUT
			,@ListSuperRollBack = @ListSuperRollBack OUT
			,@InsBalExceptCustList = @InsBalExceptCustList OUT

		SELECT  @ErrCode		AS ErrCode		
				,@ErrMsg		AS ErrMsg
				,@FailedCurrencies AS FailedCurrencies 
				,@ListSuperRollBack AS ListSuperRollBack
				,@InsBalExceptCustList AS InsBalExceptCustList
*/			   					
BEGIN
	SET NOCOUNT ON
	--Step: Create fullline customer
	EXEC [API_SiteBuilder_InsCustomer_FullLine]
		 @Customers_List		= @Customers_List OUTPUT
		,@sitename				= @sitename
		,@IP					= @IP
		,@ErrCode				= @ErrCode OUTPUT
		,@ErrMsg				= @ErrMsg OUTPUT
		,@InsBalExceptCustList	= @InsBalExceptCustList OUTPUT
		,@FailedCurrencies		= @FailedCurrencies OUTPUT
		,@ListSuperRollBack		= @ListSuperRollBack OUTPUT
		,@ErrExtraInfo			= @ErrExtraInfo OUTPUT

	IF @ErrCode <> 0
	BEGIN
		RETURN
	END

	CREATE TABLE #CustomerList(CustID INT, username VARCHAR(30), recommend INT, mrecommend INT, srecommend INT
					, roleid tinyint, Currency INT, CurrencyName NVARCHAR(50), isfinished BIT DEFAULT 0)
	DECLARE @tmpStakeLevel TABLE(Currency INT, GameTypeID INT, MinStake DECIMAL(19,8), MaxStake DECIMAL(19,8));
	DECLARE @tmpPT TABLE(ProductID INT, PT SMALLMONEY);
	DECLARE @tmpComm TABLE(ProductID INT, Comm DECIMAL(9,8));
	DECLARE @tmpBetSetting TABLE(ProductID INT,Currency INT,Sporttype INT,Bettype INT
			,MinBet MONEY,MaxBet MONEY,MaxPerMatch MONEY,MaxPerNumber MONEY,MaxPayoutPerMatch MONEY)

	CREATE TABLE #Product(
		ProductID INT, Currency INT, Sporttype INT, Bettype INT 
		, MinBet MONEY, MaxBet MONEY, MaxPerMatch MONEY, MaxPerNumber MONEY, MaxPayoutPerMatch MONEY
		, StakeLevelID INT, PT SMALLMONEY, ProductName VARCHAR(100), Comm DECIMAL(9,8)
		, BetLimitSettingType TINYINT, StakeLevelSettingType TINYINT, PTSettingType TINYINT, CommSettingType TINYINT
		, isfinished BIT DEFAULT 0
	)

	CREATE TABLE #SportsStatus(ProductID INT,Sporttype INT,Bettype INT,bitmapOrder INT,IsDisable BIT,IsDisableDownLine BIT,HasDownline BIT,IsDisableUpline BIT)
	CREATE TABLE #TmpAgentList(CustID INT, isfinished BIT DEFAULT(0))
	DECLARE @LogInfo_Tbl TABLE(UserID INT, CustID INT, ActionID INT, TrackingValue VARCHAR(MAX), TrackingValue2 VARCHAR(MAX))
	DECLARE @TempError TABLE (ErrMsg VARCHAR(MAX))
	CREATE TABLE #SportBettypeSetting(ProductID	smallint,SportType smallint,Bettype smallint,IsLive bit,SettingType	tinyint,SettingName	VARCHAR(30))
	CREATE CLUSTERED INDEX IX_TmpSportBettypeSetting ON #SportBettypeSetting(SettingType,ProductID)

	BEGIN TRY
		INSERT INTO #CustomerList(CustID,username,recommend,mrecommend,srecommend,roleid,Currency,CurrencyName)
		SELECT CustID,username,recommend,mrecommend,srecommend,roleid,Currency,CurrencyName
		FROM OPENJSON(@Customers_List) WITH (
						 CustID		INT  '$.CustID'
						,username	VARCHAR(30)	'$.username'
						,recommend	INT	'$.recommend'
						,mrecommend INT	'$.mrecommend'
						,srecommend INT	'$.srecommend'
						,roleid		tinyint	'$.roleid'
						,Currency	INT	'$.Currency'
						,CurrencyName	NVARCHAR(50) '$.CurrencyName'
					)

		INSERT INTO @tmpStakeLevel(Currency, GameTypeID, MinStake, MaxStake)
		SELECT Currency, GameTypeID, MinStake, MaxStake
		FROM OPENJSON(@ProductStakeLevel) WITH (
						 Currency INT  '$.Currency'
						,GameTypeID INT	'$.GameTypeID'
						,MinStake DECIMAL(19,8)  '$.MinStake'
						,MaxStake DECIMAL(19,8)  '$.MaxStake'
					)

		INSERT INTO @tmpPT(ProductID, PT)
		SELECT ProductID, PT
		FROM OPENJSON(@ProductPT) WITH (
						 ProductID INT  '$.ProductID'
						,PT SMALLMONEY	'$.PT'
					)

		INSERT INTO @tmpComm(ProductID, Comm)
		SELECT ProductID, Comm
		FROM OPENJSON(@ProductComm) WITH (
						 ProductID INT  '$.ProductID'
						,Comm DECIMAL(9,8)	'$.Comm'
					)

		INSERT INTO @tmpBetSetting(ProductID, Currency, Sporttype,Bettype,MinBet,MaxBet,MaxPerMatch,MaxPerNumber,MaxPayoutPerMatch)
		SELECT ProductID, Currency, Sporttype,Bettype,MinBet,MaxBet,MPM,MPB
			,MPPM = CASE WHEN ProductID = 1 THEN ISNULL(MPPM, MPM * 8) ELSE MPPM END -- if SB do not input MaxPayoutPerMatch yet, set = MaxPerMatch * 8 by default
		FROM OPENJSON(@ProductBetSetting) WITH (
						 ProductID INT  '$.ProductID'
						,Currency INT	'$.Currency'
						,Sporttype INT	'$.Sporttype'
						,Bettype INT	'$.Bettype'
						,MinBet MONEY	'$.MinBet'
						,MaxBet MONEY	'$.MaxBet'
						,MPM MONEY	'$.MPM'
						,MPB MONEY	'$.MPB'
						,MPPM MONEY '$.MPPM'
					)
	END TRY
	BEGIN CATCH
		SELECT  @ErrMsg = N'Invalid Json Input'	, @ErrCode = 3 ;	
		RETURN
	END CATCH

	INSERT INTO #SportBettypeSetting(ProductID,SportType,Bettype,IsLive	,SettingType,SettingName)
	SELECT sp.ProductID,sp.SportType,sp.Bettype,sp.IsLive,sp.SettingType,pt.SettingName
	FROM dbo.f_Dep_CustSetting_SportBetTypeSettingSelect(NULL,NULL,@SettingStatus)  sp
		INNER JOIN Dep_ProductSettingType pt WITH(NOLOCK) ON sp.SettingType = pt.SettingType

	INSERT INTO #Product(ProductID ,Currency ,MinBet ,MaxBet ,MaxPerMatch ,MaxPerNumber,MaxPayoutPerMatch,Sporttype,Bettype, PT, ProductName, Comm)
	SELECT pt.ProductID ,bs.Currency ,bs.MinBet ,bs.MaxBet ,bs.MaxPerMatch ,bs.MaxPerNumber,bs.MaxPayoutPerMatch ,bs.Sporttype ,bs.Bettype
		,pt.PT, p.ProductName, co.Comm
	FROM @tmpPT pt
		INNER JOIN @tmpBetSetting bs ON bs.ProductID = pt.ProductID
		LEFT JOIN Products p WITH(NOLOCK) ON pt.ProductID = p.ProductID
		INNER JOIN #CustomerList ci ON ci.currency = bs.currency AND ci.roleid = 4
		LEFT JOIN @tmpComm co ON pt.ProductID = co.ProductID
	-------------------------------------------------------------------------------------------------
	DECLARE @CurrencyName NVARCHAR(50), @Currency INT ,@Super_RollBack VARCHAR(MAX) = '', @srecommend INT, @AgentID INT,
		@ProductID INT, @SporttypeID INT, @BettypeID INT, @bitmapOrder INT, @BetLimit VARCHAR(MAX), @PT_XML VARCHAR(MAX), @PT SMALLMONEY, @Discount_XML VARCHAR(MAX),
		@ProductName VARCHAR(100) = '', @CreatorID INT = 10278938, @Comm DECIMAL(9,8),
		@BetLimitSettingType TINYINT, @StakeLevelSettingType TINYINT, @PTSettingType TINYINT, @CommSettingType TINYINT,
		@StakelevelXML VARCHAR(MAX) = '', @TrackingValue VARCHAR(MAX) = '', @LogXML XML, @ActionID INT

	IF @Mode = 1 -- Create New Licensee
	BEGIN
		SELECT @ActionID = 271003
	END
	ELSE 
	BEGIN
		SELECT @ActionID = 271004
			, @IsChinaView = NULL, @SpecialPlatform = NULL -- no need to log those values
	END

	UPDATE p
	SET p.BetLimitSettingType = pt.SettingType 
	FROM #Product p
		INNER JOIN #SportBettypeSetting pt ON p.ProductID = pt.ProductID
	WHERE pt.SettingName IN ('Bet Setting')

	--Update Sport, Bettype of Product <> 1
	UPDATE a
	SET a.Sporttype = sp.SportType , a.Bettype = sp.BetType
	FROM #Product a
		INNER JOIN #SportBettypeSetting sp ON a.ProductID = sp.ProductID
	WHERE sp.SettingName IN ('Bet Setting')
		AND  a.ProductID <> 1

	UPDATE p
	SET p.StakeLevelSettingType =  pt.SettingType 
	FROM #Product p
		INNER JOIN #SportBettypeSetting pt ON p.ProductID = pt.ProductID
	WHERE pt.SettingName IN ('Stake Level')

	UPDATE p
	SET p.PTSettingType =  pt.SettingType 
	FROM #Product p
		INNER JOIN #SportBettypeSetting pt ON p.ProductID = pt.ProductID
	WHERE pt.SettingName IN ('Position Taking')

	UPDATE p
	SET p.CommSettingType =  pt.SettingType 
	FROM #Product p
		INNER JOIN #SportBettypeSetting pt ON p.ProductID = pt.ProductID
	WHERE pt.SettingName IN ('Commission')

	--Update Bettype of Global Stake Level
	UPDATE a
	SET a.Sporttype = sp.SportType , a.Bettype = sp.BetType
	FROM #Product a
		INNER JOIN #SportBettypeSetting sp ON a.ProductID = sp.ProductID
	WHERE sp.SettingType = 8

	IF EXISTS( SELECT 1 FROM #CustomerList WHERE Currency = 20 AND roleid = 4)
	BEGIN
		-- New Licensee, add UUS Stake Level
		INSERT INTO	@tmpStakeLevel (Currency,GameTypeID,MinStake,MaxStake)
		SELECT DISTINCT Currency = 20, GameTypeID,st.MinStake,st.MaxStake
		FROM @tmpStakeLevel t
			CROSS APPLY ( SELECT 5 AS MinStake ,500 AS MaxStake UNION ALL
							SELECT 5 AS MinStake ,1000 AS MaxStake UNION ALL
							SELECT 5 AS MinStake ,2000 AS MaxStake ) st

		INSERT INTO #Product(ProductID ,Currency, Sporttype, Bettype ,MinBet ,MaxBet ,MaxPerMatch ,MaxPerNumber,MaxPayoutPerMatch
			 , PT, ProductName, Comm, BetLimitSettingType, StakeLevelSettingType, PTSettingType, CommSettingType)
		SELECT DISTINCT ProductID ,20, Sporttype, Bettype 
			, MinBet = 1
			, MaxBet = CASE WHEN ProductID = 1 THEN 1000 ELSE 10  END
			, MaxPerMatch = CASE WHEN ProductID = 1 THEN 10000 ELSE 100 END
			, MaxPerNumber = CASE WHEN ProductID = 3 THEN 100 ELSE NULL END
			, MaxPayoutPerMatch= CASE WHEN ProductID = 1 THEN 80000 ELSE NULL END
			, PT, ProductName, Comm, BetLimitSettingType, StakeLevelSettingType, PTSettingType, CommSettingType 
		FROM #Product
	END
	-----------------------------------------------------------------------------------------------
	WHILE (1 = 1)
	BEGIN
		SELECT @ErrCode = 0, @ErrMsg = ''
		
		UPDATE TOP (1) t
		SET @Currency = t.Currency 
			, @CurrencyName = CurrencyName
			, @srecommend = custid
			, t.isfinished = 1
		FROM #CustomerList t
		WHERE isfinished = 0	
			AND roleid = 4

		IF @@ROWCOUNT = 0 BREAK

		TRUNCATE TABLE #TmpAgentList
		INSERT INTO #TmpAgentList(CustID)
		SELECT CustID
		FROM #CustomerList t
		WHERE isfinished = 0	
			AND roleid = 2
			AND Currency = @Currency
			AND username NOT LIKE @sitename + 'ACC%'

		BEGIN TRY
			--Insert product setting
			WHILE (1 = 1)
			BEGIN
				TRUNCATE TABLE #SportsStatus
				UPDATE #TmpAgentList SET isfinished = 0

				SELECT @ErrCode = 0, @ErrMsg = ''

				SELECT TOP (1) @ProductID = t.ProductID
					, @ProductName = ProductName
					, @PT = PT
					, @Comm = Comm
					, @BetLimitSettingType = t.BetLimitSettingType
					, @StakeLevelSettingType = t.StakeLevelSettingType
					, @PTSettingType = t.PTSettingType
					, @CommSettingType = t.CommSettingType
				FROM #Product t
				WHERE isfinished = 0	
					AND Currency = @Currency

				IF @@ROWCOUNT = 0 BREAK

				--Insert Status
				IF @ProductID <> 1
				BEGIN
					--Generate Sporttype 
					INSERT INTO #SportsStatus(ProductID,Sporttype ,Bettype,bitmapOrder,IsDisable,IsDisableDownLine,HasDownline,IsDisableUpline)
					EXEC Acc_Dep_CustSetting_StatusSelect @ProductID = @ProductID, @CustID = 0, @SettingStatus = @SettingStatus

					SELECT @SporttypeID=Sporttype,@BettypeID=Bettype,@bitmapOrder=bitmapOrder FROM #SportsStatus
				
					--Insert status
					EXEC Acc_Dep_CustSetting_StatusUpd @ProductID=@ProductID,@CustID=@srecommend,@IsDisabled=0,@IsDisabledDownLine=0,
						@SportType=@SportTypeID,@BetType=@BetTypeID,@bitmapOrder=@bitmapOrder,@UserID=@CreatorID,@IP=@IP,
						@IsAgentOnly=0,@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT, @SettingStatus = @SettingStatus

					IF @ErrCode <> 0 
					BEGIN
						SELECT @ErrMsg = @ErrMsg + '(Status DCS '+ @ProductName +'.)'
						GOTO RollbackCurrency;
					END
				END

				--Insert PT 
				IF @PTSettingType IN (1,18)
				BEGIN
					SELECT  @PT_XML = ('<ROOT>' + (
								SELECT SportType AS 'SportType'
									,Bettype AS 'BetType'
									,IsLive AS 'IsLive'
									,@PT * 100 AS 'PT'
								FROM #SportBettypeSetting
								WHERE ProductID = @ProductID 
									AND SettingType = @PTSettingType
								FOR XML RAW('PT')) + '</ROOT>')
				END

				--Insert Bet limit
				IF @BetLimitSettingType IN(2,10,12)
				BEGIN
					SELECT  @BetLimit = CONVERT(VARCHAR(MAX),
					(
						SELECT DISTINCT 
								p.SportType AS '@SportType',
								p.BetType AS '@BetType',
								p.MinBet AS '@MinBet',
								p.MaxBet AS '@MaxBet',
								p.MaxPerMatch AS '@MaxPerMatch',
								CASE WHEN @BetLimitSettingType = 12 THEN p.MaxPerNumber ELSE NULL END AS '@MaxPerNumber',
								CASE WHEN @BetLimitSettingType = 10 THEN p.MaxPayoutPerMatch ELSE NULL END AS '@MaxPayoutPerMatch'
						FROM #Product p 
						WHERE p.ProductID = @ProductID AND p.Currency = @Currency AND p.BetLimitSettingType = @BetLimitSettingType	
						FOR XML PATH('BetLimit'), ROOT ('ROOT'),TYPE)
					)
				END
			
				--Stake level
				IF @StakeLevelSettingType IN (7,8)
				BEGIN
					SELECT @StakelevelXML = CONVERT(VARCHAR(MAX),
									(SELECT dp.SportType AS SportType
										,dp.BetType as BetType
										,SUBSTRING((
													SELECT ',' + CONVERT(VARCHAR,StakeLevelID)
													FROM Dep_StakeLevel WITH(NOLOCK)
													WHERE GameTypeID = dp.BetType
														AND exchangeID = @Currency
														AND ( 
																(SiteID = @SiteID AND @StakeLevelSettingType = 7)
																 OR @StakeLevelSettingType = 8
															)
													FOR XML PATH('')
													),2,1000) AS StakeLevelList
									FROM #SportBettypeSetting dp
									WHERE dp.ProductID = @ProductID 
										AND dp.SettingType = @StakeLevelSettingType
									FOR XML RAW ('StakeLevel'), ROOT ('ROOT') 	
									))

					IF @StakeLevelSettingType = 8
					BEGIN
						UPDATE a		
						SET a.StakeLevelID = b.StakeLevelID
						FROM #Product a 
							INNER JOIN Dep_StakeLevel b WITH(NOLOCK) 
								ON b.GameTypeID = a.Bettype AND b.ExchangeID = a.Currency
						WHERE a.ProductID = @ProductID AND a.Currency = @Currency
					END
				END

				WHILE 1 = 1
				BEGIN
					UPDATE TOP (1) t
					SET   @AgentID = custid
						, t.isfinished = 1
					FROM #TmpAgentList t
					WHERE isfinished = 0	

					IF @@ROWCOUNT = 0 BREAK
				
					IF @PTSettingType IN (1)
					BEGIN
						EXEC Acc_Dep_CustSetting_PositionTakingSettingUpd @SuperID=@srecommend,
							 @AgentID=@AgentID,@IsAgentOnly=1,@PT=@PT_XML,@ProductID=@ProductID,@UserID=@CreatorID,@IP=@IP,
							 @ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT, @SettingStatus = @SettingStatus	
				
						IF @ErrCode <> 0 
						BEGIN
							SELECT @ErrMsg = @ErrMsg + '(PT DCS '+ @ProductName +'.)'
							GOTO RollbackCurrency;
						END
					END

					IF @BetLimitSettingType IN (10,12) 
					BEGIN
						EXEC Acc_Dep_CustSetting_Game_BetLimitFullLineUpd @SuperID=@srecommend,
								@BetLimit=@BetLimit,@AgentID=@AgentID,@IsAgentOnly=0,@ApplyExistedMem=1,@UserID=@CreatorID,@IP=@IP,
								@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT, @SettingStatus = @SettingStatus
					END
					ELSE IF @BetLimitSettingType IN (2) 
					BEGIN
						EXEC Acc_Dep_CustSetting_BetLimitFullLineUpd @SuperID=@srecommend,
							@BetLimit=@BetLimit,@AgentID=@AgentID,@IsAgentOnly=0,@ApplyExistedMem=1,@UserID=@CreatorID,@IP=@IP,
							@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT, @SettingStatus = @SettingStatus
					END
				
					IF @ErrCode <> 0 
					BEGIN
						SELECT @ErrMsg = @ErrMsg + '(Betlimit DCS '+ @ProductName +'.)'
						GOTO RollbackCurrency;
					END

					IF @StakeLevelSettingType IN (7,8)
					BEGIN
						EXEC [dbo].[Acc_Dep_CustSetting_StakeLevelUpd] 
							@CustID = @AgentID, @ProductID = @ProductID,
							@StakeLevel = @StakelevelXML, @IsAgentOnly = 0,@UserID = @CreatorID, @IP=@IP, 
							@ErrCode=@ErrCode OUTPUT, @ErrMsg=@ErrMsg OUTPUT, @SettingStatus = @SettingStatus	
				
						IF @ErrCode <> 0 
						BEGIN
							SELECT @ErrMsg = @ErrMsg + '(Stake Level DCS '+ @ProductName +'.)'
							GOTO RollbackCurrency;
						END
					END
				END

				--PT for settingtype = 18
				IF @PTSettingType = 18
				BEGIN
					EXEC Acc_Dep_CustSetting_ChargePTUpd @CustID=@srecommend,@PT=@PT_XML,@ProductID=@ProductID,@UserID=@CreatorID,@IP=@IP,
									@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT, @SettingStatus = @SettingStatus

					IF @ErrCode <> 0 
					BEGIN
						SELECT @ErrMsg = @ErrMsg + '(PT DCS '+ @ProductName +'.)'
						GOTO RollbackCurrency;
					END
				END

				--Insert ChargeComm 
				IF @CommSettingType IN (5)
				BEGIN
					SELECT  @Discount_XML = ('<ROOT>' + (
								SELECT SportType AS 'SportType'
										,Bettype AS 'BetType'
										,@Comm AS 'Discount'
								FROM #SportBettypeSetting dp
								WHERE dp.ProductID = @ProductID 
									AND dp.SettingType = @CommSettingType
								FOR XML RAW('Discount')) + '</ROOT>')

					EXEC Acc_Dep_CustSetting_ChargeCommUpd @CustID=@srecommend,@Discount=@Discount_XML,@ProductID=@ProductID,@UserID=@CreatorID,@IP=@IP,
							@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT, @SettingStatus = @SettingStatus

					IF @ErrCode <> 0 
					BEGIN
						SELECT @ErrMsg = @ErrMsg + '(Charge Commission DCS '+ @ProductName +'.)'
						GOTO RollbackCurrency;
					END
				END

				UPDATE t
				SET isfinished = 1
				FROM #Product t
				WHERE isfinished = 0	
					AND Currency = @Currency
					AND ProductID = @ProductID
			END
		END TRY
		BEGIN CATCH
			SELECT @ErrMsg = ERROR_MESSAGE(), @ErrCode = 911
			GOTO RollbackCurrency;
		END CATCH
			
		--Rollback Currency if have any error of this currency
		RollbackCurrency:
		IF @ErrCode <> 0
		BEGIN 
			--PRINT @CurrencyName + ': ' + @ErrMsg
			INSERT INTO @TempError ( ErrMsg) 
			SELECT @CurrencyName + ': ' + @ErrMsg

			SELECT @Super_RollBack= CAST(@srecommend AS VARCHAR(20))
			SELECT @FailedCurrencies = ISNULL(@FailedCurrencies , '') + ',' + @CurrencyName
			SELECT @ListSuperRollBack = ISNULL(@ListSuperRollBack , '') + ',' + @Super_RollBack
			EXEC dbo.[Acc_Dep_CustomerIns_Rollback_Multiple] @CustIDs = @Super_RollBack, @IsRollbackFullLine = 1 
			DELETE FROM #CustomerList WHERE Currency = @Currency -- Exclude this currency for next steps
 			CONTINUE;			
		END

		IF @Mode = 1 -- Create New Licensee
		BEGIN
			SELECT @ErrMsg = 'Create Licensee successfully'
		END
		ELSE 
		BEGIN
			SELECT @ErrMsg = 'Create Currency for Licensee successfully'
		END

		--Writelog Currency
		SET @LogXML = (
						SELECT  (
								SELECT    @sitename														AS '@sitename'
										, @LicenseeType													AS '@LicenseeType'
										, @IP															AS '@IP'								
										, @creator														AS '@creator'			
										, @srecommend													AS '@SuperID'		
										, 1																AS '@CashOut'	
										, @IsCreateSub													AS '@Subsidiary'	
										, @ErrCode														AS '@ErrCode'	
										, @ErrMsg														AS '@ErrMsg'
										, @IsChinaView													AS '@IsChinaView'
										, @SpecialPlatform												AS '@SpecialPlatform'	
								FOR XML PATH('GeneralInfo'), 
								TYPE
								),
								(
									SELECT	DISTINCT ProductID 												AS '@ID'
											,CAST(PT AS VARCHAR(50))										AS '@PT'										
									FROM #Product	
									WHERE Currency = @Currency
								FOR XML PATH ('Product'),ROOT ('PT'),
								TYPE
								),
								(
								SELECT	DISTINCT ProductID 											AS '@ID'
											,  CAST(Comm AS VARCHAR(50))							AS '@ChargeComm'	
								FROM #Product	
								WHERE Currency = @Currency
									AND CommSettingType = 5
								FOR XML PATH ('Product'),ROOT ('ChargeComm'),
								TYPE
								),
								(
									SELECT CASE WHEN  bs1.Sporttype = 1 AND bs1.bettype = 9 THEN 1999
												WHEN  bs1.Sporttype = 99 AND bs1.bettype = 9 THEN 999
											ELSE bs1.Sporttype END															AS [@ID]
										,  dbo.f_CS_FomatNumber (CAST(bs1.MinBet			AS VARCHAR(50)))				AS [@minb]
										,  dbo.f_CS_FomatNumber (CAST(bs1.MaxBet			AS VARCHAR(50)))				AS [@maxb]
										,  dbo.f_CS_FomatNumber (CAST(bs1.MaxPerNumber 		AS VARCHAR(50)))				AS [@mpb]
										,  dbo.f_CS_FomatNumber (CAST(bs1.MaxPerMatch 		AS VARCHAR(50)))				AS [@mpm]	
										,  dbo.f_CS_FomatNumber (CAST(bs1.MaxPayoutPerMatch AS VARCHAR(50)))				AS [@mppm]		
									FROM #Product bs1
									WHERE bs1.Currency = @Currency	
										AND bs1.ProductID = 1
									ORDER BY ProductID, Sporttype, Bettype	
									FOR XML PATH('Sport'), ROOT ('BS1'),
									TYPE
								),
								(
									SELECT  ProductID																			AS [@ID]
											,  dbo.f_CS_FomatNumber (CAST(bs.MinBet			AS VARCHAR(50)))					AS [@minb]
											,  dbo.f_CS_FomatNumber (CAST(bs.MaxBet			AS VARCHAR(50)))					AS [@maxb]
											,  dbo.f_CS_FomatNumber (CAST(bs.MaxPerNumber 		AS VARCHAR(50)))				AS [@mpb]
											,  dbo.f_CS_FomatNumber (CAST(bs.MaxPerMatch 		AS VARCHAR(50)))				AS [@mpm]				
									FROM #Product bs 
									WHERE Currency=@Currency 
										AND bs.BetLimitSettingType IS NOT NULL	
										AND bs.ProductID <> 1
									ORDER BY ProductID, Sporttype, Bettype				
									FOR XML PATH('Product'), ROOT ('BS2'),
									TYPE
								),
								(
									SELECT	ds.ProductID AS [@ID],
										(
											SELECT st1.GameTypeID																	AS [@ID]
												,  dbo.f_CS_FomatNumber (CAST(st1.MinStake		AS VARCHAR(50)))					AS [@MinStake]
												,  dbo.f_CS_FomatNumber (CAST(st1.MaxStake		AS VARCHAR(50)))					AS [@MaxStake]
											FROM @tmpStakeLevel st1 
												INNER JOIN Dep_ProductSettingDetail dt1 WITH(NOLOCK) ON st1.GameTypeID = dt1.BetType
												INNER JOIN Dep_ProductSetting ds1 WITH(NOLOCK) ON dt1.ProductSettingID = ds1.ProductSettingID
											WHERE st1.Currency = @Currency AND ds1.SettingType = 7
												AND ds1.ProductID = ds.ProductID 
											ORDER BY st1.GameTypeID
											FOR XML PATH('Bettype'),TYPE
										) 
									FROM @tmpStakeLevel st 
										INNER JOIN Dep_ProductSettingDetail dt WITH(NOLOCK) ON st.GameTypeID = dt.BetType
										INNER JOIN Dep_ProductSetting ds WITH(NOLOCK) ON dt.ProductSettingID = ds.ProductSettingID
									WHERE st.Currency = @Currency AND ds.SettingType = 7
									GROUP BY ds.ProductID
									ORDER BY ds.ProductID
									FOR XML PATH('Product'), ROOT ('SL'),
									TYPE
								),
								(
									SELECT p.ProductID																		AS [@ID]
										,  dbo.f_CS_FomatNumber (CAST(p.StakeLevelID		AS VARCHAR(50)))				AS [@StakeLevelID]
									FROM #Product P 
									WHERE p.Currency = @Currency AND p.StakeLevelSettingType = 8
									ORDER BY p.ProductID
									FOR XML PATH('Product'), ROOT ('StakeLevelGroup'),
									TYPE
								)							
						FOR XML PATH('R'), 
						TYPE
						)
			SET @TrackingValue = REPLACE(CONVERT(VARCHAR(MAX), @LogXML), '" />', '"/"')	
			INSERT INTO @LogInfo_Tbl(UserID, CustID,ActionID,TrackingValue)
			SELECT @CreatorID, @srecommend, @ActionID, @TrackingValue	
	END

	IF CHARINDEX(',',@FailedCurrencies) = 1
	BEGIN
		SELECT @FailedCurrencies = STUFF(@FailedCurrencies,1,1,'')
	END

	SET @ErrExtraInfo = ISNULL(@ErrExtraInfo,'') +  ISNULL(
															(  
															SELECT ErrMsg  
															FROM @TempError  
															FOR Json PATH  
															)  ,'')

	IF NOT EXISTS( SELECT 1 FROM #CustomerList) --Failed all
	BEGIN
		SELECT @ErrMsg = 'Create customer failed. Please try again.'
			  ,@ErrCode = 911
		RETURN
	END

	SET @InsBalExceptCustList = (
		SELECT CustID,username
		FROM #CustomerList
		WHERE roleid = 1
		FOR Json PATH
	)

	SET @ProductList = (
		SELECT DISTINCT ProductID 
		FROM #Product
		FOR Json PATH
	)

	SET @CurrencyList = (
		SELECT DISTINCT Currency 
		FROM #CustomerList
		FOR Json PATH
	)

	SELECT @AgentList = ''

	SELECT @AgentList =  ',' +  CAST(custid as varchar(20)) + @AgentList 
	FROM #CustomerList 
	WHERE roleid = 2  
		AND username LIKE @sitename + '%01'
		AND username NOT LIKE @sitename + 'ACC%01'

	SELECT @AgentList = STUFF(@AgentList,1,1,'')

	SELECT UserID, CustID,ActionID,TrackingValue 
	FROM @LogInfo_Tbl

	SELECT @PT_Sportsbook = PT * 100 FROM @tmpPT WHERE ProductID = 1

	DROP TABLE #CustomerList
	DROP TABLE #Product
	DROP TABLE #SportsStatus
	DROP TABLE #TmpAgentList
	DROP TABLE #SportBettypeSetting
END	
GO
