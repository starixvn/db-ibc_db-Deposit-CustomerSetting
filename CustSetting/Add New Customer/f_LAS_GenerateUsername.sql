USE [CustDB]
GO
/****** Object:  UserDefinedFunction [dbo].[f_LAS_GenerateUsername]    Script Date: 4/3/2017 4:11:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  User Defined Function dbo.f_LAS_GenerateUsername    Script Date: 7/24/2015 1:51:28 AM ******/
/****** Object:  User Defined Function dbo.f_LAS_GenerateUsername    Script Date: 7/23/2015 9:21:06 AM ******/
  
  
ALTER FUNCTION [dbo].[f_LAS_GenerateUsername]  
(  
 @recommend INT  
)   
RETURNS VARCHAR(50)  
AS  
/*  
 Created: 20140717@Patrick  
 DB: DBTXN/CustDB, DBEXT/bodb02  
 Task: Generate username when add new member  
    
 Revisions:  
  - 20140919@Patrick: Error when convert data  
  - 20140924@Patrick: Fix bug handle for case new agent  
  - 20150717@Winnie: Change for exclude bettrade ACC  
  - 20170304@Winnie:  Change for exclude CashOut ACC
 Parameters Explanation:  
*/  
  
BEGIN  
 IF @recommend = 0 OR @recommend IS NULL  
 BEGIN  
  RETURN ''  
 END  
  
 DECLARE @LimitLoop INT, @Index INT, @Username VARCHAR(50)  
  , @NumTmp VARCHAR(10), @NumOfMem INT, @recommendUsername VARCHAR(50)  
 SELECT @LimitLoop = 1000, @Index = 0, @Username = ''  
  
 SELECT @recommendUsername = username  
 FROM dbo.custInfo WITH(NOLOCK)  
 WHERE custid = @recommend AND roleid = 2  
  
 SELECT @NumOfMem = ISNULL(CAST(REPLACE(username, @recommendUsername, '') AS INT), 0)  
 FROM dbo.customer WITH(NOLOCK)  
 WHERE custid = (SELECT MAX(custid)   
     FROM dbo.customer WITH(NOLOCK)   
     WHERE username LIKE @recommendUsername + '%'   
     AND username NOT LIKE @recommendUsername+'%'+'BetTrade'  
     AND username NOT LIKE @recommendUsername+'%'+'CashOut'  
     AND RoleId = 1)  
  
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
  
  SELECT @UserName = @recommendUsername + @NumTmp  
  SELECT @UserName = REPLACE(@UserName, ' ', '')  
  --check username exists or not?  
  IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.customer WITH(NOLOCK) WHERE username = @UserName)  
  BEGIN  
   IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.custInfo WITH(NOLOCK) WHERE username = @UserName)  
   BEGIN  
    RETURN @UserName  
   END  
  END  
  
  IF @Index > @LimitLoop  
  BEGIN  
   RETURN ''  
  END  
  
  SET @Index = @Index + 1  
 END  
   
 RETURN ''  
END