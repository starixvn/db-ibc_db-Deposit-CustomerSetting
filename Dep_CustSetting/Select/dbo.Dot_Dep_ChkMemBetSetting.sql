ALTER PROCEDURE [dbo].[Dot_Dep_ChkMemBetSetting]
	@CustId int
AS
/*
	REVISIONS:
		- 20120424@Kiwi: - Change to use Dep_CustSetting/Dep_CustSetting3rd
						 - Comment out financials (201)	
*/
SET NOCOUNT ON

Declare @MinMinBet money, @MaxMaxBet money,	@MaxMaxPerMatch money,
		@MinMinBetv2 money, @MaxMaxBetv2 money, @MaxMaxPerMatchv2 money,
		@MinMinBetv3 money, @MaxMaxBetv3 money, @MaxMaxPerMatchv3 money,
		@MinMinBetv5 money, @MaxMaxBetv5 money, @MaxMaxPerMatchv5 money,
		@MinMinBetv8 money, @MaxMaxBetv8 money, @MaxMaxPerMatchv8 money,
		@MinMinBetv10 money, @MaxMaxBetv10 money, @MaxMaxPerMatchv10 money,
		@MinMinBetv11 money, @MaxMaxBetv11 money, @MaxMaxPerMatchv11 money,
		@MinMinBetv99 money, @MaxMaxBetv99 money, @MaxMaxPerMatchv99 money,

		@MinMinBetv201 money, @MaxMaxBetv201 money, @MaxMaxPerMatchv201 money,
		@MinMinBetv151 money, @MaxMaxBetv151 money, @MaxMaxPerMatchv151 money

-- Select Data
Select
	@MinMinBet = Max(case when MinBet = 0 then NULL else MinBet end), 
	@MaxMaxBet = Min(case when MaxBet = 0 then NULL else MaxBet end)
from 
	Dep_CustSetting as cs WITH (NOLOCK)
	INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.Recommend or cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend)
	and cs.bettype = 1 and cs.sporttype=1
where ci.custid = @CustId

Select 
	@MinMinBetv2 = Max(case when MinBet = 0 then NULL else MinBet end), 
	@MaxMaxBetv2 = Min(case when MaxBet = 0 then NULL else MaxBet end)
from 
	Dep_CustSetting as cs WITH (NOLOCK)
	INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.Recommend or cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend)
	and cs.bettype = 1 and cs.sporttype=2
where ci.custid = @CustId

Select 
	@MinMinBetv3 = Max(case when MinBet = 0 then NULL else MinBet end), 
	@MaxMaxBetv3 = Min(case when MaxBet = 0 then NULL else MaxBet end)
from 
	Dep_CustSetting as cs WITH (NOLOCK)
	INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.Recommend or cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend)
	and cs.bettype = 1 and cs.sporttype=3
where ci.custid = @CustId

Select 
	@MinMinBetv5 = Max(case when MinBet = 0 then NULL else MinBet end), 
	@MaxMaxBetv5 = Min(case when MaxBet = 0 then NULL else MaxBet end)
from 
	Dep_CustSetting as cs WITH (NOLOCK)
	INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.Recommend or cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend)
	and cs.bettype = 1 and cs.sporttype=5
where ci.custid = @CustId

Select 
	@MinMinBetv8 = Max(case when MinBet = 0 then NULL else MinBet end), 
	@MaxMaxBetv8 = Min(case when MaxBet = 0 then NULL else MaxBet end)
from 
	Dep_CustSetting as cs WITH (NOLOCK)
	INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.Recommend or cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend)
	and cs.bettype = 1 and cs.sporttype=8
where ci.custid = @CustId

Select 
	@MinMinBetv10 = Max(case when MinBet = 0 then NULL else MinBet end), 
	@MaxMaxBetv10 = Min(case when MaxBet = 0 then NULL else MaxBet end)
from 
	Dep_CustSetting as cs WITH (NOLOCK)
	INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.Recommend or cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend)
	and cs.bettype = 1 and cs.sporttype=10
where ci.custid = @CustId

Select 
	@MinMinBetv11 = Max(case when MinBet = 0 then NULL else MinBet end), 
	@MaxMaxBetv11 = Min(case when MaxBet = 0 then NULL else MaxBet end)
from 
	Dep_CustSetting as cs WITH (NOLOCK)
	INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.Recommend or cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend)
	and cs.bettype = 1 and cs.sporttype=11
where ci.custid = @CustId

Select 
	@MinMinBetv99 = Max(case when MinBet = 0 then NULL else MinBet end), 
	@MaxMaxBetv99 = Min(case when MaxBet = 0 then NULL else MaxBet end)
