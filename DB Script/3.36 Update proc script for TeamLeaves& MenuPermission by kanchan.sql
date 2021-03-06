/****** Object:  StoredProcedure [dbo].[spUpdateLeaveBalanceAndLeaveStatus]    Script Date: 26-10-2018 18:00:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spUpdateLeaveBalanceAndLeaveStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spUpdateLeaveBalanceAndLeaveStatus]
GO
/****** Object:  StoredProcedure [dbo].[spGetMenusPermissions]    Script Date: 26-10-2018 18:00:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetMenusPermissions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetMenusPermissions]
GO
/****** Object:  StoredProcedure [dbo].[spApplyLeave]    Script Date: 26-10-2018 18:00:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spApplyLeave]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spApplyLeave]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetTimeSheetInfoForAllSelectedUsers]    Script Date: 26-10-2018 18:00:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetTimeSheetInfoForAllSelectedUsers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetTimeSheetInfoForAllSelectedUsers]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetTeamLeaves]    Script Date: 26-10-2018 18:00:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetTeamLeaves]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetTeamLeaves]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetTeamLeaves]    Script Date: 26-10-2018 18:00:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetTeamLeaves]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetTeamLeaves] AS' 
END
GO
 /*
 =============================================
 Author       :  CHANDRA PRAKASH
 ALTER date   :  27 JAN 2017
 Usage  :  Proc_GetTeamLeaves  82
 Change History    :
 --------------------------------------------------------------------------
 Modify Date       Edited By            Change Description
 --------------------------------------------------------------------------
 26 0ct 2018       kanchan kumari       removed case for leavetype and join with LeaveTypeMaster 
                                        used group by instead of distinct to remove duplicate data
 --------------------------------------------------------------------------
*/

ALTER PROCEDURE [dbo].[Proc_GetTeamLeaves] 
   @UserId int
AS
BEGIN

SET NOCOUNT ON;
SET FMTONLY OFF;

CREATE TABLE #teamId
(
   TeamId int
)

