USE [CustDB]
GO
 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
ALTER PROCEDURE [dbo].[Acc_Dep_CustomerUpdMember_Com]
	
	@CustID INT, -- Super ID

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
	
	@MinBetv154 MONEY,
	@MaxBetv154 MONEY,
	@MaxPerMatchv154 MONEY,

	@MinBetv99MP MONEY,
	@MaxBetv99MP MONEY,
	@MaxPerMatchv99MP MONEY,	
	
	@MinBetv161 MONEY,
	@MaxBetv161 MONEY,
	@MaxPerMatchv161 MONEY,

	@MaxPerBallv161 MONEY = 0,	

	@v151MinBet_31 MONEY,
	@v151MinBet_41 MONEY,
	@v151MinBet_51 MONEY,
	@v152MinBet_41 MONEY,
	@v152MinBet_51 MONEY,
	@v153MinBet_51 MONEY,

	@v151MaxBet_31 MONEY,
	@v151MaxBet_41 MONEY,
	@v151MaxBet_51 MONEY,
	@v152MaxBet_41 MONEY,
	@v152MaxBet_51 MONEY,
	@v153MaxBet_51 MONEY,

	@v151maxpermatch_31 MONEY,
	@v151maxpermatch_41 MONEY,
	@v151maxpermatch_51 MONEY,
	@v152maxpermatch_41 MONEY,
	@v152maxpermatch_51 MONEY,
	@v153maxpermatch_51 MONEY,
	-- PT
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

	
	--Virtual Sports----------------
	@VirtualSportList VARCHAR(4000)='', -- replace all old params

	--Virtual Sports----------------
	@KenoList VARCHAR(4000)='', 
	@UpdateAll tinyINT = 0,

	@UserID INT = 0,	
	@Language VARCHAR(2) = 'E',
	@IP VARCHAR(15)='',
	@ErrCode INT = 0 OUTPUT,
	@ErrMsg NVARCHAR(4000) = '' OUTPUT

AS
--@Source Control
/*
Created: 20120409@Dom
Task : Company update MinBet, MaxBet, MaxPerMatch, PT, Commission of Super agent
DB: DBTrans.bodb02

Revisions:
    - 20121128@Elodie: Get an error message from f_Get_MsgNameByMsgID function by language
	- 20130918@Don: Supporting save log of Number Game PT with format such as "0.995", "0.925", ...
	- 20131014@Francis: Support updating virtual sports with settings via XML param
	- 20131119@Francis: Update 3rd product commission of super will not impact 3rd product commission of its downline members anymore
	- 20131108@Elodie: Splitting bodb02 into CustDB (call sports, bettype by link database)	
	- 20140505@Florent: Add new sport HRFO
	- 20140509@Florent: Add new sport: 202 Keno
	- 20140605@Florent: Remove checking for Super
	- 20150609@David: Separate CustDB to DBCUST server (Use temp table for sports, bettype, GameType table, call some SPs by link server) 
	- 20151028@Jim:Implement Muay's Setting for Deposit Customer [Redmine: #45491]	
Param's Explanation:
• @ErrCode:
    = 0: Update successfully.
    > 0: Specific Error.
  
• @ErrMsg: Error description.
• @VirtualSportList: VirtualSport Settings XML param.
• @UpdateAll :  0 - default - Update only Super
				1 - Allow update all line
*/

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

--Update all line feature
IF @UpdateAll = 1
BEGIN
	IF NOT EXISTS ( SELECT top 1 1  FROM custinfo WITH (NOLOCK)
					WHERE srecommend = @custid
						AND mrecommend NOT IN (
							SELECT custid
							FROM custInfo cus WITH (NOLOCK)
							WHERE srecommend =@custid
								AND cus.roleid = 3
								AND cus.username LIKE '%ACC%'
							)
						AND roleid = 1)
		set @UpdateAll =1
	ELSE
		set @UpdateAll =0
END
-- end 

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



DECLARE @startRun DATETIME
DECLARE @endRun DATETIME
DECLARE @duration INT
SET @startRun = getdate()

DECLARE @ErrType VARCHAR(1000)
DECLARE @ErrAcc nvarchar(4000)

DECLARE @currency INT 
DECLARE @isvalid BIT
DECLARE @username varchar(40)
SELECT @ErrCode = 0
SELECT @currency = currency FROM CustInfo WHERE custid = @CustID
--Validate PT
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
EXEC dbo.Acc_Dep_CustomerInsMember_Com_CheckParam 
			@custid						= @CustID OUTPUT,
			@currency					= @currency,
			
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

			@MinBetv154					= @MinBetv154,
			@MaxBetv154					= @MaxBetv154,
			@MaxPerMatchv154			= @MaxPerMatchv154,			
			--Mix Parlay mix sports
			@MinBetv99MP				= @MinBetv99MP,
			@MaxBetv99MP				= @MaxBetv99MP,
			@MaxPerMatchv99MP			= @MaxPerMatchv99MP,
			
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
			
			--Horse Racing Commission
			@v151discount_31			= @v151discount_31,	
			@v151discount_41			= @v151discount_41,
			@v151discount_51			= @v151discount_51,

			@v152discount_41			= @v152discount_41,
			@v152discount_51			= @v152discount_51,
			@v153discount_51			= @v153discount_51,

			@isvalid					= @isvalid OUTPUT,
			@errmsg						= @errmsg OUTPUT,
			@errcode					= @errcode OUTPUT,
			@language					= @language

IF @ErrCode <> 0
BEGIN	
	RETURN
END
------------------------------------------------Validate PT-------------------------------------------------------------------

select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', '
from 
	custinfo as c with (NOLOCK) 
	inner join dep_custsetting as cs with (NOLOCK) on c.custid = cs.custid
	inner join (

			select 		1 as sporttype, 1 as bettype, @v1spositiontaking_1 as maxpositiontaking,  @v1slivepositiontaking_1 as maxlivepositiontaking
			union all select 	1 as sporttype, 2 as bettype, @v1spositiontaking_2 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	1 as sporttype, 3 as bettype, @v1spositiontaking_3 as maxpositiontaking,  @v1slivepositiontaking_3 as maxlivepositiontaking
			union all select 	1 as sporttype, 4 as bettype, @v1spositiontaking_4 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	1 as sporttype, 5 as bettype, @v1spositiontaking_5 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	1 as sporttype, 6 as bettype, @v1spositiontaking_6 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	1 as sporttype, 7 as bettype, @v1spositiontaking_7 as maxpositiontaking,  @v1slivepositiontaking_7 as maxlivepositiontaking
			union all select 	1 as sporttype, 8 as bettype, @v1spositiontaking_8 as maxpositiontaking,  @v1slivepositiontaking_8 as maxlivepositiontaking
			union all select 	1 as sporttype, 9 as bettype, @v1spositiontaking_9 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	1 as sporttype, 10 as bettype, @v1spositiontaking_10 as maxpositiontaking,  0 as maxlivepositiontaking

			union all select 	2 as sporttype, 1 as bettype, @v2spositiontaking_1 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	2 as sporttype, 2 as bettype, @v2spositiontaking_2 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	2 as sporttype, 3 as bettype, @v2spositiontaking_3 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	2 as sporttype, 7 as bettype, @v2spositiontaking_7 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	2 as sporttype, 8 as bettype, @v2spositiontaking_8 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	2 as sporttype, 20 as bettype, @v2spositiontaking_20 as maxpositiontaking,  0 as maxlivepositiontaking

			union all select 	3 as sporttype, 1 as bettype, @v3spositiontaking_1 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	3 as sporttype, 2 as bettype, @v3spositiontaking_2 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	3 as sporttype, 3 as bettype, @v3spositiontaking_3 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	3 as sporttype, 20 as bettype, @v3spositiontaking_20 as maxpositiontaking,  0 as maxlivepositiontaking

			union all select 	5 as sporttype, 1 as bettype, @v5spositiontaking_1 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	5 as sporttype, 2 as bettype, @v5spositiontaking_2 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	5 as sporttype, 3 as bettype, @v5spositiontaking_3 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	5 as sporttype, 20 as bettype, @v5spositiontaking_20 as maxpositiontaking,  0 as maxlivepositiontaking

			union all select 	8 as sporttype, 1 as bettype, @v8spositiontaking_1 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	8 as sporttype, 3 as bettype, @v8spositiontaking_3 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	8 as sporttype, 20 as bettype, @v8spositiontaking_20 as maxpositiontaking,  0 as maxlivepositiontaking

			union all select 	10 as sporttype, 1 as bettype, @v10spositiontaking_1 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	10 as sporttype, 2 as bettype, @v10spositiontaking_2 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	10 as sporttype, 3 as bettype, @v10spositiontaking_3 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	10 as sporttype, 20 as bettype, @v10spositiontaking_20 as maxpositiontaking,  0 as maxlivepositiontaking

			union all select 	11 as sporttype, 1 as bettype, @v11spositiontaking_1 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	11 as sporttype, 20 as bettype, @v11spositiontaking_20 as maxpositiontaking,  0 as maxlivepositiontaking
			
			union all select 	44 as sporttype, 3 as bettype, @v44spositiontaking_3 as maxpositiontaking,  0 as maxlivepositiontaking
			
			union all select 	99 as sporttype, 1 as bettype, @v99spositiontaking_1 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	99 as sporttype, 2 as bettype, @v99spositiontaking_2 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	99 as sporttype, 3 as bettype, @v99spositiontaking_3 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	99 as sporttype, 9 as bettype, @v99spositiontaking_9 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	99 as sporttype, 20 as bettype, @v99spositiontaking_20 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	154 as sporttype, 20 as bettype, @v154spositiontaking_20 as maxpositiontaking,  0 as maxlivepositiontaking
			
			
		) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
where c.srecommend = @custid and c.roleid = 3 and (
							(cs.spositiontaking + cs.mpositiontaking > b.maxpositiontaking and cs.islive = 0) or 
							(cs.mpositiontaking > b.maxpositiontaking  and cs.islive = 0) or 
							((b.sporttype=1) and (b.bettype in (1,3,7,8)) and (cs.islive=1) and (cs.spositiontaking + cs.mpositiontaking > b.maxlivepositiontaking)) or
							((b.sporttype=1) and (b.bettype in (1,3,7,8)) and (cs.islive=1) and (cs.mpositiontaking > b.maxpositiontaking))
						) AND @UpdateAll = 0 -- check only case update 1 supper
group by username
if @ErrAcc<>''
BEGIN
	Select @ErrMsg = 	case @Language 
						when 'E' then 'Existing masters exceeded new super position taking ('+@ErrAcc+') (for Sportsbook).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20013,@Language) + ' ('+@ErrAcc+') (for Sportsbook).'
				end, @ErrCode = 103
	return
END

--v161
select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', '
from 
	custinfo as c with (NOLOCK) 
	inner join dep_custsetting3rd as cs with (NOLOCK) on c.custid = cs.custid
	inner join (
			select 	161 as sporttype, 81 as bettype, @v161spositiontaking_81 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	161 as sporttype, 83 as bettype, @v161spositiontaking_83 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	161 as sporttype, 85 as bettype, 0 as maxpositiontaking,  @v161slivepositiontaking_85 as maxlivepositiontaking
			union all select 	161 as sporttype, 86 as bettype, @v161spositiontaking_86 as maxpositiontaking,  @v161slivepositiontaking_86 as maxlivepositiontaking
			union all select 	161 as sporttype, 87 as bettype, 0 as maxpositiontaking,  @v161slivepositiontaking_87 as maxlivepositiontaking
			union all select 	161 as sporttype, 88 as bettype, @v161spositiontaking_88 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	161 as sporttype, 89 as bettype, 0 as maxpositiontaking,  @v161slivepositiontaking_89 as maxlivepositiontaking
			union all select 	161 as sporttype, 90 as bettype, 0 as maxpositiontaking,  @v161slivepositiontaking_90 as maxlivepositiontaking
			
		) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
