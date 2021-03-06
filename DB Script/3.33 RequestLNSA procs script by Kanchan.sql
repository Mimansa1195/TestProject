
/****** Object:  StoredProcedure [dbo].[spTakeActionOnLnsaRequest]    Script Date: 15-10-2018 19:21:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spTakeActionOnLnsaRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spTakeActionOnLnsaRequest]
GO
/****** Object:  StoredProcedure [dbo].[spInsertLnsaRequest]    Script Date: 15-10-2018 19:21:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spInsertLnsaRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spInsertLnsaRequest]
GO
/****** Object:  StoredProcedure [dbo].[spGetApproverRemarks]    Script Date: 15-10-2018 19:21:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetApproverRemarks]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetApproverRemarks]
GO
/****** Object:  StoredProcedure [dbo].[spFetchLastNApprovedLnsa]    Script Date: 15-10-2018 19:21:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spFetchLastNApprovedLnsa]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spFetchLastNApprovedLnsa]
GO
/****** Object:  StoredProcedure [dbo].[spFetchAllPendingLnsaRequestByManagerId]    Script Date: 15-10-2018 19:21:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spFetchAllPendingLnsaRequestByManagerId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spFetchAllPendingLnsaRequestByManagerId]
GO
/****** Object:  StoredProcedure [dbo].[spFetchAllLnsaRequestStatusByUserId]    Script Date: 15-10-2018 19:21:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spFetchAllLnsaRequestStatusByUserId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spFetchAllLnsaRequestStatusByUserId]
GO
/****** Object:  StoredProcedure [dbo].[spFetchAllApprovedLnsaRequest]    Script Date: 15-10-2018 19:21:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spFetchAllApprovedLnsaRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spFetchAllApprovedLnsaRequest]
GO
/****** Object:  StoredProcedure [dbo].[spFetchAllApprovedLnsaRequest]    Script Date: 15-10-2018 19:21:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spFetchAllApprovedLnsaRequest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spFetchAllApprovedLnsaRequest] AS' 
END
GO
/***
   Created Date      :     2016-07-11
   Created By        :     Shubhra Upadhyay
   Purpose           :     This stored proc is used to get all approved LNSA request by reporting manager Id between a given date
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   12 oct 2018         Kanchan kumari     used vwActiveUsers instead of userdetail 
                                          and added RequestLnsaHistory
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   
   --- Test Case 1
         EXEC [dbo].[spFetchAllApprovedLnsaRequest]
         @UserId = 1
		 ,@FromDate = '2016-05-17'
         ,@TillDate = '2016-05-20'

   --- Test Case 2
         EXEC [dbo].[spFetchAllApprovedLnsaRequest]
         @UserId = 22
		 ,@FromDate = '2016-05-17'
         ,@TillDate = '2016-05-20'
***/

ALTER PROCEDURE [dbo].[spFetchAllApprovedLnsaRequest] 
    @UserId [int]
   ,@FromDate [datetime]
   ,@TillDate [datetime]
AS
BEGIN
	
SET NOCOUNT ON;
      SELECT 
		 R.[RequestId] AS [RequestId], U.[EmployeeName], D.[Date] AS [FromDate]
        ,M.[Date] AS [TillDate], R.[TotalNoOfDays] AS [NoOfDays]
        ,R.[Reason] AS [Reason]
		 ,CASE WHEN LS.StatusCode = 'PA' THEN  LS.[Status]+' with '+UD.EmployeeFirstName+' '+UD.EmployeeLastName 
		  ELSE LS.[Status]+' by '+VW.EmployeeFirstName+' '+VW.EmployeeLastName END AS [Status]
		 ,CASE WHEN R.ApproverId IS NULL THEN LS.StatusCode ELSE 'PV' END AS [StatusCode]
      FROM
         [dbo].[RequestLnsa] R WITH (NOLOCK)
        INNER JOIN [dbo].[DateMaster] D WITH (NOLOCK) ON D.[DateId] = R.[FromDateId]
        INNER JOIN [dbo].[DateMaster] M WITH (NOLOCK) ON M.[DateId] = R.[TillDateId]
		INNER JOIN [dbo].[vwActiveUsers] U WITH (NOLOCK) ON U.[UserId] = R.[CreatedBy]
		INNER JOIN [dbo].[LNSAStatusMaster] LS WITH (NOLOCK) ON R.StatusId = LS.StatusId
		LEFT JOIN [dbo].[vwActiveUsers] UD WITH (NOLOCK) ON R.ApproverId = UD.UserId
		LEFT JOIN [dbo].[vwActiveUsers] VW WITH (NOLOCK) ON R.[LastModifiedBy] = VW.UserId
		INNER JOIN [dbo].[RequestLnsaHistory] RH ON R.RequestId = RH.RequestId 
		INNER JOIN [dbo].[LNSAStatusMaster] LM ON RH.StatusId = LM.StatusId
      WHERE
         RH.CreatedBy = @UserId AND R.CreatedBy != @UserId
		 --AND R.[Status] = 1
		 AND
		 (
			D.[Date] BETWEEN @FromDate AND @TillDate OR
            M.[Date] BETWEEN @FromDate AND @TillDate OR
            @FromDate BETWEEN D.[Date] AND M.[Date]
		 )
      ORDER BY D.[Date] DESC
