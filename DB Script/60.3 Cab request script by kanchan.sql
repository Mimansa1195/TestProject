--DROP PROC Proc_TakeActionOnCabRequest
--DROP PROC Fn_GetCutOffTimeForCabBooking

/****** Object:  StoredProcedure [dbo].[spSaveNewUser]    Script Date: 16-01-2020 16:29:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spSaveNewUser]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spSaveNewUser]
GO
/****** Object:  StoredProcedure [dbo].[Proc_TakeActionOnCabRequestByUser]    Script Date: 16-01-2020 16:29:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TakeActionOnCabRequestByUser]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TakeActionOnCabRequestByUser]
GO
/****** Object:  StoredProcedure [dbo].[Proc_TakeActionOnCabRequestByMGR]    Script Date: 16-01-2020 16:29:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TakeActionOnCabRequestByMGR]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TakeActionOnCabRequestByMGR]
GO
/****** Object:  StoredProcedure [dbo].[Proc_TakeActionOnCabRequestByAdmin]    Script Date: 16-01-2020 16:29:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TakeActionOnCabRequestByAdmin]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TakeActionOnCabRequestByAdmin]
GO
/****** Object:  StoredProcedure [dbo].[Proc_TakeActionOnCabBulkApprove]    Script Date: 16-01-2020 16:29:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TakeActionOnCabBulkApprove]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TakeActionOnCabBulkApprove]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetDatesForPickAndDrop]    Script Date: 16-01-2020 16:29:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetDatesForPickAndDrop]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetDatesForPickAndDrop]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetCabShift]    Script Date: 16-01-2020 16:29:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetCabShift]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetCabShift]
GO
/****** Object:  StoredProcedure [dbo].[Proc_BookOrUpdateCabRequest]    Script Date: 16-01-2020 16:29:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BookOrUpdateCabRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BookOrUpdateCabRequest]
GO
/****** Object:  StoredProcedure [dbo].[Proc_ActionCutOffTimeInfo]    Script Date: 16-01-2020 16:29:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_ActionCutOffTimeInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_ActionCutOffTimeInfo]
GO
/****** Object:  UserDefinedFunction [dbo].[Fn_GetCutOffTimeValidityForCabBooking]    Script Date: 16-01-2020 16:29:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fn_GetCutOffTimeValidityForCabBooking]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fn_GetCutOffTimeValidityForCabBooking]
GO
/****** Object:  UserDefinedFunction [dbo].[Fn_GetCutOffTimeValidityForCabBooking]    Script Date: 16-01-2020 16:29:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fn_GetCutOffTimeValidityForCabBooking]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/*  
   Created Date      :     15-Mar-2019
   Created By        :     Kanchan Kumari
   Purpose           :    get cutoff time for cab booking
  ---------------------------------------------------------------------------------
   Test Case: 
	 SELECT * FROM [dbo].[Fn_GetCutOffTimeValidityForCabBooking](''2019-09-11'', ''MGR'')
*/
CREATE FUNCTION [dbo].[Fn_GetCutOffTimeValidityForCabBooking]
(
 @Date DATE,
 @ForScreen VARCHAR(20) 
)
RETURNS @IsValidTable TABLE(IsValid BIT) 
AS
BEGIN
 DECLARE @CutOff DATETIME
 DECLARE @CurrentTime DATETIME = GETDATE();

         DECLARE @IsCurrentDayWeekOff BIT, @IsCurrentDayHoliday BIT;

	    SELECT @IsCurrentDayHoliday =  CASE WHEN L.DateId IS NULL THEN CAST(0 AS BIT) ELSE CAST(1 AS BIT) END
	                                 FROM DateMaster DM LEFT JOIN ListOfHoliday L ON DM.DateId = L.DateId
	                                 WHERE DM.[Date] = @Date
	    SELECT @IsCurrentDayWeekOff =  DM.IsWeekend FROM DateMaster DM WHERE [Date] = @Date
 
	 IF(@ForScreen = ''ADMIN'')
	 BEGIN
		SET @CutOff =  CAST( @Date as datetime) + cast(convert(Time,''19:00:00.0000000'')  as datetime)

		INSERT INTO @IsValidTable(IsValid)
		SELECT CASE WHEN @CurrentTime > @CutOff THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END
	 END
	 ELSE IF(@ForScreen = ''MGR'')
	 BEGIN
		SET @CutOff =  CAST( @Date as datetime) + cast(convert(Time,''19:00:00.0000000'')  as datetime)
		INSERT INTO @IsValidTable(IsValid)
		SELECT CASE WHEN @CurrentTime > @CutOff THEN CAST(0 AS BIT) ELSE CAST(1 AS BIT) END
	 END
	 ELSE
	 BEGIN
		SET @CutOff =  CAST(@Date as datetime) + CAST(CONVERT(Time,''18:00:00.0000000'')  as datetime)
		INSERT INTO @IsValidTable(IsValid)
		SELECT CASE WHEN  @CurrentTime <= @CutOff AND @IsCurrentDayHoliday = 0 AND @IsCurrentDayWeekOff = 0 THEN CAST(1 AS BIT) 
		    ELSE CAST(0 AS BIT) END
	 END
 RETURN;
