GO
/****** Object:  StoredProcedure [dbo].[spTakeActionOnWorkFromHome]    Script Date: 04-03-2019 12:56:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spTakeActionOnWorkFromHome]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spTakeActionOnWorkFromHome]
GO
/****** Object:  StoredProcedure [dbo].[spTakeActionOnDataVerificationRequest]    Script Date: 04-03-2019 12:56:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spTakeActionOnDataVerificationRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spTakeActionOnDataVerificationRequest]
GO
/****** Object:  StoredProcedure [dbo].[spTakeActionOnCompOff]    Script Date: 04-03-2019 12:56:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spTakeActionOnCompOff]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spTakeActionOnCompOff]
GO
/****** Object:  StoredProcedure [dbo].[spTakeActionOnAppliedLeave]    Script Date: 04-03-2019 12:56:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spTakeActionOnAppliedLeave]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spTakeActionOnAppliedLeave]
GO
/****** Object:  StoredProcedure [dbo].[Proc_TakeActionOnOutingRequest]    Script Date: 04-03-2019 12:56:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TakeActionOnOutingRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TakeActionOnOutingRequest]
GO
/****** Object:  StoredProcedure [dbo].[Proc_TakeActionOnLegitimateLeave]    Script Date: 04-03-2019 12:56:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TakeActionOnLegitimateLeave]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TakeActionOnLegitimateLeave]
GO
/****** Object:  StoredProcedure [dbo].[Proc_TakeActionOnLegitimateLeave]    Script Date: 04-03-2019 12:56:47 ******/
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
		  @LegitimateLeaveRequestId =104,
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

	DECLARE @StatusId INT, @StatusIdNew INT, @EmployeeId BIGINT,@FirstReportingId BIGINT , @SecondReportingId BIGINT,
	        @HRId BIGINT,@DateId BIGINT,@Reason VARCHAR(500), @Result INT = 2---request can not be processed

	DECLARE @count INT,@FromDateId INT,@TillDateId INT,@CountDate INT=0,@HRHeadId INT=2166,@StatusIdForHR INT
	SELECT @EmployeeId=[UserId] FROM [dbo].LegitimateLeaveRequest WITH (NOLOCK) WHERE LegitimateLeaveRequestId=@LegitimateLeaveRequestId
	SET @SecondReportingId= (SELECT [dbo].[fnGetSecondReportingManagerByUserId](@EmployeeId))
	SET @HRId=(SELECT [dbo].[fnGetHRIdByUserId](@EmployeeId))
	SET @FirstReportingId=(SELECT [dbo].[fnGetReportingManagerByUserId](@EmployeeId))
	SET @DateId=(SELECT DateId From LegitimateLeaveRequest where LegitimateLeaveRequestId=@LegitimateLeaveRequestId)
	SET @Reason=(SELECT Reason From LegitimateLeaveRequest where LegitimateLeaveRequestId=@LegitimateLeaveRequestId)

	DECLARE @LeaveRequestApplicationId BIGINT
					SET @LeaveRequestApplicationId=(SELECT LeaveRequestApplicationId FROM LegitimateLeaveRequest WHERE LegitimateLeaveRequestId=@LegitimateLeaveRequestId)
	
		SET @StatusIdForHR=(SELECT [StatusId] FROM [dbo].LegitimateLeaveRequest WITH (NOLOCK) WHERE LegitimateLeaveRequestId=@LegitimateLeaveRequestId)
		IF(@LoginUserId=@HRHeadId AND @StatusCode='AP' AND @StatusIdForHR!=2)
		BEGIN
		SET @StatusCode='VD'
		END
		SELECT @StatusId = [StatusId] FROM [dbo].[LegitimateLeaveStatus] WITH (NOLOCK) WHERE [StatusCode]=@StatusCode
	--Approved By first level Manager
	 IF(@StatusCode='AP')
	BEGIN
	     --VM-3
		 --PC-4
		 --AS -2203
		 --AP-2167
		  IF(@LoginUserId=@FirstReportingId)
		 BEGIN
			 IF(@SecondReportingId=0)
			 BEGIN
			 SET @SecondReportingId=@HRId
			 SET @StatusIdNew=(SELECT StatusId From OutingRequestStatus where StatusCode='PV')
			 END
			 ELSE
			 BEGIN
			  SET @StatusIdNew=(SELECT StatusId FROM OutingRequestStatus WHERE StatusCode='PA')
			 END
		
			INSERT INTO LegitimateLeaveRequestHistory(LegitimateLeaveRequestId,DateId,Reason,StatusId,Remarks,CreatedBy)
	                  VALUES( @LegitimateLeaveRequestId,@DateId,@Reason, @StatusId, @Remarks,@LoginUserId)
			-- Request Table
			UPDATE LegitimateLeaveRequest set NextApproverId=@SecondReportingId,StatusId=@StatusIdNew,LastModifiedBy=@LoginUserId, LastModifiedDate=GETDATE()
			WHERE LegitimateLeaveRequestId=@LegitimateLeaveRequestId
			SET @Result = 1;
		 END
			--Approved by Second level Manager
		  ELSE IF(@LoginUserId=@SecondReportingId)
			BEGIN
				SET @StatusIdNew=(SELECT StatusId FROM OutingRequestStatus WHERE StatusCode='PV')
			    INSERT INTO LegitimateLeaveRequestHistory(LegitimateLeaveRequestId,DateId,Reason,StatusId,Remarks,CreatedBy)
	              			VALUES( @LegitimateLeaveRequestId,@DateId,@Reason, @StatusId, @Remarks,@LoginUserId)

			    UPDATE LegitimateLeaveRequest SET NextApproverId=@HRId,StatusId=@StatusIdNew,LastModifiedBy=@LoginUserId, LastModifiedDate=GETDATE()
				   WHERE LegitimateLeaveRequestId=@LegitimateLeaveRequestId

              SET @Result = 1;
		
	          END
			  IF(@EmployeeId=@HRId)
			  BEGIN
			  print @HRId;
			   INSERT INTO LegitimateLeaveRequestHistory(LegitimateLeaveRequestId,DateId,Reason,StatusId,Remarks,CreatedBy)
	              			VALUES( @LegitimateLeaveRequestId,@DateId,@Reason, 5, @Remarks,@LoginUserId)

			    UPDATE LegitimateLeaveRequest SET NextApproverId=NULL,StatusId=5,LastModifiedBy=@LoginUserId, LastModifiedDate=GETDATE()
				   WHERE LegitimateLeaveRequestId=@LegitimateLeaveRequestId

              SET @Result = 1;
			  END
       END

	-- Verififed by HR
	ELSE IF(@StatusCode='VD')
	BEGIN
		INSERT INTO LegitimateLeaveRequestHistory(LegitimateLeaveRequestId,DateId,Reason,StatusId,Remarks,CreatedBy)
	              	VALUES( @LegitimateLeaveRequestId,@DateId,@Reason, @StatusId, @Remarks,@LoginUserId)
	    UPDATE LegitimateLeaveRequest set NextApproverId=NULL,StatusId=@StatusId,LastModifiedBy=@LoginUserId, LastModifiedDate=GETDATE()
		            WHERE LegitimateLeaveRequestId=@LegitimateLeaveRequestId
					
					Update LeaveRequestApplication SET StatusId=0,LastModifiedBy=@LoginUserId,LastModifiedDate=GETDATE()
					                             WHERE LeaveRequestApplicationId=@LeaveRequestApplicationId

					INSERT INTO LeaveHistory(LeaveRequestApplicationId,StatusId,ApproverId,ApproverRemarks,CreatedBy)
					VALUES (@LeaveRequestApplicationId,0,@LoginUserId,'LWP change request approved',@LoginUserId)


					UPDATE A SET A.[Count] =  A.[Count] - 1 FROM [dbo].[LeaveBalance] A WITH (NOLOCK)
					INNER JOIN LeaveTypeMaster B ON B.TypeId=A.LeaveTypeId
					WHERE B.ShortName='LWP' AND A.UserId=@EmployeeId
		SET @Result = 1;
    END
	--Rejected by Manager
	ELSE IF(@StatusCode='RJM' OR @StatusCode='RJH')
	BEGIN
	

	 ----------------update RequestCompOffDetail table starts---------------------------------------
	    UPDATE RequestCompOffDetail SET IsActive=0, ModifiedDate=GETDATE(), ModifiedById=@LoginUserId 
		            WHERE LegitimateLeaveRequestId=@LegitimateLeaveRequestId

  --------------update RequestCompOffDetail table ends-------------------------------------------
	   

  ----------------update RequestCompOff table starts----------------------------------------------

       DECLARE @RequestId INT
	   SET @RequestId=(SELECT RequestId FROM RequestCompOffDetail WHERE LegitimateLeaveRequestId=@LegitimateLeaveRequestId)
	    UPDATE RequestCompOff SET IsAvailed=0 WHERE RequestId=@RequestId

  --------------update RequestCompOff table ends---------------------------------------

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
        SET A.[Count] = A.[Count] + 1
	    FROM [dbo].[LeaveBalance] A WITH (NOLOCK)
        INNER JOIN LeaveTypeMaster B ON B.TypeId=A.LeaveTypeId
	    WHERE B.ShortName=@Id AND A.UserId=@EmployeeId
	 SET @Result = 1;
  END
	SET @Success = @Result
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
/****** Object:  StoredProcedure [dbo].[Proc_TakeActionOnOutingRequest]    Script Date: 04-03-2019 12:56:47 ******/
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
			 IF (@EmployeeId=@HRId)
                  BEGIN
				 --PRINT @HRId;
                 UPDATE M
                 SET M.[StatusId]=5 ,M.[NextApproverId]=NULL,M.[ModifiedDate]=GETDATE(),M.[ModifiedById]=@LoginUserId
                 FROM OutingRequest M WHERE  OutingRequestId=@OutingRequestId
				 UPDATE OutingRequestDetail SET StatusId=5, ModifiedById=@LoginUserId,ModifiedDate=GETDATE() 
			   WHERE OutingRequestId=@OutingRequestId AND StatusId <= 5 -- not rejected or cancelled
               INSERT INTO OutingRequestHistory(OutingRequestId,StatusId,Remarks,CreatedById)
			   SELECT @OutingRequestId,5,@Remarks,@LoginUserId
			   SET @SuccessMsg=1;
	END	  
	ELSE IF (@EmployeeId!=@HRId)
	BEGIN
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
/****** Object:  StoredProcedure [dbo].[spTakeActionOnAppliedLeave]    Script Date: 04-03-2019 12:56:47 ******/
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
         @LeaveRequestApplicationId = 14679
        ,@Status = 'CA' -- pending for verification
        ,@Remarks = 'Cancelled'
        ,@UserId = 2166
        ,@ForwardedId = 0 --or some other id
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
	
      IF EXISTS (SELECT 1 FROM [dbo].[LeaveRequestApplication] WITH (NOLOCK) 
					WHERE [LeaveRequestApplicationId] = @LeaveRequestApplicationId AND [LastModifiedBy] = @UserId AND [LastModifiedBy] <> 1)
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
  IF(@Status='PV')
  BEGIN
  DECLARE @ApprovedBy INT
  SET @ApprovedBy = (SELECT ApproverId FROM LeaveRequestApplication WHERE LeaveRequestApplicationId=@LeaveRequestApplicationId)
  IF (@EmployeeId=@ApprovedBy)
  BEGIN
  UPDATE M
  SET M.[StatusId]=3 ,M.[ApproverId]=NULL,M.[LastModifiedBy]=@UserId,M.[LastModifiedDate]=GETDATE()
  FROM LeaveRequestApplication M WHERE LeaveRequestApplicationId=@LeaveRequestApplicationId
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
          ,3       ------approved
		  ,@UserId
		  ,@Remarks
          ,GETDATE ()
          ,@UserId    ----system marked
  END
  END
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
	   
 ---------------update advance leave detail table --------------------
      UPDATE AdvanceLeaveDetail SET IsAdjusted = 0 
      WHERE AdjustedLeaveReqAppId = @LeaveRequestApplicationId AND IsAdjusted = 1 AND IsActive = 1

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
	  IF(@@TRANCOUNT > 0) 
       ROLLBACK TRANSACTION;

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
/****** Object:  StoredProcedure [dbo].[spTakeActionOnCompOff]    Script Date: 04-03-2019 12:56:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spTakeActionOnCompOff]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spTakeActionOnCompOff] AS' 
END
GO
/***
   Created Date      :     2015-10-08
   Created By        :     Nishant Srivastava
   Purpose           :     This stored procedure to Tacke Action On Apply Comp Off By manager 
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   10 Oct 2018        kanchan kumari      updated lapse date after verification
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   --- Test Case 1
          [spTakeActionOnCompOff] 
          @RequestID = 3813
         ,@Status = 'PV'
         ,@Remark = 'OK'
         ,@UserId =2203
         ,@IsVerified =0
***/

