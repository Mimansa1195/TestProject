
/****** Object:  StoredProcedure [dbo].[spFetchAllEmployeesByStatus]    Script Date: 15-07-2019 17:22:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spFetchAllEmployeesByStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spFetchAllEmployeesByStatus]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetUsersLeaveBalanceForFnF]    Script Date: 15-07-2019 17:22:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetUsersLeaveBalanceForFnF]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetUsersLeaveBalanceForFnF]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetUsersDataToSendBirthdayMail]    Script Date: 15-07-2019 17:22:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetUsersDataToSendBirthdayMail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetUsersDataToSendBirthdayMail]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetLeaveHistoryForFullNFinal]    Script Date: 15-07-2019 17:22:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetLeaveHistoryForFullNFinal]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetLeaveHistoryForFullNFinal]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetLeaveHistoryForFullNFinal]    Script Date: 15-07-2019 17:22:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetLeaveHistoryForFullNFinal]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetLeaveHistoryForFullNFinal] AS' 
END
GO
/***
   Created Date      :    15-Apr-2019
   Created By        :    Kanchan Kumari
   Purpose           :    To get full and final Leave balance data for each user
   Usage             :   
						Proc_GetLeaveHistoryForFullNFinal 
						@UserId = 2395, 
						@FromDate='2018-03-01', 
						@TillDate = '2019-04-30',
						@BaseImagePath = 'http://geminisolutions.in/Images'
   --------------------------------------------------------------------------
***/
ALTER PROC [dbo].[Proc_GetLeaveHistoryForFullNFinal]
(
	@UserId INT,
	@FromDate DATE = null,
	@TillDate DATE = null,
	@BaseImagePath VARCHAR(300)
)
AS
BEGIN 
    SET FMTONLY OFF;
	SET NOCOUNT ON;

	DECLARE @DOLDate DATE, @StartDate DATE, @DOL DATE, @FTEDate DATE, @FYSDate DATE;
	DECLARE @CurrentDate DATE = GETDATE(), @SYear INT, @EYear INT, @CurrMonth INT;
	SELECT @FTEDate = ISNULL(FTEDate, JoiningDate) FROM UserDetail WHERE UserId = @UserId

	SET @StartDate = @FromDate;
	SET @DOLDate = @TillDate;
	
	SELECT @FromDate = ISNULL(@StartDate, @FTEDate)
	SELECT @TillDate = ISNULL(@DOLDate, @CurrentDate)
	
	SELECT @DOL = ISNULL(@DOLDate, GETDATE())

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
	SELECT @FYSDate = DATEFROMPARTS(@SYear, 04, 1)

	IF OBJECT_ID('tempdb..#TempLeaveType') IS NOT NULL
	DROP TABLE #TempLeaveType

	CREATE TABLE #TempLeaveType
	(
	  LeaveTypeId INT,
	  TypeName VARCHAR(20),
	  LeaveCount DECIMAL(5,1) NOT NULL DEFAULT(0),
	  Label VARCHAR(200),
	  Summary VARCHAR(MAX)
	)
	DECLARE @Gender VARCHAR(10), @Exclude VARCHAR(10), @ImagePath VARCHAR(200);
	SELECT @Gender = Gender, @ImagePath = ImagePath FROM vwAllUsers where UserId = @UserId
	SELECT @Exclude = CASE WHEN @Gender = 'Female' THEN 'PL(M)' ELSE 'ML' END


	     DECLARE @DefaultImagePath VARCHAR(300), @ProfileImagePath VARCHAR(300); 	 
		 SELECT @ProfileImagePath = @BaseImagePath+ 'ProfileImage/';
		 SELECT @DefaultImagePath =  CASE WHEN @ImagePath IS NOT NULL AND @ImagePath != '' THEN @ProfileImagePath+@ImagePath
		                                  WHEN (@ImagePath IS NULL OR @ImagePath != '') AND @Gender = 'Female' THEN @BaseImagePath+'female-employee.png'
		                                  ELSE @BaseImagePath+'male-employee.png' 
									 END 
	
	INSERT INTO #TempLeaveType(LeaveTypeId, TypeName, LeaveCount)
	SELECT LT.TypeId, LT.ShortName, L.[Count] 
	FROM LeaveBalance L JOIN LeaveTypeMaster LT 
	ON L.LeaveTypeId = LT.TypeId WHERE L.UserId = @UserId AND LT.ShortName NOT IN('CLT', '5CLOY', @Exclude) 

	INSERT INTO #TempLeaveType(LeaveTypeId, TypeName)
	VALUES(11, 'LNSA'), (12, 'OutDuty')

	IF OBJECT_ID('tempdb..#TempAllLeavesData') IS NOT NULL
	DROP TABLE #TempAllLeavesData

	CREATE TABLE #TempAllLeavesData
	(
	 UserId INT,
	 LeaveTypeId INT,
	 [NoOfDays] INT NOT NULL DEFAULT(1),
	 [Date] DATE,
	 [DateId] INT,
	 [IsHalfDay] BIT NOT NULL DEFAULT(0),
	 [StatusCode] VARCHAR(10),
	 [LapseDate] DATE NULL,
	 [IsLapsed] BIT NOT NULL DEFAULT(0),
	 [IsAvailed] BIT NOT NULL DEFAULT(0),
	)

	PRINT 'FROMDate'+CAST(@FromDate AS VARCHAR(20))
	PRINT 'TILLDATE'+CAST(@TillDate AS VARCHAR(20))

        --Leave Data
	INSERT INTO #TempAllLeavesData(UserId, LeaveTypeId, [Date], [DateId], [IsHalfDay], [StatusCode]) --LeaveStatusMaster
	SELECT L.UserId, DW.LeaveTypeId, DM.[Date], DM.DateId, DW.IsHalfDay,
			CASE WHEN S.StatusCode IN ('AP','AV') THEN 'AP' 
			WHEN S.StatusCode IN ('PA','PV') THEN 'PA' 
			WHEN S.StatusCode IN ('AVNA', 'AVNV') THEN 'PA' 
			ELSE S.StatusCode
			END
	FROM LeaveRequestApplication L 
	JOIN DateWiseLeaveType DW 
	ON L.LeaveRequestApplicationId = DW.LeaveRequestApplicationId
	JOIN DateMaster DM ON DW.DateId = DM.DateId
	JOIN LeaveStatusMaster S ON L.StatusId = S.StatusId
	WHERE L.UserId = @UserId 
	AND DM.[Date] BETWEEN @FromDate AND @TillDate

		--Legitimate Data
	INSERT INTO #TempAllLeavesData(UserId, LeaveTypeId, [Date], [DateId], [StatusCode])
	SELECT L.UserId, LT.TypeId, DM.[Date], DM.[DateId],
			CASE WHEN S.StatusCode IN ('PA','PV') THEN 'PA' 
			WHEN S.StatusCode IN ('RJM','RJH') THEN 'RJ' 
			WHEN S.StatusCode IN ('VD','AP') THEN 'AP' 
			ELSE S.StatusCode
			END
	FROM LegitimateLeaveRequest L 
	JOIN DateMaster DM ON L.DateId = DM.DateId
	JOIN LegitimateLeaveStatus S ON L.StatusId = S.StatusId 
	JOIN LeaveTypemaster LT ON L.LeaveCombination = '1 '+LT.ShortName
	WHERE L.UserId = @UserId AND DM.[Date] BETWEEN @FromDate AND @TillDate

	--LNSA Data
	INSERT INTO #TempAllLeavesData(UserId, LeaveTypeId, [Date], [DateId], [StatusCode])
	SELECT R.CreatedBy, 11, DM.[Date], DM.[DateId],
			CASE WHEN S.StatusCode IN ('PA','PV') THEN 'PA' 
			WHEN S.StatusCode IN ('VD','AP') THEN 'AP' 
			ELSE S.StatusCode
			END
	FROM DateWiseLNSA DW 
	JOIN RequestLNSA R ON DW.RequestId = R.RequestId
	JOIN DateMaster DM ON DM.DateId = DW.DateId
	JOIN LnsaStatusMaster S ON DW.StatusId = S.StatusId
	WHERE R.CreatedBy = @UserId
	AND DM.[Date] BETWEEN @FromDate AND @TillDate

	--Outing Data
	INSERT INTO #TempAllLeavesData(UserId, LeaveTypeId, [Date], [DateId], [StatusCode])
	SELECT R.UserId, 12, DM.[Date], DM.[DateId],
			CASE WHEN S.StatusCode IN ('PA','PV') THEN 'PA' 
			WHEN S.StatusCode IN ('RJM','RJH') THEN 'RJ' 
			WHEN S.StatusCode IN ('VD','AP') THEN 'AP' 
			ELSE S.StatusCode
			END
	FROM OutingRequestDetail DL 
	JOIN OutingRequest R 
	ON DL.OutingRequestId = R.OutingRequestId 
	JOIN DateMaster DM ON DL.DateId = DM.DateId
	JOIN OutingRequestStatus S ON DL.StatusId = S.StatusId
	WHERE R.UserId = @UserId 
	AND DM.[Date] BETWEEN @FromDate AND @TillDate 

	--COMPOFF Request Data
	INSERT INTO #TempAllLeavesData(UserId, LeaveTypeId, NoOfDays, [Date], [DateId], [StatusCode], [LapseDate], [IsLapsed], [IsAvailed])
	SELECT R.CreatedBy, 13, R.NoOfDays, DM.[Date], DM.[DateId],
			CASE WHEN R.StatusId = -1 THEN 'RJ' 
			WHEN R.StatusId IN (1, 2) THEN 'PA' 
			ELSE 'AP'
			END,
			LapseDate,
			IsLapsed,
			IsAvailed
		FROM RequestCompOff R
		JOIN DateMaster DM ON R.DateId = DM.DateId
		WHERE R.CreatedBy = @UserId 
		AND DM.[Date] BETWEEN @FromDate AND @TillDate

	IF OBJECT_ID('tempdb..#TempFinancialYear') IS NOT NULL
	DROP TABLE #TempFinancialYear

	CREATE TABLE #TempFinancialYear
	(
	FYId INT IDENTITY(1,1),
	[Year] INT,
	[FYName] VARCHAR(30),
	FYSDate DATE,
	FYEDate DATE,
	IsCurrentFY BIT NOT NULL DEFAULT(0)
	)
	DECLARE @StartYear INT, @EndYear INT;
	SELECT @StartYear = CASE WHEN DATEPART(m, @FromDate) < 4 THEN DATEPART(yyyy, DATEADD(yyyy, -1, @FromDate))
		                        ELSE DATEPART(yyyy, @FromDate)
								END
    SELECT @EndYear = DATEPART(yyyy, @TillDate)

	INSERT INTO #TempFinancialYear([Year])
	SELECT DATEPART(yyyy, [Date]) FROM DateMaster
	WHERE DATEPART(yyyy, [Date]) BETWEEN @StartYear AND @EndYear 
	GROUP BY DATEPART(yyyy, [Date]) ORDER BY DATEPART(yyyy, [Date]) DESC

    UPDATE #TempFinancialYear 
	SET FYSDate = DATEFROMPARTS([Year], 04, 01)
        ,FYEDate = DATEFROMPARTS([Year]+1, 03, 31)
		,FYName = CAST([Year] AS VARCHAR(10))+'-'+ CAST([Year]+1 AS VARCHAR(10))

    UPDATE #TempFinancialYear SET IsCurrentFY = 1 WHERE @DOL BETWEEN FYSDate AND FYEDate

	IF OBJECT_ID('tempdb..#TempLeaveCount') IS NOT NULL
	DROP TABLE #TempLeaveCount

	CREATE TABLE #TempLeaveCount
	(
	  UserId INT,
	  LeaveTypeId INT,
	  [FYId] INT,
	  Applied DECIMAL(5,1) NOT NULL DEFAULT(0),
	  Pending DECIMAL(5,1) NOT NULL DEFAULT(0),
	  Rejected DECIMAL(5,1) NOT NULL DEFAULT(0),
	  Cancelled DECIMAL(5,1) NOT NULL DEFAULT(0),
	  Approved DECIMAL(5,1) NOT NULL DEFAULT(0),
	  Available DECIMAL(5,1) NOT NULL DEFAULT(0),
	  Dates VARCHAR(MAX)
	)

	IF OBJECT_ID('tempdb..#TempCOFFAndLNSASummary') IS NOT NULL
	DROP TABLE #TempCOFFAndLNSASummary

	CREATE TABLE #TempCOFFAndLNSASummary
	(
	  UserId INT,
	  LeaveTypeId INT,
	  [QId] INT,
	  [Year] INT,
	  [Quarter] INT,
	  Summary VARCHAR(MAX)
	)

	IF OBJECT_ID('tempdb..#TempYearQuarter') IS NOT NULL
	DROP TABLE #TempYearQuarter

	CREATE TABLE #TempYearQuarter
	( 
	  [QId] INT IDENTITY(1,1),
	  [FYId] INT,
	  [Year] INT,
	  [Quarter] INT,
	  QStartDate DATE,
	  QEndDate DATE,
	  IsCurrentQtr BIT NOT NULL DEFAULT(0)
	)

	IF OBJECT_ID('tempdb..#TempYearWiseLeaveHistory') IS NOT NULL
	DROP TABLE #TempYearWiseLeaveHistory

	CREATE TABLE #TempYearWiseLeaveHistory
	( 
	  [FYId] INT,
	  [Year] INT,
	  [FYName] VARCHAR(100),
	  [IsCurrentFY] BIT,
	  [LeaveHistory] VARCHAR(MAX)
	)

   DECLARE @LeaveTypeId INT= 1, @LeaveType VARCHAR(10), @FromDateId INT, @TillDateId INT;
   SELECT @LeaveType = ShortName FROM LeaveTypeMaster WHERE TypeId = @LeaveTypeId
   DECLARE @Id INT = 0, @FyYear INT;
   WHILE(@Id <= (SELECT COUNT(*) FROM #TempFinancialYear))
   BEGIN  
            SELECT @FyYear = [Year] FROM #TempFinancialYear WHERE FYId = @Id
			
			---calculate leave summary
            SET @LeaveTypeId = 1;
			WHILE(@LeaveTypeId <= (SELECT MAX(LeaveTypeId) FROM #TempLeaveType))
			BEGIN
		         IF(@LeaveTypeId IN (4, 11) AND @Id > 0)
				 BEGIN
						 DECLARE @Qut INT = 1; DECLARE @Year INT;

						 SELECT @Year = [Year] FROM #TempFinancialYear WHERE FYId = @Id
						
						WHILE(@Qut <= 4)
						BEGIN

							 SELECT @FromDate = CASE WHEN @Qut = 1 THEN DATEFROMPARTS(@Year, '04', '01') 
																  WHEN @Qut = 2 THEN DATEFROMPARTS(@Year, '07', '01')
																  WHEN @Qut = 3 THEN DATEFROMPARTS(@Year, '10', '01')
																  ELSE DATEFROMPARTS(@Year+1, '01', '01')
															 END
							 SELECT @TillDate =  CASE WHEN @Qut = 1 THEN DATEFROMPARTS(@Year, '06', '30')
																  WHEN @Qut = 2 THEN DATEFROMPARTS(@Year, '09', '30')
																  WHEN @Qut = 3 THEN DATEFROMPARTS(@Year, '12', '31')
																  ELSE DATEFROMPARTS(@Year+1, '03', '31')
															 END
							SELECT @FromDateId = DateId FROM DateMaster WHERE [Date] = @FromDate
							SELECT @TillDateId = DateId FROM DateMaster WHERE [Date] = @TillDate

							IF NOT EXISTS(SELECT 1 FROM #TempYearQuarter WHERE QStartDate = @FromDate AND QEndDate = @TillDate)
						    BEGIN
								INSERT INTO #TempYearQuarter([FYId], [Year], [Quarter], QStartDate, QEndDate)
								SELECT @Id, @Year, @Qut, @FromDate, @TillDate 
						    END
				            
							DECLARE @QId INT;
							SELECT @QId = QId FROM #TempYearQuarter WHERE QStartDate = @FromDate AND QEndDate = @TillDate

							IF OBJECT_ID('tempdb..#TempCOFFAndLNSACount') IS NOT NULL
							DROP TABLE #TempCOFFAndLNSACount

							CREATE TABLE #TempCOFFAndLNSACount
							(
							  UserId INT,
							  LeaveTypeId INT,
							  Applied DECIMAL(5,1) NOT NULL DEFAULT(0),
							  Pending DECIMAL(5,1) NOT NULL DEFAULT(0),
							  Cancelled DECIMAL(5,1) NOT NULL DEFAULT(0),
							  Rejected DECIMAL(5,1) NOT NULL DEFAULT(0),
							  Approved DECIMAL(5,1) NOT NULL DEFAULT(0),
							  Lapsed DECIMAL(5,1) NOT NULL DEFAULT(0),
							  AvailedAsLeave DECIMAL(5,1) NOT NULL DEFAULT(0),
							  Available DECIMAL(5,1) NOT NULL DEFAULT(0),
							  Dates VARCHAR(MAX)
							)

							INSERT INTO #TempCOFFAndLNSACount(UserId, LeaveTypeId)
							SELECT @UserId, @LeaveTypeId

							 ---applied 
							 UPDATE T SET T.Applied = N.Applied 
							 FROM #TempCOFFAndLNSACount T 
							 JOIN
								(
								 SELECT UserId, SUM(NoOfDays) AS Applied
								 FROM #TempAllLeavesData
								 WHERE DateId BETWEEN @FromDateId AND @TillDateId 
								 AND LeaveTypeId = @LeaveTypeId
								 GROUP BY UserId
								) N ON T.UserId = N.UserId AND T.LeaveTypeId = @LeaveTypeId   

								---Rejected 
							 UPDATE T SET T.Rejected = N.Rejected 
							 FROM #TempCOFFAndLNSACount T 
							 JOIN
								(
								 SELECT UserId, SUM(NoOfDays) AS Rejected
								 FROM #TempAllLeavesData
								 WHERE DateId BETWEEN @FromDateId AND @TillDateId 
								 AND LeaveTypeId = @LeaveTypeId AND StatusCode = 'RJ'
								  GROUP BY UserId
								) N ON T.UserId = N.UserId AND T.LeaveTypeId = @LeaveTypeId 

									---Cancelled 
							 UPDATE T SET T.Cancelled = N.Cancelled 
							 FROM #TempCOFFAndLNSACount T 
							 JOIN
								(
								 SELECT UserId, SUM(NoOfDays) AS Cancelled
								 FROM #TempAllLeavesData
								 WHERE DateId BETWEEN @FromDateId AND @TillDateId 
								 AND LeaveTypeId = @LeaveTypeId AND StatusCode = 'CA'
								  GROUP BY UserId
								) N ON T.UserId = N.UserId AND T.LeaveTypeId = @LeaveTypeId 

										---Pending 
							 UPDATE T SET T.Pending = N.Pending 
							 FROM #TempCOFFAndLNSACount T 
							 JOIN
								(
								 SELECT UserId, SUM(NoOfDays) AS Pending
								 FROM #TempAllLeavesData
								 WHERE DateId BETWEEN @FromDateId AND @TillDateId 
								 AND LeaveTypeId = @LeaveTypeId AND StatusCode = 'PA'
								  GROUP BY UserId
								) N ON T.UserId = N.UserId AND T.LeaveTypeId = @LeaveTypeId  

							 ---approved
							 UPDATE T SET T.Approved = N.Approved 
							 FROM #TempCOFFAndLNSACount T 
							 JOIN
								(
								 SELECT UserId, SUM(NoOfDays) AS Approved
								 FROM #TempAllLeavesData
								 WHERE DateId BETWEEN @FromDateId AND @TillDateId 
								 AND LeaveTypeId = @LeaveTypeId AND StatusCode = 'AP'
								  GROUP BY UserId
								) N ON T.UserId = N.UserId AND T.LeaveTypeId = @LeaveTypeId 

								 ---Lapsed COFF
							 UPDATE T SET T.Lapsed = N.Lapsed 
							 FROM #TempCOFFAndLNSACount T 
							 JOIN
								(
								 SELECT UserId, SUM(NoOfDays) AS Lapsed
								 FROM #TempAllLeavesData
								 WHERE DateId BETWEEN @FromDateId AND @TillDateId 
								 AND LeaveTypeId = @LeaveTypeId AND StatusCode = 'AP' AND IsLapsed = 1 AND IsAvailed = 0
								  GROUP BY UserId
								) N ON T.UserId = N.UserId AND T.LeaveTypeId = @LeaveTypeId  

							---availed as leave COFF
							 UPDATE T SET T.AvailedAsLeave = N.AvailedAsLeave 
							 FROM #TempCOFFAndLNSACount T 
							 JOIN
								(
								 SELECT UserId, SUM(NoOfDays) AS AvailedAsLeave
								 FROM #TempAllLeavesData
								 WHERE DateId BETWEEN @FromDateId AND @TillDateId 
								 AND LeaveTypeId = @LeaveTypeId AND StatusCode = 'AP' AND IsLapsed = 0 AND IsAvailed = 1
								  GROUP BY UserId
								) N ON T.UserId = N.UserId AND T.LeaveTypeId = @LeaveTypeId 

							 ---available COFF
							 UPDATE T SET T.Available = N.Available 
							 FROM #TempCOFFAndLNSACount T 
							 JOIN
								(
								 SELECT UserId, SUM(NoOfDays) AS Available
								 FROM #TempAllLeavesData
								 WHERE DateId BETWEEN @FromDateId AND @TillDateId 
								 AND LeaveTypeId = @LeaveTypeId AND StatusCode = 'AP' AND IsLapsed = 0 AND IsAvailed = 0
								  GROUP BY UserId 
								) N ON T.UserId = N.UserId AND T.LeaveTypeId = @LeaveTypeId 
			
					  --- Dates
							 UPDATE T SET T.Dates = ISNULL(N.Dates,'')  
							 FROM #TempCOFFAndLNSACount T 
							 JOIN
								(
								 SELECT @UserId AS UserId,
								 STUFF( --Leave
								 (
								  SELECT ','+ CONVERT(VARCHAR(15), [Date], 106) 
								 FROM #TempAllLeavesData
								 WHERE DateId BETWEEN @FromDateId AND @TillDateId 
								 AND LeaveTypeId = @LeaveTypeId 
								  FOR XML PATH('')), 
								  1,1,'')
								 AS Dates
								) N ON T.UserId = N.UserId AND T.LeaveTypeId = @LeaveTypeId  

                         IF(@DOL BETWEEN @FromDate AND @TillDate)
						 UPDATE T SET T.[LeaveCount] = CASE WHEN  T.LeaveTypeId = 11 THEN LC.Approved ELSE LC.[Available] END, 
						          T.[Label] = 'From '+ CONVERT(VARCHAR(11), @FromDate, 106)+' to '+CONVERT(VARCHAR(11), @TillDate, 106)
						 FROM #TempLeaveType T JOIN #TempCOFFAndLNSACount LC ON T.LeaveTypeId = LC.LeaveTypeId

						 INSERT INTO #TempCOFFAndLNSASummary(UserId, LeaveTypeId, QId, [Year], [Quarter], Summary)
						 SELECT @UserId, @LeaveTypeId, @QId, @Year, @Qut,
						     --CASE WHEN @LeaveTypeId = 4 THEN
						   [dbo].[Fun_ConvertXmlToJsonObject](
								  (SELECT  Applied, Pending, Rejected, Cancelled, Approved, Lapsed, AvailedAsLeave, Available, Dates
									FROM #TempCOFFAndLNSACount  WHERE LeaveTypeId = @LeaveTypeId
									FOR XML PATH, root
									  )
								   ) 
								 --  ELSE
								 --  [dbo].[Fun_ConvertXmlToJsonObject](
								 -- (SELECT  Applied , Cancelled , Pending , Rejected , Approved , Dates
									--FROM #TempCOFFAndLNSACount 
									--FOR XML PATH, root
									--  )
								 --  )
								 --  END
								   AS Summary
						 FROM #TempLeaveType 
						 WHERE LeaveTypeId = @LeaveTypeId

					  SET @Qut = @Qut + 1;
				  END
				 END
				 ELSE
				 BEGIN
				         INSERT INTO #TempLeaveCount(UserId, LeaveTypeId, FYId)
					     SELECT @UserId, @LeaveTypeId, @Id FROM #TempLeaveType 
						 WHERE LeaveTypeId = @LeaveTypeId

				        IF(@Id = 0)
						BEGIN
								IF(@LeaveTypeId = 1) --CL
									 SELECT @FromDate = FYSDate FROM #TempFinancialYear WHERE IsCurrentFY = 1
								ELSE IF(@LeaveTypeId = 3) --LWP
								BEGIN
									DECLARE @LWPDateFrom DATE = DATEADD(m,-1, ISNULL(@DOLDate, @CurrentDate))
									SELECT @FromDate = DATEFROMPARTS(DATEPART(yyyy, @LWPDateFrom), DATEPART(m, @LWPDateFrom), 25)
								END
								ELSE
								BEGIN
									 SELECT @FromDate = @FTEDate
								END
									 SELECT @TillDate = ISNULL(@DOLDate, @CurrentDate)
			   	        END
						ELSE
						BEGIN
						       SELECT @FromDate = FYSDate, @TillDate = FYEDate FROM #TempFinancialYear WHERE FYId = @Id
						END		
						  
						   SELECT @FromDateId = DateId FROM DateMaster WHERE [Date] = @FromDate
						   SELECT @TillDateId = DateId FROM DateMaster WHERE [Date] = @TillDate

											 ---integer applied leave
									 UPDATE T SET T.Applied = N.Applied 
									 FROM #TempLeaveCount T 
									 JOIN
										(
										 SELECT UserId, COUNT(DateId) AS Applied
										 FROM #TempAllLeavesData
										 WHERE DateId BETWEEN @FromDateId AND @TillDateId 
										 AND LeaveTypeId = @LeaveTypeId
										 GROUP BY UserId
										) N ON T.UserId = N.UserId AND T.LeaveTypeId = @LeaveTypeId AND FYId = @Id
			
									  ---half day applied leave
									 UPDATE T SET T.Applied = T.Applied - 0.5*N.Applied 
									 FROM #TempLeaveCount T 
									 JOIN
										(
										 SELECT UserId, COUNT(DateId) AS Applied
										 FROM #TempAllLeavesData
										 WHERE DateId BETWEEN @FromDateId AND @TillDateId 
										 AND LeaveTypeId = @LeaveTypeId AND IsHalfDay = 1
										  GROUP BY UserId
										) N ON T.UserId = N.UserId AND T.LeaveTypeId = @LeaveTypeId AND FYId = @Id

										 ---integer cancelled leave
									 UPDATE T SET T.Cancelled = N.Cancelled 
									 FROM #TempLeaveCount T 
									 JOIN
										(
										 SELECT UserId, COUNT(DateId) AS Cancelled
										 FROM #TempAllLeavesData
										 WHERE DateId BETWEEN @FromDateId AND @TillDateId 
										 AND LeaveTypeId = @LeaveTypeId AND StatusCode = 'CA'
										  GROUP BY UserId
										) N ON T.UserId = N.UserId AND T.LeaveTypeId = @LeaveTypeId  AND FYId = @Id
			
									  ---half day cancelled leave
									 UPDATE T SET T.Cancelled = T.Cancelled - 0.5*N.Cancelled 
									 FROM #TempLeaveCount T 
									 JOIN
										(
										 SELECT UserId, COUNT(DateId) AS Cancelled
										 FROM #TempAllLeavesData
										 WHERE DateId BETWEEN @FromDateId AND @TillDateId 
										 AND LeaveTypeId = @LeaveTypeId AND IsHalfDay = 1 AND StatusCode = 'CA'
										  GROUP BY UserId
										) N ON T.UserId = N.UserId AND T.LeaveTypeId = @LeaveTypeId AND FYId = @Id

											 ---integer rejected leave
									 UPDATE T SET T.Rejected = N.Rejected 
									 FROM #TempLeaveCount T 
									 JOIN
										(
										 SELECT UserId, COUNT(DateId) AS Rejected
										 FROM #TempAllLeavesData
										 WHERE DateId BETWEEN @FromDateId AND @TillDateId 
										 AND LeaveTypeId = @LeaveTypeId AND StatusCode = 'RJ'
										  GROUP BY UserId
										) N ON T.UserId = N.UserId AND T.LeaveTypeId = @LeaveTypeId AND FYId = @Id 

										  ---half day rejected leave
									 UPDATE T SET T.Rejected = T.Rejected - 0.5*N.Rejected 
									 FROM #TempLeaveCount T 
									 JOIN
										(
										 SELECT UserId, COUNT(DateId) AS Rejected
										 FROM #TempAllLeavesData
										 WHERE DateId BETWEEN @FromDateId AND @TillDateId 
										 AND LeaveTypeId = @LeaveTypeId AND IsHalfDay = 1 AND StatusCode = 'RJ'
										  GROUP BY UserId
										) N ON T.UserId = N.UserId AND T.LeaveTypeId = @LeaveTypeId AND FYId = @Id
     
												 ---integer approved leave
									 UPDATE T SET T.Approved = N.Approved 
									 FROM #TempLeaveCount T 
									 JOIN
										(
										 SELECT UserId, COUNT(DateId) AS Approved
										 FROM #TempAllLeavesData
										 WHERE DateId BETWEEN @FromDateId AND @TillDateId 
										 AND LeaveTypeId = @LeaveTypeId AND StatusCode = 'AP'
										  GROUP BY UserId
										) N ON T.UserId = N.UserId AND T.LeaveTypeId = @LeaveTypeId AND FYId = @Id

											  ---half day approved leave
									 UPDATE T SET T.Approved = T.Approved - 0.5*N.Approved 
									 FROM #TempLeaveCount T 
									 JOIN
										(
										 SELECT UserId, COUNT(DateId) AS Approved
										 FROM #TempAllLeavesData
										 WHERE DateId BETWEEN @FromDateId AND @TillDateId 
										 AND LeaveTypeId = @LeaveTypeId AND IsHalfDay = 1 AND StatusCode = 'AP'
										  GROUP BY UserId
										) N ON T.UserId = N.UserId AND T.LeaveTypeId = @LeaveTypeId AND FYId = @Id

	 										 ---integer pending for approval leave
									 UPDATE T SET T.Pending = N.Pending 
									 FROM #TempLeaveCount T 
									 JOIN
										(
										 SELECT UserId, COUNT(DateId) AS Pending
										 FROM #TempAllLeavesData
										 WHERE DateId BETWEEN @FromDateId AND @TillDateId 
										 AND LeaveTypeId = @LeaveTypeId AND StatusCode = 'PA'
										  GROUP BY UserId
										) N ON T.UserId = N.UserId AND T.LeaveTypeId = @LeaveTypeId AND FYId = @Id

												  ---half pending for approval leave
									 UPDATE T SET T.Pending = T.Pending - 0.5*N.Pending 
									 FROM #TempLeaveCount T 
									 JOIN
										(
										 SELECT UserId, COUNT(DateId) AS Pending
										 FROM #TempAllLeavesData
										 WHERE DateId BETWEEN @FromDateId AND @TillDateId 
										 AND LeaveTypeId = @LeaveTypeId AND IsHalfDay = 1 AND StatusCode = 'PA'
										  GROUP BY UserId
										) N ON T.UserId = N.UserId AND T.LeaveTypeId = @LeaveTypeId AND FYId = @Id

									---leave Dates
									 UPDATE T SET T.Dates = ISNULL(N.Dates,'') 
									 FROM #TempLeaveCount T 
									 JOIN
										(
										 SELECT @UserId AS UserId,
										 STUFF( --Leave
										 (
										  SELECT ','+ CONVERT(VARCHAR(15), [Date], 106) 
										 FROM #TempAllLeavesData
										 WHERE DateId BETWEEN @FromDateId AND @TillDateId 
										 AND LeaveTypeId = @LeaveTypeId 
										  FOR XML PATH('')), 
										  1,1,'')
										 AS Dates
										) N ON T.UserId = N.UserId AND T.LeaveTypeId = @LeaveTypeId AND FYId = @Id  
						 IF(@Id = 0)
						 BEGIN
							 UPDATE T SET T.[LeaveCount] = CASE WHEN T.TypeName IN('LWP', 'OutDuty') THEN LC.Approved ELSE T.LeaveCount END,
									   T.[Label] = 
									   CASE WHEN T.TypeName = 'CL' THEN 'For FY '+ (SELECT FYName FROM #TempFinancialYear WHERE IsCurrentFY = 1)  
									   WHEN @LeaveTypeId = 3 AND T.TypeName = 'LWP'  THEN 'From '+ CONVERT(VARCHAR(11), @FromDate, 106)+ ' to '+CONVERT(VARCHAR(11), @TillDate, 106)   
									   ELSE 'From DOJ '+ CONVERT(VARCHAR(11), @FromDate, 106)+' to '+CONVERT(VARCHAR(11), @TillDate, 106)
									   END
							 FROM #TempLeaveType T JOIN #TempLeaveCount LC ON T.LeaveTypeId = LC.LeaveTypeId AND LC.LeaveTypeId = @LeaveTypeId
						END
	             END
				 SET @LeaveTypeId = @LeaveTypeId + 1;
			END

			--fetch leave history
			IF OBJECT_ID('tempdb..#TempAllLeavesHistory') IS NOT NULL
			DROP TABLE #TempAllLeavesHistory

			CREATE TABLE #TempAllLeavesHistory
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
			[LeaveCount] DECIMAL(5,1),
			[CreatedBy] INT NOT NULL
			)

			INSERT INTO #TempAllLeavesHistory
			EXEC [dbo].[spGetUserAppliedLeave] 
			 @UserId = @UserId
			,@Year= @FyYear
			,@IsWFHData = 1
			,@IsOuting = 1
			,@IsLnsa = 1
			,@IsAdvanaceLeave = 0

			INSERT INTO #TempYearWiseLeaveHistory([FYId], [Year], [FYName],[IsCurrentFY], [LeaveHistory])
			SELECT FYId, [Year], FYName, IsCurrentFY,
			 [dbo].[Fun_ConvertXmlToJson](
					   (
						SELECT [FetchLeaveType], CONVERT(VARCHAR(11),[ApplyDate],106)+' '+ FORMAT([ApplyDate], 'hh:mm tt') AS [ApplyDate],
						        [LeaveRequestApplicationId], [FromDate], 
						       [TillDate], [LeaveInfo], [Reason], [Status], [StatusFullForm], [Remarks], --[LeaveCount], 
							   CASE WHEN [IsLegitimateApplied] = 1 THEN 'Yes' ELSE 'No' END AS [LegitimateApplied],
			                   ISNULL([LegitimateAppliedOn],'NA') AS [LegitimateAppliedOn] 
			            FROM #TempAllLeavesHistory 
						FOR XML PATH, root
					   ) 
					  ) AS [LeaveHistory]
            FROM #TempFinancialYear WHERE FYId = @Id AND @Id != 0	

		 SET @Id = @Id + 1;          
   END  

   UPDATE #TempYearQuarter SET IsCurrentQtr = 1 WHERE @DOL BETWEEN QStartDate AND QEndDate

   UPDATE #TempLeaveType SET Summary = 
    [dbo].[Fun_ConvertXmlToJson](
					   (
						SELECT F.FYId, F.FYName,
						CASE WHEN F.[IsCurrentFY] = 1 THEN 'Yes' ELSE 'No' END AS [IsCurrentFY], 
						 T.Applied, T.Rejected, T.Cancelled, T.Pending, T.Approved, T.Dates   
						FROM #TempLeaveCount T JOIN #TempFinancialYear F ON T.FYId = F.FYId
						WHERE T.FYId != 0 AND T.LeaveTypeId = 1
						FOR XML PATH, root
					   ) 
					  ) 
					  WHERE TypeName = 'CL'	

	UPDATE #TempLeaveType SET Summary = 
    [dbo].[Fun_ConvertXmlToJson](
					   (
						SELECT F.FYId, F.FYName, CASE WHEN F.[IsCurrentFY] = 1 THEN 'Yes' ELSE 'No' END AS [IsCurrentFY], 
						 T.Applied, T.Rejected, T.Cancelled, T.Pending, T.Approved, T.Dates   
						FROM #TempLeaveCount T JOIN #TempFinancialYear F ON T.FYId = F.FYId
						WHERE T.FYId != 0 AND T.LeaveTypeId = 2
						FOR XML PATH, root
					   ) 
					  ) 
					  WHERE TypeName = 'PL'	

     UPDATE #TempLeaveType SET Summary = 
     [dbo].[Fun_ConvertXmlToJson](
					   (
						SELECT  F.FYId, F.FYName, CASE WHEN F.[IsCurrentFY] = 1 THEN 'Yes' ELSE 'No' END AS [IsCurrentFY], 
						T.Applied, T.Rejected, T.Cancelled, T.Pending, T.Approved, T.Dates   
						FROM #TempLeaveCount T JOIN #TempFinancialYear F ON T.FYId = F.FYId
						WHERE T.FYId != 0 AND T.LeaveTypeId = 3
						FOR XML PATH, root
					   ) 
					  )
					    WHERE TypeName = 'LWP'	

            UPDATE #TempLeaveType SET Summary = 
			[dbo].[Fun_ConvertXmlToJson](
			    (
				  SELECT  F.FYId, F.FYName, CASE WHEN F.[IsCurrentFY] = 1 THEN 'Yes' ELSE 'No' END AS [IsCurrentFY], QT.[Quarter],
				  CASE WHEN QT.[IsCurrentQtr] = 1 THEN 'Yes' ELSE 'No' END AS [IsCurrentQtr],  
				  CONVERT(VARCHAR(11), QT.QStartDate, 106) + '-'+ CONVERT(VARCHAR(11), QT.QEndDate, 106) AS QuarterName,
				  T.Summary 
                  FROM #TempCOFFAndLNSASummary T JOIN #TempFinancialYear F ON T.[Year] = F.[Year]
				  JOIN #TempYearQuarter QT ON T.[QId] = QT.[QId] 
				  WHERE LeaveTypeId = 4
				  FOR XML PATH, root
				  )
				 ) 
				  WHERE TypeName = 'COFF'	

	  UPDATE #TempLeaveType SET Summary = 
      [dbo].[Fun_ConvertXmlToJson](
					   (
						SELECT F.FYId, F.FYName, CASE WHEN F.[IsCurrentFY] = 1 THEN 'Yes' ELSE 'No' END AS [IsCurrentFY], 
						 T.Applied, T.Rejected, T.Cancelled, T.Pending, T.Approved, T.Dates   
						FROM #TempLeaveCount T JOIN #TempFinancialYear F ON T.FYId = F.FYId
						WHERE T.FYId != 0 AND T.LeaveTypeId = 5
						FOR XML PATH, root
					   ) 
					  )
					 WHERE TypeName = 'WFH'	
						
				   UPDATE #TempLeaveType SET Summary = 
                   [dbo].[Fun_ConvertXmlToJson](
					   (
						SELECT F.FYId, F.FYName, CASE WHEN F.[IsCurrentFY] = 1 THEN 'Yes' ELSE 'No' END AS [IsCurrentFY], 
						 T.Applied, T.Rejected, T.Cancelled, T.Pending, T.Approved, T.Dates   
						FROM #TempLeaveCount T JOIN #TempFinancialYear F ON T.FYId = F.FYId
						WHERE T.FYId != 0 AND (T.LeaveTypeId = 6 OR T.LeaveTypeId = 7)
						FOR XML PATH, root
					   ) 
					  )
					WHERE TypeName = 'ML' OR  TypeName = 'PL(M)'	


            UPDATE #TempLeaveType SET Summary = 
			[dbo].[Fun_ConvertXmlToJson](
			    (
				  SELECT  F.FYId, F.FYName, CASE WHEN F.[IsCurrentFY] = 1 THEN 'Yes' ELSE 'No' END AS [IsCurrentFY], QT.[QId], T.[Quarter],   
				  CASE WHEN QT.[IsCurrentQtr] = 1 THEN 'Yes' ELSE 'No' END AS [IsCurrentQtr],  
				  CONVERT(VARCHAR(11), QT.QStartDate, 106) + '-'+ CONVERT(VARCHAR(11), QT.QEndDate, 106) AS QuarterName,
				   T.Summary 
                  FROM #TempCOFFAndLNSASummary T JOIN #TempFinancialYear F ON T.[Year] = F.[Year]
				  JOIN #TempYearQuarter QT ON T.[QId] = QT.[QId] 
				  WHERE LeaveTypeId = 11
				  FOR XML PATH, root
				  )
				 ) 
				  WHERE TypeName = 'LNSA'	

					
				  UPDATE #TempLeaveType SET Summary = 
                  [dbo].[Fun_ConvertXmlToJson](
					   (
						SELECT  F.FYId, F.FYName, CASE WHEN F.[IsCurrentFY] = 1 THEN 'Yes' ELSE 'No' END AS [IsCurrentFY],  
						 T.Applied, T.Rejected, T.Cancelled, T.Pending, T.Approved, T.Dates   
						FROM #TempLeaveCount T JOIN #TempFinancialYear F ON T.FYId = F.FYId
						WHERE T.FYId != 0 AND T.LeaveTypeId =12
						FOR XML PATH, root
					   ) 
					  )
					WHERE TypeName = 'OutDuty' 			

    SELECT 
	      [dbo].[Fun_ConvertXmlToJsonObject](
			    (
			SELECT
	         [dbo].[Fun_ConvertXmlToJsonObject](
			    (
				 SELECT EmployeeName, EmployeeCode, ReportingManagerName, Gender, Designation, Department, Team, 
				 CONVERT(VARCHAR(11),@FTEDate,106) AS JoiningDate, @DefaultImagePath AS ImagePath,
				 CASE WHEN IsIntern = 0 THEN 'No' 
				      ELSE 'Yes' 
					  END AS IsIntern
				  FROM vwAllUsers WHERE UserId = @UserId
				  FOR XML PATH, root
				  )
				  ) AS UserSummary
				  ,
	         [dbo].[Fun_ConvertXmlToJson](
			    (
				  SELECT TypeName AS LeaveType, LeaveCount, Label
				  FROM #TempLeaveType
				  FOR XML PATH, root
				  )
				  ) AS LeaveBalanceSummary
				  ,
				
				 [dbo].[Fun_ConvertXmlToJson](
			    (
				  SELECT TypeName AS LeaveType, Summary FROM #TempLeaveType
				  FOR XML PATH, root
				 )
				 ) AS LeaveSummary
				 ,

				[dbo].[Fun_ConvertXmlToJson](
			    (
				  SELECT F.FYId, F.FYName, CASE WHEN F.IsCurrentFY = 1 THEN 'Yes' ELSE 'No' END AS IsCurrentFY,
				   F.[Year], F.[FYSDate], F.[FYEDate]
                  FROM #TempFinancialYear F
				  FOR XML PATH, root
				  )
				 ) AS FYSummary
				 ,
				 [dbo].[Fun_ConvertXmlToJson](
			    (
				  SELECT T.QId, F.[FYId], F.[FYName],
				   T.[Quarter], CONVERT(VARCHAR(11), T.QStartDate, 106) + '-'+ CONVERT(VARCHAR(11), T.QEndDate, 106) AS QuarterName, 
				    CASE WHEN T.IsCurrentQtr = 1 THEN 'Yes' ELSE 'No' END AS IsCurrentQtr
                  FROM #TempYearQuarter T JOIN #TempFinancialYear F ON T.FYId = F.FYId
				  FOR XML PATH, root
				  )
				 ) AS FYWsieQuarterSummary

            FOR XML PATH, root
          )
		  )
		  AS Summary
		  ,
		  [dbo].[Fun_ConvertXmlToJson](
			    (
				 SELECT FYId, [FYName], 
					    CASE WHEN [IsCurrentFY] = 0 THEN 'No' 
					    ELSE 'Yes' END AS [IsCurrentFY]
					   ,LeaveHistory
				 FROM #TempYearWiseLeaveHistory ORDER BY [Year] DESC
 				 FOR XML PATH, root
				  )
				 ) AS Detail
END				
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetUsersDataToSendBirthdayMail]    Script Date: 15-07-2019 17:22:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetUsersDataToSendBirthdayMail]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetUsersDataToSendBirthdayMail] AS' 
END
GO
/***
	Created Date :  26-Jun-2019
	Created By   :  Kanchan Kumari
	Purpose      :  Fetch users detail to send birthday mail
	Usage        :  EXEC  Proc_GetUsersDataToSendBirthdayMail
	
***/
ALTER PROC [dbo].[Proc_GetUsersDataToSendBirthdayMail]
AS
BEGIN
    SELECT V.EmployeeName, V.EmployeeFirstName, V.EmployeeLastName, V.EmailId, UD.DOB, UD.ExtensionNumber, UD.ImagePath, V.Gender 
	FROM vwActiveUsers V JOIN UserDetail UD ON V.UserId = UD.UserId
END
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetUsersLeaveBalanceForFnF]    Script Date: 15-07-2019 17:22:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetUsersLeaveBalanceForFnF]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetUsersLeaveBalanceForFnF] AS' 
END
GO
/***
   Created Date      :    2-July-2019
   Created By        :    Kanchan Kumari
   Purpose           :    To get full and final Leave balance data for each user
   Usage             :   
						Proc_GetUsersLeaveBalanceForFnF 
						@UserId = 2395, 
						@DOL='2018-03-01', 
						@FetchForId = 1
   --------------------------------------------------------------------------
***/
ALTER PROC [dbo].[Proc_GetUsersLeaveBalanceForFnF]
(
  @UserId INT
 ,@DOL DATE 
 ,@FetchForId INT  -- 1-show summary, 2-show detail
)
AS
BEGIN
     SET FMTONLY OFF;
	 SET NOCOUNT ON;

	 IF OBJECT_ID('tempdb..#TempLeaveTypeCount') IS NOT NULL
	 DROP TABLE #TempLeaveTypeCount

	  IF OBJECT_ID('tempdb..#TempQtrWiseLeaveCount') IS NOT NULL
	 DROP TABLE #TempQtrWiseLeaveCount

	  IF OBJECT_ID('tempdb..#TempMonthWiseLWP') IS NOT NULL
	 DROP TABLE #TempMonthWiseLWP

     DECLARE @GenderId int      --1-Male, 2-Female

	 SELECT @GenderId = GenderId FROM vwAllUsers WHERE UserId = @UserId 

	 CREATE TABLE #TempLeaveTypeCount
	 (
	  LeaveTypeId INT,
	  ShortName VARCHAR(10),
	  [Count] FLOAT DEFAULT(0) NOT NULL
	 )

	 INSERT INTO #TempLeaveTypeCount(LeaveTypeId, ShortName, [Count])
	 SELECT LT.TypeId, LT.ShortName, LB.[Count] 
	 FROM LeaveBalance LB JOIN LeaveTypeMaster LT 
	 ON LB.LeaveTypeId = LT.TypeId  
	 WHERE LB.UserId = @UserId AND LT.ShortName NOT IN('LWP','COFF', '5CLOY', 'WFH', 'CLT') 
	 AND LT.ShortName ! = CASE WHEN @GenderId = 1 THEN 'ML' ELSE 'PL(M)' END 

	 DECLARE  @PrevQtrFromDate DATE,@PrevQtrTillDate DATE, @CurrtQtrFromDate DATE, @CurrtQtrTillDate DATE 

	   SELECT @PrevQtrFromDate = DATEADD(qq, DATEDIFF(qq, 0, @DOL) - 1, 0)
            ,@PrevQtrTillDate = DATEADD(dd, -1, DATEADD(qq, DATEDIFF(qq, 0, @DOL), 0))
            ,@CurrtQtrFromDate = DATEADD(qq, DATEDIFF(qq, 0, @DOL), 0)
            ,@CurrtQtrTillDate = DATEADD (dd, -1, DATEADD(qq, DATEDIFF(qq, 0, @DOL) +1, 0))
     	       

	  CREATE TABLE #TempQtrWiseLeaveCount
	  (
	  ShortName VARCHAR(10),
	  Qtr VARCHAR(10),
	  FromDate DATE,
	  TillDate DATE,
	  Pending FLOAT NOT NULL DEFAULT(0),
	  PendingDates VARCHAR(max),
	  Lapsed FLOAT NOT NULL DEFAULT(0),
	  LapsedDates VARCHAR(max),
	  Available FLOAT NOT NULL DEFAULT(0),
	  AvailableDates VARCHAR(max),
	  Approved FLOAT NOT NULL DEFAULT(0),
	  ApprovedDates VARCHAR(max)
	 )

	 INSERT INTO #TempQtrWiseLeaveCount(ShortName, Qtr, FromDate, TillDate)
	 VALUES ('COFF', 'Previous', @PrevQtrFromDate, @PrevQtrTillDate),('COFF', 'Current', @CurrtQtrFromDate, @CurrtQtrTillDate)
	       ,('LNSA','Previous', @PrevQtrFromDate, @PrevQtrTillDate),('LNSA',  'Current', @CurrtQtrFromDate, @CurrtQtrTillDate)

