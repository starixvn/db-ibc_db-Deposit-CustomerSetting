/*<info serverAlias="DBTXN-bodb02" executers="asv_cust" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[API_SiteBuilder_InsertBalance_Exception]
	@InsBalExceptCustList VARCHAR(MAX)
AS
/*
	Created: 20240705@Eden  
	Task : SiteBuider --> Insert data to Task_Cust_CheckBalance_Exception
	DB:  DBTXN-bodb02
	Original sp: 
	
	Revisions: 
		- 20240705@Eden  : Scale out DBCUST - Licensee Customer in GlobCustDB [redmine: #207474]

	Param's Explanation: 
	Sample Format:
		EXEC [API_SiteBuilder_InsertBalance_Exception]
			@InsBalExceptCustList = '[ {"CustID":148596502,"username":"Edentest1SuperGBP"}
									,{"CustID":148596503,"username":"Edentest1GBP"}]'
		
*/			   					
BEGIN
	SET NOCOUNT ON

	INSERT INTO dbo.Task_Cust_CheckBalance_Exception(custid, remark) 
	SELECT t.CustID,t.username
	FROM OPENJSON(@InsBalExceptCustList) 
	WITH (CustID INT '$.CustID', username VARCHAR(30) '$.username') as t
	WHERE NOT EXISTS( SELECT 1 FROM Task_Cust_CheckBalance_Exception WITH(NOLOCK) WHERE custid = t.CustID)
END	
GO
