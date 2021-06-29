
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_GetRequiredUserDetailsToSendMail]    Script Date: 07-02-2019 17:59:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetRequiredUserDetailsToSendMail]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GetRequiredUserDetailsToSendMail]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_GetRequiredUserDetailsToSendMail]    Script Date: 07-02-2019 17:59:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetRequiredUserDetailsToSendMail]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/*
 Author         : Mimansa Agrawal
 Create date    : 06-Feb-2019
 Description    :	To get emailids list to send mails
 Usage          : SELECT * FROM [dbo].[Fun_GetRequiredUserDetailsToSendMail](''UserVerification'')
 Change History :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   6-Feb-2019       Kanchan Kumari        Added type UserVerification
   --------------------------------------------------------------------------
*/
CREATE FUNCTION [dbo].[Fun_GetRequiredUserDetailsToSendMail](@Tag VARCHAR(500))
RETURNS @UserDetails TABLE (
		UserId INT,
		EmailId VARCHAR(150),
		FirstName VARCHAR(50),
		LastName VARCHAR(50),
		EmployeeName VARCHAR(50)
)
AS
BEGIN
	IF (@Tag=''InvoiceRequest'')
	BEGIN
		INSERT INTO @UserDetails ([UserId], [EmailId], [FirstName], [LastName], [EmployeeName])
		SELECT V.[UserId],V.[EmailId],V.[EmployeeFirstName],V.[EmployeeLastName],V.[EmployeeName]
		FROM [dbo].[MenusUserPermission] M
		JOIN [dbo].[vwActiveUsers] V WITH(NOLOCK) ON V.[UserId]=M.[UserId]
		WHERE [MenuId] = (SELECT [MenuId] FROM [dbo].[Menu] WHERE [MenuName]=''Invoice Report'') AND M.[IsActive]=1
	END
	ELSE IF(@Tag= ''UserVerification'')
	BEGIN
	    INSERT INTO @UserDetails ([UserId], [EmailId], [FirstName], [LastName], [EmployeeName])
		SELECT V.[UserId], V.[EmailId], V.[EmployeeFirstName], V.[EmployeeLastName], V.[EmployeeName]
		FROM [dbo].[MenusUserPermission] M
		JOIN [dbo].[vwActiveUsers] V WITH(NOLOCK) ON M.[UserId] = V.[UserId]
		WHERE [MenuId] = (SELECT [MenuId] FROM [dbo].[Menu] WHERE [MenuName]=''User Management'') AND M.[IsActive] = 1
	END
RETURN 
END' 
END

GO


INSERT INTO Menu (ParentMenuId,MenuName,ControllerName,ActionName,[Sequence],CreatedById)
SELECT M.[MenuId],'Pimco Achievements',M.[ControllerName],'PimcoAchievements',15,2434
FROM Menu M WHERE M.[ParentMenuId]=0 AND MenuName='Appraisal Management'