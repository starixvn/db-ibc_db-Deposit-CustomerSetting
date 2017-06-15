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
	
	Param's explanation:
*/
BEGIN		
	INSERT INTO dbo.Task_Cust_CheckBalance_Exception(custid, remark) values(@custid, @username)
END


GO
GRANT EXECUTE ON [dbo].[Task_Cust_CheckBalance_Exception_Ins] TO [bodbAdminNet] AS [dbo]
GO
GRANT EXECUTE ON [dbo].[Task_Cust_CheckBalance_Exception_Ins] TO [bodbDownlineNet] AS [dbo]
GO
GRANT EXECUTE ON [dbo].[Task_Cust_CheckBalance_Exception_Ins] TO [bodbExtAccNet] AS [dbo]
GO
GRANT VIEW DEFINITION ON [dbo].[Task_Cust_CheckBalance_Exception_Ins] TO [vnteam] AS [dbo]