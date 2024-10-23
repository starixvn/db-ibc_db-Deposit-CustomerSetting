/*<info serverAlias="DBCUST-bodb_Licensee" executers="asv_cust" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[API_CustomerIns_DefaultComm_LicenseeDB](
	 @Site		VARCHAR(10)
	,@CustID	INT
	,@GroupDiscountID INT = 0
	,@ErrCode	INT = 0 OUTPUT
	,@ErrMsg	VARCHAR(2000) = '' OUTPUT
)
AS
/*
	Created: 20240705@Eden  
	Task : First Deposit --> Insert default group comm on Licensee DB
	DB:  DBCUST-bodb_Licensee
	Original sp: 
	
	Revisions: 
		- 20240705@Eden  : Scale out DBCUST - Licensee Customer in GlobCustDB [redmine: #207474]

	Param's Explanation: 
	Examples:
		DECLARE @ErrCode INT = 0, @ErrMsg	VARCHAR(2000) = '' 

		EXEC [API_CustomerIns_DefaultComm_LicenseeDB] 
			 @Site = 'Athena000'
			,@CustID = 123
			,@GroupDiscountID = 193
			,@ErrCode	= @ErrCode	OUT
			,@ErrMsg	= @ErrMsg OUT

		SELECT @ErrCode ,@ErrMsg

*/			   				
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		DECLARE	@LicenseeID INT

		IF ISNULL(@GroupDiscountID,0) = 0
			RETURN

		--Get LicenseeID  
		SELECT @LicenseeID = LicenseeID   
		FROM Licensees WITH (NOLOCK)   
		WHERE LicenseeName = @Site  

		IF ISNULL(@LicenseeID,0) = 0 -- Invalid Licensee
			RETURN

		--Insert LicenseeCustDiscount(Update when exist, process for concurrency)
		INSERT INTO LicenseeCustDiscount(LicenseeID,CustID,GroupDiscountID)
		SELECT @LicenseeID, @CustID, @GroupDiscountID
		WHERE NOT EXISTS( SELECT 1 FROM LicenseeCustDiscount WITH(HOLDLOCK,UPDLOCK) WHERE custid = @CustID)

		IF @@ROWCOUNT = 0
		BEGIN
			UPDATE  t
			SET t.LicenseeID = @LicenseeID,
				t.GroupDiscountID = @GroupDiscountID
			FROM LicenseeCustDiscount t WITH(ROWLOCK,UPDLOCK)
			WHERE t.CustID = @CustID
		END
	END TRY
	BEGIN CATCH
		SELECT @ErrCode	= 951
			   ,@ErrMsg	= ERROR_MESSAGE()

		RETURN
	END CATCH

END	
GO
