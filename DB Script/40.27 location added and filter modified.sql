GO
/****** Object:  StoredProcedure [dbo].[spGetLwpReport]    Script Date: 19-02-2019 17:44:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetLwpReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetLwpReport]
GO
/****** Object:  StoredProcedure [dbo].[spGetLnsaReport]    Script Date: 19-02-2019 17:44:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetLnsaReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetLnsaReport]
GO
/****** Object:  StoredProcedure [dbo].[spGetEmployeeAttendanceSummary]    Script Date: 19-02-2019 17:44:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetEmployeeAttendanceSummary]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetEmployeeAttendanceSummary]
GO
/****** Object:  StoredProcedure [dbo].[spGetEmployeeAttendance]    Script Date: 19-02-2019 17:44:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetEmployeeAttendance]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetEmployeeAttendance]
GO
/****** Object:  StoredProcedure [dbo].[spGetCompOffReport]    Script Date: 19-02-2019 17:44:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetCompOffReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetCompOffReport]
GO
/****** Object:  StoredProcedure [dbo].[spGetClubbedReport]    Script Date: 19-02-2019 17:44:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetClubbedReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetClubbedReport]
GO
/****** Object:  StoredProcedure [dbo].[spGetClubbedReport]    Script Date: 19-02-2019 17:44:58 ******/
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
		   ,@LocId = '1,2,3'
		   ,@Status=''
------------------Test Case 2
EXEC [dbo].[spGetClubbedReport]
            @FromDate ='2015-01-01'
           ,@TillDate ='2019-02-19'
           ,@RMId =NULL
           ,@UserId =NULL
           ,@DepartmentId =NULL
           ,@TeamId =NULL
		   ,@LocId = '1,2,3'
		   ,@Status='true'
     ***/
ALTER PROCEDURE [dbo].[spGetClubbedReport]
(
    @FromDate date
   ,@TillDate date
   ,@RMId varchar(MAX) = NULL
   ,@UserId varchar(MAX) = NULL
   ,@DepartmentId varchar(MAX) = NULL
   ,@TeamId varchar(MAX) = NULL
   ,@LocId varchar(MAX) = NULL
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
	    ,L.[LocationName]                                                          AS [LocationName]
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
	   INNER JOIN [dbo].[Location] L ON U.[LocationId] = L.[LocationId]
  WHERE (T.[TeamId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@TeamId,',')) OR @TeamId IS NULL OR @TeamId='' )AND
    (RM.[UserId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@RMId,',')) OR @RMId IS NULL OR @RMId='')AND
	(U.[LocationId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@LocId,',')) OR @LocId IS NULL OR @LocId='')AND
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
	  ,L.[LocationName]                                                          AS [LocationName]
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
	   INNER JOIN [dbo].[Location] L ON U.[LocationId] = L.[LocationId]
  WHERE (T.[TeamId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@TeamId,',')) OR @TeamId IS NULL OR @TeamId='' )AND
    (RM.[UserId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@RMId,',')) OR @RMId IS NULL OR @RMId='')AND
	(U.[LocationId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@LocId,',')) OR @LocId IS NULL OR @LocId='')AND
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
	  ,L.[LocationName]                                                          AS [LocationName]
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
	   INNER JOIN [dbo].[Location] L ON U.[LocationId] = L.[LocationId]
  WHERE (T.[TeamId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@TeamId,',')) OR @TeamId IS NULL OR @TeamId='')AND
    (RM.[UserId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@RMId,',')) OR @RMId IS NULL OR @RMId='')AND
	(U.[LocationId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@LocId,',')) OR @LocId IS NULL OR @LocId='')AND
	(D.[DepartmentId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@DepartmentId,',')) OR @DepartmentId IS NULL OR @DepartmentId='')
	
 ORDER BY UD.[FirstName] + UD.[LastName]
 END
--Drop Temp objects____________________________________________________________________________________________________

   DROP TABLE #EmployeeData

END

