
/****** Object:  StoredProcedure [dbo].[spUpdateEmployeeLeaveBalanceByHR]    Script Date: 05-02-2019 18:45:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spUpdateEmployeeLeaveBalanceByHR]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spUpdateEmployeeLeaveBalanceByHR]
GO
/****** Object:  StoredProcedure [dbo].[spGetUserAppliedLeave]    Script Date: 05-02-2019 18:45:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetUserAppliedLeave]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetUserAppliedLeave]
GO
/****** Object:  StoredProcedure [dbo].[spGetAttendanceRegisterForSupportingStaffMembers]    Script Date: 05-02-2019 18:45:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetAttendanceRegisterForSupportingStaffMembers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetAttendanceRegisterForSupportingStaffMembers]
GO
/****** Object:  StoredProcedure [dbo].[spGetAttendanceForUserOnDashboard]    Script Date: 05-02-2019 18:45:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetAttendanceForUserOnDashboard]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetAttendanceForUserOnDashboard]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetShiftMappingDetails]    Script Date: 05-02-2019 18:45:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetShiftMappingDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetShiftMappingDetails]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetPunchInOutLogForStaff]    Script Date: 05-02-2019 18:45:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetPunchInOutLogForStaff]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetPunchInOutLogForStaff]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetPunchInOutLogForStaff]    Script Date: 05-02-2019 18:45:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetPunchInOutLogForStaff]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetPunchInOutLogForStaff] AS' 
END
GO
-- =============================================
-- Author	  : Kanchan Kumari
-- Create date: 5-Feb-2019
-- Description:	To get door's punch In or out log for Prev, Current & Next day for staff member
-- EXEC [Proc_GetPunchInOutLogForStaff] 2479, '21 Aug 2018'
-- =============================================
ALTER PROCEDURE [dbo].[Proc_GetPunchInOutLogForStaff]
(	
	@StaffUserId INT,
	@AttendanceDate varchar(20)
)
AS
BEGIN
	 DECLARE @AccessCardNo VARCHAR(20)

	 SELECT Top 1 @AccessCardNo = REPLACE(LTRIM(REPLACE(AC.[AccessCardNo],'0',' ')),' ','0') FROM UserAccessCard UA JOIN AccessCard AC
	 WITH (NOLOCK) ON UA.AccessCardId = AC.AccessCardId AND UA.StaffUserId  =  @StaffUserId
	 AND @AttendanceDate BETWEEN UA.AssignedFromDate AND ISNULL(UA.AssignedTillDate, CAST(GETDATE() AS DATE)) AND UA.[IsFinalised] = 1 

	    SELECT CONVERT(VARCHAR(11), AML.[time], 106) + ' ' + RIGHT(CONVERT(VARCHAR, AML.[time], 100), 7) AS [PunchTime],
		AML.[state_name] AS [DoorPoint], 
		CASE 
			WHEN CAST(AML.[time] AS DATE) = DATEADD(D,-1,CAST(@AttendanceDate AS DATE)) THEN 'P' --Previous
			WHEN CAST(AML.[time] AS DATE) = CAST(@AttendanceDate AS DATE) THEN 'C'				 --Current
			WHEN CAST(AML.[time] AS DATE) = DATEADD(D,+1,CAST(@AttendanceDate AS DATE)) THEN 'N' --Next
			ELSE ''
		 END AS [Day]
	FROM dbo.acc_monitor_log AML WITH (NOLOCK)
	WHERE REPLACE(LTRIM(REPLACE(AML.[pin],'0',' ')),' ','0') = @AccessCardNo 
	AND CAST(AML.[time] AS DATE) BETWEEN DATEADD(D,-1,CAST(@AttendanceDate AS DATE)) AND DATEADD(D,+1,CAST(@AttendanceDate AS DATE))
	ORDER BY AML.[time]
END
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetShiftMappingDetails]    Script Date: 05-02-2019 18:45:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetShiftMappingDetails]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetShiftMappingDetails] AS' 
END
GO
/***
   Created Date      :     2018-07-25
   Created By        :     Kanchan kumari
   Purpose           :     This stored procedure retrives current week and week details
   Change History    :
   --------------------------------------------------------------------------
	   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------

   Created Date      :     2018-07-25
   Created By        :     Kanchan kumari
   Purpose           :     This stored procedure retrives current week and week details
   Change History    :
   --------------------------------------------------------------------------
	   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
      EXEC Proc_GetShiftMappingDetails @UserId=2421, @StartDate='2018-11-25',@EndDate='2018-12-25',@IsPreviousMonthDate = 0
***/
ALTER PROC [dbo].[Proc_GetShiftMappingDetails]
(
  @UserId INT
 ,@StartDate DATE
 ,@EndDate DATE
 ,@IsPreviousMonthDate BIT
)
AS
BEGIN
SET FMTONLY OFF;
	IF OBJECT_ID('tempdb..#TempWeek') IS NOT NULL
	DROP TABLE #TempWeek

	IF OBJECT_ID('tempdb..#TempUserData') IS NOT NULL
	DROP TABLE #TempUserData 
		
	IF OBJECT_ID('tempdb..#TempShiftCalender') IS NOT NULL
	DROP TABLE #TempShiftCalender

	CREATE TABLE #TempWeek
	(
	 [StartDate] [date] NOT NULL
	,[EndDate] [date] NOT NULL
	,[WeekNo] [int] NOT NULL
	,DateInfo DATE NULL
	)

	DECLARE @NewStartDate DATE , @NewEndDate DATE
	SET @NewStartDate = @StartDate
	SET @NewEndDate = @EndDate

	WHILE(@StartDate<=@EndDate)
	BEGIN
		INSERT INTO #TempWeek([StartDate],[EndDate],[WeekNo])
		EXEC [spFetchWeekMap] @UserId,@StartDate
		UPDATE #TempWeek SET DateInfo=@StartDate WHERE DateInfo IS NULL
		SET @StartDate = (SELECT DATEADD(d,1,@StartDate))
	END

	CREATE TABLE #TempUserData
	(
	UserId INT,
	DateId BIGINT,
	StatusId INT,
	StatusCode VARCHAR(10) 
	)
	INSERT INTO #TempUserData
		SELECT  TD.CreatedBy AS UserId,
				TD.DateId,
				CASE WHEN LS.StatusCode = 'PA' AND TD.LastModifiedBy IS NOT NULL AND TD.LastModifiedDate IS NOT NULL THEN 3 --approved
				WHEN LS.StatusCode = 'AP' THEN 3 --approved 
				WHEN LS.StatusCode = 'PA' AND TD.LastModifiedBy IS NULL AND TD.LastModifiedDate IS  NULL THEN 2 --pending
				END AS StatusId,
				CASE WHEN LS.StatusCode = 'PA' AND TD.LastModifiedBy IS NOT NULL AND TD.LastModifiedDate IS NOT NULL THEN 'AP'
				WHEN LS.StatusCode = 'AP' THEN 'AP'
				WHEN LS.StatusCode = 'PA' AND TD.LastModifiedBy IS  NULL AND TD.LastModifiedDate IS  NULL THEN 'PA'
				END AS StatusCode
				FROM DateWiseLnsa TD 
				INNER JOIN LNSAStatusMaster LS ON TD.StatusId =LS.StatusId
				WHERE TD.CreatedBy = @UserId AND (LS.StatusCode='PA' OR LS.StatusCode = 'AP')
	
  CREATE TABLE #TempShiftCalender
   (  
      [MappingStartDate] VARCHAR(20) NOT NULL,
	  [MappingEndDate] VARCHAR(20) NOT NULL,
	  [DateId] BIGINT NOT NULL
	 ,[WeekNo] BIGINT NOT NULL
	 ,[Month] VARCHAR(20) NOT NULL
	 ,[Year] INT NOT NULL
	 ,[DateInt] INT NOT NULL
	 ,[Day] VARCHAR(20) NOT NULL
	 ,FullDate VARCHAR(50) NOT NULL
	 ,IsApplied BIT NOT NULL
	 ,IsApproved BIT NOT NULL
	 ,IsLNSAEnabled BIT  
   )
   INSERT INTO #TempShiftCalender([MappingStartDate],[MappingEndDate],[DateId],[WeekNo],[Month],[Year],[DateInt],[Day],FullDate,
                            IsApplied,IsApproved)
   SELECT  
           CONVERT(VARCHAR(15),@NewStartDate,106)    AS [MappingStartDate],
           CONVERT(VARCHAR(15),@NewEndDate,106)                AS [MappingEndDate],
           DM.DateId                                        AS [DateId],
           T.WeekNo                                         AS  WeekNo,
           Convert(char(3), T.DateInfo, 0)	                AS [Month], 
		   CAST(DATEPART(yyyy,T.DateInfo) AS INT)			AS [Year],
		   CAST(DATEPART(d,T.DateInfo) AS INT)				AS [DateInt], 
		   DM.[Day]                                         AS [Day],
		   CONVERT(VARCHAR(15),T.DateInfo,106)              AS FullDate,
		   CASE WHEN TD.StatusCode='PA' OR TD.StatusCode='AP' THEN 1
		        ELSE 0 END                                  AS IsApplied,
           CASE WHEN TD.StatusCode ='AP' THEN 1
		       ELSE 0 END                                   AS IsApproved
		 FROM #TempWeek T
		 JOIN DateMaster DM ON T.DateInfo=DM.[Date]
		 LEFT JOIN #TempUserData TD ON DM.[DateId]=TD.DateId 
		 ORDER BY DM.DateId

		  UPDATE TC SET TC.IsLNSAEnabled = EL.IsEligible FROM #TempShiftCalender TC
		  JOIN (SELECT DateId,IsEligible FROM Fn_GetEligibleUserForLNSA (@UserId, @NewStartDate, @NewEndDate, @IsPreviousMonthDate)) EL
		  ON TC.DateId = EL.DateId 

		  SELECT [DateId],[WeekNo],[Month],[Year],[DateInt],[Day],FullDate,IsApplied,
                 IsApproved,[MappingStartDate],[MappingEndDate], IsLNSAEnabled
	      FROM #TempShiftCalender
