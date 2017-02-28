ALTER PROCEDURE [dbo].[Acc_Dep_CustomerUpdMemberVirtualSports_Com]
	@CustID INT, -- Super ID
	
	@v180MaxPerMatch MONEY,
	@v180MinBet MONEY,
	@v180MaxBet MONEY,
	@v180sPositionTaking SMALLMONEY,
	@v180mPositionTaking SMALLMONEY,
	@v180aPositionTaking SMALLMONEY,

	@v181MaxPerMatch MONEY,
	@v181MinBet MONEY,
	@v181MaxBet MONEY,
	@v181sPositionTaking SMALLMONEY,
	@v181mPositionTaking SMALLMONEY,
	@v181aPositionTaking SMALLMONEY,

	@v182MaxPerMatch MONEY,
	@v182MinBet MONEY,
	@v182MaxBet MONEY,
	@v182sPositionTaking SMALLMONEY,
	@v182mPositionTaking SMALLMONEY,
	@v182aPositionTaking SMALLMONEY,

	@v183MaxPerMatch MONEY,
	@v183MinBet MONEY,
	@v183MaxBet MONEY,
	@v183sPositionTaking SMALLMONEY,
	@v183mPositionTaking SMALLMONEY,
	@v183aPositionTaking SMALLMONEY,

	@v184MaxPerMatch MONEY,
	@v184MinBet MONEY,
	@v184MaxBet MONEY,
	@v184sPositionTaking SMALLMONEY,
	@v184mPositionTaking SMALLMONEY,
	@v184aPositionTaking SMALLMONEY,

	@v185MaxPerMatch MONEY,
	@v185MinBet MONEY,
	@v185MaxBet MONEY,
	@v185sPositionTaking SMALLMONEY,
	@v185mPositionTaking SMALLMONEY,
	@v185aPositionTaking SMALLMONEY,

	@v186MaxPerMatch MONEY,
	@v186MinBet MONEY,
	@v186MaxBet MONEY,
	@v186sPositionTaking SMALLMONEY,
	@v186mPositionTaking SMALLMONEY,
	@v186aPositionTaking SMALLMONEY,
	
	@UserID INT = 0,	
	@Language VARCHAR(2) = 'E',
	@ErrCode INT = 0 OUTPUT,
	@ErrMsg NVARCHAR(4000) = '' OUTPUT
 AS
 
 --@Source Control
/*
Created: 20120828@Dom
Task : Company update MinBet, MaxBet, MaxPerMatch, PT, Commission of Super agent
DB: DBTrans.bodb02

Revisions:
    - 20121128@Elodie: Get an error message from f_Get_MsgNameByMsgID function by language
	- 20131014@Francis: Support updating new virtual sports with settings
	- 20131108@Elodie: Splitting bodb02 into CustDB (call bettype by link database)
	- 20131231@Francis: Hotfix failing to update settings of new Virtual Sports for an old super
    - 20150609@David: Separate CustDB to DBCUST server (Use temp table for sports, bettype, GameType table, call some SPs by link server)
    
Param's Explanation:
• @ErrCode:
    = 0: Update successfully.
    > 0: Specific Error.
  
• @ErrMsg: Error description.
*/
 
 ----- David @ 09 JUN 2015 -------------------
	DECLARE @tmp_Bettype TABLE (TypeID INT, TypeNamee NVARCHAR(50))
	
	BEGIN TRY			
		INSERT INTO @tmp_Bettype (TypeID, TypeNamee)
		SELECT TypeID, TypeNamee FROM DBAGE.bodb02.dbo.Bettype WITH (NOLOCK)
	END TRY
	BEGIN CATCH		
		INSERT INTO @tmp_Bettype (TypeID, TypeNamee)
		SELECT TypeID, TypeNamee FROM DBTXN.bodb02.dbo.Bettype WITH (NOLOCK)
	END CATCH
----- /David @ 09 JUN 2015 -------------------

DECLARE @startRun DATETIME
DECLARE @endRun DATETIME
DECLARE @duration INT
SET @startRun = getdate()

DECLARE @ErrType VARCHAR(1000)
DECLARE @ErrAcc nvarchar(4000)

DECLARE @username varchar(40)
SELECT @ErrCode = 0




--Virtual Soccer
select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', ', @ErrType = @ErrType + t.typenamee+', '
from 
	custinfo as c with (NOLOCK) 
	inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
	inner join (
					select 180 as sporttype, 1201 as bettype, @v180spositiontaking as maxpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
	inner join @tmp_Bettype as t ON t.typeid = b.bettype
where c.srecommend = @custid 
	AND cs.sporttype = 180
	AND c.roleid = 3 
	AND (
			((cs.spositiontaking+cs.mpositiontaking>b.maxpositiontaking)) or ((cs.mpositiontaking>b.maxpositiontaking))
		)
group by username, t.typenamee

if @ErrAcc<>''

BEGIN
	Select @ErrMsg = 
				case @Language 
						when 'E' then 'Existing masters exceeded new super position taking ('+@ErrAcc+') (for Virtual Soccer).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20013,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](180,@Language) + ')'
				end, @ErrCode = 103
	return
