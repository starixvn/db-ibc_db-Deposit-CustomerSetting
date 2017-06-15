ALTER PROCEDURE [dbo].[Acc_Dep_CustomerInsMember_Com]
	@custid INT OUTPUT,
	@creator INT,
	@username VARCHAR(30),
	@userpwd VARCHAR(40) = '123qwe',
	@site NVARCHAR(50), 
	@currency INT, 

	@MinBetv1 MONEY,
	@MaxBetv1 MONEY,
	@MaxPerMatchv1 MONEY,
	
	@MinBetv2 MONEY,
	@MaxBetv2 MONEY,
	@MaxPerMatchv2 MONEY,
	
	@MinBetv3 MONEY,
	@MaxBetv3 MONEY,
	@MaxPerMatchv3 MONEY,

	@MinBetv5 MONEY,
	@MaxBetv5 MONEY,
	@MaxPerMatchv5 MONEY,

	@MinBetv8 MONEY,
	@MaxBetv8 MONEY,
	@MaxPerMatchv8 MONEY,

	@MinBetv10 MONEY,
	@MaxBetv10 MONEY,
	@MaxPerMatchv10 MONEY,

	@MinBetv11 MONEY,
	@MaxBetv11 MONEY,
	@MaxPerMatchv11 MONEY,
	
	@MinBetv44 MONEY,
	@MaxBetv44 MONEY,
	@MaxPerMatchv44 MONEY,
	
	@MinBetv99 MONEY,
	@MaxBetv99 MONEY,
	@MaxPerMatchv99 MONEY,
	
	--Mix Parlay mix sports
	@MinBetv99MP MONEY,
	@MaxBetv99MP MONEY,
	@MaxPerMatchv99MP MONEY,

	--HR Fix Odds
	@MinBetv154 MONEY,
	@MaxBetv154 MONEY,
	@MaxPerMatchv154 MONEY,
	
	--Number game
	@MinBetv161 MONEY,
	@MaxBetv161 MONEY,
	@MaxPerMatchv161 MONEY,
	@MaxPerBallv161 MONEY = 0,
	
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

	--HRFO
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

	@v1mpositiontaking_1 SMALLMONEY,
	@v1mpositiontaking_2 SMALLMONEY,
	@v1mpositiontaking_3 SMALLMONEY,
	@v1mpositiontaking_4 SMALLMONEY,
	@v1mpositiontaking_5 SMALLMONEY,
	@v1mpositiontaking_6 SMALLMONEY,
	@v1mpositiontaking_7 SMALLMONEY,
	@v1mpositiontaking_8 SMALLMONEY,
	@v1mpositiontaking_9 SMALLMONEY,
	@v1mpositiontaking_10 SMALLMONEY,
	
	@v1mlivepositiontaking_1 SMALLMONEY,
	@v1mlivepositiontaking_3 SMALLMONEY,
	@v1mlivepositiontaking_7 SMALLMONEY,
	@v1mlivepositiontaking_8 SMALLMONEY,
	
	@v2mpositiontaking_1 SMALLMONEY,
	@v2mpositiontaking_2 SMALLMONEY,
	@v2mpositiontaking_3 SMALLMONEY,
	@v2mpositiontaking_7 SMALLMONEY,
	@v2mpositiontaking_8 SMALLMONEY,
	@v2mpositiontaking_20 SMALLMONEY,

	@v3mpositiontaking_1 SMALLMONEY,
	@v3mpositiontaking_2 SMALLMONEY,
	@v3mpositiontaking_3 SMALLMONEY,
	@v3mpositiontaking_20 SMALLMONEY,

	@v5mpositiontaking_1 SMALLMONEY,
	@v5mpositiontaking_2 SMALLMONEY,
	@v5mpositiontaking_3 SMALLMONEY,
	@v5mpositiontaking_20 SMALLMONEY,

	@v8mpositiontaking_1 SMALLMONEY,
	@v8mpositiontaking_3 SMALLMONEY,
	@v8mpositiontaking_20 SMALLMONEY,

	@v10mpositiontaking_1 SMALLMONEY,
	@v10mpositiontaking_2 SMALLMONEY,
	@v10mpositiontaking_3 SMALLMONEY,
	@v10mpositiontaking_20 SMALLMONEY,

	@v11mpositiontaking_1 SMALLMONEY,
	@v11mpositiontaking_20 SMALLMONEY,
	
	@v44mpositiontaking_3 SMALLMONEY,
	
	@v99mpositiontaking_1 SMALLMONEY,
	@v99mpositiontaking_2 SMALLMONEY,
	@v99mpositiontaking_3 SMALLMONEY,
	@v99mpositiontaking_9 SMALLMONEY,
	@v99mpositiontaking_20 SMALLMONEY,

	--HRFO
	@v154mpositiontaking_20 SMALLMONEY,
	
	--v161
	@v161mpositiontaking_81 SMALLMONEY,
	@v161mpositiontaking_83 SMALLMONEY,
	@v161mpositiontaking_86 SMALLMONEY,
	@v161mpositiontaking_88 SMALLMONEY,
	@v161mlivepositiontaking_85 SMALLMONEY,
	@v161mlivepositiontaking_86 SMALLMONEY,
	@v161mlivepositiontaking_87 SMALLMONEY,
	@v161mlivepositiontaking_89 SMALLMONEY = 0,
	@v161mlivepositiontaking_90 SMALLMONEY =0,

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
	
	@v1apositiontaking_1 SMALLMONEY,
	@v1apositiontaking_2 SMALLMONEY,
	@v1apositiontaking_3 SMALLMONEY,
	@v1apositiontaking_4 SMALLMONEY,
	@v1apositiontaking_5 SMALLMONEY,
	@v1apositiontaking_6 SMALLMONEY,
	@v1apositiontaking_7 SMALLMONEY,
	@v1apositiontaking_8 SMALLMONEY,
	@v1apositiontaking_9 SMALLMONEY,
	@v1apositiontaking_10 SMALLMONEY,
	
	@v1alivepositiontaking_1 SMALLMONEY,
	@v1alivepositiontaking_3 SMALLMONEY,
	@v1alivepositiontaking_7 SMALLMONEY,
	@v1alivepositiontaking_8 SMALLMONEY,
	
	@v2apositiontaking_1 SMALLMONEY,
	@v2apositiontaking_2 SMALLMONEY,
	@v2apositiontaking_3 SMALLMONEY,
	@v2apositiontaking_7 SMALLMONEY,
	@v2apositiontaking_8 SMALLMONEY,
	@v2apositiontaking_20 SMALLMONEY,

	@v3apositiontaking_1 SMALLMONEY,
	@v3apositiontaking_2 SMALLMONEY,
	@v3apositiontaking_3 SMALLMONEY,
	@v3apositiontaking_20 SMALLMONEY,

	@v5apositiontaking_1 SMALLMONEY,
	@v5apositiontaking_2 SMALLMONEY,
	@v5apositiontaking_3 SMALLMONEY,
	@v5apositiontaking_20 SMALLMONEY,

	@v8apositiontaking_1 SMALLMONEY,
	@v8apositiontaking_3 SMALLMONEY,
	@v8apositiontaking_20 SMALLMONEY,

	@v10apositiontaking_1 SMALLMONEY,
	@v10apositiontaking_2 SMALLMONEY,
	@v10apositiontaking_3 SMALLMONEY,
	@v10apositiontaking_20 SMALLMONEY,

	@v11apositiontaking_1 SMALLMONEY,
	@v11apositiontaking_20 SMALLMONEY,
	
	@v44apositiontaking_3 SMALLMONEY,
	
	@v99apositiontaking_1 SMALLMONEY,
	@v99apositiontaking_2 SMALLMONEY,
	@v99apositiontaking_3 SMALLMONEY,
	@v99apositiontaking_9 SMALLMONEY,
	@v99apositiontaking_20 SMALLMONEY,

	--HRFO
	@v154apositiontaking_20 SMALLMONEY,
	
	--v161
	@v161apositiontaking_81 SMALLMONEY,
	@v161apositiontaking_83 SMALLMONEY,
	@v161apositiontaking_86 SMALLMONEY,
	@v161apositiontaking_88 SMALLMONEY,
	@v161alivepositiontaking_85 SMALLMONEY,
	@v161alivepositiontaking_86 SMALLMONEY,
	@v161alivepositiontaking_87 SMALLMONEY,
	@v161alivepositiontaking_89 SMALLMONEY = 0,
	@v161alivepositiontaking_90 SMALLMONEY = 0,

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

	--Horse Racing PT
	@v151IBCPositiontaking_31 smallmoney = 0,--AutoIBCPT151_SA
	@v151IBCPositiontaking_41 smallmoney = 0,--AutoIBCPT151_UK
	@v151IBCPositiontaking_51 smallmoney = 0,--AutoIBCPT151_AU

	@v152IBCPositiontaking_41 smallmoney = 0,--AutoIBCPT152_UK 
	@v152IBCPositiontaking_51 smallmoney = 0,--AutoIBCPT152_AU 

	@v153IBCPositiontaking_51 smallmoney = 0,--AutoIBCPT153_AU

	--Horse Racing Commission
	@v151discount_31 decimal(9,8) = 0,	
	@v151discount_41 decimal(9,8) = 0,

	@v151discount_51 decimal(9,8) = 0,
	@v152discount_41 decimal(9,8) = 0,
	@v152discount_51 decimal(9,8) = 0,
	@v153discount_51 decimal(9,8) = 0,
	
	@Disable151_31 BIT = 0,-- @DisableHorseRacing -> @Disable151_31
	@Disable151_41 BIT = 0,-- @DisableOpenTote -> @Disable151_41
	@Disable151_51 BIT = 0,-- @Disable151_AU -> @Disable151_51
	@Disable152_41 BIT = 0,-- @Disable152_UK -> @Disable152_41
	@Disable152_51 BIT = 0,-- @Disable152_AU -> @Disable152_51
	@Disable153_51 BIT = 0,-- @Disable153_AU -> @Disable153_51
	
	@DisableNumber BIT = 0,

	--Virtual Sport
	@VirtualSportList VARCHAR(4000)='',
	@DisableVirtualSports BIT = 0,
	--------------------------------

	--Keno
	@KenoList VARCHAR(4000)='',
	@DisableKeno BIT = 0,
	--------------------------------

	@DisableCasinoBonus BIT = 1,
	
	@IP VARCHAR(15)='',
	@Language VARCHAR(2)= 'E',
	@ErrCode INT = 0 OUTPUT,
	@ErrMsg NVARCHAR(2000) = '' OUTPUT
