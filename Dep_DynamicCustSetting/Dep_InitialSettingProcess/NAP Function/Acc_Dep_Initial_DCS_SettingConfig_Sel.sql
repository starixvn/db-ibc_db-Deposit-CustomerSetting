/*<info serverAlias="DBGLOB-GlobCustDB" executers="wsv_nap" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_Initial_DCS_SettingConfig_Sel]
AS
/*
	Created: 20220913@Eden
	Task : View Initial Setting config
	DB: DBGLOB-GlobCustDB
	Original:

	Revisions:  
	- 20220913@Eden: Flexible Initializing Deposit Customer Setting [RedmineID: #169648]
	- 20250120@Tacy: Move to GlobCustDB [RedmineID: #216870]

	Parameter Definition

	Example: 
		EXEC [Acc_Dep_Initial_DCS_SettingConfig_Sel] 
	
	Mapping site : EXEC DBACC.bodb02.dbo.Acc_SiteSel_Licensee
	Mapping Currency : EXEC DBAGE.bodb02.dbo.Acc_ExchangeCurrencySel  @mode  = 2
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
		,CAST(ISNULL(bs.ExistBetSetting,0) AS BIT) AS ExistBetSetting
	FROM  Dep_Initial_ProductConfig cf WITH(NOLOCK)
		OUTER APPLY (	SELECT TOP 1 1 AS ExistBetSetting
						FROM  Dep_Initial_BetSetting WITH(NOLOCK)
						WHERE cf.ConfigID = ConfigID
					) bs
	ORDER BY ConfigID DESC

	SELECT 1 AS StepID, 'Delete existing customer setting' AS StepName
	UNION ALL SELECT 2 AS StepID, 'Insert customer setting'
	UNION ALL SELECT 3 AS StepID, 'Insert setting for new customer'
END
GO


