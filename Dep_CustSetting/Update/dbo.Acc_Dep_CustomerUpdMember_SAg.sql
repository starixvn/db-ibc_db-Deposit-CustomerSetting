ALTER PROCEDURE [dbo].[Acc_Dep_CustomerUpdMember_SAg]

    @custid int, -- Master ID
	@UserID int = 0,

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
	
	@minbetv99mp money = 0,
	@maxbetv99mp money = 0,
	@maxpermatchv99mp money = 0,

	@minbetv161 money = 0,				
	@maxbetv161 money = 0,
	@maxpermatchv161 money = 0,	

	@maxperballv161 money = 0,
	
	--Racing Bet Setting
	@v151minbet_31			money = 0,	
	@v151maxbet_31			money = 0,	
	@v151maxpermatch_31		money = 0,	

	@v151minbet_41			money,		
	@v151maxbet_41			money,		
	@v151maxpermatch_41		money,		
	
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
	
	@v44spositiontaking_3 smallmoney,	
	
	@v99spositiontaking_1 smallmoney,
	@v99spositiontaking_2 smallmoney,
	@v99spositiontaking_3 smallmoney,	
	@v99spositiontaking_20 smallmoney,	
	@v154spositiontaking_20 smallmoney,	
	
	@v99spositiontaking_9 smallmoney = 0,

	@v161spositiontaking_81 smallmoney = 0, 				
	@v161spositiontaking_83 smallmoney = 0,
	@v161spositiontaking_86 smallmoney = 0,
	@v161spositiontaking_88 smallmoney = 0,
	
	@v161slivepositiontaking_85 smallmoney = 0,
	@v161slivepositiontaking_86 smallmoney = 0,
	@v161slivepositiontaking_87	smallmoney = 0,
	@v161slivepositiontaking_89	smallmoney = 0,
	@v161slivepositiontaking_90	smallmoney = 0,

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
	
	@v1mpositiontaking_1 smallmoney = 0,
	@v1mpositiontaking_2 smallmoney = 0,
	@v1mpositiontaking_3 smallmoney = 0,
	@v1mpositiontaking_4 smallmoney = 0,
	@v1mpositiontaking_5 smallmoney = 0,
	@v1mpositiontaking_6 smallmoney = 0,
	@v1mpositiontaking_7 smallmoney = 0,
	@v1mpositiontaking_8 smallmoney = 0,
	@v1mpositiontaking_9 smallmoney = 0,
	@v1mpositiontaking_10 smallmoney = 0,
	@v1mlivepositiontaking_1 smallmoney = 0,
	@v1mlivepositiontaking_3 smallmoney = 0,
	@v1mlivepositiontaking_7 smallmoney = 0,
	@v1mlivepositiontaking_8 smallmoney = 0,
	
	@v2mpositiontaking_1 smallmoney = 0,
	@v2mpositiontaking_2 smallmoney = 0,
	@v2mpositiontaking_3 smallmoney = 0,
	@v2mpositiontaking_7 smallmoney = 0,
	@v2mpositiontaking_8 smallmoney = 0,
	@v2mpositiontaking_20 smallmoney = 0,
	
	@v3mpositiontaking_1 smallmoney = 0,
	@v3mpositiontaking_2 smallmoney = 0,
	@v3mpositiontaking_3 smallmoney = 0,	
	@v3mpositiontaking_20 smallmoney = 0,
	
	@v5mpositiontaking_1 smallmoney = 0,
	@v5mpositiontaking_2 smallmoney = 0,
	@v5mpositiontaking_3 smallmoney = 0,	
	@v5mpositiontaking_20 smallmoney = 0,
	
	@v8mpositiontaking_1 smallmoney = 0,	
	@v8mpositiontaking_3 smallmoney = 0,	
	@v8mpositiontaking_20 smallmoney = 0,
	
	@v10mpositiontaking_1 smallmoney = 0,
	@v10mpositiontaking_2 smallmoney = 0,
	@v10mpositiontaking_3 smallmoney = 0,	
	@v10mpositiontaking_20 smallmoney = 0,
	
	@v11mpositiontaking_1 smallmoney = 0,	
	@v11mpositiontaking_20 smallmoney = 0,
	
	@v44mpositiontaking_3 smallmoney = 0,
	
	@v99mpositiontaking_1 smallmoney = 0,
	@v99mpositiontaking_2 smallmoney = 0,
	@v99mpositiontaking_3 smallmoney = 0,		
	@v99mpositiontaking_20 smallmoney = 0,
	@v154mpositiontaking_20 smallmoney = 0,

	@v99mpositiontaking_9 smallmoney = 0,

	@v161mpositiontaking_81 smallmoney = 0,        
	@v161mpositiontaking_83 smallmoney = 0,
	@v161mpositiontaking_86 smallmoney = 0,
	@v161mpositiontaking_88 smallmoney = 0,
	
	@v161mlivepositiontaking_85 smallmoney = 0,
	@v161mlivepositiontaking_86 smallmoney = 0,
	@v161mlivepositiontaking_87 smallmoney = 0,
	@v161mlivepositiontaking_89 smallmoney = 0,
	@v161mlivepositiontaking_90 smallmoney = 0,
	
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

	@Language VARCHAR(2) = 'E',
	@IP VARCHAR(15)='',
	@ErrCode INT = 0 OUTPUT,
	@ErrMsg NVARCHAR(4000) = '' OUTPUT
AS

--@Source Control
/*
Created: 20120409@Dom
Task : Super update MinBet, MaxBet, MaxPerMatch, PT, Commission of Master agent
DB: DBTrans.bodb02

Revisions:
    - 20121128@Elodie: Get an error message from f_Get_MsgNameByMsgID function by language
	- 20130918@Don: Supporting save log of Number Game PT with format such as "0.995", "0.925", ...
	- 20131014@Francis: Support updating virtual sports with settings via XML param
    - 20131119@Francis: Update 3rd product commission of super will not impact 3rd product commission of its downline members anymore
	- 20131108@Elodie: Splitting bodb02 into CustDB (call sports, bettype by link database)	
	- 20140512@Florent: Add new sport keno 202
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
--set default pt = 0 to super

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

SELECT @v182MinBet = MinBet, @v182MaxBet = MaxBet, @v182MaxPerMatch = MaxPerMatch, @v182sPositionTaking = sPositionTaking, @v182mPositionTaking = mPositionTaking, @v182aPositionTaking = aPositionTaking
FROM #input
WHERE SportType = 182

DECLARE @v183MinBet MONEY,
	@v183MaxBet MONEY,
	@v183MaxPerMatch MONEY,
	@v183sPositionTaking SMALLMONEY,
	@v183mPositionTaking SMALLMONEY,
	@v183aPositionTaking SMALLMONEY

SELECT @v183MinBet = MinBet, @v183MaxBet = MaxBet, @v183MaxPerMatch = MaxPerMatch, @v183sPositionTaking = sPositionTaking, @v183mPositionTaking = mPositionTaking, @v183aPositionTaking = aPositionTaking
FROM #input
WHERE SportType = 183

DECLARE @v184MinBet MONEY,
	@v184MaxBet MONEY,
	@v184MaxPerMatch MONEY,
	@v184sPositionTaking SMALLMONEY,
	@v184mPositionTaking SMALLMONEY,
	@v184aPositionTaking SMALLMONEY

SELECT @v184MinBet = MinBet, @v184MaxBet = MaxBet, @v184MaxPerMatch = MaxPerMatch, @v184sPositionTaking = sPositionTaking, @v184mPositionTaking = mPositionTaking, @v184aPositionTaking = aPositionTaking
FROM #input
WHERE SportType = 184

DECLARE @v185MinBet MONEY,
	@v185MaxBet MONEY,
	@v185MaxPerMatch MONEY,
	@v185sPositionTaking SMALLMONEY,
	@v185mPositionTaking SMALLMONEY,
	@v185aPositionTaking SMALLMONEY

SELECT @v185MinBet = MinBet, @v185MaxBet = MaxBet, @v185MaxPerMatch = MaxPerMatch, @v185sPositionTaking = sPositionTaking, @v185mPositionTaking = mPositionTaking, @v185aPositionTaking = aPositionTaking
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



SELECT @v1spositiontaking_1		= 0,
	@v1spositiontaking_2		= 0,
	@v1spositiontaking_3		= 0,
	@v1spositiontaking_4		= 0,
	@v1spositiontaking_5		= 0,
	@v1spositiontaking_6		= 0,
	@v1spositiontaking_7		= 0,
	@v1spositiontaking_8		= 0,
	@v1spositiontaking_9		= 0,
	@v1spositiontaking_10		= 0,
	@v1slivepositiontaking_1	= 0,
	@v1slivepositiontaking_3	= 0,
	@v1slivepositiontaking_7	= 0,
	@v1slivepositiontaking_8	= 0,
								
	@v2spositiontaking_1		= 0,
	@v2spositiontaking_2		= 0,
	@v2spositiontaking_3		= 0,
	@v2spositiontaking_7		= 0,
	@v2spositiontaking_8		= 0,
	@v2spositiontaking_20		= 0,
								
	@v3spositiontaking_1		= 0,
	@v3spositiontaking_2		= 0,
	@v3spositiontaking_3		= 0,
	@v3spositiontaking_20		= 0,
								
	@v5spositiontaking_1		= 0,
	@v5spositiontaking_2		= 0,
	@v5spositiontaking_3		= 0,
	@v5spositiontaking_20		= 0,
								
	@v8spositiontaking_1		= 0,
	@v8spositiontaking_3		= 0,
	@v8spositiontaking_20		= 0,
								
	@v10spositiontaking_1		= 0,
	@v10spositiontaking_2		= 0,
	@v10spositiontaking_3		= 0,
	@v10spositiontaking_20		= 0,
								
	@v11spositiontaking_1		= 0,
	@v11spositiontaking_20		= 0,
	
	@v44spositiontaking_3		= 0,
	
	@v99spositiontaking_1		= 0,
	@v99spositiontaking_2		= 0,
	@v99spositiontaking_3		= 0,
	@v99spositiontaking_20		= 0,
	@v154spositiontaking_20		= 0,
								
	@v99spositiontaking_9		= 0,
								
	@v161spositiontaking_81		= 0, 				
	@v161spositiontaking_83		= 0,
	@v161spositiontaking_86		= 0,
	@v161spositiontaking_88		= 0,
								
	@v161slivepositiontaking_85 = 0,
	@v161slivepositiontaking_86 = 0,
	@v161slivepositiontaking_87	= 0,
	@v161slivepositiontaking_89	= 0,
	@v161slivepositiontaking_90	= 0,
								
	--Racing					
	@v151spositiontaking_31		= 0,
	@v151spositiontaking_32		= 0,
	@v151spositiontaking_41		= 0,
	@v151spositiontaking_42		= 0,
								
	@v151spositiontaking_51		= 0,
	@v151spositiontaking_52		= 0,
								
	@v152spositiontaking_41		= 0,
	@v152spositiontaking_42		= 0,
	@v152spositiontaking_51		= 0,
	@v152spositiontaking_52		= 0,
								
	@v153spositiontaking_51		= 0,
	@v153spositiontaking_52		= 0


declare @startRun datetime
declare @endRun datetime
declare @duration int
set @startRun = getdate()

DECLARE 
	@UserName varchar(30), @srecommend int,
	@ErrAcc varchar(4000), @ErrType varchar(4000),

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

	@v151MinMinBet_31 money, @v151MaxMaxBet_31 money, @v151MaxMaxPerMatch_31 money,
	@v151MinMinBet_41 money, @v151MaxMaxBet_41 money, @v151MaxMaxPerMatch_41 money,
	@v151MinMinBet_51 money, @v151MaxMaxBet_51 money, @v151MaxMaxPerMatch_51 money,
	@v152MinMinBet_41 money, @v152MaxMaxBet_41 money, @v152MaxMaxPerMatch_41 money,
	@v152MinMinBet_51 money, @v152MaxMaxBet_51 money, @v152MaxMaxPerMatch_51 money,
	@v153MinMinBet_51 money, @v153MaxMaxBet_51 money, @v153MaxMaxPerMatch_51 money,
	
	@MinMinBetv161 money, @MaxMaxBetv161 money, @MaxMaxPerMatchv161 money,
	@MaxMaxPerBallv161 money

------------------------Validare minbet, maxbet, maxpermatch---------------------------------
---------------------------------------------------------------------------------------------------------
if @minbetv1<0 or @maxbetv1 < 0 or @maxpermatchv1 <0
BEGIN	 
Select @ErrMsg = 	case @Language 
					when 'E' then 'Wrong Min bet/ Max bet/ Max per match.'
					ELSE [dbo].[f_Get_MsgNamebyMsgID](10003,@Language)
			end, @ErrCode = 101
	return
END

if 
	@minbetv2 <0
	or @maxbetv2 <0
	or @maxpermatchv2 <0
BEGIN	
	Select @ErrMsg = 	case @Language 
						when 'E' then 'Wrong Min bet/ Max bet/ Max per match (for Basketball).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10003,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](2,@Language) + ')'
				end, @ErrCode = 102
	return
END

if 
	@minbetv3 <0
	or @maxbetv3 <0
	or @maxpermatchv3 <0
BEGIN
	Select @ErrMsg = 	case @Language 
						when 'E' then 'Wrong Min bet/ Max bet/ Max per match (for Football).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10003,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](3,@Language) + ')'
				end, @ErrCode = 103
	return
END

if 
	@minbetv5 <0
	or @maxbetv5 <0
	or @maxpermatchv5 <0
BEGIN
	Select @ErrMsg = 	case @Language 
						when 'E' then 'Wrong Min bet/ Max bet/ Max per match (for Tennis).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10003,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](5,@Language) + ')'
				end, @ErrCode = 104
	return
END

if 
	@minbetv8 <0
	or @maxbetv8 <0
	or @maxpermatchv8 <0
BEGIN
	Select @ErrMsg = 	case @Language 
						when 'E' then 'Wrong Min bet/ Max bet/ Max per match (for Baseball).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10003,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](8,@Language) + ')'
				end, @ErrCode = 105
	return
END

if 
	@minbetv10 <0
	or @maxbetv10 <0
	or @maxpermatchv10 <0
BEGIN
	Select @ErrMsg = 	case @Language 
						when 'E' then 'Wrong Min bet/ Max bet/ Max per match (for Golf).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10003,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](10,@Language) + ')'
				end, @ErrCode = 106
	return
END

if 
	@minbetv11 <0
	or @maxbetv11 <0
	or @maxpermatchv11 <0
BEGIN
	Select @ErrMsg = 	case @Language 
						when 'E' then 'Wrong Min bet/ Max bet/ Max per match (for Motosports).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10003,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](11,@Language) + ')'
				end, @ErrCode = 107
	return
END

if 
	@minbetv44 <0
	or @maxbetv44 <0
	or @maxpermatchv44 <0
BEGIN
	Select @ErrMsg = 	case @Language 
						when 'E' then 'Wrong Min bet/ Max bet/ Max per match (for MuayThai).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10003,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](44,@Language) + ')'
				end, @ErrCode = 107
	return
END

if 
	@minbetv99 <0
	or @maxbetv99 <0
	or @maxpermatchv99 <0
BEGIN
	Select @ErrMsg = 	case @Language 
						when 'E' then 'Wrong Min bet/ Max bet/ Max per match (for Other Sports).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10003,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](99,@Language) + ')'
				end, @ErrCode = 109
	return
END

if 
	@minbetv154 <0
	or @maxbetv154 <0
	or @maxpermatchv154 <0
BEGIN
	Select @ErrMsg = 	case @Language 
						when 'E' then 'Wrong Min bet/ Max bet/ Max per match (for HR Fixed Odds).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10003,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](154,@Language) + ')'
				end, @ErrCode = 109
	return
END

if 
	@minbetv99mp < 0
	or @maxbetv99mp < 0
	or @maxpermatchv99mp < 0
BEGIN
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
				end, @ErrCode = 201
	return
END

--Number Game
if 
	@minbetv161 < 0
	or @maxbetv161 < 0
	or @maxpermatchv161 < 0
BEGIN
	Select @ErrMsg = 	case @Language 
						when 'E' then 'Wrong Min bet/ Max bet/ Max per match (for Number game).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10003,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](161,@Language) + ')'
				end, @ErrCode = 202
	return
END

--Horse Racing
if 
		@v151minbet_31<0
		or @v151maxbet_31 < 0
		or @v151maxpermatch_31 <0
		or @v151minbet_41<0
		or @v151maxbet_41 < 0
		or @v151maxpermatch_41 <0
		or @v151minbet_51<0
		or @v151maxbet_51 < 0
		or @v151maxpermatch_51 <0

		or @v152minbet_41<0
		or @v152maxbet_41 < 0
		or @v152maxpermatch_41 <0
		or @v152minbet_51<0
		or @v152maxbet_51 < 0
		or @v152maxpermatch_51 <0

		or @v153minbet_51<0
		or @v153maxbet_51 < 0
		or @v153maxpermatch_51 <0
	BEGIN	 
		Select @ErrMsg = 	case @Language 
							when 'E' then 'Wrong Min bet/ Max bet/ Max per match.'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10003,@Language)
					end, @ErrCode = 101
		return
	END

--- max per ball
if @MaxPerBallv161 < 0
begin
	Select @ErrMsg = 	case @Language 
				when 'E' then 'Wrong Max Per Ball (Number Game).'
				ELSE [dbo].[f_Get_MsgNamebyMsgID](10002,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](161,@Language) + ')'
		end, @ErrCode = 202
	return
end



Select @UserName  = username, @srecommend = srecommend from custinfo with (NOLOCK) where CustID = @CustID
if 
(@minbetv1<>0 and @maxbetv1 <> 0 and  @minbetv1>@maxbetv1) 
or (@maxbetv1<> 0 and @maxpermatchv1 <> 0 and @maxbetv1>@maxpermatchv1) 
or (@minbetv1 <> 0 and @maxpermatchv1 <> 0 and @minbetv1>@maxpermatchv1)
BEGIN
	SELECT @ErrMsg =  @UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be less than max bet and max bet must be less than max bet per match'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language)
					end	, @ErrCode = 110
	return
END


if (@minbetv2 <> 0 and @maxbetv2 <> 0 and @minbetv2>@maxbetv2) 
or (@maxbetv2 <> 0 and @maxpermatchv2 <> 0 and @maxbetv2>@maxpermatchv2)
or (@minbetv2 <> 0 and @maxpermatchv2 <> 0 and @minbetv2>@maxpermatchv2) 
BEGIN
	SELECT @ErrMsg =  @UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be less than max bet and max bet must be less than max bet per match (for Basketball)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](2,@Language) + ')'
					end, @ErrCode = 111
	return
END


if (@minbetv3 <> 0 and @maxbetv3 <> 0 and @minbetv3>@maxbetv3) 
or (@maxbetv3 <> 0 and @maxpermatchv3 <> 0 and @maxbetv3>@maxpermatchv3)
or (@minbetv3 <> 0 and @maxpermatchv3 <> 0 and @minbetv3>@maxpermatchv3) 
BEGIN
	SELECT @ErrMsg =  @UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be less than max bet and max bet must be less than max bet per match (for Football)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](3,@Language) + ')'
					end, @ErrCode = 112
	return
END



if (@minbetv5 <> 0 and @maxbetv5 <> 0 and @minbetv5>@maxbetv5) 
or (@maxbetv5 <> 0 and @maxpermatchv5 <> 0 and @maxbetv5>@maxpermatchv5)
or (@minbetv5 <> 0 and @maxpermatchv5 <> 0 and @minbetv5>@maxpermatchv5) 
BEGIN
	SELECT @ErrMsg =  @UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be less than max bet and max bet must be less than max bet per match (for Tennis)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](5,@Language) + ')'
					end, @ErrCode = 113
	return
END



if (@minbetv8 <> 0 and @maxbetv8 <> 0 and @minbetv8>@maxbetv8) 
or (@maxbetv8 <> 0 and @maxpermatchv8 <> 0 and @maxbetv8>@maxpermatchv8)
or (@minbetv8 <> 0 and @maxpermatchv8 <> 0 and @minbetv8>@maxpermatchv8) 
BEGIN
	SELECT @ErrMsg =  @UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be less than max bet and max bet must be less than max bet per match (for Baseball)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](8,@Language) + ')'
					end, @ErrCode = 114	
	return
END



if (@minbetv10 <> 0 and @maxbetv10 <> 0 and @minbetv10>@maxbetv10) 
or (@maxbetv10 <> 0 and @maxpermatchv10 <> 0 and @maxbetv10>@maxpermatchv10)
or (@minbetv10 <> 0 and @maxpermatchv10 <> 0 and @minbetv10>@maxpermatchv10) 
BEGIN
	SELECT @ErrMsg =  @UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be less than max bet and max bet must be less than max bet per match (for Golf)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](10,@Language) + ')'
					end, @ErrCode = 115
	return
END



if (@minbetv11 <> 0 and @maxbetv11 <> 0 and @minbetv11>@maxbetv11) 
or (@maxbetv11 <> 0 and @maxpermatchv11 <> 0 and @maxbetv11>@maxpermatchv11)
or (@minbetv11 <> 0 and @maxpermatchv11 <> 0 and @minbetv11>@maxpermatchv11) 
BEGIN
	SELECT @ErrMsg =  @UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be less than max bet and max bet must be less than max bet per match (for Motorsports)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](11,@Language) + ')'
					end, @ErrCode = 116
	return
END

if (@minbetv44 <> 0 and @maxbetv44 <> 0 and @minbetv44>@maxbetv44) 
or (@maxbetv44 <> 0 and @maxpermatchv44 <> 0 and @maxbetv44>@maxpermatchv44)
or (@minbetv44 <> 0 and @maxpermatchv44 <> 0 and @minbetv44>@maxpermatchv44) 
BEGIN
	SELECT @ErrMsg =  @UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be less than max bet and max bet must be less than max bet per match (for MuayThai)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](44,@Language) + ')'
					end, @ErrCode = 116
	return
END

if (@minbetv99 <> 0 and @maxbetv99 <> 0 and @minbetv99>@maxbetv99) 
or (@maxbetv99 <> 0 and @maxpermatchv99 <> 0 and @maxbetv99>@maxpermatchv99)
or (@minbetv99 <> 0 and @maxpermatchv99 <> 0 and @minbetv99>@maxpermatchv99) 
BEGIN
	SELECT @ErrMsg =  @UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be less than max bet and max bet must be less than max bet per match (for Other sports)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](99,@Language) + ')'
					end, @ErrCode = 118
	return
END

if (@minbetv154 <> 0 and @maxbetv154 <> 0 and @minbetv154>@maxbetv154) 
or (@maxbetv154 <> 0 and @maxpermatchv154 <> 0 and @maxbetv154>@maxpermatchv154)
or (@minbetv154 <> 0 and @maxpermatchv154 <> 0 and @minbetv154>@maxpermatchv154) 
BEGIN
	SELECT @ErrMsg =  @UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be less than max bet and max bet must be less than max bet per match (for HR Fixed Odds)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](154,@Language) + ')'
					end, @ErrCode = 119
	return
END

-- mix parlay of mixed sports

if (@minbetv99mp <> 0 and @maxbetv99mp <> 0 and @minbetv99mp > @maxbetv99mp) 
or (@maxbetv99mp <> 0 and @maxpermatchv99mp <> 0 and @maxbetv99mp > @maxpermatchv99mp)
or (@minbetv99mp <> 0 and @maxpermatchv99mp <> 0 and @minbetv99mp > @maxpermatchv99mp) 
BEGIN
	SELECT @ErrMsg =  @UserName + ': '+
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
					end, @ErrCode = 203
	return
END

--Horse Racing
IF 
   (@v151minbet_31<>0 and @v151maxbet_31 <> 0 and  @v151minbet_31>@v151maxbet_31) 
OR (@v151maxbet_31<> 0 and @v151maxpermatch_31 <> 0 and @v151maxbet_31>@v151maxpermatch_31) 
OR (@v151minbet_31 <> 0 and @v151maxpermatch_31 <> 0 and @v151minbet_31>@v151maxpermatch_31)
OR (@v152minbet_41<>0 and @v152maxbet_41 <> 0 and  @v152minbet_41>@v152maxbet_41) 
OR (@v152maxbet_51<> 0 and @v152maxpermatch_51 <> 0 and @v152maxbet_51>@v152maxpermatch_51) 
OR (@v153minbet_51 <> 0 and @v153maxpermatch_51 <> 0 and @v153minbet_51>@v153maxpermatch_51)
BEGIN
	SELECT @ErrMsg =  @UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be less than max bet and max bet must be less than max bet per match!!!'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language)
					end	, @ErrCode = 110
	return
END

-- number game
IF (@minbetv161 <> 0 and @maxbetv161 <> 0 and @minbetv161 > @maxbetv161) 
or (@maxbetv161 <> 0 and @maxpermatchv161 <> 0 and @maxbetv161 > @maxpermatchv161)
or (@minbetv161 <> 0 and @maxpermatchv161 <> 0 and @minbetv161 > @maxpermatchv161)
BEGIN
	SELECT @ErrMsg =  @UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be less than max bet and max bet must be less than max bet per match (for Number Game)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](161,@Language) + ')'
					end, @ErrCode = 204
	return
END

-------------------END------------------------------

/************************Get Upline minbet, maxbet, maxpermatch**************************/
Select @MaxMaxPerMatchv1 = MaxPerMatch,
		@MaxMaxPerMatchv2 = MaxPerMatch2,
		@MaxMaxPerMatchv3 = MaxPerMatch3,
		@MaxMaxPerMatchv5 = MaxPerMatch5,
		@MaxMaxPerMatchv8 = MaxPerMatch8,
		@MaxMaxPerMatchv10 = MaxPerMatch10,
		@MaxMaxPerMatchv11 = MaxPerMatch11,
		@MaxMaxPerMatchv44 = MaxPerMatch44,
		@MaxMaxPerMatchv99 = MaxPerMatch99,
		@MaxMaxPerMatchv154 = MaxPerMatch154,
		@MaxMaxPerMatchv99MP = MaxPerMatch99MP,
		@MaxMaxPerMatchv161 = MaxPerMatch161,
		@MaxMaxPerBallv161 = MaxPerBall161,
		@v151MaxMaxPerMatch_31 = maxpermatch151,
		@v151MaxMaxPerMatch_41 = maxpermatch151_OT,
		@v151MaxMaxPerMatch_51 = MaxPerMatch151_AU,
		@v152MaxMaxPerMatch_41 = MaxPerMatch152_UK,
		@v152MaxMaxPerMatch_51 = MaxPerMatch152_AU,
		@v153MaxMaxPerMatch_51 = MaxPerMatch153_AU

