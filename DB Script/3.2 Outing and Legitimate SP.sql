GO
/****** Object:  StoredProcedure [dbo].[spGetUserAppliedWorkFromHome]    Script Date: 2/5/18 12:29:09 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetUserAppliedWorkFromHome]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetUserAppliedWorkFromHome]
GO
/****** Object:  StoredProcedure [dbo].[spGetUserAppliedLeave]    Script Date: 2/5/18 12:29:09 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetUserAppliedLeave]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetUserAppliedLeave]
GO
/****** Object:  StoredProcedure [dbo].[spGetUserAppliedDataChangeRequest]    Script Date: 2/5/18 12:29:09 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetUserAppliedDataChangeRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetUserAppliedDataChangeRequest]
GO
/****** Object:  StoredProcedure [dbo].[spGetUserAppliedCompOff]    Script Date: 2/5/18 12:29:09 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetUserAppliedCompOff]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetUserAppliedCompOff]
GO
/****** Object:  StoredProcedure [dbo].[spGetApproverRemarks]    Script Date: 2/5/18 12:29:09 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetApproverRemarks]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetApproverRemarks]
GO
/****** Object:  StoredProcedure [dbo].[Proc_UserAppliedLegitimateLeave]    Script Date: 2/5/18 12:29:09 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_UserAppliedLegitimateLeave]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_UserAppliedLegitimateLeave]
GO
/****** Object:  StoredProcedure [dbo].[Proc_TakeActionOnOutingRequest]    Script Date: 2/5/18 12:29:09 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TakeActionOnOutingRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TakeActionOnOutingRequest]
GO
/****** Object:  StoredProcedure [dbo].[Proc_TakeActionOnLegitimateLeave]    Script Date: 2/5/18 12:29:09 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TakeActionOnLegitimateLeave]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TakeActionOnLegitimateLeave]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetOutingReviewRequest]    Script Date: 2/5/18 12:29:09 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetOutingReviewRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetOutingReviewRequest]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetOutingRequestByUserId]    Script Date: 2/5/18 12:29:09 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetOutingRequestByUserId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetOutingRequestByUserId]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetLegitimateLeave]    Script Date: 2/5/18 12:29:09 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetLegitimateLeave]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetLegitimateLeave]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetEmpInformationForLegitimateLeave]    Script Date: 2/5/18 12:29:09 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetEmpInformationForLegitimateLeave]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetEmpInformationForLegitimateLeave]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetEmpInformation]    Script Date: 2/5/18 12:29:09 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetEmpInformation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetEmpInformation]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetDateToCancelOutingRequest]    Script Date: 2/5/18 12:29:09 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetDateToCancelOutingRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetDateToCancelOutingRequest]
GO
/****** Object:  StoredProcedure [dbo].[Proc_ApplyOutingRequest]    Script Date: 2/5/18 12:29:09 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_ApplyOutingRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_ApplyOutingRequest]
GO
/****** Object:  StoredProcedure [dbo].[Proc_ApplyLegitimateLeave]    Script Date: 2/5/18 12:29:09 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_ApplyLegitimateLeave]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_ApplyLegitimateLeave]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SelectTempCardDetailsForMIS]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SelectTempCardDetailsForMIS]
GO

/****** Object:  UserDefinedFunction [dbo].[Fun_GetUserMonthYear]    Script Date: 2/5/18 12:29:09 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetUserMonthYear]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GetUserMonthYear]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_GetUserMonthYear]    Script Date: 2/5/18 12:29:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetUserMonthYear]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/***
   Created Date      :     17-4-2018
   Created By        :     Mimansa Agrawal
   Purpose           :     This function return user''s working month and year
   Usage			 :	   SELECT * FROM [dbo].[Fun_GetUserMonthYear](1108)
   --------------------------------------------------------------------------
***/
CREATE FUNCTION [dbo].[Fun_GetUserMonthYear]
(
	@UserId int
)
RETURNS @DateTable TABLE (
		[Year] INT,
		[Month] INT,
		[MonthName] VARCHAR(15),
		[MonthYear] VARCHAR(15)
	)
AS BEGIN
    DECLARE @StartDate [Date] = (SELECT [JoiningDate] FROM [dbo].[UserDetail] WHERE [UserId] = @UserId)

	INSERT INTO @DateTable ([Year], [Month], [MonthName], [MonthYear])
	SELECT DISTINCT
		DATEPART(YY,[Date]) as [Year],
		DATEPART(MM,[Date]) as [Month],
		DATENAME(MONTH,[Date]) as [MonthName],
		CAST(DATENAME(MONTH,[Date])  AS VARCHAR(15)) + '' '' + CAST(DATEPART(YY,[Date]) AS VARCHAR(5))  as [MonthYear]
	FROM [dbo].[DateMaster] D
	WHERE [Date] BETWEEN @StartDate AND GETDATE()
	ORDER BY [Year] DESC, [Month] DESC

	RETURN
END' 
END

GO
/****** Object:  StoredProcedure [dbo].[Proc_ApplyLegitimateLeave]    Script Date: 2/5/18 12:29:09 PM ******/
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
             @EmployeeId = 1108
            ,@LoginUserId = 1108
            ,@FromDate = '2018-04-26'
            ,@Reason = 'new proc testing'
            ,@LeaveCombination= '1 PL'
			,@LeaveId=8714
			,@IsValid=1
