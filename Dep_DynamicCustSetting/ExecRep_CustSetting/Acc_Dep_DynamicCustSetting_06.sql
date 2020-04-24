/*<info serverAlias="DBCUST-CUSTDB" executers="" viewers="" isFunction="0"></info>*/
USE CustDB
GO

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


		CREATE TABLE #tmpAgent (CustId INT, IsExist BIT)
		CREATE TABLE #tmpMember(CustID INT, Grouped INT, ExistSetting BIT)
		DECLARE @BatchAgent TABLE (CustID INT, IsExist BIT)
		DECLARE @BatchMember TABLE (CustID INT, Grouped INT, ExistSetting BIT)

		SELECT @ProductSettingID = ProductSettingID 
		FROM Dep_ProductSetting WITH(NOLOCK) 
		WHERE ProductID=@ProductID 
			AND SettingType = 9	

		IF @RoleId = 4
		BEGIN
			INSERT INTO #tmpAgent (CustId, IsExist)
			SELECT custid
				,CASE WHEN d.AgentID IS NOT NULL THEN 1 ELSE 0 END
			FROM dbo.Customer c WITH (NOLOCK)
				LEFT JOIN dbo.Dep_CustDiscountGroupSetting_Member d WITH (NOLOCK) ON d.AgentID = c.custid AND d.SportType = @SportType AND d.BetType = @BetType
			WHERE roleid = 2
				AND srecommend = @srecommend
		
			INSERT INTO #tmpMember(CustID, Grouped, ExistSetting)
			SELECT c.CustID
				,CASE 
					WHEN m.CustID IS NOT NULL AND m.IsGroupedComm = 1 THEN 1 --Existing in CustSettingMode and use Agent Comm Setting
					WHEN m.CustID IS NOT NULL AND m.IsGroupedComm = 0 THEN 0 --Existing in CustSettingMode and use Member Comm Setting 
					WHEN m.CustID IS NULL THEN 2 END --Not exist in CustSettingMode
				,CASE WHEN s.CustID IS NOT NULL THEN 1 ELSE 0 END
			FROM dbo.Customer c WITH(NOLOCK)
				LEFT JOIN dbo.Dep_CustSettingMode m WITH(NOLOCK) ON c.custid = m.CustID
				LEFT JOIN dbo.Dep_CustDiscountSetting_Member s WITH(NOLOCK) ON s.CustID = c.CustId AND s.SportType = @SportType AND s.BetType = @BetType
			WHERE c.roleid = 1
				AND srecommend = @srecommend
		END
		ELSE IF @RoleId = 2
		BEGIN
			INSERT INTO #tmpAgent (CustId, IsExist)
			SELECT @CustID, 0
			UPDATE c
				SET c.IsExist = CASE WHEN d.AgentID IS NOT NULL THEN 1 ELSE 0 END 
			FROM #tmpAgent c
				LEFT JOIN dbo.Dep_CustDiscountGroupSetting_Member d WITH (NOLOCK) ON d.AgentID = c.custid AND d.SportType = @SportType AND d.BetType = @BetType

			INSERT INTO #tmpMember(CustID, Grouped, ExistSetting)
			SELECT c.CustID
				,CASE 
					WHEN m.CustID IS NOT NULL AND m.IsGroupedComm = 1 THEN 1 --Existing in CustSettingMode and use Agent Comm Setting
					WHEN m.CustID IS NOT NULL AND m.IsGroupedComm = 0 THEN 0 --Existing in CustSettingMode and use Member Comm Setting 
					WHEN m.CustID IS NULL THEN 2 END --Not exist in CustSettingMode
				,CASE WHEN s.CustID IS NOT NULL THEN 1 ELSE 0 END
			FROM dbo.Customer c WITH(NOLOCK)
				LEFT JOIN dbo.Dep_CustSettingMode m WITH(NOLOCK) ON c.custid = m.CustID
				LEFT JOIN Dep_CustDiscountSetting_Member s WITH(NOLOCK) ON s.CustID = c.CustId AND s.SportType = @SportType AND s.BetType = @BetType
			WHERE c.roleid = 1
				AND recommend = @CustID
		END


		--Insert ProductSetting for Super: Dep_LicenseeProductSetting
		IF NOT EXISTS (SELECT TOP (1) 1 FROM dbo.Dep_LicenseeProductSetting WITH (NOLOCK) WHERE CustID = @srecommend AND ProductSettingID = @ProductSettingID)
		INSERT INTO dbo.Dep_LicenseeProductSetting(CustID, ProductSettingID)
		VALUES(@srecommend, @ProductSettingID)

		-------------------------------------
		---------COMM SETTING----------------
		--Setting GroupComm for Agent - Dep_CustDiscountGroupSetting_Member
		IF EXISTS (SELECT TOP (1) 1 FROM #tmpAgent)
		BEGIN
			WHILE (0 = 0)
			BEGIN
				DELETE TOP (3000) t
				OUTPUT deleted.custid INTO @BatchAgent
				FROM #tmpAgent t

				IF @@ROWCOUNT = 0
				BREAK;

				IF EXISTS (SELECT TOP (1) 1 FROM @BatchAgent WHERE IsExist = 1)
				BEGIN
					UPDATE d
					SET d.PlayerDiscount = 0, d.AgentDiscount = 0, d.MasterDiscount = 0, d.SuperDiscount = 0
					FROM dbo.Dep_CustDiscountGroupSetting_Member d WITH(ROWLOCK)
						INNER JOIN  @BatchAgent c ON c.custid = d.AgentID AND c.IsExist = 1
					WHERE d.SportType = @SportType AND d.BetType = @BetType
				END

				IF EXISTS (SELECT TOP (1) 1 FROM @BatchAgent WHERE IsExist = 0)
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
					SELECT CustId
						,@SportType
						,@BetType
						,0
						,0
						,0
						,0
					FROM @BatchAgent t
					WHERE t.IsExist= 0
				END

				DELETE @BatchAgent
			END

		END

		----------------------------------------------------
		--Setting Comm for Member - Dep_CustDiscountSetting_Member
		IF EXISTS (SELECT TOP (1) 1 FROM #tmpMember)
		BEGIN
			WHILE (0 = 0)
			BEGIN
				DELETE TOP (3000) t
				OUTPUT deleted.custid , deleted.Grouped, deleted.ExistSetting INTO @BatchMember
				FROM #tmpMember t

				IF @@ROWCOUNT = 0
				BREAK;

				--step 1: 
					-- update Dep_CustDiscountSetting_Member: reset = 0  for member Grouped = 0 and ExistSetting = 1
					-- insert Dep_CustDiscountSetting_Member: for member Grouped = 0 AND ExistSetting = 0
				IF EXISTS (SELECT TOP (1) 1 FROM @BatchMember WHERE Grouped = 0 AND ExistSetting = 1)
				BEGIN
					UPDATE d
					SET d.PlayerDiscount = 0, d.AgentDiscount = 0, d.MasterDiscount = 0, d.SuperDiscount = 0
					FROM dbo.Dep_CustDiscountSetting_Member d WITH(ROWLOCK)
						INNER JOIN @BatchMember c ON c.custid = d.CustID AND c.Grouped = 0 AND c.ExistSetting = 1
					WHERE d.SportType = @SportType AND d.BetType = @BetType
				END

				IF EXISTS (SELECT TOP (1) 1 FROM @BatchMember WHERE Grouped = 0 AND ExistSetting = 0)
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
					SELECT CustId
						,@SportType
						,@BetType
						,0
						,0
						,0
						,0
					FROM @BatchMember t
					WHERE t.Grouped = 0
						AND t.ExistSetting = 0
				END

				--step 2:
					-- insert not exists member into Dep_CustSettingMode: Grouped = 2
				IF EXISTS (SELECT TOP (1) 1 FROM @BatchMember WHERE Grouped = 2)
				BEGIN
					INSERT INTO dbo.Dep_CustSettingMode(CustID, IsGroupedComm)
					SELECT CustId, 1			
					FROM @BatchMember t
					WHERE t.Grouped = 2
				END

				DELETE @BatchMember

			END
		END

		DROP TABLE #tmpAgent
		DROP TABLE #tmpMember
	END		
END	

GO