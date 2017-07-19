/*
	Created: 20170608@Helen
	Task: Betradar Virtual Sports  -Integration for Cash
	DB:DBCUST/CUSTDB
		
*/

USE CustDB
GO
DELETE Dep_ProductSetting WHERE ProductID IN (5,27)
GO
DELETE Dep_ProductSettingDetail WHERE SportType IN (180,181,182,183,184,185,186,190,191,199)
GO
DELETE Dep_ProductStatusProfile WHERE Sporttype IN (180,190)
GO
INSERT INTO [dbo].[Dep_ProductSetting] (ProductSettingID,ProductID,SettingType,TemplateID,DisplayOrder,SettingLevel)
VALUES 
	-- Virtual Sports
	--Status
	(9,5,4,0,1,1)
	-- PT
	,(10,5,1,0,2,2)
	-- 2: Bet Setting
	,(11,5,2,0,3,2)
	
	-- BetRadar VS
	--Status: Use VS
	-- PT
	,(12,27,1,0,1,2)
	-- 2: Bet Setting
	,(13,27,2,0,2,2)
	-- 4: Status
	,(14,27,4,0,3,1)
GO
INSERT INTO [dbo].[Dep_ProductSettingDetail] (ProductSettingID,SportType,BetType,IsLive,MaxDefaultValue,SettingStatus)
VALUES 
	-- Virtual Sports
	(9,180,1201,0,0,1)
	-- PT
	,(10,180,1201,0,0,1)
	
	-- Bet Setting
	
	,(11,180,1201,0,0,1)
	,(11,181,1231,0,0,1)
	,(11,182,1231,0,0,1)
	,(11,183,1231,0,0,1)
	,(11,184,1231,0,0,1)
	,(11,185,1231,0,0,1)
	,(11,186,1220,0,0,1)
	
	-- Betradar VS
	-- Virtual Sports
	-- Status
	--,(12,190,2701,0,0,1)
	-- PT	
	,(12,190,2701,0,0,1)
	,(12,191,2701,0,0,1)
	
	-- Bet Setting
	,(13,190,2701,0,0,1)
	,(13,191,2701,0,0,1)
	,(13,199,2799,0,0,1) -- 199 Virtual Sports Parlay dummy sport for bet setting
	
	,(14,190,2701,0,0,1)
GO

INSERT INTO [dbo].Dep_ProductStatusProfile (Sporttype,Bettype,bitmapOrder)
VALUES (180,1201,4) -- Virtual Sports
		,(190,2701,5) -- Betradar VS
GO



