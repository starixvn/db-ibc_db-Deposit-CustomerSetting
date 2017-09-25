/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet,bodbExtAccNet,bodbDownlineNet,bodbLicenseeNet" viewers="vnteam" isFunction="0"></info>*/
CREATE PROCEDURE [dbo].[Acc_Dep_CustSetting_PositionTakingSettingSelect] 
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
	SELECT  ps.ProductID ProductID, SportType,Bettype,IsLive
	FROM dbo.f_Dep_CustSetting_SportBetTypeSettingSelect(@ProductID,1) AS ps
	
	IF EXISTS (SELECT 1 FROM #SportBettypeFilter)
	BEGIN
	
	SELECT SuperPT 
	FROM 	#SportBettypeFilter ft 
			INNER JOIN dbo.Dep_CustPTSetting_Agent bl WITH (NOLOCK) ON ft.SportType = bl.sporttype AND ft.BetType = bl.bettype 
			WHERE CustID=@CustID  
	END
END

GO

