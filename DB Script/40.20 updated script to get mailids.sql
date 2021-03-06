GO
/****** Object:  UserDefinedFunction [dbo].[Fun_GetInvoicePermissionApproverEmails]    Script Date: 31-01-2019 19:45:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetInvoicePermissionApproverEmails]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GetInvoicePermissionApproverEmails]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_GetInvoicePermissionApproverEmails]    Script Date: 31-01-2019 19:45:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetInvoicePermissionApproverEmails]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Mimansa Agrawal
-- Create date: 31-Jan-2019
-- Description:	To get invoice permission approver emails
-- SELECT * FROM [dbo].[Fun_GetInvoicePermissionApproverEmails]()
-- =============================================
CREATE FUNCTION [dbo].[Fun_GetInvoicePermissionApproverEmails]()
RETURNS @EmailIds TABLE (
		EmailIds VARCHAR(MAX)
)
AS
BEGIN
			INSERT  INTO @EmailIds ([EmailIds])
			SELECT STUFF((SELECT '', '' + RTRIM(LTRIM((CAST(U.[EmailId] AS VARCHAR(MAX))))) [text()] 
	        FROM [dbo].[MenusUserPermission] M
	        JOIN [dbo].[UserDetail] U WITH(NOLOCK) ON U.[UserId]=M.[UserId]
	        WHERE [MenuId] = (SELECT [MenuId] FROM [dbo].[Menu] WHERE [MenuName]=''Invoice Report'') AND M.[IsActive]=1
			FOR XML PATH(''''), TYPE)
            .value(''.'',''NVARCHAR(MAX)''),1,2,'''') List_Output
	RETURN 
END' 
END

GO
