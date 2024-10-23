/*<info serverAlias="DBCUST-bodb_Licensee" executers="asv_cust" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[API_SiteBuilder_LicenseeDB_Ins]
	   @SiteName VARCHAR(10)  
	 , @LicenseeType VARCHAR(50)  
	 , @ProductList	VARCHAR(MAX) = ''
	 , @SystemisActive  VARCHAR(100) = 'LRF,OA,Accounting'  
	 , @ErrCode INT = 0 OUTPUT  
	 , @ErrMsg NVARCHAR(MAX) = '' OUTPUT  
	 , @LicenseeId INT = 0 OUTPUT

AS
/*
	Created: 20240705@Eden  
	Task : SiteBuider --> Create new licensee setting on Licensee DB
	DB: DBCUST-bodb_Licensee
	Original sp: 
	
	Revisions: 
		- 20240705@Eden  : Scale out DBCUST - Licensee Customer in GlobCustDB [redmine: #207474]

	Param's Explanation: 
		Sample Format:
*/			   					
BEGIN
	SET NOCOUNT ON;  
  
	DECLARE @EffectiveDate DATE = GETDATE()  
			, @ProductCode VARCHAR(MAX) = ''

	DECLARE @TmpProducts TABLE (ProductID INT)

	BEGIN TRY
		INSERT INTO @TmpProducts(ProductID)
		SELECT ProductID
		FROM OPENJSON(@ProductList) WITH (ProductID INT  '$.ProductID')
	END TRY
	BEGIN CATCH
		SELECT  @ErrMsg = N'Invalid Json Input'	, @ErrCode = 3 ;	
		RETURN
	END CATCH
	
	--default Sportsbook, Saba Promotion,Cash Out
	IF EXISTS(SELECT TOP 1 1 FROM @TmpProducts WHERE ProductID = 1)
	BEGIN
		SELECT @ProductCode=@ProductCode+'SB,SPR,CO'
	END

	--Number Games
	IF EXISTS(SELECT TOP 1 1 FROM @TmpProducts WHERE ProductID = 3)
	BEGIN
		SELECT @ProductCode=@ProductCode+',NG'
	END

	SELECT @ProductCode = @ProductCode + ',' + p.ProductPrefix
	FROM @TmpProducts t
		INNER JOIN  Product3rd p WITH(NOLOCK)
			ON t.ProductID = p.Productid
	WHERE t.ProductID NOT IN (1,3)

	 EXEC Nap_LM_Licensee_Insert_New  
	   @LicenseeName = @SiteName,  
	   @LicenseeType = @LicenseeType,  
	   @ProductCode = @ProductCode,  
	   @SystemisActive = @SystemisActive,  
	   @IsAllowMemberComm = 1,  
	   @EffectiveDate = @EffectiveDate,  
	   @ErrCode = @ErrCode OUTPUT,  
	   @ErrMsg = @ErrMsg OUTPUT,
	   @LicenseeId = @LicenseeId OUTPUT
     
	 DECLARE @Doing NVARCHAR(MAX)  
	 SET @Doing =  N'<Action value="Licensee_Insert">'  
		+ N'<RedmineId>0</RedmineId>'  
		+ N'<SpName>Nap_LM_Licensee_Insert_New</SpName>'  
		+ N'<UpdatedBy UserId="0" UserName="Site Builder" />'  
		+ N'<Licensee'  
		  + N' Description=""'  
		  + N' BrandName=""'  
		  + N' CompanyName=""'  
		  + N' SuperWildCard="' + @SiteName + 'Super"'  
		  + N' LicenseeType="' + @LicenseeType + '"'  
		  + N' IsSpecial="False"'  
		  + N' ProductCode="'+ @ProductCode +'"'  
		  + N' SystemIsActive="' + @SystemisActive + '"'  
		  + N' IsAllowMemberComm="True"'  
		  + N' EffectiveDate="' + CONVERT(VARCHAR, @EffectiveDate, 101) +'">'  
		  + @SiteName  
		  + N'</Licensee>'  
		+ (CASE WHEN ISNULL(@ErrMsg, '') <> '' THEN N'<Result>' + @ErrMsg + N'</Result>' ELSE '' END)  
		+ N'</Action>'  
  
	 EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_UserControl  
	   @CustID  = 0,  
	   @UserID  = 0,  
	   @ActionID = 5526,  
	   @Doing  = @Doing,  
	   @Duration =   0  
END	
GO
