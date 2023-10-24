/*<info serverAlias="DBCUST-CustDB" executers="" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [Task_Dep_Customer_Archive_DeleteCustSetting]
	 @CustID INT = -1
	,@LstCustID VARCHAR(MAX) = ''
AS
/*
	Created: 20230704@Eden
	Task: Delete CustSetting of customer (use for Archive Process)
	DB: DBCUST/CustDB
	Original: 

	Revisions:
		- 20230704@Eden: First commit [#179092]

	Param's Explanation:
*/
BEGIN
	SET NOCOUNT ON

	EXEC Acc_Dep_DynamicCustSetting_11 @LstCustID = @LstCustID, @ActionID = 7 -- Delete table of CustDB_CustSetting publication
	EXEC Acc_CustomerInfo_Execrep_10 @LstCustID = @LstCustID, @ActionID = 7 --Delete table of CustDB_Customer_Info publication
END