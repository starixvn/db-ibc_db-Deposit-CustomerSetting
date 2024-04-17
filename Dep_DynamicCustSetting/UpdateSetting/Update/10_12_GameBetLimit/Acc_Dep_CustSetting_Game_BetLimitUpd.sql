/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet,bodbDownlineNet,bodbExtAccNet,wsv_lap" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_CustSetting_Game_BetLimitUpd] 
	  @CustID		INT
	, @BetLimit VARCHAR(MAX)
	, @SubAccID		INT				= 0
	, @UserID		INT
	, @IP			VARCHAR(50)		= ''
	, @ErrCode			INT				= 0		OUTPUT
	, @MsgType			INT				= 0		OUTPUT
	, @ErrMsg			NVARCHAR(200)	= ''	OUTPUT
AS
/*
	Created: 20220301@Eden
	Task: Update Customer's Bet Limits
	DB: DBCUST/CustDB
	Original:

	Revision:
		- 20220301@Eden: Deposit - Sportsbook - Revise customer settings [Redmine: #167898] 
		- 20220802@Tacy: Insert history of member bet setting (Number Game only) [RedmineID: #170739]
		
	Param's Explanation:
	@BetLimit	= '<ROOT>
				<BetLimit SportType="1" BetType="1" MinBet="10" MaxBet="100" MaxPerMatch="1000" MaxPayoutPerMatch="10000" />
				<BetLimit SportType="161" BetType="81" MinBet="10" MaxBet="100" MaxPerMatch="1000" MaxPerNumber="500"/>
		</ROOT>'
		
*/

