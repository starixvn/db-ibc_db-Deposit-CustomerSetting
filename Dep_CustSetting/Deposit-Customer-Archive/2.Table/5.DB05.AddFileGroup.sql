/*
	Task: Create new file groups for Depsoit Customer Archive
	Server: DB05
	Database: Bodb_Archive_Customer_Licensee
	Data File Folder: I:\User_DB\Bodb_Archive_Customer_Licensee\
*/

USE Bodb_Archive_Customer_Licensee

/***********1. Add Customer_Table**************/
ALTER DATABASE Bodb_Archive_Customer_Licensee
ADD FILEGROUP Customer_Table;
GO

ALTER DATABASE Bodb_Archive_Customer_Licensee 
ADD FILE 
(
    NAME = Customer_Table_01,
    FILENAME = 'I:\User_DB\Bodb_Archive_Customer_Licensee\Customer_Table_01.ndf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 25MB
)
TO FILEGROUP Customer_Table;
GO
	
ALTER DATABASE Bodb_Archive_Customer_Licensee 
ADD FILE 
(
    NAME = Customer_Table_02,
    FILENAME = 'I:\User_DB\Bodb_Archive_Customer_Licensee\Customer_Table_02.ndf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 25MB
)
TO FILEGROUP Customer_Table;
GO

ALTER DATABASE Bodb_Archive_Customer_Licensee 
ADD FILE 
(
    NAME = Customer_Table_03,
    FILENAME = 'I:\User_DB\Bodb_Archive_Customer_Licensee\Customer_Table_03.ndf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 25MB
)
TO FILEGROUP Customer_Table;
GO


/***********2. Add CustVirtualSetting_Table**************/
ALTER DATABASE Bodb_Archive_Customer_Licensee
ADD FILEGROUP CustVirtualSetting_Table;
GO

ALTER DATABASE Bodb_Archive_Customer_Licensee 
ADD FILE 
(
    NAME = CustVirtualSetting_Table_01,
    FILENAME = 'I:\User_DB\Bodb_Archive_Customer_Licensee\CustVirtualSetting_Table_01.ndf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 25MB
)
TO FILEGROUP CustVirtualSetting_Table;
GO
	
ALTER DATABASE Bodb_Archive_Customer_Licensee 
ADD FILE 
(
    NAME = CustVirtualSetting_Table_02,
    FILENAME = 'I:\User_DB\Bodb_Archive_Customer_Licensee\CustVirtualSetting_Table_02.ndf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 25MB
)
TO FILEGROUP CustVirtualSetting_Table;
GO

/***********3. Add Dep_Custsetting_Table**************/
ALTER DATABASE Bodb_Archive_Customer_Licensee
ADD FILEGROUP Dep_Custsetting_Table;
GO

ALTER DATABASE Bodb_Archive_Customer_Licensee 
ADD FILE 
(
    NAME = Dep_Custsetting_Table_01,
    FILENAME = 'I:\User_DB\Bodb_Archive_Customer_Licensee\Dep_Custsetting_Table_01.ndf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 25MB
)
TO FILEGROUP Dep_Custsetting_Table;
GO
	
ALTER DATABASE Bodb_Archive_Customer_Licensee 
ADD FILE 
(
    NAME = Dep_Custsetting_Table_02,
    FILENAME = 'I:\User_DB\Bodb_Archive_Customer_Licensee\Dep_Custsetting_Table_02.ndf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 25MB
)
TO FILEGROUP Dep_Custsetting_Table;
GO

ALTER DATABASE Bodb_Archive_Customer_Licensee 
ADD FILE 
(
    NAME = Dep_Custsetting_Table_03,
    FILENAME = 'I:\User_DB\Bodb_Archive_Customer_Licensee\Dep_Custsetting_Table_03.ndf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 25MB
)
TO FILEGROUP Dep_Custsetting_Table;
GO
	
ALTER DATABASE Bodb_Archive_Customer_Licensee 
ADD FILE 
(
    NAME = Dep_Custsetting_Table_04,
    FILENAME = 'I:\User_DB\Bodb_Archive_Customer_Licensee\Dep_Custsetting_Table_04.ndf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 25MB
)
TO FILEGROUP Dep_Custsetting_Table;
GO

/***********4. Add Dep_CustBetSetting_Table**************/
ALTER DATABASE Bodb_Archive_Customer_Licensee
ADD FILEGROUP Dep_CustBetSetting_Table;
GO

