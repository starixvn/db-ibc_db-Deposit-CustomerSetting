/*<info serverAlias="DBCUST-CustDB" executers="Dot_Member" isFunction="0" isNested="1"></info>*/
ALTER PROCEDURE [dbo].[Dot_Dep_CustBonusSharingSel] 
	@CustID INT = 0
AS
/*
	Created by: 20230925@Tacy
	Task: Get all customer bonus sharing info
	DB: DBCust/CustDB
	Original: 
	
	Revisions:
		- 20201005@Tacy: Create SP [Redmine: #186192]

	Explanation's Param:
		@CustID = 0 ~ All customers
				<>0 ~ CustID
*/  
BEGIN
	SET NOCOUNT ON;

	IF @CustID=0
	BEGIN
		SELECT CustID, BonusSharingRate, FromDate, ToDate
		FROM Dep_CustBonusSharing WITH (NOLOCK)
		WHERE ToDate >= GETDATE() AND isDeleted=0 
	END
	ELSE
	BEGIN
		SELECT CustID, BonusSharingRate, FromDate, ToDate
		FROM Dep_CustBonusSharing WITH (NOLOCK)
		WHERE CustID=@CustID AND ToDate >= GETDATE() AND isDeleted=0
	END
END
GO