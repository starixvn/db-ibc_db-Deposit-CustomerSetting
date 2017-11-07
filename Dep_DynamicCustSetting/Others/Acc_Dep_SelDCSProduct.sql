/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet" viewers="vnteam" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_SelDCSProduct]	
AS 
/*	Created by: [Winnie] 
	Date: 20170922
	Task: 
	DB: DBCUST.CUSTDB

	Revisions:		
	20170922@Winnie: Licensee - select dcs product [RedmineID: #82346]

	Param's Explanation:
*/

BEGIN
	SET NOCOUNT ON

	SELECT  s.ProductID,p.ProductName,s.SettingType			
	FROM [Dep_ProductSetting] s WITH(NOLOCK) 
		INNER JOIN DBEXT.bodb02.dbo.Products p WITH(NOLOCK) ON s.ProductID=p.ProductID
	WHERE p.ProductID<>31 AND SettingType NOT IN(5,9)
END
GO
