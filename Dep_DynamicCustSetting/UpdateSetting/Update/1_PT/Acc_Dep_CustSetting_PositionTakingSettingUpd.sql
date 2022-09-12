/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet,bodbLicenseeNet,Dot_member" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE dbo.Acc_Dep_CustSetting_PositionTakingSettingUpd 
	  @SuperID		INT
	, @AgentID		INT
	, @IsAgentOnly	BIT
	, @PT			VARCHAR(MAX)
	, @ProductID	INT
	, @UserID		INT
	, @IP			VARCHAR(50)		= ''
	, @ErrCode		INT				= 0		OUTPUT	
	, @ErrMsg		NVARCHAR(200)	= ''	OUTPUT
AS
/*
	Created: 20170927@Winnie
	Task: Check Customer's PT
	Original:
	Revision:		
		- 20171009@Winnie: Update PT of DCS product RedmineID:#82346
		- 20180719@Winnie: Licensee DCS setting - Support insert/edit setting for sub_licensee - Redmine: 88700
		- 20200718@Elodie: Support level sporttype/bettype [RedmineID:#135872]
		- 202202220@Elodie: Apply DCS for SB [RedmineID: #167898] 
		- 20220912@Eden: Licensee DCS - Missing ProductSettingID for SB [RedmineID: #177703] 
	Param's Explanation:
		@PT:
		<ROOT>
				<PT
						SportType="211"
						BetType="2401"
						IsLive = "0" 
						PT="90"
				/>
		</ROOT>
	*/

