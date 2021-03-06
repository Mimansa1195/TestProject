
/****** Object:  StoredProcedure [dbo].[spRequestWorkFromHome]    Script Date: 24-01-2019 18:27:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spRequestWorkFromHome]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spRequestWorkFromHome]
GO
/****** Object:  StoredProcedure [dbo].[spGetUserAppliedLeave]    Script Date: 24-01-2019 18:27:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetUserAppliedLeave]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetUserAppliedLeave]
GO
/****** Object:  StoredProcedure [dbo].[spGetEmployeesWithNoAttendance]    Script Date: 24-01-2019 18:27:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetEmployeesWithNoAttendance]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetEmployeesWithNoAttendance]
GO
/****** Object:  StoredProcedure [dbo].[spApplyLeave]    Script Date: 24-01-2019 18:27:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spApplyLeave]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spApplyLeave]
GO
/****** Object:  StoredProcedure [dbo].[Proc_TakeActionOnOutingRequest]    Script Date: 24-01-2019 18:27:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TakeActionOnOutingRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TakeActionOnOutingRequest]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetNextWorkingDate]    Script Date: 24-01-2019 18:27:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetNextWorkingDate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetNextWorkingDate]
GO
/****** Object:  StoredProcedure [dbo].[Proc_ApplyOutingRequest]    Script Date: 24-01-2019 18:27:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_ApplyOutingRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_ApplyOutingRequest]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_CheckIfLeaveAlreadyExists]    Script Date: 24-01-2019 18:27:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_CheckIfLeaveAlreadyExists]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_CheckIfLeaveAlreadyExists]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_CheckIfLeaveAlreadyExists]    Script Date: 24-01-2019 18:27:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_CheckIfLeaveAlreadyExists]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/***
Created Date      :  22-Jan-2019
Created By        :  Kanchan Kumari
Purpose           :  To check if leave already applied for the given date
Usage             : SELECT  dbo.Fun_CheckIfLeaveAlreadyExists(2432,11128,11129)  

SELECT MIN(DM1.DateId) , MAX(DM1.DateId) FROM DateMaster DM1 WHERE DM1.Date BETWEEN ''2018-10-13'' AND ''2018-10-14''

--------------------------------------------------------------------------
**/
CREATE FUNCTION [dbo].[Fun_CheckIfLeaveAlreadyExists]
(
 @EmployeeId INT,
 @FromDateId BIGINT,
 @TillDateId BIGINT
)
RETURNS BIT 
AS
BEGIN 
      DECLARE @Success BIT = 0
		DECLARE @TempTableDateId TABLE
		(
			TempDateId INT
		)
		INSERT INTO @TempTableDateId
		SELECT DateId FROM DateMaster WHERE DateId BETWEEN @FromDateId AND @TillDateId

		IF EXISTS(SELECT 1 FROM [dbo].[OutingRequestDetail] OT
		      JOIN OutingRequest R ON OT.OutingRequestId = R.OutingRequestId
			  WHERE R.UserId = @EmployeeId
			  AND OT.[StatusId] <=5
			  AND (OT.DateId IN (SELECT TempDateId FROM @TempTableDateId))
			  )	  
	   BEGIN
		SET @Success = 1 --Already exists
	   END
	   ELSE IF EXISTS(SELECT 1 FROM [dbo].[DateWiseLeaveType] DW 
	          JOIN LeaveRequestApplication LR ON DW.LeaveRequestApplicationId = LR.LeaveRequestApplicationId
			  WHERE LR.UserId = @EmployeeId
			  AND LR.[StatusId] > 0
			  AND (DW.DateId IN (SELECT TempDateId FROM @TempTableDateId))
			  )	  
       BEGIN
	       SET @Success = 1 --Already exists
	   END
	   ELSE IF EXISTS(SELECT 1 FROM [dbo].[LegitimateLeaveRequest] LG   -- LegitimateLeaveStatus
			  WHERE LG.UserId = @EmployeeId
			  AND LG.[StatusId] <= 5
			  AND (LG.DateId IN (SELECT TempDateId FROM @TempTableDateId))
			  )	  
       BEGIN
	       SET @Success = 1 --Already exists
	   END

	RETURN @Success 
END' 
END

