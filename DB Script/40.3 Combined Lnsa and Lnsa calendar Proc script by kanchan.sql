
/****** Object:  StoredProcedure [dbo].[spTakeActionOnLnsaRequest]    Script Date: 11-12-2018 16:58:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spTakeActionOnLnsaRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spTakeActionOnLnsaRequest]
GO
/****** Object:  StoredProcedure [dbo].[spImportUserShiftMapping]    Script Date: 11-12-2018 16:58:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spImportUserShiftMapping]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spImportUserShiftMapping]
GO
/****** Object:  StoredProcedure [dbo].[spFetchLastNApprovedLnsa]    Script Date: 11-12-2018 16:58:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spFetchLastNApprovedLnsa]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spFetchLastNApprovedLnsa]
GO
/****** Object:  StoredProcedure [dbo].[spFetchAllPendingLnsaRequestByManagerId]    Script Date: 11-12-2018 16:58:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spFetchAllPendingLnsaRequestByManagerId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spFetchAllPendingLnsaRequestByManagerId]
GO
/****** Object:  StoredProcedure [dbo].[spFetchAllLnsaRequestStatusByUserId]    Script Date: 11-12-2018 16:58:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spFetchAllLnsaRequestStatusByUserId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spFetchAllLnsaRequestStatusByUserId]
GO
/****** Object:  StoredProcedure [dbo].[spFetchAllApprovedLnsaRequest]    Script Date: 11-12-2018 16:58:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spFetchAllApprovedLnsaRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spFetchAllApprovedLnsaRequest]
GO
/****** Object:  StoredProcedure [dbo].[Proc_MapLnsaShift]    Script Date: 11-12-2018 16:58:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_MapLnsaShift]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_MapLnsaShift]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetShiftMappingDetails]    Script Date: 11-12-2018 16:58:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetShiftMappingDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetShiftMappingDetails]
GO
/****** Object:  UserDefinedFunction [dbo].[Fn_GetEligibleUserForLNSA]    Script Date: 11-12-2018 16:58:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fn_GetEligibleUserForLNSA]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fn_GetEligibleUserForLNSA]
GO
/****** Object:  UserDefinedFunction [dbo].[Fn_GetEligibleUserForLNSA]    Script Date: 11-12-2018 16:58:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fn_GetEligibleUserForLNSA]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/***
   Created Date      :     2018-07-25
   Created By        :     Kanchan kumari
   Purpose           :     This stored procedure retrives current week and week details
   Change History    :
   --------------------------------------------------------------------------
	   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
      EXEC Proc_GetShiftMappingDetails @UserId=24, @StartDate=''2018-07-25'',@EndDate=''2018-08-24''
   Created Date      :     2018-11-29
   Created By        :     Kanchan kumari
   Purpose           :     This stored procedure retrives current week and week details
   Change History    :
   --------------------------------------------------------------------------
	   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
      SELECT * FROM Fn_GetEligibleUserForLNSA (4, ''2018-07-25'', ''2018-08-24'',1)
***/
CREATE FUNCTION [dbo].[Fn_GetEligibleUserForLNSA]
(
@UserId INT,
@FromDate Date,
@TillDate Date,
@IsPreviousMonthDate BIT
)
RETURNS @EligibileUsers TABLE (UserId INT, DateId BIGINT NOT NULL, IsEligible BIT)
AS
BEGIN
  
  INSERT INTO @EligibileUsers
     SELECT @UserId, DateId, CASE WHEN @IsPreviousMonthDate = 1 THEN 0 ELSE 1 END AS IsEligible
	  FROM DateMaster WHERE [Date] BETWEEN @FromDate AND @TillDate  
  RETURN
END' 
END

