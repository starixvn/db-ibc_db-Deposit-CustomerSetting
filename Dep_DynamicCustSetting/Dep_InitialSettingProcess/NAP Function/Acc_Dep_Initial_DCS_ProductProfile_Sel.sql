/*<info serverAlias="DBCUST-CUSTDB" executers="bodbadminNet" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_Initial_DCS_ProductProfile_Sel]
AS
/*
	Created: 20220913@Eden
	Task : Get Product Profile maxtrix
	DB: DBCUST/CUSTDB
	Original:

	Revisions:  
	- 20220913@Eden: Flexible Initializing Deposit Customer Setting [RedmineID: #169648]

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
END
GO


