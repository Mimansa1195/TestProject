GO
/****** Object:  StoredProcedure [dbo].[Proc_AddNewScheduler]    Script Date: 22-02-2019 16:42:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddNewScheduler]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AddNewScheduler]
GO
/****** Object:  StoredProcedure [dbo].[Proc_AddNewScheduler]    Script Date: 22-02-2019 16:42:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddNewScheduler]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_AddNewScheduler] AS' 
END
GO
/***
   Created Date      :     2019-02-20
   Created By        :     Mimansa Agrawal
   Purpose           :     This stored proc is used to add new scheduler
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   
   --------------------------------------------------------------------------
	DECLARE @Result int
		EXEC [dbo].[Proc_AddNewScheduler]
		@SchedulerName=' Mapping' ,
		@Description= 'Card Mapping',
		@FunctionName='testfghfhfhfhfhffhhfhfhjffhffhghfgfgf',
		@RepeatPeriod= 1,
		@RepeatType= 'Hour',
		@RunFor=1,
		@Ids='1108,2434' ,
		@RunDateTime='2019-02-20 00:00',
		@IsCombinedEmail =2203,
		@UserId =2203,
		@Success = @Result output
	SELECT @Result AS [RESULT]
***/
ALTER PROCEDURE [dbo].[Proc_AddNewScheduler]
(
	@SchedulerName varchar (50),
	@Description varchar (500),
	@FunctionName varchar (50),
	@RepeatPeriod int,
	@RepeatType varchar (20),
	@RunFor int,
	@Ids varchar (8000) NULL,
	@RunDateTime datetime,
	@IsCombinedEmail bit,
	@UserId int,
	@Success tinyint = 0 OUTPUT
)
AS
BEGIN TRY
	SET NOCOUNT ON;
	IF ((SELECT Count(*) FROM [dbo].[SchedulerAction] WHERE [FunctionName] = @FunctionName AND [IsActive] = 1) > 0)
	BEGIN
	    SET @Success= 2;
	END
	ELSE
	BEGIN
	IF (@RunFor > 1)
		BEGIN
			BEGIN TRANSACTION;
				INSERT INTO [dbo].[SchedulerAction]([Name],[Description],[FunctionName],[RepeatAfterPeriod],[RepeatAfterType],[LastRunTime],
											[RunFor],[Ids],[CreatedBy],[IsCombinedEmail])
				SELECT @SchedulerName,@Description ,@FunctionName,@RepeatPeriod,@RepeatType,@RunDateTime,@RunFor,
						@Ids,@UserId,@IsCombinedEmail
			COMMIT TRANSACTION;
			SET @Success= 1;
		END
		IF (@RunFor = 1)
		BEGIN
			BEGIN TRANSACTION;
				INSERT INTO [dbo].[SchedulerAction]([Name],[Description],[FunctionName],[RepeatAfterPeriod],[RepeatAfterType],[LastRunTime],
											[RunFor],[CreatedBy],[IsCombinedEmail])
				SELECT @SchedulerName,@Description ,@FunctionName,@RepeatPeriod,@RepeatType,@RunDateTime,@RunFor,@UserId,@IsCombinedEmail
			COMMIT TRANSACTION;
			SET @Success= 1;
		END
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
			 @ModuleName = 'Admnistrations'
			,@Source = '[Proc_AddNewScheduler'
			,@ErrorMessage = @ErrorMessage
			,@ErrorType = 'SP'
			,@ReportedByUserId = @UserId
END CATCH
GO
