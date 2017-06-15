USE [bodb02]
GO
/****** Object:  StoredProcedure [dbo].[Acc_Dep_CustomerInsMember_Ag]    Script Date: 06/07/2013 03:17:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.Acc_Dep_CustomerInsMember_Ag    Script Date: 2013-06-04 5:34:42 PM ******/
/****** Object:  Stored Procedure dbo.Acc_Dep_CustomerInsMember_Ag    Script Date: 10/25/2012 2:57:08 PM ******/
ALTER PROCEDURE [dbo].[Acc_Dep_CustomerInsMember_Ag]
	@custid									int OUTPUT,
	@creator								int,
	@username								varchar(30),
	@userpwd								varchar(40) = '123qwe',
	@recommend								int, -- Agent ID

	@Disable151_31 bit = 0,-- @DisableHorseRacing -> @Disable151_31
	@Disable151_41 bit = 0,-- @DisableOpenTote -> @Disable151_41
	@Disable151_51 bit = 0, -- @Disable151_AU -> @Disable151_51
	@Disable152_41 bit = 0, -- @Disable152_UK -> @Disable152_41
	@Disable152_51 bit = 0, -- @Disable152_AU -> @Disable152_51
	@Disable153_51 bit = 0,-- @Disable153_AU -> @Disable153_51
	
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
	@MinBetv99mp money,
	@MaxBetv99mp money,
	@MaxPerMatchv99mp money,
	-- number game
	@MinBetv161 money,
	@MaxBetv161 money,
	@MaxPerMatchv161 money,

	@MaxPerBallv161 money = 0,	

	--Racing Bet Setting
	@v151minbet_31			money = 0,	-- old name: @minbet_31
	@v151maxbet_31			money = 0,	-- old name: @maxbet_31
	@v151maxpermatch_31		money = 0,	-- old name: @maxpermatch_31

	@v151minbet_41			money,		-- old name: @minbet_41
	@v151maxbet_41			money,		-- old name: @maxbet_41
	@v151maxpermatch_41		money,		-- old name: @maxpermatch_41
	
	@v151minbet_51			money = 0,
	@v151maxbet_51			money = 0,
	@v151maxpermatch_51		money = 0,

	@v152minbet_41		money = 0,
	@v152maxbet_41		money = 0,
	@v152maxpermatch_41 money = 0,

	@v152minbet_51		money = 0,
	@v152maxbet_51		money = 0,
	@v152maxpermatch_51 money = 0,

	@v153minbet_51		money = 0,
	@v153maxbet_51		money = 0,
	@v153maxpermatch_51 money = 0,

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

	--Racing
	@v151apositiontaking_31 smallmoney = 0,
	@v151apositiontaking_32 smallmoney = 0,
	@v151apositiontaking_41 smallmoney = 0,
	@v151apositiontaking_42 smallmoney = 0,
	
	@v151apositiontaking_51 smallmoney = 0,
	@v151apositiontaking_52 smallmoney = 0,

	@v152apositiontaking_41 smallmoney = 0,
	@v152apositiontaking_42 smallmoney = 0,
	@v152apositiontaking_51 smallmoney = 0,
	@v152apositiontaking_52 smallmoney = 0,

	@v153apositiontaking_51 smallmoney = 0,
	@v153apositiontaking_52 smallmoney = 0,
	
	@v161apositiontaking_81 smallmoney,
	@v161apositiontaking_83 smallmoney,
	@v161apositiontaking_86 smallmoney,
	@v161apositiontaking_88 smallmoney = 0,
	
	@v161alivepositiontaking_85 smallmoney,
	@v161alivepositiontaking_86 smallmoney,	
	@v161alivepositiontaking_87 smallmoney,
	@v161alivepositiontaking_89 smallmoney = 0,	
	@v161alivepositiontaking_90 smallmoney = 0,
	
	--Horse Racing Commission
	@v151playerdiscount_31 decimal(9,8) = 0,	
	@v151playerdiscount_41 decimal(9,8) = 0,

	@v151playerdiscount_51 decimal(9,8) = 0,
	@v152playerdiscount_41 decimal(9,8) = 0,
	@v152playerdiscount_51 decimal(9,8) = 0,
	@v153playerdiscount_51 decimal(9,8) = 0,

	@v180aPositionTaking SMALLMONEY = 0,
	
	@v180MinBet MONEY = 0,
	@v180MaxBet MONEY = 0,
	@v180MaxPerMatch MONEY = 0,

	@IP										varchar(15)='',
	@Language								varchar(2)= 'E',
	@SubAccID								int = 0, --Sub-AccountID
	@ErrCode								int = 0 OUTPUT,
	@ErrMsg									nvarchar(4000) = '' OUTPUT
AS
--@Source Control
/*
Created: 20120322@Dom
Task : Agent create dummy account
DB: DBTRANS.bodb02
Original:

Revisions:
	20130604@Daniel: Change default P2P param value to "Disable P2P"
	20130607@Daniel: Exclude created member from Balance checking

    
Param's Explanation:
• @ErrCode:
    = 0: Create agent successfully.
    > 0: Specific Error.
  
• @ErrMsg: Error description.
*/


