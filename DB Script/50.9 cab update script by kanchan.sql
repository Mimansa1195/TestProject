
ALTER TABLE CabRequestHistory DROP COLUMN [Status]
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
   DECLARE @CabRequestIds VARCHAR(2000), @Vehicle VARCHAR(100), @StaffName VARCHAR(100), @StaffContactNo VARCHAR(20)
 
       SELECT @CabRequestIds = CabRequestIds, @Vehicle = V.Vehicle, @StaffName = ISNULL(F.StaffName, ''),
	    @StaffContactNo = ISNULL(F.StaffContactNo, '')
	   FROM FinalizedCabRequest F JOIN VehicleDetails V ON F.VehicleId = V.VehicleId
	   WHERE FCRequestId = @FCRequestId

         CREATE TABLE #TempRequests
		 (
		 [CabRequestId] BIGINT
		 )

		 INSERT INTO #TempRequests([CabRequestId])
		 SELECT SplitData FROM [dbo].[Fun_SplitStringStr](@CabRequestIds, ',') 
	      
	   SELECT UD.EmployeeName,ISNULL(R.EmpContactNo,'') AS EmpContactNo, UD.EmployeeFirstName, 
	          UD.ReportingManagerName AS RMName, CONVERT(VARCHAR(13), DM.[Date], 106)+' @ '+ CS.CabShiftName AS [DateAndTime], 
			  CT.ServiceType, DL.RouteLocation, R.LocationDetail, 
			  @StaffName+' ['+@StaffContactNo+']' AS Driver, @Vehicle AS Vehicle, '' AS UserRemarks,
			  UD.EmailId, L.LocationName AS CompanyLocation
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

	  INSERT INTO CabRequestHistory (CabRequestId, Remarks, StatusId,  CreatedBy)
	  SELECT CR.CabRequestId, 'Finalized', CR.StatusId,  @LoginUserId
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
				           INSERT INTO CabRequestHistory (CabRequestId, Remarks, StatusId, CreatedBy)
							SELECT @CabRequestId, @Remarks, @StatusId,  @LoginUserId FROM [CabRequest]
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
				  ELSE IF(@StatusCode = 'RJ' AND (@FirstReportingId = @LoginUserId OR @ForScreen = 'ADMIN'))
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





