GO
/****** Object:  StoredProcedure [dbo].[spGetClubbedReport]    Script Date: 13-08-2018 19:38:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetClubbedReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetClubbedReport]
GO
/****** Object:  StoredProcedure [dbo].[spGetClubbedReport]    Script Date: 13-08-2018 19:38:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetClubbedReport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGetClubbedReport] AS' 
END
GO
/***
   Created Date      :     2018-02-14
   Created By        :     Shubhra Upadhyay
   Purpose           :     This stored procedure fetch cl, pl, wfh, compoff, lnsa, attendance,  details
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   --- Test Case 1
   EXEC [dbo].[spGetClubbedReport]
            @FromDate ='2015-01-01'
           ,@TillDate ='2018-08-10'
           ,@RMId =NULL
           ,@UserId =NULL
           ,@DepartmentId ='35,32,17,3,1,2,4,21,7,5,16,8,11,34,33,29,36,24,19,15,18,9,14,20,10'
           ,@TeamId ='7,6,74,66,39,45,24,34,33,5,1,35,42,36,41,28,64,72,21,46,60,44,70,68,4,9,14,43,12,65,37,3,49,47,48,67,38,31,23,10,20,69,71,75,26,27'
		   ,@Status='false'
------------------Test Case 2
EXEC [dbo].[spGetClubbedReport]
            @FromDate ='2015-01-01'
           ,@TillDate ='2018-08-10'
           ,@RMId =NULL
           ,@UserId =NULL
           ,@DepartmentId =NULL
           ,@TeamId =NULL
		   ,@Status=''
     ***/
