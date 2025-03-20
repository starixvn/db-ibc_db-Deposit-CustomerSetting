/*<info serverAlias="DBCUST-CUSTDB" executers="" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_Initial_DCS_InitialSuper]
	@ConfigID INT,
	@IsProd BIT,
	@MaxcustID INT,
	@TotalRows INT = 0 OUTPUT
AS
/*
	Created: 20250121@Tacy
	Task : Job detect initial Setting Process
	DB: DBCUST-CUSTDB

	Revisions:  
	- 20250120@Tacy: Scale Out DBCUST - Migrate tables from CustDB to GlobCustdb [RedmineID: #216870]

	Example: 
		DECLARE @ConfigID INT, @MaxcustID INT, @IsProd BIT
		EXEC [Acc_Dep_Initial_DCS_InitialSuper]
			@ConfigID = 6,
			@IsProd = 1,
			@MaxcustID = 12345
			@TotalRows = @TotalRows OUTPUT
		SELECT @ConfigID AS ConfigID,
			   @IsProd AS IsProd,
			   @MaxcustID AS MaxcustID,
			   @TotalRows AS TotalRows
	
*/
BEGIN
	SET NOCOUNT ON
	
	SET @TotalRows=0
	
	-------------------> Start initial data for running process-----------------------------------
	DECLARE @Site VARCHAR(MAX), @Currency VARCHAR(MAX)
	DECLARE @TBL_site TABLE(SiteID INT,Site nvarchar(50) PRIMARY KEY)
	DECLARE @TBL_Currency TABLE(Currency INT PRIMARY KEY)

	SELECT @Site = Site, @Currency = Currency
	FROM Dep_Initial_ProductConfig WITH(NOLOCK)
	WHERE ConfigID = @ConfigID
		AND Status = 1 --Running

	IF @@ROWCOUNT = 0
	BEGIN
		PRINT 'No site/currency'
		GOTO ReturnSupers
	END

	--> Get List of Site/Currency by config
	INSERT INTO @TBL_site(SiteID,Site)
	SELECT DISTINCT s.siteid, s.site
	FROM Site s WITH(NOLOCK)
		INNER JOIN STRING_SPLIT(@Site,',') t ON s.siteid = t.value OR @Site = '0'
	WHERE s.isActive = 1
		AND s.isLicensee = 1

	INSERT INTO @TBL_Currency(Currency)
	SELECT DISTINCT e.ExchangeId
	FROM exchange e WITH(NOLOCK)
		INNER JOIN STRING_SPLIT(@Currency,',') t ON e.ExchangeId = t.value OR @Currency = '0'
	WHERE e.IsActive = 1
	  
	--> Insert supers to queue
	TRUNCATE TABLE Dep_Initial_Super

	INSERT INTO Dep_Initial_Super(CustID,CurrentStep)
	SELECT ci.custid, 0 AS CurrentStep
	FROM customer ci WITH (NOLOCK) 
		INNER JOIN @TBL_Currency ex ON ci.currency = ex.Currency
		INNER JOIN @TBL_site s ON ci.Site = s.Site
		INNER JOIN Dep_custsuper cs WITH (NOLOCK) ON ci.custid = cs.custid
		INNER JOIN custInfo c WITH(NOLOCK) ON c.custid = ci.custid
	WHERE ci.roleid = 4  
		AND ci.username NOT LIKE '3rdSuper%'
		AND c.Enabled = 1
		AND ci.custid <= @maxcustID

	SELECT @TotalRows=COUNT(1)
	FROM Dep_Initial_Super WITH (NOLOCK)

	ReturnSupers:
		SELECT CustID FROM Dep_Initial_Super WITH(NOLOCK)
END
GO