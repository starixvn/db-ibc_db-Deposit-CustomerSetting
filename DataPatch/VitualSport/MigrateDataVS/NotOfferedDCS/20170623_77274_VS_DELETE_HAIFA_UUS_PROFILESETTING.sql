/*
	Created: 20170626@Helen
	Task: insert the Setting of VS of new licensees into the DCS database.
	Redmine: https://redmine.nexcel.vn/issues/77274
	DB: DBTP/BODB02, DB06/BODB02

*/
USE bodb02
GO
DELETE Dep_LicenseeProductSetting 
WHERE custid = 4345449 AND ProductSettingID IN (9,10,11)