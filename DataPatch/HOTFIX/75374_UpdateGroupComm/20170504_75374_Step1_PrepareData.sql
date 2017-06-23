/*
	Created: 20170504@Elodie
	Task: Update SB Comm for MacauBet
	DB: DBCUST/CustDB
*/
USE CustDB
GO

--get list of affected Customers
SELECT CustID 
INTO dbo.CustMacauBet
FROM DBLIC.bodb_Licensee.dbo.LicenseeCustComm WITH (NOLOCK)
WHERE LicenseeID = 19 AND GroupCommID = 84  