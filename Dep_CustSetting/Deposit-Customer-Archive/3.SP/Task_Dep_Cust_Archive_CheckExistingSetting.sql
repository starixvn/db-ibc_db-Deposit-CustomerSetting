/*<info serverAlias="DBARCCUST-Bodb_Archive_Customer_Licensee" executers="" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE Task_Dep_Cust_Archive_CheckExistingSetting
	@LstCustID VARCHAR(8000) = ''
AS
/*
	Creator : Dominic
	Date : 2018-09-17
	Task : Check existing data in archive DB and in main DB
	DB: DB05/Bodb_Archive_Customer_Licensee
	Revisions:
		- 20180917@Dominic: First commit
		- 20181212@Dominic: Add a new param @LstCustID to check for a list of customers - Redmine: #106242
	Parameter:
		
	
*/
BEGIN
	DECLARE @LstArchiveExist VARCHAR(8000)

	DECLARE @XML XML
	SET @XML = N'<root><r>' + REPLACE(@LstCustID, ',', '</r><r>') + '</r></root>'

	CREATE TABLE #LstCustID(CustID INT,IsArchiveExisting BIT,IsMainExisting BIT)

	INSERT INTO #LstCustID(CustID,IsArchiveExisting,IsMainExisting) 
	SELECT r.value('.','INT'),0,0
	FROM @xml.nodes('//root/r') AS RECORDS(r)

	CREATE UNIQUE CLUSTERED INDEX PK_CustID ON #LstCustID(CustID)


	UPDATE t
	SET t.IsArchiveExisting=1
	FROM #LstCustID t
	WHERE EXISTS (SELECT 1 FROM Bodb_Archive_Customer_Licensee.[dbo].[CustSettingGame] (NOLOCK) WHERE CustID=t.CustID)
		OR EXISTS (SELECT 1 FROM Bodb_Archive_Customer_Licensee.[dbo].[CustVirtualSetting] (NOLOCK) WHERE CustID=t.CustID)
		OR EXISTS (SELECT 1 FROM Bodb_Archive_Customer_Licensee.[dbo].[Dep_CustBetSetting_Member] (NOLOCK) WHERE CustID=t.CustID)
		OR EXISTS (SELECT 1 FROM Bodb_Archive_Customer_Licensee.[dbo].[Dep_CustCommRate] (NOLOCK) WHERE CustID=t.CustID)
		OR EXISTS (SELECT 1 FROM Bodb_Archive_Customer_Licensee.[dbo].[Dep_CustDiscountSetting_Member] (NOLOCK) WHERE CustID=t.CustID)
		OR EXISTS (SELECT 1 FROM Bodb_Archive_Customer_Licensee.[dbo].[Dep_CustProductSetting] (NOLOCK) WHERE CustID=t.CustID)
		OR EXISTS (SELECT 1 FROM Bodb_Archive_Customer_Licensee.[dbo].[Dep_CustProductStatus] (NOLOCK) WHERE CustID=t.CustID)
		OR EXISTS (SELECT 1 FROM Bodb_Archive_Customer_Licensee.[dbo].[Dep_CustPTSetting_Member] (NOLOCK) WHERE CustID=t.CustID)
		OR EXISTS (SELECT 1 FROM Bodb_Archive_Customer_Licensee.[dbo].[Dep_CustSetting] (NOLOCK) WHERE CustID=t.CustID)
		OR EXISTS (SELECT 1 FROM Bodb_Archive_Customer_Licensee.[dbo].[Dep_CustSetting_AGCasino] (NOLOCK) WHERE CustID=t.CustID)
		OR EXISTS (SELECT 1 FROM Bodb_Archive_Customer_Licensee.[dbo].[Dep_CustSetting3rd] (NOLOCK) WHERE CustID=t.CustID)
		OR EXISTS (SELECT 1 FROM Bodb_Archive_Customer_Licensee.[dbo].[Dep_CustSettingGame] (NOLOCK) WHERE CustID=t.CustID)
		OR EXISTS (SELECT 1 FROM Bodb_Archive_Customer_Licensee.[dbo].[Dep_CustSettingMode] (NOLOCK) WHERE CustID=t.CustID)
		OR EXISTS (SELECT 1 FROM Bodb_Archive_Customer_Licensee.[dbo].[Dep_CustSpecialLevel] (NOLOCK) WHERE CustID=t.CustID)
		OR EXISTS (SELECT 1 FROM Bodb_Archive_Customer_Licensee.[dbo].[Dep_CustStakeLevel_Member] (NOLOCK) WHERE CustID=t.CustID)
		OR EXISTS (SELECT 1 FROM Bodb_Archive_Customer_Licensee.[dbo].CustGameType (NOLOCK) WHERE CustID=t.CustID)
	
	
	SELECT @LstArchiveExist = STUFF((
	SELECT ',' + CAST(CustID as VARCHAR(15))
	FROM #LstCustID
	WHERE IsArchiveExisting = 1
	ORDER BY CustID
	FOR XML PATH('')
	), 1, 1, '');


	SELECT ISNULL(@LstArchiveExist,'') LstArchiveExist
END