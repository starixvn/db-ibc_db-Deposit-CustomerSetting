ALTER PROCEDURE Acc_Dep_CustomerSelMemberVirtualSports_Com 
	@custid INT,
	@SportType INT
AS

 /*
Created: 20120828@Dom
Task : Company get super info to edit
DB: DB052.bodb02

Revisions:
    
Param's Explanation:
• @CustID: member ID
*/
SET NOCOUNT ON

DECLARE @UserName NVARCHAR(50),
		@MinBet MONEY,
		@MaxBet MONEY,
		@MaxPerMatch MONEY,
		@sPositionTaking SMALLMONEY,
		@DisableVirtualSports BIT
SELECT ci.username, maxpermatch180 AS maxpermatch,DisableVirtualSports, minbet,maxbet,spositiontaking
FROM custinfo ci WITH (NOLOCK)
	INNER JOIN dep_custsetting3rd cs3 WITH(NOLOCK) ON cs3.custid = ci.custid
WHERE ci.custid = @custid
AND cs3.sporttype = @SportType

GO
GRANT EXECUTE ON [dbo].[Acc_Dep_CustomerSelMemberVirtualSports_Com] TO [bodbadminNet]
GO
GRANT VIEW DEFINITION ON [dbo].[Acc_Dep_CustomerSelMemberVirtualSports_Com] TO [vnteam]
Go