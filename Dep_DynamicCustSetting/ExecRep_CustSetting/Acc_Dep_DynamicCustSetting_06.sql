/*<info serverAlias="DBCUST-CUSTDB" executers="" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_DynamicCustSetting_06]
(
	@CustID			INT
	,@RoleId		INT
	,@srecommend	INT
	,@mrecommend	INT
	,@ProductID		INT 
	,@SportType		INT
	,@BetType		INT
	,@Mode			VARCHAR(50) = 'UpdateComm'
)
AS
/*
	Created: 20200423@Max
	Task : LAP - Support commission for 3rd party products [Redmine: #131774]
	DB:  DBCUST/CustDB
	Original:
	Revision:
		- 20200432@Max: LAP - Support commission for 3rd party products [Redmine: #131774]
		
	Param's Explanation:
*/

BEGIN
	IF(dbo.f_CheckRepTable('Dep_CustDiscountGroupSetting_Member') = 0
		OR dbo.f_CheckRepTable('Dep_CustDiscountSetting_Member') = 0	
		OR dbo.f_CheckRepTable('Dep_LicenseeProductSetting') = 0	
		OR dbo.f_CheckRepTable('Dep_CustSettingMode') = 0	
		OR dbo.f_CheckRepTable('Dep_ProductSetting') = 0	
		OR dbo.f_CheckRepTable('Customer') = 0	
	   )
		RETURN
	
	IF @Mode = 'UpdateComm'
	BEGIN
		DECLARE	@SettingLevel		TINYINT
				,@ProductSettingID	INT

		CREATE TABLE #tmpMember (CustID INT, CustSettingModeType INT, GroupPlayerComm DECIMAL(9,8), GroupAgentComm DECIMAL(9,8), GroupMasterComm DECIMAL(9,8), GroupSuperComm DECIMAL(9,8))
		DECLARE @BatchMember TABLE (CustID INT, CustSettingModeType INT, GroupPlayerComm DECIMAL(9,8), GroupAgentComm DECIMAL(9,8), GroupMasterComm DECIMAL(9,8), GroupSuperComm DECIMAL(9,8))

		SELECT @ProductSettingID = ProductSettingID 
		FROM Dep_ProductSetting WITH(NOLOCK) 
		WHERE ProductID=@ProductID 
			AND SettingType = 9	

		--Only RoleId = 4 or RoleId = 2
		IF @RoleId = 4
		BEGIN
			INSERT INTO #tmpMember(CustID, CustSettingModeType, GroupPlayerComm, GroupAgentComm, GroupMasterComm, GroupSuperComm)
			SELECT c.CustID
				,CASE 
					 WHEN m.IsGroupedComm = 0 AND s.custid IS NOT NULL THEN 1
						--- have nothing in comm seting
						-- case 1: not exists setting mode
					 WHEN  m.custid IS NULL THEN 2
						-- case 2: no setting comm
					 WHEN m.IsGroupedComm = 0 AND s.CustID IS NULL THEN 3 
				END
				,ISNULL(sg.PlayerDiscount, 0)
				,ISNULL(sg.AgentDiscount, 0)
				,ISNULL(sg.MasterDiscount, 0)
				,ISNULL(sg.SuperDiscount, 0)
			FROM dbo.Customer c WITH(NOLOCK)
				LEFT JOIN dbo.Dep_CustSettingMode m WITH(NOLOCK) ON c.custid = m.CustID
				OUTER APPLY (SELECT TOP 1 s_tmp.CustID 
							 FROM Dep_CustDiscountSetting_Member s_tmp WITH(NOLOCK) WHERE s_tmp.CustID = c.CustId) AS s
				LEFT JOIN dbo.Dep_CustDiscountGroupSetting_Member sg WITH (NOLOCK) ON sg.AgentID = c.recommend AND sg.SportType = @SportType AND Sg.BetType = @BetType
			WHERE c.roleid = 1
				AND srecommend = @srecommend
				-- filter valid member to initial setting
				AND (
						-- private setting
						(m.IsGroupedComm = 0 AND s.custid IS NOT NULL)
						--- have nothing in comm seting
						--case 1: not exists setting mode
						OR m.custid IS NULL
						--case 2 no setting comm
						OR (m.IsGroupedComm = 0 AND s.CustID IS NULL)
					)
				AND mrecommend NOT IN (SELECT custid 
								FROM dbo.custinfo WITH(NOLOCK)
								WHERE srecommend=@srecommend 
									AND (username LIKE '%Acc%' OR username LIKE '%LocalBank%' OR username LIKE '%AFF%' OR username LIKE 'AB88'+'CAS%' )
									AND roleid=3
							)
 
		END
		ELSE IF @RoleId = 2
		BEGIN

			INSERT INTO #tmpMember(CustID, CustSettingModeType, GroupPlayerComm, GroupAgentComm, GroupMasterComm, GroupSuperComm)
			SELECT c.CustID
				,CASE 
					 WHEN m.IsGroupedComm = 0 AND s.custid IS NOT NULL THEN 1
						--- have nothing in comm seting
						-- case 1: not exists setting mode
					 WHEN  m.custid IS NULL THEN 2
						-- case 2: no setting comm
					 WHEN m.IsGroupedComm = 0 AND s.CustID IS NULL THEN 3 
				END
				,ISNULL(sg.PlayerDiscount, 0)
				,ISNULL(sg.AgentDiscount, 0)
				,ISNULL(sg.MasterDiscount, 0)
				,ISNULL(sg.SuperDiscount, 0)
			FROM dbo.Customer c WITH(NOLOCK)
				LEFT JOIN dbo.Dep_CustSettingMode m WITH(NOLOCK) ON c.custid = m.CustID
				OUTER APPLY (SELECT TOP 1 s_tmp.CustID 
							 FROM Dep_CustDiscountSetting_Member s_tmp WITH(NOLOCK) WHERE s_tmp.CustID = c.CustId) AS s
				LEFT JOIN dbo.Dep_CustDiscountGroupSetting_Member sg WITH (NOLOCK) ON sg.AgentID = c.recommend AND sg.SportType = @SportType AND Sg.BetType = @BetType
			WHERE c.roleid = 1
				AND recommend = @CustID
				-- filter valid member to initial setting
				AND (
						-- private setting
						(m.IsGroupedComm = 0 AND s.custid IS NOT NULL)
						--- have nothing in comm seting
						-- case 1: not exists setting mode
						OR m.custid IS NULL
						-- case 2: no setting comm
						OR (m.IsGroupedComm = 0 AND s.CustID IS NULL)
					)
				AND mrecommend NOT IN (SELECT custid 
								FROM dbo.custinfo WITH(NOLOCK)
								WHERE srecommend=@srecommend 
									AND (username LIKE '%Acc%' OR username LIKE '%LocalBank%' OR username LIKE '%AFF%' OR username LIKE 'AB88'+'CAS%' )
									AND roleid=3
							)
		END

		--Insert ProductSetting for Super: Dep_LicenseeProductSetting
		IF NOT EXISTS (SELECT TOP (1) 1 FROM dbo.Dep_LicenseeProductSetting WITH (NOLOCK) WHERE CustID = @srecommend AND ProductSettingID = @ProductSettingID)
		INSERT INTO dbo.Dep_LicenseeProductSetting(CustID, ProductSettingID)
		VALUES(@srecommend, @ProductSettingID)

		-------------------------------------
		---------COMM SETTING----------------
		--Setting GroupComm for Agent - Dep_CustDiscountGroupSetting_Member
		IF @RoleId IN (2, 4)
		BEGIN
			IF @RoleId = 2
			BEGIN
				INSERT INTO dbo.Dep_CustDiscountGroupSetting_Member(
						AgentID
						,SportType
						,BetType
						,PlayerDiscount
						,AgentDiscount
						,MasterDiscount
						,SuperDiscount
					)
				SELECT c.CustId
					,@SportType
					,@BetType
					,0
					,0
					,0
					,0
				FROM dbo.Customer c WITH (NOLOCK)
					LEFT JOIN dbo.Dep_CustDiscountGroupSetting_Member d WITH (NOLOCK) ON d.AgentID = c.custid AND d.SportType = @SportType AND d.BetType = @BetType
				WHERE custid = @CustID
					AND d.AgentID IS NULL
					
			END
			
			IF @RoleId = 4
			BEGIN
				INSERT INTO dbo.Dep_CustDiscountGroupSetting_Member(
						AgentID
						,SportType
						,BetType
						,PlayerDiscount
						,AgentDiscount
						,MasterDiscount
						,SuperDiscount
					)
				SELECT c.CustId
					,@SportType
					,@BetType
					,0
					,0
					,0
					,0
				FROM dbo.Customer c WITH (NOLOCK)
					LEFT JOIN dbo.Dep_CustDiscountGroupSetting_Member d WITH (NOLOCK) ON d.AgentID = c.custid AND d.SportType = @SportType AND d.BetType = @BetType
				WHERE roleid = 2
					AND srecommend = @srecommend
					AND d.AgentID IS NULL
			END
			
		END
		----------------------------------------------------
		--Setting Comm for Member - Dep_CustDiscountSetting_Member
		IF EXISTS (SELECT TOP (1) 1 FROM #tmpMember)
		BEGIN
			WHILE (0 = 0)
			BEGIN
				DELETE TOP (3000) t
				OUTPUT deleted.custid , deleted.CustSettingModeType, deleted.GroupPlayerComm, deleted.GroupAgentComm, deleted.GroupMasterComm, deleted.GroupSuperComm INTO @BatchMember
				FROM #tmpMember t

				IF @@ROWCOUNT = 0
				BREAK;

				--step 1: 
					-- insert Dep_CustDiscountSetting_Member: for member IsExistSettingComm = 1
				IF EXISTS (SELECT TOP (1) 1 FROM @BatchMember WHERE CustSettingModeType = 1)
				BEGIN
					INSERT INTO dbo.Dep_CustDiscountSetting_Member(
						CustID
						,SportType
						,BetType
						,PlayerDiscount
						,AgentDiscount
						,MasterDiscount
						,SuperDiscount
					)
					SELECT t.CustId
						,@SportType
						,@BetType
						,0
						,0
						,0
						,0
					FROM @BatchMember t
						LEFT JOIN Dep_CustDiscountSetting_Member cd WITH (NOLOCK) ON t.CustId = cd.CustID AND cd.SportType = @SportType AND cd.BetType = @BetType
					WHERE t.CustSettingModeType = 1
						AND cd.CustID IS NULL
				END

				--step 2:
					-- insert not exists member into Dep_CustSettingMode or isgroupcomm = 1: IsExistSettingComm = 0
				IF EXISTS (SELECT TOP (1) 1 FROM @BatchMember WHERE CustSettingModeType = 2)
				BEGIN
					--Case 1: Value Comm of Group not the same with initial value = 0
					IF EXISTS(SELECT 1
						FROM @BatchMember t
						WHERE (t.GroupPlayerComm <> 0
							OR t.GroupAgentComm <> 0
							OR t.GroupMasterComm <> 0
							OR t.GroupSuperComm <> 0)
						)
					BEGIN
						INSERT INTO dbo.Dep_CustSettingMode(CustID, IsGroupedComm)
						SELECT CustId, 0			
						FROM @BatchMember t
						WHERE t.CustSettingModeType = 2
							AND (t.GroupPlayerComm <> 0
								OR t.GroupAgentComm <> 0
								OR t.GroupMasterComm <> 0
								OR t.GroupSuperComm <> 0)

						INSERT INTO dbo.Dep_CustDiscountSetting_Member(
							CustID
							,SportType
							,BetType
							,PlayerDiscount
							,AgentDiscount
							,MasterDiscount
							,SuperDiscount
						)
						SELECT CustId
							,@SportType
							,@BetType
							,0
							,0
							,0
							,0
						FROM @BatchMember t
						WHERE t.CustSettingModeType = 2
							AND (t.GroupPlayerComm <> 0
								OR t.GroupAgentComm <> 0
								OR t.GroupMasterComm <> 0
								OR t.GroupSuperComm <> 0)
					END

					--Case 2: Value Comm of Group the same with initial value = 0
					IF EXISTS(SELECT 1
						FROM @BatchMember t
						WHERE t.GroupPlayerComm = 0
							AND t.GroupAgentComm = 0
							AND t.GroupMasterComm = 0
							AND t.GroupSuperComm = 0
						)
					BEGIN
							
						INSERT INTO dbo.Dep_CustSettingMode(CustID, IsGroupedComm)
						SELECT CustId, 1			
						FROM @BatchMember t
						WHERE t.CustSettingModeType = 2
							AND t.GroupPlayerComm = 0
							AND t.GroupAgentComm = 0
							AND t.GroupMasterComm = 0
							AND t.GroupSuperComm = 0
					END
					
				END
				
				IF EXISTS (SELECT TOP (1) 1 FROM @BatchMember WHERE CustSettingModeType = 3)
				BEGIN
					UPDATE m 
						SET IsGroupedComm = 1	
					FROM dbo.Dep_CustSettingMode m		
						INNER JOIN @BatchMember t ON m.CustID = t.CustID
					WHERE t.CustSettingModeType = 3
					
				END
				
				DELETE @BatchMember

			END
		END
		DROP TABLE #tmpMember
	END		
END	
GO


