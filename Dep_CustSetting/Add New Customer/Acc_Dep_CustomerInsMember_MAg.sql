/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet,Dot_member" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_CustomerInsMember_MAg]
	@custid int OUTPUT,
	@creator int,
	@username varchar(30),
	@userpwd varchar(40) = '123qwe',
	@mrecommend int, -- Master ID
	
	--number game status
	@DisableNumber bit = 0,	

	@MinBetv1 money,
	@MaxBetv1 money,
	@MaxPerMatchv1 money,
	
	@MinBetv2 money,
	@MaxBetv2 money,
	@MaxPerMatchv2 money,

	@MinBetv3 money,
	@MaxBetv3 money,
	@MaxPerMatchv3 money,

	@MinBetv5 money,
	@MaxBetv5 money,
	@MaxPerMatchv5 money,

	@MinBetv8 money,
	@MaxBetv8 money,
	@MaxPerMatchv8 money,

	@MinBetv10 money,
	@MaxBetv10 money,
	@MaxPerMatchv10 money,

	@MinBetv11 money,
	@MaxBetv11 money,
	@MaxPerMatchv11 money,
	
	@MinBetv99 money,
	@MaxBetv99 money,
	@MaxPerMatchv99 money,
	
	-- mix parlay of mixed sports
	@MinBetv1mp money =0,
	@MaxBetv1mp money =0,
	@MaxPerMatchv1mp money =0,
	
	@MinBetv99mp money,
	@MaxBetv99mp money,
	@MaxPerMatchv99mp money,


	-- number game
	@MinBetv161 money,
	@MaxBetv161 money,
	@MaxPerMatchv161 money,

	@MaxPerBallv161 money = 0,	


	@v1apositiontaking_1 smallmoney,
	@v1apositiontaking_2 smallmoney,
	@v1apositiontaking_3 smallmoney,
	@v1apositiontaking_4 smallmoney,
	@v1apositiontaking_5 smallmoney,
	@v1apositiontaking_6 smallmoney,
	@v1apositiontaking_7 smallmoney,
	@v1apositiontaking_8 smallmoney,
	@v1apositiontaking_9 smallmoney,
	@v1apositiontaking_10 smallmoney,
	
	@v1mpositiontaking_1 smallmoney,
	@v1mpositiontaking_2 smallmoney,
	@v1mpositiontaking_3 smallmoney,
	@v1mpositiontaking_4 smallmoney,
	@v1mpositiontaking_5 smallmoney,
	@v1mpositiontaking_6 smallmoney,
	@v1mpositiontaking_7 smallmoney,
	@v1mpositiontaking_8 smallmoney,
	@v1mpositiontaking_9 smallmoney,
	@v1mpositiontaking_10 smallmoney,
	
	@v1alivepositiontaking_1 smallmoney,
	@v1alivepositiontaking_3 smallmoney,
	@v1alivepositiontaking_7 smallmoney,
	@v1alivepositiontaking_8 smallmoney,
	@v1mlivepositiontaking_1 smallmoney,
	@v1mlivepositiontaking_3 smallmoney,
	@v1mlivepositiontaking_7 smallmoney,
	@v1mlivepositiontaking_8 smallmoney,
	
	@v2apositiontaking_1 smallmoney,
	@v2apositiontaking_2 smallmoney,
	@v2apositiontaking_3 smallmoney,
	@v2apositiontaking_7 smallmoney,
	@v2apositiontaking_8 smallmoney,
	@v2apositiontaking_20 smallmoney,

	@v3apositiontaking_1 smallmoney,
	@v3apositiontaking_2 smallmoney,
	@v3apositiontaking_3 smallmoney,
	@v3apositiontaking_20 smallmoney,

	@v5apositiontaking_1 smallmoney,
	@v5apositiontaking_2 smallmoney,
	@v5apositiontaking_3 smallmoney,
	@v5apositiontaking_20 smallmoney,

	@v8apositiontaking_1 smallmoney,
	@v8apositiontaking_3 smallmoney,
	@v8apositiontaking_20 smallmoney,

	@v10apositiontaking_1 smallmoney,
	@v10apositiontaking_2 smallmoney,
	@v10apositiontaking_3 smallmoney,
	@v10apositiontaking_20 smallmoney,

	@v11apositiontaking_1 smallmoney,
	@v11apositiontaking_20 smallmoney,	
	
	@v99apositiontaking_1 smallmoney,
	@v99apositiontaking_2 smallmoney,
	@v99apositiontaking_3 smallmoney,
	@v99apositiontaking_20 smallmoney,
	
	
	-- mix parlay of mixed sports	
	@v99apositiontaking_9 smallmoney, 

	
	
	@v161apositiontaking_81 smallmoney,
	@v161apositiontaking_83 smallmoney,
	@v161apositiontaking_86 smallmoney,
	@v161apositiontaking_88 smallmoney = 0,
	
	@v161alivepositiontaking_85 smallmoney,
	@v161alivepositiontaking_86 smallmoney,	
	@v161alivepositiontaking_87 smallmoney,
	@v161alivepositiontaking_89 smallmoney = 0,	
	@v161alivepositiontaking_90 smallmoney = 0,
	
	
	@v2mpositiontaking_1 smallmoney,
	@v2mpositiontaking_2 smallmoney,
	@v2mpositiontaking_3 smallmoney,
	@v2mpositiontaking_7 smallmoney,
	@v2mpositiontaking_8 smallmoney,
	@v2mpositiontaking_20 smallmoney,

	@v3mpositiontaking_1 smallmoney,
	@v3mpositiontaking_2 smallmoney,
	@v3mpositiontaking_3 smallmoney,
	@v3mpositiontaking_20 smallmoney,

	@v5mpositiontaking_1 smallmoney,
	@v5mpositiontaking_2 smallmoney,
	@v5mpositiontaking_3 smallmoney,
	@v5mpositiontaking_20 smallmoney,

	@v8mpositiontaking_1 smallmoney,
	@v8mpositiontaking_3 smallmoney,
	@v8mpositiontaking_20 smallmoney,

	@v10mpositiontaking_1 smallmoney,
	@v10mpositiontaking_2 smallmoney,
	@v10mpositiontaking_3 smallmoney,
	@v10mpositiontaking_20 smallmoney,

	@v11mpositiontaking_1 smallmoney,
	@v11mpositiontaking_20 smallmoney,
	
	@v99mpositiontaking_1 smallmoney,
	@v99mpositiontaking_2 smallmoney,
	@v99mpositiontaking_3 smallmoney,
	@v99mpositiontaking_20 smallmoney,



	-- mix parlay of mixed sports
	@v99mpositiontaking_9 smallmoney,

	-- number game
	@v161mpositiontaking_81 smallmoney,
	@v161mpositiontaking_83 smallmoney,
	@v161mpositiontaking_86 smallmoney,
	@v161mpositiontaking_88 smallmoney = 0,
		
	@v161mlivepositiontaking_85 smallmoney,
	@v161mlivepositiontaking_86 smallmoney,
	@v161mlivepositiontaking_87 smallmoney,
	@v161mlivepositiontaking_89 smallmoney = 0,
	@v161mlivepositiontaking_90 smallmoney = 0,
	

	--Keno
	@KenoList VARCHAR(4000)='',
	@DisableKeno BIT = 0,
	--------------------------------
	
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
	
Param's Explanation:
• @ErrCode:
    = 0: Create agent successfully.
    > 0: Specific Error.
  
• @ErrMsg: Error description.

