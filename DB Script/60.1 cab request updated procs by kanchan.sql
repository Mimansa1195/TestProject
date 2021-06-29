/*  
   Created Date      :     15-Mar-2019
   Created By        :     Kanchan Kumari
   Purpose           :     To get the cab request detail
  ---------------------------------------------------------------------------------
   Test Case: 
	  EXEC [dbo].[Proc_GetCabRequestToFinalize]
      @Date='2018-06-29',
	  @CompanyLocationId  = 1,
      @ShiftId = 1,
	  @RouteNo = 1,
	  @LoginUserId = 1
*/

ALTER PROC [dbo].[Proc_GetCabRequestToFinalize](
@Date VARCHAR(20),
@CompanyLocationId INT,
@ShiftId INT,
@RouteNo INT,
@LoginUserId INT
)
AS 
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;

   IF OBJECT_ID('tempdb..#TempCabRquest') IS NOT NULL
   DROP TABLE #TempCabRquest

CREATE TABLE #TempCabRquest
(
   CabRequestId BIGINT NOT NULL,
   EmployeeName VARCHAR(100) NOT NULL,
   StatusCode VARCHAR(20) NOT NULL,
   [Status] VARCHAR(100)NOT NULL,
   [StatusId] INT NOT NULL,
   [Date] DATE NOT NULL,
   CreatedDate VARCHAR(20) NOT NULL,
   [Shift] VARCHAR(30) NOT NULL,
   ShiftId INT NOT NULL,
   ServiceTypeId INT NOT NULL,
   ServiceType VARCHAR(20) NOT NULL,
   CompanyLocationId INT NOT NULL,
   CompanyLocation VARCHAR(100) NOT  NULL,
   RouteLocation VARCHAR(200) NOT NULL,
   RouteLocationId INT NOT NULL,
   RouteNo INT NOT NULL, 
   LocationDetail VARCHAR(500) NOT NULL,
   EmpContactNo VARCHAR(15) NOT NULL,
   RMName VARCHAR(100)  NOT NULL

)

		INSERT INTO #TempCabRquest(CabRequestId, EmployeeName,  StatusCode, [Status], [StatusId], [Date], CreatedDate, [Shift],
		              ShiftId, ServiceTypeId, ServiceType, CompanyLocationId, CompanyLocation, RouteLocation,  RouteNo, 
					  LocationDetail, RouteLocationId, EmpContactNo, RMName)

	    SELECT R.CabRequestId, UD.EmployeeName, S.StatusCode, 
		    CASE WHEN R.ApproverId IS NOT  NULL THEN S.[Status]+' with '+ M.EmployeeName
			     ELSE S.[Status] END AS [Status], 
			S.[StatusId], DM.[Date], CONVERT(VARCHAR(15), R.CreatedDate, 106)+' '+FORMAT(R.CreatedDate, 'hh:mm tt') AS CreatedDate,
			CS.CabShiftName AS [Shift], CS.CabShiftId AS ShiftId, CS.ServiceTypeId,  CT.ServiceType, 
			DL.LocationId AS CompanyLocationId, L.LocationName,  DL.RouteLocation, DL.RouteNo, R.LocationDetail, 
			DL.CabPDLocationId AS RouteLocationId, R.EmpContactNo, UD.ReportingManagerName
			
		FROM CabRequest R
		JOIN CabPickDropLocation DL ON R.CabPDLocationId = DL.CabPDLocationId
		JOIN CabStatusMaster S ON R.StatusId = S.StatusId
		JOIN CabShiftMaster CS ON R.CabShiftId = CS.CabShiftId 
		JOIN CabServiceType CT ON CS.ServiceTypeId = CT.ServiceTypeId
		JOIN DateMaster DM ON R.DateId = DM.DateId
		JOIN vwAllUsers UD ON R.UserId = UD.UserId
		JOIN Location L ON DL.LocationId = L.LocationId
	    LEFT JOIN vwAllUsers M ON R.ApproverId = M.UserId
		WHERE R.CabShiftId = @ShiftId AND DM.[Date] = @Date AND DL.LocationId = @CompanyLocationId AND DL.RouteNo = @RouteNo
		AND S.StatusCode IN('PA' ,'AP', 'PF') 
		ORDER by R.CreatedDate DESC 


		SELECT CabRequestId, EmployeeName,  StatusCode, [Status], [StatusId], [Date], CreatedDate, [Shift],
		              ShiftId, ServiceTypeId, ServiceType, CompanyLocationId, CompanyLocation, RouteLocation,  RouteNo, 
					  LocationDetail, RouteLocationId, EmpContactNo, RMName
	    FROM #TempCabRquest 
		GROUP BY CabRequestId, EmployeeName,  StatusCode, [Status], [StatusId], [Date], CreatedDate, [Shift],
		         ShiftId, ServiceTypeId, ServiceType, CompanyLocationId, CompanyLocation, RouteLocation,  RouteNo, 
			     LocationDetail, RouteLocationId, EmpContactNo,RMName
