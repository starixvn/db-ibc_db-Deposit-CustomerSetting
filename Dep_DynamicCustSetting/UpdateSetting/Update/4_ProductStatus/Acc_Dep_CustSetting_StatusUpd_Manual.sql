/*<info serverAlias="DBCUST-CUSTDB" executers="" viewers="vnteam" isFunction="0"></info>*/
USE CustDB
GO

ALTER PROCEDURE [dbo].[Acc_Dep_CustSetting_StatusUpd_Manual] 
	@ProductID INT
	, @CustID				INT
	, @IsDisabled			BIT
	, @IsDisabledDownLine	BIT = 0		
	, @SportType			INT
	, @BetType				INT
	, @bitmapOrder			TINYINT
	, @UserID				INT
	, @IP					VARCHAR(40)	
	, @ErrCode				INT				= 0		OUTPUT	
	, @ErrMsg				NVARCHAR(200)	= ''	OUTPUT
AS
/*
	Created: 20171009@Winne
	Task: Update DCS product status 
	DB: DBCUST/CustDB
	Original:
	Revisions:
		- 20171009@Winnie: Update DCS product status RedmineID:#82346
	Param's Explanation:
*/
BEGIN
	SET NOCOUNT ON
	SET NOCOUNT ON

	DECLARE @startRun	DATETIME
		, @endRun		DATETIME
		, @duration		INT
		
	DECLARE @logSpData		NVARCHAR(MAX)
		, @logSpData_Old	NVARCHAR(MAX)
		, @xml				XML	
		, @OldIsDisabled			BIT
		, @OldIsDisabledDownLine	BIT=1
		, @HasDownline	BIT=0
	DECLARE @tblmrecommend TABLE (CustID INT)

	DECLARE	@ProductName		VARCHAR(50),
			@SettingLevel		TINYINT,
			@ProductSettingID	INT

	SET @startRun = GETDATE()

	SELECT	@ErrCode	= 0
		,	@ErrMsg			= ''

	CREATE TABLE #SportBettypeFilter (SportType INT,Bettype INT)
	
	INSERT INTO #SportBettypeFilter (SportType,Bettype)
	SELECT @SportType,@BetType

	SELECT	@OldIsDisabled=(SELECT value FROM dbo.f_CustSetting_ProductStatusSel(stt.bitmapIsDisabled, @bitmapOrder))	
	FROM dbo.Dep_CustProductStatus stt WITH (NOLOCK)	
	WHERE stt.CustID = @CustID	
			
	IF EXISTS(SELECT TOP 1 1 FROM dbo.Customer s WITH (NOLOCK)	WHERE s.srecommend= @CustID	AND s.Roleid=1)
	SELECT @HasDownline=1		

	IF	@HasDownline<>0 AND @OldIsDisabled=0
	BEGIN
		IF EXISTS (
			SELECT TOP 1 1													
			FROM dbo.Dep_CustProductStatus stt WITH (NOLOCK)	
				INNER JOIN Customer b WITH(NOLOCK)	ON stt.CustID = b.CustID
				WHERE b.srecommend=@CustID AND b.roleid=1 AND	 (SELECT value FROM dbo.f_CustSetting_ProductStatusSel(stt.bitmapIsDisabled, @bitmapOrder))=1) 
		BEGIN
			SELECT @OldIsDisabledDownLine = 1
		END
		ELSE
			SELECT @OldIsDisabledDownLine = 0		
	END
			
	SELECT  @SettingLevel=SettingLevel,@ProductSettingID=ProductSettingID from Dep_ProductSetting WITH(NOLOCK) WHERE ProductID=@ProductID AND SettingType=4

	-- Select ProductName
	SELECT @ProductName = p.ProductName
	FROM DBPRO.bodb02.dbo.Products AS p WITH(NOLOCK)
	WHERE p.ProductID = @ProductID
	
	IF EXISTS (SELECT TOP 1 1 FROM Dep_LicenseeProductSetting d WITH(NOLOCK)
								INNER JOIN Dep_ProductSetting s WITH(NOLOCK) ON d.ProductSettingID=s.ProductSettingID WHERE SettingType=4 AND CustID=@CustID)
	BEGIN
		EXEC Acc_Dep_DynamicCustSetting_03
			@ActionID=1,
			@CustID=@CustID,
			@bitmapOrder=@bitmapOrder,					
			@IsDisabled=@IsDisabled,
			@IsDisabledDownline=@IsDisabledDownLine
		IF NOT EXISTS(SELECT TOP 1 1 FROM Dep_LicenseeProductSetting WITH(NOLOCK) WHERE Custid=@CustID AND ProductSettingID=@ProductSettingID )
			INSERT INTO Dep_LicenseeProductSetting(CustID,ProductSettingID)
			VALUES( @CustID,@ProductSettingID)
				
	END
	ELSE
	BEGIN
		EXEC Acc_Dep_DynamicCustSetting_03
			@ActionID=0,
			@CustID=@CustID,
			@bitmapOrder=@bitmapOrder,					
			@IsDisabled=@IsDisabled,
			@IsDisabledDownline=@IsDisabledDownLine
			
		INSERT INTO Dep_LicenseeProductSetting(CustID,ProductSettingID)
		VALUES( @CustID,@ProductSettingID)
	END
	
	SELECT @ErrMsg='Update Status successfully'
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
				@OldIsDisabledDownLine			AS '@IsDisabledDownline',
				(
					SELECT	@ProductID							AS '@ProductID',
							@OldIsDisabled						AS '@IsDisabled'	
					FOR XML PATH('IsDisabled'),
					TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_StatusUpd'),
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
				@OldIsDisabledDownLine			AS '@IsDisabledDownline',
				(
					SELECT	SportType							AS '@SportType',
							@OldIsDisabled						AS '@IsDisabled'							
					FROM #SportBettypeFilter
					FOR XML PATH('IsDisabled'),
					TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_StatusUpd'),
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
				@OldIsDisabledDownLine			AS '@IsDisabledDownline',
				(
					SELECT	BetType								AS '@BetType',
							@OldIsDisabled						AS '@IsDisabled'			
					FROM #SportBettypeFilter
					FOR XML PATH('IsDisabled'),
					TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_StatusUpd'),
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
				@OldIsDisabledDownLine			AS '@IsDisabledDownline',
				(
					SELECT	SportType							AS '@SportType',
							BetType								AS '@BetType',
							@OldIsDisabled						AS '@IsDisabled'			
					FROM #SportBettypeFilter
					FOR XML PATH('IsDisabled'),
					TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_StatusUpd'),
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
				@IsDisabledDownline				AS '@IsDisabledDownline',
				(
					SELECT	@ProductID							AS '@ProductID',
							@IsDisabled							AS '@IsDisabled'
					FROM #SportBettypeFilter
					FOR XML PATH('IsDisabled'),
					TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_StatusUpd'),
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
				@IsDisabledDownline				AS '@IsDisabledDownline',
				(
					SELECT	SportType							AS '@SportType',
							@IsDisabled							AS '@IsDisabled'							
					FROM #SportBettypeFilter
					FOR XML PATH('IsDisabled'),
					TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_StatusUpd'),
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
				@IsDisabledDownline				AS '@IsDisabledDownline',
				(
					SELECT	BetType								AS '@BetType',
							@IsDisabled							AS '@IsDisabled'
					FROM #SportBettypeFilter
					FOR XML PATH('IsDisabled'),
					TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_StatusUpd'),
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
				@IsDisabledDownline				AS '@IsDisabledDownline',
				(
					SELECT	SportType							AS '@SportType',
							BetType								AS '@BetType',
							@IsDisabled							AS '@IsDisabled'
					FROM #SportBettypeFilter
					FOR XML PATH('IsDisabled'),
					TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_StatusUpd'),
		TYPE
	)
	END
	SET @logSpData = REPLACE(CONVERT(VARCHAR(MAX), @xml), '" />', '"/"')

	SELECT @endRun = GETDATE()
		, @duration = DATEDIFF(MILLISECOND, @startRun, @endRun)

	BEGIN TRY
		EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP @UserID = @UserID
						, @CustID			= @CustID
						, @ActionID			= 1164
						, @TrackingValue	= @logSpData
						, @TrackingValue2	= @logSpData_Old
						, @duration			= @duration
	END TRY
	BEGIN CATCH
		EXEC bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP @UserID = @UserID
						, @CustID			= @CustID
						, @ActionID			= 1164
						, @TrackingValue	= @logSpData
						, @TrackingValue2	= @logSpData_Old
						, @duration			= @duration
	END CATCH
END

GRANT VIEW DEFINITION ON dbo.Acc_Dep_CustSetting_StatusUpd_Manual TO vnteam