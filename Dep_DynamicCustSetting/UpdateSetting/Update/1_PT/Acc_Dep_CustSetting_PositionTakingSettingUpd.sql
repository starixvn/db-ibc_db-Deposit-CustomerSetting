/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet,bodbDownlineNet,bodbExtAccNet,bodbLicenseeNet" viewers="vnteam" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_CustSetting_PositionTakingSettingUpd] 
	  @CustID		INT
	, @PT			TINYINT
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
		
	Param's Explanation:
	

	*/

BEGIN
	SET NOCOUNT ON

	DECLARE @startRun	DATETIME
		, @endRun		DATETIME
		, @duration		INT
		
	DECLARE @logSpData		NVARCHAR(MAX)
		, @logSpData_Old	NVARCHAR(MAX)
		, @xml				XML	
		, @OldPT			TINYINT

	DECLARE @ProductID		TINYINT,
			@ProductName	VARCHAR(50),
			@SettingLevel	TINYINT


	SET @startRun = GETDATE()

	SELECT	@ErrCode	= 0
		,	@ErrMsg			= ''

	EXEC DBEXT.bodb02.dbo.NAP_LM_CustomerSelCheckAllowedDownlines
	 @custid = @CustID
	,@Language = 'E'
	,@ErrMsg = @ErrMsg OUTPUT
	,@ErrCode=@ErrCode OUTPUT

	IF @ErrCode <> 0 
		RETURN 

		-- Select ProductID and SettingLevel
	SELECT @ProductID = ProductID, @SettingLevel = SettingLevel
	FROM (	SELECT TOP 1 ps.ProductID, ps.SettingLevel
			FROM Dep_ProductSettingDetail AS psd WITH(NOLOCK)
				INNER JOIN	#SportBettypeFilter AS tmp ON	psd.SportType = tmp.SportType AND	psd.BetType = tmp.BetType
				INNER JOIN Dep_ProductSetting AS ps WITH (NOLOCK) ON ps.ProductSettingID = psd.ProductSettingID
			WHERE	ps.ProductID IS NOT NULL
				AND	ps.SettingLevel IS NOT NULL
				AND ps.SettingType = 2	-- Bet Limit
		 ) iq

	-- Select ProductName
	SELECT @ProductName = p.ProductName
	FROM DBPRO.bodb02.dbo.Products AS p WITH(NOLOCK)
	WHERE p.ProductID = @ProductID

		
	CREATE TABLE #SportBettypeFilter (productID INT,SportType SMALLINT,Bettype SMALLINT,IsLive BIT)
	
	INSERT INTO #SportBettypeFilter (productID,SportType,Bettype,IsLive)
	SELECT  ps.ProductID ProductID, SportType,Bettype,IsLive
	FROM dbo.f_Dep_CustSetting_SportBetTypeSettingSelect(@ProductID,1) AS ps

	SELECT @OldPT= SuperPT 
			FROM 	#SportBettypeFilter ft 
			INNER JOIN dbo.Dep_CustPTSetting_Agent bl WITH (NOLOCK) ON ft.SportType = bl.sporttype AND ft.BetType = bl.bettype 
			WHERE CustID=@CustID  

	
	IF EXISTS (SELECT TOP 1 1 FROM Dep_ProductSetting ps WITH(NOLOCK) 
								INNER JOIN Dep_LicenseeProductSetting d WITH(NOLOCK) ON ps.ProductSettingID=d.ProductSettingID WHERE ProductID=@ProductID AND SettingType =2 AND CustID=@CustID)
	BEGIN
		EXEC [Acc_Dep_DynamicCustSetting_01]
				@ActionID=1,
				@CustID=@CustID,
				@PT=@PT,					
				@SettingType=1	
	END
	ELSE
	BEGIN
		EXEC [Acc_Dep_DynamicCustSetting_01]
				@ActionID=0,
				@CustID=@CustID,
				@PT=@PT,				
				@SettingType=1	

		INSERT INTO Dep_LicenseeProductSetting(CustID,ProductSettingID)
		SELECT @CustID,ProductSettingID
			FROM Dep_ProductSetting WITH(NOLOCK)
			WHERE ProductID=@ProductID AND SettingType=1
	END
	SELECT @ErrMsg='Update Bet Setting successfully'

	--IF @RoleID = 1
	--BEGIN
	--	--get old settings
	--	INSERT INTO @OldBetLimitTbl
	--	SELECT bl.SportType
	--		, bl.BetType
	--		, bl.MinBet
	--		, bl.MaxBet
	--		, bl.MaxPerMatch
	--	FROM dbo.Dep_CustBetSetting_Member bl WITH (NOLOCK)
	--		INNER JOIN @NewBetLimitTbl tmp	ON tmp.SportType = bl.sporttype	AND tmp.BetType = bl.bettype
	--	WHERE bl.custid = @CustID

	--	--update new settings
	--	UPDATE main
	--	SET main.minbet			= tmp.MinBet
	--		, main.maxbet		= tmp.MaxBet
	--		, main.maxpermatch	= tmp.MaxperMatch
	--	FROM dbo.Dep_CustBetSetting_Member main WITH(ROWLOCK,UPDLOCK)
	--		INNER JOIN @NewBetLimitTbl tmp	ON tmp.SportType = main.sporttype AND tmp.BetType = main.bettype
	--	WHERE main.custid = @CustID
	--		AND (
	--				main.minbet		<> tmp.MinBet
	--			OR main.maxbet		<> tmp.MaxBet
	--			OR main.maxpermatch <> tmp.MaxperMatch
	--			)
	--END
	--ELSE IF @RoleID IN (2, 3, 4)
	--BEGIN
	--	--get old settings
	--	INSERT INTO @OldBetLimitTbl
	--	SELECT bl.SportType
	--		, bl.BetType
	--		, bl.MinBet
	--		, bl.MaxBet
	--		, bl.MaxPerMatch
	--	FROM dbo.Dep_CustBetSetting_Agent bl WITH (NOLOCK)
	--		INNER JOIN @NewBetLimitTbl tmp	ON tmp.SportType = bl.sporttype	AND tmp.BetType = bl.bettype
	--	WHERE bl.custid = @CustID

		--update new settings
		UPDATE main
		SET main.minbet			= tmp.MinBet
			, main.maxbet		= tmp.MaxBet
			, main.maxpermatch	= tmp.MaxperMatch
		FROM dbo.Dep_CustBetSetting_Agent main WITH(ROWLOCK,UPDLOCK)
			INNER JOIN @NewBetLimitTbl tmp	ON tmp.SportType = main.sporttype AND tmp.BetType = main.bettype
		WHERE main.custid = @CustID
			AND (
					main.minbet		<> tmp.MinBet
				OR main.maxbet		<> tmp.MaxBet
				OR main.maxpermatch <> tmp.MaxperMatch
				)
	END

	--START LOGGING



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
							@OldPT								AS '@PositionTaking'						
					FROM #SportBettypeFilter
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
				@CustID							AS '@CustID',
				@UserID							AS '@UserID',				
				@IP								AS '@IP',
				(
					SELECT	SportType							AS '@SportType',
							@OldPT								AS '@PositionTaking'							
					FROM #SportBettypeFilter
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
				@CustID							AS '@CustID',
				@UserID							AS '@UserID',				
				@IP								AS '@IP',
				(
					SELECT	BetType								AS '@BetType',
							@OldPT								AS '@PositionTaking'			
					FROM #SportBettypeFilter
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
				@CustID							AS '@CustID',
				@UserID							AS '@UserID',				
				@IP								AS '@IP',
				(
					SELECT	SportType							AS '@SportType',
							BetType								AS '@BetType',
							@OldPT								AS '@PositionTaking'			
					FROM #SportBettypeFilter
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
				@CustID							AS '@CustID',
				@UserID							AS '@UserID',				
				@IP								AS '@IP',
				(
					SELECT	@ProductID							AS '@ProductID',
							@PT									AS '@PositionTaking'
					FROM #SportBettypeFilter
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
				@CustID							AS '@CustID',
				@UserID							AS '@UserID',				
				@IP								AS '@IP',
				(
					SELECT	SportType							AS '@SportType',
							@PT									AS '@PositionTaking'							
					FROM #SportBettypeFilter
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
				@CustID							AS '@CustID',
				@UserID							AS '@UserID',				
				@IP								AS '@IP',
				(
					SELECT	BetType								AS '@BetType',
							@PT									AS '@PositionTaking'
					FROM #SportBettypeFilter
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
				@CustID							AS '@CustID',
				@UserID							AS '@UserID',			
				@IP								AS '@IP',
				(
					SELECT	SportType							AS '@SportType',
							BetType								AS '@BetType',
							@PT									AS '@PositionTaking'
					FROM #SportBettypeFilter
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

	BEGIN TRY
		EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP @UserID = @UserID
						, @CustID			= @CustID
						, @ActionID			= 2048
						, @TrackingValue	= @logSpData
						, @TrackingValue2	= @logSpData_Old
						, @duration			= @duration
	END TRY
	BEGIN CATCH
		EXEC bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP @UserID = @UserID
						, @CustID			= @CustID
						, @ActionID			= 2048
						, @TrackingValue	= @logSpData
						, @TrackingValue2	= @logSpData_Old
						, @duration			= @duration
	END CATCH
END

GO
GRANT EXECUTE ON [dbo].Acc_Dep_CustSetting_PositionTakingSettingUpd TO [bodbadminNet]
GO
GRANT EXECUTE ON [dbo].Acc_Dep_CustSetting_PositionTakingSettingUpd TO [bodbDownlineNet]
GO
GRANT EXECUTE ON [dbo].Acc_Dep_CustSetting_PositionTakingSettingUpd TO [bodbExtAccNet]
GO
GRANT EXECUTE ON [dbo].Acc_Dep_CustSetting_PositionTakingSettingUpd TO [bodbLicenseeNet]