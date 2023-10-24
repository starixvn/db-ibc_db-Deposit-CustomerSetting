/*<info serverAlias="DBCUST-CUSTDB" executers="" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE Acc_Dep_DynamicCustSetting_11 
	@CustID INT = -1
	,@ActionID SMALLINT = -1
	,@LstCustID VARCHAR(MAX) = ''
AS
/*
	Creator : 20230704@Eden
	Task : Delete custsetting for archive process
		use instead of Acc_CustomerInfo_Execrep_10, @ActionID = 7
	DB: DBCUST/CustDB
	Revisions:
		- 20230704@Eden: Enhance for Scale Out [#179092]
	Parameter:
		@ActionID: 
				7: Delete Customer Setting
	
*/
BEGIN
	CREATE TABLE #LstCustID(CustID INT)

	IF @CustID <> -1 -- Update Specific custID
	BEGIN
		INSERT INTO #LstCustID(CustID) 
		SELECT @CustID
	END
	ELSE -- Update list of customer
	BEGIN
		INSERT INTO #LstCustID(CustID) 
		SELECT value 
		FROM string_split(@LstCustID,',')
	END

	IF @ActionID = 7
	BEGIN
		IF dbo.f_CheckRepTable('CustVirtualSetting') = 1 DELETE CustVirtualSetting WHERE CustID IN (SELECT CustID FROM #LstCustID)
		IF dbo.f_CheckRepTable('Dep_CustBetSetting_Member') = 1 DELETE Dep_CustBetSetting_Member WHERE CustID IN (SELECT CustID FROM #LstCustID)
		IF dbo.f_CheckRepTable('Dep_CustDiscountSetting_Member') = 1 DELETE Dep_CustDiscountSetting_Member WHERE CustID IN (SELECT CustID FROM #LstCustID)
		IF dbo.f_CheckRepTable('Dep_CustProductSetting') = 1 DELETE Dep_CustProductSetting WHERE CustID IN (SELECT CustID FROM #LstCustID)
		IF dbo.f_CheckRepTable('Dep_CustProductStatus') = 1 DELETE Dep_CustProductStatus WHERE CustID IN (SELECT CustID FROM #LstCustID)
		IF dbo.f_CheckRepTable('Dep_CustPTSetting_Member') = 1 DELETE Dep_CustPTSetting_Member WHERE CustID IN (SELECT CustID FROM #LstCustID)
		IF dbo.f_CheckRepTable('Dep_CustSetting_AGCasino') = 1 DELETE Dep_CustSetting_AGCasino WHERE CustID IN (SELECT CustID FROM #LstCustID)
		IF dbo.f_CheckRepTable('Dep_CustSettingGame') = 1 DELETE Dep_CustSettingGame WHERE CustID IN (SELECT CustID FROM #LstCustID)
		IF dbo.f_CheckRepTable('Dep_CustSettingMode') = 1 DELETE Dep_CustSettingMode WHERE CustID IN (SELECT CustID FROM #LstCustID)
		IF dbo.f_CheckRepTable('Dep_CustStakeLevel_Member') = 1 DELETE Dep_CustStakeLevel_Member WHERE CustID IN (SELECT CustID FROM #LstCustID)
		IF dbo.f_CheckRepTable('Dep_CustBetSettingGame_Member') = 1 DELETE Dep_CustBetSettingGame_Member WHERE CustID IN (SELECT CustID FROM #LstCustID)
	END

	DROP TABLE #LstCustID
END