SET NOCOUNT ON

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
	@DisableVirtualSport bit,
	@UplineSyncLiveCasino bit,
	
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
	
	--Racing
	@v151mpositiontaking_31 smallmoney ,
	@v151mpositiontaking_32 smallmoney ,
	@v151mpositiontaking_41 smallmoney ,
	@v151mpositiontaking_42 smallmoney ,
									   
	@v151mpositiontaking_51 smallmoney ,
	@v151mpositiontaking_52 smallmoney ,
									   
	@v152mpositiontaking_41 smallmoney ,
	@v152mpositiontaking_42 smallmoney ,
	@v152mpositiontaking_51 smallmoney ,
	@v152mpositiontaking_52 smallmoney ,
									   
	@v153mpositiontaking_51 smallmoney ,
	@v153mpositiontaking_52 smallmoney ,

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

	--Racing
	@v151spositiontaking_31 smallmoney ,
	@v151spositiontaking_32 smallmoney ,
	@v151spositiontaking_41 smallmoney ,
	@v151spositiontaking_42 smallmoney ,
									   
	@v151spositiontaking_51 smallmoney ,
	@v151spositiontaking_52 smallmoney ,
									   
	@v152spositiontaking_41 smallmoney ,
	@v152spositiontaking_42 smallmoney ,
	@v152spositiontaking_51 smallmoney ,
	@v152spositiontaking_52 smallmoney ,
									   
	@v153spositiontaking_51 smallmoney ,
	@v153spositiontaking_52 smallmoney ,

	--Horse Racing Commission
	@v151sdiscount_31 decimal(9,8),	
	@v151sdiscount_41 decimal(9,8),
	@v151sdiscount_51 decimal(9,8),
	@v152sdiscount_41 decimal(9,8),
	@v152sdiscount_51 decimal(9,8),
	@v153sdiscount_51 decimal(9,8),

	@v151adiscount_31 decimal(9,8),	
	@v151adiscount_41 decimal(9,8),
	@v151adiscount_51 decimal(9,8),
	@v152adiscount_41 decimal(9,8),
	@v152adiscount_51 decimal(9,8),
	@v153adiscount_51 decimal(9,8),

	@v151discount_31 decimal(9,8),	
	@v151discount_41 decimal(9,8),
	@v151discount_51 decimal(9,8),
	@v152discount_41 decimal(9,8),
	@v152discount_51 decimal(9,8),
	@v153discount_51 decimal(9,8),
	@v162apositiontaking_1101 money,
	@v162mpositiontaking_1101 money,
	@v162spositiontaking_1101 money,
	@v162discount_1101 decimal(9,8),
	@v162adiscount_1101 decimal(9,8),
	@v162sdiscount_1101 decimal(9,8)
	

select 
	@currency = currency, 
	@Msuspended = reject,
	@UplineClosed = closed,
	@UplineSyncLiveCasino = SyncLiveCasino,
	@srecommend = srecommend,
	@mrecommend = mrecommend,
	@matchlimit = matchlimit,
	@Disable151_31 = case when DisableHorseRacing = 1 then 1 else @Disable151_31 end,
	@Disable151_41 = case when DisableOpenTote = 1 then 1 else @Disable151_41 end,
	@Disable151_51 = case when Disable151_AU = 1 then 1 else @Disable151_51 end,
	@Disable152_41 = case when Disable152_UK = 1 then 1 else @Disable152_41 end,
	@Disable152_51 = case when Disable152_AU = 1 then 1 else @Disable152_51 end,
	@Disable153_51 = case when Disable153_AU = 1 then 1 else @Disable153_51 end,
	@DisableOutright = DisableOutright,
	@DisableVirtualSport = ci.DisableVirtualSports,
	@DisableNumber = case when DisableNumber = 1 then 1 else @DisableNumber end
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
	--Racing
	@v151mpositiontaking_31 = CASE WHEN cs3.sporttype = 151 AND cs3.bettype = 31 AND cs3.islive = 0 THEN cs3.mpositiontaking ELSE 0 END,
	@v151mpositiontaking_32 = CASE WHEN cs3.sporttype = 151 AND cs3.bettype = 32 AND cs3.islive = 0 THEN cs3.mpositiontaking ELSE 0 END,
	@v151mpositiontaking_41 = CASE WHEN cs3.sporttype = 151 AND cs3.bettype = 41 AND cs3.islive = 0 THEN cs3.mpositiontaking ELSE 0 END,
	@v151mpositiontaking_42 = CASE WHEN cs3.sporttype = 151 AND cs3.bettype = 42 AND cs3.islive = 0 THEN cs3.mpositiontaking ELSE 0 END,
	@v151mpositiontaking_51  = CASE WHEN cs3.sporttype = 151 AND cs3.bettype = 51 AND cs3.islive = 0 THEN cs3.mpositiontaking ELSE 0 END,
	@v151mpositiontaking_52  = CASE WHEN cs3.sporttype = 151 AND cs3.bettype = 52 AND cs3.islive = 0 THEN cs3.mpositiontaking ELSE 0 END,
									   
	@v152mpositiontaking_41 = CASE WHEN cs3.sporttype = 152 AND cs3.bettype = 41 AND cs3.islive = 0 THEN cs3.mpositiontaking ELSE 0 END ,
	@v152mpositiontaking_42 = CASE WHEN cs3.sporttype = 152 AND cs3.bettype = 42 AND cs3.islive = 0 THEN cs3.mpositiontaking ELSE 0 END ,
	@v152mpositiontaking_51 = CASE WHEN cs3.sporttype = 152 AND cs3.bettype = 51 AND cs3.islive = 0 THEN cs3.mpositiontaking ELSE 0 END ,
	@v152mpositiontaking_52 = CASE WHEN cs3.sporttype = 152 AND cs3.bettype = 52 AND cs3.islive = 0 THEN cs3.mpositiontaking ELSE 0 END ,
									   
	@v153mpositiontaking_51  = CASE WHEN cs3.sporttype = 153 AND cs3.bettype = 51 AND cs3.islive = 0 THEN cs3.mpositiontaking ELSE 0 END ,
	@v153mpositiontaking_52  = CASE WHEN cs3.sporttype = 153 AND cs3.bettype = 52 AND cs3.islive = 0 THEN cs3.mpositiontaking ELSE 0 END ,

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
	--Racing
	@v151spositiontaking_31 = CASE WHEN cs3.sporttype = 151 AND cs3.bettype = 31 AND cs3.islive = 0 THEN cs3.spositiontaking ELSE 0 END,
	@v151spositiontaking_32 = CASE WHEN cs3.sporttype = 151 AND cs3.bettype = 32 AND cs3.islive = 0 THEN cs3.spositiontaking ELSE 0 END,
	@v151spositiontaking_41 = CASE WHEN cs3.sporttype = 151 AND cs3.bettype = 41 AND cs3.islive = 0 THEN cs3.spositiontaking ELSE 0 END,
	@v151spositiontaking_42 = CASE WHEN cs3.sporttype = 151 AND cs3.bettype = 42 AND cs3.islive = 0 THEN cs3.spositiontaking ELSE 0 END,
	@v151spositiontaking_51  = CASE WHEN cs3.sporttype = 151 AND cs3.bettype = 51 AND cs3.islive = 0 THEN cs3.spositiontaking ELSE 0 END,
	@v151spositiontaking_52  = CASE WHEN cs3.sporttype = 151 AND cs3.bettype = 52 AND cs3.islive = 0 THEN cs3.spositiontaking ELSE 0 END,
									   
	@v152spositiontaking_41 = CASE WHEN cs3.sporttype = 152 AND cs3.bettype = 41 AND cs3.islive = 0 THEN cs3.spositiontaking ELSE 0 END ,
	@v152spositiontaking_42 = CASE WHEN cs3.sporttype = 152 AND cs3.bettype = 42 AND cs3.islive = 0 THEN cs3.spositiontaking ELSE 0 END ,
	@v152spositiontaking_51 = CASE WHEN cs3.sporttype = 152 AND cs3.bettype = 51 AND cs3.islive = 0 THEN cs3.spositiontaking ELSE 0 END ,
	@v152spositiontaking_52 = CASE WHEN cs3.sporttype = 152 AND cs3.bettype = 52 AND cs3.islive = 0 THEN cs3.spositiontaking ELSE 0 END ,
									   
	@v153spositiontaking_51  = CASE WHEN cs3.sporttype = 153 AND cs3.bettype = 51 AND cs3.islive = 0 THEN cs3.spositiontaking ELSE 0 END ,
	@v153spositiontaking_52  = CASE WHEN cs3.sporttype = 153 AND cs3.bettype = 52 AND cs3.islive = 0 THEN cs3.spositiontaking ELSE 0 END ,

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

