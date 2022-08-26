/*<info serverAlias="DBCUST-CUSTDB" executers="Dot_Admin,Dot_Member" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Dot_Dep_CustomerSelMemBetSetting_DCS]  
	@CustID INT,
	@Sporttype SMALLINT,
	@Bettype SMALLINT
AS  
/*  
	Created: 20170901@Elodie
	Task : Get min/max bet of member/agent
	DB: DBCUST/CustDB
	User: API Licensee  

	Revisions:  
		- 20170901@Elodie: first commit
		- 20220415@Eden: Deposit - Sportsbook - Revise customer settings [Redmine: #167898]

	Param's Explanation:  

	Excution sample: EXEC Dot_Dep_CustomerSelMemBetSetting_DCS @CustID = 778038, @Sporttype = 180, @Bettype = 1201
*/  
BEGIN
	SET NOCOUNT ON  

	DECLARE @RoleID TINYINT
	DECLARE   
		 @MinBet_Min MONEY,   
		 @MaxBet_Max MONEY,   
		 @MaxPerMatch_Min MONEY,   
		 @MaxPerMatch_Max MONEY

	SELECT @RoleID = roleid FROM dbo.custInfo WITH (NOLOCK) WHERE custid = @CustID
               
	IF @RoleID = 1
	BEGIN
		SELECT   
			 @MinBet_Min = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END),  
			 @MaxBet_Max = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END),
			 @MaxPerMatch_Min = 0,
			 @MaxPerMatch_Max = MIN(CASE WHEN cs.MaxPerMatch = 0 THEN NULL ELSE cs.MaxPerMatch END)
		FROM  
			 dbo.Dep_CustBetSetting_Agent AS cs WITH (NOLOCK)  
				INNER JOIN dbo.custinfo AS ci WITH (NOLOCK) ON (cs.custid = ci.recommend OR cs.custid = ci.mrecommend OR cs.custid = ci.srecommend) AND cs.sporttype = @Sporttype AND cs.bettype = @Bettype  			 
		WHERE ci.custid = @CustID 

		SELECT       
			ci.custid,       
			ISNULL(cs.minbet, 0) AS MinBet,      
			ISNULL(cs.maxbet, 0) AS MaxBet,  
			ISNULL(cs.maxpermatch, 0) AS MaxPerMatch,     		
  
			ISNULL(@MinBet_Min, 0) AS MinBet_Min,      
			ISNULL(@MaxBet_Max, 0) AS MaxBet_Max,      
			ISNULL(@MaxPerMatch_Min, 0) AS MaxPerMatch_Min,      
			ISNULL(@MaxPerMatch_Max, 0) AS MaxPerMatch_Max       
		FROM       
			 dbo.CustInfo ci WITH (NOLOCK)    
			 INNER JOIN dbo.Dep_CustBetSetting_Member cs WITH (NOLOCK) ON ci.custid = cs.custid      
		WHERE ci.custid = @CustID AND cs.sporttype = @Sporttype AND cs.bettype = @Bettype  			 
	END
	ELSE
	BEGIN
		SELECT   
			 @MinBet_Min = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END),  
			 @MaxBet_Max = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END),
			 @MaxPerMatch_Min = 0,
			 @MaxPerMatch_Max = MIN(CASE WHEN cs.MaxPerMatch = 0 THEN NULL ELSE cs.MaxPerMatch END)
		FROM  
			 dbo.Dep_CustBetSetting_Agent AS cs WITH (NOLOCK)
				INNER JOIN dbo.custinfo AS ci WITH (NOLOCK) ON (cs.custid = ci.recommend OR cs.custid = ci.mrecommend OR cs.custid = ci.srecommend) AND cs.sporttype = @Sporttype AND cs.bettype = @Bettype AND cs.custID <> @CustID			 
		WHERE ci.custid = @CustID     
		
		SELECT       
			ci.custid,       
			ISNULL(cs.minbet, 0) AS MinBet,      
			ISNULL(cs.maxbet, 0) AS MaxBet,  
			ISNULL(cs.maxpermatch, 0) AS MaxPerMatch,     		
  
			ISNULL(@MinBet_Min, 0) AS MinBet_Min,      
			ISNULL(@MaxBet_Max, 0) AS MaxBet_Max,      
			ISNULL(@MaxPerMatch_Min, 0) AS MaxPerMatch_Min,      
			ISNULL(@MaxPerMatch_Max, 0) AS MaxPerMatch_Max       
		FROM       
			 dbo.CustInfo ci WITH (NOLOCK)    
			 INNER JOIN dbo.Dep_CustBetSetting_Agent cs WITH (NOLOCK) ON ci.custid = cs.custid      
		WHERE ci.custid = @CustID AND cs.sporttype = @Sporttype AND cs.bettype = @Bettype  			     
	END
END
GO

