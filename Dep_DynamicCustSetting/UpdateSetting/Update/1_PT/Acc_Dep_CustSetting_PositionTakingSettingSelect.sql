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
	CREATE TABLE #SportBettypeFilter (productID INT,SportType INT,Bettype INT,IsLive BIT)
	
	INSERT INTO #SportBettypeFilter (productID,SportType,Bettype,IsLive)
	SELECT TOP 1 ProductID, SportType,Bettype,IsLive 
	FROM Dep_ProductSetting ps WITH(NOLOCK) 
		INNER JOIN Dep_ProductSettingDetail d WITH(NOLOCK) ON ps.ProductSettingID=d.ProductSettingID  
	WHERE ProductID = @ProductID AND SettingType=1	
	
	IF EXISTS (SELECT TOP 1 1 
			FROM 	#SportBettypeFilter ft 
			INNER JOIN dbo.Dep_CustPTSetting_Agent bl WITH (NOLOCK) ON ft.SportType = bl.sporttype AND ft.BetType = bl.bettype AND ft.IsLive=bl.IsLive
			WHERE CustID=@CustID  )
	BEGIN
	
			SELECT  SuperPT 
			FROM 	#SportBettypeFilter ft 
			INNER JOIN dbo.Dep_CustPTSetting_Agent bl WITH (NOLOCK) ON ft.SportType = bl.sporttype AND ft.BetType = bl.bettype AND ft.IsLive=bl.IsLive
			WHERE CustID=@CustID  
	END
	ELSE
			SELECT 0 AS SuperPT 
END



GO