GO
/****** Object:  StoredProcedure [dbo].[spGetCompOffReport]    Script Date: 19-02-2019 17:44:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetCompOffReport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGetCompOffReport] AS' 
END
GO
/***
   Created Date      :     2016-01-27
   Created By        :     Narender Singh
   Purpose           :     This stored procedure gets comp-off Report on basis of department or manager or userid
   
   Change History    :
   -------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   
   --------------------------------------------------------------------------

   Test Cases        :
   --------------------------------------------------------------------------
   
   --- Test Case 1
         EXEC [dbo].[spGetCompOffReport]
          @DepartmentId = NULL
         ,@ReportToId = NULL
         ,@UserId = NULL
         ,@FromDate = '20160625'
         ,@TillDate = '20160924'
		 ,@LocId = '1,4'
            
***/
ALTER PROCEDURE [dbo].[spGetCompOffReport]
(
	@DepartmentId varchar(4000) NULL
  ,@ReportToId varchar(4000) NULL
  ,@UserId varchar(4000) NULL
  ,@FromDate [Date] 
  ,@TillDate [Date] 
  ,@LocId varchar(2000) NULL
)
AS
BEGIN

	SET NOCOUNT ON  
   
   SELECT
       U.[UserId]                                                                                                                      AS [UserId]
	   ,U.[EmployeeId]														                                                                        AS [EmployeeId]
	   ,U.[FirstName] + ' ' + U.[LastName]								                                                                        AS [EmployeeName]
      ,D.[DepartmentName]                                                                                                              AS [DepartmentName]
	  ,L.[LocationName]                                                                                                                AS [LocationName]
	   ,UD.[FirstName] + ' ' + UD.[LastName]						                                                                           AS [ReportingManager]
	   ,A.[Applied]                                                                                                                     AS [Applied]
	   ,ISNULL(AP.[Approved], 0)											                                                                        AS [Approved]
      ,ISNULL(PA.[PendingForApproval], 0)								                                                                        AS [PendingForApproval]
	   ,ISNULL(R.[Rejected], 0)											                                                                        AS [Rejected]
      ,ISNULL(AV.[Availed], 0)                                                                                                         AS [Availed]
      ,B.[Count]                                                                                                                       AS [Balance]
   FROM
	   [dbo].[UserDetail] U WITH (NOLOCK)
	   INNER JOIN [dbo].[User] US WITH (NOLOCK) ON US.[UserId] = U.[UserId]
	   INNER JOIN [dbo].[Location] L WITH (NOLOCK) ON US.[LocationId] = L.[LocationId]
         INNER JOIN [dbo].[UserTeamMapping] M WITH (NOLOCK) ON U.[UserId] = M.[UserId]
         INNER JOIN [dbo].[Team] T WITH (NOLOCK) ON M.[TeamId] = T.[TeamId]
         INNER JOIN [dbo].[Department] D WITH (NOLOCK) ON D.[DepartmentId] = T.[DepartmentId]
         INNER JOIN [dbo].[UserDetail] UD WITH (NOLOCK) ON UD.[UserId] = U.[ReportTo]
         INNER JOIN [dbo].[LeaveBalance] B WITH (NOLOCK) ON B.[UserId] = U.[UserId]
         INNER JOIN [dbo].[LeaveTypeMaster] LTM WITH (NOLOCK) ON LTM.[TypeId] = B.[LeaveTypeId]
         INNER JOIN (SELECT R.[CreatedBy] AS [UserId],SUM(R.[NoOfDays]) AS [Applied]
               FROM[dbo].[RequestCompOff] R WITH (NOLOCK)
         INNER JOIN [dbo].[DateMaster] D WITH (NOLOCK) ON D.[DateId] = R.[DateId]
               WHERE  D.[Date] BETWEEN @FromDate AND @TillDate
               GROUP BY R.[CreatedBy] ) A ON U.[UserId] = A.[UserId]
		   LEFT JOIN (SELECT ISNULL(SUM(  R.[NoOfDays] ), 0) AS [PendingForApproval] ,R.[CreatedBy]					      				                                                                        AS [UserId]
				   FROM[dbo].[RequestCompOff] R WITH (NOLOCK)
         INNER JOIN [dbo].[DateMaster] D WITH (NOLOCK)  ON D.[DateId] = R.[DateId]
               WHERE 
 D.[Date] BETWEEN @FromDate AND @TillDate AND R.[StatusId] = 1
				   GROUP BY R.[CreatedBy] ) PA ON U.[UserId] = PA.[UserId]
		   LEFT JOIN
			   (
				   SELECT
					    ISNULL(SUM(  R.[NoOfDays] ), 0)			                                                                              AS [Approved]
					   ,R.[CreatedBy]									                                                                              AS [UserId]
				   FROM
					   [dbo].[RequestCompOff] R WITH (NOLOCK)
                     INNER JOIN
                        [dbo].[DateMaster] D WITH (NOLOCK)
                           ON D.[DateId] = R.[DateId]
               WHERE 
                  D.[Date] BETWEEN @FromDate AND @TillDate
				      AND R.[StatusId] = 3
				   GROUP BY R.[CreatedBy]
			   ) AP
				   ON U.[UserId] = AP.[UserId]
		   LEFT JOIN
			   (
				   SELECT
					    ISNULL(SUM(  R.[NoOfDays] ), 0)			                                                                              AS [Rejected]
					   ,R.[CreatedBy]								      	                                                                        AS [UserId]
				   FROM
					   [dbo].[RequestCompOff] R WITH (NOLOCK)
                     INNER JOIN
                        [dbo].[DateMaster] D WITH (NOLOCK)
                           ON D.[DateId] = R.[DateId]
               WHERE 
                  D.[Date] BETWEEN @FromDate AND @TillDate
				      AND R.[StatusId] = -1
				   GROUP BY R.[CreatedBy]
			   ) R
				   ON U.[UserId] = R.[UserId]		

         LEFT JOIN
            (              
               SELECT    
                   L.[UserId]         
                  ,SUM(LRD.[Count])                                                                                                     AS [Availed]
               FROM
                  [dbo].[LeaveRequestApplication] L WITH (NOLOCK)
                     INNER JOIN
                        (
                           SELECT
                              LD.[LeaveRequestApplicationId]
                             ,LD.[Count]
                           FROM
                              [dbo].[LeaveRequestApplicationDetail] LD WITH (NOLOCK)                           
                                 INNER JOIN
                                    [dbo].[LeaveTypeMaster] M WITH (NOLOCK)
                                       ON M.[TypeId] = LD.[LeaveTypeId]
                                 INNER JOIN
                                    [dbo].[DateWiseLeaveType] DT WITH (NOLOCK)
                                       ON DT.[LeaveRequestApplicationId] = LD.[LeaveRequestApplicationId]                     
                                 INNER JOIN
                                    [dbo].[DateMaster] D WITH (NOLOCK)
                                       ON D.[DateId] = DT.[DateId]
                           WHERE
                              D.[Date] BETWEEN @FromDate AND @TillDate
                              AND M.[ShortName] = 'COFF'
                           GROUP BY
                              LD.[LeaveRequestApplicationId]
                             ,LD.[Count]
                        ) LRD
                           ON LRD.[LeaveRequestApplicationId] = L.[LeaveRequestApplicationId]      
                  WHERE
              L.[StatusId] > 3                              
                  GROUP BY
                     L.[UserId]
) AV ON AV.[UserId] = U.[UserId]
   WHERE
      UD.[TerminateDate] IS NULL
      AND U.[TerminateDate] IS NULL
      AND D.[DepartmentId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@DepartmentId,','))
	  AND UD.[UserId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@ReportToId,','))
	  AND U.[UserId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@UserId,','))
	  AND(US.[LocationId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@LocId,',')) OR @LocId IS NULL OR @LocId='')
      AND LTM.[ShortName] = 'COFF'
   ORDER BY 
      U.[FirstName] + ' ' + U.[LastName]
END



GO
/****** Object:  StoredProcedure [dbo].[spGetEmployeeAttendance]    Script Date: 19-02-2019 17:44:58 ******/
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
   25 Jan 2019     kanchan kumari         if any leave is applied then show leave
                                          even if attendance is there for the user
										  and applied check for legitimateleave table 
   Test Cases        :
   --------------------------------------------------------------------------   
   --- Test Case 1
         EXEC [dbo].[spGetEmployeeAttendance]
            @FromDate = '2019-01-01'
           ,@EndDate = '2019-01-31'
           ,@DepartmentId = 0
           ,@ForEmployeeIds = '2434'
           ,@RMId = '2203'
		   ,@LocId = '1,4'
		   ,@FetchDataForEntireOrg = 1