END





GO
/****** Object:  StoredProcedure [dbo].[spGetAttendanceForUserOnDashboard]    Script Date: 05-02-2019 18:45:45 ******/
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
   Created By        :    Kanchan Kumari
   Purpose           :    To get user attendance
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   25 Jan 2019     kanchan kumari         if any leave is applied then show leave
                                          even if attendance is there for the user
										  and applied check for legitimateleave table 
   --------------------------------------------------------------------------
   28 Jan 2019     kanchan kumari         fetch weekend date 

   Test Cases        :
   --------------------------------------------------------------------------
   EXEC  [dbo].[spGetAttendanceForUserOnDashboard]
	 @UserId = 2432
	,@StartDate = '2019-01-01'
   ,@EndDate = '2019-01-31'
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
	CREATE TABLE #UserDateMapping (
		[UserId] [int] NOT NULL
		,[DateId] [bigint] NOT NULL
		,[Date] [date] NOT NULL
		,[Day] [varchar](20) NOT NULL
	)
	 
	CREATE TABLE #FinalAttendanceData (
		[UserId] [int] NOT NULL
		,[DateId] [bigint] NOT NULL
		,[Date] [date] NOT NULL
		,[WeekNo] INT NOT NULL
	    ,[IsWeekend] BIT NOT NULL 
	    ,[IsNormalWeek] BIT NOT NULL DEFAULT(1)
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
		[UserId],[DateId],[Date], [WeekNo], [IsWeekend], [DisplayDate],[InTime],[OutTime],[TotalTime],[IsNightShift]
	)
	SELECT @UserId, M.[DateId], M.[Date], (SELECT WeekNo FROM [dbo].[FetchDateAndWeekNo](M.[Date])), DM.IsWeekend
		,CONVERT ([varchar](11), M.[Date], 106) + ' (' + SUBSTRING(M.[Day], 1, 3) + ')'
		,CONVERT(VARCHAR(20),ISNULL(A.[UserGivenInTime], A.[SystemGeneratedInTime]),106)+' '+FORMAT(ISNULL(A.[UserGivenInTime], A.[SystemGeneratedInTime]),'hh:mm tt') AS [InTime]
		,CONVERT(VARCHAR(20),ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]),106)+' '+FORMAT(ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]),'hh:mm tt') AS [OutTime]
		,CONVERT(VARCHAR(5), ISNULL(A.[UserGivenTotalWorkingHours], A.[SystemGeneratedTotalWorkingHours]), 108) AS [TotalTime]
		,A.IsNightShift
	FROM [dbo].[DateWiseAttendance] A WITH (NOLOCK)
	RIGHT JOIN #UserDateMapping M ON M.[DateId] = A.[DateId] AND M.[UserId] = A.[UserId] AND  A.IsActive = 1 AND A.IsDeleted = 0
    INNER JOIN [dbo].[DateMaster] DM WITH (NOLOCK) ON M.[Date] = DM.[Date]
	
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

	--update holidays ---------------
	UPDATE T SET
		T.[InTime] = 'Holiday'
		,T.[OutTime] = 'Holiday'
		,T.[TotalTime] = H.[Holiday]
	FROM #FinalAttendanceData T
	INNER JOIN [dbo].[ListofHoliday] H WITH (NOLOCK) ON H.[DateId] = T.[DateId]
	WHERE T.[InTime] IS NULL 

	------------Update users weekend ------------------------
   CREATE TABLE #TempCalenderRoaster
	(
	 [UserId] INT NOT NULL,
	 [Date] DATE,
	 [WeekNo] INT NOT NULL
	)
    ----insert data from employeewiseweekoff -------------------
	INSERT INTO #TempCalenderRoaster (UserId, [Date], [WeekNo])
	SELECT UserId, DM.[Date],(SELECT WeekNo FROM [dbo].[FetchDateAndWeekNo](DM.[Date]))
	FROM EmployeeWiseWeekOff E JOIN DateMaster DM ON E.[WeekOffDateId] = DM.[DateId]
	WHERE IsActive = 1

	 ----update [IsNormalWeek] of #UserDateMapping -------------------
	UPDATE U SET U.[IsNormalWeek] = 0 
	--SELECT U.* 
	FROM #FinalAttendanceData U
	JOIN (SELECT UserId, WeekNo FROM #TempCalenderRoaster 
	GROUP BY UserId, WeekNo) N
	ON U.[UserId] = N.[UserId] AND U.[WeekNo] = N.[WeekNo]

	 --update [IsWeekend] for special user
	UPDATE #FinalAttendanceData SET [IsWeekend] = 0 WHERE [IsWeekend] = 1 AND [IsNormalWeek] = 0

	---update week off data --------------------
      UPDATE #FinalAttendanceData 
	  SET [InTime] = CASE WHEN [InTime] = 'NA' OR [InTime] IS NULL  THEN 'WeekOff' ELSE [InTime] END 
	     ,[OutTime] = CASE WHEN [OutTime] = 'NA' OR [InTime] IS NULL  THEN 'WeekOff' ELSE [InTime] END 
	     ,[TotalTime] = CASE WHEN [TotalTime] = 'NA' OR [TotalTime] IS NULL  THEN 'WeekOff' ELSE [InTime] END 
      WHERE IsWeekend = 1

