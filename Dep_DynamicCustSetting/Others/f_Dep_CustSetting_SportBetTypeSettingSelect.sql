/*<info serverAlias="DBCust-CustDB,DBACC-bodb02" selecters="wsv_nap,wsv_alp,wsv_alpv,wsv_xnap,wsv_lap" viewers="" isFunction="1" isNested="1"></info>*/
ALTER FUNCTION [dbo].[f_Dep_CustSetting_SportBetTypeSettingSelect] (@ProductID TINYINT, @SettingType SMALLINT, @SettingStatus TINYINT = 0) 
RETURNS TABLE 
/*
	Created by: 10191212
	Task: Get setting of product 
	DB: DBCust/CustDB, DBACC/bodb02(Replicated)
	Original: 
	
	Revisions:
		- 20191212@Eden: Add revision [Redmine: #123750]
		- 20240429@Tacy: Apply @SettingStatus [RedmineID: #201239]
	Explanation's Param:
		
*/   
AS
RETURN
	SELECT DISTINCT ps.ProductID, SportType, Bettype, IsLive, SettingType
		, ISNULL(MinDefaultValue,0) AS MinDefaultValue, MaxDefaultValue, IsApplyBA
		, ps.ProductSettingID, ps.SettingLevel
	FROM dbo.Dep_ProductSetting ps WITH(NOLOCK)
		INNER JOIN dbo.Dep_ProductSettingDetail pst WITH(NOLOCK) ON ps.ProductSettingID = pst.ProductSettingID
	WHERE (@ProductID IS NULL OR ps.ProductID = @ProductID)
		AND (@SettingType IS NULL OR SettingType = @SettingType) 
		AND SettingStatus <= @SettingStatus 
GO