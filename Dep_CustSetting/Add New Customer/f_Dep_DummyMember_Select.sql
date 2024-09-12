/*<info serverAlias="DBCUST-CUSTDB,DBACC-bodb02,DBCHECK-CheckResultDB" isFunction="1" isNested="1"></info>*/
CREATE FUNCTION [dbo].[f_Dep_DummyMember_Select]
		(@srecommend INT)
RETURNS @DummyMember TABLE   -- Table definition for result
   (
      custid INT, 
	  username VARCHAR(30), 
	  recommend INT
   )
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
BEGIN
	IF DB_NAME() = 'CheckResultDB'
	BEGIN
		INSERT INTO @DummyMember(custid, username, recommend)
		SELECT custid, username, recommend
		FROM CheckCustDB.dbo.Customer WITH(NOLOCK)
		WHERE srecommend=@srecommend
		AND (username LIKE '%Bettrade%' 
			OR username LIKE '%CashOut%' 
			OR username LIKE '%ClearBal%' 
			OR username LIKE '%OddsAdj%'
			OR username LIKE '%OddsBoostAdj%'
			)
	END
	ELSE
	BEGIN
		INSERT INTO @DummyMember(custid, username, recommend)
		SELECT custid, username, recommend
		FROM Customer WITH(NOLOCK)
		WHERE srecommend=@srecommend
		AND (username LIKE '%Bettrade%' 
			OR username LIKE '%CashOut%' 
			OR username LIKE '%ClearBal%' 
			OR username LIKE '%OddsAdj%'
			OR username LIKE '%OddsBoostAdj%'
			)
	END
	
	RETURN;
END