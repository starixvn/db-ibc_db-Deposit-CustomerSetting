/*
	Created by: 20170302@Helen
	Task: Betradar Virtual Sports  -Integration for Cash [Redmine: 77274]
	DB: DBLOG / bodb_CustomerLog
*/

USE bodb_CustomerLog
GO
DELETE FROM LogAction WHERE SPName IN ('Acc_Dep_CustSetting_BetLimitUpd','Acc_Dep_CustSetting_DisableStatUpd') AND ActionID IN (2046,2214)
GO
INSERT INTO LogAction (ActionID,ActionTypeID,SPName,ActionNameEN,ActionNameCH,ActionNameCS,ActionNameJP,ActionNameTH,ActionNameKO,IsInternal,ActionNameVI)
VALUES (2046,3,'Acc_Dep_CustSetting_BetLimitUpd'
		,'Update Other Products Bet Setting for customers'
		,'Update Other Products Bet Setting for customers'
		,'Update Other Products Bet Setting for customers'
		,'Update Other Products Bet Setting for customers'
		,'Update Other Products Bet Setting for customers'
		,'Update Other Products Bet Setting for customers'
		,0
		,'Update Other Products Bet Setting for customers'
		)

GO
INSERT INTO LogAction (ActionID,SPName,ActionNameEN,ActionNameCH,ActionNameCS,ActionNameJP,ActionNameTH,ActionNameKO,IsInternal,ActionNameVI)
VALUES (1163,'Acc_Dep_CustSetting_DisableStatUpd'
		,'Enabled/Disabled Other Products status'
		,'Enabled/Disabled Other Products status'
		,'Enabled/Disabled Other Products status'
		,'Enabled/Disabled Other Products status'
		,'Enabled/Disabled Other Products status'
		,'Enabled/Disabled Other Products status'
		,0
		,'Enabled/Disabled Other Products status'
		)