***/
ALTER PROCEDURE [dbo].[spGetEmployeeAttendance]
      @FromDate [date]
     ,@EndDate [date]
     ,@DepartmentId [int] = NULL
     ,@ForEmployeeIds varchar(2000) = NULL
     ,@RMId [int] = NULL
	 ,@LocId varchar(200) = NULL
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
	 ,[WeekNo] INT NOT NULL
	 ,[IsWeekend] BIT NOT NULL 
	 ,[IsNormalWeek] BIT NOT NULL DEFAULT(1)
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
      RIGHT JOIN #UserDateMapping M ON M.[DateId] = A.[DateId] AND M.[UserId] = A.[UserId] AND A.IsActive = 1 AND A.IsDeleted = 0
      INNER JOIN [dbo].[UserDetail] U WITH (NOLOCK) ON M.[UserId] = U.[UserId]

	  --select * from #FinalAttendanceData WHERE UserId = 2421 ORDER BY [Date] DESC

 --  ---- From New Bulding Data.
	--INSERT INTO #FinalAttendanceData
 --  (
 --     [UserId],[EmployeeName],[DateId],[Date],[DisplayDate],[InTime],[OutTime],[TotalTime]
 --  )
 --  SELECT 
 --     U.[UserId],U.[FirstName] + ' ' + U.[LastName],M.[DateId],M.[Date]
 --    ,CONVERT ([varchar](11), M.[Date], 106) + ' (' + SUBSTRING(M.[Day], 1, 3) + ')'
	-- ,CONVERT(VARCHAR(20),ISNULL(A.[UserGivenInTime], A.[SystemGeneratedInTime]),106)+' '+FORMAT(ISNULL(A.[UserGivenInTime], A.[SystemGeneratedInTime]),'hh:mm tt') AS [InTime]
	-- ,CONVERT(VARCHAR(20),ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]),106)+' '+FORMAT(ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]),'hh:mm tt') AS [OutTime]
	-- ,CONVERT(VARCHAR(5), ISNULL(A.[UserGivenTotalWorkingHours], A.[SystemGeneratedTotalWorkingHours]), 108) AS [TotalTime]
 --   -- ,CASE 
 --   --     WHEN CONVERT(datetime, M.[Date], 106) = CONVERT(datetime, ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]), 106) THEN CONVERT(datetime ,CAST(ISNULL(A.[UserGivenInTime], A.[SystemGeneratedInTime]) AS [time]), 100)
 --   --     ELSE CONVERT(datetime ,CAST(ISNULL(A.[UserGivenInTime], A.[SystemGeneratedInTime]) AS [time]), 100) --+ ' (' + CONVERT ([varchar](11), ISNULL(A.[UserGivenInTime], A.[SystemGeneratedInTime]), 106) + ')'
 --   --END
 --   -- ,CASE
 --   -- WHEN CONVERT(datetime, M.[Date], 106) = CONVERT(datetime, ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]), 106) THEN CONVERT(datetime ,CAST(ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]) AS [time]), 100)
 --   --     ELSE CONVERT(datetime ,CAST(ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]) AS [time]), 100) --+ ' (' + CONVERT ([varchar](11), ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]), 106) + ')'
 --   --  END
 --   -- ,CONVERT(datetime, ISNULL(A.[UserGivenTotalWorkingHours], A.[SystemGeneratedTotalWorkingHours]), 108)
	
 --  FROM
 --     [dbo].[DateWiseAttendanceAsquare] A WITH (NOLOCK)
 --     RIGHT JOIN #UserDateMapping M ON M.[DateId] = A.[DateId] AND M.[UserId] = A.[UserId] AND A.IsActive = 1 AND A.IsDeleted = 0
 --     INNER JOIN [dbo].[UserDetail] U WITH (NOLOCK) ON M.[UserId] = U.[UserId]


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
      [UserId],[EmployeeName],[DateId],[Date], [WeekNo], [IsWeekend], [DisplayDate],[InTime],[OutTime],[TotalTime],[IsNightShift],[IsPending],[IsApproved]
   )
     SELECT    
	   DW1.[UserId],DW1.[EmployeeName],DW1.[DateId],DW1.[Date],
	    (SELECT WeekNo FROM [dbo].[FetchDateAndWeekNo](DW1.[Date]))
      ,DM.IsWeekend, DW1.[DisplayDate]  
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
   JOIN DateMaster DM ON DW1.DateId = DM.DateId
   --select * from #FinalAttendanceData2 WHERE UserId = 2421 ORDER BY [Date] DESC

   ---update holidays -----------------
   UPDATE T SET
      T.[InTime] = 'Holiday'
     ,T.[OutTime] = 'Holiday'
     ,T.[TotalTime] = H.[Holiday]
   FROM
      #FinalAttendanceData2 T
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
	FROM #FinalAttendanceData2 U
	JOIN (SELECT UserId, WeekNo FROM #TempCalenderRoaster 
	GROUP BY UserId, WeekNo) N
	ON U.[UserId] = N.[UserId] AND U.[WeekNo] = N.[WeekNo]

	 --update [IsWeekend] for special user
	UPDATE #FinalAttendanceData2 SET [IsWeekend] = 0 WHERE [IsWeekend] = 1 AND [IsNormalWeek] = 0

	---update week off data --------------------
      UPDATE #FinalAttendanceData2  
	  SET [InTime] = CASE WHEN [InTime] = 'NA' OR [InTime] IS NULL  THEN 'WeekOff' ELSE [InTime] END 
	  ,[OutTime] = CASE WHEN [OutTime] = 'NA' OR [InTime] IS NULL  THEN 'WeekOff' ELSE [OutTime] END 
	  ,[TotalTime] = CASE WHEN [TotalTime] = 'NA' OR [TotalTime] IS NULL  THEN 'WeekOff' ELSE [TotalTime] END 
      WHERE IsWeekend = 1

