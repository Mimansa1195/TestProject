USE [MIS]
GO
/****** Object:  StoredProcedure [dbo].[spImportUserShiftMapping]    Script Date: 13-07-2018 20:09:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spImportUserShiftMapping]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spImportUserShiftMapping]
GO
/****** Object:  StoredProcedure [dbo].[spGetTeamWiseReportingManagers]    Script Date: 13-07-2018 20:09:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetTeamWiseReportingManagers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetTeamWiseReportingManagers]
GO
/****** Object:  StoredProcedure [dbo].[spGetDepartmentWiseTeams]    Script Date: 13-07-2018 20:09:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetDepartmentWiseTeams]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetDepartmentWiseTeams]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetUserDashboardCompOff]    Script Date: 13-07-2018 20:09:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetUserDashboardCompOff]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetUserDashboardCompOff]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetLeaveBalanceHistoryByFY]    Script Date: 13-07-2018 20:09:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetLeaveBalanceHistoryByFY]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetLeaveBalanceHistoryByFY]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetLeaveBalanceHistoryByFY]    Script Date: 13-07-2018 20:09:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetLeaveBalanceHistoryByFY]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetLeaveBalanceHistoryByFY] AS' 
END
GO
/**
EXEC Proc_GetLeaveBalanceHistoryByFY 
'01-04-2018'
,'LWP'
,33
**/
ALTER PROCEDURE [dbo].[Proc_GetLeaveBalanceHistoryByFY]
(
 @Year datetime
,@LeaveType varchar(5)
,@UserId int
)
AS
BEGIN 
BEGIN TRANSACTION
SET NOCOUNT ON;
	DECLARE @StartDate [date], @EndDate [date],@AdminId int=1,@FYear bigint,
	      @QStartDate DATE = CAST (DATEADD(q, DATEDIFF(q, 0, GETDATE()), 0) AS [Date])
         ,@QEndDate DATE = CAST (DATEADD(d, -1, DATEADD(q, DATEDIFF(q, 0, GETDATE()) + 1, 0)) AS [Date])
	SET @FYear=DATEPART(YYYY, @Year)
	IF (@FYear IS NULL OR @FYear =0)
		SET @FYear = DATEPART(YYYY, GETDATE())

	SELECT @StartDate =dateadd(Year,0,cast(concat(@FYear,'-04-01') as date)) ,
			@EndDate = dateadd(Year,1,cast(concat(@FYear,'-03-31') as date)) 
 IF(@LeaveType='WFH')
 BEGIN
 SELECT 
     LR.[CreatedDate]                                                 AS [ApplyDate]
	  ,DM1.[Date]                                                     AS [FromDate]
	  ,DM2.[Date]                                                     AS [TillDate]
	  ,LT.[ShortName]                                                 AS [LeaveInfo]
	  ,LS.[Status]                                                    AS [Status]
      ,CASE
         WHEN H.[ApproverRemarks] IS NULL THEN 'NA'
         WHEN LTRIM(RTRIM(H.[ApproverRemarks])) = '' THEN LAP.[FirstName] + ' ' + LAP.[LastName] + ': Approved'
         ELSE LAP.[FirstName] + ' ' + LAP.[LastName] + ': ' + H.[ApproverRemarks]
      END                                                             AS [Remarks]
	  ,LR.[CreatedBy] AS [CreatedBy]
	  ,LR.[NoOfTotalDays]  AS [LeaveCount]                                                                                          
	FROM 
      [dbo].[LeaveRequestApplication] LR WITH (NOLOCK)
	      INNER JOIN 
            [dbo].[LeaveRequestApplicationDetail] LRD WITH (NOLOCK)
		         ON LR.[LeaveRequestApplicationId] = LRD.[LeaveRequestApplicationId]
	      INNER JOIN 
            [dbo].[LeaveStatusMaster] LS WITH (NOLOCK)
		         ON LR.[StatusId] = LS.StatusId
	      INNER JOIN 
            [dbo].[LeaveTypeMaster] LT WITH (NOLOCK)
		         ON LRD.[LeaveTypeId] = LT.[TypeId]
	      INNER JOIN 
            [dbo].[DateMaster] DM1 WITH (NOLOCK)
		         ON LR.[FromDateId] = DM1.DateId
	      INNER JOIN 
            [dbo].[DateMaster] DM2 WITH (NOLOCK)
		         ON LR.[TillDateId] = DM2.[DateId]
	       LEFT JOIN
            (
               SELECT
                  H.[LeaveRequestApplicationId]                                                                      AS [LeaveRequestApplicationId]
                 ,MAX(H.[CreatedDate])                                                                               AS [LastUpdatedTime]
               FROM
                  [dbo].[LeaveHistory] H WITH (NOLOCK)
               GROUP BY
                  H.[LeaveRequestApplicationId]
            ) RH
               ON RH.[LeaveRequestApplicationId] = LR.[LeaveRequestApplicationId]
         LEFT JOIN
            [dbo].[LeaveHistory] H WITH (NOLOCK)
               ON H.[LeaveRequestApplicationId] = RH.[LeaveRequestApplicationId]
               AND H.[CreatedDate] = RH.[LastUpdatedTime]
         LEFT JOIN
            [dbo].[UserDetail] LAP WITH (NOLOCK)
               ON LAP.[UserId] = H.[CreatedBy] 
         LEFT JOIN
            [dbo].[UserDetail] NAP WITH (NOLOCK)
               ON NAP.[UserId] = LR.[ApproverId]
       WHERE 
         LR.[UserId] = @UserId   AND (LR.StatusId=4 OR LR.StatusId=5 OR LR.StatusId=6)
		   AND LT.[ShortName] = 'WFH' AND DM1.[Date] BETWEEN @StartDate AND @EndDate
   ORDER BY LR.[CreatedDate] DESC
