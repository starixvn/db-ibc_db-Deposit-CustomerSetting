/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_CustomerUpdMember_MAg]
	@custid int, -- Agent ID
	@UserID int = 0,

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
	@MinBetv1mp money = 0,
	@MaxBetv1mp money = 0,
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
Task : Master update MinBet, MaxBet, MaxPerMatch, PT, Commission of Agent
DB: DBCUST.CUSTDB

Revisions:
    - 20121128@Elodie: Get an error message from f_Get_MsgNameByMsgID function by language
	- 20130918@Don: Supporting save log of Number Game PT with format such as "0.995", "0.925", ...
	- 20131014@Francis: Support updating virtual sports with settings via XML param
	- 20131119@Francis: Update 3rd product commission of Agent will not impact 3rd product commission of its downline members anymore
    - 20131108@Elodie: Splitting bodb02 into CustDB (call sports, bettype by link database)	
	- 20140505@Florent: Add new sport HR Fixed Odds
	- 20140512@Florent: Add sport Keno 202
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
	
Param's Explanation:
• @ErrCode:
    = 0: Update successfully.
    > 0: Specific Error.
  
• @ErrMsg: Error description.
• @VirtualSportList: VirtualSport Settings XML param.
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



	--Setup default data
	SELECT    @v1mpositiontaking_1 	= 0,
		@v1mpositiontaking_2 		= 0,
		@v1mpositiontaking_3 		= 0,
		@v1mpositiontaking_4 		= 0,
		@v1mpositiontaking_5 		= 0,
		@v1mpositiontaking_6 		= 0,
		@v1mpositiontaking_7 		= 0,
		@v1mpositiontaking_8 		= 0,
		@v1mpositiontaking_9 		= 0,
		@v1mpositiontaking_10 		= 0,
		@v1mlivepositiontaking_1 	= 0,
		@v1mlivepositiontaking_3 	= 0,
		@v1mlivepositiontaking_7 	= 0,
		@v1mlivepositiontaking_8 	= 0,
		                            
		@v2mpositiontaking_1 		= 0,
		@v2mpositiontaking_2 		= 0,
		@v2mpositiontaking_3 		= 0,
		@v2mpositiontaking_7 		= 0,
		@v2mpositiontaking_8 		= 0,
		@v2mpositiontaking_20 		= 0,
		                            
		@v3mpositiontaking_1 		= 0,
		@v3mpositiontaking_2 		= 0,
		@v3mpositiontaking_3 		= 0,
		@v3mpositiontaking_20 		= 0,
	                                
		@v5mpositiontaking_1 		= 0,
		@v5mpositiontaking_2 		= 0,
		@v5mpositiontaking_3 		= 0,
		@v5mpositiontaking_20 		= 0,
	                                
		@v8mpositiontaking_1 		= 0,
		@v8mpositiontaking_3 		= 0,
		@v8mpositiontaking_20 		= 0,
	                                
		@v10mpositiontaking_1 		= 0,
		@v10mpositiontaking_2 		= 0,
		@v10mpositiontaking_3 		= 0,
		@v10mpositiontaking_20 		= 0,
	                                
		@v11mpositiontaking_1 		= 0,
		@v11mpositiontaking_20 		= 0,
	    
		
		@v99mpositiontaking_1 		= 0,
		@v99mpositiontaking_2 		= 0,
		@v99mpositiontaking_3 		= 0,
		@v99mpositiontaking_20 		= 0,		
	                                
		-- mix parlay of mixed sport= 0,
		@v99mpositiontaking_9 		= 0,
	                                
		-- number game              
		@v161mpositiontaking_81 	= 0,
		@v161mpositiontaking_83 	= 0,
		@v161mpositiontaking_86 	= 0,
		@v161mpositiontaking_88 	= 0,
			                        
		@v161mlivepositiontaking_85 = 0,
		@v161mlivepositiontaking_86 = 0,
		@v161mlivepositiontaking_87 = 0,
		@v161mlivepositiontaking_89 = 0,
		@v161mlivepositiontaking_90 = 0

	declare @startRun datetime
	declare @endRun datetime
	declare @duration int
	set @startRun = getdate()

	Declare 
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
		
	declare @ErrAcc varchar(4000), @ErrType varchar(4000),
			@UserName varchar(30), @mrecommend int

	Select @UserName = username, @mrecommend = mrecommend
	from customer with (NOLOCK)
	where CustID = @CustID

	Select @MinMinBetv1 = 0, @MaxMaxBetv1 = 0,
		@MinMinBetv2 = 0, @MaxMaxBetv2 = 0,
		@MinMinBetv3 = 0, @MaxMaxBetv3 = 0,
		@MinMinBetv5 = 0, @MaxMaxBetv5 = 0,
		@MinMinBetv8 = 0, @MaxMaxBetv8 = 0,
		@MinMinBetv10 = 0, @MaxMaxBetv10 = 0,
		@MinMinBetv11 = 0, @MaxMaxBetv11 = 0,
		
		@MinMinBetv99 = 0, @MaxMaxBetv99 = 0,
		
		@MinMinBetv1MP = 0, @MaxMaxBetv1MP = 0,
		@MinMinBetv99MP = 0, @MaxMaxBetv99MP = 0,
		@MinMinBetv161 = 0, @MaxMaxBetv161 = 0

	Select 
		@MinMinBetv1 = isnull(Max(case when MinBet = 0 then NULL else MinBet end),0), 
		@MaxMaxBetv1 = isnull(Min(case when MaxBet = 0 then NULL else MaxBet end),0)
	from 
		dep_custsetting as cs WITH (NOLOCK)
		INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend) and cs.bettype = 1 and cs.sporttype=1
	where ci.custid = @MRecommend

	Select 
		@MinMinBetv2 = isnull(Max(case when MinBet = 0 then NULL else MinBet end),0), 
		@MaxMaxBetv2 = isnull(Min(case when MaxBet = 0 then NULL else MaxBet end),0)
	from 
		dep_custsetting as cs WITH (NOLOCK)
		INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend) and cs.bettype = 1 and cs.sporttype=2
	where ci.custid = @MRecommend

	Select 
		@MinMinBetv3 = isnull(Max(case when MinBet = 0 then NULL else MinBet end),0), 
		@MaxMaxBetv3 = isnull(Min(case when MaxBet = 0 then NULL else MaxBet end),0)
	from 
		dep_custsetting as cs WITH (NOLOCK)
		INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend) and cs.bettype = 1 and cs.sporttype=3
	where ci.custid = @MRecommend

	Select 
		@MinMinBetv5 = isnull(Max(case when MinBet = 0 then NULL else MinBet end),0), 
		@MaxMaxBetv5 = isnull(Min(case when MaxBet = 0 then NULL else MaxBet end),0)
	from 
		dep_custsetting as cs WITH (NOLOCK)
		INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend) and cs.bettype = 1 and cs.sporttype=5
	where ci.custid = @MRecommend

	Select 
		@MinMinBetv8 = isnull(Max(case when MinBet = 0 then NULL else MinBet end),0), 
		@MaxMaxBetv8 = isnull(Min(case when MaxBet = 0 then NULL else MaxBet end),0)
	from 
		dep_custsetting as cs WITH (NOLOCK)
		INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend) and cs.bettype = 1 and cs.sporttype=8
	where ci.custid = @MRecommend

	Select 
		@MinMinBetv10 = isnull(Max(case when MinBet = 0 then NULL else MinBet end),0), 
		@MaxMaxBetv10 = isnull(Min(case when MaxBet = 0 then NULL else MaxBet end),0)
	from 
		dep_custsetting as cs WITH (NOLOCK)
		INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend) and cs.bettype = 1 and cs.sporttype=10
	where ci.custid = @MRecommend

	Select 
		@MinMinBetv11 = isnull(Max(case when MinBet = 0 then NULL else MinBet end),0), 
		@MaxMaxBetv11 = isnull(Min(case when MaxBet = 0 then NULL else MaxBet end),0)
	from 
		dep_custsetting as cs WITH (NOLOCK)
		INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend) and cs.bettype = 1 and cs.sporttype=11
	where ci.custid = @MRecommend

	
	Select 
		@MinMinBetv99 = isnull(Max(case when MinBet = 0 then NULL else MinBet end),0), 
		@MaxMaxBetv99 = isnull(Min(case when MaxBet = 0 then NULL else MaxBet end),0)
	from 
		dep_custsetting as cs WITH (NOLOCK)
		INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend) and cs.bettype = 1 and cs.sporttype=99
	where ci.custid = @MRecommend

	
	-- mixed sports
	Select 
		@MinMinBetv1MP = isnull(Max(case when MinBet = 0 then NULL else MinBet end),0), 
		@MaxMaxBetv1MP = isnull(Min(case when MaxBet = 0 then NULL else MaxBet end),0)
	from 
		dep_custsetting as cs WITH (NOLOCK)
		INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend) and cs.bettype = 9 and cs.sporttype=1
	where ci.custid = @MRecommend
	
	Select 
		@MinMinBetv99MP = isnull(Max(case when MinBet = 0 then NULL else MinBet end),0), 
		@MaxMaxBetv99MP = isnull(Min(case when MaxBet = 0 then NULL else MaxBet end),0)
	from 
		dep_custsetting as cs WITH (NOLOCK)
		INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend) and cs.bettype = 9 and cs.sporttype=99
	where ci.custid = @MRecommend

	-- number game
	Select 
		@MinMinBetv161 = isnull(Max(case when MinBet = 0 then NULL else MinBet end),0), 
		@MaxMaxBetv161 = isnull(Min(case when MaxBet = 0 then NULL else MaxBet end),0)
	from 
		dep_custsetting3rd as cs3 WITH (NOLOCK)
		INNER JOIN custinfo as ci WITH (NOLOCK) on (cs3.CustID = ci.MRecommend or cs3.CustID = ci.SRecommend) and cs3.bettype = 81 and cs3.sporttype=161
	where ci.custid = @MRecommend

	Select	
		@MaxMaxperMatchv1 = isnull(Min(case when cs.MaxPerMatch = 0 then NULL else cs.MaxPerMatch end),0), 
		@MaxMaxPerMatchv2 = isnull(Min(case when cs.MaxPerMatch2 = 0 then NULL else cs.MaxPerMatch2 end),0),
		@MaxMaxPerMatchv3 = isnull(Min(case when cs.MaxPerMatch3 = 0 then NULL else cs.MaxPerMatch3 end),0),
		@MaxMaxPerMatchv5 = isnull(Min(case when cs.MaxPerMatch5 = 0 then NULL else cs.MaxPerMatch5 end),0),
		@MaxMaxPerMatchv8 = isnull(Min(case when cs.MaxPerMatch8 = 0 then NULL else cs.MaxPerMatch8 end),0),
		@MaxMaxPerMatchv10 = isnull(Min(case when cs.MaxPerMatch10 = 0 then NULL else cs.MaxPerMatch10 end),0),
		@MaxMaxPerMatchv11 = isnull(Min(case when cs.MaxPerMatch11 = 0 then NULL else cs.MaxPerMatch11 end),0),
		
		@MaxMaxPerMatchv99 = isnull(Min(case when cs.MaxPerMatch99 = 0 then NULL else cs.MaxPerMatch99 end),0),
		
		@MaxMaxPerMatchv1MP = isnull(Min(case when cs.MaxPerMatch1MP = 0 then NULL else cs.MaxPerMatch1MP end),0),	
		@MaxMaxPerMatchv99MP = isnull(Min(case when cs.MaxPerMatch99MP = 0 then NULL else cs.MaxPerMatch99MP end),0),	
		@MaxMaxPerMatchv161 = isnull(Min(case when cs.MaxPerMatch161 = 0 then NULL else cs.MaxPerMatch161 end),0),
		@MaxMaxPerBallv161 = isnull(Min(case when cs.MaxPerBall161 = 0 then NULL else cs.MaxPerBall161 end),0)
	from 
		custinfo as cs WITH (NOLOCK) 
		INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend)
	where ci.custid = @CustID

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

	if (@MinBetv1<>0 and @MaxBetv1 <> 0 and  @MinBetv1>@MaxBetv1) or (@MaxBetv1<> 0 and @MaxPerMatchv1 <> 0 and @MaxBetv1>@MaxPerMatchv1) 
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						case @Language 
							when 'E' then 'Min bet must be less than max bet and max bet must be less than max bet per match (for Soccer)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](1,@Language) + ')'
						end						
						+ char(13) + char(10) + convert(varchar(20), @MinBetv1) + '-' + convert(varchar(20), @MaxBetv1) + '-' + convert(varchar(20), @MaxPerMatchv1), @ErrCode = 109					 
			
		return
	END

	if (@MinMinBetv1>0 and @MinBetv1>0 and @MinBetv1<@MinMinBetv1)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						case @Language 
							when 'E' then 'Min bet must be equal to or greater than Master Agent min bet (for Soccer)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10019,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](1,@Language) + ')'
						end						
						+' (' + convert(varchar(20), @MinMinBetv1) + ').', @ErrCode = 110				 
			
		return
	END

	if (@MaxMaxBetv1>0 and @MaxBetv1>0 and @MaxBetv1>@MaxMaxBetv1)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						case @Language 
							when 'E' then 'Max bet must be equal to or less than Master Agent max bet (for Soccer)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10020,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](1,@Language) + ')'
						end						
						+' (' + convert(varchar(20), @MaxMaxBetv1) + ').', @ErrCode = 111					 
			
		return
	END

	if (@MaxMaxPerMatchv1>0 and @MaxPerMatchv1>0 and @MaxPerMatchv1>@MaxMaxPerMatchv1)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						case @Language 
							when 'E' then 'Max Per Match must be equal to or less than Master Agent Max Per Match (for Soccer)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10021,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](1,@Language) + ')'
						end						
						+' (' + convert(varchar(20), @MaxMaxPerMatchv1) + ').', @ErrCode = 111					 
			
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

	if (@MinMinBetv2>0 and @MinBetv2>0 and @MinBetv2<@MinMinBetv2)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						case @Language 
							when 'E' then 'Min bet must be equal to or greater than Master Agent min bet (for Basketball)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10019,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](2,@Language) + ')'
						end						
						+' (' + convert(varchar(20), @MinMinBetv2) + ').', @ErrCode = 113					 
			
		return
	END

	if (@MaxMaxBetv2>0 and @MaxBetv2>0 and @MaxBetv2>@MaxMaxBetv2)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						case @Language 
							when 'E' then 'Max bet must be equal to or less than Master Agent max bet (for Basketball)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10020,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](2,@Language) + ')'
						end						
						+' (' + convert(varchar(20), @MaxMaxBetv2) + ').', @ErrCode = 114					 
			
		return
	END
	if (@MaxMaxPerMatchv2>0 and @MaxPerMatchv2>0 and @MaxPerMatchv2>@MaxMaxPerMatchv2)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						case @Language 
							when 'E' then 'Max Per Match must be equal to or less than Master Agent Max Per Match (for Basketball)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10021,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](2,@Language) + ')'
						end						
						+' (' + convert(varchar(20), @MaxMaxPerMatchv2) + ').', @ErrCode = 114					 
			
		return
	END

	if (@MinBetv3 <> 0 and @MaxBetv3 <> 0 and @MinBetv3>@MaxBetv3) or (@MaxBetv3 <> 0 and @MaxPerMatchv3 <> 0 and @MaxBetv3>@MaxPerMatchv3)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						case @Language 
							when 'E' then 'Min bet must be less than max bet and max bet must be less than max bet per match (for Football)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](3,@Language) + ')'
						end						
						+ char(13) + char(10) + convert(varchar(20), @MinBetv3) + '-' + convert(varchar(20), @MaxBetv3) + '-' + convert(varchar(20), @MaxPerMatchv3), @ErrCode = 112					 
			
		return
	END

	if (@MinMinBetv3>0 and @MinBetv3>0 and @MinBetv3<@MinMinBetv3)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						case @Language 
							when 'E' then 'Min bet must be equal to or greater than Master Agent min bet (for Football)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10019,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](3,@Language) + ')'
						end						
						+' (' + convert(varchar(20), @MinMinBetv3) + ').', @ErrCode = 113					 
			
		return
	END

	if (@MaxMaxBetv3>0 and @MaxBetv3>0 and @MaxBetv3>@MaxMaxBetv3)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						case @Language 
							when 'E' then 'Max bet must be equal to or less than Master Agent max bet (for Football)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10020,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](3,@Language) + ')'					
						end						
						+' (' + convert(varchar(20), @MaxMaxBetv3) + ').', @ErrCode = 114					 
			
		return
	END
	if (@MaxMaxPerMatchv3>0 and @MaxPerMatchv3>0 and @MaxPerMatchv3>@MaxMaxPerMatchv3)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						case @Language 
							when 'E' then 'Max Per Match must be equal to or less than Master Agent Max Per Match (for Football)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10021,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](3,@Language) + ')'
						end						
						+' (' + convert(varchar(20), @MaxMaxPerMatchv3) + ').', @ErrCode = 114					 
			
		return
	END

	if (@MinBetv5 <> 0 and @MaxBetv5 <> 0 and @MinBetv5>@MaxBetv5) or (@MaxBetv5 <> 0 and @MaxPerMatchv5 <> 0 and @MaxBetv5>@MaxPerMatchv5)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						case @Language 
							when 'E' then 'Min bet must be less than max bet and max bet must be less than max bet per match (for Tennis)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](5,@Language) + ')'
						end						
						+ char(13) + char(10) + convert(varchar(20), @MinBetv5) + '-' + convert(varchar(20), @MaxBetv5) + '-' + convert(varchar(20), @MaxPerMatchv5), @ErrCode = 112					 
			
		return
	END

	if (@MinMinBetv5>0 and @MinBetv5>0 and @MinBetv5<@MinMinBetv5)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						case @Language 
							when 'E' then 'Min bet must be equal to or greater than Master Agent min bet (for Tennis)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10019,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](5,@Language) + ')'
						end						
						+' (' + convert(varchar(20), @MinMinBetv5) + ').', @ErrCode = 113					 
			
		return
	END

	if (@MaxMaxBetv5>0 and @MaxBetv5>0 and @MaxBetv5>@MaxMaxBetv5)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						case @Language 
							when 'E' then 'Max bet must be equal to or less than Master Agent max bet (for Tennis)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10020,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](5,@Language) + ')'
						end						
						+' (' + convert(varchar(20), @MaxMaxBetv5) + ').', @ErrCode = 114					 
			
		return
	END
	if (@MaxMaxPerMatchv5>0 and @MaxPerMatchv5>0 and @MaxPerMatchv5>@MaxMaxPerMatchv5)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						case @Language 
							when 'E' then 'Max Per Match must be equal to or less than Master Agent Max Per Match (for Tennis)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10021,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](5,@Language) + ')'
						end						
						+' (' + convert(varchar(20), @MaxMaxPerMatchv5) + ').', @ErrCode = 114					 
			
		return
	END

	if (@MinBetv8 <> 0 and @MaxBetv8 <> 0 and @MinBetv8>@MaxBetv8) or (@MaxBetv8 <> 0 and @MaxPerMatchv8 <> 0 and @MaxBetv8>@MaxPerMatchv8)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						case @Language 
							when 'E' then 'Min bet must be less than max bet and max bet must be less than max bet per match (for Baseball)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](8,@Language) + ')'
						end						
						+ char(13) + char(10) + convert(varchar(20), @MinBetv8) + '-' + convert(varchar(20), @MaxBetv8) + '-' + convert(varchar(20), @MaxPerMatchv8), @ErrCode = 112					 
			
		return
	END

	if (@MinMinBetv8>0 and @MinBetv8>0 and @MinBetv8<@MinMinBetv8)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						case @Language 
							when 'E' then 'Min bet must be equal to or greater than Master Agent min bet (for Baseball)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10019,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](8,@Language) + ')'
						end						
						+' (' + convert(varchar(20), @MinMinBetv8) + ').', @ErrCode = 113					 
			
		return
	END

	if (@MaxMaxBetv8>0 and @MaxBetv8>0 and @MaxBetv8>@MaxMaxBetv8)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						case @Language 
							when 'E' then 'Max bet must be equal to or less than Master Agent max bet (for Baseball)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10020,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](8,@Language) + ')'
						end						
						+' (' + convert(varchar(20), @MaxMaxBetv8) + ').', @ErrCode = 114					 
			
		return
	END
	if (@MaxMaxPerMatchv8>0 and @MaxPerMatchv8>0 and @MaxPerMatchv8>@MaxMaxPerMatchv8)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						case @Language 
							when 'E' then 'Max Per Match must be equal to or less than Master Agent Max Per Match (for Baseball)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10021,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](8,@Language) + ')'
						end						
						+' (' + convert(varchar(20), @MaxMaxPerMatchv8) + ').', @ErrCode = 114					 
			
		return
	END

	if (@MinBetv10 <> 0 and @MaxBetv10 <> 0 and @MinBetv10>@MaxBetv10) or (@MaxBetv10 <> 0 and @MaxPerMatchv10 <> 0 and @MaxBetv10>@MaxPerMatchv10)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						case @Language 
							when 'E' then 'Min bet must be less than max bet and max bet must be less than max bet per match (for Golf)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](10,@Language) + ')'
						end						
						+ char(13) + char(10) + convert(varchar(20), @MinBetv10) + '-' + convert(varchar(20), @MaxBetv10) + '-' + convert(varchar(20), @MaxPerMatchv10), @ErrCode = 112					 
			
		return
	END

	if (@MinMinBetv10>0 and @MinBetv10>0 and @MinBetv10<@MinMinBetv10)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						case @Language 
							when 'E' then 'Min bet must be equal to or greater than Master Agent min bet (for Golf)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10019,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](10,@Language) + ')'						
						end						
						+' (' + convert(varchar(20), @MinMinBetv10) + ').', @ErrCode = 113					 
			
		return
	END

	if (@MaxMaxBetv10>0 and @MaxBetv10>0 and @MaxBetv10>@MaxMaxBetv10)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						case @Language 
							when 'E' then 'Max bet must be equal to or less than Master Agent max bet (for Golf)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10020,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](10,@Language) + ')'
						end						
						+' (' + convert(varchar(20), @MaxMaxBetv10) + ').', @ErrCode = 114					 
			
		return
	END
	if (@MaxMaxPerMatchv10>0 and @MaxPerMatchv10>0 and @MaxPerMatchv10>@MaxMaxPerMatchv10)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						case @Language 
							when 'E' then 'Max Per Match must be equal to or less than Master Agent Max Per Match (for Golf)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10021,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](10,@Language) + ')'
						end						
						+' (' + convert(varchar(20), @MaxMaxPerMatchv10) + ').', @ErrCode = 114					 
			
		return
	END

	if (@MinBetv11 <> 0 and @MaxBetv11 <> 0 and @MinBetv11>@MaxBetv11) or (@MaxBetv11 <> 0 and @MaxPerMatchv11 <> 0 and @MaxBetv11>@MaxPerMatchv11)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						case @Language 
							when 'E' then 'Min bet must be less than max bet and max bet must be less than max bet per match (for Motorsports)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](11,@Language) + ')'
						end						
						+ char(13) + char(10) + convert(varchar(20), @MinBetv11) + '-' + convert(varchar(20), @MaxBetv11) + '-' + convert(varchar(20), @MaxPerMatchv11), @ErrCode = 112					 
			
		return
	END

	if (@MinMinBetv11>0 and @MinBetv11>0 and @MinBetv11<@MinMinBetv11)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						case @Language 
							when 'E' then 'Min bet must be equal to or greater than Master Agent min bet (for Motorsports)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10019,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](11,@Language) + ')'
						end						
						+' (' + convert(varchar(20), @MinMinBetv11) + ').', @ErrCode = 113					 
			
		return
	END

	if (@MaxMaxBetv11>0 and @MaxBetv11>0 and @MaxBetv11>@MaxMaxBetv11)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						case @Language 
							when 'E' then 'Max bet must be equal to or less than Master Agent max bet (for Motorsports)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10020,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](11,@Language) + ')'
						end						
						+' (' + convert(varchar(20), @MaxMaxBetv11) + ').', @ErrCode = 114					 
			
		return
	END
	if (@MaxMaxPerMatchv11>0 and @MaxPerMatchv11>0 and @MaxPerMatchv11>@MaxMaxPerMatchv11)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						case @Language 
							when 'E' then 'Max Per Match must be equal to or less than Master Agent Max Per Match (for Motorsports)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10021,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](11,@Language) + ')'
						end						
						+' (' + convert(varchar(20), @MaxMaxPerMatchv11) + ').', @ErrCode = 114					 
			
		return
	END
	
	if (@MinBetv99 <> 0 and @MaxBetv99 <> 0 and @MinBetv99>@MaxBetv99) or (@MaxBetv99 <> 0 and @MaxPerMatchv99 <> 0 and @MaxBetv99>@MaxPerMatchv99)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						case @Language 
							when 'E' then 'Min bet must be less than max bet and max bet must be less than max bet per match (for Other sports)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](99,@Language) + ')'
						end						
						+ char(13) + char(10) + convert(varchar(20), @MinBetv99) + '-' + convert(varchar(20), @MaxBetv99) + '-' + convert(varchar(20), @MaxPerMatchv99), @ErrCode = 112					 
			
		return
	END

	if (@MinMinBetv99>0 and @MinBetv99>0 and @MinBetv99<@MinMinBetv99)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						case @Language 
							when 'E' then 'Min bet must be equal to or greater than Master Agent min bet (for Other sports)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10019,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](99,@Language) + ')'
						end						
						+' (' + convert(varchar(20), @MinMinBetv99) + ').', @ErrCode = 113					 
			
		return
	END

	if (@MaxMaxBetv99>0 and @MaxBetv99>0 and @MaxBetv99>@MaxMaxBetv99)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						case @Language 
							when 'E' then 'Max bet must be equal to or less than Master Agent max bet (for Other sports)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10020,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](99,@Language) + ')'
						end						
						+' (' + convert(varchar(20), @MaxMaxBetv99) + ').', @ErrCode = 114					 
			
		return
	END
	if (@MaxMaxPerMatchv99>0 and @MaxPerMatchv99>0 and @MaxPerMatchv99>@MaxMaxPerMatchv99)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						case @Language 
							when 'E' then 'Max Per Match must be equal to or less than Master Agent Max Per Match (for Other sports)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10021,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](99,@Language) + ')'
						end						
						+' (' + convert(varchar(20), @MaxMaxPerMatchv99) + ').', @ErrCode = 114					 
			
		return
	END

	if (@MinBetv1MP <> 0 and @MaxBetv1MP <> 0 and @MinBetv1MP > @MaxBetv1MP) or (@MaxBetv1MP <> 0 and @MaxPerMatchv1MP <> 0 and @MaxBetv1MP>@MaxPerMatchv1MP)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
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
						end						
						+ char(13) + char(10) + convert(varchar(20), @MinBetv1MP) + '-' + convert(varchar(20), @MaxBetv1MP) + '-' + convert(varchar(20), @MaxPerMatchv1MP), @ErrCode = 112					 		
		return
	END

	if (@MinMinBetv1MP>0 and @MinBetv1MP>0 and @MinBetv1MP<@MinMinBetv1MP)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						case @Language 
							when 'E' then 'Min bet must be equal to or greater than Master Agent min bet (for Soccer Parlay)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10019,@Language) + case @Language 
																								when 'CS' then N'(供足球串关)'
																								when 'CT' then N'(for Soccer Parlay)'
																								when 'TH' then N'(for Soccer Parlay)'
																								when 'J' then N'(for Soccer Parlay)'
																								when 'KO' then N'(for Soccer Parlay)'
																								when 'VI' then N'(for Soccer Parlay)'
																								else N'(for Soccer Parlay)' END
						end						
						+' (' + convert(varchar(20), @MinMinBetv1MP) + ').', @ErrCode = 113					 
			
		return
	END

	if (@MaxMaxBetv1MP>0 and @MaxBetv1MP>0 and @MaxBetv1MP>@MaxMaxBetv1MP)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						case @Language 
							when 'E' then 'Max bet must be equal to or less than Master Agent max bet (for Soccer Parlay)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10020,@Language) + case @Language 
																								when 'CS' then N'(供足球串关)'
																								when 'CT' then N'(for Soccer Parlay)'
																								when 'TH' then N'(for Soccer Parlay)'
																								when 'J' then N'(for Soccer Parlay)'
																								when 'KO' then N'(for Soccer Parlay)'
																								when 'VI' then N'(for Soccer Parlay)'
																								else N'(for Soccer Parlay)' END
						end						
						+' (' + convert(varchar(20), @MaxMaxBetv1MP) + ').', @ErrCode = 114					 
			
		return
	END
	if (@MaxMaxPerMatchv1MP>0 and @MaxPerMatchv1MP>0 and @MaxPerMatchv1MP>@MaxMaxPerMatchv1MP)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						case @Language 
							when 'E' then 'Max Per Match must be equal to or less than Master Agent Max Per Match (for Soccer Parlay)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10021,@Language) + case @Language 
																								when 'CS' then N'(供足球串关)'
																								when 'CT' then N'(for Soccer Parlay)'
																								when 'TH' then N'(for Soccer Parlay)'
																								when 'J' then N'(for Soccer Parlay)'
																								when 'KO' then N'(for Soccer Parlay)'
																								when 'VI' then N'(for Soccer Parlay)'
																								else N'(for Soccer Parlay)' END
						end						
						+' (' + convert(varchar(20), @MaxMaxPerMatchv1MP) + ').', @ErrCode = 114					 
			
		return
	END
	
	if (@MinBetv99MP <> 0 and @MaxBetv99MP <> 0 and @MinBetv99MP > @MaxBetv99MP) or (@MaxBetv99MP <> 0 and @MaxPerMatchv99MP <> 0 and @MaxBetv99MP>@MaxPerMatchv99MP)
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
						+ char(13) + char(10) + convert(varchar(20), @MinBetv99MP) + '-' + convert(varchar(20), @MaxBetv99MP) + '-' + convert(varchar(20), @MaxPerMatchv99MP), @ErrCode = 112					 		
		return
	END

	if (@MinMinBetv99MP>0 and @MinBetv99MP>0 and @MinBetv99MP<@MinMinBetv99MP)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						case @Language 
							when 'E' then 'Min bet must be equal to or greater than Master Agent min bet (for Mix Sports Parlay)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10019,@Language) + case @Language 
																								when 'CS' then N'(供混合体育过关)'
																								when 'CT' then N'(供混合體育過關)'
																								when 'TH' then N'(สำหรับกีฬาบอลชุด)'
																								when 'J' then N'(Mix Sports Parlay)'
																								when 'KO' then N'(Mix Sports Parlay)'
																								when 'VI' then N'(Mix Sports Parlay)'
																								else N'(Mix Sports Parlay)' END
						end						
						+' (' + convert(varchar(20), @MinMinBetv99MP) + ').', @ErrCode = 113					 
			
		return
	END

	if (@MaxMaxBetv99MP>0 and @MaxBetv99MP>0 and @MaxBetv99MP>@MaxMaxBetv99MP)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						case @Language 
							when 'E' then 'Max bet must be equal to or less than Master Agent max bet (for Mix Sports Parlay)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10020,@Language) + case @Language 
																								when 'CS' then N'(供混合体育过关)'
																								when 'CT' then N'(供混合體育過關)'
																								when 'TH' then N'(สำหรับกีฬาบอลชุด)'
																								when 'J' then N'(Mix Sports Parlay)'
																								when 'KO' then N'(Mix Sports Parlay)'
																								when 'VI' then N'(Mix Sports Parlay)'
																								else N'(Mix Sports Parlay)' END
						end						
						+' (' + convert(varchar(20), @MaxMaxBetv99MP) + ').', @ErrCode = 114					 
			
		return
	END
	if (@MaxMaxPerMatchv99MP>0 and @MaxPerMatchv99MP>0 and @MaxPerMatchv99MP>@MaxMaxPerMatchv99MP)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						case @Language 
							when 'E' then 'Max Per Match must be equal to or less than Master Agent Max Per Match (for Mix Sports Parlay)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10021,@Language) + case @Language 
																								when 'CS' then N'(供混合体育过关)'
																								when 'CT' then N'(供混合體育過關)'
																								when 'TH' then N'(สำหรับกีฬาบอลชุด)'
																								when 'J' then N'(Mix Sports Parlay)'
																								when 'KO' then N'(Mix Sports Parlay)'
																								when 'VI' then N'(Mix Sports Parlay)'
																								else N'(Mix Sports Parlay)' END
						end						
						+' (' + convert(varchar(20), @MaxMaxPerMatchv99MP) + ').', @ErrCode = 114					 
			
		return
	END

	if (@MinBetv161 <> 0 and @MaxBetv161 <> 0 and @MinBetv161 > @MaxBetv161) or (@MaxBetv161 <> 0 and @MaxPerMatchv161 <> 0 and @MaxBetv161>@MaxPerMatchv161)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						case @Language 
							when 'E' then 'Min bet must be less than max bet and max bet must be less than max bet per match (for Number Game)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](161,@Language) + ')'
						end						
						+ char(13) + char(10) + convert(varchar(20), @MinBetv161) + '-' + convert(varchar(20), @MaxBetv161) + '-' + convert(varchar(20), @MaxPerMatchv161), @ErrCode = 112					 		
		return
	END

	if (@MinMinBetv161>0 and @MinBetv161>0 and @MinBetv161<@MinMinBetv161)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						case @Language 
							when 'E' then 'Min bet must be equal to or greater than Master Agent min bet (for Number Game)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10019,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](161,@Language) + ')'
						end						
						+' (' + convert(varchar(20), @MinMinBetv161) + ').', @ErrCode = 113					 
			
		return
	END

	if (@MaxMaxBetv161>0 and @MaxBetv161>0 and @MaxBetv161>@MaxMaxBetv161)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						case @Language 
							when 'E' then 'Max bet must be equal to or less than Master Agent max bet (for Number Game)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10020,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](161,@Language) + ')'
						end
						+' (' + convert(varchar(20), @MaxMaxBetv161) + ').', @ErrCode = 114					 
			
		return
	END
	if (@MaxMaxPerMatchv161>0 and @MaxPerMatchv161>0 and @MaxPerMatchv161>@MaxMaxPerMatchv161)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						case @Language 
							when 'E' then 'Max Per Match must be equal to or less than Master Agent Max Per Match (for Number Game)'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10021,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](161,@Language) + ')'
						end						
						+' (' + convert(varchar(20), @MaxMaxPerMatchv161) + ').', @ErrCode = 114					 
			
		return
	END

	if @MaxPerBallv161 > @MaxMaxPerBallv161 and @MaxMaxPerBallv161 > 0
	begin
		SELECT @ErrMsg =	@UserName + ': '+
				case @Language 
					when 'E' then 'Max per ball must be equal to or less than Master Agent Max Per Ball (Number Game).'
					ELSE [dbo].[f_Get_MsgNamebyMsgID](10011,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](161,@Language) + ')'
				end						
				+' (' + convert(varchar(20), @MaxMaxPerBallv161) + ').', @ErrCode = 201
			return
	end

	/************************************
		Validate PT
	*************************************/

	--check a2<=a4 
	select @ErrType = ''
	select @ErrType = @ErrType + sports.Name + '-'+ bettype.Name + '-Max: '+ cast((scs.apositiontaking) as varchar(10))
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
		inner join #tmp_Sports sports on b.sporttype = sports.ID
		inner join #tmp_Bettype bettype on b.bettype = bettype.ID
	where c.custid = @mrecommend and 
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
		
							  select 1 as sporttype, 1 as bettype, @v1apositiontaking_1 as maxpositiontaking,  @v1alivepositiontaking_1 as maxlivepositiontaking
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
		where c.recommend = @custid and c.roleid = 1 and ((cs.apositiontaking+cs.mpositiontaking>b.maxpositiontaking AND cs.islive = 0) or (b.sporttype=1 and b.bettype in (1,3,7,8) AND cs.islive = 1 and cs.apositiontaking+cs.mpositiontaking>b.maxlivepositiontaking))
		group by username
		if @ErrAcc<>''
		BEGIN
			select @ErrCode = 9
			Select @ErrMsg = 	case @Language 
								when 'E' then 'Existing members exceeded new agent positiontaking ('+@ErrAcc+') (for Sportsbook)'
								ELSE [dbo].[f_Get_MsgNamebyMsgID](20017,@Language) + ' ('+@ErrAcc+') (for Sportsbook)'
						end
			return
		END

	--check a2<=a4
	select @ErrType = ''
	select @ErrType = @ErrType + sports.Name + '-'+ bettype.Name + '-Max: '+ cast((scs.apositiontaking) as varchar(10)) + '<br>'
	from customer as c with (NOLOCK) inner join dep_custsetting as scs with (NOLOCK) on c.srecommend = scs.custid inner join 
		(
				 		select 1 as bettype, 2 as sporttype, @v2apositiontaking_1 as apositiontaking, 0 as alivepositiontaking, @v2mpositiontaking_1 as mpositiontaking, 0 as mlivepositiontaking
			union all 	select 2 as bettype, 2 as sporttype, @v2apositiontaking_2 as apositiontaking, 0 as alivepositiontaking, @v2mpositiontaking_2 as mpositiontaking, 0 as mlivepositiontaking
			union all 	select 3 as bettype, 2 as sporttype, @v2apositiontaking_3 as apositiontaking, 0 as alivepositiontaking, @v2mpositiontaking_3 as mpositiontaking, 0 as mlivepositiontaking
			union all 	select 20 as bettype, 2 as sporttype, @v2apositiontaking_20 as apositiontaking, 0 as alivepositiontaking, @v2mpositiontaking_20 as mpositiontaking, 0 as mlivepositiontaking
		
		) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
		inner join #tmp_Sports sports on b.sporttype = sports.ID
		inner join #tmp_Bettype bettype on b.bettype = bettype.ID
	where c.custid = @mrecommend and (b.apositiontaking>scs.apositiontaking)
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
	select @ErrType = @ErrType + sports.Name + '-'+ bettype.Name + '-Max: '+ cast((scs.apositiontaking) as varchar(10)) + '<br>'
	from customer as c with (NOLOCK) inner join dep_custsetting as scs with (NOLOCK) on c.srecommend = scs.custid inner join 
		(
					select 1 as bettype, 3 as sporttype, @v3apositiontaking_1 as apositiontaking, 0 as alivepositiontaking, @v3mpositiontaking_1 as mpositiontaking, 0 as mlivepositiontaking
			union all 	select 2 as bettype, 3 as sporttype, @v3apositiontaking_2 as apositiontaking, 0 as alivepositiontaking, @v3mpositiontaking_2 as mpositiontaking, 0 as mlivepositiontaking
			union all 	select 3 as bettype, 3 as sporttype, @v3apositiontaking_3 as apositiontaking, 0 as alivepositiontaking, @v3mpositiontaking_3 as mpositiontaking, 0 as mlivepositiontaking
			union all 	select 20 as bettype, 3 as sporttype, @v3apositiontaking_20 as apositiontaking, 0 as alivepositiontaking, @v3mpositiontaking_20 as mpositiontaking, 0 as mlivepositiontaking
		) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
		inner join #tmp_Sports sports on b.sporttype = sports.ID
		inner join #tmp_Bettype bettype on b.bettype = bettype.ID
	where c.custid = @mrecommend and (b.apositiontaking>scs.apositiontaking)
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
	select @ErrType = @ErrType + sports.Name + '-'+ bettype.Name + '-Max: '+ cast((scs.apositiontaking) as varchar(10)) + '<br>'
	from custinfo as c with (NOLOCK) inner join dep_custsetting as scs with (NOLOCK) on c.srecommend = scs.custid inner join 
		(
					select 1 as bettype, 5 as sporttype, @v5apositiontaking_1 as apositiontaking, 0 as alivepositiontaking, @v5mpositiontaking_1 as mpositiontaking, 0 as mlivepositiontaking
			union all 	select 2 as bettype, 5 as sporttype, @v5apositiontaking_2 as apositiontaking, 0 as alivepositiontaking, @v5mpositiontaking_2 as mpositiontaking, 0 as mlivepositiontaking
			union all 	select 3 as bettype, 5 as sporttype, @v5apositiontaking_3 as apositiontaking, 0 as alivepositiontaking, @v5mpositiontaking_3 as mpositiontaking, 0 as mlivepositiontaking
			union all 	select 20 as bettype, 5 as sporttype, @v5apositiontaking_20 as apositiontaking, 0 as alivepositiontaking, @v5mpositiontaking_20 as mpositiontaking, 0 as mlivepositiontaking
		) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
		inner join #tmp_Sports sports on b.sporttype = sports.ID
		inner join #tmp_Bettype bettype on b.bettype = bettype.ID
	where c.custid = @mrecommend and (b.apositiontaking>scs.apositiontaking)
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
	select @ErrType = @ErrType + sports.Name + '-'+ bettype.Name + '-Max: '+ cast((scs.apositiontaking) as varchar(10)) + '<br>'
	from customer as c with (NOLOCK) inner join dep_custsetting as scs with (NOLOCK) on c.srecommend = scs.custid inner join 
		(
					select 1 as bettype, 8 as sporttype, @v8apositiontaking_1 as apositiontaking, 0 as alivepositiontaking, @v8mpositiontaking_1 as mpositiontaking, 0 as mlivepositiontaking
			union all 	select 3 as bettype, 8 as sporttype, @v8apositiontaking_3 as apositiontaking, 0 as alivepositiontaking, @v8mpositiontaking_3 as mpositiontaking, 0 as mlivepositiontaking
			union all 	select 20 as bettype, 8 as sporttype, @v8apositiontaking_20 as apositiontaking, 0 as alivepositiontaking, @v8mpositiontaking_20 as mpositiontaking, 0 as mlivepositiontaking
		) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
		inner join #tmp_Sports sports on b.sporttype = sports.ID
		inner join #tmp_Bettype bettype on b.bettype = bettype.ID
	where c.custid = @mrecommend and (b.apositiontaking>scs.apositiontaking)
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
	select @ErrType = @ErrType + sports.Name + '-'+ bettype.Name + '-Max: '+ cast((scs.apositiontaking) as varchar(10)) + '<br>'
	from custinfo as c with (NOLOCK) inner join dep_custsetting as scs with (NOLOCK) on c.srecommend = scs.custid inner join 
		(
					select 1 as bettype, 10 as sporttype, @v10apositiontaking_1 as apositiontaking, 0 as alivepositiontaking, @v10mpositiontaking_1 as mpositiontaking, 0 as mlivepositiontaking
			union all 	select 2 as bettype, 10 as sporttype, @v10apositiontaking_2 as apositiontaking, 0 as alivepositiontaking, @v10mpositiontaking_2 as mpositiontaking, 0 as mlivepositiontaking
			union all 	select 3 as bettype, 10 as sporttype, @v10apositiontaking_3 as apositiontaking, 0 as alivepositiontaking, @v10mpositiontaking_3 as mpositiontaking, 0 as mlivepositiontaking
			union all 	select 20 as bettype, 10 as sporttype, @v10apositiontaking_20 as apositiontaking, 0 as alivepositiontaking, @v10mpositiontaking_20 as mpositiontaking, 0 as mlivepositiontaking
		) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
		inner join #tmp_Sports sports on b.sporttype = sports.ID
		inner join #tmp_Bettype bettype on b.bettype = bettype.ID
	where c.custid = @mrecommend and (b.apositiontaking>scs.apositiontaking)
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
	select @ErrType = @ErrType + sports.Name + '-'+ bettype.Name + '-Max: '+ cast((scs.apositiontaking) as varchar(10)) + '<br>'
	from custinfo as c with (NOLOCK) inner join dep_custsetting as scs with (NOLOCK) on c.srecommend = scs.custid inner join 
		(
					select 1 as bettype, 11 as sporttype, @v11apositiontaking_1 as apositiontaking, 0 as alivepositiontaking, @v11mpositiontaking_1 as mpositiontaking, 0 as mlivepositiontaking
			union all 	select 20 as bettype, 11 as sporttype, @v11apositiontaking_20 as apositiontaking, 0 as alivepositiontaking, @v11mpositiontaking_20 as mpositiontaking, 0 as mlivepositiontaking
		) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
		inner join #tmp_Sports sports on b.sporttype = sports.ID
		inner join #tmp_Bettype bettype on b.bettype = bettype.ID
	where c.custid = @mrecommend and (b.apositiontaking>scs.apositiontaking)
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
	select @ErrType = @ErrType + sports.Name + '-'+ bettype.Name + '-Max: '+ cast((scs.apositiontaking) as varchar(10)) + '<br>'
	from custinfo as c with (NOLOCK) inner join dep_custsetting as scs with (NOLOCK) on c.srecommend = scs.custid inner join 
		(
					select 1 as bettype, 99 as sporttype, @v99apositiontaking_1 as apositiontaking, 0 as alivepositiontaking, @v99mpositiontaking_1 as mpositiontaking, 0 as mlivepositiontaking
			union all 	select 2 as bettype, 99 as sporttype, @v99apositiontaking_2 as apositiontaking, 0 as alivepositiontaking, @v99mpositiontaking_2 as mpositiontaking, 0 as mlivepositiontaking
			union all 	select 3 as bettype, 99 as sporttype, @v99apositiontaking_3 as apositiontaking, 0 as alivepositiontaking, @v99mpositiontaking_3 as mpositiontaking, 0 as mlivepositiontaking
			union all 	select 20 as bettype, 99 as sporttype, @v99apositiontaking_20 as apositiontaking, 0 as alivepositiontaking, @v99mpositiontaking_20 as mpositiontaking, 0 as mlivepositiontaking
		) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
		inner join #tmp_Sports sports on b.sporttype = sports.ID
		inner join #tmp_Bettype bettype on b.bettype = bettype.ID
	where c.custid = @mrecommend and (b.apositiontaking>scs.apositiontaking)
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
	select @ErrType = @ErrType + sports.Name + '-'+ bettype.Name + '-Max: '+ cast((scs.apositiontaking) as varchar(10)) + '<br>'
	from custinfo as c with (NOLOCK) inner join dep_custsetting as scs with (NOLOCK) on c.srecommend = scs.custid inner join 
		(
			select 9 as bettype, 99 as sporttype, @v99apositiontaking_9 as apositiontaking, 0 as alivepositiontaking, @v99mpositiontaking_9 as mpositiontaking, 0 as mlivepositiontaking
		) as b on scs.sporttype=b.sporttype and scs.bettype = b.bettype
		inner join #tmp_Sports sports on b.sporttype = sports.ID
		inner join #tmp_Bettype bettype on b.bettype = bettype.ID
	where c.custid = @mrecommend and (b.apositiontaking>scs.apositiontaking)
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
	select @ErrType = @ErrType + sports.Name + '-'+ bettype.Name + '-Max: '+ cast((cs3.apositiontaking) as varchar(10))
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
		inner join #tmp_Sports sports on b.sporttype = sports.ID
		inner join #tmp_Bettype bettype on b.bettype = bettype.ID
	where c.custid = @mrecommend and 
		((b.apositiontaking>cs3.apositiontaking AND cs3.islive = 0) or (b.sporttype = 161 and b.bettype in (85,86,87,89) and cs3.islive = 1 and b.alivepositiontaking>cs3.apositiontaking))

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
			inner join dep_custsetting3rd as cs with (NOLOCK) on c.custid = cs.custid
			inner join (
							  select 	161 as sporttype, 81 as bettype, @v161apositiontaking_81 as maxpositiontaking,  0 as maxlivepositiontaking
					union all select 	161 as sporttype, 83 as bettype, @v161apositiontaking_83 as maxpositiontaking,  0 as maxlivepositiontaking
					union all select 	161 as sporttype, 88 as bettype, @v161apositiontaking_88 as maxpositiontaking,  0 as maxlivepositiontaking
					union all select 	161 as sporttype, 85 as bettype, 0 as maxpositiontaking,  @v161alivepositiontaking_85 as maxlivepositiontaking
					union all select	161 as sporttype, 86 as bettype, @v161apositiontaking_86 as maxpositiontaking,  @v161alivepositiontaking_86 as maxlivepositiontaking
					union all select 	161 as sporttype, 87 as bettype, 0 as maxpositiontaking,  @v161alivepositiontaking_87 as maxlivepositiontaking
					union all select 	161 as sporttype, 89 as bettype, 0 as maxpositiontaking,  @v161alivepositiontaking_89 as maxlivepositiontaking
					union all select 	161 as sporttype, 90 as bettype, 0 as maxpositiontaking,  @v161mlivepositiontaking_90 as maxlivepositiontaking
					
				) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
		where c.recommend = @custid and c.roleid = 1 and ((cs.apositiontaking+cs.mpositiontaking>b.maxpositiontaking AND cs.islive = 0) or (b.sporttype=161 and cs.islive = 1 and b.bettype in (85,86,87,89) and cs.apositiontaking+cs.mpositiontaking>b.maxlivepositiontaking))
		group by username
		if @ErrAcc<>''
		BEGIN
			select @ErrCode = 211
			Select @ErrMsg = 	case @Language 
								when 'E' then 'Existing members exceeded new agent positiontaking ('+@ErrAcc+') (for Number Game).'
								ELSE [dbo].[f_Get_MsgNamebyMsgID](20017,@Language) + ' ('+@ErrAcc+') (' + [dbo].[f_Get_SportNameBySporttype](161,@Language) + ')'
						end
			return
		END

	-------------------------------------------------------------------------------------------

	declare
		@max_v1mapositiontaking_1 smallmoney,
		@max_v1mapositiontaking_2 smallmoney,
		@max_v1mapositiontaking_3 smallmoney,
		@max_v1mapositiontaking_4 smallmoney,
		@max_v1mapositiontaking_5 smallmoney,
		@max_v1mapositiontaking_6 smallmoney,
		@max_v1mapositiontaking_7 smallmoney,
		@max_v1mapositiontaking_8 smallmoney,
		@max_v1mapositiontaking_9 smallmoney,
		@max_v1mapositiontaking_10 smallmoney,
		@max_v1malivepositiontaking_1 smallmoney,
		
		@max_v1malivepositiontaking_3 smallmoney,
		@max_v1malivepositiontaking_7 smallmoney,
		@max_v1malivepositiontaking_8 smallmoney,
		
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
		-- mixed sports
		@max_v99mapositiontaking_9 smallmoney,
		-- number game
		@max_v161mapositiontaking_81 smallmoney,
		@max_v161mapositiontaking_83 smallmoney,
		--@max_v161mapositiontaking_85 smallmoney,
		@max_v161mapositiontaking_86 smallmoney,
		@max_v161mapositiontaking_88 smallmoney,
		
		@max_v161malivepositiontaking_85 smallmoney,
		@max_v161malivepositiontaking_86 smallmoney,
		@max_v161malivepositiontaking_87 smallmoney,
		@max_v161malivepositiontaking_89 smallmoney,
		@max_v161malivepositiontaking_90 smallmoney

	select @max_v1mapositiontaking_1 =mpositiontaking from dep_custsetting with (NOLOCK) where custid = @mrecommend and bettype=1 and sporttype=1 and islive = 0
	select @max_v1mapositiontaking_3 =mpositiontaking from dep_custsetting with (NOLOCK) where custid = @mrecommend and bettype=3 and sporttype=1 and islive = 0
	select @max_v1mapositiontaking_7 =mpositiontaking from dep_custsetting with (NOLOCK) where custid = @mrecommend and bettype=7 and sporttype=1 and islive = 0
	select @max_v1mapositiontaking_8 =mpositiontaking from dep_custsetting with (NOLOCK) where custid = @mrecommend and bettype=8 and sporttype=1 and islive = 0

	select @max_v1malivepositiontaking_1 =mpositiontaking from dep_custsetting with (NOLOCK) where custid = @mrecommend and bettype=1 and sporttype=1 and islive = 1
	select @max_v1malivepositiontaking_3 =mpositiontaking from dep_custsetting with (NOLOCK) where custid = @mrecommend and bettype=3 and sporttype=1 and islive = 1
	select @max_v1malivepositiontaking_7 =mpositiontaking from dep_custsetting with (NOLOCK) where custid = @mrecommend and bettype=7 and sporttype=1 and islive = 1
	select @max_v1malivepositiontaking_8 =mpositiontaking from dep_custsetting with (NOLOCK) where custid = @mrecommend and bettype=8 and sporttype=1 and islive = 1

	select @max_v1mapositiontaking_2 =mpositiontaking from dep_custsetting with (NOLOCK) where custid = @mrecommend and bettype=2 and sporttype=1
	select @max_v1mapositiontaking_4 =mpositiontaking from dep_custsetting with (NOLOCK) where custid = @mrecommend and bettype=4 and sporttype=1
	select @max_v1mapositiontaking_5 =mpositiontaking from dep_custsetting with (NOLOCK) where custid = @mrecommend and bettype=5 and sporttype=1
	select @max_v1mapositiontaking_6 =mpositiontaking from dep_custsetting with (NOLOCK) where custid = @mrecommend and bettype=6 and sporttype=1
	select @max_v1mapositiontaking_9 =mpositiontaking from dep_custsetting with (NOLOCK) where custid = @mrecommend and bettype=9 and sporttype=1
	select @max_v1mapositiontaking_10 =mpositiontaking from dep_custsetting with (NOLOCK) where custid = @mrecommend and bettype=10 and sporttype=1

	select @max_v2mapositiontaking_1 =mpositiontaking from dep_custsetting with (NOLOCK) where custid = @mrecommend and bettype=1 and sporttype=2
	select @max_v2mapositiontaking_2 =mpositiontaking from dep_custsetting with (NOLOCK) where custid = @mrecommend and bettype=2 and sporttype=2
	select @max_v2mapositiontaking_3 =mpositiontaking from dep_custsetting with (NOLOCK) where custid = @mrecommend and bettype=3 and sporttype=2
	select @max_v2mapositiontaking_7 =mpositiontaking from dep_custsetting with (NOLOCK) where custid = @mrecommend and bettype=7 and sporttype=2
	select @max_v2mapositiontaking_8 =mpositiontaking from dep_custsetting with (NOLOCK) where custid = @mrecommend and bettype=8 and sporttype=2
	select @max_v2mapositiontaking_20 =mpositiontaking from dep_custsetting with (NOLOCK) where custid = @mrecommend and bettype=20 and sporttype=2

	select @max_v3mapositiontaking_1 =mpositiontaking from dep_custsetting with (NOLOCK) where custid = @mrecommend and bettype=1 and sporttype=3
	select @max_v3mapositiontaking_2 =mpositiontaking from dep_custsetting with (NOLOCK) where custid = @mrecommend and bettype=2 and sporttype=3
	select @max_v3mapositiontaking_3 =mpositiontaking from dep_custsetting with (NOLOCK) where custid = @mrecommend and bettype=3 and sporttype=3
	select @max_v3mapositiontaking_20 =mpositiontaking from dep_custsetting with (NOLOCK) where custid = @mrecommend and bettype=20 and sporttype=3

	select @max_v5mapositiontaking_1 =mpositiontaking from dep_custsetting with (NOLOCK) where custid = @mrecommend and bettype=1 and sporttype=5
	select @max_v5mapositiontaking_2 =mpositiontaking from dep_custsetting with (NOLOCK) where custid = @mrecommend and bettype=2 and sporttype=5
	select @max_v5mapositiontaking_3 =mpositiontaking from dep_custsetting with (NOLOCK) where custid = @mrecommend and bettype=3 and sporttype=5
	select @max_v5mapositiontaking_20 =mpositiontaking from dep_custsetting with (NOLOCK) where custid = @mrecommend and bettype=20 and sporttype=5

	select @max_v8mapositiontaking_1 =mpositiontaking from dep_custsetting with (NOLOCK) where custid = @mrecommend and bettype=1 and sporttype=8
	select @max_v8mapositiontaking_3 =mpositiontaking from dep_custsetting with (NOLOCK) where custid = @mrecommend and bettype=3 and sporttype=8
	select @max_v8mapositiontaking_20 =mpositiontaking from dep_custsetting with (NOLOCK) where custid = @mrecommend and bettype=20 and sporttype=8

	select @max_v10mapositiontaking_1 =mpositiontaking from dep_custsetting with (NOLOCK) where custid = @mrecommend and bettype=1 and sporttype=10
	select @max_v10mapositiontaking_2 =mpositiontaking from dep_custsetting with (NOLOCK) where custid = @mrecommend and bettype=2 and sporttype=10
	select @max_v10mapositiontaking_3 =mpositiontaking from dep_custsetting with (NOLOCK) where custid = @mrecommend and bettype=3 and sporttype=10
	select @max_v10mapositiontaking_20 =mpositiontaking from dep_custsetting with (NOLOCK) where custid = @mrecommend and bettype=20 and sporttype=10

	select @max_v11mapositiontaking_1 =mpositiontaking from dep_custsetting with (NOLOCK) where custid = @mrecommend and bettype=1 and sporttype=11
	select @max_v11mapositiontaking_20 =mpositiontaking from dep_custsetting with (NOLOCK) where custid = @mrecommend and bettype=20 and sporttype=11

	
	select @max_v99mapositiontaking_1 =mpositiontaking from dep_custsetting with (NOLOCK) where custid = @mrecommend and bettype=1 and sporttype=99
	select @max_v99mapositiontaking_2 =mpositiontaking from dep_custsetting with (NOLOCK) where custid = @mrecommend and bettype=2 and sporttype=99
	select @max_v99mapositiontaking_3 =mpositiontaking from dep_custsetting with (NOLOCK) where custid = @mrecommend and bettype=3 and sporttype=99
	select @max_v99mapositiontaking_20 =mpositiontaking from dep_custsetting with (NOLOCK) where custid = @mrecommend and bettype=20 and sporttype=99

	-- mixed sports
	select @max_v99mapositiontaking_9 =mpositiontaking from dep_custsetting with (NOLOCK) where custid = @mrecommend and bettype=9 and sporttype=99

	--number game
	select @max_v161mapositiontaking_81 =mpositiontaking from dep_custsetting3rd with (NOLOCK) where custid = @mrecommend and bettype=81 and sporttype=161
	select @max_v161mapositiontaking_83 =mpositiontaking from dep_custsetting3rd with (NOLOCK) where custid = @mrecommend and bettype=83 and sporttype=161
	select @max_v161malivepositiontaking_85 =mpositiontaking from dep_custsetting3rd with (NOLOCK) where custid = @mrecommend and bettype=85 and sporttype=161 and islive = 1
	select @max_v161mapositiontaking_86 =mpositiontaking from dep_custsetting3rd with (NOLOCK) where custid = @mrecommend and bettype=86 and sporttype=161 and islive = 0
	select @max_v161malivepositiontaking_86 =mpositiontaking from dep_custsetting3rd with (NOLOCK) where custid = @mrecommend and bettype=86 and sporttype=161 and islive = 1
	select @max_v161malivepositiontaking_87 =mpositiontaking from dep_custsetting3rd with (NOLOCK) where custid = @mrecommend and bettype=87 and sporttype=161 and islive = 1
	select @max_v161mapositiontaking_88 =mpositiontaking from dep_custsetting3rd with (NOLOCK) where custid = @mrecommend and bettype=88 and sporttype=161
	select @max_v161malivepositiontaking_89 =mpositiontaking from dep_custsetting3rd with (NOLOCK) where custid = @mrecommend and bettype=89 and sporttype=161 and islive = 1
	select @max_v161malivepositiontaking_90 =mpositiontaking from dep_custsetting3rd with (NOLOCK) where custid = @mrecommend and bettype=90 and sporttype=161 and islive = 1

	--check m2+a2<=m3 - Vinh
	select @ErrType = ''
	select @ErrType = @ErrType + sports.Name + '-'+ bettype.Name + '-Max: '+ cast((b.max_mapositiontaking) as varchar(10))
	+ case when b.sporttype in (1,161) and b.bettype in (1,3,7,8,85,86,87,89) then '-MaxLive: '+ cast((b.max_malivepositiontaking) as varchar(10)) else '' end + '<br>'
	from
	(
				  select 1 as bettype, 1 as sporttype, @v1apositiontaking_1 as apositiontaking, @v1mpositiontaking_1 as mpositiontaking, @max_v1mapositiontaking_1 as max_mapositiontaking, @v1alivepositiontaking_1 as alivepositiontaking, @v1mlivepositiontaking_1 as mlivepositiontaking, @max_v1malivepositiontaking_1 as max_malivepositiontaking
		union all select 3 as bettype, 1 as sporttype, @v1apositiontaking_3 as apositiontaking, @v1mpositiontaking_3 as mpositiontaking, @max_v1mapositiontaking_3 as max_mapositiontaking, @v1alivepositiontaking_3 as alivepositiontaking, @v1mlivepositiontaking_3 as mlivepositiontaking, @max_v1malivepositiontaking_3 as max_malivepositiontaking
		union all select 7 as bettype, 1 as sporttype, @v1apositiontaking_7 as apositiontaking, @v1mpositiontaking_7 as mpositiontaking, @max_v1mapositiontaking_7 as max_mapositiontaking, @v1alivepositiontaking_7 as alivepositiontaking, @v1mlivepositiontaking_7 as mlivepositiontaking, @max_v1malivepositiontaking_7 as max_malivepositiontaking
		union all select 8 as bettype, 1 as sporttype, @v1apositiontaking_8 as apositiontaking, @v1mpositiontaking_8 as mpositiontaking, @max_v1mapositiontaking_8 as max_mapositiontaking, @v1alivepositiontaking_8 as alivepositiontaking, @v1mlivepositiontaking_8 as mlivepositiontaking, @max_v1malivepositiontaking_8 as max_malivepositiontaking
		union all select 2 as bettype, 1 as sporttype, @v1apositiontaking_2 as apositiontaking, @v1mpositiontaking_2 as mpositiontaking, @max_v1mapositiontaking_2 as max_mapositiontaking, 0 as alivepositiontaking, 0 as mlivepositiontaking, 0 as max_malivepositiontaking		
		union all select 4 as bettype, 1 as sporttype, @v1apositiontaking_4 as apositiontaking, @v1mpositiontaking_4 as mpositiontaking, @max_v1mapositiontaking_4 as max_mapositiontaking, 0 as alivepositiontaking, 0 as mlivepositiontaking, 0 as max_malivepositiontaking
		union all select 5 as bettype, 1 as sporttype, @v1apositiontaking_5 as apositiontaking, @v1mpositiontaking_5 as mpositiontaking, @max_v1mapositiontaking_5 as max_mapositiontaking, 0 as alivepositiontaking, 0 as mlivepositiontaking, 0 as max_malivepositiontaking
		union all select 6 as bettype, 1 as sporttype, @v1apositiontaking_6 as apositiontaking, @v1mpositiontaking_6 as mpositiontaking, @max_v1mapositiontaking_6 as max_mapositiontaking, 0 as alivepositiontaking, 0 as mlivepositiontaking, 0 as max_malivepositiontaking
		union all select 9 as bettype, 1 as sporttype, @v1apositiontaking_9 as apositiontaking, @v1mpositiontaking_9 as mpositiontaking, @max_v1mapositiontaking_9 as max_mapositiontaking, 0 as alivepositiontaking, 0 as mlivepositiontaking, 0 as max_malivepositiontaking
		union all select 10 as bettype, 1 as sporttype, @v1apositiontaking_10 as apositiontaking, @v1mpositiontaking_10 as mpositiontaking, @max_v1mapositiontaking_10 as max_mapositiontaking, 0 as alivepositiontaking, 0 as mlivepositiontaking, 0 as max_malivepositiontaking
			
		--v2
		union all select 1 as bettype, 2 as sporttype, @v2apositiontaking_1 as apositiontaking, @v2mpositiontaking_1 as mpositiontaking, @max_v2mapositiontaking_1 as max_mapositiontaking, 0 as alivepositiontaking, 0 as mlivepositiontaking, 0 as max_malivepositiontaking
		union all select 2 as bettype, 2 as sporttype, @v2apositiontaking_2 as apositiontaking, @v2mpositiontaking_2 as mpositiontaking, @max_v2mapositiontaking_2 as max_mapositiontaking, 0 as alivepositiontaking, 0 as mlivepositiontaking, 0 as max_malivepositiontaking
		union all select 3 as bettype, 2 as sporttype, @v2apositiontaking_3 as apositiontaking, @v2mpositiontaking_3 as mpositiontaking, @max_v2mapositiontaking_3 as max_mapositiontaking, 0 as alivepositiontaking, 0 as mlivepositiontaking, 0 as max_malivepositiontaking
		union all select 20 as bettype, 2 as sporttype, @v2apositiontaking_20 as apositiontaking, @v2mpositiontaking_20 as mpositiontaking, @max_v2mapositiontaking_20 as max_mapositiontaking, 0 as alivepositiontaking, 0 as mlivepositiontaking, 0 as max_malivepositiontaking

		--v3
		union all select 1 as bettype, 3 as sporttype, @v3apositiontaking_1 as apositiontaking, @v3mpositiontaking_1 as mpositiontaking, @max_v3mapositiontaking_1 as max_mapositiontaking, 0 as alivepositiontaking, 0 as mlivepositiontaking, 0 as max_malivepositiontaking
		union all select 2 as bettype, 3 as sporttype, @v3apositiontaking_2 as apositiontaking, @v3mpositiontaking_2 as mpositiontaking, @max_v3mapositiontaking_2 as max_mapositiontaking, 0 as alivepositiontaking, 0 as mlivepositiontaking, 0 as max_malivepositiontaking
		union all select 3 as bettype, 3 as sporttype, @v3apositiontaking_3 as apositiontaking, @v3mpositiontaking_3 as mpositiontaking, @max_v3mapositiontaking_3 as max_mapositiontaking, 0 as alivepositiontaking, 0 as mlivepositiontaking, 0 as max_malivepositiontaking
		union all select 20 as bettype, 3 as sporttype, @v3apositiontaking_20 as apositiontaking, @v3mpositiontaking_20 as mpositiontaking, @max_v3mapositiontaking_20 as max_mapositiontaking, 0 as alivepositiontaking, 0 as mlivepositiontaking, 0 as max_malivepositiontaking

		--v5
		union all select 1 as bettype, 5 as sporttype, @v5apositiontaking_1 as apositiontaking, @v5mpositiontaking_1 as mpositiontaking, @max_v5mapositiontaking_1 as max_mapositiontaking, 0 as alivepositiontaking, 0 as mlivepositiontaking, 0 as max_malivepositiontaking
		union all select 2 as bettype, 5 as sporttype, @v5apositiontaking_2 as apositiontaking, @v5mpositiontaking_2 as mpositiontaking, @max_v5mapositiontaking_2 as max_mapositiontaking, 0 as alivepositiontaking, 0 as mlivepositiontaking, 0 as max_malivepositiontaking
		union all select 3 as bettype, 5 as sporttype, @v5apositiontaking_3 as apositiontaking, @v5mpositiontaking_3 as mpositiontaking, @max_v5mapositiontaking_3 as max_mapositiontaking, 0 as alivepositiontaking, 0 as mlivepositiontaking, 0 as max_malivepositiontaking
		union all select 20 as bettype, 5 as sporttype, @v5apositiontaking_20 as apositiontaking, @v5mpositiontaking_20 as mpositiontaking, @max_v5mapositiontaking_20 as max_mapositiontaking, 0 as alivepositiontaking, 0 as mlivepositiontaking, 0 as max_malivepositiontaking

		--v8
		union all select 1 as bettype, 8 as sporttype, @v8apositiontaking_1 as apositiontaking, @v8mpositiontaking_1 as mpositiontaking, @max_v8mapositiontaking_1 as max_mapositiontaking, 0 as alivepositiontaking, 0 as mlivepositiontaking, 0 as max_malivepositiontaking
		union all select 3 as bettype, 8 as sporttype, @v8apositiontaking_3 as apositiontaking, @v8mpositiontaking_3 as mpositiontaking, @max_v8mapositiontaking_3 as max_mapositiontaking, 0 as alivepositiontaking, 0 as mlivepositiontaking, 0 as max_malivepositiontaking
		union all select 20 as bettype, 8 as sporttype, @v8apositiontaking_20 as apositiontaking, @v8mpositiontaking_20 as mpositiontaking, @max_v8mapositiontaking_20 as max_mapositiontaking, 0 as alivepositiontaking, 0 as mlivepositiontaking, 0 as max_malivepositiontaking

		--v10
		union all select 1 as bettype, 10 as sporttype, @v10apositiontaking_1 as apositiontaking, @v10mpositiontaking_1 as mpositiontaking, @max_v10mapositiontaking_1 as max_mapositiontaking, 0 as alivepositiontaking, 0 as mlivepositiontaking, 0 as max_malivepositiontaking
		union all select 2 as bettype, 10 as sporttype, @v10apositiontaking_2 as apositiontaking, @v10mpositiontaking_2 as mpositiontaking, @max_v10mapositiontaking_2 as max_mapositiontaking, 0 as alivepositiontaking, 0 as mlivepositiontaking, 0 as max_malivepositiontaking
		union all select 3 as bettype, 10 as sporttype, @v10apositiontaking_3 as apositiontaking, @v10mpositiontaking_3 as mpositiontaking, @max_v10mapositiontaking_3 as max_mapositiontaking, 0 as alivepositiontaking, 0 as mlivepositiontaking, 0 as max_malivepositiontaking
		union all select 20 as bettype, 10 as sporttype, @v10apositiontaking_20 as apositiontaking, @v10mpositiontaking_20 as mpositiontaking, @max_v10mapositiontaking_20 as max_mapositiontaking, 0 as alivepositiontaking, 0 as mlivepositiontaking, 0 as max_malivepositiontaking

		--v11
		union all select 1 as bettype, 11 as sporttype, @v11apositiontaking_1 as apositiontaking, @v11mpositiontaking_1 as mpositiontaking, @max_v11mapositiontaking_1 as max_mapositiontaking, 0 as alivepositiontaking, 0 as mlivepositiontaking, 0 as max_malivepositiontaking
		union all select 20 as bettype, 11 as sporttype, @v11apositiontaking_20 as apositiontaking, @v11mpositiontaking_20 as mpositiontaking, @max_v11mapositiontaking_20 as max_mapositiontaking, 0 as alivepositiontaking, 0 as mlivepositiontaking, 0 as max_malivepositiontaking
		
		--v99
		union all select 1 as bettype, 99 as sporttype, @v99apositiontaking_1 as apositiontaking, @v99mpositiontaking_1 as mpositiontaking, @max_v99mapositiontaking_1 as max_mapositiontaking, 0 as alivepositiontaking, 0 as mlivepositiontaking, 0 as max_malivepositiontaking
		union all select 2 as bettype, 99 as sporttype, @v99apositiontaking_2 as apositiontaking, @v99mpositiontaking_2 as mpositiontaking, @max_v99mapositiontaking_2 as max_mapositiontaking, 0 as alivepositiontaking, 0 as mlivepositiontaking, 0 as max_malivepositiontaking
		union all select 3 as bettype, 99 as sporttype, @v99apositiontaking_3 as apositiontaking, @v99mpositiontaking_3 as mpositiontaking, @max_v99mapositiontaking_3 as max_mapositiontaking, 0 as alivepositiontaking, 0 as mlivepositiontaking, 0 as max_malivepositiontaking
		union all select 20 as bettype, 99 as sporttype, @v99apositiontaking_20 as apositiontaking, @v99mpositiontaking_20 as mpositiontaking, @max_v99mapositiontaking_20 as max_mapositiontaking, 0 as alivepositiontaking, 0 as mlivepositiontaking, 0 as max_malivepositiontaking

		-- mixed sports
		union all select 9 as bettype, 99 as sporttype, @v99apositiontaking_9 as apositiontaking, @v99mpositiontaking_9 as mpositiontaking, @max_v99mapositiontaking_9 as max_mapositiontaking, 0 as alivepositiontaking, 0 as mlivepositiontaking, 0 as max_malivepositiontaking
			
		--number game
		union all select 81 as bettype, 161 as sporttype, @v161apositiontaking_81 as apositiontaking, @v161mpositiontaking_81 as mpositiontaking, @max_v161mapositiontaking_81 as max_mapositiontaking, 0 as alivepositiontaking, 0 as mlivepositiontaking, 0 as max_malivepositiontaking		
		union all select 83 as bettype, 161 as sporttype, @v161apositiontaking_83 as apositiontaking, @v161mpositiontaking_83 as mpositiontaking, @max_v161mapositiontaking_83 as max_mapositiontaking, 0 as alivepositiontaking, 0 as mlivepositiontaking, 0 as max_malivepositiontaking		
		union all select 85 as bettype, 161 as sporttype, 0 as apositiontaking, 0 as mpositiontaking, 0 as max_mapositiontaking, @v161alivepositiontaking_85 as alivepositiontaking, @v161mlivepositiontaking_85 as mlivepositiontaking, @max_v161malivepositiontaking_85 as max_malivepositiontaking
		union all select 86 as bettype, 161 as sporttype, @v161apositiontaking_86 as apositiontaking, @v161mpositiontaking_86 as mpositiontaking, @max_v161mapositiontaking_86 as max_mapositiontaking, @v161alivepositiontaking_86 as alivepositiontaking, @v161mlivepositiontaking_86 as mlivepositiontaking, @max_v161malivepositiontaking_86 as max_malivepositiontaking
		union all select 87 as bettype, 161 as sporttype, 0 as apositiontaking, 0 as mpositiontaking, 0 as max_mapositiontaking, @v161alivepositiontaking_87 as alivepositiontaking, @v161mlivepositiontaking_87 as mlivepositiontaking, @max_v161malivepositiontaking_87 as max_malivepositiontaking
		union all select 88 as bettype, 161 as sporttype, @v161apositiontaking_88 as apositiontaking, @v161mpositiontaking_88 as mpositiontaking, @max_v161mapositiontaking_88 as max_mapositiontaking, 0 as alivepositiontaking, 0 as mlivepositiontaking, 0 as max_malivepositiontaking		
		union all select 89 as bettype, 161 as sporttype, 0 as apositiontaking, 0 as mpositiontaking, 0 as max_mapositiontaking, @v161alivepositiontaking_89 as alivepositiontaking, @v161mlivepositiontaking_89 as mlivepositiontaking, @max_v161malivepositiontaking_89 as max_malivepositiontaking
		union all select 90 as bettype, 161 as sporttype, 0 as apositiontaking, 0 as mpositiontaking, 0 as max_mapositiontaking, @v161alivepositiontaking_90 as alivepositiontaking, @v161mlivepositiontaking_90 as mlivepositiontaking, @max_v161malivepositiontaking_90 as max_malivepositiontaking
			
	) as b
	inner join #tmp_Sports sports on b.sporttype = sports.ID
	inner join #tmp_Bettype bettype on b.bettype = bettype.ID
	where (b.apositiontaking+b.mpositiontaking>b.max_mapositiontaking) or 
			(b.sporttype in (1,161) and b.bettype in (1,3,7,8,85,86,87,89) and (b.alivepositiontaking+b.mlivepositiontaking>b.max_malivepositiontaking))

	if @ErrType <>''
	BEGIN
		select @ErrCode = 101
		Select @ErrMsg = 	@UserName + ': '+
							case @Language 
							when 'E' then 'Wrong position taking.<br>'+@ErrType
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20001,@Language) + '<br>' + @ErrType
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
		
		MaxPerMatch99 = @MaxPerMatchv99,
		
		MaxPerMatch1MP = @MaxPerMatchv1MP,
		MaxPerMatch99MP = @MaxPerMatchv99MP,
		MaxPerMatch161 = @MaxPerMatchv161,
		MaxPerBall161 = @MaxPerBallv161

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
		MinBet = case sporttype when 1 then CASE WHEN betType = 9 THEN @MinBetv1MP ELSE @MinBetv1 END when 2 then @MinBetv2 when 3 then @MinBetv3 when 5 then @MinBetv5 when 8 then @MinBetv8 when 10 then @MinBetv10 when 11 then @MinBetv11  when 99 then (case bettype when 9 then @MinBetv99MP else @MinBetv99 end)   else MinBet end,
		MaxBet = case sporttype when 1 then CASE WHEN betType = 9 THEN @MaxBetv1MP ELSE @MaxBetv1 END when 2 then @MaxBetv2 when 3 then @MaxBetv3 when 5 then @MaxBetv5 when 8 then @MaxBetv8 when 10 then @MaxBetv10 when 11 then @MaxBetv11  when 99 then (case bettype when 9 then @MaxBetv99MP else @MaxBetv99 end)   else MaxBet end,
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
						
							WHEN sporttype = 99 and bettype = 1 THEN @v99apositiontaking_1 
							WHEN sporttype = 99 and bettype = 2 THEN @v99apositiontaking_2 
							WHEN sporttype = 99 and bettype = 3 THEN @v99apositiontaking_3 
							WHEN sporttype = 99 and bettype = 9 THEN @v99apositiontaking_9 
							WHEN sporttype = 99 and bettype = 20 THEN @v99apositiontaking_20
							
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
						
							WHEN sporttype = 99 and bettype = 1 THEN @v99mpositiontaking_1 
							WHEN sporttype = 99 and bettype = 2 THEN @v99mpositiontaking_2 
							WHEN sporttype = 99 and bettype = 3 THEN @v99mpositiontaking_3 
							WHEN sporttype = 99 and bettype = 9 THEN @v99mpositiontaking_9 
							WHEN sporttype = 99 and bettype = 20 THEN @v99mpositiontaking_20
							
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
				 ELSE 
					MinBet
				 END,
		MaxBet = CASE 
					WHEN sporttype = 161 THEN @MaxBetv161 					
				 ELSE
					MaxBet
				 END,
		apositiontaking = CASE 
							
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

	--------------------------------HR Commision------------------------------------------------

	--At member level, leave the playerdiscount the value as it is
	/*
	UPDATE cs 
		SET cs.playerdiscount =  cs.discount
	FROM Dep_CustSetting3rd AS cs WITH (ROWLOCK, UPDLOCK)
	INNER JOIN custinfo AS c WITH (NOLOCK) ON cs.custid = c.custid
	WHERE c.recommend = @custid AND c.roleid = 1 AND cs.playerdiscount > cs.discount AND sporttype in (151,152,153)
	*/

	--Keno
	--Check PT
	DECLARE @vMaxPT_1501 money
	SELECT @vMaxPT_1501=isnull(mpositiontaking,0) 
	FROM dbo.CustSettingGame WITH(NOLOCK) 
	WHERE CustID= @mrecommend and Bettype=1501


	SELECT IBCBetTypeID AS Bettype,
		   ISNULL(cg.MinBet,0) AS MinBet_Up,
		   ISNULL(cg.MaxBet,0) AS Maxbet_Up ,
		   ISNULL(cg.MaxPerGameType,0) AS MaxPerMatch_UP
	INTO #Data_Upline
	FROM dbo.CustGameType cg WITH (NOLOCK)  INNER JOIN 
	#tmp_GameType gt on cg.GameTypeID=gt.ID
	and cg.CustID=@mrecommend 

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
				WHERE ((d.MinBet > d.MaxBet) OR (d.MinBet < d2.MinBet_Up)) and d.MinBet > 0)
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
				WHERE ((d.MaxBet > d2.MaxPerMatch_UP)) and d.MaxBet > 0 )
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
			   @str_spt=@str_spt + 'v202spt_' +CAST(Bettype AS VARCHAR(50))+'="'+CAST(sPositionTaking AS VARCHAR(50))+'" ',
			   @str_mpt=@str_mpt + 'v202mpt_' +CAST(Bettype AS VARCHAR(50))+'="'+CAST(mPositionTaking AS VARCHAR(50))+'" ',
			   @str_apt=@str_apt + 'v202apt_' +CAST(Bettype AS VARCHAR(50))+'="'+CAST(aPositionTaking AS VARCHAR(50))+'" '
		from #data where Bettype=@i
		set @i=@i+1
	END

	Select @LogSPData ='<Acc_Dep_CustomerUpdMember_MAg><info custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +
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
	---
	

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
	
	'/>' +	'<Keno '+	@str_bet+	'/>' +	'</Acc_Dep_CustomerUpdMember_MAg>'

	BEGIN
		DECLARE @sql varchar (MAX)
		DECLARE @TEXT varchar (4000) =''
		SELECT @sql='<Acc_Dep_CustomerUpdMember_MAg> ' +
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
		select @sql = @sql + '</Acc_Dep_CustomerUpdMember_MAg>'
		SET @LogSPData2=@sql
	END

	EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP 
		@UserID = @UserID,
		@CustID = @CustID,
		@ActionID = 2036,
		@TrackingValue = @LogSPData,
		@TrackingValue2 = @LogSPData2,
		@duration = @duration

	--Write PT log
	SELECT @LogSPData = '<Acc_Dep_CustomerUpdMember_MAg><info custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +
	'UserID="'+ coalesce(cast(@UserID as varchar(50)),space(1)) + '" ' +
	'Language="'+ coalesce(cast(@Language as varchar(2)),space(1)) + '" ' +
	'IP="'+ coalesce(cast(@IP as varchar(15)),space(1)) + '" ' +
	'ErrCode="'+ coalesce(cast(@ErrCode as varchar(50)),space(1)) + '" ' +
	'ErrMsg="'+ coalesce(cast(@ErrMsg as varchar(5000)),space(1)) + '" />' +

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
	'v161mlivept_90="'+ COALESCE(dbo.f_FomatNumericToChar(@v161mlivepositiontaking_90),SPACE(1)) + '" ' +
	@str_mpt+ ' />' +

	'<ag apt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@v1apositiontaking_1 ),SPACE(1)) + '" ' +
	'apt_2="'+ COALESCE(dbo.f_FomatNumericToChar(@v1apositiontaking_2 ),SPACE(1)) + '" ' +
	'apt_3="'+ COALESCE(dbo.f_FomatNumericToChar(@v1apositiontaking_3 ),SPACE(1)) + '" ' +
	'apt_4="'+ COALESCE(dbo.f_FomatNumericToChar(@v1apositiontaking_4 ),SPACE(1)) + '" ' +
	'apt_5="'+ COALESCE(dbo.f_FomatNumericToChar(@v1apositiontaking_5 ),SPACE(1)) + '" ' +
	'apt_6="'+ COALESCE(dbo.f_FomatNumericToChar(@v1apositiontaking_6 ),SPACE(1)) + '" ' +
	'apt_7="'+ COALESCE(dbo.f_FomatNumericToChar(@v1apositiontaking_7 ),SPACE(1)) + '" ' +
	'apt_8="'+ COALESCE(dbo.f_FomatNumericToChar(@v1apositiontaking_8 ),SPACE(1)) + '" ' +
	'apt_9="'+ COALESCE(dbo.f_FomatNumericToChar(@v1apositiontaking_9 ),SPACE(1)) + '" ' +
	'apt_10="'+ COALESCE(dbo.f_FomatNumericToChar(@v1apositiontaking_10 ),SPACE(1)) + '" ' + 
	'alivept_1="'+ COALESCE(dbo.f_FomatNumericToChar(@v1alivepositiontaking_1 ),SPACE(1)) + '" ' +
	'alivept_3="'+ COALESCE(dbo.f_FomatNumericToChar(@v1alivepositiontaking_3 ),SPACE(1)) + '" ' +
	'alivept_7="'+ COALESCE(dbo.f_FomatNumericToChar(@v1alivepositiontaking_7 ),SPACE(1)) + '" ' +
	'alivept_8="'+ COALESCE(dbo.f_FomatNumericToChar(@v1alivepositiontaking_8 ),SPACE(1)) + '" ' +

	'v2apt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@v2apositiontaking_1 ),SPACE(1)) + '" ' +
	'v2apt_2="'+ COALESCE(dbo.f_FomatNumericToChar(@v2apositiontaking_2 ),SPACE(1)) + '" ' +
	'v2apt_3="'+ COALESCE(dbo.f_FomatNumericToChar(@v2apositiontaking_3 ),SPACE(1)) + '" ' +
	'v2apt_7="'+ COALESCE(dbo.f_FomatNumericToChar(@v2apositiontaking_7 ),SPACE(1)) + '" ' +
	'v2apt_8="'+ COALESCE(dbo.f_FomatNumericToChar(@v2apositiontaking_8 ),SPACE(1)) + '" ' +
	'v2apt_20="'+ COALESCE(dbo.f_FomatNumericToChar(@v2apositiontaking_20 ),SPACE(1)) + '" ' +

	'v3apt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@v3apositiontaking_1 ),SPACE(1)) + '" ' +
	'v3apt_2="'+ COALESCE(dbo.f_FomatNumericToChar(@v3apositiontaking_2 ),SPACE(1)) + '" ' +
	'v3apt_3="'+ COALESCE(dbo.f_FomatNumericToChar(@v3apositiontaking_3 ),SPACE(1)) + '" ' +
	'v3apt_20="'+ COALESCE(dbo.f_FomatNumericToChar(@v3apositiontaking_20 ),SPACE(1)) + '" ' +

	'v5apt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@v5apositiontaking_1 ),SPACE(1)) + '" ' +
	'v5apt_2="'+ COALESCE(dbo.f_FomatNumericToChar(@v5apositiontaking_2 ),SPACE(1)) + '" ' +
	'v5apt_3="'+ COALESCE(dbo.f_FomatNumericToChar(@v5apositiontaking_3 ),SPACE(1)) + '" ' +
	'v5apt_20="'+ COALESCE(dbo.f_FomatNumericToChar(@v5apositiontaking_20 ),SPACE(1)) + '" ' +

	'v8apt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@v8apositiontaking_1 ),SPACE(1)) + '" ' +
	'v8apt_3="'+ COALESCE(dbo.f_FomatNumericToChar(@v8apositiontaking_3 ),SPACE(1)) + '" ' +
	'v8apt_20="'+ COALESCE(dbo.f_FomatNumericToChar(@v8apositiontaking_20 ),SPACE(1)) + '" ' +

	'v10apt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@v10apositiontaking_1 ),SPACE(1)) + '" ' +
	'v10apt_2="'+ COALESCE(dbo.f_FomatNumericToChar(@v10apositiontaking_2 ),SPACE(1)) + '" ' +
	'v10apt_3="'+ COALESCE(dbo.f_FomatNumericToChar(@v10apositiontaking_3 ),SPACE(1)) + '" ' +
	'v10apt_20="'+ COALESCE(dbo.f_FomatNumericToChar(@v10apositiontaking_20 ),SPACE(1)) + '" ' +

	'v11apt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@v11apositiontaking_1 ),SPACE(1)) + '" ' +
	'v11apt_20="'+ COALESCE(dbo.f_FomatNumericToChar(@v11apositiontaking_20 ),SPACE(1)) + '" ' +


	'v99apt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@v99apositiontaking_1 ),SPACE(1)) + '" ' +
	'v99apt_2="'+ COALESCE(dbo.f_FomatNumericToChar(@v99apositiontaking_2 ),SPACE(1)) + '" ' +
	'v99apt_3="'+ COALESCE(dbo.f_FomatNumericToChar(@v99apositiontaking_3 ),SPACE(1)) + '" ' +
	'v99apt_9="'+ COALESCE(dbo.f_FomatNumericToChar(@v99apositiontaking_9 ),SPACE(1)) + '" ' +
	'v99apt_20="'+ COALESCE(dbo.f_FomatNumericToChar(@v99apositiontaking_20 ),SPACE(1)) + '" ' +
	
	'v161apt_81="'+ COALESCE(dbo.f_FomatNumericToChar(@v161apositiontaking_81),SPACE(1)) + '" ' +
	'v161apt_83="'+ COALESCE(dbo.f_FomatNumericToChar(@v161apositiontaking_83),SPACE(1)) + '" ' +
	'v161apt_86="'+ COALESCE(dbo.f_FomatNumericToChar(@v161apositiontaking_86),SPACE(1)) + '" ' +
	'v161apt_88="'+ COALESCE(dbo.f_FomatNumericToChar(@v161apositiontaking_88),SPACE(1)) + '" ' +
	'v161alivept_85="'+ COALESCE(dbo.f_FomatNumericToChar(@v161alivepositiontaking_85),SPACE(1)) + '" ' +
	'v161alivept_86="'+ COALESCE(dbo.f_FomatNumericToChar(@v161alivepositiontaking_86),SPACE(1)) + '" ' +
	'v161alivept_87="'+ COALESCE(dbo.f_FomatNumericToChar(@v161alivepositiontaking_87),SPACE(1)) + '" ' +
	'v161alivept_89="'+ COALESCE(dbo.f_FomatNumericToChar(@v161alivepositiontaking_89),SPACE(1)) + '" ' +
	'v161alivept_90="'+ COALESCE(dbo.f_FomatNumericToChar(@v161alivepositiontaking_90),SPACE(1)) + '" ' +
	@str_apt+ ' />' +
	'</Acc_Dep_CustomerUpdMember_MAg>' 

	--tracking value old
	DECLARE @pt_SB smallMoney,@pt_NG smallmoney,@pt_KN smallmoney
			,@mpt_SB smallMoney=0,@mpt_NG smallmoney=0,@mpt_KN smallmoney=0
	select top 1 @pt_SB=apt FROM #data_old where Sporttype=1 AND Bettype =1 and islive =0
	select top 1 @pt_NG=apt FROM #data_old where Sporttype=161 AND Bettype =81 and islive =0
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
	SELECT @LogSPData2 = '<Acc_Dep_CustomerUpdMember_MAg><info custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +
	'UserID="'+ coalesce(cast(@UserID as varchar(50)),space(1)) + '" ' +
	'Language="'+ coalesce(cast(@Language as varchar(2)),space(1)) + '" ' +
	'IP="'+ coalesce(cast(@IP as varchar(15)),space(1)) + '" ' +
	'ErrCode="'+ coalesce(cast(@ErrCode as varchar(50)),space(1)) + '" ' +
	'ErrMsg="'+ coalesce(cast(@ErrMsg as varchar(5000)),space(1)) + '" />' +

	'<m mpt_1="'+ COALESCE(CAST(CONVERT(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +
	'mpt_2="'+ COALESCE(CAST(CONVERT(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +
	'mpt_3="'+ COALESCE(CAST(CONVERT(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +
	'mpt_4="'+ COALESCE(CAST(CONVERT(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +
	'mpt_5="'+ COALESCE(CAST(CONVERT(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +
	'mpt_6="'+ COALESCE(CAST(CONVERT(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +
	'mpt_7="'+ COALESCE(CAST(CONVERT(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +
	'mpt_8="'+ COALESCE(CAST(CONVERT(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +
	'mpt_9="'+ COALESCE(CAST(CONVERT(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +
	'mpt_10="'+ COALESCE(CAST(CONVERT(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +
	'mlivept_1="'+ COALESCE(CAST(CONVERT(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +
	'mlivept_3="'+ COALESCE(CAST(CONVERT(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +
	'mlivept_7="'+ COALESCE(CAST(CONVERT(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +
	'mlivept_8="'+ COALESCE(CAST(CONVERT(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +

	'v2mpt_1="'+ COALESCE(CAST(CONVERT(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v2mpt_2="'+ COALESCE(CAST(CONVERT(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v2mpt_3="'+ COALESCE(CAST(CONVERT(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v2mpt_7="'+ COALESCE(CAST(CONVERT(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v2mpt_8="'+ COALESCE(CAST(CONVERT(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v2mpt_20="'+ COALESCE(CAST(CONVERT(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +

	'v3mpt_1="'+ COALESCE(CAST(CONVERT(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v3mpt_2="'+ COALESCE(CAST(CONVERT(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v3mpt_3="'+ COALESCE(CAST(CONVERT(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v3mpt_20="'+ COALESCE(CAST(CONVERT(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +

	'v5mpt_1="'+ COALESCE(CAST(CONVERT(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v5mpt_2="'+ COALESCE(CAST(CONVERT(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v5mpt_3="'+ COALESCE(CAST(CONVERT(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v5mpt_20="'+ COALESCE(CAST(CONVERT(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +

	'v8mpt_1="'+ COALESCE(CAST(CONVERT(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v8mpt_3="'+ COALESCE(CAST(CONVERT(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v8mpt_20="'+ COALESCE(CAST(CONVERT(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +

	'v10mpt_1="'+ COALESCE(CAST(CONVERT(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v10mpt_2="'+ COALESCE(CAST(CONVERT(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v10mpt_3="'+ COALESCE(CAST(CONVERT(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v10mpt_20="'+ COALESCE(CAST(CONVERT(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +

	'v11mpt_1="'+ COALESCE(CAST(CONVERT(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v11mpt_20="'+ COALESCE(CAST(CONVERT(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +

	

	'v99mpt_1="'+ COALESCE(CAST(CONVERT(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v99mpt_2="'+ COALESCE(CAST(CONVERT(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v99mpt_3="'+ COALESCE(CAST(CONVERT(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v99mpt_9="'+ COALESCE(CAST(CONVERT(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +
	'v99mpt_20="'+ COALESCE(CAST(CONVERT(smallmoney,0) AS VARCHAR(50)),SPACE(1)) + '" ' +
	
	'v161mpt_81="'+ COALESCE(dbo.f_FomatNumericToChar(@v161mpositiontaking_81),SPACE(1)) + '" ' +
	'v161mpt_83="'+ COALESCE(dbo.f_FomatNumericToChar(@v161mpositiontaking_83),SPACE(1)) + '" ' +
	'v161mpt_86="'+ COALESCE(dbo.f_FomatNumericToChar(@v161mpositiontaking_86),SPACE(1)) + '" ' +
	'v161mpt_88="'+ COALESCE(dbo.f_FomatNumericToChar(@v161mpositiontaking_88),SPACE(1)) + '" ' +
	'v161mlivept_85="'+ COALESCE(dbo.f_FomatNumericToChar(@v161mlivepositiontaking_85),SPACE(1)) + '" ' +
	'v161mlivept_86="'+ COALESCE(dbo.f_FomatNumericToChar(@v161mlivepositiontaking_86),SPACE(1)) + '" ' +
	'v161mlivept_87="'+ COALESCE(dbo.f_FomatNumericToChar(@v161mlivepositiontaking_87),SPACE(1)) + '" ' +
	'v161mlivept_89="'+ COALESCE(dbo.f_FomatNumericToChar(@v161mlivepositiontaking_89),SPACE(1)) + '" ' +
	'v161mlivept_90="'+ COALESCE(dbo.f_FomatNumericToChar(@v161mlivepositiontaking_90),SPACE(1)) + '" ' +
	@str_mpt_+	' />' +

	'<ag apt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'apt_2="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'apt_3="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'apt_4="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'apt_5="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'apt_6="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'apt_7="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'apt_8="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'apt_9="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'apt_10="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' + 
	'alivept_1="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'alivept_3="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'alivept_7="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'alivept_8="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +

	'v2apt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'v2apt_2="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'v2apt_3="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'v2apt_7="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'v2apt_8="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'v2apt_20="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +

	'v3apt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'v3apt_2="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'v3apt_3="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'v3apt_20="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +

	'v5apt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'v5apt_2="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'v5apt_3="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'v5apt_20="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +

	'v8apt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'v8apt_3="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'v8apt_20="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +

	'v10apt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'v10apt_2="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'v10apt_3="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'v10apt_20="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +

	'v11apt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'v11apt_20="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +


	'v99apt_1="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'v99apt_2="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'v99apt_3="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'v99apt_9="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	'v99apt_20="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_SB ),SPACE(1)) + '" ' +
	
	'v161apt_81="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_NG),SPACE(1)) + '" ' +
	'v161apt_83="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_NG),SPACE(1)) + '" ' +
	'v161apt_86="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_NG),SPACE(1)) + '" ' +
	'v161apt_88="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_NG),SPACE(1)) + '" ' +
	'v161alivept_85="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_NG),SPACE(1)) + '" ' +
	'v161alivept_86="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_NG),SPACE(1)) + '" ' +
	'v161alivept_87="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_NG),SPACE(1)) + '" ' +
	'v161alivept_89="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_NG),SPACE(1)) + '" ' +
	'v161alivept_90="'+ COALESCE(dbo.f_FomatNumericToChar(@pt_NG),SPACE(1)) + '" ' +
	@str_apt_+ ' />' +
	'</Acc_Dep_CustomerUpdMember_MAg>'

	EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP 
		@UserID = @UserID,
		@CustID = @CustID,
		@ActionID = 2707,
		@TrackingValue = @LogSPData,
		@TrackingValue2 = @LogSPData2,
		@duration = @duration

	DROP TABLE #data
	DROP TABLE #data_Upline
	DROP TABLE #data_old
END
GO