GO
/****** Object:  StoredProcedure [dbo].[Proc_ApplyOutingRequest]    Script Date: 24-01-2019 18:27:30 ******/
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
@EmployeeId = 3
,@FromDate = '2018-05-29'
,@TillDate = '2018-05-30'
,@Reason = 'Testing by Kanchan'
,@OutingTypeId = 3
,@LoginUserId = 3
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
	DECLARE @FromDateId BIGINT, @TillDateId BIGINT, @ReportingManagerId INT, @HRId INT,@StatusId INT=2
	SET @ReportingManagerId = (SELECT [dbo].[fnGetReportingManagerByUserId](@EmployeeId)) 
	
	SET @HRId=(SELECT [dbo].[fnGetHRIdByUserId](@EmployeeId))
				SELECT @FromDateId = MIN(DM.[DateId])
		,@TillDateId = MAX(DM.[DateId])
	FROM [dbo].[DateMaster] DM WITH (NOLOCK)
	WHERE DM.[Date] BETWEEN  @FromDate AND  @TillDate

	DECLARE @IsAlreadyApplied BIT = (SELECT  dbo.Fun_CheckIfLeaveAlreadyExists(@EmployeeId, @FromDateId, @TillDateId))

	------------check if already applied other types of leave --------
	IF(@IsAlreadyApplied = 1)  
	BEGIN
		SET @Success = 1 --Already exists
	END
	ELSE 
	BEGIN	
	   IF(@ReportingManagerId=0 OR @ReportingManagerId=1)
	   BEGIN
	        SET @ReportingManagerId=@HRId
		    SET @StatusId=(SELECT StatusId FROM OutingRequestStatus WHERE StatusCode='PV')
	   END
	   		
		SELECT 
		 @FromDateId = MIN(DM.[DateId])
		,@TillDateId = MAX(DM.[DateId])
		FROM [dbo].[DateMaster] DM WITH (NOLOCK)
		WHERE DM.[Date] BETWEEN  @FromDate AND  @TillDate
	
		INSERT INTO [dbo].[OutingRequest]([OutingTypeId], [UserId], [FromDateId], [TillDateId], [Reason], 
											  [PrimaryContactNo], [AlternativeContactNo],[StatusId], [NextApproverId], [CreatedById])
		VALUES(@OutingTypeId,@EmployeeId,@FromDateId,@TillDateId, @Reason, @PrimaryContactNo, @OtherContactNo,@StatusId,@ReportingManagerId, @LoginUserId)

		DECLARE @OutingRequestId BIGINT
		SET @OutingRequestId = SCOPE_IDENTITY()
		
		--Print ('ID: ' + CAST(@OutingRequestId AS VARCHAR(10)))

		--insert into OutingRequestHistory table 
		INSERT INTO [dbo].[OutingRequestHistory]([OutingRequestId], [Remarks], [CreatedById])
		VALUES (@OutingRequestId, 'Applied', @LoginUserId)

		--insert into OutingRequestDetail
		 WHILE (@FromDateId <= @TillDateId)
			BEGIN
				INSERT INTO [dbo].[OutingRequestDetail]([OutingRequestId],[DateId],[StatusId], [CreatedById])
				VALUES(@OutingRequestId,@FromDateId,@StatusId, @EmployeeId) 
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
/****** Object:  StoredProcedure [dbo].[Proc_GetNextWorkingDate]    Script Date: 24-01-2019 18:27:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetNextWorkingDate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetNextWorkingDate] AS' 
END
GO
/* Created Date :	21-Jan-2019
   Created By   :   Kanchan Kumari
   Purpose      :   Get next working date
   Usages		:	Proc_GetNextWorkingDate
*/
ALTER PROC [dbo].[Proc_GetNextWorkingDate]
AS
BEGIN
    SELECT Top 1 D.[Date] FROM DateMaster D LEFT JOIN ListofHoliday L ON D.DateId = L.[DateId] 
	WHERE L.DateId IS NULL AND D.IsWeekend != 1 AND D.[Date] > CAST(GETDATE() AS DATE)
END


GO
/****** Object:  StoredProcedure [dbo].[Proc_TakeActionOnOutingRequest]    Script Date: 24-01-2019 18:27:30 ******/
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
	  @OutingRequestId =71,
	  @StatusCode='CA',
	  @Remarks='Requested by User',
	  @LoginUserId= 2203,
	  @LoginUserType='SPECIAL',
	  @OutingRequestDetailId=0,
	  @CancelType VARCHAR(10) = 'All',
	  @Success=@Result output
