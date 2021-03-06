/****** Object:  StoredProcedure [dbo].[spPrepareAttendance]    Script Date: 11-12-2018 17:05:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spPrepareAttendance]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spPrepareAttendance]
GO
/****** Object:  StoredProcedure [dbo].[spGetEmployeeAttendance]    Script Date: 11-12-2018 17:05:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetEmployeeAttendance]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetEmployeeAttendance]
GO
/****** Object:  StoredProcedure [dbo].[spGetAttendanceRegisterForSupportingStaffMembers]    Script Date: 11-12-2018 17:05:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetAttendanceRegisterForSupportingStaffMembers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetAttendanceRegisterForSupportingStaffMembers]
GO
/****** Object:  StoredProcedure [dbo].[spGetAttendanceForUserOnDashboard]    Script Date: 11-12-2018 17:05:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetAttendanceForUserOnDashboard]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetAttendanceForUserOnDashboard]
GO
/****** Object:  StoredProcedure [dbo].[spFetchAllLnsaRequestStatusByUserId]    Script Date: 11-12-2018 17:05:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spFetchAllLnsaRequestStatusByUserId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spFetchAllLnsaRequestStatusByUserId]
GO
/****** Object:  StoredProcedure [dbo].[spFetchAllLnsaRequestStatusByUserId]    Script Date: 11-12-2018 17:05:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spFetchAllLnsaRequestStatusByUserId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spFetchAllLnsaRequestStatusByUserId] AS' 
END
GO
/***
   Created Date      :     2016-07-11
   Created By        :     Shubhra Upadhyay
   Purpose           :     To get status of all LNSA request on basis of userId
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
    12 oct 2018       Kanchan Kumari      used [vwActiveUsers] instead of UserDetail 
                                          and used [LNSAStatusMaster]
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   --- Test Case 1
         EXEC [dbo].[spFetchAllLnsaRequestStatusByUserId]
         @UserId = 1

   --- Test Case 2
         EXEC [dbo].[spFetchAllLnsaRequestStatusByUserId]
         @UserId = 2166
***/

ALTER PROCEDURE [dbo].[spFetchAllLnsaRequestStatusByUserId] 
   @UserId [int]
AS
BEGIN
	
SET NOCOUNT ON;
      SELECT 
         D.[Date]            AS [FromDate]
        ,M.[Date]            AS [TillDate]
        ,R.[TotalNoOfDays]   AS [NoOfDays]
        ,R.[Reason]          
		,R.[ApproverRemarks] AS [Remarks]
		,LS.StatusCode   
		,R.RequestId
		,CASE WHEN R.LastModifiedDate IS NULL THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT)END AS IsCancellable
		,CONVERT(VARCHAR(15),R.CreatedDate,106) AS ApplyDate       
        ,CASE WHEN LS.StatusCode = 'PA' THEN  LS.[Status]+' with '+UD.FirstName+' '+UD.LastName 
		  ELSE LS.[Status]+' by '+VW.FirstName+' '+VW.LastName END AS [Status]
      FROM
         [dbo].[RequestLnsa] R WITH (NOLOCK)
            INNER JOIN [dbo].[DateMaster] D WITH (NOLOCK) ON D.[DateId] = R.[FromDateId]
            INNER JOIN [dbo].[DateMaster] M WITH (NOLOCK) ON M.[DateId] = R.[TillDateId]
		    LEFT JOIN [dbo].[UserDetail] UD WITH (NOLOCK) ON R.ApproverId = UD.UserId
		    LEFT JOIN [dbo].[UserDetail] VW WITH (NOLOCK) ON R.[LastModifiedBy] = VW.UserId
			INNER JOIN [dbo].[LNSAStatusMaster] LS WITH (NOLOCK) ON R.StatusId = LS.StatusId
      WHERE
         R.[CreatedBy] = @UserId
      ORDER BY D.[Date] DESC
END








GO
/****** Object:  StoredProcedure [dbo].[spGetAttendanceForUserOnDashboard]    Script Date: 11-12-2018 17:05:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetAttendanceForUserOnDashboard]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGetAttendanceForUserOnDashboard] AS' 
END
GO
/***
   Created Date      :    2018-12-10
   Created By        :    kanchan kumari
   Purpose           :   To get user attendance
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   10 dec 2018      kanchan kumari         get attendance for each date
   --------------------------------------------------------------------------

   Test Cases        :
   --------------------------------------------------------------------------
   
   EXEC  [dbo].[spGetAttendanceForUserOnDashboard]
	 @UserId = 1108
	,@Year = 2018
	,@Month =1

***/

ALTER PROCEDURE [dbo].[spGetAttendanceForUserOnDashboard]  
    @UserId [int]
   ,@StartDate [date]
   ,@EndDate [date]
AS
BEGIN
    SET FMTONLY OFF;
	SET NOCOUNT ON ;

    IF OBJECT_ID('tempdb..#UserDateMapping') IS NOT NULL
	DROP TABLE #UserDateMapping

	IF OBJECT_ID('tempdb..#NightShiftUsers') IS NOT NULL
	DROP TABLE #NightShiftUsers

	IF OBJECT_ID('tempdb..#FinalAttendanceData') IS NOT NULL
	DROP TABLE #FinalAttendanceData

    IF OBJECT_ID('tempdb..#UserDateMapping') IS NOT NULL
    DROP TABLE #UserDateMapping

	 -- For Old Building Machine Data. 
	 CREATE TABLE #UserDateMapping(
      [UserId] [int] NOT NULL
     ,[DateId] [bigint] NOT NULL
     ,[Date] [date] NOT NULL
     ,[Day] [varchar](20) NOT NULL)

	 
   CREATE TABLE #FinalAttendanceData(
      [UserId] [int] NOT NULL
     ,[DateId] [bigint] NOT NULL
     ,[Date] [date] NOT NULL
     ,[DisplayDate] [varchar](20) NOT NULL
     ,[InTime] VARCHAR(50) NULL
     ,[OutTime] VARCHAR(50) NULL
     ,[TotalTime] VARCHAR(50) NULL
	 ,[IsNightShift] BIT  NULL
	 ,[IsApproved] BIT NULL
	 ,[IsPending] BIT NULL
	 )
   INSERT INTO #UserDateMapping
   (
       [UserId],[DateId],[Date],[Day]
   )
   SELECT @UserId, [DateId], [Date], [Day]
   FROM [dbo].[DateMaster] WHERE [Date] BETWEEN @StartDate AND @EndDate


   INSERT INTO #FinalAttendanceData
   (
      [UserId],[DateId],[Date],[DisplayDate],[InTime],[OutTime],[TotalTime],[IsNightShift]
   )
   SELECT @UserId, M.[DateId], M.[Date]
     ,CONVERT ([varchar](11), M.[Date], 106) + ' (' + SUBSTRING(M.[Day], 1, 3) + ')'
	 ,CONVERT(VARCHAR(20),ISNULL(A.[UserGivenInTime], A.[SystemGeneratedInTime]),106)+' '+FORMAT(ISNULL(A.[UserGivenInTime], A.[SystemGeneratedInTime]),'hh:mm tt') AS [InTime]
	 ,CONVERT(VARCHAR(20),ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]),106)+' '+FORMAT(ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]),'hh:mm tt') AS [OutTime]
	 ,CONVERT(VARCHAR(5), ISNULL(A.[UserGivenTotalWorkingHours], A.[SystemGeneratedTotalWorkingHours]), 108) AS [TotalTime]
	 ,A.IsNightShift
   FROM
      [dbo].[DateWiseAttendance] A WITH (NOLOCK)
      RIGHT JOIN #UserDateMapping M ON M.[DateId] = A.[DateId] AND M.[UserId] = A.[UserId]

	  ------- update --------------
     UPDATE #FinalAttendanceData SET IsNightShift = 0 WHERE IsNightShift IS NULL

       CREATE TABLE #NightShiftUsers
	    (
		 [UserId] INT,
		 [Pin] VARCHAR(20) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
		 [Date] DATE NOT NULL,
		 [IsPending] BIT NOT NULL,
		 [IsApproved] BIT NOT NULL
	    )
	 ---------insert night shift user ----------------------
	 INSERT INTO #NightShiftUsers ([UserId], [Date],[IsPending], [IsApproved])
	 SELECT U.CreatedBy, D.[Date], 
		 CASE WHEN U.StatusId = 2 AND U.LastModifiedBy IS NULL AND U.LastModifiedDate IS NULL THEN 1
		 ELSE 0 END AS [IsPending],
		 CASE WHEN U.StatusId = 3 OR (U.StatusId = 2 AND U.LastModifiedBy IS NOT NULL AND U.LastModifiedDate IS NOT NULL)  
		 THEN 1 ELSE 0 END AS [IsApproved]
	 FROM DateWiseLnsa U JOIN DateMaster D WITH (NOLOCK) ON U.DateId= D.DateId
     WHERE U.StatusId = 3 OR U.StatusId = 2  AND D.[Date] BETWEEN @StartDate AND @EndDate
	 GROUP BY U.CreatedBy, D.[Date], U.StatusId,  U.LastModifiedBy, U.LastModifiedDate 

	 UPDATE F SET F.IsNightShift = 1, F.[IsPending] = N.[IsPending], F.[IsApproved] = N.[IsApproved]
	 FROM #FinalAttendanceData F
	 JOIN #NightShiftUsers N ON F.UserId = N.UserId AND F.[Date] = N.[Date]

	 UPDATE #FinalAttendanceData SET [IsPending] = 0 WHERE [IsPending] IS NULL
	 UPDATE #FinalAttendanceData SET [IsApproved] = 0 WHERE [IsApproved] IS NULL
	 UPDATE #FinalAttendanceData SET IsNightShift = 0 WHERE [IsNightShift] IS NULL

	  UPDATE T SET
      T.[InTime] = 'Holiday'
     ,T.[OutTime] = 'Holiday'
     ,T.[TotalTime] = H.[Holiday]
   FROM
      #FinalAttendanceData T
         INNER JOIN [dbo].[ListofHoliday] H WITH (NOLOCK) ON H.[DateId] = T.[DateId]
   WHERE T.[InTime] IS NULL 

   UPDATE T SET
      T.[InTime] = CASE  WHEN LT.[ShortName] = 'WFH' THEN 'WFH' WHEN LT.[ShortName] = 'LWP' THEN 'LWP' ELSE 'Leave' END
     ,T.[OutTime] = CASE  WHEN LT.[ShortName] = 'WFH' THEN 'WFH'WHEN LT.[ShortName] = 'LWP' THEN 'LWP' ELSE 'Leave' END
     ,T.[TotalTime] = CASE  WHEN LT.[ShortName] = 'WFH' THEN 'WFH' WHEN LT.[ShortName] = 'LWP' THEN 'LWP' ELSE 'Leave' END--LT.[ShortName]
   FROM
      #FinalAttendanceData T
         INNER JOIN [dbo].[DateWiseLeaveType] L WITH (NOLOCK) ON L.[DateId] = T.[DateId]         
         INNER JOIN [dbo].[LeaveRequestApplication] A WITH (NOLOCK) ON A.[LeaveRequestApplicationId] = L.[LeaveRequestApplicationId] AND A.[UserId] = T.[UserId]
         INNER JOIN [dbo].[LeaveTypeMaster] LT WITH (NOLOCK) ON LT.[TypeId] = L.[LeaveTypeId]
   WHERE T.[InTime] IS NULL AND A.[IsActive] = 1 AND A.[IsDeleted] = 0 AND A.[StatusId] > 0


   SELECT 
      F.[DisplayDate] AS [Date]
     ,ISNULL(F.[InTime], 'NA') AS [InTime]
     ,ISNULL(F.[OutTime], 'NA') AS [OutTime]
     ,ISNULL(F.[TotalTime], 'NA') AS [LoggedInHours]
	 ,IsNightShift, IsApproved, IsPending
   FROM 
      #FinalAttendanceData F
   ORDER BY       
      F.[Date]
     ,F.[InTime] DESC