from custinfo with (NOLOCK) where custid = @srecommend

Select 
	@MinMinBetv1 = MinBet,
	@MaxMaxBetv1 = MaxBet
From dep_custsetting with (NOLOCK)
where CustID = @srecommend and bettype=1 and sporttype=1

Select 
	@MinMinBetv2 = MinBet,
	@MaxMaxBetv2 = MaxBet
From dep_custsetting with (NOLOCK)
where CustID = @srecommend and bettype=1 and sporttype=2

Select 
	@MinMinBetv3 = MinBet,
	@MaxMaxBetv3 = MaxBet
From dep_custsetting with (NOLOCK)
where CustID = @srecommend and bettype=1 and sporttype=3

Select 
	@MinMinBetv5 = MinBet,
	@MaxMaxBetv5 = MaxBet
From dep_custsetting with (NOLOCK)
where CustID = @srecommend and bettype=1 and sporttype=5

Select 
	@MinMinBetv8 = MinBet,
	@MaxMaxBetv8 = MaxBet
From dep_custsetting with (NOLOCK)
where CustID = @srecommend and bettype=1 and sporttype=8

Select 
	@MinMinBetv10 = MinBet,
	@MaxMaxBetv10 = MaxBet
From dep_custsetting with (NOLOCK)
where CustID = @srecommend and bettype=1 and sporttype=10

Select 
	@MinMinBetv11 = MinBet,
	@MaxMaxBetv11 = MaxBet
From dep_custsetting with (NOLOCK)
where CustID = @srecommend and bettype=1 and sporttype=11

Select 
	@MinMinBetv44 = MinBet,
	@MaxMaxBetv44 = MaxBet
From dep_custsetting with (NOLOCK)
where CustID = @srecommend and bettype=3 and sporttype=44

Select 
	@MinMinBetv99 = MinBet,
	@MaxMaxBetv99 = MaxBet
From dep_custsetting with (NOLOCK)
where CustID = @srecommend and bettype=1 and sporttype=99

Select 
	@MinMinBetv154 = MinBet,
	@MaxMaxBetv154 = MaxBet
From dep_custsetting with (NOLOCK)
where CustID = @srecommend and bettype=20 and sporttype=154

select 
	@MinMinBetv99MP = MinBet,
	@MaxMaxBetv99MP = MaxBet
from dep_custsetting with(nolock)
where custid = @srecommend and bettype = 9 and sporttype = 99

--Horse Racing
select 
	@v151MinMinBet_31 = MinBet,
	@v151MaxMaxBet_31 = MaxBet
from dep_custsetting3rd with(nolock)
where custid = @srecommend and bettype = 31 and sporttype = 151
select 
	@v151MinMinBet_41 = MinBet,
	@v151MaxMaxBet_41 = MaxBet
from dep_custsetting3rd with(nolock)
where custid = @srecommend and bettype = 41 and sporttype = 151
select 
	@v151MinMinBet_51 = MinBet,
	@v151MaxMaxBet_51 = MaxBet
from dep_custsetting3rd with(nolock)
where custid = @srecommend and bettype = 51 and sporttype = 151
select 
	@v152MinMinBet_41 = MinBet,
	@v152MaxMaxBet_41 = MaxBet
from dep_custsetting3rd with(nolock)
where custid = @srecommend and bettype = 41 and sporttype = 152
select 
	@v152MinMinBet_51 = MinBet,
	@v152MaxMaxBet_51 = MaxBet
from dep_custsetting3rd with(nolock)
where custid = @srecommend and bettype = 51 and sporttype = 152
select 
	@v153MinMinBet_51 = MinBet,
	@v153MaxMaxBet_51 = MaxBet
from dep_custsetting3rd with(nolock)
where custid = @srecommend and bettype = 51 and sporttype = 153

--Number game
select 
	@MinMinBetv161 = MinBet,
	@MaxMaxBetv161 = MaxBet
from dep_custsetting3rd with(nolock)
where custid = @srecommend and bettype = 81 and sporttype = 161
/***********************************END******************************************/

/*******************************************
	validate Minbet, maxbet, maxpermatch
********************************************/

IF (@MinMinBetv1>0 and @MinBetv1>0 and @minbetv1<@MinMinBetv1)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be equal to or greater than Super Agent min bet (for Soccer)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10016,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](1,@Language) + ')'
					end						
					+' (' + convert(varchar(20), @MinMinBetv1) + ').', @ErrCode = 119	
	return
END

IF (@MaxMaxBetv1>0 and @MaxBetv1>0 and @maxbetv1>@MaxMaxBetv1)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max bet must be equal to or less than Super Agent max bet (for Soccer)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10017,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](1,@Language) + ')'
					end						
					+' (' + convert(varchar(20), @MaxMaxBetv1) + ').', @ErrCode = 120	
	return
END
	
IF (@MaxMaxPerMatchv1>0 and @MaxPerMatchv1>0 and @MaxPerMatchv1>@MaxMaxPerMatchv1)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max Per Match must be equal to or less than Super Agent Max Per Match (for Soccer)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10018,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](1,@Language) + ')'
					end						
					+' (' + convert(varchar(20), @MaxMaxPerMatchv1) + ').', @ErrCode = 121	
	RETURN
END

IF (@MaxMaxBetv2>0 and @maxbetv2>0 and @maxbetv2>@MaxMaxBetv2)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max bet must be equal to or less than Super Agent max bet (for Basketball)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10017,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](2,@Language) + ')'
					end						
					+' (' + convert(varchar(20), @MaxMaxBetv2) + ').', @ErrCode = 122	
	RETURN
END
	
IF (@MaxMaxPerMatchv2>0 and @MaxPerMatchv2>0 and @MaxPerMatchv2>@MaxMaxPerMatchv2)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max Per Match must be equal to or less than Super Agent Max Per Match (for Basketball)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10018,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](2,@Language) + ')'
					end						
					+' (' + convert(varchar(20), @MaxMaxPerMatchv2) + ').', @ErrCode = 123	
	return
END
	
IF (@MinMinBetv2>0 and @minbetv2>0 and @minbetv2<@MinMinBetv2)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be equal to or greater than Super Agent min bet (for Basketball)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10016,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](2,@Language) + ')'
					end						
					+' (' + convert(varchar(20), @MinMinBetv2) + ').', @ErrCode = 124	
	RETURN
END

IF (@MaxMaxBetv3>0 and @maxbetv3>0 and @maxbetv3>@MaxMaxBetv3)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max bet must be equal to or less than Super Agent max bet (for Football)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10017,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](3,@Language) + ')'
					end						
					+' (' + convert(varchar(20), @MaxMaxBetv3) + ').', @ErrCode = 125	
	return
END
	
IF (@MaxMaxPerMatchv3>0 and @MaxPerMatchv3>0 and @MaxPerMatchv3>@MaxMaxPerMatchv3)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max Per Match must be equal to or less than Super Agent Max Per Match (for Football)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10018,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](3,@Language) + ')'
					end						
					+' (' + convert(varchar(20), @MaxMaxPerMatchv3) + ').', @ErrCode = 126	
	return
END
	
IF (@MinMinBetv3>0 and @minbetv3>0 and @minbetv3<@MinMinBetv3)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be equal to or greater than Super Agent min bet (for Football)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10016,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](3,@Language) + ')'
					end						
					+' (' + convert(varchar(20), @MinMinBetv3) + ').', @ErrCode = 127	
	return
END

IF (@MaxMaxBetv5>0 and @maxbetv5>0 and @maxbetv5>@MaxMaxBetv5)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max bet must be equal to or less than Super Agent max bet (for Tennis)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10017,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](5,@Language) + ')'
					end						
					+' (' + convert(varchar(20), @MaxMaxBetv5) + ').', @ErrCode = 128	
	return
END
	
IF (@MaxMaxPerMatchv5>0 and @MaxPerMatchv5>0 and @MaxPerMatchv5>@MaxMaxPerMatchv5)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max Per Match must be equal to or less than Super Agent Max Per Match (for Tennis)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10018,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](5,@Language) + ')'
					end						
					+' (' + convert(varchar(20), @MaxMaxPerMatchv5) + ').', @ErrCode = 129	
	return
END
	
IF (@MinMinBetv5>0 and @minbetv5>0 and @minbetv5<@MinMinBetv5)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be equal to or greater than Super Agent min bet (for Tennis)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10016,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](5,@Language) + ')'
					end						
					+' (' + convert(varchar(20), @MinMinBetv5) + ').', @ErrCode = 130	
	return
END

IF (@MaxMaxBetv8>0 and @maxbetv8>0 and @maxbetv8>@MaxMaxBetv8)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max bet must be equal to or less than Super Agent max bet (for Baseball)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10017,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](8,@Language) + ')'
					end						
					+' (' + convert(varchar(20), @MaxMaxBetv8) + ').', @ErrCode = 131	
	return
END
	
IF (@MaxMaxPerMatchv8>0 and @MaxPerMatchv8>0 and @MaxPerMatchv8>@MaxMaxPerMatchv8)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max Per Match must be equal to or less than Super Agent Max Per Match (for Baseball)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10018,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](8,@Language) + ')'
					end						
					+' (' + convert(varchar(20), @MaxMaxPerMatchv8) + ').', @ErrCode = 132	
	return
END
	
IF (@MinMinBetv8>0 and @minbetv8>0 and @minbetv8<@MinMinBetv8)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be equal to or greater than Super Agent min bet (for Baseball)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10016,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](8,@Language) + ')'
					end						
					+' (' + convert(varchar(20), @MinMinBetv8) + ').', @ErrCode = 133	
	return
END

IF (@MaxMaxBetv10>0 and @maxbetv10>0 and @maxbetv10>@MaxMaxBetv10)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max bet must be equal to or less than Super Agent max bet (for Golf)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10017,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](10,@Language) + ')'
					end						
					+' (' + convert(varchar(20), @MaxMaxBetv10) + ').', @ErrCode = 134	
	RETURN
END
	
IF (@MaxMaxPerMatchv10>0 and @MaxPerMatchv10>0 and @MaxPerMatchv10>@MaxMaxPerMatchv10)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max Per Match must be equal to or less than Super Agent Max Per Match (for Golf)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10018,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](10,@Language) + ')'
					end						
					+' (' + convert(varchar(20), @MaxMaxPerMatchv10) + ').', @ErrCode = 135	
	RETURN
END
	
IF (@MinMinBetv10>0 and @minbetv10>0 and @minbetv10<@MinMinBetv10)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be equal to or greater than Super Agent min bet (for Golf)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10016,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](10,@Language) + ')'
					end						
					+' (' + convert(varchar(20), @MinMinBetv10) + ').', @ErrCode = 136	
	RETURN
END

IF (@MaxMaxBetv11>0 and @maxbetv11>0 and @maxbetv11>@MaxMaxBetv11)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max bet must be equal to or less than Super Agent max bet (for Motorsports)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10017,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](11,@Language) + ')'
					end						
					+' (' + convert(varchar(20), @MaxMaxBetv11) + ').', @ErrCode = 137	
	return
END
	
IF (@MaxMaxPerMatchv11>0 and @MaxPerMatchv11>0 and @MaxPerMatchv11>@MaxMaxPerMatchv11)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max Per Match must be equal to or less than Super Agent Max Per Match (for Motorsports)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10018,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](11,@Language) + ')'
					end						
					+' (' + convert(varchar(20), @MaxMaxPerMatchv11) + ').', @ErrCode = 138	
	return
END
	
IF (@MinMinBetv11>0 and @minbetv11>0 and @minbetv11<@MinMinBetv11)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be equal to or greater than Super Agent min bet (for Motorsports)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10016,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](11,@Language) + ')'
					end						
					+' (' + convert(varchar(20), @MinMinBetv11) + ').', @ErrCode = 139	
	return
END
--v44
IF (@MaxMaxBetv44>0 and @maxbetv44>0 and @maxbetv44>@MaxMaxBetv44)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max bet must be equal to or less than Super Agent max bet (for MuayThai)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10017,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](44,@Language) + ')'
					end						
					+' (' + convert(varchar(20), @MaxMaxBetv44) + ').', @ErrCode = 137	
	return
END
	
IF (@MaxMaxPerMatchv44>0 and @MaxPerMatchv44>0 and @MaxPerMatchv44>@MaxMaxPerMatchv44)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max Per Match must be equal to or less than Super Agent Max Per Match (for MuayThai)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10018,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](44,@Language) + ')'
					end						
					+' (' + convert(varchar(20), @MaxMaxPerMatchv44) + ').', @ErrCode = 138	
	return
END
	
IF (@MinMinBetv44>0 and @minbetv44>0 and @minbetv44<@MinMinBetv44)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be equal to or greater than Super Agent min bet (for MuayThai)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10016,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](44,@Language) + ')'
					end						
					+' (' + convert(varchar(20), @MinMinBetv44) + ').', @ErrCode = 139	
	return
END
---end v44
IF (@MaxMaxBetv99>0 and @maxbetv99>0 and @maxbetv99>@MaxMaxBetv99)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max bet must be equal to or less than Super Agent max bet (for Other sports)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10017,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](99,@Language) + ')'
					end						
					+' (' + convert(varchar(20), @MaxMaxBetv99) + ').', @ErrCode = 143	
	return
END
	
IF (@MaxMaxPerMatchv99>0 and @MaxPerMatchv99>0 and @MaxPerMatchv99>@MaxMaxPerMatchv99)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max Per Match must be equal to or less than Super Agent Max Per Match (for Other sports)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10018,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](99,@Language) + ')'
					end						
					+' (' + convert(varchar(20), @MaxMaxPerMatchv99) + ').', @ErrCode = 144	
	return
END
	
IF (@MinMinBetv99>0 and @minbetv99>0 and @minbetv99<@MinMinBetv99)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be equal to or greater than Super Agent min bet (for Other sports)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10016,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](99,@Language) + ')'
					end						
					+' (' + convert(varchar(20), @MinMinBetv99) + ').', @ErrCode = 145	
	return
END

IF (@MaxMaxBetv154>0 and @maxbetv154>0 and @maxbetv154>@MaxMaxBetv154)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max bet must be equal to or less than Super Agent max bet (for HR Fixed Odds)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10017,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](154,@Language) + ')'
					end						
					+' (' + convert(varchar(20), @MaxMaxBetv99) + ').', @ErrCode = 146	
	return
END
	
IF (@MaxMaxPerMatchv154>0 and @MaxPerMatchv154>0 and @MaxPerMatchv154>@MaxMaxPerMatchv154)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max Per Match must be equal to or less than Super Agent Max Per Match (for HR Fixed Odds)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10018,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](154,@Language) + ')'
					end						
					+' (' + convert(varchar(20), @MaxMaxPerMatchv99) + ').', @ErrCode = 147	
	return
END

IF (@MinMinBetv154>0 and @minbetv154>0 and @minbetv154<@MinMinBetv154)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be equal to or greater than Super Agent min bet (for HR Fixed Odds)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10016,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](154,@Language) + ')'
					end						
					+' (' + convert(varchar(20), @MinMinBetv99) + ').', @ErrCode = 148	
	return
END

IF (@MaxMaxBetv99MP > 0 and @maxbetv99mp > 0 and @maxbetv99mp > @MaxMaxBetv99MP)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max bet must be equal to or less than Super Agent max bet (for Mix Sports Parlay)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10017,@Language) + case @Language 
																							when 'CS' then N'(供混合体育过关)'
																							when 'CT' then N'(供混合體育過關)'
																							when 'TH' then N'(สำหรับกีฬาบอลชุด)'
																							when 'J' then N'(Mix Sports Parlay)'
																							when 'KO' then N'(Mix Sports Parlay)'
																							when 'VI' then N'(Mix Sports Parlay)'
																							else N'(Mix Sports Parlay)' END
					end						
					+' (' + convert(varchar(20), @MaxMaxBetv99MP) + ').', @ErrCode = 205	
	return
END
	
IF (@MaxMaxPerMatchv99MP > 0 and @MaxPerMatchv99MP > 0 and @MaxPerMatchv99MP > @MaxMaxPerMatchv99MP)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max Per Match must be equal to or less than Super Agent Max Per Match (for Mix Sports Parlay)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10018,@Language) + case @Language 
																							when 'CS' then N'(供混合体育过关)'
																							when 'CT' then N'(供混合體育過關)'
																							when 'TH' then N'(สำหรับกีฬาบอลชุด)'
																							when 'J' then N'(Mix Sports Parlay)'
																							when 'KO' then N'(Mix Sports Parlay)'
																							when 'VI' then N'(Mix Sports Parlay)'
																							else N'(Mix Sports Parlay)' END
					end						
					+' (' + convert(varchar(20), @MaxMaxPerMatchv99MP) + ').', @ErrCode = 206	
	return
END
	
IF (@MinMinBetv99MP > 0 and @minbetv99mp > 0 and @minbetv99mp < @MinMinBetv99MP)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be equal to or greater than Super Agent min bet (for Mix Sports Parlay)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10016,@Language) + case @Language 
																							when 'CS' then N'(供混合体育过关)'
																							when 'CT' then N'(供混合體育過關)'
																							when 'TH' then N'(สำหรับกีฬาบอลชุด)'
																							when 'J' then N'(Mix Sports Parlay)'
																							when 'KO' then N'(Mix Sports Parlay)'
																							when 'VI' then N'(Mix Sports Parlay)'
																							else N'(Mix Sports Parlay)' END
					end						
					+' (' + convert(varchar(20), @MinMinBetv99MP) + ').', @ErrCode = 207	
	return
END

IF (@MaxMaxBetv161 > 0 and @maxbetv161 > 0 and @maxbetv161 > @MaxMaxBetv161)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max bet must be equal to or less than Super Agent max bet (for Number Game)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10017,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](161,@Language) + ')'
					end						
					+' (' + convert(varchar(20), @MaxMaxBetv161) + ').', @ErrCode = 208	
	return
END
	
IF (@MaxMaxPerMatchv161 > 0 and @MaxPerMatchv161 > 0 and @MaxPerMatchv161 > @MaxMaxPerMatchv161)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max Per Match must be equal to or less than Super Agent Max Per Match (for Number Game)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10018,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](161,@Language) + ')'
					end
					+' (' + convert(varchar(20), @MaxMaxPerMatchv161) + ').', @ErrCode = 209	
	return
END
	
IF (@MinMinBetv161 > 0 and @minbetv161 > 0 and @minbetv161 < @MinMinBetv161)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be equal to or greater than Super Agent min bet (for Number Game)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10016,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](161,@Language) + ')'
					end						
					+' (' + convert(varchar(20), @MinMinBetv161) + ').', @ErrCode = 210	
	return
END

if @MaxPerBallv161 > @MaxMaxPerBallv161 and @MaxMaxPerBallv161 > 0
begin
	SELECT @ErrMsg =	@UserName + ': '+
		CASE @Language 
			WHEN 'E' THEN 'Max Per Ball must be equal to or less than Super Agent Max Per Ball (Number Game).'
			ELSE [dbo].[f_Get_MsgNamebyMsgID](10010,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](161,@Language) + ')'
		END						
		+' (' + CONVERT(VARCHAR(20), @MaxMaxPerBallv161) + ').', @ErrCode = 201				
	return
end

-- Horse Racing
if 
(@v151minbet_31<>0 and @v151maxbet_31 <> 0 and  @v151minbet_31 > @v151maxbet_31) 
or (@v151maxbet_31<> 0 and @v151maxpermatch_31 <> 0 and @v151maxbet_31 > @v151maxpermatch_31) 
or (@v151minbet_31 <> 0 and @v151maxpermatch_31 <> 0 and @v151minbet_31 > @v151maxpermatch_31)
BEGIN
	SELECT @ErrMsg =  @UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be less than max bet and max bet must be less than max bet per match!!!'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language)
					end	, @ErrCode = 110
	return