AS
--@Source Control
/*
Created: 20120314@Dom
Task : Company create Super in Deposite site
DB: DBTRANS.bodb02
Original:
Revisions:
    - 20121128@Elodie: Get an error message from f_Get_MsgNameByMsgID function by language
    - 20130604@Daniel: Change default P2P param value to "Disable P2P"
    - 20130607@Daniel: Exclude created member from Balance checking
    - 20130731@Elodie: Apply progressive bonus
	- 20130919@Don: Supporting save log of Number Game PT with format such as "0.995", "0.925", ...
	- 20131014@Francis: Support adding new virtual sports with settings via XML param
	- 20140505@Florent: Add sport HR Fix Odds
	- 20140509@Florent: Add new sport: 202 Keno
	- 20140605@Florent: Remove checking for Super
	- 20150309@Johnson: Disable virtual rate as default [RedmineID: #31927]
    - 20150609@David: Separate CustDB to DBCUST server (Use temp table for sports, bettype, GameType table, call some SPs by link server)
	- 20151028@Jim:Implement Muay's Setting for Deposit Customer [Redmine: #45491]
    - 20160830@Winnie: #63151  Add ColossusBet Agent commRate
Param's Explanation:
• @ErrCode:
    = 0: Create super successfully.
    > 0: Specific Error.
  
• @ErrMsg: Error description.
• @VirtualSportList: VirtualSport Settings XML param.
*/
BEGIN
SET NOCOUNT ON
----- David @ 09 JUN 2015 -------------------
	DECLARE @tmp_GameType TABLE (GameTypeID INT, GameTypeName NVARCHAR(50), IsDisabled BIT, IBCBettypeID INT)

	BEGIN TRY		
		INSERT INTO @tmp_GameType (GameTypeID, GameTypeName, IsDisabled, IBCBettypeID)
		SELECT GameTypeID, GameTypeName, IsDisabled, IBCBettypeID FROM DBAGE.bodb02.dbo.GameType WITH (NOLOCK)
	END TRY
	BEGIN CATCH		
		INSERT INTO @tmp_GameType (GameTypeID, GameTypeName, IsDisabled, IBCBettypeID)
		SELECT GameTypeID, GameTypeName, IsDisabled, IBCBettypeID FROM DBTXN.bodb02.dbo.GameType WITH (NOLOCK)
	END CATCH
----- /David @ 09 JUN 2015 -------------------
DECLARE @startRun DATETIME , @endRun DATETIME , @duration INT
SET @startRun = GETDATE()

DECLARE @transcode BIGINT 
DECLARE @isvalid BIT
SELECT @ErrCode = 0

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


