
/****** Object:  StoredProcedure [dbo].[spGetLeaveOrWfhLastRecordDetail]    Script Date: 16-12-2019 18:01:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetLeaveOrWfhLastRecordDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetLeaveOrWfhLastRecordDetail]
GO
/****** Object:  StoredProcedure [dbo].[spGetApproverRemarks]    Script Date: 16-12-2019 18:01:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetApproverRemarks]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetApproverRemarks]
GO
/****** Object:  StoredProcedure [dbo].[Proc_TakeActionOnCabRequest]    Script Date: 16-12-2019 18:01:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TakeActionOnCabRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TakeActionOnCabRequest]
GO
/****** Object:  StoredProcedure [dbo].[Proc_TakeActionOnCabBulkApprove]    Script Date: 16-12-2019 18:01:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TakeActionOnCabBulkApprove]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TakeActionOnCabBulkApprove]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetRoutesForCab]    Script Date: 16-12-2019 18:01:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetRoutesForCab]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetRoutesForCab]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetRouteLocationForCab]    Script Date: 16-12-2019 18:01:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetRouteLocationForCab]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetRouteLocationForCab]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetGroupedFinalizedCabRequest]    Script Date: 16-12-2019 18:01:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetGroupedFinalizedCabRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetGroupedFinalizedCabRequest]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetGroupedCabRequestToFinalize]    Script Date: 16-12-2019 18:01:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetGroupedCabRequestToFinalize]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetGroupedCabRequestToFinalize]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetFinalizedCabRequestDetail]    Script Date: 16-12-2019 18:01:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetFinalizedCabRequestDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetFinalizedCabRequestDetail]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetDatesForPickAndDrop]    Script Date: 16-12-2019 18:01:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetDatesForPickAndDrop]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetDatesForPickAndDrop]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetCabShift]    Script Date: 16-12-2019 18:01:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetCabShift]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetCabShift]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetCabReviewRequest]    Script Date: 16-12-2019 18:01:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetCabReviewRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetCabReviewRequest]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetCabRequestToFinalize]    Script Date: 16-12-2019 18:01:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetCabRequestToFinalize]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetCabRequestToFinalize]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetCabRequestDetail]    Script Date: 16-12-2019 18:01:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetCabRequestDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetCabRequestDetail]
GO
/****** Object:  StoredProcedure [dbo].[Proc_FinalizeCabRequest]    Script Date: 16-12-2019 18:01:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_FinalizeCabRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_FinalizeCabRequest]
GO
/****** Object:  StoredProcedure [dbo].[Proc_FetchCabRequestDetailByRequestId]    Script Date: 16-12-2019 18:01:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_FetchCabRequestDetailByRequestId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_FetchCabRequestDetailByRequestId]
GO
/****** Object:  StoredProcedure [dbo].[Proc_FetchCabInfoByCabRequestId]    Script Date: 16-12-2019 18:01:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_FetchCabInfoByCabRequestId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_FetchCabInfoByCabRequestId]
GO
/****** Object:  StoredProcedure [dbo].[Proc_CheckValidCabInputs]    Script Date: 16-12-2019 18:01:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_CheckValidCabInputs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_CheckValidCabInputs]
GO
/****** Object:  StoredProcedure [dbo].[Proc_BookOrUpdateCabRequest]    Script Date: 16-12-2019 18:01:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BookOrUpdateCabRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BookOrUpdateCabRequest]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_GetCabRequestMonthYear]    Script Date: 16-12-2019 18:01:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetCabRequestMonthYear]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GetCabRequestMonthYear]
GO
/****** Object:  UserDefinedFunction [dbo].[Fn_GetCutOffTimeForCabBooking]    Script Date: 16-12-2019 18:01:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fn_GetCutOffTimeForCabBooking]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fn_GetCutOffTimeForCabBooking]
GO
/****** Object:  UserDefinedFunction [dbo].[Fn_GetCutOffTimeForCabBooking]    Script Date: 16-12-2019 18:01:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fn_GetCutOffTimeForCabBooking]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/*  
   Created Date      :     15-Mar-2019
   Created By        :     Kanchan Kumari
   Purpose           :    get cutoff time for cab booking
  ---------------------------------------------------------------------------------
   Test Case: 
	 SELECT * FROM [dbo].[Fn_GetCutOffTimeForCabBooking](''2019-09-11'') 
*/
CREATE FUNCTION  [dbo].[Fn_GetCutOffTimeForCabBooking]
(
 @Date DATE
)
RETURNS DATETIME
AS
BEGIN
  DECLARE @CutOff DATETIME
 SET @CutOff =  cast( @Date as datetime) + cast(convert(Time,''20:00:00.0000000'')  as datetime)
 RETURN @CutOff;
END' 
END

GO

