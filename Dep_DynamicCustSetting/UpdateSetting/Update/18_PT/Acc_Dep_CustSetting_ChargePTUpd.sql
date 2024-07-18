/*<info serverAlias="DBCUST-CUSTDB" executers="wsv_nap,wsv_lap,svc_tig" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE dbo.Acc_Dep_CustSetting_ChargePTUpd
	 @CustID		INT
	, @PT			VARCHAR(MAX)
	, @ProductID	INT
	, @SettingStatus TINYINT = 0
	, @UserID		INT
	, @IP			VARCHAR(50)		= ''
	, @ErrCode		INT				= 0		OUTPUT	
	, @ErrMsg		NVARCHAR(200)	= ''	OUTPUT
AS
/*
	Created: 20240429@Tacy
	Task: Update Customer's PT
	DB: DBCUST/CustDB

	Revision:
		- 20240429@Tacy: Licensee DCS Setting - Integrate Exchange [RedmineID: #201239]

	Param's Explanation:
		@PT:
		<ROOT>
				<PT
					SportType="221"
					PT="90"
				/>
		</ROOT>
	*/

BEGIN
	SET NOCOUNT ON

	DECLARE @startRun DATETIME, @endRun	DATETIME, @duration INT, @ProductSettingID INT
	DECLARE @logSpData NVARCHAR(MAX), @logSpData_Old NVARCHAR(MAX), @xml XML, @iDoc INT
	DECLARE	@ProductName VARCHAR(50), @SettingLevel	TINYINT, @curDate DATE
	CREATE TABLE #tmpPT (SportType INT, PT SMALLMONEY)
	CREATE TABLE #tmpPT_Old (SportType INT, PT SMALLMONEY)

	SET @startRun = GETDATE()
	SET @curDate = CAST(GETDATE() AS DATE)

	IF EXISTS (SELECT 1 FROM Customer WITH (NOLOCK) WHERE custid=@CustID AND roleid<>4)
	BEGIN
		SELECT @ErrCode=101
			, @ErrMsg='Invalid customer.'

		RETURN
	END

	SELECT  @SettingLevel=SettingLevel, @ProductSettingID=ProductSettingID
	FROM dbo.f_Dep_CustSetting_SportBetTypeSettingSelect(@ProductID,18,@SettingStatus)

	-- Select ProductName
	SELECT @ProductName = p.ProductName
	FROM DBPRO.bodb02.dbo.Products AS p WITH(NOLOCK)
	WHERE p.ProductID = @ProductID

	--Parse XML
	EXECUTE	sp_xml_preparedocument @iDoc OUTPUT, @PT

	INSERT INTO #tmpPT (SportType, PT)
	SELECT	ox.SportType, ox.PT
	FROM OPENXML (@iDoc, '/ROOT/PT', 1) 
	WITH (
		SportType		SMALLINT
	,	PT				SMALLMONEY	
	) AS ox;

	EXECUTE sp_xml_removedocument @iDoc;
	
	INSERT INTO	#tmpPT_Old (SportType, PT)
	SELECT ts.SportType
		,	ds.PT			
	FROM	dbo.Dep_ChargeInfoSetting AS ds WITH (NOLOCK)
		INNER JOIN	#tmpPT AS ts ON	ts.SportType=ds.SportType
	WHERE ds.CustID = @CustID AND @curDate < ToDate AND ds.isDeleted=0

	IF EXISTS (SELECT 1 FROM dbo.Dep_ChargeInfoSetting AS ds WITH (NOLOCK)
			   INNER JOIN #tmpPT_Old AS ts ON ts.SportType=ds.SportType
			   WHERE ds.CustID = @CustID AND ds.isDeleted=0
					AND FromDate=DATEADD(DAY, 1, @curDate)
					AND @curDate < ToDate)
	BEGIN -- UPDATE: in a day
		UPDATE ds
			SET ds.PT = t.PT
				, ds.RepUpdateTime=SYSDATETIME()
		FROM dbo.Dep_ChargeInfoSetting ds WITH(ROWLOCK,UPDLOCK)
			INNER JOIN #tmpPT t ON ds.CustID=@CustID AND ds.SportType=t.SportType
		WHERE ds.CustID = @CustID AND ds.isDeleted=0
			AND FromDate=DATEADD(DAY, 1, @curDate)
			AND @curDate < ToDate
	END
	ELSE IF 
		EXISTS (SELECT 1 FROM dbo.Dep_ChargeInfoSetting AS ds WITH (NOLOCK)
			   INNER JOIN #tmpPT_Old AS ts ON ts.SportType=ds.SportType
			   WHERE ds.CustID = @CustID AND ds.isDeleted=0
					AND @curDate < ToDate)
	BEGIN
		UPDATE ds
			SET ds.ToDate = @curDate
				, ds.RepUpdateTime=SYSDATETIME()
		FROM dbo.Dep_ChargeInfoSetting ds WITH(ROWLOCK,UPDLOCK)
			INNER JOIN #tmpPT t ON ds.CustID=@CustID AND ds.SportType=t.SportType
		WHERE @curDate < ToDate AND ds.isDeleted=0

		INSERT INTO dbo.Dep_ChargeInfoSetting(CustID,SportType,PT,FromDate)
		SELECT @CustID,SportType,PT,DATEADD(DAY, 1, @curDate)
		FROM #tmpPT t
	END
	ELSE
		INSERT INTO dbo.Dep_ChargeInfoSetting(CustID,SportType,PT)
		SELECT @CustID,SportType,PT
		FROM #tmpPT t

	IF NOT EXISTS (SELECT 1 FROM Dep_LicenseeProductSetting d WITH(NOLOCK)
					WHERE ProductSettingID=@ProductSettingID AND CustID=@CustID)
	BEGIN
		INSERT INTO Dep_LicenseeProductSetting(CustID,ProductSettingID)
		SELECT @CustID,@ProductSettingID
	END			

	SELECT @ErrMsg='Update Position Taking successfully'
	
	--START LOGGING
	-- Log old data
	IF @SettingLevel = 1			-- Product setting level
	BEGIN
		SET @xml = (
		SELECT	@ProductID						AS '@ProductID',
				@ProductName					AS '@ProductName',
				@CustID							AS '@SuperID',
				@UserID							AS '@UserID',				
				@IP								AS '@IP',
				(
					SELECT	@ProductID			AS '@ProductID',
							cs.PT				AS '@PositionTaking'	
					FROM	#tmpPT_Old AS cs	
					FOR XML PATH('PT'),
					TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_ChargePTUpd'),
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
				@CustID							AS '@SuperID',
				@UserID							AS '@UserID',				
				@IP								AS '@IP',
				(
					SELECT	@ProductID			AS '@ProductID',
							cs.PT				AS '@PositionTaking'	
					FROM	#tmpPT AS cs			
					FOR XML PATH('PT'),
					TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_ChargePTUpd'),
		TYPE
	)
	END

	SET @logSpData = REPLACE(CONVERT(VARCHAR(MAX), @xml), '" />', '"/"')

	SELECT @endRun = GETDATE()
		, @duration = DATEDIFF(MILLISECOND, @startRun, @endRun)

	EXEC dbo.Acc_WriteLog_UserLog_RunSP_Wrapper 
		@UserID = @UserID
		, @CustID			= @CustID
		, @ActionID			= 487
		, @TrackingValue	= @logSpData
		, @TrackingValue2	= @logSpData_Old
		, @duration			= @duration
END
GO