END
------------------------------------------------------------------------------------------------------
--check all s1+m1+a1<=s4
select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', '
from 
	custinfo as c with (NOLOCK) 
	inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
	inner join (
				      select 	180 as sporttype, 1201 as bettype, @v180spositiontaking as maxpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
where c.srecommend = @custid
	AND cs.sporttype = 180 
	and c.roleid = 1 
	and (
			(cs.spositiontaking+cs.mpositiontaking+cs.apositiontaking>b.maxpositiontaking)
		)
group by username
if @ErrAcc<>''
BEGIN
	Select @ErrMsg = @username + ': ' +
				case @Language 
						when 'E' then 'Existing members exceeded new super position taking ('+@ErrAcc+') (for Virtual Soccer).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20014,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](180,@Language) + ')'
				end, @ErrCode = 104
	return
END
---------------------------------------------------------------------------------------------------------------
--Check all m1+a1<=m4
select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', '
from 
	custinfo as c with (NOLOCK) 
	inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
	inner join (
				     select 180 as sporttype, 1201 as bettype, @v180mpositiontaking as maxpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
where c.srecommend = @custid 
	AND cs.sporttype = 180 
	and c.roleid = 1 
	and (
			(cs.mpositiontaking+cs.apositiontaking>b.maxpositiontaking)  
		)
group by username
if @ErrAcc<>''
BEGIN
	Select @ErrMsg = @username + ': ' +
				case @Language 
						when 'E' then 'Existing members exceeded new master position taking ('+@ErrAcc+') (for Virtual Soccer).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20012,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](180,@Language) + ')'
				end, @ErrCode = 108
	return
END
------------------------------------------------------------------------------------------------------
--Check all a1<=a4
select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', '
from 
	custinfo as c with (NOLOCK) 
	inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
	inner join (
				   select 	180 as sporttype, 1201 as bettype, @v180apositiontaking as maxpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
where c.srecommend = @custid 
	AND cs.sporttype = 180
	and c.roleid = 1
	and (
			(cs.apositiontaking>b.maxpositiontaking)  
		)
group by username
if @ErrAcc<>''
BEGIN
	Select @ErrMsg = @username + ': ' +
				case @Language 
						when 'E' then 'Existing members exceeded new agent position taking ('+@ErrAcc+') (for Virtual Soccer).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20017,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](180,@Language) + ')'
				end, @ErrCode = 109
	return
END
/**************************
* Update CustInfo
**************************/
UPDATE custinfo with (ROWLOCK, UPDLOCK)
set 	
	MaxPerMatch180 = @v180MaxPerMatch	
where custid = @custid 
if (@@error <> 0)
begin
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end, @ErrCode = 115
	return
END
/*****************************
* Update Dep_Cussetting3rd
*****************************/
IF EXISTS (SELECT 1 FROM Dep_CustSetting3rd WITH (NOLOCK) WHERE sporttype = 180 AND custid = @CustID)
BEGIN
	UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK)
	SET	
		MinBet = @v180MinBet,
		MaxBet = @v180MaxBet,
		spositiontaking = @v180sPositionTaking,
		mpositiontaking = @v180mPositionTaking,
		apositiontaking = @v180aPositionTaking
	WHERE custid=@CustID
		AND sporttype = 180
END
ELSE
BEGIN
	INSERT INTO Dep_CustSetting3rd (custId, bettype, sporttype, apositiontaking, mpositiontaking, spositiontaking, playerdiscount, discount, adiscount, sdiscount, Minbet, Maxbet, islive)
	VALUES (@CustID, 
			1201, 
			180, 
			@v180aPositionTaking, 
			@v180mPositionTaking, 
			@v180sPositionTaking, 

			0, 0, 0, 0, 
			@v180MinBet, 
			@v180MaxBet,
			0)
END

if (@@error <> 0)
begin
	
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end	, @ErrCode = 103 
	return
END



