/*<info serverAlias="DBCUST-CUSTDB" executers="wsv_nap,wsv_alp,wsv_xnap,wsv_lap" viewers="vnteam" isFunction="0"></info>*/
USE CustDB
GO
/****** Object:  StoredProcedure dbo.Acc_3rdProductSelSuperStatus    Script Date: 10/09/2017 09:05:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.Acc_3rdProductSelSuperStatus    Script Date: 11/24/2015 9:44:45 AM ******/

ALTER PROCEDURE [dbo].[Acc_Dep_CustSetting_GlobalStakeLevelSelect] 
	@ProductID		INT
	,@CustID		INT		
	,@SettingStatus TINYINT = 0
AS
/*
	Created: 20171107@Winne
	Task: select GlobalStakeLevel of DCS product
	DB: DBCUST/CustDB
	Original:
	Revisions:
		- 20171107@Winnie: select GlobalStakeLevel of DCS product RedmineID:#85133
		- 20240429@Tacy: Apply @SettingStatus [RedmineID: #201239]
	Param's Explanation:
*/
BEGIN
	SET NOCOUNT ON

DECLARE @Currency INT,@SiteID INT, @StakeLevelList VARCHAR(200)

SELECT @Currency=d.currency,@SiteID=s.siteid
FROM Dep_CustSuper d WITH(NOLOCK)
	INNER JOIN Site s WITH(NOLOCK)	 ON d.site=s.site
WHERE d.custid=@CustID

SELECT DISTINCT ISNULL(l.StakeLevelID,0) AS StakeLevelID, ft.BetType AS GameTypeID,ISNULL(l.MinLabel,0) AS MinLabel,ISNULL(l.MaxLabel,0) AS MaxLabel,ISNULL(l.MinStake,0) AS MinStake,ISNULL(l.MaxStake,0) AS MaxStake
FROM dbo.f_Dep_CustSetting_SportBetTypeSettingSelect(@ProductID,7,@SettingStatus) ft
	LEFT JOIN Dep_StakeLevel l ON l.GameTypeID=ft.BetType AND l.ExchangeID=@Currency AND l.SiteID=@SiteID
ORDER BY ft.BetType ASC
END
GO