END
ELSE IF (@LeaveType='LNSA')
BEGIN
 SELECT DISTINCT
         R.[CreatedDate]                                                                                  AS [ApplyDate]
	   , D.[Date]                                                                                        AS [FromDate]
        ,M.[Date]                                                                                         AS [TillDate]
        ,CAST(COUNT (DW.[IsApprovedBySystem]) AS float)                                                   AS [LeaveCount]
        ,R.[Reason]                                                                                       AS [Reason]
		,R.[ApproverRemarks]																			  AS [Remarks]
        ,CASE R.[Status]
            WHEN 0 THEN 'Pending for Appoval with ' + UD.[FirstName] + ' ' + UD.[LastName]
            WHEN -1 THEN 'Rejected By ' + UD.[FirstName] + ' ' + UD.[LastName]
            WHEN 1 THEN 'Approved By ' + UD.[FirstName] + ' ' + UD.[LastName] 
         END                                                                                              AS [Status]
		,R.[CreatedBy] 
		 ,CAST ('LNSA' AS [VARCHAR]) AS [LeaveInfo]                                                                                         
      FROM
         [dbo].[RequestLnsa] R WITH (NOLOCK)
            INNER JOIN
               [dbo].[DateMaster] D WITH (NOLOCK)
                  ON D.[DateId] = R.[FromDateId]
            INNER JOIN
               [dbo].[DateMaster] M WITH (NOLOCK)
                  ON M.[DateId] = R.[TillDateId]
            INNER JOIN
               [dbo].[UserDetail] U WITH (NOLOCK)
                  ON U.[UserId] = R.[CreatedBy]
            INNER JOIN
               [dbo].[UserDetail] UD WITH (NOLOCK)
                  ON UD.[UserId] = U.[ReportTo]
				  INNER JOIN [dbo].[DateWiseLNSA] DW WITH (NOLOCK)
				  ON R.[RequestId]=DW.[RequestId]
      WHERE
         R.[CreatedBy] = @UserId AND D.[Date] BETWEEN @QStartDate AND @QEndDate AND DW.[IsApprovedBySystem]=1
		 GROUP BY R.[CreatedDate],R.[RequestId],D.[Date],M.[Date],R.[Reason],R.[ApproverRemarks],UD.[FirstName],UD.[LastName],R.[Status],R.[CreatedBy]
      ORDER BY R.[CreatedDate] DESC ,D.[Date] DESC
