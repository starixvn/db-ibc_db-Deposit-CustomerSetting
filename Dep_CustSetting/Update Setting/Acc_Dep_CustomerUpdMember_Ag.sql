ALTER PROCEDURE [dbo].[Acc_Dep_CustomerUpdMember_Ag]
	@custid int,-- MemberID
	
	@minbetv1 money,
	@maxbetv1 money,
	@maxpermatchv1 money,
	
	@minbetv2 money,
	@maxbetv2 money,
	@maxpermatchv2 money,
	
	@minbetv3 money,
	@maxbetv3 money,
	@maxpermatchv3 money,
	
	@minbetv5 money,
	@maxbetv5 money,
	@maxpermatchv5 money,
	
	@minbetv8 money,
	@maxbetv8 money,
	@maxpermatchv8 money,
	
	@minbetv10 money,
	@maxbetv10 money,
	@maxpermatchv10 money,
	
	@minbetv11 money,
	@maxbetv11 money,
	@maxpermatchv11 money,
	
	@minbetv44 money,
	@maxbetv44 money,
	@maxpermatchv44 money,
	
	@minbetv99 money,
	@maxbetv99 money,
	@maxpermatchv99 money,	

	@minbetv154 money,
	@maxbetv154 money,
	@maxpermatchv154 money,	
	
	@minbetv99MP money,
	@maxbetv99MP money,
	@maxpermatchv99MP money,	
	
	@minbetv161 money,
	@maxbetv161 money,
	@maxpermatchv161 money,	
	
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
	
	@v44apositiontaking_3 smallmoney,
	
	@v99apositiontaking_1 smallmoney,
	@v99apositiontaking_2 smallmoney,
	@v99apositiontaking_3 smallmoney,
	@v99apositiontaking_20 smallmoney,

	@v154apositiontaking_20 smallmoney,
	
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
	
	@v44mpositiontaking_3 smallmoney,
	
	@v99mpositiontaking_1 smallmoney,
	@v99mpositiontaking_2 smallmoney,
	@v99mpositiontaking_3 smallmoney,
	@v99mpositiontaking_20 smallmoney,

	@v154mpositiontaking_20 smallmoney,
	
	--Racing
	@v151mpositiontaking_31 smallmoney = 0,
	@v151mpositiontaking_32 smallmoney = 0,
	@v151mpositiontaking_41 smallmoney = 0,
	@v151mpositiontaking_42 smallmoney = 0,

	@v151mpositiontaking_51 smallmoney = 0,
	@v151mpositiontaking_52 smallmoney = 0,

	@v152mpositiontaking_41 smallmoney = 0,
	@v152mpositiontaking_42 smallmoney = 0,
	@v152mpositiontaking_51 smallmoney = 0,
	@v152mpositiontaking_52 smallmoney = 0,

	@v153mpositiontaking_51 smallmoney = 0,
	@v153mpositiontaking_52 smallmoney = 0,

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
	
	@v1spositiontaking_1 SMALLMONEY,
	@v1spositiontaking_2 SMALLMONEY,
	@v1spositiontaking_3 SMALLMONEY,
	@v1spositiontaking_4 SMALLMONEY,
	@v1spositiontaking_5 SMALLMONEY,
	@v1spositiontaking_6 SMALLMONEY,
	@v1spositiontaking_7 SMALLMONEY,
	@v1spositiontaking_8 SMALLMONEY,
	@v1spositiontaking_9 SMALLMONEY,
	@v1spositiontaking_10 SMALLMONEY,
	
	@v1slivepositiontaking_1 SMALLMONEY,
	@v1slivepositiontaking_3 SMALLMONEY,
	@v1slivepositiontaking_7 SMALLMONEY,
	@v1slivepositiontaking_8 SMALLMONEY,
	
	@v2spositiontaking_1 SMALLMONEY,
	@v2spositiontaking_2 SMALLMONEY,
	@v2spositiontaking_3 SMALLMONEY,
	@v2spositiontaking_7 SMALLMONEY,
	@v2spositiontaking_8 SMALLMONEY,
	@v2spositiontaking_20 SMALLMONEY,
	
	@v3spositiontaking_1 SMALLMONEY,
	@v3spositiontaking_2 SMALLMONEY,
	@v3spositiontaking_3 SMALLMONEY,
	@v3spositiontaking_20 SMALLMONEY,

	@v5spositiontaking_1 SMALLMONEY,
	@v5spositiontaking_2 SMALLMONEY,
	@v5spositiontaking_3 SMALLMONEY,
	@v5spositiontaking_20 SMALLMONEY,

	@v8spositiontaking_1 SMALLMONEY,
	@v8spositiontaking_3 SMALLMONEY,
	@v8spositiontaking_20 SMALLMONEY,

	@v10spositiontaking_1 SMALLMONEY,
	@v10spositiontaking_2 SMALLMONEY,
	@v10spositiontaking_3 SMALLMONEY,
	@v10spositiontaking_20 SMALLMONEY,

	@v11spositiontaking_1 SMALLMONEY,
	@v11spositiontaking_20 SMALLMONEY,
	
	@v44spositiontaking_3 SMALLMONEY,
	
	@v99spositiontaking_1 SMALLMONEY,
	@v99spositiontaking_2 SMALLMONEY,
	@v99spositiontaking_3 SMALLMONEY,
	@v99spositiontaking_9 SMALLMONEY,
	@v99spositiontaking_20 SMALLMONEY,

	@v154spositiontaking_20 SMALLMONEY,
	
	--v161
	@v161spositiontaking_81 SMALLMONEY,
	@v161spositiontaking_83 SMALLMONEY,
	@v161spositiontaking_86 SMALLMONEY,
	@v161spositiontaking_88 SMALLMONEY = 0,
	@v161slivepositiontaking_85 SMALLMONEY,
	@v161slivepositiontaking_86 SMALLMONEY,
	@v161slivepositiontaking_87 SMALLMONEY,	
	@v161slivepositiontaking_89 SMALLMONEY = 0,
	@v161slivepositiontaking_90 SMALLMONEY = 0,
	
	--Racing
	@v151spositiontaking_31 smallmoney = 0,
	@v151spositiontaking_32 smallmoney = 0,
	@v151spositiontaking_41 smallmoney = 0,
	@v151spositiontaking_42 smallmoney = 0,

	@v151spositiontaking_51 smallmoney = 0,
	@v151spositiontaking_52 smallmoney = 0,

	@v152spositiontaking_41 smallmoney = 0,
	@v152spositiontaking_42 smallmoney = 0,
	@v152spositiontaking_51 smallmoney = 0,
	@v152spositiontaking_52 smallmoney = 0,

	@v153spositiontaking_51 smallmoney = 0,
	@v153spositiontaking_52 smallmoney = 0,


	--Horse Racing Commission
	@v151discount_31 decimal(9,8) = 0,	
	@v151discount_41 decimal(9,8) = 0,

	@v151discount_51 decimal(9,8) = 0,
	@v152discount_41 decimal(9,8) = 0,
	@v152discount_51 decimal(9,8) = 0,
	@v153discount_51 decimal(9,8) = 0,
	
	
	
	--Virtual Sports----------------
	@VirtualSportList VARCHAR(4000)='', -- replace all old params
	--Keno Sports----------------
	@KenoList VARCHAR(4000)='',

	
	@UserID int = 0,	
	@Language varchar(2) = 'E',
	@IP varchar(15)='',
	@ErrCode int = 0 OUTPUT,
	@ErrMsg nvarchar(4000) = '' OUTPUT
 AS
 /*
Created:
Task : 
DB: DBTrans.bodb02

Revisions:
    - 20121128@Elodie: Get an error message from f_Get_MsgNameByMsgID function by language
	- 20130918@Don: Supporting save log of Number Game PT with format such as "0.995", "0.925", ...
	- 20131014@Francis: Support updating virtual sports with settings via XML param
	- 20131108@Elodie: Splitting bodb02 into CustDB (call sports, bettype by link database)	
    - 20140505@Florent: Add new Sport HRFO
	- 20140512@Florent: Add sport Keno 202
	- 20150609@David: Separate CustDB to DBCUST server (Use temp table for sports, bettype, GameType table, call some SPs by link server)
	- 20151028@Jim:Implement Muay's Setting for Deposit Customer [Redmine: #45491]
Param's Explanation:
• @ErrCode:
    = 0: Update successfully.
    > 0: Specific Error.
  
• @ErrMsg: Error description.
• @VirtualSportList: VirtualSport Settings XML param.
*/ 
 SET NOCOUNT ON
----- David @ 09 JUN 2015 -------------------
	DECLARE @tmp_Sports TABLE (SportType TINYINT, SportName NVARCHAR(50))
	DECLARE @tmp_Bettype TABLE (TypeID INT, TypeNamee NVARCHAR(50))
	DECLARE @tmp_GameType TABLE (GameTypeID INT, GameTypeName NVARCHAR(50), IsDisabled BIT, IBCBettypeID INT)

	BEGIN TRY
		INSERT INTO @tmp_Sports (SportType, SportName)
		SELECT SportType, SportName FROM DBAGE.bodb02.dbo.Sports WITH (NOLOCK)		
	END TRY
	BEGIN CATCH
		INSERT INTO @tmp_Sports (SportType, SportName)
		SELECT SportType, SportName FROM DBTXN.bodb02.dbo.Sports WITH (NOLOCK)	
	END CATCH

	BEGIN TRY			
		INSERT INTO @tmp_Bettype (TypeID, TypeNamee)
		SELECT TypeID, TypeNamee FROM DBAGE.bodb02.dbo.Bettype WITH (NOLOCK)
	END TRY
	BEGIN CATCH		
		INSERT INTO @tmp_Bettype (TypeID, TypeNamee)
		SELECT TypeID, TypeNamee FROM DBTXN.bodb02.dbo.Bettype WITH (NOLOCK)
	END CATCH

	BEGIN TRY		
		INSERT INTO @tmp_GameType (GameTypeID, GameTypeName, IsDisabled, IBCBettypeID)
		SELECT GameTypeID, GameTypeName, IsDisabled, IBCBettypeID FROM DBAGE.bodb02.dbo.GameType WITH (NOLOCK)
	END TRY
	BEGIN CATCH		
		INSERT INTO @tmp_GameType (GameTypeID, GameTypeName, IsDisabled, IBCBettypeID)
		SELECT GameTypeID, GameTypeName, IsDisabled, IBCBettypeID FROM DBTXN.bodb02.dbo.GameType WITH (NOLOCK)
	END CATCH
----- /David @ 09 JUN 2015 -------------------
declare @startRun datetime
declare @endRun datetime
declare @duration int
set @startRun = getdate()


--------Parse xml string into table
DECLARE @iDoc int
EXEC sp_xml_preparedocument @iDoc OUTPUT, @VirtualSportList

SELECT *
INTO #input
FROM OPENXML (@iDoc, '/products/product',1) WITH(SportType tinyint, MaxBet money, MinBet money, MaxPerMatch money, 
sPositionTaking smallmoney, mPositionTaking smallmoney, aPositionTaking smallmoney)

EXEC sp_xml_removedocument @iDoc


----------DECLARE AND SELECT INTO PARAMS
DECLARE @v180MinBet MONEY,
	@v180MaxBet MONEY,
	@v180MaxPerMatch MONEY,
	@v180sPositionTaking SMALLMONEY,
	@v180mPositionTaking SMALLMONEY,
	@v180aPositionTaking SMALLMONEY

SELECT @v180MinBet = isnull(MinBet,0), @v180MaxBet = isnull(MaxBet,0), @v180MaxPerMatch = isnull(MaxPerMatch,0), @v180sPositionTaking = isnull(sPositionTaking,0), @v180mPositionTaking = isnull(mPositionTaking,0), @v180aPositionTaking = isnull(aPositionTaking,0)
FROM #input
WHERE SportType = 180

DECLARE @v181MinBet MONEY,
	@v181MaxBet MONEY,
	@v181MaxPerMatch MONEY,
	@v181sPositionTaking SMALLMONEY,
	@v181mPositionTaking SMALLMONEY,
	@v181aPositionTaking SMALLMONEY

SELECT @v181MinBet = isnull(MinBet,0), @v181MaxBet = isnull(MaxBet,0), @v181MaxPerMatch = isnull(MaxPerMatch,0), @v181sPositionTaking = isnull(sPositionTaking,0), @v181mPositionTaking = isnull(mPositionTaking,0), @v181aPositionTaking = isnull(aPositionTaking,0)
FROM #input
WHERE SportType = 181

DECLARE @v182MinBet MONEY,
	@v182MaxBet MONEY,
	@v182MaxPerMatch MONEY,
	@v182sPositionTaking SMALLMONEY,
	@v182mPositionTaking SMALLMONEY,
	@v182aPositionTaking SMALLMONEY

SELECT @v182MinBet = isnull(MinBet,0), @v182MaxBet = isnull(MaxBet,0), @v182MaxPerMatch = isnull(MaxPerMatch,0), @v182sPositionTaking = isnull(sPositionTaking,0), @v182mPositionTaking = isnull(mPositionTaking,0), @v182aPositionTaking = isnull(aPositionTaking,0)
FROM #input
WHERE SportType = 182

DECLARE @v183MinBet MONEY,
	@v183MaxBet MONEY,
	@v183MaxPerMatch MONEY,
	@v183sPositionTaking SMALLMONEY,
	@v183mPositionTaking SMALLMONEY,
	@v183aPositionTaking SMALLMONEY

SELECT @v183MinBet = isnull(MinBet,0), @v183MaxBet = isnull(MaxBet,0), @v183MaxPerMatch = isnull(MaxPerMatch,0), @v183sPositionTaking = isnull(sPositionTaking,0), @v183mPositionTaking = isnull(mPositionTaking,0), @v183aPositionTaking = isnull(aPositionTaking,0)
FROM #input
WHERE SportType = 183

DECLARE @v184MinBet MONEY,
	@v184MaxBet MONEY,
	@v184MaxPerMatch MONEY,
	@v184sPositionTaking SMALLMONEY,
	@v184mPositionTaking SMALLMONEY,
	@v184aPositionTaking SMALLMONEY

SELECT @v184MinBet = isnull(MinBet,0), @v184MaxBet = isnull(MaxBet,0), @v184MaxPerMatch = isnull(MaxPerMatch,0), @v184sPositionTaking = isnull(sPositionTaking,0), @v184mPositionTaking = isnull(mPositionTaking,0), @v184aPositionTaking = isnull(aPositionTaking,0)
FROM #input
WHERE SportType = 184

DECLARE @v185MinBet MONEY,
	@v185MaxBet MONEY,
	@v185MaxPerMatch MONEY,
	@v185sPositionTaking SMALLMONEY,
	@v185mPositionTaking SMALLMONEY,
	@v185aPositionTaking SMALLMONEY

SELECT @v185MinBet = isnull(MinBet,0), @v185MaxBet = isnull(MaxBet,0), @v185MaxPerMatch = isnull(MaxPerMatch,0), @v185sPositionTaking = isnull(sPositionTaking,0), @v185mPositionTaking = isnull(mPositionTaking,0), @v185aPositionTaking = isnull(aPositionTaking,0)
FROM #input
WHERE SportType = 185

DECLARE @v186MinBet MONEY,
	@v186MaxBet MONEY,
	@v186MaxPerMatch MONEY,
	@v186sPositionTaking SMALLMONEY,
	@v186mPositionTaking SMALLMONEY,
	@v186aPositionTaking SMALLMONEY

SELECT @v186MinBet = isnull(MinBet,0), @v186MaxBet = isnull(MaxBet,0), @v186MaxPerMatch = isnull(MaxPerMatch,0), @v186sPositionTaking = isnull(sPositionTaking,0), @v186mPositionTaking = isnull(mPositionTaking,0), @v186aPositionTaking = isnull(aPositionTaking,0)
FROM #input
WHERE SportType = 186


DROP TABLE #input
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------Parse xml string into table -- Keno
DECLARE @xmlDoc int
EXEC sp_xml_preparedocument @xmlDoc OUTPUT, @KenoList

SELECT *
INTO #data
FROM OPENXML (@xmlDoc, '/products/product',1) WITH(BetType INT, MaxBet money, MinBet money, MaxPerMatch money, 
sPositionTaking smallmoney, mPositionTaking smallmoney, aPositionTaking smallmoney,isDisable BIT)

EXEC sp_xml_removedocument @xmlDoc
--backup old data
CREATE Table #data_old 
	(	Custid INT,
		Sporttype INT,
		Bettype INT,
		islive tinyINT,
		MinB	Money,
		MaxB	Money,
		MPM		Money,
		MPB		Money,
		spt		Money,
		mpt		Money,
		apt		Money,
		SupRBDiscount Money,
		MastRBDiscount Money,
		AgRBDiscount Money
	)
	INSERT INTO #data_old (Custid,Sporttype,Bettype ,islive,MinB,MaxB,MPM,MPB,spt,mpt,apt,SupRBDiscount,MastRBDiscount,	AgRBDiscount)
	EXEC dbo.Acc_Dep_CustomerSelInfo @Custid
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



Declare 
	@MinMinBetv1 money, @MaxMaxBetv1 money,	@MaxMaxPerMatchv1 money,
	@MinMinBetv2 money, @MaxMaxBetv2 money, @MaxMaxPerMatchv2 money,
	@MinMinBetv3 money, @MaxMaxBetv3 money, @MaxMaxPerMatchv3 money,
	@MinMinBetv5 money, @MaxMaxBetv5 money, @MaxMaxPerMatchv5 money,
	@MinMinBetv8 money, @MaxMaxBetv8 money, @MaxMaxPerMatchv8 money,
	@MinMinBetv10 money, @MaxMaxBetv10 money, @MaxMaxPerMatchv10 money,
	@MinMinBetv11 money, @MaxMaxBetv11 money, @MaxMaxPerMatchv11 money,
	@MinMinBetv44 money, @MaxMaxBetv44 money, @MaxMaxPerMatchv44 money,
	@MinMinBetv99 money, @MaxMaxBetv99 money, @MaxMaxPerMatchv99 money,
	@MinMinBetv154 money, @MaxMaxBetv154 money, @MaxMaxPerMatchv154 money,
	@MinMinBetv99MP money, @MaxMaxBetv99MP money, @MaxMaxPerMatchv99MP money,
	@MinMinBetv161 money, @MaxMaxBetv161 money, @MaxMaxPerMatchv161 money,
	@MaxMaxPerBallv161 money,
	
	@v151MinMinBet_31 money, @v151MaxMaxBet_31 money, @v151MaxMaxPerMatch_31 money,
	@v151MinMinBet_41 money, @v151MaxMaxBet_41 money, @v151MaxMaxPerMatch_41 money,
	@v151MinMinBet_51 money, @v151MaxMaxBet_51 money, @v151MaxMaxPerMatch_51 money,
	@v152MinMinBet_41 money, @v152MaxMaxBet_41 money, @v152MaxMaxPerMatch_41 money,
	@v152MinMinBet_51 money, @v152MaxMaxBet_51 money, @v152MaxMaxPerMatch_51 money,
	@v153MinMinBet_51 money, @v153MaxMaxBet_51 money, @v153MaxMaxPerMatch_51 money

declare @ErrAcc varchar(4000), @ErrType varchar(4000),
		@UserName varchar(30), @recommend int

SELECT @UserName = username, @recommend = recommend
FROM customer WITH (NOLOCK)
WHERE CustID = @CustID

if 
	@MinBetv1<0
	or @MaxBetv1 < 0
	or @MaxPerMatchv1 <0		
BEGIN
	SELECT @ErrCode = 2
	SELECT @ErrMsg = 	case @Language 
						when 'E' then 'Wrong Min bet/ Max bet/ Max per match (for Soccer).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10003,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](1,@Language) + ')'
				END
	RETURN
END

if 
	@MinBetv2 <0
	or @MaxBetv2 <0
	or @MaxPerMatchv2 <0		
BEGIN
	select @ErrCode = 3
	Select @ErrMsg = 	case @Language 
						when 'E' then 'Wrong Min bet/ Max bet/ Max per match (for Basketball).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10003,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](2,@Language) + ')'
				end
	return
END

