ALTER FUNCTION f_Dep_CustSetting_SportBetTypeSettingSelect(@ProductID TINYINT, @SettingType SMALLINT) 
RETURNS TABLE 
AS
RETURN
	SELECT DISTINCT ps.ProductID ProductID, SportType,Bettype,IsLive, SettingType 
	FROM dbo.Dep_ProductSetting ps WITH(NOLOCK)
		INNER JOIN dbo.Dep_ProductSettingDetail pst WITH(NOLOCK) ON ps.ProductSettingID = pst.ProductSettingID
	WHERE (@ProductID IS NULL OR ps.ProductID = @ProductID ) AND (@SettingType IS NULL OR SettingType = @SettingType) 
			AND SettingStatus <= CASE WHEN (OBJECT_NAME(@@PROCID) LIKE '%[_]xtest%' 
			OR  OBJECT_NAME(@@PROCID) LIKE  '%[_]xpre%' 
			OR  OBJECT_NAME(@@PROCID) LIKE  '%[_]uat[1-9]%')
			THEN 1 ELSE 0 END
GO
GRANT SELECT ON f_Dep_CustSetting_SportBetTypeSettingSelect TO [bodbDownlineNet] 
GO
GRANT SELECT ON f_Dep_CustSetting_SportBetTypeSettingSelect TO [bodbLicenseeNet]
GO
GRANT SELECT ON f_Dep_CustSetting_SportBetTypeSettingSelect TO [bodbadminNet]

