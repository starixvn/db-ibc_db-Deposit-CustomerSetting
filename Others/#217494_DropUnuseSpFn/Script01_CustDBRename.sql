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
	EXECUTE sp_rename 'dbo.Acc_CustomerInsDummyTradeCashOut' , 'DEL_Acc_CustomerInsDummyTradeCashOut';
IF OBJECT_ID('Acc_Dep_CustomerCheckOddsAdj', 'P') IS NOT NULL 
	EXECUTE sp_rename 'dbo.Acc_Dep_CustomerCheckOddsAdj' , 'DEL_Acc_Dep_CustomerCheckOddsAdj';
IF OBJECT_ID('Acc_Dep_CustomerInsMember_Ag_CheckParam', 'P') IS NOT NULL 
	EXECUTE sp_rename 'dbo.Acc_Dep_CustomerInsMember_Ag_CheckParam' , 'DEL_Acc_Dep_CustomerInsMember_Ag_CheckParam';
IF OBJECT_ID('Acc_Dep_CustomerInsMember_Com_CheckParam', 'P') IS NOT NULL 
	EXECUTE sp_rename 'dbo.Acc_Dep_CustomerInsMember_Com_CheckParam' , 'DEL_Acc_Dep_CustomerInsMember_Com_CheckParam';
IF OBJECT_ID('Acc_Dep_CustomerInsMember_MAg_CheckParam', 'P') IS NOT NULL 
	EXECUTE sp_rename 'dbo.Acc_Dep_CustomerInsMember_MAg_CheckParam' , 'DEL_Acc_Dep_CustomerInsMember_MAg_CheckParam';
IF OBJECT_ID('Acc_Dep_CustomerInsMember_SAg_CheckParam', 'P') IS NOT NULL 
	EXECUTE sp_rename 'dbo.Acc_Dep_CustomerInsMember_SAg_CheckParam' , 'DEL_Acc_Dep_CustomerInsMember_SAg_CheckParam';
IF OBJECT_ID('Acc_Dep_CustomerInsSubsidiaryRollback', 'P') IS NOT NULL 
	EXECUTE sp_rename 'dbo.Acc_Dep_CustomerInsSubsidiaryRollback' , 'DEL_Acc_Dep_CustomerInsSubsidiaryRollback';
IF OBJECT_ID('Dot_Dep_CustomerInsMember_Ag_Cust', 'P') IS NOT NULL 
	EXECUTE sp_rename 'dbo.Dot_Dep_CustomerInsMember_Ag_Cust' , 'DEL_Dot_Dep_CustomerInsMember_Ag_Cust';
IF OBJECT_ID('Dot_Dep_CustomerInsMember_Ag_Cust_Main', 'P') IS NOT NULL 
	EXECUTE sp_rename 'dbo.Dot_Dep_CustomerInsMember_Ag_Cust_Main' , 'DEL_Dot_Dep_CustomerInsMember_Ag_Cust_Main';
IF OBJECT_ID('Dot_Dep_CustomerInsMember_Ag_Cust_Switch', 'P') IS NOT NULL 
	EXECUTE sp_rename 'dbo.Dot_Dep_CustomerInsMember_Ag_Cust_Switch' , 'DEL_Dot_Dep_CustomerInsMember_Ag_Cust_Switch';
IF OBJECT_ID('Dot_Dep_CustomerInsMember_OddAdj', 'P') IS NOT NULL 
	EXECUTE sp_rename 'dbo.Dot_Dep_CustomerInsMember_OddAdj' , 'DEL_Dot_Dep_CustomerInsMember_OddAdj';

IF OBJECT_ID('f_LAS_GenerateUsername', 'FN') IS NOT NULL 
	EXECUTE sp_rename 'dbo.f_LAS_GenerateUsername' , 'DEL_f_LAS_GenerateUsername', object;

/*git\db-Deposit-CustomerSetting\CreateLicensee*/
IF OBJECT_ID('Dot_Dep_CreateCurrencyLicensee', 'P') IS NOT NULL 
	EXECUTE sp_rename 'dbo.Dot_Dep_CreateCurrencyLicensee' , 'DEL_Dot_Dep_CreateCurrencyLicensee';
IF OBJECT_ID('Dot_Dep_CreateLicensee', 'P') IS NOT NULL 
	EXECUTE sp_rename 'dbo.Dot_Dep_CreateLicensee' , 'DEL_Dot_Dep_CreateLicensee';
IF OBJECT_ID('Dot_Dep_RollBackLicensee', 'P') IS NOT NULL 
	EXECUTE sp_rename 'dbo.Dot_Dep_RollBackLicensee' , 'DEL_Dot_Dep_RollBackLicensee';
IF OBJECT_ID('Dot_Dep_RollBackLicenseeDCS', 'P') IS NOT NULL 
	EXECUTE sp_rename 'dbo.Dot_Dep_RollBackLicenseeDCS' , 'DEL_Dot_Dep_RollBackLicenseeDCS';

