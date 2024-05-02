/*<info serverAlias="DBCUST-CUSTDB" executers="wsv_nap" viewers="vnteam" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_SelDCSProduct]	
AS 
/*	Created by: [Winnie] 
	Date: 20170922
	Task: 
	DB: DBCUST.CUSTDB

	Revisions:		
	- 20170922@Winnie: Licensee - select dcs product [RedmineID: #82346]
	- 20171113@Winnie: Update Customer's Stake Level Settings - [Redmine: #85113]	
	- 20220826@Winfred: Hide Sportbook 2 in Product drop down list [redmine:#177081]
	Param's Explanation:
*/

BEGIN
	SET NOCOUNT ON

	SELECT  s.ProductID,p.ProductName,s.SettingType			
	FROM [Dep_ProductSetting] s WITH(NOLOCK) 
		INNER JOIN Dep_ProductSettingDetail b WITH(NOLOCK) ON s.ProductSettingID=b.ProductSettingID
		INNER JOIN DBEXT.bodb02.dbo.Products p WITH(NOLOCK) ON s.ProductID=p.ProductID
	WHERE p.ProductID<>31 AND SettingType NOT IN(5,9) AND b.SettingStatus <> 2
	UNION 
	SELECT p.ProductID,p.ProductName,0 AS SettingType
	FROM [Dep_ProductSetting] s WITH(NOLOCK) 
		INNER JOIN Dep_ProductSettingDetail b WITH(NOLOCK) ON s.ProductSettingID=b.ProductSettingID
		INNER JOIN DBEXT.bodb02.dbo.Products p WITH(NOLOCK) ON s.ProductID=p.ProductID
	WHERE s.SettingType=7 AND b.SettingStatus <> 2

END
GO
