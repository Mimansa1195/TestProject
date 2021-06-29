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
CREATE PROCEDURE [dbo].[Proc_ApplyLegitimateLeave]
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