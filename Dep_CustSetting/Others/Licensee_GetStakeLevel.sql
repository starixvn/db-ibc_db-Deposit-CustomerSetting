/*<info serverAlias="DBACC-bodb02" executers="Dot_Intg" executers="vnteam" isFunction="0"></info>*/
CREATE PROCEDURE [dbo].[Licensee_GetStakeLevel]
	(
      @Site NVARCHAR(100) = NULL,
      @Currency INT = 0,
	  @Products NVARCHAR(200) = 'Allbet'
	)
AS
/*
	Created by: 20180928@Chris
	Task : Return Licensee Stake Level - support Allbet only [Redmine: #102270]
	DB: DB06.bodb02
	Original: 
	Revisions:	
		- 20180928@Chris: Return Licensee Stake Level - support Allbet only [Redmine: #102270]
	Param's Explanation:  
	  + @Site		: licensee site name  
	  +	@Currency	:
			0  : selected all currencies 
	  + @products	: products list. It should be no spacing between products. For example: 'Allbet,Macau Games,PP'
			
*/
BEGIN
	SET NOCOUNT ON  

	CREATE TABLE #Products (ProductID INT, ProductName NVARCHAR(100), Sporttype INT, Bettype INT)
	
	--get sporttype, bettype	
	INSERT INTO  #Products (ProductID, ProductName, Sporttype , Bettype)
	SELECT p.ProductID, p.ProductName, sbm.SportType, sbm.BetType 
	FROM dbo.Products p WITH (NOLOCK)
	INNER JOIN dbo.SportBettypeMatrix sbm WITH (NOLOCK) ON p.ProductID = sbm.ProductID
	WHERE p.ProductName IN (select val from dbo.strSplit(ISNULL(@Products, ''), ',') AS ss)

	--Allbet product
	SELECT  ds.username
			,ds.site
			,p.ProductName
			,[StakeLevelID]
			,[GameTypeID]
			,[GameGroupID]
			,[MinLabel]
			,[MaxLabel]
			,[MinStake]
			,[MaxStake]
			,[ExchangeID]
			,[ResourceId]
			,d.[SiteID]
	FROM dbo.Dep_StakeLevel d WITH(NOLOCK)
	INNER JOIN dbo.Site WITH (NOLOCK) ON Site.siteid = d.SiteID
	INNER JOIN dbo.Dep_CustSuper ds WITH (NOLOCK) ON ds.site = Site.site AND ds.currency = d.ExchangeID
	INNER JOIN #Products p WITH (NOLOCK) ON p.Bettype = d.GameTypeID
	WHERE ds.site in (@Site)
	AND (@Currency = 0 OR (@Currency <> 0 AND ds.Currency = @Currency))
	ORDER BY p.ProductID, d.ExchangeID, d.GameTypeID, d.StakeLevelID
	
	DROP TABLE #Products
END