---------------COFF-------------------------------
   
    --pending
    UPDATE #TempQtrWiseLeaveCount SET Pending =  
	ISNULL( 
	(SELECT SUM(NoOfDays) AS [Count] FROM RequestCompOff R 
	WHERE StatusId IN(1,2) AND CreatedBy = @UserId 
	AND LapseDate BETWEEN @PrevQtrFromDate AND @PrevQtrTillDate 
	),0)
	WHERE ShortName = 'COFF' AND Qtr = 'Previous'

	---Dates
	UPDATE #TempQtrWiseLeaveCount SET PendingDates =  
	((SELECT STUFF( --Leave
		   (SELECT ','+ CONVERT(VARCHAR(15), DM.[Date], 106)  
	        FROM RequestCompOff R 
			JOIN DateMaster DM ON R.DateId = DM.DateId
	        WHERE StatusId IN(1,2) AND CreatedBy = @UserId 
	AND LapseDate BETWEEN @PrevQtrFromDate AND @PrevQtrTillDate 
	 FOR XML PATH('')), 
	  1,1,'')
	))
	WHERE ShortName = 'COFF' AND Qtr = 'Previous'


	UPDATE #TempQtrWiseLeaveCount SET Pending =  
	ISNULL(
	(SELECT SUM(NoOfDays) AS [Count] FROM RequestCompOff R 
	WHERE StatusId IN(1,2) AND CreatedBy = @UserId 
	AND LapseDate >= @CurrtQtrFromDate 
	)
	,0)
	WHERE ShortName = 'COFF' AND Qtr = 'Current'

	---Dates
	UPDATE #TempQtrWiseLeaveCount SET PendingDates =  
	((SELECT STUFF( --Leave
		   (SELECT ','+ CONVERT(VARCHAR(15), DM.[Date], 106)  
	        FROM RequestCompOff R 
			JOIN DateMaster DM ON R.DateId = DM.DateId
	   WHERE StatusId IN(1,2) AND CreatedBy = @UserId 
	AND LapseDate >= @CurrtQtrFromDate 
	 FOR XML PATH('')), 
	  1,1,'')
	))
	WHERE ShortName = 'COFF' AND Qtr = 'Current'


   --lapsed
	UPDATE #TempQtrWiseLeaveCount SET Lapsed =  
	ISNULL(
	( SELECT SUM(NoOfDays) AS [Count] FROM RequestCompOff R 
	  WHERE StatusId > 2 AND CreatedBy = @UserId AND IsAvailed = 0 AND IsLapsed = 1
	 AND LapseDate BETWEEN @PrevQtrFromDate AND @PrevQtrTillDate 
	),0)
	WHERE ShortName = 'COFF' AND Qtr = 'Previous'

		---Dates
	UPDATE #TempQtrWiseLeaveCount SET LapsedDates =  
	((SELECT STUFF( --Leave
		   (SELECT ','+ CONVERT(VARCHAR(15), DM.[Date], 106)  
	        FROM RequestCompOff R 
			JOIN DateMaster DM ON R.DateId = DM.DateId
	        WHERE StatusId > 2 AND CreatedBy = @UserId AND IsAvailed = 0 AND IsLapsed = 1
	              AND LapseDate BETWEEN @PrevQtrFromDate AND @PrevQtrTillDate 
	 FOR XML PATH('')), 
	  1,1,'')
	))
	WHERE ShortName = 'COFF' AND Qtr = 'Previous'


	UPDATE #TempQtrWiseLeaveCount SET Lapsed =  
	ISNULL(
	( SELECT SUM(NoOfDays) AS [Count] FROM RequestCompOff R 
	  WHERE StatusId > 2 AND CreatedBy = @UserId AND IsAvailed = 0 AND IsLapsed = 1
	  AND LapseDate BETWEEN @CurrtQtrFromDate AND @DOL 
	),0)
	WHERE ShortName = 'COFF' AND Qtr = 'Current'

		---Dates
	UPDATE #TempQtrWiseLeaveCount SET LapsedDates =  
	((SELECT STUFF( --Leave
		   (SELECT ','+ CONVERT(VARCHAR(15), DM.[Date], 106)  
	        FROM RequestCompOff R 
			JOIN DateMaster DM ON R.DateId = DM.DateId
	        WHERE StatusId > 2 AND CreatedBy = @UserId AND IsAvailed = 0 AND IsLapsed = 1
	              AND LapseDate BETWEEN @CurrtQtrFromDate AND @DOL 
	 FOR XML PATH('')), 
	  1,1,'')
	))
	WHERE ShortName = 'COFF' AND Qtr = 'Current'

    ---available
	UPDATE #TempQtrWiseLeaveCount SET Available =  
	ISNULL(
	( SELECT SUM(NoOfDays) AS [Count] FROM RequestCompOff R 
	  WHERE StatusId = 3 AND CreatedBy = @UserId AND IsAvailed = 0 AND IsLapsed = 0
	  AND LapseDate >= @CurrtQtrFromDate 
	),0)
	WHERE ShortName = 'COFF' AND Qtr = 'Current'

		---Dates
	UPDATE #TempQtrWiseLeaveCount SET AvailableDates =  
	((SELECT STUFF( --Leave
		   (SELECT ','+ CONVERT(VARCHAR(15), DM.[Date], 106)  
	        FROM RequestCompOff R 
			JOIN DateMaster DM ON R.DateId = DM.DateId
	        WHERE StatusId = 3 AND CreatedBy = @UserId AND IsAvailed = 0 AND IsLapsed = 0
	              AND LapseDate >= @CurrtQtrFromDate 
	 FOR XML PATH('')), 
	  1,1,'')
	))
	WHERE ShortName = 'COFF' AND Qtr = 'Current'


