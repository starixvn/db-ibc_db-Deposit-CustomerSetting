/*
	Created: 20170831@Helen
	Task: DCS Deposit for Fishing World - [Redmine:82031]
	Redmine: https://nexdev.net/issues/82031
*/  
USE bodb02
GO
SELECT MAX(custid) 
FROM custinfo  WITH (NOLOCK)