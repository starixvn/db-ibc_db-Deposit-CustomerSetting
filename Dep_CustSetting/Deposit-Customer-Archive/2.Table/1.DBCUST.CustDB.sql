/*
	Task: Create new tables for Depsoit Customer Archive
			1.Dep_Customer_Archived
			2.Dep_Customer_Archived_Config
			3.Dep_Customer_Archived_Exception
	Database: DBCUST.CustDB
*/

USE CustDB

--1.Dep_Customer_Archived
	CREATE TABLE Dep_Customer_Archived (
		CustID INT NOT NULL
		,ArchivedDate DATETIME
		,Username VARCHAR(50)
		,Username2 VARCHAR(50)
		,Recommend INT
		,ClosingBalance MONEY
		,CustIDBalanceDummy INT
		,Status VARCHAR(50)
	) ON [table_customer];

	ALTER TABLE Dep_Customer_Archived 
	ADD CONSTRAINT PK_CustID PRIMARY KEY CLUSTERED (CustID) ON [table_customer]

	CREATE UNIQUE NONCLUSTERED INDEX [IX_Username] ON Dep_Customer_Archived(Username) ON [table_customer]

	CREATE NONCLUSTERED INDEX [IX_Username2] ON Dep_Customer_Archived(Username2) ON [table_customer]

--2.Dep_Customer_Archived_Config
	CREATE TABLE Dep_Customer_Archived_Config (
		Recommend INT
		,Site VARCHAR(20)
		,MinBalance Money
		,MinDays INT
		,CustIDBalanceDummy INT
		,Status TINYINT
	) ON [DATA]
	WITH (DATA_COMPRESSION = PAGE) ;


	CREATE UNIQUE CLUSTERED INDEX PK_Recommend ON Dep_Customer_Archived_Config(Recommend) WITH (DATA_COMPRESSION = PAGE) ON [DATA]

--3.Dep_Customer_Archived_Exception
	CREATE TABLE Dep_Customer_Archived_Exception (
		CustID INT
		,Remark VARCHAR(500)
	) ON [DATA]
	WITH (DATA_COMPRESSION = PAGE) ;


	CREATE UNIQUE CLUSTERED INDEX PK_CustID ON Dep_Customer_Archived_Exception(CustID) WITH (DATA_COMPRESSION = PAGE) ON [DATA]

	