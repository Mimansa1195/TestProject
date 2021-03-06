
/****** Object:  StoredProcedure [dbo].[spTakeActionOnAppliedLeave]    Script Date: 21-11-2018 19:31:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spTakeActionOnAppliedLeave]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spTakeActionOnAppliedLeave]
GO
/****** Object:  StoredProcedure [dbo].[spGetUserAppliedLeave]    Script Date: 21-11-2018 19:31:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetUserAppliedLeave]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetUserAppliedLeave]
GO
/****** Object:  StoredProcedure [dbo].[spGetLeaves]    Script Date: 21-11-2018 19:31:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetLeaves]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetLeaves]
GO
/****** Object:  StoredProcedure [dbo].[spGetLeaveBalanceForUser]    Script Date: 21-11-2018 19:31:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetLeaveBalanceForUser]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetLeaveBalanceForUser]
GO
/****** Object:  StoredProcedure [dbo].[spGetAvailableLeaveCombination]    Script Date: 21-11-2018 19:31:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetAvailableLeaveCombination]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetAvailableLeaveCombination]
GO
/****** Object:  StoredProcedure [dbo].[spApplyLeave]    Script Date: 21-11-2018 19:31:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spApplyLeave]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spApplyLeave]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetLeaveBalanceHistoryByFY]    Script Date: 21-11-2018 19:31:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetLeaveBalanceHistoryByFY]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetLeaveBalanceHistoryByFY]
GO
/****** Object:  StoredProcedure [dbo].[Proc_ApplyLegitimateLeave]    Script Date: 21-11-2018 19:31:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_ApplyLegitimateLeave]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_ApplyLegitimateLeave]
GO
/****** Object:  UserDefinedFunction [dbo].[Fn_GetUserForExamLeaves]    Script Date: 21-11-2018 19:31:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fn_GetUserForExamLeaves]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fn_GetUserForExamLeaves]
GO
/****** Object:  UserDefinedFunction [dbo].[Fn_GetUserForExamLeaves]    Script Date: 21-11-2018 19:31:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fn_GetUserForExamLeaves]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author	  : Kanchan Kumari
-- Create date: 21-11-2018
-- Description:	To get leaves for technical trainee
-- Usage	  : SELECT * FROM [dbo].[Fn_GetUserForExamLeaves](2432,10)
-- =============================================
CREATE FUNCTION [dbo].[Fn_GetUserForExamLeaves]
(
 @UserId INT,
 @NoOfWorkingDays INT
)
RETURNS @UserLeaves TABLE (UserId int,LeaveTypeId int,LeaveCombination varchar(20),IsSpecial bit)
AS
BEGIN
    INSERT INTO @UserLeaves(UserId, LeaveTypeId, LeaveCombination, IsSpecial)
	SELECT UserId,(select TypeId FROM LeaveTypeMaster where ShortName = ''EL'') AS LeaveTypeId, Convert (varchar(4),(@NoOfWorkingDays ),0 ) + '' EL'',0
    FROM vwActiveUsers WHERE [Role] = ''Trainee'' AND DesignationGroup = ''Technical'' AND IsIntern = 1 AND UserId = @UserId
RETURN 
END

' 
END

GO
/****** Object:  StoredProcedure [dbo].[Proc_ApplyLegitimateLeave]    Script Date: 21-11-2018 19:31:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_ApplyLegitimateLeave]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_ApplyLegitimateLeave] AS' 
END
GO
/***
   Created Date      :     2018-04-19
   Created By        :     kanchan kumari
   Purpose           :     This stored procedure Apply Legitimate Leave
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
 
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
         EXEC  [dbo].[Proc_ApplyLegitimateLeave]
             @EmployeeId = 89
            ,@LoginUserId = 89
            ,@FromDateIn = '2018-04-26'
            ,@Reason = 'new proc testing'
            ,@LeaveCombination= '1 COFF'
			,@LeaveId=4437
			,@IsValid=1
			select * from LeaveRequestApplication WHERE Createdby=1  and IsActive=1
***/
ALTER PROCEDURE [dbo].[Proc_ApplyLegitimateLeave]
   (
       @EmployeeId [int]
      ,@LoginUserId [int]
      ,@FromDateIn [date]
      ,@LeaveCombination [varchar](100)
	  ,@Reason [varchar](500)
	  ,@LeaveId [int]
	  ,@IsValid [bit]
   )
   AS
      SET NOCOUNT ON;  
      SET FMTONLY OFF;
     
   BEGIN TRY
     IF OBJECT_ID('tempdb..#TempCoffAvailed') IS NOT NULL
      DROP TABLE #TempCoffAvailed
	  
	  IF OBJECT_ID('tempdb..#TempLeaveCombination') IS NOT NULL
      DROP TABLE #TempLeaveCombination

	  DECLARE @PreviousMonLastDate DATE,@LapseDateToBeAvailed DATE, @FromDateId BIGINT, @FromDate DATE 
	   
	IF( @LeaveId NOT IN (SELECT LeaveRequestApplicationId FROM LeaveRequestApplication WITH (NOLOCK) WHERE UserId=@EmployeeId AND CreatedBy=1 AND IsActive=1 AND LeaveCombination='1 LWP')) 
	BEGIN
	    SELECT 8 AS [Result]--appied lwp change request doesn't exist
	END
	ELSE
	BEGIN
      SET @FromDateId=( SELECT FromDateId FROM  [dbo].[LeaveRequestApplication] WITH (NOLOCK) WHERE [LeaveRequestApplicationId]=@LeaveId)
	  SET @FromDate=(SELECT [Date] FROM DateMaster WHERE DateId=@FromDateId)

	  IF(@FromDateIn!=@FromDate)
	  BEGIN
	    SELECT 7 AS [Result]--applied date is invalid
	  END
	  ELSE
	  BEGIN
		  SET @PreviousMonLastDate =(SELECT DATEADD(DAY,-1,DATEADD(DAY,1-DAY(@FromDate),@FromDate)) )
	  
		  IF(@LeaveCombination LIKE '%COFF%' AND (SELECT count(RequestId) From RequestCompOff where IsLapsed=0 AND StatusId>2 AND IsAvailed=0 AND CreatedBy=@EmployeeId AND LapseDate>@PreviousMonLastDate)=0)
	  BEGIN
	     SELECT 6 AS [Result]--Applied COFF leave is either lapsed or availed
	  END
	  ELSE
	  BEGIN
		IF exists(select 1 from LegitimateLeaveRequest where LeaveRequestApplicationId=@LeaveId and StatusId!=8 and StatusId !=6 and StatusId !=7)
		BEGIN
			SELECT 1 AS [Result]
		END
         
	  ELSE
	  BEGIN
			CREATE TABLE #TempLeaveCombination(
			[LeaveCombination] varchar(50)
			)
			INSERT INTO #TempLeaveCombination
			EXEC spGetAvailableLeaveCombination @NoOfWorkingDays =1, @UserId = @EmployeeId, @LeaveApplicationId = 0, @TotalDays = 0
			IF((SELECT COUNT(*) FROM #TempLeaveCombination) > 0)
			BEGIN
				IF((SELECT COUNT(*) from #TempLeaveCombination WHERE [LeaveCombination] = @LeaveCombination) > 0)
				BEGIN
					BEGIN TRANSACTION
                     
						
                            DECLARE @ApproverId int ,@StatusId int = 1
								,@ReportingManagerId int = (SELECT [dbo].[fnGetReportingManagerByUserId](@EmployeeId))
								,@HRId int = (SELECT [dbo].[fnGetHRIdByUserId](@EmployeeId));
								SET @ApproverId = @ReportingManagerId
								
						IF(@ReportingManagerId = 0 OR @ReportingManagerId = 1)
						BEGIN
							SET @ApproverId = @HRId;
							SET @StatusId = (SELECT [StatusId] FROM [dbo].[LegitimateLeaveStatus] WHERE [StatusCode] = 'PV')
						END
						ELSE
						BEGIN
							SET @StatusId=(SELECT [StatusId] FROM [dbo].[LegitimateLeaveStatus] WHERE [StatusCode] = 'PA')
						END

							IF(@IsValid=1)
							BEGIN
---------------------------------------Insert into LegitimateLeaveRequest starts---------------------------------------

									INSERT INTO LegitimateLeaveRequest
									([LeaveRequestApplicationId], [UserId], [DateId], [Reason], [StatusId],[LeaveCombination],[NextApproverId],
									[Remarks], [CreatedBy])
									VALUES(@LeaveId, @EmployeeId, @FromDateId, @Reason, @StatusId, @LeaveCombination, @ApproverId
									,'Applied', @LoginUserId)
	      
---------------------------------------Insert into LegitimateLeaveRequest ends---------------------------------------
                       
---------------------------------------Insert into LegitimateLeaveRequestHistory starts---------------------------------------
									DECLARE @LegitimateLeaveRequestId [bigint]
									SET @LegitimateLeaveRequestId = SCOPE_IDENTITY() 
											
									INSERT INTO LegitimateLeaveRequestHistory   
									([LegitimateLeaveRequestId], [DateId], [Reason], [Remarks], [CreatedBy])
									VALUES(@LegitimateLeaveRequestId, @FromDateId, @Reason, 'Applied', @LoginUserId)
	                      
---------------------------------------Insert into LegitimateLeaveRequestHistory ends---------------------------------------

---------------------------------------Update RequestCompOff starts---------------------------------------------------
				    IF(@LeaveCombination LIKE '%COFF%')
                    BEGIN
					CREATE TABLE #TempCoffAvailed(
					RequestId INT,
					LapseDate DATE
					)
                   DECLARE @AvailedRequestId INT
                   INSERT INTO #TempCoffAvailed (RequestId,LapseDate) 
				   SELECT TOP 1 RequestId,LapseDate FROM RequestCompOff
		                     WHERE IsLapsed=0 AND StatusId>2 AND IsAvailed=0 AND CreatedBy=@EmployeeId AND LapseDate>@PreviousMonLastDate ORDER BY LapseDate ASC,RequestId ASC

							SET @LapseDateToBeAvailed=(SELECT LapseDate FROM #TempCoffAvailed)
							SET @AvailedRequestId=(SELECT RequestId FROM #TempCoffAvailed)
							
							INSERT INTO [dbo].[RequestCompOffDetail](RequestId,LegitimateLeaveRequestId,CreatedById)
									VALUES(@AvailedRequestId,@LegitimateLeaveRequestId,@LoginUserId)

							print @LapseDateToBeAvailed;
							print @AvailedRequestId;
		               UPDATE RequestCompOff SET IsAvailed=1 WHERE RequestId=@AvailedRequestId
                         END
---------------------------------------Update RequestCompOff ends---------------------------------------------------
---------------------------------------Insert into [RequestCompOffDetail] starts---------------------------------------
                    
---------------------------------------Insert into [RequestCompOffDetail] ends---------------------------------------
---------------------------------------Insert into LeaveBalanceHistory/update LeaveBalance----------------------------------
						DECLARE @Id VARCHAR(10),@Msg VARCHAR(20),@LTypeId INT
				        SET @Id=(SELECT [Character] FROM [dbo].[fnSplitWord](@LeaveCombination, ' ') where Id=2)
                        SELECT @LTypeId= [TypeId] FROM [LeaveTypeMaster] WHERE ShortName=@Id
											 
								INSERT INTO [dbo].[LeaveBalanceHistory]([RecordId], [Count], [CreatedBy])
											SELECT A.[RecordId], A.[Count], @EmployeeId
											FROM LeaveBalance A INNER JOIN LeaveTypeMaster B
											ON B.TypeId=A.LeaveTypeId 
											INNER JOIN LegitimateLeaveRequest LR ON LR.UserId=A.UserId 
												WHERE  LR.[UserId] =@EmployeeId AND LR.LegitimateLeaveRequestId=@LegitimateLeaveRequestId AND B.ShortName=@Id 

																		--update LeaveBalance Table(not for LWP)

											
                        							UPDATE A
														SET A.[Count] =(A.[Count]-1)
														,[LastModifiedDate] = GETDATE()
														,[LastModifiedBy] = @EmployeeId
														FROM [dbo].[LeaveBalance] A WITH (NOLOCK)
														INNER JOIN LeaveTypeMaster B ON B.TypeId=A.LeaveTypeId
														WHERE B.ShortName=@Id AND A.UserId=@EmployeeId

												
                  
    -----------------------------------------Insert into LeaveBalanceHistory/update LeaveBalance END-----------------------------

										SELECT 4 AS [Result] --success
								END
								ELSE
									BEGIN
									SELECT 5 AS [Result]--can 't apply befor or on 24th of previous month
								END
						COMMIT;
                        END
						ELSE
						BEGIN
							--SET @Status = 3 --combination supplied is invalid
							SELECT 3 AS [Result]
						END
                END
				ELSE
				BEGIN
					--SET @Status = 2 --no combination present
					SELECT 2 AS [Result]
				END
            END
		END
      END
   END
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0
    BEGIN
    ROLLBACK TRANSACTION;
	END
    DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
    EXEC [spInsertErrorLog]
	    @ModuleName = 'LeaveManagement'
    ,@Source = 'Proc_ApplyLegitimateLeave'
    ,@ErrorMessage = @ErrorMessage
    ,@ErrorType = 'SP'
    ,@ReportedByUserId = @EmployeeId        
	SELECT 0 AS [Result]
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetLeaveBalanceHistoryByFY]    Script Date: 21-11-2018 19:31:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetLeaveBalanceHistoryByFY]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetLeaveBalanceHistoryByFY] AS' 
END
GO
/***
   Created Date      :     2018-07-04
   Created By        :     Mimansa Agrawal
   Purpose           :     This stored procedure fetches leave details for dashboard
   Change History    
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   31 oct 2018       Kanchan Kumari       fetch data for leavetype ML and PL(M) and EL
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   --- Test Case 1
  EXEC Proc_GetLeaveBalanceHistoryByFY 
'01-04-2018'
,'ML'
,2251
***/
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
	 -- ,LR.[Reason]
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
                  H.[LeaveRequestApplicationId]    AS [LeaveRequestApplicationId]
                 ,MAX(H.[CreatedDate])           AS [LastUpdatedTime]
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
         LR.[UserId] = @UserId   AND (LR.StatusId=3 OR LR.StatusId=4 OR LR.StatusId=5 OR LR.StatusId=6)
		   AND LT.[ShortName] = 'WFH' AND DM1.[Date] BETWEEN @StartDate AND @EndDate
   ORDER BY LR.[CreatedDate] DESC
END
ELSE IF (@LeaveType='LNSA')
BEGIN
 SELECT DISTINCT
         R.[CreatedDate]                                                                                  AS [ApplyDate]
	   , D.[Date]     AS [FromDate]
        ,M.[Date]                                                                                         AS [TillDate]
        ,CAST(COUNT (DW.[IsApprovedBySystem]) AS float)                                                   AS [LeaveCount]
       -- ,R.[Reason]                                                                                       AS [Reason]
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
ELSE IF(@LeaveType = 'ML' OR @LeaveType = 'PL(M)' OR @LeaveType = 'EL')
BEGIN
       SELECT
       LR.[CreatedDate]   AS [ApplyDate]
	  ,DM1.[Date]         AS [FromDate]
	  ,DM2.[Date]         AS [TillDate]
	  ,LT.[ShortName]     AS [LeaveInfo]
	  ,LS.[Status]        AS [Status]
	  ,LR.ApproverRemarks AS [Remarks]
	  ,LR.[CreatedBy] AS [CreatedBy]
	  ,LR.[NoOfWorkingDays]  AS [LeaveCount]                                                                                          
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
         WHERE 
         LR.[UserId] = @UserId   AND LR.StatusId NOT IN(0,-1)
		   AND LT.[ShortName] = @LeaveType AND DM1.[Date] BETWEEN @StartDate AND @EndDate
   ORDER BY LR.[CreatedDate] DESC
END
ELSE 
   BEGIN
    SELECT DISTINCT
		 LR.[CreatedDate]																									AS [ApplyDate]
        ,DM1.[Date]																											AS [FromDate]
		,DM2.[Date]	                                                                                                        AS [TillDate]
		--,LR.[Reason]																										
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
      AND (LR.[StatusId]>=1)
      AND DM1.[Date] BETWEEN @StartDate AND  @EndDate
   ORDER BY  LR.[CreatedDate] DESC, DM1.[Date] DESC 
END
COMMIT TRANSACTION
END




GO
/****** Object:  StoredProcedure [dbo].[spApplyLeave]    Script Date: 21-11-2018 19:31:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spApplyLeave]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spApplyLeave] AS' 
END
GO
/***
   Created Date      :     2017-01-12
   Created By        :     Shubhra Upadhyay
   Purpose           :     This stored procedure Apply New Leave
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   
   --------------------------------------------------------------------------

   Test Cases        :
   --------------------------------------------------------------------------
   
   --- Test Case 1
       DECLARE @Result [INT]
         EXEC  [dbo].[spApplyLeave]
             @EmployeeId = 2432
            ,@LoginUserId = 2432
            ,@FromDate = '2019-01-09'
            ,@TillDate =  '2019-01-10'
            ,@Reason = 'testing'
            ,@LeaveCombination= '1 EL'
            ,@PrimaryContactNo = '223344244'
            ,@AlternateContactNo = '2233443322'
            ,@IsAvailableOnMobile = 0
            ,@IsAvailableOnEmail = 0
            ,@IsFirstDayHalfDay = 0
            ,@IsLastDayHalfDay = 0
			,@Success=@Result output
			SELECT @Result AS [RESULT]
select * from errorlog order by 1 desc

***/
 ALTER PROCEDURE [dbo].[spApplyLeave]
   (
       @EmployeeId [int]
      ,@LoginUserId [int]
      ,@FromDate [date]
      ,@TillDate [date]
      ,@Reason [varchar](500)
      ,@LeaveCombination [varchar](100)
      ,@PrimaryContactNo [varchar](15)
      ,@AlternateContactNo [varchar](15)
      ,@IsAvailableOnMobile [bit]
      ,@IsAvailableOnEmail [bit]
      ,@IsFirstDayHalfDay [bit]
      ,@IsLastDayHalfDay [bit]
      ,@Success [tinyint] output
      
      --@FromDateId bigint, @TillDateId bigint, @LeaveTypeId int, @StatusId int, @LwpId int, @LoopCount float ,@TotalCount float, @Date date
   )
   AS
BEGIN TRY
      SET NOCOUNT ON;  
      SET FMTONLY OFF;
	 IF OBJECT_ID('tempdb..#TempCoffAvailed') IS NOT NULL
     DROP TABLE #TempCoffAvailed 

	  IF OBJECT_ID('tempdb..#TempLeaveComb') IS NOT NULL
      DROP TABLE #TempLeaveComb
	  
	  CREATE TABLE #TempLeaveComb(
                            [Id] int IDENTITY(1, 1)
                           ,[LeaveCount] float NOT NULL
                           ,[LeaveType] varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL
						   ,[LeaveTypeId] INT 
                        )

	                SELECT * INTO #Combination FROM [dbo].[fnSplitWord](@LeaveCombination, '+')

	                DECLARE @Temp int = 1, @CoffCount INT
				
                    WHILE(@Temp <= (SELECT COUNT(*) FROM #Combination))
                    BEGIN
                        INSERT INTO #TempLeaveComb([LeaveCount], [LeaveType])
                        SELECT (SELECT [Character] FROM [dbo].[fnSplitWord](C.[Character], ' ') WHERE [Id] = 1)
                                ,(SELECT [Character] FROM [dbo].[fnSplitWord](C.[Character], ' ') WHERE [Id] = 2)
                        FROM #Combination C 
                        WHERE C.[Id] = @Temp
						        --set leaveTypeId
                        UPDATE T
                        SET T.[LeaveTypeId] = M.[TypeId]
                        FROM #TempLeaveComb T
                        INNER JOIN [dbo].[LeaveTypeMaster] M WITH (NOLOCK)
                            ON T.[LeaveType] = M.[ShortName]

						SET @Temp = @Temp+1
					END
	    SELECT @CoffCount = [LeaveCount] FROM #TempLeaveComb WHERE LeaveTypeId = 4 -- coff count to be applied
			
	 DECLARE @PreviousMonthLastDate date = (SELECT DATEADD(DAY, -1, DATEADD(DAY, 1 - DAY(@FromDate ), @FromDate ))) 

	 IF(@LeaveCombination LIKE '%COFF%' AND (SELECT count(RequestId) From RequestCompOff where IsLapsed=0 AND StatusId>2 
	                   AND IsAvailed=0 AND CreatedBy=@EmployeeId AND LapseDate>@PreviousMonthLastDate) < @CoffCount)
	  BEGIN
		SET @Success=6--no valid compoff
	  END
	  ELSE
	  BEGIN
	      
    --DECLARE @LeaveCombo varchar(50) = '1CL + 1LWP';
         --split leave combination and     
         --DROP TABLE #TempDays
         CREATE TABLE #TempDays(
             [Status] varchar(5)
            ,[TotalDays] float
            ,[WorkingDays] float 
         )
         --DECLARE @FromDate [date] = '2016-04-13', @TillDate [date] = '2016-04-14', @EmployeeId [int] = 84; --to be deleted
         INSERT INTO #TempDays
         EXEC spGetTotalWorkingDays @Fromdate = @FromDate, @ToDate = @TillDate, @UserId = @EmployeeId, @LeaveApplicationId = 0
         --SELECT * FROM #TempDays
      
         IF((SELECT [Status] FROM #TempDays) = 'NA')
         BEGIN
            --SET @Status =  1 --date collision
            SET @Success=1
         END
         ELSE
         BEGIN
            --DECLARE @IsFirstDayHalfDay [bit] = 0, @IsLastDayHalfDay [bit] = 0, @EmployeeId [int] = 84; --to be deleted
            DECLARE @NoOfWorkingDays [float] = (SELECT [WorkingDays] FROM #TempDays)
                   ,@NoOfTotalDays [float] = (SELECT [TotalDays] FROM #TempDays)
                 
            IF(@IsFirstDayHalfDay = 1)
            BEGIN
               SET @NoOfWorkingDays = @NoOfWorkingDays - 0.5
            END
            IF(@IsLastDayHalfDay = 1)
            BEGIN
               SET @NoOfWorkingDays = @NoOfWorkingDays - 0.5
            END
         
            CREATE TABLE #TempLeaveCombination(
             [LeaveCombination] varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL
            )
            INSERT INTO #TempLeaveCombination
            EXEC spGetAvailableLeaveCombination @NoOfWorkingDays = @NoOfWorkingDays, @UserId = @EmployeeId, @LeaveApplicationId = 0, @TotalDays = @NoOfTotalDays
            --SELECT * FROM #TempLeaveCombination
            --DROP TABLE #TempLeaveCombination
            IF((SELECT COUNT(*) FROM #TempLeaveCombination) > 0)
            BEGIN
               --DECLARE @LeaveCombination varchar(50) = '1 COFF + 1 LWP' --to be deleted
               IF((SELECT COUNT(*) from #TempLeaveCombination WHERE [LeaveCombination] = @LeaveCombination) > 0)
               BEGIN
               --success logic goes here
     BEGIN TRANSACTION
                     
                     DECLARE @FromDateId Bigint ,@TillDateId bigint;
                     SELECT 
                         @FromDateId = MIN(DM.[DateId])
                        ,@TillDateId = MAX(DM.[DateId])
                     FROM 
                        [dbo].[DateMaster] DM WITH (NOLOCK)
                     WHERE 
                        DM.[Date] BETWEEN  @FromDate	AND  @TillDate

---------------------------------------Insert into LeaveRequestApplication starts---------------------------------------
                        
                        DECLARE @ApproverId int
                              ,@StatusId int = 1
                              ,@ReportingManagerId int = (SELECT [dbo].[fnGetReportingManagerByUserId](@EmployeeId))
                              ,@HRId int = (SELECT [dbo].[fnGetHRIdByUserId](@EmployeeId));

                        SET @ApproverId = @ReportingManagerId
                        IF(@ReportingManagerId = 0 OR @ReportingManagerId = @HRId)
                        BEGIN
                           SET @ApproverId = @HRId;
                           SET @StatusId = (SELECT [StatusId] FROM [dbo].[LeaveStatusMaster] WHERE [StatusCode] = 'PV')
                        END
                        INSERT INTO [dbo].[LeaveRequestApplication] 
                        ([UserId],[FromDateId],[TillDateId],[NoOfTotalDays],[NoOfWorkingDays],[Reason],[PrimaryContactNo],
						 [IsAvailableOnMobile],[IsAvailableOnEmail],[StatusId],[ApproverId],[CreatedBy],[AlternativeContactNo],[LeaveCombination])
                        SELECT @EmployeeId,@FromDateId, @TillDateId, @NoOfTotalDays,@NoOfWorkingDays,@Reason,@PrimaryContactNo
                           ,@IsAvailableOnMobile,@IsAvailableOnEmail,@StatusId,@ApproverId,@LoginUserId,@AlternateContactNo,@LeaveCombination
                        --FROM
                        --   [dbo].[UserDetail] U  WITH (NOLOCK)
                        --WHERE U.UserId = @EmployeeId 
                        --AND U.[IsDeleted] = 0 
                        --AND U.[TerminateDate] IS NULL

---------------------------------------Insert into LeaveRequestApplication ends---------------------------------------
                        
                        DECLARE @LeaveRequestApplicationId [bigint]
                        SET @LeaveRequestApplicationId = SCOPE_IDENTITY() 

               
                     DECLARE @NoOfLeavesInCombination int, @IsLWP [bit], @LeaveType [varchar](10), @LeaveCount [float]
                        CREATE TABLE #TempLeaveDetail(
                            [Id] int IDENTITY(1, 1)
                           ,[LeaveCount] float
                           ,[LeaveType] varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL
                           ,[LeaveTypeId] int
                        )
---------------------------------------Insert into LeaveRequestApplicationDetail starts---------------------------------------
		               
					    DECLARE @Count int = 1, @LastLeaveDateId bigint = 0, @IsHalfDay bit = 0
                        WHILE(@Count <= (SELECT COUNT(*) FROM #Combination))
                        BEGIN
                            INSERT INTO #TempLeaveDetail([LeaveCount], [LeaveType])
                           SELECT  (SELECT [Character] FROM [dbo].[fnSplitWord](C.[Character], ' ') WHERE [Id] = 1)
                                  ,(SELECT [Character] FROM [dbo].[fnSplitWord](C.[Character], ' ') WHERE [Id] = 2)
                           FROM #Combination C 
                           WHERE C.[Id] = @Count
                     
                           --set leaveTypeId
                           UPDATE T
                           SET T.[LeaveTypeId] = M.[TypeId]
                           FROM #TempLeaveDetail T
                           INNER JOIN [dbo].[LeaveTypeMaster] M WITH (NOLOCK)
                              ON T.[LeaveType] = M.[ShortName]
                        

                           INSERT INTO [dbo].[LeaveRequestApplicationDetail] 
                           SELECT @LeaveRequestApplicationId, T.[LeaveTypeId], T.[LeaveCount]
                           FROM #TempLeaveDetail T
                           WHERE T.[Id] = @Count

                           --fetch dateid
                           SET @Count = @Count + 1
                        END 
---------------------------------------Insert into LeaveRequestApplicationDetail ends----------------------------------

---------------------------------------Insert into [RequestCompOffDetail] starts---------------------------------------
                   IF(@LeaveCombination  LIKE '%COFF%')
				   BEGIN

				    CREATE TABLE #TempCoffAvailed(
					Id INT IDENTITY(1,1),
					RequestId INT,
					LapseDate DATE
					)
                   DECLARE @AvailedRequestId INT,@LapseDateToBeAvailed DATE, @J INT = 1

                   INSERT INTO #TempCoffAvailed(RequestId,LapseDate) 
				   SELECT TOP (@CoffCount) RequestId,LapseDate FROM RequestCompOff
		                     WHERE IsLapsed=0 AND StatusId>2 AND IsAvailed=0 AND CreatedBy=@EmployeeId 
							 AND LapseDate>@PreviousMonthLastDate ORDER BY LapseDate ASC,RequestId ASC

                        WHILE(@J<=(SELECT COUNT(Id) FROM #TempCoffAvailed))
						BEGIN
								SET @LapseDateToBeAvailed=(SELECT LapseDate FROM #TempCoffAvailed WHERE Id=@J)
								SET @AvailedRequestId=(SELECT RequestId FROM #TempCoffAvailed WHERE Id=@J)

							   INSERT INTO [dbo].[RequestCompOffDetail](RequestId,LeaveRequestApplicationId,CreatedById)
								   VALUES( @AvailedRequestId, @LeaveRequestApplicationId, @EmployeeId )

							   UPDATE [dbo].[RequestCompOff] 
							   SET [IsAvailed] = 1 
							   WHERE [RequestId]= @AvailedRequestId 
							   SET @J = @J + 1
						END

                   END
---------------------------------------Insert into [RequestCompOffDetail] ends---------------------------------------

---------------------------------------Insert into LeaveHistory table starts---------------------------------------
						
                        INSERT INTO [dbo].[LeaveHistory]
                        (
                            [LeaveRequestApplicationId]
                           ,[StatusId]
                           ,[ApproverId]
                           ,[ApproverRemarks]
                           ,[CreatedBy]
                        )
                        SELECT
                           @LeaveRequestApplicationId
                          ,@StatusId
                          ,@ApproverId
                          ,'Applied'
                          ,@EmployeeId
---------------------------------------Insert into LeaveHistory table ends---------------------------------------

---------------------------------------Insert into DateWiseLeaveType table starts---------------------------------------

                        DECLARE @StartDateId bigint = (SELECT [dbo].[fnGetNextDateId](@FromDateId-1))
						IF(@LeaveCombination LIKE '%ML%')
						BEGIN
						 PRINT 'tttttttt'
						   SET @StartDateId = @FromDateId;
						   SET @IsFirstDayHalfDay = 0;
						   SET @IsLastDayHalfDay = 0;
						END
                        WHILE (@StartDateId <= @TillDateId)
                        BEGIN
                             PRINT 'Enter outer most while loop : @StartDateId - ' + CAST(@StartDateId as VARCHAR) + ' @TillDateId - ' + CAST(@TillDateId as VARCHAR)
                             DECLARE @TotalNoOfLeavesCounter float = (SELECT SUM([LeaveCount]) FROM #TempLeaveDetail)
                                 ,@TotalNoOfDays int = (@TillDateId - @FromDateId) + 1
                                 ,@NoOfTypeOfLeaves int = (SELECT COUNT(*) FROM #TempLeaveDetail)
                                 ,@DateWiseLeaveCounter int = 1
                                 ,@TempDateWiseLeaveCounter int
                                 ,@LoopCount float
                           --IF(@TotalNoOfLeavesCounter = @TotalNoOfDays)--ie no half days are present
                           IF(@IsFirstDayHalfDay = 0 AND @IsLastDayHalfDay = 0)--ie no half days are present
                           BEGIN
                              PRINT 'Enter If condition - no half days are present'
                              WHILE(@DateWiseLeaveCounter <= @NoOfTypeOfLeaves) --while loop from 1 till number of type leaves present
                              BEGIN
                                 SET @LoopCount = (SELECT [LeaveCount] FROM #TempLeaveDetail WHERE [Id] = @DateWiseLeaveCounter)
                                 SET @TempDateWiseLeaveCounter = 1
                                 WHILE(@TempDateWiseLeaveCounter <= CEILING(@LoopCount))--while loop individual leave wise
                                 BEGIN
                                    IF(@LoopCount = CEILING(@LoopCount))--leave count is whole number
                                    BEGIN
                                       INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay])
                                       SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 0
                                       FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                       --SET @StartDateId = @StartDateId + 1
                                      IF(@LeaveCombination LIKE '%ML%')
						              BEGIN
						                  SET @StartDateId = @StartDateId+1;
						              END
						              ELSE
						              BEGIN
             SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
						              END
                                    END
                                    ELSE--leave count is fractional
                                    BEGIN
                                       DECLARE @CheckPreviousData float = (SELECT SUM([LeaveCount]) FROM #TempLeaveDetail WHERE [Id] < @DateWiseLeaveCounter)

                                       IF(@CheckPreviousData = CEILING(@CheckPreviousData) OR @CheckPreviousData IS NULL)
                                       BEGIN
                                          IF(@TempDateWiseLeaveCounter = CEILING(@LoopCount))
                                          BEGIN
                                             print 'y'
                                             INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay], [IsLastDayHalfDay])
                                             SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 1, 1
                                             FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                          END
                                          ELSE
                                          BEGIN
                                             print 'z'
                                             INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay])
                                             SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 0
                                             FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                        PRINT 'Increase startdate 6'
                                             --SET @StartDateId = @StartDateId + 1
                                              IF(@LeaveCombination LIKE '%ML%')
						                      BEGIN
						                        SET @StartDateId = @StartDateId+1;
						                      END
						                      ELSE
						                      BEGIN
                                                SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
						                      END
                                          END
                  END
                       ELSE
                                       BEGIN
                                          IF(@TempDateWiseLeaveCounter = 1)
                                          BEGIN
                                          INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay], [IsFirstDayHalfDay])
                                          SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 1, 1
                                          FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                          PRINT 'Increase startdate 5'
                                          --SET @StartDateId = @StartDateId + 1
                                              IF(@LeaveCombination LIKE '%ML%')
						                      BEGIN
						                        SET @StartDateId = @StartDateId+1;
						                      END
						                      ELSE
						                      BEGIN
                                                SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
						                      END
                                          END
                                          ELSE
                                          BEGIN
                                             print 'a'
                                             INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay])
                                             SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 0
                                             FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                             PRINT 'Increase startdate 4'
                                             --SET @StartDateId = @StartDateId + 1
                                            IF(@LeaveCombination LIKE '%ML%')
						                      BEGIN
						                        SET @StartDateId = @StartDateId+1;
						                      END
						                      ELSE
						                      BEGIN
                                                SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
						                      END
                                          END
                              END
                                    END
                                    SET @TempDateWiseLeaveCounter = @TempDateWiseLeaveCounter + 1
                                 END
                                 SET @DateWiseLeaveCounter = @DateWiseLeaveCounter + 1
                              END
                           END
                           ELSE--logic to handle half days
                           BEGIN 
                              DECLARE @LeaveDaysDiff float = @TotalNoOfDays - @TotalNoOfLeavesCounter
                              IF(@IsFirstDayHalfDay = 1 AND @IsLastDayHalfDay = 1) --both firstday and lastday are marked as half day leave
                              BEGIN
                                 PRINT 'Enter condition - both half days are present'
                                 PRINT 'Enter data for - @StartDateId = @FromDateId'
                                 INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay], [IsLastDayHalfDay])
                                 SELECT @LeaveRequestApplicationId, @FromDateId, T.[LeaveTypeId], 1, 1
              FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                 PRINT 'Increase startdate 3'
                                 --SET @StartDateId = @StartDateId + 1
                                 SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                 WHILE(@DateWiseLeaveCounter <= @NoOfTypeOfLeaves) --while loop from 1 till number of type leaves present
                                 BEGIN         
                                    SET @LoopCount = (SELECT [LeaveCount] FROM #TempLeaveDetail WHERE [Id] = @DateWiseLeaveCounter)
                                    SET @TempDateWiseLeaveCounter = 1
                WHILE(@TempDateWiseLeaveCounter <= CEILING(@LoopCount))--while loop individual leave wise CEILING(@LoopCount)
                                    BEGIN               
               IF(@StartDateId > @FromDateId AND @StartDateId < @TillDateId)
                                       BEGIN
                                          IF(@LoopCount = CEILING(@LoopCount)) --leave count is whole number
                                          BEGIN
                                             BEGIN
                                                DECLARE @CheckPreviousData1 float = (SELECT SUM([LeaveCount]) FROM #TempLeaveDetail WHERE [Id] < @DateWiseLeaveCounter)
                     
                                                IF(@CheckPreviousData1 != CEILING(@CheckPreviousData1) OR @CheckPreviousData1 IS NULL)
                                                BEGIN
                                                   IF(@TempDateWiseLeaveCounter = CEILING(@LoopCount))
                                                   BEGIN
                                                      print 'y'
                                                      INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay], [IsLastDayHalfDay])
             SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 1, 1
                                                      FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                                   END
                                                   ELSE
                                                   BEGIN
                                                      print 'z'
                                                      INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay])
                                                      SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 0
                                                      FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                                      PRINT 'Increase startdate 6'
                                                      --SET @StartDateId = @StartDateId + 1
                                                      SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                                   END
                                                END
                                                ELSE
                                                BEGIN
                                                   IF(@TempDateWiseLeaveCounter = 1)
                                                   BEGIN
                                                      INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay], [IsFirstDayHalfDay])
                                                      SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 1, 1
                                                      FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                   PRINT 'Increase startdate 5'
                                                      --SET @StartDateId = @StartDateId + 1
                                                      SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                                   END
                                                   ELSE
                                                   BEGIN
                                                      print 'a'
                                                      INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay])
            SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 0
                                                      FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                     PRINT 'Increase startdate 4'
                                                      --SET @StartDateId = @StartDateId + 1
                                                      SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                          END
                                                END
                                             END
                                          END
                                          ELSE  --leave count is fractional
                                          BEGIN
                                             IF(@TempDateWiseLeaveCounter = 1)
              BEGIN
                                                SET @TempDateWiseLeaveCounter = @TempDateWiseLeaveCounter + 1
                                             END                     
                                             IF(@TempDateWiseLeaveCounter <= CEILING(@LoopCount))
                                             BEGIN
                                                INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay])
       SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 0
                                                FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                                PRINT 'Increase startdate 3.2'
                                                --SET @StartDateId = @StartDateId + 1
                                                SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                             END
                                          END
                               END
                                       print '@TempDateWiseLeaveCounter: ' + cast(@TempDateWiseLeaveCounter as varchar(10)) 
                                       SET @TempDateWiseLeaveCounter = @TempDateWiseLeaveCounter + 1
                                    END
                                    SET @DateWiseLeaveCounter = @DateWiseLeaveCounter + 1
                                 END
                                    PRINT 'Enter data for - @StartDateId =  @TillDateId'
                                    INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay], [IsFirstDayHalfDay])
                                    SELECT @LeaveRequestApplicationId, @TillDateId, T.[LeaveTypeId], 1, 1
                                    FROM #TempLeaveDetail T WHERE [Id] = (@DateWiseLeaveCounter-1)
                                    PRINT 'Increase startdate 3.1'
                                    --SET @StartDateId = @StartDateId + 1
                                    SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                              END
                              ELSE--this means either firstday or lastday are marked as half day
                              BEGIN
                                 IF(@IsFirstDayHalfDay = 1)--firstday marked as half day
                                 BEGIN
                                    PRINT 'Enter condition - first day half day'

                                    PRINT 'Enter data for - @StartDateId = @FromDateId'
                                    INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay], [IsFirstDayHalfDay])
                                    SELECT @LeaveRequestApplicationId, @FromDateId, T.[LeaveTypeId], 1, 1
                                    FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                    PRINT 'Increase startdate 3'
                                    --SET @StartDateId = @StartDateId + 1
                   SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                    WHILE(@DateWiseLeaveCounter <= @NoOfTypeOfLeaves) --while loop from 1 till number of type leaves present
                                    BEGIN         
                                       SET @LoopCount = (SELECT [LeaveCount] FROM #TempLeaveDetail WHERE [Id] = @DateWiseLeaveCounter)
                                       SET @TempDateWiseLeaveCounter = 1
                                       WHILE(@TempDateWiseLeaveCounter <= CEILING(@LoopCount))--while loop individual leave wise
                                       BEGIN               
                                          IF(@StartDateId > @FromDateId AND @StartDateId <= @TillDateId)
                                          BEGIN
                                             IF(@LoopCount = CEILING(@LoopCount)) --leave count is whole number
                                             BEGIN
                                         BEGIN
                                                   DECLARE @CheckPreviousData2 float = (SELECT SUM([LeaveCount]) FROM #TempLeaveDetail WHERE [Id] < @DateWiseLeaveCounter)
                        
                                                   IF(@CheckPreviousData2 = CEILING(@CheckPreviousData) OR @CheckPreviousData2 IS NULL)
                                                   BEGIN
                                                      IF(@TempDateWiseLeaveCounter = CEILING(@LoopCount))
                                                      BEGIN
                                                         print 'y'
                                                         INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay], [IsFirstDayHalfDay])
                                                         SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 1, 1
                                                         FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                                      END
                                                      ELSE
                                                      BEGIN
                                                         print 'z'
                                                         INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay])
                                                         SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 0
                                                         FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                                         PRINT 'Increase startdate 6'
                                                         --SET @StartDateId = @StartDateId + 1
                                                         SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                                      END
                                                   END
                                             ELSE
                                                   BEGIN
                                                      INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay])
                                                      SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 0
                                                      FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                                      PRINT 'Increase startdate 4'
                                                      --SET @StartDateId = @StartDateId + 1
    SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                             END
                                                END
                                             END
                                             ELSE  --leave count is fractional
                                             BEGIN
                                                DECLARE @TempCheckPreviousData float = (SELECT SUM([LeaveCount]) FROM #TempLeaveDetail WHERE [Id] < @DateWiseLeaveCounter) 
                                                IF(@TempCheckPreviousData IS NULL)
                                                BEGIN
                                                   IF(@TempDateWiseLeaveCounter = 1)
                                                   BEGIN
                                                      SET @TempDateWiseLeaveCounter = @TempDateWiseLeaveCounter + 1
                                                   END
                                                   IF(@TempDateWiseLeaveCounter <= CEILING(@LoopCount))
                                                   BEGIN
                                                      INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay])
                                                      SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 0
                                   FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                                      PRINT 'Increase startdate 3.2'
                                                      --SET @StartDateId = @StartDateId + 1
                                                      SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                                   END
                      END
                                                ELSE
                                                BEGIN
                                                   IF(@TempDateWiseLeaveCounter = 1)
                                                   BEGIN
                                                      INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay], [IsLastDayHalfDay])
                                                      SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 1, 1
                                                      FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                                      PRINT 'Increase startdate 3.3'
                                                      --SET @StartDateId = @StartDateId + 1
                                                      SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                                   END                     
                                                   ELSE
                                                   BEGIN
                                                      INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay])
                                                      SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 0
                                                      FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                                      PRINT 'Increase startdate 3.2'
                                                      --SET @StartDateId = @StartDateId + 1
                                                      SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                                   END
                                                END
                  END
                                          END
           print '@TempDateWiseLeaveCounter: ' + cast(@TempDateWiseLeaveCounter as varchar(10)) 
                                          SET @TempDateWiseLeaveCounter = @TempDateWiseLeaveCounter + 1
                                       END
                                       SET @DateWiseLeaveCounter = @DateWiseLeaveCounter + 1
                                    END
                                 END
                                 ELSE IF(@IsLastDayHalfDay = 1)--lastday marked as half day
                 BEGIN
                                    PRINT 'Enter condition - last day half day'
                                    WHILE(@DateWiseLeaveCounter <= @NoOfTypeOfLeaves) --while loop from 1 till number of type leaves present
                                    BEGIN
                                       SET @LoopCount = (SELECT [LeaveCount] FROM #TempLeaveDetail WHERE [Id] = @DateWiseLeaveCounter)
                                       SET @TempDateWiseLeaveCounter = 1
                       WHILE(@TempDateWiseLeaveCounter <= CEILING(@LoopCount))--while loop individual leave wise
                                       BEGIN               
                                          IF(@StartDateId >= @FromDateId AND @StartDateId < @TillDateId)
                                          BEGIN
                                             IF(@LoopCount = CEILING(@LoopCount)) --leave count is whole number
                    BEGIN
                                                DECLARE @CheckPreviousData3 float = (SELECT SUM([LeaveCount]) FROM #TempLeaveDetail WHERE [Id] < @DateWiseLeaveCounter)
                        
                                                IF(@CheckPreviousData3 IS NULL)
                                                BEGIN
                                                INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay])
                                                   SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 0
                                                   FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                                   PRINT 'Increase startdate 6'
                                                   --SET @StartDateId = @StartDateId + 1
                                                   SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                                END
                                                ELSE
                                                BEGIN
                                                   IF(@TempDateWiseLeaveCounter = 1)
                                                   BEGIN
                                                         INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay], [IsLastDayHalfDay])
                                                         SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 1, 1
                                                         FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                                         PRINT 'Increase startdate 3.5'
                                                         --SET @StartDateId = @StartDateId + 1
                                                         SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                                   END
                                                   ELSE
                                                   BEGIN
                                                      INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay])
                                                      SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 0
                                     FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                                      PRINT 'Increase startdate 4'
                                                      --SET @StartDateId = @StartDateId + 1
                                                      SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                                   END
                                    END
                                   END
                                             ELSE  --leave count is fractional
                                             BEGIN
                                                DECLARE @TempCheckPreviousData1 float = (SELECT SUM([LeaveCount]) FROM #TempLeaveDetail WHERE [Id] < @DateWiseLeaveCounter) 
   IF(@TempCheckPreviousData1 IS NULL OR @TempCheckPreviousData1 = CEILING(@TempCheckPreviousData1))
                                                BEGIN
                                                   IF(@NoOfTypeOfLeaves > 1)
                                                   BEGIN
                                                      IF(@TempDateWiseLeaveCounter = CEILING(@LoopCount))
                                                      BEGIN
                                                         INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay], [IsFirstHalfDay])
                                                         SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 1, 1
                                                         FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                       PRINT 'Increase startdate 3.5'
                                                      END
                                                      ELSE
                                                      BEGIN
                                                         INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay])
                                                         SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 0
                                                         FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                                         PRINT 'Increase startdate 3.6'
                                                         --SET @StartDateId = @StartDateId + 1
                                                         SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                                      END
                                                   END
                                                   ELSE
                                                   BEGIN
                                                      IF(@TempDateWiseLeaveCounter = 1)
                                                      BEGIN
                                                         SET @TempDateWiseLeaveCounter = @TempDateWiseLeaveCounter + 1
                                                      END
                                                   IF(@TempDateWiseLeaveCounter <= CEILING(@LoopCount))
                                                      BEGIN
                                                         INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay])
                                                         SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 0
                                                         FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                                         PRINT 'Increase startdate 3.2'
                                       --SET @StartDateId = @StartDateId + 1
                                                  SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                                      END
                                                   END
                                                END
                                                ELSE
                                                BEGIN
                                                   INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay])
                                                   SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 0
                                                   FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                                   PRINT 'Increase startdate 3.2'
                --SET @StartDateId = @StartDateId + 1
                                                   SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                                END
                                             END
                                          END
                                          print '@TempDateWiseLeaveCounter: ' + cast(@TempDateWiseLeaveCounter as varchar(10)) 
                                          SET @TempDateWiseLeaveCounter = @TempDateWiseLeaveCounter + 1
                                       END
                         SET @DateWiseLeaveCounter = @DateWiseLeaveCounter + 1
                                    END
                                       PRINT 'Enter data for - @StartDateId = @TillDateId'
                                       INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay], [IsLastDayHalfDay])
                                       SELECT @LeaveRequestApplicationId, @TillDateId, T.[LeaveTypeId], 1, 1
                                       FROM #TempLeaveDetail T WHERE [Id] = (@DateWiseLeaveCounter-1)
                                       PRINT 'Increase startdate 3'
                                       --SET @StartDateId = @StartDateId + 1
                                       SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                 END
                                 ELSE
                                 BEGIN                                    
                                   SET @Success=5--data supplied is incorrect
                                    ROLLBACK TRANSACTION
                                 END
                              END
                           END
                           PRINT 'Increase startdate 1'
                           --SET @StartDateId = @StartDateId + 1
						   IF(@LeaveCombination LIKE '%ML%')
						   BEGIN
						       SET @StartDateId = @StartDateId+1;
						   END
						   ELSE
						   BEGIN
                              SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
						   END
                        END

