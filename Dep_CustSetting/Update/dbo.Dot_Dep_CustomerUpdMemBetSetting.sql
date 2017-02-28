ALTER PROCEDURE [dbo].[Dot_Dep_CustomerUpdMemBetSetting_Cust]
	@CustId INT, --MemberID
	
	@UpdateMinMaxBet BIT = 1,	
	@UpdateMinMaxBetv2 BIT = 1,	
	@UpdateMinMaxBetv3 BIT = 1,	
	@UpdateMinMaxBetv5 BIT = 1,	
	@UpdateMinMaxBetv8 BIT = 1,	
	@UpdateMinMaxBetv10 BIT = 1,
	@UpdateMinMaxBetv11 BIT = 1,
	@UpdateMinMaxBetv99 BIT = 1,

	@UpdateMinMaxBetv99MP BIT = 0,
	@UpdateMinMaxBetv154 BIT = 0,
			
	@UpdateMinMaxBetv201 BIT = 0,
	@UpdateMinMaxBetv151 BIT = 0,
	@UpdateMinMaxBetv151OT BIT = 0,
	@UpdateMinMaxBetv151_51 BIT = 0,
	@UpdateMinMaxBetv152_41 BIT = 0,
	@UpdateMinMaxBetv152_51 BIT = 0,
	@UpdateMinMaxBetv153_51 BIT = 0,
	@UpdateMinMaxBetv161 BIT = 0,
	@UpdateMinMaxBetv180 BIT = 0,
	@UpdateMinMaxBetv181 BIT = 0,
	@UpdateMinMaxBetv182 BIT = 0,
	@UpdateMinMaxBetv184 BIT = 0,
	@UpdateMinMaxBetv186 BIT = 0,
	@UpdateMinMaxBetv202 BIT = 0,
 
	@MinBet MONEY,
	@MaxBet MONEY,
	@MaxPerMatch MONEY,
	
	@MinBetv2 MONEY,
	@MaxBetv2 MONEY,
	@MaxPerMatchv2 MONEY,

	@MinBetv3 MONEY,
	@MaxBetv3 MONEY,
	@MaxPerMatchv3 MONEY,

	@MinBetv5 MONEY,
	@MaxBetv5 MONEY,
	@MaxPerMatchv5 MONEY,

	@MinBetv8 MONEY,
	@MaxBetv8 MONEY,
	@MaxPerMatchv8 MONEY,

	@MinBetv10 MONEY,
	@MaxBetv10 MONEY,
	@MaxPerMatchv10 MONEY,

	@MinBetv11 MONEY,
	@MaxBetv11 MONEY,
	@MaxPerMatchv11 MONEY,
	
	@MinBetv99 MONEY,
	@MaxBetv99 MONEY,
	@MaxPerMatchv99 MONEY,

	@MinBetv99MP MONEY = 0,
	@MaxBetv99MP MONEY = 0,
	@MaxPerMatchv99MP MONEY = 0,

	@MinBetv154 MONEY = 0,
	@MaxBetv154 MONEY = 0,
	@MaxPerMatchv154 MONEY = 0,
	
	@MinBetv201 MONEY = 0,
	@MaxBetv201 MONEY = 0,
	@MaxPerMatchv201 MONEY = 0,

	@MinBetv202_1501 MONEY = 0,
	@MaxBetv202_1501 MONEY = 0,
	@MaxPerMatchv202_1501 MONEY = 0,

	@MinBetv151 MONEY,
	@MaxBetv151 MONEY,
	@MaxPerMatchv151 MONEY,

	@MinBetv151OT MONEY=0,
	@MaxBetv151OT MONEY=0,
	@MaxPerMatchv151OT MONEY=0,
	
	@MinBetv151_51 MONEY=0,
	@MaxBetv151_51 MONEY=0,
	@MaxPerMatchv151_51 MONEY=0,
	
	@MinBetv152_41 MONEY=0,
	@MaxBetv152_41 MONEY=0,
	@MaxPerMatchv152_41 MONEY=0,
	
	@MinBetv152_51 MONEY=0,
	@MaxBetv152_51 MONEY=0,
	@MaxPerMatchv152_51 MONEY=0,
	
	@MinBetv153_51 MONEY=0,
	@MaxBetv153_51 MONEY=0,
	@MaxPerMatchv153_51 MONEY=0,

	@MinBetv161 MONEY = 0,
	@MaxBetv161 MONEY = 0,
	@MaxPerMatchv161 MONEY =0,
	@MaxPerBallv161 MONEY = 0,
	
	@MinBetv180 MONEY = 0,
	@MaxBetv180 MONEY = 0,
	@MaxPerMatchv180 MONEY = 0,
	
	@MinBetv181 MONEY = 0,
	@MaxBetv181 MONEY = 0,
	@MaxPerMatchv181 MONEY = 0,
	
	@MinBetv182 MONEY = 0,
	@MaxBetv182 MONEY = 0,
	@MaxPerMatchv182 MONEY = 0,
	
	@MinBetv184 MONEY = 0,
	@MaxBetv184 MONEY = 0,
	@MaxPerMatchv184 MONEY = 0,
	
	@MinBetv186 MONEY = 0,
	@MaxBetv186 MONEY = 0,
	@MaxPerMatchv186 MONEY = 0,
	
	@userid INT, --updater Id	
	@language VARCHAR(2) = 'E',
	@IP VARCHAR(15)='',	
	@ErrCode INT = 0 OUTPUT,
	@ErrMsg NVARCHAR(4000) = '' OUTPUT
AS

/*
Created: 20090721@Phuc (Tommy)
Task : Update member min max bet.
DB: DBTXN/CustDB

Revisions:
    - 20090402@Phuc: write log for logout.
    - 20091303@Peter : #353 IRP - DBA - Separate HorseRacing and Financial's setting from custsetting and custoverride
	- 20100112@Kiwi: Amend to write log in xml format.
	- 20100405@Phuc: update bet setting for HorseRacing.
	- 20100531@Thien: default min/max bet for Open Tote.
	- 20100925@Johnson: update setting for Number game and mix parlay mixed sports
	- 20101019@Henry: Record execution time
	- 20101029@Johnson: Include max per ball for number game
	- 20101113@Jamie: Remove the hard code for copying soccer handicap for Mix Sports Parlay and Number Game
	- 20110226@Henry: Add setting for HR AU, Greyhound, Harness  
	- 20110606@Amy: Write log Old values
	- 20110719@thien: temporarily bypass the racing checking for these sites below
	- 20110719@Jamie: temporarily do not update Min/MaxBet if Member's MinBet is less than Agent's MinBet for Mansion88  
	- 20120321@Kiwi: Change to use Dep_CustSetting/Dep_CustSetting3rd
	- 20130716@Elodie: Update bet setting for Virtual Soccer
	- 20131211@Elodie: Update bet setting for Virtual Racing(181), Greyhounds(182), Motor Racing(184), Tennis(186)
	- 20140123@Elodie: Update bet setting for HR Fixed Odds(154) [Redmine:#10922]
	- 20140305@Elodie: Update bet setting for Keno(202) [Redmine:#11658]
Param's Explanation:
*/

SET NOCOUNT ON

declare @startRun datetime
declare @endRun datetime
declare @duration int
set @startRun = getdate()


--Check Closed?
DECLARE @UplineClosed BIT
DECLARE @MinMinBet MONEY, @MaxMaxBet MONEY,	@MaxMaxPerMatch MONEY,
	@MinMinBetv2 MONEY, @MaxMaxBetv2 MONEY, @MaxMaxPerMatchv2 MONEY,
	@MinMinBetv3 MONEY, @MaxMaxBetv3 MONEY, @MaxMaxPerMatchv3 MONEY,
	@MinMinBetv5 MONEY, @MaxMaxBetv5 MONEY, @MaxMaxPerMatchv5 MONEY,
	@MinMinBetv8 MONEY, @MaxMaxBetv8 MONEY, @MaxMaxPerMatchv8 MONEY,
	@MinMinBetv10 MONEY, @MaxMaxBetv10 MONEY, @MaxMaxPerMatchv10 MONEY,
	@MinMinBetv11 MONEY, @MaxMaxBetv11 MONEY, @MaxMaxPerMatchv11 MONEY,
	@MinMinBetv99 MONEY, @MaxMaxBetv99 MONEY, @MaxMaxPerMatchv99 MONEY,
	@MinMinBetv99MP MONEY, @MaxMaxBetv99MP MONEY, @MaxMaxPerMatchv99MP MONEY,
	@MinMinBetv154 MONEY, @MaxMaxBetv154 MONEY, @MaxMaxPerMatchv154 MONEY,
	@MinMinBetv202_1501 MONEY, @MaxMaxBetv202_1501 MONEY, @MaxMaxPerMatchv202_1501 MONEY,

	@MinMinBetv151 MONEY, @MaxMaxBetv151 MONEY, @MaxMaxPerMatchv151 MONEY,
	@MinMinBetv151OT MONEY, @MaxMaxBetv151OT MONEY, @MaxMaxPerMatchv151OT MONEY,
	@MinMinBetv151_51 MONEY, @MaxMaxBetv151_51 MONEY, @MaxMaxPerMatchv151_51 MONEY,
	@MinMinBetv152_41 MONEY, @MaxMaxBetv152_41 MONEY, @MaxMaxPerMatchv152_41 MONEY,
	@MinMinBetv152_51 MONEY, @MaxMaxBetv152_51 MONEY, @MaxMaxPerMatchv152_51 MONEY,
	@MinMinBetv153_51 MONEY, @MaxMaxBetv153_51 MONEY, @MaxMaxPerMatchv153_51 MONEY,
	@MinMinBetv161 MONEY, @MaxMaxBetv161 MONEY, @MaxMaxPerMatchv161 MONEY, @MaxMaxPerBallv161 MONEY,
	@MinMinBetv180 MONEY, @MaxMaxBetv180 MONEY, @MaxMaxPerMatchv180 MONEY,
	@MinMinBetv181 MONEY, @MaxMaxBetv181 MONEY, @MaxMaxPerMatchv181 MONEY,
	@MinMinBetv182 MONEY, @MaxMaxBetv182 MONEY, @MaxMaxPerMatchv182 MONEY,
	@MinMinBetv184 MONEY, @MaxMaxBetv184 MONEY, @MaxMaxPerMatchv184 MONEY,
	@MinMinBetv186 MONEY, @MaxMaxBetv186 MONEY, @MaxMaxPerMatchv186 MONEY
	
Declare 
	@Old_MinBet money, @Old_MaxBet money,	@Old_MaxPerMatch money,
	@Old_MinBetv2 money, @Old_MaxBetv2 money, @Old_MaxPerMatchv2 money,
	@Old_MinBetv3 money, @Old_MaxBetv3 money, @Old_MaxPerMatchv3 money,
	@Old_MinBetv5 money, @Old_MaxBetv5 money, @Old_MaxPerMatchv5 money,
	@Old_MinBetv8 money, @Old_MaxBetv8 money, @Old_MaxPerMatchv8 money,
	@Old_MinBetv10 money, @Old_MaxBetv10 money, @Old_MaxPerMatchv10 money,
	@Old_MinBetv11 money, @Old_MaxBetv11 money, @Old_MaxPerMatchv11 money,
	@Old_MinBetv99 money, @Old_MaxBetv99 money, @Old_MaxPerMatchv99 money,
	@Old_MinBetv99MP money, @Old_MaxBetv99MP money, @Old_MaxPerMatchv99MP money,
	@Old_MinBetv154 money, @Old_MaxBetv154 money, @Old_MaxPerMatchv154 money,
	@Old_MinBetv202_1501 money, @Old_MaxBetv202_1501 money, @Old_MaxPerMatchv202_1501 money,

	@Old_MinBetv161 money, @Old_MaxBetv161 money, @Old_MaxPerMatchv161 money,
	@Old_MaxPerBallv161 money, 
	@Old_MinBetv151 MONEY, @Old_MaxBetv151 MONEY, 	@Old_MaxPerMatchv151 MONEY,	
	@Old_MinBetv151OT MONEY, @Old_MaxBetv151OT MONEY, @Old_MaxPerMatchv151OT MONEY, 
	@Old_MinBetv151_51 MONEY, @Old_MaxBetv151_51 MONEY, @Old_MaxPerMatchv151_51 MONEY, 
	@Old_MinBetv152_41 MONEY, @Old_MaxBetv152_41 MONEY, @Old_MaxPerMatchv152_41 MONEY, 
	@Old_MinBetv152_51 MONEY, @Old_MaxBetv152_51 MONEY, @Old_MaxPerMatchv152_51 MONEY, 
	@Old_MinBetv153_51 MONEY, @Old_MaxBetv153_51 MONEY, @Old_MaxPerMatchv153_51 MONEY,
	@Old_MinBetv180 money, @Old_MaxBetv180 money, @Old_MaxPerMatchv180 money,
	@Old_MinBetv181 money, @Old_MaxBetv181 money, @Old_MaxPerMatchv181 money,
	@Old_MinBetv182 money, @Old_MaxBetv182 money, @Old_MaxPerMatchv182 money,
	@Old_MinBetv184 money, @Old_MaxBetv184 money, @Old_MaxPerMatchv184 money,
	@Old_MinBetv186 money, @Old_MaxBetv186 money, @Old_MaxPerMatchv186 money
	
DECLARE @ErrAcc VARCHAR(4000), @ErrType VARCHAR(4000),
		@UserName VARCHAR(30), @recommend INT, @roleid TINYINT

SELECT @UplineClosed = ISNULL(closed,0)
FROM custinfo (NOLOCK) 
WHERE custid = @UserID 
		
SELECT @UserName = username, @recommend = recommend, @roleid = roleid
FROM customer WITH (NOLOCK)
WHERE CustID = @CustID
--select min max bet of Sportbook and Number game
    EXEC dbo.Dot_Dep_CustomerSelMinMax_Cust @custid,  
   @old_MinBet output, @old_MaxBet output, @old_MaxPerMatch output,  
   @old_MinBetv2 output, @old_MaxBetv2 output, @old_MaxPerMatchv2 output,  
   @old_MinBetv3 output, @old_MaxBetv3 output, @old_MaxPerMatchv3 output,  
   @old_MinBetv5 output, @old_MaxBetv5 output, @old_MaxPerMatchv5 output,  
   @old_MinBetv8 output, @old_MaxBetv8 output, @old_MaxPerMatchv8 output,  
   @old_MinBetv10 output, @old_MaxBetv10 output, @old_MaxPerMatchv10 output,  
   @old_MinBetv11 output, @old_MaxBetv11 output, @old_MaxPerMatchv11 output,  
   @old_MinBetv99 output, @old_MaxBetv99 output, @old_MaxPerMatchv99 output,     
   @old_MinBetv99MP output, @old_MaxBetv99MP output, @old_MaxPerMatchv99MP output,  
   @old_MinBetv154 output, @old_MaxBetv154 output, @old_MaxPerMatchv154 output,  
   @old_MinBetv161 output, @old_MaxBetv161 output, @old_MaxPerMatchv161 output, @old_MaxPerBallv161 output,
   @Old_MinBetv202_1501 output, @Old_MaxBetv202_1501 output, @Old_MaxPerMatchv202_1501 output
	
--select min max bet of Racing
Select     
	@Old_MinBetv151 = isnull(MinBet ,0),
	@Old_MaxBetv151 = isnull(MaxBet ,0) 
from     
	dbo.Dep_CustSetting3rd WITH (NOLOCK)    	
where custid = @CustID and bettype = 31 and sporttype=151    
    
--Open Tote
Select     
	@Old_MinBetv151OT = isnull(MinBet ,0),
	@Old_MaxBetv151OT = isnull(MaxBet ,0) 
from     
	Dep_CustSetting3rd WITH (NOLOCK)    
where custid = @CustID and bettype = 41 and sporttype=151    

--v151_51
Select     
	@Old_MinBetv151_51 = isnull(MinBet ,0),
	@Old_MaxBetv151_51 = isnull(MaxBet ,0) 
from     
	Dep_CustSetting3rd WITH (NOLOCK)    
where custid = @CustID and bettype = 51 and sporttype=151    
--v152_41
Select     
	@Old_MinBetv152_41 = isnull(MinBet ,0),
	@Old_MaxBetv152_41 = isnull(MaxBet ,0) 
from     
	Dep_CustSetting3rd WITH (NOLOCK)    
where custid = @CustID and bettype = 41 and sporttype=152    
--v152_51
Select     
	@Old_MinBetv152_51 = isnull(MinBet ,0),
	@Old_MaxBetv152_51 = isnull(MaxBet ,0) 
from     
	Dep_CustSetting3rd WITH (NOLOCK)    
where custid = @CustID and bettype = 51 and sporttype=152    
--v153_51
Select     
	@Old_MinBetv153_51 = isnull(MinBet ,0),
	@Old_MaxBetv153_51 = isnull(MaxBet ,0) 
from     
	Dep_CustSetting3rd WITH (NOLOCK)    
where custid = @CustID and bettype = 51 and sporttype=153 

--v180
Select     
	@Old_MinBetv180 = isnull(MinBet ,0),
	@Old_MaxBetv180 = isnull(MaxBet ,0) 
from     
	Dep_CustSetting3rd WITH (NOLOCK)    
where custid = @CustID and bettype = 1201 and sporttype=180

--v181
Select     
	@Old_MinBetv181 = isnull(MinBet ,0),
	@Old_MaxBetv181 = isnull(MaxBet ,0) 
from     
	Dep_CustSetting3rd WITH (NOLOCK)    
where custid = @CustID and bettype = 1231 and sporttype=181

--v182
Select     
	@Old_MinBetv182 = isnull(MinBet ,0),
	@Old_MaxBetv182 = isnull(MaxBet ,0) 
from     
	Dep_CustSetting3rd WITH (NOLOCK)    
where custid = @CustID and bettype = 1231 and sporttype=182

--v184
Select     
	@Old_MinBetv184 = isnull(MinBet ,0),
	@Old_MaxBetv184 = isnull(MaxBet ,0) 
from     
	Dep_CustSetting3rd WITH (NOLOCK)    
where custid = @CustID and bettype = 1231 and sporttype=184

--v186
Select     
	@Old_MinBetv186 = isnull(MinBet ,0),
	@Old_MaxBetv186 = isnull(MaxBet ,0) 
from     
	Dep_CustSetting3rd WITH (NOLOCK)    
where custid = @CustID and bettype = 1220 and sporttype=186

select @Old_MaxPerMatchv151 =isnull(MaxPerMatch151,0),
	@Old_MaxPerMatchv151OT = isnull(MaxPerMatch151_OT,0),
	@Old_MaxPerMatchv151_51 = isnull(MaxPerMatch151_AU,0), 
	@Old_MaxPerMatchv152_41 = isnull(MaxPerMatch152_UK,0), 
	@Old_MaxPerMatchv152_51 = isnull(MaxPerMatch152_AU,0), 
	@Old_MaxPerMatchv153_51 = isnull(MaxPerMatch153_AU,0),
	@Old_MaxPerMatchv180 = isnull(MaxPerMatch180,0), 
	@Old_MaxPerMatchv181 = isnull(MaxPerMatch181,0), 
	@Old_MaxPerMatchv182 = isnull(MaxPerMatch182,0), 
	@Old_MaxPerMatchv184 = isnull(MaxPerMatch184,0), 
	@Old_MaxPerMatchv186 = isnull(MaxPerMatch186,0) 
from custinfo with (nolock)
where custid=@Custid
----------------------------------
   
IF 	@Old_MinBet = @MinBet AND @Old_MaxBet = @MaxBet AND	@Old_MaxPerMatch = @MaxPerMatch AND
	@Old_MinBetv2 = @MinBetv2 AND @Old_MaxBetv2 = @MaxBetv2 AND @Old_MaxPerMatchv2 = @MaxPerMatchv2 AND
	@Old_MinBetv3 = @MinBetv3 AND @Old_MaxBetv3 = @MaxBetv3 AND @Old_MaxPerMatchv3 = @MaxPerMatchv3 AND
	@Old_MinBetv5 = @MinBetv5 AND @Old_MaxBetv5 = @MaxBetv5 AND @Old_MaxPerMatchv5 = @MaxPerMatchv5 AND
	@Old_MinBetv8 = @MinBetv8 AND @Old_MaxBetv8 = @MaxBetv8 AND @Old_MaxPerMatchv8 = @MaxPerMatchv8 AND
	@Old_MinBetv10 = @MinBetv10 AND @Old_MaxBetv10 = @MaxBetv10 AND @Old_MaxPerMatchv10 = @MaxPerMatchv10 AND
	@Old_MinBetv11 = @MinBetv11 AND @Old_MaxBetv11 = @MaxBetv11 AND @Old_MaxPerMatchv11 = @MaxPerMatchv11 AND
	@Old_MinBetv99 = @MinBetv99 AND @Old_MaxBetv99 = @MaxBetv99 AND @Old_MaxPerMatchv99 = @MaxPerMatchv99 AND
	@Old_MinBetv99MP = @MinBetv99MP AND @Old_MaxBetv99MP = @MaxBetv99MP AND @Old_MaxPerMatchv99MP = @MaxPerMatchv99MP AND
	@Old_MinBetv154 = @MinBetv154 AND @Old_MaxBetv154 = @MaxBetv154 AND @Old_MaxPerMatchv154 = @MaxPerMatchv154 AND
	@Old_MinBetv161 = @MinBetv161 AND @Old_MaxBetv161 = @MaxBetv161 AND @Old_MaxPerMatchv161 = @MaxPerMatchv161 AND
	@Old_MaxPerBallv161 = @MaxPerBallv161 AND @Old_MinBetv151 = @MinBetv151 AND @Old_MaxBetv151 = @MaxBetv151 AND 	@Old_MaxPerMatchv151 = @MaxPerMatchv151 AND	
	@Old_MinBetv151OT = @MinBetv151OT AND @Old_MaxBetv151OT = @MaxBetv151OT AND @Old_MaxPerMatchv151OT = @MaxPerMatchv151OT AND 
	@Old_MinBetv151_51 = @MinBetv151_51 AND @Old_MaxBetv151_51 = @MaxBetv151_51 AND @Old_MaxPerMatchv151_51 = @MaxPerMatchv151_51 AND 
	@Old_MinBetv152_41 = @MinBetv152_41 AND @Old_MaxBetv152_41 = @MaxBetv152_41 AND @Old_MaxPerMatchv152_41 = @MaxPerMatchv152_41 AND 
	@Old_MinBetv152_51 = @MinBetv152_51 AND @Old_MaxBetv152_51 = @MaxBetv152_51 AND @Old_MaxPerMatchv152_51 = @MaxPerMatchv152_51 AND 
	@Old_MinBetv153_51 = @MinBetv153_51 AND @Old_MaxBetv153_51 = @MaxBetv153_51 AND @Old_MaxPerMatchv153_51 = @MaxPerMatchv153_51 AND
	@Old_MinBetv180 = @MinBetv180 AND @Old_MaxBetv180 = @MaxBetv180 AND @Old_MaxPerMatchv180 = @MaxPerMatchv180 AND 
	@Old_MinBetv181 = @MinBetv181 AND @Old_MaxBetv181 = @MaxBetv181 AND @Old_MaxPerMatchv181 = @MaxPerMatchv181 AND 
	@Old_MinBetv182 = @MinBetv182 AND @Old_MaxBetv182 = @MaxBetv182 AND @Old_MaxPerMatchv182 = @MaxPerMatchv182 AND 
	@Old_MinBetv184 = @MinBetv184 AND @Old_MaxBetv184 = @MaxBetv184 AND @Old_MaxPerMatchv184 = @MaxPerMatchv184 AND 
	@Old_MinBetv186 = @MinBetv186 AND @Old_MaxBetv186 = @MaxBetv186 AND @Old_MaxPerMatchv186 = @MaxPerMatchv186 AND
	@Old_MinBetv202_1501 = @MinBetv202_1501 AND @Old_MaxBetv202_1501 = @MaxBetv202_1501 AND @Old_MaxPerMatchv202_1501 = @MaxPerMatchv202_1501
RETURN


--20110719@thien: temporarily bypass the racing checking for these sites below
declare @site varchar(20)
select @site = site from customer with (nolock) where custid = @recommend
if @site in ('TLC', 'Mayfair', 'Zzun88')
BEGIN
	SELECT @UpdateMinMaxBetv151 = 0,
		@UpdateMinMaxBetv151OT = 0,
		@UpdateMinMaxBetv151_51 = 0,
		@UpdateMinMaxBetv152_41 = 0,
		@UpdateMinMaxBetv152_51 = 0,
		@UpdateMinMaxBetv153_51 = 0
END
----------------------------------------

IF ISNULL(@roleid,0) <> 1
BEGIN
	SELECT @ErrMsg = CASE @Language 
						WHEN 'E' THEN 'Invalid user!!'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](40002,@Language)
					END	,
		@ErrCode = 100	
	RETURN
END

IF @UplineClosed = 1 
BEGIN
	SELECT @ErrMsg =  CASE @Language 
						WHEN 'E' THEN 'Your account was closed. Cannot edit member.'
						WHEN 'CS' THEN N'您的账号已关闭，无法更改会员.'
						WHEN 'CT' THEN N'您的帳戶已關閉. 無法更改會員.'
						WHEN 'TH' THEN N'บัญชีของคุณถูกระงับใช้ ไม่สามารถแก้ไข.'
						WHEN 'J' THEN N'貴方のアカウントは閉鎖されています。新規メンバーの受付はできません。'
						WHEN 'KO' THEN N'계정이용이 정지되었습니다. 회원정보를 수정 할 수 없습니다.'
						ELSE N'Your account was closed. Cannot edit member.'
					END, @ErrCode = 100
	RETURN
END 


----------------------------------------------
--Update MinBet, MaxBet, MaxPerMatch
----------------------------------------------
--Check Param
IF @UpdateMinMaxBet = 1 
BEGIN
	IF 
		@MinBet<0
		OR @MaxBet < 0
		OR @MaxPerMatch <0		
	BEGIN
		SELECT @ErrCode = 2
		SELECT @ErrMsg = 	CASE @Language 
							WHEN 'E' THEN 'Wrong Min bet/ Max bet/ Max per match (for Soccer).'
							WHEN 'CS' THEN N'最低投注/最高投注/单场最高投注不正确(于足球).'
							WHEN 'CT' THEN N'最低投注/最高投注/單場最高投注不正確(於足球).'
							WHEN 'TH' THEN N'การกำหนดจำนวนเงินสำหรับการวางเดิมพันต่ำสุด/ สูงสุด/สูงสดต่อรายการไม่ถูกต้อง (สำหรับกีฬาเทนนิส).'
							WHEN 'J' THEN N'Wrong Min bet/ Max bet/ Max per match (for Soccer).'
							WHEN 'KO' THEN N'잘못된 최소 배팅/최대 배팅/경기당 최대 (축구).'
							ELSE N'Wrong Min bet/ Max bet/ Max per match (for Soccer).'
					END
		RETURN
	END
END

