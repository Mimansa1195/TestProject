GO
/****** Object:  StoredProcedure [dbo].[spSaveNewUser]    Script Date: 21-09-2018 15:34:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spSaveNewUser]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spSaveNewUser]
GO
/****** Object:  StoredProcedure [dbo].[spFetchPendingTimeSheets]    Script Date: 21-09-2018 15:34:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spFetchPendingTimeSheets]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spFetchPendingTimeSheets]
GO
/****** Object:  StoredProcedure [dbo].[Proc_PromoteUsers]    Script Date: 21-09-2018 15:34:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_PromoteUsers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_PromoteUsers]
GO
/****** Object:  StoredProcedure [dbo].[Proc_FetchUserForTimesheets]    Script Date: 21-09-2018 15:34:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_FetchUserForTimesheets]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_FetchUserForTimesheets]
GO
/****** Object:  StoredProcedure [dbo].[Proc_FetchLeaveDetailsForPromotionAndNewUser]    Script Date: 21-09-2018 15:34:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_FetchLeaveDetailsForPromotionAndNewUser]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_FetchLeaveDetailsForPromotionAndNewUser]
GO
/****** Object:  StoredProcedure [dbo].[Proc_BulkActionOnApproveOuting]    Script Date: 21-09-2018 15:34:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BulkActionOnApproveOuting]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BulkActionOnApproveOuting]
GO
/****** Object:  StoredProcedure [dbo].[Proc_BulkActionOnApproveLegitimateRequest]    Script Date: 21-09-2018 15:34:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BulkActionOnApproveLegitimateRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BulkActionOnApproveLegitimateRequest]
GO
/****** Object:  StoredProcedure [dbo].[Proc_BulkActionOnApproveDataChange]    Script Date: 21-09-2018 15:34:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BulkActionOnApproveDataChange]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BulkActionOnApproveDataChange]
GO
/****** Object:  StoredProcedure [dbo].[Proc_BulkActionOnApproveDataChange]    Script Date: 21-09-2018 15:34:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BulkActionOnApproveDataChange]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_BulkActionOnApproveDataChange] AS' 
END
GO
-- =============================================
-- Author:		Mimansa Agrawal
-- Create date: 14-09-2018
-- Description:	To Bulk Approve Data change request
-- EXEC [dbo].[Proc_BulkActionOnApproveDataChange] '1,2','PV','OK',2166
-- =============================================
ALTER PROCEDURE [dbo].[Proc_BulkActionOnApproveDataChange]
 @RequestApplicationIds varchar(200)
,@Status [varchar](10)
,@Remark [varchar] (200)
,@UserId [int]
AS
BEGIN
      SET NOCOUNT ON;  
      SET FMTONLY OFF;

	   IF OBJECT_ID('tempdb..#Status') IS NOT NULL
		DROP TABLE #Status

	   IF OBJECT_ID('tempdb..#TempTable') IS NOT NULL
		
		DROP TABLE #TempTable
		DECLARE @Id int
		create table #Status(
		[Id] int IDENTITY(1, 1),
		Msg varchar(10),
		ApplicationId int 
		)
		create table #TempTable(
		     [Id] int IDENTITY(1, 1),
			 [RequestApplicationId] int
			 )

		insert INTO #TempTable  SELECT SplitData as RequestApplicationId FROM [dbo].[Fun_SplitStringInt] (@RequestApplicationIds,',')

		 DECLARE @Count int = 1
                        WHILE(@Count <= (SELECT COUNT(*) FROM #TempTable))
                        BEGIN
						  DECLARE @RequestApplicationId INT , @SPStatus varchar(10)
						     SELECT  @RequestApplicationId = [RequestApplicationId] FROM #TempTable C WHERE C.[Id] = @Count

							insert into #Status (Msg)
							EXEC [dbo].[spTakeActionOnDataVerificationRequest]   @RequestApplicationId, @Status, @Remark,@UserId;
							
							UPDATE #Status SET ApplicationId = @RequestApplicationId WHERE Id = SCOPE_IDENTITY();

                        SET @Count = @Count + 1
						end

		select Msg,ApplicationId from #Status
END





GO
/****** Object:  StoredProcedure [dbo].[Proc_BulkActionOnApproveLegitimateRequest]    Script Date: 21-09-2018 15:34:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BulkActionOnApproveLegitimateRequest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_BulkActionOnApproveLegitimateRequest] AS' 
END
GO
-- =============================================
-- Author:		Mimansa Agrawal
-- Create date: 13-09-2018
-- Description:	To Bulk Approve Legitimate Requests
-- EXEC [dbo].[Proc_BulkActionOnApproveLegitimateRequest] '41,42','VD','OK',2166,'HR'
-- =============================================
ALTER PROCEDURE [dbo].[Proc_BulkActionOnApproveLegitimateRequest]
 @RequestIds varchar(200)
,@StatusCode [varchar](10)
,@Remarks [Varchar] (200)
,@UserId [int]
,@UserType [varchar] (200)
--,@Result [int]
AS
BEGIN
      SET NOCOUNT ON;  
      SET FMTONLY OFF;

	   IF OBJECT_ID('tempdb..#Status') IS NOT NULL
		DROP TABLE #Status

	   IF OBJECT_ID('tempdb..#TempTable') IS NOT NULL
		DROP TABLE #TempTable

		DECLARE @Id int
		create table #Status(
		[Id] int IDENTITY(1, 1),
		Msg INT,
		ApplicationId int 
		)
		create table #TempTable(
		     [Id] int IDENTITY(1, 1),
			 [RequestApplicationId] int
			 )

		insert INTO #TempTable  SELECT SplitData as RequestApplicationId FROM [dbo].[Fun_SplitStringInt] (@RequestIds,',')

		 DECLARE @Count int = 1
                        WHILE(@Count <= (SELECT COUNT(*) FROM #TempTable))
                        BEGIN
						 DECLARE @LegitimateLeaveRequestId INT , @SPStatus varchar(20),@Result INT
						     SELECT  @LegitimateLeaveRequestId = [RequestApplicationId] FROM #TempTable C WHERE C.[Id] = @Count
							 EXEC [dbo].[Proc_TakeActionOnLegitimateLeave]  @LegitimateLeaveRequestId, @StatusCode, @Remarks,@UserId,@UserType,@Result OUTPUT;
							insert into #Status (Msg) VALUES (@Result)
							UPDATE #Status SET ApplicationId = @LegitimateLeaveRequestId WHERE Id = SCOPE_IDENTITY();
                        SET @Count = @Count + 1
						end

		select Msg,ApplicationId FROM #Status
END


GO
/****** Object:  StoredProcedure [dbo].[Proc_BulkActionOnApproveOuting]    Script Date: 21-09-2018 15:34:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BulkActionOnApproveOuting]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_BulkActionOnApproveOuting] AS' 
END
GO
-- =============================================
-- Author:		Mimansa Agrawal
-- Create date: 13-09-2018
-- Description:	To Bulk Approve Outing Requests
-- EXEC [dbo].[Proc_BulkActionOnApproveOuting] '41,42','VD','OK',2166,'HR'
-- =============================================
ALTER PROCEDURE [dbo].[Proc_BulkActionOnApproveOuting]
 @RequestIds varchar(200)
,@StatusCode [varchar](10)
,@Remarks [Varchar] (200)
,@UserId [int]
,@UserType [varchar] (200)
--,@Result [int]
AS
BEGIN
      SET NOCOUNT ON;  
      SET FMTONLY OFF;

	   IF OBJECT_ID('tempdb..#Status') IS NOT NULL
		DROP TABLE #Status

	   IF OBJECT_ID('tempdb..#TempTable') IS NOT NULL
		DROP TABLE #TempTable

		DECLARE @Id int
		create table #Status(
		[Id] int IDENTITY(1, 1),
		Msg INT,
		ApplicationId int 
		)
		create table #TempTable(
		     [Id] int IDENTITY(1, 1),
			 [RequestApplicationId] int
			 )

		insert INTO #TempTable  SELECT SplitData as RequestApplicationId FROM [dbo].[Fun_SplitStringInt] (@RequestIds,',')

		 DECLARE @Count int = 1
                        WHILE(@Count <= (SELECT COUNT(*) FROM #TempTable))
                        BEGIN
						 DECLARE @OutingRequestId INT , @SPStatus varchar(20),@Result INT
						     SELECT  @OutingRequestId = [RequestApplicationId] FROM #TempTable C WHERE C.[Id] = @Count
							 EXEC [dbo].[Proc_TakeActionOnOutingRequest]  @OutingRequestId, @StatusCode, @Remarks,@UserId,@UserType,0,@Result OUTPUT;
							insert into #Status (Msg) VALUES (@Result)
							UPDATE #Status SET ApplicationId = @OutingRequestId WHERE Id = SCOPE_IDENTITY();
                        SET @Count = @Count + 1
						end

		select Msg,ApplicationId FROM #Status
END


GO
/****** Object:  StoredProcedure [dbo].[Proc_FetchLeaveDetailsForPromotionAndNewUser]    Script Date: 21-09-2018 15:34:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_FetchLeaveDetailsForPromotionAndNewUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_FetchLeaveDetailsForPromotionAndNewUser] AS' 
END
GO
/***
   Created Date      :     2018-08-07
   Created By        :     Mimansa Agrawal
   Purpose           :     This stored procedure return leave balance before and after promotion based on userId
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   EXEC [dbo].[Proc_FetchLeaveDetailsForPromotionAndNewUser] 
   @UserId = 2417
  ,@NewDesignationId=3
  ,@PromotionDate='06/16/2018'
***/
ALTER PROCEDURE [dbo].[Proc_FetchLeaveDetailsForPromotionAndNewUser]
(
	@UserId int,
	@NewDesignationId int,
	@PromotionDate date 
)
AS
BEGIN
SET NOCOUNT ON;
SET FMTONLY OFF;    
IF OBJECT_ID('tempdb..#TempLeaveCount') IS NOT NULL
DROP TABLE #TempLeaveCount
CREATE TABLE #TempLeaveCount
(
[LeaveType] VARCHAR (50) NOT NULL,
[LeaveCount] INT NOT NULL
)
DECLARE @CLCount INT,@PLCount INT,@5CLOY INT,@NewCLCount INT,@NewPLCount INT,@OldIsIntern BIT,@NewIsIntern BIT,@CurrentMonth INT,
@ValidUserId INT= 0;
SET @CLCount=(SELECT [Count] FROM [dbo].[LeaveBalance] WHERE [UserId]=@UserId AND [LeaveTypeId]=1)
SET @PLCount=(SELECT [Count] FROM [dbo].[LeaveBalance] WHERE [UserId]=@UserId AND [LeaveTypeId]=2)
SET @5CLOY=(SELECT [Count] FROM [dbo].[LeaveBalance] WHERE [UserId]=@UserId AND [LeaveTypeId]=8)
SELECT @OldIsIntern=[IsIntern], @ValidUserId = UserId FROM [dbo].[vwActiveUsers] VAU WHERE [UserId]=@UserId
SET @NewIsIntern=(SELECT [IsIntern] FROM [dbo].[Designation] WHERE [DesignationId]=@NewDesignationId)
SET @CurrentMonth=(SELECT DATEPART(mm,GETDATE()))
DECLARE @CurrentYear INT=(SELECT DATEPART(YYYY, GETDATE()))
DECLARE @PYear INT=(SELECT DATEPART(YYYY, @PromotionDate))
DECLARE @PDate int = (SELECT DATEPART(dd, @PromotionDate))
DECLARE @PMonth int = (SELECT DATEPART(mm, @PromotionDate)) 
IF(@ValidUserId > 0)
BEGIN
IF(@OldIsIntern=1 AND @NewIsIntern=0) --leave details for interns to non interns position
BEGIN
SET @NewPLCount=CASE
				WHEN @PDate > 15 AND @CurrentYear=@PYear  THEN  @CurrentMonth-@PMonth
                WHEN @PDate > 15 AND @CurrentYear!=@PYear  THEN 12 + @CurrentMonth-@PMonth
                WHEN @PDate <= 15 AND @CurrentYear!=@PYear  THEN 13 + @CurrentMonth-@PMonth
                ELSE @CurrentMonth-@PMonth+1 
				END     