where c.srecommend = @custid and c.roleid = 3 and (
						(cs.spositiontaking+cs.mpositiontaking>b.maxpositiontaking and cs.islive = 0) or 
						(cs.mpositiontaking>b.maxpositiontaking  and cs.islive = 0) or 
						((b.sporttype=161) and (b.bettype in (85,86,87,89)) and (cs.islive = 1) and (cs.spositiontaking + cs.mpositiontaking > b.maxlivepositiontaking)) or
						((b.sporttype=161) and (b.bettype in (85,86,87,89)) and (cs.islive = 1) and (cs.mpositiontaking>b.maxlivepositiontaking))
						) AND @UpdateAll = 0 -- check only case update 1 supper
group by username
if @ErrAcc<>''
BEGIN
	Select @ErrMsg = 	case @Language 
						when 'E' then 'Existing masters exceeded new super position taking ('+@ErrAcc+') (for Number game).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20013,@Language) + ' ('+@ErrAcc+') (' + [dbo].[f_Get_SportNameBySporttype](161,@Language) + ')'
				end, @ErrCode = 103
	return
END

--check all s1+m1+a1 <= s4
--check all u1<=s4 if i1=1
select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', '
from 
	custinfo as c with (NOLOCK) 
	inner join dep_custsetting as cs with (NOLOCK) on c.custid = cs.custid
	inner join (

			select 		1 as sporttype, 1 as bettype, @v1spositiontaking_1 as maxpositiontaking,  @v1slivepositiontaking_1 as maxlivepositiontaking
			union all select 	1 as sporttype, 2 as bettype, @v1spositiontaking_2 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	1 as sporttype, 3 as bettype, @v1spositiontaking_3 as maxpositiontaking,  @v1slivepositiontaking_3 as maxlivepositiontaking
			union all select 	1 as sporttype, 4 as bettype, @v1spositiontaking_4 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	1 as sporttype, 5 as bettype, @v1spositiontaking_5 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	1 as sporttype, 6 as bettype, @v1spositiontaking_6 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	1 as sporttype, 7 as bettype, @v1spositiontaking_7 as maxpositiontaking,  @v1slivepositiontaking_7 as maxlivepositiontaking
			union all select 	1 as sporttype, 8 as bettype, @v1spositiontaking_8 as maxpositiontaking,  @v1slivepositiontaking_8 as maxlivepositiontaking
			union all select 	1 as sporttype, 9 as bettype, @v1spositiontaking_9 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	1 as sporttype, 10 as bettype, @v1spositiontaking_10 as maxpositiontaking,  0 as maxlivepositiontaking

			union all select 	2 as sporttype, 1 as bettype, @v2spositiontaking_1 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	2 as sporttype, 2 as bettype, @v2spositiontaking_2 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	2 as sporttype, 3 as bettype, @v2spositiontaking_3 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	2 as sporttype, 7 as bettype, @v2spositiontaking_7 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	2 as sporttype, 8 as bettype, @v2spositiontaking_8 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	2 as sporttype, 20 as bettype, @v2spositiontaking_20 as maxpositiontaking,  0 as maxlivepositiontaking

			union all select 	3 as sporttype, 1 as bettype, @v3spositiontaking_1 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	3 as sporttype, 2 as bettype, @v3spositiontaking_2 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	3 as sporttype, 3 as bettype, @v3spositiontaking_3 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	3 as sporttype, 20 as bettype, @v3spositiontaking_20 as maxpositiontaking,  0 as maxlivepositiontaking

			union all select 	5 as sporttype, 1 as bettype, @v5spositiontaking_1 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	5 as sporttype, 2 as bettype, @v5spositiontaking_2 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	5 as sporttype, 3 as bettype, @v5spositiontaking_3 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	5 as sporttype, 20 as bettype, @v5spositiontaking_20 as maxpositiontaking,  0 as maxlivepositiontaking

			union all select 	8 as sporttype, 1 as bettype, @v8spositiontaking_1 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	8 as sporttype, 3 as bettype, @v8spositiontaking_3 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	8 as sporttype, 20 as bettype, @v8spositiontaking_20 as maxpositiontaking,  0 as maxlivepositiontaking

			union all select 	10 as sporttype, 1 as bettype, @v10spositiontaking_1 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	10 as sporttype, 2 as bettype, @v10spositiontaking_2 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	10 as sporttype, 3 as bettype, @v10spositiontaking_3 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	10 as sporttype, 20 as bettype, @v10spositiontaking_20 as maxpositiontaking,  0 as maxlivepositiontaking

			union all select 	11 as sporttype, 1 as bettype, @v11spositiontaking_1 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	11 as sporttype, 20 as bettype, @v11spositiontaking_20 as maxpositiontaking,  0 as maxlivepositiontaking
			
			union all select 	44 as sporttype, 3 as bettype, @v44spositiontaking_3 as maxpositiontaking,  0 as maxlivepositiontaking
			
			union all select 	99 as sporttype, 1 as bettype, @v99spositiontaking_1 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	99 as sporttype, 2 as bettype, @v99spositiontaking_2 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	99 as sporttype, 3 as bettype, @v99spositiontaking_3 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	99 as sporttype, 9 as bettype, @v99spositiontaking_9 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	99 as sporttype, 20 as bettype, @v99spositiontaking_20 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	154 as sporttype, 20 as bettype, @v154spositiontaking_20 as maxpositiontaking,  0 as maxlivepositiontaking
			
		) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
where c.srecommend = @custid and c.roleid = 1 and (
			(cs.spositiontaking + cs.mpositiontaking+cs.apositiontaking>b.maxpositiontaking AND  cs.islive = 0 ) or 
			(b.sporttype=1 and b.bettype in (1,3,7,8) AND cs.islive=1 and cs.spositiontaking+ cs.apositiontaking+cs.mpositiontaking>b.maxlivepositiontaking)
			) AND @UpdateAll = 0 -- check only case update 1 supper
group by username
if @ErrAcc<>''
BEGIN
	Select @ErrMsg = 	case @Language 
						when 'E' then 'Existing members exceeded new super position taking ('+@ErrAcc+').'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20014,@Language) + ' ('+@ErrAcc+').'
				end, @ErrCode = 104
	return
END

--v161
select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', '
from 
	custinfo as c with (NOLOCK) 
	inner join dep_custsetting3rd as cs with (NOLOCK) on c.custid = cs.custid
	inner join (
			select 	161 as sporttype, 81 as bettype, @v161mpositiontaking_81 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	161 as sporttype, 83 as bettype, @v161mpositiontaking_83 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	161 as sporttype, 85 as bettype, 0 as maxpositiontaking,  @v161mlivepositiontaking_85 as maxlivepositiontaking
			union all select 	161 as sporttype, 86 as bettype, @v161mpositiontaking_86 as maxpositiontaking,  @v161mlivepositiontaking_86 as maxlivepositiontaking						
			union all select 	161 as sporttype, 87 as bettype, 0 as maxpositiontaking,  @v161mlivepositiontaking_87 as maxlivepositiontaking
			union all select 	161 as sporttype, 88 as bettype, @v161mpositiontaking_88 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	161 as sporttype, 89 as bettype, 0 as maxpositiontaking,  @v161mlivepositiontaking_89 as maxlivepositiontaking
			union all select 	161 as sporttype, 90 as bettype, 0 as maxpositiontaking,  @v161mlivepositiontaking_90 as maxlivepositiontaking
			) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
where c.srecommend = @custid and c.roleid = 1 and (
			(cs.mpositiontaking+cs.apositiontaking>b.maxpositiontaking AND cs.islive = 0) 
			or 
			(
				b.sporttype=161 and b.bettype in (85,86,87,89) and cs.islive=1 and cs.mpositiontaking+ cs.apositiontaking>b.maxlivepositiontaking)   
			) AND @UpdateAll = 0 -- check only case update 1 supper
group by username
if @ErrAcc<>''
BEGIN
	Select @ErrMsg = 	@UserName + ': '+
		case @Language 
						when 'E' then 'Existing members exceeded new master position taking ('+@ErrAcc+').'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20012,@Language) + ' ('+@ErrAcc+').'
				end, @ErrCode = 108
	return
END

--Check all a1<=a4
select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', '
from 
	custinfo as c with (NOLOCK) 
	inner join dep_custsetting as cs with (NOLOCK) on c.custid = cs.custid
	inner join (
				     select 		1 as sporttype, 1 as bettype, @v1apositiontaking_1 as maxpositiontaking,  @v1alivepositiontaking_1 as maxlivepositiontaking
			union all select 	1 as sporttype, 2 as bettype, @v1apositiontaking_2 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	1 as sporttype, 3 as bettype, @v1apositiontaking_3 as maxpositiontaking,  @v1alivepositiontaking_3 as maxlivepositiontaking
			union all select 	1 as sporttype, 4 as bettype, @v1apositiontaking_4 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	1 as sporttype, 5 as bettype, @v1apositiontaking_5 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	1 as sporttype, 6 as bettype, @v1apositiontaking_6 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	1 as sporttype, 7 as bettype, @v1apositiontaking_7 as maxpositiontaking,  @v1alivepositiontaking_7 as maxlivepositiontaking
			union all select 	1 as sporttype, 8 as bettype, @v1apositiontaking_8 as maxpositiontaking,  @v1alivepositiontaking_8 as maxlivepositiontaking
			union all select 	1 as sporttype, 9 as bettype, @v1apositiontaking_9 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	1 as sporttype, 10 as bettype, @v1apositiontaking_10 as maxpositiontaking,  0 as maxlivepositiontaking

			union all select 	2 as sporttype, 1 as bettype, @v2apositiontaking_1 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	2 as sporttype, 2 as bettype, @v2apositiontaking_2 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	2 as sporttype, 3 as bettype, @v2apositiontaking_3 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	2 as sporttype, 7 as bettype, @v2apositiontaking_7 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	2 as sporttype, 8 as bettype, @v2apositiontaking_8 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	2 as sporttype, 20 as bettype, @v2apositiontaking_20 as maxpositiontaking,  0 as maxlivepositiontaking

			union all select 	3 as sporttype, 1 as bettype, @v3apositiontaking_1 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	3 as sporttype, 2 as bettype, @v3apositiontaking_2 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	3 as sporttype, 3 as bettype, @v3apositiontaking_3 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	3 as sporttype, 20 as bettype, @v3apositiontaking_20 as maxpositiontaking,  0 as maxlivepositiontaking

			union all select 	5 as sporttype, 1 as bettype, @v5apositiontaking_1 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	5 as sporttype, 2 as bettype, @v5apositiontaking_2 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	5 as sporttype, 3 as bettype, @v5apositiontaking_3 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	5 as sporttype, 20 as bettype, @v5apositiontaking_20 as maxpositiontaking,  0 as maxlivepositiontaking

			union all select 	8 as sporttype, 1 as bettype, @v8apositiontaking_1 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	8 as sporttype, 3 as bettype, @v8apositiontaking_3 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	8 as sporttype, 20 as bettype, @v8apositiontaking_20 as maxpositiontaking,  0 as maxlivepositiontaking

			union all select 	10 as sporttype, 1 as bettype, @v10apositiontaking_1 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	10 as sporttype, 2 as bettype, @v10apositiontaking_2 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	10 as sporttype, 3 as bettype, @v10apositiontaking_3 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	10 as sporttype, 20 as bettype, @v10apositiontaking_20 as maxpositiontaking,  0 as maxlivepositiontaking

			union all select 	11 as sporttype, 1 as bettype, @v11apositiontaking_1 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	11 as sporttype, 20 as bettype, @v11apositiontaking_20 as maxpositiontaking,  0 as maxlivepositiontaking
			
			union all select 	44 as sporttype, 3 as bettype, @v44apositiontaking_3 as maxpositiontaking,  0 as maxlivepositiontaking
			
			union all select 	99 as sporttype, 1 as bettype, @v99apositiontaking_1 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	99 as sporttype, 2 as bettype, @v99apositiontaking_2 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	99 as sporttype, 3 as bettype, @v99apositiontaking_3 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	99 as sporttype, 9 as bettype, @v99apositiontaking_9 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	99 as sporttype, 20 as bettype, @v99apositiontaking_20 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	154 as sporttype, 20 as bettype, @v154apositiontaking_20 as maxpositiontaking,  0 as maxlivepositiontaking
			
		) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
where c.srecommend = @custid and c.roleid = 1 and 
											(
												(cs.apositiontaking>b.maxpositiontaking AND cs.islive = 0) or (b.sporttype=1 and b.bettype in (1,3,7,8) and cs.islive = 1 and cs.apositiontaking > b.maxlivepositiontaking)   
											) AND @UpdateAll = 0 -- check only case update 1 supper