EXEC dbo.Acc_Dep_CustomerInsMember_Com_CheckParam
			@custid						= @custid OUTPUT,
			@currency					= @currency,
			
			--Horse Racing Commission
			@v151discount_31			= @v151discount_31,	
			@v151discount_41			= @v151discount_41,
			@v151discount_51			= @v151discount_51,

			@v152discount_41			= @v152discount_41,
			@v152discount_51			= @v152discount_51,
			@v153discount_51			= @v153discount_51,
			
			@MinBet						= @MinBetv1,
			@MaxBet						= @MaxBetv1,
			@MaxPerMatch				= @MaxPerMatchv1,
			@MinBetv2					= @MinBetv2,
			@MaxBetv2					= @MaxBetv2,
			@MaxPerMatchv2				= @MaxPerMatchv2,
			@MinBetv3					= @MinBetv3,
			@MaxBetv3					= @MaxBetv3,
			@MaxPerMatchv3				= @MaxPerMatchv3,
			@MinBetv5					= @MinBetv5,
			@MaxBetv5					= @MaxBetv5,
			@MaxPerMatchv5				= @MaxPerMatchv5,
			@MinBetv8					= @MinBetv8,
			@MaxBetv8					= @MaxBetv8,
			@MaxPerMatchv8				= @MaxPerMatchv8,
			@MinBetv10					= @MinBetv10,
			@MaxBetv10					= @MaxBetv10,
			@MaxPerMatchv10				= @MaxPerMatchv10,
			@MinBetv11					= @MinBetv11,
			@MaxBetv11					= @MaxBetv11,
			@MaxPerMatchv11				= @MaxPerMatchv11,
			
			@MinBetv44					= @MinBetv44,
			@MaxBetv44					= @MaxBetv44,
			@MaxPerMatchv44				= @MaxPerMatchv44,
			
			@MinBetv99					= @MinBetv99,
			@MaxBetv99					= @MaxBetv99,
			@MaxPerMatchv99				= @MaxPerMatchv99,
			
			--Mix Parlay mix sports
			@MinBetv99MP				= @MinBetv99MP,
			@MaxBetv99MP				= @MaxBetv99MP,
			@MaxPerMatchv99MP			= @MaxPerMatchv99MP,
			
			--HRFO
			@MinBetv154				= @MinBetv154,
			@MaxBetv154				= @MaxBetv154,
			@MaxPerMatchv154		= @MaxPerMatchv154,

			--Racing Bet Setting
			@v151minbet_31			= @v151minbet_31,	
			@v151maxbet_31			= @v151maxbet_31,	
			@v151maxpermatch_31		= @v151maxpermatch_31,	
									 
			@v151minbet_41			= @v151minbet_41,		
			@v151maxbet_41			= @v151maxbet_41,		
			@v151maxpermatch_41		= @v151maxpermatch_41,		
									 
			@v151minbet_51			= @v151minbet_51,
			@v151maxbet_51			= @v151maxbet_51,
			@v151maxpermatch_51		= @v151maxpermatch_51,
									
			@v152minbet_41			= @v152minbet_41,
			@v152maxbet_41			= @v152maxbet_41,
			@v152maxpermatch_41		= @v152maxpermatch_41,
									
			@v152minbet_51			= @v152minbet_51,
			@v152maxbet_51			= @v152maxbet_51,
			@v152maxpermatch_51		= @v152maxpermatch_51,
									 
			@v153minbet_51			= @v153minbet_51,
			@v153maxbet_51			= @v153maxbet_51,
			@v153maxpermatch_51		= @v153maxpermatch_51,

			--Number game
			@MinBetv161					= @MinBetv161,
			@MaxBetv161					= @MaxBetv161,
			@MaxPerMatchv161			= @MaxPerMatchv161,

			@MaxPerBallv161				= @MaxPerBallv161,
			
			@spositiontaking_1			= @v1spositiontaking_1,
			@spositiontaking_2			= @v1spositiontaking_2,
			@spositiontaking_3			= @v1spositiontaking_3,
			@spositiontaking_4			= @v1spositiontaking_4,
			@spositiontaking_5			= @v1spositiontaking_5,
			@spositiontaking_6			= @v1spositiontaking_6,
			@spositiontaking_7			= @v1spositiontaking_7,
			@spositiontaking_8			= @v1spositiontaking_8,
			@spositiontaking_9			= @v1spositiontaking_9,
			@spositiontaking_10			= @v1spositiontaking_10,
			@slivepositiontaking_1		= @v1slivepositiontaking_1,
			@slivepositiontaking_3		= @v1slivepositiontaking_3,
			@slivepositiontaking_7		= @v1slivepositiontaking_7,
			@slivepositiontaking_8		= @v1slivepositiontaking_8,
			@v2spositiontaking_1		= @v2spositiontaking_1,
			@v2spositiontaking_2		= @v2spositiontaking_2,
			@v2spositiontaking_3		= @v2spositiontaking_3,
			@v2spositiontaking_7		= @v2spositiontaking_7,
			@v2spositiontaking_8		= @v2spositiontaking_8,
			@v2spositiontaking_20		= @v2spositiontaking_20,

			@v3spositiontaking_1		= @v3spositiontaking_1,
			@v3spositiontaking_2		= @v3spositiontaking_2,
			@v3spositiontaking_3		= @v3spositiontaking_3,
			@v3spositiontaking_20		= @v3spositiontaking_20,
			@v5spositiontaking_1		= @v5spositiontaking_1,
			@v5spositiontaking_2		= @v5spositiontaking_2,
			@v5spositiontaking_3		= @v5spositiontaking_3,
			@v5spositiontaking_20		= @v5spositiontaking_20,
			@v8spositiontaking_1		= @v8spositiontaking_1,
			@v8spositiontaking_3		= @v8spositiontaking_3,
			@v8spositiontaking_20		= @v8spositiontaking_20,
			@v10spositiontaking_1		= @v10spositiontaking_1,
			@v10spositiontaking_2		= @v10spositiontaking_2,
			@v10spositiontaking_3		= @v10spositiontaking_3,
			@v10spositiontaking_20		= @v10spositiontaking_20,
			@v11spositiontaking_1		= @v11spositiontaking_1,
			@v11spositiontaking_20		= @v11spositiontaking_20,
			
			@v44spositiontaking_3		= @v44spositiontaking_3,
			
			@v99spositiontaking_1		= @v99spositiontaking_1,
			@v99spositiontaking_2		= @v99spositiontaking_2,
			@v99spositiontaking_3		= @v99spositiontaking_3,
			@v99spositiontaking_9		= @v99spositiontaking_9,
			@v99spositiontaking_20		= @v99spositiontaking_20,

			--HRFO
			@v154spositiontaking_20		= @v154spositiontaking_20,
			
			--Racing PT
			@v151spositiontaking_31		= @v151spositiontaking_31,
			@v151spositiontaking_32		= @v151spositiontaking_32,
			@v151spositiontaking_41		= @v151spositiontaking_41,
			@v151spositiontaking_42		= @v151spositiontaking_42,
								 							
			@v151spositiontaking_51		= @v151spositiontaking_51,
			@v151spositiontaking_52		= @v151spositiontaking_52,
								 							
			@v152spositiontaking_41		= @v152spositiontaking_41,
			@v152spositiontaking_42		= @v152spositiontaking_42,
			@v152spositiontaking_51		= @v152spositiontaking_51,
			@v152spositiontaking_52		= @v152spositiontaking_52,
								 							
			@v153spositiontaking_51		= @v153spositiontaking_51,
			@v153spositiontaking_52		= @v153spositiontaking_52,

			--v161
			@v161spositiontaking_81		= @v161spositiontaking_81,
			@v161spositiontaking_83		= @v161spositiontaking_83,
			@v161spositiontaking_86		= @v161spositiontaking_86,
			@v161spositiontaking_88		= @v161spositiontaking_88,
			@v161slivepositiontaking_85 = @v161slivepositiontaking_85,
			@v161slivepositiontaking_86 = @v161slivepositiontaking_86,
			@v161slivepositiontaking_87 = @v161slivepositiontaking_87,
			@v161slivepositiontaking_89 = @v161slivepositiontaking_89,
			@v161slivepositiontaking_90 = @v161slivepositiontaking_90,

			@mpositiontaking_1			= @v1mpositiontaking_1,
			@mpositiontaking_2			= @v1mpositiontaking_2,
			@mpositiontaking_3			= @v1mpositiontaking_3,
			@mpositiontaking_4			= @v1mpositiontaking_4,
			@mpositiontaking_5			= @v1mpositiontaking_5,
			@mpositiontaking_6			= @v1mpositiontaking_6,
			@mpositiontaking_7			= @v1mpositiontaking_7,
			@mpositiontaking_8			= @v1mpositiontaking_8,
			@mpositiontaking_9			= @v1mpositiontaking_9,
			@mpositiontaking_10			= @v1mpositiontaking_10,
			@mlivepositiontaking_1		= @v1mlivepositiontaking_1,
			@mlivepositiontaking_3		= @v1mlivepositiontaking_3,
			@mlivepositiontaking_7		= @v1mlivepositiontaking_7,
			@mlivepositiontaking_8		= @v1mlivepositiontaking_8,
			@v2mpositiontaking_1		= @v2mpositiontaking_1,
			@v2mpositiontaking_2		= @v2mpositiontaking_2,
			@v2mpositiontaking_3		= @v2mpositiontaking_3,
			@v2mpositiontaking_7		= @v2mpositiontaking_7,
			@v2mpositiontaking_8		= @v2mpositiontaking_8,
			@v2mpositiontaking_20		= @v2mpositiontaking_20,

			@v3mpositiontaking_1		= @v3mpositiontaking_1,
			@v3mpositiontaking_2		= @v3mpositiontaking_2,
			@v3mpositiontaking_3		= @v3mpositiontaking_3,
			@v3mpositiontaking_20		= @v3mpositiontaking_20,
			@v5mpositiontaking_1		= @v5mpositiontaking_1,
			@v5mpositiontaking_2		= @v5mpositiontaking_2,
			@v5mpositiontaking_3		= @v5mpositiontaking_3,
			@v5mpositiontaking_20		= @v5mpositiontaking_20,
			@v8mpositiontaking_1		= @v8mpositiontaking_1,
			@v8mpositiontaking_3		= @v8mpositiontaking_3,
			@v8mpositiontaking_20		= @v8mpositiontaking_20,
			@v10mpositiontaking_1		= @v10mpositiontaking_1,
			@v10mpositiontaking_2		= @v10mpositiontaking_2,
			@v10mpositiontaking_3		= @v10mpositiontaking_3,
			@v10mpositiontaking_20		= @v10mpositiontaking_20,
			@v11mpositiontaking_1		= @v11mpositiontaking_1,
			@v11mpositiontaking_20		= @v11mpositiontaking_20,
			
			@v44mpositiontaking_3		= @v44mpositiontaking_3,
			
			@v99mpositiontaking_1		= @v99mpositiontaking_1,
			@v99mpositiontaking_2		= @v99mpositiontaking_2,
			@v99mpositiontaking_3		= @v99mpositiontaking_3,
			@v99mpositiontaking_9		= @v99mpositiontaking_9,
			@v99mpositiontaking_20		= @v99mpositiontaking_20,

			--HRFO
			@v154mpositiontaking_20		= @v154mpositiontaking_20,
			
			--Racing
			@v151mpositiontaking_31		= @v151mpositiontaking_31,
			@v151mpositiontaking_32		= @v151mpositiontaking_32,
			@v151mpositiontaking_41		= @v151mpositiontaking_41,
			@v151mpositiontaking_42		= @v151mpositiontaking_42,
										 
			@v151mpositiontaking_51		= @v151mpositiontaking_51,
			@v151mpositiontaking_52		= @v151mpositiontaking_52,
										 
			@v152mpositiontaking_41		= @v152mpositiontaking_41,
			@v152mpositiontaking_42		= @v152mpositiontaking_42,
			@v152mpositiontaking_51		= @v152mpositiontaking_51,
			@v152mpositiontaking_52		= @v152mpositiontaking_52,
										 
			@v153mpositiontaking_51		= @v153mpositiontaking_51,
			@v153mpositiontaking_52		= @v153mpositiontaking_52,

			--v161
			@v161mpositiontaking_81		= @v161mpositiontaking_81,
			@v161mpositiontaking_83		= @v161mpositiontaking_83,
			@v161mpositiontaking_86		= @v161mpositiontaking_86,
			@v161mpositiontaking_88		= @v161mpositiontaking_88,
			@v161mlivepositiontaking_85 = @v161mlivepositiontaking_85,
			@v161mlivepositiontaking_86 = @v161mlivepositiontaking_86,
			@v161mlivepositiontaking_87 = @v161mlivepositiontaking_87,
			@v161mlivepositiontaking_89 = @v161mlivepositiontaking_89,
			@v161mlivepositiontaking_90 = @v161mlivepositiontaking_90,
			
			@apositiontaking_1			= @v1apositiontaking_1,
			@apositiontaking_2			= @v1apositiontaking_2,
			@apositiontaking_3			= @v1apositiontaking_3,
			@apositiontaking_4			= @v1apositiontaking_4,
			@apositiontaking_5			= @v1apositiontaking_5,
			@apositiontaking_6			= @v1apositiontaking_6,
			@apositiontaking_7			= @v1apositiontaking_7,
			@apositiontaking_8			= @v1apositiontaking_8,
			@apositiontaking_9			= @v1apositiontaking_9,
			@apositiontaking_10			= @v1apositiontaking_10,
			@alivepositiontaking_1		= @v1alivepositiontaking_1,
			@alivepositiontaking_3		= @v1alivepositiontaking_3,
			@alivepositiontaking_7		= @v1alivepositiontaking_7,
			@alivepositiontaking_8		= @v1alivepositiontaking_8,
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
			
			@v44apositiontaking_3		= @v44apositiontaking_3,
			
			@v99apositiontaking_1		= @v99apositiontaking_1,
			@v99apositiontaking_2		= @v99apositiontaking_2,
			@v99apositiontaking_3		= @v99apositiontaking_3,
			@v99apositiontaking_9		= @v99apositiontaking_9,
			@v99apositiontaking_20		= @v99apositiontaking_20,
			--HRFO
			@v154apositiontaking_20		= @v154apositiontaking_20,
			
			--Racing
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

			-- IBC Horse Racing PT 
			@v151IBCPositiontaking_31	= @v151IBCPositiontaking_31,
			@v151IBCPositiontaking_41	= @v151IBCPositiontaking_41,
			@v151IBCPositiontaking_51	= @v151IBCPositiontaking_51,
										 
			@v152IBCPositiontaking_41	= @v152IBCPositiontaking_41 ,
			@v152IBCPositiontaking_51	= @v152IBCPositiontaking_51 ,
										
			@v153IBCPositiontaking_51	= @v153IBCPositiontaking_51,

			--v161
			@v161apositiontaking_81		= @v161apositiontaking_81,
			@v161apositiontaking_83		= @v161apositiontaking_83,
			@v161apositiontaking_86		= @v161apositiontaking_86,
			@v161apositiontaking_88		= @v161apositiontaking_88,
			@v161alivepositiontaking_85 = @v161alivepositiontaking_85,
			@v161alivepositiontaking_86 = @v161alivepositiontaking_86,
			@v161alivepositiontaking_87 = @v161alivepositiontaking_87,
			@v161alivepositiontaking_89 = @v161alivepositiontaking_89,
			@v161alivepositiontaking_90 = @v161alivepositiontaking_90,			
			
			@isvalid					= @isvalid OUTPUT,
			@errmsg						= @errmsg OUTPUT,
			@errcode					= @errcode OUTPUT,
			@language					= @language

