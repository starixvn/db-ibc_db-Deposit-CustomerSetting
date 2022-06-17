/*<info serverAlias="DBCUST-CUSTDB" executers="" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_DynamicCustSetting_00] 
	@CustID				INT
	, @SuperID			INT = NULL
	, @MasterID			INT = NULL
	, @AgentID			INT = NULL
	, @RoleID			TINYINT = 4
	, @ProductID		TINYINT = NULL
	, @ProductProfileList VARCHAR(200) = ''
	, @SuperPT SMALLINT = 93
	, @MasterPT SMALLINT = 0
	, @AgentPT SMALLINT = 0
	, @IsDisable BIT = 0
	, @IsHidden BIT = 0
	, @success BIT = 1 OUTPUT
	, @Language VARCHAR(2)= 'E'
	, @ErrCode INT = 0 OUTPUT
AS
/*
	Created: 20160405@Helen
	Task : Insert Settings Into DCS Structure - [Redmine: 55057]
	DB:  DBCUST/CustDB
	Original:
	Revisions:
		- 20170104@Helen: insert Allbet Setting (stake level) of new member into the DCS database after 1st deposit. [Redmine: #55057]
		- 20170302@Helen: Betradar Virtual Sports  -Integration for Cash [Redmine: 77274]
		- 20171025@Johnson: offer Allbet commision for member level only[Redmine: #82036]
		- 20180522@Elodie: Fix code to insert PT, Commission setting group [Redmine: #95626]
		- 20180927@Winnie: Remove AllBet [RedmineID: #99378]
		- 20181113@Winnie: Esports  - Integration [RedmineID: #100721]
		- 20200410@Johnson: Add comm for AB,Macau,PP,GD,AG [redmine:#131774] 
		- 20220218@Winfred: LG VS3  - Licensee DCS setting for new BetLimit  [Redmine: 168395]	
		- 20220614@Eden: DBCUST - modify sp syntax to adapt with the SQL Server upgrade to 2019 [Redmine: #171831] 
	*/