END


GO

/*  
   Created Date      :     15-Mar-2019
   Created By        :     Kanchan Kumari
   Purpose           :     To get the cab request detail
  ---------------------------------------------------------------------------------
   Test Case: 
	  EXEC [dbo].[Proc_GetGroupedCabRequestToFinalize]
      @Dates='2019-12-11, 2019-12-12, 2019-12-13',
	  @CompanyLocationIds  = '1,6',
	  @ServiceTypeIds = '1,2',
      @ShiftIds = '1,2,3',
	  @RouteIds = '1,2,3,4',
	  @LoginUserId = 1
*/

ALTER PROC [dbo].[Proc_GetGroupedCabRequestToFinalize](
@Dates [VARCHAR](500),
@CompanyLocationIds [VARCHAR](500),
@ServiceTypeIds [VARCHAR](500),
@ShiftIds [VARCHAR](500),
@RouteIds [VARCHAR](500),
@LoginUserId INT
)
AS 
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;

   IF OBJECT_ID('tempdb..#TempCabRquest') IS NOT NULL
   DROP TABLE #TempCabRquest

   IF OBJECT_ID('tempdb..#TempDate') IS NOT NULL
   DROP TABLE #TempDate
   
   IF OBJECT_ID('tempdb..#TempLocation') IS NOT NULL
   DROP TABLE #TempLocation

   IF OBJECT_ID('tempdb..#TempShift') IS NOT NULL
   DROP TABLE #TempShift

   IF OBJECT_ID('tempdb..#TempService') IS NOT NULL
   DROP TABLE #TempService

   IF OBJECT_ID('tempdb..#TempRoute') IS NOT NULL
   DROP TABLE #TempRoute

CREATE TABLE #TempCabRquest
(
   [Date] DATE NOT NULL,
   [Shift] VARCHAR(30) NOT NULL,
   ShiftId INT NOT NULL,
   ServiceTypeId INT NOT NULL,
   ServiceType VARCHAR(20) NOT NULL,
   CompanyLocationId INT NOT NULL,
   CompanyLocation VARCHAR(100) NOT  NULL,
   RouteNo INT NOT NULL,
   RequestCount INT NOT NULL
)

        CREATE TABLE #TempDate
		(
		 [Date] DATE 
		)

		CREATE TABLE #TempLocation
		(
		 LocationId INT 
		)

		CREATE TABLE #TempShift
		(
		 ShiftId INT 
		)

		CREATE TABLE #TempService
		(
		 ServiceTypeId INT 
		)

		CREATE TABLE #TempRoute
		(
		RouteId INT 
		)

    INSERT INTO #TempDate([Date])
	SELECT SplitData FROM [dbo].[Fun_SplitStringStr](@Dates, ',') 
		
	INSERT INTO #TempLocation(LocationId)
	SELECT SplitData FROM [dbo].[Fun_SplitStringInt](@CompanyLocationIds, ',')
			
	INSERT INTO #TempShift(ShiftId)
	SELECT SplitData FROM [dbo].[Fun_SplitStringInt](@ShiftIds, ',')

	INSERT INTO #TempService(ServiceTypeId)
	SELECT SplitData FROM [dbo].[Fun_SplitStringInt](@ServiceTypeIds, ',')

    INSERT INTO #TempRoute(RouteId)
	SELECT SplitData FROM [dbo].[Fun_SplitStringInt](@RouteIds, ',')


		INSERT INTO #TempCabRquest([Date], [Shift],ShiftId, ServiceTypeId, ServiceType, CompanyLocationId, 
		                           CompanyLocation, RequestCount, RouteNo)
	    SELECT  DM.[Date], CS.CabShiftName AS [Shift], CS.CabShiftId AS ShiftId, CS.ServiceTypeId,  CT.ServiceType, 
			    DL.LocationId AS CompanyLocationId, L.LocationName, Count(R.CabRequestId) AS RequestCount, DL.RouteNo
		FROM CabRequest R
		JOIN CabPickDropLocation DL ON R.CabPDLocationId = DL.CabPDLocationId
		JOIN CabStatusMaster S ON R.StatusId = S.StatusId
		JOIN CabShiftMaster CS ON R.CabShiftId = CS.CabShiftId 
		JOIN CabServiceType CT ON CS.ServiceTypeId = CT.ServiceTypeId
		JOIN DateMaster DM ON R.DateId = DM.DateId
		JOIN Location L ON DL.LocationId = L.LocationId
		JOIN #TempDate TD ON DM.[Date] = TD.[Date]
		JOIN #TempLocation TL ON DL.[LocationId] = TL.LocationId
		JOIN #TempShift TS ON R.CabShiftId = TS.ShiftId
		JOIN #TempService TSR ON CS.ServiceTypeId = TSR.ServiceTypeId
		JOIN #TempRoute TR ON DL.RouteNo = TR.RouteId
		WHERE S.StatusCode IN('PA' ,'AP', 'PF') 
		GROUP BY  DM.[Date],  CS.CabShiftName , 
			     CS.CabShiftId , CS.ServiceTypeId,  CT.ServiceType, DL.LocationId , L.LocationName, DL.RouteNo

		SELECT [Date], [Shift],ShiftId, ServiceTypeId, ServiceType, CompanyLocationId, CompanyLocation, RequestCount, RouteNo
	    FROM #TempCabRquest 
		GROUP BY [Date], [Shift], ShiftId, ServiceTypeId, ServiceType, CompanyLocationId, CompanyLocation,RequestCount, RouteNo
