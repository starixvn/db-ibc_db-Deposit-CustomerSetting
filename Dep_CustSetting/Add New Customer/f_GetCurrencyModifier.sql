/*<info serverAlias="DBCUST-CustDB" executers="bodbAdminNet,Dot_member" viewers="" isFunction="1"></info>*/

ALTER FUNCTION f_GetCurrencyModifier
(  
	@CurrencyId INT  
)   
RETURNS SMALLMONEY
AS  
/*  
	Created: 20200203@Elodie  
	DB: DBCUST/CustDB
	Task: Get CurrencyModifier
    
	Revisions:  
		- 20200203@Elodie: Apply Currency Modifier [Redmine:127300]

	Parameters Explanation:  
*/  
  
BEGIN  
	RETURN CASE WHEN @CurrencyId = 13 THEN 0.95 ELSE 1 END
END