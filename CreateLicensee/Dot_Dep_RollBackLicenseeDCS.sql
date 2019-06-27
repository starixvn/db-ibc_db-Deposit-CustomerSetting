/*<info serverAlias="DBCUST-CUSTDB" executers="Dot_Member" viewers="" isFunction="0"></info>*/
CREATE PROCEDURE [dbo].[Dot_Dep_RollBackLicenseeDCS] 
		@ListCustID		VARCHAR(MAX)
		
AS

/*  
 Created: 20190425@Winnie  
 Task: Rollback Licensee
 DB: DBCUST/CustDB  
 Original:  
 Revisions:  	
	20190425@Winnie:  Onebook SiteBuilder RedmineID: #111321
 Param's Explanation: 
 */
BEGIN
	CREATE TABLE #tblCustomer(CustID INT,isfinished BIT DEFAULT(0))	
	INSERT INTO #tblCustomer (CustID)
	SELECT ss.val
	FROM dbo.strSplit(@ListCustID, ',') AS ss;	

	DELETE d 
	FROM Dep_CustProductStatus d WITH (ROWLOCK) 
		INNER JOIN #tblCustomer t ON d.custid=t.CustID

	DELETE d
	FROM Dep_CustPTSetting_Agent d WITH (ROWLOCK) 
		INNER JOIN #tblCustomer t ON d.custid=t.CustID

	DELETE d
	FROM Dep_CustBetSetting_Agent d WITH(ROWLOCK)
		INNER JOIN #tblCustomer t ON d.custid=t.CustID	

	DELETE d
	FROM Dep_CustPTGroupSetting_Member d WITH(ROWLOCK)
		INNER JOIN #tblCustomer t ON d.AgentID=t.CustID	
END