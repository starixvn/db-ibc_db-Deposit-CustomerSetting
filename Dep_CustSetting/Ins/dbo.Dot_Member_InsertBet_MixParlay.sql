USE [bodb02]
GO
/****** Object:  StoredProcedure [dbo].[Dot_Member_InsertBet_MixParlay_Test]    Script Date: 06/26/2012 02:32:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.Dot_Member_InsertBet_MixParlay    Script Date: 4/24/2012 10:51:55 PM ******/
ALTER PROCEDURE [dbo].[Dot_Member_InsertBet_MixParlay]
	@custid int,			-- Customer ID
	-- BetInfo ------------------------------------------
	@matchIdInfo varchar(1000),     -- Match ID list
	@oddIdInfo varchar(1000),       -- Odd ID list
	@oddValueInfo varchar(1000),    -- Odd's value list
	@FinValueInfo varchar(1000),    -- Curr Odd's value list -- modif on 2011-6-8 new add
	@betTeamInfo varchar(1000),     -- Betted team list
	@hdp1 varchar(1000),			-- hdp1 list
	@hdp2 varchar(1000),			-- hdp2 list
	@HomeScoreInfo varchar(1000),    -- Live Home Score list
	@AwayScoreInfo varchar(1000),    -- Live Away Score list
	@NewOfferSetupInfo varchar(1000), -- Check is H.Time list
	-----------------------------------------------------
	@stake float,                   -- Stake
	@creator nvarchar(50),
	@NumOfBet int, 			-- in asp code : iCnt = request.form("count")
	@BetFrom nvarchar(1)='i',
	@language nvarchar(10) ='E',
	@BET_IP nvarchar(20),
	@oddstype tinyint = 1,
	@bettype smallint = 9,
	@betteam nvarchar(10) = N'',
	@SettingSporttype tinyint,  
	@mixodds float,				
	@date datetime,				
	@fail bit=0 output,
	@creditcheck nvarchar(10)='' output,	-- in asp code : creditcheck.asp,
	@ErrMsg nvarchar(500)='' output,
	@refno bigint=0 output,
	@transid2 bigint = 0,
	@isLicensee bit = 0
AS
/*	
Task: main SP for Place Bet Mix Parlay

History:
	- 20101026@Thien: Apply new Mix-Sport setting
	- 20110305@Thien: to add more check: number of combination must be greater than 2	
	- 20110719@Jack Chang (Trans db): add @HomeScoreInfo & @AwayScoreInfo input data then insert livehomescore & liveawayscore to bettransm table
	- 20110719@Jack Chang (Trans db): status is waitting when liveindicator true
	- 20110907@Jack Chang (Trans db): add @NewOfferSetupInfo input data when it is true insert status = 'running' to bettransm table
	- 20110922@Vivi(DBTRANS): change WHERE bettype = 9 to WHERE matchid = 9 and bettype = 9(for using better index)
	- 20111006@Joe Huang (Trans db): check maxpermatch add bettype 29
	- 20111019@Victor(DBTRANS): add @starttime how much time do PROCEDURE execute 	
	--20111124@TWJoe(DBTRANS): add transid2 for white label
    --20111204@TWJoe(DBTRANS): system parlay fix MaxPerMatch & balance
    --20111229@Joe: add insert bettrans to support account site new requirement(Catagorize Mix Parlay by Live/Dead Ball and Sport types)
		livehomescore: 0-dead ball / 1-live ball / 2-dead ball + live ball
		liveawayscore: 1-soccer / 2-other sport / 3-multi sports
		and bettransm.oddsspread: sporttype
	--20120409@Victor(DBTRANS): call update balance table SPs
	- 20120424@Kiwi: Change to use Dep_CustSetting
*/
SET NOCOUNT ON
BEGIN

