/*<info serverAlias="DBGLOB-GlobCustDB" executers="asv_cust,ow_12bet" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[API_CustomerIns_Generate]
	@UserName2 VARCHAR(50) ,
	@recommend INT,
	@SiteDBGroupID	SMALLINT = 0,
	@Site VARCHAR(10), --12Bet, Spondemo ...
	@CurrencyName NVARCHAR(50), --UUS, UT...
	@ErrCode INT = 0 OUTPUT,
	@ErrMsg NVARCHAR(2000) = '' OUTPUT,
	@CustID	INT = NULL OUTPUT,
	@Username VARCHAR(30) = NULL OUTPUT,
	@ErrExtraInfo VARCHAR(MAX) = '' OUTPUT, -- Log DB
	@RetryNumber TINYINT = 0
AS
/*
	Created: 20240705@Eden  
	Task : First Deposit --> Generate and Register Username on DBGLOB
	DB:  DBGLOB-GlobCustDB
	Original sp: 
	
	Revisions: 
		- 20240705@Eden  : Scale out DBCUST - Licensee Customer in GlobCustDB [redmine: #207474]  
		- 20240920@Helios  : Scale out DBCUST - Licensee Customer in GlobCustDB - Modified OddsBoostAdj [redmine: #207474] 
	Param's Explanation: 
		@RetryNumber: 0 Normal, <> 0 Retry
	Examples:
	    DECLARE @UserName2 NVARCHAR(50) = '12Edentest',
				@recommend INT = 791083,
				@SiteDBGroupID	SMALLINT = 0,
				@Site VARCHAR(10) = '12Bet', --12Bet, Spondemo ...
				@CurrencyName NVARCHAR(50) = 'US$', --UUS, UT...
				@CustID	INT = NULL ,
				@Username VARCHAR(30) = NULL, 
				@ErrCode INT = 0,
				@ErrMsg NVARCHAR(2000) = '',
				@ErrExtraInfo VARCHAR(MAX) = ''
		EXEC [API_CustomerIns_Generate]
			 @UserName2		= @UserName2
			,@recommend		= @recommend
			,@SiteDBGroupID	= @SiteDBGroupID
			,@Site			= @Site
			,@CurrencyName	= @CurrencyName
			,@CustID		= @CustID OUT
			,@Username		= @Username OUT
			,@ErrCode		= @ErrCode OUT
			,@ErrMsg		= @ErrMsg OUT
			,@ErrExtraInfo = @ErrExtraInfo OUT

		SELECT  @CustID	AS  CustID
			   ,@Username AS Username
			   ,@ErrCode AS ErrCode
			   ,@ErrMsg	AS ErrMsg
			   ,@ErrExtraInfo AS Err_ExtraInfo
*/	
BEGIN
	SET NOCOUNT ON 
	DECLARE @Retry TINYINT = 0, @Err INT

	BEGIN TRY
		IF @RetryNumber <> 0 -- Incase username does not exist in CustInfoMini but exists in Customer/CustInfo
		BEGIN
			UPDATE cm 
			SET 
				cm.username2 = NULL
			,	RepUpdateTime = SYSDATETIME ()
			FROM CustInfoMini cm WITH (ROWLOCK)
			WHERE cm.CustID = @CustID AND cm.username2 = @UserName2
		END 
	END TRY
	BEGIN CATCH  
		SELECT @ErrCode = 13 ,
			@ErrMsg = 'Can not generate username.',
			@ErrExtraInfo = ERROR_MESSAGE (),
			@Err = @@ERROR
	END CATCH  

	RegisterFlow: --Full flow Register new player

	SELECT @ErrCode = 0, @ErrMsg = '', @Err = 0, @ErrExtraInfo = ''

	--Check exist username2
	IF EXISTS(SELECT 1 FROM CustInfoMini WITH(NOLOCK) WHERE username = @username2)  
		OR EXISTS(SELECT 1 FROM CustInfoMini WITH (NOLOCK) WHERE username2 = @username2)  
		OR EXISTS(SELECT 1 FROM CustSubMini WITH (NOLOCK) WHERE username = @username2)  
		OR EXISTS(SELECT 1 FROM CustSubMini WITH (NOLOCK) WHERE username2 = @username2)  
	BEGIN
		SELECT @ErrMsg = 'The username is not available.'
			, @ErrCode = 11

		RETURN
	END

	-----------Generate systemid (username)---------------
	DECLARE @recommendUsername VARCHAR(50), 
		@NumOfMem INT, 
		@MaxCustID INT, 
		@UsernameOddAdj VARCHAR(30),
		@LimitLoop INT, 
		@Index INT,
		@NumTmp VARCHAR(10),
		@mrecommend INT,
		@srecommend INT,
		@Currency INT

	SELECT @LimitLoop = 900, @Index = 0, @Username = ''  

	SELECT @recommendUsername = username,
		@mrecommend = mrecommend,
		@srecommend = srecommend,
		@Currency = Currency
	FROM dbo.CustInfoMini WITH(NOLOCK)    
	WHERE custid = @recommend 

	SELECT TOP (1)  @MaxCustID = CustID
	FROM dbo.CustInfoMini WITH(NOLOCK)     
	WHERE  (username LIKE @recommendUsername + '%'   
				OR username LIKE @recommendUsername + 'S' + '%'  
			)  
		AND username NOT LIKE @recommendUsername+'%'+'BetTrade'    
		AND username NOT LIKE @recommendUsername+'%'+'CashOut'  
		AND username NOT LIKE @recommendUsername+'%'+'ClearBal'    
		AND username NOT LIKE ISNULL(@site + @CurrencyName + '01OddsAdj' ,'') 
		AND username NOT LIKE ISNULL(@site + @CurrencyName + '01OddsBoostAdj' ,'') 
		AND recommend = @recommend  
		AND CustID <> @recommend
	ORDER BY custID DESC

	SELECT @NumOfMem = ISNULL(CAST(CASE WHEN CHARINDEX('S',REPLACE(username, @recommendUsername, '')) = 0   
										THEN REPLACE(username, @recommendUsername, '')  
									ELSE REPLACE(username, @recommendUsername+ 'S', '') END  
		AS INT), 0)    
	FROM dbo.CustInfoMini WITH(NOLOCK)    
	WHERE custid = @MaxCustID

	SELECT @NumTmp = CAST(@NumOfMem AS VARCHAR(10))  
	IF @NumOfMem IS NULL --for case new agent  
	BEGIN  
		SET @NumOfMem = 0  
	END  

	--Loop to generate and check exist username
	WHILE 1 = 1  
	BEGIN  
		SET @Username = ''  
		--increase num of member  
		SET @NumOfMem = @NumOfMem + 1  
  
		IF LEN(@NumOfMem) < 3  
		BEGIN  
			SET @NumTmp = RIGHT('00' + CAST(@NumOfMem AS VARCHAR(10)), 3)  
		END  
		ELSE  
		BEGIN  
			SET @NumTmp = CAST(@NumOfMem AS VARCHAR(10))  
		END  
  
		SELECT @UserName = @recommendUsername + 'S' + @NumTmp  
		SELECT @UserName = REPLACE(@UserName, ' ', '')  

		--check username exists or not?  	 
		IF NOT EXISTS(SELECT 1 FROM CustInfoMini WITH(NOLOCK) WHERE username = @username)  
			AND NOT EXISTS(SELECT 1 FROM CustInfoMini WITH (NOLOCK) WHERE username2 = @username)  
			AND NOT EXISTS(SELECT 1 FROM CustSubMini WITH (NOLOCK) WHERE username = @username)  
			AND NOT EXISTS(SELECT 1 FROM CustSubMini WITH (NOLOCK) WHERE username2 = @username)  
		BEGIN
			BREAK; -- accept this username
		END
  
		IF @Index > @LimitLoop  
		BEGIN  
			SET @Username = ''
			BREAK; 
		END  
  
		SET @Index = @Index + 1  
	END  

	IF ISNULL(@UserName,'') = ''      
	BEGIN      
		SELECT @ErrMsg = 'Can not generate username.'      
			,@ErrCode = 13      
       
		RETURN      
	END   
	-----------Insert to CustInfoMini-------------
	BEGIN TRY
	
		--Code for production version
		INSERT INTO dbo.CustInfoMini(username,username2,recommend, mrecommend,srecommend,roleid,SiteDBGroupID, Site, Currency)
		SELECT @Username, @UserName2, @recommend,@mrecommend, @srecommend, 1, @SiteDBGroupID, @Site, @Currency

		
		SET @custid = SCOPE_IDENTITY()  
		
	END TRY
	BEGIN CATCH  
		SELECT @ErrCode = 911 ,
			@ErrMsg = 'Create customer failed. Please try again.',
			@ErrExtraInfo = ERROR_MESSAGE (),
			@Err = @@ERROR

		IF @Err = 2627 --- duplicate username
		BEGIN
			SET @Retry = @Retry + 1
			IF @Retry <= 3 -- Retry max 3 times
				GOTO RegisterFlow;
			ELSE
				RETURN
		END	
	END CATCH  
END	