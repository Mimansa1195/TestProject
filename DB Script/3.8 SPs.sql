GO
/****** Object:  StoredProcedure [dbo].[spTakeActionOnAppliedLeave]    Script Date: 13/5/18 11:28:29 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spTakeActionOnAppliedLeave]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spTakeActionOnAppliedLeave]
GO
/****** Object:  StoredProcedure [dbo].[spPrepareAttendance]    Script Date: 13/5/18 11:28:29 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spPrepareAttendance]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spPrepareAttendance]
GO
/****** Object:  StoredProcedure [dbo].[spImportUserShiftMapping]    Script Date: 13/5/18 11:28:29 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spImportUserShiftMapping]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spImportUserShiftMapping]
GO
/****** Object:  StoredProcedure [dbo].[spGetUserAppliedCompOff]    Script Date: 13/5/18 11:28:29 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetUserAppliedCompOff]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetUserAppliedCompOff]
GO
/****** Object:  StoredProcedure [dbo].[spGetDatesToRequestCompOff]    Script Date: 13/5/18 11:28:29 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetDatesToRequestCompOff]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetDatesToRequestCompOff]
GO
/****** Object:  StoredProcedure [dbo].[spGetAttendanceRegisterForSupportingStaffMembers]    Script Date: 13/5/18 11:28:29 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetAttendanceRegisterForSupportingStaffMembers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetAttendanceRegisterForSupportingStaffMembers]
GO
/****** Object:  StoredProcedure [dbo].[spFetchUserCardMappingInfoById]    Script Date: 13/5/18 11:28:29 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spFetchUserCardMappingInfoById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spFetchUserCardMappingInfoById]
GO
/****** Object:  StoredProcedure [dbo].[spFetchAllUserAccessCardMappings]    Script Date: 13/5/18 11:28:29 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spFetchAllUserAccessCardMappings]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spFetchAllUserAccessCardMappings]
GO
/****** Object:  StoredProcedure [dbo].[spFetchAllUnmappedAccessCard]    Script Date: 13/5/18 11:28:29 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spFetchAllUnmappedAccessCard]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spFetchAllUnmappedAccessCard]
GO
/****** Object:  StoredProcedure [dbo].[spDeleteUserAccessCardMapping]    Script Date: 13/5/18 11:28:29 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spDeleteUserAccessCardMapping]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spDeleteUserAccessCardMapping]
GO
/****** Object:  StoredProcedure [dbo].[spApplyLeave]    Script Date: 13/5/18 11:28:29 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spApplyLeave]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spApplyLeave]
GO
/****** Object:  StoredProcedure [dbo].[spAddUserAccessCardMapping]    Script Date: 13/5/18 11:28:29 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spAddUserAccessCardMapping]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spAddUserAccessCardMapping]
GO
/****** Object:  StoredProcedure [dbo].[Proc_TakeActionOnOutingRequest]    Script Date: 13/5/18 11:28:29 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TakeActionOnOutingRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TakeActionOnOutingRequest]
GO
/****** Object:  StoredProcedure [dbo].[Proc_TakeActionOnLegitimateLeave]    Script Date: 13/5/18 11:28:29 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TakeActionOnLegitimateLeave]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TakeActionOnLegitimateLeave]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetAllUserUnMappedCardHistory]    Script Date: 13/5/18 11:28:29 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAllUserUnMappedCardHistory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetAllUserUnMappedCardHistory]
GO
/****** Object:  StoredProcedure [dbo].[Proc_FetchAllUnmappedStaffToAccessCard]    Script Date: 13/5/18 11:28:29 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_FetchAllUnmappedStaffToAccessCard]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_FetchAllUnmappedStaffToAccessCard]
GO
/****** Object:  StoredProcedure [dbo].[Proc_ApplyOutingRequest]    Script Date: 13/5/18 11:28:29 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_ApplyOutingRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_ApplyOutingRequest]
GO
/****** Object:  StoredProcedure [dbo].[Proc_ApplyLegitimateLeave]    Script Date: 13/5/18 11:28:29 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_ApplyLegitimateLeave]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_ApplyLegitimateLeave]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetOutingRequestByUserId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetOutingRequestByUserId]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetOutingReviewRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetOutingReviewRequest]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetLegitimateLeave]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetLegitimateLeave]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spUpdateUserAccessCardMapping]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spUpdateUserAccessCardMapping]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetUserAppliedLeave]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetUserAppliedLeave]
GO





/****** Object:  StoredProcedure [dbo].[Proc_ApplyLegitimateLeave]    Script Date: 13/5/18 11:28:29 PM ******/
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
	  
		  IF(@LeaveCombination LIKE '%COFF%' AND (SELECT count(RequestId) From RequestCompOff where IsLapsed=0 AND IsAvailed=0 AND CreatedBy=@EmployeeId AND LapseDate>@PreviousMonLastDate)=0)
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
			EXEC spGetAvailableLeaveCombination @NoOfWorkingDays =1, @UserId = @EmployeeId, @LeaveApplicationId = 0
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
					CREATE TABLE #TempCoffAvailed(
					RequestId INT,
					LapseDate DATE
					)
                   DECLARE @AvailedRequestId INT
                   INSERT INTO #TempCoffAvailed (RequestId,LapseDate) 
				   SELECT TOP 1 RequestId,LapseDate FROM RequestCompOff
		                     WHERE IsLapsed=0  AND IsAvailed=0 AND CreatedBy=@EmployeeId AND LapseDate>@PreviousMonLastDate ORDER BY LapseDate ASC,RequestId ASC

							SET @LapseDateToBeAvailed=(SELECT LapseDate FROM #TempCoffAvailed)
							SET @AvailedRequestId=(SELECT RequestId FROM #TempCoffAvailed)

							print @LapseDateToBeAvailed;
							print @AvailedRequestId;
		               UPDATE RequestCompOff SET IsAvailed=1 WHERE RequestId=@AvailedRequestId

---------------------------------------Update RequestCompOff ends---------------------------------------------------
---------------------------------------Insert into [RequestCompOffDetail] starts---------------------------------------
                        IF(@LeaveCombination LIKE '%COFF%')
                        BEGIN
							INSERT INTO [dbo].[RequestCompOffDetail](RequestId,LegitimateLeaveRequestId,CreatedById)
									VALUES(@AvailedRequestId,@LegitimateLeaveRequestId,@LoginUserId)
						END
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
		END
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
/****** Object:  StoredProcedure [dbo].[Proc_ApplyOutingRequest]    Script Date: 13/5/18 11:28:30 PM ******/
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
,@FromDate = '2018-02-9'
,@TillDate = '2018-02-16'
,@Reason = 'Testing by Kanchan'
,@OutingTypeId = 1
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
		VALUES(@OutingTypeId,@EmployeeId,@FromDateId,@TillDateId, @Reason, @PrimaryContactNo, @OtherContactNo,@StatusId,@ReportingManagerId,@LoginUserId)

		DECLARE @OutingRequestId BIGINT
		SET @OutingRequestId = SCOPE_IDENTITY()
		
		--insert into OutingRequestHistory table 
		INSERT INTO [dbo].[OutingRequestHistory]([OutingRequestId], [Remarks], [CreatedById])
		VALUES (@OutingRequestId, 'Applied', @LoginUserId)

		--insert into OutingRequestDetail
		 WHILE (@FromDateId <= @TillDateId)
			BEGIN
				INSERT INTO [dbo].[OutingRequestDetail]([OutingRequestId],[DateId],[StatusId], [CreatedById])
				VALUES(@OutingRequestId,@FromDateId,@StatusId,@EmployeeId)
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
/****** Object:  StoredProcedure [dbo].[Proc_FetchAllUnmappedStaffToAccessCard]    Script Date: 13/5/18 11:28:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_FetchAllUnmappedStaffToAccessCard]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_FetchAllUnmappedStaffToAccessCard] AS' 
END
GO
/***
   Created Date      :     2018-04-17
   Created By        :     kanchan kumari
   Purpose           :     This stored proc is used to get all unmapped satff for access card mapping
   Usage			 :	   EXEC [dbo].[proc_FetchAllUnmappedStaffToAccessCard]
   --------------------------------------------------------------------------
***/
ALTER PROC [dbo].[Proc_FetchAllUnmappedStaffToAccessCard]
AS
BEGIN
	SELECT RecordId AS [StaffUserId],EmployeeName AS [StaffName] 
	FROM SupportingStaffMember WITH (NOLOCK)
	WHERE RecordId NOT IN(SELECT StaffUserId FROM UserAccessCard WITH (NOLOCK) WHERE StaffUserId IS NOT NULL AND IsActive = 1 AND IsDeleted = 0)
END
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetAllUserUnMappedCardHistory]    Script Date: 13/5/18 11:28:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAllUserUnMappedCardHistory]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetAllUserUnMappedCardHistory] AS' 
END
GO

/***
   Created Date      :     2018-05-04
   Created By        :     kanchan kumari
   Purpose           :     This stored proc is used to get all user access card mapping
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   EXEC [dbo].[Proc_GetAllUserUnMappedCardHistory]

***/
ALTER PROC [dbo].[Proc_GetAllUserUnMappedCardHistory]
AS
BEGIN
SET NOCOUNT ON;
SET FMTONLY OFF;
IF OBJECT_ID('tempdb..##AccessCardHistoryTemp') IS NOT NULL
	DROP TABLE #AccessCardHistoryTemp

CREATE TABLE #AccessCardHistoryTemp
(
 [UserCardMappingId] INT NOT NULL,
 [AccessCardId] INT NOT NULL,
 [AccessCardNo] VARCHAR(20),
 [UserId] INT,
 [EmployeeName] VARCHAR(200),
 [EmployeeId] VARCHAR(20),
 [IsActive] BIT,
 [AssignedOn] VARCHAR(30),
 [AssignedFrom] VARCHAR(50),
 [AssignedTill] VARCHAR(50),
 [DeActivatedOn] VARCHAR(30),
 [DeActivatedBy] VARCHAR(50),
 [IsPimcoUserCardMapping] BIT NOT NULL,
 [IsFinalised]  BIT NOT NULL,
 [CreatedBy] VARCHAR(50)
)
INSERT INTO #AccessCardHistoryTemp([UserCardMappingId],[AccessCardId],[AccessCardNo],[UserId],[EmployeeName],[EmployeeId],[IsActive],[AssignedOn],
                               [AssignedFrom],[AssignedTill],[DeActivatedOn],[DeActivatedBy],[IsPimcoUserCardMapping],[IsFinalised],[CreatedBy])
   SELECT
       UC.[UserAccessCardId]                          AS [UserCardMappingId]
      ,A.[AccessCardId]                               AS [AccessCardId]
      ,A.[AccessCardNo]                               AS [AccessCardNo]
      ,UC.[UserId]                                    AS [UserId]
      ,LTRIM(RTRIM(REPLACE(REPLACE(REPLACE((UD.[FirstName] + ' ' + UD.[MiddleName] + ' ' + UD.[LastName]), ' ', '{}'), '}{',''), '{}', ' '))) AS [EmployeeName]
      ,UD.[EmployeeId]                                AS [EmployeeId]
      ,UC.[IsActive]                                  AS [IsActive]
	  ,CONVERT(VARCHAR(15),UC.[CreatedDate],106)+' '+FORMAT(UC.CreatedDate,'hh:mm tt')AS [AssignedOn]
	  ,CONVERT(VARCHAR(15),UC.[AssignedFromDate],106) AS [AssignedFrom]
	  ,CONVERT(VARCHAR(15),UC.[AssignedTillDate],106) AS [AssignedTill]
	  ,CONVERT(VARCHAR(15),UC.[LastModifiedDate],106)+' '+FORMAT(UC.[LastModifiedDate],'hh:mm tt') AS [DeActivatedOn]
	  ,UD1.FirstName+' '+UD1.LastName                 AS [DeActivatedBy]
      ,UC.[IsPimco]                                   AS [IsPimcoUserCardMapping]
      ,UC.[IsFinalised]                               AS [IsFinalised]
	  ,UD2.FirstName+' '+UD2.LastName                 AS [CreatedBy]
   FROM [dbo].[UserAccessCard] UC WITH (NOLOCK)
      INNER JOIN [dbo].[AccessCard] A WITH (NOLOCK) ON UC.[AccessCardId] = A.[AccessCardId]
      INNER JOIN [dbo].[UserDetail] UD WITH (NOLOCK) ON UC.[UserId] = UD.[UserId]
	  INNER JOIN [dbo].[UserDetail] UD1 WITH (NOLOCK) ON UC.[LastModifiedBy] = UD1.[UserId]
	  INNER JOIN [dbo].[UserDetail] UD2 WITH (NOLOCK) ON UC.[CreatedBy] = UD2.[UserId]
   WHERE UC.[IsDeleted] = 1 AND UC.[StaffUserId] IS NULL
   