END

GO
/****** Object:  StoredProcedure [dbo].[spGetAttendanceRegisterForSupportingStaffMembers]    Script Date: 11-12-2018 17:05:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetAttendanceRegisterForSupportingStaffMembers]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGetAttendanceRegisterForSupportingStaffMembers] AS' 
END
GO
/***
   Created Date      :     2015-08-06
   Created By        :     Rakesh Gandhi
   Purpose           :     This stored procedure prepares attendance register for all supporting staff members
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   2018-05-02         kanchan kumari       to get staff attendance based on staff access card
   --------------------------------------------------------------------------
   2018-12-02         kanchan kumari       Used [SupportingStaffMember] table instead of CardPunchinData
   Test Cases        :
   --------------------------------------------------------------------------
   --- Test Case 1
         EXEC [dbo].[spGetAttendanceRegisterForSupportingStaffMembers]
            @FromDate = '2018-03-13'
           ,@EndDate = '2018-03-13'
           ,@ForEmployeeId = 1

   --- Test Case 2
         EXEC [dbo].[spGetAttendanceRegisterForSupportingStaffMembers]
            @FromDate = '2017-08-01'
           ,@EndDate = '2018-11-30'
           ,@ForEmployeeId = 0

***/
ALTER PROCEDURE [dbo].[spGetAttendanceRegisterForSupportingStaffMembers]
      @FromDate [date]
     ,@EndDate [date]
     ,@ForEmployeeId [int]
