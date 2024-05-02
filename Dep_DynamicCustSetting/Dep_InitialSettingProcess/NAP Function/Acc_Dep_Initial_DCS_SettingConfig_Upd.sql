/*<info serverAlias="DBCUST-CUSTDB" executers="wsv_nap" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_Initial_DCS_SettingConfig_Upd]
	@ConfigID INT,
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
	Task : Update Initial Setting config
	DB: DBCUST/CUSTDB
	Original:

	Revisions:  
	- 20220913@Eden: Flexible Initializing Deposit Customer Setting [RedmineID: #169648]

	Parameter Definition

	Example: 
		DECLARE @IsWarning BIT = 0
		EXEC [Acc_Dep_Initial_DCS_SettingConfig_Upd] 
			@ProductID		= 1,
			@SportTypeList = '1,2,43',
			@BetTypeList = '1,2',
			@Site = '0',
			@Currency = '4',
			@StartTime = '2022-07-14 10:00:00.000',
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
								  <R ID="1" SportType="1" BetType="1" MinBet="10.0000" MaxBet="100.0000" MaxPerMatch="1000.0000" MaxPayoutPerMatch="10000.0000" Currency="4" SettingType ="10"/>
								  <R ID="2" SportType="43" BetType="1" MinBet="20.0000" MaxBet="200.0000" MaxPerMatch="2000.0000" MaxPayoutPerMatch="20000.0000" Currency="4" SettingType ="10"/>
								</BS>'
			,@ConfigID = 1
			,@IsWarning = @IsWarning OUT
			,@IsConfirmed = 1
			SELECT @IsWarning

	*/
