GO
/****** Object:  StoredProcedure [dbo].[spUpdateLeaveBalanceAndLeaveStatus]    Script Date: 10-08-2018 13:21:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spUpdateLeaveBalanceAndLeaveStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spUpdateLeaveBalanceAndLeaveStatus]
GO
/****** Object:  StoredProcedure [dbo].[spSaveNewUser]    Script Date: 10-08-2018 13:21:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spSaveNewUser]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spSaveNewUser]
GO
/****** Object:  StoredProcedure [dbo].[spGetAvailableLeaveCombination]    Script Date: 10-08-2018 13:21:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetAvailableLeaveCombination]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetAvailableLeaveCombination]
GO
/****** Object:  StoredProcedure [dbo].[spFetchPendingActivitiesForManagerApproval]    Script Date: 10-08-2018 13:21:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spFetchPendingActivitiesForManagerApproval]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spFetchPendingActivitiesForManagerApproval]
GO
/****** Object:  StoredProcedure [dbo].[Proc_PromoteUsers]    Script Date: 10-08-2018 13:21:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_PromoteUsers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_PromoteUsers]
GO
/****** Object:  StoredProcedure [dbo].[Proc_DetailsOfActiveEmployees]    Script Date: 10-08-2018 13:21:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DetailsOfActiveEmployees]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DetailsOfActiveEmployees]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__UserPromo__UserI__7E994857]') AND parent_object_id = OBJECT_ID(N'[dbo].[UserPromotionHistory]'))
ALTER TABLE [dbo].[UserPromotionHistory] DROP CONSTRAINT [FK__UserPromo__UserI__7E994857]
GO
/****** Object:  Table [dbo].[UserPromotionHistory]    Script Date: 10-08-2018 13:21:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserPromotionHistory]') AND type in (N'U'))
DROP TABLE [dbo].[UserPromotionHistory]
GO
/****** Object:  Table [dbo].[UserPromotionHistory]    Script Date: 10-08-2018 13:21:45 ******/
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
/****** Object:  StoredProcedure [dbo].[Proc_DetailsOfActiveEmployees]    Script Date: 10-08-2018 13:21:45 ******/
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
/****** Object:  StoredProcedure [dbo].[Proc_PromoteUsers]    Script Date: 10-08-2018 13:21:45 ******/
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
DECLARE @NewDesignationId INT,@OldDesignationId INT,@EmployeeName VARCHAR(100)
SET @OldDesignationId=(SELECT [DesignationId] FROM [dbo].[Designation] WHERE [DesignationName]=@OldDesignation) 
SET @NewDesignationId=(SELECT [DesignationId] FROM [dbo].[Designation] WHERE [DesignationName]=@NewDesignation)
IF(@NewDesignationId=@OldDesignationId)
BEGIN
SET @Success=2      ------------------old and new designations can't be same
END
-------------update user detail for interns------------------
ELSE 
BEGIN
--IF(@IsIntern=1)
--BEGIN
--UPDATE U
--SET U.[IsFresher]=0
--FROM [dbo].[UserDetail] U
--INNER JOIN [dbo].[Designation] D ON D.DesignationId=U.[DesignationId]
--WHERE U.[UserId]=@EmployeeId AND D.[DesignationName]=@OldDesignation
--END
------------update user detail for all-----------
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
SET @Success=1 -----------------------user promoted successfully
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
/****** Object:  StoredProcedure [dbo].[spFetchPendingActivitiesForManagerApproval]    Script Date: 10-08-2018 13:21:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spFetchPendingActivitiesForManagerApproval]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spFetchPendingActivitiesForManagerApproval] AS' 
END
GO
/***
   Created Date      :     2016-04-26
   Created By        :     Narender Singh
   Purpose           :     This stored procedure retrives all requests pending for approval for a Manager
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   ------------------------------------------------------------------------
   --- Test Case 1
         EXEC [dbo].[spFetchPendingActivitiesForManagerApproval] @UserId =24
***/
ALTER PROCEDURE [dbo].[spFetchPendingActivitiesForManagerApproval]   
   @UserId [int]
