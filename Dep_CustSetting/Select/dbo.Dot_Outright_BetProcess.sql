ALTER PROCEDURE [dbo].[Dot_Outright_BetProcess]
	@custid int,
	@orid int,
	@lang nvarchar(50) = '',
	@isLicensee bit = 0
AS
/*
	REVISIONS:
		- 20120424@Kiwi: Change to use Dep_CustSetting
*/
BEGIN
	SET NOCOUNT ON

	Declare @minbet money, @maxbet money
	
	IF (@isLicensee = 1)
	BEGIN
		SELECT @minbet = IsNull(minbet,0), @maxbet = IsNull(maxbet,0)
		FROM Dep_CustSetting with (nolock)
		WHERE custid = @custid AND sporttype = 1 AND bettype = 10
	END
	ELSE
	BEGIN
		SELECT @minbet = IsNull(minbet,0), @maxbet = IsNull(maxbet,0)
		FROM custsetting with (nolock)
		WHERE custid = @custid AND sporttype = 1 AND bettype = 10
	END

	SELECT o.orid, o.leagueid, o.teamid, o.odds, o.maxbet oddsmaxbet, o.oddsstatus,
		IsNull(@minbet,0) minbet, IsNull(@maxbet,0) maxbet
	FROM outright o with (nolock)
	WHERE
		o.oddsstatus in ('running','suspend','closePrice') AND o.kickofftime > CURRENT_TIMESTAMP
		AND o.orid = @orid
END
GO
GRANT VIEW DEFINITION ON [dbo].[Dot_Outright_BetProcess] TO [vnteam]