SELECT @v151sdiscount_31 = MAX(CASE WHEN cs3.sporttype = 151 AND cs3.bettype = 31 THEN cs3.sdiscount ELSE 0 END),
	@v151sdiscount_41 = MAX(CASE WHEN cs3.sporttype = 151 AND cs3.bettype = 41 THEN cs3.sdiscount ELSE 0 END),
	@v151sdiscount_51 = MAX(CASE WHEN cs3.sporttype = 151 AND cs3.bettype = 51 THEN cs3.sdiscount ELSE 0 END),
	@v152sdiscount_41 = MAX(CASE WHEN cs3.sporttype = 152 AND cs3.bettype = 41 THEN cs3.sdiscount ELSE 0 END),
	@v152sdiscount_51 = MAX(CASE WHEN cs3.sporttype = 152 AND cs3.bettype = 51 THEN cs3.sdiscount ELSE 0 END),
	@v153sdiscount_51 = MAX(CASE WHEN cs3.sporttype = 153 AND cs3.bettype = 51 THEN cs3.sdiscount ELSE 0 END)
FROM Dep_CustSetting3rd AS cs3 WITH (NOLOCK)
WHERE cs3.custid = @srecommend

SELECT @v151adiscount_31 = MAX(CASE WHEN cs3.sporttype = 151 AND cs3.bettype = 31 THEN cs3.adiscount ELSE 0 END),
	@v151adiscount_41 = MAX(CASE WHEN cs3.sporttype = 151 AND cs3.bettype = 41 THEN cs3.adiscount ELSE 0 END),
	@v151adiscount_51 = MAX(CASE WHEN cs3.sporttype = 151 AND cs3.bettype = 51 THEN cs3.adiscount ELSE 0 END),
	@v152adiscount_41 = MAX(CASE WHEN cs3.sporttype = 152 AND cs3.bettype = 41 THEN cs3.adiscount ELSE 0 END),
	@v152adiscount_51 = MAX(CASE WHEN cs3.sporttype = 152 AND cs3.bettype = 51 THEN cs3.adiscount ELSE 0 END),
	@v153adiscount_51 = MAX(CASE WHEN cs3.sporttype = 153 AND cs3.bettype = 51 THEN cs3.adiscount ELSE 0 END)
FROM Dep_CustSetting3rd AS cs3 WITH (NOLOCK)
WHERE cs3.custid = @mrecommend

SELECT @v151discount_31 = MAX(CASE WHEN cs3.sporttype = 151 AND cs3.bettype = 31 THEN cs3.discount ELSE 0 END),
	@v151discount_41 = MAX(CASE WHEN cs3.sporttype = 151 AND cs3.bettype = 41 THEN cs3.discount ELSE 0 END),
	@v151discount_51 = MAX(CASE WHEN cs3.sporttype = 151 AND cs3.bettype = 51 THEN cs3.discount ELSE 0 END),
	@v152discount_41 = MAX(CASE WHEN cs3.sporttype = 152 AND cs3.bettype = 41 THEN cs3.discount ELSE 0 END),
	@v152discount_51 = MAX(CASE WHEN cs3.sporttype = 152 AND cs3.bettype = 51 THEN cs3.discount ELSE 0 END),
	@v153discount_51 = MAX(CASE WHEN cs3.sporttype = 153 AND cs3.bettype = 51 THEN cs3.discount ELSE 0 END)
FROM Dep_CustSetting3rd AS cs3 WITH (NOLOCK)
WHERE cs3.custid = @recommend

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
								
	--Racing					= --Racing
	@v151apositiontaking_31		= @v151apositiontaking_31,
	@v151apositiontaking_32		= @v151apositiontaking_32,
	@v151apositiontaking_41		= @v151apositiontaking_41,
	@v151apositiontaking_42		= @v151apositiontaking_42,
								
	@v151apositiontaking_51		= @v151apositiontaking_51,
	@v151apositiontaking_52		= @v151apositiontaking_52,
								
	@v152apositiontaking_41		= @v152apositiontaking_41,
	@v152apositiontaking_42		= @v152apositiontaking_42,
	@v152apositiontaking_51		= @v152apositiontaking_51,
	@v152apositiontaking_52		= @v152apositiontaking_52,
								
	@v153apositiontaking_51		= @v153apositiontaking_51,
	@v153apositiontaking_52		= @v153apositiontaking_52,
								
	@v161apositiontaking_81		= @v161apositiontaking_81, 
	@v161apositiontaking_83		= @v161apositiontaking_83, 
	@v161apositiontaking_86		= @v161apositiontaking_86, 
	@v161apositiontaking_88		= @v161apositiontaking_88, 
	@v161alivepositiontaking_85 = @v161alivepositiontaking_85,
	@v161alivepositiontaking_86 = @v161alivepositiontaking_86,
	@v161alivepositiontaking_87 = @v161alivepositiontaking_87,
	@v161alivepositiontaking_89 = @v161alivepositiontaking_89,
	@v161alivepositiontaking_90 = @v161alivepositiontaking_90,

	@v151discount_31			= @v151playerdiscount_31,
	@v151discount_41			= @v151playerdiscount_41,
	@v151discount_51			= @v151playerdiscount_51,
	@v152discount_41			= @v152playerdiscount_41,
	@v152discount_51			= @v152playerdiscount_51,
	@v153discount_51			= @v153playerdiscount_51,

	@isvalid=@isvalid OUTPUT,
	@errmsg=@ErrMsg OUTPUT,
	@errcode=@errcode OUTPUT,
	@language=@language