group by username
if @ErrAcc<>''
BEGIN
	Select @ErrMsg = 	@UserName + ': '+
		case @Language 
						when 'E' then 'Existing members exceeded new agent position taking ('+@ErrAcc+').'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20017,@Language) + ' ('+@ErrAcc+').'
				end, @ErrCode = 109
	return
END

--v161
select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', '
from 
	custinfo as c with (NOLOCK) 
	inner join dep_custsetting3rd as cs with (NOLOCK) on c.custid = cs.custid
	inner join (
			select 	161 as sporttype, 81 as bettype, @v161apositiontaking_81 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	161 as sporttype, 83 as bettype, @v161apositiontaking_83 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	161 as sporttype, 85 as bettype, 0 as maxpositiontaking,  @v161alivepositiontaking_85 as maxlivepositiontaking
			union all select 	161 as sporttype, 86 as bettype, @v161apositiontaking_86 as maxpositiontaking,  @v161alivepositiontaking_86 as maxlivepositiontaking
			union all select 	161 as sporttype, 87 as bettype, 0 as maxpositiontaking,  @v161alivepositiontaking_87 as maxlivepositiontaking
			union all select 	161 as sporttype, 88 as bettype, @v161apositiontaking_88 as maxpositiontaking,  0 as maxlivepositiontaking
			union all select 	161 as sporttype, 89 as bettype, 0 as maxpositiontaking,  @v161alivepositiontaking_89 as maxlivepositiontaking
			union all select 	161 as sporttype, 90 as bettype, 0 as maxpositiontaking,  @v161alivepositiontaking_90 as maxlivepositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
where c.srecommend = @custid and c.roleid = 1 and (
				(cs.apositiontaking>b.maxpositiontaking AND cs.islive = 0)   
				or 
				(b.sporttype=161 and b.bettype in (85,86,87,89) and cs.islive = 1 and cs.apositiontaking > b.maxlivepositiontaking)   
			) AND @UpdateAll = 0 -- check only case update 1 supper
group by username
if @ErrAcc<>''
BEGIN
	Select @ErrMsg = 	@UserName + ': '+
		case @Language 
						when 'E' then 'Existing members exceeded new agent position taking ('+@ErrAcc+').'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20017,@Language) + ' ('+@ErrAcc+').'
				end, @ErrCode = 109
	return
END
--------------------------------------------------END------------------------------------------------------------------------------

-----------------------------------------------Validate Min & Max Bet-------------------------------------------------------------------
SELECT @ErrType = ''
SELECT @ErrType = @ErrType +  (CASE WHEN MP=0 THEN sportname ELSE 'Mixed Sports' END )       + ', '
from @tmp_Sports sports inner join
(
				SELECT 1 AS sporttype,0 AS MP, @MinBetv1 AS MinBet, @MaxBetv1 AS MaxBet, @MaxPerMatchv1 AS MaxPerMatch
	UNION all	SELECT 2 AS sporttype,0 AS MP, @MinBetv2 AS MinBet, @MaxBetv2 AS MaxBet, @MaxPerMatchv2 AS MaxPerMatch
	UNION all	SELECT 3 AS sporttype,0 AS MP, @MinBetv3 AS MinBet, @MaxBetv3 AS MaxBet, @MaxPerMatchv3 AS MaxPerMatch
	UNION all	SELECT 5 AS sporttype,0 AS MP, @MinBetv5 AS MinBet, @MaxBetv5 AS MaxBet, @MaxPerMatchv5 AS MaxPerMatch
	UNION all	SELECT 8 AS sporttype,0 AS MP, @MinBetv8 AS MinBet, @MaxBetv8 AS MaxBet, @MaxPerMatchv8 AS MaxPerMatch
	UNION all	SELECT 10 AS sporttype,0 AS MP, @MinBetv10 AS MinBet, @MaxBetv10 AS MaxBet, @MaxPerMatchv10 AS MaxPerMatch
	UNION all	SELECT 11 AS sporttype,0 AS MP, @MinBetv11 AS MinBet, @MaxBetv11 AS MaxBet, @MaxPerMatchv11 AS MaxPerMatch
	UNION all	SELECT 44 AS sporttype,0 AS MP, @MinBetv44 AS MinBet, @MaxBetv44 AS MaxBet, @MaxPerMatchv44 AS MaxPerMatch
	UNION all	SELECT 99 AS sporttype,0 AS MP, @MinBetv99 AS MinBet, @MaxBetv99 AS MaxBet, @MaxPerMatchv99 AS MaxPerMatch	 
	UNION all	SELECT 154 AS sporttype,0 AS MP, @MinBetv154 AS MinBet, @MaxBetv154 AS MaxBet, @MaxPerMatchv154 AS MaxPerMatch	 
	UNION all	SELECT 99 AS sporttype,1 AS MP, @MinBetv99MP AS MinBet, @MaxBetv99MP AS MaxBet, @MaxPerMatchv99MP AS MaxPerMatch	 
	UNION all	SELECT 161 AS sporttype,0 AS MP, @MinBetv161 AS MinBet, @MaxBetv161 AS MaxBet, @MaxPerMatchv161 AS MaxPerMatch	 
) AS b ON sports.sporttype = b.sporttype
where (MinBet<>0 AND MaxBet <> 0 AND  MinBet>MaxBet) 
OR (MaxBet<> 0 AND MaxPerMatch <> 0 AND MaxBet>MaxPerMatch) 
OR (MinBet <> 0 AND MaxPerMatch <> 0 AND MinBet>MaxPerMatch) 

IF @ErrType <>''
BEGIN
	SELECT
		@ErrMsg =	CASE @Language 
							WHEN 'E' THEN 'Min bet must be less than max bet and max bet must be less than max bet per match ('+@ErrType+').'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language) + ' ('+@ErrType+').'
					END, @ErrCode = 102
	RETURN
END
----------------------------Horse Racing---------------------------------------

