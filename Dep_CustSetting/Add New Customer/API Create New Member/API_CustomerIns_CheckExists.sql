/*<info serverAlias="DBCUST-CustDB" executers="asv_cust" viewers="" isFunction="0"></info>*/
CREATE PROCEDURE [dbo].[API_CustomerIns_CheckExists]
	@UserName	VARCHAR(30) ,
	@ErrCode	INT = 0		OUTPUT,
	@ErrMsg	NVARCHAR(2000) = '' OUTPUT
AS
/*
	Created: 25092024@Helios
	Task : First Deposit --> Validate data before insert new customer
	DB:  DBCUST-CustDB
	Original sp: 
	
	Revisions: 
		- 20240925@Helios  : Scale out DBCUST - Licensee Customer in GlobCustDB [redmine: #207474]

	Param's Explanation: 
		DECLARE
			@UserName	VARCHAR(30) = 'SuperTest1',
			@ErrCode	BIT = NULL,
			@ErrMsg	NVARCHAR(2000) = ''
		EXEC [API_CustomerIns_CheckExists] @UserName			= @UserName
							   , @ErrCode			= @ErrCode OUTPUT
							   , @ErrMsg			= @ErrMsg OUTPUT

		SELECT
			@ErrCode AS ErrCode,
			@ErrMsg  AS ErrMsg	
*/			   				
BEGIN
	SET NOCOUNT ON
	
	SELECT @ErrCode = 0, @ErrMsg = ''

	IF NOT EXISTS(SELECT 1 FROM Customer WITH(NOLOCK) WHERE username = @UserName)  
		AND NOT EXISTS(SELECT 1 FROM custInfo WITH (NOLOCK) WHERE username = @UserName)  
	BEGIN
		SELECT @ErrCode = 0	-- is follow next step
		RETURN;
	END
	ELSE
	BEGIN
		SELECT 
			@ErrCode = 911 ,	-- retry API Generate
			@ErrMsg = 'This username is existed in Customer/Custinfo.'

		RETURN;
	END
END	