INSERT INTO #AccessCardHistoryTemp([UserCardMappingId],[AccessCardId],[AccessCardNo],[UserId],[EmployeeName],[EmployeeId],[IsActive],[AssignedOn],
                               [AssignedFrom],[AssignedTill],[DeActivatedOn],[DeActivatedBy],[IsPimcoUserCardMapping],[IsFinalised],[CreatedBy])
    SELECT
       UC.[UserAccessCardId]                          AS [UserCardMappingId]
      ,A.[AccessCardId]                               AS [AccessCardId]
      ,A.[AccessCardNo]                               AS [AccessCardNo]
      ,UC.[StaffUserId]                               AS [UserId]
      ,SM.EmployeeName+'(Staff)'                      AS [EmployeeName]
      ,CAST('N.A' AS VARCHAR(5))                      AS [EmployeeId]
      ,UC.[IsActive]                                  AS [IsActive]
	  ,CONVERT(VARCHAR(15),UC.[CreatedDate],106)+' '+FORMAT(UC.CreatedDate,'hh:mm tt')AS [AssignedOn]
	  ,CONVERT(VARCHAR(15),UC.[AssignedFromDate],106) AS [AssignedFrom]
	  ,CONVERT(VARCHAR(15),UC.[AssignedTillDate],106) AS [AssignedTill]
	  ,CONVERT(VARCHAR(15),UC.[LastModifiedDate],106)+' '+FORMAT(UC.[LastModifiedDate],'hh:mm tt') AS [DeActivatedOn]
	  ,UD1.FirstName+' '+UD1.LastName                 AS [DeActivatedBy]
      ,UC.[IsPimco]                                   AS [IsPimcoUserCardMapping]
      ,UC.[IsFinalised]                               AS [IsFinalised]
	  ,UD2.FirstName+' '+UD2.LastName                 AS [CreatedBy]
   FROM [dbo].[UserAccessCard] UC WITH (NOLOCK)
      INNER JOIN [dbo].[AccessCard] A WITH (NOLOCK) ON UC.[AccessCardId] = A.[AccessCardId]
      INNER JOIN [dbo].[SupportingStaffMember] SM WITH (NOLOCK) ON SM.RecordId=UC.StaffUserId
	  INNER JOIN [dbo].[UserDetail] UD1 WITH (NOLOCK) ON UC.[LastModifiedBy] = UD1.[UserId]
	   INNER JOIN [dbo].[UserDetail] UD2 WITH (NOLOCK) ON UC.[CreatedBy] = UD2.[UserId]
   WHERE UC.[IsDeleted]=1 AND UC.[StaffUserId] IS NOT NULL 


   SELECT [UserCardMappingId],[AccessCardId],[AccessCardNo],[UserId],[EmployeeName],[EmployeeId],[IsActive],[AssignedOn],
         [AssignedFrom],[AssignedTill],[DeActivatedOn],[DeActivatedBy],[IsPimcoUserCardMapping],[IsFinalised],[CreatedBy] FROM #AccessCardHistoryTemp ORDER BY [EmployeeName]
END

GO
/****** Object:  StoredProcedure [dbo].[Proc_TakeActionOnLegitimateLeave]    Script Date: 13/5/18 11:28:30 PM ******/
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
		  @LegitimateLeaveRequestId =73,
		  @StatusCode='RJM',
		  @Remarks='cant',
		  @LoginUserId=3,
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
			 IF(@FirstReportingId IN(3,4,2203,2167))
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
		  ELSE IF(@LoginUserId=@SecondReportingId)
			BEGIN
				SET @StatusIdNew=(SELECT StatusId From OutingRequestStatus where StatusCode='PV')
			    INSERT INTO LegitimateLeaveRequestHistory(LegitimateLeaveRequestId,DateId,Reason,StatusId,Remarks,CreatedBy)
	              			VALUES( @LegitimateLeaveRequestId,@DateId,@Reason, @StatusId, @Remarks,@LoginUserId)
			    UPDATE LegitimateLeaveRequest set NextApproverId=@HRId,StatusId=@StatusIdNew,LastModifiedBy=@LoginUserId, LastModifiedDate=GETDATE()
				   WHERE LegitimateLeaveRequestId=@LegitimateLeaveRequestId
		
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
					VALUES (@LeaveRequestApplicationId,0,@LoginUserId,'LWP cancelled (legitimate leave approved)',@LoginUserId)


					UPDATE A SET A.[Count] =  A.[Count] - 1 FROM [dbo].[LeaveBalance] A WITH (NOLOCK)
					INNER JOIN LeaveTypeMaster B ON B.TypeId=A.LeaveTypeId
					WHERE B.ShortName='LWP' AND A.UserId=@EmployeeId
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
/****** Object:  StoredProcedure [dbo].[Proc_TakeActionOnOutingRequest]    Script Date: 13/5/18 11:28:30 PM ******/
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

	DECLARE @StatusId INT, @StatusIdNew INT, @EmployeeId BIGINT,@FirstReportingId BIGINT , @SecondReportingId BIGINT, @HRId BIGINT,@DepartmentHeadId BIGINT ,@HRHeadId INT=2166
	DECLARE @count INT,@FromDateId INT,@TillDateId INT,@CountDate INT=0,@StatusIdForHR INT
	SELECT @EmployeeId=[UserId] FROM [dbo].[OutingRequest] WITH (NOLOCK) WHERE [OutingRequestId]=@OutingRequestId
	SET @SecondReportingId= (SELECT [dbo].[fnGetSecondReportingManagerByUserId](@EmployeeId))
	SET @HRId=(SELECT [dbo].[fnGetHRIdByUserId](@EmployeeId))
	SET @FirstReportingId=(SELECT [dbo].[fnGetReportingManagerByUserId](@EmployeeId))
	SET @DepartmentHeadId= (SELECT [dbo].[fnGetDepartmentHeadIdByUserId](@EmployeeId))
		SET @StatusIdForHR=(SELECT [StatusId] FROM [dbo].[OutingRequest] WITH (NOLOCK) WHERE OutingRequestId=@OutingRequestId)
		IF(@LoginUserId=@HRHeadId AND @StatusCode='AP' AND @StatusIdForHR!=2 OR @HRHeadId=@DepartmentHeadId)
		BEGIN
		SET @StatusCode='VD'
		END
		SELECT @StatusId = [StatusId] FROM [dbo].[OutingRequestStatus] WITH (NOLOCK) WHERE [StatusCode]=@StatusCode

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
	ELSE IF(@StatusCode='AP')
	BEGIN
	     --VM-3
		 --PC-4
		 --AS -2203
		 --AP-2167
		 IF(@LoginUserId=@FirstReportingId)
		 BEGIN

			 IF(@FirstReportingId IN(3,4,2203,2167))
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
	     ELSE IF(@LoginUserId=@SecondReportingId)
	     BEGIN
			 IF(@SecondReportingId IN(3,4,2203,2167))
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
			WHERE OutingRequestId=@OutingRequestId
			--update Outing Request Table
			UPDATE OutingRequest set StatusId=@StatusIdNew, NextApproverId=@DepartmentHeadId, ModifiedById=@LoginUserId, ModifiedDate=GETDATE()
			WHERE OutingRequestId=@OutingRequestId

	       END
	     --Approved by Department head
			ELSE IF(@LoginUserId=@DepartmentHeadId)
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
   END
	-- Verififed by HR
	ELSE IF(@StatusCode='VD')
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
/****** Object:  StoredProcedure [dbo].[spAddUserAccessCardMapping]    Script Date: 13/5/18 11:28:30 PM ******/
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
   DECLARE @result [int]
         EXEC [dbo].[spAddUserAccessCardMapping]
		 @accessCardId = 284
        ,@userId = 4
        ,@IsPimcoUserCardMapping = 0
        ,@createdBy = 2167
		,@IsStaff = 1
		,@fromDate='2018-05-14'
		,@Success= @result output
		SELECT @result AS Result
