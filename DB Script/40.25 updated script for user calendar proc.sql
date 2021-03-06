GO
/****** Object:  StoredProcedure [dbo].[Proc_GetUserWiseWeekDataInCalendar]    Script Date: 15-02-2019 13:30:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetUserWiseWeekDataInCalendar]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetUserWiseWeekDataInCalendar]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetUserWiseWeekDataInCalendar]    Script Date: 15-02-2019 13:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetUserWiseWeekDataInCalendar]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetUserWiseWeekDataInCalendar] AS' 
END
GO
/***
    Created Date      :     2019-02-01
   Created By        :     Mimansa Agrawal
   Purpose           :     This stored procedure fetches employee's weekdays detail monthly
   Change History    :
   --------------------------------------------------------------------------
	   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
      EXEC [Proc_GetUserWiseWeekDataInCalendar] @LoginUserId=2434,@StartDate='2019-01-28',@EndDate='2019-03-10'
***/
ALTER PROC [dbo].[Proc_GetUserWiseWeekDataInCalendar]
(
 @LoginUserId INT 
,@StartDate DATE 
,@EndDate DATE 
)
AS
BEGIN
	SET FMTONLY OFF;
	SET NOCOUNT ON;
	DECLARE @FromDateId BIGINT,@TillDateId BIGINT
	SET @FromDateId = (SELECT DateId FROM [dbo].[DateMaster] WITH (NOLOCK) WHERE [Date]=@StartDate)
	SET @TillDateId = (SELECT DateId FROM [dbo].[DateMaster] WITH (NOLOCK) WHERE [Date]=@EndDate)
	IF OBJECT_ID('tempdb..#UserDateMapping') IS NOT NULL
	DROP TABLE #UserDateMapping
	CREATE TABLE #UserDateMapping
	(
	 [DateId] [bigint] NOT NULL
	,[Date] [date] NOT NULL
	,[IsWeekend] BIT NOT NULL 
	,[UserId] [int] NOT NULL
	,[WeekNo] [INT] NOT NULL
	,[IsNormalWeek] BIT NOT NULL DEFAULT(1)
	,[IsWeekOff] BIT NOT NULL DEFAULT(0)
	,[IsHoliday] BIT NOT NULL DEFAULT(0)
	,[OnLeave] BIT NOT NULL DEFAULT(0)
	,[LeaveType] VARCHAR(100) NULL
	,[IsNightShift] BIT NOT NULL DEFAULT(0)
	,[WorkingHrs] VARCHAR(20) NULL
	,[TimesheetHrs] VARCHAR(20) NULL
	)
	INSERT INTO #UserDateMapping([UserId],[DateId],[Date],[IsWeekend],[WeekNo])
	SELECT  U.[UserId], D.[DateId], D.[Date], D.[IsWeekend], (SELECT WeekNo FROM [dbo].[FetchDateAndWeekNo](D.[Date]))
	FROM [dbo].[DateMaster] D WITH (NOLOCK)
	CROSS JOIN [dbo].[UserDetail] U WITH (NOLOCK) 
	WHERE U.[UserId]=@LoginUserId AND D.[Date] BETWEEN @StartDate AND @EndDate 

	 ----update [IsNormalWeek] of #UserDateMapping -------------------
	  UPDATE U SET U.[IsNormalWeek] = 0 FROM #UserDateMapping U 
	  INNER JOIN (
	             SELECT Q.[WeekNo], T.[UserId] 
				 FROM EmployeeWiseWeekOff T WITH (NOLOCK)
				 JOIN #UserDateMapping Q ON T.[UserId] = Q.[UserId] AND T.[WeekOffDateId] = Q.[DateId] 
				 WHERE T.[IsActive] = 1
				 GROUP BY T.[UserId], Q.[WeekNo]
				 ) N ON U.[UserId] = N.[UserId] AND U.[WeekNo] = N.[WeekNo]
 -------UPDATE IsWeekOff flag for normal week-----------------------------
 UPDATE U SET U.[IsWeekOff]=1 FROM #UserDateMapping U  WHERE U.[IsNormalWeek]=1 AND U.[IsWeekend]=1
 --------UPDATE IsWeekOff flag for abnormal week------------
 UPDATE U SET U.[IsWeekOff]=1 
 FROM #UserDateMapping U 
 JOIN [dbo].[EmployeeWiseWeekOff] E ON E.[WeekOffDateId]=U.DateId AND E.[UserId]=U.[UserId]
 WHERE U.[IsNormalWeek]=0 
 ----------------update isholiday flag---------
 UPDATE U SET U.[IsHoliday]=1
 FROM #UserDateMapping U 
 LEFT JOIN [dbo].[ListOfHoliday] L ON U.[DateId]=L.[DateId] 
 WHERE L.[DateId] IS NOT NULL 
 --------------------update workinghrs--------------
 ;WITH [ProjectHoursTotal] AS ( 
    SELECT 
        CONVERT(VARCHAR(5), ISNULL(A.[UserGivenTotalWorkingHours], A.[SystemGeneratedTotalWorkingHours]), 108) AS WorkHrs,
		A.[DateId]
    FROM 
        [dbo].[DateWiseAttendance] A WHERE A.[UserId]=@LoginUserId AND A.[DateId] BETWEEN @FromDateId AND @TillDateId
		GROUP BY A.[DateId],A.[UserGivenTotalWorkingHours],A.[SystemGeneratedTotalWorkingHours]
) 
UPDATE U
SET 
    U.[WorkingHrs]=ISNULL(P.[WorkHrs],'00:00')
	 FROM #UserDateMapping U
    LEFT JOIN [ProjectHoursTotal] P ON U.[DateId] = P.[DateId]
	-----------------update timesheethrs-------------
	UPDATE U SET U.[TimesheetHrs]=ISNULL(T.[TimeSpent],'0.0')
 FROM #UserDateMapping U 
 JOIN [dbo].[FinalLoggedTasks] T ON U.[Date]=T.[Date] 
  WHERE T.[CreatedBy]=@LoginUserId
  ------------Update isnightshift--------------
  UPDATE U SET U.[IsNightShift]=1
 FROM #UserDateMapping U 
  JOIN [dbo].[DateWiseLNSA] D ON U.[DateId]=D.[DateId] 
  WHERE D.[CreatedBy]=@LoginUserId AND  D.[StatusId] < 6
  -------------update leave and leavetype-----------
  ;WITH [Leaves] AS ( 
    SELECT D.[DateId], LT.[ShortName] AS LeaveType
    FROM [dbo].[LeaveRequestApplication] L  
		JOIN [dbo].[DateWiseLeaveType] D  WITH (NOLOCK) ON L.[LeaveRequestApplicationId]=D.[LeaveRequestApplicationId]
		JOIN [dbo].[LeaveTypeMaster] LT  WITH (NOLOCK) ON LT.[TypeId]=D.[LeaveTypeId]
		WHERE L.[UserId]=@LoginUserId AND L.[StatusId] > 0 AND D.[DateId] BETWEEN @FromDateId AND @TillDateId
		GROUP BY D.[DateId],LT.[ShortName]
) 
UPDATE U
SET 
    U.[OnLeave]=1,U.[LeaveType]=P.[LeaveType]
	 FROM #UserDateMapping U
    INNER JOIN [Leaves] P ON U.[DateId] = P.[DateId]
	----------update outing----------------
	 ;WITH [OutingLeaves] AS ( 
    SELECT A.[DateId], LT.[OutingTypeName] AS OutingType
    FROM [dbo].[OutingRequest] L         
         INNER JOIN [dbo].[OutingRequestDetail]  A WITH (NOLOCK) ON A.[OutingRequestId] = L.[OutingRequestId] 
         INNER JOIN [dbo].[OutingType] LT WITH (NOLOCK) ON LT.[OutingTypeId] = L.[OutingTypeId]
		 WHERE L.[UserId]=@LoginUserId AND L.[StatusId] < 6 AND A.[DateId] BETWEEN @FromDateId AND @TillDateId
		GROUP BY A.[DateId],LT.[OutingTypeName]
) 
UPDATE U
SET 
    U.[OnLeave]=1,U.[LeaveType]=P.[OutingType]
	 FROM #UserDateMapping U
    INNER JOIN [OutingLeaves] P ON U.[DateId] = P.[DateId]
	
 ----------------select userwise data---------------------
    SELECT UserId, DateId, [Date], IsWeekOff, IsHoliday, OnLeave, LeaveType, IsNightShift, WorkingHrs, TimesheetHrs
    FROM #UserDateMapping
END
GO