IF @ErrCode <> 0
BEGIN	
	RETURN
END
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF EXISTS(SELECT 1 FROM Customer WITH (NOLOCK) WHERE username= @username)
	OR EXISTS (SELECT 1 FROM Customer WITH (NOLOCK) WHERE username2 = @username)
	OR EXISTS(SELECT 1 FROM custSub WITH (NOLOCK) WHERE username= @username)
BEGIN
	SELECT @ErrMsg = CASE @Language 
						WHEN 'E' THEN 'This username is not available.'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](40001,@Language)
					END
	SELECT @ErrCode = 101		
	RETURN
END

--check for allow play horseracing
DECLARE @IsAllowedHR BIT
EXEC Acc_CheckHRAllowedCurrency
	@CurrencyID = @currency,
	@Allowed = @IsAllowedHR OUTPUT
IF @IsAllowedHR = 0 
	SELECT @Disable151_31 = 1


--Insert general info
EXEC dbo.Acc_Dep_CustomerInsUserInfo
	@custid = @custid OUTPUT,
	@creator = @creator,
	@username = @username,
	@userpwd = @userpwd,
	@pwdexpiry = NULL,
	@currency = @currency,
	@site = @site,
	@srecommend = 0,
	@mrecommend = 0,
	@recommend = 0,
	@roleid = 4,
	@TransferOption = NULL,
	@suspended = 0,
	
	@Disable151_31 = @Disable151_31,
	@Disable151_41 = @Disable151_41,
	@Disable151_51 = @Disable151_51,
	@Disable152_41 = @Disable152_41,
	@Disable152_51 = @Disable152_51,
	@Disable153_51 = @Disable153_51,
	@matchlimit = 1,
	--20150309@Johnson: disable virtual rate as default
	@virtualmultiplier = 0,	
	@DisableFinancial = 0,
	@DisableBingo = 0,
	@DisableNumber = @DisableNumber,
	@DisableCasino = 0,
	@DisableP2P = 1,
	@DisableFUNP2P = 1,
	@ISAUTORESETP2P = 1,
	@Disable162_1101 = 0,
	@DisableVirtualSports = @DisableVirtualSports,
	@DisableCasinoBonus = @DisableCasinoBonus,

	@DisableHRFO=0,
	
	@MaxPerMatch = @MaxPerMatchv1,
	@MaxPerMatchv2 = @MaxPerMatchv2,
	@MaxPerMatchv3 = @MaxPerMatchv3,
	@MaxPerMatchv5 = @MaxPerMatchv5,
	@MaxPerMatchv8 = @MaxPerMatchv8,
	@MaxPerMatchv10 = @MaxPerMatchv10,
	@MaxPerMatchv11 = @MaxPerMatchv11,
	@MaxPerMatchv44 = @MaxPerMatchv44,
	@MaxPerMatchv99 = @MaxPerMatchv99,
	@MaxPerMatchv99MP = @MaxPerMatchv99MP,
	@MaxPerMatchv161 = @MaxPerMatchv161,
	@MaxPerBallv161 = @MaxPerBallv161,

	@MaxPerMatchv154 = @MaxPerMatchv154,

	--Virtual Sport
	@MaxPerMatchv180 = @v180MaxPerMatch,
	@MaxPerMatchv181 = @v181MaxPerMatch,
	@MaxPerMatchv182 = @v182MaxPerMatch,
	@MaxPerMatchv183 = @v183MaxPerMatch,
	@MaxPerMatchv184 = @v184MaxPerMatch,
	@MaxPerMatchv185 = @v185MaxPerMatch,
	@MaxPerMatchv186 = @v186MaxPerMatch,

	--v151
	@MaxPerMatchv151_31 = @v151maxpermatch_31,
	@MaxPerMatchv151_41 = @v151maxpermatch_41,
	@MaxPerMatchv151_51 = @v151maxpermatch_51,
	
	--v152
	@MaxPerMatchv152_41  = @v152maxpermatch_41,
	@MaxPerMatchv152_51 = @v152maxpermatch_51,
	
	--v153
	@MaxPerMatchv153_51 = @v153maxpermatch_51,
	
	@v151IBCPositiontaking_31 = @v151IBCPositiontaking_31,--AutoIBCPT151_SA
	@v151IBCPositiontaking_41 = @v151IBCPositiontaking_41,--AutoIBCPT151_UK
	@v151IBCPositiontaking_51 = @v151IBCPositiontaking_51,--AutoIBCPT151_AU

	@v152IBCPositiontaking_41 = @v152IBCPositiontaking_41,--AutoIBCPT152_UK
	@v152IBCPositiontaking_51 = @v152IBCPositiontaking_51,--AutoIBCPT152_AU

	@v153IBCPositiontaking_51 = @v153IBCPositiontaking_51,--AutoIBCPT153_AU
	
	@hidekeno=@DisableKeno,

	@credit = 0,
	@maxcredit = NULL,
	@IP = @IP,
	@isinternal = 0,
	@TransferOption_dec = NULL,
	@Language = @Language,
	@ErrCode = @ErrCode OUTPUT,
	@ErrMsg = @ErrMsg OUTPUT
--Error occurs
IF @ErrCode <> 0
	RETURN

