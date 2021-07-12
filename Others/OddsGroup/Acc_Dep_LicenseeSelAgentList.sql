/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet" viewers="" isFunction="0"></info>*/

ALTER PROCEDURE [dbo].[Acc_Dep_LicenseeSelAgentList]
	@SRecommend INT
AS
/*
	Created: 20210708@Johnson
	Task: Get list agent belong to super to update odds group 
	DB: DBCUST.CustDB	
	Revisions:
		- 20210708@Johnson: initial sp [redmine:#157702]
	Parameter's Explanation:
*/

BEGIN
	SET NOCOUNT ON

	CREATE TABLE #tblmrecommend  (CustID INT PRIMARY KEY)
		
	INSERT INTO #tblmrecommend(CustID)
	SELECT custid FROM custinfo WITH (NOLOCK) WHERE roleid=3
	and username LIKE '%Acc%' and srecommend=@SRecommend		

	SELECT username + CASE WHEN NULLIF(s.OperatorID,'') IS NOT NULL THEN '('+s.OperatorID+')'
							WHEN s.OperatorID= '' THEN '(Sub)'
							ELSE '' END as username
		, CustID
	FROM customer c WITH (NOLOCK)
		LEFT JOIN [SiteConfig].[dbo].[Operator] s WITH(NOLOCK) ON c.Custid=s.AgentID
	WHERE roleid = 2 and Srecommend = @SRecommend AND mrecommend NOT IN (SELECT CustID FROM #tblmrecommend)
	ORDER BY username
END
GO