***/
ALTER PROCEDURE [dbo].[spAddUserAccessCardMapping] 
(
      @AccessCardId [int]
     ,@UserId [int]
     ,@IsPimcoUserCardMapping [bit]
     ,@CreatedBy [int]
	 ,@IsStaff bit
	 ,@fromDate Date
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
		END
		ELSE
		BEGIN
			INSERT INTO [dbo].[UserAccessCard]
			( [AccessCardId], [StaffUserId], [IsPimco], [CreatedBy],[AssignedFromDate])
			VALUES
			( @AccessCardId, @UserId, @IsPimcoUserCardMapping, @CreatedBy, @fromDate)
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
    ROLLBACK TRANSACTION;

    DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
	 SET @Success=0;
    EXEC [spInsertErrorLog]
	        @ModuleName = 'AccessCard'
        ,@Source = 'spAddUserAccessCardMapping'
        ,@ErrorMessage = @ErrorMessage
        ,@ErrorType = 'SP'
        ,@ReportedByUserId = @UserId
   
END CATCH

GO
/****** Object:  StoredProcedure [dbo].[spApplyLeave]    Script Date: 13/5/18 11:28:30 PM ******/
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
             @EmployeeId = 2421
            ,@LoginUserId = 2421
            ,@FromDate = '2018-05-03'
            ,@TillDate = '2018-05-03'
            ,@Reason = 'testing2'
            ,@LeaveCombination= '1 COFF'
            ,@PrimaryContactNo = '223344244'
            ,@AlternateContactNo = '2233443322'
            ,@IsAvailableOnMobile = 0
            ,@IsAvailableOnEmail = 0
            ,@IsFirstDayHalfDay = 0
            ,@IsLastDayHalfDay = 0
			,@Success=@Result output
			SELECT @Result AS [RESULT]
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
   )
   AS
   BEGIN
      SET NOCOUNT ON;  
      SET FMTONLY OFF;
      BEGIN TRY
	  IF OBJECT_ID('tempdb..#TempCoffAvailed') IS NOT NULL
      DROP TABLE #TempCoffAvailed 

	  DECLARE @PreviousMonLastDate DATE,@LapseDateToBeAvailed DATE

	  SET @PreviousMonLastDate =(SELECT DATEADD(DAY,-1,DATEADD(DAY,1-DAY(@FromDate),@FromDate)) )
	  print @PreviousMonLastDate

	  IF(@LeaveCombination LIKE '%COFF%' AND (SELECT count(RequestId) From RequestCompOff where IsLapsed=0 AND IsAvailed=0 AND CreatedBy=@EmployeeId AND LapseDate>@PreviousMonLastDate)=0)
	  BEGIN
	     SET @Success=6--Applied COFF leave is either lapsed or availed
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
         
            CREATE TABLE #TempLeaveCombination([LeaveCombination] varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL)

            INSERT INTO #TempLeaveCombination
            EXEC spGetAvailableLeaveCombination @NoOfWorkingDays = @NoOfWorkingDays, @UserId = @EmployeeId, @LeaveApplicationId = 0
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
                           ,[AlternativeContactNo]
                           ,[LeaveCombination]
                        )
                        SELECT 
                            @EmployeeId
                           ,@FromDateId                                    
                           ,@TillDateId                                    
                           ,@NoOfTotalDays                                 
                           ,@NoOfWorkingDays                               
                           ,@Reason                                        
                           ,@PrimaryContactNo                              
                           ,@IsAvailableOnMobile                           
                           ,@IsAvailableOnEmail                            
                           ,@StatusId
                           ,@ApproverId                             
                           ,@LoginUserId                                   
                           ,@AlternateContactNo	
                           ,@LeaveCombination
                        --FROM
                        --   [dbo].[UserDetail] U  WITH (NOLOCK)
                        --WHERE U.UserId = @EmployeeId 
                        --AND U.[IsDeleted] = 0 
                        --AND U.[TerminateDate] IS NULL

						DECLARE @LeaveRequestApplicationId [bigint]
                        SET @LeaveRequestApplicationId = SCOPE_IDENTITY() 
---------------------------------------Insert into LeaveRequestApplication ends---------------------------------------
---------------------------------------Update RequestCompOff starts---------------------------------------------------
					CREATE TABLE #TempCoffAvailed(
					RequestId INT,
					LapseDate DATE
					)
                   DECLARE @AvailedRequestId INT
                   INSERT INTO #TempCoffAvailed (RequestId,LapseDate) 
				   SELECT TOP 1 RequestId,LapseDate FROM RequestCompOff
		                     WHERE IsLapsed=0  AND IsAvailed=0 AND CreatedBy=@EmployeeId AND LapseDate>@PreviousMonLastDate ORDER BY LapseDate ASC,RequestId ASC

							SET @LapseDateToBeAvailed=(SELECT LapseDate FROM #TempCoffAvailed)
							SET @AvailedRequestId=(SELECT RequestId FROM #TempCoffAvailed)

							print @LapseDateToBeAvailed;
							print @AvailedRequestId;
		               UPDATE RequestCompOff SET IsAvailed=1 WHERE RequestId=@AvailedRequestId

---------------------------------------Update RequestCompOff starts---------------------------------------------------
                     DECLARE @NoOfLeavesInCombination int, @IsLWP [bit], @LeaveType [varchar](10), @LeaveCount [float]
                        CREATE TABLE #TempLeaveDetail(
                            [Id] int IDENTITY(1, 1)
                           ,[LeaveCount] float
                           ,[LeaveType] varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL
                           ,[LeaveTypeId] int
                        )
                  
         SELECT * INTO #Combination FROM [dbo].[fnSplitWord](@LeaveCombination, '+')
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
---------------------------------------Insert into LeaveRequestApplicationDetail ends---------------------------------------

---------------------------------------Insert into [RequestCompOffDetail] starts---------------------------------------
                        IF(@LeaveCombination LIKE '%COFF%')
                        BEGIN
                    --       CREATE TABLE #TempCompOff(                            
                    --          [RequestId] bigint
                    --          ,[DateId] bigint
                    --          ,[RemainingDays] int
                    --       )
                    --       DECLARE @CompOffCount varchar(10) = (SELECT TOP 1 [Character] FROM #Combination)
                    --       SET @CompOffCount = REPLACE(@CompOffCount, ' COFF', '')
                    --       INSERT INTO #TempCompOff
                    --       EXEC spGetOldestAvailableCompOff @UserId = @EmployeeId 
                    --                                 ,@NoOfDays = @CompOffCount
						 
                    --SELECT --DISTINCT 
                    --          [RequestId], @LeaveRequestApplicationId FROM #TempCompOff
				    
                     
					 
                      INSERT INTO [dbo].[RequestCompOffDetail](RequestId,LeaveRequestApplicationId,CreatedById)
						                             VALUES(@AvailedRequestId,@LeaveRequestApplicationId,@LoginUserId)
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
                        WHILE (@StartDateId <= @TillDateId)
                        BEGIN
                           PRINT 'Enter outer most while loop : @StartDateId - ' + CAST(@StartDateId as VARCHAR) + ' @TillDateId - ' + CAST(@TillDateId as VARCHAR)
                           DECLARE @TotalNoOfLeavesCounter float = (SELECT SUM([LeaveCount]) FROM #TempLeaveDetail)
                                 ,@TotalNoOfDays int = (@TillDateId - @FromDateId) + 1
                                 ,@NoOfTypeOfLeaves int = (SELECT COUNT(*) FROM #TempLeaveDetail)
                                 ,@DateWiseLeaveCounter int = 1
                                 ,@TempDateWiseLeaveCounter int
                                 ,@LoopCount float
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
                                       SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
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
                        --PRINT 'Increase startdate 6'
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
                                 --PRINT 'Enter condition - both half days are present'
                                 --PRINT 'Enter data for - @StartDateId = @FromDateId'
                                 INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay], [IsLastDayHalfDay])
                                 SELECT @LeaveRequestApplicationId, @FromDateId, T.[LeaveTypeId], 1, 1
                                 FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                 --PRINT 'Increase startdate 3'
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
                                                      --print 'y'
                                                      INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay], [IsLastDayHalfDay])
                                                      SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 1, 1
                                                      FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                                   END
                                                   ELSE
                                                   BEGIN
                                                      --print 'z'
                                                      INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay])
                                                      SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 0
                                                      FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                                      --PRINT 'Increase startdate 6'
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
                                                      --PRINT 'Increase startdate 5'
                                                      SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                                   END
                                                   ELSE
                                                   BEGIN
                                                      --print 'a'
                                                      INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay])
            SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 0
                                                      FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                     --PRINT 'Increase startdate 4'
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
                                                --PRINT 'Increase startdate 3.2'
                                                --SET @StartDateId = @StartDateId + 1
                                                SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                             END
                                          END
                               END
                                       --print '@TempDateWiseLeaveCounter: ' + cast(@TempDateWiseLeaveCounter as varchar(10)) 
                                       SET @TempDateWiseLeaveCounter = @TempDateWiseLeaveCounter + 1
                                    END
                                    SET @DateWiseLeaveCounter = @DateWiseLeaveCounter + 1
                                 END
                                    --PRINT 'Enter data for - @StartDateId =  @TillDateId'
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
                                    --PRINT 'Enter condition - first day half day'

                                    --PRINT 'Enter data for - @StartDateId = @FromDateId'
                                    INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay], [IsFirstDayHalfDay])
                                    SELECT @LeaveRequestApplicationId, @FromDateId, T.[LeaveTypeId], 1, 1
                                    FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                    --PRINT 'Increase startdate 3'
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
                                                         --print 'y'
                                                         INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay], [IsFirstDayHalfDay])
                                                         SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 1, 1
                                                         FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                                      END
                                                      ELSE
                                                      BEGIN
                                                         --print 'z'
                                                         INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay])
                                                         SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 0
                                                         FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                                         --PRINT 'Increase startdate 6'
                                                         SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                                      END
                                                   END
                                                   ELSE
                                                   BEGIN
                                                      INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay])
                                                      SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 0
                                                      FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                                      --PRINT 'Increase startdate 4'
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
                                                      --PRINT 'Increase startdate 3.2'
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
                                                      --PRINT 'Increase startdate 3.3'
                                                      SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                                   END                     
                                                   ELSE
                                                   BEGIN
                                                      INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay])
                                                      SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 0
                                                      FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                              --PRINT 'Increase startdate 3.2'
                                                      SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                                   END
                                                END
                  END
                                          END
           --print '@TempDateWiseLeaveCounter: ' + cast(@TempDateWiseLeaveCounter as varchar(10)) 
                                          SET @TempDateWiseLeaveCounter = @TempDateWiseLeaveCounter + 1
                                       END
                                       SET @DateWiseLeaveCounter = @DateWiseLeaveCounter + 1
                                    END
                                 END
                                 ELSE IF(@IsLastDayHalfDay = 1)--lastday marked as half day
                                 BEGIN
                                    --PRINT 'Enter condition - last day half day'
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
                                                   --PRINT 'Increase startdate 6'
                                                   SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                                END
                                                ELSE
                                                BEGIN
                                                   IF(@TempDateWiseLeaveCounter = 1)
                                                   BEGIN
                                                         INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay], [IsLastDayHalfDay])
                                                         SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 1, 1
                                                         FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                                         --PRINT 'Increase startdate 3.5'
                                                         SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                                   END
                                                   ELSE
                                                   BEGIN
                                                      INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay])
                                                      SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 0
                                     FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                                      --PRINT 'Increase startdate 4'
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
                                       --PRINT 'Increase startdate 3.5'
                                                      END
                                                      ELSE
                                                      BEGIN
                                                         INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay])
                                                         SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 0
                                                         FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                                         --PRINT 'Increase startdate 3.6'
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
                                                         --PRINT 'Increase startdate 3.2'
                                                  SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                                      END
                                                   END
                                                END
                                                ELSE
                                                BEGIN
                                                   INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay])
                                                   SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 0
                                                   FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                                   --PRINT 'Increase startdate 3.2'
                                                   SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                                END
                                             END
                                          END
                                          --print '@TempDateWiseLeaveCounter: ' + cast(@TempDateWiseLeaveCounter as varchar(10)) 
                                          SET @TempDateWiseLeaveCounter = @TempDateWiseLeaveCounter + 1
                                       END
                                       SET @DateWiseLeaveCounter = @DateWiseLeaveCounter + 1
                                    END
                                       --PRINT 'Enter data for - @StartDateId = @TillDateId'
                                       INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay], [IsLastDayHalfDay])
                                       SELECT @LeaveRequestApplicationId, @TillDateId, T.[LeaveTypeId], 1, 1
                                       FROM #TempLeaveDetail T WHERE [Id] = (@DateWiseLeaveCounter-1)
                                       --PRINT 'Increase startdate 3'
                                       SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                 END
                                 ELSE
                                 BEGIN                                    
                                    SET @Success=5--data supplied is incorrect
                                    ROLLBACK TRANSACTION
                                 END
                              END
                           END
                           --PRINT 'Increase startdate 1'
                           SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
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
                           B.[UserId] = @EmployeeId AND T.[LeaveType] != 'LWP'
                  
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
                           B.[UserId] = @EmployeeId AND T.[LeaveType] = 'LWP'
                  
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
         ROLLBACK TRANSACTION

         DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))

         EXEC [spInsertErrorLog]
	          @ModuleName = 'LeaveManagement'
            ,@Source = 'spApplyLeave'
            ,@ErrorMessage = @ErrorMessage
            ,@ErrorType = 'SP'
            ,@ReportedByUserId = @EmployeeId

       SET @Success=0
      END CATCH
   END