END

if (@v151MinMinBet_31>0 and @v151MinBet_31>0 and @v151MinBet_31<@v151MinMinBet_31)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be equal to or greater than Super Agent min bet'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10016,@Language)
					end						
					+' (' + convert(varchar(20), @v151MinMinBet_31) + ').', @ErrCode = 119	
	return
END

if (@v151MaxMaxBet_31>0 and @v151MaxBet_31>0 and @v151maxbet_31>@v151MaxMaxBet_31)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max bet must be equal to or less than Super Agent max bet'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10017,@Language)
					end						
					+' (' + convert(varchar(20), @v151MaxMaxBet_31) + ').', @ErrCode = 120	
	return
END

if (@v151MaxMaxPerMatch_31>0 and @v151MaxPerMatch_31>0 and @v151MaxPerMatch_31>@v151MaxMaxPerMatch_31)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max Per Match must be equal to or less than Super Agent Max Per Match'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10018,@Language)
					end						
					+' (' + convert(varchar(20), @v151MaxMaxPerMatch_31) + ').', @ErrCode = 121	
	return
END

if 
(@v151minbet_41<>0 and @v151maxbet_41 <> 0 and  @v151minbet_41 > @v151maxbet_41) 
or (@v151maxbet_41<> 0 and @v151maxpermatch_41 <> 0 and @v151maxbet_41 > @v151maxpermatch_41) 
or (@v151minbet_41 <> 0 and @v151maxpermatch_41 <> 0 and @v151minbet_41 > @v151maxpermatch_41)
BEGIN
	SELECT @ErrMsg =  @UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be less than max bet and max bet must be less than max bet per match!!!'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language)
					end	, @ErrCode = 110
	return
END

if (@v151MinMinBet_41>0 and @v151MinBet_41>0 and @v151MinBet_41<@v151MinMinBet_41)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be equal to or greater than Super Agent min bet'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10016,@Language)
					end						
					+' (' + convert(varchar(20), @v151MinMinBet_41) + ').', @ErrCode = 119	
	return
END

if (@v151MaxMaxBet_41>0 and @v151MaxBet_41>0 and @v151maxbet_41>@v151MaxMaxBet_41)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max bet must be equal to or less than Super Agent max bet'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10017,@Language)
					end						
					+' (' + convert(varchar(20), @v151MaxMaxBet_41) + ').', @ErrCode = 120	
	return
END

if (@v151MaxMaxPerMatch_41>0 and @v151MaxPerMatch_41>0 and @v151MaxPerMatch_41>@v151MaxMaxPerMatch_41)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max Per Match must be equal to or less than Super Agent Max Per Match'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10018,@Language)
					end						
					+' (' + convert(varchar(20), @v151MaxMaxPerMatch_41) + ').', @ErrCode = 121	
	return
END

if 
(@v151minbet_51<>0 and @v151maxbet_51 <> 0 and  @v151minbet_51 > @v151maxbet_51) 
or (@v151maxbet_51<> 0 and @v151maxpermatch_51 <> 0 and @v151maxbet_51 > @v151maxpermatch_51) 
or (@v151minbet_51 <> 0 and @v151maxpermatch_51 <> 0 and @v151minbet_51 > @v151maxpermatch_51)
BEGIN
	SELECT @ErrMsg =  @UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be less than max bet and max bet must be less than max bet per match!!!'
					ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language)
					end	, @ErrCode = 110
	return
END

if (@v151MinMinBet_51>0 and @v151MinBet_51>0 and @v151MinBet_51<@v151MinMinBet_51)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be equal to or greater than Super Agent min bet'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10016,@Language)
					end						
					+' (' + convert(varchar(20), @v151MinMinBet_51) + ').', @ErrCode = 119	
	return
END

if (@v151MaxMaxBet_51>0 and @v151MaxBet_51>0 and @v151maxbet_51>@v151MaxMaxBet_51)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max bet must be equal to or less than Super Agent max bet'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10017,@Language)
					end						
					+' (' + convert(varchar(20), @v151MaxMaxBet_51) + ').', @ErrCode = 120	
	return
END

if (@v151MaxMaxPerMatch_51>0 and @v151MaxPerMatch_51>0 and @v151MaxPerMatch_51>@v151MaxMaxPerMatch_51)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max Per Match must be equal to or less than Super Agent Max Per Match'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10018,@Language)
					end						
					+' (' + convert(varchar(20), @v151MaxMaxPerMatch_51) + ').', @ErrCode = 121	
	return
END

if (@v152MinMinBet_41>0 and @v152MinBet_41>0 and @v152MinBet_41<@v152MinMinBet_41)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be equal to or greater than Super Agent min bet'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10016,@Language)
					end						
					+' (' + convert(varchar(20), @v152MinMinBet_41) + ').', @ErrCode = 119	
	return
END

if (@v152MaxMaxBet_41>0 and @v152MaxBet_41>0 and @v152maxbet_41>@v152MaxMaxBet_41)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max bet must be equal to or less than Super Agent max bet'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10017,@Language)
					end						
					+' (' + convert(varchar(20), @v152MaxMaxBet_41) + ').', @ErrCode = 120	
	return
END

if (@v152MaxMaxPerMatch_41>0 and @v152MaxPerMatch_41>0 and @v152MaxPerMatch_41>@v152MaxMaxPerMatch_41)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max Per Match must be equal to or less than Super Agent Max Per Match'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10018,@Language)
					end						
					+' (' + convert(varchar(20), @v152MaxMaxPerMatch_41) + ').', @ErrCode = 121	
	return
END

if 
(@v152minbet_51<>0 and @v152maxbet_51 <> 0 and  @v152minbet_51 > @v152maxbet_51) 
or (@v152maxbet_51<> 0 and @v152maxpermatch_51 <> 0 and @v152maxbet_51 > @v152maxpermatch_51) 
or (@v152minbet_51 <> 0 and @v152maxpermatch_51 <> 0 and @v152minbet_51 > @v152maxpermatch_51)
BEGIN
	SELECT @ErrMsg =  @UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be less than max bet and max bet must be less than max bet per match!!!'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language)
					end	, @ErrCode = 110
	return
END

if (@v152MinMinBet_51>0 and @v152MinBet_51>0 and @v152MinBet_51<@v152MinMinBet_51)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be equal to or greater than Super Agent min bet'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10016,@Language)
					end						
					+' (' + convert(varchar(20), @v152MinMinBet_51) + ').', @ErrCode = 119	
	return
END

if (@v152MaxMaxBet_51>0 and @v152MaxBet_51>0 and @v152maxbet_51>@v152MaxMaxBet_51)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max bet must be equal to or less than Super Agent max bet'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10017,@Language)
					end						
					+' (' + convert(varchar(20), @v152MaxMaxBet_51) + ').', @ErrCode = 120	
	return
END

if (@v152MaxMaxPerMatch_51>0 and @v152MaxPerMatch_51>0 and @v152MaxPerMatch_51>@v152MaxMaxPerMatch_51)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max Per Match must be equal to or less than Super Agent Max Per Match'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10018,@Language)
					end						
					+' (' + convert(varchar(20), @v152MaxMaxPerMatch_51) + ').', @ErrCode = 121	
	return
END

if 
(@v153minbet_51<>0 and @v153maxbet_51 <> 0 and  @v153minbet_51 > @v153maxbet_51) 
or (@v153maxbet_51<> 0 and @v153maxpermatch_51 <> 0 and @v153maxbet_51 > @v153maxpermatch_51) 
or (@v153minbet_51 <> 0 and @v153maxpermatch_51 <> 0 and @v153minbet_51 > @v153maxpermatch_51)

BEGIN
	SELECT @ErrMsg =  @UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be less than max bet and max bet must be less than max bet per match!!!'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language)
					end	, @ErrCode = 110
	return
END

if (@v153MinMinBet_51>0 and @v153MinBet_51>0 and @v153MinBet_51<@v153MinMinBet_51)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Min bet must be equal to or greater than Super Agent min bet'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10016,@Language)
					end						
					+' (' + convert(varchar(20), @v153MinMinBet_51) + ').', @ErrCode = 119	
	return
END

if (@v153MaxMaxBet_51>0 and @v153MaxBet_51>0 and @v153maxbet_51>@v153MaxMaxBet_51)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max bet must be equal to or less than Super Agent max bet'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10017,@Language)
					end						
					+' (' + convert(varchar(20), @v153MaxMaxBet_51) + ').', @ErrCode = 120	
	return
END

if (@v153MaxMaxPerMatch_51>0 and @v153MaxPerMatch_51>0 and @v153MaxPerMatch_51>@v153MaxMaxPerMatch_51)
BEGIN
	SELECT @ErrMsg =	@UserName + ': '+
					case @Language 
						when 'E' then 'Max Per Match must be equal to or less than Super Agent Max Per Match'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10018,@Language)
					end						
					+' (' + convert(varchar(20), @v153MaxMaxPerMatch_51) + ').', @ErrCode = 121	
	return
END
/*****************************************************************
			End validate min-max bet, maxpermatch
*****************************************************************/

/*****************************************************************
			Validate PT
*****************************************************************/