----------------LNSA------------------------------

DECLARE @PrevFromDateId BIGINT, @PrevTillDateId BIGINT, @CurrFromDateId BIGINT, @CurrTillDateId BIGINT, @DOLId INT
 
	  SELECT @PrevFromDateId = Min(DateId), @PrevTillDateId = max(DateId)  FROM DateMaster 
	  WHERE [Date] BETWEEN @PrevQtrFromDate AND @PrevQtrTillDate

	  SELECT @CurrFromDateId = Min(DateId), @CurrTillDateId = max(DateId)  FROM DateMaster 
	  WHERE [Date] BETWEEN @CurrtQtrFromDate AND @CurrtQtrTillDate

	  SELECT @DOLId = DateId FROM DateMaster 
	  WHERE [Date] = @DOL

   --pending
    UPDATE #TempQtrWiseLeaveCount SET Pending =  
	ISNULL(
	(SELECT COUNT(D.DateId) AS [Count] FROM DateWiseLNSA D
	 WHERE D.StatusId IN(1,2) AND CreatedBy = @UserId 
	 AND DateId BETWEEN @PrevFromDateId AND @PrevTillDateId 
	),0)
	WHERE ShortName = 'LNSA' AND Qtr = 'Previous'

		---Dates
	UPDATE #TempQtrWiseLeaveCount SET PendingDates =  
	((SELECT STUFF( --Leave
		   (SELECT ','+ CONVERT(VARCHAR(15), DM.[Date], 106)  
	         FROM DateWiseLNSA D
			 JOIN DateMaster DM ON D.DateId = DM.DateId
	 WHERE D.StatusId IN(1,2) AND CreatedBy = @UserId 
	 AND D.DateId BETWEEN @PrevFromDateId AND @PrevTillDateId 
	 FOR XML PATH('')), 
	  1,1,'')
	))
    WHERE ShortName = 'LNSA' AND Qtr = 'Previous'


	UPDATE #TempQtrWiseLeaveCount SET Pending =  
	ISNULL(
	(SELECT COUNT(D.DateId) AS [Count] FROM DateWiseLNSA D
	 WHERE D.StatusId IN(1,2) AND CreatedBy = @UserId 
	 AND DateId BETWEEN @CurrFromDateId AND @DOLId 
	),0)
	WHERE ShortName = 'LNSA' AND Qtr = 'Current'

		---Dates
	UPDATE #TempQtrWiseLeaveCount SET PendingDates =  
	((SELECT STUFF( --Leave
		   (SELECT ','+ CONVERT(VARCHAR(15), DM.[Date], 106)  
	         FROM DateWiseLNSA D
			 JOIN DateMaster DM ON D.DateId = DM.DateId
	 WHERE D.StatusId IN(1,2) AND CreatedBy = @UserId 
	 AND D.DateId BETWEEN @CurrFromDateId AND @DOLId  
	 FOR XML PATH('')), 
	  1,1,'')
	))
    WHERE ShortName = 'LNSA' AND Qtr = 'Current'


   --approved
	UPDATE #TempQtrWiseLeaveCount SET Approved =  
	ISNULL(
	(SELECT COUNT(D.DateId) AS [Count] FROM DateWiseLNSA D ---LNSAStatusMaster
	 WHERE D.StatusId = 3 AND CreatedBy = @UserId 
	 AND DateId BETWEEN @PrevFromDateId AND @PrevTillDateId 
	),0)
	WHERE ShortName = 'LNSA' AND Qtr = 'Previous'

		---Dates
	UPDATE #TempQtrWiseLeaveCount SET ApprovedDates =  
	((SELECT STUFF( --Leave
		   (SELECT ','+ CONVERT(VARCHAR(15), DM.[Date], 106)  
	         FROM DateWiseLNSA D
			 JOIN DateMaster DM ON D.DateId = DM.DateId
	 WHERE D.StatusId = 3 AND CreatedBy = @UserId 
	 AND D.DateId BETWEEN @PrevFromDateId AND @PrevTillDateId 
	 FOR XML PATH('')), 
	  1,1,'')
	))
    WHERE ShortName = 'LNSA' AND Qtr = 'Previous'


	UPDATE #TempQtrWiseLeaveCount SET Approved =  
	ISNULL(
	(SELECT COUNT(D.DateId) AS [Count] FROM DateWiseLNSA D
	 WHERE D.StatusId = 3  AND CreatedBy = @UserId 
	 AND DateId BETWEEN @CurrFromDateId AND @DOLId 
	),0)
	WHERE ShortName = 'LNSA' AND Qtr = 'Current'

		---Dates
	UPDATE #TempQtrWiseLeaveCount SET ApprovedDates =  
	((SELECT STUFF( --Leave
		   (SELECT ','+ CONVERT(VARCHAR(15), DM.[Date], 106)  
	         FROM DateWiseLNSA D
			 JOIN DateMaster DM ON D.DateId = DM.DateId
	 WHERE D.StatusId = 3  AND CreatedBy = @UserId 
	 AND D.DateId BETWEEN @CurrFromDateId AND @DOLId 
	 FOR XML PATH('')), 
	  1,1,'')
	))
    WHERE ShortName = 'LNSA' AND Qtr = 'Current'

