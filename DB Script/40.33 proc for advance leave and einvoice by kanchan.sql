/****** Object:  StoredProcedure [dbo].[spTakeActionOnAppliedLeave]    Script Date: 05-03-2019 16:12:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spTakeActionOnAppliedLeave]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spTakeActionOnAppliedLeave]
GO
/****** Object:  StoredProcedure [dbo].[spManageEmployeeClientSideProjectAndManagerMapping]    Script Date: 05-03-2019 16:12:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spManageEmployeeClientSideProjectAndManagerMapping]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spManageEmployeeClientSideProjectAndManagerMapping]
GO
/****** Object:  StoredProcedure [dbo].[spGetUserAppliedLeave]    Script Date: 05-03-2019 16:12:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetUserAppliedLeave]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetUserAppliedLeave]
GO
/****** Object:  StoredProcedure [dbo].[Proc_SubmitAdvanceLeave]    Script Date: 05-03-2019 16:12:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SubmitAdvanceLeave]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SubmitAdvanceLeave]
GO
/****** Object:  StoredProcedure [dbo].[Proc_AdjustAdvanceLeaveByScheduler]    Script Date: 05-03-2019 16:12:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AdjustAdvanceLeaveByScheduler]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AdjustAdvanceLeaveByScheduler]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_CheckIfLeaveAlreadyExists]    Script Date: 05-03-2019 16:12:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_CheckIfLeaveAlreadyExists]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_CheckIfLeaveAlreadyExists]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_CheckIfLeaveAlreadyExists]    Script Date: 05-03-2019 16:12:14 ******/
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
	    ELSE IF EXISTS(SELECT 1 FROM [dbo].[AdvanceLeaveDetail] LG 
		                        JOIN [dbo].[AdvanceLeave] AD ON LG.AdvanceLeaveId = AD.AdvanceLeaveId  
							    WHERE AD.UserId = @EmployeeId
								AND LG.[IsActive] = 1
								AND (LG.DateId IN (SELECT TempDateId FROM @TempTableDateId))
								AND AD.IsActive = 1
			          )	  
       BEGIN
	       SET @Success = 1 --Already exists
	   END

	RETURN @Success 
END' 
END

