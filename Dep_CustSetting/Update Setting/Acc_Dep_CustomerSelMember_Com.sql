/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet" viewers="vnteam" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_CustomerSelMember_Com] 
	@CustID INT
AS


/*
Created: 20120321@Dom
Task : Company edit Super
DB: DBCust.CustDB

Revisions:
- 20131014@Francis: Support selecting new virtual sports with settings via XML param
- 20140505@Florent: Add new Sport HRFO
- 20140512@Florent: add Sport 202 Keno
- 20150603@Kathy: Move SP to DBCust.custDB [Redmine:#36216]
- 20151028@Jim:Implement Muay's Setting for Deposit Customer [Redmine: #45491]
- 20170302@Helen: Betradar Virtual Sports  -Integration for Cash [Redmine: 77274]
- 20180125@Winnie: Hide inactive products [RedmineID: #86086]   
Param's Explanation:
• @CustID: member ID
• @VirtualSportList: VirtualSport Settings XML param
*/
BEGIN
	SET NOCOUNT ON

	DECLARE @UserName			NVARCHAR(50),
			@MinBetv1			MONEY,  
			@MinBetv2			MONEY,  
			@MinBetv3			MONEY,  
			@MinBetv5			MONEY,  
			@MinBetv8			MONEY,  
			@MinBetv10			MONEY,  
			@MinBetv11			MONEY, 
			@MinBetv44			MONEY,  	
			@MinBetv99			MONEY,  
		
			@MaxBetv1			MONEY,
			@MaxBetv2			MONEY,
			@MaxBetv3			MONEY,
			@MaxBetv5			MONEY,
			@MaxBetv8			MONEY,
			@MaxBetv10			MONEY,
			@MaxBetv11			MONEY,
			@MaxBetv44			MONEY,
			@MaxBetv99			MONEY,
			
			@MinBetv99MP		MONEY,
			@MaxBetv99MP		MONEY,
			
			@MinBetv161			MONEY,
			@MaxBetv161			MONEY,
			
			@MaxPerMatchv1		MONEY,
			@MaxPerMatchv2		MONEY,
			@MaxPerMatchv3		MONEY,
			@MaxPerMatchv5		MONEY,
			@MaxPerMatchv8		MONEY,
			@MaxPerMatchv10		MONEY,
			@MaxPerMatchv11		MONEY,		
			@MaxPerMatchv44		MONEY,
			@MaxPerMatchv99		MONEY,
			
			@MaxPerMatchv99MP	MONEY,
			@MaxPerMatchv161	MONEY,	
			@MaxPerBallv161		MONEY,
			
			@v1sPositionTaking_1	MONEY,
			@v161sPositionTaking_81 MONEY,			

			--Keno
			@KenoList VARCHAR(4000)='', -- repalace all old params
			@vPT SMALLMONEY

	SELECT @MinBetv1 = MinBet, @MaxBetv1 = MaxBet, @v1sPositionTaking_1 = spositiontaking FROM Dep_CustSetting AS cs WITH (NOLOCK) WHERE cs.custid = @CustID and cs.bettype =  1 and cs.sporttype=1
	SELECT @MinBetv2 = MinBet,@MaxBetv2 = MaxBet FROM Dep_CustSetting AS cs WITH (NOLOCK) WHERE cs.custid = @CustID and cs.bettype = 1 and cs.sporttype=2
	SELECT @MinBetv3 = MinBet,	@MaxBetv3 = MaxBet FROM Dep_CustSetting AS cs WITH (NOLOCK) WHERE cs.custid = @CustID and cs.bettype = 1 and cs.sporttype=3
	SELECT @MinBetv5 = MinBet,	@MaxBetv5 = MaxBet FROM Dep_CustSetting AS cs WITH (NOLOCK) WHERE cs.custid = @CustID and cs.bettype = 1 and cs.sporttype=5
	SELECT @MinBetv8 = MinBet,	@MaxBetv8 = MaxBet FROM Dep_CustSetting AS cs WITH (NOLOCK) WHERE cs.custid = @CustID and cs.bettype = 1 and cs.sporttype=8
	SELECT @MinBetv10 = MinBet,@MaxBetv10 = MaxBet FROM Dep_CustSetting AS cs WITH (NOLOCK) WHERE cs.custid = @CustID and cs.bettype = 1 and cs.sporttype=10
	SELECT @MinBetv11 = MinBet, @MaxBetv11 = MaxBet FROM Dep_CustSetting AS cs WITH (NOLOCK) WHERE cs.custid = @CustID and cs.bettype = 1 and cs.sporttype=11
	SELECT @MinBetv44 = MinBet, @MaxBetv44 = MaxBet FROM Dep_CustSetting AS cs WITH (NOLOCK) WHERE cs.custid = @CustID and cs.bettype = 3 and cs.sporttype=44
	SELECT @MinBetv99 = MinBet, @MaxBetv99 = MaxBet FROM Dep_CustSetting AS cs WITH (NOLOCK) WHERE cs.custid = @CustID and cs.bettype = 1 and cs.sporttype=99
	
	--Mix parlay mixed sports 
	SELECT @MinBetv99MP = MinBet, @MaxBetv99MP = MaxBet FROM Dep_CustSetting AS cs WITH (NOLOCK) WHERE cs.custid = @CustID and cs.bettype = 9 and cs.sporttype=99

	--Number Game 
	SELECT @MinBetv161 = MinBet, @MaxBetv161 = MaxBet, @v161sPositionTaking_81 = spositiontaking FROM Dep_CustSetting3rd AS cs WITH (NOLOCK)	WHERE cs.custid = @CustID and cs.bettype = 81 and cs.sporttype=161

	
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
	 
	SELECT @vPT= ISNULL(spositiontaking,0) FROM  dbo.CustSettingGame WITH (NOLOCK) WHERE Bettype =1501 AND CustID=@CustID 
	SELECT gt.IBCBetTypeID bettype ,
		ISNULL(Minbet,0) AS Minbet,
		ISNULL(MaxBet,0) AS MaxBet,
		ISNULL(MaxPerGameType,0) AS MaxPerMatch,
		ISNULL(cgt.isDisabled,1) AS isDisabled
	INTO #data
	FROM dbo.CustGameType cgt WITH (NOLOCK) 
	INNER JOIN @tmp_GameType gt ON cgt.GameTypeID = gt.GameTypeID
	WHERE Custid=@CustID 

	SELECT @KenoList=@KenoList+'<products>'
	DECLARE @i INT =1501,
	@j INT =(select max(bettype) from #data)
	WHILE (@i<=@j)
	BEGIN
		IF (@i=1501)
			BEGIN
				SELECT @KenoList=@KenoList+'<product BetType = "'+coalesce(cast(Bettype as varchar(50)),space(1))+ '" ' 
										  +'MaxBet = "'+coalesce(cast(MaxBet as varchar(50)),space(1))+ '" ' 
										  +'MinBet = "'+coalesce(cast(MinBet as varchar(50)),space(1))+ '" ' 
										  +'MaxPerMatch = "'+ coalesce(cast(MaxPerMatch as varchar(50)),space(1)) + '" ' +
										  +'isDisabled = "'+ coalesce(cast(isDisabled as varchar(50)),space(1)) + '" ' +
										  +'sPositionTaking = "'+ coalesce(cast(@vPT as varchar(50)),space(1)) +'" '
										  + '></product>'
				FROM #data
				WHERE Bettype=@i
			END
		ELSE
			BEGIN
				SELECT @KenoList=@KenoList+'<product BetType = "'+coalesce(cast(Bettype as varchar(50)),space(1))+ '" ' 
										  +'MaxBet = "'+coalesce(cast(MaxBet as varchar(50)),space(1))+ '" ' 
										  +'MinBet = "'+coalesce(cast(MinBet as varchar(50)),space(1))+ '" ' 
										  +'MaxPerMatch = "'+ coalesce(cast(MaxPerMatch as varchar(50)),space(1)) + '" ' +
										  +'isDisabled = "'+ coalesce(cast(isDisabled as varchar(50)),space(1)) + '" ' +
										  + '></product>'
				FROM #data
				WHERE Bettype=@i
			END	
		SELECT @i=@i+1
	END
	SELECT @KenoList=@KenoList+'</products>'

	SELECT  @MinBetv1 AS MinBetv1,
			@MinBetv2  AS MinBetv2,
			@MinBetv3  AS MinBetv3,
			@MinBetv5  AS MinBetv5,
			@MinBetv8  AS MinBetv8,
			@MinBetv10 AS MinBetv10,
			@MinBetv11 AS MinBetv11,	
			@MinBetv44 AS MinBetv44,
			@MinBetv99 AS MinBetv99,		
			@MinBetv99MP AS MinBetv99MP,
			@MinBetv161 AS MinBetv161,	

			@MaxBetv1 AS MaxBetv1,
			@MaxBetv2 AS MaxBetv2,
			@MaxBetv3 AS MaxBetv3,
			@MaxBetv5 AS MaxBetv5,
			@MaxBetv8 AS MaxBetv8,
			@MaxBetv10 AS MaxBetv10,
			@MaxBetv11 AS MaxBetv11,	
			@MaxBetv44 AS MaxBetv44,
			@MaxBetv99 AS MaxBetv99,		
			@MaxBetv99MP AS MaxBetv99MP,
			@MaxBetv161 AS MaxBetv161,

			@v1sPositionTaking_1 AS v1sPositionTaking_1,
			@v161sPositionTaking_81 AS v161sPositionTaking_81,

			ci.MaxPerMatch					AS MaxPerMatchv1,			
			ci.MaxPerMatch2					AS MaxPerMatchv2,			
			ci.MaxPerMatch3					AS MaxPerMatchv3,			
			ci.MaxPerMatch5					AS MaxPerMatchv5,			
			ci.MaxPerMatch8					AS MaxPerMatchv8,			
			ci.MaxPerMatch10				AS MaxPerMatchv10,			
			ci.MaxPerMatch11				AS MaxPerMatchv11,			
			ci.MaxPerMatch44				AS MaxPerMatchv44,
			ci.MaxPerMatch99				AS MaxPerMatchv99,			
			
			ci.MaxPerMatch99MP				AS MaxPerMatchv99MP,		
			ci.MaxPerMatch161				AS MaxPerMatchv161,		
			ci.MaxPerBall161				AS MaxPerBallv161,
			@KenoList AS KenoList,
			
			ci.UserName AS UserName
	FROM CustInfo AS ci WITH (NOLOCK)
		INNER JOIN CustSuper AS csp WITH (NOLOCK) ON ci.custid = csp.custid
	WHERE ci.custid = @CustID

	DROP TABLE #data

END
GO
GRANT EXECUTE ON [dbo].[Acc_Dep_CustomerSelMember_Com] TO [bodbAdminNet] AS [dbo]
GO
GRANT VIEW DEFINITION ON [dbo].[Acc_Dep_CustomerSelMember_Com] TO [vnteam] AS [dbo]