IF @UpdateMinMaxBetv2 = 1 
BEGIN
	IF 
		@MinBetv2 <0
		OR @MaxBetv2 <0
		OR @MaxPerMatchv2 <0		
	BEGIN
		SELECT @ErrCode = 3
		SELECT @ErrMsg = 	CASE @Language 
							WHEN 'E' THEN 'Wrong Min bet/ Max bet/ Max per match (for Basketball).'
							WHEN 'CS' THEN N'最低投注/最高投注/单场最高投注不正确(于篮球).'
							WHEN 'CT' THEN N'最低投注/最高投注/單場最高投注不正確(於籃球).'
							WHEN 'TH' THEN N'การกำหนดจำนวนเงินสำหรับการวางเดิมพันต่ำสุด/ สูงสุด/สูงสดต่อรายการไม่ถูกต้อง (สำหรับกีฬาบาสเก็ตบอล).'
							WHEN 'J' THEN N'Wrong Min bet/ Max bet/ Max per match (for Basketball).'
							WHEN 'KO' THEN N'잘못된 최소 배팅/최대 배팅/경기당 최대 (농구).'
							ELSE N'Wrong Min bet/ Max bet/ Max per match (for Basketball).'
					END
		RETURN
	END
END

IF @UpdateMinMaxBetv3 = 1 
BEGIN
	IF 
		@MinBetv3 <0
		OR @MaxBetv3 <0
		OR @MaxPerMatchv3 <0		
	BEGIN
		SELECT @ErrCode = 3
		SELECT @ErrMsg = 	CASE @Language 
							WHEN 'E' THEN 'Wrong Min bet/ Max bet/ Max per match (for Football).'
							WHEN 'CS' THEN N'最低投注/最高投注/单场最高投注不正确(于美式足球).'
							WHEN 'CT' THEN N'最低投注/最高投注/單場最高投注不正確(於美式足球).'
							WHEN 'TH' THEN N'การกำหนดจำนวนเงินสำหรับการวางเดิมพันต่ำสุด/ สูงสุด/สูงสดต่อรายการไม่ถูกต้อง (สำหรับกีฬาอเมริกันฟุตบอล).'
							WHEN 'J' THEN N'Wrong Min bet/ Max bet/ Max per match (for Football).'
							WHEN 'KO' THEN N'잘못된 최소 배팅/최대 배팅/경기당 최대 (풋볼).'
							ELSE N'Wrong Min bet/ Max bet/ Max per match (for Football).'
					END
		RETURN
	END
END

IF @UpdateMinMaxBetv5 = 1
BEGIN
	IF 
		@MinBetv5 <0
		OR @MaxBetv5 <0
		OR @MaxPerMatchv5 <0		
	BEGIN
		SELECT @ErrCode = 3
		SELECT @ErrMsg = 	CASE @Language 
							WHEN 'E' THEN 'Wrong Min bet/ Max bet/ Max per match (for Tennis).'
							WHEN 'CS' THEN N'最低投注/最高投注/单场最高投注不正确(于网球).'
							WHEN 'CT' THEN N'最低投注/最高投注/單場最高投注不正確(於網球).'
							WHEN 'TH' THEN N'การกำหนดจำนวนเงินสำหรับการวางเดิมพันต่ำสุด/ สูงสุด/สูงสดต่อรายการไม่ถูกต้อง (สำหรับกีฬาเทนนิส).'
							WHEN 'J' THEN N'Wrong Min bet/ Max bet/ Max per match (for Tennis).'
							WHEN 'KO' THEN N'잘못된 최소 배팅/최대 배팅/경기당 최대 (테니스).'
							ELSE N'Wrong Min bet/ Max bet/ Max per match (for Tennis).'
					END
		RETURN
	END
END

IF @UpdateMinMaxBetv8 = 1 
BEGIN
	IF 
		@MinBetv8 <0
		OR @MaxBetv8 <0
		OR @MaxPerMatchv8 <0		
	BEGIN
		SELECT @ErrCode = 3
		SELECT @ErrMsg = 	CASE @Language 
							WHEN 'E' THEN 'Wrong Min bet/ Max bet/ Max per match (for Baseball).'
							WHEN 'CS' THEN N'最低投注/最高投注/单场最高投注不正确(于棒球).'
							WHEN 'CT' THEN N'最低投注/最高投注/單場最高投注不正確(於棒球).'
							WHEN 'TH' THEN N'การกำหนดจำนวนเงินสำหรับการวางเดิมพันต่ำสุด/ สูงสุด/สูงสดต่อรายการไม่ถูกต้อง (สำหรับกีฬาเบสบอล).'
							WHEN 'J' THEN N'Wrong Min bet/ Max bet/ Max per match (for Baseball).'
							WHEN 'KO' THEN N'잘못된 최소 배팅/최대 배팅/경기당 최대 (야구).'
							ELSE N'Wrong Min bet/ Max bet/ Max per match (for Baseball).'
					END
		RETURN
	END
END

IF @UpdateMinMaxBetv10 = 1 
BEGIN
	IF 
		@MinBetv10 <0
		OR @MaxBetv10 <0
		OR @MaxPerMatchv10 <0		
	BEGIN
		SELECT @ErrCode = 3
		SELECT @ErrMsg = 	CASE @Language 
							WHEN 'E' THEN 'Wrong Min bet/ Max bet/ Max per match (for Golf).'
							WHEN 'CS' THEN N'最低投注/最高投注/单场最高投注不正确(于高尔夫球).'
							WHEN 'CT' THEN N'最低投注/最高投注/單場最高投注不正確(於高爾夫球).'
							WHEN 'TH' THEN N'การกำหนดจำนวนเงินสำหรับการวางเดิมพันต่ำสุด/ สูงสุด/สูงสดต่อรายการไม่ถูกต้อง (สำหรับกีฬากอฟล์).'
							WHEN 'J' THEN N'Wrong Min bet/ Max bet/ Max per match (for Golf).'
							WHEN 'KO' THEN N'잘못된 최소 배팅/최대 배팅/경기당 최대 (골프).'
							ELSE N'Wrong Min bet/ Max bet/ Max per match (for Golf).'
					END
		RETURN
	END
END

IF @UpdateMinMaxBetv11 = 1 
BEGIN
	IF 
		@MinBetv11 <0
		OR @MaxBetv11 <0
		OR @MaxPerMatchv11 <0		
	BEGIN
		SELECT @ErrCode = 3
		SELECT @ErrMsg = 	CASE @Language 
							WHEN 'E' THEN 'Wrong Min bet/ Max bet/ Max per match (for Motorsports).'
							WHEN 'CS' THEN N'最低投注/最高投注/单场最高投注不正确(于赛车).'
							WHEN 'CT' THEN N'最低投注/最高投注/單場最高投注不正確(於賽車).'
							WHEN 'TH' THEN N'การกำหนดจำนวนเงินสำหรับการวางเดิมพันต่ำสุด/ สูงสุด/สูงสดต่อรายการไม่ถูกต้อง (สำหรับกีฬารถแข่ง).'
							WHEN 'J' THEN N'Wrong Min bet/ Max bet/ Max per match (for Motorsports).'
							WHEN 'KO' THEN N'잘못된 최소 배팅/최대 배팅/경기당 최대 (모토스포츠).'
							ELSE N'Wrong Min bet/ Max bet/ Max per match (for Motorsports).'
					END
		RETURN
	END
END

IF @UpdateMinMaxBetv99 = 1
BEGIN
	IF 
		@MinBetv99 <0
		OR @MaxBetv99 <0
		OR @MaxPerMatchv99 <0		
	BEGIN
		SELECT @ErrCode = 3
		SELECT @ErrMsg = 	CASE @Language 
							WHEN 'E' THEN 'Wrong Min bet/ Max bet/ Max per match (for Other sports).'
							WHEN 'CS' THEN N'最低投注/最高投注/单场最高投注不正确(于其他).'
							WHEN 'CT' THEN N'最低投注/最高投注/單場最高投注不正確(於其他).'
							WHEN 'TH' THEN N'การกำหนดจำนวนเงินสำหรับการวางเดิมพันต่ำสุด/ สูงสุด/สูงสดต่อรายการไม่ถูกต้อง (สำหรับกีฬาอื่นๆ).'
							WHEN 'J' THEN N'Wrong Min bet/ Max bet/ Max per match (for Other sports).'
							WHEN 'KO' THEN N'잘못된 최소 배팅/최대 배팅/경기당 최대 (기타 스포츠).'
							ELSE N'Wrong Min bet/ Max bet/ Max per match (for Other sports).'
					END
		RETURN
	END
END

IF @UpdateMinMaxBetv99MP = 1
BEGIN
	IF 
		@MinBetv99MP <0
		OR @MaxBetv99MP <0
		OR @MaxPerMatchv99MP <0		
	BEGIN
		SELECT @ErrCode = 3
		SELECT @ErrMsg = 	CASE @Language 
							WHEN 'E' THEN 'Wrong Min bet/ Max bet/ Max per match (for Mix Sports Parlay).'
							WHEN 'CS' THEN N'最低投注/最高投注/单场最高投注不正确(供混合体育过关).'
							WHEN 'CT' THEN N'最低投注/最高投注/單場最高投注不正確(供混合體育過關).'
							WHEN 'TH' THEN N'การกำหนดจำนวนเงินสำหรับการวางเดิมพันต่ำสุด/ สูงสุด/สูงสดต่อรายการไม่ถูกต้อง (สำหรับกีฬาบอลชุด).'
							WHEN 'J' THEN N'Wrong Min bet/ Max bet/ Max per match (for Mix Sports Parlay).'
							WHEN 'KO' THEN N'잘못된 최소 배팅/최대 배팅/경기당 최대 (for Mix Sports Parlay).'
							ELSE N'Wrong Min bet/ Max bet/ Max per match (for Mix Sports Parlay).'
					END
		RETURN
	END
END

IF @UpdateMinMaxBetv154 = 1
BEGIN
	IF 
		@MinBetv154 <0
		OR @MaxBetv154 <0
		OR @MaxPerMatchv154 <0		
	BEGIN
		SELECT @ErrCode = 3
		SELECT @ErrMsg = 	CASE @Language 
							WHEN 'E' THEN 'Wrong Min bet/ Max bet/ Max per match (for HR Fixed Odds).'
							WHEN 'CS' THEN N'最低投注/最高投注/单场最高投注不正确(赛马固定赔率).'
							WHEN 'CT' THEN N'最低投注/最高投注/單場最高投注不正確(賽馬固定賠率).'
							WHEN 'TH' THEN N'การกำหนดจำนวนเงินสำหรับการวางเดิมพันต่ำสุด/ สูงสุด/สูงสดต่อรายการไม่ถูกต้อง (Horse Racing Fixed Odds).'
							WHEN 'J' THEN N'Wrong Min bet/ Max bet/ Max per match (for HR Fixed Odds).'
							WHEN 'KO' THEN N'잘못된 최소 배팅/최대 배팅/경기당 최대 (Horse Racing Fixed Odds).'
							ELSE N'Wrong Min bet/ Max bet/ Max per match (for HR Fixed Odds).'
					END
		RETURN
	END
END

IF @UpdateMinMaxBetv151 = 1
BEGIN
	IF 
		@MinBetv151 <0
		OR @MaxBetv151 <0
		OR @MaxPerMatchv151 <0		
	BEGIN
		SELECT @ErrCode = 3
		SELECT @ErrMsg = 	CASE @Language 
							WHEN 'E' THEN 'Wrong Min bet/ Max bet/ Max per match (for Horse Racing SA Tote).'
							WHEN 'CS' THEN N'最低投注/最高投注/单场最高投注不正确 (於南非彩池).'
							WHEN 'CT' THEN N'最低投注/最高投注/單場最高投注不正確 (於南非彩池).'
							WHEN 'TH' THEN N'การกำหนดจำนวนเงินสำหรับการวางเดิมพันต่ำสุด/ สูงสุด/สูงสดต่อรายการไม่ถูกต้อง (สำหรับม้าแข่งแอฟริกาใต้ ยอดรวม).'
							WHEN 'J' THEN N'Wrong Min bet/ Max bet/ Max per match (for Horse Racing SA Tote).'
							WHEN 'KO' THEN N'잘못된 최소 배팅/최대 배팅/경기당 최대 (for Horse Racing SA Tote).'
							ELSE N'Wrong Min bet/ Max bet/ Max per match (for Horse Racing SA Tote).'
					END
		RETURN
	END
END

IF @UpdateMinMaxBetv151OT = 1
BEGIN
	IF 
		@MinBetv151OT <0
		OR @MaxBetv151OT <0
		OR @MaxPerMatchv151OT <0		
	BEGIN
		SELECT @ErrCode = 3
		SELECT @ErrMsg = 	CASE @Language 
							WHEN 'E' THEN 'Wrong Min bet/ Max bet/ Max per match (for Horse Racing UK Tote).'
							WHEN 'CS' THEN N'最低投注/最高投注/单场最高投注不正确 (於英国彩池).'
							WHEN 'CT' THEN N'最低投注/最高投注/單場最高投注不正確 (於英國彩池).'
							WHEN 'TH' THEN N'การกำหนดจำนวนเงินสำหรับการวางเดิมพันต่ำสุด/ สูงสุด/สูงสดต่อรายการไม่ถูกต้อง (สำหรับม้าแข่งสหราชอาณาจักร ยอดรวม).'
							WHEN 'J' THEN N'Wrong Min bet/ Max bet/ Max per match (for Horse Racing UK Tote).'
							WHEN 'KO' THEN N'잘못된 최소 배팅/최대 배팅/경기당 최대 (for Horse Racing UK Tote).'
							ELSE N'Wrong Min bet/ Max bet/ Max per match (for Horse Racing UK Tote).'
					END
		RETURN
	END
END


IF @UpdateMinMaxBetv151_51 = 1
BEGIN
	IF 
		@MinBetv151_51 <0
		OR @MaxBetv151_51 <0
		OR @MaxPerMatchv151_51 <0		
	BEGIN
		SELECT @ErrCode = 3
		SELECT @ErrMsg = 	CASE @Language 
							WHEN 'E' THEN 'Wrong Min bet/ Max bet/ Max per match (for Horse Racing AU Tote).'
							WHEN 'CS' THEN N'最低投注/最高投注/单场最高投注不正确 (for Horse Racing AU Tote).'
							WHEN 'CT' THEN N'最低投注/最高投注/單場最高投注不正確 (for Horse Racing AU Tote).'
							WHEN 'TH' THEN N'การกำหนดจำนวนเงินสำหรับการวางเดิมพันต่ำสุด/ สูงสุด/สูงสดต่อรายการไม่ถูกต้อง (for Horse Racing AU Tote).'
							WHEN 'J' THEN N'Wrong Min bet/ Max bet/ Max per match (for Horse Racing AU Tote).'
							WHEN 'KO' THEN N'잘못된 최소 배팅/최대 배팅/경기당 최대 (for Horse Racing AU Tote).'
							ELSE N'Wrong Min bet/ Max bet/ Max per match (for Horse Racing AU Tote).'
					END
		RETURN
	END
END

IF @UpdateMinMaxBetv152_41 = 1
BEGIN
	IF 
		@MinBetv152_41 <0
		OR @MaxBetv152_41 <0
		OR @MaxPerMatchv152_41 <0		
	BEGIN
		SELECT @ErrCode = 3
		SELECT @ErrMsg = 	CASE @Language 
							WHEN 'E' THEN 'Wrong Min bet/ Max bet/ Max per match (for Greyhound Racing UK Tote).'
							WHEN 'CS' THEN N'最低投注/最高投注/单场最高投注不正确 (for Greyhound Racing UK Tote).'
							WHEN 'CT' THEN N'最低投注/最高投注/單場最高投注不正確 (for Greyhound Racing UK Tote).'
							WHEN 'TH' THEN N'การกำหนดจำนวนเงินสำหรับการวางเดิมพันต่ำสุด/ สูงสุด/สูงสดต่อรายการไม่ถูกต้อง (for Greyhound Racing UK Tote).'
							WHEN 'J' THEN N'Wrong Min bet/ Max bet/ Max per match (for Greyhound Racing UK Tote).'
							WHEN 'KO' THEN N'잘못된 최소 배팅/최대 배팅/경기당 최대 (for Greyhound Racing UK Tote).'
							ELSE N'Wrong Min bet/ Max bet/ Max per match (for Greyhound Racing UK Tote).'
					END
		RETURN
	END
END

IF @UpdateMinMaxBetv152_51 = 1
BEGIN
	IF 
		@MinBetv152_51 <0
		OR @MaxBetv152_51 <0
		OR @MaxPerMatchv152_51 <0		
	BEGIN
		SELECT @ErrCode = 3
		SELECT @ErrMsg = 	CASE @Language 
							WHEN 'E' THEN 'Wrong Min bet/ Max bet/ Max per match (for Greyhound Racing AU Tote).'
							WHEN 'CS' THEN N'最低投注/最高投注/单场最高投注不正确 (for Greyhound Racing AU Tote).'
							WHEN 'CT' THEN N'最低投注/最高投注/單場最高投注不正確 (for Greyhound Racing AU Tote).'
							WHEN 'TH' THEN N'การกำหนดจำนวนเงินสำหรับการวางเดิมพันต่ำสุด/ สูงสุด/สูงสดต่อรายการไม่ถูกต้อง (for Greyhound Racing AU Tote).'
							WHEN 'J' THEN N'Wrong Min bet/ Max bet/ Max per match (for Greyhound Racing AU Tote).'
							WHEN 'KO' THEN N'잘못된 최소 배팅/최대 배팅/경기당 최대 (for Greyhound Racing AU Tote).'
							ELSE N'Wrong Min bet/ Max bet/ Max per match (for Greyhound Racing AU Tote).'
					END
		RETURN
	END
END

IF @UpdateMinMaxBetv153_51 = 1
BEGIN
	IF 
		@MinBetv153_51 <0
		OR @MaxBetv153_51 <0
		OR @MaxPerMatchv153_51 <0		
	BEGIN
		SELECT @ErrCode = 3
		SELECT @ErrMsg = 	CASE @Language 
							WHEN 'E' THEN 'Wrong Min bet/ Max bet/ Max per match (for Harness Racing AU Tote).'
							WHEN 'CS' THEN N'最低投注/最高投注/单场最高投注不正确 (for Harness Racing AU Tote).'
							WHEN 'CT' THEN N'最低投注/最高投注/單場最高投注不正確 (for Harness Racing AU Tote).'
							WHEN 'TH' THEN N'การกำหนดจำนวนเงินสำหรับการวางเดิมพันต่ำสุด/ สูงสุด/สูงสดต่อรายการไม่ถูกต้อง (for Harness Racing AU Tote).'
							WHEN 'J' THEN N'Wrong Min bet/ Max bet/ Max per match (for Harness Racing AU Tote).'
							WHEN 'KO' THEN N'잘못된 최소 배팅/최대 배팅/경기당 최대 (for Harness Racing AU Tote).'
							ELSE N'Wrong Min bet/ Max bet/ Max per match (for Harness Racing AU Tote).'
					END
		RETURN
	END
END


IF @UpdateMinMaxBetv161 = 1
BEGIN
	IF 
		@MinBetv161 <0
		OR @MaxBetv161 <0
		OR @MaxPerMatchv161 <0
		OR @MaxPerBallv161 < 0		
	BEGIN
		SELECT @ErrCode = 3
		SELECT @ErrMsg = 	CASE @Language 
							WHEN 'E' THEN 'Wrong Min bet/ Max bet/ Max per match/ Max per ball(for Number Game).'
							WHEN 'CS' THEN N'最低投注/最高投注/单粒球最高投注/单场游戏最高投注设置错误.'
							WHEN 'CT' THEN N'最低投注/最高投注/單粒球最高投注/單場遊戲最高投注設置錯誤.'
							WHEN 'TH' THEN N'เดิมพันขั้นต่ำผิด / เดิมพันสูงสุด /  เดิมพันสูงสุดต่อการแข่งขัน /  เดิมพันสูงสุดต่อลูก.'
							WHEN 'J' THEN N'Wrong Min bet/ Max bet/ Max per match/ Max per ball(for Number Game)..'
							WHEN 'KO' THEN N'잘못된 최소 배팅/최대 배팅/경기당 최대 (for Number Game).'
							ELSE N'Wrong Min bet/ Max bet/ Max per match/ Max per ball (for Number Game).'
					END
		RETURN
	END
END

IF @UpdateMinMaxBetv180 = 1 
BEGIN
	IF 
		@MinBetv180<0
		OR @MaxBetv180 < 0
		OR @MaxPerMatchv180 <0		
	BEGIN
		SELECT @ErrCode = 3
		SELECT @ErrMsg = 	CASE @Language 
							WHEN 'E' THEN 'Wrong Min bet/ Max bet/ Max per match (for Virtual Soccer).'
							WHEN 'CS' THEN N'最低投注/最高投注/单场最高投注不正确.'
							WHEN 'CT' THEN N'最低投注/最高投注/單場最高投注不正確.'
							WHEN 'TH' THEN N'การกำหนดจำนวนเงินสำหรับการวางเดิมพันต่ำสุด/ สูงสุด/สูงสดต่อรายการไม่ถูกต้อง.'
							WHEN 'J' THEN N'Wrong Min bet/ Max bet/ Max per match (for Virtual Soccer).'
							WHEN 'KO' THEN N'잘못된 최소 배팅/최대 배팅/경기당 최대 (for Virtual Soccer).'
							ELSE N'Wrong Min bet/ Max bet/ Max per match (for Virtual Soccer).'
					END
		RETURN
	END
END

IF @UpdateMinMaxBetv181 = 1 
BEGIN
	IF 
		@MinBetv181<0
		OR @MaxBetv181 < 0
		OR @MaxPerMatchv181 <0		
	BEGIN
		SELECT @ErrCode = 3
		SELECT @ErrMsg = 	CASE @Language 
							WHEN 'E' THEN 'Wrong Min bet/ Max bet/ Max per match (for Virtual Horse Racing).'
							WHEN 'CS' THEN N'最低投注/最高投注/单场最高投注不正确.'
							WHEN 'CT' THEN N'最低投注/最高投注/單場最高投注不正確.'
							WHEN 'TH' THEN N'การกำหนดจำนวนเงินสำหรับการวางเดิมพันต่ำสุด/ สูงสุด/สูงสดต่อรายการไม่ถูกต้อง.'
							WHEN 'J' THEN N'Wrong Min bet/ Max bet/ Max per match (for Virtual Horse Racing).'
							WHEN 'KO' THEN N'잘못된 최소 배팅/최대 배팅/경기당 최대 (for Virtual Horse Racing).'
							ELSE N'Wrong Min bet/ Max bet/ Max per match (for Virtual Horse Racing).'
					END
		RETURN
	END
END

IF @UpdateMinMaxBetv182 = 1 
BEGIN
	IF 
		@MinBetv182<0
		OR @MaxBetv182 < 0
		OR @MaxPerMatchv182 <0		
	BEGIN
		SELECT @ErrCode = 3
		SELECT @ErrMsg = 	CASE @Language 
							WHEN 'E' THEN 'Wrong Min bet/ Max bet/ Max per match (for Virtual Greyhounds).'
							WHEN 'CS' THEN N'最低投注/最高投注/单场最高投注不正确.'
							WHEN 'CT' THEN N'最低投注/最高投注/單場最高投注不正確.'
							WHEN 'TH' THEN N'การกำหนดจำนวนเงินสำหรับการวางเดิมพันต่ำสุด/ สูงสุด/สูงสดต่อรายการไม่ถูกต้อง.'
							WHEN 'J' THEN N'Wrong Min bet/ Max bet/ Max per match (for Virtual Greyhounds).'
							WHEN 'KO' THEN N'잘못된 최소 배팅/최대 배팅/경기당 최대 (for Virtual Greyhounds).'
							ELSE N'Wrong Min bet/ Max bet/ Max per match (for Virtual Greyhounds).'
					END
		RETURN
	END
END

IF @UpdateMinMaxBetv184 = 1 
BEGIN
	IF 
		@MinBetv184<0
		OR @MaxBetv184 < 0
		OR @MaxPerMatchv184 <0		
	BEGIN
		SELECT @ErrCode = 3
		SELECT @ErrMsg = 	CASE @Language 
							WHEN 'E' THEN 'Wrong Min bet/ Max bet/ Max per match (for Virtual Motor Racing).'
							WHEN 'CS' THEN N'最低投注/最高投注/单场最高投注不正确.'
							WHEN 'CT' THEN N'最低投注/最高投注/單場最高投注不正確.'
							WHEN 'TH' THEN N'การกำหนดจำนวนเงินสำหรับการวางเดิมพันต่ำสุด/ สูงสุด/สูงสดต่อรายการไม่ถูกต้อง.'
							WHEN 'J' THEN N'Wrong Min bet/ Max bet/ Max per match (for Virtual Motor Racing).'
							WHEN 'KO' THEN N'잘못된 최소 배팅/최대 배팅/경기당 최대 (for Virtual Motor Racing).'
							ELSE N'Wrong Min bet/ Max bet/ Max per match (for Virtual Motor Racing).'
					END
		RETURN
	END
END

IF @UpdateMinMaxBetv186 = 1 
BEGIN
	IF 
		@MinBetv186<0
		OR @MaxBetv186 < 0
		OR @MaxPerMatchv186 <0		
	BEGIN
		SELECT @ErrCode = 3
		SELECT @ErrMsg = 	CASE @Language 
							WHEN 'E' THEN 'Wrong Min bet/ Max bet/ Max per match (for Virtual Tennis).'
							WHEN 'CS' THEN N'最低投注/最高投注/单场最高投注不正确.'
							WHEN 'CT' THEN N'最低投注/最高投注/單場最高投注不正確.'
							WHEN 'TH' THEN N'การกำหนดจำนวนเงินสำหรับการวางเดิมพันต่ำสุด/ สูงสุด/สูงสดต่อรายการไม่ถูกต้อง.'
							WHEN 'J' THEN N'Wrong Min bet/ Max bet/ Max per match (for Virtual Tennis).'
							WHEN 'KO' THEN N'잘못된 최소 배팅/최대 배팅/경기당 최대 (for Virtual Tennis).'
							ELSE N'Wrong Min bet/ Max bet/ Max per match (for Virtual Tennis).'
					END
		RETURN
	END
END

IF @UpdateMinMaxBetv202 = 1
BEGIN
	IF 
		@MinBetv202_1501 <0
		OR @MaxBetv202_1501 <0
		OR @MaxPerMatchv202_1501 <0		
	BEGIN
		SELECT @ErrCode = 3
		SELECT @ErrMsg = 	CASE @Language 
							WHEN 'E' THEN 'Wrong Min bet/ Max bet/ Max per match (for Keno).'
							WHEN 'CS' THEN N'最低投注/最高投注/单场最高投注不正确.'
							WHEN 'CT' THEN N'最低投注/最高投注/單場最高投注不正確.'
							WHEN 'TH' THEN N'การกำหนดจำนวนเงินสำหรับการวางเดิมพันต่ำสุด/ สูงสุด/สูงสดต่อรายการไม่ถูกต้อง (Keno).'
							WHEN 'J' THEN N'Wrong Min bet/ Max bet/ Max per match (for Keno).'
							WHEN 'KO' THEN N'잘못된 최소 배팅/최대 배팅/경기당 최대 (Keno).'
							ELSE N'Wrong Min bet/ Max bet/ Max per match (for Keno).'
					END
		RETURN
	END
END

SELECT
	@MinMinBet = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END), 
	@MaxMaxBet = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END)
FROM 
	Dep_CustSetting AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.Recommend OR cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend)
	AND cs.bettype = 1 AND cs.sporttype=1
WHERE ci.custid = @recommend

SELECT 
	@MinMinBetv2 = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END), 
	@MaxMaxBetv2 = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END)
FROM 
	Dep_CustSetting AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.Recommend OR cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend)
	AND cs.bettype = 1 AND cs.sporttype=2
