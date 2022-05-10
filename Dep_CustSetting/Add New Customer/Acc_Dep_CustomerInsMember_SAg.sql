/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet,Dot_member" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_CustomerInsMember_SAg]
	@custid int OUTPUT,
	@creator int,
	@username varchar(30),
	@userpwd varchar(40)  = '123qwe',
	@srecommend int,-- Super ID
	@DisableNumber bit = 0,


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
	
	@minbetv99 money,
	@maxbetv99 money,
	@maxpermatchv99 money,
		
	@minbetv1mp money = 0,
	@maxbetv1mp money = 0,
	@maxpermatchv1mp money = 0,
	
	@minbetv99mp money = 0,
	@maxbetv99mp money = 0,
	@maxpermatchv99mp money = 0,

	@minbetv161 money = 0,				
	@maxbetv161 money = 0,
	@maxpermatchv161 money = 0,	

	@maxperballv161 money = 0,


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


	
	@Language varchar(2)= 'E',
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
	
	@v99mpositiontaking_1 smallmoney = 0,
	@v99mpositiontaking_2 smallmoney = 0,
	@v99mpositiontaking_3 smallmoney = 0,		
	@v99mpositiontaking_20 smallmoney = 0,

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

	--Keno	
	@KenoList VARCHAR(4000)='',
	@DisableKeno BIT = 0,

	@IP varchar(15)='',
	@ErrCode int = 0 OUTPUT,
	@ErrMsg nvarchar(4000) = '' OUTPUT
	
