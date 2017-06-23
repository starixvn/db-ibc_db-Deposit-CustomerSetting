
/*
	CREATEd by: Winnie
	CREATEd Date: 20160406
	Description: DCS Deposit- #5 - CREATE Trigger on replicated table to insert data into DCS History tables
	
	Database: DBTP/bodb02 (local dev: server232 -   local test: server234)
	
*/

USE bodb02
GO

CREATE TRIGGER [dbo].[Dep_CustPTSetting_Member_update] ON [dbo].[Dep_CustPTSetting_Member] AFTER UPDATE
AS
/*
	Created by: 20160406@Winnie
	Task: Trigger for updating [Dep_CustPTSetting_Member] table 
	DB: DBTP/bodb02

*/
BEGIN 
	SET NOCOUNT ON
	
	INSERT INTO bodb_CustHistory.dbo.[Dep_CustPTSetting_Member_History] (
		[CustID],
		[SportType],
		[BetType],
		[IsLive] ,
		[SuperPT],
		[MasterPT],
		[AgentPT]	
	)
	SELECT
		[CustID],
		[SportType],
		[BetType],
		[IsLive] ,
		[SuperPT],
		[MasterPT],
		[AgentPT]
	
	FROM [DELETED]
END

GO


CREATE TRIGGER [dbo].[Dep_CustPTSetting_Agent_update] ON [dbo].[Dep_CustPTSetting_Agent] AFTER UPDATE
AS
/*
	Created by: 20160406@Winnie
	Task: Trigger for updating [Dep_CustPTSetting_Agent] table 
	DB: DBTP/bodb02

*/
BEGIN 
	SET NOCOUNT ON
	
	INSERT INTO bodb_CustHistory.dbo.[CustPTSetting3rd_Agent_History] (
		[CustID] ,
		[SportType] ,
		[BetType] ,
		[IsLive] ,
		[SuperPT] ,
		[MasterPT] ,
		[AgentPT] 		
	)
	SELECT
		[CustID] ,
		[SportType] ,
		[BetType] ,
		[IsLive] ,
		[SuperPT] ,
		[MasterPT] ,
		[AgentPT] 		
	
	FROM [DELETED]
END

GO

CREATE TRIGGER [dbo].[Dep_CustPTGroupSetting_Member_update] ON [dbo].[Dep_CustPTGroupSetting_Member] AFTER UPDATE
AS
/*
	Created by: 20160406@Winnie
	Task: Trigger for updating [Dep_CustPTGroupSetting_Member] table 
	DB: DBTP/bodb02

*/
BEGIN 
	SET NOCOUNT ON
	
	INSERT INTO bodb_CustHistory.dbo.[Dep_CustPTGroupSetting_Member_History] (
		[AgentID] ,
		[SportType] ,
		[BetType] ,
		[IsLive] ,
		[SuperPT] ,
		[MasterPT] ,
		[AgentPT] 	
	)
	SELECT
		[AgentID] ,
		[SportType] ,
		[BetType] ,
		[IsLive] ,
		[SuperPT] ,
		[MasterPT] ,
		[AgentPT] 	
	FROM [DELETED]
END

GO

CREATE TRIGGER [dbo].[Dep_CustSettingMode_update] ON [dbo].[Dep_CustSettingMode] AFTER UPDATE
AS
/*
	Created by: 20160406@Winnie
	Task: Trigger for updating [Dep_CustSettingMode] table 
	DB: DBTP/bodb02

*/
BEGIN 
	SET NOCOUNT ON
	
	INSERT INTO bodb_CustHistory.dbo.[Dep_CustSettingMode_History] (
		[CustID] ,
		IsGroupedPT, 
		IsGroupedComm,
		IsGroupedBetLimit,
		IsGroupStakeLevel
	)
	SELECT
		[CustID] ,
		IsGroupedPT, 
		IsGroupedComm,
		IsGroupedBetLimit,
		IsGroupStakeLevel
	FROM [DELETED]
END

GO


CREATE TRIGGER [dbo].[Dep_CustStakeLevel_Agent_update] ON [dbo].Dep_CustStakeLevel_Agent AFTER UPDATE
AS
/*
	Created by: 20160406@Winnie
	Task: Trigger for updating [Dep_CustStakeLevel_Agent] table 
	DB: DBTP/bodb02

*/
BEGIN 
	SET NOCOUNT ON
	
	INSERT INTO bodb_CustHistory.dbo.Dep_CustStakeLevel_Agent_history (
		[CustID] ,
		[SportType] ,
		[BetType] ,
		StakeLevelList
	)
	SELECT
		[CustID] ,
		[SportType] ,
		[BetType] ,
		StakeLevelList
	FROM [DELETED]
END

GO

CREATE TRIGGER [dbo].[Dep_CustStakeLevel_Member_update] ON [dbo].Dep_CustStakeLevel_Member AFTER UPDATE
AS
/*
	Created by: 20160406@Winnie
	Task: Trigger for updating [Dep_CustStakeLevel_Member] table 
	DB: DBTP/bodb02

*/
BEGIN 
	SET NOCOUNT ON
	
	INSERT INTO bodb_CustHistory.dbo.Dep_CustStakeLevel_Member_history (
		[CustID] ,
		[SportType] , 
		[BetType] ,
		StakeLevelList,
		LastUpdated
	)
	SELECT
		[CustID] ,
		[SportType] ,
		[BetType] ,
		StakeLevelList,
		LastUpdated
	FROM [DELETED]
END

GO


CREATE TRIGGER [dbo].[Dep_CustProductStatus_update] ON [dbo].[Dep_CustProductStatus] AFTER UPDATE
AS
/*
	Created by:  20160406@Winnie
	Task: Trigger for updating [Dep_CustProductStatus] table 
	DB: DBTP/bodb02

*/
BEGIN 
	SET NOCOUNT ON
	
	INSERT INTO bodb_CustHistory.dbo.[Dep_CustProductStatus_History] (
		[CustID] ,
		
		[bitmapIsHidden] ,
		[bitmapIsDisabled] 
	)
	SELECT
		[CustID] ,		
		[bitmapIsHidden] ,
		[bitmapIsDisabled] 
	FROM [DELETED]
END
GO

