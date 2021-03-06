
/****** Object:  StoredProcedure [dbo].[Proc_SubmitUserQuarterlyAchievement]    Script Date: 03-04-2019 17:07:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SubmitUserQuarterlyAchievement]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SubmitUserQuarterlyAchievement]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetPunchInOutLog]    Script Date: 03-04-2019 17:07:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetPunchInOutLog]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetPunchInOutLog]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_GetCurrentAppraisalCycle]    Script Date: 03-04-2019 17:07:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetCurrentAppraisalCycle]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GetCurrentAppraisalCycle]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_FetchNthLevelManagerByUserId]    Script Date: 03-04-2019 17:07:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_FetchNthLevelManagerByUserId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_FetchNthLevelManagerByUserId]
GO
/****** Object:  UserDefinedFunction [dbo].[fnGetSecondReportingManagerByUserId]    Script Date: 03-04-2019 17:07:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnGetSecondReportingManagerByUserId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fnGetSecondReportingManagerByUserId]
GO
/****** Object:  UserDefinedFunction [dbo].[fnGetReportingManagerByUserId]    Script Date: 03-04-2019 17:07:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnGetReportingManagerByUserId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fnGetReportingManagerByUserId]
GO
/****** Object:  UserDefinedFunction [dbo].[fnGetDepartmentHeadIdByUserId]    Script Date: 03-04-2019 17:07:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnGetDepartmentHeadIdByUserId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fnGetDepartmentHeadIdByUserId]
GO
/****** Object:  UserDefinedFunction [dbo].[fnGetDepartmentHeadIdByUserId]    Script Date: 03-04-2019 17:07:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnGetDepartmentHeadIdByUserId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/***
   Created Date      :     27-01-2017
   Created By        :     Shubhra Upadhyay
   Purpose           :     To get departmentHeadId for particular userId
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   27-01-2017		Sudhanshu Shekhar	Removed DepartmentId reference from UserDetail and referenced with Team
   --------------------------------------------------------------------------
   18-Feb-2019       Kanchan Kumari     First take DepartmentHeadId, if not in(4, 2203, 2167)
                                        then take DivisionHeadId
  ---------------------------------------------------------------------------
   3-Apr-2019       Kanchan Kumari       Survey2Connect user''s request should not go to AP for approval

   Test Cases        :
   --------------------------------------------------------------------------   
   --- Test Case 1
   SELECT [dbo].[fnGetDepartmentHeadIdByUserId](2139)
   --- Test Case 2
   SELECT [dbo].[fnGetDepartmentHeadIdByUserId](64)
***/
CREATE FUNCTION [dbo].[fnGetDepartmentHeadIdByUserId]
(   
  @UserId int
)
RETURNS int
AS
BEGIN 
   DECLARE @DepartmentHeadId bigint, @DivisionHeadId bigint, @NewDivisionHeadId bigint, @IsS2CUser BIT = 0;

   IF EXISTS(SELECT 1 FROM vwAllUsers WHERE UserId = @UserId AND Team = ''Survey2Connect'') 
   BEGIN
       SET @IsS2CUser = 1;
   END

   DECLARE @RMId int = (SELECT [dbo].[fnGetReportingManagerByUserId](@UserId))
   DECLARE @SRMId int = (SELECT [dbo].[fnGetSecondReportingManagerByUserId](@UserId))
   IF (@RMId > 0 AND @RMId NOT IN (3, 4, 2203, 2167) AND @SRMId > 0 AND @SRMId NOT IN (3, 4, 2203, 2167))
   BEGIN
        SET @DepartmentHeadId = ISNULL( 
		                        (SELECT Top(1) D.[DepartmentHeadId] 
                                FROM [dbo].[UserTeamMapping] UTM WITH (NOLOCK)
								INNER JOIN [dbo].[Team] T WITH (NOLOCK) ON UTM.[TeamId] = T.[TeamId]
								INNER JOIN [dbo].[Department] D WITH (NOLOCK) ON T.[DepartmentId] = D.[DepartmentId]
								WHERE UTM.[UserId] = @UserId 
                                AND D.[DepartmentHeadId] != @UserId), 0)

		SET @DivisionHeadId = ISNULL( 
		                      (SELECT Top(1) DV.[DivisionHeadId]
							   FROM [dbo].[UserTeamMapping] UTM WITH (NOLOCK)
							   INNER JOIN [dbo].[Team] T WITH (NOLOCK) ON UTM.[TeamId] = T.[TeamId]
							   INNER JOIN [dbo].[Department] D WITH (NOLOCK) ON T.[DepartmentId] = D.[DepartmentId]
							   INNER JOIN [dbo].[Division] DV WITH (NOLOCK) ON D.[DivisionId] = DV.[DivisionId]
							   WHERE UTM.[UserId] = @UserId AND DV.[DivisionHeadId]!= @UserId ), 0) 
                                     

      SELECT @NewDivisionHeadId = CASE WHEN @DepartmentHeadId IN (4, 2203, 2167) THEN @DepartmentHeadId
	                                   ELSE @DivisionHeadId 
									   END 

		IF(@NewDivisionHeadId = 3 OR (@NewDivisionHeadId = 2167 AND @IsS2CUser = 1))-- 3-VM, 2167 -AP
		BEGIN
		SET @NewDivisionHeadId = 0
		END
   END
   ELSE
   BEGIN
      SET @NewDivisionHeadId = 0
   END
   RETURN @NewDivisionHeadId
END' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[fnGetReportingManagerByUserId]    Script Date: 03-04-2019 17:07:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnGetReportingManagerByUserId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
/***
   Created Date      :     27-01-2017
   Created By        :     Shubhra Upadhyay
   Purpose           :     To get reporting manager for userId
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   3-Apr-2019       Kanchan Kumari       Survey2Connect user''s request should not go to AP for approval
   --------------------------------------------------------------------------

   Test Cases        :
   --------------------------------------------------------------------------   
   --- Test Case 1
   SELECT [dbo].[fnGetReportingManagerByUserId](2309)

   --- Test Case 2
   SELECT [dbo].[fnGetReportingManagerByUserId](4)

   --- Test Case 3
   SELECT [dbo].[fnGetReportingManagerByUserId](22)

***/

CREATE FUNCTION [dbo].[fnGetReportingManagerByUserId]
(   
     @UserId int
)
RETURNS int
AS
BEGIN 
   DECLARE @RMId int, @IsS2CUser BIT = 0;

   IF EXISTS(SELECT 1 FROM vwAllUsers WHERE UserId = @UserId AND Team = ''Survey2Connect'') 
   BEGIN
       SET @IsS2CUser = 1;
   END

   IF EXISTS(
            SELECT 1
            FROM [dbo].[UserDetail] U WITH (NOLOCK)
               INNER JOIN [dbo].[UserDetail] UD WITH (NOLOCK)
                  ON U.[UserId] = UD.[ReportTo]
            WHERE
               UD.[UserId] = @UserId
               AND U.[UserId] > 0 
               AND UD.[UserId] > 0              
            )
   BEGIN
      SET @RMId = (SELECT CASE WHEN UD.ReportTo=3 OR (UD.ReportTo = 2167 AND @IsS2CUser = 1) -- 3-VM, 2167 -AP
	                           THEN 0 ELSE U.[UserId] END AS [UserId]--- VM id should not be there as reporting manager id
                       FROM [dbo].[UserDetail] U WITH (NOLOCK)
                           INNER JOIN [dbo].[UserDetail] UD WITH (NOLOCK)
                              ON U.[UserId] = UD.[ReportTo]
                       WHERE
                           UD.[UserId] = @UserId
                           AND U.[UserId] > 0 
                           AND UD.[UserId] > 0
                       )
   END      
   ELSE
   BEGIN
      SET @RMId = 0
   END
   
   RETURN @RMId
END


' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[fnGetSecondReportingManagerByUserId]    Script Date: 03-04-2019 17:07:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnGetSecondReportingManagerByUserId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
/***
   Created Date      :     27-01-2017
   Created By        :     Shubhra Upadhyay
   Purpose           :     To get reporting manager of reporting manager for userId
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
     3-Apr-2019       Kanchan Kumari       Survey2Connect user''s request should not go to AP for approval
   --------------------------------------------------------------------------

   Test Cases        :
   --------------------------------------------------------------------------   
   --- Test Case 1
   SELECT [dbo].[fnGetSecondReportingManagerByUserId](2206)

   --- Test Case 2
   SELECT [dbo].[fnGetSecondReportingManagerByUserId](4)

  SELECT V.UserId FROM vwAllUsers V JOIN vwAllUsers R ON V.RMId = R.UserId
  where V.Team = ''Survey2Connect'' AND R.RMId = 2167

***/

