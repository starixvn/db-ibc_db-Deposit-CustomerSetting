/*<info serverAlias="DBCUST-CUSTDB" executers="Dot_Member" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Dot_Dep_LicenseeProductSel] 
	@sitename			VARCHAR(10) = '',
	 @ErrCode INT = 0 OUTPUT,
	 @ErrMsg varchar(8000) = '' OUTPUT
AS  
/*  
 Created: 20210817@Winfred  
 Task: Get Product list which offered for selected licensees
 DB: DBCUST/CustDB  
 Original:  
 Revisions:  	
	- 20210623@Winfred: Get Product list which offered for selected licensees [RedmineID:#160130]
	- 20211015@Winfred: Enhance SP to get product list following UUS currency [RedmineID:#163260]
	
 Param's Explanation: 
 Sample exec:
	EXEC Dot_Dep_LicenseeProductSel @sitename='wtest45'
*/  
BEGIN
	SET NOCOUNT ON
	CREATE TABLE #supers (custid INT,DisableNumber	BIT,DisableKeno	BIT)
	CREATE TABLE #result (Productid INT,ProductName	VARCHAR(50))
	DECLARE @LicenseeID INT	
	SELECT @LicenseeID=LicenseeID FROM bodb_Licensee.dbo.Licensees WITH(NOLOCK) WHERE LicenseeName=@sitename
			
	INSERT INTO #supers(custid,DisableNumber,DisableKeno)
	SELECT ci.custid ,DisableNumber,cg.IsDisabled as DisableKeno
	FROM custInfo ci WITH (NOLOCK) 	
		INNER JOIN Dep_custsuper cs WITH (NOLOCK) ON ci.custid = cs.custid
		LEFT JOIN dbo.CustGameType cg WITH(NOLOCK) ON cs.custid = cg.CustID
	WHERE ci.roleid =4	
		AND ci.Enabled=1
		AND cs.site in (@sitename)
		AND cg.GameTypeID = 1
	
	-- Default Sportbook	
	IF 	EXISTS (SELECT TOP 1 1 FROM #supers ) 
	BEGIN
		INSERT INTO #result (Productid, ProductName) VALUES ( 1 , 'Sportsbook')
	END
	-- Check BA
	IF EXISTS (SELECT 1 FROM bodb_Licensee.dbo.LicenseeBAConfig  WITH (NOLOCK) WHERE LicenseeID = @LicenseeID AND EnableBA = 1)  
    BEGIN  
		 INSERT INTO #result (Productid, ProductName) VALUES ( -1 , 'BA')
    END 
	-- Check Number Game
	IF EXISTS (SELECT 1 FROM #supers WHERE DisableNumber = 0)  
    BEGIN  
		 INSERT INTO #result (Productid, ProductName)
		 SELECT Productid, ProductName  
		FROM DBPRO.bodb02.dbo.Products p WITH (NOLOCK)
		 WHERE ProductID = 3
    END 
    
    -- Check RNG Keno
	IF EXISTS (SELECT 1 FROM #supers WHERE DisableKeno = 0)  
    BEGIN  
		 INSERT INTO #result (Productid, ProductName)
		 SELECT Productid, ProductName  
		 FROM DBPRO.bodb02.dbo.Products p WITH (NOLOCK)
		 WHERE ProductID = 8
    END
    -- Check Cash Out
	IF EXISTS (SELECT 1 FROM #supers a INNER JOIN  Dep_SupperProductSetting b WITH(NOLOCK) ON a.custid = b.CustID WHERE b.ProductId = 25 AND b.IsEnabled = 1 )  
    BEGIN  
		 INSERT INTO #result (Productid, ProductName)
		 SELECT Productid, ProductName  
		 FROM DBPRO.bodb02.dbo.Products p WITH (NOLOCK) 
		 WHERE ProductID = 25
    END  
	
	-- Check DCS	
	INSERT INTO #result (Productid, ProductName)
	SELECT DISTINCT			T.ProductID, T.ProductName 
	FROM dbo.Dep_CustProductStatus CPS WITH (NOLOCK) 
	INNER JOIN #supers a ON a.custid = cps.CustID
	CROSS APPLY (	SELECT a.ProductID ,c.bitmapOrder,p.ProductName
					FROM dep_ProductSetting a WITH (NOLOCK) 
					INNER JOIN Dep_ProductSettingDetail b WITH (NOLOCK)ON a.ProductSettingID = b.ProductSettingID
					INNER JOIN Dep_ProductStatusProfile c WITH (NOLOCK)ON b.SportType  = c.Sporttype and b.BetType = c.Bettype
					LEFT JOIN DBPRO.bodb02.dbo.Products p  WITH (NOLOCK)ON p.ProductID = a.ProductID
					WHERE SettingType = 4)  AS T
     WHERE  ISNULL((SELECT value FROM dbo.f_CustSetting_ProductStatusSel(CPS.bitmapIsDisabled, T.bitmapOrder)),1) = 0 
     
    SELECT  Productid, ProductName
    FROM #result 
    ORDER BY Productid
     
	DROP TABLE 	#supers ,#result
END 
