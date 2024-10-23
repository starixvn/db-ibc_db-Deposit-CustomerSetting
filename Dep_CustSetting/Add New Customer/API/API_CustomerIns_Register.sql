/*<info serverAlias="DBGLOB-GlobCustDB" executers="asv_cust,wsv_nap" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[API_CustomerIns_Register]
	@Username VARCHAR(30),
	@UserName2 VARCHAR(50) = NULL,
	@UplineID INT = 0,
	@roleid TINYINT, -- roleid of New account
	@site VARCHAR(10) = NULL, 
	@Currency INT = NULL,
	@SiteDBGroupID	SMALLINT = 0,
	@ErrCode INT = 0 OUTPUT,
	@ErrMsg NVARCHAR(2000) = '' OUTPUT,
	@CustID	INT = NULL OUTPUT,
	@ErrExtraInfo VARCHAR(MAX) = '' OUTPUT -- Log DB
AS
/*
	Created: 20240705@Eden  
	Task : Insert new account--> Register Username/username2 on DBGLOB
	DB:  DBGLOB-GlobCustDB
	Original sp: 
	
	Revisions: 
		- 20240705@Eden  : Scale out DBCUST - Licensee Customer in GlobCustDB [redmine: #207474]
		- 20240920@Helios  : Scale out DBCUST - Licensee Customer in GlobCustDB - Open Code Released [redmine: #207474]

	Param's Explanation: 
	Examples:
	    DECLARE @CustID	INT = NULL,
				@ErrCode INT = 0,
				@ErrMsg NVARCHAR(2000) = ''
		EXEC [API_CustomerIns_Register]
			 @UserName		= 'sabacoinsSBC01S117835055'
			,@UserName2		= 'sabacoins$117835055'
			,@recommend		= 117835401
			,@roleid		= 1
			,@SiteDBGroupID	= 0
			,@CustID		= @CustID OUT
			,@ErrCode		= @ErrCode OUT
			,@ErrMsg		= @ErrMsg OUT

		SELECT  @CustID	AS  CustID
			   ,@ErrCode AS ErrCode
			   ,@ErrMsg	AS ErrMsg
*/	
BEGIN
	SET NOCOUNT ON 

	--Check exist username/username2
	IF EXISTS(SELECT 1 FROM CustInfoMini WITH(NOLOCK) WHERE username = @username)  
		OR EXISTS(SELECT 1 FROM CustInfoMini WITH (NOLOCK) WHERE username2 = @username)  
		OR EXISTS(SELECT 1 FROM CustSubMini WITH (NOLOCK) WHERE username = @username)  
		OR EXISTS(SELECT 1 FROM CustSubMini WITH (NOLOCK) WHERE username2 = @username)
		--username2
		OR EXISTS(SELECT 1 FROM CustInfoMini WITH(NOLOCK) WHERE username = @username2)  
		OR EXISTS(SELECT 1 FROM CustInfoMini WITH (NOLOCK) WHERE username2 = @username2)  
		OR EXISTS(SELECT 1 FROM CustSubMini WITH (NOLOCK) WHERE username = @username2)  
		OR EXISTS(SELECT 1 FROM CustSubMini WITH (NOLOCK) WHERE username2 = @username2) 
	BEGIN
		SELECT @ErrMsg = 'The username is not available.'
			, @ErrCode = 11

		RETURN
	END

	-----------Generate systemid (username)---------------
	DECLARE @recommend INT = 0,
		@mrecommend INT = 0,
		@srecommend INT = 0

	IF @roleid = 1
	BEGIN
		SELECT @recommend = recommend,
			@mrecommend = mrecommend,
			@srecommend = srecommend,
			@Currency = Currency
		FROM dbo.CustInfoMini WITH(NOLOCK)    
		WHERE custid = @UplineID 
	END
	ELSE IF @roleid = 2
	BEGIN
		SELECT @mrecommend = mrecommend,
			@srecommend = srecommend,
			@Currency = Currency
		FROM dbo.CustInfoMini WITH(NOLOCK)    
		WHERE custid = @UplineID 
	END
	ELSE IF @roleid = 3
	BEGIN
		SELECT @srecommend = srecommend,
			@Currency = Currency
		FROM dbo.CustInfoMini WITH(NOLOCK)    
		WHERE custid = @UplineID 
	END
	-----------Insert to CustInfoMini-------------
	BEGIN TRY
	
		IF @roleid = 4   
			SET @srecommend = @CustID
		ELSE IF @roleid = 3
			SET @mrecommend = @CustID
		ELSE IF @roleid = 2
			SET @recommend = @CustID

		--Code for production version
		INSERT INTO dbo.CustInfoMini(username,username2,recommend, mrecommend,srecommend,roleid,SiteDBGroupID,Site, Currency)
		SELECT @Username, @UserName2, @recommend,@mrecommend, @srecommend, @roleid, @SiteDBGroupID, @site, @Currency
		
		SET @custid = SCOPE_IDENTITY()  

		IF @roleid = 4 
		BEGIN
			UPDATE CustInfoMini WITH(ROWLOCK,UPDLOCK)
			SET srecommend = @CustID
			,	RepUpdateTime = SYSDATETIME ()
			WHERE custid = @CustID
		END
		ELSE IF @roleid = 3 
		BEGIN
			UPDATE CustInfoMini WITH(ROWLOCK,UPDLOCK)
			SET mrecommend = @CustID
			,	RepUpdateTime = SYSDATETIME ()
			WHERE custid = @CustID
		END
		ELSE IF @roleid = 2 
		BEGIN
			UPDATE CustInfoMini WITH(ROWLOCK,UPDLOCK)
			SET recommend = @CustID
			,	RepUpdateTime = SYSDATETIME ()
			WHERE custid = @CustID
		END
		
	END TRY
	BEGIN CATCH  
		SELECT @ErrCode = 911 ,
			@ErrMsg = 'Create customer failed. Please try again.',
			@ErrExtraInfo = ERROR_MESSAGE ()

		RETURN
	END CATCH  
END	