---------------LWP-----------------------

DECLARE @PrevMonthFromDate DATE, @PrevMonthTillDate DATE, @CurrtMonthFromDate DATE, @PrevMonthFromDateId BIGINT, @PrevMonthTillDateId BIGINT, @CurrtMonthFromId BIGINT,
        @Prev2MonthDate DATE = DATEADD(m, -2, @DOL), @Prev1MonthDate DATE = DATEADD(m, -1, @DOL)


	SELECT @PrevMonthFromDate =  DATEFROMPARTS(DATEPART(yyyy, @Prev2MonthDate), DATEPART(m, @Prev2MonthDate), 25) 
	SELECT @PrevMonthTillDate =  DATEFROMPARTS(DATEPART(yyyy, @Prev1MonthDate), DATEPART(m, @Prev1MonthDate), 24) 
	SELECT @CurrtMonthFromDate = DATEFROMPARTS(DATEPART(yyyy, @Prev1MonthDate), DATEPART(m, @Prev1MonthDate), 25) 

	SELECT @PrevMonthFromDateId = Min(DateId), @PrevTillDateId = max(DateId)  FROM DateMaster 
	WHERE [Date] BETWEEN @PrevMonthFromDate AND @PrevMonthTillDate

	SELECT @CurrtMonthFromId = DateId FROM DateMaster 
	WHERE [Date] = @CurrtMonthFromDate

