/*<info serverAlias="DBCUST-CUSTDB" executers="wsv_nap" viewers="vnteam" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_DynamicCustSetting_04]
	@custid int,
	@roleid tinyint,
	@IsDisabled_XML VARCHAR(MAX) = NULL
AS
/*
	Created: 20160405@Helen
	Task : Update customer/custinfo settings
	DB: DBCust/CustDB
	
	Revisions:
		- 20240712@Johnson: Apply In-house Replication for Customer Setting [redmine:#207025]	
*/
BEGIN
	
	SET NOCOUNT ON 
	
	--Check if XML is null or empty
	IF @IsDisabled_XML IS NULL OR @IsDisabled_XML='' RETURN
	
	CREATE TABLE #tempCust (ID INT IDENTITY (1,1) PRIMARY KEY,CustID INT ,RoleID INT,mrecommend INT)	
	CREATE NONCLUSTERED INDEX IDX_tempCust ON #tempCust(CustID)	

	CREATE TABLE #tblmrecommend  (CustID INT PRIMARY KEY)	
	DECLARE @StartRow	INT, 
			@MaxRow		INT,
			@Threshold	INT, 
			@StopRow INT			
	SET @StartRow=1
	SET @Threshold=2000
	
	CREATE TABLE #NewDisableStatTbl(
				SportType SMALLINT,
				BetType SMALLINT,
				IsDisabled BIT,
				IsDisabledDownline BIT
			)
	--Parse XML		
	DECLARE @iDoc INT
	EXEC sp_xml_preparedocument @iDoc OUTPUT, @IsDisabled_XML
		
	INSERT INTO #NewDisableStatTbl
	SELECT *
	FROM OPENXML (@iDoc, '/ROOT/ProductStatus',1) 
	WITH(SportType smallint, BetType smallint, IsDisabled BIT,IsDisabledDownline BIT
		)	
		
	EXEC sp_xml_removedocument @iDoc
	
	DECLARE @xmlStrDisabled XML
	DECLARE @xmlStrHidden XML
	
	SET @xmlStrDisabled = (
			SELECT (
					SELECT psp.bitmapOrder	AS '@b'
						, tmp.IsDisabled	AS '@s'
					FROM dbo.Dep_ProductStatusProfile psp WITH (NOLOCK)
						JOIN #NewDisableStatTbl tmp ON PSP.Sporttype = tmp.SportType AND psp.Bettype = tmp.BetType
	
					FOR XML PATH('r')
						, TYPE
					)
			FOR XML PATH('root')
				, TYPE
			)
	
	IF EXISTS (SELECT 1 FROM #NewDisableStatTbl WHERE IsDisabled = 0)
	BEGIN
		SET @xmlStrHidden = (
			SELECT (
					SELECT psp.bitmapOrder	AS '@b'
						, 0	AS '@s'
					FROM Dep_ProductStatusProfile psp (NOLOCK)
						JOIN #NewDisableStatTbl tmp ON PSP.Sporttype = tmp.SportType AND psp.Bettype = tmp.BetType
					WHERE tmp.IsDisabled=0	
					FOR XML PATH('r')
						, TYPE
					)
			FOR XML PATH('root')
				, TYPE
			)
	END	
			
	IF @RoleID=4
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
			UPDATE T 
				SET bitmapIsDisabled = (SELECT bitmap FROM dbo.f_GenerateProductStatus_multiple (T.bitmapIsDisabled, CONVERT(VARCHAR(MAX),@xmlStrDisabled))),
					RepUpdateTime = dbo.f_GetDateTime2()
			FROM  dbo.Dep_CustProductStatus T
				INNER JOIN #tempCust CI ON T.CustID = CI.custid	
			WHERE ID >= @StartRow AND ID <= @StopRow
			
			IF EXISTS (SELECT 1 FROM #NewDisableStatTbl WHERE IsDisabled = 0)
			BEGIN
			
				UPDATE T 
					SET bitmapIsHidden = (SELECT bitmap FROM dbo.f_GenerateProductStatus_multiple (bitmapIsHidden, CONVERT(VARCHAR(MAX),@xmlStrHidden))),
						RepUpdateTime = dbo.f_GetDateTime2()
				FROM dbo.Dep_CustProductStatus T 
					INNER JOIN #tempCust CI WITH (NOLOCK) ON T.CustID = CI.custid	
				WHERE ID >= @StartRow AND ID <= @StopRow
				
			END
			
			DELETE t
			FROM #tempCust t				
			WHERE ID >= @StartRow AND ID <= @StopRow
			
			IF	@StopRow = @MaxRow 
				BREAK
					
			SET	@StartRow = @StopRow + 1
					
			SET	@StopRow = 1 + @StopRow + @Threshold
					
			IF	@StopRow >= @MaxRow
				SET	@StopRow = @MaxRow
		END
	END
	
	ELSE IF @RoleID=3
	BEGIN
		INSERT INTO #tempCust(CustID,RoleID,mrecommend )
		SELECT s.CustID,s.roleid,s.mrecommend
		FROM dbo.Customer s WITH (NOLOCK)			
		WHERE s.mrecommend = @CustID AND roleid IN (1,2)

		SET @MaxRow = (SELECT MAX(ID) FROM #tempCust)
		
		IF @MaxRow IS NULL
			RETURN

		IF	@Threshold >= @MaxRow
		SET	@Threshold = @MaxRow
		
		SET @StopRow = @Threshold

		WHILE (0 = 0)
		BEGIN			
			UPDATE T 
				SET bitmapIsDisabled = (SELECT bitmap FROM dbo.f_GenerateProductStatus_multiple (T.bitmapIsDisabled, CONVERT(VARCHAR(MAX),@xmlStrDisabled))),
					RepUpdateTime = dbo.f_GetDateTime2()
			FROM  dbo.Dep_CustProductStatus T
				INNER JOIN #tempCust CI ON T.CustID = CI.custid	
			WHERE ID >= @StartRow AND ID <= @StopRow
			
			IF EXISTS (SELECT 1 FROM #NewDisableStatTbl WHERE IsDisabled = 0)
			BEGIN
			
				UPDATE T WITH (UPDLOCK,ROWLOCK)
					SET bitmapIsHidden = (SELECT bitmap FROM dbo.f_GenerateProductStatus_multiple (bitmapIsHidden, CONVERT(VARCHAR(MAX),@xmlStrHidden))),
						RepUpdateTime = dbo.f_GetDateTime2()
				FROM dbo.Dep_CustProductStatus T 
					INNER JOIN #tempCust CI ON T.CustID = CI.custid	
				WHERE ID >= @StartRow AND ID <= @StopRow				
			END
			
			DELETE t
			FROM #tempCust t				
			WHERE ID >= @StartRow AND ID <= @StopRow
			
			IF	@StopRow = @MaxRow 
				BREAK
					
			SET	@StartRow = @StopRow + 1
					
			SET	@StopRow = 1 + @StopRow + @Threshold
					
			IF	@StopRow >= @MaxRow
				SET	@StopRow = @MaxRow
		END
	END
	ELSE IF @RoleID=2
	BEGIN
		INSERT INTO #tempCust(CustID,RoleID)
		SELECT s.CustID,s.roleid
		FROM dbo.Customer s WITH (NOLOCK)			
		WHERE s.recommend = @CustID AND roleid =1

		SET @MaxRow = (SELECT MAX(ID) FROM #tempCust)
		
		IF @MaxRow IS NULL
			RETURN

		IF	@Threshold >= @MaxRow
		SET	@Threshold = @MaxRow
		
		SET @StopRow = @Threshold

		WHILE (0 = 0)
		BEGIN			
			UPDATE T 
				SET bitmapIsDisabled = (SELECT bitmap FROM dbo.f_GenerateProductStatus_multiple (T.bitmapIsDisabled, CONVERT(VARCHAR(MAX),@xmlStrDisabled))),
					RepUpdateTime = dbo.f_GetDateTime2()
			FROM  dbo.Dep_CustProductStatus T
				INNER JOIN #tempCust CI ON T.CustID = CI.custid	
			WHERE ID >= @StartRow AND ID <= @StopRow
			
			IF EXISTS (SELECT 1 FROM #NewDisableStatTbl WHERE IsDisabled = 0)
			BEGIN
				UPDATE T 
					SET bitmapIsHidden = (SELECT bitmap FROM dbo.f_GenerateProductStatus_multiple (bitmapIsHidden, CONVERT(VARCHAR(MAX),@xmlStrHidden))),
						RepUpdateTime = dbo.f_GetDateTime2()
				FROM dbo.Dep_CustProductStatus T 
					INNER JOIN #tempCust CI ON T.CustID = CI.custid	
				WHERE ID >= @StartRow AND ID <= @StopRow
				
			END
			
			DELETE t
			FROM #tempCust t				
			WHERE ID >= @StartRow AND ID <= @StopRow
			
			IF	@StopRow = @MaxRow 
				BREAK
					
			SET	@StartRow = @StopRow + 1
					
			SET	@StopRow = 1 + @StopRow + @Threshold
					
			IF	@StopRow >= @MaxRow
				SET	@StopRow = @MaxRow
		END	
	END
	
END