--a2+m2<=m3
select @ErrAcc = ''
	select top 100 @ErrAcc = @ErrAcc + username +', '
	from 
		custinfo as c with (NOLOCK) 
		inner join dep_custsetting as cs with (NOLOCK) on c.custid = cs.custid
		inner join (
	
				select 		1 as sporttype, 1 as bettype, @v1mpositiontaking_1 as maxpositiontaking,  @v1mlivepositiontaking_1 as maxlivepositiontaking
				union all select 	1 as sporttype, 2 as bettype, @v1mpositiontaking_2 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	1 as sporttype, 3 as bettype, @v1mpositiontaking_3 as maxpositiontaking,  @v1mlivepositiontaking_3 as maxlivepositiontaking
				union all select 	1 as sporttype, 4 as bettype, @v1mpositiontaking_4 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	1 as sporttype, 5 as bettype, @v1mpositiontaking_5 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	1 as sporttype, 6 as bettype, @v1mpositiontaking_6 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	1 as sporttype, 7 as bettype, @v1mpositiontaking_7 as maxpositiontaking,  @v1mlivepositiontaking_7 as maxlivepositiontaking
				union all select 	1 as sporttype, 8 as bettype, @v1mpositiontaking_8 as maxpositiontaking,  @v1mlivepositiontaking_8 as maxlivepositiontaking
				union all select 	1 as sporttype, 9 as bettype, @v1mpositiontaking_9 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	1 as sporttype, 10 as bettype, @v1mpositiontaking_10 as maxpositiontaking,  0 as maxlivepositiontaking
			) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
	where c.mrecommend = @custid and c.roleid = 2 and (
														(cs.apositiontaking+cs.mpositiontaking>b.maxpositiontaking and cs.islive = 0) 
														or 
														(b.bettype in (1,3,7,8) and cs.islive = 1 and cs.apositiontaking+cs.mpositiontaking>b.maxlivepositiontaking)
													  )
	group by username
	if @ErrAcc<>''
	BEGIN
		select @ErrCode = 8
		Select @ErrMsg = 	case @Language 
							when 'E' then 'Existing agents exceeded new master position taking ('+@ErrAcc+') (for Soccer).'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20011,@Language) + ' ('+@ErrAcc+') (' + [dbo].[f_Get_SportNameBySporttype](1,@Language) + ')'
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
	
				select 		1 as sporttype, 1 as bettype, @v1mpositiontaking_1 as maxpositiontaking,  @v1mlivepositiontaking_1 as maxlivepositiontaking
				union all select 	1 as sporttype, 2 as bettype, @v1mpositiontaking_2 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	1 as sporttype, 3 as bettype, @v1mpositiontaking_3 as maxpositiontaking,  @v1mlivepositiontaking_3 as maxlivepositiontaking
				union all select 	1 as sporttype, 4 as bettype, @v1mpositiontaking_4 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	1 as sporttype, 5 as bettype, @v1mpositiontaking_5 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	1 as sporttype, 6 as bettype, @v1mpositiontaking_6 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	1 as sporttype, 7 as bettype, @v1mpositiontaking_7 as maxpositiontaking,  @v1mlivepositiontaking_7 as maxlivepositiontaking
				union all select 	1 as sporttype, 8 as bettype, @v1mpositiontaking_8 as maxpositiontaking,  @v1mlivepositiontaking_8 as maxlivepositiontaking
				union all select 	1 as sporttype, 9 as bettype, @v1mpositiontaking_9 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	1 as sporttype, 10 as bettype, @v1mpositiontaking_10 as maxpositiontaking,  0 as maxlivepositiontaking
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

	--check m3<=m4
	select @ErrType = ''
	select @ErrType = @ErrType + sportname + '-'+ typenamee + '-Max: '+ cast((scs.mpositiontaking) as varchar(10))
	+ case when b.sporttype=1 and b.bettype in (1,3,7,8) and scs.islive = 1 then '-MaxLive: '+ cast((scs.mpositiontaking) as varchar(10)) else '' end + '<br>'
	from dep_custsetting as scs with (NOLOCK) inner join
		(
					select 1 as bettype, 1 as sporttype, @v1spositiontaking_1 as spositiontaking, @v1slivepositiontaking_1 as slivepositiontaking, @v1mpositiontaking_1 as mpositiontaking, @v1mlivepositiontaking_1 as mlivepositiontaking
			union all 	select 3 as bettype, 1 as sporttype, @v1spositiontaking_3 as spositiontaking, @v1slivepositiontaking_3 as slivepositiontaking, @v1mpositiontaking_3 as mpositiontaking, @v1mlivepositiontaking_3 as mlivepositiontaking
			union all 	select 7 as bettype, 1 as sporttype, @v1spositiontaking_7 as spositiontaking, @v1slivepositiontaking_7 as slivepositiontaking, @v1mpositiontaking_7 as mpositiontaking, @v1mlivepositiontaking_7 as mlivepositiontaking
			union all 	select 8 as bettype, 1 as sporttype, @v1spositiontaking_8 as spositiontaking, @v1slivepositiontaking_8 as slivepositiontaking, @v1mpositiontaking_8 as mpositiontaking, @v1mlivepositiontaking_8 as mlivepositiontaking
			union all 	select 2 as bettype, 1 as sporttype, @v1spositiontaking_2 as spositiontaking, 0 as slivepositiontaking, @v1mpositiontaking_2 as mpositiontaking, 0 as mlivepositiontaking
			union all 	select 4 as bettype, 1 as sporttype, @v1spositiontaking_4 as spositiontaking, 0 as slivepositiontaking, @v1mpositiontaking_4 as mpositiontaking, 0 as mlivepositiontaking
			union all 	select 5 as bettype, 1 as sporttype, @v1spositiontaking_5 as spositiontaking, 0 as slivepositiontaking, @v1mpositiontaking_5 as mpositiontaking, 0 as mlivepositiontaking
			union all 	select 6 as bettype, 1 as sporttype, @v1spositiontaking_6 as spositiontaking, 0 as slivepositiontaking, @v1mpositiontaking_6 as mpositiontaking, 0 as mlivepositiontaking
			union all 	select 9 as bettype, 1 as sporttype, @v1spositiontaking_9 as spositiontaking, 0 as slivepositiontaking, @v1mpositiontaking_9 as mpositiontaking, 0 as mlivepositiontaking
			union all 	select 10 as bettype, 1 as sporttype, @v1spositiontaking_10 as spositiontaking, 0 as slivepositiontaking, @v1mpositiontaking_10 as mpositiontaking, 0 as mlivepositiontaking
		) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
		inner join @tmp_Sports sports on b.sporttype = sports.sporttype
		inner join @tmp_Bettype bettype on b.bettype = bettype.typeid
	where scs.custid = @srecommend and (
						(scs.mpositiontaking<b.mpositiontaking and scs.islive = 0) or (scs.islive = 1 and scs.mpositiontaking<b.mpositiontaking)
						)
	if @ErrType <>''
	BEGIN
		select @ErrCode = 10
		Select @ErrMsg = 	@UserName + ': '+
					case @Language 
							when 'E' then 'Wrong position taking (max for master set by company).' + '<br>' + @ErrType
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20003,@Language) + '<br>' + @ErrType
					end
		return
	END

	--a2+m2<=m3
	select @ErrAcc = ''
	select top 100 @ErrAcc = @ErrAcc + username +', '
	from 
		custinfo as c with (NOLOCK) 
		inner join dep_custsetting as cs with (NOLOCK) on c.custid = cs.custid
		inner join (
	
					select 	2 as sporttype, 1 as bettype, @v2mpositiontaking_1 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	2 as sporttype, 2 as bettype, @v2mpositiontaking_2 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	2 as sporttype, 3 as bettype, @v2mpositiontaking_3 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	2 as sporttype, 20 as bettype, @v2mpositiontaking_20 as maxpositiontaking,  0 as maxlivepositiontaking
			) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
	where c.mrecommend = @custid and c.roleid = 2 and (cs.apositiontaking+cs.mpositiontaking>b.maxpositiontaking or (b.sporttype=1 and b.bettype in (1,3,7,8) and cs.islive = 1 and cs.apositiontaking+cs.mpositiontaking>b.maxlivepositiontaking))
	group by username
	if @ErrAcc<>''
	BEGIN
		select @ErrCode = 14
		Select @ErrMsg = 	case @Language 
							when 'E' then 'Existing agents exceeded new master position taking ('+@ErrAcc+') (for Basketball).'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20011,@Language) + ' ('+@ErrAcc+') (' + [dbo].[f_Get_SportNameBySporttype](2,@Language) + ')'
					end
		return
	END

	--m1+a1<=m3
	select @ErrAcc = ''
	select top 100 @ErrAcc = @ErrAcc + username +', '
	from 
		custinfo as c with (NOLOCK) 
		inner join dep_custsetting as cs with (NOLOCK) on c.custid = cs.custid
		inner join (
	
					select 	2 as sporttype, 1 as bettype, @v2mpositiontaking_1 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	2 as sporttype, 2 as bettype, @v2mpositiontaking_2 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	2 as sporttype, 3 as bettype, @v2mpositiontaking_3 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	2 as sporttype, 20 as bettype, @v2mpositiontaking_20 as maxpositiontaking,  0 as maxlivepositiontaking
			) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
	where c.mrecommend = @custid and c.roleid = 1 and (cs.apositiontaking+cs.mpositiontaking>b.maxpositiontaking or (b.sporttype=1 and b.bettype in (1,3,7,8) and cs.islive = 1 and cs.apositiontaking+cs.mpositiontaking>b.maxlivepositiontaking))
	group by username
	if @ErrAcc<>''
	BEGIN
		select @ErrCode = 15
		Select @ErrMsg = 	case @Language 
							when 'E' then 'Existing members exceeded new master position taking ('+@ErrAcc+') (for Basketball).'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20012,@Language) + ' ('+@ErrAcc+') (' + [dbo].[f_Get_SportNameBySporttype](2,@Language) + ')'
					end
		return
	END

	--check m3<=m4
	select @ErrType = ''
	select @ErrType = @ErrType + sportname + '-'+ typenamee + '-Max: '+ cast((scs.mpositiontaking) as varchar(10))
	+ case when b.sporttype=1 and b.bettype in (1,3,7,8) and scs.islive = 1 then '-MaxLive: '+ cast((scs.mpositiontaking) as varchar(10)) else '' end + '<br>'
	from dep_custsetting as scs with (NOLOCK) inner join
		(
				 	select 1 as bettype, 2 as sporttype, @v2spositiontaking_1 as spositiontaking, 0 as slivepositiontaking, @v2mpositiontaking_1 as mpositiontaking, 0 as mlivepositiontaking
			union all 	select 2 as bettype, 2 as sporttype, @v2spositiontaking_2 as spositiontaking, 0 as slivepositiontaking, @v2mpositiontaking_2 as mpositiontaking, 0 as mlivepositiontaking
			union all 	select 3 as bettype, 2 as sporttype, @v2spositiontaking_3 as spositiontaking, 0 as slivepositiontaking, @v2mpositiontaking_3 as mpositiontaking, 0 as mlivepositiontaking
			union all 	select 20 as bettype, 2 as sporttype, @v2spositiontaking_20 as spositiontaking, 0 as slivepositiontaking, @v2mpositiontaking_20 as mpositiontaking, 0 as mlivepositiontaking
		) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
		inner join @tmp_Sports sports on b.sporttype = sports.sporttype
		inner join @tmp_Bettype bettype on b.bettype = bettype.typeid
	where scs.custid = @srecommend and (
						scs.mpositiontaking<b.mpositiontaking or (b.sporttype=1 and b.bettype in (1,3,7,8) and islive = 1 and scs.mpositiontaking<b.mpositiontaking)
						)
	if @ErrType <>''
	BEGIN
		select @ErrCode = 16
		Select @ErrMsg = 	@UserName + ': '+
					case @Language 
							when 'E' then 'Wrong position taking (max for master set by company).' + '<br>' + @ErrType
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20003,@Language) + '<br>' + @ErrType
					end
		return
	END

	--m2+a2<=m3
	select @ErrAcc = ''
	select top 100 @ErrAcc = @ErrAcc + username +', '
	from 
		custinfo as c with (NOLOCK) 
		inner join dep_custsetting as cs with (NOLOCK) on c.custid = cs.custid
		inner join (
	
					select 	3 as sporttype, 1 as bettype, @v3mpositiontaking_1 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	3 as sporttype, 2 as bettype, @v3mpositiontaking_2 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	3 as sporttype, 3 as bettype, @v3mpositiontaking_3 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	3 as sporttype, 20 as bettype, @v3mpositiontaking_20 as maxpositiontaking,  0 as maxlivepositiontaking
			) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
	where c.mrecommend = @custid and c.roleid = 2 and (cs.apositiontaking+cs.mpositiontaking>b.maxpositiontaking or (b.sporttype=1 and b.bettype in (1,3,7,8) and cs.islive = 1 and cs.apositiontaking+cs.mpositiontaking>b.maxlivepositiontaking))
	group by username
	if @ErrAcc<>''
	BEGIN
		select @ErrCode = 14
		Select @ErrMsg = 	case @Language 
							when 'E' then 'Existing agents exceeded new master position taking ('+@ErrAcc+') (for Football).'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20011,@Language) + ' ('+@ErrAcc+') (' + [dbo].[f_Get_SportNameBySporttype](3,@Language) + ')'
					end
		return
	END

	--m1+a1<=m3
	select @ErrAcc = ''
	select top 100 @ErrAcc = @ErrAcc + username +', '
	from 
		custinfo as c with (NOLOCK) 
		inner join dep_custsetting as cs with (NOLOCK) on c.custid = cs.custid
		inner join (
	
					select 	3 as sporttype, 1 as bettype, @v3mpositiontaking_1 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	3 as sporttype, 2 as bettype, @v3mpositiontaking_2 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	3 as sporttype, 3 as bettype, @v3mpositiontaking_3 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	3 as sporttype, 20 as bettype, @v3mpositiontaking_20 as maxpositiontaking,  0 as maxlivepositiontaking
			) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
	where c.mrecommend = @custid and c.roleid = 1 and (cs.apositiontaking+cs.mpositiontaking>b.maxpositiontaking or (b.sporttype=1 and b.bettype in (1,3,7,8) and cs.islive = 1 and cs.apositiontaking+cs.mpositiontaking>b.maxlivepositiontaking))
	group by username
	if @ErrAcc<>''
	BEGIN
		select @ErrCode = 15
		Select @ErrMsg = 	case @Language 
							when 'E' then 'Existing members exceeded new master position taking ('+@ErrAcc+') (for Football).'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20012,@Language) + ' ('+@ErrAcc+') (' + [dbo].[f_Get_SportNameBySporttype](3,@Language) + ')'
					end
		return
	END

	--check m3<=m4
	select @ErrType = ''
	select @ErrType = @ErrType + sportname + '-'+ typenamee + '-Max: '+ cast((scs.mpositiontaking) as varchar(10))
	+ case when b.sporttype=1 and b.bettype in (1,3,7,8) and scs.islive = 1 then '-MaxLive: '+ cast((scs.mpositiontaking) as varchar(10)) else '' end + '<br>'
	from dep_custsetting as scs with (NOLOCK) inner join
		(
				select 1 as bettype, 3 as sporttype, @v3spositiontaking_1 as spositiontaking, 0 as slivepositiontaking, @v3mpositiontaking_1 as mpositiontaking, 0 as mlivepositiontaking
			union all 	select 2 as bettype, 3 as sporttype, @v3spositiontaking_2 as spositiontaking, 0 as slivepositiontaking, @v3mpositiontaking_2 as mpositiontaking, 0 as mlivepositiontaking
			union all 	select 3 as bettype, 3 as sporttype, @v3spositiontaking_3 as spositiontaking, 0 as slivepositiontaking, @v3mpositiontaking_3 as mpositiontaking, 0 as mlivepositiontaking
			union all 	select 20 as bettype, 3 as sporttype, @v3spositiontaking_20 as spositiontaking, 0 as slivepositiontaking, @v3mpositiontaking_20 as mpositiontaking, 0 as mlivepositiontaking
		) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
		inner join @tmp_Sports sports on b.sporttype = sports.sporttype
		inner join @tmp_Bettype bettype on b.bettype = bettype.typeid
	where scs.custid = @srecommend and (
						scs.mpositiontaking<b.mpositiontaking or (b.sporttype=1 and b.bettype in (1,3,7,8) and islive = 1 and scs.mpositiontaking<b.mpositiontaking)
						)
	if @ErrType <>''
	BEGIN
		select @ErrCode = 16
		Select @ErrMsg = @UserName + ': '+
					case @Language 
							when 'E' then 'Wrong position taking (max for master set by company).' + '<br>' + @ErrType
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20003,@Language) + '<br>' + @ErrType
					end
		return
	END

	--m2+a2<=m3
	select @ErrAcc = ''
	select top 100 @ErrAcc = @ErrAcc + username +', '
	from 
		custinfo as c with (NOLOCK) 
		inner join dep_custsetting as cs with (NOLOCK) on c.custid = cs.custid
		inner join (
	
					select 	5 as sporttype, 1 as bettype, @v5mpositiontaking_1 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	5 as sporttype, 2 as bettype, @v5mpositiontaking_2 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	5 as sporttype, 3 as bettype, @v5mpositiontaking_3 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	5 as sporttype, 20 as bettype, @v5mpositiontaking_20 as maxpositiontaking,  0 as maxlivepositiontaking
			) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
	where c.mrecommend = @custid and c.roleid = 2 and (cs.apositiontaking+cs.mpositiontaking>b.maxpositiontaking or (b.sporttype=1 and b.bettype in (1,3,7,8) and cs.islive = 1 and cs.apositiontaking+cs.mpositiontaking>b.maxlivepositiontaking))
	group by username
	if @ErrAcc<>''
	BEGIN
		select @ErrCode = 14
		Select @ErrMsg = 	case @Language 
							when 'E' then 'Existing agents exceeded new master position taking ('+@ErrAcc+') (for Tennis).'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20011,@Language) + ' ('+@ErrAcc+') (' + [dbo].[f_Get_SportNameBySporttype](5,@Language) + ')'
					end
		return
	END

	--m1+a1<=m3
	select @ErrAcc = ''
	select top 100 @ErrAcc = @ErrAcc + username +', '
	from 
		custinfo as c with (NOLOCK) 
		inner join dep_custsetting as cs with (NOLOCK) on c.custid = cs.custid
		inner join (
	
					select 	5 as sporttype, 1 as bettype, @v5mpositiontaking_1 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	5 as sporttype, 2 as bettype, @v5mpositiontaking_2 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	5 as sporttype, 3 as bettype, @v5mpositiontaking_3 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	5 as sporttype, 20 as bettype, @v5mpositiontaking_20 as maxpositiontaking,  0 as maxlivepositiontaking
			) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
	where c.mrecommend = @custid and c.roleid = 1 and (cs.apositiontaking+cs.mpositiontaking>b.maxpositiontaking or (b.sporttype=1 and b.bettype in (1,3,7,8) and cs.islive = 1 and cs.apositiontaking+cs.mpositiontaking>b.maxlivepositiontaking))
	group by username
	if @ErrAcc<>''
	BEGIN
		select @ErrCode = 15
		Select @ErrMsg = 	case @Language 
							when 'E' then 'Existing members exceeded new master position taking ('+@ErrAcc+') (for Tennis).'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20012,@Language) + ' ('+@ErrAcc+') (' + [dbo].[f_Get_SportNameBySporttype](5,@Language) + ')'
					end
		return
	END

	--check m3<=m4
	select @ErrType = ''
	select @ErrType = @ErrType + sportname + '-'+ typenamee + '-Max: '+ cast((scs.mpositiontaking) as varchar(10))
	+ case when b.sporttype=1 and b.bettype in (1,3,7,8) and scs.islive = 1 then '-MaxLive: '+ cast((scs.mpositiontaking) as varchar(10)) else '' end + '<br>'
	from dep_custsetting as scs with (NOLOCK) inner join
		(
				 	select 1 as bettype, 5 as sporttype, @v5spositiontaking_1 as spositiontaking, 0 as slivepositiontaking, @v5mpositiontaking_1 as mpositiontaking, 0 as mlivepositiontaking
			union all 	select 2 as bettype, 5 as sporttype, @v5spositiontaking_2 as spositiontaking, 0 as slivepositiontaking, @v5mpositiontaking_2 as mpositiontaking, 0 as mlivepositiontaking
			union all 	select 3 as bettype, 5 as sporttype, @v5spositiontaking_3 as spositiontaking, 0 as slivepositiontaking, @v5mpositiontaking_3 as mpositiontaking, 0 as mlivepositiontaking
			union all 	select 20 as bettype, 5 as sporttype, @v5spositiontaking_20 as spositiontaking, 0 as slivepositiontaking, @v5mpositiontaking_20 as mpositiontaking, 0 as mlivepositiontaking
		) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
		inner join @tmp_Sports sports on b.sporttype = sports.sporttype
		inner join @tmp_Bettype bettype on b.bettype = bettype.typeid
	where scs.custid = @srecommend and (
						scs.mpositiontaking<b.mpositiontaking or (b.sporttype=1 and b.bettype in (1,3,7,8) and scs.islive = 1 and scs.mpositiontaking<b.mpositiontaking)
						)
	if @ErrType <>''
	BEGIN
		select @ErrCode = 16
		Select @ErrMsg = @UserName + ': '+
					case @Language 
							when 'E' then 'Wrong position taking (max for master set by company).' + '<br>' + @ErrType
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20003,@Language) + '<br>' + @ErrType
					end
		return
	END

	--m2+a2<=m3
	select @ErrAcc = ''
	select top 100 @ErrAcc = @ErrAcc + username +', '
	from 
		custinfo as c with (NOLOCK) 
		inner join dep_custsetting as cs with (NOLOCK) on c.custid = cs.custid
		inner join (
	
					select 	8 as sporttype, 1 as bettype, @v8mpositiontaking_1 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	8 as sporttype, 3 as bettype, @v8mpositiontaking_3 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	8 as sporttype, 20 as bettype, @v8mpositiontaking_20 as maxpositiontaking,  0 as maxlivepositiontaking
			) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
	where c.mrecommend = @custid and c.roleid = 2 and (cs.apositiontaking+cs.mpositiontaking>b.maxpositiontaking)
	group by username
	if @ErrAcc<>''
	BEGIN
		select @ErrCode = 14
		Select @ErrMsg = 	case @Language 
							when 'E' then 'Existing agents exceeded new master position taking ('+@ErrAcc+') (for Baseball).'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20011,@Language) + ' ('+@ErrAcc+') (' + [dbo].[f_Get_SportNameBySporttype](8,@Language) + ')'
					end
		return
	END

	--m1+a1<=m3
	select @ErrAcc = ''
	select top 100 @ErrAcc = @ErrAcc + username +', '
	from 
		custinfo as c with (NOLOCK) 
		inner join dep_custsetting as cs with (NOLOCK) on c.custid = cs.custid
		inner join (
	
					select 	8 as sporttype, 1 as bettype, @v8mpositiontaking_1 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	8 as sporttype, 3 as bettype, @v8mpositiontaking_3 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	8 as sporttype, 20 as bettype, @v8mpositiontaking_20 as maxpositiontaking,  0 as maxlivepositiontaking
			) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
	where c.mrecommend = @custid and c.roleid = 1 and (cs.apositiontaking+cs.mpositiontaking>b.maxpositiontaking or (b.sporttype=1 and b.bettype in (1,3,7,8) and cs.islive = 1 and cs.apositiontaking+cs.mpositiontaking>b.maxlivepositiontaking))
	group by username
	if @ErrAcc<>''
	BEGIN
		select @ErrCode = 15
		Select @ErrMsg = 	case @Language 
							when 'E' then 'Existing members exceeded new master position taking ('+@ErrAcc+') (for Baseball).'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20012,@Language) + ' ('+@ErrAcc+') (' + [dbo].[f_Get_SportNameBySporttype](8,@Language) + ')'
					end
		return
	END

	--check m3<=m4
	select @ErrType = ''
	select @ErrType = @ErrType + sportname + '-'+ typenamee + '-Max: '+ cast((scs.mpositiontaking) as varchar(10))
	+ case when b.sporttype=1 and b.bettype in (1,3,7,8) and scs.islive = 1 then '-MaxLive: '+ cast((scs.mpositiontaking) as varchar(10)) else '' end + '<br>'
	from dep_custsetting as scs with (NOLOCK) inner join
		(
				 	select 1 as bettype, 8 as sporttype, @v8spositiontaking_1 as spositiontaking, 0 as slivepositiontaking, @v8mpositiontaking_1 as mpositiontaking, 0 as mlivepositiontaking
			union all 	select 3 as bettype, 8 as sporttype, @v8spositiontaking_3 as spositiontaking, 0 as slivepositiontaking, @v8mpositiontaking_3 as mpositiontaking, 0 as mlivepositiontaking
			union all 	select 20 as bettype, 8 as sporttype, @v8spositiontaking_20 as spositiontaking, 0 as slivepositiontaking, @v8mpositiontaking_20 as mpositiontaking, 0 as mlivepositiontaking
		) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
		inner join @tmp_Sports sports on b.sporttype = sports.sporttype
		inner join @tmp_Bettype bettype on b.bettype = bettype.typeid
	where scs.custid = @srecommend and (
						scs.mpositiontaking<b.mpositiontaking or (b.sporttype=1 and b.bettype in (1,3,7,8) and scs.islive = 1 and scs.mpositiontaking<b.mpositiontaking)
						)
	if @ErrType <>''
	BEGIN
		select @ErrCode = 16
		Select @ErrMsg = 	@UserName + ': '+
					case @Language 
							when 'E' then 'Wrong position taking (max for master set by company).' + '<br>' + @ErrType
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20003,@Language) + '<br>' + @ErrType
					end
		return
	END

	--m2+a2<=m3
	select @ErrAcc = ''
	select top 100 @ErrAcc = @ErrAcc + username +', '
	from 
		custinfo as c with (NOLOCK) 
		inner join dep_custsetting as cs with (NOLOCK) on c.custid = cs.custid
		inner join (
	
					select 	10 as sporttype, 1 as bettype, @v10mpositiontaking_1 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	10 as sporttype, 2 as bettype, @v10mpositiontaking_2 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	10 as sporttype, 3 as bettype, @v10mpositiontaking_3 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	10 as sporttype, 20 as bettype, @v10mpositiontaking_20 as maxpositiontaking,  0 as maxlivepositiontaking
			) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
	where c.mrecommend = @custid and c.roleid = 2 and (cs.apositiontaking+cs.mpositiontaking>b.maxpositiontaking or (b.sporttype=1 and b.bettype in (1,3,7,8) and cs.islive = 1 and cs.apositiontaking+cs.mpositiontaking>b.maxlivepositiontaking))
	group by username
	if @ErrAcc<>''
	BEGIN
		select @ErrCode = 14
		Select @ErrMsg = 	case @Language 
							when 'E' then 'Existing agents exceeded new master position taking ('+@ErrAcc+') (for Golf).'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20011,@Language) + ' ('+@ErrAcc+') (' + [dbo].[f_Get_SportNameBySporttype](10,@Language) + ')'
					end
		return
	END

	--m1+a1<=m3
	select @ErrAcc = ''
	select top 100 @ErrAcc = @ErrAcc + username +', '
	from 
		customer as c with (NOLOCK) 
		inner join dep_custsetting as cs with (NOLOCK) on c.custid = cs.custid
		inner join (
	
					select 	10 as sporttype, 1 as bettype, @v10mpositiontaking_1 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	10 as sporttype, 2 as bettype, @v10mpositiontaking_2 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	10 as sporttype, 3 as bettype, @v10mpositiontaking_3 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	10 as sporttype, 20 as bettype, @v10mpositiontaking_20 as maxpositiontaking,  0 as maxlivepositiontaking
			) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
	where c.mrecommend = @custid and c.roleid = 1 and (cs.apositiontaking+cs.mpositiontaking>b.maxpositiontaking or (b.sporttype=1 and b.bettype in (1,3,7,8) and cs.islive = 1 and cs.apositiontaking+cs.mpositiontaking>b.maxlivepositiontaking))
	group by username
	if @ErrAcc<>''
	BEGIN
		select @ErrCode = 15
		Select @ErrMsg = 	case @Language 
							when 'E' then 'Existing members exceeded new master position taking ('+@ErrAcc+') (for Golf).'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20012,@Language) + ' ('+@ErrAcc+') (' + [dbo].[f_Get_SportNameBySporttype](10,@Language) + ')'
					end
		return
	END

	--check m3<=m4
	select @ErrType = ''
	select @ErrType = @ErrType + sportname + '-'+ typenamee + '-Max: '+ cast((scs.mpositiontaking) as varchar(10)) + '<br>'
	from dep_custsetting as scs with (NOLOCK) inner join
		(
				 	select 1 as bettype, 10 as sporttype, @v10spositiontaking_1 as spositiontaking, 0 as slivepositiontaking, @v10mpositiontaking_1 as mpositiontaking, 0 as mlivepositiontaking
			union all 	select 2 as bettype, 10 as sporttype, @v10spositiontaking_2 as spositiontaking, 0 as slivepositiontaking, @v10mpositiontaking_2 as mpositiontaking, 0 as mlivepositiontaking
			union all 	select 3 as bettype, 10 as sporttype, @v10spositiontaking_3 as spositiontaking, 0 as slivepositiontaking, @v10mpositiontaking_3 as mpositiontaking, 0 as mlivepositiontaking
			union all 	select 20 as bettype, 10 as sporttype, @v10spositiontaking_20 as spositiontaking, 0 as slivepositiontaking, @v10mpositiontaking_20 as mpositiontaking, 0 as mlivepositiontaking
		) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
		inner join @tmp_Sports sports on b.sporttype = sports.sporttype
		inner join @tmp_Bettype bettype on b.bettype = bettype.typeid
	where scs.custid = @srecommend and (
						scs.mpositiontaking<b.mpositiontaking
						)
	if @ErrType <>''
	BEGIN
		select @ErrCode = 16
		Select @ErrMsg = @UserName + ': '+
					case @Language 
							when 'E' then 'Wrong position taking (max for master set by company).' + '<br>' + @ErrType
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20003,@Language) + '<br>' + @ErrType
					end
		return
	END

	--m2+a2<=m3
	select @ErrAcc = ''
	select top 100 @ErrAcc = @ErrAcc + username +', '
	from 
		custinfo as c with (NOLOCK) 
		inner join dep_custsetting as cs with (NOLOCK) on c.custid = cs.custid
		inner join (
	
					select 	11 as sporttype, 1 as bettype, @v11mpositiontaking_1 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	11 as sporttype, 20 as bettype, @v11mpositiontaking_20 as maxpositiontaking,  0 as maxlivepositiontaking
			) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
	where c.mrecommend = @custid and c.roleid = 2 and (cs.apositiontaking+cs.mpositiontaking>b.maxpositiontaking or (b.sporttype=1 and b.bettype in (1,3,7,8) and cs.islive = 1 and cs.apositiontaking+cs.mpositiontaking>b.maxlivepositiontaking))
	group by username
	if @ErrAcc<>''
	BEGIN
		select @ErrCode = 14
		Select @ErrMsg = 	case @Language 
							when 'E' then 'Existing agents exceeded new master position taking ('+@ErrAcc+') (for Motorsports).'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20011,@Language) + ' ('+@ErrAcc+') (' + [dbo].[f_Get_SportNameBySporttype](11,@Language) + ')'
					end
		return
	END

	--m1+a1<=m3
	select @ErrAcc = ''
	select top 100 @ErrAcc = @ErrAcc + username +', '
	from 
		custinfo as c with (NOLOCK) 
		inner join dep_custsetting as cs with (NOLOCK) on c.custid = cs.custid
		inner join (
	
					select 	11 as sporttype, 1 as bettype, @v11mpositiontaking_1 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	11 as sporttype, 20 as bettype, @v11mpositiontaking_20 as maxpositiontaking,  0 as maxlivepositiontaking
			) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
	where c.mrecommend = @custid and c.roleid = 1 and (cs.apositiontaking+cs.mpositiontaking>b.maxpositiontaking or (b.sporttype=1 and b.bettype in (1,3,7,8) and cs.islive = 1 and cs.apositiontaking+cs.mpositiontaking>b.maxlivepositiontaking))
	group by username
	if @ErrAcc<>''
	BEGIN
		select @ErrCode = 15
		Select @ErrMsg = 	case @Language 
							when 'E' then 'Existing members exceeded new master position taking ('+@ErrAcc+') (for Motorsports).'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20012,@Language) + ' ('+@ErrAcc+') (' + [dbo].[f_Get_SportNameBySporttype](11,@Language) + ')'
					end
		return
	END

	--check m3<=m4
	select @ErrType = ''
	select @ErrType = @ErrType + sportname + '-'+ typenamee + '-Max: '+ cast((scs.mpositiontaking) as varchar(10))
	+ case when b.sporttype=1 and b.bettype in (1,3,7,8) and scs.islive = 1 then '-MaxLive: '+ cast((scs.mpositiontaking) as varchar(10)) else '' end + '<br>'
	from dep_custsetting as scs with (NOLOCK) inner join
		(
				 	select 1 as bettype, 11 as sporttype, @v11spositiontaking_1 as spositiontaking, 0 as slivepositiontaking, @v11mpositiontaking_1 as mpositiontaking, 0 as mlivepositiontaking
			union all 	select 20 as bettype, 11 as sporttype, @v11spositiontaking_20 as spositiontaking, 0 as slivepositiontaking, @v11mpositiontaking_20 as mpositiontaking, 0 as mlivepositiontaking
		) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
		inner join @tmp_Sports sports on b.sporttype = sports.sporttype
		inner join @tmp_Bettype bettype on b.bettype = bettype.typeid
	where scs.custid = @srecommend and (
						scs.mpositiontaking<b.mpositiontaking or (b.sporttype=1 and b.bettype in (1,3,7,8) and islive = 1 and scs.mpositiontaking<b.mlivepositiontaking)
						)
	if @ErrType <>''
	BEGIN
		select @ErrCode = 16
		Select @ErrMsg = @UserName + ': '+
					case @Language 
							when 'E' then 'Wrong position taking (max for master set by company).' + '<br>' + @ErrType
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20003,@Language) + '<br>' + @ErrType
					end
		return
	END
----v44

	--m2+a2<=m3
	select @ErrAcc = ''
	select top 100 @ErrAcc = @ErrAcc + username +', '
	from 
		custinfo as c with (NOLOCK) 
		inner join dep_custsetting as cs with (NOLOCK) on c.custid = cs.custid
		inner join (
	
					select 	44 as sporttype, 3 as bettype, @v44mpositiontaking_3 as maxpositiontaking,  0 as maxlivepositiontaking
				
			) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
	where c.mrecommend = @custid and c.roleid = 2 and (cs.apositiontaking+cs.mpositiontaking>b.maxpositiontaking or (b.sporttype=1 and b.bettype in (1,3,7,8) and cs.islive = 1 and cs.apositiontaking+cs.mpositiontaking>b.maxlivepositiontaking))
	group by username
	if @ErrAcc<>''
	BEGIN
		select @ErrCode = 14
		Select @ErrMsg = 	case @Language 
							when 'E' then 'Existing agents exceeded new master position taking ('+@ErrAcc+') (for MuayThai).'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20011,@Language) + ' ('+@ErrAcc+') (' + [dbo].[f_Get_SportNameBySporttype](44,@Language) + ')'
					end
		return
	END

	--m1+a1<=m3
	select @ErrAcc = ''
	select top 100 @ErrAcc = @ErrAcc + username +', '
	from 
		custinfo as c with (NOLOCK) 
		inner join dep_custsetting as cs with (NOLOCK) on c.custid = cs.custid
		inner join (
	
					select 	44 as sporttype, 3 as bettype, @v44mpositiontaking_3 as maxpositiontaking,  0 as maxlivepositiontaking
				
			) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
	where c.mrecommend = @custid and c.roleid = 1 and (cs.apositiontaking+cs.mpositiontaking>b.maxpositiontaking or (b.sporttype=1 and b.bettype in (1,3,7,8) and cs.islive = 1 and cs.apositiontaking+cs.mpositiontaking>b.maxlivepositiontaking))
	group by username
	if @ErrAcc<>''
	BEGIN
		select @ErrCode = 15
		Select @ErrMsg = 	case @Language 
							when 'E' then 'Existing members exceeded new master position taking ('+@ErrAcc+') (for MuayThai).'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20012,@Language) + ' ('+@ErrAcc+') (' + [dbo].[f_Get_SportNameBySporttype](44,@Language) + ')'
					end
		return
	END

	--check m3<=m4
	select @ErrType = ''
	select @ErrType = @ErrType + sportname + '-'+ typenamee + '-Max: '+ cast((scs.mpositiontaking) as varchar(10))
	+ case when b.sporttype=1 and b.bettype in (1,3,7,8) and scs.islive = 1 then '-MaxLive: '+ cast((scs.mpositiontaking) as varchar(10)) else '' end + '<br>'
	from dep_custsetting as scs with (NOLOCK) inner join
		(
				 	select 3 as bettype, 44 as sporttype, @v44spositiontaking_3 as spositiontaking, 0 as slivepositiontaking, @v44mpositiontaking_3 as mpositiontaking, 0 as mlivepositiontaking
			
		) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
		inner join @tmp_Sports sports on b.sporttype = sports.sporttype
		inner join @tmp_Bettype bettype on b.bettype = bettype.typeid
	where scs.custid = @srecommend and (
						scs.mpositiontaking<b.mpositiontaking or (b.sporttype=1 and b.bettype in (1,3,7,8) and islive = 1 and scs.mpositiontaking<b.mlivepositiontaking)
						)
	if @ErrType <>''
	BEGIN
		select @ErrCode = 16
		Select @ErrMsg = @UserName + ': '+
					case @Language 
							when 'E' then 'Wrong position taking (max for master set by company).' + '<br>' + @ErrType
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20003,@Language) + '<br>' + @ErrType
					end
		return
	END
