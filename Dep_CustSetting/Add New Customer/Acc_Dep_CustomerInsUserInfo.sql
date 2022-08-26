/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet,Dot_member" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_CustomerInsUserInfo]
	@custid INT OUTPUT,
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
	@Danger TINYINT = 0,
	@Danger2 TINYINT = 0,
	@Danger3 TINYINT = 0, 
	@TransferOption VARCHAR(8) = NULL, --pass value (not NULL) in case direct master add new agent
	@suspended BIT = NULL,
	@closed BIT = NULL,	
	@DisableOutright BIT = 0,
	@matchlimit SMALLMONEY,
	@virtualmultiplier SMALLMONEY,
	@DisableAutoMPT BIT = 1,
	@IsInternal BIT = 0,
	@credit MONEY,
	@maxcredit MONEY = 0,
	@IP VARCHAR(15)='',
	@TransferOption_dec TINYINT,
	@Language VARCHAR(2)= 'E',
	@ErrCode INT = 0 OUTPUT,
	@ErrMsg NVARCHAR(4000) = '' OUTPUT
AS

/*
Created: 20120319@Dom
Task :	Insert general customer's Informatioin.
		Table related: customer, custinfo
DB: DBTRANS.bodb02
Original:

Revisions:
	Dom.Cao@2012-07-20: Insert site to CustAgent
	- 20121128@Elodie: Get an error message from f_Get_MsgNameByMsgID function by language
	- 20130731@Elodie: Apply progressive bonus
	- 20131014@Francis: Add some new virtual sports' max per match
	- 20140512@Florent: Add Sport HRFO and param HideKeno
	- 20150309@Johnson: separate virtual rate settings by sporttype , bettype [RedmineID #31927]
	- 20151029@Billy: Change to new VirtualRate structure [Redmine: #46541]
	- 20151028@Jim:Implement Muay's Setting for Deposit Customer [Redmine: #45491]
	- 20170302@Helen: Betradar Virtual Sports  -Integration for Cash [Redmine: 77274]
	- 20180125@Winnie: Hide inactive products [RedmineID: #86086]
	- 20190429@Elodie: Insert VR setting get from Upline for new customer [RedmineID: #112657]
	- 20190726@Winnie: Remove Muay Thai. [RedmineID: #117501]
	- 20190905@Eden: 3rd party products - Remove InActive Products Phase 2 [Redmine: #118699]
	- 20200203@Elodie: Apply Currency Modifier [Redmine:127300]
	- 20200403@Elodie: Add Currency Modifier history [Redmine:127300]
	- 20200622@Johnson: add Soccer Parlay bet limit [redmine: #135261]
	- 20201103@Tina: Get site from Agent for member level [redmine: #144323]
	- 20210224@Eden: Implement Lock for VR update [Redmine:#149370]
	- 20210520@Eden: Apply default VR Setting which is -90% whenever there is new LICENSEE Supers creation [Redmine:#153411]
	- 20210802@Eden: Deposit - Support default VR based on bettypes [Redmine:#159547]
	- 20220112@Eden: LAP - RNG Casino - Implement DCS Settings [Redmine: #166217] 
	- 20220301@Eden: Deposit - Sportsbook - Revise customer settings [Redmine: #167898] 
	
Param's Explanation:
• @ErrCode:
    = 0: Insert successfully.
    > 0: Specific Error.
  
• @ErrMsg: Error description.
*/
DECLARE @CreateDate DATETIME = GETDATE()

IF (@roleid = 1 AND ISNULL(@site,'') = '') --role member and @site does not have value
BEGIN
	SELECT @site = cus.[site]
	FROM Customer cus WITH (NOLOCK)
	WHERE cus.custid = @recommend
END

INSERT INTO Customer   			
			(username, firstname, lastname, phone, mobilephone, fax, email, address,
			city, state, country, postal, userpwd, roleid, srecommend, mrecommend, recommend, 
			currency, pwdexpiry, creator, Site, creatdate, ugroup
			) 
 		 VALUES (@username, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
			NULL, NULL, NULL, NULL, @userpwd, @roleid, @srecommend, @mrecommend, @recommend, 
			@currency, @pwdexpiry, @creator, @site, @CreateDate, @ugroup
			)

SELECT @custid=@@IDENTITY

