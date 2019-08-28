/*
	Task: Insert dummy ClearBal accounts for Tycoon, DELA - Feature #104958
	Creator: Dominic
	Run at: DBCUST.CustDB
*/
USE CustDB

--Comma separated string of licensee,e.g, 'KaiHao,12bet,W88'
DECLARE @_LicenseeLst VARCHAR(4000)='Tycoon,DELA'

--Temporary variables for Licensee loop action
DECLARE @_RegisteredLicenseeName NVARCHAR(50)
DECLARE @_LicenseeStatusId TINYINT

--Input params when creating dummy account
DECLARE @_DummyUsername VARCHAR(50)
DECLARE @_recommend INT
DECLARE @_creator INT = 10278938 --starixit
DECLARE @_userpwd VARCHAR(40) ='8058095B7DDB08A608811097E5DB8D' --123qwe
--Output values when creating dummy account
DECLARE @_CustID INT
DECLARE @_ErrCode INT
DECLARE @_ErrMsg NVARCHAR(4000) = ''


--List of Licensees
CREATE TABLE #LicenseeLst (LicenseeName NVARCHAR(50)
							,RegisteredLicenseeName NVARCHAR(50)
							,LicenseeStatusId TINYINT
							,IsExecuted BIT DEFAULT(0)
							)
CREATE UNIQUE CLUSTERED INDEX IX_LicenseeName ON #LicenseeLst(LicenseeName)

--List of Agents under a Licensee
CREATE TABLE #AgentLst(AgentID INT, AgentUserName VARCHAR(30),IsExecuted BIT DEFAULT(0) )

CREATE UNIQUE CLUSTERED INDEX IX_AgentID ON #AgentLst(AgentID)

DECLARE @XML XML
SET @XML = N'<root><r>' + REPLACE(@_LicenseeLst, ',', '</r><r>') + '</r></root>'

INSERT INTO #LicenseeLst(LicenseeName) 
SELECT r.value('.','NVARCHAR(50)')
FROM @xml.nodes('//root/r') AS RECORDS(r)


UPDATE main
SET main.RegisteredLicenseeName = l.RegisteredLicenseeName
, main.[LicenseeStatusId] = l.[LicenseeStatusId]
FROM #LicenseeLst main
INNER JOIN DB052.bodb_OIC.dbo.licensee l ON l.LicenseeName=main.LicenseeName