INSERT INTO #teamId (TeamId)(SELECT TeamId from UserTeamMapping  where UserId=@userID);
INSERT INTO #teamId (TeamId)(SELECT TeamId from Team  where TeamHeadId =@userID);

 SELECT --DISTINCT
         U.[EmployeeName] AS [UserName]
		,DM.[Date] as DateFrom, DM2.[Date] as DateTo,
		--CASE LTM.[TypeId] WHEN 5 THEN 'WFH' ELSE 'Leave' END AS [LeaveType]
	     CAST('Leave' AS VARCHAR(10)) AS [LeaveType]
		,CAST(1 AS INT) AS LeaveTypeId  --LAD.LeaveTypeId
		,L.[LeaveRequestApplicationId]													
      FROM [dbo].[LeaveRequestApplication] L WITH (NOLOCK)
            INNER JOIN [dbo].[DateWiseLeaveType] T WITH (NOLOCK) ON T.[LeaveRequestApplicationId] = L.[LeaveRequestApplicationId]
            INNER JOIN [dbo].[vwActiveUsers] U WITH (NOLOCK) ON L.[UserId] = U.[UserId] 
			INNER JOIN [dbo].[DateMaster] D WITH (NOLOCK) ON T.[DateId] = D.[DateId] 
			INNER JOIN [dbo].[LeaveStatusMaster] S WITH (NOLOCK) ON S.[StatusId] = L.[StatusId]
			INNER JOIN [dbo].[DateMaster] DM WITH (NOLOCK) ON L.[FromDateId] = DM.[DateId]
			INNER JOIN [dbo].[DateMaster] DM2 WITH (NOLOCK) ON L.[TillDateId] = DM2.[DateId]
			INNER JOIN [dbo].[LeaveRequestApplicationDetail] LAD WITH (NOLOCK) ON LAD.[LeaveRequestApplicationId] = L.[LeaveRequestApplicationId]
			--INNER JOIN [dbo].[LeaveTypeMaster] LTM WITH (NOLOCK) ON LTM.[TypeId] = LAD.[LeaveTypeId]
			INNER JOIN [dbo].[UserTeamMapping] UTM WITH (NOLOCK) ON UTM.[UserId] = U.[UserId]
      WHERE D.[Date] >= DateAdd(dd, -1, GETDATE())  AND S.[StatusId] > 0 
		 AND (UTM.TeamId IN (select distinct * from #teamId) OR UTM.UserId IN (SELECT UserId FROM UserDetail WITH (NOLOCK) WHERE ReportTo = @UserId))
	  GROUP BY U.[EmployeeName], DM.[Date], DM2.[Date], L.[LeaveRequestApplicationId]		

DROP table #teamId

END
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetTimeSheetInfoForAllSelectedUsers]    Script Date: 26-10-2018 18:00:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetTimeSheetInfoForAllSelectedUsers]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetTimeSheetInfoForAllSelectedUsers] AS' 
END
GO
/***
   Created Date      :     2018-10-25
   Created By        :     Kanchan Kumari
   Purpose           :     To fetch timesheet report for multiple users
   --------------------------------------------------------------------------
   Usage             : Proc_GetTimeSheetInfoForAllSelectedUsers @TimeSheetIds = '284747,069594,049490'
   --------------------------------------------------------------------------
***/
ALTER PROC [dbo].[Proc_GetTimeSheetInfoForAllSelectedUsers]
(
 @TimeSheetIds VARCHAR(max)
)
AS
BEGIN 
SET FMTONLY OFF;
	   IF OBJECT_ID('tempdb..#TempTimeSheetId') IS NOT NULL
	   DROP TABLE #TempTimeSheetId
      
	   CREATE TABLE #TempTimeSheetId
	   (
		 IdentityId INT,
		 TimeSheetId BIGINT
	   )

	    INSERT INTO #TempTimeSheetId 
		SELECT * FROM Fun_SplitStringInt(@TimeSheetIds,',')

	 SELECT 
	       VW.EmployeeName, TS.[WeekNo], [Year], CONVERT(VARCHAR(20), LT.[Date], 106) AS [Date]
		   ,P.Name AS ProjectName, VW.Team, TP.TaskTypeName, LT.[Description] TaskDescription, LT.TimeSpent
	 FROM TimeSheet TS JOIN TimeSheetTaskMapping TT 
	      ON TS.TimeSheetId = TT.TimeSheetId
	 JOIN LoggedTasks LT ON TT.TaskId = LT.TaskId AND LT.IsActive = 1 AND IsDeleted = 0
	 JOIN TaskType TP ON LT.TaskTypeId = TP.TaskTypeId
	 JOIN Projects P ON LT.ProjectId = P.ProjectId
	 LEFT JOIN vwActiveUsers VW ON TS.CreatedBy = VW.UserId
	 WHERE TS.TimeSheetId IN(SELECT TimeSheetId FROM #TempTimeSheetId) AND TS.[Status] = 2
	 ORDER BY TS.WeekNo, VW.EmployeeName, LT.[Date], P.Name
END
GO
/****** Object:  StoredProcedure [dbo].[spApplyLeave]    Script Date: 26-10-2018 18:00:14 ******/
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
   26 oct 2018        kanchan kumari      added check for holidays while inserting date 
                                          in DateWiseLeaveType
   --------------------------------------------------------------------------

   Test Cases        :
   --------------------------------------------------------------------------
   
   --- Test Case 1
       DECLARE @Result [INT]
         EXEC  [dbo].[spApplyLeave]
             @EmployeeId = 2203
            ,@LoginUserId = 2203
            ,@FromDate = '2018-08-12'
            ,@TillDate = '2018-08-16'
            ,@Reason = 'testing'
            ,@LeaveCombination= '2 COFF + 1PL'
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
         
        CREATE TABLE #TempLeaveCombination(
             [LeaveCombination] varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL
            )
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
                        WHILE (@StartDateId <= @TillDateId)
                        BEGIN
						     IF((SELECT HolidayId from ListofHoliday WHERE DateId = @StartDateId)>0)  --- applied date should not be Holidays 
							 BEGIN
							      SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
							 END
							 ELSE
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
/****** Object:  StoredProcedure [dbo].[spGetMenusPermissions]    Script Date: 26-10-2018 18:00:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetMenusPermissions]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGetMenusPermissions] AS' 
END
GO
/*
 Author	  :	Sudhanshu Shekhar
 Create date: 12-July-2016
 Description:	To get menus permissions
 Usage: [spGetMenusPermissions] 2241
 Change History    :
   -------------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------------
   26 oct 2018        kanchan kumari      Remove selected menus for Ineligible user
  ---------------------------------------------------------------------------------
*/
ALTER PROCEDURE [dbo].[spGetMenusPermissions]
(
  @LoginUserId INT
)
AS
BEGIN
	SET NOCOUNT ON;
	SET FMTONLY OFF;

   IF OBJECT_ID('tempdb..#PermissionTemp') IS NOT NULL
   DROP TABLE #PermissionTemp

	CREATE TABLE #PermissionTemp (
		MenuId INT, 
		MenuName VARCHAR(100),
		ParentMenuId INT,
		ControllerName VARCHAR(100),
		ActionName VARCHAR(100),
		[Sequence] INT,
		IsLinkEnabled BIT,
		IsTabMenu BIT,
		IsViewRights BIT,
		IsAddRights BIT,
		IsModifyRights BIT,
		IsDeleteRights BIT,
		IsAssignRights BIT,
		IsApproveRights BIT,
		IsDelegatable BIT,
		IsDelegated BIT DEFAULT(0),
		IsVisible BIT,
		CssClass VARCHAR(200)
		)
	IF(@LoginUserId > 0)
	BEGIN
		--User Permissions		
		INSERT INTO #PermissionTemp (MenuId, MenuName, ParentMenuId, ControllerName, ActionName, [Sequence], 
			IsLinkEnabled, IsTabMenu, IsViewRights, IsAddRights, IsModifyRights, IsDeleteRights, IsAssignRights, IsApproveRights, IsDelegatable, IsVisible, CssClass)
		SELECT M.MenuId, M.MenuName, M.ParentMenuId, M.ControllerName, M.ActionName, M.[Sequence], 
			M.IsLinkEnabled, M.IsTabMenu, P.IsViewRights, P.IsAddRights, P.IsModifyRights, P.IsDeleteRights, P.IsAssignRights, P.IsApproveRights, M.IsDelegatable, M.IsVisible, M.CssClass
		FROM Menu M
		JOIN MenusUserPermission P ON M.MenuId = P.MenuId AND P.UserId = @LoginUserId
		WHERE M.ParentMenuId NOT IN (SELECT MenuId FROM Menu WHERE ParentMenuId = 0 AND IsActive = 0)
		AND M.IsActive = 1 AND P.IsActive = 1

		--User Delegations
		IF EXISTS (SELECT 1 FROM Menu M JOIN MenusUserDelegation P ON M.MenuId = P.MenuId AND P.DelegatedToUserId = @LoginUserId
		WHERE M.ParentMenuId NOT IN (SELECT MenuId FROM Menu WHERE ParentMenuId = 0 AND IsActive = 0)
		AND M.IsActive = 1 AND P.IsActive = 1 AND P.MenuId IN(SELECT MenuId FROM #PermissionTemp)
		AND CONVERT(DATE, P.DelegatedFromDate) <= CONVERT(DATE, GETDATE()) AND CONVERT(DATE, P.DelegatedTillDate) >= CONVERT(DATE, GETDATE()))
		BEGIN -- update
			UPDATE T
			SET T.IsDelegatable = M.IsDelegatable, T.IsDelegated = 1
			FROM #PermissionTemp T
			JOIN Menu M WITH (NOLOCK) ON M.MenuId = T.MenuId
			JOIN MenusUserDelegation P ON T.MenuId = P.MenuId AND P.DelegatedToUserId = @LoginUserId
			WHERE M.ParentMenuId NOT IN (SELECT MenuId FROM Menu WHERE ParentMenuId = 0 AND IsActive = 0)
			AND M.IsActive = 1 AND P.IsActive = 1 AND P.MenuId IN(SELECT MenuId FROM #PermissionTemp)
			AND CONVERT(DATE, P.DelegatedFromDate) <= CONVERT(DATE, GETDATE()) AND CONVERT(DATE, P.DelegatedTillDate) >= CONVERT(DATE, GETDATE())
		END
		ELSE 
		BEGIN -- insert
			INSERT INTO #PermissionTemp (MenuId, MenuName, ParentMenuId, ControllerName, ActionName, [Sequence], 
				IsLinkEnabled, IsTabMenu, IsViewRights, IsAddRights, IsModifyRights, IsDeleteRights, IsAssignRights, IsApproveRights, IsDelegatable, IsDelegated, IsVisible, CssClass)
			SELECT M.MenuId, M.MenuName, M.ParentMenuId, M.ControllerName, M.ActionName, M.[Sequence], 
				M.IsLinkEnabled, M.IsTabMenu, P.IsViewRights, P.IsAddRights, P.IsModifyRights, P.IsDeleteRights, P.IsAssignRights, P.IsApproveRights, M.IsDelegatable, 1, M.IsVisible, M.CssClass
			FROM Menu M
			JOIN MenusUserDelegation P ON M.MenuId = P.MenuId AND P.DelegatedToUserId = @LoginUserId
			WHERE M.ParentMenuId NOT IN (SELECT MenuId FROM Menu WHERE ParentMenuId = 0 AND IsActive = 0)
			AND M.IsActive = 1 AND P.IsActive = 1 AND P.MenuId NOT IN(SELECT MenuId FROM #PermissionTemp)
			AND CONVERT(DATE, P.DelegatedFromDate) <= CONVERT(DATE, GETDATE()) AND CONVERT(DATE, P.DelegatedTillDate) >= CONVERT(DATE, GETDATE())
		END

		--User Delegations Parent, insert if parent not exist
			INSERT INTO #PermissionTemp (MenuId, MenuName, ParentMenuId, ControllerName, ActionName, [Sequence], 
				IsLinkEnabled, IsTabMenu, IsViewRights, IsAddRights, IsModifyRights, IsDeleteRights, IsAssignRights, IsApproveRights, IsDelegatable, IsVisible, CssClass)
			SELECT M.MenuId, M.MenuName, M.ParentMenuId, M.ControllerName, M.ActionName, M.[Sequence], 0 as IsLinkEnabled, M.IsTabMenu, 1, 1, 1, 1, 1, 1, M.IsDelegatable, M.IsVisible, M.CssClass
			FROM Menu M WHERE M.MenuId IN(SELECT ParentMenuId FROM #PermissionTemp) AND M.MenuId NOT IN (SELECT MenuId FROM #PermissionTemp)

		--Role Permissions
		DECLARE @RoleId INT = (SELECT TOP 1 RoleId FROM [User] WHERE UserId = @LoginUserId)

		INSERT INTO #PermissionTemp (MenuId, MenuName, ParentMenuId, ControllerName, ActionName, [Sequence], 
			IsLinkEnabled, IsTabMenu, IsViewRights, IsAddRights, IsModifyRights, IsDeleteRights, IsAssignRights, IsApproveRights, IsDelegatable, IsVisible, CssClass)
		SELECT M.MenuId, M.MenuName, M.ParentMenuId, M.ControllerName, M.ActionName, M.[Sequence], 
			M.IsLinkEnabled, M.IsTabMenu, P.IsViewRights, P.IsAddRights, P.IsModifyRights, P.IsDeleteRights, P.IsAssignRights, P.IsApproveRights, M.IsDelegatable, M.IsVisible, M.CssClass
		FROM Menu M
		JOIN MenusRolePermission P ON M.MenuId = P.MenuId AND P.RoleId = @RoleId
		WHERE M.ParentMenuId NOT IN (SELECT MenuId FROM Menu WHERE ParentMenuId = 0 AND IsActive = 0)
		AND P.MenuId NOT IN (SELECT T.MenuId FROM #PermissionTemp T)
		AND M.IsActive = 1 AND P.IsActive = 1

		--Exclude Menus for users with restricted permissions
		Delete from #PermissionTemp
		WHERE MenuId IN (12,23) AND (SELECT IsEligibleForLeave FROM UserDetail WHERE UserId = @LoginUserId) = 0
    END

	SELECT MenuId, MenuName, ParentMenuId, ControllerName, ActionName, [Sequence], IsLinkEnabled, IsTabMenu, IsViewRights, IsAddRights, 
		   IsModifyRights, IsDeleteRights, IsAssignRights, IsApproveRights, IsDelegatable, IsDelegated, IsVisible, CssClass
	FROM #PermissionTemp 
	ORDER BY MenuId;
END

--UPDATE Menu Set IsActive = 1 Where MenuId = 3




GO
/****** Object:  StoredProcedure [dbo].[spUpdateLeaveBalanceAndLeaveStatus]    Script Date: 26-10-2018 18:00:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spUpdateLeaveBalanceAndLeaveStatus]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spUpdateLeaveBalanceAndLeaveStatus] AS' 
END
GO
/***
   Created Date      :     2016-03-11
   Created By        :     Rakesh Gandhi
   Purpose           :     This stored procedure increments or expire leaves, marks status for leaves to availed
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By          Change Description
   --------------------------------------------------------------------------
   1-Jun-2017		 Sudhanshu Shekhar	Added ModifiedDate, ModifiedBy, RM Roles
   13-Sep-2018		 Sudhanshu Shekhar	DocumentPermission
   26 oct 2018       Kanchan Kumari     Restrict leave balance update for ineligible user
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   Test Case 1: EXEC [dbo].[spUpdateLeaveBalanceAndLeaveStatus]
***/
ALTER PROCEDURE [dbo].[spUpdateLeaveBalanceAndLeaveStatus]
AS
BEGIN TRY
    SET NOCOUNT ON;
	DECLARE @CurrentDate [date] = GETDATE(),  @CurrentDateTime [datetime] = GETDATE(), @LoginUserId INT = 1 --Admin

    BEGIN TRANSACTION

         -- insert record to history
         INSERT INTO [dbo].[LeaveBalanceHistory]
         (
            [RecordId]
            ,[Count]
            ,[CreatedDate]
            ,[CreatedBy]
         )
         
         SELECT B.[RecordId], B.[Count], @CurrentDateTime, 1
         FROM [dbo].[UserDetail] U WITH (NOLOCK) 
         INNER JOIN [dbo].[LeaveBalance] B WITH (NOLOCK) ON B.[UserId] = U.[UserId] 
         INNER JOIN [dbo].[LeaveTypeMaster] T WITH (NOLOCK) ON T.[TypeId] = B.[LeaveTypeId]
         INNER JOIN [dbo].[Designation] D WITH (NOLOCK) ON D.[DesignationId] = U.[DesignationId]
         WHERE
            ISNULL(U.[TerminateDate], '2999-12-31') > @CurrentDate
            AND U.[UserId] != 1
            AND (T.[IsAutoExpire] = 1 OR T.[IsAutoIncremented] = 1)
            AND (T.[NextAutoExpireDate] = @CurrentDate OR T.[NextAutoIncrementDate] = @CurrentDate)
			AND U.IsEligibleForLeave = 1 ----update only for eligible Users

         UNION ALL
	     SELECT B.[RecordId], B.[Count], @CurrentDateTime, 1
         FROM [dbo].[UserDetail] U WITH (NOLOCK)
         INNER JOIN [dbo].[LeaveBalance] B WITH (NOLOCK) ON B.[UserId] = U.[UserId] 
         INNER JOIN [dbo].[LeaveTypeMaster] T WITH (NOLOCK) ON T.[ShortName]='CLT'
         INNER JOIN [dbo].[Designation] D WITH (NOLOCK) ON D.[DesignationId] = U.[DesignationId] AND D.[IsIntern]=1
         WHERE
            ISNULL(U.[TerminateDate], '2999-12-31') > @CurrentDate
            AND U.[UserId] != 1
			AND T.[IsAutoIncremented] = 1
            AND T.[NextAutoIncrementDate] = @CurrentDate
			AND U.IsEligibleForLeave = 1 ----update only for eligible Users
         -- auto expire leaves
		 ----for FTE
         UPDATE B
         SET B.[Count] = 0, B.LastModifiedDate = @CurrentDateTime, B.LastModifiedBy = @LoginUserId
         FROM [dbo].[UserDetail] U WITH (NOLOCK)
         INNER JOIN [dbo].[LeaveBalance] B ON B.[UserId] = U.[UserId] 
         INNER JOIN [dbo].[LeaveTypeMaster] T WITH (NOLOCK) ON T.[TypeId] = B.[LeaveTypeId]
         INNER JOIN [dbo].[Designation] D WITH (NOLOCK) ON D.[DesignationId] = U.[DesignationId]
         WHERE
            ISNULL(U.[TerminateDate], '2999-12-31') > @CurrentDate
            AND U.[UserId] != 1
            AND T.[IsAutoExpire] = 1
            AND T.[NextAutoExpireDate] = @CurrentDate
			AND U.IsEligibleForLeave = 1 ----update only for eligible Users
         ---expire CL for interns
		 UPDATE B
         SET B.[Count] = 0, B.LastModifiedDate = @CurrentDateTime, B.LastModifiedBy = @LoginUserId
         FROM [dbo].[UserDetail] U WITH (NOLOCK)
         INNER JOIN [dbo].[LeaveBalance] B ON B.[UserId] = U.[UserId] 
         INNER JOIN [dbo].[LeaveTypeMaster] T WITH (NOLOCK) ON T.[ShortName]='CLT'
         INNER JOIN [dbo].[Designation] D WITH (NOLOCK) ON D.[DesignationId] = U.[DesignationId] AND D.[IsIntern]=1
         WHERE
            ISNULL(U.[TerminateDate], '2999-12-31') > @CurrentDate
            AND U.[UserId] != 1
			AND T.[IsAutoExpire] = 1
            AND T.[NextAutoExpireDate] = @CurrentDate
			AND U.IsEligibleForLeave = 1 ----update only for eligible Users
         -- auto increment leaves
		 --------for FTE
         UPDATE B
         SET B.[Count] = B.[Count] + T.[DaysToIncrement],B.LastModifiedDate = @CurrentDateTime, B.LastModifiedBy = @LoginUserId
         FROM [dbo].[UserDetail] U WITH (NOLOCK)
         INNER JOIN [dbo].[LeaveBalance] B ON B.[UserId] = U.[UserId] 
         INNER JOIN [dbo].[LeaveTypeMaster] T WITH (NOLOCK) ON T.[TypeId] = B.[LeaveTypeId]
		 INNER JOIN [dbo].[Designation] D WITH (NOLOCK) ON D.[DesignationId] = U.[DesignationId]
         WHERE
            ISNULL(U.[TerminateDate], '2999-12-31') > @CurrentDate
            AND U.[UserId] != 1
			AND D.[IsIntern] <> 1
            --AND D.[DesignationName] NOT LIKE '%Intern%'
            --AND D.[DesignationName] NOT LIKE '%Trainee%'
            AND T.[IsAutoIncremented] = 1
            AND T.[NextAutoIncrementDate] = @CurrentDate
			AND U.IsEligibleForLeave = 1 ----update only for eligible Users
         -------update 3 CL quarterly for interns
	     BEGIN
		 UPDATE B
		 SET B.[Count]=B.[Count] + T.[DaysToIncrement],B.LastModifiedDate = @CurrentDateTime, B.LastModifiedBy = @LoginUserId
		 FROM [dbo].[UserDetail] U WITH (NOLOCK)
         INNER JOIN [dbo].[LeaveBalance] B ON B.[UserId] = U.[UserId] 
         INNER JOIN [dbo].[LeaveTypeMaster] T WITH (NOLOCK) ON T.[ShortName]='CLT'
		 INNER JOIN [dbo].[Designation] D WITH (NOLOCK) ON D.[DesignationId] = U.[DesignationId] AND D.[IsIntern]=1
         WHERE
            ISNULL(U.[TerminateDate], '2999-12-31') > @CurrentDate
            AND U.[UserId] != 1
			AND B.[LeaveTypeId]=1
			AND T.[IsAutoIncremented] = 1
            AND T.[NextAutoIncrementDate] = @CurrentDate
			AND U.IsEligibleForLeave = 1 ----update only for eligible Users
		 END

         -- update dates for type
         UPDATE T
         SET T.[LastAutoIncrementDate] = @CurrentDate
            ,T.[NextAutoIncrementDate] =   CASE T.[AutoIncrementAfterType]
                                             WHEN 'Month' THEN DATEADD(MM, T.[AutoIncrementPeriod], @CurrentDate)
                                             WHEN 'Year' THEN DATEADD(YY, T.[AutoIncrementPeriod], @CurrentDate)
                                          END
			,T.LastModifiedDate = @CurrentDateTime, T.LastModifiedBy = @LoginUserId
         FROM [dbo].[LeaveTypeMaster] T
         WHERE T.[IsAutoIncremented] = 1 AND T.[NextAutoIncrementDate] = @CurrentDate

         UPDATE T
         SET T.[LastAutoExpireDate] = @CurrentDate
            ,T.[NextAutoExpireDate] =      CASE T.[AutoExpireAfterType]
                                             WHEN 'Month' THEN DATEADD(MM, T.[AutoExpirePeriod], @CurrentDate)
                                             WHEN 'Year' THEN DATEADD(YY, T.[AutoExpirePeriod], @CurrentDate)
                                          END
			,T.LastModifiedDate = @CurrentDateTime, T.LastModifiedBy = @LoginUserId
         FROM [dbo].[LeaveTypeMaster] T
         WHERE T.[IsAutoExpire] = 1 AND T.[NextAutoExpireDate] = @CurrentDate


         -- update leaves status to availed 
         UPDATE L
         SET L.[StatusId] = AVS.[StatusId]
		    ,L.LastModifiedDate = @CurrentDateTime, L.LastModifiedBy = @LoginUserId
         FROM [dbo].[LeaveRequestApplication] L
         INNER JOIN [dbo].[DateMaster] D WITH (NOLOCK) ON D.[DateId] = L.[FromDateId]
         INNER JOIN [dbo].[LeaveStatusMaster] CS WITH (NOLOCK) ON CS.[StatusId] = L.[StatusId] AND CS.[StatusCode] = 'AP'
         INNER JOIN [dbo].[LeaveStatusMaster] AVS WITH (NOLOCK) ON AVS.[StatusCode] = 'AV'
         WHERE D.[Date] < @CurrentDate

		 -- update leave status to availed not approved
         UPDATE L
         SET L.[StatusId] = AVS.[StatusId]
			,L.LastModifiedDate = @CurrentDateTime, L.LastModifiedBy = @LoginUserId
         FROM [dbo].[LeaveRequestApplication] L
         INNER JOIN [dbo].[DateMaster] D WITH (NOLOCK) ON D.[DateId] = L.[FromDateId]
         INNER JOIN [dbo].[LeaveStatusMaster] CS WITH (NOLOCK) ON CS.[StatusId] = L.[StatusId] AND (CS.[StatusCode] = 'PA')
         INNER JOIN [dbo].[LeaveStatusMaster] AVS WITH (NOLOCK) ON AVS.[StatusCode] = 'AVNA'
 WHERE D.[Date] < DATEADD(dd, -1, @CurrentDate)

		 -- update leave status to availed not verified
         UPDATE L
         SET L.[StatusId] = AVS.[StatusId]
			,L.LastModifiedDate = @CurrentDateTime, L.LastModifiedBy = @LoginUserId
         FROM [dbo].[LeaveRequestApplication] L
         INNER JOIN [dbo].[DateMaster] D WITH (NOLOCK) ON D.[DateId] = L.[FromDateId]
         INNER JOIN [dbo].[LeaveStatusMaster] CS WITH (NOLOCK) ON CS.[StatusId] = L.[StatusId] AND (CS.[StatusCode] = 'PV')
         INNER JOIN [dbo].[LeaveStatusMaster] AVS WITH (NOLOCK) ON AVS.[StatusCode] = 'AVNV'
         WHERE D.[Date] < DATEADD(dd, -1, @CurrentDate)

		 --Assign RM to manager role if they have reportee
	     UPDATE U
	     SET U.RoleId = (Select RoleId FROM [Role] WITH (NOLOCK) WHERE [RoleName] = 'Manager'),
	     U.LastModifiedBy = 1,
	     U.LastModifiedDate = GETDATE()
	     FROM [User] U WITH (NOLOCK)
	     WHERE U.UserId IN (SELECT UserId FROM dbo.vwActiveUsers VAU WHERE UserId IN (SELECT RMId FROM dbo.vwActiveUsers VAU)
	     		AND (RoleId = 4 OR RoleId = 5)
	     )

	     --Map User to All groups(4) to access shared documents------------
	     INSERT INTO DocumentPermissionGroupPermissions(DocumentPermissionGroupId,UserId,IsDeleted)
	     SELECT 4 AS DocumentPermissionGroupId,  UserId, 0 AS IsDeleted
	     FROM dbo.vwActiveUsers
	     WHERE UserId NOT IN (SELECT UserId FROM DocumentPermissionGroupPermissions WHERE DocumentPermissionGroupId = 4)

     COMMIT TRANSACTION;
END TRY
BEGIN CATCH
   	-- On Error
	IF @@TRANCOUNT > 0
	BEGIN
      ROLLBACK TRANSACTION;
    END
    
	DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))

    EXEC [spInsertErrorLog]
	      @ModuleName = 'LMS'
         ,@Source = 'spUpdateLeaveBalanceAndLeaveStatus'
         ,@ErrorMessage = @ErrorMessage
         ,@ErrorType = 'SP'
         ,@ReportedByUserId = 1
END CATCH
GO