CREATE FUNCTION [dbo].[fnGetSecondReportingManagerByUserId]
(   
     @UserId int
)
RETURNS int
AS
BEGIN 
   DECLARE @ResultId int, @IsS2CUser BIT = 0;

   IF EXISTS(SELECT 1 FROM vwAllUsers WHERE UserId = @UserId AND Team = ''Survey2Connect'') 
   BEGIN
       SET @IsS2CUser = 1;
   END

   IF EXISTS(
            SELECT 1
            FROM [dbo].[UserDetail] U WITH (NOLOCK)
               INNER JOIN [dbo].[UserDetail] UD WITH (NOLOCK)
                  ON U.[UserId] = UD.[ReportTo]
               INNER JOIN [dbo].[UserDetail] UD1 WITH (NOLOCK)
                  ON UD.[UserId] = UD1.[ReportTo]
            WHERE
               UD1.[UserId] = @UserId
               AND U.[UserId] > 0 
               AND UD.[UserId] > 0
               AND (SELECT [dbo].[fnGetReportingManagerByUserId](@UserId)) NOT IN (3, 4, 2203, 2167)
            )
   BEGIN
      SET @ResultId = (SELECT CASE WHEN  U.UserId = 3 OR (U.UserId = 2167 AND @IsS2CUser = 1) THEN 0 -- 3-VM, 2167 -AP
	                               ELSE U.[UserId] END AS UserId---VM should not be the 2nd rm
                       FROM [dbo].[UserDetail] U WITH (NOLOCK)
                           INNER JOIN [dbo].[UserDetail] UD WITH (NOLOCK)
                              ON U.[UserId] = UD.[ReportTo]
                           INNER JOIN [dbo].[UserDetail] UD1 WITH (NOLOCK)
                              ON UD.[UserId] = UD1.[ReportTo]
                       WHERE
                           UD1.[UserId] = @UserId
                           AND U.[UserId] > 0 
                           AND UD.[UserId] > 0
                       )
   END      
   ELSE
   BEGIN
      SET @ResultId = 0
   END
   
   RETURN @ResultId
END


' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[Fun_FetchNthLevelManagerByUserId]    Script Date: 03-04-2019 17:07:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_FetchNthLevelManagerByUserId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/***
   Created Date : 25-March-2019
   Created By   : Kanchan Kumari
   Purpose      : To get RM1, RM2, DivHeadId and HRId for all users or individual user
   
   Test Cases   : SELECT * FROM [Fun_FetchNthLevelManagerByUserId](2206)
   --------------------------------------------------------------------------   
***/
CREATE Function [dbo].[Fun_FetchNthLevelManagerByUserId]
(   
     @UserId int = null
)
RETURNS @TempUserData TABLE(
        [UserId] BIGINT,
		[IsS2CUser] BIT,
		[RM1] INT,
		[RM2] INT,
		[DeptHD] INT NOT NULL DEFAULT(0),
		[FinalDeptHDId] INT NOT NULL DEFAULT(0), 
		[HRId] INT)
