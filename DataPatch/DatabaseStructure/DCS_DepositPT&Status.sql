/*
	Created by: Winnie
	Created Date: 20160401
	Description: DCS 
	Database: DBCUST/CustDB
		
*/
USE CustDB
GO
--- CREATING FILE GROUP AND DATA FILE
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='Dep_CustPTSetting_table')
BEGIN
	ALTER DATABASE CustDB
	ADD FILEGROUP Dep_CustPTSetting_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='Dep_CustPTSetting_table_01')
BEGIN
ALTER DATABASE CustDB 
ADD FILE 
(
	NAME = Dep_CustPTSetting_table_01,
	FILENAME = 'D:\DB233\IBC_DB\CustDB\Dep_CustPTSetting_table_01.NDF'
)
TO FILEGROUP Dep_CustPTSetting_table;
END
GO
--------
-------
USE CustDB

GO

CREATE TABLE [dbo].[Dep_CustPTSetting_Member](
	[CustID] [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [smallint] NOT NULL,
	[IsLive] [bit] NOT NULL,
	[SuperPT] [tinyint] NOT NULL,
	[MasterPT] [tinyint] NOT NULL,
	[AgentPT] [tinyint] NOT NULL
	
 CONSTRAINT [PK_Dep_CustPTSetting_Member] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC,
	[SportType] ASC,
	[BetType] ASC,
	[IsLive] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON Dep_CustPTSetting_table
) ON Dep_CustPTSetting_table

GO

ALTER TABLE [dbo].[Dep_CustPTSetting_Member] ADD CONSTRAINT [DF_Dep_CustPTSetting_Member_SuperPT] DEFAULT ((0)) FOR [SuperPT]
GO

ALTER TABLE [dbo].[Dep_CustPTSetting_Member] ADD CONSTRAINT [DF_Dep_CustPTSetting_Member_MasterPT] DEFAULT ((0)) FOR [MasterPT]
GO

ALTER TABLE [dbo].[Dep_CustPTSetting_Member] ADD CONSTRAINT [DF_Dep_CustPTSetting_Member_AgentPT] DEFAULT ((0)) FOR [AgentPT]
GO

CREATE TABLE [dbo].[Dep_CustPTSetting_Agent](
	[CustID] [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [smallint] NOT NULL,
	[IsLive] [bit] NOT NULL,
	[SuperPT] [tinyint] NOT NULL,
	[MasterPT] [tinyint] NOT NULL,
	[AgentPT] [tinyint] NOT NULL	
 CONSTRAINT [PK_Dep_CustPTSetting_Agent] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC,
	[SportType] ASC,
	[BetType] ASC,
	[IsLive] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON Dep_CustPTSetting_table
) ON Dep_CustPTSetting_table

GO

ALTER TABLE [dbo].[Dep_CustPTSetting_Agent] ADD CONSTRAINT [DF_Dep_CustPTSetting_Agent_SuperPT] DEFAULT ((0)) FOR [SuperPT]
GO

ALTER TABLE [dbo].[Dep_CustPTSetting_Agent] ADD CONSTRAINT [DF_Dep_CustPTSetting_Agent_MasterPT] DEFAULT ((0)) FOR [MasterPT]
GO

ALTER TABLE [dbo].[Dep_CustPTSetting_Agent] ADD CONSTRAINT [DF_Dep_CustPTSetting_Agent_AgentPT] DEFAULT ((0)) FOR [AgentPT]
GO

CREATE TABLE [dbo].[Dep_CustPTGroupSetting_Member](
	[AgentID] [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [smallint] NOT NULL,
	[IsLive] [bit] NOT NULL,
	[SuperPT] [tinyint] NOT NULL,
	[MasterPT] [tinyint] NOT NULL,
	[AgentPT] [tinyint] NOT NULL
 CONSTRAINT [PK_Dep_CustPTGroupSetting_Member] PRIMARY KEY CLUSTERED 
(
	[AgentID] ASC,
	[SportType] ASC,
	[BetType] ASC,
	[IsLive] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON Dep_CustPTSetting_table
) ON Dep_CustPTSetting_table

GO

ALTER TABLE [dbo].[Dep_CustPTGroupSetting_Member] ADD CONSTRAINT [DF_Dep_CustPTGroupSetting_Member_SuperPT] DEFAULT ((0)) FOR [SuperPT]
GO

ALTER TABLE [dbo].[Dep_CustPTGroupSetting_Member] ADD CONSTRAINT [DF_Dep_CustPTGroupSetting_Member_MasterPT] DEFAULT ((0)) FOR [MasterPT]
GO

ALTER TABLE [dbo].[Dep_CustPTGroupSetting_Member] ADD CONSTRAINT [DF_Dep_CustPTGroupSetting_Member_AgentPT] DEFAULT ((0)) FOR [AgentPT]
GO



 
CREATE TABLE [dbo].[Dep_CustSettingMode](
	[CustID] [int] NOT NULL,
	[IsGroupedPT] [bit] NOT NULL,
	IsGroupedComm [bit] NOT NULL,
	IsGroupedBetLimit [bit] NOT NULL,
	IsGroupedStakeLevel [bit] NOT NULL
 CONSTRAINT [PK_Dep_CustSettingMode] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON Dep_CustPTSetting_table
) ON Dep_CustPTSetting_table

GO

ALTER TABLE [dbo].[Dep_CustSettingMode] ADD CONSTRAINT [DF_Dep_CustSettingMode_IsGroupedPT]  DEFAULT ((0)) FOR [IsGroupedPT]
GO
ALTER TABLE [dbo].[Dep_CustSettingMode] ADD CONSTRAINT [DF_Dep_CustSettingMode_IsGroupedComm]  DEFAULT ((0)) FOR IsGroupedComm
GO
ALTER TABLE [dbo].[Dep_CustSettingMode] ADD CONSTRAINT [DF_Dep_CustSettingMode_IsGroupedBetLimit]  DEFAULT ((0)) FOR IsGroupedBetLimit
GO
ALTER TABLE [dbo].[Dep_CustSettingMode] ADD CONSTRAINT [DF_Dep_CustSettingMode_IsGroupedStakeLevel]  DEFAULT ((0)) FOR IsGroupedStakeLevel
GO

CREATE TABLE [dbo].[Dep_CustProductStatus](
	[CustID] [int] NOT NULL, 
	[bitmapIsHidden] [binary](32) NOT NULL,
	[bitmapIsDisabled] [binary](32) NOT NULL,
 CONSTRAINT [CIX_Dep_CustProductStatus_custid] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON table_customer
) ON table_customer

GO

ALTER TABLE [dbo].[Dep_CustProductStatus] ADD  CONSTRAINT [DF_Dep_CustPRoductStatus_bitmapIsHidden]  DEFAULT (0x00) FOR [bitmapIsHidden]
GO

ALTER TABLE [dbo].[Dep_CustProductStatus] ADD  CONSTRAINT [DF_Dep_CustPRoductStatus_bitmapIsDisabled]  DEFAULT (0x00) FOR [bitmapIsDisabled]
GO

CREATE TABLE [dbo].[Dep_ProductStatusProfile](
	[Sporttype] [smallint] NOT NULL,
	[Bettype] [smallint] NOT NULL,
	[bitmapOrder] [tinyint] NOT NULL,
 CONSTRAINT [PK_Dep_ProductStatusProfile] PRIMARY KEY NONCLUSTERED 
(
	[Sporttype] ASC,
	[Bettype] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON DATA
) ON DATA

GO

-----------------

CREATE TABLE [dbo].[Dep_ProductSettingDetail](
	ProductSettingID [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [smallint] NOT NULL,
	[IsLive] [bit] NOT NULL,	
	MaxDefaultValue [decimal](9, 8) NULL,		
	[SettingStatus] [tinyint] NULL,
 CONSTRAINT [PK_Dep_ProductSettingDetail] PRIMARY KEY CLUSTERED 
(
	ProductSettingID ASC,
	[SportType] ASC,
	[BetType] ASC,
	[IsLive] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON DATA
) ON DATA

GO
ALTER TABLE [dbo].[Dep_ProductSettingDetail] ADD CONSTRAINT [DF_Dep_ProductSettingDetail_MaxDefaultValue]   DEFAULT ((0)) FOR MaxDefaultValue
GO


CREATE TABLE [dbo].[Dep_LicenseeProductSetting](
	[CustID] [int] NOT NULL,
	[ProductSettingID] [int] NOT NULL,
 CONSTRAINT [PK_Dep_LicenseeProductSetting] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC,
	[ProductSettingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON DATA
) ON DATA

GO

CREATE TABLE [dbo].[Dep_ProductSetting](
	[ProductSettingID] [int] NOT NULL,
	[ProductID] [smallint] NOT NULL,
	[SettingType] [tinyint] NOT NULL,
	[TemplateID] [tinyint] NOT NULL,	
	[DisplayOrder] [tinyint] NOT NULL,
	[SettingLevel] [tinyint] NOT NULL,
 CONSTRAINT [PK_Dep_ProductSetting] PRIMARY KEY CLUSTERED 
(
	[ProductSettingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON DATA
) ON DATA

GO

ALTER TABLE [dbo].[Dep_ProductSetting] ADD  CONSTRAINT [DF_Dep_ProductSetting_TemplateID]  DEFAULT ((0)) FOR [TemplateID]
GO



CREATE TABLE [dbo].SettingRefResource(
	RefId varchar(20) NOT NULL,
	ResourceId tinyint NOT NULL,
	Resource_en varchar(50) NOT NULL
) ON DATA

GO





