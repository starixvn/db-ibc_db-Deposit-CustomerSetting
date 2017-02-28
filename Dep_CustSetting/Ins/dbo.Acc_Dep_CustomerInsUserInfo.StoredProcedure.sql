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
	@Disable151_31 BIT = 0, --@DisableHorseRacing -> @Disable151_31
	@Disable151_41 BIT=0, -- @DisableOpenTote -> @Disable151_41
	@Disable151_51 BIT = 0,-- @Disable151_AU -> @Disable151_51
	@Disable152_41 BIT = 0,-- @Disable152_UK -> @Disable152_41
	@Disable152_51 BIT = 0,-- @Disable152_AU -> @Disable152_51
	@Disable153_51 BIT = 0,-- @Disable153_AU -> @Disable153_51
	@DisableOutright BIT = 0,
	@matchlimit SMALLMONEY,
	@virtualmultiplier SMALLMONEY,
	@DisableFinancial BIT = 0,
	@DisableAutoMPT BIT = 1,
	@IsInternal BIT = 0,
	
	@MaxPerMatch MONEY,
	@MaxPerMatchv2 MONEY,
	@MaxPerMatchv3 MONEY,
	@MaxPerMatchv5 MONEY,
	@MaxPerMatchv8 MONEY,
	@MaxPerMatchv10 MONEY,
	@MaxPerMatchv11 MONEY,
	@MaxPerMatchv44 MONEY,
	--v201
	@MaxPerMatchv201 MONEY = 0,
	
	--v151
	@MaxPerMatchv151_31 MONEY = 0,-- @MaxPerMatchv151 -> @MaxPerMatchv151_31
	@MaxPerMatchv151_41 MONEY = 0,-- @MaxPerMatchv151OT -> @MaxPerMatchv151_41
	@MaxPerMatchv151_51 MONEY = 0,-- @MaxPerMatchv151_AU -> @MaxPerMatchv151_51
	
	--v152
	@MaxPerMatchv152_41 MONEY = 0,-- @MaxPerMatchv152_UK -> @MaxPerMatchv152_41
	@MaxPerMatchv152_51 MONEY = 0,--@MaxPerMatchv152_AU -> @MaxPerMatchv152_51
	
	--v153
	@MaxPerMatchv153_51 MONEY =0,-- @MaxPerMatchv153_AU -> @MaxPerMatchv153_51
	
	@MaxPerMatchv99 MONEY,
	@MaxPerMatchv99MP MONEY,	
	@MaxPerMatchv161 MONEY,	
	@MaxPerBallv161 MONEY = 0,
	--HRFO
	@MaxPerMatchv154 MONEY,
	--Virtual Sport
	@MaxPerMatchv180 MONEY = 0,
	@MaxPerMatchv181 MONEY = 0,
	@MaxPerMatchv182 MONEY = 0,
	@MaxPerMatchv183 MONEY = 0,
	@MaxPerMatchv184 MONEY = 0,
	@MaxPerMatchv185 MONEY = 0,
	@MaxPerMatchv186 MONEY = 0,
	
	--Horse Racing PT
	@v151IBCPositiontaking_31 smallmoney = 0,--AutoIBCPT151_SA
	@v151IBCPositiontaking_41 smallmoney = 0,--AutoIBCPT151_UK
	@v151IBCPositiontaking_51 smallmoney = 0,--AutoIBCPT151_AU

	@v152IBCPositiontaking_41 smallmoney = 0,--AutoIBCPT152_UK 
	@v152IBCPositiontaking_51 smallmoney = 0,--AutoIBCPT152_AU 

	@v153IBCPositiontaking_51 smallmoney = 0,--AutoIBCPT153_AU
	
	@DisableNumber BIT = 0,
	@DisableBingo BIT = 0,
	@DisableCasino BIT = 0,
	@DisableP2P BIT = 0,
	@DisableFUNP2P BIT = 0,
	@ISAUTORESETP2P BIT = 0,
	@Disable162_1101 BIT = 0,
	@DisableVirtualSports BIT = 0,
	@DisableCasinoBonus BIT = 0,
	
	@DisableHRFO BIT = 0,
	@HideKeno BIT =0,

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
	
Param's Explanation:
• @ErrCode:
    = 0: Insert successfully.
    > 0: Specific Error.
  
• @ErrMsg: Error description.
*/