WHERE ci.custid = @recommend

SELECT 
	@MinMinBetv3 = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END), 
	@MaxMaxBetv3 = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END)
FROM 
	Dep_CustSetting AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.Recommend OR cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend)
	AND cs.bettype = 1 AND cs.sporttype=3
WHERE ci.custid = @recommend

SELECT 
	@MinMinBetv5 = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END), 
	@MaxMaxBetv5 = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END)
FROM 
	Dep_CustSetting AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.Recommend OR cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend)
	AND cs.bettype = 1 AND cs.sporttype=5
WHERE ci.custid = @recommend

SELECT 
	@MinMinBetv8 = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END), 
	@MaxMaxBetv8 = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END)
FROM 
	Dep_CustSetting AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.Recommend OR cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend)
	AND cs.bettype = 1 AND cs.sporttype=8
WHERE ci.custid = @recommend

SELECT 
	@MinMinBetv10 = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END), 
	@MaxMaxBetv10 = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END)
FROM 
	Dep_CustSetting AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.Recommend OR cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend)
	AND cs.bettype = 1 AND cs.sporttype=10
WHERE ci.custid = @recommend

SELECT 
	@MinMinBetv11 = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END), 
	@MaxMaxBetv11 = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END)
FROM 
	Dep_CustSetting AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.Recommend OR cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend)
	AND cs.bettype = 1 AND cs.sporttype=11
WHERE ci.custid = @recommend

SELECT 
	@MinMinBetv99 = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END), 
	@MaxMaxBetv99 = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END)
FROM 
	Dep_CustSetting AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.Recommend OR cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend)
	AND cs.bettype = 1 AND cs.sporttype=99
WHERE ci.custid = @recommend

SELECT
	@MinMinBetv99MP = MAX(CASE WHEN MinBet =0 THEN NULL ELSE MinBet END),
	@MaxMaxBetv99MP = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END)
FROM
	Dep_CustSetting AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.Recommend OR cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend)	
	AND cs.bettype = 9 AND cs.sporttype = 99
WHERE ci.custid = @recommend	

SELECT 
	@MinMinBetv154 = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END), 
	@MaxMaxBetv154 = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END)
FROM 
	Dep_CustSetting AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.Recommend OR cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend)
	AND cs.bettype = 20 AND cs.sporttype=154
WHERE ci.custid = @recommend
	
SELECT 
	@MinMinBetv151 = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END), 
	@MaxMaxBetv151 = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END)
FROM 
	Dep_CustSetting3rd AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.Recommend OR cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend)
	AND cs.bettype = 31 AND cs.sporttype=151
WHERE ci.custid = @recommend

SELECT 
	@MinMinBetv151OT = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END), 
	@MaxMaxBetv151OT = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END)
FROM 
	Dep_CustSetting3rd AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.Recommend OR cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend)
	AND cs.bettype = 41 AND cs.sporttype=151
WHERE ci.custid = @recommend

SELECT 
	@MinMinBetv151_51 = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END), 
	@MaxMaxBetv151_51 = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END)
FROM 
	Dep_CustSetting3rd AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.Recommend OR cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend)
	AND cs.bettype = 51 AND cs.sporttype=151
WHERE ci.custid = @recommend

SELECT 
	@MinMinBetv152_41 = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END), 
	@MaxMaxBetv152_41 = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END)
FROM 
	Dep_CustSetting3rd AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.Recommend OR cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend)
	AND cs.bettype = 41 AND cs.sporttype=152
WHERE ci.custid = @recommend

SELECT 
	@MinMinBetv152_51 = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END), 
	@MaxMaxBetv152_51 = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END)
FROM 
	Dep_CustSetting3rd AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.Recommend OR cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend)
	AND cs.bettype = 51 AND cs.sporttype=152
WHERE ci.custid = @recommend

SELECT 
	@MinMinBetv153_51 = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END), 
	@MaxMaxBetv153_51 = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END)
FROM 
	Dep_CustSetting3rd AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.Recommend OR cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend)
	AND cs.bettype = 51 AND cs.sporttype=153
WHERE ci.custid = @recommend


SELECT 
	@MinMinBetv161 = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END),
	@MaxMaxBetv161 = MIN(Case WHEN MaxBet = 0 THEN NULL ELSE MaxBet END)	
FROM
	Dep_CustSetting3rd AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.Recommend OR cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend)	 
	AND cs.sporttype = 161 AND cs.bettype = 81
WHERE ci.custid = @recommend	
	
SELECT 
	@MinMinBetv180 = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END), 
	@MaxMaxBetv180 = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END)
FROM 
	Dep_CustSetting3rd AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.Recommend OR cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend)
	AND cs.bettype = 1201 AND cs.sporttype=180
WHERE ci.custid = @recommend

SELECT 
	@MinMinBetv181 = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END), 
	@MaxMaxBetv181 = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END)
FROM 
	Dep_CustSetting3rd AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.Recommend OR cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend)
	AND cs.bettype = 1231 AND cs.sporttype=181
WHERE ci.custid = @recommend
	
SELECT 
	@MinMinBetv182 = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END), 
	@MaxMaxBetv182 = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END)
FROM 
	Dep_CustSetting3rd AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.Recommend OR cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend)
	AND cs.bettype = 1231 AND cs.sporttype=182
WHERE ci.custid = @recommend
	
SELECT 
	@MinMinBetv184 = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END), 
	@MaxMaxBetv184 = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END)
FROM 
	Dep_CustSetting3rd AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.Recommend OR cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend)
	AND cs.bettype = 1231 AND cs.sporttype=184
WHERE ci.custid = @recommend

SELECT 
	@MinMinBetv186 = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END), 
	@MaxMaxBetv186 = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END)
FROM 
	Dep_CustSetting3rd AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.Recommend OR cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend)
	AND cs.bettype = 1220 AND cs.sporttype=186
WHERE ci.custid = @recommend

SELECT 
	@MinMinBetv202_1501 = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END), 
	@MaxMaxBetv202_1501 = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END),
	@MaxMaxPerMatchv202_1501 = MIN(CASE WHEN MaxPerGameType = 0 THEN NULL ELSE cg.MaxPerGameType END)
FROM 
	CustGameType AS cg WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cg.CustID = ci.Recommend OR cg.CustID = ci.MRecommend OR cg.CustID = ci.SRecommend)
	INNER JOIN bodb02.dbo.GameType gt WITH (NOLOCK) ON cg.GameTypeID = gt.GameTypeID
WHERE ci.custid = @recommend AND gt.IBCBetTypeID = 1501 
	
SELECT 
	@MaxMaxperMatch = MIN(CASE WHEN cs.MaxPerMatch = 0 THEN NULL ELSE cs.MaxPerMatch END), 
	@MaxMaxPerMatchv2 = MIN(CASE WHEN cs.MaxPerMatch2 = 0 THEN NULL ELSE cs.MaxPerMatch2 END), 
	@MaxMaxPerMatchv3 = MIN(CASE WHEN cs.MaxPerMatch3 = 0 THEN NULL ELSE cs.MaxPerMatch3 END), 
	@MaxMaxPerMatchv5 = MIN(CASE WHEN cs.MaxPerMatch5 = 0 THEN NULL ELSE cs.MaxPerMatch5 END), 
	@MaxMaxPerMatchv8 = MIN(CASE WHEN cs.MaxPerMatch8 = 0 THEN NULL ELSE cs.MaxPerMatch8 END), 
	@MaxMaxPerMatchv10 = MIN(CASE WHEN cs.MaxPerMatch10 = 0 THEN NULL ELSE cs.MaxPerMatch10 END), 
	@MaxMaxPerMatchv11 = MIN(CASE WHEN cs.MaxPerMatch11 = 0 THEN NULL ELSE cs.MaxPerMatch11 END), 	
	@MaxMaxPerMatchv99 = MIN(CASE WHEN cs.MaxPerMatch99 = 0 THEN NULL ELSE cs.MaxPerMatch99 END),
	@MaxMaxPerMatchv99MP = MIN (CASE WHEN cs.MaxPerMatch99MP = 0 THEN NULL ELSE cs.MaxPerMatch99MP END),
	@MaxMaxPerMatchv154 = MIN(CASE WHEN cs.MaxPerMatch154 = 0 THEN NULL ELSE cs.MaxPerMatch154 END),
	
	@MaxMaxPerMatchv151 = MIN(CASE WHEN cs.MaxPerMatch151 = 0 THEN NULL ELSE cs.MaxPerMatch151 END),
	@MaxMaxPerMatchv151OT = MIN(CASE WHEN cs.MaxPerMatch151_OT = 0 THEN NULL ELSE cs.MaxPerMatch151_OT END),
	@MaxMaxPerMatchv151_51 = MIN(CASE WHEN cs.MaxPerMatch151_AU = 0 THEN NULL ELSE cs.MaxPerMatch151_AU END),
	@MaxMaxPerMatchv152_41 = MIN(CASE WHEN cs.MaxPerMatch152_UK = 0 THEN NULL ELSE cs.MaxPerMatch152_UK END),
	@MaxMaxPerMatchv152_51 = MIN(CASE WHEN cs.MaxPerMatch152_AU = 0 THEN NULL ELSE cs.MaxPerMatch152_AU END),
	@MaxMaxPerMatchv153_51 = MIN(CASE WHEN cs.MaxPerMatch153_AU = 0 THEN NULL ELSE cs.MaxPerMatch153_AU END),
	@MaxMaxPerMatchv161 = MIN(CASE WHEN cs.MaxPerMatch161 = 0 THEN NULL ELSE cs.MaxPerMatch161 END),
	@MaxMaxPerBallv161 = MIN(CASE WHEN cs.MaxPerBall161 =0 THEN NULL ELSE cs.MaxPerBall161 END),
	@MaxMaxperMatchv180 = MIN(CASE WHEN cs.MaxPerMatch180 = 0 THEN NULL ELSE cs.MaxPerMatch180 END),
	@MaxMaxperMatchv181 = MIN(CASE WHEN cs.MaxPerMatch181 = 0 THEN NULL ELSE cs.MaxPerMatch181 END),
	@MaxMaxperMatchv182 = MIN(CASE WHEN cs.MaxPerMatch182 = 0 THEN NULL ELSE cs.MaxPerMatch182 END),
	@MaxMaxperMatchv184 = MIN(CASE WHEN cs.MaxPerMatch184 = 0 THEN NULL ELSE cs.MaxPerMatch184 END),
	@MaxMaxperMatchv186 = MIN(CASE WHEN cs.MaxPerMatch186 = 0 THEN NULL ELSE cs.MaxPerMatch186 END)
FROM 
	custinfo AS cs WITH (NOLOCK) 
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.Recommend OR cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend)
WHERE ci.custid = @recommend

--20110719@Jamie: Do not update if Member's Min Bet < Agent's Min Bet for Racing Products
IF @site IN ('mansion88')
BEGIN
	IF @MinBetv151 < @MinMinBetv151 
		SELECT	@UpdateMinMaxBetv151 = 0 

	IF @MinBetv151OT < @MinMinBetv151OT 
		SELECT	@UpdateMinMaxBetv151OT = 0 

	IF @MinBetv151_51 < @MinMinBetv151_51
		SELECT	@UpdateMinMaxBetv151_51 = 0

	IF @MinBetv152_41 < @MinMinBetv152_41
		SELECT	@UpdateMinMaxBetv152_41 = 0

	IF @MinBetv152_51 < @MinMinBetv152_51
		SELECT	@UpdateMinMaxBetv152_51 = 0

	IF @MinBetv153_51 < @MinMinBetv153_51
		SELECT	@UpdateMinMaxBetv153_51 = 0

END

IF @UpdateMinMaxBet = 1
BEGIN
	IF ((@MinBet<>0 OR @MaxBet<>0 OR @MaxPerMatch<>0) AND (@MinBet>@MaxBet OR @MaxBet>@MaxPerMatch))
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be less than max bet and max bet must be less than max bet per match'
							WHEN 'CS' THEN N'最低投注不能高于最高投注，最高投注不能高于单场最高投注设定'
							WHEN 'CT' THEN N'最低投注不能高於最高投注,最高投注不能高於單場最高投注設定'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดที่วางเดิมพันได้ต้องน้อยกว่าจำนวนเงินสูงสุดในการวางเดิมพันและจำนวนเงินสูงสุดในการวางเดิมพันต้องน้อยกว่าจำนวนเงินสูงสุดของเงินเดิมพันต่อเกม.'
							WHEN 'J' THEN N'Min bet must be less than max bet and max bet must be less than max bet per match'
							WHEN 'KO' THEN N'최소 배팅은 최대 배팅 이하이여야 하고 최대 배팅은 경기당 최대 배팅보다 작아야 합니다.'
							ELSE N'Min bet must be less than max bet and max bet must be less than max bet per match'
						END						
						+ CHAR(13) + CHAR(10) + CONVERT(VARCHAR(20), @MinBet) + '-' + CONVERT(VARCHAR(20), @MaxBet) + '-' + CONVERT(VARCHAR(20), @MaxPerMatch), @ErrCode = 108
			
		RETURN
		
	END
	
	IF (@MinMinBet>0 AND @MinBet>0 AND @MinBet<@MinMinBet)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': ' +
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be equal to or greater than Agent min bet'
							WHEN 'CS' THEN N'最低投注需相等于或少于代理最低投注'
							WHEN 'CT' THEN N'最低投注需相等於或少於代理最低投注'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดในการเล่นต้องเท่ากับหรือมากกว่าจำนวนเงินขั้นต่ำในการเล่นที่กำหนดไว้ของตัวแทน'
							WHEN 'J' THEN N'Min bet must be equal to or greater than Agent min bet'
							WHEN 'KO' THEN N'최소 배팅은 에이전트의 최소 배팅 이상이여야 합니다.'
							ELSE N'Min bet must be equal to or greater than Agent min bet'
						END						
						+' (' + CONVERT(VARCHAR(20), @MinMinBet) + ').', @ErrCode = 109
				
		RETURN
	END
	
	IF (@MaxMaxBet>0 AND @MaxBet>0 AND @MaxBet>@MaxMaxBet)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max bet must be equal to or less than Agent max bet'
							WHEN 'CS' THEN N'最高投注需相等于或少于代理最高投注'
							WHEN 'CT' THEN N'最高投注需相等於或少於代理最高投注'
							WHEN 'TH' THEN N'จำนวนการวางเดิมพันสูงสุดต้องเท่ากับ หรือ น้อยกว่าราคาเดิมพันสูงสุดของตัวแทน '
							WHEN 'J' THEN N'Max bet must be equal to or less than Agent max bet'
							WHEN 'KO' THEN N'최대 배팅은 에이전트의 최대 배팅 이하이여야 합니다.'
							ELSE N'Max bet must be equal to or less than Agent max bet'
						END						
						+'(' + CONVERT(VARCHAR(20), @MaxMaxBet) + ').', @ErrCode = 110
				
		RETURN
	END
	
	IF (@MaxMaxPerMatch>0 AND @MaxPerMatch>0 AND @MaxPerMatch>@MaxMaxPerMatch)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max Per Match must be equal to or less than Agent Max Per Match'
							WHEN 'CS' THEN N'单场最高投注需相等于或少于代理单场最高投注'
							WHEN 'CT' THEN N'單場最高投注需相等於或少於代理單場最高投注'
							WHEN 'TH' THEN N'จำนวนเงินสูงสุดในการเล่นต่อรายการต้องเท่ากับหรือน้อยกว่าจำนวนเงินสูงสุดต่อรายการที่กำหนดไว้ของตัวแทน  '
							WHEN 'J' THEN N'Max Per Match must be equal to or less than Agent Max Per Match'
							WHEN 'KO' THEN N'최대 경기는 에이전트의 최대 경기보다 작아야 합니다.'
							ELSE N'Max Per Match must be equal to or less than Agent Max Per Match'
						END						
						+'(' + CONVERT(VARCHAR(20), @MaxMaxPerMatch) + ').', @ErrCode = 110
				
		RETURN
	END

END

IF @UpdateMinMaxBetv2 = 1
BEGIN
	IF ((@MinBetv2<>0 OR @MaxBetv2<>0 OR @MaxPerMatchv2<>0) AND (@MinBetv2>@MaxBetv2 OR @MaxBetv2>@MaxPerMatchv2))
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be less than max bet and max bet must be less than max bet per match (for Basketball)'
							WHEN 'CS' THEN N'最低投注不能高于最高投注，最高投注不能高于单场最高投注设定(于篮球)'
							WHEN 'CT' THEN N'最低投注不能高於最高投注,最高投注不能高於單場最高投注設定(於籃球)'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดที่วางเดิมพันได้ต้องน้อยกว่าจำนวนเงินสูงสุดในการวางเดิมพันและจำนวนเงินสูงสุดในการวางเดิมพันต้องน้อยกว่าจำนวนเงินสูงสุดของเงินเดิมพันต่อเกม (สำหรับกีฬาบาสเก็ตบอล)'
							WHEN 'J' THEN N'Min bet must be less than max bet and max bet must be less than max bet per match (for Basketball)'
							WHEN 'KO' THEN N'최소 배팅은 최대 배팅 이하이여야 하고 최대 배팅은 경기당 최대 배팅보다 작아야 합니다 (농구)'
							ELSE N'Min bet must be less than max bet and max bet must be less than max bet per match (for Basketball)'
						END						
						+ CHAR(13) + CHAR(10) + CONVERT(VARCHAR(20), @MinBetv2) + '-' + CONVERT(VARCHAR(20), @MaxBetv2) + '-' + CONVERT(VARCHAR(20), @MaxPerMatchv2), @ErrCode = 111
				
		RETURN
	END
	
	IF (@MinMinBetv2>0 AND @MinBetv2>0 AND @MinBetv2<@MinMinBetv2)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be equal to or greater than Agent min bet (for Basketball)'
							WHEN 'CS' THEN N'最低投注需相等于或少于代理最低投注(于篮球)'
							WHEN 'CT' THEN N'最低投注需相等於或少於代理最低投注(於籃球)'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดในการเล่นต้องเท่ากับหรือมากกว่าจำนวนเงินขั้นต่ำในการเล่นที่กำหนดไว้ของตัวแทน (สำหรับกีฬาบาสเก็ตบอล)'
							WHEN 'J' THEN N'Min bet must be equal to or greater than Agent min bet (for Basketball)'
							WHEN 'KO' THEN N'최소 배팅은 에이전트의 최소 배팅 이상이여야 합니다 (농구)'
							ELSE N'Min bet must be equal to or greater than Agent min bet (for Basketball)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MinMinBetv2) + ').', @ErrCode = 112
				
		RETURN
	END	
	IF (@MaxMaxBetv2>0 AND @MaxBetv2>0 AND @MaxBetv2>@MaxMaxBetv2)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max bet must be equal to or less than Agent max bet (for Basketball)'
							WHEN 'CS' THEN N'最高投注需相等于或少于代理最高投注(于篮球)'
							WHEN 'CT' THEN N'最高投注需相等於或少於代理最高投注(於籃球)'
							WHEN 'TH' THEN N'จำนวนการวางเดิมพันสูงสุดต้องเท่ากับ หรือ น้อยกว่าราคาเดิมพันสูงสุดของตัวแทน (สำหรับกีฬาบาสเก็ตบอล)'
							WHEN 'J' THEN N'Max bet must be equal to or less than Agent max bet (for Basketball)'
							WHEN 'KO' THEN N'최대 배팅은 에이전트의 최대 배팅 이하이여야 합니다 (농구)'
							ELSE N'Max bet must be equal to or less than Agent max bet (for Basketball)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MaxMaxBetv2) + ').', @ErrCode = 113
				
		RETURN
	END
	
	IF (@MaxMaxPerMatchv2>0 AND @MaxPerMatchv2>0 AND @MaxPerMatchv2>@MaxMaxPerMatchv2)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max Per Match must be equal to or less than Agent Max Per Match (for Basketball)'
							WHEN 'CS' THEN N'单场最高投注需相等于或少于代理单场最高投注(于篮球)'
							WHEN 'CT' THEN N'單場最高投注需相等於或少於代理單場最高投注(於籃球)'
							WHEN 'TH' THEN N'จำนวนเงินสูงสุดในการเล่นต่อรายการต้องเท่ากับหรือน้อยกว่าจำนวนเงินสูงสุดต่อรายการที่กำหนดไว้ของตัวแทน (สำหรับกีฬาบาสเก็ตบอล)  '
							WHEN 'J' THEN N'Max Per Match must be equal to or less than Agent Max Per Match (for Basketball)'
							WHEN 'KO' THEN N'최대 경기는 에이전트의 최대 경기보다 작아야 합니다 (농구)'
							ELSE N'Max Per Match must be equal to or less than Agent Max Per Match (for Basketball)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MaxMaxPerMatchv2) + ').', @ErrCode = 113
				
		RETURN
	END
END

IF @UpdateMinMaxBetv3 = 1
BEGIN
	IF ((@MinBetv3<>0 OR @MaxBetv3<>0 OR @MaxPerMatchv3<>0) AND (@MinBetv3>@MaxBetv3 OR @MaxBetv3>@MaxPerMatchv3))
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be less than max bet and max bet must be less than max bet per match (for Football)'
							WHEN 'CS' THEN N'最低投注不能高于最高投注，最高投注不能高于单场最高投注设定(于美式足球)'
							WHEN 'CT' THEN N'最低投注不能高於最高投注,最高投注不能高於單場最高投注設定(於美式足球)'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดที่วางเดิมพันได้ต้องน้อยกว่าจำนวนเงินสูงสุดในการวางเดิมพันและจำนวนเงินสูงสุดในการวางเดิมพันต้องน้อยกว่าจำนวนเงินสูงสุดของเงินเดิมพันต่อเกม (สำหรับกีฬาอเมริกันฟุตบอล)'
							WHEN 'J' THEN N'Min bet must be less than max bet and max bet must be less than max bet per match (for Football)'
							WHEN 'KO' THEN N'최소 배팅은 최대 배팅 이하이여야 하고 최대 배팅은 경기당 최대 배팅보다 작아야 합니다 (풋볼)'
							ELSE N'Min bet must be less than max bet and max bet must be less than max bet per match (for Football)'
						END						
						+ CHAR(13) + CHAR(10) + CONVERT(VARCHAR(20), @MinBetv3) + '-' + CONVERT(VARCHAR(20), @MaxBetv3) + '-' + CONVERT(VARCHAR(20), @MaxPerMatchv3), @ErrCode = 111
				
		RETURN
	END
	
	IF (@MinMinBetv3>0 AND @MinBetv3>0 AND @MinBetv3<@MinMinBetv3)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be equal to or greater than Agent min bet (for Football)'
							WHEN 'CS' THEN N'最低投注需相等于或少于代理最低投注(于美式足球)'
							WHEN 'CT' THEN N'最低投注需相等於或少於代理最低投注(於美式足球)'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดในการเล่นต้องเท่ากับหรือมากกว่าจำนวนเงินขั้นต่ำในการเล่นที่กำหนดไว้ของตัวแทน (สำหรับกีฬาอเมริกันฟุตบอล)'
							WHEN 'J' THEN N'Min bet must be equal to or greater than Agent min bet (for Football)'
							WHEN 'KO' THEN N'최소 배팅은 에이전트의 최소 배팅 이상이여야 합니다 (풋볼)'
							ELSE N'Min bet must be equal to or greater than Agent min bet (for Football)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MinMinBetv3) + ').', @ErrCode = 112
				
		RETURN
	END	
	IF (@MaxMaxBetv3>0 AND @MaxBetv3>0 AND @MaxBetv3>@MaxMaxBetv3)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max bet must be equal to or less than Agent max bet (for Football)'
							WHEN 'CS' THEN N'最高投注需相等于或少于代理最高投注(于美式足球)'
							WHEN 'CT' THEN N'最高投注需相等於或少於代理最高投注(於美式足球)'
							WHEN 'TH' THEN N'จำนวนการวางเดิมพันสูงสุดต้องเท่ากับ หรือ น้อยกว่าราคาเดิมพันสูงสุดของตัวแทน (สำหรับกีฬาอเมริกันฟุตบอล)'
							WHEN 'J' THEN N'Max bet must be equal to or less than Agent max bet (for Football)'
							WHEN 'KO' THEN N'최대 배팅은 에이전트의 최대 배팅 이하이여야 합니다 (풋볼)'
							ELSE N'Max bet must be equal to or less than Agent max bet (for Football)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MaxMaxBetv3) + ').', @ErrCode = 113
				
		RETURN
	END
	
	IF (@MaxMaxPerMatchv3>0 AND @MaxPerMatchv3>0 AND @MaxPerMatchv3>@MaxMaxPerMatchv3)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max Per Match must be equal to or less than Agent Max Per Match (for Football)'
							WHEN 'CS' THEN N'单场最高投注需相等于或少于代理单场最高投注(于美式足球)'
							WHEN 'CT' THEN N'單場最高投注需相等於或少於代理單場最高投注(於美式足球)'
							WHEN 'TH' THEN N'จำนวนเงินสูงสุดในการเล่นต่อรายการต้องเท่ากับหรือน้อยกว่าจำนวนเงินสูงสุดต่อรายการที่กำหนดไว้ของตัวแทน (สำหรับกีฬาอเมริกันฟุตบอล) '
							WHEN 'J' THEN N'Max Per Match must be equal to or less than Agent Max Per Match (for Football)'
							WHEN 'KO' THEN N'최대 경기는 에이전트의 최대 경기보다 작아야 합니다 (풋볼)'
							ELSE N'Max Per Match must be equal to or less than Agent Max Per Match (for Football)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MaxMaxPerMatchv3) + ').', @ErrCode = 113
				
		RETURN
	END
END

