/*<info serverAlias="DBCUST-CustDB" executers="asv_cust" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[API_AgentBetSetting_Sel]
	  @AgentID INT = NULL
	, @Site VARCHAR(10) = NULL OUTPUT
	, @Currency INT  = NULL OUTPUT
	, @Errcode INT = 0 OUTPUT
	, @ErrMsg VARCHAR(2000) = '' OUTPUT
	, @SettingStatus TINYINT = 0
AS
/*
	Created: 20250206@Eden 
	Task : return bet settings for all products for Agent
	DB:  DBCUST-CustDB
	Original sp: 
	
	Revisions: 
		- 20250206@Eden: Provide API that return bet settings for all products [redmine: #207474] 

	Param's Explanation: 
		
	Steps: 
		Step 1 (get Agent SiteDB): call sp DBGLOB.GlobCustDB.dbo.Acc_Dep_ServerDBConfigSelByCust @CustID = @AgentID
		Step 2 (get Agent Bet Setting):  Call sp API_AgentBetSetting_Sel at right SiteDB to get Bet Setting

	Sample:
		EXEC DBGLOB.GlobCustDB.dbo.Acc_Dep_ServerDBConfigSelByCust @CustID = 36649189

		DECLARE @ErrCode INT = 0 ,
				@ErrMsg NVARCHAR(2000) = '' ,
				@Site VARCHAR(10),
				@Currency INT 
		EXEC [API_AgentBetSetting_Sel]
			 @AgentID	= 36649189 --1176086,36649189
			,@ErrCode	= @ErrCode OUTPUT
			,@ErrMsg	= @ErrMsg OUTPUT
			,@Site		= @Site OUTPUT
			,@Currency	= @Currency OUTPUT
			,@SettingStatus	= 0
		SELECT   @ErrCode	AS ErrCode		
				,@ErrMsg	AS ErrMsg
				,@Site AS Site
				,@Currency AS Currency
*/			   				
BEGIN
	DECLARE @SuperID INT

	SELECT @Site = c.site, 
		@Currency = c.currency,
		@SuperID = d.custid
	FROM customer c WITH(NOLOCK) 
		INNER JOIN site s WITH(NOLOCK) ON c.site = s.site
		INNER JOIN Dep_CustSuper d WITH(NOLOCK) ON c.srecommend = d.custid
	WHERE c.custid = @AgentID
		AND c.roleid = 2

	IF @Site IS NULL
	BEGIN
		SELECT @ErrMsg = 'Invalid AgentId.', 
			@Errcode = 10
		RETURN
	END

	DECLARE @ProductSport TABLE (
		 ProductID			SMALLINT
		,SportType			SMALLINT
		,BetType			SMALLINT
		,SettingType		TINYINT
	)

	INSERT INTO @ProductSport(ProductID,SportType,BetType,SettingType)
	SELECT t.ProductID,t.SportType,t.BetType,t.SettingType
	FROM Dep_LicenseeProductSetting d WITH(NOLOCK) 
		INNER JOIN dbo.f_Dep_CustSetting_SportBetTypeSettingSelect(NULL,NULL,@SettingStatus) t
			ON d.ProductSettingID = t.ProductSettingID
		INNER JOIN Dep_ProductSettingType dt WITH(NOLOCK)
			ON dt.SettingType = t.SettingType
			AND dt.SettingName IN ('Bet Setting')
	WHERE d.CustID = @SuperID 

	 SELECT t.ProductID AS productId    
		  ,c.SportType AS sportType  
		  ,c.BetType AS betType
		  ,c.MinBet AS minBet      
		  ,c.MaxBet AS maxBet      
		  ,c.MaxPerMatch AS maxBetPerMatch    
		  ,NULL AS maxBetPerBall 
		  ,NULL AS maxPayoutPerMatch
	FROM Dep_CustBetSetting_Agent c WITH(NOLOCK) 
		INNER JOIN @ProductSport t 
			ON c.SportType = t.SportType 
			AND c.BetType = t.BetType
			AND t.SettingType NOT IN (10,12)
	WHERE custid = @AgentID
	UNION ALL
	SELECT t.ProductID				
		,c.SportType			
		,c.BetType			
		,c.MinBet				
		,c.MaxBet				
		,c.MaxPerMatch		
		,CASE WHEN t.SettingType = 12 THEN c.MaxPerNumber END
		,CASE WHEN t.SettingType = 10 THEN c.MaxPayoutPerMatch END
	FROM Dep_CustBetSettingGame_Agent c WITH(NOLOCK) 
		INNER JOIN @ProductSport t 
			ON c.SportType = t.SportType 
			AND c.BetType = t.BetType
			AND t.SettingType IN (10,12)
	WHERE custid = @AgentID
	ORDER BY ProductID, SportType, BetType
END
GO