AS
BEGIN 
		DECLARE @TempDeptHead TABLE
		(
		[UserId] INT,
		[DeptHeadId] INT NOT NULL DEFAULT(0),
		[DivHeadId] INT NOT NULL DEFAULT(0)
		)

      INSERT INTO @TempUserData([UserId], [IsS2CUser])
      SELECT UserId, CASE WHEN Team = ''Survey2Connect'' THEN 1 ELSE 0 END
	  FROM [vwAllUsers] WHERE UserId <> 1 AND (UserId = @UserId OR @UserId IS NULL)

	  UPDATE T SET T.[RM1] = CASE WHEN U.ReportTo IS NULL OR U.ReportTo = 3 OR (U.ReportTo = 2167 AND T.[IsS2CUser] = 1) THEN  0
	                              ELSE U.ReportTo 
							 END
	  FROM @TempUserData T LEFT JOIN [UserDetail] U 
	  ON T.UserId = U.UserId 

	  UPDATE T SET T.[RM2] = CASE WHEN T.RM1 IN (0, 3, 4, 2203, 2167) OR U.ReportTo IS NULL 
	                                            OR (U.ReportTo = 2167 AND T.[IsS2CUser] = 1)  THEN  0 
	                              ELSE U.ReportTo
							 END
	  FROM @TempUserData T LEFT JOIN [UserDetail] U 
	  ON T.RM1 = U.UserId

	    DECLARE @HRId bigint = 0
        SELECT TOP 1 @HRId = U.UserId 
					FROM [dbo].[User] U 
					INNER JOIN dbo.UserDetail UD WITH (NOLOCK) ON U.UserId=UD.UserId 
					WHERE U.IsActive=1 AND UD.FirstName + UD.LastName =''PriyankaGubrele''

		 IF(@HRId=0)
		 SELECT TOP 1 @HRId = U.UserId 
						FROM [dbo].[User] U 
						INNER JOIN [dbo].[UserDetail] UD WITH (NOLOCK) ON U.UserId=UD.UserId
						INNER JOIN [dbo].[Designation] D WITH (NOLOCK) ON UD.[DesignationId]=D.[DesignationId]
						INNER JOIN [dbo].[DesignationGroup] DG WITH (NOLOCK) ON D.[DesignationGroupId]=DG.[DesignationGroupId]
						WHERE U.IsActive=1 AND DG.[DesignationGroupId] = 5 --Human Resource
						ORDER BY D.DesignationId DESC

         UPDATE @TempUserData SET [HRId] = @HRId
	 

		INSERT INTO @TempDeptHead([UserId], [DeptHeadId], [DivHeadId])
		SELECT UD.UserId, ISNULL( D.[DepartmentHeadId] , 0) AS [DeptHeadId], 
		ISNULL( DV.[DivisionHeadId] , 0) AS [DivHeadId]
		FROM @TempUserData UD
		LEFT JOIN [dbo].[UserTeamMapping] UTM WITH (NOLOCK) ON UD.UserId = UTM.UserId AND UTM.IsActive = 1
		LEFT JOIN [dbo].[Team] T WITH (NOLOCK) ON UTM.[TeamId] = T.[TeamId]
		LEFT JOIN [dbo].[Department] D WITH (NOLOCK) ON T.[DepartmentId] = D.[DepartmentId]
		LEFT JOIN [dbo].[Division] DV WITH (NOLOCK) ON D.[DivisionId] = DV.[DivisionId]
		WHERE D.[DepartmentHeadId] != UTM.UserId AND DV.[DivisionHeadId]!=  UTM.UserId
		GROUP BY UD.UserId, D.[DepartmentHeadId], DV.[DivisionHeadId] 

      UPDATE T SET T.[DeptHD] = CASE WHEN D.[DeptHeadId] IN (4, 2203, 2167) THEN D.[DeptHeadId] ELSE D.[DivHeadId] END 
	  FROM @TempUserData T INNER JOIN @TempDeptHead D 
	  ON T.UserId = D.UserId

	  UPDATE T SET T.[FinalDeptHDId] = CASE WHEN T.[DeptHD] = 2167 AND T.IsS2CUser = 1 THEN 0
	                                        WHEN RM1 > 0 AND RM2 > 0 AND RM1 NOT IN (3, 4, 2203, 2167) 
	                                        AND RM2 NOT IN (3, 4, 2203, 2167) THEN T.[DeptHD] 
										    ELSE 0 
									   END 
	  FROM @TempUserData T 

	  RETURN
END' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[Fun_GetCurrentAppraisalCycle]    Script Date: 03-04-2019 17:07:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetCurrentAppraisalCycle]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N' /*
 Author      :	Sudhanshu Shekhar
 Create date :  22-Mar-2018
 Description :	To get current appraisal cycle
 Usage       :  SELECT * FROM [dbo].[Fun_GetCurrentAppraisalCycle]()
 Change History:
 --------------------------------------------------------------------------
 Modify Date       Edited By            Change Description
 --------------------------------------------------------------------------
 8-Jan-2019        kanchan kumari       Changed the logic to get current appraisal 
                                        cycle id and financial year
 --------------------------------------------------------------------------
 4-Feb-2019        kanchan kumari       get current quarter number, qtrstartdate, qtrenddate 

*/
CREATE FUNCTION [dbo].[Fun_GetCurrentAppraisalCycle]()
RETURNS @AppraisalCycleDetails TABLE (
		AppraisalCycleId INT NOT NULL,
		CountryId INT NOT NULL,
		AppraisalCycleName VARCHAR(40) NOT NULL,
		AppraisalMonth INT NOT NULL,
		AppraisalYear INT NOT NULL,
		AppraisalStartDate DATE NOT NULL,
		AppraisalEndDate DATE NOT NULL,
		GoalCycleId INT NOT NULL,
		FYStartDate DATE NOT NULL,
		FYEndDate DATE NOT NULL,
		CurrentQuarter INT NOT NULL,
		CQStartDate DATE NOT NULL,
		CQEndDate DATE NOT NULL
)
AS
BEGIN
    DECLARE @CurrentDate DATE = GETDATE(), @FYStartDate DATE, @FYEndDate DATE 
    DECLARE @SYear INT, @EYear INT, @CurrMonth INT  
	IF(DATEPART(m,@CurrentDate) < 4)
	BEGIN 
		SET @SYear = DATEPART(yyyy, DATEADD(yyyy,-1, @CurrentDate))
		SET @EYear = DATEPART(yyyy, @CurrentDate)
	END
	ELSE
	BEGIN
		SET @SYear = DATEPART(yyyy, @CurrentDate)
		SET @EYear = DATEPART(yyyy, DATEADD(yyyy, 1, @CurrentDate))
	END
	SELECT @FYStartDate = DATEFROMPARTS(@SYear,04,1)
	SELECT @FYEndDate = DATEFROMPARTS(@EYear,03,31)

	INSERT INTO @AppraisalCycleDetails(AppraisalCycleId, CountryId, AppraisalCycleName, AppraisalMonth, AppraisalYear, 
				AppraisalStartDate, AppraisalEndDate, GoalCycleId, FYStartDate, FYEndDate, CurrentQuarter, CQStartDate, CQEndDate)

    SELECT T.AppraisalCycleId, T.CountryId, T.AppraisalCycleName, T.AppraisalMonth, T.AppraisalYear,
	            DATEFROMPARTS(AppraisalYear-1, 04, 01) AS AppraisalStartDate,
			    DATEFROMPARTS(AppraisalYear, 03, 31) AS AppraisalEndDate, 
			    T.AppraisalCycleId+1 AS GoalCycleId, 
				A.AprlStartDate, A.AprlEndDate,
				CASE WHEN @CurrentDate BETWEEN Qtr1StartDate AND Qtr1EndDate THEN 1   
				     WHEN @CurrentDate BETWEEN Qtr2StartDate AND Qtr2EndDate THEN 2   
					 WHEN @CurrentDate BETWEEN Qtr3StartDate AND Qtr3EndDate THEN 3 
					 WHEN @CurrentDate BETWEEN Qtr4StartDate AND Qtr4EndDate THEN 4 
				END AS CurrentQuarter,
				CASE WHEN @CurrentDate BETWEEN Qtr1StartDate AND Qtr1EndDate THEN Qtr1StartDate 
				     WHEN @CurrentDate BETWEEN Qtr2StartDate AND Qtr2EndDate THEN Qtr2StartDate 
					 WHEN @CurrentDate BETWEEN Qtr3StartDate AND Qtr3EndDate THEN Qtr3StartDate
					 WHEN @CurrentDate BETWEEN Qtr4StartDate AND Qtr4EndDate THEN Qtr4StartDate 
				END AS CQStartDate,
				CASE WHEN @CurrentDate BETWEEN Qtr1StartDate AND Qtr1EndDate THEN Qtr1EndDate  
				     WHEN @CurrentDate BETWEEN Qtr2StartDate AND Qtr2EndDate THEN Qtr2EndDate  
					 WHEN @CurrentDate BETWEEN Qtr3StartDate AND Qtr3EndDate THEN Qtr3EndDate
					 WHEN @CurrentDate BETWEEN Qtr4StartDate AND Qtr4EndDate THEN Qtr4EndDate 
				END AS CQEndDate	     
			   FROM AppraisalCycle T
		       JOIN
			    ( SELECT AppraisalCycleId, 
			      DATEFROMPARTS(AppraisalYear, 04, 01) AS AprlStartDate,
		          DATEFROMPARTS(AppraisalYear+1, 03, 31) AS AprlEndDate,
				  DATEFROMPARTS(AppraisalYear, 04, 01) AS Qtr1StartDate,
				  DATEFROMPARTS(AppraisalYear, 06, 30) AS Qtr1EndDate,
				  DATEFROMPARTS(AppraisalYear, 07, 01) AS Qtr2StartDate,
				  DATEFROMPARTS(AppraisalYear, 09, 30) AS Qtr2EndDate,
				  DATEFROMPARTS(AppraisalYear, 10, 01) AS Qtr3StartDate,
				  DATEFROMPARTS(AppraisalYear, 12, 31) AS Qtr3EndDate,
				  DATEFROMPARTS(AppraisalYear+1, 01, 01) AS Qtr4StartDate,
				  DATEFROMPARTS(AppraisalYear+1, 03, 31) AS Qtr4EndDate
				  FROM AppraisalCycle
				) A
			   ON T.AppraisalCycleId = A.AppraisalCycleId AND A.AprlEndDate = @FYEndDate 
	RETURN 
