/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet,bodbDownlineNet,bodbExtAccNet,wsv_lap" viewers="vnteam" isFunction="0" isNested="1"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_CustSetting_Game_BetLimitCheck] 
	  @CustID		INT
	, @RoleID		INT
	, @AgentID		INT
	, @MasterID		INT
	, @SuperID		INT
	, @BetLimit		VARCHAR(MAX)
	, @ErrCode			INT				= 0		OUTPUT
	, @MsgType			INT				= 0		OUTPUT
	, @ErrMsg			NVARCHAR(MAX)	= ''	OUTPUT
AS
/*
	Created: 20220301@Eden
	Task: Check Customer's Bet Limits
	DB: DBCUST/CustDB
	Original:

	Revision:
		- 20220301@Eden: Deposit - Sportsbook - Revise customer settings [Redmine: #167898] 
		- 20230828@Luke: LAP - SEA Localization [Redmine: #187132]
		
	Param's Explanation:
	,@BetLimit	= '<ROOT>
				<BetLimit SportType="1" BetType="1" MinBet="10" MaxBet="100" MaxPerMatch="1000" MaxPayoutPerMatch="10000" />
				<BetLimit SportType="161" BetType="81" MinBet="10" MaxBet="100" MaxPerMatch="1000" MaxPerNumber="500"/>
		</ROOT>'
		
		

	*/
