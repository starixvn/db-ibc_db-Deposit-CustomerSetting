/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet,bodbExtAccNet,bodbDownlineNet,bodbLicenseeNet" viewers="vnteam" isFunction="0"></info>*/
USE CustDB
GO
ALTER PROCEDURE [dbo].[Acc_Dep_CustSetting_StakeLevelGroupSelect] 
	@ProductID		INT
	,@CustID		INT		
	,@ErrCode		INT				= 0		OUTPUT	
	,@ErrMsg		NVARCHAR(200)	= ''	OUTPUT
AS
/*
	Created: 20171107@Winne
	Task: select status of DCS product
	DB: DBCUST/CustDB
	Original:
	Revisions:
		- 20171107@Winnie: select status of DCS product RedmineID:#85133
	Param's Explanation:
*/
BEGIN
	SET NOCOUNT ON

DECLARE @Currency INT, @StakeLevelList VARCHAR(200)
CREATE TABLE #tempAgentStakeLevel (Sporttype INT, bettype INT,StakeLevelID INT,PRIMARY KEY CLUSTERED (SportType, BetType, StakeLevelID))
CREATE TABLE #tempStakeLevel (Sporttype INT, Bettype INT,StakeLevelID INT,StakeLevelGroupID INT,IsChecked BIT,PRIMARY KEY CLUSTERED (SportType, BetType, StakeLevelID))

SELECT @Currency=d.currency
FROM Dep_CustSuper d WITH(NOLOCK)
WHERE d.custid=@CustID

INSERT INTO #tempAgentStakeLevel(Sporttype,bettype,StakeLevelID)
SELECT Sporttype,bettype,CONVERT(INT,ss.val)
FROM Dep_CustStakeLevel_Agent a WITH(NOLOCK)
	CROSS APPLY	dbo.strSplit(ISNULL(a.StakeLevelList, ''), ',') AS ss
WHERE a.CustID=@CustID

INSERT INTO  #tempStakeLevel (Sporttype , Bettype,StakeLevelID ,StakeLevelGroupID ,IsChecked )
SELECT s.SportType,s.BetType,l.StakeLevelID,l.GameGroupID,0
FROM Dep_StakeLevel l WITH(NOLOCK) 
	INNER JOIN	Dep_ProductSettingDetail s WITH(NOLOCK) ON l.GameTypeID=s.BetType
	INNER JOIN	Dep_ProductSetting  d WITH(NOLOCK) ON s.ProductSettingID=d.ProductSettingID
WHERE l.ExchangeID=@Currency AND d.ProductID=@ProductID AND d.SettingType=8

	
IF(@@ROWCOUNT=0)
BEGIN	
	SELECT @ErrCode=100
	SELECT @ErrMsg='Don''t have global bet limit'
	RETURN
END

UPDATE ts
SET ts.IsChecked=1
FROM #tempStakeLevel ts
	INNER JOIN #tempAgentStakeLevel ta ON ts.StakeLevelID=ta.StakeLevelID AND ts.Sporttype=ta.Sporttype AND ts.Bettype=ta.bettype
	
SELECT t.Sporttype,t.Bettype,t.StakeLevelID,t.IsChecked
FROM #tempStakeLevel t
	
END
GO