GO
/****** Object:  StoredProcedure [dbo].[spGetUserAppliedLeave]    Script Date: 04-01-2019 20:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
   Test Cases        :
   --------------------------------------------------------------------------
   EXEC [dbo].[spGetUserAppliedLeave] 
		@UserId = 2431
		,@Year=2018
	    ,@IsWFHData = 1
***/

CREATE PROCEDURE [dbo].[spGetUserAppliedLeave] 
   @UserID [int],
   @Year [int] = null,
   @IsWFHData [bit] = 0
  AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @StartDate [date], @EndDate [date], @AdminId int = 1,@IsApplied Int, @JoiningDate [DATE]
	SELECT @JoiningDate = [JoiningDate] FROM [dbo].[UserDetail] WITH (NOLOCK) WHERE [UserId] = @UserID
	 
	IF (@Year IS NULL OR @Year =0)
		SET @Year = DATEPART(YYYY, GETDATE())

	SELECT @StartDate = dateadd(Month,0,cast(concat(@Year,'-04-01') as date)),
			@EndDate = dateadd(Year,1,cast(concat(@Year,'-03-31') as date)) 
	
	IF(DATEPART(YYYY,@JoiningDate)=DATEPART(YYYY, @StartDate) AND DATEPART(mm,@JoiningDate)<DATEPART(mm,@StartDate))
		SELECT @StartDate = @JoiningDate
IF(@IsWFHData=0)
BEGIN
	SELECT DISTINCT
		 LR.[CreatedDate]																									AS [ApplyDate]
		,LR.[LeaveRequestApplicationId]																						AS [LeaveApplicationId]
		,DM1.[Date]																											AS [FromDate]
		,DM2.[Date]																											AS [TillDate]
		,CASE WHEN LR.[LeaveCombination] LIKE '%ML%' THEN CAST(LR.[LeaveCombination] AS [varchar](8)) + ' (' + LR.[LeaveCombination] + ')'
		 ELSE CAST(LR.[NoOfWorkingDays] AS [varchar](3)) + ' (' + LR.[LeaveCombination] + ')'	END AS [LeaveInfo]
		,LR.[Reason]																										AS [Reason]
		,LS.[StatusCode]																									AS [Status]
		,CASE LS.[StatusCode] 
			WHEN 'RJ' THEN LS.[Status] + ' by ' + UD.[FirstName] + ' ' + UD.[LastName]
			WHEN 'PA' THEN LS.[Status] + ' with ' + UD.[FirstName] + ' ' + UD.[LastName]
         ELSE LS.[Status]
		 END																												AS [StatusFullForm]
		,CASE WHEN F.[LegitimateLeaveRequestId] > 0 AND F.StatusId < 6  THEN CAST (1 AS [BIT])  ELSE CAST (0 AS [BIT]) END	AS [IsApplied]
		,CASE 
			WHEN LS.[StatusCode] = 'CA' THEN LS.[Status]
			WHEN RH.[ApproverRemarks] IS NULL THEN ''
			WHEN RH.[ApproverRemarks] = '' THEN UD1.[FirstName] + ' ' + UD1.[LastName] + ': Approved'
			WHEN (RH.[ApproverId] = @AdminId AND RH.[CreatedBy] = @AdminId) THEN RH.[ApproverRemarks]
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
			[dbo].[UserDetail] UD1 WITH (NOLOCK) ON UD1.[UserId] = RH.[CreatedBy]--RH.[ApproverId]
	WHERE 
      LR.[UserId] = @UserId
      AND DM1.[Date] BETWEEN @StartDate AND @EndDate	 
   ORDER BY  LR.[CreatedDate] DESC, DM1.[Date] DESC 
   END
   IF(@IsWFHData=1)
   BEGIN
   SELECT DISTINCT
		 LR.[CreatedDate]																									AS [ApplyDate]
		,LR.[LeaveRequestApplicationId]																						AS [LeaveApplicationId]
		,DM1.[Date]																											AS [FromDate]
		,DM2.[Date]																											AS [TillDate]
		,CASE WHEN LR.[LeaveCombination] LIKE '%ML%' THEN CAST(LR.[LeaveCombination] AS [varchar](8)) + ' (' + LR.[LeaveCombination] + ')'
		WHEN LR.[LeaveCombination] IS NULL THEN  'WFH'
		 ELSE CAST(LR.[NoOfWorkingDays] AS [varchar](3)) + ' (' + LR.[LeaveCombination] + ')'	END AS [LeaveInfo]
		,LR.[Reason]																										AS [Reason]
		,LS.[StatusCode]																									AS [Status]
		,CASE LS.[StatusCode] 
			WHEN 'RJ' THEN LS.[Status] + ' by ' + UD.[FirstName] + ' ' + UD.[LastName]
			WHEN 'PA' THEN LS.[Status] + ' with ' + UD.[FirstName] + ' ' + UD.[LastName]
         ELSE LS.[Status]
		 END																												AS [StatusFullForm]
		,CASE WHEN F.[LegitimateLeaveRequestId] > 0 AND F.StatusId < 6  THEN CAST (1 AS [BIT])  ELSE CAST (0 AS [BIT]) END	AS [IsApplied]
		,CASE 
			WHEN LS.[StatusCode] = 'CA' THEN LS.[Status]
			WHEN RH.[ApproverRemarks] IS NULL THEN ''
			WHEN RH.[ApproverRemarks] = '' THEN UD1.[FirstName] + ' ' + UD1.[LastName] + ': Approved'
			WHEN (RH.[ApproverId] = @AdminId AND RH.[CreatedBy] = @AdminId) THEN RH.[ApproverRemarks]
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
   END
GO
