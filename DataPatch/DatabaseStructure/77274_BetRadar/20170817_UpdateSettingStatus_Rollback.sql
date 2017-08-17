/*
	Created: 20170608@Helen
	Task: Betradar Virtual Sports  -Integration for Cash
	DB:DBCUST/CUSTDB
		
*/

USE CustDB
GO

UPDATE [Dep_ProductSettingDetail] 
	SET SettingStatus = 1 
WHERE SportType IN (180,181,182,183,184,185,186,190,191,199)

GO
