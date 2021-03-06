GO
/****** Object:  StoredProcedure [dbo].[spGetWFHRequest]    Script Date: 09-01-2019 15:51:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetWFHRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetWFHRequest]
GO
/****** Object:  StoredProcedure [dbo].[spGetLeaves]    Script Date: 09-01-2019 15:51:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetLeaves]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetLeaves]
GO
/****** Object:  StoredProcedure [dbo].[spGetDataChangeRequests]    Script Date: 09-01-2019 15:51:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetDataChangeRequests]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetDataChangeRequests]
GO
/****** Object:  StoredProcedure [dbo].[spGetCompOff]    Script Date: 09-01-2019 15:51:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetCompOff]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetCompOff]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetOutingReviewRequest]    Script Date: 09-01-2019 15:51:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetOutingReviewRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetOutingReviewRequest]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetLegitimateLeave]    Script Date: 09-01-2019 15:51:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetLegitimateLeave]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetLegitimateLeave]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_GetUserWiseFinancialYear]    Script Date: 09-01-2019 15:51:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetUserWiseFinancialYear]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GetUserWiseFinancialYear]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_GetFinancialYear]    Script Date: 09-01-2019 15:51:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetFinancialYear]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GetFinancialYear]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_GetFinancialYear]    Script Date: 09-01-2019 15:51:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetFinancialYear]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Mimansa Agrawal
-- Create date: 08-Jan-2019
-- Description:	To get financial year drop down for review request
-- SELECT * FROM [dbo].[Fun_GetFinancialYear]()
-- =============================================
CREATE FUNCTION [dbo].[Fun_GetFinancialYear]()
RETURNS @FinancialYear TABLE (
		StartYear INT,
		EndYear INT,
		FYStartDate DATE,
		FYEndDate DATE
)
AS
BEGIN
	DECLARE	 @CurrentYear INT = (SELECT DATEPART(year, GETDATE())),
	@StartYear INT = 2010 
		WHILE @StartYear <= @CurrentYear
		BEGIN
			DECLARE @FYStartDate DATE = ''01 Apr ''+CAST((@StartYear) AS VARCHAR(4)),
			@FYEndDate DATE = ''31 Mar '' +CAST((@StartYear + 1) AS VARCHAR(4))
			INSERT  INTO @FinancialYear ([StartYear],[EndYear],[FYStartDate],[FYEndDate])
			VALUES (@StartYear,@StartYear+1,@FYStartDate , @FYEndDate)
			SET @StartYear = @StartYear + 1;
		END
	DELETE FROM @FinancialYear WHERE FYStartDate > GETDATE()
	RETURN 
END' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[Fun_GetUserWiseFinancialYear]    Script Date: 09-01-2019 15:51:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetUserWiseFinancialYear]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Mimansa Agrawal
-- Create date: 08-Jan-2019
-- Description:	To get user wise financial year
-- SELECT * FROM [dbo].[Fun_GetUserWiseFinancialYear](1108)
-- =============================================
CREATE FUNCTION [dbo].[Fun_GetUserWiseFinancialYear](@UserId int)
RETURNS @FinancialYear TABLE (
		StartYear INT,
		EndYear INT,
		FYStartDate DATE,
		FYEndDate DATE
)
AS
BEGIN
  DECLARE @JoiningDate DATE = (SELECT JoiningDate FROM [dbo].[UserDetail] WHERE UserId=@UserId)
  DECLARE  @JoiningYear INT = (SELECT DATEPART(YEAR, @JoiningDate)),
		 @JoiningMonth INT = (SELECT DATEPART(MONTH, @JoiningDate)),
		 @CurrentYear INT = (SELECT DATEPART(year, GETDATE()))
	IF(@JoiningMonth>=4)
	BEGIN
		WHILE @JoiningYear <= @CurrentYear
		BEGIN
			DECLARE @FYStartDate DATE = ''01 Apr ''+CAST((@JoiningYear) AS VARCHAR(4)),
			@FYEndDate DATE = ''31 Mar '' +CAST((@JoiningYear + 1) AS VARCHAR(4))
			INSERT  INTO @FinancialYear ([StartYear],[EndYear],[FYStartDate],[FYEndDate])
			VALUES (@JoiningYear,@JoiningYear+1,@FYStartDate , @FYEndDate)
			SET @JoiningYear = @JoiningYear + 1;
		END
	END
	IF(@JoiningMonth < 4)
	BEGIN
		DECLARE @NewStartYear INT = @JoiningYear - 1
		WHILE @NewStartYear <= @CurrentYear
		BEGIN
			DECLARE @FYStartDateNew DATE = ''01 Apr ''+CAST((@NewStartYear) AS VARCHAR(4)),
			@FYEndDateNew DATE = ''31 Mar '' +CAST((@NewStartYear + 1) AS VARCHAR(4))
			INSERT  INTO @FinancialYear ([StartYear],[EndYear],[FYStartDate],[FYEndDate])
			VALUES (@NewStartYear,@NewStartYear + 1,@FYStartDateNew , @FYEndDateNew)
			SET @NewStartYear = @NewStartYear + 1;
		END
	END
	DELETE FROM @FinancialYear WHERE FYStartDate > GETDATE()
	RETURN 
END' 
END

GO
/****** Object:  StoredProcedure [dbo].[Proc_GetLegitimateLeave]    Script Date: 09-01-2019 15:51:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetLegitimateLeave]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetLegitimateLeave] AS' 
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
	EXEC [dbo].[Proc_GetLegitimateLeave] @UserId = 2166,@Year= 2018
***/
ALTER PROCEDURE [dbo].[Proc_GetLegitimateLeave] 
   @UserId [int],
   @Year [int]
