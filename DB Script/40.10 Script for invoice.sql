GO
/****** Object:  StoredProcedure [dbo].[Proc_RequestInvoice]    Script Date: 03-01-2019 18:10:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_RequestInvoice]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_RequestInvoice]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GenerateInvoice]    Script Date: 03-01-2019 18:10:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GenerateInvoice]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GenerateInvoice]
GO
/****** Object:  StoredProcedure [dbo].[Proc_CheckIfEligibleToRequestInvoice]    Script Date: 03-01-2019 18:10:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_CheckIfEligibleToRequestInvoice]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_CheckIfEligibleToRequestInvoice]
GO
/****** Object:  StoredProcedure [dbo].[Proc_AddClient]    Script Date: 03-01-2019 18:10:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddClient]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AddClient]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__InvoiceRe__UserI__2A6E744B]') AND parent_object_id = OBJECT_ID(N'[dbo].[InvoiceRequest]'))
ALTER TABLE [dbo].[InvoiceRequest] DROP CONSTRAINT [FK__InvoiceRe__UserI__2A6E744B]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Invoice__ClientI__24B59AF5]') AND parent_object_id = OBJECT_ID(N'[dbo].[Invoice]'))
ALTER TABLE [dbo].[Invoice] DROP CONSTRAINT [FK__Invoice__ClientI__24B59AF5]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__Invoice__Created__279207A0]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Invoice] DROP CONSTRAINT [DF__Invoice__Created__279207A0]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__Invoice__IsCance__269DE367]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Invoice] DROP CONSTRAINT [DF__Invoice__IsCance__269DE367]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__Invoice__IsActiv__25A9BF2E]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Invoice] DROP CONSTRAINT [DF__Invoice__IsActiv__25A9BF2E]
END

GO
/****** Object:  Table [dbo].[InvoiceRequest]    Script Date: 03-01-2019 18:10:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InvoiceRequest]') AND type in (N'U'))
DROP TABLE [dbo].[InvoiceRequest]
GO
/****** Object:  Table [dbo].[Invoice]    Script Date: 03-01-2019 18:10:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Invoice]') AND type in (N'U'))
DROP TABLE [dbo].[Invoice]
GO
/****** Object:  Table [dbo].[Client]    Script Date: 03-01-2019 18:10:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Client]') AND type in (N'U'))
DROP TABLE [dbo].[Client]
GO
/****** Object:  Table [dbo].[Client]    Script Date: 03-01-2019 18:10:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Client]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Client](
	[ClientId] [int] IDENTITY(1,1) NOT NULL,
	[ClientName] [varchar](100) NOT NULL,
	[IsActive] [bit] NOT NULL DEFAULT ((1)),
	[CreatedDate] [datetime] NOT NULL DEFAULT (getdate()),
	[CreatedBy] [bigint] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[ClientId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Invoice]    Script Date: 03-01-2019 18:10:41 ******/
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
	[InvoiceNumber] [varchar](20) NOT NULL,
	[ClientId] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[IsCancelled] [bit] NOT NULL,
	[Reason] [varchar](100) NULL,
	[CreatedBy] [bigint] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[InvoiceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[InvoiceRequest]    Script Date: 03-01-2019 18:10:41 ******/
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
	[NoOfInvoicesRequested] [int] NOT NULL,
	[AvailableCount] [int] NOT NULL,
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
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__Invoice__IsActiv__25A9BF2E]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Invoice] ADD  DEFAULT ((1)) FOR [IsActive]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__Invoice__IsCance__269DE367]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Invoice] ADD  DEFAULT ((0)) FOR [IsCancelled]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__Invoice__Created__279207A0]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Invoice] ADD  DEFAULT (getdate()) FOR [CreatedDate]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Invoice__ClientI__24B59AF5]') AND parent_object_id = OBJECT_ID(N'[dbo].[Invoice]'))
ALTER TABLE [dbo].[Invoice]  WITH CHECK ADD FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([ClientId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__InvoiceRe__UserI__2A6E744B]') AND parent_object_id = OBJECT_ID(N'[dbo].[InvoiceRequest]'))
ALTER TABLE [dbo].[InvoiceRequest]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([UserId])
GO
/****** Object:  StoredProcedure [dbo].[Proc_AddClient]    Script Date: 03-01-2019 18:10:41 ******/
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
/****** Object:  StoredProcedure [dbo].[Proc_CheckIfEligibleToRequestInvoice]    Script Date: 03-01-2019 18:10:41 ******/
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
DECLARE @CurrentCount INT=(SELECT TOP 1 AvailableCount FROM [dbo].[InvoiceRequest] WHERE UserId = @UserId ORDER BY InvoiceRequestId DESC)
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
/****** Object:  StoredProcedure [dbo].[Proc_GenerateInvoice]    Script Date: 03-01-2019 18:10:41 ******/
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
@ClientId=3,
@UserId=2166
**/
ALTER PROCEDURE [dbo].[Proc_GenerateInvoice]
(
@ClientId INT,
@UserId INT
)
AS
BEGIN TRY
DECLARE @InvoiceNumber BIGINT = (SELECT TOP 1 [InvoiceNumber] FROM [dbo].[Invoice] ORDER BY [InvoiceId] DESC)
DECLARE @AvailableCount INT = (SELECT TOP 1 [AvailableCount] FROM [dbo].[InvoiceRequest] WHERE UserId=@UserId ORDER BY [InvoiceRequestId] DESC)
DECLARE @NewInvoiceNumber BIGINT 
IF(@InvoiceNumber > 0)	
BEGIN 
SET @NewInvoiceNumber = @InvoiceNumber + 1
END	
ELSE
BEGIN
SET @NewInvoiceNumber = 1000000001
END
BEGIN TRANSACTION
BEGIN 
INSERT INTO [dbo].[Invoice] (InvoiceNumber, ClientId, CreatedBy)
SELECT @NewInvoiceNumber, @ClientId ,@UserId
UPDATE IR
SET IR.[AvailableCount] = @AvailableCount - 1
FROM
(
   SELECT TOP 1 [AvailableCount]
   FROM [InvoiceRequest] WHERE UserId=@UserId ORDER BY [InvoiceRequestId] DESC
) IR
END
COMMIT
SELECT TOP 1 * FROM [dbo].[Invoice] ORDER BY [InvoiceId] DESC
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
/****** Object:  StoredProcedure [dbo].[Proc_RequestInvoice]    Script Date: 03-01-2019 18:10:41 ******/
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
EXEC Proc_RequestInvoice
@NoOfInvoices= 3,
@UserId=2434,
@Success = @Result output
SELECT @Result AS [RESULT]
**/
ALTER PROCEDURE [dbo].[Proc_RequestInvoice]
(
@NoOfInvoices INT,
@UserId INT,
@Success TINYINT = 0 OUTPUT 
)
AS
BEGIN TRY
BEGIN TRANSACTION
INSERT INTO [dbo].[InvoiceRequest]([UserId],[NoOfInvoicesRequested],[AvailableCount],[CreatedBy])
SELECT @UserId,@NoOfInvoices,@NoOfInvoices,@UserId
COMMIT
SET @Success= 1------------added successfully
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
GO
-------------menu updates---------------
INSERT INTO [dbo].[Menu] 
(ParentMenuId,MenuName,ControllerName,ActionName,[Sequence],IsLinkEnabled,IsVisible,IsActive
,CreatedById,CssClass,IsDelegatable,IsTabMenu)
VALUES(0,'Accounts Portal','AccountsPortal','Index',27,1,1,1,2434,'fa fa-inr',0,0)
INSERT INTO [dbo].[Menu] 
(ParentMenuId,MenuName,ControllerName,ActionName,[Sequence],IsLinkEnabled,IsVisible,IsActive
,CreatedById,CssClass,IsDelegatable,IsTabMenu)
VALUES(193,'Generate Invoice','AccountsPortal','GenerateInvoice',1,1,1,1,2434,'fa fa-inr',0,0)
INSERT INTO [dbo].[Menu] 
(ParentMenuId,MenuName,ControllerName,ActionName,[Sequence],IsLinkEnabled,IsVisible,IsActive
,CreatedById,CssClass,IsDelegatable,IsTabMenu)
VALUES(193,'Invoice Report','AccountsPortal','InvoiceReport',2,1,1,1,2434,'fa fa-inr',0,0)
