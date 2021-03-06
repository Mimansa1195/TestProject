GO
/****** Object:  StoredProcedure [dbo].[Proc_ForwardReferees]    Script Date: 27-08-2018 18:35:35 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_ForwardReferees]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_ForwardReferees]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__ReferralS__Refer__356A5A54]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReferralStatus]'))
ALTER TABLE [dbo].[ReferralStatus] DROP CONSTRAINT [FK__ReferralS__Refer__356A5A54]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__ReferralS__Refer__3476361B]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReferralStatus]'))
ALTER TABLE [dbo].[ReferralStatus] DROP CONSTRAINT [FK__ReferralS__Refer__3476361B]
GO
/****** Object:  Table [dbo].[ReferralStatus]    Script Date: 27-08-2018 18:35:35 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReferralStatus]') AND type in (N'U'))
DROP TABLE [dbo].[ReferralStatus]
GO
/****** Object:  Table [dbo].[ReferralStatus]    Script Date: 27-08-2018 18:35:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReferralStatus]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ReferralStatus](
	[ReferralStatusId] [int] IDENTITY(1,1) NOT NULL,
	[ReferralDetailId] [int] NOT NULL,
	[ReferralId] [int] NOT NULL,
	[RefereeName] [varchar](50) NOT NULL,
	[ForwardedToId] [int] NOT NULL,
	[ReferredById] [int] NOT NULL,
	[IsRelevant] [int] NULL,
	[Message] [varchar](500) NOT NULL,
	[CreatedDate] [datetime] NOT NULL DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[LastModifiedBy] [int] NULL,
	[LastModifiedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ReferralStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__ReferralS__Refer__3476361B]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReferralStatus]'))
ALTER TABLE [dbo].[ReferralStatus]  WITH CHECK ADD FOREIGN KEY([ReferralDetailId])
REFERENCES [dbo].[ReferralDetail] ([ReferralDetailId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__ReferralS__Refer__356A5A54]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReferralStatus]'))
ALTER TABLE [dbo].[ReferralStatus]  WITH CHECK ADD FOREIGN KEY([ReferralId])
REFERENCES [dbo].[Referral] ([ReferralId])
GO
/****** Object:  StoredProcedure [dbo].[Proc_ForwardReferees]    Script Date: 27-08-2018 18:35:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_ForwardReferees]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_ForwardReferees] AS' 
END
GO
/**
Created Date      :     2018-08-22
Created By        :     Mimansa Agrawal
Purpose           :     This stored procedure is used to forward referees
Change History    :
--------------------------------------------------------------------------
Modify Date       Edited By            Change Description
--------------------------------------------------------------------------
--------------------------------------------------------------------------
Test Cases        :
--------------------------------------------------------------------------
--- Test Case 1
DECLARE @Result int 
EXEC [dbo].[Proc_ForwardReferees]
 @DetailId = 6
,@ReferredById = 2434
,@EmpIds = '1108,24'
,@Message  = 'Testing'
,@UserId = 2166
,@Success = @Result output
SELECT @Result AS [RESULT]
***/
ALTER PROCEDURE [dbo].[Proc_ForwardReferees]
(
@DetailId INT,
@ReferredById INT,
@EmpIds VARCHAR(MAX),
@Message VARCHAR(500),
@UserId INT,
@Success tinyint = 0 output
)
AS
BEGIN TRY
BEGIN TRAN
INSERT INTO [dbo].[ReferralStatus]
([ReferralDetailId],[ReferralId],[RefereeName],[ForwardedToId],[ReferredById],[Message],CreatedBy)
SELECT @DetailId,R.[ReferralId],R.[RefereeName],U.[UserId],@ReferredById,@Message,@UserId
FROM UserDetail U
INNER JOIN ReferralDetail R ON R.[ReferredById]=@ReferredById
WHERE U.UserId IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@EmpIds,','))
AND R.[ReferralDetailId]=@DetailId
SET @Success=1;--------------------------inserted successfully
 COMMIT
END TRY	
BEGIN CATCH
   --On Error
   IF @@TRANCOUNT > 0
   BEGIN
     SET @Success = 0; -- Error occurred
	 ROLLBACK TRANSACTION;
	 
	 DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
	 --Log Error
	 EXEC [spInsertErrorLog]
			 @ModuleName = 'Forward Referrals'
			,@Source = 'Proc_ForwardReferees'
			,@ErrorMessage = @ErrorMessage
			,@ErrorType = 'SP'
			,@ReportedByUserId = @UserId
   END
END CATCH

GO