----------------------------------------------------------------------------------------------------------
-- Get Customer Info   --   DECLARE @ParlayMatchSetting TABLE (MatchID int, BetType smallint, enable bit, DisplayMode tinyint,OddsID bigint)
----------------------------------------------------------------------------------------------------------
	declare 
		@MinPayout float,
		@actualrate float,
		@recommend int,
		@mrecommend int,
		@srecommend int,
		@virtualrate float,
		@otpositiontaking float,
		@oapositiontaking float,
		@ompositiontaking float,
		@ospositiontaking float,
		@sdiscount float,
		@discount float,
		@adiscount float,
		@playerdiscount float,
		@currency int,
		@MaxPerMatch money,
		@reject bit,
		@username nvarchar(50),
		@CurrencyName nvarchar(10),
		@custid_get int,
		@betcheck nvarchar(50),
		@transid bigint ,
		@MaxPayout float,
		@starttime datetime

    set @transid = 0
	set @starttime=CURRENT_TIMESTAMP
----------------------------------------------------------------------------------------------------------
-- Credit check
----------------------------------------------------------------------------------------------------------
	declare @finalbalance float, @latestbettime datetime
	select @custid_get = null, @creditcheck = '', @finalbalance = 0

	select @custid_get = ci.custid, @finalbalance = isnull(sum(isnull(b.winlost, 0) - isnull(b.actual_stake, 0) + isnull(b.playercomm, 0)), 0) + isnull(ci.Credit, 0)
	from 
		custinfo as ci with (nolock)
		left join bettrans as b with (nolock) on ci.custid=b.custid  
	where ci.custid=  @custid and ci.closed=0 
	group by ci.custid, ci.credit
	
	select @latestbettime=max(transdate)
	from bettrans with (NOLOCK)
	where matchid in (9,29) and custid = @custid and bettype in (9,29)

	if @latestbettime is not null and @latestbettime>dateadd(ss,-2,getdate())
	begin

		select @ErrMsg = case @Language 
				when 'E' then 'Sorry. Odds changed.'
				when 'J' then N'Sorry. Odds changed.'
				when 'CS' then N'Sorry. Odds changed.'
				else N'Sorry. Odds changed.'
				end
		set @fail = 1 
		return
	end

	if (@custid_get is null)	
	begin
		if (@language = 'E') 
			set @ErrMsg = 'This customer cannot bet.'
		else 
			set @ErrMsg = 'This customer cannot bet.'
		set @fail = 1 
		return 
	end
	Declare @bitmap smallint, @subTicketCnt int
	set @subTicketCnt = 1
	IF @bettype = 29
	BEGIN
		SET @bitmap = dbo.ConvertToValue(@betteam, 2)
		SELECT @subTicketCnt = SUM(cnt) FROM dbo.RefCombinationSet with (nolock)
			WHERE N = @NumOfBet AND (bitmap & @bitmap) > 0
	END
	if (@finalbalance - @stake * @subTicketCnt >= 0)
		set @creditcheck = 'ok'
	else
	begin

		select @ErrMsg = case @Language 
				when 'E' then 'Sorry, You are having credit problem. This is due to insufficient fund or you have exceeded your credit limit.'
				when 'J' then N'ベットポイントはベット可能Ptsより多きため受付けられません。'
				when 'CS' then N'Sorry, You are having credit problem. This is due to insufficient fund or you have exceeded your credit limit.'
				else N'Sorry, You are having credit problem. This is due to insufficient fund or you have exceeded your credit limit.'
				end
		set @creditcheck = 'failed'	
		set @fail = 1 
		return
	end