AS
BEGIN
   SET NOCOUNT ON;
   IF 1 = 2 BEGIN
    SELECT CAST(NULL AS [varchar](500))  AS [PendingActivities]        
    WHERE 1 = 2  
   END
   IF OBJECT_ID('tempdb..#ReportingEmployee') IS NOT NULL
	        DROP TABLE #ReportingEmployee
  CREATE TABLE #ReportingEmployee
   (
      [UserId] [int] NOT NULL
     ,[UserName] [varchar](150) NOT NULL
     ,[Type] [bit] NOT NULL
   )
   IF OBJECT_ID('tempdb..#PendingActivity') IS NOT NULL
	        DROP TABLE #PendingActivity
  CREATE TABLE #PendingActivity
   (
   [Type] [varchar] (5000) NOT NULL,
   [PendingOfUser] [varchar] (200) NOT NULL,
   [PendingOnEmail] [varchar] (200) NOT NULL,
   [PendingForUser] [varchar] (200) NOT NULL,
   [Activity] [varchar](5000) NULL
   )

   -- Getting report to employees
  INSERT INTO 
      #ReportingEmployee
      (
         [UserId]
        ,[UserName]
        ,[Type]
      )
   SELECT
      U.[UserId]
     ,U.[FirstName] + ' ' + U.[LastName]
     ,0
   FROM
      [dbo].[UserDetail] U WITH (NOLOCK)
   WHERE
      U.[ReportTo] = @UserId
      --AND U.[IsDeleted] = 0
      AND U.[TerminateDate] IS NULL

   -- Getting super report to employees
  INSERT INTO 
      #ReportingEmployee
      (
         [UserId]
        ,[UserName]
        ,[Type]
      )
   SELECT
      U.[UserId]
     ,U.[FirstName] + ' ' + U.[LastName]
     ,1
   FROM
      [dbo].[UserDetail] U WITH (NOLOCK)
      INNER JOIN [dbo].[UserDetail] M WITH (NOLOCK) ON U.[ReportTo] = M.[UserId]
   WHERE
      M.[ReportTo] = @UserId
      AND U.[TerminateDate] IS NULL
   -- Inserting Employees to whom projects are not allocated
   
  INSERT INTO #PendingActivity
   (
      [Type],[PendingOfUser] ,[PendingOnEmail] ,[PendingForUser] ,[Activity]
   )
   SELECT
      'PendingTeamAllocation' ,M.[EmployeeName],UD.[EmailId],U.[EmailId],NULL
   FROM
      #ReportingEmployee T
         INNER JOIN [dbo].[vwUserTeamMapping] M WITH (NOLOCK) ON M.[UserId] = T.[UserId]
		 INNER JOIN [dbo].[UserDetail] U WITH (NOLOCK) ON U.[UserId]=T.[UserId]
		 INNER JOIN [dbo].[UserDetail] UD WITH (NOLOCK) ON UD.[UserId]=U.[ReportTo]
         AND M.[TeamName] = 'Not Assigned' AND @UserId NOT IN (14,58)
   INSERT INTO 
      #PendingActivity
      (
          [Type],[PendingOfUser] ,[PendingOnEmail] ,[PendingForUser] ,[Activity]
      )
   SELECT 
      'PendingProjectAllocation',CAST(E.[UserName]  AS VARCHAR(100)),UD.[EmailId],U.[EmailId],NULL
   FROM  
      #ReportingEmployee E
	  INNER JOIN [dbo].[UserDetail] U WITH (NOLOCK) ON U.[UserId]=E.[UserId]
	  INNER JOIN [dbo].[UserDetail] UD WITH (NOLOCK) ON UD.[UserId]=U.[ReportTo]
   WHERE 
      NOT EXISTS 
      (
         SELECT 1 FROM [dbo].[ProjectTeamMembers] G WITH (NOLOCK)
         WHERE G.[UserId] = E.[UserId]
      )
   AND E.[Type] = 0
   AND @UserId NOT IN (14,58)
 -- Inserting Timesheets pending for approval
 INSERT INTO 
      #PendingActivity
      (
         [Type],[PendingOfUser] ,[PendingOnEmail] ,[PendingForUser] ,[Activity]
      )
   SELECT 
      'PendingTimeSheet',CAST(E.[UserName]  AS VARCHAR(100)),UD.[EmailId],U.[EmailId],CAST(T.[WeekNo] AS VARCHAR(8))+'|'+( CONVERT([varchar](10), T.[StartDate], 101) + ' - ' + CONVERT([varchar](10), T.[EndDate], 101)) 
   FROM  
      [dbo].[TimeSheet] T WITH (NOLOCK)
	  INNER JOIN #ReportingEmployee E  ON T.[CreatedBy] = E.[UserId]
	  INNER JOIN [dbo].[UserDetail] U WITH (NOLOCK) ON U.[UserId]=E.[UserId]
	  INNER JOIN [dbo].[UserDetail] UD WITH (NOLOCK) ON UD.[UserId]=U.[ReportTo]
    WHERE
      T.[Status] = 1 AND E.[Type] = 0 AND (SELECT CAST(T.[CreatedDate] AS DATE))<=(SELECT CONVERT(date,DATEADD(DAY,-8,GETDATE())))
	  
    -- Inserting Leaves pending for approval
  INSERT INTO
      #PendingActivity  
      (
          [Type],[PendingOfUser] ,[PendingOnEmail] ,[PendingForUser] ,[Activity]
      )
   SELECT
     'PendingLeaves',CAST(E.[UserName]  AS VARCHAR(100)),UD.[EmailId],U.[EmailId],CONVERT([varchar](10), D.[Date], 101) + ' - ' + CONVERT([varchar](10), DM.[Date], 101) + '|' + CAST(L.[LeaveCombination] AS VARCHAR(500)) COLLATE SQL_Latin1_General_CP1_CI_AS + '|' +  CAST(L.[Reason] AS VARCHAR(500)) COLLATE SQL_Latin1_General_CP1_CI_AS + '|'  + CAST(L.[LeaveRequestApplicationId]  AS VARCHAR(20)) + '-' +  CAST(L.[ApproverId]  AS VARCHAR(20)) + '-PV|' + CAST(L.[LeaveRequestApplicationId]  AS VARCHAR(20)) + '-' +  CAST(L.[ApproverId]  AS VARCHAR(20)) + '-RJ'
      FROM
      [dbo].[LeaveRequestApplication] L WITH (NOLOCK)
         INNER JOIN
         (
            SELECT LD.[LeaveRequestApplicationId]  ,MAX(LD.[LeaveRequestApplicationDetailId])            AS [LeaveRequestApplicationDetailId]
               FROM
                  [dbo].[LeaveRequestApplicationDetail] LD WITH (NOLOCK)
                     INNER JOIN [dbo].[LeaveTypeMaster] LT WITH (NOLOCK) ON LT.[TypeId] = LD.[LeaveTypeId]
               WHERE LT.[ShortName] != 'WFH'
               GROUP BY LD.[LeaveRequestApplicationId]
         ) LAD ON LAD.[LeaveRequestApplicationId] = L.[LeaveRequestApplicationId]
         INNER JOIN [dbo].[DateMaster] D WITH (NOLOCK) ON D.[DateId] = L.[FromDateId]
         INNER JOIN [dbo].[DateMaster] DM WITH (NOLOCK) ON DM.[DateId] = L.[TillDateId]
         INNER JOIN [dbo].[LeaveStatusMaster] S WITH (NOLOCK) ON S.[StatusId] = L.[StatusId]
         INNER JOIN #ReportingEmployee E ON L.[UserId] = E.[UserId]
		 INNER JOIN [dbo].[UserDetail] U ON U.[UserId]=L.[UserId]
		 INNER JOIN [dbo].[UserDetail] UD ON UD.[UserId]=L.[ApproverId]
   WHERE
      S.[StatusCode] IN ('PA','PV') AND L.[ApproverId] = @UserId
      AND E.[Type] = 0 AND (SELECT CAST(L.[CreatedDate] AS DATE))<=(SELECT CONVERT(date,DATEADD(DAY,-8,GETDATE())))