SELECT @Result As [RESULT]
***/
ALTER PROC [dbo].[Proc_TakeActionOnOutingRequest]
@OutingRequestId BIGINT,
@StatusCode VARCHAR(20),
@Remarks VARCHAR(500) = NULL,
@LoginUserId BIGINT,
@LoginUserType VARCHAR(200) = NULL,
@OutingRequestDetailId BIGINT= NULL,
@CancelType VARCHAR(10),
@Success TINYINT = 0 Output
AS
BEGIN TRY
BEGIN TRAN
    DECLARE @SuccessMsg INT; 
	DECLARE @StatusId INT, @StatusIdNew INT, @EmployeeId BIGINT,@FirstReportingId BIGINT , @SecondReportingId BIGINT, @HRId BIGINT,@DepartmentHeadId BIGINT ,@HRHeadId INT=2166
	DECLARE @count INT,@FromDateId INT,@TillDateId INT,@CountDate INT=0,@StatusIdForHR INT
	SELECT @EmployeeId=[UserId] FROM [dbo].[OutingRequest] WITH (NOLOCK) WHERE [OutingRequestId]=@OutingRequestId
	SET @SecondReportingId= (SELECT [dbo].[fnGetSecondReportingManagerByUserId](@EmployeeId))
	SET @HRId=(SELECT [dbo].[fnGetHRIdByUserId](@EmployeeId))
	SET @FirstReportingId=(SELECT [dbo].[fnGetReportingManagerByUserId](@EmployeeId))
	SET @DepartmentHeadId= (SELECT [dbo].[fnGetDepartmentHeadIdByUserId](@EmployeeId))
		SET @StatusIdForHR=(SELECT [StatusId] FROM [dbo].[OutingRequest] WITH (NOLOCK) WHERE OutingRequestId=@OutingRequestId)
   IF(@LoginUserType != 'SPECIAL' AND @LoginUserId NOT IN(@FirstReportingId, @EmployeeId, @SecondReportingId, @DepartmentHeadId, @HRId))
   BEGIN
       SET @SuccessMsg = 2; -----not a valid user to take action
   END
   ELSE
   BEGIN

		IF(@StatusCode = 'VD' AND @LoginUserId != @HRHeadId)
		SET @StatusCode = 'AP'

		IF(@StatusCode = 'VD' AND @LoginUserId = @HRHeadId AND @StatusIdForHR = 2)
		SET @StatusCode = 'AP'

		SELECT @StatusId = [StatusId] FROM [dbo].[OutingRequestStatus] WITH (NOLOCK) WHERE [StatusCode]=@StatusCode

	WHILE(@FromDateId<=@TillDateId)
	BEGIN
		SET @CountDate=@CountDate+1
		SET @FromDateId=@FromDateId+1
	END
	--Cancel by user it self
	IF(@LoginUserType != 'SPECIAL' AND @LoginUserId = @EmployeeId AND @StatusCode='CA' AND @CancelType ='Single')
	BEGIN
		 UPDATE OutingRequestDetail SET StatusId=@StatusId ,ModifiedById=@LoginUserId ,ModifiedDate=GETDATE()
		 WHERE  OutingRequestDetailId= @OutingRequestDetailId AND StatusId <=5 ---not cancelled or rejected
		 SET @count=(SELECT Count(DateId) From OutingRequestDetail Where StatusId <= 5 
	                      AND OutingRequestId = @OutingRequestId)
		IF(@Count=0)
		 BEGIN
			INSERT INTO OutingRequestHistory(OutingRequestId,StatusId,Remarks,CreatedById)
			SELECT @OutingRequestId, @StatusId AS StatusId, @Remarks AS Remarks, @LoginUserId
			UPDATE OutingRequest SET StatusId=@StatusId, NextApproverId=NULL, ModifiedById=@LoginUserId, ModifiedDate=GETDATE()
			WHERE OutingRequestId=@OutingRequestId AND StatusId <= 5 -- not rejected or cancelled
         END
		 SET @SuccessMsg=1;---Request processed successfully
	END
	--Cancel All request by User and HR
	ELSE IF((@LoginUserType = 'SPECIAL' OR @LoginUserId = @EmployeeId OR @LoginUserId=@HRId) AND @StatusCode='CA' AND @CancelType='All')
	BEGIN
		 UPDATE OutingRequestDetail SET StatusId= @StatusId ,ModifiedById=@LoginUserId, ModifiedDate=GETDATE()
		 WHERE  OutingRequestId= @OutingRequestId AND StatusId <= 5 --outingrequeststatus
		 SET @count=(SELECT Count(DateId) From OutingRequestDetail Where StatusId <= 5 
	              AND OutingRequestId= @OutingRequestId)
		IF(@Count=0)
		 BEGIN
			INSERT INTO OutingRequestHistory(OutingRequestId,StatusId,Remarks,CreatedById)
			SELECT @OutingRequestId, @StatusId AS StatusId, @Remarks AS Remarks, @LoginUserId
			UPDATE OutingRequest SET StatusId= @StatusId, NextApproverId= NULL, ModifiedById= @LoginUserId, ModifiedDate=GETDATE()
			WHERE OutingRequestId=@OutingRequestId AND StatusId <= 5 -- not rejected or cancelled
         END
		  SET @SuccessMsg=1;
	END
	
	--Approved By first level Manager
	ELSE IF(@StatusCode='AP')
	BEGIN
	     --VM-3, PC-4, AS-2203, AP-2167
		 IF(@LoginUserId=@FirstReportingId)
		 BEGIN

			 IF(@SecondReportingId=0 OR @FirstReportingId = @DepartmentHeadId)
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
			UPDATE OutingRequestDetail SET StatusId= @StatusIdNew, ModifiedById=@LoginUserId,ModifiedDate=GETDATE() 
			WHERE OutingRequestId=@OutingRequestId AND StatusId <= 5 -- not rejected or cancelled
			--update Outing Request Table
			UPDATE OutingRequest set NextApproverId=@SecondReportingId,StatusId=@StatusIdNew,ModifiedById=@LoginUserId, ModifiedDate=GETDATE()
			WHERE OutingRequestId=@OutingRequestId AND StatusId <= 5 -- not rejected or cancelled
			SET @SuccessMsg=1;
	     END
	   --Approved by Second level Manager
	      ELSE IF(@LoginUserId=@SecondReportingId)
	      BEGIN
			    IF(@DepartmentHeadId=0 OR @SecondReportingId = @DepartmentHeadId)
			    BEGIN
			       SET @DepartmentHeadId=@HRId
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
			      WHERE OutingRequestId=@OutingRequestId AND StatusId <= 5 -- not rejected or cancelled
			      --update Outing Request Table
			      UPDATE OutingRequest set StatusId=@StatusIdNew, NextApproverId=@DepartmentHeadId, ModifiedById=@LoginUserId, ModifiedDate=GETDATE()
			      WHERE OutingRequestId=@OutingRequestId AND StatusId <= 5 -- not rejected or cancelled
				  SET @SuccessMsg=1;
         END
	     --Approved by Department head
			ELSE IF(@LoginUserId=@DepartmentHeadId AND @DepartmentHeadId != @FirstReportingId AND @DepartmentHeadId != @SecondReportingId)
			BEGIN
			   SET @StatusIdNew=(SELECT StatusId From OutingRequestStatus where StatusCode='PV')
			   INSERT INTO OutingRequestHistory(OutingRequestId,StatusId,Remarks,CreatedById)
			   SELECT @OutingRequestId,@StatusId AS StatusId,@Remarks,@LoginUserId
			   --update outing Request detail table
			   UPDATE OutingRequestDetail SET StatusId=@StatusIdNew, ModifiedById=@LoginUserId,ModifiedDate=GETDATE() 
			   WHERE OutingRequestId=@OutingRequestId AND StatusId <= 5 -- not rejected or cancelled
			   --update Outing Request Table
			   UPDATE OutingRequest set StatusId=@StatusIdNew, NextApproverId=@HRId, ModifiedById=@LoginUserId, ModifiedDate=GETDATE()
			   WHERE OutingRequestId=@OutingRequestId AND StatusId <= 5 -- not rejected or cancelled
			   SET @SuccessMsg=1;
		    END
		
   END
	-- Verififed by HR
	ELSE IF(@StatusCode='VD')
	BEGIN
		INSERT INTO OutingRequestHistory(OutingRequestId,StatusId,Remarks,CreatedById)
		SELECT @OutingRequestId,@StatusId AS StatusId,@Remarks,@LoginUserId
		--update outing Request detail table
		UPDATE OutingRequestDetail SET StatusId=@StatusId, ModifiedById=@LoginUserId,ModifiedDate=GETDATE() 
		WHERE OutingRequestId=@OutingRequestId AND StatusId <= 5 -- not rejected or cancelled
		--update Outing Request Table
		UPDATE OutingRequest set StatusId=@StatusId, NextApproverId=NULL, ModifiedById=@LoginUserId, ModifiedDate=GETDATE() 
		WHERE OutingRequestId=@OutingRequestId AND StatusId <= 5 -- not rejected or cancelled
	    SET @SuccessMsg=1;
	END
	ELSE IF(@StatusCode='RJM' )
	BEGIN
		INSERT INTO OutingRequestHistory(OutingRequestId,StatusId,Remarks,CreatedById)
		SELECT @OutingRequestId,@StatusId AS StatusId,@Remarks,@LoginUserId
		--update outing Request detail table
		UPDATE OutingRequestDetail SET StatusId=@StatusId, ModifiedById=@LoginUserId,ModifiedDate=GETDATE() 
		WHERE OutingRequestId=@OutingRequestId AND StatusId <= 5 -- not rejected or cancelled
		--update Outing Request Table
		UPDATE OutingRequest set StatusId=@StatusId, NextApproverId=NULL, ModifiedById=@LoginUserId, ModifiedDate=GETDATE()
		WHERE OutingRequestId=@OutingRequestId AND StatusId <= 5 -- not rejected or cancelled
		SET @SuccessMsg=1;
	END
	--Rejected by HR
	ELSE IF(@StatusCode='RJH' )
	BEGIN
		INSERT INTO OutingRequestHistory(OutingRequestId,StatusId,Remarks,CreatedById)
		SELECT @OutingRequestId,@StatusId AS StatusId,@Remarks,@LoginUserId
		--update outing Request detail table
		UPDATE OutingRequestDetail SET StatusId=@StatusId, ModifiedById=@LoginUserId,ModifiedDate=GETDATE() 
		WHERE OutingRequestId=@OutingRequestId AND StatusId <= 5 -- not rejected or cancelled
		--update Outing Request Table
		UPDATE OutingRequest set StatusId=@StatusId, NextApproverId=NULL, ModifiedById=@LoginUserId, ModifiedDate=GETDATE()
		WHERE OutingRequestId=@OutingRequestId AND StatusId <= 5 -- not rejected or cancelled
		SET @SuccessMsg=1;
	END
	
  END
  SET @Success= @SuccessMsg;
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
/****** Object:  StoredProcedure [dbo].[spApplyLeave]    Script Date: 24-01-2019 18:27:30 ******/
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
	            DECLARE @FromDateId Bigint ,@TillDateId bigint;
                SELECT 
                    @FromDateId = MIN(DM.[DateId])
                ,@TillDateId = MAX(DM.[DateId])
                FROM 
                [dbo].[DateMaster] DM WITH (NOLOCK)
                WHERE 
                DM.[Date] BETWEEN  @FromDate	AND  @TillDate
	      
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
        
		 DECLARE @IsAlreadyApplied BIT = (SELECT  dbo.Fun_CheckIfLeaveAlreadyExists(@EmployeeId, @FromDateId, @TillDateId))

	------------check if already applied other types of leave --------
		 IF(@IsAlreadyApplied = 1)  
		 BEGIN
			SET @Success = 1  --date collision
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
/****** Object:  StoredProcedure [dbo].[spGetEmployeesWithNoAttendance]    Script Date: 24-01-2019 18:27:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetEmployeesWithNoAttendance]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGetEmployeesWithNoAttendance] AS' 
END
GO
 /***
   Created Date      :     2016-11-21
   Created By        :     Rakesh Gandhi
   Purpose           :     This stored procedure gets the date on which 
                           there is no data found for an employee in terms of attendance/leave or WFH
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   25 Sep 2018		Kanchan Kumari		 excluded out duty/tour data and replaced joins with vwActiveUsers
   --------------------------------------------------------------------------
    26 DEC 2018		Kanchan Kumari		 excluded LNSA data , not eligible data ,
	                                     advance leave data, Legitimate leave data and EmployeeWiseWeekOff data
   Test Cases        :
   --------------------------------------------------------------------------
   --- Test Case
         EXEC [dbo].[spGetEmployeesWithNoAttendance] @FromDate = '2019-01-20' ,@ToDate = '2019-01-21'
***/
ALTER PROCEDURE [dbo].[spGetEmployeesWithNoAttendance]
    @FromDate [date] 
   ,@ToDate [date]
