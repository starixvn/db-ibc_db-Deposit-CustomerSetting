/*<info serverAlias="DBARCCUST-Bodb_Archive_Customer_Licensee" executers="" viewers="" isFunction="0"></info>*/
CREATE PROCEDURE Task_Dep_Cust_Archive_CleanReactivatedData
	@BatchSize INT = 100
AS
/*
	Creator : Dominic
	Date : 2019-01-07
	Task : Delete data in Archive DB for reactivated members - #99882
	DB: DB05/Bodb_Archive_Customer_Licensee
	Revisions:
		- 20190107@Dominic: First commit

	Parameter:
		
	
*/
BEGIN
	DECLARE @ErrCode INT, @Message VARCHAR(MAX)
	DECLARE @LstCustID VARCHAR(MAX),@LogMinCustID INT	

	CREATE TABLE #Dep_Customer_Archived(
		[CustID] INT
		, [ArchivedDate] DATETIME
	)

	INSERT INTO #Dep_Customer_Archived(CustID, ArchivedDate)
	SELECT TOP (@BatchSize) CustID, ArchivedDate
	FROM DBCUST.CustDB.dbo.Dep_Customer_Archived WITH(NOLOCK)
	WHERE Status = 'reactivation'
	ORDER BY ArchivedDate, CustID

	IF NOT EXISTS (SELECT 1 FROM #Dep_Customer_Archived)
	BEGIN
		EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive 
				@Action='CLEAN-ARCHIVEDB'
				, @Status='Done'
				, @Message='There are not any reactivated members in the list'

		RETURN
	END
	
	CREATE UNIQUE CLUSTERED INDEX IX_CustID ON #Dep_Customer_Archived([CustID])

	SELECT @LstCustID = STUFF((
		SELECT ',' + CAST(CustID as VARCHAR(15))
		FROM #Dep_Customer_Archived
		ORDER BY CustID
		FOR XML PATH('')
		), 1, 1, '');

	SELECT @Message='Start deleting archive data for reactivated members: ' + @LstCustID

	EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @CustID=@LogMinCustID
			, @Action='CLEAN-ARCHIVEDB'
			, @Status='OnProgress'
			, @Message=@Message

	--Prepare log infomation
	SELECT @LogMinCustID = MIN(CustID)
	FROM #Dep_Customer_Archived
	
	SELECT CustID 
	INTO #MainDBExistCust
	FROM DBCUST.CustDB.dbo.Customer WITH (NOLOCK)
	WHERE CustID IN (SELECT CustID FROM #Dep_Customer_Archived)

	IF(EXISTS(SELECT 1 FROM #Dep_Customer_Archived WHERE CustID NOT IN (SELECT CUstID FROM #MainDBExistCust)))
	BEGIN
		SELECT @Message='There are reactivated members who do not have data in Main DB: ' + @LstCustID

		EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @CustID=@LogMinCustID
				, @Action='CLEAN-ARCHIVEDB'
				, @Status='Failed'
				, @Message=@Message

		RAISERROR('There are reactivated members who do not have data in Main DB', 11, 1);
		
		RETURN
	END

	--Delete Custinfo
	DELETE Customer WHERE CustID IN (SELECT CustID FROM #Dep_Customer_Archived)
	DELETE custInfo WHERE CustID IN (SELECT CustID FROM #Dep_Customer_Archived) 

	--Delete customer setting tables
	DELETE [CustSettingGame] WHERE CustID IN (SELECT CustID FROM #Dep_Customer_Archived)
	DELETE [CustVirtualSetting] WHERE CustID IN (SELECT CustID FROM #Dep_Customer_Archived) 
	DELETE [Dep_CustBetSetting_Member] WHERE CustID IN (SELECT CustID FROM #Dep_Customer_Archived) 
	DELETE [Dep_CustCommRate] WHERE CustID IN (SELECT CustID FROM #Dep_Customer_Archived) 
	DELETE [Dep_CustDiscountSetting_Member] WHERE CustID IN (SELECT CustID FROM #Dep_Customer_Archived) 
	DELETE [Dep_CustProductSetting] WHERE CustID IN (SELECT CustID FROM #Dep_Customer_Archived) 
	DELETE [Dep_CustProductStatus] WHERE CustID IN (SELECT CustID FROM #Dep_Customer_Archived) 
	DELETE [Dep_CustPTSetting_Member] WHERE CustID IN (SELECT CustID FROM #Dep_Customer_Archived) 
	DELETE [Dep_CustSetting] WHERE CustID IN (SELECT CustID FROM #Dep_Customer_Archived) 
	DELETE [Dep_CustSetting_AGCasino] WHERE CustID IN (SELECT CustID FROM #Dep_Customer_Archived) 
	DELETE [Dep_CustSetting3rd] WHERE CustID IN (SELECT CustID FROM #Dep_Customer_Archived) 
	DELETE [Dep_CustSettingGame] WHERE CustID IN (SELECT CustID FROM #Dep_Customer_Archived) 
	DELETE [Dep_CustSettingMode] WHERE CustID IN (SELECT CustID FROM #Dep_Customer_Archived) 
	DELETE [Dep_CustSpecialLevel] WHERE CustID IN (SELECT CustID FROM #Dep_Customer_Archived) 
	DELETE [Dep_CustStakeLevel_Member] WHERE CustID IN (SELECT CustID FROM #Dep_Customer_Archived) 
	DELETE [CustGameType] WHERE CustID IN (SELECT CustID FROM #Dep_Customer_Archived) 
	
	--Delete data in Dep_Customer_Archived
	EXEC DBCUST.CustDB.dbo.Acc_CustomerInfo_Execrep_10 @LstCustID=@LstCustID, @ActionID=5 

	SELECT @Message = 'Finish deleting archive data for reactivated members: ' + @LstCustID

	EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive @CustID = @LogMinCustID
				, @Action='CLEAN-ARCHIVEDB'
				, @Status='Done'
				, @Message=@Message

	DROP TABLE #Dep_Customer_Archived
	DROP TABLE #MainDBExistCust
	
END

