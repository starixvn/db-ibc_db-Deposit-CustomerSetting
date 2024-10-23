/*<info serverAlias="DBCUST-CUSTDB" executers="" viewers="" isFunction="0" isNested="1"></info>*/
ALTER PROCEDURE [dbo].[Dot_Dep_CustomerInsUserInfo_12bet]
(
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

	@srecommend INT,
	@mrecommend INT,
	@recommend INT,
	@roleid INT,
		
	@country NVARCHAR(50),
	@suspended BIT = NULL,

	@matchlimit SMALLMONEY,
	@virtualmultiplier SMALLMONEY,
	
	@IP VARCHAR(15)='',
	@Language VARCHAR(2)= 'E',
	@ErrCode INT = 0 OUTPUT,
	@ErrMsg NVARCHAR(4000) = '' OUTPUT
) 
AS
/*
	Created: 20190919@Elodie
	Task : Insert general customer's Information in 1st deposit SP process
	DB: DBCUST/CustDB
	Original: Acc_CustomerInsUserInfo 

	Revisions:
		- 20190919@Elodie: Initial SP [Redmine: #118699]
		- 20191211@Johnson: Apply Default VR setting for IBO new members [redmine:#125285]
		- 20200624@Johnson: add Soccer Parlay bet limit [redmine: #135261]
		- 20200617@Eden: Virtual Rate for Basketball - Remove Apply Default VR setting for IBO new members [Redmine: #134978]
		- 20200804@Eden: VR setting for Basketball on some licensees from Desktop/China View [redmine: #138168]
		- 20200810@Eden: VR setting for Basketball on some licensees from Desktop/China View - add Happy8 licensee [redmine: #139229]
		- 20200811@Eden: Adjust VR setting for Other Sports of Haifa, IBO, Mansion88 & Happy8 [redmine: #139229]
		- 20200818@Eden: Auto Update Bet Limit Control [redmine: #139701]
		- 20200826@Eden: Adjust VR setting for Soccer of Haifa, IBO [redmine: #140368]
		- 20201103@Tina: Get site from Agent for member level [redmine: #144323]
		- 20210224@Eden: Implement Lock for VR update [Redmine:#149370]
		- 20220112@Eden: LAP - RNG Casino - Implement DCS Settings [Redmine: #166217] 
		- 20220301@Eden: Deposit - Sportsbook - Revise customer settings [Redmine: #167898]
		- 20220816@Tacy: Set default new downline Dangerous Setting [Redmine: #176518]
		- 20220913@Tacy: Customer Setting - Set Danger level (Saba Sports) for newly created members [RedmineID: #177464]
		- 20221207@Tacy: Remove columns and code used by Colossus Bets, GD product [RedmineID: #188096]
		- 20230303@Johnson: Return Basketball VR to its original state [redmine:#184339]
		- 20230310@Helios: Customer Setting - Migrate Sportsbook to DCS -Remove column DisableEsports [RedmineID: #193083]
		- 20240701@Winfred: Scale Out DBCUST - Apply In-house Replication for Virtual Rate Setting  [redmine: #207029] 
		- 20241023@Elodie: Support 12bet [RedmineID: #212624]
	Param's Explanation:
		? @ErrCode:
			= 0: Insert successfully.
			> 0: Specific Error.
  
		? @ErrMsg: Error description.
*/
BEGIN
    SET NOCOUNT ON 

	DECLARE @danger		TINYINT=0,	--Original
			@danger2	TINYINT=0,	--ABI
			@danger3	TINYINT=0,	--Basketball
			@danger4	TINYINT=0,	--E-sports
			@danger5	TINYINT=0	--Other Sports

	IF (@roleid = 1 AND ISNULL(@site,'') = '') --role member and @site does not have value
	BEGIN
		SELECT @site = cus.[site]
		FROM Customer cus WITH (NOLOCK)
		WHERE cus.custid = @recommend
	END

	
	EXEC Acc_CustomerIns
			@CustID	= @CustID
		,@UserName	= @UserName	
		,@FirstName	= ''	
		,@LastName	= ''	
		,@phone			= ''			
		,@mobilephone	= ''
		,@fax			= ''
		,@email			= ''			
		,@address		= ''		
		,@city			= ''			
		,@state			= ''			
		,@country		= ''		
		,@postal		= ''	
		,@UserPwd	= @UserPwd	 
		,@roleid	= @roleid	
		,@srecommend	= @srecommend	
		,@mrecommend	= @mrecommend	
		,@recommend		= @recommend	
		,@currency	= @currency		
		,@pwdexpiry = @pwdexpiry
		,@creator	= @creator	
		,@site			= @site			
		,@ugroup		= @ugroup
		,@UserName2		= ''
		,@refcode2 = ''
		,@ErrCode = @ErrCode OUTPUT
		,@ErrMsg  = @ErrMsg OUTPUT

	IF @ErrCode <> 0
	BEGIN
		SELECT @ErrMsg = CASE @Language 
							WHEN 'E' THEN 'Create customer failed. Please try again.'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
							END
				, @ErrCode = 911

		-- ROLLBACK MANUALLY
		EXEC Acc_Dep_CustomerInsSetting_Rollback @CustID = @CustID, @RoleID = 1
		EXEC Acc_Dep_CustomerInsUserInfo_Rollback_12bet @CustID = @CustID
		RETURN
	END

	INSERT INTO [dbo].[CustVirtualSetting] (custid, seqNo, bitmapVirtual, RepUpdateTime)
	SELECT @Custid, seqNo, bitmapVirtual, [dbo].[f_GetDateTime2]() AS RepUpdateTime
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
		--Inhouse Tables
		--DELETE FROM CustVirtualSetting WITH(ROWLOCK) WHERE custId = @CustID

		DELETE c
		OUTPUT deleted.custid, deleted.seqNo, [dbo].[f_GetDateTime2]() 
		INTO CustVirtualSetting_Del_Inhouse(custid,seqNo,RepUpdateTime)
		FROM CustVirtualSetting c WITH(ROWLOCK) 
		WHERE CustID = @CustID
	    RETURN
    END	

	--Virtual rate lock status
	INSERT INTO VRCustLockStatus(CustID,Type,RepUpdateTime)
	SELECT @custid,Type, [dbo].[f_GetDateTime2]() AS RepUpdateTime 
	FROM VRCustLockStatus v (NOLOCK) 
	WHERE CustID = @recommend
		AND NOT EXISTS( SELECT 1 FROM VRCustLockStatus(NOLOCK) WHERE CustID = @custid AND type = v.Type)

	IF @@ERROR <> 0
    BEGIN
	    SELECT @ErrMsg = CASE @Language 
					       WHEN 'E' THEN 'Create customer failed. Please try again.'
					       ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
					     END
		     , @ErrCode = 112

	    -- ROLLBACK MANUALLY
	    DELETE FROM Customer WITH(ROWLOCK) WHERE custId = @CustID
		--Inhouse Tables
		--DELETE FROM VRCustLockStatus WITH(ROWLOCK) WHERE custid = @CustID
		--DELETE FROM CustVirtualSetting WITH(ROWLOCK) WHERE custId = @CustID

		DELETE c
		OUTPUT deleted.custid, deleted.seqNo, [dbo].[f_GetDateTime2]() 
		INTO CustVirtualSetting_Del_Inhouse(custid,seqNo,RepUpdateTime)
		FROM CustVirtualSetting c WITH(ROWLOCK) 
		WHERE CustID = @CustID

		DELETE c
		OUTPUT deleted.custid, deleted.Type, [dbo].[f_GetDateTime2]() 
		INTO VRCustLockStatus_Del_Inhouse(custid,Type,RepUpdateTime)
		FROM VRCustLockStatus c WITH(ROWLOCK) 
		WHERE CustID = @CustID
	    RETURN
    END	
	
	DECLARE @licensee NVARCHAR(50)
	
	SELECT @licensee = site
	FROM customer WITH(NOLOCK)
	WHERE custid = @recommend

	IF @licensee IN('haifa','IBO','mansion88','Athena000','Happy8','ManBetX') 
		AND @currency IN (13,20) --RMB
	BEGIN
		IF  @licensee IN('haifa','IBO','ManBetX','Athena000') -- for soccer + Other sport
		BEGIN
			INSERT INTO [dbo].[VRCustAutoAdjustment](SportType, CustID, [Status],RepUpdateTime) VALUES(100, @custid, 1, [dbo].[f_GetDateTime2]() )
			IF @@ERROR <> 0
			BEGIN
				SELECT @ErrMsg = CASE @Language 
								   WHEN 'E' THEN 'Create customer failed. Please try again.'
								   ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
								 END
					 , @ErrCode = 112

				-- ROLLBACK MANUALLY
				DELETE FROM Customer WITH(ROWLOCK) WHERE custId = @CustID
				--Inhouse Tables
				--DELETE FROM CustVirtualSetting WITH(ROWLOCK) WHERE custId = @CustID
				--DELETE FROM VRCustLockStatus WITH(ROWLOCK) WHERE custid = @CustID
				--DELETE FROM VRCustAutoAdjustment WITH(ROWLOCK) WHERE custid = @CustID AND Sporttype IN(100,99)

				DELETE c
				OUTPUT deleted.custid, deleted.seqNo, [dbo].[f_GetDateTime2]() 
				INTO CustVirtualSetting_Del_Inhouse(custid,seqNo,RepUpdateTime)
				FROM CustVirtualSetting c WITH(ROWLOCK) 
				WHERE CustID = @CustID

				DELETE c
				OUTPUT deleted.custid, deleted.Type, [dbo].[f_GetDateTime2]() 
				INTO VRCustLockStatus_Del_Inhouse(custid,Type,RepUpdateTime)
				FROM VRCustLockStatus c WITH(ROWLOCK) 
				WHERE CustID = @CustID
				
				DELETE c
				OUTPUT deleted.SportType, deleted.CustID, [dbo].[f_GetDateTime2]() 
				INTO VRCustAutoAdjustment_Del_Inhouse(SportType,CustID,RepUpdateTime)
				FROM VRCustAutoAdjustment c WITH(ROWLOCK) 
				WHERE CustID = @CustID AND Sporttype IN(100,99)
				RETURN
			END
		END
		ELSE -- for Other sport
		BEGIN
			INSERT INTO [dbo].[VRCustAutoAdjustment](SportType, CustID, [Status],RepUpdateTime) VALUES(99, @custid, 1, [dbo].[f_GetDateTime2]() )
			IF @@ERROR <> 0
			BEGIN
				SELECT @ErrMsg = CASE @Language 
								   WHEN 'E' THEN 'Create customer failed. Please try again.'
								   ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
								 END
					 , @ErrCode = 112

				-- ROLLBACK MANUALLY
				DELETE FROM Customer WITH(ROWLOCK) WHERE custId = @CustID
				--Inhouse Tables
				--DELETE FROM CustVirtualSetting WITH(ROWLOCK) WHERE custId = @CustID
				--DELETE FROM VRCustLockStatus WITH(ROWLOCK) WHERE custid = @CustID
				--DELETE FROM VRCustAutoAdjustment WITH(ROWLOCK) WHERE custid = @CustID AND Sporttype IN(100,99)

				DELETE c
				OUTPUT deleted.custid, deleted.seqNo, [dbo].[f_GetDateTime2]() 
				INTO CustVirtualSetting_Del_Inhouse(custid,seqNo,RepUpdateTime)
				FROM CustVirtualSetting c WITH(ROWLOCK) 
				WHERE CustID = @CustID

				DELETE c
				OUTPUT deleted.custid, deleted.Type, [dbo].[f_GetDateTime2]() 
				INTO VRCustLockStatus_Del_Inhouse(custid,Type,RepUpdateTime)
				FROM VRCustLockStatus c WITH(ROWLOCK) 
				WHERE CustID = @CustID

				DELETE c
				OUTPUT deleted.SportType, deleted.CustID, [dbo].[f_GetDateTime2]() 
				INTO VRCustAutoAdjustment_Del_Inhouse(SportType,CustID,RepUpdateTime)
				FROM VRCustAutoAdjustment c WITH(ROWLOCK) 
				WHERE CustID = @CustID AND Sporttype IN(100,99)
				RETURN
			END
		END
	END
	
	--#139701
	INSERT INTO [BetLimitControlCustSetting]([CustID],[BetLimitTypeID],[MaxBet],[MaxPerMatch])
	SELECT @custid, BetLimitTypeID, MIN(MaxBet), MIN(MaxPerMatch)
	FROM BetLimitControlDefaultSetting WITH(NOLOCK,FORCESEEK) 
	WHERE CustID IN (@srecommend,@mrecommend,@recommend)
	GROUP BY BetLimitTypeID

	IF @@ERROR <> 0
	BEGIN
		SELECT @ErrMsg = CASE @Language 
							WHEN 'E' THEN 'Create customer failed. Please try again.'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
							END
				, @ErrCode = 112

		-- ROLLBACK MANUALLY
		DELETE FROM Customer WITH(ROWLOCK) WHERE custId = @CustID
		DELETE FROM BetLimitControlCustSetting WITH(ROWLOCK) WHERE custid = @CustID
		--Inhouse Tables
		--DELETE FROM CustVirtualSetting WITH(ROWLOCK) WHERE custId = @CustID
		--DELETE FROM VRCustLockStatus WITH(ROWLOCK) WHERE custid = @CustID
		--DELETE FROM VRCustAutoAdjustment WITH(ROWLOCK) WHERE custid = @CustID AND Sporttype IN(100,99)

		DELETE c
		OUTPUT deleted.custid, deleted.seqNo, [dbo].[f_GetDateTime2]() 
		INTO CustVirtualSetting_Del_Inhouse(custid,seqNo,RepUpdateTime)
		FROM CustVirtualSetting c WITH(ROWLOCK) 
		WHERE CustID = @CustID

		DELETE c
		OUTPUT deleted.custid, deleted.Type, [dbo].[f_GetDateTime2]() 
		INTO VRCustLockStatus_Del_Inhouse(custid,Type,RepUpdateTime)
		FROM VRCustLockStatus c WITH(ROWLOCK) 
		WHERE CustID = @CustID

		DELETE c
		OUTPUT deleted.SportType, deleted.CustID, [dbo].[f_GetDateTime2]() 
		INTO VRCustAutoAdjustment_Del_Inhouse(SportType,CustID,RepUpdateTime)
		FROM VRCustAutoAdjustment c WITH(ROWLOCK) 
		WHERE CustID = @CustID AND Sporttype IN(100,99)
		RETURN
	END

	DECLARE @DangerLevel BIGINT = NULL

	IF @roleid=1
	BEGIN
		--get DangerLevel
		SELECT @DangerLevel=DangerLevel
		FROM f_Dep_CustSetting_DangerLevel(@site, @currency)

		--get dangerous setting's upline:
		SELECT @danger=danger
			, @danger2=danger2 
			, @danger3=danger3
			, @danger4=Danger4
			, @danger5=Danger5
		FROM custInfo ci WITH (NOLOCK)
		WHERE custid=@recommend
	END

	INSERT INTO [dbo].[custinfo]
    (
	    custid, currency
	  , roleid, srecommend, mrecommend, recommend, dangercust, autosuspend, autosuspend2, reject, credit, closed, username
	  , MatchLimit, VirtualMultiplier
	  , DisableOutright
	  , danger, danger2, danger3, Danger4, Danger5
	  , Abnormal, DoubleCommLosing, DisableSuperLive
	  , DangerLevel, autosuspend3
	  )
    VALUES
    (
	    @custid, @currency
	  , @roleid, @srecommend, @mrecommend, @recommend, 0, 0, 0, ISNULL(@suspended, 0), 0, 0, @username
	  , @matchlimit, @virtualmultiplier
	  , 0
	  , @danger, @danger2, @danger3, @danger4, @danger5
	  , 0, 0, 0
	  , @DangerLevel, 0
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
		DELETE FROM custinfo WITH(ROWLOCK) WHERE custId = @CustID
		DELETE FROM BetLimitControlCustSetting WITH(ROWLOCK) WHERE custid = @CustID
		--Inhouse Tables
		--DELETE FROM CustVirtualSetting WITH(ROWLOCK) WHERE custId = @CustID
		--DELETE FROM VRCustLockStatus WITH(ROWLOCK) WHERE custid = @CustID
		--DELETE FROM VRCustAutoAdjustment WITH(ROWLOCK) WHERE custid = @CustID AND Sporttype IN(100,99)

		DELETE c
		OUTPUT deleted.custid, deleted.seqNo, [dbo].[f_GetDateTime2]() 
		INTO CustVirtualSetting_Del_Inhouse(custid,seqNo,RepUpdateTime)
		FROM CustVirtualSetting c WITH(ROWLOCK) 
		WHERE CustID = @CustID

		DELETE c
		OUTPUT deleted.custid, deleted.Type, [dbo].[f_GetDateTime2]() 
		INTO VRCustLockStatus_Del_Inhouse(custid,Type,RepUpdateTime)
		FROM VRCustLockStatus c WITH(ROWLOCK) 
		WHERE CustID = @CustID

		DELETE c
		OUTPUT deleted.SportType, deleted.CustID, [dbo].[f_GetDateTime2]() 
		INTO VRCustAutoAdjustment_Del_Inhouse(SportType,CustID,RepUpdateTime)
		FROM VRCustAutoAdjustment c WITH(ROWLOCK) 
		WHERE CustID = @CustID AND Sporttype IN(100,99)
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
			DELETE FROM custinfo WITH(ROWLOCK) WHERE custId = @CustID
			DELETE FROM BetLimitControlCustSetting WITH(ROWLOCK) WHERE custid = @CustID
			--Inhouse Tables
			--DELETE FROM CustVirtualSetting WITH(ROWLOCK) WHERE custId = @CustID
			--DELETE FROM VRCustLockStatus WITH(ROWLOCK) WHERE custid = @CustID
			--DELETE FROM VRCustAutoAdjustment WITH(ROWLOCK) WHERE custid = @CustID AND Sporttype IN(100,99)

			DELETE c
			OUTPUT deleted.custid, deleted.seqNo, [dbo].[f_GetDateTime2]() 
			INTO CustVirtualSetting_Del_Inhouse(custid,seqNo,RepUpdateTime)
			FROM CustVirtualSetting c WITH(ROWLOCK) 
			WHERE CustID = @CustID

			DELETE c
			OUTPUT deleted.custid, deleted.Type, [dbo].[f_GetDateTime2]() 
			INTO VRCustLockStatus_Del_Inhouse(custid,Type,RepUpdateTime)
			FROM VRCustLockStatus c WITH(ROWLOCK) 
			WHERE CustID = @CustID

			DELETE c
			OUTPUT deleted.SportType, deleted.CustID, [dbo].[f_GetDateTime2]() 
			INTO VRCustAutoAdjustment_Del_Inhouse(SportType,CustID,RepUpdateTime)
			FROM VRCustAutoAdjustment c WITH(ROWLOCK) 
			WHERE CustID = @CustID AND Sporttype IN(100,99)
			RETURN
		END
	END
END
