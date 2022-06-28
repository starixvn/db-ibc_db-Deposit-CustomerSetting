/*<info serverAlias="DBCUST-CustDB" executers="bodbadminNet" viewers="" isFunction="0" isNested="1"></info>*/
 /*
	Created: 20220517@Tacy
	Task : Insert history of member bet setting for Deposit
	DB: DBCust/CustDB
	Original:

	Revisions:
		- 20220517@Tacy: Initial SP [RedmineID: #170739]

	Param's Explanation:
	• @CustList:
		<root>
			<r CustID= ''1400001''  SportType=''175'' BetType=''7901'' MaxBet=''600''  MaxPerMatch=''1800'' StakeLevelList=''NULL''  UpdateTime=''2022-03-10 04:10:10.000''/>
			<r CustID= ''23700002'' SportType=''200'' BetType=''1611'' MaxBet=''NULL'' MaxPerMatch=''NULL'' StakeLevelList=''1191'' UpdateTime=''2022-03-10 04:10:10.000''/>
		</root>
 */
 
 ALTER PROCEDURE [dbo].[Acc_Dep_DynamicCustSetting_07]
		@CustList	VARCHAR(MAX) = NULL,
		@ErrMsg		NVARCHAR(200)= ''	OUTPUT

AS
BEGIN
	IF @@SERVERNAME NOT IN ('DBCUST','SITDBCUST','DB233','DB230\SQLSERVER2008R2','TESTDBCUST')
	BEGIN
		SET @ErrMsg='Server name is invailid.'
		RETURN
	END

	SET NOCOUNT ON
	DECLARE @xml XML = NULL

	CREATE TABLE #tmpCustList (
			CustID			INT
		,	SportType		SMALLINT
		,	BetType			INT
		,	MaxBet			MONEY
		,	MaxPerMatch		MONEY
		,	StakeLevelList	VARCHAR(200)
		,	UpdateTime		DATETIME
		,	PRIMARY KEY CLUSTERED (CustID, SportType, BetType, UpdateTime)
	)

	--Check if XML is null or empty
	IF @CustList IS NULL OR @CustList=''
	BEGIN
		SET @ErrMsg='Customer list is invalid.'
		RETURN
	END

	SET @xml = CONVERT(XML, @CustList)

	--Parse XML	
	DECLARE @iDoc INT

	EXEC sp_xml_preparedocument @iDoc OUTPUT
		, @xml

	INSERT INTO #tmpCustList(CustID, SportType, BetType, MaxBet, MaxPerMatch, StakeLevelList, UpdateTime)
	SELECT CustID, SportType, BetType
		, CASE WHEN ISNUMERIC(MaxBet)=1			THEN MaxBet ELSE NULL END MaxBet
		, CASE WHEN ISNUMERIC(MaxPerMatch)=1	THEN MaxPerMatch ELSE NULL END MaxPerMatch
		, CASE WHEN StakeLevelList<>'NULL'		THEN StakeLevelList ELSE NULL END StakeLevelList
		, UpdateTime
	FROM OPENXML(@iDoc, '/root/r', 1) WITH (
			CustID			INT
		,	SportType		SMALLINT
		,	BetType			INT
		,	MaxBet			VARCHAR(100)
		,	MaxPerMatch		VARCHAR(100)
		,	StakeLevelList	VARCHAR(200)
		,	UpdateTime		DATETIME
		)
	
	EXEC sp_xml_removedocument @iDoc

	--get MaxBet - StakeLevelList
	IF EXISTS (SELECT 1 FROM #tmpCustList WHERE StakeLevelList IS NOT NULL)
	BEGIN
		WITH csll AS (
			SELECT tc.CustID, SportType, BetType, tc.StakeLevelList
				, MAX(CAST(st.MaxLabel AS MONEY)) MaxStake
			FROM #tmpCustList tc 
				CROSS APPLY (SELECT TRIM(value) AS val FROM STRING_SPLIT(tc.StakeLevelList,',')) ss
				INNER JOIN Dep_StakeLevel st WITH (NOLOCK) ON st.StakeLevelID = CAST(ss.val AS INT)
			WHERE tc.StakeLevelList IS NOT NULL
			GROUP BY tc.CustID, SportType, BetType, tc.StakeLevelList
		)
		UPDATE tc
		SET tc.MaxBet = t1.MaxStake
		FROM #tmpCustList tc
			INNER JOIN csll t1 ON t1.CustID	 = tc.CustID
							AND t1.BetType	 = tc.BetType
							AND t1.SportType = tc.SportType
	END

	INSERT INTO Dep_CustMaxBetSetting_History 
		  (CustID, SportType, BetType, OldMaxBet, OldMaxPerMatch, OldStakeLevelList, UpdateTime)
	SELECT CustID, SportType, BetType, MaxBet, MaxPerMatch, StakeLevelList, UpdateTime
	FROM #tmpCustList

	--ROLLBACK
	IF @@ERROR<>0
	BEGIN
		SET @ErrMsg='Insert history of member bet setting failed.'

		DELETE cbsh
		FROM Dep_CustMaxBetSetting_History cbsh WITH (ROWLOCK)
			INNER JOIN #tmpCustList t 
				ON t.CustID	= cbsh.CustID
				AND t.SportType	= cbsh.SportType
				AND t.BetType	= cbsh.BetType
				AND t.UpdateTime= cbsh.UpdateTime
		RETURN
	END

	DROP TABLE #tmpCustList
END
GO
