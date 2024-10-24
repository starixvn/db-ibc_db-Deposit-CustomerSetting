/*<info serverAlias="DBSID-bodb02" executers="asv_cust" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Dot_Dep_Customer_Archive_ReactiveCustomer_Trans]
	@CustID int = 0,  
	@CustIDBalanceDummy INT = NULL,
	@ClosingBalance MONEY = NULL,
	@ErrCode int = 0 OUTPUT,    
	@ErrMsg nvarchar(2000) = '' OUTPUT
AS       
/*    
	Created: 20220829@Eden   
	Task : Insert balance tables and reinit balance when reactive archived member
	DB: DBTXN-bodb02    
	    
	Revisions:    
		- 20220829@Eden: LAP - Scale Out DBTrans  [redmine: #158293/#175297]
		- 20221227@Eden: Add waiting time before reinit balance  [redmine: #182048]
		- 20240705@Eden: Scale out DBCUST [redmine: #207474]

	Param's Explanation:    
	- @CustID: return old deposit member CustID    
	- @CustIDBalanceDummy: Dummy Balance custid
	- @ClosingBalance: Closing balance( captured when archived customer)
	    
	? @ErrCode:    
	 = 0: Transaction recorded successfully.    
	 > 0: Specific Error.    
	     
	? @ErrMsg: Error description.    
*/ 
BEGIN
	SET NOCOUNT ON    
	--Add waiting 3s before reinit Balance in Reactivate process (wait tranfer done to avoid duplicate error)
	WAITFOR DELAY '00:00:03'
	
	IF NOT EXISTS( SELECT TOP 1 1 FROM dbo.BalCreditSports WITH(NOLOCK) WHERE custid = @CustID)
	BEGIN
		EXEC dbo.Dot_BalanceCreditInitialize @CustID = @CustID, @errCode = @ErrCode OUTPUT 
		
		IF @ErrCode <> 0    
		BEGIN      
			EXEC dbo.Dot_BalanceCreditRemove @CustID = @CustID
			GOTO RETURNTBL;    
		END 
	END

	IF NOT EXISTS( SELECT TOP 1 1 FROM dbo.BalDebitSports WITH(NOLOCK) WHERE custid = @CustID)
	BEGIN 
		EXEC dbo.Dot_BalanceDebitInitialize @CustID = @CustID, @errCode = @ErrCode OUTPUT

		IF @ErrCode <> 0
		BEGIN      
			EXEC dbo.Dot_BalanceCreditRemove @CustID = @CustID 
			EXEC dbo.Dot_BalanceDebitRemove @CustID = @CustID
			GOTO RETURNTBL;    
		END 
	END

	IF ISNULL(@ClosingBalance,0) = 0 OR ISNULL(@CustIDBalanceDummy,0) = 0
		GOTO RETURNTBL;
	
	-- Reinit balance
	IF @ClosingBalance > 0
	BEGIN
		EXEC dbo.Dot_Int_BettransInsTransactionWithoutLog_Cust
						@custid=@CustID,
						@amount= @ClosingBalance,
						@bal_custid=@CustIDBalanceDummy,
						@Bettype = 23203,
						@transdesc = 'Reinit old member balance in deposit reactivation process',
						@ErrCode= @ErrCode OUTPUT,
						@ErrMsg= @ErrMsg OUTPUT
	END
	ELSE
	BEGIN
		EXEC dbo.Dot_Int_BettransInsTransactionWithoutLog_Cust
						@custid=@CustID,
						@amount= @ClosingBalance,
						@bal_custid=@CustIDBalanceDummy,
						@Bettype = 23203,
						@transdesc = 'Reinit old member balance in deposit reactivation process',
						@IsCharge = 1, --Not check negative balance
						@ErrCode= @ErrCode OUTPUT,
						@ErrMsg= @ErrMsg OUTPUT
	END

	IF @ErrCode <> 0
	BEGIN      
		EXEC dbo.Dot_BalanceCreditRemove @CustID = @CustID 
		EXEC dbo.Dot_BalanceDebitRemove @CustID = @CustID
		GOTO RETURNTBL;    
	END 
	
	RETURNTBL:
	IF @ErrCode <> 0
	BEGIN
		SET @ErrMsg = @ErrMsg + ' (@CustIDBalanceDummy = ' + CONVERT(VARCHAR(15),@CustIDBalanceDummy) +', @ClosingBalance =  ' + CONVERT(VARCHAR(20),@ClosingBalance,2) + ')'

		SELECT @custID as CustID, 
				'REACTIVATION' as Action, 
				'Failed' as Status,
				@ErrMsg as Message
	END		
END
GO 