END
ELSE 
   BEGIN
    SELECT DISTINCT
		 LR.[CreatedDate]																									AS [ApplyDate]
        ,DM1.[Date]																											AS [FromDate]
		,DM2.[Date]																											AS [TillDate]
		,CAST(LR.[NoOfWorkingDays] AS [varchar](3)) + ' (' + LR.[LeaveCombination] + ')'									AS [LeaveInfo]
		,LS.[Status]                                                                                                        AS [Status]
		,CASE 
			WHEN LS.[StatusCode] = 'CA' THEN LS.[Status]
			WHEN RH.[ApproverRemarks] IS NULL THEN ''
			WHEN RH.[ApproverRemarks] = '' THEN UD1.[FirstName] + ' ' + UD1.[LastName] + ': Approved'
			WHEN (RH.[ApproverId] = 1 AND RH.[CreatedBy] = 1) THEN RH.[ApproverRemarks]
			ELSE UD1.[FirstName] + ' ' + UD1.[LastName] + ': ' + RH.[ApproverRemarks]                                
		 END AS [Remarks]
		,LR.[NoOfWorkingDays]																								AS [LeaveCount]
		,LR.[CreatedBy]
		FROM 
      [dbo].[LeaveRequestApplication] LR WITH (NOLOCK)
	      INNER JOIN [dbo].[LeaveStatusMaster] LS WITH (NOLOCK) ON LR.[StatusId] = LS.StatusId
	      INNER JOIN [dbo].[DateMaster] DM1 WITH (NOLOCK) ON LR.[FromDateId] = DM1.[DateId]
	      INNER JOIN [dbo].[DateMaster] DM2 WITH (NOLOCK) ON LR.[TillDateId] = DM2.[DateId]
          LEFT JOIN [dbo].[UserDetail] UD ON LR.[ApproverId] = UD.[UserId]
		  LEFT JOIN(SELECT LLR.* FROM 
						(SELECT MAX(LegitimateLeaveRequestId) AS LegitimateLeaveRequestId ,LeaveRequestApplicationId
						FROM [LegitimateLeaveRequest] 
					    WHERE UserId=@UserId
						GROUP BY LeaveRequestApplicationId
						) LL 
						INNER JOIN [LegitimateLeaveRequest] LLR ON LL.LegitimateLeaveRequestId=LLR.LegitimateLeaveRequestId
				   ) F
				ON F.LeaveRequestApplicationId = LR.[LeaveRequestApplicationId] 
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
			[dbo].[UserDetail] UD1 WITH (NOLOCK) ON UD1.[UserId] = RH.[CreatedBy]
	WHERE 
      LR.[UserId] = @UserId  AND LR.[LeaveCombination] IN (SELECT LeaveCombination FROM LeaveRequestApplication WHERE LeaveCombination LIKE '%' + @LeaveType + '%')
      AND (LR.[StatusId]=4 OR LR.[StatusId]=5 OR LR.[StatusId]=6)
      AND DM1.[Date] BETWEEN @StartDate AND  @EndDate
   ORDER BY  LR.[CreatedDate] DESC, DM1.[Date] DESC 
END
COMMIT TRANSACTION
END