***/
 ALTER PROCEDURE [dbo].[Proc_ApplyLegitimateLeave]
   (
       @EmployeeId [int]
      ,@LoginUserId [int]
      ,@FromDate [date]
      ,@LeaveCombination [varchar](100)
	  ,@Reason [varchar](500)
	  ,@LeaveId [int]
	  ,@IsValid [bit]
   )
   AS
      SET NOCOUNT ON;  
      SET FMTONLY OFF;
     
   BEGIN TRY
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
					EXEC spGetAvailableLeaveCombination @NoOfWorkingDays =1, @UserId = @EmployeeId, @LeaveApplicationId = 0
					IF((SELECT COUNT(*) FROM #TempLeaveCombination) > 0)
					BEGIN
						IF((SELECT COUNT(*) from #TempLeaveCombination WHERE [LeaveCombination] = @LeaveCombination) > 0)
						BEGIN
						  BEGIN TRANSACTION
                     
							 DECLARE @FromDateId Bigint
						         SET @FromDateId=  ( SELECT DateId FROM  [dbo].[DateMaster]  WITH (NOLOCK) WHERE [Date]=@FromDate)
                                 DECLARE @ApproverId int ,@StatusId int = 1
									  ,@ReportingManagerId int = (SELECT [dbo].[fnGetReportingManagerByUserId](@EmployeeId))
									  ,@HRId int = (SELECT [dbo].[fnGetHRIdByUserId](@EmployeeId));
										SET @ApproverId = @ReportingManagerId
								
								IF(@ReportingManagerId = 0 OR @ReportingManagerId = @HRId)
								BEGIN
								   SET @ApproverId = @HRId;
								   SET @StatusId = (SELECT [StatusId] FROM [dbo].[LegitimateLeaveStatus] WHERE [StatusCode] = 'PV')
								END
								ELSE
								BEGIN
									SET @StatusId=(SELECT [StatusId] FROM [dbo].[LegitimateLeaveStatus] WHERE [StatusCode] = 'PA')
								END
---------------------------------------Insert into LegitimateLeaveRequest starts---------------------------------------
									IF(@IsValid=1)
									BEGIN
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
	---------------------------------------Insert into LeaveBalanceHistory/update LeaveBalance----------------------------------
											 DECLARE @Id VARCHAR(10),@Msg VARCHAR(20)
		
											 SET @Id=(SELECT [Character] FROM [dbo].[fnSplitWord](@LeaveCombination, ' ') where Id=2)
											 
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
                     
									 DROP TABLE #TempLeaveDetail
									 DROP TABLE #Combination
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
      END TRY
      BEGIN CATCH
	  IF @@TRANCOUNT>0
	  BEGIN
         ROLLBACK TRANSACTION;
         SELECT 0 AS [Result]
         DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))

         EXEC [spInsertErrorLog]
	          @ModuleName = 'LeaveManagement'
            ,@Source = 'Proc_ApplyLegitimateLeave'
            ,@ErrorMessage = @ErrorMessage
            ,@ErrorType = 'SP'
            ,@ReportedByUserId = @EmployeeId        
		  END
      END CATCH
GO
/****** Object:  StoredProcedure [dbo].[Proc_ApplyOutingRequest]    Script Date: 2/5/18 12:29:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_ApplyOutingRequest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_ApplyOutingRequest] AS' 
END
GO


/***
Created Date      :     2018-03-21
Created By        :     Kanchan Kumari
Purpose           :     This stored procedure is used to apply outing request
Change History    :
--------------------------------------------------------------------------
Modify Date       Edited By            Change Description
--------------------------------------------------------------------------
--------------------------------------------------------------------------
Test Cases        :
--------------------------------------------------------------------------
--- Test Case 1
DECLARE @Result int 
EXEC [dbo].[Proc_ApplyOutingRequest]
@EmployeeId = 2432
,@FromDate = '2018-02-9'
,@TillDate = '2018-02-16'
,@Reason = 'Testing by Kanchan'
,@OutingTypeId = 1
,@LoginUserId = 2432
,@PrimaryContactNo = '8800349797'
,@OtherContactNo = '8800349797'
,@Success = @Result output
SELECT @Result AS [RESULT]
***/
ALTER PROCEDURE [dbo].[Proc_ApplyOutingRequest] 
(
	@EmployeeId  INT,
	@FromDate DATE,
	@TillDate DATE,
	@Reason VARCHAR(500),
	@OutingTypeId int,
	@LoginUserId int,
	@PrimaryContactNo varchar(15),
	@OtherContactNo varchar(15),
	@Success tinyint = 0 output
)
AS
BEGIN TRY   
BEGIN TRAN 
	DECLARE @FromDateId BIGINT, @TillDateId BIGINT, @ReportingManagerId INT
	SET @ReportingManagerId = (SELECT [dbo].[fnGetReportingManagerByUserId](@EmployeeId)) 
	SELECT @FromDateId = MIN(DM.[DateId])
		  ,@TillDateId = MAX(DM.[DateId])
	FROM [dbo].[DateMaster] DM WITH (NOLOCK)
	WHERE DM.[Date] BETWEEN  @FromDate AND  @TillDate
	
	    IF OBJECT_ID('tempdb..#TempDateId') IS NOT NULL
	          DROP TABLE #TempDateId
	    CREATE TABLE #TempDateId
		(
			TempDateId INT
		)
		WHILE (@FromDateId <=@TillDateId)
		BEGIN
				INSERT INTO #TempDateId(TempDateId) VALUES(@FromDateId)
				SET @FromDateId = @FromDateId +1;
		END
		IF EXISTS(SELECT 1 FROM [dbo].[OutingRequestDetail]
			  WHERE [CreatedById] = @EmployeeId
			  AND [StatusId] <=5
			  AND (DateId IN (SELECT TempDateId FROM #TempDateId))
			  )	  
	BEGIN
		SET @Success = 1 --Already exists
	END
	ELSE
	BEGIN				
		SELECT 
		 @FromDateId = MIN(DM.[DateId])
		,@TillDateId = MAX(DM.[DateId])
		FROM [dbo].[DateMaster] DM WITH (NOLOCK)
		WHERE DM.[Date] BETWEEN  @FromDate AND  @TillDate
	
		INSERT INTO [dbo].[OutingRequest]([OutingTypeId], [UserId], [FromDateId], [TillDateId], [Reason], 
											  [PrimaryContactNo], [AlternativeContactNo], [NextApproverId], [CreatedById])
		VALUES(@OutingTypeId,@EmployeeId,@FromDateId,@TillDateId, @Reason, @PrimaryContactNo, @OtherContactNo, @ReportingManagerId,@LoginUserId)

		DECLARE @OutingRequestId BIGINT
		SET @OutingRequestId = SCOPE_IDENTITY()
		
		--insert into OutingRequestHistory table 
		INSERT INTO [dbo].[OutingRequestHistory]([OutingRequestId], [Remarks], [CreatedById])
		VALUES (@OutingRequestId, 'Applied', @LoginUserId)

		--insert into OutingRequestDetail
		 WHILE (@FromDateId <= @TillDateId)
			BEGIN
				INSERT INTO [dbo].[OutingRequestDetail]([OutingRequestId],[DateId], [CreatedById])
				VALUES(@OutingRequestId,@FromDateId,@EmployeeId)
				Set @FromDateId = @FromDateId + 1
			END 

		SET @Success = 2 --successfully applied
	END
	COMMIT;
END TRY	
BEGIN CATCH
   --On Error
   IF @@TRANCOUNT > 0
   BEGIN
     SET @Success = 0; -- Error occurred
	 ROLLBACK TRANSACTION;
	 
	 DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
	 --Log Error
	 EXEC [spInsertErrorLog]
			 @ModuleName = 'Outing Request'
			,@Source = 'Proc_ApplyOutingRequest'
			,@ErrorMessage = @ErrorMessage
			,@ErrorType = 'SP'
			,@ReportedByUserId = @LoginUserId
   END
END CATCH



GO
/****** Object:  StoredProcedure [dbo].[Proc_GetDateToCancelOutingRequest]    Script Date: 2/5/18 12:29:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetDateToCancelOutingRequest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetDateToCancelOutingRequest] AS' 
END
GO
--Created Date      :     2018-03-21
--Created By        :     Kanchan Kumari
--Purpose           :     This stored procedure is used to get outing date
--Usage				:	  Proc_GetDateToCancelOutingRequest @OutingRequestId=101
---------------------------------------------------------------
ALTER PROC [dbo].[Proc_GetDateToCancelOutingRequest]
	@OutingRequestId BIGINT
AS
BEGIN
	SELECT OD.OutingRequestDetailId AS [OutingRequestDetailId], DM.[Date] AS [OutingDate],OD.StatusId AS [StatusId],OS.[Status] AS [Status], OS.StatusCode AS [StatusCode] 
	FROM OutingRequestDetail OD
	INNER JOIN DateMaster DM WITH(NOLOCK) ON DM.DateId=OD.DateId
	INNER JOIN OutingRequestStatus OS WITH (NOLOCK) ON OS.StatusId=OD.StatusId
	WHERE OD.OutingRequestId=@OutingRequestId
END
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetEmpInformation]    Script Date: 2/5/18 12:29:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetEmpInformation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetEmpInformation] AS' 
END
GO

/***
   Created Date      :     2018-04-11
   Created By        :     Kanchan Kumari
   Purpose           :     This stored proc return emailId, name of applicant and approver and leave period 
   Usage             :     EXEC [dbo].[Proc_GetEmpInformation] @OutingRequestId = 21, @LoginUserId = 1108
***/
ALTER PROC [dbo].[Proc_GetEmpInformation]
	@OutingRequestId int,
	@LoginUserId int
AS
BEGIN
	SELECT LTRIM(RTRIM(U.FirstName))+' '+LTRIM(RTRIM(U.MiddleName))+' ' +LTRIM(RTRIM(U.LastName)) AS [ApplicantFullName],
		   U.EmailId AS [ApplicantEmailId], U.FirstName AS [ApplicantFirstName],
		   LTRIM(RTRIM(UD.FirstName))+' '+LTRIM(RTRIM(UD.MiddleName))+' ' +LTRIM(RTRIM(UD.LastName)) AS [ApproverFullName], 
		   UD.EmailId AS [ApproverEmailId], UD.FirstName AS [ApproverFirstName],
		   CONVERT(VARCHAR(20),DM1.[Date],106) AS [FromDate], CONVERT(VARCHAR(20),DM2.[Date],106) AS [TillDate] 
	From UserDetail U INNER JOIN OutingRequest R ON U.UserId=R.UserId 
	INNER JOIN UserDetail UD ON UD.UserId=@LoginUserId 
	INNER JOIN DateMaster DM1 ON DM1.DateId=R.FromDateId
	INNER JOIN DateMaster DM2 ON DM2.DateId=R.TillDateId
	where R.OutingRequestId=@OutingRequestId
END

GO
/****** Object:  StoredProcedure [dbo].[Proc_GetEmpInformationForLegitimateLeave]    Script Date: 2/5/18 12:29:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetEmpInformationForLegitimateLeave]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetEmpInformationForLegitimateLeave] AS' 
END
GO
/***
   Created Date      :     2018-05-01
   Created By        :     Kanchan Kumari
   Purpose           :     This stored proc return emailId, name of applicant and approver and leave period
   Change History    :
	--------------------------------------------------------------------------
	Modify Date       Edited By            Change Description
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	Test Cases        :
	--------------------------------------------------------------------------
    EXEC [dbo].[Proc_GetEmpInformationForLegitimateLeave] @RequestId = 31, @LoginUserId = 24
***/
ALTER PROC [dbo].[Proc_GetEmpInformationForLegitimateLeave]
	@RequestId int,
	@LoginUserId int
AS
BEGIN
	SELECT LTRIM(RTRIM(U.FirstName))+' '+LTRIM(RTRIM(U.MiddleName))+' ' +LTRIM(RTRIM(U.LastName)) AS [ApplicantFullName],
		   U.EmailId AS [ApplicantEmailId], U.FirstName AS [ApplicantFirstName],
		   LTRIM(RTRIM(UD.FirstName))+' '+LTRIM(RTRIM(UD.MiddleName))+' ' +LTRIM(RTRIM(UD.LastName)) AS [ApproverFullName], 
		   UD.EmailId AS [ApproverEmailId], UD.FirstName AS [ApproverFirstName],
		   CONVERT(VARCHAR(20),DM.[Date],106) AS [FromDate]
	From UserDetail U INNER JOIN LegitimateLeaveRequest R ON U.UserId=R.UserId 
	INNER JOIN UserDetail UD ON UD.UserId=@LoginUserId 
	INNER JOIN DateMaster DM ON DM.DateId=R.DateId
	
	where R.LegitimateLeaveRequestId=@RequestId
END

GO
/****** Object:  StoredProcedure [dbo].[Proc_GetLegitimateLeave]    Script Date: 2/5/18 12:29:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetLegitimateLeave]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetLegitimateLeave] AS' 
END
GO

/***
	Created Date      :     2018-05-1
	Created By        :     Kanchan Kumari
	Purpose           :     This stored procedure Get leave Deatils According to User status 
	Change History    :
	--------------------------------------------------------------------------
	Modify Date       Edited By            Change Description
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	Test Cases        :
	--------------------------------------------------------------------------
	EXEC [dbo].[Proc_GetLegitimateLeave] @UserId = 24
***/

ALTER PROCEDURE [dbo].[Proc_GetLegitimateLeave] 
   @UserId [int]
AS
BEGIN
	SET NOCOUNT ON;
    SET FMTONLY OFF;
	DECLARE @AdminId int = 1;

IF OBJECT_ID('tempdb..#TempDataNew') IS NOT NULL
	DROP TABLE #TempDataNew

	CREATE TABLE #TempDataNew
	(
		[RequestId] INT,
		[EmployeeName] VARCHAR(100),
		[Date] VARCHAR(100),
		[Reason] VARCHAR(500),
		[ApplyDate] VARCHAR(20),
		[Status] VARCHAR(100),
		[LeaveInfo] VARCHAR(20),
		[Remarks] varchar(500),
		[StatusCode] VARCHAR(10)
	)

	--Fetch pending request
		INSERT INTO #TempDataNew([RequestId], [EmployeeName], [Date], [Reason], [ApplyDate], [Status],[LeaveInfo],[Remarks],[StatusCode])
		--Pending request
			SELECT  LR.LegitimateLeaveRequestId AS [RequestId],
				UD.[FirstName] + ' ' + UD.[LastName] AS [EmployeeName],
				CONVERT(VARCHAR(20),DM.[Date] ,106) AS [Date],
				LR.[Reason] AS [Reason],
				CONVERT(VARCHAR(20), LR.CreatedDate,106) + ' ' + FORMAT(LR.CreatedDate,'hh:mm tt') AS [ApplyDate],
				(CASE WHEN S.StatusCode='PA' OR S.StatusCode='PV' THEN
				S.[Status]+' with '+ UDT.FirstName+' '+ UDT.LastName END) AS [Status],
				LR.LeaveCombination AS [LeaveInfo],
				APR.FirstName + ' ' + APR.LastName + ': ' +  REM.[Remarks] AS [Remarks],
				S.StatusCode AS [StatusCode]
			FROM LegitimateLeaveRequest LR 
			INNER JOIN  UserDetail UD WITH (NOLOCK) ON UD.UserId=LR.UserId 
			LEFT JOIN UserDetail UDT WITH (NOLOCK) ON UDT.UserId=LR.NextApproverId
			INNER JOIN  DateMaster DM WITH (NOLOCK) ON LR.DateId=DM.DateId   
			INNER JOIN LegitimateLeaveStatus S WITH (NOLOCK) ON LR.StatusId=S.StatusId
			JOIN (SELECT LegitimateLeaveRequestId, MAX(LegitimateLeaveRequestHistoryId) AS LegitimateLeaveRequestHistoryId FROM LegitimateLeaveRequestHistory GROUP BY LegitimateLeaveRequestId) ORH
				ON LR.LegitimateLeaveRequestId=ORH.LegitimateLeaveRequestId 
			INNER JOIN LegitimateLeaveRequestHistory REM WITH (NOLOCK) ON ORH.LegitimateLeaveRequestHistoryId=REM.LegitimateLeaveRequestHistoryId
			INNER JOIN UserDetail APR WITH (NOLOCK) ON REM.CreatedBy=APR.UserId
			WHERE LR.NextApproverId=@UserId 	
		
			UNION ALL

			SELECT  LR.LegitimateLeaveRequestId AS [RequestId],
				UD.[FirstName] + ' ' + UD.[LastName] AS [EmployeeName],
				CONVERT(VARCHAR(20),DM.[Date] ,106) AS [Date],
				LR.[Reason] AS [Reason],
				CONVERT(VARCHAR(20), LR.CreatedDate,106) + ' ' + FORMAT(LR.CreatedDate,'hh:mm tt') AS [ApplyDate],
				(CASE WHEN S.StatusCode='PA' OR S.StatusCode='PV' THEN S.[Status]+' with '+ UDT.FirstName+' '+ UDT.LastName END) AS [Status],
				LR.LeaveCombination AS [LeaveInfo],
				APR.FirstName + ' ' + APR.LastName + ': ' +  REM.[Remarks] AS [Remarks],
				SC.StatusCode AS [StatusCode]
				
				FROM LegitimateLeaveRequest LR 
			INNER JOIN  UserDetail UD WITH (NOLOCK) ON UD.UserId=LR.UserId 
			LEFT JOIN UserDetail UDT WITH (NOLOCK) ON UDT.UserId=LR.NextApproverId
			INNER JOIN  DateMaster DM WITH (NOLOCK) ON LR.DateId=DM.DateId   
			JOIN (SELECT LegitimateLeaveRequestId, MAX(LegitimateLeaveRequestHistoryId) AS LegitimateLeaveRequestHistoryId FROM LegitimateLeaveRequestHistory GROUP BY LegitimateLeaveRequestId) ORH
				ON LR.LegitimateLeaveRequestId=ORH.LegitimateLeaveRequestId 
			INNER JOIN LegitimateLeaveRequestHistory REM WITH (NOLOCK) ON ORH.LegitimateLeaveRequestHistoryId=REM.LegitimateLeaveRequestHistoryId
			INNER JOIN UserDetail APR WITH (NOLOCK) ON REM.CreatedBy=APR.UserId
			JOIN (SELECT LegitimateLeaveRequestId, MAX(StatusId) AS StatusId, MAX(CreatedDate) AS CreatedDate FROM LegitimateLeaveRequestHistory WITH (NOLOCK)  WHERE CreatedBy=@UserId
			 GROUP BY LegitimateLeaveRequestId ) ACT
				ON ACT.LegitimateLeaveRequestId=LR.LegitimateLeaveRequestId
				INNER JOIN LegitimateLeaveStatus SC ON SC.StatusId=ACT.StatusId
				INNER JOIN LegitimateLeaveStatus S ON S.StatusId=LR.StatusId
			WHERE (ACT.StatusId<>1) AND LR.StatusId<=3 	

			UNION
			
				SELECT  LR.LegitimateLeaveRequestId AS [RequestId],
				UD.[FirstName] + ' ' + UD.[LastName] AS [EmployeeName],
				CONVERT(VARCHAR(20),DM.[Date] ,106) AS [Date],
				LR.[Reason] AS [Reason],
				CONVERT(VARCHAR(20), LR.CreatedDate,106) + ' ' + FORMAT(LR.CreatedDate,'hh:mm tt') AS [ApplyDate],
				S.[Status] +' by '+  UDTV.FirstName+' '+ UDTV.LastName  AS [Status],
				LR.LeaveCombination AS [LeaveInfo],
				APR.FirstName + ' ' + APR.LastName + ': ' +  REM.[Remarks] AS [Remarks],
				S.StatusCode AS [StatusCode]
				
				FROM LegitimateLeaveRequest LR 
			INNER JOIN  UserDetail UD WITH (NOLOCK) ON UD.UserId=LR.UserId 
			LEFT JOIN UserDetail UDT WITH (NOLOCK) ON UDT.UserId=LR.NextApproverId
			INNER JOIN  DateMaster DM WITH (NOLOCK) ON LR.DateId=DM.DateId   
			JOIN (SELECT LegitimateLeaveRequestId, MAX(LegitimateLeaveRequestHistoryId) AS LegitimateLeaveRequestHistoryId FROM LegitimateLeaveRequestHistory GROUP BY LegitimateLeaveRequestId) ORH
				ON LR.LegitimateLeaveRequestId=ORH.LegitimateLeaveRequestId 
			INNER JOIN LegitimateLeaveRequestHistory REM WITH (NOLOCK) ON ORH.LegitimateLeaveRequestHistoryId=REM.LegitimateLeaveRequestHistoryId
			INNER JOIN UserDetail APR WITH (NOLOCK) ON REM.CreatedBy=APR.UserId
			JOIN (SELECT LegitimateLeaveRequestId, MAX(StatusId) AS StatusId, MAX(CreatedDate) AS CreatedDate FROM LegitimateLeaveRequestHistory WITH (NOLOCK)  WHERE CreatedBy=@UserId
			 GROUP BY LegitimateLeaveRequestId ) ACT
				ON ACT.LegitimateLeaveRequestId=LR.LegitimateLeaveRequestId
			INNER JOIN LegitimateLeaveStatus SC WITH (NOLOCK) ON ACT.StatusId=SC.StatusId
			INNER JOIN LegitimateLeaveStatus S WITH (NOLOCK) ON LR.StatusId=S.StatusId
			INNER JOIN UserDetail UDTV WITH (NOLOCK) ON (UDTV.UserId=LR.LastModifiedBy)
			WHERE (ACT.StatusId<>1)	AND LR.StatusId>=5 
		
	SELECT [RequestId], [EmployeeName], [Date], [Reason], [ApplyDate], [Status],[LeaveInfo],[Remarks], [StatusCode]
	FROM #TempDataNew

	END
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetOutingRequestByUserId]    Script Date: 2/5/18 12:29:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetOutingRequestByUserId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetOutingRequestByUserId] AS' 
END
GO

--Created Date      : 2018-03-21
--Created By        : Kanchan Kumari
--Purpose           : This stored procedure is used to view outing request status
--Usage				: EXEC [Proc_GetOutingRequestByUserId] 2432,2018
----------------------------------------------------------------------------
ALTER PROCEDURE [dbo].[Proc_GetOutingRequestByUserId] 
   @EmployeeId [int],
   @Year [int]=NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @StartDate [date], @EndDate [date],@JoiningDate [date]
	 
	IF (@Year IS NULL OR @Year =0)
	SET @Year = DATEPART(YYYY, GETDATE())

	SELECT @StartDate=dateadd(Month,0,cast(concat(@Year,'-04-01') as date))  ,
		  @EndDate = dateadd(Year,1,cast(concat(@Year,'-03-31') as date)) ,
		  @JoiningDate= JoiningDate FROM UserDetail WHERE UserId=@EmployeeId
		 IF(DATEPART(YYYY,@JoiningDate)=DATEPART(YYYY, @StartDate) AND DATEPART(mm,@JoiningDate)<DATEPART(mm,@StartDate))
		  SELECT @StartDate=@JoiningDate
	
	SELECT 
		R.[OutingRequestId] AS [OutingRequestId]
		,CASE WHEN R.FromDateId=R.TillDateId THEN CAST(CONVERT(VARCHAR(20),DM1.[Date],106) AS Varchar(20)) 
			ELSE  CAST(CONVERT(VARCHAR(20),DM1.[Date],106) AS Varchar(20)) + '  To  ' + CAST(CONVERT(VARCHAR(20),DM2.[Date],106) AS Varchar(20) )
		 END AS [Period],
		 DM1.[Date] AS [FromDate]
		 ,DM2.[Date] AS [TillDate]
      ,T.[OutingTypeName] AS [OutingType]
	  ,R.[Reason] AS [Reason]	  
	  ,S.[StatusCode] AS [StatusCode]
	  ,S.[Status] + ' with ' + UD.[FirstName] + ' ' + UD.[LastName] AS [Status]
	  ,APR.FirstName + ' ' + APR.LastName + ': ' +  REM.[Remarks] AS [Remarks]                                                                                                                 
	  ,CONVERT(VARCHAR(20), R.CreatedDate,106) + ' ' + FORMAT(R.CreatedDate,'hh:mm tt') AS [ApplyDate]
	FROM [dbo].[OutingRequest] R WITH (NOLOCK)
	INNER JOIN [dbo].[OutingRequestStatus] S WITH (NOLOCK) ON R.[StatusId] = S.StatusId
	INNER JOIN [dbo].[OutingType] T WITH (NOLOCK) ON R.[OutingTypeId] = T.[OutingTypeId]
	INNER JOIN [dbo].[DateMaster] DM1 WITH (NOLOCK) ON R.[FromDateId] = DM1.DateId
	INNER JOIN [dbo].[DateMaster] DM2 WITH (NOLOCK) ON R.[TillDateId] = DM2.[DateId]
	INNER JOIN [dbo].[UserDetail] UD WITH (NOLOCK) ON R.[NextApproverId] = UD.[UserId] 
	INNER JOIN (SELECT OutingRequestId, MAX(OutingRequestHistoryId) AS OutingRequestHistoryId FROM OutingRequestHistory GROUP BY OutingRequestId) ORH
			ON R.OutingRequestId=ORH.OutingRequestId	
	INNER JOIN [dbo].[OutingRequestHistory] REM WITH (NOLOCK) ON ORH.OutingRequestHistoryId=REM.OutingRequestHistoryId
	INNER JOIN [dbo].[UserDetail] APR WITH (NOLOCK) ON REM.CreatedById=APR.UserId 
	WHERE R.[UserId] = @EmployeeId AND R.CreatedDate BETWEEN @StartDate AND @EndDate

	UNION

	SELECT 
		R.[OutingRequestId] AS [OutingRequestId]
		,CASE WHEN R.FromDateId=R.TillDateId THEN CAST(CONVERT(VARCHAR(20),DM1.[Date],106) AS Varchar(20)) 
			ELSE  CAST(CONVERT(VARCHAR(20),DM1.[Date],106) AS Varchar(20)) + '  To  ' + CAST(CONVERT(VARCHAR(20),DM2.[Date],106) AS Varchar(20) )
		 END AS [Period],
		 DM1.[Date] AS [FromDate]
		 ,DM2.[Date] AS [TillDate]
      ,T.[OutingTypeName] AS [OutingType]
	  ,R.[Reason] AS [Reason]	
	  ,S.[StatusCode] AS [StatusCode]  
	  ,S.[Status] + ' by ' + UD.[FirstName] + ' ' + UD.[LastName] AS [Status]
	  ,APR.FirstName + ' ' + APR.LastName + ': ' +  REM.[Remarks] AS [Remarks]                                                                                                                 
	  ,CONVERT(VARCHAR(20), R.CreatedDate,106) + ' ' + FORMAT(R.CreatedDate,'hh:mm tt') AS [ApplyDate]
	FROM [dbo].[OutingRequest] R WITH (NOLOCK)
	INNER JOIN [dbo].[OutingRequestStatus] S WITH (NOLOCK) ON R.[StatusId] = S.StatusId
	INNER JOIN [dbo].[OutingType] T WITH (NOLOCK) ON R.[OutingTypeId] = T.[OutingTypeId]
	INNER JOIN [dbo].[DateMaster] DM1 WITH (NOLOCK) ON R.[FromDateId] = DM1.DateId
	INNER JOIN [dbo].[DateMaster] DM2 WITH (NOLOCK) ON R.[TillDateId] = DM2.[DateId]
	INNER JOIN [dbo].[UserDetail] UD WITH (NOLOCK) ON R.[ModifiedById] = UD.[UserId] 
	INNER JOIN (SELECT OutingRequestId, MAX(OutingRequestHistoryId) AS OutingRequestHistoryId FROM OutingRequestHistory GROUP BY OutingRequestId) ORH
			ON R.OutingRequestId=ORH.OutingRequestId	
	INNER JOIN [dbo].[OutingRequestHistory] REM WITH (NOLOCK) ON ORH.OutingRequestHistoryId=REM.OutingRequestHistoryId
	INNER JOIN [dbo].[UserDetail] APR WITH (NOLOCK) ON REM.CreatedById=APR.UserId 
	WHERE R.[UserId] = @EmployeeId  AND R.StatusId>=5 AND R.CreatedDate BETWEEN @StartDate AND @EndDate
END

GO
/****** Object:  StoredProcedure [dbo].[Proc_GetOutingReviewRequest]    Script Date: 2/5/18 12:29:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetOutingReviewRequest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetOutingReviewRequest] AS' 
END
GO

----------------------------------------------------------------------------
--Created Date      : 2018-03-21
--Created By        : Kanchan Kumari
--Purpose           : This stored procedure is used to apply outing request
--Usage				: EXEC [Proc_GetOutingReviewRequest] 1108
----------------------------------------------------------------------------
--DECLARE @LoginUserId [INT] = 2166
ALTER PROC [dbo].[Proc_GetOutingReviewRequest]
@LoginUserId [INT]
AS
BEGIN
	SET NOCOUNT ON;
	SET FMTONLY OFF;
	
	IF OBJECT_ID('tempdb..#TempDataNew') IS NOT NULL
	DROP TABLE #TempDataNew

	CREATE TABLE #TempDataNew
	(
		[OutingRequestId] INT,
		[EmployeeName] VARCHAR(100),
		[Period] VARCHAR(100),
		[Reason] VARCHAR(500),
		[ApplyDate] VARCHAR(20),
		[Status] VARCHAR(100),
		[DutyType] VARCHAR(20),
		[Remarks] varchar(500),
		[StatusCode] VARCHAR(10)
	)

	DECLARE @IsHR BIT=0
	SELECT @IsHR = 1 FROM UserDetail UD WITH (NOLOCK) 
				 JOIN Designation D ON UD.DesignationId=D.DesignationId 
				 JOIN DesignationGroup DG WITH (NOLOCK) ON D.DesignationGroupId = DG.DesignationGroupId 
				 WHERE UD.[UserId]=@LoginUserId AND DG.DesignationGroupId=5 --5: Human Resource
			
	--Fetch pending request
		INSERT INTO #TempDataNew([OutingRequestId], [EmployeeName], [Period], [Reason], [ApplyDate], [Status],[DutyType],[Remarks],[StatusCode])
		--Pending request
			SELECT  R.OutingRequestId AS [OutingRequestId],
				UD.[FirstName] + ' ' + UD.[LastName] AS [EmployeeName],
				CASE WHEN R.FromDateId=R.TillDateId THEN CAST(CONVERT(VARCHAR(20),DM1.[Date],106) AS Varchar(20)) 
							ELSE  CAST(CONVERT(VARCHAR(20),DM1.[Date],106) AS Varchar(20)) + '  To  ' + CAST(CONVERT(VARCHAR(20),DM2.[Date],106) AS Varchar(20) ) END AS [Period],
				R.[Reason] AS [Reason],
				CONVERT(VARCHAR(20), R.CreatedDate,106) + ' ' + FORMAT(R.CreatedDate,'hh:mm tt') AS [ApplyDate],
				(CASE WHEN S.StatusId=2 OR S.StatusId=3 THEN
				S.[Status]+' With '+ UDT.FirstName+' '+ UDT.LastName 
				ELSE S.[Status]+' by '+ UDT.FirstName+' '+ UDT.LastName END) AS [Status],
				OT.OutingTypeName AS [DutyType],
				APR.FirstName + ' ' + APR.LastName + ': ' +  REM.[Remarks] AS [Remarks],
				S.StatusCode
			FROM OutingRequest R 
			INNER JOIN  UserDetail UD WITH (NOLOCK) ON UD.UserId=R.UserId 
			INNER JOIN UserDetail UDT WITH (NOLOCK) ON UDT.UserId=R.NextApproverId
			INNER JOIN  DateMaster DM1 WITH (NOLOCK) ON R.FromDateId=DM1.DateId   
			INNER JOIN DateMaster DM2 WITH (NOLOCK) ON R.TillDateId=DM2.DateId
			INNER JOIN OutingRequestStatus S WITH (NOLOCK) ON R.StatusId=S.StatusId
			INNER JOIN OutingType OT WITH (NOLOCK) ON R.OutingTypeId=OT.OutingTypeId
			JOIN (SELECT OutingRequestId, MAX(OutingRequestHistoryId) AS OutingRequestHistoryId FROM OutingRequestHistory GROUP BY OutingRequestId) ORH
				ON R.OutingRequestId=ORH.OutingRequestId 
			INNER JOIN OutingRequestHistory REM WITH (NOLOCK) ON ORH.OutingRequestHistoryId=REM.OutingRequestHistoryId
			INNER JOIN UserDetail APR WITH (NOLOCK) ON REM.CreatedById=APR.UserId
			WHERE R.NextApproverId=@LoginUserId 

			UNION ALL

			SELECT  R.OutingRequestId AS [OutingRequestId],
				UD.[FirstName] + ' ' + UD.[LastName] AS [EmployeeName],
				CASE WHEN R.FromDateId=R.TillDateId THEN CAST(CONVERT(VARCHAR(20),DM1.[Date],106) AS Varchar(20)) 
							ELSE  CAST(CONVERT(VARCHAR(20),DM1.[Date],106) AS Varchar(20)) + '  To  ' + CAST(CONVERT(VARCHAR(20),DM2.[Date],106) AS Varchar(20) ) END AS [Period],
				R.[Reason] AS [Reason],
				CONVERT(VARCHAR(20), R.CreatedDate,106) + ' ' + FORMAT(R.CreatedDate,'hh:mm tt') AS [ApplyDate],
				 S.[Status]+' With '+ UDT.FirstName+' '+ UDT.LastName AS [Status],
				OT.OutingTypeName AS [DutyType],
				APR.FirstName + ' ' + APR.LastName + ': ' +  REM.[Remarks] AS [Remarks],
				SC.[StatusCode] AS [StatusCode]
				
			FROM OutingRequest R 
			INNER JOIN  UserDetail UD WITH (NOLOCK) ON UD.UserId=R.UserId 
			INNER JOIN  DateMaster DM1 WITH (NOLOCK) ON R.FromDateId=DM1.DateId  
			INNER JOIN DateMaster DM2 WITH (NOLOCK) ON R.TillDateId=DM2.DateId
			INNER JOIN OutingType OT WITH (NOLOCK) ON R.OutingTypeId=OT.OutingTypeId
			JOIN (SELECT OutingRequestId, MAX(OutingRequestHistoryId) AS OutingRequestHistoryId FROM OutingRequestHistory GROUP BY OutingRequestId) ORH
				ON R.OutingRequestId=ORH.OutingRequestId 
			INNER JOIN OutingRequestHistory REM WITH (NOLOCK) ON ORH.OutingRequestHistoryId=REM.OutingRequestHistoryId
			INNER JOIN UserDetail APR WITH (NOLOCK) ON REM.CreatedById=APR.UserId

			JOIN (SELECT OutingRequestId, MAX(StatusId) AS StatusId, MAX(CreatedDate) AS CreatedDate FROM OutingRequestHistory WITH (NOLOCK)  WHERE CreatedById=@LoginUserId
			 GROUP BY OutingRequestId ) ACT
				ON ACT.OutingRequestId=R.OutingRequestId
			INNER JOIN OutingRequestStatus SC WITH (NOLOCK) ON ACT.StatusId=SC.StatusId
			INNER JOIN OutingRequestStatus S WITH (NOLOCK) ON R.StatusId=S.StatusId
			INNER JOIN UserDetail UDT WITH (NOLOCK) ON (UDT.UserId=R.NextApproverId)
			WHERE (ACT.StatusId<>1) AND R.StatusId<=3

			UNION
			
			SELECT  R.OutingRequestId AS [OutingRequestId],
				UD.[FirstName] + ' ' + UD.[LastName] AS [EmployeeName],
				CASE WHEN R.FromDateId=R.TillDateId THEN CAST(CONVERT(VARCHAR(20),DM1.[Date],106) AS Varchar(20)) 
							ELSE  CAST(CONVERT(VARCHAR(20),DM1.[Date],106) AS Varchar(20)) + '  To  ' + CAST(CONVERT(VARCHAR(20),DM2.[Date],106) AS Varchar(20) ) END AS [Period],
				R.[Reason] AS [Reason],
				CONVERT(VARCHAR(20), R.CreatedDate,106) + ' ' + FORMAT(R.CreatedDate,'hh:mm tt') AS [ApplyDate],
				 S.[Status]+' by '+UDTV.FirstName+' '+UDTV.LastName AS [Status],
				 OT.OutingTypeName AS [DutyType],
				APR.FirstName + ' ' + APR.LastName + ': ' +  REM.[Remarks] AS [Remarks],
				S.[StatusCode] AS [StatusCode]
				
			FROM OutingRequest R 
			INNER JOIN  UserDetail UD WITH (NOLOCK) ON UD.UserId=R.UserId 
			INNER JOIN  DateMaster DM1 WITH (NOLOCK) ON R.FromDateId=DM1.DateId  
			INNER JOIN DateMaster DM2 WITH (NOLOCK) ON R.TillDateId=DM2.DateId
			INNER JOIN OutingType OT WITH (NOLOCK) ON R.OutingTypeId=OT.OutingTypeId
			JOIN (SELECT OutingRequestId, MAX(OutingRequestHistoryId) AS OutingRequestHistoryId FROM OutingRequestHistory GROUP BY OutingRequestId) ORH
				ON R.OutingRequestId=ORH.OutingRequestId 
			INNER JOIN OutingRequestHistory REM WITH (NOLOCK) ON ORH.OutingRequestHistoryId=REM.OutingRequestHistoryId
			INNER JOIN UserDetail APR WITH (NOLOCK) ON REM.CreatedById=APR.UserId

			JOIN (SELECT OutingRequestId, MAX(StatusId) AS StatusId, MAX(CreatedDate) AS CreatedDate FROM OutingRequestHistory WITH (NOLOCK)  WHERE CreatedById=@LoginUserId
			 GROUP BY OutingRequestId ) ACT
				ON ACT.OutingRequestId=R.OutingRequestId
			INNER JOIN OutingRequestStatus SC WITH (NOLOCK) ON ACT.StatusId=SC.StatusId
			INNER JOIN OutingRequestStatus S WITH (NOLOCK) ON R.StatusId=S.StatusId
			INNER JOIN UserDetail UDTV WITH (NOLOCK) ON (UDTV.UserId=R.ModifiedById)
			WHERE (ACT.StatusId<>1)	AND R.StatusId>=5
			
		
	SELECT [OutingRequestId], [EmployeeName], [Period], [Reason], [ApplyDate], [Status],[DutyType],[Remarks], [StatusCode]
	FROM #TempDataNew
END
GO
/****** Object:  StoredProcedure [dbo].[Proc_TakeActionOnLegitimateLeave]    Script Date: 2/5/18 12:29:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TakeActionOnLegitimateLeave]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_TakeActionOnLegitimateLeave] AS' 
END
GO

/***
Created Date      : 2018-03-21
Created By        : Kanchan Kumari
Description       : To approve/reject Legitimate Leave
Change History    :
	--------------------------------------------------------------------------
	Modify Date       Edited By            Change Description
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	Test Cases        :
	--------------------------------------------------------------------------
	DECLARE @Result INT
	EXEC [Proc_TakeActionOnLegitimateLeave]
		  @LegitimateLeaveRequestId =172,
		  @StatusCode='AP',
		  @Remarks='OK',
		  @LoginUserId=2203,
		  @LoginUserType='MGR',
		  @Success=@Result output
	SELECT @Result As [RESULT]
***/
ALTER PROC [dbo].[Proc_TakeActionOnLegitimateLeave]
@LegitimateLeaveRequestId BIGINT,
@StatusCode VARCHAR(20),
@Remarks VARCHAR(500) = NULL,
@LoginUserId BIGINT,
@LoginUserType VARCHAR(200) = NULL,
@Success TINYINT = 0 Output
AS
BEGIN TRY
BEGIN TRAN

	DECLARE @StatusId INT, @StatusIdNew INT, @EmployeeId BIGINT,@FirstReportingId BIGINT , @SecondReportingId BIGINT, @HRId BIGINT,@DateId BIGINT,@Reason VARCHAR(500)

	DECLARE @count INT,@FromDateId INT,@TillDateId INT,@CountDate INT=0
	SELECT @EmployeeId=[UserId] FROM [dbo].LegitimateLeaveRequest WITH (NOLOCK) WHERE LegitimateLeaveRequestId=@LegitimateLeaveRequestId
	SELECT @StatusId = [StatusId] FROM [dbo].[LegitimateLeaveStatus] WITH (NOLOCK) WHERE [StatusCode]=@StatusCode
	SET @SecondReportingId= (SELECT [dbo].[fnGetSecondReportingManagerByUserId](@EmployeeId))
	SET @HRId=(SELECT [dbo].[fnGetHRIdByUserId](@EmployeeId))
	SET @FirstReportingId=(SELECT [dbo].[fnGetReportingManagerByUserId](@EmployeeId))
	SET @DateId=(SELECT DateId From LegitimateLeaveRequest where LegitimateLeaveRequestId=@LegitimateLeaveRequestId)
	SET @Reason=(SELECT Reason From LegitimateLeaveRequest where LegitimateLeaveRequestId=@LegitimateLeaveRequestId)
	
	--Approved By first level Manager
	 IF(@LoginUserType='MGR' AND @StatusCode='AP' AND  @LoginUserId=@FirstReportingId)
	BEGIN
	     
		 IF(@SecondReportingId=0)
		 BEGIN
		 SET @SecondReportingId=@HRId
		 SET @StatusIdNew=(SELECT StatusId From OutingRequestStatus where StatusCode='PV')
		 END
		 ELSE
		 BEGIN
		  SET @StatusIdNew=(SELECT StatusId From OutingRequestStatus where StatusCode='PA')
		 END

		INSERT INTO LegitimateLeaveRequestHistory(LegitimateLeaveRequestId,DateId,Reason,StatusId,Remarks,CreatedBy)
	              	VALUES( @LegitimateLeaveRequestId,@DateId,@Reason, @StatusId, @Remarks,@LoginUserId)
		-- Request Table
		UPDATE LegitimateLeaveRequest set NextApproverId=@SecondReportingId,StatusId=@StatusIdNew,LastModifiedBy=@LoginUserId, LastModifiedDate=GETDATE()
		WHERE LegitimateLeaveRequestId=@LegitimateLeaveRequestId
	END
	--Approved by Second level Manager
	ELSE IF(@LoginUserType='MGR' AND @StatusCode='AP' AND  @LoginUserId=@SecondReportingId)
	BEGIN
	    SET @StatusIdNew=(SELECT StatusId From OutingRequestStatus where StatusCode='PV')
	INSERT INTO LegitimateLeaveRequestHistory(LegitimateLeaveRequestId,DateId,Reason,StatusId,Remarks,CreatedBy)
	              	VALUES( @LegitimateLeaveRequestId,@DateId,@Reason, @StatusId, @Remarks,@LoginUserId)
	UPDATE LegitimateLeaveRequest set NextApproverId=@HRId,StatusId=@StatusIdNew,LastModifiedBy=@LoginUserId, LastModifiedDate=GETDATE()
		WHERE LegitimateLeaveRequestId=@LegitimateLeaveRequestId
		
	END
	-- Verififed by HR
	ELSE IF(@LoginUserType='HR' AND @StatusCode='VD')
	BEGIN
		INSERT INTO LegitimateLeaveRequestHistory(LegitimateLeaveRequestId,DateId,Reason,StatusId,Remarks,CreatedBy)
	              	VALUES( @LegitimateLeaveRequestId,@DateId,@Reason, @StatusId, @Remarks,@LoginUserId)
	    UPDATE LegitimateLeaveRequest set NextApproverId=NULL,StatusId=@StatusId,LastModifiedBy=@LoginUserId, LastModifiedDate=GETDATE()
		            WHERE LegitimateLeaveRequestId=@LegitimateLeaveRequestId
					DECLARE @LeaveRequestApplicationId BIGINT
					SET @LeaveRequestApplicationId=(SELECT LeaveRequestApplicationId FROM LegitimateLeaveRequest WHERE LegitimateLeaveRequestId=@LegitimateLeaveRequestId)
					
					Update LeaveRequestApplication SET StatusId=0,LastModifiedBy=@LoginUserId,LastModifiedDate=GETDATE()
					                             WHERE LeaveRequestApplicationId=@LeaveRequestApplicationId

					INSERT INTO LeaveHistory(LeaveRequestApplicationId,StatusId,ApproverId,ApproverRemarks,CreatedBy)
					VALUES (@LeaveRequestApplicationId,0,@LoginUserId,'LWP cancelled (legitimate leave approved)',@LoginUserId)

    END
	--Rejected by Manager
	ELSE IF(@StatusCode='RJM' OR @StatusCode='RJH')
	BEGIN
	INSERT INTO LegitimateLeaveRequestHistory(LegitimateLeaveRequestId,DateId,Reason,StatusId,Remarks,CreatedBy)
	              	VALUES( @LegitimateLeaveRequestId,@DateId,@Reason, @StatusId, @Remarks,@LoginUserId)
		  UPDATE LegitimateLeaveRequest set NextApproverId=NULL,StatusId=@StatusId,LastModifiedBy=@LoginUserId, LastModifiedDate=GETDATE()
		            WHERE LegitimateLeaveRequestId=@LegitimateLeaveRequestId
      
	    DECLARE @LeaveCombination VARCHAR(10),@Id VARCHAR(10)
		SET @LeaveCombination=(SELECT LeaveCombination From LegitimateLeaveRequest WHERE LegitimateLeaveRequestId=@LegitimateLeaveRequestId)
		SET @Id=(SELECT [Character] FROM [dbo].[fnSplitWord](@LeaveCombination, ' ') where Id=2)
		
      INSERT INTO [dbo].[LeaveBalanceHistory]
      (
         [RecordId]
        ,[Count]
        ,[CreatedBy]
      )
	
	SELECT A.RecordId ,A.[Count],@EmployeeId
	    FROM LeaveBalance A INNER JOIN LeaveTypeMaster B ON B.TypeId= A.LeaveTypeId 
		WHERE B.ShortName=@Id AND A.UserId=@EmployeeId
		       
     
	  UPDATE A
      SET A.[Count] = CASE
                        WHEN @Id = 'LWP' THEN A.[Count] - 1
                        ELSE A.[Count] + 1
                      END
	  FROM [dbo].[LeaveBalance] A WITH (NOLOCK)
      INNER JOIN LeaveTypeMaster B ON B.TypeId=A.LeaveTypeId
	   WHERE B.ShortName=@Id AND A.UserId=@EmployeeId
     
	          END
	SET @Success=1
	COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0
SET @Success=0
	ROLLBACK TRANSACTION
	DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
        EXEC [spInsertErrorLog]
	        @ModuleName = 'LeaveManagement'
        ,@Source = '[Proc_TakeActionOnLegitimateLeave]'
        ,@ErrorMessage = @ErrorMessage
        ,@ErrorType = 'SP'
        ,@ReportedByUserId = @LoginUserId
END CATCH

GO
/****** Object:  StoredProcedure [dbo].[Proc_TakeActionOnOutingRequest]    Script Date: 2/5/18 12:29:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TakeActionOnOutingRequest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_TakeActionOnOutingRequest] AS' 
END
GO
/***
--Created Date      : 2018-03-21
--Created By        : Kanchan Kumari
--Description       : To approve/reject/cancel outing request
--Usage		        :

DECLARE @Result INT
EXEC [Proc_TakeActionOnOutingRequest]
	  @OutingRequestId =172,
	  @StatusCode='AP',
	  @Remarks='OK',
	  @LoginUserId=2203,
	  @LoginUserType='MGR',
	  @OutingRequestDetailId=0,
	  @Success=@Result output
SELECT @Result As [RESULT]
***/
ALTER PROC [dbo].[Proc_TakeActionOnOutingRequest]
@OutingRequestId BIGINT,
@StatusCode VARCHAR(20),
@Remarks VARCHAR(500) = NULL,
@LoginUserId BIGINT,
@LoginUserType VARCHAR(200) = NULL,
@OutingRequestDetailId BIGINT=NULL,
@Success TINYINT = 0 Output
AS
BEGIN TRY
BEGIN TRAN

	DECLARE @StatusId INT, @StatusIdNew INT, @EmployeeId BIGINT,@FirstReportingId BIGINT , @SecondReportingId BIGINT, @HRId BIGINT
	DECLARE @count INT,@FromDateId INT,@TillDateId INT,@CountDate INT=0
	SELECT @EmployeeId=[UserId] FROM [dbo].[OutingRequest] WITH (NOLOCK) WHERE [OutingRequestId]=@OutingRequestId
	SELECT @StatusId = [StatusId] FROM [dbo].[OutingRequestStatus] WITH (NOLOCK) WHERE [StatusCode]=@StatusCode
	SET @SecondReportingId= (SELECT [dbo].[fnGetSecondReportingManagerByUserId](@EmployeeId))
	SET @HRId=(SELECT [dbo].[fnGetHRIdByUserId](@EmployeeId))
	SET @FirstReportingId=(SELECT [dbo].[fnGetReportingManagerByUserId](@EmployeeId))
	
	WHILE(@FromDateId<=@TillDateId)
	BEGIN
	SET @CountDate=@CountDate+1
	SET @FromDateId=@FromDateId+1
	END
	--Cancel by user it self
	IF(@LoginUserId=@EmployeeId AND @StatusCode='CA' AND @Remarks='Cancel')
	BEGIN
	     print @StatusId;
		 UPDATE OutingRequestDetail SET StatusId=@StatusId ,ModifiedById=@LoginUserId ,ModifiedDate=GETDATE()
		 WHERE  OutingRequestDetailId=@OutingRequestDetailId  
		 SET @count=(SELECT Count(DateId) From OutingRequestDetail Where StatusId=8 
	              group by OutingRequestId having OutingRequestId=@OutingRequestId)
			SET @FromDateId=(SELECT FromDateId from OutingRequest where OutingRequestId=@OutingRequestId)
			SET @TillDateId=(SELECT TillDateId from OutingRequest where OutingRequestId=@OutingRequestId)
				WHILE(@FromDateId<=@TillDateId)
				BEGIN
					SET @CountDate=@CountDate+1
					SET @FromDateId=@FromDateId+1
				END

		IF(@Count=@CountDate)
		 BEGIN
			INSERT INTO OutingRequestHistory(OutingRequestId,StatusId,Remarks,CreatedById)
			SELECT @OutingRequestId, @StatusId AS StatusId,'Cancelled' AS Remarks, @LoginUserId
			UPDATE OutingRequest SET StatusId=@StatusId, NextApproverId=NULL, ModifiedById=@LoginUserId, ModifiedDate=GETDATE()
			WHERE OutingRequestId=@OutingRequestId
         END
		
	END
	--Cancel All request by User and HR
	ELSE IF(@LoginUserId=@EmployeeId OR @LoginUserId=@HRId AND @StatusCode='CA' AND @Remarks='CancelAll')
	BEGIN
	     print @StatusId;
		 UPDATE OutingRequestDetail SET StatusId=@StatusId ,ModifiedById=@LoginUserId, ModifiedDate=GETDATE()
		 WHERE  OutingRequestId=@OutingRequestId 
		 SET @count=(SELECT Count(DateId) From OutingRequestDetail Where StatusId=8 
	              group by OutingRequestId having OutingRequestId=@OutingRequestId)
			SET @FromDateId=(SELECT FromDateId from OutingRequest where OutingRequestId=@OutingRequestId)
			SET @TillDateId=(SELECT TillDateId from OutingRequest where OutingRequestId=@OutingRequestId)
				WHILE(@FromDateId<=@TillDateId)
				BEGIN
					SET @CountDate=@CountDate+1
					SET @FromDateId=@FromDateId+1
				END

		IF(@Count=@CountDate)
		 BEGIN
			INSERT INTO OutingRequestHistory(OutingRequestId,StatusId,Remarks,CreatedById)
			SELECT @OutingRequestId, @StatusId AS StatusId,'Cancelled' AS Remarks, @LoginUserId
			UPDATE OutingRequest SET StatusId=@StatusId, NextApproverId=NULL, ModifiedById=@LoginUserId, ModifiedDate=GETDATE()
			WHERE OutingRequestId=@OutingRequestId
         END
		
	END

	--Approved By first level Manager
	ELSE IF(@LoginUserType='MGR' AND @StatusCode='AP' AND  @LoginUserId=@FirstReportingId)
	BEGIN
	     
		 IF(@SecondReportingId=0)
		 BEGIN
		 SET @SecondReportingId=@HRId
		 SET @StatusIdNew=(SELECT StatusId From OutingRequestStatus where StatusCode='PV')
		 END
		 ELSE
		 BEGIN
		  SET @StatusIdNew=(SELECT StatusId From OutingRequestStatus where StatusCode='PA')
		 END

		INSERT INTO OutingRequestHistory(OutingRequestId,StatusId,Remarks,CreatedById)
		SELECT @OutingRequestId,@StatusId AS StatusId,@Remarks,@LoginUserId
		--update outing Request detail table
		UPDATE OutingRequestDetail SET StatusId=@StatusIdNew, ModifiedById=@LoginUserId,ModifiedDate=GETDATE() 
		WHERE OutingRequestId=@OutingRequestId
		--update Outing Request Table
		UPDATE OutingRequest set NextApproverId=@SecondReportingId,StatusId=@StatusIdNew,ModifiedById=@LoginUserId, ModifiedDate=GETDATE()
		WHERE OutingRequestId=@OutingRequestId
	END
	--Approved by Second level Manager
	ELSE IF(@LoginUserType='MGR' AND @StatusCode='AP' AND  @LoginUserId=@SecondReportingId)
	BEGIN
	    SET @StatusIdNew=(SELECT StatusId From OutingRequestStatus where StatusCode='PV')
		INSERT INTO OutingRequestHistory(OutingRequestId,StatusId,Remarks,CreatedById)
		SELECT @OutingRequestId,@StatusId AS StatusId,@Remarks,@LoginUserId
		--update outing Request detail table
		UPDATE OutingRequestDetail SET StatusId=@StatusIdNew, ModifiedById=@LoginUserId,ModifiedDate=GETDATE() 
		WHERE OutingRequestId=@OutingRequestId
		--update Outing Request Table
		UPDATE OutingRequest set StatusId=@StatusIdNew, NextApproverId=@HRId, ModifiedById=@LoginUserId, ModifiedDate=GETDATE()
		WHERE OutingRequestId=@OutingRequestId
	END
	-- Verififed by HR
	ELSE IF(@LoginUserType='HR' AND @StatusCode='VD')
	BEGIN
		INSERT INTO OutingRequestHistory(OutingRequestId,StatusId,Remarks,CreatedById)
		SELECT @OutingRequestId,@StatusId AS StatusId,@Remarks,@LoginUserId
		--update outing Request detail table
		UPDATE OutingRequestDetail SET StatusId=@StatusId, ModifiedById=@LoginUserId,ModifiedDate=GETDATE() 
		WHERE OutingRequestId=@OutingRequestId
		--update Outing Request Table
		UPDATE OutingRequest set StatusId=@StatusId, NextApproverId=NULL, ModifiedById=@LoginUserId, ModifiedDate=GETDATE() 
		WHERE OutingRequestId=@OutingRequestId
	END
	--Rejected by Manager
	ELSE IF(@StatusCode='RJM' )
	BEGIN
		INSERT INTO OutingRequestHistory(OutingRequestId,StatusId,Remarks,CreatedById)
		SELECT @OutingRequestId,@StatusId AS StatusId,@Remarks,@LoginUserId
		--update outing Request detail table
		UPDATE OutingRequestDetail SET StatusId=@StatusId, ModifiedById=@LoginUserId,ModifiedDate=GETDATE() 
		WHERE OutingRequestId=@OutingRequestId
		--update Outing Request Table
		UPDATE OutingRequest set StatusId=@StatusId, NextApproverId=NULL, ModifiedById=@LoginUserId, ModifiedDate=GETDATE()
		WHERE OutingRequestId=@OutingRequestId
	END
	--Rejected by HR
	ELSE IF(@StatusCode='RJH' )
	BEGIN
		INSERT INTO OutingRequestHistory(OutingRequestId,StatusId,Remarks,CreatedById)
		SELECT @OutingRequestId,@StatusId AS StatusId,@Remarks,@LoginUserId
		--update outing Request detail table
		UPDATE OutingRequestDetail SET StatusId=@StatusId, ModifiedById=@LoginUserId,ModifiedDate=GETDATE() 
		WHERE OutingRequestId=@OutingRequestId
		--update Outing Request Table
		UPDATE OutingRequest set StatusId=@StatusId, NextApproverId=NULL, ModifiedById=@LoginUserId, ModifiedDate=GETDATE()
		WHERE OutingRequestId=@OutingRequestId
	END
	SET @Success=1
	COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0
SET @Success=0
	ROLLBACK TRANSACTION
	DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
        EXEC [spInsertErrorLog]
	        @ModuleName = 'LeaveManagement'
        ,@Source = '[Proc_TakeActionOnOutingRequest]'
        ,@ErrorMessage = @ErrorMessage
        ,@ErrorType = 'SP'
        ,@ReportedByUserId = @LoginUserId
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[Proc_UserAppliedLegitimateLeave]    Script Date: 2/5/18 12:29:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_UserAppliedLegitimateLeave]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_UserAppliedLegitimateLeave] AS' 
END
GO

