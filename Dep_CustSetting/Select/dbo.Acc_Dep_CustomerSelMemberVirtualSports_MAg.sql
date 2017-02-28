ALTER PROCEDURE Acc_Dep_CustomerSelMemberVirtualSports_MAg -- master select agent
	@custid INT,
	@sporttype INT
AS

 /*
Created: 20120828@Dom
Task : Master get Agent info to edit
DB: DB052.bodb02

Revisions:
    
Param's Explanation:
• @CustID: member ID
*/
SET NOCOUNT ON

declare @mrecommend INT,
		@minbet_max money,
		@maxbet_min money,
		@apositiontaking_max smallmoney,
		@maxpermatch_max MONEY
	
select @mrecommend = mrecommend 
from custInfo ci with (NOLOCK) 
where ci.custid = @custid	

select @apositiontaking_max = mpositiontaking
FROM Dep_CustSetting3rd cs3 WITH(NOLOCK) 
where cs3.custid = @mrecommend
AND cs3.sporttype = @sporttype

 SELECT @maxpermatch_max = min( case when cs.maxpermatch180 = 0 then NULL ELSE cs.maxpermatch180 END)
 from 
	custinfo as cs WITH (NOLOCK) 
	INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend)
 where ci.custid = @CustId

select @minbet_max = MAX(CASE WHEN cs3.minbet = 0 THEN NULL ELSE cs3.minbet END),
	@maxbet_min = min( case when cs3.maxbet = 0 THEN NULL ELSE cs3.maxbet END )
from custInfo ci with(NOLOCK) 
inner JOIN Dep_CustSetting3rd cs3 WITH (nolock) ON (cs3.custid = ci.srecommend OR cs3.custid = ci.custid)
where ci.custid = @mrecommend
	AND cs3.sporttype = @sporttype

select minbet,
		maxbet,
		maxpermatch180 AS maxpermatch,
		cs3.apositiontaking,
		@minbet_max AS minbet_max,
		@maxbet_min AS maxbet_min,
		@apositiontaking_max AS apositiontaking_max ,
		@maxpermatch_max AS maxpermatch_max
from custinfo ci with(nolock)
	INNER JOIN Dep_CustSetting3rd cs3 with(nolock) ON ci.custid = cs3.custid
where ci.custid = @custid 
and sporttype = @sporttype

GO
GRANT EXECUTE ON [dbo].[Acc_Dep_CustomerSelMemberVirtualSports_MAg] TO [bodbadminNet]
GO
GRANT VIEW DEFINITION ON [dbo].[Acc_Dep_CustomerSelMemberVirtualSports_MAg] TO [vnteam]
