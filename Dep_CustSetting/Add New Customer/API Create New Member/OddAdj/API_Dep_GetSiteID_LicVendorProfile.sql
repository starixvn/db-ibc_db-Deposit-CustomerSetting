/*<info serverAlias="DBCust-SiteConfig" executers="asv_cust" viewers="" isFunction="0"></info>*/
CREATE PROCEDURE [dbo].[API_Dep_GetSiteID_LicVendorProfile]
	@SiteName		VARCHAR(50)   ,
	@SiteId		CHAR(7)	  = '' OUTPUT
AS
/*
	Created by: Helios
	Date: 12-08-2024
	Task: Check SiteID from LicVendorProfile
	DB: DBCust/SiteConfig
	Original: 
	
	Revisions:
		- 20240812@Helios: Scale out DBCUST - Licensee Customer in GlobCustDB [redmine: #207474] 

	Explanation's Param:
		
*/   
BEGIN
	SELECT @SiteId = SiteId 
	FROM dbo.LicVendorProfile WITH (NOLOCK)
	WHERE SiteName = @SiteName
END

