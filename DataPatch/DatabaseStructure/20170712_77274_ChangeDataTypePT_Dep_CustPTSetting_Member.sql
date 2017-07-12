/*
	Created: 20170712@Helen
	Task: Change PT Datatype
	
	DB: DBCUST/CUSTDB
	
	Dep_CustPTSetting_Agent: 9267 ROWS ; Dep_CustPTSetting_Member: 0 ROWS; Dep_CustPTGroupSetting_Member: 6948 ROWS
*/
USE CustDB
GO
-- Step 1: Drop default constraints ---------
ALTER TABLE Dep_CustPTSetting_Member
DROP CONSTRAINT DF_Dep_CustPTSetting_Member_SuperPT

ALTER TABLE Dep_CustPTSetting_Member
DROP CONSTRAINT DF_Dep_CustPTSetting_Member_MasterPT

ALTER TABLE Dep_CustPTSetting_Member
DROP CONSTRAINT DF_Dep_CustPTSetting_Member_AgentPT

GO
-- Step 2: change datatype ---------
ALTER TABLE Dep_CustPTSetting_Member
ALTER COLUMN SuperPT SMALLMONEY 

ALTER TABLE Dep_CustPTSetting_Member
ALTER COLUMN MasterPT SMALLMONEY 

ALTER TABLE Dep_CustPTSetting_Member
ALTER COLUMN AgentPT SMALLMONEY 

GO
-- Step 3: Add default constraints ---------
ALTER TABLE Dep_CustPTSetting_Member
ADD CONSTRAINT DF_Dep_CustPTSetting_Member_SuperPT DEFAULT 0 FOR SuperPT

ALTER TABLE Dep_CustPTSetting_Member
ADD CONSTRAINT DF_Dep_CustPTSetting_Member_MasterPT DEFAULT 0 FOR MasterPT

ALTER TABLE Dep_CustPTSetting_Member
ADD CONSTRAINT DF_Dep_CustPTSetting_Member_AgentPT DEFAULT 0 FOR AgentPT