ALTER PROCEDURE [dbo].[spGetClubbedReport]
(
    @FromDate date
   ,@TillDate date
   ,@RMId varchar(MAX) = NULL
   ,@UserId varchar(MAX) = NULL
   ,@DepartmentId varchar(MAX) = NULL
   ,@TeamId varchar(MAX) = NULL
   ,@Status varchar(20)=NULL
)
AS
BEGIN
   SET NOCOUNT ON;
   SET FMTONLY OFF;
   
   IF OBJECT_ID('tempdb..#EmployeeData') IS NOT NULL
   DROP TABLE #EmployeeData

   --Create Temp objects____________________________________________________________________________________________________

   CREATE TABLE #EmployeeData(
   [UserId] int
   ,[CL] float
   ,[PL] float
   ,[WFH] int
   ,[LNSA] int
   ,[COFF] int
   ,[TotalDaysPresent] int
   ,[TotalLoggedHours] float
   ,[JoiningDate] date
   ,[RelievingDate] date
   ,[Status] varchar(10)
   )

   INSERT INTO #EmployeeData([UserId], [JoiningDate], [RelievingDate], [Status]) 
   SELECT 
      [UserId]
     ,[JoiningDate]
     ,[TerminateDate] 
     ,CASE
         WHEN [TerminateDate] IS NULL THEN 'Active'
         ELSE 'Inactive'
      END
   FROM [dbo].[UserDetail] 
      WHERE ([TerminateDate] IS NULL OR [TerminateDate] >= @FromDate)
      AND [JoiningDate] <= @TillDate
      AND [UserId] > 1
      AND ([UserId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@UserId,',')) OR @UserId IS NULL OR @UserId='')
	  --CL UPDATE____________________________________________________________________________________________________
	UPDATE E
   SET E.[CL] = CLN.[Availed]
   FROM #EmployeeData E
   INNER JOIN
   (
   SELECT
	       U.[UserId]                                                                                                                AS [UserId]        
	      ,ISNULL(AP.[Availed],0)               							                                                                  AS [Availed]  
      FROM
	      [dbo].[UserDetail] U WITH (NOLOCK)                                    
            INNER JOIN
			      [dbo].[UserDetail] UD WITH (NOLOCK)
				      ON UD.[UserId] = U.[ReportTo]         
		      LEFT JOIN
			      (
                  SELECT    
                     L.[UserId]         
                     ,SUM(LD.[Count])                                                                                                    AS [Availed]
                  FROM
                     [dbo].[LeaveRequestApplication] L WITH (NOLOCK)
                        INNER JOIN
                           [dbo].[LeaveRequestApplicationDetail] LD WITH (NOLOCK)
                              ON LD.[LeaveRequestApplicationId] = L.[LeaveRequestApplicationId]
                        INNER JOIN
                           (
                              SELECT 
                                 [LeaveRequestApplicationId]                                       AS [LeaveRequestApplicationId]
                                ,Count(*)                                                          AS [TotalIncludingDays]
                              FROM
                                 [dbo].[DateWiseLeaveType] T WITH (NOLOCK)
                                    INNER JOIN
                                       [dbo].[DateMaster] D WITH (NOLOCK)
                                          ON T.[DateId] = D.[DateId]
                              WHERE
                                 D.[Date] BETWEEN @FromDate AND @TillDate
                              GROUP BY
                                 [LeaveRequestApplicationId]
                              ) D
                              ON D.[LeaveRequestApplicationId] = L.[LeaveRequestApplicationId]
                        INNER JOIN  
                           [dbo].[LeaveTypeMaster] LT WITH (NOLOCK)
                              ON LT.[TypeId] = LD.[LeaveTypeId]      
                  WHERE    
                     L.[LeaveCombination] IS NOT NULL 
                     AND LT.[ShortName] = 'CL'
                     AND L.[StatusId] > 2
                  GROUP BY
                     L.[UserId]
			      ) AP
				      ON U.[UserId] = AP.[UserId]		         
   ) CLN
   ON E.[UserId] = CLN.[UserId]

   --PL UPDATE____________________________________________________________________________________________________

   UPDATE E
   SET E.[PL] = PLN.[Availed]
   FROM #EmployeeData E
   INNER JOIN
   (
   SELECT
	       U.[UserId]                                                                                                                AS [UserId]  
         ,ISNULL(AP.[Availed],0)               							                                                                  AS [Availed]    
      FROM
	      [dbo].[UserDetail] U WITH (NOLOCK)                     
            INNER JOIN
			      [dbo].[UserDetail] UD WITH (NOLOCK)
				      ON UD.[UserId] = U.[ReportTo]         
		      LEFT JOIN
			      (
                  SELECT    
                     L.[UserId]         
                     ,SUM(LD.[Count])                                               AS [Availed]
                  FROM
                     [dbo].[LeaveRequestApplication] L WITH (NOLOCK)
                        INNER JOIN
                           [dbo].[LeaveRequestApplicationDetail] LD WITH (NOLOCK)
                              ON LD.[LeaveRequestApplicationId] = L.[LeaveRequestApplicationId]
                        INNER JOIN
                           (
                              SELECT 
                                 [LeaveRequestApplicationId]                                       AS [LeaveRequestApplicationId]
                                ,Count(*)                                                          AS [TotalIncludingDays]
                              FROM
    [dbo].[DateWiseLeaveType] T WITH (NOLOCK)
                                    INNER JOIN
                                       [dbo].[DateMaster] D WITH (NOLOCK)
                                          ON T.[DateId] = D.[DateId]
                              WHERE
                                 D.[Date] BETWEEN @FromDate AND @TillDate
                              GROUP BY
                                 [LeaveRequestApplicationId]
                              ) D
                              ON D.[LeaveRequestApplicationId] = L.[LeaveRequestApplicationId]
                        INNER JOIN  
      [dbo].[LeaveTypeMaster] LT WITH (NOLOCK)
                              ON LT.[TypeId] = LD.[LeaveTypeId]      
                  WHERE    
                     L.[LeaveCombination] IS NOT NULL 
                     AND LT.[ShortName] = 'PL'
                     AND L.[StatusId] > 2
                  GROUP BY
                     L.[UserId]
			      ) AP
				      ON U.[UserId] = AP.[UserId]		               
   ) PLN
   ON E.[UserId] = PLN.[UserId]

   --WFH UPDATE____________________________________________________________________________________________________

   UPDATE E
   SET E.[WFH] = WFH.[Availed]
   FROM #EmployeeData E
   INNER JOIN
   (
   SELECT
	       U.[UserId]                                                                                                                AS [UserId]      
	      ,ISNULL(AP.[Availed],0)               							                                                                  AS [Availed]      
      FROM
	      [dbo].[UserDetail] U WITH (NOLOCK)      
            INNER JOIN
			      [dbo].[UserDetail] UD WITH (NOLOCK)
				      ON UD.[UserId] = U.[ReportTo]         
		      LEFT JOIN
			      (
                  SELECT    
                     L.[UserId]         
                     ,SUM(LD.[Count])                                                                                                    AS [Availed]
                  FROM
                     [dbo].[LeaveRequestApplication] L WITH (NOLOCK)
                        INNER JOIN
                           [dbo].[LeaveRequestApplicationDetail] LD WITH (NOLOCK)
                              ON LD.[LeaveRequestApplicationId] = L.[LeaveRequestApplicationId]
                        INNER JOIN
                           (
                              SELECT 
                                 [LeaveRequestApplicationId]                                       AS [LeaveRequestApplicationId]
                                ,Count(*)                                                          AS [TotalIncludingDays]
                              FROM
                                 [dbo].[DateWiseLeaveType] T WITH (NOLOCK)
                                    INNER JOIN
                                       [dbo].[DateMaster] D WITH (NOLOCK)
                                          ON T.[DateId] = D.[DateId]
                              WHERE
                                 D.[Date] BETWEEN @FromDate AND @TillDate
                              GROUP BY
                                 [LeaveRequestApplicationId]
                              ) D
                              ON D.[LeaveRequestApplicationId] = L.[LeaveRequestApplicationId]
                        INNER JOIN  
                           [dbo].[LeaveTypeMaster] LT WITH (NOLOCK)
                              ON LT.[TypeId] = LD.[LeaveTypeId]      
                  WHERE    
                     L.[LeaveCombination] IS NULL 
                     AND LT.[ShortName] = 'WFH'
                     AND L.[StatusId] > 2
                     AND L.[Reason] NOT LIKE '%night shift%'
                  GROUP BY
                     L.[UserId]
			      ) AP
				      ON U.[UserId] = AP.[UserId]		   
   ) WFH
   ON E.[UserId] = WFH.[UserId]

   --COFF UPDATE____________________________________________________________________________________________________

   UPDATE E
   SET E.[COFF] = COFF.[Approved]
   FROM #EmployeeData E
   INNER JOIN
   (
   SELECT 
       U.[UserId]                                                                          AS [UserId]   
      ,ISNULL(AP.[Approved], 0)                                                            AS [Approved]   
   FROM
      [dbo].[UserDetail] U WITH (NOLOCK)
      INNER JOIN
         [dbo].[UserDetail] UD WITH (NOLOCK)
            ON U.[ReportTo] = UD.[UserId]         
      LEFT JOIN                                   --Approved CompOffs
  (
            SELECT
                SUM(C.[NoOfDays])                     AS [Approved]
               ,C.[CreatedBy]                         AS [CreatedBy]
            FROM
               [dbo].[RequestCompOff] C WITH (NOLOCK)
               INNER JOIN
                  [dbo].[DateMaster] D WITH (NOLOCK)
                     ON C.[DateId] = D.[DateId]
            WHERE
               C.[IsActive] = 1
               AND C.[IsDeleted] = 0
               AND C.[StatusId] = 3
               AND D.[Date] BETWEEN @FromDate AND @TillDate
            GROUP BY C.[CreatedBy]    
         ) AP
            ON U.[UserId] = AP.[CreatedBy]      
   ) COFF
   ON E.[UserId] = COFF.[UserId]

   --LNSA UPDATE____________________________________________________________________________________________________

   UPDATE E
   SET E.[LNSA] = LNSA.[Approved]
   FROM #EmployeeData E
   INNER JOIN
   (
   SELECT
	    U.[UserId]																AS [EmployeeId]	
	   ,ISNULL(AP.[Approved], 0)											AS [Approved]	
   FROM
	   [dbo].[UserDetail] U WITH (NOLOCK)		
		   LEFT JOIN
			   (
				   SELECT
					    ISNULL(SUM(  L.[TotalNoOfDays] ), 0)			AS [Approved]
					   ,L.[CreatedBy]									AS [UserId]
				   FROM
					   [dbo].[RequestLnsa] L
                  INNER JOIN
                     [dbo].[DateMaster] F
                        ON F.[Date] = @FromDate
                  INNER JOIN
                     [dbo].[DateMaster] T
                        ON T.[Date] = @TillDate
				   WHERE
					   L.[Status] = 1
                  AND L.[FromDateId] BETWEEN F.[DateId] AND T.[DateId]				
               GROUP BY L.[CreatedBy]            
			   ) AP
				   ON U.[UserId] = AP.[UserId]		
		   INNER JOIN
			   [dbo].[UserDetail] UD WITH (NOLOCK)
				   ON UD.[UserId] = U.[ReportTo]
   ) LNSA
   ON E.[UserId] = LNSA.[EmployeeId]

   --Attendance UPDATE____________________________________________________________________________________________________

   UPDATE E
   SET E.[TotalDaysPresent] = ATT.[TotalDaysPresent]
   ,E.[TotalLoggedHours] = ATT.[TotalLoggedTime(Hours)]
   FROM #EmployeeData E
   INNER JOIN
   (
   SELECT
       U.[UserId]   
      ,COUNT(*) AS [TotalDaysPresent]
      ,CAST(CAST(SUM(DATEDIFF(SECOND, '0:00:00', CAST(ISNULL(A.[SystemGeneratedTotalWorkingHours], A.[UserGivenTotalWorkingHours]) AS [time]))) AS float)/3600 AS float)   AS [TotalLoggedTime(Hours)]
   FROM
      [dbo].[DateWiseAttendance] A WITH (NOLOCK)
      INNER JOIN
         [dbo].[UserDetail] U WITH (NOLOCK)
            ON A.[UserId] = U.[UserId]
      INNER JOIN
         [dbo].[DateMaster] D WITH (NOLOCK)
            ON A.[DateId] = D.[DateId]
            AND D.[Date] >= U.[JoiningDate]
   WHERE
      D.[Date] BETWEEN @FromDate AND @TillDate
   AND A.[IsActive] = 1   
   GROUP BY
       U.[FirstName] + ' ' + U.[LastName]
      ,U.[UserId]
   ) ATT
   ON E.[UserId] = ATT.[UserId]

   --Print data____________________________________________________________________________________________________
