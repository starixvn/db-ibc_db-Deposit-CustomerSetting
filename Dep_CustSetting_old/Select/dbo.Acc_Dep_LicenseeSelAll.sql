/*<info serverAlias="DBEXT-bodb02" executers="bodbAdminNet,bodbExtAccNet" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_LicenseeSelAll]
AS

/*
	Created by: [20120718@Dom.Cao]
	Task: Get List of all licensee 
	DB: EBEXT.bodb02
   
	Revisions:
		- 20120718@Dom: Initialize SP
*/

SET NOCOUNT ON

SELECT   
    s.siteid LicenseeID, s.[site] LicenseeName  
FROM 
    site s WITH (NOLOCK)  
WHERE s.isLicensee=1
GO