/****** Object:  StoredProcedure [dbo].[Proc_CheckValidCabInputs]    Script Date: 16-12-2019 18:01:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_CheckValidCabInputs]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_CheckValidCabInputs] AS' 
END
GO
/***
   Created Date :  10-July-2019
   Created By   :  Kanchan Kumari
   Purpose      :  Validates inputs for cab booing
   Usage        :  

   DECLARE @Result int , @Msg VARCHAR(100)
   EXEC [dbo].[Proc_CheckValidCabInputs] 
   @UserId = 2432,
   @DateId = 11544,
   @RouteNo = 2,
   @ShiftId = 2,
   @LocationId = 7,
   @CompanyLocationId = 1,
   @ServiceTypeId = 1,
   @Success  = @Result out,
   @Message  = @Msg out
   SELECT @Result AS [RESULT],  @Msg AS Msg

***/
ALTER PROC [dbo].[Proc_CheckValidCabInputs]
(
 @UserId INT
,@DateId BIGINT
,@ShiftId INT
,@RouteNo INT
,@LocationId INT
,@CompanyLocationId INT
,@ServiceTypeId INT
,@Success tinyint = 0 output
,@Message  VARCHAR(100) output
)
AS
BEGIN 

   IF OBJECT_ID('tempdb..#TempValidDate') IS NOT NULL
   DROP TABLE #TempValidDate

   IF OBJECT_ID('tempdb..#TempShift') IS NOT NULL
   DROP TABLE #TempShift

   IF OBJECT_ID('tempdb..#TempRouteLocation') IS NOT NULL
   DROP TABLE #TempRouteLocation

	CREATE TABLE #TempValidDate
	(
	   DateText VARCHAR(13) NOT NULL,
	   [Date] DATE NOT NULL,
	   DateId BIGINT NOT NULL,
	   [Day] VARCHAR(100) NOT NULL 
	)	

	CREATE TABLE #TempShift
	(
		[ShiftId] INT NOT NULL,
	    [ShiftName] VARCHAR(30) NOT NULL,
		[NewShiftId] VARCHAR(30) NOT NULL
	)

	CREATE TABLE #TempRouteLocation
	(
	  CabPDLocationId INT NOT NULL,
	  [RouteLocation] VARCHAR(500) NOT NULL
	)

	DECLARE @Dates VARCHAR(15), @ServiceTypeIds VARCHAR(50) = CAST((@ServiceTypeId) AS VARCHAR(10));

	SELECT @Dates = CAST([Date] AS VARCHAR(20)) FROM DateMaster WHERE DateId = @DateId

	  INSERT INTO #TempValidDate (DateText, [Date], DateId, [Day])
	  EXEC [dbo].[Proc_GetDatesForPickAndDrop] @UserId = @UserId, @ServiceTypeId = @ServiceTypeId, @ForScreen = 'USER'

	  
	  INSERT INTO #TempShift ([ShiftId], [ShiftName],[NewShiftId])
	  EXEC [dbo].[Proc_GetCabShift] @UserId = @UserId, @Dates = @Dates, @ServiceTypeIds = @ServiceTypeIds , @ForScreen = 'USER'

	   INSERT INTO #TempRouteLocation (CabPDLocationId, [RouteLocation])
	   EXEC [dbo].[Proc_GetRouteLocationForCab] @LocationId = @CompanyLocationId, @RouteNo = @RouteNo, @ServiceTypeId = @ServiceTypeId

	  IF EXISTS(SELECT 1 FROM #TempValidDate WHERE [DateId] = @DateId)
	  BEGIN
	         IF EXISTS(SELECT 1 FROM #TempShift WHERE  ShiftId = @ShiftId)
			 BEGIN
			        IF EXISTS(SELECT 1 FROM #TempRouteLocation WHERE  CabPDLocationId = @LocationId)
			        BEGIN
			                  SET @Success = 1
							  SET @Message = 'Success'
			        END
					ELSE
					BEGIN
					       SET @Success = 2
						   SET @Message = 'Invalid Location'
					END
			 END
			 ELSE
			 BEGIN
			       SET @Success = 3
				   SET @Message = 'Invalid Shift'
			 END
	  END
	  ELSE
	  BEGIN
	          SET @Success = 4
			  SET @Message = 'Invalid Date'
	  END

	  SELECT @Message  =  @Message +' for ' +ServiceType 
	  FROM CabServiceType WHERE ServiceTypeId = @ServiceTypeId
END

GO

/****** Object:  StoredProcedure [dbo].[Proc_TakeActionOnCabRequest]    Script Date: 16-12-2019 18:01:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TakeActionOnCabRequest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_TakeActionOnCabRequest] AS' 
END
GO
/*  
   Created Date      : 15-Mar-2019
   Created By        : Kanchan Kumari
   Purpose           : To take action on cab  request
   ---------------------------------------------------
	DECLARE @Result int 
    EXEC [dbo].[Proc_TakeActionOnCabRequest]
	@LoginUserId = 2432
   ,@CabRequestId= 1
   ,@Remarks = 'Cancelled'
   ,@ForScreen = 'ADMIN'
   ,@StatusCode='CA'
   ,@Success = @Result output
SELECT @Result AS [RESULT]
*/

ALTER PROCEDURE  [dbo].[Proc_TakeActionOnCabRequest]
(	
	 @CabRequestId BIGINT
	,@StatusCode VARCHAR(5)
	,@Remarks VARCHAR(500)
	,@ForScreen VARCHAR(20)
	,@LoginUserId INT
    ,@Success tinyInt = 0 output
)
AS
BEGIN TRY	
 SET NOCOUNT ON;
         
     DECLARE @Today DATE = GETDATE(), @CurrentDate DATETIME =  GETDATE(), @StatusId INT, @NewSatusId INT, @EmployeeId INT, 
	   @FirstReportingId INT, @HRId INT;
	 DECLARE @TodayCuttOff DATETIME = ( SELECT [dbo].[Fn_GetCutOffTimeForCabBooking](@Today))
     SELECT @StatusId = StatusId FROM CabStatusMaster WHERE StatusCode = @StatusCode
	 SET @NewSatusId = @StatusId

	 SELECT @EmployeeId = [UserId] FROM [dbo].[CabRequest] WITH (NOLOCK) WHERE CabRequestId = @CabRequestId
	 SET @HRId = (SELECT [dbo].[fnGetHRIdByUserId](@EmployeeId));
	 SET @FirstReportingId = (SELECT [dbo].[fnGetReportingManagerByUserId](@EmployeeId))

	 IF(@FirstReportingId = 0 OR @FirstReportingId = 1)
				BEGIN
	   					SET @FirstReportingId = @HRId
				END
	
	 IF(@StatusCode = 'AP')
	 BEGIN
	        SELECT @NewSatusId =  StatusId FROM CabStatusMaster WHERE StatusCode = 'PF'

	 END

     IF(@CurrentDate > @TodayCuttOff AND @ForScreen != 'ADMIN')
	 BEGIN
	      SET @Success = 3  ----beyond cutoff time
	 END
	 ELSE
	 BEGIN
		  BEGIN TRANSACTION
				 IF(@StatusCode = 'CA' AND @EmployeeId = @LoginUserId )
				  BEGIN
				           INSERT INTO CabRequestHistory (CabRequestId, Remarks, StatusId, [Status], CreatedBy)
							SELECT @CabRequestId, @Remarks, @StatusId, @StatusCode, @LoginUserId FROM [CabRequest]
							WHERE [CabRequestId] = @CabRequestId AND StatusId <= 5 --Finalized

							UPDATE [dbo].[CabRequest] SET
								[StatusId] = @NewSatusId,
								[ApproverId] = NULL,
								[LastModifiedDate] = GETDATE(),
								[LastModifiedBy] = @LoginUserId
							WHERE [CabRequestId] = @CabRequestId AND StatusId < 5 --till pending for Finalization

							SET @Success=1;	
				  END
				  ELSE IF (@StatusCode = 'AP' AND (@FirstReportingId = @LoginUserId OR @ForScreen = 'ADMIN'))
				  BEGIN
				            INSERT INTO CabRequestHistory (CabRequestId, Remarks, StatusId, [Status], CreatedBy)
							SELECT @CabRequestId, @Remarks, @StatusId, @StatusCode, @LoginUserId FROM [CabRequest]
							WHERE [CabRequestId] = @CabRequestId AND StatusId = 2  --pending for approval

							UPDATE [dbo].[CabRequest] SET
								[StatusId] = @NewSatusId,
								[ApproverId] = NULL,
								[LastModifiedDate] = GETDATE(),
								[LastModifiedBy] = @LoginUserId
							WHERE [CabRequestId] = @CabRequestId AND StatusId = 2 --pending for approval

							SET @Success=1;	
				  END
				  ELSE IF(@StatusCode = 'RJ' AND (@FirstReportingId = @LoginUserId OR @ForScreen = 'ADMIN'))
				  BEGIN
				  	        INSERT INTO CabRequestHistory (CabRequestId, Remarks, StatusId, [Status], CreatedBy)
							SELECT @CabRequestId, @Remarks, @StatusId, @StatusCode, @LoginUserId FROM [CabRequest]
							WHERE [CabRequestId] = @CabRequestId AND StatusId <= 4 --till pending for Finalization

						    UPDATE [dbo].[CabRequest] SET
								[StatusId] = @NewSatusId,
								[ApproverId] = NULL,
								[LastModifiedDate] = GETDATE(),
								[LastModifiedBy] = @LoginUserId
							WHERE [CabRequestId] = @CabRequestId AND StatusId <= 4  --till pending for Finalization

							SET @Success=1;	
				  END
		 COMMIT;	
	 END
END TRY
BEGIN CATCH
	IF @@TRANCOUNT>0
	ROLLBACK TRANSACTION;
	        
		DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
		EXEC [spInsertErrorLog]
		@ModuleName = 'CabRequest'
		,@Source = '[Proc_TakeActionOnCabRequest]'
		,@ErrorMessage = @ErrorMessage
		,@ErrorType = 'SP'
		,@ReportedByUserId = @LoginUserId  

	SET @Success=0; --error occured
END CATCH


GO


/****** Object:  UserDefinedFunction [dbo].[Fun_GetCabRequestMonthYear]    Script Date: 16-12-2019 18:01:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetCabRequestMonthYear]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/***
   Created Date      :     29-06-2018
   Created By        :     Kanchan Kumari
   Purpose           :     This function return user''s month and year for cab request
   Usage			 :	   SELECT * FROM [dbo].[Fun_GetCabRequestMonthYear](2203)
   --------------------------------------------------------------------------

***/
CREATE FUNCTION [dbo].[Fun_GetCabRequestMonthYear]
(
	@UserId int
)
RETURNS @DateTable TABLE (
		[Year] INT,
		[Month] INT,
		[MnthYr] VARCHAR(15),
		[MonthYear] VARCHAR(15)
	)
AS BEGIN
    DECLARE @StartDate DATE =  DATEADD(m,-1,GETDATE()) ;
	DECLARE @EndDate DATE = GETDATE()
	INSERT INTO @DateTable ([Year], [Month], [MnthYr], [MonthYear])
	SELECT DISTINCT DATEPART(yyyy, [Date]) AS [Year], 
	             DATEPART(m, [Date]) AS [Month], 
				 CAST(DATEPART(m, [Date]) AS VARCHAR(5))+''-''+ CAST(DATEPART(yyyy, [Date]) AS VARCHAR(5)) AS [MnthYr]
	      ,CAST(DATENAME(MONTH, [Date]) AS VARCHAR(100))+'' ''+ CAST(DATEPART(yyyy, [Date]) AS VARCHAR(5)) AS [MonthYear]
		  FROM DateMaster WHERE [Date] BETWEEN @StartDate AND @EndDate
		  RETURN
END' 
END

GO
/****** Object:  StoredProcedure [dbo].[Proc_BookOrUpdateCabRequest]    Script Date: 16-12-2019 18:01:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BookOrUpdateCabRequest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_BookOrUpdateCabRequest] AS' 
END
GO
/*  
   Created Date : 15-Mar-2019
   Created By   : Kanchan Kumari
   Purpose      : To book cab
   -----------------------------
   Test Case    : 
   DECLARE @Result int , @Msg VARCHAR(100), @ReqId INT
   EXEC [dbo].[Proc_BookOrUpdateCabRequest]
      @CabRequestId  = 0 
     ,@UserId = 2432
     ,@Date = '2019-12-09'
     ,@ShiftId = 2
     ,@RouteNo = 2
     ,@LocationId = 6
     ,@LocationDetail ='5tyhf'
     ,@ServiceTypeId = 1
     ,@CompanyLocationId = 1
     ,@EmpContactNo = '8978575757'
     ,@Success  = @Result out
     ,@Message  = @Msg out
	 ,@NewCabRequestId = @ReqId out
   SELECT @Result AS [RESULT],  @Msg AS Msg, @ReqId AS RequestId

*/

ALTER PROC [dbo].[Proc_BookOrUpdateCabRequest](
 @CabRequestId BIGINT
,@UserId INT
,@Date DATE
,@ShiftId INT
,@RouteNo INT
,@LocationId INT
,@LocationDetail VARCHAR(200)
,@ServiceTypeId INT
,@CompanyLocationId INT
,@EmpContactNo VARCHAR(15)
,@Success tinyInt = 0 output
,@Message VARCHAR(100) output
,@NewCabRequestId int = 0 output
)
AS
BEGIN TRY
  BEGIN TRANSACTION
	   DECLARE  @HRId INT, @TillDateId BIGINT, @RMId INT, @StatusId INT, @DateId BIGINT;
				SELECT @StatusId = StatusId FROM CabStatusMaster WHERE StatusCode='PA'
				SET @RMId = (SELECT [dbo].[fnGetReportingManagerByUserId](@UserId)) 
				SET @HRId = (SELECT [dbo].[fnGetHRIdByUserId](@UserId));
    SELECT @DateId = DateId FROM DateMaster WHERE [Date] = @Date
	DECLARE @Today DATE = GETDATE(), @CurrentDate DATETIME =  GETDATE();
	DECLARE @TodayCuttOff DATETIME = (SELECT [dbo].Fn_GetCutOffTimeForCabBooking(@Today))
   
  
   DECLARE @Res int, @Msg varchar(100);

   EXEC [dbo].[Proc_CheckValidCabInputs] @UserId = @UserId, @DateId = @DateId, @ShiftId = @ShiftId, @RouteNo = @RouteNo, @LocationId = @LocationId,
                                         @CompanyLocationId = @CompanyLocationId, @ServiceTypeId = @ServiceTypeId, @Success = @Res out, @Message = @Msg out
   
	IF(@CurrentDate > @TodayCuttOff)	
	BEGIN
	      SET @Success = 3  ----beyond booking time
		  SET @Message = 'Beyond cutoff time'
	END
	ELSE
	BEGIN
	      IF(@Res = 1)
          BEGIN
				IF(@RMId = 0 OR @RMId = 1)
				BEGIN
	   					SET @RMId = @HRId
				END
	
				IF EXISTS(SELECT 1
						  FROM [dbo].[CabRequest] CR 
						  JOIN [dbo].[CabShiftMaster] CS ON CR.CabShiftId = CS.CabShiftId 
						  JOIN [dbo].[CabStatusMaster] S
						  ON CR.[StatusId] = S.[StatusId]
						  WHERE CR.[UserId] = @UserId  AND CS.ServiceTypeId = @ServiceTypeId
						  AND DateId = @DateId AND S.[StatusCode] NOT IN('CA','RJ')
						  AND @CabRequestId = 0
						  )	  
				BEGIN
					SET @Success = 2 --Already exists
					SET @Message = 'Already exists'
				END
				ELSE
				BEGIN
					  IF(@CabRequestId = 0)
					  BEGIN
							 INSERT INTO CabRequest (UserId, DateId, EmpContactNo, CabShiftId, CabPDLocationId, LocationDetail, StatusId, ApproverId, CreatedBy)
										VALUES(@UserId, @DateId, @EmpContactNo, @ShiftId, @LocationId, @LocationDetail, @StatusId, @RMId, @UserId)
                              SET @NewCabRequestId = SCOPE_IDENTITY();

                             INSERT INTO CabRequestHistory (CabRequestId, Remarks, StatusId, [Status],  CreatedBy)
										VALUES(@NewCabRequestId, 'Applied', 1, 'AD', @UserId)
                            
							 SET @Success=1 ----booked successfully
							 SET @Message = 'Booked successfully'
					  END
					  ELSE
					  BEGIN
							 UPDATE CabRequest
							 SET CabShiftId = @ShiftId, CabPDLocationId = @LocationId, 
								LocationDetail = @LocationDetail, LastModifiedBy = @UserId,
								LastModifiedDate = GETDATE()

						   SET @Success=1 ----updated successfully
						   SET @Message = 'Updated successfully'
					  END
				END
          END
		  ELSE
		  BEGIN
			   SET @Success = 4 -- invalid inputs
			   SELECT @Message = @Msg
		  END
   END

 COMMIT;
END TRY
BEGIN CATCH
	IF @@TRANCOUNT>0
	ROLLBACK TRANSACTION;

	SET @Success = 0 -- Error occurred
	SET @Message = 'Error occurred'
	SET @NewCabRequestId = 0
	DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
	--Log Error
	EXEC [spInsertErrorLog]
			@ModuleName = 'Cab Request'
		,@Source = 'Proc_BookOrUpdateCabRequest'
		,@ErrorMessage = @ErrorMessage
		,@ErrorType = 'SP'
		,@ReportedByUserId = @UserId
   
END CATCH


GO

/****** Object:  StoredProcedure [dbo].[Proc_FetchCabInfoByCabRequestId]    Script Date: 16-12-2019 18:01:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_FetchCabInfoByCabRequestId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_FetchCabInfoByCabRequestId] AS' 
END
GO
/*  
   Created Date      : 10-DEC-2019
   Created By        : Kanchan Kumari
   Purpose           : To finalize cab request
   ---------------------------------------------------
    EXEC [dbo].[Proc_FetchCabInfoByCabRequestId]
	@CabRequestIds= '1'
*/

ALTER Proc [dbo].[Proc_FetchCabInfoByCabRequestId]
(
 @CabRequestIds VARCHAR(8000)
)
AS
BEGIN 
   SET FMTONLY OFF;
   SET NOCOUNT ON;
   
   IF OBJECT_ID('tempdb..#TempCabRequest') IS NOT NULL
   DROP TABLE #TempCabRequest

   IF OBJECT_ID('tempdb..#TempRequests') IS NOT NULL
   DROP TABLE #TempRequests
  
 
         CREATE TABLE #TempRequests
		 (
		 [CabRequestId] BIGINT
		 )

		 INSERT INTO #TempRequests([CabRequestId])
		 SELECT SplitData FROM [dbo].[Fun_SplitStringStr](@CabRequestIds, ',') 
	      
	   SELECT UD.EmployeeName, UD.EmployeeFirstName, CONVERT(VARCHAR(13), DM.[Date], 106) AS [Date], 
	          M.EmployeeName AS RMName, M.UserId AS RMId, M.EmailId AS RMEmailId, M.EmployeeFirstName AS RMFirstName,
			   CS.CabShiftName AS [Shift], CT.ServiceType, DL.RouteLocation,
			  CONVERT(VARCHAR(15), R.CreatedDate, 106)+' '+FORMAT(R.CreatedDate, 'hh:mm tt') AS CreatedDate,
			  ISNULL(R.EmpContactNo,'') AS EmpContactNo, UD.EmailId,  L.LocationName AS CompanyLocation
		FROM #TempRequests T JOIN CabRequest R ON T.CabRequestId = R.CabRequestId
		JOIN CabPickDropLocation DL ON R.CabPDLocationId = DL.CabPDLocationId
		JOIN CabStatusMaster S ON R.StatusId = S.StatusId
		JOIN CabShiftMaster CS ON R.CabShiftId = CS.CabShiftId 
		JOIN CabServiceType CT ON CS.ServiceTypeId = CT.ServiceTypeId
		JOIN DateMaster DM ON R.DateId = DM.DateId
		JOIN Location L ON DL.LocationId = L.LocationId
		JOIN vwAllUsers UD ON R.UserId = UD.UserId
		JOIN vwAllUsers M ON UD.RMId = M.UserId
		
END 
GO
/****** Object:  StoredProcedure [dbo].[Proc_FetchCabRequestDetailByRequestId]    Script Date: 16-12-2019 18:01:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_FetchCabRequestDetailByRequestId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_FetchCabRequestDetailByRequestId] AS' 
END
GO
/*  
   Created Date      : 10-DEC-2019
   Created By        : Kanchan Kumari
   Purpose           : To finalize cab request
   ---------------------------------------------------
    EXEC [dbo].[Proc_FetchCabRequestDetailByRequestId]
	@FCRequestId= 1
*/

ALTER Proc [dbo].[Proc_FetchCabRequestDetailByRequestId]
(
 @FCRequestId BIGINT
)
AS
BEGIN 
   SET FMTONLY OFF;
   SET NOCOUNT ON;
   
   IF OBJECT_ID('tempdb..#TempCabRequest') IS NOT NULL
   DROP TABLE #TempCabRequest

   IF OBJECT_ID('tempdb..#TempRequests') IS NOT NULL
   DROP TABLE #TempRequests
   DECLARE @CabRequestIds VARCHAR(2000), @Vehicle VARCHAR(100)
 
       SELECT @CabRequestIds = CabRequestIds, @Vehicle = V.Vehicle
	   FROM FinalizedCabRequest F JOIN VehicleDetails V ON F.VehicleId = V.VehicleId
	   WHERE FCRequestId = @FCRequestId

         CREATE TABLE #TempRequests
		 (
		 [CabRequestId] BIGINT
		 )

		 INSERT INTO #TempRequests([CabRequestId])
		 SELECT SplitData FROM [dbo].[Fun_SplitStringStr](@CabRequestIds, ',') 
	      
	   SELECT UD.EmployeeName,ISNULL(R.EmpContactNo,'') AS EmpContactNo, UD.EmployeeFirstName, CONVERT(VARCHAR(13), DM.[Date], 106) AS [Date], 
	          UD.ReportingManagerName AS RMName, CS.CabShiftName AS [Shift], CT.ServiceType, DL.RouteLocation,
			  CONVERT(VARCHAR(15), R.CreatedDate, 106)+' '+FORMAT(R.CreatedDate, 'hh:mm tt') AS CreatedDate,
			  UD.EmailId, @Vehicle AS Vehicle, L.LocationName AS CompanyLocation
		FROM #TempRequests T JOIN CabRequest R ON T.CabRequestId = R.CabRequestId
		JOIN CabPickDropLocation DL ON R.CabPDLocationId = DL.CabPDLocationId
		JOIN CabStatusMaster S ON R.StatusId = S.StatusId
		JOIN CabShiftMaster CS ON R.CabShiftId = CS.CabShiftId 
		JOIN CabServiceType CT ON CS.ServiceTypeId = CT.ServiceTypeId
		JOIN DateMaster DM ON R.DateId = DM.DateId
		JOIN Location L ON DL.LocationId = L.LocationId
		JOIN vwAllUsers UD ON R.UserId = UD.UserId
END 
GO
/****** Object:  StoredProcedure [dbo].[Proc_FinalizeCabRequest]    Script Date: 16-12-2019 18:01:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_FinalizeCabRequest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_FinalizeCabRequest] AS' 
END
GO
/*  
   Created Date      : 10-DEC-2019
   Created By        : Kanchan Kumari
   Purpose           : To finalize cab request
   ---------------------------------------------------
    EXEC [dbo].[Proc_FinalizeCabRequest]
	@CabRequestIds= '1,2,3',
    @StaffId  = 1,
    @StaffName = 'HHHHHHHHH',
    @MobileNo = '9099999999',
    @VehicleId = 1,
	@LoginUserId = 2432

*/

ALTER Proc [dbo].[Proc_FinalizeCabRequest]
(
 @CabRequestIds VARCHAR(1000),
 @StaffId BIGINT,
 @StaffName VARCHAR(100),
 @MobileNo VARCHAR(100),
 @VehicleId INT,
 @LoginUserId INT
)
AS
BEGIN TRY
   SET FMTONLY OFF;
   SET NOCOUNT ON;
   
   IF OBJECT_ID('tempdb..#TempCabRequest') IS NOT NULL
   DROP TABLE #TempCabRequest

   IF OBJECT_ID('tempdb..#TempResponse') IS NOT NULL
   DROP TABLE #TempResponse

        CREATE TABLE #TempCabRequest
		(
		 Id INT IDENTITY(1,1),
		 [CabRequestId] INT,
		 [StatusCode] VARCHAR(10),
		 StatusId INT,
		 )

		CREATE TABLE #TempResponse
		(
		 [CabRequestId] INT,
		 [Success] INT,
		 [Msg] VARCHAR(100)
		)
	 BEGIN TRANSACTION
	      
	 INSERT INTO #TempCabRequest([CabRequestId])
	 SELECT SplitData FROM [dbo].[Fun_SplitStringStr](@CabRequestIds, ',') 

	 DECLARE @StatusId INT
	 SELECT @StatusId = [StatusId] FROM CabStatusMaster WHERE [Status] = 'Finalized'

	 UPDATE T SET T.StatusId = CS.StatusId, T.StatusCode = CS.StatusCode
	 FROM #TempCabRequest T JOIN  CabRequest CR 
	 ON  T.CabRequestId = CR.CabRequestId
	 JOIN CabStatusMaster CS ON CR.StatusId = CS.StatusId 

	 UPDATE CR SET CR.StatusId = @StatusId, CR.[ApproverId] = NULL,
	 CR.[LastModifiedDate] = GETDATE(),
	 CR.[LastModifiedBy] = @LoginUserId
	 FROM CabRequest CR JOIN #TempCabRequest T ON CR.CabRequestId = T.CabRequestId 
	 WHERE T.StatusCode = 'PF' -- Pending finalization

	  INSERT INTO CabRequestHistory (CabRequestId, Remarks, StatusId, [Status], CreatedBy)
	  SELECT CR.CabRequestId, 'Finalized', CR.StatusId, CS.StatusCode, @LoginUserId
	  FROM CabRequest CR JOIN #TempCabRequest T ON CR.CabRequestId = T.CabRequestId 
	  JOIN CabStatusMaster CS ON CR.StatusId = CS.StatusId 
	  WHERE CS.StatusCode = 'FD' -- finalized
	
	 
	 INSERT INTO FinalizedCabRequest(VehicleId, StaffId, StaffName, StaffContactNo, CreatedBy, CabRequestIds)
	 SELECT DISTINCT @VehicleId, @StaffId, @StaffName, @MobileNo, @LoginUserId, 
	 STUFF( (SELECT ','+ CAST(CR.CabRequestId AS VARCHAR(8000))  
	        FROM CabRequest CR JOIN #TempCabRequest T ON CR.CabRequestId = T.CabRequestId 
	       JOIN CabStatusMaster CS ON CR.StatusId = CS.StatusId 
	        WHERE CS.StatusCode = 'FD' -- finalized
			FOR XML PATH('')),  1,1,'' 
			)
	 FROM CabRequest CR JOIN #TempCabRequest T ON CR.CabRequestId = T.CabRequestId 
	 JOIN CabStatusMaster CS ON CR.StatusId = CS.StatusId 
	 WHERE CS.StatusCode = 'FD' -- finalized

	 DECLARE @FCRequestId BIGINT = SCOPE_IDENTITY();

	  INSERT INTO #TempResponse([CabRequestId], [Success], [Msg])
	  SELECT T.CabRequestId, 
	  CASE WHEN CR.CabRequestId IS NULL THEN 2 ELSE 1 END, 
	  CASE WHEN CR.CabRequestId IS NULL THEN 'unable to process request'
	       ELSE 'finalized sucessfully'
	  END
	 FROM #TempCabRequest T LEFT JOIN CabRequest CR ON T.CabRequestId = CR.CabRequestId 
	 JOIN CabStatusMaster CS ON CR.StatusId = CS.StatusId 
	 WHERE CS.StatusCode = 'FD' -- finalized
 COMMIT TRANSACTION;
  
   SELECT [CabRequestId], [Success], [Msg], @FCRequestId AS FCRequestId FROM #TempResponse

END TRY
BEGIN CATCH
   IF @@TRANCOUNT> 0
   ROLLBACK TRANSACTION;
   
    DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
		EXEC [spInsertErrorLog]
		@ModuleName = 'CabRequest'
		,@Source = '[Proc_FinalizeCabRequest]'
		,@ErrorMessage = @ErrorMessage
		,@ErrorType = 'SP'
		,@ReportedByUserId = @LoginUserId  
		 
    SELECT [CabRequestId], CAST(0 AS INT) AS [Success], 'Error Occured' AS Msg, CAST(0 AS INT) AS FCRequestId 
	FROM #TempCabRequest 
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetCabRequestDetail]    Script Date: 16-12-2019 18:01:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetCabRequestDetail]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetCabRequestDetail] AS' 
END
GO
/*  
   Created Date   : 2018-06-25
   Created By     : Kanchan Kumari
   Purpose        : This stored procedure is used to get the cab request detail
   Change History : 
   --------------------------------------------------------------------------
   Test Case: 
	   EXEC [dbo].[Proc_GetCabRequestDetail]
	   @EmployeeId=2432,
       @Month=12,
       @Year=2019
*/
ALTER PROC [dbo].[Proc_GetCabRequestDetail](
@EmployeeId INT, 
@Month INT,
@Year INT
)
AS
BEGIN 
         DECLARE @StartDate [date], @EndDate [date]
	     SELECT @StartDate = DATEADD(MONTH, @Month - 1, DATEADD(YEAR, @Year - 1900, 0)) 
		     ,@EndDate = DATEADD(DAY ,-1, DATEADD(MONTH, @Month, DATEADD(YEAR, @Year - 1900, 0))) 

	    SELECT R.CabRequestId, UD.EmployeeName, S.StatusCode, S.[Status], S.[StatusId], DM.[Date],
			CONVERT(VARCHAR(15), R.CreatedDate, 106)+' '+FORMAT(R.CreatedDate, 'hh:mm tt') AS CreatedDate,
			CS.CabShiftName AS [Shift], CS.CabShiftId AS ShiftId, CS.ServiceTypeId,  CT.ServiceType, 
			DL.LocationId AS CompanyLocationId, DL.RouteLocation, DL.RouteNo, R.LocationDetail, DL.CabPDLocationId AS RouteLocationId
		   ,ISNULL(M.EmployeeName,'') AS Approver, R.EmpContactNo
		FROM CabRequest R
		JOIN CabPickDropLocation DL ON R.CabPDLocationId = DL.CabPDLocationId
		JOIN CabStatusMaster S ON R.StatusId = S.StatusId
		JOIN CabShiftMaster CS ON R.CabShiftId = CS.CabShiftId 
		JOIN CabServiceType CT ON CS.ServiceTypeId = CT.ServiceTypeId
		JOIN DateMaster DM ON R.DateId = DM.DateId
		JOIN vwAllUsers UD ON R.UserId = UD.UserId
		LEFT JOIN vwAllUsers M ON R.ApproverId = M.UserId
		WHERE R.CreatedBy = @EmployeeId AND DM.[Date] BETWEEN @StartDate AND @EndDate
		ORDER by DM.[DateId] DESC 