------------------------^^^^^-------------------------------	
	IF (@isLicensee = 1)
	BEGIN	
		select
			@username = ci.username,
			@recommend = ci.recommend,
			@mrecommend = ci.mrecommend,
			@srecommend = ci.srecommend,
			@actualrate = exchange.actualrate,
			--@virtualrate = exchange.actualrate * IsNull(ci.VirtualMultiplier, 1),
			@virtualrate = exchange.actualrate, ---- 2009-3-9(Michael): withdraw virtual currency on mix parlay, correct score & total goal.(Vivi)	
			@oapositiontaking = cs.apositiontaking,
			@ompositiontaking = cs.mpositiontaking,
			@ospositiontaking = cs.spositiontaking,
			@sdiscount = cs.sdiscount,
			@discount = cs.discount,
			@adiscount = cs.adiscount,
			@playerdiscount = cs.playerdiscount,
			@currency = ci.currency,
			@minpayout = (case when exchange.minbet<cs.minbet then cs.minbet else exchange.minbet end)/4,
			@maxpermatch = IsNull(CASE @SettingSporttype 
				WHEN 1 THEN ci.maxpermatch 								
				ELSE MaxPerMatch99MP END, 0),--Apply new Mix-Sport setting
			@reject = reject,
			@CurrencyName = exchange.currency
		from 
			custinfo as ci with (nolock) 
			inner join Dep_CustSetting as cs with (nolock) on ci.custid = cs.custid and cs.bettype=9 and cs.sporttype=@SettingSporttype
			inner join  exchange with (nolock) on ci.currency=exchange.exchangeid 
		where ci.custid=@custid
	END
	ELSE
	BEGIN
		select
			@username = ci.username,
			@recommend = ci.recommend,
			@mrecommend = ci.mrecommend,
			@srecommend = ci.srecommend,
			@actualrate = exchange.actualrate,
			--@virtualrate = exchange.actualrate * IsNull(ci.VirtualMultiplier, 1),
			@virtualrate = exchange.actualrate, ---- 2009-3-9(Michael): withdraw virtual currency on mix parlay, correct score & total goal.(Vivi)	
			@oapositiontaking = cs.apositiontaking,
			@ompositiontaking = cs.mpositiontaking,
			@ospositiontaking = case when srecommend <= 100 then 0 else cs.spositiontaking end,
			@sdiscount = case when srecommend<=100 then cs.adiscount else cs.sdiscount end,
			@discount = cs.discount ,
			@adiscount = cs.adiscount ,
			@playerdiscount = cs.playerdiscount,
			@currency = ci.currency,
			@minpayout = (case when exchange.minbet<cs.minbet then cs.minbet else exchange.minbet end)/4,
			@maxpermatch = IsNull(CASE @SettingSporttype 
				WHEN 1 THEN ci.maxpermatch 								
				ELSE MaxPerMatch99MP END, 0),--Apply new Mix-Sport setting
			@reject = reject,
			@CurrencyName = exchange.currency
		from 
			custinfo as ci with (nolock) 
			inner join custsetting as cs with (nolock) on ci.custid = cs.custid and cs.bettype=9 and cs.sporttype=@SettingSporttype
			inner join  exchange with (nolock) on ci.currency=exchange.exchangeid 
		where ci.custid=@custid
	END

--set @minpayout = 1 for 12Bet, asiabet88, mansion88, alog site...(all licensee)
if exists(select 1 from customer with (nolock) where custid = @srecommend and site in ('12Bet', 'asiabet88', 'mansion88', 'alog', 'TLC', 'spondemo', 'SunGame', 'Mayfair', 'DELA', 'zzun88', 'bezbet', 'Bodog', 'haifa', 'SG8', 'Vwin', 'Tycoon', 'Sungame','Macaubet','Ibobet'))
BEGIN
	select @minpayout = 1
END
----------------------------------------------------------------------------------------------------------
-- Check Before Inserting Bet List to bettransm
----------------------------------------------------------------------------------------------------------

--2008-06-12: Suspend feature (Thien)
IF @reject = 1
BEGIN
	select @fail = 1
	select @ErrMsg = 'Odds suspended'
	return
END	
-------------

---------------------- Check whether include this ticket will exceed max per match -----------------------------
Declare @RunningStake money
SELECT @RunningStake = SUM(stake) FROM bettrans (nolock)
WHERE matchid in (9,29) AND custid = @custid and bettype in (9,29) AND ruben = 0
	and oddsid = @SettingSporttype --Apply new Mix-Sport setting

-- System Maximum is 100k RM
IF IsNull(@MaxPerMatch, 0) * @actualrate > 100000 SET @MaxPerMatch = 100000 / @actualrate
IF (IsNull(@RunningStake, 0) + @Stake * @subTicketCnt) > IsNull(@MaxPerMatch, 0)
begin
	select @fail = 1
	select @ErrMsg = 'Over max-per-match'
	return
end	


---------------------- Check MaxBet and MinBet -------------------------------------------------------

