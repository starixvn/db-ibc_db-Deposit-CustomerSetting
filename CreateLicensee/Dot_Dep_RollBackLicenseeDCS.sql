/*<info serverAlias="DBCUST-CUSTDB" executers="Dot_Member" viewers="" isFunction="0"></info>*/
CREATE PROCEDURE [dbo].[Dot_Dep_RollBackLicenseeDCS] 
		@CustID			INT
		
AS

/*  
 Created: 20190425@Winnie  
 Task: Rollback Licensee
 DB: DBCUST/CustDB  
 Original:  
 Revisions:  	
	20190425@Winnie:  Onebook SiteBuilder RedmineID: #111321
 Param's Explanation: 
 */
BEGIN

					DELETE Dep_CustProductStatus WITH (ROWLOCK) WHERE custId  =@CustID
					DELETE Dep_CustPTSetting_Agent WITH (ROWLOCK) WHERE custId  =@CustID
					DELETE FROM Dep_CustBetSetting_Agent WITH(ROWLOCK) WHERE custId = @CustID		
END