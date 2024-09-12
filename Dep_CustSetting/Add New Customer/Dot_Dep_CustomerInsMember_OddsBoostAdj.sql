/*<info serverAlias="DBCust-CustDB" executers="svc_tig" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Dot_Dep_CustomerInsMember_OddsBoostAdj]
	@Custid			INT OUTPUT,
	@Creator		INT,
	@sitename		VARCHAR(10),
	@Currency		INT,
	@IP				VARCHAR(15)='',
	@ErrCode		INT = 0 OUTPUT,
	@ErrMsg			NVARCHAR(4000) = '' OUTPUT,
	@Username		VARCHAR(30) OUTPUT
AS
/*
	Created by: Tacy
	Task: Create Member Dummy OddsBoostAdj
	DB: DBCust/CustDB
	
	Revisions:
		- 20240911@Tacy: Create SP [redmine:#210621]

	Explanation's Param:
		
*/   
BEGIN 
	SET NOCOUNT ON

	DECLARE	@Userpwd VARCHAR(40), @Recommend INT
	
	SELECT @Userpwd = '8058095B7DDB08A608811097E5DB8D'
	
	SELECT @Recommend=c.custid
		,@Username = c.site + e.currency + '01OddsBoostAdj' 
	FROM Customer c WITH (NOLOCK)
	INNER JOIN exchange e WITH (NOLOCK) ON c.currency = e.ExchangeId
	INNER JOIN Dep_CustSuper cs WITH (NOLOCK) ON cs.custid=c.srecommend
	WHERE c.site=@sitename AND roleid=2
	AND c.currency=@Currency
	AND c.username LIKE c.site + e.currency + '01'

	EXEC Acc_Dep_CustomerInsMember_Ag
		@custid=@Custid OUTPUT,@creator=@Creator,@username=@Username,@userpwd=@Userpwd,
		@recommend=@Recommend,@IP=@IP,@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT		
END
GO