if 
	@MinBetv3 <0
	or @MaxBetv3 <0
	or @MaxPerMatchv3 <0		
BEGIN
	select @ErrCode = 4
	Select @ErrMsg = 	case @Language 
						when 'E' then 'Wrong Min bet/ Max bet/ Max per match (for Football).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10003,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](3,@Language) + ')'
				end
	return
END

if 
	@MinBetv5 <0
	or @MaxBetv5 <0
	or @MaxPerMatchv5 <0		
BEGIN
	select @ErrCode = 5
	Select @ErrMsg = 	case @Language 
						when 'E' then 'Wrong Min bet/ Max bet/ Max per match (for Tennis).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10003,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](5,@Language) + ')'
				end
	return
END

if 
	@MinBetv8 <0
	or @MaxBetv8 <0
	or @MaxPerMatchv8 <0		
BEGIN
	select @ErrCode = 6
	Select @ErrMsg = 	case @Language 
						when 'E' then 'Wrong Min bet/ Max bet/ Max per match (for Baseball).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10003,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](8,@Language) + ')'
				end
	return
END

if 
	@MinBetv10 <0
	or @MaxBetv10 <0
	or @MaxPerMatchv10 <0		
BEGIN
	select @ErrCode = 7
	Select @ErrMsg = 	case @Language 
						when 'E' then 'Wrong Min bet/ Max bet/ Max per match (for Golf).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10003,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](10,@Language) + ')'
				end
	return
END

if 
	@MinBetv11 <0
	or @MaxBetv11 <0
	or @MaxPerMatchv11 <0		
BEGIN
	select @ErrCode = 8
	Select @ErrMsg = 	case @Language 
						when 'E' then 'Wrong Min bet/ Max bet/ Max per match (for Motorsports).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10003,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](11,@Language) + ')'
				end
	return
END

if 
	@MinBetv44 <0
	or @MaxBetv44 <0
	or @MaxPerMatchv44 <0		
BEGIN
	select @ErrCode = 8
	Select @ErrMsg = 	case @Language 
						when 'E' then 'Wrong Min bet/ Max bet/ Max per match (for Muay Thai).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10003,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](44,@Language) + ')'
				end
	return
END

if 
	@MinBetv99 <0
	or @MaxBetv99 <0
	or @MaxPerMatchv99 <0		
BEGIN
	select @ErrCode = 9
	Select @ErrMsg = 	case @Language 
						when 'E' then 'Wrong Min bet/ Max bet/ Max per match (for Other sports).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10003,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](99,@Language) + ')'
				end
	return
END

if 
	@MinBetv154 <0
	or @MaxBetv154 <0
	or @MaxPerMatchv154 <0		
BEGIN
	select @ErrCode = 9
	Select @ErrMsg = 	case @Language 
						when 'E' then 'Wrong Min bet/ Max bet/ Max per match (for Other sports).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10003,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](154,@Language) + ')'
				end
	return
END


if 
	@MinBetv99MP <0
	or @MaxBetv99MP <0
	or @MaxPerMatchv99MP <0		
BEGIN
	select @ErrCode = 10
	Select @ErrMsg = 	case @Language 
						when 'E' then 'Wrong Min bet/ Max bet/ Max per match (for Mix Sports Parlay).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10003,@Language) + case @Language 
																							when 'CS' then N'(供混合体育过关)'
																							when 'CT' then N'(供混合體育過關)'
																							when 'TH' then N'(สำหรับกีฬาบอลชุด)'
																							when 'J' then N'(Mix Sports Parlay)'
																							when 'KO' then N'(Mix Sports Parlay)'
																							when 'VI' then N'(Mix Sports Parlay)'
																							else N'(Mix Sports Parlay)' END
				end
	return
END

if 
	@MinBetv161 <0
	or @MaxBetv161 <0
	or @MaxPerMatchv161 <0		
BEGIN
	select @ErrCode = 11
	Select @ErrMsg = 	case @Language 
						when 'E' then 'Wrong Min bet/ Max bet/ Max per match (for Number Game).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10003,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](161,@Language) + ')'
				end
	return
END

if @MaxPerBallv161 < 0
	begin		
		select @ErrCode = 12
		Select @ErrMsg = 	case @Language 
					when 'E' then 'Wrong Max Per Ball (Number Game).'
					ELSE [dbo].[f_Get_MsgNamebyMsgID](10002,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](161,@Language) + ')'
			end
		return		
	end

Select
	@MinMinBetv1 = Max(case when MinBet = 0 then NULL else MinBet end), 
	@MaxMaxBetv1 = Min(case when MaxBet = 0 then NULL else MaxBet end)
from 
	dep_custsetting as cs WITH (NOLOCK)
	INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.Recommend or cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend)
	and cs.bettype = 1 and cs.sporttype=1
where ci.custid = @recommend

Select 
	@MinMinBetv2 = Max(case when MinBet = 0 then NULL else MinBet end), 
	@MaxMaxBetv2 = Min(case when MaxBet = 0 then NULL else MaxBet end)
from 
	dep_custsetting as cs WITH (NOLOCK)
	INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.Recommend or cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend)
	and cs.bettype = 1 and cs.sporttype=2
where ci.custid = @recommend

Select 
	@MinMinBetv3 = Max(case when MinBet = 0 then NULL else MinBet end), 
	@MaxMaxBetv3 = Min(case when MaxBet = 0 then NULL else MaxBet end)
from 
	dep_custsetting as cs WITH (NOLOCK)
	INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.Recommend or cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend)
	and cs.bettype = 1 and cs.sporttype=3
where ci.custid = @recommend

Select 
	@MinMinBetv5 = Max(case when MinBet = 0 then NULL else MinBet end), 
	@MaxMaxBetv5 = Min(case when MaxBet = 0 then NULL else MaxBet end)
from 
	dep_custsetting as cs WITH (NOLOCK)
	INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.Recommend or cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend)
	and cs.bettype = 1 and cs.sporttype=5
where ci.custid = @recommend

Select 
	@MinMinBetv8 = Max(case when MinBet = 0 then NULL else MinBet end), 
	@MaxMaxBetv8 = Min(case when MaxBet = 0 then NULL else MaxBet end)
from 
	dep_custsetting as cs WITH (NOLOCK)
	INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.Recommend or cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend)
	and cs.bettype = 1 and cs.sporttype=8
where ci.custid = @recommend

Select 
	@MinMinBetv10 = Max(case when MinBet = 0 then NULL else MinBet end), 
	@MaxMaxBetv10 = Min(case when MaxBet = 0 then NULL else MaxBet end)
from 
	dep_custsetting as cs WITH (NOLOCK)
	INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.Recommend or cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend)
	and cs.bettype = 1 and cs.sporttype=10
where ci.custid = @recommend

Select 
	@MinMinBetv11 = Max(case when MinBet = 0 then NULL else MinBet end), 
	@MaxMaxBetv11 = Min(case when MaxBet = 0 then NULL else MaxBet end)
from 
	dep_custsetting as cs WITH (NOLOCK)
	INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.Recommend or cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend)
	and cs.bettype = 1 and cs.sporttype=11
where ci.custid = @recommend

--
Select 
	@MinMinBetv44 = Max(case when MinBet = 0 then NULL else MinBet end), 
	@MaxMaxBetv44 = Min(case when MaxBet = 0 then NULL else MaxBet end)
from 
	dep_custsetting as cs WITH (NOLOCK)
	INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.Recommend or cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend)
	and cs.bettype = 3 and cs.sporttype=44
where ci.custid = @recommend
--
Select 
	@MinMinBetv99 = Max(case when MinBet = 0 then NULL else MinBet end), 
	@MaxMaxBetv99 = Min(case when MaxBet = 0 then NULL else MaxBet end)
from 
	dep_custsetting as cs WITH (NOLOCK)
	INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.Recommend or cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend)
	and cs.bettype = 1 and cs.sporttype=99
where ci.custid = @recommend

--HRFO
Select 
	@MinMinBetv154 = Max(case when MinBet = 0 then NULL else MinBet end), 
	@MaxMaxBetv154 = Min(case when MaxBet = 0 then NULL else MaxBet end)
from 
	dep_custsetting as cs WITH (NOLOCK)
	INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.Recommend or cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend)
	and cs.bettype = 20 and cs.sporttype=154
where ci.custid = @recommend

Select 
	@MinMinBetv99MP = Max(case when MinBet = 0 then NULL else MinBet end), 
	@MaxMaxBetv99MP = Min(case when MaxBet = 0 then NULL else MaxBet end)
from 
	dep_custsetting as cs WITH (NOLOCK)
	INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.Recommend or cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend)
	and cs.bettype = 9 and cs.sporttype=99
where ci.custid = @recommend

Select 
	@MinMinBetv161 = Max(case when MinBet = 0 then NULL else MinBet end), 
	@MaxMaxBetv161 = Min(case when MaxBet = 0 then NULL else MaxBet end)
from 
	dep_custsetting3rd as cs WITH (NOLOCK)
	INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.Recommend or cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend)
	and cs.bettype = 81 and cs.sporttype=161
where ci.custid = @recommend

Select 	
	@MaxMaxperMatchv1 = Min(case when cs.MaxPerMatch = 0 then NULL else cs.MaxPerMatch end), 	
	@MaxMaxPerMatchv2 = Min(case when cs.MaxPerMatch2 = 0 then NULL else cs.MaxPerMatch2 end), 	
	@MaxMaxPerMatchv3 = Min(case when cs.MaxPerMatch3 = 0 then NULL else cs.MaxPerMatch3 end), 	
	@MaxMaxPerMatchv5 = Min(case when cs.MaxPerMatch5 = 0 then NULL else cs.MaxPerMatch5 end), 	
	@MaxMaxPerMatchv8 = Min(case when cs.MaxPerMatch8 = 0 then NULL else cs.MaxPerMatch8 end), 	
	@MaxMaxPerMatchv10 = Min(case when cs.MaxPerMatch10 = 0 then NULL else cs.MaxPerMatch10 end), 	
	@MaxMaxPerMatchv11 = Min(case when cs.MaxPerMatch11 = 0 then NULL else cs.MaxPerMatch11 end), 	
	@MaxMaxPerMatchv44 = Min(case when cs.MaxPerMatch44 = 0 then NULL else cs.MaxPerMatch44 end), 	
	@MaxMaxPerMatchv99 = Min(case when cs.MaxPerMatch99 = 0 then NULL else cs.MaxPerMatch99 end),
	@MaxMaxPerMatchv154 = Min(case when cs.MaxPerMatch154 = 0 then NULL else cs.MaxPerMatch154 end),
	@MaxMaxPerMatchv99MP = Min(case when cs.MaxPerMatch99MP = 0 then NULL else cs.MaxPerMatch99MP end),
	@MaxMaxPerMatchv161 = Min(case when cs.MaxPerMatch161 = 0 then NULL else cs.MaxPerMatch161 end),
	@MaxMaxPerBallv161 = Min(case when cs.MaxPerBall161 = 0 then NULL else cs.MaxPerBall161 end)
from 
	custinfo as cs WITH (NOLOCK) 
	INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.Recommend or cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend)
where ci.custid = @recommend

if (@MinBetv1<>0 and @MaxBetv1 <> 0 and  @MinBetv1>@MaxBetv1) or (@MaxBetv1<> 0 and @MaxPerMatchv1 <> 0 and @MaxBetv1>@MaxPerMatchv1) 
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be less than max bet and max bet must be less than max bet per match'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language)
					end						
					+ char(13) + char(10) + convert(varchar(20), @MinBetv1) + '-' + convert(varchar(20), @MaxBetv1) + '-' + convert(varchar(20), @MaxPerMatchv1), @ErrCode = 108
			
	return
		
END
	
IF (@MinMinBetv1>0 AND @MinBetv1>0 AND @MinBetv1<@MinMinBetv1)
BEGIN
	SELECT @ErrMsg =	@UserName + ': ' +
					CASE @Language 
						WHEN 'E' THEN 'Min bet must be equal to or greater than Agent min bet'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10006,@Language)
					END						
					+' (' + CONVERT(VARCHAR(20), @MinMinBetv1) + ').', @ErrCode = 109
				
	return
END
	
IF (@MaxMaxBetv1>0 AND @MaxBetv1>0 AND @MaxBetv1>@MaxMaxBetv1)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Max bet must be equal to or less than Agent max bet'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10007,@Language)
					END						
					+'(' + CONVERT(VARCHAR(20), @MaxMaxBetv1) + ').', @ErrCode = 110
				
	return
END
	
IF (@MaxMaxPerMatchv1>0 AND @MaxPerMatchv1>0 AND @MaxPerMatchv1>@MaxMaxPerMatchv1)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Max Per Match must be equal to or less than Agent Max Per Match'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10008,@Language)
					END						
					+'(' + CONVERT(VARCHAR(20), @MaxMaxPerMatchv1) + ').', @ErrCode = 111
				
	return
END

if (@MinBetv2 <> 0 and @MaxBetv2 <> 0 and @MinBetv2>@MaxBetv2) or (@MaxBetv2 <> 0 and @MaxPerMatchv2 <> 0 and @MaxBetv2>@MaxPerMatchv2)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be less than max bet and max bet must be less than max bet per match (for Basketball)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](2,@Language) + ')'
					end						
					+ char(13) + char(10) + convert(varchar(20), @MinBetv2) + '-' + convert(varchar(20), @MaxBetv2) + '-' + convert(varchar(20), @MaxPerMatchv2), @ErrCode = 112
				
	return
END
	
IF (@MinMinBetv2>0 AND @MinBetv2>0 AND @MinBetv2<@MinMinBetv2)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Min bet must be equal to or greater than Agent min bet (for Basketball)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10006,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](2,@Language) + ')'
					END						
					+' (' + CONVERT(VARCHAR(20), @MinMinBetv2) + ').', @ErrCode = 113
				
	return
END	
IF (@MaxMaxBetv2>0 AND @MaxBetv2>0 AND @MaxBetv2>@MaxMaxBetv2)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Max bet must be equal to or less than Agent max bet (for Basketball)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10007,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](2,@Language) + ')'
					END						
					+' (' + CONVERT(VARCHAR(20), @MaxMaxBetv2) + ').', @ErrCode = 114
				
	return
END
	
IF (@MaxMaxPerMatchv2>0 AND @MaxPerMatchv2>0 AND @MaxPerMatchv2>@MaxMaxPerMatchv2)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Max Per Match must be equal to or less than Agent Max Per Match (for Basketball)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10008,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](2,@Language) + ')'
					END						
					+' (' + CONVERT(VARCHAR(20), @MaxMaxPerMatchv2) + ').', @ErrCode = 115
				
	return
END

if (@MinBetv3 <> 0 and @MaxBetv3 <> 0 and @MinBetv3>@MaxBetv3) or (@MaxBetv3 <> 0 and @MaxPerMatchv3 <> 0 and @MaxBetv3>@MaxPerMatchv3)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be less than max bet and max bet must be less than max bet per match (for Football)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](3,@Language) + ')'
					end						
					+ char(13) + char(10) + convert(varchar(20), @MinBetv3) + '-' + convert(varchar(20), @MaxBetv3) + '-' + convert(varchar(20), @MaxPerMatchv3), @ErrCode = 116
				
	return
END
	
IF (@MinMinBetv3>0 AND @MinBetv3>0 AND @MinBetv3<@MinMinBetv3)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Min bet must be equal to or greater than Agent min bet (for Football)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10006,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](3,@Language) + ')'
					END						
					+' (' + CONVERT(VARCHAR(20), @MinMinBetv3) + ').', @ErrCode = 117
				
	return
END	
IF (@MaxMaxBetv3>0 AND @MaxBetv3>0 AND @MaxBetv3>@MaxMaxBetv3)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Max bet must be equal to or less than Agent max bet (for Football)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10007,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](3,@Language) + ')'						
					END						
					+' (' + CONVERT(VARCHAR(20), @MaxMaxBetv3) + ').', @ErrCode = 118
				
	return
END
	
IF (@MaxMaxPerMatchv3>0 AND @MaxPerMatchv3>0 AND @MaxPerMatchv3>@MaxMaxPerMatchv3)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Max Per Match must be equal to or less than Agent Max Per Match (for Football)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10008,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](3,@Language) + ')'
					END						
					+' (' + CONVERT(VARCHAR(20), @MaxMaxPerMatchv3) + ').', @ErrCode = 119
				
	return
END

if (@MinBetv5 <> 0 and @MaxBetv5 <> 0 and @MinBetv5>@MaxBetv5) or (@MaxBetv5 <> 0 and @MaxPerMatchv5 <> 0 and @MaxBetv5>@MaxPerMatchv5)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be less than max bet and max bet must be less than max bet per match (for Tennis)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](5,@Language) + ')'
					end						
					+ char(13) + char(10) + convert(varchar(20), @MinBetv5) + '-' + convert(varchar(20), @MaxBetv5) + '-' + convert(varchar(20), @MaxPerMatchv5), @ErrCode = 120
				
	return
END
	
IF (@MinMinBetv5>0 AND @MinBetv5>0 AND @MinBetv5<@MinMinBetv5)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Min bet must be equal to or greater than Agent min bet (for Tennis)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10006,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](5,@Language) + ')'
					END						
					+' (' + CONVERT(VARCHAR(20), @MinMinBetv5) + ').', @ErrCode = 121
				
	return
END	
IF (@MaxMaxBetv5>0 AND @MaxBetv5>0 AND @MaxBetv5>@MaxMaxBetv5)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Max bet must be equal to or less than Agent max bet (for Tennis)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10007,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](5,@Language) + ')'
					END						
					+' (' + CONVERT(VARCHAR(20), @MaxMaxBetv5) + ').', @ErrCode = 122
				
	return
END
	
IF (@MaxMaxPerMatchv5>0 AND @MaxPerMatchv5>0 AND @MaxPerMatchv5>@MaxMaxPerMatchv5)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Max Per Match must be equal to or less than Agent Max Per Match  (for Tennis)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10008,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](5,@Language) + ')'
					END						
					+' (' + CONVERT(VARCHAR(20), @MaxMaxPerMatchv5) + ').', @ErrCode = 123
				
	return
END

if (@MinBetv8 <> 0 and @MaxBetv8 <> 0 and @MinBetv8>@MaxBetv8) or (@MaxBetv8 <> 0 and @MaxPerMatchv8 <> 0 and @MaxBetv8>@MaxPerMatchv8)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be less than max bet and max bet must be less than max bet per match (for Baseball)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](8,@Language) + ')'
					end						
					+ char(13) + char(10) + convert(varchar(20), @MinBetv8) + '-' + convert(varchar(20), @MaxBetv8) + '-' + convert(varchar(20), @MaxPerMatchv8), @ErrCode = 124
				
	return
END
	
IF (@MinMinBetv8>0 AND @MinBetv8>0 AND @MinBetv8<@MinMinBetv8)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Min bet must be equal to or greater than Agent min bet (for Baseball)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10006,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](8,@Language) + ')'
					END						
					+' (' + CONVERT(VARCHAR(20), @MinMinBetv8) + ').', @ErrCode = 125
				
	return
END	
IF (@MaxMaxBetv8>0 AND @MaxBetv8>0 AND @MaxBetv8>@MaxMaxBetv8)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Max bet must be equal to or less than Agent max bet (for Baseball)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10007,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](8,@Language) + ')'
					END						
					+' (' + CONVERT(VARCHAR(20), @MaxMaxBetv8) + ').', @ErrCode = 126
				
	return
END
	
IF (@MaxMaxPerMatchv8>0 AND @MaxPerMatchv8>0 AND @MaxPerMatchv8>@MaxMaxPerMatchv8)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Max Per Match must be equal to or less than Agent Max Per Match (for Baseball)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10008,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](8,@Language) + ')'
					END						
					+' (' + CONVERT(VARCHAR(20), @MaxMaxPerMatchv8) + ').', @ErrCode = 127
				
	return
END