BEGIN
	SELECT @ErrCode = 0
		
	IF(dbo.f_CheckRepTable('Dep_CustSettingMode') = 0
		OR dbo.f_CheckRepTable('Dep_CustPTSetting_Member') = 0
		OR dbo.f_CheckRepTable('Dep_CustPTSetting_Agent') = 0
		OR dbo.f_CheckRepTable('Dep_CustPTGroupSetting_Member') = 0
		
		OR dbo.f_CheckRepTable('Dep_ProductSetting') = 0
		OR dbo.f_CheckRepTable('Dep_ProductSettingDetail') = 0
		OR dbo.f_CheckRepTable('Dep_LicenseeProductSetting') = 0 
		
		OR dbo.f_CheckRepTable('Dep_ProductStatusProfile') = 0 
		OR dbo.f_CheckRepTable('Dep_CustProductStatus') = 0 
	
		OR dbo.f_CheckRepTable('GameGroup') = 0
		OR dbo.f_CheckRepTable('Dep_StakeLevel') = 0
		OR dbo.f_CheckRepTable('Dep_CustStakeLevel_Agent') = 0 
		OR dbo.f_CheckRepTable('Dep_CustStakeLevel_Member') = 0 
		
		OR dbo.f_CheckRepTable('Dep_CustBetSetting_Agent') = 0 
		OR dbo.f_CheckRepTable('Dep_CustBetSetting_Member') = 0 
		OR dbo.f_CheckRepTable('Dep_CustBetLimit_Special') = 0 
		
		OR dbo.f_CheckRepTable('Dep_CustDiscountSetting_Member') = 0 
		OR dbo.f_CheckRepTable('Dep_CustDiscountGroupSetting_Member') = 0 

	   )
		RETURN
		
	CREATE TABLE #ProductSettingDetail(
		[SettingType] [smallint] NOT NULL,
		[SportType] [smallint] NOT NULL,
		[BetType] [smallint] NOT NULL,
		[IsLive] BIT NOT NULL
		
	)

	CREATE TABLE #tmpDep_CustBetLimit_Special(Sporttype INT,Bettype INT,MaxBet MONEY,MaxPerMatch MONEY)
	CREATE TABLE #tmpDep_CustNewBetLimit_Special(Sporttype INT,Bettype INT,MaxBet MONEY)
	
	IF @RoleID = 4
	BEGIN
		IF @ProductID IS NULL AND @ProductProfileList = '' -- ALL DCS PRODUCT
		BEGIN
			INSERT INTO Dep_LicenseeProductSetting (CustID,ProductSettingID)
			SELECT @CustID,ps.ProductSettingID
			FROM dbo.Dep_ProductSetting ps WITH (NOLOCK)
		END
		ELSE
		BEGIN
			INSERT INTO Dep_LicenseeProductSetting (CustID,ProductSettingID)
			SELECT @CustID, t.value
			FROM STRING_SPLIT(@ProductProfileList,',') t
			WHERE t.value <> ''
		END 
		
	END
	
	INSERT INTO #ProductSettingDetail (SettingType,SportType,BetType,IsLive)
	SELECT ps.SettingType,psd.SportType,psd.BetType,psd.IsLive
	FROM Dep_LicenseeProductSetting lds WITH (NOLOCK)
		INNER JOIN Dep_ProductSetting ps WITH (NOLOCK) ON lds.ProductSettingID = PS.ProductSettingID
		INNER JOIN Dep_ProductSettingDetail psd WITH (NOLOCK) ON psd.ProductSettingID = ps.ProductSettingID
	WHERE lds.CustID =@SuperID AND (@ProductID IS NULL OR ps.ProductID = @ProductID)
	     
	/********************************************* Position Taking: SettingType = 1 ***********************************/
	IF EXISTS (SELECT 1 FROM #ProductSettingDetail WHERE SettingType = 1)
	BEGIN
		BEGIN TRY
			IF @RoleID = 4
			BEGIN
				IF (@SuperPT < 0 OR @SuperPT > 100 OR @MasterPT > @SuperPT OR @AgentPT > @SuperPT OR @AgentPT > @MasterPT)	
				BEGIN
					SET @ErrCode = 1
					RETURN
				END
				ELSE
				BEGIN	
					INSERT INTO [dbo].[Dep_CustPTSetting_Agent]
					   ([CustID]
					   ,[SportType]
					   ,[BetType]
					   ,[IsLive]
					   ,[SuperPT]
					   ,[MasterPT]
					   ,[AgentPT]
					  )
					SELECT 
						@CustID
						,dtl.SportType
						,dtl.BetType
						,dtl.IsLive
						,@SuperPT,@SuperPT,@SuperPT
					FROM #ProductSettingDetail dtl WITH (NOLOCK)
					WHERE dtl.SettingType = 1 
						
				END		
			END
			ELSE IF @RoleID = 3
			BEGIN
				
				INSERT INTO [dbo].[Dep_CustPTSetting_Agent]
				   ([CustID]
				   ,[SportType]
				   ,[BetType]
				   ,[IsLive]
				   ,[SuperPT]
				   ,[MasterPT]
				   ,[AgentPT]
				   )
				SELECT 
					@CustID
					,SportType
					,BetType
					,IsLive
					,0,SuperPT,0
				FROM Dep_CustPTSetting_Agent  (NOLOCK)
				WHERE CustID = @SuperID 
				
			END
			ELSE IF @RoleID = 2
			BEGIN
				INSERT INTO [dbo].[Dep_CustPTSetting_Agent]
					   ([CustID]
					   ,[SportType]
					   ,[BetType]
					   ,[IsLive]
					   ,[SuperPT]
					   ,[MasterPT]
					   ,[AgentPT]
					   )
				SELECT @custid,SportType,BetType
						,IsLive
						,0,0,MasterPT
				FROM Dep_CustPTSetting_Agent WITH (NOLOCK) 
				WHERE custid = @MasterID
					
			END
			ELSE
			BEGIN --RoleID = 1
				--If this is the first member,insert into Group Setting
				INSERT INTO [dbo].[Dep_CustPTGroupSetting_Member]
				   ([AgentID]
				   ,[SportType]
				   ,[BetType]
				   ,[IsLive]
				   ,[SuperPT]
				   ,[MasterPT]
				   ,[AgentPT]
				   )
				SELECT @AgentID,acs.SportType,acs.BetType,acs.IsLive,
					   0,0,acs.AgentPT
				FROM dbo.Dep_CustPTSetting_Agent acs WITH (NOLOCK)
				WHERE acs.custid = @AgentID
					AND NOT EXISTS (SELECT TOP 1 1 FROM dbo.Dep_CustPTGroupSetting_Member WITH (NOLOCK) WHERE AgentID = @AgentID AND SportType = acs.SportType AND BetType = acs.BetType)
			
				IF EXISTS(SELECT TOP 1 1
							FROM dbo.Dep_CustPTGroupSetting_Member grp WITH (NOLOCK)
								INNER JOIN Dep_CustPTSetting_Agent pta WITH (NOLOCK) ON grp.SportType = pta.SportType 
																			AND grp.BetType = pta.BetType AND pta.CustID = grp.AgentID
							WHERE grp.AgentID = @AgentID 
								AND (
									pta.SuperPT <> grp.SuperPT
									OR
									pta.MasterPT <> grp.MasterPT
									OR
									pta.AgentPT <> grp.AgentPT
								))
						
				BEGIN
					--If this member's PT setting are diffrent from Group PT Setting
					INSERT INTO [dbo].[Dep_CustPTSetting_Member]
							([CustID]
							,[SportType]
							,[BetType]
							,[IsLive]
							,[SuperPT]
							,[MasterPT]
							,[AgentPT]
							)
					SELECT @CustID,pta.SportType,pta.BetType,IsLive,
						0,0,pta.AgentPT
					FROM Dep_CustPTSetting_Agent pta WITH (NOLOCK)
					WHERE pta.CustID = @AgentID
					
					INSERT INTO dbo.Dep_CustSettingMode(CustID,IsGroupedPT)
					SELECT @CustID,0
				END
				ELSE
				BEGIN
					INSERT INTO dbo.Dep_CustSettingMode(CustID,IsGroupedPT)
					SELECT @CustID,1
				END
			END
		END TRY
		BEGIN CATCH
			SELECT @ErrCode = 1
			
			IF @RoleID = 1
			BEGIN
				DELETE FROM Dep_CustPTSetting_Member WHERE CustID = @CustID
				DELETE FROM Dep_CustSettingMode WHERE CustID = @CustID
			END
			ELSE --SMA
			BEGIN
				DELETE FROM Dep_CustPTSetting_Agent WHERE CustID = @CustID
			END
			
			RETURN
			
		END CATCH
		
	END
	
	
	/********************************************* Product Status: SettingType = 4 ************************************/
	--Get sporttype/Bettype for this setting type	
	SELECT DISTINCT psd.SportType,psd.Bettype, psd.SettingType,@IsDisable AS IsDisabled,@IsHidden AS IsHidden,pbs.bitmapOrder 
	INTO #SportBettypeFilter4
	FROM #ProductSettingDetail psd WITH(NOLOCK)  
		INNER JOIN Dep_ProductStatusProfile pbs WITH (NOLOCK) ON pbs.[SportType] = psd.[SportType] AND pbs.[BetType] = psd.[BetType]
	WHERE psd.SettingType = 4
	
	--Get from Super
	--Enable/Disable: upline status
	DECLARE @UplineID INT
	IF @RoleID = 3
		SET @UplineID = @SuperID
	ELSE IF @RoleID = 2
		SET @UplineID = @MasterID
	ELSE IF @RoleID = 1
		SET @UplineID = @AgentID		
					
	IF EXISTS (SELECT 1 FROM #SportBettypeFilter4)	
	BEGIN
		BEGIN TRY
			IF @RoleID = 4 
			BEGIN
				IF EXISTS(SELECT TOP 1 1 FROM #SportBettypeFilter4)
				BEGIN
									
					DECLARE @xmlStrDisabled XML
					DECLARE @xmlStrHidden XML
				
					SET @xmlStrDisabled = (
							SELECT (
									SELECT ft.bitmapOrder	AS '@b'
										, ft.IsDisabled	AS '@s'
									FROM #SportBettypeFilter4 ft 	
									FOR XML PATH('r')
										, TYPE
									)
							FOR XML PATH('root')
								, TYPE
							)
						
					SET @xmlStrHidden = (
							SELECT (
									SELECT ft.bitmapOrder	AS '@b'
										, ft.IsHidden	AS '@s'
									FROM #SportBettypeFilter4 ft 	
									FOR XML PATH('r')
										, TYPE
									)
							FOR XML PATH('root')
								, TYPE
							)
						
				END
			
				INSERT INTO [dbo].[Dep_CustProductStatus]([CustID],bitmapIsDisabled,bitmapIsHidden)
				SELECT	@CustID
						, (select bitmap from dbo.f_GenerateProductStatus_multiple (0, CONVERT(VARCHAR(MAX),@xmlStrDisabled)))	
						, (select bitmap from dbo.f_GenerateProductStatus_multiple (0, CONVERT(VARCHAR(MAX),@xmlStrHidden)))
		
			END
			ELSE IF @RoleID IN (3,2,1)
			BEGIN
				INSERT INTO [dbo].[Dep_CustProductStatus]([CustID],bitmapIsDisabled,bitmapIsHidden)
				SELECT @CustID, cs.bitmapIsDisabled,cs.bitmapIsHidden
				FROM [dbo].[Dep_CustProductStatus] cs WITH (NOLOCK)
				WHERE cs.CustID = @UplineID
				
			END
			
		END TRY
		BEGIN CATCH
			SELECT @ErrCode = 4

			IF @RoleID = 1
			BEGIN
				DELETE FROM Dep_CustPTSetting_Member WHERE CustID = @CustID
				DELETE FROM Dep_CustSettingMode WHERE CustID = @CustID
			END
			ELSE --SMA
			BEGIN
				DELETE FROM Dep_CustPTSetting_Agent WHERE CustID = @CustID
			END
		
			DELETE FROM Dep_CustProductStatus WHERE CustID = @CustID
		
			RETURN
		END CATCH
	END

	/********************************************* StakeLevelGroup: SettingType = 8 ***********************************/
	DECLARE @currency INT, @Site  VARCHAR(10)
	
	SELECT @currency = currency, @Site = Site 
	FROM Customer WITH (NOLOCK) 
	WHERE custid= @SuperID
	
	IF EXISTS (SELECT 1 FROM #ProductSettingDetail WHERE SettingType = 8)
	BEGIN
		BEGIN TRY
			IF @RoleID = 4
			BEGIN
				INSERT INTO Dep_CustStakeLevel_Agent (CustID,SportType,BetType,StakeLevelList)
				SELECT @CustID,T.SportType,t.BetType AS Bettype, STUFF(T1.StakeLevelList,1,1,'') AS StakeLevelListID
				FROM #ProductSettingDetail T
					CROSS APPLY ( SELECT ',' + CONVERT(VARCHAR(20),sl.StakeLevelID)
									FROM GameGroup G (NOLOCK) 
										INNER JOIN Dep_StakeLevel SL (NOLOCK) ON SL.GameGroupID = G.GameGroupID AND sl.ExchangeID = @currency
								WHERE T.SportType = G.RefSportType AND SL.GameTypeID = T.BetType AND g.IsDeposit = 1
								FOR XML PATH('')
								) AS T1 (StakeLevelList)
				WHERE T.SettingType = 8 
			
			END
			ELSE IF @RoleID IN (2,3)
			BEGIN
				INSERT INTO Dep_CustStakeLevel_Agent (CustID,SportType,BetType,StakeLevelList)
				SELECT @CustID,CS.SportType,CS.BetType,StakeLevelList
				FROM Dep_CustStakeLevel_Agent CS WITH (NOLOCK)
					INNER JOIN #ProductSettingDetail T ON CS.SportType = T.SportType AND CS.BetType = T.BetType AND T.SettingType = 8
				WHERE CustID = @UplineID
			END
			ELSE IF @RoleID = 1
			BEGIN
				INSERT INTO Dep_CustStakeLevel_member (CustID,SportType,BetType,StakeLevelList)
				SELECT @CustID,T.SportType,T.BetType,temp.list
				FROM #ProductSettingDetail T
					CROSS APPLY (SELECT TOP 1 ss.value list
								FROM	dbo.Dep_CustStakeLevel_Agent AS csla WITH (NOLOCK)
									CROSS APPLY	STRING_SPLIT(csla.StakeLevelList, ',') AS ss
									INNER JOIN Dep_StakeLevel sl WITH (NOLOCK) ON ss.value = sl.StakeLevelID  
								WHERE	csla.CustID = @UplineID
										AND csla.SportType = T.SportType
										AND csla.BetType = T.betType
								ORDER BY sl.MaxStake, sl.MinStake, SL.GameGroupID	
								) AS Temp
				WHERE t.SettingType = 8
				
			END	
		
		END TRY
		BEGIN CATCH
			SELECT @ErrCode = 8
			IF @RoleID = 1
			BEGIN
				DELETE FROM Dep_CustPTSetting_Member WHERE CustID = @CustID
				DELETE FROM Dep_CustSettingMode WHERE CustID = @CustID
				DELETE FROM Dep_CustStakeLevel_member WHERE CustID = @CustID
			END
			ELSE --SMA
			BEGIN
				DELETE FROM Dep_CustPTSetting_Agent WHERE CustID = @CustID
				DELETE FROM Dep_CustStakeLevel_Agent WHERE CustID = @CustID
			END
		
			DELETE FROM Dep_CustProductStatus WHERE CustID = @CustID
			
			RETURN
		END CATCH	
	END
	
	/********************************************* StakeLevel: SettingType = 7 ***********************************/
	
	IF EXISTS (SELECT 1 FROM #ProductSettingDetail WHERE SettingType = 7)
	BEGIN
		BEGIN TRY
			IF @RoleID = 4
			BEGIN
				INSERT INTO Dep_CustStakeLevel_Agent (CustID,SportType,BetType,StakeLevelList)
				SELECT @CustID,T.SportType,t.BetType AS Bettype, STUFF(T1.StakeLevelList,1,1,'') AS StakeLevelListID
				FROM #ProductSettingDetail T
					CROSS APPLY ( SELECT ',' + CONVERT(VARCHAR(20),sl.StakeLevelID)
								  FROM Dep_StakeLevel SL (NOLOCK) 
								WHERE SL.GameTypeID = T.BetType 
										AND sl.ExchangeID = @currency
								FOR XML PATH('')
								) AS T1 (StakeLevelList)
				WHERE T.SettingType = 7 
			
			END
			ELSE IF @RoleID IN (2,3)
			BEGIN
				INSERT INTO Dep_CustStakeLevel_Agent (CustID,SportType,BetType,StakeLevelList)
				SELECT @CustID,CS.SportType,CS.BetType,StakeLevelList
				FROM Dep_CustStakeLevel_Agent CS WITH (NOLOCK)
					INNER JOIN #ProductSettingDetail T ON CS.SportType = T.SportType AND CS.BetType = T.BetType AND T.SettingType = 7
				WHERE CustID = @UplineID
			END
			ELSE IF @RoleID = 1
			BEGIN
				INSERT INTO Dep_CustStakeLevel_member (CustID,SportType,BetType,StakeLevelList)
				SELECT @CustID,T.SportType,T.BetType,temp.list
				FROM #ProductSettingDetail T
					CROSS APPLY (SELECT TOP 1 ss.value list
								FROM	dbo.Dep_CustStakeLevel_Agent AS csla WITH (NOLOCK)
									CROSS APPLY	STRING_SPLIT(csla.StakeLevelList, ',') AS ss
									INNER JOIN Dep_StakeLevel sl WITH (NOLOCK) ON ss.value = sl.StakeLevelID  
								WHERE	csla.CustID = @UplineID AND csla.SportType = T.SportType AND csla.BetType = T.betType
								
								ORDER BY sl.MaxStake, sl.MinStake
								) AS Temp
				WHERE t.SettingType = 7
				
			END	
		
		END TRY
		BEGIN CATCH
			SELECT @ErrCode = 9
			IF @RoleID = 1
			BEGIN
				DELETE FROM Dep_CustPTSetting_Member WHERE CustID = @CustID
				DELETE FROM Dep_CustSettingMode WHERE CustID = @CustID
				DELETE FROM Dep_CustStakeLevel_member WHERE CustID = @CustID
			END
			ELSE --SMA
			BEGIN
				DELETE FROM Dep_CustPTSetting_Agent WHERE CustID = @CustID
				DELETE FROM Dep_CustStakeLevel_Agent WHERE CustID = @CustID
			END
		
			DELETE FROM Dep_CustProductStatus WHERE CustID = @CustID
			
			RETURN
		END CATCH	
	END	
	
	
	/********************************************* Betting Limit: SettingType = 2 ***********************************/
	IF EXISTS (SELECT 1 FROM #ProductSettingDetail WHERE SettingType = 2)
	BEGIN
		BEGIN TRY
			IF @RoleID = 1 -- RoleID = 1
			BEGIN	
				
				INSERT INTO #tmpDep_CustBetLimit_Special(Sporttype ,Bettype ,MaxBet ,MaxPerMatch)
				SELECT DISTINCT s.Sporttype ,s.Bettype ,MaxBet ,MaxPerMatch
				FROM Dep_CustBetLimit_Special smcs WITH(NOLOCK)
					INNER JOIN #ProductSettingDetail s ON s.SportType = smcs.SportType AND ((CASE WHEN S.SportType IN (180,181,182,183,184,185,186) THEN 1 ELSE S.Bettype END)  = smcs.BetType) AND S.SettingType = 2
				WHERE AgentID=@AgentID AND Site=@site AND CurrencyID=@currency

				INSERT INTO #tmpDep_CustBetLimit_Special(Sporttype ,Bettype ,MaxBet ,MaxPerMatch)
				SELECT DISTINCT s.Sporttype ,s.Bettype ,MaxBet ,MaxPerMatch
				FROM Dep_CustBetLimit_Special smcs WITH(NOLOCK)
					INNER JOIN #ProductSettingDetail s ON s.SportType = smcs.SportType AND ((CASE WHEN S.SportType IN (180,181,182,183,184,185,186) THEN 1 ELSE S.Bettype END)  = smcs.BetType) AND S.SettingType = 2
				WHERE AgentID IS NULL AND NOT EXISTS(SELECT 1 FROM #tmpDep_CustBetLimit_Special a WITH(NOLOCK) WHERE a.SportType=smcs.SportType AND ((CASE WHEN a.SportType IN (180,181,182,183,184,185,186) THEN 1 ELSE a.Bettype END)  = smcs.BetType))
				 AND Site=@site AND CurrencyID=@currency
	 		
				INSERT INTO [dbo].[Dep_CustBetSetting_Member]
					([CustID]
					,[SportType]
					,[BetType]
					,[MinBet]
					,[MaxBet]
					,[MaxPerMatch])
					   	
				SELECT @CustID, smcs.SportType,smcs.BetType,
							smcs.MinBet,
							ISNULL(t.MaxBet,smcs.MaxBet),
							ISNULL(t.MaxPerMatch,smcs.MaxPerMatch)
				FROM dbo.Dep_CustBetSetting_Agent smcs WITH (NOLOCK)
					INNER JOIN #ProductSettingDetail s ON s.SportType = smcs.SportType AND s.Bettype = smcs.BetType AND S.SettingType = 2
					LEFT JOIN #tmpDep_CustBetLimit_Special t ON smcs.SportType=t.Sporttype AND smcs.BetType=t.Bettype
				WHERE smcs.custid = @AgentID	
			END
		END TRY
		BEGIN CATCH
			SELECT @ErrCode = 2
			IF @RoleID = 1
			BEGIN
				DELETE FROM Dep_CustPTSetting_Member WHERE CustID = @CustID
				DELETE FROM Dep_CustSettingMode WHERE CustID = @CustID
				DELETE FROM Dep_CustStakeLevel_member WHERE CustID = @CustID
				DELETE FROM Dep_CustBetSetting_Member WHERE CustID = @CustID
				
				
			END
			ELSE --SMA
			BEGIN
				DELETE FROM Dep_CustPTSetting_Agent WHERE CustID = @CustID
				DELETE FROM Dep_CustStakeLevel_Agent WHERE CustID = @CustID
				DELETE FROM Dep_CustBetSetting_Agent WHERE CustID = @CustID
			END
		
			DELETE FROM Dep_CustProductStatus WHERE CustID = @CustID
			
			RETURN
			
		END CATCH
	END	
	/********************************************* Betting Limit: SettingType =11 ***********************************/
	IF EXISTS (SELECT 1 FROM #ProductSettingDetail WHERE SettingType = 11)
	BEGIN
		BEGIN TRY
			IF @RoleID = 1 -- RoleID = 1
			BEGIN	
				
				INSERT INTO #tmpDep_CustNewBetLimit_Special(Sporttype ,Bettype ,MaxBet )
				SELECT DISTINCT s.Sporttype ,s.Bettype ,MaxBet 
				FROM Dep_CustBetLimit_Special smcs WITH(NOLOCK)
					INNER JOIN #ProductSettingDetail s ON s.SportType = smcs.SportType AND (S.Bettype  = smcs.BetType) AND S.SettingType = 11
				WHERE AgentID=@AgentID AND Site=@site AND CurrencyID=@currency

				INSERT INTO #tmpDep_CustNewBetLimit_Special(Sporttype ,Bettype ,MaxBet )
				SELECT DISTINCT s.Sporttype ,s.Bettype ,MaxBet 
				FROM Dep_CustBetLimit_Special smcs WITH(NOLOCK)
					INNER JOIN #ProductSettingDetail s ON s.SportType = smcs.SportType AND (S.Bettype  = smcs.BetType) AND S.SettingType = 11
				WHERE AgentID IS NULL AND NOT EXISTS(SELECT 1 FROM #tmpDep_CustNewBetLimit_Special a WITH(NOLOCK) WHERE a.SportType=smcs.SportType AND (a.Bettype  = smcs.BetType))
				 AND Site=@site AND CurrencyID=@currency
	 		
				INSERT INTO [dbo].[Dep_CustBetSetting_Member]
					([CustID]
					,[SportType]
					,[BetType]
					,[MinBet]
					,[MaxBet])
					   	
				SELECT @CustID, smcs.SportType,smcs.BetType,
							smcs.MinBet,
							ISNULL(t.MaxBet,smcs.MaxBet)
				FROM dbo.Dep_CustBetSetting_Agent smcs WITH (NOLOCK)
					INNER JOIN #ProductSettingDetail s ON s.SportType = smcs.SportType AND s.Bettype = smcs.BetType AND S.SettingType = 11
					LEFT JOIN #tmpDep_CustNewBetLimit_Special t ON smcs.SportType=t.Sporttype AND smcs.BetType=t.Bettype
				WHERE smcs.custid = @AgentID	
			END
		END TRY
		BEGIN CATCH
			SELECT @ErrCode = 2
			IF @RoleID = 1
			BEGIN
				DELETE FROM Dep_CustPTSetting_Member WHERE CustID = @CustID
				DELETE FROM Dep_CustSettingMode WHERE CustID = @CustID
				DELETE FROM Dep_CustStakeLevel_member WHERE CustID = @CustID
				DELETE FROM Dep_CustBetSetting_Member WHERE CustID = @CustID
				
				
			END
			ELSE --SMA
			BEGIN
				DELETE FROM Dep_CustPTSetting_Agent WHERE CustID = @CustID
				DELETE FROM Dep_CustStakeLevel_Agent WHERE CustID = @CustID
				DELETE FROM Dep_CustBetSetting_Agent WHERE CustID = @CustID
			END
		
			DELETE FROM Dep_CustProductStatus WHERE CustID = @CustID
			
			RETURN
			
		END CATCH
	END	
	
	/********************************************* Commission : SettingType = 9 ***********************************/
	IF EXISTS (SELECT 1 FROM #ProductSettingDetail WHERE SettingType = 9)
	BEGIN
		IF @Roleid = 1
		BEGIN TRY
			--1st member under this line
			INSERT INTO dbo.Dep_CustDiscountGroupSetting_Member(
				AgentID
				,SportType
				,BetType
				,PlayerDiscount
				,AgentDiscount
				,MasterDiscount
				,SuperDiscount
			)
			SELECT @AgentID
				,sporttype
				,betType
				,0
				,0
				,0
				,0
			FROM #ProductSettingDetail ps
			WHERE SettingType=9	
				AND NOT EXISTS (SELECT TOP 1 1 FROM dbo.Dep_CustDiscountGroupSetting_Member WITH (NOLOCK) WHERE AgentID = @AgentID AND SportType = ps.SportType AND BetType = ps.BetType)
				
			--check customer has same setting with group or not 
			IF EXISTS(SELECT 1 
				FROM dbo.Dep_CustDiscountGroupSetting_Member cs WITH(NOLOCK) 
					INNER JOIN (SELECT sporttype,betType,playerDiscount,AgentDiscount,MasterDiscount,SuperDiscount
								FROM #ProductSettingDetail
								CROSS APPLY (SELECT 0 AS PlayerDiscount,
													0 AS AgentDiscount,
													0 AS MasterDiscount,
													0 AS SuperDiscount
											)s 
								WHERE settingType = 9			
								)t ON cs.sporttype= t.sporttype
									AND cs.betType= t.betType
				WHERE cs.AgentID = @AgentID 
					AND (cs.PlayerDiscount <> t.PlayerDiscount
					OR cs.AgentDiscount <> t.AgentDiscount
					OR cs.MasterDiscount <> t.MasterDiscount
					OR cs.SuperDiscount <> t.SuperDiscount)
					)
			BEGIN
				--insert individual settings
				INSERT INTO dbo.Dep_CustDiscountSetting_Member(
					CustID
					,SportType
					,BetType
					,PlayerDiscount
					,AgentDiscount
					,MasterDiscount
					,SuperDiscount
				)
				SELECT @CustID
					,sporttype
					,betType
					,0
					,0
					,0
					,0
				FROM #ProductSettingDetail
				WHERE SettingType=9	
					
				IF EXISTS(SELECT 1 FROM dbo.Dep_CustSettingMode WITH(NOLOCK) WHERE custID = @CustID)
				BEGIN
					UPDATE dbo.Dep_CustSettingMode WITH(UPDLOCK,ROWLOCK)
					SET isGroupedComm = 0
					WHERE CustID = @CustID AND isGroupedComm <> 0
				END
				ELSE
				BEGIN
					INSERT INTO dbo.Dep_CustSettingMode(CustID,IsGroupedComm)
					SELECT @CustID,0
				END
			END
			ELSE 
			--use group setting
			BEGIN
				IF EXISTS(SELECT 1 FROM dbo.Dep_CustSettingMode WITH(NOLOCK) WHERE custID = @CustID)
				BEGIN
					UPDATE dbo.Dep_CustSettingMode WITH(UPDLOCK,ROWLOCK)
					SET isGroupedComm = 1
					WHERE CustID = @CustID AND isGroupedComm = 0
				END
				ELSE
				BEGIN
					INSERT INTO dbo.Dep_CustSettingMode(CustID,IsGroupedComm)
					SELECT @CustID,1
				END
			END	
		END TRY
		BEGIN CATCH
			SELECT @ErrCode = 9
			IF @RoleID = 1
			BEGIN
				DELETE FROM Dep_CustPTSetting_Member WHERE CustID = @CustID
				DELETE FROM Dep_CustSettingMode WHERE CustID = @CustID
				DELETE FROM Dep_CustStakeLevel_member WHERE CustID = @CustID
				DELETE FROM Dep_CustBetSetting_Member WHERE CustID = @CustID
				DELETE FROM Dep_CustDiscountSetting_Member WHERE CustID = @CustID			
			END
		END CATCH
	END
	
	DROP TABLE #SportBettypeFilter4
	DROP TABLE #ProductSettingDetail
END

GO