IF @@ERROR <> 0
BEGIN
	SELECT @ErrMsg = CASE @Language 
							WHEN 'E' THEN 'Create customer failed. Please try again.'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
						END,
		@ErrCode = 111
		
	-- ROLLBACK MANUALLY
	DELETE FROM Customer WITH (ROWLOCK) WHERE custId = @CustID
		
	RETURN
END

IF @roleid = 4
BEGIN
	DECLARE @CurrencyModifier SMALLMONEY
	EXEC @CurrencyModifier = f_GetCurrencyModifier @currency

	SET @srecommend = @custid 
	UPDATE Customer WITH (ROWLOCK, UPDLOCK) SET srecommend = @custid WHERE custId = @CustID

	INSERT INTO Dep_CustSuper (custid, currency, username, site, CurrencyModifier)
	VALUES (@CustID, @currency, @username, @site, @CurrencyModifier)

	IF @CurrencyModifier <> 1
	BEGIN
		INSERT INTO CurrencyModifier_History(CustId, CurrencyModifier, FromDate, ToDate)
		SELECT @CustId, @CurrencyModifier, @CreateDate, '9999-12-31 0:00:00.000'
	END

	INSERT INTO [dbo].[CustVirtualSetting] (custid, seqNo, bitmapVirtual)
	SELECT	@CustID, 
			seqNo,
			(
				SELECT TOP 1 bitmap
				FROM dbo.f_GenerateVirtualSetting_multiple(0x00, CONVERT(VARCHAR(MAX), virtualXML))
			) AS bitmapVirtual
	FROM (
		SELECT DISTINCT seqNo
		FROM ProfileVirtualSetting WITH(NOLOCK)
	) pvs
	CROSS APPLY (
		SELECT (
			SELECT	(
						SELECT ipvs.profileID AS '@p',
							CASE WHEN ipvs.bettype IN (1,7) AND ipvs.Islive = 1 THEN 0.12 
								WHEN ipvs.bettype IN (1,7) AND ipvs.Islive = 0 THEN 0.1 
								WHEN ipvs.bettype IN (3,8) THEN 0.08
								ELSE 0.15
							END AS '@v'
						FROM ProfileVirtualSetting AS ipvs WITH(NOLOCK)
						WHERE	ipvs.seqNo = pvs.seqNo
						FOR XML PATH ('r'), 
						TYPE
					)
			FOR XML PATH ('root'), 
			TYPE
		) AS virtualXML
	) p	

END
ELSE IF @roleid = 3
BEGIN
	SET @mrecommend = @custid 
	UPDATE Customer WITH (ROWLOCK, UPDLOCK) SET mrecommend = @custid WHERE custId = @CustID

	INSERT INTO CustMaster(custId, DisableAutoMPT, IsInternal, TransferOption)
	VALUES(@CustID,@DisableAutoMPT, @IsInternal, CASE WHEN @TransferOption IS NULL THEN ISNULL(@TransferOption_dec, 0) ELSE dbo.F_Binary_Decimal(ISNULL(@TransferOption, 0)) END)

	--Virtual rate
	INSERT INTO [dbo].[CustVirtualSetting] (custid, seqNo, bitmapVirtual)
	SELECT @CustID, seqNo, bitmapVirtual
	FROM CustVirtualSetting WITH(NOLOCK)
	WHERE custid = @srecommend
END
ELSE IF @roleid = 2
BEGIN
	SET @recommend = @custid
	UPDATE Customer WITH (ROWLOCK, UPDLOCK) SET recommend = @custid WHERE custId = @CustID

	INSERT INTO CustAgent(custId,site, MaxCredit, IsInternal, TransferOption)
	VALUES(@CustID,@site, @MaxCredit, @IsInternal, CASE WHEN @TransferOption IS NULL THEN ISNULL(@TransferOption_dec, 0) ELSE dbo.F_Binary_Decimal(ISNULL(@TransferOption, 0)) END)

	--Virtual rate
	INSERT INTO [dbo].[CustVirtualSetting] (custid, seqNo, bitmapVirtual)
	SELECT @CustID, seqNo, bitmapVirtual
	FROM CustVirtualSetting WITH(NOLOCK)
	WHERE custid = @mrecommend
END
ELSE IF @roleid = 1
BEGIN	
	--Virtual rate
	INSERT INTO [dbo].[CustVirtualSetting] (custid, seqNo, bitmapVirtual)
	SELECT @CustID, seqNo, bitmapVirtual
	FROM CustVirtualSetting WITH(NOLOCK)
	WHERE custid = @recommend
END

