/*<info serverAlias="DBCUST-CUSTDB" executers="wsv_nap" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_CheckExistedAccount]
(
	@username	varchar(30),
	@RoleID		TINYINT = NULL,
	@CustID		INT = NULL OUTPUT
)	
AS
/*
Created: 20220301@Eden
Task : Check Existed deposit Account
DB: DBCUST.CUSTDB
Original:

Revisions:
	- 20220301@Eden: Deposit - Sportsbook - Revise customer settings [Redmine: #167898] 
	
Param's Explanation:

Examples:
	DECLARE @CustID INT
	EXEC [Acc_Dep_CheckExistedAccount] 
		@username = '12BETUUS01'
		,@RoleID = 2
		,@CustID = @CustID OUT
	SELECT @CustID

*/
BEGIN
	SET NOCOUNT ON

	IF @RoleID IS NULL
	BEGIN
		SELECT @CustID = c.custid
		FROM custinfo c WITH(NOLOCK)
			INNER JOIN Dep_CustSuper s WITH(NOLOCK) ON c.srecommend = s.custid
		WHERE c.username = @username
				
	END
	ELSE
	BEGIN
		SELECT @CustID = c.custid
		FROM custinfo c WITH(NOLOCK)
			INNER JOIN Dep_CustSuper s WITH(NOLOCK) ON c.srecommend = s.custid
		WHERE c.username = @username
			AND c.roleid = @RoleID
	END
END
GO