------------------------------------------Insert into DateWiseLeaveType table ends------------------------------------------
------------------------------------------Insert into LeaveBalanceHistory table starts------------------------------------------

                        INSERT INTO [dbo].[LeaveBalanceHistory]([RecordId], [Count], [CreatedBy])
                        SELECT B.[RecordId], B.[Count], @LoginUserId
                        FROM
                           #TempLeaveDetail T
                           INNER JOIN
                              [dbo].[LeaveBalance] B WITH (NOLOCK)
                                 ON T.[LeaveTypeId] = B.[LeaveTypeId]
                           WHERE
                              B.[UserId] = @EmployeeId
                  
                        --update LeaveBalance Table(not for LWP)
                        UPDATE [dbo].[LeaveBalance]
                        SET [Count] = B.[Count] - T.[LeaveCount]
                           ,[LastModifiedDate] = GETDATE()
                           ,[LastModifiedBy] = @LoginUserId
                        FROM
                           #TempLeaveDetail T
                           INNER JOIN
                              [dbo].[LeaveBalance] B WITH (NOLOCK)
                                 ON T.[LeaveTypeId] = B.[LeaveTypeId]
                        WHERE
                           B.[UserId] = @EmployeeId AND T.[LeaveType] != 'LWP' AND T.[LeaveType] !='EL'
                  
                        --update LeaveBalance Table(for LWP)
                        UPDATE [dbo].[LeaveBalance]
                        SET [Count] = B.[Count] + T.[LeaveCount]
                           ,[LastModifiedDate] = GETDATE()
                           ,[LastModifiedBy] = @LoginUserId
                        FROM
                           #TempLeaveDetail T
                           INNER JOIN
                              [dbo].[LeaveBalance] B WITH (NOLOCK)
                                 ON T.[LeaveTypeId] = B.[LeaveTypeId]
                        WHERE
                           B.[UserId] = @EmployeeId AND T.[LeaveType] = 'LWP' OR T.[LeaveType] ='EL'
                  
                        --update LeaveBalance(for 5CLOY flag)
                        IF((SELECT COUNT(*) FROM #TempLeaveDetail WHERE [LeaveType] = 'CL' AND [LeaveCount] > 2 ) > 0)
                        BEGIN
                           UPDATE [dbo].[LeaveBalance]
                        SET [Count] = 0
                           ,[LastModifiedDate] = GETDATE()
                           ,[LastModifiedBy] = @LoginUserId
                        WHERE
                           [UserId] = @EmployeeId AND [LeaveTypeId] = 8 --id for 5CLOY
                        END
------------------------------------------Insert into LeaveBalanceHistory table ends------------------------------------------                  
                         SET @Success=4 --success
                     COMMIT TRANSACTION
                     
                     DROP TABLE #TempLeaveDetail
                     DROP TABLE #Combination
               END
               ELSE
               BEGIN
                  --SET @Status = 3 --combination supplied is invalid
                   SET @Success=3
               END
            END
            ELSE
            BEGIN
               --SET @Status = 2 --no combination present
                SET @Success=2
            END
         END

	  END
END TRY
BEGIN CATCH
	-- On Error
	IF @@TRANCOUNT > 0
	BEGIN
		ROLLBACK TRANSACTION;
	END

	SET @Success = 0;
	DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
	--Log Error
	EXEC [spInsertErrorLog]
		@ModuleName = 'LeaveManagement'
	,@Source = 'spApplyLeave'
	,@ErrorMessage = @ErrorMessage
	,@ErrorType = 'SP'
	,@ReportedByUserId = @EmployeeId
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[spGetAvailableLeaveCombination]    Script Date: 21-11-2018 19:31:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetAvailableLeaveCombination]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGetAvailableLeaveCombination] AS' 
END
GO
/***
   Created Date      :     2015-05-26
   Created By        :     Nishant Srivastava
   Purpose           :     This stored procedure give all the possible combination of leaves according to user leave balance .
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   31 oct 2018        Kanchan Kumari      added Maternity Leave and Paternity Leave combination
   --------------------------------------------------------------------------
   21 nov 2018        Kanchan kumari      added exam leave for technical trainee
   Test Cases        : 3 LWP3 LWP
   --------------------------------------------------------------------------
   --- Test Case 1
        
/**Declare @Userid int ,@NoOfWorkingDays float ,@LeaveTypeId int ,@i int, @CL float ,@PL int,@compOf int ,@IsSpecial bit
SET @Userid = 2234
SET @NoOfWorkingDays =2
UPDATE LeaveBalance_Dummy
        SET NoOfLeave = 2
WHERE Userid = 33 And LeaveTypeId = 4 **/
***/
ALTER PROC [dbo].[spGetAvailableLeaveCombination]
    @Userid INT 
   ,@NoOfWorkingDays FLOAT 
   ,@LeaveApplicationId bigint
   ,@TotalDays INT
  AS
      BEGIN
      Declare @LeaveTypeId int ,@i int, @CL float ,@PL int,@compOf int ,@IsSpecial bit, @leaveappliedCount float,@leavetype int, @ML INT, @PLM INT
       --supplying a data contract
         IF 1 = 2 
            BEGIN
                   SELECT
                       CAST(NULL AS [Varchar] (50)) AS [LeaveCombination]                       				   
                   WHERE
                       1 = 2
            END   
	
	-- To add leave count of the leave which is being cancelled when cancel and applying leave	
		SELECT @leaveappliedCount = LD.[Count], @Leavetype = LD.[LeaveTypeId]
		FROM [dbo].[LeaveRequestApplicationDetail] LD WITH (NOLOCK)
				INNER JOIN [dbo].[LeaveTypeMaster] LS WITH (NOLOCK) ON LD.[LeaveTypeId] = LS.[TypeId]
		WHERE LD.[LeaveRequestApplicationId] = @LeaveApplicationId
		AND LS.[ShortName] != 'LWP'
         
		 --IF OBJECT_ID('tempdb..#Temp') IS NOT NULL
		 --DROP TABLE #Temp     

         CREATE TABLE #Temp
         (
         [Userid] [int] NOT NULL,
         [LeaveTypeID] [int] NOT NULL,
         [LeaveCombination] [Varchar](50),
         [IsSpecial] [bit] 
         ) 

         SELECT  @IsSpecial = COUNT(*) 
         FROM [dbo].[LeaveBalance] WITH (NOLOCK) 
         WHERE [Userid] = @Userid AND [LeaveTypeId] =8  AND [Count] =1 --and [NoOfLeave] >=1
         
			IF (@Leavetype = 1 AND @leaveappliedCount > 2)
				SET @IsSpecial = 1

         --SELECT @IsSpecial AS IsSpecial

         SET @i = 1
         WHILE @i <= 5
         BEGIN
            BEGIN
                  IF (@i =1)
                     SET @LeaveTypeId = 1 
                  ELSE IF (@i =2)
                     Set @LeaveTypeId = 2
                  ELSE IF (@i =3)
                     Set @LeaveTypeId = 4   
				  ELSE IF (@i = 4)----newly added combination
				    Set @LeaveTypeId = 6 ---ML 
					 ELSE IF (@i = 5)----newly added combination
				    Set @LeaveTypeId = 7 ---PL(M)         
            END

         SET @i =  @i + 1 
     
         SELECT @CL = [Count] FROM [dbo].[LeaveBalance] WITH (NOLOCK) WHERE Userid= @Userid AND LeaveTypeId= 1
         SELECT @PL = [Count] FROM [dbo].[LeaveBalance] WITH (NOLOCK) WHERE Userid= @Userid AND LeaveTypeId= 2
         SELECT @compOf = [Count] FROM [dbo].[LeaveBalance] WITH (NOLOCK) WHERE Userid= @Userid AND LeaveTypeId= 4
		 SELECT @ML = [Count] FROM [dbo].[LeaveBalance] WITH (NOLOCK) WHERE Userid= @Userid AND LeaveTypeId= 6
		 SELECT @PLM = [Count] FROM [dbo].[LeaveBalance] WITH (NOLOCK) WHERE Userid= @Userid AND LeaveTypeId= 7
         
			  IF (@Leavetype = 1)
				SET @CL = @CL + @leaveappliedCount 
			ELSE IF (@Leavetype = 2)
				Set @PL = @PL + @leaveappliedCount
			ELSE IF (@Leavetype =3 )
				Set @compOf = @compOf + @leaveappliedCount
   --     ELSE IF(@Leavetype = 6)----newly added combination
			    --Set @ML = @ML + @leaveappliedCount

             IF (@LeaveTypeId = 1 )
            BEGIN
                     IF (  @IsSpecial = 1 )
                     BEGIN
                         IF( @CL >=2  AND @NoOfWorkingDays <= 2)
                        BEGIN
                              INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                              SELECT  Userid
									  ,LeaveTypeId 
									  ,Convert (varchar(5),@NoOfWorkingDays,0) + ' CL '  AS LeaveCombination
                                    ,@IsSpecial As ISSpecial