END

GO
/****** Object:  StoredProcedure [dbo].[Proc_GetCabRequestToFinalize]    Script Date: 16-12-2019 18:01:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetCabRequestToFinalize]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetCabRequestToFinalize] AS' 
END
GO
/*  
   Created Date      :     15-Mar-2019
   Created By        :     Kanchan Kumari
   Purpose           :     To get the cab request detail
  ---------------------------------------------------------------------------------
   Test Case: 
	  EXEC [dbo].[Proc_GetCabRequestToFinalize]
      @Date='2018-06-29',
	  @CompanyLocationId  = 1,
      @ShiftId = 1,
	  @LoginUserId = 1
*/

ALTER PROC [dbo].[Proc_GetCabRequestToFinalize](
@Date VARCHAR(20),
@CompanyLocationId INT,
@ShiftId INT,
@LoginUserId INT
)
AS 
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;

   IF OBJECT_ID('tempdb..#TempCabRquest') IS NOT NULL
   DROP TABLE #TempCabRquest

CREATE TABLE #TempCabRquest
(
   CabRequestId BIGINT NOT NULL,
   EmployeeName VARCHAR(100) NOT NULL,
   StatusCode VARCHAR(20) NOT NULL,
   [Status] VARCHAR(100)NOT NULL,
   [StatusId] INT NOT NULL,
   [Date] DATE NOT NULL,
   CreatedDate VARCHAR(20) NOT NULL,
   [Shift] VARCHAR(30) NOT NULL,
   ShiftId INT NOT NULL,
   ServiceTypeId INT NOT NULL,
   ServiceType VARCHAR(20) NOT NULL,
   CompanyLocationId INT NOT NULL,
   CompanyLocation VARCHAR(100) NOT  NULL,
   RouteLocation VARCHAR(200) NOT NULL,
   RouteLocationId INT NOT NULL,
   RouteNo INT NOT NULL, 
   LocationDetail VARCHAR(500) NOT NULL,
   EmpContactNo VARCHAR(15) NOT NULL,
   RMName VARCHAR(100)  NOT NULL

)

		INSERT INTO #TempCabRquest(CabRequestId, EmployeeName,  StatusCode, [Status], [StatusId], [Date], CreatedDate, [Shift],
		              ShiftId, ServiceTypeId, ServiceType, CompanyLocationId, CompanyLocation, RouteLocation,  RouteNo, 
					  LocationDetail, RouteLocationId, EmpContactNo, RMName)

	    SELECT R.CabRequestId, UD.EmployeeName, S.StatusCode, 
		    CASE WHEN R.ApproverId IS NOT  NULL THEN S.[Status]+' with '+ M.EmployeeName
			     ELSE S.[Status] END AS [Status], 
			S.[StatusId], DM.[Date], CONVERT(VARCHAR(15), R.CreatedDate, 106)+' '+FORMAT(R.CreatedDate, 'hh:mm tt') AS CreatedDate,
			CS.CabShiftName AS [Shift], CS.CabShiftId AS ShiftId, CS.ServiceTypeId,  CT.ServiceType, 
			DL.LocationId AS CompanyLocationId, L.LocationName,  DL.RouteLocation, DL.RouteNo, R.LocationDetail, 
			DL.CabPDLocationId AS RouteLocationId, R.EmpContactNo, UD.ReportingManagerName
			
		FROM CabRequest R
		JOIN CabPickDropLocation DL ON R.CabPDLocationId = DL.CabPDLocationId
		JOIN CabStatusMaster S ON R.StatusId = S.StatusId
		JOIN CabShiftMaster CS ON R.CabShiftId = CS.CabShiftId 
		JOIN CabServiceType CT ON CS.ServiceTypeId = CT.ServiceTypeId
		JOIN DateMaster DM ON R.DateId = DM.DateId
		JOIN vwAllUsers UD ON R.UserId = UD.UserId
		JOIN Location L ON DL.LocationId = L.LocationId
	    LEFT JOIN vwAllUsers M ON R.ApproverId = M.UserId
		WHERE R.CabShiftId = @ShiftId AND DM.[Date] = @Date AND DL.LocationId = @CompanyLocationId
		AND S.StatusCode IN('PA' ,'AP', 'PF') 
		ORDER by R.CreatedDate DESC 


		SELECT CabRequestId, EmployeeName,  StatusCode, [Status], [StatusId], [Date], CreatedDate, [Shift],
		              ShiftId, ServiceTypeId, ServiceType, CompanyLocationId, CompanyLocation, RouteLocation,  RouteNo, 
					  LocationDetail, RouteLocationId, EmpContactNo, RMName
	    FROM #TempCabRquest 
		GROUP BY CabRequestId, EmployeeName,  StatusCode, [Status], [StatusId], [Date], CreatedDate, [Shift],
		         ShiftId, ServiceTypeId, ServiceType, CompanyLocationId, CompanyLocation, RouteLocation,  RouteNo, 
			     LocationDetail, RouteLocationId, EmpContactNo,RMName
