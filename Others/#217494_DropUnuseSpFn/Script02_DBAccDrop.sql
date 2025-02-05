/*<info serverAlias=DBACC-bodb02></info>*/
/*
	Created by: 20250205@Dave
	Task: Drop Unuse SP [RedmineID: #217494]
	DB: DBACC-bodb02
*/
USE bodb02
GO
/*git\db-Deposit-CustomerSetting\Deposit-Customer-Archive\3.SP*/
IF OBJECT_ID('Task_Dep_Customer_Archive_GetDormantCustomer', 'P') IS NOT NULL 
	DROP PROCEDURE dbo.Task_Dep_Customer_Archive_GetDormantCustomer;

