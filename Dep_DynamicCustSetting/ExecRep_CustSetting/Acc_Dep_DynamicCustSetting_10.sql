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
	Param's Explanation:
		@PT:
		<ROOT>
			<PT SportType="172" BetType="7701" IsLive="0" PT="70.0000" IsApplyBA="0" />
			<PT SportType="244" BetType="3001" IsLive="0" PT="81.0000" IsApplyBA="0" />
			<PT SportType="245" BetType="4601" IsLive="0" PT="82.0000" IsApplyBA="0" />
			<PT SportType="247" BetType="4301" IsLive="0" PT="90.0000" IsApplyBA="0" />
			<PT SportType="247" BetType="4599" IsLive="0" PT="90.0000" IsApplyBA="0" />
		</ROOT>
*/
BEGIN
	IF(dbo.f_CheckRepTable('Dep_CustPTGroupSetting_Member') = 0
		OR dbo.f_CheckRepTable('Dep_CustPTSetting_Agent') = 0	
		OR dbo.f_CheckRepTable('Dep_CustPTSetting_Member') = 0	
		OR dbo.f_CheckRepTable('Dep_CustSettingMode') = 0	
		OR dbo.f_CheckRepTable('Dep_ProductSetting') = 0	
		OR dbo.f_CheckRepTable('Dep_ProductSettingDetail') = 0	
		OR dbo.f_CheckRepTable('Customer') = 0	
	   )
		RETURN

		DECLARE @Threshold	INT, 
				@xml		XML, 
				@iDoc		INT		

		SET @Threshold=5000	/ @NumProduct
		
		CREATE TABLE #ValuePT (SportType INT,Bettype INT,IsLive BIT, PT SMALLMONEY,IsApplyBA BIT)
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
			INNER JOIN 	dbo.Dep_CustSettingMode m WITH(NOLOCK) ON c.custid=m.CustID	
			INNER JOIN #Agent a ON c.recommend=a.CustID
		WHERE c.roleid =1 AND m.IsGroupedPT=0

		--Parse XML
		EXECUTE	sp_xml_preparedocument @iDoc OUTPUT, @PT

		INSERT INTO #ValuePT (SportType, BetType, Islive, PT, IsApplyBA)
		SELECT	ox.SportType, ox.BetType, ox.Islive, ox.PT, ox.IsApplyBA
		FROM OPENXML (@iDoc, '/ROOT/PT', 1) 
		WITH (
			SportType		SMALLINT
		,	BetType			SMALLINT
		,	IsLive			BIT
		,	PT				SMALLMONEY	
		,	IsApplyBA		BIT
		) AS ox;

		EXECUTE sp_xml_removedocument @iDoc;
		
		IF(@Site='asiabet88' AND @Currency IN(3,6))
		BEGIN
			UPDATE a
				SET
					SuperPT  = 0
					,MasterPT = 0
					,AgentPT  = v.PT
			FROM dbo.Dep_CustPTGroupSetting_Member a WITH(ROWLOCK)
				INNER JOIN #Agent ag ON a.AgentID=ag.CustID
				INNER JOIN #ValuePT v ON a.SportType=v.SportType AND a.BetType=v.BetType AND a.IsLive=v.IsLive
			WHERE v.IsApplyBA=0
			
			UPDATE a
				SET
					SuperPT  = 0
					,MasterPT = 0
					,AgentPT  = 0
			FROM dbo.Dep_CustPTGroupSetting_Member a WITH(ROWLOCK)
				CROSS APPLY #Agent ag 
				INNER JOIN #ValuePT t ON a.AgentID=ag.CustID AND a.SportType=t.SportType AND a.BetType=t.BetType
			WHERE t.IsApplyBA=1
		END
		ELSE
		BEGIN
			UPDATE a
				SET
					SuperPT  = 0
					,MasterPT = 0
					,AgentPT  = v.PT
			FROM dbo.Dep_CustPTGroupSetting_Member a WITH(ROWLOCK)
				INNER JOIN #Agent ag ON a.AgentID=ag.CustID
				INNER JOIN #ValuePT v ON a.SportType=v.SportType AND a.BetType=v.BetType AND a.IsLive=v.IsLive			
		END
		
		IF(@Site='asiabet88' AND @Currency IN(3,6))
		BEGIN
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

					UPDATE s
					SET s.AgentPT=v.PT
					FROM [Dep_CustPTSetting_Member] s WITH(ROWLOCK)
						INNER JOIN #tmpCustTemp c	ON s.CustID=c.CustID
						INNER JOIN #ValuePT v ON s.SportType=v.SportType AND s.BetType=v.BetType AND s.IsLive=v.IsLive			
					
					TRUNCATE TABLE #tmpCustTemp					
				END;
			END;		
		END
		ELSE
		BEGIN
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

					UPDATE s
					SET s.AgentPT=v.PT
					FROM [Dep_CustPTSetting_Member] s WITH(ROWLOCK)
						INNER JOIN #tmpCustTemp c	ON s.CustID=c.CustID
						INNER JOIN #ValuePT v ON s.SportType=v.SportType AND s.BetType=v.BetType AND s.IsLive=v.IsLive							
					WHERE v.IsApplyBA=0
							
					UPDATE s
					SET s.AgentPT=0
					FROM [Dep_CustPTSetting_Member] s WITH(ROWLOCK)
						INNER JOIN Dep_CustBAActive BA ON s.CustID=BA.CustId
						INNER JOIN #tmpCustTemp c	ON s.CustID=c.CustID
						INNER JOIN #ValuePT t ON s.SportType=t.SportType AND s.BetType=t.Bettype AND s.IsLive=t.IsLive
					WHERE t.IsApplyBA=1
										
				END;
			END;		
		END

		DROP TABLE #ValuePT
		DROP TABLE #tempMemNoGrouped	
		DROP TABLE #tmpCustTemp
		DROP TABLE #Agent 
END	

GO