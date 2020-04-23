/*<info serverAlias="DBCUST-CUSTDB" executers="" viewers="" isFunction="0"></info>*/
USE CustDB
GO

ALTER PROCEDURE [dbo].[Acc_Dep_DynamicCustSetting_06]
(
	@CustID			INT 
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
				,@RoleId			INT
				,@srecommend		INT
				,@recommend			INT

		DECLARE @StartRow	INT, 
				@MaxRow		INT,
				@Threshold	INT, 
				@StopRow	INT

		SET @StartRow = 1
		SET @Threshold = 3000

		CREATE TABLE #tmpCust (ID INT IDENTITY (1,1) PRIMARY KEY, CustId INT, RoleId INT)
		CREATE TABLE #tempMemNoGrouped(ID INT IDENTITY (1,1) PRIMARY KEY,CustID INT )
		CREATE TABLE #tempMemGrouped(ID INT IDENTITY (1,1) PRIMARY KEY,CustID INT )

		CREATE NONCLUSTERED INDEX IDX_tmpCust ON #tmpCust(CustID)
		CREATE NONCLUSTERED INDEX IDX_tempMemNoGrouped ON #tempMemNoGrouped(CustID)
		CREATE NONCLUSTERED INDEX IDX_tempMemGrouped ON #tempMemGrouped(CustID)

		SELECT @SettingLevel = SettingLevel
			,@ProductSettingID = ProductSettingID 
		FROM Dep_ProductSetting WITH(NOLOCK) 
		WHERE ProductID=@ProductID 
			AND SettingType = 9	

		SELECT @RoleID = RoleID
			,@srecommend = srecommend
			,@recommend = recommend 
		FROM Customer WITH(NOLOCK) 
		WHERE custid = @CustID
	
		INSERT INTO #tmpCust (CustId, RoleId)
		SELECT custid, roleid
		FROM dbo.Customer WITH (NOLOCK)
		WHERE roleid IN (1,2)
			AND 1 = CASE WHEN @RoleId = 4 AND srecommend = @srecommend THEN 1
					WHEN @RoleId = 2 AND recommend = @recommend THEN 1
				ELSE 0 END

		INSERT INTO #tempMemNoGrouped(CustID)
		SELECT c.CustID
		FROM #tmpCust c WITH(NOLOCK)
			INNER JOIN dbo.Dep_CustSettingMode m WITH(NOLOCK) ON c.custid = m.CustID		
		WHERE c.roleid =1
			AND m.IsGroupedComm = 0

		INSERT INTO #tempMemGrouped (CustID)
		SELECT CustID
		FROM #tmpCust t
		WHERE RoleId = 1
			AND NOT EXISTS (SELECT 1 FROM #tempMemNoGrouped WHERE CustID = t.CustId)

		--Delete member from tmpCusst
		DELETE #tmpCust WHERE RoleId = 1

		--Dep_LicenseeProductSetting
		IF NOT EXISTS (SELECT 1 FROM dbo.Dep_LicenseeProductSetting WITH (NOLOCK) WHERE CustID = @srecommend AND ProductSettingID = @ProductSettingID)
		INSERT INTO dbo.Dep_LicenseeProductSetting(CustID, ProductSettingID)
		VALUES(@srecommend, @ProductSettingID)

		-------------------------------------
		---------COMM SETTING----------------
		--Dep_CustDiscountGroupSetting_Member
		IF EXISTS (SELECT TOP 1 1 FROM #tmpCust)
		BEGIN
			SET @MaxRow = (SELECT MAX(ID) FROM #tmpCust)
			
			IF	@Threshold >= @MaxRow
			SET	@Threshold = @MaxRow
			
			SET @StopRow = @Threshold

			WHILE (0 = 0)
			BEGIN
				UPDATE d
				SET d.PlayerDiscount = 0, d.AgentDiscount = 0, d.MasterDiscount = 0, d.SuperDiscount = 0
				FROM dbo.Dep_CustDiscountGroupSetting_Member d WITH(ROWLOCK)
					INNER JOIN  #tmpCust c ON c.custid = d.AgentID
				WHERE ID >= @StartRow AND ID <= @StopRow


				DELETE t
				FROM #tmpCust t
					INNER JOIN dbo.Dep_CustDiscountGroupSetting_Member s WITH(NOLOCK) ON t.CustID = s.AgentID
				WHERE ID >= @StartRow AND ID <= @StopRow

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
				FROM #tmpCust t
				WHERE ID >= @StartRow AND ID <= @StopRow
					AND t.RoleId = 2
					AND NOT EXISTS (SELECT 1 FROM dbo.Dep_CustDiscountGroupSetting_Member d WITH (NOLOCK) WHERE d.AgentID = t.CustId)

				IF	@StopRow = @MaxRow 
					BREAK
						
				SET	@StartRow = @StopRow + 1
						
				SET	@StopRow = 1 + @StopRow + @Threshold
						
				IF	@StopRow >= @MaxRow
					SET	@StopRow = @MaxRow
			END

		END

		----------------------------------------------------
		--Dep_CustDiscountSetting_Member
		--Not Grouped
		IF EXISTS (SELECT TOP 1 1 FROM #tempMemNoGrouped)
		BEGIN
			SET @StartRow=1
			SET @Threshold=3000

			SET @MaxRow = (SELECT MAX(ID) FROM #tempMemNoGrouped)
			
			IF	@Threshold >= @MaxRow
			SET	@Threshold = @MaxRow
			
			SET @StopRow = @Threshold
	
			WHILE (0=0)
			BEGIN
				UPDATE d
				SET d.PlayerDiscount = 0, d.AgentDiscount = 0, d.MasterDiscount = 0, d.SuperDiscount = 0
				FROM dbo.Dep_CustDiscountSetting_Member d WITH(ROWLOCK)
					INNER JOIN #tempMemNoGrouped c ON c.custid = d.CustID
				WHERE ID >= @StartRow AND ID <= @StopRow

				DELETE t
				FROM #tempMemNoGrouped t
					INNER JOIN dbo.Dep_CustDiscountSetting_Member s WITH(NOLOCK) ON t.CustID=s.CustID
				WHERE ID >= @StartRow AND ID <= @StopRow

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
				FROM #tempMemNoGrouped t
				WHERE ID >= @StartRow AND ID <= @StopRow
					AND NOT EXISTS (SELECT 1 FROM dbo.Dep_CustDiscountSetting_Member d WITH (NOLOCK) WHERE d.CustID = t.CustId)

				IF	@StopRow = @MaxRow 
					BREAK
						
				SET	@StartRow = @StopRow + 1
						
				SET	@StopRow = 1 + @StopRow + @Threshold
						
				IF	@StopRow >= @MaxRow
					SET	@StopRow = @MaxRow
			END
		END

		--Grouped
		IF EXISTS (SELECT TOP 1 1 FROM #tempMemGrouped)
		BEGIN
			SET @StartRow=1
			SET @Threshold=3000

			SET @MaxRow = (SELECT MAX(ID) FROM #tempMemGrouped)
			
			IF	@Threshold >= @MaxRow
			SET	@Threshold = @MaxRow
			
			SET @StopRow = @Threshold
	
			WHILE (0=0)
			BEGIN
				UPDATE d
				SET IsGroupedComm = 1
				FROM dbo.Dep_CustSettingMode d WITH(ROWLOCK)
					INNER JOIN #tempMemGrouped c ON c.custid = d.CustID
				WHERE ID >= @StartRow AND ID <= @StopRow

				DELETE t
				FROM #tempMemGrouped t
					INNER JOIN dbo.Dep_CustSettingMode s WITH(NOLOCK) ON t.CustID=s.CustID
				WHERE ID >= @StartRow AND ID <= @StopRow

				INSERT INTO dbo.Dep_CustSettingMode(
					CustID
					,IsGroupedComm
				)
				SELECT CustId, 1			
				FROM #tempMemGrouped t
				WHERE ID >= @StartRow AND ID <= @StopRow
					AND NOT EXISTS (SELECT 1 FROM dbo.Dep_CustSettingMode d WITH (NOLOCK) WHERE d.CustID = t.CustId) 
		
				IF	@StopRow = @MaxRow 
					BREAK
						
				SET	@StartRow = @StopRow + 1
						
				SET	@StopRow = 1 + @StopRow + @Threshold
						
				IF	@StopRow >= @MaxRow
					SET	@StopRow = @MaxRow
			END
		END

		DROP TABLE #tmpCust
		DROP TABLE #tempMemGrouped
		DROP TABLE #tempMemNoGrouped
	END		
END	

GO