-------------------------------------------------------------
    ---update leave --------------------
   UPDATE T SET
      T.[InTime] = CASE  WHEN LT.[ShortName] = 'WFH' THEN 'WFH' WHEN LT.[ShortName] = 'LWP' THEN 'LWP' ELSE 'Leave' END
     ,T.[OutTime] = CASE  WHEN LT.[ShortName] = 'WFH' THEN 'WFH'WHEN LT.[ShortName] = 'LWP' THEN 'LWP' ELSE 'Leave' END
     ,T.[TotalTime] = CASE  WHEN LT.[ShortName] = 'WFH' THEN 'WFH' WHEN LT.[ShortName] = 'LWP' THEN 'LWP' ELSE 'Leave' END--LT.[ShortName]
   FROM
      #FinalAttendanceData2 T
         INNER JOIN [dbo].[DateWiseLeaveType] L WITH (NOLOCK) ON L.[DateId] = T.[DateId]         
         INNER JOIN [dbo].[LeaveRequestApplication] A WITH (NOLOCK) ON A.[LeaveRequestApplicationId] = L.[LeaveRequestApplicationId] AND A.[UserId] = T.[UserId]
         INNER JOIN [dbo].[LeaveTypeMaster] LT WITH (NOLOCK) ON LT.[TypeId] = L.[LeaveTypeId]
   WHERE 
   --T.[InTime] IS NULL AND 
   A.[IsActive] = 1 AND A.[IsDeleted] = 0 AND A.[StatusId] > 0
   
   ---update outing --------------------
      UPDATE T SET
      T.[InTime] = 'Outing'
     ,T.[OutTime] = 'Outing'
     ,T.[TotalTime] = LT.[OutingTypeName]
   FROM
      #FinalAttendanceData2 T
         INNER JOIN [dbo].[OutingRequestDetail] L WITH (NOLOCK) ON L.[DateId] = T.[DateId]         
         INNER JOIN [dbo].[OutingRequest] A WITH (NOLOCK) ON A.[OutingRequestId] = L.[OutingRequestId] AND A.[UserId] = T.[UserId]
         INNER JOIN [dbo].[OutingType] LT WITH (NOLOCK) ON LT.[OutingTypeId] = A.[OutingTypeId]
   WHERE 
   --T.[InTime] IS NULL AND 
   A.[IsActive] = 1 AND A.[IsDeleted] = 0 AND L.[StatusId] < 6

   ---update legitimate leave --------------------
   UPDATE T SET
      T.[InTime] ='Leave'
     ,T.[OutTime] = 'Leave'
     ,T.[TotalTime] = 'Leave'
   FROM
      #FinalAttendanceData2 T
         INNER JOIN [dbo].[LegitimateLeaveRequest] L WITH (NOLOCK) ON T.[DateId] = L.[DateId] AND T.[UserId] = L.[UserId]         
   WHERE 
   --T.[InTime] IS NULL AND 
    L.[StatusId] = 5 --when change request is verified by HR  ---legitimateLeaveStatus

   SELECT 
      F.[UserId]
     ,F.[DisplayDate] AS [Date]
     ,F.[EmployeeName] AS [EmployeeName]
     ,D.[DepartmentName] AS [Department]
	 ,L.[LocationName] AS [LocationName]
     ,ISNULL(F.[InTime], 'NA') AS [InTime]
     ,ISNULL(F.[OutTime], 'NA') AS [OutTime]
     ,ISNULL(F.[TotalTime], 'NA') AS [LoggedInHours]
	 ,IsNightShift
	 ,IsApproved
	 ,IsPending
   FROM #FinalAttendanceData2 F
         INNER JOIN [dbo].[User] U WITH (NOLOCK) ON F.[UserId] = U.[UserId]
		 INNER JOIN [dbo].[Location] L WITH (NOLOCK) ON U.[LocationId] = L.[LocationId]
         INNER JOIN [dbo].[UserTeamMapping] UTM WITH (NOLOCK) ON F.[UserId] = UTM.[UserId] AND UTM.[IsActive] = 1
         INNER JOIN [dbo].[Team] T WITH (NOLOCK) ON UTM.[TeamId] = T.[TeamId]
         INNER JOIN [dbo].[Department] D WITH (NOLOCK) ON D.[DepartmentId] = T.[DepartmentId]  
		 WHERE U.[LocationId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@LocId,',')) OR @LocId IS NULL OR @LocId=''
   GROUP BY  F.[UserId], F.[DisplayDate],F.[EmployeeName],D.[DepartmentName],L.[LocationName], F.[InTime],F.[OutTime],F.[TotalTime],IsNightShift,IsApproved,IsPending,F.[Date]
   ORDER BY       
      F.[EmployeeName]
     ,F.[Date]
     ,F.[InTime] DESC
