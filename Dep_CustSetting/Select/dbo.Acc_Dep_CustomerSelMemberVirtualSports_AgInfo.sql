 ALTER PROCEDURE Acc_Dep_CustomerSelMemberVirtualSports_AgInfo
	@custid INT,
	@sporttype INT 
 AS
 
 /*
Created: 20120828@Dom
Task : Get Agent's info to add new member
DB: DB052.bodb02

Revisions:
    
Param's Explanation:
• @CustID: member ID
*/
 
DECLARE @MaxBet_Min MONEY,
	@MinBet_Max MONEY,
	@aPositionTaking_Max MONEY,
	@recommend INT,
	@MaxPerMatch_max MONEY
	
SELECT @recommend = ci.recommend
FROM custInfo ci WITH (NOLOCK)
WHERE custid= @custid

 SELECT @maxpermatch_max = min(case when cs.maxpermatch180 = 0 then NULL ELSE cs.maxpermatch180 END)
 from 
	custinfo as cs WITH (NOLOCK) 
	INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend OR ci.recommend = cs.custid)
 where ci.custid = @CustId
 
SELECT @MinBet_Max = MAX(CASE WHEN cs3.minbet = 0 THEN NULL ELSE cs3.minbet END),
		@MaxBet_Min =  min( case when cs3.maxbet = 0 THEN NULL ELSE cs3.maxbet END )
FROM Dep_CustSetting3rd cs3 WITH (NOLOCK)
INNER JOIN custInfo ci WITH (NOLOCK) ON ci.recommend = cs3.custid OR ci.mrecommend = cs3.custid OR ci.srecommend = cs3.custid
WHERE ci.custid = @custid
AND cs3.sporttype = @sporttype 

SELECT @aPositionTaking_Max = cs3.apositiontaking
FROM Dep_CustSetting3rd cs3 WITH (NOLOCK)
WHERE cs3.custid = @recommend
AND cs3.sporttype = @sporttype

SELECT @MaxBet_Min AS MaxBet_Min,
	@MinBet_Max AS MinBet_Max,
	@aPositionTaking_Max AS aPositionTaking_Max,
	@MaxPerMatch_max AS MaxPerMatch_max
	
	
GO
GRANT EXECUTE ON [dbo].[Acc_Dep_CustomerSelMemberVirtualSports_AgInfo] TO [bodbadminNet]
GO
GRANT VIEW DEFINITION ON [dbo].[Acc_Dep_CustomerSelMemberVirtualSports_AgInfo] TO [vnteam]
Go

--SELECT * from custInfo where username = 'PSuperTestVS20101'

--SELECT maxpermatch180 from custInfo where custid = 8070945
--SELECT maxpermatch180 from custInfo where custid = 8070946
--SELECT maxpermatch180 from custInfo where custid = 8070950
--SELECT minbet,maxbet FROM Dep_CustSetting3rd where custid = 8070945 AND sporttype = 180
--SELECT minbet,maxbet FROM Dep_CustSetting3rd where custid = 8070946 AND sporttype = 180
--SELECT minbet,maxbet FROM Dep_CustSetting3rd where custid = 8070950 AND sporttype = 180
--Acc_Dep_CustomerSelMemberVirtualSports_AgInfo 8070950,180