from 
	Dep_CustSetting as cs WITH (NOLOCK)
	INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.Recommend or cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend)
	and cs.bettype = 1 and cs.sporttype=99
where ci.custid = @CustId

select @MinMinBetv201 = 0, @MaxMaxBetv201 = 0
/*
Select 
	@MinMinBetv201 = Max(case when MinBet = 0 then NULL else MinBet end), 
	@MaxMaxBetv201 = Min(case when MaxBet = 0 then NULL else MaxBet end)
from 
	custsetting as cs WITH (NOLOCK)
	INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.Recommend or cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend)
	and cs.bettype = 2 and cs.sporttype=201
where ci.custid = @CustId
*/
Select 
	@MinMinBetv151 = Max(case when MinBet = 0 then NULL else MinBet end), 
	@MaxMaxBetv151 = Min(case when MaxBet = 0 then NULL else MaxBet end)
from 
	Dep_CustSetting3rd as cs WITH (NOLOCK)
	INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.Recommend or cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend)
	and cs.bettype = 31 and cs.sporttype=151
where ci.custid = @CustId


Select 
	@MaxMaxperMatch = Min(case when cs.MaxPerMatch = 0 then NULL else cs.MaxPerMatch end), 
	@MaxMaxPerMatchv2 = Min(case when cs.MaxPerMatch2 = 0 then NULL else cs.MaxPerMatch2 end), 
	@MaxMaxPerMatchv3 = Min(case when cs.MaxPerMatch3 = 0 then NULL else cs.MaxPerMatch3 end), 
	@MaxMaxPerMatchv5 = Min(case when cs.MaxPerMatch5 = 0 then NULL else cs.MaxPerMatch5 end), 
	@MaxMaxPerMatchv8 = Min(case when cs.MaxPerMatch8 = 0 then NULL else cs.MaxPerMatch8 end), 
	@MaxMaxPerMatchv10 = Min(case when cs.MaxPerMatch10 = 0 then NULL else cs.MaxPerMatch10 end), 
	@MaxMaxPerMatchv11 = Min(case when cs.MaxPerMatch11 = 0 then NULL else cs.MaxPerMatch11 end), 	
	@MaxMaxPerMatchv99 = Min(case when cs.MaxPerMatch99 = 0 then NULL else cs.MaxPerMatch99 end),
	
	@MaxMaxPerMatchv201 = Min(case when cs.MaxPerMatch201 = 0 then NULL else cs.MaxPerMatch201 end),
	@MaxMaxPerMatchv151 = Min(case when cs.MaxPerMatch151 = 0 then NULL else cs.MaxPerMatch151 end)
from 
	custinfo as cs WITH (NOLOCK) 
	INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.Recommend or cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend)
where ci.custid = @CustId

Select @MinMinBet AS MinMinBet, @MaxMaxBet AS MaxMaxBet, @MaxMaxperMatch AS MaxMaxperMatch,
	   @MinMinBetv2 AS MinMinBetv2, @MaxMaxBetv2 AS MaxMaxBetv2, @MaxMaxperMatchv2 AS MaxMaxperMatchv2,
	   @MinMinBetv3 AS MinMinBetv3, @MaxMaxBetv3 AS MaxMaxBetv3, @MaxMaxperMatchv3 AS MaxMaxperMatchv3,
	   @MinMinBetv5 AS MinMinBetv5, @MaxMaxBetv5 AS MaxMaxBetv5, @MaxMaxperMatchv5 AS MaxMaxperMatchv5,
	   @MinMinBetv8 AS MinMinBetv8, @MaxMaxBetv8 AS MaxMaxBetv8, @MaxMaxperMatchv8 AS MaxMaxperMatchv8,
	   @MinMinBetv10 AS MinMinBetv10, @MaxMaxBetv10 AS MaxMaxBetv10, @MaxMaxperMatchv10 AS MaxMaxperMatchv10,
	   @MinMinBetv11 AS MinMinBetv11, @MaxMaxBetv11 AS MaxMaxBetv11, @MaxMaxperMatchv11 AS MaxMaxperMatchv11,
	   @MinMinBetv99 AS MinMinBetv99, @MaxMaxBetv99 AS MaxMaxBetv99, @MaxMaxperMatchv99 AS MaxMaxperMatchv99,
	   @MinMinBetv201 AS MinMinBetv201, @MaxMaxBetv201 AS MaxMaxBetv201, @MaxMaxperMatchv201 AS MaxMaxperMatchv201,
	   @MinMinBetv151 AS MinMinBetv151, @MaxMaxBetv151 AS MaxMaxBetv151, @MaxMaxperMatchv151 AS MaxMaxperMatchv151

GO
GRANT VIEW DEFINITION ON [dbo].[Dot_Dep_ChkMemBetSetting] TO [vnteam]