if (@stake < @MinPayout )
begin
	select @fail = 1
	select @ErrMsg = case @Language 
				when 'E' then 'The stake is less than the minimum bet allowed {' + convert(varchar(30), @MinPayout) + N'.'
				when 'J' then N'ベットポイントがミニマムベットより低いです{' + convert(varchar(30), @MinPayout) + N'}'
				when 'CS' then N'The stake is less than the minimum bet allowed {' + convert(varchar(30), @MinPayout) + N'.'
				else N'The stake is less than the minimum bet allowed {' + convert(varchar(30), @MinPayout) + N'.'
			end
	return
end
---------------------- Check Max payout -------------------------------------------------------

select @MaxPayout = VValue from SystemSettings with (nolock) where VName = 'MMaxPayout'

if (@stake*@actualrate*@mixodds > @MaxPayout )
begin
	select @fail = 1
	select @ErrMsg = case @Language 
				when 'E' then 'The stake exceeded maximum payout.' 
				when 'J' then N'  ベットポイントがマックスベットより大きいです{'+ convert(nvarchar(30), convert(money, @MaxPayOut/@mixodds/@actualrate)) +N'}'
				when 'CS' then N'The stake exceeded maximum payout.' 
				else N'The stake exceeded maximum payout.' 
			end
	return
end		

---------------------- Check for odd value changed ----------------------------------------------------

BEGIN TRANSACTION
	declare @refn int
	UPDATE ref with (rowlock,updlock) SET @refn=refno=refno+1  WHERE  refid='refno'
	set @refno = @refn + 100000000000
COMMIT TRANSACTION


Declare @rowcnt int, @err int
Declare @bmInserted TABLE (liveindicator bit, sporttype tinyint)
Declare @cntSoccer int, @cntOthers int, @cntLive int, @cntDead int, @codeLiveHome smallint, @codeLiveAway smallint
Declare @TotalStake money