if @IsValid = 0
BEGIN
	return
END
---------------------------------------------------------------------------------------------------

select @username = rtrim(ltrim(@username))

if exists(select 1 from customer with (NOLOCK) where username = @username)
	or exists (select 1 from customer with (NOLOCK) where username2 = @username)
	or exists(select 1 from custsub with (NOLOCK) where username = @username)
BEGIN
	Select @ErrMsg = case @Language 
							when 'E' then 'This username is not available.'
							when 'CS' then N'?????.'
							when 'CT' then N'?????.'
							when 'TH' then N'?????????????????????????? ??????????????????.'
							when 'J' then N'This username is not available.'
							when 'ES' then N'This username is not available.'
							when 'KO' then N'? ??? ??? ??? ? ????'
							else N'This username is not available.'
						end,
		@ErrCode = 101		
	return
END
select @pwdexpiry = dateadd(dd, 30, getdate())

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
	@Disable151_31 = @Disable151_31,
	@Disable151_41 = @Disable151_41,
	@Disable151_51 = @Disable151_51,
	@Disable152_41 = @Disable152_41,
	@Disable152_51 = @Disable152_51,
	@Disable153_51 = @Disable153_51,
	@DisableOutright = @DisableOutright,
	@Disable162_1101 = 0,
	@DisableVirtualSports = @DisableVirtualSport,
	@matchlimit = @matchlimit,
	@virtualmultiplier = 1,
	@DisableFinancial = 0,
	@DisableCasino = 0,
	@IsInternal = 0,
	@DisableNumber = @DisableNumber,
	@DisableBingo = 0,
	@MaxPerMatch = @MaxPerMatchv1,
	@MaxPerMatchv2 = @MaxPerMatchv2,
	@MaxPerMatchv3 = @MaxPerMatchv3,
	@MaxPerMatchv5 = @MaxPerMatchv5,
	@MaxPerMatchv8 = @MaxPerMatchv8,
	@MaxPerMatchv10 = @MaxPerMatchv10,
	@MaxPerMatchv11 = @MaxPerMatchv11,
	@MaxPerMatchv99 = @MaxPerMatchv99,

	@MaxPerMatchv99MP = @MaxPerMatchv99MP,
	@MaxPerMatchv161 = @MaxPerMatchv161,	
	@MaxPerBallv161 = @MaxPerBallv161,

	@MaxPerMatchv180 = @v180MaxPerMatch,

	--v151
	@MaxPerMatchv151_31 = @v151maxpermatch_31,
	@MaxPerMatchv151_41 = @v151maxpermatch_41,
	@MaxPerMatchv151_51 = @v151maxpermatch_51,
	
	--v152
	@MaxPerMatchv152_41  = @v152maxpermatch_41,
	@MaxPerMatchv152_51 = @v152maxpermatch_51,
	
	--v153
	@MaxPerMatchv153_51 = @v153maxpermatch_51,

	@credit = 0,
	@maxcredit = 0,
	@DisableP2P = 1,
	@DisableFUNP2P = 1,
	@IP = @IP,
	@TransferOption_dec = 0,
	@Language = @Language,
	@ErrCode = @ErrCode OUTPUT,
	@ErrMsg = @ErrMsg OUTPUT

if @ErrCode <> 0
	return


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
UNION ALL	SELECT @custid, 9, 1, @v1apositiontaking_9, @v1mpositiontaking_9, @v1spositiontaking_9, 0, 0, 0, 0, @MinBetv1, @MaxBetv1, 0
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
							when 'CS' then N'???????,?????.'
							when 'CT' then N'???????,?????.'
							when 'TH' then N'??????????????????????? ????????? ?????????????????????.'
							when 'J' then N'Create customer failed. Please try again.'
							when 'ES' then N'Create customer failed. Please try again.'
							when 'KO' then N'??? ????? ??????.  ?? ???? ???? ???? ????.'
							else N'Create customer failed. Please try again.'
						end,
		@ErrCode = 114
	
	-- ROLLBACK MANUALLY
	DELETE [Dep_CustSetting] with (ROWLOCK) where custid =  @custid
	
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	return
END

--insert into CustSetting3rd
INSERT INTO [dbo].[Dep_CustSetting3rd]([custId], [bettype], [sporttype], [apositiontaking], [mpositiontaking], [spositiontaking],  [playerdiscount], [discount], [adiscount], [sdiscount], [Minbet], [Maxbet], [islive])

--v151
			SELECT @custid, 31, 151, @v151apositiontaking_31, @v151mpositiontaking_31, @v151spositiontaking_31, @v151playerdiscount_31, @v151discount_31, @v151adiscount_31, @v151sdiscount_31, @v151minbet_31, @v151maxbet_31, 0
