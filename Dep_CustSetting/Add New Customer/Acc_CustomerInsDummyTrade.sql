/*<info serverAlias="DBCUST-CUSTDB" executers="wsv_nap,svc_tig" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_CustomerInsDummyTrade]
	 @ProductID INT	
	 ,@CustID INT
	 ,@UserID INT
	 ,@ErrMsg VARCHAR(100) = '' OUTPUT
	 ,@InsBalCustList varchar(MAX) = '' OUTPUT
AS
/*
	Created: 20170301@Winnie
	Task: Create trade account
	DB: DBCUST/CustDB
	Original:
	Revisions:
		- 20170227@Winnie: Add CashOut [RedmineID: #71727]
		- 20180717@Winnie: NAP - Enable Cash out: Adjust the setting to reflect 100% profit of Cash Out to group [RedmineID: #90870]
		- 20180809@Sophia: HA - remove SP Lrf_CustomerInfoIns [Redmine: #99464]
		- 20180924@Elodie: Migrate bodb_Licensee to DBCUST [Redmine:#99855]
		- 20190906@Eden: 3rd party products - Remove InActive Products Phase 2 [Redmine: #118699]
		- 20220112@Eden: LAP - RNG Casino - Implement DCS Settings [Redmine: #166217] 
		- 20220617@Johnson: define temp table to avoid dump db [redmine:#174035]
		- 20220301@Eden: Deposit - Sportsbook - Revise customer settings [Redmine: #167898] 
		- 20220722@Eden: LAP - Scale Out DBTrans  [redmine: #158293/#175297]
	Param's Explanation:
		- @InsBalCustList  --> cutsid list will call 2 sp insert balance on DBTRANS SiteDB: (ex: 'CustID1,CustID2')
                    EXEC bodb02.dbo.Dot_BalanceInsCredit @CustID = @CustID1/@CustID2
                    EXEC bodb02.dbo.Dot_BalanceInsDebit @CustID = @CustID1/@CustID2
*/
BEGIN
	SET NOCOUNT ON
	SET @InsBalCustList = ''

	IF (@ProductId = 25) -- CashOut
		BEGIN			
			DECLARE @tempAgent TABLE(CustID INT PRIMARY KEY,Username VARCHAR(30),Site VARCHAR(10))
			INSERT INTO @tempAgent(CustID)
			SELECT CustID
			FROM Customer WITH(NOLOCK) WHERE srecommend=@CustID AND RoleID=2
		
			UPDATE t SET t.Username=c.username,t.Site=c.Site
			FROM @tempAgent t
				INNER JOIN Customer c WITH(NOLOCK) ON t.CustID=c.custid
			
			DELETE FROM @tempAgent WHERE Username LIKE '%' + site + '%' + 'ACC%'
			
			DECLARE  @tempDummy TABLE(Username VARCHAR(30),AgentID INT , PRIMARY KEY(Username,AgentID))
			INSERT INTO @tempDummy(Username,AgentID)
			SELECT Username+ 'CashOut',CustID
			FROM @tempAgent
			
			DELETE t
			FROM @tempDummy t
				INNER JOIN Customer a(NOLOCK) ON t.UserName=a.UserName
				
			DELETE t
			FROM @tempDummy t
				INNER JOIN custsub a(NOLOCK) ON t.UserName=a.UserName
				
			DELETE t
			FROM @tempDummy t
				INNER JOIN custInfo a(NOLOCK) ON t.UserName=a.UserName
			
			CREATE TABLE #tempCashOut(Username varchar(30), recommend INT, mrecommend INT, currency INT, site varchar(10), refcode1 nvarchar(100)
				, refcode2 nvarchar(100), ugroup varchar(3), [closed] bit, [MatchLimit] INT, [VirtualMultiplier] SMALLINT, [Enabled] BIT, [danger] TINYINT
				, [danger2] TINYINT, [danger3] TINYINT, [DisableOutright] BIT
				, [Abnormal] TINYINT, [DoubleCommLosing] BIT)	
			
			INSERT INTO #tempCashOut(Username, recommend, mrecommend, currency, site, refcode1
				, refcode2, ugroup, [closed], [MatchLimit], [VirtualMultiplier], [Enabled], [danger]
				, [danger2], [danger3], [DisableOutright]
				, [Abnormal], [DoubleCommLosing])			
			SELECT t.Username, a.custid AS recommend, a.mrecommend, a.currency, a.site, a.refcode1
				, a.refcode2, a.ugroup, b.[closed], b.[MatchLimit], b.[VirtualMultiplier], b.[Enabled], b.[danger]
				, b.[danger2], b.[danger3], b.[DisableOutright]
				, b.[Abnormal], b.[DoubleCommLosing]
			FROM Customer a(NOLOCK)				
				INNER JOIN @tempDummy t	ON a.custid = t.AgentID		
				INNER JOIN custInfo b WITH(NOLOCK) ON t.AgentID=b.custid	
			
			INSERT INTO [dbo].[Customer] ([username], [username2], creatdate, creator, currency, roleid, srecommend, mrecommend
				, recommend, site, refcode1, refcode2, ugroup)
			SELECT [username], b.site + '$' + [username], GETDATE(), @UserId, b.Currency, 1, @CustId, b.mrecommend, b.recommend
				, b.site, refcode1, refcode2, 'a'
			FROM #tempCashOut b
			WHERE NOT EXISTS (
					SELECT TOP 1 1
					FROM Customer(NOLOCK)
					WHERE username = b.username
					)

			IF (@@ERROR <> 0)
			BEGIN
				SELECT @ErrMsg = 'Could not insert customer'

				RETURN
			END

			INSERT INTO [dbo].[custInfo] ([username], [custid], [currency], [roleid], [srecommend], [mrecommend], [recommend], [closed]
				, [MatchLimit], [VirtualMultiplier], [Enabled], [danger]
				, [danger2], [danger3], [DisableOutright]
				, [Abnormal], [DoubleCommLosing], credit)
			SELECT a.[username], a.[custid], a.[currency], a.[roleid], a.[srecommend], a.[mrecommend], a.[recommend], b.[closed]
				, b.[MatchLimit], b.[VirtualMultiplier], b.[Enabled], b.[danger]
				, b.[danger2], b.[danger3], b.[DisableOutright]
				, b.[Abnormal]
				, b.[DoubleCommLosing], 0
			FROM Customer(NOLOCK) a
				INNER JOIN #tempCashOut b
				ON a.username = b.username
			WHERE NOT EXISTS (
					SELECT TOP 1 1
					FROM custInfo(NOLOCK)
					WHERE username = CAST(a.username AS NVARCHAR(50))
						OR custid = a.custid
					)

			IF (@@ERROR <> 0)
			BEGIN
				SELECT @ErrMsg = 'Could not insert custinfo'

				DELETE a
				FROM Customer a(NOLOCK)
					INNER JOIN #tempCashOut b
					ON a.username = b.username

				DELETE a
				FROM custInfo a(NOLOCK)
					INNER JOIN #tempCashOut b
					ON a.username = b.username

				RETURN
			END

			INSERT INTO [dbo].[TradeCust] ([Custid],VendorID)
			SELECT b.[Custid],14
			FROM #tempCashOut a
				INNER JOIN Customer(NOLOCK) b
				ON a.username = b.username
			WHERE NOT EXISTS (
					SELECT TOP 1 1
					FROM [TradeCust](NOLOCK)
					WHERE custid = b.custid
					)

			IF (@@ERROR <> 0)
			BEGIN
				SELECT @ErrMsg = 'Could not insert TradeCust'

				DELETE a
				FROM Customer a(NOLOCK)
					INNER JOIN #tempCashOut b
					ON a.username = b.username

				DELETE a
				FROM custInfo a(NOLOCK)
					INNER JOIN #tempCashOut b
					ON a.username = b.username

				DELETE a
				FROM [TradeCust] a(NOLOCK)
					INNER JOIN Customer(NOLOCK) c
					ON a.custid = c.Custid
					INNER JOIN #tempCashOut b
					ON c.username = b.username

				RETURN
			END

			INSERT INTO [dbo].[TradeComm] ([Agentid], [IsBA], [TradeComm], [Licenseecomm],HouseDeductionRate,HousePT,VendorID)
			SELECT a.recommend, 0, 0.03, 0.03,0.03,1,14
			FROM #tempCashOut a
			WHERE NOT EXISTS (
					SELECT TOP 1 1
					FROM [TradeComm](NOLOCK)
					WHERE [Agentid] = a.recommend
						AND [IsBA] = 0
					)

			IF (@@ERROR <> 0)
			BEGIN
				SELECT @ErrMsg = 'Could not insert TradeComm'

				DELETE a
				FROM Customer a(NOLOCK)
					INNER JOIN #tempCashOut b
					ON a.username = b.username

				DELETE a
				FROM custInfo a(NOLOCK)
					INNER JOIN #tempCashOut b
					ON a.username = b.username

				DELETE a
				FROM [TradeCust] a(NOLOCK)
					INNER JOIN Customer(NOLOCK) c
					ON a.custid = c.Custid
					INNER JOIN #tempCashOut b
					ON c.username = b.username

				DELETE a
				FROM [TradeComm] a(NOLOCK)
					INNER JOIN #tempCashOut b
					ON a.AgentId = b.recommend
				WHERE IsBA = 0

				RETURN
			END

			INSERT INTO [dbo].[TradeComm] ([Agentid], [IsBA], [TradeComm], [Licenseecomm],HouseDeductionRate,HousePT,VendorID)
			SELECT a.recommend, 1, 0.03, 0,0.03,1,14
			FROM #tempCashOut a
			WHERE NOT EXISTS (
					SELECT TOP 1 1
					FROM [TradeComm](NOLOCK)
					WHERE [Agentid] = a.recommend
						AND [IsBA] = 1
					)

			IF (@@ERROR <> 0)
			BEGIN
				SELECT @ErrMsg = 'Could not insert TradeComm'

				DELETE a
				FROM Customer a(NOLOCK)
					INNER JOIN #tempCashOut b
					ON a.username = b.username

				DELETE a
				FROM custInfo a(NOLOCK)
					INNER JOIN #tempCashOut b
					ON a.username = b.username

				DELETE a
				FROM [TradeCust] a(NOLOCK)
					INNER JOIN Customer(NOLOCK) c
					ON a.custid = c.Custid
					INNER JOIN #tempCashOut b
					ON c.username = b.username

				DELETE a
				FROM [TradeComm] a(NOLOCK)
					INNER JOIN #tempCashOut b
					ON a.AgentId = b.recommend

				RETURN
			END

			DECLARE @tradeUserName VARCHAR(50), @tradeCustId INT, @tradeAgentId INT, @tradeCurrency INT
				, @tradeSite VARCHAR(100), @tradeErrCode VARCHAR(100)

			WHILE EXISTS (
					SELECT TOP 1 1
					FROM #tempCashOut
					)
			BEGIN
				SELECT TOP 1 @tradeUserName = a.UserName, @tradeCustId = b.custid, @tradeAgentId = b.recommend
					, @tradeCurrency = b.currency, @tradeSite = b.site
				FROM #tempCashOut a
					INNER JOIN Customer b WITH (NOLOCK)
					ON a.username = b.username

				---------------------------------------------------------------------------------  
				--Set default player comm  
				EXEC bodb_Licensee.dbo.Lrf_CustomerSetDefaultComm @LicenseeName = @tradesite
					, @CustID = @tradeCustID, @ErrCode = @tradeErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT

				DELETE
				FROM #tempCashOut
				WHERE UserName = @tradeUserName

				--Output custlist to insertbalance
				SELECT @InsBalCustList = @InsBalCustList + ISNULL(',' + CONVERT(VARCHAR,@tradeCustID), '')
			END
					--end Cashout
					--end Cashout		
		END
		SET @InsBalCustList = STUFF(@InsBalCustList,1,1,'')
END

GO
