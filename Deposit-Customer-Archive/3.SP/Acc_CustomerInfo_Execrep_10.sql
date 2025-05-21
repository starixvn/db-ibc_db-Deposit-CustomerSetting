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
		- 20240724@Elodie: Replace SiteDB [RedmineID: #207738]
		- 20250113@Johnson: check inhouse for @ActionID = 5 [redmine: #207025]
		- 20250403@Tacy: Enhance Archive service to adapt IHR [#222312]
	Parameter:
		@ActionID: 
				1: Update Dep_Customer_Archived.status = archived
				2: Update Dep_Customer_Archived.status = completed
				3: Update Dep_Customer_Archived.status = failed
				4: Update Dep_Customer_Archived.status = reactivation
				5: Delete Dep_Customer_Archived 
				6: Delete CustInfo/Customer
				7: Delete Customer Setting (Dep_CustSpecialLevel)
				8: Delete balance tables
	
*/
BEGIN
	CREATE TABLE #LstCustID(CustID INT)

	--get cust list
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

	--@ActionID
	IF (dbo.f_CheckServerName() = 1 -- run on DBCUST ONLY	
		AND dbo.f_CheckEnvironment() = 'Active' -- run on KBT	
		)
		AND @ActionID < 8	
	BEGIN
		IF @ActionID IN (1,2,3,4)
		BEGIN
			UPDATE Dep_Customer_Archived
			SET status= CASE 
							WHEN @ActionID = 1 THEN 'archived'
							WHEN @ActionID = 2 THEN 'completed'
							WHEN @ActionID = 3 THEN 'failed'
							WHEN @ActionID = 4 THEN 'reactivation'
						END
				,RepUpdateTime=dbo.f_GetDateTime2()
			WHERE CustID IN (SELECT CustID FROM #LstCustID)
		END
		ELSE IF @ActionID = 5
		BEGIN		
			DELETE Dep_Customer_Archived 
			OUTPUT DELETED.custid, dbo.f_GetDateTime2()
			INTO Dep_Customer_Archived_Del_InHouse(CustID, RepUpdateTime)
			WHERE CustID IN (SELECT CustID FROM #LstCustID)
		END
		ELSE IF @ActionID = 6
		BEGIN
			DELETE Customer 
			OUTPUT DELETED.custid, dbo.f_GetDateTime2()
			INTO Customer_Del_InHouse(CustID, RepUpdateTime)
			WHERE CustID IN (SELECT CustID FROM #LstCustID)

			DELETE custInfo 
			OUTPUT DELETED.custid, dbo.f_GetDateTime2()
			INTO custInfo_Del_InHouse(CustID, RepUpdateTime)
			WHERE CustID IN (SELECT CustID FROM #LstCustID)
		END
		ELSE IF @ActionID = 7
		BEGIN
			DELETE Dep_CustSpecialLevel 
			OUTPUT DELETED.custid, dbo.f_GetDateTime2()
			INTO Dep_CustSpecialLevel_Del_InHouse(CustID, RepUpdateTime)
			WHERE CustID IN (SELECT CustID FROM #LstCustID)
		END
	END
	ELSE IF @ActionID = 8 
			AND (@@SERVERNAME IN ('DBTRANS','SITDBTRANS','TESTDBTRANS')  
				OR  @@SERVERNAME LIKE 'DBGRP%'   -- PRO
				OR  @@SERVERNAME LIKE 'SITDBGRP%'  --SIT 
				OR  @@SERVERNAME LIKE 'DBSITEC%'   -- PRO
				OR  @@SERVERNAME LIKE 'SITDBSITEC%'  --SIT 
				OR  @@SERVERNAME IN	('db67'	-- TESTDBGRP01L
									, 'TESTSITEDB2'			   --Local TEST
									,'db62\devsitedb', 'DEVDB061\DEVSITEDB2')  --Local DEV
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