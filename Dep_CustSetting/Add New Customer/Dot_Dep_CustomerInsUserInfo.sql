/*<info serverAlias="DBCUST-CUSTDB" executers="Dot_Member" viewers="" isFunction="0"></info>*/

ALTER PROCEDURE [dbo].[Dot_Dep_CustomerInsUserInfo]
	@custid INT OUTPUT,
	@firstname NVARCHAR(50),
	@lastname NVARCHAR(50),
	@creator INT,
	@username VARCHAR(30),
	@userpwd VARCHAR(40),
	@pwdexpiry DATETIME,
	@currency INT,
	@site NVARCHAR(50),
	@ugroup VARCHAR(5) = NULL,

	@srecommend INT,
	@mrecommend INT,
	@recommend INT,
	@roleid INT,
		
	@country NVARCHAR(50),
	@suspended BIT = NULL,

	@matchlimit SMALLMONEY,
	@virtualmultiplier SMALLMONEY,
	
	@MaxPerMatch MONEY,
	@MaxPerMatchv2 MONEY,
	@MaxPerMatchv3 MONEY,
	@MaxPerMatchv5 MONEY,
	@MaxPerMatchv8 MONEY,
	@MaxPerMatchv10 MONEY,
	@MaxPerMatchv11 MONEY,
	@MaxPerMatchv99 MONEY,
	@MaxPerMatchv99MP MONEY,		
	@MaxPerMatchv161 MONEY,	
	@MaxPerBallv161 MONEY = 0,	
	
	@DisableNumber BIT = 0,
	@HideKeno BIT = 0,		
	
	@IP VARCHAR(15)='',
	@Language VARCHAR(2)= 'E',
	@ErrCode INT = 0 OUTPUT,
	@ErrMsg NVARCHAR(4000) = '' OUTPUT
AS
/*
	Created: 20190919@Elodie
	Task : Insert general customer's Information in 1st deposit SP process
	DB: DBCUST/CustDB
	Original: Acc_CustomerInsUserInfo

	Revisions:
		- 20190919@Elodie: Initial SP [Redmine: #118699]
	
	Param's Explanation:
		• @ErrCode:
			= 0: Insert successfully.
			> 0: Specific Error.
  
		• @ErrMsg: Error description.
*/
BEGIN
    SET NOCOUNT ON 
	
    INSERT INTO Customer   			
	(username, firstname, lastname, phone, mobilephone, fax, email, address,
	city, state, country, postal, userpwd, roleid, srecommend, mrecommend, recommend, 
	currency, pwdexpiry, creator, Site, creatdate, ugroup
	) 
 	VALUES (@username, @firstname, @lastname, '', '', '', '', '', 
	'', '', @country, '', @userpwd, @roleid, @srecommend, @mrecommend, @recommend, 
	@currency, @pwdexpiry, @creator, @site, GETDATE(), @ugroup
	)
    
	SELECT @custid=@@IDENTITY
	
    IF @@ERROR <> 0
    BEGIN
	    SELECT @ErrMsg = CASE @Language 
							    WHEN 'E' THEN 'Create customer failed. Please try again.'
							    ELSE [dbo].[f_Get_MsgNamebyMsgID](40004, @Language)
						    END,
		    @ErrCode = 111
    		
	    -- ROLLBACK MANUALLY
	    DELETE FROM Customer WITH (ROWLOCK) WHERE custId = @CustID
    		
	    RETURN
    END
	
	INSERT INTO [dbo].[CustVirtualSetting] (custid, seqNo, bitmapVirtual)
	SELECT @Custid, seqNo, bitmapVirtual
	FROM CustVirtualSetting WITH(NOLOCK)
	WHERE custid = @recommend  

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
	    RETURN
    END	

	INSERT INTO [dbo].[custinfo]
    (
	    custid, currency
	  , maxpermatch, maxpermatch2, maxpermatch3, maxpermatch5, maxpermatch8, maxpermatch10, maxpermatch11
	  , maxpermatch99
	  , roleid, srecommend, mrecommend, recommend, dangercust, autosuspend, autosuspend2, reject, credit, closed, username
	  , MatchLimit, VirtualMultiplier
	  , DisableOutright, DisableCasino, DisableNumber, maxpermatch161, MaxPerMatch99MP, MaxPerBall161
	  , danger, danger2, danger3, Abnormal, DoubleCommLosing
	  , HideKeno, DisableEsports, DisableGoldDeluxe, HideGoldDeluxe, DisableSuperLive,DisableColossusBet,HideColossusBet
	  , MaxPerMatch1MP,maxpermatch164)
    VALUES
    (
	    @custid, @currency
	  , @MaxPerMatch, @MaxPerMatchv2, @MaxPerMatchv3, @MaxPerMatchv5, @MaxPerMatchv8, @MaxPerMatchv10, @MaxPerMatchv11
	  , @MaxPerMatchv99
	  , @roleid, @srecommend, @mrecommend, @recommend, 0, 0, 0, ISNULL(@suspended, 0), 0, 0, @username
	  , @matchlimit, @virtualmultiplier
	  , 0, 0, @DisableNumber,  @MaxPerMatchv161, @MaxPerMatchv99MP, @MaxPerBallv161
	  , 0, 0, 0, 0, 0	
	  , @HideKeno, 0, 0, 0, 0,1,1
	  , 0, 0
    )
	
    IF @@ERROR <> 0
    BEGIN 
	    SELECT @ErrMsg = CASE @Language
					       WHEN 'E' THEN 'Create customer failed. Please try again.'
					       ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
					     END,
		       @ErrCode = 113

	    -- ROLLBACK MANUALLY
	    DELETE FROM Customer WITH(ROWLOCK) WHERE custId = @CustID
		DELETE FROM CustVirtualSetting WITH(ROWLOCK) WHERE custid = @CustID	
		DELETE FROM custinfo WITH(ROWLOCK) WHERE custId = @CustID
	    RETURN
    END  

	IF NOT EXISTS (SELECT 1 FROM dbo.CustLoginInfo_Member WITH(NOLOCK) WHERE custid = @custid)
	BEGIN
		INSERT INTO CustLoginInfo_Member([CustID],[SecurityCode],[IP],[LastChangedID],[LastChangedDate],ClosedReason)
		VALUES(@custid,NULL,@IP,@creator,GETDATE(),0)

		IF @@ERROR <> 0
		BEGIN
			SELECT	@ErrMsg = CASE @Language
									WHEN 'E' THEN 'Create customer failed. Please try again.'
									ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
								END
					,@ErrCode = 114

			DELETE FROM Customer WITH(ROWLOCK) WHERE custId = @CustID
			DELETE FROM CustVirtualSetting WITH(ROWLOCK) WHERE custid = @CustID
			DELETE FROM custinfo WITH(ROWLOCK) WHERE custId = @CustID
			RETURN
		END
	END
END
GO
