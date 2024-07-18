/*<info serverAlias="DBCUST-CUSTDB" executers="wsv_nap,wsv_lap" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE dbo.Acc_Dep_CustSetting_ChargeCommCheck 
	  @CustID			INT
	, @ProductID		TINYINT
	, @Discount			VARCHAR(MAX)
	, @SettingStatus	TINYINT = 0
	, @ErrCode			INT				= 0		OUTPUT
	, @ErrMsg			NVARCHAR(MAX)	= ''	OUTPUT

AS
/*
	Created: 20240429@Tacy
	Task: Check Customer's comm
	DB: DBCUST/CustDB

	Revision:
		- 20240429@Tacy: Licensee DCS Setting - Integrate Exchange [RedmineID: #201239]

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

	DECLARE @NewDiscountTbl TABLE (
		  SportType	SMALLINT
		, BetType	SMALLINT
		, Discount	DECIMAL(9, 8)
		)

	DECLARE @xml		XML

	SELECT	@ErrCode	= 0
		,	@ErrMsg		= ''

	DECLARE @iDoc INT

	EXEC sp_xml_preparedocument @iDoc OUTPUT
					, @Discount

	INSERT @NewDiscountTbl
	SELECT SportType
		, BetType
		, CAST(Discount AS DECIMAL(9,8)) AS Discount
	FROM OPENXML(@iDoc, '/ROOT/Discount', 1) WITH (
				SportType	SMALLINT
				, BetType	SMALLINT
				, Discount	VARCHAR(15)
			)

	EXEC sp_xml_removedocument @iDoc

	CREATE TABLE #SportBettypeFilter (
			ProductID			INT
			,SportType			INT
			,Bettype			INT
			,MinDefaultValue	DECIMAL(19,8)
			,MaxDefaultValue	DECIMAL(19,8))

	INSERT INTO #SportBettypeFilter (ProductID, SportType, Bettype,  MinDefaultValue, MaxDefaultValue)
	SELECT ft.ProductID, ft.SportType, ft.Bettype, ft.MinDefaultValue, ft.MaxDefaultValue
	FROM dbo.f_Dep_CustSetting_SportBetTypeSettingSelect(@ProductID,5,@SettingStatus) ft

	IF NOT EXISTS (SELECT 1 FROM #SportBettypeFilter ft
					INNER JOIN @NewDiscountTbl t ON t.SportType=ft.SportType AND t.BetType=ft.Bettype)
	BEGIN
		SELECT @ErrCode=99
			, @ErrMsg='This setting does not exist.'

		RETURN
	END

	IF EXISTS (SELECT 1 FROM #SportBettypeFilter ft
					INNER JOIN @NewDiscountTbl t ON t.SportType=ft.SportType AND t.BetType=ft.Bettype
					WHERE t.Discount NOT BETWEEN MinDefaultValue AND MaxDefaultValue)
	BEGIN
		SELECT @ErrCode=100
			, @ErrMsg='Invalid charge commission rate.'

		RETURN
	END
END
GO