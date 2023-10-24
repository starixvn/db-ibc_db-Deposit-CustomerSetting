/*<info serverAlias="DBCUST-CUSTDB" executers="" viewers="" isFunction="0" isNested="1"></info>*/
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
		- 20220104@Eden: Archive_Dormant_Members_of_Licensee - Enhance_to_archive_periodically [#RM:125823]
		- 20230616@Tacy: Remove columns and code used by Colossus Bets, GD product [RedmineID: #188096]
		- 20230612@Eden: Enhance for Scale Out , move ActionID = 7 to sp Acc_Dep_DynamicCustSetting_11 [#179092]
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
			IF dbo.f_CheckRepTable('Dep_CustSpecialLevel') = 1 DELETE Dep_CustSpecialLevel WHERE CustID = @CustID
		END
		ELSE IF @ActionID = 8 
			AND (@@SERVERNAME IN ('DBTRANS','SITDBTRANS','TESTDBTRANS')  
				   OR  @@SERVERNAME LIKE '%SITEDB%'   
				   OR  @@SERVERNAME LIKE 'DBGRP%'   
				   OR  @@SERVERNAME LIKE 'SITDBGRP%'  
				   )  -- @DBTRANS => delete balance tables
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
		CREATE TABLE #LstCustID(CustID INT)

		INSERT INTO #LstCustID(CustID) 
		SELECT value 
		FROM string_split(@LstCustID,',')

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
			IF dbo.f_CheckRepTable('Dep_CustSpecialLevel') = 1 DELETE Dep_CustSpecialLevel WHERE CustID IN (SELECT CustID FROM #LstCustID)
		END
		ELSE IF @ActionID = 8 
			AND (@@SERVERNAME IN ('DBTRANS','SITDBTRANS','TESTDBTRANS','DB66')  
				   OR  @@SERVERNAME LIKE 'DBGRP%'   -- PRO
				   OR  @@SERVERNAME LIKE 'SITDBGRP%'  --SIT 
				   OR  @@SERVERNAME LIKE 'TESTSITEDB%'  --Local
				   )  -- @DBTRANS => delete balance tables
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

		DROP TABLE #LstCustID
	END
END