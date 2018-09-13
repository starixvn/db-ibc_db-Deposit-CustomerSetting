/*<info serverAlias="DBCUST-CUSTDB" executers="Dot_Member" executers="vnteam" isFunction="0"></info>*/
CREATE PROCEDURE [dbo].[Licensee_GetDummy]
	(
      @Site NVARCHAR(100) = NULL,
      @Currency INT = 0
	)
AS

/*
	Created by: 20180905@Chris
	Task : Return Licensee Dummy Agent List [Redmine: #100997]
	DB: DBCUST.CustDB
	Original: 
	Revisions:	
		--20180913@Chris: Add permission
	Param's Explanation:  
	  + @Site		: licensee site name  
	  +	@Currency	:
			0  : selected all currencies 
*/

BEGIN
	SET NOCOUNT ON  
	
	SELECT custid
	INTO #supers
	FROM Dep_CustSuper WITH (NOLOCK)
	WHERE site in (@Site)
	AND (@Currency = 0 OR (@Currency <> 0 AND Currency = @Currency))

	SELECT c.currency, c.custid, c.username
	FROM Customer c WITH (NOLOCK)
	INNER JOIN #supers s WITH (NOLOCK) ON s.custid = c.srecommend
	WHERE c.roleid = 1
	AND mrecommend IN (SELECT custid FROM dbo.Customer WITH(NOLOCK)
							   WHERE srecommend in (select custid from #supers) and username like '%Acc%' and roleid=3)
	ORDER BY c.currency, c.custid
	
	DROP TABLE #supers
END