select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', ', @ErrType = @ErrType + t.typenamee+', '
from 
	custinfo as c with (NOLOCK) 
	inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
	inner join (
					  select 	151 as sporttype, 31 as bettype, @v151spositiontaking_31 as maxpositiontaking
			union all select 	151 as sporttype, 32 as bettype, @v151spositiontaking_32 as maxpositiontaking
			union all select 	151 as sporttype, 41 as bettype, @v151spositiontaking_41 as maxpositiontaking
			union all select 	151 as sporttype, 42 as bettype, @v151spositiontaking_42 as maxpositiontaking
			union all select 	151 as sporttype, 51 as bettype, @v151spositiontaking_51 as maxpositiontaking
			union all select 	151 as sporttype, 52 as bettype, @v151spositiontaking_52 as maxpositiontaking
			union all select 	152 as sporttype, 41 as bettype, @v152spositiontaking_41 as maxpositiontaking
			union all select 	152 as sporttype, 42 as bettype, @v152spositiontaking_42 as maxpositiontaking
			union all select 	152 as sporttype, 51 as bettype, @v152spositiontaking_51 as maxpositiontaking
			union all select 	152 as sporttype, 52 as bettype, @v152spositiontaking_52 as maxpositiontaking
			union all select 	153 as sporttype, 51 as bettype, @v153spositiontaking_51 as maxpositiontaking
			union all select 	153 as sporttype, 52 as bettype, @v153spositiontaking_52 as maxpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
	inner join @tmp_Bettype as t ON t.typeid = b.bettype
where c.srecommend = @custid and c.roleid = 3 and (
						((cs.spositiontaking+cs.mpositiontaking>b.maxpositiontaking)) or 
						((cs.mpositiontaking>b.maxpositiontaking))
					)  
group by username, t.typenamee

if @ErrAcc<>''

BEGIN
	Select @ErrMsg = 
				case @Language 
						when 'E' then 'Existing masters exceeded new super position taking ('+@ErrAcc+') (for Racing).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20013,@Language) + ' ('+@ErrAcc+') (' + [dbo].[f_Get_SportNameBySporttype](151,@Language) + ')'
				end, @ErrCode = 103
	return
END

--check all u1<=s4 if i1=1
select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', '
from 
	custinfo as c with (NOLOCK) 
	inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
	inner join (
				      select 	151 as sporttype, 31 as bettype, @v151spositiontaking_31 as maxpositiontaking
			union all select 	151 as sporttype, 32 as bettype, @v151spositiontaking_32 as maxpositiontaking
			union all select 	151 as sporttype, 41 as bettype, @v151spositiontaking_41 as maxpositiontaking
			union all select 	151 as sporttype, 42 as bettype, @v151spositiontaking_42 as maxpositiontaking
			union all select 	151 as sporttype, 51 as bettype, @v151spositiontaking_51 as maxpositiontaking
			union all select 	151 as sporttype, 52 as bettype, @v151spositiontaking_52 as maxpositiontaking
			union all select 	152 as sporttype, 41 as bettype, @v152spositiontaking_41 as maxpositiontaking
			union all select 	152 as sporttype, 42 as bettype, @v152spositiontaking_42 as maxpositiontaking
			union all select 	152 as sporttype, 51 as bettype, @v152spositiontaking_51 as maxpositiontaking
			union all select 	152 as sporttype, 52 as bettype, @v152spositiontaking_52 as maxpositiontaking
			union all select 	153 as sporttype, 51 as bettype, @v153spositiontaking_51 as maxpositiontaking
			union all select 	153 as sporttype, 52 as bettype, @v153spositiontaking_52 as maxpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
where c.srecommend = @custid and c.roleid = 1 and (
			(cs.spositiontaking+cs.mpositiontaking+cs.apositiontaking>b.maxpositiontaking)
			)
group by username
if @ErrAcc<>''
BEGIN
	Select @ErrMsg = @username + ': ' +
				case @Language 
						when 'E' then 'Existing members exceeded new super position taking ('+@ErrAcc+') (for Racing).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20014,@Language) + ' ('+@ErrAcc+') (' + [dbo].[f_Get_SportNameBySporttype](151,@Language) + ')'
				end, @ErrCode = 104
	return
END

--Check all m1+a1<=m4
select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', '
from 
	custinfo as c with (NOLOCK) 
	inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
	inner join (
				      select 	151 as sporttype, 31 as bettype, @v151mpositiontaking_31 as maxpositiontaking
			union all select 	151 as sporttype, 32 as bettype, @v151mpositiontaking_32 as maxpositiontaking
			union all select 	151 as sporttype, 41 as bettype, @v151mpositiontaking_41 as maxpositiontaking
			union all select 	151 as sporttype, 42 as bettype, @v151mpositiontaking_42 as maxpositiontaking
			union all select 	151 as sporttype, 51 as bettype, @v151mpositiontaking_51 as maxpositiontaking
			union all select 	151 as sporttype, 52 as bettype, @v151mpositiontaking_52 as maxpositiontaking
			union all select 	152 as sporttype, 41 as bettype, @v152mpositiontaking_41 as maxpositiontaking
			union all select 	152 as sporttype, 42 as bettype, @v152mpositiontaking_42 as maxpositiontaking
			union all select 	152 as sporttype, 51 as bettype, @v152mpositiontaking_51 as maxpositiontaking
			union all select 	152 as sporttype, 52 as bettype, @v152mpositiontaking_52 as maxpositiontaking
			union all select 	153 as sporttype, 51 as bettype, @v153mpositiontaking_51 as maxpositiontaking
			union all select 	153 as sporttype, 52 as bettype, @v153mpositiontaking_52 as maxpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
where c.srecommend = @custid and c.roleid = 1 and (
			(cs.mpositiontaking+cs.apositiontaking>b.maxpositiontaking)  
			)
group by username
if @ErrAcc<>''
BEGIN
	Select @ErrMsg = @username + ': ' +
				case @Language 
						when 'E' then 'Existing members exceeded new master position taking ('+@ErrAcc+') (for Racing).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20012,@Language) + ' ('+@ErrAcc+').'
				end, @ErrCode = 108
	return
END

--Check all a1<=a4
select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', '
from 
	custinfo as c with (NOLOCK) 
	inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
	inner join (
				      select 	151 as sporttype, 31 as bettype, @v151apositiontaking_31 as maxpositiontaking
			union all select 	151 as sporttype, 32 as bettype, @v151apositiontaking_32 as maxpositiontaking
			union all select 	151 as sporttype, 41 as bettype, @v151apositiontaking_41 as maxpositiontaking
			union all select 	151 as sporttype, 42 as bettype, @v151apositiontaking_42 as maxpositiontaking
			union all select 	151 as sporttype, 51 as bettype, @v151apositiontaking_51 as maxpositiontaking
			union all select 	151 as sporttype, 52 as bettype, @v151apositiontaking_52 as maxpositiontaking
			union all select 	152 as sporttype, 41 as bettype, @v152apositiontaking_41 as maxpositiontaking
			union all select 	152 as sporttype, 42 as bettype, @v152apositiontaking_42 as maxpositiontaking
			union all select 	152 as sporttype, 51 as bettype, @v152apositiontaking_51 as maxpositiontaking
			union all select 	152 as sporttype, 52 as bettype, @v152apositiontaking_52 as maxpositiontaking
			union all select 	153 as sporttype, 51 as bettype, @v153apositiontaking_51 as maxpositiontaking
			union all select 	153 as sporttype, 52 as bettype, @v153apositiontaking_52 as maxpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
where c.srecommend = @custid and c.roleid = 1 and (
			(cs.apositiontaking>b.maxpositiontaking)  
			)
group by username
if @ErrAcc<>''
BEGIN
	Select @ErrMsg = @username + ': ' +
				case @Language 
						when 'E' then 'Existing members exceeded new agent position taking ('+@ErrAcc+') (for Racing).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20017,@Language) + ' ('+@ErrAcc+').'
				end, @ErrCode = 109
	return
END

-----------------------------------------------END------------------------------------------------------------------------------------------
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

UPDATE Dep_CustSetting WITH (ROWLOCK, UPDLOCK)
SET	
	MinBet = case sporttype when 1 then @MinBetv1 when 2 then @MinBetv2 when 3 then @MinBetv3 when 5 then @MinBetv5 when 8 then @MinBetv8 when 10 then @MinBetv10 when 11 then @MinBetv11 when 44 then @MinBetv44  when 99 then (case bettype when 9 then @MinBetv99MP else @MinBetv99 end) when 154 then @MinBetv154 else MinBet end,
	MaxBet = case sporttype when 1 then @MaxBetv1 when 2 then @MaxBetv2 when 3 then @MaxBetv3 when 5 then @MaxBetv5 when 8 then @MaxBetv8 when 10 then @MaxBetv10 when 11 then @MaxBetv11 when 44 then @MaxBetv44  when 99 then (case bettype when 9 then @MaxBetv99MP else @MaxBetv99 end) when 154 then @MaxBetv154  else MaxBet end,
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
WHERE custid=@custid

if (@@error <> 0)
begin
	
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end	, @ErrCode = 104 
	return
end
-----------------------Update Commision-------------------------------------------------

--Update @Super: g4, s4
UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK)
SET
	sdiscount = CASE WHEN bettype IN (31,32) AND sporttype = 151 THEN @v151discount_31 
					 WHEN bettype IN (41,42) AND sporttype = 151 THEN @v151discount_41 
					 WHEN bettype IN (51,52) AND sporttype = 151 THEN @v151discount_51 
					 WHEN bettype IN (41,42) AND sporttype = 152 THEN @v152discount_41
					 WHEN bettype IN (51,52) AND sporttype = 152 THEN @v152discount_51
					 WHEN bettype IN (51,52) AND sporttype = 153 THEN @v153discount_51
					 ELSE sdiscount END
WHERE custid=@custid 
		and sporttype in (151,152,153)

IF (@@ERROR <> 0)
BEGIN	
	SELECT @ErrMsg = CASE @Language 
						WHEN 'E' THEN 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					END	, @ErrCode = 107
	RETURN
END

UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK) 
	SET adiscount = CASE WHEN cs.adiscount>@v151discount_31 THEN @v151discount_31 ELSE adiscount END
	FROM Dep_CustSetting3rd AS cs INNER JOIN custinfo AS c WITH (NOLOCK) ON cs.custid = c.custid
	WHERE c.srecommend = @custid AND c.roleid = 3 AND cs.bettype IN(31,32) AND cs.sporttype = 151
	IF (@@ERROR <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT @ErrMsg = CASE @Language 
							WHEN 'E' THEN 'Update process is unsuccessful !'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
						END	, @ErrCode = 108
		RETURN
END

--Update g2=g4 if g2>g4
UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK) 
SET discount = CASE WHEN cs.discount > @v151discount_31  THEN  @v151discount_31 ELSE discount END 
FROM Dep_CustSetting3rd AS cs INNER JOIN custinfo AS c WITH (NOLOCK) ON cs.custid = c.custid
WHERE c.srecommend = @custid AND c.roleid = 2 AND cs.bettype IN(31,32) AND cs.sporttype = 151
IF (@@ERROR <> 0)
BEGIN
	ROLLBACK TRANSACTION
	SELECT @ErrMsg = CASE @Language 
						WHEN 'E' THEN 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					END	, @ErrCode = 109
	RETURN
END

--Update g4 at Member level
UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK) 
SET sdiscount = @v151discount_31
FROM Dep_CustSetting3rd AS cs INNER JOIN custinfo AS c WITH (NOLOCK) ON cs.custid = c.custid
WHERE c.srecommend = @custid 
	AND c.recommend <> 52466
	AND c.roleid = 1 
	AND cs.bettype IN(31,32) 
	AND cs.sporttype = 151
IF (@@ERROR <> 0)
BEGIN
	ROLLBACK TRANSACTION
	SELECT @ErrMsg = CASE @Language 
						WHEN 'E' THEN 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					END	, @ErrCode = 110	
	RETURN
END

--Update m3=s4 if m3>s4
UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK) 
SET adiscount = CASE WHEN cs.adiscount>@v151discount_41 THEN @v151discount_41 ELSE adiscount END 
FROM Dep_CustSetting3rd AS cs INNER JOIN custinfo AS c WITH (NOLOCK) ON cs.custid = c.custid
WHERE c.srecommend = @custid AND c.roleid = 3 AND cs.bettype IN (41,42) AND cs.sporttype = 151 
IF (@@ERROR <> 0)
BEGIN
	ROLLBACK TRANSACTION
	SELECT @ErrMsg = CASE @Language 
						WHEN 'E' THEN 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					END, @ErrCode = 111	
	RETURN
END

---------------------------------------------------
--Update a2=s4 if a2>s4
UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK) 
SET	discount = CASE WHEN cs.discount>@v151discount_41 THEN @v151discount_41 ELSE discount END 
FROM Dep_CustSetting3rd AS cs INNER JOIN custinfo AS c WITH (NOLOCK) ON cs.custid = c.custid
WHERE c.srecommend = @custid AND c.roleid = 2 AND cs.bettype IN(41,42) AND cs.sporttype = 151 
IF (@@ERROR <> 0)
BEGIN
	ROLLBACK TRANSACTION
	SELECT @ErrMsg = CASE @Language 
						WHEN 'E' THEN 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					END, @ErrCode = 112	
	RETURN
END
	
---------------------------------------------------
--Update s4 to member level
UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK) 
SET	 sdiscount = @v151discount_41
FROM Dep_CustSetting3rd AS cs INNER JOIN custinfo AS c WITH (NOLOCK) ON cs.custid = c.custid
WHERE c.srecommend = @custid 
	AND c.recommend <> 52466
	AND c.roleid = 1 
	AND cs.bettype IN(41,42) 
	AND cs.sporttype = 151
IF (@@ERROR <> 0)
BEGIN
	ROLLBACK TRANSACTION
	SELECT @ErrMsg = CASE @Language 
						WHEN 'E' THEN 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					END, @ErrCode = 113	
	RETURN
END

---------------------------------------------------
	--Update m3=s4 if m3>s4
	UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK) 
	SET adiscount = CASE WHEN cs.adiscount>@v151discount_51 THEN @v151discount_51 ELSE adiscount END 
	FROM Dep_CustSetting3rd AS cs INNER JOIN custinfo AS c WITH (NOLOCK) ON cs.custid = c.custid
	WHERE c.srecommend = @custid AND c.roleid = 3 AND cs.bettype IN (51,52) AND cs.sporttype = 151 
	IF (@@ERROR <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT @ErrMsg = CASE @Language 
							WHEN 'E' THEN 'Update process is unsuccessful !'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
						END, @ErrCode = 114	
		RETURN
	END

	---------------------------------------------------
--Update a2=s4 if a2>s4
UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK) 
SET	discount = CASE WHEN cs.discount>@v151discount_51 THEN @v151discount_51 ELSE discount END 
FROM Dep_CustSetting3rd AS cs INNER JOIN custinfo AS c WITH (NOLOCK) ON cs.custid = c.custid
WHERE c.srecommend = @custid AND c.roleid = 2 AND cs.bettype IN(51,52) AND cs.sporttype = 151 
IF (@@ERROR <> 0)
BEGIN
	ROLLBACK TRANSACTION
	SELECT @ErrMsg = CASE @Language 
						WHEN 'E' THEN 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					END, @ErrCode = 115
	RETURN
END
	
---------------------------------------------------
--Update s4 to member level
UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK) 
SET	 sdiscount = @v151discount_51
FROM Dep_CustSetting3rd AS cs INNER JOIN custinfo AS c WITH (NOLOCK) ON cs.custid = c.custid
WHERE c.srecommend = @custid 
	AND c.recommend <> 52466
	AND c.roleid = 1 
	AND cs.bettype IN(51,52) 
	AND cs.sporttype = 151
IF (@@ERROR <> 0)
BEGIN
	ROLLBACK TRANSACTION
	SELECT @ErrMsg = CASE @Language 
						WHEN 'E' THEN 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					END, @ErrCode = 116	
	RETURN
END

--Update m3=s4 if m3>s4
UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK) 
SET adiscount = CASE WHEN cs.adiscount>@v152discount_41 THEN @v152discount_41 ELSE adiscount END 
FROM Dep_CustSetting3rd AS cs INNER JOIN custinfo AS c WITH (NOLOCK) ON cs.custid = c.custid
WHERE c.srecommend = @custid AND c.roleid = 3 AND cs.bettype IN (41,42) AND cs.sporttype = 152 
IF (@@ERROR <> 0)
BEGIN
	ROLLBACK TRANSACTION
	SELECT @ErrMsg = CASE @Language 
						WHEN 'E' THEN 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					END, @ErrCode = 117	
	RETURN
END

---------------------------------------------------
--Update a2=s4 if a2>s4
UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK) 
SET	discount = CASE WHEN cs.discount>@v152discount_41 THEN @v152discount_41 ELSE discount END 
FROM Dep_CustSetting3rd AS cs INNER JOIN custinfo AS c WITH (NOLOCK) ON cs.custid = c.custid
WHERE c.srecommend = @custid AND c.roleid = 2 AND cs.bettype IN(41,42) AND cs.sporttype = 152 
IF (@@ERROR <> 0)
BEGIN
	ROLLBACK TRANSACTION
	SELECT @ErrMsg = CASE @Language 
						WHEN 'E' THEN 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					END, @ErrCode = 118	
	RETURN
END
	
---------------------------------------------------
--Update s4 to member level
UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK) 
SET	 sdiscount = @v152discount_41
FROM Dep_CustSetting3rd AS cs INNER JOIN custinfo AS c WITH (NOLOCK) ON cs.custid = c.custid
WHERE c.srecommend = @custid 
	AND c.recommend <> 52466
	AND c.roleid = 1 
	AND cs.bettype IN(41,42) 
	AND cs.sporttype = 152
IF (@@ERROR <> 0)
BEGIN
	ROLLBACK TRANSACTION
	SELECT @ErrMsg = CASE @Language 
						WHEN 'E' THEN 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					END, @ErrCode = 119	
	RETURN
END