-- Inserting work from home pending for approval
  INSERT INTO
      #PendingActivity  
      (
         [Type],[PendingOfUser] ,[PendingOnEmail] ,[PendingForUser] ,[Activity]
      )
   SELECT
      'PendingWFH', CAST(E.[UserName]  AS VARCHAR(100)),UD.[EmailId],U.[EmailId],CONVERT([varchar](10), D.[Date], 101) + '|' + CAST(L.[Reason] AS VARCHAR(500)) COLLATE SQL_Latin1_General_CP1_CI_AS + + '|' + CAST(L.[LeaveRequestApplicationId]  AS VARCHAR(20)) + '-' +  CAST(L.[ApproverId]  AS VARCHAR(20)) + '-PV|' + CAST(L.[LeaveRequestApplicationId]  AS VARCHAR(20)) + '-' +  CAST(L.[ApproverId]  AS VARCHAR(20)) + '-RJ'
         FROM
      [dbo].[LeaveRequestApplication] L WITH (NOLOCK)
         INNER JOIN [dbo].[LeaveRequestApplicationDetail] LD WITH (NOLOCK) ON LD.[LeaveRequestApplicationId] = L.[LeaveRequestApplicationId]
         INNER JOIN [dbo].[LeaveTypeMaster] M WITH (NOLOCK) ON M.[TypeId] = LD.[LeaveTypeId]
         INNER JOIN [dbo].[DateMaster] D WITH (NOLOCK) ON D.[DateId] = L.[FromDateId]
         INNER JOIN [dbo].[LeaveStatusMaster] S WITH (NOLOCK) ON S.[StatusId] = L.[StatusId]
         INNER JOIN #ReportingEmployee E ON L.[UserId] = E.[UserId]
		 INNER JOIN [dbo].[UserDetail] U ON U.[UserId]= L.[UserId]
		 INNER JOIN [dbo].[UserDetail] UD ON UD.[UserId]=U.[ReportTo]
   WHERE
      S.[StatusCode] IN ('PA','PV') AND M.[ShortName] = 'WFH' AND L.[ApproverId] = @UserId AND E.[Type] = 0
 AND (SELECT CAST(L.[CreatedDate] AS DATE))<=(SELECT CONVERT(date,DATEADD(DAY,-8,GETDATE())))
   -- Inserting comp-off request pending for approval
  INSERT INTO
      #PendingActivity  
      (
         [Type],[PendingOfUser] ,[PendingOnEmail] ,[PendingForUser] ,[Activity]
      )
   SELECT
      'PendingCompoff',CAST(E.[UserName]  AS VARCHAR(100)),UD.[EmailId],U.[EmailId],CONVERT([varchar](10), D.[Date], 101) + '|' + CAST(C.[NoOfDays]  AS VARCHAR(8)) + '|' + CAST(C.[Reason] AS VARCHAR(500)) COLLATE SQL_Latin1_General_CP1_CI_AS 
   FROM
      [dbo].[RequestCompOff] C WITH (NOLOCK) INNER JOIN [dbo].[DateMaster] D ON D.[DateId] = C.[DateId]
         INNER JOIN [dbo].[LeaveStatusMaster] S WITH (NOLOCK) ON C.[StatusId] = S.[StatusId]
         INNER JOIN #ReportingEmployee E ON E.[UserId] = C.[CreatedBy]
		 INNER JOIN [dbo].[UserDetail] U ON U.[UserId]=C.[CreatedBy]
		 INNER JOIN [dbo].[UserDetail] UD ON UD.[UserId]=U.[ReportTo]
   WHERE
      S.[StatusCode] IN ('PA','PV') AND C.[ApproverId] = @UserId
      AND E.[Type] = 0 AND (SELECT CAST(C.[CreatedDate] AS DATE))<=(SELECT CONVERT(date,DATEADD(DAY,-8,GETDATE())))
 -- Inserting data change request (leave) pending for approval
 INSERT INTO
      #PendingActivity  
      (
         [Type],[PendingOfUser] ,[PendingOnEmail] ,[PendingForUser] ,[Activity]
      )
   SELECT
      'PendingDataChangeLeave',CAST(E.[UserName]  AS VARCHAR(100)),UD.[EmailId],U.[EmailId],CONVERT([varchar](10), D.[Date], 101) + ' - ' +  CONVERT([varchar](10), DM.[Date], 101) + '|' + CAST(A.[Reason] AS VARCHAR(500)) COLLATE SQL_Latin1_General_CP1_CI_AS  + '|' + CAST(L.[LeaveCombination] AS VARCHAR(500)) COLLATE SQL_Latin1_General_CP1_CI_AS
   FROM
      [dbo].[AttendanceDataChangeRequestApplication] A WITH (NOLOCK)
         INNER JOIN [dbo].[AttendanceDataChangeRequestCategory] C WITH (NOLOCK) ON A.[RequestCategoryId] = C.[CategoryId]
         INNER JOIN [dbo].[LeaveRequestApplication] L ON L.[LeaveRequestApplicationId] = A.[RequestApplicationId]
         INNER JOIN [dbo].[DateMaster] D ON D.[DateId] = L.[FromDateId]
         INNER JOIN [dbo].[DateMaster] DM ON DM.[DateId] = L.[TillDateId]
         INNER JOIN [dbo].[LeaveStatusMaster] S WITH (NOLOCK) ON A.[StatusId] = S.[StatusId]
         INNER JOIN #ReportingEmployee E ON E.[UserId] = A.[CreatedBy]
		 INNER JOIN [dbo].[UserDetail] U ON U.[UserId]=E.[UserId]
		 INNER JOIN [dbo].[UserDetail] UD ON UD.[UserId]=U.[ReportTo]
   WHERE
      S.[StatusCode] IN ('PA','PV') AND A.[ApproverId] = @UserId
      AND C.[CategoryCode] = 'Leave'
      AND E.[Type] = 0 AND (SELECT CAST(A.[CreatedDate] AS DATE))<=(SELECT CONVERT(date,DATEADD(DAY,-8,GETDATE())))
   -----Inserting LNSA pending for approval
INSERT INTO
#PendingActivity
([Type],[PendingOfUser] ,[PendingOnEmail] ,[PendingForUser] ,[Activity])
SELECT
	'PendingLNSA' AS [Type],CAST(E.[UserName] AS VARCHAR(100)) AS [PendingOfUser],UD.[EmailId] AS [PendingOnEmail],U.[EmailId] AS [PendingForUser] ,CONVERT([varchar](10),D.[Date],101)+' - '+ CONVERT([varchar](10), DM.[Date], 101) + '|' + CAST(R.[Reason] AS VARCHAR(500)) COLLATE SQL_Latin1_General_CP1_CI_AS AS [Activity]
FROM
	[dbo].[RequestLnsa] R WITH (NOLOCK)
	INNER JOIN [dbo].[DateMaster] D ON D.[DateId] = R.[FromDateId]
    INNER JOIN [dbo].[DateMaster] DM ON DM.[DateId] = R.[TillDateId]
	INNER JOIN #ReportingEmployee E ON E.[UserId] = R.[CreatedBy]
	INNER JOIN [dbo].[UserDetail] U ON U.[UserId]=R.[CreatedBy]
	INNER JOIN [dbo].[UserDetail] UD ON UD.[UserId]=U.[ReportTo]
	WHERE
      U.[ReportTo] = @UserId
AND R.[Status]=0 AND E.[Type]=0 AND (SELECT CAST(R.[CreatedDate] AS DATE))<=(SELECT CONVERT(date,DATEADD(DAY,-8,GETDATE())))
----------Inserting pending assets for approval
--INSERT INTO
--#PendingActivity
--([Type],[PendingOfUser] ,[PendingOnEmail] ,[PendingForUser] ,[Activity])
-- SELECT
--	'PendingAssets|',CAST(E.[UserName] AS VARCHAR(100)),UD.[EmailId],U.[EmailId],CONVERT([varchar](10),D.[Date],101)+' - '+ CONVERT([varchar](10), DM.[Date], 101) + '|' + CAST(A.[Reason] AS VARCHAR(500)) COLLATE SQL_Latin1_General_CP1_CI_AS
--FROM
--	[dbo].[AssetRequest] A WITH (NOLOCK)
--	INNER JOIN [dbo].[DateMaster] D ON D.[DateId] = A.[RequiredFromDateId]
--    INNER JOIN [dbo].[DateMaster] DM ON DM.[DateId] = A.[RequiredTillDateId]
--	INNER JOIN #ReportingEmployee E ON E.[UserId] = A.[CreatedBy]
--	INNER JOIN [dbo].[UserDetail] U ON U.[UserId]=A.[CreatedBy]
--  INNER JOIN [dbo].[UserDetail] UD ON UD.[UserId]=U.[ReportTo]
--	WHERE
--      U.[ReportTo] = @UserId
--AND A.[StatusId]=1 AND E.[Type]=0   
 -------------------Inserting pending goals for approval
INSERT INTO
#PendingActivity
([Type],[PendingOfUser] ,[PendingOnEmail] ,[PendingForUser] ,[Activity]) 
  SELECT
	'PendingGoals',CAST(E.[UserName] AS VARCHAR(100)),UD.[EmailId],U.[EmailId],( CONVERT([varchar](10),D.[Date],101)+' - '+ CONVERT([varchar](10), DM.[Date], 101) + '|' + CAST(G.[Goal] AS VARCHAR(500)) COLLATE SQL_Latin1_General_CP1_CI_AS)
