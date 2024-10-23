/*<info serverAlias="DBCUST-CustDB" executers="asv_cust" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[API_SiteBuilder_Validate]
	@ProductBetSetting	VARCHAR(MAX)= NULL,
	@ProductPT	VARCHAR(MAX)= NULL,
	@Mode TINYINT = 1, -- 1: New Licensee, 2: New Currency
	@sitename	VARCHAR(10) = NULL,
	@IsCreateSub BIT = 0,
	@ErrCode INT = 0 OUTPUT,
	@ErrMsg NVARCHAR(2000) = '' OUTPUT,
	@Usernames_Register VARCHAR(MAX) = NULL OUTPUT,
	@SettingStatus TINYINT = 0
AS
/*
	Created: 20240705@Eden  
	Task : SiteBuider --> Validate data
	DB:  DBCUST-CustDB
	Original sp: 
	
	Revisions: 
		- 20240705@Eden  : Scale out DBCUST - Licensee Customer in GlobCustDB [redmine: #207474]
		- 20240920@Helios  : Scale out DBCUST - Licensee Customer in GlobCustDB - Modified OddsBoostAdj [redmine: #207474]
	Param's Explanation: 
		Sample Format:
		DECLARE @ErrCode INT = 0 , @ErrMsg NVARCHAR(2000) = '',@Usernames_Register VARCHAR(MAX)
		EXEC [API_SiteBuilder_Validate_UAT2]
			 @ProductPT	= '[{"ProductID":1,"PT":0.9000},{"ProductID":3,"PT":0.8800},
							{"ProductID":8,"PT":0.8700},{"ProductID":38,"PT":0.8500},
							{"ProductID":22,"PT":0.8900}]'
			,@ProductBetSetting = '[{"ProductID":1,"Sporttype":1,"Bettype":1,"Currency":4,"MinBet":1.0000,"MaxBet":10000.0000,"MPM":1000000.0000,"MPPM":1000000.0000},
									{"ProductID":1,"Sporttype":2,"Bettype":1,"Currency":4,"MinBet":2.0000,"MaxBet":20000.0000,"MPM":2000000.0000,"MPPM":2000000.0000},
									{"ProductID":3,"Currency":4,"MinBet":2.0000,"MaxBet":20000.0000,"MPM":2000000.0000,"MPB":100000.0000},
									{"ProductID":8,"Currency":4,"MinBet":2.0000,"MaxBet":20000.0000,"MPM":2000000.0000},
									{"ProductID":38,"Currency":4},
									{"ProductID":22,"Currency":4},
									{"ProductID":1,"Sporttype":1,"Bettype":1,"Currency":12,"MinBet":1.0000,"MaxBet":10000.0000,"MPM":1000000.0000,"MPPM":1000000.0000},
									{"ProductID":1,"Sporttype":2,"Bettype":1,"Currency":12,"MinBet":2.0000,"MaxBet":20000.0000,"MPM":2000000.0000,"MPPM":2000000.0000},
									{"ProductID":3,"Currency":12,"MinBet":2.0000,"MaxBet":20000.0000,"MPM":2000000.0000,"MPB":100000.0000},
									{"ProductID":8,"Currency":12,"MinBet":2.0000,"MaxBet":20000.0000,"MPM":2000000.0000},
									{"ProductID":38,"Currency":12},
									{"ProductID":22,"Currency":12}
									]'
			,@sitename			= 'Edentest1'
			,@IsCreateSub		= 1
			,@ErrCode			= @ErrCode OUTPUT
			,@ErrMsg			= @ErrMsg OUTPUT
			,@Usernames_Register = @Usernames_Register OUTPUT

		SELECT  @ErrCode		AS ErrCode		
				,@ErrMsg		AS ErrMsg
				,@Usernames_Register AS CustList_Register
*/			   					
BEGIN
	SET NOCOUNT ON
	DECLARE @CurrencyError NVARCHAR(MAX) = '',
		@ProductName VARCHAR(100) = '',
		@ProductID INT

	DECLARE @tmpPT TABLE(ProductID INT, PT SMALLMONEY);
	DECLARE @tmpBetSetting TABLE(ProductID INT,Currency INT,Sporttype INT,Bettype INT
			,MinBet MONEY,MaxBet MONEY,MaxPerMatch MONEY,MaxPerNumber MONEY,MaxPayoutPerMatch MONEY)

	CREATE TABLE #Product(
		ProductID INT, Currency INT, Sporttype INT, Bettype INT 
		, MinBet MONEY, MaxBet MONEY, MaxPerMatch MONEY, MaxPerNumber MONEY, MaxPayoutPerMatch MONEY
		, StakeLevelID INT, PT SMALLMONEY, ProductName VARCHAR(100)
	)
	CREATE TABLE #CheckBetlimit (ProductID INT, ProductName VARCHAR(100),Currency INT, CurrencyName NVARCHAR(50)
				,MinBet MONEY,MaxBet MONEY, MinBetGlobal MONEY,MaxBetGlobal MONEY, isfinished BIT DEFAULT(0))

	BEGIN TRY
	INSERT INTO @tmpPT(ProductID, PT)
	SELECT ProductID, PT
	FROM OPENJSON(@ProductPT) WITH (
					 ProductID INT  '$.ProductID'
					,PT SMALLMONEY	'$.PT'
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
	--------------------------------------------------------------------------------------
	INSERT INTO #Product(ProductID ,Currency ,MinBet ,MaxBet ,MaxPerMatch ,MaxPerNumber,MaxPayoutPerMatch,Sporttype,Bettype, PT, ProductName)
	SELECT pt.ProductID ,Currency ,MinBet ,MaxBet ,MaxPerMatch ,MaxPerNumber,MaxPayoutPerMatch ,Sporttype ,Bettype
		,pt.PT, p.ProductName
	FROM @tmpPT pt
		LEFT JOIN @tmpBetSetting bs ON bs.ProductID = pt.ProductID
		LEFT JOIN Products p WITH(NOLOCK) ON pt.ProductID = p.ProductID

	------------------------------------Validate data-----------------------------------------------------------
	--Product does not support
	SELECT TOP 1 @ProductName = a.ProductName 
	FROM #Product a
		OUTER APPLY dbo.f_Dep_CustSetting_SportBetTypeSettingSelect(a.ProductID,4,@SettingStatus) prd
	WHERE a.ProductID NOT IN (1) -- product no need status
		AND prd.ProductID IS NULL

	IF @ProductName <> ''
	BEGIN
		SELECT  @ErrMsg = 'This product '+ @ProductName +' does not support.', @ErrCode = 10011
		RETURN
	END

	--Validate Currency input
	IF EXISTS(SELECT TOP 1 1 
						FROM #Product a
						LEFT JOIN exchange b WITH(NOLOCK) ON a.Currency = b.ExchangeId
						WHERE b.ExchangeId IS NULL
			)
	BEGIN
		SELECT @CurrencyError = STUFF((
				SELECT ',' + CAST(kq.Currency AS VARCHAR(5)) + ''
				FROM (
						SELECT DISTINCT a.currency
						FROM #Product a
							LEFT JOIN exchange b WITH(NOLOCK) ON a.Currency = b.ExchangeId
						WHERE b.ExchangeId IS NULL
				) kq
				FOR XML PATH('')
			 ), 1, 1, '')
         
		SELECT @ErrMsg = 'Invalid currencyID(s): '+ @CurrencyError , @ErrCode = 10015
		RETURN
	END

	IF EXISTS(SELECT TOP 1 1 
						FROM #Product a
						INNER JOIN exchange b WITH(NOLOCK) ON a.Currency = b.ExchangeId
						WHERE b.IsActive = 0 OR b.OfferSite NOT IN (2,0) 
			)
	BEGIN
		SELECT @CurrencyError = STUFF((
			SELECT ',' + CAST(KQ.currency AS NVARCHAR(5)) + ''
			FROM (
				SELECT DISTINCT b.currency,b.Code
				FROM #Product a
					INNER JOIN exchange b WITH(NOLOCK) ON a.Currency = b.ExchangeId
				WHERE b.IsActive = 0 OR b.OfferSite NOT IN (2,0)
				 ) KQ
				 ORDER BY KQ.Code
				FOR XML PATH('')
			 ), 1, 1, '')
         
		SELECT @ErrMsg = 'The '+ @CurrencyError +' currency is/are not offered for Licensee. Please check again!', @ErrCode = 10006
		RETURN
	END

	--Validate Stake Level
	SELECT TOP 1 @ProductName = a.ProductName 
	FROM #Product a
		CROSS APPLY dbo.f_Dep_CustSetting_SportBetTypeSettingSelect(a.ProductID,8,@SettingStatus)  sp
	WHERE NOT EXISTS(	SELECT TOP 1 1 
						FROM Dep_StakeLevel WITH(NOLOCK) 
						WHERE GameTypeID = sp.Bettype 
							AND ExchangeID = a.Currency 
					  )
	IF @ProductName <> ''
	BEGIN
		SELECT  @ErrMsg = 'This product '+ @ProductName +' does not support the selected currencies', @ErrCode = 10007
		RETURN
	END

	IF EXISTS(SELECT TOP 1 1 FROM #Product WHERE  MinBet<0 OR MaxBet<0 OR MinBet>MaxBet OR MaxPerMatch<0  OR MaxBet>MaxPerMatch)
	BEGIN
		SELECT @ErrMsg = 'Break rule bet limit', @ErrCode = 10002
		RETURN
	END
	IF EXISTS(SELECT TOP 1 1 
						FROM #Product 
						WHERE MaxPerNumber < 0 
							OR (MaxBet>0 AND MaxPerNumber > 0 AND MaxBet > MaxPerNumber)
							OR (MaxPerMatch>0 AND MaxPerNumber > 0 AND MaxPerNumber > MaxPerMatch)
			)
	BEGIN
		SELECT @ErrMsg = 'Break rule bet limit', @ErrCode = 10005
		RETURN
	END
	IF EXISTS(SELECT TOP 1 1 
						FROM #Product 
						WHERE MaxPayoutPerMatch < 0 
							OR (MaxPerMatch>0 AND MaxPayoutPerMatch > 0 AND MaxPerMatch > MaxPayoutPerMatch)
			)
	BEGIN
		SELECT @ErrMsg = 'Break rule bet limit', @ErrCode = 10008
		RETURN
	END

	IF NOT EXISTS(	SELECT TOP 1 1 FROM #Product WHERE ProductID=1)
	BEGIN
		SELECT @ErrMsg = 'Must offer Sportbook', @ErrCode = 10004
		RETURN
	END

	IF CHARINDEX(space(1), @Sitename) > 0
	BEGIN
		SELECT @ErrMsg = 'Site name can''t contain spaces. Please check again', @ErrCode = 10099
		RETURN
	END

	----Generate Username
	CREATE TABLE #Username( Super VARCHAR(30),Master VARCHAR(30),Agent VARCHAR(30),AccMaster VARCHAR(30)
							,AccAgent VARCHAR(30),Transf VARCHAR(30),Charge VARCHAR(30),Bonus01 VARCHAR(30),Bonus02 VARCHAR(30)
							,Withdraw VARCHAR(30),Dummy3rd VARCHAR(30),ClearBal VARCHAR(30)	
							,Sub2 VARCHAR(30),Sub3 VARCHAR(30),Sub4 VARCHAR(30),Sub5 VARCHAR(30),Sub6 VARCHAR(30)
							,Sub7 VARCHAR(30),Sub8 VARCHAR(30),Sub9 VARCHAR(30),Sub10 VARCHAR(30),Sub11 VARCHAR(30)
							--,CashOut VARCHAR(30),CO_Sub2 VARCHAR(30),CO_Sub3 VARCHAR(30),CO_Sub4 VARCHAR(30),CO_Sub5 VARCHAR(30),CO_Sub6 VARCHAR(30)
							--,CO_Sub7 VARCHAR(30),CO_Sub8 VARCHAR(30),CO_Sub9 VARCHAR(30),CO_Sub10 VARCHAR(30),CO_Sub11 VARCHAR(30)
							,Currency INT, CurrencyName NVARCHAR(50) , OddsBoostAdj VARCHAR(30) , Exchange VARCHAR(30)
							)
	DECLARE @OfferedCurrency TABLE (Currency INT)

	INSERT INTO @OfferedCurrency (Currency)
	SELECT Currency 
	FROM #Product t 
	WHERE t.ProductID=1
	UNION 
	SELECT 20 AS Currency
	WHERE @Mode = 1 -- add UUS currency when create new Licensee

	INSERT INTO #Username(Super,Master,Agent,AccMaster,AccAgent,Transf,Charge ,Bonus01,Bonus02,Withdraw,Dummy3rd,Currency,ClearBal,CurrencyName, OddsBoostAdj)
	SELECT 
		@sitename+'Super'+e.currency,
		@sitename+e.currency,
		@sitename+e.currency+'01',
		@sitename+'ACC'+e.currency,
		@sitename+'ACC'+e.currency+'01',
		@sitename+'Transfer'+e.currency,
		@sitename+'Charges'+e.currency,
		@sitename+'Bonus'+e.currency,
		@sitename+'Bonus02'+e.currency,
		@sitename+'Withdrawal'+e.currency,
		@sitename+'Dummy3rd'+e.currency,
		t.Currency,@sitename+e.currency+'01ClearBal',		
		e.currency as CurrencyName,
		@sitename+e.currency+'01OddsBoostAdj'
			--, @sitename+e.currency+'01CashOut'
	FROM @OfferedCurrency t
		INNER JOIN exchange e WITH(NOLOCK) ON t.Currency=e.exchangeid

	IF @IsCreateSub = 1
	BEGIN 
		UPDATE t 
		SET t.Sub2 = Master +'02',
			t.Sub3 = Master +'03',
			t.Sub4 = Master +'04',
			t.Sub5 = Master +'05',
			t.Sub6 = Master +'06',
			t.Sub7 = Master +'07',
			t.Sub8 = Master +'08',
			t.Sub9 = Master +'09',
			t.Sub10 = Master +'10',
			t.Sub11 = Master +'11'
			--t.CO_Sub2 = Master +'02' + 'CashOut',
			--t.CO_Sub3 = Master +'03' + 'CashOut',
			--t.CO_Sub4 = Master +'04' + 'CashOut',
			--t.CO_Sub5 = Master +'05' + 'CashOut',
			--t.CO_Sub6 = Master +'06' + 'CashOut',
			--t.CO_Sub7 = Master +'07' + 'CashOut',
			--t.CO_Sub8 = Master +'08' + 'CashOut',
			--t.CO_Sub9 = Master +'09' + 'CashOut',
			--t.CO_Sub10 = Master +'10' + 'CashOut',
			--t.CO_Sub11 = Master +'11' + 'CashOut'
		FROM #Username t
	END
	
	--Create dummy exchange if offer exchange products
	IF EXISTS (SELECT 1 FROM #Product WHERE ProductID = 31)
	BEGIN
		UPDATE u 
		SET u.Exchange = @sitename + 'Exchange'+ u.CurrencyName
		FROM #Username u
	END

	SET @Usernames_Register = (
		SELECT Super,Master,Agent,AccMaster,AccAgent,Transf,Charge 
			,Bonus01,Bonus02,Withdraw,Dummy3rd,Currency,ClearBal
			,Sub2,Sub3,Sub4,Sub5,Sub6,Sub7,Sub8,Sub9,Sub10,Sub11
			,CurrencyName,Exchange,OddsBoostAdj
			--,CashOut,CO_Sub2,CO_Sub3,CO_Sub4,CO_Sub5,CO_Sub6,CO_Sub7,CO_Sub8,CO_Sub9,CO_Sub10,CO_Sub11
		FROM #Username 
		FOR Json PATH
				)

	DROP TABLE #CheckBetlimit
	DROP TABLE #Product
	DROP TABLE #Username
END	
GO
