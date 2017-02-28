
ALTER PROCEDURE [dbo].[Acc_Dep_CustomerSelMinMax]
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
	@MinBetv44 MONEY OUTPUT,
	@MaxBetv44 MONEY OUTPUT,
	@MaxPerMatchv44 MONEY OUTPUT,
	@MinBetv99 MONEY OUTPUT,
	@MaxBetv99 MONEY OUTPUT,
	@MaxPerMatchv99 MONEY OUTPUT,
	@MinBetv99MP MONEY OUTPUT,
	@MaxBetv99MP MONEY OUTPUT,
	@MaxPerMatchv99MP MONEY OUTPUT,
	@MinBetv161 MONEY OUTPUT,
	@MaxBetv161 MONEY OUTPUT,
	@MaxPerMatchv161 MONEY OUTPUT,
	@MaxPerBallv161 MONEY OUTPUT

AS
/*
Created: 20120321@Kiwi
Task : Select customer minbet, maxbet, maxpermatch. 
DB: DBTRANS.bodb02
Original:Acc_CustomerSelMinMax

Revisions:
    - 20151028@Jim:Implement Muay's Setting for Deposit Customer [Redmine: #45491]
Param's Explanation:
• @custid: custid that need to be viewed.   
*/

SET NOCOUNT ON

SELECT @MinBet = isnull(MinBet, 0), @MaxBet = isnull(MaxBet, 0)
FROM Dep_CustSetting WITH (NOLOCK)
WHERE custid = @CustID AND bettype = 1 AND sporttype = 1

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
--
SELECT @MinBetv44 = isnull(MinBet, 0), @MaxBetv44 = isnull(MaxBet, 0)
FROM Dep_CustSetting WITH (NOLOCK)
WHERE custid = @CustID AND bettype = 3 AND sporttype = 44
--
SELECT @MinBetv99 = isnull(MinBet, 0), @MaxBetv99 = isnull(MaxBet, 0)
FROM Dep_CustSetting WITH (NOLOCK)
WHERE custid = @CustID AND bettype = 1 AND sporttype = 99

SELECT @MinBetv99MP = isnull(MinBet, 0), @MaxBetv99MP = isnull(MaxBet, 0)
FROM Dep_CustSetting WITH (NOLOCK)
WHERE custid = @CustID AND bettype = 9 AND sporttype = 99

SELECT @MinBetv161 = isnull(MinBet, 0), @MaxBetv161 = isnull(MaxBet, 0)
FROM Dep_CustSetting3rd WITH (NOLOCK)
WHERE custid = @CustID AND bettype = 81 AND sporttype = 161

--MAX PER MATCH
SELECT @MaxperMatch = MaxPerMatch,
		@MaxPerMatchv2 = MaxPerMatch2,
		@MaxPerMatchv3 = MaxPerMatch3,
		@MaxPerMatchv5 = MaxPerMatch5,
		@MaxPerMatchv8 = MaxPerMatch8,
		@MaxPerMatchv10 = MaxPerMatch10,
		@MaxPerMatchv11 = MaxPerMatch11,
		@MaxPerMatchv44 = MaxPerMatch44,
		@MaxPerMatchv99 = MaxPerMatch99,
		@MaxPerMatchv99MP = MaxPerMatch99MP,
		@MaxPerMatchv161 = MaxPerMatch161,
		@MaxPerBallv161 = MaxPerBall161
FROM custinfo WITH (NOLOCK)
WHERE custid = @CustID

GO
GRANT VIEW DEFINITION ON [dbo].[Acc_Dep_CustomerSelMinMax] TO [vnteam]