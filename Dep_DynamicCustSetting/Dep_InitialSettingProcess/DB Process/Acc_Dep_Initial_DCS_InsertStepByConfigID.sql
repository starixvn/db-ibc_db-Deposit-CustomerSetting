/*<info serverAlias="DBCUST-CUSTDB" executers="" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_Initial_DCS_InsertStepByConfigID]
	@ConfigID INT
AS
/*
	Created: 20220913@Eden
	Task : insert data for Dep_Initial_StepByConfig
	DB: DBCUST/CUSTDB
	Original:

	Revisions:  
	- 20220913@Eden: Flexible Initializing Deposit Customer Setting [RedmineID: #169648]

	Parameter Definition
		StepID = :
			1: Delete existing customer setting
			2: Insert customer setting
			3: Insert setting for new customer
			....

	Example: 
	
	*/
BEGIN
	SET NOCOUNT ON

	TRUNCATE TABLE Dep_Initial_StepByConfig

	INSERT Dep_Initial_StepByConfig(StepID, IsScanCustomer)
	SELECT 1,1 UNION ALL
	SELECT 2,1 UNION ALL
	SELECT 3,0

END
GO


