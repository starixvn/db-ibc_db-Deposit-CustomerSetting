ALTER PROCEDURE [dbo].[Acc_Dep_DynamicCustSetting_04]
	@custid int,
	@roleid tinyint,
	@IsDisabled_XML VARCHAR(MAX) = NULL
AS
/*
	Created: 20160405@Helen
	Task : Update customer/custinfo settings
	DB: DBCust/CustDB

*/
BEGIN
	
	SET NOCOUNT ON 
	
	
	IF dbo.f_CheckRepTable('custinfo') = 0 
		OR dbo.f_CheckRepTable('Dep_CustProductStatus') = 0 
		RETURN
	
			
	--Check if XML is null or empty
	IF @IsDisabled_XML IS NULL OR @IsDisabled_XML='' RETURN
		
	CREATE TABLE #NewDisableStatTbl(
				SportType SMALLINT,
				BetType SMALLINT,
				IsDisabled BIT,
				IsDisabledDownline BIT
			)
	--Parse XML		
	DECLARE @iDoc INT
	EXEC sp_xml_preparedocument @iDoc OUTPUT, @IsDisabled_XML
		
	INSERT INTO #NewDisableStatTbl
	SELECT *
	FROM OPENXML (@iDoc, '/ROOT/ProductStatus',1) 
	WITH(SportType smallint, BetType smallint, IsDisabled BIT,IsDisabledDownline BIT
		)	
		
	EXEC sp_xml_removedocument @iDoc
	
	DECLARE @xmlStrDisabled XML
	DECLARE @xmlStrHidden XML
	
	SET @xmlStrDisabled = (
			SELECT (
					SELECT psp.bitmapOrder	AS '@b'
						, tmp.IsDisabled	AS '@s'
					FROM dbo.Dep_ProductStatusProfile psp WITH (NOLOCK)
						JOIN #NewDisableStatTbl tmp ON PSP.Sporttype = tmp.SportType AND psp.Bettype = tmp.BetType
	
					FOR XML PATH('r')
						, TYPE
					)
			FOR XML PATH('root')
				, TYPE
			)
	
	IF EXISTS (SELECT 1 FROM #NewDisableStatTbl WHERE IsDisabled = 0)
	BEGIN
		SET @xmlStrHidden = (
			SELECT (
					SELECT psp.bitmapOrder	AS '@b'
						, 0	AS '@s'
					FROM Dep_ProductStatusProfile psp (NOLOCK)
						JOIN #NewDisableStatTbl tmp ON PSP.Sporttype = tmp.SportType AND psp.Bettype = tmp.BetType
					WHERE tmp.IsDisabled=0	
					FOR XML PATH('r')
						, TYPE
					)
			FOR XML PATH('root')
				, TYPE
			)
	END	
			
	IF @RoleID=4
	BEGIN
		
		UPDATE T 
			SET bitmapIsDisabled = (SELECT bitmap FROM dbo.f_GenerateProductStatus_multiple (T.bitmapIsDisabled, CONVERT(VARCHAR(MAX),@xmlStrDisabled)))	
		FROM  dbo.Dep_CustProductStatus T
			INNER JOIN custInfo CI WITH (NOLOCK) ON T.CustID = CI.custid	
		WHERE CI.srecommend = @custid AND CI.roleid IN (1,2,3)
		
		IF EXISTS (SELECT 1 FROM #NewDisableStatTbl WHERE IsDisabled = 0)
		BEGIN
		
			UPDATE T 
				SET bitmapIsHidden = (SELECT bitmap FROM dbo.f_GenerateProductStatus_multiple (bitmapIsHidden, CONVERT(VARCHAR(MAX),@xmlStrHidden)))	
			FROM dbo.Dep_CustProductStatus T 
				INNER JOIN custInfo CI WITH (NOLOCK) ON T.CustID = CI.custid	
			WHERE CI.srecommend = @custid AND CI.roleid IN (1,2,3)
			
		END
		
	END
	
	ELSE IF @RoleID=3
	BEGIN
		UPDATE T 
			SET bitmapIsDisabled = (SELECT bitmap FROM dbo.f_GenerateProductStatus_multiple (T.bitmapIsDisabled, CONVERT(VARCHAR(MAX),@xmlStrDisabled)))	
		FROM  dbo.Dep_CustProductStatus T
			INNER JOIN custInfo CI WITH (NOLOCK) ON T.CustID = CI.custid	
		WHERE CI.mrecommend = @custid AND CI.roleid IN (1,2)
		
		IF EXISTS (SELECT 1 FROM #NewDisableStatTbl WHERE IsDisabled = 0)
		BEGIN
		
			UPDATE T WITH (UPDLOCK,ROWLOCK)
				SET bitmapIsHidden = (SELECT bitmap FROM dbo.f_GenerateProductStatus_multiple (bitmapIsHidden, CONVERT(VARCHAR(MAX),@xmlStrHidden)))	
			FROM dbo.Dep_CustProductStatus T 
				INNER JOIN custInfo CI WITH (NOLOCK) ON T.CustID = CI.custid	
			WHERE CI.mrecommend = @custid AND CI.roleid IN (1,2)
			
		END
	END
	ELSE IF @RoleID=2
	BEGIN
		UPDATE T 
			SET bitmapIsDisabled = (SELECT bitmap FROM dbo.f_GenerateProductStatus_multiple (T.bitmapIsDisabled, CONVERT(VARCHAR(MAX),@xmlStrDisabled)))	
		FROM  dbo.Dep_CustProductStatus T
			INNER JOIN custInfo CI WITH (NOLOCK) ON T.CustID = CI.custid	
		WHERE CI.recommend = @custid AND CI.roleid = 1
		
		IF EXISTS (SELECT 1 FROM #NewDisableStatTbl WHERE IsDisabled = 0)
		BEGIN
			UPDATE T 
				SET bitmapIsHidden = (SELECT bitmap FROM dbo.f_GenerateProductStatus_multiple (bitmapIsHidden, CONVERT(VARCHAR(MAX),@xmlStrHidden)))	
			FROM dbo.Dep_CustProductStatus T 
				INNER JOIN custInfo CI WITH (NOLOCK) ON T.CustID = CI.custid	
			WHERE CI.recommend = @custid AND CI.roleid = 1
			
		END
	END
	
END

GO
GRANT EXECUTE ON [dbo].[Acc_Dep_DynamicCustSetting_04] TO [bodbAdminNet] AS [dbo]
GO
GRANT VIEW DEFINITION ON [dbo].[Acc_Dep_DynamicCustSetting_04] TO [vnteam] AS [dbo]