END


GO
/****** Object:  StoredProcedure [dbo].[Proc_GetCabReviewRequest]    Script Date: 16-12-2019 18:01:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetCabReviewRequest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetCabReviewRequest] AS' 
END
GO
/*  
   Created Date      :    15-Mar-2019
   Created By        :    Kanchan Kumari
   Purpose           :    To review cab request 
   --------------------------------------------------------------------------
   Test Case: 
	EXEC [dbo].[Proc_GetCabReviewRequest]
    @LoginUserId = 1108
*/

ALTER PROC [dbo].[Proc_GetCabReviewRequest](
@LoginUserId INT
)
AS 
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;

CREATE TABLE #TempCabRquest
(
   CabRequestId BIGINT NOT NULL,
   EmployeeName VARCHAR(100) NOT NULL,
   StatusCode VARCHAR(20) NOT NULL,
   [Status] VARCHAR(100)NOT NULL,
   [StatusId] INT NOT NULL,
   [Date] DATE NOT NULL,
   CreatedDate VARCHAR(20) NOT NULL,
   [Shift] VARCHAR(30) NOT NULL,
   ShiftId INT NOT NULL,
   ServiceTypeId INT NOT NULL,
   ServiceType VARCHAR(20) NOT NULL,
   CompanyLocationId INT NOT NULL,
   RouteLocation VARCHAR(200) NOT NULL,
   RouteLocationId INT NOT NULL,
   RouteNo INT NOT NULL, 
   LocationDetail VARCHAR(500) NOT NULL,
   EmpContactNo VARCHAR(15) NOT NULL

)
        
		INSERT INTO #TempCabRquest(CabRequestId, EmployeeName,  StatusCode, [Status], [StatusId], [Date], CreatedDate, [Shift],
		              ShiftId, ServiceTypeId, ServiceType, CompanyLocationId, RouteLocation,  RouteNo, 
					  LocationDetail, RouteLocationId, EmpContactNo)

		SELECT R.CabRequestId, UD.EmployeeName, S.StatusCode, S.[Status]+' with '+ M.EmployeeName AS [Status], 
		       S.[StatusId], DM.[Date], CONVERT(VARCHAR(15), R.CreatedDate, 106)+' '+FORMAT(R.CreatedDate, 'hh:mm tt') AS CreatedDate,
			   CS.CabShiftName AS [Shift], CS.CabShiftId AS ShiftId, CS.ServiceTypeId,  CT.ServiceType, 
			   DL.LocationId AS CompanyLocationId, DL.RouteLocation, DL.RouteNo, R.LocationDetail, DL.CabPDLocationId AS RouteLocationId
		      ,R.EmpContactNo
		FROM CabRequest R
		JOIN CabPickDropLocation DL ON R.CabPDLocationId = DL.CabPDLocationId
		JOIN CabStatusMaster S ON R.StatusId = S.StatusId
		JOIN CabShiftMaster CS ON R.CabShiftId = CS.CabShiftId 
		JOIN CabServiceType CT ON CS.ServiceTypeId = CT.ServiceTypeId
		JOIN DateMaster DM ON R.DateId = DM.DateId
		JOIN vwAllUsers UD ON R.UserId = UD.UserId
	    JOIN vwAllUsers M ON R.ApproverId = M.UserId
		WHERE R.ApproverId = @LoginUserId 
		ORDER by R.CreatedDate DESC 

		INSERT INTO #TempCabRquest(CabRequestId, EmployeeName,  StatusCode, [Status], [StatusId], [Date], CreatedDate, [Shift],
		              ShiftId, ServiceTypeId, ServiceType, CompanyLocationId, RouteLocation,  RouteNo, 
					  LocationDetail, RouteLocationId, EmpContactNo)

		SELECT R.CabRequestId, UD.EmployeeName, S.StatusCode, 
		CASE WHEN R.ApproverId IS NOT NULL AND S.StatusCode = 'PA' THEN S.[Status] +' with ' + M.EmployeeName
		     WHEN S.StatusCode = 'PF' THEN S.[Status] 
		     ELSE  S.[Status] +' by ' + L.EmployeeName  END AS [Status], 
			 S.[StatusId], DM.[Date],
			CONVERT(VARCHAR(15), R.CreatedDate, 106)+' '+FORMAT(R.CreatedDate, 'hh:mm tt') AS CreatedDate,
			CS.CabShiftName AS [Shift], CS.CabShiftId AS ShiftId, CS.ServiceTypeId,  CT.ServiceType, 
			DL.LocationId AS CompanyLocationId, DL.RouteLocation, DL.RouteNo, R.LocationDetail, DL.CabPDLocationId AS RouteLocationId
		    ,R.EmpContactNo
		FROM CabRequestHistory H 
		JOIN CabRequest R ON H.CabRequestId = R.CabRequestId
		JOIN CabPickDropLocation DL ON R.CabPDLocationId = DL.CabPDLocationId
		JOIN CabStatusMaster S ON R.StatusId = S.StatusId
		JOIN CabShiftMaster CS ON R.CabShiftId = CS.CabShiftId 
		JOIN CabServiceType CT ON CS.ServiceTypeId = CT.ServiceTypeId
		JOIN DateMaster DM ON R.DateId = DM.DateId
		JOIN vwAllUsers UD ON R.UserId = UD.UserId
	    LEFT JOIN vwAllUsers M ON R.ApproverId = M.UserId
		LEFT JOIN vwAllUsers L ON R.LastModifiedBy = L.UserId
		WHERE H.CreatedBy = @LoginUserId AND H.CreatedBy != R.UserId AND @LoginUserId = UD.RMId
		ORDER by R.CreatedDate DESC 

		SELECT CabRequestId, EmployeeName,  StatusCode, [Status], [StatusId], [Date], CreatedDate, [Shift],
		              ShiftId, ServiceTypeId, ServiceType, CompanyLocationId, RouteLocation,  RouteNo, 
					  LocationDetail, RouteLocationId, EmpContactNo
	    FROM #TempCabRquest 
		GROUP BY CabRequestId, EmployeeName,  StatusCode, [Status], [StatusId], [Date], CreatedDate, [Shift],
		         ShiftId, ServiceTypeId, ServiceType, CompanyLocationId, RouteLocation,  RouteNo, 
			     LocationDetail, RouteLocationId, EmpContactNo