BEGIN
	SET NOCOUNT ON

	DECLARE @CustList VARCHAR(MAX)

	DECLARE @startRun	DATETIME
		, @endRun		DATETIME
		, @duration		INT
		
	DECLARE @logSpData		NVARCHAR(MAX)
		, @logSpData_Old	NVARCHAR(MAX)
		, @xml				XML
		
	DECLARE @AgentID			INT
		, @MasterID			INT
		, @SuperID			INT
		, @RoleID			INT
		
	DECLARE @OldBetLimitTbl TABLE (
		SportType			SMALLINT
		, BetType			SMALLINT
		, MinBet			MONEY
		, MaxBet			MONEY
		, MaxPerMatch		MONEY
		, MaxPerNumber		MONEY
		, MaxPayoutPerMatch	MONEY
		)
	DECLARE @NewBetLimitTbl TABLE (
		SportType			SMALLINT
		, BetType			SMALLINT
		, MinBet			MONEY
		, MaxBet			MONEY
		, MaxPerMatch		MONEY
		, MaxPerNumber		MONEY
		, MaxPayoutPerMatch	MONEY
		)
	DECLARE @History_BetLimitTbl TABLE (
		CustID				INT
		, SportType			SMALLINT
		, BetType			SMALLINT
		, MaxBet			MONEY
		, MaxPerMatch		MONEY
		, UpdateTime		DATETIME
		)

	DECLARE @ProductID		TINYINT,
			@ProductName	VARCHAR(50),
			@SettingLevel	TINYINT

	--Check if XML is null or empty
	IF @BetLimit IS NULL
		OR @BetLimit = ''
		RETURN

	SET @startRun = GETDATE()

	SELECT	@ErrCode	= 0
		,	@MsgType	= 0
		,	@ErrMsg			= ''

	--Check disable user
	EXEC dbo.Acc_CustomerSelCheckEnable 
										@custid		= @custid
									,	@ErrCode	= @ErrCode OUTPUT
									,	@ErrMsg		= @ErrMsg OUTPUT

	IF @ErrCode > 0
	BEGIN
		SET @MsgType = 101
		RETURN
	END

	--Get line information
	SELECT @AgentID = recommend
		, @MasterID = mrecommend
		, @SuperID	= srecommend
		, @RoleID	= RoleID
	FROM dbo.custInfo WITH (NOLOCK)
	WHERE custid = @CustID

	--Check belonging
	EXEC dbo.Age_CustomerSelCheckBelonging 
		@SessionCustID	= @Userid 
		,@Custid		= @custid		
		,@roleid		= @roleid OUTPUT
	IF (@roleid = 0)
	BEGIN
		SET @MsgType = 101
		SET @ErrCode = 101
		SET @ErrMsg = 'Users are not in the same line!'
		RETURN
	END
	
	--Check Allowed downlines	
	EXEC dbo.Acc_CustomerSelCheckAllowedDownlines 
												@custid		= @custid
											,	@roleid		= @roleid
											,	@isExecRep	= 1
											,	@Language	= 'E'
											,	@ErrCode	= @ErrCode	OUTPUT
											,	@ErrMsg		= @ErrMsg	OUTPUT

	IF @ErrCode > 0
	BEGIN
		SET @MsgType = 101
		RETURN
	END
	
	--Parse XML	
	DECLARE @iDoc INT

	EXEC sp_xml_preparedocument @iDoc OUTPUT
		, @BetLimit

	INSERT @NewBetLimitTbl(SportType,BetType,MinBet,MaxBet,MaxPerMatch,MaxPerNumber,MaxPayoutPerMatch)
	SELECT SportType,BetType,MinBet,MaxBet,MaxPerMatch,MaxPerNumber,MaxPayoutPerMatch
	FROM OPENXML(@iDoc, '/ROOT/BetLimit', 1) WITH (
			SportType		SMALLINT
			, BetType		SMALLINT
			, MinBet		MONEY
			, MaxBet		MONEY
			, MaxPerMatch	MONEY
			, MaxPerNumber		MONEY
			, MaxPayoutPerMatch	MONEY
			)

	EXEC sp_xml_removedocument @iDoc

	--Validate new bet settings
	EXEC [dbo].[Acc_Dep_CustSetting_Game_BetLimitCheck] @CustID	= @CustID
						, @RoleID		= @RoleID
						, @AgentID		= @AgentID
						, @MasterID		= @MasterID
						, @SuperID		= @SuperID
						, @BetLimit		= @BetLimit
						, @ErrCode		= @ErrCode	OUTPUT
						, @MsgType		= @MsgType  OUTPUT
						, @ErrMsg		= @ErrMsg	OUTPUT

	IF @ErrCode <> 0
		RETURN

	DECLARE @IsGroupedBetLimit BIT
	SELECT @IsGroupedBetLimit = ISNULL(IsGroupedBetLimit,0) FROM Dep_CustSettingMode WITH(NOLOCK) WHERE custid = @CustID

	IF @RoleID = 1
	BEGIN
		--get old settings
		IF @IsGroupedBetLimit = 1
		BEGIN
			INSERT INTO @OldBetLimitTbl(SportType,BetType,MinBet,MaxBet,MaxPerMatch,MaxPerNumber,MaxPayoutPerMatch)
			SELECT bl.SportType
				, bl.BetType
				, bl.MinBet
				, bl.MaxBet
				, bl.MaxPerMatch
				, bl.MaxPerNumber
				, bl.MaxPayoutPerMatch
			FROM dbo.Dep_CustBetSettingGameGroup_Member bl WITH (NOLOCK)
				INNER JOIN @NewBetLimitTbl tmp	ON tmp.SportType = bl.sporttype	AND tmp.BetType = bl.bettype
			WHERE bl.AgentID = @AgentID
		END
		ELSE
		BEGIN
			INSERT INTO @OldBetLimitTbl(SportType,BetType,MinBet,MaxBet,MaxPerMatch,MaxPerNumber,MaxPayoutPerMatch)
			SELECT bl.SportType
				, bl.BetType
				, bl.MinBet
				, bl.MaxBet
				, bl.MaxPerMatch
				, bl.MaxPerNumber
				, bl.MaxPayoutPerMatch
			FROM dbo.Dep_CustBetSettingGame_Member bl WITH (NOLOCK)
				INNER JOIN @NewBetLimitTbl tmp	ON tmp.SportType = bl.sporttype	AND tmp.BetType = bl.bettype
			WHERE bl.custid = @CustID
		END
		
		UPDATE Dep_CustSettingMode WITH(ROWLOCK,UPDLOCK) 
		SET IsGroupedBetLimit = 0  
		WHERE custid = @CustID
			AND IsGroupedBetLimit = 1

		--update new settings if exists row
		UPDATE main
		SET main.minbet			= tmp.MinBet
			, main.maxbet		= tmp.MaxBet
			, main.maxpermatch	= tmp.MaxperMatch
			, main.MaxPerNumber		= tmp.MaxPerNumber
			, main.MaxPayoutPerMatch	= tmp.MaxPayoutPerMatch
		OUTPUT deleted.CustID, deleted.SportType, deleted.BetType, deleted.MaxBet, deleted.MaxPerMatch, GETDATE()
			INTO @History_BetLimitTbl(CustID, SportType, BetType, MaxBet, MaxPerMatch, UpdateTime)
		FROM dbo.Dep_CustBetSettingGame_Member main WITH(ROWLOCK,UPDLOCK)
			INNER JOIN @NewBetLimitTbl tmp	ON tmp.SportType = main.sporttype AND tmp.BetType = main.bettype
		WHERE main.custid = @CustID
			AND (
					main.minbet		<> tmp.MinBet
				OR main.maxbet		<> tmp.MaxBet
				OR main.maxpermatch <> tmp.MaxperMatch
				OR main.MaxPerNumber		<> tmp.MaxPerNumber
				OR main.MaxPayoutPerMatch <> tmp.MaxPayoutPerMatch
				)

		--update new settings
		INSERT INTO Dep_CustBetSettingGame_Member(CustID,SportType,BetType,MinBet,MaxBet,MaxPerMatch,MaxPerNumber,MaxPayoutPerMatch)
		SELECT @custID,tmp.SportType,tmp.BetType,tmp.MinBet,tmp.MaxBet,tmp.MaxPerMatch,tmp.MaxPerNumber,tmp.MaxPayoutPerMatch
		FROM @NewBetLimitTbl tmp
			LEFT JOIN Dep_CustBetSettingGame_Member m WITH(NOLOCK) ON m.CustID = @CustID AND tmp.SportType = m.SportType AND tmp.BetType = m.BetType
		WHERE m.CustID IS NULL

		--Insert remain setting from group setting
		INSERT INTO Dep_CustBetSettingGame_Member(CustID,SportType,BetType,MinBet,MaxBet,MaxPerMatch,MaxPerNumber,MaxPayoutPerMatch)
		SELECT @custID,gr.SportType,gr.BetType,gr.MinBet,gr.MaxBet,gr.MaxPerMatch,gr.MaxPerNumber,gr.MaxPayoutPerMatch
		FROM Dep_CustBetSettingGameGroup_Member gr WITH(NOLOCK)
			LEFT JOIN Dep_CustBetSettingGame_Member m WITH(NOLOCK) ON m.CustID = @CustID AND gr.SportType = m.SportType AND gr.BetType = m.BetType
		WHERE m.CustID IS NULL
			AND gr.AgentID = @AgentID

		--Delete: update minbet only and be not NG
		DELETE FROM @History_BetLimitTbl WHERE SportType<>161

		DELETE old
		FROM @History_BetLimitTbl old
			INNER JOIN @NewBetLimitTbl new ON new.SportType=old.SportType
											AND new.BetType=old.BetType
											AND new.MaxBet=old.MaxBet
											AND new.MaxPerMatch=old.MaxPerMatch
		WHERE CustID=@CustID

		--Insert history bet setting
		IF EXISTS (SELECT 1 FROM @History_BetLimitTbl old)
		BEGIN
			SET @CustList = (SELECT CustID		AS '@CustID',
									SportType	AS '@SportType',
									BetType		AS '@BetType',
									MaxBet		AS '@MaxBet',
									MaxPerMatch	AS '@MaxPerMatch',
									'NULL'		AS '@StakeLevelList',
									UpdateTime	AS '@UpdateTime'
							 FROM @History_BetLimitTbl
							 FOR XML PATH ('r'), ROOT ('root')
							)

			EXECUTE Acc_Dep_DynamicCustSetting_07  @CustList=@CustList, @ErrMsg=@ErrMsg OUTPUT

			IF @ErrMsg<>''
				RETURN
		END
	END
	ELSE IF @RoleID IN (2, 3, 4)
	BEGIN
		--get old settings
		INSERT INTO @OldBetLimitTbl(SportType,BetType,MinBet,MaxBet,MaxPerMatch,MaxPerNumber,MaxPayoutPerMatch)
		SELECT bl.SportType
			, bl.BetType
			, bl.MinBet
			, bl.MaxBet
			, bl.MaxPerMatch
			, bl.MaxPerNumber
			, bl.MaxPayoutPerMatch
		FROM dbo.Dep_CustBetSettingGame_Agent bl WITH (NOLOCK)
			INNER JOIN @NewBetLimitTbl tmp	ON tmp.SportType = bl.sporttype	AND tmp.BetType = bl.bettype
		WHERE bl.custid = @CustID

		--update new settings
		UPDATE main
		SET main.minbet			= tmp.MinBet
			, main.maxbet		= tmp.MaxBet
			, main.maxpermatch	= tmp.MaxperMatch
			, main.MaxPerNumber		= tmp.MaxPerNumber
			, main.MaxPayoutPerMatch	= tmp.MaxPayoutPerMatch
		FROM dbo.Dep_CustBetSettingGame_Agent main WITH(ROWLOCK,UPDLOCK)
			INNER JOIN @NewBetLimitTbl tmp	ON tmp.SportType = main.sporttype AND tmp.BetType = main.bettype
		WHERE main.custid = @CustID
			AND (
					main.minbet		<> tmp.MinBet
				OR main.maxbet		<> tmp.MaxBet
				OR main.maxpermatch <> tmp.MaxperMatch
				OR main.MaxPerNumber		<> tmp.MaxPerNumber
				OR main.MaxPayoutPerMatch <> tmp.MaxPayoutPerMatch
				)
	END

	--START LOGGING

	-- Select ProductID and SettingLevel
	SELECT @ProductID = ProductID, @SettingLevel = SettingLevel
	FROM (	SELECT TOP 1 ps.ProductID, ps.SettingLevel
			FROM Dep_ProductSettingDetail AS psd WITH(NOLOCK)
				INNER JOIN	@NewBetLimitTbl AS tmp ON	psd.SportType = tmp.SportType AND	psd.BetType = tmp.BetType
				INNER JOIN Dep_ProductSetting AS ps WITH (NOLOCK) ON ps.ProductSettingID = psd.ProductSettingID
			WHERE	ps.ProductID IS NOT NULL
				AND	ps.SettingLevel IS NOT NULL
				AND ps.SettingType IN(10,12)	-- Bet Limit
		 ) iq

	-- Select ProductName
	SELECT @ProductName = p.ProductName
	FROM DBPRO.bodb02.dbo.Products AS p WITH(NOLOCK)
	WHERE p.ProductID = @ProductID

	-- Log old data
	IF @SettingLevel = 1			-- Product setting level
	BEGIN
		SET @xml = (
		SELECT	@ProductID						AS '@ProductID',
				@ProductName					AS '@ProductName',
				@CustID							AS '@CustID',
				@UserID							AS '@UserID',
				dbo.f_GetSubUsername(@SubAccID) AS '@SubAccName',
				@IP								AS '@IP',
				(
					SELECT	@ProductID							AS '@ProductID',
							CONVERT(DECIMAL(20,2), MinBet)		AS '@MinBet',
							CONVERT(DECIMAL(20,2), MaxBet)		AS '@MaxBet',
							CONVERT(DECIMAL(20,2), MaxPerMatch)	AS '@MaxPerMatch',
							CONVERT(DECIMAL(20,2), MaxPerNumber)AS '@MaxPerNumber',
							CONVERT(DECIMAL(20,2), MaxPayoutPerMatch)	AS '@MaxPayoutPerMatch'
					FROM @OldBetLimitTbl
					FOR XML PATH('BetLimit'),
					TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_Game_BetLimitUpd'),
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
				dbo.f_GetSubUsername(@SubAccID) AS '@SubAccName',
				@IP								AS '@IP',
				(
					SELECT	SportType							AS '@SportType',
							CONVERT(DECIMAL(20,2), MinBet)		AS '@MinBet',
							CONVERT(DECIMAL(20,2), MaxBet)		AS '@MaxBet',
							CONVERT(DECIMAL(20,2), MaxPerMatch)	AS '@MaxPerMatch',
							CONVERT(DECIMAL(20,2), MaxPerNumber)AS '@MaxPerNumber',
							CONVERT(DECIMAL(20,2), MaxPayoutPerMatch)	AS '@MaxPayoutPerMatch'
					FROM @OldBetLimitTbl
					FOR XML PATH('BetLimit'),
					TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_Game_BetLimitUpd'),
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
				dbo.f_GetSubUsername(@SubAccID) AS '@SubAccName',
				@IP								AS '@IP',
				(
					SELECT	BetType								AS '@BetType',
							CONVERT(DECIMAL(20,2), MinBet)		AS '@MinBet',
							CONVERT(DECIMAL(20,2), MaxBet)		AS '@MaxBet',
							CONVERT(DECIMAL(20,2), MaxPerMatch)	AS '@MaxPerMatch',
							CONVERT(DECIMAL(20,2), MaxPerNumber)AS '@MaxPerNumber',
							CONVERT(DECIMAL(20,2), MaxPayoutPerMatch)	AS '@MaxPayoutPerMatch'
					FROM @OldBetLimitTbl
					FOR XML PATH('BetLimit'),
					TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_Game_BetLimitUpd'),
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
				dbo.f_GetSubUsername(@SubAccID) AS '@SubAccName',
				@IP								AS '@IP',
				(
					SELECT	SportType							AS '@SportType',
							BetType								AS '@BetType',
							CONVERT(DECIMAL(20,2), MinBet)		AS '@MinBet',
							CONVERT(DECIMAL(20,2), MaxBet)		AS '@MaxBet',
							CONVERT(DECIMAL(20,2), MaxPerMatch)	AS '@MaxPerMatch',
							CONVERT(DECIMAL(20,2), MaxPerNumber)AS '@MaxPerNumber',
							CONVERT(DECIMAL(20,2), MaxPayoutPerMatch)	AS '@MaxPayoutPerMatch'
					FROM @OldBetLimitTbl
					FOR XML PATH('BetLimit'),
					TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_Game_BetLimitUpd'),
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
				dbo.f_GetSubUsername(@SubAccID) AS '@SubAccName',
				@IP								AS '@IP',
				(
					SELECT	@ProductID							AS '@ProductID',
							CONVERT(DECIMAL(20,2), MinBet)		AS '@MinBet',
							CONVERT(DECIMAL(20,2), MaxBet)		AS '@MaxBet',
							CONVERT(DECIMAL(20,2), MaxPerMatch)	AS '@MaxPerMatch',
							CONVERT(DECIMAL(20,2), MaxPerNumber)AS '@MaxPerNumber',
							CONVERT(DECIMAL(20,2), MaxPayoutPerMatch)	AS '@MaxPayoutPerMatch'
					FROM @NewBetLimitTbl
					FOR XML PATH('BetLimit'),
					TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_Game_BetLimitUpd'),
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
				dbo.f_GetSubUsername(@SubAccID) AS '@SubAccName',
				@IP								AS '@IP',
				(
					SELECT	SportType							AS '@SportType',
							CONVERT(DECIMAL(20,2), MinBet)		AS '@MinBet',
							CONVERT(DECIMAL(20,2), MaxBet)		AS '@MaxBet',
							CONVERT(DECIMAL(20,2), MaxPerMatch)	AS '@MaxPerMatch',
							CONVERT(DECIMAL(20,2), MaxPerNumber)AS '@MaxPerNumber',
							CONVERT(DECIMAL(20,2), MaxPayoutPerMatch)	AS '@MaxPayoutPerMatch'
					FROM @NewBetLimitTbl
					FOR XML PATH('BetLimit'),
					TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_Game_BetLimitUpd'),
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
				dbo.f_GetSubUsername(@SubAccID) AS '@SubAccName',
				@IP								AS '@IP',
				(
					SELECT	BetType								AS '@BetType',
							CONVERT(DECIMAL(20,2), MinBet)		AS '@MinBet',
							CONVERT(DECIMAL(20,2), MaxBet)		AS '@MaxBet',
							CONVERT(DECIMAL(20,2), MaxPerMatch)	AS '@MaxPerMatch',
							CONVERT(DECIMAL(20,2), MaxPerNumber)AS '@MaxPerNumber',
							CONVERT(DECIMAL(20,2), MaxPayoutPerMatch)	AS '@MaxPayoutPerMatch'
					FROM @NewBetLimitTbl
					FOR XML PATH('BetLimit'),
					TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_Game_BetLimitUpd'),
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
				dbo.f_GetSubUsername(@SubAccID) AS '@SubAccName',
				@IP								AS '@IP',
				(
					SELECT	SportType							AS '@SportType',
							BetType								AS '@BetType',
							CONVERT(DECIMAL(20,2), MinBet)		AS '@MinBet',
							CONVERT(DECIMAL(20,2), MaxBet)		AS '@MaxBet',
							CONVERT(DECIMAL(20,2), MaxPerMatch)	AS '@MaxPerMatch',
							CONVERT(DECIMAL(20,2), MaxPerNumber)AS '@MaxPerNumber',
							CONVERT(DECIMAL(20,2), MaxPayoutPerMatch)	AS '@MaxPayoutPerMatch'
					FROM @NewBetLimitTbl
					FOR XML PATH('BetLimit'),
					TYPE
				)
		FOR XML PATH('Acc_Dep_CustSetting_Game_BetLimitUpd'),
		TYPE
	)
	END
	SET @logSpData = REPLACE(CONVERT(VARCHAR(MAX), @xml), '" />', '"/"')

	SELECT @endRun = GETDATE()
		, @duration = DATEDIFF(MILLISECOND, @startRun, @endRun)

	BEGIN TRY
		EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP @UserID = @UserID
						, @CustID			= @CustID
						, @ActionID			= 2047
						, @TrackingValue	= @logSpData
						, @TrackingValue2	= @logSpData_Old
						, @duration			= @duration
	END TRY
	BEGIN CATCH
		EXEC bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP @UserID = @UserID
						, @CustID			= @CustID
						, @ActionID			= 2047
						, @TrackingValue	= @logSpData
						, @TrackingValue2	= @logSpData_Old
						, @duration			= @duration
	END CATCH
END

GO