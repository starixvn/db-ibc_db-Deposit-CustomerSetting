ALTER  PROCEDURE Acc_Dep_CustomerSelMemberVirtualSports_Ag
	@custid INT,
	@sporttype INT
 AS
 
 /*
Created: 20120828@Dom
Task : Agent get member info to edit
DB: DB052.bodb02

Revisions:
    
Param's Explanation:
• @CustID: member ID
*/
SET NOCOUNT ON
 
 DECLARE @MaxBet_Min MONEY,
	@MinBet_Max MONEY,
	@aPositionTaking_Max MONEY,
	@recommend INT,
	@MaxPerMatch_max MONEY
	
SELECT @recommend = ci.recommend
FROM custInfo ci WITH (NOLOCK)
WHERE custid= @custid

SELECT @MaxPerMatch_max = MIN(CASE WHEN cs.maxpermatch180 = 0 THEN NULL ELSE cs.maxpermatch180 END)
from custinfo as cs WITH (NOLOCK) 
INNER JOIN  custinfo as ci WITH (NOLOCK) ON ci.recommend = cs.custid OR ci.mrecommend = cs.custid OR ci.srecommend = cs.custid
WHERE ci.custid = @recommend

SELECT @MinBet_Max = MAX(case WHEN cs3.minbet = 0 then NULL ELSE cs3.minbet END),
		@MaxBet_Min = MIN(CASE WHEN cs3.maxbet = 0 then NULL ELSE cs3.maxbet END)
FROM custInfo ci WITH (NOLOCK)
INNER JOIN  Dep_CustSetting3rd cs3 WITH (NOLOCK) ON ci.recommend = cs3.custid OR ci.mrecommend = cs3.custid OR ci.srecommend = cs3.custid
WHERE ci.custid = @recommend
AND cs3.sporttype = @sporttype 

SELECT @aPositionTaking_Max = cs3.apositiontaking
FROM Dep_CustSetting3rd cs3 WITH (NOLOCK)
WHERE cs3.custid = @recommend
AND cs3.sporttype = @sporttype

SELECT @MaxBet_Min AS MaxBet_Min,
	@MinBet_Max AS MinBet_Max,
	@aPositionTaking_Max AS aPositionTaking_Max,
	@MaxPerMatch_max AS MaxPerMatch_max,
	ci.maxpermatch180 as maxpermatch,
	cs3.minbet,
	cs3.maxbet,
	cs3.apositiontaking
FROM custInfo ci WITH (NOLOCK)
INNER JOIN Dep_CustSetting3rd cs3 ON cs3.custid = ci.custid 
WHERE ci.custid = @custid
AND cs3.sporttype = @sporttype