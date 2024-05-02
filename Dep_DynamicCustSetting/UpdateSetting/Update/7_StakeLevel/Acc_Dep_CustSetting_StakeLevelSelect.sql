/*<info serverAlias="DBCUST-CUSTDB" executers="wsv_nap,bodbExtAccNet,bodbDownlineNet,wsv_lap" viewers="vnteam" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_CustSetting_StakeLevelSelect] 
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
		- 20180824@Winnie: Licensee DCS setting - Support insert/edit setting for sub_licensee RedmineID:#88700
		- 20220614@Eden: DBCUST - modify sp syntax to adapt with the SQL Server upgrade to 2019 [Redmine: #171831] 
	Param's Explanation:
*/
BEGIN
	SET NOCOUNT ON

DECLARE @Currency INT,@SiteID INT, @StakeLevelList VARCHAR(200)
CREATE TABLE #tempAgentStakeLevel (Sporttype INT, bettype INT,StakeLevelID INT,PRIMARY KEY CLUSTERED (SportType, BetType, StakeLevelID))
CREATE TABLE #tempStakeLevel (Sporttype INT, Bettype INT,StakeLevelID INT,StakeLevelName NVARCHAR(100),IsChecked BIT,MinStake DECIMAL(19,8),MaxStake DECIMAL(19,8),	PRIMARY KEY CLUSTERED (SportType, BetType, StakeLevelID))

SELECT @Currency=d.currency,@SiteID=s.siteid
FROM Customer d WITH(NOLOCK)
	INNER JOIN Site s WITH(NOLOCK)	 ON d.site=s.site
WHERE d.custid=@CustID

INSERT INTO #tempAgentStakeLevel(Sporttype,bettype,StakeLevelID)
SELECT Sporttype,bettype,CONVERT(INT,ss.value)
FROM Dep_CustStakeLevel_Agent a WITH(NOLOCK)
	CROSS APPLY	STRING_SPLIT(ISNULL(a.StakeLevelList, ''), ',') AS ss
WHERE a.CustID=@CustID

INSERT INTO  #tempStakeLevel (Sporttype , Bettype,StakeLevelID ,StakeLevelName ,IsChecked ,MinStake,MaxStake)
SELECT s.SportType,s.BetType,l.StakeLevelID, l.MinLabel+' - '+l.MaxLabel,0,l.MinStake,l.MaxStake
FROM Dep_StakeLevel l WITH(NOLOCK) 
	INNER JOIN	Dep_ProductSettingDetail s WITH(NOLOCK) ON l.GameTypeID=s.BetType
	INNER JOIN	Dep_ProductSetting  d WITH(NOLOCK) ON s.ProductSettingID=d.ProductSettingID
WHERE l.ExchangeID=@Currency AND l.SiteID=@SiteID AND d.ProductID=@ProductID AND d.SettingType=7
	
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
	
SELECT t.Sporttype,t.Bettype,t.StakeLevelID, t.StakeLevelName AS StakeLevelName,t.IsChecked
FROM #tempStakeLevel t	
ORDER BY Bettype, MaxStake, MinStake	
	
END
GO