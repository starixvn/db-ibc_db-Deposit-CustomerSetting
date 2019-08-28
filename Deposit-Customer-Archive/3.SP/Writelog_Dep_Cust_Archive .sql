/*<info serverAlias="DBLOG-bodb_CustomerLog" executers="" viewers="" isFunction="0"></info>*/
CREATE PROCEDURE Writelog_Dep_Cust_Archive 
	@CustID INT = 0
	,@Action VARCHAR(100)
	,@Status VARCHAR(100)
	,@Message VARCHAR(MAX)
AS
/*
	Creator : Dominic
	Date : 2018-09-12
	Task : Write log for archiving dormant deposit members
	DB: DBLOG/bodb_CustomerLog
	Revisions:
		- 20180912@Dominic: First commit
		- 20181207@Dominic: Change data type of @Message to VARCHAR(MAX) 
	Parameter:
		- @CustID: Dormant CustID
		- @Action: 
					PUT-QUEUE: Put on a waiting queue
					CLEAR-BALANCE: Clear balance
					ARCHIVE-CUSTSETTING: Archive Customer Setting tables
					DEL-CUSTSETTING: Delete Customer Setting tables in main DB
		- @Status: 
					OnProgress
					Warning
					Done
					Failed
		- @Message:
	
*/
BEGIN
	INSERT INTO [dbo].[DBALog_Archive_Dep_Cust_Process]
			   ([CustID]
			   ,[Action]
			   ,[Status]
			   ,[Message]
			   ,[LogTime])
		 VALUES
			   (@CustID
			   ,@Action
			   ,@Status
			   ,@Message
			   ,GETDATE())

END