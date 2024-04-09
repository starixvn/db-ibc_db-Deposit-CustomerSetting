/*<info serverAlias="DBCUST-CUSTDB" executers="Dot_Admin,Dot_Member,svc_tig" viewers="" isFunction="0"></info>*/
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
		- 20240315@Elodie: Tuning SP [Redmine: #199517]
	Param's Explanation:  

	Excution sample: EXEC Dot_Dep_CustomerSelMemBetSetting_DCS @CustID = 778038, @Sporttype = 180, @Bettype = 1201
*/  
BEGIN
	SET NOCOUNT ON  

	DECLARE @RoleID TINYINT, @srecommend INT, @mrecommend INT, @recommend INT
	DECLARE   
		 @MinBet_Min MONEY,   
		 @MaxBet_Max MONEY,   
		 @MaxPerMatch_Min MONEY,   
		 @MaxPerMatch_Max MONEY

	SELECT @RoleID = roleid, @srecommend = srecommend, @mrecommend = mrecommend, @recommend = recommend FROM dbo.custInfo WITH (NOLOCK) WHERE custid = @CustID
               
	IF @RoleID = 1
	BEGIN
		SELECT   
			 @MinBet_Min = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END),  
			 @MaxBet_Max = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END),
			 @MaxPerMatch_Min = 0,
			 @MaxPerMatch_Max = MIN(CASE WHEN cs.MaxPerMatch = 0 THEN NULL ELSE cs.MaxPerMatch END)
		FROM  
			 dbo.Dep_CustBetSetting_Agent AS cs WITH (NOLOCK)  
		WHERE cs.custid IN (@srecommend, @mrecommend, @recommend)
			AND cs.sporttype = @Sporttype AND cs.bettype = @Bettype  	

		SELECT       
			cs.custid,       
			ISNULL(cs.minbet, 0) AS MinBet,      
			ISNULL(cs.maxbet, 0) AS MaxBet,  
			ISNULL(cs.maxpermatch, 0) AS MaxPerMatch,     		
  
			ISNULL(@MinBet_Min, 0) AS MinBet_Min,      
			ISNULL(@MaxBet_Max, 0) AS MaxBet_Max,      
			ISNULL(@MaxPerMatch_Min, 0) AS MaxPerMatch_Min,      
			ISNULL(@MaxPerMatch_Max, 0) AS MaxPerMatch_Max       
		FROM       
			Dep_CustBetSetting_Member cs WITH (NOLOCK) 
		WHERE cs.custid = @CustID AND cs.sporttype = @Sporttype AND cs.bettype = @Bettype  			 
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
		WHERE cs.custid IN (@srecommend, @mrecommend, @recommend) AND cs.custID <> @CustID		
			AND cs.sporttype = @Sporttype AND cs.bettype = @Bettype  	
		
		SELECT       
			cs.custid,       
			ISNULL(cs.minbet, 0) AS MinBet,      
			ISNULL(cs.maxbet, 0) AS MaxBet,  
			ISNULL(cs.maxpermatch, 0) AS MaxPerMatch,     		
  
			ISNULL(@MinBet_Min, 0) AS MinBet_Min,      
			ISNULL(@MaxBet_Max, 0) AS MaxBet_Max,      
			ISNULL(@MaxPerMatch_Min, 0) AS MaxPerMatch_Min,      
			ISNULL(@MaxPerMatch_Max, 0) AS MaxPerMatch_Max       
		FROM       
			 dbo.Dep_CustBetSetting_Agent cs WITH (NOLOCK)      
		WHERE cs.custid = @CustID AND cs.sporttype = @Sporttype AND cs.bettype = @Bettype  			     
	END
END
GO

