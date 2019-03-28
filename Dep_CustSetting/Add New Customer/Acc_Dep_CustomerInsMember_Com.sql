/*<info serverAlias="DBCust-CustDB" executers="bodbadminNet,bodbDownlineNet,bodbExtAccNet" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_CustomerInsMember_Com]
(
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


	--Number game
	@MinBetv161 MONEY,
	@MaxBetv161 MONEY,
	@MaxPerMatchv161 MONEY,
	@MaxPerBallv161 MONEY = 0,
	
	
	
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

	@DisableNumber BIT = 0,

	--Keno
	@KenoList VARCHAR(4000)='',
	@DisableKeno BIT = 0,
	--------------------------------

	@DisableCasinoBonus BIT = 1,
	
	@IP VARCHAR(15)='',
	@Language VARCHAR(2)= 'E',
	@ErrCode INT = 0 OUTPUT,
	@ErrMsg NVARCHAR(2000) = '' OUTPUT
)	
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
    - 20170302@Helen: Betradar Virtual Sports  -Integration for Cash [Redmine: 77274]
    - 20170808@Winnie: Change Data Type of Sporttype [RedmineID: #73545]	
    - 20180125@Winnie: Hide inactive products [RedmineID: #86086]
	- 20181002@Dominic: Check existing username/username2 in archived DB  [Redmine:99882]  
	- 20190326@Winnie: Update PT of Sportsbook for All Licensee. [RedmineID: #110111]
Param's Explanation:
• @ErrCode:
    = 0: Create super successfully.
    > 0: Specific Error.
  
• @ErrMsg: Error description.

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
		OR EXISTS(SELECT 1 FROM Dep_Customer_Archived WITH (NOLOCK) WHERE username= @username)
		OR EXISTS (SELECT 1 FROM Dep_Customer_Archived WITH (NOLOCK) WHERE username2 = @username)
	BEGIN
		SELECT @ErrMsg = CASE @Language 
							WHEN 'E' THEN 'This username is not available.'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](40001,@Language)
						END
		SELECT @ErrCode = 101		
		RETURN
	END

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
		
		@matchlimit = 1,
		--20150309@Johnson: disable virtual rate as default
		@virtualmultiplier = 0,	
		
		@DisableNumber = @DisableNumber,
		@DisableCasino = 0,
	
		@DisableCasinoBonus = @DisableCasinoBonus,

		
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

	--v161
		SELECT @custid, 81, 161, @v161apositiontaking_81, @v161mpositiontaking_81, @v161spositiontaking_81, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 0--nonlive
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
	
		DELETE CustGameType WITH(ROWLOCK) WHERE Custid = @custid
		DELETE CustSettingGame WITH(ROWLOCK) WHERE Custid = @custid
		DELETE CustOverrideGame WITH(ROWLOCK) WHERE Custid = @custid
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

		--Write status log
	SELECT @LogSPData = '<Acc_Dep_CustomerInsMember_Com custid="'+ COALESCE(CAST(@custid AS VARCHAR(50)),SPACE(1)) + '" ' +	
	'disablenumber="'+ COALESCE(CAST(@disablenumber AS VARCHAR(1)),SPACE(1)) + '" />'
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

	

	'MinBv99MP="'+ COALESCE(CAST(@MinBetv99MP AS VARCHAR(50)),SPACE(1)) + '" ' +
	'MaxBv99MP="'+ COALESCE(CAST(@MaxBetv99MP AS VARCHAR(50)),SPACE(1)) + '" ' +
	'MPMv99MP="'+ COALESCE(CAST(@MaxPerMatchv99MP AS VARCHAR(50)),SPACE(1)) + '" ' +
	'MinBv161="'+ COALESCE(CAST(@MinBetv161 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'MaxBv161="'+ COALESCE(CAST(@MaxBetv161 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'MPMv161="'+ COALESCE(CAST(@MaxPerMatchv161 AS VARCHAR(50)),SPACE(1)) + '" ' +
	'MPBv161="' + COALESCE(CAST(@MaxPerBallv161 AS VARCHAR(50)),SPACE(1)) + '" ' +
	
	 @str_bet+ ' />' 

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

	
	@str_spt+ ' />' +
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

	
	@str_mpt + ' />' +

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

	@str_apt + ' />' + '</Acc_Dep_CustomerInsMember_Com>' 


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
GO
GRANT EXECUTE ON [dbo].[Acc_Dep_CustomerInsMember_Com] TO [bodbAdminNet] AS [dbo]
GO