END
GO
/****** Object:  StoredProcedure [dbo].[spGetEmployeeAttendanceSummary]    Script Date: 19-02-2019 17:44:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetEmployeeAttendanceSummary]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGetEmployeeAttendanceSummary] AS' 
END
GO
/***
   Created Date      :     2016-01-27
   Created By        :     Narender Singh
   Purpose           :     This stored procedure gets employee attendance summary.
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   
   --------------------------------------------------------------------------

   Test Cases        :
   --------------------------------------------------------------------------
   
   --- Test Case 1
         EXEC [dbo].[spGetEmployeeAttendanceSummary]
          @DepartmentId = NULL
         ,@ReportToId = NULL
         ,@UserId = NULL
         ,@FromDate = '20190219'
         ,@TillDate = '20190219'
		 ,@LocId = '1,4'
            
***/
ALTER PROCEDURE [dbo].[spGetEmployeeAttendanceSummary]
(
   @DepartmentId varchar(4000) NULL
  ,@ReportToId varchar(4000) NULL
  ,@UserId varchar(4000) NULL
  ,@FromDate [Date] 
  ,@TillDate [Date] 
  ,@LocId varchar(2000) NULL
)
AS
BEGIN

	SET NOCOUNT ON  
   
   SELECT
	    U.[EmployeeId]														                                                                        AS [EmployeeId]
	   ,U.[FirstName] + ' ' + U.[LastName]								                                                                        AS [EmployeeName]
      ,D.[DepartmentName]                                                                                                                     AS [DepartmentName]
	  ,L.[LocationName]                                                                                                                           AS [LocationName]                                                                                                                          
	   ,UD.[FirstName] + ' ' + UD.[LastName]						                                                                           AS [ReportingManager]	   
      ,ISNULL(A.[Present],0)                                                                                                           AS [PresentDays]
      ,ISNULL(W.[WFH],0)                                                                                                               AS [WFH]
      ,ISNULL(C.[CL],0)                                                                                                                AS [CL]
      ,ISNULL(P.[PL],0)                                                                                                                AS [PL]
      ,ISNULL(LWP.[LWP],0)                                                                                                             AS [LWP]
      ,ISNULL(CF.[COFF],0)                                                                                                             AS [COFF]
   FROM
    [dbo].[User] US WITH (NOLOCK)
	INNER JOIN [dbo].[Location] L WITH (NOLOCK) ON US.[LocationId]=L.[LocationId]
	INNER JOIN 
	   [dbo].[UserDetail] U WITH (NOLOCK) ON US.[UserId]=U.[UserId]
         INNER JOIN
            [dbo].[UserTeamMapping] M WITH (NOLOCK)
	           ON U.[UserId] = M.[UserId]
         INNER JOIN
            [dbo].[Team] T WITH (NOLOCK)
	           ON M.[TeamId] = T.[TeamId]
         INNER JOIN
            [dbo].[Department] D WITH (NOLOCK)
               ON D.[DepartmentId] = T.[DepartmentId]
         INNER JOIN
			   [dbo].[UserDetail] UD WITH (NOLOCK)
				   ON UD.[UserId] = U.[ReportTo]
         LEFT JOIN
            (
               SELECT
                  DA.[UserId]
                 ,COUNT(*)                                                                         AS [Present]
               FROM
                  [dbo].[DateWiseAttendance] DA WITH (NOLOCK)
                     INNER JOIN
                        [dbo].[DateMaster] D WITH (NOLOCK)
                           ON D.[DateId] = DA.[DateId]
               WHERE
                  D.[Date] BETWEEN @FromDate AND @TillDate
               GROUP BY
                  DA.[UserId]
            ) A
               ON  U.[UserId] = A.[UserId] 
         LEFT JOIN
            (
               SELECT 
                  L.[UserId]
                 ,SUM(LD.[Count])                                                                  AS [WFH]
               FROM
                  [dbo].[LeaveRequestApplication] L WITH (NOLOCK)
                     INNER JOIN
                        [dbo].[LeaveRequestApplicationDetail] LD WITH (NOLOCK)
 ON L.[LeaveRequestApplicationId] = LD.[LeaveRequestApplicationId]
                     INNER JOIN
                        [dbo].[LeaveTypeMaster] M WITH (NOLOCK)
                           ON M.[TypeId] = LD.[LeaveTypeId] 
                     INNER JOIN
                        [dbo].[DateMaster] D WITH (NOLOCK)
                           ON D.[DateId] = L.[FromDateId]
               WHERE 
                  M.[ShortName] = 'WFH'
                  AND L.[StatusId] > 2
                  AND D.[Date] BETWEEN @FromDate AND @TillDate
               GROUP BY
                  L.[UserId]
               ) W 
                  ON U.[UserId] = W.[UserId]
         LEFT JOIN
            (
               SELECT    
                  L.[UserId]         
                  ,SUM(CASE 
                           WHEN LD.[Count] > D.[TotalIncludingDays] THEN LD.[Count] - D.[TotalIncludingDays]
                           ELSE LD.[Count]
                        END)                                                                                                     AS [CL]
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
                  LT.[ShortName] = 'CL'
                  AND L.[StatusId] > 2
               GROUP BY
                  L.[UserId]
            ) C
               ON U.[UserId] = C.[UserId]
         LEFT JOIN
            (
               SELECT    
                  L.[UserId]         
                  ,SUM(CASE 
                           WHEN LD.[Count] > D.[TotalIncludingDays] THEN LD.[Count] - D.[TotalIncludingDays]
                           ELSE LD.[Count]
                        END)                                                                                                     AS [PL]
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
                  LT.[ShortName] = 'PL'
                  AND L.[StatusId] > 2
               GROUP BY
                  L.[UserId]
            ) P
               ON U.[UserId] = P.[UserId]
         LEFT JOIN
            (
               SELECT    
                  L.[UserId]         
                  ,SUM(CASE 
                           WHEN LT.[ShortName] = 'LWP' THEN LD.[Count]
                           WHEN LT.[ShortName] != 'LWP' AND LD.[Count] >= D.[TotalIncludingDays] THEN 0
                           ELSE D.[TotalIncludingDays] - LD.[Count]
                        END)                                                                                                     AS [LWP]
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
                  (( L.[LeaveCombination] LIKE '%+%LWP' AND LT.[ShortName] != 'LWP' ) OR (LT.[ShortName] = 'LWP' AND L.[LeaveCombination] NOT LIKE '%+%LWP'))
                  AND L.[StatusId] > 2
               GROUP BY
                  L.[UserId]
			   ) LWP
				   ON U.[UserId] = LWP.[UserId]                           
         LEFT JOIN
            (
               SELECT 
                  L.[UserId]
                 ,SUM(LD.[Count])                                                                  AS [COFF]
               FROM
                  [dbo].[LeaveRequestApplication] L WITH (NOLOCK)
                     INNER JOIN
                        [dbo].[LeaveRequestApplicationDetail] LD WITH (NOLOCK)
                           ON L.[LeaveRequestApplicationId] = LD.[LeaveRequestApplicationId]
                     INNER JOIN
                        [dbo].[LeaveTypeMaster] M WITH (NOLOCK)
                           ON M.[TypeId] = LD.[LeaveTypeId] 
                     INNER JOIN
                        [dbo].[DateMaster] D WITH (NOLOCK)
                           ON D.[DateId] = L.[FromDateId]
     WHERE 
                  M.[ShortName] = 'COFF'
AND L.[StatusId] > 2
                  AND D.[Date] BETWEEN @FromDate AND @TillDate
               GROUP BY
                  L.[UserId]
            ) CF
          ON U.[UserId] = CF.[UserId]
   WHERE
      UD.[TerminateDate] IS NULL
      AND U.[TerminateDate] IS NULL
	      AND D.[DepartmentId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@DepartmentId,','))
	  AND UD.[UserId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@ReportToId,','))
	  AND U.[UserId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@UserId,','))
      AND (US.[LocationId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@LocId,',')) OR @LocId IS NULL OR @LocId='')
      --AND (@ReportToId IS NULL OR UD.[UserId] = @ReportToId)
      --AND (@UserId IS NULL OR U.[UserId] = @UserId)      
   ORDER BY 
      U.[FirstName] + ' ' + U.[LastName]
