/*<info serverAlias="DBCUST-CUSTDB" executers="wsv_nap,wsv_lap,svc_tig" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE dbo.Acc_Dep_LicenseeSetting_PTSettingUpd 
	 @Site			VARCHAR(20)
	, @InputPT		VARCHAR(MAX)
	, @UserID		INT
	, @UserName		VARCHAR(50) 
	, @IP			VARCHAR(50)		= ''
	, @ErrCode		INT				= 0		OUTPUT	
	, @ErrMsg		NVARCHAR(200)	= ''	OUTPUT
AS
/*
	Created: 20220623@Winfred
	Task: Update licensee Customer's PT
	Original:
	Revision:		
		- 20220623@Winfred: Licensee Setting - Automate the PT adjustment when the charge rate is changed [RedmineID:#171705]
		- 20240429@Tacy: correct Log [RedmineID: #201239]
		- 20240708@Johnson: Apply In-house Replication for Customer Setting [redmine:#207025]
		- 20240814@Winfred: Enhance Update PT in NAP[RedmineID:#201477]
	Param's Explanation:
		*@UserName : Name user LA update
		@InputPT:
		<ROOT>
				<PT
						PID="59"
						CID="0"
						PT="90"
				/>
		</ROOT>
		* when PT =  -1 => don't update value
	*/

