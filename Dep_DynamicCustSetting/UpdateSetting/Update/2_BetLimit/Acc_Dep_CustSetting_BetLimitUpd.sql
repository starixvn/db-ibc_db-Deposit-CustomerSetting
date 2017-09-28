/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet,bodbDownlineNet,bodbExtAccNet,bodbLicenseeNet" viewers="vnteam" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_CustSetting_BetLimitFullLineUpd] 
	  @CustID				INT
	, @BetLimit				VARCHAR(MAX)
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
		
	Param's Explanation:
	• @BetLimit:
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
		
	DECLARE @logSpData		NVARCHAR(MAX)
		, @logSpData_Old	NVARCHAR(MAX)
		, @xml				XML
		
	DECLARE @OldBetLimitTbl TABLE (
		SportType			SMALLINT
		, BetType			SMALLINT
		, MinBet			MONEY
		, MaxBet			MONEY
		, MaxPerMatch		MONEY
		)
	DECLARE @NewBetLimitTbl TABLE (
		SportType			SMALLINT
		, BetType			SMALLINT
		, MinBet			MONEY
		, MaxBet			MONEY
		, MaxPerMatch		MONEY
		)

	DECLARE @ProductID		TINYINT,
			@ProductName	VARCHAR(50),
			@SettingLevel	TINYINT

	

	--Check if XML is null or empty
	IF @BetLimit IS NULL
		OR @BetLimit = ''
		RETURN

	SET @startRun = GETDATE()

	SELECT	@ErrCode	= 0		
		,	@ErrMsg			= ''

	EXEC DBEXT.bodb02.dbo.NAP_LM_CustomerSelCheckAllowedDownlines
		@custid = @CustID
		,@Language = 'E'
		,@ErrMsg = @ErrMsg OUTPUT
		,@ErrCode=@ErrCode OUTPUT

	IF @ErrCode <> 0 AND @ApplyExistedMem=1
		RETURN 
	
	
	--Parse XML	
	DECLARE @iDoc INT

	EXEC sp_xml_preparedocument @iDoc OUTPUT
		, @BetLimit

	INSERT @NewBetLimitTbl
	SELECT *
	FROM OPENXML(@iDoc, '/ROOT/BetLimit', 1) WITH (
			SportType		SMALLINT
			, BetType		SMALLINT
			, MinBet		MONEY
			, MaxBet		MONEY
			, MaxPerMatch	MONEY
			)

	EXEC sp_xml_removedocument @iDoc

		--get old settings
	INSERT INTO @OldBetLimitTbl
	SELECT bl.SportType
		, bl.BetType
		, bl.MinBet
		, bl.MaxBet
		, bl.MaxPerMatch
	FROM dbo.Dep_CustBetSetting_Agent bl WITH (NOLOCK)
		INNER JOIN @NewBetLimitTbl tmp	ON tmp.SportType = bl.sporttype	AND tmp.BetType = bl.bettype
		WHERE bl.custid = @CustID

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


	IF EXISTS (SELECT TOP 1 1 FROM Dep_ProductSetting ps WITH(NOLOCK) 
								INNER JOIN Dep_LicenseeProductSetting d WITH(NOLOCK) ON ps.ProductSettingID=d.ProductSettingID WHERE ProductID=@ProductID AND SettingType =2 AND CustID=@CustID)
	BEGIN
		EXEC [Acc_Dep_DynamicCustSetting_01]
				@ActionID=1,
				@CustID=@CustID,
				@BetLimit=@BetLimit,
				@ApplyExistedMem=@ApplyExistedMem,
				@SettingType=2	
	END
	ELSE
	BEGIN
		EXEC [Acc_Dep_DynamicCustSetting_01]
				@ActionID=0,
				@CustID=@CustID,
				@BetLimit=@BetLimit,
				@ApplyExistedMem=@ApplyExistedMem,
				@SettingType=2	

		INSERT INTO Dep_LicenseeProductSetting(CustID,ProductSettingID)
		SELECT @CustID,ProductSettingID
			FROM Dep_ProductSetting WITH(NOLOCK)
			WHERE ProductID=@ProductID AND SettingType=2
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
				@CustID							AS '@CustID',
				@UserID							AS '@UserID',				
				@IP								AS '@IP',
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
				@CustID							AS '@CustID',
				@UserID							AS '@UserID',				
				@IP								AS '@IP',
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
				@CustID							AS '@CustID',
				@UserID							AS '@UserID',			
				@IP								AS '@IP',
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
				@CustID							AS '@CustID',
				@UserID							AS '@UserID',				
				@IP								AS '@IP',
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
				@CustID							AS '@CustID',
				@UserID							AS '@UserID',				
				@IP								AS '@IP',
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
				@CustID							AS '@CustID',
				@UserID							AS '@UserID',			
				@IP								AS '@IP',
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
				@CustID							AS '@CustID',
				@UserID							AS '@UserID',				
				@IP								AS '@IP',
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
				@CustID							AS '@CustID',
				@UserID							AS '@UserID',			
				@IP								AS '@IP',
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
						, @CustID			= @CustID
						, @ActionID			= 2047
						, @TrackingValue	= @logSpData
						, @TrackingValue2	= @logSpData_Old
						, @duration			= @duration
	END TRY
	BEGIN CATCH
		EXEC bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP @UserID = @UserID
						, @CustID			= @CustID
						, @ActionID			= 2047
						, @TrackingValue	= @logSpData
						, @TrackingValue2	= @logSpData_Old
						, @duration			= @duration
	END CATCH
END

GO
