USE CustDB
GO

ALTER PROCEDURE dbo.Acc_3rdProductUpdSuperStatus @ProductID INT
	, @CustID INT
	, @IsEnable BIT
	, @ApplyToMember BIT = 0
	, @UserID INT
	, @IP VARCHAR(40)
	, @Langkey VARCHAR(10) = 'en-US'
	, @ErrMsg VARCHAR(100) = '' OUTPUT
AS
/*
	Created: 20150309@Winne
	Task: Update 3rd product status of super ( 12 GoldDeluxe)
	DB: DBCUST/CustDB
	Original:
	Revisions:
		- 20150612@Winnie: Add Microgaming & bettrade
		- 20150807@Winnie: Change way create bettrade member
		- 20151026@Jim: support feature #44780
		- 20151105@Patrick: Support RnG Game & rename field named DisableMicroGame to DisableMicroGameLC
		- 20160803@Winnie: #61777 BetTrade new commercial term

	Param's Explanation:
*/
BEGIN
	SET NOCOUNT ON

	DECLARE @startRun DATETIME, @endRun DATETIME, @duration INT, @LogSPData VARCHAR(MAX)
		, @TrackingValue2 VARCHAR(MAX), @IsEnabled_Old BIT = 0, @ProductName VARCHAR(50), @CurrRow INT = 1
		, @RowPerBatch INT = 10000, @RowCount INT = 0

	CREATE TABLE #CustList (RowNo INT IDENTITY(1, 1), CustID INT)

	SET @startRun = GETDATE()

	SELECT @ProductName = ProductName
	FROM DBLIC.bodb_Licensee.dbo.Product3rd WITH (NOLOCK)
	WHERE ProductID = @ProductID

	IF @Productid IN (14,17) -- Microgaming
	BEGIN
		DECLARE @RoleId INT

		SELECT @IsEnabled_Old = CASE WHEN @ProductID = 14 THEN ~ ISNULL(DisableMicrogameLC, 1)
									WHEN  @ProductID = 17 THEN ~ ISNULL(DisableMicrogameRNG, 1) END
			, @RoleId = RoleId
		FROM dbo.custInfo WITH (NOLOCK)
		WHERE CustID = @CustID
		
		--check concurrent users
		IF @IsEnable = @IsEnabled_Old
		BEGIN
			SELECT @ErrMsg = 'Invalid data because it has changed by some other people. Please refresh the page.'
			RETURN
		END

		--check upline status
		DECLARE @UplineStatus BIT
		IF @RoleId = 1
		BEGIN
			SELECT @UplineStatus = CASE WHEN @ProductID = 14 THEN ~ ISNULL(DisableMicrogameLC, 1)
										WHEN  @ProductID = 17 THEN ~ ISNULL(DisableMicrogameRNG, 1) END
			FROM dbo.custInfo WITH (NOLOCK)
			WHERE custid = (SELECT recommend FROM dbo.custInfo WITH (NOLOCK) WHERE custid = @CustID)
		END
		ELSE IF @RoleId = 2
		BEGIN
			SELECT @UplineStatus = CASE WHEN @ProductID = 14 THEN ~ ISNULL(DisableMicrogameLC, 1)
										WHEN  @ProductID = 17 THEN ~ ISNULL(DisableMicrogameRNG, 1) END
			FROM dbo.custInfo WITH (NOLOCK)
			WHERE custid = (SELECT mrecommend FROM dbo.custInfo WITH (NOLOCK) WHERE custid = @CustID)
		END
		ELSE IF @RoleId = 3
		BEGIN
			SELECT @UplineStatus = CASE WHEN @ProductID = 14 THEN ~ ISNULL(DisableMicrogameLC, 1)
										WHEN  @ProductID = 17 THEN ~ ISNULL(DisableMicrogameRNG, 1) END
			FROM dbo.custInfo WITH (NOLOCK)
			WHERE custid = (SELECT srecommend FROM dbo.custInfo WITH (NOLOCK) WHERE custid = @CustID)
		END
		ELSE IF @RoleId = 4--not checking the upline when the customer is the super
		BEGIN
			SET @UplineStatus = 1
		END
		
		IF @UplineStatus = 0 AND @IsEnable = 1
		BEGIN
			SELECT @ErrMsg = 'Upline was disabled. Can not enable.'
			RETURN
		END

		IF @ProductID = 14
		BEGIN
			UPDATE dbo.custInfo WITH (ROWLOCK)
			SET DisableMicrogameLC = ~ @IsEnable
			WHERE CustID = @CustID

			IF (@@ERROR <> 0)
			BEGIN
				SELECT @ErrMsg = 'Could not update'

				RETURN
			END
		END
		ELSE IF @ProductID = 17
		BEGIN
			UPDATE dbo.custInfo WITH (ROWLOCK)
			SET DisableMicrogameRNG = ~ @IsEnable
			WHERE CustID = @CustID

			IF (@@ERROR <> 0)
			BEGIN
				SELECT @ErrMsg = 'Could not update'

				RETURN
			END
		END

		IF @IsEnable = 0
			SET @ApplyToMember = 1

		-- Update Status for all downline members
		IF (@ApplyToMember = 1)
		BEGIN
			IF @RoleId = 4
			BEGIN
				INSERT INTO #CustList (CustID)
				SELECT rm.CustID
				FROM Customer rm WITH (NOLOCK)
					INNER JOIN Customer ag WITH (NOLOCK)
					ON rm.srecommend = ag.Custid
				WHERE rm.srecommend = @CustID
					AND ag.Username NOT LIKE '%' + ag.site + '%' + 'ACC%'
			END
			ELSE IF @RoleId = 3
			BEGIN
				INSERT INTO #CustList (CustID)
				SELECT rm.CustID
				FROM Customer rm WITH (NOLOCK)
					INNER JOIN Customer ag WITH (NOLOCK)
					ON rm.srecommend = ag.Custid
				WHERE rm.mrecommend = @CustID
					AND ag.Username NOT LIKE '%' + ag.site + '%' + 'ACC%'
			END
			ELSE
			BEGIN
				INSERT INTO #CustList (CustID)
				SELECT rm.CustID
				FROM Customer rm WITH (NOLOCK)
					INNER JOIN Customer ag WITH (NOLOCK)
					ON rm.srecommend = ag.Custid
				WHERE rm.recommend = @CustID
					AND ag.Username NOT LIKE '%' + ag.site + '%' + 'ACC%'
			END

			SELECT @RowCount = @@rowcount

			WHILE (@CurrRow <= @RowCount)
			BEGIN
				IF @ProductID = 14
				BEGIN
					UPDATE dbo.custInfo WITH (ROWLOCK, UPDLOCK)
					SET DisableMicrogameLC = ~ @IsEnable
					WHERE CustID IN (SELECT CustID
									FROM #CustList
									WHERE RowNo BETWEEN @CurrRow AND (@CurrRow + @RowPerBatch - 1))

					IF (@@ERROR <> 0)
					BEGIN
						SELECT @ErrMsg = 'Could not update'

						RETURN
					END
				END
				ELSE IF @ProductID = 17
				BEGIN
					UPDATE dbo.custInfo WITH (ROWLOCK, UPDLOCK)
					SET DisableMicrogameRNG = ~ @IsEnable
					WHERE CustID IN (SELECT CustID
									FROM #CustList
									WHERE RowNo BETWEEN @CurrRow AND (@CurrRow + @RowPerBatch - 1))

					IF (@@ERROR <> 0)
					BEGIN
						SELECT @ErrMsg = 'Could not update'

						RETURN
					END
				END

				SELECT @CurrRow = @CurrRow + @RowPerBatch

				WAITFOR DELAY '00:00:00.300'
			END

			DROP TABLE #CustList
		END
	--end 14
	END
	ELSE
	BEGIN
		SELECT @IsEnabled_Old = ISNULL(IsEnabled, 0)
		FROM dbo.Dep_SupperProductSetting WITH (NOLOCK)
		WHERE CustID = @CustID
			AND ProductId = @ProductId

		-- Update Status for Super
		IF (EXISTS (SELECT 1
					FROM dbo.Dep_SupperProductSetting WITH (NOLOCK)
					WHERE CustID = @CustID
						AND ProductId = @ProductId
						AND @ProductId NOT IN (14,17))
				)
		BEGIN
			UPDATE dbo.Dep_SupperProductSetting WITH (ROWLOCK)
			SET IsEnabled = @IsEnable
			WHERE CustID = @CustID
				AND ProductId = @ProductId

			IF (@@ERROR <> 0)
			BEGIN
				SELECT @ErrMsg = 'Could not update'

				RETURN
			END
		END
		ELSE IF (@ProductId NOT IN (14,17))
		BEGIN
			INSERT INTO dbo.Dep_SupperProductSetting (CustID, ProductId, IsEnabled)
			VALUES (@CustID, @ProductId, @IsEnable)

			IF (@@ERROR <> 0)
			BEGIN
				SELECT @ErrMsg = 'Could not insert'

				RETURN
			END
		END

		IF (@ProductId = 13) -- bettrade
		BEGIN
			SELECT a.userName + 'BetTrade' AS UserName, a.custid AS recommend, a.mrecommend, a.currency, a.site, a.refcode1
				, a.refcode2, a.ugroup, b.[closed], b.[MatchLimit], b.[VirtualMultiplier], b.[Enabled], b.[danger], b.[DisableHorseRacing]
				, b.[DisableFinancial], b.[DisableCasino], b.[SyncCasino], b.[danger2], b.[danger3], b.[DisableOutright], b.[DisableOpenTote]
				, b.[maxpermatch151_OT], b.[MaxPerMatch99MP], b.[DisableBingo], b.[DisableNumber], b.[maxpermatch161], b.[SyncBingo]
				, b.[MaxPerBall161], b.[MaxPerMatch151_AU], b.[MaxPerMatch152_UK], b.[MaxPerMatch152_AU], b.[MaxPerMatch153_AU]
				, b.[Disable151_AU], b.[Disable152_UK], b.[Disable152_AU], b.[Disable153_AU], b.[MaxTransferP2P], b.[IsAutoResetP2P]
				, b.[DisableP2P], b.[DisableFunP2P], b.[DisableLiveCasino], b.[SyncLiveCasino], b.[maxpermatch180], b.[DisableVirtualSports]
				, b.[HideVirtualSports], b.[Abnormal], b.[isAutoResetLiveCasino], b.[MaxWinLiveCasino], b.[DoubleCommLosing]
			INTO #tempBettrade
			FROM Customer a(NOLOCK)
				INNER JOIN custInfo b(NOLOCK)
				ON a.custid = b.custid
			WHERE a.srecommend = @CustID
				AND a.roleid = 2
				AND a.username NOT LIKE '%' + a.site + '%' + 'ACC%'
				AND (
					NOT EXISTS (
						SELECT 1
						FROM custInfo WITH (NOLOCK)
						WHERE username = a.userName + 'BetTrade'
						)
					)
				AND (
					NOT EXISTS (
						SELECT 1
						FROM customer WITH (NOLOCK)
						WHERE username = a.userName + 'BetTrade'
						)
					)
				AND (
					NOT EXISTS (
						SELECT 1
						FROM custsub WITH (NOLOCK)
						WHERE username = a.userName + 'BetTrade'
						)
					)

			INSERT INTO [dbo].[Customer] ([username], [username2], creatdate, creator, currency, roleid, srecommend, mrecommend
				, recommend, site, refcode1, refcode2, ugroup)
			SELECT [username], b.site + '$' + [username], GETDATE(), @UserId, b.Currency, 1, @CustId, b.mrecommend, b.recommend
				, b.site, refcode1, refcode2, ugroup
			FROM #tempBettrade b
			WHERE NOT EXISTS (
					SELECT TOP 1 1
					FROM Customer(NOLOCK)
					WHERE username = b.username
					)

			IF (@@ERROR <> 0)
			BEGIN
				SELECT @ErrMsg = 'Could not insert customer 1'

				RETURN
			END

			INSERT INTO [dbo].[custInfo] ([username], [custid], [currency], [roleid], [srecommend], [mrecommend], [recommend], [closed]
				, [MatchLimit], [VirtualMultiplier], [Enabled], [danger], [DisableHorseRacing], [DisableFinancial], [DisableCasino]
				, [SyncCasino], [danger2], [danger3], [DisableOutright], [DisableOpenTote], [maxpermatch151_OT], [MaxPerMatch99MP]
				, [DisableBingo], [DisableNumber], [maxpermatch161], [SyncBingo], [MaxPerBall161], [MaxPerMatch151_AU], [MaxPerMatch152_UK]
				, [MaxPerMatch152_AU], [MaxPerMatch153_AU], [Disable151_AU], [Disable152_UK], [Disable152_AU], [Disable153_AU]
				, [MaxTransferP2P], [IsAutoResetP2P], [DisableP2P], [DisableFunP2P], [DisableLiveCasino], [SyncLiveCasino], [maxpermatch180]
				, [DisableVirtualSports], [HideVirtualSports], [Abnormal], [isAutoResetLiveCasino], [MaxWinLiveCasino], [DoubleCommLosing], credit)
			SELECT a.[username], a.[custid], a.[currency], a.[roleid], a.[srecommend], a.[mrecommend], a.[recommend], b.[closed]
				, b.[MatchLimit], b.[VirtualMultiplier], b.[Enabled], b.[danger], b.[DisableHorseRacing], b.[DisableFinancial], b.[DisableCasino]
				, b.[SyncCasino], b.[danger2], b.[danger3], b.[DisableOutright], b.[DisableOpenTote], b.[maxpermatch151_OT], b.[MaxPerMatch99MP]
				, b.[DisableBingo], b.[DisableNumber], b.[maxpermatch161], b.[SyncBingo], b.[MaxPerBall161], b.[MaxPerMatch151_AU]
				, b.[MaxPerMatch152_UK], b.[MaxPerMatch152_AU], b.[MaxPerMatch153_AU], b.[Disable151_AU], b.[Disable152_UK], b.[Disable152_AU]
				, b.[Disable153_AU], b.[MaxTransferP2P], b.[IsAutoResetP2P], b.[DisableP2P], b.[DisableFunP2P], b.[DisableLiveCasino]
				, b.[SyncLiveCasino], b.[maxpermatch180], b.[DisableVirtualSports], b.[HideVirtualSports], b.[Abnormal], b.[isAutoResetLiveCasino]
				, b.[MaxWinLiveCasino], b.[DoubleCommLosing], 0
			FROM Customer(NOLOCK) a
				INNER JOIN #tempBettrade b
				ON a.username = b.username
			WHERE NOT EXISTS (
					SELECT TOP 1 1
					FROM custInfo(NOLOCK)
					WHERE username = a.username
						OR custid = a.custid
					)

			IF (@@ERROR <> 0)
			BEGIN
				SELECT @ErrMsg = 'Could not insert custinfo'

				DELETE a
				FROM Customer a(NOLOCK)
					INNER JOIN #tempBettrade b
					ON a.username = b.username

				DELETE a
				FROM custInfo a(NOLOCK)
					INNER JOIN #tempBettrade b
					ON a.username = b.username

				RETURN
			END

			INSERT INTO [dbo].[BetTradeCust] ([Custid])
			SELECT b.[Custid]
			FROM #tempBettrade a
				INNER JOIN Customer(NOLOCK) b
				ON a.username = b.username
			WHERE NOT EXISTS (
					SELECT TOP 1 1
					FROM [BetTradeCust](NOLOCK)
					WHERE custid = b.custid
					)

			IF (@@ERROR <> 0)
			BEGIN
				SELECT @ErrMsg = 'Could not insert BetTradeCust'

				DELETE a
				FROM Customer a(NOLOCK)
					INNER JOIN #tempBettrade b
					ON a.username = b.username

				DELETE a
				FROM custInfo a(NOLOCK)
					INNER JOIN #tempBettrade b
					ON a.username = b.username

				DELETE a
				FROM [BetTradeCust] a(NOLOCK)
					INNER JOIN Customer(NOLOCK) c
					ON a.custid = c.Custid
					INNER JOIN #tempBettrade b
					ON c.username = b.username

				RETURN
			END

			INSERT INTO [dbo].[BetTradeComm] ([Agentid], [IsBA], [BetTradeComm], [Licenseecomm],HouseDeductionRate,HousePT)
			SELECT a.recommend, 0, 0.03, 0.03,0.015,0.5
			FROM #tempBettrade a
			WHERE NOT EXISTS (
					SELECT TOP 1 1
					FROM [BetTradeComm](NOLOCK)
					WHERE [Agentid] = a.recommend
						AND [IsBA] = 0
					)

			IF (@@ERROR <> 0)
			BEGIN
				SELECT @ErrMsg = 'Could not insert BetTradeComm'

				DELETE a
				FROM Customer a(NOLOCK)
					INNER JOIN #tempBettrade b
					ON a.username = b.username

				DELETE a
				FROM custInfo a(NOLOCK)
					INNER JOIN #tempBettrade b
					ON a.username = b.username

				DELETE a
				FROM [BetTradeCust] a(NOLOCK)
					INNER JOIN Customer(NOLOCK) c
					ON a.custid = c.Custid
					INNER JOIN #tempBettrade b
					ON c.username = b.username

				DELETE a
				FROM [BetTradeComm] a(NOLOCK)
					INNER JOIN #tempBettrade b
					ON a.AgentId = b.recommend
				WHERE IsBA = 0

				RETURN
			END

			INSERT INTO [dbo].[BetTradeComm] ([Agentid], [IsBA], [BetTradeComm], [Licenseecomm],HouseDeductionRate,HousePT)
			SELECT a.recommend, 1, 0.03, 0,0.015,0.5
			FROM #tempBettrade a
			WHERE NOT EXISTS (
					SELECT TOP 1 1
					FROM [BetTradeComm](NOLOCK)
					WHERE [Agentid] = a.recommend
						AND [IsBA] = 1
					)

			IF (@@ERROR <> 0)
			BEGIN
				SELECT @ErrMsg = 'Could not insert BetTradeComm'

				DELETE a
				FROM Customer a(NOLOCK)
					INNER JOIN #tempBettrade b
					ON a.username = b.username

				DELETE a
				FROM custInfo a(NOLOCK)
					INNER JOIN #tempBettrade b
					ON a.username = b.username

				DELETE a
				FROM [BetTradeCust] a(NOLOCK)
					INNER JOIN Customer(NOLOCK) c
					ON a.custid = c.Custid
					INNER JOIN #tempBettrade b
					ON c.username = b.username

				DELETE a
				FROM [BetTradeComm] a(NOLOCK)
					INNER JOIN #tempBettrade b
					ON a.AgentId = b.recommend

				RETURN
			END

			DECLARE @bettradeUserName VARCHAR(50), @bettradeCustId INT, @bettradeAgentId INT, @bettradeCurrency INT
				, @Site VARCHAR(100), @ErrCode VARCHAR(100)

			WHILE EXISTS (
					SELECT TOP 1 1
					FROM #tempBettrade
					)
			BEGIN
				SELECT TOP 1 @bettradeUserName = a.UserName, @bettradeCustId = b.custid, @bettradeAgentId = b.recommend
					, @bettradeCurrency = b.currency, @Site = b.site
				FROM #tempBettrade a
					INNER JOIN Customer b WITH (NOLOCK)
					ON a.username = b.username

				----Insert Dep_Custsetting
				INSERT INTO [dbo].[Dep_CustSetting] ([custid], [bettype], [sporttype], [islive], [apositiontaking], [mpositiontaking]
					, [spositiontaking], [playerdiscount], [discount], [adiscount], [sdiscount], [minbet], [maxbet])
				SELECT @bettradeCustId, [bettype], [sporttype], [islive], [apositiontaking], [mpositiontaking], [spositiontaking]
					, [playerdiscount], [discount], [adiscount], [sdiscount], [minbet], [maxbet]
				FROM [Dep_CustSetting] a(NOLOCK)
				WHERE custid = @bettradeAgentId
					AND NOT EXISTS (
						SELECT TOP 1 1
						FROM [Dep_CustSetting] b(NOLOCK)
						WHERE b.custid = @bettradeCustId
							AND a.bettype = b.bettype
							AND a.sporttype = b.sporttype
							AND a.islive = b.islive
						)

				---------------------------------------------------------------------------------  
				IF (@@ERROR <> 0)
				BEGIN
					SELECT @ErrMsg = 'Could not insert BetTradeCust'

					DELETE a
					FROM Customer a(NOLOCK)
						INNER JOIN #tempBettrade b
						ON a.username = b.username

					DELETE a
					FROM custInfo a(NOLOCK)
						INNER JOIN #tempBettrade b
						ON a.username = b.username

					DELETE a
					FROM [BetTradeCust] a(NOLOCK)
						INNER JOIN Customer(NOLOCK) c
						ON a.custid = c.Custid
						INNER JOIN #tempBettrade b
						ON c.username = b.username

					DELETE a
					FROM [Dep_CustSetting] a(NOLOCK)
						INNER JOIN Customer(NOLOCK) c
						ON a.custid = c.Custid
						INNER JOIN #tempBettrade b
						ON c.username = b.username

					DELETE a
					FROM [BetTradeComm] a(NOLOCK)
						INNER JOIN #tempBettrade b
						ON a.AgentId = b.recommend

					RETURN
				END

				---------------------------------------------------------------------------------  
				-- Insert Balance
				EXEC DBTXN.bodb02.dbo.Dot_BalanceInsCredit @CustID = @CustID

				IF (@@ERROR <> 0)
				BEGIN
					SELECT @ErrMsg = 'Could not insert BetTradeCust'

					DELETE a
					FROM Customer a(NOLOCK)
						INNER JOIN #tempBettrade b
						ON a.username = b.username

					DELETE a
					FROM custInfo a(NOLOCK)
						INNER JOIN #tempBettrade b
						ON a.username = b.username

					DELETE a
					FROM [BetTradeCust] a(NOLOCK)
						INNER JOIN Customer(NOLOCK) c
						ON a.custid = c.Custid
						INNER JOIN #tempBettrade b
						ON c.username = b.username

					DELETE a
					FROM [Dep_CustSetting] a(NOLOCK)
						INNER JOIN Customer(NOLOCK) c
						ON a.custid = c.Custid
						INNER JOIN #tempBettrade b
						ON c.username = b.username

					DELETE a
					FROM [BetTradeComm] a(NOLOCK)
						INNER JOIN #tempBettrade b
						ON a.AgentId = b.recommend

					EXEC DBTXN.bodb02.dbo.Dot_BalanceDelCredit @CustID = @CustID --DELETE BalanceCredit WITH (ROWLOCK) WHERE custid = @custid   

					RETURN
				END

				EXEC DBTXN.bodb02.dbo.Dot_BalanceInsDebit @CustID = @CustID

				IF (@@ERROR <> 0)
				BEGIN
					SELECT @ErrMsg = 'Could not insert BetTradeCust'

					DELETE a
					FROM Customer a(NOLOCK)
						INNER JOIN #tempBettrade b
						ON a.username = b.username

					DELETE a
					FROM custInfo a(NOLOCK)
						INNER JOIN #tempBettrade b
						ON a.username = b.username

					DELETE a
					FROM [BetTradeCust] a(NOLOCK)
						INNER JOIN Customer(NOLOCK) c
						ON a.custid = c.Custid
						INNER JOIN #tempBettrade b
						ON c.username = b.username

					DELETE a
					FROM [Dep_CustSetting] a(NOLOCK)
						INNER JOIN Customer(NOLOCK) c
						ON a.custid = c.Custid
						INNER JOIN #tempBettrade b
						ON c.username = b.username

					DELETE a
					FROM [BetTradeComm] a(NOLOCK)
						INNER JOIN #tempBettrade b
						ON a.AgentId = b.recommend

					EXEC DBTXN.bodb02.dbo.Dot_BalanceDelCredit @CustID = @CustID --DELETE BalanceCredit WITH (ROWLOCK) WHERE custid = @custid   

					EXEC DBTXN.bodb02.dbo.Dot_BalanceDelDebit @CustID = @CustID

					RETURN
				END

				--Copy Customer Info to DBLIC.bodb_Licensee.dbo.LicenseeCustinfo
				EXEC DBLIC.bodb_Licensee.dbo.Lrf_CustomerInfoIns @CustID = @bettradeCustId
					, @Recommend = @bettradeAgentId, @Username = @bettradeUserName
					, @Username2 = @bettradeUserName, @Currency = @bettradeCurrency

				--Set default player comm  
				EXEC DBLIC.bodb_Licensee.dbo.Lrf_CustomerSetDefaultComm @LicenseeName = @site
					, @CustID = @CustID, @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT

				DELETE
				FROM #tempBettrade
				WHERE UserName = @bettradeUserName
			END
					--end bettrade
		END

		IF @IsEnable = 0
			SET @ApplyToMember = 1

		-- Update Status for all downline members
		IF (@ApplyToMember = 1)
		BEGIN
			INSERT INTO #CustList (CustID)
			SELECT rm.CustID
			FROM Customer rm WITH (NOLOCK)
				INNER JOIN Customer ag WITH (NOLOCK)
				ON rm.recommend = ag.Custid
			WHERE rm.srecommend = @CustID
				AND rm.roleid = 1
				AND ag.Username NOT LIKE '%' + ag.site + '%' + 'ACC%'

			SELECT @RowCount = @@rowcount

			WHILE (
					@CurrRow <= @RowCount
					AND @ProductId NOT IN (14,17)
					)
			BEGIN
				UPDATE dbo.Dep_CustProductSetting WITH (ROWLOCK, UPDLOCK)
				SET IsEnabled = @IsEnable
				WHERE ProductId = @ProductId
					AND CustID IN (
						SELECT CustID
						FROM #CustList
						WHERE RowNo BETWEEN @CurrRow
								AND (@CurrRow + @RowPerBatch - 1)
						)

				IF (@@ERROR <> 0)
				BEGIN
					SELECT @ErrMsg = 'Could not update'

					RETURN
				END

				INSERT INTO dbo.Dep_CustProductSetting (CustID, ProductId, IsEnabled)
				SELECT c.CustID, @ProductId, @IsEnable
				FROM #CustList c
				WHERE NOT EXISTS (
						SELECT 1
						FROM dbo.Dep_CustProductSetting cs WITH (NOLOCK)
						WHERE cs.CustID = c.CustID
							AND cs.ProductId = @ProductId
						)
					AND RowNo BETWEEN @CurrRow
						AND (@CurrRow + @RowPerBatch - 1)

				IF (@@ERROR <> 0)
				BEGIN
					SELECT @ErrMsg = 'Could not insert'

					RETURN
				END

				SELECT @CurrRow = @CurrRow + @RowPerBatch

				WAITFOR DELAY '00:00:00.300'
			END

			DROP TABLE #CustList
		END
	END

	-- Write log
	SET @endRun = GETDATE()
	SET @duration = DATEDIFF(MILLISECOND, @startRun, @endRun)

	SELECT @LogSPData = '<Acc_3rdProductUpdSuperStatus CustID="' + COALESCE(CAST(@CustID AS VARCHAR(50)), SPACE(1)) 
		+ '" ' + 'ProductName="' + COALESCE(CAST(@ProductName AS VARCHAR(50)), SPACE(1)) 
		+ '" ' + 'IsEnable="' + COALESCE(CAST(@IsEnable AS VARCHAR(1)), SPACE(1)) 
		+ '" ' + 'ApplyToMember="' + COALESCE(CAST(@ApplyToMember AS VARCHAR(1)), SPACE(1)) 
		+ '" ' + 'UserID="' + COALESCE(CAST(@UserID AS VARCHAR(50)), SPACE(1)) 
		+ '" ' + 'IP="' + COALESCE(CAST(@IP AS VARCHAR(40)), SPACE(1)) 
		+ '" ' + 'ErrMsg="' + COALESCE(CAST(@ErrMsg AS VARCHAR(8000)), SPACE(1)) + '" />'

	SELECT @TrackingValue2 = '<Acc_3rdProductUpdSuperStatus CustID="' + COALESCE(CAST(@CustID AS VARCHAR(50)), SPACE(1)) 
		+ '" ' + 'ProductName="' + COALESCE(CAST(@ProductName AS VARCHAR(50)), SPACE(1)) 
		+ '" ' + 'IsEnable="' + COALESCE(CAST(@IsEnabled_Old AS VARCHAR(1)), SPACE(1)) 
		+ '" ' + 'ApplyToMember=""' + SPACE(1) + 'UserID="' + COALESCE(CAST(@UserID AS VARCHAR(50)), SPACE(1)) 
		+ '" ' + 'IP="' + COALESCE(CAST(@IP AS VARCHAR(40)), SPACE(1)) 
		+ '" ' + 'ErrMsg="' + COALESCE(CAST(@ErrMsg AS VARCHAR(8000)), SPACE(1)) + '" />'

	BEGIN TRY
		EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP @UserID = @UserID, @CustID = @CustID
			, @ActionID = 1154, @TrackingValue = @LogSPData, @TrackingValue2 = @TrackingValue2, @duration = @duration
	END TRY

	BEGIN CATCH
		EXEC bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP @UserID = @UserID, @CustID = @CustID, @ActionID = 1154
			, @TrackingValue = @LogSPData, @TrackingValue2 = @TrackingValue2, @duration = @duration
	END CATCH
END
GO
GRANT EXECUTE ON [dbo].[Acc_3rdProductUpdSuperStatus] TO [bodbadminNet] AS [dbo]
GO

GRANT EXECUTE ON [dbo].[Acc_3rdProductUpdSuperStatus] TO [bodbDownlineNet] AS [dbo]
GO

GRANT EXECUTE ON [dbo].[Acc_3rdProductUpdSuperStatus] TO [bodbExtAccNet] AS [dbo]
GO

GRANT VIEW DEFINITION ON [dbo].[Acc_3rdProductUpdSuperStatus] TO [vnteam] AS [dbo]
GO