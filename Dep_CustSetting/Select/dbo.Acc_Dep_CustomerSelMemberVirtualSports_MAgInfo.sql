ALTER PROCEDURE Acc_Dep_CustomerSelMemberVirtualSports_MAgInfo
	@CustId INT,
	@Sporttype INT
AS

/*
Created: 20120828@Dom
Task : Get Master Agent's info to add new agent
DB: DB052.bodb02

Revisions:
    
Param's Explanation:
• @CustID: member ID
*/

 DECLARE @apositiontaking_max SMALLMONEY, @maxpermatch_max money
 
 SELECT @apositiontaking_max=(cs3.mpositiontaking)
 FROM Dep_CustSetting3rd cs3 WITH(NOLOCK)
 WHERE cs3.custid = @CustId
 AND cs3.sporttype = @Sporttype
 
 SELECT @maxpermatch_max = min(CASE WHEN cs.maxpermatch180 = 0 THEN NULL ELSE cs.maxpermatch180 END)
 from 
	custinfo as cs WITH (NOLOCK) 
	INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend)
 where ci.custid = @CustId

 select @maxpermatch_max as maxpermatch_max, 
 	@apositiontaking_max AS apositiontaking_max, 
 	MAX(CASE WHEN cs3.minbet = 0 THEN NULL ELSE cs3.minbet END) as minbet_max,
 	min(CASE WHEN cs3.maxbet = 0 THEN NULL ELSE cs3.maxbet END) as maxbet_min
 from custInfo ci with (nolock)
 inner JOIN Dep_CustSetting3rd cs3 WITH (NOLOCK)
 	ON (ci.mrecommend = cs3.custid OR ci.srecommend = cs3.custid)
 where ci.mrecommend = @CustId
 and sporttype = @Sporttype

GO
GRANT EXECUTE ON [dbo].[Acc_Dep_CustomerSelMemberVirtualSports_MAgInfo] TO [bodbadminNet]
GO
GRANT VIEW DEFINITION ON [dbo].[Acc_Dep_CustomerSelMemberVirtualSports_MAgInfo] TO [vnteam]
go

