/*<info serverAlias="DBCUST-CUSTDB" executers="wsv_nap,bodbDownlineNet,bodbExtAccNet" viewers="" isFunction="0"></info>*/

ALTER PROCEDURE dbo.Acc_3rdProductSelSuperStatus 
	@ProductID INT
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
		- 20190901@Elodie: Remove Inactive product [Redmine:#118699]

	Param's Explanation:
*/
BEGIN
	SET NOCOUNT ON
	DECLARE @StatusTable TABLE(ProductId TINYINT, SupperStatus BIT, DownlineStatus BIT, UplineStatus BIT)	
	
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