/*<info serverAlias="DBAGE-bodb02,DBEXT-bodb02" executers="wsv_nap" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_CurrencySel]
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
*/
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

    select exchangeid, code, currency from exchange 
	where 
		(@Mode = 0  AND exchangeid not in (16,17,21,22,27,28,31,33,34,35,36,37,40,42,43,44,47,48,50,62))
		OR (@Mode  = 2 AND IsActive = 1 AND OfferSite in (0,2)) 	
END
GO