-------------------------------------------------------------
	--------update leave --------------
	UPDATE T SET
		T.[InTime] = CASE  WHEN LT.[ShortName] = 'WFH' THEN 'WFH' WHEN LT.[ShortName] = 'LWP' THEN 'LWP' ELSE 'Leave' END
		,T.[OutTime] = CASE  WHEN LT.[ShortName] = 'WFH' THEN 'WFH'WHEN LT.[ShortName] = 'LWP' THEN 'LWP' ELSE 'Leave' END
		,T.[TotalTime] = CASE  WHEN LT.[ShortName] = 'WFH' THEN 'WFH' WHEN LT.[ShortName] = 'LWP' THEN 'LWP' ELSE 'Leave' END--LT.[ShortName]
	FROM #FinalAttendanceData T
	INNER JOIN [dbo].[DateWiseLeaveType] L WITH (NOLOCK) ON L.[DateId] = T.[DateId]         
	INNER JOIN [dbo].[LeaveRequestApplication] A WITH (NOLOCK) ON A.[LeaveRequestApplicationId] = L.[LeaveRequestApplicationId] AND A.[UserId] = T.[UserId]
	INNER JOIN [dbo].[LeaveTypeMaster] LT WITH (NOLOCK) ON LT.[TypeId] = L.[LeaveTypeId]
	WHERE 
	--T.[InTime] IS NULL AND 
	A.[IsActive] = 1 AND A.[IsDeleted] = 0 AND A.[StatusId] > 0

	------------ outing ------------------------
	UPDATE T SET
      T.[InTime] = 'Outing'
     ,T.[OutTime] = 'Outing'
     ,T.[TotalTime] = LT.[OutingTypeName]
   FROM  #FinalAttendanceData T
         INNER JOIN [dbo].[OutingRequestDetail] L WITH (NOLOCK) ON L.[DateId] = T.[DateId]         
         INNER JOIN [dbo].[OutingRequest] A WITH (NOLOCK) ON A.[OutingRequestId] = L.[OutingRequestId] AND A.[UserId] = T.[UserId]
         INNER JOIN [dbo].[OutingType] LT WITH (NOLOCK) ON LT.[OutingTypeId] = A.[OutingTypeId]
   WHERE 
   --T.[InTime] IS NULL AND
    A.[IsActive] = 1 AND A.[IsDeleted] = 0 AND L.[StatusId] < 6

	---update legitimate leave --------------------
   UPDATE T SET
      T.[InTime] = 'Leave'
     ,T.[OutTime] = 'Leave'
     ,T.[TotalTime] = 'Leave'
   FROM
      #FinalAttendanceData T
         INNER JOIN [dbo].[LegitimateLeaveRequest] L WITH (NOLOCK) ON T.[DateId] = L.[DateId] AND T.[UserId] = L.[UserId]         
   WHERE 
   --T.[InTime] IS NULL AND 
   L.[StatusId] = 5 --when change request is verified by HR  ---legitimateLeaveStatus

	SELECT 
		F.[DisplayDate] AS [Date]
		,ISNULL(F.[InTime], 'NA') AS [InTime]
		,ISNULL(F.[OutTime], 'NA') AS [OutTime]
		,ISNULL(F.[TotalTime], 'NA') AS [LoggedInHours]
		,IsNightShift, IsApproved, IsPending,[IsWeekend]
	FROM #FinalAttendanceData F
	Group by F.[InTime],F.[OutTime],F.[DisplayDate], F.[TotalTime],IsNightShift,IsApproved,IsPending,F.[Date],[IsWeekend]
	ORDER BY F.[Date], F.[InTime] DESC
