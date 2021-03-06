GO
/****** Object:  StoredProcedure [dbo].[Proc_ChangeTrainingStatus]    Script Date: 11-09-2018 18:46:47 ******/
DROP PROCEDURE [dbo].[Proc_ChangeTrainingStatus]
GO
/****** Object:  StoredProcedure [dbo].[Proc_ApplyForTrainingSession]    Script Date: 11-09-2018 18:46:47 ******/
DROP PROCEDURE [dbo].[Proc_ApplyForTrainingSession]
GO
/****** Object:  StoredProcedure [dbo].[Proc_AddTraining]    Script Date: 11-09-2018 18:46:47 ******/
DROP PROCEDURE [dbo].[Proc_AddTraining]
GO
ALTER TABLE [dbo].[TrainingDetail] DROP CONSTRAINT [FK__TrainingD__Train__297984BB]
GO
ALTER TABLE [dbo].[TrainingDetail] DROP CONSTRAINT [FK__TrainingD__Statu__2B61CD2D]
GO
ALTER TABLE [dbo].[TrainingDetail] DROP CONSTRAINT [FK__TrainingD__Emplo__2A6DA8F4]
GO
ALTER TABLE [dbo].[TrainingDetail] DROP CONSTRAINT [FK__TrainingD__Appro__2D4A159F]
GO
/****** Object:  Table [dbo].[TrainingStatus]    Script Date: 11-09-2018 18:46:47 ******/
DROP TABLE [dbo].[TrainingStatus]
GO
/****** Object:  Table [dbo].[TrainingDetail]    Script Date: 11-09-2018 18:46:47 ******/
DROP TABLE [dbo].[TrainingDetail]
GO
/****** Object:  Table [dbo].[Training]    Script Date: 11-09-2018 18:46:47 ******/
DROP TABLE [dbo].[Training]
GO
/****** Object:  Table [dbo].[Training]    Script Date: 11-09-2018 18:46:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Training](
	[TrainingId] [int] IDENTITY(1,1) NOT NULL,
	[Title] [varchar](1000) NOT NULL,
	[Description] [varchar](2000) NOT NULL,
	[TentativeDate] [date] NOT NULL,
	[NominationStartDate] [date] NOT NULL,
	[NominationEndDate] [date] NOT NULL,
	[IsNominationClosed] [bit] NOT NULL DEFAULT ((0)),
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL DEFAULT (getdate()),
	[LastModifiedBy] [int] NULL,
	[LastModifiedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[TrainingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TrainingDetail]    Script Date: 11-09-2018 18:46:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TrainingDetail](
	[TrainingDetailId] [int] IDENTITY(1,1) NOT NULL,
	[TrainingId] [int] NOT NULL,
	[EmployeeId] [int] NOT NULL,
	[StatusId] [int] NOT NULL DEFAULT ((1)),
	[ApproverId] [int] NOT NULL,
	[Remarks] [varchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL DEFAULT (getdate()),
	[LastModifiedBy] [int] NULL,
	[LastModifiedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[TrainingDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TrainingStatus]    Script Date: 11-09-2018 18:46:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TrainingStatus](
	[StatusId] [int] IDENTITY(1,1) NOT NULL,
	[StatusCode] [varchar](10) NOT NULL,
	[Status] [varchar](100) NOT NULL,
	[IsActive] [bit] NOT NULL DEFAULT ((1)),
	[CreatedDate] [datetime] NOT NULL DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[LastModifiedBy] [int] NULL,
	[LastModifiedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[StatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[TrainingDetail]  WITH CHECK ADD FOREIGN KEY([ApproverId])
REFERENCES [dbo].[User] ([UserId])
GO
ALTER TABLE [dbo].[TrainingDetail]  WITH CHECK ADD FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[User] ([UserId])
GO
ALTER TABLE [dbo].[TrainingDetail]  WITH CHECK ADD FOREIGN KEY([StatusId])
REFERENCES [dbo].[TrainingStatus] ([StatusId])
GO
ALTER TABLE [dbo].[TrainingDetail]  WITH CHECK ADD FOREIGN KEY([TrainingId])
REFERENCES [dbo].[Training] ([TrainingId])
GO
/****** Object:  StoredProcedure [dbo].[Proc_AddTraining]    Script Date: 11-09-2018 18:46:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***
   Created Date      :     2018-09-05
   Created By        :     Mimansa Agrawal
   Purpose           :     This procedure adds training sessions by HR 
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
DECLARE @Result int
EXEC Proc_AddTraining
@Title='Finance'
@Description=Finance,
@TentativeDate='',
@FromDate='',
@EndDate='',
@UserId='',
@Success = @Result output
SELECT @Result AS [RESULT]
**/
CREATE PROCEDURE [dbo].[Proc_AddTraining]
(
@Title VARCHAR(1000),
@Description VARCHAR(2000),
@TentativeDate DATE,
@FromDate DATE,
@EndDate DATE,
@UserId INT,
@Success TINYINT = 0 OUTPUT 
)
AS
BEGIN TRY
IF EXISTS(SELECT 1 FROM [dbo].[Training] WHERE [Title] = @Title AND [TentativeDate]=@TentativeDate) -- check if already exists
		BEGIN
			 SET @Success=2 --already exists
		END