AS
BEGIN
	SET NOCOUNT ON;
    SET FMTONLY OFF;
	DECLARE @AdminId int = 1;
	DECLARE @StartDate [date]= (SELECT dateadd(Month,0,cast(concat(@Year,'-04-01') as date))),
		 @EndDate [date] = (SELECT dateadd(Year,1,cast(concat(@Year,'-03-31') as date)) )
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
		WHERE LR.NextApproverId=@UserId AND DM.[Date] BETWEEN @StartDate AND @EndDate order by LR.CreatedDate	DESC
		
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
		WHERE (ACT.StatusId<>1) AND LR.StatusId<=3 	AND LR.UserId!=@UserId AND DM.[Date] BETWEEN @StartDate AND @EndDate ORDER BY REM.CreatedDate DESC
    
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
		WHERE (ACT.StatusId<>1)	AND LR.StatusId>=5 AND LR.UserId!=@UserId AND DM.[Date] BETWEEN @StartDate AND @EndDate ORDER BY REM.CreatedDate DESC
		
SELECT [RequestId], [EmployeeName], [Date], [Reason], [ApplyDate], [Status],[LeaveInfo],[Remarks], [StatusCode]
FROM #TempDataNew 
END

GO
/****** Object:  StoredProcedure [dbo].[Proc_GetOutingReviewRequest]    Script Date: 09-01-2019 15:51:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetOutingReviewRequest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetOutingReviewRequest] AS' 
END
GO
----------------------------------------------------------------------------
--Created Date      : 2018-03-21
--Created By        : Kanchan Kumari
--Purpose           : This stored procedure is used to apply outing request
--Usage				: EXEC [Proc_GetOutingReviewRequest] 24,2017
----------------------------------------------------------------------------
ALTER PROC [dbo].[Proc_GetOutingReviewRequest]
@LoginUserId [INT],
@Year [INT]
AS
BEGIN
	SET NOCOUNT ON;
	SET FMTONLY OFF;
	DECLARE @StartDate [date]= (SELECT dateadd(Month,0,cast(concat(@Year,'-04-01') as date))),
		 @EndDate [date] = (SELECT dateadd(Year,1,cast(concat(@Year,'-03-31') as date)) )
		 DECLARE @IsHR BIT
 IF EXISTS(SELECT 1 FROM UserDetail UD WITH (NOLOCK) 
				 JOIN Designation D ON UD.DesignationId=D.DesignationId 
				 JOIN DesignationGroup DG WITH (NOLOCK) ON D.DesignationGroupId = DG.DesignationGroupId 
				 WHERE UD.[UserId]=@LoginUserId AND DG.DesignationGroupId=5 )--5: Human Resource
				BEGIN
				SET @IsHR = 1
				END
	ELSE 
	BEGIN 
	SET @IsHR = 0
	END		
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
		[DutyType] VARCHAR(50),
		[Remarks] varchar(500),
		[StatusCode] VARCHAR(10)
	)
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
				S.[Status]+' with '+ UDT.FirstName+' '+ UDT.LastName 
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
			WHERE R.NextApproverId=@LoginUserId  AND DM1.[Date] BETWEEN @StartDate AND @EndDate order by R.CreatedDate DESC

			INSERT INTO #TempDataNew([OutingRequestId], [EmployeeName], [Period], [Reason], [ApplyDate], [Status],[DutyType],[Remarks],[StatusCode])
			SELECT  R.OutingRequestId AS [OutingRequestId],
				UD.[FirstName] + ' ' + UD.[LastName] AS [EmployeeName],
				CASE WHEN R.FromDateId=R.TillDateId THEN CAST(CONVERT(VARCHAR(20),DM1.[Date],106) AS Varchar(20)) 
							ELSE  CAST(CONVERT(VARCHAR(20),DM1.[Date],106) AS Varchar(20)) + '  To  ' + CAST(CONVERT(VARCHAR(20),DM2.[Date],106) AS Varchar(20) ) END AS [Period],
				R.[Reason] AS [Reason],
				CONVERT(VARCHAR(20), R.CreatedDate,106) + ' ' + FORMAT(R.CreatedDate,'hh:mm tt') AS [ApplyDate],
				 S.[Status]+' with '+ UDT.FirstName+' '+ UDT.LastName AS [Status],
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
			WHERE (ACT.StatusId<>1) AND R.StatusId<=3 AND R.UserId!=@LoginUserId AND DM1.[Date] BETWEEN @StartDate AND @EndDate order by REM.CreatedDate DESC 

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
			AND DM1.[Date] BETWEEN @StartDate AND @EndDate
			 order by REM.CreatedDate DESC 
			
		
	SELECT [OutingRequestId], [EmployeeName], [Period], [Reason], [ApplyDate], [Status],[DutyType],[Remarks], [StatusCode]
	FROM #TempDataNew 
END


GO
/****** Object:  StoredProcedure [dbo].[spGetCompOff]    Script Date: 09-01-2019 15:51:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetCompOff]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGetCompOff] AS' 
END
GO
/***
   Created Date      :     2016-01-27
   Created By        :     Narender Singh
   Purpose           :     This stored procedure Get Details of requested Comp Off 
                           This is for HR
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   
   --------------------------------------------------------------------------

   Test Cases        :
   --------------------------------------------------------------------------
   
   --- Test Case 1
         EXEC [dbo].[spGetCompOff]
           @UserId = 22
           ,@Status = 'dasds'

   --- Test Case 2
         EXEC [dbo].[spGetCompOff]
           @UserId = 1108,
		   @Year = 2018
           
           

            
***/
ALTER PROCEDURE [dbo].[spGetCompOff]
(
	@UserID [int] ,
	@Year [int]
)
AS
BEGIN
	SET NOCOUNT ON  
		DECLARE @StartDate [date]= (SELECT dateadd(Month,0,cast(concat(@Year,'-04-01') as date))),
		 @EndDate [date] = (SELECT dateadd(Year,1,cast(concat(@Year,'-03-31') as date)) )
	SELECT
	   R.[RequestId]																																													 AS [RequestId]
	  ,U.[FirstName] + ' ' + U.[LastName]																																								 AS [EmployeeName]
	  ,D.[Date]																																															 AS [Date]
	  ,R.[Reason]																																														 AS [Reason]
	  ,R.[CreatedDate]																																												     AS [CreatedDate]
	  ,CASE
			WHEN RCH.[ApproverRemarks] IS NULL THEN 'NA'
         WHEN LTRIM(RTRIM(RCH.[ApproverRemarks])) = '' THEN LAP.[FirstName] + ' ' + LAP.[LastName] + ': Approved'
         ELSE LAP.[FirstName] + ' ' + LAP.[LastName] + ': ' + RCH.[ApproverRemarks]
		END																																																	AS [Remarks]
	  ,ISNULL(UH.[StatusId], R.[StatusId])																																							AS [StatusId]
     --,UH.[StatusId]                   																																							AS [StatusId]
	  ,CASE  
			WHEN LS.[StatusCode] = 'RJ' THEN LS.[Status] + ' by ' + NAP.[FirstName] + ' ' + NAP.[LastName]
         WHEN LS.[StatusCode] = 'PA' AND R.[ApproverId] != @UserId THEN LS.[Status] + ' from ' + NAP.[FirstName] + ' ' + NAP.[LastName]
         WHEN LS.[StatusCode] = 'PA' AND R.[ApproverId] != @UserId THEN LS.[Status]
         ELSE LS.[Status]  
      END																																																	AS [Status]
	  ,R.[NoOfDays]																																														AS [NoOfDays]
	FROM
		[dbo].[RequestCompOff] R WITH (NOLOCK)
			INNER JOIN
				[dbo].[DateMaster] D WITH (NOLOCK)
					ON D.[DateId] = R.[DateId]
			INNER JOIN
				[dbo].[UserDetail] U WITH (NOLOCK)
					ON  U.[UserId] = R.[CreatedBy]
			INNER JOIN
				[dbo].[LeaveStatusMaster] LS WITH (NOLOCK)
					ON  LS.[StatusId] = R.[StatusId] 
			INNER JOIN 
				[dbo].[UserDetail] NAP WITH (NOLOCK)
					ON NAP.[UserId] = R.[ApproverId]
			LEFT JOIN
				(
					SELECT
						RC.[RequestId]																																										AS [RequestId]
					  ,MAX(RC.[CreatedDate])																																							AS [LatestModifiedTime]
					FROM
						[dbo].[RequestCompOffHistory] RC WITH (NOLOCK)
					GROUP BY
						RC.[RequestId]
				) RH
					ON RH.[RequestId] = R.[RequestId]	
			LEFT JOIN
				[dbo].[RequestCompOffHistory] RCH WITH (NOLOCK)
					ON RCH.[RequestId] = R.[RequestId]							
					AND RCH.[CreatedDate] = RH.[LatestModifiedTime]
			LEFT JOIN 
				[dbo].[UserDetail] LAP WITH (NOLOCK)
					ON LAP.[UserId] = RCH.[CreatedBy]					
			LEFT JOIN
				[dbo].[RequestCompOffHistory] UH WITH (NOLOCK)
					ON UH.[RequestId] = R.[RequestId]
					AND UH.[ApproverId] = @UserId -- UH.[ApproverId]
					AND UH.[CreatedBy] = @UserId
	WHERE 
		(R.[ApproverId] = @UserId
		OR UH.[CreatedBy] = @UserId) AND D.[DATE] BETWEEN @StartDate AND @EndDate 
   ORDER BY
      D.[Date] DESC
      ,U.[FirstName] + ' ' + U.[LastName]
