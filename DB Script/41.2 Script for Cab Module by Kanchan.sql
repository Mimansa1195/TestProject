/****** Object:  StoredProcedure [dbo].[Proc_TakeActionOnCabBulkApprove]    Script Date: 20-03-2019 11:40:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TakeActionOnCabBulkApprove]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TakeActionOnCabBulkApprove]
GO
/****** Object:  StoredProcedure [dbo].[Proc_TakeActionOnCabRequest]    Script Date: 20-03-2019 11:40:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TakeActionOnCabRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TakeActionOnCabRequest]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetCabReviewRequest]    Script Date: 20-03-2019 11:40:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetCabReviewRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetCabReviewRequest]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetCabRequestToFinalize]    Script Date: 20-03-2019 11:40:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetCabRequestToFinalize]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetCabRequestToFinalize]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetCabRequestDetail]    Script Date: 20-03-2019 11:40:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetCabRequestDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetCabRequestDetail]
GO
/****** Object:  StoredProcedure [dbo].[Proc_BookOrUpdateCabRequest]    Script Date: 20-03-2019 11:40:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BookOrUpdateCabRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BookOrUpdateCabRequest]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_GetCabRequestMonthYear]    Script Date: 20-03-2019 11:40:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetCabRequestMonthYear]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GetCabRequestMonthYear]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_GetCabRequestMonthYear]    Script Date: 20-03-2019 11:40:58 ******/
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
    DECLARE @StartDate [Date] , @EndDate [Date], @Start INT, @End INT
	                           IF EXISTS(SELECT 1 FROM [CabRequest] WHERE CreatedBy = @UserId) 
	                           BEGIN
							   SET @Start = (SELECT MIN(DateId) FROM [dbo].[CabRequest] WHERE [CreatedBy] = @UserId)
							   SET @End = (SELECT MAX(DateId) FROM [dbo].[CabRequest] WHERE [CreatedBy]= @UserId)
							   SET @StartDate = (SELECT [Date] FROM [dbo].[DateMaster] WHERE DateId = @Start)
							   SET @EndDate = (SELECT [Date] FROM [dbo].[DateMaster]  WHERE DateId = @End)
							   END
							   ELSE
							   BEGIN
							   SET @StartDate = GETDATE(); 
							   SET @EndDate = GETDATE(); 
							   END

	INSERT INTO @DateTable ([Year], [Month], [MnthYr], [MonthYear])
	SELECT DISTINCT
		DATEPART(YY,[Date]) as [Year],
		DATEPART(MM,[Date]) as [Month],
		--DATENAME(MONTH,[Date]) as [MonthName],
		CAST(DATEPART(MM,[Date])  AS VARCHAR(15)) + ''-'' + CAST(DATEPART(YY,[Date]) AS VARCHAR(5))  as [MonthName],
		CAST(DATENAME(MONTH,[Date])  AS VARCHAR(15)) + '' '' + CAST(DATEPART(YY,[Date]) AS VARCHAR(5))  as [MonthYear]
	FROM [dbo].[DateMaster] D
	WHERE [Date] BETWEEN @StartDate AND @EndDate
	ORDER BY [Year] DESC, [Month] DESC
	RETURN
END' 
END

GO
/****** Object:  StoredProcedure [dbo].[Proc_BookOrUpdateCabRequest]    Script Date: 20-03-2019 11:40:58 ******/
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
   DECLARE @Result int 
   EXEC [dbo].[Proc_BookOrUpdateCabRequest]
   @CabRequestId = 0
   @UserId = 2432
  ,@Date = '2018-06-27'
  ,@DropLocationId = 1
  ,@LocationDetail = 'Sector 23 house no 2134'
  ,@ShiftId = 1
  ,@Success = @Result output
  SELECT @Result AS [RESULT]
*/