END


GO 

/*  
   Created Date      :     11-DEC-2019
   Created By        :     Kanchan Kumari
   Purpose           :     To get finalized cab request detail
  ---------------------------------------------------------------------------------
   Test Case: 
	  EXEC [dbo].[Proc_GetFinalizedCabRequestDetail]
      @FCRequestId =1,
	  @ShiftId  = 1,
	  @CompanyLocationId = 1,
	  @RouteNo = 1
*/

ALTER PROC [dbo].[Proc_GetFinalizedCabRequestDetail](
@FCRequestId BIGINT,
@ShiftId INT,
@CompanyLocationId INT,
@RouteNo INT
)
AS 
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;

   IF OBJECT_ID('tempdb..#TempCabRquest') IS NOT NULL
   DROP TABLE #TempCabRquest

   IF OBJECT_ID('tempdb..#TempDate') IS NOT NULL
   DROP TABLE #TempDate
   
   IF OBJECT_ID('tempdb..#TempLocation') IS NOT NULL
   DROP TABLE #TempLocation

   IF OBJECT_ID('tempdb..#TempShift') IS NOT NULL
   DROP TABLE #TempShift

   IF OBJECT_ID('tempdb..#TempService') IS NOT NULL
   DROP TABLE #TempService

   IF OBJECT_ID('tempdb..#TempRoute') IS NOT NULL
   DROP TABLE #TempRoute

   IF OBJECT_ID('tempdb..#TempRequestIds') IS NOT NULL
   DROP TABLE #TempRequestIds

