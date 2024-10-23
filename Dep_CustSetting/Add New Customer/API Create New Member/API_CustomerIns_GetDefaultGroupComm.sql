/*<info serverAlias="DBCUST-bodb_Licensee" executers="asv_cust" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[API_CustomerIns_GetDefaultGroupComm](
	 @Site	VARCHAR(10)
	,@Comm_Products	VARCHAR(MAX)
	,@ErrCode	INT = 0 OUTPUT
	,@ErrMsg	VARCHAR(2000) = '' OUTPUT
	,@DefaultComms  VARCHAR(MAX)  = '' OUTPUT
	,@GroupDiscountID INT  = 0 OUTPUT
)
AS
/*
	Created: 20240705@Eden  
	Task : First Deposit --> Get default licensee group comm info
	DB:  DBCUST-bodb_Licensee
	Original sp: 
	
	Revisions: 
		- 20240705@Eden  : Scale out DBCUST - Licensee Customer in GlobCustDB [redmine: #207474]

	Param's Explanation: 
		@Comm_Products  :[
							{"ProductID":3,"SportType":161,"BetType":81},
							{"ProductID":22,"SportType":212,"BetType":4001},
							{"ProductID":32,"SportType":248,"BetType":4101},
							{"ProductID":28,"SportType":220,"BetType":1021},
							{"ProductID":45,"SportType":243,"BetType":3101},
							{"ProductID":36,"SportType":247,"BetType":4301},
							{"ProductID":40,"SportType":222,"BetType":4901},
							{"ProductID":38,"SportType":245,"BetType":4601}
						] 
	Examples:
		DECLARE @Comm_Products VARCHAR(MAX) ,@ErrCode INT = 0, @ErrMsg	VARCHAR(2000) = '' ,@DefaultComms  VARCHAR(MAX)  = '', @GroupDiscountID INT = 0
		EXEC CUSTDB.dbo.[Acc_Dep_GetPlayerCommProducts] @Comm_Products = @Comm_Products OUT 

		EXEC [API_CustomerIns_GetDefaultGroupComm] 
			 @Site = 'Athena000'
			,@Comm_Products = @Comm_Products
			,@ErrCode	= @ErrCode	OUT
			,@ErrMsg	= @ErrMsg OUT
			,@DefaultComms = @DefaultComms OUT
			,@GroupDiscountID = @GroupDiscountID OUT

		SELECT @ErrCode ,@ErrMsg, @DefaultComms, @GroupDiscountID

*/			   				
BEGIN
	SET NOCOUNT ON
	DECLARE @IsUpdateNG BIT = 0,  
		@LicenseeID INT

	DECLARE @DiscountSettings VARCHAR(MAX) = ''  
	DECLARE @tblSettingDCS AS TABLE (sporttype SMALLINT,Bettype SMALLINT, Discount DECIMAL(9,8))  
	DECLARE @CommProducts TABLE ( ProductID SMALLINT,SportType SMALLINT,BetType SMALLINT )

	--Get LicenseeID  
	SELECT @LicenseeID = LicenseeID   
	FROM Licensees WITH (NOLOCK)   
	WHERE LicenseeName = @Site  

	IF ISNULL(@LicenseeID,0) = 0 -- Invalid Licensee
		RETURN

	--get licensee default group comm
	SELECT TOP 1 @GroupDiscountID=GroupDiscountID 
	FROM LicenseeGroupDiscount WITH (NOLOCK) 
	WHERE LicenseeID = @LicenseeID 
		AND IsDefault = 1 
		AND IsActive = 1

	IF ISNULL(@GroupDiscountID,0) = 0 -- Licensee does not apply default group comm
		RETURN

	IF EXISTS ( SELECT TOP 1 1 FROM LicenseeProduct3rd WITH (NOLOCK) WHERE LicenseeID = @LicenseeID AND ProductID = 2)
				SELECT @IsUpdateNG = 1

	--get Product apply Player comm
	INSERT INTO @CommProducts(ProductID, SportType, BetType)
	SELECT ProductID, SportType, BetType 
	FROM OPENJSON(@Comm_Products) WITH (
				 ProductID SMALLINT  '$.ProductID' 
				,SportType SMALLINT  '$.SportType'
				,BetType SMALLINT  '$.BetType'
			)

	INSERT INTO @tblSettingDCS (sporttype,Bettype)
	SELECT SportType,bettype		
	FROM @CommProducts d
	WHERE ProductID IN (SELECT ProductID 
						FROM LicenseeProduct3rd WITH (NOLOCK) 
						WHERE LicenseeID=@LicenseeID
							AND ProductID NOT IN (1,3) --SB,NG
						)
	UNION SELECT 161,81 WHERE @IsUpdateNG = 1
	UNION SELECT 1,	1--SB Comm
	UNION SELECT 1,	4
	UNION SELECT 1,	5			
	UNION SELECT 2,	2
	UNION SELECT 1,	9--Parlay Comm

	UPDATE t  
	SET t.Discount = ISNULL(g.Discount,0)  
	FROM LicenseeGroupDiscountDetail g WITH(NOLOCK)  
		INNER JOIN @tblSettingDCS t ON g.SportType = t.SportType  
			AND g.Bettype = t.Bettype  
	WHERE LicenseeID = @LicenseeID   
		AND GroupDiscountID = @GroupDiscountID   

	--Validate data  
	IF EXISTS (SELECT 1 FROM @tblSettingDCS WHERE Discount > 0.15)   
	BEGIN  
		SELECT @ErrCode=101  
		SELECT @ErrMsg = 'Player commission should not be greater than 0.15'  
		SET @GroupDiscountID = 0 -- reset, void insert to Licensee group comm info

		RETURN  
	END  

	SELECT @DefaultComms =
			(
				SELECT SportType,BetType,Discount
				FROM @tblSettingDCS 
				FOR JSON PATH
			)
END	