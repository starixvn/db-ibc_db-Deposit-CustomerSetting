/*<info serverAlias="DBCUST-CustDB" executers="wsv_nap" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_CurrencySel]
	@UserID INT = NULL,
	@Mode	TINYINT = 0	-- 0: All, 1 : Credit, 2 :Deposit
AS
/*
	Create: 20131014@Francis
	Task: Select all currencies without unsed and overlapped ones.
	DB: DBCUST-CustDB
	Revisions:
		- 20140214@Francis: Add currencies with exchangeid = 27, 28
		- 20150918@Francis: Add currency with exchangeid = 13 
		- 20160315@Winnie: Add MKK
		- 20170327@Elodie: Add HK$ [Redmine: #74110]
		- 20180323@Johnson: Exclude list currencies not use [Redmine: #92611]
		- 20200826@Winfred: Hide Inactive , OfferSite Currency [Redmine: #140084]
		- 20240424@Tacy: NAP - Permission controls on real currency [redmineID: #202523]
		- 20240725@Tacy: Remove linked-server/cross-db on NAP_UserControl and move to DBCUST [redmineID: #208402]

*/
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @tmpExchange TABLE (exchangeID INT, Currency NVARCHAR(50), OfferSite TINYINT)

	--get deny currency
	INSERT INTO  @tmpExchange (exchangeID, Currency, OfferSite)
	SELECT exchangeID, Currency, OfferSite 
	FROM NAP_UserControl.dbo.f_GetDeniedCurrencyByUser (@UserID)
	WHERE @UserID IS NOT NULL

    SELECT exchangeid, code, currency 
	FROM exchange  WITH (NOLOCK)
	WHERE 
		((@Mode = 0  AND exchangeid not in (16,17,21,22,27,28,31,33,34,35,36,37,40,42,43,44,47,48,50,62))
			OR (@Mode <> 0 AND OfferSite in (0,@Mode))) 	
		AND IsActive = 1
		AND ExchangeId NOT IN (SELECT exchangeID FROM @tmpExchange)
END
GO