END' 
END

GO
/****** Object:  StoredProcedure [dbo].[Proc_GetPunchInOutLog]    Script Date: 03-04-2019 17:07:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetPunchInOutLog]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetPunchInOutLog] AS' 
END
GO
/*
 Author	     : Sudhanshu Shekhar
 Create date : 7-Oct-2017
 Description :To get door's punch In or out log for Prev, Current & Next day
 Usage       : EXEC [Proc_GetPunchInOutLog] 3, '14 Mar 2018'

 Change History:
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   1-Apr-2019        Kanchan Kumari       Fetched TempCard logs as well
   --------------------------------------------------------------------------
*/
ALTER PROC [dbo].[Proc_GetPunchInOutLog]
(
	@UserId INT,
	@AttendanceDate varchar(20)
)
AS
BEGIN
    SET FMTONLY OFF;
	IF OBJECT_ID('tempdb..#TempCardPunchTime') IS NOT NULL
	DROP TABLE #TempCardPunchTime

	IF OBJECT_ID('tempdb..#TempCard') IS NOT NULL
	DROP TABLE #TempCard

     CREATE TABLE #TempCardPunchTime
	 (
	 PunchTime	VARCHAR(20) NOT NULL,
	 DoorPoint	VARCHAR(50) NOT NULL,
	 Day VARCHAR(5) NOT NULL,
	 IsTemp BIT NOT NULL,
	 CardType VARCHAR(5) NOT NULL,
	 CardDetails VARCHAR(1000) NULL
	 )

	 CREATE TABLE #TempCard
	 (
	 AccessCardNo VARCHAR(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	 IssueTime	DATETIME NOT NULL,
	 ReturnTime DATETIME NOT NULL,
	 CardDetails VARCHAR(1000)
	 )

	DECLARE @AccessCardNo VARCHAR(20), @PermanentCardDetails VARCHAR(500);
	

	--permanent card details 
	SELECT TOP 1 @AccessCardNo = REPLACE(LTRIM(REPLACE(A.[AccessCardNo],'0',' ')),' ','0'),
	@PermanentCardDetails = 'AccessCardNo: '+ A.[AccessCardNo]+'\n' + 'CardType: Permanent'+'\n' + 'IssueDate: '+ CONVERT(VARCHAR(11),UA.[AssignedFromdate], 106) +'\n' +  'ReturnDate: '+   CASE WHEN UA.[AssignedTillDate] IS NULL THEN 'NA' 
	       ELSE CONVERT(VARCHAR(11), UA.[AssignedTillDate], 106) 
		   END 
	FROM UserAccessCard UA WITH (NOLOCK)
	JOIN AccessCard A WITH (NOLOCK) ON UA.AccessCardId = A.AccessCardId
	WHERE UserId= @UserId AND @AttendanceDate BETWEEN UA.[AssignedFromdate] AND ISNULL(UA.[AssignedTillDate], GETDATE())

	--temp card details 
	INSERT INTO #TempCard(AccessCardNo, IssueTime, ReturnTime, CardDetails)
	SELECT AC.AccessCardNo, T.IssueDate, ISNULL(T.ReturnDate, GETDATE()),
		  'AccessCardNo: '+ AC.[AccessCardNo]+'\n' + 'CardType: Temp'+'\n' + 'IssueDate: '+  CONVERT(VARCHAR(11),T.IssueDate, 106)+' '+ FORMAT(T.IssueDate,'hh:mm tt') +'\n' +  'ReturnDate: '+    CASE WHEN T.ReturnDate  IS NULL THEN 'NA' 
	       ELSE CONVERT(VARCHAR(11), T.ReturnDate , 106)+' '+ FORMAT(T.ReturnDate,'hh:mm tt')
		   END
    FROM [TempCardIssueDetail] T
	JOIN AccessCard AC WITH (NOLOCK) ON T.AccessCardId = AC.AccessCardId 
	WHERE T.EmployeeId = @UserId 
	AND @AttendanceDate BETWEEN CAST(T.IssueDate AS DATE) AND CAST( ISNULL(T.ReturnDate, GETDATE()) AS DATE) 
	AND T.IsActive = 1
	
	--insert permanentcard punch time detail
	INSERT INTO #TempCardPunchTime(PunchTime, DoorPoint, [Day], IsTemp, CardType)
	SELECT CONVERT(VARCHAR(11), AML.[time], 106) + ' ' + RIGHT(CONVERT(VARCHAR, AML.[time], 100), 7) AS [PunchTime],
		AML.[state_name] AS [DoorPoint], 
		CASE 
			WHEN CAST(AML.[time] AS DATE) = DATEADD(D,-1,CAST(@AttendanceDate AS DATE)) THEN 'P' --Previous
			WHEN CAST(AML.[time] AS DATE) = CAST(@AttendanceDate AS DATE) THEN 'C'				 --Current
			WHEN CAST(AML.[time] AS DATE) = DATEADD(D,+1,CAST(@AttendanceDate AS DATE)) THEN 'N' --Next
			ELSE ''
		 END AS [Day]
		 , CAST(0 AS BIT)
		 ,'P'
	FROM dbo.acc_monitor_log AML WITH (NOLOCK)
	WHERE REPLACE(LTRIM(REPLACE(AML.[pin],'0',' ')),' ','0') = @AccessCardNo 
	AND CAST(AML.[time] AS DATE) BETWEEN DATEADD(D,-1,CAST(@AttendanceDate AS DATE)) AND DATEADD(D,+1,CAST(@AttendanceDate AS DATE))
	ORDER BY AML.[time]

	--insert temp card punch detail
	INSERT INTO #TempCardPunchTime(PunchTime, DoorPoint, [Day], IsTemp, CardType, CardDetails)
	SELECT CONVERT(VARCHAR(11), AML.[time], 106) + ' ' + RIGHT(CONVERT(VARCHAR, AML.[time], 100), 7) AS [PunchTime],
		AML.[state_name] AS [DoorPoint], 
		CASE 
			WHEN CAST(AML.[time] AS DATE) = DATEADD(D,-1,CAST(@AttendanceDate AS DATE)) THEN 'P' --Previous
			WHEN CAST(AML.[time] AS DATE) = CAST(@AttendanceDate AS DATE) THEN 'C'				 --Current
			WHEN CAST(AML.[time] AS DATE) = DATEADD(D,+1,CAST(@AttendanceDate AS DATE)) THEN 'N' --Next
			ELSE ''
		 END AS [Day]
		 , CAST(1 AS BIT)
		 ,'T'
		 ,T.CardDetails
	FROM dbo.acc_monitor_log AML WITH (NOLOCK) 
	JOIN #TempCard T 
	ON REPLACE(LTRIM(REPLACE(AML.[pin],'0',' ')),' ','0') =  REPLACE(LTRIM(REPLACE(T.[AccessCardNo],'0',' ')),' ','0') 
	AND AML.[time] BETWEEN T.IssueTime AND T.ReturnTime
	GROUP BY  AML.[time], AML.[state_name], T.[AccessCardNo],T.CardDetails, T.IssueTime, T.ReturnTime
	ORDER BY AML.[time]

	SELECT PunchTime, DoorPoint, [Day], IsTemp, CardType,
	   CASE WHEN CardType = 'P' THEN  @PermanentCardDetails
	        ELSE CardDetails
       END AS CardDetails
  FROM #TempCardPunchTime
END
GO
/****** Object:  StoredProcedure [dbo].[Proc_SubmitUserQuarterlyAchievement]    Script Date: 03-04-2019 17:07:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SubmitUserQuarterlyAchievement]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_SubmitUserQuarterlyAchievement] AS' 
END
GO
/***
   Created Date      :     2019-02-05
   Created By        :     Mimansa Agrawal
   Purpose           :    To submit User quarterly pimco Achievement 
   Change History:
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   3-Apr-2019        Kanchan Kumari       Checked if achievement already exists for
                                          the given input parameter
   --------------------------------------------------------------------------
   -----------------------------------------------------------------------
    DECLARE @Result tinyint
         EXEC [dbo].[Proc_SubmitUserQuarterlyAchievement]
            @UserId = 2432
		   ,@Year = 2018
		   ,@QNumber = 1
		   ,@Comments = 'abcd'
           ,@AchievementXmlString ='<Root> <Row Achievement="test" Purpose="test" />
		                                   <Row Achievement="test" Purpose="test"></Row>
			                        </Root>'
		   ,@Success = @Result out
           SELECT @Result AS Result
***/
ALTER PROC [dbo].[Proc_SubmitUserQuarterlyAchievement]
(
 @UserId INT,
 @Year INT,
 @QNumber INT,
 @Comments VARCHAR(500),
 @AchievementXmlString xml,
 @Success tinyint=0 output
)
AS
BEGIN TRY
    SET NOCOUNT ON;
  BEGIN TRANSACTION
	DECLARE @QStartDate DATE,@QEndDate DATE,@DetailId INT
	SET @QStartDate = (SELECT QStartDate FROM [dbo].[Fun_GetQuartersForFY](@Year) WHERE QNumber=@QNumber)
	SET @QEndDate = (SELECT QEndDate FROM [dbo].[Fun_GetQuartersForFY](@Year) WHERE QNumber=@QNumber)
           IF OBJECT_ID('tempdb..##TempAchievement') IS NOT NULL
           DROP TABLE #TempAchievement

		   CREATE TABLE #TempAchievement([Achievement] VARCHAR(500),[Purpose] VARCHAR(500))
           INSERT INTO #TempAchievement
		   SELECT T.Item.value('@Achievement','VARCHAR(500)'),
			      T.Item.value('@Purpose', 'varchar(500)')
		   FROM @AchievementXmlString.nodes('/Root/Row')AS T(Item)

    IF EXISTS(SELECT 1 FROM [PimcoAchievement] WHERE UserId = @UserId AND FYStartYear = @Year AND QuarterNo = @QNumber)
	BEGIN
	     SET @Success = 2; --already submitted
	END
	ELSE
	BEGIN
		INSERT INTO [dbo].[PimcoAchievement](UserId, FYStartYear, QuarterNo, QuarterStartDate, QuarterEndDate, EmpComments, CreatedBy)
		SELECT @UserId, @Year, @QNumber, @QStartDate, @QEndDate, @Comments, @UserId 
 
		SET @DetailId = SCOPE_IDENTITY()
 
		INSERT INTO [dbo].[PimcoAchievementDetail](PimcoAchievementId, Achievement, Purpose,CreatedBy)
		SELECT @DetailId, [Achievement], [Purpose], @UserId FROM #TempAchievement
		SET @Success = 1; -- submitted successfully
	END
 COMMIT;
END TRY
BEGIN CATCH
	SET @Success = 0; -- Error Occured
    IF(@@TRANCOUNT>0)
    ROLLBACK TRANSACTION;

    DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
--Log Error
    EXEC [spInsertErrorLog]
    @ModuleName = 'PimcoAchievement'
    ,@Source = 'Proc_SubmitUserQuarterlyAchievement'
    ,@ErrorMessage = @ErrorMessage
    ,@ErrorType = 'SP'
    ,@ReportedByUserId = @UserId
END CATCH 
GO