*/
BEGIN

	SET NOCOUNT ON
	----- David @ 09 JUN 2015 -------------------
	BEGIN TRY
		SELECT *
		INTO #tmp_Sports
		FROM dbo.f_GetSportTypeBetTypeGameType(1,'DBAGE')	
	END TRY
	BEGIN CATCH
		IF OBJECT_ID(N'tempdb..#tmp_Sports') IS NOT NULL
		BEGIN
			TRUNCATE TABLE #tmp_Sports
			INSERT INTO #tmp_Sports
			SELECT *
			FROM dbo.f_GetSportTypeBetTypeGameType(1,'DBTXN')	
		END
	END CATCH

	BEGIN TRY			
		SELECT *
		INTO #tmp_Bettype
		FROM dbo.f_GetSportTypeBetTypeGameType(2,'DBAGE')	
	END TRY
	BEGIN CATCH		
		IF OBJECT_ID(N'tempdb..#tmp_Bettype') IS NOT NULL
		BEGIN
			TRUNCATE TABLE #tmp_Bettype
			INSERT INTO #tmp_Bettype
			SELECT *
			FROM dbo.f_GetSportTypeBetTypeGameType(2,'DBTXN')	
		END
	END CATCH

	BEGIN TRY		
		SELECT *
		INTO #tmp_GameType
		FROM dbo.f_GetSportTypeBetTypeGameType(3,'DBAGE')	
	END TRY
	BEGIN CATCH		
		IF OBJECT_ID(N'tempdb..#tmp_GameType') IS NOT NULL
		BEGIN
			TRUNCATE TABLE #tmp_GameType
			INSERT INTO #tmp_GameType
			SELECT *
			FROM dbo.f_GetSportTypeBetTypeGameType(3,'DBTXN')	
		END
	END CATCH

	----- /David @ 09 JUN 2015 -------------------
	--------Parse xml string into table -- Keno
	DECLARE @xmlDoc int
	EXEC sp_xml_preparedocument @xmlDoc OUTPUT, @KenoList

	SELECT *
	INTO #data
	FROM OPENXML (@xmlDoc, '/products/product',1) WITH(Bettype INT, MaxBet money, MinBet money, MaxPerMatch money, 
	sPositionTaking smallmoney, mPositionTaking smallmoney, aPositionTaking smallmoney,IsDisable BIT)

	EXEC sp_xml_removedocument @xmlDoc

	SELECT @DisableKeno = 1
	IF EXISTS (SELECT * FROM #data WHERE isDisable = 0 )
	BEGIN 
		SELECT @DisableKeno = 0
	END
	--Rollback
	DECLARE @Rollback nvarchar(1000)

	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


	--SELECT @v161mlivepositiontaking_90 = 0,
	--		@v161alivepositiontaking_90 = 0
	/************************************
	Set default value Master PT
	*************************************/
	SELECT @v1mpositiontaking_1			= 0,
		@v1mpositiontaking_2			= 0,
		@v1mpositiontaking_3			= 0,
		@v1mpositiontaking_4			= 0,
		@v1mpositiontaking_5			= 0,
		@v1mpositiontaking_6			= 0,
		@v1mpositiontaking_7			= 0,
		@v1mpositiontaking_8			= 0,
		@v1mpositiontaking_9			= 0,
		@v1mpositiontaking_10			= 0,
		@v1mlivepositiontaking_1		= 0,
		@v1mlivepositiontaking_3		= 0,
		@v1mlivepositiontaking_7		= 0,
		@v1mlivepositiontaking_8		= 0,
		@v2mpositiontaking_1			= 0,
		@v2mpositiontaking_2			= 0,
		@v2mpositiontaking_3			= 0,
		@v2mpositiontaking_7			= 0,
		@v2mpositiontaking_8			= 0,
		@v2mpositiontaking_20			= 0,
		@v3mpositiontaking_1			= 0,
		@v3mpositiontaking_2			= 0,
		@v3mpositiontaking_3			= 0,
		@v3mpositiontaking_20			= 0,
		@v5mpositiontaking_1			= 0,
		@v5mpositiontaking_2			= 0,
		@v5mpositiontaking_3			= 0,
		@v5mpositiontaking_20			= 0,
		@v8mpositiontaking_1			= 0,
		@v8mpositiontaking_3			= 0,
		@v8mpositiontaking_20			= 0,
		@v10mpositiontaking_1			= 0,
		@v10mpositiontaking_2			= 0,
		@v10mpositiontaking_3			= 0,
		@v10mpositiontaking_20			= 0,
		@v11mpositiontaking_1			= 0,
		
		@v11mpositiontaking_20			= 0,
		@v99mpositiontaking_1			= 0,
		@v99mpositiontaking_2			= 0,
		@v99mpositiontaking_3			= 0,
		@v99mpositiontaking_20			= 0,

	
		@v99mpositiontaking_9			= 0,
		@v161mpositiontaking_81			= 0,
		@v161mpositiontaking_83			= 0,
		@v161mpositiontaking_86			= 0,
		@v161mpositiontaking_88			= 0,
		@v161mlivepositiontaking_85		= 0,
		@v161mlivepositiontaking_86		= 0,
		@v161mlivepositiontaking_87		= 0,
		@v161mlivepositiontaking_89		= 0,
		@v161mlivepositiontaking_90		= 0
		
		
		


	declare @startRun datetime
	declare @endRun datetime
	declare @duration int
	set @startRun = getdate()

	--Check an account disabled or not 
	EXEC dbo.Acc_CustomerSelCheckEnable @custid = @mrecommend, @ErrCode=@ErrCode output,@ErrMsg=@ErrMsg output 
	if @ErrCode <>0		return 


	declare @ErrType varchar(4000)
	declare 
		@transcode bigint, @currency int, @pwdexpiry datetime, @site nvarchar(50),
		@MinMinBet money, @MaxMaxBet money, @MaxMaxPerMatch money, 
		@MinMinBetv2 money, @MaxMaxBetv2 money, @MaxMaxPerMatchv2 money, 
		@MinMinBetv3 money, @MaxMaxBetv3 money, @MaxMaxPerMatchv3 money, 
		@MinMinBetv5 money, @MaxMaxBetv5 money, @MaxMaxPerMatchv5 money,
		@MinMinBetv8 money, @MaxMaxBetv8 money, @MaxMaxPerMatchv8 money,
		@MinMinBetv10 money, @MaxMaxBetv10 money, @MaxMaxPerMatchv10 money,
		@MinMinBetv11 money, @MaxMaxBetv11 money, @MaxMaxPerMatchv11 money,
		
		@MinMinBetv99 money, @MaxMaxBetv99 money, @MaxMaxPerMatchv99 money,
		
		@MinMinBetv1mp money, @MaxMaxBetv1mp money, @MaxMaxPerMatchv1mp money,
		@MinMinBetv99mp money, @MaxMaxBetv99mp money, @MaxMaxPerMatchv99mp money,
		@MinMinBetv161 money, @MaxMaxBetv161 money, @MaxMaxPerMatchv161 money, 
		@MaxMaxPerBallv161 money,
		@Credit_AllOtherAgent money, @Credit_AllMember money, @Credit_MAg money,
		@srecommend int,	 
		@matchlimit smallmoney,
		@TransferOption_dec tinyint,
		@Msuspended bit,
		@UplineClosed bit,
		@DisableOutright bit,
	
		@sitename varchar(20),
		@VirtualMultiplier SMALLMONEY

	declare
		@max_mapositiontaking_1 smallmoney,
		@max_mapositiontaking_2 smallmoney,
		@max_mapositiontaking_3 smallmoney,
		@max_mapositiontaking_4 smallmoney,
		@max_mapositiontaking_5 smallmoney,
		@max_mapositiontaking_6 smallmoney,
		@max_mapositiontaking_7 smallmoney,
		@max_mapositiontaking_8 smallmoney,
		@max_mapositiontaking_9 smallmoney,
		@max_mapositiontaking_10 smallmoney,
		
		@max_malivepositiontaking_1 smallmoney,
		@max_malivepositiontaking_3 smallmoney,
		@max_malivepositiontaking_7 smallmoney,
		@max_malivepositiontaking_8 smallmoney,
		
		@max_v2mapositiontaking_1 smallmoney,
		@max_v2mapositiontaking_2 smallmoney,
		@max_v2mapositiontaking_3 smallmoney,
		@max_v2mapositiontaking_7 smallmoney,
		@max_v2mapositiontaking_8 smallmoney,
		@max_v2mapositiontaking_20 smallmoney,

		@max_v3mapositiontaking_1 smallmoney,
		@max_v3mapositiontaking_2 smallmoney,
		@max_v3mapositiontaking_3 smallmoney,
		@max_v3mapositiontaking_20 smallmoney,

		@max_v5mapositiontaking_1 smallmoney,
		@max_v5mapositiontaking_2 smallmoney,
		@max_v5mapositiontaking_3 smallmoney,
		@max_v5mapositiontaking_20 smallmoney,

		@max_v8mapositiontaking_1 smallmoney,
		@max_v8mapositiontaking_3 smallmoney,
		@max_v8mapositiontaking_20 smallmoney,

		@max_v10mapositiontaking_1 smallmoney,
		@max_v10mapositiontaking_2 smallmoney,
		@max_v10mapositiontaking_3 smallmoney,
		@max_v10mapositiontaking_20 smallmoney,

		@max_v11mapositiontaking_1 smallmoney,
		@max_v11mapositiontaking_20 smallmoney,
	
		@max_v99mapositiontaking_1 smallmoney,
		@max_v99mapositiontaking_2 smallmoney,
		@max_v99mapositiontaking_3 smallmoney,
		@max_v99mapositiontaking_20 smallmoney,

		-- mix parlay of mixed sports
		@max_v99mapositiontaking_9 smallmoney,

		@max_v161mapositiontaking_81 smallmoney,
		@max_v161mapositiontaking_83 smallmoney,
		@max_v161mapositiontaking_86 smallmoney,
		@max_v161mapositiontaking_88 smallmoney,
		
		@max_v161malivepositiontaking_85 smallmoney,
		@max_v161malivepositiontaking_86 smallmoney,
		@max_v161malivepositiontaking_87 smallmoney,	
		@max_v161malivepositiontaking_89 smallmoney,
		@max_v161malivepositiontaking_90 smallmoney

		

	select 
		@currency = currency, 
		@Msuspended = reject,
		@UplineClosed = closed,
	
		@Credit_MAg = isnull(credit, 0),
		@srecommend = srecommend,
		@matchlimit = matchlimit,
	
		@DisableOutright = DisableOutright,
		
		@DisableNumber = case when DisableNumber = 1 then 1 else @DisableNumber end,
		@VirtualMultiplier = ci.VirtualMultiplier
	from CustInfo as ci with (NOLOCK) 
	where CustID = @mrecommend


	Select @ErrCode = 0
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	declare @IsValid bit
	EXEC dbo.Acc_Dep_CustomerInsMember_MAg_CheckParam
		
		@MinBet=@MinBetv1,
		@MaxBet=@MaxBetv1,
		@MaxPerMatch=@MaxPerMatchv1,
		
		@MinBetv2=@MinBetv2,
		@MaxBetv2=@MaxBetv2,
		@MaxPerMatchv2=@MaxPerMatchv2,

		@MinBetv3=@MinBetv3,
		@MaxBetv3=@MaxBetv3,
		@MaxPerMatchv3=@MaxPerMatchv3,

		@MinBetv5=@MinBetv5,
		@MaxBetv5=@MaxBetv5,
		@MaxPerMatchv5=@MaxPerMatchv5,

		@MinBetv8=@MinBetv8,
		@MaxBetv8=@MaxBetv8,
		@MaxPerMatchv8=@MaxPerMatchv8,

		@MinBetv10=@MinBetv10,
		@MaxBetv10=@MaxBetv10,
		@MaxPerMatchv10=@MaxPerMatchv10,

		@MinBetv11=@MinBetv11,
		@MaxBetv11=@MaxBetv11,
		@MaxPerMatchv11=@MaxPerMatchv11,	
		
		@MinBetv99=@MinBetv99,
		@MaxBetv99=@MaxBetv99,
		@MaxPerMatchv99=@MaxPerMatchv99,

	
		-- mix parlay of mixed sports
		@MinBetv1mp = @MinBetv1mp,
		@MaxBetv1mp = @MaxBetv1mp,
		@MaxPerMatchv1mp = @MaxPerMatchv1mp,
		
		@MinBetv99mp = @MinBetv99mp,
		@MaxBetv99mp = @MaxBetv99mp,
		@MaxPerMatchv99mp = @MaxPerMatchv99mp,

		--number game
		@MinBetv161 = @MinBetv161,
		@MaxBetv161 = @MaxBetv161,
		@MaxPerMatchv161 = @MaxPerMatchv161,
		
		@MaxPerBallv161 = @MaxPerBallv161,
	
		@mrecommend=@mrecommend,
		
		@apositiontaking_1=@v1apositiontaking_1,
		@apositiontaking_2=@v1apositiontaking_2,
		@apositiontaking_3=@v1apositiontaking_3,
		@apositiontaking_4=@v1apositiontaking_4,
		@apositiontaking_5=@v1apositiontaking_5,
		@apositiontaking_6=@v1apositiontaking_6,
		@apositiontaking_7=@v1apositiontaking_7,
		@apositiontaking_8=@v1apositiontaking_8,
		@apositiontaking_9=@v1apositiontaking_9,
		@apositiontaking_10=@v1apositiontaking_10,
		
		@mpositiontaking_1=@v1mpositiontaking_1,
		@mpositiontaking_2=@v1mpositiontaking_2,
		@mpositiontaking_3=@v1mpositiontaking_3,
		@mpositiontaking_4=@v1mpositiontaking_4,
		@mpositiontaking_5=@v1mpositiontaking_5,
		@mpositiontaking_6=@v1mpositiontaking_6,
		@mpositiontaking_7=@v1mpositiontaking_7,
		@mpositiontaking_8=@v1mpositiontaking_8,
		@mpositiontaking_9=@v1mpositiontaking_9,
		@mpositiontaking_10=@v1mpositiontaking_10,
		
		@alivepositiontaking_1=@v1alivepositiontaking_1,
		@alivepositiontaking_3=@v1alivepositiontaking_3,
		@alivepositiontaking_7=@v1alivepositiontaking_7,
		@alivepositiontaking_8=@v1alivepositiontaking_8,
		
		@mlivepositiontaking_1=@v1mlivepositiontaking_1,
		@mlivepositiontaking_3=@v1mlivepositiontaking_3,
		@mlivepositiontaking_7=@v1mlivepositiontaking_7,
		@mlivepositiontaking_8=@v1mlivepositiontaking_8,
		
		@v2apositiontaking_1=@v2apositiontaking_1,
		@v2apositiontaking_2=@v2apositiontaking_2,
		@v2apositiontaking_3=@v2apositiontaking_3,
		@v2apositiontaking_7=@v2apositiontaking_7,
		@v2apositiontaking_8=@v2apositiontaking_8,
		@v2apositiontaking_20=@v2apositiontaking_20,
		
		@v3apositiontaking_1=@v3apositiontaking_1,
		@v3apositiontaking_2=@v3apositiontaking_2,
		@v3apositiontaking_3=@v3apositiontaking_3,
		@v3apositiontaking_20=@v3apositiontaking_20,

		@v5apositiontaking_1=@v5apositiontaking_1,
		@v5apositiontaking_2=@v5apositiontaking_2,
		@v5apositiontaking_3=@v5apositiontaking_3,
		@v5apositiontaking_20=@v5apositiontaking_20,

		@v8apositiontaking_1=@v8apositiontaking_1,
		@v8apositiontaking_3=@v8apositiontaking_3,
		@v8apositiontaking_20=@v8apositiontaking_20,

		@v10apositiontaking_1=@v10apositiontaking_1,
		@v10apositiontaking_2=@v10apositiontaking_2,
		@v10apositiontaking_3=@v10apositiontaking_3,
		@v10apositiontaking_20=@v10apositiontaking_20,

		@v11apositiontaking_1=@v11apositiontaking_1,
		@v11apositiontaking_20=@v11apositiontaking_20,
		
		@v99apositiontaking_1=@v99apositiontaking_1,
		@v99apositiontaking_2=@v99apositiontaking_2,
		@v99apositiontaking_3=@v99apositiontaking_3,
		@v99apositiontaking_20=@v99apositiontaking_20,

		
		-- mix parlay of mixed sports
		@v99apositiontaking_9 = @v99apositiontaking_9,
		

		-- number game
		@v161apositiontaking_81 = @v161apositiontaking_81,
		@v161apositiontaking_83 = @v161apositiontaking_83,
		@v161apositiontaking_86 = @v161apositiontaking_86,
		@v161apositiontaking_88 = @v161apositiontaking_88,
		
		@v161alivepositiontaking_85 = @v161alivepositiontaking_85,
		@v161alivepositiontaking_86 = @v161alivepositiontaking_86,
		@v161alivepositiontaking_87 = @v161alivepositiontaking_87,
		@v161alivepositiontaking_89 = @v161alivepositiontaking_89,
		@v161alivepositiontaking_90 = @v161alivepositiontaking_90,
		
		@v2mpositiontaking_1=@v2mpositiontaking_1,
		@v2mpositiontaking_2=@v2mpositiontaking_2,
		@v2mpositiontaking_3=@v2mpositiontaking_3,
		@v2mpositiontaking_7=@v2mpositiontaking_7,
		@v2mpositiontaking_8=@v2mpositiontaking_8,
		@v2mpositiontaking_20=@v2mpositiontaking_20,
		
		@v3mpositiontaking_1=@v3mpositiontaking_1,
		@v3mpositiontaking_2=@v3mpositiontaking_2,
		@v3mpositiontaking_3=@v3mpositiontaking_3,
		@v3mpositiontaking_20=@v3mpositiontaking_20,

		@v5mpositiontaking_1=@v5mpositiontaking_1,
		@v5mpositiontaking_2=@v5mpositiontaking_2,
		@v5mpositiontaking_3=@v5mpositiontaking_3,
		@v5mpositiontaking_20=@v5mpositiontaking_20,

		@v8mpositiontaking_1=@v8mpositiontaking_1,
		@v8mpositiontaking_3=@v8mpositiontaking_3,
		@v8mpositiontaking_20=@v8mpositiontaking_20,

		@v10mpositiontaking_1=@v10mpositiontaking_1,
		@v10mpositiontaking_2=@v10mpositiontaking_2,
		@v10mpositiontaking_3=@v10mpositiontaking_3,
		@v10mpositiontaking_20=@v10mpositiontaking_20,

		@v11mpositiontaking_1=@v11mpositiontaking_1,
		@v11mpositiontaking_20=@v11mpositiontaking_20,
		
		@v99mpositiontaking_1=@v99mpositiontaking_1,
		@v99mpositiontaking_2=@v99mpositiontaking_2,
		@v99mpositiontaking_3=@v99mpositiontaking_3,
		@v99mpositiontaking_20=@v99mpositiontaking_20,

		-- mix parlay of mixed sports
		@v99mpositiontaking_9=@v99mpositiontaking_9,
		
		
		-- number game
		@v161mpositiontaking_81 = @v161mpositiontaking_81,
		@v161mpositiontaking_83 = @v161mpositiontaking_83,
		@v161mpositiontaking_86 = @v161mpositiontaking_86,
		@v161mpositiontaking_88 = @v161mpositiontaking_88,
		
		@v161mlivepositiontaking_85 = @v161mlivepositiontaking_85,
		@v161mlivepositiontaking_86 = @v161mlivepositiontaking_86,
		@v161mlivepositiontaking_87 = @v161mlivepositiontaking_87,
		@v161mlivepositiontaking_89 = @v161mlivepositiontaking_89,
		@v161mlivepositiontaking_90 = @v161mlivepositiontaking_90,

		@isvalid=@isvalid OUTPUT,
		@errmsg=@ErrMsg OUTPUT,
		@errcode=@errcode OUTPUT,
		@language=@language
	if @IsValid = 0
	BEGIN
		return
	END
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--select @username = replace(@username, ' ', '')

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

	--m3
	select @max_mapositiontaking_1 = mpositiontaking from Dep_CustSetting with (NOLOCK) where custid = @mrecommend and bettype=1 and sporttype=1 and islive=0
	select @max_malivepositiontaking_1 = mpositiontaking from Dep_CustSetting with (NOLOCK) where custid = @mrecommend and bettype=1 and sporttype=1 and islive=1
	select @max_mapositiontaking_3 = mpositiontaking from Dep_CustSetting with (NOLOCK) where custid = @mrecommend and bettype=3 and sporttype=1 and islive=0
	select @max_malivepositiontaking_3 = mpositiontaking from Dep_CustSetting with (NOLOCK) where custid = @mrecommend and bettype=3 and sporttype=1 and islive=1
	select @max_mapositiontaking_7 = mpositiontaking from Dep_CustSetting with (NOLOCK) where custid = @mrecommend and bettype=7 and sporttype=1 and islive=0
	select @max_malivepositiontaking_7 = mpositiontaking from Dep_CustSetting with (NOLOCK) where custid = @mrecommend and bettype=7 and sporttype=1 and islive=1
	select @max_mapositiontaking_8 =mpositiontaking from Dep_CustSetting with (NOLOCK) where custid = @mrecommend and bettype=8 and sporttype=1 and islive=0
	select @max_malivepositiontaking_8 =mpositiontaking from Dep_CustSetting with (NOLOCK) where custid = @mrecommend and bettype=8 and sporttype=1 and islive=1
	select @max_mapositiontaking_2 =mpositiontaking from Dep_CustSetting with (NOLOCK) where custid = @mrecommend and bettype=2 and sporttype=1 and islive=0
	select @max_mapositiontaking_4 =mpositiontaking from Dep_CustSetting with (NOLOCK) where custid = @mrecommend and bettype=4 and sporttype=1 and islive=0
	select @max_mapositiontaking_5 =mpositiontaking from Dep_CustSetting with (NOLOCK) where custid = @mrecommend and bettype=5 and sporttype=1 and islive=0
	select @max_mapositiontaking_6 =mpositiontaking from Dep_CustSetting with (NOLOCK) where custid = @mrecommend and bettype=6 and sporttype=1 and islive=0
	select @max_mapositiontaking_9 =mpositiontaking from Dep_CustSetting with (NOLOCK) where custid = @mrecommend and bettype=9 and sporttype=1 and islive=0
	select @max_mapositiontaking_10 =mpositiontaking from Dep_CustSetting with (NOLOCK) where custid = @mrecommend and bettype=10 and sporttype=1 and islive=0

	select @max_v2mapositiontaking_1 =mpositiontaking from Dep_CustSetting with (NOLOCK) where custid = @mrecommend and bettype=1 and sporttype=2 and islive=0
	select @max_v2mapositiontaking_2 =mpositiontaking from Dep_CustSetting with (NOLOCK) where custid = @mrecommend and bettype=2 and sporttype=2 and islive=0
	select @max_v2mapositiontaking_3 =mpositiontaking from Dep_CustSetting with (NOLOCK) where custid = @mrecommend and bettype=3 and sporttype=2 and islive=0
	select @max_v2mapositiontaking_7 =mpositiontaking from Dep_CustSetting with (NOLOCK) where custid = @mrecommend and bettype=7 and sporttype=2 and islive=0
	select @max_v2mapositiontaking_8 =mpositiontaking from Dep_CustSetting with (NOLOCK) where custid = @mrecommend and bettype=8 and sporttype=2 and islive=0
	select @max_v2mapositiontaking_20 =mpositiontaking from Dep_CustSetting with (NOLOCK) where custid = @mrecommend and bettype=20 and sporttype=2 and islive=0

	select @max_v3mapositiontaking_1 =mpositiontaking from Dep_CustSetting with (NOLOCK) where custid = @mrecommend and bettype=1 and sporttype=3 and islive=0
	select @max_v3mapositiontaking_2 =mpositiontaking from Dep_CustSetting with (NOLOCK) where custid = @mrecommend and bettype=2 and sporttype=3 and islive=0
	select @max_v3mapositiontaking_3 =mpositiontaking from Dep_CustSetting with (NOLOCK) where custid = @mrecommend and bettype=3 and sporttype=3 and islive=0
	select @max_v3mapositiontaking_20 =mpositiontaking from Dep_CustSetting with (NOLOCK) where custid = @mrecommend and bettype=20 and sporttype=3 and islive=0

	select @max_v5mapositiontaking_1 =mpositiontaking from Dep_CustSetting with (NOLOCK) where custid = @mrecommend and bettype=1 and sporttype=5 and islive=0
	select @max_v5mapositiontaking_2 =mpositiontaking from Dep_CustSetting with (NOLOCK) where custid = @mrecommend and bettype=2 and sporttype=5 and islive=0
	select @max_v5mapositiontaking_3 =mpositiontaking from Dep_CustSetting with (NOLOCK) where custid = @mrecommend and bettype=3 and sporttype=5 and islive=0
	select @max_v5mapositiontaking_20 =mpositiontaking from Dep_CustSetting with (NOLOCK) where custid = @mrecommend and bettype=20 and sporttype=5 and islive=0

	select @max_v8mapositiontaking_1 =mpositiontaking from Dep_CustSetting with (NOLOCK) where custid = @mrecommend and bettype=1 and sporttype=8 and islive=0
	select @max_v8mapositiontaking_3 =mpositiontaking from Dep_CustSetting with (NOLOCK) where custid = @mrecommend and bettype=3 and sporttype=8 and islive=0
	select @max_v8mapositiontaking_20 =mpositiontaking from Dep_CustSetting with (NOLOCK) where custid = @mrecommend and bettype=20 and sporttype=8 and islive=0

	select @max_v10mapositiontaking_1 =mpositiontaking from Dep_CustSetting with (NOLOCK) where custid = @mrecommend and bettype=1 and sporttype=10 and islive=0
	select @max_v10mapositiontaking_2 =mpositiontaking from Dep_CustSetting with (NOLOCK) where custid = @mrecommend and bettype=2 and sporttype=10 and islive=0
	select @max_v10mapositiontaking_3 =mpositiontaking from Dep_CustSetting with (NOLOCK) where custid = @mrecommend and bettype=3 and sporttype=10 and islive=0
	select @max_v10mapositiontaking_20 =mpositiontaking from Dep_CustSetting with (NOLOCK) where custid = @mrecommend and bettype=20 and sporttype=10 and islive=0

	select @max_v11mapositiontaking_1 =mpositiontaking from Dep_CustSetting with (NOLOCK) where custid = @mrecommend and bettype=1 and sporttype=11 and islive=0
	select @max_v11mapositiontaking_20 =mpositiontaking from Dep_CustSetting with (NOLOCK) where custid = @mrecommend and bettype=20 and sporttype=11 and islive=0

	select @max_v99mapositiontaking_1 =mpositiontaking from Dep_CustSetting with (NOLOCK) where custid = @mrecommend and bettype=1 and sporttype=99 and islive=0
	select @max_v99mapositiontaking_2 =mpositiontaking from Dep_CustSetting with (NOLOCK) where custid = @mrecommend and bettype=2 and sporttype=99 and islive=0
	select @max_v99mapositiontaking_3 =mpositiontaking from Dep_CustSetting with (NOLOCK) where custid = @mrecommend and bettype=3 and sporttype=99 and islive=0
	select @max_v99mapositiontaking_20 =mpositiontaking from Dep_CustSetting with (NOLOCK) where custid = @mrecommend and bettype=20 and sporttype=99 and islive=0

	-- mix parlay of mixed sports
	select @max_v99mapositiontaking_9 =mpositiontaking from Dep_CustSetting with (NOLOCK) where custid = @mrecommend and bettype=9 and sporttype=99 and islive=0

	-- number game
	select @max_v161mapositiontaking_81 = mpositiontaking from Dep_CustSetting3rd with (NOLOCK) where custid = @mrecommend and bettype= 81 and sporttype=161 and islive=0
	select @max_v161mapositiontaking_83 = mpositiontaking from Dep_CustSetting3rd with (NOLOCK) where custid = @mrecommend and bettype= 83 and sporttype=161 and islive=0
	select @max_v161malivepositiontaking_85 = mpositiontaking from Dep_CustSetting3rd with (NOLOCK) where custid = @mrecommend and bettype= 85 and sporttype=161 and islive=1
	select @max_v161mapositiontaking_86 = mpositiontaking from Dep_CustSetting3rd with (NOLOCK) where custid = @mrecommend and bettype=86 and sporttype=161 and islive=0
	select @max_v161malivepositiontaking_86 = mpositiontaking from Dep_CustSetting3rd with (NOLOCK) where custid = @mrecommend and bettype=86 and sporttype=161 and islive=1
	select @max_v161malivepositiontaking_87 = mpositiontaking from Dep_CustSetting3rd with (NOLOCK) where custid = @mrecommend and bettype= 87 and sporttype=161 and islive=1
	select @max_v161mapositiontaking_88 = mpositiontaking from Dep_CustSetting3rd with (NOLOCK) where custid = @mrecommend and bettype= 88 and sporttype=161 and islive=0
	select @max_v161malivepositiontaking_89 = mpositiontaking from Dep_CustSetting3rd with (NOLOCK) where custid = @mrecommend and bettype= 89 and sporttype=161 and islive=1
	select @max_v161malivepositiontaking_90 = mpositiontaking from Dep_CustSetting3rd with (NOLOCK) where custid = @mrecommend and bettype= 90 and sporttype=161 and islive=1

	--check m2+a2<=m3
	select @ErrType = ''
	select @ErrType = @ErrType + sports.name + '-' + bettype.Name + '-Max: '+ cast((max_mapositiontaking) as varchar(10))
		+ case when b.sporttype in (1,161) and b.bettype in (1,3,7,8,85,86,87,89,90) then '--MaxLive: '+ cast((max_malivepositiontaking) as varchar(10)) else '' end + '<br>'
	from #tmp_Sports sports inner join
	(
				select 1 as bettype, 1 as sporttype, @v1apositiontaking_1 as apositiontaking, @v1alivepositiontaking_1 as alivepositiontaking, @v1mpositiontaking_1 as mpositiontaking, @v1mlivepositiontaking_1 as mlivepositiontaking, @max_mapositiontaking_1 as max_mapositiontaking,  @max_malivepositiontaking_1 as max_malivepositiontaking
		union all 	select 3 as bettype, 1 as sporttype, @v1apositiontaking_3 as apositiontaking, @v1alivepositiontaking_3 as alivepositiontaking, @v1mpositiontaking_3 as mpositiontaking, @v1mlivepositiontaking_3 as mlivepositiontaking, @max_mapositiontaking_3 as max_mapositiontaking,  @max_malivepositiontaking_3 as max_malivepositiontaking
		union all 	select 7 as bettype, 1 as sporttype, @v1apositiontaking_7 as apositiontaking, @v1alivepositiontaking_7 as alivepositiontaking, @v1mpositiontaking_7 as mpositiontaking, @v1mlivepositiontaking_7 as mlivepositiontaking, @max_mapositiontaking_7 as max_mapositiontaking,  @max_malivepositiontaking_7 as max_malivepositiontaking
		union all 	select 8 as bettype, 1 as sporttype, @v1apositiontaking_8 as apositiontaking, @v1alivepositiontaking_8 as alivepositiontaking, @v1mpositiontaking_8 as mpositiontaking, @v1mlivepositiontaking_8 as mlivepositiontaking, @max_mapositiontaking_8 as max_mapositiontaking,  @max_malivepositiontaking_8 as max_malivepositiontaking
		union all 	select 2 as bettype, 1 as sporttype, @v1apositiontaking_2 as apositiontaking, 0 as alivepositiontaking, @v1mpositiontaking_2 as mpositiontaking, 0 as mlivepositiontaking, @max_mapositiontaking_2 as max_mapositiontaking,  0 as max_malivepositiontaking
		union all 	select 4 as bettype, 1 as sporttype, @v1apositiontaking_4 as apositiontaking, 0 as alivepositiontaking, @v1mpositiontaking_4 as mpositiontaking, 0 as mlivepositiontaking, @max_mapositiontaking_4 as max_mapositiontaking,  0 as max_malivepositiontaking
		union all 	select 5 as bettype, 1 as sporttype, @v1apositiontaking_5 as apositiontaking, 0 as alivepositiontaking, @v1mpositiontaking_5 as mpositiontaking, 0 as mlivepositiontaking, @max_mapositiontaking_5 as max_mapositiontaking,  0 as max_malivepositiontaking
		union all 	select 6 as bettype, 1 as sporttype, @v1apositiontaking_6 as apositiontaking, 0 as alivepositiontaking, @v1mpositiontaking_6 as mpositiontaking, 0 as mlivepositiontaking, @max_mapositiontaking_6 as max_mapositiontaking,  0 as max_malivepositiontaking
		union all 	select 9 as bettype, 1 as sporttype, @v1apositiontaking_9 as apositiontaking, 0 as alivepositiontaking, @v1mpositiontaking_9 as mpositiontaking, 0 as mlivepositiontaking, @max_mapositiontaking_9 as max_mapositiontaking,  0 as max_malivepositiontaking
		union all 	select 10 as bettype, 1 as sporttype, @v1apositiontaking_10 as apositiontaking, 0 as alivepositiontaking, @v1mpositiontaking_10 as mpositiontaking, 0 as mlivepositiontaking, @max_mapositiontaking_10 as max_mapositiontaking,  0 as max_malivepositiontaking

		union all 	select 1 as bettype, 2 as sporttype, @v2apositiontaking_1 as apositiontaking, 0 as alivepositiontaking, @v2mpositiontaking_1 as mpositiontaking, 0 as mlivepositiontaking, @max_v2mapositiontaking_1 as max_mapositiontaking,  0 as max_malivepositiontaking
		union all 	select 2 as bettype, 2 as sporttype, @v2apositiontaking_2 as apositiontaking, 0 as alivepositiontaking, @v2mpositiontaking_2 as mpositiontaking, 0 as mlivepositiontaking, @max_v2mapositiontaking_2 as max_mapositiontaking,  0 as max_malivepositiontaking
		union all 	select 3 as bettype, 2 as sporttype, @v2apositiontaking_3 as apositiontaking, 0 as alivepositiontaking, @v2mpositiontaking_3 as mpositiontaking, 0 as mlivepositiontaking, @max_v2mapositiontaking_3 as max_mapositiontaking,  0 as max_malivepositiontaking
		union all 	select 20 as bettype, 2 as sporttype, @v2apositiontaking_20 as apositiontaking, 0 as alivepositiontaking, @v2mpositiontaking_20 as mpositiontaking, 0 as mlivepositiontaking, @max_v2mapositiontaking_20 as max_mapositiontaking,  0 as max_malivepositiontaking

		union all 	select 1 as bettype, 3 as sporttype, @v3apositiontaking_1 as apositiontaking, 0 as alivepositiontaking, @v3mpositiontaking_1 as mpositiontaking, 0 as mlivepositiontaking, @max_v3mapositiontaking_1 as max_mapositiontaking,  0 as max_malivepositiontaking
		union all 	select 2 as bettype, 3 as sporttype, @v3apositiontaking_2 as apositiontaking, 0 as alivepositiontaking, @v3mpositiontaking_2 as mpositiontaking, 0 as mlivepositiontaking, @max_v3mapositiontaking_2 as max_mapositiontaking,  0 as max_malivepositiontaking
		union all 	select 3 as bettype, 3 as sporttype, @v3apositiontaking_3 as apositiontaking, 0 as alivepositiontaking, @v3mpositiontaking_3 as mpositiontaking, 0 as mlivepositiontaking, @max_v3mapositiontaking_3 as max_mapositiontaking,  0 as max_malivepositiontaking
		union all 	select 20 as bettype, 3 as sporttype, @v3apositiontaking_20 as apositiontaking, 0 as alivepositiontaking, @v3mpositiontaking_20 as mpositiontaking, 0 as mlivepositiontaking, @max_v3mapositiontaking_20 as max_mapositiontaking,  0 as max_malivepositiontaking
		
		union all 	select 1 as bettype, 5 as sporttype, @v5apositiontaking_1 as apositiontaking, 0 as alivepositiontaking, @v5mpositiontaking_1 as mpositiontaking, 0 as mlivepositiontaking, @max_v5mapositiontaking_1 as max_mapositiontaking,  0 as max_malivepositiontaking
		union all 	select 2 as bettype, 5 as sporttype, @v5apositiontaking_2 as apositiontaking, 0 as alivepositiontaking, @v5mpositiontaking_2 as mpositiontaking, 0 as mlivepositiontaking, @max_v5mapositiontaking_2 as max_mapositiontaking,  0 as max_malivepositiontaking
		union all 	select 3 as bettype, 5 as sporttype, @v5apositiontaking_3 as apositiontaking, 0 as alivepositiontaking, @v5mpositiontaking_3 as mpositiontaking, 0 as mlivepositiontaking, @max_v5mapositiontaking_3 as max_mapositiontaking,  0 as max_malivepositiontaking
		union all 	select 20 as bettype, 5 as sporttype, @v5apositiontaking_20 as apositiontaking, 0 as alivepositiontaking, @v5mpositiontaking_20 as mpositiontaking, 0 as mlivepositiontaking, @max_v5mapositiontaking_20 as max_mapositiontaking,  0 as max_malivepositiontaking
		
		union all 	select 1 as bettype, 8 as sporttype, @v8apositiontaking_1 as apositiontaking, 0 as alivepositiontaking, @v8mpositiontaking_1 as mpositiontaking, 0 as mlivepositiontaking, @max_v8mapositiontaking_1 as max_mapositiontaking,  0 as max_malivepositiontaking
		union all 	select 3 as bettype, 8 as sporttype, @v8apositiontaking_3 as apositiontaking, 0 as alivepositiontaking, @v8mpositiontaking_3 as mpositiontaking, 0 as mlivepositiontaking, @max_v8mapositiontaking_3 as max_mapositiontaking,  0 as max_malivepositiontaking
		union all 	select 20 as bettype, 8 as sporttype, @v8apositiontaking_20 as apositiontaking, 0 as alivepositiontaking, @v8mpositiontaking_20 as mpositiontaking, 0 as mlivepositiontaking, @max_v8mapositiontaking_20 as max_mapositiontaking,  0 as max_malivepositiontaking
		
		union all 	select 1 as bettype, 10 as sporttype, @v10apositiontaking_1 as apositiontaking, 0 as alivepositiontaking, @v10mpositiontaking_1 as mpositiontaking, 0 as mlivepositiontaking, @max_v10mapositiontaking_1 as max_mapositiontaking,  0 as max_malivepositiontaking
		union all 	select 2 as bettype, 10 as sporttype, @v10apositiontaking_2 as apositiontaking, 0 as alivepositiontaking, @v10mpositiontaking_2 as mpositiontaking, 0 as mlivepositiontaking, @max_v10mapositiontaking_2 as max_mapositiontaking,  0 as max_malivepositiontaking
		union all 	select 3 as bettype, 10 as sporttype, @v10apositiontaking_3 as apositiontaking, 0 as alivepositiontaking, @v10mpositiontaking_3 as mpositiontaking, 0 as mlivepositiontaking, @max_v10mapositiontaking_3 as max_mapositiontaking,  0 as max_malivepositiontaking
		union all 	select 20 as bettype, 10 as sporttype, @v10apositiontaking_20 as apositiontaking, 0 as alivepositiontaking, @v10mpositiontaking_20 as mpositiontaking, 0 as mlivepositiontaking, @max_v10mapositiontaking_20 as max_mapositiontaking,  0 as max_malivepositiontaking
		
		union all 	select 1 as bettype, 11 as sporttype, @v11apositiontaking_1 as apositiontaking, 0 as alivepositiontaking, @v11mpositiontaking_1 as mpositiontaking, 0 as mlivepositiontaking, @max_v11mapositiontaking_1 as max_mapositiontaking,  0 as max_malivepositiontaking
		union all 	select 20 as bettype, 11 as sporttype, @v11apositiontaking_20 as apositiontaking, 0 as alivepositiontaking, @v11mpositiontaking_20 as mpositiontaking, 0 as mlivepositiontaking, @max_v11mapositiontaking_20 as max_mapositiontaking,  0 as max_malivepositiontaking
	
		union all 	select 1 as bettype, 99 as sporttype, @v99apositiontaking_1 as apositiontaking, 0 as alivepositiontaking, @v99mpositiontaking_1 as mpositiontaking, 0 as mlivepositiontaking, @max_v99mapositiontaking_1 as max_mapositiontaking,  0 as max_malivepositiontaking
		union all 	select 2 as bettype, 99 as sporttype, @v99apositiontaking_2 as apositiontaking, 0 as alivepositiontaking, @v99mpositiontaking_2 as mpositiontaking, 0 as mlivepositiontaking, @max_v99mapositiontaking_2 as max_mapositiontaking,  0 as max_malivepositiontaking
		union all 	select 3 as bettype, 99 as sporttype, @v99apositiontaking_3 as apositiontaking, 0 as alivepositiontaking, @v99mpositiontaking_3 as mpositiontaking, 0 as mlivepositiontaking, @max_v99mapositiontaking_3 as max_mapositiontaking,  0 as max_malivepositiontaking
		union all 	select 20 as bettype, 99 as sporttype, @v99apositiontaking_20 as apositiontaking, 0 as alivepositiontaking, @v99mpositiontaking_20 as mpositiontaking, 0 as mlivepositiontaking, @max_v99mapositiontaking_20 as max_mapositiontaking,  0 as max_malivepositiontaking

		-- mix parlay of mixed sports
		union all 	select 9 as bettype, 99 as sporttype, @v99apositiontaking_9 as apositiontaking, 0 as alivepositiontaking, @v99mpositiontaking_9 as mpositiontaking, 0 as mlivepositiontaking, @max_v99mapositiontaking_9 as max_mapositiontaking,  0 as max_malivepositiontaking

		-- number game
		union all 	select 8 as bettype, 1 as sporttype, @v1apositiontaking_8 as apositiontaking, @v1alivepositiontaking_8 as alivepositiontaking, @v1mpositiontaking_8 as mpositiontaking, @v1mlivepositiontaking_8 as mlivepositiontaking, @max_mapositiontaking_8 as max_mapositiontaking,  @max_malivepositiontaking_8 as max_malivepositiontaking
		union all 	select 2 as bettype, 1 as sporttype, @v1apositiontaking_2 as apositiontaking, 0 as alivepositiontaking, @v1mpositiontaking_2 as mpositiontaking, 0 as mlivepositiontaking, @max_mapositiontaking_2 as max_mapositiontaking,  0 as max_malivepositiontaking	
		union all   select 81 as bettype, 161 as sporttype, @v161apositiontaking_81 as apositiontaking, 0 as alivepositiontaking, @v161mpositiontaking_81 as mpositiontaking, 0 as mlivepositiontaking, @max_v161mapositiontaking_81 as max_mapositiontaking, 0 as max_malivepositiontaking
		union all   select 83 as bettype, 161 as sporttype, @v161apositiontaking_83 as apositiontaking, 0 as alivepositiontaking, @v161mpositiontaking_83 as mpositiontaking, 0 as mlivepositiontaking, @max_v161mapositiontaking_83 as max_mapositiontaking, 0 as max_malivepositiontaking
		union all   select 85 as bettype, 161 as sporttype, 0 as apositiontaking, @v161alivepositiontaking_85 as alivepositiontaking, 0 as mpositiontaking, @v161mlivepositiontaking_85 as mlivepositiontaking, 0 as max_mapostiontaking, @max_v161malivepositiontaking_85 as max_malivepositiontaking			
		union all   select 86 as bettype, 161 as sporttype, @v161apositiontaking_86 as apositiontaking, @v161alivepositiontaking_86 as alivepositiontaking, @v161mpositiontaking_86 as mpositiontaking, @v161mlivepositiontaking_86 as mlivepositiontaking, @max_v161mapositiontaking_86 as max_mapostiontaking, @max_v161malivepositiontaking_86 as max_malivepositiontaking			
		union all   select 87 as bettype, 161 as sporttype, 0 as apositiontaking, @v161alivepositiontaking_87 as alivepositiontaking, 0 as mpositiontaking, @v161mlivepositiontaking_87 as mlivepositiontaking, 0 as max_mapositiontaking,@max_v161malivepositiontaking_87 as max_malivepositiontaking
		union all   select 88 as bettype, 161 as sporttype, @v161apositiontaking_88 as apositiontaking, 0 as alivepositiontaking, @v161mpositiontaking_88 as mpositiontaking, 0 as mlivepositiontaking, @max_v161mapositiontaking_88 as max_mapositiontaking, 0 as max_malivepositiontaking
		union all   select 89 as bettype, 161 as sporttype, 0 as apositiontaking, @v161alivepositiontaking_89 as alivepositiontaking, 0 as mpositiontaking, @v161mlivepositiontaking_89 as mlivepositiontaking, 0 as max_mapostiontaking, @max_v161malivepositiontaking_89 as max_malivepositiontaking
		union all   select 90 as bettype, 161 as sporttype, 0 as apositiontaking, @v161alivepositiontaking_90 as alivepositiontaking, 0 as mpositiontaking, @v161mlivepositiontaking_90 as mlivepositiontaking, 0 as max_mapostiontaking, @max_v161malivepositiontaking_90 as max_malivepositiontaking
		
		) as b on sports.ID = b.sporttype
		INNER JOIN #tmp_Bettype bettype on b.bettype = bettype.ID
		where (apositiontaking + mpositiontaking>max_mapositiontaking)
			or (alivepositiontaking + mlivepositiontaking>max_malivepositiontaking)

	if @ErrType <>''
	BEGIN
		SELECT @ErrMsg = case @Language 
								when 'E' then 'Wrong position taking (max for master set by super).<br>'+@ErrType
								ELSE [dbo].[f_Get_MsgNamebyMsgID](20003,@Language) + '<br>' + @ErrType
							end
		Select @ErrCode = 102
		return 
	END

	select @ErrType = ''
	select @ErrType = @ErrType + CASE WHEN b.sporttype = 1 AND MP = 1 THEN 'Soccer Parlay' ELSE sports.Name END + ', '
	from #tmp_Sports sports inner join
	(
					select 1 as sporttype, 0 MP, @MinBetv1 as MinBet, @MaxBetv1 as MaxBet, @MaxPerMatchv1 as MaxPerMatch
		union all	select 2 as sporttype, 0 MP, @MinBetv2 as MinBet, @MaxBetv2 as MaxBet, @MaxPerMatchv2 as MaxPerMatch
		union all	select 3 as sporttype, 0 MP, @MinBetv3 as MinBet, @MaxBetv3 as MaxBet, @MaxPerMatchv3 as MaxPerMatch
		union all	select 5 as sporttype, 0 MP, @MinBetv5 as MinBet, @MaxBetv5 as MaxBet, @MaxPerMatchv5 as MaxPerMatch
		union all	select 8 as sporttype, 0 MP, @MinBetv8 as MinBet, @MaxBetv8 as MaxBet, @MaxPerMatchv8 as MaxPerMatch
		union all	select 10 as sporttype, 0 MP, @MinBetv10 as MinBet, @MaxBetv10 as MaxBet, @MaxPerMatchv10 as MaxPerMatch
		union all	select 11 as sporttype, 0 MP, @MinBetv11 as MinBet, @MaxBetv11 as MaxBet, @MaxPerMatchv11 as MaxPerMatch
	
		union all	select 99 as sporttype, 0 MP, @MinBetv99 as MinBet, @MaxBetv99 as MaxBet, @MaxPerMatchv99 as MaxPerMatch	
		
		union all   select 1 as sporttype, 1 MP, @MinBetv1mp as MinBet, @MaxBetv1mp as MaxBet, @MaxPerMatchv1mp as MaxPerMatch
		union all   select 99 as sporttype, 0 MP, @MinBetv99mp as MinBet, @MaxBetv99mp as MaxBet, @MaxPerMatchv99mp as MaxPerMatch
		union all   select 161 as sporttype, 0 MP, @MinBetv161 as MinBet, @MaxBetv161 as MaxBet, @MaxPerMatchv161 as MaxPerMatch 
	) as b on sports.ID = b.sporttype
	where (MinBet<>0 and MaxBet <> 0 and  MinBet>MaxBet) 
	or (MaxBet<> 0 and MaxPerMatch <> 0 and MaxBet>MaxPerMatch) 
	or (MinBet <> 0 and MaxPerMatch <> 0 and MinBet>MaxPerMatch) 

	if @ErrType <>''
	BEGIN
		SELECT
			@ErrMsg =	case @Language 
								when 'E' then 'Min bet must be less than max bet and max bet must be less than max per match ('+@ErrType+').'
								ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language) + ' ('+@ErrType+').'
						end
											
		Select @ErrCode = 103
		return
	END


	Select 
		@MinMinBet = isnull(Max(case when MinBet = 0 then NULL else MinBet end),0), 
		@MaxMaxBet = isnull(Min(case when MaxBet = 0 then NULL else MaxBet end),0)
	from 
		Dep_CustSetting as cs WITH (NOLOCK)
		INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.CustID or cs.CustID = ci.SRecommend) and cs.bettype = 1 and cs.sporttype=1
	where ci.custid = @mrecommend

	Select 
		@MinMinBetv2 = isnull(Max(case when MinBet = 0 then NULL else MinBet end),0), 
		@MaxMaxBetv2 = isnull(Min(case when MaxBet = 0 then NULL else MaxBet end),0)
	from 
		Dep_CustSetting as cs WITH (NOLOCK)
		INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.CustID or cs.CustID = ci.SRecommend) and cs.bettype = 1 and cs.sporttype=2
	where ci.custid = @mrecommend

	Select 
		@MinMinBetv3 = isnull(Max(case when MinBet = 0 then NULL else MinBet end),0), 
		@MaxMaxBetv3 = isnull(Min(case when MaxBet = 0 then NULL else MaxBet end),0)
	from 
		Dep_CustSetting as cs WITH (NOLOCK)
		INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.CustID or cs.CustID = ci.SRecommend) and cs.bettype = 1 and cs.sporttype=3
	where ci.custid = @mrecommend

	Select
		@MinMinBetv5 = isnull(Max(case when MinBet = 0 then NULL else MinBet end),0), 
		@MaxMaxBetv5 = isnull(Min(case when MaxBet = 0 then NULL else MaxBet end),0)
	from 
		Dep_CustSetting as cs WITH (NOLOCK)
		INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.CustID or cs.CustID = ci.SRecommend) and cs.bettype = 1 and cs.sporttype=5
	where ci.custid = @mrecommend

	Select
		@MinMinBetv8 = isnull(Max(case when MinBet = 0 then NULL else MinBet end),0), 
		@MaxMaxBetv8 = isnull(Min(case when MaxBet = 0 then NULL else MaxBet end),0)
	from 
		Dep_CustSetting as cs WITH (NOLOCK)
		INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.CustID or cs.CustID = ci.SRecommend) and cs.bettype = 1 and cs.sporttype=8
	where ci.custid = @mrecommend

	Select
		@MinMinBetv10 = isnull(Max(case when MinBet = 0 then NULL else MinBet end),0), 
		@MaxMaxBetv10 = isnull(Min(case when MaxBet = 0 then NULL else MaxBet end),0)
	from 
		Dep_CustSetting as cs WITH (NOLOCK)
		INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.CustID or cs.CustID = ci.SRecommend) and cs.bettype = 1 and cs.sporttype=10
	where ci.custid = @mrecommend

	Select 
		@MinMinBetv11 = isnull(Max(case when MinBet = 0 then NULL else MinBet end),0), 
		@MaxMaxBetv11 = isnull(Min(case when MaxBet = 0 then NULL else MaxBet end),0)
	from 
		Dep_CustSetting as cs WITH (NOLOCK)
		INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.CustID or cs.CustID = ci.SRecommend) and cs.bettype = 1 and cs.sporttype=11
	where ci.custid = @mrecommend

	
	Select 
		@MinMinBetv99 = isnull(Max(case when MinBet = 0 then NULL else MinBet end),0), 
		@MaxMaxBetv99 = isnull(Min(case when MaxBet = 0 then NULL else MaxBet end),0)
	from 
		Dep_CustSetting as cs WITH (NOLOCK)
		INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.CustID or cs.CustID = ci.SRecommend) and cs.bettype = 1 and cs.sporttype=99
	where ci.custid = @mrecommend


	--- mix parlay of mixed sports
	select	@MinMinBetv1mp = isnull(Max(case when MinBet = 0 then NULL else MinBet end),0),
			@MaxMaxBetv1mp = isnull(Max(case when MaxBet = 0 then NULL else MaxBet end),0)
	from Dep_CustSetting as cs with(nolock) inner join
		custinfo as ci with(nolock) on (cs.custid = ci.custid or cs.custid = ci.srecommend) and cs.bettype = 9 and cs.sporttype = 1
	where ci.custid = @mrecommend
	
	select	@MinMinBetv99mp = isnull(Max(case when MinBet = 0 then NULL else MinBet end),0),
			@MaxMaxBetv99mp = isnull(Max(case when MaxBet = 0 then NULL else MaxBet end),0)
	from Dep_CustSetting as cs with(nolock) inner join
		custinfo as ci with(nolock) on (cs.custid = ci.custid or cs.custid = ci.srecommend) and cs.bettype = 9 and cs.sporttype = 99
	where ci.custid = @mrecommend

	-- number game
	select	@MinMinBetv161 = isnull(max(case when minbet = 0 then null else minbet end),0),
			@MaxMaxBetv161 = isnull(max(case when maxbet = 0 then NULL else maxbet end),0)
	from Dep_CustSetting3rd as cs with(nolock) inner join 
		 custinfo as ci with(nolock) on (cs.custid = ci.custid or cs.custid = ci.srecommend) and cs.bettype = 81 and cs.sporttype = 161
	where ci.custid = @mrecommend

	Select 
		@MaxMaxperMatch = isnull(Min(case when cs.MaxPerMatch = 0 then NULL else cs.MaxPerMatch end),0),	
		@MaxMaxPerMatchv2 = isnull(Min(case when cs.MaxPerMatch2 = 0 then NULL else cs.MaxPerMatch2 end),0),
		@MaxMaxPerMatchv3 = isnull(Min(case when cs.MaxPerMatch3 = 0 then NULL else cs.MaxPerMatch3 end),0),
		@MaxMaxPerMatchv5 = isnull(Min(case when cs.MaxPerMatch5 = 0 then NULL else cs.MaxPerMatch5 end),0),
		@MaxMaxPerMatchv8 = isnull(Min(case when cs.MaxPerMatch8 = 0 then NULL else cs.MaxPerMatch8 end),0),
		@MaxMaxPerMatchv10 = isnull(Min(case when cs.MaxPerMatch10 = 0 then NULL else cs.MaxPerMatch10 end),0),
		@MaxMaxPerMatchv11 = isnull(Min(case when cs.MaxPerMatch11 = 0 then NULL else cs.MaxPerMatch11 end),0),		
		@MaxMaxPerMatchv99 = isnull(Min(case when cs.MaxPerMatch99 = 0 then NULL else cs.MaxPerMatch99 end),0),
		
		@MaxMaxPerMatchv1mp = isnull(min(case when cs.MaxPerMatch1MP = 0 then NULL else cs.MaxPerMatch1MP end),0),	
		@MaxMaxPerMatchv99mp = isnull(min(case when cs.MaxPerMatch99MP = 0 then NULL else cs.MaxPerMatch99MP end),0),
		@MaxMaxPerMatchv161 = isnull(min(case when cs.MaxPerMatch161 = 0 then NULL else cs.MaxPerMatch161 end),0),
		@MaxMaxPerBallv161 = isnull(min(case when cs.MaxPerBall161 = 0 then NULL else cs.MaxPerBall161 end),0)
	from 
		custinfo as cs WITH (NOLOCK) 
		INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.CustID or cs.CustID = ci.SRecommend)
	where ci.custid = @mrecommend

	--Dom@20120322
	select @site = site from customer with (nolock) where CustID = @srecommend

	--Vinh@20080213: get transfer option from master
	select	@TransferOption_dec = TransferOption from custmaster with (nolock) where CustID = @mrecommend

	select @ErrType = ''
	select @ErrType = @ErrType + CASE WHEN b.sporttype = 1 AND MP = 1 THEN 'Soccer Parlay' ELSE sports.Name END + ', '
	from #tmp_Sports sports inner join
	(
					select 1 as sporttype, 0 MP, @MinBetv1 as MinBet, @MinMinBet as MinMinBet
		union all 	select 1 as sporttype, 1 MP, @MinBetv1MP as MinBet, @MinMinBetv1MP as MinMinBet				
		union all	select 2 as sporttype, 0 MP, @MinBetv2 as MinBet, @MinMinBetv2 as MinMinBet
		union all	select 3 as sporttype, 0 MP, @MinBetv3 as MinBet, @MinMinBetv3 as MinMinBet
		union all	select 5 as sporttype, 0 MP, @MinBetv5 as MinBet, @MinMinBetv5 as MinMinBet
		union all	select 8 as sporttype, 0 MP, @MinBetv8 as MinBet, @MinMinBetv8 as MinMinBet
		union all	select 10 as sporttype, 0 MP, @MinBetv10 as MinBet, @MinMinBetv10 as MinMinBet
		union all	select 11 as sporttype, 0 MP, @MinBetv11 as MinBet, @MinMinBetv11 as MinMinBet	
		union all	select 99 as sporttype, 0 MP, @MinBetv99 as MinBet, @MinMinBetv99 as MinMinBet
		union all   select 99 as sporttype, 0 MP, @MinBetv99mp as MinBet, @MinMinBetv99mp as MinMinBet
		
		union all   select 161 as sporttype, 0 MP, @MinBetv161 as MinBet, @MinMinBetv161 as MinMinBet	 
	) as b on sports.ID = b.sporttype
	where MinMinBet>0 and MinBet>0 and MinBet<MinMinBet

	if @ErrType <>''
	BEGIN
		SELECT
			@ErrMsg =	case @Language 
								when 'E' then 'Min bet must be equal to or greater than master agent min bet ('+@ErrType+').'
								ELSE [dbo].[f_Get_MsgNamebyMsgID](10019,@Language) + ' ('+@ErrType+').'
						end										
		Select @ErrCode = 105
		return
	END


	select @ErrType = ''
	select @ErrType = @ErrType + CASE WHEN sporttype = 1 AND MP = 1 THEN 'Soccer Parlay' ELSE sports.Name END + ', '
	from #tmp_Sports sports inner join
	(
					select 1 as sporttype, 0 MP, @MaxBetv1 as MaxBet, @MaxMaxBet as MaxMaxBet
		union all	select 2 as sporttype, 0 MP, @MaxBetv2 as MaxBet, @MaxMaxBetv2 as MaxMaxBet
		union all	select 3 as sporttype, 0 MP, @MaxBetv3 as MaxBet, @MaxMaxBetv3 as MaxMaxBet
		union all	select 5 as sporttype, 0 MP, @MaxBetv5 as MaxBet, @MaxMaxBetv5 as MaxMaxBet
		union all	select 8 as sporttype, 0 MP, @MaxBetv8 as MaxBet, @MaxMaxBetv8 as MaxMaxBet
		union all	select 10 as sporttype, 0 MP, @MaxBetv10 as MaxBet, @MaxMaxBetv10 as MaxMaxBet
		union all	select 11 as sporttype, 0 MP, @MaxBetv11 as MaxBet, @MaxMaxBetv11 as MaxMaxBet	
		union all	select 99 as sporttype, 0 MP, @MaxBetv99 as MaxBet, @MaxMaxBetv99 as MaxMaxBet
		
		union all   select 1 as sporttype, 1 MP, @MaxBetv1mp as MaxBet, @MaxMaxBetv1mp as MaxMaxBet
		union all   select 99 as sporttype, 0 MP, @MaxBetv99mp as MaxBet, @MaxMaxBetv99mp as MaxMaxBet
		union all   select 161 as sporttype, 0 MP, @MaxBetv161 as MaxBet, @MaxMaxBetv161 as MaxMaxBet
	) as b on sports.ID = b.sporttype
	where MaxMaxBet>0 and MaxBet>0 and MaxBet>MaxMaxBet

	if @ErrType <>''
	BEGIN
		SELECT
			@ErrMsg =	case @Language 
								when 'E' then 'Max bet must be equal to or less than master agent max bet ('+@ErrType+').'
								ELSE [dbo].[f_Get_MsgNamebyMsgID](10020,@Language) + ' ('+@ErrType+').'
						end
											
		Select @ErrCode = 107
		return
	END


	select @ErrType = ''
	select @ErrType = @ErrType + CASE WHEN sporttype = 1 AND MP = 1 THEN 'Soccer Parlay' ELSE sports.Name END + ', '
	from #tmp_Sports sports inner join
	(
					select 1 as sporttype, 0 MP, @MaxPerMatchv1 as MaxPerMatch, @MaxMaxPerMatch as MaxMaxPerMatch
		union all	select 2 as sporttype, 0 MP, @MaxPerMatchv2 as MaxPerMatch, @MaxMaxPerMatchv2 as MaxMaxPerMatch
		union all	select 3 as sporttype, 0 MP, @MaxPerMatchv3 as MaxPerMatch, @MaxMaxPerMatchv3 as MaxMaxPerMatch
		union all	select 5 as sporttype, 0 MP, @MaxPerMatchv5 as MaxPerMatch, @MaxMaxPerMatchv5 as MaxMaxPerMatch
		union all	select 8 as sporttype, 0 MP, @MaxPerMatchv8 as MaxPerMatch, @MaxMaxPerMatchv8 as MaxMaxPerMatch
		union all	select 10 as sporttype, 0 MP, @MaxPerMatchv10 as MaxPerMatch, @MaxMaxPerMatchv10 as MaxMaxPerMatch
		union all	select 11 as sporttype, 0 MP, @MaxPerMatchv11 as MaxPerMatch, @MaxMaxPerMatchv11 as MaxMaxPerMatch		
		union all	select 99 as sporttype, 0 MP, @MaxPerMatchv99 as MaxPerMatch, @MaxMaxPerMatchv99 as MaxMaxPerMatch	 
		
		union all	select 1 as sporttype, 1 MP, @MaxPerMatchv1mp as MaxPerMatch, @MaxMaxPerMatchv1mp as MaxMaxPerMatch
		union all	select 99 as sporttype, 0 MP, @MaxPerMatchv99mp as MaxPerMatch, @MaxMaxPerMatchv99mp as MaxMaxPerMatch
		union all	select 161 as sporttype, 0 MP, @MaxPerMatchv161 as MaxPerMatch, @MaxMaxPerMatchv161 as MaxMaxPerMatch
	) as b on sports.ID = b.sporttype
	where MaxMaxPerMatch>0 and MaxPerMatch>0 and MaxPerMatch>MaxMaxPerMatch

	if @ErrType <>''
	BEGIN
		SELECT
			@ErrMsg =	case @Language 
								when 'E' then 'Max Per Match must be equal to or less than master agent Max Per Match ('+@ErrType+').'
								ELSE [dbo].[f_Get_MsgNamebyMsgID](10021,@Language) + ' ('+@ErrType+').'
						end
											
		Select @ErrCode = 107
		return
	END

	if @MaxPerBallv161 > @MaxMaxPerBallv161 and @MaxMaxPerBallv161 > 0
	begin
		SELECT
			@ErrMsg =	case @Language 
								when 'E' then 'Max Per Ball must be equal to or less than Master Agent Max Per Ball (Number Game).'
								ELSE [dbo].[f_Get_MsgNamebyMsgID](10011,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](161,@Language) + ')'
						end										
		Select @ErrCode = 201
		return
	end


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
	
		@DisableCasino = 0,
		@IsInternal = 0,
		@DisableNumber = @DisableNumber,
		@MaxPerMatch = @MaxPerMatchv1,
		@MaxPerMatchv2 = @MaxPerMatchv2,
		@MaxPerMatchv3 = @MaxPerMatchv3,
		@MaxPerMatchv5 = @MaxPerMatchv5,
		@MaxPerMatchv8 = @MaxPerMatchv8,
		@MaxPerMatchv10 = @MaxPerMatchv10,
		@MaxPerMatchv11 = @MaxPerMatchv11,		
		@MaxPerMatchv99 = @MaxPerMatchv99,

	
		@MaxPerMatchv1MP = @MaxPerMatchv1mp,
		@MaxPerMatchv99MP = @MaxPerMatchv99mp,		
		
		@MaxPerMatchv161 = @MaxPerMatchv161,	
		@MaxPerBallv161 = @MaxPerBallv161,
		
		
		@hidekeno=@DisableKeno,

		@credit = 0,
		@maxcredit = 0,
	
		@IP = @IP,
		@TransferOption_dec = @TransferOption_dec,
		@Language = @Language,
		@ErrCode = @ErrCode OUTPUT,
		@ErrMsg = @ErrMsg OUTPUT

	if @ErrCode <> 0
		return

	SELECT @Rollback= ' DELETE Dep_CustSetting WITH (ROWLOCK) WHERE custId ='+COALESCE(CAST(@custid AS VARCHAR(50)),SPACE(1))+
					 ' DELETE Dep_CustSetting3rd WITH (ROWLOCK) WHERE custId  ='+COALESCE(CAST(@custid AS VARCHAR(50)),SPACE(1))+
					 ' DELETE FROM Dep_CustSuper WITH(ROWLOCK) WHERE custId = '+COALESCE(CAST(@custid AS VARCHAR(50)),SPACE(1))+
			 		 
					 ' DELETE CustSettingGame WITH(ROWLOCK) WHERE custid = '+COALESCE(CAST(@custid AS VARCHAR(50)),SPACE(1))	+
					 ' DELETE CustGameType WITH(ROWLOCK) WHERE custid = '+COALESCE(CAST(@custid AS VARCHAR(50)),SPACE(1))	+
					 ' EXEC Acc_CustomerInsUserInfo_Rollback @CustID = '+COALESCE(CAST(@custid AS VARCHAR(50)),SPACE(1))


	INSERT INTO [dbo].[Dep_CustSetting]([custId], [bettype], [sporttype], [apositiontaking], [mpositiontaking], [spositiontaking], [playerdiscount], [discount], [adiscount], [sdiscount], [Minbet], [Maxbet],[islive])
	SELECT @custid, 1, 1, @v1apositiontaking_1, @v1mpositiontaking_1, 0, 0, 0, 0, 0, @MinBetv1, @MaxBetv1, 0
	UNION ALL
	SELECT @custid, 1, 1, @v1alivepositiontaking_1, @v1mlivepositiontaking_1, 0, 0, 0, 0, 0, @MinBetv1, @MaxBetv1, 1
	UNION ALL	
	SELECT @custid, 3, 1, @v1apositiontaking_3, @v1mpositiontaking_3, 0, 0, 0, 0, 0, @MinBetv1, @MaxBetv1, 0
	UNION ALL	
	SELECT @custid, 3, 1, @v1alivepositiontaking_3, @v1mlivepositiontaking_3, 0, 0, 0, 0, 0, @MinBetv1, @MaxBetv1, 1
	UNION ALL	
	SELECT @custid, 7, 1, @v1apositiontaking_7, @v1mpositiontaking_7, 0, 0, 0, 0, 0, @MinBetv1, @MaxBetv1, 0
	UNION ALL	
	SELECT @custid, 7, 1, @v1alivepositiontaking_7, @v1mlivepositiontaking_7, 0, 0, 0, 0, 0, @MinBetv1, @MaxBetv1, 1
	UNION ALL	
	SELECT @custid, 8, 1, @v1apositiontaking_8, @v1mpositiontaking_8, 0, 0, 0, 0, 0,  @MinBetv1, @MaxBetv1, 0
	UNION ALL	
	SELECT @custid, 8, 1, @v1alivepositiontaking_8, @v1mlivepositiontaking_8, 0, 0, 0, 0, 0, @MinBetv1, @MaxBetv1, 1

	UNION ALL	SELECT @custid, 2, 1, @v1apositiontaking_2, @v1mpositiontaking_2, 0, 0, 0, 0, 0, @MinBetv1, @MaxBetv1, 0
	--------------------------------------------------------------------------------------
	--1x2
	UNION ALL	SELECT @custid, 5, 1, @v1apositiontaking_5, @v1mpositiontaking_5, 0, 0, 0, 0, 0, @MinBetv1, @MaxBetv1, 0

	UNION ALL	SELECT @custid, 4, 1, @v1apositiontaking_4, @v1mpositiontaking_4, 0, 0, 0, 0, 0, @MinBetv1, @MaxBetv1, 0
	UNION ALL	SELECT @custid, 6, 1, @v1apositiontaking_6, @v1mpositiontaking_6, 0, 0, 0, 0, 0, @MinBetv1, @MaxBetv1, 0
	UNION ALL	SELECT @custid, 9, 1, @v1apositiontaking_9, @v1mpositiontaking_9, 0, 0, 0, 0, 0, @MinBetv1mp, @MaxBetv1mp, 0
	UNION ALL	SELECT @custid, 10, 1, @v1apositiontaking_10, @v1mpositiontaking_10, 0, 0, 0, 0, 0, @MinBetv1, @MaxBetv1, 0

	UNION ALL	SELECT @custid, 1, 2, @v2apositiontaking_1, @v2mpositiontaking_1, 0, 0, 0, 0, 0, @MinBetv2, @MaxBetv2, 0
	UNION ALL	SELECT @custid, 2, 2, @v2apositiontaking_2, @v2mpositiontaking_2, 0, 0, 0, 0, 0, @MinBetv2, @MaxBetv2, 0
	UNION ALL	SELECT @custid, 3, 2, @v2apositiontaking_3, @v2mpositiontaking_3, 0, 0, 0, 0, 0, @MinBetv2, @MaxBetv2, 0
	UNION ALL	SELECT @custid, 7, 2, @v2apositiontaking_7, @v2mpositiontaking_7, 0, 0, 0, 0, 0, @MinBetv2, @MaxBetv2, 0
	UNION ALL	SELECT @custid, 8, 2, @v2apositiontaking_8, @v2mpositiontaking_8, 0, 0, 0, 0, 0, @MinBetv2, @MaxBetv2, 0

	UNION ALL	SELECT @custid, 20, 2, @v2apositiontaking_20, @v2mpositiontaking_20, 0, 0, 0, 0, 0, @MinBetv2, @MaxBetv2, 0

	UNION ALL	SELECT @custid, 1, 3, @v3apositiontaking_1, @v3mpositiontaking_1, 0, 0, 0, 0, 0, @MinBetv3, @MaxBetv3, 0
	UNION ALL	SELECT @custid, 2, 3, @v3apositiontaking_2, @v3mpositiontaking_2, 0, 0, 0, 0, 0, @MinBetv3, @MaxBetv3, 0
	UNION ALL	SELECT @custid, 3, 3, @v3apositiontaking_3, @v3mpositiontaking_3, 0, 0, 0, 0, 0, @MinBetv3, @MaxBetv3, 0
	UNION ALL	SELECT @custid, 20, 3, @v3apositiontaking_20, @v3mpositiontaking_20, 0, 0, 0, 0, 0, @MinBetv3, @MaxBetv3, 0

	UNION ALL	SELECT @custid, 1, 5, @v5apositiontaking_1, @v5mpositiontaking_1, 0, 0, 0, 0, 0, @MinBetv5, @MaxBetv5, 0
	UNION ALL	SELECT @custid, 2, 5, @v5apositiontaking_2, @v5mpositiontaking_2, 0, 0, 0, 0, 0, @MinBetv5, @MaxBetv5, 0
	UNION ALL	SELECT @custid, 3, 5, @v5apositiontaking_3, @v5mpositiontaking_3, 0, 0, 0, 0, 0, @MinBetv5, @MaxBetv5, 0
	UNION ALL	SELECT @custid, 20, 5, @v5apositiontaking_20, @v5mpositiontaking_20, 0, 0, 0, 0, 0, @MinBetv5, @MaxBetv5, 0

	UNION ALL	SELECT @custid, 1, 8, @v8apositiontaking_1, @v8mpositiontaking_1, 0, 0, 0, 0, 0, @MinBetv8, @MaxBetv8, 0
	UNION ALL	SELECT @custid, 3, 8, @v8apositiontaking_3, @v8mpositiontaking_3, 0, 0, 0, 0, 0, @MinBetv8, @MaxBetv8, 0
	UNION ALL	SELECT @custid, 20, 8, @v8apositiontaking_20, @v8mpositiontaking_20, 0, 0, 0, 0, 0, @MinBetv8, @MaxBetv8, 0

	UNION ALL	SELECT @custid, 1, 10, @v10apositiontaking_1, @v10mpositiontaking_1, 0, 0, 0, 0, 0, @MinBetv10, @MaxBetv10, 0
	UNION ALL	SELECT @custid, 2, 10, @v10apositiontaking_2, @v10mpositiontaking_2, 0, 0, 0, 0, 0, @MinBetv10, @MaxBetv10, 0
	UNION ALL	SELECT @custid, 3, 10, @v10apositiontaking_3, @v10mpositiontaking_3, 0, 0, 0, 0, 0, @MinBetv10, @MaxBetv10, 0
	UNION ALL	SELECT @custid, 20, 10, @v10apositiontaking_20, @v10mpositiontaking_20, 0, 0, 0, 0, 0, @MinBetv10, @MaxBetv10, 0

	UNION ALL	SELECT @custid, 1, 11, @v11apositiontaking_1, @v11mpositiontaking_1, 0, 0, 0, 0, 0, @MinBetv11, @MaxBetv11, 0
	UNION ALL	SELECT @custid, 20, 11, @v11apositiontaking_20, @v11mpositiontaking_20, 0, 0, 0, 0, 0, @MinBetv11, @MaxBetv11, 0

	UNION ALL	SELECT @custid, 1, 99, @v99apositiontaking_1, @v99mpositiontaking_1, 0, 0, 0, 0, 0, @MinBetv99, @MaxBetv99, 0
	UNION ALL	SELECT @custid, 2, 99, @v99apositiontaking_2, @v99mpositiontaking_2, 0, 0, 0, 0, 0, @MinBetv99, @MaxBetv99, 0
	UNION ALL	SELECT @custid, 3, 99, @v99apositiontaking_3, @v99mpositiontaking_3, 0, 0, 0, 0, 0, @MinBetv99, @MaxBetv99, 0
	UNION ALL	SELECT @custid, 20, 99, @v99apositiontaking_20, @v99mpositiontaking_20, 0, 0, 0, 0, 0, @MinBetv99, @MaxBetv99, 0

	--Mix Sports Parlay
	UNION ALL	SELECT @custid, 9, 99, @v99apositiontaking_9, @v99mpositiontaking_9, 0, 0, 0, 0, 0, @MinBetv99MP, @MaxBetv99MP, 0

	if @@error <> 0
	BEGIN
		--Error occur	
		SELECT @ErrMsg = case @Language 
								when 'E' then 'Create customer failed. Please try again.'
								ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
							end,
			@ErrCode = 114
		
		-- ROLLBACK MANUALLY
		DELETE [Dep_CustSetting] with (ROWLOCK) where custid =  @custid
		
			EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
		return
	END

	--insert into CustSetting3rd
	INSERT INTO [dbo].[Dep_CustSetting3rd]([custId], [bettype], [sporttype], [apositiontaking], [mpositiontaking], [spositiontaking],  [playerdiscount], [discount], [adiscount], [sdiscount], [Minbet], [Maxbet], [islive])

	--v161
		SELECT @custid, 81, 161, @v161apositiontaking_81, @v161mpositiontaking_81, 0, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 0--nonlive
	UNION ALL	SELECT @custid, 83, 161, @v161apositiontaking_83, @v161mpositiontaking_83, 0, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 0--nonlive
	UNION ALL	SELECT @custid, 85, 161, @v161alivepositiontaking_85, @v161mlivepositiontaking_85, 0, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 1--live

	UNION ALL	SELECT @custid, 86, 161, @v161apositiontaking_86, @v161mpositiontaking_86, 0, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 0--nonlive
	UNION ALL	SELECT @custid, 86, 161, @v161alivepositiontaking_86, @v161mlivepositiontaking_86, 0, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 1--live 

	UNION ALL	SELECT @custid, 87, 161, @v161alivepositiontaking_87, @v161mlivepositiontaking_87, 0, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 1--live
	UNION ALL	SELECT @custid, 88, 161, @v161apositiontaking_88, @v161mpositiontaking_88, 0, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 0--nonlive
	UNION ALL	SELECT @custid, 89, 161, @v161alivepositiontaking_89, @v161mlivepositiontaking_89, 0, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 1--live
	UNION ALL	SELECT @custid, 90, 161, @v161alivepositiontaking_90, @v161mlivepositiontaking_90, 0, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 1--live

	if @@error <> 0
	BEGIN
		--Error occur	
		SELECT @ErrMsg = case @Language 
								when 'E' then 'Create customer failed. Please try again.'
								ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
							end,
			@ErrCode = 114
		
		-- ROLLBACK MANUALLY
		DELETE [Dep_CustSetting] with (ROWLOCK) where custid =  @custid
		DELETE [Dep_CustSetting3rd] with (ROWLOCK) where custid =  @custid
		
			EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
		return
	END



	/**********************************
	* Keno validate Min/Max Bet & MaxPerMatch
	**********************************/
	DECLARE @Bet money
	IF EXISTS (SELECT top 1 1 FROM #data WHERE (MinBet > Maxbet))
	BEGIN	
		SELECT top 1 @Bet=Maxbet FROM #data WHERE (MinBet > Maxbet) ORDER BY bettype DESC
		SELECT
			@ErrMsg =	case @Language 
								when 'E' then 'Min Bet must be less than '+COALESCE(CAST(@Bet AS VARCHAR(50)),SPACE(1))+' (Max Bet).'
								ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language)
						end
											
		Select @ErrCode = 103	
		--EXEC sp_executesql @Rollback 
		DELETE Dep_CustSetting WITH (ROWLOCK) WHERE custId =@custid
		DELETE Dep_CustSetting3rd WITH (ROWLOCK) WHERE custId  =@custid
		DELETE Dep_CustSuper WITH(ROWLOCK) WHERE custId = @CustID
	
		DELETE CustGameType WITH(ROWLOCK) WHERE custid =@custid
		DELETE CustSettingGame WITH(ROWLOCK) WHERE custid = @custid
		DELETE CustOverrideGame WITH(ROWLOCK) WHERE custid = @custid
		EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
		RETURN
	END

	IF EXISTS (SELECT top 1 1 FROM #data WHERE (MinBet > MaxPerMatch))
	BEGIN	
		SELECT top 1 @Bet=MaxPerMatch FROM #data WHERE (MinBet > MaxPerMatch) ORDER BY bettype DESC
		SELECT
			@ErrMsg =	case @Language 
								when 'E' then 'Min Bet must be less than '+COALESCE(CAST(@Bet AS VARCHAR(50)),SPACE(1))+' (Max Per Match).'
								ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language)
						end
											
		Select @ErrCode = 103	
		--EXEC sp_executesql @Rollback 
		DELETE Dep_CustSetting WITH (ROWLOCK) WHERE custId =@custid
		DELETE Dep_CustSetting3rd WITH (ROWLOCK) WHERE custId  =@custid
		DELETE Dep_CustSuper WITH(ROWLOCK) WHERE custId = @CustID
	
		DELETE CustGameType WITH(ROWLOCK) WHERE custid =@custid
		DELETE CustSettingGame WITH(ROWLOCK) WHERE custid = @custid
		DELETE CustOverrideGame WITH(ROWLOCK) WHERE custid = @custid
		EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
		RETURN
	END



	IF EXISTS (SELECT top 1 1 FROM #data WHERE (MaxBet > MaxPerMatch))
	BEGIN	
		SELECT top 1 @Bet=MaxPerMatch FROM #data WHERE (MaxBet > MaxPerMatch) ORDER BY bettype DESC
		SELECT
			@ErrMsg =	case @Language 
								when 'E' then 'Max Bet must be less than '+COALESCE(CAST(@Bet AS VARCHAR(50)),SPACE(1))+' (Max Per Match).'
								ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language)
						end
											
		Select @ErrCode = 103		
		--EXEC sp_executesql @Rollback 
		DELETE Dep_CustSetting WITH (ROWLOCK) WHERE custId =@custid
		DELETE Dep_CustSetting3rd WITH (ROWLOCK) WHERE custId  =@custid
		DELETE Dep_CustSuper WITH(ROWLOCK) WHERE custId = @CustID
	
		DELETE CustGameType WITH(ROWLOCK) WHERE custid =@custid
		DELETE CustSettingGame WITH(ROWLOCK) WHERE custid = @custid
		DELETE CustOverrideGame WITH(ROWLOCK) WHERE custid = @custid
		EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
		RETURN
	END

	--check minBet maxBet PT Upline
	SELECT  gt.IBCBetTypeID Bettype,
			isnull(cgt.minbet,0) AS MinBetMin, 
			isnull(cgt.maxbet,0) AS MaxbetMax, 
			isnull(csg.mpositiontaking,0) AS MaxPT,
			isnull(cgt.MaxPerGameType,0) AS MaxPerMarchMax
	INTO #MinMaxUpline
	FROM dbo.CustGameType cgt WITH(NOLOCK)
		INNER JOIN CustSettingGame csg ON cgt.custid = csg.custid
		INNER JOIN #tmp_GameType gT ON cgt.GameTypeID = gt.ID
	WHERE cgt.custid = @mrecommend
		AND csg.sporttype = 202	

	IF EXISTS (SELECT top 1 1 
				FROM #data d INNER JOIN #MinMaxUpline m on d.bettype=m.bettype
				WHERE (d.MinBet < m.MinBetMin) and d.MinBet > 0) 
	BEGIN	
		SELECT top 1 @Bet=MinBetMax FROM #data d INNER JOIN #MinMaxUpline m on d.bettype=m.bettype
				WHERE (d.MinBet < m.MinBetMin) ORDER BY d.bettype DESC
		SELECT
			@ErrMsg =	case @Language 
								when 'E' then 'Min Bet must be greater than or equal '+COALESCE(CAST(@Bet AS VARCHAR(50)),SPACE(1))+' (Max Per Match).'
								ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language)
						end
											
		Select @ErrCode = 103		
		--EXEC sp_executesql @Rollback 
		DELETE Dep_CustSetting WITH (ROWLOCK) WHERE custId =@custid
		DELETE Dep_CustSetting3rd WITH (ROWLOCK) WHERE custId  =@custid
		DELETE Dep_CustSuper WITH(ROWLOCK) WHERE custId = @CustID
		
		DELETE CustGameType WITH(ROWLOCK) WHERE custid =@custid
		DELETE CustSettingGame WITH(ROWLOCK) WHERE custid = @custid
		DELETE CustOverrideGame WITH(ROWLOCK) WHERE custid = @custid
		EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
		RETURN
	END
	IF EXISTS (SELECT top 1 1 
				FROM #data d INNER JOIN #MinMaxUpline m on d.bettype=m.bettype
				WHERE (d.MaxBet > m.MaxbetMax) and d.MaxBet > 0) 
	BEGIN	
		SELECT top 1 @Bet=MaxbetMax FROM #data d INNER JOIN #MinMaxUpline m on d.bettype=m.bettype
				WHERE (d.MaxBet > m.MaxbetMax) ORDER BY d.bettype DESC
		SELECT
			@ErrMsg =	case @Language 
								when 'E' then 'Max Bet must be less than or equal '+COALESCE(CAST(@Bet AS VARCHAR(50)),SPACE(1))+' (Max Per Match).'
								ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language)
						end
											
		Select @ErrCode = 103	
		--EXEC sp_executesql @Rollback 	
		DELETE Dep_CustSetting WITH (ROWLOCK) WHERE custId =@custid
		DELETE Dep_CustSetting3rd WITH (ROWLOCK) WHERE custId  =@custid
		DELETE Dep_CustSuper WITH(ROWLOCK) WHERE custId = @CustID
	
		DELETE CustGameType WITH(ROWLOCK) WHERE custid =@custid
		DELETE CustSettingGame WITH(ROWLOCK) WHERE custid = @custid
		DELETE CustOverrideGame WITH(ROWLOCK) WHERE custid = @custid
		EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
		RETURN
	END
	IF EXISTS (SELECT top 1 1 
				FROM #data d INNER JOIN #MinMaxUpline m on d.bettype=m.bettype
				WHERE (d.MaxPerMatch > m.MaxPerMarchMax) and d.MaxPerMatch >0)
	BEGIN	
		SELECT top 1 @Bet=MaxPerMarchMax FROM #data d INNER JOIN #MinMaxUpline m on d.bettype=m.bettype
				WHERE (d.MaxPerMatch > m.MaxPerMarchMax) ORDER BY d.bettype DESC
		SELECT
			@ErrMsg =	case @Language 
								when 'E' then 'Max Per Match must be less than or equal '+COALESCE(CAST(@Bet AS VARCHAR(50)),SPACE(1))+' (Max Per Match).'
								ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language)
						end
											
		Select @ErrCode = 103		
		DELETE Dep_CustSetting WITH (ROWLOCK) WHERE custId =@custid
		DELETE Dep_CustSetting3rd WITH (ROWLOCK) WHERE custId  =@custid
		DELETE Dep_CustSuper WITH(ROWLOCK) WHERE custId = @CustID
		
		DELETE CustGameType WITH(ROWLOCK) WHERE custid =@custid
		DELETE CustSettingGame WITH(ROWLOCK) WHERE custid = @custid
		DELETE CustOverrideGame WITH(ROWLOCK) WHERE custid = @custid
		EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
		RETURN
	END

	--check PT
	IF EXISTS (SELECT top 1 1 
				FROM #data d INNER JOIN #MinMaxUpline m on d.bettype=m.bettype
				WHERE (d.mPositionTaking > m.MaxPT) and d.mPositionTaking > 0)
	BEGIN	
		SELECT top 1 @Bet=MaxPerMarchMax FROM #data d INNER JOIN #MinMaxUpline m on d.bettype=m.bettype
				WHERE (d.mPositionTaking > m.MaxPT) ORDER BY d.bettype DESC
		SELECT
			@ErrMsg =	case @Language 
								when 'E' then 'Keno Position Taking is invalid.'
								ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language)
						end
											
		Select @ErrCode = 103		
		--EXEC sp_executesql @Rollback 
		DELETE Dep_CustSetting WITH (ROWLOCK) WHERE custId =@custid
		DELETE Dep_CustSetting3rd WITH (ROWLOCK) WHERE custId  =@custid
		DELETE Dep_CustSuper WITH(ROWLOCK) WHERE custId = @CustID
	
		DELETE CustGameType WITH(ROWLOCK) WHERE custid =@custid
		DELETE CustSettingGame WITH(ROWLOCK) WHERE custid = @custid
		DELETE CustOverrideGame WITH(ROWLOCK) WHERE custid = @custid
		EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
		RETURN
	END

	--insert
	INSERT INTO CustSettingGame([CustID]
			   ,[Bettype]
			   ,[Sporttype]
			   ,[apositiontaking]
			   ,[mpositiontaking]
			   ,[spositiontaking]
			   ,[playerdiscount]
			   ,[discount]
			   ,[adiscount]
			   ,[sdiscount]
			   ,[autopositiontaking]
			   ,[isautopositiontaking]
			   ,[autompositiontaking]
			   ,[isautompositiontaking])
	SELECT @custid , Bettype, 202, ISNULL(aPositionTaking,0), 0, 0, 0, 0, 0, 0, 0, 0 ,0 ,0
	FROM #data
	WHERE Bettype=1501

	INSERT INTO dbo.CustGameType(CustID,GameTypeID,StakeLevelList,MaxPerGameType,MinBet,MaxBet,IsDisabled)
	SELECT @custid,gt.ID,'',MaxPerMatch,MinBet,MaxBet,d.IsDisable 
	FROM #data d INNER JOIN #tmp_GameType gt ON d.bettype=gt.IBCBetTypeID

	IF @@ERROR <> 0
	BEGIN
		--Error Occurs
		SELECT @ErrMsg = CASE @Language 
								when 'E' then 'Create customer fail. Please try again'
								ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
							END	
				, @ErrCode=116
		
		DELETE Dep_CustSetting WITH (ROWLOCK) WHERE custId =@custid
		DELETE Dep_CustSetting3rd WITH (ROWLOCK) WHERE custId  =@custid
		DELETE Dep_CustSuper WITH(ROWLOCK) WHERE custId = @CustID
		
		DELETE CustGameType WITH(ROWLOCK) WHERE custid =@custid
		DELETE CustSettingGame WITH(ROWLOCK) WHERE custid = @custid
		DELETE CustOverrideGame WITH(ROWLOCK) WHERE custid = @custid
		EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
		RETURN
	END 

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

	 IF @ErrCode <> 0 
	 BEGIN 	
 		DELETE dep_custsetting with (ROWLOCK) where custid =  @custid
		DELETE dep_custsetting3rd with (ROWLOCK) where custid =  @custid
		
		DELETE custsettingGame WITH (ROWLOCK) WHERE custId  =@custid
		DELETE Custoverridegame WITH (ROWLOCK) WHERE custId  =@custid	
		EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
		DELETE Dep_AgentCommRate WITH(ROWLOCK) WHERE custid = @custid
 		RETURN 
	 END  
	-------Check & Insert for CashOut  

	IF EXISTS (SELECT TOP 1 1 FROM TradeComm t WITH(NOLOCK) 
				INNER JOIN custInfo c WITH(NOLOCK) ON t.AgentID=c.custid
				WHERE srecommend=@srecommend)
	BEGIN
			SELECT a.userName + 'CashOut' AS UserName, a.custid AS recommend, a.mrecommend, a.currency, a.site, a.refcode1
					, a.refcode2, a.ugroup, b.[closed], b.[MatchLimit], b.[VirtualMultiplier], b.[Enabled], b.[danger]
					, b.[DisableCasino], b.[SyncCasino], b.[danger2], b.[danger3], b.[DisableOutright]
					, b.[MaxPerMatch99MP], b.[DisableNumber], b.[maxpermatch161]
					, b.[MaxPerBall161],					
					b.[Abnormal], b.[DoubleCommLosing]
				INTO #tempCashOut
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
					, [MatchLimit], [VirtualMultiplier], [Enabled], [danger],  [DisableCasino]
					, [SyncCasino], [danger2], [danger3], [DisableOutright], [MaxPerMatch99MP],[DisableNumber]
					, [maxpermatch161], [MaxPerBall161]					
					, [Abnormal], [DoubleCommLosing], credit)
				SELECT a.[username], a.[custid], a.[currency], a.[roleid], a.[srecommend], a.[mrecommend], a.[recommend], b.[closed]
					, b.[MatchLimit], b.[VirtualMultiplier], b.[Enabled], b.[danger], b.[DisableCasino]
					, b.[SyncCasino], b.[danger2], b.[danger3], b.[DisableOutright], b.[MaxPerMatch99MP],[DisableNumber]
					, b.[maxpermatch161], b.[MaxPerBall161]
					,  b.[Abnormal], b.[DoubleCommLosing], 0
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
				----Insert Dep_Custsetting
					INSERT INTO [dbo].[Dep_CustSetting] ([custid], [bettype], [sporttype], [islive], [apositiontaking], [mpositiontaking]
						, [spositiontaking], [playerdiscount], [discount], [adiscount], [sdiscount], [minbet], [maxbet])
					SELECT @tradeCustId, [bettype], [sporttype], [islive], [apositiontaking], [mpositiontaking], [spositiontaking]
						, [playerdiscount], [discount], [adiscount], [sdiscount], [minbet], [maxbet]
					FROM [Dep_CustSetting] a(NOLOCK)
					WHERE custid = @tradeAgentId		

					---------------------------------------------------------------------------------  
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
						FROM [Dep_CustSetting] a(NOLOCK)
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
				---------------------------------------------------------------------------------  
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
						FROM [Dep_CustSetting] a(NOLOCK)
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
						FROM [Dep_CustSetting] a(NOLOCK)
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
			@DisableNumber	=	1,
			
			@MinBetv1			=	@PTDummy,
			@MaxBetv1			=	@PTDummy,
			@MaxPerMatchv1		=	@PTDummy,
			@MinBetv2			=	@PTDummy,
			@MaxBetv2			=	@PTDummy,
			@MaxPerMatchv2		=	@PTDummy,
			@MinBetv3			=	@PTDummy,
			@MaxBetv3			=	@PTDummy,
			@MaxPerMatchv3		=	@PTDummy,
			@MinBetv5			=	@PTDummy,
			@MaxBetv5			=	@PTDummy,
			@MaxPerMatchv5		=	@PTDummy,
			@MinBetv8			=	@PTDummy,
			@MaxBetv8			=	@PTDummy,
			@MaxPerMatchv8		=	@PTDummy,
			@MinBetv10			=	@PTDummy,
			@MaxBetv10			=	@PTDummy,
			@MaxPerMatchv10		=	@PTDummy,
			@MinBetv11			=	@PTDummy,
			@MaxBetv11			=	@PTDummy,
			@MaxPerMatchv11		=	@PTDummy,
			@MinBetv99			=	@PTDummy,
			@MaxBetv99			=	@PTDummy,
			@MaxPerMatchv99		=	@PTDummy,
			@MinBetv1mp			=	@PTDummy,
			@MaxBetv1mp			=	@PTDummy,
			@MaxPerMatchv1mp	=	@PTDummy,
			@MinBetv99mp		=	@PTDummy,
			@MaxBetv99mp		=	@PTDummy,
			@MaxPerMatchv99mp	=	@PTDummy,
			@MinBetv161			=	@PTDummy,
			@MaxBetv161			=	@PTDummy,
			@MaxPerMatchv161	=	@PTDummy,
			@MaxPerBallv161		=	@PTDummy,
			
			@v1apositiontaking_1	=	@PTDummy,
			@v1apositiontaking_2	=	@PTDummy,
			@v1apositiontaking_3	=	@PTDummy,
			@v1apositiontaking_4	=	@PTDummy,
			@v1apositiontaking_5	=	@PTDummy,
			@v1apositiontaking_6	=	@PTDummy,
			@v1apositiontaking_7	=	@PTDummy,
			@v1apositiontaking_8	=	@PTDummy,
			@v1apositiontaking_9	=	@PTDummy,
			@v1apositiontaking_10	=	@PTDummy,
			
			@v1alivepositiontaking_1	=	@PTDummy,
			@v1alivepositiontaking_3	=	@PTDummy,
			@v1alivepositiontaking_7	=	@PTDummy,
			@v1alivepositiontaking_8	=	@PTDummy,
			
			@v2apositiontaking_1	=	@PTDummy,
			@v2apositiontaking_2	=	@PTDummy,
			@v2apositiontaking_3	=	@PTDummy,
			@v2apositiontaking_7	=	@PTDummy,
			@v2apositiontaking_8	=	@PTDummy,
			@v2apositiontaking_20	=	@PTDummy,
			@v3apositiontaking_1	=	@PTDummy,
			@v3apositiontaking_2	=	@PTDummy,
			@v3apositiontaking_3	=	@PTDummy,
			@v3apositiontaking_20	=	@PTDummy,
			@v5apositiontaking_1	=	@PTDummy,
			@v5apositiontaking_2	=	@PTDummy,
			@v5apositiontaking_3	=	@PTDummy,
			@v5apositiontaking_20	=	@PTDummy,
			@v8apositiontaking_1	=	@PTDummy,
			@v8apositiontaking_3	=	@PTDummy,
			@v8apositiontaking_20	=	@PTDummy,
			@v10apositiontaking_1	=	@PTDummy,
			@v10apositiontaking_2	=	@PTDummy,
			@v10apositiontaking_3	=	@PTDummy,
			@v10apositiontaking_20	=	@PTDummy,
			@v11apositiontaking_1	=	@PTDummy,
			@v11apositiontaking_20	=	@PTDummy,
			@v99apositiontaking_1	=	@PTDummy,
			@v99apositiontaking_2	=	@PTDummy,
			@v99apositiontaking_3	=	@PTDummy,
			@v99apositiontaking_20	=	@PTDummy,
			@v99apositiontaking_9	=	@PTDummy,
			
			@v161apositiontaking_81		=	@PTDummy,
			@v161apositiontaking_83		=	@PTDummy,
			@v161apositiontaking_86		=	@PTDummy,
			@v161apositiontaking_88		=	@PTDummy,
			@v161alivepositiontaking_85		=	@PTDummy,
			@v161alivepositiontaking_86		=	@PTDummy,
			@v161alivepositiontaking_87		=	@PTDummy,
			@v161alivepositiontaking_89		=	@PTDummy,
			@v161alivepositiontaking_90		=	@PTDummy,
			
			@KenoList		=	'<products><product Bettype="1501" MaxBet="0" MinBet="0" MaxPerMatch="0" IsDisable="1" sPositionTaking="0" mPositionTaking="0" aPositionTaking="0"></product></products>'  ,
			@DisableKeno	=	0,
			@IP				=	@IP,
			@Language		=	@Language,
			@SubAccID		=	@SubAccID,
			@ErrCode		=	@ErrCode output,
			@ErrMsg			=	@ErrMsg output
		
		END
		  
	END 
	
	
	set @endRun = getdate()
	set @duration  = datediff (millisecond,@startRun,@endRun)

	--write log keno
	DECLARE @str_bet varchar(1000)='',
			@str_spt varchar(1000)='',
			@str_mpt varchar(1000)='',
			@str_apt varchar(1000)='',
			@i INT=1501
	WHILE (@i<=(select max(bettype) from #data))
	BEGIN
		select @str_bet=@str_bet+ 'MinBv202_' +CAST(Bettype AS VARCHAR(50))+'="'+CAST(MinBet AS VARCHAR(50))+'" '
								+ 'MaxBv202_' +CAST(Bettype AS VARCHAR(50))+'="'+CAST(MaxBet AS VARCHAR(50))+'" '
								+ 'MPMv202_' +CAST(Bettype AS VARCHAR(50))+'="'+CAST(MaxPerMatch AS VARCHAR(50))+'" ',
			   @str_spt=@str_spt + 'v202spt_' +CAST(Bettype AS VARCHAR(50))+'="'+CAST(sPositionTaking AS VARCHAR(50))+'" ',
			   @str_mpt=@str_mpt + 'v202mpt_' +CAST(Bettype AS VARCHAR(50))+'="'+CAST(mPositionTaking AS VARCHAR(50))+'" ',
			   @str_apt=@str_apt + 'v202apt_' +CAST(Bettype AS VARCHAR(50))+'="'+CAST(aPositionTaking AS VARCHAR(50))+'" '
		from #data where Bettype=@i
		set @i=@i+1
	END

	Declare @LogSPData varchar(MAX)
	--Log customer info
	Select @LogSPData = '<Acc_Dep_CustomerInsMember_MAg custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +
	'creator="'+ coalesce(cast(@creator as varchar(50)),space(1)) + '" ' +
	'username="'+ coalesce(cast(@username as varchar(30)),space(1)) + '" ' +
	'mrecommend="'+ coalesce(cast(@mrecommend as varchar(50)),space(1)) + '" ' +
	'sitename="'+ coalesce(cast(@sitename as varchar(20)),space(1)) + '" ' +
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

	--log bet Setting
	Select @LogSPData = '<Acc_Dep_CustomerInsMember_MAg custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +
	'MinBv1="'+ coalesce(cast(@MinBetv1 as varchar(50)),space(1)) + '" ' +
	'MaxBv1="'+ coalesce(cast(@MaxBetv1 as varchar(50)),space(1)) + '" ' +
	'MPMv1="'+ coalesce(cast(@MaxPerMatchv1 as varchar(50)),space(1)) + '" ' +
	'MinBv2="'+ coalesce(cast(@MinBetv2 as varchar(50)),space(1)) + '" ' +
	'MaxBv2="'+ coalesce(cast(@MaxBetv2 as varchar(50)),space(1)) + '" ' +
	'MPMv2="'+ coalesce(cast(@MaxPerMatchv2 as varchar(50)),space(1)) + '" ' +
	'MinBv3="'+ coalesce(cast(@MinBetv3 as varchar(50)),space(1)) + '" ' +
	'MaxBv3="'+ coalesce(cast(@MaxBetv3 as varchar(50)),space(1)) + '" ' +
	'MPMv3="'+ coalesce(cast(@MaxPerMatchv3 as varchar(50)),space(1)) + '" ' +
	'MinBv5="'+ coalesce(cast(@MinBetv5 as varchar(50)),space(1)) + '" ' +
	'MaxBv5="'+ coalesce(cast(@MaxBetv5 as varchar(50)),space(1)) + '" ' +
	'MPMv5="'+ coalesce(cast(@MaxPerMatchv5 as varchar(50)),space(1)) + '" ' +
	'MinBv8="'+ coalesce(cast(@MinBetv8 as varchar(50)),space(1)) + '" ' +
	'MaxBv8="'+ coalesce(cast(@MaxBetv8 as varchar(50)),space(1)) + '" ' +
	'MPMv8="'+ coalesce(cast(@MaxPerMatchv8 as varchar(50)),space(1)) + '" ' +
	'MinBv10="'+ coalesce(cast(@MinBetv10 as varchar(50)),space(1)) + '" ' +
	'MaxBv10="'+ coalesce(cast(@MaxBetv10 as varchar(50)),space(1)) + '" ' +
	'MPMv10="'+ coalesce(cast(@MaxPerMatchv10 as varchar(50)),space(1)) + '" ' +
	'MinBv11="'+ coalesce(cast(@MinBetv11 as varchar(50)),space(1)) + '" ' +
	'MaxBv11="'+ coalesce(cast(@MaxBetv11 as varchar(50)),space(1)) + '" ' +
	'MPMv11="'+ coalesce(cast(@MaxPerMatchv11 as varchar(50)),space(1)) + '" ' +

	--

	'MinBv99="'+ coalesce(cast(@MinBetv99 as varchar(50)),space(1)) + '" ' +
	'MaxBv99="'+ coalesce(cast(@MaxBetv99 as varchar(50)),space(1)) + '" ' +
	'MPMv99="'+ coalesce(cast(@MaxPerMatchv99 as varchar(50)),space(1)) + '" ' +

	'MinBv1mp="'+ coalesce(cast(@MinBetv1mp as varchar(50)),space(1)) + '" ' +
	'MaxBv1mp="'+ coalesce(cast(@MaxBetv1mp as varchar(50)),space(1)) + '" ' +
	'MPMv1mp="'+ coalesce(cast(@MaxPerMatchv1mp as varchar(50)),space(1)) + '" ' +
	
	'MinBv99mp="'+ coalesce(cast(@MinBetv99mp as varchar(50)),space(1)) + '" ' +
	'MaxBv99mp="'+ coalesce(cast(@MaxBetv99mp as varchar(50)),space(1)) + '" ' +
	'MPMv99mp="'+ coalesce(cast(@MaxPerMatchv99mp as varchar(50)),space(1)) + '" ' +
	'MinBv161="'+ coalesce(cast(@MinBetv161 as varchar(50)),space(1)) + '" ' +
	'MaxBv161="'+ coalesce(cast(@MaxBetv161 as varchar(50)),space(1)) + '" ' +
	'MPMv161="'+ coalesce(cast(@MaxPerMatchv161 as varchar(50)),space(1)) + '" ' +
	'MPBv161="' + coalesce(cast(@MaxPerBallv161 as varchar(50)), space(1)) + '" ' +

	

	@str_bet+ ' />'

	EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP 
		@UserID = @Creator,
		@CustID = @CustID,
		@ActionID = 2011,
		@TrackingValue = @LogSPData,
		@duration = @duration
	 
	--Log Status
	Select @LogSPData = '<Acc_Dep_CustomerInsMember_MAg custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +
	'closed="'+ coalesce(cast(@UplineClosed as varchar(1)),space(1)) + '" ' +	
	'DisableOutright="'+ coalesce(cast(@DisableOutright as varchar(1)),space(1)) + '" ' +
	'DisableNumber="' + coalesce(cast(@DisableNumber as varchar(1)),space(1)) + '" />'

	EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP 
		@UserID = @Creator,
		@CustID = @CustID,
		@ActionID = 2204,
		@TrackingValue = @LogSPData,
		@duration = @duration
		

	Select @LogSPData = '<Acc_Dep_CustomerInsMember_MAg><ag apt_1="'+ coalesce(dbo.f_FomatNumericToChar(@v1apositiontaking_1),space(1)) + '" ' +
	'apt_2="'+ coalesce(dbo.f_FomatNumericToChar(@v1apositiontaking_2),space(1)) + '" ' +
	'apt_3="'+ coalesce(dbo.f_FomatNumericToChar(@v1apositiontaking_3),space(1)) + '" ' +
	'apt_4="'+ coalesce(dbo.f_FomatNumericToChar(@v1apositiontaking_4),space(1)) + '" ' +
	'apt_5="'+ coalesce(dbo.f_FomatNumericToChar(@v1apositiontaking_5),space(1)) + '" ' +
	'apt_6="'+ coalesce(dbo.f_FomatNumericToChar(@v1apositiontaking_6),space(1)) + '" ' +
	'apt_7="'+ coalesce(dbo.f_FomatNumericToChar(@v1apositiontaking_7),space(1)) + '" ' +
	'apt_8="'+ coalesce(dbo.f_FomatNumericToChar(@v1apositiontaking_8),space(1)) + '" ' +
	'apt_9="'+ coalesce(dbo.f_FomatNumericToChar(@v1apositiontaking_9),space(1)) + '" ' +
	'apt_10="'+ coalesce(dbo.f_FomatNumericToChar(@v1apositiontaking_10),space(1)) + '" ' +
	'alivept_1="'+ coalesce(dbo.f_FomatNumericToChar(@v1alivepositiontaking_1),space(1)) + '" ' +
	'alivept_3="'+ coalesce(dbo.f_FomatNumericToChar(@v1alivepositiontaking_3),space(1)) + '" ' +
	'alivept_7="'+ coalesce(dbo.f_FomatNumericToChar(@v1alivepositiontaking_7),space(1)) + '" ' +
	'alivept_8="'+ coalesce(dbo.f_FomatNumericToChar(@v1alivepositiontaking_8),space(1)) + '" ' +

	'v2apt_1="'+ coalesce(dbo.f_FomatNumericToChar(@v2apositiontaking_1),space(1)) + '" ' +
	'v2apt_2="'+ coalesce(dbo.f_FomatNumericToChar(@v2apositiontaking_2),space(1)) + '" ' +
	'v2apt_3="'+ coalesce(dbo.f_FomatNumericToChar(@v2apositiontaking_3),space(1)) + '" ' +
	'v2apt_7="'+ coalesce(dbo.f_FomatNumericToChar(@v2apositiontaking_7),space(1)) + '" ' +
	'v2apt_8="'+ coalesce(dbo.f_FomatNumericToChar(@v2apositiontaking_8),space(1)) + '" ' +
	'v2apt_20="'+ coalesce(dbo.f_FomatNumericToChar(@v2apositiontaking_20),space(1)) + '" ' +

	'v3apt_1="'+ coalesce(dbo.f_FomatNumericToChar(@v3apositiontaking_1),space(1)) + '" ' +
	'v3apt_2="'+ coalesce(dbo.f_FomatNumericToChar(@v3apositiontaking_2),space(1)) + '" ' +
	'v3apt_3="'+ coalesce(dbo.f_FomatNumericToChar(@v3apositiontaking_3),space(1)) + '" ' +
	'v3apt_20="'+ coalesce(dbo.f_FomatNumericToChar(@v3apositiontaking_20),space(1)) + '" ' +

	'v5apt_1="'+ coalesce(dbo.f_FomatNumericToChar(@v5apositiontaking_1),space(1)) + '" ' +
	'v5apt_2="'+ coalesce(dbo.f_FomatNumericToChar(@v5apositiontaking_2),space(1)) + '" ' +
	'v5apt_3="'+ coalesce(dbo.f_FomatNumericToChar(@v5apositiontaking_3),space(1)) + '" ' +
	'v5apt_20="'+ coalesce(dbo.f_FomatNumericToChar(@v5apositiontaking_20),space(1)) + '" ' +

	'v8apt_1="'+ coalesce(dbo.f_FomatNumericToChar(@v8apositiontaking_1),space(1)) + '" ' +
	'v8apt_3="'+ coalesce(dbo.f_FomatNumericToChar(@v8apositiontaking_3),space(1)) + '" ' +
	'v8apt_20="'+ coalesce(dbo.f_FomatNumericToChar(@v8apositiontaking_20),space(1)) + '" ' +

	'v10apt_1="'+ coalesce(dbo.f_FomatNumericToChar(@v10apositiontaking_1),space(1)) + '" ' +
	'v10apt_2="'+ coalesce(dbo.f_FomatNumericToChar(@v10apositiontaking_2),space(1)) + '" ' +
	'v10apt_3="'+ coalesce(dbo.f_FomatNumericToChar(@v10apositiontaking_3),space(1)) + '" ' +
	'v10apt_20="'+ coalesce(dbo.f_FomatNumericToChar(@v10apositiontaking_20),space(1)) + '" ' +

	'v11apt_1="'+ coalesce(dbo.f_FomatNumericToChar(@v11apositiontaking_1),space(1)) + '" ' +
	'v11apt_20="'+ coalesce(dbo.f_FomatNumericToChar(@v11apositiontaking_20),space(1)) + '" ' +

	'v99apt_1="'+ coalesce(dbo.f_FomatNumericToChar(@v99apositiontaking_1),space(1)) + '" ' +
	'v99apt_2="'+ coalesce(dbo.f_FomatNumericToChar(@v99apositiontaking_2),space(1)) + '" ' +
	'v99apt_3="'+ coalesce(dbo.f_FomatNumericToChar(@v99apositiontaking_3),space(1)) + '" ' +
	'v99apt_20="'+ coalesce(dbo.f_FomatNumericToChar(@v99apositiontaking_20),space(1)) + '" ' +
	'v99apt_9="'+ coalesce(dbo.f_FomatNumericToChar(@v99apositiontaking_9),space(1)) + '" ' +

	'v161apt_81="'+ coalesce(dbo.f_FomatNumericToChar(@v161apositiontaking_81),space(1)) + '" ' +
	'v161apt_83="'+ coalesce(dbo.f_FomatNumericToChar(@v161apositiontaking_83),space(1)) + '" ' +
	'v161apt_86="'+ coalesce(dbo.f_FomatNumericToChar(@v161apositiontaking_86),space(1)) + '" ' +
	'v161apt_88="'+ coalesce(dbo.f_FomatNumericToChar(@v161apositiontaking_88),space(1)) + '" ' +
	'v161alivept_85="'+ coalesce(dbo.f_FomatNumericToChar(@v161alivepositiontaking_85),space(1)) + '" ' +
	'v161alivept_86="'+ coalesce(dbo.f_FomatNumericToChar(@v161alivepositiontaking_86),space(1)) + '" ' +
	'v161alivept_87="'+ coalesce(dbo.f_FomatNumericToChar(@v161alivepositiontaking_87),space(1)) + '" ' +
	'v161alivept_89="'+ coalesce(dbo.f_FomatNumericToChar(@v161alivepositiontaking_89),space(1)) + '" ' +
	'v161alivept_90="'+ coalesce(dbo.f_FomatNumericToChar(@v161alivepositiontaking_90),space(1)) + '" ' +

	

	@str_apt+
	'/>'  + 
	'<m mpt_1="'+ coalesce(dbo.f_FomatNumericToChar(@v1mpositiontaking_1),space(1)) + '" ' +
	'mpt_2="'+ coalesce(dbo.f_FomatNumericToChar(@v1mpositiontaking_2),space(1)) + '" ' +
	'mpt_3="'+ coalesce(dbo.f_FomatNumericToChar(@v1mpositiontaking_3),space(1)) + '" ' +
	'mpt_4="'+ coalesce(dbo.f_FomatNumericToChar(@v1mpositiontaking_4),space(1)) + '" ' +
	'mpt_5="'+ coalesce(dbo.f_FomatNumericToChar(@v1mpositiontaking_5),space(1)) + '" ' +
	'mpt_6="'+ coalesce(dbo.f_FomatNumericToChar(@v1mpositiontaking_6),space(1)) + '" ' +
	'mpt_7="'+ coalesce(dbo.f_FomatNumericToChar(@v1mpositiontaking_7),space(1)) + '" ' +
	'mpt_8="'+ coalesce(dbo.f_FomatNumericToChar(@v1mpositiontaking_8),space(1)) + '" ' +
	'mpt_9="'+ coalesce(dbo.f_FomatNumericToChar(@v1mpositiontaking_9),space(1)) + '" ' +
	'mpt_10="'+ coalesce(dbo.f_FomatNumericToChar(@v1mpositiontaking_10),space(1)) + '" ' +
	'mlivept_1="'+ coalesce(dbo.f_FomatNumericToChar(@v1mlivepositiontaking_1),space(1)) + '" ' +
	'mlivept_3="'+ coalesce(dbo.f_FomatNumericToChar(@v1mlivepositiontaking_3),space(1)) + '" ' +
	'mlivept_7="'+ coalesce(dbo.f_FomatNumericToChar(@v1mlivepositiontaking_7),space(1)) + '" ' +
	'mlivept_8="'+ coalesce(dbo.f_FomatNumericToChar(@v1mlivepositiontaking_8),space(1)) + '" ' +

	'v2mpt_1="'+ coalesce(dbo.f_FomatNumericToChar(@v2mpositiontaking_1),space(1)) + '" ' +
	'v2mpt_2="'+ coalesce(dbo.f_FomatNumericToChar(@v2mpositiontaking_2),space(1)) + '" ' +
	'v2mpt_3="'+ coalesce(dbo.f_FomatNumericToChar(@v2mpositiontaking_3),space(1)) + '" ' +
	'v2mpt_7="'+ coalesce(dbo.f_FomatNumericToChar(@v2mpositiontaking_7),space(1)) + '" ' +
	'v2mpt_8="'+ coalesce(dbo.f_FomatNumericToChar(@v2mpositiontaking_8),space(1)) + '" ' +
	'v2mpt_20="'+ coalesce(dbo.f_FomatNumericToChar(@v2mpositiontaking_20),space(1)) + '" ' +

	'v3mpt_1="'+ coalesce(dbo.f_FomatNumericToChar(@v3mpositiontaking_1),space(1)) + '" ' +
	'v3mpt_2="'+ coalesce(dbo.f_FomatNumericToChar(@v3mpositiontaking_2),space(1)) + '" ' +
	'v3mpt_3="'+ coalesce(dbo.f_FomatNumericToChar(@v3mpositiontaking_3),space(1)) + '" ' +
	'v3mpt_20="'+ coalesce(dbo.f_FomatNumericToChar(@v3mpositiontaking_20),space(1)) + '" ' +

	'v5mpt_1="'+ coalesce(dbo.f_FomatNumericToChar(@v5mpositiontaking_1),space(1)) + '" ' +
	'v5mpt_2="'+ coalesce(dbo.f_FomatNumericToChar(@v5mpositiontaking_2),space(1)) + '" ' +
	'v5mpt_3="'+ coalesce(dbo.f_FomatNumericToChar(@v5mpositiontaking_3),space(1)) + '" ' +
	'v5mpt_20="'+ coalesce(dbo.f_FomatNumericToChar(@v5mpositiontaking_20),space(1)) + '" ' +

	'v8mpt_1="'+ coalesce(dbo.f_FomatNumericToChar(@v8mpositiontaking_1),space(1)) + '" ' +
	'v8mpt_3="'+ coalesce(dbo.f_FomatNumericToChar(@v8mpositiontaking_3),space(1)) + '" ' +
	'v8mpt_20="'+ coalesce(dbo.f_FomatNumericToChar(@v8mpositiontaking_20),space(1)) + '" ' +

	'v10mpt_1="'+ coalesce(dbo.f_FomatNumericToChar(@v10mpositiontaking_1),space(1)) + '" ' +
	'v10mpt_2="'+ coalesce(dbo.f_FomatNumericToChar(@v10mpositiontaking_2),space(1)) + '" ' +
	'v10mpt_3="'+ coalesce(dbo.f_FomatNumericToChar(@v10mpositiontaking_3),space(1)) + '" ' +
	'v10mpt_20="'+ coalesce(dbo.f_FomatNumericToChar(@v10mpositiontaking_20),space(1)) + '" ' +

	'v11mpt_1="'+ coalesce(dbo.f_FomatNumericToChar(@v11mpositiontaking_1),space(1)) + '" ' +
	'v11mpt_20="'+ coalesce(dbo.f_FomatNumericToChar(@v11mpositiontaking_20),space(1)) + '" ' +

	'v99mpt_1="'+ coalesce(dbo.f_FomatNumericToChar(@v99mpositiontaking_1),space(1)) + '" ' +
	'v99mpt_2="'+ coalesce(dbo.f_FomatNumericToChar(@v99mpositiontaking_2),space(1)) + '" ' +
	'v99mpt_3="'+ coalesce(dbo.f_FomatNumericToChar(@v99mpositiontaking_3),space(1)) + '" ' +
	'v99mpt_20="'+ coalesce(dbo.f_FomatNumericToChar(@v99mpositiontaking_20),space(1)) + '" ' +

	'v99mpt_9="'+ coalesce(dbo.f_FomatNumericToChar(@v99mpositiontaking_9),space(1)) + '" ' +

	@str_mpt+

	'v161mpt_81="'+ coalesce(dbo.f_FomatNumericToChar(@v161mpositiontaking_81),space(1)) + '" ' +
	'v161mpt_83="'+ coalesce(dbo.f_FomatNumericToChar(@v161mpositiontaking_83),space(1)) + '" ' +
	'v161mpt_86="'+ coalesce(dbo.f_FomatNumericToChar(@v161mpositiontaking_86),space(1)) + '" ' +
	'v161mpt_88="'+ coalesce(dbo.f_FomatNumericToChar(@v161mpositiontaking_88),space(1)) + '" ' +
	'v161mlivept_85="'+ coalesce(dbo.f_FomatNumericToChar(@v161mlivepositiontaking_85),space(1)) + '" ' +
	'v161mlivept_86="'+ coalesce(dbo.f_FomatNumericToChar(@v161mlivepositiontaking_86),space(1)) + '" ' +
	'v161mlivept_87="'+ coalesce(dbo.f_FomatNumericToChar(@v161mlivepositiontaking_87),space(1)) + '" ' +
	'v161mlivept_89="'+ coalesce(dbo.f_FomatNumericToChar(@v161mlivepositiontaking_89),space(1)) + '" ' +
	'v161mlivept_90="'+ coalesce(dbo.f_FomatNumericToChar(@v161mlivepositiontaking_90),space(1)) + '" />' +'</Acc_Dep_CustomerInsMember_MAg>' 

	--Log positiontaking
	EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP 
		@UserID = @Creator,
		@CustID = @CustID,
		@ActionID = 2703,
		@TrackingValue = @LogSPData,
		@duration = @duration

	DROP TABLE #data
	DROP TABLE #MinMaxUpline

END
GO