GO
/****** Object:  StoredProcedure [dbo].[spDeleteUserAccessCardMapping]    Script Date: 13/5/18 11:28:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spDeleteUserAccessCardMapping]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spDeleteUserAccessCardMapping] AS' 
END
GO
/***
   Created Date      :     2016-09-27
   Created By        :     Shubhra Upadhyay
   Purpose           :     This stored proc is used to deactivate card
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   2018-05-07         kanchan kumari    deactivate card and insert Assigned till date
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   DECLARE @Result [int]
         EXEC [dbo].[spDeleteUserAccessCardMapping]
			  @userCardMappingId = 426
             ,@LoginUserId = 1
			 ,@AssignedTillDate='2018-04-17'
			 ,@Success= @Result  output
			 SELECT @Result  AS Result
***/
ALTER PROCEDURE [dbo].[spDeleteUserAccessCardMapping] 
(
      @UserCardMappingId [int]
     ,@LoginUserId [int]
	 ,@AssignedTillDate [Date]
	 ,@Success [tinyint] output
)
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @UserId INT, @AssignedFromDate DATE
     SELECT @AssignedFromDate =AssignedFromDate FROM UserAccessCard WITH (NOLOCK) WHERE UserAccessCardId=@UserCardMappingId

	 IF(@AssignedTilldate>=@AssignedFromDate)
	 BEGIN
      BEGIN TRANSACTION
         UPDATE [dbo].[UserAccessCard]
            SET
                [IsDeleted] = 1
               ,[IsActive] = 0
               ,[LastModifiedBy] = @LoginUserId
               ,[LastModifiedDate] = GETDATE()
			   ,[AssignedTillDate]=@AssignedTillDate
         WHERE [UserAccessCardId] = @UserCardMappingId
         SET @Success = 1 -- successfully deactivated
      COMMIT TRANSACTION;
	 END
	 ELSE
	 BEGIN
		SET @Success = 2 -- assigned till date should be greater than or equal to  Assigned From date
	 END
END TRY
BEGIN CATCH
      ROLLBACK TRANSACTION;
      DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
      EXEC [spInsertErrorLog]
	         @ModuleName = 'AccessCard'
         ,@Source = 'spDeleteUserAccessCardMapping'
         ,@ErrorMessage = @ErrorMessage
         ,@ErrorType = 'SP'
         ,@ReportedByUserId = @LoginUserId
          SET @Success = 0
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[spFetchAllUnmappedAccessCard]    Script Date: 13/5/18 11:28:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spFetchAllUnmappedAccessCard]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spFetchAllUnmappedAccessCard] AS' 
END
GO
/***
   Created Date      :     2016-09-27
   Created By        :     Shubhra Upadhyay
   Purpose           :     This stored proc is used to get all user access card mapping
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   --- Test Case 1
         EXEC [dbo].[spFetchAllUnmappedAccessCard]
***/
ALTER PROCEDURE [dbo].[spFetchAllUnmappedAccessCard] 
AS
BEGIN
	SET NOCOUNT ON;
	SELECT A.[AccessCardId] AS [CardId], A.[AccessCardNo] AS [CardNo]
	FROM [dbo].[AccessCard] A WITH (NOLOCK)
	LEFT JOIN (SELECT UC.[AccessCardId] FROM [dbo].[UserAccessCard]  UC WITH (NOLOCK)WHERE UC.[IsDeleted] = 0) T ON A.[AccessCardId] = T.[AccessCardId]
	WHERE --(UC.[AccessCardId] IS NULL OR UC.[IsDeleted] = 1)
		T.[AccessCardId] IS NULL
		AND A.[IsDeleted] = 0
		AND A.[IsActive] = 1
	ORDER BY A.[AccessCardNo]
END
GO
/****** Object:  StoredProcedure [dbo].[spFetchAllUserAccessCardMappings]    Script Date: 13/5/18 11:28:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spFetchAllUserAccessCardMappings]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spFetchAllUserAccessCardMappings] AS' 
END
GO

/***
   Created Date      :     2016-09-27
   Created By        :     Shubhra Upadhyay
   Purpose           :     This stored proc is used to get all user access card mapping
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   2018-05-04         kanchan              to get staff user access card mapping too
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   EXEC [dbo].[spFetchAllUserAccessCardMappings]
***/
ALTER PROCEDURE [dbo].[spFetchAllUserAccessCardMappings] 
AS
BEGIN
SET NOCOUNT ON;
SET FMTONLY OFF;

IF OBJECT_ID('tempdb..#AccessCardTemp') IS NOT NULL
	DROP TABLE #AccessCardTemp

CREATE TABLE #AccessCardTemp
([UserCardMappingId] INT NOT NULL,
 [AccessCardId] INT NOT NULL,
 [AccessCardNo] VARCHAR(50),
 [UserId] INT,
 [EmployeeName] VARCHAR(200),
 [EmployeeId] VARCHAR(20),
 [IsActive] BIT,
 [AssignedOn] VARCHAR(30),
 [AssignedFrom] VARCHAR(50),
 [IsPimcoUserCardMapping] BIT NOT NULL,
 [IsFinalised]  BIT NOT NULL,
 [CreatedBy] VARCHAR(50) ,
 [AssignedDate] DATE
 )
INSERT INTO #AccessCardTemp ([UserCardMappingId],[AccessCardId],[AccessCardNo],[UserId],[EmployeeName],[EmployeeId],[IsActive],[AssignedOn],
                               [AssignedFrom],[IsPimcoUserCardMapping],[IsFinalised],[CreatedBy],[AssignedDate])
   SELECT
       UC.[UserAccessCardId]                          AS [UserCardMappingId]
      ,A.[AccessCardId]                               AS [AccessCardId]
      ,A.[AccessCardNo]                               AS [AccessCardNo]
      ,UC.[UserId]                                    AS [UserId]
      ,LTRIM(RTRIM(REPLACE(REPLACE(REPLACE((UD.[FirstName] + ' ' + UD.[MiddleName] + ' ' + UD.[LastName]), ' ', '{}'), '}{',''), '{}', ' '))) AS [EmployeeName]
      ,UD.[EmployeeId]                                AS [EmployeeId]
      ,UC.[IsActive]                                  AS [IsActive]
	  ,CONVERT(VARCHAR(15),UC.[CreatedDate],106)+' '+FORMAT(UC.CreatedDate,'hh:mm tt')AS [AssignedOn]
	  ,CONVERT(VARCHAR(15),UC.[AssignedFromDate],106) AS [AssignedFrom]
      ,UC.[IsPimco]                                   AS [IsPimcoUserCardMapping]
      ,UC.[IsFinalised]                               AS [IsFinalised]
	  ,UD1.FirstName+' '+UD1.LastName                 AS [CreatedBy]
	  ,UC.[AssignedFromDate]                          AS [AssignedDate]
   FROM [dbo].[UserAccessCard] UC WITH (NOLOCK)
      INNER JOIN [dbo].[AccessCard] A WITH (NOLOCK) ON UC.[AccessCardId] = A.[AccessCardId]
      INNER JOIN [dbo].[UserDetail] UD WITH (NOLOCK) ON UC.[UserId] = UD.[UserId]
	  INNER JOIN [dbo].[UserDetail] UD1 WITH (NOLOCK) ON UC.[CreatedBy]=UD1.UserId
   WHERE UC.[IsDeleted] = 0 AND UC.[StaffUserId] IS NULL
 
   INSERT INTO #AccessCardTemp ([UserCardMappingId],[AccessCardId],[AccessCardNo],[UserId],[EmployeeName],[EmployeeId],[IsActive],[AssignedOn],
                               [AssignedFrom],[IsPimcoUserCardMapping],[IsFinalised],[CreatedBy],[AssignedDate])
   
    SELECT
       UC.[UserAccessCardId]                          AS [UserCardMappingId]
      ,A.[AccessCardId]                               AS [AccessCardId]
      ,A.[AccessCardNo]                               AS [AccessCardNo]
      ,UC.[StaffUserId]                               AS [UserId]
      ,SM.EmployeeName+'(Staff)'                      AS [EmployeeName]
      ,CAST('N.A' AS VARCHAR(5))                      AS [EmployeeId]
      ,UC.[IsActive]                                  AS [IsActive]
	  ,CONVERT(VARCHAR(15),UC.[CreatedDate],106)+' '+FORMAT(UC.CreatedDate,'hh:mm tt')AS [AssignedOn]
	  ,CONVERT(VARCHAR(15),UC.[AssignedFromDate],106) AS [AssignedFrom]
      ,UC.[IsPimco]                                   AS [IsPimcoUserCardMapping]
      ,UC.[IsFinalised]                               AS [IsFinalised]
	  ,UD1.FirstName+' '+UD1.LastName                 AS [CreatedBy]
	  ,UC.[AssignedFromDate]                          AS [AssignedDate]
   FROM [dbo].[UserAccessCard] UC WITH (NOLOCK)
      INNER JOIN [dbo].[AccessCard] A WITH (NOLOCK) ON UC.[AccessCardId] = A.[AccessCardId]
      INNER JOIN [dbo].[SupportingStaffMember] SM WITH (NOLOCK) ON SM.RecordId=UC.StaffUserId
	  INNER JOIN [dbo].[UserDetail] UD1 WITH (NOLOCK) ON UC.[CreatedBy]=UD1.UserId
   WHERE UC.[IsDeleted]=0 AND UC.[StaffUserId] IS NOT NULL 
   
   SELECT [UserCardMappingId],[AccessCardId],[AccessCardNo],[UserId],[EmployeeName],[EmployeeId],[IsActive],[AssignedOn],
                  [AssignedFrom],[IsPimcoUserCardMapping],[IsFinalised],[CreatedBy],[AssignedDate] FROM #AccessCardTemp ORDER BY [EmployeeName]
