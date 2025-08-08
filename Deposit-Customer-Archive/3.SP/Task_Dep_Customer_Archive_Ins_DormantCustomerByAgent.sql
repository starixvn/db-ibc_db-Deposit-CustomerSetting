/*<info serverAlias="DBACC-bodb02" executers="" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [Task_Dep_Customer_Archive_Ins_DormantCustomerByAgent]
	@CheckBettrans_CustPerBatch INT = 2000,
	@InsertRepTable_CustPerBatch INT = 5000,
	@Site VARCHAR(20) = NULL,
	@Recommend INT = NULL,
	@MinBalance MONEY = NULL,
	@MinDays INT = NULL,
	@CustIDBalanceDummy INT = NULL
AS
/*
	Created: 20230612@Eden
	Task: Get Dormant Customer by Agent Line
	DB: DBACC/bodb02
	Original: 

	Revisions:
		- 20230612@Eden: First commit [#179092]
		- 20250806@Tacy: Adjust Writelog after Finish inserting Dep_Customer_Archived [#235437]

	Param's Explanation:
		- @CheckBettrans_CustPerBatch: Number of cutomers in a batch which will be checked if they have bet tickets in bettrans/translog..
		- @InsertRepTable_CustPerBatch: Number of customers which will be inserted into replicated table in one transaction
*/
BEGIN
	DECLARE @ErrMsg nvarchar(200),
		@Msg nvarchar(500),
		@agentname VARCHAR(50),
		@srecommend INT,
		@NumberOfDormant INT = 0

	-- Write log - Start Of Scaning Each Agent
	EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive 
					  @CustID = @Recommend
					, @Action='PUT-QUEUE'
					, @Status='OnProgress'
					, @Message='Start Scan Dormant Customer'

	SELECT @ErrMsg = ''

	SELECT @agentname = c.username, @srecommend = c.srecommend
	FROM Customer c WITH (NOLOCK)
	WHERE c.custid = @Recommend 
		AND c.roleid = 2	

	IF ISNULL(@agentname,'') = '' OR ISNULL(@srecommend,'') = ''
		SELECT @ErrMsg = CAST(@Recommend AS varchar(50)) +':'+ 'Agent does not exist.'
	ELSE
	BEGIN
		IF @agentname LIKE '%ACC%'
			SELECT @ErrMsg = CAST(@Recommend AS varchar(50)) +':'+ 'Agent is dummy account.'
		ELSE
		BEGIN
			IF NOT EXISTS(SELECT 1 FROM Dep_CustSuper WITH (NOLOCK) WHERE custid = @srecommend)
				SELECT @ErrMsg = CAST(@Recommend AS varchar(50)) +':'+ 'Agent is not deposit customer.'
			ELSE IF NOT EXISTS(SELECT 1 FROM Customer WITH (NOLOCK) WHERE custid = @CustIDBalanceDummy AND recommend = @Recommend)
				SELECT @ErrMsg = CAST(@Recommend AS varchar(50)) +':'+ 'Dummy Account does not belong to this Agent.'
		END
	END

	---Call Task_Dep_Customer_Archive_ScanCustomer SP to scan cusotmer
	IF @ErrMsg = ''
	BEGIN
		BEGIN TRY
			EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @Action='PUT-QUEUE'
				, @CustID = @Recommend
				, @Status='OnProgress'
				, @Message='Start inserting Tmp_Dep_Customer_Archived on bodb_report@DBACC'
				
			EXEC dbo.Task_Dep_Customer_Archive_ScanCustomer
						@agentID = @Recommend, 
						@minBalance = @Minbalance, 
						@minDays = @MinDays,
						@custIDBalanceDummy = @CustIDBalanceDummy,
						@CheckBettrans_CustPerBatch = @CheckBettrans_CustPerBatch

			EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @Action='PUT-QUEUE'
				, @CustID = @Recommend
				, @Status='OnProgress'
				, @Message='Finish inserting Tmp_Dep_Customer_Archived on bodb_report@DBACC'

			SELECT @NumberOfDormant = COUNT(1)
			FROM bodb_Report.dbo.Tmp_Dep_Customer_Archived WITH (NOLOCK) 

			IF @NumberOfDormant > 0
			BEGIN
				SELECT @Msg = 'Start inserting Dep_Customer_Archived on CustDB@DBCUST: ' 
						+ CAST(@NumberOfDormant AS VARCHAR(100)) + ' rows'

				EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @Action='PUT-QUEUE'
					, @CustID = @Recommend
					, @Status='OnProgress'
					, @Message=@Msg
			
				EXEC DBCUST.CustDB.dbo.Task_Dep_Customer_Archived_Insert @InsertRepTable_CustPerBatch=@InsertRepTable_CustPerBatch
				
				-- cause: data has a little latency from dbcust to dbacc
				SELECT @NumberOfDormant = COUNT(1)
				FROM DBCUST.CustDB.dbo.Dep_Customer_Archived WITH (NOLOCK) 
				WHERE recommend=@recommend AND Status='waiting'
			
				SELECT @Msg = 'Finish inserting Dep_Customer_Archived on CustDB@DBCUST: ' 
						+ CAST(@NumberOfDormant AS VARCHAR(100)) + ' rows'

				EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @Action='PUT-QUEUE'
					, @CustID = @Recommend
					, @Status='OnProgress'
					, @Message=@Msg
			END
			ELSE
			BEGIN
				EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @Action='PUT-QUEUE'
					, @CustID = @Recommend
					, @Status='OnProgress'
					, @Message='There is no dormant customer of this agent'
			END
		END TRY
		BEGIN CATCH

			SELECT @ErrMsg = 'Exception error occurs while scanning dormant customer( ' +  @agentname + ' ): ' + ERROR_MESSAGE() 

			RAISERROR(@ErrMsg, 11, 1)

			RETURN

		END CATCH


	END
	ELSE
	BEGIN
		-- Write error log
		EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive 
					@CustID = @Recommend
					, @Action='PUT-QUEUE'
					, @Status='Failed'
					, @Message=@ErrMsg
	END
		-- Write log - End Of Scaning Each Agent
	EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive 
					  @CustID = @Recommend
					, @Action='PUT-QUEUE'
					, @Status='Done'
					, @Message='End Scan Dormant Customer'
END
GO