BEGIN TRANSACTION
	----------------------- Insert Bet Infomation into table Bettransm ---------------------------------

	INSERT INTO bettransm (
		custid, oddsid, hdp1, hdp2, odds, betteam, [status], statusID, 
		finalodds, livehomescore, liveawayscore,
		stake, refno, creator, betfrom, tpositiontaking, apositiontaking, mpositiontaking, spositiontaking,
		playerdiscount, discount, adiscount, sdiscount, actualrate, comstatus, matchid, matchdate, 
		bettype, liveindicator, oddsspread) 
	OUTPUT inserted.liveindicator, inserted.oddsspread INTO @bmInserted (liveindicator, sporttype) 
	SELECT 
		@custid, o.val as oddsid, 
		case when bettype in (4,16) then left(replace(lower(b.val),'''',''), 1) else isnull(h1.val,0.0) end AS hdp1,
		case when bettype in (4,16) then right(replace(lower(b.val),'''',''), 1) else isnull(h2.val,0.0) end AS hdp2,
		convert(smallmoney,ov.val) as odds, replace(lower(b.val),'''','') AS betteam, 
		case when odds.liveindicator = 1 and convert(bit, ht.val) <> 1 then 'waiting' else 'running' end,
		case when odds.liveindicator = 1 and convert(bit, ht.val) <> 1 then 1 else 0 end,
		convert(smallmoney,fv.val) as finalodds, isnull(sh.val, 0), isnull(sa.val, 0),
		@stake, @refno, @creator, @BetFrom, 
		@otpositiontaking, @oapositiontaking, @ompositiontaking, @ospositiontaking,
		@playerdiscount, @discount, @adiscount, @sdiscount,
		@actualrate, @refno, match.matchid, match.eventdate, 
		odds.bettype, odds.liveindicator, match.sporttype
	from --dbo.strsplit(@matchIdInfo,',') as m inner join 
	dbo.strsplit(@oddIdInfo,',') as o --on m.rank=o.rank
	inner join odds on odds.oddsid=convert(int,o.val)
	inner join match on match.matchid = odds.matchid --convert(int,m.val)
	
	inner join dbo.strsplit(@oddValueInfo,',') as ov on o.rank=ov.rank
	inner join dbo.strsplit(@betteamInfo,',') as b on o.rank=b.rank
	inner join dbo.strsplit(@FinValueInfo,',') as fv on o.rank=fv.rank
	inner join dbo.strsplit(@hdp1,',') as h1 on o.rank=h1.rank
	inner join dbo.strsplit(@hdp2,',') as h2 on o.rank=h2.rank
	inner join dbo.strsplit(@HomeScoreInfo,',') as sh on o.rank = sh.rank
	inner join dbo.strsplit(@AwayScoreInfo,',') as sa on o.rank = sa.rank
	inner join dbo.strsplit(@NewOfferSetupInfo,',') as ht on o.rank = ht.rank

	SELECT @rowcnt = @@ROWCOUNT, @err = @@ERROR
	
	SELECT
		@cntLive = SUM(case liveindicator WHEN 1 THEN 1 ELSE 0 END),
		@cntDead = SUM(case liveindicator WHEN 1 THEN 0 ELSE 1 END),
		@cntSoccer = SUM(case sporttype WHEN 1 THEN 1 ELSE 0 END),
		@cntOthers = SUM(case sporttype WHEN 1 THEN 0 ELSE 1 END)
	FROM @bmInserted
	
	SET @codeLiveHome = CASE WHEN @cntLive = 0 THEN 0 WHEN @cntDead = 0 THEN 1 ELSE 2 END
	SET	@codeLiveAway = CASE WHEN @cntOthers = 0 THEN 1 WHEN @cntSoccer = 0 THEN 2 ELSE 3 END

	-------------------------------------- Check Error -----------------------------------------------

	if (@rowcnt=0 or @err<>0)
	begin
		select @fail = 1

		if (@language = 'E' )	
		BEGIN
			set @ErrMsg = 'Betting transaction is failed. Please try again...' + convert(varchar(10),@@error)
		END
		else
		BEGIN
			set @ErrMsg = 'Betting transaction is failed. Please try again...' + convert(varchar(10),@@error)
		END
		rollback tran
		return
	end
	select @otpositiontaking = isnull(@ospositiontaking, 0) + isnull(@ompositiontaking, 0) + isnull(@oapositiontaking, 0)


	if (@NumOfBet > 1 )
	begin

		----------------- Insert into table Bettrans --------------------------------------		
		--Thien@20101026: change to insert @SettingSporttype in OddsID to check the max per match based on Sports (for Apply new Mix-Sport setting)
		IF @bettype = 9
		BEGIN
			SET @betcheck = 'm'+convert(varchar(20), @NumOfBet)
			
			-- update debitbal 
			exec Dot_BalanceUpdDebit @custid, @stake, 1	
			
			INSERT INTO dbo.bettrans (
				custid, oddsid, matchid, bettype, hdp1, hdp2, odds, betteam, stake, actual_stake, [status], statusID,
				refno, creator, betfrom, winlostdate, actualrate, virtualrate, comstatus,
				tpositiontaking, apositiontaking, mpositiontaking, spositiontaking,
				playerdiscount, discount, adiscount, sdiscount, recommend, mrecommend, srecommend, 
				currency, ip, betcheck, username, currencyName, livehomescore, liveawayscore, oddstype,  balance, transid2)  		
			select @custid, @SettingSporttype, 9, 9, 0.0, 0.0, @mixodds, 'a', @stake, @stake, 'running', 0, 
				@refno, @creator,@BetFrom, @date, @actualrate ,@virtualrate, 'm',
				@otpositiontaking, @oapositiontaking, @ompositiontaking, @ospositiontaking,
				@playerdiscount, @discount, @adiscount, @sdiscount, @recommend ,@mrecommend, @srecommend, 
				@currency, @BET_IP,@betcheck, @username, @currencyName, @codeLiveHome, @codeLiveAway, @oddstype, @finalbalance, @transid2
		
			SELECT @rowcnt = @@ROWCOUNT, @err = @@ERROR
		END ELSE IF @bettype = 29
		BEGIN
			
			-- update debitbal 
			select @TotalStake = @stake * @subTicketCnt
			exec Dot_BalanceUpdDebit @custid, @TotalStake, 1
			
			INSERT INTO dbo.bettrans (
				custid, oddsid, matchid, bettype, hdp1, hdp2, odds, betteam, stake, actual_stake, [status], statusID,
				refno, creator, betfrom, winlostdate, actualrate, virtualrate, comstatus, betid, 
				tpositiontaking, apositiontaking, mpositiontaking, spositiontaking, 
				playerdiscount, discount, adiscount, sdiscount, recommend, mrecommend, srecommend,
				currency, ip, betcheck, username, currencyName, livehomescore, liveawayscore, oddstype, balance, transid2)  		
			select @custid, @SettingSporttype, 29, 29, @subTicketCnt, @bitmap,
				@mixodds, @betteam, @TotalStake, @TotalStake, 'running', 0,
				@refno, @creator,@BetFrom, @date, @actualrate ,@virtualrate, 'm',  0,
				@otpositiontaking, @oapositiontaking, @ompositiontaking, @ospositiontaking,
				@playerdiscount, @discount, @adiscount, @sdiscount, @recommend ,@mrecommend, @srecommend,
				@currency, @BET_IP,@betcheck, @username, @currencyName, @codeLiveHome, @codeLiveAway, @oddstype, @finalbalance,@transid2
		
			SELECT @rowcnt = @@ROWCOUNT, @err = @@ERROR
		END
		------------------------ Check Error -----------------------------------------------

		if (@rowcnt =0 or @err <> 0)
		begin
			select @fail = 1
			if (@language = 'E' )	
			begin
				set @ErrMsg = 'Betting transaction is failed. Please try again...'
				-- old message: Insert into Bettrans. Unsucessful....
			end
			else
			begin
				set @ErrMsg = 'Betting transaction is failed. Please try again...'
			end
			rollback transaction
			return
		end
		else
		begin
            select @transid = scope_identity()
		end

	end
	else	
	begin
		select @fail = 1
	end
	if (@fail = 1)
	begin
		rollback tran	
	end
	else
	begin
		commit tran
	end
END

------------------------ 20081117 write log ------------------------ 
Declare @spname varchar(100)
Declare @hostname varchar(100)
SET @spname = OBJECT_NAME(@@PROCID)
SET @hostname = HOST_NAME()

declare @from nvarchar(50), @str nvarchar(500)
SELECT @from = CASE @betfrom 
	WHEN 'p' THEN 'phone'
	WHEN 'h' THEN 'mobile'
	when 'd' THEN 'deposit'
	WHEN 'w' THEN 'wap'
	WHEN 'm' THEN 'dep-wap'
	WHEN 'i' THEN 'internet'
	WHEN 't' THEN 'test'
	WHEN 'e' THEN 'Europe'
	WHEN 's' THEN 'smartphone'
	ELSE 'unknown (' + isnull(@betfrom,'') + ')' END

SELECT @str=left(
	@from + CASE @bettype WHEN 9 THEN N' PARLAY' WHEN 29 THEN N' COMBO:' + @betteam END + N' betting custid:' + cast(isnull( @custid,'x') as nvarchar(10)) 
	+ N' oddsid:' +  isnull( @oddIdInfo,'x')  
	+ N' at ' + isnull(@oddValueInfo,'x') + ' bet ' + isnull(@betTeamInfo,'x')
	-- + N' matchid: ' + isnull(@matchIdInfo,'x') -- remove, since can refer by oddsid
	+ N' stake:' + CONVERT(nvarchar(50),isnull(@stake,0)) 
	+ N' refno:' +cast(isnull( @refno,'x') as nvarchar(12)) 
	+ N' ip:' + cast(isnull(@BET_IP,'x') as nvarchar(16))
	+ N' (' + CAST(DATEDIFF(millisecond, @StartTime, CURRENT_TIMESTAMP) as nvarchar(50)) + ' ms) '
	+ N' (call ' + ISNULL(@spname, '--') + ' via ' + ISNULL(@hostname, '--') + ')'
	+ N' transid2:' + cast(isnull(@transid2,0) as nvarchar(20)) 
	, 300)
exec logfile @custid, @str

select @transid as TransID



GO
GRANT VIEW DEFINITION ON [dbo].[Dot_Member_InsertBet_MixParlay] TO [vnteam]