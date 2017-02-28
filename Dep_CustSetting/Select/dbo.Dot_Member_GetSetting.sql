ALTER PROCEDURE [dbo].[Dot_Member_GetSetting]
	@custid int,
	@isLicensee bit = 0
AS
/*
	REVISIONS:
		- 20120424@Kiwi: Change to use Dep_CustSetting
*/

	IF (@isLicensee = 1)
	BEGIN		
		SELECT maxbet 
		FROM Dep_CustSetting (nolock)
		WHERE custid = @custid AND sporttype = 1 AND bettype = 1
	END
	ELSE
	BEGIN		
		SELECT maxbet 
		FROM custsetting (nolock)
		WHERE custid = @custid AND sporttype = 1 AND bettype = 1
	END
GO
GRANT VIEW DEFINITION ON [dbo].[Dot_Member_GetSetting] TO [vnteam]