IF @UpdateMinMaxBetv5 = 1
BEGIN
	IF ((@MinBetv5<>0 OR @MaxBetv5<>0 OR @MaxPerMatchv5<>0) AND (@MinBetv5>@MaxBetv5 OR @MaxBetv5>@MaxPerMatchv5))
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be less than max bet and max bet must be less than max bet per match (for Tennis)'
							WHEN 'CS' THEN N'最低投注不能高于最高投注，最高投注不能高于单场最高投注设定(于网球)'
							WHEN 'CT' THEN N'最低投注不能高於最高投注,最高投注不能高於單場最高投注設定(於網球)'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดที่วางเดิมพันได้ต้องน้อยกว่าจำนวนเงินสูงสุดในการวางเดิมพันและจำนวนเงินสูงสุดในการวางเดิมพันต้องน้อยกว่าจำนวนเงินสูงสุดของเงินเดิมพันต่อเกม (สำหรับกีฬาเทนนิส)'
							WHEN 'J' THEN N'Min bet must be less than max bet and max bet must be less than max bet per match (for Tennis)'
							WHEN 'KO' THEN N'최소 배팅은 최대 배팅 이하이여야 하고 최대 배팅은 경기당 최대 배팅보다 작아야 합니다 (테니스)'
							ELSE N'Min bet must be less than max bet and max bet must be less than max bet per match (for Tennis)'
						END						
						+ CHAR(13) + CHAR(10) + CONVERT(VARCHAR(20), @MinBetv5) + '-' + CONVERT(VARCHAR(20), @MaxBetv5) + '-' + CONVERT(VARCHAR(20), @MaxPerMatchv5), @ErrCode = 111
				
		RETURN
	END
	
	IF (@MinMinBetv5>0 AND @MinBetv5>0 AND @MinBetv5<@MinMinBetv5)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be equal to or greater than Agent min bet (for Tennis)'
							WHEN 'CS' THEN N'最低投注需相等于或少于代理最低投注(于网球)'
							WHEN 'CT' THEN N'最低投注需相等於或少於代理最低投注(於網球)'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดในการเล่นต้องเท่ากับหรือมากกว่าจำนวนเงินขั้นต่ำในการเล่นที่กำหนดไว้ของตัวแทน (สำหรับกีฬาเทนนิส)'
							WHEN 'J' THEN N'Min bet must be equal to or greater than Agent min bet (for Tennis)'
							WHEN 'KO' THEN N'최소 배팅은 에이전트의 최소 배팅 이상이여야 합니다 (테니스)'
							ELSE N'Min bet must be equal to or greater than Agent min bet (for Tennis)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MinMinBetv5) + ').', @ErrCode = 112
				
		RETURN
	END	
	IF (@MaxMaxBetv5>0 AND @MaxBetv5>0 AND @MaxBetv5>@MaxMaxBetv5)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max bet must be equal to or less than Agent max bet (for Tennis)'
							WHEN 'CS' THEN N'最高投注需相等于或少于代理最高投注(于网球)'
							WHEN 'CT' THEN N'最高投注需相等於或少於代理最高投注(於網球)'
							WHEN 'TH' THEN N'จำนวนการวางเดิมพันสูงสุดต้องเท่ากับ หรือ น้อยกว่าราคาเดิมพันสูงสุดของตัวแทน (สำหรับกีฬาเทนนิส)'
							WHEN 'J' THEN N'Max bet must be equal to or less than Agent max bet (for Tennis)'
							WHEN 'KO' THEN N'최대 배팅은 에이전트의 최대 배팅 이하이여야 합니다 (테니스)'
							ELSE N'Max bet must be equal to or less than Agent max bet (for Tennis)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MaxMaxBetv5) + ').', @ErrCode = 113
				
		RETURN
	END
	
	IF (@MaxMaxPerMatchv5>0 AND @MaxPerMatchv5>0 AND @MaxPerMatchv5>@MaxMaxPerMatchv5)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max Per Match must be equal to or less than Agent Max Per Match  (for Tennis)'
							WHEN 'CS' THEN N'单场最高投注需相等于或少于代理单场最高投注(于网球)'
							WHEN 'CT' THEN N'單場最高投注需相等於或少於代理單場最高投注(於網球)'
							WHEN 'TH' THEN N'จำนวนเงินสูงสุดในการเล่นต่อรายการต้องเท่ากับหรือน้อยกว่าจำนวนเงินสูงสุดต่อรายการที่กำหนดไว้ของตัวแทน (สำหรับกีฬาเทนนิส)  '
							WHEN 'J' THEN N'Max Per Match must be equal to or less than Agent Max Per Match  (for Tennis)'
							WHEN 'KO' THEN N'최대 경기는 에이전트의 최대 경기보다 작아야 합니다 (테니스)'
							ELSE N'Max Per Match must be equal to or less than Agent Max Per Match  (for Tennis)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MaxMaxPerMatchv5) + ').', @ErrCode = 113
				
		RETURN
	END
END

IF @UpdateMinMaxBetv8 = 1
BEGIN
	IF ((@MinBetv8<>0 OR @MaxBetv8<>0 OR @MaxPerMatchv8<>0) AND (@MinBetv8>@MaxBetv8 OR @MaxBetv8>@MaxPerMatchv8))
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be less than max bet and max bet must be less than max bet per match (for Baseball)'
							WHEN 'CS' THEN N'最低投注不能高于最高投注，最高投注不能高于单场最高投注设定(于棒球)'
							WHEN 'CT' THEN N'最低投注不能高於最高投注,最高投注不能高於單場最高投注設定(於棒球)'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดที่วางเดิมพันได้ต้องน้อยกว่าจำนวนเงินสูงสุดในการวางเดิมพันและจำนวนเงินสูงสุดในการวางเดิมพันต้องน้อยกว่าจำนวนเงินสูงสุดของเงินเดิมพันต่อเกม (สำหรับกีฬาเบสบอล)'
							WHEN 'J' THEN N'Min bet must be less than max bet and max bet must be less than max bet per match (for Baseball)'
							WHEN 'KO' THEN N'최소 배팅은 최대 배팅 이하이여야 하고 최대 배팅은 경기당 최대 배팅보다 작아야 합니다 (야구)'
							ELSE N'Min bet must be less than max bet and max bet must be less than max bet per match (for Baseball)'
						END						
						+ CHAR(13) + CHAR(10) + CONVERT(VARCHAR(20), @MinBetv8) + '-' + CONVERT(VARCHAR(20), @MaxBetv8) + '-' + CONVERT(VARCHAR(20), @MaxPerMatchv8), @ErrCode = 111
				
		RETURN
	END
	
	IF (@MinMinBetv8>0 AND @MinBetv8>0 AND @MinBetv8<@MinMinBetv8)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be equal to or greater than Agent min bet (for Baseball)'
							WHEN 'CS' THEN N'最低投注需相等于或少于代理最低投注(于棒球)'
							WHEN 'CT' THEN N'最低投注需相等於或少於代理最低投注(於棒球)'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดในการเล่นต้องเท่ากับหรือมากกว่าจำนวนเงินขั้นต่ำในการเล่นที่กำหนดไว้ของตัวแทน (สำหรับกีฬาเบสบอล)'
							WHEN 'J' THEN N'Min bet must be equal to or greater than Agent min bet (for Baseball)'
							WHEN 'KO' THEN N'최소 배팅은 에이전트의 최소 배팅 이상이여야 합니다 (야구)'
							ELSE N'Min bet must be equal to or greater than Agent min bet (for Baseball)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MinMinBetv8) + ').', @ErrCode = 112
				
		RETURN
	END	
	IF (@MaxMaxBetv8>0 AND @MaxBetv8>0 AND @MaxBetv8>@MaxMaxBetv8)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max bet must be equal to or less than Agent max bet (for Baseball)'
							WHEN 'CS' THEN N'最高投注需相等于或少于代理最高投注(于棒球)'
							WHEN 'CT' THEN N'最高投注需相等於或少於代理最高投注(於棒球)'
							WHEN 'TH' THEN N'จำนวนการวางเดิมพันสูงสุดต้องเท่ากับ หรือ น้อยกว่าราคาเดิมพันสูงสุดของตัวแทน (สำหรับกีฬาเบสบอล)'
							WHEN 'J' THEN N'Max bet must be equal to or less than Agent max bet (for Baseball)'
							WHEN 'KO' THEN N'최대 배팅은 에이전트의 최대 배팅 이하이여야 합니다 (야구)'
							ELSE N'Max bet must be equal to or less than Agent max bet (for Baseball)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MaxMaxBetv8) + ').', @ErrCode = 113
				
		RETURN
	END
	
	IF (@MaxMaxPerMatchv8>0 AND @MaxPerMatchv8>0 AND @MaxPerMatchv8>@MaxMaxPerMatchv8)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max Per Match must be equal to or less than Agent Max Per Match (for Baseball)'
							WHEN 'CS' THEN N'单场最高投注需相等于或少于代理单场最高投注(于棒球)'
							WHEN 'CT' THEN N'單場最高投注需相等於或少於代理單場最高投注(於棒球)'
							WHEN 'TH' THEN N'จำนวนเงินสูงสุดในการเล่นต่อรายการต้องเท่ากับหรือน้อยกว่าจำนวนเงินสูงสุดต่อรายการที่กำหนดไว้ของตัวแทน (สำหรับกีฬาเบสบอล)  '
							WHEN 'J' THEN N'Max Per Match must be equal to or less than Agent Max Per Match (for Baseball)'
							WHEN 'KO' THEN N'최대 경기는 에이전트의 최대 경기보다 작아야 합니다 (야구)'
							ELSE N'Max Per Match must be equal to or less than Agent Max Per Match (for Baseball)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MaxMaxPerMatchv8) + ').', @ErrCode = 113
				
		RETURN
	END
END

IF @UpdateMinMaxBetv10 = 1
BEGIN
	IF ((@MinBetv10<>0 OR @MaxBetv10<>0 OR @MaxPerMatchv10<>0) AND (@MinBetv10>@MaxBetv10 OR @MaxBetv10>@MaxPerMatchv10))
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be less than max bet and max bet must be less than max bet per match (for Golf)'
							WHEN 'CS' THEN N'最低投注不能高于最高投注，最高投注不能高于单场最高投注设定(于高尔夫球)'
							WHEN 'CT' THEN N'最低投注不能高於最高投注,最高投注不能高於單場最高投注設定(於高爾夫球)'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดที่วางเดิมพันได้ต้องน้อยกว่าจำนวนเงินสูงสุดในการวางเดิมพันและจำนวนเงินสูงสุดในการวางเดิมพันต้องน้อยกว่าจำนวนเงินสูงสุดของเงินเดิมพันต่อเกม (สำหรับกีฬากอฟล์)'
							WHEN 'J' THEN N'Min bet must be less than max bet and max bet must be less than max bet per match (for Golf)'
							WHEN 'KO' THEN N'최소 배팅은 최대 배팅 이하이여야 하고 최대 배팅은 경기당 최대 배팅보다 작아야 합니다 (골프)'
							ELSE N'Min bet must be less than max bet and max bet must be less than max bet per match (for Golf)'
						END						
						+ CHAR(13) + CHAR(10) + CONVERT(VARCHAR(20), @MinBetv10) + '-' + CONVERT(VARCHAR(20), @MaxBetv10) + '-' + CONVERT(VARCHAR(20), @MaxPerMatchv10), @ErrCode = 111
				
		RETURN
	END
	
	IF (@MinMinBetv10>0 AND @MinBetv10>0 AND @MinBetv10<@MinMinBetv10)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be equal to or greater than Agent min bet (for Golf)'
							WHEN 'CS' THEN N'最低投注需相等于或少于代理最低投注(于高尔夫球)'
							WHEN 'CT' THEN N'最低投注需相等於或少於代理最低投注(於高爾夫球)'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดในการเล่นต้องเท่ากับหรือมากกว่าจำนวนเงินขั้นต่ำในการเล่นที่กำหนดไว้ของตัวแทน (สำหรับกีฬากอฟล์)'
							WHEN 'J' THEN N'Min bet must be equal to or greater than Agent min bet (for Golf)'
							WHEN 'KO' THEN N'최소 배팅은 에이전트의 최소 배팅 이상이여야 합니다 (골프)'
							ELSE N'Min bet must be equal to or greater than Agent min bet (for Golf)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MinMinBetv10) + ').', @ErrCode = 112
				
		RETURN
	END	
	IF (@MaxMaxBetv10>0 AND @MaxBetv10>0 AND @MaxBetv10>@MaxMaxBetv10)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max bet must be equal to or less than Agent max bet (for Golf)'
							WHEN 'CS' THEN N'最高投注需相等于或少于代理最高投注(于高尔夫球)'
							WHEN 'CT' THEN N'最高投注需相等於或少於代理最高投注(於高爾夫球)'
							WHEN 'TH' THEN N'จำนวนการวางเดิมพันสูงสุดต้องเท่ากับ หรือ น้อยกว่าราคาเดิมพันสูงสุดของตัวแทน (สำหรับกีฬากอฟล์)'
							WHEN 'J' THEN N'Max bet must be equal to or less than Agent max bet (for Golf)'
							WHEN 'KO' THEN N'최대 배팅은 에이전트의 최대 배팅 이하이여야 합니다 (골프)'
							ELSE N'Max bet must be equal to or less than Agent max bet (for Golf)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MaxMaxBetv10) + ').', @ErrCode = 113
				
		RETURN
	END
	
	IF (@MaxMaxPerMatchv10>0 AND @MaxPerMatchv10>0 AND @MaxPerMatchv10>@MaxMaxPerMatchv10)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max Per Match must be equal to or less than Agent Max Per Match (for Golf)'
							WHEN 'CS' THEN N'单场最高投注需相等于或少于代理单场最高投注(于高尔夫球)'
							WHEN 'CT' THEN N'單場最高投注需相等於或少於代理單場最高投注(於高爾夫球)'
							WHEN 'TH' THEN N'จำนวนเงินสูงสุดในการเล่นต่อรายการต้องเท่ากับหรือน้อยกว่าจำนวนเงินสูงสุดต่อรายการที่กำหนดไว้ของตัวแทน (สำหรับกีฬากอฟล์) '
							WHEN 'J' THEN N'Max Per Match must be equal to or less than Agent Max Per Match (for Golf)'
							WHEN 'KO' THEN N'최대 경기는 에이전트의 최대 경기보다 작아야 합니다 (골프)'
							ELSE N'Max Per Match must be equal to or less than Agent Max Per Match (for Golf)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MaxMaxPerMatchv10) + ').', @ErrCode = 113
				
		RETURN
	END
END

IF @UpdateMinMaxBetv11 = 1
BEGIN
	IF ((@MinBetv11<>0 OR @MaxBetv11<>0 OR @MaxPerMatchv11<>0) AND (@MinBetv11>@MaxBetv11 OR @MaxBetv11>@MaxPerMatchv11))
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be less than max bet and max bet must be less than max bet per match (for Motorsports)'
							WHEN 'CS' THEN N'最低投注不能高于最高投注，最高投注不能高于单场最高投注设定(于赛车)'
							WHEN 'CT' THEN N'最低投注不能高於最高投注,最高投注不能高於單場最高投注設定(於賽車)'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดที่วางเดิมพันได้ต้องน้อยกว่าจำนวนเงินสูงสุดในการวางเดิมพันและจำนวนเงินสูงสุดในการวางเดิมพันต้องน้อยกว่าจำนวนเงินสูงสุดของเงินเดิมพันต่อเกม (สำหรับกีฬารถแข่ง)'
							WHEN 'J' THEN N'Min bet must be less than max bet and max bet must be less than max bet per match (for Motorsports)'
							WHEN 'KO' THEN N'최소 배팅은 최대 배팅 이하이여야 하고 최대 배팅은 경기당 최대 배팅보다 작아야 합니다 (모토스포츠)'
							ELSE N'Min bet must be less than max bet and max bet must be less than max bet per match (for Motorsports)'
						END						
						+ CHAR(13) + CHAR(10) + CONVERT(VARCHAR(20), @MinBetv11) + '-' + CONVERT(VARCHAR(20), @MaxBetv11) + '-' + CONVERT(VARCHAR(20), @MaxPerMatchv11), @ErrCode = 111
				
		RETURN
	END
	
	IF (@MinMinBetv11>0 AND @MinBetv11>0 AND @MinBetv11<@MinMinBetv11)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be equal to or greater than Agent min bet (for Motorsports)'
							WHEN 'CS' THEN N'最低投注需相等于或少于代理最低投注(于赛车)'
							WHEN 'CT' THEN N'最低投注需相等於或少於代理最低投注(於賽車)'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดในการเล่นต้องเท่ากับหรือมากกว่าจำนวนเงินขั้นต่ำในการเล่นที่กำหนดไว้ของตัวแทน (สำหรับกีฬารถแข่ง)'
							WHEN 'J' THEN N'Min bet must be equal to or greater than Agent min bet (for Motorsports)'
							WHEN 'KO' THEN N'최소 배팅은 에이전트의 최소 배팅 이상이여야 합니다 (모토스포츠)'
							ELSE N'Min bet must be equal to or greater than Agent min bet (for Motorsports)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MinMinBetv11) + ').', @ErrCode = 112
				
		RETURN
	END	
	IF (@MaxMaxBetv11>0 AND @MaxBetv11>0 AND @MaxBetv11>@MaxMaxBetv11)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max bet must be equal to or less than Agent max bet (for Motorsports)'
							WHEN 'CS' THEN N'最高投注需相等于或少于代理最高投注(于赛车)'
							WHEN 'CT' THEN N'最高投注需相等於或少於代理最高投注(於賽車)'
							WHEN 'TH' THEN N'จำนวนการวางเดิมพันสูงสุดต้องเท่ากับ หรือ น้อยกว่าราคาเดิมพันสูงสุดของตัวแทน (สำหรับกีฬารถแข่ง)'
							WHEN 'J' THEN N'Max bet must be equal to or less than Agent max bet (for Motorsports)'
							WHEN 'KO' THEN N'최대 배팅은 에이전트의 최대 배팅 이하이여야 합니다 (모토스포츠)'
							ELSE N'Max bet must be equal to or less than Agent max bet (for Motorsports)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MaxMaxBetv11) + ').', @ErrCode = 113
				
		RETURN
	END
	
	IF (@MaxMaxPerMatchv11>0 AND @MaxPerMatchv11>0 AND @MaxPerMatchv11>@MaxMaxPerMatchv11)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max Per Match must be equal to or less than Agent Max Per Match (for Motorsports)'
							WHEN 'CS' THEN N'单场最高投注需相等于或少于代理单场最高投注(于赛车)'
							WHEN 'CT' THEN N'單場最高投注需相等於或少於代理單場最高投注(於賽車)'
							WHEN 'TH' THEN N'จำนวนเงินสูงสุดในการเล่นต่อรายการต้องเท่ากับหรือน้อยกว่าจำนวนเงินสูงสุดต่อรายการที่กำหนดไว้ของตัวแทน (สำหรับกีฬารถแข่ง) '
							WHEN 'J' THEN N'Max Per Match must be equal to or less than Agent Max Per Match (for Motorsports)'
							WHEN 'KO' THEN N'최대 경기는 에이전트의 최대 경기보다 작아야 합니다 (모토스포츠)'
							ELSE N'Max Per Match must be equal to or less than Agent Max Per Match (for Motorsports)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MaxMaxPerMatchv11) + ').', @ErrCode = 113
				
		RETURN
	END
END

IF @UpdateMinMaxBetv99 = 1
BEGIN
	IF ((@MinBetv99<>0 OR @MaxBetv99<>0 OR @MaxPerMatchv99<>0) AND (@MinBetv99>@MaxBetv99 OR @MaxBetv99>@MaxPerMatchv99))
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be less than max bet and max bet must be less than max bet per match (for Other sports)'
							WHEN 'CS' THEN N'最低投注不能高于最高投注，最高投注不能高于单场最高投注设定(于其他)'
							WHEN 'CT' THEN N'最低投注不能高於最高投注,最高投注不能高於單場最高投注設定(於其他)'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดที่วางเดิมพันได้ต้องน้อยกว่าจำนวนเงินสูงสุดในการวางเดิมพันและจำนวนเงินสูงสุดในการวางเดิมพันต้องน้อยกว่าจำนวนเงินสูงสุดของเงินเดิมพันต่อเกม (สำหรับกีฬาอื่นๆ)'
							WHEN 'J' THEN N'Min bet must be less than max bet and max bet must be less than max bet per match (for Other sports)'
							WHEN 'KO' THEN N'최소 배팅은 최대 배팅 이하이여야 하고 최대 배팅은 경기당 최대 배팅보다 작아야 합니다 (기타 스포츠)'
							ELSE N'Min bet must be less than max bet and max bet must be less than max bet per match (for Other sports)'
						END						
						+ CHAR(13) + CHAR(10) + CONVERT(VARCHAR(20), @MinBetv99) + '-' + CONVERT(VARCHAR(20), @MaxBetv99) + '-' + CONVERT(VARCHAR(20), @MaxPerMatchv99), @ErrCode = 111
				
		RETURN
	END
	
	IF (@MinMinBetv99>0 AND @MinBetv99>0 AND @MinBetv99<@MinMinBetv99)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be equal to or greater than Agent min bet (for Other sports)'
							WHEN 'CS' THEN N'最低投注需相等于或少于代理最低投注(于其他)'
							WHEN 'CT' THEN N'最低投注需相等於或少於代理最低投注(於其他)'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดในการเล่นต้องเท่ากับหรือมากกว่าจำนวนเงินขั้นต่ำในการเล่นที่กำหนดไว้ของตัวแทน (สำหรับกีฬาอื่นๆ)'
							WHEN 'J' THEN N'Min bet must be equal to or greater than Agent min bet (for Other sports)'
							WHEN 'KO' THEN N'최소 배팅은 에이전트의 최소 배팅 이상이여야 합니다 (기타 스포츠)'
							ELSE N'Min bet must be equal to or greater than Agent min bet (for Other sports)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MinMinBetv99) + ').', @ErrCode = 112
				
		RETURN
	END	
	IF (@MaxMaxBetv99>0 AND @MaxBetv99>0 AND @MaxBetv99>@MaxMaxBetv99)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max bet must be equal to or less than Agent max bet (for Other sports)'
							WHEN 'CS' THEN N'最高投注需相等于或少于代理最高投注(于其他)'
							WHEN 'CT' THEN N'最高投注需相等於或少於代理最高投注(於其他)'
							WHEN 'TH' THEN N'จำนวนการวางเดิมพันสูงสุดต้องเท่ากับ หรือ น้อยกว่าราคาเดิมพันสูงสุดของตัวแทน (สำหรับกีฬาอื่นๆ)'
							WHEN 'J' THEN N'Max bet must be equal to or less than Agent max bet (for Other sports)'
							WHEN 'KO' THEN N'최대 배팅은 에이전트의 최대 배팅 이하이여야 합니다 (기타 스포츠)'
							ELSE N'Max bet must be equal to or less than Agent max bet (for Other sports)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MaxMaxBetv99) + ').', @ErrCode = 113
				
		RETURN
	END
	
	IF (@MaxMaxPerMatchv99>0 AND @MaxPerMatchv99>0 AND @MaxPerMatchv99>@MaxMaxPerMatchv99)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max Per Match must be equal to or less than Agent Max Per Match (for Other sports)'
							WHEN 'CS' THEN N'单场最高投注需相等于或少于代理单场最高投注(于其他)'
							WHEN 'CT' THEN N'單場最高投注需相等於或少於代理單場最高投注(於其他)'
							WHEN 'TH' THEN N'จำนวนเงินสูงสุดในการเล่นต่อรายการต้องเท่ากับหรือน้อยกว่าจำนวนเงินสูงสุดต่อรายการที่กำหนดไว้ของตัวแทน (สำหรับกีฬาอื่นๆ) '
							WHEN 'J' THEN N'Max Per Match must be equal to or less than Agent Max Per Match (for Other sports)'
							WHEN 'KO' THEN N'최대 경기는 에이전트의 최대 경기보다 작아야 합니다 (기타 스포츠)'
							ELSE N'Max Per Match must be equal to or less than Agent Max Per Match (for Other sports)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MaxMaxPerMatchv99) + ').', @ErrCode = 113
				
		RETURN
	END
END

IF @UpdateMinMaxBetv99MP = 1
BEGIN
	IF ((@MinBetv99MP<>0 OR @MaxBetv99MP<>0 OR @MaxPerMatchv99MP<>0) AND (@MinBetv99MP>@MaxBetv99MP OR @MaxBetv99MP>@MaxPerMatchv99MP))
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be less than max bet and max bet must be less than max bet per match (for Mix Sports Parlay)'
							WHEN 'CS' THEN N'最低投注不能高于最高投注，最高投注不能高于单场最高投注设定(供混合体育过关)'
							WHEN 'CT' THEN N'最低投注不能高於最高投注,最高投注不能高於單場最高投注設定(供混合體育過關)'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดที่วางเดิมพันได้ต้องน้อยกว่าจำนวนเงินสูงสุดในการวางเดิมพันและจำนวนเงินสูงสุดในการวางเดิมพันต้องน้อยกว่าจำนวนเงินสูงสุดของเงินเดิมพันต่อเกม (สำหรับกีฬาบอลชุด)'
							WHEN 'J' THEN N'Min bet must be less than max bet and max bet must be less than max bet per match (for Mix Sports Parlay)'
							WHEN 'KO' THEN N'최소 배팅은 최대 배팅 이하이여야 하고 최대 배팅은 경기당 최대 배팅보다 작아야 합니다 (for Mix Sports Parlay)'
							ELSE N'Min bet must be less than max bet and max bet must be less than max bet per match (for Mix Sports Parlay)'
						END						
						+ CHAR(13) + CHAR(10) + CONVERT(VARCHAR(20), @MinBetv99MP) + '-' + CONVERT(VARCHAR(20), @MaxBetv99MP) + '-' + CONVERT(VARCHAR(20), @MaxPerMatchv99MP), @ErrCode = 111
				
		RETURN
	END
	
	IF (@MinMinBetv99MP>0 AND @MinBetv99MP>0 AND @MinBetv99MP<@MinMinBetv99MP)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be equal to or greater than Agent min bet (for Mix Sports Parlay)'
							WHEN 'CS' THEN N'最低投注需相等于或少于代理最低投注(供混合体育过关)'
							WHEN 'CT' THEN N'最低投注需相等於或少於代理最低投注(供混合體育過關)'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดในการเล่นต้องเท่ากับหรือมากกว่าจำนวนเงินขั้นต่ำในการเล่นที่กำหนดไว้ของตัวแทน (สำหรับกีฬาบอลชุด)'
							WHEN 'J' THEN N'Min bet must be equal to or greater than Agent min bet (for Mix Sports Parlay)'
							WHEN 'KO' THEN N'최소 배팅은 에이전트의 최소 배팅 이상이여야 합니다 (for Mix Sports Parlay)'
							ELSE N'Min bet must be equal to or greater than Agent min bet (for Mix Sports Parlay)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MinMinBetv99MP) + ').', @ErrCode = 112
				
		RETURN
	END	
	IF (@MaxMaxBetv99MP>0 AND @MaxBetv99MP>0 AND @MaxBetv99MP>@MaxMaxBetv99MP)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max bet must be equal to or less than Agent max bet (for Mix Sports Parlay)'
							WHEN 'CS' THEN N'最高投注需相等于或少于代理最高投注(供混合体育过关)'
							WHEN 'CT' THEN N'最高投注需相等於或少於代理最高投注(供混合體育過關)'
							WHEN 'TH' THEN N'จำนวนการวางเดิมพันสูงสุดต้องเท่ากับ หรือ น้อยกว่าราคาเดิมพันสูงสุดของตัวแทน (สำหรับกีฬาบอลชุด)'
							WHEN 'J' THEN N'Max bet must be equal to or less than Agent max bet (for Mix Sports Parlay)'
							WHEN 'KO' THEN N'최대 배팅은 에이전트의 최대 배팅 이하이여야 합니다 (for Mix Sports Parlay)'
							ELSE N'Max bet must be equal to or less than Agent max bet (for Mix Sports Parlay)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MaxMaxBetv99MP) + ').', @ErrCode = 113
				
		RETURN
	END
	
	IF (@MaxMaxPerMatchv99MP>0 AND @MaxPerMatchv99MP>0 AND @MaxPerMatchv99MP>@MaxMaxPerMatchv99MP)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max Per Match must be equal to or less than Agent Max Per Match (for Mix Sports Parlay)'
							WHEN 'CS' THEN N'单场最高投注需相等于或少于代理单场最高投注(供混合体育过关)'
							WHEN 'CT' THEN N'單場最高投注需相等於或少於代理單場最高投注(供混合體育過關)'
							WHEN 'TH' THEN N'จำนวนเงินสูงสุดในการเล่นต่อรายการต้องเท่ากับหรือน้อยกว่าจำนวนเงินสูงสุดต่อรายการที่กำหนดไว้ของตัวแทน (สำหรับกีฬาบอลชุด) '
							WHEN 'J' THEN N'Max Per Match must be equal to or less than Agent Max Per Match (for Mix Sports Parlay)'
							WHEN 'KO' THEN N'최대 경기는 에이전트의 최대 경기보다 작아야 합니다 (for Mix Sports Parlay)'
							ELSE N'Max Per Match must be equal to or less than Agent Max Per Match (for Mix Sports Parlay)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MaxMaxPerMatchv99MP) + ').', @ErrCode = 113
				
		RETURN
	END
