/*
	Created: 20170224@Helen
	Task: Update SiteID for 12Bet - Redmine: https://nexdev.net/issues/71612
	DB:DBCUST/CUSTDB
	
*/ 
DECLARE @SiteID INT 

SET @SiteID = (SELECT siteid FROM Site WITH(NOLOCK) WHERE Site ='12Bet')

UPDATE T
	SET SiteID = @SiteID
FROM Dep_StakeLevel T (ROWLOCK)
WHERE T.GameTypeID IN (2401,2402) 
AND ExchangeID IN (
-- sheet 1
3,13,2,71,70,51,15,4,61,45
-- sheet 2
,12,6,9) 


