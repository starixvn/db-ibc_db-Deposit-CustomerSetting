/*<info serverAlias="DBCUST-CUSTDB" executers="" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].Acc_Dep_Initial_DCS_InitialSuperStatus_Upd
	@CustID INT,
	@CurrentStep TINYINT
AS
/*
	Created: 20210713@Eden
	Task : Update Dep_Initial_Super.CurrentStep
	DB: DBCUST/CUSTDB
	Original:

	Revisions:  
	- 20210713@Eden:  Flexible Initializing Customer Setting [RedmineID: #156667]

	Parameter Definition

	Example: 
		EXEC [Acc_Dep_Initial_DCS_InitialSuperStatus_Upd] 
			@CustID = 1,
			@CurrentStep = 2
	
	*/
BEGIN
	SET NOCOUNT ON
	
	UPDATE Dep_Initial_Super WITH(ROWLOCK,UPDLOCK)
	SET CurrentStep = @CurrentStep
	WHERE CustID = @CustID
END
GO