UNION ALL	SELECT @custid, 32, 151, @v151apositiontaking_32, @v151mpositiontaking_32, @v151spositiontaking_32, @v151playerdiscount_31, @v151discount_31, @v151adiscount_31, @v151sdiscount_31, @v151minbet_31, @v151maxbet_31, 0
UNION ALL	SELECT @custid, 41, 151, @v151apositiontaking_41, @v151mpositiontaking_41, @v151spositiontaking_41, @v151playerdiscount_41,@v151discount_41, @v151adiscount_41, @v151sdiscount_41, @v151minbet_41, @v151maxbet_41, 0
UNION ALL	SELECT @custid, 42, 151, @v151apositiontaking_42, @v151mpositiontaking_42, @v151spositiontaking_42, @v151playerdiscount_41, @v151discount_41, @v151adiscount_41, @v151sdiscount_41, @v151minbet_41, @v151maxbet_41, 0
UNION ALL	SELECT @custid, 51, 151, @v151apositiontaking_51, @v151mpositiontaking_51, @v151spositiontaking_51, @v151playerdiscount_51, @v151discount_51, @v151adiscount_51, @v151sdiscount_51, @v151minbet_51, @v151maxbet_51, 0
UNION ALL	SELECT @custid, 52, 151, @v151apositiontaking_52, @v151mpositiontaking_52, @v151spositiontaking_52, @v151playerdiscount_51, @v151discount_51, @v151adiscount_51, @v151sdiscount_51, @v151minbet_51, @v151maxbet_51, 0

--v152
UNION ALL	SELECT @custid, 41, 152, @v152apositiontaking_41, @v152mpositiontaking_41, @v152spositiontaking_41, @v152playerdiscount_41, @v152discount_41, @v152adiscount_41, @v152sdiscount_41, @v152minbet_41, @v152maxbet_41, 0
UNION ALL	SELECT @custid, 42, 152, @v152apositiontaking_42, @v152mpositiontaking_42, @v152spositiontaking_42, @v152playerdiscount_41, @v152discount_41, @v152adiscount_41, @v152sdiscount_41, @v152minbet_41, @v152maxbet_41, 0
UNION ALL	SELECT @custid, 51, 152, @v152apositiontaking_51, @v152mpositiontaking_51, @v152spositiontaking_51, @v152playerdiscount_51, @v152discount_51, @v152adiscount_51, @v152sdiscount_51, @v152minbet_51, @v152maxbet_51, 0
UNION ALL	SELECT @custid, 52, 152, @v152apositiontaking_52, @v152mpositiontaking_52, @v152spositiontaking_52, @v152playerdiscount_51, @v152discount_51, @v152adiscount_51, @v152sdiscount_51, @v152minbet_51, @v152maxbet_51, 0

--v153
UNION ALL	SELECT @custid, 51, 153, @v153apositiontaking_51, @v153mpositiontaking_51, @v153spositiontaking_51, @v153playerdiscount_51, @v153discount_51, @v153adiscount_51, @v153sdiscount_51, @v153minbet_51, @v153maxbet_51, 0
UNION ALL	SELECT @custid, 52, 153, @v153apositiontaking_52, @v153mpositiontaking_52, @v153spositiontaking_52, @v153playerdiscount_51, @v153discount_51, @v153adiscount_51, @v153sdiscount_51, @v153minbet_51, @v153maxbet_51, 0

--v161
UNION ALL	SELECT @custid, 81, 161, @v161apositiontaking_81, @v161mpositiontaking_81, @v161spositiontaking_81, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 0--nonlive
UNION ALL	SELECT @custid, 83, 161, @v161apositiontaking_83, @v161mpositiontaking_83, @v161spositiontaking_83, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 0--nonlive
UNION ALL	SELECT @custid, 85, 161, @v161alivepositiontaking_85, @v161mlivepositiontaking_85, 0, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 1--live

UNION ALL	SELECT @custid, 86, 161, @v161apositiontaking_86, @v161mpositiontaking_86, @v161spositiontaking_86, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 0--nonlive
UNION ALL	SELECT @custid, 86, 161, @v161alivepositiontaking_86, @v161mlivepositiontaking_86, @v161slivepositiontaking_86, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 1--live 

UNION ALL	SELECT @custid, 87, 161, @v161alivepositiontaking_87, @v161mlivepositiontaking_87, @v161slivepositiontaking_87, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 1--live
UNION ALL	SELECT @custid, 88, 161, @v161apositiontaking_88, @v161mpositiontaking_88, @v161spositiontaking_88, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 0--nonlive
UNION ALL	SELECT @custid, 89, 161, @v161alivepositiontaking_89, @v161mlivepositiontaking_89, @v161slivepositiontaking_89, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 1--live
UNION ALL	SELECT @custid, 90, 161, @v161alivepositiontaking_90, @v161mlivepositiontaking_90, @v161slivepositiontaking_90, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 1--live

--v162
select @v162apositiontaking_1101 = apositiontaking, @v162mpositiontaking_1101 = mpositiontaking,@v162spositiontaking_1101 = spositiontaking, @v162discount_1101 = discount, @v162adiscount_1101=adiscount,@v162sdiscount_1101=sdiscount from CustSettingGame WITH(NOLOCK) where custid = @recommend and bettype = 1101 and sporttype = 162


if @@error <> 0
BEGIN
	--Error occur	
	SELECT @ErrMsg = case @Language 
							when 'E' then 'Create customer failed. Please try again.'
							when 'CS' then N'???????,?????.'
							when 'CT' then N'???????,?????.'
							when 'TH' then N'??????????????????????? ????????? ?????????????????????.'
							when 'J' then N'Create customer failed. Please try again.'
							when 'ES' then N'Create customer failed. Please try again.'
							when 'KO' then N'??? ????? ??????.  ?? ???? ???? ???? ????.'
							else N'Create customer failed. Please try again.'
						end,
		@ErrCode = 114
	
	-- ROLLBACK MANUALLY
	DELETE [Dep_CustSetting] with (ROWLOCK) where custid =  @custid
	DELETE [Dep_CustSetting3rd] with (ROWLOCK) where custid =  @custid
	
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	return
END

--Insert Into P2P Setting
INSERT INTO  dbo.P2PGAMESETTING WITH(ROWLOCK)
	(custId,bettype,StakeLevel1,StakeLevel2,StakeLevel3,StakeLevel4,StakeLevel5)
