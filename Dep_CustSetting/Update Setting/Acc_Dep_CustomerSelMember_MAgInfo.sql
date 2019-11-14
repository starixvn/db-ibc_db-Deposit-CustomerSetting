/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_CustomerSelMember_MAgInfo]
	@CustID INT
AS

/*
Created: 20120720@Dom
TASk : select min/max setting Master Agent to add new agent
DB: DBCust.CustDB

Revisions:
- 20131014@Francis: Support selecting new virtual sports with settings via XML param
- 20140418@Francis: Fix not returning data of bet setting (when customer does not have 3rd party game) bug
- 20140512@Florent: Add sport Keno
- 20150603@Kathy: Move SP to DBCust.custDB [Redmine:#36216]
- 20151028@Jim:Implement Muay's Setting for Deposit Customer [Redmine: #45491]
- 20180125@Winnie: Hide inactive products [RedmineID: #86086]    
- 20190326@Winnie: Update PT of Sportsbook for All Licensee. [RedmineID: #110111]  
- 20190726@Winnie: Remove Muay Thai. [RedmineID: #117501]  
- 20190905@Eden: 3rd party products - Remove InActive Products Phase 2 [Redmine: #118699]
Param's Explanation:
• @CustID: member ID
• @VirtualSportList: VirtualSport Settings XML param
*/
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
		
		@MaxPerMatchv1_Min				MONEY,
		@MaxPerMatchv2_Min				MONEY,
		@MaxPerMatchv3_Min				MONEY,
		@MaxPerMatchv5_Min				MONEY,
		@MaxPerMatchv8_Min				MONEY,
		@MaxPerMatchv10_Min				MONEY,
		@MaxPerMatchv11_Min				MONEY,
		
		@MaxPerMatchv99_Min				MONEY,
	
		@MaxPerMatchv99MP_Min			MONEY,
		@MaxPerMatchv161_Min			MONEY,

		@MinBetv161						MONEY,
		@MinBetv161_Min					MONEY,
		@MaxBetv161						MONEY,
		@MaxBetv161_Max					MONEY,

		@MinBetv99MP					MONEY,
		@MinBetv99MP_Min				MONEY,
		@MaxBetv99MP					MONEY,
		@MaxBetv99MP_Max				MONEY,
		
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
	
		@MaxPerMatchv99MP				MONEY,
		@MaxPerMatchv99MP_Max			MONEY,
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
		@mrecommend				INT,
		@UserName				VARCHAR(50)

SELECT @mrecommend = mrecommend, @UserName = username FROM custinfo AS ci WITH (NOLOCK) where custid = @CustID

SELECT  @MinBetv1 = max(CASE WHEN cs.bettype = 1 AND cs.sporttype = 1 THEN cs.minbet ELSE 0 END) , 
		@MaxBetv1 = max(CASE WHEN cs.bettype = 1 AND cs.sporttype = 1 THEN cs.maxbet ELSE 0 END),
		@v1mPositionTaking_1 = max(CASE WHEN cs.bettype = 1 AND cs.sporttype = 1 THEN cs.mPositionTaking ELSE 0 END),

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
		@v161mPositionTaking_81 = max(CASE WHEN cs3rd.bettype = 81 AND cs3rd.sporttype = 161 THEN cs3rd.mPositionTaking ELSE 0 END)	
FROM Dep_CustSetting AS cs WITH (NOLOCK) 
	LEFT JOIN Dep_CustSetting3rd AS cs3rd WITH (NOLOCK) ON cs.custid = cs3rd.custid
WHERE cs.custid = @CustID


---setting
SELECT  @MinBetv1_Min = max(case when MinBet = 0 then NULL else MinBet end), 
		@MaxBetv1_Max = min(case when MaxBet = 0 then NULL else MaxBet end)
FROM 
	dep_custsetting AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend) AND cs.bettype = 1 AND cs.sporttype=1
WHERE ci.custid = @CustID
		
SELECT	@MinBetv2_Min = max(case when MinBet = 0 then NULL else MinBet end),
		@MaxBetv2_Max = min(case when MaxBet = 0 then NULL else MaxBet end)
FROM 
	dep_custsetting AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend) AND cs.bettype = 1 AND cs.sporttype=2
WHERE ci.custid = @CustID		

SELECT	@MinBetv3_Min = max(case when MinBet = 0 then NULL else MinBet end),
		@MaxBetv3_Max = min(case when MaxBet = 0 then NULL else MaxBet end)
FROM 
	dep_custsetting AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend) AND cs.bettype = 1 AND cs.sporttype=3
