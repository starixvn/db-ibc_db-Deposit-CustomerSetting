/*<info serverAlias="DBCUST-CUSTDB" executers="" viewers="vnteam" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_CustSetting_StatusDownlineUpd]
@ActionID				TINYINT =0
,@CustID				INT
,@bitmapOrder			TINYINT
,@IsDisabled			BIT =1
,@IsDisabledDownline	BIT =1
AS
/*
	Created: 20240710@Johnson
	Task : Insert Status Settings for Downlines
	DB:  DBCUST/CustDB
	Original: Acc_Dep_DynamicCustSetting_03
	
	Revision
		- 20240710@Johnson: Apply In-house Replication for Deposit Customer Setting [redmine:#207025]
	Param's Explanation:
	@Action=1: Update by super
	@Action=0: Insert by super
	@Action=2: Insert/update by agent
	*/

BEGIN
	CREATE TABLE #tempCust (ID INT IDENTITY (1,1) PRIMARY KEY,CustID INT ,RoleID INT,mrecommend INT)	
	CREATE NONCLUSTERED INDEX IDX_tempCust ON #tempCust(CustID)	

	CREATE TABLE #tblmrecommend  (CustID INT PRIMARY KEY)	
	DECLARE @StartRow	INT, 
			@MaxRow		INT,
			@Threshold	INT, 
			@StopRow INT			
	SET @StartRow=1
	SET @Threshold=2000
					
	IF @ActionID=1
	BEGIN	
		INSERT INTO #tblmrecommend(CustID)
		SELECT custid FROM custinfo WITH (NOLOCK) WHERE roleid=3
		and username LIKE '%Acc%' and srecommend=@CustID		

		INSERT INTO #tempCust(CustID,RoleID,mrecommend )
		SELECT s.CustID,s.roleid,s.mrecommend
		FROM dbo.Customer s WITH (NOLOCK)			
		WHERE s.srecommend = @CustID 

		DELETE t
		FROM #tempCust t
		INNER JOIN #tblmrecommend m ON t.mrecommend=m.CustID

		SET @MaxRow = (SELECT MAX(ID) FROM #tempCust)
		
		IF @MaxRow IS NULL
			RETURN

		IF	@Threshold >= @MaxRow
		SET	@Threshold = @MaxRow
		
		SET @StopRow = @Threshold

		WHILE (0 = 0)
		BEGIN
			IF(@IsDisabled=1 OR (@IsDisabled=0 AND @IsDisabledDownline=0))
			BEGIN
				UPDATE d
				SET d.bitmapIsDisabled=dbo.f_GenerateProductStatus (d.bitmapIsDisabled, @bitmapOrder,@IsDisabled) ,
					d.bitmapIsHidden=dbo.f_GenerateProductStatus (d.bitmapIsHidden, @bitmapOrder,0) ,
					RepUpdateTime = SYSDATETIME()
				FROM #tempCust C WITH(NOLOCK)
					INNER JOIN Dep_CustProductStatus d WITH(ROWLOCK) ON c.custid=d.custid
				WHERE ID >= @StartRow AND ID <= @StopRow					
			END
			ELSE 
			BEGIN
				UPDATE d
				SET d.bitmapIsDisabled=dbo.f_GenerateProductStatus (d.bitmapIsDisabled, @bitmapOrder,@IsDisabled) ,
					d.bitmapIsHidden=dbo.f_GenerateProductStatus (d.bitmapIsHidden, @bitmapOrder,0) ,
					RepUpdateTime = SYSDATETIME()
				FROM #tempCust C WITH(NOLOCK)
					INNER JOIN Dep_CustProductStatus d WITH(ROWLOCK) ON c.custid=d.custid
				WHERE c.RoleID IN (2,3,4) AND ID >= @StartRow AND ID <= @StopRow	
			END
		
			DELETE t
			FROM #tempCust t
				INNER JOIN Dep_CustProductStatus s WITH(NOLOCK) ON t.CustID=s.CustID
			WHERE ID >= @StartRow AND ID <= @StopRow

			INSERT INTO dbo.Dep_CustProductStatus
				(CustID
				,bitmapIsDisabled
				,bitmapIsHidden
				,RepUpdateTime)
			SELECT	c.custid
			, dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, @bitmapOrder,@IsDisabled) AS bitmapIsDisabled
			, dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, @bitmapOrder,0)  AS bitmapIsHidden
			, SYSDATETIME()
			FROM #tempCust C
			WHERE c.RoleID IN(2,3,4) 
				AND ID >= @StartRow AND ID <= @StopRow
				AND NOT EXISTS (SELECT 1 FROM dbo.Dep_CustProductStatus T WITH(NOLOCK) WHERE t.custid = c.custid)
				

			INSERT INTO dbo.Dep_CustProductStatus
					(CustID
					,bitmapIsDisabled
					,bitmapIsHidden 
					,RepUpdateTime)
			SELECT	c.custid
			, dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, @bitmapOrder,@IsDisabledDownline) AS bitmapIsDisabled
			, dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, @bitmapOrder,0)  AS bitmapIsHidden
			, SYSDATETIME()
			FROM #tempCust C
			WHERE c.RoleID =1 
				AND ID >= @StartRow AND ID <= @StopRow
				AND NOT EXISTS (SELECT 1 FROM dbo.Dep_CustProductStatus T WITH(NOLOCK) WHERE t.custid = c.custid)			

			IF	@StopRow = @MaxRow 
				BREAK
					
			SET	@StartRow = @StopRow + 1
					
			SET	@StopRow = 1 + @StopRow + @Threshold
					
			IF	@StopRow >= @MaxRow
				SET	@StopRow = @MaxRow
		END
	END
	ELSE IF @ActionID=0
	BEGIN	
		INSERT INTO #tblmrecommend(CustID)
		SELECT custid FROM custinfo WITH (NOLOCK) WHERE roleid=3
		and username LIKE '%Acc%' and srecommend=@CustID		
			
		INSERT INTO #tempCust(CustID,RoleID,mrecommend )
		SELECT s.CustID,s.roleid,s.mrecommend
		FROM dbo.Customer s WITH (NOLOCK)			
		WHERE s.srecommend = @CustID		
		
		DELETE t
		FROM #tempCust t
		INNER JOIN #tblmrecommend m ON t.mrecommend=m.CustID

		SET @MaxRow = (SELECT MAX(ID) FROM #tempCust)
		
		IF @MaxRow IS NULL
			RETURN
		
		IF	@Threshold >= @MaxRow
		SET	@Threshold = @MaxRow
		
		SET @StopRow = @Threshold

		WHILE (0 = 0)
		BEGIN			
			IF(@IsDisabled=1 OR (@IsDisabled=0 AND @IsDisabledDownline=0))
			BEGIN
				INSERT INTO dbo.Dep_CustProductStatus
						   (CustID
						   ,bitmapIsDisabled
						   ,bitmapIsHidden  
						   ,RepUpdateTime)
				SELECT	c.custid
				, dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, @bitmapOrder,@IsDisabled) AS bitmapIsDisabled
				, dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, @bitmapOrder,0)  AS bitmapIsHidden
				, SYSDATETIME()
				FROM #tempCust C
				WHERE   ID >= @StartRow AND ID <= @StopRow AND NOT EXISTS (SELECT 1 FROM dbo.Dep_CustProductStatus T WITH(NOLOCK) WHERE t.custid = c.custid)
			END
			ELSE
			BEGIN
				INSERT INTO dbo.Dep_CustProductStatus
						   (CustID
						   ,bitmapIsDisabled
						   ,bitmapIsHidden 
						   ,RepUpdateTime)
				SELECT	c.custid
				, dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, @bitmapOrder,@IsDisabled) AS bitmapIsDisabled
				, dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, @bitmapOrder,0)  AS bitmapIsHidden
				, SYSDATETIME()
				FROM #tempCust C
				WHERE c.RoleID IN(2,3,4)
					AND  ID >= @StartRow AND ID <= @StopRow 
					AND NOT EXISTS (SELECT 1 FROM dbo.Dep_CustProductStatus T WITH(NOLOCK) WHERE t.custid = c.custid)

				INSERT INTO dbo.Dep_CustProductStatus
						(CustID
						,bitmapIsDisabled
						,bitmapIsHidden 
						,RepUpdateTime)
				SELECT	c.custid
				, dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, @bitmapOrder,@IsDisabledDownline) AS bitmapIsDisabled
				, dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, @bitmapOrder,0)  AS bitmapIsHidden
				, SYSDATETIME()
				FROM #tempCust C
				WHERE c.RoleID =1 
					AND  ID >= @StartRow AND ID <= @StopRow
					AND NOT EXISTS (SELECT 1 FROM dbo.Dep_CustProductStatus T WITH(NOLOCK) WHERE t.custid = c.custid)	
			END		

			IF	@StopRow = @MaxRow 
			BREAK
					
			SET	@StartRow = @StopRow + 1
					
			SET	@StopRow = 1 + @StopRow + @Threshold
					
			IF	@StopRow >= @MaxRow
				SET	@StopRow = @MaxRow
		END		
	END
	ELSE IF @ActionID=2
	BEGIN				

		INSERT INTO #tempCust(CustID,RoleID,mrecommend )
		SELECT s.CustID,s.roleid,s.mrecommend
		FROM dbo.Customer s WITH (NOLOCK)			
		WHERE s.recommend = @CustID  AND RoleID=1	
		
		SET @MaxRow = (SELECT MAX(ID) FROM #tempCust)		

		IF @MaxRow IS NULL
			RETURN

		IF	@Threshold >= @MaxRow
		SET	@Threshold = @MaxRow
		
		SET @StopRow = @Threshold
		WHILE (0 = 0)
		BEGIN	
					
			IF(@IsDisabled=1 OR (@IsDisabled=0 AND @IsDisabledDownline=0))
			BEGIN
				UPDATE d
				SET d.bitmapIsDisabled=dbo.f_GenerateProductStatus (d.bitmapIsDisabled, @bitmapOrder,@IsDisabled) ,
					d.bitmapIsHidden=dbo.f_GenerateProductStatus (d.bitmapIsHidden, @bitmapOrder,0) ,
					RepUpdateTime = SYSDATETIME()
				FROM #tempCust C WITH(NOLOCK)
					INNER JOIN Dep_CustProductStatus d WITH(ROWLOCK) ON c.custid=d.custid
				WHERE  ID >= @StartRow AND ID <= @StopRow			
			END				
					
			DELETE t
			FROM #tempCust t
				INNER JOIN Dep_CustProductStatus s WITH(NOLOCK) ON t.CustID=s.CustID
			WHERE  ID >= @StartRow AND ID <= @StopRow
		
			INSERT INTO dbo.Dep_CustProductStatus
					(CustID
					,bitmapIsDisabled
					,bitmapIsHidden 
					,RepUpdateTime)
			SELECT	c.custid
			, dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, @bitmapOrder,@IsDisabledDownline) AS bitmapIsDisabled
			, dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, @bitmapOrder,0)  AS bitmapIsHidden
			, SYSDATETIME()
			FROM #tempCust C
			WHERE NOT EXISTS (SELECT 1 FROM dbo.Dep_CustProductStatus T WITH(NOLOCK) WHERE t.custid = c.custid)		
				AND  ID >= @StartRow AND ID <= @StopRow

			IF	@StopRow = @MaxRow 
			BREAK
					
			SET	@StartRow = @StopRow + 1
					
			SET	@StopRow = 1 + @StopRow + @Threshold
					
			IF	@StopRow >= @MaxRow
				SET	@StopRow = @MaxRow
		END
	END
END	

GO