END




GO
/****** Object:  StoredProcedure [dbo].[spFetchAllLnsaRequestStatusByUserId]    Script Date: 15-10-2018 19:21:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spFetchAllLnsaRequestStatusByUserId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spFetchAllLnsaRequestStatusByUserId] AS' 
END
GO
/***
   Created Date      :     2016-07-11
   Created By        :     Shubhra Upadhyay
   Purpose           :     To get status of all LNSA request on basis of userId
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
    12 oct 2018       Kanchan Kumari      used [vwActiveUsers] instead of UserDetail 
                                          and used [LNSAStatusMaster]
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   --- Test Case 1
         EXEC [dbo].[spFetchAllLnsaRequestStatusByUserId]
        @UserId = 1

   --- Test Case 2
         EXEC [dbo].[spFetchAllLnsaRequestStatusByUserId]
         @UserId = 2166
***/

ALTER PROCEDURE [dbo].[spFetchAllLnsaRequestStatusByUserId] 
   @UserId [int]
AS
BEGIN
	
SET NOCOUNT ON;
      SELECT 
         D.[Date]            AS [FromDate]
        ,M.[Date]            AS [TillDate]
        ,R.[TotalNoOfDays]   AS [NoOfDays]
        ,R.[Reason]          
		,R.[ApproverRemarks] AS [Remarks]
		,LS.StatusCode   
		,R.RequestId          
        ,CASE WHEN LS.StatusCode = 'PA' THEN  LS.[Status]+' with '+UD.EmployeeFirstName+' '+UD.EmployeeLastName 
		  ELSE LS.[Status]+' by '+VW.EmployeeFirstName+' '+VW.EmployeeLastName END AS [Status]
      FROM
         [dbo].[RequestLnsa] R WITH (NOLOCK)
            INNER JOIN [dbo].[DateMaster] D WITH (NOLOCK) ON D.[DateId] = R.[FromDateId]
            INNER JOIN [dbo].[DateMaster] M WITH (NOLOCK) ON M.[DateId] = R.[TillDateId]
		    LEFT JOIN [dbo].[vwActiveUsers] UD WITH (NOLOCK) ON R.ApproverId = UD.UserId
		    LEFT JOIN [dbo].[vwActiveUsers] VW WITH (NOLOCK) ON R.[LastModifiedBy] = VW.UserId
			INNER JOIN [dbo].[LNSAStatusMaster] LS WITH (NOLOCK) ON R.StatusId = LS.StatusId
      WHERE
         R.[CreatedBy] = @UserId
      ORDER BY D.[Date] DESC
END