WHERE ci.custid = @CustID		

		
SELECT	@MinBetv5_Min = max(case when MinBet = 0 then NULL else MinBet end),
		@MaxBetv5_Max = min(case when MaxBet = 0 then NULL else MaxBet end)
FROM 
	dep_custsetting AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend) AND cs.bettype = 1 AND cs.sporttype=5
WHERE ci.custid = @CustID		
		
SELECT	@MinBetv8_Min = max(case when MinBet = 0 then NULL else MinBet end),
		@MaxBetv8_Max = min(case when MaxBet = 0 then NULL else MaxBet end)
FROM 
	dep_custsetting AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend) AND cs.bettype = 1 AND cs.sporttype=8
WHERE ci.custid = @CustID

SELECT	@MinBetv10_Min = max(case when MinBet = 0 then NULL else MinBet end),
		@MaxBetv10_Max = min(case when MaxBet = 0 then NULL else MaxBet end)
FROM 
	dep_custsetting AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend) AND cs.bettype = 1 AND cs.sporttype=10
WHERE ci.custid = @CustID		

SELECT	@MinBetv11_Min = max(case when MinBet = 0 then NULL else MinBet end),
		@MaxBetv11_Max = min(case when MaxBet = 0 then NULL else MaxBet end)
FROM 
	dep_custsetting AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend) AND cs.bettype = 1 AND cs.sporttype=11
WHERE ci.custid = @CustID		
---

--
SELECT	@MinBetv99_Min = max(case when MinBet = 0 then NULL else MinBet end),
		@MaxBetv99_Max = min(case when MaxBet = 0 then NULL else MaxBet end)
FROM 
	dep_custsetting AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend) AND cs.bettype = 1 AND cs.sporttype=99
WHERE ci.custid = @CustID


SELECT	@MinBetv99MP_Min = max(case when MinBet = 0 then NULL else MinBet end),
		@MaxBetv99MP_Max = min(case when MaxBet = 0 then NULL else MaxBet end)
FROM 
	dep_custsetting AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend) AND cs.bettype = 9 AND cs.sporttype=99
WHERE ci.custid = @CustID		

SELECT	@MinBetv161_Min = max(case when MinBet = 0 then NULL else MinBet end),
		@MaxBetv161_Max = min(case when MaxBet = 0 then NULL else MaxBet end)
FROM 
	dep_custsetting3rd AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend) AND cs.bettype = 81 AND cs.sporttype=161
WHERE ci.custid = @CustID

Select	
	@MaxPerMatchv1_Min = 0,
	@MaxPerMatchv2_Min = 0,
	@MaxPerMatchv3_Min = 0,
	@MaxPerMatchv5_Min = 0,
	@MaxPerMatchv8_Min = 0,
	@MaxPerMatchv10_Min = 0,
	@MaxPerMatchv11_Min = 0,
	
	@MaxPerMatchv99_Min = 0,
	
	@MaxPerMatchv99MP_Min = 0,
	@MaxPerMatchv161_Min = 0,
	
	@MaxPerMatchv1_Max = Min(case when cs.MaxPerMatch = 0 then NULL else cs.MaxPerMatch end), 
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
	INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend)
where ci.custid = @CustID

--PT MAX
SELECT	@v1mPositionTaking_1_Max = max(CASE WHEN cs.bettype = 1 AND cs.sporttype = 1 THEN cs.mpositiontaking ELSE 0 END),
		@v161mPositionTaking_81_Max = max(CASE WHEN cs3rd.bettype = 81 AND cs3rd.sporttype = 161 THEN cs3rd.mpositiontaking ELSE 0 END)
FROM Dep_CustSetting AS cs WITH (NOLOCK)
	LEFT JOIN Dep_CustSetting3rd AS cs3rd WITH (NOLOCK) ON cs.custid = cs3rd.custid
 WHERE cs.custid = @mrecommend

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
--Keno

--Minbet maxbet matchpermatch
SELECT @vPT= ISNULL(mpositiontaking,0) 
FROM  dbo.CustSettingGame WITH (NOLOCK) 
WHERE Bettype =1501 AND CustID=@CustID 
--MinBet_Max Maxbet_Min
SELECT @vPt_Max= ISNULL(mpositiontaking,0) 
FROM  dbo.CustSettingGame WITH (NOLOCK) 
WHERE Bettype =1501 AND CustID=@mrecommend 


SELECT gt.IBCBetTypeID bettype ,
	ISNULL(Minbet,0) AS Minbet_Up,
	ISNULL(MaxBet,0) AS MaxBet_Up,
	ISNULL(MaxPerGameType,0) AS MaxPerMatch_Up,
	ISNULL(cgt.isDisabled,1) AS isDisabled
