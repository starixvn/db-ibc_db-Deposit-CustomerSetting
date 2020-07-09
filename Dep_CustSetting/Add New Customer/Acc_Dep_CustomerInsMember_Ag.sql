/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet,Dot_member" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_CustomerInsMember_Ag]
(
	@custid		int OUTPUT,
	@creator	int,
	@username	varchar(30),
	@userpwd	varchar(40) = '123qwe',
	@recommend	int, -- Agent ID
	
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
	
	
	
	@v1alivepositiontaking_1 smallmoney,
	@v1alivepositiontaking_3 smallmoney,
	@v1alivepositiontaking_7 smallmoney,
	@v1alivepositiontaking_8 smallmoney,
	
	
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

	--Keno
	@KenoList VARCHAR(4000)='',
	@DisableKeno BIT = 0,
	--------------------------------
	

	@IP										varchar(15)='',
	@Language								varchar(2)= 'E',
	@SubAccID								int = 0, --Sub-AccountID
	@ErrCode								int = 0 OUTPUT,
	@ErrMsg									nvarchar(4000) = '' OUTPUT
)	
AS

--@Source Control
/*
Created: 20120322@Dom
Task : Agent create dummy account
DB: DBTRANS.bodb02
Original:

Revisions:
    - 20121128@Elodie: Get an error message from f_Get_MsgNameByMsgID function by language
    - 20130604@Daniel: Change default P2P param value to "Disable P2P"
    - 20130607@Daniel: Exclude created member from Balance checking
    - 20130731@Elodie: Apply progressive bonus
	- 20130919@Don: Supporting save log of Number Game PT with format such as "0.995", "0.925", ...
	- 20131014@Francis: Support adding new virtual sports with settings via XML param
	- 20131108@Elodie: Splitting bodb02 into CustDB (Insert Task_Cust_CheckBalance_Exception by link database)	
	- 20140505@Florent: Add sport HR Fix Odds
	- 20140512@Florent: Add new sport: 202 Keno
    - 20150309@Johnson: Disable virtual rate as default [RedmineID: #31927]
    - 20150610@Kathy: Migrate custDB to new server DBCust (temp GameType table, call Task_Cust_CheckBalance_Exception_Ins by linked server) [Redmine:#36216]
    - 20151028@Jim:Implement Muay's Setting for Deposit Customer [Redmine: #45491]
    - 20170302@Helen: Betradar Virtual Sports  -Integration for Cash [Redmine: 77274]
    - 20170808@Winnie: Change Data Type of Sporttype [RedmineID: #73545]	
    - 20180125@Winnie: Hide inactive products [RedmineID: #86086]
	- 20181002@Dominic: Check existing username/username2 in archived DB  [Redmine:99882]
	- 20190326@Winnie: Update PT of Sportsbook for All Licensee. [RedmineID: #110111]
	- 20190422@Elodie: Offer unique nickname for CN88 [Redmine:112287]
	- 20190429@Elodie: Insert VR setting get from Upline for new customer [RedmineID: #112657]
	- 20190726@Winnie: Remove Muay Thai. [RedmineID: #117501]
	- 20190905@Eden: 3rd party products - Remove InActive Products Phase 2 [Redmine: #118699]
	- 20200622@Johnson: add Soccer Parlay bet limit [redmine: #135261]
Param's Explanation:
• @ErrCode:
    = 0: Create member successfully.
    > 0: Specific Error.
  
• @ErrMsg: Error description.

*/
BEGIN

	SET NOCOUNT ON

	--------Parse xml string into table -- Keno
	DECLARE @xmlDoc int
	EXEC sp_xml_preparedocument @xmlDoc OUTPUT, @KenoList

	SELECT *
	INTO #data
	FROM OPENXML (@xmlDoc, '/products/product',1) WITH(Bettype int, MaxBet money, MinBet money, MaxPerMatch money, 
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


	select @v161alivepositiontaking_90 = 0

	declare @startRun datetime
	declare @endRun datetime
	declare @duration int
	set @startRun = getdate()

	--Check an account disabled or not 
	EXEC dbo.Acc_CustomerSelCheckEnable @custid = @recommend, @ErrCode=@ErrCode output,@ErrMsg=@ErrMsg output 
	if @ErrCode <>0		return 


	declare @ErrType varchar(4000)
	declare 
		@currency int, @pwdexpiry datetime,
		@srecommend int, @mrecommend int,	 
		@matchlimit smallmoney,
		@Msuspended bit,
		@UplineClosed bit,
		@DisableOutright bit,
	
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
		
		@v1mlivepositiontaking_1 smallmoney,
		@v1mlivepositiontaking_3 smallmoney,
		@v1mlivepositiontaking_7 smallmoney,
		@v1mlivepositiontaking_8 smallmoney,

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
		@v161mpositiontaking_88 smallmoney,
			
		@v161mlivepositiontaking_85 smallmoney,
		@v161mlivepositiontaking_86 smallmoney,
		@v161mlivepositiontaking_87 smallmoney,
		@v161mlivepositiontaking_89 smallmoney,
		@v161mlivepositiontaking_90 smallmoney,
		
		

		@v1spositiontaking_1 smallmoney,
		@v1spositiontaking_2 smallmoney,
		@v1spositiontaking_3 smallmoney,
		@v1spositiontaking_4 smallmoney,
		@v1spositiontaking_5 smallmoney,
		@v1spositiontaking_6 smallmoney,
		@v1spositiontaking_7 smallmoney,
		@v1spositiontaking_8 smallmoney,
		@v1spositiontaking_9 smallmoney,
		@v1spositiontaking_10 smallmoney,

		@v1slivepositiontaking_1 smallmoney,
		@v1slivepositiontaking_3 smallmoney,
		@v1slivepositiontaking_7 smallmoney,
		@v1slivepositiontaking_8 smallmoney,
		
		@v2spositiontaking_1 smallmoney,
		@v2spositiontaking_2 smallmoney,
		@v2spositiontaking_3 smallmoney,
		@v2spositiontaking_7 smallmoney,
		@v2spositiontaking_8 smallmoney,
		@v2spositiontaking_20 smallmoney,
		
		@v3spositiontaking_1 smallmoney,
		@v3spositiontaking_2 smallmoney,
		@v3spositiontaking_3 smallmoney,
		@v3spositiontaking_20 smallmoney,
		
		@v5spositiontaking_1 smallmoney,
		@v5spositiontaking_2 smallmoney,
		@v5spositiontaking_3 smallmoney,
		@v5spositiontaking_20 smallmoney,
		
		@v8spositiontaking_1 smallmoney,	
		@v8spositiontaking_3 smallmoney,
		@v8spositiontaking_20 smallmoney,
		
		@v10spositiontaking_1 smallmoney,
		@v10spositiontaking_2 smallmoney,
		@v10spositiontaking_3 smallmoney,
		@v10spositiontaking_20 smallmoney,
		
		@v11spositiontaking_1 smallmoney,	
		@v11spositiontaking_20 smallmoney,	
		
		@v99spositiontaking_1 smallmoney,
		@v99spositiontaking_2 smallmoney,
		@v99spositiontaking_3 smallmoney,	
		@v99spositiontaking_20 smallmoney,	
	
		@v99spositiontaking_9 smallmoney,

		@v161spositiontaking_81 smallmoney, 				
		@v161spositiontaking_83 smallmoney,
		@v161spositiontaking_86 smallmoney,
		@v161spositiontaking_88 smallmoney,
		
		@v161slivepositiontaking_85 smallmoney,
		@v161slivepositiontaking_86 smallmoney,
		@v161slivepositiontaking_87	smallmoney,
		@v161slivepositiontaking_89	smallmoney,
		@v161slivepositiontaking_90	smallmoney,

		@VirtualMultiplier SMALLMONEY


	select 
		@currency = currency, 
		@Msuspended = reject,
		@UplineClosed = closed,
	
		@srecommend = srecommend,
		@mrecommend = mrecommend,
		@matchlimit = matchlimit,
		@DisableOutright = DisableOutright,
		@DisableNumber = case when DisableNumber = 1 then 1 else @DisableNumber end,
		@VirtualMultiplier = ci.VirtualMultiplier
	from CustInfo as ci with (NOLOCK) 
	where CustID = @recommend

	--Get Upline PT
	SELECT @v1mpositiontaking_1 = CASE WHEN cs.sporttype = 1 AND cs.bettype = 1 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,
		@v1mpositiontaking_2 = CASE WHEN cs.sporttype = 1 AND cs.bettype = 2 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,
		@v1mpositiontaking_3 = CASE WHEN cs.sporttype = 1 AND cs.bettype = 3 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,
		@v1mpositiontaking_4 = CASE WHEN cs.sporttype = 1 AND cs.bettype = 4 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,
		@v1mpositiontaking_5 = CASE WHEN cs.sporttype = 1 AND cs.bettype = 5 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,
		@v1mpositiontaking_6 = CASE WHEN cs.sporttype = 1 AND cs.bettype = 6 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,
		@v1mpositiontaking_7 = CASE WHEN cs.sporttype = 1 AND cs.bettype = 7 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,
		@v1mpositiontaking_8 = CASE WHEN cs.sporttype = 1 AND cs.bettype = 8 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,
		@v1mpositiontaking_9 = CASE WHEN cs.sporttype = 1 AND cs.bettype = 9 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,
		@v1mpositiontaking_10  = CASE WHEN cs.sporttype = 1 AND cs.bettype = 10 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,
		
		@v2mpositiontaking_1  = CASE WHEN cs.sporttype = 2 AND cs.bettype = 1 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,
		@v2mpositiontaking_2 = CASE WHEN cs.sporttype = 2 AND cs.bettype = 2 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,
		@v2mpositiontaking_3 = CASE WHEN cs.sporttype = 2 AND cs.bettype = 3 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,
		@v2mpositiontaking_7 = CASE WHEN cs.sporttype = 2 AND cs.bettype = 7 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,
		@v2mpositiontaking_8 = CASE WHEN cs.sporttype = 2 AND cs.bettype = 8 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,
		@v2mpositiontaking_20 = CASE WHEN cs.sporttype = 2 AND cs.bettype = 20 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,

		@v3mpositiontaking_1 = CASE WHEN cs.sporttype = 3 AND cs.bettype = 1 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,
		@v3mpositiontaking_2 = CASE WHEN cs.sporttype = 3 AND cs.bettype = 2 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,
		@v3mpositiontaking_3 = CASE WHEN cs.sporttype = 3 AND cs.bettype = 3 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,
		@v3mpositiontaking_20 = CASE WHEN cs.sporttype = 3 AND cs.bettype = 20 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,

		@v5mpositiontaking_1 = CASE WHEN cs.sporttype = 5 AND cs.bettype = 1 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,
		@v5mpositiontaking_2 = CASE WHEN cs.sporttype = 5 AND cs.bettype = 2 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,
		@v5mpositiontaking_3 = CASE WHEN cs.sporttype = 5 AND cs.bettype = 3 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,
		@v5mpositiontaking_20 = CASE WHEN cs.sporttype = 5 AND cs.bettype = 20 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,

		@v8mpositiontaking_1 = CASE WHEN cs.sporttype = 8 AND cs.bettype = 1 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,
		@v8mpositiontaking_3 = CASE WHEN cs.sporttype = 8 AND cs.bettype = 3 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,
		@v8mpositiontaking_20 = CASE WHEN cs.sporttype = 8 AND cs.bettype = 20 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,

		@v10mpositiontaking_1 = CASE WHEN cs.sporttype = 10 AND cs.bettype = 1 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,
		@v10mpositiontaking_2  = CASE WHEN cs.sporttype = 10 AND cs.bettype = 2 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,
		@v10mpositiontaking_3  = CASE WHEN cs.sporttype = 10 AND cs.bettype = 3 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,
		@v10mpositiontaking_20 = CASE WHEN cs.sporttype = 10 AND cs.bettype = 20 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,

		@v11mpositiontaking_1 = CASE WHEN cs.sporttype = 11 AND cs.bettype = 1 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,
		@v11mpositiontaking_20  = CASE WHEN cs.sporttype = 11 AND cs.bettype = 20 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,
	
		@v99mpositiontaking_1  = CASE WHEN cs.sporttype = 99 AND cs.bettype = 1 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,
		@v99mpositiontaking_2 = CASE WHEN cs.sporttype = 99 AND cs.bettype = 2 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,
		@v99mpositiontaking_3 = CASE WHEN cs.sporttype = 99 AND cs.bettype = 3 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,
		@v99mpositiontaking_20 = CASE WHEN cs.sporttype = 99 AND cs.bettype = 20 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,
		


		@v99mpositiontaking_9 = CASE WHEN cs.sporttype = 99 AND cs.bettype = 9 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,

		-- mix parlay of mixed sports
		
		
		-- number game
		@v161mpositiontaking_81  = CASE WHEN cs3.sporttype = 161 AND cs3.bettype = 81 AND cs3.islive = 0 THEN cs3.mpositiontaking ELSE 0 END,
		@v161mpositiontaking_83  = CASE WHEN cs3.sporttype = 161 AND cs3.bettype = 83 AND cs3.islive = 0 THEN cs3.mpositiontaking ELSE 0 END,
		@v161mpositiontaking_86  = CASE WHEN cs3.sporttype = 161 AND cs3.bettype = 86 AND cs3.islive = 0 THEN cs3.mpositiontaking ELSE 0 END,
		@v161mpositiontaking_88  = CASE WHEN cs3.sporttype = 161 AND cs3.bettype = 88 AND cs3.islive = 0 THEN cs3.mpositiontaking ELSE 0 END,
			
		@v161mlivepositiontaking_85 = CASE WHEN cs3.sporttype = 161 AND cs3.bettype = 85 AND cs3.islive = 1 THEN cs3.mpositiontaking ELSE 0 END,
		@v161mlivepositiontaking_86  = CASE WHEN cs3.sporttype = 161 AND cs3.bettype = 86 AND cs3.islive = 1 THEN cs3.mpositiontaking ELSE 0 END,
		@v161mlivepositiontaking_87  = CASE WHEN cs3.sporttype = 161 AND cs3.bettype = 87 AND cs3.islive = 1 THEN cs3.mpositiontaking ELSE 0 END,
		@v161mlivepositiontaking_89  = CASE WHEN cs3.sporttype = 161 AND cs3.bettype = 89 AND cs3.islive = 1 THEN cs3.mpositiontaking ELSE 0 END,
		@v161mlivepositiontaking_90  = CASE WHEN cs3.sporttype = 161 AND cs3.bettype = 90 AND cs3.islive = 1 THEN cs3.mpositiontaking ELSE 0 END,
		
		@v1mlivepositiontaking_1 = CASE WHEN cs.sporttype = 1 AND cs.bettype = 1 AND cs.islive = 1 THEN cs.mpositiontaking ELSE 0 END,
		@v1mlivepositiontaking_3  = CASE WHEN cs.sporttype = 1 AND cs.bettype = 3 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,
		@v1mlivepositiontaking_7  = CASE WHEN cs.sporttype = 1 AND cs.bettype = 7 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,
		@v1mlivepositiontaking_8  = CASE WHEN cs.sporttype = 1 AND cs.bettype = 8 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END

	FROM Dep_CustSetting  AS cs WITH (NOLOCK)
		INNER JOIN Dep_CustSetting3rd AS cs3 WITH (NOLOCK) ON cs3.custid = cs.custid
	WHERE cs.custid = @recommend

	--Get Upline PT
	SELECT @v1spositiontaking_1 = CASE WHEN cs.sporttype = 1 AND cs.bettype = 1 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,
		@v1spositiontaking_2 = CASE WHEN cs.sporttype = 1 AND cs.bettype = 2 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,
		@v1spositiontaking_3 = CASE WHEN cs.sporttype = 1 AND cs.bettype = 3 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,
		@v1spositiontaking_4 = CASE WHEN cs.sporttype = 1 AND cs.bettype = 4 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,
		@v1spositiontaking_5 = CASE WHEN cs.sporttype = 1 AND cs.bettype = 5 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,
		@v1spositiontaking_6 = CASE WHEN cs.sporttype = 1 AND cs.bettype = 6 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,
		@v1spositiontaking_7 = CASE WHEN cs.sporttype = 1 AND cs.bettype = 7 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,
		@v1spositiontaking_8 = CASE WHEN cs.sporttype = 1 AND cs.bettype = 8 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,
		@v1spositiontaking_9 = CASE WHEN cs.sporttype = 1 AND cs.bettype = 9 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,
		@v1spositiontaking_10  = CASE WHEN cs.sporttype = 1 AND cs.bettype = 10 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,
		
		@v2spositiontaking_1  = CASE WHEN cs.sporttype = 2 AND cs.bettype = 1 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,
		@v2spositiontaking_2 = CASE WHEN cs.sporttype = 2 AND cs.bettype = 2 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,
		@v2spositiontaking_3 = CASE WHEN cs.sporttype = 2 AND cs.bettype = 3 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,
		@v2spositiontaking_7 = CASE WHEN cs.sporttype = 2 AND cs.bettype = 7 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,
		@v2spositiontaking_8 = CASE WHEN cs.sporttype = 2 AND cs.bettype = 8 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,
		@v2spositiontaking_20 = CASE WHEN cs.sporttype = 2 AND cs.bettype = 20 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,

		@v3spositiontaking_1 = CASE WHEN cs.sporttype = 3 AND cs.bettype = 1 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,
		@v3spositiontaking_2 = CASE WHEN cs.sporttype = 3 AND cs.bettype = 2 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,
		@v3spositiontaking_3 = CASE WHEN cs.sporttype = 3 AND cs.bettype = 3 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,
		@v3spositiontaking_20 = CASE WHEN cs.sporttype = 3 AND cs.bettype = 20 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,

		@v5spositiontaking_1 = CASE WHEN cs.sporttype = 5 AND cs.bettype = 1 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,
		@v5spositiontaking_2 = CASE WHEN cs.sporttype = 5 AND cs.bettype = 2 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,
		@v5spositiontaking_3 = CASE WHEN cs.sporttype = 5 AND cs.bettype = 3 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,
		@v5spositiontaking_20 = CASE WHEN cs.sporttype = 5 AND cs.bettype = 20 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,

		@v8spositiontaking_1 = CASE WHEN cs.sporttype = 8 AND cs.bettype = 1 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,
		@v8spositiontaking_3 = CASE WHEN cs.sporttype = 8 AND cs.bettype = 3 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,
		@v8spositiontaking_20 = CASE WHEN cs.sporttype = 8 AND cs.bettype = 20 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,

		@v10spositiontaking_1 = CASE WHEN cs.sporttype = 10 AND cs.bettype = 1 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,
		@v10spositiontaking_2  = CASE WHEN cs.sporttype = 10 AND cs.bettype = 2 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,
		@v10spositiontaking_3  = CASE WHEN cs.sporttype = 10 AND cs.bettype = 3 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,
		@v10spositiontaking_20 = CASE WHEN cs.sporttype = 10 AND cs.bettype = 20 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,

		@v11spositiontaking_1 = CASE WHEN cs.sporttype = 11 AND cs.bettype = 1 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,
		@v11spositiontaking_20  = CASE WHEN cs.sporttype = 11 AND cs.bettype = 20 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,	
		
		@v99spositiontaking_1  = CASE WHEN cs.sporttype = 99 AND cs.bettype = 1 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,
		@v99spositiontaking_2 = CASE WHEN cs.sporttype = 99 AND cs.bettype = 2 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,
		@v99spositiontaking_3 = CASE WHEN cs.sporttype = 99 AND cs.bettype = 3 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,
		@v99spositiontaking_20 = CASE WHEN cs.sporttype = 99 AND cs.bettype = 20 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,

	

		@v99spositiontaking_9 = CASE WHEN cs.sporttype = 99 AND cs.bettype = 9 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,
		

		-- mix parlay of mixed sports
		
		
		-- number game
		@v161spositiontaking_81  = CASE WHEN cs3.sporttype = 161 AND cs3.bettype = 81 AND cs3.islive = 0 THEN cs3.spositiontaking ELSE 0 END,
		@v161spositiontaking_83  = CASE WHEN cs3.sporttype = 161 AND cs3.bettype = 83 AND cs3.islive = 0 THEN cs3.spositiontaking ELSE 0 END,
		@v161spositiontaking_86  = CASE WHEN cs3.sporttype = 161 AND cs3.bettype = 86 AND cs3.islive = 0 THEN cs3.spositiontaking ELSE 0 END,
		@v161spositiontaking_88  = CASE WHEN cs3.sporttype = 161 AND cs3.bettype = 88 AND cs3.islive = 0 THEN cs3.spositiontaking ELSE 0 END,
			
		@v161slivepositiontaking_85 = CASE WHEN cs3.sporttype = 161 AND cs3.bettype = 85 AND cs3.islive = 1 THEN cs3.spositiontaking ELSE 0 END,
		@v161slivepositiontaking_86  = CASE WHEN cs3.sporttype = 161 AND cs3.bettype = 86 AND cs3.islive = 1 THEN cs3.spositiontaking ELSE 0 END,
		@v161slivepositiontaking_87  = CASE WHEN cs3.sporttype = 161 AND cs3.bettype = 87 AND cs3.islive = 1 THEN cs3.spositiontaking ELSE 0 END,
		@v161slivepositiontaking_89  = CASE WHEN cs3.sporttype = 161 AND cs3.bettype = 89 AND cs3.islive = 1 THEN cs3.spositiontaking ELSE 0 END,
		@v161slivepositiontaking_90  = CASE WHEN cs3.sporttype = 161 AND cs3.bettype = 90 AND cs3.islive = 1 THEN cs3.spositiontaking ELSE 0 END,
		
		@v1slivepositiontaking_1 = CASE WHEN cs.sporttype = 1 AND cs.bettype = 1 AND cs.islive = 1 THEN cs.spositiontaking ELSE 0 END,
		@v1slivepositiontaking_3  = CASE WHEN cs.sporttype = 1 AND cs.bettype = 3 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,
		@v1slivepositiontaking_7  = CASE WHEN cs.sporttype = 1 AND cs.bettype = 7 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,
		@v1slivepositiontaking_8  = CASE WHEN cs.sporttype = 1 AND cs.bettype = 8 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END

	FROM Dep_CustSetting  AS cs WITH (NOLOCK)
		INNER JOIN Dep_CustSetting3rd AS cs3 WITH (NOLOCK) ON cs3.custid = cs.custid
	WHERE cs.custid = @mrecommend



	Select @ErrCode = 0
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	declare @IsValid bit
	EXEC dbo.Acc_Dep_CustomerInsMember_Ag_CheckParam
		
		@recommend				= @recommend,
		@MinBetv1				= @MinBetv1,
		@MaxBetv1				= @MaxBetv1,
		@MaxPerMatchv1			= @MaxPerMatchv1,
		
		@MinBetv2				= @MinBetv2,
		@MaxBetv2				= @MaxBetv2,
		@MaxPerMatchv2			= @MaxPerMatchv2,
		
		@MinBetv3				= @MinBetv3,
		@MaxBetv3				= @MaxBetv3,
		@MaxPerMatchv3			= @MaxPerMatchv3,

		@MinBetv5				= @MinBetv5,
		@MaxBetv5				= @MaxBetv5,
		@MaxPerMatchv5			= @MaxPerMatchv5,

		@MinBetv8				= @MinBetv8,
		@MaxBetv8				= @MaxBetv8,
		@MaxPerMatchv8			= @MaxPerMatchv8,

		@MinBetv10				= @MinBetv10,
		@MaxBetv10				= @MaxBetv10,
		@MaxPerMatchv10			= @MaxPerMatchv10,

		@MinBetv11				= @MinBetv11,
		@MaxBetv11				= @MaxBetv11,
		@MaxPerMatchv11			= @MaxPerMatchv11,	
		
		@MinBetv99				=@MinBetv99,
		@MaxBetv99				=@MaxBetv99,
		@MaxPerMatchv99			=@MaxPerMatchv99,	
	
		--Mix Parlay mix sports
		@MinBetv1MP				= @MinBetv1MP,
		@MaxBetv1MP				= @MaxBetv1MP,
		@MaxPerMatchv1MP		= @MaxPerMatchv1MP,
		
		@MinBetv99MP			= @MinBetv99MP,
		@MaxBetv99MP			= @MaxBetv99MP,
		@MaxPerMatchv99MP		= @MaxPerMatchv99MP,
		
		--Number game
		@MinBetv161				= @MinBetv161,
		@MaxBetv161				= @MaxBetv161,
		@MaxPerBallv161			= @MaxPerBallv161,
		@MaxPerMatchv161		= @MaxPerMatchv161,

		@v1apositiontaking_1		= @v1apositiontaking_1,
		@v1apositiontaking_2		= @v1apositiontaking_2,
		@v1apositiontaking_3		= @v1apositiontaking_3,
		@v1apositiontaking_4		= @v1apositiontaking_4,
		@v1apositiontaking_5		= @v1apositiontaking_5,
		@v1apositiontaking_6		= @v1apositiontaking_6,
		@v1apositiontaking_7		= @v1apositiontaking_7,
		@v1apositiontaking_8		= @v1apositiontaking_8,
		@v1apositiontaking_9		= @v1apositiontaking_9,
		@v1apositiontaking_10		= @v1apositiontaking_10,
		@v1alivepositiontaking_1	= @v1alivepositiontaking_1,
		@v1alivepositiontaking_3	= @v1alivepositiontaking_3,
		@v1alivepositiontaking_7	= @v1alivepositiontaking_7,
		@v1alivepositiontaking_8	= @v1alivepositiontaking_8,	
									
		@v2apositiontaking_1		= @v2apositiontaking_1,
		@v2apositiontaking_2		= @v2apositiontaking_2,
		@v2apositiontaking_3		= @v2apositiontaking_3,
		@v2apositiontaking_7		= @v2apositiontaking_7,
		@v2apositiontaking_8		= @v2apositiontaking_8,
		@v2apositiontaking_20		= @v2apositiontaking_20,
									
		@v3apositiontaking_1		= @v3apositiontaking_1,
		@v3apositiontaking_2		= @v3apositiontaking_2,
		@v3apositiontaking_3		= @v3apositiontaking_3,
		@v3apositiontaking_20		= @v3apositiontaking_20,
									
		@v5apositiontaking_1		= @v5apositiontaking_1,
		@v5apositiontaking_2		= @v5apositiontaking_2,
		@v5apositiontaking_3		= @v5apositiontaking_3,
		@v5apositiontaking_20		= @v5apositiontaking_20,
									
		@v8apositiontaking_1		= @v8apositiontaking_1,
		@v8apositiontaking_3		= @v8apositiontaking_3,
		@v8apositiontaking_20		= @v8apositiontaking_20,
									
		@v10apositiontaking_1		= @v10apositiontaking_1,
		@v10apositiontaking_2		= @v10apositiontaking_2,
		@v10apositiontaking_3		= @v10apositiontaking_3,
		@v10apositiontaking_20		= @v10apositiontaking_20,
									
		@v11apositiontaking_1		= @v11apositiontaking_1,
		@v11apositiontaking_20		= @v11apositiontaking_20,
		
		@v99apositiontaking_1		= @v99apositiontaking_1,
		@v99apositiontaking_2		= @v99apositiontaking_2,
		@v99apositiontaking_3		= @v99apositiontaking_3,
		@v99apositiontaking_9		= @v99apositiontaking_9,
		@v99apositiontaking_20		= @v99apositiontaking_20,

		@v161apositiontaking_81		= @v161apositiontaking_81, 
		@v161apositiontaking_83		= @v161apositiontaking_83, 
		@v161apositiontaking_86		= @v161apositiontaking_86, 
		@v161apositiontaking_88		= @v161apositiontaking_88, 
		@v161alivepositiontaking_85 = @v161alivepositiontaking_85,
		@v161alivepositiontaking_86 = @v161alivepositiontaking_86,
		@v161alivepositiontaking_87 = @v161alivepositiontaking_87,
		@v161alivepositiontaking_89 = @v161alivepositiontaking_89,
		@v161alivepositiontaking_90 = @v161alivepositiontaking_90,

	
		@isvalid=@isvalid OUTPUT,
		@errmsg=@ErrMsg OUTPUT,
		@errcode=@errcode OUTPUT,
		@language=@language
	if @IsValid = 0
	BEGIN
		return
	END
	---------------------------------------------------------------------------------------------------

	SELECT @username = rtrim(ltrim(@username))

	DECLARE @IsExists BIT 
	EXEC Age_CustomerCheckExists @username = @username, @IsExists = @IsExists OUTPUT

	IF @IsExists = 1
	BEGIN
		SELECT @ErrMsg = CASE @Language 
								WHEN 'E' THEN 'This username is not available.'
								ELSE [dbo].[f_Get_MsgNamebyMsgID](40001,@Language)
						END,
			@ErrCode = 101		
		RETURN
	END
	SELECT @pwdexpiry = dateadd(dd, 30, getdate())

	--Insert general data 
	EXEC dbo.Acc_Dep_CustomerInsUserInfo
		@custid = @custid OUTPUT,
		@creator = @creator,
		@username = @username,
		@userpwd = @userpwd,
		@pwdexpiry = @pwdexpiry,
		@currency = @currency,
		@site = NULL,
		@srecommend = @srecommend,
		@mrecommend = @mrecommend,
		@recommend = @recommend,
		@roleid = 1,
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
		
	
		@MaxPerMatchv1MP = @MaxPerMatchv1MP,
		@MaxPerMatchv99MP = @MaxPerMatchv99MP,
		@MaxPerMatchv161 = @MaxPerMatchv161,	
		@MaxPerBallv161 = @MaxPerBallv161,
		

		@hidekeno=@DisableKeno,

		@credit = 0,
		@maxcredit = 0,
	
		@IP = @IP,
		@TransferOption_dec = 0,
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
	SELECT @custid, 1, 1, @v1apositiontaking_1, @v1mpositiontaking_1, @v1spositiontaking_1, 0, 0, 0, 0, @MinBetv1, @MaxBetv1, 0
	UNION ALL
	SELECT @custid, 1, 1, @v1alivepositiontaking_1, @v1mlivepositiontaking_1, @v1slivepositiontaking_1, 0, 0, 0, 0, @MinBetv1, @MaxBetv1, 1
	UNION ALL	
	SELECT @custid, 3, 1, @v1apositiontaking_3, @v1mpositiontaking_3, @v1spositiontaking_3, 0, 0, 0, 0, @MinBetv1, @MaxBetv1, 0
	UNION ALL	
	SELECT @custid, 3, 1, @v1alivepositiontaking_3, @v1mlivepositiontaking_3, @v1slivepositiontaking_3, 0, 0, 0, 0, @MinBetv1, @MaxBetv1, 1
	UNION ALL	
	SELECT @custid, 7, 1, @v1apositiontaking_7, @v1mpositiontaking_7, @v1spositiontaking_7, 0, 0, 0, 0, @MinBetv1, @MaxBetv1, 0
	UNION ALL	
	SELECT @custid, 7, 1, @v1alivepositiontaking_7, @v1mlivepositiontaking_7, @v1slivepositiontaking_7, 0, 0, 0, 0, @MinBetv1, @MaxBetv1, 1
	UNION ALL	
	SELECT @custid, 8, 1, @v1apositiontaking_8, @v1mpositiontaking_8, @v1spositiontaking_8, 0, 0, 0, 0,  @MinBetv1, @MaxBetv1, 0
	UNION ALL	
	SELECT @custid, 8, 1, @v1alivepositiontaking_8, @v1mlivepositiontaking_8, @v1slivepositiontaking_8, 0, 0, 0, 0, @MinBetv1, @MaxBetv1, 1

	UNION ALL	SELECT @custid, 2, 1, @v1apositiontaking_2, @v1mpositiontaking_2, @v1spositiontaking_2, 0, 0, 0, 0, @MinBetv1, @MaxBetv1, 0
	--------------------------------------------------------------------------------------
	--1x2
	UNION ALL	SELECT @custid, 5, 1, @v1apositiontaking_5, @v1mpositiontaking_5, @v1spositiontaking_5, 0, 0, 0, 0, @MinBetv1, @MaxBetv1, 0

	UNION ALL	SELECT @custid, 4, 1, @v1apositiontaking_4, @v1mpositiontaking_4, @v1spositiontaking_4, 0, 0, 0, 0, @MinBetv1, @MaxBetv1, 0
	UNION ALL	SELECT @custid, 6, 1, @v1apositiontaking_6, @v1mpositiontaking_6, @v1spositiontaking_6, 0, 0, 0, 0, @MinBetv1, @MaxBetv1, 0
	UNION ALL	SELECT @custid, 9, 1, @v1apositiontaking_9, @v1mpositiontaking_9, @v1spositiontaking_9, 0, 0, 0, 0, @MinBetv1MP, @MaxBetv1MP, 0
	UNION ALL	SELECT @custid, 10, 1, @v1apositiontaking_10, @v1mpositiontaking_10, @v1spositiontaking_10, 0, 0, 0, 0, @MinBetv1, @MaxBetv1, 0

	UNION ALL	SELECT @custid, 1, 2, @v2apositiontaking_1, @v2mpositiontaking_1, @v2spositiontaking_1, 0, 0, 0, 0, @MinBetv2, @MaxBetv2, 0
	UNION ALL	SELECT @custid, 2, 2, @v2apositiontaking_2, @v2mpositiontaking_2, @v2spositiontaking_2, 0, 0, 0, 0, @MinBetv2, @MaxBetv2, 0
	UNION ALL	SELECT @custid, 3, 2, @v2apositiontaking_3, @v2mpositiontaking_3, @v2spositiontaking_3, 0, 0, 0, 0, @MinBetv2, @MaxBetv2, 0
	UNION ALL	SELECT @custid, 7, 2, @v2apositiontaking_7, @v2mpositiontaking_7, @v2spositiontaking_7, 0, 0, 0, 0, @MinBetv2, @MaxBetv2, 0
	UNION ALL	SELECT @custid, 8, 2, @v2apositiontaking_8, @v2mpositiontaking_8, @v2spositiontaking_8, 0, 0, 0, 0, @MinBetv2, @MaxBetv2, 0

	UNION ALL	SELECT @custid, 20, 2, @v2apositiontaking_20, @v2mpositiontaking_20, @v2spositiontaking_20, 0, 0, 0, 0, @MinBetv2, @MaxBetv2, 0

	UNION ALL	SELECT @custid, 1, 3, @v3apositiontaking_1, @v3mpositiontaking_1, @v3spositiontaking_1, 0, 0, 0, 0, @MinBetv3, @MaxBetv3, 0
	UNION ALL	SELECT @custid, 2, 3, @v3apositiontaking_2, @v3mpositiontaking_2, @v3spositiontaking_2, 0, 0, 0, 0, @MinBetv3, @MaxBetv3, 0
	UNION ALL	SELECT @custid, 3, 3, @v3apositiontaking_3, @v3mpositiontaking_3, @v3spositiontaking_3, 0, 0, 0, 0, @MinBetv3, @MaxBetv3, 0
	UNION ALL	SELECT @custid, 20, 3, @v3apositiontaking_20, @v3mpositiontaking_20, @v3spositiontaking_20, 0, 0, 0, 0, @MinBetv3, @MaxBetv3, 0

	UNION ALL	SELECT @custid, 1, 5, @v5apositiontaking_1, @v5mpositiontaking_1, @v5spositiontaking_1, 0, 0, 0, 0, @MinBetv5, @MaxBetv5, 0
	UNION ALL	SELECT @custid, 2, 5, @v5apositiontaking_2, @v5mpositiontaking_2, @v5spositiontaking_2, 0, 0, 0, 0, @MinBetv5, @MaxBetv5, 0
	UNION ALL	SELECT @custid, 3, 5, @v5apositiontaking_3, @v5mpositiontaking_3, @v5spositiontaking_3, 0, 0, 0, 0, @MinBetv5, @MaxBetv5, 0
	UNION ALL	SELECT @custid, 20, 5, @v5apositiontaking_20, @v5mpositiontaking_20, @v5spositiontaking_20, 0, 0, 0, 0, @MinBetv5, @MaxBetv5, 0

	UNION ALL	SELECT @custid, 1, 8, @v8apositiontaking_1, @v8mpositiontaking_1, @v8spositiontaking_1, 0, 0, 0, 0, @MinBetv8, @MaxBetv8, 0
	UNION ALL	SELECT @custid, 3, 8, @v8apositiontaking_3, @v8mpositiontaking_3, @v8spositiontaking_3, 0, 0, 0, 0, @MinBetv8, @MaxBetv8, 0
	UNION ALL	SELECT @custid, 20, 8, @v8apositiontaking_20, @v8mpositiontaking_20, @v8spositiontaking_20, 0, 0, 0, 0, @MinBetv8, @MaxBetv8, 0

	UNION ALL	SELECT @custid, 1, 10, @v10apositiontaking_1, @v10mpositiontaking_1, @v10spositiontaking_1, 0, 0, 0, 0, @MinBetv10, @MaxBetv10, 0
	UNION ALL	SELECT @custid, 2, 10, @v10apositiontaking_2, @v10mpositiontaking_2, @v10spositiontaking_2, 0, 0, 0, 0, @MinBetv10, @MaxBetv10, 0
	UNION ALL	SELECT @custid, 3, 10, @v10apositiontaking_3, @v10mpositiontaking_3, @v10spositiontaking_3, 0, 0, 0, 0, @MinBetv10, @MaxBetv10, 0
	UNION ALL	SELECT @custid, 20, 10, @v10apositiontaking_20, @v10mpositiontaking_20, @v10spositiontaking_20, 0, 0, 0, 0, @MinBetv10, @MaxBetv10, 0

	UNION ALL	SELECT @custid, 1, 11, @v11apositiontaking_1, @v11mpositiontaking_1, @v11spositiontaking_1, 0, 0, 0, 0, @MinBetv11, @MaxBetv11, 0
	UNION ALL	SELECT @custid, 20, 11, @v11apositiontaking_20, @v11mpositiontaking_20, @v11spositiontaking_20, 0, 0, 0, 0, @MinBetv11, @MaxBetv11, 0

	UNION ALL	SELECT @custid, 1, 99, @v99apositiontaking_1, @v99mpositiontaking_1, @v99spositiontaking_1, 0, 0, 0, 0, @MinBetv99, @MaxBetv99, 0
	UNION ALL	SELECT @custid, 2, 99, @v99apositiontaking_2, @v99mpositiontaking_2, @v99spositiontaking_2, 0, 0, 0, 0, @MinBetv99, @MaxBetv99, 0
	UNION ALL	SELECT @custid, 3, 99, @v99apositiontaking_3, @v99mpositiontaking_3, @v99spositiontaking_3, 0, 0, 0, 0, @MinBetv99, @MaxBetv99, 0
	UNION ALL	SELECT @custid, 20, 99, @v99apositiontaking_20, @v99mpositiontaking_20, @v99spositiontaking_20, 0, 0, 0, 0, @MinBetv99, @MaxBetv99, 0

	
	--Mix Sports Parlay
	UNION ALL	SELECT @custid, 9, 99, @v99apositiontaking_9, @v99mpositiontaking_9, @v99spositiontaking_9, 0, 0, 0, 0, @MinBetv99MP, @MaxBetv99MP, 0

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
		SELECT @custid, 81, 161, @v161apositiontaking_81, @v161mpositiontaking_81, @v161spositiontaking_81, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 0--nonlive
	UNION ALL	SELECT @custid, 83, 161, @v161apositiontaking_83, @v161mpositiontaking_83, @v161spositiontaking_83, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 0--nonlive
	UNION ALL	SELECT @custid, 85, 161, @v161alivepositiontaking_85, @v161mlivepositiontaking_85, 0, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 1--live

	UNION ALL	SELECT @custid, 86, 161, @v161apositiontaking_86, @v161mpositiontaking_86, @v161spositiontaking_86, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 0--nonlive
	UNION ALL	SELECT @custid, 86, 161, @v161alivepositiontaking_86, @v161mlivepositiontaking_86, @v161slivepositiontaking_86, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 1--live 

	UNION ALL	SELECT @custid, 87, 161, @v161alivepositiontaking_87, @v161mlivepositiontaking_87, @v161slivepositiontaking_87, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 1--live
	UNION ALL	SELECT @custid, 88, 161, @v161apositiontaking_88, @v161mpositiontaking_88, @v161spositiontaking_88, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 0--nonlive
	UNION ALL	SELECT @custid, 89, 161, @v161alivepositiontaking_89, @v161mlivepositiontaking_89, @v161slivepositiontaking_89, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 1--live
	UNION ALL	SELECT @custid, 90, 161, @v161alivepositiontaking_90, @v161mlivepositiontaking_90, @v161slivepositiontaking_90, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 1--live


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

	--Keno

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
	DECLARE @tmp_GameType TABLE (GameTypeID INT, GameTypeName NVARCHAR(50), IsDisabled BIT, IBCBettypeID INT)
	 BEGIN TRY		
		INSERT INTO @tmp_GameType (GameTypeID, GameTypeName, IsDisabled, IBCBettypeID)
		SELECT GameTypeID, GameTypeName, IsDisabled, IBCBettypeID FROM DBAGE.bodb02.dbo.GameType WITH (NOLOCK)
	 END TRY
	 BEGIN CATCH		
		INSERT INTO @tmp_GameType (GameTypeID, GameTypeName, IsDisabled, IBCBettypeID)
		SELECT GameTypeID, GameTypeName, IsDisabled, IBCBettypeID FROM DBTXN.bodb02.dbo.GameType WITH (NOLOCK)
	 END CATCH

	SELECT  gt.IBCBetTypeID Bettype ,
			isnull(cgt.minbet,0) AS MinBetMin, 
			isnull(cgt.maxbet,0) AS MaxbetMax, 
			isnull(csg.mpositiontaking,0) AS MaxPT,
			isnull(cgt.MaxPerGameType,0) AS MaxPerMarchMax
	INTO #MinMaxUpline
	FROM dbo.CustGameType cgt WITH(NOLOCK)
		INNER JOIN CustSettingGame csg ON cgt.custid = csg.custid
		INNER JOIN @tmp_GameType gt ON cgt.GameTypeID = gt.GameTypeID
	WHERE cgt.custid = @recommend
		AND csg.sporttype = 202	

	IF EXISTS (SELECT top 1 1 
				FROM #data d INNER JOIN #MinMaxUpline m on d.bettype=m.bettype
				WHERE (d.MinBet < m.MinBetMin) and d.MinBet > 0) 
	BEGIN	
		SELECT top 1 @Bet=MinBetMin FROM #data d INNER JOIN #MinMaxUpline m on d.bettype=m.bettype
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
				WHERE (d.MaxPerMatch > m.MaxPerMarchMax) and d.MaxPerMatch >0 )
	BEGIN	
		SELECT top 1 @Bet=MaxPerMarchMax FROM #data d INNER JOIN #MinMaxUpline m on d.bettype=m.bettype
				WHERE (d.MaxPerMatch > m.MaxPerMarchMax) ORDER BY d.bettype DESC
		SELECT
			@ErrMsg =	case @Language 
								when 'E' then 'Max Per Match must be less than or equal '+COALESCE(CAST(@Bet AS VARCHAR(50)),SPACE(1))+' (Max Per Match).'
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

	--check PT
	IF EXISTS (SELECT top 1 1 
				FROM #data d INNER JOIN #MinMaxUpline m on d.bettype=m.bettype
				WHERE (d.mPositionTaking > m.MaxPT) and d.mPositionTaking >0)
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
	SELECT @custid,gt.GameTypeID,'',MaxPerMatch,MinBet,MaxBet,d.IsDisable 
	FROM #data d INNER JOIN @tmp_GameType gt ON d.bettype=gt.IBCBetTypeID

	IF @@ERROR <> 0
	BEGIN
		--Error Occurs
		SELECT @ErrMsg = CASE @Language 
								when 'E' then 'Create customer fail. Please try again'
								ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
							END	
				, @ErrCode=116
		
		-- ROLLBACK MANUALLY
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

	
	--Exclude created member from Balance checking
	--INSERT INTO dbo.Task_Cust_CheckBalance_Exception(custid, remark) values(@custid, @username)
	EXEC DBTXN.bodb02.dbo.Task_Cust_CheckBalance_Exception_Ins @custid = @custid, @username = @username
	if @@error <> 0
	BEGIN
		--Error occur
		SELECT @ErrMsg = case @Language 
								when 'E' then 'Exclude customer from balance checking failed.'
								else N'Exclude customer from balance checking failed.'
							end,
			@ErrCode = 211		
		RETURN
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
	Select @LogSPData = '<Acc_Dep_CustomerInsMember_Ag custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +
	'creator="'+ coalesce(cast(@creator as varchar(50)),space(1)) + '" ' +
	'username="'+ coalesce(cast(@username as varchar(30)),space(1)) + '" ' +
	'recommend="'+ coalesce(cast(@recommend as varchar(50)),space(1)) + '" ' +
	'IP="'+ coalesce(cast(@IP as varchar(15)),space(1)) + '" ' +
	'Language="'+ coalesce(cast(@Language as varchar(2)),space(1)) + '" ' +
	'SubAccName="'+ coalesce(cast(dbo.f_GetSubUsername(@SubAccID) as varchar(30)),space(1)) + '" ' +
	'ErrCode="'+ coalesce(cast(@ErrCode as varchar(50)),space(1)) + '" ' +
	'ErrMsg="'+ coalesce(cast(@ErrMsg as varchar(4000)),space(1)) + '" />'
	EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP 
		@UserID = @Creator,
		@CustID = @CustID,
		@ActionID = 2415,
		@TrackingValue = @LogSPData,
		@duration = @duration		

		
	--log bet Setting
	Select @LogSPData = '<Acc_Dep_CustomerInsMember_Ag custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +
	'MinBv1="'+ coalesce(cast(@minbetv1 as varchar(50)),space(1)) + '" ' +
	'MaxBv1="'+ coalesce(cast(@maxbetv1 as varchar(50)),space(1)) + '" ' +
	'MPMv1="'+ coalesce(cast(@maxpermatchv1 as varchar(50)),space(1)) + '" ' +
	'MinBv2="'+ coalesce(cast(@minbetv2 as varchar(50)),space(1)) + '" ' +
	'MaxBv2="'+ coalesce(cast(@maxbetv2 as varchar(50)),space(1)) + '" ' +
	'MPMv2="'+ coalesce(cast(@maxpermatchv2 as varchar(50)),space(1)) + '" ' +
	'MinBv3="'+ coalesce(cast(@minbetv3 as varchar(50)),space(1)) + '" ' +
	'MaxBv3="'+ coalesce(cast(@maxbetv3 as varchar(50)),space(1)) + '" ' +
	'MPMv3="'+ coalesce(cast(@maxpermatchv3 as varchar(50)),space(1)) + '" ' +
	'MinBv5="'+ coalesce(cast(@minbetv5 as varchar(50)),space(1)) + '" ' +
	'MaxBv5="'+ coalesce(cast(@maxbetv5 as varchar(50)),space(1)) + '" ' +
	'MPMv5="'+ coalesce(cast(@maxpermatchv5 as varchar(50)),space(1)) + '" ' +
	'MinBv8="'+ coalesce(cast(@minbetv8 as varchar(50)),space(1)) + '" ' +
	'MaxBv8="'+ coalesce(cast(@maxbetv8 as varchar(50)),space(1)) + '" ' +
	'MPMv8="'+ coalesce(cast(@maxpermatchv8 as varchar(50)),space(1)) + '" ' +
	'MinBv10="'+ coalesce(cast(@minbetv10 as varchar(50)),space(1)) + '" ' +
	'MaxBv10="'+ coalesce(cast(@maxbetv10 as varchar(50)),space(1)) + '" ' +
	'MPMv10="'+ coalesce(cast(@maxpermatchv10 as varchar(50)),space(1)) + '" ' +
	'MinBv11="'+ coalesce(cast(@minbetv11 as varchar(50)),space(1)) + '" ' +
	'MaxBv11="'+ coalesce(cast(@maxbetv11 as varchar(50)),space(1)) + '" ' +
	'MPMv11="'+ coalesce(cast(@maxpermatchv11 as varchar(50)),space(1)) + '" ' +

	'MinBv99="'+ coalesce(cast(@minbetv99 as varchar(50)),space(1)) + '" ' +
	'MaxBv99="'+ coalesce(cast(@maxbetv99 as varchar(50)),space(1)) + '" ' +
	'MPMv99="'+ coalesce(cast(@maxpermatchv99 as varchar(50)),space(1)) + '" ' +

	'MinBv1MP="'+ coalesce(cast(@minbetv1mp as varchar(50)),space(1)) + '" ' +
	'MaxBv1MP="'+ coalesce(cast(@maxbetv1mp as varchar(50)),space(1)) + '" ' +
	'MPMv1MP="'+ coalesce(cast(@maxpermatchv1mp as varchar(50)),space(1)) + '" ' +
	
	'MinBv99MP="'+ coalesce(cast(@minbetv99mp as varchar(50)),space(1)) + '" ' +
	'MaxBv99MP="'+ coalesce(cast(@maxbetv99mp as varchar(50)),space(1)) + '" ' +
	'MPMv99MP="'+ coalesce(cast(@maxpermatchv99mp as varchar(50)),space(1)) + '" ' +
	'MinBv161="' + coalesce(cast(@minbetv161 as varchar(50)),space(1)) + '" ' +
	'MaxBv161="' + coalesce(cast(@maxbetv161 as varchar(50)),space(1)) + '" ' +
	'MPMv161="' + coalesce(cast(@maxpermatchv161 as varchar(50)),space(1)) + '" ' +
	'MPBv161="' + coalesce(cast(@maxperballv161 as varchar(50)), space(1)) + '" ' +	

	@str_bet + ' />'
	
	EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP 
		@UserID = @Creator,
		@CustID = @CustID,
		@ActionID = 2008,
		@TrackingValue = @LogSPData,
		@duration = @duration
	 
	--Log Status
	Select @LogSPData = '<Acc_Dep_CustomerInsMember_Ag custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +
	'closed="'+ coalesce(cast(@UplineClosed as varchar(1)),space(1)) + '" ' +
	'DisableOutright="'+ coalesce(cast(@DisableOutright as varchar(1)),space(1)) + '" ' +
	'DisableNumber="' + coalesce(cast(@DisableNumber as varchar(1)),space(1)) + '" />'

	EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP 
		@UserID = @Creator,
		@CustID = @CustID,
		@ActionID = 2205,
		@TrackingValue = @LogSPData,
		@duration = @duration
		

	--Write PT log
	SELECT @LogSPData = '<Acc_Dep_CustomerInsMember_Ag><s spt_1="'+ COALESCE(CAST(@v1spositiontaking_1 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'spt_2="'+ COALESCE(CAST(@v1spositiontaking_2 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'spt_3="'+ COALESCE(CAST(@v1spositiontaking_3 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'spt_4="'+ COALESCE(CAST(@v1spositiontaking_4 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'spt_5="'+ COALESCE(CAST(@v1spositiontaking_5 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'spt_6="'+ COALESCE(CAST(@v1spositiontaking_6 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'spt_7="'+ COALESCE(CAST(@v1spositiontaking_7 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'spt_8="'+ COALESCE(CAST(@v1spositiontaking_8 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'spt_9="'+ COALESCE(CAST(@v1spositiontaking_9 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'spt_10="'+ COALESCE(CAST(@v1spositiontaking_10 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'slivept_1="'+ COALESCE(CAST(@v1slivepositiontaking_1 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'slivept_3="'+ COALESCE(CAST(@v1slivepositiontaking_3 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'slivept_7="'+ COALESCE(CAST(@v1slivepositiontaking_7 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'slivept_8="'+ COALESCE(CAST(@v1slivepositiontaking_8 AS VARCHAR(50)),SPACE(1)) + '" ' +

	'v2spt_1="'+ COALESCE(CAST(@v2spositiontaking_1 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v2spt_2="'+ COALESCE(CAST(@v2spositiontaking_2 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v2spt_3="'+ COALESCE(CAST(@v2spositiontaking_3 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v2spt_7="'+ COALESCE(CAST(@v2spositiontaking_7 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v2spt_8="'+ COALESCE(CAST(@v2spositiontaking_8 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v2spt_20="'+ COALESCE(CAST(@v2spositiontaking_20 AS VARCHAR(50)),SPACE(1)) + '" ' +

	'v3spt_1="'+ COALESCE(CAST(@v3spositiontaking_1 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v3spt_2="'+ COALESCE(CAST(@v3spositiontaking_2 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v3spt_3="'+ COALESCE(CAST(@v3spositiontaking_3 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v3spt_20="'+ COALESCE(CAST(@v3spositiontaking_20 AS VARCHAR(50)),SPACE(1)) + '" ' +

	'v5spt_1="'+ COALESCE(CAST(@v5spositiontaking_1 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v5spt_2="'+ COALESCE(CAST(@v5spositiontaking_2 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v5spt_3="'+ COALESCE(CAST(@v5spositiontaking_3 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v5spt_20="'+ COALESCE(CAST(@v5spositiontaking_20 AS VARCHAR(50)),SPACE(1)) + '" ' +

	'v8spt_1="'+ COALESCE(CAST(@v8spositiontaking_1 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v8spt_3="'+ COALESCE(CAST(@v8spositiontaking_3 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v8spt_20="'+ COALESCE(CAST(@v8spositiontaking_20 AS VARCHAR(50)),SPACE(1)) + '" ' +

	'v10spt_1="'+ COALESCE(CAST(@v10spositiontaking_1 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v10spt_2="'+ COALESCE(CAST(@v10spositiontaking_2 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v10spt_3="'+ COALESCE(CAST(@v10spositiontaking_3 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v10spt_20="'+ COALESCE(CAST(@v10spositiontaking_20 AS VARCHAR(50)),SPACE(1)) + '" ' +

	'v11spt_1="'+ COALESCE(CAST(@v11spositiontaking_1 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v11spt_20="'+ COALESCE(CAST(@v11spositiontaking_20 AS VARCHAR(50)),SPACE(1)) + '" ' +

	'v99spt_1="'+ COALESCE(CAST(@v99spositiontaking_1 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v99spt_2="'+ COALESCE(CAST(@v99spositiontaking_2 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v99spt_3="'+ COALESCE(CAST(@v99spositiontaking_3 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v99spt_9="'+ COALESCE(CAST(@v99spositiontaking_9 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v99spt_20="'+ COALESCE(CAST(@v99spositiontaking_20 AS VARCHAR(50)),SPACE(1)) + '" ' +

	'v161spt_81="'+ COALESCE(CONVERT(VARCHAR(50),@v161spositiontaking_81,2),SPACE(1)) + '" ' +
	'v161spt_83="'+ COALESCE(CONVERT(VARCHAR(50),@v161spositiontaking_83,2),SPACE(1)) + '" ' +
	'v161spt_86="'+ COALESCE(CONVERT(VARCHAR(50),@v161spositiontaking_86,2),SPACE(1)) + '" ' +
	'v161spt_88="'+ COALESCE(CONVERT(VARCHAR(50),@v161spositiontaking_88,2),SPACE(1)) + '" ' +
	'v161slivept_85="'+ COALESCE(CONVERT(VARCHAR(50),@v161slivepositiontaking_85,2),SPACE(1)) + '" ' +
	'v161slivept_86="'+ COALESCE(CONVERT(VARCHAR(50),@v161slivepositiontaking_86,2),SPACE(1)) + '" ' +
	'v161slivept_87="'+ COALESCE(CONVERT(VARCHAR(50),@v161slivepositiontaking_87,2),SPACE(1)) + '" ' +
	'v161slivept_89="'+ COALESCE(CONVERT(VARCHAR(50),@v161slivepositiontaking_89,2),SPACE(1)) + '" ' +
	'v161slivept_90="'+ COALESCE(CONVERT(VARCHAR(50),@v161slivepositiontaking_90,2),SPACE(1)) + '" ' +

	@str_spt+
	' />' +
	

	'<m mpt_1="'+ COALESCE(CAST(@v1mpositiontaking_1 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'mpt_2="'+ COALESCE(CAST(@v1mpositiontaking_2 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'mpt_3="'+ COALESCE(CAST(@v1mpositiontaking_3 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'mpt_4="'+ COALESCE(CAST(@v1mpositiontaking_4 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'mpt_5="'+ COALESCE(CAST(@v1mpositiontaking_5 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'mpt_6="'+ COALESCE(CAST(@v1mpositiontaking_6 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'mpt_7="'+ COALESCE(CAST(@v1mpositiontaking_7 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'mpt_8="'+ COALESCE(CAST(@v1mpositiontaking_8 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'mpt_9="'+ COALESCE(CAST(@v1mpositiontaking_9 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'mpt_10="'+ COALESCE(CAST(@v1mpositiontaking_10 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'mlivept_1="'+ COALESCE(CAST(@v1mlivepositiontaking_1 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'mlivept_3="'+ COALESCE(CAST(@v1mlivepositiontaking_3 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'mlivept_7="'+ COALESCE(CAST(@v1mlivepositiontaking_7 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'mlivept_8="'+ COALESCE(CAST(@v1mlivepositiontaking_8 AS VARCHAR(50)),SPACE(1)) + '" ' +

	'v2mpt_1="'+ COALESCE(CAST(@v2mpositiontaking_1 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v2mpt_2="'+ COALESCE(CAST(@v2mpositiontaking_2 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v2mpt_3="'+ COALESCE(CAST(@v2mpositiontaking_3 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v2mpt_7="'+ COALESCE(CAST(@v2mpositiontaking_7 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v2mpt_8="'+ COALESCE(CAST(@v2mpositiontaking_8 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v2mpt_20="'+ COALESCE(CAST(@v2mpositiontaking_20 AS VARCHAR(50)),SPACE(1)) + '" ' +

	'v3mpt_1="'+ COALESCE(CAST(@v3mpositiontaking_1 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v3mpt_2="'+ COALESCE(CAST(@v3mpositiontaking_2 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v3mpt_3="'+ COALESCE(CAST(@v3mpositiontaking_3 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v3mpt_20="'+ COALESCE(CAST(@v3mpositiontaking_20 AS VARCHAR(50)),SPACE(1)) + '" ' +

	'v5mpt_1="'+ COALESCE(CAST(@v5mpositiontaking_1 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v5mpt_2="'+ COALESCE(CAST(@v5mpositiontaking_2 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v5mpt_3="'+ COALESCE(CAST(@v5mpositiontaking_3 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v5mpt_20="'+ COALESCE(CAST(@v5mpositiontaking_20 AS VARCHAR(50)),SPACE(1)) + '" ' +

	'v8mpt_1="'+ COALESCE(CAST(@v8mpositiontaking_1 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v8mpt_3="'+ COALESCE(CAST(@v8mpositiontaking_3 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v8mpt_20="'+ COALESCE(CAST(@v8mpositiontaking_20 AS VARCHAR(50)),SPACE(1)) + '" ' +

	'v10mpt_1="'+ COALESCE(CAST(@v10mpositiontaking_1 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v10mpt_2="'+ COALESCE(CAST(@v10mpositiontaking_2 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v10mpt_3="'+ COALESCE(CAST(@v10mpositiontaking_3 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v10mpt_20="'+ COALESCE(CAST(@v10mpositiontaking_20 AS VARCHAR(50)),SPACE(1)) + '" ' +

	'v11mpt_1="'+ COALESCE(CAST(@v11mpositiontaking_1 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v11mpt_20="'+ COALESCE(CAST(@v11mpositiontaking_20 AS VARCHAR(50)),SPACE(1)) + '" ' +

	'v99mpt_1="'+ COALESCE(CAST(@v99mpositiontaking_1 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v99mpt_2="'+ COALESCE(CAST(@v99mpositiontaking_2 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v99mpt_3="'+ COALESCE(CAST(@v99mpositiontaking_3 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v99mpt_9="'+ COALESCE(CAST(@v99mpositiontaking_9 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v99mpt_20="'+ COALESCE(CAST(@v99mpositiontaking_20 AS VARCHAR(50)),SPACE(1)) + '" ' +

	'v161mpt_81="'+ COALESCE(CONVERT(VARCHAR(50),@v161mpositiontaking_81,2),SPACE(1)) + '" ' +
	'v161mpt_83="'+ COALESCE(CONVERT(VARCHAR(50),@v161mpositiontaking_83,2),SPACE(1)) + '" ' +
	'v161mpt_86="'+ COALESCE(CONVERT(VARCHAR(50),@v161mpositiontaking_86,2),SPACE(1)) + '" ' +
	'v161mpt_88="'+ COALESCE(CONVERT(VARCHAR(50),@v161mpositiontaking_88,2),SPACE(1)) + '" ' +
	'v161mlivept_85="'+ COALESCE(CONVERT(VARCHAR(50),@v161mlivepositiontaking_85,2),SPACE(1)) + '" ' +
	'v161mlivept_86="'+ COALESCE(CONVERT(VARCHAR(50),@v161mlivepositiontaking_86,2),SPACE(1)) + '" ' +
	'v161mlivept_87="'+ COALESCE(CONVERT(VARCHAR(50),@v161mlivepositiontaking_87,2),SPACE(1)) + '" ' +
	'v161mlivept_89="'+ COALESCE(CONVERT(VARCHAR(50),@v161mlivepositiontaking_89,2),SPACE(1)) + '" ' +
	'v161mlivept_90="'+ COALESCE(CONVERT(VARCHAR(50),@v161mlivepositiontaking_90,2),SPACE(1)) + '" ' +

	@str_mpt+

	
	' />' +

	'<ag apt_1="'+ COALESCE(CAST(@v1apositiontaking_1 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'apt_2="'+ COALESCE(CAST(@v1apositiontaking_2 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'apt_3="'+ COALESCE(CAST(@v1apositiontaking_3 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'apt_4="'+ COALESCE(CAST(@v1apositiontaking_4 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'apt_5="'+ COALESCE(CAST(@v1apositiontaking_5 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'apt_6="'+ COALESCE(CAST(@v1apositiontaking_6 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'apt_7="'+ COALESCE(CAST(@v1apositiontaking_7 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'apt_8="'+ COALESCE(CAST(@v1apositiontaking_8 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'apt_9="'+ COALESCE(CAST(@v1apositiontaking_9 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'apt_10="'+ COALESCE(CAST(@v1apositiontaking_10 AS VARCHAR(50)),SPACE(1)) + '" ' + 
	'alivept_1="'+ COALESCE(CAST(@v1alivepositiontaking_1 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'alivept_3="'+ COALESCE(CAST(@v1alivepositiontaking_3 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'alivept_7="'+ COALESCE(CAST(@v1alivepositiontaking_7 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'alivept_8="'+ COALESCE(CAST(@v1alivepositiontaking_8 AS VARCHAR(50)),SPACE(1)) + '" ' +

	'v2apt_1="'+ COALESCE(CAST(@v2apositiontaking_1 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v2apt_2="'+ COALESCE(CAST(@v2apositiontaking_2 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v2apt_3="'+ COALESCE(CAST(@v2apositiontaking_3 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v2apt_7="'+ COALESCE(CAST(@v2apositiontaking_7 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v2apt_8="'+ COALESCE(CAST(@v2apositiontaking_8 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v2apt_20="'+ COALESCE(CAST(@v2apositiontaking_20 AS VARCHAR(50)),SPACE(1)) + '" ' +

	'v3apt_1="'+ COALESCE(CAST(@v3apositiontaking_1 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v3apt_2="'+ COALESCE(CAST(@v3apositiontaking_2 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v3apt_3="'+ COALESCE(CAST(@v3apositiontaking_3 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v3apt_20="'+ COALESCE(CAST(@v3apositiontaking_20 AS VARCHAR(50)),SPACE(1)) + '" ' +

	'v5apt_1="'+ COALESCE(CAST(@v5apositiontaking_1 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v5apt_2="'+ COALESCE(CAST(@v5apositiontaking_2 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v5apt_3="'+ COALESCE(CAST(@v5apositiontaking_3 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v5apt_20="'+ COALESCE(CAST(@v5apositiontaking_20 AS VARCHAR(50)),SPACE(1)) + '" ' +

	'v8apt_1="'+ COALESCE(CAST(@v8apositiontaking_1 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v8apt_3="'+ COALESCE(CAST(@v8apositiontaking_3 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v8apt_20="'+ COALESCE(CAST(@v8apositiontaking_20 AS VARCHAR(50)),SPACE(1)) + '" ' +

	'v10apt_1="'+ COALESCE(CAST(@v10apositiontaking_1 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v10apt_2="'+ COALESCE(CAST(@v10apositiontaking_2 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v10apt_3="'+ COALESCE(CAST(@v10apositiontaking_3 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v10apt_20="'+ COALESCE(CAST(@v10apositiontaking_20 AS VARCHAR(50)),SPACE(1)) + '" ' +

	'v11apt_1="'+ COALESCE(CAST(@v11apositiontaking_1 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v11apt_20="'+ COALESCE(CAST(@v11apositiontaking_20 AS VARCHAR(50)),SPACE(1)) + '" ' +

	'v99apt_1="'+ COALESCE(CAST(@v99apositiontaking_1 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v99apt_2="'+ COALESCE(CAST(@v99apositiontaking_2 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v99apt_3="'+ COALESCE(CAST(@v99apositiontaking_3 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v99apt_9="'+ COALESCE(CAST(@v99apositiontaking_9 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v99apt_20="'+ COALESCE(CAST(@v99apositiontaking_20 AS VARCHAR(50)),SPACE(1)) + '" ' +

	'v161apt_81="'+ COALESCE(CONVERT(VARCHAR(50),@v161apositiontaking_81,2),SPACE(1)) + '" ' +
	'v161apt_83="'+ COALESCE(CONVERT(VARCHAR(50),@v161apositiontaking_83,2),SPACE(1)) + '" ' +
	'v161apt_86="'+ COALESCE(CONVERT(VARCHAR(50),@v161apositiontaking_86,2),SPACE(1)) + '" ' +
	'v161apt_88="'+ COALESCE(CONVERT(VARCHAR(50),@v161apositiontaking_88,2),SPACE(1)) + '" ' +
	'v161alivept_85="'+ COALESCE(CONVERT(VARCHAR(50),@v161alivepositiontaking_85,2),SPACE(1)) + '" ' +
	'v161alivept_86="'+ COALESCE(CONVERT(VARCHAR(50),@v161alivepositiontaking_86,2),SPACE(1)) + '" ' +
	'v161alivept_87="'+ COALESCE(CONVERT(VARCHAR(50),@v161alivepositiontaking_87,2),SPACE(1)) + '" ' +
	'v161alivept_89="'+ COALESCE(CONVERT(VARCHAR(50),@v161alivepositiontaking_89,2),SPACE(1)) + '" ' +
	'v161alivept_90="'+ COALESCE(CONVERT(VARCHAR(50),@v161alivepositiontaking_90,2),SPACE(1)) + '" ' +

	@str_apt+

	
	 ' />'+
	'</Acc_Dep_CustomerInsMember_Ag>' 

	--Log positiontaking
	EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP 
		@UserID = @Creator,
		@CustID = @CustID,
		@ActionID = 2704,
		@TrackingValue = @LogSPData,
		@duration = @duration

	DROP TABLE #data
	DROP TABLE #MinMaxUpline
END
GO
