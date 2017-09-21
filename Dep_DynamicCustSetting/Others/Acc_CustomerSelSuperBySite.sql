/*<info serverAlias="DBEXT-bodb02" executers="bodbAdminNet" viewers="vnteam" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_CustomerSelSuperBySite]
	@Site varchar(10) = ''
AS 
/*	Created by: [Winnie] 
	Date: 20170921
	Task: 
	DB: DB052.bodb02

	Revisions:		
	20170921@Winnie: Licensee - Edit DCS Bet Setting [RedmineID: #82346]

	Param's Explanation:
*/

BEGIN
	SET NOCOUNT ON
	SELECT username,custid  FROM customer WITH(NOLOCK) WHERE site = @Site AND roleid=4
END
GO