---------------------------------------------------
--Update m3=s4 if m3>s4
UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK) 
SET adiscount = CASE WHEN cs.adiscount>@v152discount_51 THEN @v152discount_51 ELSE adiscount END 
FROM Dep_CustSetting3rd AS cs INNER JOIN custinfo AS c WITH (NOLOCK) ON cs.custid = c.custid
WHERE c.srecommend = @custid AND c.roleid = 3 AND cs.bettype IN (51,52) AND cs.sporttype = 152 
IF (@@ERROR <> 0)
BEGIN
	ROLLBACK TRANSACTION
	SELECT @ErrMsg = CASE @Language 
						WHEN 'E' THEN 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					END, @ErrCode = 120	
	RETURN
END

---------------------------------------------------
--Update a2=s4 if a2>s4
UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK) 
SET	discount = CASE WHEN cs.discount>@v152discount_51 THEN @v152discount_51 ELSE discount END 
FROM Dep_CustSetting3rd AS cs INNER JOIN custinfo AS c WITH (NOLOCK) ON cs.custid = c.custid
WHERE c.srecommend = @custid AND c.roleid = 2 AND cs.bettype IN(51,52) AND cs.sporttype = 152 
IF (@@ERROR <> 0)
BEGIN
	ROLLBACK TRANSACTION
	SELECT @ErrMsg = CASE @Language 
						WHEN 'E' THEN 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					END, @ErrCode = 121	
	RETURN
END
	
---------------------------------------------------
--Update s4 to member level
UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK) 
SET	 sdiscount = @v152discount_51
FROM Dep_CustSetting3rd AS cs INNER JOIN custinfo AS c WITH (NOLOCK) ON cs.custid = c.custid
WHERE c.srecommend = @custid 
	AND c.recommend <> 52466
	AND c.roleid = 1 
	AND cs.bettype IN(51,52) 
	AND cs.sporttype = 152
IF (@@ERROR <> 0)
BEGIN
	ROLLBACK TRANSACTION
	SELECT @ErrMsg = CASE @Language 
						WHEN 'E' THEN 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					END, @ErrCode = 122	
	RETURN
END

---------------------------------------------------
--Update m3=s4 if m3>s4
UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK) 
SET adiscount = CASE WHEN cs.adiscount>@v153discount_51 THEN @v153discount_51 ELSE adiscount END 
FROM Dep_CustSetting3rd AS cs INNER JOIN custinfo AS c WITH (NOLOCK) ON cs.custid = c.custid
WHERE c.srecommend = @custid AND c.roleid = 3 AND cs.bettype IN (51,52) AND cs.sporttype = 153 
IF (@@ERROR <> 0)
BEGIN
	ROLLBACK TRANSACTION
	SELECT @ErrMsg = CASE @Language 
						WHEN 'E' THEN 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					END, @ErrCode = 123	
	RETURN
END

---------------------------------------------------
--Update a2=s4 if a2>s4
UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK) 
SET	discount = CASE WHEN cs.discount>@v153discount_51 THEN @v153discount_51 ELSE discount END 
FROM Dep_CustSetting3rd AS cs INNER JOIN custinfo AS c WITH (NOLOCK) ON cs.custid = c.custid
WHERE c.srecommend = @custid AND c.roleid = 2 AND cs.bettype IN(51,52) AND cs.sporttype = 153 
IF (@@ERROR <> 0)
BEGIN
	ROLLBACK TRANSACTION
	SELECT @ErrMsg = CASE @Language 
						WHEN 'E' THEN 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					END, @ErrCode = 124	
	RETURN
END
	
---------------------------------------------------
--Update s4 to member level
UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK) 
SET	 sdiscount = @v153discount_51
FROM Dep_CustSetting3rd AS cs INNER JOIN custinfo AS c WITH (NOLOCK) ON cs.custid = c.custid
WHERE c.srecommend = @custid 
	AND c.recommend <> 52466
	AND c.roleid = 1 
	AND cs.bettype IN(51,52) 
	AND cs.sporttype = 153
IF (@@ERROR <> 0)
BEGIN
	ROLLBACK TRANSACTION
	SELECT @ErrMsg = CASE @Language 
						WHEN 'E' THEN 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					END, @ErrCode = 125	
	RETURN
END

---------------------------------------------------
--At member level, update adiscount = sdiscount  if adiscount > sdiscount
UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK) 
SET adiscount = CASE WHEN cs.adiscount>cs.sdiscount THEN cs.sdiscount ELSE adiscount END 
FROM Dep_CustSetting3rd AS cs INNER JOIN custinfo AS c WITH (NOLOCK) ON cs.custid = c.custid
WHERE c.srecommend = @custid AND c.roleid = 1 AND sporttype IN (151,152,153)
--and cs.adiscount>cs.sdiscount
IF (@@ERROR <> 0)
BEGIN
	ROLLBACK TRANSACTION
	SELECT @ErrMsg = CASE @Language 
						WHEN 'E' THEN 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					END, @ErrCode = 126
	RETURN
END

---------------------------------------------------
--At member level, update discount = adiscount  if discount > adiscount
UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK) 
SET    discount = CASE WHEN cs.discount>cs.adiscount THEN adiscount ELSE discount END 
FROM Dep_CustSetting3rd AS cs INNER JOIN custinfo AS c WITH (NOLOCK) ON cs.custid = c.custid
WHERE c.srecommend = @custid AND c.roleid = 1 AND sporttype IN (151,152,153)
--and cs.discount>cs.adiscount
IF (@@ERROR <> 0)
BEGIN
	ROLLBACK TRANSACTION
	SELECT @ErrMsg = CASE @Language 
						WHEN 'E' THEN 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					END, @ErrCode = 127	
	RETURN
END

---------------------------------------------------
--At member level, leave the playerdiscount the value as it is
/*
UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK) 
SET    playerdiscount = CASE WHEN cs.playerdiscount>cs.discount THEN discount ELSE playerdiscount END 
FROM Dep_CustSetting3rd AS cs INNER JOIN custinfo AS c WITH (NOLOCK) ON cs.custid = c.custid
WHERE c.srecommend = @custid AND c.roleid = 1  AND sporttype IN (151,152,153)
-- and cs.playerdiscount>cs.discount
*/
IF (@@ERROR <> 0)
BEGIN
	ROLLBACK TRANSACTION
	SELECT @ErrMsg = CASE @Language 
						WHEN 'E' THEN 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					END, @ErrCode = 128	
	RETURN
END

---------------------------END HR COMM----------------------------------------
UPDATE CustSuper WITH (ROWLOCK, UPDLOCK)
	SET AutoIBCPositionTaking_Tote	= @v151IBCPositiontaking_31,
		AutoIBCPositionTaking_Fixed = @v151IBCPositiontaking_41,
		AutoIBCPT151_AU				= @v151IBCPositiontaking_51,
		AutoIBCPT152_UK				= @v152IBCPositiontaking_41,
		AutoIBCPT152_AU				= @v152IBCPositiontaking_51,
		AutoIBCPT153_AU				= @v153IBCPositiontaking_51
WHERE custid=@custid

if (@@error <> 0)
begin
	
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end	, @ErrCode = 104 
	return
end



EXEC Acc_Dep_CustomerUpdMemberVirtualSports_Com
	@CustID = @CustID, -- Super ID
	
	@v180MaxPerMatch = @v180MaxPerMatch,
	@v180MinBet = @v180MinBet,
	@v180MaxBet = @v180MaxBet,
	@v180sPositionTaking = @v180sPositionTaking,
	@v180mPositionTaking = @v180mPositionTaking,
	@v180aPositionTaking = @v180aPositionTaking,

	@v181MaxPerMatch = @v181MaxPerMatch,
	@v181MinBet = @v181MinBet,
	@v181MaxBet = @v181MaxBet,
	@v181sPositionTaking = @v181sPositionTaking,
	@v181mPositionTaking = @v181mPositionTaking,
	@v181aPositionTaking = @v181aPositionTaking,

	@v182MaxPerMatch = @v182MaxPerMatch,
	@v182MinBet = @v182MinBet,
	@v182MaxBet = @v182MaxBet,
	@v182sPositionTaking = @v182sPositionTaking,
	@v182mPositionTaking = @v182mPositionTaking,
	@v182aPositionTaking = @v182aPositionTaking,

	@v183MaxPerMatch = @v183MaxPerMatch,
	@v183MinBet = @v183MinBet,
	@v183MaxBet = @v183MaxBet,
	@v183sPositionTaking = @v183sPositionTaking,
	@v183mPositionTaking = @v183mPositionTaking,
	@v183aPositionTaking = @v183aPositionTaking,

	@v184MaxPerMatch = @v184MaxPerMatch,
	@v184MinBet = @v184MinBet,
	@v184MaxBet = @v184MaxBet,
	@v184sPositionTaking = @v184sPositionTaking,
	@v184mPositionTaking = @v184mPositionTaking,
	@v184aPositionTaking = @v184aPositionTaking,

	@v185MaxPerMatch = @v185MaxPerMatch,
	@v185MinBet = @v185MinBet,
	@v185MaxBet = @v185MaxBet,
	@v185sPositionTaking = @v185sPositionTaking,
	@v185mPositionTaking = @v185mPositionTaking,
	@v185aPositionTaking = @v185aPositionTaking,

	@v186MaxPerMatch = @v186MaxPerMatch,
	@v186MinBet = @v186MinBet,
	@v186MaxBet = @v186MaxBet,
	@v186sPositionTaking = @v186sPositionTaking,
	@v186mPositionTaking = @v186mPositionTaking,
	@v186aPositionTaking = @v186aPositionTaking,

	@UserID = @UserID,	
	@Language = @Language,
	@ErrCode = @ErrCode OUTPUT,
	@ErrMsg = @ErrMsg OUTPUT

IF @ErrCode <> 0 
	RETURN 

--Keno
--Check PT
--SELECT isnull(a.Bettype,0) Bettype,isnull(a.MaxPositiontaking,0) MaxPositiontaking,
--	   isnull(a.Maxsdiscount,0) Maxsdiscount,isnull(b.MinBet,0) MinBet
--INTO #MinMax_upline
--FROM dbo.ProductGlobalSetting a INNER JOIN dbo.ProductBetSetting b 
--on a.Bettype=b.Bettype
--WHERE b.Sporttype=202 AND b.Currency=@currency

--DECLARE @Bet MONEY
--IF EXISTS (SELECT TOP 1 1 
--			FROM #data a INNER JOIN #MinMax_upline b ON a.Bettype = b.Bettype 
--			WHERE a.Minbet < b.MinBet)
--BEGIN
--	SELECT @Bet=b.MinBet FROM #data a INNER JOIN #MinMax_upline b ON a.Bettype = b.Bettype 
--			WHERE a.Minbet < b.MinBet
--			ORDER BY a.bettype DESC
--	SELECT @ErrCode = 3,
--				@ErrMsg = CASE @Language 
--							WHEN 'E' THEN 'Min Bet must be greater than or equal '+coalesce(cast(@Bet as varchar(50)),space(1)) + '.'
--							ELSE [dbo].[f_Get_MsgNamebyMsgID](20001,@Language)
--						  END
--		RETURN
--END

--Update PT
UPDATE c SET
	c.spositiontaking=d.sPositionTaking,
	c.mpositiontaking=d.mPositionTaking,
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


