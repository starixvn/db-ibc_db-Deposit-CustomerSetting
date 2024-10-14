/*<info serverAlias="DBCust-CustDB" executers="wsv_nap" viewers="" isFunction="0" isNested="1"></info>*/
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
		
	Param's Explanation:

	Examples:
		EXEC Acc_Dep_CustomerInsUserInfo_Rollback @CustID = xxx 
	*/
BEGIN
	SET NOCOUNT ON
	
	DECLARE @RoleID tinyint  
	SELECT @RoleID = RoleID FROM CustInfo (NOLOCK) WHERE CustID = @CustID  
  	
	IF @RoleID BETWEEN 2 AND 4
		DELETE FROM CustLoginInfo WITH (ROWLOCK) WHERE CustID = @CustID 

	IF @RoleID = 4
	BEGIN
		DELETE FROM CustSuper WITH (ROWLOCK) WHERE CustID = @CustID
		
		DELETE FROM Dep_CustSuper WITH(ROWLOCK) 
		OUTPUT DELETED.custid, SYSDATETIME()
		INTO Dep_CustSuper_Del_InHouse(custid,RepUpdateTime)
		WHERE custId = @CustID		
		
		DELETE Dep_LicenseeProductSetting WITH(ROWLOCK) 
		OUTPUT DELETED.custid, DELETED.ProductSettingID,SYSDATETIME()
		INTO Dep_LicenseeProductSetting_Del_InHouse(custid,ProductSettingID,RepUpdateTime)
		WHERE custid = @custid
	END	
	ELSE IF @RoleID = 3
		DELETE FROM CustMaster WITH (ROWLOCK)  WHERE CustID = @CustID
	ELSE IF @RoleID = 2
		DELETE FROM CustAgent WITH (ROWLOCK)  WHERE CustID = @CustID

	DELETE FROM custinfo WITH (ROWLOCK)  WHERE custid = @CustID  
	DELETE FROM customer WITH (ROWLOCK)  WHERE CustID = @CustID 

	DELETE c
	OUTPUT deleted.custid, deleted.seqNo, [dbo].[f_GetDateTime2]() 
	INTO CustVirtualSetting_Del_Inhouse(custid,seqNo,RepUpdateTime)
	FROM CustVirtualSetting c WITH(ROWLOCK) 
	WHERE CustID = @CustID

	DELETE c
	OUTPUT deleted.custid, deleted.Type, [dbo].[f_GetDateTime2]() 
	INTO VRCustLockStatus_Del_Inhouse(custid,Type,RepUpdateTime)
	FROM VRCustLockStatus c WITH(ROWLOCK) 
	WHERE CustID = @CustID 	
	
	DELETE c
	OUTPUT deleted.custid, deleted.LevelID, [dbo].[f_GetDateTime2]() 
	INTO VRCustSetting_Del_Inhouse(custid,LevelID,RepUpdateTime)
	FROM VRCustSetting c WITH(ROWLOCK) 
	WHERE CustID = @CustID
		
END