/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet,bodbDownlineNet,bodbExtAccNet,bodbLicenseeNet" viewers="vnteam" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_CustSetting_PositionTakingSettingUpd] 
	  @CustID		INT
	, @PT			SMALLMONEY
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
		- 20171009@Winnie: Update PT of DCS product [RedmineID:#82346]
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

	DECLARE	@ProductName		VARCHAR(50),
			@SettingLevel		TINYINT,
			@ProductSettingID	INT


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
			
	SELECT  @SettingLevel=SettingLevel,@ProductSettingID=ProductSettingID from Dep_ProductSetting WITH(NOLOCK) WHERE ProductID=@ProductID AND SettingType=1

	-- Select ProductName
	SELECT @ProductName = p.ProductName
	FROM DBPRO.bodb02.dbo.Products AS p WITH(NOLOCK)
	WHERE p.ProductID = @ProductID

		
	CREATE TABLE #SportBettypeFilter (SportType INT,Bettype INT,IsLive BIT)
	
	INSERT INTO #SportBettypeFilter (SportType,Bettype,IsLive)
	SELECT DISTINCT  SportType,Bettype,IsLive 	
	FROM Dep_ProductSetting ps WITH(NOLOCK) 
		INNER JOIN Dep_ProductSettingDetail d WITH(NOLOCK) ON ps.ProductSettingID=d.ProductSettingID  
	WHERE ProductID = @ProductID AND SettingType=1	

	SELECT @OldPT= SuperPT 
			FROM 	#SportBettypeFilter ft 
			INNER JOIN dbo.Dep_CustPTSetting_Agent bl WITH (NOLOCK) ON ft.SportType = bl.sporttype AND ft.BetType = bl.bettype 
			WHERE CustID=@CustID  

	
	IF EXISTS (SELECT TOP 1 1 FROM Dep_LicenseeProductSetting d WITH(NOLOCK)WHERE ProductSettingID=@ProductSettingID AND CustID=@CustID)
	BEGIN
		EXEC [Acc_Dep_DynamicCustSetting_01]
				@ActionID=1,
				@CustID=@CustID,
				@PT=@PT,					
				@ProductID=@ProductID
				
	END
	ELSE
	BEGIN
		EXEC [Acc_Dep_DynamicCustSetting_01]
				@ActionID=0,
				@CustID=@CustID,
				@PT=@PT,				
				@ProductID=@ProductID
			
		INSERT INTO Dep_LicenseeProductSetting(CustID,ProductSettingID)
		VALUES( @CustID,@ProductSettingID)
	END
	
	SELECT @ErrMsg='Update Position Taking successfully'
	
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
GRANT EXECUTE ON [dbo].[Acc_Dep_CustSetting_PositionTakingSettingUpd] TO [bodbadminNet]
GO
GRANT EXECUTE ON [dbo].[Acc_Dep_CustSetting_PositionTakingSettingUpd] TO [bodbDownlineNet]
GO
GRANT EXECUTE ON [dbo].[Acc_Dep_CustSetting_PositionTakingSettingUpd] TO [bodbExtAccNet]
GO
GRANT EXECUTE ON [dbo].[Acc_Dep_CustSetting_PositionTakingSettingUpd] TO [bodbLicenseeNet]