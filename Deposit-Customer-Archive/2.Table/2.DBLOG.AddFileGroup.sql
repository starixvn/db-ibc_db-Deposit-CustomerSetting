/*
	Task: Create new file groups for Depsoit Customer Archive
	Server: DB052
	Database: bodb_CustomerLog
	Data File Folder: M:\IBC_DB\DBALog_Archive_Dep_Cust\
*/

USE bodb_CustomerLog

ALTER DATABASE bodb_CustomerLog
ADD FILEGROUP DBALog_Archive_Dep_Cust;
GO

ALTER DATABASE bodb_CustomerLog 
ADD FILE 
(
    NAME = DBALog_Archive_Dep_Cust_Table_01,
    FILENAME = 'M:\IBC_DB\DBALog_Archive_Dep_Cust\DBALog_Archive_Dep_Cust_Table_01.ndf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 25MB
)
TO FILEGROUP DBALog_Archive_Dep_Cust;
GO
	
ALTER DATABASE bodb_CustomerLog 
ADD FILE 
(
    NAME = DBALog_Archive_Dep_Cust_Table_02,
    FILENAME = 'M:\IBC_DB\DBALog_Archive_Dep_Cust\DBALog_Archive_Dep_Cust_Table_02.ndf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 25MB
)
TO FILEGROUP DBALog_Archive_Dep_Cust;
GO