BEGIN
	SET NOCOUNT ON

	DECLARE @ErrorSportTypeTbl TABLE (
			SportType			SMALLINT
			, BetType			SMALLINT
			, MinBet			MONEY
			, MaxBet			MONEY
			, MaxPerMatch		MONEY
			, MaxPerNumber		MONEY
			, MaxPayoutPerMatch	MONEY
			, MinMinBet			MONEY
			, MaxMaxBet			MONEY
			, MaxMaxPerMatch	MONEY
			, MaxMaxPerNumber	MONEY
			, MaxMaxPayoutPerMatch	MONEY
		)
	DECLARE @xml		XML
	DECLARE @Currency INT
	DECLARE @UplineLimitTbl TABLE (
			SportType		SMALLINT
			, BetType		SMALLINT
			, MinBet		MONEY
			, MaxBet		MONEY
			, MaxPerMatch	MONEY
			, MaxPerNumber		MONEY
			, MaxPayoutPerMatch	MONEY
		)
	DECLARE @NewBetLimitTbl TABLE (
			SportType		SMALLINT
			, BetType		SMALLINT
			, MinBet		MONEY
			, MaxBet		MONEY
			, MaxPerMatch	MONEY
			, MaxPerNumber		MONEY
			, MaxPayoutPerMatch	MONEY
		)
	
	IF @BetLimit IS NULL
		OR @BetLimit = ''
		RETURN

	SELECT	@ErrCode	= 0
		,	@MsgType	= 0
		,	@ErrMsg		= ''

	--Parse XML data
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

	--Get currency of member
	SELECT @Currency = ci.currency
	FROM dbo.custInfo ci WITH(NOLOCK)
	WHERE ci.custid=@CustID
	
	IF @RoleID = 3
	BEGIN
		--Get super 's bet limit
		INSERT INTO @UplineLimitTbl(SportType,BetType,MinBet,MaxBet,MaxPerMatch,MaxPerNumber,MaxPayoutPerMatch)
		SELECT bl.SportType
			, bl.BetType
			, MAX(CASE 
						WHEN bl.MinBet = 0
							THEN NULL
						ELSE bl.MinBet
					END) AS MinBet
			, MIN(CASE 
						WHEN bl.MaxBet = 0
							THEN NULL
						ELSE bl.MaxBet
					END) AS MaxBet
			, MIN(CASE 
						WHEN bl.MaxPerMatch = 0
							THEN NULL
						ELSE bl.MaxPerMatch
					END) AS MaxPerMatch
			, MIN(CASE 
						WHEN bl.MaxPerNumber = 0
							THEN NULL
						ELSE bl.MaxPerNumber
					END) AS MaxPerNumber
			, MIN(CASE 
						WHEN bl.MaxPayoutPerMatch = 0
							THEN NULL
						ELSE bl.MaxPayoutPerMatch
					END) AS MaxPayoutPerMatch
		FROM dbo.Dep_CustBetSettingGame_Agent bl WITH (NOLOCK)
		INNER JOIN @NewBetLimitTbl tmp
			ON tmp.SportType	= bl.SportType
				AND tmp.BetType = bl.BetType
		WHERE bl.CustID			= @SuperID
		GROUP BY bl.SportType
			, bl.BetType
	END
	ELSE IF @RoleID = 2
	BEGIN
		--Get super/master 's bet limit
		INSERT INTO @UplineLimitTbl(SportType,BetType,MinBet,MaxBet,MaxPerMatch,MaxPerNumber,MaxPayoutPerMatch)
		SELECT bl.SportType
			, bl.BetType
			, MAX(CASE 
						WHEN bl.MinBet = 0
							THEN NULL
						ELSE bl.MinBet
					END) AS MinBet
			, MIN(CASE 
						WHEN bl.MaxBet = 0
							THEN NULL
						ELSE bl.MaxBet
					END) AS MaxBet
			, MIN(CASE 
						WHEN bl.MaxPerMatch = 0
							THEN NULL
						ELSE bl.MaxPerMatch
					END) AS MaxPerMatch
			, MIN(CASE 
						WHEN bl.MaxPerNumber = 0
							THEN NULL
						ELSE bl.MaxPerNumber
					END) AS MaxPerNumber
			, MIN(CASE 
						WHEN bl.MaxPayoutPerMatch = 0
							THEN NULL
						ELSE bl.MaxPayoutPerMatch
					END) AS MaxPayoutPerMatch
		FROM dbo.Dep_CustBetSettingGame_Agent bl WITH (NOLOCK)
		INNER JOIN @NewBetLimitTbl tmp
			ON tmp.SportType	= bl.SportType
				AND tmp.BetType = bl.BetType
		WHERE bl.CustID		= @SuperID
			OR bl.CustID	= @MasterID
		GROUP BY bl.SportType
			, bl.BetType
	END
	ELSE IF @RoleID = 1
	BEGIN
		--Get super/master 's bet limit
		INSERT INTO @UplineLimitTbl(SportType,BetType,MinBet,MaxBet,MaxPerMatch,MaxPerNumber,MaxPayoutPerMatch)
		SELECT bl.SportType
			, bl.BetType
			, MAX(CASE 
						WHEN bl.MinBet = 0
							THEN NULL
						ELSE bl.MinBet
					END) AS MinBet
			, MIN(CASE 
						WHEN bl.MaxBet = 0
							THEN NULL
						ELSE bl.MaxBet
					END) AS MaxBet
			, MIN(CASE 
						WHEN bl.MaxPerMatch = 0
							THEN NULL
						ELSE bl.MaxPerMatch
					END) AS MaxPerMatch
			, MIN(CASE 
						WHEN bl.MaxPerNumber = 0
							THEN NULL
						ELSE bl.MaxPerNumber
					END) AS MaxPerNumber
			, MIN(CASE 
						WHEN bl.MaxPayoutPerMatch = 0
							THEN NULL
						ELSE bl.MaxPayoutPerMatch
					END) AS MaxPayoutPerMatch
		FROM dbo.Dep_CustBetSettingGame_Agent bl WITH (NOLOCK)
		INNER JOIN @NewBetLimitTbl tmp
			ON tmp.SportType	= bl.SportType
				AND tmp.BetType = bl.BetType
		WHERE bl.CustID		= @SuperID
			OR bl.CustID	= @MasterID
			OR bl.CustID	= @AgentID
		GROUP BY bl.SportType
			, bl.BetType
	END
	
	--Get 1 error row
	INSERT INTO @ErrorSportTypeTbl(SportType,BetType,MinBet,MaxBet,MaxPerMatch,MaxPerNumber,MaxPayoutPerMatch
		,MinMinBet,MaxMaxBet,MaxMaxPerMatch,MaxMaxPerNumber,MaxMaxPayoutPerMatch)
	SELECT tmp.SportType
		, tmp.BetType
		, tmp.MinBet
		, tmp.MaxBet
		, tmp.MaxPerMatch
		, tmp.MaxPerNumber
		, tmp.MaxPayoutPerMatch
		, ISNULL(ubl.MinBet, 0)
		, ISNULL(ubl.MaxBet, 0)
		, ISNULL(ubl.MaxPerMatch, 0)
		, ISNULL(ubl.MaxPerNumber, 0)
		, ISNULL(ubl.MaxPayoutPerMatch, 0)
	FROM @NewBetLimitTbl tmp
		LEFT JOIN @UplineLimitTbl ubl ON tmp.SportType	= ubl.SportType	AND tmp.BetType = ubl.BetType
	WHERE	tmp.MinBet		< 0
		OR tmp.MaxBet		< 0
		OR tmp.MaxPerMatch	< 0
		OR tmp.MaxPerNumber		< 0
		OR tmp.MaxPayoutPerMatch	< 0
		OR (
				(
					tmp.MinBet	<> 0
					OR tmp.MaxBet	<> 0
					OR tmp.MaxPerMatch	<> 0
					OR tmp.MaxPerNumber	<> 0
					OR tmp.MaxPayoutPerMatch	<> 0
				)
				AND
				(
					tmp.MinBet		< ISNULL(ubl.MinBet,0)
					OR tmp.MaxBet		< ISNULL(ubl.MinBet,0)
					OR tmp.MaxPerMatch	< ISNULL(ubl.MinBet,0)
					OR tmp.MaxPerNumber		< ISNULL(ubl.MaxPerNumber,0)
					OR tmp.MaxPayoutPerMatch	< ISNULL(ubl.MaxPayoutPerMatch,0)
				)
			)
		OR (
			(
					tmp.MinBet	<> 0
				OR tmp.MaxBet	<> 0
				)
			AND tmp.MinBet > tmp.MaxBet
			)
		OR (
			(
					tmp.MaxBet		<> 0
				OR tmp.MaxPerMatch	<> 0
				)
			AND tmp.MaxBet > tmp.MaxPerMatch
			)
		OR (
			(
					tmp.MinBet		<> 0
				OR tmp.MaxPerMatch	<> 0
				)
			AND tmp.MinBet > tmp.MaxPerMatch
			)
		------------
		OR (
			(
					tmp.MaxPerNumber <> 0
				OR tmp.MaxBet	<> 0
				)
			AND tmp.MaxBet > tmp.MaxPerNumber
			)
		OR (
			(
					tmp.MaxPerNumber <> 0
				OR tmp.MaxPerMatch	<> 0
				)
			AND tmp.MaxPerNumber > tmp.MaxPerMatch
			)
		OR (
			(
					tmp.MaxPayoutPerMatch <> 0
				OR tmp.MaxPerMatch	<> 0
				)
			AND tmp.MaxPerMatch > tmp.MaxPayoutPerMatch
			)
		--------------
		OR (
			ubl.MinBet		> 0
			AND tmp.MinBet	> 0
			AND tmp.MinBet	< ubl.MinBet
			)
		OR (
			ubl.MaxBet		> 0
			AND tmp.MaxBet	> 0
			AND tmp.MaxBet	> ubl.MaxBet
			)
		OR (
			ubl.MaxPerMatch		> 0
			AND tmp.MaxPerMatch > 0
			AND tmp.MaxPerMatch > ubl.MaxPerMatch
			)
		------
		OR (
			ubl.MaxPerNumber > 0
			AND tmp.MaxPerNumber	> 0
			AND tmp.MaxPerNumber	> ubl.MaxPerNumber
			)
		OR (
			ubl.MaxPayoutPerMatch > 0
			AND tmp.MaxPayoutPerMatch > 0
			AND tmp.MaxPayoutPerMatch > ubl.MaxPayoutPerMatch
			)

	--IF there's no error data then return
	IF NOT EXISTS (
			SELECT TOP 1 1
			FROM @ErrorSportTypeTbl
			)
		RETURN

	--Check all setting >=0
	IF EXISTS(	SELECT TOP 1 1 
				FROM @ErrorSportTypeTbl tmp
				WHERE	tmp.MinBet		< 0
					OR tmp.MaxBet		< 0
					OR tmp.MaxPerMatch	< 0
					OR tmp.MaxPerNumber	< 0
					OR tmp.MaxPayoutPerMatch	< 0
					)
	BEGIN
		SET @xml = (
				SELECT 10003 AS '@MsgID'
					, 'Wrong Min Bet/ Max Bet/ Max Per Match/ Max Per Ball/ Max Payout Per Match.' AS '@Msg'
					, (
						SELECT tmp.SportType AS '@SportType'
							, tmp.BetType AS '@BetType'
						FROM @ErrorSportTypeTbl tmp
								
						WHERE	tmp.MinBet		< 0
							OR tmp.MaxBet		< 0
							OR tmp.MaxPerMatch	< 0
							OR tmp.MaxPerNumber	< 0
							OR tmp.MaxPayoutPerMatch	< 0

						FOR XML PATH('Row')
							, TYPE
						)
				FOR XML PATH('Root')
					, TYPE
				)		
		SET @ErrMsg = REPLACE(CONVERT(VARCHAR(MAX), @xml), '" />', '"/"')
		SET @MsgType = 71
		SET @ErrCode = 101
		
		RETURN
	END
	

	--Check MinBet<=MaxBet<=MaxPerMatch	
	IF EXISTS(SELECT TOP 1 1
			FROM @ErrorSportTypeTbl tmp
			WHERE (
					(
							tmp.MinBet	<> 0
						OR tmp.MaxBet	<> 0
						)
					AND tmp.MinBet > tmp.MaxBet
					)
				OR (
					(
							tmp.MaxBet		<> 0
						OR tmp.MaxPerMatch	<> 0
						)
					AND tmp.MaxBet > tmp.MaxPerMatch
					)
				OR (
					(
							tmp.MinBet		<> 0
						OR tmp.MaxPerMatch	<> 0
						)
					AND tmp.MinBet > tmp.MaxPerMatch
					))
	BEGIN
		SET @xml = (
				SELECT 10005 AS '@MsgID'
					, 'Min Bet must be less than Max Bet and Max Bet must be less than Max Per Match.' AS '@Msg'
					, (
						SELECT tmp.SportType AS '@SportType'
							, tmp.BetType AS '@BetType'
						FROM @ErrorSportTypeTbl tmp
						WHERE (
								(
										tmp.MinBet	<> 0
									OR tmp.MaxBet	<> 0
									)
								AND tmp.MinBet > tmp.MaxBet
								)
							OR (
								(
										tmp.MaxBet		<> 0
									OR tmp.MaxPerMatch	<> 0
									)
								AND tmp.MaxBet > tmp.MaxPerMatch
								)
							OR (
								(
										tmp.MinBet		<> 0
									OR tmp.MaxPerMatch	<> 0
									)
								AND tmp.MinBet > tmp.MaxPerMatch
								)
						FOR XML PATH('Row')
							, TYPE
						)
				FOR XML PATH('Root')
					, TYPE
				)		
		SET @ErrMsg = REPLACE(CONVERT(VARCHAR(MAX), @xml), '" />', '"/"')
		SET @MsgType = 71
		SET @ErrCode = 102
		
		RETURN
	END

	--Check MaxBet<=MaxPerNumber<=MaxPerMatch	
	IF EXISTS(SELECT TOP 1 1
			FROM @ErrorSportTypeTbl tmp
			WHERE (     (
							tmp.MaxPerNumber	<> 0
						OR tmp.MaxPerMatch	<> 0
						)
						AND tmp.MaxPerNumber > tmp.MaxPerMatch
					)
					OR (
						(
								tmp.MaxPerNumber		<> 0
							OR tmp.MaxBet	<> 0
							)
						AND tmp.MaxBet > tmp.MaxPerNumber
					)
				)
	BEGIN
		SET @xml = (
				SELECT 10005 AS '@MsgID'
					, 'Max Bet must be less than Max Per Ball and Max Per Ball must be less than Max Per Match.' AS '@Msg'
					, (
						SELECT tmp.SportType AS '@SportType'
							, tmp.BetType AS '@BetType'
						FROM @ErrorSportTypeTbl tmp
						WHERE (     (
									tmp.MaxPerNumber	<> 0
								OR tmp.MaxPerMatch	<> 0
								)
								AND tmp.MaxPerNumber > tmp.MaxPerMatch
							)
							OR (
								(
										tmp.MaxPerNumber		<> 0
									OR tmp.MaxBet	<> 0
									)
								AND tmp.MaxBet > tmp.MaxPerNumber
							)
						FOR XML PATH('Row')
							, TYPE
						)
				FOR XML PATH('Root')
					, TYPE
				)		
		SET @ErrMsg = REPLACE(CONVERT(VARCHAR(MAX), @xml), '" />', '"/"')
		SET @MsgType = 71
		SET @ErrCode = 102
		
		RETURN
	END

	--Check MaxPerMatch<= MaxPayoutPerMatch	
	IF EXISTS(SELECT TOP 1 1
			FROM @ErrorSportTypeTbl tmp
			WHERE (
							tmp.MaxPayoutPerMatch	<> 0
						OR tmp.MaxPerMatch	<> 0
						)
					AND tmp.MaxPerMatch > tmp.MaxPayoutPerMatch
					)
	BEGIN
		SET @xml = (
				SELECT 10005 AS '@MsgID'
					, 'Max Per Match must be less than Max Payout Per Match.' AS '@Msg'
					, (
						SELECT tmp.SportType AS '@SportType'
							, tmp.BetType AS '@BetType'
						FROM @ErrorSportTypeTbl tmp
						WHERE (
									tmp.MaxPayoutPerMatch	<> 0
								OR tmp.MaxPerMatch	<> 0
								)
							AND tmp.MaxPerMatch > tmp.MaxPayoutPerMatch
						FOR XML PATH('Row')
							, TYPE
						)
				FOR XML PATH('Root')
					, TYPE
				)		
		SET @ErrMsg = REPLACE(CONVERT(VARCHAR(MAX), @xml), '" />', '"/"')
		SET @MsgType = 71
		SET @ErrCode = 102
		
		RETURN
	END

	IF @RoleID IN (1, 2, 3)
	BEGIN
		--Check if MAX(upper.minbet) > 0 and minbet>0 then minbet>=MAX(upper.minbet)
		IF EXISTS(SELECT TOP 1 1
				FROM @ErrorSportTypeTbl tmp
				WHERE tmp.MinMinBet > 0
					AND tmp.MinBet	> 0
					AND tmp.MinBet	< tmp.MinMinBet)
		BEGIN
			SET @xml = (
					SELECT CASE 
								WHEN @RoleID = 3
									THEN 10016
								WHEN @RoleID = 2
									THEN 10019
								WHEN @RoleID = 1
									THEN 10006
								END 
							AS '@MsgID'
						, CASE 
								WHEN @RoleID = 3
									THEN 'Min Bet must be equal to or greater than Super Agent Min Bet'
								WHEN @RoleID = 2
									THEN 'Min Bet must be equal to or greater than Master Agent Min Bet'
								WHEN @RoleID = 1
									THEN 'Min Bet must be equal to or greater than Agent Min Bet'
								END 
							AS '@Msg'
						, (
							SELECT tmp.SportType AS '@SportType'
								, tmp.BetType AS '@BetType'
							FROM @ErrorSportTypeTbl tmp
							WHERE tmp.MinMinBet > 0
								AND tmp.MinBet	> 0
								AND tmp.MinBet	< tmp.MinMinBet
							FOR XML PATH('Row')
								, TYPE
							)
					FOR XML PATH('Root')
						, TYPE
					)		
			SET @ErrMsg = REPLACE(CONVERT(VARCHAR(MAX), @xml), '" />', '"/"')
			SET @MsgType = 71
			SET @ErrCode = 103
			
			RETURN
		END

		--Check if MIN(upper.maxbet) > 0 and maxbet>0 then maxbet<=MIN(upper.maxbet)
		IF EXISTS(SELECT TOP 1 1
				FROM @ErrorSportTypeTbl tmp
				WHERE tmp.MaxMaxBet > 0
					AND tmp.MaxBet	> 0
					AND tmp.MaxBet	> tmp.MaxMaxBet)
		BEGIN
			SET @xml = (
					SELECT CASE 
								WHEN @RoleID = 3
									THEN 10017
								WHEN @RoleID = 2
									THEN 10020
								WHEN @RoleID = 1
									THEN 10007
								END 
							AS '@MsgID'
						, CASE 
								WHEN @RoleID = 3
									THEN 'Max Bet must be equal to or less than Super Agent Max Bet'
								WHEN @RoleID = 2
									THEN 'Max Bet must be equal to or less than Master Agent Max Bet'
								WHEN @RoleID = 1
									THEN 'Max Bet must be equal to or less than Agent Max Bet'
								END 
							AS '@Msg'
						, (
							SELECT tmp.SportType AS '@SportType'
								, tmp.BetType AS '@BetType'
							FROM @ErrorSportTypeTbl tmp
							WHERE tmp.MaxMaxBet > 0
									AND tmp.MaxBet	> 0
									AND tmp.MaxBet	> tmp.MaxMaxBet
							FOR XML PATH('Row')
								, TYPE
							)
					FOR XML PATH('Root')
						, TYPE
					)		
			SET @ErrMsg = REPLACE(CONVERT(VARCHAR(MAX), @xml), '" />', '"/"')
			SET @MsgType = 71
			SET @ErrCode = 104
			
			RETURN
		END

		--Check if MIN(upper.maxpermatch)> 0 and maxpermatch>0 then maxpermatch<=MIN(upper.maxpermatch)
		IF EXISTS(SELECT TOP 1 1
				FROM @ErrorSportTypeTbl tmp
				WHERE tmp.MaxMaxPerMatch	> 0
					AND tmp.MaxPerMatch		> 0
					AND tmp.MaxPerMatch		> tmp.MaxMaxPerMatch)
		BEGIN
			SET @xml = (
					SELECT CASE 
								WHEN @RoleID = 3
									THEN 10018
								WHEN @RoleID = 2
									THEN 10021
								WHEN @RoleID = 1
									THEN 10008
								END 
							AS '@MsgID'
						, CASE 
								WHEN @RoleID = 3
									THEN 'Max Per Match must be equal to or less than Super Agent Max Per Match'
								WHEN @RoleID = 2
									THEN 'Max Per Match must be equal to or less than Master Agent Max Per Match'
								WHEN @RoleID = 1
									THEN 'Max Per Match must be equal to or less than Agent Max Per Match'
								END
							AS '@Msg'
						, (
							SELECT tmp.SportType AS '@SportType'
								, tmp.BetType AS '@BetType'
							FROM @ErrorSportTypeTbl tmp
							WHERE tmp.MaxMaxPerMatch	> 0
								AND tmp.MaxPerMatch		> 0
								AND tmp.MaxPerMatch		> tmp.MaxMaxPerMatch
							FOR XML PATH('Row')
								, TYPE
							)
					FOR XML PATH('Root')
						, TYPE
					)		
			SET @ErrMsg = REPLACE(CONVERT(VARCHAR(MAX), @xml), '" />', '"/"')
			SET @MsgType = 71
			SET @ErrCode = 105
			
			RETURN
		END

		--Check if MIN(upper.MaxPerNumber)> 0 and MaxPerNumber>0 then MaxPerNumber<=MIN(upper.MaxPerNumber)
		IF EXISTS(SELECT TOP 1 1
				FROM @ErrorSportTypeTbl tmp
				WHERE tmp.MaxMaxPerNumber	> 0
					AND tmp.MaxPerNumber		> 0
					AND tmp.MaxPerNumber		> tmp.MaxMaxPerNumber)
		BEGIN
			SET @xml = (
					SELECT CASE 
								WHEN @RoleID = 3
									THEN 10018
								WHEN @RoleID = 2
									THEN 10021
								WHEN @RoleID = 1
									THEN 10008
								END 
							AS '@MsgID'
						, CASE 
								WHEN @RoleID = 3
									THEN 'Max Per Ball must be equal to or less than Super Agent Max Per Ball'
								WHEN @RoleID = 2
									THEN 'Max Per Ball must be equal to or less than Master Agent Max Per Ball'
								WHEN @RoleID = 1
									THEN 'Max Per Ball must be equal to or less than Agent Max Per Ball'
								END
							AS '@Msg'
						, (
							SELECT tmp.SportType AS '@SportType'
								, tmp.BetType AS '@BetType'
							FROM @ErrorSportTypeTbl tmp
							WHERE tmp.MaxMaxPerNumber	> 0
								AND tmp.MaxPerNumber		> 0
								AND tmp.MaxPerNumber		> tmp.MaxMaxPerNumber
							FOR XML PATH('Row')
								, TYPE
							)
					FOR XML PATH('Root')
						, TYPE
					)		
			SET @ErrMsg = REPLACE(CONVERT(VARCHAR(MAX), @xml), '" />', '"/"')
			SET @MsgType = 71
			SET @ErrCode = 105
			
			RETURN
		END

		--Check if MIN(upper.MaxPayoutPerMatch)> 0 and MaxPayoutPerMatch>0 then MaxPayoutPerMatch<=MIN(upper.MaxPayoutPerMatch)
		IF EXISTS(SELECT TOP 1 1
				FROM @ErrorSportTypeTbl tmp
				WHERE tmp.MaxMaxPayoutPerMatch	> 0
					AND tmp.MaxPayoutPerMatch		> 0
					AND tmp.MaxPayoutPerMatch		> tmp.MaxMaxPayoutPerMatch)
		BEGIN
			SET @xml = (
					SELECT CASE 
								WHEN @RoleID = 3
									THEN 10018
								WHEN @RoleID = 2
									THEN 10021
								WHEN @RoleID = 1
									THEN 10008
								END 
							AS '@MsgID'
						, CASE 
								WHEN @RoleID = 3
									THEN 'Max Payout Per Match must be equal to or less than Super Agent Max Payout Per Match'
								WHEN @RoleID = 2
									THEN 'Max Payout Per Match must be equal to or less than Master Agent Max Payout Per Match'
								WHEN @RoleID = 1
									THEN 'Max Payout Per Match must be equal to or less than Agent Max Payout Per Match'
								END
							AS '@Msg'
						, (
							SELECT tmp.SportType AS '@SportType'
								, tmp.BetType AS '@BetType'
							FROM @ErrorSportTypeTbl tmp
							WHERE tmp.MaxMaxPayoutPerMatch	> 0
								AND tmp.MaxPayoutPerMatch		> 0
								AND tmp.MaxPayoutPerMatch		> tmp.MaxMaxPayoutPerMatch
							FOR XML PATH('Row')
								, TYPE
							)
					FOR XML PATH('Root')
						, TYPE
					)		
			SET @ErrMsg = REPLACE(CONVERT(VARCHAR(MAX), @xml), '" />', '"/"')
			SET @MsgType = 71
			SET @ErrCode = 105
			
			RETURN
		END
	END
END

GO