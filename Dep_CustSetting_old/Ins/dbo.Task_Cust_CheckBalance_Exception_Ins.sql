 /*<info serverAlias="DBTXN-bodb02" executers="asv_cust,wsv_nap" viewers="" isFunction="0"></info>*/
 ALTER PROCEDURE [dbo].[Task_Cust_CheckBalance_Exception_Ins] 
	@custid		INT,
	@username	VARCHAR(30)
AS
/*
	Created: 20131108@Elodie
	Task: Exclude created member from Balance checking
	DB: DBTXN/bodb02
	Original:
	
	Revisions:
		- 20240705@Eden  : Scale out DBCUST - Licensee Customer in GlobCustDB [redmine: #207474]
	
	Param's explanation:
*/
BEGIN		
	INSERT INTO dbo.Task_Cust_CheckBalance_Exception(custid, remark) values(@custid, @username)
END
GO