FROM   [dbo].[LeaveBalance] WITH (NOLOCK) 
                              WHERE   Userid = @Userid and LeaveTypeId= 1
                              PRINT '1.0'
                        END
                         ELSE IF( @CL >=5  AND  @NoOfWorkingDays <= 5 AND @CL >= @NoOfWorkingDays)--  @NoOfWorkingDays <= 5 )
                        BEGIN
                              INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                              SELECT  Userid
                                    ,LeaveTypeId 
                                    ,Convert (varchar(5),@NoOfWorkingDays,0) +' CL '  AS LeaveCombination
                                    ,@IsSpecial As ISSpecial
                              FROM   [dbo].[LeaveBalance] WITH (NOLOCK) 
                              WHERE   Userid = @Userid and LeaveTypeId= 1
                              PRINT '1.2'
                        END
						ELSE IF (@CL >= 5 AND @NoOfWorkingDays >= 5 )
                        BEGIN
                              INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                                 SELECT  Userid
                                       ,LeaveTypeId 
                                       ,'5 CL + ' + Convert (varchar(5),@NoOfWorkingDays - 5,0)  + ' LWP' AS LeaveCombination
                                       ,@IsSpecial As ISSpecial
                                 FROM   [dbo].[LeaveBalance] WITH (NOLOCK) 
                                 WHERE   Userid = @Userid and LeaveTypeId= 1
                                 PRINT '1.3'
                                 ------------------------------------
							
                                 IF(@NoOfWorkingDays <= 10 AND @PL >= (@NoOfWorkingDays - 5))
                                 BEGIN
                                    INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                                    SELECT  Userid
                                          ,LeaveTypeId 
                                          ,'5 CL + ' + Convert (varchar(5),@NoOfWorkingDays - 5,0)  + ' PL' AS LeaveCombination
                                          ,@IsSpecial As ISSpecial
                                    FROM   [dbo].[LeaveBalance] WITH (NOLOCK)
                                   WHERE   Userid = @Userid and LeaveTypeId= 1
                                 END
                                 ------------------------------------
                        END 
                        ELSE IF( @CL <=5  AND @NoOfWorkingDays <= 5 )

                              BEGIN
                                  INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                                  SELECT  Userid
                                          ,LeaveTypeId 
                                          ,CASE
                                                WHEN @NoOfWorkingDays <= @CL THEN  Convert (varchar(5), @NoOfWorkingDays,0) + ' CL'
                                                ELSE Convert (varchar(5), @CL,0) + ' CL + '+ Convert (varchar(5),@NoOfWorkingDays - @CL,0)  + ' LWP'
                                           END                                          
                                          ,@IsSpecial As ISSpecial
                            FROM   [dbo].[LeaveBalance] WITH (NOLOCK) 
                                  WHERE   Userid = @Userid and LeaveTypeId= 1
                                  PRINT '1.4'
								------------------------------------
								
								  
                                  IF(@PL >= (@NoOfWorkingDays - @CL))
								
                                    BEGIN
                                       INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
       SELECT  Userid
                      ,LeaveTypeId 
                                             ,CASE
     WHEN @NoOfWorkingDays <= @CL THEN  Convert (varchar(5), @NoOfWorkingDays,0) + ' CL'
                                                ELSE Convert (varchar(5), @CL,0) + ' CL + ' + Convert (varchar(5),@NoOfWorkingDays - @CL,0)  + ' PL'
                                             END                                                                                       
                                             ,@IsSpecial As ISSpecial
                                       FROM   [dbo].[LeaveBalance] WITH (NOLOCK)
                                       WHERE   Userid = @Userid and LeaveTypeId= 1
                                       PRINT '1.4.1'
                                    END
                                  ------------------------------------
                              END
                             
                          ELSE IF (@CL <= 5 AND @NoOfWorkingDays >= 5 )

                              BEGIN
                                  INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                                     SELECT  Userid
                                             ,LeaveTypeId 
                                             ,Convert (varchar(5), @CL,0) + ' CL + '+ Convert (varchar(5),@NoOfWorkingDays - @CL,0)  + ' LWP' AS LeaveCombination
                                             ,@IsSpecial As ISSpecial
                                     FROM   [dbo].[LeaveBalance] WITH (NOLOCK) 
                                     WHERE   Userid = @Userid and LeaveTypeId= 1
                                     PRINT '1.5'
                                   ------------------------------------
                                       IF(@NoOfWorkingDays <= 10 AND @PL >= (@NoOfWorkingDays - @CL))
                                       BEGIN
                                          INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                                          SELECT  Userid
                                                ,LeaveTypeId 
                                                ,Convert (varchar(5), @CL,0) + ' CL + ' + Convert (varchar(5),@NoOfWorkingDays - 5,0)  + ' PL' AS LeaveCombination
                                                ,@IsSpecial As ISSpecial
                                          FROM   [dbo].[LeaveBalance] WITH (NOLOCK)
                                          WHERE   Userid = @Userid and LeaveTypeId= 1
                                       END
                                   ------------------------------------
                              END
                          ELSE IF (@CL  = 0 AND @NoOfWorkingDays >= 1 )

                              BEGIN
                                  INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                                     SELECT  Userid,LeaveTypeId 
                                             ,Convert (varchar(5),@NoOfWorkingDays,0)  + ' LWP' AS LeaveCombination
                                             ,@IsSpecial As ISSpecial
                                     FROM   [dbo].[LeaveBalance] WITH (NOLOCK) 
                                     WHERE   Userid = @Userid and LeaveTypeId= 1
                                     PRINT '1.6'
                              END
				
                      END  
           ELSE
                     BEGIN
                             
	                         IF (  @CL >= 2 AND  @NoOfWorkingDays > 2 AND @IsSpecial = 0)
                              BEGIN
                                   INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                                  SELECT  Userid
                                          ,LeaveTypeId 
										  ,'2 CL + ' + Convert (varchar(5),@NoOfWorkingDays - 2,0) + ' LWP '   AS LeaveCombination
    ,@IsSpecial As ISSpecial
								 FROM   [dbo].[LeaveBalance] WITH (NOLOCK) 
                     WHERE   Userid = @Userid and LeaveTypeId= 1
                                  PRINT '1.7 '
                               END
                               ELSE IF ( ( @CL <> 0 and @CL <= 2) AND  @NoOfWorkingDays <= 2 AND @CL < @NoOfWorkingDays AND @IsSpecial = 0)
                              BEGIN
                                   INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                                  SELECT  Userid
                                          ,LeaveTypeId 
                                          ,Convert (varchar(5),@CL ,0) + ' CL + ' + Convert (varchar(5),@NoOfWorkingDays -@CL ,0) + ' LWP'   AS LeaveCombination
                                          ,@IsSpecial As ISSpecial
                                  FROM   [dbo].[LeaveBalance] WITH (NOLOCK) 
                                  WHERE   Userid = @Userid and LeaveTypeId= 1
                                  PRINT '1.8'
                               END
                               ELSE IF ( ( @CL <> 0 and @CL <= 2) AND  @NoOfWorkingDays <= 2 AND @CL = @NoOfWorkingDays AND @IsSpecial = 0 )
                              BEGIN
                                   INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                                  SELECT  Userid
                                          ,LeaveTypeId 
                                          ,Convert (varchar(5),@NoOfWorkingDays ,0) + ' CL '    AS LeaveCombination
                                          ,@IsSpecial As ISSpecial
                                  FROM   [dbo].[LeaveBalance] WITH (NOLOCK) 
                                  WHERE   Userid = @Userid and LeaveTypeId= 1
                                  PRINT '1.9'
                               END
                               ELSE IF (   @NoOfWorkingDays <= 2 AND @CL > @NoOfWorkingDays  AND @IsSpecial = 0)
                              BEGIN
                                   INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                                  SELECT  Userid
                                          ,LeaveTypeId 
                                          ,Convert (varchar(5),@NoOfWorkingDays ,0) + ' CL '    AS LeaveCombination
                ,@IsSpecial As ISSpecial
                                  FROM   [dbo].[LeaveBalance] WITH (NOLOCK) 
                                  WHERE   Userid = @Userid and LeaveTypeId= 1
                                  PRINT '1.10'
                               END
                                ELSE IF ( ( @CL = 0 ) AND  @NoOfWorkingDays <= 2 AND @IsSpecial = 0 )
                              BEGIN
                                   INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                                  SELECT  Userid
                                          ,LeaveTypeId 
                                          ,Convert (varchar(5),@CL,0) +' CL + ' + Convert (varchar(5),@NoOfWorkingDays ,0) + ' LWP '   AS LeaveCombination
                                          ,@IsSpecial As ISSpecial
                                  FROM   [dbo].[LeaveBalance] WITH (NOLOCK) 
                                  WHERE   Userid = @Userid and LeaveTypeId= 1
                                  PRINT '1.11'
                               END

                           ELSE IF (@CL  = 0 AND @NoOfWorkingDays >= 1  AND @IsSpecial = 0 )

                              BEGIN
                                  INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                                     SELECT  Userid
											,LeaveTypeId 
											,Convert (varchar(5),@CL,0) +' CL + ' + Convert (varchar(5),@NoOfWorkingDays,0)  + ' LWP' AS LeaveCombination
                         ,@IsSpecial As ISSpecial
                                     FROM   [dbo].[LeaveBalance] WITH (NOLOCK) 
         WHERE   Userid = @Userid and LeaveTypeId= 1
         PRINT '1.12'
                              END
                           END
           END
             IF (@LeaveTypeId = 2 )
            BEGIN
               IF (@PL > 0  And @NoOfWorkingDays > 0)
                     BEGIN
                        IF (@pl >= @NoOfWorkingDays )
                           BEGIN             
                                    INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)  
                                    SELECT Userid ,LeaveTypeId , Convert (varchar(4),(@NoOfWorkingDays ),0 ) + ' PL' AS LeaveCombination
                                    ,0 As ISSpecial
                                    FROM [dbo].[LeaveBalance] WITH (NOLOCK) 
                                    WHERE Userid = @Userid and LeaveTypeId = 2
                                    PRINT '2.0'
                           END
                        ELSE 
                           BEGIN
                                    INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                                    SELECT Userid ,LeaveTypeId , Convert (varchar(4),@pl ,0 ) + ' PL + ' + Convert (varchar(4),(@NoOfWorkingDays- @pl ),0 )+ ' LWP' AS LeaveCombination
                                    ,0 As ISSpecial
                                    FROM [dbo].[LeaveBalance] WITH (NOLOCK) 
                                    WHERE Userid = @Userid and LeaveTypeId= 2
                                    PRINT '2.1'
                           END
                     END
                 ELSE 
                           BEGIN
                                     INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                                    SELECT Userid 
                                          ,LeaveTypeId 
                                          ,Convert (varchar(4),@pl ,0 ) + ' PL + ' +Convert (varchar(4),(@NoOfWorkingDays),0 )+ ' LWP' AS LeaveCombination
                                    ,0 As ISSpecial
                                    FROM [dbo].[LeaveBalance] WITH (NOLOCK) 
                                    WHERE Userid = @Userid and LeaveTypeId= 2
          Print '2.2'
                           END
            END
             IF (@LeaveTypeId = 4 )
            BEGIN
               IF ( @compOf >= 1 AND @NoOfWorkingDays = 1 )
                  BEGIN   
                         INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)            
                        SELECT 
                              Userid 
                             ,LeaveTypeId 
                             ,Convert (varchar(4),(@NoOfWorkingDays ),0 ) + ' COFF' AS LeaveCombination
                        ,0 As ISSpecial
                        FROM [dbo].[LeaveBalance] WITH (NOLOCK) 
                        WHERE Userid = @Userid and LeaveTypeId= 4
                        PRINT '3.0'
                  END
              ELSE IF(@compOf >= 1 AND @NoOfWorkingDays = 0.5)--condition for 0.5 coff
               BEGIN   
              INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)            
                     SELECT 
                           Userid 
                           ,LeaveTypeId 
                           ,Convert (varchar(4),(@NoOfWorkingDays ),0 ) + ' LWP' AS LeaveCombination
                     ,0 As ISSpecial
                     FROM [dbo].[LeaveBalance] WITH (NOLOCK) 
                     WHERE Userid = @Userid and LeaveTypeId= 4
                      PRINT '3.1'
               END
       ELSE IF(@compof >=1 AND @NoOfWorkingDays<=2 AND @NoOfWorkingDays>1)
	   BEGIN
	   INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)            
                     SELECT 
                           Userid 
                           ,LeaveTypeId 
                           ,CASE
                           WHEN @CL>=1 THEN '1 COFF + ' + Convert (varchar(4),(@NoOfWorkingDays-1 ),0 ) + ' CL' 
						   ELSE  '1 COFF + ' + Convert (varchar(4),(@NoOfWorkingDays-1 ),0 ) + ' LWP' 
						    END    
                     ,0 As ISSpecial
                     FROM [dbo].[LeaveBalance] WITH (NOLOCK) 
                     WHERE Userid = @Userid and LeaveTypeId= 4
                      PRINT '3.2'
	   END
	   IF(@compof >=1 AND @NoOfWorkingDays<=2 AND @NoOfWorkingDays>1)
	   BEGIN
	   INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)            
                     SELECT 
                           Userid 
                           ,LeaveTypeId 
                           ,CASE
                            WHEN @PL>=1 THEN '1 COFF + ' + Convert (varchar(4),(@NoOfWorkingDays-1 ),0 ) + ' PL' 
						   ELSE  '1 COFF + ' + Convert (varchar(4),(@NoOfWorkingDays-1 ),0 ) + ' LWP' 
						    END    
							,0 As ISSpecial
                     FROM [dbo].[LeaveBalance] WITH (NOLOCK) 
                     WHERE Userid = @Userid and LeaveTypeId= 4
                      PRINT '3.3'
	   END
	    IF(@compof >=2 AND @NoOfWorkingDays>2 AND @NoOfWorkingDays<=10)
	   BEGIN
	   INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)            
                     SELECT 
                           Userid 
                           ,LeaveTypeId
						   ,CASE
                            WHEN @PL>=@NoOfWorkingDays-2 THEN '2 COFF + ' + Convert (varchar(4),(@NoOfWorkingDays-2 ),0 ) + ' PL' 
						   ELSE  '2 COFF + ' + Convert (varchar(4),(@NoOfWorkingDays-2),0 ) + ' LWP' 
						    END   
                           ,0 As ISSpecial
                     FROM [dbo].[LeaveBalance] WITH (NOLOCK) 
                     WHERE Userid = @Userid and LeaveTypeId= 4
                      PRINT '3.4'
	   END
	    IF(@compof >=2  AND @CL>=2 AND @NoOfWorkingDays>2 AND @NoOfWorkingDays<=4)
	   BEGIN
	   INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)          
                     SELECT 
                           Userid 
                           ,LeaveTypeId 
                           ,'2 COFF + ' + Convert (varchar(4),(@NoOfWorkingDays-2 ),0 ) + ' CL' AS LeaveCombination
                     ,0 As ISSpecial
                     FROM [dbo].[LeaveBalance] WITH (NOLOCK) 
                     WHERE Userid = @Userid and LeaveTypeId= 4
                      PRINT '3.5'
	   END
	   IF(@compof >=2  AND @NoOfWorkingDays=2)
	   BEGIN
	   INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)          
                     SELECT 
                           Userid 
                           ,LeaveTypeId 
                           ,'2 COFF'  AS LeaveCombination
                     ,0 As ISSpecial
                     FROM [dbo].[LeaveBalance] WITH (NOLOCK) 
                     WHERE Userid = @Userid and LeaveTypeId= 4
                      PRINT '3.5'
	   END

           END 
		     IF (@LeaveTypeId = 6) ---Maternity Leave
			 BEGIN
			    IF((SELECT UserId FROM [UserDetail] WHERE UserId = @Userid AND GenderId = 2 AND MaritalStatusId = 2)>0)
				BEGIN
				PRINT 'MLP'
					IF(@NoOfWorkingDays<=@ML)
					BEGIN
						INSERT INTO #Temp  (Userid, LeaveTypeID, LeaveCombination, IsSpecial)  
						SELECT Userid, LeaveTypeId, Convert (varchar(4),(@TotalDays ),0 ) + ' ML' AS LeaveCombination
						, 0 As ISSpecial
						FROM [dbo].[LeaveBalance] WITH (NOLOCK) 
						WHERE Userid = @Userid and LeaveTypeId = @LeaveTypeId
                    END
                END
			 END    
			 IF (@LeaveTypeId = 7) ---Paternity Leave
			 BEGIN
			    IF((SELECT UserId FROM [UserDetail] WHERE UserId = @Userid AND GenderId = 1 AND MaritalStatusId = 2)>0)
				BEGIN
				PRINT 'PLM'
					IF(@NoOfWorkingDays <= @PLM)
					BEGIN
						INSERT INTO #Temp  (Userid, LeaveTypeID, LeaveCombination, IsSpecial)  
						SELECT Userid, LeaveTypeId, Convert (varchar(4),(@NoOfWorkingDays ),0 ) + ' PL(M)' AS LeaveCombination
						, 0 As ISSpecial
						FROM [dbo].[LeaveBalance] WITH (NOLOCK) 
						WHERE Userid = @Userid and LeaveTypeId = @LeaveTypeId
                    END
                END
			 END  
			 INSERT INTO #Temp (Userid, LeaveTypeID, LeaveCombination, IsSpecial)  
			 SELECT UserId,LeaveTypeId,LeaveCombination,IsSpecial FROM [dbo].[Fn_GetUserForExamLeaves](@Userid, @NoOfWorkingDays)
     END

         UPDATE #Temp 
         SET LeaveCombination = Replace (LeaveCombination ,'0 CL +','')
         WHERE LeaveTypeID =1

         UPDATE #Temp 
         SET LeaveCombination = Replace (LeaveCombination ,'0 PL +','')
         WHERE LeaveTypeID =2

         UPDATE #Temp 
         SET LeaveCombination = Replace (LeaveCombination ,'0 COFF +','')
         WHERE LeaveTypeID =4

		 UPDATE #Temp 
         SET LeaveCombination = Replace (LeaveCombination ,'0 ML +','')
         WHERE LeaveTypeID =6

		 UPDATE #Temp 
         SET LeaveCombination = Replace (LeaveCombination ,'0 PL(M) +','')
         WHERE LeaveTypeID =6

		 UPDATE #Temp 
         SET LeaveCombination = Replace (LeaveCombination ,'0 EL +','')
         WHERE LeaveTypeID =(select TypeId FROM LeaveTypeMaster where ShortName = 'EL')

         SELECT DISTINCT LTRIM(RTRIM(LeaveCombination)) AS LeaveCombination
         FROM #Temp GROUP BY LeaveCombination,Userid
     END 

