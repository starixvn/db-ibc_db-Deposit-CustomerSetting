/*<info serverAlias="DBCUST-CUSTDB" executers="wsv_nap,bodbDownlineNet,bodbExtAccNet,wsv_lap,svc_tig" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_CustSetting_NewBetLimitFullLineUpd] 
	  @SuperID				INT
	, @BetLimit				VARCHAR(MAX)
	, @AgentID				INT
	, @IsAgentOnly			BIT
	, @ApplyExistedMem		BIT=0	
	, @UserID				INT
	, @IP					VARCHAR(50)		= ''
	, @ErrCode				INT				= 0		OUTPUT	
	, @ErrMsg				NVARCHAR(200)	= ''	OUTPUT
AS
/*
	Created: 20220218@Winfred
	Task: Update Customer's New Bet Limits
	DB: DBCUST/CustDB
	Original:
	Revision:	
		- 20220218@Winfred: Licesee Management-Licensee setting - LG VS3  - Licensee DCS setting for new BetLimit  - Redmine: 168395
		- 20230722@Winfred: NAP LM - Enhance performance when adjusting betlimit for big licensees  [redmine:#195079]
		- 20240705@Johnson: Apply In-house Replication for Customer Setting [redmine:#207025]
	Param's Explanation:
	� @BetLimit:
		<ROOT>
				<BetLimit 
						SportType="1" 
						BetType="1" 
						MinBet="1" 
						MaxBet="30000" 
				/>
		</ROOT>	
	*/