END
GO
/****** Object:  StoredProcedure [dbo].[spGetDataChangeRequests]    Script Date: 09-01-2019 15:51:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetDataChangeRequests]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGetDataChangeRequests] AS' 
END
GO
/***
   Created Date      :     2016-01-29
   Created By        :     Banbari Lal
   Purpose           :     This stored procedure is to  get data change requests  
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   --- Test Case 1
         EXEC [dbo].[spGetDataChangeRequests]
             @UserId = 47
            ,@Role = 'M'
   --- Test Case 2
         EXEC [dbo].[spGetDataChangeRequests]
            @UserId = 2166
           ,@Role = 'M'
		   ,@Year = 2017
***/
ALTER PROCEDURE [dbo].[spGetDataChangeRequests] 
    @UserId [int]
   ,@Role varchar(5)
   ,@Year [int]
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @StartDate [date]= (SELECT dateadd(Month,0,cast(concat(@Year,'-04-01') as date))),
		 @EndDate [date] = (SELECT dateadd(Year,1,cast(concat(@Year,'-03-31') as date)) )
	SELECT 
      A.[RequestId] AS [ApplicationId]
     ,E.[FirstName] + ' ' + E.[LastName]  AS [EmployeeName]
     ,C.[CategoryCode] AS [Category]
     ,REPLACE(CONVERT([varchar](11), FD.[Date], 106), ' ', '-') + ' to ' +  REPLACE(CONVERT([varchar](11), TD.[Date], 106), ' ', '-') AS [Period]                                                        
     ,A.[Reason] AS [Reason]
	 ,A.[CreatedDate] AS [CreatedDate]
     ,CASE
         WHEN LS.[StatusCode] = 'CA' THEN A.[ApproverRemarks]
         WHEN H.[ApproverRemarks] IS NULL THEN 'NA'
         WHEN LTRIM(RTRIM(H.[ApproverRemarks])) = '' THEN LAP.[FirstName] + ' ' + LAP.[LastName] + ': Approved'
         ELSE LAP.[FirstName] + ' ' + LAP.[LastName] + ': ' + H.[ApproverRemarks]
      END AS [ApproverRemarks]                                                    
      ,CASE  
         WHEN LS.[StatusCode] = 'RJ' THEN LS.[Status] + ' by ' + NAP.[FirstName] + ' ' + NAP.[LastName]
         WHEN LS.[StatusCode] = 'PA' AND A.[ApproverId] != @UserId THEN LS.[Status] + ' from ' + NAP.[FirstName] + ' ' + NAP.[LastName]
         WHEN LS.[StatusCode] = 'PV' AND A.[ApproverId] != @UserId THEN LS.[Status]
         ELSE LS.[Status]  
      END  AS [Status]    
     ,ISNULL(UH.[StatusId], A.[StatusId])                                                                                                                                              AS [StatusId]
   FROM
      [dbo].[AttendanceDataChangeRequestApplication] A WITH (NOLOCK)
         INNER JOIN [dbo].[UserDetail] E WITH (NOLOCK) ON E.[UserId] = A.[CreatedBy] AND E.[UserId]!=@UserId
         INNER JOIN [dbo].[AttendanceDataChangeRequestCategory] C WITH (NOLOCK) ON C.[CategoryId] = A.[RequestCategoryid]
         INNER JOIN [dbo].[LeaveRequestApplication] L WITH (NOLOCK) ON L.[LeaveRequestApplicationId] = A.[RequestApplicationId]
         INNER JOIN [dbo].[DateMaster] FD WITH (NOLOCK) ON FD.[DateId] = L.[FromDateId]
         INNER JOIN [dbo].[DateMaster] TD WITH (NOLOCK) ON TD.[DateId] = L.[TillDateId]
         INNER JOIN [dbo].[LeaveStatusMaster] LS WITH (NOLOCK) ON LS.[StatusId] = A.[StatusId]
         INNER JOIN [dbo].[UserDetail] NAP WITH (NOLOCK) ON NAP.[UserId] = A.[ApproverId]
         LEFT JOIN
            (
               SELECT H.[RequestId] AS [RequestId],MAX(H.[CreatedDate]) AS [LatestModifiedTime]
               FROM [dbo].[AttendanceDataChangeRequestHistory] H WITH (NOLOCK)
               GROUP BY H.[RequestId]
            ) RH ON A.[RequestId] = RH.[RequestId]
         LEFT JOIN [dbo].[AttendanceDataChangeRequestHistory] H WITH (NOLOCK) ON H.[RequestId] = RH.[RequestId] AND H.[CreatedDate] = RH.[LatestModifiedTime]
         LEFT JOIN [dbo].[UserDetail] LAP WITH (NOLOCK) ON H.[ApproverId] = LAP.[UserId]
         LEFT JOIN [dbo].[AttendanceDataChangeRequestHistory] UH WITH (NOLOCK) ON A.[RequestId] = UH.[RequestId] AND UH.[ApproverId] = @UserId
   WHERE
      C.[CategoryCode] = 'Leave' AND FD.[Date] BETWEEN @StartDate AND @EndDate
      AND (UH.[ApproverId] = @UserId OR A.[ApproverId] = @UserId)

   UNION

   SELECT 
      A.[RequestId] AS [ApplicationId]
     ,E.[FirstName] + ' ' + E.[LastName] AS [EmployeeName]
     ,C.[CategoryCode] AS [Category]
	 ,REPLACE(CONVERT([varchar](11), FD.[Date], 106), ' ', '-') AS [Period]
     ,A.[Reason] AS [Reason]
	 ,A.[CreatedDate] AS [CreatedDate]
     ,CASE
         WHEN LS.[StatusCode] = 'CA' THEN A.[ApproverRemarks]
         WHEN H.[ApproverRemarks] IS NULL THEN 'NA'
         WHEN LTRIM(RTRIM(H.[ApproverRemarks])) = '' THEN LAP.[FirstName] + ' ' + LAP.[LastName] + ': Approved'
         ELSE LAP.[FirstName] + ' ' + LAP.[LastName] + ': ' + H.[ApproverRemarks]
      END AS [ApproverRemarks]                                                    
      ,CASE  
         WHEN LS.[StatusCode] = 'RJ' THEN LS.[Status] + ' by ' + NAP.[FirstName] + ' ' + NAP.[LastName]
         WHEN LS.[StatusCode] = 'PA' AND A.[ApproverId] != @UserId THEN LS.[Status] + ' from ' + NAP.[FirstName] + ' ' + NAP.[LastName]
         WHEN LS.[StatusCode] = 'PV' AND A.[ApproverId] != @UserId THEN LS.[Status]
         ELSE LS.[Status]  
      END AS [Status]    
     ,ISNULL(UH.[StatusId], A.[StatusId])                                                                                                                                              AS [StatusId]
   FROM
      [dbo].[AttendanceDataChangeRequestApplication] A WITH (NOLOCK)
         INNER JOIN [dbo].[UserDetail] E WITH (NOLOCK) ON E.[UserId] = A.[CreatedBy] AND E.[UserId]!=@UserId
         INNER JOIN [dbo].[AttendanceDataChangeRequestCategory] C WITH (NOLOCK) ON C.[CategoryId] = A.[RequestCategoryid]
         INNER JOIN [dbo].[DateWiseAttendance] DA WITH (NOLOCK) ON DA.[RecordId] = A.[RequestApplicationId]
         INNER JOIN [dbo].[DateMaster] FD WITH (NOLOCK) ON FD.[DateId] = DA.[DateId]
         INNER JOIN [dbo].[LeaveStatusMaster] LS WITH (NOLOCK) ON LS.[StatusId] = A.[StatusId]
         INNER JOIN [dbo].[UserDetail] NAP WITH (NOLOCK) ON A.[ApproverId] = NAP.[UserId]
         LEFT JOIN
            (
               SELECT H.[RequestId] AS [RequestId],MAX(H.[CreatedDate]) AS [LatestModifiedTime]
               FROM [dbo].[AttendanceDataChangeRequestHistory] H WITH (NOLOCK)
               GROUP BY H.[RequestId]
            ) RH ON A.[RequestId] = RH.[RequestId]
         LEFT JOIN [dbo].[AttendanceDataChangeRequestHistory] H WITH (NOLOCK) ON H.[RequestId] = RH.[RequestId] AND H.[CreatedDate] = RH.[LatestModifiedTime]
         LEFT JOIN [dbo].[UserDetail] LAP WITH (NOLOCK) ON H.[ApproverId] = LAP.[UserId]
         LEFT JOIN [dbo].[AttendanceDataChangeRequestHistory] UH WITH (NOLOCK) ON A.[RequestId] = UH.[RequestId] AND UH.[ApproverId] = @UserId
   WHERE
      C.[CategoryCode] = 'Attendance' AND FD.[Date] BETWEEN @StartDate AND @EndDate
      AND (UH.[ApproverId] = @UserId OR A.[ApproverId] = @UserId)
