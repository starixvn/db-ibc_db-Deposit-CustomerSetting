/*<info serverAlias="DBGlob-GlobCustDB" executers="wsv_nap" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_CustomerGenLicenseeSubUsername]
(
	@UserName	VARCHAR(30),
	@Num		INT
)
AS
/*
Created: 20190918@Winnie
Task : GenLicenseeSubUsername --> move check to GlobCustDB [#207474]
DB: DBGlob-GlobCustDB
Original:

Revisions:
    - 20190918@Winnie: Create SP RedmineID:#120141
	- 20230605@Winfred: NAP LM - New function to create agent subsidiary for TM team [redmine:#185123]
	- 20240705@Eden : Scale out DBCUST - Licensee Customer in GlobCustDB [redmine: #207474] 
*/
BEGIN
	DECLARE @startnum INT
	DECLARE @endnum INT
	DECLARE @mrecommend INT,@mrecommendUsername VARCHAR(30)

	SELECT @mrecommend=mrecommend FROM CustInfoMini WITH(NOLOCK) WHERE username = @UserName
	SELECT @mrecommendUsername = Username FROM CustInfoMini WITH(NOLOCK) WHERE custid = @mrecommend
	CREATE TABLE #tempSubUserName(UserName VARCHAR(30))

	IF @mrecommendUsername IS NULL
	BEGIN
		GOTO RETURNTbl;
	END

	BEGIN TRY
		SELECT @startnum=ISNULL(CAST(REPLACE(username, @mrecommendUsername, '') AS INT), 0)+1
		FROM dbo.CustInfoMini WITH(NOLOCK)  
		WHERE custid = (
						SELECT MAX(custid)   
						FROM dbo.CustInfoMini WITH(NOLOCK)   
						WHERE username LIKE @mrecommendUsername + '%'   
							AND username NOT LIKE @mrecommendUsername+'%'+'BetTrade'  
							AND username NOT LIKE @mrecommendUsername+'%'+'CashOut'
							AND username NOT LIKE @mrecommendUsername+'%'+'ClearBal'  
							AND mrecommend = @mrecommend
							AND RoleId = 2
						)
	END TRY
	BEGIN CATCH
		GOTO RETURNTbl;
	END CATCH
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

	RETURNTbl:
	SELECT * FROM #tempSubUserName
END
GO