CREATE TABLE #TempMonthWiseLWP
(
 ShortName VARCHAR(10),
 [Month] VARCHAR(10),
 FromDate DATE,
 TillDate DATE,
 [Count] FLOAT NOT NULL DEFAULT(0),
 Dates VARCHAR(MAX) 
)

	INSERT INTO #TempMonthWiseLWP(ShortName, [Month], FromDate, TillDate)
	VALUES('LWP','Previous',@PrevMonthFromDate, @PrevMonthTillDate)
	,('LWP','Current', @CurrtMonthFromDate, @DOL)

 --approved
	UPDATE #TempMonthWiseLWP SET [Count] =  
	ISNULL(
	(SELECT COUNT(D.DateId) AS [Count] 
	   FROM DateWiseLeaveType D JOIN LeaveRequestApplication L
	        ON D.LeaveRequestApplicationId = L.LeaveRequestApplicationId  --- LeaveTypeMaster 3- LWP LeaveStatusMaster
	   LEFT JOIN LegitimateLeaveRequest LR
	        ON D.LeaveRequestApplicationId = LR.LeaveRequestApplicationId 
	           AND D.DateId = LR.DateId AND LR.StatusId < 5 
	   WHERE D.LeaveTypeId = 3 AND L.StatusId > 0 AND L.UserId = @UserId 
	         AND L.IsActive = 1 AND LR.DateId IS NULL AND D.DateId BETWEEN @PrevFromDateId AND @PrevTillDateId
	),0)
	-
	(0.5)*(
	ISNULL(
	(SELECT COUNT(D.DateId) AS [Count] 
	  FROM DateWiseLeaveType D JOIN LeaveRequestApplication L
	   ON D.LeaveRequestApplicationId = L.LeaveRequestApplicationId ---LeaveTypeMaster 3- LWP LeaveStatusMaster
	 WHERE L.StatusId > 0 AND L.UserId = @UserId AND L.IsActive = 1
	  AND D.LeaveTypeId = 3 AND D.DateId BETWEEN @PrevFromDateId AND @PrevTillDateId AND D.IsHalfDay = 1 
	),0)
	)
	WHERE ShortName = 'LWP' AND [Month] = 'Previous'


	---Dates
	UPDATE #TempMonthWiseLWP SET [Dates] =  
	(SELECT STUFF( --Leave
		   (SELECT ','+ CONVERT(VARCHAR(15), DM.[Date], 106)  
	        FROM DateWiseLeaveType D JOIN LeaveRequestApplication L
	             ON D.LeaveRequestApplicationId = L.LeaveRequestApplicationId 
			INNER JOIN DateMaster DM ON D.DateId = DM.DateId 
			LEFT JOIN LegitimateLeaveRequest LR
	             ON D.LeaveRequestApplicationId = LR.LeaveRequestApplicationId 
	                AND D.DateId = LR.DateId AND LR.StatusId < 5 
	        WHERE D.LeaveTypeId = 3 AND L.StatusId > 0 AND L.UserId = @UserId AND L.IsActive = 1
	             AND LR.DateId IS NULL AND D.DateId BETWEEN @PrevFromDateId AND @PrevTillDateId
	  FOR XML PATH('')), 
	  1,1,'')
	)
	WHERE ShortName = 'LWP' AND [Month] = 'Previous'

	--------------------------------------------------------------------------------------

	UPDATE #TempMonthWiseLWP SET [Count] =  
	ISNULL(
	(SELECT COUNT(D.DateId) AS [Count] 
	   FROM DateWiseLeaveType D JOIN LeaveRequestApplication L
	        ON D.LeaveRequestApplicationId = L.LeaveRequestApplicationId  --- LeaveTypeMaster 3- LWP LeaveStatusMaster
	   LEFT JOIN LegitimateLeaveRequest LR
	        ON D.LeaveRequestApplicationId = LR.LeaveRequestApplicationId 
	           AND D.DateId = LR.DateId AND LR.StatusId < 5 
	   WHERE D.LeaveTypeId = 3 AND L.StatusId > 0 AND L.UserId = @UserId 
	         AND L.IsActive = 1 AND LR.DateId IS NULL AND D.DateId BETWEEN @CurrFromDateId AND @DOLId
	),0)
	-
	(0.5)*(
	ISNULL(
	(SELECT COUNT(D.DateId) AS [Count] 
	  FROM DateWiseLeaveType D JOIN LeaveRequestApplication L
	   ON D.LeaveRequestApplicationId = L.LeaveRequestApplicationId ---LeaveTypeMaster 3- LWP LeaveStatusMaster
	 WHERE L.StatusId > 0 AND L.UserId = @UserId AND L.IsActive = 1
	  AND D.LeaveTypeId = 3 AND D.DateId BETWEEN @CurrFromDateId AND @DOLId AND D.IsHalfDay = 1 
	),0)
	)
	WHERE ShortName = 'LWP' AND [Month] = 'Current'

	---Dates
	UPDATE #TempMonthWiseLWP SET [Dates] =  
	(SELECT STUFF( --Leave
		   (SELECT ','+ CONVERT(VARCHAR(15), DM.[Date], 106)  
	        FROM DateWiseLeaveType D JOIN LeaveRequestApplication L
	             ON D.LeaveRequestApplicationId = L.LeaveRequestApplicationId 
			INNER JOIN DateMaster DM ON D.DateId = DM.DateId 
			LEFT JOIN LegitimateLeaveRequest LR
	             ON D.LeaveRequestApplicationId = LR.LeaveRequestApplicationId 
	                AND D.DateId = LR.DateId AND LR.StatusId < 5 
	        WHERE D.LeaveTypeId = 3 AND L.StatusId > 0 AND L.UserId = @UserId AND L.IsActive = 1
	             AND LR.DateId IS NULL AND D.DateId BETWEEN @CurrFromDateId AND @DOLId
	  FOR XML PATH('')), 
	  1,1,'')
	)
	WHERE ShortName = 'LWP' AND [Month] = 'Current'

	IF OBJECT_ID('tempdb..#TempSummary') IS NOT NULL
	DROP TABLE #TempSummary

	CREATE TABLE #TempSummary
	( 
	 ShortName VARCHAR(100),
	 Summary VARCHAR(MAX)
	)

	IF(@FetchForId = 1)
	BEGIN
	     INSERT INTO #TempSummary(ShortName, Summary)
	     SELECT ShortName, [Count] FROM #TempLeaveTypeCount

		 INSERT INTO #TempSummary(ShortName, Summary)
	     SELECT ShortName+'(From '+ CONVERT(VARCHAR(11),FromDate,106) +')' 
		 ,'Lapsed -'+ CAST(Lapsed AS VARCHAR(5))+ ','+ 'Pending -'+ CAST(Pending AS VARCHAR(5))+ ','+ 'Available -'+ CAST(Available AS VARCHAR(5)) +','+ 'Total -'+ CAST( (Lapsed+ Pending + Available) AS VARCHAR(5))  
		 AS SUMMARY
		 FROM #TempQtrWiseLeaveCount WHERE Qtr = 'Current' AND ShortName = 'COFF'

		 INSERT INTO #TempSummary(ShortName, Summary)
	     SELECT ShortName+'(From '+ CONVERT(VARCHAR(11),FromDate,106) +')' 
		 ,'Approved -'+ CAST(Approved AS VARCHAR(5))+ ','+ 'Pending -'+ CAST(Pending AS VARCHAR(5)) +','+ 'Total -'+ CAST( (Pending + Approved) AS VARCHAR(5))  
		 AS SUMMARY
		 FROM #TempQtrWiseLeaveCount WHERE Qtr = 'Current' AND ShortName = 'LNSA'

		 INSERT INTO #TempSummary(ShortName, Summary)
	     SELECT ShortName+'(From '+ CONVERT(VARCHAR(11),FromDate,106) +')', [Count]
		 FROM #TempMonthWiseLWP WHERE [Month] = 'Current'

		 INSERT INTO #TempSummary(ShortName, Summary)
	     SELECT ShortName+' Dates', Dates
		 FROM #TempMonthWiseLWP WHERE [Month] = 'Current'

		SELECT ShortName AS LeaveTypes, Summary FROM #TempSummary
   END