if (@MinBetv10 <> 0 and @MaxBetv10 <> 0 and @MinBetv10>@MaxBetv10) or (@MaxBetv10 <> 0 and @MaxPerMatchv10 <> 0 and @MaxBetv10>@MaxPerMatchv10)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be less than max bet and max bet must be less than max bet per match (for Golf)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](10,@Language) + ')'
					end						
					+ char(13) + char(10) + convert(varchar(20), @MinBetv10) + '-' + convert(varchar(20), @MaxBetv10) + '-' + convert(varchar(20), @MaxPerMatchv10), @ErrCode = 128
				
	return
END
	
IF (@MinMinBetv10>0 AND @MinBetv10>0 AND @MinBetv10<@MinMinBetv10)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Min bet must be equal to or greater than Agent min bet (for Golf)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10006,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](10,@Language) + ')'
					END						
					+' (' + CONVERT(VARCHAR(20), @MinMinBetv10) + ').', @ErrCode = 129
				
	return
END	
IF (@MaxMaxBetv10>0 AND @MaxBetv10>0 AND @MaxBetv10>@MaxMaxBetv10)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Max bet must be equal to or less than Agent max bet (for Golf)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10007,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](10,@Language) + ')'
					END						
					+' (' + CONVERT(VARCHAR(20), @MaxMaxBetv10) + ').', @ErrCode = 130
				
	return
END
	
IF (@MaxMaxPerMatchv10>0 AND @MaxPerMatchv10>0 AND @MaxPerMatchv10>@MaxMaxPerMatchv10)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Max Per Match must be equal to or less than Agent Max Per Match (for Golf)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10008,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](10,@Language) + ')'
					END						
					+' (' + CONVERT(VARCHAR(20), @MaxMaxPerMatchv10) + ').', @ErrCode = 131
				
	return
END

if (@MinBetv11 <> 0 and @MaxBetv11 <> 0 and @MinBetv11>@MaxBetv11) or (@MaxBetv11 <> 0 and @MaxPerMatchv11 <> 0 and @MaxBetv11>@MaxPerMatchv11)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be less than max bet and max bet must be less than max bet per match (for Motorsports)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](11,@Language) + ')'
					end						
					+ char(13) + char(10) + convert(varchar(20), @MinBetv11) + '-' + convert(varchar(20), @MaxBetv11) + '-' + convert(varchar(20), @MaxPerMatchv11), @ErrCode = 132
				
	return
END
	
IF (@MinMinBetv11>0 AND @MinBetv11>0 AND @MinBetv11<@MinMinBetv11)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Min bet must be equal to or greater than Agent min bet (for Motorsports)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10006,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](11,@Language) + ')'
					END						
					+' (' + CONVERT(VARCHAR(20), @MinMinBetv11) + ').', @ErrCode = 133
				
	return
END	
IF (@MaxMaxBetv11>0 AND @MaxBetv11>0 AND @MaxBetv11>@MaxMaxBetv11)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Max bet must be equal to or less than Agent max bet (for Motorsports)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10007,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](11,@Language) + ')'
					END						
					+' (' + CONVERT(VARCHAR(20), @MaxMaxBetv11) + ').', @ErrCode = 134
				
	return
END
	
IF (@MaxMaxPerMatchv11>0 AND @MaxPerMatchv11>0 AND @MaxPerMatchv11>@MaxMaxPerMatchv11)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Max Per Match must be equal to or less than Agent Max Per Match (for Motorsports)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10008,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](11,@Language) + ')'
					END						
					+' (' + CONVERT(VARCHAR(20), @MaxMaxPerMatchv11) + ').', @ErrCode = 135
				
	return
END
---44
if (@MinBetv44 <> 0 and @MaxBetv44 <> 0 and @MinBetv44>@MaxBetv44) or (@MaxBetv44 <> 0 and @MaxPerMatchv44 <> 0 and @MaxBetv44>@MaxPerMatchv44)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be less than max bet and max bet must be less than max bet per match (for MuayThai)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](44,@Language) + ')'
					end						
					+ char(13) + char(10) + convert(varchar(20), @MinBetv44) + '-' + convert(varchar(20), @MaxBetv44) + '-' + convert(varchar(20), @MaxPerMatchv44), @ErrCode = 132
				
	return
END
	
IF (@MinMinBetv44>0 AND @MinBetv44>0 AND @MinBetv44<@MinMinBetv44)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Min bet must be equal to or greater than Agent min bet (for MuayThai)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10006,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](44,@Language) + ')'
					END						
					+' (' + CONVERT(VARCHAR(20), @MinMinBetv44) + ').', @ErrCode = 133
				
	return
END	
IF (@MaxMaxBetv44>0 AND @MaxBetv44>0 AND @MaxBetv44>@MaxMaxBetv44)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Max bet must be equal to or less than Agent max bet (for MuayThai)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10007,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](44,@Language) + ')'
					END						
					+' (' + CONVERT(VARCHAR(20), @MaxMaxBetv44) + ').', @ErrCode = 134
				
	return
END
	
IF (@MaxMaxPerMatchv44>0 AND @MaxPerMatchv44>0 AND @MaxPerMatchv44>@MaxMaxPerMatchv44)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Max Per Match must be equal to or less than Agent Max Per Match (for MuayThai)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10008,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](44,@Language) + ')'
					END						
					+' (' + CONVERT(VARCHAR(20), @MaxMaxPerMatchv44) + ').', @ErrCode = 135
				
	return
END
---
if (@MinBetv99 <> 0 and @MaxBetv99 <> 0 and @MinBetv99>@MaxBetv99) or (@MaxBetv99 <> 0 and @MaxPerMatchv99 <> 0 and @MaxBetv99>@MaxPerMatchv99)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be less than max bet and max bet must be less than max bet per match (for Other sports)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](99,@Language) + ')'
					end						
					+ char(13) + char(10) + convert(varchar(20), @MinBetv99) + '-' + convert(varchar(20), @MaxBetv99) + '-' + convert(varchar(20), @MaxPerMatchv99), @ErrCode = 136
				
	return
END
	
IF (@MinMinBetv99>0 AND @MinBetv99>0 AND @MinBetv99<@MinMinBetv99)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Min bet must be equal to or greater than Agent min bet (for Other sports)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10006,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](99,@Language) + ')'
					END						
					+' (' + CONVERT(VARCHAR(20), @MinMinBetv99) + ').', @ErrCode = 137
				
	return
END	
IF (@MaxMaxBetv99>0 AND @MaxBetv99>0 AND @MaxBetv99>@MaxMaxBetv99)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Max bet must be equal to or less than Agent max bet (for Other sports)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10007,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](99,@Language) + ')'				
					END						
					+' (' + CONVERT(VARCHAR(20), @MaxMaxBetv99) + ').', @ErrCode = 138
				
	return
END
	
IF (@MaxMaxPerMatchv99>0 AND @MaxPerMatchv99>0 AND @MaxPerMatchv99>@MaxMaxPerMatchv99)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Max Per Match must be equal to or less than Agent Max Per Match (for Other sports)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10008,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](99,@Language) + ')'
					END						
					+' (' + CONVERT(VARCHAR(20), @MaxMaxPerMatchv99) + ').', @ErrCode = 139
				
	return
END

--HRFO
if (@MinBetv154 <> 0 and @MaxBetv154 <> 0 and @MinBetv154>@MaxBetv154) or (@MaxBetv154 <> 0 and @MaxPerMatchv154 <> 0 and @MaxBetv154>@MaxPerMatchv154)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be less than max bet and max bet must be less than max bet per match (for HR Fixed Odds)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](154,@Language) + ')'
					end						
					+ char(13) + char(10) + convert(varchar(20), @MinBetv154) + '-' + convert(varchar(20), @MaxBetv154) + '-' + convert(varchar(20), @MaxPerMatchv154), @ErrCode = 136
				
	return
END
	
IF (@MinMinBetv154>0 AND @MinBetv154>0 AND @MinBetv154<@MinMinBetv154)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Min bet must be equal to or greater than Agent min bet (for HR Fixed Odds)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10006,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](154,@Language) + ')'
					END						
					+' (' + CONVERT(VARCHAR(20), @MinMinBetv154) + ').', @ErrCode = 137
				
	return
END	
IF (@MaxMaxBetv154>0 AND @MaxBetv154>0 AND @MaxBetv154>@MaxMaxBetv154)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Max bet must be equal to or less than Agent max bet (for HR Fixed Odds)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10007,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](154,@Language) + ')'				
					END						
					+' (' + CONVERT(VARCHAR(20), @MaxMaxBetv154) + ').', @ErrCode = 138
				
	return
END
	
IF (@MaxMaxPerMatchv154>0 AND @MaxPerMatchv154>0 AND @MaxPerMatchv154>@MaxMaxPerMatchv154)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Max Per Match must be equal to or less than Agent Max Per Match (for HR Fixed Odds)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10008,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](154,@Language) + ')'
					END						
					+' (' + CONVERT(VARCHAR(20), @MaxMaxPerMatchv154) + ').', @ErrCode = 139
				
	return
END

if (@MinBetv99MP <> 0 and @MaxBetv99MP <> 0 and @MinBetv99MP>@MaxBetv99MP) or (@MaxBetv99MP <> 0 and @MaxPerMatchv99MP <> 0 and @MaxBetv99MP>@MaxPerMatchv99MP)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be less than max bet and max bet must be less than max bet per match (for Mix Sports Parlay)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language) + case @Language 
																							when 'CS' then N'(供混合体育过关)'
																							when 'CT' then N'(供混合體育過關)'
																							when 'TH' then N'(สำหรับกีฬาบอลชุด)'
																							when 'J' then N'(Mix Sports Parlay)'
																							when 'KO' then N'(Mix Sports Parlay)'
																							when 'VI' then N'(Mix Sports Parlay)'
																							else N'(Mix Sports Parlay)' END
					end						
					+ char(13) + char(10) + convert(varchar(20), @MinBetv99MP) + '-' + convert(varchar(20), @MaxBetv99MP) + '-' + convert(varchar(20), @MaxPerMatchv99MP), @ErrCode = 140
				
	return
END
	
IF (@MinMinBetv99MP>0 AND @MinBetv99MP>0 AND @MinBetv99MP<@MinMinBetv99MP)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Min bet must be equal to or greater than Agent min bet (for Mix Sports Parlay)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10006,@Language) + case @Language 
																							when 'CS' then N'(供混合体育过关)'
																							when 'CT' then N'(供混合體育過關)'
																							when 'TH' then N'(สำหรับกีฬาบอลชุด)'
																							when 'J' then N'(Mix Sports Parlay)'
																							when 'KO' then N'(Mix Sports Parlay)'
																							when 'VI' then N'(Mix Sports Parlay)'
																							else N'(Mix Sports Parlay)' END
					END						
					+' (' + CONVERT(VARCHAR(20), @MinMinBetv99MP) + ').', @ErrCode = 141
				
	return
END	
IF (@MaxMaxBetv99MP>0 AND @MaxBetv99MP>0 AND @MaxBetv99MP>@MaxMaxBetv99MP)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Max bet must be equal to or less than Agent max bet (for Mix Sports Parlay)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10007,@Language) + case @Language 
																							when 'CS' then N'(供混合体育过关)'
																							when 'CT' then N'(供混合體育過關)'
																							when 'TH' then N'(สำหรับกีฬาบอลชุด)'
																							when 'J' then N'(Mix Sports Parlay)'
																							when 'KO' then N'(Mix Sports Parlay)'
																							when 'VI' then N'(Mix Sports Parlay)'
																							else N'(Mix Sports Parlay)' END
					END						
					+' (' + CONVERT(VARCHAR(20), @MaxMaxBetv99MP) + ').', @ErrCode = 142
				
	return
END
	
IF (@MaxMaxPerMatchv99MP>0 AND @MaxPerMatchv99MP>0 AND @MaxPerMatchv99MP>@MaxMaxPerMatchv99MP)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Max Per Match must be equal to or less than Agent Max Per Match (for Mix Sports Parlay)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10008,@Language) + case @Language 
																							when 'CS' then N'(供混合体育过关)'
																							when 'CT' then N'(供混合體育過關)'
																							when 'TH' then N'(สำหรับกีฬาบอลชุด)'
																							when 'J' then N'(Mix Sports Parlay)'
																							when 'KO' then N'(Mix Sports Parlay)'
																							when 'VI' then N'(Mix Sports Parlay)'
																							else N'(Mix Sports Parlay)' END
					END						
					+' (' + CONVERT(VARCHAR(20), @MaxMaxPerMatchv99MP) + ').', @ErrCode = 143
				
	return
END

if (@MinBetv161 <> 0 and @MaxBetv161 <> 0 and @MinBetv161>@MaxBetv161) or (@MaxBetv161<> 0 and @MaxPerMatchv161 <> 0 and @MaxBetv161>@MaxPerMatchv161)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be less than max bet and max bet must be less than max bet per match (for Number Game)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](161,@Language) + ')'
					end						
					+ char(13) + char(10) + convert(varchar(20), @MinBetv161) + '-' + convert(varchar(20), @MaxBetv161) + '-' + convert(varchar(20), @MaxPerMatchv161), @ErrCode = 144
				
	return
END
	
IF (@MinMinBetv161>0 AND @MinBetv161>0 AND @MinBetv161<@MinMinBetv161)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Min bet must be equal to or greater than Agent min bet (for Number Game)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10006,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](161,@Language) + ')'
					END						
					+' (' + CONVERT(VARCHAR(20), @MinMinBetv161) + ').', @ErrCode = 145
				
	return
END	
IF (@MaxMaxBetv161>0 AND @MaxBetv161>0 AND @MaxBetv161>@MaxMaxBetv161)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Max bet must be equal to or less than Agent max bet (for Number Game)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10007,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](161,@Language) + ')'
					END						
					+' (' + CONVERT(VARCHAR(20), @MaxMaxBetv161) + ').', @ErrCode = 146
				
	return
END
	
IF (@MaxMaxPerMatchv161>0 AND @MaxPerMatchv161>0 AND @MaxPerMatchv161>@MaxMaxPerMatchv161)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Max Per Match must be equal to or less than Agent Max Per Match (for Number Game)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10008,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](161,@Language) + ')'
					END						
					+' (' + CONVERT(VARCHAR(20), @MaxMaxPerMatchv161) + ').', @ErrCode = 147
				
	return
END

if @MaxPerBallv161 > @MaxMaxPerBallv161 and @MaxMaxPerBallv161 > 0
begin
	SELECT @ErrMsg = @UserName + ': ' +
		CASE @Language 
			WHEN 'E' THEN 'Max Per Ball must equal to or less than Agent Max Per Ball (Number Game).'
			ELSE [dbo].[f_Get_MsgNamebyMsgID](10009,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](161,@Language) + ')'
		END
		+' (' + CONVERT(VARCHAR(20), @MaxMaxPerBallv161) + ').', @ErrCode = 201				
	return
end

-------------------HORSE RACING-----------------------

Select 
	@v151MinMinBet_31 = isnull(Max(case when MinBet = 0 then NULL else MinBet end),0), 
	@v151MaxMaxBet_31 = isnull(Min(case when MaxBet = 0 then NULL else MaxBet end),0)
from 
	Dep_CustSetting3rd as cs WITH (NOLOCK)
	INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend or cs.CustID = ci.Recommend) and cs.bettype = 31 and cs.sporttype=151
where ci.custid = @Recommend

Select 
	@v151MinMinBet_41 = isnull(Max(case when MinBet = 0 then NULL else MinBet end),0), 
	@v151MaxMaxBet_41 = isnull(Min(case when MaxBet = 0 then NULL else MaxBet end),0)
from 
	Dep_CustSetting3rd as cs WITH (NOLOCK)
	INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend or cs.CustID = ci.Recommend) and cs.bettype = 41 and cs.sporttype=151
where ci.custid = @Recommend

Select 
	@v151MinMinBet_51 = isnull(Max(case when MinBet = 0 then NULL else MinBet end),0), 
	@v151MaxMaxBet_51 = isnull(Min(case when MaxBet = 0 then NULL else MaxBet end),0)
from 
	Dep_CustSetting3rd as cs WITH (NOLOCK)
	INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend or cs.CustID = ci.Recommend) and cs.bettype = 51 and cs.sporttype=151
where ci.custid = @Recommend

Select 
	@v152MinMinBet_41 = isnull(Max(case when MinBet = 0 then NULL else MinBet end),0), 
	@v152MaxMaxBet_41 = isnull(Min(case when MaxBet = 0 then NULL else MaxBet end),0)
from 
	Dep_CustSetting3rd as cs WITH (NOLOCK)
	INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend or cs.CustID = ci.Recommend) and cs.bettype = 41 and cs.sporttype=152
where ci.custid = @Recommend

Select 
	@v152MinMinBet_51 = isnull(Max(case when MinBet = 0 then NULL else MinBet end),0), 
	@v152MaxMaxBet_51 = isnull(Min(case when MaxBet = 0 then NULL else MaxBet end),0)
from 
	Dep_CustSetting3rd as cs WITH (NOLOCK)
	INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend or cs.CustID = ci.Recommend) and cs.bettype = 51 and cs.sporttype=152
where ci.custid = @Recommend

Select 
	@v153MinMinBet_51 = isnull(Max(case when MinBet = 0 then NULL else MinBet end),0), 
	@v153MaxMaxBet_51 = isnull(Min(case when MaxBet = 0 then NULL else MaxBet end),0)
from 
	Dep_CustSetting3rd as cs WITH (NOLOCK)
	INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend or cs.CustID = ci.Recommend) and cs.bettype = 51 and cs.sporttype=153
where ci.custid = @Recommend

if (@v151MinBet_31<>0 and @v151MaxBet_31 <> 0 and  @v151MinBet_31>@v151MaxBet_31) or (@v151MaxBet_31<> 0 and @v151MaxPerMatch_31 <> 0 and @v151MaxBet_31>@v151MaxPerMatch_31) 
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be less than max bet and max bet must be less than max bet per match!!!'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language)
					end						
					+ char(13) + char(10) + convert(varchar(20), @v151MinBet_31) + '-' + convert(varchar(20), @v151MaxBet_31) + '-' + convert(varchar(20), @v151MaxPerMatch_31), @ErrCode = 109					 
	
	return
END

if (@v151MinMinBet_31>0 and @v151MinBet_31>0 and @v151MinBet_31<@v151MinMinBet_31)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be equal to or greater than Master Agent min bet'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10019,@Language)
					end						
					+' (' + convert(varchar(20), @v151MinMinBet_31) + ').', @ErrCode = 110				 
	
	return
END

if (@v151MaxMaxBet_31>0 and @v151MaxBet_31>0 and @v151MaxBet_31>@v151MaxMaxBet_31)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max bet must be equal to or less than Master Agent max bet'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10020,@Language)
					end						
					+' (' + convert(varchar(20), @v151MaxMaxBet_31) + ').', @ErrCode = 111					 
	
	return
END

if (@v151MaxMaxPerMatch_31>0 and @v151MaxPerMatch_31>0 and @v151MaxPerMatch_31>@v151MaxMaxPerMatch_31)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max Per Match must be equal to or less than Master Agent Max Per Match'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10021,@Language)
					end						
					+' (' + convert(varchar(20), @v151MaxMaxPerMatch_31) + ').', @ErrCode = 111					 
	
	return
END

if (@v151MinBet_41<>0 and @v151MaxBet_41 <> 0 and  @v151MinBet_41>@v151MaxBet_41) or (@v151MaxBet_41<> 0 and @v151MaxPerMatch_41 <> 0 and @v151MaxBet_41>@v151MaxPerMatch_41) 
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be less than max bet and max bet must be less than max bet per match!!!'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language)
					end						
					+ char(13) + char(10) + convert(varchar(20), @v151MinBet_41) + '-' + convert(varchar(20), @v151MaxBet_41) + '-' + convert(varchar(20), @v151MaxPerMatch_41), @ErrCode = 109					 
	
	return
END

if (@v151MinMinBet_41>0 and @v151MinBet_41>0 and @v151MinBet_41<@v151MinMinBet_41)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be equal to or greater than Master Agent min bet'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10019,@Language)
					end						
					+' (' + convert(varchar(20), @v151MinMinBet_41) + ').', @ErrCode = 110				 
	
	return
END

