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
	@maxpermatch151 [money],
	@maxpermatch201 [money],
	@maxpermatch151_OT [money],
	@maxpermatch161 [money],
	@maxpermatch99MP [money],
	@maxpermatch151_AU [money] = null,
	@maxpermatch152_UK [money] = null,
	@maxpermatch152_AU [money] = null,
	@maxpermatch153_AU [money] = null
WITH EXECUTE AS CALLER
AS
/*
Created: 
Task: SET Max Per Match of licensee
DB: DBCUST.CUSTDB
Original:

Revisions:
    - 20110301@Henry: set maxpermatch for new bettype (AU Horse, Harness, Greyhound)
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
		maxpermatch151 = @maxpermatch151,
		maxpermatch201 = @maxpermatch201,
		maxpermatch151_OT = @maxpermatch151_OT,
		maxpermatch161 = @maxpermatch161,
		maxpermatch99MP	= @maxpermatch99MP,
		maxpermatch151_AU = case when @maxpermatch151_AU is null then maxpermatch151_AU else @maxpermatch151_AU end,	
		maxpermatch152_UK = case when  @maxpermatch152_UK is null then maxpermatch152_UK else @maxpermatch152_UK end,	
		maxpermatch152_AU = case when @maxpermatch152_AU is null then maxpermatch152_AU else @maxpermatch152_AU end,	
		maxpermatch153_AU = case when @maxpermatch153_AU is null then maxpermatch153_AU else @maxpermatch153_AU end
	where custid = @custid 
END
