/*
	Task: Insert ActionID For The Reactivation Process
	Creator: Kean
	Run at: DBLOG.bodb_CustomerLog

*/

USE [bodb_CustomerLog]
GO

INSERT INTO [dbo].[LogAction]
           ([ActionID]
           ,[ActionTypeID]
           ,[SPName]
           ,[ActionNameEN]
           ,[ActionNameCH]
           ,[ActionNameCS]
           ,[ActionNameJP]
           ,[ActionNameIT]
           ,[ActionNameTH]
           ,[ActionNameKO]
           ,[XsltContent]
           ,[IsInternal]
           ,[ActionNameVI])
     VALUES
           (1505
           ,NULL
           ,'Dot_Dep_Customer_Archive_ReactiveCustomer'
           ,'Reactive archive account by IT Admin'
		   ,'Reactive archive account by IT Admin'
           ,'Reactive archive account by IT Admin'
           ,'Reactive archive account by IT Admin'
           ,'Reactive archive account by IT Admin'
           ,'Reactive archive account by IT Admin'
           ,'Reactive archive account by IT Admin'
           ,NULL
           ,1
           ,'Reactive archive account by IT Admin')