AS
BEGIN
	SET NOCOUNT ON;
	SET FMTONLY OFF;

	IF OBJECT_ID('tempdb..#UserDateMapping') IS NOT NULL
	DROP TABLE #UserDateMapping

	IF OBJECT_ID('tempdb..#FinalAttendanceData') IS NOT NULL
	DROP TABLE #FinalAttendanceData

   CREATE TABLE #UserDateMapping
   (
      [EmployeeName] [varchar](250) NOT NULL
	 ,[StaffUserId] INT
     ,[DateId] [bigint] NOT NULL
     ,[Date] [date] NOT NULL
     ,[Day] [varchar](20) NOT NULL
	 ,[AccessCardNo] VARCHAR(15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
   )

   CREATE TABLE #FinalAttendanceData
   (
      [EmployeeName] [varchar](100) NOT NULL
     ,[DateId] [bigint] NOT NULL
     ,[Date] [date] NOT NULL
     ,[DisplayDate] [varchar](20) NOT NULL
     ,[InTime] [varchar](50) NULL
     ,[OutTime] [varchar](50) NULL
     ,[TotalTime] [varchar](50) NULL
	 ,[IsNightShift] BIT NULL DEFAULT(0)
   )

   INSERT INTO #UserDateMapping
   (
       [EmployeeName]
	  ,[StaffUserId]
      ,[DateId]
      ,[Date]
      ,[Day]
	  ,[AccessCardNo]
   )
   SELECT
       E.[EmployeeName]
	   ,E.RecordId
      ,D.[DateId]
      ,D.[Date]
      ,D.[Day]
	  ,AC.[AccessCardNo]
   FROM [dbo].[SupportingStaffMember] E WITH (NOLOCK)
   CROSS JOIN [dbo].[DateMaster] D WITH (NOLOCK)
   INNER JOIN UserAccessCard UA ON UA.StaffUserId=E.RecordId
   INNER JOIN AccessCard AC ON AC.AccessCardId=UA.AccessCardId 
   WHERE
       E.[RecordId] = CASE WHEN @ForEmployeeId=0 THEN E.[RecordId] ELSE @ForEmployeeId END
	  AND E.IsActive=1
      AND D.[Date] BETWEEN @FromDate AND @EndDate

   INSERT INTO #FinalAttendanceData
   (
      [EmployeeName]
     ,[DateId]
     ,[Date]
     ,[DisplayDate]
     ,[InTime]
     ,[OutTime]
     ,[TotalTime]
	 ,[IsNightShift]
   )
   SELECT 
      M.[EmployeeName]
     ,M.[DateId]
     ,M.[Date]
     ,CONVERT ([varchar](20), M.[Date], 106) + ' (' + SUBSTRING(M.[Day], 1, 3) + ')'
	 ,CONVERT(VARCHAR(15),A.[InTime],106)+' '+FORMAT(A.[InTime],'hh:mm tt') AS [InTime]
	 ,CONVERT(VARCHAR(15),A.[OutTime],106)+' '+FORMAT(A.[OutTime],'hh:mm tt') AS [OutTime]
     ,CONVERT(VARCHAR(5),A.[Duration],108) 
	 ,A.[IsNightShift]
   FROM [dbo].StaffAttendanceForDate A WITH (NOLOCK) 
   RIGHT JOIN #UserDateMapping M ON M.[Date] = A.[Date] AND M.StaffUserId = A.StaffUserId


   UPDATE T SET T.[IsNightShift] = 0
   FROM #FinalAttendanceData T
   WHERE T.[IsNightShift] IS NULL

   UPDATE T
   SET
      T.[InTime] = 'Holiday'
     ,T.[OutTime] = 'Holiday'
     ,T.[TotalTime] = H.[Holiday]
   FROM #FinalAttendanceData T
   INNER JOIN [dbo].[ListofHoliday] H WITH (NOLOCK) ON H.[DateId] = T.[DateId]
   WHERE T.[InTime] IS NULL
   SELECT 
      F.[DisplayDate]          AS [Date]
     ,F.[EmployeeName]         AS [EmployeeName]
     ,F.[InTime]               AS [InTime]
     ,F.[OutTime]              AS [OutTime]
     ,F.[TotalTime]            AS [LoggedInHours]
	 ,F.[IsNightShift]         AS [IsNightShift]
   FROM #FinalAttendanceData F
   ORDER BY F.[Date], F.[InTime]
END
GO
/****** Object:  StoredProcedure [dbo].[spGetEmployeeAttendance]    Script Date: 11-12-2018 17:05:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetEmployeeAttendance]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGetEmployeeAttendance] AS' 
END
GO
/***
   Created Date      :     08-May-2017
   Created By        :     Chandra Prakash
   Purpose           :     This stored procedure retrives user attendance based on filter condition
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   2018-12-02         kanchan kumari       get flag for night shift user 
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------   
   --- Test Case 1
         EXEC [dbo].[spGetEmployeeAttendance]
            @FromDate = '2018-11-01'
           ,@EndDate = '2018-12-01'
           ,@DepartmentId = 0
           ,@ForEmployeeIds = '2395,74,2228'
           ,@RMId = 2203
		   ,@FetchDataForEntireOrg = 1

***/
ALTER PROCEDURE [dbo].[spGetEmployeeAttendance]
      @FromDate [date]
     ,@EndDate [date]
     ,@DepartmentId [int] = NULL
     ,@ForEmployeeIds varchar(2000) = NULL
     ,@RMId [int] = NULL
     ,@FetchDataForEntireOrg [bit] = 0
AS
BEGIN
  SET NOCOUNT ON;
  SET FMTONLY OFF;
   IF OBJECT_ID('tempdb..#UserDateMapping') IS NOT NULL
	DROP TABLE #UserDateMapping

	IF OBJECT_ID('tempdb..#NightShiftUsers') IS NOT NULL
	DROP TABLE #NightShiftUsers

	IF OBJECT_ID('tempdb..#FinalAttendanceData') IS NOT NULL
	DROP TABLE #FinalAttendanceData

   IF OBJECT_ID('tempdb..#FinalAttendanceData2') IS NOT NULL
   DROP TABLE #FinalAttendanceData2

    IF OBJECT_ID('tempdb..#UserDateMapping') IS NOT NULL
   DROP TABLE #UserDateMapping

   IF OBJECT_ID('tempdb..#Users') IS NOT NULL
   DROP TABLE #Users

    DECLARE @DepartmentName [varchar](50)
   CREATE TABLE #UserDateMapping(
      [UserId] [int] NOT NULL
     ,[DateId] [bigint] NOT NULL
     ,[Date] [date] NOT NULL
     ,[Day] [varchar](20) NOT NULL)

   CREATE TABLE #FinalAttendanceData(
      [UserId] [int] NOT NULL
     ,[EmployeeName] [varchar](100) NOT NULL
     ,[DateId] [bigint] NOT NULL
     ,[Date] [date] NOT NULL
     ,[DisplayDate] [varchar](20) NOT NULL
     ,[InTime] VARCHAR(50) NULL
     ,[OutTime] VARCHAR(50) NULL
     ,[TotalTime] VARCHAR(50) NULL
	 ,[IsNightShift] BIT  NULL
	 ,[IsApproved] BIT NULL
	 ,[IsPending] BIT NULL
	 )

	  CREATE TABLE #FinalAttendanceData2(
      [UserId] [int] NOT NULL
     ,[EmployeeName] [varchar](100) NOT NULL
     ,[DateId] [bigint] NOT NULL
     ,[Date] [date] NOT NULL
     ,[DisplayDate] [varchar](20) NOT NULL
     ,[InTime] varchar(50) NULL
     ,[OutTime] varchar(50) NULL
     ,[TotalTime] varchar(50) NULL
	 ,[IsNightShift] BIT NOT NULL
	 ,[IsApproved] BIT NOT NULL
	 ,[IsPending] BIT NOT NULL
	 )
   
   CREATE TABLE #Users(
      [EmployeeId] [int]
     ,[ManagerId] [int])   

   IF(@RMId IS NOT NULL)   
      INSERT INTO #Users
         EXEC [dbo].[spGetEmployeesReportingToUser]
            @UserId = @RMId
           ,@IncludeUser = 0
           ,@FetchDataForEntireOrg = @FetchDataForEntireOrg
   ELSE
      INSERT INTO #Users 
         SELECT [SplitData]
               ,NULL 
         FROM [dbo].[Fun_SplitStringInt](@ForEmployeeIds, ',')

   INSERT INTO #UserDateMapping
   (
       [UserId],[DateId],[Date],[Day]
   )
   SELECT
       UTM.[UserId],D.[DateId],D.[Date],D.[Day]
   FROM
      [dbo].[UserTeamMapping] UTM WITH (NOLOCK)
      INNER JOIN [dbo].[Team] T WITH (NOLOCK) 
         ON UTM.[TeamId] = T.[TeamId]
      CROSS JOIN [dbo].[DateMaster] D WITH (NOLOCK)
      INNER JOIN [dbo].[UserDetail] UD WITH (NOLOCK) 
         ON UD.[UserId] = UTM.[UserId] 
         AND ISNULL(UD.[TerminateDate], '2999-12-31') > D.[Date] 
         --AND UD.[JoiningDate] < D.[Date]
      INNER JOIN #Users U ON U.[EmployeeId] = UTM.[UserId]          
   WHERE
      T.[DepartmentId] = CASE WHEN @DepartmentId > 0 THEN @DepartmentId ELSE T.[DepartmentId] END
      AND D.[Date] BETWEEN @FromDate AND @EndDate AND UTM.[IsActive] = 1

   IF @ForEmployeeIds != ''
   BEGIN
      DELETE FROM #UserDateMapping WHERE  [UserId] NOT IN (SELECT [SplitData] FROM [dbo].[Fun_SplitStringInt](@ForEmployeeIds, ','))
   END

   --SELECT * FROM #UserDateMapping
   -- From Old Building Data
   INSERT INTO #FinalAttendanceData
   (
      [UserId],[EmployeeName],[DateId],[Date],[DisplayDate],[InTime],[OutTime],[TotalTime],[IsNightShift]
   )
   SELECT 
      U.[UserId],U.[FirstName] + ' ' + U.[LastName],M.[DateId],M.[Date]
     ,CONVERT ([varchar](11), M.[Date], 106) + ' (' + SUBSTRING(M.[Day], 1, 3) + ')'
	 ,CONVERT(VARCHAR(20),ISNULL(A.[UserGivenInTime], A.[SystemGeneratedInTime]),106)+' '+FORMAT(ISNULL(A.[UserGivenInTime], A.[SystemGeneratedInTime]),'hh:mm tt') AS [InTime]
	 ,CONVERT(VARCHAR(20),ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]),106)+' '+FORMAT(ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]),'hh:mm tt') AS [OutTime]
	 ,CONVERT(VARCHAR(5), ISNULL(A.[UserGivenTotalWorkingHours], A.[SystemGeneratedTotalWorkingHours]), 108) AS [TotalTime]
    -- ,CASE 
    --     WHEN CONVERT(datetime, M.[Date], 106) = CONVERT(datetime, ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]), 106) THEN CONVERT(datetime ,CAST(ISNULL(A.[UserGivenInTime], A.[SystemGeneratedInTime]) AS [time]), 100)
    --     ELSE CONVERT(datetime ,CAST(ISNULL(A.[UserGivenInTime], A.[SystemGeneratedInTime]) AS [time]), 100) --+ ' (' + CONVERT ([varchar](11), ISNULL(A.[UserGivenInTime], A.[SystemGeneratedInTime]), 106) + ')'
    --END
    -- ,CASE
    --     WHEN CONVERT(datetime, M.[Date], 106) = CONVERT(datetime, ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]), 106) THEN CONVERT(datetime ,CAST(ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]) AS [time]), 100)
    --     ELSE CONVERT(datetime ,CAST(ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]) AS [time]), 100) --+ ' (' + CONVERT ([varchar](11), ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]), 106) + ')'
    --  END
    -- ,CONVERT(datetime, ISNULL(A.[UserGivenTotalWorkingHours], A.[SystemGeneratedTotalWorkingHours]), 108)
	 ,A.IsNightShift
   FROM
      [dbo].[DateWiseAttendance] A WITH (NOLOCK)
      RIGHT JOIN #UserDateMapping M ON M.[DateId] = A.[DateId] AND M.[UserId] = A.[UserId]
      INNER JOIN [dbo].[UserDetail] U WITH (NOLOCK) ON M.[UserId] = U.[UserId]

	  --select * from #FinalAttendanceData WHERE UserId = 2421 ORDER BY [Date] DESC

   ---- From New Bulding Data.
	INSERT INTO #FinalAttendanceData
   (
      [UserId],[EmployeeName],[DateId],[Date],[DisplayDate],[InTime],[OutTime],[TotalTime]
   )
   SELECT 
      U.[UserId],U.[FirstName] + ' ' + U.[LastName],M.[DateId],M.[Date]
     ,CONVERT ([varchar](11), M.[Date], 106) + ' (' + SUBSTRING(M.[Day], 1, 3) + ')'
	 ,CONVERT(VARCHAR(20),ISNULL(A.[UserGivenInTime], A.[SystemGeneratedInTime]),106)+' '+FORMAT(ISNULL(A.[UserGivenInTime], A.[SystemGeneratedInTime]),'hh:mm tt') AS [InTime]
	 ,CONVERT(VARCHAR(20),ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]),106)+' '+FORMAT(ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]),'hh:mm tt') AS [OutTime]
	 ,CONVERT(VARCHAR(5), ISNULL(A.[UserGivenTotalWorkingHours], A.[SystemGeneratedTotalWorkingHours]), 108) AS [TotalTime]
    -- ,CASE 
    --     WHEN CONVERT(datetime, M.[Date], 106) = CONVERT(datetime, ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]), 106) THEN CONVERT(datetime ,CAST(ISNULL(A.[UserGivenInTime], A.[SystemGeneratedInTime]) AS [time]), 100)
    --     ELSE CONVERT(datetime ,CAST(ISNULL(A.[UserGivenInTime], A.[SystemGeneratedInTime]) AS [time]), 100) --+ ' (' + CONVERT ([varchar](11), ISNULL(A.[UserGivenInTime], A.[SystemGeneratedInTime]), 106) + ')'
    --END
    -- ,CASE
    --     WHEN CONVERT(datetime, M.[Date], 106) = CONVERT(datetime, ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]), 106) THEN CONVERT(datetime ,CAST(ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]) AS [time]), 100)
    --     ELSE CONVERT(datetime ,CAST(ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]) AS [time]), 100) --+ ' (' + CONVERT ([varchar](11), ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]), 106) + ')'
    --  END
    -- ,CONVERT(datetime, ISNULL(A.[UserGivenTotalWorkingHours], A.[SystemGeneratedTotalWorkingHours]), 108)
	
   FROM
      [dbo].[DateWiseAttendanceAsquare] A WITH (NOLOCK)
      RIGHT JOIN #UserDateMapping M ON M.[DateId] = A.[DateId] AND M.[UserId] = A.[UserId]
      INNER JOIN [dbo].[UserDetail] U WITH (NOLOCK) ON M.[UserId] = U.[UserId]


   --INSERT INTO #FinalAttendanceData
   --(
   --   [UserId],[EmployeeName],[DateId],[Date],[DisplayDate],[InTime],[OutTime],[TotalTime]
   --)
   --SELECT 
   --   U.[UserId],U.[FirstName] + ' ' + U.[LastName],M.[DateId],M.[Date]
   --  ,CONVERT ([varchar](11), M.[Date], 106) + ' (' + SUBSTRING(M.[Day], 1, 3) + ')'
   -- ,CASE 
   --      WHEN CONVERT(datetime, M.[Date], 106) = CONVERT(datetime, ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]), 106) THEN CONVERT(datetime ,CAST(ISNULL(A.[UserGivenInTime], A.[SystemGeneratedInTime]) AS [time]), 100)
   --      ELSE CONVERT(datetime ,CAST(ISNULL(A.[UserGivenInTime], A.[SystemGeneratedInTime]) AS [time]), 100) --+ ' (' + CONVERT ([varchar](11), ISNULL(A.[UserGivenInTime], A.[SystemGeneratedInTime]), 106) + ')'
   --   END
   --  ,CASE
   --      WHEN CONVERT(datetime, M.[Date], 106) = CONVERT(datetime, ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]), 106) THEN CONVERT(datetime ,CAST(ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]) AS [time]), 100)
   --      ELSE CONVERT(datetime ,CAST(ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]) AS [time]), 100) --+ ' (' + CONVERT ([varchar](11), ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]), 106) + ')'
   --   END
   --  ,CONVERT(datetime, ISNULL(A.[UserGivenTotalWorkingHours], A.[SystemGeneratedTotalWorkingHours]), 108)
   --FROM
   --   [dbo].[DateWiseAttendanceAsquare] A WITH (NOLOCK)
   --   RIGHT JOIN #UserDateMapping M ON M.[DateId] = A.[DateId] AND M.[UserId] = A.[UserId]
   --   INNER JOIN [dbo].[UserDetail] U WITH (NOLOCK) ON M.[UserId] = U.[UserId]
   
    ---update isnight shiift where null--------
	  UPDATE #FinalAttendanceData SET IsNightShift = 0 WHERE IsNightShift IS NULL

	  ---------------------------------------night shift user---------------
   	 CREATE TABLE #NightShiftUsers
	 (
		 [UserId] INT,
		 [Pin] VARCHAR(20) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
		 [Date] DATE NOT NULL,
		 [FromDateTime] DATETIME,
		 [TillDateTime] DATETIME,
		 [IsPending] BIT NOT NULL,
		 [IsApproved] BIT NOT NULL
	 )
	 ---------insert night shift user ----------------------
	 INSERT INTO #NightShiftUsers ([UserId], [Date],[IsPending], [IsApproved])
	 SELECT U.CreatedBy, D.[Date], 
		 CASE WHEN U.StatusId = 2 AND U.LastModifiedBy IS NULL AND U.LastModifiedDate IS NULL THEN 1
		 ELSE 0 END AS [IsPending],
		 CASE WHEN U.StatusId = 3 OR (U.StatusId = 2 AND U.LastModifiedBy IS NOT NULL AND U.LastModifiedDate IS NOT NULL)  
		 THEN 1 ELSE 0 END AS [IsApproved]
	 FROM DateWiseLnsa U JOIN DateMaster D WITH (NOLOCK) ON U.DateId= D.DateId
     WHERE U.StatusId = 3 OR U.StatusId = 2  AND D.[Date] BETWEEN @FromDate AND @EndDate
	 GROUP BY U.CreatedBy, D.[Date], U.StatusId,  U.LastModifiedBy, U.LastModifiedDate 

	 UPDATE F SET F.IsNightShift = 1, F.[IsPending] = N.[IsPending], F.[IsApproved] = N.[IsApproved]
	 FROM #FinalAttendanceData F
	 JOIN #NightShiftUsers N ON F.UserId = N.UserId AND F.[Date] = N.[Date]

	 UPDATE #FinalAttendanceData SET [IsPending] = 0 WHERE [IsPending] IS NULL
	 UPDATE #FinalAttendanceData SET [IsApproved] = 0 WHERE [IsApproved] IS NULL
	 UPDATE #FinalAttendanceData SET IsNightShift = 0 WHERE [IsNightShift] IS NULL

 ---------------------------------------------------------

   INSERT INTO #FinalAttendanceData2
   (
      [UserId],[EmployeeName],[DateId],[Date],[DisplayDate],[InTime],[OutTime],[TotalTime],[IsNightShift],[IsPending],[IsApproved]
   )
     SELECT    
	   DW1.[UserId],DW1.[EmployeeName],DW1.[DateId],DW1.[Date],DW1.[DisplayDate]  
	  ,DW1.[InTime] AS [InTime]
	  ,DW1.[OutTime] AS [OutTime]
	  ,DW1.[TotalTime]           
	 --,CONVERT([varchar](7),CAST( MIN(DW1.[InTime]) AS time), 100) AS [InTime]
	 --,CONVERT([varchar](7),CAST( MAX(DW1.[OutTime]) AS time), 100) AS [OutTime]
	 --,CONVERT([varchar](5),(MAX(DW1.[OutTime]) - MIN(DW1.[InTime])), 108) AS [TotalTime]
	 ,DW1.[IsNightShift]
	 ,DW1.IsPending
	 ,DW1.IsApproved
   FROM  #FinalAttendanceData DW1 
   
   --select * from #FinalAttendanceData2 WHERE UserId = 2421 ORDER BY [Date] DESC

   UPDATE T SET
      T.[InTime] = 'Holiday'
     ,T.[OutTime] = 'Holiday'
     ,T.[TotalTime] = H.[Holiday]
   FROM
      #FinalAttendanceData2 T
         INNER JOIN [dbo].[ListofHoliday] H WITH (NOLOCK) ON H.[DateId] = T.[DateId]
   WHERE T.[InTime] IS NULL 

   UPDATE T SET
      T.[InTime] = CASE  WHEN LT.[ShortName] = 'WFH' THEN 'WFH' WHEN LT.[ShortName] = 'LWP' THEN 'LWP' ELSE 'Leave' END
     ,T.[OutTime] = CASE  WHEN LT.[ShortName] = 'WFH' THEN 'WFH'WHEN LT.[ShortName] = 'LWP' THEN 'LWP' ELSE 'Leave' END
     ,T.[TotalTime] = CASE  WHEN LT.[ShortName] = 'WFH' THEN 'WFH' WHEN LT.[ShortName] = 'LWP' THEN 'LWP' ELSE 'Leave' END--LT.[ShortName]
   FROM
      #FinalAttendanceData2 T
         INNER JOIN [dbo].[DateWiseLeaveType] L WITH (NOLOCK) ON L.[DateId] = T.[DateId]         
         INNER JOIN [dbo].[LeaveRequestApplication] A WITH (NOLOCK) ON A.[LeaveRequestApplicationId] = L.[LeaveRequestApplicationId] AND A.[UserId] = T.[UserId]
         INNER JOIN [dbo].[LeaveTypeMaster] LT WITH (NOLOCK) ON LT.[TypeId] = L.[LeaveTypeId]
   WHERE T.[InTime] IS NULL AND A.[IsActive] = 1 AND A.[IsDeleted] = 0 AND A.[StatusId] > 0
   
   
   SELECT 
      F.[UserId]
     ,F.[DisplayDate] AS [Date]
     ,F.[EmployeeName] AS [EmployeeName]
     ,D.[DepartmentName] AS [Department]
     ,ISNULL(F.[InTime], 'NA') AS [InTime]
     ,ISNULL(F.[OutTime], 'NA') AS [OutTime]
     ,ISNULL(F.[TotalTime], 'NA') AS [LoggedInHours]
	 ,IsNightShift
	 ,IsApproved
	 ,IsPending
   FROM 
      #FinalAttendanceData2 F
         INNER JOIN [dbo].[UserTeamMapping] UTM WITH (NOLOCK) ON F.[UserId] = UTM.[UserId] AND UTM.[IsActive] = 1
         INNER JOIN [dbo].[Team] T WITH (NOLOCK) ON UTM.[TeamId] = T.[TeamId]
         INNER JOIN [dbo].[Department] D WITH (NOLOCK) ON D.[DepartmentId] = T.[DepartmentId]  
   ORDER BY       
      F.[EmployeeName]
     ,F.[Date]
     ,F.[InTime] DESC
