/*<info serverAlias="DBCUST-CUSTDB" executers="wsv_nap,wsv_lap" viewers="" isFunction="0"></info>*/
CREATE PROCEDURE dbo.Acc_Dep_CustSetting_ChargeCommSelect 
	  @CustID		INT
	, @ProductID	TINYINT
	, @SettingStatus TINYINT = 0
AS
/*
	Created: 20240429@Tacy
	Task: Select Customer's comm
	DB: DBCUST/CustDB

	Revision:
		- 20240429@Tacy: Licensee DCS Setting - Integrate Exchange [RedmineID: #201239]

	Param's Explanation:
	
	*/
BEGIN
	SET NOCOUNT ON;

	CREATE TABLE #SportBettypeFilter (productID INT,SportType INT,Bettype INT,IsLive BIT)
	
	INSERT INTO #SportBettypeFilter (productID,SportType,Bettype,IsLive)
	SELECT ProductID, SportType,Bettype,IsLive 
	FROM dbo.f_Dep_CustSetting_SportBetTypeSettingSelect(@ProductID,5,@SettingStatus)
	
	IF EXISTS (SELECT 1 
				FROM #SportBettypeFilter ft 
				INNER JOIN dbo.Dep_CustDiscountSetting_Agent bl WITH (NOLOCK) ON ft.SportType = bl.sporttype AND ft.Bettype=bl.BetType
				WHERE CustID=@CustID)
	BEGIN
			SELECT  ft.Sporttype, ft.bettype, Discount
			FROM 	#SportBettypeFilter ft 
			INNER JOIN dbo.Dep_CustDiscountSetting_Agent bl WITH (NOLOCK) ON ft.SportType = bl.sporttype AND ft.Bettype=bl.BetType
			WHERE CustID=@CustID
	END
	ELSE
			SELECT  ft.Sporttype, ft.bettype, 0 as Discount 
			FROM 	#SportBettypeFilter ft 
END
GO