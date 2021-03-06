
/****** Object:  StoredProcedure [dbo].[spGetLeaveBalanceForUser]    Script Date: 31-10-2018 17:03:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetLeaveBalanceForUser]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetLeaveBalanceForUser]
GO
/****** Object:  StoredProcedure [dbo].[spGetAvailableLeaveCombination]    Script Date: 31-10-2018 17:03:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetAvailableLeaveCombination]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetAvailableLeaveCombination]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetLeaveBalanceHistoryByFY]    Script Date: 31-10-2018 17:03:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetLeaveBalanceHistoryByFY]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetLeaveBalanceHistoryByFY]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetLeaveBalanceHistoryByFY]    Script Date: 31-10-2018 17:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetLeaveBalanceHistoryByFY]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetLeaveBalanceHistoryByFY] AS' 
END
GO
/***
   Created Date      :     2018-07-04
   Created By        :     Mimansa Agrawal
   Purpose           :     This stored procedure fetches leave details for dashboard
   Change History    
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   31 oct 2018       Kanchan Kumari       fetch data for leavetype ML and PL(M)
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   --- Test Case 1
  EXEC Proc_GetLeaveBalanceHistoryByFY 
'01-04-2018'
,'ML'
,2251
***/
ALTER PROCEDURE [dbo].[Proc_GetLeaveBalanceHistoryByFY]
(
 @Year datetime
,@LeaveType varchar(5)
,@UserId int
)
AS
BEGIN 
BEGIN TRANSACTION
SET NOCOUNT ON;
	DECLARE @StartDate [date], @EndDate [date],@AdminId int=1,@FYear bigint,
	      @QStartDate DATE = CAST (DATEADD(q, DATEDIFF(q, 0, GETDATE()), 0) AS [Date])
         ,@QEndDate DATE = CAST (DATEADD(d, -1, DATEADD(q, DATEDIFF(q, 0, GETDATE()) + 1, 0)) AS [Date])
	SET @FYear=DATEPART(YYYY, @Year)
	IF (@FYear IS NULL OR @FYear =0)
		SET @FYear = DATEPART(YYYY, GETDATE())

	SELECT @StartDate =dateadd(Year,0,cast(concat(@FYear,'-04-01') as date)) ,
			@EndDate = dateadd(Year,1,cast(concat(@FYear,'-03-31') as date)) 
 IF(@LeaveType='WFH')
 BEGIN
     SELECT 
     LR.[CreatedDate]                                                 AS [ApplyDate]
	  ,DM1.[Date]                                                     AS [FromDate]
	  ,DM2.[Date]                                                     AS [TillDate]
	 -- ,LR.[Reason]
	  ,LT.[ShortName]                                                 AS [LeaveInfo]
	  ,LS.[Status]                                                    AS [Status]
      ,CASE
         WHEN H.[ApproverRemarks] IS NULL THEN 'NA'
         WHEN LTRIM(RTRIM(H.[ApproverRemarks])) = '' THEN LAP.[FirstName] + ' ' + LAP.[LastName] + ': Approved'
         ELSE LAP.[FirstName] + ' ' + LAP.[LastName] + ': ' + H.[ApproverRemarks]
      END                                                             AS [Remarks]
	  ,LR.[CreatedBy] AS [CreatedBy]
	  ,LR.[NoOfTotalDays]  AS [LeaveCount]                                                                                          
	FROM 
      [dbo].[LeaveRequestApplication] LR WITH (NOLOCK)
	      INNER JOIN 
            [dbo].[LeaveRequestApplicationDetail] LRD WITH (NOLOCK)
		         ON LR.[LeaveRequestApplicationId] = LRD.[LeaveRequestApplicationId]
	      INNER JOIN 
            [dbo].[LeaveStatusMaster] LS WITH (NOLOCK)
		         ON LR.[StatusId] = LS.StatusId
	      INNER JOIN 
            [dbo].[LeaveTypeMaster] LT WITH (NOLOCK)
		         ON LRD.[LeaveTypeId] = LT.[TypeId]
	      INNER JOIN 
            [dbo].[DateMaster] DM1 WITH (NOLOCK)
		         ON LR.[FromDateId] = DM1.DateId
	      INNER JOIN 
            [dbo].[DateMaster] DM2 WITH (NOLOCK)
		         ON LR.[TillDateId] = DM2.[DateId]
	       LEFT JOIN
            (
               SELECT
                  H.[LeaveRequestApplicationId]    AS [LeaveRequestApplicationId]
                 ,MAX(H.[CreatedDate])           AS [LastUpdatedTime]
               FROM
                  [dbo].[LeaveHistory] H WITH (NOLOCK)
               GROUP BY
                  H.[LeaveRequestApplicationId]
            ) RH
               ON RH.[LeaveRequestApplicationId] = LR.[LeaveRequestApplicationId]
         LEFT JOIN
            [dbo].[LeaveHistory] H WITH (NOLOCK)
               ON H.[LeaveRequestApplicationId] = RH.[LeaveRequestApplicationId]
               AND H.[CreatedDate] = RH.[LastUpdatedTime]
         LEFT JOIN
            [dbo].[UserDetail] LAP WITH (NOLOCK)
               ON LAP.[UserId] = H.[CreatedBy] 
         LEFT JOIN
            [dbo].[UserDetail] NAP WITH (NOLOCK)
               ON NAP.[UserId] = LR.[ApproverId]
       WHERE 
         LR.[UserId] = @UserId   AND (LR.StatusId=3 OR LR.StatusId=4 OR LR.StatusId=5 OR LR.StatusId=6)
		   AND LT.[ShortName] = 'WFH' AND DM1.[Date] BETWEEN @StartDate AND @EndDate
   ORDER BY LR.[CreatedDate] DESC
