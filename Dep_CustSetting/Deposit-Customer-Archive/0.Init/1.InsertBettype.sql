/*
	Task: Insert new bettype 23203 to clear balance
	Server: DBTRANS
	Database: bodb02
*/

USE [bodb02]


INSERT INTO [dbo].[bettype]
           ([typeid]
           ,[typenamee]
           ,[typenamec]
           ,[typedesc]        
           ,[typenamec_uni]
           ,[ParentTypeid])
     VALUES
           (23203
           ,'DTRAARC'
           ,'DTRAARC'
           ,'Transfer for deposit site when archiving and reactivating dormant members'
           ,'DTRAARC'
		   ,23203)
GO


