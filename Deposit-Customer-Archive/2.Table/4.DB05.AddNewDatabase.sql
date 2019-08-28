/*
	Task: Create a new database Bodb_Archive_Customer_Licensee for Depsoit Customer Archive
	Server: DB052
	Database: DBLOG.Bodb_Archive_Customer_Licensee
	Data File Folder: I:\User_DB\Bodb_Archive_Customer_Licensee\
*/

CREATE DATABASE Bodb_Archive_Customer_Licensee 
ON  PRIMARY 
( NAME = N'Bodb_Archive_Customer_Licensee', FILENAME = N'I:\User_DB\bodb_Customer\Bodb_Archive_Customer_Licensee.mdf' 
	, SIZE = 100MB 
	, MAXSIZE = UNLIMITED
	, FILEGROWTH = 25MB 
) 
LOG ON 
( NAME = N'Bodb_Archive_Customer_Licensee_Log', FILENAME = N'I:\User_DB\bodb_Customer\Bodb_Archive_Customer_Licensee.ldf' 
	, SIZE = 100MB 
	, MAXSIZE = 4GB 
	, FILEGROWTH = 10%)