/*<info serverAlias="DBARCCUST-Bodb_Archive_Customer_Licensee" executers="asv_cust" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[API_CustomerReactive_GetArchivedInfo]
	@CustID	INT,
	@Recommend INT = 0 OUTPUT,
	@ErrCode INT = 0 OUTPUT,
	@ErrMsg NVARCHAR(2000) = '' OUTPUT,
	@CustomerInfo VARCHAR(MAX) = '' OUTPUT --Json format 
AS
/*
	Created: 20240705@Eden  
	Task : Reactive Customer --> Get customer info on backup Database
	DB:  DBARCCUST-Bodb_Archive_Customer_Licensee
	Original sp: 
	
	Revisions: 
		- 20240705@Eden  : Scale out DBCUST - Licensee Customer in GlobCustDB [redmine: #207474]

	Param's Explanation: 
	Examples:
	    DECLARE @CustomerInfo VARCHAR(MAX),
				@CustID	INT = 985954,
				@ErrCode INT = 0,
				@ErrMsg NVARCHAR(2000) = ''
		EXEC [API_CustomerReactive_GetArchivedInfo]
			 @CustID		= @CustID
			,@ErrCode		= @ErrCode OUT
			,@ErrMsg		= @ErrMsg OUT
			,@CustomerInfo  = @CustomerInfo OUT

		SELECT  @CustID	AS  CustID
			   ,@ErrCode AS ErrCode
			   ,@ErrMsg	AS ErrMsg
			   ,@CustomerInfo AS CustomerInfo
*/	
BEGIN
	SET NOCOUNT ON 
	DECLARE @Username varchar(30) = ''

	SELECT @Username = username, @Recommend = Recommend
	FROM dbo.Customer WITH(NOLOCK)
	WHERE custid = @CustID

	IF ISNULL(@Username,'') = ''      
	BEGIN    
		SELECT @ErrMsg = 'This account is not a dormant member.'
			 , @ErrCode = 7

		SELECT @custID as CustID, 
			'REACTIVATION' as Action, 
			'Failed' as Status,
			'This member does not exist in Archive DB' as Message

		RETURN    
	END 

	SELECT @CustomerInfo = (
		SELECT	firstname,
				lastname,
				username,
				userpwd,
				pwdexpiry,
				phone,
				mobilephone,
				email,
				fax,
				address,
				city,
				state,
				country,
				postal,
				birthday,
				refcode1,
				remark,
				creatdate,
				username2,
				refcode2,
				recommend
		 FROM dbo.Customer WITH(NOLOCK)
		 WHERE custid = @CustID	
		 FOR JSON PATH
	 )
END	
GO