END
ELSE IF (@LeaveType='LNSA')
BEGIN
 SELECT DISTINCT
         R.[CreatedDate]                                                                                  AS [ApplyDate]
	   , D.[Date]     AS [FromDate]
        ,M.[Date]                                                                                         AS [TillDate]
        ,CAST(COUNT (DW.[IsApprovedBySystem]) AS float)                                                   AS [LeaveCount]
       -- ,R.[Reason]                                                                                       AS [Reason]
		,R.[ApproverRemarks]																			  AS [Remarks]
        ,CASE R.[Status]
            WHEN 0 THEN 'Pending for Appoval with ' + UD.[FirstName] + ' ' + UD.[LastName]
            WHEN -1 THEN 'Rejected By ' + UD.[FirstName] + ' ' + UD.[LastName]
            WHEN 1 THEN 'Approved By ' + UD.[FirstName] + ' ' + UD.[LastName] 
         END                                                                                              AS [Status]
		,R.[CreatedBy] 
		 ,CAST ('LNSA' AS [VARCHAR]) AS [LeaveInfo]                                                                                         
      FROM
         [dbo].[RequestLnsa] R WITH (NOLOCK)
            INNER JOIN
               [dbo].[DateMaster] D WITH (NOLOCK)
                  ON D.[DateId] = R.[FromDateId]
            INNER JOIN
               [dbo].[DateMaster] M WITH (NOLOCK)
                  ON M.[DateId] = R.[TillDateId]
            INNER JOIN
               [dbo].[UserDetail] U WITH (NOLOCK)
                  ON U.[UserId] = R.[CreatedBy]
            INNER JOIN
               [dbo].[UserDetail] UD WITH (NOLOCK)
                  ON UD.[UserId] = U.[ReportTo]
				  INNER JOIN [dbo].[DateWiseLNSA] DW WITH (NOLOCK)
				  ON R.[RequestId]=DW.[RequestId]
      WHERE
         R.[CreatedBy] = @UserId AND D.[Date] BETWEEN @QStartDate AND @QEndDate AND DW.[IsApprovedBySystem]=1
		 GROUP BY R.[CreatedDate],R.[RequestId],D.[Date],M.[Date],R.[Reason],R.[ApproverRemarks],UD.[FirstName],UD.[LastName],R.[Status],R.[CreatedBy]
      ORDER BY R.[CreatedDate] DESC ,D.[Date] DESC
END
ELSE IF(@LeaveType = 'ML' OR @LeaveType = 'PL(M)')
BEGIN
       SELECT
       LR.[CreatedDate]   AS [ApplyDate]
	  ,DM1.[Date]         AS [FromDate]
	  ,DM2.[Date]         AS [TillDate]
	  ,LT.[ShortName]     AS [LeaveInfo]
	  ,LS.[Status]        AS [Status]
	  ,LR.ApproverRemarks AS [Remarks]
	  ,LR.[CreatedBy] AS [CreatedBy]
	  ,LR.[NoOfWorkingDays]  AS [LeaveCount]                                                                                          
	FROM 
      [dbo].[LeaveRequestApplication] LR WITH (NOLOCK)
	      INNER JOIN 
            [dbo].[LeaveRequestApplicationDetail] LRD WITH (NOLOCK)
		         ON LR.[LeaveRequestApplicationId] = LRD.[LeaveRequestApplicationId]
	      INNER JOIN 
            [dbo].[LeaveStatusMaster] LS WITH (NOLOCK)
		         ON LR.[StatusId] = LS.StatusId
	      INNER JOIN 
            [dbo].[LeaveTypeMaster] LT WITH (NOLOCK)
		         ON LRD.[LeaveTypeId] = LT.[TypeId]
	      INNER JOIN 
            [dbo].[DateMaster] DM1 WITH (NOLOCK)
		         ON LR.[FromDateId] = DM1.DateId
	      INNER JOIN 
            [dbo].[DateMaster] DM2 WITH (NOLOCK)
		         ON LR.[TillDateId] = DM2.[DateId]
         WHERE 
         LR.[UserId] = @UserId   AND LR.StatusId NOT IN(0,-1)
		   AND LT.[ShortName] = @LeaveType AND DM1.[Date] BETWEEN @StartDate AND @EndDate
   ORDER BY LR.[CreatedDate] DESC
