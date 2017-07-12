/*
	Created: 20170608@Helen
	Task: Keno Lottery -Integration for Cash
	DB:DBCUST/CUSTDB
		
*/
USE CustDB
GO
DELETE Dep_ProductSetting WHERE ProductID IN (28)
GO
DELETE Dep_ProductSettingDetail WHERE SportType IN (220)
GO
DELETE Dep_ProductStatusProfile WHERE Sporttype IN (220)
GO
INSERT INTO [dbo].[Dep_ProductSetting] (ProductSettingID,ProductID,SettingType,TemplateID,DisplayOrder,SettingLevel)
VALUES 
	-- Virtual Sports
	--Status
	(15,28,4,0,1,1)
	-- PT
	,(16,28,1,0,2,2)
	-- 2: Bet Setting
	,(17,28,2,0,3,2)

GO
INSERT INTO [dbo].[Dep_ProductSettingDetail] (ProductSettingID,SportType,BetType,IsLive,MaxDefaultValue,SettingStatus)
VALUES 
	-- Keno Lottery
	(15,220,1021,0,0,1)
	-- PT
	,(16,220,1021,0,0,1)
	-- Bet Setting
	,(17,220,1021,0,0,1)
	
GO

INSERT INTO [dbo].Dep_ProductStatusProfile (Sporttype,Bettype,bitmapOrder)
VALUES (220,1021,6) -- Keno Lotery
		
GO