FROM
	[dbo].[UserGoal] G WITH (NOLOCK)
	INNER JOIN [dbo].[DateMaster] D ON D.[DateId] = G.[StartDateId]
    INNER JOIN [dbo].[DateMaster] DM ON DM.[DateId] = G.[EndDateId]
	INNER JOIN #ReportingEmployee E ON E.[UserId] = G.[CreatedBy]
	INNER JOIN [dbo].[UserDetail] U ON U.[UserId]=G.[CreatedBy]
	INNER JOIN [dbo].[UserDetail] UD ON UD.[UserId]=U.[ReportTo]
	WHERE
      U.[ReportTo] = @UserId
AND G.[GoalStatusId]=2 AND E.[Type]=0  AND (SELECT CAST(G.[CreatedDate] AS DATE))<=(SELECT CONVERT(date,DATEADD(DAY,-8,GETDATE())))
 -----------------Inserting pending users for verification
INSERT INTO
#PendingActivity
([Type],[PendingOfUser] ,[PendingOnEmail] ,[PendingForUser] ,[Activity])
SELECT
	'PendingNewUsers',CAST(T.[UserName] AS VARCHAR(100)),UD.[EmailId],U.[EmailId],(CONVERT([varchar](10),T.[GuidExpiryDate], 101))
FROM
	[dbo].[TempUserRegistration] T WITH (NOLOCK)
	
	--INNER JOIN #ReportingEmployee E ON E.[UserId] =	T.[CreatedBy]
	INNER JOIN [dbo].[UserDetail] U ON U.[UserId]=T.[CreatedBy]
	INNER JOIN [dbo].[UserDetail] UD ON UD.[UserId]=U.[ReportTo]
	WHERE
    @UserId IN (SELECT UserId FROM UserDetail U
	INNER JOIN Designation D ON D.DesignationId=U.DesignationId
    WHERE DesignationGroupId=5 AND IsIntern=0 AND TerminateDate IS NULL)
	 AND T.[IsVerified]=0 AND (SELECT CAST(T.[CreatedDate] AS DATE))<=(SELECT CONVERT(date,DATEADD(DAY,-3,GETDATE())))
-------------------Inserting pending profile verification
INSERT INTO
#PendingActivity
([Type],[PendingOfUser] ,[PendingOnEmail] ,[PendingForUser] ,[Activity])
SELECT
	'PendingProfiles',CAST(U.[FirstName]+' '+U.[LastName] AS VARCHAR(100)),UD.[EmailId],U.[EmailId],NULL
FROM
	[dbo].[ChangeExtnRequest] P WITH (NOLOCK)
	INNER JOIN [dbo].[UserDetail] U ON U.[UserId]=P.[CreatedById]
	--INNER JOIN [dbo].[UserDetail] U ON U.[UserId]=G.[CreatedBy]
	INNER JOIN [dbo].[UserDetail] UD ON UD.[UserId]=U.[ReportTo] 
	WHERE
    @UserId IN (SELECT UserId FROM UserDetail U
	INNER JOIN Designation D ON D.DesignationId=U.DesignationId
    WHERE DesignationGroupId=5 AND IsIntern=0 AND TerminateDate IS NULL)
	 AND P.[IsActionPerformed]=0 AND (SELECT CAST(P.[CreatedDate] AS DATE))<=(SELECT CONVERT(date,DATEADD(DAY,-4,GETDATE())))
 SELECT * FROM #PendingActivity
   ORDER BY [Activity]
END