ALTER DATABASE Bodb_Archive_Customer_Licensee 
ADD FILE 
(
    NAME = Dep_CustBetSetting_Table_01,
    FILENAME = 'I:\User_DB\Bodb_Archive_Customer_Licensee\Dep_CustBetSetting_Table_01.ndf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 25MB
)
TO FILEGROUP Dep_CustBetSetting_Table;
GO
	
ALTER DATABASE Bodb_Archive_Customer_Licensee 
ADD FILE 
(
    NAME = Dep_CustBetSetting_Table_02,
    FILENAME = 'I:\User_DB\Bodb_Archive_Customer_Licensee\Dep_CustBetSetting_Table_02.ndf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 25MB
)
TO FILEGROUP Dep_CustBetSetting_Table;
GO

/***********5. Add Dep_Custsetting3rd_Table**************/
ALTER DATABASE Bodb_Archive_Customer_Licensee
ADD FILEGROUP Dep_Custsetting3rd_Table;
GO

ALTER DATABASE Bodb_Archive_Customer_Licensee 
ADD FILE 
(
    NAME = Dep_Custsetting3rd_Table_01,
    FILENAME = 'I:\User_DB\Bodb_Archive_Customer_Licensee\Dep_Custsetting3rd_Table_01.ndf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 25MB
)
TO FILEGROUP Dep_Custsetting3rd_Table;
GO
	
ALTER DATABASE Bodb_Archive_Customer_Licensee 
ADD FILE 
(
    NAME = Dep_Custsetting3rd_Table_02,
    FILENAME = 'I:\User_DB\Bodb_Archive_Customer_Licensee\Dep_Custsetting3rd_Table_02.ndf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 25MB
)
TO FILEGROUP Dep_Custsetting3rd_Table;
GO

ALTER DATABASE Bodb_Archive_Customer_Licensee 
ADD FILE 
(
    NAME = Dep_Custsetting3rd_Table_03,
    FILENAME = 'I:\User_DB\Bodb_Archive_Customer_Licensee\Dep_Custsetting3rd_Table_03.ndf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 25MB
)
TO FILEGROUP Dep_Custsetting3rd_Table;
GO


/***********6. Dep_CustSettingGame_Table ***********/
ALTER DATABASE Bodb_Archive_Customer_Licensee
ADD FILEGROUP Dep_CustSettingGame_Table;
GO

ALTER DATABASE Bodb_Archive_Customer_Licensee 
ADD FILE 
(
    NAME = Dep_CustSettingGame_Table_01,
    FILENAME = 'I:\User_DB\Bodb_Archive_Customer_Licensee\Dep_CustSettingGame_Table_01.ndf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 25MB
)
TO FILEGROUP Dep_CustSettingGame_Table;
GO
	
ALTER DATABASE Bodb_Archive_Customer_Licensee 
ADD FILE 
(
    NAME = Dep_CustSettingGame_Table_02,
    FILENAME = 'I:\User_DB\Bodb_Archive_Customer_Licensee\Dep_CustSettingGame_Table_02.ndf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 25MB
)
TO FILEGROUP Dep_CustSettingGame_Table;
GO

/***********7. CustSettingGame_Table ***********/
ALTER DATABASE Bodb_Archive_Customer_Licensee
ADD FILEGROUP CustSettingGame_Table;
GO

ALTER DATABASE Bodb_Archive_Customer_Licensee 
ADD FILE 
(
    NAME = CustSettingGame_Table_01,
    FILENAME = 'I:\User_DB\Bodb_Archive_Customer_Licensee\CustSettingGame_Table_01.ndf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 25MB
)
TO FILEGROUP CustSettingGame_Table;
GO
	
ALTER DATABASE Bodb_Archive_Customer_Licensee 
ADD FILE 
(
    NAME = CustSettingGame_Table_02,
    FILENAME = 'I:\User_DB\Bodb_Archive_Customer_Licensee\CustSettingGame_Table_02.ndf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 25MB
)
TO FILEGROUP CustSettingGame_Table;
GO

/***********8. Dep_CustPTSetting_Table ***********/
ALTER DATABASE Bodb_Archive_Customer_Licensee
ADD FILEGROUP Dep_CustPTSetting_Table;
GO