ALTER PROCEDURE [dbo].[spTakeActionOnCompOff]
 @RequestID [Bigint]
,@Status [varchar](10)
,@Remark [Varchar] (200)
,@UserId [int]
,@IsVerified [bit]
AS
BEGIN

SET NOCOUNT ON;
      BEGIN TRY
        DECLARE @ApplicantUserId int ,@Date Date ,@CurrentStatusId INT,@Result varchar(10)

		IF EXISTS (SELECT 1 FROM [dbo].[RequestCompOff] WITH (NOLOCK) WHERE [RequestId] = @RequestID AND [LastModifiedBy] = @UserId)
		BEGIN
			SELECT 'DUPLICATE'                                                                                   AS [Result]
			RETURN
		END
            
        BEGIN TRANSACTION
            SELECT @ApplicantUserId= CreatedBy ,@Date =DM.[Date]
            FROM [dbo].[RequestCompOff] R JOIN DateMaster DM
            ON DM.DateID=  R.DateId
            WHERE  R.[RequestID] = @RequestID 
           -- SELECT @Date
            SELECT  TOP 1 @CurrentStatusId = Statusid FROM [dbo].[RequestCompOffHistory] WHERE RequestId = @RequestID  ORDER BY CreatedDate DESC
              
            IF (@Status = 'CA' AND @UserID = @ApplicantUserId  AND @CurrentStatusId = 1 )
            BEGIN
			UPDATE R
			SET
				R.ApproverId = @Userid
				,R.LastModifiedDate = GETDATE()
				,R.LastModifiedBy = @UserId
			FROM [dbo].[RequestCompOff] R 
			WHERE R.[RequestId] = @RequestID 

            INSERT INTO [dbo].[RequestCompOffHistory](RequestId,StatusId,ApproverId,ApproverRemarks,CreatedBy)
            VALUES (@RequestID,0,@UserID,@Remark,@UserID)
            set @Result= 'SUCCEED'
            END            
            ELSE IF (@Status = 'RJ')
		      BEGIN
              ----------Leave balance count Updation on 
               IF (@CurrentStatusId = 3 )
               BEGIN
					UPDATE LB
					SET 
					LB.[count] = LB.[count]-R.[NoOfDays] 
					,LB.[LastmodifiedDate] = GETDATE()
					,LB.[LastModifiedBy] = @UserID
					FROM [dbo].[LeaveBalance] LB 
					INNER JOIN [RequestCompOff] R WITH (NOLOCK) ON R.[CreatedBy] = LB.[UserId] 
					INNER JOIN [dbo].[LeaveTypeMaster] T WITH (NOLOCK) ON T.TypeId = LB.LeaveTypeId
					WHERE R.RequestId = @RequestID AND LB.UserId = @UserID AND T.[ShortName] = 'COFF'
               END
            ---------Comp Off Status Update Of Reject
               BEGIN
					UPDATE R
					SET
					R.Statusid=-1,
					R.ApproverId = @Userid
					,R.LastModifiedDate = GETDATE()
					,R.LastModifiedBy = @UserId
					FROM [dbo].[RequestCompOff] R WITH (NOLOCK)
					WHERE R.RequestId = @RequestID 
			---------Comp Off Status Update Of 
                  INSERT INTO [dbo].[RequestCompOffHistory](RequestId,StatusId,ApproverId,ApproverRemarks,CreatedBy)
                  VALUES (@RequestID,-1,@UserID,@Remark,@UserID)
                  set @Result= 'SUCCEED'
               END 
            END
            
            ELSE IF (@Status = 'AP')
		      BEGIN
			  -----------------update Lapse date after verification by HR------------
			   DECLARE @VerifiedDate DATETIME = GETDATE() , @CurrentMonth int,@CurrentYear int,
			                                @TargetMonth int, @TargetYear int, @LapseDate date;
			    SELECT @CurrentMonth =  DATEPART(mm, @VerifiedDate)
                       ,@CurrentYear =  DATEPART(yy, @VerifiedDate);
						       
                SET @TargetMonth  = CASE
                                    WHEN @CurrentMonth > 10 THEN (@CurrentMonth - 10)
                                    ELSE @CurrentMonth + 2
                                    END
                SET @TargetYear  =  CASE
                                    WHEN @CurrentMonth > 10 THEN (@CurrentYear + 1)
                                    ELSE @CurrentYear
                                    END

                SET @LapseDate  = (SELECT TOP 1 [Date] FROM [dbo].[DateMaster] WITH (NOLOCK)
                                    WHERE DATEPART(mm, [Date]) = @TargetMonth
                                       AND DATEPART(yy, [Date]) = @TargetYear
                                    ORDER BY [Date] DESC)
                                     

			------------Comp Off Approved status update after verification
					UPDATE R
					SET
					 R.Statusid=3
					,R.ApproverId = @Userid
					,R.LapseDate = @LapseDate
					,R.LastModifiedDate = GETDATE()
					,R.LastModifiedBy = @UserId
					FROM [dbo].[RequestCompOff] R WITH (NOLOCK)
					WHERE R.RequestId = @RequestID 
  ----------CompOffHistory update with Approced Status After Hr Verification
				   INSERT INTO [dbo].[RequestCompOffHistory](RequestId,StatusId,ApproverId,ApproverRemarks,CreatedBy)
				   VALUES (@RequestID,3,@UserID,@Remark,@UserID)
                  ----------Leave balance count Updation on                                         
				   INSERT INTO [dbo].[LeaveBalanceHistory]([RecordId],[Count],[CreatedBy])
				   SELECT B.[RecordId],B.[Count],@UserId
				   FROM [dbo].[LeaveBalance] B WITH (NOLOCK)
				   INNER JOIN [dbo].[RequestCompOff] A WITH (NOLOCK) ON A.[CreatedBy] = B.[UserId]
				   INNER JOIN [dbo].[LeaveTypeMaster] M WITH (NOLOCK) ON B.[LeaveTypeId] = M.[TypeId] 
				   WHERE M.[ShortName] = 'COFF'
				   AND A.[RequestId] = @RequestID
					
				   UPDATE LB
				   SET LB.[count] = LB.[count] + R.[NoOfDays]
					   ,LB.[LastmodifiedDate] = GETDATE()
					   ,LB.[LastModifiedBy] = @UserID
				   FROM [dbo].[LeaveBalance] LB 
				   INNER JOIN [RequestCompOff] R WITH (NOLOCK) ON R.[CreatedBy] = LB.[UserId] 
				   INNER JOIN [dbo].[LeaveTypeMaster] T WITH (NOLOCK) ON T.TypeId = LB.LeaveTypeId
				   WHERE R.RequestId = @RequestID AND T.[ShortName] = 'COFF'    
				   
				                   
		 
               SET @Result= 'SUCCEED' 
            END 
                  
            ELSE IF (@Status = 'PV')
		      BEGIN
               DECLARE @EmployeeId int = (SELECT [CreatedBy] FROM [RequestCompOff] WHERE [RequestId] = @RequestID), @StatusId int, @ApproverId int
               DECLARE @FirstReportingManagerId int = (SELECT [dbo].[fnGetReportingManagerByUserId](@EmployeeId))
                      ,@SecondReportingManagerId int = (SELECT [dbo].[fnGetSecondReportingManagerByUserId](@EmployeeId))
                      ,@HRId int = (SELECT [dbo].[fnGetHRIdByUserId](@EmployeeId))
               --DECLARE @NoOfActionsOnRequest int = (SELECT COUNT(*) FROM [RequestCompOffHistory] WHERE [RequestId] = @RequestID AND [StatusId] > 0 AND [ApproverId] IN (@FirstReportingManagerId, @SecondReportingManagerId))

               IF(@UserId = @FirstReportingManagerId AND (@SecondReportingManagerId != 0 OR @SecondReportingManagerId != @HRId) AND @SecondReportingManagerId != 0)
               BEGIN
                  SET @ApproverId = @SecondReportingManagerId
                  SET @StatusId = (SELECT [StatusId] FROM [LeaveStatusMaster] WHERE [StatusCode] = 'PA')
               END
               ELSE IF(@UserId = @FirstReportingManagerId AND (@SecondReportingManagerId = 0 OR @SecondReportingManagerId = @HRId))
               BEGIN
                  SET @ApproverId = @HRId
                  SET @StatusId = (SELECT [StatusId] FROM [LeaveStatusMaster] WHERE [StatusCode] = 'PV')
               END
               ELSE IF(@UserId = @SecondReportingManagerId)
               BEGIN
                  SET @ApproverId = @HRId
                  SET @StatusId = (SELECT [StatusId] FROM [LeaveStatusMaster] WHERE [StatusCode] = 'PV')
               END   
			     IF (@EmployeeId=@ApproverId)
                  BEGIN
				 -- PRINT @ApproverId;
                 UPDATE M
                 SET M.[StatusId]=3 ,M.[ApproverId]=NULL,M.[LastModifiedDate]=GETDATE(),M.[LastModifiedBy]=@UserId
                 FROM [RequestCompOff] M WHERE [RequestId] = @RequestID
               INSERT INTO [dbo].[RequestCompOffHistory](RequestId,StatusId,ApproverId,ApproverRemarks,CreatedBy)
               VALUES(@RequestID,3,@UserId,@Remark --@StatusId
                     ,@UserId)    
			    SET @Result= 'SUCCEED' 
	END	  
	ELSE IF ((@EmployeeId!=@ApproverId))
	BEGIN                                      
		         UPDATE R
                     SET
                         R.ApproverId = @ApproverId  --2166              --Need to be replaced with HR ID
                        ,R.LastModifiedDate = GETDATE()
                        ,R.LastModifiedBy = @UserId
						,R.StatusID = @StatusId--2
                     FROM 
                           [dbo].[RequestCompOff] R WITH (NOLOCK)
                     WHERE 
                           R.RequestId = @RequestID 

               INSERT INTO [dbo].[RequestCompOffHistory](RequestId,StatusId,ApproverId,ApproverRemarks,CreatedBy)
               VALUES(@RequestID,2 --@StatusId
                     ,@UserID,@Remark,@UserID)     
				 SET @Result= 'SUCCEED' 
			END	
            END
            ELSE
            BEGIN
               SET @Result= 'FAILED' 
            END
			 
			   SELECT @Result AS [Result]
            
         COMMIT TRANSACTION
      END TRY
      BEGIN CATCH
	  IF (@@TRANCOUNT>0)
         ROLLBACK TRANSACTION;

         DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))

         EXEC [spInsertErrorLog]
	            @ModuleName = 'LeaveManagement'
            ,@Source = 'spTakeActionOnCompOff'
            ,@ErrorMessage = @ErrorMessage
            ,@ErrorType = 'SP'
            ,@ReportedByUserId = @UserId

         SELECT 'FAILED' AS [Result]
      END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[spTakeActionOnDataVerificationRequest]    Script Date: 04-03-2019 12:56:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spTakeActionOnDataVerificationRequest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spTakeActionOnDataVerificationRequest] AS' 