END
GO
/****** Object:  StoredProcedure [dbo].[spFetchUserCardMappingInfoById]    Script Date: 13/5/18 11:28:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spFetchUserCardMappingInfoById]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spFetchUserCardMappingInfoById] AS' 
END
GO

/***
   Created Date      :     2016-09-27
   Created By        :     Shubhra Upadhyay
   Purpose           :     This stored proc is used to get all user access card mapping
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   --- Test Case 1
         EXEC [dbo].[spFetchUserCardMappingInfoById]
         @UserCardMappingId = 418
***/
ALTER PROCEDURE [dbo].[spFetchUserCardMappingInfoById]
(
   @UserCardMappingId [int]
) 
AS
BEGIN
	SET NOCOUNT ON;
   SELECT
       UD.[UserId]                                    AS [UserId]
      ,UD.[FirstName] + ' ' + UD.[LastName]           AS [EmployeeName]
      ,A.[AccessCardId]                               AS [AccessCardId]
      ,A.[AccessCardNo]                               AS [AccessCardNo]
      ,UC.[IsPimco]                                   AS [IsPimcoUserCardMapping]
   FROM
      [dbo].[UserAccessCard] UC WITH (NOLOCK)
      INNER JOIN
         [dbo].[UserDetail] UD WITH (NOLOCK)
            ON UC.[UserId] = UD.[UserId]
      INNER JOIN
         [dbo].[AccessCard] A WITH (NOLOCK)
            ON UC.[AccessCardId] = A.[AccessCardId]
   WHERE 
      UC.[UserAccessCardId] = @UserCardMappingId AND UC.StaffUserId IS NULL

	  UNION

	  SELECT
       UC.[StaffUserId]                                    AS [UserId]
      ,SM.EmployeeName+' (Staff)'                        AS [EmployeeName]
      ,A.[AccessCardId]                               AS [AccessCardId]
      ,A.[AccessCardNo]                               AS [AccessCardNo]
      ,UC.[IsPimco]                                   AS [IsPimcoUserCardMapping]
   FROM
      [dbo].[UserAccessCard] UC WITH (NOLOCK)
      INNER JOIN
         [dbo].[AccessCard] A WITH (NOLOCK)
            ON UC.[AccessCardId] = A.[AccessCardId]
			INNER JOIN [dbo].[SupportingStaffMember] SM ON SM.RecordId=UC.StaffUserId 
   WHERE 
      UC.[UserAccessCardId] = @UserCardMappingId AND UC.StaffUserId IS NOT NULL
END

GO
/****** Object:  StoredProcedure [dbo].[spGetAttendanceRegisterForSupportingStaffMembers]    Script Date: 13/5/18 11:28:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetAttendanceRegisterForSupportingStaffMembers]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGetAttendanceRegisterForSupportingStaffMembers] AS' 
END
GO
/***
   Created Date      :     2015-08-06
   Created By        :     Rakesh Gandhi
   Purpose           :     This stored procedure prepares attendance register for all supporting staff members
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   2018-05-02         kanchan kumari       to get staff attendance based on staff access card
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   --- Test Case 1
         EXEC [dbo].[spGetAttendanceRegisterForSupportingStaffMembers]
            @FromDate = '2018-03-13'
           ,@EndDate = '2018-03-13'
           ,@ForEmployeeId = 1

   --- Test Case 2
         EXEC [dbo].[spGetAttendanceRegisterForSupportingStaffMembers]
            @FromDate = '2016-08-01'
           ,@EndDate = '2018-04-30'
           ,@ForEmployeeId = 0
***/
ALTER PROCEDURE [dbo].[spGetAttendanceRegisterForSupportingStaffMembers]
      @FromDate [date]
     ,@EndDate [date]
     ,@ForEmployeeId [int]
