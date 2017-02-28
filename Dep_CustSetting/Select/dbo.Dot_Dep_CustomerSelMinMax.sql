ALTER PROCEDURE [dbo].[Dot_Dep_CustomerSelMinMax_Cust]
	@custid INT,
	@MinBet MONEY OUTPUT,
	@MaxBet MONEY OUTPUT,
	@MaxPerMatch MONEY OUTPUT,
	@MinBetv2 MONEY OUTPUT,
	@MaxBetv2 MONEY OUTPUT,
	@MaxPerMatchv2 MONEY OUTPUT,
	@MinBetv3 MONEY OUTPUT,
	@MaxBetv3 MONEY OUTPUT,
	@MaxPerMatchv3 MONEY OUTPUT,
	@MinBetv5 MONEY OUTPUT,
	@MaxBetv5 MONEY OUTPUT,
	@MaxPerMatchv5 MONEY OUTPUT,
	@MinBetv8 MONEY OUTPUT,
	@MaxBetv8 MONEY OUTPUT,
	@MaxPerMatchv8 MONEY OUTPUT,
	@MinBetv10 MONEY OUTPUT,
	@MaxBetv10 MONEY OUTPUT,
	@MaxPerMatchv10 MONEY OUTPUT,
	@MinBetv11 MONEY OUTPUT,
	@MaxBetv11 MONEY OUTPUT,
	@MaxPerMatchv11 MONEY OUTPUT,
	@MinBetv99 MONEY OUTPUT,
	@MaxBetv99 MONEY OUTPUT,
	@MaxPerMatchv99 MONEY OUTPUT,
	@MinBetv99MP MONEY OUTPUT,
	@MaxBetv99MP MONEY OUTPUT,
	@MaxPerMatchv99MP MONEY OUTPUT,
	@MinBetv154 MONEY OUTPUT,
	@MaxBetv154 MONEY OUTPUT,
	@MaxPerMatchv154 MONEY OUTPUT,
	@MinBetv161 MONEY OUTPUT,
	@MaxBetv161 MONEY OUTPUT,
	@MaxPerMatchv161 MONEY OUTPUT,
	@MaxPerBallv161 MONEY OUTPUT,
	@MinBetv202_1501 MONEY OUTPUT,
	@MaxBetv202_1501 MONEY OUTPUT,
	@MaxPerMatchv202_1501 MONEY OUTPUT

AS
/*
Created: 20120321@Kiwi
Task : Select customer minbet, maxbet, maxpermatch. 
DB: DBTRANS/CustDB
Original:Acc_CustomerSelMinMax

Revisions:
    - 20140123@Elodie: retrieve bet setting for HR Fixed Odds(154) [Redmine:#10922]
	- 20140305@Elodie: retrieve bet setting for Keno(202) [Redmine:#11658]
Param's Explanation:
• @custid: custid that need to be viewed.   
*/

SET NOCOUNT ON

SELECT @MinBet = isnull(MinBet, 0), @MaxBet = isnull(MaxBet, 0)
FROM Dep_CustSetting WITH (NOLOCK)
WHERE custid = @CustID AND bettype = 1 AND sporttype = 1 AND islive=0

SELECT @MinBetv2 = isnull(MinBet, 0), @MaxBetv2 = isnull(MaxBet, 0)
FROM Dep_CustSetting WITH (NOLOCK)
WHERE custid = @CustID AND bettype = 1 AND sporttype = 2

SELECT @MinBetv3 = isnull(MinBet, 0), @MaxBetv3 = isnull(MaxBet, 0)
FROM Dep_CustSetting WITH (NOLOCK)
WHERE custid = @CustID AND bettype = 1 AND sporttype = 3

SELECT @MinBetv5 = isnull(MinBet, 0), @MaxBetv5 = isnull(MaxBet, 0)
FROM Dep_CustSetting WITH (NOLOCK)
WHERE custid = @CustID AND bettype = 1 AND sporttype = 5

SELECT @MinBetv8 = isnull(MinBet, 0), @MaxBetv8 = isnull(MaxBet, 0)
FROM Dep_CustSetting WITH (NOLOCK)
WHERE custid = @CustID AND bettype = 1 AND sporttype = 8

SELECT @MinBetv10 = isnull(MinBet, 0), @MaxBetv10 = isnull(MaxBet, 0)
FROM Dep_CustSetting WITH (NOLOCK)
WHERE custid = @CustID AND bettype = 1 AND sporttype = 10

SELECT @MinBetv11 = isnull(MinBet, 0), @MaxBetv11 = isnull(MaxBet, 0)
FROM Dep_CustSetting WITH (NOLOCK)
WHERE custid = @CustID AND bettype = 1 AND sporttype = 11

SELECT @MinBetv99 = isnull(MinBet, 0), @MaxBetv99 = isnull(MaxBet, 0)
FROM Dep_CustSetting WITH (NOLOCK)
WHERE custid = @CustID AND bettype = 1 AND sporttype = 99

SELECT @MinBetv99MP = isnull(MinBet, 0), @MaxBetv99MP = isnull(MaxBet, 0)
FROM Dep_CustSetting WITH (NOLOCK)
WHERE custid = @CustID AND bettype = 9 AND sporttype = 99

SELECT @MinBetv154 = isnull(MinBet, 0), @MaxBetv154 = isnull(MaxBet, 0)
FROM Dep_CustSetting WITH (NOLOCK)
WHERE custid = @CustID AND bettype = 20 AND sporttype = 154

SELECT @MinBetv161 = isnull(MinBet, 0), @MaxBetv161 = isnull(MaxBet, 0)
FROM Dep_CustSetting3rd WITH (NOLOCK)
WHERE custid = @CustID AND bettype = 81 AND sporttype = 161

SELECT @MinBetv202_1501 = isnull(MinBet, 0), @MaxBetv202_1501 = isnull(MaxBet, 0), @MaxPerMatchv202_1501 = isnull(MaxPerGameType, 0)
FROM CustGameType cg WITH (NOLOCK)
	INNER JOIN bodb02.dbo.GameType gt WITH (NOLOCK) ON cg.GameTypeID = gt.GameTypeID
WHERE custid = @CustID AND gt.IBCBetTypeID = 1501

--MAX PER MATCH
SELECT @MaxperMatch = MaxPerMatch,
		@MaxPerMatchv2 = MaxPerMatch2,
		@MaxPerMatchv3 = MaxPerMatch3,
		@MaxPerMatchv5 = MaxPerMatch5,
		@MaxPerMatchv8 = MaxPerMatch8,
		@MaxPerMatchv10 = MaxPerMatch10,
		@MaxPerMatchv11 = MaxPerMatch11,
		@MaxPerMatchv99 = MaxPerMatch99,
		@MaxPerMatchv99MP = MaxPerMatch99MP,
		@MaxPerMatchv154 = MaxPerMatch154,
		@MaxPerMatchv161 = MaxPerMatch161,
		@MaxPerBallv161 = MaxPerBall161
FROM custinfo WITH (NOLOCK)
WHERE custid = @CustID

GO
GRANT ALTER ON [dbo].[Dot_Dep_CustomerSelMinMax_Cust] TO [vnteam] AS [dbo]
GO
GRANT VIEW DEFINITION ON [dbo].[Dot_Dep_CustomerSelMinMax_Cust] TO [vnteam] AS [dbo]