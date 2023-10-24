/*<info serverAlias="DBCUST-CustDB" executers="" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE Task_Dep_Customer_Archive_AgentConfigStatus_Upd
	@AgentID INT = NULL,
	@Status TINYINT = NULL
AS
/*
	Created: 20230612@Eden
	Task: Update Status Dep_Customer_Archived_Config
	DB: DBCUST/CustDB
	Original: Task_Dep_Customer_Archive_AgentConfigStatus_Upd

	Revisions:
		- 20230612@Eden: First commit [#179092]

	Param's Explanation:
		@Status = 
			0 - Scan: allow to scan member to archive
			1 - Skip: not scan, not do archive process
			2 - Pending for testing: not scan, not do archive process, will be updated to 0 after testing
			3 - Done Archive for this Agent
	Examples:
	 EXEC Task_Dep_Customer_Archive_AgentConfigStatus_Upd @AgentID =  31607835, @Status = 3
*/
BEGIN
	SET NOCOUNT ON

	IF @Status IS NULL
		RETURN

	UPDATE cf 
	SET cf.Status = @Status
	FROM dbo.Dep_Customer_Archived_Config cf WITH (ROWLOCK,UPDLOCK)
	WHERE Status <> @Status
		AND Recommend = @AgentID
END