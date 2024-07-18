/*<info serverAlias="DBCUST-CUSTDB" executers="wsv_nap,wsv_alp,wsv_xnap,wsv_lap" viewers="vnteam" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_CustSetting_StakeLevelGroupSelect] 
	@ProductID		INT
	,@CustID		INT		
	,@SettingStatus TINYINT = 0
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
		- 20240429@Tacy: Apply @SettingStatus [RedmineID: #201239]
	Param's Explanation:
*/
BEGIN
	SET NOCOUNT ON

DECLARE @Currency INT, @StakeLevelList VARCHAR(200),@TotalRows		INT
CREATE TABLE #tempAgentStakeLevel (Sporttype INT, bettype INT,StakeLevelID INT,PRIMARY KEY CLUSTERED (SportType, BetType, StakeLevelID))
CREATE TABLE #tempStakeLevel (Sporttype INT, Bettype INT,StakeLevelID INT,StakeLevelGroupID INT,IsChecked BIT,PRIMARY KEY CLUSTERED (SportType, BetType, StakeLevelID))

SELECT @Currency=d.currency
FROM Customer d WITH(NOLOCK)
WHERE d.custid=@CustID

INSERT INTO #tempAgentStakeLevel(Sporttype,bettype,StakeLevelID)
SELECT Sporttype,bettype,CONVERT(INT,ss.value)
FROM Dep_CustStakeLevel_Agent a WITH(NOLOCK)
	CROSS APPLY	STRING_SPLIT(ISNULL(a.StakeLevelList, ''), ',') AS ss
WHERE a.CustID=@CustID

INSERT INTO  #tempStakeLevel (Sporttype , Bettype,StakeLevelID ,StakeLevelGroupID ,IsChecked )
SELECT ft.SportType,ft.BetType,l.StakeLevelID,l.GameGroupID,0
FROM Dep_StakeLevel l WITH(NOLOCK) 
	CROSS APPLY (SELECT f.SportType, f.Bettype
				FROM dbo.f_Dep_CustSetting_SportBetTypeSettingSelect(@ProductID,8,@SettingStatus) f
				WHERE l.GameTypeID=f.BetType)ft
WHERE l.ExchangeID=@Currency
	
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
	
SELECT t.Sporttype,bb.BetType,t.StakeLevelID,t.IsChecked,bb.StakeLevelGroupID,GroupName AS StakeLevelGroupName,bb.StakeLevel,t.Bettype AS bettypeRef
FROM #tempStakeLevel t
INNER JOIN
	(SELECT	
			gg.RefSportType							SportType
		,	slgd.GameTypeID							BetType
		,	gg.GameGroupID							StakeLevelGroupID
		,	slgd.MinLabel + N' - ' + slgd.MaxLabel	StakeLevel
		,	sl.StakeLevelID
		,	gg.GroupName
	FROM		#tempStakeLevel AS sll
	INNER JOIN	dbo.Dep_StakeLevel AS sl WITH (NOLOCK)
			ON	sl.StakeLevelID = sll.StakeLevelID
	INNER JOIN	dbo.GameGroup AS gg WITH (NOLOCK)
			ON	gg.GameGroupID = sl.GameGroupID
	INNER JOIN	dbo.Dep_StakeLevelGroupDetail AS slgd WITH (NOLOCK)
			ON	slgd.StakeLevelID = sl.StakeLevelID
	) bb
	ON t.StakeLevelID=bb.StakeLevelID
	
END
GO