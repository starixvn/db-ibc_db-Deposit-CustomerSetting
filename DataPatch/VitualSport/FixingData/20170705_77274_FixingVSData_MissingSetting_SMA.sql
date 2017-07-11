/*
	Created: 20170705@Helen
	Task: Fix Data for VS
	DB: DBCUST/CUSTDB
*/
USE CustDB
GO

CREATE TABLE #Cust_tmp_SMA ( CustID INT)

CREATE TABLE #SportMissing (SportType SMALLINT,Bettype SMALLINT)
INSERT INTO #SportMissing (SportType, betType)
VALUES (181,1231),(182,1231),(183,1231),(184,1231),(185,1231),(186,1220)

INSERT INTO #Cust_tmp_SMA (CustID)
SELECT Custid
FROM custInfo CI (NOLOCK)
WHERE custid IN (1573975, 1573978, 1573980, 1574024, 1574025, 1574026, 1574036, 1574041, 1574043, 1574083, 1574086, 1574089, 2397885, 2397886, 2397889, 3544240, 3544248, 3544256, 3544377, 3544379, 3544381, 3763288, 3763319, 3763331, 7596081, 7596180, 7596324, 7604551, 8092049, 8092050, 8092051, 10942049, 10536288, 10536289, 10536290, 10536368, 10536369, 10536370, 10536397, 10536398, 10536399, 10536437, 10536438, 10536439, 10536473, 10536474, 10536475, 12387160, 12387161, 12387162, 12620291, 12620292, 12620293)

INSERT INTO Dep_CustSetting3rd (custid, bettype, sporttype, islive, apositiontaking, mpositiontaking, spositiontaking, playerdiscount, discount, adiscount, sdiscount, minbet, maxbet)
SELECT CS.custid, S.bettype, S.sporttype, islive, apositiontaking, mpositiontaking, spositiontaking, playerdiscount, discount, adiscount, sdiscount, minbet, maxbet
FROM Dep_CustSetting3rd CS WITH (NOLOCK)
	INNER JOIN #Cust_tmp_SMA C ON CS.custid = C.CustID AND CS.sporttype = 180
	CROSS JOIN #SportMissing S 
WHERE NOT EXISTS (SELECT 1 FROM Dep_CustSetting3rd CS1 WITH (NOLOCK) WHERE CS1.custid = CS.custid AND CS1.sporttype=S.SportType)
