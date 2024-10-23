/*<info serverAlias="DBGLOB-GlobCustDB" executers="asv_cust" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[API_SiteBuilder_Customers_Register]
	@Usernames_Register	VARCHAR(MAX)= NULL,
	@sitename	VARCHAR(10)= NULL,
	@IsChinaView BIT = 0,
	@SpecialPlatform TINYINT = 0,
	@SiteDBGroupID	SMALLINT = 0,
	@IP	VARCHAR(50) = NULL,
	@ProductStakeLevel	VARCHAR(MAX)= NULL,
	@Mode TINYINT = 1, -- 1: New Licensee, 2: New Currency, 3: Create Dummy Accounts Only
	@ErrCode INT = 0 OUTPUT,
	@ErrMsg NVARCHAR(2000) = '' OUTPUT,
	@Customers_List VARCHAR(MAX) = NULL OUTPUT,
	@SiteID INT = 0 OUTPUT,
	@FailedCurrencies VARCHAR(MAX) = '' OUTPUT,
	@ErrExtraInfo VARCHAR(MAX) = '' OUTPUT -- Log DB
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
		DECLARE @ErrCode INT = 0 , @ErrMsg NVARCHAR(2000) = '', @Customers_List VARCHAR(MAX), @SiteID INT,@FailedCurrencies VARCHAR(MAX)
		EXEC [API_SiteBuilder_Customers_Register_UAT2]
			 @Usernames_Register = '[{"Super":"Edentest1SuperGBP","Master":"Edentest1GBP","Agent":"Edentest1GBP01","AccMaster":"Edentest1ACCGBP","AccAgent":"Edentest1ACCGBP01"
									,"Transf":"Edentest1TransferGBP","Charge":"Edentest1ChargesGBP","Bonus01":"Edentest1BonusGBP","Bonus02":"Edentest1Bonus02GBP"
									 ,"Withdraw":"Edentest1WithdrawalGBP","Dummy3rd":"Edentest1Dummy3rdGBP","Currency":12,"ClearBal":"Edentest1GBP01ClearBal"
									 ,"Sub2":"Edentest1GBP02","Sub3":"Edentest1GBP03","Sub4":"Edentest1GBP04","Sub5":"Edentest1GBP05","Sub6":"Edentest1GBP06"
									 ,"Sub7":"Edentest1GBP07","Sub8":"Edentest1GBP08","Sub9":"Edentest1GBP09","Sub10":"Edentest1GBP10","Sub11":"Edentest1GBP11"
									 ,"CurrencyName":"GBP"},
									{"Super":"Edentest1SuperTB","Master":"Edentest1TB","Agent":"Edentest1TB01","AccMaster":"Edentest1ACCTB","AccAgent":"Edentest1ACCTB01"
									 ,"Transf":"Edentest1TransferTB","Charge":"Edentest1ChargesTB","Bonus01":"Edentest1BonusTB","Bonus02":"Edentest1Bonus02TB"
									 ,"Withdraw":"Edentest1WithdrawalTB","Dummy3rd":"Edentest1Dummy3rdTB","Currency":4,"ClearBal":"Edentest1TB01ClearBal"
									 ,"Sub2":"Edentest1TB02","Sub3":"Edentest1TB03","Sub4":"Edentest1TB04","Sub5":"Edentest1TB05","Sub6":"Edentest1TB06"
									 ,"Sub7":"Edentest1TB07","Sub8":"Edentest1TB08","Sub9":"Edentest1TB09","Sub10":"Edentest1TB10","Sub11":"Edentest1TB11"
									 ,"CurrencyName":"TB"}]'
			,@ProductStakeLevel = '[{"Currency":4,"GameTypeID":4601,"MinStake":"20","MaxStake":"100"},
									{"Currency":4,"GameTypeID":4601,"MinStake":"20","MaxStake":"2000"},
									{"Currency":12,"GameTypeID":4601,"MinStake":"20","MaxStake":"100"}, 
									{"Currency":12,"GameTypeID":4601,"MinStake":"20","MaxStake":"2000"} 
									]'
			,@sitename			= 'Edentest1'
			,@IsChinaView		= 0
			,@SpecialPlatform	= 0
			,@SiteDBGroupID		= 0
			,@Mode				= 1
			,@ErrCode			= @ErrCode OUTPUT
			,@ErrMsg			= @ErrMsg OUTPUT
			,@Customers_List	= @Customers_List OUTPUT
			,@SiteID			= @SiteID OUTPUT
			,@FailedCurrencies  = @FailedCurrencies OUTPUT

		SELECT  @ErrCode		AS ErrCode		
				,@ErrMsg		AS ErrMsg
				,@Customers_List AS Customers_List
				,@SiteID AS SiteID
				,@FailedCurrencies AS FailedCurrencies 
*/			   					
BEGIN
	DECLARE @CustDBGroupID smallint = 0
	DECLARE @tmpStakeLevel TABLE(Currency INT, GameTypeID INT, MinStake DECIMAL(19,8), MaxStake DECIMAL(19,8),MinLabel NVARCHAR(50),MaxLabel NVARCHAR(50));
	DECLARE @SiteDBConfig TABLE ( 
		 CustDBGroupID	smallint
		,LinkedServerNameDBCUST	varchar(512)
		,ClientAccessNameDBCUST varchar(512)
		,AGIP_DBCUST varchar(50)
		,FQDN_DBCUST varchar(50)
		,SiteDBGroupID	smallint
		,LinkedServerName	varchar(512)
		,ClientAccessName varchar(512)
		,AGIP varchar(50)
		,FQDN varchar(50)
	)

	IF @Mode IN(1,2) -- Onebook Site builder
	BEGIN
		BEGIN TRY
			INSERT INTO @tmpStakeLevel(Currency, GameTypeID, MinStake, MaxStake)
			SELECT Currency, GameTypeID, MinStake, MaxStake
			FROM OPENJSON(@ProductStakeLevel) WITH (
							 Currency INT  '$.Currency'
							,GameTypeID INT	'$.GameTypeID'
							,MinStake DECIMAL(19,8)  '$.MinStake'
							,MaxStake DECIMAL(19,8)  '$.MaxStake'
						)
		END TRY
		BEGIN CATCH
			SELECT  @ErrMsg = N'Invalid Json Input'	, @ErrCode = 3 ;	
			RETURN
		END CATCH
	END
	ELSE
	BEGIN
		SET @ProductStakeLevel = NULL
	END
	
	IF @Mode = 1 --New Licensee
	BEGIN
		-- Get @CustDBGroupID
		INSERT INTO @SiteDBConfig(CustDBGroupID,LinkedServerNameDBCUST,ClientAccessNameDBCUST,AGIP_DBCUST,FQDN_DBCUST
								 ,SiteDBGroupID,LinkedServerName,ClientAccessName,AGIP,FQDN)
		EXEC API_SiteBuilder_GetCustomerSiteDB @SiteDBGroupID = @SiteDBGroupID

		SELECT TOP 1 @CustDBGroupID = ISNULL(CustDBGroupID,0) FROM @SiteDBConfig

		IF @SiteDBGroupID IS NULL
		BEGIN
			SELECT @ErrMsg = 'Invalid SiteDBGroupID', @ErrCode = 10010
			RETURN
		END

		IF EXISTS (SELECT TOP 1 1 FROM dbo.Site WITH (NOLOCK) WHERE site = @Sitename) 
			OR EXISTS (SELECT TOP 1 1 FROM bodb_Licensee.dbo.Licensees WITH (NOLOCK) WHERE LicenseeName = @Sitename)
		BEGIN
			SELECT @ErrMsg = 'Site Name already exists.', @ErrCode = 10003
			RETURN
		END
		
		INSERT INTO dbo.Site(site, ServerID, isLicensee, isActive, isDeposit, IsChinaView, SiteDBGroupID, SpecialPlatfrom,CustDBGroupID)
		VALUES (@sitename, 0, 1, 1, 1 , @IsChinaView, @SiteDBGroupID, @SpecialPlatform, @CustDBGroupID)
	
		IF @@ERROR <> 0
		BEGIN
			SELECT @ErrMsg = 'Insert Site Failed', @ErrCode = 10001

			RETURN
		END

		-- New Licensee, add UUS Stake Level
		INSERT INTO	@tmpStakeLevel (Currency,GameTypeID,MinLabel,MaxLabel,MinStake,MaxStake)
		SELECT DISTINCT Currency = 20, GameTypeID,st.MinStake,st.MaxStake,st.MinStake,st.MaxStake
		FROM @tmpStakeLevel t
			CROSS APPLY ( SELECT 5 AS MinStake ,500 AS MaxStake UNION ALL
							SELECT 5 AS MinStake ,1000 AS MaxStake UNION ALL
							SELECT 5 AS MinStake ,2000 AS MaxStake ) st
	END
	ELSE -- New Currency
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.Site WITH (NOLOCK) WHERE site = @Sitename) 
		OR NOT EXISTS (SELECT TOP 1 1 FROM bodb_Licensee.dbo.Licensees WITH (NOLOCK) WHERE LicenseeName = @Sitename)
		BEGIN
			SELECT @ErrMsg = 'Site Name does not exist.', @ErrCode = 10013
			RETURN
		END  

	END

	UPDATE t 
	SET t.MinLabel = FORMAT(t.MinStake, '#,#0.####'),
		t.MaxLabel = FORMAT(t.MaxStake, '#,#0.####')
	FROM @tmpStakeLevel t

	--> Get SiteID 
	SELECT @SiteID = siteid, @CustDBGroupID = CustDBGroupID FROM dbo.Site WITH (NOLOCK) WHERE site = @Sitename

	CREATE TABLE #Username( Super VARCHAR(30),Master VARCHAR(30),Agent VARCHAR(30),AccMaster VARCHAR(30)
						,AccAgent VARCHAR(30),Transf VARCHAR(30),Charge VARCHAR(30),Bonus01 VARCHAR(30),Bonus02 VARCHAR(30)
						,Withdraw VARCHAR(30),Dummy3rd VARCHAR(30),Currency INT,ClearBal VARCHAR(30)	
						,Sub2 VARCHAR(30),Sub3 VARCHAR(30),Sub4 VARCHAR(30),Sub5 VARCHAR(30),Sub6 VARCHAR(30)
						,Sub7 VARCHAR(30),Sub8 VARCHAR(30),Sub9 VARCHAR(30),Sub10 VARCHAR(30),Sub11 VARCHAR(30)
						--,CashOut VARCHAR(30),CO_Sub2 VARCHAR(30),CO_Sub3 VARCHAR(30),CO_Sub4 VARCHAR(30),CO_Sub5 VARCHAR(30),CO_Sub6 VARCHAR(30)
						--,CO_Sub7 VARCHAR(30),CO_Sub8 VARCHAR(30),CO_Sub9 VARCHAR(30),CO_Sub10 VARCHAR(30),CO_Sub11 VARCHAR(30)
						, CurrencyName NVARCHAR(50),Isfinished BIT DEFAULT (0)
						, Exchange VARCHAR(30)
						, OddsBoostAdj VARCHAR(30)
						)

	DECLARE @tmpSubUserName VARCHAR(30),@tmpSubCustID INT,@tmpDumUserName VARCHAR(30),@tmpDumCustID INT	
	CREATE TABLE #tempSubUserName (Username VARCHAR(30),isfinished BIT DEFAULT(0))
	CREATE TABLE #tempDumUserName (Username VARCHAR(30),UplineID INT,isfinished BIT DEFAULT(0))
	CREATE TABLE #Generated_CustList(CustID INT, username VARCHAR(30), recommend INT, mrecommend INT, srecommend INT, roleid tinyint, Currency INT, CurrencyName NVARCHAR(50))
	DECLARE @TempError TABLE (ErrMsg VARCHAR(MAX))

	SET NOCOUNT ON
	BEGIN TRY
		INSERT INTO #Username(Super,Master,Agent,AccMaster,AccAgent,Transf,Charge 
				,Bonus01,Bonus02,Withdraw,Dummy3rd,Currency,ClearBal
				,Sub2,Sub3,Sub4,Sub5,Sub6,Sub7,Sub8,Sub9,Sub10,Sub11
				,CurrencyName,Exchange,OddsBoostAdj
				--,CashOut,CO_Sub2,CO_Sub3,CO_Sub4,CO_Sub5,CO_Sub6,CO_Sub7,CO_Sub8,CO_Sub9,CO_Sub10,CO_Sub11
				)
		SELECT Super,Master,Agent,AccMaster,AccAgent,Transf,Charge 
				,Bonus01,Bonus02,Withdraw,Dummy3rd,Currency,ClearBal
				,Sub2,Sub3,Sub4,Sub5,Sub6,Sub7,Sub8,Sub9,Sub10,Sub11
				,CurrencyName,Exchange,OddsBoostAdj
				--,CashOut,CO_Sub2,CO_Sub3,CO_Sub4,CO_Sub5,CO_Sub6,CO_Sub7,CO_Sub8,CO_Sub9,CO_Sub10,CO_Sub11
		FROM OPENJSON(@Usernames_Register) 
		WITH (
				 Super VARCHAR(30) '$.Super',Master VARCHAR(30) '$.Master',Agent VARCHAR(30) '$.Agent',AccMaster VARCHAR(30) '$.AccMaster'
				,AccAgent VARCHAR(30)'$.AccAgent',Transf VARCHAR(30)'$.Transf',Charge VARCHAR(30)'$.Charge',Bonus01 VARCHAR(30)'$.Bonus01',Bonus02 VARCHAR(30)'$.Bonus02'
				,Withdraw VARCHAR(30)'$.Withdraw',Dummy3rd VARCHAR(30)'$.Dummy3rd',Currency INT'$.Currency',ClearBal VARCHAR(30)'$.ClearBal'
				,Sub2 VARCHAR(30)'$.Sub2',Sub3 VARCHAR(30)'$.Sub3',Sub4 VARCHAR(30)'$.Sub4',Sub5 VARCHAR(30)'$.Sub5',Sub6 VARCHAR(30)'$.Sub6'
				,Sub7 VARCHAR(30)'$.Sub7',Sub8 VARCHAR(30)'$.Sub8',Sub9 VARCHAR(30)'$.Sub9',Sub10 VARCHAR(30)'$.Sub10',Sub11 VARCHAR(30)'$.Sub11'
				,CurrencyName NVARCHAR(50)'$.CurrencyName',Exchange VARCHAR(30)'$.Exchange',OddsBoostAdj VARCHAR(30)'$.OddsBoostAdj'
				--,CashOut VARCHAR(30)'$.CashOut'	,CO_Sub2 VARCHAR(30)'$.CO_Sub2',CO_Sub3 VARCHAR(30)'$.CO_Sub3',CO_Sub4 VARCHAR(30)'$.CO_Sub4',CO_Sub5 VARCHAR(30)'$.CO_Sub5',CO_Sub6 VARCHAR(30)'$.CO_Sub6'
				--,CO_Sub7 VARCHAR(30)'$.CO_Sub7',CO_Sub8 VARCHAR(30)'$.CO_Sub8',CO_Sub9 VARCHAR(30)'$.CO_Sub9',CO_Sub10 VARCHAR(30)'$.CO_Sub10',CO_Sub11 VARCHAR(30)'$.CO_Sub11'
		)
	END TRY
	BEGIN CATCH
		SELECT  @ErrMsg = N'Invalid Json Input'	, @ErrCode = 3 ;	
		RETURN
	END CATCH

	--SELECT * FROM #Username

	DECLARE  @SuperID INT,@MasterID INT,@AgentID INT,@AccMasterID INT,@AccAgentID INT,@DummyAgentID INT			

	DECLARE @Super VARCHAR(30),@Master VARCHAR(30),@Agent VARCHAR(30),@AccMaster VARCHAR(30),@AccAgent VARCHAR(30)
			,@Transf VARCHAR(30),@Charge VARCHAR(30),@Bonus01 VARCHAR(30)
			,@Bonus02 VARCHAR(30),@Dummy3rd VARCHAR(30),@ClearBal VARCHAR(30),@Withdraw VARCHAR(30)
			,@Sub2 VARCHAR(30),@Sub3 VARCHAR(30),@Sub4 VARCHAR(30),@Sub5 VARCHAR(30),@Sub6 VARCHAR(30)
			,@Sub7 VARCHAR(30),@Sub8 VARCHAR(30),@Sub9 VARCHAR(30),@Sub10 VARCHAR(30),@Sub11 VARCHAR(30)
			,@Currency INT, @CurrencyName NVARCHAR(50),@Exchange VARCHAR(30), @OddsBoostAdj VARCHAR(30)
			,@ListSuperRollBack VARCHAR(MAX) = ''
			,@StakeLevel_ByCurrency VARCHAR(MAX)
			,@CreatorID INT = 10278938	
			,@TmpUsername VARCHAR(30)
		
	SELECT @FailedCurrencies = ''

	--Begin register username
	WHILE (1 = 1)
	BEGIN
		SELECT @ErrCode = 0, @ErrMsg = '', @ErrExtraInfo = '', @SuperID = 0
		
		UPDATE TOP (1) #Username
		SET isfinished = 1
			,@Super=Super,@Master=Master,@Agent=Agent,@AccMaster=AccMaster,@AccAgent=AccAgent
			,@Transf=Transf,@Charge=Charge ,@Bonus01=Bonus01,@Withdraw=Withdraw 
			,@Bonus02=Bonus02,@Dummy3rd=Dummy3rd,@ClearBal=ClearBal
			,@Sub2=sub2,@Sub3=sub3,@Sub4 =sub4,@sub5=sub5,@Sub6=sub6
			,@sub7=sub7,@sub8 =sub8,@sub9=sub9,@Sub10=sub10,@sub11=sub11
			,@Currency=Currency, @CurrencyName = CurrencyName, @Exchange = Exchange , @OddsBoostAdj = OddsBoostAdj
		WHERE isfinished = 0	

		IF @@ROWCOUNT = 0 BREAK
		
		-- Register Super
		EXEC [API_CustomerIns_Register]
			 @UserName		= @Super
			,@roleid		= 4
			,@SiteDBGroupID	= @CustDBGroupID
			,@site			= @sitename
			,@Currency		= @Currency
			,@CustID		= @SuperID OUT
			,@ErrCode		= @ErrCode OUT
			,@ErrMsg		= @ErrMsg OUT
			,@ErrExtraInfo = @ErrExtraInfo OUT

		IF @ErrCode<>0
		BEGIN
			SELECT @TmpUsername = @Super
			GOTO RollbackCurrency; 				
		END
	
		-- Register Master
		EXEC [API_CustomerIns_Register]
			 @UserName		= @Master
			,@UplineID		= @SuperID
			,@roleid		= 3
			,@SiteDBGroupID	= @CustDBGroupID
			,@site			= @sitename
			,@CustID		= @MasterID OUT
			,@ErrCode		= @ErrCode OUT
			,@ErrMsg		= @ErrMsg OUT
			,@ErrExtraInfo = @ErrExtraInfo OUT

		IF @ErrCode<>0
		BEGIN
			SELECT @TmpUsername = @Master
			GOTO RollbackCurrency;		
		END

		-- Register Agent
		EXEC [API_CustomerIns_Register]
			 @UserName		= @Agent
			,@UplineID		= @MasterID
			,@roleid		= 2
			,@SiteDBGroupID	= @CustDBGroupID
			,@site			= @sitename
			,@CustID		= @AgentID OUT
			,@ErrCode		= @ErrCode OUT
			,@ErrMsg		= @ErrMsg OUT
			,@ErrExtraInfo = @ErrExtraInfo OUT

		IF @ErrCode<>0
		BEGIN
			SELECT @TmpUsername = @Agent
			GOTO RollbackCurrency;				
		END

		-- Register Master dummy ACC
		EXEC [API_CustomerIns_Register]
			 @UserName		= @AccMaster
			,@UplineID		= @SuperID
			,@roleid		= 3
			,@SiteDBGroupID	= @CustDBGroupID
			,@site			= @sitename
			,@CustID		= @AccMasterID OUT
			,@ErrCode		= @ErrCode OUT
			,@ErrMsg		= @ErrMsg OUT
			,@ErrExtraInfo = @ErrExtraInfo OUT

		IF @ErrCode<>0
		BEGIN
			SELECT @TmpUsername = @AccMaster
			GOTO RollbackCurrency;			
		END

		-- Register Agent dummy ACC
		EXEC [API_CustomerIns_Register]
			 @UserName		= @AccAgent
			,@UplineID		= @AccMasterID
			,@roleid		= 2
			,@SiteDBGroupID	= @CustDBGroupID
			,@site			= @sitename
			,@CustID		= @AccAgentID OUT
			,@ErrCode		= @ErrCode OUT
			,@ErrMsg		= @ErrMsg OUT
			,@ErrExtraInfo = @ErrExtraInfo OUT

		IF @ErrCode<>0
		BEGIN
			SELECT @TmpUsername = @AccAgent
			GOTO RollbackCurrency;				
		END

		-- Insert Dummy Member
		INSERT INTO #tempDumUserName(Username,UplineID)
		SELECT @ClearBal, @AgentID
		UNION ALL
		SELECT @Transf, @AccAgentID
		UNION ALL
		SELECT @Charge, @AccAgentID
		UNION ALL
		SELECT @Bonus01, @AccAgentID
		UNION ALL
		SELECT @Bonus02, @AccAgentID
		UNION ALL
		SELECT @Withdraw, @AccAgentID
		UNION ALL
		SELECT @Dummy3rd, @AccAgentID
		UNION ALL -- Register dummy Exchange
		SELECT @Exchange , @AccAgentID
		WHERE ISNULL(@Exchange,'') <> ''
		UNION ALL
		SELECT @OddsBoostAdj, @AgentID

		WHILE (1 = 1)
		BEGIN		
			UPDATE TOP (1) #tempDumUserName
			SET isfinished = 1
				,@tmpDumUserName=Username
				,@DummyAgentID=UplineID
			WHERE isfinished = 0

			IF @@ROWCOUNT = 0
				BREAK; 

			EXEC [API_CustomerIns_Register]
				 @UserName		= @tmpDumUserName
				,@UplineID		= @DummyAgentID
				,@roleid		= 1
				,@SiteDBGroupID	= @CustDBGroupID
				,@site			= @sitename
				,@CustID		= @tmpDumCustID OUT
				,@ErrCode		= @ErrCode OUT
				,@ErrMsg		= @ErrMsg OUT
				,@ErrExtraInfo = @ErrExtraInfo OUT

			IF @ErrCode <> 0
				BREAK; 
		END

		IF @ErrCode<>0
		BEGIN
			SELECT @TmpUsername = @tmpDumUserName
			GOTO RollbackCurrency;	
		END

		--Create Sub			
		INSERT INTO #tempSubUserName(Username)
		SELECT @Sub2
		UNION ALL
		SELECT @Sub3
		UNION ALL
		SELECT @Sub4
		UNION ALL
		SELECT @Sub5
		UNION ALL
		SELECT @Sub6
		UNION ALL
		SELECT @Sub7
		UNION ALL
		SELECT @Sub8
		UNION ALL
		SELECT @Sub9
		UNION ALL
		SELECT @Sub10
		UNION ALL
		SELECT @Sub11

		IF NOT EXISTS( SELECT TOP 1 1 FROM #tempSubUserName WHERE ISNULL(Username,'') = '')
		BEGIN
			WHILE (1 = 1)
			BEGIN		
				UPDATE TOP (1) #tempSubUserName
				SET isfinished = 1
					,@tmpSubUserName=Username
				WHERE isfinished = 0

				IF @@ROWCOUNT = 0
					BREAK;

				-- Register Sub Agent
				EXEC [API_CustomerIns_Register]
					 @UserName		= @tmpSubUserName
					,@UplineID		= @MasterID
					,@roleid		= 2
					,@SiteDBGroupID	= @CustDBGroupID
					,@site			= @sitename
					,@CustID		= @tmpSubCustID OUT
					,@ErrCode		= @ErrCode OUT
					,@ErrMsg		= @ErrMsg OUT
					,@ErrExtraInfo = @ErrExtraInfo OUT
						
				IF @ErrCode<>0 
					BREAK;
			END
		END

		IF @ErrCode<>0
		BEGIN
			SELECT @TmpUsername = @tmpSubUserName
			GOTO RollbackCurrency;	
		END

		--Init Global Stake level by Currency for Onebook site builder
		IF ISNULL(@ProductStakeLevel,'') <> ''
		BEGIN
			SELECT @StakeLevel_ByCurrency = CONVERT(VARCHAR(MAX),
														(SELECT (SELECT 
																	 0 AS '@StakeLevelID'
																	,GameTypeID AS '@GameTypeID'
																	,MinLabel AS '@MinLabel'
																	,MaxLabel AS '@MaxLabel'
																	,MinStake AS '@MinStake'
																	,MaxStake AS '@MaxStake'
																FROM @tmpStakeLevel WHERE currency = @Currency
																FOR XML PATH('StakeLevel'),TYPE
																)
														FOR XML PATH('ROOT'),TYPE
														)) 

			--Create Global Stake level : 
			EXEC CustDB.[dbo].[Acc_Dep_CustSetting_GlobalStakeLevelUpdate] 
					 @StakeLevel = @StakeLevel_ByCurrency	
					,@CustID	= @SuperID
					,@Currency	= @Currency
					,@SiteID	= @SiteID
					,@UserID	= @CreatorID 
					,@IP		= @IP
					,@ErrCode	= @ErrCode OUTPUT 
					,@ErrMsg	= @ErrMsg OUTPUT

			IF @ErrCode<>0
			BEGIN
				SELECT @TmpUsername = 'Global Stake level.'
 				GOTO RollbackCurrency;			
			END
		END

		--Rollback Currency if have any error of this currency
		RollbackCurrency:
		IF @ErrCode <> 0
		BEGIN 
			PRINT @ErrMsg + '(' + @TmpUsername + ')'
			INSERT INTO @TempError (ErrMsg) 
			SELECT 'Register User '+ @TmpUsername + ': ' + ISNULL(@ErrMsg,'') + ' - '  + ISNULL(@ErrExtraInfo,'')  

			SELECT @FailedCurrencies = ISNULL(@FailedCurrencies , '') + ',' + @CurrencyName
			SELECT @ListSuperRollBack= CAST(@SuperID AS VARCHAR(20))
			EXEC dbo.[Acc_CustomerIns_Rollback_Multiple] @CustIDs = @ListSuperRollBack, @IsRollbackFullLine = 1 
 			CONTINUE;		
		END

		INSERT INTO #Generated_CustList(CustID,username,recommend,mrecommend,srecommend,roleid,Currency,CurrencyName)
		SELECT CustID,username,recommend,mrecommend,srecommend,roleid,Currency,@CurrencyName
		FROM CustInfoMini WITH(NOLOCK) 
		WHERE srecommend = @SuperID
	END

	SELECT @FailedCurrencies = STUFF(@FailedCurrencies,1,1,'')

	SET @Customers_List = (
		SELECT CustID,username,recommend,mrecommend,srecommend,roleid,Currency,CurrencyName  
		FROM #Generated_CustList
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

	----Delete currency Failed
	--DELETE t 
	--FROM @tmpStakeLevel t
	--	LEFT JOIN #Generated_CustList ci
	--		ON t.Currency = ci.Currency AND ci.roleid = 4
	--WHERE ci.Currency IS NULL

	--SET @ProductStakeLevel = (
	--	SELECT Currency, GameTypeID, MinStake, MaxStake,MinLabel,MaxLabel
	--	FROM @tmpStakeLevel
	--	FOR Json PATH
	--	)

	DROP TABLE #Generated_CustList
	DROP TABLE #tempDumUserName
	DROP TABLE #tempSubUserName
	DROP TABLE #Username
END	
GO
