/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet,bodbExtAccNet,bodbDownlineNet,bodbLicenseeNet" viewers="vnteam" isFunction="0"></info>*/
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
AS
/*
	Created: 20171107@Winne
	Task: select GlobalStakeLevel of DCS product
	DB: DBCUST/CustDB
	Original:
	Revisions:
		- 20171107@Winnie: select GlobalStakeLevel of DCS product RedmineID:#85133
	Param's Explanation:
*/
BEGIN
	SET NOCOUNT ON

DECLARE @Currency INT,@SiteID INT, @StakeLevelList VARCHAR(200)

SELECT @Currency=d.currency,@SiteID=s.siteid
FROM Dep_CustSuper d WITH(NOLOCK)
	INNER JOIN Site s WITH(NOLOCK)	 ON d.site=s.site
WHERE d.custid=@CustID

SELECT DISTINCT l.StakeLevelID, l.GameTypeID,l.MinLabel,l.MaxLabel,l.MinStake,l.MaxStake
FROM Dep_StakeLevel l WITH(NOLOCK) 
	INNER JOIN	Dep_ProductSettingDetail s WITH(NOLOCK) ON l.GameTypeID=s.BetType
	INNER JOIN	Dep_ProductSetting  d WITH(NOLOCK) ON s.ProductSettingID=d.ProductSettingID
WHERE l.ExchangeID=@Currency AND l.SiteID=@SiteID AND d.ProductID=@ProductID AND d.SettingType=7
END	

GO