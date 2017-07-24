/*
	Created by: 20170302@Helen
	Task: Betradar Virtual Sports  -Integration for Cash [Redmine: 77274]
	DB: DBLOG / bodb_CustomerLog
*/
USE bodb_CustomerLog
GO
INSERT INTO LogAction (ActionID,ActionTypeID,SPName,ActionNameEN,ActionNameCH,ActionNameCS,ActionNameJP,ActionNameTH,ActionNameKO,IsInternal,ActionNameVI)
VALUES (2046,3,'Acc_Dep_CustSetting_BetLimitUpd'
		,'Update Bet Settings for Deposit Customers for DCS Products'
		,'Update Bet Settings for Deposit Customers for DCS Products'
		,'Update Bet Settings for Deposit Customers for DCS Products'
		,'Update Bet Settings for Deposit Customers for DCS Products'
		,'Update Bet Settings for Deposit Customers for DCS Products'
		,'Update Bet Settings for Deposit Customers for DCS Products'
		,0
		,'Update Bet Settings for Deposit Customers for DCS Products'
		)

GO
INSERT INTO LogAction (ActionID,SPName,ActionNameEN,ActionNameCH,ActionNameCS,ActionNameJP,ActionNameTH,ActionNameKO,IsInternal,ActionNameVI)
VALUES (1163,'Acc_Dep_CustSetting_DisableStatUpd'
		,'Update status for DCS Product for Deposit'
		,'Update status for DCS Product for Deposit'
		,'Update status for DCS Product for Deposit'
		,'Update status for DCS Product for Deposit'
		,'Update status for DCS Product for Deposit'
		,'Update status for DCS Product for Deposit'
		,0
		,'Update status for DCS Product for Deposit'
		)
