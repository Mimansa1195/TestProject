GO
/****** Object:  StoredProcedure [dbo].[Proc_ChangeReferralStatus]    Script Date: 10-08-2018 13:17:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_ChangeReferralStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_ChangeReferralStatus]
GO
/****** Object:  StoredProcedure [dbo].[Proc_AddReferral]    Script Date: 10-08-2018 13:17:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddReferral]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AddReferral]
GO
/****** Object:  StoredProcedure [dbo].[Proc_AddRefereeByUser]    Script Date: 10-08-2018 13:17:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddRefereeByUser]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AddRefereeByUser]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ReferralDetail_Referral]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReferralDetail]'))
ALTER TABLE [dbo].[ReferralDetail] DROP CONSTRAINT [FK_ReferralDetail_Referral]
GO
/****** Object:  Table [dbo].[ReferralDetail]    Script Date: 10-08-2018 13:17:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReferralDetail]') AND type in (N'U'))
DROP TABLE [dbo].[ReferralDetail]
GO
/****** Object:  Table [dbo].[Referral]    Script Date: 10-08-2018 13:17:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Referral]') AND type in (N'U'))
DROP TABLE [dbo].[Referral]
GO
/****** Object:  Table [dbo].[Referral]    Script Date: 10-08-2018 13:17:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Referral]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Referral](
	[ReferralId] [int] IDENTITY(1,1) NOT NULL,
	[From] [date] NOT NULL,
	[Till] [date] NOT NULL,
	[Profile] [varchar](200) NOT NULL,
	[Description] [varchar](200) NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_Referral_CreatedDate]  DEFAULT (getdate()),
	[CreatedById] [int] NULL,
	[IsPositionClosed] [bit] NOT NULL DEFAULT ((0)),
	[LastModifiedDate] [datetime] NULL,
	[LastModifiedBy] [int] NULL,
 CONSTRAINT [PK_Referral] PRIMARY KEY CLUSTERED 
(
	[ReferralId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ReferralDetail]    Script Date: 10-08-2018 13:17:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReferralDetail]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ReferralDetail](
	[ReferralDetailId] [int] IDENTITY(1,1) NOT NULL,
	[ReferralId] [int] NOT NULL,
	[RefereeName] [varchar](50) NOT NULL,
	[ReferredBy] [varchar](50) NOT NULL,
	[RelationWithReferee] [varchar](50) NOT NULL,
	[Resume] [varchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_ReferralDetail_CreatedDate]  DEFAULT (getdate()),
	[ReferredById] [int] NOT NULL,
 CONSTRAINT [PK_ReferralDetail] PRIMARY KEY CLUSTERED 
(
	[ReferralDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ReferralDetail_Referral]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReferralDetail]'))
ALTER TABLE [dbo].[ReferralDetail]  WITH CHECK ADD  CONSTRAINT [FK_ReferralDetail_Referral] FOREIGN KEY([ReferralId])
REFERENCES [dbo].[Referral] ([ReferralId])
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ReferralDetail_Referral]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReferralDetail]'))
ALTER TABLE [dbo].[ReferralDetail] CHECK CONSTRAINT [FK_ReferralDetail_Referral]
GO
/****** Object:  StoredProcedure [dbo].[Proc_AddRefereeByUser]    Script Date: 10-08-2018 13:17:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddRefereeByUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_AddRefereeByUser] AS' 
END
GO
/***
   Created Date      :     2018-07-30
   Created By        :     Mimansa Agrawal
   Purpose           :     This procedure adds persons referred by any user for job openings
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   
   --------------------------------------------------------------------------

   Test Cases        :
   --------------------------------------------------------------------------
  
DECLARE @Result int
EXEC [dbo].[Proc_AddRefereeByUser]
    @ReferralId=1 
   ,@RefereeName='abc' 
   ,@Relation='pqr'
   ,@Resume='abc.pdf'
   ,@UserId=2434
   ,@Success = @Result output
SELECT @Result AS [RESULT]
***/
ALTER PROCEDURE [dbo].[Proc_AddRefereeByUser]
(
    @ReferralId int 
   ,@RefereeName varchar(100)  
   ,@Relation varchar(100)
   ,@Resume varchar(500)
   ,@UserId int
   ,@Success TINYINT = 0 OUTPUT
) 
AS
BEGIN
SET NOCOUNT ON;
	BEGIN TRY
      BEGIN TRANSACTION
	  DECLARE @ReferredBy varchar(100)=(SELECT [FirstName]+''+[LastName] FROM UserDetail WHERE UserId=@UserId) 
         INSERT INTO 
            [dbo].[ReferralDetail]
            ([ReferralId],[RefereeName],[ReferredBy],[RelationWithReferee],[Resume],[ReferredById])
         SELECT @ReferralId,@RefereeName,@ReferredBy,@Relation,@Resume,@UserId
               SET @Success=1 -------------------------added successfully
      COMMIT TRANSACTION
   END TRY
   BEGIN CATCH
         ROLLBACK TRANSACTION
         DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))

         EXEC [spInsertErrorLog]
	            @ModuleName = 'Referral'
            ,@Source = 'Proc_AddRefereeByUser'
            ,@ErrorMessage = @ErrorMessage
            ,@ErrorType = 'SP'
            ,@ReportedByUserId = @UserId        

           SET @Success=0 ----------------------error
         
      END CATCH 