IF @@ERROR <> 0
BEGIN
	SELECT @ErrMsg = CASE @Language 
							WHEN 'E' THEN 'Create customer failed. Please try again.'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
						END,
		@ErrCode = 112
		
	-- ROLLBACK MANUALLY
	IF @RoleID = 4
	BEGIN
		DELETE FROM CustSuper WITH(ROWLOCK) WHERE custId = @CustID
		DELETE FROM Dep_CustSuper WITH(ROWLOCK) WHERE custId = @CustID
	END
	ELSE IF @RoleID = 3
		DELETE FROM CustMaster WITH(ROWLOCK) WHERE custId = @CustID
	ELSE IF @RoleID = 2
		DELETE FROM CustAgent WITH(ROWLOCK) WHERE custId = @CustID
		
	DELETE FROM Customer WITH(ROWLOCK) WHERE custId = @CustID
	DELETE FROM CustVirtualSetting WITH(ROWLOCK) WHERE custId = @CustID
			
	RETURN
END

DECLARE @UplineID INT

SELECT @UplineID = CASE WHEN @roleid = 3 THEN @srecommend 
						WHEN @roleid = 2 THEN @mrecommend
						WHEN @roleid = 1 THEN @recommend
					END

--VR lock status
INSERT INTO VRCustLockStatus(CustID,Type)
SELECT @custid,Type
FROM VRCustLockStatus v (NOLOCK) 
WHERE CustID = @UplineID
	AND NOT EXISTS( SELECT 1 FROM VRCustLockStatus(NOLOCK) WHERE CustID = @custid AND type = v.Type)

IF @@ERROR <> 0
BEGIN
	SELECT @ErrMsg = CASE @Language 
							WHEN 'E' THEN 'Create customer failed. Please try again.'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
						END,
		@ErrCode = 112
		
	-- ROLLBACK MANUALLY
	IF @RoleID = 4
	BEGIN
		DELETE FROM CustSuper WITH(ROWLOCK) WHERE custId = @CustID
		DELETE FROM Dep_CustSuper WITH(ROWLOCK) WHERE custId = @CustID
	END
	ELSE IF @RoleID = 3
		DELETE FROM CustMaster WITH(ROWLOCK) WHERE custId = @CustID
	ELSE IF @RoleID = 2
		DELETE FROM CustAgent WITH(ROWLOCK) WHERE custId = @CustID
		
	DELETE FROM Customer WITH(ROWLOCK) WHERE custId = @CustID
	DELETE FROM CustVirtualSetting WITH(ROWLOCK) WHERE custId = @CustID
	DELETE FROM VRCustLockStatus WITH(ROWLOCK) WHERE custid = @CustID
			
	RETURN
END

INSERT INTO [dbo].[custinfo](
	[custId], [currency]
	,[roleid], srecommend, [mrecommend], [recommend], [dangercust], [autosuspend], [reject], [credit], [closed], [username], MatchLimit, VirtualMultiplier
	,DisableOutright
	,danger,danger2,danger3)
VALUES(
	@custid, @currency
	,@roleid, @srecommend, @mrecommend, @recommend, 0, 0, ISNULL(@suspended,0), @credit, ISNULL(@closed,0), @username, @matchlimit, @virtualmultiplier
	,@DisableOutright
	,@danger,@danger2,@danger3)

IF @@ERROR <> 0
BEGIN 
--	DELETE customer with (ROWLOCK) where custid =  @custid
	SELECT @ErrMsg = CASE @Language 
							WHEN 'E' THEN 'Create customer failed. Please try again.'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
						END,
				@ErrCode = 113
				
	-- ROLLBACK MANUALLY
	IF @RoleID = 4
	BEGIN
		DELETE FROM CustSuper WITH(ROWLOCK) WHERE custId = @CustID
		DELETE FROM Dep_CustSuper WITH(ROWLOCK) WHERE custId = @CustID
	END
	ELSE IF @RoleID = 3
		DELETE FROM CustMaster WITH(ROWLOCK) WHERE custId = @CustID
	ELSE IF @RoleID = 2
		DELETE FROM CustAgent WITH(ROWLOCK) WHERE custId = @CustID
		
	DELETE FROM Customer WITH(ROWLOCK) WHERE custId = @CustID
	DELETE FROM CustVirtualSetting WITH(ROWLOCK) WHERE custId = @CustID
	DELETE FROM VRCustLockStatus WITH(ROWLOCK) WHERE custid = @CustID
	
	RETURN
END
GO