ALTER DATABASE Bodb_Archive_Customer_Licensee 
ADD FILE 
(
    NAME = Dep_CustPTSetting_Table_01,
    FILENAME = 'I:\User_DB\Bodb_Archive_Customer_Licensee\Dep_CustPTSetting_Table_01.ndf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 25MB
)
TO FILEGROUP Dep_CustPTSetting_Table;
GO
	
ALTER DATABASE Bodb_Archive_Customer_Licensee 
ADD FILE 
(
    NAME = Dep_CustPTSetting_Table_02,
    FILENAME = 'I:\User_DB\Bodb_Archive_Customer_Licensee\Dep_CustPTSetting_Table_02.ndf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 25MB
)
TO FILEGROUP Dep_CustPTSetting_Table;
GO

/***********9. Dep_CustStakeLevel_Table ***********/
ALTER DATABASE Bodb_Archive_Customer_Licensee
ADD FILEGROUP Dep_CustStakeLevel_Table;
GO

ALTER DATABASE Bodb_Archive_Customer_Licensee 
ADD FILE 
(
    NAME = Dep_CustStakeLevel_Table_01,
    FILENAME = 'I:\User_DB\Bodb_Archive_Customer_Licensee\Dep_CustStakeLevel_Table_01.ndf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 25MB
)
TO FILEGROUP Dep_CustStakeLevel_Table;
GO
	
ALTER DATABASE Bodb_Archive_Customer_Licensee 
ADD FILE 
(
    NAME = Dep_CustStakeLevel_Table_02,
    FILENAME = 'I:\User_DB\Bodb_Archive_Customer_Licensee\Dep_CustStakeLevel_Table_02.ndf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 25MB
)
TO FILEGROUP Dep_CustStakeLevel_Table;
GO

/***********10. Dep_CustDiscount_Member_Table ***********/
ALTER DATABASE Bodb_Archive_Customer_Licensee
ADD FILEGROUP Dep_CustDiscount_Member_Table;
GO

ALTER DATABASE Bodb_Archive_Customer_Licensee 
ADD FILE 
(
    NAME = Dep_CustDiscount_Member_Table_01,
    FILENAME = 'I:\User_DB\Bodb_Archive_Customer_Licensee\Dep_CustDiscount_Member_Table_01.ndf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 25MB
)
TO FILEGROUP Dep_CustDiscount_Member_Table;
GO
	
ALTER DATABASE Bodb_Archive_Customer_Licensee 
ADD FILE 
(
    NAME = Dep_CustDiscount_Member_Table_02,
    FILENAME = 'I:\User_DB\Bodb_Archive_Customer_Licensee\Dep_CustDiscount_Member_Table_02.ndf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 25MB
)
TO FILEGROUP Dep_CustDiscount_Member_Table;
GO

/***********11. CustGameType_Table ***********/
ALTER DATABASE Bodb_Archive_Customer_Licensee
ADD FILEGROUP CustGameType_Table;
GO

ALTER DATABASE Bodb_Archive_Customer_Licensee 
ADD FILE 
(
    NAME = CustGameType_Table_01,
    FILENAME = 'I:\User_DB\Bodb_Archive_Customer_Licensee\CustGameType_Table_01.ndf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 25MB
)
TO FILEGROUP CustGameType_Table;
GO
	
ALTER DATABASE Bodb_Archive_Customer_Licensee 
ADD FILE 
(
    NAME = CustGameType_Table_02,
    FILENAME = 'I:\User_DB\Bodb_Archive_Customer_Licensee\CustGameType_Table_02.ndf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 25MB
)
TO FILEGROUP CustGameType_Table;
GO

/***********12. DATA ***********/
ALTER DATABASE Bodb_Archive_Customer_Licensee
ADD FILEGROUP DATA;
GO

ALTER DATABASE Bodb_Archive_Customer_Licensee 
ADD FILE 
(
    NAME = Bodb_Archive_Customer_Licensee_DATA_01,
    FILENAME = 'I:\User_DB\Bodb_Archive_Customer_Licensee\Bodb_Archive_Customer_Licensee_DATA_01.ndf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 25MB
)
TO FILEGROUP DATA;
GO
	
ALTER DATABASE Bodb_Archive_Customer_Licensee 
ADD FILE 
(
    NAME = Bodb_Archive_Customer_Licensee_DATA_02,
    FILENAME = 'I:\User_DB\Bodb_Archive_Customer_Licensee\Bodb_Archive_Customer_Licensee_DATA_02.ndf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 25MB
)
TO FILEGROUP DATA;
GO