CREATE TABLE #TempCabRquest
(
   CabRequestId BIGINT NOT NULL,
   EmployeeName VARCHAR(100) NOT NULL,
   StatusCode VARCHAR(20) NOT NULL,
   [Status] VARCHAR(100)NOT NULL,
   [StatusId] INT NOT NULL,
   [Date] DATE NOT NULL,
   CreatedDate VARCHAR(20) NOT NULL,
   [Shift] VARCHAR(30) NOT NULL,
   ShiftId INT NOT NULL,
   ServiceTypeId INT NOT NULL,
   ServiceType VARCHAR(20) NOT NULL,
   CompanyLocationId INT NOT NULL,
   CompanyLocation VARCHAR(100) NOT  NULL,
   RouteLocation VARCHAR(200) NOT NULL,
   RouteLocationId INT NOT NULL,
   RouteNo INT NOT NULL, 
   LocationDetail VARCHAR(500) NOT NULL,
   EmpContactNo VARCHAR(15) NOT NULL,
   RMName VARCHAR(100)  NOT NULL
)
	DECLARE @CabRequestIds VARCHAR(1000) ;
	SELECT @CabRequestIds = CabRequestIds FROM FinalizedCabRequest WHERE FCRequestId = @FCRequestId

   IF OBJECT_ID('tempdb..#TempRequest') IS NOT NULL
   DROP TABLE #TempRequest

		CREATE TABLE #TempRequest
		(
		 CabRequestId BIGINT
		)

	INSERT INTO #TempRequest (CabRequestId)
	SELECT SplitData FROM [dbo].[Fun_SplitStringInt](@CabRequestIds, ',')
	
		
		INSERT INTO #TempCabRquest(CabRequestId, EmployeeName,  StatusCode, [Status], [StatusId], [Date], CreatedDate, [Shift],
		              ShiftId, ServiceTypeId, ServiceType, CompanyLocationId, CompanyLocation, RouteLocation,  RouteNo, 
					  LocationDetail, RouteLocationId, EmpContactNo, RMName)

		SELECT R.CabRequestId, UD.EmployeeName, S.StatusCode, S.[Status] +' by '+ L.EmployeeName AS [Status], 
			S.[StatusId], DM.[Date], CONVERT(VARCHAR(15), R.CreatedDate, 106)+' '+FORMAT(R.CreatedDate, 'hh:mm tt') AS CreatedDate,
			CS.CabShiftName AS [Shift], CS.CabShiftId AS ShiftId, CS.ServiceTypeId,  CT.ServiceType, 
			DL.LocationId AS CompanyLocationId,  LO.LocationName, DL.RouteLocation, DL.RouteNo, R.LocationDetail, DL.CabPDLocationId AS RouteLocationId
			,R.EmpContactNo, ISNULL(UD.ReportingManagerName,'') 
		FROM CabRequest R 
		JOIN CabPickDropLocation DL ON R.CabPDLocationId = DL.CabPDLocationId
		JOIN CabStatusMaster S ON R.StatusId = S.StatusId
		JOIN CabShiftMaster CS ON R.CabShiftId = CS.CabShiftId 
		JOIN CabServiceType CT ON CS.ServiceTypeId = CT.ServiceTypeId
		JOIN DateMaster DM ON R.DateId = DM.DateId
		JOIN vwAllUsers UD ON R.UserId = UD.UserId
		JOIN Location LO ON DL.LocationId = LO.LocationId
		JOIN #TempRequest T ON R.CabRequestId = T.CabRequestId
		LEFT JOIN vwAllUsers L ON R.LastModifiedBy = L.UserId
		WHERE R.CabShiftId = @ShiftId AND DL.LocationId = @CompanyLocationId AND S.StatusCode = 'FD' AND DL.RouteNo = @RouteNo
		ORDER by R.CreatedDate DESC 
	
		SELECT CabRequestId, EmployeeName,  StatusCode, [Status], [StatusId], [Date], CreatedDate, [Shift],
		              ShiftId, ServiceTypeId, ServiceType, CompanyLocationId, CompanyLocation, RouteLocation,  RouteNo, 
					  LocationDetail, RouteLocationId, EmpContactNo, RMName
	    FROM #TempCabRquest 
		GROUP BY CabRequestId, EmployeeName,  StatusCode, [Status], [StatusId], [Date], CreatedDate, [Shift],
		         ShiftId, ServiceTypeId, ServiceType, CompanyLocationId, CompanyLocation, RouteLocation,  RouteNo, 
			     LocationDetail, RouteLocationId, EmpContactNo, RMName
END

GO

/*  
   Created Date      :     11-DEC-2019
   Created By        :     Kanchan Kumari
   Purpose           :     To get finalized cab request detail
  ---------------------------------------------------------------------------------
   Test Case: 
	  EXEC [dbo].[Proc_GetGroupedFinalizedCabRequest]
      @Dates='2019-12-11, 2019-12-12, 2019-12-13',
	  @CompanyLocationIds  = '1,6',
	  @ServiceTypeIds = '1,2',
      @ShiftIds = '1,2',
	  @RouteIds = '1,2,3,4',
	  @LoginUserId = 1
*/

