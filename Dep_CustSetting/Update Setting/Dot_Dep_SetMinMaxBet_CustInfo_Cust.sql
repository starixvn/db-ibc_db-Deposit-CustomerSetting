/*<info serverAlias="DBCUST-CUSTDB" executers="Dot_Admin, Dot_Member" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Dot_Dep_SetMinMaxBet_CustInfo_Cust]
	@custid [int],
	@maxpermatch [money],
	@maxpermatch2 [money],
	@maxpermatch3 [money],
	@maxpermatch5 [money],
	@maxpermatch8 [money],
	@maxpermatch10 [money],
	@maxpermatch11 [money],
	@maxpermatch12 [money],
	@maxpermatch99 [money],
	@maxpermatch161 [money],
	@maxpermatch1MP [money] = 0,
	@maxpermatch99MP [money]
WITH EXECUTE AS CALLER
AS
/*
Created: 
Task: SET Max Per Match of licensee
DB: DBCUST.CUSTDB
Original:

Revisions:
    - 20110301@Henry: set maxpermatch for new bettype (AU Horse, Harness, Greyhound)
	- 20190909@Eden: 3rd party products - Remove InActive Products Phase 2 [Redmine: #118699]
	- 20200619@Johnson: add Soccer Parlay bet limit [redmine: #135261]
*/

BEGIN
SET NOCOUNT ON
	update custinfo with (rowlock, updlock) set
		maxpermatch = @maxpermatch,
		maxpermatch2 = @maxpermatch2,
		maxpermatch3 = @maxpermatch3,
		maxpermatch5 = @maxpermatch5,
		maxpermatch8 = @maxpermatch8,
		maxpermatch10 = @maxpermatch10,
		maxpermatch11 = @maxpermatch11,
		maxpermatch12 = @maxpermatch12,
		maxpermatch99 = @maxpermatch99,
		maxpermatch161 = @maxpermatch161,
		maxpermatch1MP	= @maxpermatch1MP,
		maxpermatch99MP	= @maxpermatch99MP
	where custid = @custid 
END