END
ELSE 
   BEGIN
    SELECT DISTINCT
		 LR.[CreatedDate]																									AS [ApplyDate]
        ,DM1.[Date]																											AS [FromDate]
		,DM2.[Date]	                                                                                                        AS [TillDate]
		--,LR.[Reason]																										
		,CAST(LR.[NoOfWorkingDays] AS [varchar](3)) + ' (' + LR.[LeaveCombination] + ')'									AS [LeaveInfo]
		,LS.[Status]                                                                                                        AS [Status]
		,CASE 
			WHEN LS.[StatusCode] = 'CA' THEN LS.[Status]
			WHEN RH.[ApproverRemarks] IS NULL THEN ''
			WHEN RH.[ApproverRemarks] = '' THEN UD1.[FirstName] + ' ' + UD1.[LastName] + ': Approved'
			WHEN (RH.[ApproverId] = 1 AND RH.[CreatedBy] = 1) THEN RH.[ApproverRemarks]
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
			[dbo].[UserDetail] UD1 WITH (NOLOCK) ON UD1.[UserId] = RH.[CreatedBy]
	WHERE 
      LR.[UserId] = @UserId  AND LR.[LeaveCombination] IN (SELECT LeaveCombination FROM LeaveRequestApplication WHERE LeaveCombination LIKE '%' + @LeaveType + '%')
      AND (LR.[StatusId]>=1)
      AND DM1.[Date] BETWEEN @StartDate AND  @EndDate
   ORDER BY  LR.[CreatedDate] DESC, DM1.[Date] DESC 
END
COMMIT TRANSACTION
END



GO
/****** Object:  StoredProcedure [dbo].[spGetAvailableLeaveCombination]    Script Date: 31-10-2018 17:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetAvailableLeaveCombination]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGetAvailableLeaveCombination] AS' 
END
GO
/***
   Created Date      :     2015-05-26
   Created By        :     Nishant Srivastava
   Purpose           :     This stored procedure give all the possible combination of leaves according to user leave balance .
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   31 oct 2018        Kanchan Kumari      added Maternity Leave and Paternity Leave combination
   --------------------------------------------------------------------------
   Test Cases        : 3 LWP3 LWP
   --------------------------------------------------------------------------
   --- Test Case 1
        
/**Declare @Userid int ,@NoOfWorkingDays float ,@LeaveTypeId int ,@i int, @CL float ,@PL int,@compOf int ,@IsSpecial bit
SET @Userid = 2234
SET @NoOfWorkingDays =2
UPDATE LeaveBalance_Dummy
        SET NoOfLeave = 2
WHERE Userid = 33 And LeaveTypeId = 4 **/
***/
ALTER PROC [dbo].[spGetAvailableLeaveCombination]
    @Userid INT 
   ,@NoOfWorkingDays FLOAT 
   ,@LeaveApplicationId bigint 
  AS
      BEGIN
      Declare @LeaveTypeId int ,@i int, @CL float ,@PL int,@compOf int ,@IsSpecial bit, @leaveappliedCount float,@leavetype int, @ML INT, @PLM INT
       --supplying a data contract
         IF 1 = 2 
            BEGIN
                   SELECT
                       CAST(NULL AS [Varchar] (50)) AS [LeaveCombination]                       				   
                   WHERE
                       1 = 2
            END   
	
	-- To add leave count of the leave which is being cancelled when cancel and applying leave	
		SELECT @leaveappliedCount = LD.[Count], @Leavetype = LD.[LeaveTypeId]
		FROM [dbo].[LeaveRequestApplicationDetail] LD WITH (NOLOCK)
				INNER JOIN [dbo].[LeaveTypeMaster] LS WITH (NOLOCK) ON LD.[LeaveTypeId] = LS.[TypeId]
		WHERE LD.[LeaveRequestApplicationId] = @LeaveApplicationId
		AND LS.[ShortName] != 'LWP'
         
		 --IF OBJECT_ID('tempdb..#Temp') IS NOT NULL
		 --DROP TABLE #Temp     

         CREATE TABLE #Temp
         (
         [Userid] [int] NOT NULL,
         [LeaveTypeID] [int] NOT NULL,
         [LeaveCombination] [Varchar](50),
         [IsSpecial] [bit] 
         ) 

         SELECT  @IsSpecial = COUNT(*) 
         FROM [dbo].[LeaveBalance] WITH (NOLOCK) 
         WHERE [Userid] = @Userid AND [LeaveTypeId] =8  AND [Count] =1 --and [NoOfLeave] >=1
         
			IF (@Leavetype = 1 AND @leaveappliedCount > 2)
				SET @IsSpecial = 1

         --SELECT @IsSpecial AS IsSpecial

         SET @i = 1
         WHILE @i <= 5
         BEGIN
            BEGIN
                  IF (@i =1)
                     SET @LeaveTypeId = 1 
                  ELSE IF (@i =2)
                     Set @LeaveTypeId = 2
                  ELSE IF (@i =3)
                     Set @LeaveTypeId = 4   
				  ELSE IF (@i = 4)----newly added combination
				    Set @LeaveTypeId = 6 ---ML 
					 ELSE IF (@i = 5)----newly added combination
				    Set @LeaveTypeId = 7 ---PL(M)         
            END

         SET @i =  @i + 1 
     
         SELECT @CL = [Count] FROM [dbo].[LeaveBalance] WITH (NOLOCK) WHERE Userid= @Userid AND LeaveTypeId= 1
         SELECT @PL = [Count] FROM [dbo].[LeaveBalance] WITH (NOLOCK) WHERE Userid= @Userid AND LeaveTypeId= 2
         SELECT @compOf = [Count] FROM [dbo].[LeaveBalance] WITH (NOLOCK) WHERE Userid= @Userid AND LeaveTypeId= 4
		 SELECT @ML = [Count] FROM [dbo].[LeaveBalance] WITH (NOLOCK) WHERE Userid= @Userid AND LeaveTypeId= 6
		 SELECT @PLM = [Count] FROM [dbo].[LeaveBalance] WITH (NOLOCK) WHERE Userid= @Userid AND LeaveTypeId= 7
         
			  IF (@Leavetype = 1)
				SET @CL = @CL + @leaveappliedCount 
			ELSE IF (@Leavetype = 2)
				Set @PL = @PL + @leaveappliedCount
			ELSE IF (@Leavetype =3 )
				Set @compOf = @compOf + @leaveappliedCount
       --     ELSE IF(@Leavetype = 6)----newly added combination
			    --Set @ML = @ML + @leaveappliedCount

             IF (@LeaveTypeId = 1 )
            BEGIN
                     IF (  @IsSpecial = 1 )
                     BEGIN
                         IF( @CL >=2  AND @NoOfWorkingDays <= 2)
                        BEGIN
                              INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                              SELECT  Userid
									  ,LeaveTypeId 
									  ,Convert (varchar(5),@NoOfWorkingDays,0) + ' CL '  AS LeaveCombination
                                    ,@IsSpecial As ISSpecial
