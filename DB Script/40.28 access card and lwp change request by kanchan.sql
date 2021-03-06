
/****** Object:  StoredProcedure [dbo].[spGetUserAppliedLeaveForLWPChangeRequest]    Script Date: 21-02-2019 12:35:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetUserAppliedLeaveForLWPChangeRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetUserAppliedLeaveForLWPChangeRequest]
GO
/****** Object:  StoredProcedure [dbo].[spGetUserAppliedLeave]    Script Date: 21-02-2019 12:35:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetUserAppliedLeave]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetUserAppliedLeave]
GO
/****** Object:  StoredProcedure [dbo].[spAddUserAccessCardMapping]    Script Date: 21-02-2019 12:35:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spAddUserAccessCardMapping]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spAddUserAccessCardMapping]
GO
/****** Object:  StoredProcedure [dbo].[spAddUserAccessCardMapping]    Script Date: 21-02-2019 12:35:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spAddUserAccessCardMapping]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spAddUserAccessCardMapping] AS' 
END
GO
/***
   Created Date      :     2016-09-27
   Created By        :     Shubhra Upadhyay
   Purpose           :     This stored proc is used to add new access cardtus
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By           Change Description
   2018-05-04        kanchan kumari       for staff access card mapping
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   DECLARE @result [int],  @mappingId BIGINT
        EXEC [dbo].[spAddUserAccessCardMapping]
		 @accessCardId = 284
        ,@userId = 4
        ,@IsPimcoUserCardMapping = 0
        ,@createdBy = 2167
		,@IsStaff = 1
		,@fromDate='2018-05-14'
		,@Success= @result output
		,@UserCardMappingId = @mappingId output
		SELECT @result AS Result,  @mappingId AS UserCardMappingId
***/
ALTER PROCEDURE [dbo].[spAddUserAccessCardMapping] 
(
      @AccessCardId [int]
     ,@UserId [int]
     ,@IsPimcoUserCardMapping [bit]
     ,@CreatedBy [int]
	 ,@IsStaff bit
	 ,@fromDate Date
	 ,@UserCardMappingId bigint output
	 ,@Success [tinyint] output
)
AS
BEGIN TRY
SET NOCOUNT ON;
	DECLARE @MaxAssignedTillDate DATE
	IF(@IsStaff=1)
	BEGIN
		  SELECT @MaxAssignedTillDate = MAX(AssignedTillDate) FROM UserAccessCard WITH (NOLOCK) WHERE  StaffUserId=@UserId
	END
	ELSE
	BEGIN
		  SELECT @MaxAssignedTillDate = MAX(AssignedTillDate) FROM UserAccessCard WITH (NOLOCK) WHERE  UserId=@UserId
     END
BEGIN TRANSACTION
	IF(@MaxAssignedTillDate IS NULL OR @fromDate>@MaxAssignedTillDate)
	BEGIN
		IF(@IsStaff=0)
		BEGIN
			INSERT INTO [dbo].[UserAccessCard]
			( [AccessCardId], [UserId], [IsPimco], [CreatedBy],[AssignedFromDate])
			VALUES
			(@AccessCardId, @UserId, @IsPimcoUserCardMapping, @CreatedBy, @fromDate)
			SET @UserCardMappingId = SCOPE_IDENTITY()
		END
		ELSE
		BEGIN
			INSERT INTO [dbo].[UserAccessCard]
			( [AccessCardId], [StaffUserId], [IsPimco], [CreatedBy],[AssignedFromDate])
			VALUES
			( @AccessCardId, @UserId, @IsPimcoUserCardMapping, @CreatedBy, @fromDate)
			SET @UserCardMappingId = SCOPE_IDENTITY()
		END
    SET @Success=1;--sucessfully mapped card
	END
	ELSE
	BEGIN
	SET @Success=2;--fromDate should be greater than Max of old assigned till date
	END
	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
     IF @@TRANCOUNT>0
	 BEGIN
      ROLLBACK TRANSACTION;
	END
    DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
    EXEC [spInsertErrorLog]
	        @ModuleName = 'AccessCard'
        ,@Source = 'spAddUserAccessCardMapping'
        ,@ErrorMessage = @ErrorMessage
        ,@ErrorType = 'SP'
        ,@ReportedByUserId = @UserId

    SET @Success=0;
	SET @UserCardMappingId = 0;
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[spGetUserAppliedLeave]    Script Date: 21-02-2019 12:35:24 ******/
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
		,@IsOuting = 1
		,@IsLnsa = 1
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
	 [LegitimateAppliedOn] VARCHAR(30),
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
		,F.LegitimateAppliedOn
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
					SELECT UserId, DateId, CONVERT(VARCHAR(11),CreatedDate,106)+' '+ FORMAT(CreatedDate, 'hh:mm tt') AS LegitimateAppliedOn
					FROM [LegitimateLeaveRequest]    ----LegitimateLeaveStatus
					WHERE UserId = @UserId AND StatusId <= 5 --not rejected or cancelled
					GROUP BY UserId, DateId, CreatedDate
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
		,F.[LegitimateAppliedOn]
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
					SELECT UserId, DateId, CONVERT(VARCHAR(11),CreatedDate,106)+' '+ FORMAT(CreatedDate, 'hh:mm tt') AS LegitimateAppliedOn
					FROM [LegitimateLeaveRequest]    ----LegitimateLeaveStatus
					WHERE UserId = @UserId AND StatusId <= 5 --not rejected or cancelled
					GROUP BY UserId, DateId, CreatedDate
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
		,NULL AS [LegitimateAppliedOn]
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
		,NULL AS [LegitimateAppliedOn]
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
	      [Reason], [Status], [StatusFullForm], [IsLegitimateApplied], [LegitimateAppliedOn], [Remarks], [LeaveCount], [CreatedBy] 
   FROM #TempUserAppliedLeave 
   GROUP BY [FetchLeaveType], [ApplyDate], [LeaveRequestApplicationId], [FromDate], [TillDate], [LeaveInfo] ,
	        [Reason], [Status], [StatusFullForm], [IsLegitimateApplied],[LegitimateAppliedOn], [Remarks], [LeaveCount], [CreatedBy] 
   ORDER BY [ApplyDate] DESC, [FromDate] DESC
   END


