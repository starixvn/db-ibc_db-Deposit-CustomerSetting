/*
	Task: Add new column maxpermatch164 for Happy 5
	Run at: DB05@Bodb_Archive_Customer_Licensee
*/
USE Bodb_Archive_Customer_Licensee
GO

ALTER TABLE custinfo ADD maxpermatch164 MONEY NULL 
GO

ALTER TABLE custinfo ADD CONSTRAINT DF_CustInfo_maxpermatch164  DEFAULT ((0)) FOR [maxpermatch164]
GO
