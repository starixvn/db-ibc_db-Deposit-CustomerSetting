/*<info serverAlias="DBCUST-CUSTDB" executers="" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_DynamicCustSetting_10]
	 @Site			VARCHAR(10)
	,@Currency		INT
	,@NumProduct	INT = 1
	,@CustIDList	VARCHAR(MAX) = ''
	,@PT			XML
AS
/*
	Created: 20220623@Winfred
	Task : Insert Settings Into DCS Structure - Redmine: 171705
	DB:  DBCUST/CustDB
	Original:
	Revision
		- 20220623@Winfred: Licensee Setting - Automate the PT adjustment when the charge rate is changed [RedmineID:#171705]
		- 20240708@Johnson: Apply In-house Replication for Customer Setting [redmine:#207025]
		- 20240814@Winfred: Enhance Update PT in NAP[RedmineID:#201477]
		- 20240925@Johnson: Add DBKLC1 [redmine: #207025]
		- 20241010@Johnson: remove DBKLC1 [redmine: #207025]
		- 20250224@Johnson: remove WITH(ROWLOCK,UPDLOCK) command SELECT Dep_CustSettingMode [RedmineID: #212684]
		- 20250213@Virgil.Phan: Drop BA functions [RedmineID: #216882]

	Param's Explanation:
		@PT:
		<ROOT>
			<PT SportType="172" BetType="7701" IsLive="0" PT="70.0000" />
			<PT SportType="244" BetType="3001" IsLive="0" PT="81.0000" />
			<PT SportType="245" BetType="4601" IsLive="0" PT="82.0000" />
			<PT SportType="247" BetType="4301" IsLive="0" PT="90.0000" />
			<PT SportType="247" BetType="4599" IsLive="0" PT="90.0000" />
		</ROOT>
*/
BEGIN
	IF @@SERVERNAME NOT IN ('DBCUST','DBSPARE','SITDBCUST','TESTDBCUST','DB-60\DEVDBCUST')
		RETURN;
		
	DECLARE @Threshold	INT, 
			@xml		XML, 
			@iDoc		INT		

	SET @Threshold=2000	/ @NumProduct
	
	CREATE TABLE #ValuePT (SportType INT,Bettype INT,IsLive BIT, PT SMALLMONEY )
	CREATE TABLE #tempMemNoGrouped(CustID INT PRIMARY KEY CLUSTERED,isfinished BIT DEFAULT(0))	
	CREATE TABLE #tmpCustTemp	(CustID INT PRIMARY KEY)
	CREATE TABLE #Agent (CustID INT PRIMARY KEY CLUSTERED)	

	CREATE NONCLUSTERED INDEX IDX_tempMemNoGrouped ON #tempMemNoGrouped(CustID)
	
	INSERT INTO #Agent (CustID)
	SELECT ss.value
	FROM STRING_SPLIT(@CustIDList, ',') AS ss
	WHERE value <> ''
	
	INSERT INTO #tempMemNoGrouped(CustID)
	SELECT c.CustID
	FROM dbo.Customer c WITH(NOLOCK)
			CROSS APPLY ( SELECT TOP 1 IsGroupedPT
								FROM dbo.Dep_CustSettingMode WITH(NOLOCK)
								WHERE custid=c.CustID AND IsGroupedPT=0
							) m
		INNER JOIN #Agent a ON c.recommend=a.CustID
		WHERE c.roleid =1

	--Parse XML
	EXECUTE	sp_xml_preparedocument @iDoc OUTPUT, @PT

	INSERT INTO #ValuePT (SportType, BetType, Islive, PT)
	SELECT	ox.SportType, ox.BetType, ox.Islive, ox.PT
	FROM OPENXML (@iDoc, '/ROOT/PT', 1) 
	WITH (
		SportType		SMALLINT
	,	BetType			SMALLINT
	,	IsLive			BIT
	,	PT				SMALLMONEY
	) AS ox;

	EXECUTE sp_xml_removedocument @iDoc;
	

	UPDATE a
	SET  SuperPT  = 0
		,MasterPT = 0
		,AgentPT  = v.PT
		,RepUpdateTime = dbo.f_GetDateTime2()
	FROM #Agent t
		CROSS APPLY #ValuePT v 
		CROSS APPLY (	SELECT TOP 1 SuperPT, MasterPT, AgentPT, RepUpdateTime
						FROM dbo.Dep_CustPTGroupSetting_Member WITH(ROWLOCK,UPDLOCK)
						WHERE AgentID = t.CustID AND SportType=v.SportType 
							AND BetType=v.BetType AND IsLive=v.IsLive
					) a			

	IF EXISTS(SELECT 1 FROM #tempMemNoGrouped)
	BEGIN

		WHILE (0 = 0)
		BEGIN				
				
			UPDATE TOP (@Threshold) c WITH (ROWLOCK)
			SET c.isfinished = 1
			OUTPUT DELETED.CustID INTO #tmpCustTemp(CustID)
			FROM #tempMemNoGrouped c 
			WHERE isfinished = 0
	
			IF @@ROWCOUNT = 0 BREAK

			UPDATE a
			SET a.AgentPT=v.PT,
				RepUpdateTime = dbo.f_GetDateTime2()
			FROM #tmpCustTemp t
				CROSS APPLY #ValuePT v 
				CROSS APPLY (	SELECT TOP 1 AgentPT, RepUpdateTime
								FROM dbo.Dep_CustPTSetting_Member WITH(ROWLOCK,UPDLOCK)
								WHERE CustID = t.CustID AND SportType=v.SportType 
									AND BetType=v.BetType AND IsLive=v.IsLive
							) a										
		END;
	END;		

	DROP TABLE #ValuePT
	DROP TABLE #tempMemNoGrouped	
	DROP TABLE #tmpCustTemp
	DROP TABLE #Agent 
END	

GO