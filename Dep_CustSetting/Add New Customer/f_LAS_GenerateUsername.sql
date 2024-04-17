/*<info serverAlias="DBCUST-CustDB" executers="bodbAdminNet,bodbDownlineNet,wsv_lap,Dot_Member" viewers="vnteam" isFunction="1"></info>*/

ALTER FUNCTION [dbo].[f_LAS_GenerateUsername]  
(  
 @recommend INT  
)   
RETURNS VARCHAR(50)  
AS  
/*  
 Created: 20140717@Patrick  
 DB: DBCUST/CustDB
 Task: Generate username when add new member  
    
 Revisions:  
  - 20140919@Patrick: Error when convert data  
  - 20140924@Patrick: Fix bug handle for case new agent  
  - 20150717@Winnie: Change for exclude bettrade ACC  
  - 20170304@Winnie:  Change for exclude CashOut ACC [Redmine: #72107]
  - 20181002@Dominic: Check existing username/username2 in archived DB  [Redmine:99882]
  - 20190422@Elodie: Offer unique nickname for CN88 [Redmine:112287]
  - 20201005@Winfred: Add new OddsAdj dummy customers [redmine:#142952]
  - 20231110@Elodie: Fix error username generation [Redmine: #196742]
  - 20231114@Johnson: change format username by adding 'S' (SystemID) [redmine: #196742]
 Parameters Explanation:  
*/  
  
BEGIN  
	IF @recommend = 0 OR @recommend IS NULL  
	BEGIN  
		RETURN ''  
	END  
  
	DECLARE @LimitLoop INT, @Index INT, @Username VARCHAR(50), @IsExists BIT,@Currency INT,@UsernameOddAdj VARCHAR(30),
			@NumTmp VARCHAR(10), @NumOfMem INT, @NumOfMem2 INT, @recommendUsername VARCHAR(50)  
	SELECT @LimitLoop = 1000, @Index = 0, @Username = ''  
  
	SELECT @recommendUsername = username , @Currency = currency
	FROM dbo.custInfo WITH(NOLOCK)  
	WHERE custid = @recommend AND roleid = 2  
  
		SET @UsernameOddAdj = isnull((SELECT  currency
		FROM exchange with(nolock)
		WHERE ExchangeId = @Currency),'') + '01OddsAdj'  
  
	SELECT @NumOfMem = ISNULL(CAST(CASE WHEN CHARINDEX('S',REPLACE(username, @recommendUsername, '')) = 0 
										THEN REPLACE(username, @recommendUsername, '')
										ELSE REPLACE(username, @recommendUsername+ 'S', '')	END
									AS INT), 0)  
	FROM dbo.customer WITH(NOLOCK)  
	WHERE custid = (SELECT MAX(custid)   
		FROM dbo.customer WITH(NOLOCK)   
		WHERE 
		(username LIKE @recommendUsername + '%' 
		OR username LIKE @recommendUsername + 'S' + '%'
		)
		AND username NOT LIKE @recommendUsername+'%'+'BetTrade'  
		AND username NOT LIKE @recommendUsername+'%'+'CashOut'
		AND username NOT LIKE @recommendUsername+'%'+'ClearBal'  
		AND username NOT LIKE Isnull(site,'') + Isnull(@UsernameOddAdj,'')  
		AND recommend = @recommend
		AND RoleId = 1)  

	---- 20231110@Elodie: Fix error username generation [Redmine: #196742]
	--IF @Recommend IN (40436421, 40436419) AND @NumOfMem < 99999 SELECT @NumOfMem = 99999

	SELECT @NumOfMem2 = ISNULL(CAST(CASE WHEN CHARINDEX('S',REPLACE(username, @recommendUsername, '')) = 0 
										THEN REPLACE(username, @recommendUsername, '')
										ELSE REPLACE(username, @recommendUsername+ 'S', '')	END
									AS INT), 0)   
	FROM dbo.Dep_Customer_Archived WITH(NOLOCK)  
	WHERE custid = (SELECT MAX(custid)   
					FROM dbo.Dep_Customer_Archived WITH(NOLOCK)   
					WHERE (username LIKE @recommendUsername + '%' OR username LIKE @recommendUsername + 'S' + '%')
						AND recommend = @recommend)
	
	IF ISNULL(@NumOfMem2,0) > ISNULL(@NumOfMem,0) SELECT @NumOfMem=@NumOfMem2
  
	SELECT @NumTmp = CAST(@NumOfMem AS VARCHAR(10))  
	IF @NumOfMem IS NULL --for case new agent  
	BEGIN  
		SET @NumOfMem = 0  
	END  
  
	WHILE 1 = 1  
	BEGIN  
		SET @Username = ''  
		--increase num of member  
		SET @NumOfMem = @NumOfMem + 1  
  
		IF LEN(@NumOfMem) < 3  
		BEGIN  
			SET @NumTmp = RIGHT('00' + CAST(@NumOfMem AS VARCHAR(10)), 3)  
		END  
		ELSE  
		BEGIN  
			SET @NumTmp = CAST(@NumOfMem AS VARCHAR(10))  
		END  
  
		SELECT @UserName = @recommendUsername + 'S' + @NumTmp  
		SELECT @UserName = REPLACE(@UserName, ' ', '')  

		--check username exists or not?  	 
		IF NOT EXISTS(SELECT 1 FROM customer WITH(NOLOCK) WHERE username = @username)
			AND NOT EXISTS (SELECT 1 FROM customer WITH (NOLOCK) WHERE username2 = @username)
			AND NOT EXISTS(SELECT 1 FROM custsub WITH (NOLOCK) WHERE username = @username)
			AND NOT EXISTS(SELECT 1 FROM custsub WITH (NOLOCK) WHERE username2 = @username)
			AND NOT EXISTS(SELECT 1 FROM Dep_Customer_Archived WITH (NOLOCK) WHERE username= @username)
			AND NOT EXISTS (SELECT 1 FROM Dep_Customer_Archived WITH (NOLOCK) WHERE username2 = @username)
		BEGIN
			RETURN @UserName  
		END
  
		IF @Index > @LimitLoop  
		BEGIN  
			RETURN ''  
		END  
  
		SET @Index = @Index + 1  
	END  
   
	RETURN ''  
END