AS
BEGIN
   SET NOCOUNT ON;
    IF OBJECT_ID('tempdb..#UserDateMapping') IS NOT NULL
	DROP TABLE #UserDateMapping

	IF OBJECT_ID('tempdb..#TempCalenderRoaster') IS NOT NULL
	DROP TABLE #TempCalenderRoaster

   --supplying a data contract
   IF 1 = 2 BEGIN
    SELECT
         CAST(null AS [date])        AS [Date]
        ,CAST(null AS [int])         AS [UserId]
        ,CAST(null AS [varchar](50)) AS [EmployeeName]
        ,CAST(null AS [varchar](50)) AS [MobileNo]
    WHERE 1 = 2  
   END

   --DECLARE @ToDate [date] = DATEADD(DD, -1, GETDATE())
    
	CREATE TABLE #UserDateMapping
	(
		 [DateId] [bigint] NOT NULL
		,[Date] [date] NOT NULL
		,[IsWeekend] BIT NOT NULL 
		,[UserId] [int] NOT NULL
		,[WeekNo] [INT] NOT NULL
		,[IsNormalWeek] BIT NOT NULL DEFAULT(1)
	)
	
	INSERT INTO #UserDateMapping([UserId],[DateId],[Date],[IsWeekend],[WeekNo])
	SELECT  U.[UserId], D.[DateId], D.[Date], D.[IsWeekend], (SELECT WeekNo FROM [dbo].[FetchDateAndWeekNo](D.[Date]))
	FROM [dbo].[DateMaster] D WITH (NOLOCK)
	CROSS JOIN [dbo].[vwActiveUsers] U WITH (NOLOCK)
	WHERE (D.[Date] BETWEEN @FromDate AND @ToDate) AND U.[JoiningDate] < @FromDate 
	      AND U.IsEligibleForLeave = 1 ---only eligible user 

    ----delete enties where date greater than currentdate -----------
	DELETE U 
	FROM #UserDateMapping U WITH (NOLOCK) WHERE [Date] > CAST(GETDATE() AS Date)
	-----------------------------------------------------------------

	CREATE TABLE #TempCalenderRoaster
	(
	 [UserId] INT NOT NULL,
	 [Date] DATE,
	 [WeekNo] INT NOT NULL
	)
    ----insert data from employeewiseweekoff -------------------
	INSERT INTO #TempCalenderRoaster (UserId, [Date], [WeekNo])
	SELECT UserId, DM.[Date],(SELECT WeekNo FROM [dbo].[FetchDateAndWeekNo](DM.[Date]))
	FROM EmployeeWiseWeekOff E JOIN DateMaster DM ON E.[WeekOffDateId] = DM.[DateId]
	WHERE IsActive = 1

	 ----update [IsNormalWeek] of #UserDateMapping -------------------
	UPDATE U SET U.[IsNormalWeek] = 0 
	--SELECT U.* 
	FROM #UserDateMapping U
	JOIN (SELECT UserId, WeekNo FROM #TempCalenderRoaster 
	GROUP BY UserId, WeekNo) N
	ON U.[UserId] = N.[UserId] AND U.[WeekNo] = N.[WeekNo]

    -- delete entries of employees for which data is available in #TempCalenderRoaster
	DELETE U 
	FROM #UserDateMapping U WITH (NOLOCK) JOIN #TempCalenderRoaster T 
	ON U.[UserId] = T.[UserId] AND U.[Date] = T.[Date] 

    -- delete entries for weekend for all user whose weekend is as normal weekend
    DELETE FROM #UserDateMapping 
	WHERE [IsNormalWeek] = 1 AND [IsWeekend] = 1

	-- delete entries for holidays 
	DELETE T
	FROM #UserDateMapping T WITH (NOLOCK)
	INNER JOIN [dbo].[ListofHoliday] H WITH (NOLOCK) ON T.[DateId] = H.[DateId] 

   -- delete management employees
	DELETE T
	FROM #UserDateMapping T WITH (NOLOCK)
	INNER JOIN [dbo].[ManagementEmployee] M WITH (NOLOCK) ON T.[UserId] = M.[UserId]

   -- delete entries for entries before date of joining
	DELETE T
	FROM #UserDateMapping T WITH (NOLOCK)
	INNER JOIN [dbo].[vwActiveUsers] U WITH (NOLOCK) ON T.[UserId] = U.[UserId]
	WHERE T.[Date] < U.[JoiningDate]

 -- delete entries for employees on Out duty/tour Leave
	DELETE T
	FROM #UserDateMapping T WITH (NOLOCK) 
	JOIN(
		SELECT R.UserId, OD.DateId FROM [dbo].[OutingRequest] R 
		INNER JOIN [dbo].[OutingRequestDetail] OD WITH (NOLOCK) ON R.[OutingRequestId] = OD.[OutingRequestId]
		WHERE OD.[StatusId] <=5
	   )N ON T.UserId = N.UserId AND T.DateId = N.[DateId]  --ie neither rejected nor cancelled  OutingRequestStatus

   -- delete entries for employees on leave or WFH
	DELETE T
	FROM #UserDateMapping T WITH (NOLOCK)
	INNER JOIN [dbo].[LeaveRequestApplication] L WITH (NOLOCK) ON T.[UserId] = L.[UserId] AND L.[StatusId] > 0--
	INNER JOIN [dbo].[DateWiseLeaveType] D WITH (NOLOCK) ON L.[LeaveRequestApplicationId] = D.[LeaveRequestApplicationId] AND T.[DateId] = D.[DateId]

	-- delete entries for employees available with temporary access cards
	DELETE T
	FROM #UserDateMapping T WITH (NOLOCK)
	INNER JOIN [dbo].[TempCardIssueDetail] I WITH (NOLOCK) 
		ON CONVERT([varchar](8), T.[Date], 112) = CONVERT([varchar](8), I.[IssueDate], 112) AND T.[UserId] = I.[EmployeeId]
               
	-- delete entries for employees for which attendance is available
	DELETE T
	FROM #UserDateMapping T WITH (NOLOCK)
	INNER JOIN [dbo].[DateWiseAttendance] D WITH (NOLOCK) ON T.[DateId] = D.[DateId] AND T.[UserId] = D.[UserId]

	-- delete entries for employees for which LNSA is applied 
	DELETE T
	FROM #UserDateMapping T WITH (NOLOCK)
	INNER JOIN [dbo].[DateWiseLNSA] D WITH (NOLOCK) ON T.[DateId] = D.[DateId] AND T.[UserId] = D.[CreatedBy]
	WHERE D.StatusId = 2 --pending for approval  --LNSAStatusMaster

	-- delete entries for employees whose entry are there in [AdvanceLeaveDetail]  table 
	DELETE T
	FROM #UserDateMapping T WITH (NOLOCK)
	INNER JOIN [dbo].[AdvanceLeaveDetail] D WITH (NOLOCK) ON T.DateId = D.DateId AND D.IsActive = 1
	INNER JOIN AdvanceLeave A WITH (NOLOCK) ON D.AdvanceLeaveId = A.AdvanceLeaveId AND T.[UserId] = A.[UserId]

	-- delete entries for employees whose entry is available in [LegitimateLeave]  table 
	DELETE T
	FROM #UserDateMapping T WITH (NOLOCK)
	INNER JOIN [dbo].[LegitimateLeaveRequest] LG WITH (NOLOCK) ON T.DateId = LG.DateId AND T.[UserId] = LG.DateId AND LG.StatusId <=5 -- not rejected or cancelled

	-- delete entries for employees for which attendance is available for Asquare
	DELETE T
	FROM #UserDateMapping T WITH (NOLOCK)
	INNER JOIN [dbo].[DateWiseAttendanceASquare] D WITH (NOLOCK) ON T.[UserId] = D.[UserId]
	INNER JOIN [dbo].[DateMaster] DM WITH (NOLOCK) ON DM.[DateId] = D.[DateId] AND DM.[Date] BETWEEN @FromDate AND @ToDate

   SELECT 
      T.[Date]
	 ,U.EmployeeName 
	 ,RM.EmployeeName AS [RM]
	 ,U.EmployeeCode AS EmployeeId
	 ,CASE WHEN U.IsIntern=1 THEN 'Yes' ELSE 'No' END AS Intern
     ,U.[UserId]
     ,U.[MobileNumber] AS [MobileNo]
   FROM #UserDateMapping T WITH (NOLOCK)
   LEFT JOIN [dbo].[vwActiveUsers] U WITH (NOLOCK) ON T.[UserId] = U.[UserId]
   LEFT JOIN [dbo].[vwActiveUsers] RM WITH (NOLOCK) ON U.[RMId] = RM.[UserId]
   WHERE  U.UserId <> 1 AND U.IsEligibleForLeave = 1
   GROUP BY T.[Date], U.EmployeeName, RM.EmployeeName, U.EmployeeCode, U.IsIntern, U.[UserId], U.[MobileNumber]   
   ORDER BY T.[Date], U.EmployeeName
