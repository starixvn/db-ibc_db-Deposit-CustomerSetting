/*<info serverAlias="DBCUST-CUSTDB" executers="asv_cust" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE API_Dep_3rdProductCustStatusSel 
	@AgentId INT
	, @ProductId INT
	, @IsEnabled BIT = 0 OUTPUT  
AS  
/*  
 Created: 20241210@Elodie  
 Task: Get 3rd product status of member  
 DB: DBCUST/CustDB  
 Original:  Dot_Dep_3rdProductSelCustStatus
 Revisions:  
	- 20241210@Elodie: Initial SP [Redmine: #214963]

 Param's Explanation:  
*/  
BEGIN  
	SET NOCOUNT ON  
	DECLARE @srecommend  INT

	IF @ProductId IN (25) --Cashout
	BEGIN		
		SELECT @srecommend = srecommend
		FROM dbo.Customer c WITH (NOLOCK)
		WHERE c.CustID = @AgentId and roleid = 2

		SELECT @IsEnabled = ISNULL(IsEnabled,0)  
		FROM dbo.Dep_SupperProductSetting WITH (NOLOCK)  
		WHERE CustID = @Srecommend AND ProductId = @ProductId
	END	
   
END  
GO