END

IF @UpdateMinMaxBetv154 = 1
BEGIN
	IF ((@MinBetv154<>0 OR @MaxBetv154<>0 OR @MaxPerMatchv154<>0) AND (@MinBetv154>@MaxBetv154 OR @MaxBetv154>@MaxPerMatchv154))
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be less than max bet and max bet must be less than max bet per match (for HR Fixed Odds)'
							WHEN 'CS' THEN N'最低投注不能高于最高投注，最高投注不能高于单场最高投注设定(赛马固定赔率)'
							WHEN 'CT' THEN N'最低投注不能高於最高投注,最高投注不能高於單場最高投注設定(賽馬固定賠率)'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดที่วางเดิมพันได้ต้องน้อยกว่าจำนวนเงินสูงสุดในการวางเดิมพันและจำนวนเงินสูงสุดในการวางเดิมพันต้องน้อยกว่าจำนวนเงินสูงสุดของเงินเดิมพันต่อเกม (Horse Racing Fixed Odds)'
							WHEN 'J' THEN N'Min bet must be less than max bet and max bet must be less than max bet per match (for HR Fixed Odds)'
							WHEN 'KO' THEN N'최소 배팅은 최대 배팅 이하이여야 하고 최대 배팅은 경기당 최대 배팅보다 작아야 합니다 (Horse Racing Fixed Odds)'
							ELSE N'Min bet must be less than max bet and max bet must be less than max bet per match (for HR Fixed Odds)'
						END						
						+ CHAR(13) + CHAR(10) + CONVERT(VARCHAR(20), @MinBetv154) + '-' + CONVERT(VARCHAR(20), @MaxBetv154) + '-' + CONVERT(VARCHAR(20), @MaxPerMatchv154), @ErrCode = 111
				
		RETURN
	END
	
	IF (@MinMinBetv154>0 AND @MinBetv154>0 AND @MinBetv154<@MinMinBetv154)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be equal to or greater than Agent min bet (for HR Fixed Odds)'
							WHEN 'CS' THEN N'最低投注需相等于或少于代理最低投注(赛马固定赔率)'
							WHEN 'CT' THEN N'最低投注需相等於或少於代理最低投注(賽馬固定賠率)'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดในการเล่นต้องเท่ากับหรือมากกว่าจำนวนเงินขั้นต่ำในการเล่นที่กำหนดไว้ของตัวแทน (Horse Racing Fixed Odds)'
							WHEN 'J' THEN N'Min bet must be equal to or greater than Agent min bet (for HR Fixed Odds)'
							WHEN 'KO' THEN N'최소 배팅은 에이전트의 최소 배팅 이상이여야 합니다 (Horse Racing Fixed Odds)'
							ELSE N'Min bet must be equal to or greater than Agent min bet (for HR Fixed Odds)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MinMinBetv154) + ').', @ErrCode = 112
				
		RETURN
	END	
	IF (@MaxMaxBetv154>0 AND @MaxBetv154>0 AND @MaxBetv154>@MaxMaxBetv154)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max bet must be equal to or less than Agent max bet (for HR Fixed Odds)'
							WHEN 'CS' THEN N'最高投注需相等于或少于代理最高投注(赛马固定赔率)'
							WHEN 'CT' THEN N'最高投注需相等於或少於代理最高投注(賽馬固定賠率)'
							WHEN 'TH' THEN N'จำนวนการวางเดิมพันสูงสุดต้องเท่ากับ หรือ น้อยกว่าราคาเดิมพันสูงสุดของตัวแทน (Horse Racing Fixed Odds)'
							WHEN 'J' THEN N'Max bet must be equal to or less than Agent max bet (for HR Fixed Odds)'
							WHEN 'KO' THEN N'최대 배팅은 에이전트의 최대 배팅 이하이여야 합니다 (Horse Racing Fixed Odds)'
							ELSE N'Max bet must be equal to or less than Agent max bet (for HR Fixed Odds)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MaxMaxBetv154) + ').', @ErrCode = 113
				
		RETURN
	END
	
	IF (@MaxMaxPerMatchv154>0 AND @MaxPerMatchv154>0 AND @MaxPerMatchv154>@MaxMaxPerMatchv154)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max Per Match must be equal to or less than Agent Max Per Match (for HR Fixed Odds)'
							WHEN 'CS' THEN N'单场最高投注需相等于或少于代理单场最高投注(赛马固定赔率)'
							WHEN 'CT' THEN N'單場最高投注需相等於或少於代理單場最高投注(賽馬固定賠率)'
							WHEN 'TH' THEN N'จำนวนเงินสูงสุดในการเล่นต่อรายการต้องเท่ากับหรือน้อยกว่าจำนวนเงินสูงสุดต่อรายการที่กำหนดไว้ของตัวแทน (Horse Racing Fixed Odds) '
							WHEN 'J' THEN N'Max Per Match must be equal to or less than Agent Max Per Match (for HR Fixed Odds)'
							WHEN 'KO' THEN N'최대 경기는 에이전트의 최대 경기보다 작아야 합니다 (Horse Racing Fixed Odds)'
							ELSE N'Max Per Match must be equal to or less than Agent Max Per Match (for HR Fixed Odds)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MaxMaxPerMatchv154) + ').', @ErrCode = 113
				
		RETURN
	END
END

--v151
IF @UpdateMinMaxBetv151 = 1
BEGIN
	IF ((@MinBetv151<>0 OR @MaxBetv151<>0 OR @MaxPerMatchv151<>0) AND (@MinBetv151>@MaxBetv151 OR @MaxBetv151>@MaxPerMatchv151))
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be less than max bet and max bet must be less than max bet per match (for Horse Racing SA Tote) '
							WHEN 'CS' THEN N'最低投注不能高于最高投注，最高投注不能高于单场最高投注设定 (for Horse Racing SA Tote)'
							WHEN 'CT' THEN N'最低投注不能高於最高投注,最高投注不能高於單場最高投注設定 (for Horse Racing SA Tote)'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดที่วางเดิมพันได้ต้องน้อยกว่าจำนวนเงินสูงสุดในการวางเดิมพันและจำนวนเงินสูงสุดในการวางเดิมพันต้องน้อยกว่าจำนวนเงินสูงสุดของเงินเดิมพันต่อเกม (for Horse Racing SA Tote)'
							WHEN 'J' THEN N'Min bet must be less than max bet and max bet must be less than max bet per match (for Horse Racing SA Tote)'
							WHEN 'KO' THEN N'최소 배팅은 최대 배팅 이하이여야 하고 최대 배팅은 경기당 최대 배팅보다 작아야 합니다 (for Horse Racing SA Tote)'
							ELSE N'Min bet must be less than max bet and max bet must be less than max bet per match (for Horse Racing SA Tote) '
						END						
						+ CHAR(13) + CHAR(10) + CONVERT(VARCHAR(20), @MinBetv151) + '-' + CONVERT(VARCHAR(20), @MaxBetv151) + '-' + CONVERT(VARCHAR(20), @MaxPerMatchv151), @ErrCode = 111
							
		RETURN
	END
	
	IF (@MinMinBetv151>0 AND @MinBetv151>0 AND @MinBetv151<@MinMinBetv151)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be equal to or greater than Agent min bet (for Horse Racing SA Tote) '
							WHEN 'CS' THEN N'最低投注需相等于或少于代理最低投注 (for Horse Racing SA Tote)'
							WHEN 'CT' THEN N'最低投注需相等於或少於代理最低投注 (for Horse Racing SA Tote)'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดในการเล่นต้องเท่ากับหรือมากกว่าจำนวนเงินขั้นต่ำในการเล่นที่กำหนดไว้ของตัวแทน  (for Horse Racing SA Tote)'
							WHEN 'J' THEN N'Min bet must be equal to or greater than Agent min bet (for Horse Racing SA Tote) '
							WHEN 'KO' THEN N'최소 배팅은 에이전트의 최소 배팅 이상이여야 합니다 (for Horse Racing SA Tote) '
							ELSE N'Min bet must be equal to or greater than Agent min bet (for Horse Racing SA Tote) '
						END						
						+' (' + CONVERT(VARCHAR(20), @MinMinBetv151) + ').', @ErrCode = 112
					
		RETURN
	END	
	IF (@MaxMaxBetv151>0 AND @MaxBetv151>0 AND @MaxBetv151>@MaxMaxBetv151)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max bet must be equal to or less than Agent max bet (for Horse Racing SA Tote) '
							WHEN 'CS' THEN N'最高投注需相等于或少于代理最高投注 (for Horse Racing SA Tote)'
							WHEN 'CT' THEN N'最高投注需相等於或少於代理最高投注 (for Horse Racing SA Tote)'
							WHEN 'TH' THEN N'จำนวนการวางเดิมพันสูงสุดต้องเท่ากับ หรือ น้อยกว่าราคาเดิมพันสูงสุดของตัวแทน (for Horse Racing SA Tote)'
							WHEN 'J' THEN N'Max bet must be equal to or less than Agent max bet (for Horse Racing SA Tote) '
							WHEN 'KO' THEN N'최대 배팅은 에이전트의 최대 배팅 이하이여야 합니다 (for Horse Racing SA Tote) '
							ELSE N'Max bet must be equal to or less than Agent max bet (for Horse Racing SA Tote) '
						END						
						+' (' + CONVERT(VARCHAR(20), @MaxMaxBetv151) + ').', @ErrCode = 113
							
		RETURN
	END
	
	IF (@MaxMaxPerMatchv151>0 AND @MaxPerMatchv151>0 AND @MaxPerMatchv151>@MaxMaxPerMatchv151)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max Per Match must be equal to or less than Agent Max Per Match  (for Horse Racing SA Tote) '
							WHEN 'CS' THEN N'单场最高投注需相等于或少于代理单场最高投注 (for Horse Racing SA Tote) '
							WHEN 'CT' THEN N'單場最高投注需相等於或少於代理單場最高投注 (for Horse Racing SA Tote) '
							WHEN 'TH' THEN N'จำนวนเงินสูงสุดในการเล่นต่อรายการต้องเท่ากับหรือน้อยกว่าจำนวนเงินสูงสุดต่อรายการที่กำหนดไว้ของตัวแทน (for Horse Racing SA Tote) '
							WHEN 'J' THEN N'Max Per Match must be equal to or less than Agent Max Per Match  (for Horse Racing SA Tote) '
							WHEN 'KO' THEN N'최대 경기는 에이전트의 최대 경기보다 작아야 합니다 (for Horse Racing SA Tote) '
							ELSE N'Max Per Match must be equal to or less than Agent Max Per Match  (for Horse Racing SA Tote)  '
						END						
						+' (' + CONVERT(VARCHAR(20), @MaxMaxPerMatchv151) + ').', @ErrCode = 113
							
		RETURN
	END
END

--v151OT
IF @UpdateMinMaxBetv151OT = 1
BEGIN
	IF ((@MinBetv151OT<>0 OR @MaxBetv151OT<>0 OR @MaxPerMatchv151OT<>0) AND (@MinBetv151OT>@MaxBetv151OT OR @MaxBetv151OT>@MaxPerMatchv151OT))
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be less than max bet and max bet must be less than max bet per match (for Horse Racing UK Tote) '
							WHEN 'CS' THEN N'最低投注不能高于最高投注，最高投注不能高于单场最高投注设定 (for Horse Racing UK Tote)'
							WHEN 'CT' THEN N'最低投注不能高於最高投注,最高投注不能高於單場最高投注設定 (for Horse Racing UK Tote)'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดที่วางเดิมพันได้ต้องน้อยกว่าจำนวนเงินสูงสุดในการวางเดิมพันและจำนวนเงินสูงสุดในการวางเดิมพันต้องน้อยกว่าจำนวนเงินสูงสุดของเงินเดิมพันต่อเกม (for Horse Racing UK Tote)'
							WHEN 'J' THEN N'Min bet must be less than max bet and max bet must be less than max bet per match (for Horse Racing UK Tote)'
							WHEN 'KO' THEN N'최소 배팅은 최대 배팅 이하이여야 하고 최대 배팅은 경기당 최대 배팅보다 작아야 합니다 (for Horse Racing UK Tote)'
							ELSE N'Min bet must be less than max bet and max bet must be less than max bet per match (for Horse Racing UK Tote) '
						END						
						+ CHAR(13) + CHAR(10) + CONVERT(VARCHAR(20), @MinBetv151OT) + '-' + CONVERT(VARCHAR(20), @MaxBetv151OT) + '-' + CONVERT(VARCHAR(20), @MaxPerMatchv151OT), @ErrCode = 111
							
		RETURN
	END
	
	IF (@MinMinBetv151OT>0 AND @MinBetv151OT>0 AND @MinBetv151OT<@MinMinBetv151OT)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be equal to or greater than Agent min bet (for Horse Racing UK Tote) '
							WHEN 'CS' THEN N'最低投注需相等于或少于代理最低投注 (for Horse Racing UK Tote)'
							WHEN 'CT' THEN N'最低投注需相等於或少於代理最低投注 (for Horse Racing UK Tote)'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดในการเล่นต้องเท่ากับหรือมากกว่าจำนวนเงินขั้นต่ำในการเล่นที่กำหนดไว้ของตัวแทน (for Horse Racing UK Tote)'
							WHEN 'J' THEN N'Min bet must be equal to or greater than Agent min bet (for Horse Racing UK Tote) '
							WHEN 'KO' THEN N'최소 배팅은 에이전트의 최소 배팅 이상이여야 합니다 (for Horse Racing UK Tote) '
							ELSE N'Min bet must be equal to or greater than Agent min bet (for Horse Racing UK Tote) '
						END						
						+' (' + CONVERT(VARCHAR(20), @MinMinBetv151OT) + ').', @ErrCode = 112
							
		RETURN
	END	
	IF (@MaxMaxBetv151OT>0 AND @MaxBetv151OT>0 AND @MaxBetv151OT>@MaxMaxBetv151OT)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max bet must be equal to or less than Agent max bet (for Horse Racing UK Tote) '
							WHEN 'CS' THEN N'最高投注需相等于或少于代理最高投注 (for Horse Racing UK Tote)'
							WHEN 'CT' THEN N'最高投注需相等於或少於代理最高投注 (for Horse Racing UK Tote)'
							WHEN 'TH' THEN N'จำนวนการวางเดิมพันสูงสุดต้องเท่ากับ หรือ น้อยกว่าราคาเดิมพันสูงสุดของตัวแทน (for Horse Racing UK Tote)'
							WHEN 'J' THEN N'Max bet must be equal to or less than Agent max bet (for Horse Racing UK Tote) '
							WHEN 'KO' THEN N'최대 배팅은 에이전트의 최대 배팅 이하이여야 합니다 (for Horse Racing UK Tote) '
							ELSE N'Max bet must be equal to or less than Agent max bet (for Horse Racing UK Tote) '
						END						
						+' (' + CONVERT(VARCHAR(20), @MaxMaxBetv151OT) + ').', @ErrCode = 113
							
		RETURN
	END
	
	IF (@MaxMaxPerMatchv151OT>0 AND @MaxPerMatchv151OT>0 AND @MaxPerMatchv151OT>@MaxMaxPerMatchv151OT)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max Per Match must be equal to or less than Agent Max Per Match  (for Horse Racing UK Tote) '
							WHEN 'CS' THEN N'单场最高投注需相等于或少于代理单场最高投注 (for Horse Racing UK Tote) '
							WHEN 'CT' THEN N'單場最高投注需相等於或少於代理單場最高投注 (for Horse Racing UK Tote) '
							WHEN 'TH' THEN N'จำนวนเงินสูงสุดในการเล่นต่อรายการต้องเท่ากับหรือน้อยกว่าจำนวนเงินสูงสุดต่อรายการที่กำหนดไว้ของตัวแทน (for Horse Racing UK Tote) '
							WHEN 'J' THEN N'Max Per Match must be equal to or less than Agent Max Per Match  (for Horse Racing UK Tote) '
							WHEN 'KO' THEN N'최대 경기는 에이전트의 최대 경기보다 작아야 합니다 (for Horse Racing UK Tote) '
							ELSE N'Max Per Match must be equal to or less than Agent Max Per Match  (for Horse Racing UK Tote)  '
						END						
						+' (' + CONVERT(VARCHAR(20), @MaxMaxPerMatchv151OT) + ').', @ErrCode = 113
							
		RETURN
	END
END

--v151_51
IF @UpdateMinMaxBetv151_51 = 1
BEGIN
	IF ((@MinBetv151_51<>0 OR @MaxBetv151_51<>0 OR @MaxPerMatchv151_51<>0) AND (@MinBetv151_51>@MaxBetv151_51 OR @MaxBetv151_51>@MaxPerMatchv151_51))
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be less than max bet and max bet must be less than max bet per match (for Horse Racing AU Tote) '
							WHEN 'CS' THEN N'最低投注不能高于最高投注，最高投注不能高于单场最高投注设定 (for Horse Racing AU Tote)'
							WHEN 'CT' THEN N'最低投注不能高於最高投注,最高投注不能高於單場最高投注設定 (for Horse Racing AU Tote)'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดที่วางเดิมพันได้ต้องน้อยกว่าจำนวนเงินสูงสุดในการวางเดิมพันและจำนวนเงินสูงสุดในการวางเดิมพันต้องน้อยกว่าจำนวนเงินสูงสุดของเงินเดิมพันต่อเกม (for Horse Racing AU Tote)'
							WHEN 'J' THEN N'Min bet must be less than max bet and max bet must be less than max bet per match (for Horse Racing AU Tote)'
							WHEN 'KO' THEN N'최소 배팅은 최대 배팅 이하이여야 하고 최대 배팅은 경기당 최대 배팅보다 작아야 합니다 (for Horse Racing AU Tote)'
							ELSE N'Min bet must be less than max bet and max bet must be less than max bet per match (for Horse Racing AU Tote) '
						END						
						+ CHAR(13) + CHAR(10) + CONVERT(VARCHAR(20), @MinBetv151_51) + '-' + CONVERT(VARCHAR(20), @MaxBetv151_51) + '-' + CONVERT(VARCHAR(20), @MaxPerMatchv151_51), @ErrCode = 111
							
		RETURN
	END
	
	IF (@MinMinBetv151_51>0 AND @MinBetv151_51>0 AND @MinBetv151_51<@MinMinBetv151_51)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be equal to or greater than Agent min bet (for Horse Racing AU Tote) '
							WHEN 'CS' THEN N'最低投注需相等于或少于代理最低投注 (for Horse Racing AU Tote)'
							WHEN 'CT' THEN N'最低投注需相等於或少於代理最低投注 (for Horse Racing AU Tote)'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดในการเล่นต้องเท่ากับหรือมากกว่าจำนวนเงินขั้นต่ำในการเล่นที่กำหนดไว้ของตัวแทน  (for Horse Racing AU Tote)'
							WHEN 'J' THEN N'Min bet must be equal to or greater than Agent min bet (for Horse Racing AU Tote) '
							WHEN 'KO' THEN N'최소 배팅은 에이전트의 최소 배팅 이상이여야 합니다 (for Horse Racing AU Tote) '
							ELSE N'Min bet must be equal to or greater than Agent min bet (for Horse Racing AU Tote) '
						END						
						+' (' + CONVERT(VARCHAR(20), @MinMinBetv151_51) + ').', @ErrCode = 112
					
		RETURN
	END	
	IF (@MaxMaxBetv151_51>0 AND @MaxBetv151_51>0 AND @MaxBetv151_51>@MaxMaxBetv151_51)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max bet must be equal to or less than Agent max bet (for Horse Racing AU Tote) '
							WHEN 'CS' THEN N'最高投注需相等于或少于代理最高投注 (for Horse Racing AU Tote)'
							WHEN 'CT' THEN N'最高投注需相等於或少於代理最高投注 (for Horse Racing AU Tote)'
							WHEN 'TH' THEN N'จำนวนการวางเดิมพันสูงสุดต้องเท่ากับ หรือ น้อยกว่าราคาเดิมพันสูงสุดของตัวแทน (for Horse Racing AU Tote)'
							WHEN 'J' THEN N'Max bet must be equal to or less than Agent max bet (for Horse Racing AU Tote) '
							WHEN 'KO' THEN N'최대 배팅은 에이전트의 최대 배팅 이하이여야 합니다 (for Horse Racing AU Tote) '
							ELSE N'Max bet must be equal to or less than Agent max bet (for Horse Racing AU Tote) '
						END						
						+' (' + CONVERT(VARCHAR(20), @MaxMaxBetv151_51) + ').', @ErrCode = 113
							
		RETURN
	END
	
	IF (@MaxMaxPerMatchv151_51>0 AND @MaxPerMatchv151_51>0 AND @MaxPerMatchv151_51>@MaxMaxPerMatchv151_51)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max Per Match must be equal to or less than Agent Max Per Match  (for Horse Racing AU Tote) '
							WHEN 'CS' THEN N'单场最高投注需相等于或少于代理单场最高投注 (for Horse Racing AU Tote) '
							WHEN 'CT' THEN N'單場最高投注需相等於或少於代理單場最高投注 (for Horse Racing AU Tote) '
							WHEN 'TH' THEN N'จำนวนเงินสูงสุดในการเล่นต่อรายการต้องเท่ากับหรือน้อยกว่าจำนวนเงินสูงสุดต่อรายการที่กำหนดไว้ของตัวแทน (for Horse Racing AU Tote) '
							WHEN 'J' THEN N'Max Per Match must be equal to or less than Agent Max Per Match  (for Horse Racing AU Tote) '
							WHEN 'KO' THEN N'최대 경기는 에이전트의 최대 경기보다 작아야 합니다 (for Horse Racing AU Tote) '
							ELSE N'Max Per Match must be equal to or less than Agent Max Per Match  (for Horse Racing AU Tote)  '
						END						
						+' (' + CONVERT(VARCHAR(20), @MaxMaxPerMatchv151_51) + ').', @ErrCode = 113
							
		RETURN 
	END
END
--v152_41
IF @UpdateMinMaxBetv152_41 = 1
BEGIN
	IF ((@MinBetv152_41<>0 OR @MaxBetv152_41<>0 OR @MaxPerMatchv152_41<>0) AND (@MinBetv152_41>@MaxBetv152_41 OR @MaxBetv152_41>@MaxPerMatchv152_41))
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be less than max bet and max bet must be less than max bet per match (for Greyhound Racing UK Tote) '
							WHEN 'CS' THEN N'最低投注不能高于最高投注，最高投注不能高于单场最高投注设定 (for Greyhound Racing UK Tote)'
							WHEN 'CT' THEN N'最低投注不能高於最高投注,最高投注不能高於單場最高投注設定 (for Greyhound Racing UK Tote)'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดที่วางเดิมพันได้ต้องน้อยกว่าจำนวนเงินสูงสุดในการวางเดิมพันและจำนวนเงินสูงสุดในการวางเดิมพันต้องน้อยกว่าจำนวนเงินสูงสุดของเงินเดิมพันต่อเกม (for Greyhound Racing UK Tote)'
							WHEN 'J' THEN N'Min bet must be less than max bet and max bet must be less than max bet per match (for Greyhound Racing UK Tote)'
							WHEN 'KO' THEN N'최소 배팅은 최대 배팅 이하이여야 하고 최대 배팅은 경기당 최대 배팅보다 작아야 합니다 (for Greyhound Racing UK Tote)'
							ELSE N'Min bet must be less than max bet and max bet must be less than max bet per match (for Greyhound Racing UK Tote) '
						END						
						+ CHAR(13) + CHAR(10) + CONVERT(VARCHAR(20), @MinBetv152_41) + '-' + CONVERT(VARCHAR(20), @MaxBetv152_41) + '-' + CONVERT(VARCHAR(20), @MaxPerMatchv152_41), @ErrCode = 111
							
		RETURN
	END
	
	IF (@MinMinBetv152_41>0 AND @MinBetv152_41>0 AND @MinBetv152_41<@MinMinBetv152_41)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be equal to or greater than Agent min bet (for Greyhound Racing UK Tote) '
							WHEN 'CS' THEN N'最低投注需相等于或少于代理最低投注 (for Greyhound Racing UK Tote)'
							WHEN 'CT' THEN N'最低投注需相等於或少於代理最低投注 (for Greyhound Racing UK Tote)'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดในการเล่นต้องเท่ากับหรือมากกว่าจำนวนเงินขั้นต่ำในการเล่นที่กำหนดไว้ของตัวแทน  (for Greyhound Racing UK Tote)'
							WHEN 'J' THEN N'Min bet must be equal to or greater than Agent min bet (for Greyhound Racing UK Tote) '
							WHEN 'KO' THEN N'최소 배팅은 에이전트의 최소 배팅 이상이여야 합니다 (for Greyhound Racing UK Tote) '
							ELSE N'Min bet must be equal to or greater than Agent min bet (for Greyhound Racing UK Tote) '
						END						
						+' (' + CONVERT(VARCHAR(20), @MinMinBetv152_41) + ').', @ErrCode = 112
					
		RETURN
	END	
	IF (@MaxMaxBetv152_41>0 AND @MaxBetv152_41>0 AND @MaxBetv152_41>@MaxMaxBetv152_41)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max bet must be equal to or less than Agent max bet (for Greyhound Racing UK Tote) '
							WHEN 'CS' THEN N'最高投注需相等于或少于代理最高投注 (for Greyhound Racing UK Tote)'
							WHEN 'CT' THEN N'最高投注需相等於或少於代理最高投注 (for Greyhound Racing UK Tote)'
							WHEN 'TH' THEN N'จำนวนการวางเดิมพันสูงสุดต้องเท่ากับ หรือ น้อยกว่าราคาเดิมพันสูงสุดของตัวแทน (for Greyhound Racing UK Tote)'
							WHEN 'J' THEN N'Max bet must be equal to or less than Agent max bet (for Greyhound Racing UK Tote) '
							WHEN 'KO' THEN N'최대 배팅은 에이전트의 최대 배팅 이하이여야 합니다 (for Greyhound Racing UK Tote) '
							ELSE N'Max bet must be equal to or less than Agent max bet (for Greyhound Racing UK Tote) '
						END						
						+' (' + CONVERT(VARCHAR(20), @MaxMaxBetv152_41) + ').', @ErrCode = 113
							
		RETURN
	END
	
	IF (@MaxMaxPerMatchv152_41>0 AND @MaxPerMatchv152_41>0 AND @MaxPerMatchv152_41>@MaxMaxPerMatchv152_41)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max Per Match must be equal to or less than Agent Max Per Match  (for Greyhound Racing UK Tote) '
							WHEN 'CS' THEN N'单场最高投注需相等于或少于代理单场最高投注 (for Greyhound Racing UK Tote) '
							WHEN 'CT' THEN N'單場最高投注需相等於或少於代理單場最高投注 (for Greyhound Racing UK Tote) '
							WHEN 'TH' THEN N'จำนวนเงินสูงสุดในการเล่นต่อรายการต้องเท่ากับหรือน้อยกว่าจำนวนเงินสูงสุดต่อรายการที่กำหนดไว้ของตัวแทน (for Greyhound Racing UK Tote) '
							WHEN 'J' THEN N'Max Per Match must be equal to or less than Agent Max Per Match  (for Greyhound Racing UK Tote) '
							WHEN 'KO' THEN N'최대 경기는 에이전트의 최대 경기보다 작아야 합니다 (for Greyhound Racing UK Tote) '
							ELSE N'Max Per Match must be equal to or less than Agent Max Per Match  (for Greyhound Racing UK Tote)  '
						END						
						+' (' + CONVERT(VARCHAR(20), @MaxMaxPerMatchv152_41) + ').', @ErrCode = 113
							
		RETURN
	END