BEGIN
	SET NOCOUNT ON
	
	DECLARE @startRun DATETIME, @endRun	DATETIME, @duration INT, @mrecommend INT , @creator	INT
	DECLARE @logSpData NVARCHAR(MAX), @logSpData_Old NVARCHAR(MAX), @xml XML, @iDoc INT,  @Threshold INT, @NumProduct INT = 0
	DECLARE	@ProductName VARCHAR(50), @SettingLevel	TINYINT, @ProductID INT,@Currency INT,@CustIDList VARCHAR(MAX),@SuperID INT,@PT XML
	
	SET @creator = 10278938	--StarixIT

	CREATE TABLE #PTProduct(ProductID INT,Currency INT,PT SMALLMONEY, PRIMARY KEY(ProductID ,Currency ))
	CREATE TABLE #SportTypeBetType(ProductID INT,SportType INT,Bettype INT,BettypeName NVARCHAR(128),Currency INT,IsLive BIT,PT SMALLMONEY,
								   ProductName VARCHAR(50),SettingLevel TINYINT,ProductSettingID INT,IsApplyBA BIT,isfinished BIT DEFAULT(0),PRIMARY KEY(ProductSettingID,Sporttype ,Bettype,Currency))
	CREATE TABLE #tmpSMA (CustID INT ,RoleID INT,Currency INT,srecommend INT,  ProductSettingID INT, isfinished BIT DEFAULT(0),PRIMARY KEY(CustID ,ProductSettingID ))
	CREATE TABLE #Dummy (CustID INT PRIMARY KEY)	
	CREATE TABLE #tmpSMATemp (CustID INT,RoleID INT,Currency INT,srecommend INT, ProductSettingID INT,PRIMARY KEY(CustID ,ProductSettingID ))
	CREATE TABLE #tmpPT_Old (CustID INT ,SportType INT,Bettype INT,IsLive BIT, PT SMALLMONEY, PRIMARY KEY(CustID ,Sporttype ,Bettype ))
	CREATE TABLE #tmpAdjPT (SportType INT,Bettype INT,IsLive BIT,IsApplyBA BIT, PT SMALLMONEY,ProductID INT,ProductName VARCHAR(50),SettingLevel TINYINT, PRIMARY KEY(Sporttype ,Bettype ))
	CREATE NONCLUSTERED INDEX  NIX_tmpSMA ON #tmpSMA (isfinished) 

	SET @startRun = GETDATE()
	SELECT	@ErrCode = 0, @ErrMsg = ''
	BEGIN TRY
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
	END TRY

	BEGIN CATCH
		SET @ErrCode = 100
		SET @ErrMsg = N'Unable to process update NAP PT due to invalid parameters, please try again.'
		RETURN
	END CATCH;
	-- All sport type  - bettype
	INSERT INTO #SportTypeBetType (ProductID,SportType,Bettype,BettypeName,Currency,IsLive,PT,ProductName,SettingLevel,ProductSettingID,IsApplyBA)
	SELECT a.ProductID,psd.SportType,psd.BetType,bt.typenamee AS BettypeName,a.Currency,IsLive,a.PT, p.ProductName,dp.SettingLevel,dp.ProductSettingID,psd.IsApplyBA
	FROM #PTProduct a
	INNER JOIN Dep_ProductSetting dp WITH(NOLOCK) ON dp.ProductID=a.ProductID 
	INNER JOIN Dep_ProductSettingDetail psd WITH(NOLOCK) ON dp.ProductSettingID = psd.ProductSettingID
	LEFT JOIN  Exchange e WITH(NOLOCK) ON e.ExchangeId = a.Currency 
	INNER JOIN DBPRO.bodb02.dbo.Products p WITH(NOLOCK) ON p.ProductID = a.ProductID
	INNER JOIN DBPRO.bodb02.dbo.bettype bt WITH(NOLOCK) ON bt.typeid = psd.BetType
	WHERE dp.SettingType=1 AND (a.Currency = 0 OR (e.IsActive = 1 AND e.OfferSite IN (0,2))) AND a.PT <> -1
	
	-- Remove Bettype Jackpot Contribution
	DELETE FROM #SportTypeBetType WHERE BettypeName LIKE '%' + 'Contribution'

	-- ALL SMA affect
	INSERT INTO #tmpSMA(CustID,Currency,RoleID,srecommend,ProductSettingID)
	SELECT DISTINCT ci.custid, ci.currency, ci.roleid,ci.srecommend,lps.ProductSettingID
	FROM custInfo ci WITH(NOLOCK) 
		INNER JOIN Dep_custsuper cs WITH (NOLOCK) ON ci.custid = cs.custid
		INNER JOIN Dep_LicenseeProductSetting lps with(nolock) ON ci.custid = lps.CustID
		INNER JOIN #SportTypeBetType stp with(nolock) ON stp.ProductSettingID = lps.ProductSettingID AND stp.Currency <> 0
	WHERE Roleid=4 AND cs.site = @Site 
	AND EXISTS (SELECT 1 FROM #PTProduct WHERE ProductID = stp.ProductID AND Currency = ci.currency AND PT <> -1)
	UNION ALL 
	SELECT  DISTINCT ci.custid, ci.currency, ci.roleid,ci.srecommend,lps.ProductSettingID
	FROM custInfo ci WITH(NOLOCK) 
		INNER JOIN Dep_custsuper cs WITH (NOLOCK) ON ci.custid = cs.custid
		INNER JOIN Dep_LicenseeProductSetting lps with(nolock) ON ci.custid = lps.CustID
		INNER JOIN #SportTypeBetType stp with(nolock) ON stp.ProductSettingID = lps.ProductSettingID AND stp.Currency = 0
	WHERE Roleid=4 AND cs.site = @Site 
	AND ci.currency NOT IN (SELECT Currency FROM #PTProduct WHERE ProductID = stp.ProductID AND Currency <> 0)
	AND EXISTS (SELECT 1 FROM #PTProduct WHERE ProductID = stp.ProductID AND Currency = 0  AND PT <> -1)

	INSERT INTO	#tmpPT_Old (CustID,SportType, BetType, Islive, PT)
	SELECT DISTINCT	a.CustID	
		,	stb.SportType
		,	stb.BetType
		,	stb.IsLive
		,	a.SuperPT
	FROM #tmpSMA t
			INNER JOIN #SportTypeBetType stb ON t.ProductSettingID = stb.ProductSettingID
			CROSS APPLY (
							SELECT TOP 1 CustID, SuperPT
							FROM dbo.Dep_CustPTSetting_Agent WITH(NOLOCK)
							WHERE CustID = t.CustID AND SportType=stb.SportType AND BetType=stb.BetType AND IsLive = stb.IsLive
						) a

	INSERT INTO #Dummy(CustID)
	SELECT CustID FROM Customer WITH(NOLOCK) 
	WHERE Roleid=3 AND site = @Site
		AND (username LIKE '%Acc%' OR username LIKE '%LocalBank%' OR 
			 username LIKE '%AFF%' OR username LIKE 'AB88'+'CAS%')
		AND srecommend IN (SELECT CustID FROM  #tmpSMA)
	
	INSERT INTO #tmpSMA(CustID,Currency,RoleID,ci.srecommend,ProductSettingID)
	SELECT  DISTINCT ci.CustID, ci.currency ,ci.roleid, ci.srecommend, sa.ProductSettingID 
	FROM custInfo ci WITH(NOLOCK) 
	INNER JOIN #tmpSMA sa ON ci.srecommend = sa.CustID AND sa.RoleID = 4
	WHERE Enabled=1 AND ci.Roleid in (2,3)  
		AND ci.srecommend IN (SELECT CustID FROM  #tmpSMA)
		AND EXISTS (SELECT 1 FROM #PTProduct WHERE Currency = ci.currency)
		AND mrecommend NOT IN (SELECT custid FROM #Dummy)	
	UNION ALL 
	SELECT  DISTINCT ci.CustID, ci.currency, ci.roleid, ci.srecommend, sa.ProductSettingID 
	FROM custInfo ci WITH(NOLOCK) 
	INNER JOIN #tmpSMA sa ON ci.srecommend = sa.CustID AND sa.RoleID = 4
	WHERE Enabled=1 AND ci.Roleid in (2,3)  
		AND ci.srecommend IN (SELECT CustID FROM  #tmpSMA)
		AND NOT EXISTS (SELECT 1 FROM #PTProduct WHERE Currency = ci.currency)
		AND mrecommend NOT IN (SELECT custid FROM #Dummy)	
		AND EXISTS (SELECT 1 FROM #PTProduct WHERE Currency = 0)
	
	SET @Threshold = 2000 
	WHILE(1 =1)
	BEGIN
		UPDATE TOP (@Threshold) c WITH (ROWLOCK)
		SET c.isfinished = 1
		OUTPUT DELETED.CustID,DELETED.RoleID,DELETED.Currency,DELETED.ProductSettingID INTO #tmpSMATemp(CustID,RoleID,Currency,ProductSettingID)
		FROM #tmpSMA c 
		WHERE isfinished = 0
		
		IF @@ROWCOUNT = 0 BREAK
		-- exists currency
		UPDATE a
		SET  SuperPT  = CASE WHEN t.RoleID = 4 THEN stb.PT ELSE 0 END
			,MasterPT = CASE WHEN t.RoleID IN (3,4) THEN stb.PT ELSE 0 END
			,AgentPT  = CASE WHEN t.RoleID IN (2,4) THEN stb.PT ELSE 0 END
			,RepUpdateTime = dbo.f_GetDateTime2()
		FROM #tmpSMATemp t
			INNER JOIN #SportTypeBetType stb ON t.ProductSettingID = stb.ProductSettingID AND t.Currency = stb.Currency 
			CROSS APPLY (
							SELECT TOP 1 SuperPT, MasterPT, AgentPT
							FROM dbo.Dep_CustPTSetting_Agent WITH(ROWLOCK,UPDLOCK)
							WHERE CustID = t.CustID AND SportType=stb.SportType AND BetType=stb.BetType
						) a
		
		-- all currency
		UPDATE a
		SET  SuperPT  = CASE WHEN t.RoleID = 4 THEN stb.PT ELSE 0 END
			,MasterPT = CASE WHEN t.RoleID IN (3,4) THEN stb.PT ELSE 0 END
			,AgentPT  = CASE WHEN t.RoleID IN (2,4) THEN stb.PT ELSE 0 END
			,RepUpdateTime = dbo.f_GetDateTime2()
		FROM #tmpSMATemp t
			INNER JOIN #SportTypeBetType stb ON t.ProductSettingID = stb.ProductSettingID AND stb.Currency = 0 
			CROSS APPLY (
							SELECT TOP 1 SuperPT, MasterPT, AgentPT
							FROM dbo.Dep_CustPTSetting_Agent WITH(ROWLOCK,UPDLOCK)
							WHERE CustID = t.CustID AND SportType = stb.SportType AND BetType = stb.BetType
						) a
		WHERE  NOT EXISTS (SELECT TOP 1 1 FROM #SportTypeBetType WHERE Currency = t.Currency AND stb.SportType=SportType AND stb.BetType=BetType )
		
		TRUNCATE TABLE #tmpSMATemp
	END
	
	UPDATE #tmpSMA SET isfinished = 0
	WHILE(1 =1)
	BEGIN
			UPDATE TOP (1) c
			SET c.isfinished = 1,
				@SuperID = c.srecommend, 
				@Currency = c.Currency 
			FROM #tmpSMA c 
			WHERE isfinished = 0 AND RoleID = 4
		
			IF @@ROWCOUNT = 0 BREAK

			SELECT @CustIDList =  STUFF((SELECT DISTINCT ',' + cast(custid AS VARCHAR(10))
			FROM #tmpSMA
			WHERE RoleID = 2 AND Currency = @Currency AND srecommend = @SuperID
			FOR XML PATH('')), 1, 1, '')

			TRUNCATE TABLE #tmpAdjPT
			
			INSERT INTO #tmpAdjPT(SportType,BetType,IsLive,PT,IsApplyBA,ProductID,ProductName,SettingLevel)
			SELECT SportType,BetType,IsLive,PT,IsApplyBA,ProductID,ProductName,SettingLevel
			FROM   #SportTypeBetType stb
			INNER JOIN #tmpSMA sa on stb.ProductSettingID = sa.ProductSettingID
			WHERE sa.CustID = @SuperID AND sa.RoleID = 4 AND stb.Currency = sa.Currency 
			UNION
			SELECT	SportType,BetType,IsLive,PT,IsApplyBA,ProductID,ProductName,SettingLevel
			FROM	#SportTypeBetType stb	
			INNER JOIN #tmpSMA sa on stb.ProductSettingID = sa.ProductSettingID
			WHERE sa.CustID = @SuperID AND sa.RoleID = 4 AND stb.Currency = 0 AND 
					NOT EXISTS( SELECT 1 
								FROM #SportTypeBetType 
								WHERE Currency = sa.Currency 
								AND SportType = stb.SportType 
								AND Bettype = stb.Bettype )

			SET @NumProduct = (SELECT COUNT(1) FROM #tmpAdjPT)

			SET @PT = (
				SELECT	SportType	AS '@SportType',
						BetType		AS '@BetType',
						IsLive 		AS '@IsLive',
						PT 			AS '@PT',
						IsApplyBA 	AS '@IsApplyBA'
				FROM #tmpAdjPT 
				FOR XML PATH('PT'),ROOT ('ROOT'),
				TYPE )
			
			IF @PT IS NOT NULL AND @NumProduct <> 0
			BEGIN
					EXEC Acc_Dep_DynamicCustSetting_10	
						@Site = @Site,
						@Currency = @Currency,
						@NumProduct = @NumProduct,
						@CustIDList=@CustIDList,
						@PT=@PT	
					
					IF	@@ERROR <> 0
					BEGIN	
						SELECT	@ErrCode = 101
							,	@ErrMsg = 'Fail to update member Position Taking, please try again.';
						BREAK;
					END;
			END
		
			--START LOGGING
			-- Log old data
			SET @xml = (
				SELECT	@SuperID						AS '@SuperID',
						@creator						AS '@UserID',				
						@IP								AS '@IP',				
						@UserID							AS '@AdminID',
						@UserName						AS '@AdminName',
						(
							SELECT DISTINCT	stb.ProductID			AS '@ProductID',
									stb.ProductName			AS '@ProductName',
									cs.PT					AS '@PositionTaking'	
							FROM	#tmpPT_Old AS cs
								CROSS APPLY ( SELECT DISTINCT ProductID,ProductName,SettingLevel
												FROM	#SportTypeBetType
												WHERE cs.SportType = SportType AND cs.Bettype = Bettype) stb
							WHERE CustID = @SuperID AND stb.SettingLevel = 1 -- Product setting level
							ORDER BY stb.ProductID,stb.ProductName
							FOR XML PATH('Product'), 
							TYPE
						),
						(
							SELECT	DISTINCT stb.ProductID			AS '@ProductID',
									stb.ProductName			AS '@ProductName',
									cs.SportType			AS '@SportType',
									cs.PT					AS '@PositionTaking'	
							FROM	#tmpPT_Old AS cs
								CROSS APPLY ( SELECT DISTINCT ProductID,ProductName,SettingLevel
												FROM	#SportTypeBetType
												WHERE cs.SportType = SportType AND cs.Bettype = Bettype) stb
							WHERE CustID = @SuperID AND stb.SettingLevel = 2 -- SportType setting level
							ORDER BY stb.ProductID,stb.ProductName,cs.SportType
							FOR XML PATH('SportType'),
							TYPE
						),
						(
							SELECT	DISTINCT stb.ProductID			AS '@ProductID',
									stb.ProductName			AS '@ProductName',
									cs.BetType				AS '@BetType',
									cs.PT					AS '@PositionTaking'	
							FROM	#tmpPT_Old AS cs
								CROSS APPLY ( SELECT DISTINCT ProductID,ProductName,SettingLevel
												FROM	#SportTypeBetType
												WHERE cs.SportType = SportType AND cs.Bettype = Bettype) stb
							WHERE CustID = @SuperID AND stb.SettingLevel = 3 -- BetType setting level
							ORDER BY stb.ProductID,stb.ProductName,cs.Bettype
							FOR XML PATH('BetType'), 
							TYPE
						),
						(
							SELECT	DISTINCT stb.ProductID			AS '@ProductID',
									stb.ProductName			AS '@ProductName',
									cs.SportType			AS '@SportType',
									cs.BetType				AS '@BetType',
									cs.PT					AS '@PositionTaking'	
							FROM	#tmpPT_Old AS cs
								CROSS APPLY ( SELECT DISTINCT ProductID,ProductName,SettingLevel
												FROM	#SportTypeBetType
												WHERE cs.SportType = SportType AND cs.Bettype = Bettype) stb
							WHERE CustID = @SuperID AND stb.SettingLevel = 4 -- SportType BetType setting level
							ORDER BY stb.ProductID,stb.ProductName,cs.SportType,cs.Bettype
							FOR XML PATH('SportTypeBetType'), 
							TYPE
						)
				FOR XML PATH('R'),
				TYPE)
			SET @logSpData_Old = REPLACE(CONVERT(VARCHAR(MAX), @xml), '" />', '"/"')
			
			-- Log new updated data
			SET @xml = (
				SELECT	@SuperID						AS '@SuperID',
						@creator						AS '@UserID',				
						@IP								AS '@IP',			
						@UserID							AS '@AdminID',
						@UserName						AS '@AdminName',
						(
							SELECT DISTINCT cs.ProductID			AS '@ProductID',
									cs.ProductName					AS '@ProductName',
									cs.PT							AS '@PositionTaking'	
							FROM	#tmpAdjPT AS cs	
							WHERE cs.SettingLevel = 1  -- Product setting level
							ORDER BY cs.ProductID,cs.ProductName
							FOR XML PATH('Product'),
							TYPE
						),
						(
							SELECT cs.ProductID						AS '@ProductID',
									cs.ProductName					AS '@ProductName',
									cs.SportType					AS '@SportType',
									cs.PT							AS '@PositionTaking'	
							FROM	#tmpAdjPT AS cs				
							WHERE cs.SettingLevel = 2  -- SportType setting level
							ORDER BY cs.ProductID,	cs.ProductName,cs.SportType
							FOR XML PATH('SportType'),
							TYPE
						),
						(
							SELECT DISTINCT	cs.ProductID			AS '@ProductID',
									cs.ProductName					AS '@ProductName',
									cs.BetType						AS '@BetType',
									cs.PT							AS '@PositionTaking'	
							FROM	#tmpAdjPT AS cs				
							WHERE cs.SettingLevel = 3 -- BetType setting level
							ORDER BY cs.ProductID,	cs.ProductName,cs.BetType
							FOR XML PATH('BetType'),
							TYPE
						),
						(
							SELECT DISTINCT	cs.ProductID			AS '@ProductID',
									cs.ProductName					AS '@ProductName',
									cs.SportType					AS '@SportType',
									cs.BetType						AS '@BetType',
									cs.PT							AS '@PositionTaking'	
							FROM	#tmpAdjPT AS cs			
							WHERE cs.SettingLevel = 4 -- SportType BetType setting level
							ORDER BY cs.ProductID,	cs.ProductName,cs.SportType, cs.BetType
							FOR XML PATH('SportTypeBetType'),
							TYPE
						)
				FOR XML PATH('R'),
				TYPE
			)

			SET @logSpData = REPLACE(CONVERT(VARCHAR(MAX), @xml), '" />', '"/"')

			SELECT @endRun = GETDATE() , @duration = DATEDIFF(MILLISECOND, @startRun, @endRun)
		
			BEGIN TRY
				EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP_MultiCust 
					@UserID				= @creator
					, @CustIDList		= @CustIDList
					, @ActionID			= 472
					, @NewPT_XML		= @logSpData
					, @OldPT_XML		= @logSpData_Old
					, @duration			= @duration
			END TRY

			BEGIN CATCH
				EXEC bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP_MultiCust 
					@UserID				= @creator
					, @CustIDList		= @CustIDList
					, @ActionID			= 472
					, @NewPT_XML		= @logSpData
					, @OldPT_XML		= @logSpData_Old
					, @duration			= @duration
			END CATCH
			UPDATE #tmpSMA SET isfinished = 1 WHERE isfinished = 0 AND RoleID = 4 AND Currency = @Currency AND CustID = @SuperID
			WAITFOR DELAY '00:00:00.100'
	END
	IF @ErrCode = 0
	BEGIN
		SET @ErrMsg=''
	END
	
	DROP TABLE #PTProduct
	DROP TABLE #SportTypeBetType
	DROP TABLE #tmpSMA 
	DROP TABLE #Dummy 	
	DROP TABLE #tmpSMATemp 
	DROP TABLE #tmpPT_Old 
	DROP TABLE #tmpAdjPT
	END
GO