END
GO
/****** Object:  StoredProcedure [dbo].[spGetAttendanceRegisterForSupportingStaffMembers]    Script Date: 05-02-2019 18:45:45 ******/
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
	 ,[StaffUserId] INT NOT NULL
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
	 ,[StaffUserId]
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
	 ,M.[StaffUserId]
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
	 ,F.[StaffUserId]          
     ,F.[InTime]               AS [InTime]
     ,F.[OutTime]              AS [OutTime]
     ,F.[TotalTime]            AS [LoggedInHours]
	 ,F.[IsNightShift]         AS [IsNightShift]
   FROM #FinalAttendanceData F
   ORDER BY F.[Date], F.[InTime]
END

GO
/****** Object:  StoredProcedure [dbo].[spGetUserAppliedLeave]    Script Date: 05-02-2019 18:45:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetUserAppliedLeave]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGetUserAppliedLeave] AS' 
END
GO
/***
   Created Date      :     2016-01-27
   Created By        :     Shubhra Upadhyay
   Purpose           :     This stored procedure retrives details for leave either pending for approval or is appoved for user provided
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   19-Apr-2018	     Mimansa Agrawal    Added financial year as filter
   --------------------------------------------------------------------------
   21 jan 2019       Kanchan Kumari      fetch data for outing request
   --------------------------------------------------------------------------
   5 feb 2019        Kanchan Kumari      fetch data for Lnsa request
   Test Cases        :
   --------------------------------------------------------------------------
   EXEC [dbo].[spGetUserAppliedLeave] 
		@UserId = 2432
		,@Year=2018
	    ,@IsWFHData = 1
		,@LeaveType ='LNSA'
***/

ALTER PROCEDURE [dbo].[spGetUserAppliedLeave] 
(
   @UserID [int],
   @Year [int] = null,
   @IsWFHData [bit] = 0,
   @IsOuting [bit] = 0,
   @IsLnsa [bit] = 0
)
  AS
BEGIN
	SET NOCOUNT ON;
	SET FMTONLY OFF;

	IF OBJECT_ID('tempdb..#TempUserAppliedLeave') IS NOT NULL
	DROP TABLE #TempUserAppliedLeave

	DECLARE @StartDate [date], @EndDate [date], @AdminId int = 1,@IsApplied Int, @JoiningDate [DATE]
	SELECT @JoiningDate = [JoiningDate] FROM [dbo].[UserDetail] WITH (NOLOCK) WHERE [UserId] = @UserID
	 
	IF (@Year IS NULL OR @Year =0)
		SET @Year = DATEPART(YYYY, GETDATE())

	SELECT @StartDate = dateadd(Month,0,cast(concat(@Year,'-04-01') as date)),
			@EndDate = dateadd(Year,1,cast(concat(@Year,'-03-31') as date)) 
	
	IF(DATEPART(YYYY,@JoiningDate)=DATEPART(YYYY, @StartDate) AND DATEPART(mm,@JoiningDate)<DATEPART(mm,@StartDate))
	SELECT @StartDate = @JoiningDate

	CREATE TABLE #TempUserAppliedLeave
	(
	 [FetchLeaveType] VARCHAR(20),
	 [ApplyDate] DATETIME NOT NULL,
	 [LeaveRequestApplicationId] INT NOT NULL,
	 [FromDate] DATE NOT NULL,
	 [TillDate] DATE NOT NULL,
	 [LeaveInfo] VARCHAR(50),
	 [Reason] VARCHAR(500),
	 [Status] VARCHAR(10),
	 [StatusFullForm] VARCHAR(100),
	 [IsLegitimateApplied] BIT NOT NULL,
	 [Remarks] VARCHAR(500),
	 [LeaveCount] float,
	 [CreatedBy] INT NOT NULL
	)