END



GO
/****** Object:  StoredProcedure [dbo].[spGetLnsaReport]    Script Date: 19-02-2019 17:44:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetLnsaReport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGetLnsaReport] AS' 
END
GO
/***
   Created Date      :     2016-01-27
   Created By        :     Narender Singh
   Purpose           :     This stored procedure gets lnsa Report on basis of department or manager or userid
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   
   --------------------------------------------------------------------------

   Test Cases        :
   --------------------------------------------------------------------------
   
   --- Test Case 1
         EXEC [dbo].[spGetLnsaReport]
          @DepartmentId = '16,5,4,9,15,1,20,7,8,2'
         ,@ReportToId = '2157,23,1,24,2167,2203,88,27,14,61,50,55,2149,58,2147,2160,31,2218,29,4,30,2166,13,2248,1110,1108,56,57,3,2124,97,2137'
         ,@UserId = '2231,83,77,74,38,35,39,86,89,92,97,1098,1105,1106,1107,1108,1109,1110,1111,2115,2122,2121,2119,2118,2117,2116,2125,2123,2124,2131,2132,2134,2137,2139,2141,2143,2144,2145,2147,2148,2149,2150,2153,2151,2152,2161,2165,2166,2168,2170,2171


,2209,2211,2221,2210,2217,2222,2224,2234,2237,44,2238,2236,2242,2243,2245,2248,45,2250,2252,2251,2255,24,70,23,71,61,2,55,46,62,64,47,65,66,27,67,56,49,32,72,28,29,30,31,33,36,37,50,84,75,78,81,76,2179,2173,2178,2182,2174,2172,2194,2192,2188,2186,2180,219


5,2187,2185,2246,2206,2177,2189,2175,2181,2199,2193,2215,2207,2226,2227,2232,2230,2229,2228,2233,2235,2240,58,43,68,4,14'
         ,@FromDate = '20160101'
         ,@TillDate = '20161031'
		 ,@LocId = '1,4'
            
***/
ALTER PROCEDURE [dbo].[spGetLnsaReport]
(
   @DepartmentId varchar(4000) NULL
  ,@ReportToId varchar(4000) NULL
  ,@UserId varchar(4000) NULL
  ,@FromDate [Date] 
  ,@TillDate [Date] 
  ,@LocId varchar(2000) NULL
)
AS
BEGIN

	SET NOCOUNT ON  
   
   SELECT
	    U.[UserId]                                              AS [UserId]
      ,U.[EmployeeId]														AS [EmployeeId]
	   ,U.[FirstName] + ' ' + U.[LastName]								AS [EmployeeName]
      ,D.[DepartmentName]                                      AS [DepartmentName]
	  ,L.[LocationName]                                        AS [LocationName]
	   ,UD.[FirstName] + ' ' + UD.[LastName]						   AS [Reporting Manager]
	   ,A.[Applied]                                             AS [Applied]
	   ,ISNULL(AP.[Approved], 0)											AS [Approved]
      ,ISNULL(PA.[PendingForApproval], 0)								AS [Pending For Approval]
	   ,ISNULL(R.[Rejected], 0)											AS [Rejected]
   FROM [dbo].[User] UM
         JOIN [Location] L WITH (NOLOCK) ON L.[LocationId] = UM.[LocationId]
		 JOIN [UserDetail] U WITH (NOLOCK) ON U.UserId = UM.UserId
         INNER JOIN [dbo].[UserTeamMapping] M WITH (NOLOCK) ON U.[UserId] = M.[UserId]
         INNER JOIN [dbo].[Team] T WITH (NOLOCK) ON M.[TeamId] = T.[TeamId]
         INNER JOIN [dbo].[Department] D WITH (NOLOCK) ON D.[DepartmentId] = T.[DepartmentId]
         INNER JOIN [dbo].[UserDetail] UD WITH (NOLOCK) ON UD.[UserId] = U.[ReportTo]
         INNER JOIN (
               SELECT L.[CreatedBy] AS [UserId] ,COUNT(*) AS [Applied]
               FROM [dbo].[RequestLnsa] L WITH (NOLOCK) 
			   INNER JOIN [dbo].[DateMaster] D WITH (NOLOCK) ON D.[DateId] BETWEEN L.[FromDateId] AND L.[TillDateId]
               WHERE D.[Date] BETWEEN @FromDate AND @TillDate 
               GROUP BY L.[CreatedBy]
            ) A ON A.[UserId] = U.[UserId]
		   LEFT JOIN (
			   SELECT ISNULL(COUNT(*), 0) AS [PendingForApproval] ,L.[CreatedBy] AS [UserId]
				FROM [dbo].[RequestLnsa] L WITH (NOLOCK) 
				INNER JOIN [dbo].[DateMaster] D WITH (NOLOCK) ON D.[DateId] BETWEEN L.[FromDateId] AND L.[TillDateId]
				WHERE D.[Date] BETWEEN @FromDate AND @TillDate AND L.[StatusId]=2
				GROUP BY L.[CreatedBy]
			   ) PA ON U.[UserId] = PA.[UserId]
		   LEFT JOIN (
			   SELECT ISNULL(COUNT(*), 0) AS [Approved] , L.[CreatedBy] AS [UserId]
				FROM [dbo].[RequestLnsa] L WITH (NOLOCK) 
				INNER JOIN [dbo].[DateMaster] D WITH (NOLOCK) ON D.[DateId] BETWEEN L.[FromDateId] AND L.[TillDateId]
                WHERE D.[Date] BETWEEN @FromDate AND @TillDate AND L.[StatusId] = 3
				GROUP BY L.[CreatedBy]
			   ) AP ON U.[UserId] = AP.[UserId]
		   LEFT JOIN (
				SELECT ISNULL(COUNT(*), 0) AS [Rejected], L.[CreatedBy] AS [UserId]
				FROM [dbo].[RequestLnsa] L WITH (NOLOCK)
				INNER JOIN [dbo].[DateMaster] D WITH (NOLOCK) ON D.[DateId] BETWEEN L.[FromDateId] AND L.[TillDateId]
				WHERE D.[Date] BETWEEN @FromDate AND @TillDate AND L.[StatusId] = 6
				GROUP BY L.[CreatedBy]
			   ) R ON U.[UserId] = R.[UserId]		
   WHERE UM.IsActive = 1 AND UD.[TerminateDate] IS NULL AND U.[TerminateDate] IS NULL
      AND D.[DepartmentId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@DepartmentId,','))
	  AND UD.[UserId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@ReportToId,','))
	  AND U.[UserId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@UserId,','))
	  AND(UM.[LocationId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@LocId,',')) OR @LocId IS NULL OR @LocId='')
   ORDER BY U.[FirstName] + ' ' + U.[LastName]