--Virtual Horse Racing
select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', ', @ErrType = @ErrType + t.typenamee+', '
from 
	custinfo as c with (NOLOCK) 
	inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
	inner join (
					select 181 as sporttype, 1231 as bettype, @v181spositiontaking as maxpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
	inner join @tmp_Bettype as t ON t.typeid = b.bettype
where c.srecommend = @custid 
	AND cs.sporttype = 181
	AND c.roleid = 3 
	AND (
			((cs.spositiontaking+cs.mpositiontaking>b.maxpositiontaking)) or ((cs.mpositiontaking>b.maxpositiontaking))
		)
group by username, t.typenamee

if @ErrAcc<>''

BEGIN
	Select @ErrMsg = 
				case @Language 
						when 'E' then 'Existing masters exceeded new super position taking ('+@ErrAcc+') (for Virtual Horse Racing).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20013,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](181,@Language) + ')'
				end, @ErrCode = 103
	return
END
------------------------------------------------------------------------------------------------------
--check all s1+m1+a1<=s4
select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', '
from 
	custinfo as c with (NOLOCK) 
	inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
	inner join (
				      select 181 as sporttype, 1231 as bettype, @v181spositiontaking as maxpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
where c.srecommend = @custid
	AND cs.sporttype = 181 
	and c.roleid = 1 
	and (
			(cs.spositiontaking+cs.mpositiontaking+cs.apositiontaking>b.maxpositiontaking)
		)
group by username
if @ErrAcc<>''
BEGIN
	Select @ErrMsg = @username + ': ' +
				case @Language 
						when 'E' then 'Existing members exceeded new super position taking ('+@ErrAcc+') (for Virtual Horse Racing).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20014,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](181,@Language) + ')'
				end, @ErrCode = 104
	return
END
---------------------------------------------------------------------------------------------------------------
--Check all m1+a1<=m4
select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', '
from 
	custinfo as c with (NOLOCK) 
	inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
	inner join (
				     select 181 as sporttype, 1231 as bettype, @v181mpositiontaking as maxpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
where c.srecommend = @custid 
	AND cs.sporttype = 181 
	and c.roleid = 1 
	and (
			(cs.mpositiontaking+cs.apositiontaking>b.maxpositiontaking)  
		)
group by username
if @ErrAcc<>''
BEGIN
	Select @ErrMsg = @username + ': ' +
				case @Language 
						when 'E' then 'Existing members exceeded new master position taking ('+@ErrAcc+') (for Virtual Horse Racing).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20012,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](181,@Language) + ')'
				end, @ErrCode = 108
	return
END
------------------------------------------------------------------------------------------------------
--Check all a1<=a4
select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', '
from 
	custinfo as c with (NOLOCK) 
	inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
	inner join (
				   select 181 as sporttype, 1231 as bettype, @v181apositiontaking as maxpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
where c.srecommend = @custid 
	AND cs.sporttype = 181
	and c.roleid = 1
	and (
			(cs.apositiontaking>b.maxpositiontaking)  
		)
group by username
if @ErrAcc<>''
BEGIN
	Select @ErrMsg = @username + ': ' +
				case @Language 
						when 'E' then 'Existing members exceeded new agent position taking ('+@ErrAcc+') (for Virtual Horse Racing).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20017,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](181,@Language) + ')'
				end, @ErrCode = 109
	return
END
/**************************
* Update CustInfo
**************************/
UPDATE custinfo with (ROWLOCK, UPDLOCK)
set 	
	MaxPerMatch181 = @v181MaxPerMatch	
where custid = @custid 
if (@@error <> 0)
begin
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end, @ErrCode = 115
	return
END
/*****************************
* Update Dep_Cussetting3rd
*****************************/
IF EXISTS (SELECT 1 FROM Dep_CustSetting3rd WITH (NOLOCK) WHERE sporttype = 181 AND custid = @CustID)
BEGIN
	UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK)
	SET	
		MinBet = @v181MinBet,
		MaxBet = @v181MaxBet,
		spositiontaking = @v181sPositionTaking,
		mpositiontaking = @v181mPositionTaking,
		apositiontaking = @v181aPositionTaking
	WHERE custid=@CustID
		AND sporttype = 181
END
ELSE
BEGIN
	INSERT INTO Dep_CustSetting3rd (custId, bettype, sporttype, apositiontaking, mpositiontaking, spositiontaking, playerdiscount, discount, adiscount, sdiscount, Minbet, Maxbet, islive)
	VALUES (@CustID, 
			1231, 
			181, 
			@v181aPositionTaking, 
			@v181mPositionTaking, 
			@v181sPositionTaking, 
			0, 0, 0, 0, 
			@v181MinBet, 
			@v181MaxBet,
			0)
END

if (@@error <> 0)
begin
	
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end	, @ErrCode = 103 
	return
END