GO
/****** Object:  StoredProcedure [dbo].[Proc_GetShiftMappingDetails]    Script Date: 11-12-2018 16:58:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetShiftMappingDetails]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetShiftMappingDetails] AS' 
END
GO
/***
   Created Date      :     2018-07-25
   Created By        :     Kanchan kumari
   Purpose           :     This stored procedure retrives current week and week details
   Change History    :
   --------------------------------------------------------------------------
	   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
      EXEC Proc_GetShiftMappingDetails @UserId=24, @StartDate='2018-07-25',@EndDate='2018-08-24'

   Created Date      :     2018-07-25
   Created By        :     Kanchan kumari
   Purpose           :     This stored procedure retrives current week and week details
   Change History    :
   --------------------------------------------------------------------------
	   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
      EXEC Proc_GetShiftMappingDetails @UserId=4, @StartDate='2018-07-25',@EndDate='2018-08-24',@IsPreviousMonthDate = 1
***/
ALTER PROC [dbo].[Proc_GetShiftMappingDetails]
(
  @UserId INT
 ,@StartDate DATE
 ,@EndDate DATE
 ,@IsPreviousMonthDate BIT
)
AS
BEGIN
SET FMTONLY OFF;
	IF OBJECT_ID('tempdb..#TempWeek') IS NOT NULL
	DROP TABLE #TempWeek

	IF OBJECT_ID('tempdb..#TempUserData') IS NOT NULL
	DROP TABLE #TempUserData 
		
	IF OBJECT_ID('tempdb..#TempShiftCalender') IS NOT NULL
	DROP TABLE #TempShiftCalender

	CREATE TABLE #TempWeek
	(
	 [StartDate] [date] NOT NULL
	,[EndDate] [date] NOT NULL
	,[WeekNo] [int] NOT NULL
	,DateInfo DATE NULL
	)

	DECLARE @NewStartDate DATE , @NewEndDate DATE
	SET @NewStartDate = @StartDate
	SET @NewEndDate = @EndDate

	WHILE(@StartDate<=@EndDate)
	BEGIN
		INSERT INTO #TempWeek([StartDate],[EndDate],[WeekNo])
		EXEC [spFetchWeekMap] @UserId,@StartDate
		UPDATE #TempWeek SET DateInfo=@StartDate WHERE DateInfo IS NULL
		SET @StartDate = (SELECT DATEADD(d,1,@StartDate))
	END

	CREATE TABLE #TempUserData
	(
	UserId INT,
	DateId BIGINT,
	StatusId INT,
	StatusCode VARCHAR(10) 
	)
	INSERT INTO #TempUserData
		SELECT  TD.CreatedBy AS UserId,
				TD.DateId,
				CASE WHEN LS.StatusCode = 'PA' AND TD.LastModifiedBy IS NOT NULL AND TD.LastModifiedDate IS NOT NULL THEN 3 --approved
				WHEN LS.StatusCode = 'AP' THEN 3 --approved 
				WHEN LS.StatusCode = 'PA' AND TD.LastModifiedBy IS NULL AND TD.LastModifiedDate IS  NULL THEN 2 --pending
				END AS StatusId,
				CASE WHEN LS.StatusCode = 'PA' AND TD.LastModifiedBy IS NOT NULL AND TD.LastModifiedDate IS NOT NULL THEN 'AP'
				WHEN LS.StatusCode = 'AP' THEN 'AP'
				WHEN LS.StatusCode = 'PA' AND TD.LastModifiedBy IS  NULL AND TD.LastModifiedDate IS  NULL THEN 'PA'
				END AS StatusCode
				FROM DateWiseLnsa TD 
				INNER JOIN LNSAStatusMaster LS ON TD.StatusId =LS.StatusId
				WHERE TD.CreatedBy = @UserId AND (LS.StatusCode='PA' OR LS.StatusCode = 'AP')
	
  CREATE TABLE #TempShiftCalender
   (  
      [MappingStartDate] VARCHAR(20) NOT NULL,
	  [MappingEndDate] VARCHAR(20) NOT NULL,
	  [DateId] BIGINT NOT NULL
	 ,[WeekNo] BIGINT NOT NULL
	 ,[Month] VARCHAR(20) NOT NULL
	 ,[Year] INT NOT NULL
	 ,[DateInt] INT NOT NULL
	 ,[Day] VARCHAR(20) NOT NULL
	 ,FullDate VARCHAR(50) NOT NULL
	 ,IsApplied BIT NOT NULL
	 ,IsApproved BIT NOT NULL
	 ,IsLNSAEnabled BIT  
   )
   INSERT INTO #TempShiftCalender([MappingStartDate],[MappingEndDate],[DateId],[WeekNo],[Month],[Year],[DateInt],[Day],FullDate,
                            IsApplied,IsApproved)
   SELECT  
           CONVERT(VARCHAR(15),@NewStartDate,106)         AS [MappingStartDate],
           CONVERT(VARCHAR(15),@NewEndDate,106)                AS [MappingEndDate],
           DM.DateId                                        AS [DateId],
           T.WeekNo                                         AS  WeekNo,
           CAST(DATENAME(mm,T.DateInfo) AS VARCHAR(20))		AS [Month] , 
		   CAST(DATEPART(yyyy,T.DateInfo) AS INT)			AS [Year],
		   CAST(DATEPART(d,T.DateInfo) AS INT)				AS [DateInt], 
		   DM.[Day]                                         AS [Day],
		   CONVERT(VARCHAR(15),T.DateInfo,106)              AS FullDate,
		   CASE WHEN TD.StatusCode='PA' OR TD.StatusCode='AP' THEN 1
		        ELSE 0 END                                  AS IsApplied,
           CASE WHEN TD.StatusCode ='AP' THEN 1
		       ELSE 0 END                                   AS IsApproved
		 FROM #TempWeek T
		 JOIN DateMaster DM ON T.DateInfo=DM.[Date]
		 LEFT JOIN #TempUserData TD ON DM.[DateId]=TD.DateId 
		 ORDER BY DM.DateId

		  UPDATE TC SET TC.IsLNSAEnabled = EL.IsEligible FROM #TempShiftCalender TC
		  JOIN (SELECT DateId,IsEligible FROM Fn_GetEligibleUserForLNSA (@UserId, @NewStartDate, @NewEndDate, @IsPreviousMonthDate)) EL
		  ON TC.DateId = EL.DateId 

		  SELECT [DateId],[WeekNo],[Month],[Year],[DateInt],[Day],FullDate,IsApplied,
                 IsApproved,[MappingStartDate],[MappingEndDate], IsLNSAEnabled
	      FROM #TempShiftCalender
END





