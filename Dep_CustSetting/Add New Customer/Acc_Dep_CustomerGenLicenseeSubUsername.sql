/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_CustomerGenLicenseeSubUsername]
(
@UserName	VARCHAR(30),
@Num		INT
)
AS
/*
Created: 20190918@Winnie
Task : GenLicenseeSubUsername
DB: DBCUST.CUSTDB
Original:

Revisions:
    - 20190918@Winnie: Create SP RedmineID:#120141
*/
BEGIN
DECLARE @startnum INT
DECLARE @endnum INT
DECLARE @mrecommend INT,@mrecommendUsername VARCHAR(30)
SELECT @mrecommend=mrecommend FROM custInfo WITH(NOLOCK) WHERE username=@UserName
SELECT @mrecommendUsername=Username FROM custInfo WITH(NOLOCK) WHERE custid=@mrecommend
CREATE TABLE #tempSubUserName(UserName VARCHAR(30))

SELECT @mrecommendUsername = username  
FROM dbo.custInfo WITH(NOLOCK)  
WHERE custid = @mrecommend

IF @mrecommendUsername IS NULL
BEGIN
	SELECT * FROM #tempSubUserName
	RETURN
END
SELECT @startnum=ISNULL(CAST(REPLACE(username, @mrecommendUsername, '') AS INT), 0)+1
FROM dbo.customer WITH(NOLOCK)  
WHERE custid = (SELECT MAX(custid)   
	FROM dbo.customer WITH(NOLOCK)   
	WHERE username LIKE @mrecommendUsername + '%'   
	AND username NOT LIKE @mrecommendUsername+'%'+'BetTrade'  
	AND username NOT LIKE @mrecommendUsername+'%'+'CashOut'
	AND username NOT LIKE @mrecommendUsername+'%'+'ClearBal'  
	AND mrecommend = @mrecommend
	AND RoleId = 2)

SELECT @endnum=@startnum+@Num-1

;WITH gen AS (
    SELECT @startnum AS num
    UNION ALL
    SELECT num+1 FROM gen WHERE num+1<=@endnum
)
INSERT INTO #tempSubUserName(UserName)
SELECT CASE WHEN LEN(Num)=1 THEN @mrecommendUsername+'0'+CAST( Num AS VARCHAR(50)) 
	   ELSE @mrecommendUsername+CAST( Num AS VARCHAR(50))  END AS Username

FROM gen
OPTION (MAXRECURSION 600) 

SELECT * FROM #tempSubUserName
END