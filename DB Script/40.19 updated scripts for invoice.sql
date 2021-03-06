GO
/****** Object:  StoredProcedure [dbo].[Proc_RequestInvoice]    Script Date: 31-01-2019 18:30:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_RequestInvoice]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_RequestInvoice]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GenerateInvoice]    Script Date: 31-01-2019 18:30:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GenerateInvoice]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GenerateInvoice]
GO
/****** Object:  StoredProcedure [dbo].[Proc_CheckIfEligibleToRequestInvoice]    Script Date: 31-01-2019 18:30:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_CheckIfEligibleToRequestInvoice]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_CheckIfEligibleToRequestInvoice]
GO
/****** Object:  StoredProcedure [dbo].[Proc_AddClient]    Script Date: 31-01-2019 18:30:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddClient]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AddClient]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__InvoiceRe__Invoi__4794C2DE]') AND parent_object_id = OBJECT_ID(N'[dbo].[InvoiceRequestDetail]'))
ALTER TABLE [dbo].[InvoiceRequestDetail] DROP CONSTRAINT [FK__InvoiceRe__Invoi__4794C2DE]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__InvoiceRe__Clien__4888E717]') AND parent_object_id = OBJECT_ID(N'[dbo].[InvoiceRequestDetail]'))
ALTER TABLE [dbo].[InvoiceRequestDetail] DROP CONSTRAINT [FK__InvoiceRe__Clien__4888E717]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__InvoiceRe__UserI__2A6E744B]') AND parent_object_id = OBJECT_ID(N'[dbo].[InvoiceRequest]'))
ALTER TABLE [dbo].[InvoiceRequest] DROP CONSTRAINT [FK__InvoiceRe__UserI__2A6E744B]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Invoice__Invoice__54EEBDFC]') AND parent_object_id = OBJECT_ID(N'[dbo].[Invoice]'))
ALTER TABLE [dbo].[Invoice] DROP CONSTRAINT [FK__Invoice__Invoice__54EEBDFC]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__Invoice__Created__57CB2AA7]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Invoice] DROP CONSTRAINT [DF__Invoice__Created__57CB2AA7]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__Invoice__IsCance__56D7066E]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Invoice] DROP CONSTRAINT [DF__Invoice__IsCance__56D7066E]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__Invoice__IsActiv__55E2E235]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Invoice] DROP CONSTRAINT [DF__Invoice__IsActiv__55E2E235]
END

GO
/****** Object:  Table [dbo].[InvoiceRequestDetail]    Script Date: 31-01-2019 18:30:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InvoiceRequestDetail]') AND type in (N'U'))
DROP TABLE [dbo].[InvoiceRequestDetail]
GO
/****** Object:  Table [dbo].[InvoiceRequest]    Script Date: 31-01-2019 18:30:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InvoiceRequest]') AND type in (N'U'))
DROP TABLE [dbo].[InvoiceRequest]
GO
/****** Object:  Table [dbo].[Invoice]    Script Date: 31-01-2019 18:30:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Invoice]') AND type in (N'U'))
DROP TABLE [dbo].[Invoice]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_GetInvoicePermissionApproverEmails]    Script Date: 31-01-2019 18:30:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetInvoicePermissionApproverEmails]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GetInvoicePermissionApproverEmails]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_GetInvoicePermissionApproverEmails]    Script Date: 31-01-2019 18:30:54 ******/
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
			SELECT STUFF((SELECT '', '' + CAST(U.[EmailId] AS VARCHAR(MAX)) [text()] 
	        FROM [dbo].[MenusUserPermission] M
	        JOIN [dbo].[UserDetail] U WITH(NOLOCK) ON U.[UserId]=M.[UserId]
	        WHERE [MenuId] = (SELECT [MenuId] FROM [dbo].[Menu] WHERE [MenuName]=''Invoice Report'') AND M.[IsActive]=1
			FOR XML PATH(''''), TYPE)
            .value(''.'',''NVARCHAR(MAX)''),1,2,'' '') List_Output
	RETURN 
END
' 
END

GO
/****** Object:  Table [dbo].[Invoice]    Script Date: 31-01-2019 18:30:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Invoice]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Invoice](
	[InvoiceId] [bigint] IDENTITY(1,1) NOT NULL,
	[InvoiceRequestDetailId] [bigint] NOT NULL,
	[InvoiceNumber] [varchar](20) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[IsCancelled] [bit] NOT NULL,
	[Reason] [varchar](100) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[InvoiceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[InvoiceRequest]    Script Date: 31-01-2019 18:30:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InvoiceRequest]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[InvoiceRequest](
	[InvoiceRequestId] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[IsApproved] [bit] NOT NULL DEFAULT ((0)),
	[IsRejected] [bit] NOT NULL DEFAULT ((0)),
	[Comments] [varchar](500) NULL,
	[CreatedDate] [datetime] NOT NULL DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[InvoiceRequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[InvoiceRequestDetail]    Script Date: 31-01-2019 18:30:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InvoiceRequestDetail]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[InvoiceRequestDetail](
	[InvoiceRequestDetailId] [bigint] IDENTITY(1,1) NOT NULL,
	[InvoiceRequestId] [bigint] NOT NULL,
	[ClientId] [int] NOT NULL,
	[RequestedCount] [int] NOT NULL,
	[AvailableCount] [int] NOT NULL,
	[IsActive] [bit] NOT NULL DEFAULT ((1)),
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL DEFAULT (getdate()),
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[InvoiceRequestDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__Invoice__IsActiv__55E2E235]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Invoice] ADD  DEFAULT ((1)) FOR [IsActive]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__Invoice__IsCance__56D7066E]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Invoice] ADD  DEFAULT ((0)) FOR [IsCancelled]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__Invoice__Created__57CB2AA7]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Invoice] ADD  DEFAULT (getdate()) FOR [CreatedDate]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Invoice__Invoice__54EEBDFC]') AND parent_object_id = OBJECT_ID(N'[dbo].[Invoice]'))
ALTER TABLE [dbo].[Invoice]  WITH CHECK ADD FOREIGN KEY([InvoiceRequestDetailId])
REFERENCES [dbo].[InvoiceRequestDetail] ([InvoiceRequestDetailId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__InvoiceRe__UserI__2A6E744B]') AND parent_object_id = OBJECT_ID(N'[dbo].[InvoiceRequest]'))
ALTER TABLE [dbo].[InvoiceRequest]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([UserId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__InvoiceRe__Clien__4888E717]') AND parent_object_id = OBJECT_ID(N'[dbo].[InvoiceRequestDetail]'))
ALTER TABLE [dbo].[InvoiceRequestDetail]  WITH CHECK ADD FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([ClientId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__InvoiceRe__Invoi__4794C2DE]') AND parent_object_id = OBJECT_ID(N'[dbo].[InvoiceRequestDetail]'))
ALTER TABLE [dbo].[InvoiceRequestDetail]  WITH CHECK ADD FOREIGN KEY([InvoiceRequestId])
REFERENCES [dbo].[InvoiceRequest] ([InvoiceRequestId])
GO
/****** Object:  StoredProcedure [dbo].[Proc_AddClient]    Script Date: 31-01-2019 18:30:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddClient]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_AddClient] AS' 
END
GO
/***
   Created Date      :     2018-12-18
   Created By        :     Mimansa Agrawal
   Purpose           :     This procedure add new clients 
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
DECLARE @Result int
EXEC Proc_AddClient
@ClientName= Pimco,
@UserId=2166,
@Success = @Result output
SELECT @Result AS [RESULT]
**/
ALTER PROCEDURE [dbo].[Proc_AddClient]
(
@ClientName VARCHAR(100),
@UserId INT,
@Success TINYINT = 0 OUTPUT 
)
AS
BEGIN TRY
IF EXISTS(SELECT 1 FROM [dbo].[Client] WHERE [ClientName] = @ClientName) -- check if already exists
		BEGIN
			 SET @Success=2 --already exists
		END
ELSE
BEGIN
BEGIN TRANSACTION
INSERT INTO [dbo].[Client]([ClientName],CreatedBy)
SELECT @ClientName,@UserId

COMMIT
SET @Success= 1------------added successfully
END
END TRY
BEGIN CATCH
	--On Error
	IF @@TRANCOUNT > 0
	 ROLLBACK TRANSACTION;

     SET @Success = 0; -- Error occurred
	 DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
	 --Log Error
	 EXEC [spInsertErrorLog]
			 @ModuleName = 'Accounts'
			,@Source = 'Proc_AddClient'
			,@ErrorMessage = @ErrorMessage
			,@ErrorType = 'SP'
			,@ReportedByUserId = @UserId
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[Proc_CheckIfEligibleToRequestInvoice]    Script Date: 31-01-2019 18:30:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_CheckIfEligibleToRequestInvoice]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_CheckIfEligibleToRequestInvoice] AS' 
END
GO

/***
   Created Date      :     2018-12-28
   Created By        :     Mimansa Agrawal
   Purpose           :     This procedure checks if user can request for new invoices
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
DECLARE @Result int
EXEC Proc_CheckIfEligibleToRequestInvoice
@UserId=2166,
@Success = @Result output
SELECT @Result AS [RESULT]
**/
ALTER PROCEDURE [dbo].[Proc_CheckIfEligibleToRequestInvoice]
(
@UserId INT,
@Success TINYINT = 0 OUTPUT 
)
AS
BEGIN TRY
DECLARE @InvoiceRequestId INT = (SELECT TOP 1 InvoiceRequestId FROM [dbo].[InvoiceRequest] WHERE UserId = @UserId ORDER BY InvoiceRequestId DESC)
DECLARE @CurrentCount INT=(SELECT  SUM(AvailableCount) FROM [dbo].[InvoiceRequestDetail] WHERE InvoiceRequestId=@InvoiceRequestId)
DECLARE @IsApproved INT=(SELECT TOP 1 IsApproved FROM [dbo].[InvoiceRequest] WHERE UserId = @UserId ORDER BY InvoiceRequestId DESC)
DECLARE @IsRejected INT=(SELECT TOP 1 IsRejected FROM [dbo].[InvoiceRequest] WHERE UserId = @UserId ORDER BY InvoiceRequestId DESC)
IF (@CurrentCount > 0 AND @IsApproved = 1)
		BEGIN
			 SET @Success=3 --approved and count exists (not eligible)
		END
ELSE IF (@CurrentCount > 0 AND @IsApproved = 0 AND @IsRejected=0)
BEGIN
SET @Success = 2 --------------count exists but not approved (not eligible)
END
ELSE
BEGIN
SET @Success= 1------------eligible to request
END
END TRY
BEGIN CATCH
	--On Error
     SET @Success = 0; -- Error occurred
	 DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
	 --Log Error
	 EXEC [spInsertErrorLog]
			 @ModuleName = 'Accounts'
			,@Source = 'Proc_CheckIfEligibleToRequestInvoice'
			,@ErrorMessage = @ErrorMessage
			,@ErrorType = 'SP'
			,@ReportedByUserId = @UserId
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[Proc_GenerateInvoice]    Script Date: 31-01-2019 18:30:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GenerateInvoice]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GenerateInvoice] AS' 
END
GO
/***
   Created Date      :     2018-12-17
   Created By        :     Mimansa Agrawal
   Purpose           :     This procedure generates invoice for clients
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
EXEC Proc_GenerateInvoice
@ClientId=7,
@UserId=2203
**/
ALTER PROCEDURE [dbo].[Proc_GenerateInvoice]
(
@ClientId INT,
@UserId INT
)
AS
BEGIN TRY
DECLARE @InvoiceNumber BIGINT = (SELECT TOP 1 [InvoiceNumber] FROM [dbo].[Invoice] ORDER BY [InvoiceId] DESC)
DECLARE @InvoiceRequestDetailId BIGINT = (SELECT TOP 1 [InvoiceRequestDetailId] FROM [dbo].[InvoiceRequestDetail] WHERE CreatedBy=@UserId AND ClientId=@ClientId AND IsActive=1 ORDER BY [InvoiceRequestDetailId] DESC)
DECLARE @AvailableCount INT = (SELECT TOP 1 [AvailableCount] FROM [dbo].[InvoiceRequestDetail] WHERE CreatedBy=@UserId AND ClientId=@ClientId AND IsActive=1 ORDER BY [InvoiceRequestDetailId] DESC)
DECLARE @NewInvoiceNumber BIGINT 
IF(@InvoiceNumber > 0)	
BEGIN 
SET @NewInvoiceNumber = @InvoiceNumber + 1
END	
ELSE
BEGIN
SET @NewInvoiceNumber = 1000000001
END
IF (@AvailableCount > 0)
BEGIN
BEGIN TRANSACTION
INSERT INTO [dbo].[Invoice] (InvoiceRequestDetailId, InvoiceNumber, CreatedBy)
SELECT @InvoiceRequestDetailId,@NewInvoiceNumber,@UserId
UPDATE IR
SET IR.[AvailableCount] = @AvailableCount - 1
FROM
(
   SELECT TOP 1 [AvailableCount]
   FROM [InvoiceRequestDetail] WHERE CreatedBy=@UserId AND ClientId=@ClientId AND IsActive=1 ORDER BY [InvoiceRequestDetailId] DESC
) IR
COMMIT
SELECT TOP 1 * FROM [dbo].[Invoice] ORDER BY [InvoiceId] DESC
END
ELSE
BEGIN
 SELECT TOP 1 * FROM [dbo].[Invoice]  WHERE 1 = 0 ORDER BY [InvoiceId] DESC
END
END TRY
BEGIN CATCH
	--On Error
	IF @@TRANCOUNT > 0
	 ROLLBACK TRANSACTION;
	 DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
	 --Log Error
	 EXEC [spInsertErrorLog]
			 @ModuleName = 'Accounts'
			,@Source = 'Proc_GenerateInvoice'
			,@ErrorMessage = @ErrorMessage
			,@ErrorType = 'SP'
			,@ReportedByUserId = @UserId
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[Proc_RequestInvoice]    Script Date: 31-01-2019 18:30:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_RequestInvoice]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_RequestInvoice] AS' 
END
GO
/***
   Created Date      :     2018-12-27
   Created By        :     Mimansa Agrawal
   Purpose           :     This procedure requests for invoice by users
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
DECLARE @Result int
  EXEC [dbo].[Proc_RequestInvoice]
         @RequestXmlString = '<Root>
                <Row ClientId = "1" NoOfInvoices = "3"></Row>
                <Row ClientId = "2" NoOfInvoices = "6"></Row>
               </Root>'
         ,@UserId = 1108
,@Success = @Result output
SELECT @Result AS [RESULT]
**/
ALTER PROCEDURE [dbo].[Proc_RequestInvoice]
(
 @RequestXmlString XML
,@UserId INT
,@Success TINYINT = 0 OUTPUT 
)
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY
DECLARE @RequestDetailId BIGINT, @InvoiceCount INT
IF OBJECT_ID('tempdb..#Requests') IS NOT NULL
DROP TABLE #Requests
CREATE TABLE #Requests (RequestId INT IDENTITY(1,1), ClientId INT, NoOfInvoices INT)
--BEGIN TRANSACTION
INSERT INTO #Requests(ClientId, NoOfInvoices)
       SELECT T.Item.value('@ClientId', 'varchar(25)'),
           T.Item.value('@NoOfInvoices', 'varchar(25)')
       FROM @RequestXmlString.nodes('/Root/Row') AS T(Item)
	SET @InvoiceCount = (SELECT SUM(NoOfInvoices) FROM #Requests)
	IF (@InvoiceCount > 10)
	BEGIN 
	SET @Success = 2 -----------cant add more than 10
	END
	ELSE
	BEGIN
	BEGIN TRANSACTION
INSERT INTO [dbo].[InvoiceRequest]([UserId],[CreatedBy])
SELECT @UserId,@UserId 
SET @RequestDetailId = SCOPE_IDENTITY()
INSERT INTO [dbo].[InvoiceRequestDetail](InvoiceRequestId,ClientId,RequestedCount,AvailableCount,CreatedBy)
SELECT @RequestDetailId,T.[ClientId],T.[NoOfInvoices],t.[NoOfInvoices],@UserId
FROM #Requests T
COMMIT
SET @Success= 1------------added successfully
END
END TRY
BEGIN CATCH
	--On Error
	IF @@TRANCOUNT > 0
	 ROLLBACK TRANSACTION;

     SET @Success = 0; -- Error occurred
	 DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
	 --Log Error
	 EXEC [spInsertErrorLog]
			 @ModuleName = 'Accounts'
			,@Source = 'Proc_RequestInvoice'
			,@ErrorMessage = @ErrorMessage
			,@ErrorType = 'SP'
			,@ReportedByUserId = @UserId
END CATCH
END
GO
