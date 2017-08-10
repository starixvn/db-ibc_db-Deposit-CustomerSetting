/*
	Created: 20170809@Helen
	Task: Fix missing betseting for keno
	DB: DBCUST/CUSTDB
*/
USE  Custdb
GO

CREATE TABLE #member (custID INT, recommend INT)

INSERT INTO #member (CustID,recommend )
SELECT ci.custid, ci.recommend
FROM CustInfo ci WITH (NOLOCK)
WHERE ci.custid IN ('5845095','14191890','15634613','15634635','15634638','21691827')

INSERT INTO dbo.CustGameType (CustID, GameTypeID, StakeLevelList, MaxPerGameType, MinBet, MaxBet, IsDisabled)
SELECT m.CustID, GameTypeID, StakeLevelList, MaxPerGameType, MinBet, MaxBet, IsDisabled
FROM #member m WITH (NOLOCK) 
	INNER JOIN dbo.CustGameType CGT WITH (NOLOCK) ON m.recommend = CGT.CustID
WHERE CGT.GameTypeID = 1	

GO