INSERT INTO Customer   			
			(username, firstname, lastname, phone, mobilephone, fax, email, address,
			city, state, country, postal, userpwd, roleid, srecommend, mrecommend, recommend, 
			currency, pwdexpiry, creator, Site, creatdate, ugroup
			) 
 		 VALUES (@username, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
			NULL, NULL, NULL, NULL, @userpwd, @roleid, @srecommend, @mrecommend, @recommend, 
			@currency, @pwdexpiry, @creator, @site, GETDATE(), @ugroup
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
	SET @srecommend = @custid 
	UPDATE Customer WITH (ROWLOCK, UPDLOCK) SET srecommend = @custid WHERE custId = @CustID

	INSERT INTO CustSuper(custId, AutoIBCPositionTaking_Tote, AutoIBCPositionTaking_Fixed, AutoIBCPT151_AU, AutoIBCPT152_UK, AutoIBCPT152_AU, AutoIBCPT153_AU, IsInternal, TransferOption) 
	VALUES(@CustID,@v151IBCPositiontaking_31,@v151IBCPositiontaking_41,@v151IBCPositiontaking_51,@v152IBCPositiontaking_41,@v152IBCPositiontaking_51,@v153IBCPositiontaking_51, @IsInternal, CASE WHEN @TransferOption IS NULL THEN ISNULL(@TransferOption_dec, 0) ELSE dbo.F_Binary_Decimal(ISNULL(@TransferOption, 0)) END)
	
	INSERT INTO Dep_CustSuper (custid, currency, username, site)
	VALUES (@CustID, @currency, @username, @site)
END
ELSE IF @roleid = 3
BEGIN
	SET @mrecommend = @custid 
	UPDATE Customer WITH (ROWLOCK, UPDLOCK) SET mrecommend = @custid WHERE custId = @CustID

	INSERT INTO CustMaster(custId, DisableAutoMPT, IsInternal, TransferOption)
	VALUES(@CustID,@DisableAutoMPT, @IsInternal, CASE WHEN @TransferOption IS NULL THEN ISNULL(@TransferOption_dec, 0) ELSE dbo.F_Binary_Decimal(ISNULL(@TransferOption, 0)) END)
END
ELSE IF @roleid = 2
BEGIN
	SET @recommend = @custid
	UPDATE Customer WITH (ROWLOCK, UPDLOCK) SET recommend = @custid WHERE custId = @CustID

	INSERT INTO CustAgent(custId,site, MaxCredit, IsInternal, TransferOption)
	VALUES(@CustID,@site, @MaxCredit, @IsInternal, CASE WHEN @TransferOption IS NULL THEN ISNULL(@TransferOption_dec, 0) ELSE dbo.F_Binary_Decimal(ISNULL(@TransferOption, 0)) END)
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
			
	RETURN
END

--Virtual rate
INSERT INTO [dbo].[CustVirtualSetting] (custid, seqNo, bitmapVirtual)
SELECT	@Custid, 
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
					SELECT	ipvs.profileID			AS '@p',
							vr.virtualMultiplier	AS '@v'
					FROM	ProfileVirtualSetting	AS ipvs WITH(NOLOCK)
					CROSS APPLY (
						SELECT CAST(1.00 AS SMALLMONEY) AS virtualMultiplier
					) vr
					WHERE	ipvs.seqNo = pvs.seqNo
					FOR XML PATH ('r'), 
					TYPE
				)
		FOR XML PATH ('root'), 
		TYPE
	) AS virtualXML
) p	

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

INSERT INTO [dbo].[custinfo](
	[custId], [currency], [maxpermatch], [maxpermatch2], [maxpermatch3], [maxpermatch5], [maxpermatch8], [maxpermatch10], [maxpermatch11],[maxpermatch44], [maxpermatch201],[maxpermatch151],[maxpermatch151_OT], MaxPerMatch151_AU, MaxPerMatch152_UK, MaxPerMatch152_AU, MaxPerMatch153_AU, [maxpermatch99]
	,[roleid], srecommend, [mrecommend], [recommend], [dangercust], [autosuspend], [reject], [credit], [closed], [username], MatchLimit, VirtualMultiplier
	,DisableHorseRacing,DisableOpenTote,Disable151_AU,Disable152_UK,Disable152_AU,Disable153_AU,DisableFinancial, DisableOutright, DisableCasino, DisableNumber,DisableBingo
	,maxpermatch161,MaxPerMatch99MP,MaxPerBall161,danger,danger2,danger3,DisableP2P,DisableFunP2P,ISAUTORESETP2P,DisableLiveCasino, DisableVirtualSports,maxpermatch180,maxpermatch181,maxpermatch182,maxpermatch183,maxpermatch184,maxpermatch185,maxpermatch186,DisableCasinoBonus,DisableHRFixedOdds,maxpermatch154,HideKeno)
VALUES(
	@custid, @currency, @MaxPerMatch, @MaxPerMatchv2, @MaxPerMatchv3, @MaxPerMatchv5, @MaxPerMatchv8, @MaxPerMatchv10, @MaxPerMatchv11,@MaxPerMatchv44, @MaxPerMatchv201,@MaxPerMatchv151_31, @MaxPerMatchv151_41,@MaxPerMatchv151_51, @MaxPerMatchv152_41, @MaxPerMatchv152_51, @MaxPerMatchv153_51, @MaxPerMatchv99
	,@roleid, @srecommend, @mrecommend, @recommend, 0, 0, ISNULL(@suspended,0), @credit, ISNULL(@closed,0), @username, @matchlimit, @virtualmultiplier, 
	@Disable151_31,@Disable151_41,@Disable151_51,@Disable152_41,@Disable152_51,@Disable153_51,@DisableFinancial,@DisableOutright, @DisableCasino, @DisableNumber,@DisableBingo
	,@MaxPerMatchv161,@MaxPerMatchv99MP,@MaxPerBallv161,@danger,@danger2,@danger3,@DisableP2P,@DisableFUNP2P,@ISAUTORESETP2P, @Disable162_1101,@DisableVirtualSports,@MaxPerMatchv180,@MaxPerMatchv181,@MaxPerMatchv182,@MaxPerMatchv183,@MaxPerMatchv184,@MaxPerMatchv185,@MaxPerMatchv186,@DisableCasinoBonus,@DisableHRFO,@MaxPerMatchv154,@HideKeno)

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
	
	RETURN
END
GO

GRANT VIEW DEFINITION ON [dbo].[Acc_Dep_CustomerInsUserInfo] TO [vnteam] AS [dbo]