----endv44
	--m2+a2<=m3
	select @ErrAcc = ''
	select top 100 @ErrAcc = @ErrAcc + username +', '
	from 
		custinfo as c with (NOLOCK) 
		inner join dep_custsetting as cs with (NOLOCK) on c.custid = cs.custid
		inner join (
	
					select 	99 as sporttype, 1 as bettype, @v99mpositiontaking_1 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	99 as sporttype, 2 as bettype, @v99mpositiontaking_2 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	99 as sporttype, 3 as bettype, @v99mpositiontaking_3 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	99 as sporttype, 20 as bettype, @v99mpositiontaking_20 as maxpositiontaking,  0 as maxlivepositiontaking
			) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
	where c.mrecommend = @custid and c.roleid = 2 and (cs.apositiontaking+cs.mpositiontaking>b.maxpositiontaking)
	group by username
	if @ErrAcc<>''
	BEGIN
		select @ErrCode = 14
		Select @ErrMsg = 	case @Language 
							when 'E' then 'Existing agents exceeded new master position taking ('+@ErrAcc+') (for Other sports).'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20011,@Language) + ' ('+@ErrAcc+') (' + [dbo].[f_Get_SportNameBySporttype](99,@Language) + ')'
					end
		return
	END

	--m1+a1<=m3
	select @ErrAcc = ''
	select top 100 @ErrAcc = @ErrAcc + username +', '
	from 
		custinfo as c with (NOLOCK) 
		inner join dep_custsetting as cs with (NOLOCK) on c.custid = cs.custid
		inner join (
	
					select 	99 as sporttype, 1 as bettype, @v99mpositiontaking_1 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	99 as sporttype, 2 as bettype, @v99mpositiontaking_2 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	99 as sporttype, 3 as bettype, @v99mpositiontaking_3 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	99 as sporttype, 20 as bettype, @v99mpositiontaking_20 as maxpositiontaking,  0 as maxlivepositiontaking
			) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
	where c.mrecommend = @custid and c.roleid = 1 and (cs.apositiontaking+cs.mpositiontaking>b.maxpositiontaking)
	group by username
	if @ErrAcc<>''
	BEGIN
		select @ErrCode = 15
		Select @ErrMsg = 	case @Language 
							when 'E' then 'Existing members exceeded new master position taking ('+@ErrAcc+') (for Other sports).'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20012,@Language) + ' ('+@ErrAcc+') (' + [dbo].[f_Get_SportNameBySporttype](99,@Language) + ')'
					end
		return
	END

	--check m3<=m4
	select @ErrType = ''
	select @ErrType = @ErrType + sportname + '-'+ typenamee + '-Max: '+ cast((scs.mpositiontaking) as varchar(10)) + '<br>'
	from dep_custsetting as scs with (NOLOCK) inner join
		(
				 	select 1 as bettype, 99 as sporttype, @v99spositiontaking_1 as spositiontaking, 0 as slivepositiontaking, @v99mpositiontaking_1 as mpositiontaking, 0 as mlivepositiontaking
			union all 	select 2 as bettype, 99 as sporttype, @v99spositiontaking_2 as spositiontaking, 0 as slivepositiontaking, @v99mpositiontaking_2 as mpositiontaking, 0 as mlivepositiontaking
			union all 	select 3 as bettype, 99 as sporttype, @v99spositiontaking_3 as spositiontaking, 0 as slivepositiontaking, @v99mpositiontaking_3 as mpositiontaking, 0 as mlivepositiontaking
			union all 	select 20 as bettype, 99 as sporttype, @v99spositiontaking_20 as spositiontaking, 0 as slivepositiontaking, @v99mpositiontaking_20 as mpositiontaking, 0 as mlivepositiontaking
		) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
		inner join @tmp_Sports sports on b.sporttype = sports.sporttype
		inner join @tmp_Bettype bettype on b.bettype = bettype.typeid
	where scs.custid = @srecommend and (
						scs.mpositiontaking<b.mpositiontaking
						)
	if @ErrType <>''
	BEGIN
		select @ErrCode = 16
		Select @ErrMsg = @UserName + ': '+
					case @Language 
							when 'E' then 'Wrong position taking (max for master set by company).' + '<br>' + @ErrType
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20003,@Language) + '<br>' + @ErrType
					end
		return
	END

	--HRFO
		--m2+a2<=m3
	select @ErrAcc = ''
	select top 100 @ErrAcc = @ErrAcc + username +', '
	from 
		custinfo as c with (NOLOCK) 
		inner join dep_custsetting as cs with (NOLOCK) on c.custid = cs.custid
		inner join (	
					select 	154 as sporttype, 20 as bettype, @v154mpositiontaking_20 as maxpositiontaking,  0 as maxlivepositiontaking
			) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
	where c.mrecommend = @custid and c.roleid = 2 and (cs.apositiontaking+cs.mpositiontaking>b.maxpositiontaking)
	group by username
	if @ErrAcc<>''
	BEGIN
		select @ErrCode = 14
		Select @ErrMsg = 	case @Language 
							when 'E' then 'Existing agents exceeded new master position taking ('+@ErrAcc+') (for HR Fixed Odds).'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20011,@Language) + ' ('+@ErrAcc+') (' + [dbo].[f_Get_SportNameBySporttype](154,@Language) + ')'
					end
		return
	END

	--m1+a1<=m3
	select @ErrAcc = ''
	select top 100 @ErrAcc = @ErrAcc + username +', '
	from 
		custinfo as c with (NOLOCK) 
		inner join dep_custsetting as cs with (NOLOCK) on c.custid = cs.custid
		inner join (	
					select 	154 as sporttype, 20 as bettype, @v154mpositiontaking_20 as maxpositiontaking,  0 as maxlivepositiontaking
			) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
	where c.mrecommend = @custid and c.roleid = 1 and (cs.apositiontaking+cs.mpositiontaking>b.maxpositiontaking)
	group by username
	if @ErrAcc<>''
	BEGIN
		select @ErrCode = 15
		Select @ErrMsg = 	case @Language 
							when 'E' then 'Existing members exceeded new master position taking ('+@ErrAcc+') (for HR Fixed Odds).'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20012,@Language) + ' ('+@ErrAcc+') (' + [dbo].[f_Get_SportNameBySporttype](154,@Language) + ')'
					end
		return
	END

	--check m3<=m4
	select @ErrType = ''
	select @ErrType = @ErrType + sportname + '-'+ typenamee + '-Max: '+ cast((scs.mpositiontaking) as varchar(10)) + '<br>'
	from dep_custsetting as scs with (NOLOCK) inner join
		(
		 	select 20 as bettype, 154 as sporttype, @v154spositiontaking_20 as spositiontaking, 0 as slivepositiontaking, @v154mpositiontaking_20 as mpositiontaking, 0 as mlivepositiontaking
		) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
		inner join @tmp_Sports sports on b.sporttype = sports.sporttype
		inner join @tmp_Bettype bettype on b.bettype = bettype.typeid
	where scs.custid = @srecommend and (
						scs.mpositiontaking<b.mpositiontaking
						)
	if @ErrType <>''
	BEGIN
		select @ErrCode = 16
		Select @ErrMsg = @UserName + ': '+
					case @Language 
							when 'E' then 'Wrong position taking (max for master set by company).' + '<br>' + @ErrType
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20003,@Language) + '<br>' + @ErrType
					end
		return
	END
	--HRFO
	
	--m2+a2<=m3
	select @ErrAcc = ''
	select top 100 @ErrAcc = @ErrAcc + username +', '
	from 
		custinfo as c with (NOLOCK) 
		inner join dep_custsetting as cs with (NOLOCK) on c.custid = cs.custid
		inner join (
				select 	99 as sporttype, 9 as bettype, @v99mpositiontaking_9 as maxpositiontaking,  0 as maxlivepositiontaking
			) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
	where c.mrecommend = @custid and c.roleid = 2 and (cs.apositiontaking+cs.mpositiontaking>b.maxpositiontaking)
	group by username
	if @ErrAcc<>''
	BEGIN
		select @ErrCode = 203
		Select @ErrMsg = 	case @Language 
							when 'E' then 'Existing agents exceeded new master position taking ('+@ErrAcc+') (for Mix Sports Parlay).'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20011,@Language) + ' ('+@ErrAcc+') ' + case @Language 
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

	--m1+a1<=m3
	select @ErrAcc = ''
	select top 100 @ErrAcc = @ErrAcc + username +', '
	from 
		custinfo as c with (NOLOCK) 
		inner join dep_custsetting as cs with (NOLOCK) on c.custid = cs.custid
		inner join (
				select 	99 as sporttype, 9 as bettype, @v99mpositiontaking_9 as maxpositiontaking,  0 as maxlivepositiontaking
			) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
	where c.mrecommend = @custid and c.roleid = 1 and (cs.apositiontaking+cs.mpositiontaking>b.maxpositiontaking)
	group by username
	if @ErrAcc<>''
	BEGIN
		select @ErrCode = 204
		Select @ErrMsg = 	case @Language 
							when 'E' then 'Existing members exceeded new master position taking ('+@ErrAcc+') (for Mix Sports Parlay).'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20012,@Language) + ' ('+@ErrAcc+') ' + case @Language 
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

	--check m3<=m4
	select @ErrType = ''
	select @ErrType = @ErrType + sportname + '-'+ typenamee + '-Max: '+ cast((scs.mpositiontaking) as varchar(10))
	from dep_custsetting as scs with (NOLOCK) inner join
		(
			select 9 as bettype, 99 as sporttype, @v99spositiontaking_9 as spositiontaking, 0 as slivepositiontaking, @v99mpositiontaking_9 as mpositiontaking, 0 as mlivepositiontaking
		) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
		inner join @tmp_Sports sports on b.sporttype = sports.sporttype
		inner join @tmp_Bettype bettype on b.bettype = bettype.typeid
	where scs.custid = @srecommend and (
						scs.mpositiontaking<b.mpositiontaking
						)
	if @ErrType <>''
	BEGIN
		select @ErrCode = 205
		Select @ErrMsg = @UserName + ': '+
					case @Language 
							when 'E' then 'Wrong position taking (max for master set by company).' + '<br>' + @ErrType
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20003,@Language) + '<br>' + @ErrType
					end
		return
	END

	select @ErrAcc = ''
	select top 100 @ErrAcc = @ErrAcc + username 
	from 
		custinfo as c with (NOLOCK) 
		inner join dep_custsetting3rd as cs3 with (NOLOCK) on c.custid = cs3.custid
		inner join (											  
						  select 161 as sporttype, 81 as bettype, @v161mpositiontaking_81 as maxpositiontaking, 0 as maxlivepositiontaking
				union all select 161 as sporttype, 83 as bettype, @v161mpositiontaking_83 as maxpositiontaking, 0 as maxlivepositiontaking
				union all select 161 as sporttype, 88 as bettype, @v161mpositiontaking_88 as maxpositiontaking, 0 as maxlivepositiontaking
				union all select 161 as sporttype, 85 as bettype, 0 as maxpositiontaking, @v161mlivepositiontaking_85 as maxlivepositiontaking
				union all select 161 as sporttype, 86 as bettype, @v161mpositiontaking_86 as maxpositiontaking, @v161mlivepositiontaking_86 as maxlivepositiontaking
				union all select 161 as sporttype, 87 as bettype, 0 as maxpositiontaking, @v161mlivepositiontaking_87 as maxlivepositiontaking
				union all select 161 as sporttype, 89 as bettype, 0 as maxpositiontaking, @v161mlivepositiontaking_89 as maxlivepositiontaking
				union all select 161 as sporttype, 90 as bettype, 0 as maxpositiontaking, @v161mlivepositiontaking_90 as maxlivepositiontaking
			) as b on cs3.sporttype=b.sporttype and cs3.bettype = b.bettype
	where c.mrecommend = @custid and c.roleid = 2 and ((cs3.apositiontaking+cs3.mpositiontaking>b.maxpositiontaking and cs3.islive = 0) or (cs3.islive = 1 and b.bettype in (85,86,87,89) and cs3.apositiontaking+cs3.mpositiontaking>b.maxlivepositiontaking))				
	group by username

	if @ErrAcc<>''
	BEGIN
		select @ErrCode = 210
		Select @ErrMsg = 	case @Language 
							when 'E' then 'Existing agents exceeded new master position taking ('+@ErrAcc+') (for Number Game).'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20011,@Language) + ' ('+@ErrAcc+') (' + [dbo].[f_Get_SportNameBySporttype](161,@Language) + ')'
					end
		return
	END

	--a1+m1<=m3
	select @ErrAcc = ''
	select top 100 @ErrAcc = @ErrAcc + username +', '
	from 
		custinfo as c with (NOLOCK) 
		inner join dep_custsetting3rd as cs with (NOLOCK) on c.custid = cs.custid
		inner join (
						  select 	161 as sporttype, 81 as bettype, @v161mpositiontaking_81 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	161 as sporttype, 83 as bettype, @v161mpositiontaking_83 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	161 as sporttype, 88 as bettype, @v161mpositiontaking_88 as maxpositiontaking,  0 as maxlivepositiontaking
				union all select 	161 as sporttype, 85 as bettype, 0 as maxpositiontaking,  @v161mlivepositiontaking_85 as maxlivepositiontaking
				union all select	161 as sporttype, 86 as bettype, @v161mpositiontaking_86 as maxpositiontaking,  @v161mlivepositiontaking_86 as maxlivepositiontaking
				union all select 	161 as sporttype, 87 as bettype, 0 as maxpositiontaking,  @v161mlivepositiontaking_87 as maxlivepositiontaking
				union all select 	161 as sporttype, 89 as bettype, 0 as maxpositiontaking,  @v161mlivepositiontaking_89 as maxlivepositiontaking
				union all select 	161 as sporttype, 90 as bettype, 0 as maxpositiontaking,  @v161mlivepositiontaking_90 as maxlivepositiontaking
				
			) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
	where c.mrecommend = @custid and c.roleid = 1 and ((cs.apositiontaking+cs.mpositiontaking>b.maxpositiontaking AND cs.islive = 0) or (b.sporttype=161 and cs.islive = 1 and b.bettype in (85,86,87,89) and cs.apositiontaking+cs.mpositiontaking>b.maxlivepositiontaking))
	group by username
	if @ErrAcc<>''
	BEGIN
		select @ErrCode = 211
		Select @ErrMsg = 	case @Language 
							when 'E' then 'Existing members exceeded new master position taking ('+@ErrAcc+') (for Number Game).'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20012,@Language) + ' ('+@ErrAcc+') (' + [dbo].[f_Get_SportNameBySporttype](161,@Language) + ')'
					end
		return
	END

	--check m3<=m4
	select @ErrType = ''
	select @ErrType = @ErrType + sportname + '-'+ typenamee + '-Max: '+ cast((scs.mpositiontaking) as varchar(10))
	+ case when b.sporttype=161 and b.bettype in (85,86,87,89) then '-MaxLive: '+ cast((scs.mpositiontaking) as varchar(10)) else '' end + '<br>'
	from dep_custsetting3rd as scs with (NOLOCK) inner join
		(
						select 81 as bettype, 161 as sporttype, @v161spositiontaking_81 as spositiontaking, 0 as slivepositiontaking, @v161mpositiontaking_81 as mpositiontaking, 0 as mlivepositiontaking
			union all 	select 83 as bettype, 161 as sporttype, @v161spositiontaking_83 as spositiontaking, 0 as slivepositiontaking, @v161mpositiontaking_83 as mpositiontaking, 0 as mlivepositiontaking
			union all 	select 88 as bettype, 161 as sporttype, @v161spositiontaking_88 as spositiontaking, 0 as slivepositiontaking, @v161mpositiontaking_88 as mpositiontaking, 0 as mlivepositiontaking
			union all 	select 85 as bettype, 161 as sporttype, 0 as spositiontaking, @v161slivepositiontaking_85 as slivepositiontaking, 0 as mpositiontaking, @v161mlivepositiontaking_85 as mlivepositiontaking
			union all 	select 86 as bettype, 161 as sporttype, @v161spositiontaking_86 as spositiontaking, @v161slivepositiontaking_86 as slivepositiontaking, @v161mpositiontaking_86 as mpositiontaking, @v161mlivepositiontaking_86 as mlivepositiontaking
			union all 	select 87 as bettype, 161 as sporttype, 0 as spositiontaking, @v161slivepositiontaking_87 as slivepositiontaking, 0 as mpositiontaking, @v161mlivepositiontaking_87 as mlivepositiontaking
			union all 	select 89 as bettype, 161 as sporttype, 0 as spositiontaking, @v161slivepositiontaking_89 as slivepositiontaking, 0 as mpositiontaking, @v161mlivepositiontaking_89 as mlivepositiontaking
			union all 	select 90 as bettype, 161 as sporttype, 0 as spositiontaking, @v161slivepositiontaking_90 as slivepositiontaking, 0 as mpositiontaking, @v161mlivepositiontaking_90 as mlivepositiontaking
			
		) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
		inner join @tmp_Sports sports on b.sporttype = sports.sporttype
		inner join @tmp_Bettype bettype on b.bettype = bettype.typeid
	where scs.custid = @srecommend and 
						(
							(scs.mpositiontaking<b.mpositiontaking AND scs.islive = 0) or (b.sporttype=161 and scs.islive = 1 and b.bettype in (85,86,87,89) and scs.mpositiontaking<b.mpositiontaking)
						)
	if @ErrType <>''
	BEGIN
		select @ErrCode = 212
		Select @ErrMsg = 	@UserName + ': '+
					case @Language 
							when 'E' then 'Wrong position taking (max for master set by company).' + '<br>' + @ErrType
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20003,@Language) + '<br>' + @ErrType
					end
		return
	END

	--s3<=s4,s3+m3<=s4
	select @ErrType = ''
	select @ErrType = @ErrType + sportname + '-'+ typenamee + '-Max: '+ cast((cs.spositiontaking) as varchar(10)) + '<br>'
	from dep_custsetting as cs with (NOLOCK) inner join
		(
					select 1 as bettype, 2 as sporttype, @v2spositiontaking_1 as spositiontaking, 0 as livepositiontaking, @v2mpositiontaking_1 as mpositiontaking
			union all 	select 2 as bettype, 2 as sporttype, @v2spositiontaking_2 as spositiontaking, 0 as livepositiontaking, @v2mpositiontaking_2 as mpositiontaking
			union all 	select 3 as bettype, 2 as sporttype, @v2spositiontaking_3 as spositiontaking, 0 as livepositiontaking, @v2mpositiontaking_3 as mpositiontaking
			union all 	select 20 as bettype, 2 as sporttype, @v2spositiontaking_20 as spositiontaking, 0 as livepositiontaking, @v2mpositiontaking_20 as mpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype=b.bettype
		inner join @tmp_Sports sports on b.sporttype = sports.sporttype
		inner join @tmp_Bettype bettype on b.bettype = bettype.typeid
	where cs.custid = @srecommend and cs.islive = 0
		and 
		(
			(cs.spositiontaking<b.spositiontaking) or (cs.spositiontaking<b.spositiontaking+b.mpositiontaking)
		)
	if @ErrType <>''
	BEGIN
		Select @ErrMsg =	@UserName + ': '+
							case @Language 
								when 'E' then 'Wrong  position taking.<br>'+@ErrType
								ELSE [dbo].[f_Get_MsgNamebyMsgID](20001,@Language) + '<br>' + @ErrType
							end, @ErrCode = 104
		return
	END

	--s3<=s4,s3+m3<=s4
	select @ErrType = ''
	select @ErrType = @ErrType + sportname + '-'+ typenamee + '-Max: '+ cast((cs.spositiontaking) as varchar(10)) + '<br>'
	from dep_custsetting as cs with (NOLOCK) inner join
		(
					select 1 as bettype, 3 as sporttype, @v3spositiontaking_1 as spositiontaking, 0 as livepositiontaking, @v3mpositiontaking_1 as mpositiontaking
			union all 	select 2 as bettype, 3 as sporttype, @v3spositiontaking_2 as spositiontaking, 0 as livepositiontaking, @v3mpositiontaking_2 as mpositiontaking
			union all 	select 3 as bettype, 3 as sporttype, @v3spositiontaking_3 as spositiontaking, 0 as livepositiontaking, @v3mpositiontaking_3 as mpositiontaking
			union all 	select 20 as bettype, 3 as sporttype, @v3spositiontaking_20 as spositiontaking, 0 as livepositiontaking, @v3mpositiontaking_20 as mpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype=b.bettype
		inner join @tmp_Sports sports on b.sporttype = sports.sporttype
		inner join @tmp_Bettype bettype on b.bettype = bettype.typeid
	where cs.custid = @srecommend
		and 
		((cs.spositiontaking<b.spositiontaking) or (cs.spositiontaking<b.spositiontaking+b.mpositiontaking)
		)
	if @ErrType <>''
	BEGIN
		Select @ErrMsg =	@UserName + ': '+
							case @Language 
								when 'E' then 'Wrong  position taking.<br>'+@ErrType
								ELSE [dbo].[f_Get_MsgNamebyMsgID](20001,@Language) + '<br>' + @ErrType
							end, @ErrCode = 104
		return
	END

	--s3<=s4,s3+m3<=s4
	select @ErrType = ''
	select @ErrType = @ErrType + sportname + '-'+ typenamee + '-Max: '+ cast((cs.spositiontaking) as varchar(10))
	from dep_custsetting as cs with (NOLOCK) inner join
		(
					select 1 as bettype, 5 as sporttype, @v5spositiontaking_1 as spositiontaking, 0 as livepositiontaking, @v5mpositiontaking_1 as mpositiontaking
			union all 	select 2 as bettype, 5 as sporttype, @v5spositiontaking_2 as spositiontaking, 0 as livepositiontaking, @v5mpositiontaking_2 as mpositiontaking
			union all 	select 3 as bettype, 5 as sporttype, @v5spositiontaking_3 as spositiontaking, 0 as livepositiontaking, @v5mpositiontaking_3 as mpositiontaking
			union all 	select 20 as bettype, 5 as sporttype, @v5spositiontaking_20 as spositiontaking, 0 as livepositiontaking, @v5mpositiontaking_20 as mpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype=b.bettype
		inner join @tmp_Sports sports on b.sporttype = sports.sporttype
		inner join @tmp_Bettype bettype on b.bettype = bettype.typeid
	where cs.custid = @srecommend
		and 
		((cs.spositiontaking<b.spositiontaking) or (cs.spositiontaking<b.spositiontaking+b.mpositiontaking)
		)
	if @ErrType <>''
	BEGIN
		Select @ErrMsg =	@UserName + ': '+
							case @Language 
								when 'E' then 'Wrong  position taking.<br>'+@ErrType
								ELSE [dbo].[f_Get_MsgNamebyMsgID](20001,@Language) + '<br>' + @ErrType
							end, @ErrCode = 104
		return
	END

	--s3<=s4,s3+m3<=s4
	select @ErrType = ''
	select @ErrType = @ErrType + sportname + '-'+ typenamee + '-Max: '+ cast((cs.spositiontaking) as varchar(10))
	from dep_custsetting as cs with (NOLOCK) inner join
		(
					select 1 as bettype, 8 as sporttype, @v8spositiontaking_1 as spositiontaking, 0 as livepositiontaking, @v8mpositiontaking_1 as mpositiontaking
			union all 	select 3 as bettype, 8 as sporttype, @v8spositiontaking_3 as spositiontaking, 0 as livepositiontaking, @v8mpositiontaking_3 as mpositiontaking
			union all 	select 20 as bettype, 8 as sporttype, @v8spositiontaking_20 as spositiontaking, 0 as livepositiontaking, @v8mpositiontaking_20 as mpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype=b.bettype
		inner join @tmp_Sports sports on b.sporttype = sports.sporttype
		inner join @tmp_Bettype bettype on b.bettype = bettype.typeid
	where cs.custid = @srecommend
		and 
		((cs.spositiontaking<b.spositiontaking) or (cs.spositiontaking<b.spositiontaking+b.mpositiontaking)
		)
	if @ErrType <>''
	BEGIN
		Select @ErrMsg =	@UserName + ': '+
							case @Language 
								when 'E' then 'Wrong  position taking.<br>'+@ErrType
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20001,@Language) + '<br>' + @ErrType
							end, @ErrCode = 104
		return
	END

	--s3<=s4,s3+m3<=s4
	select @ErrType = ''
	select @ErrType = @ErrType + sportname + '-'+ typenamee + '-Max: '+ cast((cs.spositiontaking) as varchar(10))
	from dep_custsetting as cs with (NOLOCK) inner join
		(
					select 1 as bettype, 10 as sporttype, @v10spositiontaking_1 as spositiontaking, 0 as livepositiontaking, @v10mpositiontaking_1 as mpositiontaking
			union all 	select 2 as bettype, 10 as sporttype, @v10spositiontaking_2 as spositiontaking, 0 as livepositiontaking, @v10mpositiontaking_2 as mpositiontaking
			union all 	select 3 as bettype, 10 as sporttype, @v10spositiontaking_3 as spositiontaking, 0 as livepositiontaking, @v10mpositiontaking_3 as mpositiontaking
			union all 	select 20 as bettype, 10 as sporttype, @v10spositiontaking_20 as spositiontaking, 0 as livepositiontaking, @v10mpositiontaking_20 as mpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype=b.bettype
		inner join @tmp_Sports sports on b.sporttype = sports.sporttype
		inner join @tmp_Bettype bettype on b.bettype = bettype.typeid
	where cs.custid = @srecommend
		and 
		((cs.spositiontaking<b.spositiontaking) or (cs.spositiontaking<b.spositiontaking+b.mpositiontaking)
		)
	if @ErrType <>''
	BEGIN
		Select @ErrMsg =	@UserName + ': '+
							case @Language 
								when 'E' then 'Wrong  position taking.<br>'+@ErrType
								ELSE [dbo].[f_Get_MsgNamebyMsgID](20001,@Language) + '<br>' + @ErrType
							end, @ErrCode = 104
		return
	END

	--s3<=s4,s3+m3<=s4
	select @ErrType = ''
	select @ErrType = @ErrType + sportname + '-'+ typenamee + '-Max: '+ cast((cs.spositiontaking) as varchar(10))
	from custsetting as cs with (NOLOCK) inner join
		(
					select 1 as bettype, 11 as sporttype, @v11spositiontaking_1 as spositiontaking, 0 as livepositiontaking, @v11mpositiontaking_1 as mpositiontaking
			union all 	select 20 as bettype, 11 as sporttype, @v11spositiontaking_20 as spositiontaking, 0 as livepositiontaking, @v11mpositiontaking_20 as mpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype=b.bettype
		inner join @tmp_Sports sports on b.sporttype = sports.sporttype
		inner join @tmp_Bettype bettype on b.bettype = bettype.typeid
	where cs.custid = @srecommend
		and 
		((cs.spositiontaking<b.spositiontaking) or (cs.spositiontaking<b.spositiontaking+b.mpositiontaking)
		)
	if @ErrType <>''
	BEGIN
		Select @ErrMsg =	@UserName + ': '+
							case @Language 
								when 'E' then 'Wrong  position taking.<br>'+@ErrType
								ELSE [dbo].[f_Get_MsgNamebyMsgID](20001,@Language) + '<br>' + @ErrType
							end, @ErrCode = 104
		return
	END
	---v44
	--s3<=s4,s3+m3<=s4
	select @ErrType = ''
	select @ErrType = @ErrType + sportname + '-'+ typenamee + '-Max: '+ cast((cs.spositiontaking) as varchar(10))
	from custsetting as cs with (NOLOCK) inner join
		(
					select 3 as bettype, 44 as sporttype, @v44spositiontaking_3 as spositiontaking, 0 as livepositiontaking, @v44mpositiontaking_3 as mpositiontaking
			
		) as b on cs.sporttype=b.sporttype and cs.bettype=b.bettype
		inner join @tmp_Sports sports on b.sporttype = sports.sporttype
		inner join @tmp_Bettype bettype on b.bettype = bettype.typeid
	where cs.custid = @srecommend
		and 
		((cs.spositiontaking<b.spositiontaking) or (cs.spositiontaking<b.spositiontaking+b.mpositiontaking)
		)
	if @ErrType <>''
	BEGIN
		Select @ErrMsg =	@UserName + ': '+
							case @Language 
								when 'E' then 'Wrong  position taking.<br>'+@ErrType
								ELSE [dbo].[f_Get_MsgNamebyMsgID](20001,@Language) + '<br>' + @ErrType
							end, @ErrCode = 104
		return
	END
	--s3<=s4,s3+m3<=s4
	select @ErrType = ''
	select @ErrType = @ErrType + sportname + '-'+ typenamee + '-Max: '+ cast((cs.spositiontaking) as varchar(10)) + '<br>'
	from dep_custsetting as cs with (NOLOCK) inner join
		(
					select 1 as bettype, 99 as sporttype, @v99spositiontaking_1 as spositiontaking, 0 as livepositiontaking, @v99mpositiontaking_1 as mpositiontaking
			union all 	select 2 as bettype, 99 as sporttype, @v99spositiontaking_2 as spositiontaking, 0 as livepositiontaking, @v99mpositiontaking_2 as mpositiontaking
			union all 	select 3 as bettype, 99 as sporttype, @v99spositiontaking_3 as spositiontaking, 0 as livepositiontaking, @v99mpositiontaking_3 as mpositiontaking
			union all 	select 20 as bettype, 99 as sporttype, @v99spositiontaking_20 as spositiontaking, 0 as livepositiontaking, @v99mpositiontaking_20 as mpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype=b.bettype
		inner join @tmp_Sports sports on b.sporttype = sports.sporttype
		inner join @tmp_Bettype bettype on b.bettype = bettype.typeid
	where cs.custid = @srecommend
		and 
		((cs.spositiontaking<b.spositiontaking) or (cs.spositiontaking<b.spositiontaking+b.mpositiontaking)
		)
	if @ErrType <>''
	BEGIN
		Select @ErrMsg =	@UserName + ': '+
							case @Language 
								when 'E' then 'Wrong  position taking.<br>'+@ErrType
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20001,@Language) + '<br>' + @ErrType
							end, @ErrCode = 104
		return
	END
	--HRFO
	--s3<=s4,s3+m3<=s41
	select @ErrType = ''
	select @ErrType = @ErrType + sportname + '-'+ typenamee + '-Max: '+ cast((cs.spositiontaking) as varchar(10)) + '<br>'
	from dep_custsetting as cs with (NOLOCK) inner join
		(
			select 20 as bettype, 154 as sporttype, @v154spositiontaking_20 as spositiontaking, 0 as livepositiontaking, @v154mpositiontaking_20 as mpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype=b.bettype
		inner join @tmp_Sports sports on b.sporttype = sports.sporttype
		inner join @tmp_Bettype bettype on b.bettype = bettype.typeid
	where cs.custid = @srecommend
		and 
		((cs.spositiontaking<b.spositiontaking) or (cs.spositiontaking<b.spositiontaking+b.mpositiontaking)
		)
	if @ErrType <>''
	BEGIN
		Select @ErrMsg =	@UserName + ': '+
							case @Language 
								when 'E' then 'Wrong  position taking.<br>'+@ErrType
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20001,@Language) + '<br>' + @ErrType
							end, @ErrCode = 104
		return
	END

	--s3<=s4,s3+m3<=s4
	select @ErrType = ''
	select @ErrType = @ErrType + sportname + '-'+ typenamee + '-Max: '+ cast((cs.spositiontaking) as varchar(10))
	from dep_custsetting as cs with (NOLOCK) inner join
		(
			select 9 as bettype, 99 as sporttype, @v99spositiontaking_9 as spositiontaking, 0 as livepositiontaking, @v99mpositiontaking_9 as mpositiontaking	
		) as b on cs.sporttype=b.sporttype and cs.bettype=b.bettype
		inner join @tmp_Sports sports on b.sporttype = sports.sporttype
		inner join @tmp_Bettype bettype on b.bettype = bettype.typeid
	where cs.custid = @srecommend
		and 
		((cs.spositiontaking<b.spositiontaking) or (cs.spositiontaking<b.spositiontaking+b.mpositiontaking)
		)
	if @ErrType <>''
	BEGIN
		Select @ErrMsg =	@UserName + ': '+
							case @Language 
								when 'E' then 'Wrong  position taking.<br>'+@ErrType
								ELSE [dbo].[f_Get_MsgNamebyMsgID](20001,@Language) + '<br>' + @ErrType
							end, @ErrCode = 104
		return
	END

	--s3<=s4,s3+m3<=s4
	select @ErrType = ''
	select @ErrType = @ErrType + sportname + '-'+ typenamee + '-Max: '+ cast((cs.spositiontaking) as varchar(10))
	+ case when b.sporttype=161 and b.bettype in (85,86,87,89) then '-MaxLive: '+ cast((cs.spositiontaking) as varchar(10)) else '' end + '<br>'
	from dep_custsetting3rd as cs with (NOLOCK) inner join
		(
						select 81 as bettype, 161 as sporttype, @v161spositiontaking_81 as spositiontaking, 0 as slivepositiontaking, @v161mpositiontaking_81 as mpositiontaking, 0 as mlivepositiontaking
			union all	select 83 as bettype, 161 as sporttype, @v161spositiontaking_83 as spositiontaking, 0 as slivepositiontaking, @v161mpositiontaking_83 as mpositiontaking, 0 as mlivepositiontaking	
			union all	select 88 as bettype, 161 as sporttype, @v161spositiontaking_88 as spositiontaking, 0 as slivepositiontaking, @v161mpositiontaking_88 as mpositiontaking, 0 as mlivepositiontaking	
			union all	select 85 as bettype, 161 as sporttype, 0 as spositiontaking, @v161slivepositiontaking_85 as slivepositiontaking, 0 as mpositiontaking, @v161mlivepositiontaking_85 as mlivepositiontaking	
			union all	select 86 as bettype, 161 as sporttype, @v161spositiontaking_86 as spositiontaking, @v161slivepositiontaking_86 as slivepositiontaking, @v161mpositiontaking_86 as mpositiontaking, @v161mlivepositiontaking_86 as mlivepositiontaking	
			union all	select 87 as bettype, 161 as sporttype, 0 as spositiontaking, @v161slivepositiontaking_87 as slivepositiontaking, 0 as mpositiontaking, @v161mlivepositiontaking_87 as mlivepositiontaking	
			union all	select 89 as bettype, 161 as sporttype, 0 as spositiontaking, @v161slivepositiontaking_89 as slivepositiontaking, 0 as mpositiontaking, @v161mlivepositiontaking_89 as mlivepositiontaking	
			union all	select 90 as bettype, 161 as sporttype, 0 as spositiontaking, @v161slivepositiontaking_90 as slivepositiontaking, 0 as mpositiontaking, @v161mlivepositiontaking_90 as mlivepositiontaking	
		) as b on cs.sporttype=b.sporttype and cs.bettype=b.bettype
		inner join @tmp_Sports sports on b.sporttype = sports.sporttype
		inner join @tmp_Bettype bettype on b.bettype = bettype.typeid
	where cs.custid = @srecommend
		and 
		((cs.spositiontaking<b.spositiontaking AND cs.islive = 0) or (cs.spositiontaking<b.spositiontaking+b.mpositiontaking  AND cs.islive = 0)
			or (b.bettype in (85,86,87,89) AND cs.islive = 1 and b.sporttype=161 and cs.spositiontaking<b.spositiontaking)
		)  
	if @ErrType <>''
	BEGIN
		Select @ErrMsg =	@UserName + ': '+
							case @Language 
								when 'E' then 'Wrong  position taking.<br>'+@ErrType
								ELSE [dbo].[f_Get_MsgNamebyMsgID](20001,@Language) + '<br>' + @ErrType
							end, @ErrCode = 104
		return
	END

	/****************Horse Racing*******************/

	--m2+a2<=m3
	select @ErrAcc = ''
	select top 100 @ErrAcc = @ErrAcc + username +','
	from 
		custinfo as c with (NOLOCK) 
		inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
		inner join (
							select 	151 as sporttype, 31 as bettype, @v151mpositiontaking_31 as maxpositiontaking
				union all	select 	151 as sporttype, 32 as bettype, @v151mpositiontaking_32 as maxpositiontaking
				union all	select 	151 as sporttype, 41 as bettype, @v151mpositiontaking_41 as maxpositiontaking
				union all	select 	151 as sporttype, 42 as bettype, @v151mpositiontaking_42 as maxpositiontaking
				union all	select 	151 as sporttype, 51 as bettype, @v151mpositiontaking_51 as maxpositiontaking
				union all	select 	151 as sporttype, 52 as bettype, @v151mpositiontaking_52 as maxpositiontaking
				
			) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
	where c.mrecommend = @custid and c.roleid = 2 and (cs.apositiontaking + cs.mpositiontaking > b.maxpositiontaking)
	group by username
	if @ErrAcc<>''
	BEGIN
		select @ErrCode = 14
		Select @ErrMsg = @UserName + ': ' + 
					case @Language 
							when 'E' then 'Existing agents exceeded new master position taking ('+@ErrAcc+') (for Horse Racing).'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20011,@Language) + ' ('+@ErrAcc+') (' + [dbo].[f_Get_SportNameBySporttype](151,@Language) + ')'
					end
		return
	END

	--m1+a1<=m3
	select @ErrAcc = ''
	select top 100 @ErrAcc = @ErrAcc + username +', '
	from 
		custinfo as c with (NOLOCK) 
		inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
		inner join (
							select 	151 as sporttype, 31 as bettype, @v151mpositiontaking_31 as maxpositiontaking
				union all	select 	151 as sporttype, 32 as bettype, @v151mpositiontaking_32 as maxpositiontaking
				union all	select 	151 as sporttype, 41 as bettype, @v151mpositiontaking_41 as maxpositiontaking
				union all	select 	151 as sporttype, 42 as bettype, @v151mpositiontaking_42 as maxpositiontaking
				union all	select 	151 as sporttype, 51 as bettype, @v151mpositiontaking_51 as maxpositiontaking
				union all	select 	151 as sporttype, 52 as bettype, @v151mpositiontaking_52 as maxpositiontaking

			) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
	where c.mrecommend = @custid and c.roleid = 1 and (cs.apositiontaking+cs.mpositiontaking>b.maxpositiontaking )
	group by username
	if @ErrAcc<>''
	BEGIN
		select @ErrCode = 15
		Select @ErrMsg = @UserName + ': ' + 
					case @Language 
							when 'E' then 'Existing members exceeded new master position taking ('+@ErrAcc+') (for Horse Racing).'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20012,@Language) + ' ('+@ErrAcc+') (' + [dbo].[f_Get_SportNameBySporttype](151,@Language) + ')'
					end
		return
	END

	--check m3<=m4
	select @ErrType = ''
	select @ErrType = @ErrType + s.SportName +' - ' +
	case when b.bettype = 51 then 'Win.Aust Tote' when b.bettype = 52 then 'Place.Aust Tote' else typenamee end
	 + '-Max: '+ cast((scs.mpositiontaking) as varchar(10)) + '<br>'
	from Dep_CustSetting3rd as scs with (NOLOCK) inner join
		(
			 				select 31 as bettype, 151 as sporttype, @v151spositiontaking_31 as spositiontaking, @v151mpositiontaking_31 as mpositiontaking  
			union all	 	select 32 as bettype, 151 as sporttype, @v151spositiontaking_32 as spositiontaking, @v151mpositiontaking_32 as mpositiontaking
			union all	 	select 41 as bettype, 151 as sporttype, @v151spositiontaking_41 as spositiontaking, @v151mpositiontaking_41 as mpositiontaking
			union all	 	select 42 as bettype, 151 as sporttype, @v151spositiontaking_42 as spositiontaking, @v151mpositiontaking_42 as mpositiontaking
			union all	 	select 51 as bettype, 151 as sporttype, @v151spositiontaking_51 as spositiontaking, @v151mpositiontaking_51 as mpositiontaking
			union all	 	select 52 as bettype, 151 as sporttype, @v151spositiontaking_52 as spositiontaking, @v151mpositiontaking_52 as mpositiontaking
			
		) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
		inner join @tmp_Bettype bettype on b.bettype = bettype.typeid
		inner join @tmp_Sports s on b.sporttype = s.sporttype 
	where scs.custid = @srecommend and (
						scs.mpositiontaking<b.mpositiontaking 
						)
	if @ErrType <>''
	BEGIN
		select @ErrCode = 16
		Select @ErrMsg = @UserName + ': '+
					case @Language 
							when 'E' then 'Wrong position taking (max for master set by company).' + '<br>' + @ErrType
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20003,@Language) + '<br>' + @ErrType
					end
		return
	END

	--s3<=s4,s3+m3<=s4
	select @ErrType = ''
	select @ErrType = @ErrType + s.SportName + ' - ' + 
	case when b.bettype = 51 then 'Win.Aust Tote' when b.bettype = 52 then 'Place.Aust Tote' else typenamee end
	 + '-Max: '+ cast((cs.spositiontaking) as varchar(10))+ '<br>'
	from Dep_CustSetting3rd as cs with (NOLOCK) inner join
		(
							select 31 as bettype, 151 as sporttype, @v151spositiontaking_31 as spositiontaking, @v151mpositiontaking_31 as mpositiontaking
			union all		select 32 as bettype, 151 as sporttype, @v151spositiontaking_32 as spositiontaking, @v151mpositiontaking_32 as mpositiontaking
			union all		select 41 as bettype, 151 as sporttype, @v151spositiontaking_41 as spositiontaking, @v151mpositiontaking_41 as mpositiontaking
			union all		select 42 as bettype, 151 as sporttype, @v151spositiontaking_42 as spositiontaking, @v151mpositiontaking_42 as mpositiontaking
			union all		select 51 as bettype, 151 as sporttype, @v151spositiontaking_51 as spositiontaking, @v151mpositiontaking_51 as mpositiontaking
			union all		select 52 as bettype, 151 as sporttype, @v151spositiontaking_52 as spositiontaking, @v151mpositiontaking_52 as mpositiontaking
			
		) as b on cs.sporttype=b.sporttype and cs.bettype=b.bettype
		inner join @tmp_Bettype bettype on b.bettype = bettype.typeid
		inner join @tmp_Sports s on b.sporttype = s.sporttype
	where cs.custid = @srecommend
		and 
		((cs.spositiontaking<b.spositiontaking) or (cs.spositiontaking<b.spositiontaking+b.mpositiontaking)
		)
	if @ErrType <>''
	BEGIN
		Select @ErrMsg =	@UserName + ': '+
							case @Language 
								when 'E' then 'Wrong  position taking.<br>'+@ErrType
								ELSE [dbo].[f_Get_MsgNamebyMsgID](20001,@Language) + '<br>' + @ErrType
							end, @ErrCode = 224
		return
	END

	--m2+a2<=m3
	select @ErrAcc = ''
	select top 100 @ErrAcc = @ErrAcc + username +', '
	from 
		custinfo as c with (NOLOCK) 
		inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
		inner join (
							select 	152 as sporttype, 41 as bettype, @v152mpositiontaking_41 as maxpositiontaking
				union all	select 	152 as sporttype, 42 as bettype, @v152mpositiontaking_42 as maxpositiontaking
				union all	select 	152 as sporttype, 51 as bettype, @v152mpositiontaking_51 as maxpositiontaking
				union all	select 	152 as sporttype, 52 as bettype, @v152mpositiontaking_52 as maxpositiontaking
				
			) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
	where c.mrecommend = @custid and c.roleid = 2 and (cs.apositiontaking+cs.mpositiontaking>b.maxpositiontaking)
	group by username
	if @ErrAcc<>''
	BEGIN
		select @ErrCode = 14
		Select @ErrMsg = @UserName + ': ' + 
					case @Language 
							when 'E' then 'Existing agents exceeded new master position taking ('+@ErrAcc+') (for Greyhound).'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20011,@Language) + ' ('+@ErrAcc+') (' + [dbo].[f_Get_SportNameBySporttype](152,@Language) + ')'
					end
		return
	END

	--m1+a1<=m3
	select @ErrAcc = ''
	select top 100 @ErrAcc = @ErrAcc + username +', '
	from 
		custinfo as c with (NOLOCK) 
		inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
		inner join (
							select 	152 as sporttype, 41 as bettype, @v152mpositiontaking_41 as maxpositiontaking
				union all	select 	152 as sporttype, 42 as bettype, @v152mpositiontaking_42 as maxpositiontaking
				union all	select 	152 as sporttype, 51 as bettype, @v152mpositiontaking_51 as maxpositiontaking
				union all	select 	152 as sporttype, 52 as bettype, @v152mpositiontaking_52 as maxpositiontaking
			) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
	where c.mrecommend = @custid and c.roleid = 1 and (cs.apositiontaking+cs.mpositiontaking>b.maxpositiontaking )
	group by username
	if @ErrAcc<>''
	BEGIN
		select @ErrCode = 15
		Select @ErrMsg = @UserName + ': ' + 
					case @Language 
							when 'E' then 'Existing members exceeded new master position taking ('+@ErrAcc+') (for Greyhound).'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20012,@Language) + ' ('+@ErrAcc+') (' + [dbo].[f_Get_SportNameBySporttype](152,@Language) + ')'
					end
		return
	END

	--check m3<=m4
	select @ErrType = ''
	select @ErrType = @ErrType + s.SportName +' - ' +
	case when b.bettype = 51 then 'Win.Aust Tote' when b.bettype = 52 then 'Place.Aust Tote' else typenamee end
	 + '-Max: '+ cast((scs.mpositiontaking) as varchar(10)) + '<br>'
	from Dep_CustSetting3rd as scs with (NOLOCK) inner join
		(
			 				select 41 as bettype, 152 as sporttype, @v152spositiontaking_41 as spositiontaking, @v152mpositiontaking_41 as mpositiontaking
			union all	 	select 42 as bettype, 152 as sporttype, @v152spositiontaking_42 as spositiontaking, @v152mpositiontaking_42 as mpositiontaking
			union all	 	select 51 as bettype, 152 as sporttype, @v152spositiontaking_51 as spositiontaking, @v152mpositiontaking_51 as mpositiontaking
			union all	 	select 52 as bettype, 152 as sporttype, @v152spositiontaking_52 as spositiontaking, @v152mpositiontaking_52 as mpositiontaking
			
		) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
		inner join @tmp_Bettype bettype on b.bettype = bettype.typeid
		inner join @tmp_Sports s on b.sporttype = s.sporttype 
	where scs.custid = @srecommend and (
						scs.mpositiontaking<b.mpositiontaking 
						)
	if @ErrType <>''
	BEGIN
		select @ErrCode = 16
		Select @ErrMsg = @UserName + ': '+
					case @Language 
							when 'E' then 'Wrong position taking (max for master set by company).' + '<br>' + @ErrType
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20003,@Language) + '<br>' + @ErrType
					end
		return
	END

	--s3<=s4,s3+m3<=s4
	select @ErrType = ''
	select @ErrType = @ErrType + s.SportName + ' - ' + 
	case when b.bettype = 51 then 'Win.Aust Tote' when b.bettype = 52 then 'Place.Aust Tote' else typenamee end
	 + '-Max: '+ cast((cs.spositiontaking) as varchar(10))+ '<br>'
	from Dep_CustSetting3rd as cs with (NOLOCK) inner join
		(
							select 41 as bettype, 152 as sporttype, @v152spositiontaking_41 as spositiontaking, @v152mpositiontaking_41 as mpositiontaking
			union all		select 42 as bettype, 152 as sporttype, @v152spositiontaking_42 as spositiontaking, @v152mpositiontaking_42 as mpositiontaking
			union all		select 51 as bettype, 152 as sporttype, @v152spositiontaking_51 as spositiontaking, @v152mpositiontaking_51 as mpositiontaking
			union all		select 52 as bettype, 152 as sporttype, @v152spositiontaking_52 as spositiontaking, @v152mpositiontaking_52 as mpositiontaking
			
		) as b on cs.sporttype=b.sporttype and cs.bettype=b.bettype
		inner join @tmp_Bettype bettype on b.bettype = bettype.typeid
		inner join @tmp_Sports s on b.sporttype = s.sporttype
	where cs.custid = @srecommend
		and 
		((cs.spositiontaking<b.spositiontaking) or (cs.spositiontaking<b.spositiontaking+b.mpositiontaking)
		)
	if @ErrType <>''
	BEGIN
		Select @ErrMsg =	@UserName + ': '+
							case @Language 
								when 'E' then 'Wrong  position taking.<br>'+@ErrType
								ELSE [dbo].[f_Get_MsgNamebyMsgID](20001,@Language) + '<br>' + @ErrType
							end, @ErrCode = 224
		return
	END

	--m2+a2<=m3
	select @ErrAcc = ''
	select top 100 @ErrAcc = @ErrAcc + username +', '
	from 
		custinfo as c with (NOLOCK) 
		inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
		inner join (
							select 	153 as sporttype, 51 as bettype, @v153mpositiontaking_51 as maxpositiontaking
				union all	select 	153 as sporttype, 52 as bettype, @v153mpositiontaking_52 as maxpositiontaking
				
			) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
	where c.mrecommend = @custid and c.roleid = 2 and (cs.apositiontaking+cs.mpositiontaking>b.maxpositiontaking)
	group by username
	if @ErrAcc<>''
	BEGIN
		select @ErrCode = 14
		Select @ErrMsg = @UserName + ': ' + 
					case @Language 
							when 'E' then 'Existing agents exceeded new master position taking ('+@ErrAcc+') (for Harness).'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20011,@Language) + ' ('+@ErrAcc+') (' + [dbo].[f_Get_SportNameBySporttype](152,@Language) + ')'
					end
		return
	END

	--m1+a1<=m3
	select @ErrAcc = ''
	select top 100 @ErrAcc = @ErrAcc + username +', '
	from 
		custinfo as c with (NOLOCK) 
		inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
		inner join (
							select 	153 as sporttype, 51 as bettype, @v153mpositiontaking_51 as maxpositiontaking
				union all	select 	153 as sporttype, 52 as bettype, @v153mpositiontaking_52 as maxpositiontaking
			) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
	where c.mrecommend = @custid and c.roleid = 1 and (cs.apositiontaking+cs.mpositiontaking>b.maxpositiontaking )
	group by username
	if @ErrAcc<>''
	BEGIN
		select @ErrCode = 15
		Select @ErrMsg = @UserName + ': ' + 
					case @Language 
							when 'E' then 'Existing members exceeded new master position taking ('+@ErrAcc+') for Harness.'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20012,@Language) + ' ('+@ErrAcc+').'
					end
		return
	END

	--check m3<=m4
	select @ErrType = ''
	select @ErrType = @ErrType + s.SportName +' - ' +
	case when b.bettype = 51 then 'Win.Aust Tote' when b.bettype = 52 then 'Place.Aust Tote' else typenamee end
	 + '-Max: '+ cast((scs.mpositiontaking) as varchar(10)) + '<br>'
	from Dep_CustSetting3rd as scs with (NOLOCK) inner join
		(
			 				select 51 as bettype, 153 as sporttype, @v153spositiontaking_51 as spositiontaking, @v153mpositiontaking_51 as mpositiontaking
			union all	 	select 52 as bettype, 153 as sporttype, @v153spositiontaking_52 as spositiontaking, @v153mpositiontaking_52 as mpositiontaking
			
		) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
		inner join @tmp_Bettype bettype on b.bettype = bettype.typeid
		inner join @tmp_Sports s on b.sporttype = s.sporttype 
	where scs.custid = @srecommend and (
						scs.mpositiontaking<b.mpositiontaking 
						)
	if @ErrType <>''
	BEGIN
		select @ErrCode = 16
		Select @ErrMsg = @UserName + ': '+
					case @Language 
							when 'E' then 'Wrong position taking (max for master set by company).' + '<br>' + @ErrType
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20003,@Language) + '<br>' + @ErrType
					end
		return
	END

	--s3<=s4,s3+m3<=s4
	select @ErrType = ''
	select @ErrType = @ErrType + s.SportName + ' - ' + 
	case when b.bettype = 51 then 'Win.Aust Tote' when b.bettype = 52 then 'Place.Aust Tote' else typenamee end
	 + '-Max: '+ cast((cs.spositiontaking) as varchar(10))+ '<br>'
	from Dep_CustSetting3rd as cs with (NOLOCK) inner join
		(
							select 51 as bettype, 153 as sporttype, @v153spositiontaking_51 as spositiontaking, @v153mpositiontaking_51 as mpositiontaking
			union all		select 52 as bettype, 153 as sporttype, @v153spositiontaking_52 as spositiontaking, @v153mpositiontaking_52 as mpositiontaking
			
		) as b on cs.sporttype=b.sporttype and cs.bettype=b.bettype
		inner join @tmp_Bettype bettype on b.bettype = bettype.typeid
		inner join @tmp_Sports s on b.sporttype = s.sporttype
	where cs.custid = @srecommend
		and 
		((cs.spositiontaking<b.spositiontaking) or (cs.spositiontaking<b.spositiontaking+b.mpositiontaking)
		)
	if @ErrType <>''
	BEGIN
		Select @ErrMsg =	@UserName + ': '+
							case @Language 
								when 'E' then 'Wrong  position taking.<br>'+@ErrType
								ELSE [dbo].[f_Get_MsgNamebyMsgID](20001,@Language) + '<br>' + @ErrType
							end, @ErrCode = 224
		return
	END
