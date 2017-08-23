/*
	Created: 20170823@Helen
	Task: https://nexdev.net/issues/82010
	DB: DBCUST/CUSTDB
	
*/

USE CustDB
GO

DECLARE @Srecommend INT 
SET @Srecommend =  15970515 -- Mayfair, INH 

CREATE TABLE #Cust_SMA (CustID INT PRIMARY KEY)
CREATE TABLE #Cust_member (CustID INT PRIMARY KEY)

INSERT INTO #Cust_SMA (CustID)
SELECT CUSTID
FROM custInfo CI WITH (NOLOCK)
WHERE srecommend = @Srecommend AND roleid IN (2,3,4)

INSERT INTO #Cust_member (CustID)
SELECT CUSTID
FROM custInfo CI WITH (NOLOCK)
WHERE srecommend = @Srecommend AND roleid = 1

UPDATE CBS
	SET MinBet = 10, MaxBet = 10000, MaxPerMatch = 50000 	  	
FROM dbo.Dep_CustBetSetting_Agent cbs WITH (ROWLOCK,UPDLOCK)
	INNER JOIN #Cust_SMA sma WITH (NOLOCK) ON cbs.CustID = SMA.CustID
WHERE SportType IN (180,181,182,183,184,185,186,190,191,199)


UPDATE CBS
	SET MinBet = 10, MaxBet = 10000, MaxPerMatch = 50000 	  	
FROM dbo.Dep_CustBetSetting_Member cbs WITH (ROWLOCK,UPDLOCK)
	INNER JOIN #Cust_member member WITH (NOLOCK) ON cbs.CustID = member.CustID
WHERE SportType IN (180,181,182,183,184,185,186,190,191,199)

GO
	
	