END
GO
/****** Object:  StoredProcedure [dbo].[spGetUserAppliedLeave]    Script Date: 24-01-2019 18:27:30 ******/
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

   Test Cases        :
   --------------------------------------------------------------------------
   EXEC [dbo].[spGetUserAppliedLeave] 
		@UserId = 2432
		,@Year=2018
	    ,@IsWFHData = 1
		,@IsOutingData = 1
***/

ALTER PROCEDURE [dbo].[spGetUserAppliedLeave] 
   @UserID [int],
   @Year [int] = null,
   @IsWFHData [bit] = 0,
   @IsOutingData [bit] = 0
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
					SELECT UserId, DateId
					FROM [LegitimateLeaveRequest]    ----LegitimateLeaveStatus
					WHERE UserId = @UserId AND StatusId <= 5 --not rejected or cancelled
					GROUP BY UserId, DateId
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
					SELECT UserId, DateId
					FROM [LegitimateLeaveRequest]    ----LegitimateLeaveStatus
					WHERE UserId = @UserId AND StatusId <= 5 --not rejected or cancelled
					GROUP BY UserId, DateId
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

   IF(@IsOutingData = 1)
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

   SELECT [FetchLeaveType], [ApplyDate], [LeaveRequestApplicationId], [FromDate], [TillDate], [LeaveInfo] ,
	      [Reason], [Status], [StatusFullForm], [IsLegitimateApplied], [Remarks], [LeaveCount], [CreatedBy] 
   FROM #TempUserAppliedLeave 
   GROUP BY [FetchLeaveType], [ApplyDate], [LeaveRequestApplicationId], [FromDate], [TillDate], [LeaveInfo] ,
	        [Reason], [Status], [StatusFullForm], [IsLegitimateApplied], [Remarks], [LeaveCount], [CreatedBy] 
   ORDER BY [ApplyDate] DESC, [FromDate] DESC
   END