SET @NewCLCount=CASE
				WHEN @PMonth BETWEEN 4 AND 12 THEN (16 - @PMonth)
				ELSE (4 - @PMonth)
				END
IF(@PDate > 10)
   SET @NewCLCount = @NewCLCount - 1
INSERT INTO #TempLeaveCount
([LeaveType] ,[LeaveCount])
VALUES('OldCL',@CLCount),('OldPL',@PLCount),('Old5CLOY',@5CLOY),('NewCL',@NewCLCount),('NewPL',@NewPLCount),('New5CLOY',1),('OldRole',5),('NewRole',4)-----5 is roleid for trainee and 4 for user
END
ELSE
BEGIN
INSERT INTO #TempLeaveCount
([LeaveType] ,[LeaveCount])
VALUES('OldCL',@CLCount),('OldPL',@PLCount),('Old5CLOY',@5CLOY),('NewCL',@CLCount),('NewPL',@PLCount),('New5CLOY',@5CLOY) 
END
END
ELSE --For New User
BEGIN
IF(@NewIsIntern=0) --leave details for non-intern positions
BEGIN
SET @CLCount = CASE
               WHEN @PMonth BETWEEN 4 AND 12 THEN (16 - @PMonth)
               ELSE (4 - @PMonth)
               END
            IF(@PDate > 10)
               SET @CLCount = @CLCount - 1