END
 --EXEC [dbo].[spGetDataChangeRequests] 1108,'M'
GO
/****** Object:  StoredProcedure [dbo].[spGetLeaves]    Script Date: 09-01-2019 15:51:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetLeaves]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGetLeaves] AS' 
END
GO
/***
	Created Date      :     2016-01-27
	Created By        :     Nishant Srivastava
	Purpose           :     This stored procedure Get leave Deatils According to User status 
   
	Change History    :
	--------------------------------------------------------------------------
	Modify Date       Edited By            Change Description
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	Test Cases        :
	-----------------------------------------------------------------------
	EXEC [dbo].[spGetLeaves] @UserId = 1108,@Year = 2017
***/
ALTER PROCEDURE [dbo].[spGetLeaves] 
   @UserId [int],
   @Year [int]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @AdminId int = 1;
	--IF (@Year IS NULL OR @Year =0)
	--	SET @Year = DATEPART(YYYY, GETDATE())
		DECLARE @StartDate [date]= (SELECT dateadd(Month,0,cast(concat(@Year,'-04-01') as date))),
		 @EndDate [date] = (SELECT dateadd(Year,1,cast(concat(@Year,'-03-31') as date)) )
	SELECT 
      L.[LeaveRequestApplicationId] AS [ApplicationId]
     ,E.[FirstName] + ' ' + E.[LastName] AS [EmployeeName]
     ,FD.[Date] AS [FromDate]
     ,TD.[Date] AS [ToDate]
	 ,CASE WHEN L.[LeaveCombination] LIKE '%ML%' THEN CAST(L.[LeaveCombination] AS [varchar](8)) + ' (' + L.[LeaveCombination] + ')'
		 ELSE CAST(L.[NoOfWorkingDays] AS [varchar](10)) + ' (' + L.[LeaveCombination]+ ')'	END AS [LeaveInfo]
     --,CAST(L.[NoOfWorkingDays] AS [varchar](10)) + ' (' + L.[LeaveCombination] + ')' AS [LeaveInfo]
     ,L.[Reason]
	 ,L.[CreatedDate]
     ,LS.[StatusCode]
	 ,CASE
         WHEN LS.[StatusCode] = 'CA' THEN L.[ApproverRemarks]
         WHEN H.[ApproverRemarks] IS NULL THEN 'NA'
         WHEN LTRIM(RTRIM(H.[ApproverRemarks])) = '' THEN LAP.[FirstName] + ' ' + LAP.[LastName] + ': Approved'
		 WHEN (L.[ApproverId] = @AdminId AND L.[CreatedBy] = @AdminId) THEN H.[ApproverRemarks]
         ELSE LAP.[FirstName] + ' ' + LAP.[LastName] + ': ' + H.[ApproverRemarks]
      END                                                               AS [ApproverRemarks]                                                    


      ,CASE  
         WHEN LS.[StatusCode] = 'RJ' THEN LS.[Status] + ' by ' + NAP.[FirstName] + ' ' + NAP.[LastName]
         WHEN LS.[StatusCode] = 'PA' AND L.[ApproverId] != @UserId THEN LS.[Status] + ' from ' + NAP.[FirstName] + ' ' + NAP.[LastName]
         WHEN LS.[StatusCode] = 'PV' AND L.[ApproverId] != @UserId THEN LS.[Status]
         ELSE LS.[Status]  
      END                                   AS [Status]    
     ,ISNULL(UH.[StatusId], L.[StatusId])   AS [StatusId]
     ,L.[UserId]                            AS [ApplicantId]
   FROM [dbo].[LeaveRequestApplication] L WITH (NOLOCK)
	INNER JOIN [dbo].[UserDetail] E WITH (NOLOCK) ON E.[UserId] = L.[UserId]
	INNER JOIN
	(
		SELECT LD.[LeaveRequestApplicationId] AS [LeaveRequestApplicationId], MAX(LD.[LeaveRequestApplicationDetailId]) AS [LatestRecordId]                                          
		FROM [dbo].[LeaveRequestApplicationDetail] LD WITH (NOLOCK)
		INNER JOIN [dbo].[LeaveTypeMaster] LT WITH (NOLOCK) ON LT.[TypeId] = LD.[LeaveTypeId]
		WHERE LT.[ShortName] != 'WFH'
		GROUP BY LD.[LeaveRequestApplicationId]      
	) RLD ON RLD.[LeaveRequestApplicationId] = L.[LeaveRequestApplicationId]
	INNER JOIN [dbo].[LeaveRequestApplicationDetail] LD WITH (NOLOCK) ON LD.[LeaveRequestApplicationDetailId] = RLD.[LatestRecordId]
	INNER JOIN [dbo].[DateMaster] FD WITH (NOLOCK) ON FD.[DateId] = L.[FromDateId]
	INNER JOIN [dbo].[DateMaster] TD WITH (NOLOCK) ON TD.[DateId] = L.[TillDateId]
	INNER JOIN [dbo].[LeaveStatusMaster] LS WITH (NOLOCK) ON LS.[StatusId] = L.[StatusId]
	LEFT JOIN [dbo].[UserDetail] NAP WITH (NOLOCK) ON NAP.[UserId] = L.[ApproverId]
	LEFT JOIN
	(
		SELECT H.[LeaveRequestApplicationId] AS [LeaveRequestApplicationId], MAX(H.[CreatedDate]) AS [LatestModifiedTime]
		FROM [dbo].[LeaveHistory] H WITH (NOLOCK)
		GROUP BY H.[LeaveRequestApplicationId]
	) RH ON RH.[LeaveRequestApplicationId] = L.[LeaveRequestApplicationId] 
	LEFT JOIN [dbo].[LeaveHistory] H WITH (NOLOCK) ON H.[LeaveRequestApplicationId] = L.[LeaveRequestApplicationId] AND H.[CreatedDate] = RH.[LatestModifiedTime]
	LEFT JOIN [dbo].[UserDetail] LAP WITH (NOLOCK) ON LAP.[UserId] = H.[CreatedBy]
	LEFT JOIN [dbo].[LeaveHistory] UH WITH (NOLOCK) ON UH.[LeaveRequestApplicationId] = L.[LeaveRequestApplicationId] AND UH.[CreatedBy] = @UserId
   WHERE ((L.[ApproverId] = @UserId OR UH.[CreatedBy] = @UserId) 
		   OR (L.[ApproverId] = @AdminId AND L.[CreatedBy] = @AdminId 
				AND (@UserId = [dbo].[fnGetReportingManagerByUserId](L.UserId)
					 OR @UserId = [dbo].[fnGetSecondReportingManagerByUserId](L.UserId)
					 OR @UserId = [dbo].[fnGetHRIdByUserId](L.UserId))
					)
		  )
     AND FD.[Date] BETWEEN @StartDate AND @EndDate
      AND L.[UserId] != @UserId
   ORDER BY FD.[Date] DESC, E.[FirstName] + ' ' + E.[LastName]