ELSE
BEGIN
BEGIN TRANSACTION
INSERT INTO [dbo].[Training]([Title],[Description],[TentativeDate],[NominationStartDate],[NominationEndDate],[CreatedBy])
SELECT @Title,@Description,@TentativeDate,@FromDate,@EndDate,@UserId

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
			 @ModuleName = 'HRPortal'
			,@Source = 'Proc_AddTraining'
			,@ErrorMessage = @ErrorMessage
			,@ErrorType = 'SP'
			,@ReportedByUserId = @UserId
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[Proc_ApplyForTrainingSession]    Script Date: 11-09-2018 18:46:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***
   Created Date      :     2018-09-05
   Created By        :     Mimansa Agrawal
   Purpose           :     This procedure is used to apply for training sessions by users 
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
DECLARE @Result int
EXEC Proc_ApplyForTrainingSession
@TrainingId=4,
@EmployeeId=2434,
@Success = @Result output
SELECT @Result AS [RESULT]
**/
CREATE PROCEDURE [dbo].[Proc_ApplyForTrainingSession]
(
@TrainingId INT,
@EmployeeId INT,
@Success TINYINT = 0 output
)
AS
BEGIN TRY
IF EXISTS(SELECT 1 FROM [dbo].[TrainingDetail] WHERE [TrainingId] = @TrainingId AND [EmployeeId]=@EmployeeId) -- check if already exists
		BEGIN
			 UPDATE [dbo].[TrainingDetail]
			 SET [StatusId]=1,
			 [Remarks]='Pending For Approval',
			 [LastModifiedBy]=@EmployeeId,
			 [LastModifiedDate]=GETDATE()
			 WHERE [TrainingId] = @TrainingId AND [EmployeeId]=@EmployeeId
			 SET @Success= 2------------added again successfully
        END
ELSE
BEGIN
BEGIN TRANSACTION
DECLARE @ApproverId INT
SET @ApproverId=(SELECT U.[ReportTo] FROM [dbo].[UserDetail] U WHERE U.[UserId]=@EmployeeId)
INSERT INTO [dbo].[TrainingDetail](TrainingId,EmployeeId,ApproverId,CreatedBy)
VALUES(@TrainingId,@EmployeeId,@ApproverId,@EmployeeId)
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
			 @ModuleName = 'HRPortal'
			,@Source = 'Proc_ApplyForTrainingSession'
			,@ErrorMessage = @ErrorMessage
			,@ErrorType = 'SP'
			,@ReportedByUserId = @EmployeeId
END CATCH

GO
/****** Object:  StoredProcedure [dbo].[Proc_ChangeTrainingStatus]    Script Date: 11-09-2018 18:46:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***
   Created Date      :     2018-09-05
   Created By        :     Mimansa Agrawal
   Purpose           :     This procedure changes training session nomination openings status 
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   
   --------------------------------------------------------------------------

   Test Cases        :
 
EXEC [dbo].[Proc_ChangeTrainingStatus]
	@TrainingId = 1
    ,@Status = 2 --Status = 1:open nominations, 2:close nominations
	,@UserId = 1
              
***/

CREATE PROCEDURE [dbo].[Proc_ChangeTrainingStatus]
(
    @TrainingId int
   ,@Status int
   ,@UserId int
) 
AS
BEGIN
	
	SET NOCOUNT ON;
	BEGIN TRY
      IF(@Status = 1) --open nominations 
      BEGIN
         BEGIN TRANSACTION
            UPDATE [dbo].[Training]
            SET
                [IsNominationClosed] = 0
               ,[LastModifiedBy] = @UserId
               ,[LastModifiedDate] = GETDATE()
            WHERE [TrainingId] = @TrainingId
      END
      ELSE IF(@Status = 2) --close nominations
      BEGIN
         BEGIN TRANSACTION
            UPDATE [dbo].[Training]
            SET
                [IsNominationClosed] = 1
               ,[LastModifiedBy] = @UserId
               ,[LastModifiedDate] = GETDATE()
            WHERE [TrainingId] = @TrainingId
      END
     
      SELECT CAST(1 AS [bit])                                                 AS [Result]
      COMMIT TRANSACTION
   END TRY
   BEGIN CATCH
         ROLLBACK TRANSACTION
         
         DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))

      EXEC [spInsertErrorLog]
	         @ModuleName = 'Training'
         ,@Source = 'Proc_ChangeTrainingStatus'
         ,@ErrorMessage = @ErrorMessage
         ,@ErrorType = 'SP'
         ,@ReportedByUserId = @UserId


           SELECT CAST(0 AS [bit])                                         AS [Result]
         
      END CATCH 
END
GO
---------------insert into menu----------
INSERT INTO Menu (ParentmenuId,MenuName,ControllerName,ActionName,[Sequence],IsLinkEnabled,IsVisible,CreatedById,CssClass) 
VALUES(0,'HR Portal','HRPortal','Index',25,1,1,1,'fa fa-desktop')
INSERT INTO Menu (ParentmenuId,MenuName,ControllerName,ActionName,[Sequence],IsLinkEnabled,IsVisible,CreatedById,CssClass) 
VALUES(186,'Referral','HRPortal','Referral',1,1,1,1,'fa fa-user-circle')
INSERT INTO Menu (ParentmenuId,MenuName,ControllerName,ActionName,[Sequence],IsLinkEnabled,IsVisible,CreatedById,CssClass) 
VALUES(186,'Manage Training','HRPortal','ManageTraining',2,1,1,1,'fa fa-book')
INSERT INTO Menu (ParentmenuId,MenuName,ControllerName,ActionName,[Sequence],IsLinkEnabled,IsVisible,CreatedById,CssClass) 
VALUES(0,'Review Training Request','Training','ReiewTrainingRequest',26,1,1,1,'fa fa-book')


---------------insert widget------------------

INSERT INTO [dbo].[DashboardWidget] (DashboardWidgetName,CreatedById)
VALUES ('Training',1)

----------------insert into trainingStatus---------------

INSERT INTO [dbo].[TrainingStatus]
(StatusCode,[Status],CreatedBy)
VALUES('PA','Pending For Approval',1),('AP','Approved',1),('RJ','Rejected',1),('CA','Cancelled',1)