IF EXISTS(SELECT 1 FROM #LicenseeLst WHERE RegisteredLicenseeName IS NULL)
BEGIN
	RAISERROR('There are licensees with unidentified registered name.', 11, 1)
	
	RETURN
END

WHILE(EXISTS(SELECT 1 FROM #LicenseeLst WHERE IsExecuted=0))
BEGIN
	UPDATE TOP(1) main
	SET main.IsExecuted=1
		, @_RegisteredLicenseeName = main.RegisteredLicenseeName
		, @_LicenseeStatusId = main.LicenseeStatusId
	FROM #LicenseeLst main
	WHERE IsExecuted=0

	IF @_LicenseeStatusId = 4 --Terminated Licensee: Insert dummy accounts for UUS lines
	BEGIN
		INSERT INTO #AgentLst(AgentID, AgentUserName)
		SELECT custid,username
		FROM Customer ag(NOLOCK)
		WHERE roleid=2
		AND username NOT LIKE '%ACC%' 
		AND srecommend IN (
			SELECT CustID
			FROM Dep_CustSuper (NOLOCK)
			WHERE site = @_RegisteredLicenseeName
		)
		AND EXISTS (SELECT 1 FROM Customer (NOLOCK) WHERE recommend=ag.custid AND roleid=1)
		AND NOT EXISTS (SELECT 1 FROM Customer (NOLOCK) WHERE recommend=ag.custid AND roleid=1 AND username LIKE '%ClearBal')
	END
	ELSE
	BEGIN
		INSERT INTO #AgentLst(AgentID, AgentUserName)
		SELECT custid,username
		FROM Customer ag(NOLOCK)
		WHERE roleid=2
		AND username NOT LIKE '%ACC%' 
		AND currency NOT IN (20,27,28)
		AND srecommend IN (
			SELECT CustID
			FROM Dep_CustSuper (NOLOCK)
			WHERE site = @_RegisteredLicenseeName
		)
		AND EXISTS (SELECT 1 FROM Customer (NOLOCK) WHERE recommend=ag.custid AND roleid=1)
		AND NOT EXISTS (SELECT 1 FROM Customer (NOLOCK) WHERE recommend=ag.custid AND roleid=1 AND username LIKE '%ClearBal')
	END

	WHILE(EXISTS(SELECT 1 FROM #AgentLst WHERE IsExecuted=0))
	BEGIN
		UPDATE TOP(1) main
		SET main.IsExecuted=1
			, @_recommend = main.AgentID
			, @_DummyUsername = main.AgentUserName + 'ClearBal'
		FROM #AgentLst main
		WHERE IsExecuted=0
		
		SELECT @_ErrCode  = 0

		EXEC Acc_Dep_CustomerInsMember_Ag 
			@username=@_DummyUsername
			,@recommend=@_recommend
			,@creator=@_creator
			,@userpwd=@_userpwd
			,@DisableNumber=1,@MinBetv1=0.0000,@MaxBetv1=0.0000,@MaxPerMatchv1=0.0000,@MinBetv2=0.0000,@MaxBetv2=0.0000,@MaxPerMatchv2=0.0000
			,@MinBetv3=0.0000,@MaxBetv3=0.0000,@MaxPerMatchv3=0.0000,@MinBetv5=0.0000,@MaxBetv5=0.0000,@MaxPerMatchv5=0.0000,@MinBetv8=0.0000
			,@MaxBetv8=0.0000,@MaxPerMatchv8=0.0000,@MinBetv10=0.0000,@MaxBetv10=0.0000,@MaxPerMatchv10=0.0000,@MinBetv11=0.0000,@MaxBetv11=0.0000
			,@MaxPerMatchv11=0.0000,@MinBetv44=0.0000,@MaxBetv44=0.0000,@MaxPerMatchv44=0.0000,@MinBetv99=0.0000,@MaxBetv99=0.0000
			,@MaxPerMatchv99=0.0000,@MinBetv99mp=0.0000,@MaxBetv99mp=0.0000,@MaxPerMatchv99mp=0.0000,@MinBetv161=0.0000,@MaxBetv161=0.0000
			,@MaxPerMatchv161=0.0000,@MaxPerBallv161=0.0000,@v1apositiontaking_1=0.0000,@v1apositiontaking_2=0.0000
			,@v1apositiontaking_3=0.0000,@v1apositiontaking_4=0.0000,@v1apositiontaking_5=0.0000,@v1apositiontaking_6=0.0000
			,@v1apositiontaking_7=0.0000,@v1apositiontaking_8=0.0000,@v1apositiontaking_9=0.0000,@v1apositiontaking_10=0.0000
			,@v1alivepositiontaking_1=0.0000,@v1alivepositiontaking_3=0.0000,@v1alivepositiontaking_7=0.0000
			,@v1alivepositiontaking_8=0.0000,@v2apositiontaking_1=0.0000,@v2apositiontaking_2=0.0000
			,@v2apositiontaking_3=0.0000,@v2apositiontaking_7=0.0000,@v2apositiontaking_8=0.0000
			,@v2apositiontaking_20=0.0000,@v3apositiontaking_1=0.0000,@v3apositiontaking_2=0.0000,@v3apositiontaking_3=0.0000
			,@v3apositiontaking_20=0.0000,@v5apositiontaking_1=0.0000,@v5apositiontaking_2=0.0000,@v5apositiontaking_3=0.0000
			,@v5apositiontaking_20=0.0000,@v8apositiontaking_1=0.0000,@v8apositiontaking_3=0.0000,@v8apositiontaking_20=0.0000
			,@v10apositiontaking_1=0.0000,@v10apositiontaking_2=0.0000,@v10apositiontaking_3=0.0000,@v10apositiontaking_20=0.0000
			,@v11apositiontaking_1=0.0000,@v11apositiontaking_20=0.0000,@v44apositiontaking_3=0.0000,@v99apositiontaking_1=0.0000
			,@v99apositiontaking_2=0.0000,@v99apositiontaking_3=0.0000,@v99apositiontaking_20=0.0000,@v99apositiontaking_9=0.0000
			,@v161apositiontaking_81=0.0000,@v161apositiontaking_83=0.0000,@v161apositiontaking_86=0.0000,@v161apositiontaking_88=0.0000
			,@v161alivepositiontaking_85=0.0000,@v161alivepositiontaking_86=0.0000,@v161alivepositiontaking_87=0.0000
			,@v161alivepositiontaking_89=0.0000,@v161alivepositiontaking_90=0.0000
			,@KenoList='<products><product Bettype="1501" MaxBet="0" MinBet="0" MaxPerMatch="0" IsDisable="1" sPositionTaking="0" mPositionTaking="0" aPositionTaking="0"></product><product Bettype="1503" MaxBet="0" MinBet="0" MaxPerMatch="0" IsDisable="1" sPositionTaking="0" mPositionTaking="0" aPositionTaking="0"></product><product Bettype="1504" MaxBet="0" MinBet="0" MaxPerMatch="0" IsDisable="1" sPositionTaking="0" mPositionTaking="0" aPositionTaking="0"></product><product Bettype="1505" MaxBet="0" MinBet="0" MaxPerMatch="0" IsDisable="1" sPositionTaking="0" mPositionTaking="0" aPositionTaking="0"></product><product Bettype="1507" MaxBet="0" MinBet="0" MaxPerMatch="0" IsDisable="1" sPositionTaking="0" mPositionTaking="0" aPositionTaking="0"></product><product Bettype="1508" MaxBet="0" MinBet="0" MaxPerMatch="0" IsDisable="1" sPositionTaking="0" mPositionTaking="0" aPositionTaking="0"></product><product Bettype="1509" MaxBet="0" MinBet="0" MaxPerMatch="0" IsDisable="1" sPositionTaking="0" mPositionTaking="0" aPositionTaking="0"></product><product Bettype="1511" MaxBet="0" MinBet="0" MaxPerMatch="0" IsDisable="1" sPositionTaking="0" mPositionTaking="0" aPositionTaking="0"></product><product Bettype="1513" MaxBet="0" MinBet="0" MaxPerMatch="0" IsDisable="1" sPositionTaking="0" mPositionTaking="0" aPositionTaking="0"></product><product Bettype="1514" MaxBet="0" MinBet="0" MaxPerMatch="0" IsDisable="1" sPositionTaking="0" mPositionTaking="0" aPositionTaking="0"></product></products>'
			,@DisableKeno=default,@IP='',@Language=default,@SubAccID=default
			,@custid=@_CustID output, @ErrCode=@_ErrCode output,@ErrMsg=@_ErrMsg output

		IF @_ErrCode > 0
		BEGIN
			SELECT @_ErrMsg = 'Can not create this dummy ClearBal(' + @_DummyUsername + ') : ' + @_ErrMsg

			EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive 
				@Action='CREATE-DUMMY'
				, @Status='Failed'
				, @Message=@_ErrMsg
		END
		ELSE
		BEGIN
			SELECT @_ErrMsg = 'Finish create this dummy ClearBal(' + @_DummyUsername + ')'

			EXEC DBLOG.bodb_CustomerLog.dbo.Writelog_Dep_Cust_Archive 
				@Action='CREATE-DUMMY'
				, @Status='Done'
				, @Message=@_ErrMsg
		END

		WAITFOR DELAY '00:00:01'
	END

	TRUNCATE TABLE #AgentLst
END

DROP TABLE #AgentLst
DROP TABLE #LicenseeLst