END


GO
/****** Object:  StoredProcedure [dbo].[Proc_GetCabShift]    Script Date: 16-12-2019 18:01:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetCabShift]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetCabShift] AS' 
END
GO
/*  
   Created Date : 27-Nov-2019
   Created By   : Kanchan Kumari
   Purpose      : fetch shift for pick and drop 
   -----------------------------
   Test Case    : 
   EXEC [dbo].[Proc_GetCabShift] @UserId = 6, @Dates = '2019-12-09, 2019-12-10', @ServiceTypeIds = '1,2', @ForScreen = 'ADMIN'

*/
ALTER PROC [dbo].[Proc_GetCabShift]
(
  @UserId INT,
  @Dates [VARCHAR](500),
  @ServiceTypeIds [VARCHAR](500),
  @ForScreen VARCHAR(20)
)
AS
BEGIN
     SET NOCOUNT ON;
	 SET FMTONLY OFF;

   IF OBJECT_ID('tempdb..#TempDate') IS NOT NULL
   DROP TABLE #TempDate
   
   IF OBJECT_ID('tempdb..#TempService') IS NOT NULL
   DROP TABLE #TempService


        CREATE TABLE #TempDate
		(
		 Id INT IDENTITY(1,1),
		 [Date] DATE
		)

		CREATE TABLE #TempService
		(
		 ServiceTypeId INT 
		)

	INSERT INTO #TempDate([Date])
	SELECT SplitData FROM [dbo].[Fun_SplitStringStr](@Dates, ',') 

	INSERT INTO #TempService(ServiceTypeId)
	SELECT SplitData FROM [dbo].[Fun_SplitStringInt](@ServiceTypeIds, ',')

        IF OBJECT_ID('tempdb..#TempCabShift') IS NOT NULL
		DROP TABLE #TempCabShift

		IF OBJECT_ID('tempdb..#TempUsersCabShift') IS NOT NULL
		DROP TABLE #TempUsersCabShift

		CREATE TABLE #TempCabShift
		(
			[CabShiftId] INT NOT NULL,
			[CabShiftName] VARCHAR(30) NOT NULL,
			[IsMorning] BIT NOT NULL
		)	                  
		
		CREATE TABLE #TempUsersCabShift
		(
		  [ShiftId] INT NOT NULL,
	      [ShiftName] VARCHAR(30) NOT NULL,
		  [Date] DATE,
		  [Idx] INT
		)

		 DECLARE @Today DATE =  GETDATE(),@SelectedDate DATE , @CurrentDate DATETIME = GETDATE();
		 DECLARE @TodayCuttOff DATETIME = (SELECT [dbo].Fn_GetCutOffTimeForCabBooking(@Today))

		 DECLARE @TodayDateNAme VARCHAR(30), @SelectedDateNAme  VARCHAR(30), @IsCurrentDayWeekOff BIT;

		 --SELECT @TodayDateNAme = UPPER(DATENAME(dw, @Today))
		
		 SELECT @IsCurrentDayWeekOff = IsWeekend FROM DateMaster WHERE [Date] = @Today 
		

		INSERT INTO #TempCabShift([CabShiftId], [CabShiftName], [IsMorning])
		SELECT CabShiftId, CabShiftName, 
				CASE WHEN CabShiftName LIKE '%PM%' THEN CAST(0 AS BIT) 
					 ELSE CAST(1 AS BIT)
				END
        FROM [CabShiftMaster] CS
		JOIN #TempService TSR ON CS.ServiceTypeId = TSR.ServiceTypeId

     DECLARE @Idx INT = 1;

WHILE(@Idx <= (SELECT MAX(Id) FROM #TempDate))
BEGIN
      SELECT @SelectedDate = [Date] FROM #TempDate WHERE Id = @Idx
	  SELECT @SelectedDateNAme = UPPER(DATENAME(dw, @SelectedDate))

     IF(@ForScreen = 'ADMIN' OR (@CurrentDate <= @TodayCuttOff AND @IsCurrentDayWeekOff = 0))
	 BEGIN
			IF(@SelectedDate = @Today)
			BEGIN
				INSERT INTO #TempUsersCabShift([ShiftId], [ShiftName], [Date], [Idx])
				SELECT CabShiftId,  CONVERT(VARCHAR(11), @SelectedDate, 106)+' '+ CabShiftName  AS ShiftName
				      ,@SelectedDate, @Idx
				FROM #TempCabShift
				WHERE [IsMorning] = 0
			END
			ELSE IF(@SelectedDate > @Today AND @SelectedDateNAme NOT IN('SATURDAY', 'SUNDAY'))
			BEGIN
				INSERT INTO #TempUsersCabShift([ShiftId], [ShiftName], [Date], [Idx])
				SELECT CabShiftId,  CONVERT(VARCHAR(11), @SelectedDate, 106)+' '+ CabShiftName  AS ShiftName
				      ,@SelectedDate, @Idx
				FROM #TempCabShift
				WHERE [IsMorning] = 1
			END
			ELSE
			BEGIN
			    INSERT INTO #TempUsersCabShift([ShiftId], [ShiftName], [Date], [Idx])
				SELECT CabShiftId,  CONVERT(VARCHAR(11), @SelectedDate, 106)+' '+ CabShiftName  AS ShiftName
					  ,@SelectedDate, @Idx
				FROM #TempCabShift
			END
		
     END
SET @Idx = @Idx+1;
END	
	 SELECT T.ShiftId, T.ShiftName, CAST(T.Idx AS VARCHAR(5))+'-'+CAST(T.ShiftId AS VARCHAR(10)) AS NewShiftId
	  FROM #TempUsersCabShift T JOIN #TempCabShift C ON T.ShiftId = C.CabShiftId
	 GROUP BY T.ShiftId, T.ShiftName, T.[Date], C.[IsMorning], T.Idx
	 ORDER BY T.[Date] ASC, C.[IsMorning] ASC
END
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetDatesForPickAndDrop]    Script Date: 16-12-2019 18:01:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetDatesForPickAndDrop]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetDatesForPickAndDrop] AS' 
END
GO
/*  
   Created Date : 27-Nov-2019
   Created By   : Kanchan Kumari
   Purpose      : fetch dates for pick and drop 
   -----------------------------
   Test Case    : 
   EXEC [dbo].[Proc_GetDatesForPickAndDrop] @UserId = 2432, @ForScreen ="ADMIN" ,@ServiceTypeId = 2

*/
ALTER Proc [dbo].[Proc_GetDatesForPickAndDrop]
(
  @UserId INT,
  @ServiceTypeId INT,
  @ForScreen VARCHAR(20) 
)
AS
BEGIN
     SET FMTONLY OFF;
	 SET NOCOUNT ON;
  
     DECLARE @Today DATE = GETDATE(), @CurrentDate DATETIME =  GETDATE();
	 DECLARE @TodayCuttOff DATETIME =  (SELECT [dbo].Fn_GetCutOffTimeForCabBooking(@Today))
     DECLARE @DateNAme VARCHAR(30), @IsCurrentDayWeekOff BIT;

	 SELECT @DateNAme = UPPER(DATENAME(dw, @Today))
	 SELECT @IsCurrentDayWeekOff =  DM.IsWeekend FROM DateMaster DM WHERE [Date] = @Today
	  
    IF OBJECT_ID('tempdb..#TempDateForCab') IS NOT NULL
	DROP TABLE #TempDateForCab

	CREATE TABLE #TempDateForCab
	(
	   DateText VARCHAR(13) NOT NULL,
	   [Date] DATE NOT NULL,
	   DateId BIGINT NOT NULL,
	   [Day] VARCHAR(100) NOT NULL 
	)	                           
    
	 IF((@CurrentDate <= @TodayCuttOff OR @ForScreen = 'ADMIN') AND @IsCurrentDayWeekOff = 0)
	 BEGIN
			INSERT INTO #TempDateForCab
			SELECT Top(2) CONVERT(VARCHAR(11), DM.[Date], 106) AS DateText, DM.[Date], DM.[DateId], DM.[Day] 
			FROM [DateMaster] DM 
			WHERE DM.[Date] >= @Today 
	 END
	 
	 IF((@ForScreen = 'ADMIN' OR (@CurrentDate <= @TodayCuttOff AND @IsCurrentDayWeekOff = 0)) AND @DateNAme = 'FRIDAY')
	 BEGIN
			INSERT INTO #TempDateForCab
			SELECT Top(2) CONVERT(VARCHAR(11), DM.[Date], 106) AS DateText, DM.[Date], DM.[DateId], DM.[Day] 
			FROM [DateMaster] DM 
			WHERE DM.[Date] >= DATEADD(d,2,@Today) 
	 END
	
	IF(@ForScreen = 'ADMIN')
	BEGIN
	     SELECT TD.DateText, TD.[Date], TD.[DateId], TD.[Day]  
		 FROM #TempDateForCab TD 
	END

	IF(@ForScreen = 'USER')
	BEGIN
	     SELECT TD.DateText, TD.[Date], TD.[DateId], TD.[Day]
		 FROM #TempDateForCab TD 
		 LEFT JOIN
		 (
		   SELECT CR.DateId FROM CabRequest CR JOIN CabShiftMaster SM ON CR.CabShiftId = SM.CabShiftId  -- cabstatusmaster
		   WHERE CR.UserId = @UserId AND SM.ServiceTypeId= @ServiceTypeId AND CR.StatusId <= 5
		 ) N ON TD.DateId = N.DateId
		 WHERE N.DateId IS NULL
	END
	