FROM   [dbo].[LeaveBalance] WITH (NOLOCK) 
                              WHERE   Userid = @Userid and LeaveTypeId= 1
                              PRINT '1.0'
                        END
                         ELSE IF( @CL >=5  AND  @NoOfWorkingDays <= 5 AND @CL >= @NoOfWorkingDays)--  @NoOfWorkingDays <= 5 )
                        BEGIN
                              INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                              SELECT  Userid
                                    ,LeaveTypeId 
                                    ,Convert (varchar(5),@NoOfWorkingDays,0) +' CL '  AS LeaveCombination
                                    ,@IsSpecial As ISSpecial
                              FROM   [dbo].[LeaveBalance] WITH (NOLOCK) 
                              WHERE   Userid = @Userid and LeaveTypeId= 1
                              PRINT '1.2'
                        END
						ELSE IF (@CL >= 5 AND @NoOfWorkingDays >= 5 )
                        BEGIN
                              INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                                 SELECT  Userid
                                       ,LeaveTypeId 
                                       ,'5 CL + ' + Convert (varchar(5),@NoOfWorkingDays - 5,0)  + ' LWP' AS LeaveCombination
                                       ,@IsSpecial As ISSpecial
                                 FROM   [dbo].[LeaveBalance] WITH (NOLOCK) 
                                 WHERE   Userid = @Userid and LeaveTypeId= 1
                                 PRINT '1.3'
                                 ------------------------------------
							
                                 IF(@NoOfWorkingDays <= 10 AND @PL >= (@NoOfWorkingDays - 5))
                                 BEGIN
                                    INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                                    SELECT  Userid
                                          ,LeaveTypeId 
                                          ,'5 CL + ' + Convert (varchar(5),@NoOfWorkingDays - 5,0)  + ' PL' AS LeaveCombination
                                          ,@IsSpecial As ISSpecial
                                    FROM   [dbo].[LeaveBalance] WITH (NOLOCK)
                                   WHERE   Userid = @Userid and LeaveTypeId= 1
                                 END
                                 ------------------------------------
                        END 
                        ELSE IF( @CL <=5  AND @NoOfWorkingDays <= 5 )

                              BEGIN
                                  INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                                  SELECT  Userid
                                          ,LeaveTypeId 
                                          ,CASE
                                                WHEN @NoOfWorkingDays <= @CL THEN  Convert (varchar(5), @NoOfWorkingDays,0) + ' CL'
                                                ELSE Convert (varchar(5), @CL,0) + ' CL + '+ Convert (varchar(5),@NoOfWorkingDays - @CL,0)  + ' LWP'
                                           END                                          
                                          ,@IsSpecial As ISSpecial
                                  FROM   [dbo].[LeaveBalance] WITH (NOLOCK) 
                                  WHERE   Userid = @Userid and LeaveTypeId= 1
                                  PRINT '1.4'
								------------------------------------
								
								  
                                  IF(@PL >= (@NoOfWorkingDays - @CL))
								
                                    BEGIN
                                       INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
       SELECT  Userid
                      ,LeaveTypeId 
                                             ,CASE
     WHEN @NoOfWorkingDays <= @CL THEN  Convert (varchar(5), @NoOfWorkingDays,0) + ' CL'
                                                ELSE Convert (varchar(5), @CL,0) + ' CL + ' + Convert (varchar(5),@NoOfWorkingDays - @CL,0)  + ' PL'
                                             END                                                                                       
                                             ,@IsSpecial As ISSpecial
                                       FROM   [dbo].[LeaveBalance] WITH (NOLOCK)
                                       WHERE   Userid = @Userid and LeaveTypeId= 1
                                       PRINT '1.4.1'
                                    END
                                  ------------------------------------
                              END
                             
                          ELSE IF (@CL <= 5 AND @NoOfWorkingDays >= 5 )

                              BEGIN
                                  INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                                     SELECT  Userid
                                             ,LeaveTypeId 
                                             ,Convert (varchar(5), @CL,0) + ' CL + '+ Convert (varchar(5),@NoOfWorkingDays - @CL,0)  + ' LWP' AS LeaveCombination
                                             ,@IsSpecial As ISSpecial
                                     FROM   [dbo].[LeaveBalance] WITH (NOLOCK) 
                                     WHERE   Userid = @Userid and LeaveTypeId= 1
                                     PRINT '1.5'
                                   ------------------------------------
                                       IF(@NoOfWorkingDays <= 10 AND @PL >= (@NoOfWorkingDays - @CL))
                                       BEGIN
                                          INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                                          SELECT  Userid
                                                ,LeaveTypeId 
                                                ,Convert (varchar(5), @CL,0) + ' CL + ' + Convert (varchar(5),@NoOfWorkingDays - 5,0)  + ' PL' AS LeaveCombination
                                                ,@IsSpecial As ISSpecial
                                          FROM   [dbo].[LeaveBalance] WITH (NOLOCK)
                                          WHERE   Userid = @Userid and LeaveTypeId= 1
                                       END
                                   ------------------------------------
                              END
                          ELSE IF (@CL  = 0 AND @NoOfWorkingDays >= 1 )

                              BEGIN
                                  INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                                     SELECT  Userid,LeaveTypeId 
                                             ,Convert (varchar(5),@NoOfWorkingDays,0)  + ' LWP' AS LeaveCombination
                                             ,@IsSpecial As ISSpecial
                                     FROM   [dbo].[LeaveBalance] WITH (NOLOCK) 
                                     WHERE   Userid = @Userid and LeaveTypeId= 1
                                     PRINT '1.6'
                              END
				
                      END  
               ELSE
                     BEGIN
                             
	                         IF (  @CL >= 2 AND  @NoOfWorkingDays > 2 AND @IsSpecial = 0)
                              BEGIN
                                   INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                                  SELECT  Userid
                                          ,LeaveTypeId 
										  ,'2 CL + ' + Convert (varchar(5),@NoOfWorkingDays - 2,0) + ' LWP '   AS LeaveCombination
    ,@IsSpecial As ISSpecial
								 FROM   [dbo].[LeaveBalance] WITH (NOLOCK) 
                     WHERE   Userid = @Userid and LeaveTypeId= 1
                                  PRINT '1.7 '
                               END
                               ELSE IF ( ( @CL <> 0 and @CL <= 2) AND  @NoOfWorkingDays <= 2 AND @CL < @NoOfWorkingDays AND @IsSpecial = 0)
                              BEGIN
                                   INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                                  SELECT  Userid
                                          ,LeaveTypeId 
                                          ,Convert (varchar(5),@CL ,0) + ' CL + ' + Convert (varchar(5),@NoOfWorkingDays -@CL ,0) + ' LWP'   AS LeaveCombination
                                          ,@IsSpecial As ISSpecial
                                  FROM   [dbo].[LeaveBalance] WITH (NOLOCK) 
                                  WHERE   Userid = @Userid and LeaveTypeId= 1
                                  PRINT '1.8'
                               END
                               ELSE IF ( ( @CL <> 0 and @CL <= 2) AND  @NoOfWorkingDays <= 2 AND @CL = @NoOfWorkingDays AND @IsSpecial = 0 )
                              BEGIN
                                   INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                                  SELECT  Userid
                                          ,LeaveTypeId 
                                          ,Convert (varchar(5),@NoOfWorkingDays ,0) + ' CL '    AS LeaveCombination
                                          ,@IsSpecial As ISSpecial
                                  FROM   [dbo].[LeaveBalance] WITH (NOLOCK) 
                                  WHERE   Userid = @Userid and LeaveTypeId= 1
                                  PRINT '1.9'
                               END
                               ELSE IF (   @NoOfWorkingDays <= 2 AND @CL > @NoOfWorkingDays  AND @IsSpecial = 0)
                              BEGIN
                                   INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                                  SELECT  Userid
                                          ,LeaveTypeId 
                                          ,Convert (varchar(5),@NoOfWorkingDays ,0) + ' CL '    AS LeaveCombination
                ,@IsSpecial As ISSpecial
                                  FROM   [dbo].[LeaveBalance] WITH (NOLOCK) 
                                  WHERE   Userid = @Userid and LeaveTypeId= 1
                                  PRINT '1.10'
                               END
                                ELSE IF ( ( @CL = 0 ) AND  @NoOfWorkingDays <= 2 AND @IsSpecial = 0 )
                              BEGIN
                                   INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                                  SELECT  Userid
                                          ,LeaveTypeId 
                                          ,Convert (varchar(5),@CL,0) +' CL + ' + Convert (varchar(5),@NoOfWorkingDays ,0) + ' LWP '   AS LeaveCombination
                                          ,@IsSpecial As ISSpecial
                                  FROM   [dbo].[LeaveBalance] WITH (NOLOCK) 
                                  WHERE   Userid = @Userid and LeaveTypeId= 1
                                  PRINT '1.11'
                               END

                               ELSE IF (@CL  = 0 AND @NoOfWorkingDays >= 1  AND @IsSpecial = 0 )

                              BEGIN
                                  INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                                     SELECT  Userid
											,LeaveTypeId 
											,Convert (varchar(5),@CL,0) +' CL + ' + Convert (varchar(5),@NoOfWorkingDays,0)  + ' LWP' AS LeaveCombination
                         ,@IsSpecial As ISSpecial
                                     FROM   [dbo].[LeaveBalance] WITH (NOLOCK) 
         WHERE   Userid = @Userid and LeaveTypeId= 1
         PRINT '1.12'
                              END
                           END
           END
             IF (@LeaveTypeId = 2 )
            BEGIN
               IF (@PL > 0  And @NoOfWorkingDays > 0)
                     BEGIN
                        IF (@pl >= @NoOfWorkingDays )
                           BEGIN             
                                    INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)  
                                    SELECT Userid ,LeaveTypeId , Convert (varchar(4),(@NoOfWorkingDays ),0 ) + ' PL' AS LeaveCombination
                                    ,0 As ISSpecial
                                    FROM [dbo].[LeaveBalance] WITH (NOLOCK) 
                                    WHERE Userid = @Userid and LeaveTypeId = 2
                                    PRINT '2.0'
                           END
                        ELSE 
                           BEGIN
                                    INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                                    SELECT Userid ,LeaveTypeId , Convert (varchar(4),@pl ,0 ) + ' PL + ' + Convert (varchar(4),(@NoOfWorkingDays- @pl ),0 )+ ' LWP' AS LeaveCombination
                                    ,0 As ISSpecial
                                    FROM [dbo].[LeaveBalance] WITH (NOLOCK) 
                                    WHERE Userid = @Userid and LeaveTypeId= 2
                                    PRINT '2.1'
                           END
                     END
                 ELSE 
                           BEGIN
                                     INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)
                                    SELECT Userid 
                                          ,LeaveTypeId 
                                          ,Convert (varchar(4),@pl ,0 ) + ' PL + ' +Convert (varchar(4),(@NoOfWorkingDays),0 )+ ' LWP' AS LeaveCombination
                                    ,0 As ISSpecial
                                    FROM [dbo].[LeaveBalance] WITH (NOLOCK) 
                                    WHERE Userid = @Userid and LeaveTypeId= 2
          Print '2.2'
                           END
            END
             IF (@LeaveTypeId = 4 )
            BEGIN
               IF ( @compOf >= 1 AND @NoOfWorkingDays = 1 )
                  BEGIN   
                         INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)            
                        SELECT 
                              Userid 
                             ,LeaveTypeId 
                             ,Convert (varchar(4),(@NoOfWorkingDays ),0 ) + ' COFF' AS LeaveCombination
                        ,0 As ISSpecial
                        FROM [dbo].[LeaveBalance] WITH (NOLOCK) 
                        WHERE Userid = @Userid and LeaveTypeId= 4
                        PRINT '3.0'
                  END
              ELSE IF(@compOf >= 1 AND @NoOfWorkingDays = 0.5)--condition for 0.5 coff
               BEGIN   
              INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)            
                     SELECT 
                           Userid 
                           ,LeaveTypeId 
                           ,Convert (varchar(4),(@NoOfWorkingDays ),0 ) + ' LWP' AS LeaveCombination
                     ,0 As ISSpecial
                     FROM [dbo].[LeaveBalance] WITH (NOLOCK) 
                     WHERE Userid = @Userid and LeaveTypeId= 4
                      PRINT '3.1'
               END
       ELSE IF(@compof >=1 AND @NoOfWorkingDays<=2 AND @NoOfWorkingDays>1)
	   BEGIN
	   INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)            
                     SELECT 
                           Userid 
                           ,LeaveTypeId 
                           ,CASE
                           WHEN @CL>=1 THEN '1 COFF + ' + Convert (varchar(4),(@NoOfWorkingDays-1 ),0 ) + ' CL' 
						   ELSE  '1 COFF + ' + Convert (varchar(4),(@NoOfWorkingDays-1 ),0 ) + ' LWP' 
						    END    
                     ,0 As ISSpecial
                     FROM [dbo].[LeaveBalance] WITH (NOLOCK) 
                     WHERE Userid = @Userid and LeaveTypeId= 4
                      PRINT '3.2'
	   END
	   IF(@compof >=1 AND @NoOfWorkingDays<=2 AND @NoOfWorkingDays>1)
	   BEGIN
	   INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)            
                     SELECT 
                           Userid 
                           ,LeaveTypeId 
                           ,CASE
                            WHEN @PL>=1 THEN '1 COFF + ' + Convert (varchar(4),(@NoOfWorkingDays-1 ),0 ) + ' PL' 
						   ELSE  '1 COFF + ' + Convert (varchar(4),(@NoOfWorkingDays-1 ),0 ) + ' LWP' 
						    END    
							,0 As ISSpecial
                     FROM [dbo].[LeaveBalance] WITH (NOLOCK) 
                     WHERE Userid = @Userid and LeaveTypeId= 4
                      PRINT '3.3'
	   END
	    IF(@compof >=2 AND @NoOfWorkingDays>2 AND @NoOfWorkingDays<=10)
	   BEGIN
	   INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)            
                     SELECT 
                           Userid 
                           ,LeaveTypeId
						   ,CASE
                            WHEN @PL>=@NoOfWorkingDays-2 THEN '2 COFF + ' + Convert (varchar(4),(@NoOfWorkingDays-2 ),0 ) + ' PL' 
						   ELSE  '2 COFF + ' + Convert (varchar(4),(@NoOfWorkingDays-2),0 ) + ' LWP' 
						    END   
                           ,0 As ISSpecial
                     FROM [dbo].[LeaveBalance] WITH (NOLOCK) 
                     WHERE Userid = @Userid and LeaveTypeId= 4
                      PRINT '3.4'
	   END
	    IF(@compof >=2  AND @CL>=2 AND @NoOfWorkingDays>2 AND @NoOfWorkingDays<=4)
	   BEGIN
	   INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)          
                     SELECT 
                           Userid 
                           ,LeaveTypeId 
                           ,'2 COFF + ' + Convert (varchar(4),(@NoOfWorkingDays-2 ),0 ) + ' CL' AS LeaveCombination
                     ,0 As ISSpecial
                     FROM [dbo].[LeaveBalance] WITH (NOLOCK) 
                     WHERE Userid = @Userid and LeaveTypeId= 4
                      PRINT '3.5'
	   END
	   IF(@compof >=2  AND @NoOfWorkingDays=2)
	   BEGIN
	   INSERT INTO #Temp  (Userid,LeaveTypeID,LeaveCombination,IsSpecial)          
                     SELECT 
                           Userid 
                           ,LeaveTypeId 
                           ,'2 COFF'  AS LeaveCombination
                     ,0 As ISSpecial
                     FROM [dbo].[LeaveBalance] WITH (NOLOCK) 
                     WHERE Userid = @Userid and LeaveTypeId= 4
                      PRINT '3.5'
	   END

           END 
		     IF (@LeaveTypeId = 6) ---Maternity Leave
			 BEGIN
			    IF((SELECT UserId FROM [UserDetail] WHERE UserId = @Userid AND GenderId = 2 AND MaritalStatusId = 2)>0)
				BEGIN
				PRINT 'MLP'
					IF(@NoOfWorkingDays<=@ML)
					BEGIN
						INSERT INTO #Temp  (Userid, LeaveTypeID, LeaveCombination, IsSpecial)  
						SELECT Userid, LeaveTypeId, Convert (varchar(4),(@NoOfWorkingDays ),0 ) + ' ML' AS LeaveCombination
						, 0 As ISSpecial
						FROM [dbo].[LeaveBalance] WITH (NOLOCK) 
						WHERE Userid = @Userid and LeaveTypeId = @LeaveTypeId
                    END
                END
			 END    
			 IF (@LeaveTypeId = 7) ---Paternity Leave
			 BEGIN
			    IF((SELECT UserId FROM [UserDetail] WHERE UserId = @Userid AND GenderId = 1 AND MaritalStatusId = 2)>0)
				BEGIN
				PRINT 'PLM'
					IF(@NoOfWorkingDays <= @PLM)
					BEGIN
						INSERT INTO #Temp  (Userid, LeaveTypeID, LeaveCombination, IsSpecial)  
						SELECT Userid, LeaveTypeId, Convert (varchar(4),(@NoOfWorkingDays ),0 ) + ' PL(M)' AS LeaveCombination
						, 0 As ISSpecial
						FROM [dbo].[LeaveBalance] WITH (NOLOCK) 
						WHERE Userid = @Userid and LeaveTypeId = @LeaveTypeId
                    END
                END
			 END          
     END

         UPDATE #Temp 
         SET LeaveCombination = Replace (LeaveCombination ,'0 CL +','')
         WHERE LeaveTypeID =1

         UPDATE #Temp 
         SET LeaveCombination = Replace (LeaveCombination ,'0 PL +','')
         WHERE LeaveTypeID =2

         UPDATE #Temp 
         SET LeaveCombination = Replace (LeaveCombination ,'0 COFF +','')
         WHERE LeaveTypeID =4

		 UPDATE #Temp 
         SET LeaveCombination = Replace (LeaveCombination ,'0 ML +','')
         WHERE LeaveTypeID =6

		 UPDATE #Temp 
         SET LeaveCombination = Replace (LeaveCombination ,'0 PL(M) +','')
         WHERE LeaveTypeID =6

         SELECT DISTINCT LTRIM(RTRIM(LeaveCombination)) AS LeaveCombination
         FROM #Temp GROUP BY LeaveCombination,Userid
     END 