--Virtual Greyhounds
select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', ', @ErrType = @ErrType + t.typenamee+', '
from 
	custinfo as c with (NOLOCK) 
	inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
	inner join (
					select 182 as sporttype, 1231 as bettype, @v182spositiontaking as maxpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
	inner join @tmp_Bettype as t ON t.typeid = b.bettype
where c.srecommend = @custid 
	AND cs.sporttype = 182
	AND c.roleid = 3 
	AND (
			((cs.spositiontaking+cs.mpositiontaking>b.maxpositiontaking)) or ((cs.mpositiontaking>b.maxpositiontaking))
		)
group by username, t.typenamee

if @ErrAcc<>''

BEGIN
	Select @ErrMsg = 
				case @Language 
						when 'E' then 'Existing masters exceeded new super position taking ('+@ErrAcc+') (for Virtual Greyhounds).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20013,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](182,@Language) + ')'
				end, @ErrCode = 103
	return
END
------------------------------------------------------------------------------------------------------
--check all s1+m1+a1<=s4
select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', '
from 
	custinfo as c with (NOLOCK) 
	inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
	inner join (
				      select 	182 as sporttype, 1231 as bettype, @v182spositiontaking as maxpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
where c.srecommend = @custid
	AND cs.sporttype = 182
	and c.roleid = 1 
	and (
			(cs.spositiontaking+cs.mpositiontaking+cs.apositiontaking>b.maxpositiontaking)
		)
group by username
if @ErrAcc<>''
BEGIN
	Select @ErrMsg = @username + ': ' +
				case @Language 
						when 'E' then 'Existing members exceeded new super position taking ('+@ErrAcc+') (for Virtual Greyhounds).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20014,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](182,@Language) + ')'
				end, @ErrCode = 104
	return
END
---------------------------------------------------------------------------------------------------------------
--Check all m1+a1<=m4
select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', '
from 
	custinfo as c with (NOLOCK) 
	inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
	inner join (
				     select 182 as sporttype, 1231 as bettype, @v182mpositiontaking as maxpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
where c.srecommend = @custid 
	AND cs.sporttype = 182 
	and c.roleid = 1 
	and (
			(cs.mpositiontaking+cs.apositiontaking>b.maxpositiontaking)  
		)
group by username
if @ErrAcc<>''
BEGIN
	Select @ErrMsg = @username + ': ' +
				case @Language 
						when 'E' then 'Existing members exceeded new master position taking ('+@ErrAcc+') (for Virtual Greyhounds).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20012,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](182,@Language) + ')'
				end, @ErrCode = 108
	return
END
------------------------------------------------------------------------------------------------------
--Check all a1<=a4
select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', '
from 
	custinfo as c with (NOLOCK) 
	inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
	inner join (
				   select 	182 as sporttype, 1231 as bettype, @v182apositiontaking as maxpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
where c.srecommend = @custid 
	AND cs.sporttype = 182
	and c.roleid = 1
	and (
			(cs.apositiontaking>b.maxpositiontaking)  
		)
group by username
if @ErrAcc<>''
BEGIN
	Select @ErrMsg = @username + ': ' +
				case @Language 
						when 'E' then 'Existing members exceeded new agent position taking ('+@ErrAcc+') (for Virtual Greyhounds).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20017,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](182,@Language) + ')'
				end, @ErrCode = 109
	return
END
/**************************
* Update CustInfo
**************************/
UPDATE custinfo with (ROWLOCK, UPDLOCK)
set 	
	MaxPerMatch182 = @v182MaxPerMatch	
where custid = @custid 
if (@@error <> 0)
begin
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end, @ErrCode = 115
	return
END
/*****************************
* Update Dep_Cussetting3rd
*****************************/
IF EXISTS (SELECT 1 FROM Dep_CustSetting3rd WITH (NOLOCK) WHERE sporttype = 182 AND custid = @CustID)
BEGIN
	UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK)
	SET	
		MinBet = @v182MinBet,
		MaxBet = @v182MaxBet,
		spositiontaking = @v182sPositionTaking,
		mpositiontaking = @v182mPositionTaking,
		apositiontaking = @v182aPositionTaking
	WHERE custid=@CustID
		AND sporttype = 182
END
ELSE
BEGIN
	INSERT INTO Dep_CustSetting3rd (custId, bettype, sporttype, apositiontaking, mpositiontaking, spositiontaking, playerdiscount, discount, adiscount, sdiscount, Minbet, Maxbet, islive)
	VALUES (@CustID, 
			1231, 
			182, 
			@v182aPositionTaking, 
			@v182mPositionTaking, 
			@v182sPositionTaking, 
			0, 0, 0, 0, 
			@v182MinBet, 
			@v182MaxBet,
			0)
END

if (@@error <> 0)
begin
	
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end	, @ErrCode = 103 
	return
END


