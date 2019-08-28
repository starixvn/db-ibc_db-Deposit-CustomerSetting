/*
	Task: Insert Deposit Archive Configurations for Tycoon, DELA - Feature #104958
	Creator: Dominic
	Run at: DBCUST.CustDB

*/
USE [CustDB]

--Comma separated string of licensee,e.g, 'KaiHao,12bet,W88'
DECLARE @_LicenseeLst VARCHAR(4000)='Tycoon,DELA'
DECLARE @_DefaultMinBalance MONEY = 100000000
DECLARE @_DefaultMinDays SMALLINT = 1
DECLARE @_DefaultConfigStatus TINYINT = 0

CREATE TABLE #LicenseeLst (LicenseeName NVARCHAR(50)
							,RegisteredLicenseeName NVARCHAR(50)
							)
CREATE UNIQUE CLUSTERED INDEX IX_LicenseeName ON #LicenseeLst(LicenseeName)

DECLARE @XML XML
SET @XML = N'<root><r>' + REPLACE(@_LicenseeLst, ',', '</r><r>') + '</r></root>'

INSERT INTO #LicenseeLst(LicenseeName) 
SELECT r.value('.','NVARCHAR(50)')
FROM @xml.nodes('//root/r') AS RECORDS(r)

UPDATE main
SET main.RegisteredLicenseeName = l.RegisteredLicenseeName
FROM #LicenseeLst main
INNER JOIN DB052.bodb_OIC.dbo.licensee l ON l.LicenseeName=main.LicenseeName

IF EXISTS(SELECT 1 FROM #LicenseeLst WHERE RegisteredLicenseeName IS NULL)
BEGIN
	RAISERROR('There are licensees with unidentified registered name.', 11, 1)
	
	RETURN
END

INSERT INTO Dep_Customer_Archived_Config
           ([Recommend]
           ,[Site]
           ,[MinBalance]
           ,[MinDays]
           ,[CustIDBalanceDummy]
           ,[Status])
SELECT ag.custid [Recommend]
, ds.site [Site]
, @_DefaultMinBalance [MinBalance]
, @_DefaultMinDays [MinDays]
, dum.custid [CustIDBalanceDummy]
, @_DefaultConfigStatus [Status]
FROM Customer ag(NOLOCK)
INNER JOIN Dep_CustSuper ds (NOLOCK) ON ag.srecommend = ds.custid
INNER JOIN Customer dum (NOLOCK) ON dum.recommend = ag.custid AND dum.roleid = 1 AND dum.username LIKE '%ClearBal'
WHERE ag.roleid=2 
AND ds.site IN (SELECT RegisteredLicenseeName FROM #LicenseeLst)
AND ag.custid NOT IN (SELECT recommend FROM Dep_Customer_Archived_Config)

DROP TABLE #LicenseeLst



