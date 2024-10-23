/*<info serverAlias="DBCUST-CustDB" executers="asv_cust,wsv_nap" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_GetPlayerCommProducts](
	@Comm_Products VARCHAR(MAX) = '' OUTPUT --Json format
)
AS
/*
	Created: 20240705@Eden  
	Task : First Deposit --> Validate data before insert new customer
	DB:  DBCUST-CustDB
	Original sp: 
	
	Revisions: 
		- 20240705@Eden  : Scale out DBCUST - Licensee Customer in GlobCustDB [redmine: #207474]

	Param's Explanation: 
		DECLARE @Comm_Products VARCHAR(MAX)
		EXEC [Acc_Dep_GetPlayerCommProducts] @Comm_Products = @Comm_Products OUT

		SELECT ProductID, SportType, BetType 
		FROM OPENJSON(@Comm_Products) WITH (
				 ProductID SMALLINT  '$.ProductID' 
				,SportType SMALLINT  '$.SportType'
				,BetType SMALLINT  '$.BetType'
				)

		SELECT @Comm_Products

*/			   				
BEGIN
	SET NOCOUNT ON

	SELECT @Comm_Products =
			(
				SELECT ProductID, SportType, BetType 
				FROM dbo.Dep_ProductSetting d WITH(NOLOCK)  
					INNER JOIN dbo.Dep_ProductSettingDetail dp WITH(NOLOCK)   
					ON d.ProductSettingID = dp.ProductSettingID  
				WHERE SettingType = 9   
				FOR JSON PATH
			)
END	