/*
	Created: 20170608@Helen
	Task: Betradar Virtual Sports  -Integration for Cash
	DB:DBCUST/CUSTDB
		
*/

USE CustDB
GO

UPDATE [Dep_ProductSettingDetail] 
	SET SettingStatus = 0 
WHERE SportType = 220

GO

 


