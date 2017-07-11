/*
	Created: 20170608@Helen
	Task: Keno Lottery Sports  -Integration for Cash
	DB:DBCUST/CUSTDB
		
	Data for global Product Betsetting
*/
USE CustDB
GO

INSERT INTO Dep_ProductBetSetting (Sporttype, Bettype, Currency, MinBet, MaxBet, MaxPerMatch, DefaultMinBet, DefaultMaxBet, DefaultMaxPerMatch)
VALUES (220,1031,20,1,1000,10000,1,1000,10000)
	