--Update All 
--check exists real member
IF @UpdateAll = 1
BEGIN	
	CREATE TABLE #listUpdate (rowID INT primary key IDENTITY(1,1) NOT NULL, roleid int, SuperID INT,MasterID INT,AgentID INT)

	INSERT into #listUpdate (roleid,SuperID,MasterID,AgentID)
	SELECT roleid,srecommend,mrecommend,recommend 
	FROM custInfo WITH (NOLOCK)
	WHERE srecommend=@custid and roleid IN (3,2) and CHARINDEX('ACC',username) =0
	ORDER BY roleid DESC
	--use cursor

	DECLARE @MasterID INT,@AgentID INT,@RoleID tinyINT,@rownum INT,@k INT = 1
	SELECT @rownum = count(1) from #listUpdate
	
	WHILE (@k <= @rownum)
		BEGIN	
			select @MasterID=MasterID, @AgentID =AgentID, @RoleID=roleid  FROM #listUpdate where rowID=@k		
			IF @RoleID = 3
				BEGIN
					--update Master
																																								exec dbo.Acc_Dep_CustomerUpdMember_SAg 
					@custid  = @MasterID ,
					@UserID  = @UserID ,
					@minbetv1  = @minbetv1 ,
					@maxbetv1  = @maxbetv1 ,
					@maxpermatchv1  = @maxpermatchv1 ,
					@minbetv2  = @minbetv2 ,
					@maxbetv2  = @maxbetv2 ,
					@maxpermatchv2  = @maxpermatchv2 ,
					@minbetv3  = @minbetv3 ,
					@maxbetv3  = @maxbetv3 ,
					@maxpermatchv3  = @maxpermatchv3 ,
					@minbetv5  = @minbetv5 ,
					@maxbetv5  = @maxbetv5 ,
					@maxpermatchv5  = @maxpermatchv5 ,
					@minbetv8  = @minbetv8 ,
					@maxbetv8  = @maxbetv8 ,
					@maxpermatchv8  = @maxpermatchv8 ,
					@minbetv10  = @minbetv10 ,
					@maxbetv10  = @maxbetv10 ,
					@maxpermatchv10  = @maxpermatchv10 ,
					@minbetv11  = @minbetv11 ,
					@maxbetv11  = @maxbetv11 ,
					@maxpermatchv11  = @maxpermatchv11 ,
					@minbetv44  = @minbetv44 ,
					@maxbetv44  = @maxbetv44 ,
					@maxpermatchv44  = @maxpermatchv44 ,
					
					@minbetv99  = @minbetv99 ,
					@maxbetv99  = @maxbetv99 ,
					@maxpermatchv99  = @maxpermatchv99 ,
					@minbetv154  = @minbetv154 ,
					@maxbetv154  = @maxbetv154 ,
					@maxpermatchv154  = @maxpermatchv154 ,
					@minbetv99mp  = @minbetv99mp ,
					@maxbetv99mp  = @maxbetv99mp ,
					@maxpermatchv99mp  = @maxpermatchv99mp ,
					@minbetv161  = @minbetv161 ,
					@maxbetv161  = @maxbetv161 ,
					@maxpermatchv161  = @maxpermatchv161 ,
					@maxperballv161  = @maxperballv161 ,
					@v151minbet_31			 = @v151minbet_31,	
					@v151maxbet_31			 = @v151maxbet_31,	
					@v151maxpermatch_31		 = @v151maxbet_31,	

					@v151minbet_41			= @v151minbet_41,		
					@v151maxbet_41			= @v151maxbet_41,		
					@v151maxpermatch_41		= @v151maxpermatch_41,		
	
					@v151minbet_51			 = @v151minbet_51,
					@v151maxbet_51			 = @v151maxbet_51,
					@v151maxpermatch_51		 = @v151maxpermatch_51,

					@v152minbet_41		 = @v152minbet_41,
					@v152maxbet_41		 = @v152maxbet_41,
					@v152maxpermatch_41  = @v152maxpermatch_41 ,
	
					@v152minbet_51		 = @v152minbet_51,
					@v152maxbet_51		 = @v152maxbet_51,
					@v152maxpermatch_51  = @v152maxpermatch_51 ,
	
					@v153minbet_51		 = @v153minbet_51,
					@v153maxbet_51		 = @v153maxbet_51,
					@v153maxpermatch_51  = @v153maxpermatch_51 ,

					@v1spositiontaking_1  = @v1spositiontaking_1 ,
					@v1spositiontaking_2  = @v1spositiontaking_2 ,
					@v1spositiontaking_3  = @v1spositiontaking_3 ,
					@v1spositiontaking_4  = @v1spositiontaking_4 ,
					@v1spositiontaking_5  = @v1spositiontaking_5 ,
					@v1spositiontaking_6  = @v1spositiontaking_6 ,
					@v1spositiontaking_7  = @v1spositiontaking_7 ,
					@v1spositiontaking_8  = @v1spositiontaking_8 ,
					@v1spositiontaking_9  = @v1spositiontaking_9 ,
					@v1spositiontaking_10  = @v1spositiontaking_10 ,
					@v1slivepositiontaking_1  = @v1slivepositiontaking_1 ,
					@v1slivepositiontaking_3  = @v1slivepositiontaking_3 ,
					@v1slivepositiontaking_7  = @v1slivepositiontaking_7 ,
					@v1slivepositiontaking_8  = @v1slivepositiontaking_8 ,
	
					@v2spositiontaking_1  = @v2spositiontaking_1 ,
					@v2spositiontaking_2  = @v2spositiontaking_2 ,
					@v2spositiontaking_3  = @v2spositiontaking_3 ,
					@v2spositiontaking_7  = @v2spositiontaking_7 ,
					@v2spositiontaking_8  = @v2spositiontaking_8 ,
					@v2spositiontaking_20  = @v2spositiontaking_20 ,
	
					@v3spositiontaking_1  = @v3spositiontaking_1 ,
					@v3spositiontaking_2  = @v3spositiontaking_2 ,
					@v3spositiontaking_3  = @v3spositiontaking_3 ,
					@v3spositiontaking_20  = @v3spositiontaking_20 ,
	
					@v5spositiontaking_1  = @v5spositiontaking_1 ,
					@v5spositiontaking_2  = @v5spositiontaking_2 ,
					@v5spositiontaking_3  = @v5spositiontaking_3 ,
					@v5spositiontaking_20  = @v5spositiontaking_20 ,

					@v8spositiontaking_1  = @v8spositiontaking_1 ,
					@v8spositiontaking_3  = @v8spositiontaking_3 ,
					@v8spositiontaking_20  = @v8spositiontaking_20 ,

					@v10spositiontaking_1  = @v10spositiontaking_1 ,
					@v10spositiontaking_2  = @v10spositiontaking_2 ,
					@v10spositiontaking_3  = @v10spositiontaking_3 ,
					@v10spositiontaking_20  = @v10spositiontaking_20 ,

					@v11spositiontaking_1  = @v11spositiontaking_1 ,
					@v11spositiontaking_20  = @v11spositiontaking_20 ,
					
					@v44spositiontaking_3  = @v44spositiontaking_3 ,
					
					@v99spositiontaking_1  = @v99spositiontaking_1 ,
					@v99spositiontaking_2  = @v99spositiontaking_2 ,
					@v99spositiontaking_3  = @v99spositiontaking_3 ,
					@v99spositiontaking_20  = @v99spositiontaking_20 ,
					@v154spositiontaking_20  = @v154spositiontaking_20 ,

					@v99spositiontaking_9  = @v99spositiontaking_9 ,

					@v161spositiontaking_81  = @v161spositiontaking_81 ,
					@v161spositiontaking_83  = @v161spositiontaking_83 ,
					@v161spositiontaking_86  = @v161spositiontaking_86 ,
					@v161spositiontaking_88  = @v161spositiontaking_88 ,

					@v161slivepositiontaking_85  = @v161slivepositiontaking_85 ,
					@v161slivepositiontaking_86  = @v161slivepositiontaking_86 ,
					@v161slivepositiontaking_87	 = @v161slivepositiontaking_87,
					@v161slivepositiontaking_89	 = @v161slivepositiontaking_89,
					@v161slivepositiontaking_90	 = @v161slivepositiontaking_90,

					@v151spositiontaking_31  = @v151spositiontaking_31 ,
					@v151spositiontaking_32  = @v151spositiontaking_32 ,
					@v151spositiontaking_41  = @v151spositiontaking_41 ,
					@v151spositiontaking_42  = @v151spositiontaking_42 ,
	
					@v151spositiontaking_51  = @v151spositiontaking_51 ,
					@v151spositiontaking_52  = @v151spositiontaking_52 ,

					@v152spositiontaking_41  = @v152spositiontaking_41 ,
					@v152spositiontaking_42  = @v152spositiontaking_42 ,
					@v152spositiontaking_51  = @v152spositiontaking_51 ,
					@v152spositiontaking_52  = @v152spositiontaking_52 ,

					@v153spositiontaking_51  = @v153spositiontaking_51 ,
					@v153spositiontaking_52  = @v153spositiontaking_52 ,

					@v1mpositiontaking_1  = @v1mpositiontaking_1 ,
					@v1mpositiontaking_2  = @v1mpositiontaking_2 ,
					@v1mpositiontaking_3  = @v1mpositiontaking_3 ,
					@v1mpositiontaking_4  = @v1mpositiontaking_4 ,
					@v1mpositiontaking_5  = @v1mpositiontaking_5 ,
					@v1mpositiontaking_6  = @v1mpositiontaking_6 ,
					@v1mpositiontaking_7  = @v1mpositiontaking_7 ,
					@v1mpositiontaking_8  = @v1mpositiontaking_8 ,
					@v1mpositiontaking_9  = @v1mpositiontaking_9 ,
					@v1mpositiontaking_10  = @v1mpositiontaking_10 ,
					@v1mlivepositiontaking_1  = @v1mlivepositiontaking_1 ,
					@v1mlivepositiontaking_3  = @v1mlivepositiontaking_3 ,
					@v1mlivepositiontaking_7  = @v1mlivepositiontaking_7 ,
					@v1mlivepositiontaking_8  = @v1mlivepositiontaking_8 ,

					@v2mpositiontaking_1  = @v2mpositiontaking_1 ,
					@v2mpositiontaking_2  = @v2mpositiontaking_2 ,
					@v2mpositiontaking_3  = @v2mpositiontaking_3 ,
					@v2mpositiontaking_7  = @v2mpositiontaking_7 ,
					@v2mpositiontaking_8  = @v2mpositiontaking_8 ,
					@v2mpositiontaking_20  = @v2mpositiontaking_20 ,

					@v3mpositiontaking_1  = @v3mpositiontaking_1 ,
					@v3mpositiontaking_2  = @v3mpositiontaking_2 ,
					@v3mpositiontaking_3  = @v3mpositiontaking_3 ,
					@v3mpositiontaking_20  = @v3mpositiontaking_20 ,

					@v5mpositiontaking_1  = @v5mpositiontaking_1 ,
					@v5mpositiontaking_2  = @v5mpositiontaking_2 ,
					@v5mpositiontaking_3  = @v5mpositiontaking_3 ,
					@v5mpositiontaking_20  = @v5mpositiontaking_20 ,

					@v8mpositiontaking_1  = @v8mpositiontaking_1 ,
					@v8mpositiontaking_3  = @v8mpositiontaking_3 ,
					@v8mpositiontaking_20  = @v8mpositiontaking_20 ,

					@v10mpositiontaking_1  = @v10mpositiontaking_1 ,
					@v10mpositiontaking_2  = @v10mpositiontaking_2 ,
					@v10mpositiontaking_3  = @v10mpositiontaking_3 ,
					@v10mpositiontaking_20  = @v10mpositiontaking_20 ,

					@v11mpositiontaking_1  = @v11mpositiontaking_1 ,
					@v11mpositiontaking_20  = @v11mpositiontaking_20 ,
					
					@v44mpositiontaking_3  = @v44mpositiontaking_3 ,
					
					@v99mpositiontaking_1  = @v99mpositiontaking_1 ,
					@v99mpositiontaking_2  = @v99mpositiontaking_2 ,
					@v99mpositiontaking_3  = @v99mpositiontaking_3 ,
					@v99mpositiontaking_20  = @v99mpositiontaking_20 ,
					@v154mpositiontaking_20  = @v154mpositiontaking_20 ,

					@v99mpositiontaking_9  = @v99mpositiontaking_9 ,

					@v161mpositiontaking_81  = @v161mpositiontaking_81 ,
					@v161mpositiontaking_83  = @v161mpositiontaking_83 ,
					@v161mpositiontaking_86  = @v161mpositiontaking_86 ,
					@v161mpositiontaking_88  = @v161mpositiontaking_88 ,

					@v161mlivepositiontaking_85  = @v161mlivepositiontaking_85 ,
					@v161mlivepositiontaking_86  = @v161mlivepositiontaking_86 ,
					@v161mlivepositiontaking_87  = @v161mlivepositiontaking_87 ,
					@v161mlivepositiontaking_89  = @v161mlivepositiontaking_89 ,
					@v161mlivepositiontaking_90  = @v161mlivepositiontaking_90 ,

					@v151mpositiontaking_31  = @v151mpositiontaking_31 ,
					@v151mpositiontaking_32  = @v151mpositiontaking_32 ,
					@v151mpositiontaking_41  = @v151mpositiontaking_41 ,
					@v151mpositiontaking_42  = @v151mpositiontaking_42 ,

					@v151mpositiontaking_51  = @v151mpositiontaking_51 ,
					@v151mpositiontaking_52  = @v151mpositiontaking_52 ,

					@v152mpositiontaking_41  = @v152mpositiontaking_41 ,
					@v152mpositiontaking_42  = @v152mpositiontaking_42 ,
					@v152mpositiontaking_51  = @v152mpositiontaking_51 ,
					@v152mpositiontaking_52  = @v152mpositiontaking_52 ,

					@v153mpositiontaking_51  = @v153mpositiontaking_51 ,
					@v153mpositiontaking_52  = @v153mpositiontaking_52 ,

					@v151discount_31  = @v151discount_31 ,
					@v151discount_41  = @v151discount_41 ,

					@v151discount_51  = @v151discount_51 ,
					@v152discount_41  = @v152discount_41 ,
					@v152discount_51  = @v152discount_51 ,
					@v153discount_51  = @v153discount_51 ,

					--Virtual  = --Virtual ,
					@VirtualSportList  = @VirtualSportList ,

					@KenoList  = @KenoList ,
		
					@Language  = @Language ,
					@IP  = @IP ,
					@ErrCode  = @ErrCode ,
					@ErrMsg  = @ErrMsg 
				END 
			IF @RoleID = 2 -- update Agent
				BEGIN					
					 exec dbo.Acc_Dep_CustomerUpdMember_MAg 
					@custid  = @AgentID ,
					@UserID  = @UserID ,

					@minbetv1  = @minbetv1 ,
					@maxbetv1  = @maxbetv1 ,
					@maxpermatchv1  = @maxpermatchv1 ,
					@minbetv2  = @minbetv2 ,
					@maxbetv2  = @maxbetv2 ,
					@maxpermatchv2  = @maxpermatchv2 ,
					@minbetv3  = @minbetv3 ,
					@maxbetv3  = @maxbetv3 ,
					@maxpermatchv3  = @maxpermatchv3 ,
					@minbetv5  = @minbetv5 ,
					@maxbetv5  = @maxbetv5 ,
					@maxpermatchv5  = @maxpermatchv5 ,
					@minbetv8  = @minbetv8 ,
					@maxbetv8  = @maxbetv8 ,
					@maxpermatchv8  = @maxpermatchv8 ,
					@minbetv10  = @minbetv10 ,
					@maxbetv10  = @maxbetv10 ,
					@maxpermatchv10  = @maxpermatchv10 ,
					@minbetv11  = @minbetv11 ,
					@maxbetv11  = @maxbetv11 ,
					@maxpermatchv11  = @maxpermatchv11 ,
					@minbetv44  = @minbetv44 ,
					@maxbetv44  = @maxbetv44 ,
					@maxpermatchv44  = @maxpermatchv44 ,
					
					@minbetv99  = @minbetv99 ,
					@maxbetv99  = @maxbetv99 ,
					@maxpermatchv99  = @maxpermatchv99 ,
					@minbetv154  = @minbetv154 ,
					@maxbetv154  = @maxbetv154 ,
					@maxpermatchv154  = @maxpermatchv154 ,
					@minbetv99mp  = @minbetv99mp ,
					@maxbetv99mp  = @maxbetv99mp ,
					@maxpermatchv99mp  = @maxpermatchv99mp ,
					@minbetv161  = @minbetv161 ,
					@maxbetv161  = @maxbetv161 ,
					@maxpermatchv161  = @maxpermatchv161 ,
					@maxperballv161  = @maxperballv161 ,
					@v151minbet_31			 = @v151minbet_31,	
					@v151maxbet_31			 = @v151maxbet_31,	
					@v151maxpermatch_31		 = @v151maxbet_31,	

					@v151minbet_41			= @v151minbet_41,		
					@v151maxbet_41			= @v151maxbet_41,		
					@v151maxpermatch_41		= @v151maxpermatch_41,		
	
					@v151minbet_51			 = @v151minbet_51,
					@v151maxbet_51			 = @v151maxbet_51,
					@v151maxpermatch_51		 = @v151maxpermatch_51,

					@v152minbet_41		 = @v152minbet_41,
					@v152maxbet_41		 = @v152maxbet_41,
					@v152maxpermatch_41  = @v152maxpermatch_41 ,
	
					@v152minbet_51		 = @v152minbet_51,
					@v152maxbet_51		 = @v152maxbet_51,
					@v152maxpermatch_51  = @v152maxpermatch_51 ,
	
					@v153minbet_51		 = @v153minbet_51,
					@v153maxbet_51		 = @v153maxbet_51,
					@v153maxpermatch_51  = @v153maxpermatch_51 ,

					@v1apositiontaking_1  = @v1apositiontaking_1 ,
					@v1apositiontaking_2  = @v1apositiontaking_2 ,
					@v1apositiontaking_3  = @v1apositiontaking_3 ,
					@v1apositiontaking_4  = @v1apositiontaking_4 ,
					@v1apositiontaking_5  = @v1apositiontaking_5 ,
					@v1apositiontaking_6  = @v1apositiontaking_6 ,
					@v1apositiontaking_7  = @v1apositiontaking_7 ,
					@v1apositiontaking_8  = @v1apositiontaking_8 ,
					@v1apositiontaking_9  = @v1apositiontaking_9 ,
					@v1apositiontaking_10  = @v1apositiontaking_10 ,

					@v1alivepositiontaking_1  = @v1alivepositiontaking_1 ,
					@v1alivepositiontaking_3  = @v1alivepositiontaking_3 ,
					@v1alivepositiontaking_7  = @v1alivepositiontaking_7 ,
					@v1alivepositiontaking_8  = @v1alivepositiontaking_8 ,
	
					@v2apositiontaking_1  = @v2apositiontaking_1 ,
					@v2apositiontaking_2  = @v2apositiontaking_2 ,
					@v2apositiontaking_3  = @v2apositiontaking_3 ,
					@v2apositiontaking_7  = @v2apositiontaking_7 ,
					@v2apositiontaking_8  = @v2apositiontaking_8 ,
					@v2apositiontaking_20  = @v2apositiontaking_20 ,
	
					@v3apositiontaking_1  = @v3apositiontaking_1 ,
					@v3apositiontaking_2  = @v3apositiontaking_2 ,
					@v3apositiontaking_3  = @v3apositiontaking_3 ,
					@v3apositiontaking_20  = @v3apositiontaking_20 ,
	
					@v5apositiontaking_1  = @v5apositiontaking_1 ,
					@v5apositiontaking_2  = @v5apositiontaking_2 ,
					@v5apositiontaking_3  = @v5apositiontaking_3 ,
					@v5apositiontaking_20  = @v5apositiontaking_20 ,

					@v8apositiontaking_1  = @v8apositiontaking_1 ,
					@v8apositiontaking_3  = @v8apositiontaking_3 ,
					@v8apositiontaking_20  = @v8apositiontaking_20 ,

					@v10apositiontaking_1  = @v10apositiontaking_1 ,
					@v10apositiontaking_2  = @v10apositiontaking_2 ,
					@v10apositiontaking_3  = @v10apositiontaking_3 ,
					@v10apositiontaking_20  = @v10apositiontaking_20 ,

					@v11apositiontaking_1  = @v11apositiontaking_1 ,
					@v11apositiontaking_20  = @v11apositiontaking_20 ,
					
					@v44apositiontaking_3  = @v44apositiontaking_3 ,
					
					@v99apositiontaking_1  = @v99apositiontaking_1 ,
					@v99apositiontaking_2  = @v99apositiontaking_2 ,
					@v99apositiontaking_3  = @v99apositiontaking_3 ,
					@v99apositiontaking_20  = @v99apositiontaking_20 ,
					@v154apositiontaking_20  = @v154apositiontaking_20 ,

					@v99apositiontaking_9  = @v99apositiontaking_9 ,

					@v161apositiontaking_81  = @v161apositiontaking_81 ,
					@v161apositiontaking_83  = @v161apositiontaking_83 ,
					@v161apositiontaking_86  = @v161apositiontaking_86 ,
					@v161apositiontaking_88  = @v161apositiontaking_88 ,

					@v161alivepositiontaking_85  = @v161alivepositiontaking_85 ,
					@v161alivepositiontaking_86  = @v161alivepositiontaking_86 ,
					@v161alivepositiontaking_87	 = @v161alivepositiontaking_87,
					@v161alivepositiontaking_89	 = @v161alivepositiontaking_89,
					@v161alivepositiontaking_90	 = @v161alivepositiontaking_90,

					@v151apositiontaking_31  = @v151apositiontaking_31 ,
					@v151apositiontaking_32  = @v151apositiontaking_32 ,
					@v151apositiontaking_41  = @v151apositiontaking_41 ,
					@v151apositiontaking_42  = @v151apositiontaking_42 ,
	
					@v151apositiontaking_51  = @v151apositiontaking_51 ,
					@v151apositiontaking_52  = @v151apositiontaking_52 ,

					@v152apositiontaking_41  = @v152apositiontaking_41 ,
					@v152apositiontaking_42  = @v152apositiontaking_42 ,
					@v152apositiontaking_51  = @v152apositiontaking_51 ,
					@v152apositiontaking_52  = @v152apositiontaking_52 ,

					@v153apositiontaking_51  = @v153apositiontaking_51 ,
					@v153apositiontaking_52  = @v153apositiontaking_52 ,

					@v1mpositiontaking_1  = @v1mpositiontaking_1 ,
					@v1mpositiontaking_2  = @v1mpositiontaking_2 ,
					@v1mpositiontaking_3  = @v1mpositiontaking_3 ,
					@v1mpositiontaking_4  = @v1mpositiontaking_4 ,
					@v1mpositiontaking_5  = @v1mpositiontaking_5 ,
					@v1mpositiontaking_6  = @v1mpositiontaking_6 ,
					@v1mpositiontaking_7  = @v1mpositiontaking_7 ,
					@v1mpositiontaking_8  = @v1mpositiontaking_8 ,
					@v1mpositiontaking_9  = @v1mpositiontaking_9 ,
					@v1mpositiontaking_10  = @v1mpositiontaking_10 ,
					@v1mlivepositiontaking_1  = @v1mlivepositiontaking_1 ,
					@v1mlivepositiontaking_3  = @v1mlivepositiontaking_3 ,
					@v1mlivepositiontaking_7  = @v1mlivepositiontaking_7 ,
					@v1mlivepositiontaking_8  = @v1mlivepositiontaking_8 ,

					@v2mpositiontaking_1  = @v2mpositiontaking_1 ,
					@v2mpositiontaking_2  = @v2mpositiontaking_2 ,
					@v2mpositiontaking_3  = @v2mpositiontaking_3 ,
					@v2mpositiontaking_7  = @v2mpositiontaking_7 ,
					@v2mpositiontaking_8  = @v2mpositiontaking_8 ,
					@v2mpositiontaking_20  = @v2mpositiontaking_20 ,

					@v3mpositiontaking_1  = @v3mpositiontaking_1 ,
					@v3mpositiontaking_2  = @v3mpositiontaking_2 ,
					@v3mpositiontaking_3  = @v3mpositiontaking_3 ,
					@v3mpositiontaking_20  = @v3mpositiontaking_20 ,

					@v5mpositiontaking_1  = @v5mpositiontaking_1 ,
					@v5mpositiontaking_2  = @v5mpositiontaking_2 ,
					@v5mpositiontaking_3  = @v5mpositiontaking_3 ,
					@v5mpositiontaking_20  = @v5mpositiontaking_20 ,

					@v8mpositiontaking_1  = @v8mpositiontaking_1 ,
					@v8mpositiontaking_3  = @v8mpositiontaking_3 ,
					@v8mpositiontaking_20  = @v8mpositiontaking_20 ,

					@v10mpositiontaking_1  = @v10mpositiontaking_1 ,
					@v10mpositiontaking_2  = @v10mpositiontaking_2 ,
					@v10mpositiontaking_3  = @v10mpositiontaking_3 ,
					@v10mpositiontaking_20  = @v10mpositiontaking_20 ,

					@v11mpositiontaking_1  = @v11mpositiontaking_1 ,
					@v11mpositiontaking_20  = @v11mpositiontaking_20 ,
					
					@v44mpositiontaking_3  = @v44mpositiontaking_3 ,
					
					@v99mpositiontaking_1  = @v99mpositiontaking_1 ,
					@v99mpositiontaking_2  = @v99mpositiontaking_2 ,
					@v99mpositiontaking_3  = @v99mpositiontaking_3 ,
					@v99mpositiontaking_20  = @v99mpositiontaking_20 ,
					@v154mpositiontaking_20  = @v154mpositiontaking_20 ,

					@v99mpositiontaking_9  = @v99mpositiontaking_9 ,

					@v161mpositiontaking_81  = @v161mpositiontaking_81 ,
					@v161mpositiontaking_83  = @v161mpositiontaking_83 ,
					@v161mpositiontaking_86  = @v161mpositiontaking_86 ,
					@v161mpositiontaking_88  = @v161mpositiontaking_88 ,

					@v161mlivepositiontaking_85  = @v161mlivepositiontaking_85 ,
					@v161mlivepositiontaking_86  = @v161mlivepositiontaking_86 ,
					@v161mlivepositiontaking_87  = @v161mlivepositiontaking_87 ,
					@v161mlivepositiontaking_89  = @v161mlivepositiontaking_89 ,
					@v161mlivepositiontaking_90  = @v161mlivepositiontaking_90 ,

					@v151mpositiontaking_31  = @v151mpositiontaking_31 ,
					@v151mpositiontaking_32  = @v151mpositiontaking_32 ,
					@v151mpositiontaking_41  = @v151mpositiontaking_41 ,
					@v151mpositiontaking_42  = @v151mpositiontaking_42 ,

					@v151mpositiontaking_51  = @v151mpositiontaking_51 ,
					@v151mpositiontaking_52  = @v151mpositiontaking_52 ,

					@v152mpositiontaking_41  = @v152mpositiontaking_41 ,
					@v152mpositiontaking_42  = @v152mpositiontaking_42 ,
					@v152mpositiontaking_51  = @v152mpositiontaking_51 ,
					@v152mpositiontaking_52  = @v152mpositiontaking_52 ,

					@v153mpositiontaking_51  = @v153mpositiontaking_51 ,
					@v153mpositiontaking_52  = @v153mpositiontaking_52 ,

					@v151discount_31  = @v151discount_31 ,
					@v151discount_41  = @v151discount_41 ,

					@v151discount_51  = @v151discount_51 ,
					@v152discount_41  = @v152discount_41 ,
					@v152discount_51  = @v152discount_51 ,
					@v153discount_51  = @v153discount_51 ,

					--Virtual  = --Virtual ,
					@VirtualSportList  = @VirtualSportList ,

					@KenoList  = @KenoList ,
		
					@Language  = @Language ,
					@IP  = @IP ,
					@ErrCode  = @ErrCode ,
					@ErrMsg  = @ErrMsg 
				END
			set @k=@k+1
		END		
	DROP TABLE #listUpdate