SET @PLCount=CASE
				WHEN @PDate > 15 AND @CurrentYear=@PYear  THEN  @CurrentMonth-@PMonth
				WHEN @PDate > 15 AND @CurrentYear!=@PYear  THEN 12 + @CurrentMonth-@PMonth
				WHEN @PDate <= 15 AND @CurrentYear!=@PYear  THEN 13 + @CurrentMonth-@PMonth
				ELSE @CurrentMonth-@PMonth+1 
				END     
INSERT INTO #TempLeaveCount
([LeaveType] ,[LeaveCount])
VALUES('CL',@CLCount),('PL',@PLCount),('5CLOY',1)
END
ELSE    ------------------for interns
BEGIN
SET @CLCount = CASE
               WHEN @PMonth IN (1,4,7,10) THEN 3
			   WHEN @PMonth IN (2,5,8,11) THEN 2
               ELSE 1
               END
             IF(@PDate > 15)          ----if date greater than 15 then reduce CL by 1
               SET @CLCount = @CLCount - 1
INSERT INTO #TempLeaveCount
([LeaveType] ,[LeaveCount])
VALUES('CL',@CLCount),('PL',0),('5CLOY',0) 
END
END
SELECT [LeaveType],[LeaveCount] 
FROM #TempLeaveCount
END
GO
/****** Object:  StoredProcedure [dbo].[Proc_FetchUserForTimesheets]    Script Date: 21-09-2018 15:34:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_FetchUserForTimesheets]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_FetchUserForTimesheets] AS' 
END
GO
/***
   Created Date      :     2018-09-20
   Created By        :     Mimansa Agrawal
   Purpose           :     This stored procedure return eligible and excluded users for timesheets
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   EXEC [dbo].[Proc_FetchUserForTimesheets]
   @UserId=58,
   @Category=2
***/
ALTER PROCEDURE [dbo].[Proc_FetchUserForTimesheets]
(
@UserId INT,
@Category INT                    
)
AS
BEGIN
IF(@Category=1) ---------------------For eligible users-----------------
BEGIN 
SELECT v.[UserId],v.[EmployeeName] FROM [dbo].[vwActiveUsers] v 
INNER JOIN [dbo].[vwActiveUsers] vw on v.[RMId]=vw.[UserId]
LEFT JOIN [dbo].[TimesheetExcludedUser] t on t.[UserId]=v.[UserId] AND t.[IsActive]=1
where t.[UserId] IS NULL
AND v.[RMId]=@UserId 
ORDER BY v.[EmployeeName]
END
ELSE       ----------------for excluded users---------------
BEGIN
SELECT v.[UserId],v.[EmployeeName] FROM [dbo].[vwActiveUsers]  v 
INNER JOIN [dbo].[vwActiveUsers] vw on v.rmid=vw.userid
LEFT JOIN [dbo].[TimesheetExcludedUser] t on t.[UserId]=v.[UserId] AND t.[IsActive]=1
where t.[UserId] IS NOT NULL
and v.[RMId]=@UserId 
ORDER BY v.[EmployeeName]
END
END
GO
/****** Object:  StoredProcedure [dbo].[Proc_PromoteUsers]    Script Date: 21-09-2018 15:34:38 ******/
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
		,@NewDesignationId=3
        ,@PromotionDate='2018-08-08'
	    ,@NewEmpCode='GSI G 111'
        ,@UserId=1108
        ,@Success = @Result output
	    SELECT @Result AS [RESULT]
   ***/
