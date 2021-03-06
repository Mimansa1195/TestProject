/****** Object:  StoredProcedure [dbo].[Proc_GetReimbursementListToReview]    Script Date: 05-10-2018 10:57:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetReimbursementListToReview]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetReimbursementListToReview]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetReimbursementList]    Script Date: 05-10-2018 10:57:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetReimbursementList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetReimbursementList]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_GetReimbursementMonthYearToViewAndApprove]    Script Date: 05-10-2018 10:57:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetReimbursementMonthYearToViewAndApprove]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GetReimbursementMonthYearToViewAndApprove]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_GetReimbursementMonthYearToViewAndApprove]    Script Date: 05-10-2018 10:57:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetReimbursementMonthYearToViewAndApprove]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author	  : Kanchan Kumari
-- Create date: 6-Sept-2018
-- Description:	To get month year for Manager
-- Usage	  : SELECT * FROM [dbo].[Fun_GetReimbursementMonthYearToViewAndApprove]()
-- DROP FUNCTION Fun_GetReimbursementMonthYearForApprover
-- =============================================

CREATE FUNCTION [dbo].[Fun_GetReimbursementMonthYearToViewAndApprove](
)
RETURNS @MonthYearList TABLE  ([MonthYear] VARCHAR(100), [Month] VARCHAR(26), [Year] int, [MonthNumber] int)
AS
BEGIN
    DECLARE @StartDate DATETIME, @EndDate DATETIME, @TypeName VARCHAR(10), @n DATETIME = GETDATE()
			     SELECT @StartDate = datefromparts(2018,4, 1),
			     @EndDate = datefromparts(Datepart(yyyy, @n), Datepart(m, @n), 1)
			
	INSERT INTO @MonthYearList
	SELECT  DATENAME(MONTH, DATEADD(MONTH, x.number, @StartDate)) + '' '' + Convert(varchar(4), Year(DATEADD(MONTH, x.number, @StartDate))) AS MonthName
	,DATENAME(MONTH, DATEADD(MONTH, x.number, @StartDate))
	,Convert(int, Year(DATEADD(MONTH, x.number, @StartDate))) AS [Year]
	,CAST (MONTH(DATENAME(MONTH, DATEADD(MONTH, x.number, @StartDate)) + '' 1 2010'') AS INT) 
	FROM    master.dbo.spt_values x
	WHERE x.type = ''P''
	AND   x.number <= DATEDIFF(MONTH, @StartDate, @EndDate) order by x.number desc;
	RETURN 
END
' 
END

GO
/****** Object:  StoredProcedure [dbo].[Proc_GetReimbursementList]    Script Date: 05-10-2018 10:57:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetReimbursementList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetReimbursementList] AS' 
END
GO
/***
   Created Date      :     2018-08-24
   Created By        :     Kanchan Kumari
   Purpose           :     To get the applied reimbursement request
   --------------------------------------------------------------------------
   Usage             : Proc_GetReimbursementList @UserId = 2432, @ReimbursementTypeId=1, @Year = 0
   --------------------------------------------------------------------------
***/
ALTER PROC [dbo].[Proc_GetReimbursementList]
(
@UserId INT,
@ReimbursementTypeId INT = 0,
@Year INT = 0
)
AS
BEGIN
	     DECLARE @StartDate DATE, @EndDate DATE;

	    IF(@Year!=0)
	    BEGIN
		     SELECT @StartDate = datefromparts(@Year,4, 1),
			        @EndDate = datefromparts(@Year+1, 3, 31)
	    END
		SELECT RT.ReimbursementTypeName, R.ReimbursementRequestId, R.ReimbApprovedAmt AS ApprovedAmount, R.ReimbRequestedAmt AS RequestedAmount,
			   R.[Month], R.[Year], R.IsActive,
			    CASE WHEN S.StatusCode = 'DF' THEN S.[Status] +' by '+ UR.EmployeeFirstName +' '+UR.EmployeeLastName
				     WHEN S.StatusCode IN('PA','PV') THEN S.[Status] +' with '+ VP.EmployeeFirstName +' '+VP.EmployeeLastName
					 ELSE  S.[Status] +' by '+ VD.EmployeeFirstName + ' ' + VD.EmployeeLastName END AS [Status],
			   CONVERT(VARCHAR(20),R.CreatedDate,106)+' '+FORMAT(R.CreatedDate, 'hh:mm tt') AS CreatedDate,
			   CONVERT(VARCHAR(20),R.SubmittedDate,106)+' '+FORMAT(R.CreatedDate, 'hh:mm tt') AS SubmittedDate,
			   CASE WHEN S.StatusCode = 'DF' THEN  UR.EmployeeFirstName + ' ' + UR.EmployeeLastName + ': ' +  R.[Remarks] 
			        ELSE VD.EmployeeFirstName + ' ' + VD.EmployeeLastName + ': ' +  R.[Remarks] END AS [Remarks],
			   CASE WHEN S.StatusCode IN('SD', 'PA', 'AP', 'PV', 'VD') THEN 1 ELSE 0 END AS IsSubmitted,
			   MT.[MonthYear],
			   S.StatusCode
		FROM ReimbursementRequest R JOIN ReimbursementType RT WITH(NOLOCK) ON  R.ReimbursementTypeId = RT.ReimbursementTypeId
			JOIN ReimbursementStatus S WITH(NOLOCK) ON R.StatusId = S.StatusId 
			LEFT JOIN vwActiveUsers VD WITH(NOLOCK) ON R.ModifiedById = VD.UserId
			LEFT JOIN vwActiveUsers VP WITH(NOLOCK) ON R.NextApproverId = VP.UserId
			JOIN vwActiveUsers UR WITH(NOLOCK) ON R.CreatedById = UR.UserId
			JOIN (SELECT * FROM dbo.[Fun_GetReimbursementMonthYearToViewAndApprove]()) MT 
			             ON MT.[MonthNumber] = R.[Month] AND MT.[Year] = R.[Year]
		WHERE R.UserId = @UserId  				 
		      AND (datefromparts(R.[Year], R.[Month], 1) BETWEEN @StartDate AND @EndDate OR @Year = 0) 
		      AND (R.ReimbursementTypeId = @ReimbursementTypeId OR @ReimbursementTypeId = 0) 
        ORDER BY  R.[Year] DESC, R.[Month] DESC, R.SubmittedDate DESC
