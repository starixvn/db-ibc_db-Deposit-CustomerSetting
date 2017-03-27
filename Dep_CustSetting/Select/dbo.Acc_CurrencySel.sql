ALTER PROCEDURE [dbo].[Acc_CurrencySel]
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
*/
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

    select exchangeid, code, currency from exchange 
	where 
	code not in (select a.code from (select count(code) as b, code from exchange where Code <> '' group by code having count(code)>=2) a)
	and exchangeid not in (42, 48)
	union
	select exchangeid, code, currency from exchange where code = 'USD' and currency = '$US'
	union
	select exchangeid, code, currency from exchange where code = 'IDR' and currency = 'IN'
	union
	select exchangeid, code, currency from exchange where code = 'JPY' and currency = 'JPY'
	union
	select exchangeid, code, currency from exchange where code = 'KRW' and currency = 'Won'
	union
	select exchangeid, code, currency from exchange where code = 'THB' and currency = 'THB'
	union
	select exchangeid, code, currency from exchange where code = 'THB' and currency = 'TB'
	union
	select exchangeid, code, currency from exchange where code = 'USD' and currency = 'US$'
	union
	select exchangeid, code, currency from exchange where code = '' and currency = 'UUS'
	union 
	select exchangeid, code, currency from exchange where code = 'CNY' and currency = 'RMB' 
	union   
	select exchangeid, code, currency from exchange where code = 'MMK' and currency = 'MKK'
	union   
	select exchangeid, code, currency from exchange where code = 'HKD' and currency = 'HK$'
END