ALTER PROCEDURE [dbo].[Proc_PromoteUsers]
(
	@EmployeeId INT,
	@NewDesignationId INT,
	@PromotionDate DATE,
	@NewEmpCode VARCHAR(100),
	@UserId INT,
	@Success tinyint = 0 output
)
AS
BEGIN TRY
SET NOCOUNT ON;
BEGIN TRANSACTION
	DECLARE @OldDesignationId INT,@OldIsIntern BIT,@NewIsIntern BIT,@CLCount INT,@CurrentMonth INT,@OldEmpCode VARCHAR(50)
	SELECT @OldDesignationId=[DesignationId],@OldEmpCode=[EmployeeId] FROM [dbo].[UserDetail] WHERE [UserId]=@EmployeeId
	SET @OldIsIntern=(SELECT [IsIntern] FROM [dbo].[Designation] WHERE [DesignationId]=@OldDesignationId)
	SELECT @NewIsIntern=[IsIntern] FROM [dbo].[Designation] WHERE [DesignationId]=@NewDesignationId
	SET @CurrentMonth=(SELECT DATEPART(mm, GETDATE()))
	DECLARE @CurrentYear INT=(SELECT DATEPART(YYYY, GETDATE()))
	DECLARE @PYear INT=(SELECT DATEPART(YYYY, @PromotionDate))
	IF(@NewDesignationId=@OldDesignationId)
	BEGIN
	SET @Success=3     ------------------old and new designations can't be same
	END
	-------------update users details for interns promoted to non interns------------------
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
		WHEN @PDate > 15 AND @CurrentYear=@PYear  THEN  @CurrentMonth-@PMonth
		WHEN @PDate > 15 AND @CurrentYear!=@PYear  THEN 12 + @CurrentMonth-@PMonth
		WHEN @PDate <= 15 AND @CurrentYear!=@PYear  THEN 13 + @CurrentMonth-@PMonth
		ELSE @CurrentMonth-@PMonth+1 
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
		------------------update user table for interns to non-interns-------------
		UPDATE [dbo].[User]
		SET [RoleId]=(SELECT RoleId From [dbo].[Role] WHERE UPPER(RoleName)='USER'),
		[LastModifiedBy]=@UserId,
		[LastModifiedDate]=GETDATE()
		WHERE [UserId]=@EmployeeId
	----------- insert into user promotion history table----------
		INSERT INTO [dbo].[UserPromotionHistory]
		([UserId],[OldDesignationId],[NewDesignationId],[PromotionDate],[CreatedBy],[OldEmployeeCode],[NewEmployeeCode])
		VALUES
		(@EmployeeId,@OldDesignationId,@NewDesignationId,@PromotionDate,@UserId,@OldEmpCode,@NewEmpCode)
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
		([UserId],[OldDesignationId],[NewDesignationId],[PromotionDate],[CreatedBy],[OldEmployeeCode],[NewEmployeeCode])
		VALUES
		(@EmployeeId,@OldDesignationId,@NewDesignationId,@PromotionDate,@UserId,@OldEmpCode,@NewEmpCode)
		SET @Success=1 -----------------------other users promoted successfully
	END
