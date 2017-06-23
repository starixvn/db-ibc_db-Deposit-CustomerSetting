/*
	Created by: Helen
	Created Date: 20170606
	Description: DCS 
	Database: DBTP/bodb_CustHistory (local dev: server232 -   local test: server234)
	
	Filegroup in local test - Server 234: "D:\DB234_SQLSERVER2008R2\IBC_DB\bodb_history"
	Filegroup in local dev -  Server 232: "E:\IBC_DB\bodb_CustHistory"
*/
USE bodb_CustHistory
GO
--- CREATING FILE GROUP AND DATA FILE
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='Dep_CustBetSetting_table')
BEGIN
	ALTER DATABASE bodb_CustHistory
	ADD FILEGROUP Dep_CustBetSetting_table;
END
GO
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='Dep_CustBetSetting_table_01')
BEGIN
	ALTER DATABASE bodb_CustHistory 
	ADD FILE 
	(
		NAME = Dep_CustBetSetting_table_01,
		-- Local test
		--FILENAME = 'D:\DB234_SQLSERVER2008R2\IBC_DB\bodb_history\Dep_CustBetSetting_table_01.NDF'
		-- Local dev
		--FILENAME = 'E:\IBC_DB\bodb_CustHistory\Dep_CustBetSetting_table_01.NDF'
		-- Production
		FILENAME = 'P:\IBC_DB\bodb_CustHistory\Dep_CustBetSetting_table_01.NDF'
		, SIZE = 32MB , MAXSIZE = UNLIMITED, FILEGROWTH = 32MB
	)
	TO FILEGROUP Dep_CustBetSetting_table;
END
GO

USE bodb_CustHistory
GO
CREATE TABLE [dbo].[Dep_CustBetSetting_Member_history](
	[UpdateTime] [datetime] NOT NULL,
	[CustID] [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [smallint] NOT NULL,
	[MinBet] [money] NULL,
	[MaxBet] [money] NULL,
	[MaxPerMatch] [money] NULL
) ON [Dep_CustBetSetting_Table]

GO

ALTER TABLE [dbo].[Dep_CustBetSetting_Member_history] ADD  CONSTRAINT [DF_Dep_CustBetSetting_Member_UpdateTime]  DEFAULT (getdate()) FOR [UpdateTime]
GO
ALTER TABLE [dbo].[Dep_CustBetSetting_Member_history] ADD  CONSTRAINT [DF_Dep_CustBetSetting_Member_MinBet] DEFAULT ((0)) FOR [MinBet]
GO

ALTER TABLE [dbo].[Dep_CustBetSetting_Member_history] ADD  CONSTRAINT [DF_Dep_CustBetSetting_Member_MaxBet] DEFAULT ((0)) FOR [MaxBet]
GO

ALTER TABLE [dbo].[Dep_CustBetSetting_Member_history] ADD  CONSTRAINT [DF_Dep_CustBetSetting_Member_MaxPerMatch] DEFAULT ((0)) FOR [MaxPerMatch]
GO
CREATE CLUSTERED INDEX [Dep_CustBetSetting_Member_His_Index] ON [dbo].[Dep_CustBetSetting_Member_history] 
(
	[UpdateTime] ASC,
	[CustID] ASC
) 
GO
CREATE TABLE [dbo].[Dep_CustBetSetting_Agent_history](
	[UpdateTime] [datetime] NOT NULL,
	[CustID] [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [smallint] NOT NULL,
	[MinBet] [money] NULL,
	[MaxBet] [money] NULL,
	[MaxPerMatch] [money] NULL

) ON [Dep_CustBetSetting_Table]

GO
ALTER TABLE [dbo].[Dep_CustBetSetting_Agent_history] ADD  CONSTRAINT [DF_Dep_CustBetSetting_Agent_UpdateTime]  DEFAULT (getdate()) FOR [UpdateTime]
GO
ALTER TABLE [dbo].[Dep_CustBetSetting_Agent_history] ADD  CONSTRAINT [DF_Dep_CustBetSetting_Agent_MinBet] DEFAULT ((0)) FOR [MinBet]
GO

ALTER TABLE [dbo].[Dep_CustBetSetting_Agent_history] ADD  CONSTRAINT [DF_Dep_CustBetSetting_Agent_MaxBet] DEFAULT ((0)) FOR [MaxBet]
GO

ALTER TABLE [dbo].[Dep_CustBetSetting_Agent_history] ADD  CONSTRAINT [DF_Dep_CustBetSetting_Agent_MaxPerMatch] DEFAULT ((0)) FOR [MaxPerMatch]
GO

CREATE CLUSTERED INDEX [Dep_CustBetSetting_Agent_His_Index] ON [dbo].[Dep_CustBetSetting_Agent_history] 
(
	[UpdateTime] ASC,
	[CustID] ASC
) 
GO