/*************************************
Validate discount
**************************************/
IF (@v151discount_31 < 0 OR @v151discount_31 > 0.04)
BEGIN		
	SELECT @ErrMsg = 	CASE @Language 
						WHEN 'E' THEN 'Invalid commission rate (SA Tote).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](2,@Language)
				END, @ErrCode = 101
	RETURN
END

IF (@v151discount_41 < 0 OR @v151discount_41 > 0.04)
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


/*----------------------------
UPDATE Customer Info
---------------------------*/
update custinfo with (ROWLOCK, UPDLOCK)
set 	
	MaxPerMatch			= @MaxPerMatchv1,
	MaxPerMatch2		= @MaxPerMatchv2,
	MaxPerMatch3		= @MaxPerMatchv3,
	MaxPerMatch5		= @MaxPerMatchv5,
	MaxPerMatch8		= @MaxPerMatchv8,
	MaxPerMatch10		= @MaxPerMatchv10,
	MaxPerMatch11		= @MaxPerMatchv11,
	MaxPerMatch44		= @MaxPerMatchv44,
	MaxPerMatch99		= @MaxPerMatchv99,
	MaxPerMatch154		= @MaxPerMatchv154,
	MaxPerMatch99MP		= @MaxPerMatchv99MP,
	MaxPerMatch161		= @MaxPerMatchv161,
	MaxPerBall161       = @maxperballv161,
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

