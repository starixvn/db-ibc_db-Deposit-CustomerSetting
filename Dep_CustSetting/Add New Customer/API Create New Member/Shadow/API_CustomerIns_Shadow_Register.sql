/*<info serverAlias="DBGlob-GlobCustDB" executers="asv_cust" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[API_CustomerIns_Shadow_Register]
	@RealCustID INT,    
	@AgentID INT,     
	@SiteDBGroupID	SMALLINT = 0,
	@CustID	INT = NULL OUTPUT,
	@Username VARCHAR(30) = '' OUTPUT,  
	@Username2 VARCHAR(50) = '' OUTPUT,  
	@ErrCode INT = 0 OUTPUT,    
	@ErrMsg NVARCHAR(2000) = '' OUTPUT,
	@ErrExtraInfo VARCHAR(MAX) = '' OUTPUT -- Log DB
AS
/*
	Created: 20240705@Eden  
	Task : Shadow member --> Validate data before insert new customer, and register member
	DB:  DBGlob-GlobCustDB
	Original sp: 
	
	Revisions: 
		- 20240705@Eden  : Scale out DBCUST - Licensee Customer in GlobCustDB [redmine: #207474]

	Param's Explanation: 
		DECLARE @UserName VARCHAR(30) = NULL,
				@UserName2 VARCHAR(50) = NULL ,
				@CustID	INT = NULL,
				@ErrCode INT = 0 ,
				@ErrMsg NVARCHAR(2000) = ''
		EXEC [API_CustomerIns_Shadow_Register]
			 @RealCustID		= 117835063
			,@AgentID			= 117835401
			,@SiteDBGroupID	    = 0
			,@CustID			= @CustID OUT
			,@UserName2			= @UserName2 OUTPUT
			,@UserName			= @UserName OUTPUT
			,@ErrCode			= @ErrCode OUTPUT
			,@ErrMsg			= @ErrMsg OUTPUT

		SELECT   @CustID		AS CustID
				,@UserName		AS UserName			
				,@UserName2		AS UserName2						
				,@ErrCode		AS ErrCode		
				,@ErrMsg		AS ErrMsg
*/			   				
BEGIN
	SET NOCOUNT ON

	DECLARE	 @CustCurrency INT,	--currency's real cust
			 @recommend INT,
			 @site VARCHAR(10), 
			 @recommendUsername VARCHAR(30),
			 @Currency INT

	SELECT @CustCurrency = currency
	FROM CustInfoMini c WITH (NOLOCK)
	WHERE custid = @RealCustID
		AND roleid = 1 
		AND site <> 'SabaCoins'

	IF @CustCurrency IS NULL
	BEGIN
		SET @ErrCode=99
		SET @ErrMsg='Invalid member.'
		
		RETURN
	END

	SELECT @recommend = c.custID,  
		   @recommendUsername = c.username,   
		   @site    = c.site,
		   @Currency = c.currency
	FROM CustInfoMini c WITH(NOLOCK)
	WHERE c.CustID = @AgentID 
		AND c.roleid = 2 
		AND c.site = 'SabaCoins' 
		AND c.currency = CASE WHEN @CustCurrency <> 20 THEN 213 --SBC
							 ELSE 72 END --YNG : for TEST
	     
	--check valid agent here    
	IF @recommend IS NULL    
	BEGIN    
		SELECT @ErrMsg = 'Invalid agent.', @ErrCode = 10    
		RETURN    
	END      

	--Generate Username, username2
	SELECT @UserName = @recommendUsername + 'S' + CAST(@RealCustID AS varchar(30))  
	SELECT @UserName2 = @site  + '$' + CAST(@RealCustID AS varchar(30))   

	EXEC [API_CustomerIns_Register]
			 @UserName		= @UserName
			,@UserName2		= @UserName2
			,@Uplineid		= @recommend
			,@roleid		= 1
			,@SiteDBGroupID	= @SiteDBGroupID
			,@site			= @site
			,@Currency		= @Currency
			,@CustID		= @CustID OUT
			,@ErrCode		= @ErrCode OUT
			,@ErrMsg		= @ErrMsg OUT
			,@ErrExtraInfo  = @ErrExtraInfo OUT
END	
GO