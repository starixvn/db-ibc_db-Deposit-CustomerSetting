ALTER PROCEDURE [dbo].[Acc_Dep_LicenseeUsernameCheck]
	@username VARCHAR(30),
	@Language VARCHAR(2)= 'E',
	@ErrCode INT = 0 OUTPUT,
	@ErrMsg NVARCHAR(2000) = '' OUTPUT
	
AS
/*
	Create: 20131014@Francis
	Task: Check if the current Licensee's username exists.
	DB: DBEXT.BODB02
*/

BEGIN
		IF EXISTS(SELECT 1 FROM Customer WITH (NOLOCK) WHERE username= @username)
		OR EXISTS (SELECT 1 FROM Customer WITH (NOLOCK) WHERE username2 = @username)
		OR EXISTS(SELECT 1 FROM custSub WITH (NOLOCK) WHERE username= @username)
	BEGIN
		SELECT @ErrMsg = CASE @Language 
							WHEN 'E' THEN 'This username is not available.'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](40001,@Language)
						END
		SELECT @ErrCode = 101		
		RETURN
	END
	

END



GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


GO 
 GRANT VIEW DEFINITION ON [dbo].[Acc_Dep_LicenseeUsernameCheck] TO [vnteam]
GO 
 GRANT EXECUTE ON [dbo].[Acc_Dep_LicenseeUsernameCheck] TO [bodbAdminNet]
GO 