AS
BEGIN
	SET NOCOUNT ON;
	SET FMTONLY OFF;

	IF OBJECT_ID('tempdb..#UserDateMapping') IS NOT NULL
	DROP TABLE #UserDateMapping

	IF OBJECT_ID('tempdb..#FinalAttendanceData') IS NOT NULL
	DROP TABLE #FinalAttendanceData

   CREATE TABLE #UserDateMapping
   (
      [EmployeeName] [varchar](250) NOT NULL
     ,[DateId] [bigint] NOT NULL
     ,[Date] [date] NOT NULL
     ,[Day] [varchar](20) NOT NULL
	 ,[AccessCardNo] VARCHAR(15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
   )

   CREATE TABLE #FinalAttendanceData
   (
      [EmployeeName] [varchar](100) NOT NULL
     ,[DateId] [bigint] NOT NULL
     ,[Date] [date] NOT NULL
     ,[DisplayDate] [varchar](20) NOT NULL
     ,[InTime] [varchar](50) NULL
     ,[OutTime] [varchar](50) NULL
     ,[TotalTime] [varchar](50) NULL
   )

   INSERT INTO #UserDateMapping
   (
       [EmployeeName]
      ,[DateId]
      ,[Date]
      ,[Day]
	  ,[AccessCardNo]
   )
   SELECT
       E.[EmployeeName]
      ,D.[DateId]
      ,D.[Date]
      ,D.[Day]
	  ,AC.[AccessCardNo]
   FROM [dbo].[SupportingStaffMember] E WITH (NOLOCK)
   CROSS JOIN [dbo].[DateMaster] D WITH (NOLOCK)
   INNER JOIN UserAccessCard UA ON UA.StaffUserId=E.RecordId
   INNER JOIN AccessCard AC ON AC.AccessCardId=UA.AccessCardId 
   WHERE
       E.[RecordId] = CASE WHEN @ForEmployeeId=0 THEN E.[RecordId] ELSE @ForEmployeeId END
	  AND E.IsActive=1
      AND D.[Date] BETWEEN @FromDate AND @EndDate

   INSERT INTO #FinalAttendanceData
   (
      [EmployeeName]
     ,[DateId]
     ,[Date]
     ,[DisplayDate]
     ,[InTime]
     ,[OutTime]
     ,[TotalTime]
   )
   SELECT 
      M.[EmployeeName]
     ,M.[DateId]
     ,M.[Date]
     ,CONVERT ([varchar](20), M.[Date], 106) + ' (' + SUBSTRING(M.[Day], 1, 3) + ')'
     ,CASE 
         WHEN CONVERT([varchar](20), M.[Date], 106) = CONVERT([varchar](20), A.[InTime], 106) THEN CONVERT([varchar](20) ,CAST(A.[InTime] AS [time]), 100)
         ELSE CONVERT([varchar](20) ,CAST(A.[InTime] AS [time]), 100) + ' (' + CONVERT ([varchar](11), A.[InTime], 106) + ')'
      END
     ,CASE
         WHEN CONVERT([varchar](20), M.[Date], 106) = CONVERT([varchar](20), A.[OutTime], 106) THEN CONVERT([varchar](20) ,CAST(A.[OutTime] AS [time]), 100)
         ELSE CONVERT([varchar](20) ,CAST(A.[OutTime] AS [time]), 100) + ' (' + CONVERT ([varchar](20), A.[OutTime], 106) + ')'
      END
     ,CONVERT([varchar](10), A.[OutTime] - A.[InTime], 108)
   FROM [dbo].[CardPunchinData] A WITH (NOLOCK) 
   RIGHT JOIN #UserDateMapping M ON M.[DateId] = A.[DateId] AND M.[AccessCardNo] = A.[CardNo]

   UPDATE T
   SET
      T.[InTime] = 'Holiday'
     ,T.[OutTime] = 'Holiday'
     ,T.[TotalTime] = H.[Holiday]
   FROM #FinalAttendanceData T
   INNER JOIN [dbo].[ListofHoliday] H WITH (NOLOCK) ON H.[DateId] = T.[DateId]
   WHERE T.[InTime] IS NULL

   SELECT 
      F.[DisplayDate]          AS [Date]
     ,F.[EmployeeName]         AS [EmployeeName]
     ,F.[InTime]               AS [InTime]
     ,F.[OutTime]              AS [OutTime]
     ,F.[TotalTime]            AS [LoggedInHours]
   FROM #FinalAttendanceData F
   ORDER BY F.[Date], F.[InTime]
END
GO
/****** Object:  StoredProcedure [dbo].[spGetDatesToRequestCompOff]    Script Date: 13/5/18 11:28:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetDatesToRequestCompOff]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGetDatesToRequestCompOff] AS' 
END
GO
/***
   Created Date      :     2016-01-24
   Created By        :     Rakesh Gandhi
   Purpose           :     This stored procedure gets the dates available for comp offs
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   11/4/2016         Shubhra Upadhyay     Apply check so that no dates are returned for intern designation
   21/4/2017         Shubhra Upadhyay     Check quarter dates from 1 to 30/31
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   EXEC [dbo].[spGetDatesToRequestCompOff] @UserId = 2421
***/
ALTER PROCEDURE [dbo].[spGetDatesToRequestCompOff]
   @UserId [int]
AS
BEGIN
   SET NOCOUNT ON;
   SET FMTONLY OFF;

   DECLARE 
      @CurrentDate [date] = GETDATE()
     ,@CompOffStartDate [date] = DATEADD( d, -31, GETDATE())
     ,@IsIntern [bit]
	    
	IF OBJECT_ID('tempdb..#FinalValues') IS NOT NULL
	DROP TABLE #FinalValues

	CREATE TABLE #FinalValues
	(
		[DateId] [bigint]
		,[Date] [varchar] (10)
		,[Ocassion] [varchar](50)
	)

      INSERT INTO #FinalValues([DateId],[Date],[Ocassion])
      SELECT D.[DateId]
			 ,CONVERT([varchar](10), D.[Date], 101)
			 ,ISNULL (H.[Holiday], D.[Day])
      FROM [dbo].[DateMaster] D WITH (NOLOCK)
      LEFT JOIN [dbo].[ListofHoliday] H WITH (NOLOCK) ON H.[DateId] = D.[DateId]
      WHERE (D.[Day] = 'Saturday'OR D.[Day]='Sunday' OR H.[HolidayId] IS NOT NULL) 
			AND D.[Date] >= @CompOffStartDate
			AND D.[Date] < @CurrentDate
      UNION

      SELECT
          D.[DateId]
         ,CONVERT([varchar](10), D.[Date], 101)
         ,ISNULL (H.[Holiday], D.[Day])
      FROM [dbo].[DateMaster] D WITH (NOLOCK)
      LEFT JOIN [dbo].[ListofHoliday] H WITH (NOLOCK) ON H.[DateId] = D.[DateId]
      WHERE (D.[Day] = 'Saturday' OR D.[Day]='Sunday' OR H.[HolidayId] IS NOT NULL) 
			AND D.[Date] >= @CompOffStartDate
			AND D.[Date] <= @CurrentDate 

      DELETE T
      FROM #FinalValues T
      WHERE T.[Date] > @CurrentDate
               
      DELETE T
      FROM #FinalValues T
      INNER JOIN [dbo].[RequestCompOff] M WITH (NOLOCK) ON M.[DateId] = T.[DateId] AND M.[CreatedBy] = @UserId AND M.[StatusId] > -1
  
	SELECT [DateId],[Date],[Ocassion]
	FROM #FinalValues       
END
GO
/****** Object:  StoredProcedure [dbo].[spGetUserAppliedCompOff]    Script Date: 13/5/18 11:28:30 PM ******/
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
   EXEC [dbo].[spGetUserAppliedCompOff] @UserId = 1108,@Year=2018
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
         WHEN COUNT(RD.[RequestId]) = 0 AND COUNT(LD.[RequestId]) = 0 THEN 1 --available
		 ELSE 2 --availed
   --      WHEN C.[NoOfDays] = COUNT(RD.[RequestId]) THEN 2 --availed
   --      WHEN C.[NoOfDays] > COUNT(RD.[RequestId]) THEN 3 --partially availed
       END   AS [AvailabilityStatus]
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
		 ----------for legitimate--------
		  LEFT JOIN
         (
            SELECT
               LD.[RequestId]
            FROM
               [dbo].[RequestCompOffDetail] LD WITH (NOLOCK)
               INNER JOIN
                  [dbo].[LegitimateLeaveRequest] LL WITH (NOLOCK)
                  ON LD.[LegitimateLeaveRequestId] = LL.[LegitimateLeaveRequestId]
                     AND LL.[StatusId] <6
         ) LD
         ON C.[RequestId] = LD.[RequestId]      
		 ---------------------------------
	  LEFT JOIN ( 
				 SELECT H.[RequestId] AS [RequestId], MAX(H.[CreatedDate]) AS [LatestModifiedOn]
				 FROM [dbo].[RequestCompOffHistory] H WITH (NOLOCK)
				 GROUP BY H.[RequestId]
        ) RH ON C.[RequestId] = RH.[RequestId]

	  LEFT JOIN [dbo].[RequestCompOffHistory] H WITH (NOLOCK) ON H.[RequestId] = RH.[RequestId] AND H.[CreatedDate] = RH.[LatestModifiedOn]
	  LEFT JOIN [dbo].[UserDetail] CAP WITH (NOLOCK) ON H.[ApproverId] = CAP.[UserId]
   WHERE 
      U.[UserId] = @UserId 
      AND US.[IsActive] = 1   AND D.[Date] BETWEEN @StartDate AND @EndDate    
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
   
   ORDER BY C.LapseDate DESC, C.[CreatedDate] DESC  
END
GO
/****** Object:  StoredProcedure [dbo].[spImportUserShiftMapping]    Script Date: 13/5/18 11:28:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spImportUserShiftMapping]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spImportUserShiftMapping] AS' 
END
GO
/***
   Created Date      :     2016-01-24
   Created By        :     Rakesh Gandhi
   Purpose           :     This stored procedure imports attendance for a date from excel
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   27-Nov-2017		Sudhanshu Shekhar	 Replaced name and added userId in xml
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   --- Test Case 1
         EXEC [dbo].[spImportUserShiftMapping]
            @FromDate = '2016-01-25'
           ,@ToDate = '2016-01-31'
           ,@Data = '<ShiftMapping>
                        <ShiftRecord>
                         <UserId>1108</UserId>
                         <Shift>A</Shift>
                       </ShiftRecord>
                       <ShiftRecord>
                         <UserId>84</UserId>
                         <Shift>A</Shift>
                       </ShiftRecord>
                       <ShiftRecord>
                         <UserId>1109</UserId>
                         <Shift>A</Shift>
                       </ShiftRecord>
                       <ShiftRecord>
                         <UserId>22</UserId>
                         <Shift>A</Shift>
                       </ShiftRecord>
                     </ShiftMapping>'
***/
ALTER PROCEDURE [dbo].[spImportUserShiftMapping]
   @FromDate [date]
  ,@ToDate [date]
  ,@Data [xml]
  ,@LoginUserId [int] = 0
AS
BEGIN
   SET NOCOUNT ON;
   IF (@LoginUserId = 0)
    SET @LoginUserId = 58 --Neeraj Yadav for e-Inv

   --supplying a data contract
   IF 1 = 2 
   BEGIN
      SELECT
         CAST(NULL AS [date]) 			AS [Date]
        ,CAST(NULL AS [varchar](152))   AS [Name]
        ,CAST(NULL AS [varchar](50))    AS [Shift]
        ,CAST(NULL AS [varchar](500))   AS [Remarks]
      WHERE 1 = 2
   END

   CREATE TABLE #Data
   (
      [UserId] [int] NULL
     ,[DateId] [bigint] NULL
     ,[ShiftId] [int] NULL
     ,[Shift] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL
     ,[Remarks] [varchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL 
   )
   
   WHILE @FromDate <= @ToDate
      BEGIN
         -- parse XML
         INSERT INTO #Data
         (
             [UserId]
            ,[Shift] 
            ,[DateId]
         )   
         SELECT  Mapping.value('(UserId)[1]', '[INT]') AS 'UserId'
				,Mapping.value('(Shift)[1]', '[varchar] (50)') AS 'Shift'
				,D.[DateId]
         FROM @Data.nodes('/ShiftMapping/ShiftRecord') AS Attend(Mapping) 
         INNER JOIN [dbo].[DateMaster] D WITH (NOLOCK) ON D.[Date] = @FromDate

   --      -- update user ids
   --      UPDATE T
   --      SET T.[UserId] = M.[UserId]
   --      FROM #Data T
		 --INNER JOIN [dbo].[UserDetail] M WITH (NOLOCK) ON LTRIM(RTRIM(T.[Name])) = LTRIM(RTRIM(M.[FirstName])) + ' ' + LTRIM(RTRIM(M.[LastName]))
   --                  --AND ISNULL(M.[TerminateDate], '2999-12-31') >= @FromDate

         UPDATE T
         SET T.[ShiftId] = M.[ShiftId]
         FROM #Data T 
         INNER JOIN [dbo].[ShiftMaster] M WITH (NOLOCK) ON LTRIM(RTRIM(M.[ShiftName])) = LTRIM(RTRIM(T.[Shift])) AND M.[IsActive] = 1 AND M.[IsDeleted] = 0

         -- update remarks
         UPDATE T
         SET T.[Remarks] = 'Unable to find employee and shift in database'
         FROM #Data T
         WHERE T.[UserId] IS NULL AND T.[ShiftId] IS NULL

         UPDATE T
         SET T.[Remarks] = 'Unable to find employee in database'
         FROM #Data T
         WHERE T.[UserId] IS NULL AND T.[Remarks] IS NULL

         UPDATE T 
         SET T.[Remarks] = 'Unable to find shift in database'
         FROM #Data T
         WHERE T.[ShiftId] IS NULL AND T.[Remarks] IS NULL

         SET @FromDate = DATEADD(dd, 1, @FromDate)
  END
      
      -- check for invalid records
      IF EXISTS (SELECT 1 FROM #Data WHERE [Remarks] IS NOT NULL) -- some invalid records are available
      BEGIN
         SELECT
            D.[Date] AS [Date]
           ,T.[UserId] AS [UserId]
           ,T.[Shift] AS [Shift]
           ,T.[Remarks] AS [Remarks]
         FROM #Data T
         INNER JOIN [dbo].[DateMaster] D WITH (NOLOCK) ON T.[DateId] = D.[DateId]
         WHERE T.[Remarks] IS NOT NULL
      END
      ELSE
      BEGIN
         BEGIN TRY
            BEGIN TRANSACTION
               UPDATE M
               SET
                  M.[IsActive] = 0
                 ,M.[IsDeleted] = 1
                 ,M.[LastModifiedDate] = GETDATE()
                 ,M.[LastModifiedBy] = @LoginUserId
               FROM [dbo].[UserShiftMapping] M
               INNER JOIN #Data T 
				ON M.[DateId] = T.[DateId]
				AND M.[UserId] = T.[UserId]
				AND M.[ShiftId] != T.[ShiftId]

               INSERT INTO [dbo].[UserShiftMapping]([DateId],[UserId],[ShiftId],[CreatedBy])
               SELECT T.[DateId],T.[UserId],T.[ShiftId],@LoginUserId
               FROM #Data T
               LEFT JOIN [dbo].[UserShiftMapping] M 
					ON T.[DateId] = M.[DateId]
					AND T.[UserId] = M.[UserId]
					AND M.[IsActive] = 1
					AND M.[IsDeleted] = 0
               WHERE
                  M.[MappingId] IS NULL
            
            COMMIT TRANSACTION
            
            SELECT D.[Date] AS [Date],T.[Shift] AS [Shift], T.[Remarks] AS [Remarks]
            FROM #Data T
            INNER JOIN [dbo].[DateMaster] D WITH (NOLOCK) ON T.[DateId] = D.[DateId]
            WHERE T.[Remarks] IS NOT NULL
         END TRY
         BEGIN CATCH
            ROLLBACK TRANSACTION
            
            DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))

      EXEC [spInsertErrorLog]
	      @ModuleName = 'eInvoice'
         ,@Source = 'spImportUserShiftMapping'
         ,@ErrorMessage = @ErrorMessage
         ,@ErrorType = 'SP'
         ,@ReportedByUserId = @LoginUserId
         END CATCH
      END
END
GO
/****** Object:  StoredProcedure [dbo].[spPrepareAttendance]    Script Date: 13/5/18 11:28:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spPrepareAttendance]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spPrepareAttendance] AS' 
END
GO
/***
   Created Date      :     2017-11-25
   Created By        :     Shubhra Upadhyay
   Purpose           :     This stored procedure prepares attendance in save in MIS table
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   8 jan 2018		Sudhanshu Shekhar	  Corrected attendance and temp card logs, added asquare and ground floor gates entry
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   --- Test Case 1 EXEC [dbo].[spPrepareAttendance] @FromDate = '2018-01-26'
***/
ALTER  PROCEDURE [dbo].[spPrepareAttendance] 
(
   @FromDate [datetime] = NULL
  ,@UserId [int] = 1
)
AS
BEGIN
   SET NOCOUNT ON;

   IF OBJECT_ID('tempdb..#acc_reader') IS NOT NULL
   DROP TABLE #acc_reader

   IF OBJECT_ID('tempdb..#TempAttendanceLog') IS NOT NULL
   DROP TABLE #TempAttendanceLog

   IF OBJECT_ID('tempdb..#Attendance') IS NOT NULL
   DROP TABLE #Attendance

   IF OBJECT_ID('tempdb..#ExitOnNextDays') IS NOT NULL
   DROP TABLE #ExitOnNextDays

   IF OBJECT_ID('tempdb..#CardPunchinData') IS NOT NULL
   DROP TABLE #CardPunchinData

   IF OBJECT_ID('tempdb..#DateWiseAttendance') IS NOT NULL
   DROP TABLE #DateWiseAttendance

	IF (@FromDate IS NULL)
	SET @FromDate = '2016-04-30' --CAST(GETDATE() AS [Date])

   BEGIN TRY
	CREATE TABLE #acc_reader
	(
		[door_id] [int] NULL,
		[reader_name] [nvarchar](30) NULL,
		[reader_state] [smallint] NULL,
	)

	INSERT INTO #acc_reader
	SELECT [door_id], [reader_name], [reader_state] 
	FROM [AccessController].[dbo].[acc_reader] WITH (NOLOCK)

	CREATE TABLE #TempAttendanceLog
	(
		 [Date] [date] NOT NULL
        ,[Pin] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
		,[MinIN] [datetime] NULL --Updatable
		,[MaxIN] [datetime] NULL --Updatable
		,[MinOUT] [datetime] NULL --Updatable
		,[MaxOUT] [datetime] NULL --Updatable
		,[MinTime] [datetime] NULL
		,[MaxTime] [datetime] NULL
	)
	
	--Insert Min and Max time of the day
	INSERT INTO #TempAttendanceLog([Date],[Pin], [MinTime],[MaxTime])
	SELECT 
	 CAST(L.[time] AS [date]) AS [Date]
	,L.[pin]
	,MIN(L.[time]) AS [MinTime]
	,MAX(L.[time]) AS [MaxTime]
	FROM [dbo].[acc_monitor_log] L WITH (NOLOCK)
	INNER JOIN #acc_reader R WITH (NOLOCK) ON L.[state]=R.[reader_state] AND L.[event_point_id]=R.[door_id]
	WHERE 
	R.[reader_name] IN ('Main Entrance I In', 'Main Entrance I Out', 'Main Entrance II In', 'Main Entrance II Out', 'Emergency Exit In', 'Emergency Exit Out',
					'ASQ-Gate1-IN', 'ASQ-Gate1-OUT', 'ASQ-Gate2-IN', 'ASQ-Gate2-OUT', 'GS-G-Main-1 In', 'GS-G-Main-1 Out', 'GND-Main_Door In','GND-Main_Door Out')
	AND CAST(L.[time] AS [date]) > '2016-04-30'
	GROUP BY CAST(L.[time] AS [date]), L.[pin]

	--UPDATE Min/Max of IN
	UPDATE T
	SET 
	 T.[MinIN] = L.[MinIN]
	,T.[MaxIN] = L.[MaxIN]
	FROM #TempAttendanceLog T
	JOIN (SELECT
	 CAST(L.[time] AS [date]) AS [Date]
	,MIN(L.[time]) AS [MinIN]
	,MAX(L.[time]) AS [MaxIN]
	,L.[pin]
	FROM [dbo].[acc_monitor_log] L WITH (NOLOCK)
	INNER JOIN #acc_reader R WITH (NOLOCK) ON L.[state]=R.[reader_state] AND L.[event_point_id]=R.[door_id]
	WHERE 
	R.[reader_name] IN ('Main Entrance I In', 'Main Entrance II In', 'Emergency Exit In', 'ASQ-Gate1-IN', 'ASQ-Gate2-IN', 'GS-G-Main-1 In', 'GND-Main_Door In')
	AND CAST(L.[time] AS [date]) > '2016-04-30'
	GROUP BY CAST(L.[time] AS [date]), L.[pin]) L
	ON REPLACE(LTRIM(REPLACE(T.[pin],'0',' ')),' ','0') = REPLACE(LTRIM(REPLACE(L.[pin],'0',' ')),' ','0') AND T.[Date] = L.[Date]
	 
	--UPDATE Min/Max of OUT
	UPDATE T
	SET 
	 T.[MinOUT] = L.[MinOUT]
	,T.[MaxOUT] = L.[MaxOUT]
	FROM #TempAttendanceLog T
	JOIN (SELECT
	 CAST(L.[time] AS [date]) AS [Date]
	,MIN(L.[time]) AS [MinOUT]
	,MAX(L.[time]) AS [MaxOUT]
	,L.[pin]
	FROM [dbo].[acc_monitor_log] L WITH (NOLOCK)
	INNER JOIN #acc_reader R WITH (NOLOCK) ON L.[state]=R.[reader_state] AND L.[event_point_id]=R.[door_id]
	WHERE 
	R.[reader_name] IN ('Main Entrance I Out', 'Main Entrance II Out', 'Emergency Exit Out', 'ASQ-Gate1-OUT', 'ASQ-Gate2-OUT', 'GS-G-Main-1 Out','GND-Main_Door Out')
	AND CAST(L.[time] AS [date]) > '2016-04-30'
	GROUP BY CAST(L.[time] AS [date]), L.[pin]) L
	ON REPLACE(LTRIM(REPLACE(T.[pin],'0',' ')),' ','0') = REPLACE(LTRIM(REPLACE(L.[pin],'0',' ')),' ','0') AND T.[Date] = L.[Date]

	CREATE TABLE #Attendance
	(
		 [Date] [date] NOT NULL
        ,[Pin] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
		,[InTime] [datetime] NOT NULL
		,[OutTime] [datetime] NULL
		,[Duration] AS [OutTime] - [InTime]
	)

	CREATE TABLE #ExitOnNextDays
	(
		 [Date] [date] NOT NULL
		,[Pin] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
		,[Time] [datetime] NOT NULL
		,[IsOut] [bit] NOT NULL
		,[ReaderName] [varchar] (60) NOT NULL
	)

   INSERT INTO #ExitOnNextDays
   (
      [Date]
	 ,[Pin]
     ,[Time]
     ,[IsOut]
     ,[ReaderName]
   )
   SELECT
      CAST(L.[time] AS [Date]) AS [Date]
	 ,L.[pin]
     ,L.[time]
     ,CASE
         WHEN R.[reader_name] = 'Main Entrance I Out' THEN 1
         WHEN R.[reader_name] = 'Main Entrance II Out' THEN 1
         WHEN R.[reader_name] = 'Emergency Exit Out' THEN 1
		 WHEN R.[reader_name] = 'ASQ-Gate1-OUT' THEN 1  -- don't remove --temp
         WHEN R.[reader_name] = 'ASQ-Gate2-OUT' THEN 1  -- don't remove --temp
         WHEN R.[reader_name] = 'GS-G-Main-1 Out' THEN 1  -- don't remove --temp
         WHEN R.[reader_name] = 'GND-Main_Door Out' THEN 1 
         ELSE 0 
      END AS [IsOut]
     ,R.[reader_name]
   FROM
      [dbo].[acc_monitor_log] L WITH (NOLOCK)
         INNER JOIN #TempAttendanceLog IT
   ON REPLACE(LTRIM(REPLACE(IT.[pin],'0',' ')),' ','0') = REPLACE(LTRIM(REPLACE(L.[pin],'0',' ')),' ','0') AND IT.[MinTime] = L.[time]
   INNER JOIN #acc_reader R WITH (NOLOCK) ON L.[state]=R.[reader_state] AND L.[event_point_id]=R.[door_id]
   WHERE CAST(L.[time] AS [date]) > '2016-04-30'

   DELETE FROM #ExitOnNextDays WHERE [IsOut] = 0

   -- Calculate and get in/out time 
	INSERT INTO #Attendance([Date],[Pin],[InTime],[OutTime])
	SELECT T.[Date], T.[Pin], T.[MinTime] AS [InTime], 
	CASE WHEN T.[Date] = CAST(GETDATE() AS DATE) THEN T.[MaxOUT]
		ELSE T.[MaxTime] END AS [OutTime]
	--COALESCE(T.[MinIN],T.[MinTime]) AS [InTime],
	--COALESCE(T.[MaxOUT],T.[MaxTime]) AS [OutTime]
	--	COALESCE(T.[MinIN],T.[MinTime]) AS [InTime],
	--COALESCE(
	--		CASE WHEN T.[MinIN] IS NULL THEN T.[MinTime] ELSE NULL END,
	--		CASE WHEN T.[MinIN] > T.[MinTime] THEN T.[MinTime] ELSE NULL END,
	--		T.[MaxTime]) AS [OutTime]
	FROM #TempAttendanceLog T

   -- update data for out on next days
	UPDATE A
	SET
		A.[OutTime] = E.[Time]
	FROM #Attendance A
	INNER JOIN #ExitOnNextDays E ON E.[Date] = DATEADD(DD, 1, A.[Date])
	AND REPLACE(LTRIM(REPLACE(E.[pin],'0',' ')),' ','0') = REPLACE(LTRIM(REPLACE(A.[pin],'0',' ')),' ','0') --E.[CardNo] = A.[CardNo] 
	WHERE A.[OutTime] IS NULL

   BEGIN TRANSACTION
  --Insert into temp card punchin data
	SELECT A.[Pin],'' AS [Name],D.[DateId],A.[Date],A.[InTime],A.[OutTime]
	INTO #CardPunchinData
	FROM #Attendance A         
	INNER JOIN [dbo].[DateMaster] D WITH (NOLOCK) ON A.[Date] = D.[Date]
	GROUP BY A.[Pin],D.[DateId],A.[Date],A.[InTime],A.[OutTime]
	ORDER BY A.[InTime] DESC

  --Insert into temp, date wise attendance
	SELECT D.[DateId],UD.[UserId],A.[InTime],A.[OutTime],1 [IsActive],GETDATE() [CreatedDate],1 [CreatedBy]
	INTO #DateWiseAttendance
	FROM #Attendance A         
	INNER JOIN [dbo].[AccessCard] AC WITH (NOLOCK) ON REPLACE(LTRIM(REPLACE(A.[Pin],'0',' ')),' ','0') = REPLACE(LTRIM(REPLACE(AC.[AccessCardNo],'0',' ')),' ','0')
	INNER JOIN [dbo].[UserAccessCard] UAC WITH (NOLOCK) ON AC.[AccessCardId] = UAC.[AccessCardId]
			AND A.[Date] BETWEEN UAC.[AssignedFromDate] AND ISNULL(UAC.[AssignedTillDate], GETDATE())
	INNER JOIN [dbo].[DateMaster] D WITH (NOLOCK) ON A.[Date] = D.[Date]
	LEFT JOIN [dbo].[UserDetail] UD WITH (NOLOCK) ON UD.[UserId] = UAC.[UserId]
	WHERE 
		UD.[UserId] IS NOT NULL
		AND UAC.[IsFinalised] = 1
	GROUP BY D.[DateId],UD.[UserId],A.[InTime],A.[OutTime]
	ORDER BY A.[InTime] DESC

	--Insert Temporary card log into temp date wise attendance
	INSERT INTO #DateWiseAttendance
	SELECT C.[DateId],T.[EmployeeId],C.[InTime], --C.[OutTime],
	CASE WHEN T.ReturnDate IS NULL THEN (C.[OutTime])
		 WHEN CONVERT([varchar](8), T.ReturnDate, 112)=CONVERT([varchar](8), C.[InTime], 112) THEN T.ReturnDate
		 ELSE C.[OutTime] 
	END AS [OutTime],
	1,GETDATE(),1
	FROM #CardPunchinData C WITH (NOLOCK)
	INNER JOIN [dbo].[AccessCard] A WITH (NOLOCK) ON REPLACE(LTRIM(REPLACE(C.[Pin],'0',' ')),' ','0') = REPLACE(LTRIM(REPLACE(A.[AccessCardNo],'0',' ')),' ','0')
	INNER JOIN [dbo].[TempCardIssueDetail] T WITH (NOLOCK) ON A.[AccessCardId] = T.[AccessCardId]
	INNER JOIN [dbo].[UserDetail] MU WITH (NOLOCK) ON T.[EmployeeId] = MU.[UserId]
	WHERE
		CONVERT([varchar](8), T.[IssueDate], 112) = CONVERT([varchar](8), C.[InTime], 112)
		AND CAST(C.[Date] AS [Date]) BETWEEN @FromDate AND CAST(GETDATE() AS [Date])
	ORDER BY C.[Date]

	EXEC [Proc_Truncate] 'DateWiseAttendance', 1 --by Admin
	EXEC [Proc_Truncate] 'CardPunchinData', 1 --by Admin
	
	INSERT INTO [dbo].[CardPunchinData]([CardNo],[Name],[DateId],[Date],[InTime],[OutTime])
	SELECT [Pin], [Name], [DateId], [Date], [InTime],[OutTime]
	FROM #CardPunchinData

	INSERT INTO [dbo].[DateWiseAttendance]([DateId],[UserId],[SystemGeneratedInTime],[SystemGeneratedOutTime],[SystemGeneratedStatusId],[CreatedDate],[CreatedBy])
	SELECT [DateId],[UserId],[InTime],[OutTime],[IsActive],[CreatedDate],[CreatedBy]
    FROM #DateWiseAttendance

   COMMIT TRANSACTION;
   SELECT 1 AS [Result]
   END TRY
	BEGIN CATCH
	IF @@TRANCOUNT > 0
	BEGIN
		ROLLBACK TRANSACTION;
		DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
		--Log Error
		EXEC [spInsertErrorLog]
			 @ModuleName = 'AccessController'
			,@Source = 'spPrepareAttendance'
			,@ErrorMessage = @ErrorMessage
			,@ErrorType = 'SP'
			,@ReportedByUserId = @UserId

	SELECT 2 AS [Result]
	END
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[spTakeActionOnAppliedLeave]    Script Date: 13/5/18 11:28:30 PM ******/
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
         @LeaveRequestApplicationId = 1
        ,@Status = 'CA'
        ,@Remarks = 'Canceled by User'
        ,@UserId = 4
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
         @LeaveRequestApplicationId = 8757
        ,@Status = 'RJ' -- pending for verification
        ,@Remarks = 'Rejected by Aprajita'
        ,@UserId = 62
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
   
   BEGIN TRY
      DECLARE @Date [date] = GETDATE()

      IF EXISTS (SELECT 1 FROM [dbo].[LeaveRequestApplication] WITH (NOLOCK) WHERE [LeaveRequestApplicationId] = @LeaveRequestApplicationId AND [LastModifiedBy] = @UserId)
      BEGIN
         SELECT 'DUPLICATE' AS [Result]
         RETURN
      END
      ELSE IF EXISTS (SELECT 1 FROM [dbo].[LeaveRequestApplication] L WITH (NOLOCK) INNER JOIN [dbo].[DateMaster] D WITH (NOLOCK) ON L.[FromDateId] = D.[DateId] 
					  WHERE L.[LeaveRequestApplicationId] = @LeaveRequestApplicationId AND L.[UserId] = @UserId AND D.[Date] <= @Date AND L.[StatusId] = 0)--@Status = 'CA')
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
	 PRINT @LeaveRequestApplicationId;
	    UPDATE RequestCompOffDetail SET IsActive=0, ModifiedDate=GETDATE(), ModifiedById=@UserId 
		            WHERE LeaveRequestApplicationId=@LeaveRequestApplicationId

  --------------update RequestCompOffDetail table ends-------------------------------------------
	   
  ----------------update RequestCompOff table starts----------------------------------------------
       DECLARE @RequestId INT
	   SET @RequestId=(SELECT RequestId FROM RequestCompOffDetail WHERE LeaveRequestApplicationId=@LeaveRequestApplicationId)
	   PRINT @RequestId;
	    UPDATE RequestCompOff SET IsAvailed=0 WHERE RequestId=@RequestId

  --------------update RequestCompOff table ends---------------------------------------------------
	  UPDATE B
      SET B.[Count] = CASE
                        WHEN M.[ShortName] = 'LWP' THEN B.[Count] - D.[Count]
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

