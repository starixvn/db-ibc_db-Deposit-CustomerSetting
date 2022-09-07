/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet,bodbDownlineNet,bodbExtAccNet,Dot_Member" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Dot_Dep_Customer_Archive_InsertCustomerInfo]
	@custid INT,
	@firstname NVARCHAR(50),
	@lastname NVARCHAR(50),
	@creator INT,
	@username VARCHAR(30),
	@userpwd VARCHAR(40),
	@pwdexpiry DATETIME,
	@currency INT,
	@site NVARCHAR(50),
	@ugroup VARCHAR(5) = NULL,
	@createDate SMALLDATETIME, --20181011@Kean: Support for reactivation of member
	@birthday SMALLDATETIME,
	@refcode1	NVARCHAR(50),
	@remark NVARCHAR(50),
	@refcode2 NVARCHAR(50),
	@username2 VARCHAR(50),

	@srecommend INT,
	@mrecommend INT,
	@recommend INT,
	@roleid INT = 1,
	
	@Danger TINYINT = 0,
	@Danger2 TINYINT = 0,
	@Danger3 TINYINT = 0,
	@Danger4 TINYINT = 0,
	@Danger5 TINYINT = 0,

	@Abnormal TINYINT = 0,
	
	@phone NVARCHAR(50),
	@mobilephone NVARCHAR(50),
	@email NVARCHAR(50),
	@fax NVARCHAR(50),
	@address NVARCHAR(80),
	@city NVARCHAR(50),
	@state NVARCHAR(50),
	@country NVARCHAR(50),
	@postal NVARCHAR(50),
	@TransferOption VARCHAR(8) = NULL, --pass value (not NULL) in case direct master add new agent
	@suspended BIT = NULL,

	@closed BIT = NULL,	
	@DisableOutright BIT = 0,
	@matchlimit SMALLMONEY,
	@virtualmultiplier SMALLMONEY,
	@DisableAutoMPT BIT = 1,
	@IsInternal BIT = 0,
	
	@autosuspend BIT = 0,
	@autosuspend2 BIT = 0,

	
	@DisableColossusBet BIT = 1,
	@HideColossusBet BIT = 1,
	
	@DisableSuperLive BIT = 0,
	@maxcredit MONEY = 0,
	@isSearchAndCopy BIT = 0,
	@copyFromCustID INT = 0,
	
	@IP VARCHAR(15)='',
	@TransferOption_dec TINYINT,
	@SystemID	TINYINT=1,
	@Language VARCHAR(2)= 'E',
	@ErrCode INT = 0 OUTPUT,
	@ErrMsg NVARCHAR(4000) = '' OUTPUT
AS