GO
/****** Object:  StoredProcedure [dbo].[Proc_AdjustAdvanceLeaveByScheduler]    Script Date: 05-03-2019 16:12:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AdjustAdvanceLeaveByScheduler]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_AdjustAdvanceLeaveByScheduler] AS' 
END
GO
/***
   Created Date      : 1-Mar-2019
   Created By        : Kanchan Kumari
   Purpose           : To adjust advance leave
   Usage             : EXEC Proc_AdjustAdvanceLeaveByScheduler @AdjustForUserId = 1108

   select * from errorlog order by 1 desc
***/
ALTER PROC [dbo].[Proc_AdjustAdvanceLeaveByScheduler]
(
  @AdjustForUserId INT = NULL
)
AS
 BEGIN TRY
	 IF OBJECT_ID('tempdb..#tempAdvanceUserData') IS NOT NULL
     DROP TABLE #tempAdvanceUserData

	 IF OBJECT_ID('tempdb..#TempAdjustmentTransactionHistoryLog') IS NOT NULL
     DROP TABLE #TempAdjustmentTransactionHistoryLog

	 CREATE TABLE #TempAdjustmentTransactionHistoryLog
	 (
	  UserId INT,
	  IsAdjusted BIT NOT NULL DEFAULT(0),
	  Msg VARCHAR(100),
	  AdjustedLeaveReqAppId BIGINT
	 )

	 CREATE TABLE #tempAdvanceUserData
	 (
	   Id INT IDENTITY(1,1),
	   UserId INT,
	   AdvanceLeaveCount INT,
	   CLCount INT NOT NULL DEFAULT(0),
	   PLCount INT NOT NULL DEFAULT(0),
	   COFFCount INT NOT NULL DEFAULT(0)
	 )

  BEGIN TRANSACTION    
	 INSERT INTO #tempAdvanceUserData(UserId, AdvanceLeaveCount)
	 SELECT A.UserId, COUNT(AD.AdvanceLeaveDetailId) AS LeaveCount FROM AdvanceLeaveDetail AD JOIN AdvanceLeave A
	 ON AD.AdvanceLeaveId = A.AdvanceLeaveId AND AD.IsActive = 1 AND AD.IsAdjusted = 0
	 WHERE A.IsActive = 1 AND (A.UserId = @AdjustForUserId OR @AdjustForUserId IS NULL)
	 GROUP BY A.UserId HAVING COUNT(AD.AdvanceLeaveDetailId) != 0

	 UPDATE T SET T.CLCount = LB.[Count] 
	 FROM #tempAdvanceUserData T 
	 JOIN LeaveBalance LB ON T.UserId = LB.UserId 
	 WHERE LB.LeaveTypeId = 1 --CL LeaveTypeMaster

	 UPDATE T SET T.PLCount = LB.[Count] 
	 FROM #tempAdvanceUserData T 
	 JOIN LeaveBalance LB ON T.UserId = LB.UserId 
	 WHERE LB.LeaveTypeId = 2 --PL LeaveTypeMaster
	
	  DECLARE @StatusId int = (SELECT [StatusId] FROM [LeaveStatusMaster] WHERE [StatusCode] = 'AV'),
	          @AdminId INT = 1

	  DECLARE @i INT = 1, @UserId INT
	 
	  WHILE(@i <= (SELECT Count(*) FROM #tempAdvanceUserData))
	  BEGIN
	          DECLARE @Sucess INT = 0,
		      @CLCount FLOAT, @PLCount FLOAT, @COFFCount INT, @AdvanceLeaveCount INT,
	          @LeaveCombination VARCHAR(50), @LeaveCount INT ,@FromDateId BIGINT, @TillDateId BIGINT, 
			  @LeaveRequestApplicationId BIGINT, @LeaveTypeId INT

	       SELECT @UserId = UserId, @CLCount = CLCount,
		          @PLCount = PLCount, @AdvanceLeaveCount = AdvanceLeaveCount
		   FROM #tempAdvanceUserData WHERE Id = @i
			 
				   SELECT @COFFCount = COUNT(RequestId) From RequestCompOff WHERE IsLapsed = 0 AND StatusId = 3
						  AND IsAvailed=0 AND CreatedBy= @UserId AND LapseDate >= GETDATE()

				  SELECT @LeaveCombination = 
				  CASE WHEN @CLCount != 0 AND @AdvanceLeaveCount <= @CLCount THEN CAST(@AdvanceLeaveCount AS VARCHAR(30))+' CL' 
					   WHEN @CLCount != 0 AND @AdvanceLeaveCount > @CLCount THEN CAST(@CLCount AS VARCHAR(30))+' CL' 
					   WHEN @CLCount = 0 AND @COFFCount ! = 0 AND @AdvanceLeaveCount <= @COFFCount THEN CAST(@AdvanceLeaveCount AS VARCHAR(30))+' COFF'
					   WHEN @CLCount != 0 AND @AdvanceLeaveCount > @COFFCount THEN CAST(@COFFCount  AS VARCHAR(30))+' COFF'
					   WHEN @CLCount = 0 AND @COFFCount = 0 AND @PLCount != 0 AND @AdvanceLeaveCount <= @PLCount THEN CAST(@AdvanceLeaveCount AS VARCHAR(30))+' PL'
					   WHEN @CLCount != 0 AND @AdvanceLeaveCount > @PLCount THEN CAST(@PLCount  AS VARCHAR(30))+' PL'
					   ELSE NULL 
				  END
				  SELECT @LeaveCount =  
				  CASE WHEN @CLCount != 0 AND @AdvanceLeaveCount <= @CLCount THEN @AdvanceLeaveCount
					   WHEN @CLCount != 0 AND @AdvanceLeaveCount > @CLCount THEN @CLCount
					   WHEN @CLCount = 0 AND @COFFCount ! = 0 AND @AdvanceLeaveCount <= @COFFCount THEN @AdvanceLeaveCount
					   WHEN @CLCount != 0 AND @AdvanceLeaveCount > @COFFCount THEN @COFFCount
					   WHEN @CLCount = 0 AND @COFFCount = 0 AND @PLCount != 0 AND @AdvanceLeaveCount <= @PLCount THEN @AdvanceLeaveCount
					   WHEN @CLCount != 0 AND @AdvanceLeaveCount > @PLCount THEN @PLCount
					   ELSE 0 
				  END
       
					  SELECT @LeaveTypeId = 
					  CASE WHEN @LeaveCombination LIKE '%CL%' THEN 1
						   WHEN @LeaveCombination LIKE '%COFF%' THEN 4 
						   WHEN @LeaveCombination LIKE '%PL%' THEN 2
					  END --LeaveTypeMaster
                IF(@LeaveCount != 0)
				BEGIN
					  CREATE TABLE #TempAdvanceLeaveDetail
					  (
					  AdvanceLeaveDetailId BIGINT,
					  DateId BIGINT,
					  AdjustedLeaveReqAppId BIGINT
					  )
					  ----- insert into #TempAdvanceLeaveDetail
					  INSERT INTO #TempAdvanceLeaveDetail(AdvanceLeaveDetailId, DateId)
					  SELECT TOP (@LeaveCount) AD.AdvanceLeaveDetailId, AD.DateId 
					  FROM AdvanceLeaveDetail AD JOIN AdvanceLeave A ON AD.AdvanceLeaveId = A.AdvanceLeaveId
					  WHERE A.UserId = @UserId AND AD.IsAdjusted = 0 AND AD.IsActive = 1 AND A.IsActive = 1

					  SELECT @FromDateId = MIN(DateId), @TillDateId = MAX(DateId) FROM #TempAdvanceLeaveDetail
			
					 ---insert into LeaveRequestApplication
					  INSERT INTO [dbo].[LeaveRequestApplication] 
								([UserId],[FromDateId],[TillDateId],[NoOfTotalDays],[NoOfWorkingDays],[Reason],[PrimaryContactNo],
								 [IsAvailableOnMobile],[IsAvailableOnEmail],[StatusId],[ApproverId],[CreatedBy],[AlternativeContactNo],[LeaveCombination])
					  SELECT @UserId, @FromDateId, @TillDateId, @LeaveCount, @LeaveCount, 'Adjustment of advance leave', '8888888888',
								0, 0, @StatusId, 1, @AdminId, null, @LeaveCombination 

					  SELECT @LeaveRequestApplicationId = SCOPE_IDENTITY();

						 ---insert into LeaveRequestApplicationDetail
						 INSERT INTO [dbo].[LeaveRequestApplicationDetail](LeaveRequestApplicationId, LeaveTypeId, [Count]) 
						 VALUES (@LeaveRequestApplicationId, @LeaveTypeId, @LeaveCount)

						---insert into DateWiseLeaveType
						INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay], [IsFirstDayHalfDay], [IsLastDayHalfDay])
						SELECT @LeaveRequestApplicationId, T.DateId, @LeaveTypeId, 0, 0, 0
						FROM #TempAdvanceLeaveDetail T 

						--insert into LeaveHistory
						INSERT INTO [dbo].[LeaveHistory]([LeaveRequestApplicationId], [StatusId], [ApproverId], [ApproverRemarks], [CreatedBy])
						SELECT @LeaveRequestApplicationId ,@StatusId, 1, 'Adjustment of advance leave', @AdminId

						--update #TempAdvanceLeaveDetail
						UPDATE #TempAdvanceLeaveDetail SET AdjustedLeaveReqAppId = @LeaveRequestApplicationId 

						--update AdvanceLeaveDetail
						UPDATE AD SET AD.IsAdjusted = 1, AD.AdjustedLeaveReqAppId = T.AdjustedLeaveReqAppId, LastModifiedBy = @AdminId, LastModifiedDate = GETDATE() 
						FROM AdvanceLeaveDetail AD JOIN #TempAdvanceLeaveDetail T ON AD.AdvanceLeaveDetailId = T.AdvanceLeaveDetailId

					IF(@LeaveTypeId = 4) -- COFF
					BEGIN
						   CREATE TABLE #TempCoffAvailed(
							Id INT IDENTITY(1,1),
							RequestId INT,
							LapseDate DATE
							)
						   DECLARE @AvailedRequestId INT, @LapseDateToBeAvailed DATE, @J INT = 1

						   INSERT INTO #TempCoffAvailed(RequestId, LapseDate) 
						   SELECT TOP (@LeaveCount) RequestId, LapseDate FROM RequestCompOff
									 WHERE IsLapsed = 0 AND StatusId > 2 AND IsAvailed = 0 AND CreatedBy = @UserId 
									 AND LapseDate >= GETDATE() ORDER BY LapseDate ASC, RequestId ASC

								WHILE(@J<=(SELECT COUNT(Id) FROM #TempCoffAvailed))
								BEGIN
										SET @LapseDateToBeAvailed=(SELECT LapseDate FROM #TempCoffAvailed WHERE Id=@J)
										SET @AvailedRequestId=(SELECT RequestId FROM #TempCoffAvailed WHERE Id=@J)

									   INSERT INTO [dbo].[RequestCompOffDetail](RequestId,LeaveRequestApplicationId,CreatedById)
										   VALUES( @AvailedRequestId, @LeaveRequestApplicationId, @UserId)

									   UPDATE [dbo].[RequestCompOff] 
									   SET [IsAvailed] = 1, LastModifiedBy = @AdminId, LastModifiedDate = GETDATE() 
									   WHERE [RequestId]= @AvailedRequestId 
									   SET @J = @J + 1
								END
			     
					END
					 ---------------------------------Insert into LeaveBalanceHistory table--------------------------
					INSERT INTO [dbo].[LeaveBalanceHistory]([RecordId], [Count], [CreatedBy])
					SELECT B.[RecordId], B.[Count], @AdminId
					FROM [dbo].[LeaveBalance] B WITH (NOLOCK)
					WHERE [UserId] = @UserId AND [LeaveTypeId] = @LeaveTypeId

					---------------------------------Update into LeaveBalance table---------------------------------
					UPDATE [dbo].[LeaveBalance]
					SET [Count] = ISNULL([Count], 0) - @LeaveCount
						,[LastModifiedDate] = GETDATE()
						,[LastModifiedBy] = @AdminId
					WHERE [UserId] = @UserId AND [LeaveTypeId] = @LeaveTypeId

				  SET @Sucess = 1
				  END
				  ELSE
				  BEGIN
				     SET @Sucess = 3
				  END

				SET @i = @i + 1;
				IF OBJECT_ID('tempdb..#TempAdvanceLeaveDetail') IS NOT NULL
				DROP TABLE #TempAdvanceLeaveDetail   

				IF OBJECT_ID('tempdb..#TempCoffAvailed') IS NOT NULL
				DROP TABLE #TempCoffAvailed

				INSERT INTO #TempAdjustmentTransactionHistoryLog(UserId, IsAdjusted,Msg, AdjustedLeaveReqAppId)
				SELECT @UserId, 
					   CASE WHEN @Sucess = 1 THEN CAST(1 AS BIT) 
							ELSE CAST(0 AS BIT) 
					   END AS IsAdjusted,
					    CASE WHEN @Sucess = 1 THEN 'Adjusted sucessully'
							ELSE 'No leaves available' 
					   END AS IsAdjusted,
					   ISNULL(@LeaveRequestApplicationId,0)
	  END
	  COMMIT;	

	  SELECT UserId, IsAdjusted, AdjustedLeaveReqAppId, Msg
			FROM #TempAdjustmentTransactionHistoryLog                
END TRY
BEGIN CATCH
       IF @@TRANCOUNT > 0
	   ROLLBACK TRANSACTION;

	      DECLARE @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
	         EXEC [spInsertErrorLog]
			 @ModuleName = 'Scheduler'
			,@Source = 'Proc_AdjustAdvanceLeaveByScheduler'
			,@ErrorMessage = @ErrorMessage
			,@ErrorType = 'SP'
			,@ReportedByUserId = @AdminId

			INSERT INTO #TempAdjustmentTransactionHistoryLog(UserId, IsAdjusted, AdjustedLeaveReqAppId, Msg)
		    SELECT null, 0, 0, 'Error occurred' 

			SELECT UserId, IsAdjusted, AdjustedLeaveReqAppId, Msg
			FROM #TempAdjustmentTransactionHistoryLog
END CATCH

GO
/****** Object:  StoredProcedure [dbo].[Proc_SubmitAdvanceLeave]    Script Date: 05-03-2019 16:12:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SubmitAdvanceLeave]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_SubmitAdvanceLeave] AS' 
END
GO
/*  
   Created Date : 28-Feb-2019
   Created By   : Kanchan Kumari
   Purpose      : To apply advance leave
   Usage        :	
   ---------------------------------	
   DECLARE @Result int 
   EXEC [dbo].[Proc_SubmitAdvanceLeave]
   @EmployeeId = 2298
  ,@FromDate = '2019-02-28'
  ,@TillDate = '2019-02-28'
  ,@Reason = 'As per user request, advance leave applied with additional approval from HR which needs to be adjusted later.'
  ,@LoginUserId = 4
  ,@Success = @Result output
  SELECT @Result AS [RESULT]
*/
ALTER PROC [dbo].[Proc_SubmitAdvanceLeave]
(
@EmployeeId INT,
@FromDate DATE,
@TillDate DATE,
@Reason VARCHAR(500),
@LoginUserId INT,
@Success tinyint = 0 output
)
AS
BEGIN TRY
	  DECLARE @FromDateId BIGINT, @TillDateId BIGINT
	  SELECT @FromDateId = MIN(DateId),@TillDateId = MAX(DateId) 
	  FROM DateMaster WHERE [Date] BETWEEN @FromDate AND @TillDate

	  BEGIN TRANSACTION
	  DECLARE @IsAlreadyApplied BIT = (SELECT  dbo.Fun_CheckIfLeaveAlreadyExists(@EmployeeId, @FromDateId, @TillDateId))
	  IF(@IsAlreadyApplied = 1)
	  BEGIN
	      SET @Success = 2;--already exist
	  END
	  ELSE
	  BEGIN
		  INSERT INTO AdvanceLeave(UserId, FromDateId, TillDateId, Reason, CreatedBy)
		  VALUES(@EmployeeId, @FromDateId, @TillDateId, @Reason, @LoginUserId)

		  DECLARE @AdvanceLeaveId INT = SCOPE_IDENTITY();

		  INSERT INTO AdvanceLeaveDetail(AdvanceLeaveId, DateId, IsActive, IsAdjusted, CreatedBy)
		  SELECT @AdvanceLeaveId, DateId, 1, 0, @LoginUserId
		  FROM DateMaster
		  WHERE [Date] BETWEEN @FromDate AND @TillDate
		  ORDER BY [Date] 
		  SET @Success = 1; --successfully applied
	 END
	COMMIT;

END TRY
BEGIN CATCH
	IF @@TRANCOUNT>0
	BEGIN
	  ROLLBACK TRANSACTION;
	END
		 SET @Success = 0 -- Error occurred
		 DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
		 --Log Error
		 EXEC [spInsertErrorLog]
				 @ModuleName = 'Update Leave'
				,@Source = 'Proc_SubmitAdvanceLeave'
				,@ErrorMessage = @ErrorMessage
				,@ErrorType = 'SP'
				,@ReportedByUserId = @LoginUserId
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[spGetUserAppliedLeave]    Script Date: 05-03-2019 16:12:14 ******/
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
   --------------------------------------------------------------------------
   5 feb 2019        Kanchan Kumari      fetch data for Lnsa request
   Test Cases        :
   --------------------------------------------------------------------------
   EXEC [dbo].[spGetUserAppliedLeave] 
		@UserId = 2432
		,@Year=2018
	    ,@IsWFHData = 1
		,@IsOuting = 1
		,@IsLnsa = 1
		,@IsAdvanaceLeave = 1
***/

ALTER PROCEDURE [dbo].[spGetUserAppliedLeave] 
(
   @UserID [int],
   @Year [int] = null,
   @IsWFHData [bit] = 0,
   @IsOuting [bit] = 0,
   @IsLnsa [bit] = 0,
   @IsAdvanaceLeave [bit] = 0
)
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
	 [LegitimateAppliedOn] VARCHAR(30),
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
		,F.LegitimateAppliedOn
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
					SELECT UserId, DateId, CONVERT(VARCHAR(11),CreatedDate,106)+' '+ FORMAT(CreatedDate, 'hh:mm tt') AS LegitimateAppliedOn
					FROM [LegitimateLeaveRequest]    ----LegitimateLeaveStatus
					WHERE UserId = @UserId AND StatusId <= 5 --not rejected or cancelled
					GROUP BY UserId, DateId, CreatedDate
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
		,F.[LegitimateAppliedOn]
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
					SELECT UserId, DateId, CONVERT(VARCHAR(11),CreatedDate,106)+' '+ FORMAT(CreatedDate, 'hh:mm tt') AS LegitimateAppliedOn
					FROM [LegitimateLeaveRequest]    ----LegitimateLeaveStatus
					WHERE UserId = @UserId AND StatusId <= 5 --not rejected or cancelled
					GROUP BY UserId, DateId, CreatedDate
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

   IF(@IsOuting = 1)
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
		,NULL AS [LegitimateAppliedOn]
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

   IF(@IsLnsa = 1)
   BEGIN
       INSERT INTO #TempUserAppliedLeave
	   SELECT 
	     'LNSA' AS [FetchLeaveType]
		,R.CreatedDate AS [ApplyDate]
	    ,R.RequestId AS [LeaveRequestApplicationId]
        ,D.[Date]            AS [FromDate]
        ,M.[Date]            AS [TillDate]
        ,'LNSA ('+ CAST(R.[TotalNoOfDays]AS VARCHAR(20)) + ' LNSA)' AS [LeaveInfo]  
     ,R.[Reason]          
		,LS.StatusCode AS [Status]
        ,CASE WHEN LS.StatusCode = 'PA' THEN  LS.[Status]+' with '+UD.FirstName+' '+UD.LastName 
		  ELSE LS.[Status]+' by '+VW.FirstName+' '+VW.LastName END AS [StatusFullForm]
		,0 AS [IsLegitimateApplied]
		,NULL AS [LegitimateAppliedOn]
		,R.[ApproverRemarks] AS [Remarks]
		,R.[TotalNoOfDays]  AS [LeaveCount]
		,R.CreatedBy AS CreatedBy
      FROM
         [dbo].[RequestLnsa] R WITH (NOLOCK) -- LNSAStatusMaster
		    INNER JOIN [dbo].[DateWiseLnsa] DW WITH (NOLOCK) ON R.RequestId = DW.RequestId
			INNER JOIN [dbo].[DateMaster] DM WITH (NOLOCK) ON DW.DateId = DM.[DateId]
		    INNER JOIN [dbo].[DateMaster] D WITH (NOLOCK) ON D.[DateId] = R.[FromDateId]
            INNER JOIN [dbo].[DateMaster] M WITH (NOLOCK) ON M.[DateId] = R.[TillDateId]
		    LEFT JOIN [dbo].[UserDetail] UD WITH (NOLOCK) ON R.ApproverId = UD.UserId
		    LEFT JOIN [dbo].[UserDetail] VW WITH (NOLOCK) ON R.[LastModifiedBy] = VW.UserId
			INNER JOIN [dbo].[LNSAStatusMaster] LS WITH (NOLOCK) ON R.StatusId = LS.StatusId
      WHERE
         R.[CreatedBy] = @UserId AND  R.[CreatedBy] != 1 AND DM.[Date] BETWEEN @StartDate AND @EndDate
		 AND R.[StatusId] <=5 ORDER BY R.CreatedDate DESC 
   END
   IF(@IsAdvanaceLeave = 1)
   BEGIN
        INSERT INTO #TempUserAppliedLeave
        SELECT
       'AdvanceLeave' AS [FetchLeaveType]
		,R.CreatedDate AS [ApplyDate]
	    ,R.AdvanceLeaveId AS [LeaveRequestApplicationId]
        ,D.[Date]            AS [FromDate]
        ,M.[Date]            AS [TillDate]
        ,'Advance Leave ('+ CAST(M.[DateId]-D.[DateId]+1 AS VARCHAR(10) )+ ' )' AS [LeaveInfo]  
        ,R.[Reason]          
		,CASE WHEN R.IsActive = 1 THEN 'AD'
			  ELSE 'CA'
		 END AS [Status]
        ,CASE WHEN R.IsActive = 1 THEN 'Applied'
			  ELSE 'Cancelled'
		 END  AS [StatusFullForm]
		,0 AS [IsLegitimateApplied]
		,NULL AS [LegitimateAppliedOn]
		,'NA' AS [Remarks]
		,D.[DateId]-M.[DateId]+1  AS [LeaveCount]
		,R.CreatedBy AS CreatedBy
      FROM
         [dbo].[AdvanceLeave] R -- LNSAStatusMaster
		    INNER JOIN [dbo].[DateMaster] D  ON D.[DateId] = R.[FromDateId]
            INNER JOIN [dbo].[DateMaster] M  ON M.[DateId] = R.[TillDateId]
		    INNER JOIN [dbo].[vwAllUsers] UD ON R.CreatedBy = UD.UserId
      WHERE
         R.[UserId] = @UserId AND D.[Date]>= @StartDate AND M.[Date]<= @EndDate
		  ORDER BY R.CreatedDate DESC 
   END

   SELECT [FetchLeaveType], [ApplyDate], [LeaveRequestApplicationId], [FromDate], [TillDate], [LeaveInfo] ,
	      [Reason], [Status], [StatusFullForm], [IsLegitimateApplied], [LegitimateAppliedOn], [Remarks], [LeaveCount], [CreatedBy] 
   FROM #TempUserAppliedLeave 
   GROUP BY [FetchLeaveType], [ApplyDate], [LeaveRequestApplicationId], [FromDate], [TillDate], [LeaveInfo] ,
	        [Reason], [Status], [StatusFullForm], [IsLegitimateApplied],[LegitimateAppliedOn], [Remarks], [LeaveCount], [CreatedBy] 
   ORDER BY [ApplyDate] DESC, [FromDate] DESC
   END



GO
/****** Object:  StoredProcedure [dbo].[spManageEmployeeClientSideProjectAndManagerMapping]    Script Date: 05-03-2019 16:12:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spManageEmployeeClientSideProjectAndManagerMapping]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spManageEmployeeClientSideProjectAndManagerMapping] AS' 
END
GO
/***
   Created Date      :    4-Mar-2019
   Created By        :    Kanchan Kumari
   Purpose           :    This stored procedure is to get information of all employees
   Usage             :
     DECLARE @result int, @Msg VARCHAR(2000)
     EXEC [dbo].[spManageEmployeeClientSideProjectAndManagerMapping]
     @mapping = '<EmployeeProjectMapping><Mapping MappingId = "1" ClientSideManagerId = "2" ProjectId = "2" EmployeeId = "GSI G 045" IsBilled = "1" IsActive = "1"/>
	                  </EmployeeProjectMapping>',
     @Success =  @result output,
	 @Message = @Msg output
	 SELECT @result AS Result, @Msg AS Message

	 errorLog order by 1 desc
***/

ALTER PROCEDURE [dbo].[spManageEmployeeClientSideProjectAndManagerMapping] 
(
    @Mapping [xml] 
   ,@Success tinyint = 0 output
   ,@Message varchar(2000) = '' output
)
AS
BEGIN TRY
   SET NOCOUNT ON;

   IF OBJECT_ID('tempdb..#EmployeeProjectMapping') IS NOT NULL
   DROP TABLE #EmployeeProjectMapping

         CREATE TABLE #EmployeeProjectMapping
         (
            [MappingId] BIGINT NULL 
           ,[ClientSideManagerId] [BIGINT] NOT NULL
           ,[ProjectId] [bigint] NOT  NULL
		   ,[EmployeeId] VARCHAR(40) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
		   ,[IsBilled] BIT NOT NULL 
		   ,[IsActive] BIT NOT NULL
		   ,[IsDeleted] AS CASE WHEN [IsActive] = 1 THEN 0 ELSE 1 END
         )

         INSERT INTO #EmployeeProjectMapping
         (
            [MappingId], [ClientSideManagerId], [ProjectId], [EmployeeId], [IsBilled], [IsActive]   
         )
		 SELECT T.Item.value('@MappingId', 'BIGINT') AS MappingId,
			T.Item.value('@ClientSideManagerId', 'BIGINT') AS ClientSideManagerId,
			T.Item.value('@ProjectId', 'BIGINT') AS ProjectId,
			T.Item.value('@EmployeeId', '[VARCHAR](30)') AS EmployeeId,
			T.Item.value('@IsBilled', 'BIT') AS  IsBilled,
			T.Item.value('@IsActive', 'BIT') AS IsActive
		FROM @Mapping.nodes('/EmployeeProjectMapping/Mapping') AS T(Item)

	  BEGIN TRANSACTION
         -------insert when same data doesn't exist       
         INSERT INTO [dbo].[UserClientSideManagerAndProjectMapping]
         (
            [UserId], [ClientSideManagerId], [ProjectId], [IsBilled], [IsActive], [CreatedBy]
         )
         SELECT U.[UserId], M.[ClientSideManagerId], M.[ProjectId], M.[IsBilled], M.[IsActive], 1
         FROM [dbo].[UserDetail] U WITH (NOLOCK)
         INNER JOIN #EmployeeProjectMapping M 
                     ON U.[EmployeeId] = M.[EmployeeId] AND M.MappingId = 0
	     LEFT JOIN [dbo].[UserClientSideManagerAndProjectMapping] UC 
			         ON U.UserId = UC.UserId AND M.ClientSideManagerId = UC.ClientSideManagerId 
					    AND M.ProjectId = UC.ProjectId AND M.IsBilled = UC.IsBilled
					    AND M.IsActive = UC.IsActive
         WHERE UC.MappingId IS NULL 
		 
		 -----update when same data exist 
		 UPDATE T SET T.ProjectId = M.ProjectId, 
		              T.[ClientSideManagerId] = M.[ClientSideManagerId],
					  T.[IsBilled] = M.[IsBilled], T.[IsActive] = M.[IsActive],
					  T.[IsDeleted] = M.[IsDeleted]
		  FROM [dbo].[UserClientSideManagerAndProjectMapping] T
		  INNER JOIN [dbo].[UserDetail] U WITH (NOLOCK)
		            ON T.UserId = U.UserId
          INNER JOIN #EmployeeProjectMapping M 
                    ON U.[EmployeeId] = M.[EmployeeId] AND  M.MappingId <> 0
		  INNER JOIN [dbo].[UserClientSideManagerAndProjectMapping] UC 
			         ON  M.MappingId = UC.[MappingId] AND U.UserId = UC.UserId
    
		 	SET @Success=1    ---------------commit if successful
			SET @Message='Employees project mapped successfully.'   ---------------commit if successful
	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
   IF @@TRANCOUNT>0
   ROLLBACK TRANSACTION;

    DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
		DECLARE @ErrId BIGINT=0 

		EXEC [spInsertErrorLog]
			@ModuleName = 'EmployeeClientSideProjectAndManagerMapping'
			,@Source = 'spInsertEmployeeClientSideProjectAndManagerMapping'
			,@ErrorMessage = @ErrorMessage
			,@ErrorType = 'SP'
			,@ReportedByUserId = 1
			,@ErrorId=@ErrId OUTPUT

		SET @Success=0; -----------------error occured
		SET @Message= 'Your request cannot be processed, please try after some time or contact to MIS team with reference id: ' + CAST(@ErrId AS VARCHAR(20)) + ' for further assistance.'
END CATCH

GO
/****** Object:  StoredProcedure [dbo].[spTakeActionOnAppliedLeave]    Script Date: 05-03-2019 16:12:14 ******/
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

------------compOff
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
					,R.IsLapsed = 0
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

