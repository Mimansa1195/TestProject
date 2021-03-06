USE [MIS]
GO
/****** Object:  StoredProcedure [dbo].[Proc_PromoteUsers]    Script Date: 21-08-2018 16:58:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_PromoteUsers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_PromoteUsers]
GO
/****** Object:  StoredProcedure [dbo].[Proc_PromoteUsers]    Script Date: 21-08-2018 16:58:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_PromoteUsers]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_PromoteUsers] AS' 
END
GO
/***
   Created Date      :     2018-08-08
   Created By        :     Mimansa Agrawal
   Purpose           :     This stored proc is used to promote employees
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   --- Test Case 1
   DECLARE @Result int 
         EXEC [dbo].[Proc_PromoteUsers]
         @EmployeeId=2434
		,@EmpName='Mimansa Agrawal'
		,@OldDesignation='Software Emgineer L1'
		,@NewDesignation='Software Engineer L2'
        ,@PromotionDate='2018-08-08'
		,@OldEmpCode='GSI GI 091'
		,@NewEmpCode='GSI G 111'
        ,@UserId=1108
        ,@Success = @Result output
	    SELECT @Result AS [RESULT]
   ***/
ALTER PROCEDURE [dbo].[Proc_PromoteUsers]
(
@EmployeeId INT,
@EmpName VARCHAR(500),
@OldDesignation VARCHAR(500),
@NewDesignation VARCHAR(500),
@PromotionDate DATE,
@OldEmpCode VARCHAR(100),
@NewEmpCode VARCHAR(100),
@UserId INT,
--@IsIntern BIT,
@Success tinyint = 0 output
)
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY
BEGIN TRANSACTION
DECLARE @NewDesignationId INT,@OldDesignationId INT,@EmployeeName VARCHAR(100),@OldIsIntern BIT,@NewIsIntern BIT,@CLCount INT
SET @OldDesignationId=(SELECT [DesignationId] FROM [dbo].[Designation] WHERE [DesignationName]=@OldDesignation)
SET @OldIsIntern=(SELECT [IsIntern] FROM [dbo].[Designation] WHERE [DesignationId]=@OldDesignationId)
SET @NewDesignationId=(SELECT [DesignationId] FROM [dbo].[Designation] WHERE [DesignationName]=@NewDesignation)
SET @NewIsIntern=(SELECT [IsIntern] FROM [dbo].[Designation] WHERE [DesignationId]=@NewDesignationId)
IF(@NewDesignationId=@OldDesignationId)
BEGIN
SET @Success=3     ------------------old and new designations can't be same
END
-------------update user detail for interns promoted to non interns------------------
ELSE IF(@OldIsIntern=1 AND @NewIsIntern=0)
BEGIN
 DECLARE @PDate int = (SELECT DATEPART(dd, @PromotionDate))
            DECLARE @PMonth int = (SELECT DATEPART(mm, @PromotionDate))         
            SET @CLCount = CASE
                              WHEN @PMonth BETWEEN 4 AND 12 THEN (16 - @PMonth)
                              ELSE (4 - @PMonth)
                           END
            IF(@PDate > 10)
               SET @CLCount = @CLCount - 1
--------------------insert into leave balance history------------------------
  INSERT INTO [dbo].[LeaveBalanceHistory]
         (
            [RecordId],[Count],[CreatedDate],[CreatedBy]
         )
          SELECT B.[RecordId], B.[Count], GETDATE(), @UserId
         FROM [dbo].[UserDetail] U WITH (NOLOCK)
         INNER JOIN [dbo].[LeaveBalance] B WITH (NOLOCK) ON B.[UserId] = U.[UserId] 
         INNER JOIN [dbo].[LeaveTypeMaster] T WITH (NOLOCK) ON T.[TypeId]=B.[LeaveTypeId]
         INNER JOIN [dbo].[Designation] D WITH (NOLOCK) ON D.[DesignationId] = U.[DesignationId] AND D.[IsIntern]=1
         WHERE
            ISNULL(U.[TerminateDate], '2999-12-31') > GETDATE()
            AND U.[UserId]=@EmployeeId
------------------update CLT balance to zero--------------
	UPDATE [dbo].[LeaveBalance]
	SET [Count]=0,
	[LastModifiedDate]=GETDATE(),
	[LastModifiedBy]=@UserId
	WHERE [UserId]=@EmployeeId AND [LeaveTypeId]=9
--------------update CL for interns turning non interns--------------
	UPDATE [dbo].[LeaveBalance]
	SET [Count]=@CLCount,
	[LastModifiedDate]=GETDATE(),
	[LastModifiedBy]=@UserId
	WHERE [UserId]=@EmployeeId AND [LeaveTypeId]=1		
----------------update PL----------
	UPDATE [dbo].[LeaveBalance]
	SET [Count]=CASE
	WHEN @PDate > 15 THEN 0
	ELSE 1
	END,
	[LastModifiedDate]=GETDATE(),
	[LastModifiedBy]=@UserId
	WHERE [UserId]=@EmployeeId AND [LeaveTypeId]=2
---------------update 5CLOY flag-----------
	UPDATE [dbo].[LeaveBalance]
	SET [Count]=1,
	[LastModifiedDate]=GETDATE(),
	[LastModifiedBy]=@UserId
	WHERE [UserId]=@EmployeeId AND [LeaveTypeId]=8
--------------------update userdetail table for interns--------------		
	UPDATE [dbo].[UserDetail]
	SET [DesignationId]=@NewDesignationId,
	[EmployeeId]=@NewEmpCode,
	[LastModifiedBy]=@UserId,
	[LastModifiedDate]=GETDATE()
	WHERE [UserId]=@EmployeeId
----------- insert into user promotion history table----------
	INSERT INTO [dbo].[UserPromotionHistory]
	([UserId],[EmployeeName],[OldDesignation],[NewDesignation],[PromotionDate],[CreatedBy],[OldEmployeeCode],[NewEmployeeCode])
	VALUES
	(@EmployeeId,@EmpName,@OldDesignation,@NewDesignation,@PromotionDate,@UserId,@OldEmpCode,@NewEmpCode)
	SET @Success=2 ------------interns promoted successfully
END
ELSE
BEGIN
------------update user detail for rest cases-----------
	UPDATE [dbo].[UserDetail]
	SET [DesignationId]=@NewDesignationId,
	[EmployeeId]=@NewEmpCode,
	[LastModifiedBy]=@UserId,
	[LastModifiedDate]=GETDATE()
	WHERE [UserId]=@EmployeeId
----------- insert into user promotion history table----------
	INSERT INTO [dbo].[UserPromotionHistory]
	([UserId],[EmployeeName],[OldDesignation],[NewDesignation],[PromotionDate],[CreatedBy],[OldEmployeeCode],[NewEmployeeCode])
	VALUES
	(@EmployeeId,@EmpName,@OldDesignation,@NewDesignation,@PromotionDate,@UserId,@OldEmpCode,@NewEmpCode)
	SET @Success=1 -----------------------other users promoted successfully
END
COMMIT TRANSACTION
   END TRY
   BEGIN CATCH
   SET @Success=0 ------------------error occured
      ROLLBACK TRANSACTION
      
      DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))

      EXEC [spInsertErrorLog]
	         @ModuleName = 'UserManagement'
         ,@Source = 'Proc_PromoteUsers'
         ,@ErrorMessage = @ErrorMessage
         ,@ErrorType = 'SP'
         ,@ReportedByUserId = @UserId       
	END CATCH
END
GO
