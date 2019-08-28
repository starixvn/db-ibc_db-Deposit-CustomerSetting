/*
	Task: Insert test data into Dep_Customer_Archived
	Creator: Dominic
	Run at: DBCUST@CustDB
*/
USE [CustDB]
GO

INSERT INTO [dbo].[Dep_Customer_Archived]
           ([CustID]
           ,[ArchivedDate]
           ,[Username]
           ,[Username2]
           ,[Recommend]
           ,[ClosingBalance]
           ,[CustIDBalanceDummy]
           ,[Status])
VALUES
(50000000
,GETDATE()
,'KaiHaoRMB011973'
,'KaiHao$khlong169'
,15582199
,0
,0
,'waiting'),

(50000001
,GETDATE()
,'KaiHaoRMB011974'
,'KaiHao$khlong170'
,15582199
,0
,0
,'waiting'),

(50000002
,GETDATE()
,'KaiHaoRMB011975'
,'KaiHao$khlong171'
,15582199
,0
,0
,'waiting')



