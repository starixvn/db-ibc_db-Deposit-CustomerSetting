/*<info serverAlias="DBCUST-CUSTDB" executers="wsv_nap,wsv_lap" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE dbo.Acc_Dep_CustSetting_ChargeCommUpd 
	  @CustID			INT
	, @ProductID		TINYINT
	, @Discount			VARCHAR(MAX)
	, @SettingStatus	TINYINT = 0
	, @UserID		INT
	, @IP			VARCHAR(50)		= ''
	, @ErrCode		INT				= 0		OUTPUT	
	, @ErrMsg		NVARCHAR(200)	= ''	OUTPUT

AS
/*
	Created: 20240429@Tacy
	Task: Check Customer's comm
	DB: DBCUST/CustDB

	Revision:
		- 20240429@Tacy: Licensee DCS Setting - Integrate Exchange [RedmineID: #201239]
		- 20240812@Tacy: Correct writelog [Redmine: #201239]

	Param's Explanation:
		• @Discount:
			<ROOT>
					<Discount 
							SportType="221" 
							BetType="8001" 
							Discount="0.0025"
					/>
			</ROOT>
*/
BEGIN
	SET NOCOUNT ON;

	DECLARE @iDoc INT
	
	DECLARE @startRun				DATETIME
		,	@endRun					DATETIME
		,	@duration				INT
		
	DECLARE @logSpData		NVARCHAR(MAX)
		,	@logSpData_Old	NVARCHAR(MAX)
		,	@xml			XML
		
	DECLARE @recommend		INT
		,	@mrecommend		INT
		,	@srecommend		INT
		,	@RoleID			INT
		,	@SportType		SMALLINT
		,	@Bettype		SMALLINT
		,	@ChargeComm		DECIMAL(9,8)


	DECLARE @NewDiscountTbl TABLE (
				SportType	SMALLINT
			,	BetType		SMALLINT
			,	Discount	DECIMAL(9,8)
		)
		
	DECLARE @oldDiscountTbl TABLE (
				SportType	SMALLINT
			,	BetType		SMALLINT
			,	Discount	DECIMAL(9,8)
		)

	DECLARE @ProductName	VARCHAR(50),
			@SettingLevel	TINYINT,
			@ProductSettingID INT

	--Check if XML is null or empty
	IF @Discount IS NULL
		OR @Discount = ''
		RETURN

	--Check discount value
	EXEC dbo.Acc_Dep_CustSetting_ChargeCommCheck 
		 @CustID		= @CustID
		,@ProductID		= @ProductID		
		,@Discount		= @Discount
		,@SettingStatus	= @SettingStatus
		,@ErrCode		= @ErrCode OUTPUT
		,@ErrMsg		= @ErrMsg OUTPUT

	IF @ErrCode<>0
		RETURN

	--Get line information
	SELECT @recommend = recommend
		, @mrecommend = mrecommend
		, @srecommend = srecommend
		, @RoleID = RoleID
	FROM dbo.custInfo WITH (NOLOCK)
	WHERE custid = @CustID

	--Parse XML
	EXEC sp_xml_preparedocument @iDoc OUTPUT
		, @Discount

	INSERT @NewDiscountTbl
	SELECT SportType
		, BetType
		, CAST(Discount AS DECIMAL(9, 8)) AS Discount
	FROM OPENXML(@iDoc, '/ROOT/Discount', 1) WITH (
			SportType SMALLINT
			, BetType SMALLINT
			, Discount VARCHAR(15)
			)

	EXEC sp_xml_removedocument @iDoc

	--Get old comm
	INSERT INTO @oldDiscountTbl
	SELECT dc.SportType
		, dc.BetType
		, dc.Discount
	FROM @NewDiscountTbl tmp
	INNER JOIN dbo.Dep_CustDiscountSetting_Agent dc WITH (NOLOCK)
		ON dc.SportType		= tmp.SportType
			AND dc.BetType	= tmp.BetType
			AND dc.CustID	= @CustID
	
	--get setting
	SELECT @SportType=ft.SportType, @Bettype=ft.Bettype
		, @ProductSettingID=ProductSettingID, @SettingLevel=SettingLevel
	FROM dbo.f_Dep_CustSetting_SportBetTypeSettingSelect(@ProductID,5,@SettingStatus) ft

	SELECT @ChargeComm=Discount
	FROM @NewDiscountTbl
	WHERE SportType=@SportType AND BetType=@Bettype

	EXEC Acc_Dep_DynamicCustSetting_06
		@CustID			= @CustID
		,@RoleId		= @RoleID
		,@srecommend	= @srecommend
		,@mrecommend	= @mrecommend
		,@ProductID		= @ProductID 
		,@SportType		= @SportType
		,@BetType		= @BetType
		,@ChargeComm	= @ChargeComm
		,@Mode			= 'UpdateChargeComm'

	SELECT @ErrMsg='Update Charge Commission successfully'

	-- Select ProductName
	SELECT @ProductName = p.ProductName
	FROM DBPRO.bodb02.dbo.Products AS p WITH(NOLOCK)
	WHERE p.ProductID = @ProductID

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
							cs.Discount				AS '@Discount'	
					FROM	@oldDiscountTbl AS cs	
					FOR XML PATH('PT'),
					TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_ChargeCommUpd'),
		TYPE
	)
	END
	ELSE IF @SettingLevel = 2		-- SportType setting level
	BEGIN
		SET @xml = (
		SELECT	@ProductID						AS '@ProductID',
				@ProductName					AS '@ProductName',
				@CustID							AS '@SuperID',
				@UserID							AS '@UserID',				
				@IP								AS '@IP',
				(
					SELECT	SportType			AS '@SportType',
							cs.Discount				AS '@Discount'	
					FROM	@oldDiscountTbl AS cs
					FOR XML PATH('PT'),
					TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_ChargeCommUpd'),
		TYPE
	)
	END
	ELSE IF @SettingLevel = 3		-- BetType setting level
	BEGIN
		SET @xml = (
		SELECT	@ProductID						AS '@ProductID',
				@ProductName					AS '@ProductName',
				@CustID							AS '@SuperID',
				@UserID							AS '@UserID',				
				@IP								AS '@IP',
				(
					SELECT	BetType				AS '@BetType',
							cs.Discount				AS '@Discount'	
					FROM	@oldDiscountTbl AS cs
					FOR XML PATH('PT'),
					TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_ChargeCommUpd'),
		TYPE
	)
	END
	ELSE IF @SettingLevel = 4		-- SportType BetType setting level
	BEGIN
		SET @xml = (
		SELECT	@ProductID						AS '@ProductID',
				@ProductName					AS '@ProductName',
				@CustID							AS '@SuperID',
				@UserID							AS '@UserID',				
				@IP								AS '@IP',
				(
					SELECT	SportType			AS '@SportType',
							BetType				AS '@BetType',
							cs.Discount				AS '@Discount'	
					FROM	@oldDiscountTbl AS cs
					FOR XML PATH('PT'),
					TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_ChargeCommUpd'),
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
							cs.Discount				AS '@Discount'	
					FROM	@NewDiscountTbl AS cs			
					FOR XML PATH('PT'),
					TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_ChargeCommUpd'),
		TYPE
	)
	END
	ELSE IF @SettingLevel = 2		-- SportType setting level
	BEGIN
		SET @xml = (
		SELECT	@ProductID						AS '@ProductID',
				@ProductName					AS '@ProductName',
				@CustID							AS '@SuperID',
				@UserID							AS '@UserID',				
				@IP								AS '@IP',
				(
					SELECT	SportType			AS '@SportType',
							cs.Discount				AS '@Discount'	
					FROM	@NewDiscountTbl AS cs	
					FOR XML PATH('Discount'),
					TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_ChargeCommUpd'),
		TYPE
	)
	END
	ELSE IF @SettingLevel = 3		-- BetType setting level
	BEGIN
		SET @xml = (
		SELECT	@ProductID						AS '@ProductID',
				@ProductName					AS '@ProductName',
				@CustID							AS '@SuperID',
				@UserID							AS '@UserID',				
				@IP								AS '@IP',
				(
					SELECT	BetType				AS '@BetType',
							cs.Discount				AS '@Discount'	
					FROM	@NewDiscountTbl AS cs	
					FOR XML PATH('Discount'),
					TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_ChargeCommUpd'),
		TYPE
	)
	END
	ELSE IF @SettingLevel = 4		-- SportType BetType setting level
	BEGIN
		SET @xml = (
		SELECT	@ProductID						AS '@ProductID',
				@ProductName					AS '@ProductName',
				@CustID							AS '@SuperID',
				@UserID							AS '@UserID',			
				@IP								AS '@IP',
				(
					SELECT	SportType			AS '@SportType',
							BetType				AS '@BetType',
							cs.Discount				AS '@Discount'	
					FROM	@NewDiscountTbl AS cs	
					FOR XML PATH('Discount'),
					TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_ChargeCommUpd'),
		TYPE
	)
	END
	SET @logSpData = REPLACE(CONVERT(VARCHAR(MAX), @xml), '" />', '"/"')

	SELECT @endRun = GETDATE()
		, @duration = DATEDIFF(MILLISECOND, @startRun, @endRun)

	EXEC dbo.Acc_WriteLog_UserLog_RunSP_Wrapper 
		@UserID = @UserID
		, @CustID			= @CustID
		, @ActionID			= 256
		, @TrackingValue	= @logSpData
		, @TrackingValue2	= @logSpData_Old
		, @duration			= @duration

END
GO