/*<info serverAlias="DBCUST-CUSTDB" executers="" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_Initial_DCS_ScanConfig]
	@ConfigID INT = 0 OUTPUT,
	@IsProd BIT = 0 OUTPUT, --1: PROD env, 0: Testing env ( to config more replicated server)
	@MaxcustID INT = 0 OUTPUT,
	@IsTest BIT = NULL
AS
/*
	Created: 20220913@Eden
	Task : Job detect initial Setting Process
	DB: DBCUST/CUSTDB
	Original:

	Revisions:  
	- 20220913@Eden: Flexible Initializing Deposit Customer Setting [RedmineID: #169648] 

	Value Mapping
		CurrentStep = :
			1: Delete existing customer setting
			2: Insert customer setting
			3: Insert setting for new customer
			....

	Example: 
	DECLARE @ConfigID INT, @MaxcustID INT, @IsProd BIT
	EXEC [Acc_Dep_Initial_DCS_ScanConfig] 
		@ConfigID = @ConfigID OUTPUT,
		@IsProd = @IsProd OUT,
		@MaxcustID = @MaxcustID OUT
	SELECT @ConfigID AS ConfigID,
		   @IsProd AS IsProd,
		   @MaxcustID AS MaxcustID
	
	*/
BEGIN
	SET NOCOUNT ON
	DECLARE @XMLConfig VARCHAR(MAX),
	@BetSettingXML VARCHAR(MAX)

	SELECT @ConfigID = 0

	IF @@SERVERNAME = 'DBCUST'
		SET @IsProd = 1
	ELSE
		SET @IsProd = 0

	IF @IsTest IS NULL
	BEGIN
		IF @IsProd = 1 
			SET @IsTest = 0 -- dont't initial for test config on PRODUCTION
		ELSE
			SET @IsTest = 1
	END

	IF EXISTS ( SELECT 1 FROM Dep_Initial_ProductConfig WITH(NOLOCK) WHERE Status = 1 AND IsTest <= @IsTest) --RUNNING
	BEGIN
		PRINT 'Have process is running'
		GOTO ReturnLB;
	END

	SELECT TOP(1) @ConfigID = ConfigID  
	FROM Dep_Initial_ProductConfig WITH(NOLOCK) 
	WHERE Status IN (0) --Planned
		AND StartTime <= GETDATE()
		AND IsTest <= @IsTest
		AND ConfigID > 0
	ORDER BY StartTime, ConfigID

	IF @ConfigID IS NOT NULL
	BEGIN
		EXEC [Acc_Dep_Initial_DCS_ConfigStatus_Upd] 
			@ConfigID = @ConfigID,
			@Status = 1
	END
	ELSE
	BEGIN
		PRINT 'Have no process need to be run on this time'
		GOTO ReturnLB;
	END
	
	-------------------> Start initial data for running process-----------------------------------
	DECLARE @Site VARCHAR(MAX), @Currency VARCHAR(MAX)
	DECLARE @TBL_site TABLE(SiteID INT,Site nvarchar(50) PRIMARY KEY)
	DECLARE @TBL_Currency TABLE(Currency INT PRIMARY KEY)

	SELECT @Site = Site, @Currency = Currency
	FROM Dep_Initial_ProductConfig WITH(NOLOCK)
	WHERE ConfigID = @ConfigID
		AND Status = 1 --Running

	IF @@ROWCOUNT = 0
	BEGIN
		PRINT 'No site/currency'
		GOTO ReturnLB;
	END
	
	IF EXISTS(
		SELECT TOP 1 1 
		FROM Dep_Initial_ProductConfig_Detail WITH(NOLOCK)
		WHERE ConfigID = @ConfigID
	)
	BEGIN
		SELECT @XMLConfig = (
		SELECT	 idt.SportType
				,idt.BetType
				,idt.IsLive
				,idt.SettingType
				,idt.IsDefault
				,idt.DefaultValueSuper
				,idt.DefaultValueMaster
				,idt.DefaultValueAgent
				,idt.DefaultValueMember
				,idt.SpecialRequirement
				,t.SettingName
		FROM Dep_Initial_ProductConfig_Detail idt WITH(NOLOCK)
			INNER JOIN Dep_ProductSettingType t WITH(NOLOCK) ON t.SettingType = idt.SettingType
		WHERE ConfigID = @ConfigID
		FOR XML RAW('R') ,ROOT ('ROOT'))

	END
	ELSE
	BEGIN
		PRINT 'No Setting'
		GOTO ReturnLB;
	END

	IF EXISTS(
		SELECT TOP 1 1 
		FROM Dep_Initial_BetSetting WITH(NOLOCK)
		WHERE ConfigID = @ConfigID
	)
	BEGIN
		SELECT @BetSettingXML = (
		SELECT	 SportType				
				,BetType				
				,Currency				
				,MinBet					
				,MaxBet					
				,MaxPerMatch			
				,MaxPerNumber			
				,MaxPayoutPerMatch		
		FROM Dep_Initial_BetSetting	
		WHERE ConfigID = @ConfigID
		FOR XML RAW('R') ,ROOT ('BS'))
	END	

	--> Insert Initial_StepByConfig
	EXEC Acc_Dep_Initial_DCS_InsertStepByConfigID @ConfigID = @ConfigID

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

	DECLARE @MaxCustTBL TABLE( custid INT)
	DECLARE @sql nvarchar(max) = ''

	--> Get @maxcustID
	IF @IsProd = 1 --PRODUCTION --> get maxcustid from DBTP
	BEGIN
		SET @sql = '
		SELECT Custid
		FROM OPENQUERY (DBTP, ''SELECT  TOP (1) c.Custid 
								FROM bodb02.dbo.custInfo c WITH(NOLOCK)
								ORDER BY c.CustID DESC'')'

		INSERT INTO @MaxCustTBL(custid)
		EXEC (@sql)

		SELECT @MaxcustID = custid 
		FROM @MaxCustTBL
	END
	ELSE
	BEGIN
		SELECT  TOP (1) @maxcustID = c.Custid 
		FROM custInfo c WITH(NOLOCK)
		ORDER BY c.CustID DESC
	END
	  
	TRUNCATE TABLE Dep_Initial_Super

	--> Insert supers to queue
	INSERT INTO Dep_Initial_Super(CustID,CurrentStep)
	SELECT ci.custid, 0 AS CurrentStep
	FROM customer ci WITH (NOLOCK) 
		INNER JOIN @TBL_Currency ex ON ci.currency = ex.Currency
		INNER JOIN @TBL_site s ON ci.Site = s.Site
		INNER JOIN Dep_custsuper cs WITH (NOLOCK) ON ci.custid = cs.custid
		INNER JOIN custInfo c WITH(NOLOCK) ON c.custid = ci.custid
	WHERE ci.roleid = 4  
		AND ci.username NOT LIKE '3rdSuper%'
		AND c.Enabled = 1
		AND ci.custid <= @maxcustID

	IF @@SERVERNAME IN( 'DBSPARE','DBBACKUP2') -- DBTEST --> Get MaxcustID to test new accs steps
	BEGIN
		SELECT @MaxcustID = MIN(custid)
		FROM
		(
			SELECT TOP (500) ci.custid
			FROM Dep_Initial_Super it WITH(NOLOCK)
				INNER JOIN custInfo ci WITH(NOLOCK) ON it.CustID = ci.srecommend
			ORDER BY ci.custid DESC
		)topx

		--Delete direct acc > @MaxcustID
		DELETE 
		FROM Dep_Initial_Super WITH(ROWLOCK,UPDLOCK) 
		WHERE CustID > @MaxcustID
	END

	ReturnLB:
	SELECT CAST(StepID AS INT) AS StepID, IsScanCustomer, ISNULL(@XMLConfig,'') AS XMLConfig, ISNULL(@BetSettingXML,'') AS BetSettingXML
	FROM Dep_Initial_StepByConfig WITH(NOLOCK) 
	ORDER BY SortOrder
END
GO


