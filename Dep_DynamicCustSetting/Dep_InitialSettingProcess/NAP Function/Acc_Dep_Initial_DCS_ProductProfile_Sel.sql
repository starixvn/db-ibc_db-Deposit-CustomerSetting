/*<info serverAlias="DBGLOB-GlobCustDB" executers="wsv_nap" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_Initial_DCS_ProductProfile_Sel]
AS
/*
	Created: 20220913@Eden
	Task : Get Product Profile maxtrix
	DB: DBGLOB-GlobCustDB
	Original:

	Revisions:  
	- 20220913@Eden: Flexible Initializing Deposit Customer Setting [RedmineID: #169648]
	- 20240117@Tacy: NAP - Merge VS1, VS2, VS3 as Virtual Sports [Redmine: #198008]
	- 20250120@Tacy: Move to GlobCustDB [RedmineID: #216870]

	Parameter Definition

	Example: 
		EXEC [Acc_Dep_Initial_DCS_ProductProfile_Sel] 

	*/
BEGIN
	SET NOCOUNT ON

	SELECT p.SettingType
		,d.SportType
		,d.BetType
		,d.IsLive
		,p.ProductID
		,t.SettingName
	FROM  Dep_ProductSetting p WITH(NOLOCK)
		INNER JOIN Dep_ProductSettingDetail d WITH(NOLOCK) ON d.ProductSettingID = p.ProductSettingID
		INNER JOIN Dep_ProductSettingType t WITH(NOLOCK) ON p.SettingType = t.SettingType
	WHERE t.SettingName IN('Position Taking','Bet Setting','Product Status','Stake Level')
		AND p.ProductID <> 31--exclude  Exchange
		AND SettingStatus<=1
END
GO