BEGIN
	SET NOCOUNT ON

	DECLARE @startRun	DATETIME
		, @endRun		DATETIME
		, @duration		INT
		, @mrecommend	INT
		, @MsgType		INT			
		
	DECLARE @logSpData		NVARCHAR(MAX)
		, @logSpData_Old	NVARCHAR(MAX)
		, @xml				XML
		
	DECLARE @OldBetLimitTbl TABLE (
		SportType			INT
		, BetType			INT
		, MinBet			MONEY
		, MaxBet			MONEY
		)
	DECLARE @NewBetLimitTbl TABLE (
		SportType			INT
		, BetType			INT
		, MinBet			MONEY
		, MaxBet			MONEY
		)

	DECLARE @ProductID		TINYINT,
			@ProductName	VARCHAR(50),
			@SettingLevel	TINYINT
	
	--Check if XML is null or empty
	IF @BetLimit IS NULL
		OR @BetLimit = ''
		RETURN

	SET @startRun = GETDATE()

	SELECT	@ErrCode	    = 0		
		,	@ErrMsg			= ''

	IF @ApplyExistedMem=1
	BEGIN	
		EXEC Acc_Dep_CustomerSelCheckAllowedDownlines
		 @custid = @AgentID
		,@IsSetting = 1
		,@Language = 'E'
		,@ErrMsg = @ErrMsg OUTPUT
		,@ErrCode= @ErrCode OUTPUT
	END
	
	IF @ErrCode <> 0 
		RETURN 
	
	--Parse XML	
	DECLARE @iDoc INT
	 
	EXEC sp_xml_preparedocument @iDoc OUTPUT
		, @BetLimit

	INSERT @NewBetLimitTbl
	SELECT *
	FROM OPENXML(@iDoc, '/ROOT/BetLimit', 1) WITH (
			SportType		INT
			, BetType		INT
			, MinBet		MONEY
			, MaxBet		MONEY
			)

	EXEC sp_xml_removedocument @iDoc

	CREATE TABLE #tempSMA(
					CustID			INT,
					SportType		INT ,
					BetType			INT ,
					MinBet			MONEY,
					MaxBet			MONEY)

	--get old settings
	INSERT INTO @OldBetLimitTbl
	SELECT bl.SportType
		, bl.BetType
		, bl.MinBet
		, bl.MaxBet
	FROM dbo.Dep_CustBetSetting_Agent bl WITH (NOLOCK)
		INNER JOIN @NewBetLimitTbl tmp	ON tmp.SportType = bl.sporttype	AND tmp.BetType = bl.bettype
	WHERE bl.custid = @AgentID

	--Validate new bet settings
	EXEC [dbo].[Acc_Dep_CustSetting_NewBetLimitCheck] @CustID	= @SuperID
						, @RoleID		= 4
						, @AgentID		= 0
						, @MasterID		= 0
						, @SuperID		= @SuperID
						, @BetLimit		= @BetLimit
						, @ErrCode		= @ErrCode	OUTPUT
						, @MsgType		= @MsgType	OUTPUT
						, @ErrMsg		= @ErrMsg	OUTPUT

	IF @ErrCode <> 0
		RETURN
	
	-- Select ProductID and SettingLevel
	SELECT @ProductID = ProductID, @SettingLevel = SettingLevel
	FROM (	SELECT TOP 1 ps.ProductID, ps.SettingLevel
			FROM Dep_ProductSettingDetail AS psd WITH(NOLOCK)
				INNER JOIN	@NewBetLimitTbl AS tmp ON	psd.SportType = tmp.SportType AND	psd.BetType = tmp.BetType
				INNER JOIN Dep_ProductSetting AS ps WITH (NOLOCK) ON ps.ProductSettingID = psd.ProductSettingID
			WHERE	ps.ProductID IS NOT NULL
				AND	ps.SettingLevel IS NOT NULL
				AND ps.SettingType = 11	-- New Bet Limit
		 ) iq

	IF NOT EXISTS (SELECT 1 FROM Dep_ProductSetting ps WITH(NOLOCK) 
								INNER JOIN Dep_LicenseeProductSetting d WITH(NOLOCK) ON ps.ProductSettingID=d.ProductSettingID 
							WHERE ProductID=@ProductID AND SettingType = 11 AND CustID=@SuperID)
		SELECT @IsAgentOnly=0

	IF(@IsAgentOnly=0)
	BEGIN		
		SELECT @mrecommend=mrecommend FROM Customer WITH(NOLOCK) WHERE custid=@AgentID
		
		INSERT INTO #tempSMA(CustID,SportType,BetType,MinBet,MaxBet)
		SELECT @SuperID,s.SportType,s.BetType,s.MinBet,s.MaxBet
		FROM @NewBetLimitTbl s
		UNION ALL
		SELECT @mrecommend,s.SportType,s.BetType,s.MinBet,s.MaxBet
		FROM @NewBetLimitTbl s

	END
		INSERT INTO #tempSMA(CustID,SportType,BetType,MinBet,MaxBet)
		SELECT @AgentID,s.SportType,s.BetType,s.MinBet,s.MaxBet
		FROM @NewBetLimitTbl s

		UPDATE main
		SET main.minbet			= tmp.MinBet
			, main.maxbet		= tmp.MaxBet
			, main.RepUpdateTime = SYSDATETIME()
		FROM dbo.Dep_CustBetSetting_Agent main WITH(ROWLOCK)
			INNER JOIN #tempSMA tmp	ON main.CustID=tmp.CustID AND tmp.SportType = main.sporttype AND tmp.BetType = main.bettype
		WHERE (
					main.minbet		<> tmp.MinBet
				OR main.maxbet		<> tmp.MaxBet
				)

		 DELETE t 
		 FROM #tempSMA t 
		 INNER JOIN Dep_CustBetSetting_Agent cs WITH(NOLOCK) ON t.custid = cs.custid AND cs.sporttype = t.Sporttype AND cs.bettype = t.Bettype

		 INSERT INTO dbo.Dep_CustBetSetting_Agent(CustID,SportType,BetType,MinBet,MaxBet,RepUpdateTime)
		 SELECT CustID,SportType,BetType,MinBet,MaxBet,SYSDATETIME()
		 FROM #tempSMA t

	
	IF @ApplyExistedMem=1
	BEGIN
		EXEC Acc_Dep_CustSetting_BetLimitDownlineUpd				
				@CustID=@AgentID,
				@BetLimit=@BetLimit,
				@settingType = 11
	END

	IF NOT EXISTS (SELECT 1 FROM Dep_ProductSetting ps WITH(NOLOCK) 
									INNER JOIN Dep_LicenseeProductSetting d WITH(NOLOCK) ON ps.ProductSettingID=d.ProductSettingID WHERE ProductID=@ProductID AND SettingType = 11 AND CustID=@SuperID)
		BEGIN
			INSERT INTO Dep_LicenseeProductSetting(CustID,ProductSettingID,RepUpdateTime)
			SELECT @SuperID,ProductSettingID,SYSDATETIME()
			FROM Dep_ProductSetting WITH(NOLOCK)
			WHERE ProductID=@ProductID AND SettingType = 11
		END			

	SELECT @ErrMsg='Update Bet Setting successfully'
	--START LOGGING

	-- Select ProductName
	SELECT @ProductName = p.ProductName
	FROM DBPRO.bodb02.dbo.Products AS p WITH(NOLOCK)
		WHERE p.ProductID = @ProductID

	-- Log old data
		IF @SettingLevel = 1			-- Product setting level
		BEGIN
			SET @xml = (
			SELECT	@ProductID						AS '@ProductID',
					@ProductName					AS '@ProductName',
					@SuperID						AS '@SuperID',
					@UserID							AS '@UserID',				
					@IP								AS '@IP',
					NULL							AS '@IsAgentOnly',
					NULL							AS '@ApplyExistedMem',
					@AgentID						AS '@AgentID',
					(
						SELECT	@ProductID							AS '@ProductID',
								CONVERT(DECIMAL(20,2), MinBet)		AS '@MinBet',
								CONVERT(DECIMAL(20,2), MaxBet)		AS '@MaxBet'
						FROM @OldBetLimitTbl
						FOR XML PATH('BetLimit'),
						TYPE
					)
			FOR XML PATH('Acc_Dep_CustSetting_NewBetLimitFullLineUpd'),
			TYPE
		)
		END
		ELSE IF @SettingLevel = 2		-- SportType setting level
		BEGIN
			SET @xml = (
			SELECT	@ProductID						AS '@ProductID',
					@ProductName					AS '@ProductName',
					@SuperID						AS '@SuperID',
					@UserID							AS '@UserID',				
					@IP								AS '@IP',
					NULL							AS '@IsAgentOnly',
					NULL							AS '@ApplyExistedMem',
					@AgentID						AS '@AgentID',
					(
						SELECT	SportType							AS '@SportType',
								CONVERT(DECIMAL(20,2), MinBet)		AS '@MinBet',
								CONVERT(DECIMAL(20,2), MaxBet)		AS '@MaxBet'
						FROM @OldBetLimitTbl
						FOR XML PATH('BetLimit'),
						TYPE
					)
			FOR XML PATH('Acc_Dep_CustSetting_NewBetLimitFullLineUpd'),
			TYPE
		)
		END
		ELSE IF @SettingLevel = 3		-- BetType setting level
		BEGIN
			SET @xml = (
			SELECT	@ProductID						AS '@ProductID',
					@ProductName					AS '@ProductName',
					@SuperID						AS '@SuperID',
					@UserID							AS '@UserID',			
					@IP								AS '@IP',
					NULL							AS '@IsAgentOnly',
					NULL							AS '@ApplyExistedMem',
					@AgentID						AS '@AgentID',
					(
						SELECT	BetType								AS '@BetType',
								CONVERT(DECIMAL(20,2), MinBet)		AS '@MinBet',
								CONVERT(DECIMAL(20,2), MaxBet)		AS '@MaxBet'
						FROM @OldBetLimitTbl
						FOR XML PATH('BetLimit'),
						TYPE
					)
			FOR XML PATH('Acc_Dep_CustSetting_NewBetLimitFullLineUpd'),
			TYPE
		)
		END
		ELSE IF @SettingLevel = 4		-- SportType BetType setting level
		BEGIN
			SET @xml = (
			SELECT	@ProductID						AS '@ProductID',
					@ProductName					AS '@ProductName',
					@SuperID						AS '@SuperID',
					@UserID							AS '@UserID',				
					@IP								AS '@IP',
					NULL							AS '@IsAgentOnly',
					NULL							AS '@ApplyExistedMem',
					@AgentID						AS '@AgentID',
					(
						SELECT	SportType							AS '@SportType',
								BetType								AS '@BetType',
								CONVERT(DECIMAL(20,2), MinBet)		AS '@MinBet',
								CONVERT(DECIMAL(20,2), MaxBet)		AS '@MaxBet'
						FROM @OldBetLimitTbl
						FOR XML PATH('BetLimit'),
						TYPE
					)
			FOR XML PATH('Acc_Dep_CustSetting_NewBetLimitFullLineUpd'),
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
					@SuperID						AS '@SuperID',
					@UserID							AS '@UserID',				
					@IP								AS '@IP',
					@IsAgentOnly					AS '@IsAgentOnly',
					@ApplyExistedMem				AS '@ApplyExistedMem',
					@AgentID						AS '@AgentID',
					(
						SELECT	@ProductID							AS '@ProductID',
								CONVERT(DECIMAL(20,2), MinBet)		AS '@MinBet',
								CONVERT(DECIMAL(20,2), MaxBet)		AS '@MaxBet'
						FROM @NewBetLimitTbl
						FOR XML PATH('BetLimit'),
						TYPE
					)
			FOR XML PATH('Acc_Dep_CustSetting_NewBetLimitFullLineUpd'),
			TYPE
		)
		END
		ELSE IF @SettingLevel = 2		-- SportType setting level
		BEGIN
			SET @xml = (
			SELECT	@ProductID						AS '@ProductID',
					@ProductName					AS '@ProductName',
					@SuperID						AS '@SuperID',
					@UserID							AS '@UserID',			
					@IP								AS '@IP',
					@IsAgentOnly					AS '@IsAgentOnly',
					@ApplyExistedMem				AS '@ApplyExistedMem',
					@AgentID						AS '@AgentID',
					(
						SELECT	SportType							AS '@SportType',
								CONVERT(DECIMAL(20,2), MinBet)		AS '@MinBet',
								CONVERT(DECIMAL(20,2), MaxBet)		AS '@MaxBet'
						FROM @NewBetLimitTbl
						FOR XML PATH('BetLimit'),
						TYPE
					)
			FOR XML PATH('Acc_Dep_CustSetting_NewBetLimitFullLineUpd'),
			TYPE
		)
		END
		ELSE IF @SettingLevel = 3		-- BetType setting level
		BEGIN
			SET @xml = (
			SELECT	@ProductID						AS '@ProductID',
					@ProductName					AS '@ProductName',
					@SuperID						AS '@SuperID',
					@UserID							AS '@UserID',				
					@IP								AS '@IP',
					@IsAgentOnly					AS '@IsAgentOnly',
					@ApplyExistedMem				AS '@ApplyExistedMem',
					@AgentID						AS '@AgentID',
					(
						SELECT	BetType								AS '@BetType',
								CONVERT(DECIMAL(20,2), MinBet)		AS '@MinBet',
								CONVERT(DECIMAL(20,2), MaxBet)		AS '@MaxBet'
						FROM @NewBetLimitTbl
						FOR XML PATH('BetLimit'),
						TYPE
					)
			FOR XML PATH('Acc_Dep_CustSetting_NewBetLimitFullLineUpd'),
			TYPE
		)
		END
		ELSE IF @SettingLevel = 4		-- SportType BetType setting level
		BEGIN
			SET @xml = (
			SELECT	@ProductID						AS '@ProductID',
					@ProductName					AS '@ProductName',
					@SuperID						AS '@SuperID',
					@UserID							AS '@UserID',			
					@IP								AS '@IP',
					@IsAgentOnly					AS '@IsAgentOnly',
					@ApplyExistedMem				AS '@ApplyExistedMem',
					@AgentID						AS '@AgentID',
					(
						SELECT	SportType							AS '@SportType',
								BetType								AS '@BetType',
								CONVERT(DECIMAL(20,2), MinBet)		AS '@MinBet',
								CONVERT(DECIMAL(20,2), MaxBet)		AS '@MaxBet'
						FROM @NewBetLimitTbl
						FOR XML PATH('BetLimit'),
						TYPE
					)
			FOR XML PATH('Acc_Dep_CustSetting_NewBetLimitFullLineUpd'),
			TYPE
		)
		END
		SET @logSpData = REPLACE(CONVERT(VARCHAR(MAX), @xml), '" />', '"/"')

		SELECT @endRun = GETDATE()
			, @duration = DATEDIFF(MILLISECOND, @startRun, @endRun)

		BEGIN TRY
			EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP @UserID = @UserID
							, @CustID			= @SuperID
							, @ActionID			= 220030
							, @TrackingValue	= @logSpData
							, @TrackingValue2	= @logSpData_Old
							, @duration			= @duration
		END TRY
		BEGIN CATCH
			EXEC bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP @UserID = @UserID
							, @CustID			= @SuperID
							, @ActionID			= 220030
							, @TrackingValue	= @logSpData
							, @TrackingValue2	= @logSpData_Old
							, @duration			= @duration
		END CATCH
END


GO