GO
/****** Object:  StoredProcedure [dbo].[spFetchAllPendingLnsaRequestByManagerId]    Script Date: 15-10-2018 19:21:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spFetchAllPendingLnsaRequestByManagerId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spFetchAllPendingLnsaRequestByManagerId] AS' 
END
GO
ALTER PROCEDURE [dbo].[spFetchAllPendingLnsaRequestByManagerId] 
   @LoginUserId [int]
AS
BEGIN
SET NOCOUNT ON;
	  --DECLARE --CASE WHEN U.[ReportTo]=3 THEN 2166 ELSE U.[ReportTo]
      SELECT 
		 R.[RequestId] AS [RequestId]
		,U.[EmployeeName]
		,LS.[Status]+' with '+UD.EmployeeFirstName+' '+UD.EmployeeLastName AS [Status]
        ,D.[Date] AS [FromDate]
        ,M.[Date] AS [TillDate]
        ,R.[TotalNoOfDays] AS [NoOfDays]
        ,R.[Reason] AS [Reason]
      FROM
         [dbo].[RequestLnsa] R WITH (NOLOCK)
         INNER JOIN [dbo].[DateMaster] D WITH (NOLOCK) ON D.[DateId] = R.[FromDateId]
         INNER JOIN [dbo].[DateMaster] M WITH (NOLOCK) ON M.[DateId] = R.[TillDateId]
         INNER JOIN [dbo].[vwActiveUsers] U WITH (NOLOCK) ON U.[UserId] = R.[CreatedBy]
		 INNER JOIN [dbo].[LNSAStatusMaster] LS WITH (NOLOCK) ON R.StatusId = LS.StatusId
		 LEFT JOIN [dbo].[vwActiveUsers] UD WITH (NOLOCK) ON R.ApproverId = UD.UserId
      WHERE R.ApproverId = @LoginUserId 
      ORDER BY D.[Date] DESC
END

GO
/****** Object:  StoredProcedure [dbo].[spFetchLastNApprovedLnsa]    Script Date: 15-10-2018 19:21:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spFetchLastNApprovedLnsa]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spFetchLastNApprovedLnsa] AS' 
END
GO
/***
   Created Date      :     2017-05-09
   Created By        :     Chandra Prakash Tiwari
   Purpose           :     To get last n approved LNSA request by reporting manager Id 
   Test Cases        :
   --------------------------------------------------------------------------
   
   --- Test Case 1
         EXEC [dbo].[spFetchLastNApprovedLnsa]
         @UserId = 24
         ,@NoOfRecords = 25
***/
ALTER PROCEDURE [dbo].[spFetchLastNApprovedLnsa] 
     @UserId [int]
    ,@NoOfRecords [int]
AS
BEGIN
SET NOCOUNT ON;
      SELECT TOP (@NoOfRecords)
		  R.[RequestId] AS [RequestId], U.[EmployeeName], D.[Date] AS [FromDate]
         ,M.[Date] AS [TillDate],R.[TotalNoOfDays] AS [NoOfDays],R.[Reason] AS [Reason]
		 ,CASE WHEN LS.StatusCode = 'PA' THEN  LS.[Status]+' with '+UD.EmployeeFirstName+' '+UD.EmployeeLastName 
		  ELSE LS.[Status]+' by '+VW.EmployeeFirstName+' '+VW.EmployeeLastName END AS [Status]
		 ,CASE WHEN R.ApproverId IS NULL THEN LS.StatusCode ELSE 'PV' END AS [StatusCode]
      FROM
         [dbo].[RequestLnsa] R WITH (NOLOCK)
            INNER JOIN [dbo].[DateMaster] D WITH (NOLOCK) ON D.[DateId] = R.[FromDateId]
            INNER JOIN [dbo].[DateMaster] M WITH (NOLOCK) ON M.[DateId] = R.[TillDateId]
            INNER JOIN [dbo].[vwActiveUsers] U WITH (NOLOCK) ON U.[UserId] = R.[CreatedBy]
			INNER JOIN [dbo].[LNSAStatusMaster] LS WITH (NOLOCK) ON R.StatusId = LS.StatusId
		    LEFT JOIN [dbo].[vwActiveUsers] UD WITH (NOLOCK) ON R.ApproverId = UD.UserId
		    LEFT JOIN [dbo].[vwActiveUsers] VW WITH (NOLOCK) ON R.[LastModifiedBy] = VW.UserId
			INNER JOIN [dbo].[RequestLnsaHistory] RH ON R.RequestId = RH.RequestId 
			INNER JOIN [dbo].[LNSAStatusMaster] LM ON RH.StatusId = LM.StatusId
      WHERE RH.[CreatedBy] = @UserId AND R.CreatedBy !=@UserId
         --RH.[CreatedBy] = @UserId AND R.[Status] = 1
      ORDER BY D.[Date] DESC
END