END



GO
/****** Object:  StoredProcedure [dbo].[spGetLwpReport]    Script Date: 19-02-2019 17:44:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetLwpReport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGetLwpReport] AS' 
END
GO
/***
   Created Date      :     2018-12-27
   Created By        :     Kanchan Kumari
   Purpose           :     This stored procedure gets lwp Report on basis of department or manager or userid
   Change History    :
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   --- Test Case 1
         EXEC [dbo].[spGetLwpReport]
          @DepartmentId = NULL
         ,@ReportToId = NULL
         ,@UserId = NULL
         ,@FromDate = '2018-11-25'
         ,@TillDate = '20181224'
		 ,@LocId = '1,4'
***/
ALTER PROCEDURE [dbo].[spGetLwpReport]
(
   @DepartmentId varchar(4000) = NULL
  ,@ReportToId varchar(4000) = NULL
  ,@UserId varchar(4000) = NULL
  ,@FromDate [Date] 
  ,@TillDate [Date] 
  ,@LocId varchar(2000) NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	SET FMTONLY OFF;

	IF OBJECT_ID('tempdb..#TempLWPCount') IS NOT NULL
	DROP TABLE #TempLWPCount

	CREATE TABLE #TempLWPCount
	(
		UserId INT,
		EmployeeName VARCHAR(100),
		EmployeeId VARCHAR(20),
		DepartmentName VARCHAR(200),
		ReportingManager VARCHAR(200),
		AppliedIntegerCount INT NOT NULL DEFAULT(0),
		AppliedHalfDayCount INT NOT NULL DEFAULT(0),
		AvailedIntegerCount INT NOT NULL DEFAULT(0),
		AvailedHalfDayCount INT NOT NULL DEFAULT(0),
		CancelledIntegerCount INT NOT NULL DEFAULT(0),
		CancelledHalfDayCount INT NOT NULL DEFAULT(0),
		PendingForApprovalIntegerCount INT NOT NULL DEFAULT(0),
		PendingForApprovalHalfDayCount INT NOT NULL DEFAULT(0),
		AppliedCount FLOAT,
		AvailedCount FLOAT,
		CancelledCount FLOAT,
		PendingForApprovalCount FLOAT
	)

	INSERT INTO #TempLWPCount(UserId,EmployeeName,EmployeeId,DepartmentName,ReportingManager)
	SELECT VW.UserId,VW.EmployeeName,VW.EmployeeCode, VW.Department, VW.ReportingManagerName
	FROM  vwActiveUsers VW 
	JOIN LeaveRequestApplication L ON VW.UserId = L.UserId 
	JOIN DateWiseLeaveType D ON L.LeaveRequestApplicationId = D.LeaveRequestApplicationId
	JOIN DateMaster DM ON D.DateId = DM.DateId 
	WHERE (VW.UserId IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@UserId,','))
	    OR @UserId IS NULL)
		AND DM.[Date] BETWEEN @FromDate AND @TillDate AND D.LeaveTypeId = 3 
	GROUP BY VW.UserId, VW.EmployeeName,VW.EmployeeCode, VW.Department, VW.ReportingManagerName
	ORDER BY VW.EmployeeName

----------------------applied -------------------
	UPDATE T 
	SET T.AppliedIntegerCount = N.[Count] 
	FROM #TempLWPCount T 
	JOIN (SELECT L.UserId, COUNT(D.RecordId) AS [Count]
		from LeaveRequestApplication L WITH (NOLOCK)
		JOIN DateWiseLeaveType D ON L.LeaveRequestApplicationId = D.LeaveRequestApplicationId
		JOIN DateMaster DM ON D.DateId = DM.DateId 
		WHERE  DM.[Date] BETWEEN @FromDate AND @TillDate AND D.LeaveTypeId = 3 AND D.IsHalfDay = 0
		GROUP BY L.UserId
		) N
	ON T.UserId = N.UserId

	UPDATE T 
	SET T.AppliedHalfDayCount = N.[Count] 
	FROM #TempLWPCount T 
	JOIN (SELECT L.UserId, COUNT(D.RecordId) AS [Count]
		from LeaveRequestApplication L WITH (NOLOCK) 
		JOIN DateWiseLeaveType D ON L.LeaveRequestApplicationId = D.LeaveRequestApplicationId
		JOIN DateMaster DM ON D.DateId = DM.DateId 
		WHERE  DM.[Date] BETWEEN @FromDate AND @TillDate AND D.LeaveTypeId = 3 AND D.IsHalfDay = 1 
		GROUP BY L.UserId
		) N
	ON T.UserId = N.UserId

	UPDATE #TempLWPCount SET AppliedCount = (AppliedIntegerCount + 0.5*AppliedHalfDayCount) 