GO
/****** Object:  StoredProcedure [dbo].[spGetLeaveBalanceForUser]    Script Date: 31-10-2018 17:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetLeaveBalanceForUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGetLeaveBalanceForUser] AS' 
END
GO
/***
   Created Date      :     2015-12-24
   Created By        :     Nishant Srivastava
   Purpose           :     This stored procedure return leave balance based on userId
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   13-May-2017		Sudhanshu Shekhar	  Auto Calculate FY Start/End date, LNSA date filter correction, Old/New PL implementation
   28-Nov-2017		Sudhanshu Shekhar	  Old and New PL canculation
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   EXEC [dbo].[spGetLeaveBalanceForUser] @UserId = 84
***/
ALTER PROCEDURE [dbo].[spGetLeaveBalanceForUser] 
(
   @UserId INT
)
AS
BEGIN
   SET NOCOUNT ON;
   SET FMTONLY OFF;    

   DECLARE @NewPLStartDate DATE= '01 Jun 2017', @MaxPLCutOff INT =20;

   IF OBJECT_ID('tempdb..#TempLeaveCount') IS NOT NULL
   DROP TABLE #TempLeaveCount

   DECLARE @FYStartDate DATE = '01 Apr '+cast(YEAR(DATEADD(Month,-((DATEPART(Month,GETDATE())+8) %12),GETDATE())) AS VARCHAR(4)) --'20170401'
         ,@FYEndDate DATE = '31 Mar '+cast(YEAR(DATEADD(Month,-((DATEPART(Month,GETDATE())+8) %12),GETDATE()))+1 AS VARCHAR(4)) --'20180331'
         ,@QStartDate DATE = CAST (DATEADD(q, DATEDIFF(q, 0, GETDATE()), 0) AS [Date])
         ,@QEndDate DATE = CAST (DATEADD(d, -1, DATEADD(q, DATEDIFF(q, 0, GETDATE()) + 1, 0)) AS [Date])
   
   CREATE TABLE #TempLeaveCount(
       [LeaveType] varchar(10)
      ,[LeaveCount] float
   )

   INSERT INTO #TempLeaveCount
   SELECT LT.[ShortName] AS [LeaveType]
         ,LB.[Count] AS [LeaveCount]
   FROM [LeaveBalance] LB WITH (NOLOCK)
   INNER JOIN [dbo].[LeaveTypeMaster]  LT WITH (NOLOCK) ON LB.[LeaveTypeId] = LT.[TypeId]
   WHERE LB.[UserId] = @UserId AND LT.[ShortName] IN ('CL', 'PL', 'LWP', 'COFF','ML','PL(M)', '5CLOY')
   
   --WFH-------------
   INSERT INTO #TempLeaveCount
   SELECT 'WFH', ISNULL(AP.[Approved],0)
   FROM [dbo].[UserDetail] U WITH (NOLOCK)		
   LEFT JOIN
         (
            SELECT L.[UserId]         
				   ,SUM(LD.[Count]) AS [Approved]
            FROM [dbo].[LeaveRequestApplication] L WITH (NOLOCK)
            INNER JOIN [dbo].[LeaveRequestApplicationDetail] LD WITH (NOLOCK) ON LD.[LeaveRequestApplicationId] = L.[LeaveRequestApplicationId]
            INNER JOIN (
                        SELECT [LeaveRequestApplicationId] AS [LeaveRequestApplicationId]
							   ,Count(*) AS [TotalIncludingDays]
                        FROM [dbo].[DateWiseLeaveType] T WITH (NOLOCK)
                        INNER JOIN [dbo].[DateMaster] D WITH (NOLOCK) ON T.[DateId] = D.[DateId]
                        WHERE D.[Date] BETWEEN @FYStartDate AND @FYEndDate
                        GROUP BY [LeaveRequestApplicationId]
                        ) D
                        ON D.[LeaveRequestApplicationId] = L.[LeaveRequestApplicationId]
             INNER JOIN [dbo].[LeaveTypeMaster] LT WITH (NOLOCK) ON LT.[TypeId] = LD.[LeaveTypeId]      
            WHERE L.[LeaveCombination] IS NULL 
               AND LT.[ShortName] = 'WFH'
               AND L.[StatusId] > 2
            GROUP BY L.[UserId]
	      ) AP ON U.[UserId] = AP.[UserId]
      WHERE U.[UserId] = @UserId

   --LNSA-------------
  
   INSERT INTO #TempLeaveCount
   SELECT 
		'LNSA'
		,ISNULL(AP.[Approved], 0)
   FROM [dbo].[UserDetail] U WITH (NOLOCK)		
   LEFT JOIN 
		 (
			SELECT 
				 COUNT(D.IsApprovedBySystem ) AS [Approved]
				,R.[CreatedBy]				  AS [UserId]
			FROM [dbo].[DateWiseLNSA] D
			INNER JOIN [dbo].[RequestLNSA] R ON R.[RequestId]=D.[RequestId] 
			INNER JOIN [dbo].[DateMaster] DM ON DM.[DateId]=D.[DateId]
			WHERE  D.[IsApprovedBySystem]=1
			AND DM.[Date] BETWEEN @QStartDate AND @QEndDate
			GROUP BY R.[CreatedBy]			
		  ) AP 
	ON U.[UserId] = AP.[UserId]
    WHERE U.[UserId] = @UserId
   
   PRINT 'OK'
   DECLARE  @OldPL FLOAT = 0
			,@NewPL FLOAT = 0
   
   SELECT @OldPL = OldPL
		 ,@NewPL = NewPL FROM [dbo].[Fun_GetOldAndNewPLByUser](@UserId)

   INSERT INTO #TempLeaveCount
   VALUES ('OLDPL', @OldPL)
		 ,('NEWPL', @NewPL);
   ----------------------------
   SELECT * FROM #TempLeaveCount
END
GO
