/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet,bodbDownlineNet,bodbExtAccNet,bodbLicenseeNet" viewers="vnteam" isFunction="0"></info>*/
CREATE PROCEDURE dbo.Acc_Dep_CustSetting_StakeLevelUpd 
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

	CREATE TABLE	#tmpStake (					
						SportType		SMALLINT
					,	BetType			INT
					,	StakeLevelList	VARCHAR(200)
					,	PRIMARY KEY CLUSTERED (SportType, BetType)
					);

	CREATE TABLE	#StakeLevelList_Old (
						SportType			SMALLINT
					,	BetType				INT				
					,	StakeLevelList_old	VARCHAR(200)	
					,	PRIMARY KEY CLUSTERED (SportType, BetType)				
					);

	--Check if XML is null or empty
	IF	@StakeLevel IS NULL OR @StakeLevel = ''
		RETURN;

	SELECT	@ErrCode	= 0
		,	@MsgType	= 0
		,	@ErrMsg			= '';

	SET	@startRun = GETDATE();

	--Get line information

	EXEC DBEXT.dbo.NAP_LM_CustomerSelCheckAllowedDownlines
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
	,	BetType			INT
	,	StakeLevelList	VARCHAR(200)	
	) AS ox;

	EXECUTE sp_xml_removedocument @iDoc;

	INSERT INTO	#StakeLevelList_Old (SportType, BetType, StakeLevelList_old)
	SELECT	cslm.SportType
		,	cslm.BetType
		,	cslm.StakeLevelList			
	FROM	dbo.Dep_CustStakeLevel_Agent AS cslm WITH (NOLOCK)
		INNER JOIN	#tmpStake AS ts
			ON	ts.SportType=cslm.SportType
			AND ts.BetType = cslm.BetType
	WHERE	cslm.CustID = @CustID;

	EXEC	Acc_Dep_DynamicCustSetting_05
			@CustID		= @CustID
		,	@StakeLevel	= @StakeLevel

	------------------ START LOGGING ------------------
	-- Select ProductName
	SELECT	@ProductName = p.ProductName
	FROM	DBPRO.bodb02.dbo.Products AS p WITH(NOLOCK)
	WHERE	p.ProductID = @ProductID;

	-- Log old value

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
	
	SET @logSpData_Old = REPLACE(CONVERT(VARCHAR(MAX), @xml), '" />', '"/"');

	-- Log new updated value

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
