/*
	CREATEd by: Helen
	CREATEd Date: 20170606
	Description: DCS - #5 - CREATE Trigger on replicated table to insert data into DCS History tables
	
	Database: DBTP/bodb02 (local dev: server232 -   local test: server234)
	
*/

USE bodb02
GO

CREATE TRIGGER [dbo].[Dep_CustBetSetting_Member_update] ON [dbo].[Dep_CustBetSetting_Member] AFTER UPDATE
AS
/*
	Created by: 20170606@Helen
	Task: Trigger for updating [Dep_CustBetSetting_Member] table 
	DB: DBTP/bodb02

*/
BEGIN 
	SET NOCOUNT ON
	
	INSERT INTO bodb_CustHistory.dbo.[Dep_CustBetSetting_Member_History] (
		[CustID] ,
		[SportType] ,
		[BetType] ,
		[MinBet],
		[MaxBet],
		[MaxPerMatch]
	)
	SELECT
		[CustID] ,
		[SportType] ,
		[BetType] ,
		[MinBet],
		[MaxBet],
		[MaxPerMatch]
	FROM [DELETED]
END

GO


CREATE TRIGGER [dbo].[Dep_CustBetSetting_Agent_update] ON [dbo].[Dep_CustBetSetting_Agent] AFTER UPDATE
AS
/*
	Created by: 20170606@Helen
	Task: Trigger for updating [Dep_CustBetSetting_Agent] table 
	DB: DBTP/bodb02

*/
BEGIN 
	SET NOCOUNT ON
	
	INSERT INTO bodb_CustHistory.dbo.[Dep_CustBetSetting_Agent_History] (
		[CustID] ,
		[SportType] ,
		[BetType] ,
		[MinBet] ,
		[MaxBet] ,
		[MaxPerMatch]
	)
	SELECT
		[CustID] ,
		[SportType] ,
		[BetType] ,
		[MinBet] ,
		[MaxBet] ,
		[MaxPerMatch]
	FROM [DELETED]
END

GO
