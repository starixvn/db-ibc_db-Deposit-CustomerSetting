/*
	Created by: Winnie
	Created Date: 20160401
	Description: DCS 
	Database: DBCUST/CustDB
		
*/
USE CustDB
GO
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='Dep_CustStakeLevel_table')
BEGIN
	ALTER DATABASE CustDB
	ADD FILEGROUP Dep_CustStakeLevel_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='Dep_CustStakeLevel_table_01')
BEGIN
	ALTER DATABASE CustDB 
	ADD FILE 
	(
		NAME = Dep_CustStakeLevel_table_01,
		FILENAME = 'D:\DB233\IBC_DB\CustDB\Dep_CustStakeLevel_table_01.NDF'
	)
	TO FILEGROUP Dep_CustStakeLevel_table;
END
GO


-----
CREATE TABLE [dbo].[Dep_StakeLevelGroupDetail](
	[StakeLevelID] [int] NOT NULL,
	[GameTypeID] [smallint] NOT NULL,
	[MinLabel] [nvarchar](50) NULL,
	[MaxLabel] [nvarchar](50) NULL,
	[MinStake] [decimal](19, 8) NULL,
	[MaxStake] [decimal](19, 8) NULL,
 CONSTRAINT [PK_Dep_StakeLevelGroupDetail] PRIMARY KEY CLUSTERED 
(
	[StakeLevelID] ASC,
	[GameTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON DATA
) ON DATA

GO

-------

CREATE TABLE [dbo].[Dep_StakeLevel](
	[StakeLevelID] [int] NOT NULL,
	[GameTypeID] [smallint] NOT NULL,
	[GameGroupID] [smallint] NOT NULL,
	[MinLabel] [nvarchar](50) NULL,
	[MaxLabel] [nvarchar](50) NULL,
	[MinStake] [decimal](19, 8) NULL,
	[MaxStake] [decimal](19, 8) NULL,
	[ExchangeID] [int] NULL,
	[ResourceId] [int] NULL,
 CONSTRAINT [PK_Dep_StakeLevel] PRIMARY KEY CLUSTERED 
(
	[StakeLevelID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON DATA
) ON DATA

GO

ALTER TABLE [dbo].[Dep_StakeLevel] ADD  CONSTRAINT [DF_Dep_StakeLevel_GameGroupID]  DEFAULT ((0)) FOR [GameGroupID]
GO
------
CREATE TABLE [dbo].[Dep_CustStakeLevel_Agent](
	[CustID] [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [smallint] NOT NULL,
	[StakeLevelList] [varchar](200) NULL,
 CONSTRAINT [PK_Dep_CustStakeLevel_Agent] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC,
	[SportType] ASC,
	[BetType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON Dep_CustStakeLevel_table
) ON Dep_CustStakeLevel_table

GO

CREATE TABLE [dbo].[Dep_CustStakeLevel_Member](
	[CustID] [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [smallint] NOT NULL,
	[StakeLevelList] [varchar](200) NULL,
	[LastUpdated] [datetime] NULL,
 CONSTRAINT [PK_Dep_CustStakeLevel_Member] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC,
	[SportType] ASC,
	[BetType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON Dep_CustStakeLevel_table
) ON Dep_CustStakeLevel_table

GO