ALTER PROC [dbo].[Proc_BookOrUpdateCabRequest](
 @CabRequestId BIGINT
,@UserId INT
,@Date DATE
,@DropLocationId INT
,@LocationDetail VARCHAR(200)
,@ShiftId INT
,@Success tinyInt = 0 output
)
AS
BEGIN TRY
  BEGIN TRANSACTION
	   DECLARE @DateId BIGINT, @HRId INT, @TillDateId BIGINT, @RMId INT, @StatusId INT, 
	            @CutOffTime Time = '18:00:00.0000000', @CurrentTime Time ;
				SELECT @StatusId = StatusId FROM CabStatusMaster WHERE StatusCode='PA'
				SET @RMId = (SELECT [dbo].[fnGetReportingManagerByUserId](@UserId)) 
				SET @HRId = (SELECT [dbo].[fnGetHRIdByUserId](@UserId));
				SELECT @DateId = [DateId] FROM [dbo].[DateMaster] WHERE [Date] = @Date
	   SELECT @CurrentTime = CONVERT(TIME, GETDATE()) 
	IF(@CurrentTime > @CutOffTime)	
	BEGIN
	      SET @Success = 3  ----beyond booking time
	END
	ELSE
	BEGIN
		IF(@RMId = 0 OR @RMId = 1)
		BEGIN
	   			SET @RMId = @HRId
		END
	
		IF EXISTS(SELECT 1
				  FROM [dbo].[CabRequest] C 
				  JOIN [dbo].[CabStatusMaster] S
				  ON C.[StatusId] = S.[StatusId]
				  WHERE C.[CreatedBy] = @UserId 
				  AND DateId = @DateId AND S.[StatusCode] NOT IN('CA','RJ')
				  AND @CabRequestId = 0
				  )	  
		BEGIN
			SET @Success = 2 --Already exists
		END
		ELSE
		BEGIN
		      IF(@CabRequestId = 0)
	          BEGIN
					 INSERT INTO CabRequest (DateId, CabShiftId, DropLocationId, LocationDetail, StatusId, ApproverId, CreatedBy)
												VALUES(@DateId, @ShiftId, @DropLocationId, @LocationDetail, @StatusId, @RMId, @UserId)

					 SET @Success=1 ----booked successfully
              END
	          ELSE
	          BEGIN
				     UPDATE CabRequest
					 SET CabShiftId = @ShiftId, DropLocationId = @DropLocationId, 
						LocationDetail = @LocationDetail, LastModifiedBy = @UserId,
						LastModifiedDate = GETDATE()

				   SET @Success=1 ----updated successfully
	          END
	    END
    END
 COMMIT;
END TRY
BEGIN CATCH
	IF @@TRANCOUNT>0
	ROLLBACK TRANSACTION;

	SET @Success = 0 -- Error occurred
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
/****** Object:  StoredProcedure [dbo].[Proc_GetCabRequestDetail]    Script Date: 20-03-2019 11:40:58 ******/
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
   Created Date      :     2018-06-25
   Created By        :     Kanchan Kumari
   Purpose           :     This stored procedure is used to get the cab request detail
   Change History    :
   --------------------------------------------------------------------------
   Test Case: 
	   EXEC [dbo].[Proc_GetCabRequestDetail]
	   @EmployeeId=2432,
       @Month=4,
       @Year=2018
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

	    SELECT R.CabRequestId, UD.EmployeeName, S.StatusCode, S.[Status], DM.[Date],
			CONVERT(VARCHAR(15), R.CreatedDate, 106)+' '+FORMAT(R.CreatedDate, 'hh:mm tt') AS CreatedDate,
			CS.CabShiftName AS [Shift], CS.CabShiftId AS ShiftId,
			R.DropLocationId, DL.DropLocation, CR.CabRouteId, CR.CabRoute, R.LocationDetail
		FROM CabRequest R
		JOIN DropLocation DL ON R.DropLocationId = DL.DropLocationId
		JOIN CabRoute CR ON DL.CabRouteId = CR.CabRouteId
		JOIN CabStatusMaster S ON R.StatusId = S.StatusId
		JOIN CabShiftMaster CS ON R.CabShiftId = CS.CabShiftId 
		JOIN DateMaster DM ON R.DateId = DM.DateId
		JOIN vwAllUsers UD ON R.CreatedBy = UD.UserId
		WHERE R.CreatedBy = @EmployeeId AND DM.[Date] BETWEEN @StartDate AND @EndDate
		ORDER by DM.[DateId] DESC 
END
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetCabRequestToFinalize]    Script Date: 20-03-2019 11:40:58 ******/
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
      @ShiftId=1,
	  @RouteId = 1,
	  @LoginUserId = 1
*/

