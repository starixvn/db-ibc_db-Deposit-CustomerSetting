/*<info serverAlias="DBCUST-CUSTDB" executers="Dot_Member" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Dot_Dep_LicenseeProductOffer] 
	 @ProductID	SMALLINT = 0,
	 @ErrCode	INT = 0 OUTPUT,
	 @ErrMsg	VARCHAR(8000) = '' OUTPUT
AS  
/*  
 Created: 20220228@Winfred  
 Task: SP to provide currency list offered for some products
 DB: DBCUST/CustDB  
 Original:  
 Revisions:  	
	- 20220228@Winfred: SP to provide currency list offered for some products [RedmineID:#169114]
	
 Param's Explanation: 
	@ProductID : 0 ALL , <> 0 : Only Product
 Sample exec:
	EXEC Dot_Dep_LicenseeProductOffer @ProductID = 0
*/  
BEGIN
	SET NOCOUNT ON
	CREATE TABLE #result (Productid INT,ExchangeId	INT,Currency NVARCHAR(50))
	
	INSERT INTO #result(Productid,  ExchangeId, currency)
	SELECT DISTINCT a.ProductID, sl.ExchangeID, e.currency 
	FROM Dep_ProductSetting a WITH(NOLOCK)
		INNER JOIN Dep_ProductSettingDetail psd WITH(NOLOCK) ON a.ProductSettingID = psd.ProductSettingID
		INNER JOIN DEP_StakeLevel sl WITH(NOLOCK)  ON sl.GameTypeID = psd.BetType
		INNER JOIN exchange e WITH(NOLOCK) ON sl.ExchangeID = e.ExchangeId
	WHERE a.SettingType = 8	AND psd.SettingStatus = 0 AND (@ProductID = 0 OR a.ProductID = @ProductID)
	     
    SELECT  Productid, ExchangeId, Currency
    FROM #result 
    ORDER BY Productid , ExchangeId
     
	DROP TABLE 	#result
END 
