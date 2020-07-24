/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet,bodbLicenseeNet" viewers="" isFunction="0"></info>*/
CREATE PROCEDURE dbo.Acc_Dep_CustSetting_PositionTakingSettingSelect 
	  @CustID		INT
	, @ProductID	TINYINT
AS
/*
	Created: 20170925@Winnie
	Task: Check Customer's PT
	DB: DBCUST/CustDB
	Original:
	Revision:
		- 20180719@Winnie: Licensee DCS setting - Support insert/edit setting for sub_licensee - Redmine: 88700
	Param's Explanation:
	
	*/
BEGIN
	CREATE TABLE #SportBettypeFilter (productID INT,SportType INT,Bettype INT,IsLive BIT)
	
	INSERT INTO #SportBettypeFilter (productID,SportType,Bettype,IsLive)
	SELECT ProductID, SportType,Bettype,IsLive 
	FROM dbo.f_Dep_CustSetting_SportBetTypeSettingSelect(@ProductID,1)
	
	IF EXISTS (SELECT 1 
			FROM 	#SportBettypeFilter ft 
			INNER JOIN dbo.Dep_CustPTSetting_Agent bl WITH (NOLOCK) ON ft.SportType = bl.sporttype AND ft.BetType = bl.bettype AND ft.IsLive=bl.IsLive
			WHERE CustID=@CustID  )
	BEGIN
	
			SELECT  ft.Sporttype, ft.bettype, ft.IsLive, AgentPT 
			FROM 	#SportBettypeFilter ft 
			INNER JOIN dbo.Dep_CustPTSetting_Agent bl WITH (NOLOCK) ON ft.SportType = bl.sporttype AND ft.BetType = bl.bettype AND ft.IsLive=bl.IsLive
			WHERE CustID=@CustID  
	END
	ELSE
			SELECT  ft.Sporttype, ft.bettype, ft.IsLive,  0 as AgentPT 
			FROM 	#SportBettypeFilter ft 
END
GO