GO
/****** Object:  StoredProcedure [dbo].[Proc_GetUserDashboardCompOff]    Script Date: 13-07-2018 20:09:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetUserDashboardCompOff]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetUserDashboardCompOff] AS' 
END
GO
-- EXEC [dbo].[Proc_GetUserDashboardCompOff] 2231,'01-04-2018'
ALTER PROCEDURE [dbo].[Proc_GetUserDashboardCompOff]
   @UserId [int]
  ,@Year DATETIME
AS
BEGIN
   SET NOCOUNT ON;
   DECLARE @StartDate [date], @EndDate [date],@FY bigint
	SET @FY=DATEPART(YYYY, @Year)
	IF (@FY IS NULL OR @FY =0)
	SET @FY = DATEPART(YYYY, GETDATE())

	SELECT @StartDate=dateadd(Month,0,cast(concat(@FY,'-04-01') as date)),
		  @EndDate = dateadd(Year,1,cast(concat(@FY,'-03-31') as date)) 
    SELECT 
      D.[Date]         AS [Date]
     ,C.[NoOfDays]     AS [NoOfDays]
     ,LS.[Status]
     ,C.[StatusId]
	 ,LS.[StatusCode]
	 ,C.[CreatedDate] AS [AppliedOn]
     ,C.[IsLapsed]
     ,C.[LapseDate]      
       FROM
      [dbo].[RequestCompOff] C WITH (NOLOCK)
      INNER JOIN 
         [dbo].[UserDetail] U WITH (NOLOCK) 
            ON C.[CreatedBy] = U.[UserId]
      INNER JOIN 
         [dbo].[User] US WITH (NOLOCK) 
            ON U.[UserId] = US.[UserId]
      INNER JOIN 
         [dbo].[LeaveStatusMaster] LS WITH (NOLOCK) 
            ON C.[StatusId] = LS.StatusId
      INNER JOIN 
         [dbo].[DateMaster] D WITH (NOLOCK)
            ON C.[DateId] = D.[DateId]
   WHERE 
      U.[UserId] = @UserId AND (C.[StatusId]=3 OR C.[StatusId]=4 OR C.[StatusId]=5 OR C.[StatusId]=6)
      AND US.[IsActive] = 1 AND D.[Date] BETWEEN @StartDate AND @EndDate  AND C.[IsLapsed]=0 AND C.[IsAvailed]=0
   GROUP BY C.[RequestId]
   ,D.[Date]
   ,C.[NoOfDays]
   ,C.[LastModifiedBy]
   ,C.[ApproverId]
   ,LS.[StatusCode]
   ,C.[StatusId]
   ,LS.[Status]
   ,C.[CreatedDate]
   ,C.[IsLapsed]
   ,C.[LapseDate]
   ORDER BY C.LapseDate DESC, C.[CreatedDate] DESC  
END
GO
/****** Object:  StoredProcedure [dbo].[spGetDepartmentWiseTeams]    Script Date: 13-07-2018 20:09:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetDepartmentWiseTeams]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGetDepartmentWiseTeams] AS' 
END
GO

/***
   Created Date      :     2018-06-12
   Created By        :     Mimansa Agrawal
   Purpose           :     This stored procedure get all team names in a Department
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   
   --------------------------------------------------------------------------

   Test Cases        :
   --------------------------------------------------------------------------
  
   Test Cases        : 1 

   EXEC [spGetDepartmentWiseTeams]
         @DepartmentId = NULL
         
   EXEC [spGetDepartmentWiseTeams]
         @DepartmentId = '1,2,3'
		 SELECT * FROM [dbo].[Fun_SplitStringInt] ('1,2,3',',')
  
***/ 
ALTER PROCEDURE [dbo].[spGetDepartmentWiseTeams]
(
   @DepartmentId varchar(200) = NULL
)
AS
BEGIN

   SET NOCOUNT ON;

   SELECT  
	 T.[TeamId]
	,T.[TeamName]	
   FROM 
		[dbo].[Team] T WITH (NOLOCK)
		INNER JOIN [Department] D WITH (NOLOCK) 
		ON D.[DepartmentId] = T.[DepartmentId]			
   WHERE 
   D.[DepartmentId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@DepartmentId,',')) 
   OR @DepartmentId IS NULL
   GROUP BY 
	    T.[TeamId]
      ,T.[TeamName]
   ORDER BY T.[TeamName]
END
GO
/****** Object:  StoredProcedure [dbo].[spGetTeamWiseReportingManagers]    Script Date: 13-07-2018 20:09:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetTeamWiseReportingManagers]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGetTeamWiseReportingManagers] AS' 
END
GO

/***
   Created Date      :     2018-06-12
   Created By        :     Mimanasa Agrawal
   Purpose           :     This stored procedure get all reporting manager in a Team
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   
   --------------------------------------------------------------------------

   Test Cases        :
   --------------------------------------------------------------------------
  
   Test Cases        : 1 

   EXEC [spGetTeamWiseReportingManagers]
         @TeamId = NULL
         
   EXEC [spGetTeamWiseReportingManagers]
         @TeamId = '7,6,66,39,45,34,33,1,42,36,41,60,44,4,22,76,52,40,8,32,73,14,43,65,47,67,38,20,71,75,27'
		 SELECT * FROM [dbo].[Fun_SplitStringInt] ('1,2,3',',')
  
***/ 
ALTER PROCEDURE [dbo].[spGetTeamWiseReportingManagers]
(
   @TeamId varchar(200) = NULL
)
AS
BEGIN

   SET NOCOUNT ON 

   SELECT 
	    UDR.[UserId]
      ,UDR.[FirstName] + ' ' + UDR.[LastName] AS [ReportingManagerName] 
   FROM [dbo].[Department] D WITH (NOLOCK)
   INNER JOIN [dbo].[Team] T WITH (NOLOCK) ON D.[DepartmentId] = T.[DepartmentId]
   INNER JOIN [dbo].[UserTeamMapping] UTM WITH (NOLOCK) ON UTM.[TeamId] = T.[TeamId]
   INNER JOIN [dbo].[UserDetail] UD WITH (NOLOCK) ON UD.[UserId] = UTM.[UserId] 
   INNER JOIN [dbo].[UserDetail] UDR WITH (NOLOCK) ON UDR.[UserId] = UD.[ReportTo]
   WHERE (T.[TeamId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@TeamId,','))) OR @TeamId IS NULL 
   AND UD.[TerminateDate] IS NULL
   GROUP BY 
	    UDR.[UserId]
      ,UDR.[FirstName] + ' ' + UDR.[LastName] 
   ORDER BY UDR.[FirstName] + ' ' + UDR.[LastName] 
