/*
	Task: Create new tables for Depsoit Customer Archive
			1.DBALog_Archive_Dep_Cust_Process
	Database: DBLOG.bodb_CustomerLog
*/

USE bodb_CustomerLog

--1.DBALog_Archive_Dep_Cust_Process
	CREATE TABLE DBALog_Archive_Dep_Cust_Process (
		LogId [int] IDENTITY(1,1)
		,CustID INT
		,Action VARCHAR(100)
		,Status VARCHAR(100)
		,Message VARCHAR(1000)
		,LogTime DATETIME
	) ON DBALog_Archive_Dep_Cust
	WITH (DATA_COMPRESSION = PAGE) ;


	CREATE CLUSTERED INDEX CIX_LogTime ON DBALog_Archive_Dep_Cust_Process(LogTime) WITH (DATA_COMPRESSION = PAGE) ON DBALog_Archive_Dep_Cust


	