END' 
END

GO
/****** Object:  StoredProcedure [dbo].[Proc_ActionCutOffTimeInfo]    Script Date: 16-01-2020 16:29:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_ActionCutOffTimeInfo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_ActionCutOffTimeInfo] AS' 
END
GO
/*  
   Created Date : 14-Jan-2020
   Created By   : Kanchan Kumari
   Purpose      : check action taken time 
   -----------------------------
   Test Case    : 
   DECLARE @Res int
   EXEC [dbo].[Proc_ActionCutOffTimeInfo] @CabRequestId = 25,  @Response = @Res output
   SELECT @Res AS RESULT
*/
ALTER PROC [dbo].[Proc_ActionCutOffTimeInfo]
(
 @CabRequestId BIGINT,
 @Response tinyint = 0 output
)
AS
BEGIN
    DECLARE @UserId INT, @Date DATE, @ServiceTypeId INT, @CurrStatusId INT;

    SELECT @UserId = UserId, @Date = D.[Date], @ServiceTypeId = CS.ServiceTypeId, @CurrStatusId = C.StatusId
    FROM CabRequest C JOIN DateMaster D WITH (NOLOCK) ON C.DateId = D.DateId
    JOIN CabShiftMaster CS WITH (NOLOCK) ON C.CabShiftId = CS.CabShiftId 
	WHERE C.CabRequestId = @CabRequestId
	
	IF OBJECT_ID('tempdb..#TempDates') IS NOT NULL
	DROP TABLE #TempDates

	CREATE TABLE #TempDates
	(
	   DateText VARCHAR(13) NOT NULL,
	   [Date] DATE NOT NULL,
	   DateId BIGINT NOT NULL,
	   [Day] VARCHAR(100) NOT NULL 
	)	 
	
	 INSERT INTO #TempDates(DateText, [Date], DateId,  [Day])     
	 EXEC [dbo].[Proc_GetDatesForPickAndDrop] @UserId = @UserId, @ForScreen ='MGR' ,@ServiceTypeId = @ServiceTypeId

	 DECLARE @IsValidTime BIT = (SELECT IsValid FROM [dbo].[Fn_GetCutOffTimeValidityForCabBooking](GETDATE(), 'MGR'))
	 
	 IF(@CurrStatusId = 2) -- Pending for approval
	 BEGIN
			IF(@Date IN(SELECT [Date] FROM #TempDates) AND @IsValidTime = 1)
			BEGIN
				SET @Response = 1;
			END
			ELSE
			BEGIN
				SET @Response = 3 --beyond cut off time already
			END
	END
	ELSE
	BEGIN
	      SET @Response = 2 --action taken already
	END	
END
GO
/****** Object:  StoredProcedure [dbo].[Proc_BookOrUpdateCabRequest]    Script Date: 16-01-2020 16:29:41 ******/
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
	DECLARE @IsValidTime BIT = (SELECT IsValid FROM [dbo].Fn_GetCutOffTimeValidityForCabBooking(@Today, 'USER'))
   
  
   DECLARE @Res int, @Msg varchar(100);

   EXEC [dbo].[Proc_CheckValidCabInputs] @UserId = @UserId, @DateId = @DateId, @ShiftId = @ShiftId, @RouteNo = @RouteNo, @LocationId = @LocationId,
                                         @CompanyLocationId = @CompanyLocationId, @ServiceTypeId = @ServiceTypeId, @Success = @Res out, @Message = @Msg out
   
	IF(@IsValidTime = 0)	
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

                             INSERT INTO CabRequestHistory (CabRequestId, Remarks, StatusId, CreatedBy)
										VALUES(@NewCabRequestId, 'Applied', 1, @UserId)
                            
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
/****** Object:  StoredProcedure [dbo].[Proc_GetCabShift]    Script Date: 16-01-2020 16:29:41 ******/
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

		 DECLARE  @IsCurrentDayWeekOff BIT, @IsCurrentDayHoliday BIT, @IsSelectedDayWeekOff BIT, @IsSelectedDayHoliday BIT;

		SELECT @IsCurrentDayHoliday =  CASE WHEN L.DateId IS NULL THEN CAST(0 AS BIT) ELSE CAST(1 AS BIT) END
	                                 FROM DateMaster DM LEFT JOIN ListOfHoliday L ON DM.DateId = L.DateId
	                                 WHERE DM.[Date] = @Today
		
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
	 SELECT @IsSelectedDayWeekOff = IsWeekend FROM DateMaster WHERE [Date] = @SelectedDate 

	 SELECT @IsSelectedDayHoliday =  CASE WHEN L.DateId IS NULL THEN CAST(0 AS BIT) ELSE CAST(1 AS BIT) END
	                                 FROM DateMaster DM LEFT JOIN ListOfHoliday L ON DM.DateId = L.DateId
	                                 WHERE DM.[Date] = @SelectedDate

     IF(@ForScreen = 'ADMIN' OR (@IsCurrentDayWeekOff = 0 AND @IsCurrentDayHoliday = 0))
	 BEGIN
			IF(@SelectedDate = @Today)
			BEGIN
				INSERT INTO #TempUsersCabShift([ShiftId], [ShiftName], [Date], [Idx])
				SELECT CabShiftId,  CONVERT(VARCHAR(11), @SelectedDate, 106)+' '+ CabShiftName  AS ShiftName
				      ,@SelectedDate, @Idx
				FROM #TempCabShift
				WHERE [IsMorning] = 0
			END
			ELSE IF(@SelectedDate > @Today AND @IsSelectedDayWeekOff = 0 AND @IsSelectedDayHoliday = 0)
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
/****** Object:  StoredProcedure [dbo].[Proc_GetDatesForPickAndDrop]    Script Date: 16-01-2020 16:29:41 ******/
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
ALTER PROC [dbo].[Proc_GetDatesForPickAndDrop]
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
     DECLARE @IsCurrentDayWeekOff BIT, @IsCurrentDayHoliday BIT, @NextWorkingDate DATE;

	  SELECT @IsCurrentDayHoliday =  CASE WHEN L.DateId IS NULL THEN CAST(0 AS BIT) ELSE CAST(1 AS BIT) END
	                                 FROM DateMaster DM LEFT JOIN ListOfHoliday L ON DM.DateId = L.DateId
	                                 WHERE DM.[Date] = @Today
      
     SET @NextWorkingDate = (SELECT Top(1) DM.[Date] FROM DateMaster DM LEFT JOIN ListOfHoliday L ON DM.DateId = L.DateId
	 WHERE DM.[Date] > @Today AND DM.IsWeekend = 0 AND L.DateId IS NULL)

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
    
	IF(@IsCurrentDayWeekOff = 0 AND @IsCurrentDayHoliday = 0)
	BEGIN
					INSERT INTO #TempDateForCab
					SELECT  CONVERT(VARCHAR(11), DM.[Date], 106) AS DateText, DM.[Date], DM.[DateId], DM.[Day] 
					FROM [DateMaster] DM 
					WHERE DM.[Date] BETWEEN @Today AND @NextWorkingDate
	END
	
	IF(@ForScreen = 'ADMIN' OR @ForScreen = 'MGR')
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
/****** Object:  StoredProcedure [dbo].[Proc_TakeActionOnCabBulkApprove]    Script Date: 16-01-2020 16:29:41 ******/
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

						    EXEC [dbo].[Proc_TakeActionOnCabRequestByMGR] @CabRequestId, @StatusCode, @Remarks, @LoginUserId, @result OUTPUT
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
/****** Object:  StoredProcedure [dbo].[Proc_TakeActionOnCabRequestByAdmin]    Script Date: 16-01-2020 16:29:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TakeActionOnCabRequestByAdmin]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_TakeActionOnCabRequestByAdmin] AS' 
END
GO

/*  
   Created Date      : 15-Mar-2019
   Created By        : Kanchan Kumari
   Purpose           : To take action on cab  request by admin
   ---------------------------------------------------
	DECLARE @Result int 
    EXEC [dbo].[Proc_TakeActionOnCabRequestByAdmin]
	@LoginUserId = 84
   ,@CabRequestId= 26
   ,@Remarks = 'Cancelled'
   ,@StatusCode='CA'
   ,@Success = @Result output
SELECT @Result AS [RESULT]
*/

ALTER PROCEDURE  [dbo].[Proc_TakeActionOnCabRequestByAdmin]
(	
	 @CabRequestId BIGINT
	,@StatusCode VARCHAR(5)
	,@Remarks VARCHAR(500)
	,@LoginUserId INT
    ,@Success tinyInt = 0 output
)
AS
BEGIN TRY	
 SET NOCOUNT ON;
         
     DECLARE @Today DATE = GETDATE(), @CurrentDate DATETIME =  GETDATE(), @StatusId INT, @NewSatusId INT;
	
     SELECT @StatusId = StatusId FROM CabStatusMaster WHERE StatusCode = @StatusCode
	 SET @NewSatusId = @StatusId
	
	 IF(@StatusCode = 'AP')
	 BEGIN
	        SELECT @NewSatusId =  StatusId FROM CabStatusMaster WHERE StatusCode = 'PF'
	 END
		  BEGIN TRANSACTION
			      IF (@StatusCode = 'AP')
				  BEGIN
				            INSERT INTO CabRequestHistory (CabRequestId, Remarks, StatusId, CreatedBy)
							SELECT @CabRequestId, @Remarks, @StatusId,  @LoginUserId FROM [CabRequest]
							WHERE [CabRequestId] = @CabRequestId AND StatusId = 2  --pending for approval

							UPDATE [dbo].[CabRequest] SET
								[StatusId] = @NewSatusId,
								[ApproverId] = NULL,
								[LastModifiedDate] = GETDATE(),
								[LastModifiedBy] = @LoginUserId
							WHERE [CabRequestId] = @CabRequestId AND StatusId = 2 --pending for approval

							SET @Success=1;	
				  END
				  ELSE IF(@StatusCode = 'RJ')
				  BEGIN
				  	        INSERT INTO CabRequestHistory (CabRequestId, Remarks, StatusId, CreatedBy)
							SELECT @CabRequestId, @Remarks, @StatusId, @LoginUserId FROM [CabRequest]
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
END TRY
BEGIN CATCH
	IF @@TRANCOUNT>0
	ROLLBACK TRANSACTION;
	  
		DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
		EXEC [spInsertErrorLog]
		@ModuleName = 'CabRequest'
		,@Source = '[Proc_TakeActionOnCabRequestByAdmin]'
		,@ErrorMessage = @ErrorMessage
		,@ErrorType = 'SP'
		,@ReportedByUserId = @LoginUserId  

	SET @Success=0; --error occured
END CATCH


GO
/****** Object:  StoredProcedure [dbo].[Proc_TakeActionOnCabRequestByMGR]    Script Date: 16-01-2020 16:29:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TakeActionOnCabRequestByMGR]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_TakeActionOnCabRequestByMGR] AS' 
END
GO

/*  
   Created Date      : 15-Mar-2019
   Created By        : Kanchan Kumari
   Purpose           : To take action on cab  request by mgr
   ---------------------------------------------------
	DECLARE @Result int 
    EXEC [dbo].[Proc_TakeActionOnCabRequestByMGR]
	@LoginUserId = 84
   ,@CabRequestId= 26
   ,@Remarks = 'Cancelled'
   ,@StatusCode='CA'
   ,@Success = @Result output
SELECT @Result AS [RESULT]
*/

ALTER PROCEDURE  [dbo].[Proc_TakeActionOnCabRequestByMGR]
(	
	 @CabRequestId BIGINT
	,@StatusCode VARCHAR(5)
	,@Remarks VARCHAR(500)
	,@LoginUserId INT
    ,@Success tinyInt = 0 output
)
AS
BEGIN TRY	
 SET NOCOUNT ON;

     DECLARE @Today DATE = GETDATE(), @CurrentDate DATETIME =  GETDATE(), @StatusId INT, @NewSatusId INT, @EmployeeId INT;
     SELECT @StatusId = StatusId FROM CabStatusMaster WHERE StatusCode = @StatusCode
	 SET @NewSatusId = @StatusId

    DECLARE @Res int
    EXEC [dbo].[Proc_ActionCutOffTimeInfo] @CabRequestId = @CabRequestId, @Response = @Res output
	
	 IF(@StatusCode = 'AP')
	 BEGIN
	        SELECT @NewSatusId =  StatusId FROM CabStatusMaster WHERE StatusCode = 'PF'
	 END
	  BEGIN TRANSACTION
	      IF(@Res = 1)
		  BEGIN
				INSERT INTO CabRequestHistory (CabRequestId, Remarks, StatusId, CreatedBy)
				SELECT @CabRequestId, @Remarks, @StatusId,  @LoginUserId FROM [CabRequest]
				WHERE [CabRequestId] = @CabRequestId AND StatusId = 2  --pending for approval

				UPDATE [dbo].[CabRequest] SET
					[StatusId] = @NewSatusId,
					[ApproverId] = NULL,
					[LastModifiedDate] = GETDATE(),
					[LastModifiedBy] = @LoginUserId
				WHERE [CabRequestId] = @CabRequestId AND StatusId = 2 --pending for approval

				SET @Success = 1; -- success		
		  END
		  ELSE
		  BEGIN
		     SET @Success = @Res; -- 2--action taken already, 3- beyond cutoff time  
		  END
		
		 COMMIT;	
END TRY
BEGIN CATCH
	IF @@TRANCOUNT>0
	ROLLBACK TRANSACTION;
	  
		DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
		EXEC [spInsertErrorLog]
		@ModuleName = 'CabRequest'
		,@Source = '[Proc_TakeActionOnCabRequestByMGR]'
		,@ErrorMessage = @ErrorMessage
		,@ErrorType = 'SP'
		,@ReportedByUserId = @LoginUserId  
	SET @Success=0; --error occured
END CATCH


GO
/****** Object:  StoredProcedure [dbo].[Proc_TakeActionOnCabRequestByUser]    Script Date: 16-01-2020 16:29:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TakeActionOnCabRequestByUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_TakeActionOnCabRequestByUser] AS' 
END
GO
/*  
   Created Date      : 15-Mar-2019
   Created By        : Kanchan Kumari
   Purpose           : To take action on cab  request by user
   ---------------------------------------------------
	DECLARE @Result int 
    EXEC [dbo].[Proc_TakeActionOnCabRequestByUser]
	@LoginUserId = 84
   ,@CabRequestId= 26
   ,@Remarks = 'Cancelled'
   ,@StatusCode='CA'
   ,@Success = @Result output
SELECT @Result AS [RESULT]
*/

ALTER PROCEDURE  [dbo].[Proc_TakeActionOnCabRequestByUser]
(	
	 @CabRequestId BIGINT
	,@StatusCode VARCHAR(5)
	,@Remarks VARCHAR(500)
	,@LoginUserId INT
    ,@Success tinyInt = 0 output
)
AS
BEGIN TRY	
 SET NOCOUNT ON;
     DECLARE @Today DATE = GETDATE(), @CurrentDate DATETIME =  GETDATE(), @StatusId INT, @CurrStatusId INT, 
	  @EmployeeId INT, @DateId BIGINT;
	  
	  SELECT @StatusId = StatusId FROM CabStatusMaster WHERE StatusCode = @StatusCode

	 SELECT @EmployeeId = [UserId], @DateId = DateId, @CurrStatusId = StatusId
	 FROM [dbo].[CabRequest] WITH (NOLOCK) WHERE CabRequestId = @CabRequestId
	
    IF OBJECT_ID('tempdb..#TempDates') IS NOT NULL
	DROP TABLE #TempDates

	CREATE TABLE #TempDates
	(
	   DateText VARCHAR(13) NOT NULL,
	   [Date] DATE NOT NULL,
	   DateId BIGINT NOT NULL,
	   [Day] VARCHAR(100) NOT NULL 
	)	 
	
	 INSERT INTO #TempDates(DateText, [Date], DateId,  [Day])     
	 EXEC [dbo].[Proc_GetDatesForPickAndDrop] @UserId = @EmployeeId, @ForScreen ='MGR' ,@ServiceTypeId = 1

	 DECLARE @IsValidTime BIT = (SELECT IsValid FROM [dbo].[Fn_GetCutOffTimeValidityForCabBooking](@Today, 'USER'))

	 IF(@DateId IN(SELECT DateId FROM #TempDates) AND @IsValidTime = 1)
	 BEGIN
	       IF(@CurrStatusId < 5)
		   BEGIN
		         BEGIN TRANSACTION
				 IF(@StatusCode = 'CA' AND @EmployeeId = @LoginUserId )
				  BEGIN
				           INSERT INTO CabRequestHistory (CabRequestId, Remarks, StatusId, CreatedBy)
							SELECT @CabRequestId, @Remarks, @StatusId,  @LoginUserId FROM [CabRequest]
							WHERE [CabRequestId] = @CabRequestId AND StatusId <= 5 --Finalized

							UPDATE [dbo].[CabRequest] SET
								[StatusId] = @StatusId,
								[ApproverId] = NULL,
								[LastModifiedDate] = GETDATE(),
								[LastModifiedBy] = @LoginUserId
							WHERE [CabRequestId] = @CabRequestId AND StatusId < 5 --till pending for Finalization

							SET @Success=1;	
				  END
            END
			ELSE
			BEGIN
			    SET @Success = 2; -- already action taken
			END
		  COMMIT;	
	 END
	 ELSE
	 BEGIN
	    SET @Success = 3 ; --3- beyond cutoff time
	 END
END TRY
BEGIN CATCH
	IF @@TRANCOUNT>0
	ROLLBACK TRANSACTION;
	  
		DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
		EXEC [spInsertErrorLog]
		@ModuleName = 'CabRequest'
		,@Source = '[Proc_TakeActionOnCabRequestByUser]'
		,@ErrorMessage = @ErrorMessage
		,@ErrorType = 'SP'
		,@ReportedByUserId = @LoginUserId  

	SET @Success=0; --error occured
END CATCH


GO
/****** Object:  StoredProcedure [dbo].[spSaveNewUser]    Script Date: 16-01-2020 16:29:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spSaveNewUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spSaveNewUser] AS' 
END
GO
/***
   Created Date      :     2016-11-30
   Created By        :     Shubhra Upadhyay
   Purpose           :     This stored procedure is to save a new user (result -> true: success, false: failure)
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   
   --------------------------------------------------------------------------

   Test Cases        :
   --------------------------------------------------------------------------

   --- Test Case 1
         DECLARE @Usr INT, @res int
         EXEC [dbo].[spSaveNewUser]
             @RegistrationId = 3
             ,@UserName = 'v7dBXhOXkXyqYlDwYki3Fw==' 
             ,@Dob = '4Ea8CbheEbabfwRC/9EUxQB97nHAZ6ND'
             ,@BloodGroup = 'KxWIFmk5Oc+58NhL+KlXOw=='
             ,@EmailId = 'v7dBXhOXkXyPPlWRVWaXi8F8MiKkCki2Ej5ibLBVUVGXqN75EJ7HNA=='
             ,@MobileNumber = 'z/c9Ya2bHtYKHnJGdmBAgw=='
             ,@EmployeeId = 'GSI G 038'
             ,@DepartmentId = 2
             ,@DesignationId = 1
			 ,@ProbationPeriod = 6
             ,@TeamId = 3
             ,@WsNo = 'wsno'
             ,@ExtensionNo = 'ex'
             --,@AccCardNo = 'acc'
             ,@Doj = '12/21/2016'
             ,@RoleId = 3
             ,@ReportingManagerId = 0
             ,@UserId = 84
             ,@PasswordResetCode = '5TUWKYCQ1L'
			 ,@Success = @res output
			 ,@NewUser = @Usr output
			 SELECT @res AS RESULT, @Usr AS USERNEW
              
***/
ALTER PROCEDURE [dbo].[spSaveNewUser]
(
     @RegistrationId bigint
    ,@UserName varchar(100)
    ,@Dob varchar(50)
    ,@BloodGroup varchar(50)
    ,@EmailId varchar(150)
    ,@MobileNumber varchar(50)
    ,@EmployeeId varchar(50)
    ,@DepartmentId int
    ,@DesignationId int
	,@ProbationPeriod int
    ,@TeamId bigint
    ,@WsNo varchar(20)
    ,@ExtensionNo varchar(10)
    --,@AccCardNo varchar(50)
    ,@Doj varchar(20)
    ,@RoleId int
    ,@ReportingManagerId int
    ,@UserId int
    ,@PasswordResetCode varchar(15)
	,@Success tinyint = 0 output
	,@NewUser int = 0 output
) 
AS
BEGIN TRY 
	SET NOCOUNT ON;

	IF EXISTS(SELECT 1 FROM UserDetail 
	WHERE REPLACE(LTRIM(REPLACE(REPLACE(EmployeeId,' ',''), '0', ' ')), ' ', '0') = REPLACE(LTRIM(REPLACE(REPLACE(@EmployeeId,' ',''), '0', ' ')), ' ', '0'))
	BEGIN
		SET @Success = 2; -- employeeid exists
		SET @NewUser = 0;
	END
    ELSE
	BEGIN 
         BEGIN TRANSACTION
         INSERT INTO [dbo].[User]
         (
             [LocationId]
            ,[RoleId]
            ,[UserName]
            ,[IsActive]
            ,[UnsuccessfulLoginAttempt]
            ,[IsLocked]
            ,[IsSuspended]
            ,[IsPasswordResetRequired]
            ,[CreatedDate]
            ,[CreatedBy]
            ,[PasswordResetCode]
            ,[IsPasswordResetCodeExpired]
         )
         VALUES
         (   
             1
            ,@RoleId
            ,@UserName
            ,1
            ,0
            ,0
            ,0
            ,1
            ,GETDATE()
            ,@UserId
            ,@PasswordResetCode
            ,0
         )   

         DECLARE @NewUserId int = SCOPE_IDENTITY() --new UserId
           
         INSERT INTO [dbo].[UserDetail]   -- insert in UserDetail table
         (
             [UserId]
            ,[FirstName]
            ,[MiddleName]
            ,[LastName]
            ,[DOB]
            ,[GenderId]
            ,[MaritalStatusId]
            ,[BloodGroup]
            ,[MobileNumber]
            ,[EmailId]
            ,[EmployeeId]
            ,[JoiningDate]
            ,[DesignationId]
            --,[CreatedBy]
            ,[ReportTo]
            ,[EmergencyContactNumber]
            ,[PersonalEmailId]
            --,[DepartmentId]
            --,[AssignedWorkStation]
            ,[ExtensionNumber]
            ,[InsuranceAmount]
            ,[PanCardId]
            ,[AadhaarCardId]
            ,[VoterCardId]
            ,[DrivingLicenseId]
            ,[PassportId]
            ,[LastEmployerName]
            ,[LastEmployerLocation]
            ,[LastJobTenure]
            ,[JobLeavingReason]
            ,[UAN]
            ,[IsFresher]
            ,[LastJobDesignation]
            ,[ImagePath]
			,[ProbationPeriodMonths]
            --,[PhotoFileName]
         )
         SELECT
           @NewUserId
           ,UR.[FirstName]
           ,ISNULL(UR.[MiddleName], '')
           ,UR.[LastName]
           ,@Dob
           ,UR.[GenderId]
           ,UR.[MaritalStatusId]
           ,@BloodGroup
           ,@MobileNumber
           ,@EmailId
           ,@EmployeeId
           ,@Doj
           ,@DesignationId
           --,UR.[CreatedBy]
           ,@ReportingManagerId
           ,UR.[EmergencyContactNumber]
           ,UR.[PersonalEmailId]
           --,@DepartmentId
           --,@WsNo
           ,@ExtensionNo
           ,UR.[InsuranceAmount]
           ,UR.[PanCardId]
           ,UR.[AadhaarCardId]
           ,UR.[VoterCardId]
           ,UR.[DrivingLicenseId]
           ,UR.[PassportId]
           ,UR.[LastEmployerName]
           ,UR.[LastEmployerLocation]
           ,UR.[LastJobTenure]
           ,UR.[JobLeavingReason]
           ,UR.[LastJobUAN]
           ,UR.[IsFresher]
           ,UR.[LastJobDesignation]
           ,UR.[PhotoFileName]
		   ,@ProbationPeriod
         FROM [dbo].[TempUserRegistration] UR WITH (NOLOCK) WHERE UR.[RegistrationId] = @RegistrationId
         
         INSERT INTO [dbo].[UserAddressDetail]  --insert in UserAddressDetail table
         (
             [UserId]
            ,[Address]
            ,[CountryId]
            ,[StateId]
            ,[CityId]
            ,[PinCode]
            ,[IsAddressPermanent]
            ,[IsActive]
         )
         SELECT
             @NewUserId
            ,UA.[Address]
            ,UA.[CountryId]
            ,UA.[StateId]
            ,UA.[CityId]
            ,UA.[PinCode]
            ,UA.[IsAddressPermanent]
            ,1
         FROM [dbo].[TempUserAddressDetail] UA WITH (NOLOCK) WHERE UA.[RegistrationId] = @RegistrationId
         
         ------------------insert into [UserTeamMapping] starts------------------
         INSERT INTO [dbo].[UserTeamMapping]  
         (
             [UserId]
            ,[TeamId]
            ,[CreatedBy]
            ,[TeamRoleId]
            ,[ConsiderInClientReports]
         )
         SELECT
               @NewUserId
            ,@TeamId
            ,@UserId
            ,7 --set default role as General
            ,0     
         ------------------insert into [UserTeamMapping] ends------------------

         ------------------insert into [LeaveBalance] starts------------------
         IF( (SELECT [IsIntern] FROM [dbo].[Designation] WHERE [DesignationId] = @DesignationId) = 0) --credit leaves for non intern designations
         BEGIN
            DECLARE @JoiningDate int = (SELECT DATEPART(dd, @Doj))
            DECLARE @JoiningMonth int = (SELECT DATEPART(mm, @Doj))  
		    DECLARE @CurrentMonth INT=(SELECT DATEPART(mm, GETDATE()))
            DECLARE @CurrentYear INT=(SELECT DATEPART(YYYY, GETDATE()))  
			DECLARE @JoiningYear INT=(SELECT DATEPART(YYYY, @Doj))   
            DECLARE @CLCount int,@PLCount int
			SET @CLCount = CASE
                              WHEN @JoiningMonth BETWEEN 4 AND 12 THEN (16 - @JoiningMonth)
                              ELSE (4 - @JoiningMonth)
                           END
            IF(@JoiningDate > 10)
               SET @CLCount = @CLCount - 1
            SET @PLCount=CASE
				WHEN @JoiningDate > 15 AND @CurrentYear=@JoiningYear  THEN  @CurrentMonth-@JoiningMonth
				WHEN @JoiningDate > 15 AND @CurrentYear!=@JoiningYear  THEN 12 + @CurrentMonth-@JoiningMonth
				WHEN @JoiningDate <= 15 AND @CurrentYear!=@JoiningYear  THEN 13 + @CurrentMonth-@JoiningMonth
				ELSE @CurrentMonth-@JoiningMonth+1 
				END     
            INSERT INTO [dbo].[LeaveBalance]
            (
               [UserId]
              ,[LeaveTypeId]
,[Count]
              ,[CreatedBy]
            )
            SELECT
               @NewUserId
              ,M.[TypeId]
              ,CASE
                  WHEN M.[ShortName] = 'PL' THEN @PLCount
                  WHEN M.[ShortName] = 'CL' THEN @CLCount
                  WHEN M.[ShortName] = '5CLOY' THEN 1
                  ELSE 0
               END
              ,@UserId
            FROM [dbo].[LeaveTypeMaster] M WITH (NOLOCK)
         END
         ELSE  --credit 3 CL for interns quarterly
         BEGIN
		 DECLARE @JDate int = (SELECT DATEPART(dd, @Doj))
            DECLARE @JMonth int = (SELECT DATEPART(mm, @Doj))         
            DECLARE @CLCountInterns int

            SET @CLCountInterns = CASE
                              WHEN @JMonth IN (1,4,7,10) THEN 3
							  WHEN @JMonth IN (2,5,8,11) THEN 2
                              ELSE 1
                           END
            IF(@JDate > 15)          ----if date greater than 15 then reduce CL by 1
               SET @CLCountInterns = @CLCountInterns - 1
            INSERT INTO [dbo].[LeaveBalance]
            (
               [UserId]
              ,[LeaveTypeId]
              ,[Count]
              ,[CreatedBy]
            )
            SELECT
               @NewUserId
              ,M.[TypeId]
              ,CASE
			  WHEN M.[ShortName]='CL' THEN @CLCountInterns
			  ELSE 0
			  END
              ,@UserId
   FROM [dbo].[LeaveTypeMaster] M WITH (NOLOCK)
         END
         
         ------------------insert into [LeaveBalance] ends------------------

         --DELETE FROM [dbo].[TempUserAddressDetail] WHERE [RegistrationId] = @RegistrationId
         --DELETE FROM [dbo].[TempUserRegistration] WHERE [RegistrationId] = @RegistrationId
		  
		  SET @Success = 1; -- duplicate user
	      SET @NewUser = @NewUserId;

         COMMIT TRANSACTION;
   END       
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
    ROLLBACK TRANSACTION;

	SET @Success = 0; -- duplicate user
	SET @NewUser = 0;

    DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
    EXEC [spInsertErrorLog]
	    @ModuleName = 'UserManagement'
    ,@Source = 'spSaveNewUser'
    ,@ErrorMessage = @ErrorMessage
    ,@ErrorType = 'SP'
    ,@ReportedByUserId = @UserId   
	     
END CATCH
GO