/***
	Created Date      :     2018-05-1
	Created By        :     Kanchan Kumari
	Purpose           :     This stored procedure Get legitimate leave Deatils.
   
	Change History    :
	--------------------------------------------------------------------------
	Modify Date       Edited By            Change Description
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	Test Cases        :
	--------------------------------------------------------------------------
	EXEC  Proc_UserAppliedLegitimateLeave @UserId=24 ,@Year=2018
***/
ALTER PROC [dbo].[Proc_UserAppliedLegitimateLeave]
@UserId INT,
@Year [int] = null
AS
BEGIN
SET NOCOUNT ON;
	DECLARE @StartDate [date], @EndDate [date], @AdminId int = 1
	 
	IF (@Year IS NULL OR @Year =0)
	SET @Year = DATEPART(YYYY, GETDATE())

	SELECT @StartDate=dateadd(Month,0,cast(concat(@Year,'-04-01') as date))  ,
		  @EndDate = dateadd(Year,1,cast(concat(@Year,'-03-31') as date)) 
	SELECT  CONVERT(VARCHAR(20), LR.CreatedDate,106) + ' ' + FORMAT(LR.CreatedDate,'hh:mm tt') AS [ApplyDate],
        LR.LegitimateLeaveRequestId AS [LeaveApplicationId],
		CAST(CONVERT(VARCHAR(20),DM.[Date],106) AS Varchar(20)) AS[FromDate] ,
	    CAST(CONVERT(VARCHAR(20),DM.[Date],106) AS Varchar(20))  AS[TillDate],
	    LR.LeaveCombination AS [LeaveInfo],
	    LR.Reason AS[Reason],
	    LS.StatusCode AS[Status],
		
	   (CASE WHEN LS.StatusCode='CA' THEN LS.[Status] +' by '+UD2.FirstName+' '+UD2.LastName
	   WHEN LS.StatusCode='RJM'  THEN LS.[Status] +' by '+UD2.FirstName+' '+UD2.LastName
	   WHEN LS.StatusCode='RJH'  THEN LS.[Status] +' by '+UD2.FirstName+' '+UD2.LastName
	   WHEN LS.StatusCode='VD' THEN LS.[Status] +' by '+UD2.FirstName+' '+UD2.LastName
	   ELSE LS.[Status]+' with '+UD1.FirstName+' '+UD1.LastName END) AS  [StatusFullForm],
	    (CASE
         WHEN LS.[StatusCode] = 'CA' THEN LR.[Remarks]
         WHEN LRH.[Remarks] IS NULL THEN 'NA'
         WHEN LTRIM(RTRIM(LRH.[Remarks])) = '' THEN UDL.[FirstName] + ' ' + UDL.[LastName] + ': Approved'
		WHEN (LR.[NextApproverId] = @AdminId AND LR.[CreatedBy] = @AdminId) THEN LRH.[Remarks]
         ELSE UDL.[FirstName] + ' ' + UDL.[LastName] + ': ' + LRH.[Remarks]
         END) AS[Remarks]   ,
	     1 AS [LeaveCount],
	    LR.CreatedBy
	   FROM LegitimateLeaveRequest LR 
	   LEFT JOIN UserDetail UD1 ON UD1.UserId=LR.NextApproverId
	   LEFT JOIN UserDetail UD2 ON UD2.UserId=LR.LastModifiedBy
	   INNER JOIN DateMaster DM ON DM.DateId=LR.DateId
	   INNER JOIN LegitimateLeaveStatus LS ON LS.StatusId=LR.StatusId
	   INNER JOIN (SELECT LegitimateLeaveRequestId, MAX(LegitimateLeaveRequestHistoryId) AS LegitimateLeaveRequestHistoryId 
	               FROM LegitimateLeaveRequestHistory GROUP BY LegitimateLeaveRequestId) ORH
			ON ORH.LegitimateLeaveRequestId=LR.LegitimateLeaveRequestId	
	   INNER JOIN [dbo].[LegitimateLeaveRequestHistory] LRH WITH (NOLOCK)
	    ON LRH.LegitimateLeaveRequestHistoryId=ORH.LegitimateLeaveRequestHistoryId
	   INNER JOIN [dbo].[UserDetail] UDL WITH (NOLOCK) ON UDL.UserId=LRH.CreatedBy
	WHERE 
      LR.[UserId] =@UserId
      AND LR.[CreatedDate] BETWEEN @StartDate AND @EndDate
   ORDER BY LR.[CreatedDate] DESC
	END  