SELECT @custid  , bettype , StakeLevel1 , 0 , 0 , 0 , 0 FROM P2PGameSetting WITH(NOLOCK) WHERE custid = @recommend AND bettype = 1001
UNION ALL 
SELECT @custid  , bettype , StakeLevel1 , 0 , 0 , 0 , 0 FROM P2PGameSetting WITH(NOLOCK) WHERE custid = @recommend AND bettype = 1002


if @@error <> 0
BEGIN
	--Error occurs
	SELECT @ErrMsg = case @Language 
							when 'E' then 'Add member fail. Please try again'
							when 'CS' then N'???????,?????'
							when 'CT' then N'???????,?????'
							when 'TH' then N'??????????????????????????? ?????????????????????'
							when 'J' then N'????????????????????????????????'
							when 'ES' then N'Fallo al añadir miembro. Por favor, inténtelo de nuevo.'
							when 'KO' then N'????? ??????. ?? ??? ??? ????'
							else N'Add member fail. Please try again'
						end	
			, @ErrCode=216
	
	-- ROLLBACK MANUALLY
	Delete dep_custsetting with (ROWLOCK) where custid  =@custid
	Delete dep_CustSetting3rd with (ROWLOCK) where custid  =@custid
	DELETE P2PGameSetting WITH (ROWLOCK) WHERE custId  =@custid
		
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	return
END


INSERT INTO dbo.P2PGroupComm WITH(ROWLOCK)
           (custId,groupID,sdiscount,adiscount,discount,playerdiscount)
SELECT @custid custId
	,P2PGroupComm.groupID
	,GC_S.sdiscount
	,GC_M.adiscount
	,P2PGroupComm.discount
	,0 playerdiscount
FROM dbo.P2PGroupComm WITH(NOLOCK) 
INNER JOIN (
	SELECT groupID
		,sdiscount
	FROM dbo.P2PGroupComm WITH(NOLOCK) 
	WHERE custid = @srecommend
	) GC_S ON GC_S.GROUPID = P2PGroupComm.GROUPID
INNER JOIN (
	SELECT groupID
		,adiscount
	FROM dbo.P2PGroupComm WITH(NOLOCK) 
	WHERE custid = @mrecommend
	) GC_M ON GC_M.GROUPID = P2PGroupComm.GROUPID
WHERE custid = @recommend;

if @@error <> 0
BEGIN
	--Error occurs
	SELECT @ErrMsg = case @Language 
							when 'E' then 'Add member fail. Please try again'
							when 'CS' then N'???????,?????'
							when 'CT' then N'???????,?????'
							when 'TH' then N'??????????????????????????? ?????????????????????'
							when 'J' then N'????????????????????????????????'
							when 'ES' then N'Fallo al añadir miembro. Por favor, inténtelo de nuevo.'
							when 'KO' then N'????? ??????. ?? ??? ??? ????'
							else N'Add member fail. Please try again'
						end	
			, @ErrCode=216
	
	-- ROLLBACK MANUALLY
	Delete dep_custsetting with (ROWLOCK) where custid  =@custid
	Delete dep_CustSetting3rd with (ROWLOCK) where custid  =@custid
	DELETE P2PGameSetting WITH (ROWLOCK) WHERE custId  =@custid
	DELETE P2PGroupComm WITH (ROWLOCK) WHERE custId  =@custid
	
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	return
END

SELECT	@v162apositiontaking_1101 = CASE WHEN @UplineSyncLiveCasino = 1 THEN @v162apositiontaking_1101 ELSE 0 END,
		@v162mpositiontaking_1101 = CASE WHEN @UplineSyncLiveCasino = 1 THEN @v162mpositiontaking_1101 ELSE 0 END,
		@v162spositiontaking_1101 = CASE WHEN @UplineSyncLiveCasino = 1 THEN @v162spositiontaking_1101 ELSE 0 END,
		@v162discount_1101 = CASE WHEN @UplineSyncLiveCasino = 1 THEN @v162discount_1101 ELSE 0 END,
		@v162adiscount_1101 = CASE WHEN @UplineSyncLiveCasino = 1 THEN @v162adiscount_1101 ELSE 0 END,
		@v162sdiscount_1101 = CASE WHEN @UplineSyncLiveCasino = 1 THEN @v162sdiscount_1101 ELSE 0 END
--- insert into custsettingGame
INSERT INTO custsettingGame(CustID, Bettype, Sporttype, apositiontaking, mpositiontaking, spositiontaking, playerdiscount, discount, adiscount, sdiscount, autopositiontaking, isautopositiontaking, autompositiontaking, isautompositiontaking)
	SELECT @custid, 1101, 162, @v162apositiontaking_1101, @v162mpositiontaking_1101, @v162spositiontaking_1101, 0, @v162discount_1101, @v162adiscount_1101, @v162sdiscount_1101, 0, 0, 0, 0
		
if @@error <> 0
BEGIN

	--Error occur
	SELECT @ErrMsg = case @Language 
							when 'E' then 'Create customer failed. Please try again.'
							when 'CS' then N'???????,?????.'
							when 'CT' then N'???????,?????.'
							when 'TH' then N'??????????????????????? ????????? ?????????????????????.'
							when 'J' then N'Create customer failed. Please try again.'
							when 'ES' then N'Create customer failed. Please try again.'
							when 'KO' then N'?? ??? ??????. ?? ??? ??? ????.'
							else N'Create customer failed. Please try again.'
						end,
		@ErrCode = 210
		
	-- ROLLBACK MANUALLY
	Delete dep_custsetting with (ROWLOCK) where custid  =@custid
	Delete dep_CustSetting3rd with (ROWLOCK) where custid  =@custid
	DELETE P2PGameSetting WITH (ROWLOCK) WHERE custId  =@custid
	DELETE P2PGroupComm WITH (ROWLOCK) WHERE custId  =@custid
	DELETE custsettingGame WITH (ROWLOCK) WHERE custId  =@custid
		
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	RETURN
END

EXEC Acc_Dep_CustomerInsMemberVirtualSports_Ag
	@custid = @custid,
	@recommend = @recommend,

	@v180aPositionTaking = @v180aPositionTaking,
	
	@v180MinBet = @v180MinBet,
	@v180MaxBet = @v180MaxBet,
	
	@ErrCode = @ErrCode OUTPUT,
	@Language = @Language,
	@ErrMsg = @ErrMsg OUTPUT

