/*<info serverAlias="DBCUST-CUSTDB" executers="wsv_nap" viewers="" isFunction="0"></info>*/
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
	- 20170302@Helen: Betradar Virtual Sports  -Integration for Cash [Redmine: 77274]
	- 20170809@Winnie: Change Data Type of Sporttype [RedmineID: #73545]	
	- 20180125@Winnie: Hide inactive products [RedmineID: #86086]     
	- 20180326@Winnie: Customer Setting - urgent fix to support for long bettype name. [RedmineID: #91216]
	- 20190726@Winnie: Remove Muay Thai. [RedmineID: #117501] 
	- 20191107@Eden: 3rd party products - Remove InActive Products Phase 2 [Redmine: #118699]
	- 20200619@Johnson: add Soccer Parlay bet limit [redmine: #135261]
	- 20201214@Winfred: Adjust PT value with 4 decimal places for SB  [redmine: #146574]
	- 20220615@Tacy: Hot modify Select Into statement to avoid dump [Redmine: #174035]
	
Param's Explanation:
• @ErrCode:
    = 0: Update successfully.
    > 0: Specific Error.
  
• @ErrMsg: Error description.
• @VirtualSportList: VirtualSport Settings XML param.
*/
BEGIN
	SET NOCOUNT ON

	CREATE TABLE #tmp_Sports (ID INT, Name NVARCHAR(500),IsDisabled BIT,IBCBettypeID INT)
	CREATE TABLE #tmp_Bettype (ID INT, Name NVARCHAR(500),IsDisabled BIT,IBCBettypeID INT)
	CREATE TABLE #tmp_GameType (ID INT, Name NVARCHAR(500),IsDisabled BIT,IBCBettypeID INT)
	CREATE TABLE #Data_Upline (bettype INT, Minbet_Up MONEY, MaxBet_Up MONEY, MaxPerMatch_Up MONEY)

	CREATE TABLE #data (
		BetType INT, 
		MaxBet money, 
		MinBet money, 
		MaxPerMatch money, 
		sPositionTaking smallmoney,
		mPositionTaking smallmoney, 
		aPositionTaking smallmoney,
		isDisable BIT
	)

	----- David @ 09 JUN 2015 -------------------
	BEGIN TRY
		INSERT INTO #tmp_Sports (ID, Name, IsDisabled, IBCBettypeID)
		SELECT ID, Name, IsDisabled, IBCBettypeID
		FROM dbo.f_GetSportTypeBetTypeGameType(1,'DBAGE')	
	END TRY
	BEGIN CATCH
		IF OBJECT_ID(N'tempdb..#tmp_Sports') IS NOT NULL
		BEGIN
			TRUNCATE TABLE #tmp_Sports
			INSERT INTO #tmp_Sports
			SELECT ID, Name, IsDisabled, IBCBettypeID
			FROM dbo.f_GetSportTypeBetTypeGameType(1,'DBTXN')	
		END
	END CATCH

	BEGIN TRY			
		INSERT INTO #tmp_Bettype (ID, Name, IsDisabled, IBCBettypeID)
		SELECT ID, Name, IsDisabled, IBCBettypeID
		FROM dbo.f_GetSportTypeBetTypeGameType(2,'DBAGE')	
	END TRY
	BEGIN CATCH		
		IF OBJECT_ID(N'tempdb..#tmp_Bettype') IS NOT NULL
		BEGIN
			TRUNCATE TABLE #tmp_Bettype
			INSERT INTO #tmp_Bettype
			SELECT ID, Name, IsDisabled, IBCBettypeID
			FROM dbo.f_GetSportTypeBetTypeGameType(2,'DBTXN')	
		END
	END CATCH

	BEGIN TRY		
		INSERT INTO #tmp_GameType (ID, Name, IsDisabled, IBCBettypeID)
		SELECT ID, Name, IsDisabled, IBCBettypeID
		FROM dbo.f_GetSportTypeBetTypeGameType(3,'DBAGE')	
	END TRY
	BEGIN CATCH		
		IF OBJECT_ID(N'tempdb..#tmp_GameType') IS NOT NULL
		BEGIN
			TRUNCATE TABLE #tmp_GameType
			INSERT INTO #tmp_GameType
			SELECT ID, Name, IsDisabled, IBCBettypeID
			FROM dbo.f_GetSportTypeBetTypeGameType(3,'DBTXN')	
		END
	END CATCH
	----- /David @ 09 JUN 2015 -------------------
	--set default pt = 0 to super
	--------Parse xml string into table -- Keno
	DECLARE @xmlDoc int
	EXEC sp_xml_preparedocument @xmlDoc OUTPUT, @KenoList

	INSERT INTO #data (BetType, MaxBet, MinBet, MaxPerMatch, sPositionTaking, mPositionTaking, aPositionTaking, isDisable)
	SELECT BetType, MaxBet, MinBet, MaxPerMatch, sPositionTaking, mPositionTaking, aPositionTaking, isDisable
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
	
		@v99spositiontaking_1		= 0,
		@v99spositiontaking_2		= 0,
		@v99spositiontaking_3		= 0,
		@v99spositiontaking_20		= 0,
								
		@v99spositiontaking_9		= 0,
									
		@v161spositiontaking_81		= 0, 				
		@v161spositiontaking_83		= 0,
		@v161spositiontaking_86		= 0,
		@v161spositiontaking_88		= 0,
									
		@v161slivepositiontaking_85 = 0,
		@v161slivepositiontaking_86 = 0,
		@v161slivepositiontaking_87	= 0,
		@v161slivepositiontaking_89	= 0,
		@v161slivepositiontaking_90	= 0

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
	
		@MinMinBetv99 money, @MaxMaxBetv99 money, @MaxMaxPerMatchv99 money,	
		@MinMinBetv1MP money, @MaxMaxBetv1MP money, @MaxMaxPerMatchv1MP money,
		@MinMinBetv99MP money, @MaxMaxBetv99MP money, @MaxMaxPerMatchv99MP money,
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
		@minbetv1mp < 0
		or @maxbetv1mp < 0
		or @maxpermatchv1mp < 0
	BEGIN
		Select @ErrMsg = 	case @Language 
							when 'E' then 'Wrong Min bet/ Max bet/ Max per match (for Soccer Parlay).'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10003,@Language) + case @Language 
																								when 'CS' then N'(供足球串关)'
																								when 'CT' then N'(for Soccer Parlay)'
																								when 'TH' then N'(for Soccer Parlay)'
																								when 'J' then N'(for Soccer Parlay)'
																								when 'KO' then N'(for Soccer Parlay)'
																								when 'VI' then N'(for Soccer Parlay)'
																								else N'(for Soccer Parlay)' END
					end, @ErrCode = 200
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

	
	-- mix parlay of mixed sports
	if (@minbetv1mp <> 0 and @maxbetv1mp <> 0 and @minbetv1mp > @maxbetv1mp) 
	or (@maxbetv1mp <> 0 and @maxpermatchv1mp <> 0 and @maxbetv1mp > @maxpermatchv1mp)
	or (@minbetv1mp <> 0 and @maxpermatchv1mp <> 0 and @minbetv1mp > @maxpermatchv1mp) 
	BEGIN
		SELECT @ErrMsg =  @UserName + ': '+
						case @Language 
							when 'E' then 'Min bet must be less than max bet and max bet must be less than max bet per match (for Soccer Parlay)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language) + case @Language 
																								when 'CS' then N'(供足球串关)'
																								when 'CT' then N'(for Soccer Parlay)'
																								when 'TH' then N'(for Soccer Parlay)'
																								when 'J' then N'(for Soccer Parlay)'
																								when 'KO' then N'(for Soccer Parlay)'
																								when 'VI' then N'(for Soccer Parlay)'
																								else N'(for Soccer Parlay)' END
						end, @ErrCode = 203
		return
	END
	
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
		
			@MaxMaxPerMatchv99 = MaxPerMatch99,
			
			@MaxMaxPerMatchv1MP = MaxPerMatch1MP,
			@MaxMaxPerMatchv99MP = MaxPerMatch99MP,
			@MaxMaxPerMatchv161 = MaxPerMatch161,
			@MaxMaxPerBallv161 = MaxPerBall161
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
		@MinMinBetv99 = MinBet,
		@MaxMaxBetv99 = MaxBet
	From dep_custsetting with (NOLOCK)
	where CustID = @srecommend and bettype=1 and sporttype=99

	select 
		@MinMinBetv1MP = MinBet,
		@MaxMaxBetv1MP = MaxBet
	from dep_custsetting with(nolock)
	where custid = @srecommend and bettype = 9 and sporttype = 1	

	
	select 
		@MinMinBetv99MP = MinBet,
		@MaxMaxBetv99MP = MaxBet
	from dep_custsetting with(nolock)
	where custid = @srecommend and bettype = 9 and sporttype = 99	

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
	
	IF (@MaxMaxBetv1MP > 0 and @maxbetv1mp > 0 and @maxbetv1mp > @MaxMaxBetv1MP)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						case @Language 
							when 'E' then 'Max bet must be equal to or less than Super Agent max bet (for Soccer Parlay)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10017,@Language) + case @Language 
																								when 'CS' then N'(供足球串关)'
																								when 'CT' then N'(for Soccer Parlay)'
																								when 'TH' then N'(for Soccer Parlay)'
																								when 'J' then N'(for Soccer Parlay)'
																								when 'KO' then N'(for Soccer Parlay)'
																								when 'VI' then N'(for Soccer Parlay)'
																								else N'(for Soccer Parlay)' END
						end						
						+' (' + convert(varchar(20), @MaxMaxBetv1MP) + ').', @ErrCode = 205	
		return
	END
		
	IF (@MaxMaxPerMatchv1MP > 0 and @MaxPerMatchv1MP > 0 and @MaxPerMatchv1MP > @MaxMaxPerMatchv1MP)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						case @Language 
							when 'E' then 'Max Per Match must be equal to or less than Super Agent Max Per Match (for Soccer Parlay)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10018,@Language) + case @Language 
																								when 'CS' then N'(供足球串关)'
																								when 'CT' then N'(for Soccer Parlay)'
																								when 'TH' then N'(for Soccer Parlay)'
																								when 'J' then N'(for Soccer Parlay)'
																								when 'KO' then N'(for Soccer Parlay)'
																								when 'VI' then N'(for Soccer Parlay)'
																								else N'(for Soccer Parlay)' END
						end						
						+' (' + convert(varchar(20), @MaxMaxPerMatchv1MP) + ').', @ErrCode = 206	
		return
	END
		
	IF (@MinMinBetv1MP > 0 and @minbetv1mp > 0 and @minbetv1mp < @MinMinBetv1MP)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						case @Language 
							when 'E' then 'Min bet must be equal to or greater than Super Agent min bet (for Soccer Parlay)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10016,@Language) + case @Language 
																								when 'CS' then N'(供足球串关)'
																								when 'CT' then N'(for Soccer Parlay)'
																								when 'TH' then N'(สfor Soccer Parlay)'
																								when 'J' then N'(for Soccer Parlay)'
																								when 'KO' then N'(for Soccer Parlay)'
																								when 'VI' then N'(for Soccer Parlay)'
																								else N'(for Soccer Parlay)' END
						end						
						+' (' + convert(varchar(20), @MinMinBetv1MP) + ').', @ErrCode = 207	
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
		select @ErrType = @ErrType + sports.Name + '-'+ bettype.Name + '-Max: '+ cast((scs.mpositiontaking) as varchar(10))
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
			inner join #tmp_Sports sports on b.sporttype = sports.ID
			inner join #tmp_Bettype bettype on b.bettype = bettype.ID
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
		select @ErrType = @ErrType + sports.Name + '-'+ bettype.Name + '-Max: '+ cast((scs.mpositiontaking) as varchar(10))
		+ case when b.sporttype=1 and b.bettype in (1,3,7,8) and scs.islive = 1 then '-MaxLive: '+ cast((scs.mpositiontaking) as varchar(10)) else '' end + '<br>'
		from dep_custsetting as scs with (NOLOCK) inner join
			(
				 		select 1 as bettype, 2 as sporttype, @v2spositiontaking_1 as spositiontaking, 0 as slivepositiontaking, @v2mpositiontaking_1 as mpositiontaking, 0 as mlivepositiontaking
				union all 	select 2 as bettype, 2 as sporttype, @v2spositiontaking_2 as spositiontaking, 0 as slivepositiontaking, @v2mpositiontaking_2 as mpositiontaking, 0 as mlivepositiontaking
				union all 	select 3 as bettype, 2 as sporttype, @v2spositiontaking_3 as spositiontaking, 0 as slivepositiontaking, @v2mpositiontaking_3 as mpositiontaking, 0 as mlivepositiontaking
				union all 	select 20 as bettype, 2 as sporttype, @v2spositiontaking_20 as spositiontaking, 0 as slivepositiontaking, @v2mpositiontaking_20 as mpositiontaking, 0 as mlivepositiontaking
			) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
			inner join #tmp_Sports sports on b.sporttype = sports.ID
			inner join #tmp_Bettype bettype on b.bettype = bettype.ID
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
		select @ErrType = @ErrType + sports.Name + '-'+ bettype.Name + '-Max: '+ cast((scs.mpositiontaking) as varchar(10))
		+ case when b.sporttype=1 and b.bettype in (1,3,7,8) and scs.islive = 1 then '-MaxLive: '+ cast((scs.mpositiontaking) as varchar(10)) else '' end + '<br>'
		from dep_custsetting as scs with (NOLOCK) inner join
			(
					select 1 as bettype, 3 as sporttype, @v3spositiontaking_1 as spositiontaking, 0 as slivepositiontaking, @v3mpositiontaking_1 as mpositiontaking, 0 as mlivepositiontaking
				union all 	select 2 as bettype, 3 as sporttype, @v3spositiontaking_2 as spositiontaking, 0 as slivepositiontaking, @v3mpositiontaking_2 as mpositiontaking, 0 as mlivepositiontaking
				union all 	select 3 as bettype, 3 as sporttype, @v3spositiontaking_3 as spositiontaking, 0 as slivepositiontaking, @v3mpositiontaking_3 as mpositiontaking, 0 as mlivepositiontaking
				union all 	select 20 as bettype, 3 as sporttype, @v3spositiontaking_20 as spositiontaking, 0 as slivepositiontaking, @v3mpositiontaking_20 as mpositiontaking, 0 as mlivepositiontaking
			) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
			inner join #tmp_Sports sports on b.sporttype = sports.ID
			inner join #tmp_Bettype bettype on b.bettype = bettype.ID
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
		select @ErrType = @ErrType + sports.Name + '-'+ bettype.Name + '-Max: '+ cast((scs.mpositiontaking) as varchar(10))
		+ case when b.sporttype=1 and b.bettype in (1,3,7,8) and scs.islive = 1 then '-MaxLive: '+ cast((scs.mpositiontaking) as varchar(10)) else '' end + '<br>'
		from dep_custsetting as scs with (NOLOCK) inner join
			(
				 		select 1 as bettype, 5 as sporttype, @v5spositiontaking_1 as spositiontaking, 0 as slivepositiontaking, @v5mpositiontaking_1 as mpositiontaking, 0 as mlivepositiontaking
				union all 	select 2 as bettype, 5 as sporttype, @v5spositiontaking_2 as spositiontaking, 0 as slivepositiontaking, @v5mpositiontaking_2 as mpositiontaking, 0 as mlivepositiontaking
				union all 	select 3 as bettype, 5 as sporttype, @v5spositiontaking_3 as spositiontaking, 0 as slivepositiontaking, @v5mpositiontaking_3 as mpositiontaking, 0 as mlivepositiontaking
				union all 	select 20 as bettype, 5 as sporttype, @v5spositiontaking_20 as spositiontaking, 0 as slivepositiontaking, @v5mpositiontaking_20 as mpositiontaking, 0 as mlivepositiontaking
			) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
			inner join #tmp_Sports sports on b.sporttype = sports.ID
			inner join #tmp_Bettype bettype on b.bettype = bettype.ID
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
		select @ErrType = @ErrType + sports.Name + '-'+ bettype.Name + '-Max: '+ cast((scs.mpositiontaking) as varchar(10))
		+ case when b.sporttype=1 and b.bettype in (1,3,7,8) and scs.islive = 1 then '-MaxLive: '+ cast((scs.mpositiontaking) as varchar(10)) else '' end + '<br>'
		from dep_custsetting as scs with (NOLOCK) inner join
			(
				 		select 1 as bettype, 8 as sporttype, @v8spositiontaking_1 as spositiontaking, 0 as slivepositiontaking, @v8mpositiontaking_1 as mpositiontaking, 0 as mlivepositiontaking
				union all 	select 3 as bettype, 8 as sporttype, @v8spositiontaking_3 as spositiontaking, 0 as slivepositiontaking, @v8mpositiontaking_3 as mpositiontaking, 0 as mlivepositiontaking
				union all 	select 20 as bettype, 8 as sporttype, @v8spositiontaking_20 as spositiontaking, 0 as slivepositiontaking, @v8mpositiontaking_20 as mpositiontaking, 0 as mlivepositiontaking
			) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
			inner join #tmp_Sports sports on b.sporttype = sports.ID
			inner join #tmp_Bettype bettype on b.bettype = bettype.ID
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
		select @ErrType = @ErrType + sports.Name + '-'+ bettype.Name + '-Max: '+ cast((scs.mpositiontaking) as varchar(10)) + '<br>'
		from dep_custsetting as scs with (NOLOCK) inner join
			(
				 		select 1 as bettype, 10 as sporttype, @v10spositiontaking_1 as spositiontaking, 0 as slivepositiontaking, @v10mpositiontaking_1 as mpositiontaking, 0 as mlivepositiontaking
				union all 	select 2 as bettype, 10 as sporttype, @v10spositiontaking_2 as spositiontaking, 0 as slivepositiontaking, @v10mpositiontaking_2 as mpositiontaking, 0 as mlivepositiontaking
				union all 	select 3 as bettype, 10 as sporttype, @v10spositiontaking_3 as spositiontaking, 0 as slivepositiontaking, @v10mpositiontaking_3 as mpositiontaking, 0 as mlivepositiontaking
				union all 	select 20 as bettype, 10 as sporttype, @v10spositiontaking_20 as spositiontaking, 0 as slivepositiontaking, @v10mpositiontaking_20 as mpositiontaking, 0 as mlivepositiontaking
			) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
			inner join #tmp_Sports sports on b.sporttype = sports.ID
			inner join #tmp_Bettype bettype on b.bettype = bettype.ID
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
		select @ErrType = @ErrType + sports.Name + '-'+ bettype.Name + '-Max: '+ cast((scs.mpositiontaking) as varchar(10))
		+ case when b.sporttype=1 and b.bettype in (1,3,7,8) and scs.islive = 1 then '-MaxLive: '+ cast((scs.mpositiontaking) as varchar(10)) else '' end + '<br>'
		from dep_custsetting as scs with (NOLOCK) inner join
			(
				 		select 1 as bettype, 11 as sporttype, @v11spositiontaking_1 as spositiontaking, 0 as slivepositiontaking, @v11mpositiontaking_1 as mpositiontaking, 0 as mlivepositiontaking
				union all 	select 20 as bettype, 11 as sporttype, @v11spositiontaking_20 as spositiontaking, 0 as slivepositiontaking, @v11mpositiontaking_20 as mpositiontaking, 0 as mlivepositiontaking
			) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
			inner join #tmp_Sports sports on b.sporttype = sports.ID
			inner join #tmp_Bettype bettype on b.bettype = bettype.ID
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
		select @ErrType = @ErrType + sports.Name + '-'+ bettype.Name + '-Max: '+ cast((scs.mpositiontaking) as varchar(10)) + '<br>'
		from dep_custsetting as scs with (NOLOCK) inner join
			(
				 		select 1 as bettype, 99 as sporttype, @v99spositiontaking_1 as spositiontaking, 0 as slivepositiontaking, @v99mpositiontaking_1 as mpositiontaking, 0 as mlivepositiontaking
				union all 	select 2 as bettype, 99 as sporttype, @v99spositiontaking_2 as spositiontaking, 0 as slivepositiontaking, @v99mpositiontaking_2 as mpositiontaking, 0 as mlivepositiontaking
				union all 	select 3 as bettype, 99 as sporttype, @v99spositiontaking_3 as spositiontaking, 0 as slivepositiontaking, @v99mpositiontaking_3 as mpositiontaking, 0 as mlivepositiontaking
				union all 	select 20 as bettype, 99 as sporttype, @v99spositiontaking_20 as spositiontaking, 0 as slivepositiontaking, @v99mpositiontaking_20 as mpositiontaking, 0 as mlivepositiontaking
			) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
			inner join #tmp_Sports sports on b.sporttype = sports.ID
			inner join #tmp_Bettype bettype on b.bettype = bettype.ID
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
		select @ErrType = @ErrType + sports.Name + '-'+ bettype.Name + '-Max: '+ cast((scs.mpositiontaking) as varchar(10))
		from dep_custsetting as scs with (NOLOCK) inner join
			(
				select 9 as bettype, 99 as sporttype, @v99spositiontaking_9 as spositiontaking, 0 as slivepositiontaking, @v99mpositiontaking_9 as mpositiontaking, 0 as mlivepositiontaking
			) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
			inner join #tmp_Sports sports on b.sporttype = sports.ID
			inner join #tmp_Bettype bettype on b.bettype = bettype.ID
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
		select @ErrType = @ErrType + sports.Name + '-'+ bettype.Name + '-Max: '+ cast((scs.mpositiontaking) as varchar(10))
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
			inner join #tmp_Sports sports on b.sporttype = sports.ID
			inner join #tmp_Bettype bettype on b.bettype = bettype.ID
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
		select @ErrType = @ErrType + sports.Name + '-'+ bettype.Name + '-Max: '+ cast((cs.spositiontaking) as varchar(10)) + '<br>'
		from dep_custsetting as cs with (NOLOCK) inner join
			(
						select 1 as bettype, 2 as sporttype, @v2spositiontaking_1 as spositiontaking, 0 as livepositiontaking, @v2mpositiontaking_1 as mpositiontaking
				union all 	select 2 as bettype, 2 as sporttype, @v2spositiontaking_2 as spositiontaking, 0 as livepositiontaking, @v2mpositiontaking_2 as mpositiontaking
				union all 	select 3 as bettype, 2 as sporttype, @v2spositiontaking_3 as spositiontaking, 0 as livepositiontaking, @v2mpositiontaking_3 as mpositiontaking
				union all 	select 20 as bettype, 2 as sporttype, @v2spositiontaking_20 as spositiontaking, 0 as livepositiontaking, @v2mpositiontaking_20 as mpositiontaking
			) as b on cs.sporttype=b.sporttype and cs.bettype=b.bettype
			inner join #tmp_Sports sports on b.sporttype = sports.ID
			inner join #tmp_Bettype bettype on b.bettype = bettype.ID
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
		select @ErrType = @ErrType + sports.Name + '-'+ bettype.Name + '-Max: '+ cast((cs.spositiontaking) as varchar(10)) + '<br>'
		from dep_custsetting as cs with (NOLOCK) inner join
			(
						select 1 as bettype, 3 as sporttype, @v3spositiontaking_1 as spositiontaking, 0 as livepositiontaking, @v3mpositiontaking_1 as mpositiontaking
				union all 	select 2 as bettype, 3 as sporttype, @v3spositiontaking_2 as spositiontaking, 0 as livepositiontaking, @v3mpositiontaking_2 as mpositiontaking
				union all 	select 3 as bettype, 3 as sporttype, @v3spositiontaking_3 as spositiontaking, 0 as livepositiontaking, @v3mpositiontaking_3 as mpositiontaking
				union all 	select 20 as bettype, 3 as sporttype, @v3spositiontaking_20 as spositiontaking, 0 as livepositiontaking, @v3mpositiontaking_20 as mpositiontaking
			) as b on cs.sporttype=b.sporttype and cs.bettype=b.bettype
			inner join #tmp_Sports sports on b.sporttype = sports.ID
			inner join #tmp_Bettype bettype on b.bettype = bettype.ID
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
		select @ErrType = @ErrType + sports.Name + '-'+ bettype.Name + '-Max: '+ cast((cs.spositiontaking) as varchar(10))
		from dep_custsetting as cs with (NOLOCK) inner join
			(
						select 1 as bettype, 5 as sporttype, @v5spositiontaking_1 as spositiontaking, 0 as livepositiontaking, @v5mpositiontaking_1 as mpositiontaking
				union all 	select 2 as bettype, 5 as sporttype, @v5spositiontaking_2 as spositiontaking, 0 as livepositiontaking, @v5mpositiontaking_2 as mpositiontaking
				union all 	select 3 as bettype, 5 as sporttype, @v5spositiontaking_3 as spositiontaking, 0 as livepositiontaking, @v5mpositiontaking_3 as mpositiontaking
				union all 	select 20 as bettype, 5 as sporttype, @v5spositiontaking_20 as spositiontaking, 0 as livepositiontaking, @v5mpositiontaking_20 as mpositiontaking
			) as b on cs.sporttype=b.sporttype and cs.bettype=b.bettype
			inner join #tmp_Sports sports on b.sporttype = sports.ID
			inner join #tmp_Bettype bettype on b.bettype = bettype.ID
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
		select @ErrType = @ErrType + sports.Name + '-'+ bettype.Name + '-Max: '+ cast((cs.spositiontaking) as varchar(10))
		from dep_custsetting as cs with (NOLOCK) inner join
			(
						select 1 as bettype, 8 as sporttype, @v8spositiontaking_1 as spositiontaking, 0 as livepositiontaking, @v8mpositiontaking_1 as mpositiontaking
				union all 	select 3 as bettype, 8 as sporttype, @v8spositiontaking_3 as spositiontaking, 0 as livepositiontaking, @v8mpositiontaking_3 as mpositiontaking
				union all 	select 20 as bettype, 8 as sporttype, @v8spositiontaking_20 as spositiontaking, 0 as livepositiontaking, @v8mpositiontaking_20 as mpositiontaking
			) as b on cs.sporttype=b.sporttype and cs.bettype=b.bettype
			inner join #tmp_Sports sports on b.sporttype = sports.ID
			inner join #tmp_Bettype bettype on b.bettype = bettype.ID
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
		select @ErrType = @ErrType + sports.Name + '-'+ bettype.Name + '-Max: '+ cast((cs.spositiontaking) as varchar(10))
		from dep_custsetting as cs with (NOLOCK) inner join
			(
						select 1 as bettype, 10 as sporttype, @v10spositiontaking_1 as spositiontaking, 0 as livepositiontaking, @v10mpositiontaking_1 as mpositiontaking
				union all 	select 2 as bettype, 10 as sporttype, @v10spositiontaking_2 as spositiontaking, 0 as livepositiontaking, @v10mpositiontaking_2 as mpositiontaking
				union all 	select 3 as bettype, 10 as sporttype, @v10spositiontaking_3 as spositiontaking, 0 as livepositiontaking, @v10mpositiontaking_3 as mpositiontaking
				union all 	select 20 as bettype, 10 as sporttype, @v10spositiontaking_20 as spositiontaking, 0 as livepositiontaking, @v10mpositiontaking_20 as mpositiontaking
			) as b on cs.sporttype=b.sporttype and cs.bettype=b.bettype
			inner join #tmp_Sports sports on b.sporttype = sports.ID
			inner join #tmp_Bettype bettype on b.bettype = bettype.ID
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
		select @ErrType = @ErrType + sports.Name + '-'+ bettype.Name + '-Max: '+ cast((cs.spositiontaking) as varchar(10))
		from custsetting as cs with (NOLOCK) inner join
			(
						select 1 as bettype, 11 as sporttype, @v11spositiontaking_1 as spositiontaking, 0 as livepositiontaking, @v11mpositiontaking_1 as mpositiontaking
				union all 	select 20 as bettype, 11 as sporttype, @v11spositiontaking_20 as spositiontaking, 0 as livepositiontaking, @v11mpositiontaking_20 as mpositiontaking
			) as b on cs.sporttype=b.sporttype and cs.bettype=b.bettype
			inner join #tmp_Sports sports on b.sporttype = sports.ID
			inner join #tmp_Bettype bettype on b.bettype = bettype.ID
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
		select @ErrType = @ErrType + sports.Name + '-'+ bettype.Name + '-Max: '+ cast((cs.spositiontaking) as varchar(10)) + '<br>'
		from dep_custsetting as cs with (NOLOCK) inner join
			(
						select 1 as bettype, 99 as sporttype, @v99spositiontaking_1 as spositiontaking, 0 as livepositiontaking, @v99mpositiontaking_1 as mpositiontaking
				union all 	select 2 as bettype, 99 as sporttype, @v99spositiontaking_2 as spositiontaking, 0 as livepositiontaking, @v99mpositiontaking_2 as mpositiontaking
				union all 	select 3 as bettype, 99 as sporttype, @v99spositiontaking_3 as spositiontaking, 0 as livepositiontaking, @v99mpositiontaking_3 as mpositiontaking
				union all 	select 20 as bettype, 99 as sporttype, @v99spositiontaking_20 as spositiontaking, 0 as livepositiontaking, @v99mpositiontaking_20 as mpositiontaking
			) as b on cs.sporttype=b.sporttype and cs.bettype=b.bettype
			inner join #tmp_Sports sports on b.sporttype = sports.ID
			inner join #tmp_Bettype bettype on b.bettype = bettype.ID
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
		select @ErrType = @ErrType + sports.Name + '-'+ bettype.Name + '-Max: '+ cast((cs.spositiontaking) as varchar(10))
		from dep_custsetting as cs with (NOLOCK) inner join
			(
				select 9 as bettype, 99 as sporttype, @v99spositiontaking_9 as spositiontaking, 0 as livepositiontaking, @v99mpositiontaking_9 as mpositiontaking	
			) as b on cs.sporttype=b.sporttype and cs.bettype=b.bettype
			inner join #tmp_Sports sports on b.sporttype = sports.ID
			inner join #tmp_Bettype bettype on b.bettype = bettype.ID
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
		select @ErrType = @ErrType + sports.Name + '-'+ bettype.Name + '-Max: '+ cast((cs.spositiontaking) as varchar(10))
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
			inner join #tmp_Sports sports on b.sporttype = sports.ID
			inner join #tmp_Bettype bettype on b.bettype = bettype.ID
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
		
		MaxPerMatch99		= @MaxPerMatchv99,
		
		MaxPerMatch1MP		= @MaxPerMatchv1MP,
		MaxPerMatch99MP		= @MaxPerMatchv99MP,
		MaxPerMatch161		= @MaxPerMatchv161,
		MaxPerBall161       = @maxperballv161
		
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
		MinBet = case sporttype when 1 then CASE WHEN betType = 9 THEN @MinBetv1MP ELSE @MinBetv1 END when 2 then @MinBetv2 when 3 then @MinBetv3 when 5 then @MinBetv5 when 8 then @MinBetv8 when 10 then @MinBetv10 when 11 then @MinBetv11  when 99 then (case bettype when 9 then @MinBetv99MP else @MinBetv99 end) else MinBet end,
		MaxBet = case sporttype when 1 then CASE WHEN betType = 9 THEN @MaxBetv1MP ELSE @MaxBetv1 END when 2 then @MaxBetv2 when 3 then @MaxBetv3 when 5 then @MaxBetv5 when 8 then @MaxBetv8 when 10 then @MaxBetv10 when 11 then @MaxBetv11  when 99 then (case bettype when 9 then @MaxBetv99MP else @MaxBetv99 end) else MaxBet end,
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
							
						
							
							WHEN sporttype = 99 and bettype = 1 THEN @v99mpositiontaking_1 
							WHEN sporttype = 99 and bettype = 2 THEN @v99mpositiontaking_2 
							WHEN sporttype = 99 and bettype = 3 THEN @v99mpositiontaking_3 
							WHEN sporttype = 99 and bettype = 9 THEN @v99mpositiontaking_9 
							WHEN sporttype = 99 and bettype = 20 THEN @v99mpositiontaking_20
							
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
						
							WHEN sporttype = 99 and bettype = 1 THEN @v99spositiontaking_1 
							WHEN sporttype = 99 and bettype = 2 THEN @v99spositiontaking_2 
							WHEN sporttype = 99 and bettype = 3 THEN @v99spositiontaking_3 
							WHEN sporttype = 99 and bettype = 9 THEN @v99spositiontaking_9 
							WHEN sporttype = 99 and bettype = 20 THEN @v99spositiontaking_20
							
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
				 ELSE 
					MinBet
				 END,
		MaxBet = CASE 
					WHEN sporttype = 161 THEN @MaxBetv161 					
				 ELSE
					MaxBet
				 END,
		mpositiontaking = CASE 
							
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

	-- At member level, leave the playerdiscount the value as it is
	/*
	UPDATE cs 
		SET cs.playerdiscount =  cs.discount
	FROM Dep_CustSetting3rd AS cs WITH (ROWLOCK, UPDLOCK)
	INNER JOIN custinfo AS c WITH (NOLOCK) ON cs.custid = c.custid
	WHERE c.mrecommend = @custid AND c.roleid = 1 AND cs.playerdiscount > cs.discount AND sporttype in (151,152,153)
	*/
	--Keno
	--Check PT
	DECLARE @vMaxPT_1501 money

	SELECT @vMaxPT_1501=isnull(spositiontaking,0) 
	FROM dbo.CustSettingGame WITH(NOLOCK) 
	WHERE CustID= @srecommend and Bettype=1501


	INSERT INTO #Data_Upline (Bettype,MinBet_Up,Maxbet_Up,MaxPerMatch_UP)
	SELECT IBCBetTypeID AS Bettype,
		   ISNULL(cg.MinBet,0) AS MinBet_Up,
		   ISNULL(cg.MaxBet,0) AS Maxbet_Up ,
		   ISNULL(cg.MaxPerGameType,0) AS MaxPerMatch_UP
	FROM dbo.CustGameType cg WITH (NOLOCK)  INNER JOIN 
	#tmp_GameType gt on cg.GameTypeID=gt.ID
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
	FROM CustGameType g WITH (ROWLOCK, UPDLOCK) INNER JOIN #tmp_GameType gt on g.GameTypeID=gt.ID
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
	'<info custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +
	'UserID="'+ coalesce(cast(@UserID as varchar(50)),space(1)) + '" ' +
	'Language="'+ coalesce(cast(@Language as varchar(2)),space(1)) + '" ' +
	'IP="'+ coalesce(cast(@IP as varchar(15)),space(1)) + '" ' +
	'ErrCode="'+ coalesce(cast(@ErrCode as varchar(50)),space(1)) + '" ' +
	'ErrMsg="'+ coalesce(cast(@ErrMsg as varchar(5000)),space(1)) + '" />' +
	
	'<SportsBook MinBv1="'+ coalesce(cast(@MinBetv1 as varchar(50)),space(1))+ '" ' +
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


	'MinBv99="'+ coalesce(cast(@MinBetv99 as varchar(50)),space(1))+ '" ' +
	'MaxBv99="'+ coalesce(cast(@MaxBetv99 as varchar(50)),space(1))+ '" ' +
	'MPMv99="'+ coalesce(cast(@MaxPerMatchv99 as varchar(50)),space(1))+ '" ' +

	'MinBv161="'+ coalesce(cast(@MinBetv161 as varchar(50)),space(1))+ '" ' +
	'MaxBv161="'+ coalesce(cast(@MaxBetv161 as varchar(50)),space(1))+ '" ' +
	'MPMv161="'+ coalesce(cast(@MaxPerMatchv161 as varchar(50)),space(1))+ '" ' +
	'MPBv161="' + coalesce(cast(@MaxPerBallv161 as varchar(50)),space(1)) + '" ' +
	
	'MinBv1MP="'+ coalesce(cast(@MinBetv1MP as varchar(50)),space(1))+ '" ' +
	'MaxBv1MP="'+ coalesce(cast(@MaxBetv1MP as varchar(50)),space(1))+ '" ' +
	'MPMv1MP="'+ coalesce(cast(@MaxPerMatchv1MP as varchar(50)),space(1))+ '" ' +
	
	'MinBv99MP="'+ coalesce(cast(@MinBetv99MP as varchar(50)),space(1))+ '" ' +
	'MaxBv99MP="'+ coalesce(cast(@MaxBetv99MP as varchar(50)),space(1))+ '" ' +
	'MPMv99MP="'+ coalesce(cast(@MaxPerMatchv99MP as varchar(50)),space(1))+ '" ' +

	'/>'+	'<Keno '+	@str_bet+	'/>' +	'</Acc_Dep_CustomerUpdMember_SAg>'

	BEGIN
		DECLARE @sql varchar (MAX)
		DECLARE @TEXT varchar (4000) =''
		SELECT @sql='<Acc_Dep_CustomerUpdMember_SAg> ' +
			'<info custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +
			'UserID="'+ coalesce(cast(@UserID as varchar(50)),space(1)) + '" ' +
			'Language="'+ coalesce(cast(@Language as varchar(2)),space(1)) + '" ' +
			'IP="'+ coalesce(cast(@IP as varchar(15)),space(1)) + '" ' +
			'ErrCode="'+ coalesce(cast(@ErrCode as varchar(50)),space(1)) + '" ' +
			'ErrMsg="'+ coalesce(cast(@ErrMsg as varchar(5000)),space(1)) + '" />' +
			
			'<SportsBook '
		Select @TEXT= @TEXT +
					'MinBv'+ cast(Sporttype as varchar(10))+'="'+ coalesce(cast(MinB as varchar(50)),space(1))+ '" ' +
					'MaxBv'+ cast(Sporttype as varchar(10))+'="'+ coalesce(cast(MaxB as varchar(50)),space(1))+ '" ' +
					'MPMv' + cast(Sporttype as varchar(10))+'="'+ coalesce(cast(MPM  as varchar(50)),space(1))+ '" ' +	
					CASE WHEN Sporttype=161 THEN 'MPBv161="'+ coalesce(cast(MPB as varchar(50)),space(1))+ '" ' ELSE '' END
			FROM #data_old
			WHERE (Sporttype <=100 OR Sporttype in (161))  AND islive=0
				AND NOT (sporttype = 1 AND bettype = 9)
			GROUP BY Custid,Sporttype,MinB,MaxB,MPM,MPB
		Select @TEXT= @TEXT +
					'MinBv'+ cast(Sporttype as varchar(10))+'MP="'+ coalesce(cast(MinB as varchar(50)),space(1))+ '" ' +
					'MaxBv'+ cast(Sporttype as varchar(10))+'MP="'+ coalesce(cast(MaxB as varchar(50)),space(1))+ '" ' +
					'MPMv' + cast(Sporttype as varchar(10))+'MP="'+ coalesce(cast(MPM  as varchar(50)),space(1))+ '" ' 	
			FROM #data_old
			WHERE (Sporttype IN (1,99) and Bettype=9)
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

	'<s spt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@v1spositiontaking_1 ),SPACE(1)) + '" ' +
	'spt_2="'+ COALESCE(dbo.f_FomatNumericToChar(@v1spositiontaking_2 ),SPACE(1)) + '" ' +
	'spt_3="'+ COALESCE(dbo.f_FomatNumericToChar(@v1spositiontaking_3 ),SPACE(1)) + '" ' +
	'spt_4="'+ COALESCE(dbo.f_FomatNumericToChar(@v1spositiontaking_4 ),SPACE(1)) + '" ' +
	'spt_5="'+ COALESCE(dbo.f_FomatNumericToChar(@v1spositiontaking_5 ),SPACE(1)) + '" ' +
	'spt_6="'+ COALESCE(dbo.f_FomatNumericToChar(@v1spositiontaking_6 ),SPACE(1)) + '" ' +
	'spt_7="'+ COALESCE(dbo.f_FomatNumericToChar(@v1spositiontaking_7 ),SPACE(1)) + '" ' +
	'spt_8="'+ COALESCE(dbo.f_FomatNumericToChar(@v1spositiontaking_8 ),SPACE(1)) + '" ' +
	'spt_9="'+ COALESCE(dbo.f_FomatNumericToChar(@v1spositiontaking_9 ),SPACE(1)) + '" ' +
	'spt_10="'+ COALESCE(dbo.f_FomatNumericToChar(@v1spositiontaking_10 ),SPACE(1)) + '" ' +
	'slivept_1="'+ COALESCE(dbo.f_FomatNumericToChar(@v1slivepositiontaking_1 ),SPACE(1)) + '" ' +
	'slivept_3="'+ COALESCE(dbo.f_FomatNumericToChar(@v1slivepositiontaking_3 ),SPACE(1)) + '" ' +
	'slivept_7="'+ COALESCE(dbo.f_FomatNumericToChar(@v1slivepositiontaking_7 ),SPACE(1)) + '" ' +
	'slivept_8="'+ COALESCE(dbo.f_FomatNumericToChar(@v1slivepositiontaking_8 ),SPACE(1)) + '" ' +

	'v2spt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@v2spositiontaking_1 ),SPACE(1)) + '" ' +
	'v2spt_2="'+ COALESCE(dbo.f_FomatNumericToChar(@v2spositiontaking_2 ),SPACE(1)) + '" ' +
	'v2spt_3="'+ COALESCE(dbo.f_FomatNumericToChar(@v2spositiontaking_3 ),SPACE(1)) + '" ' +
	'v2spt_7="'+ COALESCE(dbo.f_FomatNumericToChar(@v2spositiontaking_7 ),SPACE(1)) + '" ' +
	'v2spt_8="'+ COALESCE(dbo.f_FomatNumericToChar(@v2spositiontaking_8 ),SPACE(1)) + '" ' +
	'v2spt_20="'+ COALESCE(dbo.f_FomatNumericToChar(@v2spositiontaking_20 ),SPACE(1)) + '" ' +

	'v3spt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@v3spositiontaking_1 ),SPACE(1)) + '" ' +
	'v3spt_2="'+ COALESCE(dbo.f_FomatNumericToChar(@v3spositiontaking_2 ),SPACE(1)) + '" ' +
	'v3spt_3="'+ COALESCE(dbo.f_FomatNumericToChar(@v3spositiontaking_3 ),SPACE(1)) + '" ' +
	'v3spt_20="'+ COALESCE(dbo.f_FomatNumericToChar(@v3spositiontaking_20 ),SPACE(1)) + '" ' +

	'v5spt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@v5spositiontaking_1 ),SPACE(1)) + '" ' +
	'v5spt_2="'+ COALESCE(dbo.f_FomatNumericToChar(@v5spositiontaking_2 ),SPACE(1)) + '" ' +
	'v5spt_3="'+ COALESCE(dbo.f_FomatNumericToChar(@v5spositiontaking_3 ),SPACE(1)) + '" ' +
	'v5spt_20="'+ COALESCE(dbo.f_FomatNumericToChar(@v5spositiontaking_20 ),SPACE(1)) + '" ' +

	'v8spt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@v8spositiontaking_1 ),SPACE(1)) + '" ' +
	'v8spt_3="'+ COALESCE(dbo.f_FomatNumericToChar(@v8spositiontaking_3 ),SPACE(1)) + '" ' +
	'v8spt_20="'+ COALESCE(dbo.f_FomatNumericToChar(@v8spositiontaking_20 ),SPACE(1)) + '" ' +

	'v10spt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@v10spositiontaking_1 ),SPACE(1)) + '" ' +
	'v10spt_2="'+ COALESCE(dbo.f_FomatNumericToChar(@v10spositiontaking_2 ),SPACE(1)) + '" ' +
	'v10spt_3="'+ COALESCE(dbo.f_FomatNumericToChar(@v10spositiontaking_3 ),SPACE(1)) + '" ' +
	'v10spt_20="'+ COALESCE(dbo.f_FomatNumericToChar(@v10spositiontaking_20 ),SPACE(1)) + '" ' +

	'v11spt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@v11spositiontaking_1 ),SPACE(1)) + '" ' +
	'v11spt_20="'+ COALESCE(dbo.f_FomatNumericToChar(@v11spositiontaking_20 ),SPACE(1)) + '" ' +

	'v99spt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@v99spositiontaking_1 ),SPACE(1)) + '" ' +
	'v99spt_2="'+ COALESCE(dbo.f_FomatNumericToChar(@v99spositiontaking_2 ),SPACE(1)) + '" ' +
	'v99spt_3="'+ COALESCE(dbo.f_FomatNumericToChar(@v99spositiontaking_3 ),SPACE(1)) + '" ' +
	'v99spt_9="'+ COALESCE(dbo.f_FomatNumericToChar(@v99spositiontaking_9 ),SPACE(1)) + '" ' +
	'v99spt_20="'+ COALESCE(dbo.f_FomatNumericToChar(@v99spositiontaking_20 ),SPACE(1)) + '" ' +


	'v161spt_81="'+ COALESCE(dbo.f_FomatNumericToChar(@v161spositiontaking_81),SPACE(1)) + '" ' +
	'v161spt_83="'+ COALESCE(dbo.f_FomatNumericToChar(@v161spositiontaking_83),SPACE(1)) + '" ' +
	'v161spt_86="'+ COALESCE(dbo.f_FomatNumericToChar(@v161spositiontaking_86),SPACE(1)) + '" ' +
	'v161spt_88="'+ COALESCE(dbo.f_FomatNumericToChar(@v161spositiontaking_88),SPACE(1)) + '" ' +
	'v161slivept_85="'+ COALESCE(dbo.f_FomatNumericToChar(@v161slivepositiontaking_85),SPACE(1)) + '" ' +
	'v161slivept_86="'+ COALESCE(dbo.f_FomatNumericToChar(@v161slivepositiontaking_86),SPACE(1)) + '" ' +
	'v161slivept_87="'+ COALESCE(dbo.f_FomatNumericToChar(@v161slivepositiontaking_87),SPACE(1)) + '" ' +
	'v161slivept_89="'+ COALESCE(dbo.f_FomatNumericToChar(@v161slivepositiontaking_89),SPACE(1)) + '" ' +
	'v161slivept_90="'+ COALESCE(dbo.f_FomatNumericToChar(@v161slivepositiontaking_90),SPACE(1)) + '" ' +
	@str_spt+	' />' +


	'<m mpt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@v1mpositiontaking_1 ),SPACE(1)) + '" ' +
	'mpt_2="'+ COALESCE(dbo.f_FomatNumericToChar(@v1mpositiontaking_2 ),SPACE(1)) + '" ' +
	'mpt_3="'+ COALESCE(dbo.f_FomatNumericToChar(@v1mpositiontaking_3 ),SPACE(1)) + '" ' +
	'mpt_4="'+ COALESCE(dbo.f_FomatNumericToChar(@v1mpositiontaking_4 ),SPACE(1)) + '" ' +
	'mpt_5="'+ COALESCE(dbo.f_FomatNumericToChar(@v1mpositiontaking_5 ),SPACE(1)) + '" ' +
	'mpt_6="'+ COALESCE(dbo.f_FomatNumericToChar(@v1mpositiontaking_6 ),SPACE(1)) + '" ' +
	'mpt_7="'+ COALESCE(dbo.f_FomatNumericToChar(@v1mpositiontaking_7 ),SPACE(1)) + '" ' +
	'mpt_8="'+ COALESCE(dbo.f_FomatNumericToChar(@v1mpositiontaking_8 ),SPACE(1)) + '" ' +
	'mpt_9="'+ COALESCE(dbo.f_FomatNumericToChar(@v1mpositiontaking_9 ),SPACE(1)) + '" ' +
	'mpt_10="'+ COALESCE(dbo.f_FomatNumericToChar(@v1mpositiontaking_10 ),SPACE(1)) + '" ' +
	'mlivept_1="'+ COALESCE(dbo.f_FomatNumericToChar(@v1mlivepositiontaking_1 ),SPACE(1)) + '" ' +
	'mlivept_3="'+ COALESCE(dbo.f_FomatNumericToChar(@v1mlivepositiontaking_3 ),SPACE(1)) + '" ' +
	'mlivept_7="'+ COALESCE(dbo.f_FomatNumericToChar(@v1mlivepositiontaking_7 ),SPACE(1)) + '" ' +
	'mlivept_8="'+ COALESCE(dbo.f_FomatNumericToChar(@v1mlivepositiontaking_8 ),SPACE(1)) + '" ' +

	'v2mpt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@v2mpositiontaking_1 ),SPACE(1)) + '" ' +
	'v2mpt_2="'+ COALESCE(dbo.f_FomatNumericToChar(@v2mpositiontaking_2 ),SPACE(1)) + '" ' +
	'v2mpt_3="'+ COALESCE(dbo.f_FomatNumericToChar(@v2mpositiontaking_3 ),SPACE(1)) + '" ' +
	'v2mpt_7="'+ COALESCE(dbo.f_FomatNumericToChar(@v2mpositiontaking_7 ),SPACE(1)) + '" ' +
	'v2mpt_8="'+ COALESCE(dbo.f_FomatNumericToChar(@v2mpositiontaking_8 ),SPACE(1)) + '" ' +
	'v2mpt_20="'+ COALESCE(dbo.f_FomatNumericToChar(@v2mpositiontaking_20 ),SPACE(1)) + '" ' +

	'v3mpt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@v3mpositiontaking_1 ),SPACE(1)) + '" ' +
	'v3mpt_2="'+ COALESCE(dbo.f_FomatNumericToChar(@v3mpositiontaking_2 ),SPACE(1)) + '" ' +
	'v3mpt_3="'+ COALESCE(dbo.f_FomatNumericToChar(@v3mpositiontaking_3 ),SPACE(1)) + '" ' +
	'v3mpt_20="'+ COALESCE(dbo.f_FomatNumericToChar(@v3mpositiontaking_20 ),SPACE(1)) + '" ' +

	'v5mpt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@v5mpositiontaking_1 ),SPACE(1)) + '" ' +
	'v5mpt_2="'+ COALESCE(dbo.f_FomatNumericToChar(@v5mpositiontaking_2 ),SPACE(1)) + '" ' +
	'v5mpt_3="'+ COALESCE(dbo.f_FomatNumericToChar(@v5mpositiontaking_3 ),SPACE(1)) + '" ' +
	'v5mpt_20="'+ COALESCE(dbo.f_FomatNumericToChar(@v5mpositiontaking_20 ),SPACE(1)) + '" ' +

	'v8mpt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@v8mpositiontaking_1 ),SPACE(1)) + '" ' +
	'v8mpt_3="'+ COALESCE(dbo.f_FomatNumericToChar(@v8mpositiontaking_3 ),SPACE(1)) + '" ' +
	'v8mpt_20="'+ COALESCE(dbo.f_FomatNumericToChar(@v8mpositiontaking_20 ),SPACE(1)) + '" ' +

	'v10mpt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@v10mpositiontaking_1 ),SPACE(1)) + '" ' +
	'v10mpt_2="'+ COALESCE(dbo.f_FomatNumericToChar(@v10mpositiontaking_2 ),SPACE(1)) + '" ' +
	'v10mpt_3="'+ COALESCE(dbo.f_FomatNumericToChar(@v10mpositiontaking_3 ),SPACE(1)) + '" ' +
	'v10mpt_20="'+ COALESCE(dbo.f_FomatNumericToChar(@v10mpositiontaking_20 ),SPACE(1)) + '" ' +

	'v11mpt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@v11mpositiontaking_1 ),SPACE(1)) + '" ' +
	'v11mpt_20="'+ COALESCE(dbo.f_FomatNumericToChar(@v11mpositiontaking_20 ),SPACE(1)) + '" ' +

	'v99mpt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@v99mpositiontaking_1 ),SPACE(1)) + '" ' +
	'v99mpt_2="'+ COALESCE(dbo.f_FomatNumericToChar(@v99mpositiontaking_2 ),SPACE(1)) + '" ' +
	'v99mpt_3="'+ COALESCE(dbo.f_FomatNumericToChar(@v99mpositiontaking_3 ),SPACE(1)) + '" ' +
	'v99mpt_9="'+ COALESCE(dbo.f_FomatNumericToChar(@v99mpositiontaking_9 ),SPACE(1)) + '" ' +
	'v99mpt_20="'+ COALESCE(dbo.f_FomatNumericToChar(@v99mpositiontaking_20 ),SPACE(1)) + '" ' +
	
	'v161mpt_81="'+ COALESCE(dbo.f_FomatNumericToChar(@v161mpositiontaking_81),SPACE(1)) + '" ' +
	'v161mpt_83="'+ COALESCE(dbo.f_FomatNumericToChar(@v161mpositiontaking_83),SPACE(1)) + '" ' +
	'v161mpt_86="'+ COALESCE(dbo.f_FomatNumericToChar(@v161mpositiontaking_86),SPACE(1)) + '" ' +
	'v161mpt_88="'+ COALESCE(dbo.f_FomatNumericToChar(@v161mpositiontaking_88),SPACE(1)) + '" ' +
	'v161mlivept_85="'+ COALESCE(dbo.f_FomatNumericToChar(@v161mlivepositiontaking_85),SPACE(1)) + '" ' +
	'v161mlivept_86="'+ COALESCE(dbo.f_FomatNumericToChar(@v161mlivepositiontaking_86),SPACE(1)) + '" ' +
	'v161mlivept_87="'+ COALESCE(dbo.f_FomatNumericToChar(@v161mlivepositiontaking_87),SPACE(1)) + '" ' +
	'v161mlivept_89="'+ COALESCE(dbo.f_FomatNumericToChar(@v161mlivepositiontaking_89),SPACE(1)) + '" ' +
	'v161mlivept_90="'+ COALESCE(dbo.f_FomatNumericToChar(@v161mlivepositiontaking_90),SPACE(1)) + '" '+
	@str_mpt+	' />'+	'</Acc_Dep_CustomerUpdMember_SAg>' 

	--tracking value old
	DECLARE @pt_SB smallMoney,@pt_NG smallmoney,@pt_KN smallmoney,
			@spt_SB smallMoney =0 ,@spt_NG smallmoney = 0,@spt_KN smallmoney=0
	select top 1 @pt_SB=mpt FROM #data_old where Sporttype=1 AND Bettype =1 and islive =0
	select top 1 @pt_NG=mpt FROM #data_old where Sporttype=161 AND Bettype =81 and islive =0
	
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

	'<s spt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@v1spositiontaking_1 ),SPACE(1)) + '" ' +
	'spt_2="'+ COALESCE(dbo.f_FomatNumericToChar(@v1spositiontaking_2 ),SPACE(1)) + '" ' +
	'spt_3="'+ COALESCE(dbo.f_FomatNumericToChar(@v1spositiontaking_3 ),SPACE(1)) + '" ' +
	'spt_4="'+ COALESCE(dbo.f_FomatNumericToChar(@v1spositiontaking_4 ),SPACE(1)) + '" ' +
	'spt_5="'+ COALESCE(dbo.f_FomatNumericToChar(@v1spositiontaking_5 ),SPACE(1)) + '" ' +
	'spt_6="'+ COALESCE(dbo.f_FomatNumericToChar(@v1spositiontaking_6 ),SPACE(1)) + '" ' +
	'spt_7="'+ COALESCE(dbo.f_FomatNumericToChar(@v1spositiontaking_7 ),SPACE(1)) + '" ' +
	'spt_8="'+ COALESCE(dbo.f_FomatNumericToChar(@v1spositiontaking_8 ),SPACE(1)) + '" ' +
	'spt_9="'+ COALESCE(dbo.f_FomatNumericToChar(@v1spositiontaking_9 ),SPACE(1)) + '" ' +
	'spt_10="'+ COALESCE(dbo.f_FomatNumericToChar(@v1spositiontaking_10 ),SPACE(1)) + '" ' +
	'slivept_1="'+ COALESCE(dbo.f_FomatNumericToChar(@v1slivepositiontaking_1 ),SPACE(1)) + '" ' +
	'slivept_3="'+ COALESCE(dbo.f_FomatNumericToChar(@v1slivepositiontaking_3 ),SPACE(1)) + '" ' +
	'slivept_7="'+ COALESCE(dbo.f_FomatNumericToChar(@v1slivepositiontaking_7 ),SPACE(1)) + '" ' +
	'slivept_8="'+ COALESCE(dbo.f_FomatNumericToChar(@v1slivepositiontaking_8 ),SPACE(1)) + '" ' +

	'v2spt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@v2spositiontaking_1 ),SPACE(1)) + '" ' +
	'v2spt_2="'+ COALESCE(dbo.f_FomatNumericToChar(@v2spositiontaking_2 ),SPACE(1)) + '" ' +
	'v2spt_3="'+ COALESCE(dbo.f_FomatNumericToChar(@v2spositiontaking_3 ),SPACE(1)) + '" ' +
	'v2spt_7="'+ COALESCE(dbo.f_FomatNumericToChar(@v2spositiontaking_7 ),SPACE(1)) + '" ' +
	'v2spt_8="'+ COALESCE(dbo.f_FomatNumericToChar(@v2spositiontaking_8 ),SPACE(1)) + '" ' +
	'v2spt_20="'+ COALESCE(dbo.f_FomatNumericToChar(@v2spositiontaking_20 ),SPACE(1)) + '" ' +

	'v3spt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@v3spositiontaking_1 ),SPACE(1)) + '" ' +
	'v3spt_2="'+ COALESCE(dbo.f_FomatNumericToChar(@v3spositiontaking_2 ),SPACE(1)) + '" ' +
	'v3spt_3="'+ COALESCE(dbo.f_FomatNumericToChar(@v3spositiontaking_3 ),SPACE(1)) + '" ' +
	'v3spt_20="'+ COALESCE(dbo.f_FomatNumericToChar(@v3spositiontaking_20 ),SPACE(1)) + '" ' +

	'v5spt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@v5spositiontaking_1 ),SPACE(1)) + '" ' +
	'v5spt_2="'+ COALESCE(dbo.f_FomatNumericToChar(@v5spositiontaking_2 ),SPACE(1)) + '" ' +
	'v5spt_3="'+ COALESCE(dbo.f_FomatNumericToChar(@v5spositiontaking_3 ),SPACE(1)) + '" ' +
	'v5spt_20="'+ COALESCE(dbo.f_FomatNumericToChar(@v5spositiontaking_20 ),SPACE(1)) + '" ' +

	'v8spt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@v8spositiontaking_1 ),SPACE(1)) + '" ' +
	'v8spt_3="'+ COALESCE(dbo.f_FomatNumericToChar(@v8spositiontaking_3 ),SPACE(1)) + '" ' +
	'v8spt_20="'+ COALESCE(dbo.f_FomatNumericToChar(@v8spositiontaking_20 ),SPACE(1)) + '" ' +

	'v10spt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@v10spositiontaking_1 ),SPACE(1)) + '" ' +
	'v10spt_2="'+ COALESCE(dbo.f_FomatNumericToChar(@v10spositiontaking_2 ),SPACE(1)) + '" ' +
	'v10spt_3="'+ COALESCE(dbo.f_FomatNumericToChar(@v10spositiontaking_3 ),SPACE(1)) + '" ' +
	'v10spt_20="'+ COALESCE(dbo.f_FomatNumericToChar(@v10spositiontaking_20 ),SPACE(1)) + '" ' +

	'v11spt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@v11spositiontaking_1 ),SPACE(1)) + '" ' +
	'v11spt_20="'+ COALESCE(dbo.f_FomatNumericToChar(@v11spositiontaking_20 ),SPACE(1)) + '" ' +

	'v99spt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@v99spositiontaking_1 ),SPACE(1)) + '" ' +
	'v99spt_2="'+ COALESCE(dbo.f_FomatNumericToChar(@v99spositiontaking_2 ),SPACE(1)) + '" ' +
	'v99spt_3="'+ COALESCE(dbo.f_FomatNumericToChar(@v99spositiontaking_3 ),SPACE(1)) + '" ' +
	'v99spt_9="'+ COALESCE(dbo.f_FomatNumericToChar(@v99spositiontaking_9 ),SPACE(1)) + '" ' +
	'v99spt_20="'+ COALESCE(dbo.f_FomatNumericToChar(@v99spositiontaking_20 ),SPACE(1)) + '" ' +
	
	'v161spt_81="'+ COALESCE(dbo.f_FomatNumericToChar(@v161spositiontaking_81),SPACE(1)) + '" ' +
	'v161spt_83="'+ COALESCE(dbo.f_FomatNumericToChar(@v161spositiontaking_83),SPACE(1)) + '" ' +
	'v161spt_86="'+ COALESCE(dbo.f_FomatNumericToChar(@v161spositiontaking_86),SPACE(1)) + '" ' +
	'v161spt_88="'+ COALESCE(dbo.f_FomatNumericToChar(@v161spositiontaking_88),SPACE(1)) + '" ' +
	'v161slivept_85="'+ COALESCE(dbo.f_FomatNumericToChar(@v161slivepositiontaking_85),SPACE(1)) + '" ' +
	'v161slivept_86="'+ COALESCE(dbo.f_FomatNumericToChar(@v161slivepositiontaking_86),SPACE(1)) + '" ' +
	'v161slivept_87="'+ COALESCE(dbo.f_FomatNumericToChar(@v161slivepositiontaking_87),SPACE(1)) + '" ' +
	'v161slivept_89="'+ COALESCE(dbo.f_FomatNumericToChar(@v161slivepositiontaking_89),SPACE(1)) + '" ' +
	'v161slivept_90="'+ COALESCE(dbo.f_FomatNumericToChar(@v161slivepositiontaking_90),SPACE(1)) + '" ' +
	@str_spt_+	' />' +


	'<m mpt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'mpt_2="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'mpt_3="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'mpt_4="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'mpt_5="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'mpt_6="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'mpt_7="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'mpt_8="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'mpt_9="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'mpt_10="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'mlivept_1="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'mlivept_3="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'mlivept_7="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'mlivept_8="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +

	'v2mpt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'v2mpt_2="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'v2mpt_3="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'v2mpt_7="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'v2mpt_8="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'v2mpt_20="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +

	'v3mpt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'v3mpt_2="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'v3mpt_3="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'v3mpt_20="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +

	'v5mpt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'v5mpt_2="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'v5mpt_3="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'v5mpt_20="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +

	'v8mpt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'v8mpt_3="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'v8mpt_20="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +

	'v10mpt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'v10mpt_2="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'v10mpt_3="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'v10mpt_20="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +

	'v11mpt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'v11mpt_20="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +

	'v99mpt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'v99mpt_2="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'v99mpt_3="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'v99mpt_9="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'v99mpt_20="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	
	'v161mpt_81="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_NG),SPACE(1)) + '" ' +
	'v161mpt_83="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_NG),SPACE(1)) + '" ' +
	'v161mpt_86="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_NG),SPACE(1)) + '" ' +
	'v161mpt_88="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_NG),SPACE(1)) + '" ' +
	'v161mlivept_85="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_NG),SPACE(1)) + '" ' +
	'v161mlivept_86="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_NG),SPACE(1)) + '" ' +
	'v161mlivept_87="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_NG),SPACE(1)) + '" ' +
	'v161mlivept_89="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_NG),SPACE(1)) + '" ' +
	'v161mlivept_90="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_NG),SPACE(1)) + '" ' +
	@str_mpt_+	' />' +
	'</Acc_Dep_CustomerUpdMember_SAg>'


	EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP 
		@UserID = @UserID,
		@CustID = @CustID,
		@ActionID = 2705,
		@TrackingValue = @LogSPData,
		@TrackingValue2 = @LogSPData2,
		@duration = @duration

	DROP TABLE #data
	DROP TABLE #Data_Upline
	DROP TABLE #data_old
	DROP TABLE #tmp_Bettype
	DROP TABLE #tmp_Sports
	DROP TABLE #tmp_GameType
END
GO
