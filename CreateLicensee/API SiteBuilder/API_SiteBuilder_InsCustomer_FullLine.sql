/*<info serverAlias="DBCUST-CustDB" executers="asv_cust" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[API_SiteBuilder_InsCustomer_FullLine]
	@Customers_List		VARCHAR(MAX) = NULL OUTPUT, --in/out parameter
	@sitename			VARCHAR(10)= NULL,
	@IP					VARCHAR(50)= '',	
	@ErrCode			INT = 0				OUTPUT,
	@ErrMsg				NVARCHAR(MAX) = ''	OUTPUT,
	@InsBalExceptCustList VARCHAR(MAX) = '' OUTPUT,
	@FailedCurrencies VARCHAR(MAX) = '' OUTPUT,
	@ListSuperRollBack VARCHAR(MAX) = '' OUTPUT,
	@ErrExtraInfo VARCHAR(MAX) = '' OUTPUT -- Log DB
AS
/*
	Created: 20240705@Eden  
	Task : SiteBuider --> Insert full line customer
	DB:  DBCUST-CustDB
	Original sp: 
	
	Revisions: 
		- 20240705@Eden  : Scale out DBCUST - Licensee Customer in GlobCustDB [redmine: #207474]
		- 20241009@Helios  : Scale out DBCUST - Licensee Customer in GlobCustDB [redmine: #207474]
	Param's Explanation: 
		Sample Format:
		DECLARE @ErrCode INT = 0 , @ErrMsg NVARCHAR(2000) = '',@FailedCurrencies VARCHAR(MAX) = '' ,	@ListSuperRollBack VARCHAR(MAX) = ''
		EXEC [API_SiteBuilder_InsCustomer_FullLine]
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
			,@ErrCode			= @ErrCode OUTPUT
			,@ErrMsg			= @ErrMsg OUTPUT
			,@FailedCurrencies = @FailedCurrencies OUT
			,@ListSuperRollBack = @ListSuperRollBack OUT

		SELECT  @ErrCode		AS ErrCode		
				,@ErrMsg		AS ErrMsg
				,@FailedCurrencies AS FailedCurrencies 
				,@ListSuperRollBack AS ListSuperRollBack
*/			   					
BEGIN
	SET NOCOUNT ON

	CREATE TABLE #CustomerList(CustID INT, username VARCHAR(30), recommend INT, mrecommend INT, srecommend INT
					, roleid tinyint, Currency INT, CurrencyName NVARCHAR(50), isfinished BIT DEFAULT 0)
	DECLARE @TempError TABLE (ErrMsg VARCHAR(MAX))

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
	END TRY
	BEGIN CATCH
		SELECT  @ErrMsg = N'Invalid Json Input'	, @ErrCode = 3 ;	
		RETURN
	END CATCH

	DECLARE @CurrencyName NVARCHAR(50)
		,@CustID INT, @username VARCHAR(30), @recommend INT, @mrecommend INT, @srecommend INT, @roleid tinyint, @Currency INT
		,@CreatorID INT = 10278938, @Pass VARCHAR(100), @Super_RollBack VARCHAR(MAX) = ''

	SELECT @FailedCurrencies = '', @ListSuperRollBack = '', @InsBalExceptCustList = ''
	SELECT @Pass='8058095B7DDB08A608811097E5DB8D'

	WHILE (1 = 1)
	BEGIN
		SELECT @ErrCode = 0, @ErrMsg = '', @ErrExtraInfo = ''
		
		SELECT TOP 1 @Currency = t.Currency , @CurrencyName = CurrencyName
		FROM #CustomerList t
		WHERE isfinished = 0	

		IF @@ROWCOUNT = 0 BREAK

		--Create full line
		WHILE 1= 1
		BEGIN
			SELECT TOP 1 
				@CustID = custid,
				@username = username,
				@recommend = recommend,
				@mrecommend = mrecommend,
				@srecommend = srecommend,
				@roleid = roleid
			FROM #CustomerList t
			WHERE isfinished = 0	
				AND t.Currency = @Currency
			ORDER BY RoleID DESC
			
			IF @@ROWCOUNT = 0 
				BREAK;

			BEGIN TRY
				IF @roleid = 4
				BEGIN
					EXEC Acc_Dep_CustomerInsMember_Com @Custid=@CustID,@Username=@username,@creator=@CreatorID
						,@userpwd=@Pass,@site=@sitename,@currency=@Currency,@IP=@IP,@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT, @ErrExtraInfo = @ErrExtraInfo OUTPUT
				END
				ELSE IF @roleid = 3
				BEGIN
					EXEC Acc_Dep_CustomerInsMember_SAg @Custid=@CustID,@Username=@username,@creator=@CreatorID
						,@userpwd=@Pass,@srecommend=@srecommend,@IP=@IP,@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT, @ErrExtraInfo = @ErrExtraInfo OUTPUT
				END
				ELSE IF @roleid = 2
				BEGIN
					EXEC Acc_Dep_CustomerInsMember_MAg @Custid=@CustID,@Username=@username,@creator=@CreatorID
						,@userpwd=@Pass,@mrecommend=@mrecommend,@IP=@IP,@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT, @ErrExtraInfo = @ErrExtraInfo OUTPUT
				END
				ELSE IF @roleid = 1
				BEGIN
					EXEC Acc_Dep_CustomerInsMember_Ag 
						 @Custid=@CustID,@Username=@username,@creator=@CreatorID
						,@userpwd=@Pass,@recommend=@recommend,@IP=@IP,@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT, @ErrExtraInfo = @ErrExtraInfo OUTPUT
				END
			
				IF @ErrCode<>0
					GOTO RollbackCurrency;	
			END TRY
			BEGIN CATCH 
				SELECT @ErrCode = 911
				SELECT @ErrExtraInfo = ERROR_MESSAGE()
				GOTO RollbackCurrency;
			END CATCH

			UPDATE t
			SET t.isfinished = 1
			FROM #CustomerList t
			WHERE t.Currency = @Currency
				AND t.CustID = @CustID

			--Rollback Currency if have any error of this currency
			RollbackCurrency:
			IF @ErrCode <> 0
			BEGIN 
				INSERT INTO @TempError ( ErrMsg) 
				SELECT 'Create User '+ @username + ': '  + ISNULL(@ErrMsg,'') + ' - '  + ISNULL(@ErrExtraInfo,'')  

				--PRINT @ErrMsg + ': ' + @username
				SELECT @Super_RollBack= CAST(@srecommend AS VARCHAR(20))
				SELECT @FailedCurrencies = ISNULL(@FailedCurrencies , '') + ',' + @CurrencyName
				SELECT @ListSuperRollBack = ISNULL(@ListSuperRollBack , '') + ',' + @Super_RollBack
				EXEC dbo.[Acc_Dep_CustomerIns_Rollback_Multiple] @CustIDs = @Super_RollBack, @IsRollbackFullLine = 1 

				UPDATE t
				SET t.isfinished = 1
				FROM #CustomerList t
				WHERE t.Currency = @Currency

 				BREAK;			
			END
		END

		IF ISNULL(@ErrCode,0) = 0 -- Enable Cashout if create fullline successfully
		BEGIN
			--Enable CashOut
			BEGIN TRY
				EXEC [Acc_3rdProductUpdSuperStatus] @ProductID=25, @CustID=@srecommend
					,@IsEnable=1,@ApplyToMember=1,@UserID=@CreatorID,@IP=@IP,@ErrMsg=@ErrMsg OUTPUT

				IF @ErrMsg <> ''
				BEGIN
					INSERT INTO @TempError (ErrMsg) 
					SELECT 'CashOut '+ @CurrencyName + ' : ' + @ErrMsg
				END
			END TRY
			BEGIN CATCH 
				INSERT INTO @TempError (ErrMsg) 
				SELECT 'CashOut '+ @CurrencyName + ' : ' + ERROR_MESSAGE()
			END CATCH
		END
		
		UPDATE t
		SET t.isfinished = 1
		FROM #CustomerList t
		WHERE t.Currency = @Currency
	END

	SELECT @FailedCurrencies = STUFF(@FailedCurrencies,1,1,'')
	SELECT @ListSuperRollBack = STUFF(@ListSuperRollBack,1,1,'')

	DELETE t 
	FROM #CustomerList t
		LEFT JOIN customer ci WITH(NOLOCK) 
			ON t.CustID = ci.custid
	WHERE ci.custid IS NULL

	SET @Customers_List = (
		SELECT CustID,username,recommend,mrecommend,srecommend,roleid,Currency,CurrencyName  
		FROM #CustomerList
		FOR Json PATH
		)

	SET @ErrExtraInfo = (
		SELECT ErrMsg
		FROM @TempError
		FOR Json PATH
		)

	IF ISNULL(@Customers_List,'') = '' --Failed all
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

	DROP TABLE #CustomerList
END	
GO
