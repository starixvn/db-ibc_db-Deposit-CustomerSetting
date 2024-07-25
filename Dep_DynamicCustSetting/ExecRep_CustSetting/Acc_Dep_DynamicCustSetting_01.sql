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
		- 202202220@Elodie: Apply DCS for SB [RedmineID: #167898] 
		- 20240708@Johnson: Apply In-house Replication for Customer Setting [redmine:#207025]
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
	DECLARE @StartRow INT, @StopRow	INT, @MaxRow INT, @Threshold INT, 
			@Currency INT, @Site VARCHAR(10),
			@xml XML, @iDoc INT				

	DECLARE @SportBettypeFilter TABLE(SportType INT,Bettype INT,IsLive BIT,IsApplyBA BIT)		
	CREATE TABLE #ValuePT (SportType INT,Bettype INT,IsLive BIT, PT SMALLMONEY)
	CREATE TABLE #tempMemNoGrouped(ID INT IDENTITY (1,1) PRIMARY KEY,CustID INT )	

	CREATE NONCLUSTERED INDEX IDX_tempMemNoGrouped ON #tempMemNoGrouped(CustID)

	INSERT INTO @SportBettypeFilter (SportType,Bettype,IsLive,IsApplyBA)
	SELECT DISTINCT SportType,Bettype,IsLive,IsApplyBA
	FROM Dep_ProductSetting ps WITH(NOLOCK) 
		INNER JOIN Dep_ProductSettingDetail d WITH(NOLOCK) ON ps.ProductSettingID=d.ProductSettingID  
	WHERE ProductID = @ProductID AND SettingType=1		
	
	SELECT @Site=Site,@Currency=Currency FROM Customer WITH(NOLOCK) WHERE custid=@CustID	
	
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

	INSERT INTO #tempMemNoGrouped(CustID)
	SELECT c.CustID
	FROM dbo.Customer c WITH(NOLOCK)
		INNER JOIN 	dbo.Dep_CustSettingMode m WITH(NOLOCK) ON c.custid=m.CustID	
	WHERE c.recommend = @CustID AND c.roleid =1
		AND m.IsGroupedPT=0

	IF(@Site='asiabet88' AND @Currency IN(3,6))
	BEGIN
		IF EXISTS (	SELECT 1 
					FROM @SportBettypeFilter ft 
						INNER JOIN dbo.Dep_CustPTGroupSetting_Member bl WITH (NOLOCK) ON ft.SportType = bl.sporttype AND ft.BetType = bl.bettype 
					WHERE AgentID=@CustID)
		BEGIN
			UPDATE a
			SET
				SuperPT  = 0
				,MasterPT = 0
				,AgentPT  = v.PT
				,RepUpdateTime = SYSDATETIME()
			FROM dbo.Dep_CustPTGroupSetting_Member a WITH(ROWLOCK)
				INNER JOIN @SportBettypeFilter t ON a.SportType=t.SportType AND a.BetType=t.BetType AND a.IsLive=t.IsLive
				INNER JOIN #ValuePT v ON t.SportType=v.SportType AND t.BetType=v.BetType AND t.IsLive=v.IsLive
			WHERE a.AgentID = @CustID AND t.IsApplyBA = 0

			UPDATE a
			SET
				SuperPT  = 0
				,MasterPT = 0
				,AgentPT  = 0
				,RepUpdateTime = SYSDATETIME()
			FROM dbo.Dep_CustPTGroupSetting_Member a WITH(ROWLOCK)
				INNER JOIN @SportBettypeFilter t ON a.SportType=t.SportType AND a.BetType=t.BetType AND a.IsLive=t.IsLive
				INNER JOIN #ValuePT v ON t.SportType=v.SportType AND t.BetType=v.BetType AND t.IsLive=v.IsLive
			WHERE a.AgentID = @CustID AND t.IsApplyBA = 1
		END
		ELSE
		BEGIN
			INSERT INTO dbo.Dep_CustPTGroupSetting_Member(AgentID,SportType,BetType,IsLive,SuperPT,MasterPT,AgentPT,RepUpdateTime)
			SELECT @CustID,t.SportType,t.BetType,t.IsLive,0,0,v.PT,SYSDATETIME()
			FROM @SportBettypeFilter t
				INNER JOIN #ValuePT v ON t.SportType=v.SportType AND t.BetType=v.BetType AND t.IsLive=v.IsLive
			WHERE t.IsApplyBA=0

			INSERT INTO dbo.Dep_CustPTGroupSetting_Member(AgentID,SportType,BetType,IsLive,SuperPT,MasterPT,AgentPT,RepUpdateTime)
			SELECT @CustID,SportType,BetType,IsLive,0,0,0,SYSDATETIME()
			FROM @SportBettypeFilter t
			WHERE t.IsApplyBA=1
		END
	END
	ELSE
	BEGIN
		IF EXISTS (	SELECT 1 
					FROM @SportBettypeFilter ft 
						INNER JOIN dbo.Dep_CustPTGroupSetting_Member bl WITH (NOLOCK) ON ft.SportType = bl.sporttype AND ft.BetType = bl.bettype 
					WHERE AgentID=@CustID)
			UPDATE a
				SET
					 SuperPT  = 0
					,MasterPT = 0
					,AgentPT  = v.PT
					,RepUpdateTime = SYSDATETIME()
			FROM dbo.Dep_CustPTGroupSetting_Member a WITH(ROWLOCK)
				INNER JOIN @SportBettypeFilter t ON a.SportType=t.SportType AND a.BetType=t.BetType AND a.IsLive=t.IsLive
				INNER JOIN #ValuePT v ON t.SportType=v.SportType AND t.BetType=v.BetType AND t.IsLive=v.IsLive		
			WHERE a.AgentID = @CustID
		ELSE
			INSERT INTO dbo.Dep_CustPTGroupSetting_Member(AgentID,SportType,BetType,IsLive,SuperPT,MasterPT,AgentPT,RepUpdateTime)
			SELECT @CustID,t.SportType,t.BetType,t.IsLive,0,0,v.PT,SYSDATETIME()
			FROM @SportBettypeFilter t				
				INNER JOIN #ValuePT v ON t.SportType=v.SportType AND t.BetType=v.BetType AND t.IsLive=v.IsLive	
	END

	SET @StartRow=1
	SET @Threshold=2000

	IF(@Site='asiabet88' AND @Currency IN(3,6))
	BEGIN
		IF EXISTS(SELECT 1 FROM #tempMemNoGrouped)
		BEGIN
		
			SET @MaxRow = (SELECT MAX(ID) FROM #tempMemNoGrouped)
		
			IF	@Threshold > @MaxRow
				SET	@Threshold = @MaxRow
		
			SET @StopRow = @Threshold

			WHILE (0 = 0)
			BEGIN				
				UPDATE s
				SET s.AgentPT=v.PT,
					RepUpdateTime = dbo.f_GetDateTime2()
				FROM [Dep_CustPTSetting_Member] s WITH(ROWLOCK)
					INNER JOIN #tempMemNoGrouped c	ON s.CustID=c.CustID
					INNER JOIN @SportBettypeFilter t ON s.SportType=t.SportType AND s.BetType=t.Bettype AND s.IsLive=t.IsLive
					INNER JOIN #ValuePT v ON t.SportType=v.SportType AND t.BetType=v.BetType AND t.IsLive=v.IsLive		
				WHERE ID >= @StartRow AND ID <= @StopRow	
				
				INSERT INTO [dbo].[Dep_CustPTSetting_Member](CustID,[SportType],[BetType],[IsLive],SuperPT,MasterPT,AgentPT,RepUpdateTime)
				SELECT c.CustID,t.SportType,t.BetType,t.IsLive,0,0,v.PT, dbo.f_GetDateTime2()
				FROM #tempMemNoGrouped c		
					CROSS APPLY @SportBettypeFilter t
					INNER JOIN #ValuePT v ON t.SportType=v.SportType AND t.BetType=v.BetType AND t.IsLive=v.IsLive		
				WHERE ID >= @StartRow AND ID <= @StopRow	
					AND NOT EXISTS (SELECT 1 FROM  Dep_CustPTSetting_Member m WITH(NOLOCK) WHERE m.CustID=c.CustID AND m.SportType=t.SportType AND m.BetType=t.Bettype AND m.IsLive=t.IsLive)	
						
				IF	@StopRow = @MaxRow 
					BREAK
					
				SET	@StartRow = @StopRow + 1
					
				SET	@StopRow = @StartRow + @Threshold
					
				IF	@StopRow >= @MaxRow
					SET	@StopRow = @MaxRow
			END
		END
	END
	ELSE
	BEGIN
		IF EXISTS(SELECT 1 FROM #tempMemNoGrouped)
		BEGIN
		
			SET @MaxRow = (SELECT MAX(ID) FROM #tempMemNoGrouped)
		
			IF	@Threshold >= @MaxRow
				SET	@Threshold = @MaxRow
		
			SET @StopRow = @Threshold

			WHILE (0 = 0)
			BEGIN				
				
				UPDATE s
				SET s.AgentPT=v.PT,
					RepUpdateTime = dbo.f_GetDateTime2()
				FROM [Dep_CustPTSetting_Member] s WITH(ROWLOCK)
					INNER JOIN #tempMemNoGrouped c	ON s.CustID=c.CustID
					INNER JOIN @SportBettypeFilter t ON s.SportType=t.SportType AND s.BetType=t.Bettype AND s.IsLive=t.IsLive	
					INNER JOIN #ValuePT v ON t.SportType=v.SportType AND t.BetType=v.BetType AND t.IsLive=v.IsLive							
				WHERE t.IsApplyBA=0
					AND ID >= @StartRow AND ID <= @StopRow	
				
				INSERT INTO [dbo].[Dep_CustPTSetting_Member](CustID,[SportType],[BetType],[IsLive],SuperPT,MasterPT,AgentPT,RepUpdateTime)
				SELECT c.CustID,t.SportType,t.BetType,t.IsLive,0,0,v.PT,dbo.f_GetDateTime2()
				FROM #tempMemNoGrouped c		
					CROSS APPLY @SportBettypeFilter t
					INNER JOIN #ValuePT v ON t.SportType=v.SportType AND t.BetType=v.BetType AND t.IsLive=v.IsLive				
				WHERE ID >= @StartRow AND ID <= @StopRow	
					AND NOT EXISTS (SELECT 1 FROM  Dep_CustPTSetting_Member m WITH(NOLOCK) WHERE m.CustID=c.CustID AND m.SportType=t.SportType AND m.BetType=t.Bettype AND m.IsLive=t.IsLive)	
					AND t.IsApplyBA=0
						
				UPDATE s
				SET s.AgentPT=0,
					RepUpdateTime = dbo.f_GetDateTime2()
				FROM [Dep_CustPTSetting_Member] s WITH(ROWLOCK)
					INNER JOIN Dep_CustBAActive BA ON s.CustID=BA.CustId
					INNER JOIN #tempMemNoGrouped c	ON s.CustID=c.CustID
					INNER JOIN @SportBettypeFilter t ON s.SportType=t.SportType AND s.BetType=t.Bettype AND s.IsLive=t.IsLive
				WHERE ID >= @StartRow AND ID <= @StopRow	
					AND t.IsApplyBA=1						
				
				INSERT INTO [dbo].[Dep_CustPTSetting_Member](CustID,[SportType],[BetType],[IsLive],SuperPT,MasterPT,AgentPT,RepUpdateTime)
				SELECT c.CustID,SportType,BetType,IsLive,0,0,0,dbo.f_GetDateTime2()
				FROM #tempMemNoGrouped c		
					CROSS APPLY @SportBettypeFilter t	
				WHERE ID >= @StartRow AND ID <= @StopRow	
					AND NOT EXISTS (SELECT 1 FROM  Dep_CustPTSetting_Member m WITH(NOLOCK) WHERE m.CustID=c.CustID AND m.SportType=t.SportType AND m.BetType=t.Bettype AND m.IsLive=t.IsLive)	
					AND t.IsApplyBA=1
						
				IF	@StopRow = @MaxRow 
					BREAK
					
				SET	@StartRow = @StopRow + 1
					
				SET	@StopRow = @StartRow + @Threshold
					
				IF	@StopRow >= @MaxRow
					SET	@StopRow = @MaxRow
									
			END
		END	
	END
END	

GO