GO
/****** Object:  StoredProcedure [dbo].[spGetLeaveBalanceForUser]    Script Date: 21-11-2018 19:31:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetLeaveBalanceForUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGetLeaveBalanceForUser] AS' 
END
GO
/***
   Created Date      :     2015-12-24
   Created By        :     Nishant Srivastava
   Purpose           :     This stored procedure return leave balance based on userId
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   13-May-2017		Sudhanshu Shekhar	  Auto Calculate FY Start/End date, LNSA date filter correction, Old/New PL implementation
   28-Nov-2017		Sudhanshu Shekhar	  Old and New PL canculation
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   EXEC [dbo].[spGetLeaveBalanceForUser] @UserId = 84
***/
ALTER PROCEDURE [dbo].[spGetLeaveBalanceForUser] 
(
   @UserId INT
)
AS
BEGIN
   SET NOCOUNT ON;
   SET FMTONLY OFF;    

   DECLARE @NewPLStartDate DATE= '01 Jun 2017', @MaxPLCutOff INT =20;

   IF OBJECT_ID('tempdb..#TempLeaveCount') IS NOT NULL
   DROP TABLE #TempLeaveCount

   DECLARE @FYStartDate DATE = '01 Apr '+cast(YEAR(DATEADD(Month,-((DATEPART(Month,GETDATE())+8) %12),GETDATE())) AS VARCHAR(4)) --'20170401'
         ,@FYEndDate DATE = '31 Mar '+cast(YEAR(DATEADD(Month,-((DATEPART(Month,GETDATE())+8) %12),GETDATE()))+1 AS VARCHAR(4)) --'20180331'
         ,@QStartDate DATE = CAST (DATEADD(q, DATEDIFF(q, 0, GETDATE()), 0) AS [Date])
         ,@QEndDate DATE = CAST (DATEADD(d, -1, DATEADD(q, DATEDIFF(q, 0, GETDATE()) + 1, 0)) AS [Date])
   
   CREATE TABLE #TempLeaveCount(
       [LeaveType] varchar(10)
      ,[LeaveCount] float
   )

   INSERT INTO #TempLeaveCount
   SELECT LT.[ShortName] AS [LeaveType]
         ,LB.[Count] AS [LeaveCount]
   FROM [LeaveBalance] LB WITH (NOLOCK)
   INNER JOIN [dbo].[LeaveTypeMaster]  LT WITH (NOLOCK) ON LB.[LeaveTypeId] = LT.[TypeId]
   WHERE LB.[UserId] = @UserId AND LT.[ShortName] IN ('CL', 'PL', 'LWP', 'COFF','ML','PL(M)', '5CLOY','EL')
   
   --WFH-------------
   INSERT INTO #TempLeaveCount
   SELECT 'WFH', ISNULL(AP.[Approved],0)
   FROM [dbo].[UserDetail] U WITH (NOLOCK)		
   LEFT JOIN
         (
            SELECT L.[UserId]         
				   ,SUM(LD.[Count]) AS [Approved]
            FROM [dbo].[LeaveRequestApplication] L WITH (NOLOCK)
            INNER JOIN [dbo].[LeaveRequestApplicationDetail] LD WITH (NOLOCK) ON LD.[LeaveRequestApplicationId] = L.[LeaveRequestApplicationId]
            INNER JOIN (
                        SELECT [LeaveRequestApplicationId] AS [LeaveRequestApplicationId]
							   ,Count(*) AS [TotalIncludingDays]
                        FROM [dbo].[DateWiseLeaveType] T WITH (NOLOCK)
                        INNER JOIN [dbo].[DateMaster] D WITH (NOLOCK) ON T.[DateId] = D.[DateId]
                        WHERE D.[Date] BETWEEN @FYStartDate AND @FYEndDate
                        GROUP BY [LeaveRequestApplicationId]
                        ) D
                        ON D.[LeaveRequestApplicationId] = L.[LeaveRequestApplicationId]
             INNER JOIN [dbo].[LeaveTypeMaster] LT WITH (NOLOCK) ON LT.[TypeId] = LD.[LeaveTypeId]      
            WHERE L.[LeaveCombination] IS NULL 
               AND LT.[ShortName] = 'WFH'
               AND L.[StatusId] > 2
            GROUP BY L.[UserId]
	      ) AP ON U.[UserId] = AP.[UserId]
      WHERE U.[UserId] = @UserId

   --LNSA-------------
  
   INSERT INTO #TempLeaveCount
   SELECT 
		'LNSA'
		,ISNULL(AP.[Approved], 0)
   FROM [dbo].[UserDetail] U WITH (NOLOCK)		
   LEFT JOIN 
		 (
			SELECT 
				 COUNT(D.IsApprovedBySystem ) AS [Approved]
				,R.[CreatedBy]				  AS [UserId]
			FROM [dbo].[DateWiseLNSA] D
			INNER JOIN [dbo].[RequestLNSA] R ON R.[RequestId]=D.[RequestId] 
			INNER JOIN [dbo].[DateMaster] DM ON DM.[DateId]=D.[DateId]
			WHERE  D.[IsApprovedBySystem]=1
			AND DM.[Date] BETWEEN @QStartDate AND @QEndDate
			GROUP BY R.[CreatedBy]			
		  ) AP 
	ON U.[UserId] = AP.[UserId]
    WHERE U.[UserId] = @UserId
   
   PRINT 'OK'
   DECLARE  @OldPL FLOAT = 0
			,@NewPL FLOAT = 0
   
   SELECT @OldPL = OldPL
		 ,@NewPL = NewPL FROM [dbo].[Fun_GetOldAndNewPLByUser](@UserId)

   INSERT INTO #TempLeaveCount
   VALUES ('OLDPL', @OldPL)
		 ,('NEWPL', @NewPL);
   ----------------------------
   SELECT * FROM #TempLeaveCount
