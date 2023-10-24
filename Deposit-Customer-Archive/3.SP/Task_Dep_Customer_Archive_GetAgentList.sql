/*<info serverAlias="DBCUST-CustDB" executers="" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [Task_Dep_Customer_Archive_GetAgentList]
AS
/*
	Created: 20230612@Eden
	Task: Get list Agent to scan Dormant list
	DB: DBCUST/CustDB
	Original: Task_Dep_Customer_Archive_GetDormantCustomer

	Revisions:
		- 20230612@Eden: First commit [#179092]

	Param's Explanation:
*/
BEGIN
	SET NOCOUNT ON

	SELECT cf.Site, cf.Recommend, cf.MinBalance, cf.MinDays, cf.CustIDBalanceDummy, s.SiteDBGroupID
	FROM dbo.Dep_Customer_Archived_Config cf WITH (NOLOCK)
		INNER JOIN site s WITH(NOLOCK) 
			ON cf.site = s.site
	WHERE Status = 0
END