if (@v151MaxMaxBet_41>0 and @v151MaxBet_41>0 and @v151MaxBet_41>@v151MaxMaxBet_41)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max bet must be equal to or less than Master Agent max bet'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10020,@Language)
					end						
					+' (' + convert(varchar(20), @v151MaxMaxBet_41) + ').', @ErrCode = 111					 
	
	return
END

if (@v151MaxMaxPerMatch_41>0 and @v151MaxPerMatch_41>0 and @v151MaxPerMatch_41>@v151MaxMaxPerMatch_41)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max Per Match must be equal to or less than Master Agent Max Per Match'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10021,@Language)
					end						
					+' (' + convert(varchar(20), @v151MaxMaxPerMatch_41) + ').', @ErrCode = 111					 
	
	return
END

if (@v151MinBet_51<>0 and @v151MaxBet_51 <> 0 and  @v151MinBet_51>@v151MaxBet_51) or (@v151MaxBet_51<> 0 and @v151MaxPerMatch_51 <> 0 and @v151MaxBet_51>@v151MaxPerMatch_51) 
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be less than max bet and max bet must be less than max bet per match!!!'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language)
					end						
					+ char(13) + char(10) + convert(varchar(20), @v151MinBet_51) + '-' + convert(varchar(20), @v151MaxBet_51) + '-' + convert(varchar(20), @v151MaxPerMatch_51), @ErrCode = 109					 
	
	return
END

if (@v151MinMinBet_51>0 and @v151MinBet_51>0 and @v151MinBet_51<@v151MinMinBet_51)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be equal to or greater than Master Agent min bet'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10019,@Language)
					end						
					+' (' + convert(varchar(20), @v151MinMinBet_51) + ').', @ErrCode = 110				 
	
	return
END

if (@v151MaxMaxBet_51>0 and @v151MaxBet_51>0 and @v151MaxBet_51>@v151MaxMaxBet_51)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max bet must be equal to or less than Master Agent max bet'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10020,@Language)
					end						
					+' (' + convert(varchar(20), @v151MaxMaxBet_51) + ').', @ErrCode = 111					 
	
	return
END

if (@v151MaxMaxPerMatch_51>0 and @v151MaxPerMatch_51>0 and @v151MaxPerMatch_51>@v151MaxMaxPerMatch_51)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max Per Match must be equal to or less than Master Agent Max Per Match'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10021,@Language)
					end						
					+' (' + convert(varchar(20), @v151MaxMaxPerMatch_51) + ').', @ErrCode = 111					 
	
	return
END

if (@v152MinBet_41<>0 and @v152MaxBet_41 <> 0 and  @v152MinBet_41>@v152MaxBet_41) or (@v152MaxBet_41<> 0 and @v152MaxPerMatch_41 <> 0 and @v152MaxBet_41>@v152MaxPerMatch_41) 
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be less than max bet and max bet must be less than max bet per match!!!'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language)
					end						
					+ char(13) + char(10) + convert(varchar(20), @v152MinBet_41) + '-' + convert(varchar(20), @v152MaxBet_41) + '-' + convert(varchar(20), @v152MaxPerMatch_41), @ErrCode = 109					 
	
	return
END

if (@v152MinMinBet_41>0 and @v152MinBet_41>0 and @v152MinBet_41<@v152MinMinBet_41)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be equal to or greater than Master Agent min bet'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10019,@Language)
					end						
					+' (' + convert(varchar(20), @v152MinMinBet_41) + ').', @ErrCode = 110				 
	
	return
END

if (@v152MaxMaxBet_41>0 and @v152MaxBet_41>0 and @v152MaxBet_41>@v152MaxMaxBet_41)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max bet must be equal to or less than Master Agent max bet'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10020,@Language)
					end						
					+' (' + convert(varchar(20), @v152MaxMaxBet_41) + ').', @ErrCode = 111					 
	
	return
END

if (@v152MaxMaxPerMatch_41>0 and @v152MaxPerMatch_41>0 and @v152MaxPerMatch_41>@v152MaxMaxPerMatch_41)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max Per Match must be equal to or less than Master Agent Max Per Match'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10021,@Language)
					end						
					+' (' + convert(varchar(20), @v152MaxMaxPerMatch_41) + ').', @ErrCode = 111					 
	
	return
END

if (@v152MinBet_51<>0 and @v152MaxBet_51 <> 0 and  @v152MinBet_51>@v152MaxBet_51) or (@v152MaxBet_51<> 0 and @v152MaxPerMatch_51 <> 0 and @v152MaxBet_51>@v152MaxPerMatch_51) 
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be less than max bet and max bet must be less than max bet per match!!!'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language)
					end						
					+ char(13) + char(10) + convert(varchar(20), @v152MinBet_51) + '-' + convert(varchar(20), @v152MaxBet_51) + '-' + convert(varchar(20), @v152MaxPerMatch_51), @ErrCode = 109					 
	
	return
END

if (@v152MinMinBet_51>0 and @v152MinBet_51>0 and @v152MinBet_51<@v152MinMinBet_51)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be equal to or greater than Master Agent min bet'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10019,@Language)
					end						
					+' (' + convert(varchar(20), @v152MinMinBet_51) + ').', @ErrCode = 110				 
	
	return
END

if (@v152MaxMaxBet_51>0 and @v152MaxBet_51>0 and @v152MaxBet_51>@v152MaxMaxBet_51)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max bet must be equal to or less than Master Agent max bet'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10020,@Language)
					end						
					+' (' + convert(varchar(20), @v152MaxMaxBet_51) + ').', @ErrCode = 111					 
	
	return
END

if (@v152MaxMaxPerMatch_51>0 and @v152MaxPerMatch_51>0 and @v152MaxPerMatch_51>@v152MaxMaxPerMatch_51)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max Per Match must be equal to or less than Master Agent Max Per Match'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10021,@Language)
					end						
					+' (' + convert(varchar(20), @v152MaxMaxPerMatch_51) + ').', @ErrCode = 111					 
	
	return
END

if (@v153MinBet_51<>0 and @v153MaxBet_51 <> 0 and  @v153MinBet_51>@v153MaxBet_51) or (@v153MaxBet_51<> 0 and @v153MaxPerMatch_51 <> 0 and @v153MaxBet_51>@v153MaxPerMatch_51) 
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be less than max bet and max bet must be less than max bet per match!!!'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language)
					end						
					+ char(13) + char(10) + convert(varchar(20), @v153MinBet_51) + '-' + convert(varchar(20), @v153MaxBet_51) + '-' + convert(varchar(20), @v153MaxPerMatch_51), @ErrCode = 109					 
	
	return
END

if (@v153MinMinBet_51>0 and @v153MinBet_51>0 and @v153MinBet_51<@v153MinMinBet_51)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be equal to or greater than Master Agent min bet'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10019,@Language)
					end						
					+' (' + convert(varchar(20), @v153MinMinBet_51) + ').', @ErrCode = 110				 
	
	return
END

if (@v153MaxMaxBet_51>0 and @v153MaxBet_51>0 and @v153MaxBet_51>@v153MaxMaxBet_51)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max bet must be equal to or less than Master Agent max bet'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10020,@Language)
					end						
					+' (' + convert(varchar(20), @v153MaxMaxBet_51) + ').', @ErrCode = 111					 
	
	return
END

if (@v153MaxMaxPerMatch_51>0 and @v153MaxPerMatch_51>0 and @v153MaxPerMatch_51>@v153MaxMaxPerMatch_51)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max Per Match must be equal to or less than Master Agent Max Per Match'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10021,@Language)
					end						
					+' (' + convert(varchar(20), @v153MaxMaxPerMatch_51) + ').', @ErrCode = 111					 
	
	return
END

/************************************
	Validate Commision
*************************************/

IF (@v151discount_31 < 0 OR @v151discount_31 > 0.04)
BEGIN		
	SELECT @ErrMsg = 	CASE @Language 
						WHEN 'E' THEN 'Invalid commission rate (SA Tote).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](2,@Language)
				END, @ErrCode = 101
	RETURN
END
IF (@v151discount_41 < 0	OR @v151discount_41 > 0.04)
BEGIN		
	SELECT @ErrMsg = 	CASE @Language 
						WHEN 'E' THEN 'Invalid commission rate (UK/Irish Tote).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](3,@Language)
				END, @ErrCode = 101
	RETURN
END

IF (@v151discount_51 < 0 OR @v151discount_51 > 0.04)
BEGIN		
	SELECT @ErrMsg = 	CASE @Language 
						WHEN 'E' THEN 'Invalid commission rate (Aust Tote).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](4,@Language)
				END, @ErrCode = 101
	RETURN
END

IF (@v152discount_41 < 0 OR @v152discount_41 > 0.04)
BEGIN		
	SELECT @ErrMsg = 	CASE @Language 
						WHEN 'E' THEN 'Invalid commission rate (UK/Irish Greyhounds).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](5,@Language)
				END, @ErrCode = 101
	RETURN
END
IF (@v152discount_51 < 0 OR @v152discount_51 > 0.04)
BEGIN		
	SELECT @ErrMsg = 	CASE @Language 
						WHEN 'E' THEN 'Invalid commission rate (Aust Greyhound).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](6,@Language)
				END, @ErrCode = 101
	RETURN
END

IF (@v153discount_51 < 0 OR @v153discount_51 > 0.04)
BEGIN		
	SELECT @ErrMsg = 	CASE @Language 
						WHEN 'E' THEN 'Invalid commission rate (Aust Harness).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](7,@Language)
				END, @ErrCode = 101
	RETURN
END


/************************************
	Validate PT
*************************************/

--check a2<=a4 
select @ErrType = ''
select @ErrType = @ErrType + sportname + '-'+ typenamee + '-Max: '+ cast((scs.apositiontaking) as varchar(10))
+ case when b.sporttype=1 and b.bettype in (1,3,7,8) and scs.islive = 1 then '-MaxLive: '+ cast((scs.apositiontaking) as varchar(10)) else '' end + '<br>'
from customer as c with (NOLOCK) inner join dep_custsetting as scs with (NOLOCK) on c.srecommend = scs.custid inner join 
	(
					select 1 as bettype, 1 as sporttype, @v1apositiontaking_1 as apositiontaking, @v1alivepositiontaking_1 as alivepositiontaking, @v1mpositiontaking_1 as mpositiontaking, @v1mlivepositiontaking_1 as mlivepositiontaking
		union all 	select 3 as bettype, 1 as sporttype, @v1apositiontaking_3 as apositiontaking, @v1alivepositiontaking_3 as alivepositiontaking, @v1mpositiontaking_3 as mpositiontaking, @v1mlivepositiontaking_3 as mlivepositiontaking
		union all 	select 7 as bettype, 1 as sporttype, @v1apositiontaking_7 as apositiontaking, @v1alivepositiontaking_7 as alivepositiontaking, @v1mpositiontaking_7 as mpositiontaking, @v1mlivepositiontaking_7 as mlivepositiontaking
		union all 	select 8 as bettype, 1 as sporttype, @v1apositiontaking_8 as apositiontaking, @v1alivepositiontaking_8 as alivepositiontaking, @v1mpositiontaking_8 as mpositiontaking, @v1mlivepositiontaking_8 as mlivepositiontaking
		union all 	select 2 as bettype, 1 as sporttype, @v1apositiontaking_2 as apositiontaking, 0 as alivepositiontaking, @v1mpositiontaking_2 as mpositiontaking, 0 as mlivepositiontaking
		union all 	select 4 as bettype, 1 as sporttype, @v1apositiontaking_4 as apositiontaking, 0 as alivepositiontaking, @v1mpositiontaking_4 as mpositiontaking, 0 as mlivepositiontaking
		union all 	select 5 as bettype, 1 as sporttype, @v1apositiontaking_5 as apositiontaking, 0 as alivepositiontaking, @v1mpositiontaking_5 as mpositiontaking, 0 as mlivepositiontaking
		union all 	select 6 as bettype, 1 as sporttype, @v1apositiontaking_6 as apositiontaking, 0 as alivepositiontaking, @v1mpositiontaking_6 as mpositiontaking, 0 as mlivepositiontaking
		union all 	select 9 as bettype, 1 as sporttype, @v1apositiontaking_9 as apositiontaking, 0 as alivepositiontaking, @v1mpositiontaking_9 as mpositiontaking, 0 as mlivepositiontaking
		union all 	select 10 as bettype, 1 as sporttype, @v1apositiontaking_10 as apositiontaking, 0 as alivepositiontaking, @v1mpositiontaking_10 as mpositiontaking, 0 as mlivepositiontaking
		) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
	inner join @tmp_Sports sports on b.sporttype = sports.sporttype
	inner join @tmp_Bettype bettype on b.bettype = bettype.typeid
where c.custid = @recommend and 
	(b.apositiontaking>scs.apositiontaking or (b.sporttype = 1 and b.bettype in (1,3,7,8) and scs.islive = 1 and b.apositiontaking>scs.apositiontaking))

if @ErrType <>''
BEGIN
	select @ErrCode = 11
	Select @ErrMsg = 	@UserName + ': '+
				case @Language 
						when 'E' then 'Wrong position taking (max set by company).<br>'+@ErrType
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20005,@Language) + '<br>' + @ErrType
				end
	return
END

--a1+m1<=m3
	select @ErrAcc = ''
	select top 100 @ErrAcc = @ErrAcc + username +', '
	from 
		custinfo as c with (NOLOCK) 
		inner join dep_custsetting as cs with (NOLOCK) on c.custid = cs.custid
		inner join (
	
				select 		1 as sporttype, 1 as bettype, @v1apositiontaking_1 as maxpositiontaking,  @v1mlivepositiontaking_1 as maxlivepositiontaking
				union all select 	1 as sporttype, 2 as bettype, @v1apositiontaking_2 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	1 as sporttype, 3 as bettype, @v1apositiontaking_3 as maxpositiontaking,  @v1alivepositiontaking_3 as maxlivepositiontaking
				union all select 	1 as sporttype, 4 as bettype, @v1apositiontaking_4 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	1 as sporttype, 5 as bettype, @v1apositiontaking_5 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	1 as sporttype, 6 as bettype, @v1apositiontaking_6 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	1 as sporttype, 7 as bettype, @v1apositiontaking_7 as maxpositiontaking,  @v1alivepositiontaking_7 as maxlivepositiontaking
				union all select 	1 as sporttype, 8 as bettype, @v1apositiontaking_8 as maxpositiontaking,  @v1alivepositiontaking_8 as maxlivepositiontaking
				union all select 	1 as sporttype, 9 as bettype, @v1apositiontaking_9 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	1 as sporttype, 10 as bettype, @v1apositiontaking_10 as maxpositiontaking,  0 as maxlivepositiontaking
			) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
	where c.mrecommend = @custid and c.roleid = 1 and ((cs.apositiontaking+cs.mpositiontaking>b.maxpositiontaking AND cs.islive = 0) or (b.sporttype=1 and b.bettype in (1,3,7,8) AND cs.islive = 1 and cs.apositiontaking+cs.mpositiontaking>b.maxlivepositiontaking))
	group by username
	if @ErrAcc<>''
	BEGIN
		select @ErrCode = 9
		Select @ErrMsg = 	case @Language 
							when 'E' then 'Existing members exceeded new master position taking ('+@ErrAcc+') (for Soccer).'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20012,@Language) + ' ('+@ErrAcc+') (' + [dbo].[f_Get_SportNameBySporttype](1,@Language) + ')'
					end
		return
	END

--check a2<=a4
select @ErrType = ''
select @ErrType = @ErrType + sportname + '-'+ typenamee + '-Max: '+ cast((scs.apositiontaking) as varchar(10)) + '<br>'
from customer as c with (NOLOCK) inner join dep_custsetting as scs with (NOLOCK) on c.srecommend = scs.custid inner join 
	(
				 	select 1 as bettype, 2 as sporttype, @v2apositiontaking_1 as apositiontaking, 0 as alivepositiontaking, @v2mpositiontaking_1 as mpositiontaking, 0 as mlivepositiontaking
		union all 	select 2 as bettype, 2 as sporttype, @v2apositiontaking_2 as apositiontaking, 0 as alivepositiontaking, @v2mpositiontaking_2 as mpositiontaking, 0 as mlivepositiontaking
		union all 	select 3 as bettype, 2 as sporttype, @v2apositiontaking_3 as apositiontaking, 0 as alivepositiontaking, @v2mpositiontaking_3 as mpositiontaking, 0 as mlivepositiontaking
		union all 	select 20 as bettype, 2 as sporttype, @v2apositiontaking_20 as apositiontaking, 0 as alivepositiontaking, @v2mpositiontaking_20 as mpositiontaking, 0 as mlivepositiontaking
	
	) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
	inner join @tmp_Sports sports on b.sporttype = sports.sporttype
	inner join @tmp_Bettype bettype on b.bettype = bettype.typeid
where c.custid = @recommend and (b.apositiontaking>scs.apositiontaking)
if @ErrType <>''
BEGIN
	select @ErrCode = 12
	Select @ErrMsg = 	@UserName + ': '+
				case @Language 
						when 'E' then 'Wrong position taking (max set by company).<br>'+@ErrType
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20005,@Language) + '<br>' + @ErrType
				end
	return
END

--check a2<=a4
select @ErrType = ''
select @ErrType = @ErrType + sportname + '-'+ typenamee + '-Max: '+ cast((scs.apositiontaking) as varchar(10)) + '<br>'
from customer as c with (NOLOCK) inner join dep_custsetting as scs with (NOLOCK) on c.srecommend = scs.custid inner join 
	(
				select 1 as bettype, 3 as sporttype, @v3apositiontaking_1 as apositiontaking, 0 as alivepositiontaking, @v3mpositiontaking_1 as mpositiontaking, 0 as mlivepositiontaking
		union all 	select 2 as bettype, 3 as sporttype, @v3apositiontaking_2 as apositiontaking, 0 as alivepositiontaking, @v3mpositiontaking_2 as mpositiontaking, 0 as mlivepositiontaking
		union all 	select 3 as bettype, 3 as sporttype, @v3apositiontaking_3 as apositiontaking, 0 as alivepositiontaking, @v3mpositiontaking_3 as mpositiontaking, 0 as mlivepositiontaking
		union all 	select 20 as bettype, 3 as sporttype, @v3apositiontaking_20 as apositiontaking, 0 as alivepositiontaking, @v3mpositiontaking_20 as mpositiontaking, 0 as mlivepositiontaking
	) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
	inner join @tmp_Sports sports on b.sporttype = sports.sporttype
	inner join @tmp_Bettype bettype on b.bettype = bettype.typeid
where c.custid = @recommend and (b.apositiontaking>scs.apositiontaking)
if @ErrType <>''
BEGIN
	select @ErrCode = 12
	Select @ErrMsg = 	@UserName + ': '+
				case @Language 
						when 'E' then 'Wrong position taking (max set by company).<br>'+@ErrType
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20005,@Language) + '<br>' + @ErrType
				end
	return
END

--check a2<=a4
select @ErrType = ''
select @ErrType = @ErrType + sportname + '-'+ typenamee + '-Max: '+ cast((scs.apositiontaking) as varchar(10)) + '<br>'
from custinfo as c with (NOLOCK) inner join dep_custsetting as scs with (NOLOCK) on c.srecommend = scs.custid inner join 
	(
				select 1 as bettype, 5 as sporttype, @v5apositiontaking_1 as apositiontaking, 0 as alivepositiontaking, @v5mpositiontaking_1 as mpositiontaking, 0 as mlivepositiontaking
		union all 	select 2 as bettype, 5 as sporttype, @v5apositiontaking_2 as apositiontaking, 0 as alivepositiontaking, @v5mpositiontaking_2 as mpositiontaking, 0 as mlivepositiontaking
		union all 	select 3 as bettype, 5 as sporttype, @v5apositiontaking_3 as apositiontaking, 0 as alivepositiontaking, @v5mpositiontaking_3 as mpositiontaking, 0 as mlivepositiontaking
		union all 	select 20 as bettype, 5 as sporttype, @v5apositiontaking_20 as apositiontaking, 0 as alivepositiontaking, @v5mpositiontaking_20 as mpositiontaking, 0 as mlivepositiontaking
	) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
	inner join @tmp_Sports sports on b.sporttype = sports.sporttype
	inner join @tmp_Bettype bettype on b.bettype = bettype.typeid