BEGIN
	SET NOCOUNT ON

	DECLARE @startRun DATETIME, @endRun	DATETIME, @duration INT, @mrecommend	INT
	DECLARE @logSpData NVARCHAR(MAX), @logSpData_Old NVARCHAR(MAX), @xml XML, @iDoc INT
	DECLARE	@ProductName VARCHAR(50), @SettingLevel	TINYINT
	CREATE TABLE #tmpPT (SportType INT,Bettype INT,IsLive BIT, PT SMALLMONEY)
	CREATE TABLE #tmpPT_Old (SportType INT,Bettype INT,IsLive BIT, PT SMALLMONEY)

	SET @startRun = GETDATE()

	SELECT	@ErrCode = 0, @ErrMsg = ''
	
	EXEC Acc_Dep_CustomerSelCheckAllowedDownlines
		 @custid = @AgentID
		,@Language = 'E'
		,@ErrMsg = @ErrMsg OUTPUT
		,@ErrCode= @ErrCode OUTPUT

	IF @ErrCode <> 0 
		RETURN 
			
	SELECT  @SettingLevel=SettingLevel FROM Dep_ProductSetting WITH(NOLOCK) WHERE ProductID=@ProductID AND SettingType=1

	-- Select ProductName
	SELECT @ProductName = p.ProductName
	FROM DBPRO.bodb02.dbo.Products AS p WITH(NOLOCK)
	WHERE p.ProductID = @ProductID

	SELECT @mrecommend=mrecommend FROM Customer WITH(NOLOCK) WHERE custid=@AgentID
	--Parse XML
	EXECUTE	sp_xml_preparedocument @iDoc OUTPUT, @PT

	INSERT INTO #tmpPT (SportType, BetType, Islive, PT)
	SELECT	ox.SportType, ox.BetType, ox.Islive, ox.PT
	FROM OPENXML (@iDoc, '/ROOT/PT', 1) 
	WITH (
		SportType		SMALLINT
	,	BetType			SMALLINT
	,	IsLive			BIT
	,	PT				SMALLMONEY	
	) AS ox;

	EXECUTE sp_xml_removedocument @iDoc;
	
	INSERT INTO	#tmpPT_Old (SportType, BetType, Islive, PT)
	SELECT	cslm.SportType
		,	cslm.BetType
		,	cslm.IsLive
		,	cslm.SuperPT			
	FROM	dbo.Dep_CustPTSetting_Agent AS cslm WITH (NOLOCK)
		INNER JOIN	#tmpPT AS ts ON	ts.SportType=cslm.SportType AND ts.BetType = cslm.BetType AND ts.IsLive = cslm.IsLive
	WHERE	cslm.CustID = @SuperID

	IF NOT EXISTS (SELECT 1 FROM Dep_ProductSetting ps WITH(NOLOCK) 
								INNER JOIN Dep_LicenseeProductSetting d WITH(NOLOCK) ON ps.ProductSettingID=d.ProductSettingID 
							WHERE ProductID=@ProductID AND SettingType = 1 AND CustID=@SuperID)
		SELECT @IsAgentOnly=0

	IF(@IsAgentOnly=0)
	BEGIN
		IF EXISTS (	SELECT 1 
					FROM #tmpPT ft 
						INNER JOIN dbo.Dep_CustPTSetting_Agent bl WITH (NOLOCK) ON ft.SportType = bl.sporttype AND ft.BetType = bl.bettype AND ft.IsLive = bl.IsLive
					WHERE CustID=@SuperID)
			UPDATE a
			 SET
				   SuperPT  = t.PT
				  ,MasterPT = t.PT
				  ,AgentPT  = t.PT
			FROM dbo.Dep_CustPTSetting_Agent a WITH(ROWLOCK,UPDLOCK)
				INNER JOIN #tmpPT t ON a.CustID=@SuperID AND a.SportType=t.SportType AND a.BetType=t.BetType AND t.IsLive = a.IsLive
		 ELSE
			INSERT INTO dbo.Dep_CustPTSetting_Agent(CustID,SportType,BetType,IsLive,SuperPT,MasterPT,AgentPT)
			SELECT @SuperID,SportType,BetType,IsLive,PT,PT,PT
			FROM #tmpPT t

		IF EXISTS (SELECT 1 
					FROM #tmpPT ft 
						INNER JOIN dbo.Dep_CustPTSetting_Agent bl WITH (NOLOCK) ON ft.SportType = bl.sporttype AND ft.BetType = bl.bettype AND ft.IsLive = bl.IsLive
					WHERE CustID=@mrecommend)
			UPDATE a
				SET
					 SuperPT  = 0
					,MasterPT = PT
					,AgentPT  = 0
			FROM dbo.Dep_CustPTSetting_Agent a WITH(ROWLOCK,UPDLOCK)
				INNER JOIN #tmpPT t ON a.CustID=@mrecommend AND a.SportType=t.SportType AND a.BetType=t.BetType AND t.IsLive = a.IsLive
		 ELSE
			INSERT INTO dbo.Dep_CustPTSetting_Agent(CustID,SportType,BetType,IsLive,SuperPT,MasterPT,AgentPT)
			SELECT @mrecommend,SportType,BetType,IsLive,0,PT,0
			FROM #tmpPT t

		IF NOT EXISTS (SELECT 1 FROM Dep_ProductSetting ps WITH(NOLOCK) 
									INNER JOIN Dep_LicenseeProductSetting d WITH(NOLOCK) ON ps.ProductSettingID=d.ProductSettingID 
								WHERE ProductID=@ProductID AND SettingType = 1 AND CustID=@SuperID)
		BEGIN
			INSERT INTO Dep_LicenseeProductSetting(CustID,ProductSettingID)
			SELECT @SuperID,ProductSettingID
			FROM Dep_ProductSetting WITH(NOLOCK)
			WHERE ProductID=@ProductID AND SettingType = 1
		END			

	END

	IF EXISTS (	SELECT  1 
				FROM #tmpPT ft 
					INNER JOIN dbo.Dep_CustPTSetting_Agent bl WITH (NOLOCK) ON ft.SportType = bl.sporttype AND ft.BetType = bl.bettype AND ft.IsLive = bl.IsLive
				WHERE CustID=@AgentID)
		UPDATE a
		SET SuperPT   = 0
			,MasterPT = 0
			,AgentPT  = PT
		FROM dbo.Dep_CustPTSetting_Agent a WITH(ROWLOCK,UPDLOCK)
			INNER JOIN #tmpPT t ON a.CustID=@AgentID AND a.SportType=t.SportType AND a.BetType=t.BetType AND t.IsLive = a.IsLive
	ELSE
		INSERT INTO dbo.Dep_CustPTSetting_Agent(CustID,SportType,BetType,IsLive,SuperPT,MasterPT,AgentPT)
		SELECT @AgentID,SportType,BetType,IsLive,0,0,PT
		FROM #tmpPT t
	
	EXEC Acc_Dep_DynamicCustSetting_01	
		@CustID=@AgentID,
		@PT=@PT,					
		@ProductID=@ProductID	

	SELECT @ErrMsg='Update Position Taking successfully'
	
	--START LOGGING
	-- Log old data
	IF @SettingLevel = 1			-- Product setting level
	BEGIN
		SET @xml = (
		SELECT	@ProductID						AS '@ProductID',
				@ProductName					AS '@ProductName',
				@AgentID						AS '@AgentID',
				NULL							AS '@IsAgentOnly',
				@SuperID						AS '@SuperID',
				@UserID							AS '@UserID',				
				@IP								AS '@IP',
				(
					SELECT	@ProductID			AS '@ProductID',
							cs.PT				AS '@PositionTaking'	
					FROM	#tmpPT_Old AS cs	
					FOR XML PATH('PT'),
					TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_PositionTakingSettingUpd'),
		TYPE
	)
	END
	ELSE IF @SettingLevel = 2		-- SportType setting level
	BEGIN
		SET @xml = (
		SELECT	@ProductID						AS '@ProductID',
				@ProductName					AS '@ProductName',
				@AgentID						AS '@AgentID',
				NULL							AS '@IsAgentOnly',
				@SuperID						AS '@SuperID',
				@UserID							AS '@UserID',				
				@IP								AS '@IP',
				(
					SELECT	SportType			AS '@SportType',
							cs.PT				AS '@PositionTaking'	
					FROM	#tmpPT_Old AS cs
					FOR XML PATH('PT'),
					TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_PositionTakingSettingUpd'),
		TYPE
	)
	END
	ELSE IF @SettingLevel = 3		-- BetType setting level
	BEGIN
		SET @xml = (
		SELECT	@ProductID						AS '@ProductID',
				@ProductName					AS '@ProductName',
				@AgentID						AS '@AgentID',
				NULL							AS '@IsAgentOnly',
				@SuperID						AS '@SuperID',
				@UserID							AS '@UserID',				
				@IP								AS '@IP',
				(
					SELECT	BetType				AS '@BetType',
							cs.PT				AS '@PositionTaking'	
					FROM	#tmpPT_Old AS cs
					FOR XML PATH('PT'),
					TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_PositionTakingSettingUpd'),
		TYPE
	)
	END
	ELSE IF @SettingLevel = 4		-- SportType BetType setting level
	BEGIN
		SET @xml = (
		SELECT	@ProductID						AS '@ProductID',
				@ProductName					AS '@ProductName',
				@AgentID						AS '@AgentID',
				NULL							AS '@IsAgentOnly',
				@SuperID						AS '@SuperID',
				@UserID							AS '@UserID',				
				@IP								AS '@IP',
				(
					SELECT	SportType			AS '@SportType',
							BetType				AS '@BetType',
							cs.PT				AS '@PositionTaking'	
					FROM	#tmpPT_Old AS cs
					FOR XML PATH('PT'),
					TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_PositionTakingSettingUpd'),
		TYPE
	)
	END
	SET @logSpData_Old = REPLACE(CONVERT(VARCHAR(MAX), @xml), '" />', '"/"')

	-- Log new updated data
	IF @SettingLevel = 1			-- Product setting level
	BEGIN
		SET @xml = (
		SELECT	@ProductID						AS '@ProductID',
				@ProductName					AS '@ProductName',
				@AgentID						AS '@AgentID',
				@IsAgentOnly					AS '@IsAgentOnly',
				@SuperID						AS '@SuperID',
				@UserID							AS '@UserID',				
				@IP								AS '@IP',
				(
					SELECT	@ProductID			AS '@ProductID',
							cs.PT				AS '@PositionTaking'	
					FROM	#tmpPT AS cs			
					FOR XML PATH('PT'),
					TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_PositionTakingSettingUpd'),
		TYPE
	)
	END
	ELSE IF @SettingLevel = 2		-- SportType setting level
	BEGIN
		SET @xml = (
		SELECT	@ProductID						AS '@ProductID',
				@ProductName					AS '@ProductName',
				@AgentID						AS '@AgentID',
				@IsAgentOnly					AS '@IsAgentOnly',
				@SuperID						AS '@SuperID',
				@UserID							AS '@UserID',				
				@IP								AS '@IP',
				(
					SELECT	SportType			AS '@SportType',
							cs.PT				AS '@PositionTaking'	
					FROM	#tmpPT AS cs	
					FOR XML PATH('PT'),
					TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_PositionTakingSettingUpd'),
		TYPE
	)
	END
	ELSE IF @SettingLevel = 3		-- BetType setting level
	BEGIN
		SET @xml = (
		SELECT	@ProductID						AS '@ProductID',
				@ProductName					AS '@ProductName',
				@AgentID						AS '@AgentID',
				@IsAgentOnly					AS '@IsAgentOnly',
				@SuperID						AS '@SuperID',
				@UserID							AS '@UserID',				
				@IP								AS '@IP',
				(
					SELECT	BetType				AS '@BetType',
							cs.PT				AS '@PositionTaking'	
					FROM	#tmpPT AS cs	
					FOR XML PATH('PT'),
					TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_PositionTakingSettingUpd'),
		TYPE
	)
	END
	ELSE IF @SettingLevel = 4		-- SportType BetType setting level
	BEGIN
		SET @xml = (
		SELECT	@ProductID						AS '@ProductID',
				@ProductName					AS '@ProductName',
				@AgentID						AS '@AgentID',
				@IsAgentOnly					AS '@IsAgentOnly',
				@SuperID						AS '@SuperID',
				@UserID							AS '@UserID',			
				@IP								AS '@IP',
				(
					SELECT	SportType			AS '@SportType',
							BetType				AS '@BetType',
							cs.PT				AS '@PositionTaking'	
					FROM	#tmpPT AS cs	
					FOR XML PATH('PT'),
					TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_PositionTakingSettingUpd'),
		TYPE
	)
	END
	SET @logSpData = REPLACE(CONVERT(VARCHAR(MAX), @xml), '" />', '"/"')

	SELECT @endRun = GETDATE()
		, @duration = DATEDIFF(MILLISECOND, @startRun, @endRun)

	EXEC dbo.Acc_WriteLog_UserLog_RunSP_Wrapper 
		@UserID = @UserID
		, @CustID			= @AgentID
		, @ActionID			= 469
		, @TrackingValue	= @logSpData
		, @TrackingValue2	= @logSpData_Old
		, @duration			= @duration
END
GO