GO
/****** Object:  StoredProcedure [dbo].[spGetAvailableLeaveCombination]    Script Date: 10-08-2018 13:21:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetAvailableLeaveCombination]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGetAvailableLeaveCombination] AS' 
END
GO
/***
   Created Date      :     2015-05-26
   Created By        :     Nishant Srivastava
   Purpose           :     This stored procedure give all the possible combination of leaves according to user leave balance .
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        : 3 LWP3 LWP
   --------------------------------------------------------------------------
   --- Test Case 1
         EXEC [dbo].[spGetAvailableLeaveCombination]
            @Userid = 1108
           ,@NoOfWorkingDays = 4
		   ,@LeaveApplicationId = 0
		   
/**Declare @Userid int ,@NoOfWorkingDays float ,@LeaveTypeId int ,@i int, @CL float ,@PL int,@compOf int ,@IsSpecial bit
SET @Userid = 33
SET @NoOfWorkingDays =2
UPDATE LeaveBalance_Dummy
        SET NoOfLeave = 2
WHERE Userid = 33 And LeaveTypeId =4 **/
***/
ALTER PROCEDURE [dbo].[spGetAvailableLeaveCombination] 
    @Userid INT
   ,@NoOfWorkingDays FLOAT  
	,@LeaveApplicationId bigint
   AS
      BEGIN
      Declare @LeaveTypeId int ,@i int, @CL float ,@PL int,@compOf int ,@IsSpecial bit, @leaveappliedCount float,@leavetype int
       --supplying a data contract
         IF 1 = 2 
            BEGIN
                   SELECT
                       CAST(NULL AS [Varchar] (50)) AS [LeaveCombination]                       				   
                   WHERE
                       1 = 2
            END   
	
	-- To add leave count of the leave which is being cancelled when cancel and applying leave	
		SELECT @leaveappliedCount = LD.[Count], @Leavetype = LD.[LeaveTypeId]
		FROM [dbo].[LeaveRequestApplicationDetail] LD WITH (NOLOCK)
				INNER JOIN [dbo].[LeaveTypeMaster] LS WITH (NOLOCK) ON LD.[LeaveTypeId] = LS.[TypeId]
		WHERE LD.[LeaveRequestApplicationId] = @LeaveApplicationId
		AND LS.[ShortName] != 'LWP'
              
         CREATE TABLE #Temp
         (
         [Userid] [int] NOT NULL,
         [LeaveTypeID] [int] NOT NULL,
         [LeaveCombination] [Varchar](50),
         [IsSpecial] [bit] 
         ) 

         SELECT  @IsSpecial = COUNT(*) 
         FROM [dbo].[LeaveBalance] WITH (NOLOCK) 
         WHERE [Userid] = @Userid AND [LeaveTypeId] =8  AND [Count] =1 --and [NoOfLeave] >=1
         
			IF (@Leavetype = 1 AND @leaveappliedCount > 2)
				SET @IsSpecial = 1

         --SELECT @IsSpecial AS IsSpecial

         SET @i = 1
         WHILE @i <= 3
         
         BEGIN
            BEGIN
                  IF (@i =1)
                     SET @LeaveTypeId =1 
                  ELSE IF (@i =2)
                     Set @LeaveTypeId =2
                  ELSE IF (@i =3)
                     Set @LeaveTypeId =4               
            END

         SET @i =  @i + 1 
     
         SELECT @CL = [Count] FROM [dbo].[LeaveBalance] WITH (NOLOCK) WHERE Userid= @Userid AND LeaveTypeId= 1
         SELECT @PL = [Count] FROM [dbo].[LeaveBalance] WITH (NOLOCK) WHERE Userid= @Userid AND LeaveTypeId= 2
         SELECT @compOf = [Count] FROM [dbo].[LeaveBalance] WITH (NOLOCK) WHERE Userid= @Userid AND LeaveTypeId= 4
         
			IF (@Leavetype = 1)
				SET @CL = @CL + @leaveappliedCount 
			ELSE IF (@Leavetype = 2)
				Set @PL = @PL + @leaveappliedCount
			ELSE IF (@Leavetype =3)
				Set @compOf = @compOf + @leaveappliedCount

             IF (@LeaveTypeId = 1 )
            BEGIN
                     IF (  @IsSpecial = 1 )
                     BEGIN
                         IF( @CL >=2  AND @NoOfWorkingDays <= 2)
                        BEGIN
                              INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                              SELECT  Userid
									  ,LeaveTypeId 
									  ,Convert (varchar(5),@NoOfWorkingDays,0) + ' CL '  AS LeaveCombination
                                    ,@IsSpecial As ISSpecial
                              FROM   [dbo].[LeaveBalance] WITH (NOLOCK) 
                              WHERE   Userid = @Userid and LeaveTypeId= 1
                              PRINT '1.0'
                        END
                         ELSE IF( @CL >=5  AND  @NoOfWorkingDays <= 5 AND @CL >= @NoOfWorkingDays)--  @NoOfWorkingDays <= 5 )
                        BEGIN
                              INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                              SELECT  Userid
                                    ,LeaveTypeId 
                                    ,Convert (varchar(5),@NoOfWorkingDays,0) +' CL '  AS LeaveCombination
                                    ,@IsSpecial As ISSpecial
                              FROM   [dbo].[LeaveBalance] WITH (NOLOCK) 
                              WHERE   Userid = @Userid and LeaveTypeId= 1
                              PRINT '1.2'
                        END
						ELSE IF (@CL >= 5 AND @NoOfWorkingDays >= 5 )
                        BEGIN
                              INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                                 SELECT  Userid
                                       ,LeaveTypeId 
                                       ,'5 CL + ' + Convert (varchar(5),@NoOfWorkingDays - 5,0)  + ' LWP' AS LeaveCombination
                                       ,@IsSpecial As ISSpecial
                                 FROM   [dbo].[LeaveBalance] WITH (NOLOCK) 
                                 WHERE   Userid = @Userid and LeaveTypeId= 1
                                 PRINT '1.3'
                                 ------------------------------------
							
                                 IF(@NoOfWorkingDays <= 10 AND @PL >= (@NoOfWorkingDays - 5))
                                 BEGIN
                                    INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                                    SELECT  Userid
                                          ,LeaveTypeId 
                                          ,'5 CL + ' + Convert (varchar(5),@NoOfWorkingDays - 5,0)  + ' PL' AS LeaveCombination
                                          ,@IsSpecial As ISSpecial
                                    FROM   [dbo].[LeaveBalance] WITH (NOLOCK)
                                   WHERE   Userid = @Userid and LeaveTypeId= 1
                                 END
                                 ------------------------------------
                        END 
                        ELSE IF( @CL <=5  AND @NoOfWorkingDays <= 5 )

                              BEGIN
                                  INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                                  SELECT  Userid
                                          ,LeaveTypeId 
                                          ,CASE
                                                WHEN @NoOfWorkingDays <= @CL THEN  Convert (varchar(5), @NoOfWorkingDays,0) + ' CL'
                                                ELSE Convert (varchar(5), @CL,0) + ' CL + '+ Convert (varchar(5),@NoOfWorkingDays - @CL,0)  + ' LWP'
                                           END                                          
                                          ,@IsSpecial As ISSpecial
                                  FROM   [dbo].[LeaveBalance] WITH (NOLOCK) 
                                  WHERE   Userid = @Userid and LeaveTypeId= 1
                                  PRINT '1.4'
								------------------------------------
								
								  
                                  IF(@PL >= (@NoOfWorkingDays - @CL))
								
                                    BEGIN
                                       INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
       SELECT  Userid
                      ,LeaveTypeId 
                                             ,CASE
                                                WHEN @NoOfWorkingDays <= @CL THEN  Convert (varchar(5), @NoOfWorkingDays,0) + ' CL'
                                                ELSE Convert (varchar(5), @CL,0) + ' CL + ' + Convert (varchar(5),@NoOfWorkingDays - @CL,0)  + ' PL'
                                             END                                                                                       
                                             ,@IsSpecial As ISSpecial
                                       FROM   [dbo].[LeaveBalance] WITH (NOLOCK)
                                       WHERE   Userid = @Userid and LeaveTypeId= 1
                                       PRINT '1.4.1'
                                    END
                                  ------------------------------------
                              END
                             
                          ELSE IF (@CL <= 5 AND @NoOfWorkingDays >= 5 )

                              BEGIN
                                  INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                                     SELECT  Userid
                                             ,LeaveTypeId 
                                             ,Convert (varchar(5), @CL,0) + ' CL + '+ Convert (varchar(5),@NoOfWorkingDays - @CL,0)  + ' LWP' AS LeaveCombination
                                             ,@IsSpecial As ISSpecial
                                     FROM   [dbo].[LeaveBalance] WITH (NOLOCK) 
                                     WHERE   Userid = @Userid and LeaveTypeId= 1
                                     PRINT '1.5'
                                   ------------------------------------
                                       IF(@NoOfWorkingDays <= 10 AND @PL >= (@NoOfWorkingDays - @CL))
                                       BEGIN
                                          INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                                          SELECT  Userid
                                                ,LeaveTypeId 
                                                ,Convert (varchar(5), @CL,0) + ' CL + ' + Convert (varchar(5),@NoOfWorkingDays - 5,0)  + ' PL' AS LeaveCombination
                                                ,@IsSpecial As ISSpecial
                                          FROM   [dbo].[LeaveBalance] WITH (NOLOCK)
                                          WHERE   Userid = @Userid and LeaveTypeId= 1
                                       END
                                   ------------------------------------
                              END
                          ELSE IF (@CL  = 0 AND @NoOfWorkingDays >= 1 )

                              BEGIN
                                  INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                                     SELECT  Userid,LeaveTypeId 
                                             ,Convert (varchar(5),@NoOfWorkingDays,0)  + ' LWP' AS LeaveCombination
                                             ,@IsSpecial As ISSpecial
                                     FROM   [dbo].[LeaveBalance] WITH (NOLOCK) 
                                     WHERE   Userid = @Userid and LeaveTypeId= 1
                                     PRINT '1.6'
                              END
				
                      END  
               ELSE
                     BEGIN
                             
	                         IF (  @CL >= 2 AND  @NoOfWorkingDays > 2 AND @IsSpecial = 0)
                              BEGIN
                                   INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                                  SELECT  Userid
                                          ,LeaveTypeId 
										  ,'2 CL + ' + Convert (varchar(5),@NoOfWorkingDays - 2,0) + ' LWP '   AS LeaveCombination
    ,@IsSpecial As ISSpecial
								 FROM   [dbo].[LeaveBalance] WITH (NOLOCK) 
                                  WHERE   Userid = @Userid and LeaveTypeId= 1
                                  PRINT '1.7 '
                               END
                               ELSE IF ( ( @CL <> 0 and @CL <= 2) AND  @NoOfWorkingDays <= 2 AND @CL < @NoOfWorkingDays AND @IsSpecial = 0)
                              BEGIN
                                   INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                                  SELECT  Userid
                                          ,LeaveTypeId 
                                          ,Convert (varchar(5),@CL ,0) + ' CL + ' + Convert (varchar(5),@NoOfWorkingDays -@CL ,0) + ' LWP'   AS LeaveCombination
                                          ,@IsSpecial As ISSpecial
                                  FROM   [dbo].[LeaveBalance] WITH (NOLOCK) 
                                  WHERE   Userid = @Userid and LeaveTypeId= 1
                                  PRINT '1.8'
                               END
                               ELSE IF ( ( @CL <> 0 and @CL <= 2) AND  @NoOfWorkingDays <= 2 AND @CL = @NoOfWorkingDays AND @IsSpecial = 0 )
                              BEGIN
                                   INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                                  SELECT  Userid
                                          ,LeaveTypeId 
                                          ,Convert (varchar(5),@NoOfWorkingDays ,0) + ' CL '    AS LeaveCombination
                                          ,@IsSpecial As ISSpecial
                                  FROM   [dbo].[LeaveBalance] WITH (NOLOCK) 
                                  WHERE   Userid = @Userid and LeaveTypeId= 1
                                  PRINT '1.9'
                               END
                               ELSE IF (   @NoOfWorkingDays <= 2 AND @CL > @NoOfWorkingDays  AND @IsSpecial = 0)
                              BEGIN
                                   INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                                  SELECT  Userid
                                          ,LeaveTypeId 
                                          ,Convert (varchar(5),@NoOfWorkingDays ,0) + ' CL '    AS LeaveCombination
                ,@IsSpecial As ISSpecial
                                  FROM   [dbo].[LeaveBalance] WITH (NOLOCK) 
                                  WHERE   Userid = @Userid and LeaveTypeId= 1
                                  PRINT '1.10'
                               END
                                ELSE IF ( ( @CL = 0 ) AND  @NoOfWorkingDays <= 2 AND @IsSpecial = 0 )
                              BEGIN
                                   INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                                  SELECT  Userid
                                          ,LeaveTypeId 
                                          ,Convert (varchar(5),@CL,0) +' CL + ' + Convert (varchar(5),@NoOfWorkingDays ,0) + ' LWP '   AS LeaveCombination
                                          ,@IsSpecial As ISSpecial
                                  FROM   [dbo].[LeaveBalance] WITH (NOLOCK) 
                                  WHERE   Userid = @Userid and LeaveTypeId= 1
                                  PRINT '1.11'
                               END

                               ELSE IF (@CL  = 0 AND @NoOfWorkingDays >= 1  AND @IsSpecial = 0 )

                              BEGIN
                                  INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                                     SELECT  Userid
											,LeaveTypeId 
											,Convert (varchar(5),@CL,0) +' CL + ' + Convert (varchar(5),@NoOfWorkingDays,0)  + ' LWP' AS LeaveCombination
                         ,@IsSpecial As ISSpecial
                                     FROM   [dbo].[LeaveBalance] WITH (NOLOCK) 
                                     WHERE   Userid = @Userid and LeaveTypeId= 1
                                     PRINT '1.12'
                              END
                           END
           END
            IF (@LeaveTypeId = 2 )
            BEGIN
               IF (@PL > 0  And @NoOfWorkingDays > 0)
                     BEGIN
                        IF (@pl >= @NoOfWorkingDays )
                           BEGIN             
                                     INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)  
                                    SELECT Userid ,LeaveTypeId , Convert (varchar(4),(@NoOfWorkingDays ),0 ) + ' PL' AS LeaveCombination
                                    ,0 As ISSpecial
                                    FROM [dbo].[LeaveBalance] WITH (NOLOCK) 
                                    WHERE Userid = @Userid and LeaveTypeId= 2
                                    Print '2.0'
                           END
                        ELSE 
                           BEGIN
                                     INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                                    SELECT Userid ,LeaveTypeId , Convert (varchar(4),@pl ,0 ) + ' PL + ' + Convert (varchar(4),(@NoOfWorkingDays- @pl ),0 )+ ' LWP' AS LeaveCombination
                                    ,0 As ISSpecial
                                    FROM [dbo].[LeaveBalance] WITH (NOLOCK) 
                                    WHERE Userid = @Userid and LeaveTypeId= 2
                                    Print '2.1'
                           END
                     END
                 ELSE 
                           BEGIN
                                     INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                                    SELECT Userid 
                                          ,LeaveTypeId 
                                          ,Convert (varchar(4),@pl ,0 ) + ' PL + ' +Convert (varchar(4),(@NoOfWorkingDays),0 )+ ' LWP' AS LeaveCombination
                                    ,0 As ISSpecial
                                    FROM [dbo].[LeaveBalance] WITH (NOLOCK) 
                                    WHERE Userid = @Userid and LeaveTypeId= 2
          Print '2.2'
                           END
            END
           IF (@LeaveTypeId = 4 )
            BEGIN
               IF ( @compOf >= 1 AND @NoOfWorkingDays = 1 )
                  BEGIN   
                         INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)            
                        SELECT 
                              Userid 
                             ,LeaveTypeId 
                             ,Convert (varchar(4),(@NoOfWorkingDays ),0 ) + ' COFF' AS LeaveCombination
                        ,0 As ISSpecial
                        FROM [dbo].[LeaveBalance] WITH (NOLOCK) 
                        WHERE Userid = @Userid and LeaveTypeId= 4
                        PRINT '3.0'
                  END
              ELSE IF(@compOf >= 1 AND @NoOfWorkingDays = 0.5)--condition for 0.5 coff
               BEGIN   
              INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)            
                     SELECT 
                           Userid 
                           ,LeaveTypeId 
                           ,Convert (varchar(4),(@NoOfWorkingDays ),0 ) + ' LWP' AS LeaveCombination
                     ,0 As ISSpecial
                     FROM [dbo].[LeaveBalance] WITH (NOLOCK) 
                     WHERE Userid = @Userid and LeaveTypeId= 4
                      PRINT '3.1'
               END
       ELSE IF(@compof >=1 AND @NoOfWorkingDays<=2 AND @NoOfWorkingDays>1)
	   BEGIN
	   INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)            
                     SELECT 
                           Userid 
                           ,LeaveTypeId 
                           ,CASE
                            WHEN @CL>=1 THEN '1 COFF + ' + Convert (varchar(4),(@NoOfWorkingDays-1 ),0 ) + ' CL' 
						   ELSE  '1 COFF + ' + Convert (varchar(4),(@NoOfWorkingDays-1 ),0 ) + ' LWP' 
						    END    
                     ,0 As ISSpecial
                     FROM [dbo].[LeaveBalance] WITH (NOLOCK) 
                     WHERE Userid = @Userid and LeaveTypeId= 4
                      PRINT '3.2'
	   END
	   IF(@compof >=1 AND @NoOfWorkingDays<=2 AND @NoOfWorkingDays>1)
	   BEGIN
	   INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)            
                     SELECT 
                           Userid 
                           ,LeaveTypeId 
                           ,CASE
                            WHEN @PL>=1 THEN '1 COFF + ' + Convert (varchar(4),(@NoOfWorkingDays-1 ),0 ) + ' PL' 
						   ELSE  '1 COFF + ' + Convert (varchar(4),(@NoOfWorkingDays-1 ),0 ) + ' LWP' 
						    END    
							,0 As ISSpecial
                     FROM [dbo].[LeaveBalance] WITH (NOLOCK) 
                     WHERE Userid = @Userid and LeaveTypeId= 4
                      PRINT '3.3'
	   END
	    IF(@compof >=2 AND @NoOfWorkingDays>2 AND @NoOfWorkingDays<=10)
	   BEGIN
	   INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)            
                     SELECT 
                           Userid 
                           ,LeaveTypeId
						   ,CASE
                            WHEN @PL>=@NoOfWorkingDays-2 THEN '2 COFF + ' + Convert (varchar(4),(@NoOfWorkingDays-2 ),0 ) + ' PL' 
						   ELSE  '2 COFF + ' + Convert (varchar(4),(@NoOfWorkingDays-2),0 ) + ' LWP' 
						    END   
                           ,0 As ISSpecial
                     FROM [dbo].[LeaveBalance] WITH (NOLOCK) 
                     WHERE Userid = @Userid and LeaveTypeId= 4
                      PRINT '3.4'
	   END
	    IF(@compof >=2  AND @CL>=2 AND @NoOfWorkingDays>2 AND @NoOfWorkingDays<=4)
	   BEGIN
	   INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)          
                     SELECT 
                           Userid 
                           ,LeaveTypeId 
                           ,'2 COFF + ' + Convert (varchar(4),(@NoOfWorkingDays-2 ),0 ) + ' CL' AS LeaveCombination
                     ,0 As ISSpecial
                     FROM [dbo].[LeaveBalance] WITH (NOLOCK) 
                     WHERE Userid = @Userid and LeaveTypeId= 4
                      PRINT '3.5'
	   END
	   IF(@compof >=2  AND @NoOfWorkingDays=2)
	   BEGIN
	   INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)          
                     SELECT 
                           Userid 
                           ,LeaveTypeId 
                           ,'2 COFF'  AS LeaveCombination
                     ,0 As ISSpecial
                     FROM [dbo].[LeaveBalance] WITH (NOLOCK) 
                     WHERE Userid = @Userid and LeaveTypeId= 4
                      PRINT '3.5'
	   END

           END           
     END
         UPDATE #Temp 
         SET LeaveCombination = Replace (LeaveCombination ,'0 CL +','')
         WHERE LeaveTypeID =1

         UPDATE #Temp 
         SET LeaveCombination = Replace (LeaveCombination ,'0 PL +','')
         WHERE LeaveTypeID =2

         UPDATE #Temp 
         SET LeaveCombination = Replace (LeaveCombination ,'0 COFF +','')
         WHERE LeaveTypeID =4

         SELECT DISTINCT LTRIM(RTRIM(LeaveCombination)) AS LeaveCombination
         FROM #Temp 
		   GROUP BY LeaveCombination,Userid
     END 