where c.custid = @recommend and (b.apositiontaking>scs.apositiontaking)
if @ErrType <>''
BEGIN
	select @ErrCode = 12
	Select @ErrMsg = @UserName + ': '+
				case @Language 
						when 'E' then 'Wrong position taking (max set by company).<br>'+@ErrType
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20005,@Language) + '<br>' + @ErrType
				end
	return
END

--check a2<=a4
select @ErrType = ''
select @ErrType = @ErrType + sportname + '-'+ typenamee + '-Max: '+ cast((scs.apositiontaking) as varchar(10)) + '<br>'
from customer as c with (NOLOCK) inner join dep_custsetting as scs with (NOLOCK) on c.srecommend = scs.custid inner join 
	(
				select 1 as bettype, 8 as sporttype, @v8apositiontaking_1 as apositiontaking, 0 as alivepositiontaking, @v8mpositiontaking_1 as mpositiontaking, 0 as mlivepositiontaking
		union all 	select 3 as bettype, 8 as sporttype, @v8apositiontaking_3 as apositiontaking, 0 as alivepositiontaking, @v8mpositiontaking_3 as mpositiontaking, 0 as mlivepositiontaking
		union all 	select 20 as bettype, 8 as sporttype, @v8apositiontaking_20 as apositiontaking, 0 as alivepositiontaking, @v8mpositiontaking_20 as mpositiontaking, 0 as mlivepositiontaking
	) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
	inner join @tmp_Sports sports on b.sporttype = sports.sporttype
	inner join @tmp_Bettype bettype on b.bettype = bettype.typeid
where c.custid = @recommend and (b.apositiontaking>scs.apositiontaking)
if @ErrType <>''
BEGIN
	select @ErrCode = 12
	Select @ErrMsg = @UserName + ': '+
				case @Language 
						when 'E' then 'Wrong position taking (max set by company).<br>'+@ErrType
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20005,@Language) + '<br>' + @ErrType
				end
	return
END

--check a2<=a4
select @ErrType = ''
select @ErrType = @ErrType + sportname + '-'+ typenamee + '-Max: '+ cast((scs.apositiontaking) as varchar(10)) + '<br>'
from custinfo as c with (NOLOCK) inner join dep_custsetting as scs with (NOLOCK) on c.srecommend = scs.custid inner join 
	(
				select 1 as bettype, 10 as sporttype, @v10apositiontaking_1 as apositiontaking, 0 as alivepositiontaking, @v10mpositiontaking_1 as mpositiontaking, 0 as mlivepositiontaking
		union all 	select 2 as bettype, 10 as sporttype, @v10apositiontaking_2 as apositiontaking, 0 as alivepositiontaking, @v10mpositiontaking_2 as mpositiontaking, 0 as mlivepositiontaking
		union all 	select 3 as bettype, 10 as sporttype, @v10apositiontaking_3 as apositiontaking, 0 as alivepositiontaking, @v10mpositiontaking_3 as mpositiontaking, 0 as mlivepositiontaking
		union all 	select 20 as bettype, 10 as sporttype, @v10apositiontaking_20 as apositiontaking, 0 as alivepositiontaking, @v10mpositiontaking_20 as mpositiontaking, 0 as mlivepositiontaking
	) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
	inner join @tmp_Sports sports on b.sporttype = sports.sporttype
	inner join @tmp_Bettype bettype on b.bettype = bettype.typeid
where c.custid = @recommend and (b.apositiontaking>scs.apositiontaking)
if @ErrType <>''
BEGIN
	select @ErrCode = 12
	Select @ErrMsg = 	@UserName + ': '+
				case @Language 
						when 'E' then 'Wrong position taking (max set by company).<br>'+@ErrType
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20005,@Language) + '<br>' + @ErrType
				end
	return
END

--check a2<=a4
select @ErrType = ''
select @ErrType = @ErrType + sportname + '-'+ typenamee + '-Max: '+ cast((scs.apositiontaking) as varchar(10)) + '<br>'
from custinfo as c with (NOLOCK) inner join dep_custsetting as scs with (NOLOCK) on c.srecommend = scs.custid inner join 
	(
				select 1 as bettype, 11 as sporttype, @v11apositiontaking_1 as apositiontaking, 0 as alivepositiontaking, @v11mpositiontaking_1 as mpositiontaking, 0 as mlivepositiontaking
		union all 	select 20 as bettype, 11 as sporttype, @v11apositiontaking_20 as apositiontaking, 0 as alivepositiontaking, @v11mpositiontaking_20 as mpositiontaking, 0 as mlivepositiontaking
	) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
	inner join @tmp_Sports sports on b.sporttype = sports.sporttype
	inner join @tmp_Bettype bettype on b.bettype = bettype.typeid
where c.custid = @recommend and (b.apositiontaking>scs.apositiontaking)
if @ErrType <>''
BEGIN
	select @ErrCode = 12
	Select @ErrMsg = @UserName + ': '+
				case @Language 
						when 'E' then 'Wrong position taking (max set by company).<br>'+@ErrType
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20005,@Language) + '<br>' + @ErrType
				end
	return
END
---44
--check a2<=a4
select @ErrType = ''
select @ErrType = @ErrType + sportname + '-'+ typenamee + '-Max: '+ cast((scs.apositiontaking) as varchar(10)) + '<br>'
from custinfo as c with (NOLOCK) inner join dep_custsetting as scs with (NOLOCK) on c.srecommend = scs.custid inner join 
	(
				select 3 as bettype, 44 as sporttype, @v44apositiontaking_3 as apositiontaking, 0 as alivepositiontaking, @v44mpositiontaking_3 as mpositiontaking, 0 as mlivepositiontaking
		
	) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
	inner join @tmp_Sports sports on b.sporttype = sports.sporttype
	inner join @tmp_Bettype bettype on b.bettype = bettype.typeid
where c.custid = @recommend and (b.apositiontaking>scs.apositiontaking)
if @ErrType <>''
BEGIN
	select @ErrCode = 12
	Select @ErrMsg = @UserName + ': '+
				case @Language 
						when 'E' then 'Wrong position taking (max set by company).<br>'+@ErrType
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20005,@Language) + '<br>' + @ErrType
				end
	return
END
---
--check a2<=a4
select @ErrType = ''
select @ErrType = @ErrType + sportname + '-'+ typenamee + '-Max: '+ cast((scs.apositiontaking) as varchar(10)) + '<br>'
from custinfo as c with (NOLOCK) inner join dep_custsetting as scs with (NOLOCK) on c.srecommend = scs.custid inner join 
	(
				select 1 as bettype, 99 as sporttype, @v99apositiontaking_1 as apositiontaking, 0 as alivepositiontaking, @v99mpositiontaking_1 as mpositiontaking, 0 as mlivepositiontaking
		union all 	select 2 as bettype, 99 as sporttype, @v99apositiontaking_2 as apositiontaking, 0 as alivepositiontaking, @v99mpositiontaking_2 as mpositiontaking, 0 as mlivepositiontaking
		union all 	select 3 as bettype, 99 as sporttype, @v99apositiontaking_3 as apositiontaking, 0 as alivepositiontaking, @v99mpositiontaking_3 as mpositiontaking, 0 as mlivepositiontaking
		union all 	select 20 as bettype, 99 as sporttype, @v99apositiontaking_20 as apositiontaking, 0 as alivepositiontaking, @v99mpositiontaking_20 as mpositiontaking, 0 as mlivepositiontaking
	) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
	inner join @tmp_Sports sports on b.sporttype = sports.sporttype
	inner join @tmp_Bettype bettype on b.bettype = bettype.typeid
where c.custid = @recommend and (b.apositiontaking>scs.apositiontaking)
if @ErrType <>''
BEGIN
	select @ErrCode = 12
	Select @ErrMsg = @UserName + ': '+
				case @Language 
						when 'E' then 'Wrong position taking (max set by company).<br>'+@ErrType
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20005,@Language) + '<br>' + @ErrType
				end
	return
END

--check a2<=a4
select @ErrType = ''
select @ErrType = @ErrType + sportname + '-'+ typenamee + '-Max: '+ cast((scs.apositiontaking) as varchar(10)) + '<br>'
from custinfo as c with (NOLOCK) inner join dep_custsetting as scs with (NOLOCK) on c.srecommend = scs.custid inner join 
	(
		select 20 as bettype, 154 as sporttype, @v154apositiontaking_20 as apositiontaking, 0 as alivepositiontaking, @v154mpositiontaking_20 as mpositiontaking, 0 as mlivepositiontaking
	) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
	inner join @tmp_Sports sports on b.sporttype = sports.sporttype
	inner join @tmp_Bettype bettype on b.bettype = bettype.typeid
where c.custid = @recommend and (b.apositiontaking>scs.apositiontaking)
if @ErrType <>''
BEGIN
	select @ErrCode = 12
	Select @ErrMsg = @UserName + ': '+
				case @Language 
						when 'E' then 'Wrong position taking (max set by company).<br>'+@ErrType
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20005,@Language) + '<br>' + @ErrType
				end
	return
END

--check a2<=a4 
select @ErrType = ''
select @ErrType = @ErrType + sportname + '-'+ typenamee + '-Max: '+ cast((scs.apositiontaking) as varchar(10)) + '<br>'
from custinfo as c with (NOLOCK) inner join dep_custsetting as scs with (NOLOCK) on c.srecommend = scs.custid inner join 
	(
		select 9 as bettype, 99 as sporttype, @v99apositiontaking_9 as apositiontaking, 0 as alivepositiontaking, @v99mpositiontaking_9 as mpositiontaking, 0 as mlivepositiontaking
	) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
	inner join @tmp_Sports sports on b.sporttype = sports.sporttype
	inner join @tmp_Bettype bettype on b.bettype = bettype.typeid
where c.custid = @recommend and (b.apositiontaking>scs.apositiontaking)
if @ErrType <>''
BEGIN
	select @ErrCode = 12
	Select @ErrMsg = @UserName + ': '+
				case @Language 
						when 'E' then 'Wrong position taking (max set by company).<br>'+@ErrType
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20005,@Language) + '<br>' + @ErrType
				end
	return
END

--check a2<=a4 
select @ErrType = ''
select @ErrType = @ErrType + sportname + '-'+ typenamee + '-Max: '+ cast((cs3.apositiontaking) as varchar(10))
+ case when b.sporttype=161 and b.bettype in (85,86,87,89) and cs3.islive = 1 then '-MaxLive: '+ cast((cs3.apositiontaking) as varchar(10)) else '' end + '<br>'
from customer as c with (NOLOCK) inner join dep_custsetting3rd as cs3 with (NOLOCK) on c.srecommend = cs3.custid inner join 
	(
					select 81 as bettype, 161 as sporttype, @v161apositiontaking_81 as apositiontaking, 0 as alivepositiontaking, @v161mpositiontaking_81 as mpositiontaking, 0 as mlivepositiontaking
		union all	select 83 as bettype, 161 as sporttype, @v161apositiontaking_83 as apositiontaking, 0 as alivepositiontaking, @v161mpositiontaking_83 as mpositiontaking, 0 as mlivepositiontaking
		union all	select 85 as bettype, 161 as sporttype, 0 as apositiontaking, @v161alivepositiontaking_85 as alivepositiontaking, 0 as mpositiontaking, @v161mlivepositiontaking_85 as mlivepositiontaking
		union all	select 86 as bettype, 161 as sporttype, @v161apositiontaking_86 as apositiontaking, @v161alivepositiontaking_86 as alivepositiontaking, @v161mpositiontaking_86 as mpositiontaking, @v161mlivepositiontaking_86 as mlivepositiontaking
		union all	select 87 as bettype, 161 as sporttype, 0 as apositiontaking, @v161alivepositiontaking_87 as alivepositiontaking, 0 as mpositiontaking, @v161mlivepositiontaking_87 as mlivepositiontaking
		union all	select 88 as bettype, 161 as sporttype, @v161apositiontaking_88 as apositiontaking, 0 as alivepositiontaking, @v161mpositiontaking_88 as mpositiontaking, 0 as mlivepositiontaking
		union all	select 89 as bettype, 161 as sporttype, 0 as apositiontaking, @v161alivepositiontaking_89 as alivepositiontaking, 0 as mpositiontaking, @v161mlivepositiontaking_89 as mlivepositiontaking
		union all	select 90 as bettype, 161 as sporttype, 0 as apositiontaking, @v161alivepositiontaking_90 as alivepositiontaking, 0 as mpositiontaking, @v161mlivepositiontaking_90 as mlivepositiontaking
			
		) as b on cs3.sporttype=b.sporttype and cs3.bettype = b.bettype
	inner join @tmp_Sports sports on b.sporttype = sports.sporttype
	inner join @tmp_Bettype bettype on b.bettype = bettype.typeid
where c.custid = @recommend and 
	((b.apositiontaking>cs3.apositiontaking and cs3.islive = 0) or (b.sporttype = 161 and b.bettype in (85,86,87,89) and islive = 1 and b.alivepositiontaking>cs3.apositiontaking))

if @ErrType <>''
BEGIN
	select @ErrCode = 11
	Select @ErrMsg = 	@UserName + ': '+
				case @Language 
						when 'E' then 'Wrong position taking (max set by company).<br>'+@ErrType
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20005,@Language) + '<br>' + @ErrType
				end
	return
END

-- Horse racing

IF @v151apositiontaking_31 < 0
	or @v151apositiontaking_31 > 0.5
	or @v151apositiontaking_32 < 0
	or @v151apositiontaking_32 > 0.5
	
	
	or @v151apositiontaking_41 < 0
	or @v151apositiontaking_41 > 0.5			
	or @v151apositiontaking_42 < 0
	or @v151apositiontaking_42 > 0.5		
	
	
	or @v151apositiontaking_51 < 0
	or @v151apositiontaking_51 > 0.5
	or @v151apositiontaking_52 < 0
	or @v151apositiontaking_52 > 0.5		
	
	
BEGIN
	select @ErrCode = 8
	Select @ErrMsg = 	@UserName + ': '+
		case @Language 
						when 'E' then 'Wrong position taking.'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20001,@Language)
				end
	return
END		

--check a1<=a4 - Vinh
select @ErrType = ''
select @ErrType = @ErrType + s.SportName + ' - ' +
case when b.bettype = 51 then 'Win.Aust Tote' when b.bettype = 52 then 'Place.Aust Tote' else typenamee end
 + '-Max: '+ cast((scs.apositiontaking) as varchar(10)) + '<br>'
from custinfo as c with (NOLOCK) inner join Dep_CustSetting3rd as scs with (NOLOCK) on c.srecommend = scs.custid inner join 
	(
		 			select 31 as bettype, 151 as sporttype, @v151apositiontaking_31 as apositiontaking
		union all 	select 32 as bettype, 151 as sporttype, @v151apositiontaking_32 as apositiontaking
		union all 	select 41 as bettype, 151 as sporttype, @v151apositiontaking_41 as apositiontaking
		union all 	select 42 as bettype, 151 as sporttype, @v151apositiontaking_42 as apositiontaking
		union all 	select 51 as bettype, 151 as sporttype, @v151apositiontaking_51 as apositiontaking
		union all 	select 52 as bettype, 151 as sporttype, @v151apositiontaking_52 as apositiontaking
	) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
	inner join @tmp_Bettype bettype on b.bettype = bettype.typeid
	inner join @tmp_Sports s on b.sporttype = s.sporttype
where c.custid = @recommend and (b.apositiontaking>scs.apositiontaking )
if @ErrType <>''
BEGIN
	select @ErrCode = 10
	Select @ErrMsg = 	@UserName + ': '+
		case @Language 
						when 'E' then 'Wrong position taking (max set by company).<br>'+@ErrType
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20005,@Language) + '<br>' + @ErrType
				end
	return
END

IF @v152apositiontaking_41 < 0
	or @v152apositiontaking_41 > 0.5
	or @v152apositiontaking_42 < 0
	or @v152apositiontaking_42 > 0.5		
	

	or	@v152apositiontaking_51 < 0
	or @v152apositiontaking_51 > 0.5
	or @v152apositiontaking_52 < 0
	or @v152apositiontaking_52 > 0.5		
	
BEGIN
	select @ErrCode = 8
	Select @ErrMsg = 	@UserName + ': '+
		case @Language 
						when 'E' then 'Wrong position taking.'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20001,@Language)
				end
	return
END	

--check a1<=a4 - Vinh
select @ErrType = ''
select @ErrType = @ErrType + s.SportName + ' - ' +
case when b.bettype = 51 then 'Win.Aust Tote' when b.bettype = 52 then 'Place.Aust Tote' else typenamee end
 + '-Max: '+ cast((scs.apositiontaking) as varchar(10)) + '<br>'
from custinfo as c with (NOLOCK) inner join Dep_CustSetting3rd as scs with (NOLOCK) on c.srecommend = scs.custid inner join 
	(
					select 41 as bettype, 152 as sporttype, @v152apositiontaking_41 as apositiontaking
		union all 	select 42 as bettype, 152 as sporttype, @v152apositiontaking_42 as apositiontaking
		union all 	select 51 as bettype, 152 as sporttype, @v152apositiontaking_51 as apositiontaking
		union all 	select 52 as bettype, 152 as sporttype, @v152apositiontaking_52 as apositiontaking
	) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
	inner join @tmp_Bettype bettype on b.bettype = bettype.typeid
	inner join @tmp_Sports s on b.sporttype = s.sporttype
where c.custid = @recommend and (b.apositiontaking>scs.apositiontaking )
if @ErrType <>''
BEGIN
	select @ErrCode = 10
	Select @ErrMsg = 	@UserName + ': '+
		case @Language 
						when 'E' then 'Wrong position taking (max set by company).<br>'+@ErrType
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20005,@Language) + '<br>' + @ErrType
				end
	return
END		

IF @v153apositiontaking_51 < 0
	or @v153apositiontaking_51 > 0.5

	or	@v153apositiontaking_52 < 0
	or @v153apositiontaking_52 > 0.5
BEGIN
	select @ErrCode = 8
	Select @ErrMsg = 	@UserName + ': '+
		case @Language 
						when 'E' then 'Wrong position taking.'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20001,@Language)
				end
	return
END

--check a1<=a4 - Vinh
select @ErrType = ''
select @ErrType = @ErrType + s.SportName + ' - ' +
case when b.bettype = 51 then 'Win.Aust Tote' when b.bettype = 52 then 'Place.Aust Tote' else typenamee end
 + '-Max: '+ cast((scs.apositiontaking) as varchar(10)) + '<br>'
from custinfo as c with (NOLOCK) inner join Dep_CustSetting3rd as scs with (NOLOCK) on c.srecommend = scs.custid inner join 
	(
					select 51 as bettype, 153 as sporttype, @v153apositiontaking_51 as apositiontaking
		union all 	select 52 as bettype, 153 as sporttype, @v153apositiontaking_52 as apositiontaking
	) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
	inner join @tmp_Bettype bettype on b.bettype = bettype.typeid
	inner join @tmp_Sports s on b.sporttype = s.sporttype
where c.custid = @recommend and (b.apositiontaking>scs.apositiontaking )
if @ErrType <>''
BEGIN
	select @ErrCode = 10
	Select @ErrMsg = 	@UserName + ': '+
		case @Language 
						when 'E' then 'Wrong position taking (max set by company).<br>'+@ErrType
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20005,@Language) + '<br>' + @ErrType
				end
	return
END	

/*----------------------------
UPDATE Customer Info
---------------------------*/
update custinfo with (ROWLOCK, UPDLOCK)
set 	
	MaxPerMatch = @MaxPerMatchv1,
	MaxPerMatch2 = @MaxPerMatchv2,
	MaxPerMatch3 = @MaxPerMatchv3,
	MaxPerMatch5 = @MaxPerMatchv5,
	MaxPerMatch8 = @MaxPerMatchv8,
	MaxPerMatch10 = @MaxPerMatchv10,
	MaxPerMatch11 = @MaxPerMatchv11,
	MaxPerMatch44 = @MaxPerMatchv44,
	MaxPerMatch99 = @MaxPerMatchv99,
	MaxPerMatch154 = @MaxPerMatchv154,
	MaxPerMatch99MP = @MaxPerMatchv99MP,
	MaxPerMatch161 = @MaxPerMatchv161,
	MaxPerBall161 = @MaxPerBallv161,
	maxpermatch151		= @v151MaxPerMatch_31,
	maxpermatch151_OT	= @v151MaxPerMatch_41,
	MaxPerMatch151_AU	= @v151MaxPerMatch_51,
	MaxPerMatch152_UK	= @v152MaxPerMatch_41,
	MaxPerMatch152_AU	= @v152MaxPerMatch_51,
	MaxPerMatch153_AU	= @v153MaxPerMatch_51
