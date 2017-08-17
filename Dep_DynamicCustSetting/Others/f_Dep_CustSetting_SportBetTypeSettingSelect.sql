ALTER FUNCTION [dbo].[f_Dep_CustSetting_SportBetTypeSettingSelect](@ProductID TINYINT, @SettingType SMALLINT) 
RETURNS @SportBetTypeSetting TABLE (productID INT, SportType SMALLINT, Bettype SMALLINT, IsLive BIT, SettingType SMALLINT)
BEGIN 
	DECLARE @isTest BIT,@SQL NVARCHAR(100) = OBJECT_NAME(@@PROCID)

	IF  (@SQL like '%_xtest%' 
			OR  @SQL like '%_xpre%' 
			OR  @SQL like '%_uat1%'
			OR  @SQL like '%_uat2%'
			OR  @SQL like '%_uat3%'
			OR  @SQL like '%_uat4%')
	BEGIN
		SELECT @isTest = 1
	END
	ELSE
	BEGIN
		SELECT @isTest = 0
	END
	
	INSERT @SportBetTypeSetting
	SELECT DISTINCT ps.productID, SportType,Bettype,IsLive, SettingType 
	FROM dbo.Dep_ProductSetting ps WITH(NOLOCK)
		INNER JOIN dbo.Dep_ProductSettingDetail pst WITH(NOLOCK) ON ps.ProductSettingID = pst.ProductSettingID
	WHERE (@ProductID IS NULL OR ProductID = @ProductID ) AND (@SettingType IS NULL OR SettingType = @SettingType) 
			AND SettingStatus <= CASE WHEN @isTest = 1 THEN 1 ELSE 0 END
	
	RETURN
END
GO
GRANT SELECT ON f_Dep_CustSetting_SportBetTypeSettingSelect TO [bodbDownlineNet] 
GO
GRANT SELECT ON f_Dep_CustSetting_SportBetTypeSettingSelect TO [bodbLicenseeNet]
GO
GRANT SELECT ON f_Dep_CustSetting_SportBetTypeSettingSelect TO [bodbadminNet]