SELECT @Rollback= ' DELETE Dep_CustSetting WITH (ROWLOCK) WHERE custId ='+COALESCE(CAST(@custid AS VARCHAR(50)),SPACE(1))+
				 ' DELETE Dep_CustSetting3rd WITH (ROWLOCK) WHERE custId  ='+COALESCE(CAST(@custid AS VARCHAR(50)),SPACE(1))+
				 ' DELETE FROM Dep_CustSuper WITH(ROWLOCK) WHERE custId = '+COALESCE(CAST(@custid AS VARCHAR(50)),SPACE(1))+
			 	 ' DELETE P2PGameSetting WITH (ROWLOCK) WHERE custId  ='+COALESCE(CAST(@custid AS VARCHAR(50)),SPACE(1))+
				 ' DELETE P2PGroupComm WITH (ROWLOCK) WHERE custId  ='+COALESCE(CAST(@custid AS VARCHAR(50)),SPACE(1))+
				 ' DELETE CustGameType WITH(ROWLOCK) WHERE custid = '+COALESCE(CAST(@custid AS VARCHAR(50)),SPACE(1))	+
				 ' DELETE CustSettingGame WITH(ROWLOCK) WHERE custid = '+COALESCE(CAST(@custid AS VARCHAR(50)),SPACE(1))	+
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

UNION ALL	SELECT @custid, 3, 44, @v44apositiontaking_3, @v44mpositiontaking_3, @v44spositiontaking_3, 0, 0, 0, 0, @MinBetv44, @MaxBetv44, 0

UNION ALL	SELECT @custid, 1, 99, @v99apositiontaking_1, @v99mpositiontaking_1, @v99spositiontaking_1, 0, 0, 0, 0, @MinBetv99, @MaxBetv99, 0
UNION ALL	SELECT @custid, 2, 99, @v99apositiontaking_2, @v99mpositiontaking_2, @v99spositiontaking_2, 0, 0, 0, 0, @MinBetv99, @MaxBetv99, 0
UNION ALL	SELECT @custid, 3, 99, @v99apositiontaking_3, @v99mpositiontaking_3, @v99spositiontaking_3, 0, 0, 0, 0, @MinBetv99, @MaxBetv99, 0
UNION ALL	SELECT @custid, 20, 99, @v99apositiontaking_20, @v99mpositiontaking_20, @v99spositiontaking_20, 0, 0, 0, 0, @MinBetv99, @MaxBetv99, 0
--Mix Sports Parlay
UNION ALL	SELECT @custid, 9, 99, @v99apositiontaking_9, @v99mpositiontaking_9, @v99spositiontaking_9, 0, 0, 0, 0, @MinBetv99MP, @MaxBetv99MP, 0
--HRFO
UNION ALL	SELECT @custid, 20, 154, @v154apositiontaking_20, @v154mpositiontaking_20, @v154spositiontaking_20, 0, 0, 0, 0, @MinBetv154, @MaxBetv154, 0
IF @@ERROR <> 0
BEGIN
	--Error Occurs
	SELECT @ErrMsg = CASE @Language 
							when 'E' then 'Create customer fail. Please try again'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
						END	
			, @ErrCode=116
	
	-- ROLLBACK MANUALLY
	DELETE Dep_CustSetting WITH (ROWLOCK) WHERE custId  =@custid
	
	DELETE FROM Dep_CustSuper WITH(ROWLOCK) WHERE custId = @CustID
	
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	RETURN
END

--insert into Dep_CustSetting3rd
INSERT INTO [dbo].[Dep_CustSetting3rd]([custId], [bettype], [sporttype], [apositiontaking], [mpositiontaking], [spositiontaking],  [playerdiscount], [discount], [adiscount], [sdiscount], [Minbet], [Maxbet], [islive])

--v151
			SELECT @custid, 31, 151, @v151apositiontaking_31, @v151mpositiontaking_31, @v151spositiontaking_31, 0, 0, 0, @v151discount_31, @v151minbet_31, @v151maxbet_31, 0
UNION ALL	SELECT @custid, 32, 151, @v151apositiontaking_32, @v151mpositiontaking_32, @v151spositiontaking_32, 0, 0, 0, @v151discount_31, @v151minbet_31, @v151maxbet_31, 0
UNION ALL	SELECT @custid, 41, 151, @v151apositiontaking_41, @v151mpositiontaking_41, @v151spositiontaking_41, 0, 0, 0, @v151discount_41, @v151minbet_41, @v151maxbet_41, 0
UNION ALL	SELECT @custid, 42, 151, @v151apositiontaking_42, @v151mpositiontaking_42, @v151spositiontaking_42, 0, 0, 0, @v151discount_41, @v151minbet_41, @v151maxbet_41, 0
UNION ALL	SELECT @custid, 51, 151, @v151apositiontaking_51, @v151mpositiontaking_51, @v151spositiontaking_51, 0, 0, 0, @v151discount_51, @v151minbet_51, @v151maxbet_51, 0
UNION ALL	SELECT @custid, 52, 151, @v151spositiontaking_52, @v151mpositiontaking_52, @v151apositiontaking_52, 0, 0, 0, @v151discount_51, @v151minbet_51, @v151maxbet_51, 0

--v152
UNION ALL	SELECT @custid, 41, 152, @v152apositiontaking_41, @v152mpositiontaking_41, @v152spositiontaking_41, 0, 0, 0, @v152discount_41, @v152minbet_41, @v152maxbet_41, 0
UNION ALL	SELECT @custid, 42, 152, @v152apositiontaking_42, @v152mpositiontaking_42, @v152spositiontaking_42, 0, 0, 0, @v152discount_41, @v152minbet_41, @v152maxbet_41, 0
UNION ALL	SELECT @custid, 51, 152, @v152apositiontaking_51, @v152mpositiontaking_51, @v152spositiontaking_51, 0, 0, 0, @v152discount_51, @v152minbet_51, @v152maxbet_51, 0
UNION ALL	SELECT @custid, 52, 152, @v152apositiontaking_52, @v152mpositiontaking_52, @v152spositiontaking_52, 0, 0, 0, @v152discount_51, @v152minbet_51, @v152maxbet_51, 0

--v153
UNION ALL	SELECT @custid, 51, 153, @v153apositiontaking_51, @v153mpositiontaking_51, @v153spositiontaking_51, 0, 0, 0, @v153discount_51, @v153minbet_51, @v153maxbet_51, 0
UNION ALL	SELECT @custid, 52, 153, @v153apositiontaking_52, @v153mpositiontaking_52, @v153spositiontaking_52, 0, 0, 0, @v153discount_51, @v153minbet_51, @v153maxbet_51, 0

--v161
UNION ALL	SELECT @custid, 81, 161, @v161apositiontaking_81, @v161mpositiontaking_81, @v161spositiontaking_81, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 0--nonlive
UNION ALL	SELECT @custid, 83, 161, @v161apositiontaking_83, @v161mpositiontaking_83, @v161spositiontaking_83, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 0--nonlive
UNION ALL	SELECT @custid, 85, 161, @v161alivepositiontaking_85, @v161mlivepositiontaking_85, @v161slivepositiontaking_85, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 1--live

UNION ALL	SELECT @custid, 86, 161, @v161apositiontaking_86, @v161mpositiontaking_86, @v161spositiontaking_86, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 0--nonlive
UNION ALL	SELECT @custid, 86, 161,@v161alivepositiontaking_86, @v161mlivepositiontaking_86, @v161slivepositiontaking_86, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 1--live 

UNION ALL	SELECT @custid, 87, 161, @v161alivepositiontaking_87, @v161mlivepositiontaking_87, @v161slivepositiontaking_87, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 1--live
UNION ALL	SELECT @custid, 88, 161, @v161apositiontaking_88, @v161mpositiontaking_88, @v161spositiontaking_88, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 0--nonlive
UNION ALL	SELECT @custid, 89, 161, @v161alivepositiontaking_89, @v161mlivepositiontaking_89, @v161slivepositiontaking_89, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 1--live
UNION ALL	SELECT @custid, 90, 161, @v161alivepositiontaking_90, @v161mlivepositiontaking_90, @v161slivepositiontaking_90, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 1--live

IF @@ERROR <> 0
BEGIN
	--Error Occurs
	
	SELECT @ErrMsg = CASE @Language 
							when 'E' then 'Create customer fail. Please try again'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
						END	
			, @ErrCode=116
	
	-- ROLLBACK MANUALLY
	DELETE Dep_CustSetting WITH (ROWLOCK) WHERE custId  =@custid
	DELETE Dep_CustSetting3rd WITH (ROWLOCK) WHERE custId  =@custid
	
	DELETE FROM Dep_CustSuper WITH(ROWLOCK) WHERE custId = @CustID
	
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	RETURN
END 

--Insert Into P2P Setting
INSERT INTO  dbo.P2PGAMESETTING WITH(ROWLOCK)
	(custId,bettype,StakeLevel1,StakeLevel2,StakeLevel3,StakeLevel4,StakeLevel5)