IF(@IsWFHData=0)
BEGIN
    INSERT INTO #TempUserAppliedLeave
	SELECT 
	    'LEAVE' AS [FetchLeaveType]
		,LR.[CreatedDate]				AS [ApplyDate]
		,LR.[LeaveRequestApplicationId]	AS [LeaveRequestApplicationId]
		,DM1.[Date]						AS [FromDate]
		,DM2.[Date]						AS [TillDate]
		,CASE WHEN LR.[LeaveCombination] LIKE '%ML%' THEN CAST(LR.[LeaveCombination] AS [varchar](8)) + ' (' + LR.[LeaveCombination] + ')'
		 ELSE CAST(LR.[NoOfWorkingDays] AS [varchar](3)) + ' (' + LR.[LeaveCombination] + ')'	END AS [LeaveInfo]
		,LR.[Reason]	AS [Reason]
		,LS.[StatusCode] AS [Status]
		,CASE LS.[StatusCode] 
			WHEN 'RJ' THEN LS.[Status] + ' by ' + UD.[FirstName] + ' ' + UD.[LastName]
			WHEN 'PA' THEN LS.[Status] + ' with ' + UD.[FirstName] + ' ' + UD.[LastName]
         ELSE LS.[Status]
		 END AS [StatusFullForm]
		,CASE WHEN F.UserId IS NULL THEN CAST (0 AS [BIT])  ELSE CAST (1 AS [BIT]) END	AS [IsLegitimateApplied]
		,CASE 
			WHEN LS.[StatusCode] = 'CA' THEN LS.[Status]
			WHEN RH.[ApproverRemarks] IS NULL THEN ''
			WHEN RH.[ApproverRemarks] = '' THEN UD1.[FirstName] + ' ' + UD1.[LastName] + ': Approved'
			WHEN (RH.[ApproverId] = @AdminId AND RH.[CreatedBy] = @AdminId) THEN RH.[ApproverRemarks]
			ELSE UD1.[FirstName] + ' ' + UD1.[LastName] + ': ' + RH.[ApproverRemarks]                                
		 END AS [Remarks]
		,LR.[NoOfWorkingDays] AS [LeaveCount]
		,LR.[CreatedBy]
	FROM 
      [dbo].[LeaveRequestApplication] LR WITH (NOLOCK)
	      INNER JOIN [dbo].[LeaveStatusMaster] LS WITH (NOLOCK) ON LR.[StatusId] = LS.StatusId
	      INNER JOIN [dbo].[DateMaster] DM1 WITH (NOLOCK) ON LR.[FromDateId] = DM1.[DateId]
	      INNER JOIN [dbo].[DateMaster] DM2 WITH (NOLOCK) ON LR.[TillDateId] = DM2.[DateId]
          LEFT JOIN [dbo].[UserDetail] UD ON LR.[ApproverId] = UD.[UserId]
		  LEFT JOIN (
					SELECT UserId, DateId
					FROM [LegitimateLeaveRequest]    ----LegitimateLeaveStatus
					WHERE UserId = @UserId AND StatusId <= 5 --not rejected or cancelled
					GROUP BY UserId, DateId
				   ) F
				ON F.UserId = LR.UserId AND F.DateId = LR.FromDateId 
	     INNER JOIN 
            (
               SELECT LDA.[LeaveRequestApplicationId], MAX(LDA.[LeaveRequestApplicationDetailId]) AS [LeaveRequestApplicationDetailId]                     
               FROM [dbo].[LeaveRequestApplicationDetail] LDA WITH (NOLOCK) 
               INNER JOIN [dbo].[LeaveTypeMaster] T WITH (NOLOCK) ON LDA.[LeaveTypeId] = T.[TypeId]
               WHERE T.[ShortName] != 'WFH'
               GROUP BY LDA.[LeaveRequestApplicationId]
            ) LDA ON LR.[LeaveRequestApplicationId] = LDA.[LeaveRequestApplicationId]
		  LEFT JOIN
           (
            SELECT H.[LeaveRequestApplicationId], H.[ApproverId], H.[ApproverRemarks], H.[CreatedBy]
            FROM [dbo].[LeaveHistory] H WITH (NOLOCK)
            INNER JOIN
                  (
                     SELECT LH.[LeaveRequestApplicationId] AS [LeaveRequestApplicationId],MAX(LH.[CreatedDate]) AS [RecentTime]
                     FROM [dbo].[LeaveHistory] LH WITH (NOLOCK)
                     GROUP BY LH.[LeaveRequestApplicationId]
                  ) RH ON H.[CreatedDate] = RH.[RecentTime] AND H.[LeaveRequestApplicationId] = RH.[LeaveRequestApplicationId]
         ) RH ON RH.[LeaveRequestApplicationId] = LR.[LeaveRequestApplicationId]
         LEFT JOIN 
			[dbo].[UserDetail] UD1 WITH (NOLOCK) ON UD1.[UserId] = RH.[CreatedBy]--RH.[ApproverId]
	WHERE 
      LR.[UserId] = @UserId
      AND DM1.[Date] BETWEEN @StartDate AND @EndDate	 
   ORDER BY LR.[CreatedDate] DESC, DM1.[Date] DESC 
   END
   IF(@IsWFHData=1)
   BEGIN
       INSERT INTO #TempUserAppliedLeave
       SELECT 
	    'LEAVE' AS [FetchLeaveType]
		,LR.[CreatedDate] AS [ApplyDate]
		,LR.[LeaveRequestApplicationId]	AS [LeaveRequestApplicationId]
		,DM1.[Date]	AS [FromDate]
		,DM2.[Date]	AS [TillDate]
		,CASE WHEN LR.[LeaveCombination] LIKE '%ML%' THEN CAST(LR.[LeaveCombination] AS [varchar](8)) + ' (' + LR.[LeaveCombination] + ')'
		WHEN LR.[LeaveCombination] IS NULL THEN  'WFH'
		 ELSE CAST(LR.[NoOfWorkingDays] AS [varchar](3)) + ' (' + LR.[LeaveCombination] + ')'	END AS [LeaveInfo]
		,LR.[Reason]	AS [Reason]
		,LS.[StatusCode]	AS [Status]
		,CASE LS.[StatusCode] 
			WHEN 'RJ' THEN LS.[Status] + ' by ' + UD.[FirstName] + ' ' + UD.[LastName]
			WHEN 'PA' THEN LS.[Status] + ' with ' + UD.[FirstName] + ' ' + UD.[LastName]
         ELSE LS.[Status]
		 END AS [StatusFullForm]
		,CASE WHEN F.UserId IS NULL THEN CAST (0 AS [BIT])  ELSE CAST (1 AS [BIT]) END	AS [IsLegitimateApplied]
		,CASE 
			WHEN LS.[StatusCode] = 'CA' THEN LS.[Status]
			WHEN RH.[ApproverRemarks] IS NULL THEN ''
			WHEN RH.[ApproverRemarks] = '' THEN UD1.[FirstName] + ' ' + UD1.[LastName] + ': Approved'
			WHEN (RH.[ApproverId] = @AdminId AND RH.[CreatedBy] = @AdminId) THEN RH.[ApproverRemarks]
			ELSE UD1.[FirstName] + ' ' + UD1.[LastName] + ': ' + RH.[ApproverRemarks]                                
		 END AS [Remarks]
		,LR.[NoOfWorkingDays] AS [LeaveCount]
		,LR.[CreatedBy]
    	FROM 
        [dbo].[LeaveRequestApplication] LR WITH (NOLOCK)
	      INNER JOIN [dbo].[LeaveStatusMaster] LS WITH (NOLOCK) ON LR.[StatusId] = LS.StatusId
	      INNER JOIN [dbo].[DateMaster] DM1 WITH (NOLOCK) ON LR.[FromDateId] = DM1.[DateId]
	      INNER JOIN [dbo].[DateMaster] DM2 WITH (NOLOCK) ON LR.[TillDateId] = DM2.[DateId]
          LEFT JOIN [dbo].[UserDetail] UD ON LR.[ApproverId] = UD.[UserId]
		  LEFT JOIN (
					SELECT UserId, DateId
					FROM [LegitimateLeaveRequest]    ----LegitimateLeaveStatus
					WHERE UserId = @UserId AND StatusId <= 5 --not rejected or cancelled
					GROUP BY UserId, DateId
				   ) F
				ON F.UserId = LR.UserId AND F.DateId = LR.FromDateId 
		  LEFT JOIN
           (
           SELECT H.[LeaveRequestApplicationId], H.[ApproverId], H.[ApproverRemarks], H.[CreatedBy]
            FROM [dbo].[LeaveHistory] H WITH (NOLOCK)
            INNER JOIN
                  (
                     SELECT LH.[LeaveRequestApplicationId] AS [LeaveRequestApplicationId],MAX(LH.[CreatedDate]) AS [RecentTime]
                     FROM [dbo].[LeaveHistory] LH WITH (NOLOCK)
                     GROUP BY LH.[LeaveRequestApplicationId]
                  ) RH ON H.[CreatedDate] = RH.[RecentTime] AND H.[LeaveRequestApplicationId] = RH.[LeaveRequestApplicationId]
         ) RH ON RH.[LeaveRequestApplicationId] = LR.[LeaveRequestApplicationId]
         LEFT JOIN 
			[dbo].[UserDetail] UD1 WITH (NOLOCK) ON UD1.[UserId] = RH.[CreatedBy]--RH.[ApproverId]
	WHERE 
      LR.[UserId] = @UserId
      AND DM1.[Date] BETWEEN @StartDate AND @EndDate	 
   ORDER BY  LR.[CreatedDate] DESC, DM1.[Date] DESC 
   END

   IF(@IsOuting = 1)
   BEGIN
    INSERT INTO #TempUserAppliedLeave
	SELECT 
	    'OUTING' AS [FetchLeaveType]
	    ,R.CreatedDate AS [ApplyDate]
		,R.[OutingRequestId] AS [LeaveRequestApplicationId]
		,DM1.[Date] AS [FromDate]
		,DM2.[Date] AS [TillDate]
        ,T.[OutingTypeName] AS [LeaveInfo]
	    ,R.[Reason] AS [Reason]	  
	    ,S.[StatusCode] AS [Status]
	    ,CASE WHEN S.StatusCode IN ('CA', 'RJM', 'RJH', 'VD', 'AP') THEN S.[Status] + ' by ' + CM.[FirstName] + ' ' + CM.[LastName]
	        ELSE S.[Status] + ' with ' + UD.[FirstName] + ' ' + UD.[LastName] END AS [StatusFullForm]
	    ,0 AS [IsLegitimateApplied]
	    ,APR.FirstName + ' ' + APR.LastName + ': ' +  REM.[Remarks] AS [Remarks]                                                                                                                 
	    ,CASE WHEN DM1.[Date] = DM2.[Date] THEN 1 ELSE (R.TillDateId - R.FromDateId+1) END AS [LeaveCount]
	    ,R.CreatedById AS CreatedBy
	FROM [dbo].[OutingRequest] R WITH (NOLOCK)
	INNER JOIN [dbo].[OutingRequestStatus] S WITH (NOLOCK) ON R.[StatusId] = S.StatusId
	INNER JOIN [dbo].[OutingType] T WITH (NOLOCK) ON R.[OutingTypeId] = T.[OutingTypeId]
	INNER JOIN [dbo].[DateMaster] DM1 WITH (NOLOCK) ON R.[FromDateId] = DM1.DateId
	INNER JOIN [dbo].[DateMaster] DM2 WITH (NOLOCK) ON R.[TillDateId] = DM2.[DateId]
	LEFT JOIN [dbo].[UserDetail] UD WITH (NOLOCK) ON R.[NextApproverId] = UD.[UserId] 
	LEFT JOIN [dbo].[UserDetail] CM WITH (NOLOCK) ON R.[ModifiedById] = CM.UserId 
	INNER JOIN (SELECT OutingRequestId, MAX(OutingRequestHistoryId) AS OutingRequestHistoryId FROM OutingRequestHistory GROUP BY OutingRequestId) ORH
			ON R.OutingRequestId=ORH.OutingRequestId	
	INNER JOIN [dbo].[OutingRequestHistory] REM WITH (NOLOCK) ON ORH.OutingRequestHistoryId=REM.OutingRequestHistoryId
	INNER JOIN [dbo].[UserDetail] APR WITH (NOLOCK) ON REM.CreatedById=APR.UserId 
	WHERE R.[UserId] = @UserID AND R.[UserId] != 1 
	AND DM1.[Date] BETWEEN @StartDate AND @EndDate AND S.[StatusId] <=5 ORDER BY R.CreatedDate DESC 
   END

    IF(@IsLnsa = 1)
   BEGIN
       INSERT INTO #TempUserAppliedLeave
	   SELECT 
	     'LNSA' AS [FetchLeaveType]
		,R.CreatedDate AS [ApplyDate]
	    ,R.RequestId AS [LeaveRequestApplicationId]
        ,D.[Date]            AS [FromDate]
        ,M.[Date]            AS [TillDate]
        ,'LNSA ('+ CAST(R.[TotalNoOfDays]AS VARCHAR(20)) + ' LNSA)' AS [LeaveInfo]  
        ,R.[Reason]          
		,LS.StatusCode AS [Status]
        ,CASE WHEN LS.StatusCode = 'PA' THEN  LS.[Status]+' with '+UD.FirstName+' '+UD.LastName 
		  ELSE LS.[Status]+' by '+VW.FirstName+' '+VW.LastName END AS [StatusFullForm]
		,0 AS [IsLegitimateApplied]
		,R.[ApproverRemarks] AS [Remarks]
		,R.[TotalNoOfDays]  AS [LeaveCount]
		,R.CreatedBy AS CreatedBy
      FROM
         [dbo].[RequestLnsa] R WITH (NOLOCK) -- LNSAStatusMaster
		    INNER JOIN [dbo].[DateWiseLnsa] DW WITH (NOLOCK) ON R.RequestId = DW.RequestId
			INNER JOIN [dbo].[DateMaster] DM WITH (NOLOCK) ON DW.DateId = DM.[DateId]
		    INNER JOIN [dbo].[DateMaster] D WITH (NOLOCK) ON D.[DateId] = R.[FromDateId]
            INNER JOIN [dbo].[DateMaster] M WITH (NOLOCK) ON M.[DateId] = R.[TillDateId]
		    LEFT JOIN [dbo].[UserDetail] UD WITH (NOLOCK) ON R.ApproverId = UD.UserId
		    LEFT JOIN [dbo].[UserDetail] VW WITH (NOLOCK) ON R.[LastModifiedBy] = VW.UserId
			INNER JOIN [dbo].[LNSAStatusMaster] LS WITH (NOLOCK) ON R.StatusId = LS.StatusId
      WHERE
         R.[CreatedBy] = @UserId AND  R.[CreatedBy] != 1 AND DM.[Date] BETWEEN @StartDate AND @EndDate
		 AND R.[StatusId] <=5 ORDER BY R.CreatedDate DESC 
   END

   SELECT [FetchLeaveType], [ApplyDate], [LeaveRequestApplicationId], [FromDate], [TillDate], [LeaveInfo] ,
	      [Reason], [Status], [StatusFullForm], [IsLegitimateApplied], [Remarks], [LeaveCount], [CreatedBy] 
   FROM #TempUserAppliedLeave 
   GROUP BY [FetchLeaveType], [ApplyDate], [LeaveRequestApplicationId], [FromDate], [TillDate], [LeaveInfo] ,
	        [Reason], [Status], [StatusFullForm], [IsLegitimateApplied], [Remarks], [LeaveCount], [CreatedBy] 
   ORDER BY [ApplyDate] DESC, [FromDate] DESC
   END

