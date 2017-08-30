/*
	Created: 20170830@Helen
	Task: https://nexdev.net/issues/82347
	DB: DB06/bodb02
*/  
USE bodb02
GO
SELECT MAX(custid) 
FROM custinfo  WITH (NOLOCK)