GO
/****** Object:  StoredProcedure [dbo].[spSaveNewUser]    Script Date: 10-08-2018 13:21:46 ******/
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
            DECLARE @CLCount int

            SET @CLCount = CASE
                              WHEN @JoiningMonth BETWEEN 4 AND 12 THEN (16 - @JoiningMonth)
                              ELSE (4 - @JoiningMonth)
                           END
            IF(@JoiningDate > 10)
               SET @CLCount = @CLCount - 1
            
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
                  WHEN M.[ShortName] = 'PL' THEN 1
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
/****** Object:  StoredProcedure [dbo].[spUpdateLeaveBalanceAndLeaveStatus]    Script Date: 10-08-2018 13:21:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spUpdateLeaveBalanceAndLeaveStatus]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spUpdateLeaveBalanceAndLeaveStatus] AS' 
END
GO
/***
   Created Date      :     2016-03-11
   Created By        :     Rakesh Gandhi
   Purpose           :     This stored procedure increments or expire leaves, marks status for leaves to availed
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   1-Jun-2017		 Sudhanshu Shekhar	  Added ModifiedDate and ModifiedBy
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   Test Case 1: EXEC [dbo].[spUpdateLeaveBalanceAndLeaveStatus]
***/
ALTER PROCEDURE [dbo].[spUpdateLeaveBalanceAndLeaveStatus]
AS
BEGIN
   SET NOCOUNT ON;
   DECLARE @CurrentDate [date] = GETDATE(),  @CurrentDateTime [datetime] = GETDATE(), @LoginUserId INT = 1 --Admin
   BEGIN TRY
      BEGIN TRANSACTION

         -- insert record to history
         INSERT INTO [dbo].[LeaveBalanceHistory]
         (
            [RecordId]
            ,[Count]
            ,[CreatedDate]
            ,[CreatedBy]
         )
         
         SELECT B.[RecordId], B.[Count], @CurrentDateTime, 1
         FROM [dbo].[UserDetail] U WITH (NOLOCK) 
         INNER JOIN [dbo].[LeaveBalance] B WITH (NOLOCK) ON B.[UserId] = U.[UserId] 
         INNER JOIN [dbo].[LeaveTypeMaster] T WITH (NOLOCK) ON T.[TypeId] = B.[LeaveTypeId]
         INNER JOIN [dbo].[Designation] D WITH (NOLOCK) ON D.[DesignationId] = U.[DesignationId]
         WHERE
            ISNULL(U.[TerminateDate], '2999-12-31') > @CurrentDate
            AND U.[UserId] != 1
            AND (T.[IsAutoExpire] = 1 OR T.[IsAutoIncremented] = 1)
            AND (T.[NextAutoExpireDate] = @CurrentDate OR T.[NextAutoIncrementDate] = @CurrentDate)

         UNION ALL
	     SELECT B.[RecordId], B.[Count], @CurrentDateTime, 1
         FROM [dbo].[UserDetail] U WITH (NOLOCK)
         INNER JOIN [dbo].[LeaveBalance] B WITH (NOLOCK) ON B.[UserId] = U.[UserId] 
         INNER JOIN [dbo].[LeaveTypeMaster] T WITH (NOLOCK) ON T.[ShortName]='CLT'
         INNER JOIN [dbo].[Designation] D WITH (NOLOCK) ON D.[DesignationId] = U.[DesignationId] AND D.[IsIntern]=1
         WHERE
            ISNULL(U.[TerminateDate], '2999-12-31') > @CurrentDate
            AND U.[UserId] != 1
			AND T.[IsAutoIncremented] = 1
            AND T.[NextAutoIncrementDate] = @CurrentDate

         -- auto expire leaves
		 ----for FTE
         UPDATE B
         SET B.[Count] = 0, B.LastModifiedDate = @CurrentDateTime, B.LastModifiedBy = @LoginUserId
         FROM [dbo].[UserDetail] U WITH (NOLOCK)
         INNER JOIN [dbo].[LeaveBalance] B ON B.[UserId] = U.[UserId] 
         INNER JOIN [dbo].[LeaveTypeMaster] T WITH (NOLOCK) ON T.[TypeId] = B.[LeaveTypeId]
         INNER JOIN [dbo].[Designation] D WITH (NOLOCK) ON D.[DesignationId] = U.[DesignationId]
         WHERE
            ISNULL(U.[TerminateDate], '2999-12-31') > @CurrentDate
            AND U.[UserId] != 1
            AND T.[IsAutoExpire] = 1
            AND T.[NextAutoExpireDate] = @CurrentDate
         ---expire CL for interns
		 UPDATE B
         SET B.[Count] = 0, B.LastModifiedDate = @CurrentDateTime, B.LastModifiedBy = @LoginUserId
         FROM [dbo].[UserDetail] U WITH (NOLOCK)
         INNER JOIN [dbo].[LeaveBalance] B ON B.[UserId] = U.[UserId] 
         INNER JOIN [dbo].[LeaveTypeMaster] T WITH (NOLOCK) ON T.[ShortName]='CLT'
         INNER JOIN [dbo].[Designation] D WITH (NOLOCK) ON D.[DesignationId] = U.[DesignationId] AND D.[IsIntern]=1
         WHERE
            ISNULL(U.[TerminateDate], '2999-12-31') > @CurrentDate
            AND U.[UserId] != 1
			AND T.[IsAutoExpire] = 1
            AND T.[NextAutoExpireDate] = @CurrentDate
         -- auto increment leaves
		 --------for FTE
         UPDATE B
         SET B.[Count] = B.[Count] + T.[DaysToIncrement],B.LastModifiedDate = @CurrentDateTime, B.LastModifiedBy = @LoginUserId
         FROM [dbo].[UserDetail] U WITH (NOLOCK)
         INNER JOIN [dbo].[LeaveBalance] B ON B.[UserId] = U.[UserId] 
         INNER JOIN [dbo].[LeaveTypeMaster] T WITH (NOLOCK) ON T.[TypeId] = B.[LeaveTypeId]
		 INNER JOIN [dbo].[Designation] D WITH (NOLOCK) ON D.[DesignationId] = U.[DesignationId]
         WHERE
            ISNULL(U.[TerminateDate], '2999-12-31') > @CurrentDate
            AND U.[UserId] != 1
			AND D.[IsIntern] <> 1
            --AND D.[DesignationName] NOT LIKE '%Intern%'
            --AND D.[DesignationName] NOT LIKE '%Trainee%'
            AND T.[IsAutoIncremented] = 1
            AND T.[NextAutoIncrementDate] = @CurrentDate
         -------update 3 CL quarterly for interns
	     BEGIN
		 UPDATE B
		 SET B.[Count]=B.[Count] + T.[DaysToIncrement],B.LastModifiedDate = @CurrentDateTime, B.LastModifiedBy = @LoginUserId
		 FROM [dbo].[UserDetail] U WITH (NOLOCK)
         INNER JOIN [dbo].[LeaveBalance] B ON B.[UserId] = U.[UserId] 
         INNER JOIN [dbo].[LeaveTypeMaster] T WITH (NOLOCK) ON T.[ShortName]='CLT'
		 INNER JOIN [dbo].[Designation] D WITH (NOLOCK) ON D.[DesignationId] = U.[DesignationId] AND D.[IsIntern]=1
         WHERE
            ISNULL(U.[TerminateDate], '2999-12-31') > @CurrentDate
            AND U.[UserId] != 1
			AND B.[LeaveTypeId]=1
			AND T.[IsAutoIncremented] = 1
            AND T.[NextAutoIncrementDate] = @CurrentDate
		 END
         -- update dates for type
         UPDATE T
         SET T.[LastAutoIncrementDate] = @CurrentDate
            ,T.[NextAutoIncrementDate] =   CASE T.[AutoIncrementAfterType]
                                             WHEN 'Month' THEN DATEADD(MM, T.[AutoIncrementPeriod], @CurrentDate)
                                             WHEN 'Year' THEN DATEADD(YY, T.[AutoIncrementPeriod], @CurrentDate)
                                          END
			,T.LastModifiedDate = @CurrentDateTime, T.LastModifiedBy = @LoginUserId
         FROM [dbo].[LeaveTypeMaster] T
         WHERE T.[IsAutoIncremented] = 1 AND T.[NextAutoIncrementDate] = @CurrentDate

         UPDATE T
         SET T.[LastAutoExpireDate] = @CurrentDate
            ,T.[NextAutoExpireDate] =      CASE T.[AutoExpireAfterType]
                                             WHEN 'Month' THEN DATEADD(MM, T.[AutoExpirePeriod], @CurrentDate)
                                             WHEN 'Year' THEN DATEADD(YY, T.[AutoExpirePeriod], @CurrentDate)
                                          END
			,T.LastModifiedDate = @CurrentDateTime, T.LastModifiedBy = @LoginUserId
         FROM [dbo].[LeaveTypeMaster] T
         WHERE T.[IsAutoExpire] = 1 AND T.[NextAutoExpireDate] = @CurrentDate


         -- update status to availed for leaves
         UPDATE L
         SET L.[StatusId] = AVS.[StatusId]
		    ,L.LastModifiedDate = @CurrentDateTime, L.LastModifiedBy = @LoginUserId
         FROM [dbo].[LeaveRequestApplication] L
         INNER JOIN [dbo].[DateMaster] D WITH (NOLOCK) ON D.[DateId] = L.[FromDateId]
         INNER JOIN [dbo].[LeaveStatusMaster] CS WITH (NOLOCK) ON CS.[StatusId] = L.[StatusId] AND CS.[StatusCode] = 'AP'
         INNER JOIN [dbo].[LeaveStatusMaster] AVS WITH (NOLOCK) ON AVS.[StatusCode] = 'AV'
         WHERE D.[Date] < @CurrentDate

         UPDATE L
         SET L.[StatusId] = AVS.[StatusId]
			,L.LastModifiedDate = @CurrentDateTime, L.LastModifiedBy = @LoginUserId
         FROM [dbo].[LeaveRequestApplication] L
         INNER JOIN [dbo].[DateMaster] D WITH (NOLOCK) ON D.[DateId] = L.[FromDateId]
         INNER JOIN [dbo].[LeaveStatusMaster] CS WITH (NOLOCK) ON CS.[StatusId] = L.[StatusId] AND (CS.[StatusCode] = 'PA')
         INNER JOIN [dbo].[LeaveStatusMaster] AVS WITH (NOLOCK) ON AVS.[StatusCode] = 'AVNA'
         WHERE D.[Date] < DATEADD(dd, -1, @CurrentDate)

         UPDATE L
         SET L.[StatusId] = AVS.[StatusId]
			,L.LastModifiedDate = @CurrentDateTime, L.LastModifiedBy = @LoginUserId
         FROM [dbo].[LeaveRequestApplication] L
         INNER JOIN [dbo].[DateMaster] D WITH (NOLOCK) ON D.[DateId] = L.[FromDateId]
         INNER JOIN [dbo].[LeaveStatusMaster] CS WITH (NOLOCK) ON CS.[StatusId] = L.[StatusId] AND (CS.[StatusCode] = 'PV')
         INNER JOIN [dbo].[LeaveStatusMaster] AVS WITH (NOLOCK) ON AVS.[StatusCode] = 'AVNV'
         WHERE D.[Date] < DATEADD(dd, -1, @CurrentDate)

      COMMIT TRANSACTION;
   END TRY
   BEGIN CATCH
      ROLLBACK TRANSACTION;
      
      DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))

      EXEC [spInsertErrorLog]
	      @ModuleName = 'LMS'
         ,@Source = 'spUpdateLeaveBalanceAndLeaveStatus'
         ,@ErrorMessage = @ErrorMessage
         ,@ErrorType = 'SP'
         ,@ReportedByUserId = 1

   END CATCH
END
GO
----------add column in user detail-------
ALTER TABLE UserDetail
ADD ProbationPeriodMonths INT NULL