END

GO
/****** Object:  StoredProcedure [dbo].[Proc_GetReimbursementListToReview]    Script Date: 05-10-2018 10:57:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetReimbursementListToReview]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetReimbursementListToReview] AS' 
END
GO
/***
   Created Date      :     2018-08-24
   Created By        :     Kanchan Kumari
   Purpose           :     To get the applied reimbursement request to review 
   --------------------------------------------------------------------------
   Usage             :
   --------------------------------------------------------------------------
        Proc_GetReimbursementListToReview @LoginUserId = 1108, @Year = 2018, @ReimbursementTypeId=0
***/
ALTER PROC Proc_GetReimbursementListToReview
(
@LoginUserId INT,
@Year INT = 0,
@ReimbursementTypeId INT = 0
)
AS
BEGIN
	SET FMTONLY OFF;
	   DECLARE @StartDate DATE, @EndDate DATE;

	    IF(@Year!=0)
	    BEGIN
		     SELECT @StartDate = datefromparts(@Year,4, 1),
			        @EndDate = datefromparts(@Year+1, 3, 31)
	    END

	IF OBJECT_ID('tempdb..#TempReimbursementData') IS NOT NULL
	DROP TABLE #TempReimbursementData

	CREATE TABLE #TempReimbursementData
	(
		ReimbursementRequestId INT NOT NULL,
		UserId INT NOT NULL,
		EmployeeName VARCHAR(100),
		ReimbursementTypeName VARCHAR(50),
		Department VARCHAR(100),
		ApprovedAmount DECIMAL(18,2),
		RequestedAmount DECIMAL(18,2),
		StatusId INT,
		StatusCode VARCHAR(5),
		[Status] VARCHAR(100),
		[Remarks] varchar(500),
		SubmittedDate VARCHAR(30),
		MonthYear VARCHAR(100)
	)  
		  INSERT INTO #TempReimbursementData -----fetch pending request
		  SELECT RR.ReimbursementRequestId, RR.UserId, UD.EmployeeName, RT.ReimbursementTypeName, UD.Department,
		         RR.ReimbApprovedAmt AS ApprovedAmount,
				 RR.ReimbRequestedAmt AS RequestedAmount, 
				 RS.StatusId,RS.StatusCode, 
				 CASE WHEN RS.StatusCode IN('PA','PV') THEN RS.[Status] +' with '+ VP.EmployeeFirstName +' '+VP.EmployeeLastName
					  ELSE  RS.[Status] +' by '+ VD.EmployeeFirstName + ' ' + VD.EmployeeLastName END AS [Status],
			     VD.EmployeeFirstName + ' ' + VD.EmployeeLastName + ': ' +  RR.[Remarks] AS [Remarks],
			   CONVERT(VARCHAR(20),RR.SubmittedDate,106)+' '+FORMAT(RR.SubmittedDate, 'hh:mm tt') AS SubmittedDate,
			   MT.[MonthYear] 
		  FROM ReimbursementRequest RR JOIN vwActiveUsers UD ON RR.UserId = UD.UserId 
			   JOIN ReimbursementStatus RS ON RR.StatusId = RS.StatusId 
			   JOIN ReimbursementType RT ON RR.ReimbursementTypeId = RT.ReimbursementTypeId 
			   LEFT JOIN vwActiveUsers VD ON RR.ModifiedById = VD.UserId
			   LEFT JOIN vwActiveUsers VP ON RR.NextApproverId = VP.UserId
			  JOIN (SELECT * FROM dbo.[Fun_GetReimbursementMonthYearToViewAndApprove]()) MT
			             ON MT.[MonthNumber] = RR.[Month] AND MT.[Year] = RR.[Year]
		    WHERE RR.NextApproverId = @LoginUserId  
				 AND (datefromparts(RR.[Year], RR.[Month], 1) BETWEEN @StartDate AND @EndDate OR @Year = 0) 
				 AND (RR.ReimbursementTypeId = @ReimbursementTypeId OR @ReimbursementTypeId = 0)
				 AND RS.StatusCode != 'RB'
				 ORDER BY  RR.[Year] DESC, RR.[Month] DESC, RR.SubmittedDate DESC
				 
			 INSERT INTO #TempReimbursementData -----fetch approved or rejected request or cancelled request
		   	 SELECT RR.ReimbursementRequestId,RR.UserId, UD.EmployeeName, RT.ReimbursementTypeName, UD.Department,
			     RR.ReimbApprovedAmt AS ApprovedAmount,
				 RR.ReimbRequestedAmt AS RequestedAmount, 
				  RS.StatusId,SH.StatusCode,
			      CASE WHEN SH.StatusCode = 'RB' THEN SH.[Status] +' by '+  VH.EmployeeFirstName + ' ' + VH.EmployeeLastName 
				       WHEN ND.UserId IS NULL THEN RS.[Status] +' by '+  VD.EmployeeFirstName + ' ' + VD.EmployeeLastName 
				       ELSE RS.[Status] +' with '+ ND.EmployeeFirstName + ' ' + ND.EmployeeLastName END AS [Status],
				  VD.EmployeeFirstName + ' ' + VD.EmployeeLastName + ': ' +  RR.[Remarks] AS [Remarks],
				  CONVERT(VARCHAR(20),RR.SubmittedDate,106)+' '+FORMAT(RR.SubmittedDate, 'hh:mm tt') AS SubmittedDate,
				    MT.[MonthYear] 
		  FROM ReimbursementRequest RR JOIN vwActiveUsers UD ON RR.UserId = UD.UserId 
			   JOIN ReimbursementStatus RS ON RR.StatusId = RS.StatusId 
			   JOIN ReimbursementType RT ON RR.ReimbursementTypeId = RT.ReimbursementTypeId 
			   LEFT JOIN vwActiveUsers ND ON RR.NextApproverId = ND.UserId
			   LEFT JOIN vwActiveUsers VD ON RR.ModifiedById = VD.UserId
			   JOIN ReimbursementHistory RH ON RR.ReimbursementRequestId = RH.ReimbursementRequestId
			   JOIN vwActiveUsers VH ON RH.CreatedById = VH.UserId 
			   JOIN ReimbursementStatus SH ON RH.StatusId = SH.StatusId
			      JOIN (SELECT * FROM dbo.[Fun_GetReimbursementMonthYearToViewAndApprove]()) MT
			             ON MT.[MonthNumber] = RR.[Month] AND MT.[Year] = RR.[Year]
		  WHERE RH.CreatedById = @LoginUserId  AND RH.CreatedById != RR.UserId				
				AND (datefromparts(RR.[Year], RR.[Month], 1) BETWEEN @StartDate AND @EndDate OR @Year = 0)
				AND (RR.ReimbursementTypeId = @ReimbursementTypeId OR @ReimbursementTypeId = 0)
				AND SH.StatusCode != 'RB'
		  ORDER BY  RR.[Year] DESC, RR.[Month] DESC, RH.CreatedDate DESC

	   SELECT * FROM #TempReimbursementData 
	   GROUP BY  ReimbursementRequestId, EmployeeName, ReimbursementTypeName, Department,
	              StatusId, StatusCode, [Status], [Remarks], SubmittedDate, MonthYear, UserId, ApprovedAmount, RequestedAmount