END
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetFinalizedCabRequestDetail]    Script Date: 16-12-2019 18:01:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetFinalizedCabRequestDetail]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetFinalizedCabRequestDetail] AS' 
END
GO
/*  
   Created Date      :     11-DEC-2019
   Created By        :     Kanchan Kumari
   Purpose           :     To get finalized cab request detail
  ---------------------------------------------------------------------------------
   Test Case: 
	  EXEC [dbo].[Proc_GetFinalizedCabRequestDetail]
      @FCRequestId =1,
	  @ShiftId  = 1,
	  @CompanyLocationId = 1
*/

ALTER PROC [dbo].[Proc_GetFinalizedCabRequestDetail](
@FCRequestId BIGINT,
@ShiftId INT,
@CompanyLocationId INT
)
AS 
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;

   IF OBJECT_ID('tempdb..#TempCabRquest') IS NOT NULL
   DROP TABLE #TempCabRquest

   IF OBJECT_ID('tempdb..#TempDate') IS NOT NULL
   DROP TABLE #TempDate
   
   IF OBJECT_ID('tempdb..#TempLocation') IS NOT NULL
   DROP TABLE #TempLocation

   IF OBJECT_ID('tempdb..#TempShift') IS NOT NULL
   DROP TABLE #TempShift

   IF OBJECT_ID('tempdb..#TempService') IS NOT NULL
   DROP TABLE #TempService

   IF OBJECT_ID('tempdb..#TempRoute') IS NOT NULL
   DROP TABLE #TempRoute

   IF OBJECT_ID('tempdb..#TempRequestIds') IS NOT NULL
   DROP TABLE #TempRequestIds

CREATE TABLE #TempCabRquest
(
   CabRequestId BIGINT NOT NULL,
   EmployeeName VARCHAR(100) NOT NULL,
   StatusCode VARCHAR(20) NOT NULL,
   [Status] VARCHAR(100)NOT NULL,
   [StatusId] INT NOT NULL,
   [Date] DATE NOT NULL,
   CreatedDate VARCHAR(20) NOT NULL,
   [Shift] VARCHAR(30) NOT NULL,
   ShiftId INT NOT NULL,
   ServiceTypeId INT NOT NULL,
   ServiceType VARCHAR(20) NOT NULL,
   CompanyLocationId INT NOT NULL,
   CompanyLocation VARCHAR(100) NOT  NULL,
   RouteLocation VARCHAR(200) NOT NULL,
   RouteLocationId INT NOT NULL,
   RouteNo INT NOT NULL, 
   LocationDetail VARCHAR(500) NOT NULL,
   EmpContactNo VARCHAR(15) NOT NULL,
   RMName VARCHAR(100)  NOT NULL
)
	DECLARE @CabRequestIds VARCHAR(1000) ;
	SELECT @CabRequestIds = CabRequestIds FROM FinalizedCabRequest WHERE FCRequestId = @FCRequestId

   IF OBJECT_ID('tempdb..#TempRequest') IS NOT NULL
   DROP TABLE #TempRequest

		CREATE TABLE #TempRequest
		(
		 CabRequestId BIGINT
		)

	INSERT INTO #TempRequest (CabRequestId)
	SELECT SplitData FROM [dbo].[Fun_SplitStringInt](@CabRequestIds, ',')
	
		
		INSERT INTO #TempCabRquest(CabRequestId, EmployeeName,  StatusCode, [Status], [StatusId], [Date], CreatedDate, [Shift],
		              ShiftId, ServiceTypeId, ServiceType, CompanyLocationId, CompanyLocation, RouteLocation,  RouteNo, 
					  LocationDetail, RouteLocationId, EmpContactNo, RMName)

		SELECT R.CabRequestId, UD.EmployeeName, S.StatusCode, S.[Status] +' by '+ L.EmployeeName AS [Status], 
			S.[StatusId], DM.[Date], CONVERT(VARCHAR(15), R.CreatedDate, 106)+' '+FORMAT(R.CreatedDate, 'hh:mm tt') AS CreatedDate,
			CS.CabShiftName AS [Shift], CS.CabShiftId AS ShiftId, CS.ServiceTypeId,  CT.ServiceType, 
			DL.LocationId AS CompanyLocationId,  LO.LocationName, DL.RouteLocation, DL.RouteNo, R.LocationDetail, DL.CabPDLocationId AS RouteLocationId
			,R.EmpContactNo, ISNULL(UD.ReportingManagerName,'') 
		FROM CabRequest R 
		JOIN CabPickDropLocation DL ON R.CabPDLocationId = DL.CabPDLocationId
		JOIN CabStatusMaster S ON R.StatusId = S.StatusId
		JOIN CabShiftMaster CS ON R.CabShiftId = CS.CabShiftId 
		JOIN CabServiceType CT ON CS.ServiceTypeId = CT.ServiceTypeId
		JOIN DateMaster DM ON R.DateId = DM.DateId
		JOIN vwAllUsers UD ON R.UserId = UD.UserId
		JOIN Location LO ON DL.LocationId = LO.LocationId
		JOIN #TempRequest T ON R.CabRequestId = T.CabRequestId
		LEFT JOIN vwAllUsers L ON R.LastModifiedBy = L.UserId
		WHERE R.CabShiftId = @ShiftId AND DL.LocationId = @CompanyLocationId AND S.StatusCode = 'FD'
		ORDER by R.CreatedDate DESC 
	
		SELECT CabRequestId, EmployeeName,  StatusCode, [Status], [StatusId], [Date], CreatedDate, [Shift],
		              ShiftId, ServiceTypeId, ServiceType, CompanyLocationId, CompanyLocation, RouteLocation,  RouteNo, 
					  LocationDetail, RouteLocationId, EmpContactNo, RMName
	    FROM #TempCabRquest 
		GROUP BY CabRequestId, EmployeeName,  StatusCode, [Status], [StatusId], [Date], CreatedDate, [Shift],
		         ShiftId, ServiceTypeId, ServiceType, CompanyLocationId, CompanyLocation, RouteLocation,  RouteNo, 
			     LocationDetail, RouteLocationId, EmpContactNo, RMName
END
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetGroupedCabRequestToFinalize]    Script Date: 16-12-2019 18:01:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetGroupedCabRequestToFinalize]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetGroupedCabRequestToFinalize] AS' 
END
GO
/*  
   Created Date      :     15-Mar-2019
   Created By        :     Kanchan Kumari
   Purpose           :     To get the cab request detail
  ---------------------------------------------------------------------------------
   Test Case: 
	  EXEC [dbo].[Proc_GetGroupedCabRequestToFinalize]
      @Dates='2019-12-11, 2019-12-12, 2019-12-13',
	  @CompanyLocationIds  = '1,6',
	  @ServiceTypeIds = '1,2',
      @ShiftIds = '1,2,3',
	  @RouteIds = '1,2,3,4',
	  @LoginUserId = 1
*/

ALTER PROC [dbo].[Proc_GetGroupedCabRequestToFinalize](
@Dates [VARCHAR](500),
@CompanyLocationIds [VARCHAR](500),
@ServiceTypeIds [VARCHAR](500),
@ShiftIds [VARCHAR](500),
@RouteIds [VARCHAR](500),
@LoginUserId INT
)
AS 
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;

   IF OBJECT_ID('tempdb..#TempCabRquest') IS NOT NULL
   DROP TABLE #TempCabRquest

   IF OBJECT_ID('tempdb..#TempDate') IS NOT NULL
   DROP TABLE #TempDate
   
   IF OBJECT_ID('tempdb..#TempLocation') IS NOT NULL
   DROP TABLE #TempLocation

   IF OBJECT_ID('tempdb..#TempShift') IS NOT NULL
   DROP TABLE #TempShift

   IF OBJECT_ID('tempdb..#TempService') IS NOT NULL
   DROP TABLE #TempService

   IF OBJECT_ID('tempdb..#TempRoute') IS NOT NULL
   DROP TABLE #TempRoute

CREATE TABLE #TempCabRquest
(
   [Date] DATE NOT NULL,
   [Shift] VARCHAR(30) NOT NULL,
   ShiftId INT NOT NULL,
   ServiceTypeId INT NOT NULL,
   ServiceType VARCHAR(20) NOT NULL,
   CompanyLocationId INT NOT NULL,
   CompanyLocation VARCHAR(100) NOT  NULL,
   RequestCount INT NOT NULL
)

        CREATE TABLE #TempDate
		(
		 [Date] DATE 
		)

		CREATE TABLE #TempLocation
		(
		 LocationId INT 
		)

		CREATE TABLE #TempShift
		(
		 ShiftId INT 
		)

		CREATE TABLE #TempService
		(
		 ServiceTypeId INT 
		)

		CREATE TABLE #TempRoute
		(
		RouteId INT 
		)

    INSERT INTO #TempDate([Date])
	SELECT SplitData FROM [dbo].[Fun_SplitStringStr](@Dates, ',') 
		
	INSERT INTO #TempLocation(LocationId)
	SELECT SplitData FROM [dbo].[Fun_SplitStringInt](@CompanyLocationIds, ',')
			
	INSERT INTO #TempShift(ShiftId)
	SELECT SplitData FROM [dbo].[Fun_SplitStringInt](@ShiftIds, ',')

	INSERT INTO #TempService(ServiceTypeId)
	SELECT SplitData FROM [dbo].[Fun_SplitStringInt](@ServiceTypeIds, ',')

    INSERT INTO #TempRoute(RouteId)
	SELECT SplitData FROM [dbo].[Fun_SplitStringInt](@RouteIds, ',')


		INSERT INTO #TempCabRquest([Date], [Shift],ShiftId, ServiceTypeId, ServiceType, CompanyLocationId, 
		                           CompanyLocation, RequestCount)
	    SELECT  DM.[Date], CS.CabShiftName AS [Shift], CS.CabShiftId AS ShiftId, CS.ServiceTypeId,  CT.ServiceType, 
			    DL.LocationId AS CompanyLocationId, L.LocationName, Count(R.CabRequestId) AS RequestCount
		FROM CabRequest R
		JOIN CabPickDropLocation DL ON R.CabPDLocationId = DL.CabPDLocationId
		JOIN CabStatusMaster S ON R.StatusId = S.StatusId
		JOIN CabShiftMaster CS ON R.CabShiftId = CS.CabShiftId 
		JOIN CabServiceType CT ON CS.ServiceTypeId = CT.ServiceTypeId
		JOIN DateMaster DM ON R.DateId = DM.DateId
		JOIN Location L ON DL.LocationId = L.LocationId
		JOIN #TempDate TD ON DM.[Date] = TD.[Date]
		JOIN #TempLocation TL ON DL.[LocationId] = TL.LocationId
		JOIN #TempShift TS ON R.CabShiftId = TS.ShiftId
		JOIN #TempService TSR ON CS.ServiceTypeId = TSR.ServiceTypeId
		JOIN #TempRoute TR ON DL.RouteNo = TR.RouteId
		WHERE S.StatusCode IN('PA' ,'AP', 'PF') 
		GROUP BY  DM.[Date],  CS.CabShiftName , 
			     CS.CabShiftId , CS.ServiceTypeId,  CT.ServiceType, DL.LocationId , L.LocationName

		SELECT [Date], [Shift],ShiftId, ServiceTypeId, ServiceType, CompanyLocationId, CompanyLocation,RequestCount
	    FROM #TempCabRquest 
		GROUP BY [Date], [Shift], ShiftId, ServiceTypeId, ServiceType, CompanyLocationId, CompanyLocation,RequestCount