--Created Date      : 2018-03-21
--Created By        : Kanchan Kumari
--Purpose           : This stored procedure is used to view outing request status
--Usage				: EXEC [Proc_GetOutingRequestByUserId] 1108,2018
----------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[Proc_GetOutingRequestByUserId] 
   @EmployeeId [int],
   @Year [int]=NULL
AS
BEGIN
	SET NOCOUNT ON;
	SET FMTONLY OFF;
	IF OBJECT_ID('tempdb..#OutingTable') IS NOT NULL
	DROP TABLE #OutingTable
	
	DECLARE @StartDate [date], @EndDate [date],@JoiningDate [date]
	 
	IF (@Year IS NULL OR @Year =0)
	SET @Year = DATEPART(YYYY, GETDATE())

	SELECT @StartDate=dateadd(Month,0,cast(concat(@Year,'-04-01') as date))  ,
		  @EndDate = dateadd(Year,1,cast(concat(@Year,'-03-31') as date)) ,
		  @JoiningDate= JoiningDate FROM UserDetail WHERE UserId=@EmployeeId
		 IF(DATEPART(YYYY,@JoiningDate)=DATEPART(YYYY, @StartDate) AND DATEPART(mm,@JoiningDate)<DATEPART(mm,@StartDate))
		  SELECT @StartDate=@JoiningDate

