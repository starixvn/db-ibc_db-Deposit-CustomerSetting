/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet" viewers="" isFunction="0"></info>*/

ALTER PROCEDURE [dbo].[Acc_Dep_LicenseeOddsGroupSelByAgent]
	@custids VARCHAR(MAX) 
AS
/*
	Created: 20210708@Johnson
	Task: Get list agent belong to super to update odds group 
	DB: DBCUST.CustDB	
	Revisions:
		- 20210708@Johnson: initial sp [redmine:#157702]
	Parameter's Explanation:
		- custids: agent list
*/

BEGIN
	SET NOCOUNT ON
	
	
	SELECT CustID
		,username 
		,CASE WHEN NULLIF(s.OperatorID,'') IS NOT NULL THEN s.OperatorID
			WHEN s.OperatorID = '' THEN '(sub)'
			WHEN s.OperatorID IS NULL THEN '-' END as OperatorID
		,d.UGroup		
		,d.IsActive
	FROM customer c WITH (NOLOCK)
		LEFT JOIN [SiteConfig].[dbo].[Operator] s WITH(NOLOCK) ON c.Custid=s.AgentID
		LEFT JOIN Dep_DefaultOddGroup d WITH(NOLOCK) ON c.custid = d.AgentID
	WHERE roleid = 2
		AND custid IN (SELECT val FROM dbo.strSplit(@custids,','))
	ORDER BY username
END