/*
	Created: 20160801@Helen
	Task: DCS Deposit for Allbet
		Insert Master Data:
			dbo.Dep_ProductSetting
			dbo.Dep_ProductSettingDetail
			dbo.Dep_ProductStatusProfile
			
	DB: Run at DBCust.CustDB
*/  
USE [CustDB]
Go
INSERT INTO [dbo].[Dep_ProductSetting] (ProductSettingID,ProductID,SettingType,TemplateID,DisplayOrder,SettingLevel)
VALUES 
	--Status
	(4,21,4,0,1,1)
	-- PT
	,(5,21,1,0,2,1)
	-- Stakelevel group
	,(6,21,7,0,3,3)
GO
INSERT INTO [dbo].[Dep_ProductSettingDetail] (ProductSettingID,SportType,BetType,IsLive,MaxDefaultValue,SettingStatus)
VALUES 
	(4,211,2401,0,0,1)
	,(5,211,2401,0,0,1)
	,(6,211,2401,0,0,1)
	,(6,211,2402,0,0,1)
GO

INSERT INTO [dbo].Dep_ProductStatusProfile (Sporttype,Bettype,bitmapOrder)
VALUES (211,2401,2)

GO




