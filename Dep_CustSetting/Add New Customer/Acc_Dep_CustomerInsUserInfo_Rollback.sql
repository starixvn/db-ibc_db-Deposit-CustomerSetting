/*<info serverAlias="DBCust-CustDB" executers="wsv_nap,asv_cust,wsv_lap" viewers="" isFunction="0" isNested="1"></info>*/
ALTER PROCEDURE [dbo].Acc_Dep_CustomerInsUserInfo_Rollback 
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
		- 20241122@Johnson: Apply In-house replication for Credit Setting [RedmineID: #212684]
		- 20241230@Aries: Scale Out DBCUST - Apply Inhouse replication for the remaning tables [Redmine: #215627]
		
	Param's Explanation:

	Examples:
		EXEC Acc_Dep_CustomerInsUserInfo_Rollback @CustID = xxx 
	*/
BEGIN
	SET NOCOUNT ON
	
	DECLARE @RoleID tinyint  
	SELECT @RoleID = RoleID FROM customer (NOLOCK) WHERE CustID = @CustID  
  	
	IF @RoleID BETWEEN 2 AND 4
		DELETE FROM CustLoginInfo WITH(ROWLOCK) 
		OUTPUT DELETED.custid, SYSDATETIME()
		INTO CustLoginInfo_Del_InHouse(custid,RepUpdateTime)
		WHERE custId = @CustID	

	IF @RoleID = 4
	BEGIN
		DELETE c 
		OUTPUT DELETED.CustID, dbo.f_GetDateTime2()
		INTO CustSuper_Del_InHouse(CustID,RepUpdateTime)
		FROM CustSuper c WITH (ROWLOCK) 
		WHERE CustID = @CustID
		
		DELETE FROM Dep_CustSuper WITH(ROWLOCK) 
		OUTPUT DELETED.custid, SYSDATETIME()
		INTO Dep_CustSuper_Del_InHouse(custid,RepUpdateTime)
		WHERE custId = @CustID		
	END	
	ELSE IF @RoleID = 3
		DELETE c 
		OUTPUT DELETED.CustID, dbo.f_GetDateTime2()
		INTO CustMaster_Del_InHouse(CustID,RepUpdateTime)
		FROM CustMaster c WITH (ROWLOCK)  
		WHERE CustID = @CustID
	ELSE IF @RoleID = 2
		DELETE c 
		OUTPUT DELETED.CustID, dbo.f_GetDateTime2()
		INTO CustAgent_Del_InHouse(CustID,RepUpdateTime)
		FROM CustAgent c WITH (ROWLOCK)  
		WHERE CustID = @CustID

	DELETE FROM custinfo WITH (ROWLOCK)  
	OUTPUT DELETED.CustID, dbo.f_GetDateTime2()
	INTO custinfo_Del_InHouse(CustID,RepUpdateTime)
	WHERE custid = @CustID  
	
	DELETE FROM customer WITH (ROWLOCK)  
	OUTPUT DELETED.CustID, dbo.f_GetDateTime2()
	INTO customer_Del_InHouse(CustID,RepUpdateTime)
	WHERE CustID = @CustID 
END
GO