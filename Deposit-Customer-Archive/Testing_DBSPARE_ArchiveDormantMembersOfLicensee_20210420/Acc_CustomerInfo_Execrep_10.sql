/*<info serverAlias="DBSPARE-CUSTDB" executers="" viewers="vnteam" isFunction="0"></info>*/
ALTER PROCEDURE Acc_CustomerInfo_Execrep_10
	@CustID INT = -1
	,@ActionID SMALLINT = -1
	,@LstCustID VARCHAR(MAX) = ''
AS
/*
	Creator : Dominic
	Date : 2018-09-12
	Task : Delete/Update data on DBCUST
	DB: DBCUST/CustDB
	Revisions:
		- 20180912@Dominic: First commit
		- 20181206@Dominic: Add a new input param @LstCustID for batch processing - Redmine #105893
		- 20181218@Dominic: Change data type of input param @ActionID
	Parameter:
		@ActionID: 
				1: Update Dep_Customer_Archived.status = archived
				2: Update Dep_Customer_Archived.status = completed
				3: Update Dep_Customer_Archived.status = failed
				4: Update Dep_Customer_Archived.status = reactivation
				5: Delete Dep_Customer_Archived 
				6: Delete CustInfo/Customer
				7: Delete Customer Setting
				8: Delete balance tables
	
*/
BEGIN
	IF @CustID <> -1 --Update data for a specific customer
	BEGIN
		IF @ActionID IN (1,2,3,4)
		BEGIN
			IF dbo.f_CheckRepTable('Dep_Customer_Archived') = 1
			UPDATE Dep_Customer_Archived
			SET status= CASE 
							WHEN @ActionID = 1 THEN 'archived'
							WHEN @ActionID = 2 THEN 'completed'
							WHEN @ActionID = 3 THEN 'failed'
							WHEN @ActionID = 4 THEN 'reactivation'
						END
			WHERE CustID = @CustID
		END
		ELSE IF @ActionID = 5
		BEGIN
			IF dbo.f_CheckRepTable('Dep_Customer_Archived') = 1 DELETE Dep_Customer_Archived WHERE CustID = @CustID
		END
		ELSE IF @ActionID = 6
		BEGIN
			IF dbo.f_CheckRepTable('Customer') = 1 DELETE Customer WHERE CustID = @CustID
			IF dbo.f_CheckRepTable('custInfo') = 1 DELETE custInfo WHERE CustID = @CustID
		END
		ELSE IF @ActionID = 7
		BEGIN
			IF dbo.f_CheckRepTable('CustSettingGame') = 1 DELETE CustSettingGame WHERE CustID = @CustID
			IF dbo.f_CheckRepTable('CustVirtualSetting') = 1 DELETE CustVirtualSetting WHERE CustID = @CustID
			IF dbo.f_CheckRepTable('Dep_CustBetSetting_Member') = 1 DELETE Dep_CustBetSetting_Member WHERE CustID = @CustID
			IF dbo.f_CheckRepTable('Dep_CustCommRate') = 1 DELETE Dep_CustCommRate WHERE CustID = @CustID
			IF dbo.f_CheckRepTable('Dep_CustDiscountSetting_Member') = 1 DELETE Dep_CustDiscountSetting_Member WHERE CustID = @CustID
			IF dbo.f_CheckRepTable('Dep_CustProductSetting') = 1 DELETE Dep_CustProductSetting WHERE CustID = @CustID
			IF dbo.f_CheckRepTable('Dep_CustProductStatus') = 1 DELETE Dep_CustProductStatus WHERE CustID = @CustID
			IF dbo.f_CheckRepTable('Dep_CustPTSetting_Member') = 1 DELETE Dep_CustPTSetting_Member WHERE CustID = @CustID
			IF dbo.f_CheckRepTable('Dep_CustSetting') = 1 DELETE Dep_CustSetting WHERE CustID = @CustID
			IF dbo.f_CheckRepTable('Dep_CustSetting_AGCasino') = 1 DELETE Dep_CustSetting_AGCasino WHERE CustID = @CustID
			IF dbo.f_CheckRepTable('Dep_CustSetting3rd') = 1 DELETE Dep_CustSetting3rd WHERE CustID = @CustID
			IF dbo.f_CheckRepTable('Dep_CustSettingGame') = 1 DELETE Dep_CustSettingGame WHERE CustID = @CustID
			IF dbo.f_CheckRepTable('Dep_CustSettingMode') = 1 DELETE Dep_CustSettingMode WHERE CustID = @CustID
			IF dbo.f_CheckRepTable('Dep_CustSpecialLevel') = 1 DELETE Dep_CustSpecialLevel WHERE CustID = @CustID
			IF dbo.f_CheckRepTable('Dep_CustStakeLevel_Member') = 1 DELETE Dep_CustStakeLevel_Member WHERE CustID = @CustID
			IF dbo.f_CheckRepTable('CustGameType') = 1 DELETE CustGameType WHERE CustID = @CustID
		END
		ELSE IF @ActionID = 8 AND @@SERVERNAME = 'DBSPARE'
		BEGIN
		
			DELETE bodb02.dbo.BalCreditSports WITH(ROWLOCK,UPDLOCK)  WHERE CustID = @CustID
			DELETE bodb02.dbo.BalDebitSports WITH(ROWLOCK,UPDLOCK)  WHERE CustID = @CustID

			DELETE bodb02.dbo.BalCreditCasino WITH(ROWLOCK,UPDLOCK)  WHERE CustID = @CustID
			DELETE bodb02.dbo.BalDebitCasino WITH(ROWLOCK,UPDLOCK)  WHERE CustID = @CustID

			DELETE bodb02.dbo.BalCreditOthers WITH(ROWLOCK,UPDLOCK)  WHERE CustID = @CustID
			DELETE bodb02.dbo.BalDebitOthers WITH(ROWLOCK,UPDLOCK)  WHERE CustID = @CustID

			DELETE bodb02.dbo.BalCreditTransfer WITH(ROWLOCK,UPDLOCK)  WHERE CustID = @CustID
			DELETE bodb02.dbo.BalDebitTransfer WITH(ROWLOCK,UPDLOCK)  WHERE CustID = @CustID
		END
	END
	ELSE
	BEGIN --Update data for a list of customers
		DECLARE @XML XML
		SET @XML = N'<root><r>' + REPLACE(@LstCustID, ',', '</r><r>') + '</r></root>'

		CREATE TABLE #LstCustID(CustID INT)

		INSERT INTO #LstCustID(CustID) 
		SELECT r.value('.','INT')
		FROM @xml.nodes('//root/r') AS RECORDS(r)


		IF @ActionID IN (1,2,3,4)
		BEGIN
			IF dbo.f_CheckRepTable('Dep_Customer_Archived') = 1
			UPDATE Dep_Customer_Archived
			SET status= CASE 
							WHEN @ActionID = 1 THEN 'archived'
							WHEN @ActionID = 2 THEN 'completed'
							WHEN @ActionID = 3 THEN 'failed'
							WHEN @ActionID = 4 THEN 'reactivation'
						END
			WHERE CustID IN (SELECT CustID FROM #LstCustID)
		END
		ELSE IF @ActionID = 5
		BEGIN
			IF dbo.f_CheckRepTable('Dep_Customer_Archived') = 1 DELETE Dep_Customer_Archived WHERE CustID IN (SELECT CustID FROM #LstCustID)
		END
		ELSE IF @ActionID = 6
		BEGIN
			IF dbo.f_CheckRepTable('Customer') = 1 DELETE Customer WHERE CustID IN (SELECT CustID FROM #LstCustID)
			IF dbo.f_CheckRepTable('custInfo') = 1 DELETE custInfo WHERE CustID IN (SELECT CustID FROM #LstCustID)
		END
		ELSE IF @ActionID = 7
		BEGIN
			IF dbo.f_CheckRepTable('CustSettingGame') = 1 DELETE CustSettingGame WHERE CustID IN (SELECT CustID FROM #LstCustID)
			IF dbo.f_CheckRepTable('CustVirtualSetting') = 1 DELETE CustVirtualSetting WHERE CustID IN (SELECT CustID FROM #LstCustID)
			IF dbo.f_CheckRepTable('Dep_CustBetSetting_Member') = 1 DELETE Dep_CustBetSetting_Member WHERE CustID IN (SELECT CustID FROM #LstCustID)
			IF dbo.f_CheckRepTable('Dep_CustCommRate') = 1 DELETE Dep_CustCommRate WHERE CustID IN (SELECT CustID FROM #LstCustID)
			IF dbo.f_CheckRepTable('Dep_CustDiscountSetting_Member') = 1 DELETE Dep_CustDiscountSetting_Member WHERE CustID IN (SELECT CustID FROM #LstCustID)
			IF dbo.f_CheckRepTable('Dep_CustProductSetting') = 1 DELETE Dep_CustProductSetting WHERE CustID IN (SELECT CustID FROM #LstCustID)
			IF dbo.f_CheckRepTable('Dep_CustProductStatus') = 1 DELETE Dep_CustProductStatus WHERE CustID IN (SELECT CustID FROM #LstCustID)
			IF dbo.f_CheckRepTable('Dep_CustPTSetting_Member') = 1 DELETE Dep_CustPTSetting_Member WHERE CustID IN (SELECT CustID FROM #LstCustID)
			IF dbo.f_CheckRepTable('Dep_CustSetting') = 1 DELETE Dep_CustSetting WHERE CustID IN (SELECT CustID FROM #LstCustID)
			IF dbo.f_CheckRepTable('Dep_CustSetting_AGCasino') = 1 DELETE Dep_CustSetting_AGCasino WHERE CustID IN (SELECT CustID FROM #LstCustID)
			IF dbo.f_CheckRepTable('Dep_CustSetting3rd') = 1 DELETE Dep_CustSetting3rd WHERE CustID IN (SELECT CustID FROM #LstCustID)
			IF dbo.f_CheckRepTable('Dep_CustSettingGame') = 1 DELETE Dep_CustSettingGame WHERE CustID IN (SELECT CustID FROM #LstCustID)
			IF dbo.f_CheckRepTable('Dep_CustSettingMode') = 1 DELETE Dep_CustSettingMode WHERE CustID IN (SELECT CustID FROM #LstCustID)
			IF dbo.f_CheckRepTable('Dep_CustSpecialLevel') = 1 DELETE Dep_CustSpecialLevel WHERE CustID IN (SELECT CustID FROM #LstCustID)
			IF dbo.f_CheckRepTable('Dep_CustStakeLevel_Member') = 1 DELETE Dep_CustStakeLevel_Member WHERE CustID IN (SELECT CustID FROM #LstCustID)
			IF dbo.f_CheckRepTable('CustGameType') = 1 DELETE CustGameType WHERE CustID IN (SELECT CustID FROM #LstCustID)
		END
		ELSE IF @ActionID = 8 AND @@SERVERNAME = 'DBSPARE'
		BEGIN
		
			DELETE bodb02.dbo.BalCreditSports WITH(ROWLOCK,UPDLOCK)  WHERE CustID IN (SELECT CustID FROM #LstCustID)
			DELETE bodb02.dbo.BalDebitSports WITH(ROWLOCK,UPDLOCK)  WHERE CustID IN (SELECT CustID FROM #LstCustID)

			DELETE bodb02.dbo.BalCreditCasino WITH(ROWLOCK,UPDLOCK)  WHERE CustID IN (SELECT CustID FROM #LstCustID)
			DELETE bodb02.dbo.BalDebitCasino WITH(ROWLOCK,UPDLOCK)  WHERE CustID IN (SELECT CustID FROM #LstCustID)

			DELETE bodb02.dbo.BalCreditOthers WITH(ROWLOCK,UPDLOCK)  WHERE CustID IN (SELECT CustID FROM #LstCustID)
			DELETE bodb02.dbo.BalDebitOthers WITH(ROWLOCK,UPDLOCK)  WHERE CustID IN (SELECT CustID FROM #LstCustID)

			DELETE bodb02.dbo.BalCreditTransfer WITH(ROWLOCK,UPDLOCK)  WHERE CustID IN (SELECT CustID FROM #LstCustID)
			DELETE bodb02.dbo.BalDebitTransfer WITH(ROWLOCK,UPDLOCK)  WHERE CustID IN (SELECT CustID FROM #LstCustID)
		END
	END
END