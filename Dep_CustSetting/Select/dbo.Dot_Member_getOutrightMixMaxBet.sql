ALTER PROCEDURE [dbo].[Dot_Member_getOutrightMixMaxBet]
	@custid int,
	@isLicensee bit = 0
AS
/*
	REVISIONS:
		- 20120424@Kiwi: Change to use Dep_CustSetting
*/
BEGIN
	SET NOCOUNT ON
	IF (@isLicensee = 1)
	BEGIN
		SELECT IsNull(minbet,0) minbet, IsNull(maxbet,0) maxbet
		FROM Dep_CustSetting with (nolock)
		WHERE custid = @custid AND sporttype = 1 AND bettype = 10
	END
	ELSE
	BEGIN
		SELECT IsNull(minbet,0) minbet, IsNull(maxbet,0) maxbet
		FROM custsetting with (nolock)
		WHERE custid = @custid AND sporttype = 1 AND bettype = 10
	END
	
END
GO
GRANT VIEW DEFINITION ON [dbo].[Dot_Member_getOutrightMixMaxBet] TO [vnteam]