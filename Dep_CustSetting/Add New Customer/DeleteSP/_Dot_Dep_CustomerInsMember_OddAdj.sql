/*<info serverAlias="DBCust-CustDB" executers="svc_tig" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Dot_Dep_CustomerInsMember_OddAdj]
	@Custid			INT OUTPUT,
	@Creator		INT,
	@Recommend		INT, -- Real Agent 
	@IP				VARCHAR(15)='',
	@ErrCode		INT = 0 OUTPUT,
	@ErrMsg			NVARCHAR(4000) = '' OUTPUT,
	@Username		VARCHAR(30) OUTPUT
AS
/*
	Created by: Winfred
	Date: 20201005
	Task: Create Member Dummy OddAdj
	DB: DBCust/CustDB
	Original: 
	
	Revisions:
		- 20201005@Winfred: Check OddsAdj dummy customers [redmine:#142952]
		- 20220301@Eden: Deposit - Sportsbook - Revise customer settings [Redmine: #167898] 
		- 20220722@Eden: LAP - Scale Out DBTrans  [redmine: #158293/#175297]

	Explanation's Param:
		
*/   
BEGIN 
	SET NOCOUNT ON
	DECLARE	@Site NVARCHAR(100),	@Userpwd VARCHAR(40)
	
	SELECT @Userpwd = '8058095B7DDB08A608811097E5DB8D'
	
	SELECT @Site  = ci.site,@Username = ci.site+ e.currency + '01OddsAdj' 
	FROM Customer as ci with (NOLOCK) 
	INNER JOIN exchange e with(nolock) on ci.currency = e.ExchangeId
	WHERE ci.custid = @Recommend AND ci.roleid = 2
	-- Check Site offer OddAdj
	DECLARE @IsSiteOffer BIT
	EXEC Acc_Dep_CustomerCheckOddsAdj @Site = @Site, @IsOffer = @IsSiteOffer OUTPUT

	IF @IsSiteOffer = 0
	BEGIN    
		SELECT @ErrMsg = 'The site is not offer OddAdj.', @ErrCode = 111    
		RETURN    
	END  

	EXEC Acc_Dep_CustomerInsMember_Ag
		@custid=@Custid OUTPUT,@creator=@Creator,@username=@Username,@userpwd=@Userpwd,
		@recommend=@Recommend,@IP=@IP,@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT		
	
END