where custid = @custid 
if (@@error <> 0)
begin
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end, @ErrCode = 115
	return
end

/*----------------------------
UPDATE Customer Setting
---------------------------*/

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
	
	@v44mpositiontaking_3 = CASE WHEN cs.sporttype = 44 AND cs.bettype = 3 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,
	
	@v99mpositiontaking_1  = CASE WHEN cs.sporttype = 99 AND cs.bettype = 1 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,
	@v99mpositiontaking_2 = CASE WHEN cs.sporttype = 99 AND cs.bettype = 2 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,
	@v99mpositiontaking_3 = CASE WHEN cs.sporttype = 99 AND cs.bettype = 3 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,
	@v99mpositiontaking_20 = CASE WHEN cs.sporttype = 99 AND cs.bettype = 20 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,

	@v154mpositiontaking_20 = CASE WHEN cs.sporttype = 154 AND cs.bettype = 20 AND cs.islive = 0 THEN cs.mpositiontaking ELSE 0 END,

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
	
	@v44spositiontaking_3 = CASE WHEN cs.sporttype = 44 AND cs.bettype = 3 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,
	
	@v99spositiontaking_1  = CASE WHEN cs.sporttype = 99 AND cs.bettype = 1 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,
	@v99spositiontaking_2 = CASE WHEN cs.sporttype = 99 AND cs.bettype = 2 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,
	@v99spositiontaking_3 = CASE WHEN cs.sporttype = 99 AND cs.bettype = 3 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,
	@v99spositiontaking_20 = CASE WHEN cs.sporttype = 99 AND cs.bettype = 20 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,

	@v154spositiontaking_20 = CASE WHEN cs.sporttype = 154 AND cs.bettype = 20 AND cs.islive = 0 THEN cs.spositiontaking ELSE 0 END,

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
WHERE cs.custid = @recommend

UPDATE Dep_CustSetting WITH (ROWLOCK, UPDLOCK)
SET	
	MinBet = case sporttype when 1 then @MinBetv1 when 2 then @MinBetv2 when 3 then @MinBetv3 when 5 then @MinBetv5 when 8 then @MinBetv8 when 10 then @MinBetv10 when 11 then @MinBetv11 when 44 then @MinBetv44 when 99 then (case bettype when 9 then @MinBetv99MP else @MinBetv99 end) when 154 then @MinBetv154 else MinBet end,
	MaxBet = case sporttype when 1 then @MaxBetv1 when 2 then @MaxBetv2 when 3 then @MaxBetv3 when 5 then @MaxBetv5 when 8 then @MaxBetv8 when 10 then @MaxBetv10 when 11 then @MaxBetv11 when 44 then @MaxBetv44 when 99 then (case bettype when 9 then @MaxBetv99MP else @MaxBetv99 end) when 154 then @MaxBetv154 else MaxBet end,
	apositiontaking = CASE
						WHEN sporttype = 1 and bettype = 1 and islive = 0 THEN @v1apositiontaking_1
						WHEN sporttype = 1 and bettype = 2 and islive = 0 THEN @v1apositiontaking_2
						WHEN sporttype = 1 and bettype = 3 and islive = 0 THEN @v1apositiontaking_3
						WHEN sporttype = 1 and bettype = 4 and islive = 0 THEN @v1apositiontaking_4 
						WHEN sporttype = 1 and bettype = 5 and islive = 0 THEN @v1apositiontaking_5
						WHEN sporttype = 1 and bettype = 6 and islive = 0 THEN @v1apositiontaking_6
						WHEN sporttype = 1 and bettype = 7 and islive = 0 THEN @v1apositiontaking_7
						WHEN sporttype = 1 and bettype = 8 and islive = 0 THEN @v1apositiontaking_8
						WHEN sporttype = 1 and bettype = 9 and islive = 0 THEN @v1apositiontaking_9
						WHEN sporttype = 1 and bettype = 10 and islive = 0 THEN @v1apositiontaking_10

						WHEN sporttype = 1 and bettype = 1 and islive = 1 THEN @v1apositiontaking_1
						WHEN sporttype = 1 and bettype = 3 and islive = 1 THEN @v1apositiontaking_3
						WHEN sporttype = 1 and bettype = 7 and islive = 1 THEN @v1apositiontaking_7
						WHEN sporttype = 1 and bettype = 8 and islive = 1 THEN @v1apositiontaking_8

						WHEN sporttype = 2 and bettype = 1 THEN @v2apositiontaking_1 
						WHEN sporttype = 2 and bettype = 2 THEN @v2apositiontaking_2 
						WHEN sporttype = 2 and bettype = 3 THEN @v2apositiontaking_3 
						WHEN sporttype = 2 and bettype = 7 THEN @v2apositiontaking_7 
						WHEN sporttype = 2 and bettype = 8 THEN @v2apositiontaking_8 
						WHEN sporttype = 2 and bettype = 20 THEN @v2apositiontaking_20

						WHEN sporttype = 3 and bettype = 1 THEN @v3apositiontaking_1 
						WHEN sporttype = 3 and bettype = 2 THEN @v3apositiontaking_2 
						WHEN sporttype = 3 and bettype = 3 THEN @v3apositiontaking_3 
						WHEN sporttype = 3 and bettype = 20 THEN @v3apositiontaking_20

						WHEN sporttype = 5 and bettype = 1 THEN @v5apositiontaking_1 
						WHEN sporttype = 5 and bettype = 2 THEN @v5apositiontaking_2 
						WHEN sporttype = 5 and bettype = 3 THEN @v5apositiontaking_3 
						WHEN sporttype = 5 and bettype = 20 THEN @v5apositiontaking_20

						WHEN sporttype = 8 and bettype = 1 THEN @v8apositiontaking_1 
						WHEN sporttype = 8 and bettype = 3 THEN @v8apositiontaking_3 
						WHEN sporttype = 8 and bettype = 20 THEN @v8apositiontaking_20

						WHEN sporttype = 10 and bettype = 1 THEN @v10apositiontaking_1 
						WHEN sporttype = 10 and bettype = 2 THEN @v10apositiontaking_2 
						WHEN sporttype = 10 and bettype = 3 THEN @v10apositiontaking_3 
						WHEN sporttype = 10 and bettype = 20 THEN @v10apositiontaking_20

						WHEN sporttype = 11 and bettype = 1 THEN @v11apositiontaking_1 
						WHEN sporttype = 11 and bettype = 20 THEN @v11apositiontaking_20
						
						WHEN sporttype = 44 and bettype = 3 THEN @v44apositiontaking_3 
						
						WHEN sporttype = 99 and bettype = 1 THEN @v99apositiontaking_1 
						WHEN sporttype = 99 and bettype = 2 THEN @v99apositiontaking_2 
						WHEN sporttype = 99 and bettype = 3 THEN @v99apositiontaking_3 
						WHEN sporttype = 99 and bettype = 9 THEN @v99apositiontaking_9 
						WHEN sporttype = 99 and bettype = 20 THEN @v99apositiontaking_20

						WHEN sporttype = 154 and bettype = 20 THEN @v154apositiontaking_20

					  ELSE
						apositiontaking
					  END,--End Agent PT

	mpositiontaking = CASE
						WHEN sporttype = 1 and bettype = 1 and islive = 0 THEN @v1mpositiontaking_1
						WHEN sporttype = 1 and bettype = 2 and islive = 0 THEN @v1mpositiontaking_2
						WHEN sporttype = 1 and bettype = 3 and islive = 0 THEN @v1mpositiontaking_3
						WHEN sporttype = 1 and bettype = 4 and islive = 0 THEN @v1mpositiontaking_4 
						WHEN sporttype = 1 and bettype = 5 and islive = 0 THEN @v1mpositiontaking_5
						WHEN sporttype = 1 and bettype = 6 and islive = 0 THEN @v1mpositiontaking_6
						WHEN sporttype = 1 and bettype = 7 and islive = 0 THEN @v1mpositiontaking_7
						WHEN sporttype = 1 and bettype = 8 and islive = 0 THEN @v1mpositiontaking_8
						WHEN sporttype = 1 and bettype = 9 and islive = 0 THEN @v1mpositiontaking_9
						WHEN sporttype = 1 and bettype = 10 and islive = 0 THEN @v1mpositiontaking_10

						WHEN sporttype = 1 and bettype = 1 and islive = 1 THEN @v1mpositiontaking_1
						WHEN sporttype = 1 and bettype = 3 and islive = 1 THEN @v1mpositiontaking_3
						WHEN sporttype = 1 and bettype = 7 and islive = 1 THEN @v1mpositiontaking_7
						WHEN sporttype = 1 and bettype = 8 and islive = 1 THEN @v1mpositiontaking_8

						WHEN sporttype = 2 and bettype = 1 THEN @v2mpositiontaking_1 
						WHEN sporttype = 2 and bettype = 2 THEN @v2mpositiontaking_2 
						WHEN sporttype = 2 and bettype = 3 THEN @v2mpositiontaking_3 
						WHEN sporttype = 2 and bettype = 7 THEN @v2mpositiontaking_7 
						WHEN sporttype = 2 and bettype = 8 THEN @v2mpositiontaking_8 
						WHEN sporttype = 2 and bettype = 20 THEN @v2mpositiontaking_20

						WHEN sporttype = 3 and bettype = 1 THEN @v3mpositiontaking_1 
						WHEN sporttype = 3 and bettype = 2 THEN @v3mpositiontaking_2 
						WHEN sporttype = 3 and bettype = 3 THEN @v3mpositiontaking_3 
						WHEN sporttype = 3 and bettype = 20 THEN @v3mpositiontaking_20

						WHEN sporttype = 5 and bettype = 1 THEN @v5mpositiontaking_1 
						WHEN sporttype = 5 and bettype = 2 THEN @v5mpositiontaking_2 
						WHEN sporttype = 5 and bettype = 3 THEN @v5mpositiontaking_3 
						WHEN sporttype = 5 and bettype = 20 THEN @v5mpositiontaking_20

						WHEN sporttype = 8 and bettype = 1 THEN @v8mpositiontaking_1 
						WHEN sporttype = 8 and bettype = 3 THEN @v8mpositiontaking_3 
						WHEN sporttype = 8 and bettype = 20 THEN @v8mpositiontaking_20

						WHEN sporttype = 10 and bettype = 1 THEN @v10mpositiontaking_1 
						WHEN sporttype = 10 and bettype = 2 THEN @v10mpositiontaking_2 
						WHEN sporttype = 10 and bettype = 3 THEN @v10mpositiontaking_3 
						WHEN sporttype = 10 and bettype = 20 THEN @v10mpositiontaking_20

						WHEN sporttype = 11 and bettype = 1 THEN @v11mpositiontaking_1 
						WHEN sporttype = 11 and bettype = 20 THEN @v11mpositiontaking_20
						
						WHEN sporttype = 44 and bettype = 3 THEN @v44mpositiontaking_3 
						
						WHEN sporttype = 99 and bettype = 1 THEN @v99mpositiontaking_1 
						WHEN sporttype = 99 and bettype = 2 THEN @v99mpositiontaking_2 
						WHEN sporttype = 99 and bettype = 3 THEN @v99mpositiontaking_3 
						WHEN sporttype = 99 and bettype = 9 THEN @v99mpositiontaking_9 
						WHEN sporttype = 99 and bettype = 20 THEN @v99mpositiontaking_20

						WHEN sporttype = 154 and bettype = 20 THEN @v154mpositiontaking_20

					  ELSE
						mpositiontaking
					  END--End Maser PT
WHERE custid=@custid

if (@@error <> 0)
begin
	
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end	, @ErrCode = 103 
	return
end

--update 3rd
update dep_custsetting3rd with (ROWLOCK, UPDLOCK)
set	
	MinBet = CASE 
				WHEN sporttype = 161 THEN @MinBetv161 
				WHEN sporttype = 151 AND (bettype = 31 OR bettype = 32) THEN @v151MinBet_31 
				WHEN sporttype = 151 AND (bettype = 41 OR bettype = 42) THEN @v151MinBet_41 
				WHEN sporttype = 151 AND (bettype = 51 OR bettype = 52) THEN @v151MinBet_51 
				WHEN sporttype = 152 AND (bettype = 41 OR bettype = 42) THEN @v152MinBet_41 
				WHEN sporttype = 152 AND (bettype = 51 OR bettype = 52) THEN @v152MinBet_51 
				WHEN sporttype = 153 AND (bettype = 51 OR bettype = 52) THEN @v153MinBet_51 
			 ELSE 
				MinBet
			 END,
	MaxBet = CASE 
				WHEN sporttype = 161 THEN @MaxBetv161 
				WHEN sporttype = 151 AND (bettype = 31 OR bettype = 32) THEN @v151MaxBet_31 
				WHEN sporttype = 151 AND (bettype = 41 OR bettype = 42) THEN @v151MaxBet_41 
				WHEN sporttype = 151 AND (bettype = 51 OR bettype = 52) THEN @v151MaxBet_51 
				WHEN sporttype = 152 AND (bettype = 41 OR bettype = 42) THEN @v152MaxBet_41 
				WHEN sporttype = 152 AND (bettype = 51 OR bettype = 52) THEN @v152MaxBet_51 
				WHEN sporttype = 153 AND (bettype = 51 OR bettype = 52) THEN @v153MaxBet_51 
			 ELSE
				MaxBet
			 END,
	apositiontaking = CASE 
						WHEN  sporttype = 151 AND (bettype = 31 OR bettype = 32) THEN @v151apositiontaking_31 
						WHEN  sporttype = 151 AND (bettype = 41 OR bettype = 42) THEN @v151apositiontaking_41 
						WHEN  sporttype = 151 AND (bettype = 51 OR bettype = 52) THEN @v151apositiontaking_51 
						WHEN  sporttype = 152 AND (bettype = 41 OR bettype = 42) THEN @v152apositiontaking_41 
						WHEN  sporttype = 152 AND (bettype = 51 OR bettype = 52) THEN @v152apositiontaking_51 
						WHEN  sporttype = 153 AND (bettype = 51 OR bettype = 52) THEN @v153apositiontaking_51 

						WHEN sporttype = 161 and bettype = 81 and islive = 0 THEN @v161apositiontaking_81 
						WHEN sporttype = 161 and bettype = 83 and islive = 0 THEN @v161apositiontaking_83 
						WHEN sporttype = 161 and bettype = 86 and islive = 0 THEN @v161apositiontaking_86 
						WHEN sporttype = 161 and bettype = 88 and islive = 0 THEN @v161apositiontaking_88 
						WHEN sporttype = 161 and bettype = 85 and islive = 1 THEN @v161alivepositiontaking_85 
						WHEN sporttype = 161 and bettype = 86 and islive = 1 THEN @v161alivepositiontaking_86 
						WHEN sporttype = 161 and bettype = 87 and islive = 1 THEN @v161alivepositiontaking_87 
						WHEN sporttype = 161 and bettype = 89 and islive = 1 THEN @v161alivepositiontaking_89 
						WHEN sporttype = 161 and bettype = 90 and islive = 1 THEN @v161alivepositiontaking_90 
					ELSE
						apositiontaking
					END,
	mpositiontaking = CASE 
						WHEN  sporttype = 151 AND (bettype = 31 OR bettype = 32) THEN @v151mpositiontaking_31 
						WHEN  sporttype = 151 AND (bettype = 41 OR bettype = 42) THEN @v151mpositiontaking_41 
						WHEN  sporttype = 151 AND (bettype = 51 OR bettype = 52) THEN @v151mpositiontaking_51 
						WHEN  sporttype = 152 AND (bettype = 41 OR bettype = 42) THEN @v152mpositiontaking_41 
						WHEN  sporttype = 152 AND (bettype = 51 OR bettype = 52) THEN @v152mpositiontaking_51 
						WHEN  sporttype = 153 AND (bettype = 51 OR bettype = 52) THEN @v153mpositiontaking_51 

						WHEN sporttype = 161 and bettype = 81 and islive = 0 THEN @v161mpositiontaking_81 
						WHEN sporttype = 161 and bettype = 83 and islive = 0 THEN @v161mpositiontaking_83 
						WHEN sporttype = 161 and bettype = 86 and islive = 0 THEN @v161mpositiontaking_86 
						WHEN sporttype = 161 and bettype = 88 and islive = 0 THEN @v161mpositiontaking_88 
						WHEN sporttype = 161 and bettype = 85 and islive = 1 THEN @v161mlivepositiontaking_85 
						WHEN sporttype = 161 and bettype = 86 and islive = 1 THEN @v161mlivepositiontaking_86 
						WHEN sporttype = 161 and bettype = 87 and islive = 1 THEN @v161mlivepositiontaking_87 
						WHEN sporttype = 161 and bettype = 89 and islive = 1 THEN @v161mlivepositiontaking_89 
						WHEN sporttype = 161 and bettype = 90 and islive = 1 THEN @v161mlivepositiontaking_90 
					ELSE
						mpositiontaking
					END,
	playerdiscount = CASE 
					WHEN  sporttype = 151 AND (bettype = 31 OR bettype = 32) THEN @v151discount_31
					WHEN  sporttype = 151 AND (bettype = 41 OR bettype = 42) THEN @v151discount_41
					WHEN  sporttype = 151 AND (bettype = 51 OR bettype = 52) THEN @v151discount_51
					WHEN  sporttype = 152 AND (bettype = 41 OR bettype = 42) THEN @v152discount_41
					WHEN  sporttype = 152 AND (bettype = 51 OR bettype = 52) THEN @v152discount_51
					WHEN  sporttype = 153 AND (bettype = 51 OR bettype = 52) THEN @v153discount_51
				ELSE
					playerdiscount
				END
WHERE custid=@custid

if (@@error <> 0)
begin
	
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end	, @ErrCode = 104 
	return
end


EXEC Acc_Dep_CustomerUpdMemberVirtualSports_Ag
	@custid  = @custid,
	@userid  = @userid,

	@v180aPositionTaking  = @v180aPositionTaking,
	@v180mPositionTaking  = @v180mPositionTaking,
	@v180sPositionTaking  = @v180sPositionTaking,
	@v180MinBet  = @v180MinBet,
	@v180MaxBet  = @v180MaxBet,
	@v180MaxPerMatch  = @v180MaxPerMatch,

	@v181aPositionTaking  = @v181aPositionTaking,
	@v181mPositionTaking  = @v181mPositionTaking,
	@v181sPositionTaking  = @v181sPositionTaking,
	@v181MinBet  = @v181MinBet,
	@v181MaxBet  = @v181MaxBet,
	@v181MaxPerMatch  = @v181MaxPerMatch,

	@v182aPositionTaking  = @v182aPositionTaking,
	@v182mPositionTaking  = @v182mPositionTaking,
	@v182sPositionTaking  = @v182sPositionTaking,
	@v182MinBet  = @v182MinBet,
	@v182MaxBet  = @v182MaxBet,
	@v182MaxPerMatch  = @v182MaxPerMatch,

	@v183aPositionTaking  = @v183aPositionTaking,
	@v183mPositionTaking  = @v183mPositionTaking,
	@v183sPositionTaking  = @v183sPositionTaking,
	@v183MinBet  = @v183MinBet,
	@v183MaxBet  = @v183MaxBet,
	@v183MaxPerMatch  = @v183MaxPerMatch,

	@v184aPositionTaking  = @v184aPositionTaking,
	@v184mPositionTaking  = @v184mPositionTaking,
	@v184sPositionTaking  = @v184sPositionTaking,
	@v184MinBet  = @v184MinBet,
	@v184MaxBet  = @v184MaxBet,
	@v184MaxPerMatch  = @v184MaxPerMatch,

	@v185aPositionTaking  = @v185aPositionTaking,
	@v185mPositionTaking  = @v185mPositionTaking,
	@v185sPositionTaking  = @v185sPositionTaking,
	@v185MinBet  = @v185MinBet,
	@v185MaxBet  = @v185MaxBet,
	@v185MaxPerMatch  = @v185MaxPerMatch,

	@v186aPositionTaking  = @v186aPositionTaking,
	@v186mPositionTaking  = @v186mPositionTaking,
	@v186sPositionTaking  = @v186sPositionTaking,
	@v186MinBet  = @v186MinBet,
	@v186MaxBet  = @v186MaxBet,
	@v186MaxPerMatch  = @v186MaxPerMatch,
	
	@ErrCode  = @ErrCode OUTPUT,
	@Language  = @Language,
	@ErrMsg  = @ErrMsg OUTPUT

