CREATE PROCEDURE [dbo].[Acc_Dep_LicenseeSelAll]
AS

/*
	Created by: [20120718@Dom.Cao]
	Task: Get List of all licensee 
	DB: DB052.bodb02
	Revisions:
	
*/

SET NOCOUNT ON

SELECT   
	s.siteid LicenseeID, s.[site] LicenseeName  
FROM 
	site s WITH (NOLOCK)  
WHERE s.isLicensee=1

GO
GRANT EXECUTE ON [dbo].[Acc_Dep_LicenseeSelAll] TO [bodbAdminNet]
GO
GRANT EXECUTE ON [dbo].[Acc_Dep_LicenseeSelAll] TO [bodbExtAccNet]
GO
GRANT VIEW DEFINITION ON [dbo].[Acc_Dep_LicenseeSelAll] TO [vnteam]