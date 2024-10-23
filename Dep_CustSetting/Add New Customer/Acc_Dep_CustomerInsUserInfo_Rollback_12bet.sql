/*<info serverAlias="DBCust-CustDB" executers="wsv_nap,asv_cust,wsv_lap" viewers="" isFunction="0" isNested="1"></info>*/
ALTER PROCEDURE [dbo].Acc_Dep_CustomerInsUserInfo_Rollback_12bet
	  @CustID INT 
AS
/*
	Created: 20240705@Eden 
	Task : Rollback Deposit Customer Info for New accounts when failed 
	DB: DBCUST/CustDB
	Original:

	Revisions:
		- 20240705@Eden  : Scale out DBCUST - Licensee Customer in GlobCustDB [redmine: #207474]
		- 20240701@Winfred: Scale Out DBCUST - Apply In-house Replication for Virtual Rate Setting  [redmine: #207029]
		- 20241023@Elodie: Support 12bet [RedmineID: #212624]
	Param's Explanation:

	Examples:
		EXEC Acc_Dep_CustomerInsUserInfo_Rollback @CustID = xxx 
	*/
BEGIN
	SET NOCOUNT ON
	
	DECLARE @RoleID tinyint  
	SELECT @RoleID = RoleID FROM customer (NOLOCK) WHERE CustID = @CustID  
  	
	EXEC GlobCustDB.dbo.Acc_CustomerIns_Rollback @CustID = @CustID

	IF @RoleID BETWEEN 2 AND 4
		DELETE FROM CustLoginInfo WITH (ROWLOCK) WHERE CustID = @CustID 

	IF @RoleID = 4
	BEGIN
		DELETE FROM CustSuper WITH (ROWLOCK) WHERE CustID = @CustID
		
		DELETE FROM Dep_CustSuper WITH(ROWLOCK) 
		OUTPUT DELETED.custid, SYSDATETIME()
		INTO Dep_CustSuper_Del_InHouse(custid,RepUpdateTime)
		WHERE custId = @CustID		
	END	
	ELSE IF @RoleID = 3
		DELETE FROM CustMaster WITH (ROWLOCK)  WHERE CustID = @CustID
	ELSE IF @RoleID = 2
		DELETE FROM CustAgent WITH (ROWLOCK)  WHERE CustID = @CustID

	DELETE FROM custinfo WITH (ROWLOCK)  WHERE custid = @CustID  
	DELETE FROM customer WITH (ROWLOCK)  WHERE CustID = @CustID 
END
GO