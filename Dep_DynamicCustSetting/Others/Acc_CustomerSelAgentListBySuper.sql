/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet,bodbExtAccNet,bodbDownlineNet,wsv_lap" viewers="" isFunction="0"></info>*/

ALTER PROCEDURE [dbo].[Acc_CustomerSelAgentListBySuper]
	@SRecommend VARCHAR(MAX) = ''
AS
/*
	Created: 
	Date: 
	Task: 
	DB: DBCUST.CustDB	
	Revisions:
		- 20180718@Winnie: Get agentlist by super
		- 20220713@Winfred: NAP/NAP LM - Enhance to adjust PT for all currencies [RedmineID:#174815]
	Parameter's Explanation:
	@SRecommend : List srecommend
*/
--Original: sp CustomerSelAgentList

BEGIN
	SET NOCOUNT ON
	CREATE TABLE #Super (CustID INT PRIMARY KEY)
	CREATE TABLE #tblmrecommend  (CustID INT PRIMARY KEY)
		
	INSERT INTO #Super(CustID)
	SELECT ss.value	FROM STRING_SPLIT(@SRecommend, ',') AS ss	WHERE value <> ''

	INSERT INTO #tblmrecommend(CustID)
	SELECT c.custid 
	FROM custinfo c WITH (NOLOCK) 
	INNER JOIN #Super s ON c.srecommend = s.CustID
	WHERE roleid=3 and (username LIKE '%Acc%' OR username LIKE '%LocalBank%' 
						OR username LIKE '%AFF%' OR username LIKE 'AB88'+'CAS%')		

	SELECT username, c.CustID, c.srecommend, CASE WHEN s.AgentID IS NOT NULL THEN 1 ELSE 0 END AS IsSub
	FROM customer c WITH (NOLOCK) 
		INNER JOIN #Super su ON c.srecommend = su.CustID
		LEFT JOIN [SiteConfig].[dbo].[Operator] s WITH(NOLOCK) ON c.Custid=s.AgentID
	WHERE roleid = 2 AND mrecommend NOT IN (SELECT CustID FROM #tblmrecommend)
	ORDER BY c.srecommend,username
END
GO
