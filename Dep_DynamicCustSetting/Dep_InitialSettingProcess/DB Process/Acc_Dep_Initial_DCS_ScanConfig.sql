/*<info serverAlias="DBGLOB-GlobCustDB" executers="" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_Initial_DCS_ScanConfig]
	@ConfigID INT = 0 OUTPUT,
	@IsProd BIT = 0 OUTPUT, --1: PROD env, 0: Testing env ( to config more replicated server)
	@MaxcustID INT = 0 OUTPUT,
	@IsTest BIT = NULL
AS
/*
	Created: 20220913@Eden
	Task : Job detect initial Setting Process
	DB: DBGLOB-GlobCustDB
	Original:

	Revisions:  
	- 20220913@Eden: Flexible Initializing Deposit Customer Setting [RedmineID: #169648] 
	- 20250120@Tacy: Move to GlobCustDB [RedmineID: #216870]

	Value Mapping
		CurrentStep = :
			1: Delete existing customer setting
			2: Insert customer setting
			3: Insert setting for new customer
			....

	Example: 
	DECLARE @ConfigID INT, @IsProd BIT, @MaxcustID INT
	EXEC [Acc_Dep_Initial_DCS_ScanConfig] 
		@ConfigID = @ConfigID OUTPUT,
		@IsProd = @IsProd OUTPUT,
		@MaxcustID = @MaxcustID OUTPUT
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

	-- Get MaxCustID
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
	ELSE IF @@SERVERNAME IN ( 'DBSPARE','DBBACKUP2') -- DBTEST --> Get MaxcustID to test new accs steps
	BEGIN 
		SELECT @MaxcustID = MIN(custid)
		FROM
		(
			SELECT TOP 500 ci.custid
			FROM CustInfoMini ci WITH (NOLOCK) 
				INNER JOIN Site s WITH (NOLOCK) ON ci.Site = s.Site
			WHERE ci.roleid = 4  AND s.isDeposit=1 AND s.isActive=1
				AND ci.username NOT LIKE '3rdSuper%'
			ORDER BY ci.custid DESC
		)topx
	END
	ELSE
	BEGIN
		SELECT  TOP (1) @maxcustID = c.Custid
		FROM CustInfoMini c WITH(NOLOCK)
		ORDER BY c.CustID DESC
	END

	ReturnLB:
		SELECT CAST(StepID AS INT) AS StepID, IsScanCustomer, ISNULL(@XMLConfig,'') AS XMLConfig, ISNULL(@BetSettingXML,'') AS BetSettingXML
		FROM Dep_Initial_StepByConfig WITH(NOLOCK) 
		ORDER BY SortOrder
END
GO