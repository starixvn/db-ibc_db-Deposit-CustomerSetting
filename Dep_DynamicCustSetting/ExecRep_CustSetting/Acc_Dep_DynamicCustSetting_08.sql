/*<info serverAlias="DBCUST-CUSTDB" executers="" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_DynamicCustSetting_08]
	 @Site			VARCHAR(10)
	,@Currency		INT
	,@InputPT		VARCHAR(MAX) = ''
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
				<PT
						PID="59"
						CID="0"
						PT="90"
				/>
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

		DECLARE @StartRow	INT, 
				@MaxRow		INT,
				@Threshold	INT, 
				@StopRow	INT,
				@xml		XML, 
				@iDoc		INT	, 
				@iDoc2		INT		

		SET @StartRow=1
		SET @Threshold=3000

		DECLARE @SportBettypeFilter TABLE(SportType INT,Bettype INT,IsLive BIT,IsApplyBA BIT)		
		CREATE TABLE #ValuePT (SportType INT,Bettype INT,IsLive BIT, PT SMALLMONEY)
		CREATE TABLE #PTProduct(ProductID INT,Currency INT,PT SMALLMONEY)	
		CREATE TABLE #tempMemNoGrouped(ID INT IDENTITY (1,1) PRIMARY KEY,CustID INT )	
		CREATE TABLE #Agent (CustID INT PRIMARY KEY CLUSTERED)	

		CREATE NONCLUSTERED INDEX IDX_tempMemNoGrouped ON #tempMemNoGrouped(CustID)
		
		--Parse XML
		EXECUTE	sp_xml_preparedocument @iDoc OUTPUT, @InputPT

		INSERT INTO #PTProduct (ProductID, Currency, PT)
		SELECT	ox.PID, ox.CID, ox.PT
		FROM OPENXML (@iDoc, '/ROOT/PT', 1) 
		WITH (
			PID		INT
		,	CID		INT
		,	PT		SMALLMONEY	
		) AS ox;

		EXECUTE sp_xml_removedocument @iDoc;
		
		INSERT INTO #Agent (CustID)
		SELECT ss.value
		FROM STRING_SPLIT(@CustIDList, ',') AS ss
		WHERE value <> ''

		INSERT INTO @SportBettypeFilter (SportType,Bettype,IsLive,IsApplyBA)
		SELECT DISTINCT SportType,Bettype,IsLive,IsApplyBA
		FROM Dep_ProductSetting ps WITH(NOLOCK) 
			INNER JOIN Dep_ProductSettingDetail d WITH(NOLOCK) ON ps.ProductSettingID=d.ProductSettingID  
			INNER JOIN #PTProduct p ON ps.ProductID = p.ProductID
		WHERE SettingType=1	

		INSERT INTO #tempMemNoGrouped(CustID)
		SELECT c.CustID
		FROM dbo.Customer c WITH(NOLOCK)
			INNER JOIN 	dbo.Dep_CustSettingMode m WITH(NOLOCK) ON c.custid=m.CustID	
			INNER JOIN #Agent a ON c.recommend=a.CustID
			CROSS APPLY (SELECT TOP 1 custid
						 FROM dbo.Dep_CustPTSetting_Member ptm WITH (NOLOCK)
						 WHERE 	ptm.custid = c.custid) AS tmp
		WHERE c.roleid =1 AND m.IsGroupedPT=0

		--Parse XML
		EXECUTE	sp_xml_preparedocument @iDoc2 OUTPUT, @PT

		INSERT INTO #ValuePT (SportType, BetType, Islive, PT)
		SELECT	ox.SportType, ox.BetType, ox.Islive, ox.PT
		FROM OPENXML (@iDoc2, '/ROOT/PT', 1) 
		WITH (
			SportType		SMALLINT
		,	BetType			SMALLINT
		,	IsLive			BIT
		,	PT				SMALLMONEY	
		) AS ox;

		EXECUTE sp_xml_removedocument @iDoc2;
		
		IF(@Site='asiabet88' AND @Currency IN(3,6))
		BEGIN
			UPDATE a
				SET
					SuperPT  = 0
					,MasterPT = 0
					,AgentPT  = v.PT
			FROM dbo.Dep_CustPTGroupSetting_Member a WITH(ROWLOCK)
				INNER JOIN #Agent ag ON a.AgentID=ag.CustID
				INNER JOIN @SportBettypeFilter t ON a.SportType=t.SportType AND a.BetType=t.BetType AND a.IsLive=t.IsLive
				INNER JOIN #ValuePT v ON t.SportType=v.SportType AND t.BetType=v.BetType AND t.IsLive=v.IsLive
			WHERE t.IsApplyBA=0
			
			UPDATE a
				SET
					SuperPT  = 0
					,MasterPT = 0
					,AgentPT  = 0
			FROM dbo.Dep_CustPTGroupSetting_Member a WITH(ROWLOCK)
				CROSS APPLY #Agent ag 
				INNER JOIN @SportBettypeFilter t ON a.AgentID=ag.CustID AND a.SportType=t.SportType AND a.BetType=t.BetType
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
				INNER JOIN @SportBettypeFilter t ON a.SportType=t.SportType AND a.BetType=t.BetType AND a.IsLive=t.IsLive
				INNER JOIN #ValuePT v ON t.SportType=v.SportType AND t.BetType=v.BetType AND t.IsLive=v.IsLive			
		END

		IF(@Site='asiabet88' AND @Currency IN(3,6))
		BEGIN
						
			SET @StartRow=1
			SET @Threshold=3000	

			IF EXISTS(SELECT 1 FROM #tempMemNoGrouped)
			BEGIN
			
				SET @MaxRow = (SELECT MAX(ID) FROM #tempMemNoGrouped)
			
				IF	@Threshold >= @MaxRow
					SET	@Threshold = @MaxRow
			
				SET @StopRow = @Threshold

				WHILE (0 = 0)
				BEGIN				
				
					UPDATE s
					SET s.AgentPT=v.PT
					FROM [Dep_CustPTSetting_Member] s WITH(ROWLOCK)
						INNER JOIN #tempMemNoGrouped c	ON s.CustID=c.CustID
						INNER JOIN @SportBettypeFilter t ON s.SportType=t.SportType AND s.BetType=t.Bettype AND s.IsLive=t.IsLive
						INNER JOIN #ValuePT v ON t.SportType=v.SportType AND t.BetType=v.BetType AND t.IsLive=v.IsLive		
					WHERE ID >= @StartRow AND ID <= @StopRow	
					
					IF	@StopRow = @MaxRow 
						BREAK
						
					SET	@StartRow = @StopRow + 1
						
					SET	@StopRow = 1 + @StopRow + @Threshold
						
					IF	@StopRow >= @MaxRow
						SET	@StopRow = @MaxRow
										
				END;
			END;		
		END
		ELSE
		BEGIN
			SET @StartRow=1
			SET @Threshold=3000

			IF EXISTS(SELECT 1 FROM #tempMemNoGrouped)
			BEGIN
			
				SET @MaxRow = (SELECT MAX(ID) FROM #tempMemNoGrouped)
			
				IF	@Threshold >= @MaxRow
					SET	@Threshold = @MaxRow
			
				SET @StopRow = @Threshold

				WHILE (0 = 0)
				BEGIN				
					
					UPDATE s
					SET s.AgentPT=v.PT
					FROM [Dep_CustPTSetting_Member] s WITH(ROWLOCK)
						INNER JOIN #tempMemNoGrouped c	ON s.CustID=c.CustID
						INNER JOIN @SportBettypeFilter t ON s.SportType=t.SportType AND s.BetType=t.Bettype AND s.IsLive=t.IsLive	
						INNER JOIN #ValuePT v ON t.SportType=v.SportType AND t.BetType=v.BetType AND t.IsLive=v.IsLive							
					WHERE t.IsApplyBA=0
							
					UPDATE s
					SET s.AgentPT=0
					FROM [Dep_CustPTSetting_Member] s WITH(ROWLOCK)
						INNER JOIN Dep_CustBAActive BA ON s.CustID=BA.CustId
						INNER JOIN #tempMemNoGrouped c	ON s.CustID=c.CustID
						INNER JOIN @SportBettypeFilter t ON s.SportType=t.SportType AND s.BetType=t.Bettype AND s.IsLive=t.IsLive
					WHERE ID >= @StartRow AND ID <= @StopRow	
						AND t.IsApplyBA=1
							
					IF	@StopRow = @MaxRow 
						BREAK
						
					SET	@StartRow = @StopRow + 1
						
					SET	@StopRow = 1 + @StopRow + @Threshold
						
					IF	@StopRow >= @MaxRow
						SET	@StopRow = @MaxRow
										
				END;
			END;		
		END
END	

GO