CREATE TABLE #OutingTable
(
[OutingRequestId] BIGINT NOT NULL,
[Period] VARCHAR(50),
[FromDate] DATE,
[TillDate] DATE,
[OutingType] VARCHAR(10),
[Reason] VARCHAR(500),
[StatusCode] VARCHAR(10),
[Status] VARCHAR(100),
[Remarks] VARCHAR(200),
[ApplyDate] VARCHAR(25)
)
  INSERT INTO #OutingTable ([OutingRequestId],[Period],[FromDate],[TillDate],[OutingType],[Reason],[StatusCode],[Status],[Remarks],[ApplyDate])
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
	WHERE R.[UserId] = @EmployeeId AND DM1.[Date] BETWEEN @StartDate AND @EndDate

	INSERT INTO #OutingTable ([OutingRequestId],[Period],[FromDate],[TillDate],[OutingType],[Reason],[StatusCode],[Status],[Remarks],[ApplyDate])
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
	WHERE R.[UserId] = @EmployeeId  AND R.StatusId>=5 AND DM1.[Date] BETWEEN @StartDate AND @EndDate

	SELECT [OutingRequestId],[Period],[FromDate],[TillDate],[OutingType],[Reason],[StatusCode],[Status],[Remarks],[ApplyDate] 
	FROM #OutingTable ORDER BY [ApplyDate] DESC
END
GO
----------------------------------------------------------------------------
--Created Date      : 2018-03-21
--Created By        : Kanchan Kumari
--Purpose           : This stored procedure is used to apply outing request
--Usage				: EXEC [Proc_GetOutingReviewRequest] 1108
----------------------------------------------------------------------------
CREATE PROC [dbo].[Proc_GetOutingReviewRequest]
@LoginUserId [INT]
AS
BEGIN
	SET NOCOUNT ON;
	SET FMTONLY OFF;
	
	IF OBJECT_ID('tempdb..#TempDataNew') IS NOT NULL
	DROP TABLE #TempDataNew

	CREATE TABLE #TempDataNew
	(
		[OutingRequestId] INT NOT NULL,
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

			INSERT INTO #TempDataNew([OutingRequestId], [EmployeeName], [Period], [Reason], [ApplyDate], [Status],[DutyType],[Remarks],[StatusCode])
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
			WHERE (ACT.StatusId<>1) AND R.StatusId<=3 AND R.UserId!=@LoginUserId

			INSERT INTO #TempDataNew([OutingRequestId], [EmployeeName], [Period], [Reason], [ApplyDate], [Status],[DutyType],[Remarks],[StatusCode])
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
			WHERE (ACT.StatusId<>1)	AND R.StatusId>=5 AND R.UserId!=@LoginUserId
		
	SELECT [OutingRequestId], [EmployeeName], [Period], [Reason], [ApplyDate], [Status],[DutyType],[Remarks], [StatusCode]
	FROM #TempDataNew ORDER BY [ApplyDate] DESC
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
	EXEC [dbo].[Proc_GetLegitimateLeave] @UserId = 1108
***/
CREATE PROCEDURE [dbo].[Proc_GetLegitimateLeave] 
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
		[RequestId] INT NOT NULL,
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
		
		INSERT INTO #TempDataNew([RequestId], [EmployeeName], [Date], [Reason], [ApplyDate], [Status],[LeaveInfo],[Remarks],[StatusCode])
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
		WHERE (ACT.StatusId<>1) AND LR.StatusId<=3 	AND LR.UserId!=@UserId
    
		INSERT INTO #TempDataNew([RequestId], [EmployeeName], [Date], [Reason], [ApplyDate], [Status],[LeaveInfo],[Remarks],[StatusCode])
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
		WHERE (ACT.StatusId<>1)	AND LR.StatusId>=5 AND LR.UserId!=@UserId
		
SELECT [RequestId], [EmployeeName], [Date], [Reason], [ApplyDate], [Status],[LeaveInfo],[Remarks], [StatusCode]
FROM #TempDataNew ORDER BY [ApplyDate] DESC
END
GO

/****** Object:  StoredProcedure [dbo].[spGetUserAppliedLeave]    Script Date: 13/5/18 11:28:30 PM ******/
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
		@UserId = 2436
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
		,CAST(LR.[NoOfWorkingDays] AS [varchar](3)) + ' (' + LR.[LeaveCombination] + ')'									AS [LeaveInfo]
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spUpdateUserAccessCardMapping]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spUpdateUserAccessCardMapping] AS' 
END
GO
   /***
   Created Date      :     2016-09-27
   Created By        :     Shubhra Upadhyay
   Purpose           :     This stored proc is used to add new access cardtus
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   --- Test Case 1
         EXEC [dbo].[spUpdateUserAccessCardMapping]
         @userCardMappingId = 1
         ,@accessCardId = 5
         --,@userId = 47
         ,@isPimcoUserCardMapping = 1
         ,@createdBy = 1

   --- Test Case 2
         EXEC [dbo].[spUpdateUserAccessCardMapping]
			,@UserCardMappingId = 2
         ,@accessCardId = 9
         --,@userId = 45
         ,@isPimcoUserCardMapping = 0
         ,@createdBy = 1
		 ,@assignedFrom='2018-09-06'
***/
ALTER PROCEDURE [dbo].[spUpdateUserAccessCardMapping] 
(
      @UserCardMappingId [int]
     ,@AccessCardId [int]
     --,@UserId [int]
     ,@IsPimcoUserCardMapping [bit]
     ,@ModifiedBy [int]
	 ,@assignedFrom [Date]
)
AS
BEGIN
	SET NOCOUNT ON;
   BEGIN TRY
      BEGIN TRANSACTION
         UPDATE [dbo].[UserAccessCard]
         SET
             [AccessCardId] = @AccessCardId
            --,[UserId] = @UserId
            ,[IsPimco] = @IsPimcoUserCardMapping
            ,[LastModifiedBy] = @ModifiedBy
            ,[LastModifiedDate] = GETDATE()
			,[AssignedFromDate]=@assignedFrom
         WHERE
            [UserAccessCardId] = @UserCardMappingId
         SELECT CAST( 1 AS [bit])         AS [Result]
      COMMIT TRANSACTION
   END TRY

   BEGIN CATCH
      ROLLBACK TRANSACTION

      DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))

      EXEC [spInsertErrorLog]
	         @ModuleName = 'AccessCard'
         ,@Source = 'spUpdateUserAccessCardMapping'
         ,@ErrorMessage = @ErrorMessage
         ,@ErrorType = 'SP'
         ,@ReportedByUserId = @ModifiedBy

           SELECT CAST( 0 AS [bit])     AS [Result]
   END CATCH
END
GO
