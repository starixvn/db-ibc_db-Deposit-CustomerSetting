/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet,Dot_member" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_CustomerInsMember_MAg]
	@custid int OUTPUT,
	@creator int,
	@username varchar(30),
	@userpwd varchar(40) = '123qwe',
	@mrecommend int, -- Master ID
	@IP varchar(15)='',
	@Language varchar(2)= 'E',
	@SubAccID int = 0, --Sub-AccountID
	@ErrCode int = 0 OUTPUT,
	@ErrMsg nvarchar(4000) = '' OUTPUT
AS
--@Source Control
/*
Created: 20120322@Dom
Task : Master create Agent
DB: DBTRANS.bodb02
Original:

Revisions:
    - 20121128@Elodie: Get an error message from f_Get_MsgNameByMsgID function by language
    - 20130604@Daniel: Change default P2P param value to "Disable P2P"
    - 20130607@Daniel: Exclude created member from Balance checking
    - 20130731@Elodie: Apply progressive bonus
	- 20130919@Don: Supporting save log of Number Game PT with format such as "0.995", "0.925", ...
	- 20131014@Francis: Support adding new virtual sports with settings via XML param
	- 20131108@Elodie: Splitting bodb02 into CustDB (call sport, bettype by link database)	
	- 20140505@Florent: Add sport HR Fix Odds
	- 20140512@Florent: Add new sport: 202 Keno
	- 20150309@Johnson: Disable virtual rate as default [RedmineID: #31927]
    - 20150609@David: Separate CustDB to DBCUST server (Use temp table for sports, bettype, GameType table, call some SPs by link server)
    - 20151028@Jim:Implement Muay's Setting for Deposit Customer [Redmine: #45491]
    - 20160830@Winnie: #63151  Add ColossusBet Agent commRate
    - 20170227@Winnie: Add Cash Out [Redmine:#72171]
    - 20170302@Helen: Betradar Virtual Sports  -Integration for Cash [Redmine: 77274]
    - 20170808@Winnie: Change Data Type of Sporttype [RedmineID: #73545]
	- 20180125@Winnie: Hide inactive products [RedmineID: #86086]
	- 20180514@Winnie: Hot fix Nap CashOut [RedmineID: #95079]
	- 20180717@Winnie: NAP - Enable Cash out: Adjust the setting to reflect 100% profit of Cash Out to group [RedmineID: #90870]
	- 20180326@Winnie: Customer Setting - urgent fix to support for long bettype name. [RedmineID: #91216]
	- 20180809@Sophia: HA - remove SP Lrf_CustomerInfoIns [Redmine: #99464]
	- 20181002@Dominic: Check existing username/username2 in archived DB  [Redmine:99882]
	- 20181108@Elodie: Migrate bodb_Licensee to DBCUST [Redmine:#99855]
	- 20190326@Winnie: Update PT of Sportsbook for All Licensee. [RedmineID: #110111]
	- 20190422@Elodie: Offer unique nickname for CN88 [Redmine:112287]
	- 20190429@Elodie: Insert VR setting get from Upline for new customer [RedmineID: #112657]
	- 20190726@Winnie: Remove Muay Thai. [RedmineID: #117501]
	- 20190920@Winnie: Fix bug log. [RedmineID: #120141]
	- 20191001@Eden: 3rd party products - Remove InActive Products Phase 2 [Redmine: #118699]
	- 20200622@Johnson: add Soccer Parlay bet limit [redmine: #135261]
	- 20201005@Winfred: Add new OddsAdj dummy customers [redmine:#142952]
	- 20201214@Winfred: Adjust PT value with 4 decimal places for SB  [redmine: #146574]
	- 20220112@Eden: LAP - RNG Casino - Implement DCS Settings [Redmine: #166217] 
	- 20220617@Johnson: define temp table to avoid dump db [redmine:#174035]
	- 20220301@Eden: Deposit - Sportsbook - Revise customer settings [Redmine: #167898] 
Param's Explanation:
• @ErrCode:
    = 0: Create agent successfully.
    > 0: Specific Error.
  
• @ErrMsg: Error description.

*/
BEGIN
	SET NOCOUNT ON

	declare @startRun datetime
	declare @endRun datetime
	declare @duration int
	set @startRun = getdate()

	--Check an account disabled or not 
	EXEC dbo.Acc_CustomerSelCheckEnable @custid = @mrecommend, @ErrCode=@ErrCode output,@ErrMsg=@ErrMsg output 
	if @ErrCode <>0		return 

	declare 
		@currency int, 
		@pwdexpiry datetime, 
		@site nvarchar(50),
		@srecommend int,	 
		@matchlimit smallmoney,
		@TransferOption_dec tinyint,
		@UplineClosed bit,
		@DisableOutright bit,
		@VirtualMultiplier SMALLMONEY

	select 
		@currency = currency, 
		@UplineClosed = closed,
		@srecommend = srecommend,
		@matchlimit = matchlimit,
		@DisableOutright = DisableOutright,
		@VirtualMultiplier = ci.VirtualMultiplier
	from CustInfo as ci with (NOLOCK) 
	where CustID = @mrecommend


	Select @ErrCode = 0

	SELECT @username = rtrim(ltrim(@username))

	DECLARE @IsExists BIT 
	EXEC Age_CustomerCheckExists @username = @username, @IsExists = @IsExists OUTPUT

	IF @IsExists = 1
	BEGIN
		SELECT @ErrMsg = CASE @Language 
							WHEN 'E' THEN 'This username is not available.'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](40001,@Language)
						END
		SELECT @ErrCode = 101		
		RETURN
	END
	SELECT @pwdexpiry = dateadd(dd, 30, getdate())

	--Dom@20120322
	select @site = site from customer with (nolock) where CustID = @srecommend

	--Vinh@20080213: get transfer option from master
	select	@TransferOption_dec = TransferOption from custmaster with (nolock) where CustID = @mrecommend

	--Insert general data 
	EXEC dbo.Acc_Dep_CustomerInsUserInfo
		@custid = @custid OUTPUT,
		@creator = @creator,
		@username = @username,
		@userpwd = @userpwd,
		@pwdexpiry = @pwdexpiry,
		@currency = @currency,
		@site = @site,
		@srecommend = @srecommend,
		@mrecommend = @mrecommend,
		@recommend = 0,
		@roleid = 2,
		@TransferOption = NULL,
		@suspended = 0,
		@closed=@UplineClosed,
		@DisableOutright = @DisableOutright,
		@matchlimit = @matchlimit,
		@virtualmultiplier = @VirtualMultiplier,
		
		@IsInternal = 0,
		@credit = 0,
		@maxcredit = 0,
		@IP = @IP,
		@TransferOption_dec = @TransferOption_dec,
		@Language = @Language,
		@ErrCode = @ErrCode OUTPUT,
		@ErrMsg = @ErrMsg OUTPUT

	if @ErrCode <> 0
		return

	 -------Insert Dep_AgentCommRate for ColossusBets
	 INSERT INTO Dep_AgentCommRate
			   ([CustID]
			   ,[Sporttype]
			   ,[Bettype]
			   ,CommRate)
	SELECT @custid, 204, 18001, 0.1215
	UNION ALL
	SELECT @custid, 204, 18002, 0.45

	----------------------CHECK Error
	 IF @@ERROR <> 0 
	 BEGIN 	
		EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
		DELETE Dep_AgentCommRate WITH(ROWLOCK) WHERE custid = @custid
 		RETURN 
	 END  

	-------Check & Insert for CashOut  
	IF EXISTS (SELECT TOP 1 1 FROM TradeComm t WITH(NOLOCK) 
				INNER JOIN custInfo c WITH(NOLOCK) ON t.AgentID=c.custid
				WHERE srecommend=@srecommend)
	BEGIN
		CREATE TABLE #tempCashOut(
				UserName varchar(30), recommend INT, mrecommend INT, currency TINYINT, site VARCHAR(10), refcode1 nvarchar(100)  
			 , refcode2 nvarchar(100), ugroup varchar(3), [closed] bit, [MatchLimit] smallmoney, [VirtualMultiplier] smallmoney, [Enabled] bit, [danger] TINYINT  
			 , [danger2] TINYINT, [danger3] TINYINT, [DisableOutright] BIT  
			 , [Abnormal] TINYINT, [DoubleCommLosing] BIT)  

		INSERT INTO #tempCashOut(
					UserName, recommend, mrecommend, currency, site, refcode1  
				 , refcode2, ugroup, [closed], [MatchLimit], [VirtualMultiplier], [Enabled], [danger]  
				 , [danger2], [danger3], [DisableOutright]  
				 , [Abnormal], [DoubleCommLosing]
				)  
		SELECT a.userName + 'CashOut' AS UserName, a.custid AS recommend, a.mrecommend, a.currency, a.site, a.refcode1
				, a.refcode2, a.ugroup, b.[closed], b.[MatchLimit], b.[VirtualMultiplier], b.[Enabled], b.[danger]
				, b.[danger2], b.[danger3], b.[DisableOutright]					
				, b.[Abnormal], b.[DoubleCommLosing]
		FROM Customer a(NOLOCK)
			INNER JOIN custInfo b(NOLOCK)
			ON a.custid = b.custid
		WHERE a.custid = @CustID
				
		INSERT INTO [dbo].[Customer] ([username], [username2], creatdate, creator, currency, roleid, srecommend, mrecommend
				, recommend, site, refcode1, refcode2, ugroup)
		SELECT [username], b.site + '$' + [username], GETDATE(), @creator, b.Currency, 1, @srecommend, b.mrecommend, b.recommend
			, b.site, refcode1, refcode2, ugroup
		FROM #tempCashOut b
				
		IF (@@ERROR <> 0)
		BEGIN
			SELECT @ErrMsg = 'Could not insert customer '

			RETURN
		END

		INSERT INTO [dbo].[custInfo] ([username], [custid], [currency], [roleid], [srecommend], [mrecommend], [recommend], [closed]
			, [MatchLimit], [VirtualMultiplier], [Enabled], [danger]
			, [danger2], [danger3], [DisableOutright]					
			, [Abnormal], [DoubleCommLosing], credit)
		SELECT a.[username], a.[custid], a.[currency], a.[roleid], a.[srecommend], a.[mrecommend], a.[recommend], b.[closed]
			, b.[MatchLimit], b.[VirtualMultiplier], b.[Enabled], b.[danger]
			, b.[danger2], b.[danger3], b.[DisableOutright]
			, b.[Abnormal], b.[DoubleCommLosing], 0
		FROM Customer(NOLOCK) a
			INNER JOIN #tempCashOut b
			ON a.username = b.username

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

		SELECT TOP 1 @tradeUserName = a.UserName, @tradeCustId = b.custid, @tradeAgentId = b.recommend
				, @tradeCurrency = b.currency, @tradeSite = b.site
		FROM #tempCashOut a
			INNER JOIN Customer b WITH (NOLOCK)
			ON a.username = b.username
			
		-- Insert Balance
		EXEC DBTXN.bodb02.dbo.Dot_BalanceInsCredit @CustID = @tradeCustID

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

			DELETE a
			FROM [TradeComm] a(NOLOCK)
				INNER JOIN #tempCashOut b
				ON a.AgentId = b.recommend

			EXEC DBTXN.bodb02.dbo.Dot_BalanceDelCredit @CustID = @tradeCustID --DELETE BalanceCredit WITH (ROWLOCK) WHERE custid = @custid   

			RETURN
		END

		EXEC DBTXN.bodb02.dbo.Dot_BalanceInsDebit @CustID = @tradeCustID

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

			DELETE a
			FROM [TradeComm] a(NOLOCK)
				INNER JOIN #tempCashOut b
				ON a.AgentId = b.recommend

			EXEC DBTXN.bodb02.dbo.Dot_BalanceDelCredit @CustID = @tradeCustID --DELETE BalanceCredit WITH (ROWLOCK) WHERE custid = @custid   

			EXEC DBTXN.bodb02.dbo.Dot_BalanceDelDebit @CustID = @tradeCustID

			RETURN
		END				

		--Set default player comm  
		EXEC bodb_Licensee.dbo.Lrf_CustomerSetDefaultComm @LicenseeName = @tradesite
			, @CustID = @tradeCustID, @ErrCode = @tradeErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT

		DELETE
		FROM #tempCashOut
		WHERE UserName = @tradeUserName
		--end Cashout	
	END

	---- check site offer OddAdj
	DECLARE @IsSiteOffer BIT,@PTDummy SMALLMONEY = 0,@CustIdOddAdj INT,@UsernameOddAdj VARCHAR(30)
	EXEC Acc_Dep_CustomerCheckOddsAdj @Site = @Site, @IsOffer = @IsSiteOffer OUTPUT
	IF @IsSiteOffer = 1
	BEGIN 
		
		SELECT @UsernameOddAdj = @Site + currency + '01OddsAdj'  
		FROM exchange with(nolock)
		WHERE ExchangeId = @Currency
		SET @IsExists = 0
		EXEC Age_CustomerCheckExists @username = @UsernameOddAdj, @IsExists = @IsExists OUTPUT

		IF @IsExists = 0
		BEGIN
			EXEC Acc_Dep_CustomerInsMember_Ag 
			@custid			=	@CustIdOddAdj output,
			@creator		=	@Creator,
			@username		=	@UsernameOddAdj,
			@userpwd		=	@Userpwd,
			@recommend		=	@Custid,
			@IP				=	@IP,
			@Language		=	@Language,
			@SubAccID		=	@SubAccID,
			@ErrCode		=	@ErrCode output,
			@ErrMsg			=	@ErrMsg output
		
		END
		  
	END 
	
	set @endRun = getdate()
	set @duration  = datediff (millisecond,@startRun,@endRun)

	Declare @LogSPData varchar(MAX)
	--Log customer info
	Select @LogSPData = '<Acc_Dep_CustomerInsMember_MAg custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +
	'creator="'+ coalesce(cast(@creator as varchar(50)),space(1)) + '" ' +
	'username="'+ coalesce(cast(@username as varchar(30)),space(1)) + '" ' +
	'mrecommend="'+ coalesce(cast(@mrecommend as varchar(50)),space(1)) + '" ' +
	'sitename="'+ coalesce(cast(@site as varchar(20)),space(1)) + '" ' +
	'IP="'+ coalesce(cast(@IP as varchar(15)),space(1)) + '" ' +
	'Language="'+ coalesce(cast(@Language as varchar(2)),space(1)) + '" ' +
	'SubAccName="'+ coalesce(cast(dbo.f_GetSubUsername(@SubAccID) as varchar(30)),space(1)) + '" ' +
	'ErrCode="'+ coalesce(cast(@ErrCode as varchar(50)),space(1)) + '" ' +
	'ErrMsg="'+ coalesce(cast(@ErrMsg as varchar(4000)),space(1)) + '" />'
	EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP 
		@UserID = @Creator,
		@CustID = @CustID,
		@ActionID = 2414,
		@TrackingValue = @LogSPData,
		@duration = @duration

	--Log Status
	Select @LogSPData = '<Acc_Dep_CustomerInsMember_MAg custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +
	'closed="'+ coalesce(cast(@UplineClosed as varchar(1)),space(1)) + '" ' +	
	'DisableOutright="'+ coalesce(cast(@DisableOutright as varchar(1)),space(1)) + '" />'

	EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP 
		@UserID = @Creator,
		@CustID = @CustID,
		@ActionID = 2204,
		@TrackingValue = @LogSPData,
		@duration = @duration

END
GO
GO