END
--v152_51
IF @UpdateMinMaxBetv152_51 = 1
BEGIN
	IF ((@MinBetv152_51<>0 OR @MaxBetv152_51<>0 OR @MaxPerMatchv152_51<>0) AND (@MinBetv152_51>@MaxBetv152_51 OR @MaxBetv152_51>@MaxPerMatchv152_51))
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be less than max bet and max bet must be less than max bet per match (for Greyhound Racing AU Tote) '
							WHEN 'CS' THEN N'最低投注不能高于最高投注，最高投注不能高于单场最高投注设定 (for Greyhound Racing AU Tote)'
							WHEN 'CT' THEN N'最低投注不能高於最高投注,最高投注不能高於單場最高投注設定 (for Greyhound Racing AU Tote)'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดที่วางเดิมพันได้ต้องน้อยกว่าจำนวนเงินสูงสุดในการวางเดิมพันและจำนวนเงินสูงสุดในการวางเดิมพันต้องน้อยกว่าจำนวนเงินสูงสุดของเงินเดิมพันต่อเกม (for Greyhound Racing AU Tote)'
							WHEN 'J' THEN N'Min bet must be less than max bet and max bet must be less than max bet per match (for Greyhound Racing AU Tote)'
							WHEN 'KO' THEN N'최소 배팅은 최대 배팅 이하이여야 하고 최대 배팅은 경기당 최대 배팅보다 작아야 합니다 (for Greyhound Racing AU Tote)'
							ELSE N'Min bet must be less than max bet and max bet must be less than max bet per match (for Greyhound Racing AU Tote) '
						END						
						+ CHAR(13) + CHAR(10) + CONVERT(VARCHAR(20), @MinBetv152_51) + '-' + CONVERT(VARCHAR(20), @MaxBetv152_51) + '-' + CONVERT(VARCHAR(20), @MaxPerMatchv152_51), @ErrCode = 111
							
		RETURN
	END
	
	IF (@MinMinBetv152_51>0 AND @MinBetv152_51>0 AND @MinBetv152_51<@MinMinBetv152_51)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be equal to or greater than Agent min bet (for Greyhound Racing AU Tote) '
							WHEN 'CS' THEN N'最低投注需相等于或少于代理最低投注 (for Greyhound Racing AU Tote)'
							WHEN 'CT' THEN N'最低投注需相等於或少於代理最低投注 (for Greyhound Racing AU Tote)'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดในการเล่นต้องเท่ากับหรือมากกว่าจำนวนเงินขั้นต่ำในการเล่นที่กำหนดไว้ของตัวแทน  (for Greyhound Racing AU Tote)'
							WHEN 'J' THEN N'Min bet must be equal to or greater than Agent min bet (for Greyhound Racing AU Tote) '
							WHEN 'KO' THEN N'최소 배팅은 에이전트의 최소 배팅 이상이여야 합니다 (for Greyhound Racing AU Tote) '
							ELSE N'Min bet must be equal to or greater than Agent min bet (for Greyhound Racing AU Tote) '
						END						
						+' (' + CONVERT(VARCHAR(20), @MinMinBetv152_51) + ').', @ErrCode = 112
					
		RETURN
	END	
	IF (@MaxMaxBetv152_51>0 AND @MaxBetv152_51>0 AND @MaxBetv152_51>@MaxMaxBetv152_51)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max bet must be equal to or less than Agent max bet (for Greyhound Racing AU Tote) '
							WHEN 'CS' THEN N'最高投注需相等于或少于代理最高投注 (for Greyhound Racing AU Tote)'
							WHEN 'CT' THEN N'最高投注需相等於或少於代理最高投注 (for Greyhound Racing AU Tote)'
							WHEN 'TH' THEN N'จำนวนการวางเดิมพันสูงสุดต้องเท่ากับ หรือ น้อยกว่าราคาเดิมพันสูงสุดของตัวแทน (for Greyhound Racing AU Tote)'
							WHEN 'J' THEN N'Max bet must be equal to or less than Agent max bet (for Greyhound Racing AU Tote) '
							WHEN 'KO' THEN N'최대 배팅은 에이전트의 최대 배팅 이하이여야 합니다 (for Greyhound Racing AU Tote) '
							ELSE N'Max bet must be equal to or less than Agent max bet (for Greyhound Racing AU Tote) '
						END						
						+' (' + CONVERT(VARCHAR(20), @MaxMaxBetv152_51) + ').', @ErrCode = 113
							
		RETURN
	END
	
	IF (@MaxMaxPerMatchv152_51>0 AND @MaxPerMatchv152_51>0 AND @MaxPerMatchv152_51>@MaxMaxPerMatchv152_51)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max Per Match must be equal to or less than Agent Max Per Match  (for Greyhound Racing AU Tote) '
							WHEN 'CS' THEN N'单场最高投注需相等于或少于代理单场最高投注 (for Greyhound Racing AU Tote) '
							WHEN 'CT' THEN N'單場最高投注需相等於或少於代理單場最高投注 (for Greyhound Racing AU Tote) '
							WHEN 'TH' THEN N'จำนวนเงินสูงสุดในการเล่นต่อรายการต้องเท่ากับหรือน้อยกว่าจำนวนเงินสูงสุดต่อรายการที่กำหนดไว้ของตัวแทน (for Greyhound Racing AU Tote) '
							WHEN 'J' THEN N'Max Per Match must be equal to or less than Agent Max Per Match  (for Greyhound Racing AU Tote) '
							WHEN 'KO' THEN N'최대 경기는 에이전트의 최대 경기보다 작아야 합니다 (for Greyhound Racing AU Tote) '
							ELSE N'Max Per Match must be equal to or less than Agent Max Per Match  (for Greyhound Racing AU Tote)  '
						END						
						+' (' + CONVERT(VARCHAR(20), @MaxMaxPerMatchv152_51) + ').', @ErrCode = 113
							
		RETURN
	END
END
--v153_51
IF @UpdateMinMaxBetv153_51 = 1
BEGIN
	IF ((@MinBetv153_51<>0 OR @MaxBetv153_51<>0 OR @MaxPerMatchv153_51<>0) AND (@MinBetv153_51>@MaxBetv153_51 OR @MaxBetv153_51>@MaxPerMatchv153_51))
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be less than max bet and max bet must be less than max bet per match (for Harness Racing AU Tote) '
							WHEN 'CS' THEN N'最低投注不能高于最高投注，最高投注不能高于单场最高投注设定 (for Harness Racing AU Tote)'
							WHEN 'CT' THEN N'最低投注不能高於最高投注,最高投注不能高於單場最高投注設定 (for Harness Racing AU Tote)'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดที่วางเดิมพันได้ต้องน้อยกว่าจำนวนเงินสูงสุดในการวางเดิมพันและจำนวนเงินสูงสุดในการวางเดิมพันต้องน้อยกว่าจำนวนเงินสูงสุดของเงินเดิมพันต่อเกม (for Harness Racing AU Tote)'
							WHEN 'J' THEN N'Min bet must be less than max bet and max bet must be less than max bet per match (for Harness Racing AU Tote)'
							WHEN 'KO' THEN N'최소 배팅은 최대 배팅 이하이여야 하고 최대 배팅은 경기당 최대 배팅보다 작아야 합니다 (for Harness Racing AU Tote)'
							ELSE N'Min bet must be less than max bet and max bet must be less than max bet per match (for Harness Racing AU Tote) '
						END						
						+ CHAR(13) + CHAR(10) + CONVERT(VARCHAR(20), @MinBetv153_51) + '-' + CONVERT(VARCHAR(20), @MaxBetv153_51) + '-' + CONVERT(VARCHAR(20), @MaxPerMatchv153_51), @ErrCode = 111
							
		RETURN
	END
	
	IF (@MinMinBetv153_51>0 AND @MinBetv153_51>0 AND @MinBetv153_51<@MinMinBetv153_51)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be equal to or greater than Agent min bet (for Harness Racing AU Tote) '
							WHEN 'CS' THEN N'最低投注需相等于或少于代理最低投注 (for Harness Racing AU Tote)'
							WHEN 'CT' THEN N'最低投注需相等於或少於代理最低投注 (for Harness Racing AU Tote)'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดในการเล่นต้องเท่ากับหรือมากกว่าจำนวนเงินขั้นต่ำในการเล่นที่กำหนดไว้ของตัวแทน  (for Harness Racing AU Tote)'
							WHEN 'J' THEN N'Min bet must be equal to or greater than Agent min bet (for Harness Racing AU Tote) '
							WHEN 'KO' THEN N'최소 배팅은 에이전트의 최소 배팅 이상이여야 합니다 (for Harness Racing AU Tote) '
							ELSE N'Min bet must be equal to or greater than Agent min bet (for Harness Racing AU Tote) '
						END						
						+' (' + CONVERT(VARCHAR(20), @MinMinBetv153_51) + ').', @ErrCode = 112
					
		RETURN
	END	
	IF (@MaxMaxBetv153_51>0 AND @MaxBetv153_51>0 AND @MaxBetv153_51>@MaxMaxBetv153_51)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max bet must be equal to or less than Agent max bet (for Harness Racing AU Tote) '
							WHEN 'CS' THEN N'最高投注需相等于或少于代理最高投注 (for Harness Racing AU Tote)'
							WHEN 'CT' THEN N'最高投注需相等於或少於代理最高投注 (for Harness Racing AU Tote)'
							WHEN 'TH' THEN N'จำนวนการวางเดิมพันสูงสุดต้องเท่ากับ หรือ น้อยกว่าราคาเดิมพันสูงสุดของตัวแทน (for Harness Racing AU Tote)'
							WHEN 'J' THEN N'Max bet must be equal to or less than Agent max bet (for Harness Racing AU Tote) '
							WHEN 'KO' THEN N'최대 배팅은 에이전트의 최대 배팅 이하이여야 합니다 (for Harness Racing AU Tote) '
							ELSE N'Max bet must be equal to or less than Agent max bet (for Harness Racing AU Tote) '
						END						
						+' (' + CONVERT(VARCHAR(20), @MaxMaxBetv153_51) + ').', @ErrCode = 113
							
		RETURN
	END
	
	IF (@MaxMaxPerMatchv153_51>0 AND @MaxPerMatchv153_51>0 AND @MaxPerMatchv153_51>@MaxMaxPerMatchv153_51)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max Per Match must be equal to or less than Agent Max Per Match  (for Harness Racing AU Tote) '
							WHEN 'CS' THEN N'单场最高投注需相等于或少于代理单场最高投注 (for Harness Racing AU Tote) '
							WHEN 'CT' THEN N'單場最高投注需相等於或少於代理單場最高投注 (for Harness Racing AU Tote) '
							WHEN 'TH' THEN N'จำนวนเงินสูงสุดในการเล่นต่อรายการต้องเท่ากับหรือน้อยกว่าจำนวนเงินสูงสุดต่อรายการที่กำหนดไว้ของตัวแทน (for Harness Racing AU Tote) '
							WHEN 'J' THEN N'Max Per Match must be equal to or less than Agent Max Per Match  (for Harness Racing AU Tote) '
							WHEN 'KO' THEN N'최대 경기는 에이전트의 최대 경기보다 작아야 합니다 (for Harness Racing AU Tote) '
							ELSE N'Max Per Match must be equal to or less than Agent Max Per Match  (for Harness Racing AU Tote)  '
						END						
						+' (' + CONVERT(VARCHAR(20), @MaxMaxPerMatchv153_51) + ').', @ErrCode = 113
							
		RETURN
	END
END

--v161
IF @UpdateMinMaxBetv161 = 1
BEGIN
	IF ((@MinBetv161<>0 OR @MaxBetv161<>0 OR @MaxPerMatchv161<>0) AND (@MinBetv161>@MaxBetv161 OR @MaxBetv161>@MaxPerMatchv161 ))
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be less than max bet , max bet must be less than max bet per match(for Number Game) '
							WHEN 'CS' THEN N'最低投注不能高于最高投注，最高投注不能高于单场最高投注设定，单粒球最高投注必須大於最高投注和低於单场游戏最高投注'
							WHEN 'CT' THEN N'最低投注不能高於最高投注,最高投注不能高於單場最高投注設定, 單粒球最高投注必須大於最高投注和低於單場遊戲最高投注'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดที่วางเดิมพันได้ต้องน้อยกว่าจำนวนเงินสูงสุดในการวางเดิมพันและจำนวนเงินสูงสุดในการวางเดิมพันต้องน้อยกว่าจำนวนเงินสูงสุดของเงินเดิมพันต่อเกม'
							WHEN 'J' THEN N'Min bet must be less than max bet and max bet must be less than max bet per match(for Number Game)'
							WHEN 'KO' THEN N'최소 배팅은 최대 배팅 이하이여야 하고 최대 배팅은 경기당 최대 배팅보다 작아야 합니다 (for Number Game)'
							ELSE N'Min bet must be less than max bet and max bet must be less than max bet per match(for Number Game)'
						END						
						+ CHAR(13) + CHAR(10) + CONVERT(VARCHAR(20), @MinBetv161) + '-' + CONVERT(VARCHAR(20), @MaxBetv161) + '-' + CONVERT(VARCHAR(20), @MaxPerMatchv161), @ErrCode = 111
							
		RETURN
	END
	
	IF ((@MaxBetv161<>0 OR @MaxPerMatchv161<>0 OR @MaxPerBallv161 <> 0) AND (@MaxBetv161 > @MaxPerBallv161 OR @MaxPerBallv161 > @MaxPerMatchv161))
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max Per Ball must be greater than Max Bet and less than Max Per Match (for Number Game) '
							WHEN 'CS' THEN N'单粒球最高投注必須大於最高投注和低於单场游戏最高投注'
							WHEN 'CT' THEN N'單粒球最高投注必須大於最高投注和低於單場遊戲最高投注'
							WHEN 'TH' THEN N'ค่าสูงสุดต่อบอลต้องสูงกว่าการเดิมพันสูงสุดและน้อยกว่าการตั้งค่าสูงสุดของการแข่งขัน'
							WHEN 'J' THEN N'Max Per Ball must be greater than Max Bet and less than Max Per Match (for Number Game)'
							WHEN 'KO' THEN N'Max Per Ball must be greater than Max Bet and less than Max Per Match (for Number Game)'
							ELSE N'Max Per Ball must be greater than Max Bet and less than Max Per Match (for Number Game)'
						END						
						+ CHAR(13) + CHAR(10) + CONVERT(VARCHAR(20), @MaxBetv161) + '-' + CONVERT(VARCHAR(20), @MaxPerMatchv161) + '-' + CONVERT(VARCHAR(20), @MaxPerBallv161), @ErrCode = 111							
		RETURN
	END
	
	IF (@MinMinBetv161>0 AND @MinBetv161>0 AND @MinBetv161<@MinMinBetv161)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be equal to or greater than Agent min bet (for Number Game) '
							WHEN 'CS' THEN N'最低投注需相等于或少于代理最低投注 (供数字游戏)'
							WHEN 'CT' THEN N'最低投注需相等於或少於代理最低投注 (供數字游戲)'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดในการเล่นต้องเท่ากับหรือมากกว่าจำนวนเงินขั้นต่ำในการเล่นที่กำหนดไว้ของตัวแทน (สำหรับเกมหมายเลข)'
							WHEN 'J' THEN N'Min bet must be equal to or greater than Agent min bet (for Number Game) '
							WHEN 'KO' THEN N'최소 배팅은 에이전트의 최소 배팅 이상이여야 합니다 (for Number Game) '
							ELSE N'Min bet must be equal to or greater than Agent min bet (for Number Game) '
						END						
						+' (' + CONVERT(VARCHAR(20), @MinMinBetv161) + ').', @ErrCode = 112
							
		RETURN
	END	
	IF (@MaxMaxBetv161>0 AND @MaxBetv161>0 AND @MaxBetv161>@MaxMaxBetv161)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max bet must be equal to or less than Agent max bet (for Number Game) '
							WHEN 'CS' THEN N'最高投注需相等于或少于代理最高投注 (供数字游戏)'
							WHEN 'CT' THEN N'最高投注需相等於或少於代理最高投注 (供數字游戲)'
							WHEN 'TH' THEN N'จำนวนการวางเดิมพันสูงสุดต้องเท่ากับ หรือ น้อยกว่าราคาเดิมพันสูงสุดของตัวแทน (สำหรับเกมหมายเลข)'
							WHEN 'J' THEN N'Max bet must be equal to or less than Agent max bet (for Number Game) '
							WHEN 'KO' THEN N'최대 배팅은 에이전트의 최대 배팅 이하이여야 합니다 (for Number Game) '
							ELSE N'Max bet must be equal to or less than Agent max bet (for Number Game) '
						END						
						+' (' + CONVERT(VARCHAR(20), @MaxMaxBetv161) + ').', @ErrCode = 113
							
		RETURN
	END
	IF (@MaxMaxPerBallv161 > 0 AND @MaxPerBallv161 > 0 AND @MaxPerBallv161 > @MaxMaxPerBallv161)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language
							WHEN 'E' THEN 'Sorry, Max Per Ball must be equal to or less than super agent Max Per Ball (Number Game)'
							WHEN 'CS' THEN '单粒球最高投注必須大於或等於最高投注和低於或等於单场場游戏最高投注'
							WHEN 'CT' THEN '單粒球最高投注必須大於或等於最高投注和低於或等於單場場遊戲最高投注'
							WHEN 'TH' THEN 'ขออภัย, ค่าสูงสุดต่อบอลต้องมากกว่าหรือเท่ากับการเดิมพันสูงสุด และน้อยกว่าหรือเท่ากับการตั้งค่าสูงสุดของการแข่งขัน'
							WHEN 'J' THEN 'Sorry, Max Per Ball must be equal to or less than super agent Max Per Ball (Number Game)'
							WHEN 'KO' THEN 'Sorry, Max Per Ball must be equal to or less than super agent Max Per Ball (Number Game)'
							ELSE N'Sorry, Max Per Ball must be equal to or less than super agent Max Per Ball (Number Game)'
						END
						+' (' +  CONVERT(VARCHAR(20),@MaxMaxBetv161) + ').', @ErrCode = 113
						
		RETURN
	END
	IF (@MaxMaxPerMatchv161>0 AND @MaxPerMatchv161>0 AND @MaxPerMatchv161>@MaxMaxPerMatchv161)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max Per Match must be equal to or less than Agent Max Per Match  (for Number Game) '
							WHEN 'CS' THEN N'单场最高投注需相等于或少于代理单场最高投注 (供数字游戏) '
							WHEN 'CT' THEN N'單場最高投注需相等於或少於代理單場最高投注 (供數字游戲) '
							WHEN 'TH' THEN N'จำนวนเงินสูงสุดในการเล่นต่อรายการต้องเท่ากับหรือน้อยกว่าจำนวนเงินสูงสุดต่อรายการที่กำหนดไว้ของตัวแทน (สำหรับเกมหมายเลข) '
							WHEN 'J' THEN N'Max Per Match must be equal to or less than Agent Max Per Match  (for Number Game) '
							WHEN 'KO' THEN N'최대 경기는 에이전트의 최대 경기보다 작아야 합니다 (for Number Game) '
							ELSE N'Max Per Match must be equal to or less than Agent Max Per Match  (for Number Game)  '
						END						
						+' (' + CONVERT(VARCHAR(20), @MaxMaxPerMatchv161) + ').', @ErrCode = 113
							
		RETURN
	END
END

IF @UpdateMinMaxBetv180 = 1
BEGIN
	IF ((@MinBetv180<>0 OR @MaxBetv180<>0 OR @MaxPerMatchv180<>0) AND (@MinBetv180>@MaxBetv180 OR @MaxBetv180>@MaxPerMatchv180))
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be less than max bet and max bet must be less than max bet per match (for Virtual Soccer)'
							WHEN 'CS' THEN N'最低投注不能高于最高投注，最高投注不能高于单场最高投注设定'
							WHEN 'CT' THEN N'最低投注不能高於最高投注,最高投注不能高於單場最高投注設定'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดที่วางเดิมพันได้ต้องน้อยกว่าจำนวนเงินสูงสุดในการวางเดิมพันและจำนวนเงินสูงสุดในการวางเดิมพันต้องน้อยกว่าจำนวนเงินสูงสุดของเงินเดิมพันต่อเกม (for Virtual Soccer)'
							WHEN 'J' THEN N'Min bet must be less than max bet and max bet must be less than max bet per match (for Virtual Soccer)'
							WHEN 'KO' THEN N'최소 배팅은 최대 배팅 이하이여야 하고 최대 배팅은 경기당 최대 배팅보다 작아야 합니다.'
							ELSE N'Min bet must be less than max bet and max bet must be less than max bet per match (for Virtual Soccer)'
						END						
						+ CHAR(13) + CHAR(10) + CONVERT(VARCHAR(20), @MinBetv180) + '-' + CONVERT(VARCHAR(20), @MaxBetv180) + '-' + CONVERT(VARCHAR(20), @MaxPerMatchv180), @ErrCode = 111
				
		RETURN
	END
	
	IF (@MinMinBetv180>0 AND @MinBetv180>0 AND @MinBetv180<@MinMinBetv180)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be equal to or greater than Agent min bet (for Virtual Soccer)'
							WHEN 'CS' THEN N'最低投注需相等于或少于代理最低投注'
							WHEN 'CT' THEN N'最低投注需相等於或少於代理最低投注'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดในการเล่นต้องเท่ากับหรือมากกว่าจำนวนเงินขั้นต่ำในการเล่นที่กำหนดไว้ของตัวแทน (for Virtual Soccer)'
							WHEN 'J' THEN N'Min bet must be equal to or greater than Agent min bet (for Virtual Soccer)'
							WHEN 'KO' THEN N'최소 배팅은 에이전트의 최소 배팅 이상이여야 합니다.'
							ELSE N'Min bet must be equal to or greater than Agent min bet (for Virtual Soccer)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MinMinBetv180) + ').', @ErrCode = 112
				
		RETURN
	END	
	IF (@MaxMaxBetv180>0 AND @MaxBetv180>0 AND @MaxBetv180>@MaxMaxBetv180)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max bet must be equal to or less than Agent max bet (for Virtual Soccer)'
							WHEN 'CS' THEN N'最高投注需相等于或少于代理最高投注'
							WHEN 'CT' THEN N'最高投注需相等於或少於代理最高投注'
							WHEN 'TH' THEN N'จำนวนการวางเดิมพันสูงสุดต้องเท่ากับ หรือ น้อยกว่าราคาเดิมพันสูงสุดของตัวแทน (for Virtual Soccer)'
							WHEN 'J' THEN N'Max bet must be equal to or less than Agent max bet (for Virtual Soccer)'
							WHEN 'KO' THEN N'최대 배팅은 에이전트의 최대 배팅 이하이여야 합니다.'
							ELSE N'Max bet must be equal to or less than Agent max bet (for Virtual Soccer)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MaxMaxBetv180) + ').', @ErrCode = 113
				
		RETURN
	END
	
	IF (@MaxMaxPerMatchv180>0 AND @MaxPerMatchv180>0 AND @MaxPerMatchv180>@MaxMaxPerMatchv180)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max Per Match must be equal to or less than Agent Max Per Match (for Virtual Soccer)'
							WHEN 'CS' THEN N'单场最高投注需相等于或少于代理单场最高投注'
							WHEN 'CT' THEN N'單場最高投注需相等於或少於代理單場最高投注'
							WHEN 'TH' THEN N'จำนวนเงินสูงสุดในการเล่นต่อรายการต้องเท่ากับหรือน้อยกว่าจำนวนเงินสูงสุดต่อรายการที่กำหนดไว้ของตัวแทน (for Virtual Soccer) '
							WHEN 'J' THEN N'Max Per Match must be equal to or less than Agent Max Per Match (for Virtual Soccer)'
							WHEN 'KO' THEN N'최대 경기는 에이전트의 최대 경기보다 작아야 합니다.'
							ELSE N'Max Per Match must be equal to or less than Agent Max Per Match (for Virtual Soccer)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MaxMaxPerMatchv180) + ').', @ErrCode = 113
				
		RETURN
	END
END

IF @UpdateMinMaxBetv181 = 1
BEGIN
	IF ((@MinBetv181<>0 OR @MaxBetv181<>0 OR @MaxPerMatchv181<>0) AND (@MinBetv181>@MaxBetv181 OR @MaxBetv181>@MaxPerMatchv181))
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be less than max bet and max bet must be less than max bet per match (for Virtual Horse Racing)'
							WHEN 'CS' THEN N'最低投注不能高于最高投注，最高投注不能高于单场最高投注设定'
							WHEN 'CT' THEN N'最低投注不能高於最高投注,最高投注不能高於單場最高投注設定'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดที่วางเดิมพันได้ต้องน้อยกว่าจำนวนเงินสูงสุดในการวางเดิมพันและจำนวนเงินสูงสุดในการวางเดิมพันต้องน้อยกว่าจำนวนเงินสูงสุดของเงินเดิมพันต่อเกม (for Virtual Horse Racing)'
							WHEN 'J' THEN N'Min bet must be less than max bet and max bet must be less than max bet per match (for Virtual Horse Racing)'
							WHEN 'KO' THEN N'최소 배팅은 최대 배팅 이하이여야 하고 최대 배팅은 경기당 최대 배팅보다 작아야 합니다.'
							ELSE N'Min bet must be less than max bet and max bet must be less than max bet per match (for Virtual Horse Racing)'
						END						
						+ CHAR(13) + CHAR(10) + CONVERT(VARCHAR(20), @MinBetv181) + '-' + CONVERT(VARCHAR(20), @MaxBetv181) + '-' + CONVERT(VARCHAR(20), @MaxPerMatchv181), @ErrCode = 111
				
		RETURN
	END
	
	IF (@MinMinBetv181>0 AND @MinBetv181>0 AND @MinBetv181<@MinMinBetv181)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be equal to or greater than Agent min bet (for Virtual Horse Racing)'
							WHEN 'CS' THEN N'最低投注需相等于或少于代理最低投注'
							WHEN 'CT' THEN N'最低投注需相等於或少於代理最低投注'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดในการเล่นต้องเท่ากับหรือมากกว่าจำนวนเงินขั้นต่ำในการเล่นที่กำหนดไว้ของตัวแทน (for Virtual Horse Racing)'
							WHEN 'J' THEN N'Min bet must be equal to or greater than Agent min bet (for Virtual Horse Racing)'
							WHEN 'KO' THEN N'최소 배팅은 에이전트의 최소 배팅 이상이여야 합니다.'
							ELSE N'Min bet must be equal to or greater than Agent min bet (for Virtual Horse Racing)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MinMinBetv181) + ').', @ErrCode = 112
				
		RETURN
	END	
	IF (@MaxMaxBetv181>0 AND @MaxBetv181>0 AND @MaxBetv181>@MaxMaxBetv181)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max bet must be equal to or less than Agent max bet (for Virtual Horse Racing)'
							WHEN 'CS' THEN N'最高投注需相等于或少于代理最高投注'
							WHEN 'CT' THEN N'最高投注需相等於或少於代理最高投注'
							WHEN 'TH' THEN N'จำนวนการวางเดิมพันสูงสุดต้องเท่ากับ หรือ น้อยกว่าราคาเดิมพันสูงสุดของตัวแทน (for Virtual Horse Racing)'
							WHEN 'J' THEN N'Max bet must be equal to or less than Agent max bet (for Virtual Horse Racing)'
							WHEN 'KO' THEN N'최대 배팅은 에이전트의 최대 배팅 이하이여야 합니다.'
							ELSE N'Max bet must be equal to or less than Agent max bet (for Virtual Horse Racing)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MaxMaxBetv181) + ').', @ErrCode = 113
				
		RETURN
	END
	
	IF (@MaxMaxPerMatchv181>0 AND @MaxPerMatchv181>0 AND @MaxPerMatchv181>@MaxMaxPerMatchv181)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max Per Match must be equal to or less than Agent Max Per Match (for Virtual Horse Racing)'
							WHEN 'CS' THEN N'单场最高投注需相等于或少于代理单场最高投注'
							WHEN 'CT' THEN N'單場最高投注需相等於或少於代理單場最高投注'
							WHEN 'TH' THEN N'จำนวนเงินสูงสุดในการเล่นต่อรายการต้องเท่ากับหรือน้อยกว่าจำนวนเงินสูงสุดต่อรายการที่กำหนดไว้ของตัวแทน (for Virtual Horse Racing) '
							WHEN 'J' THEN N'Max Per Match must be equal to or less than Agent Max Per Match (for Virtual Horse Racing)'
							WHEN 'KO' THEN N'최대 경기는 에이전트의 최대 경기보다 작아야 합니다.'
							ELSE N'Max Per Match must be equal to or less than Agent Max Per Match (for Virtual Horse Racing)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MaxMaxPerMatchv181) + ').', @ErrCode = 113
				
		RETURN
	END