END



GO
/****** Object:  StoredProcedure [dbo].[spImportUserShiftMapping]    Script Date: 13-07-2018 20:09:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spImportUserShiftMapping]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spImportUserShiftMapping] AS' 
END
GO
/***
   Created Date      :     2016-01-24
   Created By        :     Rakesh Gandhi
   Purpose           :     This stored procedure imports attendance for a date from excel
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   27-Nov-2017		Sudhanshu Shekhar	 Replaced name and added userId in xml
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   --- Test Case 1
   Declare @res tinyint, @Msg varchar(2000)
         EXEC [dbo].[spImportUserShiftMapping]
            @FromDate = '2018-01-01'
           ,@ToDate = '2018-03-01'
           ,@Data = '<ShiftMapping>
               <ShiftRecord UserId="2434" Shift="D" />
               <ShiftRecord UserId="24332" Shift="D" />
               </ShiftMapping>'
           ,@Success=@res output
		   ,@Message=@Msg output
  SELECT @res AS Result, @Msg AS Message
***/
ALTER PROCEDURE [dbo].[spImportUserShiftMapping]
   @FromDate [date]
  ,@ToDate [date]
  ,@Data [xml]
  ,@LoginUserId [int] = 0
  ,@Success	tinyint output
  ,@Message varchar(2000) output
