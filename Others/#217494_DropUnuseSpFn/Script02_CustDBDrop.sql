/*<info serverAlias=DBCUST-CustDB></info>*/
/*
	Created by: 20250205@Dave
	Task: Drop Unuse SP [RedmineID: #217494]
	DB: DBCUST-CustDB
*/
USE CustDB;
GO

/*git\db-Deposit-CustomerSetting\Dep_CustSetting\Add New Customer\DeleteSP*/

IF OBJECT_ID('Acc_CustomerInsDummyTradeCashOut', 'P') IS NOT NULL 
	DROP PROCEDURE dbo.Acc_CustomerInsDummyTradeCashOut;
IF OBJECT_ID('Acc_Dep_CustomerCheckOddsAdj', 'P') IS NOT NULL 
	DROP PROCEDURE dbo.Acc_Dep_CustomerCheckOddsAdj;
IF OBJECT_ID('Acc_Dep_CustomerInsMember_Ag_CheckParam', 'P') IS NOT NULL 
	DROP PROCEDURE dbo.Acc_Dep_CustomerInsMember_Ag_CheckParam;
IF OBJECT_ID('Acc_Dep_CustomerInsMember_Com_CheckParam', 'P') IS NOT NULL 
	DROP PROCEDURE dbo.Acc_Dep_CustomerInsMember_Com_CheckParam;
IF OBJECT_ID('Acc_Dep_CustomerInsMember_MAg_CheckParam', 'P') IS NOT NULL 
	DROP PROCEDURE dbo.Acc_Dep_CustomerInsMember_MAg_CheckParam;
IF OBJECT_ID('Acc_Dep_CustomerInsMember_SAg_CheckParam', 'P') IS NOT NULL 
	DROP PROCEDURE dbo.Acc_Dep_CustomerInsMember_SAg_CheckParam;
IF OBJECT_ID('Acc_Dep_CustomerInsSubsidiaryRollback', 'P') IS NOT NULL 
	DROP PROCEDURE dbo.Acc_Dep_CustomerInsSubsidiaryRollback;
IF OBJECT_ID('Dot_Dep_CustomerInsMember_Ag_Cust', 'P') IS NOT NULL 
	DROP PROCEDURE dbo.Dot_Dep_CustomerInsMember_Ag_Cust;
IF OBJECT_ID('Dot_Dep_CustomerInsMember_Ag_Cust_Main', 'P') IS NOT NULL 
	DROP PROCEDURE dbo.Dot_Dep_CustomerInsMember_Ag_Cust_Main;
IF OBJECT_ID('Dot_Dep_CustomerInsMember_Ag_Cust_Switch', 'P') IS NOT NULL 
	DROP PROCEDURE dbo.Dot_Dep_CustomerInsMember_Ag_Cust_Switch;
IF OBJECT_ID('Dot_Dep_CustomerInsMember_OddAdj', 'P') IS NOT NULL 
	DROP PROCEDURE dbo.Dot_Dep_CustomerInsMember_OddAdj;

IF OBJECT_ID('f_LAS_GenerateUsername', 'FN') IS NOT NULL 
	DROP FUNCTION dbo.f_LAS_GenerateUsername;

/*git\db-Deposit-CustomerSetting\CreateLicensee*/

IF OBJECT_ID('Dot_Dep_CreateCurrencyLicensee', 'P') IS NOT NULL 
	DROP PROCEDURE dbo.Dot_Dep_CreateCurrencyLicensee;
IF OBJECT_ID('Dot_Dep_CreateLicensee', 'P') IS NOT NULL 
	DROP PROCEDURE dbo.Dot_Dep_CreateLicensee;
IF OBJECT_ID('Dot_Dep_RollBackLicensee', 'P') IS NOT NULL 
	DROP PROCEDURE dbo.Dot_Dep_RollBackLicensee;
IF OBJECT_ID('Dot_Dep_RollBackLicenseeDCS', 'P') IS NOT NULL 
	DROP PROCEDURE dbo.Dot_Dep_RollBackLicenseeDCS;