END
GO
/****** Object:  StoredProcedure [dbo].[spPrepareAttendance]    Script Date: 11-12-2018 17:05:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spPrepareAttendance]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spPrepareAttendance] AS' 
END
GO
    /***
   Created Date      :     2017-11-25
   Created By        :     Shubhra Upadhyay
   Purpose           :     This stored procedure prepares attendance in save in MIS table
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   8 Jan 2018		Sudhanshu Shekhar	  Corrected attendance and temp card logs, added asquare and ground floor gates entry
   17 Sep 2018		Sudhanshu Shekhar	  Removed truncate table & implemented data merge
  
   7 Dec 2018       Kanchan Kumari        calculate attendance  for employee, staff and  temp card 
                                          1. when user in night shift 
                                          2. when day shift in cuurent date but not night shift in prev date
										  3. when day shift in cuurent date but night shift in prev date
   --------------------------------------------------------------------------
    Test Case 1 EXEC [dbo].[spPrepareAttendance] @FromDate = '2017-04-01'
***/
ALTER PROCEDURE [dbo].[spPrepareAttendance] 
(
   @FromDate [datetime] = NULL
  ,@UserId [int] = 1
)
AS
BEGIN TRY
   --SET NOCOUNT, XACT_ABORT OFF;
    DECLARE @CurrentTimeStamp [datetime] = GETDATE();

	IF OBJECT_ID('tempdb..#acc_reader') IS NOT NULL
	DROP TABLE #acc_reader

	IF OBJECT_ID('tempdb..#NightShiftUsers') IS NOT NULL
	DROP TABLE #NightShiftUsers

	IF OBJECT_ID('tempdb..#TempStaffAttendance') IS NOT NULL
	DROP TABLE #TempStaffAttendance

   IF OBJECT_ID('tempdb..#TemporaryCardLog') IS NOT NULL
   DROP TABLE #TemporaryCardLog

    IF OBJECT_ID('tempdb..#TempAttendanceLog') IS NOT NULL
   DROP TABLE #TempAttendanceLog

   IF OBJECT_ID('tempdb..#ShiftUsers') IS NOT NULL
   DROP TABLE #ShiftUsers

   IF OBJECT_ID('tempdb..#Attendance') IS NOT NULL
   DROP TABLE #Attendance

   IF OBJECT_ID('tempdb..#CardPunchinData') IS NOT NULL
   DROP TABLE #CardPunchinData

   IF OBJECT_ID('tempdb..#StaffAttendance') IS NOT NULL
   DROP TABLE #StaffAttendance

   IF OBJECT_ID('tempdb..#DateWiseAttendance') IS NOT NULL
   DROP TABLE #DateWiseAttendance

	IF (@FromDate IS NULL)
	SET @FromDate = '2017-04-01' --CAST(GETDATE() AS [Date])

	CREATE TABLE #acc_reader
	(
		[door_id] [int] NULL,
		[reader_name] [nvarchar](30) NULL,
		[reader_state] [smallint] NULL,
	)

	INSERT INTO #acc_reader
	SELECT [door_id], [reader_name], [reader_state] 
	FROM [AccessController].[dbo].[acc_reader] WITH (NOLOCK)

	CREATE TABLE #TempAttendanceLog
	(
		 [Date] [date] NOT NULL
        ,[Pin] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
		,[MinTime] [datetime] NULL
		,[MaxTime] [datetime] NULL
	)

	--Insert date and pin and min max time
	INSERT INTO #TempAttendanceLog([Date],[Pin], [MinTime],[MaxTime])
	SELECT 
	 CAST(L.[time] AS [date]) AS [Date]
	,L.[pin]
	,MIN(L.[time]) AS [MinTime]
	,MAX(L.[time]) AS [MaxTime]
	FROM [dbo].[acc_monitor_log] L WITH (NOLOCK)
	INNER JOIN #acc_reader R WITH (NOLOCK) ON L.[state]=R.[reader_state] AND L.[event_point_id]=R.[door_id]
	WHERE 
	R.[reader_name] IN ('Main Entrance I In', 'Main Entrance I Out', 'Main Entrance II In', 'Main Entrance II Out', 'Emergency Exit In', 'Emergency Exit Out',
					'ASQ-Gate1-IN', 'ASQ-Gate1-OUT', 'ASQ-Gate2-IN', 'ASQ-Gate2-OUT', 'GS-G-Main-1 In', 'GS-G-Main-1 Out', 'GND-Main_Door In','GND-Main_Door Out')
	AND CAST(L.[time] AS [date]) > '2017-04-01'
	GROUP BY CAST(L.[time] AS [date]), L.[pin] 
	
	------------------For employee member having assigned card (day & night shift user) --------------------

	CREATE TABLE #ShiftUsers
	(
	 [UserId] INT
	,[Pin] VARCHAR(20) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL
	,[Date] DATE NOT NULL
	,FromDateTime DATETIME
	,TillDateTime DATETIME
	,[MinIN] [datetime] NULL --Updatable
	,[MaxIN] [datetime] NULL --Updatable
	,[MinOUT] [datetime] NULL --Updatable
	,[MaxOUT] [datetime] NULL --Updatable
	,[MinTime] [datetime] NULL
	,[MaxTime] [datetime] NULL
	,[IsNightShift] [BIT] NOT NULL DEFAULT (0)
	,[IsPrevNightShift] [BIT] NOT NULL DEFAULT (0)
	)
	 ------insert userId who is having pin on given date------------------
	 INSERT INTO #ShiftUsers ([UserId], [Date], Pin)
	 SELECT UA.UserId, T.[Date],T.[pin] FROM #TempAttendanceLog T JOIN AccessCard AC WITH (NOLOCK)
	 ON REPLACE(LTRIM(REPLACE(T.[pin],'0',' ')),' ','0') = REPLACE(LTRIM(REPLACE(AC.[AccessCardNo],'0',' ')),' ','0') 
	 JOIN UserAccessCard UA  WITH (NOLOCK) ON AC.AccessCardId = UA.AccessCardId AND UA.UserId IS NOT NULL
	 AND T.[Date] BETWEEN UA.AssignedFromDate AND ISNULL(UA.AssignedTillDate, CAST(GETDATE() AS DATE)) AND UA.[IsFinalised] = 1 
	 
	 CREATE TABLE #NightShiftUsers
	 (
		 [UserId] INT,
		 [Pin] VARCHAR(20) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
		 [Date] DATE NOT NULL,
		 [FromDateTime] DATETIME,
		 [TillDateTime] DATETIME,
		 [IsPending] BIT NOT NULL,
		 [IsApproved] BIT NOT NULL
	 )
	 ---------insert night shift user ----------------------
	 INSERT INTO #NightShiftUsers ([UserId], [Date],[IsPending], [IsApproved])
	 SELECT U.CreatedBy, D.[Date], 
		 CASE WHEN U.StatusId = 2 AND U.LastModifiedBy IS NULL AND U.LastModifiedDate IS NULL THEN 1
		 ELSE 0 END AS [IsPending],
		 CASE WHEN U.StatusId = 3 OR (U.StatusId = 2 AND U.LastModifiedBy IS NOT NULL AND U.LastModifiedDate IS NOT NULL)  
		 THEN 1 ELSE 0 END AS [IsApproved]
	 FROM DateWiseLnsa U JOIN DateMaster D WITH (NOLOCK) ON U.DateId= D.DateId
     WHERE U.StatusId = 3 OR U.StatusId = 2  AND D.[Date] BETWEEN  '2017-04-01' AND CAST(GETDATE() AS DATE)
	 GROUP BY U.CreatedBy, D.[Date], U.StatusId,  U.LastModifiedBy, U.LastModifiedDate 

	    --select * from #ShiftUsers T  where T.UserId = 2431 AND [Date] BETWEEN '2018-05-01' AND  '2018-05-04'
		--select * from #TemporaryCardLog where UserId = 2431 AND [Date] BETWEEN '2018-05-01' AND  '2018-05-04'

	 ----------- delete from shift user where night shift of user for the date is pending ---------
		DELETE S  FROM #ShiftUsers S INNER JOIN #NightShiftUsers N
		ON S.UserId = N.UserId AND S.[Date] = N.[Date] AND N.[IsPending]= 1 AND N.[IsApproved] = 0

	 ----------update pin of all user having date bewteen AssignedFromDate and AssignedTillDate--------
	 UPDATE N SET N.[Pin] = AC.AccessCardNo
	,N.FromDateTime =  cast( N.[Date] as datetime) + cast(convert(Time,'12:00:00.0000001')  as datetime)
    ,N.TillDateTime =  cast(DATEADD(d,1,N.[Date]) as datetime) + cast(convert(Time,'12:00:00.0000000')  as datetime)
	 FROM #NightShiftUsers N JOIN UserAccessCard UA WITH (NOLOCK) ON N.UserId = UA.UserId AND UA.UserId IS NOT NULL 
	 AND N.[Date] BETWEEN UA.AssignedFromDate AND ISNULL(UA.AssignedTillDate, CAST(GETDATE() AS DATE)) AND UA.[IsFinalised] = 1
	 JOIN AccessCard AC WITH (NOLOCK) ON UA.AccessCardId = AC.AccessCardId 

	 -----------when current date in night shift-----------------------
	 UPDATE DS SET DS.[IsNightShift] = 1,  DS.FromDateTime = NS.FromDateTime,
	 DS.TillDateTime = NS.TillDateTime, DS.[Pin] = NS.[Pin]
	 FROM #ShiftUsers DS JOIN #NightShiftUsers NS 
	 WITH (NOLOCK) ON DS.[UserId] = NS.UserId AND DS.[Date] = NS.[Date] AND NS.[IsApproved] = 1 AND NS.[IsPending] = 0

	 -----------when current date in day shift and prev in night shift-----------------------
	 UPDATE DS SET DS.[IsPrevNightShift] = 1 
	 ,DS.FromDateTime =  cast( DS.[Date] as datetime) + cast(convert(Time,'12:00:00.0000001')  as datetime)
     ,DS.TillDateTime =  cast( DS.[Date] as datetime) + cast(convert(Time,'23:59:59.1000000')  as datetime)
	 FROM #ShiftUsers DS JOIN #NightShiftUsers NS
	 WITH (NOLOCK) ON DS.[UserId] = NS.UserId AND DATEADD(d,-1,DS.[Date]) = NS.[Date] AND NS.[IsApproved] = 1 AND NS.[IsPending] = 0
	 WHERE DS.[IsNightShift] = 0

	------------when current date in day shift but prev not in night shift-----------------------
	  UPDATE DS SET 
	  DS.FromDateTime =  cast( DS.[Date] as datetime) + cast(convert(Time,'00:00:01.0000000')  as datetime)
     ,DS.TillDateTime =  cast( DS.[Date] as datetime) + cast(convert(Time,'23:59:59.1000000')  as datetime)
	  FROM #ShiftUsers DS WITH (NOLOCK)
	  WHERE DS.[IsNightShift] = 0 AND DS.[IsPrevNightShift] = 0

	---UPDATE MinTime /MaxTime 
	UPDATE T SET  T.[MinTime] = L.[MinTime],T.[MaxTime] = L.[MaxTime]
	FROM #ShiftUsers T
      JOIN (
	        SELECT  NS.UserId, L.[pin] AS Pin, NS.[Date], MIN(L.[time]) AS MinTime, MAX(L.[time]) AS MaxTime
			FROM [dbo].[acc_monitor_log] L WITH (NOLOCK)
			INNER JOIN #acc_reader R WITH (NOLOCK) ON L.[state]=R.[reader_state] AND L.[event_point_id]=R.[door_id]
		    INNER JOIN #ShiftUsers NS WITH (NOLOCK) ON  REPLACE(LTRIM(REPLACE(L.[pin],'0',' ')),' ','0') = REPLACE(LTRIM(REPLACE(NS.[Pin],'0',' ')),' ','0') 
			WHERE  
			    R.[reader_name] IN ('Main Entrance I In', 'Main Entrance I Out', 'Main Entrance II In', 'Main Entrance II Out', 'Emergency Exit In', 'Emergency Exit Out',
				'ASQ-Gate1-IN', 'ASQ-Gate1-OUT', 'ASQ-Gate2-IN', 'ASQ-Gate2-OUT', 'GS-G-Main-1 In', 'GS-G-Main-1 Out', 'GND-Main_Door In','GND-Main_Door Out')
			AND CAST(L.[time] AS [date]) > '2017-04-01'
			AND L.[time] BETWEEN NS.FromDateTime AND NS.TillDateTime
			GROUP BY NS.UserId,L.[pin], NS.[Date]
			) L
        ON  T.UserId = L.UserId AND REPLACE(LTRIM(REPLACE(T.[Pin],'0',' ')),' ','0') = REPLACE(LTRIM(REPLACE(L.[Pin],'0',' ')),' ','0') AND T.[Date] = L.[Date]  

  --UPDATE Min/Max of IN 
	UPDATE T SET  T.[MinIN] = L.[MinIN],T.[MaxIN] = L.[MaxIN]
	FROM #ShiftUsers T
	JOIN (
			SELECT NS.UserId,NS.[Date] ,L.[Pin],MIN(L.[time]) AS [MinIN],MAX(L.[time]) AS [MaxIN]
			FROM [dbo].[acc_monitor_log] L WITH (NOLOCK)
			INNER JOIN #acc_reader R WITH (NOLOCK) ON L.[state]=R.[reader_state] AND L.[event_point_id]=R.[door_id]
		    INNER JOIN #ShiftUsers NS WITH (NOLOCK) ON  REPLACE(LTRIM(REPLACE(L.[pin],'0',' ')),' ','0') = REPLACE(LTRIM(REPLACE(NS.[pin],'0',' ')),' ','0') 
			WHERE 
			R.[reader_name] IN ('Main Entrance I In', 'Main Entrance II In', 'Emergency Exit In', 'ASQ-Gate1-IN', 'ASQ-Gate2-IN', 'GS-G-Main-1 In', 'GND-Main_Door In')
			AND CAST(L.[time] AS [date]) > '2017-04-01'
			AND L.[time] BETWEEN NS.FromDateTime AND NS.TillDateTime
			GROUP BY  NS.UserId, NS.[Date], L.[Pin]
		 ) L
	ON  T.UserId = L.UserId AND REPLACE(LTRIM(REPLACE(T.[Pin],'0',' ')),' ','0') = REPLACE(LTRIM(REPLACE(L.[Pin],'0',' ')),' ','0') AND T.[Date] = L.[Date]  

	--UPDATE Min/Max of OUT 
	UPDATE T SET  T.[MinOUT] = L.[MinOUT],T.[MaxOUT] = L.[MaxOUT]
	FROM #ShiftUsers T
	JOIN (
		 SELECT NS.[Date], NS.[UserId],L.[pin],MIN(L.[time]) AS [MinOUT],MAX(L.[time]) AS [MaxOUT]
		 FROM [dbo].[acc_monitor_log] L WITH (NOLOCK)
		INNER JOIN #acc_reader R WITH (NOLOCK) ON L.[state]=R.[reader_state] AND L.[event_point_id]=R.[door_id]
		INNER JOIN #ShiftUsers NS WITH (NOLOCK) ON  REPLACE(LTRIM(REPLACE(L.[pin],'0',' ')),' ','0') = REPLACE(LTRIM(REPLACE(NS.[pin],'0',' ')),' ','0')
		WHERE 
		R.[reader_name] IN ('Main Entrance I Out', 'Main Entrance II Out', 'Emergency Exit Out', 'ASQ-Gate1-OUT', 'ASQ-Gate2-OUT', 'GS-G-Main-1 Out','GND-Main_Door Out')
		AND CAST(L.[time] AS [date]) > '2017-04-01'
		AND L.[time] BETWEEN NS.FromDateTime AND NS.TillDateTime
		GROUP BY  NS.UserId, NS.[Date], L.[Pin]
	     )L
	ON  T.UserId = L.UserId AND REPLACE(LTRIM(REPLACE(T.[Pin],'0',' ')),' ','0') = REPLACE(LTRIM(REPLACE(L.[Pin],'0',' ')),' ','0') AND T.[Date] = L.[Date]  

	--------------------------------------------------------------------------------------

	------------------For staff member having assigned card (day & night shift ) --------------------

	CREATE TABLE #StaffAttendance
	(
	 [Date] DATE NOT NULL
	,[StaffUserId] INT
	,[Pin] VARCHAR(20) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL
	,[FromDateTime] DATETIME
	,[TillDateTime] DATETIME
	,[MinIN] [datetime] NULL --Updatable
	,[MaxIN] [datetime] NULL --Updatable
	,[MinOUT] [datetime] NULL --Updatable
	,[MaxOUT] [datetime] NULL --Updatable
	,[MinTime] [datetime] NULL
	,[MaxTime] [datetime] NULL
	,[IsNightShift] [BIT] NOT NULL DEFAULT(0)
	)

	 INSERT INTO #StaffAttendance ([StaffUserId], [Date], [Pin])
	 SELECT UA.StaffUserId, T.[Date],T.[pin] FROM #TempAttendanceLog T JOIN AccessCard AC WITH (NOLOCK)
	 ON REPLACE(LTRIM(REPLACE(T.[pin],'0',' ')),' ','0') = REPLACE(LTRIM(REPLACE(AC.[AccessCardNo],'0',' ')),' ','0') JOIN UserAccessCard UA  
	 WITH (NOLOCK) ON AC.AccessCardId = UA.AccessCardId AND UA.StaffUserId IS NOT NULL 
	 AND T.[Date] BETWEEN UA.AssignedFromDate AND ISNULL(UA.AssignedTillDate, CAST(GETDATE() AS DATE)) AND UA.[IsFinalised] = 1 

	 --------night shift staff -------------
	  UPDATE DS SET 
	  DS.[IsNightShift] = 1,
	  DS.FromDateTime =  cast( DS.[Date] as datetime) + cast(convert(Time,'12:00:00.0000000')  as datetime)
     ,DS.TillDateTime =  cast( DATEADD(d,1,DS.[Date]) as datetime) + cast(convert(Time,'12:00:00.0000000')  as datetime)
	  FROM #StaffAttendance DS WITH (NOLOCK)
	  WHERE [StaffUserId] = 28 --give specific staff user id who are in night shift

	  --------------for day shift staff--------------
	  UPDATE DS SET 
	  DS.FromDateTime =  cast( DS.[Date] as datetime) + cast(convert(Time,'00:00:01.0000000')  as datetime)
     ,DS.TillDateTime =  cast( DS.[Date] as datetime) + cast(convert(Time,'23:59:59.1000000')  as datetime)
	  FROM #StaffAttendance DS WITH (NOLOCK)
	  WHERE DS.[IsNightShift] = 0 

  -- UPDATE MinTime AND MaxTime
	UPDATE T SET T.[MinTime] = L.[MinTime],T.[MaxTime] = L.[MaxTime]
	FROM #StaffAttendance T
      JOIN (
	        SELECT  NS.[StaffUserId], L.[pin] AS Pin, NS.[Date], MIN(L.[time]) AS MinTime, MAX(L.[time]) AS MaxTime
			FROM [dbo].[acc_monitor_log] L WITH (NOLOCK)
			INNER JOIN #acc_reader R WITH (NOLOCK) ON L.[state]=R.[reader_state] AND L.[event_point_id]=R.[door_id]
		    INNER JOIN #StaffAttendance NS WITH (NOLOCK) ON  REPLACE(LTRIM(REPLACE(L.[pin],'0',' ')),' ','0') = REPLACE(LTRIM(REPLACE(NS.[Pin],'0',' ')),' ','0')
			WHERE  
			    R.[reader_name] IN ('Main Entrance I In', 'Main Entrance I Out', 'Main Entrance II In', 'Main Entrance II Out', 'Emergency Exit In', 'Emergency Exit Out',
				'ASQ-Gate1-IN', 'ASQ-Gate1-OUT', 'ASQ-Gate2-IN', 'ASQ-Gate2-OUT', 'GS-G-Main-1 In', 'GS-G-Main-1 Out', 'GND-Main_Door In','GND-Main_Door Out')
			AND CAST(L.[time] AS [date]) > '2017-04-01'
			AND L.[time] BETWEEN NS.FromDateTime AND NS.TillDateTime
			GROUP BY NS.[StaffUserId],L.[pin], NS.[Date]
			) L
        ON  T.[StaffUserId] = L.[StaffUserId] AND REPLACE(LTRIM(REPLACE(T.[Pin],'0',' ')),' ','0') = REPLACE(LTRIM(REPLACE(L.[Pin],'0',' ')),' ','0') AND T.[Date] = L.[Date]  

  --UPDATE Min/Max of IN 
	UPDATE T SET T.[MinIN] = L.[MinIN],T.[MaxIN] = L.[MaxIN]
	FROM #StaffAttendance T
	JOIN (
			SELECT  NS.[StaffUserId],NS.[Date] ,L.[Pin],MIN(L.[time]) AS [MinIN],MAX(L.[time]) AS [MaxIN]
			FROM [dbo].[acc_monitor_log] L WITH (NOLOCK)
			INNER JOIN #acc_reader R WITH (NOLOCK) ON L.[state]=R.[reader_state] AND L.[event_point_id]=R.[door_id]
		    INNER JOIN #StaffAttendance NS WITH (NOLOCK) ON  REPLACE(LTRIM(REPLACE(L.[pin],'0',' ')),' ','0') = REPLACE(LTRIM(REPLACE(NS.[pin],'0',' ')),' ','0') 
			WHERE 
			R.[reader_name] IN ('Main Entrance I In', 'Main Entrance II In', 'Emergency Exit In', 'ASQ-Gate1-IN', 'ASQ-Gate2-IN', 'GS-G-Main-1 In', 'GND-Main_Door In')
			AND CAST(L.[time] AS [date]) > '2017-04-01'
			AND L.[time] BETWEEN NS.FromDateTime AND NS.TillDateTime
			GROUP BY  NS.[StaffUserId], NS.[Date], L.[Pin]
		 ) L
	ON  T.[StaffUserId] = L.[StaffUserId] AND REPLACE(LTRIM(REPLACE(T.[Pin],'0',' ')),' ','0') = REPLACE(LTRIM(REPLACE(L.[Pin],'0',' ')),' ','0') AND T.[Date] = L.[Date]  
	
	--UPDATE Min/Max of OUT 
	UPDATE T SET  T.[MinOUT] = L.[MinOUT],T.[MaxOUT] = L.[MaxOUT]
	FROM #StaffAttendance T
	JOIN (
		 SELECT NS.[Date], NS.[StaffUserId],L.[pin],MIN(L.[time]) AS [MinOUT],MAX(L.[time]) AS [MaxOUT]
		 FROM [dbo].[acc_monitor_log] L WITH (NOLOCK)
		INNER JOIN #acc_reader R WITH (NOLOCK) ON L.[state]=R.[reader_state] AND L.[event_point_id]=R.[door_id]
		INNER JOIN #StaffAttendance NS WITH (NOLOCK) ON  REPLACE(LTRIM(REPLACE(L.[pin],'0',' ')),' ','0') = REPLACE(LTRIM(REPLACE(NS.[pin],'0',' ')),' ','0')  
		WHERE 
		R.[reader_name] IN ('Main Entrance I Out', 'Main Entrance II Out', 'Emergency Exit Out', 'ASQ-Gate1-OUT', 'ASQ-Gate2-OUT', 'GS-G-Main-1 Out','GND-Main_Door Out')
		AND CAST(L.[time] AS [date]) > '2017-04-01'
		AND L.[time] BETWEEN NS.FromDateTime AND NS.TillDateTime
		GROUP BY  NS.[StaffUserId], NS.[Date], L.[Pin]
	     )L
	ON  T.[StaffUserId] = L.[StaffUserId] AND REPLACE(LTRIM(REPLACE(T.[Pin],'0',' ')),' ','0') = REPLACE(LTRIM(REPLACE(L.[Pin],'0',' ')),' ','0') AND T.[Date] = L.[Date]

  --------------------------------------------------------------------------------------------------------------

  ------------------For employee having temporary card assigned (day & night shift ) --------------------

   --For Temporary Card 
	CREATE TABLE #TemporaryCardLog
	(
	     [Date] [Date] NOT NULL
		,[UserId] INT NOT NULL
        ,[Pin] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
		,[AssignedFromDateTime] DATETIME
		,[AssignedTillDateTime] DATETIME
		,[MinIN] [datetime] NULL --Updatable
		,[MaxIN] [datetime] NULL --Updatable
		,[MinOUT] [datetime] NULL --Updatable
		,[MaxOUT] [datetime] NULL --Updatable
		,[MinTime] [datetime] NULL
		,[MaxTime] [datetime] NULL
		,[IsNightShift] [BIT] NOT NULL DEFAULT (0)
		,[IsPrevDateNightShift] [BIT] NOT NULL DEFAULT (0)
	)
	--insert when temp card return same day
	INSERT INTO #TemporaryCardLog ([Date], [UserId], [Pin], AssignedFromDateTime, AssignedTillDateTime)
	SELECT CAST(T.IssueDate AS [DATE]) AS [Date], T.EmployeeId, AC.AccessCardNo, T.IssueDate, T.ReturnDate FROM [TempCardIssueDetail] T
	JOIN AccessCard AC WITH (NOLOCK) ON T.AccessCardId = AC.AccessCardId 

	 ----------- delete #TemporaryCardLog where night shift of user for the date is pending ---------
		DELETE T FROM #TemporaryCardLog T INNER JOIN #NightShiftUsers N
		ON T.UserId = N.UserId AND T.[Date] = N.[Date] AND N.[IsPending]= 1 AND N.[IsApproved] = 0

	----update when current date in night shift ----------------------
	UPDATE T
	SET T.[IsNightShift] = 1, 
	T.[AssignedFromDateTime] =  CASE WHEN T.AssignedFromDateTime >= CAST(T.[Date] as datetime) + cast(convert(Time,'12:00:00.0000001')  as datetime) THEN T.AssignedFromDateTime
		  ELSE cast( T.[Date] as datetime) + cast(convert(Time,'12:00:00.0000001')  as datetime)
	 END ,
	 T.AssignedTillDateTime = 
	 CASE   WHEN T.AssignedTillDateTime IS NOT NULL 
		       AND T.AssignedTillDateTime <= (cast(DATEADD(d,1,T.[Date]) as datetime) + cast(convert(Time,'12:00:00.0000000')  as datetime))
		       THEN T.AssignedTillDateTime
			ELSE (cast(DATEADD(d,1,T.[Date]) as datetime) + cast(convert(Time,'12:00:00.0000000')  as datetime)) END
	FROM #TemporaryCardLog T 
	JOIN #NightShiftUsers N WITH (NOLOCK) ON T.UserId = N.UserId AND T.[Date] = N.[Date] AND N.[IsApproved] = 1 AND N.[IsPending] = 0

	-------update when current date in day shift and prev date in night shift----------------------
	UPDATE T
	SET T.[IsPrevDateNightShift] = 1,
	T.[AssignedFromDateTime] =  CASE WHEN T.AssignedFromDateTime >= CAST(T.[Date] as datetime) + cast(convert(Time,'12:00:00.0000001')  as datetime) THEN T.AssignedFromDateTime
		  ELSE cast( T.[Date] as datetime) + cast(convert(Time,'12:00:00.0000001')  as datetime)
	 END ,
	 T.AssignedTillDateTime = 
	          CASE WHEN T.AssignedTillDateTime IS NOT NULL AND CAST(T.AssignedTillDateTime AS Date) = T.[Date] 
		           THEN T.AssignedTillDateTime
			  ELSE (cast(T.[Date] as datetime) + cast(convert(Time,'23:59:59.1000000')  as datetime)) END
	FROM #TemporaryCardLog T 
	JOIN #NightShiftUsers NP WITH (NOLOCK) ON T.UserId = NP.UserId AND DATEADD(d,-1,T.[Date]) = NP.[Date] AND NP.[IsApproved] = 1 AND NP.[IsPending] = 0
	WHERE  T.IsNightShift = 0 

	------update when current date in day shift but prev date not in night shift----------------------
	UPDATE T
	SET
	 T.AssignedTillDateTime = 
	     CASE  WHEN T.AssignedTillDateTime IS NOT NULL 
		       AND CAST(T.AssignedTillDateTime AS Date) = T.[Date] 
		       THEN T.AssignedTillDateTime
			ELSE (cast(T.[Date] as datetime) + cast(convert(Time,'23:59:59.1000000')  as datetime)) END
	FROM #TemporaryCardLog T WITH (NOLOCK)
	WHERE  T.IsNightShift = 0 AND T.[IsPrevDateNightShift] = 0
	-------------------------------------------------------------------------------------------------------------------------

	-- UPDATE MinTime AND MaxTime
	UPDATE T SET  T.[MinTime] = L.[MinTime], T.[MaxTime] = L.[MaxTime]
	FROM #TemporaryCardLog T
      JOIN (
	        SELECT  NS.UserId, L.[pin] AS Pin, NS.[Date], MIN(L.[time]) AS MinTime, MAX(L.[time]) AS MaxTime
			FROM [dbo].[acc_monitor_log] L WITH (NOLOCK)
			INNER JOIN #acc_reader R WITH (NOLOCK) ON L.[state]=R.[reader_state] AND L.[event_point_id]=R.[door_id]
		    INNER JOIN #TemporaryCardLog NS WITH (NOLOCK) ON  REPLACE(LTRIM(REPLACE(L.[pin],'0',' ')),' ','0') = REPLACE(LTRIM(REPLACE(NS.[Pin],'0',' ')),' ','0') 
			WHERE  
			    R.[reader_name] IN ('Main Entrance I In', 'Main Entrance I Out', 'Main Entrance II In', 'Main Entrance II Out', 'Emergency Exit In', 'Emergency Exit Out',
				'ASQ-Gate1-IN', 'ASQ-Gate1-OUT', 'ASQ-Gate2-IN', 'ASQ-Gate2-OUT', 'GS-G-Main-1 In', 'GS-G-Main-1 Out', 'GND-Main_Door In','GND-Main_Door Out')
			AND CAST(L.[time] AS [date]) > '2017-04-01'
			AND L.[time] BETWEEN NS.AssignedFromDateTime AND NS.AssignedTillDateTime
			GROUP BY NS.UserId,L.[pin], NS.[Date]
			) L
        ON  T.UserId = L.UserId AND REPLACE(LTRIM(REPLACE(T.[Pin],'0',' ')),' ','0') = REPLACE(LTRIM(REPLACE(L.[Pin],'0',' ')),' ','0') AND T.[Date] = L.[Date]  

  --UPDATE Min/Max of IN 
	UPDATE T SET T.[MinIN] = L.[MinIN],T.[MaxIN] = L.[MaxIN]
	FROM #TemporaryCardLog T
	JOIN (
			SELECT  NS.UserId, NS.[Date],L.[Pin],MIN(L.[time]) AS [MinIN],MAX(L.[time]) AS [MaxIN]
			FROM [dbo].[acc_monitor_log] L WITH (NOLOCK)
			INNER JOIN #acc_reader R WITH (NOLOCK) ON L.[state]=R.[reader_state] AND L.[event_point_id]=R.[door_id]
		    INNER JOIN #TemporaryCardLog NS WITH (NOLOCK) ON  REPLACE(LTRIM(REPLACE(L.[pin],'0',' ')),' ','0') = REPLACE(LTRIM(REPLACE(NS.[pin],'0',' ')),' ','0')
			WHERE 
			R.[reader_name] IN ('Main Entrance I In', 'Main Entrance II In', 'Emergency Exit In', 'ASQ-Gate1-IN', 'ASQ-Gate2-IN', 'GS-G-Main-1 In', 'GND-Main_Door In')
			AND CAST(L.[time] AS [date]) > '2017-04-01'
			AND L.[time] BETWEEN NS.AssignedFromDateTime AND NS.AssignedTillDateTime
			GROUP BY  NS.UserId, NS.[Date], L.[Pin]
		 ) L
	ON  T.UserId = L.UserId AND REPLACE(LTRIM(REPLACE(T.[Pin],'0',' ')),' ','0') = REPLACE(LTRIM(REPLACE(L.[Pin],'0',' ')),' ','0') AND T.[Date] = L.[Date]  

	
	--UPDATE Min/Max of OUT 
	UPDATE T SET  T.[MinOUT] = L.[MinOUT],T.[MaxOUT] = L.[MaxOUT]
	FROM #TemporaryCardLog T
	JOIN (
		 SELECT NS.[Date], NS.[UserId],L.[pin],MIN(L.[time]) AS [MinOUT],MAX(L.[time]) AS [MaxOUT]
		FROM [dbo].[acc_monitor_log] L WITH (NOLOCK)
		INNER JOIN #acc_reader R WITH (NOLOCK) ON L.[state]=R.[reader_state] AND L.[event_point_id]=R.[door_id]
		INNER JOIN #TemporaryCardLog NS WITH (NOLOCK) ON  REPLACE(LTRIM(REPLACE(L.[pin],'0',' ')),' ','0') = REPLACE(LTRIM(REPLACE(NS.[pin],'0',' ')),' ','0')
		WHERE 
		R.[reader_name] IN ('Main Entrance I Out', 'Main Entrance II Out', 'Emergency Exit Out', 'ASQ-Gate1-OUT', 'ASQ-Gate2-OUT', 'GS-G-Main-1 Out','GND-Main_Door Out')
		AND CAST(L.[time] AS [date]) > '2017-04-01'
		AND L.[time] BETWEEN NS.AssignedFromDateTime AND NS.AssignedTillDateTime
		GROUP BY  NS.UserId, NS.[Date], L.[Pin]
	     )L
	ON  T.UserId = L.UserId AND REPLACE(LTRIM(REPLACE(T.[Pin],'0',' ')),' ','0') = REPLACE(LTRIM(REPLACE(L.[Pin],'0',' ')),' ','0') AND T.[Date] = L.[Date]  
	
	----------------------------------------------------------------------------------------------------------------------------   
	BEGIN TRANSACTION

	CREATE TABLE #Attendance
	(
		 [Date] [date] NOT NULL
        ,[Pin] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
		,[InTime] [datetime] NOT NULL
		,[OutTime] [datetime] NULL
		,[Duration] AS [OutTime] - [InTime]
	)

	----delete if user punch in log not present 
	DELETE FROM #ShiftUsers WHERE MinTime IS NULL AND MaxTime IS  NULL
	DELETE FROM #StaffAttendance WHERE MinTime IS NULL AND MaxTime IS  NULL
	DELETE FROM #TemporaryCardLog WHERE MinTime IS NULL AND MaxTime IS  NULL

	   -- Calculate and get in/out time of employee
	INSERT INTO #Attendance([Date],[Pin],[InTime],[OutTime])
	SELECT T.[Date], T.[Pin], 
    CASE WHEN (T.[MinIN] IS NULL AND  T.[MinOUT] IS NULL) THEN T.[MinTime] 
	     WHEN (T.[MinIN] IS NULL AND T.[MinOUT] IS NOT NULL) THEN T.[MinOUT]
		 ELSE  T.[MinIN]  
	END AS [InTime],
	CASE WHEN (T.[MaxOut] IS NULL AND T.[MaxIN] IS NULL) THEN T.[MaxTime] 
	     WHEN (T.[MaxOut] IS NULL AND T.[MaxIN] IS NOT NULL) THEN T.[MaxIN]
		 ELSE  T.[MaxOut] 
	END AS [OutTime]
	FROM #ShiftUsers T ORDER BY T.[UserId] ASC, T.[Date] DESC

	-- Calculate and get in/out time of staff
	INSERT INTO #Attendance([Date],[Pin],[InTime],[OutTime])
	SELECT T.[Date], T.[Pin], 
    CASE WHEN (T.[MinIN] IS NULL AND  T.[MinOUT] IS NULL) THEN T.[MinTime] 
	     WHEN (T.[MinIN] IS NULL AND T.[MinOUT] IS NOT NULL) THEN T.[MinOUT]
		 ELSE  T.[MinIN]  
	END AS [InTime],
	CASE WHEN (T.[MaxOut] IS NULL AND T.[MaxIN] IS NULL) THEN T.[MaxTime] 
	     WHEN (T.[MaxOut] IS NULL AND T.[MaxIN] IS NOT NULL) THEN T.[MaxIN]
		 ELSE  T.[MaxOut] 
	END AS [OutTime]
	FROM #StaffAttendance T ORDER BY T.[Date] DESC

	------------------create table for staff ----------------------------

	CREATE TABLE #TempStaffAttendance
	(
	 [Date] DATE NOT NULL
	,[StaffUserId] INT
	,[InTime] [datetime] NULL
	,[OutTime] [datetime] NULL
	,[Duration] AS [OutTime] - [InTime]
	,[IsNightShift] [BIT] NOT NULL 
	)