END

IF @UpdateMinMaxBetv182 = 1
BEGIN
	IF ((@MinBetv182<>0 OR @MaxBetv182<>0 OR @MaxPerMatchv182<>0) AND (@MinBetv182>@MaxBetv182 OR @MaxBetv182>@MaxPerMatchv182))
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be less than max bet and max bet must be less than max bet per match (for Virtual Greyhounds)'
							WHEN 'CS' THEN N'最低投注不能高于最高投注，最高投注不能高于单场最高投注设定'
							WHEN 'CT' THEN N'最低投注不能高於最高投注,最高投注不能高於單場最高投注設定'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดที่วางเดิมพันได้ต้องน้อยกว่าจำนวนเงินสูงสุดในการวางเดิมพันและจำนวนเงินสูงสุดในการวางเดิมพันต้องน้อยกว่าจำนวนเงินสูงสุดของเงินเดิมพันต่อเกม (for Virtual Greyhounds)'
							WHEN 'J' THEN N'Min bet must be less than max bet and max bet must be less than max bet per match (for Virtual Greyhounds)'
							WHEN 'KO' THEN N'최소 배팅은 최대 배팅 이하이여야 하고 최대 배팅은 경기당 최대 배팅보다 작아야 합니다.'
							ELSE N'Min bet must be less than max bet and max bet must be less than max bet per match (for Virtual Greyhounds)'
						END						
						+ CHAR(13) + CHAR(10) + CONVERT(VARCHAR(20), @MinBetv182) + '-' + CONVERT(VARCHAR(20), @MaxBetv182) + '-' + CONVERT(VARCHAR(20), @MaxPerMatchv182), @ErrCode = 111
				
		RETURN
	END
	
	IF (@MinMinBetv182>0 AND @MinBetv182>0 AND @MinBetv182<@MinMinBetv182)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be equal to or greater than Agent min bet (for Virtual Greyhounds)'
							WHEN 'CS' THEN N'最低投注需相等于或少于代理最低投注'
							WHEN 'CT' THEN N'最低投注需相等於或少於代理最低投注'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดในการเล่นต้องเท่ากับหรือมากกว่าจำนวนเงินขั้นต่ำในการเล่นที่กำหนดไว้ของตัวแทน (for Virtual Greyhounds)'
							WHEN 'J' THEN N'Min bet must be equal to or greater than Agent min bet (for Virtual Greyhounds)'
							WHEN 'KO' THEN N'최소 배팅은 에이전트의 최소 배팅 이상이여야 합니다.'
							ELSE N'Min bet must be equal to or greater than Agent min bet (for Virtual Greyhounds)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MinMinBetv182) + ').', @ErrCode = 112
				
		RETURN
	END	
	IF (@MaxMaxBetv182>0 AND @MaxBetv182>0 AND @MaxBetv182>@MaxMaxBetv182)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max bet must be equal to or less than Agent max bet (for Virtual Greyhounds)'
							WHEN 'CS' THEN N'最高投注需相等于或少于代理最高投注'
							WHEN 'CT' THEN N'最高投注需相等於或少於代理最高投注'
							WHEN 'TH' THEN N'จำนวนการวางเดิมพันสูงสุดต้องเท่ากับ หรือ น้อยกว่าราคาเดิมพันสูงสุดของตัวแทน (for Virtual Greyhounds)'
							WHEN 'J' THEN N'Max bet must be equal to or less than Agent max bet (for Virtual Greyhounds)'
							WHEN 'KO' THEN N'최대 배팅은 에이전트의 최대 배팅 이하이여야 합니다.'
							ELSE N'Max bet must be equal to or less than Agent max bet (for Virtual Greyhounds)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MaxMaxBetv182) + ').', @ErrCode = 113
				
		RETURN
	END
	
	IF (@MaxMaxPerMatchv182>0 AND @MaxPerMatchv182>0 AND @MaxPerMatchv182>@MaxMaxPerMatchv182)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max Per Match must be equal to or less than Agent Max Per Match (for Virtual Greyhounds)'
							WHEN 'CS' THEN N'单场最高投注需相等于或少于代理单场最高投注'
							WHEN 'CT' THEN N'單場最高投注需相等於或少於代理單場最高投注'
							WHEN 'TH' THEN N'จำนวนเงินสูงสุดในการเล่นต่อรายการต้องเท่ากับหรือน้อยกว่าจำนวนเงินสูงสุดต่อรายการที่กำหนดไว้ของตัวแทน (for Virtual Greyhounds) '
							WHEN 'J' THEN N'Max Per Match must be equal to or less than Agent Max Per Match (for Virtual Greyhounds)'
							WHEN 'KO' THEN N'최대 경기는 에이전트의 최대 경기보다 작아야 합니다.'
							ELSE N'Max Per Match must be equal to or less than Agent Max Per Match (for Virtual Greyhounds)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MaxMaxPerMatchv182) + ').', @ErrCode = 113
				
		RETURN
	END
END

IF @UpdateMinMaxBetv184 = 1
BEGIN
	IF ((@MinBetv184<>0 OR @MaxBetv184<>0 OR @MaxPerMatchv184<>0) AND (@MinBetv184>@MaxBetv184 OR @MaxBetv184>@MaxPerMatchv184))
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be less than max bet and max bet must be less than max bet per match (for Virtual Motor Racing)'
							WHEN 'CS' THEN N'最低投注不能高于最高投注，最高投注不能高于单场最高投注设定'
							WHEN 'CT' THEN N'最低投注不能高於最高投注,最高投注不能高於單場最高投注設定'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดที่วางเดิมพันได้ต้องน้อยกว่าจำนวนเงินสูงสุดในการวางเดิมพันและจำนวนเงินสูงสุดในการวางเดิมพันต้องน้อยกว่าจำนวนเงินสูงสุดของเงินเดิมพันต่อเกม (for Virtual Motor Racing)'
							WHEN 'J' THEN N'Min bet must be less than max bet and max bet must be less than max bet per match (for Virtual Motor Racing)'
							WHEN 'KO' THEN N'최소 배팅은 최대 배팅 이하이여야 하고 최대 배팅은 경기당 최대 배팅보다 작아야 합니다.'
							ELSE N'Min bet must be less than max bet and max bet must be less than max bet per match (for Virtual Motor Racing)'
						END						
						+ CHAR(13) + CHAR(10) + CONVERT(VARCHAR(20), @MinBetv184) + '-' + CONVERT(VARCHAR(20), @MaxBetv184) + '-' + CONVERT(VARCHAR(20), @MaxPerMatchv184), @ErrCode = 111
				
		RETURN
	END
	
	IF (@MinMinBetv184>0 AND @MinBetv184>0 AND @MinBetv184<@MinMinBetv184)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be equal to or greater than Agent min bet (for Virtual Motor Racing)'
							WHEN 'CS' THEN N'最低投注需相等于或少于代理最低投注'
							WHEN 'CT' THEN N'最低投注需相等於或少於代理最低投注'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดในการเล่นต้องเท่ากับหรือมากกว่าจำนวนเงินขั้นต่ำในการเล่นที่กำหนดไว้ของตัวแทน (for Virtual Motor Racing)'
							WHEN 'J' THEN N'Min bet must be equal to or greater than Agent min bet (for Virtual Motor Racing)'
							WHEN 'KO' THEN N'최소 배팅은 에이전트의 최소 배팅 이상이여야 합니다.'
							ELSE N'Min bet must be equal to or greater than Agent min bet (for Virtual Motor Racing)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MinMinBetv184) + ').', @ErrCode = 112
				
		RETURN
	END	
	IF (@MaxMaxBetv184>0 AND @MaxBetv184>0 AND @MaxBetv184>@MaxMaxBetv184)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max bet must be equal to or less than Agent max bet (for Virtual Motor Racing)'
							WHEN 'CS' THEN N'最高投注需相等于或少于代理最高投注'
							WHEN 'CT' THEN N'最高投注需相等於或少於代理最高投注'
							WHEN 'TH' THEN N'จำนวนการวางเดิมพันสูงสุดต้องเท่ากับ หรือ น้อยกว่าราคาเดิมพันสูงสุดของตัวแทน (for Virtual Motor Racing)'
							WHEN 'J' THEN N'Max bet must be equal to or less than Agent max bet (for Virtual Motor Racing)'
							WHEN 'KO' THEN N'최대 배팅은 에이전트의 최대 배팅 이하이여야 합니다.'
							ELSE N'Max bet must be equal to or less than Agent max bet (for Virtual Motor Racing)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MaxMaxBetv184) + ').', @ErrCode = 113
				
		RETURN
	END
	
	IF (@MaxMaxPerMatchv184>0 AND @MaxPerMatchv184>0 AND @MaxPerMatchv184>@MaxMaxPerMatchv184)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max Per Match must be equal to or less than Agent Max Per Match (for Virtual Motor Racing)'
							WHEN 'CS' THEN N'单场最高投注需相等于或少于代理单场最高投注'
							WHEN 'CT' THEN N'單場最高投注需相等於或少於代理單場最高投注'
							WHEN 'TH' THEN N'จำนวนเงินสูงสุดในการเล่นต่อรายการต้องเท่ากับหรือน้อยกว่าจำนวนเงินสูงสุดต่อรายการที่กำหนดไว้ของตัวแทน (for Virtual Motor Racing) '
							WHEN 'J' THEN N'Max Per Match must be equal to or less than Agent Max Per Match (for Virtual Motor Racing)'
							WHEN 'KO' THEN N'최대 경기는 에이전트의 최대 경기보다 작아야 합니다.'
							ELSE N'Max Per Match must be equal to or less than Agent Max Per Match (for Virtual Motor Racing)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MaxMaxPerMatchv184) + ').', @ErrCode = 113
				
		RETURN
	END
END

IF @UpdateMinMaxBetv186 = 1
BEGIN
	IF ((@MinBetv186<>0 OR @MaxBetv186<>0 OR @MaxPerMatchv186<>0) AND (@MinBetv186>@MaxBetv186 OR @MaxBetv186>@MaxPerMatchv186))
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be less than max bet and max bet must be less than max bet per match (for Virtual Tennis)'
							WHEN 'CS' THEN N'最低投注不能高于最高投注，最高投注不能高于单场最高投注设定'
							WHEN 'CT' THEN N'最低投注不能高於最高投注,最高投注不能高於單場最高投注設定'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดที่วางเดิมพันได้ต้องน้อยกว่าจำนวนเงินสูงสุดในการวางเดิมพันและจำนวนเงินสูงสุดในการวางเดิมพันต้องน้อยกว่าจำนวนเงินสูงสุดของเงินเดิมพันต่อเกม (for Virtual Tennis)'
							WHEN 'J' THEN N'Min bet must be less than max bet and max bet must be less than max bet per match (for Virtual Tennis)'
							WHEN 'KO' THEN N'최소 배팅은 최대 배팅 이하이여야 하고 최대 배팅은 경기당 최대 배팅보다 작아야 합니다.'
							ELSE N'Min bet must be less than max bet and max bet must be less than max bet per match (for Virtual Tennis)'
						END						
						+ CHAR(13) + CHAR(10) + CONVERT(VARCHAR(20), @MinBetv186) + '-' + CONVERT(VARCHAR(20), @MaxBetv186) + '-' + CONVERT(VARCHAR(20), @MaxPerMatchv186), @ErrCode = 111
				
		RETURN
	END
	
	IF (@MinMinBetv186>0 AND @MinBetv186>0 AND @MinBetv186<@MinMinBetv186)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be equal to or greater than Agent min bet (for Virtual Tennis)'
							WHEN 'CS' THEN N'最低投注需相等于或少于代理最低投注'
							WHEN 'CT' THEN N'最低投注需相等於或少於代理最低投注'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดในการเล่นต้องเท่ากับหรือมากกว่าจำนวนเงินขั้นต่ำในการเล่นที่กำหนดไว้ของตัวแทน (for Virtual Tennis)'
							WHEN 'J' THEN N'Min bet must be equal to or greater than Agent min bet (for Virtual Tennis)'
							WHEN 'KO' THEN N'최소 배팅은 에이전트의 최소 배팅 이상이여야 합니다.'
							ELSE N'Min bet must be equal to or greater than Agent min bet (for Virtual Tennis)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MinMinBetv186) + ').', @ErrCode = 112
				
		RETURN
	END	
	IF (@MaxMaxBetv186>0 AND @MaxBetv186>0 AND @MaxBetv186>@MaxMaxBetv186)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max bet must be equal to or less than Agent max bet (for Virtual Tennis)'
							WHEN 'CS' THEN N'最高投注需相等于或少于代理最高投注'
							WHEN 'CT' THEN N'最高投注需相等於或少於代理最高投注'
							WHEN 'TH' THEN N'จำนวนการวางเดิมพันสูงสุดต้องเท่ากับ หรือ น้อยกว่าราคาเดิมพันสูงสุดของตัวแทน (for Virtual Tennis)'
							WHEN 'J' THEN N'Max bet must be equal to or less than Agent max bet (for Virtual Tennis)'
							WHEN 'KO' THEN N'최대 배팅은 에이전트의 최대 배팅 이하이여야 합니다.'
							ELSE N'Max bet must be equal to or less than Agent max bet (for Virtual Tennis)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MaxMaxBetv186) + ').', @ErrCode = 113
				
		RETURN
	END
	
	IF (@MaxMaxPerMatchv186>0 AND @MaxPerMatchv186>0 AND @MaxPerMatchv186>@MaxMaxPerMatchv186)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max Per Match must be equal to or less than Agent Max Per Match (for Virtual Tennis)'
							WHEN 'CS' THEN N'单场最高投注需相等于或少于代理单场最高投注'
							WHEN 'CT' THEN N'單場最高投注需相等於或少於代理單場最高投注'
							WHEN 'TH' THEN N'จำนวนเงินสูงสุดในการเล่นต่อรายการต้องเท่ากับหรือน้อยกว่าจำนวนเงินสูงสุดต่อรายการที่กำหนดไว้ของตัวแทน (for Virtual Tennis) '
							WHEN 'J' THEN N'Max Per Match must be equal to or less than Agent Max Per Match (for Virtual Tennis)'
							WHEN 'KO' THEN N'최대 경기는 에이전트의 최대 경기보다 작아야 합니다.'
							ELSE N'Max Per Match must be equal to or less than Agent Max Per Match (for Virtual Tennis)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MaxMaxPerMatchv186) + ').', @ErrCode = 113
				
		RETURN
	END
END

IF @UpdateMinMaxBetv202 = 1
BEGIN
	IF ((@MinBetv202_1501<>0 OR @MaxBetv202_1501<>0 OR @MaxPerMatchv202_1501<>0) AND (@MinBetv202_1501>@MaxBetv2 OR @MaxBetv202_1501>@MaxPerMatchv202_1501))
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be less than max bet and max bet must be less than max bet per match (for Keno)'
							WHEN 'CS' THEN N'最低投注不能高于最高投注，最高投注不能高于单场最高投注设定'
							WHEN 'CT' THEN N'最低投注不能高於最高投注,最高投注不能高於單場最高投注設定'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดที่วางเดิมพันได้ต้องน้อยกว่าจำนวนเงินสูงสุดในการวางเดิมพันและจำนวนเงินสูงสุดในการวางเดิมพันต้องน้อยกว่าจำนวนเงินสูงสุดของเงินเดิมพันต่อเกม'
							WHEN 'J' THEN N'Min bet must be less than max bet and max bet must be less than max bet per match (for Keno)'
							WHEN 'KO' THEN N'최소 배팅은 최대 배팅 이하이여야 하고 최대 배팅은 경기당 최대 배팅보다 작아야 합니다'
							ELSE N'Min bet must be less than max bet and max bet must be less than max bet per match (for Keno)'
						END						
						+ CHAR(13) + CHAR(10) + CONVERT(VARCHAR(20), @MinBetv2) + '-' + CONVERT(VARCHAR(20), @MaxBetv2) + '-' + CONVERT(VARCHAR(20), @MaxPerMatchv2), @ErrCode = 111
				
		RETURN
	END
	
	IF (@MinMinBetv202_1501>0 AND @MinBetv202_1501>0 AND @MinBetv202_1501<@MinMinBetv202_1501)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Min bet must be equal to or greater than Agent min bet (for Keno)'
							WHEN 'CS' THEN N'最低投注需相等于或少于代理最低投注'
							WHEN 'CT' THEN N'最低投注需相等於或少於代理最低投注'
							WHEN 'TH' THEN N'จำนวนเงินต่ำสุดในการเล่นต้องเท่ากับหรือมากกว่าจำนวนเงินขั้นต่ำในการเล่นที่กำหนดไว้ของตัวแทน'
							WHEN 'J' THEN N'Min bet must be equal to or greater than Agent min bet (for Keno)'
							WHEN 'KO' THEN N'최소 배팅은 에이전트의 최소 배팅 이상이여야 합니다'
							ELSE N'Min bet must be equal to or greater than Agent min bet (for Keno)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MinMinBetv2) + ').', @ErrCode = 112
				
		RETURN
	END	
	IF (@MaxMaxBetv202_1501>0 AND @MaxBetv202_1501>0 AND @MaxBetv202_1501>@MaxMaxBetv202_1501)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max bet must be equal to or less than Agent max bet (for Keno)'
							WHEN 'CS' THEN N'最高投注需相等于或少于代理最高投注'
							WHEN 'CT' THEN N'最高投注需相等於或少於代理最高投注'
							WHEN 'TH' THEN N'จำนวนการวางเดิมพันสูงสุดต้องเท่ากับ หรือ น้อยกว่าราคาเดิมพันสูงสุดของตัวแทน'
							WHEN 'J' THEN N'Max bet must be equal to or less than Agent max bet (for Keno)'
							WHEN 'KO' THEN N'최대 배팅은 에이전트의 최대 배팅 이하이여야 합니다'
							ELSE N'Max bet must be equal to or less than Agent max bet (for Keno)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MaxMaxBetv2) + ').', @ErrCode = 113
				
		RETURN
	END
	
	IF (@MaxMaxPerMatchv202_1501>0 AND @MaxPerMatchv202_1501>0 AND @MaxPerMatchv202_1501>@MaxMaxPerMatchv202_1501)
	BEGIN
		SELECT @ErrMsg =	@UserName + ': '+
						CASE @Language 
							WHEN 'E' THEN 'Max Per Match must be equal to or less than Agent Max Per Match (for Keno)'
							WHEN 'CS' THEN N'单场最高投注需相等于或少于代理单场最高投注'
							WHEN 'CT' THEN N'單場最高投注需相等於或少於代理單場最高投注'
							WHEN 'TH' THEN N'จำนวนเงินสูงสุดในการเล่นต่อรายการต้องเท่ากับหรือน้อยกว่าจำนวนเงินสูงสุดต่อรายการที่กำหนดไว้ของตัวแทน'
							WHEN 'J' THEN N'Max Per Match must be equal to or less than Agent Max Per Match (for Keno)'
							WHEN 'KO' THEN N'최대 경기는 에이전트의 최대 경기보다 작아야 합니다'
							ELSE N'Max Per Match must be equal to or less than Agent Max Per Match (for Keno)'
						END						
						+' (' + CONVERT(VARCHAR(20), @MaxMaxPerMatchv2) + ').', @ErrCode = 113
				
		RETURN
	END
END
----------
UPDATE Dep_CustSetting WITH (ROWLOCK, UPDLOCK)
SET
	MinBet = CASE WHEN (@UpdateMinMaxBet = 1 AND sporttype=1) THEN @MinBet
				WHEN (@UpdateMinMaxBetv2 = 1 AND sporttype=2) THEN @MinBetv2
				WHEN (@UpdateMinMaxBetv3 = 1 AND sporttype=3) THEN @MinBetv3
				WHEN (@UpdateMinMaxBetv5 = 1 AND sporttype=5) THEN @MinBetv5
				WHEN (@UpdateMinMaxBetv8 = 1 AND sporttype=8) THEN @MinBetv8
				WHEN (@UpdateMinMaxBetv10 = 1 AND sporttype=10) THEN @MinBetv10
				WHEN (@UpdateMinMaxBetv11 = 1 AND sporttype=11) THEN @MinBetv11				
				WHEN (@UpdateMinMaxBetv99 = 1 AND sporttype=99 AND bettype <> 9) THEN @MinBetv99	
				WHEN (@UpdateMinMaxBetv99MP = 1 AND sporttype = 99 AND bettype = 9) THEN @MinBetv99MP			
				WHEN (@UpdateMinMaxBetv154 = 1 AND sporttype=154) THEN @MinBetv154
			ELSE minbet END,
	MaxBet = CASE WHEN (@UpdateMinMaxBet = 1 AND sporttype=1) THEN @MaxBet
				WHEN (@UpdateMinMaxBetv2 = 1 AND sporttype=2) THEN @MaxBetv2
				WHEN (@UpdateMinMaxBetv3 = 1 AND sporttype=3) THEN @MaxBetv3
				WHEN (@UpdateMinMaxBetv5 = 1 AND sporttype=5) THEN @MaxBetv5
				WHEN (@UpdateMinMaxBetv8 = 1 AND sporttype=8) THEN @MaxBetv8
				WHEN (@UpdateMinMaxBetv10 = 1 AND sporttype=10) THEN @MaxBetv10
				WHEN (@UpdateMinMaxBetv11 = 1 AND sporttype=11) THEN @MaxBetv11				
				WHEN (@UpdateMinMaxBetv99 = 1 AND sporttype=99 AND bettype <> 9) THEN @MaxBetv99				
				WHEN (@UpdateMinMaxBetv99MP = 1 AND sporttype = 99 AND bettype = 9) THEN @MaxBetv99MP
				WHEN (@UpdateMinMaxBetv154 = 1 AND sporttype=154) THEN @MaxBetv154			
			ELSE MaxBet END
WHERE custid=@custid

UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK)
SET
	MinBet = CASE WHEN (@UpdateMinMaxBetv151 = 1 AND sporttype=151 AND bettype IN(31,32)) THEN @MinBetv151
				WHEN (@UpdateMinMaxBetv151OT = 1 AND sporttype=151 AND bettype IN(41,42)) THEN @MinBetv151OT
				WHEN (@UpdateMinMaxBetv151_51 = 1 AND sporttype=151 AND bettype IN(51,52)) THEN @MinBetv151_51
				WHEN (@UpdateMinMaxBetv152_41 = 1 AND sporttype=152 AND bettype IN(41,42)) THEN @MinBetv152_41
				WHEN (@UpdateMinMaxBetv152_51 = 1 AND sporttype=152 AND bettype IN(51,52)) THEN @MinBetv152_51
				WHEN (@UpdateMinMaxBetv153_51 = 1 AND sporttype=153 AND bettype IN(51,52)) THEN @MinBetv153_51
				
				WHEN (@UpdateMinMaxBetv161 = 1 AND sporttype = 161) THEN @MinBetv161
				WHEN (@UpdateMinMaxBetv180 = 1 AND sporttype = 180) THEN @MinBetv180
				WHEN (@UpdateMinMaxBetv181 = 1 AND sporttype = 181) THEN @MinBetv181
				WHEN (@UpdateMinMaxBetv182 = 1 AND sporttype = 182) THEN @MinBetv182
				WHEN (@UpdateMinMaxBetv184 = 1 AND sporttype = 184) THEN @MinBetv184
				WHEN (@UpdateMinMaxBetv186 = 1 AND sporttype = 186) THEN @MinBetv186
			ELSE minbet END,
	MaxBet = CASE WHEN (@UpdateMinMaxBetv151 = 1 AND sporttype=151 AND bettype IN(31,32)) THEN @MaxBetv151
				WHEN (@UpdateMinMaxBetv151OT = 1 AND sporttype=151 AND bettype IN(41,42)) THEN @MaxBetv151OT
				WHEN (@UpdateMinMaxBetv151_51 = 1 AND sporttype=151 AND bettype IN(51,52)) THEN @MaxBetv151_51
				WHEN (@UpdateMinMaxBetv152_41 = 1 AND sporttype=152 AND bettype IN(41,42)) THEN @MaxBetv152_41
				WHEN (@UpdateMinMaxBetv152_51 = 1 AND sporttype=152 AND bettype IN(51,52)) THEN @MaxBetv152_51
				WHEN (@UpdateMinMaxBetv153_51 = 1 AND sporttype=153 AND bettype IN(51,52)) THEN @MaxBetv153_51
				
				WHEN (@UpdateMinMaxBetv161 = 1 AND sporttype = 161) THEN @MaxBetv161
				WHEN (@UpdateMinMaxBetv180 = 1 AND sporttype = 180) THEN @MaxBetv180
				WHEN (@UpdateMinMaxBetv181 = 1 AND sporttype = 181) THEN @MaxBetv181
				WHEN (@UpdateMinMaxBetv182 = 1 AND sporttype = 182) THEN @MaxBetv182
				WHEN (@UpdateMinMaxBetv184 = 1 AND sporttype = 184) THEN @MaxBetv184
				WHEN (@UpdateMinMaxBetv186 = 1 AND sporttype = 186) THEN @MaxBetv186
			ELSE MaxBet END
WHERE custid=@custid

UPDATE cg WITH (ROWLOCK, UPDLOCK)
SET
	MinBet = CASE WHEN @UpdateMinMaxBetv202 = 1 THEN @MinBetv202_1501 ELSE minbet END,
	MaxBet = CASE WHEN @UpdateMinMaxBetv202 = 1 THEN @MaxBetv202_1501 ELSE MaxBet END,
	MaxPerGameType = CASE WHEN @UpdateMinMaxBetv202 = 1 THEN @MaxPerMatchv202_1501 ELSE MaxPerGameType END