END
GO


/****** Object:  StoredProcedure [dbo].[spTakeActionOnCompOff]    Script Date: 11-10-2018 17:03:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spTakeActionOnCompOff]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spTakeActionOnCompOff]
GO
/****** Object:  StoredProcedure [dbo].[spGetUserAppliedCompOff]    Script Date: 11-10-2018 17:03:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetUserAppliedCompOff]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetUserAppliedCompOff]
GO
/****** Object:  StoredProcedure [dbo].[spGetShiftUserMappingList]    Script Date: 11-10-2018 17:03:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetShiftUserMappingList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetShiftUserMappingList]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetTeamMembersListForUserTeamMapping]    Script Date: 11-10-2018 17:03:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetTeamMembersListForUserTeamMapping]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetTeamMembersListForUserTeamMapping]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetTeamMembersListForUserTeamMapping]    Script Date: 11-10-2018 17:03:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetTeamMembersListForUserTeamMapping]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetTeamMembersListForUserTeamMapping] AS' 
END
GO
--EXEC PROC Proc_GetTeamMembersListForUserTeamMapping @TeamId = 5
ALTER PROC [dbo].[Proc_GetTeamMembersListForUserTeamMapping]
AS
BEGIN
     SELECT distinct D.DepartmentName,T.TeamName,T.TeamId, ISNULL(STUFF((SELECT  ', ' + EmployeeName FROM vwActiveUsers T2 where T2.TeamId=T.TeamId order by T2.EmployeeName FOR XML PATH ('')), 1, 1, ''),0) col2
	 FROM Team T
	 JOIN Department D ON T.DepartmentId = D.DepartmentId
	 order by T.TeamName
END

GO
/****** Object:  StoredProcedure [dbo].[spGetShiftUserMappingList]    Script Date: 11-10-2018 17:03:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetShiftUserMappingList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGetShiftUserMappingList] AS' 
END
GO

/***
   Created Date      :     2017-02-08
   Created By        :     Jitender Kumar
   Purpose           :     stored procedure to get Shift User Mapping List
   Change History    :
   -------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
    11 oct 2018      Kanchan kumari       fetch data for multiple weeks
   --------------------------------------------------------------------------

   Test Cases        :
   --------------------------------------------------------------------------
   
   --- Test Case 1
         EXEC [dbo].[spGetShiftUserMappingList]
		  @TeamIds  = ''
		  ,@ShiftIds  = '3'		 
		   ,@XmlString ='<Root>
                 <Row FromDate="10/08/2018" EndDate="10/15/2018"/>
                </Root>'
		  ,@LoginUserId  =1109
***/
--DECLARE
--		   @TeamIds varchar(4000) = '36'
--		  ,@ShiftIds varchar(4000) = '3'		 
--		  ,@StartDate DATE = '2017-02-06'
--		  ,@EndDate DATE = '2017-02-12'		  
--		  ,@LoginUserId [int] =1109