COMMIT TRANSACTION
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0
	  BEGIN
         ROLLBACK TRANSACTION;
	  END
     SET @Success=0 ------------------error occured 
DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
	EXEC [spInsertErrorLog]
	     @ModuleName = 'UserManagement'
        ,@Source = 'Proc_PromoteUsers'
        ,@ErrorMessage = @ErrorMessage
        ,@ErrorType = 'SP'
        ,@ReportedByUserId = @UserId       
	END CATCH
GO
/****** Object:  StoredProcedure [dbo].[spFetchPendingTimeSheets]    Script Date: 21-09-2018 15:34:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spFetchPendingTimeSheets]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spFetchPendingTimeSheets] AS' 
END
GO
/***
   Created Date      :     2015-04-01
   Created By        :     Rakesh Gandhi
   Purpose           :     This stored procedure retrives name of employees who had not submitted their time sheet for a selected week
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   
   --- Test Case 1
         EXEC [dbo].[spFetchPendingTimeSheets]
            @WeekNo = 19
           ,@Year = 2018
           ,@UserId = 47
***/
ALTER PROCEDURE [dbo].[spFetchPendingTimeSheets]
  (@WeekNo [int]
  ,@Year [int] 
  ,@UserId [int])
AS
BEGIN
SET NOCOUNT ON; 
if(@UserId in (3,4,2167,2203))	
BEGIN
;WITH UsersReportToMe ([EmployeeId], [EmployeeName], [ManagerId], [ManagerName], [Level])
AS
(
 -- Anchor member definition
SELECT 
	 UD.[UserId] AS [EmployeeId]
	,UD.[EmployeeName] AS [EmployeeName]
	,MD.[UserId] AS [ManagerId]
	,MD.[EmployeeName] AS [ManagerName]
	,0 AS [Level]
FROM [dbo].[vwActiveUsers] UD WITH (NOLOCK)
--INNER JOIN [dbo].[TempEmployeeReminderDetail] T WITH (NOLOCK) ON UD.[UserId] = T.[UserId]
INNER JOIN [dbo].[vwActiveUsers] MD WITH (NOLOCK) ON MD.[UserId] = UD.[RMId] 
UNION ALL
-- Recursive member definition
SELECT 
	 UD.[UserId] AS [EmployeeId]
	,UD.[EmployeeName] AS [EmployeeName] 
	,MD.[EmployeeId] AS [ManagerId]
	,MD.[EmployeeName] AS [ManagerName]
	,[Level] + 1 AS [Level]
FROM [dbo].[vwActiveUsers] UD WITH (NOLOCK)
--INNER JOIN [dbo].[TempEmployeeReminderDetail] T WITH (NOLOCK) ON UD.[UserId] = T.[UserId]
INNER JOIN [UsersReportToMe] MD ON UD.[RMId] = MD.[EmployeeId]
)
SELECT DISTINCT
	 UD.[EmployeeName] AS [EmployeeName]
	,MD.[EmployeeName] AS [ManagerName]
	,CASE
	 WHEN A.[Status] IS NULL OR A.[Status] < 1 THEN 'inline-block'
	 ELSE 'none'
	 END AS [Applicant]
	,CASE
	 WHEN A.[Status] = 1 THEN 'inline-block'
	 ELSE 'none'
	 END        AS [Reviewer]
FROM
[dbo].[vwActiveUsers] UD WITH (NOLOCK)
INNER JOIN [dbo].[User] US WITH (NOLOCK) ON UD.[UserId] = US.[UserId]
INNER JOIN [UsersReportToMe] R  ON UD.[UserId] = R.[EmployeeId]
LEFT JOIN [dbo].[TimesheetExcludedUser] T WITH (NOLOCK) ON R.[EmployeeId] = T.[UserId]  AND T.[IsActive]=1
INNER JOIN [dbo].[vwActiveUsers] MD WITH (NOLOCK) ON R.[ManagerId] = MD.[UserId]
LEFT JOIN [dbo].[TimeSheet] A WITH (NOLOCK) ON A.[CreatedBy] = UD.[UserId] AND A.[WeekNo] = @WeekNo AND A.[Year] = @Year
WHERE
US.[IsActive] = 1
AND T.[UserId] IS NULL
AND UD.[UserId] <> 1
--AND UD.[UserId] NOT IN (SELECT UserId FROM TimesheetExcludedUser WHERE IsActive=1)
AND A.[Status] IS NULL OR A.[Status] < 2      
END
ELSE
BEGIN
;WITH UsersReportToMe ([EmployeeId], [EmployeeName], [ManagerId], [ManagerName], [Level])
AS
(
-- Anchor member definition
SELECT 
	 UD.[UserId]            AS [EmployeeId]
	,UD.[EmployeeName]      AS [EmployeeName]
	,MD.[UserId]            AS [ManagerId]
	,MD.[EmployeeName]      AS [ManagerName]
	,0                      AS [Level]
FROM 
[dbo].[vwActiveUsers] UD WITH (NOLOCK)
--INNER JOIN [dbo].[TempEmployeeReminderDetail] T WITH (NOLOCK) On UD.[UserId] = T.[UserId]
INNER JOIN [dbo].[vwActiveUsers] MD WITH (NOLOCK) ON MD.[UserId] = UD.[RMId]
WHERE
MD.[UserId] =@UserId
UNION ALL
-- Recursive member definition
SELECT 
	 UD.[UserId]            AS [EmployeeId]
	,UD.[EmployeeName]      AS [EmployeeName] 
	,MD.[EmployeeId]        AS [ManagerId]
	,MD.[EmployeeName]      AS [ManagerName]
	,[Level] + 1            AS [Level]
FROM 
[dbo].[vwActiveUsers] UD WITH (NOLOCK)
--INNER JOIN [dbo].[TempEmployeeReminderDetail] T WITH (NOLOCK) ON UD.[UserId] = T.[UserId]
INNER JOIN [UsersReportToMe] MD ON UD.[RMId] = MD.[EmployeeId]
)
SELECT
	 UD.[EmployeeName]      AS [EmployeeName]
	,MD.[EmployeeName]      AS [ManagerName]
	,CASE
	 WHEN A.[Status] IS NULL OR A.[Status] < 1 THEN 'inline-block'
	 ELSE 'none'
	 END                    AS [Applicant]
	,CASE
	 WHEN A.[Status] = 1 THEN 'inline-block'
	 ELSE 'none'
     END                    AS [Reviewer]