END
GO
/***
   Created Date      :     2016-02-09
   Created By        :     Nishant Srivastava
   Purpose           :     This stored procedure to take action On data change request 
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   --- Test Case 1
   EXEC [dbo].[spTakeActionOnDataVerificationRequest] 
            @RequestApplicationId = 162
            ,@Status ='PV'
            ,@Remark = 'Approved'
            ,@UserId = 2203
***/
ALTER PROCEDURE [dbo].[spTakeActionOnDataVerificationRequest]
 @RequestApplicationId [Bigint]
,@Status [varchar](10)
,@Remark [Varchar] (200)
,@UserId [int]
AS
BEGIN
SET NOCOUNT ON;
   BEGIN TRY
     DECLARE @Statusid INT
      IF EXISTS (SELECT 1 FROM [dbo].[AttendanceDataCHangeRequestApplication] WITH (NOLOCK) WHERE [RequestId] = @RequestApplicationId AND [LastModifiedBy] = @UserId)
      BEGIN
         SELECT 'DUPLICATE' AS [Result]
         RETURN
      END			
      BEGIN TRANSACTION
			SELECT @Statusid = Statusid 
         FROM [dbo].[LeaveStatusMaster]  WITH (NOLOCK) 
         WHERE [StatusCode] = @Status
                         
         IF (@Status = 'PV')
         BEGIN
            DECLARE @EmployeeId int = (SELECT [CreatedBy] FROM [AttendanceDataCHangeRequestApplication] WHERE [RequestId] = @RequestApplicationId), @ApproverId int
            DECLARE @FirstReportingManagerId int = (SELECT [dbo].[fnGetReportingManagerByUserId](@EmployeeId))
                     ,@SecondReportingManagerId int = (SELECT [dbo].[fnGetSecondReportingManagerByUserId](@EmployeeId))
                     ,@HRId int = (SELECT [dbo].[fnGetHRIdByUserId](@EmployeeId))
            --DECLARE @NoOfActionsOnRequest int = (SELECT COUNT(*) FROM [RequestCompOffHistory] WHERE [RequestId] = @RequestID AND [StatusId] > 0 AND [ApproverId] IN (@FirstReportingManagerId, @SecondReportingManagerId))
            
			IF(@UserId = @FirstReportingManagerId AND (@SecondReportingManagerId != 0 OR @SecondReportingManagerId != @HRId) AND @SecondReportingManagerId != 0)
            BEGIN
               SET @ApproverId = @SecondReportingManagerId
               SET @Statusid = (SELECT [StatusId] FROM [LeaveStatusMaster] WHERE [StatusCode] = 'PA')
            END
            ELSE IF(@UserId = @FirstReportingManagerId AND (@SecondReportingManagerId = 0 OR @SecondReportingManagerId = @HRId))
            BEGIN
               SET @ApproverId = @HRId
               SET @Statusid = (SELECT [StatusId] FROM [LeaveStatusMaster] WHERE [StatusCode] = 'PV')
            END
            ELSE IF(@UserId = @SecondReportingManagerId)
            BEGIN
			   SET @ApproverId = @HRId
               SET @Statusid = (SELECT [StatusId] FROM [LeaveStatusMaster] WHERE [StatusCode] = 'PV')
            END                                          
             IF (@EmployeeId=@ApproverId)
                  BEGIN
				-- PRINT @ApproverId;
                 UPDATE M
                 SET M.[StatusId]=3 ,M.[ApproverId]=NULL,M.[LastModifiedDate]=GETDATE(),M.[LastModifiedBy]=@UserId
                 FROM [AttendanceDataCHangeRequestApplication] M  WHERE [RequestId] = @RequestApplicationId
               INSERT INTO [AttendanceDataChangeRequestHistory](RequestId,StatusId,ApproverId,ApproverRemarks,CreatedDate)
			   SELECT @RequestApplicationId,3,@UserId,@Remark,GETDATE()
	END	  
	ELSE IF (@EmployeeId!=@ApproverId)
	BEGIN
			UPDATE DCR
            SET  
               StatusId = @Statusid 
               ,ApproverId = @ApproverId--2166
               ,ApproverRemarks = @Remark 
               ,LastModifiedBy = @UserId
               ,LastModifiedDate = GETDATE()  
            FROM 
               [AttendanceDataCHangeRequestApplication] DCR 
            WHERE [RequestId] = @RequestApplicationId

            INSERT INTO [AttendanceDataChangeRequestHistory](RequestId,StatusId,ApproverId,ApproverRemarks,CreatedDate)                     
			SELECT @RequestApplicationId,L.[StatusId],@UserId,@Remark,GetDate()
			FROM [dbo].[LeaveStatusMaster]  L WITH (NOLOCK) 
			WHERE [StatusCode] = 'AP'   
         END 
		 
       END  
         ELSE IF (@Status = 'RJ')
         BEGIN
            UPDATE DCR
            SET 
                StatusId = @Statusid 
               ,ApproverId = @UserId
               ,ApproverRemarks = @Remark 
               ,LastModifiedBy = @UserId
               ,LastModifiedDate = GETDATE()  
            FROM 
               [AttendanceDataCHangeRequestApplication] DCR
               WHERE [RequestId] = @RequestApplicationId
                        
            INSERT INTO [AttendanceDataChangeRequestHistory](RequestId,StatusId,ApproverId,ApproverRemarks,CreatedDate)
            VALUES (@RequestApplicationId,@Statusid,@UserId,@Remark,GetDate())
         END 

         ELSE IF (@Status = 'AP' )
         BEGIN
            UPDATE DCR
            SET  
				 StatusId = @Statusid
				,ApproverId = @UserId
				,ApproverRemarks = @Remark 
				,LastModifiedBy = @UserId
				,LastModifiedDate = GETDATE()  
            FROM 
               [AttendanceDataCHangeRequestApplication] DCR
            WHERE [RequestId] = @RequestApplicationId

            INSERT INTO [AttendanceDataChangeRequestHistory](RequestId,StatusId,ApproverId,ApproverRemarks,CreatedDate)
            VALUES (@RequestApplicationId,@Statusid,@UserId,@Remark,GetDate())                        
         END 
         
         SELECT 'SUCCEED' AS [Result]
      COMMIT TRANSACTION
   END TRY
   BEGIN CATCH      
      ROLLBACK TRANSACTION
      
      DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
      EXEC [spInsertErrorLog]
	      @ModuleName = 'LeaveManagement'
         ,@Source = 'spTakeActionOnDataVerificationRequest'
         ,@ErrorMessage = @ErrorMessage
         ,@ErrorType = 'SP'
         ,@ReportedByUserId = @UserId

      SELECT 'FAILED' AS [Result]
   END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[spTakeActionOnWorkFromHome]    Script Date: 04-03-2019 12:56:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spTakeActionOnWorkFromHome]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spTakeActionOnWorkFromHome] AS' 
