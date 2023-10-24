/*<info serverAlias="DBCUST-CUSTDB" executers="" viewers="vnteam" isFunction="0"></info>*/
ALTER PROCEDURE [Task_Dep_Customer_Archive_GetAffAccount]
AS
/*
	Created: 20181019@Dominic
	Task: Collect aff accounts which are used for withdrawal to exclude them from Deposit Archive Process
	DB: DBCUST/CustDB

	Revisions:
		- 20181019@Dominic: First commit
		- 20190808@Dominic: Check for online DB only
		- 20230612@Eden: Enhance for Scale Out [#179092]
	Param's Explanation:
*/
BEGIN
	CREATE TABLE #CustAffMember(
			custid	int,
			Remark	varchar(500)
		)

	DECLARE @_SqlCmd NVARCHAR(4000)

	--1. Get aff accounts off Athena
	CREATE TABLE #AthenaLicenseeDB(DatabaseName VARCHAR(100), IsExec BIT DEFAULT(0))
	DECLARE @_AthenaDBName VARCHAR(100)
	DECLARE @_AthenaLicenseeID INT
	DECLARE @_AthenaLicenseeName varchar(100)
	


	INSERT INTO #AthenaLicenseeDB(DatabaseName)
	SELECT name
	FROM OPENQUERY(DBAFF --DBAFF
	,'
		SELECT name 
		FROM sys.databases 
		WHERE name like ''Affiliate_%''
		AND state_desc = ''ONLINE''
		AND name NOT LIKE ''%12BET%''
		AND name NOT IN (''Affiliate_12bet_Archive'',''AffiliateDeployment'')
	')

	WHILE(EXISTS(SELECT 1 FROM #AthenaLicenseeDB WHERE IsExec=0))
	BEGIN
		UPDATE TOP (1) #AthenaLicenseeDB
		SET IsExec=1
			,@_AthenaDBName=DatabaseName
		WHERE IsExec=0
	
		SELECT @_SqlCmd = 'SELECT @_AthenaLicenseeID=svalue 
									FROM DBAFF.'+@_AthenaDBName+'.dbo.SystemSettings 
									WHERE sname=''LicenseeID'''

		EXEC sp_executesql @_SqlCmd,N'@_AthenaLicenseeID INT OUTPUT',@_AthenaLicenseeID=@_AthenaLicenseeID OUTPUT


		SELECT @_AthenaLicenseeName = l.Licenseename 
		FROM [bodb_Licensee].[dbo].[Licensees] l (NOLOCK)
		WHERE LicenseeID=@_AthenaLicenseeID

		SELECT @_SqlCmd =' 
			;With cte(username2)
			AS
			(
				SELECT username2
				FROM OPENQUERY(DBAFF, ''SELECT '''''+@_AthenaLicenseeName+''''' + ''''$'''' + Player_Username AS username2
				FROM '+@_AthenaDBName+'.dbo.AffDetail WITH (NOLOCK)'')
			)
			INSERT INTO #CustAffMember(custid,Remark)
			SELECT custid CustID, '''+@_AthenaLicenseeName+''' + ''- aff member for withdrawal'' Remark
			FROM dbo.Customer WITH (NOLOCK)
			WHERE username2 IN (select username2 from cte)
		'

		EXEC sp_executesql @_SqlCmd,N'@_AthenaDBName VARCHAR(100),@_AthenaLicenseeName varchar(100)'
				,@_AthenaDBName=@_AthenaDBName
				,@_AthenaLicenseeName=@_AthenaLicenseeName
	END

	DROP TABLE #AthenaLicenseeDB

	--2.Get aff accounts off 12BET
	
	SELECT @_SqlCmd =' 
		;With cte(username2)
		AS
		(
			SELECT username2
			FROM OPENQUERY(DBAFF12BET, ''SELECT ''''12Bet'''' + ''''$'''' + Player_Username AS username2
			FROM Affiliate_12BET.dbo.AffDetail WITH (NOLOCK)'')
		)
		INSERT INTO #CustAffMember(custid,Remark)
		SELECT custid CustID, ''12BET'' + ''- aff member for withdrawal'' Remark
		FROM dbo.Customer WITH (NOLOCK)
		WHERE username2 IN (select username2 from cte)
	'
	EXEC sp_executesql @_SqlCmd
	--Delete existing accounts
	DELETE #CustAffMember
	WHERE CustID IN (SELECT CustID FROM Dep_Customer_Archived_Exception (NOLOCK))

	--Insert new accounts
	INSERT INTO Dep_Customer_Archived_Exception([CustID],[Remark])
	SELECT custid, MAX(Remark) AS Remark
	FROM #CustAffMember
	GROUP BY CustID

	DROP TABLE #CustAffMember

END