GO
/****** Object:  StoredProcedure [dbo].[Proc_MapLnsaShift]    Script Date: 11-12-2018 16:58:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_MapLnsaShift]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_MapLnsaShift] AS' 
END
GO
/***
Created Date      :     2018-07-20
Created By        :     Kanchan Kumari
Purpose           :     This stored procedure is to map night shift by user
Change History    :
--------------------------------------------------------------------------
Modify Date       Edited By            Change Description
--------------------------------------------------------------------------
--------------------------------------------------------------------------
Test Cases        :
--------------------------------------------------------------------------
--- Test Case 1
DECLARE @Res tinyint=0
EXEC [dbo].[Proc_MapLnsaShift]
  @EmployeeId = 84
 ,@DateId ='11024,11025,11026,11027,11028,11029,11030,11031,11032,11033,11034,11035,11036'
 ,@Success = @Res output 
SELECT @Res AS Status

SELECT * from TempUserShift
SELECT * from TempUserShiftHistory
SELECT * from TempUserShiftDetail

***/
ALTER PROC [dbo].[Proc_MapLnsaShift] 
(
@EmployeeId INT,
@DateId VARCHAR(500),
@Reason VARCHAR(500),
@Success tinyint out
)
AS 
BEGIN TRY
SET NOCOUNT ON;
     IF(@DateId='' OR @DateId IS NULL)
	 BEGIN
	 SET @Success=3;----date is empty or null
	 END
     ELSE
	 BEGIN
        BEGIN TRANSACTION;
	    IF OBJECT_ID('tempdb..#TempShiftMap') IS NOT NULL
	    DROP TABLE #TempShiftMap
	
	 CREATE TABLE #TempShiftMap(
	 IdentityId INT,
	 DateId INT
	 )
        DECLARE  @ReportingManagerId INT, @HRId INT, @StatusId INT
		SET @ReportingManagerId = (SELECT [dbo].[fnGetReportingManagerByUserId](@EmployeeId)) 
		SET @HRId=(SELECT [dbo].[fnGetHRIdByUserId](@EmployeeId))

		INSERT INTO #TempShiftMap 

		SELECT * FROM Fun_SplitStringInt(@DateId,',')

        IF EXISTS(SELECT 1 FROM DateWiseLNSA 
                  WHERE CreatedBy=@EmployeeId
				  AND StatusId<6
				  AND (DateId IN(SELECT DateId FROM #TempShiftMap)))
		BEGIN
				SET @Success=2---already exist
		END
		ELSE
		BEGIN
			IF(@ReportingManagerId=1 OR @ReportingManagerId=0)
			BEGIN
			SET @ReportingManagerId=@HRId
			END
		--------------------------Insert into requestLNSA table------------------------
		    DECLARE @FromDateId BIGINT,@TillDateId BIGINT, @NoOfDays INT
			SELECT @FromDateId = MIN(DateId), @TillDateId = MAX(DateId) FROM #TempShiftMap
			SELECT @NoOfDays = Count(*) FROM #TempShiftMap

		 	 SELECT @StatusId = StatusId FROM LNSAStatusMaster WHERE StatusCode = 'PA'

             INSERT INTO [dbo].[RequestLnsa]
             ([FromDateId], [TillDateId], [TotalNoOfDays], [Reason], StatusId, [ApproverId], [CreatedBy])
             VALUES( @FromDateId, @TillDateId, @NoOfDays, @Reason, @StatusId, @ReportingManagerId, @EmployeeId)
			      
			DECLARE @RequestId BIGINT,
			@StatusIdNew INT = (SELECT StatusId FROM LNSAStatusMaster WHERE StatusCode = 'AD')

			SET @RequestId = SCOPE_IDENTITY()
			------------------insert into RequestLnsaHistory----------
			INSERT INTO RequestLnsaHistory(RequestId, StatusId, Remarks, CreatedBy)
									 VALUES(@RequestId, @StatusIdNew, 'Applied', @EmployeeId)

			-----------------insert into DateWiseLNSA------------
					    INSERT INTO [dbo].[DateWiseLNSA]([RequestId],[DateId],[StatusId],[Remarks],[CreatedBy])
						SELECT @RequestId, D.[DateId],@StatusId,'Applied',@EmployeeId
						FROM #TempShiftMap D JOIN DateMaster DM WITH (NOLOCK) ON D.DateId = DM.DateId ORDER BY DM.[Date]
						
						
			SET @Success=1  	
		END
		--shift mapped successfully
		COMMIT;
		--SELECT @Result = [dbo].[Fun_ConvertXmlToJson]((select * from #Result FOR XML PATH, root))
    END
END TRY

BEGIN CATCH
	 IF(@@TRANCOUNT>0)
	 ROLLBACK TRANSACTION;

	 SET @Success=0;  ---error occurred
	 
	 DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
	 --Log Error
	 EXEC [spInsertErrorLog]
			 @ModuleName = 'LNSA'
			,@Source = 'Proc_MapLnsaShift'
			,@ErrorMessage = @ErrorMessage
			,@ErrorType = 'SP'
			,@ReportedByUserId = @EmployeeId
END CATCH
--select * from errorlog order by 1 desc


GO
/****** Object:  StoredProcedure [dbo].[spFetchAllApprovedLnsaRequest]    Script Date: 11-12-2018 16:58:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spFetchAllApprovedLnsaRequest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spFetchAllApprovedLnsaRequest] AS' 
END
GO
/***
   Created Date      :     2016-07-11
   Created By        :     Shubhra Upadhyay
   Purpose           :     This stored proc is used to get all approved LNSA request by reporting manager Id between a given date
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   12 oct 2018         Kanchan kumari     used vwActiveUsers instead of userdetail 
                                          and added RequestLnsaHistory
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   
   --- Test Case 1
         EXEC [dbo].[spFetchAllApprovedLnsaRequest]
         @UserId = 1
		 ,@FromDate = '2016-05-17'
         ,@TillDate = '2016-05-20'

   --- Test Case 2
         EXEC [dbo].[spFetchAllApprovedLnsaRequest]
         @UserId = 22
		 ,@FromDate = '2016-05-17'
         ,@TillDate = '2016-05-20'
***/

ALTER PROCEDURE [dbo].[spFetchAllApprovedLnsaRequest] 
    @UserId [int]
   ,@FromDate [datetime]
   ,@TillDate [datetime]
AS
BEGIN
	
SET NOCOUNT ON;
      SELECT 
		 R.[RequestId] AS [RequestId], U.[EmployeeName], D.[Date] AS [FromDate]
        ,M.[Date] AS [TillDate], R.[TotalNoOfDays] AS [NoOfDays]
        ,R.[Reason] AS [Reason]
		 ,CASE WHEN LS.StatusCode = 'PA' THEN  LS.[Status]+' with '+UD.EmployeeFirstName+' '+UD.EmployeeLastName 
		  ELSE LS.[Status]+' by '+VW.EmployeeFirstName+' '+VW.EmployeeLastName END AS [Status]
		 ,CASE WHEN R.ApproverId IS NULL THEN LS.StatusCode ELSE 'PV' END AS [StatusCode],
		 CONVERT(VARCHAR(15),R.[CreatedDate],106) AS ApplyDate
      FROM
         [dbo].[RequestLnsa] R WITH (NOLOCK)
        INNER JOIN [dbo].[DateMaster] D WITH (NOLOCK) ON D.[DateId] = R.[FromDateId]
        INNER JOIN [dbo].[DateMaster] M WITH (NOLOCK) ON M.[DateId] = R.[TillDateId]
		INNER JOIN [dbo].[vwActiveUsers] U WITH (NOLOCK) ON U.[UserId] = R.[CreatedBy]
		INNER JOIN [dbo].[LNSAStatusMaster] LS WITH (NOLOCK) ON R.StatusId = LS.StatusId
		LEFT JOIN [dbo].[vwActiveUsers] UD WITH (NOLOCK) ON R.ApproverId = UD.UserId
		LEFT JOIN [dbo].[vwActiveUsers] VW WITH (NOLOCK) ON R.[LastModifiedBy] = VW.UserId
		INNER JOIN [dbo].[RequestLnsaHistory] RH ON R.RequestId = RH.RequestId 
		INNER JOIN [dbo].[LNSAStatusMaster] LM ON RH.StatusId = LM.StatusId
      WHERE
         RH.CreatedBy = @UserId AND R.CreatedBy != @UserId
		 --AND R.[Status] = 1
		 AND
		 (
			D.[Date] BETWEEN @FromDate AND @TillDate OR
            M.[Date] BETWEEN @FromDate AND @TillDate OR
            @FromDate BETWEEN D.[Date] AND M.[Date]
		 )
		  GROUP BY  R.[RequestId], R.[CreatedDate],U.[EmployeeName],D.[Date],M.[Date],R.[TotalNoOfDays],
	     R.[Reason],LS.StatusCode,LS.[Status],UD.EmployeeFirstName,UD.EmployeeLastName,VW.EmployeeFirstName,R.ApproverId,VW.EmployeeLastName
      ORDER BY D.[Date] DESC
END






GO
/****** Object:  StoredProcedure [dbo].[spFetchAllLnsaRequestStatusByUserId]    Script Date: 11-12-2018 16:58:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spFetchAllLnsaRequestStatusByUserId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spFetchAllLnsaRequestStatusByUserId] AS' 
END
GO
/***
   Created Date      :     2016-07-11
   Created By        :     Shubhra Upadhyay
   Purpose           :     To get status of all LNSA request on basis of userId
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
    12 oct 2018       Kanchan Kumari      used [vwActiveUsers] instead of UserDetail 
                                          and used [LNSAStatusMaster]
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   --- Test Case 1
         EXEC [dbo].[spFetchAllLnsaRequestStatusByUserId]
         @UserId = 1

   --- Test Case 2
         EXEC [dbo].[spFetchAllLnsaRequestStatusByUserId]
         @UserId = 2166
***/

ALTER PROCEDURE [dbo].[spFetchAllLnsaRequestStatusByUserId] 
   @UserId [int]
AS
BEGIN
	
SET NOCOUNT ON;
      SELECT 
         D.[Date]            AS [FromDate]
        ,M.[Date]            AS [TillDate]
        ,R.[TotalNoOfDays]   AS [NoOfDays]
        ,R.[Reason]          
		,R.[ApproverRemarks] AS [Remarks]
		,LS.StatusCode   
		,R.RequestId
		,CASE WHEN R.LastModifiedDate IS NULL THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT)END AS IsCancellable
		,CONVERT(VARCHAR(15),R.CreatedDate,106) AS ApplyDate       
        ,CASE WHEN LS.StatusCode = 'PA' THEN  LS.[Status]+' with '+UD.FirstName+' '+UD.LastName 
		  ELSE LS.[Status]+' by '+VW.FirstName+' '+VW.LastName END AS [Status]
      FROM
         [dbo].[RequestLnsa] R WITH (NOLOCK)
            INNER JOIN [dbo].[DateMaster] D WITH (NOLOCK) ON D.[DateId] = R.[FromDateId]
            INNER JOIN [dbo].[DateMaster] M WITH (NOLOCK) ON M.[DateId] = R.[TillDateId]
		    LEFT JOIN [dbo].[UserDetail] UD WITH (NOLOCK) ON R.ApproverId = UD.UserId
		    LEFT JOIN [dbo].[UserDetail] VW WITH (NOLOCK) ON R.[LastModifiedBy] = VW.UserId
			INNER JOIN [dbo].[LNSAStatusMaster] LS WITH (NOLOCK) ON R.StatusId = LS.StatusId
      WHERE
         R.[CreatedBy] = @UserId
      ORDER BY D.[Date] DESC
END







GO
/****** Object:  StoredProcedure [dbo].[spFetchAllPendingLnsaRequestByManagerId]    Script Date: 11-12-2018 16:58:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spFetchAllPendingLnsaRequestByManagerId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spFetchAllPendingLnsaRequestByManagerId] AS' 
END
GO
ALTER PROCEDURE [dbo].[spFetchAllPendingLnsaRequestByManagerId] 
   @LoginUserId [int]
AS
BEGIN
SET NOCOUNT ON;
	  --DECLARE --CASE WHEN U.[ReportTo]=3 THEN 2166 ELSE U.[ReportTo]
      SELECT 
		 R.[RequestId] AS [RequestId]
		,U.[EmployeeName]
		,LS.[Status]+' with '+UD.EmployeeFirstName+' '+UD.EmployeeLastName AS [Status]
        ,D.[Date] AS [FromDate]
        ,M.[Date] AS [TillDate]
        ,R.[TotalNoOfDays] AS [NoOfDays]
        ,R.[Reason] AS [Reason]
		,CONVERT(VARCHAR(15),R.[CreatedDate],106) AS ApplyDate
      FROM
         [dbo].[RequestLnsa] R WITH (NOLOCK)
         INNER JOIN [dbo].[DateMaster] D WITH (NOLOCK) ON D.[DateId] = R.[FromDateId]
         INNER JOIN [dbo].[DateMaster] M WITH (NOLOCK) ON M.[DateId] = R.[TillDateId]
         INNER JOIN [dbo].[vwActiveUsers] U WITH (NOLOCK) ON U.[UserId] = R.[CreatedBy]
		 INNER JOIN [dbo].[LNSAStatusMaster] LS WITH (NOLOCK) ON R.StatusId = LS.StatusId
		 LEFT JOIN [dbo].[vwActiveUsers] UD WITH (NOLOCK) ON R.ApproverId = UD.UserId
      WHERE R.ApproverId = @LoginUserId 
      ORDER BY D.[Date] DESC
END



GO
/****** Object:  StoredProcedure [dbo].[spFetchLastNApprovedLnsa]    Script Date: 11-12-2018 16:58:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spFetchLastNApprovedLnsa]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spFetchLastNApprovedLnsa] AS' 
END
GO
/***
   Created Date      :     2017-05-09
   Created By        :     Chandra Prakash Tiwari
   Purpose           :     To get last n approved LNSA request by reporting manager Id 
   Test Cases        :
   --------------------------------------------------------------------------
   
   --- Test Case 1
         EXEC [dbo].[spFetchLastNApprovedLnsa]
         @UserId = 1108
         ,@NoOfRecords = 25
***/
ALTER PROCEDURE [dbo].[spFetchLastNApprovedLnsa] 
     @UserId [int]
    ,@NoOfRecords [int]
AS
BEGIN
SET NOCOUNT ON;
      SELECT TOP (@NoOfRecords)
		  R.[RequestId] AS [RequestId], CONVERT(VARCHAR(15),R.[CreatedDate],106) AS ApplyDate, U.[EmployeeName], D.[Date] AS [FromDate]
         ,M.[Date] AS [TillDate],R.[TotalNoOfDays] AS [NoOfDays],R.[Reason] AS [Reason]
		 ,CASE WHEN LS.StatusCode = 'PA' THEN  LS.[Status]+' with '+UD.EmployeeFirstName+' '+UD.EmployeeLastName 
		  ELSE LS.[Status]+' by '+VW.EmployeeFirstName+' '+VW.EmployeeLastName END AS [Status]
		 ,CASE WHEN R.ApproverId IS NULL THEN LS.StatusCode ELSE 'PV' END AS [StatusCode]
      FROM
         [dbo].[RequestLnsa] R WITH (NOLOCK)
            INNER JOIN [dbo].[DateMaster] D WITH (NOLOCK) ON D.[DateId] = R.[FromDateId]
            INNER JOIN [dbo].[DateMaster] M WITH (NOLOCK) ON M.[DateId] = R.[TillDateId]
            INNER JOIN [dbo].[vwActiveUsers] U WITH (NOLOCK) ON U.[UserId] = R.[CreatedBy]
			INNER JOIN [dbo].[LNSAStatusMaster] LS WITH (NOLOCK) ON R.StatusId = LS.StatusId
		    LEFT JOIN [dbo].[vwActiveUsers] UD WITH (NOLOCK) ON R.ApproverId = UD.UserId
		    LEFT JOIN [dbo].[vwActiveUsers] VW WITH (NOLOCK) ON R.[LastModifiedBy] = VW.UserId
			INNER JOIN [dbo].[RequestLnsaHistory] RH ON R.RequestId = RH.RequestId 
			INNER JOIN [dbo].[LNSAStatusMaster] LM ON RH.StatusId = LM.StatusId
      WHERE RH.[CreatedBy] = @UserId AND R.CreatedBy !=@UserId
	  GROUP BY  R.[RequestId], R.[CreatedDate],U.[EmployeeName],D.[Date],M.[Date],R.[TotalNoOfDays],
	     R.[Reason],LS.StatusCode,LS.[Status],UD.EmployeeFirstName,UD.EmployeeLastName,VW.EmployeeFirstName,R.ApproverId,VW.EmployeeLastName
         --RH.[CreatedBy] = @UserId AND R.[Status] = 1
      ORDER BY D.[Date] DESC
END






GO
/****** Object:  StoredProcedure [dbo].[spImportUserShiftMapping]    Script Date: 11-12-2018 16:58:08 ******/
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
   Declare @res tinyint, @Msg varchar(2000)
         EXEC [dbo].[spImportUserShiftMapping]
            @FromDate = '2018-11-26'
           ,@ToDate = '2018-12-02'
           ,@Data = '<ShiftMapping>
               <ShiftRecord UserId="2432" Shift="D" />
               </ShiftMapping>'
           ,@Success=@res output
		   ,@Message=@Msg output
  SELECT @res AS Result, @Msg AS Message
***/
ALTER PROCEDURE [dbo].[spImportUserShiftMapping]
   @FromDate [date]
  ,@ToDate [date]
  ,@Data [xml]
  ,@LoginUserId [int] = 0
  ,@Success	tinyint output
  ,@Message varchar(2000) output
AS
BEGIN TRY 
   SET NOCOUNT ON;

   IF (@LoginUserId = 0)
    SET @LoginUserId = 58 --Neeraj Yadav for e-Inv

   --supplying a data contract
   IF 1 = 2 
   BEGIN
      SELECT
         CAST(NULL AS [date]) 			AS [Date]
        --,CAST(NULL AS [varchar](152))   AS [Name]
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
		SELECT T.Item.value('@UserId', 'int') [UserId],
			T.Item.value('@Shift', 'varchar(2)') [Shift],
			D.[DateId]
		FROM @Data.nodes('/ShiftMapping/ShiftRecord') AS T(Item)
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
       BEGIN TRANSACTION

	          ----if already exist in the usershiftmapping and not active then update
               UPDATE M
               SET
			      M.[ShiftId] = T.[ShiftId]
                 ,M.[IsActive] = 1
                 ,M.[IsDeleted] = 0
                 ,M.[LastModifiedDate] = GETDATE()
                 ,M.[LastModifiedBy] = @LoginUserId
               FROM [dbo].[UserShiftMapping] M
               INNER JOIN #Data T 
				ON M.[DateId] = T.[DateId]
				AND M.[UserId] = T.[UserId]
				AND M.[IsActive] = 0
				AND M.[IsDeleted] = 1

              ----if not exist in the usershiftmapping insert
               INSERT INTO [dbo].[UserShiftMapping]([DateId],[UserId],[ShiftId],[CreatedBy])
               SELECT T.[DateId],T.[UserId],T.[ShiftId],@LoginUserId
               FROM #Data T
               LEFT JOIN [dbo].[UserShiftMapping] M 
					ON T.[DateId] = M.[DateId]
					AND T.[UserId] = M.[UserId]
               WHERE
                  M.[MappingId] IS NULL
            

			SET @Success=1    ---------------commit if successful
			SET @Message='Users shift added successfully.'   ---------------commit if successful

            COMMIT TRANSACTION
            
            SELECT 
				 D.[Date] AS [Date]
			    ,T.[Shift] AS [Shift]
				,T.[Remarks] AS [Remarks]
            FROM #Data T
            INNER JOIN [dbo].[DateMaster] D WITH (NOLOCK) ON T.[DateId] = D.[DateId]
            WHERE T.[Remarks] IS NOT NULL
		END
END TRY
BEGIN CATCH
		IF @@TRANCOUNT > 0
		BEGIN
        ROLLBACK TRANSACTION
        SELECT
		     NULL AS [Date]
			,NULL AS [Shift]
			,NULL AS [Remarks]

        DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
		DECLARE @ErrId BIGINT=0 

		EXEC [spInsertErrorLog]
			@ModuleName = 'eInvoice'
			,@Source = 'spImportUserShiftMapping'
			,@ErrorMessage = @ErrorMessage
			,@ErrorType = 'SP'
			,@ReportedByUserId = @LoginUserId
			,@ErrorId=@ErrId OUTPUT

		SET @Success=0; -----------------error occured
		SET @Message= 'Your request cannot be processed, please try after some time or contact to MIS team with reference id: ' + CAST(@ErrId AS VARCHAR(20)) + ' for further assistance.'
END
END CATCH


GO
/****** Object:  StoredProcedure [dbo].[spTakeActionOnLnsaRequest]    Script Date: 11-12-2018 16:58:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spTakeActionOnLnsaRequest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spTakeActionOnLnsaRequest] AS' 
END
GO
/***
   Created Date      :     2016-05-17
   Created By        :     Shubhra Upadhyay
   Purpose           :     To take action (approve / reject) on pending LNSA request by reporting manager
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   12 oct 2018       Kanchan kumari        added approval level till rm2 and Insert into RequestLnsaHistory
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   --- Test Case 1
   DECLARE @Res INT
			EXEC [dbo].[spTakeActionOnLnsaRequest]
			  @LoginUserId =1108
			  ,@RequestId =2
			  ,@Remarks='ok'
			  ,@StatusCode = 'RJ' 
			  ,@ActionCode = 'Single'
			  ,@Success = @Res output
			  SELECT @Res AS RESULT
***/
ALTER PROCEDURE [dbo].[spTakeActionOnLnsaRequest] 
 @LoginUserId INT,
 @RequestId BIGINT,
 @Remarks VARCHAR(500),
 @StatusCode VARCHAR(5),
 @ActionCode VARCHAR(5),
 @Success TINYINT Output
AS
SET NOCOUNT ON
BEGIN TRY
   BEGIN TRANSACTION
         DECLARE @StatusId INT, @StatusIdNew INT, @UserId INT, @SecondRMId INT, @FirstRMId INT, @HRId INT, @Result INT = 0,@Count INT,@LnsaRequestId INT,@RequestLnsaId INT;
         
		 IF(@StatusCode = 'RJ')
		 BEGIN
				   SELECT @StatusId = StatusId FROM LNSAStatusMaster WHERE StatusCode = @StatusCode

		          IF( @ActionCode='ALL' )
			      BEGIN
				              --@RequestId AS RequestLnsaId

							---------------update RequestLnsa --------------
							UPDATE [dbo].[RequestLnsa] 
							   SET [ApproverId] = null, [ApproverRemarks] = @Remarks, StatusId = @StatusId
							  ,[Status] = -1, [LastModifiedBy] = @LoginUserId, [LastModifiedDate] = GETDATE()
							WHERE [RequestId] = @RequestId AND StatusId <=5 --verified

							---------------update DateWiseLNSA --------------
							UPDATE [dbo].[DateWiseLNSA] SET [IsApprovedBySystem] = 0, StatusId = @StatusId, Remarks = @Remarks,
							  [LastModifiedBy] = @LoginUserId, [LastModifiedDate] = GETDATE()
							WHERE [RequestId] = @RequestId AND StatusId <=5 --verified

							---------------Insert into RequestLnsaHistory --------------
							INSERT INTO RequestLnsaHistory(RequestId, StatusId, Remarks, CreatedBy)
								   VALUES(@RequestId, @StatusId, @Remarks, @LoginUserId)

						    ---------------------update UserShiftMapping---------------
				           
							UPDATE U SET U.IsActive = 0, U.IsDeleted = 1, U.LastModifiedDate = GETDATE(),
											U.LastModifiedBy=@LoginUserId FROM UserShiftMapping U 
											JOIN DateWiseLNSA T ON U.DateId = T.DateId AND T.CreatedBy = U.UserId
									WHERE T.RequestId = @RequestId AND T.StatusId = @StatusId AND U.shiftId = 3 --night shift  -- Rejected
									     AND U.IsActive = 1 AND U.IsDeleted = 0
							
							SET @Result = 1 ---successfully rejected  
				  END
				  ELSE 
				  BEGIN
				              --@RequestId AS DateWise(RecordId)

				                  SET @LnsaRequestId = ( SELECT RequestId FROM [DateWiseLNSA] WHERE RecordId = @RequestId)
						                                         
							    ---------------update DateWiseLNSA --------------
								   UPDATE DL  SET DL.[IsApprovedBySystem] = 0, DL.StatusId = @StatusId, DL.Remarks = @Remarks,
							       DL.[LastModifiedBy] = @LoginUserId, DL.[LastModifiedDate] = GETDATE()
							       FROM [dbo].[DateWiseLNSA] DL  WHERE DL.RecordId = @RequestId --cancelled
 
                                  SET  @Count = (SELECT Count(RecordId) FROM [DateWiseLNSA]
						                                     WHERE RequestId = @LnsaRequestId  AND StatusId <= 5) --verified
                                    IF (@Count = 0) --no active request
									BEGIN
									 	---------------update RequestLnsa --------------
										   UPDATE [dbo].[RequestLnsa] 
										   SET [ApproverId] = null, [ApproverRemarks] = @Remarks, StatusId = @StatusId
										  ,[Status] = -1, [LastModifiedBy] = @LoginUserId, [LastModifiedDate] = GETDATE()
										   WHERE [RequestId] = @LnsaRequestId AND StatusId <= 5 --verified

										   ---------------Insert into RequestLnsaHistory --------------
										  INSERT INTO RequestLnsaHistory(RequestId, StatusId, Remarks, CreatedBy)
										  VALUES(@LnsaRequestId, @StatusId, @Remarks, @LoginUserId)

								    END
									 ---------------------update UserShiftMapping---------------
									   UPDATE U SET U.IsActive = 0 , U.IsDeleted = 1, U.LastModifiedDate = GETDATE(),
									             U.LastModifiedBy=@LoginUserId FROM UserShiftMapping U 
									             JOIN DateWiseLNSA T ON U.DateId = T.DateId AND T.CreatedBy = U.UserId
											WHERE T.RecordId = @RequestId AND U.IsActive=1 AND U.IsDeleted =0 AND U.shiftId = 3 --night shift 
											AND T.StatusId = @StatusId --Rejected 
						
                       SET @Result = 1 ---successfully rejected  
				  END
			
		 END	

		 ELSE IF(@StatusCode = 'CA')
		 BEGIN
		      SELECT @StatusId = StatusId FROM LNSAStatusMaster WHERE StatusCode = @StatusCode
	          
			  IF( @ActionCode='ALL')
			  BEGIN
			                 --@RequestId AS RequestLnsaId

							---------------update RequestLnsa --------------
							UPDATE [dbo].[RequestLnsa] 
							   SET [ApproverId] = null, [ApproverRemarks] = @Remarks, StatusId = @StatusId
							  ,[Status] = 0, [LastModifiedBy] = @LoginUserId, [LastModifiedDate] = GETDATE()
							WHERE [RequestId] = @RequestId AND  StatusId <=5 --verified

							---------------update DateWiseLNSA --------------
							UPDATE [dbo].[DateWiseLNSA] SET [IsApprovedBySystem] = 0, StatusId = @StatusId, Remarks = @Remarks,
							[LastModifiedBy] = @LoginUserId, [LastModifiedDate] = GETDATE()
							WHERE [RequestId] = @RequestId AND  StatusId <=5 --verified

							   ---------------Insert into RequestLnsaHistory --------------
							INSERT INTO RequestLnsaHistory(RequestId, StatusId, Remarks, CreatedBy)
								   VALUES(@RequestId, @StatusId, @Remarks, @LoginUserId)
								   	
							SET @Result = 1 ---successfully Cancelled  
			  END
			  ELSE
			  BEGIN
			                      --@RequestId AS DateWise(RecordId)

				                  SET @LnsaRequestId = ( SELECT RequestId FROM [DateWiseLNSA] WHERE RecordId = @RequestId)
						                                         
							    ---------------update DateWiseLNSA --------------
								   UPDATE DL  SET DL.[IsApprovedBySystem] = 0, DL.StatusId = @StatusId, DL.Remarks = @Remarks,
							       DL.[LastModifiedBy] = @LoginUserId, DL.[LastModifiedDate] = GETDATE()
							       FROM [dbo].[DateWiseLNSA] DL  WHERE DL.RecordId = @RequestId --cancelled
 
                                    SET  @Count = (SELECT Count(RecordId) FROM [DateWiseLNSA]
						                                     WHERE RequestId = @LnsaRequestId  AND StatusId <= 5) --verified
                               
                                    IF (@Count = 0) --no active request
									BEGIN
									 	---------------update RequestLnsa --------------
										   UPDATE [dbo].[RequestLnsa] 
										   SET [ApproverId] = null, [ApproverRemarks] = @Remarks, StatusId = @StatusId
										  ,[Status] = 0, [LastModifiedBy] = @LoginUserId, [LastModifiedDate] = GETDATE()
										   WHERE [RequestId] = @LnsaRequestId AND StatusId <= 5 --verified

										      ---------------Insert into RequestLnsaHistory --------------
										  INSERT INTO RequestLnsaHistory(RequestId, StatusId, Remarks, CreatedBy)
										  VALUES(@LnsaRequestId, @StatusId, @Remarks, @LoginUserId)

								    END
									
                       SET @Result = 1 ---successfully rejected  
              END
		 END
		 ELSE IF (@StatusCode='AP')
		 BEGIN 
		           --@RequestId AS RequestLnsaId
				   SELECT @UserId = CreatedBy FROM [RequestLnsa] WHERE RequestId = @RequestId
				   SET @SecondRMId = (SELECT [dbo].[fnGetSecondReportingManagerByUserId](@UserId))
				   SET @FirstRMId = (SELECT [dbo].[fnGetReportingManagerByUserId](@UserId));
				   SET @HRId = (SELECT [dbo].[fnGetHRIdByUserId](@UserId))
				IF(@LoginUserId = @FirstRMId AND @LoginUserId != @UserId)
				BEGIN
						IF(@SecondRMId = 0)
						SET @SecondRMId = @HRId

						SELECT @StatusId = StatusId FROM LNSAStatusMaster WHERE StatusCode = 'PA'
						SELECT @StatusIdNew = StatusId FROM LNSAStatusMaster WHERE StatusCode = 'AP'

					        	---------------update RequestLnsa --------------
								UPDATE [dbo].[RequestLnsa] 
								   SET [ApproverId] = @SecondRMId, [ApproverRemarks] = @Remarks, StatusId = @StatusId
								  ,[Status] = 1, [LastModifiedBy] = @LoginUserId, [LastModifiedDate] = GETDATE()
								WHERE [RequestId] = @RequestId AND StatusId = 2 --pending for approval

								---------------update DateWiseLNSA --------------
						        UPDATE  [dbo].[DateWiseLNSA] SET [IsApprovedBySystem] = 0, StatusId = @StatusId, Remarks = @Remarks,
							    [LastModifiedBy] = @LoginUserId, [LastModifiedDate] = GETDATE()
							    WHERE [RequestId] = @RequestId AND StatusId = 2 --pending for approval

								---------------Insert into RequestLnsaHistory --------------
								INSERT INTO RequestLnsaHistory(RequestId, StatusId, Remarks, CreatedBy)
								VALUES(@RequestId, @StatusIdNew, @Remarks,  @LoginUserId)

								----------------------Insert into UserShiftMapping--------(insert if same date is not available in UserShiftMapping)
                                INSERT INTO UserShiftMapping(DateId, UserId, ShiftId, IsActive, IsDeleted ,CreatedDate,
								                                           CreatedBy,LastModifiedDate, LastModifiedBy)
								SELECT TSD.DateId, TS.CreatedBy, 3, 1, 0, TSD.CreatedDate, TSD.CreatedBy, TSD.LastModifiedDate, TSD.LastModifiedBy
								FROM DateWiseLNSA TSD 
								INNER JOIN RequestLnsa TS ON TSD.RequestId=TS.RequestId
								LEFT JOIN UserShiftMapping U ON TSD.DateId = U.DateId AND U.UserId = TSD.CreatedBy 
								WHERE TSD.RequestId = @RequestId AND TSD.StatusId = @StatusId AND TSD.LastModifiedBy = @LoginUserId AND U.[MappingId] IS NULL 


									----------------------Insert into UserShiftMapping--------(update if same date is available in UserShiftMapping)
                                UPDATE U SET ShiftId=3, IsActive=1, IsDeleted=0, LastModifiedDate = TSD.LastModifiedDate, LastModifiedBy=TSD.LastModifiedBy
											FROM UserShiftMapping U JOIN DateWiseLNSA TSD ON U.DateId = TSD.DateId AND  U.UserId = TSD.CreatedBy
								            WHERE TSD.RequestId = @RequestId AND TSD.StatusId = @StatusId AND TSD.LastModifiedBy = @LoginUserId
                      	
					  SET @Result = 1 ---successfully approved by rm1
				END
				ELSE IF(@LoginUserId = @SecondRMId OR @LoginUserId = @HRId)
				BEGIN
				        SELECT @StatusId = StatusId FROM LNSAStatusMaster WHERE StatusCode = 'AP'

						---------------update RequestLnsa --------------
				        UPDATE [dbo].[RequestLnsa] 
						   SET [ApproverId] = null, [ApproverRemarks] = @Remarks, StatusId = @StatusId
						  ,[Status] = 1, [LastModifiedBy] = @LoginUserId, [LastModifiedDate] = GETDATE()
						WHERE [RequestId] = @RequestId AND StatusId = 2 --pending for approval

						---------------update DateWiseLNSA --------------
						 UPDATE  [dbo].[DateWiseLNSA] SET [IsApprovedBySystem] = 1, StatusId = @StatusId, Remarks = @Remarks,
							    [LastModifiedBy] = @LoginUserId, [LastModifiedDate] = GETDATE()
							    WHERE [RequestId] = @RequestId AND StatusId = 2 --pending for approval

						---------------Insert into RequestLnsaHistory --------------
						INSERT INTO RequestLnsaHistory(RequestId, StatusId, Remarks, CreatedBy)
						VALUES(@RequestId, @StatusId, @Remarks,  @LoginUserId)
         
						UPDATE M
						SET M.[IsApprovedBySystem] = 1
						FROM [dbo].[DateWiseLNSA] M WITH (NOLOCK)
						INNER JOIN [dbo].[RequestLnsa] R WITH (NOLOCK)
								ON M.[RequestId] = R.[RequestId]
						INNER JOIN [dbo].[LeaveRequestApplication] L WITH (NOLOCK)
								ON R.[CreatedBy]  = L.[UserId] 
								AND L.[StatusId] > 1 -- consider only approved WFH
						INNER JOIN [dbo].[DateWiseLeaveType] D WITH (NOLOCK)
								ON M.[DateId] = D.[DateId] AND D.[LeaveTypeId] = 5 -- for WFH
								AND L.[LeaveRequestApplicationId] = D.[LeaveRequestApplicationId]
						--for attendance
						UPDATE M 
						SET M.[IsApprovedBySystem] = 1
						FROM [dbo].[DateWiseLNSA] M WITH (NOLOCK)
						INNER JOIN [dbo].[RequestLnsa] R WITH (NOLOCK)
								ON M.[RequestId] = R.[RequestId]
						INNER JOIN [dbo].[DateWiseAttendance] A WITH (NOLOCK)
								ON M.[DateId] = A.[DateId] AND R.[CreatedBy] = A.[UserId]
					SET @Result = 1 ---successfully approved by rm2
		       END
		 END

		SET @Success = @Result;
  COMMIT TRANSACTION;
END TRY
BEGIN CATCH
IF(@@TRANCOUNT>0)
ROLLBACK TRANSACTION;
    DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
    EXEC [spInsertErrorLog]
	    @ModuleName = 'Lnsa'
    ,@Source = 'spTakeActionOnLnsaRequest'
    ,@ErrorMessage = @ErrorMessage
    ,@ErrorType = 'SP'
    ,@ReportedByUserId = @UserId  
	SET @Success = 0;
END CATCH

GO