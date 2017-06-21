/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet,bodbExtAccNet,bodbDownlineNet,bodbLicenseeNet" viewers="vnteam" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_CustSetting_BetLimitSettingSelect] 
	  @CustID		INT
	, @ProductID	TINYINT
AS
/*
	Created: 20170615@Helen
	Task: Check Customer's Bet Limits
	DB: DBCUST/CustDB
	Original:

	Revision:
		- 20170302@Helen: Betradar Virtual Sports  -Integration for Cash [Redmine: 77274]
		
		
	Param's Explanation:

	
	*/
BEGIN
	
	DECLARE @Currency TINYINT, @RoleID INT
	
	CREATE TABLE #SportBettypeFilter (productID INT,SportType SMALLINT,Bettype SMALLINT,IsLive BIT)
	
	INSERT INTO #SportBettypeFilter (productID,SportType,Bettype,IsLive)
	SELECT  ps.ProductID ProductID, SportType,Bettype,IsLive
	FROM dbo.f_Dep_CustSetting_SportBetTypeSettingSelect(@ProductID,2) AS ps
	
	IF EXISTS (SELECT 1 FROM #SportBettypeFilter)
	BEGIN
	
		SELECT @Currency = Currency, @RoleID = roleid
		FROM dbo.Customer c WITH(NOLOCK)
		WHERE c.custID = @CustID
	
		IF @RoleID IN (2,3,4)
		BEGIN
			SELECT ft.SportType
				, ft.BetType
				, bl.MinBet
				, bl.MaxBet
				, bl.MaxPerMatch
				, pbs.MinBet AS MinBetMin
			FROM #SportBettypeFilter ft 
				INNER JOIN dbo.Dep_CustBetSetting_Agent bl WITH (NOLOCK) ON ft.SportType = bl.sporttype AND ft.BetType = bl.bettype 
				INNER JOIN dbo.Dep_ProductBetSetting pbs WITH (NOLOCK) ON pbs.SportType = bl.sporttype AND pbs.BetType = bl.bettype AND pbs.Currency = @Currency
			WHERE bl.custid = @CustID
		END
		ELSE IF @RoleID = 1
		BEGIN
			SELECT pdt.SportType  
				, pdt.BetType  
				, bl.MinBet  
				, bl.MaxBet  
				, bl.MaxPerMatch  
			FROM #SportBettypeFilter pdt WITH (NOLOCK)  
				INNER JOIN dbo.Dep_CustBetSetting_Member bl WITH (NOLOCK) ON pdt.SportType = bl.sporttype AND pdt.BetType = bl.bettype  
			WHERE bl.custid = @CustID  
				
		END
	END
	
	DROP TABLE #SportBettypeFilter
END

GO
GRANT EXECUTE ON [dbo].[Acc_Dep_CustSetting_BetLimitSettingSelect] TO [bodbadminNet]
GO
GRANT EXECUTE ON [dbo].[Acc_Dep_CustSetting_BetLimitSettingSelect] TO [bodbDownlineNet]
GO
GRANT EXECUTE ON [dbo].[Acc_Dep_CustSetting_BetLimitSettingSelect] TO [bodbExtAccNet]
GO
GRANT EXECUTE ON [dbo].[Acc_Dep_CustSetting_BetLimitSettingSelect] TO [bodbLicenseeNet]


