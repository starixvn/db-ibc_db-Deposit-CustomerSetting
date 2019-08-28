/*
	Task: Insert Deposit Archive Configurations
	Creator: Dominic
	Run at: DBCUST.CustDB

*/
USE [CustDB]

--Comma separated string of licensee,e.g, 'KaiHao,12bet,W88'
DECLARE @_LicenseeLst VARCHAR(4000)='Wuming,10bet,99UU,Longbao,BuyWin,Star99,LZYQ,TCL,Aragon88,May88,Kasking88,ABB688,Leon,Indowin,GDC,Emmyo,CQ11,Platinum,KING10,21CASH,LEXIBET,I668Bet/I228Bet,BWINNING,YHY1980,ALLBETCLUB,Goobet(Devabet),Bet2Day,HBObet,MGM88,THBET,28Bet,WINNER99,67BET,RYB95,Doctorgame,DUOLE,ASIANBET,VCBET,DAYWIN,Kaihao,SHABAING,Tycoon,DELA,SLC88,INBET,EMPIRE555,BAOBET,TOOBET,Happy8,Kashbet (K8),SALONCS,666VIP,MARVELDH,VGS,WM8888,Holey,AK318'
DECLARE @_DefaultMinBalance MONEY = 0.01
DECLARE @_DefaultMinDays SMALLINT = 365
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



