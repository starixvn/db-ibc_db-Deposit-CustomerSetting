/*
	Created: 20170503@Elodie
	Task: Update comm for MacauBet licensee
	DB: DBLIC/bodb_Licensee
*/
USE bodb_licensee
GO

DECLARE @p20 nvarchar(max)
declare @p21 int
declare @p22 nvarchar(4000)
exec Lrf_LicenseeGroupCommUpd_xtest	@LicenseeID=19,
									@GroupCommId=84,
									@GroupName=N'macau',
									@SbComm=0.0025,
									@ParlayComm=0.002,
									@NGComm=0,
									@RacingComm=0,
									@LCComm=0,
									@RNGComm=0,
									@IsUpdateNG=0,
									@IsUpdateRacing=1,
									@IsUpdateLC=0,
									@IsUpdateRNG=0,
									@GroupColor=N'#3ff',
									@UserId=10278938,@Ip=N'202.78.231.3',@langkey=N'en-US',@IsDefault=1,@IsResetDefault=0,
									@StrCustID=@p20 output,@ErrCode=@p21 output,@ErrMsg=@p22 output
select @p20, @p21, @p22

GO

--DECLARE
--	@LicenseeID INT = 19,
--	@GroupName VARCHAR(100) = 'macau'

--SELECT @GroupName = ltrim(rtrim(@GroupName))

--SELECT g.ID AS GroupCommID,g.GroupName,g.SBComm,g.RacingComm,g.NGComm, g.LCComm,g.RNGComm,g.Parlaycomm,g.color AS GroupColor, ISNULL(c.NumberOfCustomer,0) AS NumberOfCustomer, g.IsDefault  
--FROM dbo.LicenseeGroupComm g WITH (NOLOCK)   
--	LEFT JOIN (	SELECT COUNT(1) AS NumberOfCustomer, GroupCommID
--				FROM LicenseeCustComm (NOLOCK)
--				WHERE LicenseeID = @LicenseeID
--				GROUP BY GroupCommID) c ON g.id=c.GroupCommID  
--WHERE   
--	IsActive = 1   
--	AND (@GroupName='' OR (@GroupName<>'' AND GroupName LIKE '%' + @GroupName + '%'))  
--	AND g.LicenseeID = @LicenseeID  
--OPTION (MAXDOP 4)  


