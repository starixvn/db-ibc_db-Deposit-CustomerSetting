/*<info serverAlias="DBCUST-CUSTDB" executers="wsv_nap" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_Initial_DCS_SettingConfigDetail_Sel]
	@ConfigID INT
AS
/*
	Created: 20220913@Eden
	Task : View Initial Setting config detail
	DB: DBCUST/CUSTDB
	Original:

	Revisions:  
	- 20220913@Eden: Flexible Initializing Deposit Customer Setting [RedmineID: #169648]

	Parameter Definition

	Example: 
		EXEC [Acc_Dep_Initial_DCS_SettingConfigDetail_Sel] 
			@ConfigID = 3
	
	Mapping site : DBACC.bodb02..Acc_SiteSel_Licensee
	Mapping Currency : DBAGE.bodb02..Acc_ExchangeCurrencySel @mode  = 2
	*/
BEGIN
	SET NOCOUNT ON

	SELECT ConfigID
		,ProductID
		,SportTypeList
		,BetTypeList
		,Site
		,Currency
		,StartTime
		,EndTime
		,IsTest
		,Status
		,CurrentStep
		,ProcessedStep
		,Remark
	FROM  Dep_Initial_ProductConfig cf WITH(NOLOCK)
	WHERE ConfigID = @ConfigID

	SELECT cf.ConfigID
		,cf.SportType
		,cf.BetType
		,cf.IsLive
		,cf.SettingType
		,cf.IsDefault
		,DefaultValueSuper = CASE WHEN SettingName = 'Position Taking' THEN cf.DefaultValueSuper/100 ELSE cf.DefaultValueSuper END
		,DefaultValueMaster = CASE WHEN SettingName = 'Position Taking' THEN cf.DefaultValueMaster/100 ELSE cf.DefaultValueMaster END
		,DefaultValueAgent = CASE WHEN SettingName = 'Position Taking' THEN cf.DefaultValueAgent/100 ELSE cf.DefaultValueAgent END
		,DefaultValueMember = CASE WHEN SettingName = 'Position Taking' THEN cf.DefaultValueMember/100 ELSE cf.DefaultValueMember END
		,cf.SpecialRequirement 
		,t.SettingName
	FROM  Dep_Initial_ProductConfig_Detail cf WITH(NOLOCK)
		INNER JOIN Dep_ProductSettingType t WITH(NOLOCK) ON cf.SettingType = t.SettingType
	WHERE ConfigID = @ConfigID
	ORDER BY cf.SettingType,cf.SportType,cf.BetType
END
GO


