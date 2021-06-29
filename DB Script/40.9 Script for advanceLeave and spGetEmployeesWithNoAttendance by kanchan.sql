--DROP TABLE AdvanceLeaveDetail
--DROP TABLE AdvanceLeave

CREATE TABLE AdvanceLeave
(
 AdvanceLeaveId BIGINT NOT NULL IDENTITY(1,1),
 UserId INT NOT NULL,
 FromDateId INT NOT NULL,
 TillDateId INT NOT NULL,
 Reason VARCHAR(500) NOT NULL,
 IsActive BIT NOT NULL,
 CreatedBy INT NOT NULL,
 CreatedDate DATETIME NOT NULL,
 LastModifiedBy INT NULL,
 LastModifiedDate DATETIME NULL,
 CONSTRAINT [PK_AdvanceLeave_AdvanceLeaveId] PRIMARY KEY CLUSTERED 
(
	[AdvanceLeaveId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[AdvanceLeave]  WITH CHECK ADD  CONSTRAINT [FK_AdvanceLeave_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([UserId])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[AdvanceLeave] CHECK CONSTRAINT [FK_AdvanceLeave_User]
GO

ALTER TABLE [dbo].[AdvanceLeave] ADD CONSTRAINT DF_AdvanceLeave_IsActive DEFAULT(1) FOR IsActive
GO

ALTER TABLE [dbo].[AdvanceLeave] ADD CONSTRAINT DF_AdvanceLeave_CreatedDate DEFAULT(GETDATE()) FOR CreatedDate
GO

CREATE TABLE AdvanceLeaveDetail
(
 AdvanceLeaveDetailId BIGINT NOT NULL IDENTITY(1,1),
 AdvanceLeaveId BIGINT NOT NULL,
 [DateId] INT NOT NULL,
 IsActive BIT NOT NULL,
 IsAdjusted BIT NOT NULL,
 AdjustedLeaveTypeId INT NULL,
 CreatedBy INT NOT NULL,
 CreatedDate DATETIME NOT NULL,
 LastModifiedBy INT NULL,
 LastModifiedDate DATETIME NULL,
 CONSTRAINT [PK_AdvanceLeaveDetail_AdvanceLeaveDetailId] PRIMARY KEY CLUSTERED 
(
	[AdvanceLeaveDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[AdvanceLeaveDetail]  WITH CHECK ADD  CONSTRAINT [FK_AdvanceLeaveDetail_AdvanceLeave_AdvanceLeaveId] FOREIGN KEY([AdvanceLeaveId])
REFERENCES [dbo].[AdvanceLeave] ([AdvanceLeaveId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AdvanceLeaveDetail] CHECK CONSTRAINT [FK_AdvanceLeaveDetail_AdvanceLeave_AdvanceLeaveId]
GO

ALTER TABLE AdvanceLeaveDetail ADD CONSTRAINT DF_AdvanceLeaveDetail_IsActive DEFAULT(1) FOR IsActive
GO

ALTER TABLE AdvanceLeaveDetail ADD CONSTRAINT DF_AdvanceLeaveDetail_IsAdjusted DEFAULT(0) FOR IsAdjusted
GO

ALTER TABLE AdvanceLeaveDetail ADD CONSTRAINT DF_AdvanceLeaveDetail_CreatedDate DEFAULT(GETDATE()) FOR CreatedDate
GO

 /***
   Created Date      :     2016-11-21
   Created By        :     Rakesh Gandhi
   Purpose           :     This stored procedure gets the date on which 
                           there is no data found for an employee in terms of attendance/leave or WFH
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   25 Sep 2018		Kanchan Kumari		 excluded out duty/tour data and replaced joins with vwActiveUsers
   --------------------------------------------------------------------------
    26 DEC 2018		Kanchan Kumari		 excluded LNSA Applied user and not eligible user and advanceleave applied user
   Test Cases        :
   --------------------------------------------------------------------------
   --- Test Case
         EXEC [dbo].[spGetEmployeesWithNoAttendance] @FromDate = '2018-11-25' ,@ToDate = '2018-12-24'
***/
ALTER PROCEDURE [dbo].[spGetEmployeesWithNoAttendance]
    @FromDate [date] 
   ,@ToDate [date]
AS
BEGIN
   SET NOCOUNT ON;
    IF OBJECT_ID('tempdb..#UserDateMapping') IS NOT NULL
	DROP TABLE #UserDateMapping

   --supplying a data contract
   IF 1 = 2 BEGIN
    SELECT
         CAST(null AS [date])        AS [Date]
        ,CAST(null AS [int])         AS [UserId]
        ,CAST(null AS [varchar](50)) AS [EmployeeName]
        ,CAST(null AS [varchar](50)) AS [MobileNo]
    WHERE 1 = 2  
   END

   --DECLARE @ToDate [date] = DATEADD(DD, -1, GETDATE())
    
	CREATE TABLE #UserDateMapping
	(
		[DateId] [bigint] NOT NULL
		,[Date] [date] NOT NULL
		,[UserId] [int] NOT NULL
	)

	INSERT INTO #UserDateMapping([DateId],[Date],[UserId])
	SELECT D.[DateId], D.[Date],U.[UserId]
	FROM [dbo].[DateMaster] D WITH (NOLOCK)
	CROSS JOIN [dbo].[vwActiveUsers] U WITH (NOLOCK)
	WHERE (D.[Date] BETWEEN @FromDate AND @ToDate) AND U.[JoiningDate] < @FromDate
	AND U.IsEligibleForLeave = 1 ---only eligible user

   -- delete management employees
	DELETE T
	FROM #UserDateMapping T WITH (NOLOCK)
	INNER JOIN [dbo].[ManagementEmployee] M WITH (NOLOCK) ON T.[UserId] = M.[UserId]

   -- delete entries for entries before date of joining
	DELETE T
	FROM #UserDateMapping T WITH (NOLOCK)
	INNER JOIN [dbo].[vwActiveUsers] U WITH (NOLOCK) ON T.[UserId] = U.[UserId]
	WHERE T.[Date] < U.[JoiningDate]

   -- delete enteries after date of termination
	--DELETE T
	--FROM #UserDateMapping T WITH (NOLOCK)
	--INNER JOIN [dbo].[UserDetail] U WITH (NOLOCK) ON T.[UserId] = U.[UserId]
	--WHERE T.[Date] > U.[TerminateDate]

 -- delete entries for employees on Out duty/tour Leave
	DELETE T
	FROM #UserDateMapping T WITH (NOLOCK)
	INNER JOIN [dbo].[OutingRequest] R WITH (NOLOCK) ON T.[UserId] =  R.[UserId] 
	INNER JOIN [dbo].[OutingRequestDetail] OD WITH (NOLOCK) ON R.[OutingRequestId] = OD.[OutingRequestId]
	INNER JOIN [dbo].[DateMaster] DM WITH (NOLOCK) ON OD.[DateId] = DM.[DateId]
	WHERE OD.[StatusId] <=5 --ie neither rejected nor cancelled  OutingRequestStatus

   -- delete entries for employees on leave or WFH
	DELETE T
	FROM #UserDateMapping T WITH (NOLOCK)
	INNER JOIN [dbo].[LeaveRequestApplication] L WITH (NOLOCK) ON T.[UserId] = L.[UserId] AND L.[StatusId] > 0--
	INNER JOIN [dbo].[DateWiseLeaveType] D WITH (NOLOCK) ON L.[LeaveRequestApplicationId] = D.[LeaveRequestApplicationId] AND T.[DateId] = D.[DateId]

   -- delete entries for weekend for exceptional employees
	DELETE T
	FROM #UserDateMapping T WITH (NOLOCK)
	INNER JOIN [dbo].[EmployeeWiseWeekOff] O WITH (NOLOCK) ON T.[UserId] = O.[UserId] 
			AND (DATEPART(DW, T.[Date]) = O.[WeekOffDay1] OR DATEPART(DW, T.[Date]) = O.[WeekOffDay2])

	-- delete entries for normal weekoffs
	DELETE T
	FROM #UserDateMapping T WITH (NOLOCK)
	LEFT JOIN [dbo].[EmployeeWiseWeekOff] O WITH (NOLOCK) ON T.[UserId] = O.[UserId]
	INNER JOIN [dbo].[DateMaster] D WITH (NOLOCK) ON T.[DateId] = D.[DateId] AND D.[IsWeekend] = 1
	WHERE O.[RecordId] IS NULL

	-- delete entries for holidays
	DELETE T
	FROM #UserDateMapping T WITH (NOLOCK)
	INNER JOIN [dbo].[ListofHoliday] H WITH (NOLOCK)
	ON T.[DateId] = H.[DateId]

	-- delete entries for employees available with temporary access cards
	DELETE T
	FROM #UserDateMapping T WITH (NOLOCK)
	INNER JOIN [dbo].[TempCardIssueDetail] I WITH (NOLOCK) 
		ON CONVERT([varchar](8), T.[Date], 112) = CONVERT([varchar](8), I.[IssueDate], 112) AND T.[UserId] = I.[EmployeeId]
               
	-- delete entries for employees for which attendance is available
	DELETE T
	FROM #UserDateMapping T WITH (NOLOCK)
	INNER JOIN [dbo].[DateWiseAttendance] D WITH (NOLOCK) ON T.[DateId] = D.[DateId] AND T.[UserId] = D.[UserId]

	-- delete entries for employees for which LNSA is applied 
	DELETE T
	FROM #UserDateMapping T WITH (NOLOCK)
	INNER JOIN [dbo].[DateWiseLNSA] D WITH (NOLOCK) ON T.[DateId] = D.[DateId] AND T.[UserId] = D.[CreatedBy]
	WHERE D.StatusId = 2 --pending for approval  --LNSAStatusMaster

	-- delete entries for employees whose entry are there in [AdvanceLeaveDetail]  table 
	DELETE T
	FROM #UserDateMapping T WITH (NOLOCK)
	INNER JOIN [dbo].[AdvanceLeaveDetail] D WITH (NOLOCK) ON T.DateId = D.DateId AND T.[UserId] = D.[CreatedBy] AND D.IsActive = 1

	-- delete entries for employees for which attendance is available for Asquare
	DELETE T
	FROM #UserDateMapping T WITH (NOLOCK)
	INNER JOIN [dbo].[DateWiseAttendanceASquare] D WITH (NOLOCK) ON T.[UserId] = D.[UserId]
	INNER JOIN [dbo].[DateMaster] DM WITH (NOLOCK) ON DM.[DateId] = D.[DateId] AND DM.[Date] BETWEEN @FromDate AND @ToDate

   SELECT 
      T.[Date]
	 ,U.EmployeeName 
	 ,RM.EmployeeName AS [RM]
	 ,U.EmployeeCode AS EmployeeId
	 ,CASE WHEN U.IsIntern=1 THEN 'Yes' ELSE 'No' END AS Intern
     ,U.[UserId]
     ,U.[MobileNumber] AS [MobileNo]
   FROM #UserDateMapping T WITH (NOLOCK)
   LEFT JOIN [dbo].[vwActiveUsers] U WITH (NOLOCK) ON T.[UserId] = U.[UserId]
   LEFT JOIN [dbo].[vwActiveUsers] RM WITH (NOLOCK) ON U.[RMId] = RM.[UserId]
   WHERE  U.UserId <> 1 AND U.IsEligibleForLeave = 1
   GROUP BY T.[Date], U.EmployeeName, RM.EmployeeName, U.EmployeeCode, U.IsIntern, U.[UserId], U.[MobileNumber]   
   ORDER BY T.[Date], U.EmployeeName
END