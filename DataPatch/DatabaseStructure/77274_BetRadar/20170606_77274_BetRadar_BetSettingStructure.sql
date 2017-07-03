/*
	Created by: Helen
	Created Date: 20170606
	Description: DCS - Deposit - Bet Setting 
	Database: DBCUST/CustDB
		
*/
USE CUSTDB
GO
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='Dep_CustBetSetting_Member_table')
BEGIN
	ALTER DATABASE CUSTDB
	ADD FILEGROUP Dep_CustBetSetting_Member_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='Dep_CustBetSetting_Member_table_01')
BEGIN
	ALTER DATABASE CUSTDB 
	ADD FILE 
	(
		NAME = Dep_CustBetSetting_Member_table_01,
		-- local dev
		--FILENAME = 'E:\SQLSERVER2008R2\IBC_DB\CustDB\Dep_CustBetSetting_Member_table_01.NDF'
		--FILENAME = 'D:\IBC_DB\bodb02\Dep_CustBetSetting_Member_table_01.NDF'
		
		-- local test
		--FILENAME = 'D:\DB233\IBC_DB\CustDB\Dep_CustBetSetting_Member_table_01.NDF'
		--FILENAME = 'D:\DB234_SQLSERVER2008R2\IBC_DB\bodb02\Dep_CustBetSetting_Member_table_01.NDF'
		
		FILENAME = 'H:\USER_DB\CustDB\Dep_CustBetSetting_Member_table_01.NDF'
	)
	TO FILEGROUP Dep_CustBetSetting_Member_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='Dep_CustBetSetting_Agent_table')
BEGIN
	ALTER DATABASE CUSTDB
	ADD FILEGROUP Dep_CustBetSetting_Agent_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='Dep_CustBetSetting_Agent_table_01')
BEGIN
	ALTER DATABASE CUSTDB 
	ADD FILE 
	(
		NAME = Dep_CustBetSetting_Agent_table_01,
		
		-- local dev
		--FILENAME = 'E:\SQLSERVER2008R2\IBC_DB\CustDB\Dep_CustBetSetting_Agent_table_01.NDF'
		--FILENAME = 'D:\IBC_DB\bodb02\Dep_CustBetSetting_Agent_table_01.NDF'
		-- local test
		--FILENAME = 'D:\DB233\IBC_DB\CustDB\Dep_CustBetSetting_Agent_table_01.NDF'
		--FILENAME = 'D:\DB234_SQLSERVER2008R2\IBC_DB\bodb02\Dep_CustBetSetting_Agent_table_01.NDF'
		
		FILENAME = 'H:\USER_DB\CustDB\Dep_CustBetSetting_Agent_table_01.NDF'
	)
	TO FILEGROUP Dep_CustBetSetting_Agent_table;
END

GO
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='Dep_ProductBetSetting_table')
BEGIN
	ALTER DATABASE CUSTDB
	ADD FILEGROUP Dep_ProductBetSetting_table;
END
GO
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='Dep_ProductBetSetting_table_01')
BEGIN
	ALTER DATABASE CUSTDB 
	ADD FILE 
	(
		NAME = Dep_ProductBetSetting_table_01,
			-- local dev
		--FILENAME = 'E:\SQLSERVER2008R2\IBC_DB\CustDB\Dep_ProductBetSetting_table_01.NDF'
		--FILENAME = 'D:\IBC_DB\bodb02\Dep_ProductBetSetting_table_01.NDF'
		-- local test
		--FILENAME = 'D:\DB233\IBC_DB\CustDB\Dep_ProductBetSetting_table_01.NDF'
		--FILENAME = 'D:\DB234_SQLSERVER2008R2\IBC_DB\bodb02\Dep_ProductBetSetting_table_01.NDF'
		
		FILENAME = 'H:\USER_DB\CustDB\Dep_ProductBetSetting_table_01.NDF'
	)
	TO FILEGROUP Dep_ProductBetSetting_table;
END