GO
/****** Object:  StoredProcedure [dbo].[spUpdateEmployeeLeaveBalanceByHR]    Script Date: 05-02-2019 18:45:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spUpdateEmployeeLeaveBalanceByHR]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spUpdateEmployeeLeaveBalanceByHR] AS' 
END
GO
/***
   Created Date      :     2016-01-20
   Created By        :     Shubhra Upadhyay
   Purpose           :     This stored procedure Update employee Leave Balance
      
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   5-Feb-2019        Kanchan Kumari       Updated marital status if ML or PL(M)
                                          Credited to user
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   EXEC [dbo].[spUpdateEmployeeLeaveBalanceByHR]   
   @Type=1,
   @UserId = 24,
	@ClCount = 100,
	@PlCount = 100,
	@CompOffCount = 100,
	@LwpCount = 100,
	@Cloy = 1,
	@MlCount=1,
	@AllocationCount=0,
	@UpdatedBy = 2
            
***/

ALTER PROCEDURE [dbo].[spUpdateEmployeeLeaveBalanceByHR]
(
    @Type int,
	@UserId bigint,
	@ClCount float,
	@PlCount float,
	@CompOffCount float,
	@LwpCount float,
	@Cloy bit,
	@MlCount float,
	@AllocationCount int,
	@UpdatedBy bigint
)  