UPDATE Dep_CustSetting WITH (ROWLOCK, UPDLOCK)
SET
	MinBet = case sporttype when 1 then @MinBetv1 when 2 then @MinBetv2 when 3 then @MinBetv3 when 5 then @MinBetv5 when 8 then @MinBetv8 when 10 then @MinBetv10 when 11 then @MinBetv11 when 44 then @MinBetv44 when 99 then (case bettype when 9 then @MinBetv99MP else @MinBetv99 end)  when 154 then @MinBetv154 else MinBet end,
	MaxBet = case sporttype when 1 then @MaxBetv1 when 2 then @MaxBetv2 when 3 then @MaxBetv3 when 5 then @MaxBetv5 when 8 then @MaxBetv8 when 10 then @MaxBetv10 when 11 then @MaxBetv11 when 44 then @MaxBetv44  when 99 then (case bettype when 9 then @MaxBetv99MP else @MaxBetv99 end)  when 154 then @MaxBetv154 else MaxBet end,
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
					  END,--End Maser PT
	spositiontaking = CASE
						WHEN sporttype = 1 and bettype = 1 and islive = 0 THEN @v1spositiontaking_1
						WHEN sporttype = 1 and bettype = 2 and islive = 0 THEN @v1spositiontaking_2
						WHEN sporttype = 1 and bettype = 3 and islive = 0 THEN @v1spositiontaking_3
						WHEN sporttype = 1 and bettype = 4 and islive = 0 THEN @v1spositiontaking_4 
						WHEN sporttype = 1 and bettype = 5 and islive = 0 THEN @v1spositiontaking_5
						WHEN sporttype = 1 and bettype = 6 and islive = 0 THEN @v1spositiontaking_6
						WHEN sporttype = 1 and bettype = 7 and islive = 0 THEN @v1spositiontaking_7
						WHEN sporttype = 1 and bettype = 8 and islive = 0 THEN @v1spositiontaking_8
						WHEN sporttype = 1 and bettype = 9 and islive = 0 THEN @v1spositiontaking_9
						WHEN sporttype = 1 and bettype = 10 and islive = 0 THEN @v1spositiontaking_10

						WHEN sporttype = 1 and bettype = 1 and islive = 1 THEN @v1spositiontaking_1
						WHEN sporttype = 1 and bettype = 3 and islive = 1 THEN @v1spositiontaking_3
						WHEN sporttype = 1 and bettype = 7 and islive = 1 THEN @v1spositiontaking_7
						WHEN sporttype = 1 and bettype = 8 and islive = 1 THEN @v1spositiontaking_8

						WHEN sporttype = 2 and bettype = 1 THEN @v2spositiontaking_1 
						WHEN sporttype = 2 and bettype = 2 THEN @v2spositiontaking_2 
						WHEN sporttype = 2 and bettype = 3 THEN @v2spositiontaking_3 
						WHEN sporttype = 2 and bettype = 7 THEN @v2spositiontaking_7 
						WHEN sporttype = 2 and bettype = 8 THEN @v2spositiontaking_8 
						WHEN sporttype = 2 and bettype = 20 THEN @v2spositiontaking_20

						WHEN sporttype = 3 and bettype = 1 THEN @v3spositiontaking_1 
						WHEN sporttype = 3 and bettype = 2 THEN @v3spositiontaking_2 
						WHEN sporttype = 3 and bettype = 3 THEN @v3spositiontaking_3 
						WHEN sporttype = 3 and bettype = 20 THEN @v3spositiontaking_20

						WHEN sporttype = 5 and bettype = 1 THEN @v5spositiontaking_1 
						WHEN sporttype = 5 and bettype = 2 THEN @v5spositiontaking_2 
						WHEN sporttype = 5 and bettype = 3 THEN @v5spositiontaking_3 
						WHEN sporttype = 5 and bettype = 20 THEN @v5spositiontaking_20

						WHEN sporttype = 8 and bettype = 1 THEN @v8spositiontaking_1 
						WHEN sporttype = 8 and bettype = 3 THEN @v8spositiontaking_3 
						WHEN sporttype = 8 and bettype = 20 THEN @v8spositiontaking_20

						WHEN sporttype = 10 and bettype = 1 THEN @v10spositiontaking_1 
						WHEN sporttype = 10 and bettype = 2 THEN @v10spositiontaking_2 
						WHEN sporttype = 10 and bettype = 3 THEN @v10spositiontaking_3 
						WHEN sporttype = 10 and bettype = 20 THEN @v10spositiontaking_20

						WHEN sporttype = 11 and bettype = 1 THEN @v11spositiontaking_1 
						WHEN sporttype = 11 and bettype = 20 THEN @v11spositiontaking_20
						
						WHEN sporttype = 44 and bettype = 3 THEN @v44spositiontaking_3 
						
						WHEN sporttype = 99 and bettype = 1 THEN @v99spositiontaking_1 
						WHEN sporttype = 99 and bettype = 2 THEN @v99spositiontaking_2 
						WHEN sporttype = 99 and bettype = 3 THEN @v99spositiontaking_3 
						WHEN sporttype = 99 and bettype = 9 THEN @v99spositiontaking_9 
						WHEN sporttype = 99 and bettype = 20 THEN @v99spositiontaking_20
						WHEN sporttype = 154 and bettype = 20 THEN @v154spositiontaking_20

					  ELSE
						spositiontaking
					  END--End Super PT
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
	spositiontaking = CASE 
						WHEN  sporttype = 151 AND (bettype = 31 OR bettype = 32) THEN @v151spositiontaking_31 
						WHEN  sporttype = 151 AND (bettype = 41 OR bettype = 42) THEN @v151spositiontaking_41 
						WHEN  sporttype = 151 AND (bettype = 51 OR bettype = 52) THEN @v151spositiontaking_51 
						WHEN  sporttype = 152 AND (bettype = 41 OR bettype = 42) THEN @v152spositiontaking_41 
						WHEN  sporttype = 152 AND (bettype = 51 OR bettype = 52) THEN @v152spositiontaking_51 
						WHEN  sporttype = 153 AND (bettype = 51 OR bettype = 52) THEN @v153spositiontaking_51 

						WHEN sporttype = 161 and bettype = 81 and islive = 0 THEN @v161spositiontaking_81 
						WHEN sporttype = 161 and bettype = 83 and islive = 0 THEN @v161spositiontaking_83 
						WHEN sporttype = 161 and bettype = 86 and islive = 0 THEN @v161spositiontaking_86 
						WHEN sporttype = 161 and bettype = 88 and islive = 0 THEN @v161spositiontaking_88 
						WHEN sporttype = 161 and bettype = 85 and islive = 1 THEN @v161slivepositiontaking_85 
						WHEN sporttype = 161 and bettype = 86 and islive = 1 THEN @v161slivepositiontaking_86 
						WHEN sporttype = 161 and bettype = 87 and islive = 1 THEN @v161slivepositiontaking_87 
						WHEN sporttype = 161 and bettype = 89 and islive = 1 THEN @v161slivepositiontaking_89 
						WHEN sporttype = 161 and bettype = 90 and islive = 1 THEN @v161slivepositiontaking_90 
					ELSE
						spositiontaking
					END
where 
	custid=@custid

if (@@error <> 0)
begin
	
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end	, @ErrCode = 104 
	return
end

--------------------Update Commision-----------------------------



--Get g3=g4 if g3>g4
SELECT @v151discount_31 = CASE WHEN @v151discount_31 >sdiscount THEN sdiscount ELSE @v151discount_31 END
FROM Dep_CustSetting3rd AS cs WITH (NOLOCK) 
WHERE custid = @srecommend AND bettype=31 AND sporttype = 151
--Update @Master: g3, m3
UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK)
SET    adiscount = @v151discount_31
WHERE custid=@custid AND bettype IN(31,32) AND sporttype = 151
IF (@@ERROR <> 0)
BEGIN
		
	SELECT @ErrMsg = @UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					END	, @ErrCode = 102
	RETURN
END
---------------------------------------
--Update g2 = g3 if g2>g3 at agent
UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK) 
SET    discount = @v151discount_31 
FROM Dep_CustSetting3rd AS cs
INNER JOIN custinfo AS ci WITH (NOLOCK) ON cs.custid = ci.custid
WHERE ci.mrecommend = @custid AND ci.roleid = 2 AND cs.bettype IN(31,32) AND cs.sporttype = 151 AND discount> @v151discount_31
IF (@@ERROR <> 0)
BEGIN
			
	SELECT @ErrMsg = @UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					END, @ErrCode = 103					 
			
	RETURN
END

---------------------------------------
--Update g3 @ member level
UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK) 
SET adiscount = @v151discount_31
FROM Dep_CustSetting3rd AS cs
INNER JOIN custinfo AS c WITH (NOLOCK) ON cs.custid = c.custid
WHERE c.mrecommend = @custid 	
	AND c.recommend <> 52466
	AND c.roleid = 1 
	AND cs.bettype IN(31,32) 
	AND cs.sporttype = 151
IF (@@ERROR <> 0)
BEGIN
			
	SELECT @ErrMsg = @UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					END, @ErrCode = 105	
			
	RETURN
END

--Get m3=s4 if m3>s4
SELECT @v151discount_41 = CASE WHEN @v151discount_41 > sdiscount THEN sdiscount ELSE @v151discount_41 END 
FROM Dep_CustSetting3rd AS cs WITH (NOLOCK) 
WHERE custid = @srecommend AND bettype = 41 AND sporttype = 151 
		
--Update @Master: g3, m3
UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK)
SET    adiscount = @v151discount_41 
WHERE custid=@custid AND bettype IN(41,42) AND sporttype = 151 
IF (@@ERROR <> 0)
BEGIN
			
	SELECT @ErrMsg = @UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					END	, @ErrCode = 109
	RETURN
END
---------------------------------------
--Update a2 = m3 if a2>m3 at agent
UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK) 
SET    discount = @v151discount_41
FROM Dep_CustSetting3rd AS cs
INNER JOIN custinfo AS ci WITH (NOLOCK) ON cs.custid = ci.custid
WHERE ci.mrecommend = @custid AND ci.roleid = 2 AND cs.bettype IN(41,42) AND cs.sporttype = 151 AND discount>@v151discount_41
IF (@@ERROR <> 0)
BEGIN
			
	SELECT @ErrMsg = @UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					END, @ErrCode = 104				 
			
	RETURN
END
		
		
		
---------------------------------------
--Update m3 @ member level
UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK) 
SET    adiscount = @v151discount_41
FROM Dep_CustSetting3rd AS cs
INNER JOIN custinfo AS c WITH (NOLOCK) ON cs.custid = c.custid
WHERE c.mrecommend = @custid 
	AND c.recommend <> 52466
	AND c.roleid = 1 
	AND cs.bettype IN(41,42) 
	AND cs.sporttype = 151
IF (@@ERROR <> 0)
BEGIN
			
	SELECT @ErrMsg = @UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					END	, @ErrCode = 106
	RETURN
END

--Get m3=s4 if m3>s4
SELECT @v151discount_51 = CASE WHEN @v151discount_51 > sdiscount THEN sdiscount ELSE @v151discount_51 END 
FROM Dep_CustSetting3rd AS cs WITH (NOLOCK) 
WHERE custid = @srecommend AND bettype = 51 AND sporttype = 151 
		
--Update @Master: g3, m3
UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK)
SET    adiscount = @v151discount_51 
WHERE custid=@custid AND bettype IN(51,52) AND sporttype = 151 
IF (@@ERROR <> 0)
BEGIN
			
	SELECT @ErrMsg = @UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					END	, @ErrCode = 109
	RETURN
END
---------------------------------------
--Update a2 = m3 if a2>m3 at agent
UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK) 
SET    discount = @v151discount_51
FROM Dep_CustSetting3rd AS cs
INNER JOIN custinfo AS ci WITH (NOLOCK) ON cs.custid = ci.custid
WHERE ci.mrecommend = @custid AND ci.roleid = 2 AND cs.bettype IN(51,52) AND cs.sporttype = 151 AND discount>@v151discount_51
IF (@@ERROR <> 0)
BEGIN
			
	SELECT @ErrMsg = @UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					END, @ErrCode = 104				 
			
	RETURN
END
		
		
		
---------------------------------------
--Update m3 @ member level
UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK) 
SET    adiscount = @v151discount_51
FROM Dep_CustSetting3rd AS cs
INNER JOIN custinfo AS c WITH (NOLOCK) ON cs.custid = c.custid
WHERE c.mrecommend = @custid 
	AND c.recommend <> 52466
	AND c.roleid = 1 
	AND cs.bettype IN(51,52) 
	AND cs.sporttype = 151
IF (@@ERROR <> 0)
BEGIN
			
	SELECT @ErrMsg = @UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					END	, @ErrCode = 106
	RETURN
END

--Get m3=s4 if m3>s4
SELECT @v152discount_41 = CASE WHEN @v152discount_41 > sdiscount THEN sdiscount ELSE @v152discount_41 END 
FROM Dep_CustSetting3rd AS cs WITH (NOLOCK) 
WHERE custid = @srecommend AND bettype = 41 AND sporttype = 152 
		
--Update @Master: g3, m3
UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK)
SET    adiscount = @v152discount_41 
WHERE custid=@custid AND bettype IN(41,42) AND sporttype = 152 
IF (@@ERROR <> 0)
BEGIN
			
	SELECT @ErrMsg = @UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					END	, @ErrCode = 109
	RETURN
