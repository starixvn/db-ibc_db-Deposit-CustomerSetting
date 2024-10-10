/*<info serverAlias="DBCUST-CUSTDB" executers="wsv_nap,wsv_lap" viewers="" isFunction="0" isNested="1"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_DynamicCustSetting_05]
		@StakeLevel	VARCHAR(MAX)
	,   @ActionID	TINYINT =1
AS
/*
	Created: 20171114@Winnie
	Task : Update Customer's Stake Level Settings - [Redmine: #85133]
	DB: DBCUST/CustDB
	Original:

	Revisions:
		- 20171114@Winnie: Update Customer's Stake Level Settings - [Redmine: #85133]
		- 20180824@Winnie: Licensee DCS setting - Support insert/edit setting for sub_licensee RedmineID:#88700
		- 20220511@Eden: Arcadia Gaming - Fix duplicated data [RedmineID:#172588]
		- 20220517@Tacy: Insert history of member bet setting [RedmineID: 170739]
		- 20240709@Johnson: Apply In-house Replication for Customer Setting [redmine:#207025]
		- 20240925@Johnson: Add DBKLC1 [redmine: #207025]
		- 20241010@Johnson: remove DBKLC1 [redmine: #207025]
	Param's Explanation:
	@Action=1: Update and insert
	@Action=0: Insert new
		@StakeLevel:
		<ROOT>
				<StakeLevel 						
						SportType="212" 
						BetType="2401" 
						StakeLevelList="1,2,3,4,5"
				/>
		</ROOT>
*/
BEGIN
	IF @@SERVERNAME NOT IN ('DBCUST','DBSPARE','SITDBCUST','TESTDBCUST','DB-60\DEVDBCUST')
		RETURN;
		
	SET NOCOUNT ON;

	DECLARE @CustList VARCHAR(MAX),
			@ErrMsg NVARCHAR(MAX)

	IF @StakeLevel IS NULL OR @StakeLevel=''
		RETURN;

	DECLARE	@iDoc			INT;


	CREATE TABLE #StakeLevel (		
			CustID	INT
		,	RoleID  TINYINT 
		,	SportType			SMALLINT
		,	BetType				SMALLINT
		,	StakeLevelList		VARCHAR(200)
		,	MemberStakeLevel	VARCHAR(200)
		,	PRIMARY KEY (CustID,SportType,BetType)
	);

	CREATE TABLE #History_StakeLevel (		
			CustID	INT
		,	SportType			SMALLINT
		,	BetType				SMALLINT
		,	StakeLevelList		VARCHAR(200)
		,	UpdateTime			DATETIME
	);

	-- Read XML
	EXECUTE sys.sp_xml_preparedocument @iDoc OUTPUT, @StakeLevel;

	INSERT INTO	#StakeLevel
		( CustID,RoleID,	SportType  , BetType   , StakeLevelList,MemberStakeLevel)
	SELECT	ox.CustID, ox.RoleID, ox.SportType, ox.BetType, ox.StakeLevelList,ox.MemberStakeLevel
	FROM	OPENXML(@iDoc, '/ROOT/StakeLevel', 1)
			WITH (		
				CustID				INT
			,	RoleID				TINYINT		
			,	SportType			SMALLINT
			,	BetType				SMALLINT
			,	StakeLevelList		VARCHAR(200)
			,	MemberStakeLevel	VARCHAR(200)
			) AS ox;

	EXECUTE sys.sp_xml_removedocument @iDoc;	

	IF (@ActionID=1)
	BEGIN
		UPDATE cslm
		SET cslm.LastUpdated=GETDATE(),cslm.StakeLevelList=tv.MemberStakeLevel,
			RepUpdateTime = dbo.f_GetDateTime2()
		OUTPUT deleted.CustID, deleted.SportType, deleted.BetType, deleted.StakeLevelList, inserted.LastUpdated
			INTO #History_StakeLevel
		FROM	dbo.Dep_CustStakeLevel_Member AS cslm WITH(ROWLOCK,UPDLOCK)
			INNER JOIN #StakeLevel AS tv ON cslm.Custid=tv.CustID AND cslm.SportType=tv.SportType AND cslm.BetType=tv.BetType
		WHERE tv.RoleID =1

		--delete
		DELETE his
		FROM #History_StakeLevel his
			INNER JOIN #StakeLevel AS tv ON his.Custid=tv.CustID
		WHERE his.StakeLevelList=TV.StakeLevelList

		UPDATE csla
		SET	csla.StakeLevelList = sl.StakeLevelList,
			RepUpdateTime = dbo.f_GetDateTime2()
		FROM	dbo.Dep_CustStakeLevel_Agent AS csla WITH(ROWLOCK,UPDLOCK)
			INNER JOIN	#StakeLevel AS sl	ON	csla.CustID=sl.CustID	AND sl.SportType = csla.SportType	AND	sl.BetType = csla.BetType
		WHERE sl.RoleID IN(2,3,4)

		DELETE t
		FROM #StakeLevel t 
			INNER JOIN Dep_CustStakeLevel_Agent a WITH(NOLOCK) ON t.CustID=a.CustID AND t.SportType=a.SportType AND t.BetType=a.BetType

		DELETE t
		FROM #StakeLevel t 
			INNER JOIN Dep_CustStakeLevel_Member a WITH(NOLOCK) ON t.CustID=a.CustID AND t.SportType=a.SportType AND t.BetType=a.BetType

		INSERT INTO dbo.Dep_CustStakeLevel_Member(CustID,SportType,BetType,StakeLevelList,LastUpdated,RepUpdateTime)
		SELECT CustID,SportType,BetType,tv.MemberStakeLevel,GETDATE(),dbo.f_GetDateTime2()	
		FROM #StakeLevel tv	
		WHERE tv.RoleID =1
	
		INSERT INTO dbo.Dep_CustStakeLevel_Agent(CustID,SportType,BetType,StakeLevelList,RepUpdateTime)
		SELECT CustID,SportType,BetType,StakeLevelList,dbo.f_GetDateTime2()
		FROM #StakeLevel
		WHERE RoleID IN(2,3,4)
		
		
		--Insert history bet setting
		IF EXISTS (SELECT 1 FROM #History_StakeLevel)
		BEGIN
			SET @CustList = (SELECT CustID			AS '@CustID',
									SportType		AS '@SportType',
									BetType			AS '@BetType',
									'NULL'			AS '@MaxBet',
									'NULL'			AS '@MaxPerMatch',
									StakeLevelList	AS '@StakeLevelList',
									UpdateTime		AS '@UpdateTime'
							 FROM #History_StakeLevel
							 FOR XML PATH ('r'), ROOT ('root')
							)

			EXECUTE Acc_Dep_DynamicCustSetting_07  @CustList=@CustList, @ErrMsg=@ErrMsg OUTPUT

			IF @ErrMsg<>''
				RETURN
		END
	END
	ELSE
	BEGIN
		--Delete redudant data before insert
		DELETE a
		OUTPUT DELETED.[CustID],DELETED.[Sporttype],DELETED.[Bettype],dbo.f_GetDateTime2()
		INTO [Dep_CustStakeLevel_Agent_Del_InHouse]([CustID],[Sporttype],[Bettype],[RepUpdateTime])
		FROM #StakeLevel t 
			INNER JOIN Dep_CustStakeLevel_Agent a WITH(ROWLOCK,UPDLOCK) 
				ON t.CustID=a.CustID AND t.SportType=a.SportType AND t.BetType=a.BetType

		DELETE a
		OUTPUT DELETED.[CustID],DELETED.[Sporttype],DELETED.[Bettype],dbo.f_GetDateTime2()
		INTO [Dep_CustStakeLevel_Member_Del_InHouse]([CustID],[Sporttype],[Bettype],[RepUpdateTime])
		FROM #StakeLevel t
			INNER JOIN Dep_CustStakeLevel_Member a WITH(ROWLOCK,UPDLOCK) 
				ON t.CustID=a.CustID AND t.SportType=a.SportType AND t.BetType=a.BetType

		INSERT INTO dbo.Dep_CustStakeLevel_Member(CustID,SportType,BetType,StakeLevelList,LastUpdated,RepUpdateTime)
		SELECT CustID,SportType,BetType,tv.MemberStakeLevel,GETDATE(),dbo.f_GetDateTime2()	
		FROM #StakeLevel tv	
		WHERE tv.RoleID =1
	
		INSERT INTO dbo.Dep_CustStakeLevel_Agent(CustID,SportType,BetType,StakeLevelList,RepUpdateTime)
		SELECT CustID,SportType,BetType,StakeLevelList,dbo.f_GetDateTime2()
		FROM #StakeLevel
		WHERE RoleID IN(2,3,4)
	END
	DROP TABLE #StakeLevel;
	DROP TABLE #History_StakeLevel;
END;


GO