ALTER PROCEDURE [dbo].[spGetShiftUserMappingList]
(
   @TeamIds varchar(4000) = NULL
  ,@ShiftIds varchar(4000) = NULL
  ,@XmlString xml
  ,@LoginUserId [int]
)
AS
BEGIN      
SET NOCOUNT ON;
SET FMTONLY OFF;
            IF OBJECT_ID('tempdb..#TempWeekData') IS NOT NULL
			DROP TABLE #TempWeekData

		    CREATE TABLE #TempWeekData( Id INT IDENTITY(1,1), FromDate DATE, EndDate DATE)
			INSERT INTO #TempWeekData(FromDate, EndDate)
			SELECT 
			    T.Item.value('@FromDate', 'DATE'),
			    T.Item.value('@EndDate', 'DATE')
			FROM @XmlString.nodes('/Root/Row')AS T(Item)

			IF OBJECT_ID('tempdb..#TempDateId') IS NOT NULL
			DROP TABLE #TempDateId

		    CREATE TABLE #TempDateId(DateId INT)

			DECLARE @i INT= 1, @COUNT INT = (SELECT COUNT(*) FROM #TempWeekData)
			DECLARE @FromDate DATE, @EndDate DATE

			WHILE(@i <= @COUNT)
			BEGIN
			        SELECT @FromDate = FromDate
				        ,@EndDate = EndDate FROM #TempWeekData WHERE Id = @i
					INSERT INTO #TempDateId
					SELECT DateId FROM  DateMaster WHERE [Date] BETWEEN @FromDate AND @EndDate
					SET @i = @i+1;
			END
      IF OBJECT_ID('tempdb..#TeampShiftUserMappingList') IS NOT NULL
      DROP TABLE #TeampShiftUserMappingList

    CREATE TABLE #TeampShiftUserMappingList (MappingId BIGINT,TeamId Int, TeamName VARCHAR(100),UserName VARCHAR(100), ShiftName VARCHAR(100), DateId BIGINT,DateValue VARCHAR(30),
	             [Day] VARCHAR(20),InTime VARCHAR(10),OutTime VARCHAR(10),IsWeekEnd [bit],IsNight [bit],UserId Int,ShiftId Int,ShiftType VARCHAR(30),)

	INSERT Into #TeampShiftUserMappingList (MappingId,TeamId, TeamName, UserName,ShiftName,DateId,DateValue,[Day],InTime,OutTime,IsWeekEnd,IsNight,UserId,ShiftId,ShiftType)
	SELECT USM.MappingId,T.TeamId, T.TeamName, US.FirstName+' '+US.LastName, SM.ShiftName,USM.DateId,convert(VARCHAR(30),DM.[Date],106),DM.[Day],SM.InTime,SM.OutTime,SM.IsWeekEnd,SM.IsNight,USM.UserId,USM.ShiftId,
	CASE WHEN (SM.IsNight = 1 AND SM.IsWeekEnd = 1) THEN 'Night || Weekend' WHEN (SM.IsNight = 1 AND SM.IsWeekEnd = 0) THEN 'Night || Weekday' 
		WHEN (SM.IsNight = 0 AND SM.IsWeekEnd = 1) THEN 'Day || Weekend' WHEN (SM.IsNight = 0 AND SM.IsWeekEnd = 0) THEN 'Day || Weekday' ELSE 'NA' END as ShiftType
	FROM UserShiftMapping USM WITH (NOLOCK)
    INNER JOIN [dbo].[ShiftMaster] SM WITH (NOLOCK) ON USM.ShiftId = SM.ShiftId
    INNER JOIN [dbo].[UserTeamMapping] UTM WITH (NOLOCK) ON USM.UserId = UTM.UserId
    INNER JOIN [dbo].[Team] T WITH (NOLOCK) ON UTM.TeamId = T.TeamId
    INNER JOIN [dbo].[DateMaster] DM WITH (NOLOCK) ON USM.DateId = DM.DateId
	INNER JOIN [dbo].[UserDetail] US WITH (NOLOCK) ON USM.UserId = US.UserId 
	WHERE USM.IsActive=1 AND
	USM.DateId IN (SELECT DateId FROM #TempDateId) 
	AND USM.[ShiftId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@ShiftIds,',')) OR @ShiftIds IS NULL
	
	select T.MappingId, T.TeamName, T.UserName,T.ShiftName,T.DateId,T.DateValue,T.[Day],T.InTime,T.OutTime,T.IsWeekEnd,T.IsNight,T.ShiftType,T.UserId,T.ShiftId
	from #TeampShiftUserMappingList T WHERE T.[TeamId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@TeamIds,',')) OR @TeamIds IS NULL OR @TeamIds = ''
	ORDER BY T.TeamName
      