IF(@Status='false')
BEGIN
  SELECT 
       UD.[FirstName] + ' ' + UD.[LastName]                                      AS [EmployeeName]
      ,RM.[FirstName] + ' ' + RM.[LastName]                                      AS [ReportingManager]
      ,D.[DepartmentName]                                   AS [Department]
      ,T.[TeamName]                                                              AS [Team]
      ,ISNULL(CAST(CL AS VARCHAR(10)), 'N.A')                                    AS [CL]
      ,ISNULL(CAST(PL AS VARCHAR(10)), 'N.A')                                    AS [PL]
      ,ISNULL(CAST(WFH AS VARCHAR(10)), 'N.A')                                   AS [WFH]
      ,ISNULL(CAST(COFF AS VARCHAR(10)), 'N.A')                                  AS [COFF]
      ,ISNULL(CAST(LNSA AS VARCHAR(10)), 'N.A')                                  AS [LNSA]
      ,ISNULL(CAST([TotalDaysPresent] AS VARCHAR(10)), 'N.A')                    AS [TotalDaysPresent]
      ,ISNULL(CAST([TotalLoggedHours] AS VARCHAR(10)), 'N.A')                    AS [TotalLoggedHours]
      ,CONVERT(VARCHAR(11), E.[JoiningDate], 101)								 AS [JoiningDate]
      ,ISNULL(CONVERT(VARCHAR(10), [RelievingDate], 101), 'N.A')                 AS [RelievingDate]
      ,E.[Status]
   FROM
      #EmployeeData E
      INNER JOIN [dbo].[UserDetail] UD ON E.[UserId] = UD.[UserId]
      INNER JOIN [dbo].[UserDetail] RM ON UD.[ReportTo] = RM.[UserId]
      INNER JOIN [dbo].[UserTeamMapping] UTM ON [UD].[UserId] = UTM.[UserId]
      INNER JOIN [dbo].[Team] T ON [T].[TeamId] = UTM.[TeamId]
      INNER JOIN [dbo].[Department] D ON T.[DepartmentId] = D.[DepartmentId]
      INNER JOIN [dbo].[User] U ON U.[UserId] = UD.[UserId]
  WHERE (T.[TeamId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@TeamId,',')) OR @TeamId IS NULL OR @TeamId='' )AND
    (RM.[UserId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@RMId,',')) OR @RMId IS NULL OR @RMId='')AND
	(D.[DepartmentId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@DepartmentId,',')) OR @DepartmentId IS NULL OR @DepartmentId='')
	AND U.[IsActive]=0
 ORDER BY UD.[FirstName] + UD.[LastName]
 END
