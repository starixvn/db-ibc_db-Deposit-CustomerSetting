/*<info serverAlias="DBCUST-CUSTDB" executers="bodbadminNet" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_Initial_DCS_SettingConfig_Ins]
	@ProductID TINYINT,
	@SportTypeList VARCHAR(MAX), 
	@BetTypeList VARCHAR(MAX),
	@Site VARCHAR(MAX),
	@Currency VARCHAR(MAX),
	@StartTime DATETIME,
	@IsTest	BIT,
	@Remark	VARCHAR	(1000) = '',
	@XMLConfig VARCHAR(MAX) = '',
	@BetSettingXML VARCHAR(MAX) = '',
	@UserId	INT = 0,
	@IP	VARCHAR(45) = '',
	@IsWarning BIT = 0 OUTPUT,
	@IsConfirmed BIT = 0
AS
/*
	Created: 20220913@Eden
	Task : Insert Initial Setting config
	DB: DBCUST/CUSTDB
	Original:

	Revisions:  
	- 20220913@Eden: Flexible Initializing Deposit Customer Setting [RedmineID: #169648]

	Parameter Definition

	Example: 
		DECLARE @IsWarning BIT = 0
		EXEC [Acc_Dep_Initial_DCS_SettingConfig_Ins] 
			@ProductID		= 1,
			@SportTypeList =  '1,2,43,5,8',
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
			,@IsConfirmed = 1
			SELECT @IsWarning

	*/
BEGIN
	SET NOCOUNT ON
	DECLARE @ActionID INT  = 201064
	DECLARE @StartRun DATETIME, @EndRun DATETIME, @Duration INT
	SET @StartRun = GETDATE()

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
		[ID] [INT]
	)

	CREATE TABLE #TempBetSetting(
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
	)

	CREATE TABLE #ErrorTbl (ID INT,ErrorCode INT , ErrorMsg VARCHAR(max))
	CREATE TABLE #BetSettingErrorTbl (ConfigRowID INT, BSRowID INT,SettingType TINYINT, Currency INT, Sporttype SMALLINT, Bettype SMALLINT, ErrCode INT)

	EXEC Acc_Dep_Initial_DCS_SettingConfig_Check 
			@ProductID		= @ProductID,
			@SportTypeList = @SportTypeList,
			@BetTypeList = @BetTypeList,
			@Site = @Site,
			@Currency = @Currency,
			@StartTime = @StartTime,
			@IsTest = @IsTest,
			@XMLConfig = @XMLConfig,
			@BetSettingXML = @BetSettingXML,
			@IsWarning = @IsWarning OUT,
			@IsConfirmed = @IsConfirmed

	IF EXISTS ( SELECT 1 FROM #ErrorTbl)
	BEGIN
		GOTO ReturnErrorTbl;
	END

	IF @IsWarning = 1
		RETURN

	DECLARE @ConfigID INT
	
	--Insert Config
	INSERT INTO Dep_Initial_ProductConfig(
		 ProductID
		,SportTypeList
		,BetTypeList
		,Site
		,Currency
		,StartTime
		,IsTest
		,Status
		,Remark
	)
	SELECT @ProductID
		,@SportTypeList
		,@BetTypeList
		,@Site
		,@Currency
		,@StartTime
		,@IsTest
		,0
		,@Remark 

	SELECT @ConfigID = SCOPE_IDENTITY()

	INSERT INTO Dep_Initial_ProductConfig_Detail(
		 ConfigID
		,SportType
		,BetType
		,IsLive
		,SettingType
		,IsDefault
		,DefaultValueSuper
		,DefaultValueMaster
		,DefaultValueAgent
		,DefaultValueMember
		,SpecialRequirement
	)
	SELECT @ConfigID
		,SportType
		,BetType
		,IsLive
		,SettingType
		,IsDefault
		,DefaultValueSuper
		,DefaultValueMaster
		,DefaultValueAgent
		,DefaultValueMember
		,SpecialRequirement
	FROM #TempConfig

	INSERT INTO Dep_Initial_BetSetting(ConfigID,SportType,BetType,MinBet,MaxBet,MaxPerMatch,MaxPerNumber,MaxPayoutPerMatch,Currency)
	SELECT @ConfigID,SportType,BetType,MinBet,MaxBet,MaxPerMatch,MaxPerNumber,MaxPayoutPerMatch,Currency FROM #TempBetSetting

	SET @EndRun = GETDATE()
	SET @Duration = DATEDIFF (MILLISECOND, @StartRun, @EndRun)

	DECLARE @LogData VARCHAR(MAX), @LogXML XML

	SET @LogXML = (
					SELECT  (
							SELECT   @ConfigID			AS '@ConfigID'
									,@ProductID			AS '@ProductID'	
									,@SportTypeList		AS '@SportTypeList'
									,@BetTypeList		AS '@BetTypeList'
									,@Site				AS '@Site'
									,@Currency			AS '@Currency'
									,@StartTime			AS '@StartTime'
									,@IsTest			AS '@IsTest'
									,@Remark			AS '@Remark'
									,@IP				AS '@IP'
							FOR XML PATH('InitConfig'), TYPE ),
							(
								SELECT	 SportType				AS '@SportType'
										,BetType				AS '@BetType'
										,IsLive					AS '@IsLive'
										,SettingType			AS '@SettingType'
										,IsDefault				AS '@IsDefault'
										,DefaultValueSuper		AS '@DefaultValueSuper'
										,DefaultValueMaster		AS '@DefaultValueMaster'
										,DefaultValueAgent		AS '@DefaultValueAgent'
										,DefaultValueMember		AS '@DefaultValueMember'
										,SpecialRequirement		AS '@SpecialRequirement'
								FROM #TempConfig				
								ORDER BY SportType, BetType, IsLive, SettingType			
							FOR XML PATH ('Row'),ROOT ('Detail'), TYPE ),
							(
								SELECT	 SportType				AS '@SportType'
										,BetType				AS '@BetType'
										,Currency				AS '@Currency'
										,MinBet					AS '@MinBet'
										,MaxBet					AS '@MaxBet'
										,MaxPerMatch			AS '@MaxPerMatch'
										,MaxPerNumber			AS '@MaxPerNumber'
										,MaxPayoutPerMatch		AS '@MaxPayoutPerMatch'
								FROM #TempBetSetting				
								ORDER BY SportType, BetType, Currency			
							FOR XML PATH ('Row'),ROOT ('BS'), TYPE )
						FOR XML PATH('R'), TYPE
					)

	SET @LogData = REPLACE(CONVERT(VARCHAR(MAX), @LogXML), '" />', '"/"')	

	--Write log:
	EXEC dbo.Acc_WriteLog_UserLog_RunSP_Wrapper
				@UserId				= @UserId,
				@CustId				= 0,
				@ActionId			= @ActionID,
				@TrackingValue		= @LogData,
				@Duration			= @Duration
	
	ReturnErrorTbl:
	SELECT * FROM #ErrorTbl
	SELECT * FROM #BetSettingErrorTbl

	DROP TABLE #TempConfig
	DROP TABLE #ErrorTbl
	DROP TABLE #BetSettingErrorTbl
	DROP TABLE #TempBetSetting
END
GO