------------------------------------------------------------
	INSERT INTO #TempStaffAttendance([Date], StaffUserId,  [InTime], [OutTime],[IsNightShift])
	SELECT T.[Date], T.StaffUserId, 
    CASE WHEN (T.[MinIN] IS NULL AND  T.[MinOUT] IS NULL) THEN T.[MinTime] 
	     WHEN (T.[MinIN] IS NULL AND T.[MinOUT] IS NOT NULL) THEN T.[MinOUT]
		 ELSE  T.[MinIN]  
	END AS [InTime],
	CASE WHEN (T.[MaxOut] IS NULL AND T.[MaxIN] IS NULL) THEN T.[MaxTime] 
	     WHEN (T.[MaxOut] IS NULL AND T.[MaxIN] IS NOT NULL) THEN T.[MaxIN]
		 ELSE  T.[MaxOut] 
	END AS [OutTime],
	T.[IsNightShift]
	FROM #StaffAttendance T ORDER BY T.[Date] DESC

	------truncate StaffAttendance ----------------
	EXEC [Proc_Truncate] 'StaffAttendanceForDate', 1 --by Admin 

	INSERT INTO StaffAttendanceForDate([Date], [StaffUserId], [InTime], [OutTime],[IsNightShift], [Duration] )
	SELECT [Date], [StaffUserId], [InTime], [OutTime],[IsNightShift], [Duration]  FROM #TempStaffAttendance

	  --Insert into card punchin data to get attendance using accesscard no
	SELECT A.[Pin],'' AS [Name], D.[DateId], A.[Date], A.[InTime], A.[OutTime]
	INTO #CardPunchinData
	FROM #Attendance A         
	INNER JOIN [dbo].[DateMaster] D WITH (NOLOCK) ON A.[Date] = D.[Date]
	GROUP BY A.[Pin],D.[DateId],A.[Date],A.[InTime],A.[OutTime]
	ORDER BY A.[InTime] DESC 

	-----delete from shift users where tempcard data is matched 
	        DELETE A FROM #ShiftUsers A INNER JOIN #TemporaryCardLog T
			WITH (NOLOCK) ON T.[UserId] = A.[UserId] AND T.[Date] = A.[Date] 

    ---insert temporary card log data in shift user --------------------
	INSERT INTO #ShiftUsers (UserId, Pin, [Date], FromDateTime, TillDateTime, MinIN, MaxIN, MinOUT, MaxOUT, MinTime, MaxTime, IsNightShift)
	SELECT T.UserId, T.Pin, T.[Date], T.AssignedFromDateTime AS FromDateTime, T.AssignedTillDateTime AS TillDateTime,
	       T.MinIN, T.MaxIN, T.MinOUT, T.MaxOUT, T.MinTime, T.MaxTime, T.IsNightShift
	FROM #TemporaryCardLog T LEFT JOIN #ShiftUsers A WITH (NOLOCK) ON T.[UserId] = A.[UserId] AND T.[Date] = A.[Date] 
	WHERE  A.[UserId] IS NULL AND A.[Date] IS NULL 

  --Insert into temp, date wise attendance
	SELECT DM.[DateId], T.[UserId],
	 CASE WHEN (T.[MinIN] IS NULL AND  T.[MinOUT] IS NULL) THEN T.[MinTime] 
	     WHEN (T.[MinIN] IS NULL AND T.[MinOUT] IS NOT NULL) THEN T.[MinOUT]
		 ELSE  T.[MinIN]  
	END AS [InTime],
	CASE WHEN (T.[MaxOut] IS NULL AND T.[MaxIN] IS NULL) THEN T.[MaxTime] 
	     WHEN (T.[MaxOut] IS NULL AND T.[MaxIN] IS NOT NULL) THEN T.[MaxIN]
		 ELSE  T.[MaxOut] 
	END AS [OutTime],
	T.IsNightShift AS IsNightShift,
	1 [IsActive], GETDATE() [CreatedDate], 1 [CreatedBy]
	INTO #DateWiseAttendance
	FROM #ShiftUsers T 
	JOIN DateMaster DM WITH (NOLOCK) ON T.[Date] = DM.[Date]
	ORDER BY T.[UserId] ASC, T.[Date] DESC

	--======================================================================
	-------Removed truncate, and implemented megre-------------------
	--EXEC [Proc_Truncate] 'CardPunchinData', 1 --by Admin
	--EXEC [Proc_Truncate] 'DateWiseAttendance', 1 --by Admin
	  
	-----------------------------------------------------------------
	--1--------------------------------------------------------------
	--INSERT INTO [dbo].[CardPunchinData]([CardNo],[Name],[DateId],[Date],[InTime],[OutTime])
	--SELECT [Pin], [Name], [DateId], [Date], [InTime],[OutTime]
	--FROM #CardPunchinData

	--Merge into CardPunchinData ------------------------------------
		MERGE [dbo].[CardPunchinData] AS TARGET
		USING #CardPunchinData AS SOURCE 
		ON (TARGET.CardNo = SOURCE.Pin AND TARGET.DateId = SOURCE.DateId) 

		--When records are matched, update the records if there is any change
		WHEN MATCHED AND (TARGET.OutTime <> SOURCE.OutTime OR TARGET.OutTime <> SOURCE.OutTime)
		THEN 
		UPDATE SET 
		TARGET.InTime = SOURCE.InTime, 
		TARGET.OutTime = SOURCE.OutTime,
		TARGET.IsActive = 1,
		TARGET.ModifiedDate = GETDATE(),
		TARGET.ModifiedBy = 1

		--When no records are matched, insert the incoming records from source table to target table
		WHEN NOT MATCHED BY TARGET THEN 
		INSERT ([CardNo],[Name],[DateId],[Date],[InTime],[OutTime],[IsActive],[CreatedDate],[CreatedBy])
		VALUES (SOURCE.[Pin], SOURCE.[Name], SOURCE.[DateId], SOURCE.[Date], SOURCE.[InTime], SOURCE.[OutTime],1,GETDATE(),1)

		--When there is a row that exists in target table and same record does not exist in source table then deactivate this record from target table
		WHEN NOT MATCHED BY SOURCE THEN
	    UPDATE SET TARGET.IsActive = 0, TARGET.ModifiedDate = GETDATE(), TARGET.ModifiedBy = 1

		OUTPUT  $action AS [ActionType],
				DELETED.[CardNo] AS [OldCardNo], 
				DELETED.[DateId] AS [OldDateId], 
				DELETED.[Date] AS [OldDate],
				DELETED.[InTime] AS [OldInTime],
				DELETED.[OutTime] AS [OldOutTime], 
				DELETED.[IsActive] AS [OldIsActive], 
				INSERTED.[CardNo] AS [NewCardNo], 
				INSERTED.[DateId] AS [NewDateId], 
				INSERTED.[Date] AS [NewDate],
				INSERTED.[InTime] AS [NewInTime],
				INSERTED.[OutTime] AS [NewOutTime], 
				INSERTED.[IsActive] AS [NewIsActive], 
				@CurrentTimeStamp AS [ModifiedDate]
		INTO CardPunchinDataMergeHistory([ActionType],[OldCardNo],[OldDateId],[OldDate],[OldInTime],[OldOutTime],[OldIsActive],
										 [NewCardNo],[NewDateId],[NewDate],[NewInTime],[NewOutTime],[NewIsActive],[ModifiedDate]);
	--2--------------------------------------
	--INSERT INTO [dbo].[DateWiseAttendance]([DateId],[UserId],[SystemGeneratedInTime],[SystemGeneratedOutTime],[SystemGeneratedStatusId],[CreatedDate],[CreatedBy],[IsNightShift])
	--SELECT [DateId],[UserId],[InTime],[OutTime],[IsActive],[CreatedDate],[CreatedBy],[IsNightShift]
	--FROM #DateWiseAttendance

	--Merge into DateWiseAttendance ------------------------------------
	   MERGE [dbo].[DateWiseAttendance] AS TARGET
		USING #DateWiseAttendance AS SOURCE 
		ON (TARGET.UserId = SOURCE.UserId AND TARGET.DateId = SOURCE.DateId) 

		--When records are matched, update the records if there is any change
		WHEN MATCHED AND (TARGET.SystemGeneratedInTime <> SOURCE.InTime OR TARGET.SystemGeneratedOutTime <> SOURCE.OutTime)
		THEN 
		UPDATE SET 
		TARGET.[SystemGeneratedInTime] = SOURCE.InTime, 
		TARGET.[SystemGeneratedOutTime] = SOURCE.OutTime,
		TARGET.[IsActive] = 1,
		TARGET.[IsDeleted] = 0,
		TARGET.[LastModifiedDate] = @CurrentTimeStamp,
		TARGET.[LastModifiedBy] = 1,
		TARGET.[IsNightShift] = SOURCE.IsNightShift

		--When no records are matched, insert the incoming records from source table to target table
		WHEN NOT MATCHED BY TARGET THEN 
		INSERT ([UserId],[DateId],[SystemGeneratedInTime],[SystemGeneratedOutTime],[SystemGeneratedStatusId],[IsActive],[IsDeleted],[CreatedDate],[CreatedBy], [IsNightShift])
		VALUES (SOURCE.[UserId], SOURCE.[DateId], SOURCE.[InTime], SOURCE.[OutTime],1,1,0,@CurrentTimeStamp,1, SOURCE.IsNightShift)
		
		--When there is a row that exists in target table and same record does not exist in source table then deactivate this record from target table
		WHEN NOT MATCHED BY SOURCE THEN
	    UPDATE SET TARGET.[IsActive] = 0, TARGET.[IsDeleted] = 1,TARGET.[LastModifiedDate] = @CurrentTimeStamp, TARGET.[LastModifiedBy] = 1
			
		OUTPUT  $action AS [ActionType],
				DELETED.[DateId] AS [OldDateId], 
				DELETED.[UserId] AS [OldUserId], 
				DELETED.[SystemGeneratedInTime] AS [OldInTime],
				DELETED.[SystemGeneratedOutTime] AS [OldOutTime],
				DELETED.[SystemGeneratedTotalWorkingHours] AS [OldTotalWorkingHours],
				DELETED.[IsActive] AS [OldIsActive],
				DELETED.[IsDeleted] AS [OldIsDeleted],
				DELETED.[IsNightShift] AS [OldIsNightShift], 
				INSERTED.[DateId] AS [NewDateId], 
				INSERTED.[UserId] AS [NewUserId], 
				INSERTED.[SystemGeneratedInTime] AS [NewInTime],
				INSERTED.[SystemGeneratedOutTime] AS [NewOutTime],
				INSERTED.[SystemGeneratedTotalWorkingHours] AS [NewTotalWorkingHours],
				INSERTED.[IsActive] AS [NewIsActive],
				INSERTED.[IsDeleted] AS [NewIsDeleted],
				INSERTED.[IsNightShift] AS [NewIsNightShift], 
				@CurrentTimeStamp  AS [ModifiedDate]
		INTO DateWiseAttendanceMergeHistory([ActionType],[OldDateId],[OldUserId],[OldInTime],[OldOutTime],[OldTotalWorkingHours],[OldIsActive],[OldIsDeleted],OldIsNightShift,
										 [NewDateId],[NewUserId],[NewInTime],[NewOutTime],[NewTotalWorkingHours],[NewIsActive],[NewIsDeleted],[NewIsNightShift], [ModifiedDate]);
	--======================================================================

   COMMIT TRANSACTION;
   SELECT 1 AS [Result]
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
	BEGIN
		ROLLBACK TRANSACTION;
	END

	DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
	--Log Error
	EXEC [spInsertErrorLog]
		@ModuleName = 'AccessController'
	,@Source = 'spPrepareAttendance'
	,@ErrorMessage = @ErrorMessage
	,@ErrorType = 'SP'
	,@ReportedByUserId = @UserId

	SELECT 2 AS [Result]
END CATCH
GO