END
---------------------------------------
--Update a2 = m3 if a2>m3 at agent
UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK) 
SET    discount = @v152discount_41
FROM Dep_CustSetting3rd AS cs
INNER JOIN custinfo AS ci WITH (NOLOCK) ON cs.custid = ci.custid
WHERE ci.mrecommend = @custid AND ci.roleid = 2 AND cs.bettype IN(41,42) AND cs.sporttype = 152 AND discount>@v152discount_41
IF (@@ERROR <> 0)
BEGIN
			
	SELECT @ErrMsg = @UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					END, @ErrCode = 104				 
			
	RETURN
END
		
		
		
---------------------------------------
--Update m3 @ member level
UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK) 
SET    adiscount = @v152discount_41
FROM Dep_CustSetting3rd AS cs
INNER JOIN custinfo AS c WITH (NOLOCK) ON cs.custid = c.custid
WHERE c.mrecommend = @custid 
	AND c.recommend <> 52466
	AND c.roleid = 1 
	AND cs.bettype IN(41,42) 
	AND cs.sporttype = 152
IF (@@ERROR <> 0)
BEGIN
			
	SELECT @ErrMsg = @UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					END	, @ErrCode = 106
	RETURN
END

--Get m3=s4 if m3>s4
SELECT @v152discount_51 = CASE WHEN @v152discount_51 > sdiscount THEN sdiscount ELSE @v152discount_51 END 
FROM Dep_CustSetting3rd AS cs WITH (NOLOCK) 
WHERE custid = @srecommend AND bettype = 51 AND sporttype = 152 
		
--Update @Master: g3, m3
UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK)
SET    adiscount = @v152discount_51 
WHERE custid=@custid AND bettype IN(51,52) AND sporttype = 152 
IF (@@ERROR <> 0)
BEGIN
			
	SELECT @ErrMsg = @UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					END	, @ErrCode = 109
	RETURN
END
---------------------------------------
--Update a2 = m3 if a2>m3 at agent
UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK) 
SET    discount = @v152discount_51
FROM Dep_CustSetting3rd AS cs
INNER JOIN custinfo AS ci WITH (NOLOCK) ON cs.custid = ci.custid
WHERE ci.mrecommend = @custid AND ci.roleid = 2 AND cs.bettype IN(51,52) AND cs.sporttype = 152 AND discount>@v152discount_51
IF (@@ERROR <> 0)
BEGIN
			
	SELECT @ErrMsg = @UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					END, @ErrCode = 104				 
			
	RETURN
END
		
		
		
---------------------------------------
--Update m3 @ member level
UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK) 
SET    adiscount = @v152discount_51
FROM Dep_CustSetting3rd AS cs
INNER JOIN custinfo AS c WITH (NOLOCK) ON cs.custid = c.custid
WHERE c.mrecommend = @custid 
	AND c.recommend <> 52466
	AND c.roleid = 1 
	AND cs.bettype IN(51,52) 
	AND cs.sporttype = 152
IF (@@ERROR <> 0)
BEGIN
			
	SELECT @ErrMsg = @UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					END	, @ErrCode = 106
	RETURN
END

--Get m3=s4 if m3>s4
SELECT @v153discount_51 = CASE WHEN @v153discount_51 > sdiscount THEN sdiscount ELSE @v153discount_51 END 
FROM Dep_CustSetting3rd AS cs WITH (NOLOCK) 
WHERE custid = @srecommend AND bettype = 51 AND sporttype = 153 
		
--Update @Master: g3, m3
UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK)
SET    adiscount = @v153discount_51 
WHERE custid=@custid AND bettype IN(51,52) AND sporttype = 153 
IF (@@ERROR <> 0)
BEGIN
			
	SELECT @ErrMsg = @UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					END	, @ErrCode = 109
	RETURN
END
---------------------------------------
--Update a2 = m3 if a2>m3 at agent
UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK) 
SET    discount = @v153discount_51
FROM Dep_CustSetting3rd AS cs
INNER JOIN custinfo AS ci WITH (NOLOCK) ON cs.custid = ci.custid
WHERE ci.mrecommend = @custid AND ci.roleid = 2 AND cs.bettype IN(51,52) AND cs.sporttype = 153 AND discount>@v153discount_51
IF (@@ERROR <> 0)
BEGIN
			
	SELECT @ErrMsg = @UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					END, @ErrCode = 104				 
			
	RETURN
END
		
		
		
---------------------------------------
--Update m3 @ member level
UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK) 
SET    adiscount = @v153discount_51
FROM Dep_CustSetting3rd AS cs
INNER JOIN custinfo AS c WITH (NOLOCK) ON cs.custid = c.custid
WHERE c.mrecommend = @custid 
	AND c.recommend <> 52466
	AND c.roleid = 1 
	AND cs.bettype IN(51,52) 
	AND cs.sporttype = 153
IF (@@ERROR <> 0)
BEGIN
			
	SELECT @ErrMsg = @UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					END	, @ErrCode = 106
	RETURN
END

-- Member level
UPDATE cs 
	SET cs.discount =  cs.adiscount
FROM Dep_CustSetting3rd AS cs WITH (ROWLOCK, UPDLOCK)
INNER JOIN custinfo AS c WITH (NOLOCK) ON cs.custid = c.custid
WHERE c.mrecommend = @custid AND c.roleid = 1 AND cs.discount > cs.adiscount AND sporttype in (151,152,153)

-- At member level, leave the playerdiscount the value as it is
/*
UPDATE cs 
	SET cs.playerdiscount =  cs.discount
FROM Dep_CustSetting3rd AS cs WITH (ROWLOCK, UPDLOCK)
INNER JOIN custinfo AS c WITH (NOLOCK) ON cs.custid = c.custid
WHERE c.mrecommend = @custid AND c.roleid = 1 AND cs.playerdiscount > cs.discount AND sporttype in (151,152,153)
*/

EXEC Acc_Dep_CustomerUpdMemberVirtualSports_SAg
	@UserID = @UserID,
	
	@CustId = @custid,

	@v180MinBet =@v180MinBet,
	@v180MaxBet =@v180MaxBet,
	@v180MaxPerMatch =@v180MaxPerMatch,
	@v180sPositionTaking =@v180sPositionTaking,
	@v180mPositionTaking =@v180mPositionTaking,
	
	@v181MinBet =@v181MinBet,
	@v181MaxBet =@v181MaxBet,
	@v181MaxPerMatch =@v181MaxPerMatch,
	@v181sPositionTaking =@v181sPositionTaking,
	@v181mPositionTaking =@v181mPositionTaking,

	@v182MinBet =@v182MinBet,
	@v182MaxBet =@v182MaxBet,
	@v182MaxPerMatch =@v182MaxPerMatch,
	@v182sPositionTaking =@v182sPositionTaking,
	@v182mPositionTaking =@v182mPositionTaking,

	@v183MinBet =@v183MinBet,
	@v183MaxBet =@v183MaxBet,
	@v183MaxPerMatch =@v183MaxPerMatch,
	@v183sPositionTaking =@v183sPositionTaking,
	@v183mPositionTaking =@v183mPositionTaking,

	@v184MinBet =@v184MinBet,
	@v184MaxBet =@v184MaxBet,
	@v184MaxPerMatch =@v184MaxPerMatch,
	@v184sPositionTaking =@v184sPositionTaking,
	@v184mPositionTaking =@v184mPositionTaking,

	@v185MinBet =@v185MinBet,
	@v185MaxBet =@v185MaxBet,
	@v185MaxPerMatch =@v185MaxPerMatch,
	@v185sPositionTaking =@v185sPositionTaking,
	@v185mPositionTaking =@v185mPositionTaking,

	@v186MinBet =@v186MinBet,
	@v186MaxBet =@v186MaxBet,
	@v186MaxPerMatch =@v186MaxPerMatch,
	@v186sPositionTaking =@v186sPositionTaking,
	@v186mPositionTaking =@v186mPositionTaking,

	@Language = @Language,
	@ErrCode = @ErrCode OUTPUT,
	@ErrMsg = @ErrMsg OUTPUT

--IF @ErrCode <> 0 
--BEGIN	
--	RETURN
--END


--Keno
--Check PT
DECLARE @vMaxPT_1501 money

SELECT @vMaxPT_1501=isnull(spositiontaking,0) 
FROM dbo.CustSettingGame WITH(NOLOCK) 
WHERE CustID= @srecommend and Bettype=1501

SELECT IBCBetTypeID AS Bettype,
	   ISNULL(cg.MinBet,0) AS MinBet_Up,
	   ISNULL(cg.MaxBet,0) AS Maxbet_Up ,
	   ISNULL(cg.MaxPerGameType,0) AS MaxPerMatch_UP
INTO #Data_Upline
FROM dbo.CustGameType cg WITH (NOLOCK)  INNER JOIN 
@tmp_GameType gt on cg.GameTypeID=gt.GameTypeID
and cg.CustID=@srecommend 

--check PT
IF EXISTS (SELECT top 1 1 FROM #data WHERE mPositionTaking > @vMaxPT_1501 and mPositionTaking > 0)
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
			WHERE ((d.MinBet > d.MaxBet) OR (d.MinBet < d2.MinBet_Up)) and d.MinBet >0)
BEGIN
	SELECT @Bet = d2.MinBet_Up FROM #data d INNER JOIN #data_Upline d2 ON d.Bettype=d2.Bettype
			WHERE (d.MinBet > d.MaxBet) OR (d.MinBet < d2.MinBet_Up)
			ORDER BY d.Bettype DESC
	SELECT @ErrMsg = case @Language 
							when 'E' then 'Min Bet must be greater than or equal '+coalesce(cast(@Bet as varchar(50)),space(1))+'.<br>'
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
			WHERE (d.MaxPerMatch > d2.MaxPerMatch_UP) and d.MaxPerMatch >0)
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
	c.mpositiontaking=d.mPositionTaking
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
Declare @LogSPData varchar(MAX)
Declare @LogSPData2 varchar(MAX)

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
		   @str_spt=@str_spt + 'v202spt_' +CAST(Bettype AS VARCHAR(50))+'="'+CAST(CONVERT(smallmoney,0) AS VARCHAR(50))+'" ',
		   @str_mpt=@str_mpt + 'v202mpt_' +CAST(Bettype AS VARCHAR(50))+'="'+CAST(mPositionTaking AS VARCHAR(50))+'" ',
		   @str_apt=@str_apt + 'v202apt_' +CAST(Bettype AS VARCHAR(50))+'="'+CAST(aPositionTaking AS VARCHAR(50))+'" '
	from #data where Bettype=@i
	set @i=@i+1
END
Select @LogSPData ='<Acc_Dep_CustomerUpdMember_SAg>' +
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
'/>'+
'<VirtualSports '+
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
'</Acc_Dep_CustomerUpdMember_SAg>'

BEGIN
	DECLARE @sql varchar (MAX)
	DECLARE @TEXT varchar (4000) =''
	SELECT @sql='<Acc_Dep_CustomerUpdMember_SAg> ' +
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
	select @sql = @sql + '</Acc_Dep_CustomerUpdMember_SAg>'

	SET @LogSPData2=@sql
END

EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP 
	@UserID = @UserID,
	@CustID = @CustID,
	@ActionID = 2019,
	@TrackingValue = @LogSPData,
	@TrackingValue2 = @LogSPData2,
	@duration = @duration

--Write PT log
SELECT @LogSPData = '<Acc_Dep_CustomerUpdMember_SAg><info custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +
'UserID="'+ coalesce(cast(@UserID as varchar(50)),space(1)) + '" ' +
'Language="'+ coalesce(cast(@Language as varchar(2)),space(1)) + '" ' +
'IP="'+ coalesce(cast(@IP as varchar(15)),space(1)) + '" ' +
'ErrCode="'+ coalesce(cast(@ErrCode as varchar(50)),space(1)) + '" ' +
'ErrMsg="'+ coalesce(cast(@ErrMsg as varchar(5000)),space(1)) + '" />' +

'<s spt_1="'+ COALESCE(CAST(@v1spositiontaking_1 AS VARCHAR(50)),SPACE(1)) + '" ' +
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
'v154spt_20="'+ COALESCE(CAST(@v154spositiontaking_20 AS VARCHAR(50)),SPACE(1)) + '" ' +

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
'v180spt="'+ COALESCE(CAST(convert(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +
'v181spt="'+ COALESCE(CAST(convert(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +
'v182spt="'+ COALESCE(CAST(convert(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +
'v183spt="'+ COALESCE(CAST(convert(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +
'v184spt="'+ COALESCE(CAST(convert(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +
'v185spt="'+ COALESCE(CAST(convert(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +
'v186spt="'+ COALESCE(CAST(convert(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + 
'" />' +


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
'v161mlivept_90="'+ COALESCE(CONVERT(VARCHAR(50),@v161mlivepositiontaking_90,2),SPACE(1)) + '" '+
@str_mpt+
'v180mpt="'+ COALESCE(CAST(@v180mPositionTaking AS VARCHAR(50)),SPACE(1)) + '" '+
'v181mpt="'+ COALESCE(CAST(@v181mPositionTaking AS VARCHAR(50)),SPACE(1)) + '" '+
'v182mpt="'+ COALESCE(CAST(@v182mPositionTaking AS VARCHAR(50)),SPACE(1)) + '" '+
'v183mpt="'+ COALESCE(CAST(@v183mPositionTaking AS VARCHAR(50)),SPACE(1)) + '" '+
'v184mpt="'+ COALESCE(CAST(@v184mPositionTaking AS VARCHAR(50)),SPACE(1)) + '" '+
'v185mpt="'+ COALESCE(CAST(@v185mPositionTaking AS VARCHAR(50)),SPACE(1)) + '" '+
'v186mpt="'+ COALESCE(CAST(@v186mPositionTaking AS VARCHAR(50)),SPACE(1)) + '" />'+
'</Acc_Dep_CustomerUpdMember_SAg>' 

--tracking value old
DECLARE @pt_SB smallMoney,@pt_NG smallmoney,@pt_VS smallmoney,@pt_KN smallmoney,
		@spt_SB smallMoney =0 ,@spt_NG smallmoney = 0,@spt_VS smallmoney= 0,@spt_KN smallmoney=0
select top 1 @pt_SB=mpt FROM #data_old where Sporttype=1 AND Bettype =1 and islive =0
select top 1 @pt_NG=mpt FROM #data_old where Sporttype=161 AND Bettype =81 and islive =0
select top 1 @pt_VS=mpt FROM #data_old where Sporttype=180 AND  islive =0
select top 1 @pt_KN=mpt FROM #data_old where Sporttype=202 AND Bettype =1501 and islive =0
--write log keno
DECLARE @str_spt_ varchar(1000)='',
		@str_mpt_ varchar(1000)='',
		@str_apt_ varchar(1000)=''
set @i =1501
WHILE (@i<=@j)
BEGIN
	select @str_spt_=@str_spt_ + 'v202spt_' +CAST(Bettype AS VARCHAR(50))+'="'+CAST(@spt_KN AS VARCHAR(50))+'" ',
		   @str_mpt_=@str_mpt_ + 'v202mpt_' +CAST(Bettype AS VARCHAR(50))+'="'+CAST(@pt_KN AS VARCHAR(50))+'" ',
		   @str_apt_=@str_apt_ + 'v202apt_' +CAST(Bettype AS VARCHAR(50))+'="'+CAST(@pt_KN AS VARCHAR(50))+'" '
	from #data where Bettype=@i
	set @i=@i+1
END
SELECT @LogSPData2 = '<Acc_Dep_CustomerUpdMember_SAg><info custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +
'UserID="'+ coalesce(cast(@UserID as varchar(50)),space(1)) + '" ' +
'Language="'+ coalesce(cast(@Language as varchar(2)),space(1)) + '" ' +
'IP="'+ coalesce(cast(@IP as varchar(15)),space(1)) + '" ' +
'ErrCode="'+ coalesce(cast(@ErrCode as varchar(50)),space(1)) + '" ' +
'ErrMsg="'+ coalesce(cast(@ErrMsg as varchar(5000)),space(1)) + '" />' +

'<s spt_1="'+ COALESCE(CAST(@v1spositiontaking_1 AS VARCHAR(50)),SPACE(1)) + '" ' +
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
'v154spt_20="'+ COALESCE(CAST(@v154spositiontaking_20 AS VARCHAR(50)),SPACE(1)) + '" ' +

'v161spt_81="'+ COALESCE(CONVERT(VARCHAR(50),@v161spositiontaking_81,2),SPACE(1)) + '" ' +
'v161spt_83="'+ COALESCE(CONVERT(VARCHAR(50),@v161spositiontaking_83,2),SPACE(1)) + '" ' +
'v161spt_86="'+ COALESCE(CONVERT(VARCHAR(50),@v161spositiontaking_86,2),SPACE(1)) + '" ' +
'v161spt_88="'+ COALESCE(CONVERT(VARCHAR(50),@v161spositiontaking_88,2),SPACE(1)) + '" ' +
'v161slivept_85="'+ COALESCE(CONVERT(VARCHAR(50),@v161slivepositiontaking_85,2),SPACE(1)) + '" ' +
'v161slivept_86="'+ COALESCE(CONVERT(VARCHAR(50),@v161slivepositiontaking_86,2),SPACE(1)) + '" ' +
'v161slivept_87="'+ COALESCE(CONVERT(VARCHAR(50),@v161slivepositiontaking_87,2),SPACE(1)) + '" ' +
'v161slivept_89="'+ COALESCE(CONVERT(VARCHAR(50),@v161slivepositiontaking_89,2),SPACE(1)) + '" ' +
'v161slivept_90="'+ COALESCE(CONVERT(VARCHAR(50),@v161slivepositiontaking_90,2),SPACE(1)) + '" ' +
@str_spt_+
'v180spt="'+ COALESCE(CAST(@spt_VS AS VARCHAR(50)),SPACE(1)) + '" ' +
'v181spt="'+ COALESCE(CAST(@spt_VS AS VARCHAR(50)),SPACE(1)) + '" ' +
'v182spt="'+ COALESCE(CAST(@spt_VS AS VARCHAR(50)),SPACE(1)) + '" ' +
'v183spt="'+ COALESCE(CAST(@spt_VS AS VARCHAR(50)),SPACE(1)) + '" ' +
'v184spt="'+ COALESCE(CAST(@spt_VS AS VARCHAR(50)),SPACE(1)) + '" ' +
'v185spt="'+ COALESCE(CAST(@spt_VS AS VARCHAR(50)),SPACE(1)) + '" ' +
'v186spt="'+ COALESCE(CAST(@spt_VS AS VARCHAR(50)),SPACE(1)) + 
'" />' +


'<m mpt_1="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'mpt_2="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'mpt_3="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'mpt_4="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'mpt_5="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'mpt_6="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'mpt_7="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'mpt_8="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'mpt_9="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'mpt_10="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'mlivept_1="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'mlivept_3="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'mlivept_7="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'mlivept_8="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +

'v2mpt_1="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v2mpt_2="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v2mpt_3="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v2mpt_7="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v2mpt_8="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v2mpt_20="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +

'v3mpt_1="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v3mpt_2="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v3mpt_3="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v3mpt_20="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +

'v5mpt_1="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v5mpt_2="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v5mpt_3="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v5mpt_20="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +

'v8mpt_1="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v8mpt_3="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v8mpt_20="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +

'v10mpt_1="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v10mpt_2="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v10mpt_3="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v10mpt_20="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +

'v11mpt_1="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v11mpt_20="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +

'v44mpt_3="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +

'v99mpt_1="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v99mpt_2="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v99mpt_3="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v99mpt_9="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v99mpt_20="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v154mpt_20="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +

'v161mpt_81="'+ COALESCE(CONVERT(VARCHAR(50),@pt_NG,2),SPACE(1)) + '" ' +
'v161mpt_83="'+ COALESCE(CONVERT(VARCHAR(50),@pt_NG,2),SPACE(1)) + '" ' +
'v161mpt_86="'+ COALESCE(CONVERT(VARCHAR(50),@pt_NG,2),SPACE(1)) + '" ' +
'v161mpt_88="'+ COALESCE(CONVERT(VARCHAR(50),@pt_NG,2),SPACE(1)) + '" ' +
'v161mlivept_85="'+ COALESCE(CONVERT(VARCHAR(50),@pt_NG,2),SPACE(1)) + '" ' +
'v161mlivept_86="'+ COALESCE(CONVERT(VARCHAR(50),@pt_NG,2),SPACE(1)) + '" ' +
'v161mlivept_87="'+ COALESCE(CONVERT(VARCHAR(50),@pt_NG,2),SPACE(1)) + '" ' +
'v161mlivept_89="'+ COALESCE(CONVERT(VARCHAR(50),@pt_NG,2),SPACE(1)) + '" ' +
'v161mlivept_90="'+ COALESCE(CONVERT(VARCHAR(50),@pt_NG,2),SPACE(1)) + '" ' +
@str_mpt_+
'v180mpt="'+ COALESCE(CAST(@pt_VS AS VARCHAR(50)),SPACE(1)) + '" ' + 
'v181mpt="'+ COALESCE(CAST(@pt_VS AS VARCHAR(50)),SPACE(1)) + '" ' +
'v182mpt="'+ COALESCE(CAST(@pt_VS AS VARCHAR(50)),SPACE(1)) + '" ' +
'v183mpt="'+ COALESCE(CAST(@pt_VS AS VARCHAR(50)),SPACE(1)) + '" ' +
'v184mpt="'+ COALESCE(CAST(@pt_VS AS VARCHAR(50)),SPACE(1)) + '" ' +
'v185mpt="'+ COALESCE(CAST(@pt_VS AS VARCHAR(50)),SPACE(1)) + '" ' +
'v186mpt="'+ COALESCE(CAST(@pt_VS AS VARCHAR(50)),SPACE(1)) +
'" />' +
'</Acc_Dep_CustomerUpdMember_SAg>'


EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP 
	@UserID = @UserID,
	@CustID = @CustID,
	@ActionID = 2705,
	@TrackingValue = @LogSPData,
	@TrackingValue2 = @LogSPData2,
	@duration = @duration

Select @LogSPData = '<Acc_Dep_CustomerUpdMember_SAg custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +
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
select @v151discount_31_=MastRBDiscount FROM #data_old WHERE custid=@custID and sporttype = 151 AND bettype =31
select @v151discount_41_=MastRBDiscount FROM #data_old WHERE custid=@custID and sporttype = 151 AND bettype =41
select @v151discount_51_=MastRBDiscount FROM #data_old WHERE custid=@custID and sporttype = 151 AND bettype =51
select @v152discount_41_=MastRBDiscount FROM #data_old WHERE custid=@custID and sporttype = 152 AND bettype =41
select @v152discount_51_=MastRBDiscount FROM #data_old WHERE custid=@custID and sporttype = 152 AND bettype =51
select @v153discount_51_=MastRBDiscount FROM #data_old WHERE custid=@custID and sporttype = 153 AND bettype =51

Select @LogSPData2 = '<Acc_Dep_CustomerUpdMember_SAg custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +
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
	@ActionID = 2605,
	@TrackingValue = @LogSPData,
	@TrackingValue2 = @LogSPData2,
	@duration = @duration

DROP TABLE #data
DROP TABLE #Data_Upline
DROP TABLE #data_old
