/*<info serverAlias="DBCUST-CUSTDB" executers="Dot_Member" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Dot_Dep_RollBackLicensee] 		
		@ListCustID		VARCHAR(MAX)		
AS

/*  
 Created: 20190425@Winnie  
 Task: Rollback Licensee
 DB: DBCUST/CustDB  
 Original:  
 Revisions:  	
	- 20190425@Winnie:  Onebook SiteBuilder RedmineID: #111321
	- 20220301@Eden: Deposit - Sportsbook - Revise customer settings [Redmine: #167898] 
	- 20230601@Eden: Remove unused tables [Redmine: #189081] 
 Param's Explanation: 
 */
BEGIN
	CREATE TABLE #tblCustomer(CustID INT,isfinished BIT DEFAULT(0))
	DECLARE @CustID INT
	INSERT INTO #tblCustomer (CustID)
	SELECT ss.value
	FROM string_split(@ListCustID, ',') AS ss
	WHERE ss.value <> ''

	DELETE d 
	FROM Dep_CustSuper d WITH(ROWLOCK) 
		INNER JOIN #tblCustomer t ON d.custid=t.CustID
		
	WHILE (1 = 1)
	BEGIN		
		UPDATE TOP (1) #tblCustomer
		SET isfinished = 1
			,@CustID=CustID
		WHERE isfinished = 0

		IF @@ROWCOUNT = 0 BREAK 		
		EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID												
	END	
	
	DELETE d 
	FROM Dep_AgentCommRate d WITH(ROWLOCK) 
		INNER JOIN #tblCustomer t ON d.custid=t.CustID
END