BEGIN
	SET NOCOUNT ON
	DECLARE @ActionID INT  = 201066
	DECLARE @StartRun DATETIME, @EndRun DATETIME, @Duration INT
	SET @StartRun = GETDATE()
	DECLARE @LogData VARCHAR(MAX), @LogXML XML
		,@LogData_old VARCHAR(MAX), @LogXML_old XML

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

	IF NOT EXISTS( SELECT 1 FROM Dep_Initial_ProductConfig WITH(NOLOCK) WHERE ConfigID = @ConfigID)
	BEGIN
		INSERT INTO #ErrorTbl(ID,ErrorCode,ErrorMsg)
		SELECT NULL
			,ErrCode = 301
			,ErrMsg = 'This row does not exist, please refresh again.'

		GOTO ReturnErrorTbl;
	END

	IF EXISTS( SELECT 1 FROM Dep_Initial_ProductConfig WITH(NOLOCK) WHERE ConfigID = @ConfigID AND Status <> 0)
	BEGIN
		INSERT INTO #ErrorTbl(ID,ErrorCode,ErrorMsg)
		SELECT NULL
			,ErrCode = 302
			,ErrMsg = 'The status of this row is no longer "Planned". You cannot edit or delete this row.'

		GOTO ReturnErrorTbl;
	END

	EXEC Acc_Dep_Initial_DCS_SettingConfig_Check 
			@ConfigID = @ConfigID,
			@ProductID	= @ProductID,
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

	--> Get old data for write log
	SET @LogXML_old = (
					SELECT  (
							SELECT   ConfigID			AS '@ConfigID'
									,ProductID			AS '@ProductID'	
									,SportTypeList		AS '@SportTypeList'
									,BetTypeList		AS '@BetTypeList'
									,Site				AS '@Site'
									,Currency			AS '@Currency'
									,StartTime			AS '@StartTime'
									,IsTest				AS '@IsTest'
									,Remark				AS '@Remark'
									,@IP				AS '@IP'
							FROM Dep_Initial_ProductConfig WITH(NOLOCK)
								WHERE ConfigID = @ConfigID	
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
								FROM Dep_Initial_ProductConfig_Detail WITH(NOLOCK)
								WHERE ConfigID = @ConfigID			
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
								FROM Dep_Initial_BetSetting		
								WHERE ConfigID = @ConfigID	
								ORDER BY SportType, BetType, Currency			
							FOR XML PATH ('Row'),ROOT ('BS'), TYPE )
						FOR XML PATH('R'), TYPE
					)

	--> Update Dep_Initial_ProductConfig
	UPDATE Dep_Initial_ProductConfig WITH(ROWLOCK,UPDLOCK)
	SET  ProductID			= @ProductID
		,SportTypeList		= @SportTypeList
		,BetTypeList		= @BetTypeList
		,Site				= @Site
		,Currency			= @Currency
		,StartTime			= @StartTime
		,IsTest				= @IsTest
		,Remark				= @Remark 
	WHERE ConfigID = @ConfigID

	--> Reresh Dep_Initial_ProductConfig_Detail
	MERGE Dep_Initial_ProductConfig_Detail dt
	USING #TempConfig t
		ON dt.ConfigID = @ConfigID
		AND dt.Sporttype = t.Sporttype
		AND dt.BetType = t.BetType
		AND dt.IsLive = t.IsLive
		AND dt.SettingType = t.SettingType
	WHEN MATCHED AND NOT ( dt.IsDefault							= t.IsDefault
						AND ISNULL(dt.DefaultValueSuper,0)		= ISNULL(t.DefaultValueSuper,0)
						AND ISNULL(dt.DefaultValueMaster,0)		= ISNULL(t.DefaultValueMaster,0)
						AND ISNULL(dt.DefaultValueAgent,0)		= ISNULL(t.DefaultValueAgent,0)
						AND ISNULL(dt.DefaultValueMember,0)		= ISNULL(t.DefaultValueMember,0)
						AND ISNULL(dt.SpecialRequirement,'')	= ISNULL(t.SpecialRequirement,'')
					)
			THEN 
						UPDATE
						SET  dt.IsDefault			= t.IsDefault
							,dt.DefaultValueSuper	= t.DefaultValueSuper
							,dt.DefaultValueMaster	= t.DefaultValueMaster
							,dt.DefaultValueAgent	= t.DefaultValueAgent
							,dt.DefaultValueMember	= t.DefaultValueMember
							,dt.SpecialRequirement	= t.SpecialRequirement
	WHEN NOT MATCHED THEN 
						INSERT (
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
						VALUES( @ConfigID
								,t.SportType
								,t.BetType
								,t.IsLive
								,t.SettingType
								,t.IsDefault
								,t.DefaultValueSuper
								,t.DefaultValueMaster
								,t.DefaultValueAgent
								,t.DefaultValueMember
								,t.SpecialRequirement
							)
	WHEN NOT MATCHED BY SOURCE AND dt.ConfigID = @ConfigID
		THEN DELETE; 

	--> Reresh Dep_Initial_BetSetting
	MERGE Dep_Initial_BetSetting dt
	USING #TempBetSetting t
		ON dt.ConfigID = @ConfigID
		AND dt.Sporttype = t.Sporttype
		AND dt.BetType = t.BetType
		AND dt.Currency = t.Currency
	WHEN MATCHED AND NOT (  ISNULL(dt.MinBet,0)				= ISNULL(t.MinBet,0)
						AND ISNULL(dt.MaxBet,0)				= ISNULL(t.MaxBet,0)
						AND ISNULL(dt.MaxPerMatch,0)		= ISNULL(t.MaxPerMatch,0)
						AND ISNULL(dt.MaxPerNumber,0)		= ISNULL(t.MaxPerNumber,0)
						AND ISNULL(dt.MaxPayoutPerMatch,0)	= ISNULL(t.MaxPayoutPerMatch,0)
					)
			THEN 
						UPDATE
						SET  dt.MinBet				= t.MinBet
							,dt.MaxBet				= t.MaxBet
							,dt.MaxPerMatch			= t.MaxPerMatch
							,dt.MaxPerNumber		= t.MaxPerNumber
							,dt.MaxPayoutPerMatch	= t.MaxPayoutPerMatch
	WHEN NOT MATCHED THEN 
						INSERT (ConfigID,SportType,BetType,MinBet,MaxBet,MaxPerMatch,MaxPerNumber,MaxPayoutPerMatch,Currency
						)
						VALUES(@ConfigID,SportType,BetType,MinBet,MaxBet,MaxPerMatch,MaxPerNumber,MaxPayoutPerMatch,Currency)
	WHEN NOT MATCHED BY SOURCE AND dt.ConfigID = @ConfigID
		THEN DELETE; 

	SET @EndRun = GETDATE()
	SET @Duration = DATEDIFF (MILLISECOND, @StartRun, @EndRun)

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
	SET @LogData_old = REPLACE(CONVERT(VARCHAR(MAX), @LogXML_old), '" />', '"/"')

	--Write log:
	EXEC dbo.Acc_WriteLog_UserLog_RunSP_Wrapper
				@UserId				= @UserId,
				@CustId				= 0,
				@ActionId			= @ActionID,
				@TrackingValue		= @LogData,
				@TrackingValue2		= @LogData_old,
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