----------------------availed -------------------
	UPDATE T 
	SET T.AvailedIntegerCount = N.[Count] 
	FROM #TempLWPCount T
	JOIN (SELECT L.UserId, COUNT(D.RecordId) AS [Count]
		from LeaveRequestApplication L WITH (NOLOCK)
		JOIN DateWiseLeaveType D ON L.LeaveRequestApplicationId = D.LeaveRequestApplicationId
		JOIN DateMaster DM ON D.DateId = DM.DateId 
		WHERE DM.[Date] BETWEEN @FromDate AND @TillDate AND D.LeaveTypeId = 3 AND D.IsHalfDay = 0 AND L.StatusId >3
		GROUP BY L.UserId
		) N
	ON T.UserId = N.UserId

	UPDATE T 
	SET T.AvailedHalfDayCount = N.[Count] 
	FROM #TempLWPCount T
	JOIN (SELECT L.UserId, COUNT(D.RecordId) AS [Count]
		from LeaveRequestApplication L WITH (NOLOCK)
		JOIN DateWiseLeaveType D ON L.LeaveRequestApplicationId = D.LeaveRequestApplicationId
		JOIN DateMaster DM ON D.DateId = DM.DateId 
		WHERE  DM.[Date] BETWEEN @FromDate AND @TillDate AND D.LeaveTypeId = 3 AND D.IsHalfDay = 1 AND L.StatusId >3
		GROUP BY L.UserId
		) N
	ON T.UserId = N.UserId

	UPDATE #TempLWPCount SET AvailedCount = (AvailedIntegerCount + 0.5*AvailedHalfDayCount) 

----------------------cancelled -------------------
	UPDATE T 
	SET T.CancelledIntegerCount = N.[Count]
	FROM #TempLWPCount T
	JOIN (SELECT L.UserId, COUNT(D.RecordId) AS [Count]
		from LeaveRequestApplication L WITH (NOLOCK) 
		JOIN DateWiseLeaveType D ON L.LeaveRequestApplicationId = D.LeaveRequestApplicationId
		JOIN DateMaster DM ON D.DateId = DM.DateId 
		WHERE  DM.[Date] BETWEEN @FromDate AND @TillDate AND D.LeaveTypeId = 3 AND D.IsHalfDay = 0 AND L.StatusId = 0
		GROUP BY L.UserId
		) N
	ON T.UserId = N.UserId

	UPDATE T 
	SET T.CancelledHalfDayCount = N.[Count]
	FROM #TempLWPCount T
	JOIN (SELECT L.UserId, COUNT(D.RecordId) AS [Count]
		from LeaveRequestApplication L WITH (NOLOCK)
		JOIN DateWiseLeaveType D ON L.LeaveRequestApplicationId = D.LeaveRequestApplicationId
		JOIN DateMaster DM ON D.DateId = DM.DateId 
		WHERE  DM.[Date] BETWEEN @FromDate AND @TillDate AND D.LeaveTypeId = 3 AND D.IsHalfDay = 1 AND L.StatusId = 0
		GROUP BY L.UserId
		) N
	ON T.UserId = N.UserId

	UPDATE #TempLWPCount SET CancelledCount = (CancelledIntegerCount + 0.5*CancelledHalfDayCount) 

----------------------pending for approval -------------------
-- LeaveStatusMaster
	UPDATE T 
	SET T.PendingForApprovalIntegerCount = N.[Count] 
	FROM #TempLWPCount T
	JOIN (SELECT L.UserId, COUNT(D.RecordId) AS [Count]
		from LeaveRequestApplication L WITH (NOLOCK)
		JOIN DateWiseLeaveType D ON L.LeaveRequestApplicationId = D.LeaveRequestApplicationId
		JOIN DateMaster DM ON D.DateId = DM.DateId 
		WHERE  DM.[Date] BETWEEN @FromDate AND @TillDate AND D.LeaveTypeId = 3 AND D.IsHalfDay = 0 AND L.StatusId IN(1,2)
		GROUP BY L.UserId
		) N
	ON T.UserId = N.UserId

	UPDATE T 
	SET T.PendingForApprovalHalfDayCount = N.[Count] 
	FROM #TempLWPCount T
	JOIN (SELECT L.UserId, COUNT(D.RecordId) AS [Count]
		from LeaveRequestApplication L WITH (NOLOCK)
		JOIN DateWiseLeaveType D ON L.LeaveRequestApplicationId = D.LeaveRequestApplicationId
		JOIN DateMaster DM ON D.DateId = DM.DateId 
		WHERE  DM.[Date] BETWEEN @FromDate AND @TillDate AND D.LeaveTypeId = 3 AND D.IsHalfDay = 1 AND L.StatusId IN(1,2)
		GROUP BY L.UserId
		) N
	ON T.UserId = N.UserId

	UPDATE #TempLWPCount SET PendingForApprovalCount = (PendingForApprovalIntegerCount + 0.5*PendingForApprovalHalfDayCount) 

   SELECT T.[UserId], T.[EmployeeId], T.[EmployeeName], T.[DepartmentName], T.[ReportingManager],L.[LocationName] AS [LocationName] 
	     ,T.[AppliedCount] AS [Applied], T.[AvailedCount] AS [Availed],
          T.[PendingForApprovalCount] AS [PendingForApproval], T.[CancelledCount] AS [Cancelled]
   FROM #TempLWPCount T
   JOIN [dbo].[User] U ON U.[UserId]=T.[UserId] 
    JOIN [dbo].[Location] L ON U.[LocationId]=L.[LocationId] 
   WHERE (U.[LocationId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@LocId,',')) OR @LocId IS NULL OR @LocId='')
END
GO
----------------insert location in table----------
INSERT INTO [dbo].[Location](LocationName,CompanyId,CityId,StateId,CountryId,CreatedById,[Address])
SELECT 'IT Park, Panchkula',CO.[CompanyId],CI.[CityId],CI.[StateId],C.[CountryId],1,'Plot No: 5, 1st Floor, IT Park • Panchkula, Haryana 134109'
FROM [dbo].[Company] CO 
CROSS JOIN [dbo].[City] CI
CROSS JOIN Country C 
WHERE CO.[CompanyName]='Gemini Solutions' AND CI.[CityName]='Panchkula' AND C.[CountryName]='India'