AS
BEGIN
SET NOCOUNT ON
DECLARE @GenderId INT
SET @GenderId=(SELECT GenderId FROM [dbo].[UserDetail] WHERE UserId=@UserId)
DECLARE @ExiClCount float,@ExiPlCount float,@ExiCompOffCount float,@ExiLwpCount float,@ExiCloy bit,@ExiMlCount float,@ExiPLMCount float
SET @ExiClCount= (SELECT [Count] FROM [dbo].[LeaveBalance] WHERE UserId=@UserId AND LeaveTypeId=1)
SET @ExiPlCount= (SELECT [Count] FROM [dbo].[LeaveBalance] WHERE UserId=@UserId AND LeaveTypeId=2)
SET @ExiCompOffCount= (SELECT [Count] FROM [dbo].[LeaveBalance] WHERE UserId=@UserId AND LeaveTypeId=4)
SET @ExiLwpCount= (SELECT [Count] FROM [dbo].[LeaveBalance] WHERE UserId=@UserId AND LeaveTypeId=3)
SET @ExiCloy= (SELECT [Count] FROM [dbo].[LeaveBalance] WHERE UserId=@UserId AND LeaveTypeId=8)
SET @ExiMlCount= (SELECT [Count] FROM [dbo].[LeaveBalance] WHERE UserId=@UserId AND LeaveTypeId=6)
SET @ExiPLMCount= (SELECT [Count] FROM [dbo].[LeaveBalance] WHERE UserId=@UserId AND LeaveTypeId=7)
IF(@ExiClCount!=@ClCount AND @Type=1)
BEGIN
INSERT INTO [dbo].[LeaveBalanceHistory] (RecordId,[Count],CreatedBy) SELECT L.RecordId,@ExiClCount,@UpdatedBy FROM [LeaveBalance] L WHERE UserId=@UserId AND LeaveTypeId=1
END
IF(@ExiPlCount!=@PlCount AND @Type=1)
BEGIN
INSERT INTO [dbo].[LeaveBalanceHistory] (RecordId,[Count],CreatedBy) SELECT L.RecordId,@ExiPlCount,@UpdatedBy FROM [LeaveBalance] L WHERE UserId=@UserId AND LeaveTypeId=2
END
IF(@ExiCompOffCount!=@CompOffCount AND @Type=1)
BEGIN
INSERT INTO [dbo].[LeaveBalanceHistory] (RecordId,[Count],CreatedBy) SELECT L.RecordId,@ExiCompOffCount,@UpdatedBy FROM [LeaveBalance] L WHERE UserId=@UserId AND LeaveTypeId=4
END
IF(@ExiLwpCount!=@LwpCount AND @Type=1)
BEGIN
INSERT INTO [dbo].[LeaveBalanceHistory] (RecordId,[Count],CreatedBy) SELECT L.RecordId,@ExiLwpCount,@UpdatedBy FROM [LeaveBalance] L WHERE UserId=@UserId AND LeaveTypeId=3
END
IF(@ExiCloy!=@Cloy AND @Type=1)
BEGIN
INSERT INTO [dbo].[LeaveBalanceHistory] (RecordId,[Count],CreatedBy) SELECT L.RecordId,@ExiCloy,@UpdatedBy FROM [LeaveBalance] L WHERE UserId=@UserId AND LeaveTypeId=8
END
IF(@ExiMlCount!=@MlCount AND @GenderId=2 AND @Type=2)
BEGIN
INSERT INTO [dbo].[LeaveBalanceHistory] (RecordId,[Count],CreatedBy) SELECT L.RecordId,@ExiMlCount,@UpdatedBy FROM [LeaveBalance] L WHERE UserId=@UserId AND LeaveTypeId=6
END
IF(@ExiPLMCount!=@MlCount AND @GenderId=1 AND @Type=2)
BEGIN
INSERT INTO [dbo].[LeaveBalanceHistory] (RecordId,[Count],CreatedBy) SELECT L.RecordId,@ExiPLMCount,@UpdatedBy FROM [LeaveBalance] L WHERE UserId=@UserId AND LeaveTypeId=7
END
IF(@Type=1)
BEGIN
UPDATE LB      
	SET         
      LB.[Count] = CASE
                     WHEN LM.[ShortName] = 'CL'  THEN @ClCount
                     WHEN LM.[ShortName] = 'PL' THEN @PlCount
                     WHEN LM.[ShortName] = 'COFF'  THEN @CompOffCount
                     WHEN LM.[ShortName] = 'LWP'  THEN @LwpCount
                     WHEN LM.[ShortName] = '5CLOY' AND @Cloy = 1  THEN 1
                     ELSE LB.[Count]
                   END
     ,LB.[LastModifiedBy] = @UpdatedBy
     ,LB.[LastModifiedDate] = GETDATE()

	FROM [dbo].[LeaveBalance] LB
      INNER JOIN [dbo].[LeaveTypeMaster] LM
         ON LB.[LeaveTypeId] = LM.[TypeId]
	WHERE LB.[UserId] = @UserId
   SELECT 1 AS Result
