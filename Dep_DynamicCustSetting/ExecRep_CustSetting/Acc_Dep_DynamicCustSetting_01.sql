/*<info serverAlias="DBCUST-CUSTDB" executers="" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_DynamicCustSetting_01]
	 @CustID				INT
	,@ProductID				INT
	,@PT					VARCHAR(MAX) = ''
AS
/*
	Created: 20170928@Winnie
	Task : Insert Settings Into DCS Structure - Redmine: 82346
	DB:  DBCUST/CustDB
	Original:
	Revision
		Revision
		- 20170928@Winnie: Insert PT Settings Into DCS Structure - Redmine: 82346
		- 20180719@Winnie: Licensee DCS setting - Support insert/edit setting for sub_licensee - Redmine: 88700
		- 20181112@Winnie: Esports - Redmine: #100721
		- 20200618@Helen: LAP - Support commission for 3rd party products [Redmine: #131774]
		- 20200718@Elodie: Support level sporttype/bettype [RedmineID:#135872]
	Param's Explanation:
		@PT:
		<ROOT>
				<PT
						SportType="211"
						BetType="2401" 
						IsLive="0"  
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
				@Currency	INT,
				@Site		VARCHAR(10),
				@Threshold	INT, 
				@StopRow	INT,
				@xml		XML, 
				@iDoc INT		

		SET @StartRow=1
		SET @Threshold=3000

		DECLARE @SportBettypeFilter TABLE(SportType INT,Bettype INT,IsLive BIT,IsApplyBA BIT)		
		CREATE TABLE #ValuePT (SportType INT,Bettype INT,IsLive BIT, PT SMALLMONEY)

		CREATE TABLE #tempMemBA(ID INT IDENTITY (1,1) PRIMARY KEY,CustID INT )	
		CREATE TABLE #tempMemNonBA(ID INT IDENTITY (1,1) PRIMARY KEY,CustID INT )		
		CREATE TABLE #tempMemNoGrouped(ID INT IDENTITY (1,1) PRIMARY KEY,CustID INT )		

		CREATE NONCLUSTERED INDEX IDX_tempMemBA ON #tempMemBA(CustID)
		CREATE NONCLUSTERED INDEX IDX_tempMemNonBA ON #tempMemNonBA(CustID)
		CREATE NONCLUSTERED INDEX IDX_tempMemNoGrouped ON #tempMemNoGrouped(CustID)
		
		INSERT INTO @SportBettypeFilter (SportType,Bettype,IsLive,IsApplyBA)
		SELECT DISTINCT SportType,Bettype,IsLive,IsApplyBA
		FROM Dep_ProductSetting ps WITH(NOLOCK) 
			INNER JOIN Dep_ProductSettingDetail d WITH(NOLOCK) ON ps.ProductSettingID=d.ProductSettingID  
		WHERE ProductID = @ProductID AND SettingType=1		
		
		SELECT @Site=Site,@Currency=Currency FROM Customer WITH(NOLOCK) WHERE custid=@CustID	
		
		INSERT INTO #tempMemBA(CustID)
		SELECT c.CustID
		FROM Customer c WITH(NOLOCK)
			INNER JOIN Dep_CustBAActive BA WITH(NOLOCK) ON c.custid=BA.CustId
			LEFT JOIN Dep_CustSettingMode m WITH(NOLOCK) ON c.custid = m.CustID
			OUTER APPLY (SELECT TOP 1 custid
						 FROM dbo.Dep_CustPTSetting_Member ptm WITH (NOLOCK)
						 WHERE 	ptm.custid = c.custid) AS tmp
		WHERE c.recommend=@CustID AND c.roleid =1
			AND (m.CustID IS NULL OR (m.IsGroupedPT = 0 AND tmp.CustID IS NULL))
			
		INSERT INTO #tempMemNonBA(CustID)
		SELECT c.CustID
		FROM Customer c WITH(NOLOCK)
			LEFT JOIN Dep_CustSettingMode m WITH(NOLOCK) ON c.custid = m.CustID
			OUTER APPLY (SELECT TOP 1 custid
						 FROM dbo.Dep_CustPTSetting_Member ptm WITH (NOLOCK)
						 WHERE 	ptm.custid = c.custid) AS tmp
						 			
		WHERE c.recommend=@CustID AND c.roleid =1
			AND (m.CustID IS NULL OR (m.IsGroupedPT = 0 AND tmp.CustID IS NULL))
			AND c.custid NOT IN (SELECT BA.CustID FROM  Dep_CustBAActive BA WITH(NOLOCK))

		INSERT INTO #tempMemNoGrouped(CustID)
		SELECT c.CustID
		FROM dbo.Customer c WITH(NOLOCK)
			INNER JOIN 	dbo.Dep_CustSettingMode m WITH(NOLOCK) ON c.custid=m.CustID	
			CROSS APPLY (SELECT TOP 1 custid
						 FROM dbo.Dep_CustPTSetting_Member ptm WITH (NOLOCK)
						 WHERE 	ptm.custid = c.custid) AS tmp
		WHERE c.recommend=@CustID AND c.roleid =1
			AND m.IsGroupedPT=0

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

		IF(@Site='asiabet88' AND @Currency IN(3,6))
		BEGIN
			IF EXISTS (SELECT 1 FROM 	@SportBettypeFilter ft 
									INNER JOIN dbo.Dep_CustPTGroupSetting_Member bl WITH (NOLOCK) ON ft.SportType = bl.sporttype AND ft.BetType = bl.bettype 
										WHERE AgentID=@CustID AND ft.IsApplyBA=0)
				UPDATE a
					SET
						 SuperPT  = 0
						,MasterPT = 0
						,AgentPT  = v.PT
				FROM dbo.Dep_CustPTGroupSetting_Member a WITH(ROWLOCK)
					INNER JOIN @SportBettypeFilter t ON a.AgentID=@CustID AND a.SportType=t.SportType AND a.BetType=t.BetType AND a.IsLive=t.IsLive
					INNER JOIN #ValuePT v ON t.SportType=v.SportType AND t.BetType=v.BetType AND t.IsLive=v.IsLive
				WHERE t.IsApplyBA=0
			ELSE
				INSERT INTO dbo.Dep_CustPTGroupSetting_Member(AgentID,SportType,BetType,IsLive,SuperPT,MasterPT,AgentPT)
				SELECT @CustID,t.SportType,t.BetType,t.IsLive,0,0,v.PT
				FROM @SportBettypeFilter t
					INNER JOIN #ValuePT v ON t.SportType=v.SportType AND t.BetType=v.BetType AND t.IsLive=v.IsLive
				WHERE t.IsApplyBA=0

			IF EXISTS (SELECT 1 FROM 	@SportBettypeFilter ft 
									INNER JOIN dbo.Dep_CustPTGroupSetting_Member bl WITH (NOLOCK) ON ft.SportType = bl.sporttype AND ft.BetType = bl.bettype 
										WHERE AgentID=@CustID AND ft.IsApplyBA=1)
				UPDATE a
					SET
						 SuperPT  = 0
						,MasterPT = 0
						,AgentPT  = 0
				FROM dbo.Dep_CustPTGroupSetting_Member a WITH(ROWLOCK)
					INNER JOIN @SportBettypeFilter t ON a.AgentID=@CustID AND a.SportType=t.SportType AND a.BetType=t.BetType
				WHERE t.IsApplyBA=1
			ELSE
				INSERT INTO dbo.Dep_CustPTGroupSetting_Member(AgentID,SportType,BetType,IsLive,SuperPT,MasterPT,AgentPT)
				SELECT @CustID,SportType,BetType,IsLive,0,0,0
				FROM @SportBettypeFilter t
				WHERE t.IsApplyBA=1
		END
		ELSE
		BEGIN
			IF EXISTS (SELECT 1 FROM 	@SportBettypeFilter ft 
									INNER JOIN dbo.Dep_CustPTGroupSetting_Member bl WITH (NOLOCK) ON ft.SportType = bl.sporttype AND ft.BetType = bl.bettype 
										WHERE AgentID=@CustID)
				UPDATE a
					SET
						 SuperPT  = 0
						,MasterPT = 0
						,AgentPT  = v.PT
				FROM dbo.Dep_CustPTGroupSetting_Member a WITH(ROWLOCK)
					INNER JOIN @SportBettypeFilter t ON a.AgentID=@CustID AND a.SportType=t.SportType AND a.BetType=t.BetType AND a.IsLive=t.IsLive
					INNER JOIN #ValuePT v ON t.SportType=v.SportType AND t.BetType=v.BetType AND t.IsLive=v.IsLive			
			ELSE
				INSERT INTO dbo.Dep_CustPTGroupSetting_Member(AgentID,SportType,BetType,IsLive,SuperPT,MasterPT,AgentPT)
				SELECT @CustID,t.SportType,t.BetType,t.IsLive,0,0,v.PT
				FROM @SportBettypeFilter t				
					INNER JOIN #ValuePT v ON t.SportType=v.SportType AND t.BetType=v.BetType AND t.IsLive=v.IsLive		
		END

		IF(@Site='asiabet88' AND @Currency IN(3,6))
		BEGIN
			IF EXISTS(SELECT 1 FROM #tempMemBA)
			BEGIN
			
				SET @MaxRow = (SELECT MAX(ID) FROM #tempMemBA)
			
				IF	@Threshold >= @MaxRow
				SET	@Threshold = @MaxRow
			
				SET @StopRow = @Threshold

				WHILE (0 = 0)
				BEGIN	
				
					UPDATE dcm 
						   SET IsGroupedPT = 1
					FROM dbo.Dep_CustSettingMode dcm WITH (ROWLOCK)	
						INNER JOIN #tempMemBA c ON c.CustID = dcm.CustID AND dcm.IsGroupedPT = 0
					WHERE ID >= @StartRow AND ID <= @StopRow
					
					INSERT INTO dbo.Dep_CustSettingMode
						   (CustID
						   ,IsGroupedPT
						   ,IsGroupedComm
						   ,IsGroupedBetLimit
						)	
					SELECT c.CustID,1,0,0
					FROM #tempMemBA c
					WHERE ID >= @StartRow AND ID <= @StopRow	
						AND NOT EXISTS (SELECT 1 FROM  Dep_CustSettingMode m WITH(NOLOCK) WHERE m.CustID=c.CustID)	
		
					IF	@StopRow = @MaxRow 
						BREAK
						
					SET	@StartRow = @StopRow + 1
						
					SET	@StopRow = 1 + @StopRow + @Threshold
						
					IF	@StopRow >= @MaxRow
						SET	@StopRow = @MaxRow
										
				END;
			END;	
			
			SET @StartRow=1
			SET @Threshold=3000	

			IF EXISTS(SELECT 1 FROM #tempMemNonBA)
			BEGIN
			
				SET @MaxRow = (SELECT MAX(ID) FROM #tempMemNonBA)
			
				IF	@Threshold >= @MaxRow
				SET	@Threshold = @MaxRow
			
				SET @StopRow = @Threshold

				WHILE (0 = 0)
				BEGIN
					
					UPDATE dcm 
						   SET IsGroupedPT = 0
					FROM dbo.Dep_CustSettingMode dcm WITH (ROWLOCK)	
						INNER JOIN #tempMemNonBA c ON c.CustID = dcm.CustID AND dcm.IsGroupedPT = 1
					WHERE ID >= @StartRow AND ID <= @StopRow	
						
					INSERT INTO dbo.Dep_CustSettingMode
						   (CustID
						   ,IsGroupedPT
						   ,IsGroupedComm
						   ,IsGroupedBetLimit
						)	
					SELECT c.CustID,0,0,0
					FROM #tempMemNonBA c
					WHERE ID >= @StartRow AND ID <= @StopRow	
						AND NOT EXISTS (SELECT 1 FROM  Dep_CustSettingMode m WITH(NOLOCK) WHERE m.CustID=c.CustID)	

					INSERT INTO [dbo].[Dep_CustPTSetting_Member](CustID,[SportType],[BetType],[IsLive],SuperPT,MasterPT,AgentPT)
					SELECT c.CustID,t.SportType,t.BetType,t.IsLive,0,0,v.PT
					FROM #tempMemNonBA c		
						CROSS APPLY @SportBettypeFilter t	
						INNER JOIN #ValuePT v ON t.SportType=v.SportType AND t.BetType=v.BetType AND t.IsLive=v.IsLive		
					WHERE ID >= @StartRow AND ID <= @StopRow	
						AND NOT EXISTS (SELECT 1 FROM  Dep_CustPTSetting_Member m WITH(NOLOCK) WHERE m.CustID=c.CustID AND m.SportType=t.SportType AND m.BetType=t.Bettype AND m.IsLive=t.IsLive)	
						
					IF	@StopRow = @MaxRow 
						BREAK
						
					SET	@StartRow = @StopRow + 1
						
					SET	@StopRow = 1 + @StopRow + @Threshold
						
					IF	@StopRow >= @MaxRow
						SET	@StopRow = @MaxRow
										
				END;
			END;		

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
					
					INSERT INTO [dbo].[Dep_CustPTSetting_Member](CustID,[SportType],[BetType],[IsLive],SuperPT,MasterPT,AgentPT)
					SELECT c.CustID,SportType,BetType,IsLive,0,0,@PT
					FROM #tempMemNoGrouped c		
						CROSS APPLY @SportBettypeFilter t	
					WHERE ID >= @StartRow AND ID <= @StopRow	
						AND NOT EXISTS (SELECT 1 FROM  Dep_CustPTSetting_Member m WITH(NOLOCK) WHERE m.CustID=c.CustID AND m.SportType=t.SportType AND m.BetType=t.Bettype AND m.IsLive=t.IsLive)	
							
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
			IF EXISTS(SELECT 1 FROM #tempMemNonBA)
			BEGIN
			
				SET @MaxRow = (SELECT MAX(ID) FROM #tempMemNonBA)
			
				IF	@Threshold >= @MaxRow
				SET	@Threshold = @MaxRow
			
				SET @StopRow = @Threshold

				WHILE (0 = 0)
				BEGIN	
					
					UPDATE dcm 
						   SET IsGroupedPT = 1
					FROM dbo.Dep_CustSettingMode dcm WITH (ROWLOCK)	
						INNER JOIN #tempMemNonBA c ON c.CustID = dcm.CustID AND dcm.IsGroupedPT = 0
					WHERE ID >= @StartRow AND ID <= @StopRow
					
					INSERT INTO dbo.Dep_CustSettingMode
						   (CustID
						   ,IsGroupedPT
						   ,IsGroupedComm
						   ,IsGroupedBetLimit
						)	
					SELECT c.CustID,1,0,0
					FROM #tempMemNonBA c
					WHERE ID >= @StartRow AND ID <= @StopRow	
						AND NOT EXISTS (SELECT 1 FROM  Dep_CustSettingMode m WITH(NOLOCK) WHERE m.CustID=c.CustID)	
		
					IF	@StopRow = @MaxRow 
						BREAK
						
					SET	@StartRow = @StopRow + 1
						
					SET	@StopRow = 1 + @StopRow + @Threshold
						
					IF	@StopRow >= @MaxRow
						SET	@StopRow = @MaxRow
										
				END;
			END;	
			
			SET @StartRow=1
			SET @Threshold=3000	

			IF EXISTS(SELECT 1 FROM #tempMemBA)
			BEGIN
			
				SET @MaxRow = (SELECT MAX(ID) FROM #tempMemBA)
			
				IF	@Threshold >= @MaxRow
				SET	@Threshold = @MaxRow
			
				SET @StopRow = @Threshold

				WHILE (0 = 0)
				BEGIN
					
					UPDATE dcm 
						   SET IsGroupedPT = 0
					FROM dbo.Dep_CustSettingMode dcm WITH (ROWLOCK)	
						INNER JOIN #tempMemBA c ON c.CustID = dcm.CustID AND dcm.IsGroupedPT = 1
					WHERE ID >= @StartRow AND ID <= @StopRow	
						
					INSERT INTO dbo.Dep_CustSettingMode
						   (CustID
						   ,IsGroupedPT
						   ,IsGroupedComm
						   ,IsGroupedBetLimit
						)	
					SELECT c.CustID,0,0,0
					FROM #tempMemBA c
					WHERE ID >= @StartRow AND ID <= @StopRow	
						AND NOT EXISTS (SELECT 1 FROM  Dep_CustSettingMode m WITH(NOLOCK) WHERE m.CustID=c.CustID)	

					INSERT INTO [dbo].[Dep_CustPTSetting_Member](CustID,[SportType],[BetType],[IsLive],SuperPT,MasterPT,AgentPT)
					SELECT c.CustID,SportType,BetType,IsLive,0,0,0
					FROM #tempMemBA c		
						CROSS APPLY @SportBettypeFilter t	
					WHERE ID >= @StartRow AND ID <= @StopRow	
						AND NOT EXISTS (SELECT 1 FROM  Dep_CustPTSetting_Member m WITH(NOLOCK) WHERE m.CustID=c.CustID AND m.SportType=t.SportType AND m.BetType=t.Bettype AND m.IsLive=t.IsLive)	
						AND t.IsApplyBA=1

					INSERT INTO [dbo].[Dep_CustPTSetting_Member](CustID,[SportType],[BetType],[IsLive],SuperPT,MasterPT,AgentPT)
					SELECT c.CustID,t.SportType,t.BetType,t.IsLive,0,0,v.PT
					FROM #tempMemBA c		
						CROSS APPLY @SportBettypeFilter t
						INNER JOIN #ValuePT v ON t.SportType=v.SportType AND t.BetType=v.BetType AND t.IsLive=v.IsLive			
					WHERE ID >= @StartRow AND ID <= @StopRow	
						AND NOT EXISTS (SELECT 1 FROM  Dep_CustPTSetting_Member m WITH(NOLOCK) WHERE m.CustID=c.CustID AND m.SportType=t.SportType AND m.BetType=t.Bettype AND m.IsLive=t.IsLive)	
						AND t.IsApplyBA=0

					IF	@StopRow = @MaxRow 
						BREAK
						
					SET	@StartRow = @StopRow + 1
						
					SET	@StopRow = 1 + @StopRow + @Threshold
						
					IF	@StopRow >= @MaxRow
						SET	@StopRow = @MaxRow
										
				END;
			END;		

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
						AND ID >= @StartRow AND ID <= @StopRow	
					
					INSERT INTO [dbo].[Dep_CustPTSetting_Member](CustID,[SportType],[BetType],[IsLive],SuperPT,MasterPT,AgentPT)
					SELECT c.CustID,SportType,BetType,IsLive,0,0,@PT
					FROM #tempMemNoGrouped c		
						CROSS APPLY @SportBettypeFilter t	
					WHERE ID >= @StartRow AND ID <= @StopRow	
						AND NOT EXISTS (SELECT 1 FROM  Dep_CustPTSetting_Member m WITH(NOLOCK) WHERE m.CustID=c.CustID AND m.SportType=t.SportType AND m.BetType=t.Bettype AND m.IsLive=t.IsLive)	
						AND t.IsApplyBA=0
							
					UPDATE s
					SET s.AgentPT=0
					FROM [Dep_CustPTSetting_Member] s WITH(ROWLOCK)
						INNER JOIN Dep_CustBAActive BA ON s.CustID=BA.CustId
						INNER JOIN #tempMemNoGrouped c	ON s.CustID=c.CustID
						INNER JOIN @SportBettypeFilter t ON s.SportType=t.SportType AND s.BetType=t.Bettype AND s.IsLive=t.IsLive
					WHERE ID >= @StartRow AND ID <= @StopRow	
						AND t.IsApplyBA=1						
					
					INSERT INTO [dbo].[Dep_CustPTSetting_Member](CustID,[SportType],[BetType],[IsLive],SuperPT,MasterPT,AgentPT)
					SELECT c.CustID,SportType,BetType,IsLive,0,0,0
					FROM #tempMemNoGrouped c		
						CROSS APPLY @SportBettypeFilter t	
					WHERE ID >= @StartRow AND ID <= @StopRow	
						AND NOT EXISTS (SELECT 1 FROM  Dep_CustPTSetting_Member m WITH(NOLOCK) WHERE m.CustID=c.CustID AND m.SportType=t.SportType AND m.BetType=t.Bettype AND m.IsLive=t.IsLive)	
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