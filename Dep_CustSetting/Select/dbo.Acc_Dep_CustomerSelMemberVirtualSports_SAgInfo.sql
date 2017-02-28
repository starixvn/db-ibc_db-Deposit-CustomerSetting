ALTER PROCEDURE Acc_Dep_CustomerSelMemberVirtualSports_SAgInfo 
	@custid INT,
	@sporttype INT
AS

 /*
Created: 20120828@Dom
Task : Get Super Agent's info to add Master
DB: DB052.bodb02

Revisions:
    
Param's Explanation:
• @CustID: member ID
*/
SET NOCOUNT ON

select minbet as MinBet_Max,
	maxbet as MaxBet_Min,
	maxpermatch180 as MaxPerMatch_Max,
	mpositiontaking as mPositionTaking_Max
from custinfo ci with (nolock) 
INNER JOIN dep_custsetting3rd cs3 WITH (NOLOCK) ON ci.custid = cs3.custid
where ci.custid = @custid
	and sporttype= @sporttype

GO
GRANT EXECUTE ON [dbo].[Acc_Dep_CustomerSelMemberVirtualSports_SAgInfo] TO [bodbadminNet]
GO
GRANT VIEW DEFINITION ON [dbo].[Acc_Dep_CustomerSelMemberVirtualSports_SAgInfo] TO [vnteam]
