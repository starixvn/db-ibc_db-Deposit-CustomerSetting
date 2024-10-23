/*<info serverAlias="DBCUST-CustDB" executers="asv_cust" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[API_CustomerIns_Validate]
	@DepositUserName VARCHAR(50),
	@AgentID INT,
	--@AffiliateID INT = NULL,
	--@BonusCode VARCHAR(20) = NULL,
	@ErrCode INT = 0 OUTPUT,
	@ErrMsg NVARCHAR(2000) = '' OUTPUT,
	@CurrencyName NVARCHAR(50) = NULL OUTPUT, --UUS, UT...
	@Site VARCHAR(10) = NULL OUTPUT, --12Bet, Spondemo ...
	@UserName2 VARCHAR(50) = NULL OUTPUT,
	@recommend INT = NULL OUTPUT
AS
/*
	Created: 20240705@Eden  
	Task : First Deposit --> Validate data before insert new customer
	DB:  DBCUST-CustDB
	Original sp: 
	
	Revisions: 
		- 20240705@Eden  : Scale out DBCUST - Licensee Customer in GlobCustDB [redmine: #207474]

	Param's Explanation: 
		DECLARE @DepositUserName NVARCHAR(50) = 'Edentest',
				@AgentID INT = 836210,
				--@AffiliateID INT = NULL,
				--@BonusCode VARCHAR(20) = NULL,
				@UserName2 NVARCHAR(50) = NULL ,
				@recommend INT = NULL ,
				@Site VARCHAR(10) = NULL , --12Bet, Spondemo ...
				@CurrencyName NVARCHAR(50) = NULL , --UUS, UT...
				@ErrCode INT = 0 ,
				@ErrMsg NVARCHAR(2000) = '' 
		EXEC [API_CustomerIns_Validate]
			@DepositUserName	= @DepositUserName
			,@AgentID			= @AgentID
			--,@AffiliateID		= @AffiliateID
			--,@BonusCode			= @BonusCode
			,@UserName2			= @UserName2 OUTPUT
			,@recommend			= @recommend OUTPUT
			,@Site				= @Site OUTPUT
			,@CurrencyName		= @CurrencyName OUTPUT
			,@ErrCode			= @ErrCode OUTPUT
			,@ErrMsg			= @ErrMsg OUTPUT

		SELECT  @UserName2		AS UserName2			
				,@recommend		AS recommend			
				,@Site			AS Site				
				,@CurrencyName	AS CurrencyName		
				,@ErrCode		AS ErrCode		
				,@ErrMsg		AS ErrMsg
*/			   				
BEGIN
	SET NOCOUNT ON
	----------------Affiliate Bonus Code--------------------
	--IF ISNULL(@AffiliateID,0) > 0 AND @BonusCode IS NOT NULL -- @bonuscode is valid, change currency agent from [..]01 --> [..]02      
	--BEGIN      
	--	DECLARE @_currAgentName VARCHAR(20)      
	--	SELECT @_currAgentName = username FROM Custinfo WITH(NOLOCK) WHERE custid = @AgentID        
	--	SELECT @AgentID = CustID FROM CustInfo WITH(NOLOCK) WHERE username = Replace(@_currAgentName, '01', '02')    
	--END     

	-------------------------------------  
	DECLARE  @currency INT,              
		@srecommend INT

	SELECT @srecommend = ci.srecommend,            
		@recommend = ci.custID,          
		@currency = ci.currency,          
		@site    = c.site
	FROM custinfo ci WITH(NOLOCK)       
		INNER JOIN customer c WITH(NOLOCK) 
			ON ci.custid = c.custid      
	WHERE ci.CustID = @AgentID 
		AND ci.roleid = 2    

	IF @recommend IS NULL      
	BEGIN      
		SELECT @ErrMsg = 'Invalid agent.', @ErrCode = 10      
		RETURN      
	END  

	SELECT @CurrencyName = currency
	FROM exchange WITH(NOLOCK) 
	WHERE ExchangeId = @currency

	SELECT @ErrCode = 0 , @ErrMsg = ''  
	
	----> Check Betlimit SB + NG
	--EXEC dbo.Acc_Dep_CustSetting_Game_Check    
	--	 @custid	= NULL,    
	--	 @AgentID	= @AgentID,    
	--	 @Site		= @Site,    
	--	 @Currency	= @Currency,    
	--	 @ProductID = NULL,    
	--	 @SuperID	= @srecommend,    
	--	 @ErrCode	= @ErrCode OUTPUT,    	   
	--	 @ErrMsg	= @ErrMsg OUTPUT

	--IF @ErrCode <> 0
	--	RETURN
		 
	--SELECT @ErrCode = 0 , @ErrMsg = ''   
	
	----> Check Betlimit Other DCS Products
	--EXEC dbo.Acc_Dep_CustSetting_Check    
	--	 @custid	= NULL,    
	--	 @AgentID	= @AgentID,    
	--	 @Site		= @Site,    
	--	 @Currency	= @Currency,    
	--	 @ProductID = NULL,    
	--	 @SuperID	= @srecommend,    
	--	 @ErrCode	= @ErrCode OUTPUT,    	   
	--	 @ErrMsg	= @ErrMsg OUTPUT

	--IF @ErrCode <> 0
	--	RETURN

	----Set Username2
	SELECT @UserName2 = @site + '$' + @DepositUserName  
END	