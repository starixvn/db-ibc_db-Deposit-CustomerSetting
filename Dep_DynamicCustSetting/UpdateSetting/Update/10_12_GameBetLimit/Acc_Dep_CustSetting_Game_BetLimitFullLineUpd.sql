/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet,bodbDownlineNet,bodbExtAccNet,bodbLicenseeNet,Dot_member" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_CustSetting_Game_BetLimitFullLineUpd] 
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
	Created: 20220301@Eden
	Task: Update Customer's Bet Limits -Licensee DCS Setting
	DB: DBCUST/CustDB
	Original:

	Revision:
		- 20220301@Eden: Deposit - Sportsbook - Revise customer settings [Redmine: #167898] 
		- 20230722@Winfred: NAP LM - Enhance performance when adjusting betlimit for big licensees  [redmine:#195079]
		
	Param's Explanation:

	@BetLimit	= '<ROOT>
				<BetLimit SportType="1" BetType="1" MinBet="10" MaxBet="100" MaxPerMatch="1000" MaxPayoutPerMatch="10000" />
		</ROOT>'
	
	@BetLimit	= '<ROOT>
			<BetLimit SportType="161" BetType="81" MinBet="10" MaxBet="100" MaxPerMatch="1000" MaxPerNumber="500"/>
	</ROOT>'
		
*/

BEGIN
	SET NOCOUNT ON

	DECLARE @startRun	DATETIME
		, @endRun		DATETIME
		, @duration		INT
		, @mrecommend	INT
		
	DECLARE @logSpData		NVARCHAR(MAX)
		, @logSpData_Old	NVARCHAR(MAX)
		, @xml				XML
		
	DECLARE @OldBetLimitTbl TABLE (
		SportType			INT
		, BetType			INT
		, MinBet			MONEY
		, MaxBet			MONEY
		, MaxPerMatch		MONEY
		, MaxPerNumber		MONEY
		, MaxPayoutPerMatch	MONEY
		)
	DECLARE @NewBetLimitTbl TABLE (
		SportType			INT
		, BetType			INT
		, MinBet			MONEY
		, MaxBet			MONEY
		, MaxPerMatch		MONEY
		, MaxPerNumber		MONEY
		, MaxPayoutPerMatch	MONEY
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

	INSERT @NewBetLimitTbl(SportType,BetType,MinBet,MaxBet,MaxPerMatch,MaxPerNumber,MaxPayoutPerMatch)
	SELECT SportType,BetType,MinBet,MaxBet,MaxPerMatch,MaxPerNumber,MaxPayoutPerMatch
	FROM OPENXML(@iDoc, '/ROOT/BetLimit', 1) WITH (
			SportType		INT
			, BetType		INT
			, MinBet		MONEY
			, MaxBet		MONEY
			, MaxPerMatch	MONEY
			, MaxPerNumber		MONEY
			, MaxPayoutPerMatch	MONEY
			)

	EXEC sp_xml_removedocument @iDoc

	CREATE TABLE #tempSMA(
					CustID			INT,
					SportType		INT ,
					BetType			INT ,
					MinBet			MONEY,
					MaxBet			MONEY,
					MaxPerMatch		MONEY,
					MaxPerNumber		MONEY,
					MaxPayoutPerMatch	MONEY
					)

				--get old settings
	INSERT INTO @OldBetLimitTbl(SportType,BetType,MinBet,MaxBet,MaxPerMatch,MaxPerNumber,MaxPayoutPerMatch)
	SELECT bl.SportType
		, bl.BetType
		, bl.MinBet
		, bl.MaxBet
		, bl.MaxPerMatch
		, bl.MaxPerNumber
		, bl.MaxPayoutPerMatch
	FROM dbo.Dep_CustBetSettingGame_Agent bl WITH (NOLOCK)
		INNER JOIN @NewBetLimitTbl tmp	ON tmp.SportType = bl.sporttype	AND tmp.BetType = bl.bettype
		WHERE bl.custid = @AgentID

	-- Select ProductID and SettingLevel
	SELECT @ProductID = ProductID, @SettingLevel = SettingLevel
	FROM (	SELECT TOP 1 ps.ProductID, ps.SettingLevel
			FROM Dep_ProductSettingDetail AS psd WITH(NOLOCK)
				INNER JOIN	@NewBetLimitTbl AS tmp ON	psd.SportType = tmp.SportType AND	psd.BetType = tmp.BetType
				INNER JOIN Dep_ProductSetting AS ps WITH (NOLOCK) ON ps.ProductSettingID = psd.ProductSettingID
			WHERE	ps.ProductID IS NOT NULL
				AND	ps.SettingLevel IS NOT NULL
				AND ps.SettingType IN(10,12)	-- Bet Limit
		 ) iq

	IF NOT EXISTS (SELECT 1 FROM Dep_ProductSetting ps WITH(NOLOCK) 
								INNER JOIN Dep_LicenseeProductSetting d WITH(NOLOCK) ON ps.ProductSettingID=d.ProductSettingID 
							WHERE ProductID=@ProductID AND SettingType IN(10,12) AND CustID=@SuperID)
		SELECT @IsAgentOnly=0

	IF(@IsAgentOnly=0)
	BEGIN		
		SELECT @mrecommend=mrecommend FROM Customer WITH(NOLOCK) WHERE custid=@AgentID
					
		INSERT INTO #tempSMA(CustID,SportType,BetType,MinBet,MaxBet,MaxPerMatch,MaxPerNumber,MaxPayoutPerMatch)
		SELECT @SuperID,s.SportType,s.BetType,s.MinBet,s.MaxBet,s.MaxPerMatch,s.MaxPerNumber,s.MaxPayoutPerMatch
		FROM @NewBetLimitTbl s
		UNION ALL
		SELECT @mrecommend,s.SportType,s.BetType,s.MinBet,s.MaxBet,s.MaxPerMatch,s.MaxPerNumber,s.MaxPayoutPerMatch
		FROM @NewBetLimitTbl s

	END

	INSERT INTO #tempSMA(CustID,SportType,BetType,MinBet,MaxBet,MaxPerMatch,MaxPerNumber,MaxPayoutPerMatch)
	SELECT @AgentID,s.SportType,s.BetType,s.MinBet,s.MaxBet,s.MaxPerMatch,s.MaxPerNumber,s.MaxPayoutPerMatch
	FROM @NewBetLimitTbl s

	UPDATE main
	SET main.minbet			= tmp.MinBet
		, main.maxbet		= tmp.MaxBet
		, main.maxpermatch	= tmp.MaxperMatch
		, main.MaxPerNumber		= tmp.MaxPerNumber
		, main.MaxPayoutPerMatch	= tmp.MaxPayoutPerMatch
	FROM dbo.Dep_CustBetSettingGame_Agent main WITH(ROWLOCK)
		INNER JOIN #tempSMA tmp	ON main.CustID=tmp.CustID AND tmp.SportType = main.sporttype AND tmp.BetType = main.bettype
	WHERE (
				main.minbet		<> tmp.MinBet
			OR main.maxbet		<> tmp.MaxBet
			OR main.maxpermatch <> tmp.MaxperMatch
			OR main.MaxPerNumber <> tmp.MaxPerNumber
			OR main.MaxPayoutPerMatch <> tmp.MaxPayoutPerMatch
			)

	DELETE t 
	FROM #tempSMA t 
	INNER JOIN Dep_CustBetSettingGame_Agent cs WITH(NOLOCK) ON t.custid = cs.custid AND cs.sporttype = t.Sporttype AND cs.bettype = t.Bettype

	INSERT INTO dbo.Dep_CustBetSettingGame_Agent(CustID,SportType,BetType,MinBet,MaxBet,MaxPerMatch,MaxPerNumber,MaxPayoutPerMatch)
	SELECT CustID,SportType,BetType,MinBet,MaxBet,MaxPerMatch,MaxPerNumber,MaxPayoutPerMatch
	FROM #tempSMA t

	INSERT INTO Dep_CustBetSettingGameGroup_Member(AgentID,SportType,BetType,MinBet,MaxBet,MaxPerMatch,MaxPerNumber,MaxPayoutPerMatch)
	SELECT @AgentID,t.SportType,t.BetType,t.MinBet,t.MaxBet,t.MaxPerMatch,t.MaxPerNumber,t.MaxPayoutPerMatch
	FROM @NewBetLimitTbl t
		LEFT JOIN Dep_CustBetSettingGameGroup_Member m WITH(NOLOCK) ON  m.AgentID = @AgentID AND t.SportType= m.SportType AND t.BetType = m.BetType
	WHERE m.AgentID IS NULL
	
	IF @ApplyExistedMem=1
	BEGIN
		UPDATE main
		SET main.minbet			= tmp.MinBet
			, main.maxbet		= tmp.MaxBet
			, main.maxpermatch	= tmp.MaxperMatch
			, main.MaxPerNumber		= tmp.MaxPerNumber
			, main.MaxPayoutPerMatch	= tmp.MaxPayoutPerMatch
		FROM dbo.Dep_CustBetSettingGameGroup_Member main WITH(ROWLOCK)
			INNER JOIN @NewBetLimitTbl tmp	ON tmp.SportType = main.sporttype AND tmp.BetType = main.bettype
		WHERE (
					main.minbet		<> tmp.MinBet
				OR main.maxbet		<> tmp.MaxBet
				OR main.maxpermatch <> tmp.MaxperMatch
				OR main.MaxPerNumber <> tmp.MaxPerNumber
				OR main.MaxPayoutPerMatch <> tmp.MaxPayoutPerMatch
				)
				AND main.AgentID = @AgentID

		EXEC Acc_Dep_DynamicCustSetting_02				
				@CustID=@AgentID,
				@BetLimit=@BetLimit,
				@Mode = 'GameBetLimit'

	END

	IF NOT EXISTS (SELECT 1 FROM Dep_ProductSetting ps WITH(NOLOCK) 
									INNER JOIN Dep_LicenseeProductSetting d WITH(NOLOCK) ON ps.ProductSettingID=d.ProductSettingID WHERE ProductID=@ProductID AND SettingType IN(10,12) AND CustID=@SuperID)
		BEGIN
			INSERT INTO Dep_LicenseeProductSetting(CustID,ProductSettingID)
			SELECT @SuperID,ProductSettingID
			FROM Dep_ProductSetting WITH(NOLOCK)
			WHERE ProductID=@ProductID AND SettingType IN (10,12)
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
								CONVERT(DECIMAL(20,2), MaxBet)		AS '@MaxBet',
								CONVERT(DECIMAL(20,2), MaxPerMatch)	AS '@MaxPerMatch',
								CONVERT(DECIMAL(20,2), MaxPerNumber)AS '@MaxPerNumber',
								CONVERT(DECIMAL(20,2), MaxPayoutPerMatch)	AS '@MaxPayoutPerMatch'
						FROM @OldBetLimitTbl
						FOR XML PATH('BetLimit'),
						TYPE
					)
			FOR XML PATH('Acc_Dep_CustSetting_Game_BetLimitFullLineUpd'),
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
								CONVERT(DECIMAL(20,2), MaxBet)		AS '@MaxBet',
								CONVERT(DECIMAL(20,2), MaxPerMatch)	AS '@MaxPerMatch',
								CONVERT(DECIMAL(20,2), MaxPerNumber)AS '@MaxPerNumber',
								CONVERT(DECIMAL(20,2), MaxPayoutPerMatch)	AS '@MaxPayoutPerMatch'
						FROM @OldBetLimitTbl
						FOR XML PATH('BetLimit'),
						TYPE
					)
			FOR XML PATH('Acc_Dep_CustSetting_Game_BetLimitFullLineUpd'),
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
								CONVERT(DECIMAL(20,2), MaxBet)		AS '@MaxBet',
								CONVERT(DECIMAL(20,2), MaxPerMatch)	AS '@MaxPerMatch',
								CONVERT(DECIMAL(20,2), MaxPerNumber)AS '@MaxPerNumber',
								CONVERT(DECIMAL(20,2), MaxPayoutPerMatch)	AS '@MaxPayoutPerMatch'
						FROM @OldBetLimitTbl
						FOR XML PATH('BetLimit'),
						TYPE
					)
			FOR XML PATH('Acc_Dep_CustSetting_Game_BetLimitFullLineUpd'),
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
								CONVERT(DECIMAL(20,2), MaxBet)		AS '@MaxBet',
								CONVERT(DECIMAL(20,2), MaxPerMatch)	AS '@MaxPerMatch',
								CONVERT(DECIMAL(20,2), MaxPerNumber)AS '@MaxPerNumber',
								CONVERT(DECIMAL(20,2), MaxPayoutPerMatch)	AS '@MaxPayoutPerMatch'
						FROM @OldBetLimitTbl
						FOR XML PATH('BetLimit'),
						TYPE
					)
			FOR XML PATH('Acc_Dep_CustSetting_Game_BetLimitFullLineUpd'),
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
								CONVERT(DECIMAL(20,2), MaxBet)		AS '@MaxBet',
								CONVERT(DECIMAL(20,2), MaxPerMatch)	AS '@MaxPerMatch',
								CONVERT(DECIMAL(20,2), MaxPerNumber)AS '@MaxPerNumber',
								CONVERT(DECIMAL(20,2), MaxPayoutPerMatch)	AS '@MaxPayoutPerMatch'
						FROM @NewBetLimitTbl
						FOR XML PATH('BetLimit'),
						TYPE
					)
			FOR XML PATH('Acc_Dep_CustSetting_Game_BetLimitFullLineUpd'),
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
								CONVERT(DECIMAL(20,2), MaxBet)		AS '@MaxBet',
								CONVERT(DECIMAL(20,2), MaxPerMatch)	AS '@MaxPerMatch',
								CONVERT(DECIMAL(20,2), MaxPerNumber)AS '@MaxPerNumber',
								CONVERT(DECIMAL(20,2), MaxPayoutPerMatch)	AS '@MaxPayoutPerMatch'
						FROM @NewBetLimitTbl
						FOR XML PATH('BetLimit'),
						TYPE
					)
			FOR XML PATH('Acc_Dep_CustSetting_Game_BetLimitFullLineUpd'),
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
								CONVERT(DECIMAL(20,2), MaxBet)		AS '@MaxBet',
								CONVERT(DECIMAL(20,2), MaxPerMatch)	AS '@MaxPerMatch',
								CONVERT(DECIMAL(20,2), MaxPerNumber)AS '@MaxPerNumber',
								CONVERT(DECIMAL(20,2), MaxPayoutPerMatch)	AS '@MaxPayoutPerMatch'
						FROM @NewBetLimitTbl
						FOR XML PATH('BetLimit'),
						TYPE
					)
			FOR XML PATH('Acc_Dep_CustSetting_Game_BetLimitFullLineUpd'),
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
								CONVERT(DECIMAL(20,2), MaxBet)		AS '@MaxBet',
								CONVERT(DECIMAL(20,2), MaxPerMatch)	AS '@MaxPerMatch',
								CONVERT(DECIMAL(20,2), MaxPerNumber)AS '@MaxPerNumber',
								CONVERT(DECIMAL(20,2), MaxPayoutPerMatch)	AS '@MaxPayoutPerMatch'
						FROM @NewBetLimitTbl
						FOR XML PATH('BetLimit'),
						TYPE
					)
			FOR XML PATH('Acc_Dep_CustSetting_Game_BetLimitFullLineUpd'),
			TYPE
		)
		END
		SET @logSpData = REPLACE(CONVERT(VARCHAR(MAX), @xml), '" />', '"/"')

		SELECT @endRun = GETDATE()
			, @duration = DATEDIFF(MILLISECOND, @startRun, @endRun)

		BEGIN TRY
			EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP @UserID = @UserID
							, @CustID			= @SuperID
							, @ActionID			= 398
							, @TrackingValue	= @logSpData
							, @TrackingValue2	= @logSpData_Old
							, @duration			= @duration
		END TRY
		BEGIN CATCH
			EXEC bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP @UserID = @UserID
							, @CustID			= @SuperID
							, @ActionID			= 398
							, @TrackingValue	= @logSpData
							, @TrackingValue2	= @logSpData_Old
							, @duration			= @duration
		END CATCH
END


GO
