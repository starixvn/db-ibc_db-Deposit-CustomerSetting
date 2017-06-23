/*
	Created: 20160801@Helen
	Task: DCS Deposit for Fishing World - [Redmine:67633]
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
	(7,24,4,0,1,1)
	-- PT
	,(8,24,1,0,2,1)
	-- Stakelevel group
	--,(6,21,7,0,3,3)
GO
INSERT INTO [dbo].[Dep_ProductSettingDetail] (ProductSettingID,SportType,BetType,IsLive,MaxDefaultValue,SettingStatus)
VALUES 
	(7,219,1011,0,0,1)
	,(8,219,1011,0,0,1)
	
GO

INSERT INTO [dbo].Dep_ProductStatusProfile (Sporttype,Bettype,bitmapOrder)
VALUES (219,1011,3)

GO




