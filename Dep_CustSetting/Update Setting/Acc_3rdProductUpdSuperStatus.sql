/*<info serverAlias="DBCUST-CUSTDB" executers="wsv_nap,bodbDownlineNet,bodbExtAccNet,svc_tig" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_3rdProductUpdSuperStatus] 
	@ProductID INT
	, @CustID INT
	, @IsEnable BIT
	, @ApplyToMember BIT = 0	
	, @UserID INT
	, @IP VARCHAR(40)
	, @Langkey VARCHAR(10) = 'en-US'
	, @ErrMsg VARCHAR(100) = '' OUTPUT
	, @InsBalCustList varchar(MAX) = '' OUTPUT
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
		- 20180717@Winnie: NAP - Enable Cash out: Adjust the setting to reflect 100% profit of Cash Out to group [RedmineID: #90870]
		- 20180924@Elodie: Migrate bodb_Licensee to DBCUST [Redmine:#99855]
		- 20190901@Elodie: Remove Inactive product [Redmine:#118699]
		- 20220722@Eden: LAP - Scale Out DBTrans  [redmine: #158293/#175297]

	Param's Explanation:
		- @InsBalCustList  --> cutsid list will call 2 sp insert balance on DBTRANS SiteDB: (ex: 'CustID1,CustID2')
                    EXEC bodb02.dbo.Dot_BalanceInsCredit @CustID = @CustID1/@CustID2
                    EXEC bodb02.dbo.Dot_BalanceInsDebit @CustID = @CustID1/@CustID2
*/
BEGIN
	SET NOCOUNT ON

	DECLARE @startRun DATETIME, @endRun DATETIME, @duration INT, @LogSPData VARCHAR(MAX)
		, @TrackingValue2 VARCHAR(MAX), @IsEnabled_Old BIT = 0, @ProductName VARCHAR(50), @CurrRow INT = 1
		, @RowPerBatch INT = 10000, @RowCount INT = 0,@DisableDownlines BIT,@HasDownline BIT = 0 ,@DisableDownlines_Old BIT = 0

	CREATE TABLE #CustList (RowNo INT IDENTITY(1, 1), CustID INT)

	SET @startRun = GETDATE()

	SELECT @ProductName = ProductName
	FROM bodb_Licensee.dbo.Product3rd WITH (NOLOCK)
	WHERE ProductID = @ProductID

	SELECT @IsEnabled_Old = ISNULL(IsEnabled, 0)
	FROM dbo.Dep_SupperProductSetting WITH (NOLOCK)
	WHERE CustID = @CustID
		AND ProductId = @ProductId

	-- Update Status for Super
	IF EXISTS (SELECT 1
				FROM dbo.Dep_SupperProductSetting WITH (NOLOCK)
				WHERE CustID = @CustID
					AND ProductId = @ProductId)
			
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
	ELSE 
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
									,@InsBalCustList = @InsBalCustList OUTPUT

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

		WHILE (@CurrRow <= @RowCount)
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

	EXEC Acc_WriteLog_UserLog_RunSP_Wrapper 
		@UserID = @UserID, 
		@CustID = @CustID, 
		@ActionID = 1154, 
		@TrackingValue = @LogSPData, 
		@TrackingValue2 = @TrackingValue2, 
		@duration = @duration	
END
GO
