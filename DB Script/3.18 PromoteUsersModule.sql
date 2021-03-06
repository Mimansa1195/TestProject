
GO
/****** Object:  StoredProcedure [dbo].[Proc_PromoteUsers]    Script Date: 14-08-2018 16:59:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_PromoteUsers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_PromoteUsers]
GO
/****** Object:  StoredProcedure [dbo].[Proc_FetchLeaveDetailsForPromotion]    Script Date: 14-08-2018 16:59:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_FetchLeaveDetailsForPromotion]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_FetchLeaveDetailsForPromotion]
GO
/****** Object:  StoredProcedure [dbo].[Proc_DetailsOfActiveEmployees]    Script Date: 14-08-2018 16:59:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DetailsOfActiveEmployees]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DetailsOfActiveEmployees]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__UserPromo__UserI__7E994857]') AND parent_object_id = OBJECT_ID(N'[dbo].[UserPromotionHistory]'))
ALTER TABLE [dbo].[UserPromotionHistory] DROP CONSTRAINT [FK__UserPromo__UserI__7E994857]
GO
/****** Object:  Table [dbo].[UserPromotionHistory]    Script Date: 14-08-2018 16:59:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserPromotionHistory]') AND type in (N'U'))
DROP TABLE [dbo].[UserPromotionHistory]
GO
/****** Object:  Table [dbo].[UserPromotionHistory]    Script Date: 14-08-2018 16:59:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserPromotionHistory]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[UserPromotionHistory](
	[UserPromotionHistoryId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[EmployeeName] [varchar](500) NOT NULL,
	[OldDesignation] [varchar](500) NOT NULL,
	[NewDesignation] [varchar](500) NOT NULL,
	[PromotionDate] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL DEFAULT (getdate()),
	[LastModifiedBy] [int] NULL,
	[LastModifiedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[UserPromotionHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__UserPromo__UserI__7E994857]') AND parent_object_id = OBJECT_ID(N'[dbo].[UserPromotionHistory]'))
ALTER TABLE [dbo].[UserPromotionHistory]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([UserId])
GO
/****** Object:  StoredProcedure [dbo].[Proc_DetailsOfActiveEmployees]    Script Date: 14-08-2018 16:59:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DetailsOfActiveEmployees]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_DetailsOfActiveEmployees] AS' 
END
GO
/***
   Created Date      :     2018-08-07
   Created By        :     Mimansa Agrawal
   Purpose           :     This stored proc is used to fetch all employees with designation details
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   --EXEC Proc_DetailsOfActiveEmployees
***/
ALTER PROCEDURE [dbo].[Proc_DetailsOfActiveEmployees]
AS
BEGIN
SELECT 
	U.[UserId],LTRIM(RTRIM(REPLACE(REPLACE(REPLACE((U.[FirstName] + ' ' + U.[MiddleName] + ' ' + U.[LastName]), ' ', '{}'), '}{',''), '{}', ' '))) AS [EmployeeName]
	,U.[EmployeeId],LTRIM(RTRIM(REPLACE(REPLACE(REPLACE((UDT.[FirstName] + ' ' + UDT.[MiddleName] + ' ' + UDT.[LastName]), ' ', '{}'), '}{',''), '{}', ' '))) AS [ManagerName]
	,DG.[DesignationGroupId],D.[DesignationName],T.[TeamName],DE.[DepartmentName],U.[JoiningDate],D.[IsIntern]
FROM [dbo].[UserDetail] U 
INNER JOIN [dbo].[UserDetail] UDT ON UDT.[UserId] = U.[ReportTo]
INNER JOIN [dbo].[Designation] D ON D.[DesignationId] = U.[DesignationId]
INNER JOIN [dbo].[DesignationGroup] DG ON DG.[DesignationGroupId]=D.[DesignationGroupId]
INNER JOIN [dbo].[UserTeamMapping] UT ON UT.[UserId] = U.[UserId]
INNER JOIN [dbo].[Team] T ON T.[TeamId] = UT.[TeamId]
INNER JOIN [dbo].[Department] DE ON DE.[DepartmentId] = T.[DepartmentId]
WHERE U.[TerminateDate] IS NULL
ORDER BY EmployeeName
END





