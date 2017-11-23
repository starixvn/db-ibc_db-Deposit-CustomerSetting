/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet,bodbDownlineNet,bodbExtAccNet,bodbLicenseeNet" viewers="vnteam" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_CustSetting_StakeLevelUpd] 
		@CustID			INT
	,	@ProductID		TINYINT
	,	@StakeLevel		VARCHAR(MAX)	
	,	@UserID			INT
	,	@IP				VARCHAR(50)		= ''
	,	@ErrCode		INT				= 0		OUTPUT
	,	@MsgType		INT				= 0		OUTPUT
	,	@ErrMsg			NVARCHAR(200)	= ''	OUTPUT
AS
/*
	Created: 20171113@Winnie
	Task : Update Customer's Stake Level Settings - [Redmine: #85113]
	DB: DBCUST/CustDB
	Original:

	Revisions:
		- 20171113@Winnie: Update Customer's Stake Level Settings - [Redmine: #85113]	

	Param's Explanation:
		@StakeLevel:
		<ROOT>
				<StakeLevel
						SportType="211"
						BetType="2401" 
						StakeLevelList="1,2,3,4,5"
				/>
		</ROOT>

	*/
BEGIN
	SET NOCOUNT ON;

	DECLARE @iDoc INT;
	
	DECLARE @startRun					DATETIME
		,	@endRun						DATETIME
		,	@duration					INT;
		
	DECLARE @logSpData					NVARCHAR(MAX)
		,	@logSpData_Old				NVARCHAR(MAX)
		,	@xml						XML
		,	@ProductName				VARCHAR(50)		
		,	@SettingLevel				TINYINT
		,	@ProductSettingID			INT		
		,	@ActionID					TINYINT=1

	CREATE TABLE	#tmpStake (					
						SportType			SMALLINT
					,	BetType				SMALLINT
					,	StakeLevelList		VARCHAR(200)
					,	MemberStakeLevel	VARCHAR(200)
					,	PRIMARY KEY CLUSTERED (SportType, BetType)
					);

	CREATE TABLE	#StakeLevelList_Old (
						SportType			SMALLINT
					,	BetType				SMALLINT				
					,	StakeLevelList_old	VARCHAR(200)	
					,	PRIMARY KEY CLUSTERED (SportType, BetType)				
					);

	CREATE TABLE #CustStakeLevelDownlines (
					ID						INT IDENTITY (1,1)
				,	CustID					INT 			
				,	RoleID					TINYINT		
				,	SportType				SMALLINT
				,	BetType					SMALLINT
				,	StakeLevelList			VARCHAR(200)
				,	MemberStakeLevel		VARCHAR(200)
				,	PRIMARY KEY CLUSTERED (ID)
				);

	--Check if XML is null or empty
	IF	@StakeLevel IS NULL OR @StakeLevel = ''
		RETURN;

	SELECT	@ErrCode	= 0
		,	@MsgType	= 0
		,	@ErrMsg			= '';

	SET	@startRun = GETDATE();
	SELECT  @SettingLevel=SettingLevel,@ProductSettingID=ProductSettingID from Dep_ProductSetting WITH(NOLOCK) WHERE ProductID=@ProductID AND SettingType IN(7,8)

	--Get line information

	EXEC DBEXT.bodb02.dbo.NAP_LM_CustomerSelCheckAllowedDownlines
	 @custid = @CustID
	,@Language = 'E'
	,@ErrMsg = @ErrMsg OUTPUT
	,@ErrCode=@ErrCode OUTPUT

	IF @ErrCode <> 0 
		RETURN 			

	--Parse XML
	EXECUTE	sp_xml_preparedocument @iDoc OUTPUT, @StakeLevel;

	INSERT INTO #tmpStake
		(	SportType   , BetType   , StakeLevelList)
	SELECT	ox.SportType, ox.BetType, ox.StakeLevelList
	FROM OPENXML (@iDoc, '/ROOT/StakeLevel', 1) 
	WITH (
		SportType		SMALLINT
	,	BetType			SMALLINT
	,	StakeLevelList	VARCHAR(200)	
	) AS ox;

	EXECUTE sp_xml_removedocument @iDoc;

	
	UPDATE tv 
	SET tv.MemberStakeLevel=(SELECT TOP 1 ss.val	
													FROM dbo.strSplit(tv.StakeLevelList, ',') AS ss
													INNER JOIN	dbo.Dep_StakeLevel AS sl WITH(NOLOCK)	ON CAST(ss.val AS INT) = sl.StakeLevelID		
													ORDER BY	sl.MaxStake, sl.MinStake,sl.GameGroupID)
	FROM #tmpStake tv  

	
	INSERT INTO	#StakeLevelList_Old (SportType, BetType, StakeLevelList_old)
	SELECT	cslm.SportType
		,	cslm.BetType
		,	cslm.StakeLevelList			
	FROM	dbo.Dep_CustStakeLevel_Agent AS cslm WITH (NOLOCK)
		INNER JOIN	#tmpStake AS ts
			ON	ts.SportType=cslm.SportType
			AND ts.BetType = cslm.BetType
	WHERE	cslm.CustID = @CustID;

	IF NOT EXISTS(SELECT TOP 1 1 FROM Dep_LicenseeProductSetting WITH(NOLOCK) WHERE Custid=@CustID AND ProductSettingID=@ProductSettingID )
	BEGIN

		INSERT INTO Dep_LicenseeProductSetting(CustID,ProductSettingID)
		VALUES( @CustID,@ProductSettingID)

		SELECT @ActionID=0
	END

	INSERT INTO #CustStakeLevelDownlines(CustID,RoleID,SportType,BetType,StakeLevelList,MemberStakeLevel)
	SELECT CustID,RoleID,SportType,BetType,StakeLevelList,MemberStakeLevel
	FROM CustInfo WITH(NOLOCK)
		CROSS APPLY #tmpStake
	 WHERE srecommend=@CustID

	DECLARE @StartRow INT = 1, @MaxRow INT,@Threshold INT = 10000, @StopRow INT;
			
	SET @MaxRow = (SELECT MAX(ID) FROM #CustStakeLevelDownlines);
			
	IF	@Threshold >= @MaxRow
		SET	@Threshold = @MaxRow;
			
	SET @StopRow = @Threshold;
			
	IF EXISTS(SELECT TOP(1) 1 FROM #CustStakeLevelDownlines)
	BEGIN
		WHILE (0 = 0)
		BEGIN		
			SET	@StakeLevel =	(
											SELECT	custid				AS CustID
												,	RoleID				AS RoleID
												,	SportType			AS SportType	
												,	BetType				AS BetType		
												,	StakeLevelList		AS StakeLevelList	
												,	MemberStakeLevel	AS MemberStakeLevel
											FROM	#CustStakeLevelDownlines
											WHERE	ID >= @StartRow 
												AND	ID <= @StopRow
											FOR XML RAW ('StakeLevel'), ROOT ('ROOT') 
										);
					
			-- Correct downlines via ExecRep
			EXECUTE	Acc_Dep_DynamicCustSetting_05
						@StakeLevel	= @StakeLevel
					,	@ActionID	= @ActionID
			IF	@StopRow = @MaxRow 
				BREAK;
					
			SET	@StartRow = @StopRow + 1;
					
			SET	@StopRow = 1 + @StopRow + @Threshold;
					
			IF	@StopRow >= @MaxRow
				SET	@StopRow = @MaxRow;
		END;
	END;
		

			
	------------------ START LOGGING ------------------
	-- Select ProductName
	SELECT	@ProductName = p.ProductName
	FROM	DBPRO.bodb02.dbo.Products AS p WITH(NOLOCK)
	WHERE	p.ProductID = @ProductID;

	-- Log old value	
	IF @SettingLevel = 1			-- Product setting level
	BEGIN
		SET @xml = (
		SELECT	@ProductID							AS '@ProductID'
			,	@ProductName						AS '@ProductName'
			,	@CustID								AS '@CustID'
			,	@UserID								AS '@UserID'		
			,	@IP									AS '@IP'
			,	(
					SELECT	@ProductID				AS '@ProductID'					
						,	slle.StakeLevelList_old	AS '@StakeLevelList'
					FROM	#StakeLevelList_Old AS slle							
					FOR XML PATH('StakeLevel')
				,	TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_StakeLevelUpd')
	,	TYPE
	);
	END;
	ELSE IF @SettingLevel = 2		-- SportType setting level
	BEGIN
		SET @xml = (
		SELECT	@ProductID							AS '@ProductID'
			,	@ProductName						AS '@ProductName'
			,	@CustID								AS '@CustID'
			,	@UserID								AS '@UserID'
			,	@IP									AS '@IP'
			,	(
					SELECT	slle.SportType			AS '@SportType'						
						,	slle.StakeLevelList_old	AS '@StakeLevelList'
					FROM	#StakeLevelList_Old AS slle							
					FOR XML PATH('StakeLevel')
				,	TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_StakeLevelUpd')
	,	TYPE
	);
	END;
	ELSE IF @SettingLevel = 3		-- BetType setting level
	BEGIN
		SET @xml = (
		SELECT	@ProductID							AS '@ProductID'
			,	@ProductName						AS '@ProductName'
			,	@CustID								AS '@CustID'
			,	@UserID								AS '@UserID'			
			,	@IP									AS '@IP'
			,	(
					SELECT	slle.BetType			AS '@BetType'
						,	slle.StakeLevelList_old	AS '@StakeLevelList'
					FROM	#StakeLevelList_Old AS slle							
					FOR XML PATH('StakeLevel')
				,	TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_StakeLevelUpd')
	,	TYPE
	);
	END;
	ELSE IF @SettingLevel = 4		-- SportType BetType setting level
	BEGIN
		SET @xml = (
		SELECT	@ProductID						AS '@ProductID'
			,	@ProductName					AS '@ProductName'
			,	@CustID							AS '@CustID'
			,	@UserID							AS '@UserID'		
			,	@IP								AS '@IP'
			,	(
					SELECT	slle.SportType			AS '@SportType'
						,	slle.BetType			AS '@BetType'
						,	slle.StakeLevelList_old	AS '@StakeLevelList'
					FROM	#StakeLevelList_Old AS slle							
					FOR XML PATH('StakeLevel')
				,	TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_StakeLevelUpd')
	,	TYPE
	);
	END;
	SET @logSpData_Old = REPLACE(CONVERT(VARCHAR(MAX), @xml), '" />', '"/"');

	-- Log new updated value
	IF @SettingLevel = 1			-- Product setting level
	BEGIN
		SET @xml = (
		SELECT	@ProductID							AS '@ProductID'
			,	@ProductName						AS '@ProductName'
			,	@CustID								AS '@CustID'
			,	@UserID								AS '@UserID'			
			,	@IP									AS '@IP'
			,	(
					SELECT	@ProductID				AS '@ProductID'
						,	ts.StakeLevelList		AS '@StakeLevelList'
					FROM	#tmpStake AS ts
					FOR XML PATH('StakeLevel')
				,	TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_StakeLevelUpd')
	,	TYPE
	);
	END;
	ELSE IF @SettingLevel = 2		-- SportType setting level
	BEGIN
		SET @xml = (
		SELECT	@ProductID							AS '@ProductID'
			,	@ProductName						AS '@ProductName'
			,	@CustID								AS '@CustID'
			,	@UserID								AS '@UserID'			
			,	@IP									AS '@IP'
			,	(
					SELECT	ts.SportType			AS '@SportType'					
						,	ts.StakeLevelList		AS '@StakeLevelList'
					FROM	#tmpStake AS ts
					FOR XML PATH('StakeLevel')		
				,	TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_StakeLevelUpd')
	,	TYPE
	);
	END;
	ELSE IF @SettingLevel = 3		-- BetType setting level
	BEGIN
		SET @xml = (
		SELECT	@ProductID							AS '@ProductID'
			,	@ProductName						AS '@ProductName'
			,	@CustID								AS '@CustID'
			,	@UserID								AS '@UserID'			
			,	@IP									AS '@IP'
			,	(
					SELECT	ts.BetType				AS '@BetType'
						,	ts.StakeLevelList		AS '@StakeLevelList'
					FROM	#tmpStake AS ts
					FOR XML PATH('StakeLevel')		
				,	TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_StakeLevelUpd')
	,	TYPE
	);
	END;
	ELSE IF @SettingLevel = 4		-- SportType BetType setting level
	BEGIN
		SET @xml = (
		SELECT	@ProductID						AS '@ProductID'
			,	@ProductName					AS '@ProductName'
			,	@CustID							AS '@CustID'
			,	@UserID							AS '@UserID'		
			,	@IP								AS '@IP'
			,	(
					SELECT	ts.SportType			AS '@SportType'
						,	ts.BetType				AS '@BetType'
						,	ts.StakeLevelList		AS '@StakeLevelList'
					FROM	#tmpStake AS ts
					FOR XML PATH('StakeLevel')		
				,	TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_StakeLevelUpd')
	,	TYPE
	);
	END;
	-------------------------------------------------------------------------------------------------------------------

	SET	@logSpData	= REPLACE(CONVERT(VARCHAR(MAX), @xml), '" />', '"/"');

	SELECT	@endRun	= GETDATE()
		,	@duration = DATEDIFF(MILLISECOND, @startRun, @endRun);

	BEGIN TRY
		EXECUTE	DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP 
					@UserID			= @UserID
				,	@CustID			= @CustID
				,	@ActionID		= 397
				,	@TrackingValue	= @logSpData
				,	@TrackingValue2	= @logSpData_Old
				,	@duration		= @duration;
	END TRY

	BEGIN CATCH
		EXECUTE	bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP 
					@UserID			= @UserID
				,	@CustID			= @CustID
				,	@ActionID		= 397
				,	@TrackingValue	= @logSpData
				,	@TrackingValue2	= @logSpData_Old
				,	@duration		= @duration;
	END CATCH;
END;


GO
