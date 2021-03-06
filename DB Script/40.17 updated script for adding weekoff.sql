GO
/****** Object:  StoredProcedure [dbo].[Proc_AddWeekOffUsers]    Script Date: 29-01-2019 16:33:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddWeekOffUsers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AddWeekOffUsers]
GO
/****** Object:  StoredProcedure [dbo].[Proc_AddWeekOffUsers]    Script Date: 29-01-2019 16:33:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddWeekOffUsers]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_AddWeekOffUsers] AS' 
END
GO
/***
   Created Date      :     2019-01-21
   Created By        :     Mimansa Agrawal
   Purpose           :     This stored procedure adds user week off data
   
   Change History    :
   -------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   
   --------------------------------------------------------------------------

   Test Cases        :
   --------------------------------------------------------------------------
   
   --- Test Case 1
      DECLARE @Result int
         EXEC [dbo].[Proc_AddWeekOffUsers]
          @UserIds = '2431'
         ,@DateIds = '11236,11237,11238,11239'
         ,@LoginUserId = 1108
		 ,@Success = @Result OUTPUT
		 SELECT @Result AS [Result]
***/
ALTER PROCEDURE [dbo].[Proc_AddWeekOffUsers]
(
	@UserIds varchar(4000) NULL
  ,@DateIds varchar(4000) NULL
  ,@LoginUserId INT 
  ,@Success TINYINT = 0 OUTPUT
)
AS
BEGIN TRY
IF ((SELECT COUNT(SplitData) FROM [dbo].[Fun_SplitStringInt] (@DateIds,',')) > 3)
BEGIN 
SET @Success=3 ----------cannot insert more than 3 days at a time
END
ELSE IF EXISTS(SELECT 1 FROM [dbo].[EmployeeWiseWeekOff] WHERE [UserId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@UserIds,',')) AND
WeekOffDateId IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@DateIds,',')) AND [IsActive]=1) -- check if already exists
		BEGIN
			 SET @Success=2 --already exists
		END
		ELSE
		BEGIN
BEGIN TRANSACTION
INSERT INTO [dbo].[EmployeeWiseWeekOff]([UserId],[WeekOffDateId],[CreatedBy])
SELECT U.[UserId],D.[DateId],@LoginUserId
FROM [dbo].[DateMaster] D WITH (NOLOCK)
CROSS JOIN [dbo].[UserDetail] U WITH (NOLOCK)
WHERE U.[UserId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@UserIds,',')) AND
D.[DateId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@DateIds,','))
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
			 @ModuleName = 'LNSA'
			,@Source = 'Proc_AddWeekOffUsers'
			,@ErrorMessage = @ErrorMessage
			,@ErrorType = 'SP'
			,@ReportedByUserId = @LoginUserId
END CATCH
	
  



GO
