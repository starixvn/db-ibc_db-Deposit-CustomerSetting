/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_CustomerSelMember_SAg]
	@CustID INT
AS

/*
Created: 20120321@Dom
TASk : Super edit master
DB: DBCust.CustDB

Revisions:
	- 20131014@Francis: Support selecting new virtual sports with settings via XML param
	- 20140418@Francis: Fix not returning data of bet setting (when customer does not have 3rd party game) bug
    - 20140505@Florent: Add new Sport HRFO
	- 20140512@Florent: Add Keno Sport
	- 20150603@Kathy: Move SP to DBCust.custDB [Redmine:#36216]
	- 20151028@Jim:Implement Muay's Setting for Deposit Customer [Redmine: #45491]
	- 20170302@Helen: Betradar Virtual Sports  -Integration for Cash [Redmine: 77274]
	- 20180125@Winnie: Hide inactive products [RedmineID: #86086]  
	- 20190326@Winnie: Update PT of Sportsbook for All Licensee. [RedmineID: #110111]
	- 20190726@Winnie: Remove Muay Thai. [RedmineID: #117501]  
Param's Explanation:
• @CustID: member ID
• @VirtualSportList: VirtualSport Settings XML param
*/
BEGIN
	SET NOCOUNT ON

	DECLARE @MinBetv1						MONEY, 
			@MinBetv1_Min					MONEY,
			@MinBetv2						MONEY, 
			@MinBetv2_Min					MONEY,
			@MinBetv3						MONEY,  
			@MinBetv3_Min					MONEY,  
			@MinBetv5						MONEY,  
			@MinBetv5_Min					MONEY,  
			@MinBetv8						MONEY,  
			@MinBetv8_Min					MONEY,  
			@MinBetv10						MONEY,  
			@MinBetv10_Min					MONEY,  
			@MinBetv11						MONEY,  
			@MinBetv11_Min					MONEY,
			
			@MinBetv99						MONEY,  
			@MinBetv99_Min					MONEY,  
			
			@MaxBetv1						MONEY,
			@MaxBetv1_Max					MONEY,  
			@MaxBetv2						MONEY,
			@MaxBetv2_Max					MONEY,  
			@MaxBetv3						MONEY,
			@MaxBetv3_Max					MONEY,
			@MaxBetv5						MONEY,
			@MaxBetv5_Max					MONEY,
			@MaxBetv8						MONEY,
			@MaxBetv8_Max					MONEY,
			@MaxBetv10						MONEY,
			@MaxBetv10_Max					MONEY,
			@MaxBetv11						MONEY,
			@MaxBetv11_Max					MONEY,
		
			@MaxBetv99						MONEY,
			@MaxBetv99_Max					MONEY,
	

			@MinBetv99MP					MONEY,
			@MinBetv99MP_Min				MONEY,
			@MaxBetv99MP					MONEY,
			@MaxBetv99MP_Max				MONEY,
			@MaxPerMatchv99MP				MONEY,
			@MaxPerMatchv99MP_Max			MONEY,
			@MinBetv161						MONEY,
			@MinBetv161_Min					MONEY,
			@MaxBetv161						MONEY,
			@MaxBetv161_Max					MONEY,
			
			@MaxPerMatchv1					MONEY,
			@MaxPerMatchv1_Max				MONEY,
			@MaxPerMatchv2					MONEY,
			@MaxPerMatchv2_Max				MONEY,
			@MaxPerMatchv3					MONEY,
			@MaxPerMatchv3_Max				MONEY,
			@MaxPerMatchv5					MONEY,
			@MaxPerMatchv5_Max				MONEY,
			@MaxPerMatchv8					MONEY,
			@MaxPerMatchv8_Max				MONEY,
			@MaxPerMatchv10					MONEY,
			@MaxPerMatchv10_Max				MONEY,
			@MaxPerMatchv11					MONEY,
			@MaxPerMatchv11_Max				MONEY,
			
			@MaxPerMatchv99					MONEY,
			@MaxPerMatchv99_Max				MONEY,

			@MaxPerMatchv161				MONEY,	
			@MaxPerMatchv161_Max			MONEY,	
			@MaxPerBallv161					MONEY,
			@MaxPerBallv161_Max				MONEY,

			@v1mPositionTaking_1				MONEY,
			@v1mPositionTaking_1_Max			MONEY,
			@v161mPositionTaking_81				MONEY,
			@v161mPositionTaking_81_Max			MONEY,
			--Keno
			@KenoList VARCHAR(4000)='', -- repalace all old params
			@vPT SMALLMONEY,
			@vPT_Max SMALLMONEY,		

			@srecommend				INT

	SELECT @srecommend = srecommend FROM custinfo AS ci WITH (NOLOCK) where custid = @CustID

	SELECT  @MinBetv1 = max(CASE WHEN cs.bettype = 1 AND cs.sporttype = 1 THEN cs.minbet ELSE 0 END) , 
			@MaxBetv1 = max(CASE WHEN cs.bettype = 1 AND cs.sporttype = 1 THEN cs.maxbet ELSE 0 END),
			@v1mPositionTaking_1 = max(CASE WHEN cs.bettype = 1 AND cs.sporttype = 1 THEN cs.mpositiontaking ELSE 0 END),

			@MinBetv2 = max(CASE WHEN cs.bettype = 1 AND cs.sporttype = 2 THEN cs.minbet ELSE 0 END),
			@MaxBetv2 = max(CASE WHEN cs.bettype = 1 AND cs.sporttype = 2 THEN cs.maxbet ELSE 0 END),

			@MinBetv3 = max(CASE WHEN cs.bettype = 1 AND cs.sporttype = 3 THEN cs.minbet ELSE 0 END),
			@MaxBetv3 = max(CASE WHEN cs.bettype = 1 AND cs.sporttype = 3 THEN cs.maxbet ELSE 0 END),

			@MinBetv5 = max(CASE WHEN cs.bettype = 1 AND cs.sporttype = 5 THEN cs.minbet ELSE 0 END),
			@MaxBetv5 = max(CASE WHEN cs.bettype = 1 AND cs.sporttype = 5 THEN cs.maxbet ELSE 0 END),
			
			@MinBetv8 = max(CASE WHEN cs.bettype = 1 AND cs.sporttype = 8 THEN cs.minbet ELSE 0 END),
			@MaxBetv8 = max(CASE WHEN cs.bettype = 1 AND cs.sporttype = 8 THEN cs.maxbet ELSE 0 END),

			@MinBetv10 = max(CASE WHEN cs.bettype = 1 AND cs.sporttype = 10 THEN cs.minbet ELSE 0 END),
			@MaxBetv10 = max(CASE WHEN cs.bettype = 1 AND cs.sporttype = 10 THEN cs.maxbet ELSE 0 END),

			@MinBetv11 = max(CASE WHEN cs.bettype = 1 AND cs.sporttype = 11 THEN cs.minbet ELSE 0 END),
			@MaxBetv11 = max(CASE WHEN cs.bettype = 1 AND cs.sporttype = 11 THEN cs.maxbet ELSE 0 END),
	
			
			@MinBetv99 = max(CASE WHEN cs.bettype = 1 AND cs.sporttype = 99 THEN cs.minbet ELSE 0 END),
			@MaxBetv99 = max(CASE WHEN cs.bettype = 1 AND cs.sporttype = 99 THEN cs.maxbet ELSE 0 END),

			@MinBetv99MP = max(CASE WHEN cs.bettype = 9 AND cs.sporttype = 99 THEN cs.minbet ELSE 0 END),
			@MaxBetv99MP = max(CASE WHEN cs.bettype = 9 AND cs.sporttype = 99 THEN cs.maxbet ELSE 0 END),

			@MinBetv161 = max(CASE WHEN cs3rd.bettype = 81 AND cs3rd.sporttype = 161 THEN cs3rd.minbet ELSE 0 END),
			@MaxBetv161 = max(CASE WHEN cs3rd.bettype = 81 AND cs3rd.sporttype = 161 THEN cs3rd.maxbet ELSE 0 END),
			@v161mPositionTaking_81 = max(CASE WHEN cs3rd.bettype = 81 AND cs3rd.sporttype = 161 THEN cs3rd.mpositiontaking ELSE 0 END)
		

	FROM Dep_CustSetting AS cs WITH (NOLOCK) 
		LEFT JOIN Dep_CustSetting3rd AS cs3rd WITH (NOLOCK) ON cs.custid = cs3rd.custid
	WHERE cs.custid = @CustID

			
	SELECT  @v1mPositionTaking_1_Max = max(CASE WHEN cs.bettype = 1 AND cs.sporttype = 1 THEN cs.spositiontaking ELSE 0 END),
			@v161mPositionTaking_81_Max = max(CASE WHEN cs3rd.bettype = 81 AND cs3rd.sporttype = 161 THEN cs3rd.spositiontaking ELSE 0 END)

	FROM Dep_CustSetting AS cs WITH (NOLOCK)
		LEFT JOIN Dep_CustSetting3rd AS cs3rd WITH (NOLOCK) ON cs.custid = cs3rd.custid
	 WHERE cs.custid = @srecommend
	 
	 
	 
	--min max
	Select 
		@MinBetv1_Min = Max(case when MinBet = 0 then NULL else MinBet end), 
		@MaxBetv1_Max = Min(case when MaxBet = 0 then NULL else MaxBet end)
	from 
		dep_custsetting as cs WITH (NOLOCK)
		INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.SRecommend) and cs.bettype = 1 and cs.sporttype=1
	where ci.custid = @CustID

	Select 
		@MinBetv2_Min = Max(case when MinBet = 0 then NULL else MinBet end), 
		@MaxBetv2_Max = Min(case when MaxBet = 0 then NULL else MaxBet end)
	from 
		dep_custsetting as cs WITH (NOLOCK)
		INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.SRecommend) and cs.bettype = 1 and cs.sporttype=2
	where ci.custid = @CustID

	Select 
		@MinBetv3_Min = Max(case when MinBet = 0 then NULL else MinBet end), 
		@MaxBetv3_Max = Min(case when MaxBet = 0 then NULL else MaxBet end)
	from 
		dep_custsetting as cs WITH (NOLOCK)
		INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.SRecommend) and cs.bettype = 1 and cs.sporttype=3
	where ci.custid = @CustID

	Select 
		@MinBetv5_Min = Max(case when MinBet = 0 then NULL else MinBet end), 
		@MaxBetv5_Max = Min(case when MaxBet = 0 then NULL else MaxBet end)
	from 
		dep_custsetting as cs WITH (NOLOCK)
		INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.SRecommend) and cs.bettype = 1 and cs.sporttype=5
	where ci.custid = @CustID

	Select 
		@MinBetv8_Min = Max(case when MinBet = 0 then NULL else MinBet end), 
		@MaxBetv8_Max = Min(case when MaxBet = 0 then NULL else MaxBet end)
	from 
		dep_custsetting as cs WITH (NOLOCK)
		INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.SRecommend) and cs.bettype = 1 and cs.sporttype=8
	where ci.custid = @CustID

	Select 
		@MinBetv10_Min = Max(case when MinBet = 0 then NULL else MinBet end), 
		@MaxBetv10_Max = Min(case when MaxBet = 0 then NULL else MaxBet end)
	from 
		dep_custsetting as cs WITH (NOLOCK)
		INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.SRecommend) and cs.bettype = 1 and cs.sporttype=10
	where ci.custid = @CustID

	Select 
		@MinBetv11_Min = Max(case when MinBet = 0 then NULL else MinBet end), 
		@MaxBetv11_Max = Min(case when MaxBet = 0 then NULL else MaxBet end)
	from 
		dep_custsetting as cs WITH (NOLOCK)
		INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.SRecommend) and cs.bettype = 1 and cs.sporttype=11
	where ci.custid = @CustID
	----
	
	----
	Select 
		@MinBetv99_Min = Max(case when MinBet = 0 then NULL else MinBet end), 
		@MaxBetv99_Max = Min(case when MaxBet = 0 then NULL else MaxBet end)
	from 
		dep_custsetting as cs WITH (NOLOCK)
		INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.SRecommend) and cs.bettype = 1 and cs.sporttype=99
	where ci.custid = @CustID


	-- mix parlay mixed sports
	select	@MinBetv99MP_Min = Max(case when MinBet = 0 then NULL else MinBet end),
			@MaxBetv99MP_Max = Min(case when MaxBet = 0 then NULL else MaxBet end)
	from dep_custsetting cs WITH(NOLOCK)
		 INNER JOIN custinfo as ci WITH(NOLOCK) ON (cs.CustID = ci.SRecommend) and cs.bettype = 9 and cs.sporttype = 99
	where ci.custid = @Custid


	-- number game
	select	@MinBetv161_Min = Max(case when MinBet = 0 then NULL else MinBet end),
			@MaxBetv161_Max = Min(case when MaxBet = 0 then NULL else MaxBet end)
	from
		dep_custsetting3rd as cs WITH(NOLOCK)
		INNER JOIN custinfo as ci WITH(NOLOCK) ON (cs.CustID = ci.SRecommend) and cs.bettype = 81 and cs.sporttype = 161
	where ci.custid = @CustID


	Select @MaxperMatchv1_Max = Min(case when cs.MaxPerMatch = 0 then NULL else cs.MaxPerMatch end),
		
		@MaxPerMatchv2_Max = Min(case when cs.MaxPerMatch2 = 0 then NULL else cs.MaxPerMatch2 end),
		
		@MaxPerMatchv3_Max = Min(case when cs.MaxPerMatch3 = 0 then NULL else cs.MaxPerMatch3 end),

		@MaxPerMatchv5_Max = Min(case when cs.MaxPerMatch5 = 0 then NULL else cs.MaxPerMatch5 end),

		@MaxPerMatchv8_Max = Min(case when cs.MaxPerMatch8 = 0 then NULL else cs.MaxPerMatch8 end),

		@MaxPerMatchv10_Max = Min(case when cs.MaxPerMatch10 = 0 then NULL else cs.MaxPerMatch10 end),

		@MaxPerMatchv11_Max = Min(case when cs.MaxPerMatch11 = 0 then NULL else cs.MaxPerMatch11 end),
		
		

		@MaxPerMatchv99_Max = Min(case when cs.MaxPerMatch99 = 0 then NULL else cs.MaxPerMatch99 end),		
			
		@MaxPerMatchv99MP_Max = Min(case when cs.MaxPerMatch99MP = 0 then NULL else cs.MaxPerMatch99MP end),

		@MaxPerMatchv161_Max = Min(case when cs.MaxPerMatch161 = 0 then NULL else cs.MaxPerMatch161 end),

		@MaxPerBallv161_Max = Min(case when cs.MaxPerBall161 = 0 then NULL else cs.MaxPerBall161 end)
		
	from 
		custinfo as cs WITH (NOLOCK) 
		INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.SRecommend)
	where ci.custid = @CustID

	--- MaxPerMatch
	SELECT @MaxPerMatchv1				= ci.MaxPerMatch,
		@MaxPerMatchv2				= ci.MaxPerMatch2,
		@MaxPerMatchv3				= ci.MaxPerMatch3,
		@MaxPerMatchv5				= ci.MaxPerMatch5,
		@MaxPerMatchv8				= ci.MaxPerMatch8,
		@MaxPerMatchv10				= ci.MaxPerMatch10,
		@MaxPerMatchv11				= ci.MaxPerMatch11,
		
		@MaxPerMatchv99				= ci.MaxPerMatch99,
		
		@MaxPerMatchv99MP			= ci.MaxPerMatch99MP,
		@MaxPerMatchv161			= ci.MaxPerMatch161,
		@MaxPerBallv161				= ci.MaxPerBall161
	FROM custinfo (NOLOCK) ci WHERE ci.custid = @CustID

	--Keno
	 -- 20150603@Kathy: Migrate custDB to new server - DBCust
	 DECLARE @tmp_GameType TABLE (GameTypeID INT, GameTypeName NVARCHAR(50), IsDisabled BIT, IBCBettypeID INT)
	 BEGIN TRY		
		INSERT INTO @tmp_GameType (GameTypeID, GameTypeName, IsDisabled, IBCBettypeID)
		SELECT GameTypeID, GameTypeName, IsDisabled, IBCBettypeID FROM DBAGE.bodb02.dbo.GameType WITH (NOLOCK)
	 END TRY
	 BEGIN CATCH		
		INSERT INTO @tmp_GameType (GameTypeID, GameTypeName, IsDisabled, IBCBettypeID)
		SELECT GameTypeID, GameTypeName, IsDisabled, IBCBettypeID FROM DBTXN.bodb02.dbo.GameType WITH (NOLOCK)
	 END CATCH
	 
	--Minbet maxbet matchpermatch
	SELECT @vPT= ISNULL(mpositiontaking,0) FROM  dbo.CustSettingGame WITH (NOLOCK) WHERE Bettype =1501 AND CustID=@CustID 
	--MinBet_Max Maxbet_Min
	SELECT @vPT_Max= ISNULL(spositiontaking,0) FROM  dbo.CustSettingGame WITH (NOLOCK) WHERE Bettype =1501 AND CustID=@srecommend 
	SELECT gt.IBCBetTypeID bettype ,
		ISNULL(Minbet,0) AS Minbet_Up,
		ISNULL(MaxBet,0) AS MaxBet_Up,
		ISNULL(MaxPerGameType,0) AS MaxPerMatch_Up,
		ISNULL(cgt.isDisabled,1) AS isDisabled
	INTO #dataUpline
	FROM dbo.CustGameType cgt WITH (NOLOCK) 
	INNER JOIN @tmp_GameType gt ON cgt.GameTypeID = gt.GameTypeID
	WHERE Custid=@srecommend 

	SELECT gt.IBCBetTypeID bettype ,
		ISNULL(Minbet,0) AS Minbet,
		ISNULL(MaxBet,0) AS MaxBet,
		ISNULL(MaxPerGameType,0) AS MaxPerMatch,
		ISNULL(cgt.isDisabled,1) AS isDisabled
	INTO #data
	FROM dbo.CustGameType cgt WITH (NOLOCK) 
	INNER JOIN @tmp_GameType gt  ON cgt.GameTypeID = gt.GameTypeID
	WHERE Custid=@CustID 

	SELECT @KenoList=@KenoList+'<products>'
	DECLARE @i INT =1501,
	@j INT =(select max(bettype) from #data)
	WHILE (@i<=@j)
	BEGIN
		IF (@i=1501)
			BEGIN
				SELECT @KenoList=@KenoList+'<product BetType = "'+coalesce(cast(d.Bettype as varchar(50)),space(1))+ '" ' 
										  +'MaxBet = "'+coalesce(cast(MaxBet as varchar(50)),space(1))+ '" ' 
										  +'MaxBet_Min = "'+ coalesce(cast(MaxBet_up as varchar(50)),space(1)) + '" ' 
										  +'MinBet = "'+coalesce(cast(MinBet as varchar(50)),space(1))+ '" ' 
										  +'MinBet_Max = "'+ coalesce(cast(MinBet_up as varchar(50)),space(1)) + '" ' 
										  +'MaxPerMatch = "'+ coalesce(cast(MaxPerMatch as varchar(50)),space(1)) + '" ' +
										  +'MaxPerMatch_Max = "'+ coalesce(cast(MaxPerMatch_up as varchar(50)),space(1)) + '" '
										  +'isDisabled = "'+ coalesce(cast(d.isDisabled as varchar(50)),space(1)) + '" ' +
										  +'mPositionTaking = "'+ coalesce(CONVERT(varchar(50),@vPT,2),space(1)) +'" '
										  +'mPositionTaking_Max = "'+ coalesce(CONVERT( varchar(50),@vPT_Max,2),space(1)) +'" '
										  +'mPositionTaking_Min = "0" '
										  + '></product>'
				FROM #data d inner join #dataUpline d2 on d.bettype=d2.bettype
				WHERE d.Bettype=@i
			END
		ELSE
			BEGIN
				SELECT @KenoList=@KenoList+'<product BetType = "'+coalesce(cast(d.Bettype as varchar(50)),space(1))+ '" ' 
										  +'MaxBet = "'+coalesce(cast(MaxBet as varchar(50)),space(1))+ '" ' 
										  +'MaxBet_Min = "'+ coalesce(cast(MaxBet_up as varchar(50)),space(1)) + '" ' 
										  +'MinBet = "'+coalesce(cast(MinBet as varchar(50)),space(1))+ '" ' 
										  +'MinBet_Max = "'+ coalesce(cast(MinBet_up as varchar(50)),space(1)) + '" ' 
										  +'MaxPerMatch = "'+ coalesce(cast(MaxPerMatch as varchar(50)),space(1)) + '" ' +
										  +'MaxPerMatch_Max = "'+ coalesce(cast(MaxPerMatch_up as varchar(50)),space(1)) + '" '
										  +'isDisabled = "'+ coalesce(cast(d.isDisabled as varchar(50)),space(1)) + '" ' +
										  + '></product>'
				FROM #data d inner join #dataUpline d2 on d.bettype=d2.bettype
				WHERE d.Bettype=@i
			END	
		SELECT @i=@i+1
	END
	SELECT @KenoList=@KenoList+'</products>'

	SELECT @MinBetv1  AS MinBetv1,
		@MinBetv2     AS MinBetv2,
		@MinBetv3     AS MinBetv3,
		@MinBetv5     AS MinBetv5,
		@MinBetv8     AS MinBetv8,
		@MinBetv10    AS MinBetv10,
		@MinBetv11    AS MinBetv11,	
		
		@MinBetv99    AS MinBetv99,
	
		@MinBetv99MP  AS minbetv99MP,
		@MinBetv161   AS minbetv161,
		
		isnull(@MinBetv1_Min,0)     AS MinBetv1_Min,
		isnull(@MinBetv2_Min,0)     AS MinBetv2_Min,
		isnull(@MinBetv3_Min,0)     AS MinBetv3_Min,
		isnull(@MinBetv5_Min,0)     AS MinBetv5_Min,
		isnull(@MinBetv8_Min,0)     AS MinBetv8_Min,
		isnull(@MinBetv10_Min,0)    AS MinBetv10_Min,
		isnull(@MinBetv11_Min,0)    AS MinBetv11_Min,	
		
		isnull(@MinBetv99_Min,0)    AS MinBetv99_Min,
	
		isnull(@MinBetv99MP_Min,0)  AS minbetv99MP_Min,
		isnull(@MinBetv161_Min,0)   AS minbetv161_Min,
		
	
		@MaxBetv1 AS MaxBetv1,
		@MaxBetv2 AS MaxBetv2,
		@MaxBetv3 AS MaxBetv3,
		@MaxBetv5 AS MaxBetv5,
		@MaxBetv8 AS MaxBetv8,
		@MaxBetv10 AS MaxBetv10,
		@MaxBetv11 AS MaxBetv11,	
		
		@MaxBetv99 AS MaxBetv99,
	
		@MaxBetv99MP AS maxbetv99MP,
		@MaxBetv161 AS maxbetv161,
		
		
		isnull(@MaxBetv1_Max,0) AS MaxBetv1_Max,
		isnull(@MaxBetv2_Max,0) AS MaxBetv2_Max,
		isnull(@MaxBetv3_Max,0) AS MaxBetv3_Max,
		isnull(@MaxBetv5_Max,0) AS MaxBetv5_Max,
		isnull(@MaxBetv8_Max,0) AS MaxBetv8_Max,
		isnull(@MaxBetv10_Max,0) AS MaxBetv10_Max,
		isnull(@MaxBetv11_Max,0) AS MaxBetv11_Max,	
		
		isnull(@MaxBetv99_Max,0) AS MaxBetv99_Max,
		
		isnull(@MaxBetv99MP_Max,0) AS Maxbetv99MP_Max,
		isnull(@MaxBetv161_Max,0) AS Maxbetv161_Max,
		
		
		---PT
		@v1mPositionTaking_1 AS v1mPositionTaking_1,
		isnull(@v1mPositionTaking_1_Max,0) AS v1mPositionTaking_1_Max,
		0 AS v1mPositionTaking_1_Min,
		@v161mPositionTaking_81 AS v161mPositionTaking_81,
		isnull(@v161mPositionTaking_81_Max,0) AS v161mPositionTaking_81_Max,
		
		
		0 AS v161mPositionTaking_81_Min,
		
	
		
		isnull(@MaxPerMatchv1_Max,0)    AS MaxPerMatchv1_Max,
		isnull(@MaxPerMatchv2_Max,0)    AS MaxPerMatchv2_Max,
		isnull(@MaxPerMatchv3_Max,0)    AS MaxPerMatchv3_Max,
		isnull(@MaxPerMatchv5_Max,0)    AS MaxPerMatchv5_Max,
		isnull(@MaxPerMatchv8_Max,0)    AS MaxPerMatchv8_Max,
		isnull(@MaxPerMatchv10_Max,0)   AS MaxPerMatchv10_Max,
		isnull(@MaxPerMatchv11_Max,0)   AS MaxPerMatchv11_Max,	
		
		isnull(@MaxPerMatchv99_Max,0)   AS MaxPerMatchv99_Max,
		
		isnull(@MaxPerMatchv99MP_Max,0) AS MaxPerMatchv99MP_Max,
		isnull(@MaxPerMatchv161_Max,0)  AS MaxPerMatchv161_Max,
		isnull(@MaxPerBallv161_Max,0)	  AS MaxPerBallv161_Max,
		@MaxPerMatchv1		AS MaxPerMatchv1,
		@MaxPerMatchv2		AS MaxPerMatchv2,
		@MaxPerMatchv3		AS MaxPerMatchv3,
		@MaxPerMatchv5		AS MaxPerMatchv5,
		@MaxPerMatchv8		AS MaxPerMatchv8,
		@MaxPerMatchv10		AS MaxPerMatchv10,
		@MaxPerMatchv11		AS MaxPerMatchv11,
		
		@MaxPerMatchv99		AS MaxPerMatchv99,
	
		@MaxPerMatchv99MP	AS MaxPerMatchv99MP,
		@MaxPerBallv161		AS MaxPerBallv161,
		@MaxPerMatchv161	AS MaxPerMatchv161,
		@KenoList AS KenoList,	
		ci.username
	FROM CustInfo AS ci with (NOLOCK) 
	WHERE ci.CustID = @CustID
			
	DROP TABLE #dataUpline
	DROP TABLE #data

END
GO
GRANT EXECUTE ON [dbo].[Acc_Dep_CustomerSelMember_SAg] TO [bodbAdminNet] AS [dbo]
GO