AS
BEGIN TRY 
   SET NOCOUNT ON;

   IF (@LoginUserId = 0)
    SET @LoginUserId = 58 --Neeraj Yadav for e-Inv

   --supplying a data contract
   IF 1 = 2 
   BEGIN
      SELECT
         CAST(NULL AS [date]) 			AS [Date]
        --,CAST(NULL AS [varchar](152))   AS [Name]
        ,CAST(NULL AS [varchar](50))    AS [Shift]
        ,CAST(NULL AS [varchar](500))   AS [Remarks]
      WHERE 1 = 2
   END

   CREATE TABLE #Data
   (
      [UserId] [int] NULL
     ,[DateId] [bigint] NULL
     ,[ShiftId] [int] NULL
     ,[Shift] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL
     ,[Remarks] [varchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL 
   )
   
   WHILE @FromDate <= @ToDate
      BEGIN
         -- parse XML
         INSERT INTO #Data
         (
             [UserId]
            ,[Shift] 
            ,[DateId]
         )
		SELECT T.Item.value('@UserId', 'int') [UserId],
			T.Item.value('@Shift', 'varchar(2)') [Shift],
			D.[DateId]
		FROM @Data.nodes('/ShiftMapping/ShiftRecord') AS T(Item)
		INNER JOIN [dbo].[DateMaster] D WITH (NOLOCK) ON D.[Date] = @FromDate

   --      -- update user ids
   --      UPDATE T
   --      SET T.[UserId] = M.[UserId]
   --      FROM #Data T
		 --INNER JOIN [dbo].[UserDetail] M WITH (NOLOCK) ON LTRIM(RTRIM(T.[Name])) = LTRIM(RTRIM(M.[FirstName])) + ' ' + LTRIM(RTRIM(M.[LastName]))
   --                  --AND ISNULL(M.[TerminateDate], '2999-12-31') >= @FromDate

         UPDATE T
         SET T.[ShiftId] = M.[ShiftId]
         FROM #Data T 
         INNER JOIN [dbo].[ShiftMaster] M WITH (NOLOCK) ON LTRIM(RTRIM(M.[ShiftName])) = LTRIM(RTRIM(T.[Shift])) AND M.[IsActive] = 1 AND M.[IsDeleted] = 0

         -- update remarks
         UPDATE T
         SET T.[Remarks] = 'Unable to find employee and shift in database'
         FROM #Data T
         WHERE T.[UserId] IS NULL AND T.[ShiftId] IS NULL

         UPDATE T
         SET T.[Remarks] = 'Unable to find employee in database'
         FROM #Data T
         WHERE T.[UserId] IS NULL AND T.[Remarks] IS NULL

         UPDATE T 
         SET T.[Remarks] = 'Unable to find shift in database'
         FROM #Data T
         WHERE T.[ShiftId] IS NULL AND T.[Remarks] IS NULL

         SET @FromDate = DATEADD(dd, 1, @FromDate)
  END
      
      -- check for invalid records
      IF EXISTS (SELECT 1 FROM #Data WHERE [Remarks] IS NOT NULL) -- some invalid records are available
      BEGIN
         SELECT
            D.[Date] AS [Date]
           ,T.[UserId] AS [UserId]
           ,T.[Shift] AS [Shift]
           ,T.[Remarks] AS [Remarks]
         FROM #Data T
         INNER JOIN [dbo].[DateMaster] D WITH (NOLOCK) ON T.[DateId] = D.[DateId]
         WHERE T.[Remarks] IS NOT NULL
      END
      ELSE
      BEGIN
       BEGIN TRANSACTION
               UPDATE M
               SET
                  M.[IsActive] = 0
                 ,M.[IsDeleted] = 1
                 ,M.[LastModifiedDate] = GETDATE()
                 ,M.[LastModifiedBy] = @LoginUserId
               FROM [dbo].[UserShiftMapping] M
               INNER JOIN #Data T 
				ON M.[DateId] = T.[DateId]
				AND M.[UserId] = T.[UserId]
				AND M.[ShiftId] != T.[ShiftId]

               INSERT INTO [dbo].[UserShiftMapping]([DateId],[UserId],[ShiftId],[CreatedBy])
               SELECT T.[DateId],T.[UserId],T.[ShiftId],@LoginUserId
               FROM #Data T
               LEFT JOIN [dbo].[UserShiftMapping] M 
					ON T.[DateId] = M.[DateId]
					AND T.[UserId] = M.[UserId]
					AND M.[IsActive] = 1
					AND M.[IsDeleted] = 0
               WHERE
                  M.[MappingId] IS NULL
            

			SET @Success=1    ---------------commit if successful
			SET @Message='Users shift added successfully.'   ---------------commit if successful

            COMMIT TRANSACTION
            
            SELECT 
				 D.[Date] AS [Date]
			    ,T.[Shift] AS [Shift]
				,T.[Remarks] AS [Remarks]
            FROM #Data T
            INNER JOIN [dbo].[DateMaster] D WITH (NOLOCK) ON T.[DateId] = D.[DateId]
            WHERE T.[Remarks] IS NOT NULL
		END
END TRY
BEGIN CATCH
		IF @@TRANCOUNT > 0
		BEGIN
        ROLLBACK TRANSACTION
        SELECT
		     NULL AS [Date]
			,NULL AS [Shift]
			,NULL AS [Remarks]

        DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
		DECLARE @ErrId BIGINT=0 

		EXEC [spInsertErrorLog]
			@ModuleName = 'eInvoice'
			,@Source = 'spImportUserShiftMapping'
			,@ErrorMessage = @ErrorMessage
			,@ErrorType = 'SP'
			,@ReportedByUserId = @LoginUserId
			,@ErrorId=@ErrId OUTPUT

		SET @Success=0; -----------------error occured
		SET @Message= 'Your request cannot be processed, please try after some time or contact to MIS team with reference id: ' + CAST(@ErrId AS VARCHAR(20)) + ' for further assistance.'
END
END CATCH

GO
