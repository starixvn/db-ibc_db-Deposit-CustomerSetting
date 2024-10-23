/*<info serverAlias="DBCUST-CustDB" executers="asv_cust,wsv_nap" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_CustomerIns_Rollback_Multiple]
	@CustIDs VARCHAR(MAX),
	@IsRollbackFullLine BIT = 0 --= 1: Rollback full line 
AS
/*
	Created: 20240705@Eden  
	Task : Rollback custinfo mini for multiple accounts
	DB:  DBCUST-CustDB
	Original sp: 
	
	Revisions: 
		- 20240705@Eden  : Scale out DBCUST - Licensee Customer in GlobCustDB [redmine: #207474]

	Param's Explanation: 
		Sample Format:
		EXEC [Acc_Dep_CustomerIns_Rollback_Multiple]
			 @CustIDs = '148595789,148595790'
*/			   					
BEGIN
	SET NOCOUNT ON
	DECLARE @Customer TABLE (custid int, RoleID TINYINT, isfinished bit default 0)
	INSERT INTO @Customer (custid)
	SELECT value 
	FROM string_split(@CustIDs,',') t
	
	DELETE FROM @Customer WHERE ISNULL(custid,0) = 0

	UPDATE t
	SET t.RoleID = c.roleid
	FROM @Customer t
			INNER JOIN Customer c WITH(NOLOCK) 
				ON t.custid = c.custID

	IF @IsRollbackFullLine = 1
	BEGIN
		INSERT INTO @Customer(custid,RoleID)
		SELECT c.custid,c.roleid
		FROM @Customer t
			INNER JOIN Customer c WITH(NOLOCK) 
				ON t.custid = c.srecommend
		WHERE c.roleid IN (1,2,3)
	END

	DECLARE @custid INT, @roleid TINYINT

	WHILE 1 = 1
	BEGIN
		SELECT @custid = custid, @roleid = RoleID
		FROM @Customer t
		WHERE isfinished = 0	
		ORDER BY t.custid DESC

		IF @@ROWCOUNT = 0
			BREAK;

		EXEC Acc_Dep_CustomerInsSetting_Rollback @CustID = @CustID, @RoleID = @roleid
		EXEC Acc_Dep_CustomerInsUserInfo_Rollback @CustID = @CustID

		UPDATE @Customer
		SET isfinished = 1 
		WHERE custid = @custid
	END
END	
GO