END 

set @endRun = getdate()
set @duration  = datediff (millisecond,@startRun,@endRun)
-- Write log
Declare @LogSPData varchar(Max)
Declare @LogSPData2 varchar(Max)

--Write log
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

Select @LogSPData ='<Acc_Dep_CustomerUpdMember_Com> ' +
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
'/>' +
'<Keno '+
@str_bet+
'/>' +
'</Acc_Dep_CustomerUpdMember_Com>'

--SELECT TOP 1 @LogSPData2=ISNULL(TrackingValue,0) 
--FROM DBLOG.bodb_CustomerLog.dbo.UserLog_RunSP WITH (NOLOCK)
--WHERE Custid=@CustID AND ActionID=2012
--ORDER BY logid DESC

--IF @LogSPData2 IS NULL
BEGIN
	DECLARE @sql varchar (MAX)
	DECLARE @TEXT varchar (4000) =''
	SELECT @sql='<Acc_Dep_CustomerUpdMember_Com> ' +
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
	select @sql = @sql + '</Acc_Dep_CustomerUpdMember_Com>'
	SET @LogSPData2=@sql
END

EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP 
	@UserID = @UserID,
	@CustID = @CustID,
	@ActionID = 2012,
	@TrackingValue = @LogSPData,
	@TrackingValue2 = @LogSPData2,
	@duration = @duration

