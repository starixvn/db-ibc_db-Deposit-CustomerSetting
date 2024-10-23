/*<info serverAlias="DBCUST-CUSTDB" executers="asv_cust" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[API_CustomerReactive_Insert]
	@CustID	INT,
	@CustomerInfo VARCHAR(MAX) = '', --Json format 
	@SubsidiaryID INT = 0,
	@DefaultComms VARCHAR(MAX)  = '',
	@GroupDiscountID INT = 0,
	@ErrCode INT = 0 OUTPUT,
	@ErrMsg NVARCHAR(2000) = '' OUTPUT,
	@CustIDBalanceDummy INT = NULL OUTPUT,
	@ClosingBalance MONEY = NULL OUTPUT,
	@ErrExtraInfo VARCHAR(MAX) = '' OUTPUT -- Log DB   
AS
/*
	Created: 20240705@Eden  
	Task : Reactive Customer --> Validate
	DB:  DBCUST-CUSTDB
	Original sp: 
	
	Revisions: 
		- 20240705@Eden  : Scale out DBCUST - Licensee Customer in GlobCustDB [redmine: #207474]
		- 20240920@Helios  : Scale out DBCUST - Licensee Customer in GlobCustDB - Modified BEGIN TRY - CATCH [redmine: #207474]
	Param's Explanation:
		
	Examples:
	    DECLARE @CustomerInfo VARCHAR(MAX) = '[{"firstname":"---","lastname":"---","username":"12BETEURO01034","userpwd":"56E8A2D78170E87C928E480797CC73","pwdexpiry":"2008-08-01T06:32:54.633","phone":"-","mobilephone":"-","email":"test@test.com","fax":"-","address":"-","city":"-","state":"-","country":"-","postal":"-","creatdate":"2008-07-02T06:33:00","username2":"12Bet$abkuba","refcode2":"3782","recommend":791088}]',
				@CustID	INT = 985954,
				@ErrCode INT = 0,
				@ErrMsg NVARCHAR(2000) = ''
		EXEC API_CustomerReactive_Insert
			 @CustID		= @CustID
			,@CustomerInfo  = @CustomerInfo
			,@ErrCode		= @ErrCode OUT
			,@ErrMsg		= @ErrMsg OUT
			

		SELECT  @CustID	AS  CustID
			   ,@ErrCode AS ErrCode
			   ,@ErrMsg	AS ErrMsg
*/	
BEGIN
	SET NOCOUNT ON 

	IF NOT EXISTS(SELECT 1 FROM Dep_Customer_Archived (NOLOCK) WHERE CustID = @CustID AND Status = 'completed')
	BEGIN    
		SELECT @ErrMsg = 'This account is locked for Archive Process now. Please try again after few minutes.'
			 , @ErrCode = 8

		SELECT @custID as CustID, 
			'REACTIVATION' as Action, 
			'Failed' as Status,
			'This member is not archived completely, can not be reactivated.' as Message

		RETURN    
	END 

	IF EXISTS (SELECT 1 FROM Customer (NOLOCK) WHERE CustID = @CustID)
		OR EXISTS (SELECT 1 FROM Custinfo (NOLOCK) WHERE CustID = @CustID)
	BEGIN
		SELECT @ErrMsg = 'This account has been reactivated by someone else.'
			 , @ErrCode = 9
		
		SELECT @custID as CustID, 
			'REACTIVATION' as Action, 
			'Failed' as Status,
			'This member is existing in Main DB.' as Message

		RETURN    
	END

	DECLARE @FirstName nvarchar(50),    
			@LastName nvarchar(50),   
			@Username varchar(50) ='',
			@Password varchar(40),
			@phone nvarchar(50),
			@mobilephone nvarchar(50),
			@Email nvarchar(50),  
			@fax nvarchar(50),
			@address nvarchar(50),
			@city nvarchar(50),   
			@state nvarchar(50),
			@Country nvarchar(50),
			@postal nvarchar(50),
			@birthday smalldatetime,
			@refcode1	nvarchar(50),
			@remark nvarchar(50),
			@createDate smalldatetime,
			@username2 varchar(50),    
			@refcode2 nvarchar(50), 
			@AgentID int,
			@pwdexpiry datetime

	DECLARE @danger		TINYINT=0,	--Original
			@danger2	TINYINT=0,	--ABI
			@danger3	TINYINT=0,	--Basketball
			@danger4	TINYINT=0,	--E-sports
			@danger5	TINYINT=0	--Other Sports

	DECLARE @currency int,    
		 @recommend int,    
		 @mrecommend int,    
		 @srecommend int,     
		 @agusername varchar(30),    
		 @site varchar(30),       
		 @ugroup varchar(5) = 'a',  
		 @matchlimit smallmoney,    
		 @virtualmultiplier smallmoney    
	    
	SELECT @FirstName = firstname,
			@Lastname = lastname,
			@Username = username,
			@Password = userpwd,
			@phone = phone,
			@mobilephone = mobilephone,
			@Email = email,
			@fax = fax,
			@address = address,
			@city = city,
			@state = state,
			@Country = country,
			@postal = postal,
			@birthday = birthday,
			@refcode1 = refcode1,
			@remark = remark,
			@createDate = creatdate,
			@username2 = username2,
			@refcode2 = refcode2,
			@AgentID = recommend
	FROM OPENJSON(@CustomerInfo) WITH (
		 firstname		nvarchar(50)		'$.firstname'	
		,lastname		nvarchar(50)		'$.lastname'
		,username		varchar(30) 		'$.username'
		,userpwd		varchar(40)			'$.userpwd'
		,phone			nvarchar(50)		'$.phone'
		,mobilephone	nvarchar(50)		'$.mobilephone'
		,email			nvarchar(50)		'$.email'
		,fax			nvarchar(50)		'$.fax'
		,address		nvarchar(50)		'$.address'
		,city			nvarchar(50)		'$.city'
		,state			nvarchar(50)		'$.state'
		,country		nvarchar(50)		'$.country'
		,postal			nvarchar(50)		'$.postal'
		,birthday		smalldatetime		'$.birthday'
		,refcode1		nvarchar(50)		'$.refcode1'
		,remark			nvarchar(50)		'$.remark'
		,creatdate		smalldatetime		'$.creatdate'
		,username2		varchar(50)			'$.username2'
		,refcode2		nvarchar(50)		'$.refcode2'
		,recommend		int					'$.recommend'
		)

	SELECT    
		@srecommend = ci.srecommend,    
		@mrecommend = ci.mrecommend,     
		@recommend = ci.custID,    
		@agusername = ci.username,    
		@currency = ci.currency,      
		@site = c.site,       
		@matchlimit   = matchlimit,    
		@virtualmultiplier = virtualmultiplier,
		@danger=danger,
		@danger2=danger2, 
		@danger3=danger3,
		@danger4=Danger4,
		@danger5=Danger5
	FROM custinfo ci WITH(NOLOCK)     
		INNER JOIN customer c WITH(NOLOCK) ON ci.custid = c.custid    
	WHERE ci.CustID = @AgentID    
		AND ci.roleid = 2 
		
	IF @recommend is null    
	BEGIN    
		SELECT @ErrMsg = 'Invalid agent.'
			, @ErrCode = 10    
	 
		SELECT @custID as CustID, 
			'REACTIVATION' as Action, 
			'Failed' as Status,
			'Agent of this member does not exist in custinfo in main DB' as Message

		RETURN    
	END    

	IF EXISTS(SELECT 1 FROM customer WITH(NOLOCK) WHERE username = @username)  
		OR EXISTS(SELECT 1 FROM customer WITH (NOLOCK) WHERE username2 = @username)  
		OR EXISTS(SELECT 1 FROM CustSub WITH (NOLOCK) WHERE username = @username)  
		OR EXISTS(SELECT 1 FROM CustSub WITH (NOLOCK) WHERE username2 = @username)
		--username2
		OR EXISTS(SELECT 1 FROM customer WITH(NOLOCK) WHERE username = @username2)  
		OR EXISTS(SELECT 1 FROM customer WITH (NOLOCK) WHERE username2 = @username2)  
		OR EXISTS(SELECT 1 FROM CustSub WITH (NOLOCK) WHERE username = @username2)  
		OR EXISTS(SELECT 1 FROM CustSub WITH (NOLOCK) WHERE username2 = @username2)    
	BEGIN    
		SELECT @ErrMsg = 'The username is not available.', @ErrCode = 11

		SELECT @custID as CustID, 
			'REACTIVATION' as Action, 
			'Failed' as Status,
			'The username is already existing in customer' as Message
				    
		RETURN    

	END    

	IF EXISTS(SELECT 1 FROM customer (NOLOCK) WHERE custid = @CustID)
	BEGIN
		SELECT @ErrMsg = 'This member has been reactivated by someone else.'
		SELECT @ErrCode = 22

		SELECT @custID as CustID, 
			'REACTIVATION' as Action, 
			'Failed' as Status,
			@ErrMsg as Message

		RETURN
	END   

	SELECT @ugroup = Ugroup FROM Dep_DefaultOddGroup WITH(NOLOCK) WHERE AgentID = @recommend AND IsActive=1
	SELECT @pwdexpiry = dateadd(dd, 30, getdate())

	--------------Insert customer info, customer setting---------------------------------
	--Insert general data     
	EXEC dbo.Dot_Dep_Customer_Archive_InsertCustomerInfo    
	 @custid = @custid,    
	 @firstname = @firstname,    
	 @lastname = @lastname,    
	 @creator = @recommend,    
	 @username = @username,    
	 @userpwd = @Password,    
	 @pwdexpiry = @pwdexpiry,    
	 @currency = @currency,    
	 @site = @site,    
	 @ugroup = @ugroup,
	 @createDate = @createDate, --20181011@Kean: Support for reactivation of member
	 @birthday = @birthday,
	 @refcode1 = @refcode1,
	 @remark = @remark,
	 @refcode2 = @refcode2,
	 @username2 = @username2,    
	 @srecommend = @srecommend,    
	 @mrecommend = @mrecommend,    
	 @recommend = @recommend,    
	 @roleid = 1,    
	 @danger=@danger,
	 @danger2=@danger2,
	 @danger3=@danger3,
	 @danger4=@Danger4,
	 @danger5=@Danger5,
	 @phone = @phone,    
	 @mobilephone = @mobilephone,    
	 @email = @Email,    
	 @fax = @fax,    
	 @address = @address,    
	 @city = @city,    
	 @state = @state,    
	 @country = @Country,    
	 @postal = @postal,
	 @TransferOption = null,    
	 @matchlimit = @matchlimit,    
	 @virtualmultiplier = @virtualmultiplier,    
	 @IP = '',    
	 @TransferOption_dec = null,    
	 @Language = 'E',    
	 @ErrCode = @ErrCode OUTPUT,    
	 @ErrMsg = @ErrMsg OUTPUT,
	 @BonusWalletFlag = 0,
	 @SubsidiaryID = @SubsidiaryID,
	 @ErrExtraInfo = @ErrExtraInfo OUTPUT
	
	IF @ErrCode <> 0 
	BEGIN   
		SELECT @custID as CustID, 
			'REACTIVATION' as Action, 
			'Failed' as Status,
			@ErrMsg as Message
		
		RETURN  
	END  

	BEGIN TRY
		DECLARE @DCSErrCode INT = 0
		EXEC dbo.Acc_Dep_DynamicCustSetting_00
				@CustID				= @CustID
				, @SuperID			= @srecommend
				, @MasterID			= @mrecommend
				, @AgentID			= @recommend
				, @RoleID			= 1
				, @ProductID		= NULL
				, @ErrCode			= @DCSErrCode OUTPUT
				
		IF @DCSErrCode <> 0 
		BEGIN
			--Error occur
			SELECT @ErrCode = 911 ,
				@ErrMsg = 'Create customer failed. Please try again.',
				@ErrExtraInfo = 'Acc_Dep_DynamicCustSetting_00: ' + CAST( @DCSErrCode AS  VARCHAR(20))

			-- ROLLBACK MANUALLY      
			EXEC Acc_Dep_CustomerInsSetting_Rollback @CustID = @CustID, @RoleID = 1
			EXEC Acc_Dep_CustomerInsUserInfo_Rollback @CustID = @CustID

			SELECT @custID as CustID, 
				'REACTIVATION' as Action, 
				'Failed' as Status,
				'Acc_Dep_DynamicCustSetting_00 is failed' as Message
				 
			RETURN    
		END
	END TRY

	BEGIN CATCH
			--Error occur
			SELECT @ErrCode = 911 ,
				@ErrMsg = 'Create customer failed. Please try again.',
				@ErrExtraInfo = 'Acc_Dep_DynamicCustSetting_00: ' + CAST( @DCSErrCode AS  VARCHAR(20))

			-- ROLLBACK MANUALLY      
			EXEC Acc_Dep_CustomerInsSetting_Rollback @CustID = @CustID, @RoleID = 1
			EXEC Acc_Dep_CustomerInsUserInfo_Rollback @CustID = @CustID

			SELECT @custID as CustID, 
				'REACTIVATION' as Action, 
				'Failed' as Status,
				'Acc_Dep_DynamicCustSetting_00 is failed' as Message
				 
			RETURN  
	END CATCH

	SELECT TOP 1 @CustIDBalanceDummy = CustIDBalanceDummy
			, @ClosingBalance = ClosingBalance
	FROM dbo.Dep_Customer_Archived WITH(NOLOCK)
	WHERE Status = 'completed' AND CustID = @CustID

	--Set default Group comm if exists
	IF @DefaultComms <> '' AND @GroupDiscountID <> 0
	BEGIN
		EXEC API_CustomerIns_DefaultComm_MainDB
			 @DefaultComms	= @DefaultComms
			,@Recommend		= @Recommend
			,@CustID		= @CustID
			,@ErrCode		= @ErrCode OUTPUT
			,@ErrMsg		= @ErrMsg OUTPUT
	END

	BEGIN TRY
		--Set default bet setting of AG Casino    
		EXEC Lrf_AGC_Customer_SetDefaultSetting      
			@CustID = @CustID,    
			@SuperID = @recommend,      
			@ErrCode = @ErrCode,      
			@ErrMsg = @ErrMsg    
	END TRY
	BEGIN CATCH
		SELECT @ErrCode	= 952
			   ,@ErrMsg	= ERROR_MESSAGE()
	END CATCH

	BEGIN TRY
		--Set default bet setting of 3rd Product    
		EXEC dbo.Lrf_3rdProductCustomerSetDefaultSetting      
			@CustID = @CustID,    
			@SuperID = @srecommend,      
			@ErrCode = @ErrCode,      
			@ErrMsg = @ErrMsg    
	END TRY
	BEGIN CATCH
		SELECT @ErrCode	= 953
			   ,@ErrMsg	= ERROR_MESSAGE()
	END CATCH

	--Update Dep_Customer_Archived.status = reactivation
	UPDATE Dep_Customer_Archived WITH(ROWLOCK,UPDLOCK)
	SET 
		status = 'reactivation'  
	,	RepUpdateTime = SYSDATETIME ()
	WHERE CustID = @CustID
	
	DECLARE @LogMsg VARCHAR(200) = 'Finish reactivating customer'
	
	SET @LogMsg = @LogMsg + ' (ClosingBalance =  ' + CONVERT(VARCHAR(20),ISNULL(@ClosingBalance,0),2) + ')'

	SELECT @custID as CustID, 
			'REACTIVATION' as Action, 
			'Done' as Status,
			@LogMsg as Message
				 
	--Customer log:
	DECLARE @MinBet MONEY,@MaxBet MONEY,@MaxPerMatch MONEY,@MaxPayoutPermatch MONEY -- Bet setting of representative sport type = 1 , bettype = 1
	DECLARE @Discount DECIMAL(9,8) = 0 -- Commission of representative sport type = 1 , bettype = 1
	DECLARE @PT smallmoney -- Position taking of representative sport type = 1 , bettype = 1
	DECLARE @LogInfo_Tbl TABLE(UserID INT, CustID INT, ActionID INT, TrackingValue VARCHAR(MAX), TrackingValue2 VARCHAR(MAX))
	DECLARE @TrackingValue VARCHAR(MAX), @TrackingValue2 VARCHAR(MAX)

	--PT
	IF EXISTS(SELECT 1 FROM Dep_CustSettingMode WITH(NOLOCK) WHERE custid = @CustID AND IsGroupedPT = 1)
	BEGIN
		SELECT @PT = AgentPT/100 FROM Dep_CustPTGroupSetting_Member WITH(NOLOCK) WHERE AgentID = @AgentID AND SportType = 1 AND BetType = 1
	END
	ELSE
	BEGIN
		SELECT @PT = AgentPT/100 FROM Dep_CustPTSetting_Member WITH(NOLOCK) WHERE CustID = @CustID AND SportType = 1 AND BetType = 1
	END

	--Comm
	IF EXISTS(SELECT 1 FROM Dep_CustSettingMode WITH(NOLOCK) WHERE custid = @CustID AND IsGroupedComm = 1)
	BEGIN
		SELECT @Discount = AgentDiscount FROM Dep_CustDiscountGroupSetting_Member WITH(NOLOCK) WHERE AgentID = @AgentID AND SportType = 1 AND BetType = 1
	END
	ELSE
	BEGIN
		SELECT @Discount = AgentDiscount FROM Dep_CustDiscountSetting_Member WITH(NOLOCK) WHERE CustID = @CustID AND SportType = 1 AND BetType = 1
	END

	--Bet Setting
	IF EXISTS(SELECT 1 FROM Dep_CustSettingMode WITH(NOLOCK) WHERE custid = @CustID AND IsGroupedBetLimit = 1)
	BEGIN
		SELECT @MinBet = MinBet, @MaxBet= MaxBet, @MaxPerMatch = MaxPerMatch, @MaxPayoutPermatch = MaxPayoutPerMatch 
		FROM Dep_CustBetSettingGameGroup_Member WITH(NOLOCK) WHERE AgentID = @AgentID AND SportType = 1 AND BetType = 1
	END
	ELSE
	BEGIN
		SELECT @MinBet = MinBet, @MaxBet= MaxBet, @MaxPerMatch = MaxPerMatch, @MaxPayoutPermatch = MaxPayoutPerMatch 
		FROM Dep_CustBetSettingGame_Member WITH(NOLOCK) WHERE CustID = @CustID AND SportType = 1 AND BetType = 1
	END


	DECLARE @xml XML

	SET @xml = (
					SELECT	@custid							AS '@custid',
							dbo.f_FomatNumericToChar(@PT)	AS '@AgentPT',
							@Discount						AS '@Discount',	
							@MinBet							AS '@MinBet',
							@MaxBet							AS '@MaxBet',
							@MaxPerMatch					AS '@MaxPerMatch',
							@MaxPayoutPermatch				AS '@MaxPayoutPermatch',
							@recommend						AS '@Creator',
							@Email							AS '@Email',
							@username						AS '@Username',
							@SubsidiaryID					AS '@SubsidiaryID',
							@recommend						AS '@AgentID',
							@ugroup							AS '@ugroup',
							@firstname						AS '@fname',
							@lastname						AS '@lname',
							@GroupDiscountID				AS '@GroupDiscountID',
							@ErrCode						AS '@ErrCode',
							@ErrMsg							AS '@ErrMsg',
							(
								SELECT	t.SportType								AS '@SportType',
									t.BetType									AS '@BetType',
									t.PlayerDiscount							AS '@PlayerDiscount'
								FROM Dep_CustDiscountSetting_Member t WITH(NOLOCK)
								WHERE CustID = @CustID 
								FOR XML PATH('Comm'),
								TYPE
			
							)
					FOR XML PATH('R'),
					TYPE
				)

	SET @TrackingValue = REPLACE(CONVERT(VARCHAR(MAX), @xml), '" />', '"/"')

	INSERT INTO @LogInfo_Tbl(UserID, CustID,ActionID,TrackingValue)
	SELECT @CustID, @CustID, 271001, @TrackingValue

	SELECT UserID, CustID,ActionID,TrackingValue 
	FROM @LogInfo_Tbl
END
GO