END


GO
/****** Object:  StoredProcedure [dbo].[spGetUserAppliedCompOff]    Script Date: 11-10-2018 17:03:59 ******/
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
   EXEC [dbo].[spGetUserAppliedCompOff] @UserId = 2405,@Year=2018
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
       C.[RequestId]    AS [RequestId]
      ,D.[Date]         AS [Date]
      ,C.[Reason]       AS [Reason]
      ,C.[NoOfDays]     AS [NoOfDays]
      ,CASE
         WHEN LS.[StatusCode] = 'RJ' THEN 'Rejected By ' + (SELECT [FirstName] + ' ' + [LastName] FROM [dbo].[UserDetail] WHERE [UserId] = C.[LastModifiedBy])
         WHEN LS.[StatusCode] = 'CA' THEN 'Cancelled '
         WHEN LS.[StatusCode] = 'PA' THEN 'Pending for approval with ' + (SELECT [FirstName] + ' ' + [LastName] FROM [dbo].[UserDetail] WHERE [UserId] = C.[ApproverId])
         ELSE LS.[Status]
       END              AS [Status]
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
         WHEN COUNT(RD.[RequestId]) = 0  AND COUNT(LL.[RequestId]) = 0 THEN 1       --available
         WHEN C.[NoOfDays] = (COUNT(RD.[RequestId]) + COUNT(LL.[RequestId])) THEN 2 --availed
         WHEN C.[NoOfDays] > (COUNT(RD.[RequestId]) + COUNT(LL.[RequestId])) THEN 3 --partially availed
       END                          AS [AvailabilityStatus]
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
	  LEFT JOIN ( 
				 SELECT H.[RequestId] AS [RequestId], MAX(H.[CreatedDate]) AS [LatestModifiedOn]
				 FROM [dbo].[RequestCompOffHistory] H WITH (NOLOCK)
				 GROUP BY H.[RequestId]
        ) RH ON C.[RequestId] = RH.[RequestId]
      LEFT JOIN
      (
         SELECT
            RD.[RequestId]
         FROM
            [dbo].[RequestCompOffDetail] RD WITH (NOLOCK)
            INNER JOIN
               [dbo].[LegitimateLeaveRequest] L WITH (NOLOCK)
               ON RD.[LegitimateLeaveRequestId] = L.[LegitimateLeaveRequestId]
               AND L.[StatusId] < 6
      ) LL
      ON C.[RequestId] = LL.[RequestId]   
	  LEFT JOIN 
         [dbo].[RequestCompOffHistory] H WITH (NOLOCK) 
         ON H.[RequestId] = RH.[RequestId] 
         AND H.[CreatedDate] = RH.[LatestModifiedOn]
	  LEFT JOIN 
         [dbo].[UserDetail] CAP WITH (NOLOCK) 
         ON H.[ApproverId] = CAP.[UserId]
   WHERE 
      U.[UserId] = @UserId 
      AND US.[IsActive] = 1 AND C.[LapseDate] BETWEEN @StartDate AND @EndDate    
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
   ORDER BY  C.[RequestId] DESC, C.[CreatedDate] DESC
END
GO
/****** Object:  StoredProcedure [dbo].[spTakeActionOnCompOff]    Script Date: 11-10-2018 17:03:59 ******/
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
          @RequestID = 1864
         ,@Status = 'PV'
         ,@Remark = 'Test'
         ,@UserId =61
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