GO
CREATE TABLE [dbo].[Dep_CustBetSetting_Member](
	[CustID] [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [smallint] NOT NULL,
	[MinBet] [money] NULL,
	[MaxBet] [money] NULL,
	[MaxPerMatch] [money] NULL,
 CONSTRAINT [PK_Dep_CustBetSetting_Member] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC,
	[SportType] ASC,
	[BetType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [Dep_CustBetSetting_Member_Table]
) ON [Dep_CustBetSetting_Member_Table]

GO

ALTER TABLE [dbo].[Dep_CustBetSetting_Member] ADD CONSTRAINT [DF_Dep_CustBetSetting_Member_MinBet] DEFAULT ((0)) FOR [MinBet]
GO

ALTER TABLE [dbo].[Dep_CustBetSetting_Member] ADD CONSTRAINT [DF_Dep_CustBetSetting_Member_MaxBet] DEFAULT ((0)) FOR [MaxBet]
GO

ALTER TABLE [dbo].[Dep_CustBetSetting_Member] ADD CONSTRAINT [DF_Dep_CustBetSetting_Member_MaxPerMatch]  DEFAULT ((0)) FOR [MaxPerMatch]
GO
CREATE TABLE [dbo].[Dep_CustBetSetting_Agent](
	[CustID] [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [smallint] NOT NULL,
	[MinBet] [money] NULL,
	[MaxBet] [money] NULL,
	[MaxPerMatch] [money] NULL,
 CONSTRAINT [PK_Dep_CustBetSetting_Agent] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC,
	[SportType] ASC,
	[BetType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [Dep_CustBetSetting_Agent_Table]
) ON [Dep_CustBetSetting_Agent_Table]
GO
ALTER TABLE [dbo].[Dep_CustBetSetting_Agent] ADD CONSTRAINT [DF_Dep_CustBetSetting_Agent_MinBet]  DEFAULT ((0)) FOR [MinBet]
GO
ALTER TABLE [dbo].[Dep_CustBetSetting_Agent] ADD CONSTRAINT [DF_Dep_CustBetSetting_Agent_MaxBet]  DEFAULT ((0)) FOR [MaxBet]
GO
ALTER TABLE [dbo].[Dep_CustBetSetting_Agent] ADD CONSTRAINT [DF_Dep_CustBetSetting_Agent_MaxPerMatch]  DEFAULT ((0)) FOR [MaxPerMatch]
GO
CREATE TABLE [dbo].[Dep_ProductBetSetting](
	[Sporttype] [int] NOT NULL,
	[Bettype] [smallint] NOT NULL,
	[Currency] [tinyint] NOT NULL,
	[MinBet] [money] NULL,
	[MaxBet] [money] NULL,
	[MaxPerMatch] [money] NULL,
	[DefaultMinBet] [money] NULL,
	[DefaultMaxBet] [money] NULL,
	[DefaultMaxPerMatch] [money] NULL,
 CONSTRAINT [PK_Dep_ProductBetSetting] PRIMARY KEY CLUSTERED 
(
	[Sporttype] ASC,
	[Bettype] ASC,
	[Currency] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [Dep_ProductBetSetting_table]
) ON [Dep_ProductBetSetting_table]

GO
ALTER TABLE [dbo].[Dep_ProductBetSetting] ADD  CONSTRAINT [DF_Dep_ProductBetSetting_Minbet]  DEFAULT ((0)) FOR [MinBet]
GO
ALTER TABLE [dbo].[Dep_ProductBetSetting] ADD  CONSTRAINT [DF_Dep_ProductBetSetting_MaxBet]  DEFAULT ((0)) FOR [MaxBet]
GO
ALTER TABLE [dbo].[Dep_ProductBetSetting] ADD  CONSTRAINT [DF_Dep_ProductBetSetting_MaxPerMatch]  DEFAULT ((0)) FOR [MaxPerMatch]
GO
ALTER TABLE [dbo].[Dep_ProductBetSetting] ADD  CONSTRAINT [DF_Dep_ProductBetSetting_DefaultMinBet]  DEFAULT ((0)) FOR [DefaultMinBet]
GO
ALTER TABLE [dbo].[Dep_ProductBetSetting] ADD  CONSTRAINT [DF_Dep_ProductBetSetting_DefaultMaxBet]  DEFAULT ((0)) FOR [DefaultMaxBet]
GO
ALTER TABLE [dbo].[Dep_ProductBetSetting] ADD  CONSTRAINT [DF_Dep_ProductBetSetting_DefaultMaxPerMatch]  DEFAULT ((0)) FOR [DefaultMaxPerMatch]
GO