ELSE IF (@Status='true')
BEGIN
  SELECT 
       UD.[FirstName] + ' ' + UD.[LastName]                                      AS [EmployeeName]
      ,RM.[FirstName] + ' ' + RM.[LastName]                                      AS [ReportingManager]
      ,D.[DepartmentName]                                   AS [Department]
      ,T.[TeamName]                                                              AS [Team]
      ,ISNULL(CAST(CL AS VARCHAR(10)), 'N.A')                                    AS [CL]
      ,ISNULL(CAST(PL AS VARCHAR(10)), 'N.A')                                    AS [PL]
      ,ISNULL(CAST(WFH AS VARCHAR(10)), 'N.A')                                   AS [WFH]
      ,ISNULL(CAST(COFF AS VARCHAR(10)), 'N.A')                                  AS [COFF]
      ,ISNULL(CAST(LNSA AS VARCHAR(10)), 'N.A')                                  AS [LNSA]
      ,ISNULL(CAST([TotalDaysPresent] AS VARCHAR(10)), 'N.A')                    AS [TotalDaysPresent]
      ,ISNULL(CAST([TotalLoggedHours] AS VARCHAR(10)), 'N.A')                    AS [TotalLoggedHours]
      ,CONVERT(VARCHAR(11), E.[JoiningDate], 101)                                AS [JoiningDate]
      ,ISNULL(CONVERT(VARCHAR(10), [RelievingDate], 101), 'N.A')                 AS [RelievingDate]
      ,E.[Status]
   FROM
      #EmployeeData E
      INNER JOIN [dbo].[UserDetail] UD ON E.[UserId] = UD.[UserId]
      INNER JOIN [dbo].[UserDetail] RM ON UD.[ReportTo] = RM.[UserId]
      INNER JOIN [dbo].[UserTeamMapping] UTM ON [UD].[UserId] = UTM.[UserId]
      INNER JOIN [dbo].[Team] T ON [T].[TeamId] = UTM.[TeamId]
      INNER JOIN [dbo].[Department] D ON T.[DepartmentId] = D.[DepartmentId]
      INNER JOIN [dbo].[User] U ON U.[UserId] = UD.[UserId]
  WHERE (T.[TeamId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@TeamId,',')) OR @TeamId IS NULL OR @TeamId='' )AND
    (RM.[UserId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@RMId,',')) OR @RMId IS NULL OR @RMId='')AND
	(D.[DepartmentId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@DepartmentId,',')) OR @DepartmentId IS NULL OR @DepartmentId='')
	AND U.[IsActive]=1
 ORDER BY UD.[FirstName] + UD.[LastName]
 END
 ELSE
 BEGIN
 SELECT 
       UD.[FirstName] + ' ' + UD.[LastName]                                      AS [EmployeeName]
      ,RM.[FirstName] + ' ' + RM.[LastName]                                      AS [ReportingManager]
      ,D.[DepartmentName]                                   AS [Department]
      ,T.[TeamName]                                                              AS [Team]
      ,ISNULL(CAST(CL AS VARCHAR(10)), 'N.A')                                    AS [CL]
      ,ISNULL(CAST(PL AS VARCHAR(10)), 'N.A')                                    AS [PL]
      ,ISNULL(CAST(WFH AS VARCHAR(10)), 'N.A')                                   AS [WFH]
      ,ISNULL(CAST(COFF AS VARCHAR(10)), 'N.A')                                  AS [COFF]
      ,ISNULL(CAST(LNSA AS VARCHAR(10)), 'N.A')                                  AS [LNSA]
      ,ISNULL(CAST([TotalDaysPresent] AS VARCHAR(10)), 'N.A')                    AS [TotalDaysPresent]
      ,ISNULL(CAST([TotalLoggedHours] AS VARCHAR(10)), 'N.A')                    AS [TotalLoggedHours]
      ,CONVERT(VARCHAR(11), E.[JoiningDate], 101)                  AS [JoiningDate]
      ,ISNULL(CONVERT(VARCHAR(10), [RelievingDate], 101), 'N.A')   AS [RelievingDate]
      ,E.[Status]
   FROM
      #EmployeeData E
      INNER JOIN [dbo].[UserDetail] UD ON E.[UserId] = UD.[UserId]
      INNER JOIN [dbo].[UserDetail] RM ON UD.[ReportTo] = RM.[UserId]
      INNER JOIN [dbo].[UserTeamMapping] UTM ON [UD].[UserId] = UTM.[UserId]
      INNER JOIN [dbo].[Team] T ON [T].[TeamId] = UTM.[TeamId]
      INNER JOIN [dbo].[Department] D ON T.[DepartmentId] = D.[DepartmentId]
      INNER JOIN [dbo].[User] U ON U.[UserId] = UD.[UserId]
  WHERE (T.[TeamId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@TeamId,',')) OR @TeamId IS NULL OR @TeamId='')AND
    (RM.[UserId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@RMId,',')) OR @RMId IS NULL OR @RMId='')AND
	(D.[DepartmentId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@DepartmentId,',')) OR @DepartmentId IS NULL OR @DepartmentId='')
	
 ORDER BY UD.[FirstName] + UD.[LastName]
 END
--Drop Temp objects____________________________________________________________________________________________________

   DROP TABLE #EmployeeData

END
GO
