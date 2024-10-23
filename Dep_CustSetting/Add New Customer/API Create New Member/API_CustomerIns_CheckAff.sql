/*<info serverAlias="DBAFF12BET-Affiliate_12Bet" executers="asv_cust" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[API_CustomerIns_CheckAff]
	@AffiliateID INT = NULL,
	--@BonusCode VARCHAR(20) = NULL,
	@ErrCode INT = 0 OUTPUT,
	@ErrMsg NVARCHAR(2000) = '' OUTPUT	
AS
/*
	Created: 20240705@Eden  
	Task : First Deposit --> Check Affiliate BonusCode
	DB:  DBAFF12BET-Affiliate_12Bet
	Original sp: 
	
	Revisions: 
		- 20240705@Eden  : Scale out DBCUST - Licensee Customer in GlobCustDB [redmine: #207474]

	Param's Explanation: 
	
	Examples:
		DECLARE @AffiliateID INT = 1031039,
				@ErrCode INT = 0 ,
				@ErrMsg NVARCHAR(2000) = ''
				
		EXEC [API_CustomerIns_CheckAff]
			@AffiliateID = @AffiliateID OUTPUT,
			--@BonusCode = 'test',
			@ErrCode = @ErrCode OUTPUT,
			@ErrMsg = @ErrMsg OUTPUT	

		SELECT @ErrCode, @ErrMsg, @AffiliateID

*/	
BEGIN
	SET NOCOUNT ON

	--IF (ISNULL(@AffiliateID, 0) = 0 AND @BonusCode IS NOT NULL)       
	--BEGIN       
	--	SELECT @AffiliateID = AffID 
	--	FROM dbo.AffDetail WITH(NOLOCK) WHERE bonuscode = @BonusCode        
	--END    
	
	IF ISNULL(@AffiliateID,0) > 0      
	BEGIN      
		IF NOT EXISTS(SELECT 1 FROM dbo.AffInfo with(nolock) where AffID = @AffiliateID)        
		BEGIN      
			SELECT @ErrMsg = 'Invalid Affiliate agent.'
				 , @ErrCode = 12   
			
			RETURN      
		END       
	END    
END	