GO
/****** Object:  StoredProcedure [dbo].[spGetUserAppliedLeaveForLWPChangeRequest]    Script Date: 21-02-2019 12:35:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetUserAppliedLeaveForLWPChangeRequest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGetUserAppliedLeaveForLWPChangeRequest] AS' 
END
GO
/***
   Created Date      :    2019-01-02
   Created By        :    Kanchan kumari
   Purpose           :    Retrives details for leave for lwp change request
   Usage			 :	  EXEC [dbo].[spGetUserAppliedLeaveForLWPChangeRequest] @UserId = 2432
   --------------------------------------------------------------------------
***/
ALTER PROC [dbo].[spGetUserAppliedLeaveForLWPChangeRequest]
( 
	@UserId [int]  
)
AS
BEGIN
	DECLARE @PrevDate [date], @StartDate DATE, @EndDate date, @CurrentDate DATETIME, @FutureDate DATE, @CutOffTime DATETIME
		SET @CurrentDate = GETDATE();
		SET @PrevDate = dateadd(m, -1, @CurrentDate)
		SET @FutureDate = dateadd(m, 1, @CurrentDate)
	    SELECT @StartDate = DATEFROMPARTS(DATEPART(yyyy,@PrevDate),DATEPART(m,@PrevDate), 25)
	    SELECT @EndDate = DATEFROMPARTS(DATEPART(yyyy,@CurrentDate),DATEPART(m,@CurrentDate), 26)
		SET @CutOffTime = cast(@EndDate as datetime) + cast(convert(Time,'12:00:00.0000001')  as datetime)

IF(@CurrentDate > @CutOffTime)
BEGIN
        SELECT @StartDate = DATEFROMPARTS(DATEPART(yyyy,@CurrentDate),DATEPART(m,@CurrentDate), 25)
		SELECT @EndDate = DATEFROMPARTS(DATEPART(yyyy,@FutureDate),DATEPART(m,@FutureDate), 26)
END
	SELECT LR.LeaveRequestApplicationId AS LeaveId, DM.[Date]
	,CASE WHEN F.[LegitimateLeaveRequestId] > 0 AND F.StatusId < 6  THEN CAST (1 AS [BIT])  ELSE CAST (0 AS [BIT]) END	AS [IsApplied]
	FROM [dbo].[LeaveRequestApplication] LR WITH (NOLOCK)
	INNER JOIN [dbo].[LeaveStatusMaster] LS WITH (NOLOCK) ON LR.[StatusId] = LS.StatusId
	INNER JOIN DateMaster DM ON LR.FromDateId = DM.DateId 
	LEFT JOIN(SELECT LLR.* FROM 
				(SELECT MAX(LegitimateLeaveRequestId) AS LegitimateLeaveRequestId ,LeaveRequestApplicationId
				FROM [LegitimateLeaveRequest] 
				WHERE UserId=@UserId 
				GROUP BY LeaveRequestApplicationId
				) LL 
				INNER JOIN [LegitimateLeaveRequest] LLR ON LL.LegitimateLeaveRequestId=LLR.LegitimateLeaveRequestId
			) F
		ON F.LeaveRequestApplicationId = LR.[LeaveRequestApplicationId] 
	WHERE 
		LR.[UserId] = @UserId AND DM.[Date] BETWEEN @StartDate AND CAST(@CurrentDate AS DATE)
		AND LR.CreatedBy = 1 AND LS.[StatusCode] = 'AV' AND LR.LeaveCombination = '1 LWP' 
END
GO