FROM CustGameType cg WITH (ROWLOCK, UPDLOCK)
	INNER JOIN bodb02.dbo.GameType gt WITH (NOLOCK) ON cg.GameTypeID = gt.GameTypeID
WHERE custid=@custid AND gt.IBCBetTypeID BETWEEN 1501 AND 1509

IF (@@ERROR <> 0)
BEGIN
	
	SELECT @ErrMsg = @UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Update process is unsuccessful !'
						WHEN 'CS' THEN N'更新程序不成功 !'
						WHEN 'CT' THEN N'更新程序不成功 !'
						WHEN 'TH' THEN N'ขั้นตอนหรือกระบวนการในการปรับยอดไม่เสร็จสิ้น!'
						WHEN 'J' THEN N'アップデート出来ません。'
						WHEN 'KO' THEN N'업데이트에 실패했습니다.'
						ELSE N'Update process is unsuccessful !'
					END, @ErrCode = 115
	RETURN
END

UPDATE custinfo WITH (ROWLOCK, UPDLOCK)
SET 	
	MaxPerMatch = CASE WHEN @UpdateMinMaxBet=1 THEN @MaxPerMatch ELSE MaxPerMatch END,
	MaxPerMatch2 = CASE WHEN @UpdateMinMaxBetv2 = 1 THEN @MaxPerMatchv2 ELSE MaxPerMatch2 END,
	MaxPerMatch3 = CASE WHEN @UpdateMinMaxBetv3 = 1 THEN @MaxPerMatchv3 ELSE MaxPerMatch3 END,
	MaxPerMatch5 = CASE WHEN @UpdateMinMaxBetv5 = 1 THEN @MaxPerMatchv5 ELSE MaxPerMatch5 END,
	MaxPerMatch8 = CASE WHEN @UpdateMinMaxBetv8 = 1 THEN @MaxPerMatchv8 ELSE MaxPerMatch8 END,
	MaxPerMatch10 = CASE WHEN @UpdateMinMaxBetv10 = 1 THEN @MaxPerMatchv10 ELSE MaxPerMatch10 END,
	MaxPerMatch11 = CASE WHEN @UpdateMinMaxBetv11 = 1 THEN @MaxPerMatchv11 ELSE MaxPerMatch11 END,	
	MaxPerMatch99 = CASE WHEN @UpdateMinMaxBetv99 = 1 THEN @MaxPerMatchv99 ELSE MaxPerMatch99 END,
	MaxPerMatch99MP = CASE WHEN @UpdateMinMaxBetv99MP = 1 THEN @MaxPerMatchv99MP ELSE MaxPerMatch99MP END,
	MaxPerMatch154 = CASE WHEN @UpdateMinMaxBetv154 = 1 THEN @MaxPerMatchv154 ELSE MaxPerMatch154 END,	
	MaxPerMatch151 = CASE WHEN @UpdateMinMaxBetv151 = 1 THEN @MaxPerMatchv151 ELSE MaxPerMatch151 END,
	MaxPerMatch151_OT = CASE WHEN @UpdateMinMaxBetv151OT = 1 THEN @MaxPerMatchv151OT ELSE MaxPerMatch151_OT END,
	MaxPerMatch151_AU = CASE WHEN @UpdateMinMaxBetv151_51 = 1 THEN @MaxPerMatchv151_51 ELSE MaxPerMatch151_AU END,
	MaxPerMatch152_UK = CASE WHEN @UpdateMinMaxBetv152_41 = 1 THEN @MaxPerMatchv152_41 ELSE MaxPerMatch152_UK END,
	MaxPerMatch152_AU = CASE WHEN @UpdateMinMaxBetv152_51 = 1 THEN @MaxPerMatchv152_51 ELSE MaxPerMatch152_AU END,
	MaxPerMatch153_AU = CASE WHEN @UpdateMinMaxBetv153_51 = 1 THEN @MaxPerMatchv153_51 ELSE MaxPerMatch153_AU END,
	
	MaxPerMatch161 = CASE WHEN @UpdateMinMaxBetv161 = 1 THEN @MaxPerMatchv161 ELSE MaxPerMatch161 END,
	MaxPerBall161 = CASE WHEN @UpdateMinMaxBetv161 = 1 THEN @MaxPerBallv161 ELSE MaxPerBall161 END,
	MaxPerMatch180 = CASE WHEN @UpdateMinMaxBetv180 = 1 THEN @MaxPerMatchv180 ELSE MaxPerMatch180 END,
	MaxPerMatch181 = CASE WHEN @UpdateMinMaxBetv181 = 1 THEN @MaxPerMatchv181 ELSE MaxPerMatch181 END,
	MaxPerMatch182 = CASE WHEN @UpdateMinMaxBetv182 = 1 THEN @MaxPerMatchv182 ELSE MaxPerMatch182 END,
	MaxPerMatch184 = CASE WHEN @UpdateMinMaxBetv184 = 1 THEN @MaxPerMatchv184 ELSE MaxPerMatch184 END,
	MaxPerMatch186 = CASE WHEN @UpdateMinMaxBetv186 = 1 THEN @MaxPerMatchv186 ELSE MaxPerMatch186 END
WHERE custid = @custid 

IF (@@ERROR <> 0)
BEGIN
	
	SELECT @ErrMsg = @UserName + ': '+
					CASE @Language 
						WHEN 'E' THEN 'Update process is unsuccessful !'
						WHEN 'CS' THEN N'更新程序不成功 !'
						WHEN 'CT' THEN N'更新程序不成功 !'
						WHEN 'TH' THEN N'ขั้นตอนหรือกระบวนการในการปรับยอดไม่เสร็จสิ้น!'
						WHEN 'J' THEN N'アップデート出来ません。'
						WHEN 'KO' THEN N'업데이트에 실패했습니다.'
						ELSE N'Update process is unsuccessful !'
					END, @ErrCode = 115
	RETURN
END

DECLARE @LogSPData VARCHAR(5000)
DECLARE @TrackingValue2 VARCHAR(5000)

SELECT @LogSPData ='<Dot_Dep_CustomerUpdMemBetSetting_Cust custid="'+ COALESCE(CAST(@custid AS VARCHAR(50)),SPACE(1)) + '" ' +
'MinB="'+ COALESCE(CAST(@minbet AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxB="'+ COALESCE(CAST(@maxbet AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPM="'+ COALESCE(CAST(@maxpermatch AS VARCHAR(50)),SPACE(1)) + '" ' +
'MinBv2="'+ COALESCE(CAST(@minbetv2 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv2="'+ COALESCE(CAST(@maxbetv2 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv2="'+ COALESCE(CAST(@maxpermatchv2 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MinBv3="'+ COALESCE(CAST(@minbetv3 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv3="'+ COALESCE(CAST(@maxbetv3 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv3="'+ COALESCE(CAST(@maxpermatchv3 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MinBv5="'+ COALESCE(CAST(@minbetv5 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv5="'+ COALESCE(CAST(@maxbetv5 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv5="'+ COALESCE(CAST(@maxpermatchv5 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MinBv8="'+ COALESCE(CAST(@minbetv8 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv8="'+ COALESCE(CAST(@maxbetv8 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv8="'+ COALESCE(CAST(@maxpermatchv8 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MinBv10="'+ COALESCE(CAST(@minbetv10 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv10="'+ COALESCE(CAST(@maxbetv10 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv10="'+ COALESCE(CAST(@maxpermatchv10 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MinBv11="'+ COALESCE(CAST(@minbetv11 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv11="'+ COALESCE(CAST(@maxbetv11 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv11="'+ COALESCE(CAST(@maxpermatchv11 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MinBv99="'+ COALESCE(CAST(@minbetv99 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv99="'+ COALESCE(CAST(@maxbetv99 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv99="'+ COALESCE(CAST(@maxpermatchv99 AS VARCHAR(50)),SPACE(1)) + '" ' +

'MinBv99MP="'+ COALESCE(CAST(@minbetv99MP AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv99MP="'+ COALESCE(CAST(@maxbetv99MP AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv99MP="'+ COALESCE(CAST(@maxpermatchv99MP AS VARCHAR(50)),SPACE(1)) + '" ' +

'MinBv154="'+ COALESCE(CAST(@minbetv154 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv154="'+ COALESCE(CAST(@maxbetv154 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv154="'+ COALESCE(CAST(@maxpermatchv154 AS VARCHAR(50)),SPACE(1)) + '" ' +

'MinBv151="'+ COALESCE(CAST(@minbetv151 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv151="'+ COALESCE(CAST(@maxbetv151 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv151="'+ COALESCE(CAST(@maxpermatchv151 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MinBv151OT="'+ COALESCE(CAST(@minbetv151OT AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv151OT="'+ COALESCE(CAST(@maxbetv151OT AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv151OT="'+ COALESCE(CAST(@maxpermatchv151OT AS VARCHAR(50)),SPACE(1)) + '" ' +
'MinBv151_51="'+ COALESCE(CAST(@minbetv151_51 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv151_51="'+ COALESCE(CAST(@maxbetv151_51 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv151_51="'+ COALESCE(CAST(@maxpermatchv151_51 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MinBv152_41="'+ COALESCE(CAST(@minbetv152_41 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv152_41="'+ COALESCE(CAST(@maxbetv152_41 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv152_41="'+ COALESCE(CAST(@maxpermatchv152_41 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MinBv152_51="'+ COALESCE(CAST(@minbetv152_51 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv152_51="'+ COALESCE(CAST(@maxbetv152_51 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv152_51="'+ COALESCE(CAST(@maxpermatchv152_51 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MinBv153_51="'+ COALESCE(CAST(@minbetv153_51 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv153_51="'+ COALESCE(CAST(@maxbetv153_51 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv153_51="'+ COALESCE(CAST(@maxpermatchv153_51 AS VARCHAR(50)),SPACE(1)) + '" ' +


'MinBv161="'+ COALESCE(CAST(@minbetv161 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv161="'+ COALESCE(CAST(@maxbetv161 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv161="'+ COALESCE(CAST(@maxpermatchv161 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPBv161="'+ COALESCE(CAST(@maxperballv161 AS VARCHAR(50)),SPACE(1)) + '" ' +

'MinBv180="'+ COALESCE(CAST(@minbetv180 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv180="'+ COALESCE(CAST(@maxbetv180 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv180="'+ COALESCE(CAST(@maxpermatchv180 AS VARCHAR(50)),SPACE(1)) + '" ' +

'MinBv181="'+ COALESCE(CAST(@minbetv181 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv181="'+ COALESCE(CAST(@maxbetv181 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv181="'+ COALESCE(CAST(@maxpermatchv181 AS VARCHAR(50)),SPACE(1)) + '" ' +

'MinBv182="'+ COALESCE(CAST(@minbetv182 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv182="'+ COALESCE(CAST(@maxbetv182 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv182="'+ COALESCE(CAST(@maxpermatchv182 AS VARCHAR(50)),SPACE(1)) + '" ' +

'MinBv184="'+ COALESCE(CAST(@minbetv184 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv184="'+ COALESCE(CAST(@maxbetv184 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv184="'+ COALESCE(CAST(@maxpermatchv184 AS VARCHAR(50)),SPACE(1)) + '" ' +

'MinBv186="'+ COALESCE(CAST(@minbetv186 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv186="'+ COALESCE(CAST(@maxbetv186 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv186="'+ COALESCE(CAST(@maxpermatchv186 AS VARCHAR(50)),SPACE(1)) + '" ' +

'MinBv202_1501="'+ COALESCE(CAST(@minbetv202_1501 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv202_1501="'+ COALESCE(CAST(@maxbetv202_1501 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv202_1501="'+ COALESCE(CAST(@maxpermatchv202_1501 AS VARCHAR(50)),SPACE(1)) + '" ' +

'UMMB="'+ COALESCE(CAST(@UpdateMinMaxBet AS VARCHAR(50)),SPACE(1)) + '" ' +
'UMMBv2="'+ COALESCE(CAST(@UpdateMinMaxBetv2 AS VARCHAR(50)),SPACE(1)) + '" ' +
'UMMBv3="'+ COALESCE(CAST(@UpdateMinMaxBetv3 AS VARCHAR(50)),SPACE(1)) + '" ' +
'UMMBv5="'+ COALESCE(CAST(@UpdateMinMaxBetv5 AS VARCHAR(50)),SPACE(1)) + '" ' +
'UMMBv8="'+ COALESCE(CAST(@UpdateMinMaxBetv8 AS VARCHAR(50)),SPACE(1)) + '" ' +
'UMMBv10="'+ COALESCE(CAST(@UpdateMinMaxBetv10 AS VARCHAR(50)),SPACE(1)) + '" ' +
'UMMBv11="'+ COALESCE(CAST(@UpdateMinMaxBetv11 AS VARCHAR(50)),SPACE(1)) + '" ' +
'UMMBv99="'+ COALESCE(CAST(@UpdateMinMaxBetv99 AS VARCHAR(50)),SPACE(1)) + '" ' +
'UMMBv99MP="'+ COALESCE(CAST(@UpdateMinMaxBetv99MP AS VARCHAR(50)),SPACE(1)) + '" ' +
'UMMBv154="'+ COALESCE(CAST(@UpdateMinMaxBetv154 AS VARCHAR(50)),SPACE(1)) + '" ' +
'UMMBv151="'+ COALESCE(CAST(@UpdateMinMaxBetv151 AS VARCHAR(50)),SPACE(1)) + '" ' +
'UMMBv151OT="'+ COALESCE(CAST(@UpdateMinMaxBetv151OT AS VARCHAR(50)),SPACE(1)) + '" ' +
'UMMBv151_51="'+ COALESCE(CAST(@UpdateMinMaxBetv151_51 AS VARCHAR(50)),SPACE(1)) + '" ' +
'UMMBv152_41="'+ COALESCE(CAST(@UpdateMinMaxBetv152_41 AS VARCHAR(50)),SPACE(1)) + '" ' +
'UMMBv152_51="'+ COALESCE(CAST(@UpdateMinMaxBetv152_51 AS VARCHAR(50)),SPACE(1)) + '" ' +
'UMMBv153_51="'+ COALESCE(CAST(@UpdateMinMaxBetv153_51 AS VARCHAR(50)),SPACE(1)) + '" ' +
'UMMBv161="'+ COALESCE(CAST(@UpdateMinMaxBetv161 AS VARCHAR(50)),SPACE(1)) + '" ' +
'UMMBv180="'+ COALESCE(CAST(@UpdateMinMaxBetv180 AS VARCHAR(50)),SPACE(1)) + '" ' +
'UMMBv181="'+ COALESCE(CAST(@UpdateMinMaxBetv181 AS VARCHAR(50)),SPACE(1)) + '" ' +
'UMMBv182="'+ COALESCE(CAST(@UpdateMinMaxBetv182 AS VARCHAR(50)),SPACE(1)) + '" ' +
'UMMBv184="'+ COALESCE(CAST(@UpdateMinMaxBetv184 AS VARCHAR(50)),SPACE(1)) + '" ' +
'UMMBv186="'+ COALESCE(CAST(@UpdateMinMaxBetv186 AS VARCHAR(50)),SPACE(1)) + '" ' +
'UMMBv202="'+ COALESCE(CAST(@UpdateMinMaxBetv202 AS VARCHAR(50)),SPACE(1)) + '" ' +
'UserID="'+ COALESCE(CAST(@UserID AS VARCHAR(50)),SPACE(1)) + '" ' +
'Language="'+ COALESCE(CAST(@Language AS VARCHAR(2)),SPACE(1)) + '" ' +
'IP="'+ COALESCE(CAST(@IP AS VARCHAR(15)),SPACE(1)) + '" ' +
'ErrCode="'+ COALESCE(CAST(@ErrCode AS VARCHAR(50)),SPACE(1)) + '" ' +
'ErrMsg="'+ COALESCE(CAST(@ErrMsg AS VARCHAR(5000)),SPACE(1)) + '" />'

SELECT @TrackingValue2 ='<Dot_Dep_CustomerUpdMemBetSetting_Cust custid="'+ COALESCE(CAST(@custid AS VARCHAR(50)),SPACE(1)) + '" ' +
'MinB="'+ COALESCE(CAST(@Old_minbet AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxB="'+ COALESCE(CAST(@Old_maxbet AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPM="'+ COALESCE(CAST(@Old_maxpermatch AS VARCHAR(50)),SPACE(1)) + '" ' +
'MinBv2="'+ COALESCE(CAST(@Old_minbetv2 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv2="'+ COALESCE(CAST(@Old_maxbetv2 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv2="'+ COALESCE(CAST(@Old_maxpermatchv2 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MinBv3="'+ COALESCE(CAST(@Old_minbetv3 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv3="'+ COALESCE(CAST(@Old_maxbetv3 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv3="'+ COALESCE(CAST(@Old_maxpermatchv3 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MinBv5="'+ COALESCE(CAST(@Old_minbetv5 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv5="'+ COALESCE(CAST(@Old_maxbetv5 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv5="'+ COALESCE(CAST(@Old_maxpermatchv5 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MinBv8="'+ COALESCE(CAST(@Old_minbetv8 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv8="'+ COALESCE(CAST(@Old_maxbetv8 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv8="'+ COALESCE(CAST(@Old_maxpermatchv8 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MinBv10="'+ COALESCE(CAST(@Old_minbetv10 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv10="'+ COALESCE(CAST(@Old_maxbetv10 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv10="'+ COALESCE(CAST(@Old_maxpermatchv10 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MinBv11="'+ COALESCE(CAST(@Old_minbetv11 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv11="'+ COALESCE(CAST(@Old_maxbetv11 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv11="'+ COALESCE(CAST(@Old_maxpermatchv11 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MinBv99="'+ COALESCE(CAST(@Old_minbetv99 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv99="'+ COALESCE(CAST(@Old_maxbetv99 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv99="'+ COALESCE(CAST(@Old_maxpermatchv99 AS VARCHAR(50)),SPACE(1)) + '" ' +

'MinBv99MP="'+ COALESCE(CAST(@Old_minbetv99MP AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv99MP="'+ COALESCE(CAST(@Old_maxbetv99MP AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv99MP="'+ COALESCE(CAST(@Old_maxpermatchv99MP AS VARCHAR(50)),SPACE(1)) + '" ' +

'MinBv154="'+ COALESCE(CAST(@Old_minbetv154 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv154="'+ COALESCE(CAST(@Old_maxbetv154 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv154="'+ COALESCE(CAST(@Old_maxpermatchv154 AS VARCHAR(50)),SPACE(1)) + '" ' +

'MinBv151="'+ COALESCE(CAST(@Old_minbetv151 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv151="'+ COALESCE(CAST(@Old_maxbetv151 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv151="'+ COALESCE(CAST(@Old_maxpermatchv151 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MinBv151OT="'+ COALESCE(CAST(@Old_minbetv151OT AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv151OT="'+ COALESCE(CAST(@Old_maxbetv151OT AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv151OT="'+ COALESCE(CAST(@Old_maxpermatchv151OT AS VARCHAR(50)),SPACE(1)) + '" ' +
'MinBv151_51="'+ COALESCE(CAST(@Old_minbetv151_51 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv151_51="'+ COALESCE(CAST(@Old_maxbetv151_51 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv151_51="'+ COALESCE(CAST(@Old_maxpermatchv151_51 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MinBv152_41="'+ COALESCE(CAST(@Old_minbetv152_41 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv152_41="'+ COALESCE(CAST(@Old_maxbetv152_41 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv152_41="'+ COALESCE(CAST(@Old_maxpermatchv152_41 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MinBv152_51="'+ COALESCE(CAST(@Old_minbetv152_51 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv152_51="'+ COALESCE(CAST(@Old_maxbetv152_51 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv152_51="'+ COALESCE(CAST(@Old_maxpermatchv152_51 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MinBv153_51="'+ COALESCE(CAST(@Old_minbetv153_51 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv153_51="'+ COALESCE(CAST(@Old_maxbetv153_51 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv153_51="'+ COALESCE(CAST(@Old_maxpermatchv153_51 AS VARCHAR(50)),SPACE(1)) + '" ' +


'MinBv161="'+ COALESCE(CAST(@Old_minbetv161 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv161="'+ COALESCE(CAST(@Old_maxbetv161 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv161="'+ COALESCE(CAST(@Old_maxpermatchv161 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPBv161="'+ COALESCE(CAST(@Old_maxperballv161 AS VARCHAR(50)),SPACE(1)) + '" ' +

'MinBv180="'+ COALESCE(CAST(@Old_minbetv180 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv180="'+ COALESCE(CAST(@Old_maxbetv180 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv180="'+ COALESCE(CAST(@Old_maxpermatchv180 AS VARCHAR(50)),SPACE(1)) + '" ' +

'MinBv181="'+ COALESCE(CAST(@Old_minbetv181 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv181="'+ COALESCE(CAST(@Old_maxbetv181 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv181="'+ COALESCE(CAST(@Old_maxpermatchv181 AS VARCHAR(50)),SPACE(1)) + '" ' +

'MinBv182="'+ COALESCE(CAST(@Old_minbetv182 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv182="'+ COALESCE(CAST(@Old_maxbetv182 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv182="'+ COALESCE(CAST(@Old_maxpermatchv182 AS VARCHAR(50)),SPACE(1)) + '" ' +

'MinBv184="'+ COALESCE(CAST(@Old_minbetv184 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv184="'+ COALESCE(CAST(@Old_maxbetv184 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv184="'+ COALESCE(CAST(@Old_maxpermatchv184 AS VARCHAR(50)),SPACE(1)) + '" ' +

'MinBv186="'+ COALESCE(CAST(@Old_minbetv186 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv186="'+ COALESCE(CAST(@Old_maxbetv186 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv186="'+ COALESCE(CAST(@Old_maxpermatchv186 AS VARCHAR(50)),SPACE(1)) + '" ' +

'MinBv202_1501="'+ COALESCE(CAST(@Old_minbetv202_1501 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MaxBv202_1501="'+ COALESCE(CAST(@Old_maxbetv202_1501 AS VARCHAR(50)),SPACE(1)) + '" ' +
'MPMv202_1501="'+ COALESCE(CAST(@Old_maxpermatchv202_1501 AS VARCHAR(50)),SPACE(1)) + '" ' +

'UMMB="'+ COALESCE(CAST(@UpdateMinMaxBet AS VARCHAR(50)),SPACE(1)) + '" ' +
'UMMBv2="'+ COALESCE(CAST(@UpdateMinMaxBetv2 AS VARCHAR(50)),SPACE(1)) + '" ' +
'UMMBv3="'+ COALESCE(CAST(@UpdateMinMaxBetv3 AS VARCHAR(50)),SPACE(1)) + '" ' +
'UMMBv5="'+ COALESCE(CAST(@UpdateMinMaxBetv5 AS VARCHAR(50)),SPACE(1)) + '" ' +
'UMMBv8="'+ COALESCE(CAST(@UpdateMinMaxBetv8 AS VARCHAR(50)),SPACE(1)) + '" ' +
'UMMBv10="'+ COALESCE(CAST(@UpdateMinMaxBetv10 AS VARCHAR(50)),SPACE(1)) + '" ' +
'UMMBv11="'+ COALESCE(CAST(@UpdateMinMaxBetv11 AS VARCHAR(50)),SPACE(1)) + '" ' +
'UMMBv99="'+ COALESCE(CAST(@UpdateMinMaxBetv99 AS VARCHAR(50)),SPACE(1)) + '" ' +
'UMMBv99MP="'+ COALESCE(CAST(@UpdateMinMaxBetv99MP AS VARCHAR(50)),SPACE(1)) + '" ' +
'UMMBv154="'+ COALESCE(CAST(@UpdateMinMaxBetv154 AS VARCHAR(50)),SPACE(1)) + '" ' +
'UMMBv151="'+ COALESCE(CAST(@UpdateMinMaxBetv151 AS VARCHAR(50)),SPACE(1)) + '" ' +
'UMMBv151OT="'+ COALESCE(CAST(@UpdateMinMaxBetv151OT AS VARCHAR(50)),SPACE(1)) + '" ' +
'UMMBv151_51="'+ COALESCE(CAST(@UpdateMinMaxBetv151_51 AS VARCHAR(50)),SPACE(1)) + '" ' +
'UMMBv152_41="'+ COALESCE(CAST(@UpdateMinMaxBetv152_41 AS VARCHAR(50)),SPACE(1)) + '" ' +
'UMMBv152_51="'+ COALESCE(CAST(@UpdateMinMaxBetv152_51 AS VARCHAR(50)),SPACE(1)) + '" ' +
'UMMBv153_51="'+ COALESCE(CAST(@UpdateMinMaxBetv153_51 AS VARCHAR(50)),SPACE(1)) + '" ' +
'UMMBv161="'+ COALESCE(CAST(@UpdateMinMaxBetv161 AS VARCHAR(50)),SPACE(1)) + '" ' +
'UMMBv180="'+ COALESCE(CAST(@UpdateMinMaxBetv180 AS VARCHAR(50)),SPACE(1)) + '" ' +
'UMMBv181="'+ COALESCE(CAST(@UpdateMinMaxBetv181 AS VARCHAR(50)),SPACE(1)) + '" ' +
'UMMBv182="'+ COALESCE(CAST(@UpdateMinMaxBetv182 AS VARCHAR(50)),SPACE(1)) + '" ' +
'UMMBv184="'+ COALESCE(CAST(@UpdateMinMaxBetv184 AS VARCHAR(50)),SPACE(1)) + '" ' +
'UMMBv186="'+ COALESCE(CAST(@UpdateMinMaxBetv186 AS VARCHAR(50)),SPACE(1)) + '" ' +
'UMMBv202="'+ COALESCE(CAST(@UpdateMinMaxBetv202 AS VARCHAR(50)),SPACE(1)) + '" ' +
'UserID="'+ COALESCE(CAST(@UserID AS VARCHAR(50)),SPACE(1)) + '" ' +
'Language="'+ COALESCE(CAST(@Language AS VARCHAR(2)),SPACE(1)) + '" ' +
'IP="'+ COALESCE(CAST(@IP AS VARCHAR(15)),SPACE(1)) + '" ' +
'ErrCode="'+ COALESCE(CAST(@ErrCode AS VARCHAR(50)),SPACE(1)) + '" ' +
'ErrMsg="'+ COALESCE(CAST(@ErrMsg AS VARCHAR(5000)),SPACE(1)) + '" />'

set @endRun = getdate()
set @duration  = datediff (millisecond,@startRun,@endRun)

EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP 
	@UserID = @UserID,
	@CustID = @CustID,
	@ActionID = 314,
	@TrackingValue = @LogSPData,
	@TrackingValue2 = @TrackingValue2,
	@duration = @duration

GO
GRANT EXECUTE ON [dbo].[Dot_Dep_CustomerUpdMemBetSetting_Cust] TO [Dot_Admin] AS [dbo]
GO
GRANT EXECUTE ON [dbo].[Dot_Dep_CustomerUpdMemBetSetting_Cust] TO [Dot_Member] AS [dbo]
GO
GRANT EXECUTE ON [dbo].[Dot_Dep_CustomerUpdMemBetSetting_Cust] TO [vnteam] AS [dbo]
GO
GRANT VIEW DEFINITION ON [dbo].[Dot_Dep_CustomerUpdMemBetSetting_Cust] TO [vnteam] AS [dbo]