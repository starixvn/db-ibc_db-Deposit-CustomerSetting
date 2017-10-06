/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet,bodbExtAccNet,bodbDownlineNet,bodbLicenseeNet" viewers="vnteam" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_CustSetting_PositionTakingSettingSelect] 
	  @CustID		INT
	, @ProductID	TINYINT
AS
/*
	Created: 20170925@Winnie
	Task: Check Customer's PT
	DB: DBCUST/CustDB
	Original:
	Revision:
		
	Param's Explanation:
	
	*/
BEGIN
	CREATE TABLE #SportBettypeFilter (productID INT,SportType SMALLINT,Bettype SMALLINT,IsLive BIT)
	
	INSERT INTO #SportBettypeFilter (productID,SportType,Bettype,IsLive)
	SELECT DISTINCT ProductID, SportType,Bettype,IsLive FROM dbo.ProductSettingDetail WITH(NOLOCK)
	WHERE ProductID = @ProductID AND SettingType=1
	
	IF EXISTS (SELECT TOP 1 1 
			FROM 	#SportBettypeFilter ft 
			INNER JOIN dbo.Dep_CustPTSetting_Agent bl WITH (NOLOCK) ON ft.SportType = bl.sporttype AND ft.BetType = bl.bettype 
			WHERE CustID=@CustID  )
	BEGIN
	
			SELECT DISTINCT SuperPT 
			FROM 	#SportBettypeFilter ft 
			INNER JOIN dbo.Dep_CustPTSetting_Agent bl WITH (NOLOCK) ON ft.SportType = bl.sporttype AND ft.BetType = bl.bettype 
			WHERE CustID=@CustID  
	END
	ELSE
			SELECT 0 AS SuperPT 
END

GO