END

GO
/****** Object:  StoredProcedure [dbo].[spGetLeaves]    Script Date: 21-11-2018 19:31:56 ******/
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
	 ,CASE WHEN L.[LeaveCombination] LIKE '%ML%' THEN CAST(L.[LeaveCombination] AS [varchar](8)) + ' (' + L.[LeaveCombination] + ')'
		 ELSE CAST(L.[NoOfWorkingDays] AS [varchar](10)) + ' (' + L.[LeaveCombination]+ ')'	END AS [LeaveInfo]
     --,CAST(L.[NoOfWorkingDays] AS [varchar](10)) + ' (' + L.[LeaveCombination] + ')' AS [LeaveInfo]
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
/****** Object:  StoredProcedure [dbo].[spGetUserAppliedLeave]    Script Date: 21-11-2018 19:31:56 ******/
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
   Test Cases        :
   --------------------------------------------------------------------------
   EXEC [dbo].[spGetUserAppliedLeave] 
		@UserId = 2253
		,@Year=2018
***/

ALTER PROCEDURE [dbo].[spGetUserAppliedLeave] 
   @UserID [int],
   @Year [int] = null
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
GO
/****** Object:  StoredProcedure [dbo].[spTakeActionOnAppliedLeave]    Script Date: 21-11-2018 19:31:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spTakeActionOnAppliedLeave]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spTakeActionOnAppliedLeave] AS' 
END
GO
/***
   Created Date      :     2016-02-08
   Created By        :     Nishant Srivastava
   Purpose           :     This stored procedure to Tacke Action On Apply Leave By User,Manager,HR 
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   2016-5-18         Narender Singh       Handling for Cancel leave after availing
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   --- Test Case 1
      EXEC [dbo].[spTakeActionOnAppliedLeave] 
         @LeaveRequestApplicationId = 10019
        ,@Status = 'PV'
        ,@Remarks = 'Approved'
        ,@UserId = 2166
        ,@ForwardedId = 0 -- take care of 5CL in a year

   --  Test Case 2
      EXEC [dbo].[spTakeActionOnAppliedLeave] 
         @LeaveRequestApplicationId = 8686
        ,@Status = 'PV' -- pending for verification
        ,@Remarks = 'OK'
        ,@UserId = 2432
        ,@ForwardedId = 0 --or some other id

   --  Test Case 3
      EXEC [dbo].[spTakeActionOnAppliedLeave] 
         @LeaveRequestApplicationId = 1
        ,@Status = 'AP' -- pending for verification
        ,@Remarks = 'Approved by Amit Handa'
        ,@UserId = 4
        ,@ForwardedId = 0 or some other id

   --  Test Case 4
      EXEC [dbo].[spTakeActionOnAppliedLeave] 
         @LeaveRequestApplicationId = 8874
        ,@Status = 'CA' -- pending for verification
        ,@Remarks = 'Cancelled'
        ,@UserId = 2166
        ,@ForwardedId = 0 or some other id
***/
ALTER PROCEDURE [dbo].[spTakeActionOnAppliedLeave] 
   @LeaveRequestApplicationId [bigint]
  ,@Status [varchar] (2)
  ,@Remarks [Varchar] (500)
  ,@UserId [int]
  ,@ForwardedId [int]
