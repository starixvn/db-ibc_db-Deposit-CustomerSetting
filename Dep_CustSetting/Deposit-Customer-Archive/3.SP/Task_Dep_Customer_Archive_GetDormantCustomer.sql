/*<info serverAlias="DBACC-bodb02" executers="" viewers="vnteam" isFunction="0"></info>*/
ALTER PROCEDURE [Task_Dep_Customer_Archive_GetDormantCustomer]
	@CheckStatement_DaysPerBatch INT = 1,
	@CheckBettrans_CustPerBatch INT = 2000,
	@InsertRepTable_CustPerBatch INT = 6000
AS
/*
	Created: 20180911@Kean
	Task: Get Dormant Customer
	DB: DBACC/bodb02
	Original: Task_Dep_Customer_Archive_GetDormantCustomer

	Revisions:
		- 20180911@Kean: First commit
		- 20190114@Dominic: Move this SP to bodb02@DB06 - Redmine #107931
		- 20190312@Dominic: Improve performance - #109528

	Param's Explanation:
		- @CheckStatement_DaysPerBatch: Number of cutomers in a batch which will be checked if they have bet tickets in statement
		- @CheckBettrans_CustPerBatch: Number of cutomers in a batch which will be checked if they have bet tickets in bettrans/translog..
		- @InsertRepTable_CustPerBatch: Number of customers which will be inserted into replicated table in one transaction
*/
BEGIN
	SET NOCOUNT ON
	DECLARE @ErrMsg nvarchar(200)
	DECLARE @Msg nvarchar(500)
	Declare @NumberOfDormant INT = 0
	
	-- Config infor
	DECLARE @Site VARCHAR(20)
	DECLARE @Recommend INT
	DECLARE @MinBalance MONEY
	DECLARE @MinDays INT
	DECLARE @CustIDBalanceDummy INT

	-- Agent infor
	DECLARE @srecommend INT, @agentname VARCHAR(50)

	-- For insert data
	DECLARE @CustID INT, @Username VARCHAR(50), @Username2 VARCHAR(50), @ClosingBalance MONEY

	-- Write log - Start Process
	EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @Action='PUT-QUEUE'
					, @Status='OnProgress'
					, @Message='Start Get Dormant Customer'
	-- Cursor
	DECLARE Dep_Customer_Archived_Config_Cursor CURSOR FOR
	SELECT Site, Recommend, MinBalance, MinDays, CustIDBalanceDummy
	FROM DBCUST.CustDB.dbo.Dep_Customer_Archived_Config  WITH (NOLOCK)
	WHERE Status = 0;

	OPEN Dep_Customer_Archived_Config_Cursor

	FETCH NEXT FROM Dep_Customer_Archived_Config_Cursor
	INTO @Site, @Recommend, @MinBalance, @MinDays, @CustIDBalanceDummy

	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- Write log - Start Of Scaning Each Agent
	   EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive 
						@CustID = @Recommend
					  ,	@Action='PUT-QUEUE'
					  , @Status='OnProgress'
					  , @Message='Start Scan Dormant Customer'

		SELECT @ErrMsg = ''

		SELECT @agentname = c.username, @srecommend = c.srecommend
		FROM Customer c WITH (NOLOCK)
		WHERE c.custid = @Recommend AND c.roleid = 2	

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
							@CheckStatement_DaysPerBatch = @CheckStatement_DaysPerBatch,
							@CheckBettrans_CustPerBatch = @CheckBettrans_CustPerBatch


				EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @Action='PUT-QUEUE'
					, @CustID = @Recommend
					, @Status='OnProgress'
					, @Message='Finish inserting Tmp_Dep_Customer_Archived on bodb_report@DBACC'

				SELECT @NumberOfDormant = COUNT(1)
				FROM bodb_Report.dbo.Tmp_Dep_Customer_Archived WITH (NOLOCK) 

				SELECT @Msg = 'Start inserting Dep_Customer_Archived on CustDB@DBCUST: ' 
						+ CAST(@NumberOfDormant AS VARCHAR(100)) + ' rows'

				EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @Action='PUT-QUEUE'
					, @CustID = @Recommend
					, @Status='OnProgress'
					, @Message=@Msg

				EXEC DBCUST.CustDB.dbo.Task_Dep_Customer_Archived_Insert @InsertRepTable_CustPerBatch=@InsertRepTable_CustPerBatch

				SELECT @Msg = 'Finish inserting Dep_Customer_Archived on CustDB@DBCUST: ' 
						+ CAST(@NumberOfDormant AS VARCHAR(100)) + ' rows'

				EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @Action='PUT-QUEUE'
					, @CustID = @Recommend
					, @Status='OnProgress'
					, @Message=@Msg
			END TRY
			BEGIN CATCH

				SELECT @ErrMsg = 'Exception error occurs while scanning dormant customer: ' + ERROR_MESSAGE()

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
					  ,	@Action='PUT-QUEUE'
					  , @Status='Done'
					  , @Message='End Scan Dormant Customer'
		FETCH NEXT FROM Dep_Customer_Archived_Config_Cursor
		INTO @Site, @Recommend, @MinBalance, @MinDays, @CustIDBalanceDummy
	END

	CLOSE Dep_Customer_Archived_Config_Cursor;  
	DEALLOCATE Dep_Customer_Archived_Config_Cursor;

	-- Write log - END Process
	EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @Action='PUT-QUEUE'
					, @Status='Done'
					, @Message='Finish Get Dormant Customer'
END