ALTER PROC [dbo].[Proc_GetGroupedFinalizedCabRequest](
@Dates [VARCHAR](500),
@CompanyLocationIds [VARCHAR](500),
@ServiceTypeIds [VARCHAR](500),
@ShiftIds [VARCHAR](500),
@RouteIds [VARCHAR](500),
@LoginUserId INT
)
AS 
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;

   IF OBJECT_ID('tempdb..#TempDate') IS NOT NULL
   DROP TABLE #TempDate
   
   IF OBJECT_ID('tempdb..#TempLocation') IS NOT NULL
   DROP TABLE #TempLocation

   IF OBJECT_ID('tempdb..#TempShift') IS NOT NULL
   DROP TABLE #TempShift

   IF OBJECT_ID('tempdb..#TempService') IS NOT NULL
   DROP TABLE #TempService

   IF OBJECT_ID('tempdb..#TempRoute') IS NOT NULL
   DROP TABLE #TempRoute

   IF OBJECT_ID('tempdb..#TempRequestIds') IS NOT NULL
   DROP TABLE #TempRequestIds


        CREATE TABLE #TempDate
		(
		 [Date] DATE 
		)

		CREATE TABLE #TempLocation
		(
		 LocationId INT 
		)

		CREATE TABLE #TempShift
		(
		 ShiftId INT 
		)

		CREATE TABLE #TempService
		(
		 ServiceTypeId INT 
		)

		CREATE TABLE #TempRoute
		(
		RouteId INT 
		)

		CREATE TABLE #TempRequestIds
		(
		 FCRequestId BIGINT NOT NULL,
		 RequestIds VARCHAR(1000),
		 StaffId INT,
		 StaffName VARCHAR(100),
		 StaffContactNo VARCHAR(100),
		 VehicleId INT,
		 CabRequestId BIGINT
		)

    INSERT INTO #TempDate([Date])
	SELECT SplitData FROM [dbo].[Fun_SplitStringStr](@Dates, ',') 
		
	INSERT INTO #TempLocation(LocationId)
	SELECT SplitData FROM [dbo].[Fun_SplitStringInt](@CompanyLocationIds, ',')
			
	INSERT INTO #TempShift(ShiftId)
	SELECT SplitData FROM [dbo].[Fun_SplitStringInt](@ShiftIds, ',')

	INSERT INTO #TempService(ServiceTypeId)
	SELECT SplitData FROM [dbo].[Fun_SplitStringInt](@ServiceTypeIds, ',')

    INSERT INTO #TempRoute(RouteId)
	SELECT SplitData FROM [dbo].[Fun_SplitStringInt](@RouteIds, ',')

	INSERT INTO #TempRequestIds (FCRequestId,  RequestIds, StaffId, StaffName, StaffContactNo, VehicleId, CabRequestId)
	SELECT F.FCRequestId, F.CabRequestIds, F.StaffId, F.StaffName, F.StaffContactNo, F.VehicleId,
	N.SplitData AS CabRequestId FROM FinalizedCabRequest F 
	CROSS APPLY (SELECT SplitData FROM [dbo].[Fun_SplitStringInt](F.CabRequestIds, ',')) N
	WHERE F.IsActive=1
     
		   SELECT TRS.FCRequestId, S.StatusCode, S.[Status] +' by '+ L.EmployeeName AS [Status], 
		   CONVERT(VARCHAR(11), R.LastModifiedDate,106)+' '+FORMAT(R.LastModifiedDate, 'hh:mm tt') AS FinalizedOn,
			DM.[Date], CS.CabShiftName AS [Shift], CS.CabShiftId AS ShiftId, CS.ServiceTypeId,  CT.ServiceType,
			DL.LocationId, LO.LocationName, 
			CASE WHEN CS.CabShiftName LIKE '%AM%' THEN  'Morning' ELSE 'Evening' END AS DayWiseShift,
			ISNULL(TRS.StaffContactNo,'') AS StaffContactNo, ISNULL(TRS.StaffName,'') AS StaffName, ISNULL(V.Vehicle,'') AS Vehicle
			,COUNT(TRS.CabRequestId) AS RequestCount, DL.RouteNo
		FROM #TempRequestIds TRS JOIN CabRequest R ON TRS.CabRequestId = R.CabRequestId
		JOIN CabPickDropLocation DL ON R.CabPDLocationId = DL.CabPDLocationId
		JOIN CabStatusMaster S ON R.StatusId = S.StatusId
		JOIN CabShiftMaster CS ON R.CabShiftId = CS.CabShiftId 
		JOIN CabServiceType CT ON CS.ServiceTypeId = CT.ServiceTypeId
		JOIN DateMaster DM ON R.DateId = DM.DateId
		JOIN vwAllUsers UD ON R.UserId = UD.UserId
		JOIN Location LO ON DL.LocationId = LO.LocationId
		JOIN #TempDate TD ON DM.[Date] = TD.[Date]
		JOIN #TempLocation TL ON DL.[LocationId] = TL.LocationId
		JOIN #TempShift TS ON R.CabShiftId = TS.ShiftId
		JOIN #TempService TSR ON CS.ServiceTypeId = TSR.ServiceTypeId
		JOIN #TempRoute TR ON DL.RouteNo = TR.RouteId
		JOIN VehicleDetails V ON TRS.VehicleId = V.VehicleId
		LEFT JOIN vwAllUsers L ON R.LastModifiedBy = L.UserId
	    GROUP BY TRS.FCRequestId, R.LastModifiedDate, S.StatusCode, S.[Status], L.EmployeeName, DM.[Date], CS.CabShiftName, 
		          CS.CabShiftId, CS.ServiceTypeId,  CT.ServiceType, TRS.StaffContactNo, TRS.StaffName, V.Vehicle,
				  DL.LocationId, LO.LocationName, DL.RouteNo
END


