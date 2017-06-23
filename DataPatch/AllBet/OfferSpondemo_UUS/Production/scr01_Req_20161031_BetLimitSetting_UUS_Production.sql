/********This is SIT environment*******/
/*
	Created by: Helen
	Created Date:  20161031
	Task: Set up Bet Limit Setting for testing Allbet on Spondemo Licensee - https://nexdev.net/issues/66409
	DB: DBCUST/CUSTDB
	
	/* Allbet betlimit for uus
		- Normal : 300 - 30000
		- VIP handicap : 10000-500000
		SELECT * FROM Dep_StakeLevel (nolock) where ExchangeID = 20 and GameTypeID in (2401,2402) 
	*/
	
*/

/* ------Production --------------- */
USE CustDB

GO

UPDATE Dep_StakeLevel 
	set MinLabel = '300', MaxLabel ='30,000', MinStake = 300, MaxStake = 30000
WHERE StakeLevelID = 209 AND GameTypeID = 2401 AND ExchangeID = 20	

GO
UPDATE Dep_StakeLevel 
	SET MinLabel = '10,000', MaxLabel ='500,000', MinStake = 10000, MaxStake = 500000
WHERE StakeLevelID = 235 AND GameTypeID = 2402 AND ExchangeID = 20	

