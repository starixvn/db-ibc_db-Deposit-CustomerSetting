/*<info serverAlias="DBCUST-CUSTDB" executers="wsv_nap,wsv_lap" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE dbo.Acc_Dep_CustSetting_ChargePTSelect
	  @CustID		INT
	, @ProductID	TINYINT
	, @SettingStatus TINYINT = 0
AS
/*
	Created: 20240429@Tacy
	Task: Select Customer's PT
	DB: DBCUST/CustDB

	Revision:
		- 20240429@Tacy: Licensee DCS Setting - Integrate Exchange [RedmineID: #201239]

	Param's Explanation:
	
	*/
BEGIN
	SET NOCOUNT ON;

	DECLARE @curDate DATE

	SET @curDate = CAST(GETDATE() AS DATE)

	CREATE TABLE #SportBettypeFilter (productID INT,SportType INT,Bettype INT,IsLive BIT)
	
	INSERT INTO #SportBettypeFilter (productID,SportType,Bettype,IsLive)
	SELECT ProductID, SportType,Bettype,IsLive 
	FROM dbo.f_Dep_CustSetting_SportBetTypeSettingSelect(@ProductID,18,@SettingStatus)
	
	IF EXISTS (SELECT 1 
				FROM #SportBettypeFilter ft 
				INNER JOIN dbo.Dep_ChargeInfoSetting ds WITH (NOLOCK) ON ft.SportType = ds.sporttype
				WHERE CustID=@CustID AND @curDate < ToDate AND ds.isDeleted=0)
	BEGIN
			SELECT  ft.Sporttype, PT
			FROM 	#SportBettypeFilter ft 
			INNER JOIN dbo.Dep_ChargeInfoSetting ds WITH (NOLOCK) ON ft.SportType = ds.sporttype
			WHERE CustID=@CustID AND @curDate < ToDate AND ds.isDeleted=0
	END
	ELSE
			SELECT  ft.Sporttype,  0 as PT 
			FROM 	#SportBettypeFilter ft 
END
GO