END



GO
/****** Object:  StoredProcedure [dbo].[Proc_AddReferral]    Script Date: 10-08-2018 13:17:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddReferral]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_AddReferral] AS' 
END
GO
/***
   Created Date      :     2018-07-12
   Created By        :     Mimansa Agrawal
   Purpose           :     This procedure add job openings by HR 
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   
   --------------------------------------------------------------------------

   Test Cases        :
   --------------------------------------------------------------------------
 DECLARE @Result int
EXEC Proc_AddReferral
@FromDate='',
@EndDate='',
@Position='Business Analyst',
@Description='R Programming',
@UserId=2166,
@Success = @Result output
SELECT @Result AS [RESULT]
**/
ALTER PROCEDURE [dbo].[Proc_AddReferral]
(
@FromDate DATE,
@TillDate DATE,
@Position VARCHAR(200),
@Description varchar(200),
@UserId INT,
@Success TINYINT = 0 OUTPUT 
)
AS
BEGIN TRY
IF EXISTS(SELECT 1 FROM [dbo].[Referral] WHERE [Profile] = @Position) -- check if already exists
		BEGIN
			 SET @Success=2 --already exists
		END
ELSE
BEGIN
BEGIN TRANSACTION
INSERT INTO [dbo].[Referral]([From],Till,[Profile],[Description],CreatedById)
SELECT @FromDate,@TillDate,@Position,@Description,@UserId

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
			 @ModuleName = 'Dashboard'
			,@Source = 'Proc_AddReferral'
			,@ErrorMessage = @ErrorMessage
			,@ErrorType = 'SP'
			,@ReportedByUserId = @UserId
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[Proc_ChangeReferralStatus]    Script Date: 10-08-2018 13:17:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_ChangeReferralStatus]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_ChangeReferralStatus] AS' 
END
GO
/***
   Created Date      :     2018-07-14
   Created By        :     Mimansa Agrawal
   Purpose           :     This procedure changes job openings status 
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   
   --------------------------------------------------------------------------

   Test Cases        :
 
EXEC [dbo].[Proc_ChangeReferralStatus]
	@ReferralId = 1
    ,@Status = 2 --Status = 1:open position, 2:close position
	,@UserId = 1
              
***/

ALTER PROCEDURE [dbo].[Proc_ChangeReferralStatus]
(
    @ReferralId int
   ,@Status int
   ,@UserId int
) 
AS
BEGIN
	
	SET NOCOUNT ON;
	BEGIN TRY
      IF(@Status = 1) --open position 
      BEGIN
         BEGIN TRANSACTION
            UPDATE [dbo].[Referral]
            SET
                [IsPositionClosed] = 0
               ,[LastModifiedBy] = @UserId
               ,[LastModifiedDate] = GETDATE()
            WHERE [ReferralId] = @ReferralId
      END
      ELSE IF(@Status = 2) --close position
      BEGIN
         BEGIN TRANSACTION
            UPDATE [dbo].[Referral]
            SET
                [IsPositionClosed] = 1
               ,[LastModifiedBy] = @UserId
               ,[LastModifiedDate] = GETDATE()
            WHERE [ReferralId] = @ReferralId
      END
     
      SELECT CAST(1 AS [bit])                                                 AS [Result]
      COMMIT TRANSACTION
   END TRY
   BEGIN CATCH
         ROLLBACK TRANSACTION
         
         DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))

      EXEC [spInsertErrorLog]
	         @ModuleName = 'Form'
         ,@Source = 'Proc_ChangeReferralStatus'
         ,@ErrorMessage = @ErrorMessage
         ,@ErrorType = 'SP'
         ,@ReportedByUserId = @UserId


           SELECT CAST(0 AS [bit])                                         AS [Result]
         
      END CATCH 
END



GO
