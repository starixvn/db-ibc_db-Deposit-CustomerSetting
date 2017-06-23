/*
	Created: 20170217@Helen
	Task: DCS Deposit for Fishing World - [Redmine:71568]
	Redmine: https://nexdev.net/issues/71568
*/ 
-- BEGIN STEP 1: Deploy this SP at DBCUST.CustDB, Run only in the FIRST running
------------------------------------------------------
ALTER PROCEDURE [dbo].[Acc_Dep_DynamicCustSetting_09]
 	 @srecommend INT
	, @max_custid INT
	, @target VARCHAR(20)
	
AS
BEGIN	
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at DBCUST only
	
	
	IF (dbo.f_CheckRepTable('Dep_CustPTSetting_Agent') = 0
		OR dbo.f_CheckRepTable('Dep_CustPTGroupSetting_Member') = 0 )
		RETURN
	
	DECLARE @ProductID INT = 24 -- Fishing World
		, @SuperPT SMALLINT = 92
	-- For StakelevelGroup params
	--, @IsStakeLevel BIT = 1
	
	DECLARE @SportType SMALLINT = 219, @BetType SMALLINT = 1011

	CREATE TABLE #tblCust (custid int, roleid int) 

	INSERT INTO #tblCust			
	SELECT custid,roleid
	FROM custInfo WITH(NOLOCK)
	WHERE srecommend =@srecommend 
		AND roleid IN (2,3,4)
		AND mrecommend NOT IN (SELECT custid FROM custinfo WITH(NOLOCK)
							   WHERE srecommend=@srecommend and username like '%Acc%' and roleid=3)
		AND custid <= @max_custid 
							   
	-- Licensee profile list
	-- PT processing
	UPDATE ST
		SET SuperPT = CASE WHEN ci.roleid = 4 THEN @SuperPT ELSE 0 END 
			, MasterPT = CASE WHEN ci.roleid IN (3,4) THEN @SuperPT ELSE 0 END 
			, AgentPT = CASE WHEN ci.roleid IN (2,4) THEN @SuperPT ELSE 0 END
	FROM [Dep_CustPTSetting_Agent] ST WITH (ROWLOCK,UPDLOCK)
		INNER JOIN #tblCust ci ON ST.CustID = CI.custid AND ci.roleid IN (2,3,4)
	WHERE ST.SportType = @SportType AND ST.BetType = @BetType	
		
	UPDATE ST
		SET AgentPT = @SuperPT
	FROM Dep_CustPTGroupSetting_Member ST WITH (ROWLOCK,UPDLOCK)
		INNER JOIN #tblCust ci ON ST.AgentID = CI.custid AND CI.roleid = 2
	WHERE ST.SportType = @SportType AND ST.BetType = @BetType	
	
	DROP TABLE #tblCust


END	

GO
-- END STEP 1: DEPLOY THIS SP @ DBCUST.CustDB -------

------------------------------------------------------	
-- BEGIN STEP 2: Run this SP at replicated DB: DB06, DBTP -----
--------------------------------------------------------------------------------------
DECLARE @ProductID INT = 24, @SportType INT = 219
 
CREATE TABLE #supers (custid int, isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT
SELECT  @max_custid= xxx ---input maxcustid

INSERT INTO #supers(custid)
SELECT custid
FROM  Dep_CustSuper with(nolock) 
WHERE site IN ('ISC888') -- API
	AND custid <= @max_custid
	AND currency NOT IN (27) -- Currency H - it is just test currency, used once in a while 
	

-- For deployer info
DECLARE @super_cnt INT, @index INT = 0

SET @super_cnt = (SELECT COUNT(*) FROM #supers )

DECLARE @msg nvarchar(200) = 'Currently at order %d, SuperID: %d.'

DECLARE @msg_total nvarchar(200) = 'Total of supers: %d.'

RAISERROR (@msg_total, 0, 1, @super_cnt) WITH NOWAIT

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #supers
	SET isfinished = 1
		,@srecommend = custid
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
	
	SET @index = @index + 1
	
	RAISERROR (@msg, 0, 1,@index, @srecommend) WITH NOWAIT
	
	EXEC dbo.[Acc_Dep_DynamicCustSetting_09] @srecommend = @srecommend, @max_custid=@max_custid,@target = 'REPLICATED' 	
				
	WAITFOR DELAY '00:00:00.280'			
END	

DROP TABLE #supers		
GO		

-- END STEP 2: Run this SP at replicated DB: DB06, DBTP -----
-----------------------------------------------------------------------------------
-- BEGIN STEP 3: Run this SP at DBCust -----
-------------------------------------------------
DECLARE @ProductID INT = 24, @SportType INT = 219
 
CREATE TABLE #supers (custid int, isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT
SELECT  @max_custid= xxx ---input maxcustid

INSERT INTO #supers(custid)
SELECT custid
FROM  Dep_CustSuper with(nolock) 
WHERE site IN ('ISC888') -- API
	AND custid <= @max_custid
	AND currency NOT IN (27) -- Currency H - it is just test currency, used once in a while 
	

-- For deployer info
DECLARE @super_cnt INT, @index INT = 0

SET @super_cnt = (SELECT COUNT(*) FROM #supers )

DECLARE @msg nvarchar(200) = 'Currently at order %d, SuperID: %d.'

DECLARE @msg_total nvarchar(200) = 'Total of supers: %d.'

RAISERROR (@msg_total, 0, 1, @super_cnt) WITH NOWAIT

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #supers
	SET isfinished = 1
		,@srecommend = custid
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
	
	SET @index = @index + 1
	
	RAISERROR (@msg, 0, 1,@index, @srecommend) WITH NOWAIT
	
	EXEC dbo.[Acc_Dep_DynamicCustSetting_09] @srecommend = @srecommend, @max_custid=@max_custid,@target = 'DBCUST'
		
	WAITFOR DELAY '00:00:00.280'			
END	

DROP TABLE #supers		
GO		


-- END STEP 3: Run this SP at DBCust -----
-------------------------------------------------