GO
/****** Object:  StoredProcedure [dbo].[spGetApproverRemarks]    Script Date: 2/5/18 12:29:09 PM ******/
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
       
***/
ALTER PROCEDURE [dbo].[spGetApproverRemarks]
(
   @RequestId [bigint]
  ,@Type [varchar] (10)
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
	
	ELSE
	 SELECT 'ERROR'  AS	[Result]
END

GO
/****** Object:  StoredProcedure [dbo].[spGetUserAppliedCompOff]    Script Date: 2/5/18 12:29:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetUserAppliedCompOff]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGetUserAppliedCompOff] AS' 
END
GO
/***
   Created Date      :     2017-02-07
   Created By        :     Shubhra Upadhyay
   Purpose           :     This stored procedure gets all applied comp off on basis of userId
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   19-4-2018        Mimansa Agrawal      Added filter for financial year
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   EXEC [dbo].[spGetUserAppliedCompOff] @UserId = 2432,@Year=2018
***/
ALTER PROCEDURE [dbo].[spGetUserAppliedCompOff] 
   @UserId [int],@Year [int]=NULL
AS
BEGIN
   SET NOCOUNT ON;
   DECLARE @StartDate [date], @EndDate [date], @JoiningDate [date]
	 
	IF (@Year IS NULL OR @Year =0)
	SET @Year = DATEPART(YYYY, GETDATE())

	SELECT @StartDate=dateadd(Month,0,cast(concat(@Year,'-04-01') as date))  ,
		  @EndDate = dateadd(Year,1,cast(concat(@Year,'-03-31') as date)) ,
		  @JoiningDate= JoiningDate FROM UserDetail WHERE UserId=@UserId
		  IF(DATEPART(YYYY,@JoiningDate)=DATEPART(YYYY, @StartDate) AND DATEPART(mm,@JoiningDate)<DATEPART(mm,@StartDate))
		  SELECT @StartDate=@JoiningDate

   SELECT 
       C.[RequestId] AS [RequestId]
      ,D.[Date] AS [Date]
      ,C.[Reason] AS [Reason]
      ,C.[NoOfDays] AS [NoOfDays]
      ,CASE
         WHEN LS.[StatusCode] = 'RJ' THEN 'Rejected By ' + (SELECT [FirstName] + ' ' + [LastName] FROM [dbo].[UserDetail] WHERE [UserId] = C.[LastModifiedBy])
         WHEN LS.[StatusCode] = 'CA' THEN 'Cancelled '
         WHEN LS.[StatusCode] = 'PA' THEN 'Pending for approval with ' + (SELECT [FirstName] + ' ' + [LastName] FROM [dbo].[UserDetail] WHERE [UserId] = C.[ApproverId])
         ELSE LS.[Status]
       END AS [Status]
     ,C.[StatusId]
	 ,LS.[StatusCode]
	  ,CASE
         WHEN LS.[StatusCode] = 'CA' THEN LS.[Status]
         WHEN H.[ApproverRemarks] IS NULL THEN 'NA'
         WHEN H.[CreatedBy] = @UserId THEN
									 (SELECT [FirstName] + ' ' + [LastName] FROM [dbo].[UserDetail] WHERE [UserId] = H.[CreatedBy]) + ': Applied'
         WHEN (LTRIM(RTRIM(H.[ApproverRemarks])) = '' AND H.[CreatedBy]<>@UserId) THEN CAP.[FirstName] + ' ' + CAP.[LastName] + ': Approved'
         ELSE CAP.[FirstName] + ' ' + CAP.[LastName] + ': ' + H.[ApproverRemarks]
      END  AS [ApproverRemarks]
      ,C.[CreatedDate] AS [AppliedOn]
      ,C.[IsLapsed]
      ,C.[LapseDate]      
      ,CASE
         WHEN COUNT(RD.[RequestId]) = 0 THEN 1 --available
         WHEN C.[NoOfDays] = COUNT(RD.[RequestId]) THEN 2 --availed
         WHEN C.[NoOfDays] > COUNT(RD.[RequestId]) THEN 3 --partially availed
       END                          AS [AvailabilityStatus]
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
      LEFT JOIN
         (
            SELECT
               RD.[RequestId]
            FROM
               [dbo].[RequestCompOffDetail] RD WITH (NOLOCK)
               INNER JOIN
                  [dbo].[LeaveRequestApplication] L WITH (NOLOCK)
                  ON RD.[LeaveRequestApplicationId] = L.[LeaveRequestApplicationId]
                     AND L.[StatusId] > 0
                     AND L.[IsActive] = 1
                     AND L.[IsDeleted] = 0
         ) RD
         ON C.[RequestId] = RD.[RequestId]      
	  LEFT JOIN ( 
				 SELECT H.[RequestId] AS [RequestId], MAX(H.[CreatedDate]) AS [LatestModifiedOn]
				 FROM [dbo].[RequestCompOffHistory] H WITH (NOLOCK)
				 GROUP BY H.[RequestId]
        ) RH ON C.[RequestId] = RH.[RequestId]

	  LEFT JOIN [dbo].[RequestCompOffHistory] H WITH (NOLOCK) ON H.[RequestId] = RH.[RequestId] AND H.[CreatedDate] = RH.[LatestModifiedOn]
	  LEFT JOIN [dbo].[UserDetail] CAP WITH (NOLOCK) ON H.[ApproverId] = CAP.[UserId]
   WHERE 
      U.[UserId] = @UserId 
      AND US.[IsActive] = 1   AND C.[CreatedDate] BETWEEN @StartDate AND @EndDate    
   GROUP BY C.[RequestId]
   ,D.[Date]
   ,C.[Reason]
   ,C.[NoOfDays]
   ,C.[LastModifiedBy]
   ,C.[ApproverId]
   ,LS.[StatusCode]
   ,C.[StatusId]
   ,LS.[Status]
   ,H.[CreatedBy]
   ,H.[ApproverRemarks]
   ,CAP.[FirstName] + ' ' + CAP.[LastName]
   ,C.[CreatedDate]
   ,C.[IsLapsed]
   ,C.[LapseDate]
   ORDER BY C.[CreatedDate] DESC   
END
GO
/****** Object:  StoredProcedure [dbo].[spGetUserAppliedDataChangeRequest]    Script Date: 2/5/18 12:29:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetUserAppliedDataChangeRequest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGetUserAppliedDataChangeRequest] AS' 
END
GO
/***
   Created Date      :     2017-02-07
   Created By        :     Shubhra Upadhyay
   Purpose           :     This stored procedure gets all applied data change request on basis of userId
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   --- Test Case 1
         EXEC [dbo].[spGetUserAppliedDataChangeRequest] @UserId = 1108,@Year=2017
***/
ALTER PROCEDURE [dbo].[spGetUserAppliedDataChangeRequest] 
   @UserId [int],
   @Year [int]=NULL
AS
BEGIN
SET NOCOUNT ON;
 DECLARE @StartDate [date], @EndDate [date], @JoiningDate [date]
	 
	IF (@Year IS NULL OR @Year =0)
	SET @Year = DATEPART(YYYY, GETDATE())

	SELECT @StartDate=dateadd(Month,0,cast(concat(@Year,'-04-01') as date))  ,
		  @EndDate = dateadd(Year,1,cast(concat(@Year,'-03-31') as date)) ,
		  @JoiningDate= JoiningDate FROM UserDetail WHERE UserId=@UserId
		 IF(DATEPART(YYYY,@JoiningDate)=DATEPART(YYYY, @StartDate) AND DATEPART(mm,@JoiningDate)<DATEPART(mm,@StartDate))
		  SELECT @StartDate=@JoiningDate

   SELECT
       C.[RequestId]     AS [RequestId]
      ,CA.[CategoryCode] AS [Category]
      ,C.[Reason]        AS [Reason]
      ,CASE
         WHEN S.[StatusCode] = 'RJ' THEN 'Rejected By ' + (SELECT [FirstName] + ' ' + [LastName] FROM [dbo].[UserDetail] WHERE [UserId] = C.[LastModifiedBy])
         WHEN S.[StatusCode] = 'CA' THEN 'Cancelled '
         WHEN S.[StatusCode] = 'PA' THEN 'Pending for approval with ' + (SELECT [FirstName] + ' ' + [LastName] FROM [dbo].[UserDetail] WHERE [UserId] = C.[ApproverId])
         ELSE S.[Status]
       END AS [Status]
      ,(SELECT TOP 1 CASE
         WHEN (H.[ApproverRemarks] = '' OR H.[ApproverRemarks] IS NULL) THEN (SELECT [FirstName] + ' ' + [LastName] FROM [dbo].[UserDetail] WHERE [UserId] = H.[ApproverId]) + ': Approved'
         ELSE (SELECT [FirstName] + ' ' + [LastName] FROM [dbo].[UserDetail] WHERE [UserId] = H.[ApproverId]) + ': ' + H.[ApproverRemarks]
       END) AS [ApproverRemarks]
      ,C.[CreatedDate] AS [AppliedOn]
   FROM [dbo].[AttendanceDataChangeRequestApplication] C WITH (NOLOCK)
      INNER JOIN [dbo].[UserDetail] U WITH (NOLOCK) ON C.[CreatedBy] = U.[UserId]
      INNER JOIN [dbo].[User] US WITH (NOLOCK) ON U.[UserId] = US.[UserId]
      INNER JOIN  [dbo].[LeaveStatusMaster] S WITH (NOLOCK) ON C.[StatusId] = S.StatusId
      INNER JOIN [dbo].[AttendanceDataChangeRequestCategory] CA WITH (NOLOCK) ON C.[RequestCategoryid] = CA.[CategoryId]
      INNER JOIN (SELECT MAX(RecordId) AS RecordId, RequestId FROM [dbo].[AttendanceDataChangeRequestHistory] WITH (NOLOCK) GROUP BY RequestId) H1 ON C.[RequestId] = H1.[RequestId]
	  INNER JOIN [dbo].[AttendanceDataChangeRequestHistory] H WITH (NOLOCK) ON H1.RecordId = H.RecordId
   WHERE U.[UserId] = @UserId AND US.[IsActive] = 1 AND U.[TerminateDate] IS NULL AND C.[CreatedDate] BETWEEN @StartDate AND @EndDate
   ORDER BY C.[CreatedDate] DESC
END
GO
/****** Object:  StoredProcedure [dbo].[spGetUserAppliedLeave]    Script Date: 2/5/18 12:29:09 PM ******/
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
   EXEC [dbo].[spGetUserAppliedLeave] @UserId = 1108 ,@Year=2018
***/
ALTER PROCEDURE [dbo].[spGetUserAppliedLeave] 
   @UserID [int],
   @Year [int] = null
  AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @StartDate [date], @EndDate [date], @AdminId int = 1,@IsApplied Int, @JoiningDate [DATE]
	SELECT @JoiningDate = JoiningDate FROM UserDetail WITH (NOLOCK) WHERE UserId=@UserID
	 
	IF (@Year IS NULL OR @Year =0)
	SET @Year = DATEPART(YYYY, GETDATE())

	SELECT @StartDate=dateadd(Month,0,cast(concat(@Year,'-04-01') as date)),
		  @EndDate = dateadd(Year,1,cast(concat(@Year,'-03-31') as date)) 
	
	IF(DATEPART(YYYY,@JoiningDate)=DATEPART(YYYY, @StartDate) AND DATEPART(mm,@JoiningDate)<DATEPART(mm,@StartDate))
	 SELECT @StartDate = @JoiningDate

	SELECT 
      LR.[CreatedDate]                                                                  AS [ApplyDate]
	  ,LR.[LeaveRequestApplicationId]                                                   AS [LeaveApplicationId]
	  ,DM1.[Date]                                                                       AS [FromDate]
	  ,DM2.[Date]                                                                       AS [TillDate]
	  ,CAST(LR.[NoOfWorkingDays] AS [varchar](3)) + ' (' + LR.[LeaveCombination] + ')'  AS [LeaveInfo]
	  ,LR.[Reason]                                                                      AS [Reason]
	  ,LS.[StatusCode]                                                                  AS [Status]
	  ,CASE LS.[StatusCode] 
         WHEN 'RJ' THEN LS.[Status] + ' by ' + UD.[FirstName] + ' ' + UD.[LastName]
         WHEN 'PA' THEN LS.[Status] + ' with ' + UD.[FirstName] + ' ' + UD.[LastName]
         ELSE LS.[Status]
      END AS [StatusFullForm],
		CASE WHEN LL.[LegitimateLeaveRequestId] > 0 THEN CAST (1 AS [BIT])  ELSE CAST (0 AS [BIT]) END AS [IsApplied]
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
		  LEFT JOIN [dbo].[LegitimateLeaveRequest] LL WITH (NOLOCK) ON LR.[LeaveRequestApplicationId] = LL.[LeaveRequestApplicationId]
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
         LEFT JOIN [dbo].[UserDetail] UD1 WITH (NOLOCK) ON UD1.[UserId] = RH.[CreatedBy]--RH.[ApproverId]
	WHERE 
      LR.[UserId] = @UserId 
      AND LR.[CreatedDate] BETWEEN @StartDate AND @EndDate
   ORDER BY LR.[CreatedDate] DESC
   END
GO
/****** Object:  StoredProcedure [dbo].[spGetUserAppliedWorkFromHome]    Script Date: 2/5/18 12:29:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetUserAppliedWorkFromHome]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGetUserAppliedWorkFromHome] AS' 
END
GO
/***
   Created Date      :     2016-01-27
   Created By        :     Nishant Srivastava
   Purpose           :     This stored procedure Get User Applied WFH (This is for HR)
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   19-4-2018        Mimansa Agrawal       Added filter for finanacial year
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   --- Test Case 1
         EXEC [dbo].[spGetUserAppliedWorkFromHome]
           @UserId = 1108,@Year=2017
***/
ALTER PROCEDURE [dbo].[spGetUserAppliedWorkFromHome] 
   @UserId [int],
   @Year [int]=NULL
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @StartDate [date], @EndDate [date], @JoiningDate [date]
	SELECT @JoiningDate= JoiningDate FROM UserDetail  WITH (NOLOCK) WHERE UserId=@UserId
	IF (@Year IS NULL OR @Year =0)
	SET @Year = DATEPART(YYYY, GETDATE())

	SELECT @StartDate=dateadd(Month,0,cast(concat(@Year,'-04-01') as date))  ,
		  @EndDate = dateadd(Year,1,cast(concat(@Year,'-03-31') as date)) 
		  IF(DATEPART(YYYY,@JoiningDate)=DATEPART(YYYY, @StartDate) AND DATEPART(mm,@JoiningDate)<DATEPART(mm,@StartDate))
		  SELECT @StartDate=@JoiningDate
	SELECT 
      LR.[LeaveRequestApplicationId] AS [WorkFromHomeId]
	  ,LR.[CreatedDate]               AS [ApplyDate]
	  ,DM1.[Date]                     AS [FromDate]
	  ,DM2.[Date]                     AS [TillDate]
	  ,LT.[ShortName]                 AS [LeaveType]
	  ,LR.[Reason]                    AS [Reason]
	  ,LS.[StatusCode]                AS [Status]
	  ,CASE LS.[StatusCode] 
         WHEN 'RJ' THEN LS.[Status] + ' by ' + NAP.[FirstName] + ' ' + NAP.[LastName]
         WHEN 'PA' THEN LS.[Status] + ' from ' + NAP.[FirstName] + ' ' + NAP.[LastName]
         ELSE LS.[Status]
      END                                                                                                            AS [StatusFullForm]
	  ,CASE
         WHEN H.[ApproverRemarks] IS NULL THEN 'NA'
         WHEN LTRIM(RTRIM(H.[ApproverRemarks])) = '' THEN LAP.[FirstName] + ' ' + LAP.[LastName] + ': Approved'
         ELSE LAP.[FirstName] + ' ' + LAP.[LastName] + ': ' + H.[ApproverRemarks]
      END                                                                                                            AS [Remarks]
	  ,DWL.[IsHalfDay]                                                                                                AS [IsHalfDay]
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
	      INNER JOIN 
            [dbo].[DateWiseLeaveType] DWL WITH (NOLOCK)
		         ON LR.[LeaveRequestApplicationId] = DWL.[LeaveRequestApplicationId]
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
         LR.[UserId] = @UserId
		   AND LT.[ShortName] = 'WFH' AND LR.[CreatedDate] BETWEEN @StartDate AND @EndDate
   ORDER BY LR.[CreatedDate] DESC
END
GO

GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectTempCardDetailsForMIS]    Script Date: 2/5/18 6:28:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author        :		 CHANDRA PRAKASH
-- ALTER date	 :		 30 March 2016
-- Description	 :       SELECT Temp Card Details
--- EXEC [dbo].[Proc_SelectTempCardDetailsForMIS]  '01-Apr-2016','15-Apr-2017'
-- =============================================
CREATE PROCEDURE [dbo].[Proc_SelectTempCardDetailsForMIS] 
@From [Date] =null, 
@To [Date] =null
AS
BEGIN
SET NOCOUNT ON;
SELECT [IssueId]
	  ,LTRIM(RTRIM(REPLACE(REPLACE(REPLACE((UD.[FirstName] + ' ' + UD.[MiddleName] + ' ' + UD.[LastName]), ' ', '{}'), '}{',''), '{}', ' '))) [EmployeeName]
      ,ac.[AccessCardNo]
      ,[IssueDate]
      ,[ReturnDate]
      ,[Reason]
      ,[IsReturn]
  FROM [dbo].[TempCardIssueDetail] vd 
  join [dbo].[UserDetail] ud on vd.EmployeeId = ud.UserId
  join [dbo].[AccessCard] ac on vd.AccessCardId=ac.AccessCardId
  WHERE CONVERT(DATE, vd.[IssueDate], 106) >=CONVERT(DATE,  isnull(@From,getdate()), 106) 
	    AND CONVERT(DATE, vd.[IssueDate], 106)   <= CONVERT(DATE,  isnull(@To,getdate()), 106)
END
GO