AS
--@Source Control
/*
Created: 20120320@Dom
Task : Super creates Master
DB: DBTRANS.bodb02
Original:

Revisions:
    - 20121128@Elodie: Get an error message from f_Get_MsgNameByMsgID function by language
    - 20130604@Daniel: Change default P2P param value to "Disable P2P"
    - 20130607@Daniel: Exclude created member from Balance checking
    - 20130731@Elodie: Apply progressive bonus
	- 20130919@Don: Supporting save log of Number Game PT with format such as "0.995", "0.925", ...
	- 20131014@Francis: Support adding new virtual sports with settings via XML param
    - 20131108@Elodie: Splitting bodb02 into CustDB (call sports, bettype by link database)	
	- 20140505@Florent: Add sport HR Fix Odds
	- 20140512@Florent: Add keno
	- 20150309@Johnson: Disable virtual rate as default [RedmineID: #31927]
	- 20150609@David: Separate CustDB to DBCUST server (Use temp table for sports, bettype, GameType table, call some SPs by link server)
	- 20151028@Jim:Implement Muay's Setting for Deposit Customer [Redmine: #45491]
	- 20160830@Winnie: #63151  Add ColossusBet Agent commRate
	- 20170302@Helen: Betradar Virtual Sports  -Integration for Cash [Redmine: 77274]
	- 20170808@Winnie: Change Data Type of Sporttype [RedmineID: #73545]	
	- 20180125@Winnie: Hide inactive products [RedmineID: #86086]
	- 20180326@Winnie: Customer Setting - urgent fix to support for long bettype name. [RedmineID: #91216]
	- 20181002@Dominic: Check existing username/username2 in archived DB  [Redmine:99882]
	- 20190422@Elodie: Offer unique nickname for CN88 [Redmine:112287]
	- 20190429@Elodie: Insert VR setting get from Upline for new customer [RedmineID: #112657]
	- 20190726@Winnie: Remove Muay Thai. [RedmineID: #117501]
	- 20190905@Eden: 3rd party products - Remove InActive Products Phase 2 [Redmine: #118699]
	- 20200622@Johnson: add Soccer Parlay bet limit [redmine: #135261]
	- 20201214@Winfred: Adjust PT value with 4 decimal places for SB  [redmine: #146574]
	- 20220112@Eden: LAP - RNG Casino - Implement DCS Settings [Redmine: #166217] 
	
Param's Explanation:
• @ErrCode:
    = 0: Create master successfully.
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
	--SELECT @v161slivepositiontaking_90 = 0,
	--		@v161mlivepositiontaking_90 = 0
	/********************************
	Set default value master super PT
	*********************************/
	SELECT @v1spositiontaking_1			= 0,
		@v1spositiontaking_2			= 0,
		@v1spositiontaking_3			= 0,
		@v1spositiontaking_4			= 0,
		@v1spositiontaking_5			= 0,
		@v1spositiontaking_6			= 0,
		@v1spositiontaking_7			= 0,
		@v1spositiontaking_8			= 0,
		@v1spositiontaking_9			= 0,
		@v1spositiontaking_10			= 0,
		@v1slivepositiontaking_1		= 0,
		@v1slivepositiontaking_3		= 0,
		@v1slivepositiontaking_7		= 0,
		@v1slivepositiontaking_8		= 0,
		@v2spositiontaking_1			= 0,
		@v2spositiontaking_2			= 0,
		@v2spositiontaking_3			= 0,
		@v2spositiontaking_7			= 0,
		@v2spositiontaking_8			= 0,
		@v2spositiontaking_20			= 0,
		@v3spositiontaking_1			= 0,
		@v3spositiontaking_2			= 0,
		@v3spositiontaking_3			= 0,
		@v3spositiontaking_20			= 0,
		@v5spositiontaking_1			= 0,
		@v5spositiontaking_2			= 0,
		@v5spositiontaking_3			= 0,
		@v5spositiontaking_20			= 0,
		@v8spositiontaking_1			= 0,
		@v8spositiontaking_3			= 0,
		@v8spositiontaking_20			= 0,
		@v10spositiontaking_1			= 0,
		@v10spositiontaking_2			= 0,
		@v10spositiontaking_3			= 0,
		@v10spositiontaking_20			= 0,
		@v11spositiontaking_1			= 0,
		@v11spositiontaking_20			= 0,
	
		@v99spositiontaking_1			= 0,
		@v99spositiontaking_2			= 0,
		@v99spositiontaking_3			= 0,
		@v99spositiontaking_20			= 0,
		@v99spositiontaking_9			= 0,

		@v161spositiontaking_81			= 0, 				
		@v161spositiontaking_83			= 0,
		@v161spositiontaking_86			= 0,
		@v161spositiontaking_88			= 0,
		@v161slivepositiontaking_85		= 0,
		@v161slivepositiontaking_86		= 0,
		@v161slivepositiontaking_87		= 0,
		@v161slivepositiontaking_89		= 0,
		@v161slivepositiontaking_90		= 0
		
		
	declare @startRun datetime
	declare @endRun datetime
	declare @duration int
	set @startRun = getdate()

	--Check an account disabled or not 
	EXEC dbo.Acc_CustomerSelCheckEnable @custid = @srecommend, @ErrCode=@ErrCode output,@ErrMsg=@ErrMsg output 
	if @ErrCode <>0		return 

	declare 
		@transcode bigint, @currency int, @pwdexpiry datetime,
		@MinMinBet money, @MaxMaxBet money, @MaxMaxPerMatch money,
		@MinMinBetv2 money, @MaxMaxBetv2 money, @MaxMaxPerMatchv2 money,
		@MinMinBetv3 money, @MaxMaxBetv3 money, @MaxMaxPerMatchv3 money,
		@MinMinBetv5 money, @MaxMaxBetv5 money, @MaxMaxPerMatchv5 money,
		@MinMinBetv8 money, @MaxMaxBetv8 money, @MaxMaxPerMatchv8 money,
		@MinMinBetv10 money, @MaxMaxBetv10 money, @MaxMaxPerMatchv10 money,
		@MinMinBetv11 money, @MaxMaxBetv11 money, @MaxMaxPerMatchv11 money,
		
		@MinMinBetv99 money, @MaxMaxBetv99 money, @MaxMaxPerMatchv99 money,		
		@MinMinBetv1mp money, @MaxMaxBetv1mp money, @MaxMaxPerMatchv1MP money,
		@MinMinBetv99mp money, @MaxMaxBetv99mp money, @MaxMaxPerMatchv99MP money,
		@MinMinBetv161 money, @MaxMaxBetv161 money, @MaxMaxPerMatchv161 money,
		@MaxMaxPerBallv161 money,
		
		@RoleID_SAg tinyint, @matchlimit smallmoney,
		@TransferOption_dec tinyint,
		@DisableOutright bit,
		
		@Ssuspended bit,
		@UplineClosed bit,
		
		@max_spositiontaking_1 smallmoney,
		@max_spositiontaking_2 smallmoney,
		@max_spositiontaking_3 smallmoney,
		@max_spositiontaking_4 smallmoney,
		@max_spositiontaking_5 smallmoney,
		@max_spositiontaking_6 smallmoney,
		@max_spositiontaking_7 smallmoney,
		@max_spositiontaking_8 smallmoney,
		@max_spositiontaking_9 smallmoney,
		@max_spositiontaking_10 smallmoney,
		@max_slivepositiontaking_1 smallmoney,
		@max_slivepositiontaking_3 smallmoney,
		@max_slivepositiontaking_7 smallmoney,
		@max_slivepositiontaking_8 smallmoney,

		@max_v2spositiontaking_1 smallmoney,
		@max_v2spositiontaking_2 smallmoney,
		@max_v2spositiontaking_3 smallmoney,
		@max_v2spositiontaking_7 smallmoney,
		@max_v2spositiontaking_8 smallmoney,
		@max_v2spositiontaking_20 smallmoney,
		
		@max_v3spositiontaking_1 smallmoney,
		@max_v3spositiontaking_2 smallmoney,
		@max_v3spositiontaking_3 smallmoney,	
		@max_v3spositiontaking_20 smallmoney,
		
		@max_v5spositiontaking_1 smallmoney,
		@max_v5spositiontaking_2 smallmoney,
		@max_v5spositiontaking_3 smallmoney,	
		@max_v5spositiontaking_20 smallmoney,
		
		@max_v8spositiontaking_1 smallmoney,	
		@max_v8spositiontaking_3 smallmoney,	
		@max_v8spositiontaking_20 smallmoney,
		
		@max_v10spositiontaking_1 smallmoney,
		@max_v10spositiontaking_2 smallmoney,
		@max_v10spositiontaking_3 smallmoney,	
		@max_v10spositiontaking_20 smallmoney,
		
		@max_v11spositiontaking_1 smallmoney,	
		@max_v11spositiontaking_20 smallmoney,
			
		@max_v99spositiontaking_1 smallmoney,
		@max_v99spositiontaking_2 smallmoney,
		@max_v99spositiontaking_3 smallmoney,		
		@max_v99spositiontaking_20 smallmoney,
	
		@max_v99spositiontaking_9 smallmoney,

		@max_v161spositiontaking_81 smallmoney,							
		@max_v161spositiontaking_83 smallmoney,
		@max_v161spositiontaking_86 smallmoney,
		@max_v161spositiontaking_88 smallmoney,
		
		@max_v161slivepositiontaking_85 smallmoney,
		@max_v161slivepositiontaking_86 smallmoney,
		@max_v161slivepositiontaking_87 smallmoney,
		@max_v161slivepositiontaking_89 smallmoney,
		@max_v161slivepositiontaking_90 smallmoney,

		@site varchar(50),
		@VirtualMultiplier SMALLMONEY

	DECLARE @ErrType varchar(4000)	
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	--select @username = replace(@username, ' ', '')
	select @username = rtrim(ltrim(@username))

	select 
		@currency = currency,
		@Ssuspended = reject,
		@UplineClosed = closed,
		
		@MaxMaxPerMatch = isnull(MaxPerMatch, 0),
		@MaxMaxPerMatchv2 = isnull(MaxPerMatch2, 0),
		@MaxMaxPerMatchv3 = isnull(MaxPerMatch3, 0),
		@MaxMaxPerMatchv5 = isnull(MaxPerMatch5, 0),
		@MaxMaxPerMatchv8 = isnull(MaxPerMatch8, 0),
		@MaxMaxPerMatchv10 = isnull(MaxPerMatch10, 0),
		@MaxMaxPerMatchv11 = isnull(MaxPerMatch11, 0),
	
		@MaxMaxPerMatchv99 = isnull(MaxPerMatch99, 0),
		
		@MaxMaxPerMatchv161 = isnull(MaxPerMatch161, 0),
		@MaxMaxPerMatchv1MP = isnull(MaxPerMatch1MP, 0),
		@MaxMaxPerMatchv99MP = isnull(MaxPerMatch99MP, 0),
		@MaxMaxPerBallv161 = isnull(MaxPerBall161, 0),

		@matchlimit = matchlimit,
		@DisableNumber = case when ci.DisableNumber = 1 then 1 else @DisableNumber end,
		@DisableOutright = DisableOutright,
		
		@VirtualMultiplier = ci.VirtualMultiplier
	from CustInfo as ci with (NOLOCK) 
	where CustID = @srecommend

	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	declare @IsValid bit
	select @IsValid = 0
	Select @ErrCode = 0
	EXEC dbo.Acc_Dep_CustomerInsMember_SAg_CheckParam 
			@minbet = @minbetv1,
			@maxbet = @maxbetv1,
			@maxpermatch = @maxpermatchv1,
			@minbetv2 = @minbetv2,
			@maxbetv2 = @maxbetv2,
			@maxpermatchv2 = @maxpermatchv2,
			@minbetv3 = @minbetv3,
			@maxbetv3 = @maxbetv3,
			@maxpermatchv3 = @maxpermatchv3,
			@minbetv5 = @minbetv5,
			@maxbetv5 = @maxbetv5,
			@maxpermatchv5 = @maxpermatchv5,
			@minbetv8 = @minbetv8,
			@maxbetv8 = @maxbetv8,
			@maxpermatchv8 = @maxpermatchv8,
			@minbetv10 = @minbetv10,
			@maxbetv10 = @maxbetv10,
			@maxpermatchv10 = @maxpermatchv10,
			@minbetv11 = @minbetv11,
			@maxbetv11 = @maxbetv11,
			@maxpermatchv11 = @maxpermatchv11,
			
			@minbetv99 = @minbetv99,
			@maxbetv99 = @maxbetv99,
			@maxpermatchv99 = @maxpermatchv99,
			
			@minbetv1mp = @minbetv1mp,
			@maxbetv1mp = @maxbetv1mp,
			@maxpermatchv1mp = @maxpermatchv1mp,
			
			@minbetv99mp = @minbetv99mp,
			@maxbetv99mp = @maxbetv99mp,
			@maxpermatchv99mp = @maxpermatchv99mp,

			@minbetv161 = @minbetv161,
			@maxbetv161 = @maxbetv161,
			@maxpermatchv161 = @maxpermatchv161,

			@maxperballv161 = @maxperballv161,

			@srecommend = @srecommend,
			@spositiontaking_1 = @v1spositiontaking_1,
			@spositiontaking_2 = @v1spositiontaking_2,
			@spositiontaking_3 = @v1spositiontaking_3,
			@spositiontaking_4 = @v1spositiontaking_4,
			@spositiontaking_5 = @v1spositiontaking_5,
			@spositiontaking_6 = @v1spositiontaking_6,
			@spositiontaking_7 = @v1spositiontaking_7,
			@spositiontaking_8 = @v1spositiontaking_8,
			@spositiontaking_9 = @v1spositiontaking_9,
			@spositiontaking_10 = @v1spositiontaking_10,
			@slivepositiontaking_1 = @v1slivepositiontaking_1,
			@slivepositiontaking_3 = @v1slivepositiontaking_3,
			@slivepositiontaking_7 = @v1slivepositiontaking_7,
			@slivepositiontaking_8 = @v1slivepositiontaking_8,
			@v2spositiontaking_1 = @v2spositiontaking_1,
			@v2spositiontaking_2 = @v2spositiontaking_2,
			@v2spositiontaking_3 = @v2spositiontaking_3,
			@v2spositiontaking_7 = @v2spositiontaking_7,
			@v2spositiontaking_8 = @v2spositiontaking_8,
			@v2spositiontaking_20 = @v2spositiontaking_20,
			@v3spositiontaking_1 = @v3spositiontaking_1,
			@v3spositiontaking_2 = @v3spositiontaking_2,
			@v3spositiontaking_3 = @v3spositiontaking_3,
			@v3spositiontaking_20 = @v3spositiontaking_20,
			@v5spositiontaking_1 = @v5spositiontaking_1,
			@v5spositiontaking_2 = @v5spositiontaking_2,
			@v5spositiontaking_3 = @v5spositiontaking_3,
			@v5spositiontaking_20 = @v5spositiontaking_20,
			@v8spositiontaking_1 = @v8spositiontaking_1,
			@v8spositiontaking_3 = @v8spositiontaking_3,
			@v8spositiontaking_20 = @v8spositiontaking_20,
			@v10spositiontaking_1 = @v10spositiontaking_1,
			@v10spositiontaking_2 = @v10spositiontaking_2,
			@v10spositiontaking_3 = @v10spositiontaking_3,
			@v10spositiontaking_20 = @v10spositiontaking_20,
			@v11spositiontaking_1 = @v11spositiontaking_1,
			@v11spositiontaking_20 = @v11spositiontaking_20,
		
			@v99spositiontaking_1 = @v99spositiontaking_1,
			@v99spositiontaking_2 = @v99spositiontaking_2,
			@v99spositiontaking_3 = @v99spositiontaking_3,		
			@v99spositiontaking_20 = @v99spositiontaking_20,
			@v99spositiontaking_9 = @v99spositiontaking_9,

		
			@v161spositiontaking_81 = @v161spositiontaking_81,
			@v161spositiontaking_83 = @v161spositiontaking_83,
			@v161spositiontaking_86 = @v161spositiontaking_86,
			@v161spositiontaking_88 = @v161spositiontaking_88,
			
			@v161slivepositiontaking_85 = @v161slivepositiontaking_85,
			@v161slivepositiontaking_86 = @v161slivepositiontaking_86,
			@v161slivepositiontaking_87 = @v161slivepositiontaking_87,
			@v161slivepositiontaking_89 = @v161slivepositiontaking_89,
			@v161slivepositiontaking_90 = @v161slivepositiontaking_90,

			@mpositiontaking_1 = @v1mpositiontaking_1,
			@mpositiontaking_2 = @v1mpositiontaking_2,
			@mpositiontaking_3 = @v1mpositiontaking_3,
			@mpositiontaking_4 = @v1mpositiontaking_4,
			@mpositiontaking_5 = @v1mpositiontaking_5,
			@mpositiontaking_6 = @v1mpositiontaking_6,
			@mpositiontaking_7 = @v1mpositiontaking_7,
			@mpositiontaking_8 = @v1mpositiontaking_8,
			@mpositiontaking_9 = @v1mpositiontaking_9,
			@mpositiontaking_10 = @v1mpositiontaking_10,
			@mlivepositiontaking_1 = @v1mlivepositiontaking_1,
			@mlivepositiontaking_3 = @v1mlivepositiontaking_3,
			@mlivepositiontaking_7 = @v1mlivepositiontaking_7,
			@mlivepositiontaking_8 = @v1mlivepositiontaking_8,
			@v2mpositiontaking_1 = @v2mpositiontaking_1,
			@v2mpositiontaking_2 = @v2mpositiontaking_2,
			@v2mpositiontaking_3 = @v2mpositiontaking_3,
			@v2mpositiontaking_7 = @v2mpositiontaking_7,
			@v2mpositiontaking_8 = @v2mpositiontaking_8,
			@v2mpositiontaking_20 = @v2mpositiontaking_20,
			@v3mpositiontaking_1 = @v3mpositiontaking_1,
			@v3mpositiontaking_2 = @v3mpositiontaking_2,
			@v3mpositiontaking_3 = @v3mpositiontaking_3,
			@v3mpositiontaking_20 = @v3mpositiontaking_20,
			@v5mpositiontaking_1 = @v5mpositiontaking_1,
			@v5mpositiontaking_2 = @v5mpositiontaking_2,
			@v5mpositiontaking_3 = @v5mpositiontaking_3,
			@v5mpositiontaking_20 = @v5mpositiontaking_20,
			@v8mpositiontaking_1 = @v8mpositiontaking_1,
			@v8mpositiontaking_3 = @v8mpositiontaking_3,
			@v8mpositiontaking_20 = @v8mpositiontaking_20,
			@v10mpositiontaking_1 = @v10mpositiontaking_1,
			@v10mpositiontaking_2 = @v10mpositiontaking_2,
			@v10mpositiontaking_3 = @v10mpositiontaking_3,
			@v10mpositiontaking_20 = @v10mpositiontaking_20,
			@v11mpositiontaking_1 = @v11mpositiontaking_1,
			@v11mpositiontaking_20 = @v11mpositiontaking_20,
			
		
			@v99mpositiontaking_1 = @v99mpositiontaking_1,
			@v99mpositiontaking_2 = @v99mpositiontaking_2,
			@v99mpositiontaking_3 = @v99mpositiontaking_3,		
			@v99mpositiontaking_20 = @v99mpositiontaking_20,

		

			@v99mpositiontaking_9 = @v99mpositiontaking_9,

			@v161mpositiontaking_81 = @v161mpositiontaking_81,
			@v161mpositiontaking_83 = @v161mpositiontaking_83,
			@v161mpositiontaking_86 = @v161mpositiontaking_86,
			@v161mpositiontaking_88 = @v161mpositiontaking_88,
			
			@v161mlivepositiontaking_85 = @v161mlivepositiontaking_85,
			@v161mlivepositiontaking_86 = @v161mlivepositiontaking_86,
			@v161mlivepositiontaking_87 = @v161mlivepositiontaking_87,
			@v161mlivepositiontaking_89 = @v161mlivepositiontaking_89,
			@v161mlivepositiontaking_90 = @v161mlivepositiontaking_90,

			@isvalid = @isvalid OUTPUT,
			@errmsg = @errmsg OUTPUT,
			@errcode = @errcode OUTPUT,
			@language = @language
	if @IsValid = 0
	BEGIN
		RETURN
	END
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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

	SELECT @ErrType = ''
	SELECT @ErrType = @ErrType + CASE WHEN b.sporttype = 1 AND MP = 1 THEN 'Soccer Parlay' ELSE sports.name END + ', '
	from #tmp_Sports sports inner join
	(
					select 1 as sporttype, 0 MP,  @minbetv1 as minbet, @maxbetv1 as maxbet, @maxpermatchv1 as maxpermatch
		union all	select 1 as sporttype, 1 MP, @minbetv1mp as minbet, @maxbetv1mp as maxbet, @maxpermatchv1mp as maxpermatch
		union all	select 2 as sporttype, 0 MP, @minbetv2 as minbet, @maxbetv2 as maxbet, @maxpermatchv2 as maxpermatch
		union all	select 3 as sporttype, 0 MP, @minbetv3 as minbet, @maxbetv3 as maxbet, @maxpermatchv3 as maxpermatch
		union all	select 5 as sporttype, 0 MP, @minbetv5 as minbet, @maxbetv5 as maxbet, @maxpermatchv5 as maxpermatch
		union all	select 8 as sporttype, 0 MP, @minbetv8 as minbet, @maxbetv8 as maxbet, @maxpermatchv8 as maxpermatch
		union all	select 10 as sporttype, 0 MP, @minbetv10 as minbet, @maxbetv10 as maxbet, @maxpermatchv10 as maxpermatch
		union all	select 11 as sporttype, 0 MP, @minbetv11 as minbet, @maxbetv11 as maxbet, @maxpermatchv11 as maxpermatch
		
		union all	select 99 as sporttype, 0 MP, @minbetv99 as minbet, @maxbetv99 as maxbet, @maxpermatchv99 as maxpermatch	 
		 
		union all	select 99 as sporttype, 0 MP, @minbetv99mp as minbet, @maxbetv99mp as maxbet, @maxpermatchv99mp as maxpermatch
		union all   select 161 as sporttype, 0 MP, @minbetv161 as minbet, @maxbetv161 as maxbet, @maxpermatchv161 as maxpermatch
	) as b on sports.ID = b.sporttype
	where (minbet>maxbet) 
	or (maxbet>maxpermatch) 
	or (minbet>maxpermatch) 

	if @ErrType <>''
	BEGIN
		select @ErrType = left(@ErrType,len(@ErrType)-1)
		SELECT
			@ErrMsg =	case @Language 
								when 'E' then 'Min Bet must be less than Max Bet and Max Bet must be less than Max Per Match ('+@ErrType+').'
								ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language) + ' ('+@ErrType+').'
						end
											
		Select @ErrCode = 103
		return
	END

	select @max_spositiontaking_1 = spositiontaking from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=1 and sporttype=1 and islive = 0
	select @max_slivepositiontaking_1 = spositiontaking from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=1 and sporttype=1 and islive = 1

	select @max_spositiontaking_3 = spositiontaking from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=3 and sporttype=1 and islive = 0
	select @max_slivepositiontaking_3 = spositiontaking from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=3 and sporttype=1 and islive = 1

	select @max_spositiontaking_7 = spositiontaking from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=7 and sporttype=1 and islive = 0
	select @max_slivepositiontaking_7 = spositiontaking from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=7 and sporttype=1 and islive = 1

	select @max_spositiontaking_8 = spositiontaking from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=8 and sporttype=1 and islive = 0
	select @max_slivepositiontaking_8 = spositiontaking from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=8 and sporttype=1 and islive = 1

	select @max_spositiontaking_2 = spositiontaking from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=2 and sporttype=1 and islive = 0
	select @max_spositiontaking_4 = spositiontaking from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=4 and sporttype=1 and islive = 0
	select @max_spositiontaking_5 = spositiontaking from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=5 and sporttype=1 and islive = 0
	select @max_spositiontaking_6 = spositiontaking from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=6 and sporttype=1 and islive = 0
	select @max_spositiontaking_9 = spositiontaking from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=9 and sporttype=1 and islive = 0
	select @max_spositiontaking_10 = spositiontaking from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=10 and sporttype=1 and islive = 0

	select @max_v2spositiontaking_1 = spositiontaking from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=1 and sporttype=2 and islive = 0
	select @max_v2spositiontaking_2 = spositiontaking from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=2 and sporttype=2 and islive = 0
	select @max_v2spositiontaking_3 = spositiontaking from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=3 and sporttype=2 and islive = 0

	select @max_v2spositiontaking_20 = spositiontaking from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=20 and sporttype=2 and islive = 0

	select @max_v3spositiontaking_1 = spositiontaking from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=1 and sporttype=3 and islive = 0
	select @max_v3spositiontaking_2 = spositiontaking from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=2 and sporttype=3 and islive = 0
	select @max_v3spositiontaking_3 = spositiontaking from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=3 and sporttype=3 and islive = 0
	select @max_v3spositiontaking_20 = spositiontaking from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=20 and sporttype=3 and islive = 0

	select @max_v5spositiontaking_1 = spositiontaking from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=1 and sporttype=5 and islive = 0
	select @max_v5spositiontaking_2 = spositiontaking from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=2 and sporttype=5 and islive = 0
	select @max_v5spositiontaking_3 = spositiontaking from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=3 and sporttype=5 and islive = 0
	select @max_v5spositiontaking_20 = spositiontaking from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=20 and sporttype=5 and islive = 0

	select @max_v8spositiontaking_1 = spositiontaking from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=1 and sporttype=8 and islive = 0
	select @max_v8spositiontaking_3 = spositiontaking from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=3 and sporttype=8 and islive = 0
	select @max_v8spositiontaking_20 = spositiontaking from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=20 and sporttype=8 and islive = 0

	select @max_v10spositiontaking_1 = spositiontaking from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=1 and sporttype=10 and islive = 0
	select @max_v10spositiontaking_2 = spositiontaking from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=2 and sporttype=10 and islive = 0
	select @max_v10spositiontaking_3 = spositiontaking from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=3 and sporttype=10 and islive = 0
	select @max_v10spositiontaking_20 = spositiontaking from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=20 and sporttype=10 and islive = 0

	select @max_v11spositiontaking_1 = spositiontaking from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=1 and sporttype=11 and islive = 0
	select @max_v11spositiontaking_20 = spositiontaking from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=20 and sporttype=11 and islive = 0	

	select @max_v99spositiontaking_1 = spositiontaking from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=1 and sporttype=99 and islive = 0
	select @max_v99spositiontaking_2 = spositiontaking from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=2 and sporttype=99 and islive = 0
	select @max_v99spositiontaking_3 = spositiontaking from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=3 and sporttype=99 and islive = 0
	select @max_v99spositiontaking_20 = spositiontaking from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=20 and sporttype=99 and islive = 0


	select @max_v99spositiontaking_9 = spositiontaking from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=9 and sporttype=99 and islive = 0

	select @max_v161spositiontaking_81 = spositiontaking from Dep_CustSetting3rd with(nolock) where custid = @srecommend and bettype = 81 and sporttype = 161 and islive = 0
	select @max_v161spositiontaking_83 = spositiontaking from Dep_CustSetting3rd with(nolock) where custid = @srecommend and bettype = 83 and sporttype = 161 and islive = 0
	select @max_v161spositiontaking_88 = spositiontaking from Dep_CustSetting3rd with(nolock) where custid = @srecommend and bettype = 88 and sporttype = 161 and islive = 0
	select @max_v161slivepositiontaking_85 = spositiontaking from Dep_CustSetting3rd with(nolock) where custid = @srecommend and bettype = 85 and sporttype = 161  and islive = 1
	select @max_v161spositiontaking_86 = spositiontaking from Dep_CustSetting3rd with(nolock) where custid = @srecommend and bettype = 86 and sporttype = 161 and islive = 0
	select @max_v161slivepositiontaking_86 = spositiontaking from Dep_CustSetting3rd with(nolock) where custid = @srecommend and bettype = 86 and sporttype = 161 and islive = 1
	select @max_v161slivepositiontaking_87 = spositiontaking from Dep_CustSetting3rd with(nolock) where custid = @srecommend and bettype = 87 and sporttype = 161 and islive = 1
	select @max_v161slivepositiontaking_89 = spositiontaking from Dep_CustSetting3rd with(nolock) where custid = @srecommend and bettype = 89 and sporttype = 161 and islive = 1
	select @max_v161slivepositiontaking_90 = spositiontaking from Dep_CustSetting3rd with(nolock) where custid = @srecommend and bettype = 90 and sporttype = 161 and islive = 1


	--check s3+m3<=s4
	select @ErrType = ''
	select @ErrType = @ErrType + sports.Name + '-' + sports.Name + '-Max:'+ cast((max_spositiontaking) as varchar(10))
		+ case when b.sporttype in (1,161) and b.bettype in (1,3,7,8,85,86,87,89) then '--Live:'+ cast((max_slivepositiontaking) as varchar(10)) else '' end + '<br>'
	from #tmp_Sports sports inner join
	(
					select 1 as bettype, 1 as sporttype, @v1spositiontaking_1 as spositiontaking, @v1slivepositiontaking_1 as slivepositiontaking, @v1mpositiontaking_1 as mpositiontaking, @v1mlivepositiontaking_1 as mlivepositiontaking, @max_spositiontaking_1 as max_spositiontaking,  @max_slivepositiontaking_1 as max_slivepositiontaking
		union all 	select 3 as bettype, 1 as sporttype, @v1spositiontaking_3 as spositiontaking, @v1slivepositiontaking_3 as slivepositiontaking, @v1mpositiontaking_3 as mpositiontaking, @v1mlivepositiontaking_3 as mlivepositiontaking, @max_spositiontaking_3 as max_spositiontaking,  @max_slivepositiontaking_3 as max_slivepositiontaking
		union all 	select 7 as bettype, 1 as sporttype, @v1spositiontaking_7 as spositiontaking, @v1slivepositiontaking_7 as slivepositiontaking, @v1mpositiontaking_7 as mpositiontaking, @v1mlivepositiontaking_7 as mlivepositiontaking, @max_spositiontaking_7 as max_spositiontaking,  @max_slivepositiontaking_7 as max_slivepositiontaking
		union all 	select 8 as bettype, 1 as sporttype, @v1spositiontaking_8 as spositiontaking, @v1slivepositiontaking_8 as slivepositiontaking, @v1mpositiontaking_8 as mpositiontaking, @v1mlivepositiontaking_8 as mlivepositiontaking, @max_spositiontaking_8 as max_spositiontaking,  @max_slivepositiontaking_8 as max_slivepositiontaking
		union all 	select 2 as bettype, 1 as sporttype, @v1spositiontaking_2 as spositiontaking, 0 as slivepositiontaking, @v1mpositiontaking_2 as mpositiontaking, 0 as mlivepositiontaking, @max_spositiontaking_2 as max_spositiontaking,  0 as max_slivepositiontaking
		union all 	select 4 as bettype, 1 as sporttype, @v1spositiontaking_4 as spositiontaking, 0 as slivepositiontaking, @v1mpositiontaking_4 as mpositiontaking, 0 as mlivepositiontaking, @max_spositiontaking_4 as max_spositiontaking,  0 as max_slivepositiontaking
		union all 	select 5 as bettype, 1 as sporttype, @v1spositiontaking_5 as spositiontaking, 0 as slivepositiontaking, @v1mpositiontaking_5 as mpositiontaking, 0 as mlivepositiontaking, @max_spositiontaking_5 as max_spositiontaking,  0 as max_slivepositiontaking
		union all 	select 6 as bettype, 1 as sporttype, @v1spositiontaking_6 as spositiontaking, 0 as slivepositiontaking, @v1mpositiontaking_6 as mpositiontaking, 0 as mlivepositiontaking, @max_spositiontaking_6 as max_spositiontaking,  0 as max_slivepositiontaking
		union all 	select 9 as bettype, 1 as sporttype, @v1spositiontaking_9 as spositiontaking, 0 as slivepositiontaking, @v1mpositiontaking_9 as mpositiontaking, 0 as mlivepositiontaking, @max_spositiontaking_9 as max_spositiontaking,  0 as max_slivepositiontaking
		union all 	select 10 as bettype, 1 as sporttype, @v1spositiontaking_10 as spositiontaking, 0 as slivepositiontaking, @v1mpositiontaking_10 as mpositiontaking, 0 as mlivepositiontaking, @max_spositiontaking_10 as max_spositiontaking,  0 as max_slivepositiontaking

		union all 	select 1 as bettype, 2 as sporttype, @v2spositiontaking_1 as spositiontaking, 0 as slivepositiontaking, @v2mpositiontaking_1 as mpositiontaking, 0 as mlivepositiontaking, @max_v2spositiontaking_1 as max_spositiontaking,  0 as max_slivepositiontaking
		union all 	select 2 as bettype, 2 as sporttype, @v2spositiontaking_2 as spositiontaking, 0 as slivepositiontaking, @v2mpositiontaking_2 as mpositiontaking, 0 as mlivepositiontaking, @max_v2spositiontaking_2 as max_spositiontaking,  0 as max_slivepositiontaking
		union all 	select 3 as bettype, 2 as sporttype, @v2spositiontaking_3 as spositiontaking, 0 as slivepositiontaking, @v2mpositiontaking_3 as mpositiontaking, 0 as mlivepositiontaking, @max_v2spositiontaking_3 as max_spositiontaking,  0 as max_slivepositiontaking

		union all 	select 20 as bettype, 2 as sporttype, @v2spositiontaking_20 as spositiontaking, 0 as slivepositiontaking, @v2mpositiontaking_20 as mpositiontaking, 0 as mlivepositiontaking, @max_v2spositiontaking_20 as max_spositiontaking,  0 as max_slivepositiontaking

		union all 	select 1 as bettype, 3 as sporttype, @v3spositiontaking_1 as spositiontaking, 0 as slivepositiontaking, @v3mpositiontaking_1 as mpositiontaking, 0 as mlivepositiontaking, @max_v3spositiontaking_1 as max_spositiontaking,  0 as max_slivepositiontaking
		union all 	select 2 as bettype, 3 as sporttype, @v3spositiontaking_2 as spositiontaking, 0 as slivepositiontaking, @v3mpositiontaking_2 as mpositiontaking, 0 as mlivepositiontaking, @max_v3spositiontaking_2 as max_spositiontaking,  0 as max_slivepositiontaking
		union all 	select 3 as bettype, 3 as sporttype, @v3spositiontaking_3 as spositiontaking, 0 as slivepositiontaking, @v3mpositiontaking_3 as mpositiontaking, 0 as mlivepositiontaking, @max_v3spositiontaking_3 as max_spositiontaking,  0 as max_slivepositiontaking
		union all 	select 20 as bettype, 3 as sporttype, @v3spositiontaking_20 as spositiontaking, 0 as slivepositiontaking, @v3mpositiontaking_20 as mpositiontaking, 0 as mlivepositiontaking, @max_v3spositiontaking_20 as max_spositiontaking,  0 as max_slivepositiontaking
		
		union all 	select 1 as bettype, 5 as sporttype, @v5spositiontaking_1 as spositiontaking, 0 as slivepositiontaking, @v5mpositiontaking_1 as mpositiontaking, 0 as mlivepositiontaking, @max_v5spositiontaking_1 as max_spositiontaking,  0 as max_slivepositiontaking
		union all 	select 2 as bettype, 5 as sporttype, @v5spositiontaking_2 as spositiontaking, 0 as slivepositiontaking, @v5mpositiontaking_2 as mpositiontaking, 0 as mlivepositiontaking, @max_v5spositiontaking_2 as max_spositiontaking,  0 as max_slivepositiontaking
		union all 	select 3 as bettype, 5 as sporttype, @v5spositiontaking_3 as spositiontaking, 0 as slivepositiontaking, @v5mpositiontaking_3 as mpositiontaking, 0 as mlivepositiontaking, @max_v5spositiontaking_3 as max_spositiontaking,  0 as max_slivepositiontaking
		union all 	select 20 as bettype, 5 as sporttype, @v5spositiontaking_20 as spositiontaking, 0 as slivepositiontaking, @v5mpositiontaking_20 as mpositiontaking, 0 as mlivepositiontaking, @max_v5spositiontaking_20 as max_spositiontaking,  0 as max_slivepositiontaking
		
		union all 	select 1 as bettype, 8 as sporttype, @v8spositiontaking_1 as spositiontaking, 0 as slivepositiontaking, @v8mpositiontaking_1 as mpositiontaking, 0 as mlivepositiontaking, @max_v8spositiontaking_1 as max_spositiontaking,  0 as max_slivepositiontaking
		union all 	select 3 as bettype, 8 as sporttype, @v8spositiontaking_3 as spositiontaking, 0 as slivepositiontaking, @v8mpositiontaking_3 as mpositiontaking, 0 as mlivepositiontaking, @max_v8spositiontaking_3 as max_spositiontaking,  0 as max_slivepositiontaking
		union all 	select 20 as bettype, 8 as sporttype, @v8spositiontaking_20 as spositiontaking, 0 as slivepositiontaking, @v8mpositiontaking_20 as mpositiontaking, 0 as mlivepositiontaking, @max_v8spositiontaking_20 as max_spositiontaking,  0 as max_slivepositiontaking
		
		union all 	select 1 as bettype, 10 as sporttype, @v10spositiontaking_1 as spositiontaking, 0 as slivepositiontaking, @v10mpositiontaking_1 as mpositiontaking, 0 as mlivepositiontaking, @max_v10spositiontaking_1 as max_spositiontaking,  0 as max_slivepositiontaking
		union all 	select 2 as bettype, 10 as sporttype, @v10spositiontaking_2 as spositiontaking, 0 as slivepositiontaking, @v10mpositiontaking_2 as mpositiontaking, 0 as mlivepositiontaking, @max_v10spositiontaking_2 as max_spositiontaking,  0 as max_slivepositiontaking
		union all 	select 3 as bettype, 10 as sporttype, @v10spositiontaking_3 as spositiontaking, 0 as slivepositiontaking, @v10mpositiontaking_3 as mpositiontaking, 0 as mlivepositiontaking, @max_v10spositiontaking_3 as max_spositiontaking,  0 as max_slivepositiontaking
		union all 	select 20 as bettype, 10 as sporttype, @v10spositiontaking_20 as spositiontaking, 0 as slivepositiontaking, @v10mpositiontaking_20 as mpositiontaking, 0 as mlivepositiontaking, @max_v10spositiontaking_20 as max_spositiontaking,  0 as max_slivepositiontaking
		
		union all 	select 1 as bettype, 11 as sporttype, @v11spositiontaking_1 as spositiontaking, 0 as slivepositiontaking, @v11mpositiontaking_1 as mpositiontaking, 0 as mlivepositiontaking, @max_v11spositiontaking_1 as max_spositiontaking,  0 as max_slivepositiontaking
		union all 	select 20 as bettype, 11 as sporttype, @v11spositiontaking_20 as spositiontaking, 0 as slivepositiontaking, @v11mpositiontaking_20 as mpositiontaking, 0 as mlivepositiontaking, @max_v11spositiontaking_20 as max_spositiontaking,  0 as max_slivepositiontaking
		
		union all 	select 1 as bettype, 99 as sporttype, @v99spositiontaking_1 as spositiontaking, 0 as slivepositiontaking, @v99mpositiontaking_1 as mpositiontaking, 0 as mlivepositiontaking, @max_v99spositiontaking_1 as max_spositiontaking,  0 as max_slivepositiontaking
		union all 	select 2 as bettype, 99 as sporttype, @v99spositiontaking_2 as spositiontaking, 0 as slivepositiontaking, @v99mpositiontaking_2 as mpositiontaking, 0 as mlivepositiontaking, @max_v99spositiontaking_2 as max_spositiontaking,  0 as max_slivepositiontaking
		union all 	select 3 as bettype, 99 as sporttype, @v99spositiontaking_3 as spositiontaking, 0 as slivepositiontaking, @v99mpositiontaking_3 as mpositiontaking, 0 as mlivepositiontaking, @max_v99spositiontaking_3 as max_spositiontaking,  0 as max_slivepositiontaking	
		union all 	select 20 as bettype, 99 as sporttype, @v99spositiontaking_20 as spositiontaking, 0 as slivepositiontaking, @v99mpositiontaking_20 as mpositiontaking, 0 as mlivepositiontaking, @max_v99spositiontaking_20 as max_spositiontaking,  0 as max_slivepositiontaking

		union all 	select 9 as bettype, 99 as sporttype, @v99spositiontaking_9 as spositiontaking, 0 as slivepositiontaking, @v99mpositiontaking_9 as mpositiontaking, 0 as mlivepositiontaking, @max_v99spositiontaking_9 as max_spositiontaking,  0 as max_slivepositiontaking

		union all   select 81 as bettype, 161 as sporttype, @v161spositiontaking_81 as spositiontaking, 0 as slivepositiontaking, @v161mpositiontaking_81 as mpositiontaking, 0 as mlivepositiontaking, @max_v161spositiontaking_81 as max_positiontaking, 0 as max_slivepositiontaking
		union all   select 83 as bettype, 161 as sporttype, @v161spositiontaking_83 as spositiontaking, 0 as slivepositiontaking, @v161mpositiontaking_83 as mpositiontaking, 0 as mlivepositiontaking, @max_v161spositiontaking_83 as max_positiontaking, 0 as max_slivepositiontaking
		union all   select 88 as bettype, 161 as sporttype, @v161spositiontaking_88 as spositiontaking, 0 as slivepositiontaking, @v161mpositiontaking_88 as mpositiontaking, 0 as mlivepositiontaking, @max_v161spositiontaking_88 as max_positiontaking, 0 as max_slivepositiontaking	
		union all   select 85 as bettype, 161 as sporttype, 0 as spositiontaking, @v161slivepositiontaking_85 as slivepositiontaking, 0 as mpositiontaking, @v161mlivepositiontaking_85 as mlivepositiontaking, 0 as max_positiontaking, @max_v161slivepositiontaking_85 as max_slivepositiontaking
		union all   select 86 as bettype, 161 as sporttype, @v161spositiontaking_86 as spositiontaking, @v161slivepositiontaking_86 as slivepositiontaking, @v161mpositiontaking_86 as mpositiontaking, @v161mlivepositiontaking_86 as mlivepositiontaking, @max_v161spositiontaking_86 as max_spositiontaking, @max_v161slivepositiontaking_86 as max_slivepositiontaking
		union all   select 87 as bettype, 161 as sporttype, 0 as spositiontaking, @v161slivepositiontaking_87 as slivepositiontaking, 0 as mpositiontaking, @v161mlivepositiontaking_87 as mlivepositiontaking, 0 as max_positiontaking, @max_v161slivepositiontaking_87 as max_slivepositiontaking
		union all   select 89 as bettype, 161 as sporttype, 0 as spositiontaking, @v161slivepositiontaking_89 as slivepositiontaking, 0 as mpositiontaking, @v161mlivepositiontaking_89 as mlivepositiontaking, 0 as max_positiontaking, @max_v161slivepositiontaking_89 as max_slivepositiontaking
		union all   select 90 as bettype, 161 as sporttype, 0 as spositiontaking, @v161slivepositiontaking_90 as slivepositiontaking, 0 as mpositiontaking, @v161mlivepositiontaking_90 as mlivepositiontaking, 0 as max_positiontaking, @max_v161slivepositiontaking_90 as max_slivepositiontaking
				
		) as b on sports.ID = b.sporttype
		inner join #tmp_Bettype bettype on b.bettype = bettype.ID
		where (spositiontaking + mpositiontaking>max_spositiontaking)
			or (slivepositiontaking + mlivepositiontaking>max_slivepositiontaking)

	if @ErrType <>''
	BEGIN
		SELECT @ErrMsg = case @Language 
								when 'E' then 'Wrong position taking (max for super set by company).<br>'+@ErrType
								ELSE [dbo].[f_Get_MsgNamebyMsgID](20004,@Language) + '<br>' + @ErrType
							end
		Select @ErrCode = 104
		return 
	END

	SELECT TOP 1
		@MinMinBet = Isnull(MinBet, 0), @MaxMaxBet = isnull(MaxBet, 0)
	FROM Dep_CustSetting WITH (NOLOCK) 
	WHERE custid = @srecommend and  bettype=1 and sporttype=1

	--End Check valid commission 


	select top 1  @MinMinBetv2 = Isnull(MinBet, 0), @MaxMaxBetv2 = isnull(MaxBet, 0) from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=1 and sporttype=2
	select top 1 @MinMinBetv3 = Isnull(MinBet, 0), @MaxMaxBetv3 = isnull(MaxBet, 0) from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=1 and sporttype=3
	select top 1 @MinMinBetv5 = Isnull(MinBet, 0), @MaxMaxBetv5 = isnull(MaxBet, 0) from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=1 and sporttype=5
	select top 1 @MinMinBetv8 = Isnull(MinBet, 0), @MaxMaxBetv8 = isnull(MaxBet, 0) from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=1 and sporttype=8
	select top 1 @MinMinBetv10 = Isnull(MinBet, 0), @MaxMaxBetv10 = isnull(MaxBet, 0) from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=1 and sporttype=10
	select top 1 @MinMinBetv11 = Isnull(MinBet, 0), @MaxMaxBetv11 = isnull(MaxBet, 0) from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=1 and sporttype=11

	select top 1 @MinMinBetv99 = Isnull(MinBet, 0), @MaxMaxBetv99 = isnull(MaxBet, 0) from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=1 and sporttype=99

	select top 1 @MinMinBetv1MP = Isnull(MinBet, 0), @MaxMaxBetv1MP = isnull(MaxBet, 0) from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=9 and sporttype=1
	select top 1 @MinMinBetv99MP = Isnull(MinBet, 0), @MaxMaxBetv99MP = isnull(MaxBet, 0) from Dep_CustSetting with (NOLOCK) where custid = @srecommend and bettype=9 and sporttype=99

	select top 1 @MinMinBetv161 = Isnull(MinBet,0), @MaxMaxBetv161 = Isnull(MaxBet,0) from Dep_CustSetting with(NOLOCK) where custid = @srecommend and bettype = 81 and sporttype = 161

	--Dom@20120322
	select @site = site from customer with (nolock) where CustID = @srecommend

	--Vinh@20080213: get transfer option from super

	select @TransferOption_dec = TransferOption 
	from custsuper with (nolock) where CustID = @srecommend

	select @ErrType = ''
	select @ErrType = @ErrType + CASE WHEN b.sporttype = 1 AND MP = 1 THEN 'Soccer Parlay' ELSE sports.name END + ', '
	from #tmp_Sports sports inner join
	(
					select 1 as sporttype, 0 MP, @minbetv1 as minbet, @MinMinBet as MinMinBet
		union all	select 2 as sporttype, 0 MP, @minbetv2 as minbet, @MinMinBetv2 as MinMinBet
		union all	select 3 as sporttype, 0 MP, @minbetv3 as minbet, @MinMinBetv3 as MinMinBet
		union all	select 5 as sporttype, 0 MP, @minbetv5 as minbet, @MinMinBetv5 as MinMinBet
		union all	select 8 as sporttype, 0 MP, @minbetv8 as minbet, @MinMinBetv8 as MinMinBet
		union all	select 10 as sporttype, 0 MP, @minbetv10 as minbet, @MinMinBetv10 as MinMinBet
		union all	select 11 as sporttype, 0 MP, @minbetv11 as minbet, @MinMinBetv11 as MinMinBet
		union all	select 99 as sporttype, 0 MP, @minbetv99 as minbet, @MinMinBetv99 as MinMinBet
		
		union all   select 1 as sporttype, 1 MP, @minbetv1mp as minbet, @MinMinBetv1MP as MinMinBet
		union all   select 99 as sporttype, 0 MP, @minbetv99mp as minbet, @MinMinBetv99MP as MinMinBet
		union all   select 161 as sporttype, 0 MP, @minbetv161 as minbet, @MinMinBetv161 as MinMinBet	 
	) as b on sports.ID = b.sporttype
	where MinMinBet>0 and MinBet>0 and minbet<MinMinBet

	if @ErrType <>''
	BEGIN
		SELECT
			@ErrMsg =	case @Language 
								when 'E' then 'Min bet must be equal to or greater than super agent min bet ('+@ErrType+').'
								ELSE [dbo].[f_Get_MsgNamebyMsgID](10016,@Language) + ' ('+@ErrType+').'
						end
											
		Select @ErrCode = 107
		return
	END

	select @ErrType = ''
	select @ErrType = @ErrType + CASE WHEN b.sporttype = 1 AND MP =1 THEN 'Soccer Parlay' ELSE sports.Name END + ', '
	from #tmp_Sports sports inner join
	(
					select 1 as sporttype, 0 MP, @maxbetv1 as maxbet, @MaxMaxBet as MaxMaxBet
		union all	select 2 as sporttype, 0 MP, @maxbetv2 as maxbet, @MaxMaxBetv2 as MaxMaxBet
		union all	select 3 as sporttype, 0 MP, @maxbetv3 as maxbet, @MaxMaxBetv3 as MaxMaxBet
		union all	select 5 as sporttype, 0 MP, @maxbetv5 as maxbet, @MaxMaxBetv5 as MaxMaxBet
		union all	select 8 as sporttype, 0 MP, @maxbetv8 as maxbet, @MaxMaxBetv8 as MaxMaxBet
		union all	select 10 as sporttype, 0 MP, @maxbetv10 as maxbet, @MaxMaxBetv10 as MaxMaxBet
		union all	select 11 as sporttype, 0 MP, @maxbetv11 as maxbet, @MaxMaxBetv11 as MaxMaxBet
		union all	select 99 as sporttype, 0 MP, @maxbetv99 as maxbet, @MaxMaxBetv99 as MaxMaxBet	
		
		union all	select 1 as sporttype, 1 MP, @maxbetv1mp as maxbet, @MaxMaxBetv1MP as MaxMaxBet	
		union all	select 99 as sporttype, 0 MP, @maxbetv99mp as maxbet, @MaxMaxBetv99MP as MaxMaxBet
		union all   select 161 as sporttype, 0 MP, @maxbetv161 as maxbet, @MaxMaxBetv161 as MaxMaxbet 
	) as b on sports.ID = b.sporttype
	where MaxMaxBet>0 and MaxBet>0 and maxbet>MaxMaxBet

	if @ErrType <>''
	BEGIN
		SELECT
			@ErrMsg =	case @Language 
								when 'E' then 'Max bet must be equal to or less than super agent max bet ('+@ErrType+').'
								ELSE [dbo].[f_Get_MsgNamebyMsgID](10017,@Language) + ' ('+@ErrType+').'
						end
											
		Select @ErrCode = 107
		return
	END

	select @ErrType = ''
	select @ErrType = @ErrType + CASE WHEN b.sporttype = 1 AND MP = 1 THEN 'Soccer Parlay' ELSE sports.Name END + ', '
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
		
		union all	select 1 as sporttype, 1 MP, @MaxPerMatchv1MP as MaxPerMatch, @MaxMaxPerMatchv1MP as MaxMaxPerMatch
		union all	select 99 as sporttype, 0 MP, @MaxPerMatchv99MP as MaxPerMatch, @MaxMaxPerMatchv99MP as MaxMaxPerMatch
		union all   select 161 as sporttype, 0 MP, @MaxPerMatchv161 as MaxPerMatch, @MaxMaxPerMatchv161 as MaxMaxPerMatch 
	) as b on sports.ID = b.sporttype
	where MaxMaxPerMatch>0 and MaxPerMatch>0 and MaxPerMatch>MaxMaxPerMatch

	if @ErrType <>''
	BEGIN
		SELECT
			@ErrMsg =	case @Language 
								when 'E' then 'Max Per Match must be equal to or less than super agent Max Per Match ('+@ErrType+').'
								ELSE [dbo].[f_Get_MsgNamebyMsgID](10018,@Language) + ' ('+@ErrType+').'
						end
											
		Select @ErrCode = 108
		return
	END

	--- max per ball
	IF @MaxPerBallv161 > @MaxMaxPerBallv161 and @MaxMaxPerBallv161 > 0
	BEGIN
		select @ErrMsg =	case @Language 
								when 'E' then 'Max Per Ball must be equal to or less than Super Agent Max Per Ball (Number Game).'
								ELSE [dbo].[f_Get_MsgNamebyMsgID](10010,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](161,@Language) + ')'
						end										
		Select @ErrCode = 201
		return
	END



	--Insert general info
	EXEC dbo.Acc_Dep_CustomerInsUserInfo
		@custid = @custid OUTPUT,
		@creator = @creator,
		@username = @username,
		@userpwd = @userpwd,
		@pwdexpiry = @pwdexpiry,
		@currency = @currency,
		@site = @site,
		@srecommend = @srecommend,
		@mrecommend = 0,
		@recommend = 0,
		@roleid = 3,
		@TransferOption = NULL,
		@suspended = 0,
		@closed = @UplineClosed,
	
		@DisableOutright = @DisableOutright,
		@matchlimit = @matchlimit,
		
		@virtualmultiplier = @VirtualMultiplier,		
		
		@DisableAutoMPT = 0,
		@DisableNumber = @DisableNumber,
		
		@IsInternal = 0,
		@MaxPerMatch = @MaxPerMatchv1,
		@MaxPerMatchv2 = @MaxPerMatchv2,
		@MaxPerMatchv3 = @MaxPerMatchv3,
		@MaxPerMatchv5 = @MaxPerMatchv5,
		@MaxPerMatchv8 = @MaxPerMatchv8,
		@MaxPerMatchv10 = @MaxPerMatchv10,
		@MaxPerMatchv11 = @MaxPerMatchv11,
		
		@MaxPerMatchv99 = @MaxPerMatchv99,
		
		@MaxPerMatchv1MP =@MaxPerMatchv1MP,
		@MaxPerMatchv99MP =@MaxPerMatchv99MP,
		@MaxPerMatchv161 = @MaxPerMatchv161,
		@MaxPerBallv161 = @MaxPerBallv161,
		
	
		@hidekeno=@DisableKeno,

		@credit = 0,
		@maxcredit = null,
		
		@IP = @IP,
		@TransferOption_dec = @TransferOption_dec,
		@Language = @Language,
		@ErrCode = @ErrCode OUTPUT,
		@ErrMsg = @ErrMsg OUTPUT

	--Error Occurs
	IF @ErrCode <> 0
		return 

	SELECT @Rollback= ' DELETE Dep_CustSetting WITH (ROWLOCK) WHERE custId ='+COALESCE(CAST(@custid AS VARCHAR(50)),SPACE(1))+
					 ' DELETE Dep_CustSetting3rd WITH (ROWLOCK) WHERE custId  ='+COALESCE(CAST(@custid AS VARCHAR(50)),SPACE(1))+
					 ' DELETE FROM Dep_CustSuper WITH(ROWLOCK) WHERE custId = '+COALESCE(CAST(@custid AS VARCHAR(50)),SPACE(1))+
			 	
					 ' DELETE CustSettingGame WITH(ROWLOCK) WHERE custid = '+COALESCE(CAST(@custid AS VARCHAR(50)),SPACE(1))	+
					 ' DELETE CustGameType WITH(ROWLOCK) WHERE custid = '+COALESCE(CAST(@custid AS VARCHAR(50)),SPACE(1))	+
					 ' EXEC Acc_CustomerInsUserInfo_Rollback @CustID = '+COALESCE(CAST(@custid AS VARCHAR(50)),SPACE(1))

	--Allow master using auto master PT or not
	--Update CustMaster WITH(ROWLOCK,UPDLOCK) SET DisableAutoMPT = @DIsableAutoMPT WHERE CustID = @CustID
		
	INSERT INTO [dbo].[Dep_CustSetting]([custId], [bettype], [sporttype], [apositiontaking], [mpositiontaking], [spositiontaking], [playerdiscount], [discount], [adiscount], [sdiscount], [Minbet], [Maxbet],[islive])
	SELECT @custid, 1, 1, 0, @v1mpositiontaking_1, @v1spositiontaking_1, 0, 0, 0, 0, @MinBetv1, @MaxBetv1, 0
	UNION ALL
	SELECT @custid, 1, 1, 0, @v1mlivepositiontaking_1, @v1slivepositiontaking_1, 0, 0, 0, 0, @MinBetv1, @MaxBetv1, 1
	UNION ALL	
	SELECT @custid, 3, 1, 0, @v1mpositiontaking_3, @v1spositiontaking_3, 0, 0, 0, 0, @MinBetv1, @MaxBetv1, 0
	UNION ALL	
	SELECT @custid, 3, 1, 0, @v1mlivepositiontaking_3, @v1slivepositiontaking_3, 0, 0, 0, 0, @MinBetv1, @MaxBetv1, 1
	UNION ALL	
	SELECT @custid, 7, 1, 0, @v1mpositiontaking_7, @v1spositiontaking_7, 0, 0, 0, 0, @MinBetv1, @MaxBetv1, 0
	UNION ALL	
	SELECT @custid, 7, 1, 0, @v1mlivepositiontaking_7, @v1slivepositiontaking_7, 0, 0, 0, 0, @MinBetv1, @MaxBetv1, 1
	UNION ALL	
	SELECT @custid, 8, 1, 0, @v1mpositiontaking_8, @v1spositiontaking_8, 0, 0, 0, 0,  @MinBetv1, @MaxBetv1, 0
	UNION ALL	
	SELECT @custid, 8, 1, 0, @v1mlivepositiontaking_8, @v1slivepositiontaking_8, 0, 0, 0, 0, @MinBetv1, @MaxBetv1, 1

	UNION ALL	SELECT @custid, 2, 1, 0, @v1mpositiontaking_2, @v1spositiontaking_2, 0, 0, 0, 0, @MinBetv1, @MaxBetv1, 0
	--------------------------------------------------------------------------------------
	--1x2
	UNION ALL	SELECT @custid, 5, 1, 0, @v1mpositiontaking_5, @v1spositiontaking_5, 0, 0, 0, 0, @MinBetv1, @MaxBetv1, 0

	UNION ALL	SELECT @custid, 4, 1, 0, @v1mpositiontaking_4, @v1spositiontaking_4, 0, 0, 0, 0, @MinBetv1, @MaxBetv1, 0
	UNION ALL	SELECT @custid, 6, 1, 0, @v1mpositiontaking_6, @v1spositiontaking_6, 0, 0, 0, 0, @MinBetv1, @MaxBetv1, 0
	UNION ALL	SELECT @custid, 9, 1, 0, @v1mpositiontaking_9, @v1spositiontaking_9, 0, 0, 0, 0, @MinBetv1MP, @MaxBetv1MP, 0
	UNION ALL	SELECT @custid, 10, 1, 0, @v1mpositiontaking_10, @v1spositiontaking_10, 0, 0, 0, 0, @MinBetv1, @MaxBetv1, 0

	UNION ALL	SELECT @custid, 1, 2, 0, @v2mpositiontaking_1, @v2spositiontaking_1, 0, 0, 0, 0, @MinBetv2, @MaxBetv2, 0
	UNION ALL	SELECT @custid, 2, 2, 0, @v2mpositiontaking_2, @v2spositiontaking_2, 0, 0, 0, 0, @MinBetv2, @MaxBetv2, 0
	UNION ALL	SELECT @custid, 3, 2, 0, @v2mpositiontaking_3, @v2spositiontaking_3, 0, 0, 0, 0, @MinBetv2, @MaxBetv2, 0
	UNION ALL	SELECT @custid, 7, 2, 0, @v2mpositiontaking_7, @v2spositiontaking_7, 0, 0, 0, 0, @MinBetv2, @MaxBetv2, 0
	UNION ALL	SELECT @custid, 8, 2, 0, @v2mpositiontaking_8, @v2spositiontaking_8, 0, 0, 0, 0, @MinBetv2, @MaxBetv2, 0

	UNION ALL	SELECT @custid, 20, 2, 0, @v2mpositiontaking_20, @v2spositiontaking_20, 0, 0, 0, 0, @MinBetv2, @MaxBetv2, 0

	UNION ALL	SELECT @custid, 1, 3, 0, @v3mpositiontaking_1, @v3spositiontaking_1, 0, 0, 0, 0, @MinBetv3, @MaxBetv3, 0
	UNION ALL	SELECT @custid, 2, 3, 0, @v3mpositiontaking_2, @v3spositiontaking_2, 0, 0, 0, 0, @MinBetv3, @MaxBetv3, 0
	UNION ALL	SELECT @custid, 3, 3, 0, @v3mpositiontaking_3, @v3spositiontaking_3, 0, 0, 0, 0, @MinBetv3, @MaxBetv3, 0
	UNION ALL	SELECT @custid, 20, 3, 0, @v3mpositiontaking_20, @v3spositiontaking_20, 0, 0, 0, 0, @MinBetv3, @MaxBetv3, 0

	UNION ALL	SELECT @custid, 1, 5, 0, @v5mpositiontaking_1, @v5spositiontaking_1, 0, 0, 0, 0, @MinBetv5, @MaxBetv5, 0
	UNION ALL	SELECT @custid, 2, 5, 0, @v5mpositiontaking_2, @v5spositiontaking_2, 0, 0, 0, 0, @MinBetv5, @MaxBetv5, 0
	UNION ALL	SELECT @custid, 3, 5, 0, @v5mpositiontaking_3, @v5spositiontaking_3, 0, 0, 0, 0, @MinBetv5, @MaxBetv5, 0
	UNION ALL	SELECT @custid, 20, 5, 0, @v5mpositiontaking_20, @v5spositiontaking_20, 0, 0, 0, 0, @MinBetv5, @MaxBetv5, 0

	UNION ALL	SELECT @custid, 1, 8, 0, @v8mpositiontaking_1, @v8spositiontaking_1, 0, 0, 0, 0, @MinBetv8, @MaxBetv8, 0
	UNION ALL	SELECT @custid, 3, 8, 0, @v8mpositiontaking_3, @v8spositiontaking_3, 0, 0, 0, 0, @MinBetv8, @MaxBetv8, 0
	UNION ALL	SELECT @custid, 20, 8, 0, @v8mpositiontaking_20, @v8spositiontaking_20, 0, 0, 0, 0, @MinBetv8, @MaxBetv8, 0

	UNION ALL	SELECT @custid, 1, 10, 0, @v10mpositiontaking_1, @v10spositiontaking_1, 0, 0, 0, 0, @MinBetv10, @MaxBetv10, 0
	UNION ALL	SELECT @custid, 2, 10, 0, @v10mpositiontaking_2, @v10spositiontaking_2, 0, 0, 0, 0, @MinBetv10, @MaxBetv10, 0
	UNION ALL	SELECT @custid, 3, 10, 0, @v10mpositiontaking_3, @v10spositiontaking_3, 0, 0, 0, 0, @MinBetv10, @MaxBetv10, 0
	UNION ALL	SELECT @custid, 20, 10, 0, @v10mpositiontaking_20, @v10spositiontaking_20, 0, 0, 0, 0, @MinBetv10, @MaxBetv10, 0

	UNION ALL	SELECT @custid, 1, 11, 0, @v11mpositiontaking_1, @v11spositiontaking_1, 0, 0, 0, 0, @MinBetv11, @MaxBetv11, 0
	UNION ALL	SELECT @custid, 20, 11, 0, @v11mpositiontaking_20, @v11spositiontaking_20, 0, 0, 0, 0, @MinBetv11, @MaxBetv11, 0

	UNION ALL	SELECT @custid, 1, 99, 0, @v99mpositiontaking_1, @v99spositiontaking_1, 0, 0, 0, 0, @MinBetv99, @MaxBetv99, 0
	UNION ALL	SELECT @custid, 2, 99, 0, @v99mpositiontaking_2, @v99spositiontaking_2, 0, 0, 0, 0, @MinBetv99, @MaxBetv99, 0
	UNION ALL	SELECT @custid, 3, 99, 0, @v99mpositiontaking_3, @v99spositiontaking_3, 0, 0, 0, 0, @MinBetv99, @MaxBetv99, 0
	UNION ALL	SELECT @custid, 20, 99, 0, @v99mpositiontaking_20, @v99spositiontaking_20, 0, 0, 0, 0, @MinBetv99, @MaxBetv99, 0
	--Mix Sports Parlay
	UNION ALL	SELECT @custid, 9, 99, 0, @v99mpositiontaking_9, @v99spositiontaking_9, 0, 0, 0, 0, @MinBetv99MP, @MaxBetv99MP, 0
	
	if @@Error <> 0
	BEGIN
		--Error Occurs	
		SELECT @ErrMsg = case @Language 
								when 'E' then 'Create customer fail. Please try again'
								ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
							end	
				,  @ErrCode=116
		
		-- ROLLBACK MANUALLY
		DELETE [Dep_CustSetting] with (ROWLOCK) where custid =  @custid
		
		EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
		
		return
	END
	--insert into CustSetting3rd
	INSERT INTO [dbo].[Dep_CustSetting3rd]([custId], [bettype], [sporttype], [apositiontaking], [mpositiontaking], [spositiontaking],  [playerdiscount], [discount], [adiscount], [sdiscount], [Minbet], [Maxbet], [islive])

	--v161
	SELECT @custid, 81, 161, 0, @v161mpositiontaking_81, @v161spositiontaking_81, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 0--nonlive
	UNION ALL	SELECT @custid, 83, 161, 0, @v161mpositiontaking_83, @v161spositiontaking_83, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 0--nonlive
	UNION ALL	SELECT @custid, 85, 161, 0, @v161mlivepositiontaking_85, @v161slivepositiontaking_85, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 1--live

	UNION ALL	SELECT @custid, 86, 161, 0, @v161mpositiontaking_86, @v161spositiontaking_86, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 0--nonlive
	UNION ALL	SELECT @custid, 86, 161, 0, @v161mlivepositiontaking_86, @v161slivepositiontaking_86, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 1--live 

	UNION ALL	SELECT @custid, 87, 161, 0, @v161mlivepositiontaking_87, @v161slivepositiontaking_87, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 1--live
	UNION ALL	SELECT @custid, 88, 161, 0, @v161mpositiontaking_88, @v161spositiontaking_88, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 0--nonlive
	UNION ALL	SELECT @custid, 89, 161, 0, @v161mlivepositiontaking_89, @v161slivepositiontaking_89, 0, 0, 0, 0, @MinBetv161, @MaxBetv161, 1--live
	UNION ALL	SELECT @custid, 90, 161, 0, @v161mlivepositiontaking_90, @v161slivepositiontaking_90, 0, 0, 0, 0, @minbetv161, @maxbetv161, 1--live

	if @@Error <> 0
	BEGIN
		--Error Occurs	
		SELECT @ErrMsg = case @Language 
								when 'E' then 'Create customer fail. Please try again'
								ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
							end	
				,  @ErrCode=117
		
		-- ROLLBACK MANUALLY
		DELETE [Dep_CustSetting] with (ROWLOCK) where custid =  @custid
		DELETE [Dep_CustSetting3rd] with (ROWLOCK) where custid = @custid
		
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
		DELETE Dep_CustSetting WITH (ROWLOCK) WHERE CustId = @custid
		DELETE Dep_CustSetting3rd WITH (ROWLOCK) WHERE CustId = @custid
		DELETE Dep_CustSuper WITH(ROWLOCK) WHERE CustId = @CustID
	
		DELETE CustGameType WITH(ROWLOCK) WHERE Custid = @custid
		DELETE CustSettingGame WITH(ROWLOCK) WHERE Custid = @custid
		DELETE CustOverrideGame WITH(ROWLOCK) WHERE Custid = @custid
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
		DELETE Dep_CustSetting WITH (ROWLOCK) WHERE CustId = @custid
		DELETE Dep_CustSetting3rd WITH (ROWLOCK) WHERE CustId = @custid
		DELETE Dep_CustSuper WITH(ROWLOCK) WHERE CustId = @CustID
	
		DELETE CustGameType WITH(ROWLOCK) WHERE Custid = @custid
		DELETE CustSettingGame WITH(ROWLOCK) WHERE Custid = @custid
		DELETE CustOverrideGame WITH(ROWLOCK) WHERE Custid = @custid
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
		DELETE Dep_CustSetting WITH (ROWLOCK) WHERE CustId = @custid
		DELETE Dep_CustSetting3rd WITH (ROWLOCK) WHERE CustId = @custid
		DELETE Dep_CustSuper WITH(ROWLOCK) WHERE CustId = @CustID
		
		DELETE CustGameType WITH(ROWLOCK) WHERE Custid = @custid
		DELETE CustSettingGame WITH(ROWLOCK) WHERE Custid = @custid
		DELETE CustOverrideGame WITH(ROWLOCK) WHERE Custid = @custid
		EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
		RETURN
	END

	--check minBet maxBet PT Upline
	SELECT  kt.IBCBetTypeID Bettype,
			isnull(cgt.minbet,0) AS MinBetMin, 
			isnull(cgt.maxbet,0) AS MaxbetMax, 
			isnull(csg.mpositiontaking,0) AS MaxPT,
			isnull(cgt.MaxPerGameType,0) AS MaxPerMarchMax
	INTO #MinMaxUpline
	FROM dbo.CustGameType cgt WITH(NOLOCK)
		INNER JOIN CustSettingGame csg ON cgt.custid = csg.custid
		INNER JOIN #tmp_GameType KT  ON cgt.GameTypeID = kt.ID
	WHERE cgt.custid = @srecommend
		AND csg.sporttype = 202	

	IF EXISTS (SELECT top 1 1 
				FROM #data d INNER JOIN #MinMaxUpline m on d.bettype=m.bettype
				WHERE (d.MinBet < m.MinBetMin) AND d.MinBet>0) 
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
		DELETE Dep_CustSetting WITH (ROWLOCK) WHERE CustId = @custid
		DELETE Dep_CustSetting3rd WITH (ROWLOCK) WHERE CustId = @custid
		DELETE Dep_CustSuper WITH(ROWLOCK) WHERE CustId = @CustID
		
		DELETE CustGameType WITH(ROWLOCK) WHERE Custid = @custid
		DELETE CustSettingGame WITH(ROWLOCK) WHERE Custid = @custid
		DELETE CustOverrideGame WITH(ROWLOCK) WHERE Custid = @custid
		EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
		RETURN
	END
	IF EXISTS (SELECT top 1 1 
				FROM #data d INNER JOIN #MinMaxUpline m on d.bettype=m.bettype
				WHERE (d.MaxBet > m.MaxbetMax) and d.MaxBet>0) 
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
		DELETE Dep_CustSetting WITH (ROWLOCK) WHERE CustId = @custid
		DELETE Dep_CustSetting3rd WITH (ROWLOCK) WHERE CustId = @custid
		DELETE Dep_CustSuper WITH(ROWLOCK) WHERE CustId = @CustID
	
		DELETE CustGameType WITH(ROWLOCK) WHERE Custid = @custid
		DELETE CustSettingGame WITH(ROWLOCK) WHERE Custid = @custid
		DELETE CustOverrideGame WITH(ROWLOCK) WHERE Custid = @custid
		EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
		RETURN
	END
	IF EXISTS (SELECT top 1 1 
				FROM #data d INNER JOIN #MinMaxUpline m on d.bettype=m.bettype
				WHERE (d.MaxPerMatch > m.MaxPerMarchMax) AND d.MaxPerMatch>0 )
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
		DELETE Dep_CustSetting WITH (ROWLOCK) WHERE CustId = @custid
		DELETE Dep_CustSetting3rd WITH (ROWLOCK) WHERE CustId = @custid
		DELETE Dep_CustSuper WITH(ROWLOCK) WHERE CustId = @CustID
		
		DELETE CustGameType WITH(ROWLOCK) WHERE Custid = @custid
		DELETE CustSettingGame WITH(ROWLOCK) WHERE Custid = @custid
		DELETE CustOverrideGame WITH(ROWLOCK) WHERE Custid = @custid
		EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
		RETURN
	END

	--check PT
	IF EXISTS (SELECT top 1 1 
				FROM #data d INNER JOIN #MinMaxUpline m on d.bettype=m.bettype
				WHERE (d.mPositionTaking > m.MaxPT) AND d.mPositionTaking > 0)
	BEGIN		
		SELECT
			@ErrMsg =	case @Language 
								when 'E' then 'Keno Position Taking is invalid.'
								ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language)
						end
											
		Select @ErrCode = 103		
		--EXEC sp_executesql @Rollback 
		DELETE Dep_CustSetting WITH (ROWLOCK) WHERE CustId = @custid
		DELETE Dep_CustSetting3rd WITH (ROWLOCK) WHERE CustId = @custid
		DELETE Dep_CustSuper WITH(ROWLOCK) WHERE CustId = @CustID
		
		DELETE CustGameType WITH(ROWLOCK) WHERE Custid = @custid
		DELETE CustSettingGame WITH(ROWLOCK) WHERE Custid = @custid
		DELETE CustOverrideGame WITH(ROWLOCK) WHERE Custid = @custid
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
	SELECT @custid , Bettype, 202, 0, ISNULL(mPositionTaking,0), 0, 0, 0, 0, 0, 0, 0 ,0 ,0
	FROM #data
	WHERE Bettype=1501

	INSERT INTO dbo.CustGameType(CustID,GameTypeID,StakeLevelList,MaxPerGameType,MinBet,MaxBet,IsDisabled)
	SELECT @custid,gt.ID,'',MaxPerMatch,MinBet,MaxBet,d.IsDisable 
	FROM #data d INNER JOIN #tmp_GameType gt ON d.bettype=gt.IBCBetTypeID
	SELECT @ErrCode
	IF (@@ERROR <> 0 OR @ErrCode <>0)
	BEGIN
		--Error Occurs
		SELECT @ErrMsg = CASE @Language 
								when 'E' then 'Create customer fail. Please try again'
								ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
							END	
				, @ErrCode=116
		
		--EXEC sp_executesql @Rollback 
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
 		DELETE [Dep_CustSetting] with (ROWLOCK) where custid =  @custid
		DELETE [Dep_CustSetting3rd] with (ROWLOCK) where custid = @custid
		
		DELETE CustSettingGame WITH(ROWLOCK) WHERE custid = @custid
		DELETE CustOverrideGame WITH(ROWLOCK) WHERE custid = @custid
		
		EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
		DELETE Dep_AgentCommRate WITH(ROWLOCK) WHERE custid = @custid
 		RETURN 
	 END  
	 
	set @endRun = getdate()
	set @duration  = datediff (millisecond,@startRun,@endRun)

	--write log keno
	DECLARE @str_bet varchar(1000)='',
			@str_spt varchar(1000)='',
			@str_mpt varchar(1000)='',
			@str_apt varchar(1000)='',
			@i INT=1501,
			@j INT=(select max(Bettype) FROM #data)
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

	Declare @LogSPData varchar(MAX)
	--Log customer info
	Select @LogSPData = '<Acc_Dep_CustomerInsMember_SAg custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +
	'creator="'+ coalesce(cast(@creator as varchar(50)),space(1)) + '" ' +
	'username="'+ coalesce(cast(@username as varchar(30)),space(1)) + '" ' +
	'Language="'+ coalesce(cast(@Language as varchar(2)),space(1)) + '" ' +
	'srecommend="'+ coalesce(cast(@srecommend as varchar(50)),space(1)) + '" ' +
	'IP="'+ coalesce(cast(@IP as varchar(15)),space(1)) + '" ' +
	'site="'+ coalesce(cast(@site as varchar(50)),space(1)) + '" ' +
	'ErrCode="'+ coalesce(cast(@ErrCode as varchar(50)),space(1)) + '" ' +
	'ErrMsg="'+ coalesce(cast(@ErrMsg as varchar(5000)),space(1)) + '" />'
	EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP 
		@UserID = @Creator,
		@CustID = @CustID,
		@ActionID = 2413,
		@TrackingValue = @LogSPData,
		@duration = @duration
		
	--Log bet setting
	Select @LogSPData = '<Acc_Dep_CustomerInsMember_SAg custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +
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
	---
	---
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
		@ActionID = 2010, 
		@TrackingValue = @LogSPData,
		@duration = @duration

	--Log status
	Select @LogSPData = '<Acc_Dep_CustomerInsMember_SAg custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +
	'closed="'+ coalesce(cast(@UplineClosed as varchar(1)),space(1)) + '" ' +	
	'DisableOutright="'+ coalesce(cast(@DisableOutright as varchar(1)),space(1)) + '" ' +
	'DisableNumber="' + coalesce(cast(@DisableNumber as varchar(1)),space(1)) + '" />'


	EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP 
		@UserID = @Creator,
		@CustID = @CustID,
		@ActionID = 2203,
		@TrackingValue = @LogSPData,
		@duration = @duration
		
	--Log positiontaking
	Select @LogSPData = '<Acc_Dep_CustomerInsMember_SAg><s spt_1="'+ coalesce(dbo.f_FomatNumericToChar(@v1spositiontaking_1 ),space(1)) + '" ' +
	'spt_2="'+ coalesce(dbo.f_FomatNumericToChar(@v1spositiontaking_2 ),space(1)) + '" ' +
	'spt_3="'+ coalesce(dbo.f_FomatNumericToChar(@v1spositiontaking_3 ),space(1)) + '" ' +
	'spt_4="'+ coalesce(dbo.f_FomatNumericToChar(@v1spositiontaking_4 ),space(1)) + '" ' +
	'spt_5="'+ coalesce(dbo.f_FomatNumericToChar(@v1spositiontaking_5 ),space(1)) + '" ' +
	'spt_6="'+ coalesce(dbo.f_FomatNumericToChar(@v1spositiontaking_6 ),space(1)) + '" ' +
	'spt_7="'+ coalesce(dbo.f_FomatNumericToChar(@v1spositiontaking_7 ),space(1)) + '" ' +
	'spt_8="'+ coalesce(dbo.f_FomatNumericToChar(@v1spositiontaking_8 ),space(1)) + '" ' +
	'spt_9="'+ coalesce(dbo.f_FomatNumericToChar(@v1spositiontaking_9 ),space(1)) + '" ' +
	'spt_10="'+ coalesce(dbo.f_FomatNumericToChar(@v1spositiontaking_10 ),space(1)) + '" ' +
	'slivept_1="'+ coalesce(dbo.f_FomatNumericToChar(@v1slivepositiontaking_1 ),space(1)) + '" ' +
	'slivept_3="'+ coalesce(dbo.f_FomatNumericToChar(@v1slivepositiontaking_3 ),space(1)) + '" ' +
	'slivept_7="'+ coalesce(dbo.f_FomatNumericToChar(@v1slivepositiontaking_7 ),space(1)) + '" ' +
	'slivept_8="'+ coalesce(dbo.f_FomatNumericToChar(@v1slivepositiontaking_8 ),space(1)) + '" ' +

	'v2spt_1="'+ coalesce(dbo.f_FomatNumericToChar(@v2spositiontaking_1 ),space(1)) + '" ' +
	'v2spt_2="'+ coalesce(dbo.f_FomatNumericToChar(@v2spositiontaking_2 ),space(1)) + '" ' +
	'v2spt_3="'+ coalesce(dbo.f_FomatNumericToChar(@v2spositiontaking_3 ),space(1)) + '" ' +
	'v2spt_7="'+ coalesce(dbo.f_FomatNumericToChar(@v2spositiontaking_7 ),space(1)) + '" ' +
	'v2spt_8="'+ coalesce(dbo.f_FomatNumericToChar(@v2spositiontaking_8 ),space(1)) + '" ' +
	'v2spt_20="'+ coalesce(dbo.f_FomatNumericToChar(@v2spositiontaking_20 ),space(1)) + '" ' +

	'v3spt_1="'+ coalesce(dbo.f_FomatNumericToChar(@v3spositiontaking_1 ),space(1)) + '" ' +
	'v3spt_2="'+ coalesce(dbo.f_FomatNumericToChar(@v3spositiontaking_2 ),space(1)) + '" ' +
	'v3spt_3="'+ coalesce(dbo.f_FomatNumericToChar(@v3spositiontaking_3 ),space(1)) + '" ' +
	'v3spt_20="'+ coalesce(dbo.f_FomatNumericToChar(@v3spositiontaking_20 ),space(1)) + '" ' +

	'v5spt_1="'+ coalesce(dbo.f_FomatNumericToChar(@v5spositiontaking_1 ),space(1)) + '" ' +
	'v5spt_2="'+ coalesce(dbo.f_FomatNumericToChar(@v5spositiontaking_2 ),space(1)) + '" ' +
	'v5spt_3="'+ coalesce(dbo.f_FomatNumericToChar(@v5spositiontaking_3 ),space(1)) + '" ' +
	'v5spt_20="'+ coalesce(dbo.f_FomatNumericToChar(@v5spositiontaking_20 ),space(1)) + '" ' +

	'v8spt_1="'+ coalesce(dbo.f_FomatNumericToChar(@v8spositiontaking_1 ),space(1)) + '" ' +
	'v8spt_3="'+ coalesce(dbo.f_FomatNumericToChar(@v8spositiontaking_3 ),space(1)) + '" ' +
	'v8spt_20="'+ coalesce(dbo.f_FomatNumericToChar(@v8spositiontaking_20 ),space(1)) + '" ' +

	'v10spt_1="'+ coalesce(dbo.f_FomatNumericToChar(@v10spositiontaking_1 ),space(1)) + '" ' +
	'v10spt_2="'+ coalesce(dbo.f_FomatNumericToChar(@v10spositiontaking_2 ),space(1)) + '" ' +
	'v10spt_3="'+ coalesce(dbo.f_FomatNumericToChar(@v10spositiontaking_3 ),space(1)) + '" ' +
	'v10spt_20="'+ coalesce(dbo.f_FomatNumericToChar(@v10spositiontaking_20 ),space(1)) + '" ' +

	'v11spt_1="'+ coalesce(dbo.f_FomatNumericToChar(@v11spositiontaking_1 ),space(1)) + '" ' +
	'v11spt_20="'+ coalesce(dbo.f_FomatNumericToChar(@v11spositiontaking_20 ),space(1)) + '" ' +

	'v99spt_1="'+ coalesce(dbo.f_FomatNumericToChar(@v99spositiontaking_1 ),space(1)) + '" ' +
	'v99spt_2="'+ coalesce(dbo.f_FomatNumericToChar(@v99spositiontaking_2 ),space(1)) + '" ' +
	'v99spt_3="'+ coalesce(dbo.f_FomatNumericToChar(@v99spositiontaking_3 ),space(1)) + '" ' +
	'v99spt_9="'+ coalesce(dbo.f_FomatNumericToChar(@v99spositiontaking_9 ),space(1)) + '" ' +
	'v99spt_20="'+ coalesce(dbo.f_FomatNumericToChar(@v99spositiontaking_20 ),space(1)) + '" ' +
	'v161spt_81="' + coalesce(dbo.f_FomatNumericToChar(@v161spositiontaking_81),space(1)) + '" ' +
	'v161spt_83="' + coalesce(dbo.f_FomatNumericToChar(@v161spositiontaking_83),space(1)) + '" ' +
	'v161spt_86="' + coalesce(dbo.f_FomatNumericToChar(@v161spositiontaking_86),space(1)) + '" ' +
	'v161spt_88="' + coalesce(dbo.f_FomatNumericToChar(@v161spositiontaking_88),space(1)) + '" ' +
	'v161slivept_85="' + coalesce(dbo.f_FomatNumericToChar(@v161slivepositiontaking_85),space(1)) + '" ' +
	'v161slivept_86="' + coalesce(dbo.f_FomatNumericToChar(@v161slivepositiontaking_86),space(1)) + '" ' + 
	'v161slivept_87="' + coalesce(dbo.f_FomatNumericToChar(@v161slivepositiontaking_87),space(1)) + '" ' + 
	'v161slivept_89="' + coalesce(dbo.f_FomatNumericToChar(@v161slivepositiontaking_89),space(1)) + '" ' + 
	'v161slivept_90="' + coalesce(dbo.f_FomatNumericToChar(@v161slivepositiontaking_90),space(1)) + '" ' +

	@str_spt +	' />' +

	'<m mpt_1="'+ coalesce(dbo.f_FomatNumericToChar(@v1mpositiontaking_1 ),space(1)) + '" ' +
	'mpt_2="'+ coalesce(dbo.f_FomatNumericToChar(@v1mpositiontaking_2 ),space(1)) + '" ' +
	'mpt_3="'+ coalesce(dbo.f_FomatNumericToChar(@v1mpositiontaking_3 ),space(1)) + '" ' +
	'mpt_4="'+ coalesce(dbo.f_FomatNumericToChar(@v1mpositiontaking_4 ),space(1)) + '" ' +
	'mpt_5="'+ coalesce(dbo.f_FomatNumericToChar(@v1mpositiontaking_5 ),space(1)) + '" ' +
	'mpt_6="'+ coalesce(dbo.f_FomatNumericToChar(@v1mpositiontaking_6 ),space(1)) + '" ' +
	'mpt_7="'+ coalesce(dbo.f_FomatNumericToChar(@v1mpositiontaking_7 ),space(1)) + '" ' +
	'mpt_8="'+ coalesce(dbo.f_FomatNumericToChar(@v1mpositiontaking_8 ),space(1)) + '" ' +
	'mpt_9="'+ coalesce(dbo.f_FomatNumericToChar(@v1mpositiontaking_9 ),space(1)) + '" ' +
	'mpt_10="'+ coalesce(dbo.f_FomatNumericToChar(@v1mpositiontaking_10 ),space(1)) + '" ' +
	'mlivept_1="'+ coalesce(dbo.f_FomatNumericToChar(@v1mlivepositiontaking_1 ),space(1)) + '" ' +
	'mlivept_3="'+ coalesce(dbo.f_FomatNumericToChar(@v1mlivepositiontaking_3 ),space(1)) + '" ' +
	'mlivept_7="'+ coalesce(dbo.f_FomatNumericToChar(@v1mlivepositiontaking_7 ),space(1)) + '" ' +
	'mlivept_8="'+ coalesce(dbo.f_FomatNumericToChar(@v1mlivepositiontaking_8 ),space(1)) + '" ' +

	'v2mpt_1="'+ coalesce(dbo.f_FomatNumericToChar(@v2mpositiontaking_1 ),space(1)) + '" ' +
	'v2mpt_2="'+ coalesce(dbo.f_FomatNumericToChar(@v2mpositiontaking_2 ),space(1)) + '" ' +
	'v2mpt_3="'+ coalesce(dbo.f_FomatNumericToChar(@v2mpositiontaking_3 ),space(1)) + '" ' +
	'v2mpt_7="'+ coalesce(dbo.f_FomatNumericToChar(@v2mpositiontaking_7 ),space(1)) + '" ' +
	'v2mpt_8="'+ coalesce(dbo.f_FomatNumericToChar(@v2mpositiontaking_8 ),space(1)) + '" ' +
	'v2mpt_20="'+ coalesce(dbo.f_FomatNumericToChar(@v2mpositiontaking_20 ),space(1)) + '" ' +

	'v3mpt_1="'+ coalesce(dbo.f_FomatNumericToChar(@v3mpositiontaking_1 ),space(1)) + '" ' +
	'v3mpt_2="'+ coalesce(dbo.f_FomatNumericToChar(@v3mpositiontaking_2 ),space(1)) + '" ' +
	'v3mpt_3="'+ coalesce(dbo.f_FomatNumericToChar(@v3mpositiontaking_3 ),space(1)) + '" ' +
	'v3mpt_20="'+ coalesce(dbo.f_FomatNumericToChar(@v3mpositiontaking_20 ),space(1)) + '" ' +

	'v5mpt_1="'+ coalesce(dbo.f_FomatNumericToChar(@v5mpositiontaking_1 ),space(1)) + '" ' +
	'v5mpt_2="'+ coalesce(dbo.f_FomatNumericToChar(@v5mpositiontaking_2 ),space(1)) + '" ' +
	'v5mpt_3="'+ coalesce(dbo.f_FomatNumericToChar(@v5mpositiontaking_3 ),space(1)) + '" ' +
	'v5mpt_20="'+ coalesce(dbo.f_FomatNumericToChar(@v5mpositiontaking_20 ),space(1)) + '" ' +

	'v8mpt_1="'+ coalesce(dbo.f_FomatNumericToChar(@v8mpositiontaking_1 ),space(1)) + '" ' +
	'v8mpt_3="'+ coalesce(dbo.f_FomatNumericToChar(@v8mpositiontaking_3 ),space(1)) + '" ' +
	'v8mpt_20="'+ coalesce(dbo.f_FomatNumericToChar(@v8mpositiontaking_20 ),space(1)) + '" ' +

	'v10mpt_1="'+ coalesce(dbo.f_FomatNumericToChar(@v10mpositiontaking_1 ),space(1)) + '" ' +
	'v10mpt_2="'+ coalesce(dbo.f_FomatNumericToChar(@v10mpositiontaking_2 ),space(1)) + '" ' +
	'v10mpt_3="'+ coalesce(dbo.f_FomatNumericToChar(@v10mpositiontaking_3 ),space(1)) + '" ' +
	'v10mpt_20="'+ coalesce(dbo.f_FomatNumericToChar(@v10mpositiontaking_20 ),space(1)) + '" ' +

	'v11mpt_1="'+ coalesce(dbo.f_FomatNumericToChar(@v11mpositiontaking_1 ),space(1)) + '" ' +
	'v11mpt_20="'+ coalesce(dbo.f_FomatNumericToChar(@v11mpositiontaking_20 ),space(1)) + '" ' +

	'v99mpt_1="'+ coalesce(dbo.f_FomatNumericToChar(@v99mpositiontaking_1 ),space(1)) + '" ' +
	'v99mpt_2="'+ coalesce(dbo.f_FomatNumericToChar(@v99mpositiontaking_2 ),space(1)) + '" ' +
	'v99mpt_3="'+ coalesce(dbo.f_FomatNumericToChar(@v99mpositiontaking_3 ),space(1)) + '" ' +
	'v99mpt_20="'+ coalesce(dbo.f_FomatNumericToChar(@v99mpositiontaking_20 ),space(1)) + '" ' + 

	-- mix parlay of mixed sports
	'v99mpt_9="'+ coalesce(dbo.f_FomatNumericToChar(@v99mpositiontaking_9 ),space(1)) + '" ' +

	
	@str_mpt+

	-- number game
	'v161mpt_81="'+ coalesce(dbo.f_FomatNumericToChar(@v161mpositiontaking_81),space(1)) + '" ' + 
	'v161mpt_83="'+ coalesce(dbo.f_FomatNumericToChar(@v161mpositiontaking_83),space(1)) + '" ' + 
	'v161mpt_86="'+ coalesce(dbo.f_FomatNumericToChar(@v161mpositiontaking_86),space(1)) + '" ' + 
	'v161mpt_88="'+ coalesce(dbo.f_FomatNumericToChar(@v161mpositiontaking_88),space(1)) + '" ' + 
	'v161mlivept_85="'+ coalesce(dbo.f_FomatNumericToChar(@v161mlivepositiontaking_85),space(1)) + '" ' + 
	'v161mlivept_86="'+ coalesce(dbo.f_FomatNumericToChar(@v161mlivepositiontaking_86),space(1)) + '" ' + 
	'v161mlivept_87="'+ coalesce(dbo.f_FomatNumericToChar(@v161mlivepositiontaking_87),space(1)) + '" ' + 
	'v161mlivept_89="'+ coalesce(dbo.f_FomatNumericToChar(@v161mlivepositiontaking_89),space(1)) + '" ' + 
	'v161mlivept_90="'+ coalesce(dbo.f_FomatNumericToChar(@v161mlivepositiontaking_90),space(1)) + '" /></Acc_Dep_CustomerInsMember_SAg>' 
	EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP 
		@UserID = @Creator,
		@CustID = @CustID,
		@ActionID = 2702,
		@TrackingValue = @LogSPData,
		@duration = @duration

	DROP TABLE #data
	DROP TABLE #MinMaxUpline
END
GO