END
IF(@Type=2) -- ML/ PL(M)
BEGIN
	UPDATE LB      
	SET         
      LB.[Count] = CASE
                     WHEN LM.[ShortName] = 'ML' AND @GenderId= 2  AND @AllocationCount<2 THEN @MlCount
					 WHEN LM.[ShortName] = 'PL(M)' AND @GenderId=1 AND @AllocationCount<2  THEN @MlCount
					 ELSE LB.[Count]
                   END
     ,LB.[LastModifiedBy] = @UpdatedBy
	 ,LB.[AllocationFrequency]= CASE
	                            WHEN @AllocationCount<2 AND LM.[ShortName] = 'ML' AND @GenderId=2 
								THEN @AllocationCount + 1
								WHEN @AllocationCount<2 AND LM.[ShortName] = 'PL(M)' AND @GenderId=1 
								THEN @AllocationCount + 1
	                            ELSE
                                LB.[AllocationFrequency]
								END
     ,LB.[LastModifiedDate] = GETDATE()

	FROM [dbo].[LeaveBalance] LB
      INNER JOIN [dbo].[LeaveTypeMaster] LM
         ON LB.[LeaveTypeId] = LM.[TypeId]
	WHERE LB.[UserId] = @UserId

    ---update marital status of user
	UPDATE UserDetail SET MaritalStatusId = 2 --married
	WHERE UserId = @UserId

   SELECT 1 AS Result
END
END


GO
