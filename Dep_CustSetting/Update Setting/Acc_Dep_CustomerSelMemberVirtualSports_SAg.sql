 ALTER PROCEDURE Acc_Dep_CustomerSelMemberVirtualSports_SAg
	@custid INT,
	@sporttype INT
 AS

 /*
Created: 20120828@Dom
Task : Super get master info to edit
DB: DB052.bodb02

Revisions:
    
Param's Explanation:
• @CustID: member ID
*/
SET NOCOUNT ON

 DECLARE  @srecommend int,
		 @MinBet_Max money,
		 @MaxBet_Min money,
		 @MaxPerMatch_Max money,
		 @mPositionTaking_Max smallmoney

 select @srecommend = srecommend from custInfo with (nolock) where custid = @custid
 select @MinBet_Max = minbet, 
	@MaxBet_Min = maxbet, 
	@MaxPerMatch_Max = maxpermatch180,
	@mPositionTaking_Max = cs3.mpositiontaking 
 from custinfo ci with (NOLOCK) 
 INNER JOIN dep_custsetting3rd cs3 WITH (NOLOCK) ON ci.custid = cs3.custid
 where ci.custid = @srecommend
	AND sporttype = @sporttype

select cs3.minbet,
	cs3.maxbet,
	cs3.mpositiontaking,
	ci.maxpermatch180 as maxpermatch,
	@MinBet_Max as MinBet_Max ,
	@MaxBet_Min as MaxBet_Min,
	@MaxPerMatch_Max as MaxPerMatch_Max,
	@mPositionTaking_Max as mPositionTaking_Max
from custinfo ci with (NOLOCK) 
inner join dep_custsetting3rd cs3 with (NOLOCK) ON ci.custid = cs3.custid
where ci.custid = @custid
	and sporttype = @sporttype


GO
GRANT EXECUTE ON [dbo].[Acc_Dep_CustomerSelMemberVirtualSports_SAg] TO [bodbadminNet]
GO
GRANT VIEW DEFINITION ON [dbo].[Acc_Dep_CustomerSelMemberVirtualSports_SAg] TO [vnteam]
Go