--Virtual Speedway
select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', ', @ErrType = @ErrType + t.typenamee+', '
from 
	custinfo as c with (NOLOCK) 
	inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
	inner join (
					select 183 as sporttype, 1231 as bettype, @v183spositiontaking as maxpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
	inner join @tmp_Bettype as t ON t.typeid = b.bettype
where c.srecommend = @custid 
	AND cs.sporttype = 183
	AND c.roleid = 3 
	AND (
			((cs.spositiontaking+cs.mpositiontaking>b.maxpositiontaking)) or ((cs.mpositiontaking>b.maxpositiontaking))
		)
group by username, t.typenamee

if @ErrAcc<>''

BEGIN
	Select @ErrMsg = 
				case @Language 
						when 'E' then 'Existing masters exceeded new super position taking ('+@ErrAcc+') (for Virtual Speedway).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20013,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](183,@Language) + ')'
				end, @ErrCode = 103
	return
END
------------------------------------------------------------------------------------------------------
--check all s1+m1+a1<=s4
select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', '
from 
	custinfo as c with (NOLOCK) 
	inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
	inner join (
				      select 	183 as sporttype, 1231 as bettype, @v183spositiontaking as maxpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
where c.srecommend = @custid
	AND cs.sporttype = 183 
	and c.roleid = 1 
	and (
			(cs.spositiontaking+cs.mpositiontaking+cs.apositiontaking>b.maxpositiontaking)
		)
group by username
if @ErrAcc<>''
BEGIN
	Select @ErrMsg = @username + ': ' +
				case @Language 
						when 'E' then 'Existing members exceeded new super position taking ('+@ErrAcc+') (for Virtual Speedway).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20014,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](183,@Language) + ')'
				end, @ErrCode = 104
	return
END
---------------------------------------------------------------------------------------------------------------
--Check all m1+a1<=m4
select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', '
from 
	custinfo as c with (NOLOCK) 
	inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
	inner join (
				     select 183 as sporttype, 1231 as bettype, @v183mpositiontaking as maxpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
where c.srecommend = @custid 
	AND cs.sporttype = 183 
	and c.roleid = 1 
	and (
			(cs.mpositiontaking+cs.apositiontaking>b.maxpositiontaking)  
		)
group by username
if @ErrAcc<>''
BEGIN
	Select @ErrMsg = @username + ': ' +
				case @Language 
						when 'E' then 'Existing members exceeded new master position taking ('+@ErrAcc+') (for Virtual Speedway).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20012,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](183,@Language) + ')'
				end, @ErrCode = 108
	return
END
------------------------------------------------------------------------------------------------------
--Check all a1<=a4
select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', '
from 
	custinfo as c with (NOLOCK) 
	inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
	inner join (
				   select 	183 as sporttype, 1231 as bettype, @v183apositiontaking as maxpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
where c.srecommend = @custid 
	AND cs.sporttype = 183
	and c.roleid = 1
	and (
			(cs.apositiontaking>b.maxpositiontaking)  
		)
group by username
if @ErrAcc<>''
BEGIN
	Select @ErrMsg = @username + ': ' +
				case @Language 
						when 'E' then 'Existing members exceeded new agent position taking ('+@ErrAcc+') (for Virtual Speedway).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20017,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](183,@Language) + ')'
				end, @ErrCode = 109
	return
END
/**************************
* Update CustInfo
**************************/

UPDATE custinfo with (ROWLOCK, UPDLOCK)
set 	
	MaxPerMatch183 = @v183MaxPerMatch	
where custid = @custid 
if (@@error <> 0)
begin
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end, @ErrCode = 115
	return
END

/*****************************
* Update Dep_Cussetting3rd
*****************************/
IF EXISTS (SELECT 1 FROM Dep_CustSetting3rd WITH (NOLOCK) WHERE sporttype = 183 AND custid = @CustID)
BEGIN
	UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK)
	SET	
		MinBet = @v183MinBet,
		MaxBet = @v183MaxBet,
		spositiontaking = @v183sPositionTaking,
		mpositiontaking = @v183mPositionTaking,
		apositiontaking = @v183aPositionTaking
	WHERE custid=@CustID
		AND sporttype = 183
END
ELSE
BEGIN
	INSERT INTO Dep_CustSetting3rd (custId, bettype, sporttype, apositiontaking, mpositiontaking, spositiontaking, playerdiscount, discount, adiscount, sdiscount, Minbet, Maxbet, islive)
	VALUES (@CustID, 
			1231, 
			183, 
			@v183aPositionTaking, 
			@v183mPositionTaking, 
			@v183sPositionTaking, 
			0, 0, 0, 0, 
			@v183MinBet, 
			@v183MaxBet,
			0)
END

if (@@error <> 0)
begin
	
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end	, @ErrCode = 103 
	return
END


