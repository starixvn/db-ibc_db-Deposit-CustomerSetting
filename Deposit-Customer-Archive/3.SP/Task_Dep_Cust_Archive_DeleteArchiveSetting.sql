/*<info serverAlias="DBARCCUST-Bodb_Archive_Customer_Licensee" executers="" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE Task_Dep_Cust_Archive_DeleteArchiveSetting
	@LstCustID VARCHAR(8000) = ''
AS
/*
	Creator : Dominic
	Date : 2018-09-17
	Task : Delete existing setting in Bodb_Archive_Customer_Licensee
	DB: DB05/Bodb_Archive_Customer_Licensee
	Revisions:
		- 20180917@Dominic: First commit
		- 20181217@Dominic: Add a new param @LstCustID to check for a list of customers - Redmine: #106242
	Parameter:
		
	
*/
BEGIN
	DECLARE @SQL VARCHAR(MAX)

	CREATE TABLE #CheckCustMainExist(
			CustID INT
			,TableID INT
			)

	--Check existing setting in main DB
	SELECT @SQL = 'SELECT CustID, 1 TableID FROM CustDB.dbo.[CustSettingGame] (NOLOCK) WHERE CustID IN (' + @LstCustID + ') GROUP BY CustID'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'UNION ALL'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'SELECT CustID, 2 TableID FROM CustDB.dbo.[CustVirtualSetting] (NOLOCK) WHERE CustID IN (' + @LstCustID + ') GROUP BY CustID'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'UNION ALL'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'SELECT CustID, 3 TableID FROM CustDB.dbo.[Dep_CustBetSetting_Member] (NOLOCK) WHERE CustID IN (' + @LstCustID + ') GROUP BY CustID'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'UNION ALL'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'SELECT CustID, 4 TableID FROM CustDB.dbo.[Dep_CustCommRate] (NOLOCK) WHERE CustID IN (' + @LstCustID + ') GROUP BY CustID'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'UNION ALL'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'SELECT CustID, 5 TableID FROM CustDB.dbo.[Dep_CustDiscountSetting_Member] (NOLOCK) WHERE CustID IN (' + @LstCustID + ') GROUP BY CustID'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'UNION ALL'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'SELECT CustID, 6 TableID FROM CustDB.dbo.[Dep_CustProductSetting] (NOLOCK) WHERE CustID IN (' + @LstCustID + ') GROUP BY CustID'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'UNION ALL'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'SELECT CustID, 7 TableID FROM CustDB.dbo.[Dep_CustProductStatus] (NOLOCK) WHERE CustID IN (' + @LstCustID + ') GROUP BY CustID'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'UNION ALL'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'SELECT CustID, 8 TableID FROM CustDB.dbo.[Dep_CustPTSetting_Member] (NOLOCK) WHERE CustID IN (' + @LstCustID + ') GROUP BY CustID'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'UNION ALL'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'SELECT CustID, 9 TableID FROM CustDB.dbo.[Dep_CustSetting] (NOLOCK) WHERE CustID IN (' + @LstCustID + ') GROUP BY CustID'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'UNION ALL'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'SELECT CustID, 10 TableID FROM CustDB.dbo.[Dep_CustSetting_AGCasino] (NOLOCK) WHERE CustID IN (' + @LstCustID + ') GROUP BY CustID'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'UNION ALL'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'SELECT CustID, 11 TableID FROM CustDB.dbo.[Dep_CustSetting3rd] (NOLOCK) WHERE CustID IN (' + @LstCustID + ') GROUP BY CustID'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'UNION ALL'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'SELECT CustID, 12 TableID FROM CustDB.dbo.[Dep_CustSettingGame] (NOLOCK) WHERE CustID IN (' + @LstCustID + ') GROUP BY CustID'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'UNION ALL'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'SELECT CustID, 13 TableID FROM CustDB.dbo.[Dep_CustSettingMode] (NOLOCK) WHERE CustID IN (' + @LstCustID + ') GROUP BY CustID'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'UNION ALL'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'SELECT CustID, 14 TableID FROM CustDB.dbo.[Dep_CustSpecialLevel] (NOLOCK) WHERE CustID IN (' + @LstCustID + ') GROUP BY CustID'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'UNION ALL'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'SELECT CustID, 15 TableID FROM CustDB.dbo.[Dep_CustStakeLevel_Member] (NOLOCK) WHERE CustID IN (' + @LstCustID + ') GROUP BY CustID'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'UNION ALL'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'SELECT CustID, 16 TableID FROM CustDB.dbo.[CustGameType] (NOLOCK) WHERE CustID IN (' + @LstCustID + ') GROUP BY CustID'

	INSERT INTO #CheckCustMainExist(CustID,TableID)
	EXEC (@SQL) AT DBCUST

	CREATE UNIQUE CLUSTERED INDEX IX_TableID ON #CheckCustMainExist(TableID,CustID)

	--Delete existing settings in Archive DB if there are existing settings in Main DB
	DELETE [CustSettingGame]
	WHERE CustID IN (SELECT CustID FROM #CheckCustMainExist WHERE TableID = 1)
	
	DELETE CustVirtualSetting
	WHERE CustID IN (SELECT CustID FROM #CheckCustMainExist WHERE TableID = 2)
	
	DELETE Dep_CustBetSetting_Member
	WHERE CustID IN (SELECT CustID FROM #CheckCustMainExist WHERE TableID = 3)
	
	DELETE Dep_CustCommRate
	WHERE CustID IN (SELECT CustID FROM #CheckCustMainExist WHERE TableID = 4)
	
	DELETE Dep_CustDiscountSetting_Member
	WHERE CustID IN (SELECT CustID FROM #CheckCustMainExist WHERE TableID = 5)
	
	DELETE Dep_CustProductSetting
	WHERE CustID IN (SELECT CustID FROM #CheckCustMainExist WHERE TableID = 6)
	
	DELETE Dep_CustProductStatus
	WHERE CustID IN (SELECT CustID FROM #CheckCustMainExist WHERE TableID = 7)
	
	DELETE Dep_CustPTSetting_Member
	WHERE CustID IN (SELECT CustID FROM #CheckCustMainExist WHERE TableID = 8)
	
	DELETE Dep_CustSetting
	WHERE CustID IN (SELECT CustID FROM #CheckCustMainExist WHERE TableID = 9)
	
	DELETE Dep_CustSetting_AGCasino
	WHERE CustID IN (SELECT CustID FROM #CheckCustMainExist WHERE TableID = 10)
	
	DELETE Dep_CustSetting3rd
	WHERE CustID IN (SELECT CustID FROM #CheckCustMainExist WHERE TableID = 11)
	
	DELETE Dep_CustSettingGame
	WHERE CustID IN (SELECT CustID FROM #CheckCustMainExist WHERE TableID = 12)
	
	DELETE Dep_CustSettingMode
	WHERE CustID IN (SELECT CustID FROM #CheckCustMainExist WHERE TableID = 13)
	
	DELETE Dep_CustSpecialLevel
	WHERE CustID IN (SELECT CustID FROM #CheckCustMainExist WHERE TableID = 14)
	
	DELETE Dep_CustStakeLevel_Member
	WHERE CustID IN (SELECT CustID FROM #CheckCustMainExist WHERE TableID = 15)
	
	DELETE CustGameType
	WHERE CustID IN (SELECT CustID FROM #CheckCustMainExist WHERE TableID = 16)

END