/*
	Created: 20160405@Helen
	Task: DCS Deposit
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
	(1,22,4,0,1,1)
	-- PT
	,(2,22,1,0,2,1)
	-- Stakelevel group
	,(3,22,8,0,3,2)
GO
INSERT INTO [dbo].[Dep_ProductSettingDetail] (ProductSettingID,SportType,BetType,IsLive,MaxDefaultValue,SettingStatus)
VALUES 
	(1,212,4001,0,0,1)
	,(2,212,4001,0,0,1)
	,(3,212,4001,0,0,1)
GO

INSERT INTO [dbo].Dep_ProductStatusProfile (Sporttype,Bettype,bitmapOrder)
VALUES (212,4001,1)

GO
