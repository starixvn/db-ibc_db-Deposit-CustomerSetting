/*
	Created: 20160801@Helen
	Task: DCS Deposit - Update setting Status when release to Production
			
	DB: Run at DBCust.CustDB
*/  
USE [CustDB]
GO
UPDATE PSD
	 SET SettingStatus = 0  
FROM [Dep_ProductSettingDetail] PSD
	INNER JOIN [Dep_ProductSetting] PS WITH (NOLOCK) ON PSD.ProductSettingID = PS.ProductSettingID
WHERE PS.ProductID = 21