FROM
[dbo].[vwActiveUsers] UD WITH (NOLOCK)
INNER JOIN [dbo].[User] US WITH (NOLOCK) ON UD.[UserId] = US.[UserId]
INNER JOIN [UsersReportToMe] R  ON UD.[UserId] = R.[EmployeeId] 
LEFT JOIN [dbo].[TimesheetExcludedUser] T WITH (NOLOCK) ON R.[EmployeeId] = T.[UserId] AND T.[IsActive]=1
INNER JOIN [dbo].[vwActiveUsers] MD WITH (NOLOCK) ON R.[ManagerId] = MD.[UserId]
LEFT JOIN [dbo].[TimeSheet] A WITH (NOLOCK) ON A.[CreatedBy] = UD.[UserId] AND A.[WeekNo] = @WeekNo AND A.[Year] = @Year
WHERE
US.[IsActive] = 1
AND T.[UserId] IS NULL 
AND UD.[UserId] <> 1
--AND UD.[UserId] NOT IN (SELECT UserId FROM TimesheetExcludedUser WHERE IsActive=1)
AND A.[Status] IS NULL OR A.[Status] < 2      
ORDER BY UD.[EmployeeName]
END
END

GO
/****** Object:  StoredProcedure [dbo].[spSaveNewUser]    Script Date: 21-09-2018 15:34:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spSaveNewUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spSaveNewUser] AS' 
END
GO
/***
   Created Date      :     2016-11-30
   Created By        :     Shubhra Upadhyay
   Purpose           :     This stored procedure is to save a new user (result -> true: success, false: failure)
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   
   --------------------------------------------------------------------------

   Test Cases        :
   --------------------------------------------------------------------------

   --- Test Case 1
         EXEC [dbo].[spSaveNewUser]
             @RegistrationId = 3
             ,@UserName = 'v7dBXhOXkXyqYlDwYki3Fw==' 
             ,@Dob = '4Ea8CbheEbabfwRC/9EUxQB97nHAZ6ND'
             ,@BloodGroup = 'KxWIFmk5Oc+58NhL+KlXOw=='
             ,@EmailId = 'v7dBXhOXkXyPPlWRVWaXi8F8MiKkCki2Ej5ibLBVUVGXqN75EJ7HNA=='
             ,@MobileNumber = 'z/c9Ya2bHtYKHnJGdmBAgw=='
             ,@EmployeeId = 'eid'
             ,@DepartmentId = 2
             ,@DesignationId = 1
             ,@TeamId = 3
             ,@WsNo = 'wsno'
             ,@ExtensionNo = 'ex'
             --,@AccCardNo = 'acc'
             ,@Doj = '12/21/2016'
             ,@RoleId = 3
             ,@ReportingManagerId = 0
             ,@UserId = 84
             ,@PasswordResetCode = '5TUWKYCQ1L'
              
***/
ALTER PROCEDURE [dbo].[spSaveNewUser]
(
     @RegistrationId bigint
    ,@UserName varchar(100)
    ,@Dob varchar(50)
    ,@BloodGroup varchar(50)
    ,@EmailId varchar(150)
    ,@MobileNumber varchar(50)
    ,@EmployeeId varchar(50)
    ,@DepartmentId int
    ,@DesignationId int
	,@ProbationPeriod int
    ,@TeamId bigint
    ,@WsNo varchar(20)
    ,@ExtensionNo varchar(10)
    --,@AccCardNo varchar(50)
    ,@Doj varchar(20)
    ,@RoleId int
    ,@ReportingManagerId int
    ,@UserId int
    ,@PasswordResetCode varchar(15)
	
) 
AS
BEGIN
	
	SET NOCOUNT ON;
	SET FMTONLY OFF;
	IF OBJECT_ID('tempdb..#MappingInfo') IS NOT NULL
	DROP TABLE #MappingInfo
	