END



GO
/****** Object:  StoredProcedure [dbo].[spGetWFHRequest]    Script Date: 09-01-2019 15:51:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetWFHRequest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGetWFHRequest] AS' 
END
GO
/***
   Created Date      :     2016-01-27
   Created By        :     Nishant Srivastava
   Purpose           :     This stored procedure retrives details for WFHs either approved or pending for approval for a user for last 6 months
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   
   --------------------------------------------------------------------------

   Test Cases        :
   --------------------------------------------------------------------------
   
   --- Test Case 1
         EXEC [dbo].[spGetWFHRequest]
           @UserId = 4,
		   @Year = 2018
   --- Test Case 2
         EXEC [dbo].[spGetWFHRequest]
           @UserId = 22  ,
		    @Year = 2018       
           
***/
ALTER PROCEDURE [dbo].[spGetWFHRequest] 
   @UserId [int],
    @Year [int]
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @StartDate [date]= (SELECT dateadd(Month,0,cast(concat(@Year,'-04-01') as date))),
		 @EndDate [date] = (SELECT dateadd(Year,1,cast(concat(@Year,'-03-31') as date)) )
	SELECT 
      L.[LeaveRequestApplicationId] AS [ApplicationId]
     ,E.[FirstName] + ' ' + E.[LastName] AS [EmployeeName]
     ,D.[Date]
     ,DW.[IsHalfDay] 
     ,L.[Reason]
	 ,L.[CreatedDate] 
	  ,CASE
         WHEN LS.[StatusCode] = 'CA' THEN L.[ApproverRemarks]
         WHEN H.[ApproverRemarks] IS NULL THEN 'NA'
         WHEN LTRIM(RTRIM(H.[ApproverRemarks])) = '' THEN LAP.[FirstName] + ' ' + LAP.[LastName] + ': Approved'
         ELSE LAP.[FirstName] + ' ' + LAP.[LastName] + ': ' + H.[ApproverRemarks]
      END  AS [ApproverRemarks]
     ,CASE  
         WHEN LS.[StatusCode] = 'RJ' THEN LS.[Status] + ' by ' + NAP.[FirstName] + ' ' + NAP.[LastName]
         WHEN LS.[StatusCode] = 'PA' AND L.[ApproverId] != @UserId THEN LS.[Status] + ' from ' + NAP.[FirstName] + ' ' + NAP.[LastName]
         WHEN LS.[StatusCode] = 'PA' AND L.[ApproverId] != @UserId THEN LS.[Status]
         ELSE LS.[Status]
      END AS [Status]
     ,ISNULL(UH.[StatusId], L.[StatusId]) AS [StatusId]
     --,L.[StatusId] AS [StatusId]
   FROM
      [dbo].[LeaveRequestApplication] L WITH (NOLOCK)
      INNER JOIN [dbo].[UserDetail] E WITH (NOLOCK) ON E.[UserId] = L.[UserId]
      INNER JOIN (SELECT LD.[LeaveRequestApplicationId] AS [LeaveRequestApplicationId],MAX(LD.[LeaveRequestApplicationDetailId])                                                                                                                AS [LatestRecordId]                                          
     FROM
                  [dbo].[LeaveRequestApplicationDetail] LD WITH (NOLOCK)
               GROUP BY
                  LD.[LeaveRequestApplicationId]      
            ) RLD
               ON RLD.[LeaveRequestApplicationId] = L.[LeaveRequestApplicationId]
         INNER JOIN
            [dbo].[LeaveRequestApplicationDetail] LD WITH (NOLOCK)
               ON LD.[LeaveRequestApplicationDetailId] = RLD.[LatestRecordId]
         INNER JOIN
            [dbo].[LeaveTypeMaster] LT WITH (NOLOCK)
               ON LT.[TypeId] = LD.[LeaveTypeId]
         INNER JOIN
            [dbo].[DateWiseLeaveType] DW WITH (NOLOCK)
               ON DW.[LeaveRequestApplicationId] = L.[LeaveRequestApplicationId]
               AND DW.[LeaveTypeId] = LT.[TypeId]
         INNER JOIN
            [dbo].[DateMaster] D WITH (NOLOCK)
               ON D.[DateId] = L.[FromDateId]
         INNER JOIN
            [dbo].[LeaveStatusMaster] LS WITH (NOLOCK)
               ON LS.[StatusId] = L.[StatusId]
         LEFT JOIN
            [dbo].[UserDetail] NAP WITH (NOLOCK)
               ON NAP.[UserId] = L.[ApproverId]
         LEFT JOIN
            (
               SELECT
                  H.[LeaveRequestApplicationId]                                                                                                                                        AS [LeaveRequestApplicationId]
                 ,MAX(H.[CreatedDate])                                                              AS [LatestModifiedTime]
               FROM
                  [dbo].[LeaveHistory] H WITH (NOLOCK)
               GROUP BY
                  H.[LeaveRequestApplicationId]
            ) RH
               ON RH.[LeaveRequestApplicationId] = L.[LeaveRequestApplicationId] 
         LEFT JOIN
            [dbo].[LeaveHistory] H WITH (NOLOCK)
               ON H.[LeaveRequestApplicationId] = L.[LeaveRequestApplicationId]
               AND H.[CreatedDate] = RH.[LatestModifiedTime]
         LEFT JOIN
            [dbo].[UserDetail] LAP WITH (NOLOCK)
               ON LAP.[UserId] = H.[CreatedBy]
         LEFT JOIN
            [dbo].[LeaveHistory] UH WITH (NOLOCK)
               ON UH.[LeaveRequestApplicationId] = L.[LeaveRequestApplicationId]
               AND UH.[CreatedBy] = @UserId
   WHERE
      (L.[ApproverId] = @UserId OR UH.[CreatedBy] = @UserId)
      AND LT.[ShortName] = 'WFH'
      AND D.[Date] BETWEEN @StartDate AND @EndDate
      AND L.[UserId] != @UserId
   ORDER BY
      D.[Date] DESC
     ,E.[FirstName] + ' ' + E.[LastName]
END
GO
