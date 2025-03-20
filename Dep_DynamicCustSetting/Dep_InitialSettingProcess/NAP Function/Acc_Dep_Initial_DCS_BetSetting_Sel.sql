/*<info serverAlias="DBGLOB-GlobCustDB" executers="wsv_nap" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_Initial_DCS_BetSetting_Sel]
	@ConfigID INT
AS
/*
	Created: 20220913@Eden
	Task : View Bet Setting config detail
	DB: DBGLOB-GlobCustDB
	Original:

	Revisions:  
	- 20220913@Eden: Flexible Initializing Deposit Customer Setting [RedmineID: #169648]
	- 20250120@Tacy: Move to GlobCustDB [RedmineID: #216870]

	Parameter Definition

	Example: 
		EXEC [Acc_Dep_Initial_DCS_BetSetting_Sel] 
			@ConfigID = 1
	
	*/
BEGIN
	SET NOCOUNT ON

	SELECT cf.ConfigID
		,cf.Currency
		,cf.SportType
		,cf.BetType
		,cf.MinBet
		,cf.MaxBet
		,cf.MaxPerMatch
		,cf.MaxPerNumber
		,cf.MaxPayoutPerMatch
		,e.currency AS CurrencyName
		,e.Code AS CurrencyCode
		,d.SettingType
	FROM  Dep_Initial_BetSetting cf WITH(NOLOCK)
		INNER JOIN Dep_Initial_ProductConfig_Detail d WITH(NOLOCK) 
			ON cf.ConfigID = d.ConfigID
			AND cf.SportType = d.SportType
			AND cf.BetType = d.BetType
		INNER JOIN Dep_ProductSettingType t WITH(NOLOCK) 
			ON d.SettingType = t.SettingType AND t.SettingName = 'Bet Setting'
		INNER JOIN exchange e WITH(NOLOCK) 
			ON cf.Currency = e.ExchangeId
	WHERE cf.ConfigID = @ConfigID
	ORDER BY e.currency, d.SportType, d.BetType, d.SettingType
END
GO


