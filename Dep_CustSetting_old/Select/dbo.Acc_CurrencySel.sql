/*<info serverAlias="DBAGE-bodb02,DBEXT-bodb02" executers="wsv_nap" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_CurrencySel]
	@UserID INT = NULL,
	@Mode	TINYINT = 0	-- 0: All, 1 : Credit, 2 :Deposit
AS
/*
	Create: 20131014@Francis
	Task: Select all currencies without unsed and overlapped ones.
	DB: DBEXT.BODB02
	Revisions:
		- 20140214@Francis: Add currencies with exchangeid = 27, 28
		- 20150918@Francis: Add currency with exchangeid = 13 
		- 20160315@Winnie: Add MKK
		- 20170327@Elodie: Add HK$ [Redmine: #74110]
		- 20180323@Johnson: Exclude list currencies not use [Redmine: #92611]
		- 20200826@Winfred: Hide Inactive , OfferSite Currency [Redmine: #140084]
		- 20240424@Tacy: NAP - Permission controls on real currency [redmineID: #202523]
*/
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @tmpExchange TABLE (exchangeID INT, Currency NVARCHAR(50), OfferSite TINYINT)

	DECLARE @SearchCurrency VARCHAR(1024)

	DECLARE @tmpUserid VARCHAR(50)
	SELECT @tmpUserid=CAST(@Userid AS VARCHAR(50))

	--get deny currency
    SELECT @SearchCurrency = 'SELECT * 
	FROM OPENQUERY(DBPOL, 
	''SELECT exchangeID, Currency, OfferSite FROM NAP_UserControl.dbo.f_GetDeniedCurrencyByUser ( ''''' + @tmpUserid + ''''')'')'

	INSERT INTO  @tmpExchange (exchangeID, Currency, OfferSite)
	EXECUTE(@SearchCurrency)

    select exchangeid, code, currency 
	from exchange  with (nolock)
	where 
		((@Mode = 0  AND exchangeid not in (16,17,21,22,27,28,31,33,34,35,36,37,40,42,43,44,47,48,50,62))
		OR (@Mode  = 2  AND OfferSite in (0,2))) 	
		AND IsActive = 1
		AND (@Userid IS NULL 
				OR (@Userid IS NOT NULL AND ExchangeId NOT IN (SELECT exchangeID FROM @tmpExchange)))
END
GO