INTO #dataUpline
FROM dbo.CustGameType cgt WITH (NOLOCK) 
INNER JOIN @tmp_GameType gt ON cgt.GameTypeID = gt.GameTypeID
WHERE Custid=@mrecommend 

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
			SELECT @KenoList=@KenoList+'<product BetType = "'+coalesce(cast(d.Bettype as varchar(50)),space(1))+ '" ' 
									  +'MaxBet = "'+coalesce(cast(MaxBet as varchar(50)),space(1))+ '" ' 
									  +'MaxBet_Min = "'+ coalesce(cast(MaxBet_up as varchar(50)),space(1)) + '" ' 
									  +'MinBet = "'+coalesce(cast(MinBet as varchar(50)),space(1))+ '" ' 
									  +'MinBet_Max = "'+ coalesce(cast(MinBet_up as varchar(50)),space(1)) + '" ' 
									  +'MaxPerMatch = "'+ coalesce(cast(MaxPerMatch as varchar(50)),space(1)) + '" ' +
									  +'MaxPerMatch_Max = "'+ coalesce(cast(MaxPerMatch_up as varchar(50)),space(1)) + '" '
									  +'isDisabled = "'+ coalesce(cast(d.isDisabled as varchar(50)),space(1)) + '" ' +
									  +'mPositionTaking = "'+ coalesce(CONVERT(varchar(50),@vPT,2),space(1)) +'" '
									  +'mPositionTaking_Max = "'+ coalesce(CONVERT(varchar(50),@vPT_Max,2),space(1)) +'" '
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
	

	@MaxBetv1		AS MaxBetv1,
	@MaxBetv2		AS MaxBetv2,
	@MaxBetv3		AS MaxBetv3,
	@MaxBetv5		AS MaxBetv5,
	@MaxBetv8		AS MaxBetv8,
	@MaxBetv10		AS MaxBetv10,
	@MaxBetv11		AS MaxBetv11,	
	
	@MaxBetv99		AS MaxBetv99,
	
	@MaxBetv99MP	AS maxbetv99MP,
	@MaxBetv161		AS maxbetv161,

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
	@v1mPositionTaking_1_Max AS v1mPositionTaking_1_Max,
	@v161mPositionTaking_81 AS v161mPositionTaking_81,
	@v161mPositionTaking_81_Max AS v161mPositionTaking_81_Max,
	



	-- Max Per Match
	isnull(@MaxPerMatchv1_Max,0)			AS MaxPerMatchv1_Max,		
	isnull(@MaxPerMatchv2_Max,0)			AS MaxPerMatchv2_Max,		
	isnull(@MaxPerMatchv3_Max,0)			AS MaxPerMatchv3_Max,		
	isnull(@MaxPerMatchv5_Max,0)			AS MaxPerMatchv5_Max,		
	isnull(@MaxPerMatchv8_Max,0)			AS MaxPerMatchv8_Max,		
	isnull(@MaxPerMatchv10_Max,0)			AS MaxPerMatchv10_Max,		
	isnull(@MaxPerMatchv11_Max,0)			AS MaxPerMatchv11_Max,		
	
	isnull(@MaxPerMatchv99_Max,0)			AS MaxPerMatchv99_Max,		
	
	isnull(@MaxPerMatchv99MP_Max,0)			AS MaxPerMatchv99MP_Max,	
	isnull(@MaxPerMatchv161_Max,0)			AS MaxPerMatchv161_Max,	
	isnull(@MaxPerBallv161_Max,0)			AS MaxPerBallv161_Max,
	
	ci.MaxPerMatch				AS MaxPerMatchv1,		
	ci.MaxPerMatch2				AS MaxPerMatchv2,		
	ci.MaxPerMatch3				AS MaxPerMatchv3,		
	ci.MaxPerMatch5				AS MaxPerMatchv5,		
	ci.MaxPerMatch8				AS MaxPerMatchv8,		
	ci.MaxPerMatch10			AS MaxPerMatchv10,		
	ci.MaxPerMatch11			AS MaxPerMatchv11,		
	
	ci.MaxPerMatch99			AS MaxPerMatchv99,		
	
	ci.MaxPerMatch99MP			AS MaxPerMatchv99MP,	
	ci.MaxPerMatch161			AS MaxPerMatchv161,	
	ci.MaxPerBall161			AS MaxPerBallv161,	
	
	@KenoList AS KenoList,

	@UserName AS UserName
FROM custinfo (NOLOCK) ci WHERE ci.custid = @CustID

DROP TABLE #dataUpline
DROP TABLE #data


GO