END


GO
/****** Object:  StoredProcedure [dbo].[Proc_GetGroupedFinalizedCabRequest]    Script Date: 16-12-2019 18:01:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetGroupedFinalizedCabRequest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetGroupedFinalizedCabRequest] AS' 
END
GO
/*  
   Created Date      :     11-DEC-2019
   Created By        :     Kanchan Kumari
   Purpose           :     To get finalized cab request detail
  ---------------------------------------------------------------------------------
   Test Case: 
	  EXEC [dbo].[Proc_GetGroupedFinalizedCabRequest]
      @Dates='2019-12-11, 2019-12-12, 2019-12-13',
	  @CompanyLocationIds  = '1,6',
	  @ServiceTypeIds = '1,2',
      @ShiftIds = '1,2',
	  @RouteIds = '1,2,3,4',
	  @LoginUserId = 1
*/

ALTER PROC [dbo].[Proc_GetGroupedFinalizedCabRequest](
@Dates [VARCHAR](500),
@CompanyLocationIds [VARCHAR](500),
@ServiceTypeIds [VARCHAR](500),
@ShiftIds [VARCHAR](500),
@RouteIds [VARCHAR](500),
@LoginUserId INT
)
AS 
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;

   IF OBJECT_ID('tempdb..#TempDate') IS NOT NULL
   DROP TABLE #TempDate
   
   IF OBJECT_ID('tempdb..#TempLocation') IS NOT NULL
   DROP TABLE #TempLocation

   IF OBJECT_ID('tempdb..#TempShift') IS NOT NULL
   DROP TABLE #TempShift

   IF OBJECT_ID('tempdb..#TempService') IS NOT NULL
   DROP TABLE #TempService

   IF OBJECT_ID('tempdb..#TempRoute') IS NOT NULL
   DROP TABLE #TempRoute

   IF OBJECT_ID('tempdb..#TempRequestIds') IS NOT NULL
   DROP TABLE #TempRequestIds


        CREATE TABLE #TempDate
		(
		 [Date] DATE 
		)

		CREATE TABLE #TempLocation
		(
		 LocationId INT 
		)

		CREATE TABLE #TempShift
		(
		 ShiftId INT 
		)

		CREATE TABLE #TempService
		(
		 ServiceTypeId INT 
		)

		CREATE TABLE #TempRoute
		(
		RouteId INT 
		)

		CREATE TABLE #TempRequestIds
		(
		 FCRequestId BIGINT NOT NULL,
		 RequestIds VARCHAR(1000),
		 StaffId INT,
		 StaffName VARCHAR(100),
		 StaffContactNo VARCHAR(100),
		 VehicleId INT,
		 CabRequestId BIGINT
		)

    INSERT INTO #TempDate([Date])
	SELECT SplitData FROM [dbo].[Fun_SplitStringStr](@Dates, ',') 
		
	INSERT INTO #TempLocation(LocationId)
	SELECT SplitData FROM [dbo].[Fun_SplitStringInt](@CompanyLocationIds, ',')
			
	INSERT INTO #TempShift(ShiftId)
	SELECT SplitData FROM [dbo].[Fun_SplitStringInt](@ShiftIds, ',')

	INSERT INTO #TempService(ServiceTypeId)
	SELECT SplitData FROM [dbo].[Fun_SplitStringInt](@ServiceTypeIds, ',')

    INSERT INTO #TempRoute(RouteId)
	SELECT SplitData FROM [dbo].[Fun_SplitStringInt](@RouteIds, ',')

	INSERT INTO #TempRequestIds (FCRequestId,  RequestIds, StaffId, StaffName, StaffContactNo, VehicleId, CabRequestId)
	SELECT F.FCRequestId, F.CabRequestIds, F.StaffId, F.StaffName, F.StaffContactNo, F.VehicleId,
	N.SplitData AS CabRequestId FROM FinalizedCabRequest F 
	CROSS APPLY (SELECT SplitData FROM [dbo].[Fun_SplitStringInt](F.CabRequestIds, ',')) N
	WHERE F.IsActive=1
     
		SELECT TRS.FCRequestId, S.StatusCode, S.[Status] +' by '+ L.EmployeeName AS [Status], 
		   CONVERT(VARCHAR(11), R.LastModifiedDate,106)+' '+FORMAT(R.LastModifiedDate, 'hh:mm tt') AS FinalizedOn,
			DM.[Date], CS.CabShiftName AS [Shift], CS.CabShiftId AS ShiftId, CS.ServiceTypeId,  CT.ServiceType,
			DL.LocationId, LO.LocationName,
			CASE WHEN CS.CabShiftName LIKE '%AM%' THEN  'Morning' ELSE 'Evening' END AS DayWiseShift,
			ISNULL(TRS.StaffContactNo,'') AS StaffContactNo, ISNULL(TRS.StaffName,'') AS StaffName, ISNULL(V.Vehicle,'') AS Vehicle
			,COUNT(TRS.CabRequestId) AS RequestCount
		FROM #TempRequestIds TRS JOIN CabRequest R ON TRS.CabRequestId = R.CabRequestId
		JOIN CabPickDropLocation DL ON R.CabPDLocationId = DL.CabPDLocationId
		JOIN CabStatusMaster S ON R.StatusId = S.StatusId
		JOIN CabShiftMaster CS ON R.CabShiftId = CS.CabShiftId 
		JOIN CabServiceType CT ON CS.ServiceTypeId = CT.ServiceTypeId
		JOIN DateMaster DM ON R.DateId = DM.DateId
		JOIN vwAllUsers UD ON R.UserId = UD.UserId
		JOIN Location LO ON DL.LocationId = LO.LocationId
		JOIN #TempDate TD ON DM.[Date] = TD.[Date]
		JOIN #TempLocation TL ON DL.[LocationId] = TL.LocationId
		JOIN #TempShift TS ON R.CabShiftId = TS.ShiftId
		JOIN #TempService TSR ON CS.ServiceTypeId = TSR.ServiceTypeId
		JOIN #TempRoute TR ON DL.RouteNo = TR.RouteId
		JOIN VehicleDetails V ON TRS.VehicleId = V.VehicleId
		LEFT JOIN vwAllUsers L ON R.LastModifiedBy = L.UserId
	    GROUP BY TRS.FCRequestId, R.LastModifiedDate, S.StatusCode, S.[Status], L.EmployeeName, DM.[Date], CS.CabShiftName, 
		          CS.CabShiftId, CS.ServiceTypeId,  CT.ServiceType, TRS.StaffContactNo, TRS.StaffName, V.Vehicle,
				  DL.LocationId, LO.LocationName
END


GO
/****** Object:  StoredProcedure [dbo].[Proc_GetRouteLocationForCab]    Script Date: 16-12-2019 18:01:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetRouteLocationForCab]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetRouteLocationForCab] AS' 
END
GO
/*  
   Created Date : 27-Nov-2019
   Created By   : Kanchan Kumari
   Purpose      : fetch cab route locations
   -----------------------------
   Test Case    : 
   EXEC [dbo].[Proc_GetRouteLocationForCab] @LocationId = 6, @RouteNo = 1, @ServiceTypeId =1

*/
ALTER Proc [dbo].[Proc_GetRouteLocationForCab]
(
 @LocationId INT,
 @RouteNo INT,
 @ServiceTypeId INT
)
AS
BEGIN 
    SET FMTONLY OFF;
	SET NOCOUNT ON;

	 CREATE TABLE #TempRoute
	(
	  CabPDLocationId INT NOT NULL,
	  [RouteLocation] VARCHAR(500) NOT NULL
	)

		  
    IF(@ServiceTypeId = 1) -- Pick Up
	BEGIN
			INSERT INTO #TempRoute(CabPDLocationId, [RouteLocation])
			SELECT CabPDLocationId, [RouteLocation]
			FROM CabPickDropLocation 
			WHERE RouteNo = @RouteNo AND LocationId = @LocationId
			ORDER BY [Sequence] DESC
	END
	ELSE
	BEGIN
			INSERT INTO #TempRoute(CabPDLocationId, [RouteLocation])
			SELECT CabPDLocationId, [RouteLocation]
			FROM CabPickDropLocation 
			WHERE RouteNo = @RouteNo AND LocationId = @LocationId
			ORDER BY [Sequence] ASC
	END

	SELECT CabPDLocationId, [RouteLocation] FROM #TempRoute