--Virtual Motor Racing
select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', ', @ErrType = @ErrType + t.typenamee+', '
from 
	custinfo as c with (NOLOCK) 
	inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
	inner join (
					select 184 as sporttype, 1231 as bettype, @v184spositiontaking as maxpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
	inner join @tmp_Bettype as t ON t.typeid = b.bettype
where c.srecommend = @custid 
	AND cs.sporttype = 184
	AND c.roleid = 3 
	AND (
			((cs.spositiontaking+cs.mpositiontaking>b.maxpositiontaking)) or ((cs.mpositiontaking>b.maxpositiontaking))
		)
group by username, t.typenamee

if @ErrAcc<>''

BEGIN
	Select @ErrMsg = 
				case @Language 
						when 'E' then 'Existing masters exceeded new super position taking ('+@ErrAcc+') (for Virtual Motor Racing).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20013,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](184,@Language) + ')'
				end, @ErrCode = 103
	return
END
------------------------------------------------------------------------------------------------------
--check all s1+m1+a1<=s4
select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', '
from 
	custinfo as c with (NOLOCK) 
	inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
	inner join (
				      select 	184 as sporttype, 1231 as bettype, @v184spositiontaking as maxpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
where c.srecommend = @custid
	AND cs.sporttype = 184 
	and c.roleid = 1 
	and (
			(cs.spositiontaking+cs.mpositiontaking+cs.apositiontaking>b.maxpositiontaking)
		)
group by username
if @ErrAcc<>''
BEGIN
	Select @ErrMsg = @username + ': ' +
				case @Language 
						when 'E' then 'Existing members exceeded new super position taking ('+@ErrAcc+') (for Virtual Motor Racing).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20014,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](184,@Language) + ')'
				end, @ErrCode = 104
	return
END
---------------------------------------------------------------------------------------------------------------
--Check all m1+a1<=m4
select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', '
from 
	custinfo as c with (NOLOCK) 
	inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
	inner join (
				     select 184 as sporttype, 1231 as bettype, @v184mpositiontaking as maxpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
where c.srecommend = @custid 
	AND cs.sporttype = 184 
	and c.roleid = 1 
	and (
			(cs.mpositiontaking+cs.apositiontaking>b.maxpositiontaking)  
		)
group by username
if @ErrAcc<>''
BEGIN
	Select @ErrMsg = @username + ': ' +
				case @Language 
						when 'E' then 'Existing members exceeded new master position taking ('+@ErrAcc+') (for Virtual Motor Racing).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20012,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](184,@Language) + ')'
				end, @ErrCode = 108
	return
END
------------------------------------------------------------------------------------------------------
--Check all a1<=a4
select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', '
from 
	custinfo as c with (NOLOCK) 
	inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
	inner join (
				   select 	184 as sporttype, 1231 as bettype, @v184apositiontaking as maxpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
where c.srecommend = @custid 
	AND cs.sporttype = 184
	and c.roleid = 1
	and (
			(cs.apositiontaking>b.maxpositiontaking)  
		)
group by username
if @ErrAcc<>''
BEGIN
	Select @ErrMsg = @username + ': ' +
				case @Language 
						when 'E' then 'Existing members exceeded new agent position taking ('+@ErrAcc+') (for Virtual Motor Racing).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20017,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](184,@Language) + ')'
				end, @ErrCode = 109
	return
END
/**************************
* Update CustInfo
**************************/
UPDATE custinfo with (ROWLOCK, UPDLOCK)
set 	
	MaxPerMatch184 = @v184MaxPerMatch	
where custid = @custid 
if (@@error <> 0)
begin
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end, @ErrCode = 115
	return
END
/*****************************
* Update Dep_Cussetting3rd
*****************************/
IF EXISTS (SELECT 1 FROM Dep_CustSetting3rd WITH (NOLOCK) WHERE sporttype = 184 AND custid = @CustID)
BEGIN
	UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK)
	SET	
		MinBet = @v184MinBet,
		MaxBet = @v184MaxBet,
		spositiontaking = @v184sPositionTaking,
		mpositiontaking = @v184mPositionTaking,
		apositiontaking = @v184aPositionTaking
	WHERE custid=@CustID
		AND sporttype = 184
END
ELSE
BEGIN
	INSERT INTO Dep_CustSetting3rd (custId, bettype, sporttype, apositiontaking, mpositiontaking, spositiontaking, playerdiscount, discount, adiscount, sdiscount, Minbet, Maxbet, islive)
	VALUES (@CustID, 
			1231, 
			184, 
			@v184aPositionTaking, 
			@v184mPositionTaking, 
			@v184sPositionTaking, 
			0, 0, 0, 0, 
			@v184MinBet, 
			@v184MaxBet, 
			0)
END

if (@@error <> 0)
begin
	
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end	, @ErrCode = 103 
	return
END