SELECT @custid  , 1001 , 1 , 0 , 0 , 0 , 0
UNION ALL SELECT @custid  , 1002 , 1 , 0 , 0 , 0 , 0

IF @@ERROR <> 0
BEGIN
	--Error Occurs
	SELECT @ErrMsg = CASE @Language 
							when 'E' then 'Create customer fail. Please try again'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
						END	
			, @ErrCode=116
	
	-- ROLLBACK MANUALLY
	DELETE P2PGameSetting WITH (ROWLOCK) WHERE custId  =@custid
	
	DELETE Dep_CustSetting WITH (ROWLOCK) WHERE custId  =@custid
	DELETE Dep_CustSetting3rd WITH (ROWLOCK) WHERE custId  =@custid	
	DELETE FROM Dep_CustSuper WITH(ROWLOCK) WHERE custId = @CustID
	
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	RETURN
END  

--Insert Into P2P Commision
INSERT INTO dbo.P2PGroupComm WITH(ROWLOCK)
           (custId,groupID,sdiscount,adiscount,discount,playerdiscount)
SELECT @custid  , 1 , 0 , 0 , 0 , 0 
UNION ALL SELECT @custid  , 2 , 0 , 0 , 0 , 0 

IF @@ERROR <> 0
BEGIN
	--Error Occurs
	SELECT @ErrMsg = CASE @Language 
							when 'E' then 'Create customer fail. Please try again'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
						END	
			, @ErrCode=116
	
	-- ROLLBACK MANUALLY
	DELETE Dep_CustSetting WITH (ROWLOCK) WHERE custId  =@custid
	DELETE Dep_CustSetting3rd WITH (ROWLOCK) WHERE custId  =@custid
	DELETE FROM Dep_CustSuper WITH(ROWLOCK) WHERE custId = @CustID
	
	DELETE P2PGameSetting WITH (ROWLOCK) WHERE custId  =@custid
	DELETE P2PGroupComm WITH (ROWLOCK) WHERE custId  =@custid
		
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	RETURN
END 

