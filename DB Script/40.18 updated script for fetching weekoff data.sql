GO
/****** Object:  StoredProcedure [dbo].[Proc_GetEmployeeWeekData]    Script Date: 30-01-2019 15:48:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetEmployeeWeekData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetEmployeeWeekData]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetEmployeeWeekData]    Script Date: 30-01-2019 15:48:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetEmployeeWeekData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetEmployeeWeekData] AS' 
END
GO
/***
    Created Date      :     2019-01-15
   Created By        :     Mimansa Agrawal
   Purpose           :     This stored procedure fetches employee's week off detail
   Change History    :
   --------------------------------------------------------------------------
	   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
      EXEC Proc_GetEmployeeWeekData @LoginUserId=2203,@FromDate='2019-02-25',@TillDate='2019-03-03'
***/
ALTER PROC [dbo].[Proc_GetEmployeeWeekData]
(
 @LoginUserId INT 
,@FromDate DATE 
,@TillDate DATE 
)
AS
BEGIN
	SET FMTONLY OFF;
	SET NOCOUNT ON;

	DECLARE @FromDateId BIGINT, @TillDateId BIGINT

	SET @FromDateId = (SELECT DateId FROM DateMaster WHERE [Date]=@FromDate)
	SET @TillDateId = (SELECT DateId FROM DateMaster WHERE [Date]=@TillDate)

	IF OBJECT_ID('tempdb..#UserDateMapping') IS NOT NULL
	DROP TABLE #UserDateMapping
	IF OBJECT_ID('tempdb..#Emp') IS NOT NULL
    DROP TABLE #Emp
	CREATE TABLE #Emp(
      EmpId INT,
	  ManagerId INT
		)
	CREATE TABLE #UserDateMapping
	(
	 [DateId] [bigint] NOT NULL
	,[Date] [date] NOT NULL
	,[IsWeekend] BIT NOT NULL 
	,[UserId] [int] NOT NULL
	,[WeekNo] [INT] NOT NULL
	,[IsNormalWeek] BIT NOT NULL DEFAULT(1)
	)
	INSERT INTO #Emp ([EmpId],[ManagerId])
    EXEC [dbo].[spGetEmployeesReportingToUser] @LoginUserId, 0, 0;
	INSERT INTO #UserDateMapping([UserId],[DateId],[Date],[IsWeekend],[WeekNo])
	SELECT  U.[UserId], D.[DateId], D.[Date], D.[IsWeekend], (SELECT WeekNo FROM [dbo].[FetchDateAndWeekNo](D.[Date]))
	FROM [dbo].[DateMaster] D WITH (NOLOCK)
	CROSS JOIN [dbo].[UserDetail] U WITH (NOLOCK) 
	WHERE U.[UserId] IN (SELECT EmpId From #Emp) AND D.[Date] BETWEEN @FromDate AND @TillDate 

	 ----update [IsNormalWeek] of #UserDateMapping -------------------
	  UPDATE U SET U.[IsNormalWeek] = 0 FROM #UserDateMapping U 
	  INNER JOIN (
	             SELECT Q.[WeekNo], T.[UserId] 
				 FROM EmployeeWiseWeekOff T WITH (NOLOCK)
				 JOIN #UserDateMapping Q ON T.[UserId] = Q.[UserId] AND T.[WeekOffDateId] = Q.[DateId] 
				 WHERE T.[IsActive] = 1
				 GROUP BY T.[UserId], Q.[WeekNo]
				 ) N ON U.[UserId] = N.[UserId] AND U.[WeekNo] = N.[WeekNo]
    -------delete data where normal week----------------
				 ;WITH ExcludedUsers AS
				(
				 select * from #UserDateMapping
				 WHERE IsNormalWeek = 1
				 )
				DELETE FROM
				ExcludedUsers
     --delete entries of employees for which data is available in #TempCalenderRoaster-----
	DELETE U 
	FROM #UserDateMapping U WITH (NOLOCK) JOIN EmployeeWiseWeekOff T 
	ON U.[UserId] = T.[UserId] AND U.[DateId] = T.[WeekOffDateId] AND T.[IsActive]=1
	-----select week days of employees----------
    SELECT DateId,[Date],IsWeekend,UserId,WeekNo,IsNormalWeek FROM #UserDateMapping 
	--WHERE UserId IN (SELECT UserId FROM EmployeeWiseWeekOff WHERE WeekOffDateId BETWEEN @FromDateId AND @TillDateId)
END


GO
