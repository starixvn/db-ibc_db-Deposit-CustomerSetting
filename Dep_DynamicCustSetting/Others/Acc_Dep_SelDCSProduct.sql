/*<info serverAlias="DBCUST-CUSTDB" executers="wsv_nap" viewers="vnteam" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_SelDCSProduct]	
	@SettingStatus TINYINT = 0
AS 
/*	Created by: [Winnie] 
	Date: 20170922
	Task: 
	DB: DBCUST.CUSTDB

	Revisions:		
	- 20170922@Winnie: Licensee - select dcs product [RedmineID: #82346]
	- 20171113@Winnie: Update Customer's Stake Level Settings - [Redmine: #85113]	
	- 20220826@Winfred: Hide Sportbook 2 in Product drop down list [redmine:#177081]
	- 20240429@Tacy: Licensee DCS Setting - Integrate Exchange [RedmineID: #201239]
	Param's Explanation:
*/

BEGIN
	SET NOCOUNT ON

	SELECT  ft.ProductID,p.ProductName,ft.SettingType			
	FROM DBEXT.bodb02.dbo.Products p WITH(NOLOCK) 
		CROSS APPLY dbo.f_Dep_CustSetting_SportBetTypeSettingSelect (p.ProductID,NULL,@SettingStatus) ft
	WHERE SettingType NOT IN (9)
	UNION 
	SELECT ft.ProductID,p.ProductName,0 AS SettingType
	FROM DBEXT.bodb02.dbo.Products p WITH(NOLOCK) 
		CROSS APPLY dbo.f_Dep_CustSetting_SportBetTypeSettingSelect (p.ProductID,7,@SettingStatus) ft
END
GO
