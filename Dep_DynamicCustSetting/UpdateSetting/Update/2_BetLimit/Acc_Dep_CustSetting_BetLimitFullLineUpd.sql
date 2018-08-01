/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet,bodbDownlineNet,bodbExtAccNet,bodbLicenseeNet" viewers="vnteam" isFunction="0"></info>*/
USE CustDB
GO

ALTER PROCEDURE [dbo].[Acc_Dep_CustSetting_BetLimitFullLineUpd] 
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
	Created: 20170927@Winnie
	Task: Check Customer's Bet Limits
	DB: DBCUST/CustDB
	Original:
	Revision:	
		- 20170928@Winnie: Insert Settings Into DCS Structure - Redmine: 82346
		- 20180719@Winnie: Licensee DCS setting - Support insert/edit setting for sub_licensee - Redmine: 88700
	Param's Explanation:
	� @BetLimit:
		<ROOT>
				<BetLimit 
						SportType="1" 
						BetType="1" 
						MinBet="1" 
						MaxBet="30000" 
						MaxPerMatch="1000000"
				/>
		</ROOT>	
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
		)
	DECLARE @NewBetLimitTbl TABLE (
		SportType			INT
		, BetType			INT
		, MinBet			MONEY
		, MaxBet			MONEY
		, MaxPerMatch		MONEY
		)

	DECLARE @ProductID		TINYINT,
			@ProductName	VARCHAR(50),
			@SettingLevel	TINYINT
	CREATE TABLE #tmpAgent (AgentID INT PRIMARY KEY)

	--Check if XML is null or empty
	IF @BetLimit IS NULL
		OR @BetLimit = ''
		RETURN

	SET @startRun = GETDATE()

	SELECT	@ErrCode	    = 0		
		,	@ErrMsg			= ''
	
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
			, MaxPerMatch	MONEY
			)

	EXEC sp_xml_removedocument @iDoc

	CREATE TABLE #tempSMA(
					CustID			INT,
					SportType		INT ,
					BetType			INT ,
					MinBet			MONEY,
					MaxBet			MONEY,
					MaxPerMatch		MONEY)

				--get old settings
	INSERT INTO @OldBetLimitTbl
	SELECT bl.SportType
		, bl.BetType
		, bl.MinBet
		, bl.MaxBet
		, bl.MaxPerMatch
	FROM dbo.Dep_CustBetSetting_Agent bl WITH (NOLOCK)
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
				AND ps.SettingType = 2	-- Bet Limit
		 ) iq

	IF(@IsAgentOnly=0)
	BEGIN		
		SELECT @mrecommend=mrecommend FROM Customer WITH(NOLOCK) WHERE custid=@AgentID
			
		INSERT INTO #tempSMA(CustID,SportType,BetType,MinBet,MaxBet,MaxPerMatch)
		SELECT @SuperID,s.SportType,s.BetType,s.MinBet,s.MaxBet,s.MaxPerMatch
		FROM @NewBetLimitTbl s
		UNION ALL
		SELECT @mrecommend,s.SportType,s.BetType,s.MinBet,s.MaxBet,s.MaxPerMatch
		FROM @NewBetLimitTbl s
		UNION ALL 
		SELECT @AgentID,s.SportType,s.BetType,s.MinBet,s.MaxBet,s.MaxPerMatch
		FROM @NewBetLimitTbl s		

		UPDATE main
		SET main.minbet			= tmp.MinBet
			, main.maxbet		= tmp.MaxBet
			, main.maxpermatch	= tmp.MaxperMatch
		FROM dbo.Dep_CustBetSetting_Agent main WITH(ROWLOCK,UPDLOCK)
			INNER JOIN #tempSMA tmp	ON main.CustID=tmp.CustID AND tmp.SportType = main.sporttype AND tmp.BetType = main.bettype
		WHERE (
					main.minbet		<> tmp.MinBet
				OR main.maxbet		<> tmp.MaxBet
				OR main.maxpermatch <> tmp.MaxperMatch
				)

		 DELETE t 
		 FROM #tempSMA t 
		 INNER JOIN Dep_CustBetSetting_Agent cs WITH(NOLOCK) ON t.custid = cs.custid AND cs.sporttype = t.Sporttype AND cs.bettype = t.Bettype

		 INSERT INTO dbo.Dep_CustBetSetting_Agent(CustID,SportType,BetType,MinBet,MaxBet,MaxPerMatch)
		 SELECT CustID,SportType,BetType,MinBet,MaxBet,MaxPerMatch
		 FROM #tempSMA t
		 IF NOT EXISTS (SELECT TOP 1 1 FROM Dep_ProductSetting ps WITH(NOLOCK) 
									INNER JOIN Dep_LicenseeProductSetting d WITH(NOLOCK) ON ps.ProductSettingID=d.ProductSettingID WHERE ProductID=@ProductID AND SettingType =2 AND CustID=@SuperID)
		BEGIN
			INSERT INTO Dep_LicenseeProductSetting(CustID,ProductSettingID)
			SELECT @SuperID,ProductSettingID
			FROM Dep_ProductSetting WITH(NOLOCK)
			WHERE ProductID=@ProductID AND SettingType=2
		END					
	END
	ELSE IF (@IsAgentOnly=1)
	BEGIN
	
		INSERT INTO #tempSMA(CustID,SportType,BetType,MinBet,MaxBet,MaxPerMatch)
		SELECT @AgentID,s.SportType,s.BetType,s.MinBet,s.MaxBet,s.MaxPerMatch
		FROM @NewBetLimitTbl s
	
		UPDATE main
		SET main.minbet			= tmp.MinBet
			, main.maxbet		= tmp.MaxBet
			, main.maxpermatch	= tmp.MaxperMatch
		FROM dbo.Dep_CustBetSetting_Agent main WITH(ROWLOCK,UPDLOCK)
			INNER JOIN #tempSMA tmp	ON main.CustID=tmp.CustID AND tmp.SportType = main.sporttype AND tmp.BetType = main.bettype
		WHERE (
					main.minbet		<> tmp.MinBet
				OR main.maxbet		<> tmp.MaxBet
				OR main.maxpermatch <> tmp.MaxperMatch
				)

		 DELETE t 
		 FROM #tempSMA t 
		 INNER JOIN Dep_CustBetSetting_Agent cs WITH(NOLOCK) ON t.custid = cs.custid AND cs.sporttype = t.Sporttype AND cs.bettype = t.Bettype

		 INSERT INTO dbo.Dep_CustBetSetting_Agent(CustID,SportType,BetType,MinBet,MaxBet,MaxPerMatch)
		 SELECT CustID,SportType,BetType,MinBet,MaxBet,MaxPerMatch
		 FROM #tempSMA t
	END
	IF @ApplyExistedMem=1
	BEGIN
		EXEC Acc_Dep_DynamicCustSetting_02
				@ActionID=0,
				@CustID=@AgentID,
				@BetLimit=@BetLimit,
				@ApplyExistedMem=@ApplyExistedMem		
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
								CONVERT(DECIMAL(20,2), MaxPerMatch)	AS '@MaxPerMatch'
						FROM @OldBetLimitTbl
						FOR XML PATH('BetLimit'),
						TYPE
					)
			FOR XML PATH('Acc_Dep_CustSetting_BetLimitFullLineUpd'),
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
								CONVERT(DECIMAL(20,2), MaxPerMatch)	AS '@MaxPerMatch'
						FROM @OldBetLimitTbl
						FOR XML PATH('BetLimit'),
						TYPE
					)
			FOR XML PATH('Acc_Dep_CustSetting_BetLimitFullLineUpd'),
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
								CONVERT(DECIMAL(20,2), MaxPerMatch)	AS '@MaxPerMatch'
						FROM @OldBetLimitTbl
						FOR XML PATH('BetLimit'),
						TYPE
					)
			FOR XML PATH('Acc_Dep_CustSetting_BetLimitFullLineUpd'),
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
								CONVERT(DECIMAL(20,2), MaxPerMatch)	AS '@MaxPerMatch'
						FROM @OldBetLimitTbl
						FOR XML PATH('BetLimit'),
						TYPE
					)
			FOR XML PATH('Acc_Dep_CustSetting_BetLimitFullLineUpd'),
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
								CONVERT(DECIMAL(20,2), MaxPerMatch)	AS '@MaxPerMatch'
						FROM @NewBetLimitTbl
						FOR XML PATH('BetLimit'),
						TYPE
					)
			FOR XML PATH('Acc_Dep_CustSetting_BetLimitFullLineUpd'),
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
								CONVERT(DECIMAL(20,2), MaxPerMatch)	AS '@MaxPerMatch'
						FROM @NewBetLimitTbl
						FOR XML PATH('BetLimit'),
						TYPE
					)
			FOR XML PATH('Acc_Dep_CustSetting_BetLimitFullLineUpd'),
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
								CONVERT(DECIMAL(20,2), MaxPerMatch)	AS '@MaxPerMatch'
						FROM @NewBetLimitTbl
						FOR XML PATH('BetLimit'),
						TYPE
					)
			FOR XML PATH('Acc_Dep_CustSetting_BetLimitFullLineUpd'),
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
								CONVERT(DECIMAL(20,2), MaxPerMatch)	AS '@MaxPerMatch'
						FROM @NewBetLimitTbl
						FOR XML PATH('BetLimit'),
						TYPE
					)
			FOR XML PATH('Acc_Dep_CustSetting_BetLimitFullLineUpd'),
			TYPE
		)
		END
		SET @logSpData = REPLACE(CONVERT(VARCHAR(MAX), @xml), '" />', '"/"')

		SELECT @endRun = GETDATE()
			, @duration = DATEDIFF(MILLISECOND, @startRun, @endRun)

		BEGIN TRY
			EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP @UserID = @UserID
							, @CustID			= @SuperID
							, @ActionID			= 394
							, @TrackingValue	= @logSpData
							, @TrackingValue2	= @logSpData_Old
							, @duration			= @duration
		END TRY
		BEGIN CATCH
			EXEC bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP @UserID = @UserID
							, @CustID			= @SuperID
							, @ActionID			= 394
							, @TrackingValue	= @logSpData
							, @TrackingValue2	= @logSpData_Old
							, @duration			= @duration
		END CATCH
END


GO
