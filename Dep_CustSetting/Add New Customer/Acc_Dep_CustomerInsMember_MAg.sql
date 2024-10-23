/*<info serverAlias="DBCUST-CUSTDB" executers="wsv_nap" viewers="" isFunction="0"></info>*/
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
	@ErrMsg nvarchar(4000) = '' OUTPUT,
	@ErrExtraInfo VARCHAR(MAX) = '' OUTPUT -- Log DB
AS
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
	- 20220722@Eden: LAP - Scale Out DBTrans  [redmine: #158293/#175297]
	- 20221207@Tacy: Remove columns and code used by Colossus Bets, GD product [RedmineID: #188096]
	- 20240715@Johnson: Apply In-house Replication for Deposit Customer Setting [redmine:#207025]
	- 20240701@Winfred: Scale Out DBCUST - Apply In-house Replication for Virtual Rate Setting  [redmine: #207029]
	- 20240705@Eden  : Scale out DBCUST - Licensee Customer in GlobCustDB [redmine: #207474]

Param's Explanation:
	- @ErrCode:
		= 0: Create agent successfully.
		> 0: Specific Error.
  
	- @ErrMsg: Error description.

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


	SELECT @ErrCode = 0
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
		@ErrMsg = @ErrMsg OUTPUT,
		@ErrExtraInfo = @ErrExtraInfo OUTPUT

	IF @ErrCode <> 0
		RETURN
	
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