ALTER PROC [dbo].[Proc_GetCabRequestToFinalize](
@Date [VARCHAR](15),
@ShiftId INT = 0,
@RouteId INT = 0,
@LoginUserId INT
)
AS 
BEGIN
		SELECT R.CabRequestId, UD.EmployeeName, S.StatusCode, S.[Status], DM.[Date],
			CONVERT(VARCHAR(15), R.CreatedDate, 106)+' '+FORMAT(R.CreatedDate, 'hh:mm tt') AS CreatedDate,
			CS.CabShiftName AS [Shift], CS.CabShiftId,
		    R.DropLocationId, DL.DropLocation, CR.CabRouteId, CR.CabRoute, R.LocationDetail
		FROM CabRequest R
		JOIN DropLocation DL ON R.DropLocationId = DL.DropLocationId
		JOIN CabRoute CR ON DL.CabRouteId = CR.CabRouteId
		JOIN CabStatusMaster S ON R.StatusId = S.StatusId
		JOIN CabShiftMaster CS ON R.CabShiftId = CS.CabShiftId 
		JOIN DateMaster DM ON R.DateId = DM.DateId
		JOIN vwAllUsers UD ON R.CreatedBy = UD.UserId
		WHERE DM.[Date] = @Date AND (R.CabShiftId = @ShiftId OR @ShiftId = 0)
		      AND (CR.CabRouteId = @RouteId OR @RouteId = 0)
			  --AND R.LastModifiedBy != @LoginUserId
END

GO
/****** Object:  StoredProcedure [dbo].[Proc_GetCabReviewRequest]    Script Date: 20-03-2019 11:40:58 ******/
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
SELECT R.CabRequestId, UD.EmployeeName, S.StatusCode, S.[Status], DM.[Date],
			CONVERT(VARCHAR(15), R.CreatedDate, 106)+' '+FORMAT(R.CreatedDate, 'hh:mm tt') AS CreatedDate,
			CS.CabShiftName AS [Shift], CS.CabShiftId,
		    R.DropLocationId, DL.DropLocation, CR.CabRouteId, CR.CabRoute, R.LocationDetail
		FROM CabRequest R
		JOIN DropLocation DL ON R.DropLocationId = DL.DropLocationId
		JOIN CabRoute CR ON DL.CabRouteId = CR.CabRouteId
		JOIN CabStatusMaster S ON R.StatusId = S.StatusId
		JOIN CabShiftMaster CS ON R.CabShiftId = CS.CabShiftId 
		JOIN DateMaster DM ON R.DateId = DM.DateId
		JOIN vwAllUsers UD ON R.CreatedBy = UD.UserId
		WHERE R.ApproverId = @LoginUserId OR R.ApproverId IS NULL
		ORDER BY CreatedDate desc
END

GO

/****** Object:  StoredProcedure [dbo].[Proc_TakeActionOnCabRequest]    Script Date: 20-03-2019 11:40:58 ******/
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
	@UserId=1108
   ,@RequestId=28
   ,@ActionCode='CA'
   ,@Success = @Result output
SELECT @Result AS [RESULT]
*/

ALTER PROCEDURE  [dbo].[Proc_TakeActionOnCabRequest]
(	
	 @RequestId BIGINT
	,@ActionCode VARCHAR(5)
	,@LoginUserId INT
    ,@Success tinyInt = 0 output
)
AS
BEGIN TRY	
 SET NOCOUNT ON;
 BEGIN TRANSACTION
		UPDATE [dbo].[CabRequest] SET
			[StatusId] = (SELECT StatusId FROM CabStatusMaster WHERE StatusCode = @ActionCode),
			[ApproverId] = NULL,
			[LastModifiedDate] = GETDATE(),
			[LastModifiedBy] = @LoginUserId
			WHERE [CabRequestId] = @RequestId
		SET @Success=1;	
 COMMIT;
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
/****** Object:  StoredProcedure [dbo].[Proc_TakeActionOnCabBulkApprove]    Script Date: 20-03-2019 11:40:58 ******/
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
	,@requestId='1'
	,@statusCode='AP'
*/
ALTER PROC [dbo].[Proc_TakeActionOnCabBulkApprove](
 @RequestId varchar(500)
,@StatusCode VARCHAR(5)
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
		 SELECT SplitData AS [CabRequestId] FROM [dbo].[Fun_SplitStringInt] (@requestId,',')
		
		 DECLARE @Count int = 1
                        WHILE(@Count <= (SELECT COUNT(*) FROM #TempCabTable))
                        BEGIN
						     DECLARE @CabRequestId BIGINT, @EmployeeName VARCHAR(200), @EmailId VARCHAR(100), @FirsName VARCHAR(50)
						     SELECT  @CabRequestId = CabRequestId FROM #TempCabTable C WHERE C.[Id] = @Count
							 DECLARE @result INT

						    EXEC [dbo].[Proc_TakeActionOnCabRequest]  @CabRequestId, @StatusCode, @LoginUserId, @result OUTPUT
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