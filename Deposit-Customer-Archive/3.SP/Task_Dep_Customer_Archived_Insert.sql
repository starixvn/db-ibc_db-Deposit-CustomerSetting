/*<info serverAlias="DBCUST-CUSTDB" executers="" viewers="vnteam" isFunction="0"></info>*/
CREATE PROCEDURE [Task_Dep_Customer_Archived_Insert]
	@InsertRepTable_CustPerBatch INT = 2000
AS
/*
	Created: Dominic@20190114
	Task :	Insert data into table Dep_Customer_Archived with data from DBACC.bodb_report.Tmp_Dep_Customer_Archived - Redmine #107931
	DB: DBCUST/CustDB

	Revisions:    
		- 20190114@Dominic: First commit
		- 20190424@Dominic: Increase the waiting time to 3s - Feature #111652
		- 20230612@Eden: Enhance for Scale Out [#179092]
		- 20250403@Tacy: Enhance Archive service to adapt IHR [#222312]

	Explaination:
		- @InsertRepTable_CustPerBatch: Number of customers which will be inserted into replicated table in one transaction
*/
BEGIN
    SET NOCOUNT ON 
	
	CREATE TABLE #Tmp_Dep_Customer_Archived(
		[CustID] [int] NOT NULL,
		[ArchivedDate] [datetime] NULL,
		[Username] [varchar](50) NULL,
		[Username2] [varchar](50) NULL,
		[Recommend] [int] NULL,
		[ClosingBalance] [money] NULL,
		[CustIDBalanceDummy] [int] NULL,
		[Status] [varchar](50) NULL,
		IsInserted BIT DEFAULT(0)
	)

	INSERT INTO #Tmp_Dep_Customer_Archived ([CustID],[ArchivedDate],[Username],[Username2],[Recommend],[ClosingBalance],[CustIDBalanceDummy],[Status])
	SELECT [CustID]
           ,[ArchivedDate]
           ,[Username]
           ,[Username2]
           ,[Recommend]
           ,[ClosingBalance]
           ,[CustIDBalanceDummy]
           ,[Status]
	FROM DBACC.bodb_Report.dbo.Tmp_Dep_Customer_Archived WITH (NOLOCK)
	
	CREATE UNIQUE CLUSTERED INDEX IX_CustID ON #Tmp_Dep_Customer_Archived(CustID)

	--Delete duplicated data
	DELETE #Tmp_Dep_Customer_Archived
	WHERE CustID IN (
		SELECT CustID FROM [dbo].[Dep_Customer_Archived] WITH (NOLOCK)
	)

	WHILE (1=1)
	BEGIN
		UPDATE TOP(@InsertRepTable_CustPerBatch) #Tmp_Dep_Customer_Archived
		SET IsInserted = 1

		INSERT INTO [dbo].[Dep_Customer_Archived]
			   ([CustID]
			   ,[ArchivedDate]
			   ,[Username]
			   ,[Username2]
			   ,[Recommend]
			   ,[ClosingBalance]
			   ,[CustIDBalanceDummy]
			   ,[Status]
			   ,[RepUpdateTime])
		SELECT [CustID]
			   ,[ArchivedDate]
			   ,[Username]
			   ,[Username2]
			   ,[Recommend]
			   ,[ClosingBalance]
			   ,[CustIDBalanceDummy]
			   ,[Status]
			   ,dbo.f_GetDateTime2()
		FROM #Tmp_Dep_Customer_Archived
		WHERE IsInserted = 1

		DELETE #Tmp_Dep_Customer_Archived
		WHERE IsInserted = 1

		IF @@ROWCOUNT < @InsertRepTable_CustPerBatch
			BREAK

		WAITFOR DELAY '00:00:00.100'
	END

	DROP TABLE #Tmp_Dep_Customer_Archived
END