END
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetRoutesForCab]    Script Date: 16-12-2019 18:01:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetRoutesForCab]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetRoutesForCab] AS' 
END
GO
/*  
   Created Date : 27-Nov-2019
   Created By   : Kanchan Kumari
   Purpose      : fetch cab routes 
   -----------------------------
   Test Case    : 
   EXEC [dbo].[Proc_GetRoutesForCab] @LocationIds = '1,6', @ServiceTypeIds = '1,2'
 
*/
ALTER Proc [dbo].[Proc_GetRoutesForCab]
(
 @LocationIds VARCHAR(500),
 @ServiceTypeIds VARCHAR(100)
)
AS
BEGIN 
SET NOCOUNT ON;
SET FMTONLY OFF;

   IF OBJECT_ID('tempdb..#TempRouteNo') IS NOT NULL
   DROP TABLE #TempRouteNo

   IF OBJECT_ID('tempdb..#TempRoute') IS NOT NULL
   DROP TABLE #TempRoute

   IF OBJECT_ID('tempdb..#TempServiceType') IS NOT NULL
   DROP TABLE #TempServiceType

    CREATE TABLE #TempRouteNo
	(
	  Id INT IDENTITY(1,1),
	  RouteNo INT
	)

	CREATE TABLE #TempRoute
	(
	  RouteNo INT NOT NULL,
	  [Route] VARCHAR(1000) NOT NULL,
	  [ServiceTypeId] INT NOT NULL
	)

	 CREATE TABLE #TempServiceType
	(
	  Id INT IDENTITY(1,1),
	  ServiceTypeId INT
	)

	INSERT INTO #TempServiceType(ServiceTypeId)
	SELECT SplitData FROM [dbo].[Fun_SplitStringInt](@ServiceTypeIds, ',')


	    INSERT INTO #TempRouteNo(RouteNo)
		SELECT RouteNo FROM CabPickDropLocation 
		WHERE LocationId IN( SELECT SplitData FROM [dbo].[Fun_SplitStringInt](@LocationIds, ',') )
		GROUP BY RouteNo

		DECLARE  @ServiceId INT= 1;

  WHILE(@ServiceId <= (SELECT MAX(Id) FROM #TempServiceType))
  BEGIN		
          DECLARE @Id INT = 1, @RouteNo INT, @ServiceTypeId INT= 0;
		  SELECT @ServiceTypeId = ServiceTypeId FROM #TempServiceType WHERE Id = @ServiceId

    IF(@ServiceTypeId = 1) -- Pick Up
	BEGIN
	      
			WHILE(@Id <= (SELECT MAX(Id) FROM #TempRouteNo))
			BEGIN
				    SELECT @RouteNo = RouteNo FROM #TempRouteNo WHERE Id = @Id
					INSERT INTO #TempRoute(RouteNo,[ServiceTypeId], [Route])
					SELECT @RouteNo,@ServiceTypeId, STUFF( (SELECT ','+ CAST(RouteLocation AS VARCHAR(1000))
									FROM CabPickDropLocation 
									WHERE RouteNo = @RouteNo 
									AND LocationId IN( SELECT SplitData FROM [dbo].[Fun_SplitStringInt](@LocationIds, ',') )
									ORDER BY [Sequence] DESC
									FOR XML PATH('')),  1,1,'' ) AS [Route]
					
                SET @Id = @Id+1;
			END
	END
	ELSE
	BEGIN
	     WHILE(@Id <= (SELECT MAX(Id) FROM #TempRouteNo)) --Drop
			BEGIN
				    SELECT @RouteNo = RouteNo FROM #TempRouteNo WHERE Id = @Id

					INSERT INTO #TempRoute(RouteNo,[ServiceTypeId], [Route])
					SELECT @RouteNo, @ServiceTypeId, STUFF( (SELECT ','+ CAST(RouteLocation AS VARCHAR(1000))
									FROM CabPickDropLocation 
									WHERE RouteNo = @RouteNo 
									AND LocationId IN( SELECT SplitData FROM [dbo].[Fun_SplitStringInt](@LocationIds, ',') )
									ORDER BY [Sequence] ASC
									FOR XML PATH('')),  1,1,'' ) AS [Route]
                SET @Id = @Id+1;
			END
	END

	SET @ServiceId = @ServiceId + 1;
  END
	SELECT RouteNo, REPLACE([Route],',',' > ') AS CabRoute, CS.[ServiceTypeId], 
	CASE WHEN CS.ServiceType = 'Drop' THEN  CS.ServiceType+'-'+ CAST(RouteNo AS VARCHAR(10))
	ELSE 'Pick'+'-'+ CAST(RouteNo AS VARCHAR(10)) END AS NewRouteNo
	FROM #TempRoute T JOIN CabServiceType CS ON T.ServiceTypeId = CS.ServiceTypeId
END
GO
/****** Object:  StoredProcedure [dbo].[Proc_TakeActionOnCabBulkApprove]    Script Date: 16-12-2019 18:01:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TakeActionOnCabBulkApprove]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_TakeActionOnCabBulkApprove] AS' 
END
GO
/*  
   Created Date      :  15-Mar-2019
   Created By        :  Kanchan Kumari
   Purpose           : To take action on multiple request
   --------------------------------------------------------------------------
   Test Case: 
	EXEC [dbo].[Proc_TakeActionOnCabBulkApprove]
	 @LoginUserId = 1108
	,@RequestIds='1'
	,@StatusCode='AP'
	,@Remarks = 
*/
ALTER PROC [dbo].[Proc_TakeActionOnCabBulkApprove](
 @RequestIds varchar(500)
,@StatusCode VARCHAR(5)
,@Remarks VARCHAR(500)
,@LoginUserId INT
)
AS
BEGIN
 SET NOCOUNT ON;  
      SET FMTONLY OFF;
	    IF OBJECT_ID('tempdb..#CabStatus') IS NOT NULL
		DROP TABLE #CabStatus

	    IF OBJECT_ID('tempdb..#TempCabTable') IS NOT NULL
		DROP TABLE #TempCabTable

		DECLARE @Id int
		
		CREATE TABLE #CabStatus(
		[Id] INT IDENTITY(1, 1),
		Msg INT DEFAULT(0),
		CabRequestId BIGINT, 
		EmployeeName VARCHAR(200),
		FirstName VARCHAR(50),
		EmailId VARCHAR(100)
		)
		CREATE TABLE #TempCabTable(
		     [Id] INT IDENTITY(1, 1),
			 [CabRequestId] BIGINT
			 )

		 INSERT INTO #TempCabTable([CabRequestId]) 
		 SELECT SplitData AS [CabRequestId] FROM [dbo].[Fun_SplitStringInt] (@RequestIds,',')
		
		 DECLARE @Count int = 1
                        WHILE(@Count <= (SELECT COUNT(*) FROM #TempCabTable))
                        BEGIN
						     DECLARE @CabRequestId BIGINT, @EmployeeName VARCHAR(200), @EmailId VARCHAR(100), @FirsName VARCHAR(50)
						     SELECT  @CabRequestId = CabRequestId FROM #TempCabTable C WHERE C.[Id] = @Count
							 DECLARE @result INT

						    EXEC [dbo].[Proc_TakeActionOnCabRequest]  @CabRequestId, @StatusCode, @Remarks, 'MGR', @LoginUserId, @result OUTPUT
							INSERT INTO #CabStatus (Msg) VALUES(@result)

							 SELECT @EmployeeName = V.EmployeeName, @EmailId = V.EmailId, @FirsName = V.EmployeeFirstName
									FROM vwAllUsers V 
									JOIN CabRequest CR WITH (NOLOCK) ON
									 V.UserId = CR.CreatedBy
							        WHERE CR.[CabRequestId] = @CabRequestId

							UPDATE #CabStatus SET CabRequestId = @CabRequestId,
							                      EmployeeName = @EmployeeName,
												  FirstName = @FirsName,
												  EmailId = @EmailId
							WHERE Id = SCOPE_IDENTITY();

                        SET @Count = @Count + 1
						END
		SELECT Msg, CabRequestId, EmployeeName, FirstName, EmailId
		FROM #CabStatus 
		GROUP BY Msg, CabRequestId, EmployeeName, FirstName, EmailId
END

GO

/****** Object:  StoredProcedure [dbo].[spGetApproverRemarks]    Script Date: 16-12-2019 18:01:39 ******/
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

	EXEC [dbo].[spGetApproverRemarks] 
    @RequestId = 2
   ,@Type = 'CAB'
       
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
	ELSE IF(@Type = 'CAB')
	BEGIN
			SELECT CONVERT (VARCHAR(19),RH.[CreatedDate],106)+ ' ' + FORMAT(RH.CreatedDate,'hh:mm tt') + ' | ' + UD.[FirstName] + ' ' + UD.[LastName] + ' : ' + RH.[Remarks] AS Remarks
			FROM CabRequestHistory RH 
			JOIN CabStatusMaster S ON RH.StatusId = S.StatusId
			JOIN UserDetail UD ON RH.CreatedBy = UD.UserId
			WHERE RH.CabRequestId = @RequestId
			ORDER by RH.CreatedDate DESC, RH.CabRequestHistoryId DESC
	END
	ELSE
	 SELECT 'ERROR'  AS	[Result]
END


GO
/****** Object:  StoredProcedure [dbo].[spGetLeaveOrWfhLastRecordDetail]    Script Date: 16-12-2019 18:01:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetLeaveOrWfhLastRecordDetail]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGetLeaveOrWfhLastRecordDetail] AS' 
END
GO

/***
   Created Date      :     2015-12-24
   Created By        :     Narender Singh
   Purpose           :     This stored procedure return last leave or wfh record
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   
   --------------------------------------------------------------------------

   Test Cases        :
   --------------------------------------------------------------------------
   
   EXEC  [dbo].[spGetLeaveOrWfhLastRecordDetail]  
	@UserId = 42
	,@Type = 'CAB'


***/

ALTER PROCEDURE [dbo].[spGetLeaveOrWfhLastRecordDetail]
(
    @UserId int 
   ,@Type varchar(5)   
)
AS
BEGIN
SET NOCOUNT ON
	IF(@Type = 'WFH')
	BEGIN
		SELECT TOP 1 
            L.[Reason]
         ,UD.[MobileNumber] AS [PrimaryContactNo]
         ,L.[AlternativeContactNo] --L.[PrimaryContactNo]
		FROM [dbo].[LeaveRequestApplication] L WITH (NOLOCK)
			INNER JOIN [dbo].[LeaveRequestApplicationDetail] LD WITH (NOLOCK)
				ON L.[LeaveRequestApplicationId] = LD.[LeaveRequestApplicationId]
					INNER JOIN [dbo].[LeaveTypeMaster] LT WITH (NOLOCK)
						ON LD.[LeaveTypeId] = LT.[TypeId]
               INNER JOIN [dbo].[UserDetail] UD WITH (NOLOCK)
                  ON UD.[UserId] = @UserId
			WHERE L.[UserId] = @UserId
			AND LT.[ShortName] = @Type
			ORDER BY L.[CreatedDate] DESC
					
		END

	IF(@Type = 'LEAVE')		
	BEGIN
		SELECT TOP 1 
            L.[Reason]
         ,UD.[MobileNumber] AS [PrimaryContactNo]
         ,L.[AlternativeContactNo] --L.[PrimaryContactNo]            
		FROM [dbo].[LeaveRequestApplication] L WITH (NOLOCK)
			INNER JOIN [dbo].[LeaveRequestApplicationDetail] LD WITH (NOLOCK)
				ON L.[LeaveRequestApplicationId] = LD.[LeaveRequestApplicationId]
					INNER JOIN [dbo].[LeaveTypeMaster] LT WITH (NOLOCK)
						ON LD.[LeaveTypeId] = LT.[TypeId]
               INNER JOIN [dbo].[UserDetail] UD WITH (NOLOCK)
                  ON UD.[UserId] = @UserId
			WHERE L.[UserId] = @UserId
			AND LT.[ShortName] != 'WFH'
			ORDER BY L.[CreatedDate] DESC					
	END   
	
	IF(@Type = 'OUTING')		
	BEGIN
		SELECT TOP 1 
          R.[Reason]
         ,R.[PrimaryContactNo] AS [PrimaryContactNo]
         ,R.[AlternativeContactNo] --L.[PrimaryContactNo]            
		FROM [dbo].[OutingRequest] R WITH (NOLOCK)
		INNER JOIN [dbo].[OutingType] OT WITH (NOLOCK)
		ON R.[OutingTypeId] = OT.OutingTypeId
		WHERE R.[UserId] = @UserId
		ORDER BY R.[CreatedDate] DESC					
    END   

	IF(@Type = 'CAB')		
	BEGIN
		SELECT TOP 1 
          CAST('Cab Request' AS VARCHAR(10)) AS [Reason]
         ,UD.[MobileNumber] AS [PrimaryContactNo]
         ,R.[EmpContactNo] AS [AlternativeContactNo]   
		FROM [dbo].[CabRequest] R WITH (NOLOCK)
		INNER JOIN [dbo].[UserDetail] UD WITH (NOLOCK)
		ON R.[UserId] = UD.[UserId]
		WHERE R.[UserId] = @UserId
		ORDER BY R.[CreatedDate] DESC					
    END                    
END



GO