IF @ErrCode <> 0 
	RETURN


--Keno
--Check PT
DECLARE @vMaxPT_1501 money

SELECT @vMaxPT_1501=isnull(apositiontaking,0) 
FROM dbo.CustSettingGame WITH(NOLOCK) 
WHERE CustID= @recommend and Bettype=1501

SELECT IBCBetTypeID AS Bettype,
	   ISNULL(cg.MinBet,0) AS MinBet_Up,
	   ISNULL(cg.MaxBet,0) AS Maxbet_Up ,
	   ISNULL(cg.MaxPerGameType,0) AS MaxPerMatch_UP
INTO #Data_Upline
FROM dbo.CustGameType cg WITH (NOLOCK)  INNER JOIN 
@tmp_GameType gt on cg.GameTypeID=gt.GameTypeID
and cg.CustID=@recommend 

--check PT
IF EXISTS (SELECT top 1 1 FROM #data WHERE aPositionTaking > @vMaxPT_1501 and aPositionTaking > 0)
BEGIN
	Select @ErrMsg = case @Language 
							when 'E' then 'Wrong  position taking.<br>'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20001,@Language) + '<br>'
						end, @ErrCode = 104
	return
END  


DECLARE @Bet MONEY
--check minbet
IF EXISTS (SELECT top 1 1 
			FROM #data d INNER JOIN #data_Upline d2 ON d.Bettype=d2.Bettype
			WHERE ((d.MinBet > d.MaxBet) OR (d.MinBet < d2.MinBet_Up)) and d.MinBet > 0 )
BEGIN
	SELECT @Bet = d2.MinBet_Up FROM #data d INNER JOIN #data_Upline d2 ON d.Bettype=d2.Bettype
			WHERE (d.MinBet > d.MaxBet) OR (d.MinBet < d2.MinBet_Up)
			ORDER BY d.Bettype DESC
	SELECT @ErrMsg = case @Language 
							when 'E' then 'Min Bet must be greater than or equal '+coalesce(cast(@Bet as varchar(50)),space(1))+'1051.<br>'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20001,@Language) + '<br>'
						end, @ErrCode = 104
	return
END

--check maxBet
IF EXISTS (SELECT top 1 1 
			FROM #data d INNER JOIN #data_Upline d2 ON d.Bettype=d2.Bettype
			WHERE (d.MaxBet > d2.MaxPerMatch_UP) and d.MaxBet > 0)
BEGIN
	SELECT @Bet = d2.MaxPerMatch_UP FROM #data d INNER JOIN #data_Upline d2 ON d.Bettype=d2.Bettype
			WHERE (d.MaxBet > d2.MaxPerMatch_UP)
			ORDER BY d.Bettype DESC
	Select @ErrMsg = case @Language 
							when 'E' then 'Max Bet must be less than or equal '+coalesce(cast(@Bet as varchar(50)),space(1))+'.<br>'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20001,@Language) + '<br>'
						end, @ErrCode = 104
	return
END
--check maxpeermatch
IF EXISTS (SELECT top 1 1 
			FROM #data d INNER JOIN #data_Upline d2 ON d.Bettype=d2.Bettype
			WHERE (d.MaxPerMatch > d2.MaxPerMatch_UP) and d.MaxPerMatch > 0)
BEGIN
	SELECT @Bet = d2.MaxPerMatch_UP FROM #data d INNER JOIN #data_Upline d2 ON d.Bettype=d2.Bettype
			WHERE (d.MaxPerMatch > d2.MaxPerMatch_UP)
			ORDER BY d.Bettype DESC
	Select @ErrMsg = case @Language 
							when 'E' then 'Max Per Match must be less than or equal '+coalesce(cast(@Bet as varchar(50)),space(1))+'.<br>'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20001,@Language) + '<br>'
						end, @ErrCode = 104
	return
END

--Update PT
--select * from dbo.CustSettingGame where CustID=137309034 Sporttype=202 and 
UPDATE c SET
	c.apositiontaking=d.aPositionTaking
FROM dbo.CustSettingGame c WITH (ROWLOCK, UPDLOCK) INNER JOIN #data d ON c.Bettype=d.Bettype
WHERE c.CustID=@custid AND c.Sporttype=202 AND d.Bettype=1501
--UPdate BetLimit
--UPDATE dbo.CustGameType SET MinBet=
update g set g.MinBet = d.MinBet
	  ,g.MaxBet = d.MaxBet
	 ,g.MaxPerGameType = d.MaxPerMatch	
FROM CustGameType g WITH (ROWLOCK, UPDLOCK) INNER JOIN @tmp_GameType gt on g.GameTypeID=gt.GameTypeID
	 INNER JOIN #data d ON d.Bettype=gt.IBCBetTypeID
where CustID=@custID 
IF (@@error <> 0)
BEGIN
	
	SELECT @ErrMsg = CASE @Language 
						WHEN 'E' THEN 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					END	, @ErrCode = 104 
	RETURN
END

set @endRun = getdate()
set @duration  = datediff (millisecond,@startRun,@endRun)
-- Write log
Declare @LogSPData varchar(5000)
Declare @LogSPData2 varchar(5000)