--Virtual Cycling
select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', ', @ErrType = @ErrType + t.typenamee+', '
from 
	custinfo as c with (NOLOCK) 
	inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
	inner join (
					select 185 as sporttype, 1231 as bettype, @v185spositiontaking as maxpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
	inner join @tmp_Bettype as t ON t.typeid = b.bettype
where c.srecommend = @custid 
	AND cs.sporttype = 185
	AND c.roleid = 3 
	AND (
			((cs.spositiontaking+cs.mpositiontaking>b.maxpositiontaking)) or ((cs.mpositiontaking>b.maxpositiontaking))
		)
group by username, t.typenamee

if @ErrAcc<>''

BEGIN
	Select @ErrMsg = 
				case @Language 
						when 'E' then 'Existing masters exceeded new super position taking ('+@ErrAcc+') (for Virtual Cycling).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20013,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](185,@Language) + ')'
				end, @ErrCode = 103
	return
END
------------------------------------------------------------------------------------------------------
--check all s1+m1+a1<=s4
select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', '
from 
	custinfo as c with (NOLOCK) 
	inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
	inner join (
				      select 	185 as sporttype, 1231 as bettype, @v185spositiontaking as maxpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
where c.srecommend = @custid
	AND cs.sporttype = 185 
	and c.roleid = 1 
	and (
			(cs.spositiontaking+cs.mpositiontaking+cs.apositiontaking>b.maxpositiontaking)
		)
group by username
if @ErrAcc<>''
BEGIN
	Select @ErrMsg = @username + ': ' +
				case @Language 
						when 'E' then 'Existing members exceeded new super position taking ('+@ErrAcc+') (for Virtual Cycling).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20014,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](185,@Language) + ')'
				end, @ErrCode = 104
	return
END
---------------------------------------------------------------------------------------------------------------
--Check all m1+a1<=m4
select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', '
from 
	custinfo as c with (NOLOCK) 
	inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
	inner join (
				     select 185 as sporttype, 1231 as bettype, @v185mpositiontaking as maxpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
where c.srecommend = @custid 
	AND cs.sporttype = 185 
	and c.roleid = 1 
	and (
			(cs.mpositiontaking+cs.apositiontaking>b.maxpositiontaking)  
		)
group by username
if @ErrAcc<>''
BEGIN
	Select @ErrMsg = @username + ': ' +
				case @Language 
						when 'E' then 'Existing members exceeded new master position taking ('+@ErrAcc+') (for Virtual Cycling).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20012,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](185,@Language) + ')'
				end, @ErrCode = 108
	return
END
------------------------------------------------------------------------------------------------------
--Check all a1<=a4
select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', '
from 
	custinfo as c with (NOLOCK) 
	inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
	inner join (
				   select 	185 as sporttype, 1231 as bettype, @v185apositiontaking as maxpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
where c.srecommend = @custid 
	AND cs.sporttype = 185
	and c.roleid = 1
	and (
			(cs.apositiontaking>b.maxpositiontaking)  
		)
group by username
if @ErrAcc<>''
BEGIN
	Select @ErrMsg = @username + ': ' +
				case @Language 
						when 'E' then 'Existing members exceeded new agent position taking ('+@ErrAcc+') (for Virtual Cycling).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20017,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](185,@Language) + ')'
				end, @ErrCode = 109
	return
END
/**************************
* Update CustInfo
**************************/

UPDATE custinfo with (ROWLOCK, UPDLOCK)
set 	
	MaxPerMatch185 = @v185MaxPerMatch	
where custid = @custid 
if (@@error <> 0)
begin
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end, @ErrCode = 115
	return
END

/*****************************
* Update Dep_Cussetting3rd
*****************************/
IF EXISTS (SELECT 1 FROM Dep_CustSetting3rd WITH (NOLOCK) WHERE sporttype = 185 AND custid = @CustID)
BEGIN
	UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK)
	SET	
		MinBet = @v185MinBet,
		MaxBet = @v185MaxBet,
		spositiontaking = @v185sPositionTaking,
		mpositiontaking = @v185mPositionTaking,
		apositiontaking = @v185aPositionTaking
	WHERE custid=@CustID
		AND sporttype = 185
END
ELSE
BEGIN
	INSERT INTO Dep_CustSetting3rd (custId, bettype, sporttype, apositiontaking, mpositiontaking, spositiontaking, playerdiscount, discount, adiscount, sdiscount, Minbet, Maxbet, islive)
	VALUES (@CustID, 
			1231, 
			185, 
			@v185aPositionTaking, 
			@v185mPositionTaking, 
			@v185sPositionTaking, 
			0, 0, 0, 0, 
			@v185MinBet, 
			@v185MaxBet,
			0)
END

if (@@error <> 0)
begin
	
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end	, @ErrCode = 103 
	return
END


