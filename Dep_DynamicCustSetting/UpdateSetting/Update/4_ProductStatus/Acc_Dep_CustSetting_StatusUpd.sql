/*<info serverAlias="DBCUST-CUSTDB" executers="wsv_nap,wsv_alp,wsv_xnap,wsv_lap,svc_tig" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_CustSetting_StatusUpd] @ProductID INT
	, @CustID				INT
	, @IsDisabled			BIT
	, @IsDisabledDownLine	BIT = 0		
	, @SportType			INT
	, @BetType				INT
	, @bitmapOrder			TINYINT
	, @SettingStatus		TINYINT = 0
	, @UserID				INT
	, @IP					VARCHAR(40)	
	, @IsAgentOnly			BIT
	, @ErrCode				INT				= 0		OUTPUT	
	, @ErrMsg				NVARCHAR(200)	= ''	OUTPUT
	, @InsBalExceptCustList	VARCHAR(200)	= ''	OUTPUT
AS
/*
	Created: 20171009@Winne
	Task: Update DCS product status 
	DB: DBCUST/CustDB
	Original:
	Revisions:
		- 20171009@Winnie: Update DCS product status RedmineID:#82346
		- 20180719@Winnie: Licensee DCS setting - Support insert/edit setting for sub_licensee - Redmine: #88700
		- 20200423@Max: LAP - Support commission for 3rd party products [Redmine: #131774]
		- 20200511@Max: Add comm for FW, Remove AG, GD - [Redmine: #131774]
		- 20200701@Helen: Remove Allbet - [Redmine: #131774]  
		- 20200814@Helen: LAP - Offer commission to 3rd party products - Phase 2 - [Redmine: #139238] 
		- 20201111@Helen: LAP - Offer commission to 3rd party products - Phase 3 - [Redmine: #145012] 
		- 20210603@Eden: LAP - Support commission for 3rd party products - Phase 4 [Redmine: #154048]   
		- 20210817@Johnson: Add VGaming [redmine:#159696]
		- 20211101@Winfred: Merge Sports Lottery under Sportsbook when turn on BA [redmine:#163191]
		- 20220112@Eden: LAP - RNG Casino - Implement DCS Settings [Redmine: #166217] 
		- 20220422@Winfred: LAP - Support commission for 3rd party products - Phase 4.2 [Redmine: #171586]   
		- 20220301@Eden: Deposit - Sportsbook - Revise customer settings [Redmine: #167898] 
		- 20230315@Johnson: Add MaxGame, FGG, Jili Comm [redmine:#182922]
		- 20230804@Tacy: LAP - Offer Player Commission to Yeebet, MG-RNG [redmine: #192203]
		- 20230808@Tacy: LAP - Offer Player Commission to VS3 (new) [redmine: #192203]
		- 20241101@Tacy: LAP - Merge VS1, VS2, VS3 as Virtual Sports [Redmine: #199523]
		- 20240429@Tacy: Licensee DCS Setting - Integrate Exchange [RedmineID: #201239]
		- 20240503@Johnson: Restructure Commission [redmine:#179088]
		- 20240710@Johnson: Apply In-house Replication for Deposit Customer Setting [redmine:#207025]
	Param's Explanation:
	- @InsBalExceptCustList -->  cutsid and username  list will call sp insert exception balance on SiteDB : (ex: 'CustID1;username1,CustID2;username2,...' )
                    EXEC bodb02.dbo.Task_Cust_CheckBalance_Exception_Ins @custid = @custid, @username = @username"
*/
BEGIN
	SET NOCOUNT ON

	DECLARE @startRun	DATETIME
		, @endRun		DATETIME
		, @duration		INT
		, @RoleID		INT
		, @srecommend	INT
		, @mrecommend	INT

	SELECT @RoleID=RoleID,@srecommend=srecommend,@mrecommend=mrecommend FROM Customer WITH(NOLOCK) WHERE custid=@CustID
		
	DECLARE @logSpData		NVARCHAR(MAX)
		, @logSpData_Old	NVARCHAR(MAX)
		, @xml				XML	
		, @OldIsDisabled			BIT
		, @OldIsDisabledDownLine	BIT=1
		, @HasDownline	BIT=0
	DECLARE @tblmrecommend TABLE (CustID INT)

	DECLARE	@ProductName		VARCHAR(50),
			@SettingLevel		TINYINT,
			@ProductSettingID	INT

	SET @startRun = GETDATE()

	SELECT	@ErrCode	= 0
		,	@ErrMsg			= ''

	EXEC Acc_Dep_CustomerSelCheckAllowedDownlines
	 @custid = @CustID
	,@Language = 'E'
	,@ErrMsg = @ErrMsg OUTPUT
	,@ErrCode= @ErrCode OUTPUT

	IF @ErrCode <> 0 
		RETURN 	
		
	CREATE TABLE #SportBettypeFilter (SportType INT,Bettype INT)
	
	INSERT INTO #SportBettypeFilter (SportType,Bettype)
	SELECT @SportType,@BetType

	SELECT	@OldIsDisabled=(SELECT value FROM dbo.f_CustSetting_ProductStatusSel(stt.bitmapIsDisabled, @bitmapOrder))	
	FROM dbo.Dep_CustProductStatus stt WITH (NOLOCK)	
	WHERE stt.CustID = @CustID	
		
	SELECT  @SettingLevel=SettingLevel,@ProductSettingID=ProductSettingID 
	FROM dbo.f_Dep_CustSetting_SportBetTypeSettingSelect(@ProductID,4,@SettingStatus)

	--Exchange: Create dummy account
	IF @ProductID=31 AND @IsDisabled=0
	BEGIN
		DECLARE @DumCustID INT, @DummyAgentID INT
			,@DumUserName VARCHAR(30), @Pass VARCHAR(100)

		SELECT	@DummyAgentID = c.recommend		--same line: Dummy3rd account
			,@DumUserName = c.site + 'Exchange' + CONVERT(VARCHAR,e.currency)
			,@Pass = '8058095B7DDB08A608811097E5DB8D'
		FROM Customer c WITH (NOLOCK)
		INNER JOIN exchange e WITH (NOLOCK) ON e.ExchangeId=c.currency
		WHERE srecommend=@srecommend AND roleid=1
			AND username=c.site + 'Dummy3rd' + CONVERT(VARCHAR,e.currency)
			
		DECLARE @IsExists BIT   
		EXEC [Acc_Dep_CustomerCheckExists] @username = @DumUserName, @IsExists = @IsExists OUTPUT	
			
		IF @IsExists=0
		BEGIN
			EXEC Acc_Dep_CustomerInsMember_Ag 
					@custid=@DumCustID OUTPUT
					,@creator=@UserID
					,@username=@DumUserName
					,@userpwd=@Pass
					,@recommend=@DummyAgentID
					,@IP=@IP
					,@ErrCode=@ErrCode OUTPUT
					,@ErrMsg=@ErrMsg OUTPUT

			IF @ErrCode<>0
			BEGIN
				EXEC [Acc_CustomerInsUserInfo_Rollback] @CustID=@DumCustID
				RETURN
			END

			SELECT @InsBalExceptCustList = CONVERT(VARCHAR,@DumCustID) +  ';' + @DumUserName 
		END
	END

	--Update Status
	IF @RoleID=4
	BEGIN		
		IF EXISTS(SELECT 1 FROM dbo.Customer s WITH (NOLOCK)	WHERE s.srecommend= @CustID	AND s.Roleid=1)
			SELECT @HasDownline=1				

		IF	@HasDownline<>0 AND @OldIsDisabled=0
		BEGIN
			IF EXISTS (
				SELECT  1													
				FROM dbo.Dep_CustProductStatus stt WITH (NOLOCK)	
					INNER JOIN Customer b WITH(NOLOCK)	ON stt.CustID = b.CustID
					WHERE b.srecommend=@CustID AND b.roleid=1 AND	 (SELECT value FROM dbo.f_CustSetting_ProductStatusSel(stt.bitmapIsDisabled, @bitmapOrder))=1) 
			BEGIN
				SELECT @OldIsDisabledDownLine = 1
			END
			ELSE
				SELECT @OldIsDisabledDownLine = 0		
		END
		
		IF EXISTS (SELECT 1 FROM Dep_LicenseeProductSetting d WITH (NOLOCK) 
					CROSS APPLY dbo.f_Dep_CustSetting_SportBetTypeSettingSelect(NULL,4,@SettingStatus) f
					WHERE d.ProductSettingID=f.ProductSettingID AND CustID=@CustID)
		BEGIN
			EXEC Acc_Dep_CustSetting_StatusDownlineUpd
					@ActionID=1,
					@CustID=@CustID,
					@bitmapOrder=@bitmapOrder,					
					@IsDisabled=@IsDisabled,
					@IsDisabledDownline=@IsDisabledDownLine
					
			IF NOT EXISTS(SELECT  1 FROM Dep_LicenseeProductSetting WITH(NOLOCK) WHERE Custid=@CustID AND ProductSettingID=@ProductSettingID )
				INSERT INTO Dep_LicenseeProductSetting(CustID,ProductSettingID,RepUpdateTime)
				VALUES( @CustID,@ProductSettingID,SYSDATETIME())
				
		END
		ELSE
		BEGIN
			EXEC Acc_Dep_CustSetting_StatusDownlineUpd
					@ActionID=0,
					@CustID=@CustID,
					@bitmapOrder=@bitmapOrder,					
					@IsDisabled=@IsDisabled,
					@IsDisabledDownline=@IsDisabledDownLine
			
			INSERT INTO Dep_LicenseeProductSetting(CustID,ProductSettingID,RepUpdateTime)
			VALUES( @CustID,@ProductSettingID,SYSDATETIME())
		END
	END
	ELSE IF @RoleID=2
	BEGIN		
		IF NOT EXISTS(SELECT 1 FROM Dep_LicenseeProductSetting WITH(NOLOCK) WHERE Custid=@srecommend AND ProductSettingID=@ProductSettingID )
			SELECT @IsAgentOnly=0

		IF(@IsAgentOnly=0)
			BEGIN		
				IF NOT EXISTS (SELECT 1 FROM dbo.Dep_CustProductStatus T WITH(NOLOCK) WHERE t.custid=@srecommend)
				BEGIN
					INSERT INTO dbo.Dep_CustProductStatus
						(CustID
						,bitmapIsDisabled
						,bitmapIsHidden
						,RepUpdateTime)
		   			SELECT	@srecommend
					, dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, @bitmapOrder,@IsDisabled) AS bitmapIsDisabled
					, dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, @bitmapOrder,0)  AS bitmapIsHidden						
					, SYSDATETIME()
				END
				ELSE
				BEGIN
				UPDATE d
					SET d.bitmapIsDisabled=dbo.f_GenerateProductStatus (d.bitmapIsDisabled, @bitmapOrder,@IsDisabled) ,
						d.bitmapIsHidden=dbo.f_GenerateProductStatus (d.bitmapIsHidden, @bitmapOrder,0) ,
						RepUpdateTime = SYSDATETIME()
					FROM Dep_CustProductStatus d WITH(ROWLOCK) 
					WHERE d.custid=@srecommend 
				END

				IF NOT EXISTS (SELECT 1 FROM dbo.Dep_CustProductStatus T WITH(NOLOCK) WHERE t.custid=@mrecommend)
				BEGIN
					INSERT INTO dbo.Dep_CustProductStatus
						(CustID
						,bitmapIsDisabled
						,bitmapIsHidden
						,RepUpdateTime)
		   			SELECT	@mrecommend
					, dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, @bitmapOrder,@IsDisabled) AS bitmapIsDisabled
					, dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, @bitmapOrder,0)  AS bitmapIsHidden						
					, SYSDATETIME()
				END
				ELSE
				UPDATE d
					SET d.bitmapIsDisabled=dbo.f_GenerateProductStatus (d.bitmapIsDisabled, @bitmapOrder,@IsDisabled) ,
						d.bitmapIsHidden=dbo.f_GenerateProductStatus (d.bitmapIsHidden, @bitmapOrder,0) ,
						RepUpdateTime = SYSDATETIME()
					FROM Dep_CustProductStatus d WITH(ROWLOCK) 
					WHERE d.custid=@mrecommend	
			END

		IF NOT EXISTS (SELECT 1 FROM dbo.Dep_CustProductStatus T WITH(NOLOCK) WHERE t.custid=@CustID)
			BEGIN
				INSERT INTO dbo.Dep_CustProductStatus
					(CustID
					,bitmapIsDisabled
					,bitmapIsHidden
					,RepUpdateTime)
		   		SELECT	@CustID
				, dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, @bitmapOrder,@IsDisabled) AS bitmapIsDisabled
				, dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, @bitmapOrder,0)  AS bitmapIsHidden						
				, SYSDATETIME()
			END
			ELSE
			UPDATE d
				SET d.bitmapIsDisabled=dbo.f_GenerateProductStatus (d.bitmapIsDisabled, @bitmapOrder,@IsDisabled) ,
					d.bitmapIsHidden=dbo.f_GenerateProductStatus (d.bitmapIsHidden, @bitmapOrder,0),
					RepUpdateTime = SYSDATETIME()
				FROM Dep_CustProductStatus d WITH(ROWLOCK) 
				WHERE d.custid=@CustID	

		IF EXISTS(SELECT  1 FROM dbo.Customer s WITH (NOLOCK)	WHERE s.recommend= @CustID	AND s.Roleid=1)
			SELECT @HasDownline=1			
			
		IF	@HasDownline<>0 AND @OldIsDisabled=0
		BEGIN
			
			IF EXISTS (
				SELECT  1													
				FROM dbo.Dep_CustProductStatus stt WITH (NOLOCK)	
					INNER JOIN Customer b WITH(NOLOCK)	ON stt.CustID = b.CustID
					WHERE b.recommend=@CustID AND b.roleid=1 AND	 (SELECT value FROM dbo.f_CustSetting_ProductStatusSel(stt.bitmapIsDisabled, @bitmapOrder))=1) 
			BEGIN
				SELECT @OldIsDisabledDownLine = 1
			END
			ELSE
				SELECT @OldIsDisabledDownLine = 0	
		END		
			EXEC Acc_Dep_CustSetting_StatusDownlineUpd
				@ActionID=2,
				@CustID=@CustID,
				@bitmapOrder=@bitmapOrder,					
				@IsDisabled=@IsDisabled,
				@IsDisabledDownline=@IsDisabledDownLine

		IF NOT EXISTS(SELECT 1 FROM Dep_LicenseeProductSetting WITH(NOLOCK) WHERE Custid=@srecommend AND ProductSettingID=@ProductSettingID )
			INSERT INTO Dep_LicenseeProductSetting(CustID,ProductSettingID,RepUpdateTime)
			VALUES( @srecommend,@ProductSettingID,SYSDATETIME())	
		
	END
	
	-----------Setting Comm-------------
	IF EXISTS (SELECT 1 FROM Dep_ProductSettingDetail p 
				INNER JOIN Dep_ProductSetting d on p.ProductSettingID = d.ProductSettingID
			WHERE d.ProductID = @ProductID
				AND SettingType = 9)
		AND @IsDisabled = 0 
	BEGIN
		EXEC Acc_Dep_CustSetting_CommDownlineUpd
			@CustID			= @CustID
			,@RoleId		= @RoleID
			,@srecommend	= @srecommend
			,@mrecommend	= @mrecommend
			,@ProductID		= @ProductID 
			,@SportType		= @SportType
			,@BetType		= @BetType
			,@Mode			= 'UpdateComm'
	END
	------------------------------------

	-- Select ProductName
	SELECT @ProductName = p.ProductName
	FROM DBPRO.bodb02.dbo.Products AS p WITH(NOLOCK)
	WHERE p.ProductID = @ProductID

	SELECT @ErrMsg='Update Status successfully'
	--START LOGGING
	-- Log old data
	IF @SettingLevel = 1			-- Product setting level
	BEGIN
		SET @xml = (
		SELECT	@ProductID						AS '@ProductID',
				@ProductName					AS '@ProductName',
				@CustID							AS '@CustID',
				@UserID							AS '@UserID',				
				@IP								AS '@IP',
				NULL							AS '@IsAgentOnly',
				@OldIsDisabledDownLine			AS '@IsDisabledDownline',
				(
					SELECT	@ProductID							AS '@ProductID',
							@OldIsDisabled						AS '@IsDisabled'	
					FOR XML PATH('IsDisabled'),
					TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_StatusUpd'),
		TYPE
	)
	END
	ELSE IF @SettingLevel = 2		-- SportType setting level
	BEGIN
		SET @xml = (
		SELECT	@ProductID						AS '@ProductID',
				@ProductName					AS '@ProductName',
				@CustID							AS '@CustID',
				@UserID							AS '@UserID',				
				@IP								AS '@IP',
				NULL							AS '@IsAgentOnly',
				@OldIsDisabledDownLine			AS '@IsDisabledDownline',
				(
					SELECT	SportType							AS '@SportType',
							@OldIsDisabled						AS '@IsDisabled'							
					FROM #SportBettypeFilter
					FOR XML PATH('IsDisabled'),
					TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_StatusUpd'),
		TYPE
	)
	END
	ELSE IF @SettingLevel = 3		-- BetType setting level
	BEGIN
		SET @xml = (
		SELECT	@ProductID						AS '@ProductID',
				@ProductName					AS '@ProductName',
				@CustID							AS '@CustID',
				@UserID							AS '@UserID',				
				@IP								AS '@IP',
				NULL							AS '@IsAgentOnly',
				@OldIsDisabledDownLine			AS '@IsDisabledDownline',
				(
					SELECT	BetType								AS '@BetType',
							@OldIsDisabled						AS '@IsDisabled'			
					FROM #SportBettypeFilter
					FOR XML PATH('IsDisabled'),
					TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_StatusUpd'),
		TYPE
	)
	END
	ELSE IF @SettingLevel = 4		-- SportType BetType setting level
	BEGIN
		SET @xml = (
		SELECT	@ProductID						AS '@ProductID',
				@ProductName					AS '@ProductName',
				@CustID							AS '@CustID',
				@UserID							AS '@UserID',				
				@IP								AS '@IP',
				NULL							AS '@IsAgentOnly',
				@OldIsDisabledDownLine			AS '@IsDisabledDownline',
				(
					SELECT	SportType							AS '@SportType',
							BetType								AS '@BetType',
							@OldIsDisabled						AS '@IsDisabled'			
					FROM #SportBettypeFilter
					FOR XML PATH('IsDisabled'),
					TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_StatusUpd'),
		TYPE
	)
	END
	SET @logSpData_Old = REPLACE(CONVERT(VARCHAR(MAX), @xml), '" />', '"/"')

	-- Log new updated data
	IF @SettingLevel = 1			-- Product setting level
	BEGIN
		SET @xml = (
		SELECT	@ProductID						AS '@ProductID',
				@ProductName					AS '@ProductName',
				@CustID							AS '@CustID',
				@UserID							AS '@UserID',				
				@IP								AS '@IP',
				@IsAgentOnly					AS '@IsAgentOnly',
				@IsDisabledDownline				AS '@IsDisabledDownline',
				(
					SELECT	@ProductID							AS '@ProductID',
							@IsDisabled							AS '@IsDisabled'
					FROM #SportBettypeFilter
					FOR XML PATH('IsDisabled'),
					TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_StatusUpd'),
		TYPE
	)
	END
	ELSE IF @SettingLevel = 2		-- SportType setting level
	BEGIN
		SET @xml = (
		SELECT	@ProductID						AS '@ProductID',
				@ProductName					AS '@ProductName',
				@CustID							AS '@CustID',
				@UserID							AS '@UserID',				
				@IP								AS '@IP',
				@IsAgentOnly					AS '@IsAgentOnly',
				@IsDisabledDownline				AS '@IsDisabledDownline',
				(
					SELECT	SportType							AS '@SportType',
							@IsDisabled							AS '@IsDisabled'							
					FROM #SportBettypeFilter
					FOR XML PATH('IsDisabled'),
					TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_StatusUpd'),
		TYPE
	)
	END
	ELSE IF @SettingLevel = 3		-- BetType setting level
	BEGIN
		SET @xml = (
		SELECT	@ProductID						AS '@ProductID',
				@ProductName					AS '@ProductName',
				@CustID							AS '@CustID',
				@UserID							AS '@UserID',				
				@IP								AS '@IP',
				@IsAgentOnly					AS '@IsAgentOnly',
				@IsDisabledDownline				AS '@IsDisabledDownline',
				(
					SELECT	BetType								AS '@BetType',
							@IsDisabled							AS '@IsDisabled'
					FROM #SportBettypeFilter
					FOR XML PATH('IsDisabled'),
					TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_StatusUpd'),
		TYPE
	)
	END
	ELSE IF @SettingLevel = 4		-- SportType BetType setting level
	BEGIN
		SET @xml = (
		SELECT	@ProductID						AS '@ProductID',
				@ProductName					AS '@ProductName',
				@CustID							AS '@CustID',
				@UserID							AS '@UserID',			
				@IP								AS '@IP',
				@IsAgentOnly					AS '@IsAgentOnly',
				@IsDisabledDownline				AS '@IsDisabledDownline',
				(
					SELECT	SportType							AS '@SportType',
							BetType								AS '@BetType',
							@IsDisabled							AS '@IsDisabled'
					FROM #SportBettypeFilter
					FOR XML PATH('IsDisabled'),
					TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_StatusUpd'),
		TYPE
	)
	END
	SET @logSpData = REPLACE(CONVERT(VARCHAR(MAX), @xml), '" />', '"/"')

	SELECT @endRun = GETDATE()
		, @duration = DATEDIFF(MILLISECOND, @startRun, @endRun)

	BEGIN TRY
		EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP @UserID = @UserID
						, @CustID			= @CustID
						, @ActionID			= 1164
						, @TrackingValue	= @logSpData
						, @TrackingValue2	= @logSpData_Old
						, @duration			= @duration
	END TRY
	BEGIN CATCH
		EXEC bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP @UserID = @UserID
						, @CustID			= @CustID
						, @ActionID			= 1164
						, @TrackingValue	= @logSpData
						, @TrackingValue2	= @logSpData_Old
						, @duration			= @duration
	END CATCH
END

GO