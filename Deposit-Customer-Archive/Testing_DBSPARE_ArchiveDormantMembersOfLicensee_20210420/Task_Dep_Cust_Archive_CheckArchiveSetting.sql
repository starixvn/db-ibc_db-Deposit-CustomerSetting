/*<info serverAlias="DBSPARE-Bodb_Archive_Customer_Licensee" executers="" selecters="" viewers="" isFunction="0" isNested="0"></info>*/  
ALTER PROCEDURE [dbo].[Task_Dep_Cust_Archive_CheckArchiveSetting]
	@LstCustID VARCHAR(8000) = ''
AS
/*
	Creator : Dominic
	Date : 2018-09-17
	Task : Check if setting is coppied to ARchive DB sucessfully
	DB: DB05/Bodb_Archive_Customer_Licensee
	Revisions:
		- 20180917@Dominic: First commit
		- 20181217@Dominic: Add a new param @LstCustID to check for a list of customers - Redmine: #106242
	Parameter:
		
	
*/
BEGIN
	DECLARE @SQL VARCHAR(MAX)
	DECLARE @LstErrCustID VARCHAR(8000)
	DECLARE @LstSuccessCustID VARCHAR(8000)

	DECLARE @XML XML
	SET @XML = N'<root><r>' + REPLACE(@LstCustID, ',', '</r><r>') + '</r></root>'

	CREATE TABLE #LstCustID(CustID INT)

	CREATE TABLE #CheckCustRowCnt(
						CustID INT
						,TableID INT
						, RowCnt INT
				)

	INSERT INTO #LstCustID(CustID) 
	SELECT r.value('.','INT')
	FROM @xml.nodes('//root/r') AS RECORDS(r)

	CREATE UNIQUE CLUSTERED INDEX PK_CustID ON #LstCustID(CustID)

	--Check No. Of rows in Main DB
	SELECT @SQL = 'SELECT CustID, 1 TableID, COUNT(1) RowCnt FROM CustDB.dbo.[CustSettingGame] (NOLOCK) WHERE CustID IN (' + @LstCustID + ') GROUP BY CustID'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'UNION ALL'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'SELECT CustID, 2 TableID, COUNT(1) RowCnt FROM CustDB.dbo.[CustVirtualSetting] (NOLOCK) WHERE CustID IN (' + @LstCustID + ') GROUP BY CustID'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'UNION ALL'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'SELECT CustID, 3 TableID, COUNT(1) RowCnt FROM CustDB.dbo.[Dep_CustBetSetting_Member] (NOLOCK) WHERE CustID IN (' + @LstCustID + ') GROUP BY CustID'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'UNION ALL'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'SELECT CustID, 4 TableID, COUNT(1) RowCnt FROM CustDB.dbo.[Dep_CustCommRate] (NOLOCK) WHERE CustID IN (' + @LstCustID + ') GROUP BY CustID'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'UNION ALL'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'SELECT CustID, 5 TableID, COUNT(1) RowCnt FROM CustDB.dbo.[Dep_CustDiscountSetting_Member] (NOLOCK) WHERE CustID IN (' + @LstCustID + ') GROUP BY CustID'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'UNION ALL'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'SELECT CustID, 6 TableID, COUNT(1) RowCnt FROM CustDB.dbo.[Dep_CustProductSetting] (NOLOCK) WHERE CustID IN (' + @LstCustID + ') GROUP BY CustID'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'UNION ALL'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'SELECT CustID, 7 TableID, COUNT(1) RowCnt FROM CustDB.dbo.[Dep_CustProductStatus] (NOLOCK) WHERE CustID IN (' + @LstCustID + ') GROUP BY CustID'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'UNION ALL'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'SELECT CustID, 8 TableID, COUNT(1) RowCnt FROM CustDB.dbo.[Dep_CustPTSetting_Member] (NOLOCK) WHERE CustID IN (' + @LstCustID + ') GROUP BY CustID'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'UNION ALL'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'SELECT CustID, 9 TableID, COUNT(1) RowCnt FROM CustDB.dbo.[Dep_CustSetting] (NOLOCK) WHERE CustID IN (' + @LstCustID + ') GROUP BY CustID'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'UNION ALL'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'SELECT CustID, 10 TableID, COUNT(1) RowCnt FROM CustDB.dbo.[Dep_CustSetting_AGCasino] (NOLOCK) WHERE CustID IN (' + @LstCustID + ') GROUP BY CustID'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'UNION ALL'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'SELECT CustID, 11 TableID, COUNT(1) RowCnt FROM CustDB.dbo.[Dep_CustSetting3rd] (NOLOCK) WHERE CustID IN (' + @LstCustID + ') GROUP BY CustID'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'UNION ALL'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'SELECT CustID, 12 TableID, COUNT(1) RowCnt FROM CustDB.dbo.[Dep_CustSettingGame] (NOLOCK) WHERE CustID IN (' + @LstCustID + ') GROUP BY CustID'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'UNION ALL'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'SELECT CustID, 13 TableID, COUNT(1) RowCnt FROM CustDB.dbo.[Dep_CustSettingMode] (NOLOCK) WHERE CustID IN (' + @LstCustID + ') GROUP BY CustID'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'UNION ALL'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'SELECT CustID, 14 TableID, COUNT(1) RowCnt FROM CustDB.dbo.[Dep_CustSpecialLevel] (NOLOCK) WHERE CustID IN (' + @LstCustID + ') GROUP BY CustID'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'UNION ALL'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'SELECT CustID, 15 TableID, COUNT(1) RowCnt FROM CustDB.dbo.[Dep_CustStakeLevel_Member] (NOLOCK) WHERE CustID IN (' + @LstCustID + ') GROUP BY CustID'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'UNION ALL'
	SELECT @SQL = @SQL + CHAR(13)+CHAR(10) + 'SELECT CustID, 16 TableID, COUNT(1) RowCnt FROM CustDB.dbo.[CustGameType] (NOLOCK) WHERE CustID IN (' + @LstCustID + ') GROUP BY CustID'

	INSERT INTO #CheckCustRowCnt(CustID,TableID,RowCnt)
	EXEC (@SQL) AT DBNOTI

	--Check No. Of rows in Archive DB
	INSERT INTO #CheckCustRowCnt(CustID,TableID,RowCnt)
	SELECT CustID,TableID,RowCnt
	FROM (
		SELECT CustID, 1 TableID, COUNT(1) RowCnt FROM [CustSettingGame] (NOLOCK) WHERE CustID IN (SELECT CustID FROM #LstCustID) GROUP BY CustID
		UNION ALL
		SELECT CustID, 2 TableID, COUNT(1) RowCnt FROM [CustVirtualSetting] (NOLOCK) WHERE CustID IN (SELECT CustID FROM #LstCustID) GROUP BY CustID
		UNION ALL
		SELECT CustID, 3 TableID, COUNT(1) RowCnt FROM [Dep_CustBetSetting_Member] (NOLOCK) WHERE CustID IN (SELECT CustID FROM #LstCustID) GROUP BY CustID
		UNION ALL
		SELECT CustID, 4 TableID, COUNT(1) RowCnt FROM [Dep_CustCommRate] (NOLOCK) WHERE CustID IN (SELECT CustID FROM #LstCustID) GROUP BY CustID
		UNION ALL
		SELECT CustID, 5 TableID, COUNT(1) RowCnt FROM [Dep_CustDiscountSetting_Member] (NOLOCK) WHERE CustID IN (SELECT CustID FROM #LstCustID) GROUP BY CustID
		UNION ALL
		SELECT CustID, 6 TableID, COUNT(1) RowCnt FROM [Dep_CustProductSetting] (NOLOCK) WHERE CustID IN (SELECT CustID FROM #LstCustID) GROUP BY CustID
		UNION ALL
		SELECT CustID, 7 TableID, COUNT(1) RowCnt FROM [Dep_CustProductStatus] (NOLOCK) WHERE CustID IN (SELECT CustID FROM #LstCustID) GROUP BY CustID
		UNION ALL
		SELECT CustID, 8 TableID, COUNT(1) RowCnt FROM [Dep_CustPTSetting_Member] (NOLOCK) WHERE CustID IN (SELECT CustID FROM #LstCustID) GROUP BY CustID
		UNION ALL
		SELECT CustID, 9 TableID, COUNT(1) RowCnt FROM [Dep_CustSetting] (NOLOCK) WHERE CustID IN (SELECT CustID FROM #LstCustID) GROUP BY CustID
		UNION ALL
		SELECT CustID, 10 TableID, COUNT(1) RowCnt FROM [Dep_CustSetting_AGCasino] (NOLOCK) WHERE CustID IN (SELECT CustID FROM #LstCustID) GROUP BY CustID
		UNION ALL
		SELECT CustID, 11 TableID, COUNT(1) RowCnt FROM [Dep_CustSetting3rd] (NOLOCK) WHERE CustID IN (SELECT CustID FROM #LstCustID) GROUP BY CustID
		UNION ALL
		SELECT CustID, 12 TableID, COUNT(1) RowCnt FROM [Dep_CustSettingGame] (NOLOCK) WHERE CustID IN (SELECT CustID FROM #LstCustID) GROUP BY CustID
		UNION ALL
		SELECT CustID, 13 TableID, COUNT(1) RowCnt FROM [Dep_CustSettingMode] (NOLOCK) WHERE CustID IN (SELECT CustID FROM #LstCustID) GROUP BY CustID
		UNION ALL
		SELECT CustID, 14 TableID, COUNT(1) RowCnt FROM [Dep_CustSpecialLevel] (NOLOCK) WHERE CustID IN (SELECT CustID FROM #LstCustID) GROUP BY CustID
		UNION ALL
		SELECT CustID, 15 TableID, COUNT(1) RowCnt FROM [Dep_CustStakeLevel_Member] (NOLOCK) WHERE CustID IN (SELECT CustID FROM #LstCustID) GROUP BY CustID
		UNION ALL
		SELECT CustID, 16 TableID, COUNT(1) RowCnt FROM [CustGameType] (NOLOCK) WHERE CustID IN (SELECT CustID FROM #LstCustID) GROUP BY CustID
	) tmp

	CREATE CLUSTERED INDEX IX_CustID ON #CheckCustRowCnt(CustID,TableID)

	SELECT @LstErrCustID = STUFF((
	SELECT ',' + CAST(CusTID as VARCHAR(15))
	FROM (
		SELECT DISTINCT CustID
		FROM #CheckCustRowCnt
		GROUP BY CustID,TableID
		HAVING COUNT(RowCnt) < 2 OR MIN(RowCnt) <> MAX(RowCnt)	
	) tmp
	ORDER BY CustID
	FOR XML PATH('')
	), 1, 1, '');

	SELECT @LstSuccessCustID = STUFF((
	SELECT ',' + CAST(CusTID as VARCHAR(15))
	FROM (
		SELECT DISTINCT CustID
		FROM #CheckCustRowCnt
		GROUP BY CustID,TableID
		HAVING COUNT(RowCnt) = 2 AND MIN(RowCnt) = MAX(RowCnt)
	) tmp
	ORDER BY CustID
	FOR XML PATH('')
	), 1, 1, '');
	
	
	SELECT ISNULL(@LstErrCustID,'') LstErrCustID, ISNULL(@LstSuccessCustID,'') LstSuccessCustID
END