END
GO
/****** Object:  StoredProcedure [dbo].[spFetchAllEmployeesByStatus]    Script Date: 15-07-2019 17:22:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spFetchAllEmployeesByStatus]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spFetchAllEmployeesByStatus] AS' 
END
GO
/***
   Created Date      :     2016-06-10
   Created By        :     Shubhra Upadhyay
   Purpose           :     This stored proc is used to fetch all employees with a specific status(1: active, 2: inactive)
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   --- Test Case 1
         EXEC [dbo].[spFetchAllEmployeesByStatus] @Status = 1
   --- Test Case 2
         EXEC [dbo].[spFetchAllEmployeesByStatus] @Status = 2
***/
ALTER PROCEDURE [dbo].[spFetchAllEmployeesByStatus] 
(
   @Status [int] --1: active, 2: inactive
) 
AS
BEGIN
SET NOCOUNT ON;

	SELECT
	UD.[UserId] AS [UserId],
	LTRIM(RTRIM(REPLACE(REPLACE(REPLACE((UD.[FirstName] + ' ' + UD.[MiddleName] + ' ' + UD.[LastName]), ' ', '{}'), '}{',''), '{}', ' '))) AS [Name]
	,UD.[EmployeeId] AS [EmployeeId]
	,UD.[EmailId] AS [EmailId]
	,UD.JoiningDate
	FROM [dbo].[UserDetail] UD WITH (NOLOCK)
	JOIN [dbo].[User] U WITH (NOLOCK) ON UD.[UserId] = U.[UserId]
	WHERE U.[RoleId]<>1 AND
	((UD.[TerminateDate] IS NULL AND U.[IsActive]=1) AND @Status = 1) OR ((UD.[TerminateDate] IS NOT NULL OR U.[IsActive]=0) AND @Status = 2)
	ORDER BY LTRIM(RTRIM(REPLACE(REPLACE(REPLACE((UD.[FirstName] + ' ' + UD.[MiddleName] + ' ' + UD.[LastName]), ' ', '{}'), '}{',''), '{}', ' ')))
END
GO
