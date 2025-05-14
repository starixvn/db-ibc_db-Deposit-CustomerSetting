/*<info serverAlias="DBGlob-GlobCustDB" executers="asv_cust" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[API_CustomerIns_Shadow_Register]
	@AgentID INT,     
	@SiteDBGroupID	SMALLINT = 0,
	@CustID	INT = NULL OUTPUT,
	@Username VARCHAR(30) = '' OUTPUT,  
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
		- 20240705@Eden: Scale out DBCUST - Licensee Customer in GlobCustDB [redmine: #207474]
		- 20241219@Tacy: SabaCoins - Phase 02 [redmine: #215807]

	Param's Explanation: 
		DECLARE @UserName VARCHAR(30) = NULL,
				@CustID	INT = NULL,
				@ErrCode INT = 0 ,
				@ErrMsg NVARCHAR(2000) = ''
		EXEC [API_CustomerIns_Shadow_Register]
			 @AgentID			= 117835401
			,@SiteDBGroupID	    = 0
			,@CustID			= @CustID OUT
			,@UserName			= @UserName OUTPUT
			,@ErrCode			= @ErrCode OUTPUT
			,@ErrMsg			= @ErrMsg OUTPUT

		SELECT   @CustID		AS CustID
				,@UserName		AS UserName			
				,@ErrCode		AS ErrCode		
				,@ErrMsg		AS ErrMsg
*/			   				
BEGIN
	SET NOCOUNT ON

	DECLARE	 @recommend INT,
			 @site VARCHAR(10), 
			 @recommendUsername VARCHAR(30),
			 @Currency INT
	
	SELECT @recommend = c.custID,  
		   @recommendUsername = c.username,   
		   @site    = c.site,
		   @Currency = c.currency
	FROM CustInfoMini c WITH(NOLOCK)
	WHERE c.CustID = @AgentID 
		AND c.roleid = 2 
		AND c.site = 'SabaCoins' 
		AND c.currency IN (213	--SBC
						  , 72 )--YNG : for TEST
	     
	--check valid agent here    
	IF @recommend IS NULL    
	BEGIN    
		SELECT @ErrMsg = 'Invalid agent.', @ErrCode = 10    
		RETURN    
	END      

	--Generate Username
	SELECT @UserName = @recommendUsername + 'S' + CAST(NEXT VALUE FOR dbo.SeqUsername AS varchar(30))  

	EXEC [API_CustomerIns_Register]
			 @UserName		= @UserName
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