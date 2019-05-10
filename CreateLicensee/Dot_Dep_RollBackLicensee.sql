/*<info serverAlias="DBCUST-CUSTDB" executers="Dot_Member" viewers="" isFunction="0"></info>*/
CREATE PROCEDURE [dbo].[Dot_Dep_RollBackLicensee] 
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

					DELETE Dep_CustSetting WITH (ROWLOCK) WHERE custId  =@CustID
					DELETE Dep_CustSetting3rd WITH (ROWLOCK) WHERE custId  =@CustID
					DELETE FROM Dep_CustSuper WITH(ROWLOCK) WHERE custId = @CustID
		
					DELETE CustSettingGame WITH(ROWLOCK) WHERE custid = @CustID
					DELETE CustOverrideGame WITH(ROWLOCK) WHERE custid = @CustID	
					EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
					DELETE Dep_AgentCommRate WITH(ROWLOCK) WHERE custid = @CustID
					DELETE CustGameType WITH(ROWLOCK) WHERE Custid = @custid

END