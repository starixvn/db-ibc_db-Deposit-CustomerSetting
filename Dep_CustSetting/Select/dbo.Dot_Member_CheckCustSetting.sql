ALTER PROCEDURE [dbo].[Dot_Member_CheckCustSetting]
	@custid int,
	@sporttype int,
	@bettype int,
	@liveindicator bit,
	@betfrom nvarchar(11) = 'i',
	@actualrate float,
	@virtualrate float,
	@stake money,
	@isLicensee bit = 0 ----Identify deposit customer
AS
BEGIN
	
	-- 2011-06-21@VictorSu(DBTRANS): add sporttype 32 Netball
	-- 2011-07-08@EddieChen(DBTRANS): get actualrate from exchange again, and output @actualrate to bet process [Dot_Member_InsertBet]
	-- 2011-07-19@JoeHuang(DBTRANS): sporttype 161(number game) add bet type 88,89
	-- 2011-09-28@Viet: apply virtual rate for BA deposit customers.
	-- 2011-10-15@Joe&Thien: add back the virtual rate for deposit tickets. Exclusion the virtual rate for Autobookie function only
	-- 2012-04-20@Kiwi: Change to use Dep_custsetting/Dep_custsetting3rd to Deposit customer.
	
	SET NOCOUNT ON;

	Declare
	@username nvarchar(30),
	@apos smallmoney, @mpos smallmoney, 
	@spos smallmoney, @tpos smallmoney,
	@minbet money, @maxbet money,
	@stake_to_company float,
	@playerdiscount decimal(9,8), @adiscount decimal(9,8), 
	@mdiscount decimal(9,8), @sdiscount decimal(9,8),
	@CustSettingBettype tinyint,
	@CustSettingSporttype tinyint,
	@srecommend int,
	@mrecommend int,
	@recommend int,
	@autosuspend bit,
	@currency int,
	@result varchar(50),
	@danger tinyint

	SET @CustSettingSporttype = case
		when @bettype in (13,24,25,26,27,28) then 1  -- for bet type :13,24,25,26,27,28
		when @sporttype = 26 then 3		-- Football(3) for Rugby(26) (Vivi)
		when @sporttype = 32 then 2		-- Basketball(2) for Netball(32) (Victor)
		when @sporttype NOT IN (1,2,3,5,8,10,11,151,161) then 99
		else @sporttype end

	SET @CustSettingBettype = case
		--when @bettype between 51 and 56 then 3						--Get Over/Under for Financial bettype from 51 to 56 (Thien)
		--when @bettype between 61 and 66 then 2						--Get Odd/Even for Financial bettype from 61 to 66 (Thien)
		when @bettype = 82 then 81						--Get 1st ball Over/Under for Last ball Over/Under
		when @bettype = 84 then 83						--Get 1st ball Odd/Even for Last ball Odd/Even
		when @bettype in (13,24,25,26,27,28) then 1     -- for bet type :13,24,25,26,27,28
		when @sporttype in (3,8,26) AND @bettype = 7 then 1	--Get Fulltime Handicap for 1st Handicap
		when @sporttype in (3,8,26) AND @bettype = 8 then 3	--Get Fulltime Over/Under for 1st Over/Under
		when @sporttype = 8 AND @bettype = 21 then 20	--Get Fulltime moneyline for 1st money
		when @sporttype = 11 AND @bettype = 3 then 1	--Motorsport (11) don't have OverUnder (3) setting, get from HDP (1)
		when @bettype = 15 then 5						--Get Fulltime 1x2 for 1st 1x2
		when @bettype = 12 then 2						--20080620: Get Fulltime OE for 1st OE (Thien)
		when @bettype in (16,14) then 4					--Get CorrectScore for HTFT, FGLG
		when @bettype in (32,33) then 31				--20081223_Thien: Get WIN for PLACE and WIN/PLACE for HorseRacing TOTE
		when @bettype in (42,43) then 41				--20090811_Thien: Get WIN for PLACE and WIN/PLACE for HorseRacing FIXED ODDS
		when @bettype = 22 then 1						--20090205_Vivi:  don't have Next Goal (22) setting, get from HDP (1)
		else @bettype end

	SET  @CustSettingBettype = case
		when @sporttype = 26 and @bettype = 5 then 1	--20090317_Vivi: don't have Rugby(26) FT.1X2 setting, get from Footbal(3)+HDP(1)
		when @CustSettingSporttype >= 2 AND @CustSettingBettype = 5 then 2
		when @CustSettingBettype not in (1,2,3,4,5,6,7,8,9,10,20,21,22,31,41,81,83,85,86,87,88,89) then 2
		else @CustSettingBettype end

	-- Special requirement
	-- Vivi@2009-3-27: input parameter not correct(when open 2 browser use 2 account), re-get data again, when RD tem find out reason will remove.
	select
		@username=username, @autosuspend=isnull(autosuspend,0), @currency=currency,
		@srecommend=isnull(srecommend,0), @mrecommend=isnull(mrecommend,0), @recommend=isnull(recommend,0), @danger = isnull(danger,0)
	from custinfo with (nolock) where custid = @custid

	IF @sporttype IN (151,161) --20091216_Jamie:Get 3rd setting from CustSetting3rd 
	BEGIN
		IF (@isLicensee = 1)
		BEGIN
			SELECT				
				@apos = IsNull(apositiontaking,0),
				@mpos = IsNull(mpositiontaking,0),
				@spos = IsNull(spositiontaking,0),
				@minbet = IsNull(minbet,0),
				@maxbet = IsNull(maxbet,0),
				@playerdiscount = IsNull(playerdiscount,0),
				@adiscount = IsNull(discount,0),
				@mdiscount = IsNull(adiscount,0),
				@sdiscount = IsNull(sdiscount,0)
			FROM dbo.Dep_CustSetting3rd (nolock)
			WHERE custid =@custid 
				AND bettype=@CustSettingBettype		
				AND sporttype=@CustSettingSporttype
				AND islive = @liveindicator
		END
		ELSE
		BEGIN		
			SELECT
				--warrior use deadball PT instead of live PT setting
				@apos = IsNull(CASE @sporttype WHEN 161 THEN case @liveindicator when 1 then CASE WHEN @bettype in (85,86,87,89) THEN alivepositiontaking ELSE apositiontaking END else apositiontaking end ELSE apositiontaking END,0),
				@mpos = IsNull(CASE @sporttype WHEN 161 THEN case @liveindicator when 1 then CASE WHEN @bettype in (85,86,87,89) THEN mlivepositiontaking ELSE mpositiontaking END else mpositiontaking end ELSE mpositiontaking END,0),
				@spos = CASE
						WHEN @srecommend <= 100 THEN 0
						ELSE IsNull(CASE @sporttype WHEN 161 THEN case @liveindicator when 1 then CASE WHEN @bettype in (85,86,87,89) THEN slivepositiontaking ELSE spositiontaking END else spositiontaking end ELSE spositiontaking END,0)
						END,
				@minbet = IsNull(minbet,0),
				@maxbet = IsNull(maxbet,0),
				@playerdiscount = IsNull(playerdiscount,0),
				@adiscount = IsNull(discount,0),
				@mdiscount = IsNull(adiscount,0),
				@sdiscount = IsNull(CASE WHEN @srecommend <= 100 THEN adiscount ELSE sdiscount END,0)
			FROM dbo.custsetting3rd (nolock)
			WHERE custid =@custid 
				AND bettype=@CustSettingBettype		
				AND sporttype=@CustSettingSporttype	
		END
	END
	ELSE
	BEGIN
		IF (@isLicensee = 1)
		BEGIN
			SELECT
				@apos = IsNull (apositiontaking,0),				@mpos = IsNull (mpositiontaking,0),
				@spos = ISNULL (spositiontaking,0),
				@minbet = IsNull(minbet,0),
				@maxbet = IsNull(maxbet,0),
				@playerdiscount = IsNull(playerdiscount,0),
				@adiscount = IsNull(discount,0),
				@mdiscount = IsNull(adiscount,0),
				@sdiscount = IsNull(sdiscount,0)
			FROM dbo.Dep_CustSetting (nolock)
			WHERE custid =@custid 
				AND bettype=@CustSettingBettype		
				AND sporttype=@CustSettingSporttype
				AND islive = @liveindicator			
		END		
		ELSE
		BEGIN		
			SELECT
				@apos = IsNull(CASE @sporttype WHEN 1 THEN case @liveindicator when 1 then CASE WHEN @bettype in (1,3,7,8) THEN alivepositiontaking ELSE apositiontaking END else apositiontaking end ELSE apositiontaking END,0),				@mpos = IsNull(CASE @sporttype WHEN 1 THEN case @liveindicator when 1 then CASE WHEN @bettype in (1,3,7,8) THEN mlivepositiontaking ELSE mpositiontaking END else mpositiontaking end ELSE mpositiontaking END,0),
				@spos = CASE
						WHEN @srecommend <= 100 THEN 0
						ELSE IsNull(CASE @sporttype WHEN 1 THEN case @liveindicator when 1 then CASE WHEN @bettype in (1,3,7,8) THEN slivepositiontaking ELSE spositiontaking END else spositiontaking end ELSE spositiontaking END,0)
						END,
				@minbet = IsNull(minbet,0),
				@maxbet = IsNull(maxbet,0),
				@playerdiscount = IsNull(playerdiscount,0),
				@adiscount = IsNull(discount,0),
				@mdiscount = IsNull(adiscount,0),
				@sdiscount = IsNull(CASE WHEN @srecommend <= 100 THEN adiscount ELSE sdiscount END,0)
			FROM dbo.custsetting (nolock)
			WHERE custid =@custid 
				AND bettype=@CustSettingBettype		
				AND sporttype=@CustSettingSporttype	
		END
	END							
	if (@@rowcount=0 or @@error<>0) 
	begin
		set @result='userinfonotfound'
	end
	else
	begin
		if @betfrom NOT IN ('p')
		begin
			IF @bettype = 10 set @minbet = @minbet / 4
			ELSE IF @bettype NOT IN (1,3,7,8)	set @minbet = @minbet / 3
			if @stake > @maxbet or @stake < @minbet
			begin
				set @result='stakeproblem'
			end
		end
	end
	
	-- Scott@2010-6-17: Get actualrate from exchange table.
	SELECT @actualrate = actualrate 
	FROM dbo.exchange WITH (NOLOCK) 
	WHERE exchangeid = @currency

	-- 2009-4-5(Michael): Virtual Currency to apply only to these bettype  1,3,7,8,5,15,20 (Vivi)
	-- 20110702@Thien: add back filter to NOT apply virtualrate for licensees' tickets
	-- 2011-09-28@Viet: apply virtual rate for BA deposit customers.
	-- 2011-10-15@Joe&Thien: add back the virtual rate for deposit tickets
	SELECT
		@virtualrate = CASE
						--WHEN @betfrom IN ('d','m','e') and @danger <> 100 THEN @actualrate
						WHEN @bettype in (2,12) THEN @actualrate
						ELSE @virtualrate * @actualrate END,
		@tpos = @apos+@mpos+@spos
	
	if (@tpos>0.95)
		begin
			set @result='positiontakingproblem'
		end
	
	-- 2011-10-15@Joe&Thien: exclusion the virtual rate for Autobookie function only
	set @stake_to_company = @stake*(1-@tpos) * 
		CASE
			WHEN @betfrom IN ('d','m','e') THEN @actualrate
			ELSE @virtualrate
		END

	select @username as username,
		@apos as apos,
		@mpos as mpos,
		@spos as spos,
		@tpos as tpos,
		@minbet as minbet,
		@maxbet as maxbet,
		@playerdiscount as playerdiscount,
		@adiscount as adiscount,
		@mdiscount as mdiscount,
		@sdiscount as sdiscount,
		@stake_to_company as stake_to_company,
		@CustSettingBettype as CustSettingBettype, 
		@CustSettingSporttype as CustSettingSporttype,
		@virtualrate as virtualrate,
		@autosuspend as autosuspend,
		@srecommend as srecommend,
		@mrecommend as mrecommend,
		@recommend as recommend,
		@currency as currency,
		IsNull(@result,'') as result,
		@actualrate as actualrate
END
GO
GRANT VIEW DEFINITION ON [dbo].[Dot_Member_CheckCustSetting] TO [vnteam]