IF @ErrCode <> 0 
BEGIN
	
	DELETE dep_custsetting with (ROWLOCK) where custid  =@custid
	DELETE dep_CustSetting3rd with (ROWLOCK) where custid  =@custid
	DELETE P2PGameSetting WITH (ROWLOCK) WHERE custId  =@custid
	DELETE P2PGroupComm WITH (ROWLOCK) WHERE custId  =@custid
	DELETE custsettingGame WITH (ROWLOCK) WHERE custId  =@custid
		
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	RETURN
END

--Exclude created member from Balance checking
INSERT INTO dbo.Task_Cust_CheckBalance_Exception(custid, remark) values(@custid, @username)
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

Declare @LogSPData varchar(4000)
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
	
--Log commission
SELECT @LogSPData = '<Acc_Dep_CustomerInsMember_Ag custid="'+ COALESCE(CAST(@custid AS VARCHAR(50)),SPACE(1)) + '" ' +
'v151discount_31="'+ COALESCE(CAST(@v151playerdiscount_31 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v151discount_41="'+ COALESCE(CAST(@v151playerdiscount_41 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v151discount_51="'+ COALESCE(CAST(@v151playerdiscount_51 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v152discount_41="'+ COALESCE(CAST(@v152playerdiscount_41 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v152discount_51="'+ COALESCE(CAST(@v152playerdiscount_51 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v153discount_51="'+ COALESCE(CAST(@v153playerdiscount_51 AS VARCHAR(50)),SPACE(1)) + '" />'
EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP 
	@UserID = @Creator,
	@CustID = @CustID,
	@ActionID = 2604,
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
'MinBv99MP="'+ coalesce(cast(@minbetv99mp as varchar(50)),space(1)) + '" ' +
'MaxBv99MP="'+ coalesce(cast(@maxbetv99mp as varchar(50)),space(1)) + '" ' +
'MPM99MP="'+ coalesce(cast(@maxpermatchv99mp as varchar(50)),space(1)) + '" ' +
'MinBv161="' + coalesce(cast(@minbetv161 as varchar(50)),space(1)) + '" ' +
'MaxBv161="' + coalesce(cast(@maxbetv161 as varchar(50)),space(1)) + '" ' +
'MPMv161="' + coalesce(cast(@maxpermatchv161 as varchar(50)),space(1)) + '" ' +
'MPBv161="' + coalesce(cast(@maxperballv161 as varchar(50)), space(1)) + '" ' +
'MinBv151_31="'+ COALESCE(CAST(@v151minbet_31 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv151_31="'+ COALESCE(CAST(@v151maxbet_31 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv151_31="'+ COALESCE(CAST(@v151maxpermatch_31 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MinBv151_41="'+ COALESCE(CAST(@v151minbet_41 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv151_41="'+ COALESCE(CAST(@v151maxbet_41 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv151_41="'+ COALESCE(CAST(@v151maxpermatch_41 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MinBv151_51="'+ COALESCE(CAST(@v151minbet_31 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv151_51="'+ COALESCE(CAST(@v151maxbet_31 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv151_51="'+ COALESCE(CAST(@v151maxpermatch_31 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MinBv152_41="'+ COALESCE(CAST(@v152minbet_41 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv152_41="'+ COALESCE(CAST(@v152maxbet_41 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv152_41="'+ COALESCE(CAST(@v152maxpermatch_41 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MinBv152_51="'+ COALESCE(CAST(@v152minbet_51 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv152_51="'+ COALESCE(CAST(@v152maxbet_51 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv152_51="'+ COALESCE(CAST(@v152maxpermatch_51 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MinBv153_51="'+ COALESCE(CAST(@v153minbet_51 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv153_51="'+ COALESCE(CAST(@v153maxbet_51 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv153_51="'+ COALESCE(CAST(@v153maxpermatch_51 AS VARCHAR(50)),SPACE(1)) + '" ' +

'MinBv180="'+ COALESCE(CAST(@v180MinBet AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv180="'+ COALESCE(CAST(@v180MaxBet AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv180="'+ COALESCE(CAST(@v180MaxPerMatch AS VARCHAR(50)),SPACE(1)) + '" />'
EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP 
	@UserID = @Creator,
	@CustID = @CustID,
	@ActionID = 2008,
	@TrackingValue = @LogSPData,
	@duration = @duration
 
--Log Status
Select @LogSPData = '<Acc_Dep_CustomerInsMember_Ag custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +
'closed="'+ coalesce(cast(@UplineClosed as varchar(1)),space(1)) + '" ' +
'DisableHorseRacing="'+ coalesce(cast(@Disable151_31 as varchar(1)),space(1)) + '" ' +
'DisableOT="'+ coalesce(cast(@Disable151_41 as varchar(1)),space(1)) + '" ' +
'Disable151_51="'+ coalesce(cast(@Disable151_51 as varchar(1)),space(1)) + '" ' +
'Disable152_41="'+ coalesce(cast(@Disable152_41 as varchar(1)),space(1)) + '" ' +
'Disable152_51="'+ coalesce(cast(@Disable152_51 as varchar(1)),space(1)) + '" ' +
'Disable153_51="'+ coalesce(cast(@Disable153_51 as varchar(1)),space(1)) + '" ' +
'DisableOutright="'+ coalesce(cast(@DisableOutright as varchar(1)),space(1)) + '" ' +
'DisableVirtualSports="'+ coalesce(cast(@DisableVirtualSport as varchar(1)),space(1)) + '" ' +
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

'v161spt_81="'+ COALESCE(CAST(@v161spositiontaking_81 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v161spt_83="'+ COALESCE(CAST(@v161spositiontaking_83 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v161spt_86="'+ COALESCE(CAST(@v161spositiontaking_86 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v161spt_88="'+ COALESCE(CAST(@v161spositiontaking_88 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v161slivept_85="'+ COALESCE(CAST(@v161slivepositiontaking_85 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v161slivept_86="'+ COALESCE(CAST(@v161slivepositiontaking_86 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v161slivept_87="'+ COALESCE(CAST(@v161slivepositiontaking_87 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v161slivept_89="'+ COALESCE(CAST(@v161slivepositiontaking_89 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v161slivept_90="'+ COALESCE(CAST(@v161slivepositiontaking_90 AS VARCHAR(50)),SPACE(1)) + '" ' +

'v151spt_31="'+ COALESCE(CAST(@v151spositiontaking_31 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v151spt_32="'+ COALESCE(CAST(@v151spositiontaking_32 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v151spt_41="'+ COALESCE(CAST(@v151spositiontaking_41 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v151spt_42="'+ COALESCE(CAST(@v151spositiontaking_42 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v151spt_51="'+ COALESCE(CAST(@v151spositiontaking_51 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v151spt_52="'+ COALESCE(CAST(@v151spositiontaking_52 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v152spt_41="'+ COALESCE(CAST(@v152spositiontaking_41 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v152spt_42="'+ COALESCE(CAST(@v152spositiontaking_42 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v152spt_51="'+ COALESCE(CAST(@v152spositiontaking_51 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v152spt_52="'+ COALESCE(CAST(@v152spositiontaking_52 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v153spt_51="'+ COALESCE(CAST(@v153spositiontaking_51 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v153spt_52="'+ COALESCE(CAST(@v153spositiontaking_52 AS VARCHAR(50)),SPACE(1)) + '" />' +


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

'v161mpt_81="'+ COALESCE(CAST(@v161mpositiontaking_81 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v161mpt_83="'+ COALESCE(CAST(@v161mpositiontaking_83 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v161mpt_86="'+ COALESCE(CAST(@v161mpositiontaking_86 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v161mpt_88="'+ COALESCE(CAST(@v161mpositiontaking_88 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v161mlivept_85="'+ COALESCE(CAST(@v161mlivepositiontaking_85 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v161mlivept_86="'+ COALESCE(CAST(@v161mlivepositiontaking_86 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v161mlivept_87="'+ COALESCE(CAST(@v161mlivepositiontaking_87 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v161mlivept_89="'+ COALESCE(CAST(@v161mlivepositiontaking_89 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v161mlivept_90="'+ COALESCE(CAST(@v161mlivepositiontaking_90 AS VARCHAR(50)),SPACE(1)) + '" ' +

'v151mpt_31="'+ COALESCE(CAST(@v151mpositiontaking_31 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v151mpt_32="'+ COALESCE(CAST(@v151mpositiontaking_32 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v151mpt_41="'+ COALESCE(CAST(@v151mpositiontaking_41 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v151mpt_42="'+ COALESCE(CAST(@v151mpositiontaking_42 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v151mpt_51="'+ COALESCE(CAST(@v151mpositiontaking_51 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v151mpt_52="'+ COALESCE(CAST(@v151mpositiontaking_52 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v152mpt_41="'+ COALESCE(CAST(@v152mpositiontaking_41 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v152mpt_42="'+ COALESCE(CAST(@v152mpositiontaking_42 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v152mpt_51="'+ COALESCE(CAST(@v152mpositiontaking_51 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v152mpt_52="'+ COALESCE(CAST(@v152mpositiontaking_52 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v153mpt_51="'+ COALESCE(CAST(@v153mpositiontaking_51 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v153mpt_52="'+ COALESCE(CAST(@v153mpositiontaking_52 AS VARCHAR(50)),SPACE(1)) + 
'" />' +

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

'v161apt_81="'+ COALESCE(CAST(@v161apositiontaking_81 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v161apt_83="'+ COALESCE(CAST(@v161apositiontaking_83 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v161apt_86="'+ COALESCE(CAST(@v161apositiontaking_86 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v161apt_88="'+ COALESCE(CAST(@v161apositiontaking_88 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v161alivept_85="'+ COALESCE(CAST(@v161alivepositiontaking_85 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v161alivept_86="'+ COALESCE(CAST(@v161alivepositiontaking_86 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v161alivept_87="'+ COALESCE(CAST(@v161alivepositiontaking_87 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v161alivept_89="'+ COALESCE(CAST(@v161alivepositiontaking_89 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v161alivept_90="'+ COALESCE(CAST(@v161alivepositiontaking_90 AS VARCHAR(50)),SPACE(1)) + '" ' +

'v151apt_31="'+ COALESCE(CAST(@v151apositiontaking_31 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v151apt_32="'+ COALESCE(CAST(@v151apositiontaking_32 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v151apt_41="'+ COALESCE(CAST(@v151apositiontaking_41 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v151apt_42="'+ COALESCE(CAST(@v151apositiontaking_42 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v151apt_51="'+ COALESCE(CAST(@v151apositiontaking_51 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v151apt_52="'+ COALESCE(CAST(@v151apositiontaking_52 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v152apt_41="'+ COALESCE(CAST(@v152apositiontaking_41 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v152apt_42="'+ COALESCE(CAST(@v152apositiontaking_42 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v152apt_51="'+ COALESCE(CAST(@v152apositiontaking_51 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v152apt_52="'+ COALESCE(CAST(@v152apositiontaking_52 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v153apt_51="'+ COALESCE(CAST(@v153apositiontaking_51 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v153apt_52="'+ COALESCE(CAST(@v153apositiontaking_52 AS VARCHAR(50)),SPACE(1)) + '" '+
'v180apt="'+ COALESCE(CAST(@v180aPositionTaking AS VARCHAR(50)),SPACE(1)) + '" />'+
'</Acc_Dep_CustomerInsMember_Ag>' 

--Log positiontaking
EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP 
	@UserID = @Creator,
	@CustID = @CustID,
	@ActionID = 2704,
	@TrackingValue = @LogSPData,
	@duration = @duration
GO
GRANT EXECUTE ON [dbo].[Acc_Dep_CustomerInsMember_Ag] TO [bodbAdminNet]
GO
GRANT EXECUTE ON [dbo].[Acc_Dep_CustomerInsMember_Ag] TO [bodbDownlineNet]
GO
GRANT EXECUTE ON [dbo].[Acc_Dep_CustomerInsMember_Ag] TO [bodbExtAccNet]
GO
GRANT VIEW DEFINITION ON [dbo].[Acc_Dep_CustomerInsMember_Ag] TO [vnteam]