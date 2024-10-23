/*<info serverAlias="DBGLOB-GlobCustDB" executers="asv_cust" viewers="" isFunction="0"></info>*/
CREATE PROCEDURE [dbo].[API_InsOddsAdj_Register]
	@AgentID		INT			,
	@site			VARCHAR(10)		,
	@SiteDBGroupID	SMALLINT		,		
	@username		VARCHAR(30)		= NULL OUTPUT,
	@CustID		INT			= NULL	OUTPUT,
	@ErrCode		INT			= 0		OUTPUT,
	@ErrMsg		NVARCHAR(2000)	= ''		OUTPUT

AS
/*
	Created by: Helios
	Date: 12-08-2024
	Task: Get Useranme , pwd DummyAccount for Spread Adjustment
	DB: DBGLOB/GlobCustDB
	Original:  Dot_Dep_CustomerInsMember_OddAdj
	
	Revisions:
		- 20240812@Helios: Scale out DBCUST - Licensee Customer in GlobCustDB [redmine: #207474] 

	Explanation's Param:
		
*/   
BEGIN

	SELECT @username		= c.site + e.currency + '01OddsAdj' 
	FROM CustInfoMini c WITH(NOLOCK)  
	INNER JOIN exchange e WITH (NOLOCK) ON c.currency = e.ExchangeId
	WHERE c.CustID = @AgentID AND c.roleid = 2


	-- Register Dummy Member Odd Adj
	EXEC API_CustomerIns_Register 
				  @Username			= @username
				, @UplineID			= @AgentID
				, @roleid			= 1
				, @site			= @site
				, @SiteDBGroupID		= @SiteDBGroupID
				, @ErrCode			= @ErrCode	OUT
				, @ErrMsg			= @ErrMsg	OUT
				, @CustID			= @CustID	OUT
END