--Write PT log
SELECT @LogSPData = '<Acc_Dep_CustomerUpdMember_Com><info custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +
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
'v161slivept_90="'+ COALESCE(CONVERT(VARCHAR(50),@v161slivepositiontaking_90,2),SPACE(1)) +'" ' +
@str_spt+
'v180spt="'+ COALESCE(CAST(@v180sPositionTaking AS VARCHAR(50)),SPACE(1)) +'" ' +
'v181spt="'+ COALESCE(CAST(@v181sPositionTaking AS VARCHAR(50)),SPACE(1)) +'" ' +
'v182spt="'+ COALESCE(CAST(@v182sPositionTaking AS VARCHAR(50)),SPACE(1)) +'" ' +
'v183spt="'+ COALESCE(CAST(@v183sPositionTaking AS VARCHAR(50)),SPACE(1)) +'" ' +
'v184spt="'+ COALESCE(CAST(@v184sPositionTaking AS VARCHAR(50)),SPACE(1)) +'" ' +
'v185spt="'+ COALESCE(CAST(@v185sPositionTaking AS VARCHAR(50)),SPACE(1)) +'" ' +
'v186spt="'+ COALESCE(CAST(@v186sPositionTaking AS VARCHAR(50)),SPACE(1)) +'" />' +


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
'</Acc_Dep_CustomerUpdMember_Com>' 

--tracking value old
DECLARE @pt_SB smallMoney,@pt_NG smallmoney,@pt_VS smallmoney,@pt_KN smallmoney
select top 1 @pt_SB=spt FROM #data_old where Sporttype=1 AND Bettype =1 and islive =0
select top 1 @pt_NG=spt FROM #data_old where Sporttype=161 AND Bettype =81 and islive =0
select top 1 @pt_VS=spt FROM #data_old where Sporttype=180 AND  islive =0
select top 1 @pt_KN=spt FROM #data_old where Sporttype=202 AND Bettype =1501 and islive =0
--write log keno
DECLARE @str_spt_ varchar(1000)='',
		@str_mpt_ varchar(1000)='',
		@str_apt_ varchar(1000)=''
set @i =1501
WHILE (@i<=@j)
BEGIN
	select @str_spt_=@str_spt_ + 'v202spt_' +CAST(Bettype AS VARCHAR(50))+'="'+CAST(@pt_KN AS VARCHAR(50))+'" ',
		   @str_mpt_=@str_mpt_ + 'v202mpt_' +CAST(Bettype AS VARCHAR(50))+'="'+CAST(@pt_KN AS VARCHAR(50))+'" ',
		   @str_apt_=@str_apt_ + 'v202apt_' +CAST(Bettype AS VARCHAR(50))+'="'+CAST(@pt_KN AS VARCHAR(50))+'" '
	from #data where Bettype=@i
	set @i=@i+1
END
SELECT @LogSPData2 = '<Acc_Dep_CustomerUpdMember_Com><info custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +
'UserID="'+ coalesce(cast(@UserID as varchar(50)),space(1)) + '" ' +
'Language="'+ coalesce(cast(@Language as varchar(2)),space(1)) + '" ' +
'IP="'+ coalesce(cast(@IP as varchar(15)),space(1)) + '" ' +
'ErrCode="'+ coalesce(cast(@ErrCode as varchar(50)),space(1)) + '" ' +
'ErrMsg="'+ coalesce(cast(@ErrMsg as varchar(5000)),space(1)) + '" />' +

'<s spt_1="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'spt_2="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'spt_3="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'spt_4="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'spt_5="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'spt_6="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'spt_7="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'spt_8="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'spt_9="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'spt_10="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'slivept_1="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'slivept_3="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'slivept_7="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'slivept_8="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +

'v2spt_1="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v2spt_2="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v2spt_3="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v2spt_7="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v2spt_8="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v2spt_20="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +

'v3spt_1="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v3spt_2="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v3spt_3="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v3spt_20="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +

'v5spt_1="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v5spt_2="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v5spt_3="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v5spt_20="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +

'v8spt_1="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v8spt_3="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v8spt_20="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +

'v10spt_1="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v10spt_2="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v10spt_3="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v10spt_20="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +

'v11spt_1="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v11spt_20="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +

'v44spt_3="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +

'v99spt_1="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v99spt_2="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v99spt_3="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v99spt_9="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +
'v99spt_20="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +

'v154spt_20="'+ COALESCE(CAST(@pt_SB AS VARCHAR(50)),SPACE(1)) + '" ' +

'v161spt_81="'+ COALESCE(CONVERT(VARCHAR(50),@pt_NG,2),SPACE(1)) + '" ' +
'v161spt_83="'+ COALESCE(CONVERT(VARCHAR(50),@pt_NG,2),SPACE(1)) + '" ' +
'v161spt_86="'+ COALESCE(CONVERT(VARCHAR(50),@pt_NG,2),SPACE(1)) + '" ' +
'v161spt_88="'+ COALESCE(CONVERT(VARCHAR(50),@pt_NG,2),SPACE(1)) + '" ' +
'v161slivept_85="'+ COALESCE(CONVERT(VARCHAR(50),@pt_NG,2),SPACE(1)) + '" ' +
'v161slivept_86="'+ COALESCE(CONVERT(VARCHAR(50),@pt_NG,2),SPACE(1)) + '" ' +
'v161slivept_87="'+ COALESCE(CONVERT(VARCHAR(50),@pt_NG,2),SPACE(1)) + '" ' +
'v161slivept_89="'+ COALESCE(CONVERT(VARCHAR(50),@pt_NG,2),SPACE(1)) + '" ' +
'v161slivept_90="'+ COALESCE(CONVERT(VARCHAR(50),@pt_NG,2),SPACE(1)) +'" ' +
--old
@str_spt_ + 
'v180spt="'+ COALESCE(CAST(@pt_VS AS VARCHAR(50)),SPACE(1)) +'" ' +
'v181spt="'+ COALESCE(CAST(@pt_VS AS VARCHAR(50)),SPACE(1)) +'" ' +
'v182spt="'+ COALESCE(CAST(@pt_VS AS VARCHAR(50)),SPACE(1)) +'" ' +
'v183spt="'+ COALESCE(CAST(@pt_VS AS VARCHAR(50)),SPACE(1)) +'" ' +
'v184spt="'+ COALESCE(CAST(@pt_VS AS VARCHAR(50)),SPACE(1)) +'" ' +
'v185spt="'+ COALESCE(CAST(@pt_VS AS VARCHAR(50)),SPACE(1)) +'" ' +
'v186spt="'+ COALESCE(CAST(@pt_VS AS VARCHAR(50)),SPACE(1)) +'" />' +

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
'</Acc_Dep_CustomerUpdMember_Com>'

EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP 
	@UserID = @UserID,
	@CustID = @CustID,
	@ActionID = 2709,
	@TrackingValue = @LogSPData,
	@TrackingValue2 = @LogSPData2,
	@duration = @duration

Select @LogSPData = '<Acc_Dep_CustomerUpdMember_Com custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +
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
select @v151discount_31_=SupRBDiscount FROM #data_old WHERE custid=@custID and sporttype = 151 AND bettype =31
select @v151discount_41_=SupRBDiscount FROM #data_old WHERE custid=@custID and sporttype = 151 AND bettype =41
select @v151discount_51_=SupRBDiscount FROM #data_old WHERE custid=@custID and sporttype = 151 AND bettype =51
select @v152discount_41_=SupRBDiscount FROM #data_old WHERE custid=@custID and sporttype = 152 AND bettype =41
select @v152discount_51_=SupRBDiscount FROM #data_old WHERE custid=@custID and sporttype = 152 AND bettype =51
select @v153discount_51_=SupRBDiscount FROM #data_old WHERE custid=@custID and sporttype = 153 AND bettype =51

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
	@ActionID = 2606,
	@TrackingValue = @LogSPData,
	@TrackingValue2 = @LogSPData2,
	@duration = @duration

DROP TABLE #data
--DROP TABLE #MinMax_upline
drop TABLE #data_old