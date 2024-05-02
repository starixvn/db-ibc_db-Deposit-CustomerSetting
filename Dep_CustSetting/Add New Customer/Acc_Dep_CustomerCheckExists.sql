/*<info serverAlias="DBCUST-CUSTDB" executers="svc_tig" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_CustomerCheckExists]
	@username	 VARCHAR(50),
	@isExists	 BIT = 0 OUTPUT
AS
/*
	Created: Elodie
	Date: 20190524
	Task: Check user name/nickname is valid or not for 1st deposit
	DB: DBCUST/CustDB
	
	Revisions:		
		- 20190524@Elodie: Initial SP [Redmine:112287]
	Parameter's Explanation:
*/	
BEGIN
	SET NOCOUNT ON
	
	IF EXISTS(SELECT 1 FROM customer WITH(NOLOCK) WHERE username = @username)
		OR EXISTS (SELECT 1 FROM customer WITH (NOLOCK) WHERE username2 = @username)
		OR EXISTS(SELECT 1 FROM custsub WITH (NOLOCK) WHERE username = @username)
		OR EXISTS(SELECT 1 FROM custsub WITH (NOLOCK) WHERE username2 = @username)
		OR EXISTS(SELECT 1 FROM Dep_Customer_Archived WITH (NOLOCK) WHERE username= @username)
		OR EXISTS (SELECT 1 FROM Dep_Customer_Archived WITH (NOLOCK) WHERE username2 = @username)
			SELECT @isExists = 1
	ELSE 
			SELECT @isExists = 0
END
GO
 