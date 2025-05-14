/*<info serverAlias="DBSHADOW-CustDB" executers="asv_cust" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[API_CustomerIns_SabaCheck]
	@SabaID		BIGINT, 
	@CustID		INT,
	@CustType	TINYINT,
	@IsTest		BIT = 0 OUTPUT,
	@ErrCode	INT = 0 OUTPUT,
	@ErrMsg		NVARCHAR(2000) = '' OUTPUT
AS
/*    
	Created: 20241230@Tacy 
	Task : Saba Coins - Phase 2 - Support multiple wallets
	DB: DBSHADOW/CustDB    
	    
	Revisions:  
		- 20241230@Tacy: Create SP [Redmine: #215807]

	Param's Explanation:
		@CustType = 0 ~ Real member
					1 ~ Shadow member

*/
BEGIN
	SET NOCOUNT ON;

	--Invalid SabaID
	IF ISNULL(@SabaID,0)=0
	BEGIN
		SELECT @ErrMsg = 'Invalid wallet ID.', @ErrCode = 11      
		RETURN
	END
	
	IF NOT EXISTS (SELECT TOP 1 1 FROM Dep_CustSabaInfo WITH (NOLOCK) WHERE SabaID=@SabaID AND CustType=1)
	BEGIN
		IF @CustType=0
		BEGIN --not exists Shadow mapping with Saba wallet
			SELECT @ErrMsg = 'This wallet ID has not been associated with any Shadow member yet.', @ErrCode = 12      
			RETURN
		END
		ELSE
		BEGIN -- 1st mapping shadow
			SELECT @IsTest = CASE WHEN c.currency=72 THEN 1 ELSE 0 END
			FROM Customer c WITH (NOLOCK)
			WHERE c.custid=@CustID
		END
	END
	ELSE
	BEGIN
		SELECT TOP 1 
				@IsTest = CASE WHEN c.currency=72 THEN 1 ELSE 0 END
		FROM Dep_CustSabaInfo sb WITH (NOLOCK)
		INNER JOIN Customer c WITH (NOLOCK) ON c.custid=sb.CustID
		WHERE CustType=1 AND SabaID=@SabaID
	END
END
GO