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
		- 20250722@Tacy: Performance tuning  [#233777]
		- 20250806@Tacy: Add Writelog when inserting Dep_Customer_Archived  [#235437]

	Explaination:
		- @InsertRepTable_CustPerBatch: Number of customers which will be inserted into replicated table in one transaction
*/
BEGIN
    SET NOCOUNT ON
	
	DECLARE @Message VARCHAR(MAX), @LogLstCustID VARCHAR(MAX)
	DECLARE @tmpCount int = 0, @Count int = 0 , @Recommend INT
	
	CREATE TABLE #Tmp_Dep_Customer_Archived(
		[CustID] [int] NOT NULL,
		[ArchivedDate] [datetime] NULL,
		[Username] [varchar](50) NULL,
		[Username2] [varchar](50) NULL,
		[Recommend] [int] NULL,
		[ClosingBalance] [money] NULL,
		[CustIDBalanceDummy] [int] NULL,
		[Status] [varchar](50) NULL
	)

	CREATE TABLE #Tmp_Dep_Customer_Archived_Batch(
		[CustID] [int] NOT NULL,
		[ArchivedDate] [datetime] NULL,
		[Username] [varchar](50) NULL,
		[Username2] [varchar](50) NULL,
		[Recommend] [int] NULL,
		[ClosingBalance] [money] NULL,
		[CustIDBalanceDummy] [int] NULL,
		[Status] [varchar](50) NULL
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

	SELECT TOP 1 @Recommend = Recommend
	FROM #Tmp_Dep_Customer_Archived

	WHILE (1=1)
	BEGIN
		TRUNCATE TABLE #Tmp_Dep_Customer_Archived_Batch

		DELETE TOP(@InsertRepTable_CustPerBatch) T 
		OUTPUT [deleted].[CustID], [deleted].[ArchivedDate]
			 , [deleted].[Username], [deleted].[Username2], [deleted].[Recommend]
			 , [deleted].[ClosingBalance], [deleted].[CustIDBalanceDummy], [deleted].[Status]
		INTO #Tmp_Dep_Customer_Archived_Batch 
			([CustID],[ArchivedDate],[Username],[Username2],[Recommend],[ClosingBalance],[CustIDBalanceDummy],[Status])
		FROM #Tmp_Dep_Customer_Archived T

		SET @tmpCount=@@ROWCOUNT
		
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
		FROM #Tmp_Dep_Customer_Archived_Batch
		
		SET @Count=@@ROWCOUNT

		IF @Count < @InsertRepTable_CustPerBatch
		BEGIN
			IF @Count < @tmpCount
			BEGIN
				SELECT @LogLstCustID = STUFF((SELECT ',' + CAST(CustID as VARCHAR(15))
											  FROM #Tmp_Dep_Customer_Archived_Batch
											  ORDER BY CustID
											  FOR XML PATH('')
											), 1, 1, '');

				SELECT @Message = 'Exception error occurs while inserting dormant customer: ' + @LogLstCustID
			
				-- Log detailed error information
				EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive 
					@Action='PUT-QUEUE'
					, @CustID = @Recommend
					, @Status='Warning'
					, @Message=@Message
			END

			BREAK
		END

		WAITFOR DELAY '00:00:00.100'
	END

	DROP TABLE #Tmp_Dep_Customer_Archived, #Tmp_Dep_Customer_Archived_Batch
END