--Insert live casino setting
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
VALUES (@custid , 1101, 162, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0 ,0)
--check min bet min, 
--SELECT Bettype,MinBet 
--INTO #Minbet
--FROM dbo.ProductBetSetting WHERE Currency=@currency
--IF EXISTS (SELECT TOP 1 1 FROM #data d INNER JOIN #Minbet m ON d.bettype=m.bettype WHERE d.Minbet < m.minbet)
--BEGIN
--	Declare @vMaxPT money
--	SELECT @vMaxPT=m.Minbet FROM #data d INNER JOIN #Minbet m ON d.bettype=m.bettype WHERE d.Minbet < m.minbet ORDER BY d.bettype DESC
--	SELECT
--		@ErrMsg =	case @Language 
--							when 'E' then 'Min bet must be greater than '+ COALESCE(CAST(@vMaxPT AS VARCHAR(50)),SPACE(1)) +'.'
--							ELSE [dbo].[f_Get_MsgNamebyMsgID](10006,@Language)
--					end
										
--	SELECT @ErrCode = 107
--	EXEC sp_executesql @Rollback 
--	RETURN 
--END

--check PT MaxPT
--SELECT Bettype,MaxPositiontaking,Maxsdiscount
--INTO #KenoPT
--FROM dbo.ProductGlobalSetting WHERE Sporttype=202
--IF EXISTS (SELECT TOP 1 1 FROM #data d INNER JOIN #KenoPT k ON d.bettype = k.bettype 
--	WHERE d.sPositionTaking>k.MaxPositiontaking)
--BEGIN
--	SELECT @ErrCode = 3,
--			@ErrMsg = CASE @Language 
--						WHEN 'E' THEN 'Keno position taking is invalid .'
--						ELSE [dbo].[f_Get_MsgNamebyMsgID](20001,@Language)
--			          END
--	EXEC sp_executesql @Rollback 
--	RETURN
--END
-- Insert 
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
SELECT @custid , bettype, 202, ISNULL(aPositionTaking,0), ISNULL(mPositionTaking,0), ISNULL(sPositionTaking,0), 0, 0, 0, 0, 0, 0 ,0 ,0
FROM #data
WHERE bettype =1501

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
	
	DELETE Dep_CustSetting WITH (ROWLOCK) WHERE CustId = @custid
	DELETE Dep_CustSetting3rd WITH (ROWLOCK) WHERE CustId = @custid
	DELETE Dep_CustSuper WITH(ROWLOCK) WHERE CustId = @CustID
	DELETE P2PGameSetting WITH (ROWLOCK) WHERE CustId  = @custid
	DELETE P2PGroupComm WITH (ROWLOCK) WHERE CustId  = @custid
	DELETE CustGameType WITH(ROWLOCK) WHERE Custid = @custid
	DELETE CustSettingGame WITH(ROWLOCK) WHERE Custid = @custid
	DELETE CustOverrideGame WITH(ROWLOCK) WHERE Custid = @custid
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID 
	RETURN
END 

--Insert live casino PT
INSERT INTO [CustOverrideGame]
           ([CustID]
           ,[Bettype]
           ,[Sporttype]
           ,[minpositiontaking])
VALUES(@custid, 1101, 162, 0)

IF @@ERROR <> 0
BEGIN
	--Error Occurs
	SELECT @ErrMsg = CASE @Language 
							when 'E' then 'Create customer fail. Please try again'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
						END	
			, @ErrCode=116
	
	-- ROLLBACK MANUALLY
	DELETE P2PGameSetting WITH (ROWLOCK) WHERE custId  =@custid
	DELETE P2PGroupComm WITH (ROWLOCK) WHERE custId  =@custid
	DELETE CustSettingGame WITH(ROWLOCK) WHERE custid = @custid
	DELETE CustOverrideGame WITH(ROWLOCK) WHERE custid = @custid
	
	DELETE FROM Dep_CustSuper WITH(ROWLOCK) WHERE custId = @CustID
	
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	RETURN
END  



---------------------------------------=VIRTUAL SPORT=----------------------------------------
EXEC Acc_Dep_CustomerInsMemberVirtualSports_Com
	@custid = @custid, 
	@v180MinBet = @v180MinBet,
	@v180MaxBet = @v180MaxBet,
	@v180sPositionTaking = @v180sPositionTaking,
	@v180mPositionTaking = @v180mPositionTaking,
	@v180aPositionTaking = @v180aPositionTaking,

	@v181MinBet = @v181MinBet,
	@v181MaxBet = @v181MaxBet,
	@v181sPositionTaking = @v181sPositionTaking,
	@v181mPositionTaking = @v181mPositionTaking,
	@v181aPositionTaking = @v181aPositionTaking,

	@v182MinBet = @v182MinBet,
	@v182MaxBet = @v182MaxBet,
	@v182sPositionTaking = @v182sPositionTaking,
	@v182mPositionTaking = @v182mPositionTaking,
	@v182aPositionTaking = @v182aPositionTaking,

	@v183MinBet = @v183MinBet,
	@v183MaxBet = @v183MaxBet,
	@v183sPositionTaking = @v183sPositionTaking,
	@v183mPositionTaking = @v183mPositionTaking,
	@v183aPositionTaking = @v183aPositionTaking,

	@v184MinBet = @v184MinBet,
	@v184MaxBet = @v184MaxBet,
	@v184sPositionTaking = @v184sPositionTaking,
	@v184mPositionTaking = @v184mPositionTaking,
	@v184aPositionTaking = @v184aPositionTaking,

	@v185MinBet = @v185MinBet,
	@v185MaxBet = @v185MaxBet,
	@v185sPositionTaking = @v185sPositionTaking,
	@v185mPositionTaking = @v185mPositionTaking,
	@v185aPositionTaking = @v185aPositionTaking,

	@v186MinBet = @v186MinBet,
	@v186MaxBet = @v186MaxBet,
	@v186sPositionTaking = @v186sPositionTaking,
	@v186mPositionTaking = @v186mPositionTaking,
	@v186aPositionTaking = @v186aPositionTaking,
	
	@Language = @Language,
	@ErrCode = @ErrCode OUTPUT,
	@ErrMsg = @ErrMsg OUTPUT

----------------------CHECK Error

 IF @ErrCode <> 0 
 BEGIN
 	
 	DELETE Dep_CustSetting WITH (ROWLOCK) WHERE custId  =@custid
	DELETE Dep_CustSetting3rd WITH (ROWLOCK) WHERE custId  =@custid
	DELETE FROM Dep_CustSuper WITH(ROWLOCK) WHERE custId = @CustID
	
	DELETE P2PGameSetting WITH (ROWLOCK) WHERE custId  =@custid
	DELETE P2PGroupComm WITH (ROWLOCK) WHERE custId  =@custid
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
 	
 	DELETE Dep_CustSetting WITH (ROWLOCK) WHERE custId  =@custid
	DELETE Dep_CustSetting3rd WITH (ROWLOCK) WHERE custId  =@custid
	DELETE FROM Dep_CustSuper WITH(ROWLOCK) WHERE custId = @CustID
	
	DELETE P2PGameSetting WITH (ROWLOCK) WHERE custId  =@custid
	DELETE P2PGroupComm WITH (ROWLOCK) WHERE custId  =@custid
	DELETE CustSettingGame WITH(ROWLOCK) WHERE custid = @custid
	DELETE CustOverrideGame WITH(ROWLOCK) WHERE custid = @custid	
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	DELETE Dep_AgentCommRate WITH(ROWLOCK) WHERE custid = @custid
 	RETURN 
 END  
----------------------------END INSERT------------------------------------
	
SET @endRun = GETDATE()
SET @duration  = DATEDIFF (millisecond,@startRun,@endRun)

--write log keno
DECLARE @str_bet varchar(1000)='',
		@str_spt varchar(1000)='',
		@str_mpt varchar(1000)='',
		@str_apt varchar(1000)='',
		@i INT=1501
WHILE (@i<=(SELECT max(Bettype) From #data))
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

DECLARE @LogSPData VARCHAR(MAX)
--Write general info
SELECT @LogSPData = '<Acc_Dep_CustomerInsMember_Com custid="'+ COALESCE(CAST(@custid AS VARCHAR(50)),SPACE(1)) + '" ' +
'creator="'+ COALESCE(CAST(@creator AS VARCHAR(50)),SPACE(1)) + '" ' +
'username="'+ COALESCE(CAST(@username AS VARCHAR(20)),SPACE(1)) + '" ' +
'site="'+ COALESCE(CAST(@site AS VARCHAR(100)),SPACE(1)) + '" ' +
'currency="'+ COALESCE(CAST(@currency AS VARCHAR(50)),SPACE(1)) + '" ' +
'IP="'+ COALESCE(CAST(@IP AS VARCHAR(15)),SPACE(1)) + '" ' +
'Language="'+ COALESCE(CAST(@Language AS VARCHAR(2)),SPACE(1)) + '" ' +
'ErrCode="'+ COALESCE(CAST(@ErrCode AS VARCHAR(50)),SPACE(1)) + '" ' +
'ErrMsg="'+ COALESCE(CAST(@ErrMsg AS VARCHAR(4000)),SPACE(1)) + '" />'
EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP 
	@UserID = @Creator,
	@CustID = @CustID,
	@ActionID = 2412,
	@TrackingValue = @LogSPData,
	@duration = @duration
	
--Write commission log
SELECT @LogSPData = '<Acc_Dep_CustomerInsMember_Com custid="'+ COALESCE(CAST(@custid AS VARCHAR(50)),SPACE(1)) + '" ' +
'v151discount_31="'+ COALESCE(CAST(@v151discount_31 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v151discount_41="'+ COALESCE(CAST(@v151discount_41 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v151discount_51="'+ COALESCE(CAST(@v151discount_51 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v152discount_41="'+ COALESCE(CAST(@v152discount_41 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v152discount_51="'+ COALESCE(CAST(@v152discount_51 AS VARCHAR(50)),SPACE(1)) + '" ' +
'v153discount_51="'+ COALESCE(CAST(@v153discount_51 AS VARCHAR(50)),SPACE(1)) + '" />'
EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP 
	@UserID = @Creator,
	@CustID = @CustID,
	@ActionID = 2601,
	@TrackingValue = @LogSPData,
	@duration = @duration

--Write status log
SELECT @LogSPData = '<Acc_Dep_CustomerInsMember_Com custid="'+ COALESCE(CAST(@custid AS VARCHAR(50)),SPACE(1)) + '" ' +
'disablehorseracing="'+ COALESCE(CAST(@Disable151_31 AS VARCHAR(1)),SPACE(1)) + '" ' +
'disableOT="'+ COALESCE(CAST(@Disable151_41 AS VARCHAR(1)),SPACE(1)) + '" ' +
'disable151_51="'+ COALESCE(CAST(@Disable151_51 AS VARCHAR(1)),SPACE(1)) + '" ' +
'disable152_41="'+ COALESCE(CAST(@Disable152_41 AS VARCHAR(1)),SPACE(1)) + '" ' +
'disable152_51="'+ COALESCE(CAST(@Disable152_51 AS VARCHAR(1)),SPACE(1)) + '" ' +
'disable153_51="'+ COALESCE(CAST(@Disable153_51 AS VARCHAR(1)),SPACE(1)) + '" ' +
'disablenumber="'+ COALESCE(CAST(@disablenumber AS VARCHAR(1)),SPACE(1)) + '" ' +
'DisableVirtualSports="'+ COALESCE(CAST(@DisableVirtualSports AS VARCHAR(1)),SPACE(1)) + '" />'
EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP 
	@UserID = @Creator,
	@CustID = @CustID,
	@ActionID = 2202,
	@TrackingValue = @LogSPData,
	@duration = @duration


--Write Bet setting log
SELECT @LogSPData = '<Acc_Dep_CustomerInsMember_Com custid="'+ COALESCE(CAST(@custid AS VARCHAR(50)),SPACE(1)) + '" ' +
'MinBv1="'+ COALESCE(CAST(@MinBetv1 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv1="'+ COALESCE(CAST(@MaxBetv1 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv1="'+ COALESCE(CAST(@MaxPerMatchv1 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MinBv2="'+ COALESCE(CAST(@MinBetv2 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv2="'+ COALESCE(CAST(@MaxBetv2 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv2="'+ COALESCE(CAST(@MaxPerMatchv2 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MinBv3="'+ COALESCE(CAST(@MinBetv3 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv3="'+ COALESCE(CAST(@MaxBetv3 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv3="'+ COALESCE(CAST(@MaxPerMatchv3 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MinBv5="'+ COALESCE(CAST(@MinBetv5 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv5="'+ COALESCE(CAST(@MaxBetv5 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv5="'+ COALESCE(CAST(@MaxPerMatchv5 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MinBv8="'+ COALESCE(CAST(@MinBetv8 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv8="'+ COALESCE(CAST(@MaxBetv8 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv8="'+ COALESCE(CAST(@MaxPerMatchv8 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MinBv10="'+ COALESCE(CAST(@MinBetv10 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv10="'+ COALESCE(CAST(@MaxBetv10 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv10="'+ COALESCE(CAST(@MaxPerMatchv10 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MinBv11="'+ COALESCE(CAST(@MinBetv11 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv11="'+ COALESCE(CAST(@MaxBetv11 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv11="'+ COALESCE(CAST(@MaxPerMatchv11 AS VARCHAR(50)),SPACE(1)) + '" ' +

'MinBv44="'+ COALESCE(CAST(@MinBetv44 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv44="'+ COALESCE(CAST(@MaxBetv44 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv44="'+ COALESCE(CAST(@MaxPerMatchv44 AS VARCHAR(50)),SPACE(1)) + '" ' +

'MinBv99="'+ COALESCE(CAST(@MinBetv99 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv99="'+ COALESCE(CAST(@MaxBetv99 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv99="'+ COALESCE(CAST(@MaxPerMatchv99 AS VARCHAR(50)),SPACE(1)) + '" ' +

--HRFO
'MinBv154="'+ COALESCE(CAST(@MinBetv154 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv154="'+ COALESCE(CAST(@MaxBetv154 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv154="'+ COALESCE(CAST(@MaxPerMatchv154 AS VARCHAR(50)),SPACE(1)) + '" ' +

'MinBv99MP="'+ COALESCE(CAST(@MinBetv99MP AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv99MP="'+ COALESCE(CAST(@MaxBetv99MP AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv99MP="'+ COALESCE(CAST(@MaxPerMatchv99MP AS VARCHAR(50)),SPACE(1)) + '" ' +
'MinBv161="'+ COALESCE(CAST(@MinBetv161 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv161="'+ COALESCE(CAST(@MaxBetv161 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv161="'+ COALESCE(CAST(@MaxPerMatchv161 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPBv161="' + COALESCE(CAST(@MaxPerBallv161 AS VARCHAR(50)),SPACE(1)) + '" ' +
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
 @str_bet+ 
'MinBv180="'+ COALESCE(CAST(@v180MinBet AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv180="'+ COALESCE(CAST(@v180MaxBet AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv180="'+ COALESCE(CAST(@v180MaxPerMatch AS VARCHAR(50)),SPACE(1)) + '" ' +

'MinBv181="'+ COALESCE(CAST(@v181MinBet AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv181="'+ COALESCE(CAST(@v181MaxBet AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv181="'+ COALESCE(CAST(@v181MaxPerMatch AS VARCHAR(50)),SPACE(1)) + '" ' +

'MinBv182="'+ COALESCE(CAST(@v182MinBet AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv182="'+ COALESCE(CAST(@v182MaxBet AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv182="'+ COALESCE(CAST(@v182MaxPerMatch AS VARCHAR(50)),SPACE(1)) + '" ' +

'MinBv183="'+ COALESCE(CAST(@v183MinBet AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv183="'+ COALESCE(CAST(@v183MaxBet AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv183="'+ COALESCE(CAST(@v183MaxPerMatch AS VARCHAR(50)),SPACE(1)) + '" ' +

'MinBv184="'+ COALESCE(CAST(@v184MinBet AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv184="'+ COALESCE(CAST(@v184MaxBet AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv184="'+ COALESCE(CAST(@v184MaxPerMatch AS VARCHAR(50)),SPACE(1)) + '" ' +

'MinBv185="'+ COALESCE(CAST(@v185MinBet AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv185="'+ COALESCE(CAST(@v185MaxBet AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv185="'+ COALESCE(CAST(@v185MaxPerMatch AS VARCHAR(50)),SPACE(1)) + '" ' +

'MinBv186="'+ COALESCE(CAST(@v186MinBet AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv186="'+ COALESCE(CAST(@v186MaxBet AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv186="'+ COALESCE(CAST(@v186MaxPerMatch AS VARCHAR(50)),SPACE(1)) + 
'" />' 

EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP 
	@UserID = @Creator,
	@CustID = @CustID,
	@ActionID = 2009,
	@TrackingValue = @LogSPData,
	@duration = @duration
	

--Write PT log
SELECT @LogSPData = '<Acc_Dep_CustomerInsMember_Com><s spt_1="'+ COALESCE(CAST(@v1spositiontaking_1 AS VARCHAR(50)),SPACE(1)) + '" ' +
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

'v44spt_3="'+ COALESCE(CAST(@v44spositiontaking_3 AS VARCHAR(50)),SPACE(1)) + '" ' +


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
'v153spt_52="'+ COALESCE(CAST(@v153spositiontaking_52 AS VARCHAR(50)),SPACE(1)) + '" ' +
@str_spt+
'v180spt="'+ COALESCE(CAST(@v180sPositionTaking AS VARCHAR(50)),SPACE(1)) + '" ' +
'v181spt="'+ COALESCE(CAST(@v181sPositionTaking AS VARCHAR(50)),SPACE(1)) + '" ' +
'v182spt="'+ COALESCE(CAST(@v182sPositionTaking AS VARCHAR(50)),SPACE(1)) + '" ' +
'v183spt="'+ COALESCE(CAST(@v183sPositionTaking AS VARCHAR(50)),SPACE(1)) + '" ' +
'v184spt="'+ COALESCE(CAST(@v184sPositionTaking AS VARCHAR(50)),SPACE(1)) + '" ' +
'v185spt="'+ COALESCE(CAST(@v185sPositionTaking AS VARCHAR(50)),SPACE(1)) + '" ' +
'v186spt="'+ COALESCE(CAST(@v186sPositionTaking AS VARCHAR(50)),SPACE(1)) + '" />' +


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

'v161mpt_81="'+ COALESCE(CONVERT(VARCHAR(50),@v161mpositiontaking_81,2),SPACE(1)) + '" ' +
'v161mpt_83="'+ COALESCE(CONVERT(VARCHAR(50),@v161mpositiontaking_83,2),SPACE(1)) + '" ' +
'v161mpt_86="'+ COALESCE(CONVERT(VARCHAR(50),@v161mpositiontaking_86,2),SPACE(1)) + '" ' +
'v161mpt_88="'+ COALESCE(CONVERT(VARCHAR(50),@v161mpositiontaking_88,2),SPACE(1)) + '" ' +
'v161mlivept_85="'+ COALESCE(CONVERT(VARCHAR(50),@v161mlivepositiontaking_85,2),SPACE(1)) + '" ' +
'v161mlivept_86="'+ COALESCE(CONVERT(VARCHAR(50),@v161mlivepositiontaking_86,2),SPACE(1)) + '" ' +
'v161mlivept_87="'+ COALESCE(CONVERT(VARCHAR(50),@v161mlivepositiontaking_87,2),SPACE(1)) + '" ' +
'v161mlivept_89="'+ COALESCE(CONVERT(VARCHAR(50),@v161mlivepositiontaking_89,2),SPACE(1)) + '" ' +
'v161mlivept_90="'+ COALESCE(CONVERT(VARCHAR(50),@v161mlivepositiontaking_90,2),SPACE(1)) + '" ' +

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
'v153mpt_52="'+ COALESCE(CAST(@v153mpositiontaking_52 AS VARCHAR(50)),SPACE(1)) + '" ' +
@str_mpt+
'v180mpt="'+ COALESCE(CAST(@v180mPositionTaking AS VARCHAR(50)),SPACE(1)) + '" ' +
'v181mpt="'+ COALESCE(CAST(@v181mPositionTaking AS VARCHAR(50)),SPACE(1)) + '" ' +
'v182mpt="'+ COALESCE(CAST(@v182mPositionTaking AS VARCHAR(50)),SPACE(1)) + '" ' +
'v183mpt="'+ COALESCE(CAST(@v183mPositionTaking AS VARCHAR(50)),SPACE(1)) + '" ' +
'v184mpt="'+ COALESCE(CAST(@v184mPositionTaking AS VARCHAR(50)),SPACE(1)) + '" ' +
'v185mpt="'+ COALESCE(CAST(@v185mPositionTaking AS VARCHAR(50)),SPACE(1)) + '" ' +
'v186mpt="'+ COALESCE(CAST(@v186mPositionTaking AS VARCHAR(50)),SPACE(1)) + '" />' +

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

'v161apt_81="'+ COALESCE(CONVERT(VARCHAR(50),@v161apositiontaking_81,2),SPACE(1)) + '" ' +
'v161apt_83="'+ COALESCE(CONVERT(VARCHAR(50),@v161apositiontaking_83,2),SPACE(1)) + '" ' +
'v161apt_86="'+ COALESCE(CONVERT(VARCHAR(50),@v161apositiontaking_86,2),SPACE(1)) + '" ' +
'v161apt_88="'+ COALESCE(CONVERT(VARCHAR(50),@v161apositiontaking_88,2),SPACE(1)) + '" ' +
'v161alivept_85="'+ COALESCE(CONVERT(VARCHAR(50),@v161alivepositiontaking_85,2),SPACE(1)) + '" ' +
'v161alivept_86="'+ COALESCE(CONVERT(VARCHAR(50),@v161alivepositiontaking_86,2),SPACE(1)) + '" ' +
'v161alivept_87="'+ COALESCE(CONVERT(VARCHAR(50),@v161alivepositiontaking_87,2),SPACE(1)) + '" ' +
'v161alivept_89="'+ COALESCE(CONVERT(VARCHAR(50),@v161alivepositiontaking_89,2),SPACE(1)) + '" ' +
'v161alivept_90="'+ COALESCE(CONVERT(VARCHAR(50),@v161alivepositiontaking_90,2),SPACE(1)) + '" ' +

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
@str_apt+
'v180apt="'+ COALESCE(CAST(@v180aPositionTaking AS VARCHAR(50)),SPACE(1)) + '" '+
'v181apt="'+ COALESCE(CAST(@v181aPositionTaking AS VARCHAR(50)),SPACE(1)) + '" '+
'v182apt="'+ COALESCE(CAST(@v182aPositionTaking AS VARCHAR(50)),SPACE(1)) + '" '+
'v183apt="'+ COALESCE(CAST(@v183aPositionTaking AS VARCHAR(50)),SPACE(1)) + '" '+
'v184apt="'+ COALESCE(CAST(@v184aPositionTaking AS VARCHAR(50)),SPACE(1)) + '" '+
'v185apt="'+ COALESCE(CAST(@v185aPositionTaking AS VARCHAR(50)),SPACE(1)) + '" '+
'v186apt="'+ COALESCE(CAST(@v186aPositionTaking AS VARCHAR(50)),SPACE(1)) + '" />'+
'</Acc_Dep_CustomerInsMember_Com>' 


EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP 
	@UserID = @Creator,
	@CustID = @CustID,
	@ActionID = 2701,
	@TrackingValue = @LogSPData,
	@duration = @duration

DROP TABLE #data
--DROP TABLE #Minbet
--DROP TABLE #KenoPT

END