AS
BEGIN
	SET NOCOUNT ON
   
   IF OBJECT_ID('tempdb..#TempCoffCount') IS NOT NULL
     DROP TABLE #TempCoffCount 

   BEGIN TRY
      DECLARE @Date [date] = GETDATE()
	
      IF EXISTS (SELECT 1 FROM [dbo].[LeaveRequestApplication] WITH (NOLOCK) WHERE [LeaveRequestApplicationId] = @LeaveRequestApplicationId AND [LastModifiedBy] = @UserId)
      BEGIN
         SELECT 'DUPLICATE' AS [Result]
         RETURN
      END
      ELSE IF EXISTS (SELECT 1 FROM [dbo].[LeaveRequestApplication] L WITH (NOLOCK) INNER JOIN [dbo].[DateMaster] D WITH (NOLOCK) ON L.[FromDateId] = D.[DateId] 
					  WHERE L.[LeaveRequestApplicationId] = @LeaveRequestApplicationId AND L.[UserId] = @UserId AND D.[Date] <= @Date AND L.[StatusId] = 0) --@Status = 'CA')
      BEGIN
         SELECT 'CANCELLED'                                                                                   AS [Result]
         RETURN
      END

      BEGIN TRANSACTION
      -- create history of existing record

	INSERT INTO [dbo].[LeaveHistory] 
	(
		[LeaveRequestApplicationId]
		,[StatusId]
		,[ApproverId]
		,[ApproverRemarks]
		,[CreatedDate]
		,[CreatedBy]
	)
     SELECT 
           @LeaveRequestApplicationId
          ,[Statusid]
          ,@UserID
          ,@Remarks
          ,GETDATE ()
          ,@UserID
     FROM [dbo].[LeaveStatusMaster] LS WITH (NOLOCK) 
	 WHERE LS.StatusCode = @Status
   
      --declarations
   
      DECLARE @EmployeeId int = (SELECT [UserId] FROM [LeaveRequestApplication] WHERE [LeaveRequestApplicationId] = @LeaveRequestApplicationId)
      DECLARE @FirstReportingManagerId int = (SELECT [dbo].[fnGetReportingManagerByUserId](@EmployeeId))
             ,@SecondReportingManagerId int = (SELECT [dbo].[fnGetSecondReportingManagerByUserId](@EmployeeId))
             ,@HRId int = (SELECT [dbo].[fnGetHRIdByUserId](@EmployeeId))
             ,@DepartmentHeadId int = (SELECT [dbo].[fnGetDepartmentHeadIdByUserId](@EmployeeId))
      DECLARE @NoOfActionsOnRequest int = (SELECT COUNT(*) FROM [LeaveHistory] WHERE [LeaveRequestApplicationId] = @LeaveRequestApplicationId AND [StatusId] > 0 AND [ApproverId] IN (@FirstReportingManagerId, @SecondReportingManagerId))
      DECLARE @IsForwardToDepartmentHead bit = 0
   
      -- set forwaded id to departmentHeadId id if 5 CL in a year and approver is other than departmentHead

      IF EXISTS (SELECT 1 FROM [dbo].[LeaveRequestApplication] A WITH (NOLOCK)
                 INNER JOIN [dbo].[LeaveRequestApplicationDetail] D WITH (NOLOCK) ON A.[LeaveRequestApplicationId] = D.[LeaveRequestApplicationId]
				 INNER JOIN [dbo].[LeaveTypeMaster] M WITH (NOLOCK) ON D.[LeaveTypeId] = M.[TypeId] 								
			     WHERE 
                  A.[LeaveRequestApplicationId] = @LeaveRequestApplicationId 
                  AND M.[ShortName] = 'CL'
                  AND D.[Count] > 2
                  AND A.[ApproverId] != @DepartmentHeadId --4
                  AND A.[UserId] != @DepartmentHeadId --4 
                  AND @ForwardedId = 0
				  AND NOT EXISTS (SELECT 1 FROM [dbo].[LeaveHistory] LH 
				  WHERE LH.[LeaveRequestApplicationId] = A.[LeaveRequestApplicationId]
				  AND LH.ApproverId = @DepartmentHeadId)) --4
   BEGIN
      IF(@EmployeeId != @DepartmentHeadId AND @DepartmentHeadId != 0 AND (@UserId = @SecondReportingManagerId OR (@UserId = @FirstReportingManagerId AND @SecondReportingManagerId = 0)))
         SET @IsForwardToDepartmentHead = 1
      --SELECT @ForwardedId = @DepartmentHeadId--4
   END
      -- change status of leave ie UPDATE [LeaveRequestApplication] table
       UPDATE M
       SET M.[StatusId] = 
		   CASE
				WHEN @Status = 'PV' AND @ForwardedId > 0 THEN S1.[StatusId]
				WHEN @Status = 'PV' AND @UserId = @FirstReportingManagerId AND (@SecondReportingManagerId != 0 OR @SecondReportingManagerId != @HRId) AND @SecondReportingManagerId != 0 THEN S1.[StatusId]
				WHEN @Status = 'PV' AND @UserId = @FirstReportingManagerId AND (@SecondReportingManagerId = 0 OR @SecondReportingManagerId = @HRId) AND @IsForwardToDepartmentHead = 1 THEN S1.[StatusId]
				WHEN @Status = 'PV' AND @UserId = @FirstReportingManagerId AND (@SecondReportingManagerId = 0 OR @SecondReportingManagerId = @HRId) AND @IsForwardToDepartmentHead = 0 THEN S.[StatusId]
				WHEN @Status = 'PV' AND @UserId = @SecondReportingManagerId AND @IsForwardToDepartmentHead = 0 THEN S.[StatusId]
				WHEN @Status = 'PV' AND @UserId = @SecondReportingManagerId AND @DepartmentHeadId != @HRId AND @SecondReportingManagerId != @DepartmentHeadId AND @FirstReportingManagerId != @DepartmentHeadId 
									AND @IsForwardToDepartmentHead = 1 THEN S1.[StatusId]                        
				WHEN @Status = 'PV' AND @UserId = @DepartmentHeadId THEN S.[StatusId]
				
                      
			--WHEN @Status = 'PV' AND @UserId = @FirstReportingManagerId AND (@SecondReportingManagerId != 0 OR @SecondReportingManagerId != @HRId) THEN S1.[StatusId]-- pending for approval
			--WHEN @Status = 'PV' AND @UserId = @FirstReportingManagerId AND (@SecondReportingManagerId = 0 OR @SecondReportingManagerId = @HRId) AND @ForwardedId = 0 THEN S.[StatusId]
			--WHEN @Status = 'PV' AND @UserId = @SecondReportingManagerId AND @ForwardedId > 0 THEN S1.[StatusId]-- pending for approval
			--WHEN @Status = 'PV' AND @UserId = @SecondReportingManagerId AND @ForwardedId = 0 THEN S.[StatusId]
			--WHEN @Status = 'PV' AND @UserId NOT IN (@FirstReportingManagerId, @SecondReportingManagerId, @HRId) AND @ForwardedId = 0 AND @NoOfActionsOnRequest = 1 AND (@SecondReportingManagerId != 0 OR @SecondReportingManagerId != @HRId) THEN S1.[StatusId]
			--WHEN @Status = 'PV' AND @UserId NOT IN (@FirstReportingManagerId, @SecondReportingManagerId, @HRId) AND @ForwardedId = 0 AND @NoOfActionsOnRequest = 1 AND (@SecondReportingManagerId = 0 OR @SecondReportingManagerId = @HRId) THEN S.[StatusId]

				WHEN @Status = 'PV' AND @UserId NOT IN (@FirstReportingManagerId, @SecondReportingManagerId, @DepartmentHeadId, @HRId) AND 
				@NoOfActionsOnRequest = 1 AND (@SecondReportingManagerId != 0 OR @SecondReportingManagerId != @HRId) AND @SecondReportingManagerId != 0 THEN S1.[StatusId]
				WHEN @Status = 'PV' AND @UserId NOT IN (@FirstReportingManagerId, @SecondReportingManagerId, @DepartmentHeadId, @HRId) AND @NoOfActionsOnRequest = 1 AND
					(@SecondReportingManagerId = 0 OR @SecondReportingManagerId = @HRId) AND @IsForwardToDepartmentHead = 1 THEN S1.[StatusId]
				WHEN @Status = 'PV' AND @UserId NOT IN (@FirstReportingManagerId, @SecondReportingManagerId, @DepartmentHeadId, @HRId) AND @NoOfActionsOnRequest = 1 AND 
				(@SecondReportingManagerId = 0 OR @SecondReportingManagerId = @HRId) AND @IsForwardToDepartmentHead = 0 THEN S.[StatusId]
				WHEN @Status = 'PV' AND @UserId NOT IN (@FirstReportingManagerId, @SecondReportingManagerId, @DepartmentHeadId, @HRId) AND @NoOfActionsOnRequest = 2 AND @IsForwardToDepartmentHead = 1 THEN S1.[StatusId]
				WHEN @Status = 'PV' AND @UserId NOT IN (@FirstReportingManagerId, @SecondReportingManagerId, @DepartmentHeadId, @HRId) AND @NoOfActionsOnRequest = 2 THEN S.[StatusId]
                        
				--WHEN @Status = 'PV' AND @ForwardedId = 0 THEN S.[StatusId]
				--WHEN @Status = 'PV' AND @ForwardedId > 0 THEN S1.[StatusId] -- pending for approval                        
				ELSE S.[StatusId]
				END
           ,M.[ApproverRemarks] = @Remarks
           ,M.[ApproverId] = 
		   CASE
				WHEN @Status = 'PV' AND @ForwardedId > 0 THEN @ForwardedId
				WHEN @Status = 'PV' AND @UserId = @FirstReportingManagerId AND (@SecondReportingManagerId != 0 OR @SecondReportingManagerId != @HRId) AND
					 @SecondReportingManagerId != 0 THEN @SecondReportingManagerId -- pending for approval
				WHEN @Status = 'PV' AND @UserId = @FirstReportingManagerId AND (@SecondReportingManagerId = 0 OR @SecondReportingManagerId = @HRId) AND 
				@IsForwardToDepartmentHead = 1 THEN @DepartmentHeadId
				WHEN @Status = 'PV' AND @UserId = @FirstReportingManagerId AND (@SecondReportingManagerId = 0 OR @SecondReportingManagerId = @HRId) AND 
				@IsForwardToDepartmentHead = 0 THEN @HRId
				WHEN @Status = 'PV' AND @UserId = @SecondReportingManagerId AND @IsForwardToDepartmentHead = 0 THEN @HRId
				WHEN @Status = 'PV' AND @UserId = @SecondReportingManagerId AND @DepartmentHeadId != @HRId AND @SecondReportingManagerId != @DepartmentHeadId AND 
				@FirstReportingManagerId != @DepartmentHeadId AND @IsForwardToDepartmentHead = 1 THEN @DepartmentHeadId                           
				WHEN @Status = 'PV' AND @UserId = @DepartmentHeadId THEN @HRId
				WHEN @Status = 'PV' AND @ForwardedId > 0 THEN @ForwardedId

				--WHEN @Status = 'PV' AND @UserId = @FirstReportingManagerId AND (@SecondReportingManagerId != 0 OR @SecondReportingManagerId != @HRId) AND @ForwardedId = 0 THEN @SecondReportingManagerId -- pending for approval
				--WHEN @Status = 'PV' AND @UserId = @FirstReportingManagerId AND (@SecondReportingManagerId != 0 OR @SecondReportingManagerId != @HRId) AND @ForwardedId > 0 THEN @ForwardedId -- pending for approval
				--WHEN @Status = 'PV' AND @UserId = @FirstReportingManagerId AND (@SecondReportingManagerId = 0 OR @SecondReportingManagerId = @HRId) AND @ForwardedId = 0 THEN @HRId
				--WHEN @Status = 'PV' AND @UserId = @SecondReportingManagerId AND @ForwardedId > 0 THEN @ForwardedId-- pending for approval
				--WHEN @Status = 'PV' AND @UserId = @SecondReportingManagerId AND @ForwardedId = 0 THEN @HRId

				WHEN @Status = 'PV' AND @UserId NOT IN (@FirstReportingManagerId, @SecondReportingManagerId, @DepartmentHeadId, @HRId) AND @NoOfActionsOnRequest = 1 AND
					(@SecondReportingManagerId != 0 OR @SecondReportingManagerId != @HRId) AND @SecondReportingManagerId != 0 THEN @SecondReportingManagerId
				WHEN @Status = 'PV' AND @UserId NOT IN (@FirstReportingManagerId, @SecondReportingManagerId, @DepartmentHeadId, @HRId) AND @NoOfActionsOnRequest = 1 AND
					(@SecondReportingManagerId = 0 OR @SecondReportingManagerId = @HRId) AND @IsForwardToDepartmentHead = 1 THEN @DepartmentHeadId
				WHEN @Status = 'PV' AND @UserId NOT IN (@FirstReportingManagerId, @SecondReportingManagerId, @DepartmentHeadId, @HRId) AND @NoOfActionsOnRequest = 1 AND 
				(@SecondReportingManagerId = 0 OR @SecondReportingManagerId = @HRId) AND @IsForwardToDepartmentHead = 0 THEN @HRId
				WHEN @Status = 'PV' AND @UserId NOT IN (@FirstReportingManagerId, @SecondReportingManagerId, @DepartmentHeadId, @HRId) AND @NoOfActionsOnRequest = 2 AND
					@IsForwardToDepartmentHead = 1 THEN @DepartmentHeadId WHEN @Status = 'PV' AND 
					@UserId NOT IN (@FirstReportingManagerId, @SecondReportingManagerId, @DepartmentHeadId, @HRId) AND @NoOfActionsOnRequest = 2 AND @IsForwardToDepartmentHead = 0
					THEN @HRId
                           
				--WHEN @Status = 'PV' AND @ForwardedId = 0 THEN 2166
				--WHEN @Status = 'PV' AND @ForwardedId > 0 THEN @ForwardedId
				WHEN @Status = 'CA' THEN NULL
						ELSE M.[ApproverId]
				END
     ,M.[IsActive] = CASE WHEN @Status = 'CA' THEN 0 ELSE 1 END
      ,M.[IsDeleted] = CASE WHEN @Status = 'CA' THEN 1 ELSE 0 END
      ,M.[LastModifiedBy] = @UserId
      ,M.[LastModifiedDate] = GETDATE()
   FROM [dbo].[LeaveRequestApplication] M
   INNER JOIN [dbo].[LeaveStatusMaster] S WITH (NOLOCK) ON S.[StatusCode] = @Status
   INNER JOIN [dbo].[LeaveStatusMaster] S1 WITH (NOLOCK) ON S1.[StatusCode] = 'PA'
   
   WHERE M.[LeaveRequestApplicationId] = @LeaveRequestApplicationId
  
      IF (@Status = 'CA' OR @Status = 'RJ')
      BEGIN      
      INSERT INTO [dbo].[LeaveBalanceHistory]
      (
         [RecordId]
        ,[Count]
        ,[CreatedBy]
      )
		SELECT B.[RecordId],B.[Count],@UserId
		FROM [dbo].[LeaveBalance] B WITH (NOLOCK)
		INNER JOIN [dbo].[LeaveRequestApplication] A WITH (NOLOCK) ON A.[UserId] = B.[UserId]
		INNER JOIN [dbo].[LeaveRequestApplicationDetail] D WITH (NOLOCK) ON B.[LeaveTypeId] = D.[LeaveTypeId]
					AND A.[LeaveRequestApplicationId] = D.[LeaveRequestApplicationId]
		WHERE D.[LeaveRequestApplicationId] = @LeaveRequestApplicationId   
		      
  ----------------update RequestCompOffDetail table starts---------------------------------------

	    UPDATE RequestCompOffDetail SET IsActive=0, ModifiedDate=GETDATE(), ModifiedById=@UserId 
		            WHERE LeaveRequestApplicationId=@LeaveRequestApplicationId

  --------------update RequestCompOffDetail table ends-------------------------------------------

  ----------------update RequestCompOff table starts----------------------------------------------
       CREATE TABLE #TempCoffCount 
	   (
	   Id INT IDENTITY(1,1),
	   RequestId INT,
	   )
		   DECLARE @J INT = 1;
		   INSERT INTO #TempCoffCount
		   SELECT RequestId FROM RequestCompOffDetail WHERE LeaveRequestApplicationId=@LeaveRequestApplicationId
	   
		WHILE(@J <= (SELECT COUNT(Id) FROM #TempCoffCount))
		BEGIN
			UPDATE RequestCompOff SET IsAvailed=0 
			   WHERE RequestId=(SELECT RequestId FROM #TempCoffCount WHERE Id = @J)
			SET @J = @J + 1
		END
  --------------update RequestCompOff table ends---------------------------------------------------
	  UPDATE B
      SET B.[Count] = CASE
                        WHEN M.[ShortName] = 'LWP' OR M.[ShortName] = 'EL' THEN B.[Count] - D.[Count]
                        ELSE B.[Count] + D.[Count]
                      END
	  FROM [dbo].[LeaveBalance] B WITH (NOLOCK)
	  INNER JOIN [dbo].[LeaveRequestApplication] L WITH (NOLOCK) ON L.[UserId] = B.[UserId]
      INNER JOIN [dbo].[LeaveRequestApplicationDetail] D WITH (NOLOCK) ON B.[LeaveTypeId] = D.[LeaveTypeId] AND L.[LeaveRequestApplicationId] = D.[LeaveRequestApplicationId]
      INNER JOIN [dbo].[LeaveTypeMaster] M WITH (NOLOCK) ON M.[TypeId] = D.[LeaveTypeId]
      WHERE D.[LeaveRequestApplicationId] = @LeaveRequestApplicationId		
	   
			-- make 5 CL in a year available to user
			IF EXISTS (SELECT 1 FROM [dbo].[LeaveRequestApplicationDetail] D WITH (NOLOCK) 
							INNER JOIN [dbo].[LeaveTypeMaster] M WITH (NOLOCK) ON D.[LeaveTypeId] = M.[TypeId] 
							WHERE D.[LeaveRequestApplicationId] = @LeaveRequestApplicationId AND M.[ShortName] = 'CL' AND D.[Count] > 2 )
			BEGIN
				INSERT INTO [dbo].[LeaveBalanceHistory]
				(
				[RecordId]
				,[Count]
				,[CreatedBy]
				)
				SELECT B.[RecordId],B.[Count],@UserId
				FROM [dbo].[LeaveBalance] B WITH (NOLOCK)
				INNER JOIN [dbo].[LeaveRequestApplication] A WITH (NOLOCK) ON A.[UserId] = B.[UserId]
				INNER JOIN [dbo].[LeaveTypeMaster] M WITH (NOLOCK) ON B.[LeaveTypeId] = M.[TypeId] 
				WHERE M.[ShortName] = '5CLOY' AND A.[LeaveRequestApplicationId] = @LeaveRequestApplicationId
         
				UPDATE B
				SET B.[Count] = 1
				FROM [dbo].[LeaveBalance] B
				INNER JOIN [dbo].[LeaveRequestApplication] A WITH (NOLOCK) ON A.[UserId] = B.[UserId]
				INNER JOIN [dbo].[LeaveTypeMaster] M WITH (NOLOCK) ON B.[LeaveTypeId] = M.[TypeId] 
				WHERE M.[ShortName] = '5CLOY' AND A.[LeaveRequestApplicationId] = @LeaveRequestApplicationId
			END
      END

      SELECT 'SUCCEED' AS [Result]

      COMMIT TRANSACTION;
   END TRY
  BEGIN CATCH      
      ROLLBACK TRANSACTION
      DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
      EXEC [spInsertErrorLog]
	      @ModuleName = 'LeaveManagement'
         ,@Source = 'spTakeActionOnAppliedLeave'
         ,@ErrorMessage = @ErrorMessage
         ,@ErrorType = 'SP'
         ,@ReportedByUserId = @UserId

      SELECT 'FAILURE' AS [Result]
	 
   END CATCH
END

GO