/*
	Created: 20181010@Kean
	Task :	Insert general customer's Informatioin for supporting reactivation old deposit member
			Table related: customer, custinfo and CustVirtualSetting
	DB: DBCUST/CustDB
	Original: Reuse Acc_CustomerInsUserInfo SP and edit

	Revisions:    
		- 20181010@Dominic: First commit
		- 20181228@Dominic: Insert data into table Customer by using Dep_Customer_Archive_InsCustomer_WithCustID
		- 20190909@Eden: 3rd party products - Remove InActive Products Phase 2 [Redmine: #118699]
		- 20220112@Eden: LAP - RNG Casino - Implement DCS Settings [Redmine: #166217] 
		- 20220301@Eden: Deposit - Sportsbook - Revise customer settings [Redmine: #167898] 
		- 20220907@Tacy: NAP - Set Dangerous Level of member following upline (Agent) [Redmine: #176518]

	Param's Explanation:
	• @ErrCode:
		= 0: Insert successfully.
		> 0: Specific Error.
  
	• @ErrMsg: Error description.
*/
BEGIN
    SET NOCOUNT ON 
	
	DECLARE @NotificationInfo VARCHAR(MAX)

	EXEC Dep_Customer_Archive_InsCustomer_WithCustID 
				@custid=@custid,
				@firstname=@firstname,
				@lastname=@lastname,
				@creator=@creator,
				@username=@username,
				@userpwd=@userpwd,
				@pwdexpiry=@pwdexpiry,
				@currency=@currency,
				@site=@site,
				@ugroup=@ugroup,
				@createDate=@createDate,
				@birthday=@birthday,
				@refcode1=@refcode1,
				@remark=@remark,
				@refcode2=@refcode2,
				@username2=@username2,
				@srecommend=@srecommend,
				@mrecommend=@mrecommend,
				@recommend=@recommend,
				@roleid=@roleid,
				@phone=@phone,
				@mobilephone=@mobilephone,
				@email=@email,
				@fax=@fax,
				@address=@address,
				@city=@city,
				@state=@state,
				@country=@country,
				@postal=@postal,
				@ErrCode = @ErrCode OUTPUT,    
				@ErrMsg = @ErrMsg OUTPUT
	
    IF @ErrCode <> 0
    BEGIN
	    SELECT @ErrMsg = CASE @Language 
							    WHEN 'E' THEN 'Create customer failed. Please try again.'
							    ELSE [dbo].[f_Get_MsgNamebyMsgID](40004, @Language)
						    END,
		    @ErrCode = 111
    		
	    RETURN
    END
	
	IF @ErrCode <>0
	BEGIN
			SELECT @ErrMsg = CASE @Language 
							    WHEN 'E' THEN 'Create customer failed. Please try again.'
							    ELSE [dbo].[f_Get_MsgNamebyMsgID](40004, @Language)
						    END
				, @ErrCode = 116
		 -- ROLLBACK MANUALLY
			DELETE FROM Customer WITH (ROWLOCK) WHERE custId = @CustID
			
			RETURN
	END
	
    DECLARE	@UplineSecurityCode			 VARCHAR(50)
	      , @isForcedChangeSecurityCode BIT

    SELECT @UplineSecurityCode		 = NULL
	     , @isForcedChangeSecurityCode = 0

	IF @roleid = 1
	BEGIN		
		INSERT INTO [dbo].[CustVirtualSetting] (custid, seqNo, bitmapVirtual)
		SELECT @Custid, seqNo, bitmapVirtual
		FROM CustVirtualSetting WITH(NOLOCK)
		WHERE custid = @recommend  
	END
    IF @@ERROR <> 0
    BEGIN
	    SELECT @ErrMsg = CASE @Language 
					       WHEN 'E' THEN 'Create customer failed. Please try again.'
					       ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
					     END
		     , @ErrCode = 112

	    -- ROLLBACK MANUALLY
	    DELETE FROM Customer WITH(ROWLOCK) WHERE custId = @CustID
		DELETE FROM CustVirtualSetting WITH(ROWLOCK) WHERE custid = @CustID
		EXEC DBMSG.bodb_Message.dbo.Age_MsgCustReadStatus_Del  @custid
	    RETURN
    END	

	DECLARE @ClosedReason TINYINT 
	IF(@SystemID=1 AND @closed=1)
		SELECT @ClosedReason=1
	ELSE IF(@SystemID<>1 AND @closed=1)
		SELECT @ClosedReason=2
	ELSE 
		SELECT @ClosedReason=0

	IF @roleid=1
	BEGIN		
		IF NOT EXISTS (SELECT 1 FROM dbo.CustLoginInfo_Member WITH(NOLOCK) WHERE custid = @custid)
		BEGIN
			INSERT INTO CustLoginInfo_Member([CustID],[SecurityCode],[IP],[LastChangedID],[LastChangedDate],ClosedReason)
			VALUES(@custid,NULL,@IP,@creator,GETDATE(),@ClosedReason)
			IF @@ERROR <> 0
			BEGIN
				SELECT	@ErrMsg = CASE @Language
										WHEN 'E' THEN 'Create customer failed. Please try again.'
										ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
									END
						,@ErrCode = 115

				DELETE FROM Customer WITH(ROWLOCK) WHERE custId = @CustID
				DELETE FROM CustVirtualSetting WITH(ROWLOCK) WHERE custid = @CustID
				EXEC DBMSG.bodb_Message.dbo.Age_MsgCustReadStatus_Del  @custid
				RETURN
			END
		END
	END
    INSERT INTO [dbo].[custinfo]
    (
	    custid, currency
	  , roleid, srecommend, mrecommend, recommend, dangercust, autosuspend, autosuspend2, reject, credit, closed, username
	  , MatchLimit, VirtualMultiplier
	  , DisableOutright
	  , danger, danger2, danger3, Danger4, Danger5
	  , Abnormal	 
	  , DoubleCommLosing	
	  , DisableSuperLive,DisableColossusBet,HideColossusBet
	  )
    VALUES
    (
	    @custid, @currency
	  , @roleid, @srecommend, @mrecommend, @recommend, 0, @autosuspend, @autosuspend2, ISNULL(@suspended, 0), 0, ISNULL(@closed, 0), @username
	  , @matchlimit, @virtualmultiplier
	  , @DisableOutright
	  , @danger, @danger2, @danger3, @Danger4, @Danger5
	  , @Abnormal
	  , 0
	  , @DisableSuperLive,@DisableColossusBet,@HideColossusBet
    )

	
    IF @@ERROR <> 0
    BEGIN 
    --	DELETE customer with (ROWLOCK) where custid =  @custid
	    SELECT @ErrMsg = CASE @Language
					       WHEN 'E' THEN 'Create customer failed. Please try again.'
					       ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
					     END,
		       @ErrCode = 113

	    -- ROLLBACK MANUALLY
	    DELETE FROM Customer WITH(ROWLOCK) WHERE custId = @CustID
		DELETE FROM CustVirtualSetting WITH(ROWLOCK) WHERE custid = @CustID	
		EXEC DBMSG.bodb_Message.dbo.Age_MsgCustReadStatus_Del  @custid
	    RETURN
    END
END


GO

