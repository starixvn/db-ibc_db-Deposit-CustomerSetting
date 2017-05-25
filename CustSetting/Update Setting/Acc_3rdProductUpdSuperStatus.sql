USE CustDB
GO

ALTER PROCEDURE [dbo].[Acc_3rdProductUpdSuperStatus] @ProductID INT
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
		- 20170227@Winnie: Add CashOut [RedmineID: #71727]
	Param's Explanation:
*/
BEGIN
	SET NOCOUNT ON

	DECLARE @startRun DATETIME, @endRun DATETIME, @duration INT, @LogSPData VARCHAR(MAX)
		, @TrackingValue2 VARCHAR(MAX), @IsEnabled_Old BIT = 0, @ProductName VARCHAR(50), @CurrRow INT = 1
		, @RowPerBatch INT = 10000, @RowCount INT = 0,@DisableDownlines BIT,@HasDownline BIT = 0 ,@DisableDownlines_Old BIT = 0

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
		IF (@IsEnabled_Old = @IsEnable )
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
		
		EXEC Acc_CustomerInsDummyTrade	@ProductID	=@ProductID	
										,@CustID	=@CustID
										,@UserID	=@UserID
										,@ErrMsg	=@ErrMsg



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