END
GO
/***
   Created Date      :     2015-10-08
   Created By        :     Nishant Srivastava
   Purpose           :     This stored procedure to Tacke Action On Apply WFH By manager 
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   9-Nov-2017		 Sudhanshu			  Added @HRHeadId and StatusId if both are null(Cases where RM changes)
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   --- Test Case 1
   EXEC [dbo].[spTakeActionOnWorkFromHome] 
            @LeaveRequestApplicationId = 5642
            ,@Status = 'PV'
            ,@Remark = 'Test by Sudhanshu'
            ,@UserId = 2203
            ,@IsForwarded = 0
***/
ALTER PROCEDURE [dbo].[spTakeActionOnWorkFromHome]
 @LeaveRequestApplicationId [Bigint]
,@Status [varchar](10)
,@Remark [Varchar] (200)
,@UserId [int]
,@IsForwarded [bit]
AS
BEGIN
SET NOCOUNT ON ;
        DECLARE @ApplicantUserId int ,@Date Date ,@CurrentStatusId INT,@Statusid int,@Result varchar(10), @HRHeadId INT = 2166 -- Priyanka
		BEGIN TRY

            IF EXISTS (SELECT 1 FROM [dbo].[LeaveRequestApplication] WITH (NOLOCK) 
			WHERE [LeaveRequestApplicationId] = @LeaveRequestApplicationId AND [LastModifiedBy] = @UserId)
            BEGIN
               SELECT 'DUPLICATE' AS [Result]
               RETURN
            END

            BEGIN TRANSACTION
            
            SELECT @ApplicantUserId= CreatedBy ,@Date =DM.[Date]
            FROM [dbo].[LeaveRequestApplication] R WITH (NOLOCK) JOIN [dbo].[DateMaster] DM  WITH (NOLOCK)
            ON DM.DateID=  R.FromDateId
            WHERE  R.[LeaveRequestApplicationId] = @LeaveRequestApplicationId 
            
            SELECT   @CurrentStatusId = Statusid FROM [dbo].[LeaveRequestApplication]  WITH (NOLOCK) WHERE LeaveRequestApplicationId = @LeaveRequestApplicationId  
            ORDER BY CreatedDate DESC

            SELECT @Statusid= Statusid FROM [DBO].[LeaveStatusMaster]  WITH (NOLOCK) WHERE StatusCode =@Status              
			   IF(@Status = 'CA')
               BEGIN
                    IF (@UserID = @ApplicantUserId AND  @CurrentStatusId =1)
                    BEGIN
						UPDATE R
						SET
							R.ApproverId = @Userid
							,R.LastModifiedDate = GETDATE()
							,R.LastModifiedBy = @UserId
							,R.[StatusId] = @Statusid
							,R.[ApproverRemarks] =@Remark
						FROM [dbo].[LeaveRequestApplication] R 
						WHERE R.[LeaveRequestApplicationId] = @LeaveRequestApplicationId 

						INSERT INTO [dbo].[LeaveHistory] (LeaveRequestApplicationId,StatusId,ApproverId,ApproverRemarks,CreatedDate,CreatedBy)
						VALUES (@LeaveRequestApplicationId,@Statusid,@UserID,@Remark,GETDATE (),@UserID)
						set @Result= 'SUCCEED' 
                    END
                    ELSE 
                    BEGIN
						set @Result=  'FAILED' 
					END
               END 
               ELSE IF (@Status = 'PV')
               BEGIN
					DECLARE @EmployeeId int = (SELECT [UserId] FROM [LeaveRequestApplication] WHERE [LeaveRequestApplicationId] = @LeaveRequestApplicationId),
						@ApproverId INT

					DECLARE @FirstReportingManagerId int = (SELECT [dbo].[fnGetReportingManagerByUserId](@EmployeeId))
					,@SecondReportingManagerId int = (SELECT [dbo].[fnGetSecondReportingManagerByUserId](@EmployeeId))
					,@HRId int = (SELECT [dbo].[fnGetHRIdByUserId](@EmployeeId))
					,@DepartmentHeadId int = (SELECT [dbo].[fnGetDepartmentHeadIdByUserId](@EmployeeId))

					SELECT @ApproverId =  CASE
                              WHEN @UserId = @FirstReportingManagerId AND (@SecondReportingManagerId != 0 OR @SecondReportingManagerId != @HRId) AND @SecondReportingManagerId != 0 THEN @SecondReportingManagerId -- pending for approval
                              WHEN @UserId = @FirstReportingManagerId AND (@SecondReportingManagerId = 0 OR @SecondReportingManagerId = @HRId) AND @DepartmentHeadId != 0 THEN @DepartmentHeadId
                              WHEN @UserId = @FirstReportingManagerId AND (@SecondReportingManagerId = 0 OR @SecondReportingManagerId = @HRId) AND @DepartmentHeadId = 0 THEN @HRId
                              WHEN @UserId = @SecondReportingManagerId AND (@DepartmentHeadId = 0 OR @DepartmentHeadId = @HRId OR @SecondReportingManagerId = @DepartmentHeadId OR @FirstReportingManagerId = @DepartmentHeadId) THEN @HRId
                              WHEN @UserId = @SecondReportingManagerId AND @DepartmentHeadId != @HRId AND @SecondReportingManagerId != @DepartmentHeadId AND @FirstReportingManagerId != @DepartmentHeadId THEN @DepartmentHeadId                              
                              
                              WHEN @UserId = @DepartmentHeadId THEN @HRId
                              --WHEN @IsForwarded = 1 AND @UserId != 4 THEN  4
                              ELSE @HRHeadId
                           END
                         
  
  IF (@EmployeeId=@ApproverId)
  BEGIN
  UPDATE M
  SET M.[StatusId]=3 ,M.[ApproverId]=NULL,M.[LastModifiedBy]=@UserId,M.[LastModifiedDate]=GETDATE()
  FROM LeaveRequestApplication M WHERE LeaveRequestApplicationId=@LeaveRequestApplicationId
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
          ,3       ------approved
		  ,@UserId
		  ,@Remark
          ,GETDATE ()
          ,@UserId    ----system marked
		  set @Result= 'SUCCEED' 
  END
  ELSE IF (@EmployeeId!=@ApproverId)
  BEGIN
                   UPDATE R 
                        SET
						  R.[ApproverId] = @ApproverId
                          ,R.LastModifiedDate = GETDATE()
                          ,R.LastModifiedBy = @UserId
                          ,R.[StatusId] = CASE
                              WHEN @UserId = @FirstReportingManagerId AND (@SecondReportingManagerId != 0 OR @SecondReportingManagerId != @HRId) AND @SecondReportingManagerId != 0 THEN S1.[StatusId]
                              WHEN @UserId = @FirstReportingManagerId AND (@SecondReportingManagerId = 0 OR @SecondReportingManagerId = @HRId) AND @DepartmentHeadId != 0 THEN S1.[StatusId]
                              WHEN @UserId = @FirstReportingManagerId AND (@SecondReportingManagerId = 0 OR @SecondReportingManagerId = @HRId) AND @DepartmentHeadId = 0 THEN S.[StatusId]
                              WHEN @UserId = @SecondReportingManagerId AND (@DepartmentHeadId = 0 OR @DepartmentHeadId = @HRId OR @SecondReportingManagerId = @DepartmentHeadId OR @FirstReportingManagerId = @DepartmentHeadId) THEN S.[StatusId]
                              WHEN @UserId = @SecondReportingManagerId AND @DepartmentHeadId != @HRId AND @SecondReportingManagerId != @DepartmentHeadId AND @FirstReportingManagerId != @DepartmentHeadId THEN S1.[StatusId]                              
                              WHEN @UserId = @DepartmentHeadId THEN S.[StatusId]
                              --WHEN @IsForwarded = 1 AND @UserId != 4 THEN 1
                              ELSE @Statusid
                           END
                          ,R.[ApproverRemarks] = @Remark
                        FROM [dbo].[LeaveRequestApplication] R 
						INNER JOIN [dbo].[LeaveStatusMaster] S WITH (NOLOCK) ON S.[StatusCode] = @Status
                        INNER JOIN [dbo].[LeaveStatusMaster] S1 WITH (NOLOCK) ON S1.[StatusCode] = 'PA'
                        WHERE R.[LeaveRequestApplicationId] = @LeaveRequestApplicationId 

                     INSERT INTO [dbo].[LeaveHistory] (LeaveRequestApplicationId,StatusId,ApproverId,ApproverRemarks,CreatedDate,CreatedBy)
                     VALUES (@LeaveRequestApplicationId,@Statusid,@UserID,@Remark,GETDATE(),@UserID)
                     set @Result= 'SUCCEED' 
                   END
				   END
               ELSE
               BEGIN
                      UPDATE R
                        SET
                           R.ApproverId = @Userid
                          ,R.LastModifiedDate = GETDATE()
                          ,R.LastModifiedBy = @UserId
                          ,R.[StatusId] = @Statusid
                          ,R.[ApproverRemarks] =@Remark
                      FROM [dbo].[LeaveRequestApplication] R 
                        WHERE R.[LeaveRequestApplicationId] = @LeaveRequestApplicationId 

                     INSERT INTO [dbo].[LeaveHistory] (LeaveRequestApplicationId,StatusId,ApproverId,ApproverRemarks,CreatedDate,CreatedBy)
                     VALUES (@LeaveRequestApplicationId,@Statusid,@UserID,@Remark,GETDATE(),@UserID)
                     set @Result= 'SUCCEED' 
                  END 
				select @Result as Result
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION

		DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))

		EXEC [spInsertErrorLog]
			@ModuleName = 'LeaveManagement'
			,@Source = 'spTakeActionOnWorkFromHome'
			,@ErrorMessage = @ErrorMessage
			,@ErrorType = 'SP'
			,@ReportedByUserId = @UserId

		SELECT 'FAILURE' AS [Result]
	END CATCH
END

GO
