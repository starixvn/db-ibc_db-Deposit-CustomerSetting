USE CustDB
GO

ALTER PROCEDURE dbo.Acc_3rdProductSelSuperStatus @ProductID INT
	, @CustID INT
	, @SupperStatus BIT = 0 OUTPUT
	, @DownlineStatus BIT = 0 OUTPUT
AS
/*
	Created: 20150313@Winne
	Task: select 3rd product status of super ( 12 GoldDeluxe)
	DB: DBCUST/CustDB
	Original:
	Revisions:
		- 20150612@Winnie: Add Microgaming
		- 20151105@Patrick: Support RnG Game & rename field named DisableMicroGame to DisableMicroGameLC

	Param's Explanation:
*/
BEGIN
	SET NOCOUNT ON
	DECLARE @StatusTable TABLE(ProductId TINYINT, SupperStatus BIT, DownlineStatus BIT, UplineStatus BIT)
	DECLARE @EnableMicrogameLC BIT, @EnableMicrogameRNG BIT, @UplineStatusLC BIT, @UplineStatusRnG BIT

	IF @ProductID = 14 -- Microgaming for both : LC & RnG
	BEGIN
		DECLARE @RoleId INT

		SELECT @EnableMicrogameLC = ISNULL(~ DisableMicrogameLC, 0)
			, @EnableMicrogameRNG= ISNULL(~ DisableMicrogameRNG, 0)
			, @RoleId = RoleId
		FROM CustInfo WITH (NOLOCK)
		WHERE CustID = @CustID

		--get upline status
		IF @RoleId = 1
		BEGIN
			SELECT @UplineStatusLC = ISNULL(~ DisableMicrogameLC, 0)
				, @UplineStatusRnG= ISNULL(~ DisableMicrogameRNG, 0)
			FROM dbo.custInfo WITH (NOLOCK)
			WHERE custid = (SELECT recommend FROM dbo.custInfo WITH (NOLOCK) WHERE custid = @CustID)
		END
		ELSE IF @RoleId = 2
		BEGIN
			SELECT @UplineStatusLC = ISNULL(~ DisableMicrogameLC, 0)
				, @UplineStatusRnG= ISNULL(~ DisableMicrogameRNG, 0)
			FROM dbo.custInfo WITH (NOLOCK)
			WHERE custid = (SELECT mrecommend FROM dbo.custInfo WITH (NOLOCK) WHERE custid = @CustID)
		END
		ELSE IF @RoleId = 3
		BEGIN
			SELECT @UplineStatusLC = ISNULL(~ DisableMicrogameLC, 0)
				, @UplineStatusRnG= ISNULL(~ DisableMicrogameRNG, 0)
			FROM dbo.custInfo WITH (NOLOCK)
			WHERE custid = (SELECT srecommend FROM dbo.custInfo WITH (NOLOCK) WHERE custid = @CustID)
		END
		ELSE IF @RoleId = 4--not checking the upline when the customer is the super
		BEGIN
			SELECT @UplineStatusLC = 1, @UplineStatusRnG= 1
		END

		CREATE TABLE #CustList14 (CustID INT)

		IF @RoleId = 4
		BEGIN
			INSERT INTO #CustList14 (CustID)
			SELECT s.CustID
			FROM dbo.Customer s WITH (NOLOCK)
				INNER JOIN dbo.Customer m WITH (NOLOCK) ON s.mrecommend = m.custid
			WHERE s.srecommend = @CustID
				AND s.custid <> @CustID
				AND m.Username NOT LIKE '%' + m.site + 'ACC%'
		END
		ELSE IF @RoleId = 3
		BEGIN
			INSERT INTO #CustList14 (CustID)
			SELECT m.CustID
			FROM dbo.Customer m WITH (NOLOCK)
				INNER JOIN dbo.Customer a WITH (NOLOCK) ON m.recommend = a.custid
			WHERE m.mrecommend = @CustID
				AND m.custid <> @CustID
				AND a.Username NOT LIKE '%' + a.site + 'ACC%'
		END
		ELSE
		BEGIN
			INSERT INTO #CustList14 (CustID)
			SELECT a.CustID
			FROM dbo.Customer a WITH (NOLOCK)
			WHERE a.recommend = @CustID
				AND a.custid <> @CustID
				AND a.Username NOT LIKE '%' + ISNULL(a.site, '') + 'ACC%'
		END
		--for Microgaming LC
		IF EXISTS (SELECT TOP 1 1
					FROM CustInfo a WITH (NOLOCK)
						INNER JOIN #CustList14 b ON a.CustID = b.CustID
					WHERE ISNULL(a.DisableMicrogameLC, 1) = 1)
				AND EXISTS (SELECT TOP 1 1 FROM #CustList14 b)
		BEGIN
			SELECT @DownlineStatus = 0
		END
		ELSE
		BEGIN
			SELECT @DownlineStatus = 1
		END

		INSERT INTO @StatusTable(ProductId, SupperStatus, DownlineStatus, UplineStatus)
		VALUES(14, @EnableMicrogameLC, @DownlineStatus, @UplineStatusLC)

		--for RnG
		IF EXISTS (
					SELECT TOP 1 1
					FROM CustInfo a WITH (NOLOCK)
						INNER JOIN #CustList14 b ON a.CustID = b.CustID
					WHERE ISNULL(a.DisableMicrogameRNG, 1) = 1)
				AND EXISTS (SELECT TOP 1 1 FROM #CustList14 b)
		BEGIN
			SELECT @DownlineStatus = 0
		END
		ELSE
		BEGIN
			SELECT @DownlineStatus = 1
		END

		INSERT INTO @StatusTable(ProductId, SupperStatus, DownlineStatus, UplineStatus)
		VALUES(17, @EnableMicrogameRNG, @DownlineStatus, @UplineStatusRnG)

		SELECT ProductId, SupperStatus, DownlineStatus, UplineStatus FROM @StatusTable

		DROP TABLE #CustList14

		RETURN
	END

	---
	SELECT @SupperStatus = IsEnabled
	FROM Dep_SupperProductSetting WITH (NOLOCK)
	WHERE CustID = @CustID
		AND ProductId = @ProductId

	IF @SupperStatus IS NULL
		SET @SupperStatus = 0

	CREATE TABLE #CustList (CustID INT)

	INSERT INTO #CustList (CustID)
	SELECT rm.CustID
	FROM Customer rm WITH (NOLOCK)
		INNER JOIN Customer ag WITH (NOLOCK)
		ON rm.recommend = ag.Custid
	WHERE rm.srecommend = @CustID
		AND rm.roleid = 1
		AND ag.Username NOT LIKE '%' + ag.site + 'ACC%'

	IF EXISTS (
			SELECT TOP 1 1
			FROM Dep_CustProductSetting a WITH (NOLOCK)
				INNER JOIN #CustList b
				ON a.CustID = b.CustID
			WHERE a.ProductId = @ProductId
				AND a.IsEnabled = 1
			)
		SELECT @DownlineStatus = 1
	ELSE
		SELECT @DownlineStatus = 0

	INSERT INTO @StatusTable(ProductId, SupperStatus, DownlineStatus, UplineStatus)
	VALUES(@ProductId, @SupperStatus, @DownlineStatus, 1)

	SELECT ProductId, SupperStatus, DownlineStatus, UplineStatus FROM @StatusTable
END
GO

GRANT EXECUTE ON [dbo].[Acc_3rdProductSelSuperStatus] TO [bodbadminNet] AS [dbo]
GO

GRANT EXECUTE ON [dbo].[Acc_3rdProductSelSuperStatus] TO [bodbDownlineNet] AS [dbo]
GO

GRANT EXECUTE ON [dbo].[Acc_3rdProductSelSuperStatus] TO [bodbExtAccNet] AS [dbo]
GO

GRANT VIEW DEFINITION ON [dbo].[Acc_3rdProductSelSuperStatus] TO [vnteam] AS [dbo]