CREATE TABLE #MappingInfo(
IsSuccess BIT NOT NULL,
UserId   INT NOT NULL
)
	BEGIN TRY
      
      BEGIN TRANSACTION
         INSERT INTO [dbo].[User]
         (
             [LocationId]
            ,[RoleId]
            ,[UserName]
            ,[IsActive]
            ,[UnsuccessfulLoginAttempt]
            ,[IsLocked]
            ,[IsSuspended]
            ,[IsPasswordResetRequired]
            ,[CreatedDate]
            ,[CreatedBy]
            ,[PasswordResetCode]
            ,[IsPasswordResetCodeExpired]
         )
         VALUES
         (   
             1
            ,@RoleId
            ,@UserName
            ,1
            ,0
            ,0
            ,0
            ,1
            ,GETDATE()
            ,@UserId
            ,@PasswordResetCode
            ,0
         )   

         DECLARE @NewUserId int = SCOPE_IDENTITY() --new UserId
           
         INSERT INTO [dbo].[UserDetail]   -- insert in UserDetail table
         (
             [UserId]
            ,[FirstName]
            ,[MiddleName]
            ,[LastName]
            ,[DOB]
            ,[GenderId]
            ,[MaritalStatusId]
            ,[BloodGroup]
            ,[MobileNumber]
            ,[EmailId]
            ,[EmployeeId]
            ,[JoiningDate]
            ,[DesignationId]
            --,[CreatedBy]
            ,[ReportTo]
            ,[EmergencyContactNumber]
            ,[PersonalEmailId]
            --,[DepartmentId]
            --,[AssignedWorkStation]
            ,[ExtensionNumber]
            ,[InsuranceAmount]
            ,[PanCardId]
            ,[AadhaarCardId]
            ,[VoterCardId]
            ,[DrivingLicenseId]
            ,[PassportId]
            ,[LastEmployerName]
            ,[LastEmployerLocation]
            ,[LastJobTenure]
            ,[JobLeavingReason]
            ,[UAN]
            ,[IsFresher]
            ,[LastJobDesignation]
            ,[ImagePath]
			,[ProbationPeriodMonths]
            --,[PhotoFileName]
         )
         SELECT
      @NewUserId
           ,UR.[FirstName]
           ,ISNULL(UR.[MiddleName], '')
           ,UR.[LastName]
           ,@Dob
           ,UR.[GenderId]
           ,UR.[MaritalStatusId]
           ,@BloodGroup
           ,@MobileNumber
           ,@EmailId
           ,@EmployeeId
           ,@Doj
           ,@DesignationId
           --,UR.[CreatedBy]
           ,@ReportingManagerId
           ,UR.[EmergencyContactNumber]
           ,UR.[PersonalEmailId]
           --,@DepartmentId
           --,@WsNo
           ,@ExtensionNo
           ,UR.[InsuranceAmount]
           ,UR.[PanCardId]
           ,UR.[AadhaarCardId]
           ,UR.[VoterCardId]
           ,UR.[DrivingLicenseId]
           ,UR.[PassportId]
           ,UR.[LastEmployerName]
           ,UR.[LastEmployerLocation]
           ,UR.[LastJobTenure]
           ,UR.[JobLeavingReason]
           ,UR.[LastJobUAN]
           ,UR.[IsFresher]
           ,UR.[LastJobDesignation]
           ,UR.[PhotoFileName]
		   ,@ProbationPeriod
         FROM [dbo].[TempUserRegistration] UR WITH (NOLOCK) WHERE UR.[RegistrationId] = @RegistrationId
         
         INSERT INTO [dbo].[UserAddressDetail]  --insert in UserAddressDetail table
         (
             [UserId]
            ,[Address]
            ,[CountryId]
            ,[StateId]
            ,[CityId]
            ,[PinCode]
            ,[IsAddressPermanent]
            ,[IsActive]
         )
         SELECT
             @NewUserId
            ,UA.[Address]
            ,UA.[CountryId]
            ,UA.[StateId]
            ,UA.[CityId]
            ,UA.[PinCode]
            ,UA.[IsAddressPermanent]
            ,1
         FROM [dbo].[TempUserAddressDetail] UA WITH (NOLOCK) WHERE UA.[RegistrationId] = @RegistrationId
         
         ------------------insert into [UserTeamMapping] starts------------------
         INSERT INTO [dbo].[UserTeamMapping]  
         (
             [UserId]
            ,[TeamId]
            ,[CreatedBy]
            ,[TeamRoleId]
            ,[ConsiderInClientReports]
         )
         SELECT
               @NewUserId
            ,@TeamId
            ,@UserId
            ,7 --set default role as General
            ,0     
         ------------------insert into [UserTeamMapping] ends------------------

         ------------------insert into [LeaveBalance] starts------------------
         IF( (SELECT [IsIntern] FROM [dbo].[Designation] WHERE [DesignationId] = @DesignationId) = 0) --credit leaves for non intern designations
         BEGIN
            DECLARE @JoiningDate int = (SELECT DATEPART(dd, @Doj))
            DECLARE @JoiningMonth int = (SELECT DATEPART(mm, @Doj))  
		    DECLARE @CurrentMonth INT=(SELECT DATEPART(mm, GETDATE()))
            DECLARE @CurrentYear INT=(SELECT DATEPART(YYYY, GETDATE()))  
			DECLARE @JoiningYear INT=(SELECT DATEPART(YYYY, @Doj))   
            DECLARE @CLCount int,@PLCount int
			SET @CLCount = CASE
                              WHEN @JoiningMonth BETWEEN 4 AND 12 THEN (16 - @JoiningMonth)
                              ELSE (4 - @JoiningMonth)
                           END
            IF(@JoiningDate > 10)
               SET @CLCount = @CLCount - 1
            SET @PLCount=CASE
				WHEN @JoiningDate > 15 AND @CurrentYear=@JoiningYear  THEN  @CurrentMonth-@JoiningMonth
				WHEN @JoiningDate > 15 AND @CurrentYear!=@JoiningYear  THEN 12 + @CurrentMonth-@JoiningMonth
				WHEN @JoiningDate <= 15 AND @CurrentYear!=@JoiningYear  THEN 13 + @CurrentMonth-@JoiningMonth
				ELSE @CurrentMonth-@JoiningMonth+1 
				END     
            INSERT INTO [dbo].[LeaveBalance]
            (
               [UserId]
              ,[LeaveTypeId]
              ,[Count]
              ,[CreatedBy]
            )
            SELECT
               @NewUserId
              ,M.[TypeId]
              ,CASE
                  WHEN M.[ShortName] = 'PL' THEN @PLCount
                  WHEN M.[ShortName] = 'CL' THEN @CLCount
                  WHEN M.[ShortName] = '5CLOY' THEN 1
                  ELSE 0
               END
              ,@UserId
            FROM [dbo].[LeaveTypeMaster] M WITH (NOLOCK)
         END
         ELSE  --credit 3 CL for interns quarterly
         BEGIN
		 DECLARE @JDate int = (SELECT DATEPART(dd, @Doj))
            DECLARE @JMonth int = (SELECT DATEPART(mm, @Doj))         
            DECLARE @CLCountInterns int

            SET @CLCountInterns = CASE
                              WHEN @JMonth IN (1,4,7,10) THEN 3
							  WHEN @JMonth IN (2,5,8,11) THEN 2
                              ELSE 1
                           END
            IF(@JDate > 15)          ----if date greater than 15 then reduce CL by 1
               SET @CLCountInterns = @CLCountInterns - 1
            INSERT INTO [dbo].[LeaveBalance]
            (
               [UserId]
              ,[LeaveTypeId]
              ,[Count]
              ,[CreatedBy]
            )
            SELECT
               @NewUserId
              ,M.[TypeId]
              ,CASE
			  WHEN M.[ShortName]='CL' THEN @CLCountInterns
			  ELSE 0
			  END
              ,@UserId
   FROM [dbo].[LeaveTypeMaster] M WITH (NOLOCK)
         END
         
         ------------------insert into [LeaveBalance] ends------------------

         --DELETE FROM [dbo].[TempUserAddressDetail] WHERE [RegistrationId] = @RegistrationId
         --DELETE FROM [dbo].[TempUserRegistration] WHERE [RegistrationId] = @RegistrationId
		  
      INSERT INTO #MappingInfo(IsSuccess, UserId)
	  SELECT 1 AS IsSuccess,@NewUserId AS [UserId]

		 SELECT  IsSuccess  AS [IsSuccess], [UserId] AS [UserId] FROM #MappingInfo    
      COMMIT TRANSACTION;
          
   END TRY
   BEGIN CATCH
         ROLLBACK TRANSACTION;

         DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))

         EXEC [spInsertErrorLog]
	         @ModuleName = 'UserManagement'
            ,@Source = 'spSaveNewUser'
            ,@ErrorMessage = @ErrorMessage
            ,@ErrorType = 'SP'
            ,@ReportedByUserId = @UserId        

         	 
      INSERT INTO #MappingInfo(IsSuccess, UserId)
	  SELECT 0 AS IsSuccess,0 AS [UserId]


		 SELECT  IsSuccess  AS [IsSuccess], [UserId] AS [UserId] FROM #MappingInfo    
      END CATCH 
END
GO
---------------for inserting in timesheet excluded user---------------
INSERT INTO TimesheetExcludedUser (UserId,IsActive,CreatedBy)
SELECT u.userid,1,1 
FROM vwactiveusers u
WHERE userid NOT IN (SELECT userid FROM [vwEligibleUsersToFillTimesheet])
AND u.ReportingManagerName NOT IN (
'Satender Singh',
'Lovish Sanghvi',
'Prashank Chaudhary',
'Vishal Sachdeva'
)
 AND u.IsIntern=0
ORDER BY u.EmployeeName