GO
/****** Object:  StoredProcedure [dbo].[spGetApproverRemarks]    Script Date: 15-10-2018 19:21:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetApproverRemarks]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGetApproverRemarks] AS' 
END
GO
/***
   Created Date      :     2016-03-06
   Created By        :     Narender Singh
   Purpose           :     This stored procedure Returns remarks by Approvers
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   --- Test Case 1
      EXEC [dbo].[spGetApproverRemarks] 
         @RequestId = 4404
        ,@Type = 'LEAVE'
        
   --  Test Case 2
      EXEC [dbo].[spGetApproverRemarks] 
         @RequestId = 12
        ,@Type = 'WFH'
        
   --  Test Case 3
      EXEC [dbo].[spGetApproverRemarks] 
         @RequestId = 1
        ,@Type = 'COFF'
        
   --  Test Case 4
      EXEC [dbo].[spGetApproverRemarks] 
         @RequestId = 1
        ,@Type = 'DATACHANGE'

	  EXEC [dbo].[spGetApproverRemarks] 
         @RequestId = 613
        ,@Type = 'LNSAREQUEST'
       
***/
ALTER PROCEDURE [dbo].[spGetApproverRemarks]
(
   @RequestId [bigint]
  ,@Type [varchar] (20)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @AdminId int = 1

   IF(@Type = 'WFH' OR @Type = 'LEAVE')
	BEGIN
		SELECT 
		CASE
			WHEN LTRIM(RTRIM(LH.[ApproverRemarks])) = '' THEN CONVERT (VARCHAR(19),LH.[CreatedDate]) + ' | ' + UD.[FirstName] + ' ' + UD.[LastName] + ' : Approved'
			WHEN (LH.[ApproverId] = @AdminId AND LH.[CreatedBy] = @AdminId) THEN CONVERT (VARCHAR(19),LH.[CreatedDate],106)+' '+FORMAT(LH.CreatedDate,'hh:mm tt')  + ' | ' + LH.[ApproverRemarks]
			ELSE CONVERT (VARCHAR(19),LH.[CreatedDate],106) +' '+FORMAT(LH.CreatedDate,'hh:mm tt') + ' | ' + UD.[FirstName] + ' ' + UD.[LastName] + ' : ' + LH.[ApproverRemarks] 	
			END																																																		AS [Result]
		FROM [dbo].[LeaveHistory] LH
		INNER JOIN [dbo].[UserDetail] UD ON UD.[UserId] = LH.[CreatedBy]
		WHERE LH.[LeaveRequestApplicationId] =@RequestId 
		ORDER BY LH.[CreatedDate] DESC

	END
	ELSE IF(@Type = 'LGT' OR @Type = 'LEGITIMATE')
	BEGIN
		SELECT 
		CASE
			WHEN LTRIM(RTRIM(LH.[Remarks])) = '' THEN CONVERT (VARCHAR(19),LH.[CreatedDate]) + ' | ' + UD.[FirstName] + ' ' + UD.[LastName] + ' : Approved'
			WHEN ( LH.[CreatedBy] = @AdminId) THEN CONVERT (VARCHAR(19),LH.[CreatedDate],106) +' ' + FORMAT(LH.CreatedDate,'hh:mm tt')  + ' | ' + LH.[Remarks]
			ELSE CONVERT (VARCHAR(19),LH.[CreatedDate],106) +' ' + FORMAT(LH.CreatedDate,'hh:mm tt') + ' | ' + UD.[FirstName] + ' ' + UD.[LastName] + ' : ' + LH.[Remarks] 	
			END																																																		AS [Result]
			FROM [dbo].[LegitimateLeaveRequestHistory] LH
			INNER JOIN [dbo].[UserDetail] UD ON UD.[UserId] = LH.[CreatedBy]
			WHERE LH.[LegitimateLeaveRequestId] =@RequestId 
			ORDER BY LH.[CreatedDate] DESC

	END
	
	ELSE IF(@Type = 'COFF')
	BEGIN
		SELECT
		CASE
			WHEN LTRIM(RTRIM(RC.[ApproverRemarks])) = '' THEN CONVERT (VARCHAR(19),RC.[CreatedDate]) + ' : ' + UD.[FirstName] + ' ' + UD.[LastName] + ' : Approved'
			ELSE CONVERT (VARCHAR(19),RC.[CreatedDate]) + ' : ' + UD.[FirstName] + ' ' + UD.[LastName] + ' : ' + RC.[ApproverRemarks]			
		END																																																			AS [Result]
		FROM
			[dbo].[RequestCompOffHistory] RC
			INNER JOIN  [dbo].[UserDetail] UD ON UD.[UserId] = RC.[CreatedBy]
		WHERE RC.[RequestId] = @RequestId
		ORDER BY RC.[CreatedDate] DESC							
	END
	
	ELSE IF(@Type = 'DATACHANGE')
	BEGIN
		SELECT
		CASE
			WHEN LTRIM(RTRIM(DC.[ApproverRemarks])) = '' THEN CONVERT (VARCHAR(19), DC.[CreatedDate]) + ' : ' + UD.[FirstName] + ' ' + UD.[LastName] + ' : Approved'
			ELSE CONVERT (VARCHAR(19),DC.[CreatedDate]) + ' : ' + UD.[FirstName] + ' ' + UD.[LastName] + ' : ' + DC.[ApproverRemarks]
		END																																																			AS	[Result]
		FROM [dbo].[AttendanceDataChangeRequestHistory] DC 
			INNER JOIN [dbo].[UserDetail] UD ON UD.[UserId] = DC.[ApproverId]
		WHERE DC.[RequestId] = @RequestId
		ORDER BY DC.[CreatedDate] DESC

	END
	--for outing request approver remarks
	ELSE  IF(@Type = 'OR' OR @Type = 'OUTING')
	BEGIN
		SELECT 
		CASE
			WHEN LTRIM(RTRIM(H.[Remarks])) = '' THEN CONVERT (VARCHAR(19),H.[CreatedDate],106)+ ' ' + FORMAT(H.CreatedDate,'hh:mm tt') + ' | ' + UD.[FirstName] + ' ' + UD.[LastName] + ' : Approved'
			WHEN (H.[CreatedById] =  @AdminId AND R.[CreatedById] = @AdminId) THEN CONVERT (VARCHAR(19),H.[CreatedDate],106)+ ' ' + FORMAT(H.CreatedDate,'hh:mm tt') + ' | ' + H.[Remarks]
			ELSE CONVERT (VARCHAR(19),H.[CreatedDate],106)+ ' ' + FORMAT(H.CreatedDate,'hh:mm tt') + ' | ' + UD.[FirstName] + ' ' + UD.[LastName] + ' : ' + H.[Remarks] 	
			END	 AS [Result]																																																	
		FROM [dbo].[OutingRequestHistory] H
		INNER JOIN [dbo].[OutingRequest] R ON R.OutingRequestId=H.OutingRequestId
		INNER JOIN [dbo].[UserDetail] UD ON UD.[UserId] = H.[CreatedById]
		WHERE H.[OutingRequestId] = @RequestId
		ORDER BY H.[CreatedDate] DESC
	END
    ELSE  IF(@Type = 'LNSA' OR @Type = 'LNSASHIFT')
	BEGIN
		SELECT 
		CASE
			WHEN LTRIM(RTRIM(H.[Remarks])) = '' AND H.StatusId=4 THEN CONVERT (VARCHAR(19),H.[CreatedDate],106)+ ' ' + FORMAT(H.CreatedDate,'hh:mm tt') + ' | ' + UD.[FirstName] + ' ' + UD.[LastName] + ' : Approved'
			WHEN LTRIM(RTRIM(H.[Remarks])) = '' AND ( H.StatusId=6 OR H.StatusId=7) THEN CONVERT (VARCHAR(19),H.[CreatedDate],106)+ ' ' + FORMAT(H.CreatedDate,'hh:mm tt') + ' | ' + UD.[FirstName] + ' ' + UD.[LastName] + ' : Rejected'
			WHEN (H.[CreatedBy] =  @AdminId AND R.[CreatedBy] = @AdminId) THEN CONVERT (VARCHAR(19),H.[CreatedDate],106)+ ' ' + FORMAT(H.CreatedDate,'hh:mm tt') + ' | ' + H.[Remarks]
			ELSE CONVERT (VARCHAR(19),H.[CreatedDate],106)+ ' ' + FORMAT(H.CreatedDate,'hh:mm tt') + ' | ' + UD.[FirstName] + ' ' + UD.[LastName] + ' : ' + H.[Remarks] 	
			END	 AS [Result]																																																	
		FROM [dbo].[TempUserShiftHistory] H
		INNER JOIN [dbo].[TempUserShift] R ON R.TempUserShiftId=H.TempUserShiftId
		INNER JOIN [dbo].[UserDetail] UD ON UD.[UserId] = H.[CreatedBy]
		WHERE H.[TempUserShiftId] = @RequestId
		ORDER BY H.[CreatedDate] DESC, H.TempUserShiftHistoryId DESC
	END
	
	ELSE  IF(@Type = 'LNSAREQUEST')
	BEGIN
		SELECT 
		CASE
			WHEN LTRIM(RTRIM(H.[Remarks])) = '' AND H.StatusId= 3 THEN CONVERT (VARCHAR(19),H.[CreatedDate],106)+ ' ' + FORMAT(H.CreatedDate,'hh:mm tt') + ' | ' + UD.[FirstName] + ' ' + UD.[LastName] + ' : Approved'
			WHEN LTRIM(RTRIM(H.[Remarks])) = '' AND ( H.StatusId=6 ) THEN CONVERT (VARCHAR(19),H.[CreatedDate],106)+ ' ' + FORMAT(H.CreatedDate,'hh:mm tt') + ' | ' + UD.[FirstName] + ' ' + UD.[LastName] + ' : Rejected'
			WHEN (H.[CreatedBy] =  @AdminId AND R.[CreatedBy] = @AdminId) THEN CONVERT (VARCHAR(19),H.[CreatedDate],106)+ ' ' + FORMAT(H.CreatedDate,'hh:mm tt') + ' | ' + H.[Remarks]
			ELSE CONVERT (VARCHAR(19),H.[CreatedDate],106)+ ' ' + FORMAT(H.CreatedDate,'hh:mm tt') + ' | ' + UD.[FirstName] + ' ' + UD.[LastName] + ' : ' + H.[Remarks] 	
			END	 AS [Result]																																																	
		FROM [dbo].[RequestLnsaHistory] H
		INNER JOIN [dbo].[RequestLnsa] R ON R.RequestId=H.RequestId
		INNER JOIN [dbo].[UserDetail] UD ON UD.[UserId] = H.[CreatedBy]
		WHERE H.[RequestId] = @RequestId
		ORDER BY H.[CreatedDate] DESC, H.RequestLnsaHistoryId DESC
	END
	ELSE
	 SELECT 'ERROR'  AS	[Result]
END







GO
/****** Object:  StoredProcedure [dbo].[spInsertLnsaRequest]    Script Date: 15-10-2018 19:21:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spInsertLnsaRequest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spInsertLnsaRequest] AS' 
END
GO
/***
   Created Date      :     2016-07-08
   Created By        :     Shubhra Upadhyay
   Purpose           :     This stored procedure is to insert new lnsa request in DB
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   20-06-2018      Mimansa Agrawal        added query for insertion in DatewiseLnsa
   --------------------------------------------------------------------------
   12 oct 2018     Kanchan kumari         added approverid in RequestLnsa and 
                                          inserted data in RequestLnsaHistoty 
   Test Cases        :
   --------------------------------------------------------------------------
   --- Test Case 1
         BEGIN TRANSACTION
            EXEC [dbo].[spInsertLnsaRequest] 
                   @FromDate = '2016-05-17'
                  ,@TillDate = '2016-05-20'
                  ,@Reason = 'WFH'
                  ,@UserId = 84
         ROLLBACK TRANSACTION
***/
ALTER PROCEDURE [dbo].[spInsertLnsaRequest] 
	@FromDate [datetime]
   ,@TillDate [datetime]
   ,@Reason [varchar](2000)
   ,@UserId [int]
AS
SET NOCOUNT ON
BEGIN TRY
     BEGIN TRANSACTION
		   	DECLARE @ApproverId INT= (SELECT [dbo].[fnGetReportingManagerByUserId](@UserId)),
		    @StatusId INT = (SELECT StatusId FROM LNSAStatusMaster WHERE StatusCode = 'PA');
			      IF(@ApproverId = 0)
				  BEGIN
				      SET @ApproverId = (SELECT [dbo].[fnGetHRIdByUserId](@UserId))
				  END 

            INSERT INTO [dbo].[RequestLnsa]
            ([FromDateId], [TillDateId], [TotalNoOfDays], [Reason], StatusId, [ApproverId], [CreatedBy])
            SELECT D.[DateId], DM.[DateId], DM.[DateId] + 1 - D.[DateId],
			       @Reason, @StatusId, @ApproverId, @UserId
            FROM [dbo].[DateMaster] D WITH (NOLOCK)
            INNER JOIN [dbo].[DateMaster] DM WITH (NOLOCK)
                 ON DM.[Date] = @TillDate       
            WHERE D.[Date] = @FromDate
			
			DECLARE @RequestId BIGINT,@FromDateId BIGINT,@TillDateId BIGINT,
			@StatusIdNew INT = (SELECT StatusId FROM LNSAStatusMaster WHERE StatusCode = 'AD')

			SET @RequestId = SCOPE_IDENTITY()
			------------------insert into RequestLnsaHistory----------
			INSERT INTO RequestLnsaHistory(RequestId, StatusId, Remarks, CreatedBy)
									 VALUES(@RequestId, @StatusIdNew, 'Applied', @UserId)

			-----------------insert into DateWiseLNSA------------
			SELECT @FromDateId = MIN(DM.[DateId]), @TillDateId = MAX(DM.[DateId])
			FROM [dbo].[DateMaster] DM WITH (NOLOCK)
			WHERE DM.[Date] BETWEEN  @FromDate AND  @TillDate
				WHILE (@FromDateId <= @TillDateId)
				BEGIN
					INSERT INTO [dbo].[DateWiseLNSA]([RequestId],[DateId])
						SELECT @RequestId, D.[DateId]
						FROM [dbo].[DateMaster] D WITH (NOLOCK)
						WHERE D.[DateId] = @FromDateId
						AND D.[IsWeekend] = 0
					Set @FromDateId = @FromDateId + 1
				END 
				SELECT CAST(1 AS [bit]) AS [Result]
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
 SELECT CAST(0 AS [bit])  AS [Result]
 IF @@TRANCOUNT>0
 ROLLBACK TRANSACTION;
 DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
      EXEC [spInsertErrorLog]
	         @ModuleName = 'Lnsa'
         ,@Source = 'spInsertLnsaRequest'
         ,@ErrorMessage = @ErrorMessage
         ,@ErrorType = 'SP'
         ,@ReportedByUserId = @UserId
END CATCH






GO
/****** Object:  StoredProcedure [dbo].[spTakeActionOnLnsaRequest]    Script Date: 15-10-2018 19:21:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spTakeActionOnLnsaRequest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spTakeActionOnLnsaRequest] AS' 
END
GO
/***
   Created Date      :     2016-05-17
   Created By        :     Shubhra Upadhyay
   Purpose           :     To take action (approve / reject) on pending LNSA request by reporting manager
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   12 oct 2018       Kanchan kumari        added approval level till rm2 and Insert into RequestLnsaHistory
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   --- Test Case 1
            EXEC [dbo].[spTakeActionOnLnsaRequest] 
                   @RequestId = 5
                  ,@Status = 1
				  ,@Remarks = 'OKAY'
                  ,@UserId = 22
***/
ALTER PROCEDURE [dbo].[spTakeActionOnLnsaRequest] 
    @RequestId [bigint]
   ,@Status [int]
   ,@Remarks [varchar](500)
   ,@LoginUserId [int]
AS
 SET NOCOUNT ON
BEGIN TRY
   BEGIN TRANSACTION
         DECLARE @StatusId INT, @StatusIdNew INT, @UserId INT, @SecondRMId INT, @FirstRMId INT, @HRId INT, @Result INT;
		 SELECT @UserId = CreatedBy FROM [RequestLnsa] WHERE RequestId = @RequestId
		       SET @SecondRMId = (SELECT [dbo].[fnGetSecondReportingManagerByUserId](@UserId))
			   SET @FirstRMId = (SELECT [dbo].[fnGetReportingManagerByUserId](@UserId));
			   SET @HRId = (SELECT [dbo].[fnGetHRIdByUserId](@UserId))
         
		 IF(@Status = -1)
		 BEGIN
				SELECT @StatusId = StatusId FROM LNSAStatusMaster WHERE StatusCode = 'RJ'

				UPDATE [dbo].[RequestLnsa] 
				   SET [ApproverId] = null, [ApproverRemarks] = @Remarks, StatusId = @StatusId
				  ,[Status] = @Status, [LastModifiedBy] = @LoginUserId, [LastModifiedDate] = GETDATE()
				WHERE [RequestId] = @RequestId

				UPDATE  
				   [dbo].[DateWiseLNSA] SET [IsApprovedBySystem] = 0
				WHERE [RequestId] = @RequestId

				INSERT INTO RequestLnsaHistory(RequestId, StatusId, Remarks, CreatedBy)
				       VALUES(@RequestId, @StatusId, @Remarks, @LoginUserId)
				SET @Result = 1 ---successfully rejected
		 END	
		 ELSE IF (@Status=1)
		 BEGIN 
				IF(@LoginUserId = @FirstRMId AND @LoginUserId != @UserId)
				BEGIN
						IF(@SecondRMId = 0)
						SET @SecondRMId = @HRId

						SELECT @StatusId = StatusId FROM LNSAStatusMaster WHERE StatusCode = 'PA'
						SELECT @StatusIdNew = StatusId FROM LNSAStatusMaster WHERE StatusCode = 'AP'

						UPDATE [dbo].[RequestLnsa] 
						   SET [ApproverId] = @SecondRMId, [ApproverRemarks] = @Remarks, StatusId = @StatusId
						  ,[Status] = @Status, [LastModifiedBy] = @LoginUserId, [LastModifiedDate] = GETDATE()
						WHERE [RequestId] = @RequestId

						INSERT INTO RequestLnsaHistory(RequestId, StatusId, Remarks, CreatedBy)
						VALUES(@RequestId, @StatusIdNew, @Remarks,  @LoginUserId)
					  SET @Result = 1 ---successfully approved by rm1
				END
				ELSE IF(@LoginUserId = @SecondRMId OR @LoginUserId = @HRId)
				BEGIN
				        SELECT @StatusId = StatusId FROM LNSAStatusMaster WHERE StatusCode = 'AP'
				        UPDATE [dbo].[RequestLnsa] 
						   SET [ApproverId] = null, [ApproverRemarks] = @Remarks, StatusId = @StatusId
						  ,[Status] = @Status, [LastModifiedBy] = @LoginUserId, [LastModifiedDate] = GETDATE()
						WHERE [RequestId] = @RequestId

						INSERT INTO RequestLnsaHistory(RequestId, StatusId, Remarks, CreatedBy)
						VALUES(@RequestId, @StatusId, @Remarks,  @LoginUserId)
         
						UPDATE M
						SET M.[IsApprovedBySystem] = 1
						FROM [dbo].[DateWiseLNSA] M WITH (NOLOCK)
						INNER JOIN [dbo].[RequestLnsa] R WITH (NOLOCK)
								ON M.[RequestId] = R.[RequestId]
						INNER JOIN [dbo].[LeaveRequestApplication] L WITH (NOLOCK)
								ON R.[CreatedBy]  = L.[UserId] 
								AND L.[StatusId] > 1 -- consider only approved WFH
						INNER JOIN [dbo].[DateWiseLeaveType] D WITH (NOLOCK)
								ON M.[DateId] = D.[DateId] AND D.[LeaveTypeId] = 5 -- for WFH
								AND L.[LeaveRequestApplicationId] = D.[LeaveRequestApplicationId]
						--for attendance
						UPDATE M 
						SET M.[IsApprovedBySystem] = 1
						FROM [dbo].[DateWiseLNSA] M WITH (NOLOCK)
						INNER JOIN [dbo].[RequestLnsa] R WITH (NOLOCK)
								ON M.[RequestId] = R.[RequestId]
						INNER JOIN [dbo].[DateWiseAttendance] A WITH (NOLOCK)
								ON M.[DateId] = A.[DateId] AND R.[CreatedBy] = A.[UserId]
					SET @Result = 1 ---successfully approved by rm2
		       END
		 END

		SELECT CAST(@Result AS [bit]) AS [Result], D.[Date] AS [FromDate]
			,DM.[Date] AS [TillDate]
		FROM [dbo].[RequestLnsa] R
			INNER JOIN [dbo].[DateMaster] D
				ON R.[FromDateId] = D.[DateId]
			INNER JOIN [dbo].[DateMaster] DM
				ON R.[TillDateId] = DM.[DateId]
		WHERE R.[RequestId] = @RequestId

  COMMIT TRANSACTION;
END TRY
BEGIN CATCH
IF(@@TRANCOUNT>0)
ROLLBACK TRANSACTION;

    DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
    EXEC [spInsertErrorLog]
	    @ModuleName = 'Lnsa'
    ,@Source = 'spTakeActionOnLnsaRequest'
    ,@ErrorMessage = @ErrorMessage
    ,@ErrorType = 'SP'
    ,@ReportedByUserId = @UserId         
	 SELECT CAST(0 AS [bit]) AS [Result]
	,NULL  AS [FromDate], NULL  AS [TillDate]	
END CATCH

GO
