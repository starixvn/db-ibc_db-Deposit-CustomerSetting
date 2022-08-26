/*<info serverAlias="DBCUST-CUSTDB" executers="Dot_Admin,Dot_Member" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Dot_Dep_CustomerSelMemBetSettingGame_DCS]  
	@CustID INT,
	@Sporttype SMALLINT,
	@Bettype SMALLINT
AS  
/*  
	Created: 20220415@Eden
	Task : Get min/max bet of member/agent - use for SB/NG
	DB: DBCUST/CustDB
	User: API Licensee  

	Revisions:  
		- 20220415@Eden: Deposit - Sportsbook - Revise customer settings [Redmine: #167898] 

	Param's Explanation:  

	Excution sample: 
	EXEC Dot_Dep_CustomerSelMemBetSettingGame_DCS @CustID = 60902493, @Sporttype = 1, @Bettype = 1
*/  
BEGIN
	SET NOCOUNT ON  

	DECLARE @RoleID TINYINT, @recommend INT, @mrecommend INT, @srecommend INT, @IsGroupedBetLimit BIT
	DECLARE @MinBet_Min MONEY,   
		 @MaxBet_Max MONEY,   
		 @MaxPerMatch_Min MONEY,   
		 @MaxPerMatch_Max MONEY,
		 @MaxPerNumber_Max MONEY,
		 @MaxPayoutPerMatch_Max MONEY	 

	SELECT @RoleID = ci.roleid, 
		@recommend = ci.recommend,
		@mrecommend = ci.mrecommend,
		@srecommend = ci.srecommend
	FROM dbo.custInfo ci WITH (NOLOCK) 
	WHERE custid = @CustID

	SELECT  @MinBet_Min = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END),  
			@MaxBet_Max = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END),
			@MaxPerMatch_Min = 0,
			@MaxPerMatch_Max = MIN(CASE WHEN cs.MaxPerMatch = 0 THEN NULL ELSE cs.MaxPerMatch END),
			@MaxPerNumber_Max = MIN(CASE WHEN cs.MaxPerNumber = 0 THEN NULL ELSE cs.MaxPerNumber END),
			@MaxPayoutPerMatch_Max = MIN(CASE WHEN cs.MaxPayoutPerMatch = 0 THEN NULL ELSE cs.MaxPayoutPerMatch END)
	FROM  dbo.Dep_CustBetSettingGame_Agent AS cs WITH (NOLOCK)  
	WHERE cs.sporttype = @Sporttype 
		AND cs.bettype = @Bettype  
		AND cs.custid IN (@recommend,@mrecommend,@srecommend)
		AND cs.custid <> @CustID
               
	IF @RoleID = 1
	BEGIN
		SELECT @IsGroupedBetLimit = IsGroupedBetLimit FROM Dep_CustSettingMode WITH(NOLOCK) WHERE CustID = @CustID

		IF @IsGroupedBetLimit = 1
		BEGIN
			SELECT       
				@custid AS custid,       
				ISNULL(cs.minbet, 0) AS MinBet,      
				ISNULL(cs.maxbet, 0) AS MaxBet,  
				ISNULL(cs.maxpermatch, 0) AS MaxPerMatch,
				ISNULL(cs.MaxPerNumber, 0) AS MaxPerNumber,  
				ISNULL(cs.MaxPayoutPerMatch, 0) AS MaxPayoutPerMatch,       		
  
				ISNULL(@MinBet_Min, 0) AS MinBet_Min,      
				ISNULL(@MaxBet_Max, 0) AS MaxBet_Max,      
				ISNULL(@MaxPerMatch_Min, 0) AS MaxPerMatch_Min,      
				ISNULL(@MaxPerMatch_Max, 0) AS MaxPerMatch_Max,
				ISNULL(@MaxPerNumber_Max, 0) AS MaxPerNumber_Max,
				ISNULL(@MaxPayoutPerMatch_Max, 0) AS MaxPayoutPerMatch_Max     
			FROM  dbo.Dep_CustBetSettingGameGroup_Member cs WITH (NOLOCK)   
			WHERE cs.AgentID = @recommend AND cs.sporttype = @Sporttype AND cs.bettype = @Bettype 
		END 
		ELSE
		BEGIN
			SELECT       
				@custid AS custid,       
				ISNULL(cs.minbet, 0) AS MinBet,      
				ISNULL(cs.maxbet, 0) AS MaxBet,  
				ISNULL(cs.maxpermatch, 0) AS MaxPerMatch,
				ISNULL(cs.MaxPerNumber, 0) AS MaxPerNumber,  
				ISNULL(cs.MaxPayoutPerMatch, 0) AS MaxPayoutPerMatch,       		
  
				ISNULL(@MinBet_Min, 0) AS MinBet_Min,      
				ISNULL(@MaxBet_Max, 0) AS MaxBet_Max,      
				ISNULL(@MaxPerMatch_Min, 0) AS MaxPerMatch_Min,      
				ISNULL(@MaxPerMatch_Max, 0) AS MaxPerMatch_Max,
				ISNULL(@MaxPerNumber_Max, 0) AS MaxPerNumber_Max,
				ISNULL(@MaxPayoutPerMatch_Max, 0) AS MaxPayoutPerMatch_Max     
			FROM  dbo.Dep_CustBetSettingGame_Member cs WITH (NOLOCK)   
			WHERE cs.custid = @CustID AND cs.sporttype = @Sporttype AND cs.bettype = @Bettype 
		END 			 
	END
	ELSE
	BEGIN
		SELECT       
			@custid AS custid,       
			ISNULL(cs.minbet, 0) AS MinBet,      
			ISNULL(cs.maxbet, 0) AS MaxBet,  
			ISNULL(cs.maxpermatch, 0) AS MaxPerMatch,
			ISNULL(cs.MaxPerNumber, 0) AS MaxPerNumber,  
			ISNULL(cs.MaxPayoutPerMatch, 0) AS MaxPayoutPerMatch,       		
  
			ISNULL(@MinBet_Min, 0) AS MinBet_Min,      
			ISNULL(@MaxBet_Max, 0) AS MaxBet_Max,      
			ISNULL(@MaxPerMatch_Min, 0) AS MaxPerMatch_Min,      
			ISNULL(@MaxPerMatch_Max, 0) AS MaxPerMatch_Max,
			ISNULL(@MaxPerNumber_Max, 0) AS MaxPerNumber_Max,
			ISNULL(@MaxPayoutPerMatch_Max, 0) AS MaxPayoutPerMatch_Max     
		FROM  dbo.Dep_CustBetSettingGame_Agent cs WITH (NOLOCK)   
		WHERE cs.custid = @CustID AND cs.sporttype = @Sporttype AND cs.bettype = @Bettype  			     
	END
END
GO