GO
/****** Object:  StoredProcedure [dbo].[spRequestWorkFromHome]    Script Date: 24-01-2019 18:27:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spRequestWorkFromHome]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spRequestWorkFromHome] AS' 
END
GO
/***
   Created Date      :     2016-01-25
   Created By        :     Nishant Srivastava
   Purpose           :     This stored procedure Apply Work From Home 
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   
   --------------------------------------------------------------------------

   Test Cases        :
   --------------------------------------------------------------------------
   
   --- Test Case 1
         EXEC  [dbo].[spRequestWorkFromHome]
                @Userid = 42
               ,@Date ='2016-01-29'
               ,@Reason= 'Test'
               ,@MobileNo = '12345678900'
               ,@LeaveType='WFH'
               ,@NoOfTotalDays=1
               ,@NoOfWorkingDays = 1
               ,@IsFirstHalfWfh = 0
               ,@IsLastHalfWfh = 0 
			   ,@LoginUserId = 1

   --- Test Case 2
         EXEC  [dbo].[spRequestWorkFromHome]
                @Userid = 79
               ,@Date ='2017-05-16'
               ,@Reason= 'Test'
               ,@MobileNo = '7856346677'
               ,@LeaveType='WFH'
               ,@NoOfTotalDays = 1
               ,@NoOfWorkingDays = 1
               ,@IsFirstHalfWfh = 0
               ,@IsLastHalfWfh = 0
			   ,@LoginUserId = 1
          DROP PROC  [spRequestWorkFromHome]
***/

