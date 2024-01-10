/*<info serverAlias="DBTXN-bodb02" executers="" viewers="" isFunction="0" isNested="1"></info>*/
ALTER PROCEDURE [dbo].[Task_Dep_Cust_Archive_Clear_Balance] 
	@BatchSize INT = 100
AS
/*
	Creator : Dominic
	Date : 2018-09-12
	Task : Clear remaining balance and delete customer info when archiving dormant deposit members
	DB: DBTXN/bodb02
	Revisions:
		- 20180912@Dominic: First commit
		- 20181120@Dominic: Add new column custinfo.maxpermatch164 - Redmine: #104972
		- 20181120@Dominic: Enhance performance - Redmine: #105480
		- 20191002@Eden: 3rd party products - Remove InActive Products Phase 2 [Redmine: #118699]
		- 20200226@Eden: Archive_Dormant_Members_of_Licensee - Enhance_to_archive_periodically [#RM:125823]
		- 20201210@Eden: LAP - Split Transfer out of bettrans [#RM:164301]
		- 20220112@Eden: LAP - RNG Casino - Implement DCS Settings [Redmine: #166217] 
		- 20220608@Eden: Enhance - check exists before rollback data on licensee DB [#RM:125823]
		- 20230424@Tacy: Remove columns and code used by Colossus Bets, GD product [RedmineID: #188096]
		- 20230612@Eden: Enhance for Scale Out [#179092]
		- 20230310@Helios: Customer Setting - Migrate Sportsbook to DCS -Remove column DisableEsports [RedmineID: #193083] 
	Parameter:
		
	
*/
BEGIN

	DECLARE @CustID INT, @CustIDBalanceDummy INT, @ClosingBalance MONEY

	DECLARE @LicenseeID INT

	DECLARE @ErrCode INT, @Message VARCHAR(MAX), @ErrMsg VARCHAR(1000)
	
	DECLARE @LstCustID VARCHAR(MAX),@LogLstCustID VARCHAR(MAX), @LogMinCustID INT	

	CREATE TABLE #Dep_Customer_Archived(
		[CustID] INT,
		[CustIDBalanceDummy] INT,
		[ClosingBalance] MONEY,
		[CheckDate] DATETIME,
		[Recommend] INT,
		LicenseeID INT,
		BAStastus TINYINT, --0: No need to turn off | 1: Need to turn off | 2: Turning off | 3: Turn off failed | 4: Turn off sucessfully 
		TransBalStastus TINYINT --0: No need transfer balance | 1: Need to transfer balance | 2: Transfering balance | 3: Transfer balance failed | 4: Transfer balance sucessfully 
	)

	/******************************Step 1: Check data******************************/
	--Get members to clear balance
	INSERT INTO #Dep_Customer_Archived([CustID],[CustIDBalanceDummy],[ClosingBalance],[CheckDate],[Recommend],LicenseeID,BAStastus,TransBalStastus)
	SELECT TOP (@BatchSize) CusTID
			, CustIDBalanceDummy
			, -ClosingBalance
			, DATEADD(DAY,-2,ArchivedDate)
			, recommend
			, NULL
			, 0
			, 0
	FROM DBCUST.CustDB.dbo.Dep_Customer_Archived WITH(NOLOCK)
	WHERE Status = 'waiting'
	ORDER BY ArchivedDate, CustID

	CREATE UNIQUE CLUSTERED INDEX IX_CustID ON #Dep_Customer_Archived([CustID])

	IF NOT EXISTS(SELECT 1 FROM #Dep_Customer_Archived)
	BEGIN
		EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive 
				@Action='CLEAR-BALANCE'
				, @Status='Done'
				, @Message='There are not any dormant members in the waiting list'
		
		RETURN
	END

	--Prepare log infomation
	SELECT @LogLstCustID = STUFF((
		SELECT ',' + CAST(CustID as VARCHAR(15))
		FROM #Dep_Customer_Archived
		ORDER BY CustID
		FOR XML PATH('')
		), 1, 1, '');

	--Prepare log infomation
	SELECT @LogMinCustID = MIN(CustID)
	FROM #Dep_Customer_Archived

	SELECT @Message='Start clearing balance: ' + @LogLstCustID

	EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @CustID=@LogMinCustID
			, @Action='CLEAR-BALANCE'
			, @Status='OnProgress'
			, @Message=@Message
			
	IF EXISTS(SELECT 1 FROM #Dep_Customer_Archived WHERE CustID = CustIDBalanceDummy)
	BEGIN

		SELECT @LstCustID = STUFF((
		SELECT ',' + CAST(CusTID as VARCHAR(15))
		FROM #Dep_Customer_Archived
		WHERE CustID = CustIDBalanceDummy
		FOR XML PATH('')
		), 1, 1, '');

		SELECT @Message = 'Dummy account must be different from dormant member: ' + @LstCustID
		
		EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @CustID=@LogMinCustID
				, @Action='CLEAR-BALANCE'
				, @Status='Failed'
				, @Message=@Message

		--Update Dep_Customer_Archived.status = failed
		EXEC DBCUST.CustDB.dbo.Acc_CustomerInfo_Execrep_10 @LstCustID=@LstCustID, @ActionID=3 

		DELETE #Dep_Customer_Archived WHERE CustID = CustIDBalanceDummy
	END


	IF EXISTS (	
				SELECT 1 
				FROM #Dep_Customer_Archived t1
				LEFT JOIN  CustDB..Customer c (NOLOCK) ON c.custid = t1.CustID AND c.recommend = t1.Recommend AND c.roleid=1
				WHERE c.custid IS NULL
			)
		OR EXISTS (	
				SELECT 1 
				FROM #Dep_Customer_Archived t1
				LEFT JOIN  CustDB..custInfo c (NOLOCK) ON c.custid = t1.CustID AND c.recommend = t1.Recommend AND c.roleid=1
				WHERE c.custid IS NULL
			)
	BEGIN
		SELECT @LstCustID = STUFF((
		SELECT ',' + CAST(CusTID as VARCHAR(15))
		FROM (
			SELECT t1.CustID 
			FROM #Dep_Customer_Archived t1
			LEFT JOIN  CustDB..Customer c (NOLOCK) ON c.custid = t1.CustID AND c.recommend = t1.Recommend AND c.roleid=1
			WHERE c.custid IS NULL
			UNION
			SELECT t1.CustID 
			FROM #Dep_Customer_Archived t1
			LEFT JOIN  CustDB..custInfo c (NOLOCK) ON c.custid = t1.CustID AND c.recommend = t1.Recommend AND c.roleid=1
			WHERE c.custid IS NULL
		) tmp
		FOR XML PATH('')
		), 1, 1, '');


		SELECT @Message = 'Dormant members do not exist in Customer/Custinfo: ' + @LstCustID

		EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @CustID=@LogMinCustID
				, @Action='CLEAR-BALANCE'
				, @Status='Failed'
				, @Message=@Message
		
		--Update Dep_Customer_Archived.status = failed
		EXEC DBCUST.CustDB.dbo.Acc_CustomerInfo_Execrep_10 @LstCustID=@LstCustID, @ActionID=3 

		DELETE #Dep_Customer_Archived
		WHERE CustID IN (
			SELECT t1.CustID 
			FROM #Dep_Customer_Archived t1
			LEFT JOIN  CustDB..Customer c (NOLOCK) ON c.custid = t1.CustID AND c.recommend = t1.Recommend AND c.roleid=1
			WHERE c.custid IS NULL
			UNION ALL
			SELECT t1.CustID 
			FROM #Dep_Customer_Archived t1
			LEFT JOIN  CustDB..custInfo c (NOLOCK) ON c.custid = t1.CustID AND c.recommend = t1.Recommend AND c.roleid=1
			WHERE c.custid IS NULL
		)
	END

	IF EXISTS (	
				SELECT 1 
				FROM #Dep_Customer_Archived t1
				LEFT JOIN  CustDB..Customer c (NOLOCK) ON c.custid = t1.CustIDBalanceDummy AND c.roleid=1
				WHERE c.custid IS NULL
			)
		OR EXISTS (	
				SELECT 1 
				FROM #Dep_Customer_Archived t1
				LEFT JOIN  CustDB..custInfo c (NOLOCK) ON c.custid = t1.CustIDBalanceDummy AND c.roleid=1
				WHERE c.custid IS NULL
			)
	BEGIN
		SELECT @LstCustID = STUFF((
		SELECT ',' + CAST(CusTID as VARCHAR(15))
		FROM (
			SELECT t1.CustID 
			FROM #Dep_Customer_Archived t1
			LEFT JOIN  CustDB..Customer c (NOLOCK) ON c.custid = t1.CustIDBalanceDummy AND c.recommend = t1.Recommend AND c.roleid=1
			WHERE c.custid IS NULL
			UNION
			SELECT t1.CustID 
			FROM #Dep_Customer_Archived t1
			LEFT JOIN  CustDB..custInfo c (NOLOCK) ON c.custid = t1.CustIDBalanceDummy AND c.recommend = t1.Recommend AND c.roleid=1
			WHERE c.custid IS NULL
		) tmp
		FOR XML PATH('')
		), 1, 1, '');

		SELECT @Message = 'Dummy accounts for those dormant members do not exist in Customer/Custinfo: ' + @LstCustID

		EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @CustID=@LogMinCustID
				, @Action='CLEAR-BALANCE'
				, @Status='Failed'
				, @Message=@Message
		
		--Update Dep_Customer_Archived.status = failed
		EXEC DBCUST.CustDB.dbo.Acc_CustomerInfo_Execrep_10 @LstCustID=@LstCustID, @ActionID=3

		DELETE #Dep_Customer_Archived
		WHERE CustID IN (
			SELECT t1.CustID 
			FROM #Dep_Customer_Archived t1
			LEFT JOIN  CustDB..Customer c (NOLOCK) ON c.custid = t1.CustIDBalanceDummy AND c.recommend = t1.Recommend AND c.roleid=1
			WHERE c.custid IS NULL
			UNION ALL
			SELECT t1.CustID 
			FROM #Dep_Customer_Archived t1
			LEFT JOIN  CustDB..custInfo c (NOLOCK) ON c.custid = t1.CustIDBalanceDummy AND c.recommend = t1.Recommend AND c.roleid=1
			WHERE c.custid IS NULL
		)
	END

	IF EXISTS (SELECT 1 FROM #Dep_Customer_Archived WHERE CustID IN (SELECT CustID FROM DBCUST.CustDB.dbo.Dep_Customer_Archived_Exception WITH(NOLOCK)))
	BEGIN
		SELECT @LstCustID = STUFF((
		SELECT ',' + CAST(CustID as VARCHAR(15))
		FROM #Dep_Customer_Archived
		WHERE CustID IN (SELECT CustID FROM DBCUST.CustDB.dbo.Dep_Customer_Archived_Exception WITH(NOLOCK))
		FOR XML PATH('')
		), 1, 1, '');

		SELECT @Message = 'Dormant members are in exception list: ' + @LstCustID

		EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @CustID=@LogMinCustID
				, @Action='CLEAR-BALANCE'
				, @Status='Failed'
				, @Message=@Message
		
		--Update Dep_Customer_Archived.status = failed
		EXEC DBCUST.CustDB.dbo.Acc_CustomerInfo_Execrep_10 @LstCustID=@LstCustID, @ActionID=3

		DELETE #Dep_Customer_Archived
		WHERE CustID IN (SELECT CustID FROM DBCUST.CustDB.dbo.Dep_Customer_Archived_Exception WITH(NOLOCK))
	END

	IF EXISTS (
			SELECT 1 
			FROM #Dep_Customer_Archived t
			INNER JOIN CustDB..Customer c1(NOLOCK) ON c1.custid = t.CustID
			INNER JOIN CustDB..Customer c2(NOLOCK) ON c2.custid = t.CustIDBalanceDummy
			WHERE c1.recommend <> c2.recommend	
		)
	BEGIN
		SELECT @LstCustID = STUFF((
		SELECT ',' + CAST(t.CustID as VARCHAR(15))
		FROM #Dep_Customer_Archived t
		INNER JOIN CustDB..Customer c1(NOLOCK) ON c1.custid = t.CustID
		INNER JOIN CustDB..Customer c2(NOLOCK) ON c2.custid = t.CustIDBalanceDummy
		WHERE c1.recommend <> c2.recommend	
		FOR XML PATH('')
		), 1, 1, '');

		SELECT @Message = 'Dormant member and dummy account must be under the same line: ' + @LstCustID

		EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @CustID=@LogMinCustID
				, @Action='CLEAR-BALANCE'
				, @Status='Failed'
				, @Message=@Message
		
		--Update Dep_Customer_Archived.status = failed
		EXEC DBCUST.CustDB.dbo.Acc_CustomerInfo_Execrep_10 @LstCustID=@LstCustID, @ActionID=3 

		DELETE t
		FROM #Dep_Customer_Archived t
		INNER JOIN CustDB..Customer c1(NOLOCK) ON c1.custid = t.CustID
		INNER JOIN CustDB..Customer c2(NOLOCK) ON c2.custid = t.CustIDBalanceDummy
		WHERE c1.recommend <> c2.recommend	

	END

	IF EXISTS (SELECT 1 FROM  DBARCCUST.[Bodb_Archive_Customer_Licensee].[dbo].[Customer] WITH(NOLOCK) WHERE CustID IN  (SELECT CustID FROM #Dep_Customer_Archived))
		OR EXISTS (SELECT 1 FROM  DBARCCUST.[Bodb_Archive_Customer_Licensee].[dbo].Custinfo WITH(NOLOCK) WHERE  CustID IN  (SELECT CustID FROM #Dep_Customer_Archived))
	BEGIN
		SELECT @LstCustID = STUFF((
		SELECT ',' + CAST(CusTID as VARCHAR(15))
		FROM (
			SELECT CustID 
			FROM  DBARCCUST.[Bodb_Archive_Customer_Licensee].[dbo].[Customer] WITH(NOLOCK) 
			WHERE CustID IN  (SELECT CustID FROM #Dep_Customer_Archived)
			UNION
			SELECT CustID 
			FROM  DBARCCUST.[Bodb_Archive_Customer_Licensee].[dbo].Custinfo WITH(NOLOCK) 
			WHERE CustID IN  (SELECT CustID FROM #Dep_Customer_Archived)
		) tmp
		FOR XML PATH('')
		), 1, 1, '');

		SELECT @Message = 'There is already customer information of dormant members in Archive DB: ' + @LstCustID

		EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @CustID=@LogMinCustID
				, @Action='CLEAR-BALANCE'
				, @Status='Failed'
				, @Message=@Message
		
		--Update Dep_Customer_Archived.status = failed
		EXEC DBCUST.CustDB.dbo.Acc_CustomerInfo_Execrep_10 @LstCustID=@LstCustID, @ActionID=3

		DELETE #Dep_Customer_Archived
		WHERE CustID IN (
			SELECT CustID 
			FROM  DBARCCUST.[Bodb_Archive_Customer_Licensee].[dbo].[Customer] WITH(NOLOCK) 
			WHERE CustID IN  (SELECT CustID FROM #Dep_Customer_Archived)
			UNION ALL
			SELECT CustID 
			FROM  DBARCCUST.[Bodb_Archive_Customer_Licensee].[dbo].[Customer] WITH(NOLOCK) 
			WHERE CustID IN  (SELECT CustID FROM #Dep_Customer_Archived)
		)
	END

	--Update LicenseeID
	UPDATE t
	SET t.LicenseeID = lc.LicenseeID
	FROM #Dep_Customer_Archived t
	INNER JOIN DBCUST.bodb_Licensee.dbo.LicenseeCust lc WITH(NOLOCK) ON lc.CustID = t.Recommend


	IF EXISTS(SELECT 1 FROM #Dep_Customer_Archived WHERE LicenseeID IS NULL)
	BEGIN
		SELECT @LstCustID = STUFF((
		SELECT ',' + CAST(t.CustID as VARCHAR(15))
		FROM #Dep_Customer_Archived t
		WHERE LicenseeID IS NULL
		FOR XML PATH('')
		), 1, 1, '');

		SELECT @Message = 'Members do not belong to any licensees: ' + @LstCustID

		EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @CustID=@LogMinCustID
				, @Action='CLEAR-BALANCE'
				, @Status='Failed'
				, @Message=@Message
		
		--Update Dep_Customer_Archived.status = failed
		EXEC DBCUST.CustDB.dbo.Acc_CustomerInfo_Execrep_10 @LstCustID=@LstCustID, @ActionID=3

		DELETE #Dep_Customer_Archived WHERE LicenseeID IS NULL
	END

	CREATE TABLE #Active_Cust (CustID INT PRIMARY KEY)
	CREATE TABLE #BettingMember_AGC(CustID INT PRIMARY KEY)

	INSERT INTO #BettingMember_AGC(CustID)
	SELECT custid
	FROM OPENQUERY (DBPTCS, 'SELECT DISTINCT b.custid
							 FROM bodb_PlaytechCS.dbo.bettrans_AGCasino b with (NOLOCK)
							 WHERE transdate >= CONVERT(DATE,GETDATE() - 1)')

	INSERT INTO #Active_Cust(custid)
	SELECT CustID 
	FROM #Dep_Customer_Archived WHERE CustID IN (SELECT CustID FROM bodb02..Transfer (NOLOCK) WHERE bettype <> 20000)
	UNION
	SELECT CustID 
	FROM #Dep_Customer_Archived WHERE CustID IN (SELECT CustID FROM bodb02..bettrans (NOLOCK))
	UNION
	SELECT CustID 
	FROM #Dep_Customer_Archived WHERE CustID IN (SELECT CustID FROM bodb02..bettrans14 (NOLOCK))
	UNION
	SELECT CustID 
	FROM #Dep_Customer_Archived WHERE CustID IN (SELECT CustID FROM bodb02..bettransLC (NOLOCK))
	UNION
	SELECT CustID 
	FROM #Dep_Customer_Archived WHERE CustID IN (SELECT CustID FROM bodb02..bettransLC14 (NOLOCK))
	UNION
	SELECT CustID 
	FROM #Dep_Customer_Archived WHERE CustID IN (SELECT CustID FROM bodb02..bettransRNG (NOLOCK))
	UNION
	SELECT CustID 
	FROM #Dep_Customer_Archived WHERE CustID IN (SELECT CustID FROM bodb02..bettransRNG14 (NOLOCK))
	UNION
	SELECT CustID 
	FROM #Dep_Customer_Archived WHERE CustID IN (SELECT CustID FROM bodb02..translog (NOLOCK))
	UNION
	SELECT CustID 
	FROM #Dep_Customer_Archived WHERE CustID IN (SELECT CustID FROM bodb02..translog14 (NOLOCK))
	UNION
	SELECT CustID 
	FROM #Dep_Customer_Archived WHERE CustID IN (SELECT CustID FROM #BettingMember_AGC)

	IF EXISTS(SELECT 1 FROM #Active_Cust)
	BEGIN
		SELECT @LstCustID = STUFF((
		SELECT ',' + CAST(CusTID as VARCHAR(15))
		FROM (SELECT CustID FROM #Active_Cust) tmp
		FOR XML PATH('')
		), 1, 1, '');

		SELECT @Message = 'Dormant members have active bet or transfer tickets and will be removed from the waiting list: ' + @LstCustID

		EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @CustID=@LogMinCustID
				, @Action='CLEAR-BALANCE'
				, @Status='Failed'
				, @Message=@Message
		
		--Delete Dep_Customer_Archived
		EXEC DBCUST.CustDB.dbo.Acc_CustomerInfo_Execrep_10 @LstCustID=@LstCustID, @ActionID=5
		
		DELETE #Dep_Customer_Archived
		WHERE CustID IN (SELECT CustID FROM #Active_Cust)
	END
	--Check data in Cust_TrackingLastBetDate
	ELSE IF EXISTS(	SELECT 1 
					FROM #Dep_Customer_Archived t  
							INNER JOIN DBACC.bodb02.dbo.Cust_TrackingLastBetDate s WITH(NOLOCK) ON s.custid = t.custid and s.LastBetDate >= t.CheckDate
					)
	BEGIN
		SELECT @LstCustID = STUFF((
		SELECT ',' + CAST(CusTID as VARCHAR(15))
		FROM (
			SELECT t.CustID 
			FROM #Dep_Customer_Archived t  
					INNER JOIN DBACC.bodb02.dbo.Cust_TrackingLastBetDate s WITH(NOLOCK) ON s.custid = t.custid and s.LastBetDate >= t.CheckDate
		) tmp
		FOR XML PATH('')
		), 1, 1, '');

		SELECT @Message = 'Dormant members have active bet or transfer tickets and will be removed from the waiting list: ' + @LstCustID

		EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @CustID=@LogMinCustID
				, @Action='CLEAR-BALANCE'
				, @Status='Failed'
				, @Message=@Message
		
		--Delete Dep_Customer_Archived
		EXEC DBCUST.CustDB.dbo.Acc_CustomerInfo_Execrep_10 @LstCustID=@LstCustID, @ActionID=5
		
		DELETE t
		FROM #Dep_Customer_Archived t  
				INNER JOIN DBACC.bodb02.dbo.Cust_TrackingLastBetDate s WITH(NOLOCK) ON s.custid = t.custid and s.LastBetDate >= t.CheckDate
	END

	IF NOT EXISTS (SELECT 1 FROM #Dep_Customer_Archived)
	BEGIN
		SELECT @Message = 'All members in the batch are failed'

		EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @CustID = @LogMinCustID
					, @Action='CLEAR-BALANCE'
					, @Status='Failed'
					, @Message=@Message

		RETURN
	END

	/******************************Step 2: Turn off BA flag******************************/
	--Log info
	SELECT @LogLstCustID = STUFF((
			SELECT ',' + CAST(CustID as VARCHAR(15))
			FROM #Dep_Customer_Archived
			ORDER BY CustID
			FOR XML PATH('')
			), 1, 1, '');

	--If members' BA flags are turned on and they do not belong to DELA, we turn off BA flag
	IF EXISTS(
				SELECT 1
				FROM DBCUST.bodb_licensee.dbo.[LicenseeBAHistory] ba WITH (NOLOCK)
				INNER JOIN #Dep_Customer_Archived t ON ba.LicenseeID = t.LicenseeID AND ba.CustID = t.CustID
				WHERE ba.[Status] = 'Running' AND t.LicenseeID <> 7
			)
	BEGIN
		BEGIN TRY

			--Update BAStastus for those members whoes BA flags need to be turned off
			UPDATE t
			SET t.BAStastus = 1 --Need to be turned off
			FROM #Dep_Customer_Archived t
			WHERE t.LicenseeID <> 7 AND 
				EXISTS(SELECT 1
				FROM DBCUST.bodb_licensee.dbo.[LicenseeBAHistory] ba WITH (NOLOCK)
				WHERE ba.LicenseeID = t.LicenseeID AND ba.CustID = t.CustID AND ba.[Status] = 'Running')
			
			--Start a loop to turn off BA flags
			WHILE EXISTS(SELECT 1 FROM #Dep_Customer_Archived WHERE BAStastus=1)
			BEGIN
				UPDATE TOP (1) t
				SET BAStastus=2 --Turning off
					,@CustID=Custid
					,@LicenseeID=LicenseeID
				FROM #Dep_Customer_Archived t
				WHERE t.BAStastus=1

				SELECT @ErrCode = 0

				EXEC DBCUST.CustDB.dbo.Lrf_CustomerUpdMemberBAStatus @LicenseeID=@LicenseeID
						,@CustID=@CustID
						,@IsAdmin=1
						,@ModifyBy=10278938 --starixit
						,@IsBA=0
						,@IP=''
						,@ErrCode=@ErrCode output,@ErrMsg=@ErrMsg output

				IF @ErrCode <> 0
				BEGIN
					SELECT @Message = 'Failed to turn off BA flag (' + CAST(@CustID AS VARCHAR(15)) + '): ' + @ErrMsg 

					EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @CustID = @LogMinCustID
							, @Action='CLEAR-BALANCE'
							, @Status='Failed'
							, @Message= @Message

					--Update Dep_Customer_Archived.status = failed
					EXEC DBCUST.CustDB.dbo.Acc_CustomerInfo_Execrep_10 @CustID=@CustID, @ActionID=3

					UPDATE #Dep_Customer_Archived
					SET BAStastus=3 --failed
					WHERE CustID=@CustID

				END
				ELSE
				BEGIN
					UPDATE #Dep_Customer_Archived
					SET BAStastus=4 --success
					WHERE CustID=@CustID
				END

			END	
			
		END TRY
		BEGIN CATCH

			SELECT @Message = 'Exception error occurs while turning off BA flag: ' + ERROR_MESSAGE()

			RAISERROR(@Message, 11, 1)

			--Roll back for those whoes BA flags have been turned off sucessfully
			WHILE EXISTS(SELECT 1 FROM #Dep_Customer_Archived WHERE BAStastus=4)
			BEGIN
				UPDATE TOP (1) t
				SET BAStastus=1
					,@CustID=Custid
					,@LicenseeID=LicenseeID
				FROM #Dep_Customer_Archived t
				WHERE t.BAStastus=4

				EXEC DBCUST.CustDB.dbo.Lrf_CustomerUpdMemberBAStatus @LicenseeID=@LicenseeID
				,@CustID=@CustID
				,@IsAdmin=1
				,@ModifyBy=10278938 --starixit
				,@IsBA=1
				,@IP=''
				,@ErrCode=@ErrCode output,@ErrMsg=@ErrMsg output

			END		

			SELECT @Message='Exception error occurs while turning off BA flag: ' + @LogLstCustID

			EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @CustID=@LogMinCustID
					, @Action='CLEAR-BALANCE'
					, @Status='Failed'
					, @Message=@Message

			RETURN

		END CATCH

		SELECT @Message='Finish turning off BA flag: ' + @LogLstCustID

		EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @CustID=@LogMinCustID
				, @Action='CLEAR-BALANCE'
				, @Status='OnProgress'
				, @Message=@Message

	END

	--Delete dormant members whoes BA-Flag can not be turned off 
	DELETE #Dep_Customer_Archived WHERE BAStastus=3
	

	/******************************Step 3: Copy Customer/Custinfo to archive DB******************************/
	--Log info
	SELECT @LogLstCustID = STUFF((
			SELECT ',' + CAST(CustID as VARCHAR(15))
			FROM #Dep_Customer_Archived
			ORDER BY CustID
			FOR XML PATH('')
			), 1, 1, '');

	BEGIN TRY
		INSERT INTO [DBARCCUST].[Bodb_Archive_Customer_Licensee].[dbo].[Customer]
			   ([custid],[firstname],[lastname],[address],[postal],[city],[state],[country]
				,[phone],[mobilephone],[fax],[email],[birthday],[refcode1],[refcode2],[remark]
				,[creatdate],[creator],[username],[currency],[userpwd],[lastlogged],[pwdexpiry]
				,[roleid],[mrecommend],[recommend],[ugroup],[logincount],[on_sessionid],[site]
				,[iplogin],[important],[srecommend],[username2]
				)
		SELECT [custid],[firstname],[lastname],[address],[postal],[city],[state],[country]
				,[phone],[mobilephone],[fax],[email],[birthday],[refcode1],[refcode2],[remark]
				,[creatdate],[creator],[username],[currency],[userpwd],[lastlogged],[pwdexpiry]
				,[roleid],[mrecommend],[recommend],[ugroup],[logincount],[on_sessionid],[site]
				,[iplogin],[important],[srecommend],[username2]
		FROM DBCUST.CustDB.dbo.Customer WITH(NOLOCK)
		WHERE custid IN (SELECT CustID FROM #Dep_Customer_Archived)


		INSERT INTO DBARCCUST.[Bodb_Archive_Customer_Licensee].[dbo].[custInfo]
			   ([username],[custid],[currency],[roleid],[srecommend],[mrecommend]
				,[recommend],[dangercust],[autosuspend],[reject],[credit],[closed]
				,[MatchLimit],[VirtualMultiplier],[maxpermatch],[maxpermatch2]
				,[maxpermatch3],[maxpermatch5],[maxpermatch8],[maxpermatch10]
				,[maxpermatch11],[maxpermatch12],[maxpermatch99],[Enabled]
				,[danger]
				,[DisableCasino],[SyncCasino],[danger2],[danger3]
				,[DisableOutright],[MaxPerMatch99MP]
				,[DisableNumber],[maxpermatch161],[MaxPerBall161]
				,[Abnormal]
				,[DoubleCommLosing]
				,[autosuspend2]
				,[HideKeno],[HideGoldDeluxe],[DisableGoldDeluxe],[DisableSuperLive]
				,[DisableColossusBet],[HideColossusBet]
				,[LockUpd],[MaxPerMatch1MP],[BonusWalletFlag]
				,[maxpermatch164]
			   )
		SELECT [username],[custid],[currency],[roleid],[srecommend],[mrecommend]
				,[recommend],[dangercust],[autosuspend],[reject],[credit],[closed]
				,[MatchLimit],[VirtualMultiplier],0,0
				,0,0,0,0
				,0,0,0,[Enabled]
				,[danger]
				,0,0,[danger2],[danger3]
				,[DisableOutright],0
				,0,0,0
				,[Abnormal]
				,[DoubleCommLosing]
				,[autosuspend2]
				,0,0,0,[DisableSuperLive]
				,1,1
				,[LockUpd],0,[BonusWalletFlag]
				,0
		FROM DBCUST.CustDB.dbo.custInfo WITH(NOLOCK)
		WHERE custid IN (SELECT CustID FROM #Dep_Customer_Archived)
	END TRY
	BEGIN CATCH
		SELECT @Message = 'Exception error occurs while copying Customer/CustomerInfo to Archive DB: ' + ERROR_MESSAGE()

		--Roll back data
		DELETE DBARCCUST.[Bodb_Archive_Customer_Licensee].[dbo].[custInfo] WHERE custid IN (SELECT CustID FROM #Dep_Customer_Archived)
		DELETE DBARCCUST.[Bodb_Archive_Customer_Licensee].[dbo].Customer WHERE custid IN (SELECT CustID FROM #Dep_Customer_Archived)

		--Roll back for those whoes BA flags have been turned off sucessfully
		WHILE EXISTS(SELECT 1 FROM #Dep_Customer_Archived WHERE BAStastus=4)
		BEGIN
			UPDATE TOP (1) t
			SET BAStastus=1
				,@CustID=Custid
				,@LicenseeID=LicenseeID
			FROM #Dep_Customer_Archived t
			WHERE t.BAStastus=4

			EXEC DBCUST.CustDB.dbo.Lrf_CustomerUpdMemberBAStatus @LicenseeID=@LicenseeID
			,@CustID=@CustID
			,@IsAdmin=1
			,@ModifyBy=10278938 --starixit
			,@IsBA=1
			,@IP=''
			,@ErrCode=@ErrCode output,@ErrMsg=@ErrMsg output

		END

		RAISERROR(@Message, 11, 1)

		SELECT @Message = 'Exception error occurs while copying Customer/CustomerInfo to Archive DB: ' + @LogLstCustID

		EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @CustID=@LogMinCustID
				, @Action='CLEAR-BALANCE'
				, @Status='Failed'
				, @Message=@Message


		RETURN
	END CATCH

	SELECT @Message = 'Finish copying customer/CustomerInfo to Archive DB: ' + @LogLstCustID

	EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @CustID = @LogMinCustID
				, @Action='CLEAR-BALANCE'
				, @Status='OnProgress'
				, @Message=@Message


	/******************************Step 4: Transfer remaining balance******************************/
	--Log info
	SELECT @LogLstCustID = STUFF((
			SELECT ',' + CAST(CustID as VARCHAR(15))
			FROM #Dep_Customer_Archived
			ORDER BY CustID
			FOR XML PATH('')
			), 1, 1, '');

	BEGIN TRY
		IF EXISTS(SELECT 1 FROM #Dep_Customer_Archived WHERE ClosingBalance <> 0)
		BEGIN
			--Update TransBalStastus for those need to be cleared balance
			UPDATE #Dep_Customer_Archived
			SET TransBalStastus=1 --Need to be cleared balance
			WHERE ClosingBalance <> 0

			WHILE EXISTS(SELECT 1 FROM #Dep_Customer_Archived WHERE TransBalStastus=1)
			BEGIN
				UPDATE TOP (1) t
				SET TransBalStastus=2 --Clearing balance
					,@CustID=Custid
					,@ClosingBalance=ClosingBalance
					,@CustIDBalanceDummy=CustIDBalanceDummy
				FROM #Dep_Customer_Archived t
				WHERE t.TransBalStastus=1

				SELECT @ErrCode = 0

				EXEC Dot_Int_BettransInsTransactionWithoutLog_Cust 
						@custid=@CustID,
						@amount= @ClosingBalance,
						@bal_custid=@CustIDBalanceDummy,
						@Bettype = 23203,
						@transdesc = 'Clear dormant member balance in deposit archive process',
						@ErrCode= @ErrCode OUT,
						@ErrMsg= @Message OUT
				

				IF @ErrCode <> 0
				BEGIN
					SELECT @Message = 'Transfer remaining balance to dummy account is failed (' + CAST(@CustID AS VARCHAR(15)) + '): ' + @Message 

					EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @CustID = @LogMinCustID
							, @Action='CLEAR-BALANCE'
							, @Status='Failed'
							, @Message= @Message

					--Update Dep_Customer_Archived.status = failed
					EXEC DBCUST.CustDB.dbo.Acc_CustomerInfo_Execrep_10 @CustID=@CustID, @ActionID=3

					UPDATE #Dep_Customer_Archived
					SET TransBalStastus=3 --failed
					WHERE CustID=@CustID

				END
				ELSE
				BEGIN
					UPDATE #Dep_Customer_Archived
					SET TransBalStastus=4 --success
					WHERE CustID=@CustID
				END

			END

			--Roll back data for members who can not transfer closing balance
			IF EXISTS (SELECT CustID FROM #Dep_Customer_Archived WHERE TransBalStastus=3)
			BEGIN
				DELETE DBARCCUST.[Bodb_Archive_Customer_Licensee].[dbo].[custInfo] 
				WHERE CustID IN (SELECT CustID FROM #Dep_Customer_Archived WHERE TransBalStastus=3)
			
				DELETE DBARCCUST.[Bodb_Archive_Customer_Licensee].[dbo].Customer 
				WHERE CustID IN (SELECT CustID FROM #Dep_Customer_Archived WHERE TransBalStastus=3)
			END
			--Turn on BA flags for members who can not transfer closing balance, but have been turned off BA flags sucessfully
			WHILE EXISTS(SELECT 1 FROM #Dep_Customer_Archived WHERE TransBalStastus=3 AND BAStastus=4)
			BEGIN
				UPDATE TOP (1) t
				SET BAStastus=1
					,@CustID=Custid
					,@ClosingBalance=ClosingBalance
					,@CustIDBalanceDummy=CustIDBalanceDummy
				FROM #Dep_Customer_Archived t
				WHERE t.TransBalStastus=3 AND t.BAStastus=4

				EXEC DBCUST.CustDB.dbo.Lrf_CustomerUpdMemberBAStatus @LicenseeID=@LicenseeID
				,@CustID=@CustID
				,@IsAdmin=1
				,@ModifyBy=10278938 --starixit
				,@IsBA=1
				,@IP=''
				,@ErrCode=@ErrCode output,@ErrMsg=@ErrMsg output

			END

		END

	END TRY
	BEGIN CATCH
		SELECT @Message = 'Exception error occurs while transfering remaining balance: ' + ERROR_MESSAGE()

		--Roll back data
		DELETE DBARCCUST.[Bodb_Archive_Customer_Licensee].[dbo].[custInfo] WHERE custid IN (SELECT CustID FROM #Dep_Customer_Archived)
		DELETE DBARCCUST.[Bodb_Archive_Customer_Licensee].[dbo].Customer WHERE custid IN (SELECT CustID FROM #Dep_Customer_Archived)

		--Turn on BA
		WHILE EXISTS(SELECT 1 FROM #Dep_Customer_Archived WHERE BAStastus=4)
		BEGIN
			UPDATE TOP (1) t
			SET BAStastus=1
				,@CustID=Custid
				,@LicenseeID=LicenseeID
			FROM #Dep_Customer_Archived t
			WHERE t.BAStastus=4

			EXEC DBCUST.CustDB.dbo.Lrf_CustomerUpdMemberBAStatus @LicenseeID=@LicenseeID
			,@CustID=@CustID
			,@IsAdmin=1
			,@ModifyBy=10278938 --starixit
			,@IsBA=1
			,@IP=''
			,@ErrCode=@ErrCode output,@ErrMsg=@ErrMsg output

		END

		--Transfer balance back to members
		WHILE EXISTS(SELECT 1 FROM #Dep_Customer_Archived WHERE TransBalStastus=4)
		BEGIN
			UPDATE TOP (1) t
			SET TransBalStastus=1
				,@CustID=Custid
				,@ClosingBalance=-ClosingBalance
				,@CustIDBalanceDummy=CustIDBalanceDummy
			FROM #Dep_Customer_Archived t
			WHERE t.TransBalStastus=4

			EXEC Dot_Int_BettransInsTransactionWithoutLog_Cust 
						@custid=@CUSTID,
						@amount= @ClosingBalance,
						@bal_custid=@CustIDBalanceDummy,
						@Bettype = 23203,
						@transdesc = 'Clear dormant member balance in deposit archive process',
						@ErrCode= @ErrCode OUT,
						@ErrMsg= @Message OUT

		END

		RAISERROR(@Message, 11, 1)

		SELECT @Message = 'Exception error occurs while transfering remaining balance: ' + @LogLstCustID

		EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @CustID=@LogMinCustID
				, @Action='CLEAR-BALANCE'
				, @Status='Failed'
				, @Message=@Message


		RETURN

	END CATCH

	SELECT @Message = 'Finish transfering remaining balance to dummy account: ' + @LogLstCustID

	EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @CustID = @LogMinCustID
				, @Action='CLEAR-BALANCE'
				, @Status='OnProgress'
				, @Message=@Message

	--Delete members who can not transfer closing balance 
	DELETE #Dep_Customer_Archived WHERE TransBalStastus=3

	--List of members whoes are archived successfully
	SELECT @LstCustID = STUFF((
		SELECT ',' + CAST(CustID as VARCHAR(15))
		FROM #Dep_Customer_Archived
		ORDER BY CustID
		FOR XML PATH('')
		), 1, 1, '');

	--Log info
	SELECT @LogLstCustID = STUFF((
			SELECT ',' + CAST(CustID as VARCHAR(15))
			FROM #Dep_Customer_Archived
			ORDER BY CustID
			FOR XML PATH('')
			), 1, 1, '');

	/******************************Step 5: Delete Customer/CustInfo in main database******************************/
		IF ((
				SELECT COUNT(1)
				FROM DBARCCUST.[Bodb_Archive_Customer_Licensee].dbo.customer WITH (NOLOCK)
				WHERE CustID IN (SELECT CustID FROM #Dep_Customer_Archived)
			) 
			=
			(
				SELECT COUNT(1)
				FROM #Dep_Customer_Archived
			))
			AND
			((
				SELECT COUNT(1)
				FROM DBARCCUST.[Bodb_Archive_Customer_Licensee].dbo.custinfo WITH (NOLOCK)
				WHERE CustID IN (SELECT CustID FROM #Dep_Customer_Archived)
			) 
			=
			(
				SELECT COUNT(1)
				FROM #Dep_Customer_Archived
			))
		BEGIN
			BEGIN TRY
				--Delete CustInfo/Customer
				EXEC DBCUST.CustDB.dbo.Acc_CustomerInfo_Execrep_10 @LstCustID=@LstCustID, @ActionID=6

				SELECT @Message = 'Finish deleting Customer/CustInfo in main DB: ' + @LogLstCustID

				EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @CustID = @LogMinCustID
						, @Action='CLEAR-BALANCE'
						, @Status='OnProgress'
						, @Message=@Message
			END TRY
			BEGIN CATCH

				SELECT @Message = 'Exception error occurs while deleting customer/custinfo in main DB: ' + ERROR_MESSAGE()
				RAISERROR(@Message, 11, 1)

				SELECT @Message = 'Exception error occurs while deleting customer/custinfo in main DB: ' + @LogLstCustID

				EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @CustID = @LogMinCustID
							, @Action='CLEAR-BALANCE'
							, @Status='Failed'
							, @Message=@Message

				RETURN
			END CATCH
		END
		ELSE
		BEGIN
			RAISERROR('Can not delete Customer/CustInfo in main DB because there is not data in archive DB', 11, 1)

			SELECT @Message = 'Can not delete Customer/CustInfo in main DB because there is not data in archive DB: ' + @LogLstCustID

			EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @CustID = @LogMinCustID
						, @Action='CLEAR-BALANCE'
						, @Status='Failed'
						, @Message=@Message

			RETURN
		END
	

	/******************************Step 6: Delete balance tables******************************/
	BEGIN TRY
			--Delete CustInfo/Customer
			EXEC DBCUST.CustDB.dbo.Acc_CustomerInfo_Execrep_10 @LstCustID=@LstCustID, @ActionID=8

			SELECT @Message = 'Finish deleting balance tables in main DB: ' + @LogLstCustID

			EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @CustID = @LogMinCustID
					, @Action='CLEAR-BALANCE'
					, @Status='OnProgress'
					, @Message=@Message
	END TRY
	BEGIN CATCH		
			SELECT @Message = 'Exception error occurs while deleting balance tables in main DB: ' + ERROR_MESSAGE()

			RAISERROR(@Message, 11, 1)

			SELECT @Message = 'Exception error occurs while deleting balance tables in main DB: ' + @LogLstCustID

			EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @CustID = @LogMinCustID
						, @Action='CLEAR-BALANCE'
						, @Status='Failed'
						, @Message=@Message

			RETURN
	END CATCH
	
	/******************************Step 7: Update member status******************************/
	--Update Dep_Customer_Archived.status = archived
	EXEC DBCUST.CustDB.dbo.Acc_CustomerInfo_Execrep_10 @LstCustID=@LstCustID, @ActionID=1

	SELECT @Message = 'SiteDB' + CONVERT(VARCHAR(10),dbo.f_Get_SiteDBGroupID()) + ': Finish clearing balance and Custinfo: ' + @LogLstCustID

	EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @CustID = @LogMinCustID
				, @Action='CLEAR-BALANCE'
				, @Status='Done'
				, @Message=@Message

	DROP TABLE #BettingMember_AGC
	DROP TABLE #Dep_Customer_Archived
END
GO