/*
	Created by: Winnie
	Created Date: 20160401
	Description: DCS 
	Database: DBTP/bodb_CustHistory
		
*/

-------

USE bodb_CustHistory

GO


CREATE TABLE [dbo].[Dep_CustPTSetting_Member_history](
	UpdateTime datetime NOT NULL,
	[CustID] [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [smallint] NOT NULL,
	[IsLive] [bit] NOT NULL,
	[SuperPT] [tinyint] NOT NULL,
	[MasterPT] [tinyint] NOT NULL,
	[AgentPT] [tinyint] NOT NULL

) ON Dep_CustSetting3rd_table

GO
ALTER TABLE [dbo].[Dep_CustPTSetting_Member_history] ADD  CONSTRAINT [DF_Dep_CustPTSetting_Member_history_UpdateTime]  DEFAULT (getdate()) FOR [UpdateTime]
GO

ALTER TABLE [dbo].[Dep_CustPTSetting_Member_history] ADD  DEFAULT ((0)) FOR [SuperPT]
GO

ALTER TABLE [dbo].[Dep_CustPTSetting_Member_history] ADD  DEFAULT ((0)) FOR [MasterPT]
GO

ALTER TABLE [dbo].[Dep_CustPTSetting_Member_history] ADD  DEFAULT ((0)) FOR [AgentPT]
GO

CREATE CLUSTERED INDEX [Dep_CustPTSetting_Member_His_Index] ON [dbo].[Dep_CustPTSetting_Member_history] 
(
	[UpdateTime] ASC,
	[CustID] ASC
) 
GO

CREATE TABLE [dbo].Dep_CustPTSetting_Agent_history(
	UpdateTime datetime NOT NULL,
	[CustID] [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [smallint] NOT NULL,
	[IsLive] [bit] NOT NULL,
	[SuperPT] [tinyint] NOT NULL,
	[MasterPT] [tinyint] NOT NULL,
	[AgentPT] [tinyint] NOT NULL	
) ON Dep_CustSetting3rd_table

GO

ALTER TABLE [dbo].Dep_CustPTSetting_Agent_history ADD  CONSTRAINT [DF_Dep_CustPTSetting_Agent_history_UpdateTime]  DEFAULT (getdate()) FOR [UpdateTime]
GO

ALTER TABLE [dbo].Dep_CustPTSetting_Agent_history ADD  DEFAULT ((0)) FOR [SuperPT]
GO

ALTER TABLE [dbo].Dep_CustPTSetting_Agent_history ADD  DEFAULT ((0)) FOR [MasterPT]
GO

ALTER TABLE [dbo].Dep_CustPTSetting_Agent_history ADD  DEFAULT ((0)) FOR [AgentPT]
GO
CREATE CLUSTERED INDEX [Dep_CustPTSetting_Agent_His_Index] ON [dbo].[Dep_CustPTSetting_Agent_history] 
(
	[UpdateTime] ASC,
	[CustID] ASC
) 
GO

CREATE TABLE [dbo].Dep_CustPTGroupSetting_Member_history(
	UpdateTime datetime NOT NULL,
	[AgentID] [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [smallint] NOT NULL,
	[IsLive] [bit] NOT NULL,
	[SuperPT] [tinyint] NOT NULL,
	[MasterPT] [tinyint] NOT NULL,
	[AgentPT] [tinyint] NOT NULL
) ON Dep_CustSetting3rd_table

GO

ALTER TABLE [dbo].Dep_CustPTGroupSetting_Member_history ADD  CONSTRAINT [DF_CustPTGroupSetting_Member_history_UpdateTime]  DEFAULT (getdate()) FOR [UpdateTime]
GO

ALTER TABLE [dbo].Dep_CustPTGroupSetting_Member_history ADD  DEFAULT ((0)) FOR [SuperPT]
GO

ALTER TABLE [dbo].Dep_CustPTGroupSetting_Member_history ADD  DEFAULT ((0)) FOR [MasterPT]
GO

ALTER TABLE [dbo].Dep_CustPTGroupSetting_Member_history ADD  DEFAULT ((0)) FOR [AgentPT]
GO
CREATE CLUSTERED INDEX [Dep_CustPTGroupSetting_Member_His_Index] ON [dbo].[Dep_CustPTGroupSetting_Member_history] 
(
	[UpdateTime] ASC,
	[AgentID] ASC
) 
GO


CREATE TABLE [dbo].Dep_CustSettingMode_history(
	UpdateTime datetime NOT NULL,
	[CustID] [int] NOT NULL,
	[IsGroupedPT] [bit] NOT NULL,
	IsGroupedComm [bit] NOT NULL,
	IsGroupedBetLimit [bit] NOT NULL,
	IsGroupStakeLevel [bit] NOT NULL
) ON Dep_CustSetting3rd_table

GO
ALTER TABLE [dbo].Dep_CustSettingMode_history ADD  CONSTRAINT [DF_Dep_CustSettingMode_history_UpdateTime]  DEFAULT (getdate()) FOR [UpdateTime]
GO

ALTER TABLE [dbo].Dep_CustSettingMode_history ADD  DEFAULT ((0)) FOR [IsGroupedPT]
GO
ALTER TABLE [dbo].Dep_CustSettingMode_history ADD  DEFAULT ((0)) FOR IsGroupedComm
GO
ALTER TABLE [dbo].Dep_CustSettingMode_history ADD  DEFAULT ((0)) FOR IsGroupedBetLimit
GO
ALTER TABLE [dbo].Dep_CustSettingMode_history ADD  DEFAULT ((0)) FOR IsGroupStakeLevel
GO
CREATE CLUSTERED INDEX [Dep_CustSettingMode_His_Index] ON [dbo].[Dep_CustSettingMode_history] 
(
	[UpdateTime] ASC,
	[CustID] ASC
) 
GO

CREATE TABLE [dbo].Dep_CustProductStatus_history(
	UpdateTime datetime NOT NULL,
	[CustID] [int] NOT NULL,
	[bitmapIsHidden] [binary](32) NOT NULL,
	[bitmapIsDisabled] [binary](32) NOT NULL,
) ON Dep_CustSetting3rd_table

GO
ALTER TABLE [dbo].Dep_CustProductStatus_history ADD  CONSTRAINT [DF_Dep_CustProductStatus_history_UpdateTime]  DEFAULT (getdate()) FOR [UpdateTime]
GO

ALTER TABLE [dbo].Dep_CustProductStatus_history ADD  CONSTRAINT [DF_Dep_CustPRoductStatus_bitmapIsHidden]  DEFAULT (0x00) FOR [bitmapIsHidden]
GO

ALTER TABLE [dbo].Dep_CustProductStatus_history ADD  CONSTRAINT [DF_Dep_CustPRoductStatus_bitmapIsDisabled]  DEFAULT (0x00) FOR [bitmapIsDisabled]
GO
CREATE CLUSTERED INDEX [Dep_CustProductStatus_His_Index] ON [dbo].[Dep_CustProductStatus_history] 
(
	[UpdateTime] ASC,
	[CustID] ASC
) 
GO
---

CREATE TABLE [dbo].Dep_CustStakeLevel_Agent_history(
	UpdateTime datetime NOT NULL,
	[CustID] [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [smallint] NOT NULL,
	[StakeLevelList] [varchar](200) NULL, 
) ON Dep_CustSetting3rd_table

GO
ALTER TABLE [dbo].Dep_CustStakeLevel_Agent_history ADD  CONSTRAINT [DF_Dep_CustStakeLevel_Agent_history_UpdateTime]  DEFAULT (getdate()) FOR [UpdateTime]
GO
CREATE CLUSTERED INDEX [Dep_CustStakeLevel_Agent_His_Index] ON [dbo].[Dep_CustStakeLevel_Agent_history]  
(
	[UpdateTime] ASC,
	[CustID] ASC
) 
GO

CREATE TABLE [dbo].Dep_CustStakeLevel_Member_history( 
	UpdateTime datetime NOT NULL,
	[CustID] [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [smallint] NOT NULL,
	[StakeLevelList] [varchar](200) NULL,
	[LastUpdated] [datetime] NULL,
) ON Dep_CustSetting3rd_table

GO
ALTER TABLE [dbo].Dep_CustStakeLevel_Member_history ADD  CONSTRAINT [DF_Dep_CustStakeLevel_Member_history_UpdateTime]  DEFAULT (getdate()) FOR [UpdateTime]
GO
CREATE CLUSTERED INDEX [Dep_CustStakeLevel_Member_His_Index] ON [dbo].[Dep_CustStakeLevel_Member_history] 
(
	[UpdateTime] ASC,
	[CustID] ASC
) 
GO
