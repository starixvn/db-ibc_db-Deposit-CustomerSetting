/*<info serverAlias="DBCUST-CUSTDB,DBACC-bodb02" selecters="wsv_nap,wsv_lap,vnteam" isFunction="1" isNested="1"></info>*/
ALTER FUNCTION [dbo].[f_Dep_DummyMember_Select]
	(@srecommend	INT)
RETURNS TABLE
AS
/*
	Created: 20240912@Tacy
	Task : Get dummy member
	DB: DBCUST-CUSTDB,DBACC-bodb02,DBCHECK-CheckResultDB
	Original:

	Revisions:
		- 20240912@Tacy: Initial SP [RedmineID: #210613]

	Param's Explanation::		
*/	
RETURN
	SELECT custid, username, recommend
	FROM Customer WITH(NOLOCK)
	WHERE srecommend=@srecommend
	AND roleid=1
	AND (username LIKE '%Bettrade%' 
		OR username LIKE '%CashOut%' 
		OR username LIKE '%ClearBal%' 
		OR username LIKE '%OddsAdj%'
		OR username LIKE '%OddsBoostAdj%'
		)