ALTER PROCEDURE [dbo].[Dot_Member_Custsetting]
	@custid int,
	@sporttype int,
	@bettype int,
	@isLicensee bit = 0
AS
BEGIN
	-- 20110623@Jack Chnag(DBTRANS): new sport netball(32) rule follow by besketball(2) 
	-- 20110706@Vivi(DBTRANS): Get Australia HR setting 51 (parameter @bettype input 51,52,53)
    -- 20110907@Tony Yu(DBTRANS):Add new sport greyhounds(152)
	-- 20120424@Kiwi: Change to use Dep_custsetting/Dep_custsetting3rd
	-- 20120626@Amy: add more condition islive=0 when retrieve from Dep_custsetting/Dep_custsetting3rd
	SET NOCOUNT ON

	Declare @CustSettingSporttype tinyint
	Declare @CustSettingBettype tinyint

	SET @CustSettingSporttype = case
		when @bettype in (13,24,25,26,27,28) then 1  -- for bet type :13,24,25,26,27,28
		when @sporttype = 26 then 3		-- Football(3) for Rugby(26) (Vivi)
		when @sporttype = 32 then 2
		when @sporttype NOT IN (1,2,3,5,8,10,11,151,152,161) then 99
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
		when @bettype in (42,43) then 41				--20090811_Thien: Get WIN for PLACE and WIN/PLACE for HorseRacing OPEN TOTE
		when @bettype in (52,53) then 51				--20110706_Vivi: Get WIN for PLACE and WIN/PLACE for HorseRacing Australia HR
		when @bettype = 22 then 1						--20090205_Vivi:  don't have Next Goal (22) setting, get from HDP (1)
		else @bettype end

	SET  @CustSettingBettype = case
		when @sporttype = 26 and @bettype = 5 then 1	--20090317_Vivi: don't have Rugby(26) FT.1X2 setting, get from Footbal(3)+HDP(1)
		when @CustSettingSporttype >= 2 AND @CustSettingBettype = 5 then 2
		when @CustSettingBettype not in (1,2,3,4,5,6,7,8,9,10,20,21,22,31,41,51,81,83,85,86,87,88,89) then 2
		else @CustSettingBettype end

	IF @sporttype IN (151,152,161) --20091216_Jamie:Get 3rd setting from CustSetting3rd 
	BEGIN
		IF (@isLicensee = 1)
		BEGIN
			SELECT
				cs.minbet, cs.maxbet, cs.apositiontaking,
				cs.mpositiontaking, cs.spositiontaking, cs.playerdiscount,
				cs.discount, cs.adiscount, cs.sdiscount 			
			FROM dbo.dep_custsetting3rd cs (nolock)
			WHERE cs.custid = @custid AND bettype = @CustSettingBettype AND sporttype = @CustSettingSporttype AND islive=0		
		END
		ELSE
		BEGIN
			SELECT
				cs.minbet, cs.maxbet, cs.apositiontaking,
				cs.mpositiontaking, cs.spositiontaking, cs.playerdiscount,
				cs.discount, cs.adiscount, cs.sdiscount 			
			FROM dbo.custsetting3rd cs (nolock)
			WHERE cs.custid = @custid AND bettype = @CustSettingBettype AND sporttype = @CustSettingSporttype		
		END
	END		
	ELSE 
	BEGIN
		IF (@isLicensee = 1)
		BEGIN
			SELECT
				cs.minbet, cs.maxbet, cs.apositiontaking,
				cs.mpositiontaking, cs.spositiontaking, cs.playerdiscount,
				cs.discount, cs.adiscount, cs.sdiscount 			
			FROM dbo.dep_custsetting cs with (nolock)
			WHERE cs.custid = @custid AND bettype = @CustSettingBettype AND sporttype = @CustSettingSporttype AND islive=0		
		END
		ELSE
		BEGIN
			SELECT
				cs.minbet, cs.maxbet, cs.apositiontaking,
				cs.mpositiontaking, cs.spositiontaking, cs.playerdiscount,
				cs.discount, cs.adiscount, cs.sdiscount 			
			FROM dbo.custsetting cs with (nolock)
			WHERE cs.custid = @custid AND bettype = @CustSettingBettype AND sporttype = @CustSettingSporttype
		END
	END
END

GO
GRANT VIEW DEFINITION ON [dbo].[Dot_Member_Custsetting] TO [vnteam]