--Virtual Tennis
select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', ', @ErrType = @ErrType + t.typenamee+', '
from 
	custinfo as c with (NOLOCK) 
	inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
	inner join (
					select 186 as sporttype, 1220 as bettype, @v186spositiontaking as maxpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
	inner join @tmp_Bettype as t ON t.typeid = b.bettype
where c.srecommend = @custid 
	AND cs.sporttype = 186
	AND c.roleid = 3 
	AND (
			((cs.spositiontaking+cs.mpositiontaking>b.maxpositiontaking)) or ((cs.mpositiontaking>b.maxpositiontaking))
		)
group by username, t.typenamee

if @ErrAcc<>''

BEGIN
	Select @ErrMsg = 
				case @Language 
						when 'E' then 'Existing masters exceeded new super position taking ('+@ErrAcc+') (for Virtual Tennis).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20013,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](186,@Language) + ')'
				end, @ErrCode = 103
	return
END
------------------------------------------------------------------------------------------------------
--check all s1+m1+a1<=s4
select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', '
from 
	custinfo as c with (NOLOCK) 
	inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
	inner join (
				      select 186 as sporttype, 1220 as bettype, @v186spositiontaking as maxpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
where c.srecommend = @custid
	AND cs.sporttype = 186
	and c.roleid = 1 
	and (
			(cs.spositiontaking+cs.mpositiontaking+cs.apositiontaking>b.maxpositiontaking)
		)
group by username
if @ErrAcc<>''
BEGIN
	Select @ErrMsg = @username + ': ' +
				case @Language 
						when 'E' then 'Existing members exceeded new super position taking ('+@ErrAcc+') (for Virtual Tennis).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20014,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](186,@Language) + ')'
				end, @ErrCode = 104
	return
END
---------------------------------------------------------------------------------------------------------------
--Check all m1+a1<=m4
select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', '
from 
	custinfo as c with (NOLOCK) 
	inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
	inner join (
				     select 186 as sporttype, 1220 as bettype, @v186mpositiontaking as maxpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
where c.srecommend = @custid 
	AND cs.sporttype = 186 
	and c.roleid = 1 
	and (
			(cs.mpositiontaking+cs.apositiontaking>b.maxpositiontaking)  
		)
group by username
if @ErrAcc<>''
BEGIN
	Select @ErrMsg = @username + ': ' +
				case @Language 
						when 'E' then 'Existing members exceeded new master position taking ('+@ErrAcc+') (for Virtual Tennis).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20012,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](186,@Language) + ')'
				end, @ErrCode = 108
	return
END
------------------------------------------------------------------------------------------------------
--Check all a1<=a4
select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', '
from 
	custinfo as c with (NOLOCK) 
	inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
	inner join (
				   select 186 as sporttype, 1220 as bettype, @v186apositiontaking as maxpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
where c.srecommend = @custid 
	AND cs.sporttype = 186
	and c.roleid = 1
	and (
			(cs.apositiontaking>b.maxpositiontaking)  
		)
group by username
if @ErrAcc<>''
BEGIN
	Select @ErrMsg = @username + ': ' +
				case @Language 
						when 'E' then 'Existing members exceeded new agent position taking ('+@ErrAcc+') (for Virtual Tennis).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20017,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](186,@Language) + ')'
				end, @ErrCode = 109
	return
END
/**************************
* Update CustInfo
**************************/
UPDATE custinfo with (ROWLOCK, UPDLOCK)
set 	
	MaxPerMatch186 = @v186MaxPerMatch	
where custid = @custid 
if (@@error <> 0)
begin
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end, @ErrCode = 115
	return
END
/*****************************
* Update Dep_Cussetting3rd
*****************************/
IF EXISTS (SELECT 1 FROM Dep_CustSetting3rd WITH (NOLOCK) WHERE sporttype = 186 AND custid = @CustID)
BEGIN
	UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK)
	SET	
		MinBet = @v186MinBet,
		MaxBet = @v186MaxBet,
		spositiontaking = @v186sPositionTaking,
		mpositiontaking = @v186mPositionTaking,
		apositiontaking = @v186aPositionTaking
	WHERE custid=@CustID
		AND sporttype = 186

END
ELSE
BEGIN
	INSERT INTO Dep_CustSetting3rd (custId, bettype, sporttype, apositiontaking, mpositiontaking, spositiontaking, playerdiscount, discount, adiscount, sdiscount, Minbet, Maxbet, islive)
	VALUES (@CustID, 
			1220, 
			186, 
			@v186aPositionTaking, 
			@v186mPositionTaking, 
			@v186sPositionTaking, 
			0, 0, 0, 0, 
			@v186MinBet, 
			@v186MaxBet,
			0)
END

if (@@error <> 0)
begin
	
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end	, @ErrCode = 103 
	return
END