GO
/****** Object:  StoredProcedure [dbo].[Proc_FetchLeaveDetailsForPromotion]    Script Date: 14-08-2018 16:59:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_FetchLeaveDetailsForPromotion]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_FetchLeaveDetailsForPromotion] AS' 
END
GO
/***
   Created Date      :     2015-12-24
   Created By        :     Mimansa Agrawal
   Purpose           :     This stored procedure return leave balance before and after promotion based on userId
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   EXEC [dbo].[Proc_FetchLeaveDetailsForPromotion] 
   @UserId = 84
  ,@NewDesignationId=5
  ,@PromotionDate='08/13/2018'
***/
--DROP PROCEDURE [dbo].[Proc_FetchLeaveDetailsForPromotion]
ALTER PROCEDURE [dbo].[Proc_FetchLeaveDetailsForPromotion]
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

	DECLARE @CLCount INT,@PLCount INT,@5CLOY INT,@NewCLCount INT,@NewPLCount INT,@OldIsIntern BIT,@NewIsIntern BIT
	SET @CLCount=(SELECT [Count] FROM [dbo].[LeaveBalance] WHERE [UserId]=@UserId AND [LeaveTypeId]=1)
	SET @PLCount=(SELECT [Count] FROM [dbo].[LeaveBalance] WHERE [UserId]=@UserId AND [LeaveTypeId]=2)
	SET @5CLOY=(SELECT [Count] FROM [dbo].[LeaveBalance] WHERE [UserId]=@UserId AND [LeaveTypeId]=8)
	SET @OldIsIntern=(SELECT [IsIntern] FROM [dbo].[Designation] WHERE [DesignationId]=(SELECT [DesignationId] FROM [dbo].[UserDetail] WHERE [UserId]=@UserId))
	SET @NewIsIntern=(SELECT [IsIntern] FROM [dbo].[Designation] WHERE [DesignationId]=@NewDesignationId)

	IF(@OldIsIntern=1 AND @NewIsIntern=0) --leave details for interns to non interns position
    BEGIN
            DECLARE @PDate int = (SELECT DATEPART(dd, @PromotionDate))
            DECLARE @PMonth int = (SELECT DATEPART(mm, @PromotionDate)) 
			SET @NewPLCount=CASE
							WHEN @PDate > 15 THEN  0
							ELSE 1   
							END     
            SET @NewCLCount = CASE
                              WHEN @PMonth BETWEEN 4 AND 12 THEN (16 - @PMonth)
                              ELSE (4 - @PMonth)
                            END
            IF(@PDate > 10)
               SET @NewCLCount = @NewCLCount - 1
           
		INSERT INTO #TempLeaveCount
		([LeaveType] ,[LeaveCount])
		VALUES('OldCL',@CLCount),('OldPL',@PLCount),('Old5CLOY',@5CLOY),('NewCL',@NewCLCount),('NewPL',@NewPLCount),('New5CLOY',1) 
	END
	ELSE
	BEGIN

		INSERT INTO #TempLeaveCount
		([LeaveType] ,[LeaveCount])
		VALUES('OldCL',@CLCount),('OldPL',@PLCount),('Old5CLOY',@5CLOY),('NewCL',@CLCount),('NewPL',@PLCount),('New5CLOY',@5CLOY) 
	END

	SELECT [LeaveType],[LeaveCount] 
	FROM #TempLeaveCount
END
GO
/****** Object:  StoredProcedure [dbo].[Proc_PromoteUsers]    Script Date: 14-08-2018 16:59:40 ******/
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
		,@OldDesignation='Technical Trainee'
		,@NewDesignation='GET'
        ,@PromotionDate='2018-08-08'
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
@PromotionDate DATETIME,
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
	[LastModifiedBy]=@UserId,
	[LastModifiedDate]=GETDATE()
	WHERE [UserId]=@EmployeeId
----------- insert into user promotion history table----------
	INSERT INTO [dbo].[UserPromotionHistory]
	([UserId],[EmployeeName],[OldDesignation],[NewDesignation],[PromotionDate],[CreatedBy])
	VALUES
	(@EmployeeId,@EmpName,@OldDesignation,@NewDesignation,@PromotionDate,@UserId)
	SET @Success=2 ------------interns promoted successfully
END
ELSE
BEGIN
------------update user detail for rest cases-----------
	UPDATE [dbo].[UserDetail]
	SET [DesignationId]=@NewDesignationId,
	[LastModifiedBy]=@UserId,
	[LastModifiedDate]=GETDATE()
	WHERE [UserId]=@EmployeeId
----------- insert into user promotion history table----------
	INSERT INTO [dbo].[UserPromotionHistory]
	([UserId],[EmployeeName],[OldDesignation],[NewDesignation],[PromotionDate],[CreatedBy])
	VALUES
	(@EmployeeId,@EmpName,@OldDesignation,@NewDesignation,@PromotionDate,@UserId)
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
