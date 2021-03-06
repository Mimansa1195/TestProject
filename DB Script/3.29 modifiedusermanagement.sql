GO
/****** Object:  StoredProcedure [dbo].[spGetLeaves]    Script Date: 03-10-2018 16:15:12 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetLeaves]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetLeaves]
GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateApproverIdOnManagerChange]    Script Date: 03-10-2018 16:15:12 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_UpdateApproverIdOnManagerChange]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_UpdateApproverIdOnManagerChange]
GO
/****** Object:  StoredProcedure [dbo].[Proc_FetchPendingApprovalsForUserId]    Script Date: 03-10-2018 16:15:12 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_FetchPendingApprovalsForUserId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_FetchPendingApprovalsForUserId]
GO
/****** Object:  View [dbo].[vwEligibleUsersToFillTimesheet]    Script Date: 03-10-2018 16:15:12 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vwEligibleUsersToFillTimesheet]'))
DROP VIEW [dbo].[vwEligibleUsersToFillTimesheet]
GO
/****** Object:  View [dbo].[vwEligibleUsersToFillTimesheet]    Script Date: 03-10-2018 16:15:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vwEligibleUsersToFillTimesheet]'))
EXEC dbo.sp_executesql @statement = N'/***
   Created Date      :     2015-11-10
   Created By        :     Rakesh Gandhi
   Purpose           :     This view retrive active users
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   
   --------------------------------------------------------------------------

   Test Cases        :
   --------------------------------------------------------------------------

   Test Case 1:
      SELECT * FROM [dbo].[vwEligibleUsersToFillTimesheet]

***/
CREATE VIEW [dbo].[vwEligibleUsersToFillTimesheet]
AS
   SELECT 
      U.[UserId]
     ,U.[UserName]
     ,UD.[FirstName]                                     AS [EmployeeFirstName]
     ,UD.[LastName]                                      AS [EmployeeLastName]
	  ,LTRIM(RTRIM(REPLACE(REPLACE(REPLACE((ISNULL(UD.[FirstName],'''') + '' '' + ISNULL(UD.[MiddleName],'''') + '' '' + ISNULL(UD.[LastName],'''')), '' '', ''{}''), ''}{'',''''), ''{}'', '' ''))) AS [EmployeeName]
     ,UD.[EmailId]                                       AS [EmailId]
     ,RM.[FirstName] + '' '' + RM.[LastName]               AS [ReportingManagerName]
     ,RM.[EmailId]                                       AS [ReportingManagerEmailId]
   FROM
     [dbo].[User] U WITH (NOLOCK)         
     INNER JOIN [dbo].[UserDetail] UD WITH (NOLOCK) ON U.[UserId] = UD.[UserId]
     INNER JOIN [dbo].[UserDetail] RM WITH (NOLOCK) ON UD.[ReportTo] = RM.[UserId]
	 LEFT JOIN [dbo].[TimesheetExcludedUser] T WITH (NOLOCK) ON T.[UserId]=U.[UserId] AND T.[IsActive]=1
   WHERE T.[UserId] IS NULL AND UD.[TerminateDate] IS NULL
   AND UD.[UserId] <> 1 AND U.[IsActive] = 1
   

' 
GO
/****** Object:  StoredProcedure [dbo].[Proc_FetchPendingApprovalsForUserId]    Script Date: 03-10-2018 16:15:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_FetchPendingApprovalsForUserId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_FetchPendingApprovalsForUserId] AS' 
END
GO
/***
   Created Date      :     2018-09-25
   Created By        :     Mimansa Agrawal
   Purpose           :     This procedure is used to fetch all pending requests of any user before manager change
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
EXEC Proc_FetchPendingApprovalsForUserId
@UserId=2277
**/
ALTER PROCEDURE [dbo].[Proc_FetchPendingApprovalsForUserId]
@UserId INT
AS
BEGIN
SET NOCOUNT ON;
SET FMTONLY OFF;    
IF OBJECT_ID('tempdb..#PendingApprovals') IS NOT NULL
DROP TABLE #PendingApprovals
CREATE TABLE #PendingApprovals
(
[Type] VARCHAR (50) NOT NULL,
[Period] VARCHAR (500) NOT NULL,
[ReportingManager] VARCHAR (500) NOT NULL,
[RMId] INT NOT NULL
)
IF EXISTS(SELECT 1 FROM LeaveRequestApplication WHERE UserId=@UserId AND StatusId NOT IN (-1,0,3,4))
	BEGIN
	INSERT INTO  #PendingApprovals([Type],[Period],[ReportingManager],[RMId])
	SELECT 'Leave',CAST(D.[Date] AS VARCHAR(50)) + '  To  ' + CAST(DT.[Date] AS VARCHAR(50)),V.[FirstName] + ' ' + V.[MiddleName] + ' ' + V.[LastName],L.[ApproverId]
	FROM [dbo].[LeaveRequestApplication] L WITH (NOLOCK)
	INNER JOIN [dbo].[DateMaster] D ON D.[DateId]=L.FromDateId
	INNER JOIN [dbo].[DateMaster] DT ON DT.[DateId]=L.TillDateId 
	INNER JOIN [dbo].[UserDetail] V ON V.[UserId]=L.[ApproverId]
	WHERE L.[UserId]=@UserId AND L.[StatusId] NOT IN (-1,0,3,4) AND L.[LeaveCombination] IS NOT NULL
	END
IF EXISTS(SELECT 1 FROM RequestCompOff WHERE CreatedBy=@UserId AND StatusId NOT IN (-1,0,3,4))
	BEGIN
	INSERT INTO  #PendingApprovals([Type],[Period],[ReportingManager],[RMId])
	SELECT 'CompOff',CAST(D.[Date] AS VARCHAR(50)),V.[FirstName]+' '+V.[MiddleName]+' '+V.[LastName],R.[ApproverId]
	FROM [dbo].[RequestCompOff] R WITH (NOLOCK)
	INNER JOIN [dbo].[DateMaster] D ON D.[DateId]=R.DateId
	INNER JOIN [dbo].[UserDetail] V ON V.[UserId]=R.[ApproverId]
	WHERE R.[CreatedBy]=@UserId AND StatusId NOT IN (-1,0,3,4)
	END
IF EXISTS(SELECT 1 FROM LeaveRequestApplication WHERE CreatedBy=@UserId AND StatusId NOT IN (-1,0,3,4) AND LeaveCombination IS NULL)
	BEGIN
	INSERT INTO  #PendingApprovals([Type],[Period],[ReportingManager],[RMId])
	SELECT 'WFH',CAST(D.[Date] AS VARCHAR(50)) + '  To  ' + CAST(DT.[Date] AS VARCHAR(50)),V.[FirstName]+' '+V.[MiddleName]+' '+V.[LastName],L.[ApproverId]
	FROM [dbo].[LeaveRequestApplication] L WITH (NOLOCK)
	INNER JOIN [dbo].[DateMaster] D ON D.[DateId]=L.FromDateId
	INNER JOIN [dbo].[DateMaster] DT ON DT.[DateId]=L.TillDateId 
	INNER JOIN [dbo].[UserDetail] V ON V.[UserId]=L.[ApproverId]
	WHERE L.[UserId]=@UserId AND L.[StatusId] NOT IN (-1,0,3,4) AND L.[LeaveCombination] IS NULL
	END
IF EXISTS(SELECT 1 FROM OutingRequest WHERE UserId=@UserId AND StatusId NOT IN (5,6,7,8))
	BEGIN
	INSERT INTO  #PendingApprovals([Type],[Period],[ReportingManager],[RMId])
	SELECT 'OutDuty/Tour',CAST(D.[Date] AS VARCHAR(50)) + '  To  ' + CAST(DT.[Date] AS VARCHAR(50)),V.[FirstName]+' '+V.[MiddleName]+' '+V.[LastName],O.[NextApproverId]
	FROM [dbo].[OutingRequest] O WITH (NOLOCK)
	INNER JOIN [dbo].[DateMaster] D ON D.[DateId]=O.FromDateId
	INNER JOIN [dbo].[DateMaster] DT ON DT.[DateId]=O.TillDateId 
	INNER JOIN [dbo].[UserDetail] V ON V.[UserId]=O.[NextApproverId]
	WHERE O.[UserId]=@UserId AND O.[StatusId] NOT IN (5,6,7,8)
	END
IF EXISTS(SELECT 1 FROM LegitimateLeaveRequest WHERE UserId=@UserId AND StatusId NOT IN (5,6,7,8))
	BEGIN
	INSERT INTO  #PendingApprovals([Type],[Period],[ReportingManager],[RMId])
	SELECT 'LWP Change',CAST(D.[Date] AS VARCHAR(50)),V.[FirstName]+' '+V.[MiddleName]+' '+V.[LastName],L.[NextApproverId]
	FROM [dbo].[LegitimateLeaveRequest] L WITH (NOLOCK)
	INNER JOIN [dbo].[DateMaster] D ON D.[DateId]=L.DateId
	INNER JOIN [dbo].[UserDetail] V ON V.[UserId]=L.[NextApproverId]
	WHERE L.[UserId]=@UserId AND L.[StatusId] NOT IN (5,6,7,8)
	END
IF EXISTS(SELECT 1 FROM TempUserShift WHERE UserId=@UserId AND StatusId NOT IN (5,6,7,8))
	BEGIN
	INSERT INTO  #PendingApprovals([Type],[Period],[ReportingManager],[RMId])
	SELECT 'LNSA Shift',DT.[Date],V.[FirstName]+' '+V.[MiddleName]+' '+V.[LastName],T.[ApproverId]
	FROM [dbo].[TempUserShift] T WITH (NOLOCK)
	INNER JOIN [dbo].[TempUserShiftDetail] TD ON TD.[TempUserShiftId]=T.[TempUserShiftId]
	INNER JOIN [dbo].[DateMaster] DT ON DT.[DateId]=TD.DateId 
	INNER JOIN [dbo].[UserDetail] V ON V.[UserId]=T.[ApproverId]
	WHERE T.[UserId]=@UserId AND T.[StatusId] NOT IN (4,5,6,7,8)
	END
IF EXISTS(SELECT 1 FROM AttendanceDataChangeRequestApplication WHERE CreatedBy=@UserId AND StatusId NOT IN (-1,0,3,4))
	BEGIN
	INSERT INTO  #PendingApprovals([Type],[Period],[ReportingManager],[RMId])
	SELECT 'Data Change',AD.[CategoryCode],V.[EmployeeName],A.[ApproverId]
	FROM [dbo].[AttendanceDataChangeRequestApplication] A WITH (NOLOCK)
	INNER JOIN [dbo].[AttendanceDataChangeRequestCategory] AD ON A.[RequestCategoryId]=AD.[CategoryId]
	INNER JOIN [dbo].[vwActiveUsers] V ON V.[UserId]=A.[ApproverId]
	WHERE A.[CreatedBy]=@UserId AND StatusId NOT IN (-1,0,3,4)
	END
--IF EXISTS(SELECT 1 FROM TimeSheet WHERE CreatedBy=2434 AND [Status] NOT IN (-1,2))
--	BEGIN
--	INSERT INTO  #PendingApprovals([Type],[Period])
--	SELECT 'Timesheet',CAST(T.[StartDate] AS VARCHAR(50)) + '  To  ' + CAST(T.[EndDate] AS VARCHAR(50)) 
--	FROM [dbo].[TimeSheet] T WITH (NOLOCK)
--	WHERE T.[CreatedBy]=@UserId AND T.[Status] NOT IN (-1,2)
--	END
SELECT [Type],[Period],[ReportingManager],[RMId] FROM #PendingApprovals
END
GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateApproverIdOnManagerChange]    Script Date: 03-10-2018 16:15:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_UpdateApproverIdOnManagerChange]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_UpdateApproverIdOnManagerChange] AS' 
END
GO
/***
   Created Date      :     2018-09-28
   Created By        :     Mimansa Agrawal
   Purpose           :     This procedure is used to update rmIds for users to approve pending requests from previous manager
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
EXEC Proc_UpdateApproverIdOnManagerChange
@EmployeeId=2277,
@RMId=47,
@UserId=2167
**/
ALTER PROCEDURE [dbo].[Proc_UpdateApproverIdOnManagerChange]
@EmployeeId INT,
@RMId INT,
@UserId INT
AS
BEGIN
SET NOCOUNT ON;
SET FMTONLY OFF;  
UPDATE [dbo].[UserDetail] SET ReportTo=@RMId WHERE UserId=@EmployeeId
IF EXISTS(SELECT 1 FROM LeaveRequestApplication WHERE UserId=@EmployeeId AND StatusId IN (1,5))
	BEGIN
	UPDATE L
	SET L.[ApproverId]=@RMId,
	L.[LastModifiedBy]=@UserId,L.[LastModifiedDate]=GETDATE()
	FROM [dbo].[LeaveRequestApplication] L WITH (NOLOCK)
    WHERE L.[UserId]=@EmployeeId AND L.[StatusId] IN (1,5) AND L.[LeaveCombination] IS NOT NULL
	UPDATE L
	SET L.[ApproverId]=@RMId
	FROM [dbo].[LeaveHistory] L WITH (NOLOCK)
	INNER JOIN [dbo].[LeaveRequestApplication] LV ON LV.[LeaveRequestApplicationId]=L.[LeaveRequestApplicationId]
	WHERE LV.[UserId]=@EmployeeId AND L.[StatusId] IN (1,5,2) AND LV.[LeaveCombination] IS NOT NULL
	END
IF EXISTS(SELECT 1 FROM RequestCompOff WHERE CreatedBy=@EmployeeId AND StatusId IN (1,5))
	BEGIN
	UPDATE R
	SET R.ApproverId=@RMId,R.[LastModifiedBy]=@UserId,R.[LastModifiedDate]=GETDATE()
	FROM [dbo].[RequestCompOff] R WITH (NOLOCK)
	WHERE R.[CreatedBy]=@EmployeeId AND R.[StatusId] IN (1,5)
	UPDATE R
	SET R.ApproverId=@RMId
	FROM [dbo].[RequestCompOffHistory] RH WITH (NOLOCK)
	INNER JOIN [dbo].[RequestCompOff] R ON R.[RequestId]=RH.[RequestId]
	WHERE R.[CreatedBy]=@EmployeeId AND R.[StatusId] IN (1,5,2)
	END
IF EXISTS(SELECT 1 FROM LeaveRequestApplication WHERE CreatedBy=@EmployeeId AND StatusId IN (1,5) AND LeaveCombination IS NULL)
	BEGIN
	UPDATE L
	SET L.ApproverId=@RMId,L.[LastModifiedBy]=@UserId,L.[LastModifiedDate]=GETDATE()
	FROM [dbo].[LeaveRequestApplication] L WITH (NOLOCK)
	WHERE L.[UserId]=@EmployeeId AND L.[StatusId] IN (1,5) AND L.[LeaveCombination] IS NULL
	UPDATE L
	SET L.[ApproverId]=@RMId
	FROM [dbo].[LeaveHistory] L WITH (NOLOCK)
	INNER JOIN [dbo].[LeaveRequestApplication] LV ON LV.[LeaveRequestApplicationId]=L.[LeaveRequestApplicationId]
	WHERE LV.[UserId]=@EmployeeId AND L.[StatusId] IN (1,5,2) AND LV.[LeaveCombination] IS NULL
	END
IF EXISTS(SELECT 1 FROM OutingRequest WHERE UserId=@EmployeeId AND StatusId NOT IN (3,5,6,7,8))
	BEGIN
	UPDATE O
	SET O.[NextApproverId]=@RMId,O.[ModifiedById]=@UserId,O.[ModifiedDate]=GETDATE()
	FROM [dbo].[OutingRequest] O WITH (NOLOCK)
	WHERE O.[UserId]=@EmployeeId AND O.[StatusId] NOT IN (3,5,6,7,8)
	END
IF EXISTS(SELECT 1 FROM LegitimateLeaveRequest WHERE UserId=@EmployeeId AND StatusId NOT IN (3,5,6,7,8))
	BEGIN
	UPDATE L
	SET L.[NextApproverId]=@RMId,L.[LastModifiedBy]=@UserId,L.[LastModifiedDate]=GETDATE()
	FROM [dbo].[LegitimateLeaveRequest] L WITH (NOLOCK)
	INNER JOIN [dbo].[UserDetail] V ON V.[UserId]=L.[NextApproverId]
	WHERE L.[UserId]=@EmployeeId AND L.[StatusId] NOT IN (3,5,6,7,8)
	END
IF EXISTS(SELECT 1 FROM TempUserShift WHERE UserId=@EmployeeId AND StatusId NOT IN (3,5,6,7,8))
	BEGIN
	UPDATE T
	SET T.[ApproverId]=@RMId,T.[LastModifiedBy]=@UserId,T.[LastModifiedDate]=GETDATE()
	FROM [dbo].[TempUserShift] T WITH (NOLOCK)
	INNER JOIN [dbo].[TempUserShiftDetail] TD ON TD.[TempUserShiftId]=T.[TempUserShiftId]
	WHERE T.[UserId]=@EmployeeId AND T.[StatusId] NOT IN (3,5,6,7,8)
	END
IF EXISTS(SELECT 1 FROM AttendanceDataChangeRequestApplication WHERE CreatedBy=@EmployeeId AND StatusId IN (1,5))
	BEGIN
	UPDATE A
	SET A.[ApproverId]=@RMId,A.[LastModifiedBy]=@UserId,A.[LastModifiedDate]=GETDATE()
	FROM [dbo].[AttendanceDataChangeRequestApplication] A WITH (NOLOCK)
	WHERE A.[CreatedBy]=@EmployeeId AND StatusId IN (1,5)
	UPDATE AD
	SET AD.[ApproverId]=@RMId
	FROM [dbo].[AttendanceDataChangeRequestApplication] A WITH (NOLOCK)
	INNER JOIN [dbo].[AttendanceDataChangeRequestHistory] AD ON A.[RequestApplicationId]=AD.[RequestId]
	WHERE A.[CreatedBy]=@EmployeeId AND A.[StatusId] IN (1,5,2)
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spGetLeaves]    Script Date: 03-10-2018 16:15:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetLeaves]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGetLeaves] AS' 
END
GO
/***
	Created Date      :     2016-01-27
	Created By        :     Nishant Srivastava
	Purpose           :     This stored procedure Get leave Deatils According to User status 
   
	Change History    :
	--------------------------------------------------------------------------
	Modify Date       Edited By            Change Description
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	Test Cases        :
	--------------------------------------------------------------------------
	EXEC [dbo].[spGetLeaves] @UserId = 47
***/
ALTER PROCEDURE [dbo].[spGetLeaves] 
   @UserId [int]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @AdminId int = 1;

	SELECT 
      L.[LeaveRequestApplicationId] AS [ApplicationId]
     ,E.[FirstName] + ' ' + E.[LastName] AS [EmployeeName]
     ,FD.[Date] AS [FromDate]
     ,TD.[Date] AS [ToDate]
     ,CAST(L.[NoOfWorkingDays] AS [varchar](10)) + ' (' + L.[LeaveCombination] + ')' AS [LeaveInfo]
     ,L.[Reason]
	 ,L.[CreatedDate]
     ,LS.[StatusCode]
	 ,CASE
         WHEN LS.[StatusCode] = 'CA' THEN L.[ApproverRemarks]
         WHEN H.[ApproverRemarks] IS NULL THEN 'NA'
         WHEN LTRIM(RTRIM(H.[ApproverRemarks])) = '' THEN LAP.[FirstName] + ' ' + LAP.[LastName] + ': Approved'
		 WHEN (L.[ApproverId] = @AdminId AND L.[CreatedBy] = @AdminId) THEN H.[ApproverRemarks]
         ELSE LAP.[FirstName] + ' ' + LAP.[LastName] + ': ' + H.[ApproverRemarks]
      END                                                               AS [ApproverRemarks]                                                    


      ,CASE  
         WHEN LS.[StatusCode] = 'RJ' THEN LS.[Status] + ' by ' + NAP.[FirstName] + ' ' + NAP.[LastName]
         WHEN LS.[StatusCode] = 'PA' AND L.[ApproverId] != @UserId THEN LS.[Status] + ' from ' + NAP.[FirstName] + ' ' + NAP.[LastName]
         WHEN LS.[StatusCode] = 'PV' AND L.[ApproverId] != @UserId THEN LS.[Status]
         ELSE LS.[Status]  
      END                                   AS [Status]    
     ,ISNULL(UH.[StatusId], L.[StatusId])   AS [StatusId]
     ,L.[UserId]                            AS [ApplicantId]
   FROM [dbo].[LeaveRequestApplication] L WITH (NOLOCK)
	INNER JOIN [dbo].[UserDetail] E WITH (NOLOCK) ON E.[UserId] = L.[UserId]
	INNER JOIN
	(
		SELECT LD.[LeaveRequestApplicationId] AS [LeaveRequestApplicationId], MAX(LD.[LeaveRequestApplicationDetailId]) AS [LatestRecordId]                                          
		FROM [dbo].[LeaveRequestApplicationDetail] LD WITH (NOLOCK)
		INNER JOIN [dbo].[LeaveTypeMaster] LT WITH (NOLOCK) ON LT.[TypeId] = LD.[LeaveTypeId]
		WHERE LT.[ShortName] != 'WFH'
		GROUP BY LD.[LeaveRequestApplicationId]      
	) RLD ON RLD.[LeaveRequestApplicationId] = L.[LeaveRequestApplicationId]
	INNER JOIN [dbo].[LeaveRequestApplicationDetail] LD WITH (NOLOCK) ON LD.[LeaveRequestApplicationDetailId] = RLD.[LatestRecordId]
	INNER JOIN [dbo].[DateMaster] FD WITH (NOLOCK) ON FD.[DateId] = L.[FromDateId]
	INNER JOIN [dbo].[DateMaster] TD WITH (NOLOCK) ON TD.[DateId] = L.[TillDateId]
	INNER JOIN [dbo].[LeaveStatusMaster] LS WITH (NOLOCK) ON LS.[StatusId] = L.[StatusId]
	LEFT JOIN [dbo].[UserDetail] NAP WITH (NOLOCK) ON NAP.[UserId] = L.[ApproverId]
	LEFT JOIN
	(
		SELECT H.[LeaveRequestApplicationId] AS [LeaveRequestApplicationId], MAX(H.[CreatedDate]) AS [LatestModifiedTime]
		FROM [dbo].[LeaveHistory] H WITH (NOLOCK)
		GROUP BY H.[LeaveRequestApplicationId]
	) RH ON RH.[LeaveRequestApplicationId] = L.[LeaveRequestApplicationId] 
	LEFT JOIN [dbo].[LeaveHistory] H WITH (NOLOCK) ON H.[LeaveRequestApplicationId] = L.[LeaveRequestApplicationId] AND H.[CreatedDate] = RH.[LatestModifiedTime]
	LEFT JOIN [dbo].[UserDetail] LAP WITH (NOLOCK) ON LAP.[UserId] = H.[CreatedBy]
	LEFT JOIN [dbo].[LeaveHistory] UH WITH (NOLOCK) ON UH.[LeaveRequestApplicationId] = L.[LeaveRequestApplicationId] AND UH.[CreatedBy] = @UserId
   WHERE ((L.[ApproverId] = @UserId OR UH.[CreatedBy] = @UserId) 
		   OR (L.[ApproverId] = @AdminId AND L.[CreatedBy] = @AdminId 
				AND (@UserId = [dbo].[fnGetReportingManagerByUserId](L.UserId)
					 OR @UserId = [dbo].[fnGetSecondReportingManagerByUserId](L.UserId)
					 OR @UserId = [dbo].[fnGetHRIdByUserId](L.UserId))
					)
		  )
     -- AND L.[CreatedDate] >= DATEADD(MM, -6, GETDATE())
      AND L.[UserId] != @UserId
   ORDER BY FD.[Date] DESC, E.[FirstName] + ' ' + E.[LastName]
END



GO