ALTER PROCEDURE [dbo].[spRequestWorkFromHome]
 @UserId [int]
,@Date [Date]
,@Reason [varchar](500)
,@NoOfTotalDays [float]
,@NoOfWorkingDays [float]
,@MobileNo [varchar](15)
,@LeaveType [varchar](3)
,@IsFirstHalfWfh [bit]
,@IsLastHalfWfh [bit]
,@LoginUserId [INT]
AS
SET NOCOUNT ON;
SET FMTONLY OFF;
   BEGIN TRY  
   IF OBJECT_ID('tempdb..#Result') IS NOT NULL
   DROP TABLE #Result

    CREATE TABLE #Result(
	           [Success] INT,               
               [UserId] int
              ,[FirstName] [varchar](100)
              ,[LastName] [varchar](100)
              ,[EmailId] [varchar](200)
              )
			 
	DECLARE @DateId Bigint ,@TypeId Int, @Success INT
    SELECT @DateId  = [DateId]  FROM [dbo].[DateMaster] WITH (NOLOCK) WHERE [Date] = @Date
    SELECT @TypeId  = [TypeId]  FROM [dbo].[LeaveTypeMaster] WITH (NOLOCK) WHERE [ShortName] = @LeaveType 
                   
    BEGIN TRANSACTION         

	          DECLARE @ApproverId int
                  ,@StatusId int = 1
                  ,@ReportingManagerId int = (SELECT [dbo].[fnGetReportingManagerByUserId](@UserId))
                  ,@DepartmentHeadId int = (SELECT [dbo].[fnGetDepartmentHeadIdByUserId](@UserId))
                  ,@HRId int = (SELECT [dbo].[fnGetHRIdByUserId](@UserId))
               SET @ApproverId = @ReportingManagerId

            ------Check if already applied wfh or other leave by user for same date------
			 DECLARE @IsAlreadyApplied BIT = (SELECT  dbo.Fun_CheckIfLeaveAlreadyExists(@UserId, @DateId, @DateId))

	------------check if already applied other types of leave --------
		 IF(@IsAlreadyApplied = 1)  
		 BEGIN
			SET @Success = 2  --date collision
		 END
		 ELSE
		 BEGIN
            ------Insert into [LeaveRequestApplication] starts------            
               
               IF(@ReportingManagerId = 0 OR @ReportingManagerId = @HRId)
               BEGIN
                  IF(@DepartmentHeadId = 0)
                  BEGIN
                  SET @ApproverId = @HRId;
                  SET @StatusId = (SELECT [StatusId] FROM [dbo].[LeaveStatusMaster] WHERE [StatusCode] = 'PV')
               END
                  ELSE
                  BEGIN
                  SET @ApproverId = @DepartmentHeadId
                  SET @StatusId = (SELECT [StatusId] FROM [dbo].[LeaveStatusMaster] WHERE [StatusCode] = 'AP')
               END
               END

               INSERT INTO [LeaveRequestApplication] 
               (
                   [UserId]
                  ,[FromDateId]
                  ,[TillDateId]
                  ,[NoOfTotalDays]
                  ,[NoOfWorkingDays]
                  ,[Reason]
                  ,[PrimaryContactNo]
                  ,[IsAvailableOnMobile]
                  ,[IsAvailableOnEmail]
                  ,[StatusId]
                  ,[ApproverId]
                  ,[CreatedBy]
               )
               SELECT 
                      @UserId
                     ,@DateId                               AS FromDateId
                     ,@DateId                               AS TillDateId
                     ,@NoOfTotalDays                        AS NoOfTotalDays
                     ,@NoOfWorkingDays                      AS NoOfWorkingDays
                     ,@Reason                               AS [Reason]
                     ,@MobileNo                             AS [PrimaryContactNo]
                     ,1                                     AS IsAvailableOnMobile
                     ,1        
                     ,@StatusId                             AS IsAvailableOnEmail
                     ,@ApproverId                           AS ApproverId
                     ,@LoginUserId                          AS [CreatedBy]                           
                  ------Insert into [LeaveRequestApplication] ends------

            ------Insert into [LeaveRequestApplicationDetail] starts------
               DECLARE @LeaveRequestApplicationId [bigint]
               SET @LeaveRequestApplicationId = SCOPE_IDENTITY () 
               INSERT INTO [dbo].[LeaveRequestApplicationDetail]
               SELECT 
                     L.[LeaveRequestApplicationId]          AS LeaveRequestApplicationId
                     ,@TypeId                               AS [LeaveTypeId]
                     ,@NoOfWorkingDays                      AS [Count]             
               FROM 
                     [dbo].[LeaveRequestApplication] L WITH (NOLOCK) 
               WHERE 
                     [LeaveRequestApplicationId] = @LeaveRequestApplicationId
                     AND [UserId] = @UserId
               ------Insert into [LeaveRequestApplicationDetail] ends------

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
                  ,@LoginUserId

            ---------------------------------------Insert into LeaveHistory table ends---------------------------------------
            ------Insert into [DateWiseLeaveType] starts------
            IF(@IsFirstHalfWfh = 1)
            BEGIN
               INSERT INTO [dbo].[DateWiseLeaveType](
                     [LeaveRequestApplicationId]
                  ,[DateId]
                  ,[LeaveTypeId]
                  ,[IsHalfDay]
                  ,[IsFirstDayHalfDay]
                  )
               VALUES(
                  @LeaveRequestApplicationId
                  ,@DateId
                  ,@TypeId
                  ,1
                  ,1
                  )
            END
            ELSE IF(@IsLastHalfWfh = 1)
            BEGIN
               INSERT INTO [dbo].[DateWiseLeaveType](
                     [LeaveRequestApplicationId]
                  ,[DateId]
                  ,[LeaveTypeId]
                  ,[IsHalfDay]
                  ,[IsLastDayHalfDay]
                  )
               VALUES(
                  @LeaveRequestApplicationId
                  ,@DateId
                  ,@TypeId
                  ,1
                  ,1
                   )
            END
            ELSE  --WFH is for full day
            BEGIN
               INSERT INTO [dbo].[DateWiseLeaveType](
                     [LeaveRequestApplicationId]
                  ,[DateId]
                  ,[LeaveTypeId]
                  ,[IsHalfDay]
                  )
               VALUES(
                  @LeaveRequestApplicationId
                  ,@DateId
                  ,@TypeId
                  ,0
                  )
            END
            ------Insert into [DateWiseLeaveType] ends------         
           SET @Success = 1  -- successfully applied
         END         
COMMIT TRANSACTION;      
	INSERT INTO #Result
    SELECT @Success AS Success, M.[UserId], M.[FirstName], M.[LastName], M.[EmailId]
    FROM [dbo].[UserDetail] M WITH (NOLOCK) 
    INNER JOIN [dbo].[UserDetail] U WITH (NOLOCK) ON M.[UserId] = @ApproverId----change so that vm shoud not get mail
    WHERE U.[UserId] = @ApproverId    

      SELECT * FROM #Result
END TRY
BEGIN CATCH
	IF @@TRANCOUNT>0
	ROLLBACK TRANSACTION;
         DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
         EXEC [spInsertErrorLog]
	       @ModuleName = 'WorkFromHome'
         ,@Source = 'spRequestWorkFromHome'
         ,@ErrorMessage = @ErrorMessage
         ,@ErrorType = 'SP'
         ,@ReportedByUserId = @UserId

    INSERT INTO #Result(Success)VALUES(0)
  SELECT * FROM #Result
END CATCH


GO