--write log keno
DECLARE @str_bet varchar(1000)='',
		@str_spt varchar(1000)='',
		@str_mpt varchar(1000)='',
		@str_apt varchar(1000)='',
		@i INT=1501,
		@j INT=(select max(bettype) from #data)
WHILE (@i<=@j)
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

Select @LogSPData ='<Acc_Dep_CustomerUpdMember_Ag>' +
'<SportsBook custid="'+ coalesce(cast(@custid as varchar(50)),space(1))+ '" ' +
'UserID="'+ coalesce(cast(@UserID as varchar(50)),space(1))+ '" ' +
'Language="'+ coalesce(cast(@Language as varchar(2)),space(1))+ '" ' +
'IP="'+ coalesce(cast(@IP as varchar(15)),space(1))+ '" ' +
'ErrCode="'+ coalesce(cast(@ErrCode as varchar(50)),space(1)) + '" ' +
'ErrMsg="'+ coalesce(cast(@ErrMsg as varchar(5000)),space(1)) + '" ' +

'MinBv1="'+ coalesce(cast(@MinBetv1 as varchar(50)),space(1))+ '" ' +
'MaxBv1="'+ coalesce(cast(@MaxBetv1 as varchar(50)),space(1))+ '" ' +
'MPMv1="'+ coalesce(cast(@MaxPerMatchv1 as varchar(50)),space(1))+ '" ' +
'MinBv2="'+ coalesce(cast(@MinBetv2 as varchar(50)),space(1))+ '" ' +
'MaxBv2="'+ coalesce(cast(@MaxBetv2 as varchar(50)),space(1))+ '" ' +
'MPMv2="'+ coalesce(cast(@MaxPerMatchv2 as varchar(50)),space(1))+ '" ' +
'MinBv3="'+ coalesce(cast(@MinBetv3 as varchar(50)),space(1))+ '" ' +
'MaxBv3="'+ coalesce(cast(@MaxBetv3 as varchar(50)),space(1))+ '" ' +
'MPMv3="'+ coalesce(cast(@MaxPerMatchv3 as varchar(50)),space(1))+ '" ' +
'MinBv5="'+ coalesce(cast(@MinBetv5 as varchar(50)),space(1))+ '" ' +
'MaxBv5="'+ coalesce(cast(@MaxBetv5 as varchar(50)),space(1))+ '" ' +
'MPMv5="'+ coalesce(cast(@MaxPerMatchv5 as varchar(50)),space(1))+ '" ' +
'MinBv8="'+ coalesce(cast(@MinBetv8 as varchar(50)),space(1))+ '" ' +
'MaxBv8="'+ coalesce(cast(@MaxBetv8 as varchar(50)),space(1))+ '" ' +
'MPMv8="'+ coalesce(cast(@MaxPerMatchv8 as varchar(50)),space(1))+ '" ' +
'MinBv10="'+ coalesce(cast(@MinBetv10 as varchar(50)),space(1))+ '" ' +
'MaxBv10="'+ coalesce(cast(@MaxBetv10 as varchar(50)),space(1))+ '" ' +
'MPMv10="'+ coalesce(cast(@MaxPerMatchv10 as varchar(50)),space(1))+ '" ' +
'MinBv11="'+ coalesce(cast(@MinBetv11 as varchar(50)),space(1))+ '" ' +
'MaxBv11="'+ coalesce(cast(@MaxBetv11 as varchar(50)),space(1))+ '" ' +
'MPMv11="'+ coalesce(cast(@MaxPerMatchv11 as varchar(50)),space(1))+ '" ' +
--
'MinBv44="'+ coalesce(cast(@MinBetv44 as varchar(50)),space(1))+ '" ' +
'MaxBv44="'+ coalesce(cast(@MaxBetv44 as varchar(50)),space(1))+ '" ' +
'MPMv44="'+ coalesce(cast(@MaxPerMatchv44 as varchar(50)),space(1))+ '" ' +

'MinBv99="'+ coalesce(cast(@MinBetv99 as varchar(50)),space(1))+ '" ' +
'MaxBv99="'+ coalesce(cast(@MaxBetv99 as varchar(50)),space(1))+ '" ' +
'MPMv99="'+ coalesce(cast(@MaxPerMatchv99 as varchar(50)),space(1))+ '" ' +
'MinBv154="'+ coalesce(cast(@MinBetv154 as varchar(50)),space(1))+ '" ' +
'MaxBv154="'+ coalesce(cast(@MaxBetv154 as varchar(50)),space(1))+ '" ' +
'MPMv154="'+ coalesce(cast(@MaxPerMatchv154 as varchar(50)),space(1))+ '" ' +

'MinBv161="'+ coalesce(cast(@MinBetv161 as varchar(50)),space(1))+ '" ' +
'MaxBv161="'+ coalesce(cast(@MaxBetv161 as varchar(50)),space(1))+ '" ' +
'MPMv161="'+ coalesce(cast(@MaxPerMatchv161 as varchar(50)),space(1))+ '" ' +
'MPBv161="' + coalesce(cast(@MaxPerBallv161 as varchar(50)),space(1)) + '" ' +
'MinBv99MP="'+ coalesce(cast(@MinBetv99MP as varchar(50)),space(1))+ '" ' +
'MaxBv99MP="'+ coalesce(cast(@MaxBetv99MP as varchar(50)),space(1))+ '" ' +
'MPMv99MP="'+ coalesce(cast(@MaxPerMatchv99MP as varchar(50)),space(1))+ '" ' +
'v151MinB_31="'+ coalesce(cast(@v151MinBet_31 as varchar(50)),space(1)) + '" ' +
'v151MaxB_31="'+ coalesce(cast(@v151MaxBet_31 as varchar(50)),space(1)) + '" ' +
'v151MPM_31="'+ coalesce(cast(@v151MaxPerMatch_31 as varchar(50)),space(1)) + '" ' +
'v151MinB_41="'+ coalesce(cast(@v151MinBet_41 as varchar(50)),space(1)) + '" ' +
'v151MaxB_41="'+ coalesce(cast(@v151MaxBet_41 as varchar(50)),space(1)) + '" ' +
'v151MPM_41="'+ coalesce(cast(@v151MaxPerMatch_41 as varchar(50)),space(1)) + '" ' +
'v151MinB_51="'+ coalesce(cast(@v151MinBet_51 as varchar(50)),space(1)) + '" ' +
'v151MaxB_51="'+ coalesce(cast(@v151MaxBet_51 as varchar(50)),space(1)) + '" ' +
'v151MPM_51="'+ coalesce(cast(@v151MaxPerMatch_51 as varchar(50)),space(1)) + '" ' +
'v152MinB_41="'+ coalesce(cast(@v152MinBet_41 as varchar(50)),space(1)) + '" ' +
'v152MaxB_41="'+ coalesce(cast(@v152MaxBet_41 as varchar(50)),space(1)) + '" ' +
'v152MPM_41="'+ coalesce(cast(@v152MaxPerMatch_41 as varchar(50)),space(1)) + '" ' +
'v152MinB_51="'+ coalesce(cast(@v152MinBet_51 as varchar(50)),space(1)) + '" ' +
'v152MaxB_51="'+ coalesce(cast(@v152MaxBet_51 as varchar(50)),space(1)) + '" ' +
'v152MPM_51="'+ coalesce(cast(@v152MaxPerMatch_51 as varchar(50)),space(1)) + '" ' +
'v153MinB_51="'+ coalesce(cast(@v153MinBet_51 as varchar(50)),space(1)) + '" ' +
'v153MaxB_51="'+ coalesce(cast(@v153MaxBet_51 as varchar(50)),space(1)) + '" ' +
'v153MPM_51="'+ coalesce(cast(@v153MaxPerMatch_51 as varchar(50)),space(1)) + '" ' +
'/>' +
'<VirtualSports ' +
'v180MinB="'+ coalesce(cast(@v180MinBet as varchar(50)),space(1)) + '" ' +
'v180MaxB="'+ coalesce(cast(@v180MaxBet as varchar(50)),space(1)) + '" ' +
'v180MPM="'+ coalesce(cast(@v180MaxPerMatch as varchar(50)),space(1)) + '" ' +

'v181MinB="'+ coalesce(cast(@v181MinBet as varchar(50)),space(1)) + '" ' +
'v181MaxB="'+ coalesce(cast(@v181MaxBet as varchar(50)),space(1)) + '" ' +
'v181MPM="'+ coalesce(cast(@v181MaxPerMatch as varchar(50)),space(1)) + '" ' +

'v182MinB="'+ coalesce(cast(@v182MinBet as varchar(50)),space(1)) + '" ' +
'v182MaxB="'+ coalesce(cast(@v182MaxBet as varchar(50)),space(1)) + '" ' +
'v182MPM="'+ coalesce(cast(@v182MaxPerMatch as varchar(50)),space(1)) + '" ' +

'v183MinB="'+ coalesce(cast(@v183MinBet as varchar(50)),space(1)) + '" ' +
'v183MaxB="'+ coalesce(cast(@v183MaxBet as varchar(50)),space(1)) + '" ' +
'v183MPM="'+ coalesce(cast(@v183MaxPerMatch as varchar(50)),space(1)) + '" ' +

'v184MinB="'+ coalesce(cast(@v184MinBet as varchar(50)),space(1)) + '" ' +
'v184MaxB="'+ coalesce(cast(@v184MaxBet as varchar(50)),space(1)) + '" ' +
'v184MPM="'+ coalesce(cast(@v184MaxPerMatch as varchar(50)),space(1)) + '" ' +

'v185MinB="'+ coalesce(cast(@v185MinBet as varchar(50)),space(1)) + '" ' +
'v185MaxB="'+ coalesce(cast(@v185MaxBet as varchar(50)),space(1)) + '" ' +
'v185MPM="'+ coalesce(cast(@v185MaxPerMatch as varchar(50)),space(1)) + '" ' +

'v186MinB="'+ coalesce(cast(@v186MinBet as varchar(50)),space(1)) + '" ' +
'v186MaxB="'+ coalesce(cast(@v186MaxBet as varchar(50)),space(1)) + '" ' +
'v186MPM="'+ coalesce(cast(@v186MaxPerMatch as varchar(50)),space(1)) + '" ' +
'/>'+
'<Keno '+
@str_bet+
'/>' +
'</Acc_Dep_CustomerUpdMember_Ag>'

BEGIN
	DECLARE @sql varchar (MAX)
	DECLARE @TEXT varchar (4000) =''
	SELECT @sql='<Acc_Dep_CustomerUpdMember_Ag> ' +
		'<SportsBook custid="'+ coalesce(cast(@custid as varchar(50)),space(1))+ '" ' +
					'UserID="'+ coalesce(cast(@UserID as varchar(50)),space(1))+ '" ' +
					'Language="'+ coalesce(cast(@Language as varchar(2)),space(1))+ '" ' +
					'IP="'+ coalesce(cast(@IP as varchar(15)),space(1))+ '" ' +
					'ErrCode="'+ coalesce(cast(@ErrCode as varchar(50)),space(1)) + '" ' +
					'ErrMsg="'+ coalesce(cast(@ErrMsg as varchar(5000)),space(1)) + '" ' 
	Select @TEXT= @TEXT +
				'MinBv'+ cast(Sporttype as varchar(10))+'="'+ coalesce(cast(MinB as varchar(50)),space(1))+ '" ' +
				'MaxBv'+ cast(Sporttype as varchar(10))+'="'+ coalesce(cast(MaxB as varchar(50)),space(1))+ '" ' +
				'MPMv' + cast(Sporttype as varchar(10))+'="'+ coalesce(cast(MPM  as varchar(50)),space(1))+ '" ' +	
				CASE WHEN Sporttype=161 THEN 'MPBv161="'+ coalesce(cast(MPB as varchar(50)),space(1))+ '" ' ELSE '' END
		FROM #data_old
		WHERE (Sporttype <=100 OR Sporttype in (154,161))  AND islive=0
		GROUP BY Custid,Sporttype,MinB,MaxB,MPM,MPB
	Select @TEXT= @TEXT +
				'MinBv'+ cast(Sporttype as varchar(10))+'MP="'+ coalesce(cast(MinB as varchar(50)),space(1))+ '" ' +
				'MaxBv'+ cast(Sporttype as varchar(10))+'MP="'+ coalesce(cast(MaxB as varchar(50)),space(1))+ '" ' +
				'MPMv' + cast(Sporttype as varchar(10))+'MP="'+ coalesce(cast(MPM  as varchar(50)),space(1))+ '" ' 	
		FROM #data_old
		WHERE (Sporttype= 99 and Bettype=9)
		GROUP BY Custid,Sporttype,MinB,MaxB,MPM
	select @sql=@sql+@TEXT
	SET @TEXT=''
	Select @TEXT= @TEXT +
				'v'+cast(Sporttype as varchar(10))+ 'MinB_'+ cast(Bettype as varchar(10))+'="'+ coalesce(cast(MinB as varchar(50)),space(1))+ '" ' +
				'v'+cast(Sporttype as varchar(10))+ 'MaxB_'+ cast(Bettype as varchar(10))+'="'+ coalesce(cast(MaxB as varchar(50)),space(1))+ '" ' +
				'v'+cast(Sporttype as varchar(10))+ 'MPM_' + cast(Bettype as varchar(10))+'="'+ coalesce(cast(MPM  as varchar(50)),space(1))+ '" ' 	
		FROM #data_old
		WHERE Sporttype >100 AND Sporttype <154 and islive=0
		GROUP BY Custid,Sporttype,Bettype,MinB,MaxB,MPM
	select @sql=@sql+@TEXT + '/>'
	SELECT @TEXT=''
	SELECT @TEXT=@TEXT + '<VirtualSports '
	Select @TEXT= @TEXT +
				'v'+cast(Sporttype as varchar(10))+ 'MinB'+'="'+ coalesce(cast(MinB as varchar(50)),space(1))+ '" ' +
				'v'+cast(Sporttype as varchar(10))+ 'MaxB'+'="'+ coalesce(cast(MaxB as varchar(50)),space(1))+ '" ' +
				'v'+cast(Sporttype as varchar(10))+ 'MPM' ++'="'+ coalesce(cast(MPM  as varchar(50)),space(1))+ '" ' 	
		FROM #data_old
		WHERE Sporttype >=180 AND Sporttype <=186 and islive=0
		GROUP BY Custid,Sporttype,Bettype,MinB,MaxB,MPM
	select @sql=@sql+@TEXT + '/>'
	select @TEXT=''
	SELECT @TEXT=@TEXT + '<Keno '
	Select @TEXT= @TEXT +
				'MinBv202_' +CAST(Bettype AS VARCHAR(50))+'="'+CAST(MinB AS VARCHAR(50))+'" ' +
				'MaxBv202_' +CAST(Bettype AS VARCHAR(50))+'="'+CAST(MaxB AS VARCHAR(50))+'" ' +
				'MPMv202_' +CAST(Bettype AS VARCHAR(50))+'="'+CAST(MPM AS VARCHAR(50))+'" '
		FROM #data_old
		WHERE Bettype >=1501 AND Bettype <=@j and islive=0
		GROUP BY Custid,Sporttype,Bettype,MinB,MaxB,MPM
	select @sql = @sql + @TEXT + '/>'
	select @sql = @sql + '</Acc_Dep_CustomerUpdMember_Ag>'
	SET @LogSPData2=@sql
END

EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP 
	@UserID = @UserID,
	@CustID = @CustID,
	@ActionID = 2013,
	@TrackingValue = @LogSPData,
	@TrackingValue2 = @LogSPData2,
	@duration = @duration

--Write PT log
SELECT @LogSPData = '<Acc_Dep_CustomerUpdMember_Ag><info custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +
'UserID="'+ coalesce(cast(@UserID as varchar(50)),space(1)) + '" ' +
'Language="'+ coalesce(cast(@Language as varchar(2)),space(1)) + '" ' +
'IP="'+ coalesce(cast(@IP as varchar(15)),space(1)) + '" ' +
'ErrCode="'+ coalesce(cast(@ErrCode as varchar(50)),space(1)) + '" ' +
'ErrMsg="'+ coalesce(cast(@ErrMsg as varchar(5000)),space(1)) + '" />' +

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

'v44mpt_3="'+ COALESCE(CAST(@v44mpositiontaking_3 AS VARCHAR(50)),SPACE(1)) + '" ' +

'v99mpt_1="'+ COALESCE(CAST(@v99mpositiontaking_1 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v99mpt_2="'+ COALESCE(CAST(@v99mpositiontaking_2 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v99mpt_3="'+ COALESCE(CAST(@v99mpositiontaking_3 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v99mpt_9="'+ COALESCE(CAST(@v99mpositiontaking_9 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v99mpt_20="'+ COALESCE(CAST(@v99mpositiontaking_20 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v154mpt_20="'+ COALESCE(CAST(@v154mpositiontaking_20 AS VARCHAR(50)),SPACE(1)) + '" ' +

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
'v180mpt="'+ COALESCE(CAST(@v180mPositionTaking AS VARCHAR(50)),SPACE(1)) + '" ' +
'v181mpt="'+ COALESCE(CAST(@v181mPositionTaking AS VARCHAR(50)),SPACE(1)) + '" ' +
'v182mpt="'+ COALESCE(CAST(@v182mPositionTaking AS VARCHAR(50)),SPACE(1)) + '" ' +
'v183mpt="'+ COALESCE(CAST(@v183mPositionTaking AS VARCHAR(50)),SPACE(1)) + '" ' +
'v184mpt="'+ COALESCE(CAST(@v184mPositionTaking AS VARCHAR(50)),SPACE(1)) + '" ' +
'v185mpt="'+ COALESCE(CAST(@v185mPositionTaking AS VARCHAR(50)),SPACE(1)) + '" ' +
'v186mpt="'+ COALESCE(CAST(@v186mPositionTaking AS VARCHAR(50)),SPACE(1)) + 
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

'v44apt_3="'+ COALESCE(CAST(@v44apositiontaking_3 AS VARCHAR(50)),SPACE(1)) + '" ' +

'v99apt_1="'+ COALESCE(CAST(@v99apositiontaking_1 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v99apt_2="'+ COALESCE(CAST(@v99apositiontaking_2 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v99apt_3="'+ COALESCE(CAST(@v99apositiontaking_3 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v99apt_9="'+ COALESCE(CAST(@v99apositiontaking_9 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v99apt_20="'+ COALESCE(CAST(@v99apositiontaking_20 AS VARCHAR(50)),SPACE(1)) + '" ' +

'v154apt_20="'+ COALESCE(CAST(@v154apositiontaking_20 AS VARCHAR(50)),SPACE(1)) + '" ' +

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
'v180apt="'+ COALESCE(CAST(@v180aPositionTaking AS VARCHAR(50)),SPACE(1)) + '" ' +
'v181apt="'+ COALESCE(CAST(@v181aPositionTaking AS VARCHAR(50)),SPACE(1)) + '" ' +
'v182apt="'+ COALESCE(CAST(@v182aPositionTaking AS VARCHAR(50)),SPACE(1)) + '" ' +
'v183apt="'+ COALESCE(CAST(@v183aPositionTaking AS VARCHAR(50)),SPACE(1)) + '" ' +
'v184apt="'+ COALESCE(CAST(@v184aPositionTaking AS VARCHAR(50)),SPACE(1)) + '" ' +
'v185apt="'+ COALESCE(CAST(@v185aPositionTaking AS VARCHAR(50)),SPACE(1)) + '" ' +
'v186apt="'+ COALESCE(CAST(@v186aPositionTaking AS VARCHAR(50)),SPACE(1)) + '" />' +
'</Acc_Dep_CustomerUpdMember_Ag>' 

--tracking value old
DECLARE @pt_SB smallMoney,@pt_NG smallmoney,@pt_VS smallmoney,@pt_KN smallmoney,
		@mpt_SB smallMoney,@mpt_NG smallmoney,@mpt_VS smallmoney,@mpt_KN smallmoney
select @mpt_SB=0,@mpt_NG=0,@mpt_VS=0,@mpt_KN=0
select top 1 @pt_SB=apt FROM #data_old where Sporttype=1 AND Bettype =1 and islive =0
select top 1 @pt_NG=apt FROM #data_old where Sporttype=161 AND Bettype =81 and islive =0
select top 1 @pt_VS=apt FROM #data_old where Sporttype=180 AND  islive =0
select top 1 @pt_KN=apt FROM #data_old where Sporttype=202 AND Bettype =1501 and islive =0
--write log keno
DECLARE @str_spt_ varchar(1000)='',
		@str_mpt_ varchar(1000)='',
		@str_apt_ varchar(1000)=''
set @i =1501
WHILE (@i<=@j)
BEGIN
	select @str_spt_=@str_spt_ + 'v202spt_' +CAST(Bettype AS VARCHAR(50))+'="'+CAST(@pt_KN AS VARCHAR(50))+'" ',
		   @str_mpt_=@str_mpt_ + 'v202mpt_' +CAST(Bettype AS VARCHAR(50))+'="'+CAST(@mpt_KN AS VARCHAR(50))+'" ',
		   @str_apt_=@str_apt_ + 'v202apt_' +CAST(Bettype AS VARCHAR(50))+'="'+CAST(@pt_KN AS VARCHAR(50))+'" '
	from #data where Bettype=@i
	set @i=@i+1
END
SELECT @LogSPData2 = '<Acc_Dep_CustomerUpdMember_Ag><info custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +
'UserID="'+ coalesce(cast(@UserID as varchar(50)),space(1)) + '" ' +
'Language="'+ coalesce(cast(@Language as varchar(2)),space(1)) + '" ' +
'IP="'+ coalesce(cast(@IP as varchar(15)),space(1)) + '" ' +
'ErrCode="'+ coalesce(cast(@ErrCode as varchar(50)),space(1)) + '" ' +
'ErrMsg="'+ coalesce(cast(@ErrMsg as varchar(5000)),space(1)) + '" />' +

'<m mpt_1="'+ COALESCE(CAST(@mpt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'mpt_2="'+ COALESCE(CAST(@mpt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'mpt_3="'+ COALESCE(CAST(@mpt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'mpt_4="'+ COALESCE(CAST(@mpt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'mpt_5="'+ COALESCE(CAST(@mpt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'mpt_6="'+ COALESCE(CAST(@mpt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'mpt_7="'+ COALESCE(CAST(@mpt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'mpt_8="'+ COALESCE(CAST(@mpt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'mpt_9="'+ COALESCE(CAST(@mpt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'mpt_10="'+ COALESCE(CAST(@mpt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'mlivept_1="'+ COALESCE(CAST(@mpt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'mlivept_3="'+ COALESCE(CAST(@mpt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'mlivept_7="'+ COALESCE(CAST(@mpt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'mlivept_8="'+ COALESCE(CAST(@mpt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +

'v2mpt_1="'+ COALESCE(CAST(@mpt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v2mpt_2="'+ COALESCE(CAST(@mpt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v2mpt_3="'+ COALESCE(CAST(@mpt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v2mpt_7="'+ COALESCE(CAST(@mpt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v2mpt_8="'+ COALESCE(CAST(@mpt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v2mpt_20="'+ COALESCE(CAST(@mpt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +

'v3mpt_1="'+ COALESCE(CAST(@mpt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v3mpt_2="'+ COALESCE(CAST(@mpt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v3mpt_3="'+ COALESCE(CAST(@mpt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v3mpt_20="'+ COALESCE(CAST(@mpt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +

'v5mpt_1="'+ COALESCE(CAST(@mpt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v5mpt_2="'+ COALESCE(CAST(@mpt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v5mpt_3="'+ COALESCE(CAST(@mpt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v5mpt_20="'+ COALESCE(CAST(@mpt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +

'v8mpt_1="'+ COALESCE(CAST(@mpt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v8mpt_3="'+ COALESCE(CAST(@mpt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v8mpt_20="'+ COALESCE(CAST(@mpt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +

'v10mpt_1="'+ COALESCE(CAST(@mpt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v10mpt_2="'+ COALESCE(CAST(@mpt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v10mpt_3="'+ COALESCE(CAST(@mpt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v10mpt_20="'+ COALESCE(CAST(@mpt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +

'v11mpt_1="'+ COALESCE(CAST(@mpt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v11mpt_20="'+ COALESCE(CAST(@mpt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +

'v44mpt_3="'+ COALESCE(CAST(@mpt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +

'v99mpt_1="'+ COALESCE(CAST(@mpt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v99mpt_2="'+ COALESCE(CAST(@mpt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v99mpt_3="'+ COALESCE(CAST(@mpt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v99mpt_9="'+ COALESCE(CAST(@mpt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v99mpt_20="'+ COALESCE(CAST(@mpt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v154mpt_20="'+ COALESCE(CAST(@mpt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +

'v161mpt_81="'+ COALESCE(CONVERT(VARCHAR(50),@mpt_NG,2),SPACE(1)) + '" ' +
'v161mpt_83="'+ COALESCE(CONVERT(VARCHAR(50),@mpt_NG,2),SPACE(1)) + '" ' +
'v161mpt_86="'+ COALESCE(CONVERT(VARCHAR(50),@mpt_NG,2),SPACE(1)) + '" ' +
'v161mpt_88="'+ COALESCE(CONVERT(VARCHAR(50),@mpt_NG,2),SPACE(1)) + '" ' +
'v161mlivept_85="'+ COALESCE(CONVERT(VARCHAR(50),@mpt_NG,2),SPACE(1)) + '" ' +
'v161mlivept_86="'+ COALESCE(CONVERT(VARCHAR(50),@mpt_NG,2),SPACE(1)) + '" ' +
'v161mlivept_87="'+ COALESCE(CONVERT(VARCHAR(50),@mpt_NG,2),SPACE(1)) + '" ' +
'v161mlivept_89="'+ COALESCE(CONVERT(VARCHAR(50),@mpt_NG,2),SPACE(1)) + '" ' +
'v161mlivept_90="'+ COALESCE(CONVERT(VARCHAR(50),@mpt_NG,2),SPACE(1)) + '" ' +
@str_mpt_+
'v180mpt="'+ COALESCE(CAST(@mpt_VS AS VARCHAR(50)),SPACE(1)) + '" ' + 
'v181mpt="'+ COALESCE(CAST(@mpt_VS AS VARCHAR(50)),SPACE(1)) + '" ' +
'v182mpt="'+ COALESCE(CAST(@mpt_VS AS VARCHAR(50)),SPACE(1)) + '" ' +
'v183mpt="'+ COALESCE(CAST(@mpt_VS AS VARCHAR(50)),SPACE(1)) + '" ' +
'v184mpt="'+ COALESCE(CAST(@mpt_VS AS VARCHAR(50)),SPACE(1)) + '" ' +
'v185mpt="'+ COALESCE(CAST(@mpt_VS AS VARCHAR(50)),SPACE(1)) + '" ' +
'v186mpt="'+ COALESCE(CAST(@mpt_VS AS VARCHAR(50)),SPACE(1)) +
'" />' +

'<ag apt_1="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'apt_2="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'apt_3="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'apt_4="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'apt_5="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'apt_6="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'apt_7="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'apt_8="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'apt_9="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'apt_10="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' + 
'alivept_1="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'alivept_3="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'alivept_7="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'alivept_8="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +

'v2apt_1="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v2apt_2="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v2apt_3="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v2apt_7="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v2apt_8="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v2apt_20="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +

'v3apt_1="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v3apt_2="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v3apt_3="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v3apt_20="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +

'v5apt_1="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v5apt_2="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v5apt_3="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v5apt_20="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +

'v8apt_1="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v8apt_3="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v8apt_20="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +

'v10apt_1="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v10apt_2="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v10apt_3="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v10apt_20="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +

'v11apt_1="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v11apt_20="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +

'v44apt_3="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +

'v99apt_1="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v99apt_2="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v99apt_3="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v99apt_9="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v99apt_20="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v154apt_20="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +

'v161apt_81="'+ COALESCE(CONVERT(VARCHAR(50),@pt_NG,2),SPACE(1)) + '" ' +
'v161apt_83="'+ COALESCE(CONVERT(VARCHAR(50),@pt_NG,2),SPACE(1)) + '" ' +
'v161apt_86="'+ COALESCE(CONVERT(VARCHAR(50),@pt_NG,2),SPACE(1)) + '" ' +
'v161apt_88="'+ COALESCE(CONVERT(VARCHAR(50),@pt_NG,2),SPACE(1)) + '" ' +
'v161alivept_85="'+ COALESCE(CONVERT(VARCHAR(50),@pt_NG,2),SPACE(1)) + '" ' +
'v161alivept_86="'+ COALESCE(CONVERT(VARCHAR(50),@pt_NG,2),SPACE(1)) + '" ' +
'v161alivept_87="'+ COALESCE(CONVERT(VARCHAR(50),@pt_NG,2),SPACE(1)) + '" ' +
'v161alivept_89="'+ COALESCE(CONVERT(VARCHAR(50),@pt_NG,2),SPACE(1)) + '" ' +
'v161alivept_90="'+ COALESCE(CONVERT(VARCHAR(50),@pt_NG,2),SPACE(1)) + '" ' +
@str_apt_+
'v180apt="'+ COALESCE(CAST(@pt_VS AS VARCHAR(50)),SPACE(1)) + '" ' +
'v181apt="'+ COALESCE(CAST(@pt_VS AS VARCHAR(50)),SPACE(1)) + '" ' +
'v182apt="'+ COALESCE(CAST(@pt_VS AS VARCHAR(50)),SPACE(1)) + '" ' +
'v183apt="'+ COALESCE(CAST(@pt_VS AS VARCHAR(50)),SPACE(1)) + '" ' +
'v184apt="'+ COALESCE(CAST(@pt_VS AS VARCHAR(50)),SPACE(1)) + '" ' +
'v185apt="'+ COALESCE(CAST(@pt_VS AS VARCHAR(50)),SPACE(1)) + '" ' +
'v186apt="'+ COALESCE(CAST(@pt_VS AS VARCHAR(50)),SPACE(1)) + '" />' +
'</Acc_Dep_CustomerUpdMember_Ag>'


EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP 
	@UserID = @UserID,
	@CustID = @CustID,
	@ActionID = 2706,
	@TrackingValue = @LogSPData,
	@TrackingValue2 = @LogSPData2,
	@duration = @duration

Select @LogSPData = '<Acc_Dep_CustomerUpdMember_Ag custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +
'v151discount_31="'+ coalesce(cast(@v151discount_31 as varchar(50)),space(1)) + '" ' +
'v151discount_41="'+ coalesce(cast(@v151discount_41 as varchar(50)),space(1)) + '" ' +
'v151discount_51="'+ coalesce(cast(@v151discount_51 as varchar(50)),space(1)) + '" ' +
'v152discount_41="'+ coalesce(cast(@v152discount_41 as varchar(50)),space(1)) + '" ' +
'v152discount_51="'+ coalesce(cast(@v152discount_51 as varchar(50)),space(1)) + '" ' +
'v153discount_51="'+ coalesce(cast(@v153discount_51 as varchar(50)),space(1)) + '" ' +
'UserID="'+ coalesce(cast(@UserID as varchar(50)),space(1)) + '" ' +
'Language="'+ coalesce(cast(@Language as varchar(2)),space(1)) + '" ' +
'IP="'+ coalesce(cast(@IP as varchar(15)),space(1)) + '" ' +
'ErrCode="'+ coalesce(cast(@ErrCode as varchar(50)),space(1)) + '" ' +
'ErrMsg="'+ coalesce(cast(@ErrMsg as varchar(5000)),space(1)) + '" />'

DECLARE @v151discount_31_ decimal(9,8) = 0,	
		@v151discount_41_ decimal(9,8) = 0,
		@v151discount_51_ decimal(9,8) = 0,
		@v152discount_41_ decimal(9,8) = 0,
		@v152discount_51_ decimal(9,8) = 0,
		@v153discount_51_ decimal(9,8) = 0
select @v151discount_31_=AgRBDiscount FROM #data_old WHERE custid=@custID and sporttype = 151 AND bettype =31
select @v151discount_41_=AgRBDiscount FROM #data_old WHERE custid=@custID and sporttype = 151 AND bettype =41
select @v151discount_51_=AgRBDiscount FROM #data_old WHERE custid=@custID and sporttype = 151 AND bettype =51
select @v152discount_41_=AgRBDiscount FROM #data_old WHERE custid=@custID and sporttype = 152 AND bettype =41
select @v152discount_51_=AgRBDiscount FROM #data_old WHERE custid=@custID and sporttype = 152 AND bettype =51
select @v153discount_51_=AgRBDiscount FROM #data_old WHERE custid=@custID and sporttype = 153 AND bettype =51

Select @LogSPData2 = '<Acc_Dep_CustomerUpdMember_Com custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +
'v151discount_31="'+ coalesce(cast(@v151discount_31_ as varchar(50)),space(1)) + '" ' +
'v151discount_41="'+ coalesce(cast(@v151discount_41_ as varchar(50)),space(1)) + '" ' +
'v151discount_51="'+ coalesce(cast(@v151discount_51_ as varchar(50)),space(1)) + '" ' +
'v152discount_41="'+ coalesce(cast(@v152discount_41_ as varchar(50)),space(1)) + '" ' +
'v152discount_51="'+ coalesce(cast(@v152discount_51_ as varchar(50)),space(1)) + '" ' +
'v153discount_51="'+ coalesce(cast(@v153discount_51_ as varchar(50)),space(1)) + '" ' +
'UserID="'+ coalesce(cast(@UserID as varchar(50)),space(1)) + '" ' +
'Language="'+ coalesce(cast(@Language as varchar(2)),space(1)) + '" ' +
'IP="'+ coalesce(cast(@IP as varchar(15)),space(1)) + '" ' +
'ErrCode="'+ coalesce(cast(@ErrCode as varchar(50)),space(1)) + '" ' +
'ErrMsg="'+ coalesce(cast(@ErrMsg as varchar(5000)),space(1)) + '" />'

EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP 
	@UserID = @UserID,
	@CustID = @CustID,
	@ActionID = 2608,
	@TrackingValue = @LogSPData,
	@TrackingValue2 = @LogSPData2,
	@duration = @duration

DROP TABLE #data
DROP TABLE #data_upline
drop TABLE #data_old
