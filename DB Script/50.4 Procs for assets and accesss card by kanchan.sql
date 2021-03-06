
/****** Object:  StoredProcedure [dbo].[spFetchAllEmployeesByStatus]    Script Date: 25-11-2019 14:06:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spFetchAllEmployeesByStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spFetchAllEmployeesByStatus]
GO
/****** Object:  StoredProcedure [dbo].[spFetchAllAccessCards]    Script Date: 25-11-2019 14:06:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spFetchAllAccessCards]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spFetchAllAccessCards]
GO
/****** Object:  StoredProcedure [dbo].[Proc_VerifyUserRegDetails]    Script Date: 25-11-2019 14:06:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_VerifyUserRegDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_VerifyUserRegDetails]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetCabReviewRequest]    Script Date: 25-11-2019 14:06:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetCabReviewRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetCabReviewRequest]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetAssetsDetailsByRequestId]    Script Date: 25-11-2019 14:06:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAssetsDetailsByRequestId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetAssetsDetailsByRequestId]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetAllUsersAssets]    Script Date: 25-11-2019 14:06:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAllUsersAssets]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetAllUsersAssets]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetAllAssetsByUserId]    Script Date: 25-11-2019 14:06:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAllAssetsByUserId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetAllAssetsByUserId]
GO
/****** Object:  StoredProcedure [dbo].[Proc_BookOrUpdateCabRequest]    Script Date: 25-11-2019 14:06:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BookOrUpdateCabRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BookOrUpdateCabRequest]
GO
/****** Object:  StoredProcedure [dbo].[Proc_AddUpdateAssetsDetail]    Script Date: 25-11-2019 14:06:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddUpdateAssetsDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AddUpdateAssetsDetail]
GO
/****** Object:  View [dbo].[vwAllUsers]    Script Date: 25-11-2019 14:06:16 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vwAllUsers]'))
DROP VIEW [dbo].[vwAllUsers]
GO
/****** Object:  View [dbo].[vwActiveUsers]    Script Date: 25-11-2019 14:06:16 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vwActiveUsers]'))
DROP VIEW [dbo].[vwActiveUsers]
GO
/****** Object:  View [dbo].[vwActiveUsers]    Script Date: 25-11-2019 14:06:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vwActiveUsers]'))
EXEC dbo.sp_executesql @statement = N'/***
   Created Date      :     2015-11-10
   Created By        :     Rakesh Gandhi
   Purpose           :     This view retrive active users
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   Test Case 1:
      SELECT * FROM [dbo].[vwActiveUsers]
***/
CREATE VIEW [dbo].[vwActiveUsers]
AS
   SELECT 
      U.[UserId]
     ,U.[UserName]
	 ,UD.[EmployeeId] AS [EmployeeCode]
     ,UD.[FirstName] AS [EmployeeFirstName]
     ,UD.[LastName] AS [EmployeeLastName]
	 ,LTRIM(RTRIM(REPLACE(REPLACE(REPLACE((ISNULL(UD.[FirstName],'''') + '' '' + ISNULL(UD.[MiddleName],'''') + '' '' + ISNULL(UD.[LastName],'''')), '' '', ''{}''), ''}{'',''''), ''{}'', '' ''))) AS [EmployeeName]
	 ,LTRIM(RTRIM(REPLACE(REPLACE(REPLACE((ISNULL(UD.[FirstName],'''') + '' '' + ISNULL(UD.[LastName],'''')), '' '', ''{}''), ''}{'',''''), ''{}'', '' ''))) AS [DisplayName]
	 ,R.[RoleId]
	 ,R.[RoleName] AS [Role]
	 ,UD.[DesignationId]
	 ,Desig.[DesignationName] AS [Designation]
	 ,Desig.[IsIntern]
	 ,DG.[DesignationGroupId]
	 ,DG.[DesignationGroupName] AS [DesignationGroup]
     ,UD.[EmailId] AS [EmailId]
	 ,RM.UserId AS RMId
	 ,LTRIM(RTRIM(REPLACE(REPLACE(REPLACE((ISNULL(RM.[FirstName],'''') + '' '' + ISNULL(RM.[MiddleName],'''') + '' '' + ISNULL(RM.[LastName],'''')), '' '', ''{}''), ''}{'',''''), ''{}'', '' ''))) AS [ReportingManagerName]
     ,RM.[EmailId] AS [ReportingManagerEmailId]
	 ,UD.[GenderId]
	 ,G.[GenderType] AS Gender
	 ,UD.[MobileNumber]
	 ,UD.[EmployeeId]
	 ,UD.[JoiningDate]
     ,UD.[BloodGroup]
	 ,UD.[ImagePath]
	 ,UD.[EmergencyContactNumber]
	 ,UD.IsImageVerified
	 ,UD.[ProbationPeriodMonths]
	 ,UD.IsEligibleForLeave
	 ,T.TeamId
	 ,T.TeamName [Team]
	 ,D.DepartmentId
	 ,D.DepartmentName [Department]
	 ,Div.DivisionId
	 ,Div.DivisionName [Division]
   FROM [dbo].[User] U WITH (NOLOCK)
   JOIN [dbo].[UserDetail] UD WITH (NOLOCK) ON U.[UserId] = UD.[UserId]
   JOIN [dbo].[UserDetail] RM WITH (NOLOCK) ON UD.[ReportTo] = RM.[UserId]
   JOIN [dbo].[Gender] G WITH (NOLOCK) ON UD.[GenderId] = G.[GenderId]
   JOIN [dbo].[Role] R WITH (NOLOCK) ON U.[RoleId] = R.[RoleId]
   JOIN [dbo].[Designation] Desig WITH (NOLOCK) ON UD.[DesignationId] = Desig.[DesignationId]
   JOIN [dbo].[DesignationGroup] DG WITH (NOLOCK) ON Desig.[DesignationGroupId] = DG.[DesignationGroupId]
   LEFT JOIN [dbo].[UserTeamMapping] UT ON (U.UserId=UT.UserId AND UT.IsActive = 1)
   LEFT JOIN [dbo].[Team] T WITH (NOLOCK) ON UT.TeamId = T.TeamId
   LEFT JOIN [dbo].[Department] D WITH (NOLOCK) ON T.DepartmentId=D.DepartmentId
   LEFT JOIN [dbo].[Division] Div WITH (NOLOCK) ON D.DivisionId = Div.DivisionId
   WHERE UD.[TerminateDate] IS NULL AND UD.[UserId] <> 1 AND U.[IsActive] = 1 AND UD.IsUserVerified = 1	' 
GO
/****** Object:  View [dbo].[vwAllUsers]    Script Date: 25-11-2019 14:06:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vwAllUsers]'))
EXEC dbo.sp_executesql @statement = N'/***
   Created Date :	2018-12-28
   Created By   :	Sudhanshu Shekhar
   Purpose      :	This view retrive all(active and inactive) users
   Usage		:	SELECT * FROM [dbo].[vwAllUsers]
   --------------------------------------------------------------------------
***/
CREATE VIEW [dbo].[vwAllUsers]
AS
   SELECT 
      U.[UserId]
     ,U.[UserName]
	 ,UD.[EmployeeId] AS [EmployeeCode]
     ,UD.[FirstName] AS [EmployeeFirstName]
     ,UD.[LastName] AS [EmployeeLastName]
	 ,LTRIM(RTRIM(REPLACE(REPLACE(REPLACE((ISNULL(UD.[FirstName],'''') + '' '' + ISNULL(UD.[MiddleName],'''') + '' '' + ISNULL(UD.[LastName],'''')), '' '', ''{}''), ''}{'',''''), ''{}'', '' ''))) AS [EmployeeName]
	 ,LTRIM(RTRIM(REPLACE(REPLACE(REPLACE((ISNULL(UD.[FirstName],'''') + '' '' + ISNULL(UD.[LastName],'''')), '' '', ''{}''), ''}{'',''''), ''{}'', '' ''))) AS [DisplayName]
	 ,R.[RoleId]
	 ,R.[RoleName] AS [Role]
	 ,UD.[DesignationId]
	 ,Desig.[DesignationName] AS [Designation]
	 ,Desig.[IsIntern]
	 ,DG.[DesignationGroupId]
	 ,DG.[DesignationGroupName] AS [DesignationGroup]
     ,UD.[EmailId] AS [EmailId]
	 ,RM.UserId AS RMId
	 ,LTRIM(RTRIM(REPLACE(REPLACE(REPLACE((ISNULL(RM.[FirstName],'''') + '' '' + ISNULL(RM.[MiddleName],'''') + '' '' + ISNULL(RM.[LastName],'''')), '' '', ''{}''), ''}{'',''''), ''{}'', '' ''))) AS [ReportingManagerName]
     ,RM.[EmailId] AS [ReportingManagerEmailId]
	 ,UD.[GenderId]
	 ,G.[GenderType] AS Gender
	 ,UD.[MobileNumber]
	 ,UD.[EmployeeId]
	 ,UD.[JoiningDate]
     ,UD.[BloodGroup]
	 ,UD.[ImagePath]
	 ,UD.[EmergencyContactNumber]
	 ,UD.IsImageVerified
	 ,UD.[ProbationPeriodMonths]
	 ,UD.IsEligibleForLeave
	 ,T.TeamId
	 ,T.TeamName [Team]
	 ,D.DepartmentId
	 ,D.DepartmentName [Department]
	 ,Div.DivisionId
	 ,Div.DivisionName [Division]
	 ,U.[IsActive]
FROM [dbo].[User] U WITH (NOLOCK)
JOIN [dbo].[UserDetail] UD WITH (NOLOCK) ON U.[UserId] = UD.[UserId]
JOIN [dbo].[Gender] G WITH (NOLOCK) ON UD.[GenderId] = G.[GenderId]
JOIN [dbo].[Role] R WITH (NOLOCK) ON U.[RoleId] = R.[RoleId]
JOIN [dbo].[Designation] Desig WITH (NOLOCK) ON UD.[DesignationId] = Desig.[DesignationId]
JOIN [dbo].[DesignationGroup] DG WITH (NOLOCK) ON Desig.[DesignationGroupId] = DG.[DesignationGroupId]
LEFT JOIN [dbo].[UserDetail] RM WITH (NOLOCK) ON UD.[ReportTo] = RM.[UserId]
LEFT JOIN [dbo].[UserTeamMapping] UT ON (U.UserId=UT.UserId AND UT.IsActive = 1)
LEFT JOIN [dbo].[Team] T WITH (NOLOCK) ON UT.TeamId = T.TeamId
LEFT JOIN [dbo].[Department] D WITH (NOLOCK) ON T.DepartmentId=D.DepartmentId
LEFT JOIN [dbo].[Division] Div WITH (NOLOCK) ON D.DivisionId = Div.DivisionId
WHERE UD.IsUserVerified = 1' 
GO
/****** Object:  StoredProcedure [dbo].[Proc_AddUpdateAssetsDetail]    Script Date: 25-11-2019 14:06:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddUpdateAssetsDetail]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_AddUpdateAssetsDetail] AS' 
END
GO
/*  
   Created Date : 10-July-2019
   Created By   : Kanchan Kumari
   Purpose      : To add or update asset details 
   -----------------------------
   Test Case    : 
   DECLARE @Result int 
   EXEC [dbo].[Proc_AddUpdateAssetsDetail]
     @AssetId = 0,
	 @AssetTypeId  = 1,
	 @BrandId = 1 ,
	 @Model = 'Apple',
	 @SerialNumber = '648ujfn v' ,
	 @Description = '',
	 @loginUserId = 1 ,
	 @Success = @Result output
	 SELECT @Result AS [RESULT]
*/
ALTER PROC [dbo].[Proc_AddUpdateAssetsDetail]
(
 @AssetId BIGINT,
 @AssetTypeId BIGINT,
 @BrandId INT,
 @Model VARCHAR(100),
 @SerialNumber VARCHAR(100),
 @Description VARCHAR(100),
 @IsActive BIT,
 @loginUserId INT,
 @Success tinyint out
)
AS
BEGIN TRY
     BEGIN TRANSACTION

     IF EXISTS(SELECT 1 FROM AssetsMaster AM WHERE AM.AssetTypeId = @AssetTypeId AND BrandId = @BrandId
			              AND Model = @Model AND SerialNo = @SerialNumber 
						  --AND [Description] = @Description 
						  AND IsActive = 1 AND @IsActive = 1)
     BEGIN 
	      SET @Success = 2 --duplicate
	 END
     IF(@AssetId = 0)
	 BEGIN
	        INSERT INTO AssetsMaster(AssetTypeId, BrandId, Model, SerialNo, [Description], CreatedBy)
			VALUES(@AssetTypeId, @BrandId, @Model, @SerialNumber, @Description, @loginUserId)
			
			SET @Success = 1 --success
	 END
	 ELSE
	 BEGIN
	        UPDATE AM SET AM.AssetTypeId = @AssetTypeId, AM.BrandId = @BrandId, 
			              AM.Model = @Model, AM.SerialNo = @SerialNumber, AM.[Description] = @Description,
						  AM.ModifiedDate = GETDATE(), AM.ModifiedBy = @loginUserId
			FROM AssetsMaster AM WHERE AM.AssetId = @AssetId AND @IsActive = 1

			 UPDATE AM SET AM.IsActive = 0, AM.ModifiedDate = GETDATE(), AM.ModifiedBy = @loginUserId
			FROM AssetsMaster AM WHERE AM.AssetId = @AssetId AND  @IsActive = 0

			SET @Success = 1 --success
	 END

	 COMMIT;
     
END TRY
BEGIN CATCH
    IF @@TRANCOUNT>0
	ROLLBACK TRANSACTION;

	SET @Success = 0 -- Error occurred
	DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
	--Log Error
	EXEC [spInsertErrorLog]
			@ModuleName = 'Asset Allocation'
		,@Source = 'Proc_AddUpdateAssetsDetail'
		,@ErrorMessage = @ErrorMessage
		,@ErrorType = 'SP'
		,@ReportedByUserId = @LoginUserId
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[Proc_BookOrUpdateCabRequest]    Script Date: 25-11-2019 14:06:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BookOrUpdateCabRequest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_BookOrUpdateCabRequest] AS' 
END
GO
/*  
   Created Date : 15-Mar-2019
   Created By   : Kanchan Kumari
   Purpose      : To book cab
   -----------------------------
   Test Case    : 
   DECLARE @Result int 
   EXEC [dbo].[Proc_BookOrUpdateCabRequest]
   @CabRequestId = 0
   @UserId = 2432
  ,@Date = '2018-06-27'
  ,@DropLocationId = 1
  ,@LocationDetail = 'Sector 23 house no 2134'
  ,@ShiftId = 1
  ,@Success = @Result output
  SELECT @Result AS [RESULT]
*/

ALTER PROC [dbo].[Proc_BookOrUpdateCabRequest](
 @CabRequestId BIGINT
,@UserId INT
,@Date DATE
,@DropLocationId INT
,@LocationDetail VARCHAR(200)
,@ShiftId INT
,@Success tinyInt = 0 output
)
AS
BEGIN TRY
  BEGIN TRANSACTION
	   DECLARE @DateId BIGINT, @HRId INT, @TillDateId BIGINT, @RMId INT, @StatusId INT, 
	            @CutOffTime Time = '20:00:00.0000000', @CurrentTime Time ;
				SELECT @StatusId = StatusId FROM CabStatusMaster WHERE StatusCode='PA'
				SET @RMId = (SELECT [dbo].[fnGetReportingManagerByUserId](@UserId)) 
				SET @HRId = (SELECT [dbo].[fnGetHRIdByUserId](@UserId));
				SELECT @DateId = [DateId] FROM [dbo].[DateMaster] WHERE [Date] = @Date
	   SELECT @CurrentTime = CONVERT(TIME, GETDATE()) 
	IF(@CurrentTime > @CutOffTime)	
	BEGIN
	      SET @Success = 3  ----beyond booking time
	END
	ELSE
	BEGIN
		IF(@RMId = 0 OR @RMId = 1)
		BEGIN
	   			SET @RMId = @HRId
		END
	
		IF EXISTS(SELECT 1
				  FROM [dbo].[CabRequest] C 
				  JOIN [dbo].[CabStatusMaster] S
				  ON C.[StatusId] = S.[StatusId]
				  WHERE C.[CreatedBy] = @UserId 
				  AND DateId = @DateId AND S.[StatusCode] NOT IN('CA','RJ')
				  AND @CabRequestId = 0
				  )	  
		BEGIN
			SET @Success = 2 --Already exists
		END
		ELSE
		BEGIN
		      IF(@CabRequestId = 0)
	          BEGIN
					 INSERT INTO CabRequest (DateId, CabShiftId, DropLocationId, LocationDetail, StatusId, ApproverId, CreatedBy)
												VALUES(@DateId, @ShiftId, @DropLocationId, @LocationDetail, @StatusId, @RMId, @UserId)

					 SET @Success=1 ----booked successfully
              END
	          ELSE
	          BEGIN
				     UPDATE CabRequest
					 SET CabShiftId = @ShiftId, DropLocationId = @DropLocationId, 
						LocationDetail = @LocationDetail, LastModifiedBy = @UserId,
						LastModifiedDate = GETDATE()
						WHERE CabRequestId = @CabRequestId

				   SET @Success=1 ----updated successfully
	          END
	    END
    END
 COMMIT;
END TRY
BEGIN CATCH
	IF @@TRANCOUNT>0
	ROLLBACK TRANSACTION;

	SET @Success = 0 -- Error occurred
	DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
	--Log Error
	EXEC [spInsertErrorLog]
			@ModuleName = 'Cab Request'
		,@Source = 'Proc_BookOrUpdateCabRequest'
		,@ErrorMessage = @ErrorMessage
		,@ErrorType = 'SP'
		,@ReportedByUserId = @UserId
   
END CATCH


GO
/****** Object:  StoredProcedure [dbo].[Proc_GetAllAssetsByUserId]    Script Date: 25-11-2019 14:06:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAllAssetsByUserId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetAllAssetsByUserId] AS' 
END
GO
/***
   Created Date :  10-July-2019
   Created By   :  Kanchan Kumari
   Purpose      :  Get all assets detail
   Usage        :  EXEC [dbo].[Proc_GetAllAssetsByUserId] @ActionCode = 'GG', @UserId = 74
***/
ALTER PROCEDURE [dbo].[Proc_GetAllAssetsByUserId] 
(
  @ActionCode VARCHAR(20),
  @UserId INT
)
AS
BEGIN
	SET NOCOUNT ON;
	SET FMTONLY OFF;

	IF OBJECT_ID('tempdb..#TempUsersAssetDetail') IS NOT NULL
	DROP TABLE #TempUsersAssetDetail

	CREATE TABLE #TempAssetGroupedByUser
	(
		
		[EmployeeName] VARCHAR(100) NOT NULL,
		[UserId] INT NOT NULL,
		[AssetCount] INT NOT NULL
	)

	CREATE TABLE #TempUsersAssetDetail
	(
		[AssetsRequestId] BIGINT NOT NULL,
		[EmployeeName] VARCHAR(100) NOT NULL,
		[EmployeeCode] VARCHAR(100) NOT NULL,
		[UserId] INT NOT NULL,
		[AllocateFrom] VARCHAR(11) NOT NULL,
		[AllocateTill] VARCHAR(11) NOT NULL,
		[AssetId] INT NOT NULL,
		[TypeId] INT NOT NULL,
		[BrandId] INT NOT NULL,
		[Type] VARCHAR(100)NOT NULL,
		[BrandName] VARCHAR(100)NOT NULL,
		[Remarks] VARCHAR(500)NOT NULL,
		[Model] VARCHAR(100)NOT NULL,
		[Description] VARCHAR(100)NOT NULL,
		[SerialNo] VARCHAR(100)NOT NULL,
		[IsActive] BIT NOT NULL DEFAULT(1),
		[Status] VARCHAR(100) NOT NULL,
		[CreatedDate] VARCHAR(25)NOT NULL,
		[CreatedBy] VARCHAR(100)NOT NULL,
		[ModifiedBy] VARCHAR(100) NOT NULL,
		[ModifiedDate] VARCHAR(25) NOT NULL,
		[DeAllocationRemarks] VARCHAR(500) NOT NULL DEFAULT(CAST('' AS VARCHAR(500)))
	)
	IF(@ActionCode = 'AA') -- active assets
	BEGIN   

	       INSERT INTO #TempUsersAssetDetail([AssetsRequestId], [EmployeeName], [EmployeeCode], [UserId], [AllocateFrom],[AllocateTill],  
		                  [AssetId], [TypeId], [Type], [BrandId], [BrandName], [Remarks], [Model], [Description], [SerialNo], [Status], [CreatedDate], 
					      [CreatedBy], [ModifiedBy], [ModifiedDate]
					  )

		   SELECT UA.AssetsRequestId, UD.EmployeeName, UD.EmployeeCode, UA.UserId, CONVERT(VARCHAR(11),UA.[AllocatedFrom],106) AS AllocateFrom, 
				  ISNULL(CONVERT(VARCHAR(11),UA.[AllocatedTill],106), '') AS AllocateTill, AM.AssetId, 
				  T.[TypeId], T.[Type], AB.[BrandId], AB.[BrandName], ISNULL(UA.Remarks, '') AS Remarks, 
				  AM.[Model], AM.[Description], AM.[SerialNo], CAST('Allocated assets' AS VARCHAR(100)) AS [Status],
				  CONVERT(VARCHAR(11), UA.CreatedDate ,106)+' '+ FORMAT(UA.CreatedDate, 'hh:mm tt') AS [CreatedDate],
				   C.EmployeeName AS [CreatedBy], 
				  ISNULL(M.EmployeeName, '') AS [ModifiedBy], 
				  CASE WHEN UA.ModifiedDate IS NULL THEN '' 
					   ELSE CONVERT(VARCHAR(11), UA.ModifiedDate ,106)+' '+ FORMAT(UA.ModifiedDate, 'hh:mm tt') 
				  END AS ModifiedDate
		   FROM UsersAssetDetail UA 
		   JOIN vwAllUsers UD ON UA.UserId = UD.UserId
		   INNER JOIN [dbo].[AssetsMaster] AM  ON UA.AssetId = AM.AssetId
		   INNER JOIN [dbo].[AssetType] T ON AM.AssetTypeId = T.TypeId
		   INNER JOIN [dbo].[AssetsBrand] AB ON AM.BrandId = AB.BrandId
		   INNER JOIN [dbo].[vwAllUsers] C ON UA.CreatedBy = C.UserId
		   LEFT JOIN [dbo].[vwAllUsers] M ON UA.ModifiedBy = M.UserId
		   WHERE UA.IsActive = 1 AND UA.UserId = @UserId
		   ORDER BY UA.CreatedDate DESC, UA.ModifiedDate DESC
		  
    END
	ELSE IF(@ActionCode = 'DA') -- deallocated asset
	BEGIN

	       INSERT INTO #TempUsersAssetDetail([AssetsRequestId], [EmployeeName], [EmployeeCode], [UserId], [AllocateFrom],[AllocateTill],  
		                  [AssetId], [TypeId], [Type], [BrandId], [BrandName], [Remarks], [Model], [Description], [SerialNo], [Status], [CreatedDate], 
					      [CreatedBy], [ModifiedBy], [ModifiedDate]
					  )
		   SELECT UA.AssetsRequestId, UD.EmployeeName, UD.EmployeeCode, UA.UserId, CONVERT(VARCHAR(11),UA.[AllocatedFrom],106) AS AllocateFrom, 
				   ISNULL(CONVERT(VARCHAR(11),UA.[AllocatedTill],106), '') AS AllocateTill, AM.AssetId, 
				  T.[TypeId], T.[Type], AB.[BrandId], AB.[BrandName], ISNULL(UA.Remarks, '') AS Remarks, 
				  AM.[Model], AM.[Description], AM.[SerialNo],  CAST('Pending for collection' AS VARCHAR(100)) AS [Status],
				  CONVERT(VARCHAR(11), UA.CreatedDate ,106)+' '+ FORMAT(UA.CreatedDate, 'hh:mm tt') AS [CreatedDate],
				   C.EmployeeName AS [CreatedBy], 
				  ISNULL(M.EmployeeName, '') AS [ModifiedBy], 
				  CASE WHEN UA.ModifiedDate IS NULL THEN '' 
					   ELSE CONVERT(VARCHAR(11), UA.ModifiedDate ,106)+' '+ FORMAT(UA.ModifiedDate, 'hh:mm tt') 
				  END AS ModifiedDate
		FROM UsersAssetDetail UA 
		   JOIN vwAllUsers UD ON UA.UserId = UD.UserId
		   INNER JOIN [dbo].[AssetsMaster] AM  ON UA.AssetId = AM.AssetId
		   INNER JOIN [dbo].[AssetType] T ON AM.AssetTypeId = T.TypeId
		   INNER JOIN [dbo].[AssetsBrand] AB ON AM.BrandId = AB.BrandId
		   INNER JOIN [dbo].[vwAllUsers] C ON UA.CreatedBy = C.UserId
		   LEFT JOIN [dbo].[vwAllUsers] M ON UA.ModifiedBy = M.UserId
		   WHERE UA.IsActive = 0 AND UA.IsLost = 0 AND UA.IsCollected = 0 AND UA.UserId = @UserId
		   ORDER BY UA.CreatedDate DESC, UA.ModifiedDate DESC
   END
    ELSE 
	BEGIN

	       INSERT INTO #TempUsersAssetDetail([AssetsRequestId], [EmployeeName], [EmployeeCode], [UserId], [AllocateFrom],[AllocateTill],  
		                  [AssetId], [TypeId], [Type], [BrandId], [BrandName], [Remarks], [Model], [Description], [SerialNo], [Status], [CreatedDate], 
					      [CreatedBy], [ModifiedBy], [ModifiedDate],[DeAllocationRemarks]
					  )
		   SELECT UA.AssetsRequestId, UD.EmployeeName, UD.EmployeeCode, UA.UserId, CONVERT(VARCHAR(11),UA.[AllocatedFrom],106) AS AllocateFrom, 
				   ISNULL(CONVERT(VARCHAR(11),UA.[AllocatedTill],106), '') AS AllocateTill, AM.AssetId, 
				  T.[TypeId], T.[Type], AB.[BrandId], AB.[BrandName], ISNULL(UA.Remarks, '') AS Remarks, 
				  AM.[Model], AM.[Description], AM.[SerialNo],
				   CASE WHEN UA.IsLost = 1 THEN CAST('Lost' AS VARCHAR(100)) 
										      WHEN UA.IsCollected = 1 THEN CAST('Collected' AS VARCHAR(100))
											   ELSE CAST('' AS VARCHAR(100)) 
											  END  AS [Status],
				   CONVERT(VARCHAR(11), UA.CreatedDate ,106)+' '+ FORMAT(UA.CreatedDate, 'hh:mm tt') AS [CreatedDate],
				   C.EmployeeName AS [CreatedBy], 
				   ISNULL(M.EmployeeName, '') AS [ModifiedBy], 
				  CASE WHEN UA.ModifiedDate IS NULL THEN '' 
					   ELSE CONVERT(VARCHAR(11), UA.ModifiedDate ,106)+' '+ FORMAT(UA.ModifiedDate, 'hh:mm tt') 
				  END AS ModifiedDate, CAST(ISNULL(UA.DeAllocationRemarks,'') AS VARCHAR(500)) 
		  FROM  UsersAssetDetail UA 
		   JOIN vwAllUsers UD ON UA.UserId = UD.UserId
		   INNER JOIN [dbo].[AssetsMaster] AM  ON UA.AssetId = AM.AssetId
		   INNER JOIN [dbo].[AssetType] T ON AM.AssetTypeId = T.TypeId
		   INNER JOIN [dbo].[AssetsBrand] AB ON AM.BrandId = AB.BrandId
		   INNER JOIN [dbo].[vwAllUsers] C ON UA.CreatedBy = C.UserId
		   LEFT JOIN [dbo].[vwAllUsers] M ON UA.ModifiedBy = M.UserId
		   WHERE UA.IsActive = 0  AND UA.UserId = @UserId AND (UA.IsLost = 1 OR UA.IsCollected = 1)
		   ORDER BY UA.CreatedDate DESC, UA.ModifiedDate DESC
   END

   SELECT * FROM #TempUsersAssetDetail
END






GO
/****** Object:  StoredProcedure [dbo].[Proc_GetAllUsersAssets]    Script Date: 25-11-2019 14:06:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAllUsersAssets]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetAllUsersAssets] AS' 
END
GO
/***
   Created Date :  10-July-2019
   Created By   :  Kanchan Kumari
   Purpose      :  Get all assets detail
   Usage        :  EXEC [dbo].[Proc_GetAllUsersAssets] @ActionCode = 'GG'
***/
ALTER PROCEDURE [dbo].[Proc_GetAllUsersAssets] 
(
  @ActionCode VARCHAR(20) 
)
AS
BEGIN
	SET NOCOUNT ON;
	SET FMTONLY OFF;

	IF OBJECT_ID('tempdb..#TempAssetGroupedByUser') IS NOT NULL
	DROP TABLE #TempAssetGroupedByUser

	IF OBJECT_ID('tempdb..#TempUsersAssetDetail') IS NOT NULL
	DROP TABLE #TempUsersAssetDetail

	IF OBJECT_ID('tempdb..#TempUserAssets') IS NOT NULL
	DROP TABLE #TempUserAssets

	CREATE TABLE #TempUserAssets
	(
        AssetsRequestId	BIGINT
       ,UserId	INT
       ,AssetId	BIGINT
       ,AllocatedFrom	DATE
       ,AllocatedTill	DATE
       ,Remarks	VARCHAR(500)
       ,IsActive	BIT
       ,CreatedDate	DATETIME
       ,CreatedBy	INT
       ,ModifiedDate	DATETIME
       ,ModifiedBy	INT
       ,IsLost	BIT
       ,IsCollected	BIT
       ,DeAllocationRemarks	VARCHAR(500)
	   ,StatusCode VARCHAR(20)
	   ,[Status] VARCHAR(100)
	)

	CREATE TABLE #TempAssetGroupedByUser
	(
		
		[EmployeeName] VARCHAR(100) NOT NULL,
		[UserId] INT NOT NULL,
		[AssetCount] INT NOT NULL
	)

	CREATE TABLE #TempUsersAssetDetail
	(
		[AssetsRequestId] BIGINT NOT NULL,
		[EmployeeName] VARCHAR(100) NOT NULL,
		[EmployeeCode] VARCHAR(100) NOT NULL,
		[UserId] INT NOT NULL,
		[AllocateFrom] VARCHAR(11) NOT NULL,
		[AllocateTill] VARCHAR(11) NOT NULL,
		[AssetId] INT NOT NULL,
		[TypeId] INT NOT NULL,
		[BrandId] INT NOT NULL,
		[Type] VARCHAR(100)NOT NULL,
		[BrandName] VARCHAR(100)NOT NULL,
		[Remarks] VARCHAR(500)NOT NULL,
		[Model] VARCHAR(100)NOT NULL,
		[Description] VARCHAR(100)NOT NULL,
		[SerialNo] VARCHAR(100)NOT NULL,
		[AssetCount] INT NOT NULL,
		[IsActive] BIT NOT NULL DEFAULT(1),
		[Status] VARCHAR(100) NOT NULL,
		[CreatedDate] VARCHAR(25)NOT NULL,
		[CreatedBy] VARCHAR(100)NOT NULL,
		[ModifiedBy] VARCHAR(100) NOT NULL,
		[ModifiedDate] VARCHAR(25) NOT NULL,
		[DeAllocationRemarks] VARCHAR(100) NOT NULL,
		[ImagePath] VARCHAR(100),
		[Gender] VARCHAR(20)
	)
	IF(@ActionCode = 'AA') -- active assets
	BEGIN   
	       INSERT INTO #TempAssetGroupedByUser([EmployeeName], [UserId], [AssetCount])
		   SELECT UD.EmployeeName, UD.UserId, Count(UA.AssetsRequestId) AS AssetCount
		   FROM UsersAssetDetail UA JOIN vwAllUsers UD ON UA.UserId = UD.UserId
		   WHERE UA.IsActive = 1
		   GROUP BY UD.EmployeeName, UD.UserId

		;WITH UserLaptopAsset AS
		(
		   SELECT UT.*,
				 ROW_NUMBER() OVER (PARTITION BY UT.UserId ORDER BY UT.CreatedDate DESC) AS rn
		   FROM UsersAssetDetail  UT
		   INNER JOIN [dbo].[AssetsMaster] AM  ON UT.AssetId = AM.AssetId
		   INNER JOIN [dbo].[AssetType] T ON AM.AssetTypeId = T.TypeId
		  WHERE UT.IsActive = 1 AND T.[Type] = 'Laptop'
		)

		INSERT INTO #TempUserAssets(AssetsRequestId, UserId, AssetId, AllocatedFrom, AllocatedTill, Remarks, IsActive, CreatedDate
                                    ,CreatedBy, ModifiedDate, ModifiedBy, IsLost, IsCollected, DeAllocationRemarks,StatusCode, [Status])

		SELECT AssetsRequestId, UserId, AssetId, AllocatedFrom, AllocatedTill, Remarks, IsActive, CreatedDate
                                    ,CreatedBy, ModifiedDate, ModifiedBy, IsLost, IsCollected, DeAllocationRemarks, 
									CAST('AA' AS VARCHAR(20)), CAST('Allocated Assets' AS VARCHAR(100)) 
	    FROM UserLaptopAsset WHERE rn = 1


		;WITH UserAsset AS
		(
		   SELECT UT.*,
				 ROW_NUMBER() OVER (PARTITION BY UT.UserId ORDER BY UT.CreatedDate DESC) AS un
		   FROM UsersAssetDetail  UT
		   INNER JOIN [dbo].[AssetsMaster] AM  ON UT.AssetId = AM.AssetId
		   INNER JOIN [dbo].[AssetType] T ON AM.AssetTypeId = T.TypeId
		  WHERE UT.IsActive = 1 AND T.[Type] != 'Laptop'
		)

	    INSERT INTO #TempUserAssets(AssetsRequestId, UserId, AssetId, AllocatedFrom, AllocatedTill, Remarks, IsActive, CreatedDate
                                    ,CreatedBy, ModifiedDate, ModifiedBy, IsLost, IsCollected, DeAllocationRemarks, StatusCode, [Status])

		SELECT U.AssetsRequestId, U.UserId, U.AssetId, U.AllocatedFrom, U.AllocatedTill, U.Remarks, U.IsActive, U.CreatedDate
                                    ,U.CreatedBy, U.ModifiedDate, U.ModifiedBy, U.IsLost, U.IsCollected, U.DeAllocationRemarks
									,CAST('AA' AS VARCHAR(20)), CAST('Allocated Assets' AS VARCHAR(100))
	    FROM UserAsset U LEFT JOIN #TempUserAssets T ON U.UserId = T.UserId
		WHERE un = 1 AND T.UserId IS NULL

		

	    
		  
    END
	ELSE IF(@ActionCode = 'DA') -- deallocated asset
	BEGIN


	       INSERT INTO #TempAssetGroupedByUser([EmployeeName], [UserId], [AssetCount])
		   SELECT UD.EmployeeName, UD.UserId, Count(UA.AssetsRequestId) AS AssetCount
		   FROM UsersAssetDetail UA JOIN vwAllUsers UD ON UA.UserId = UD.UserId
		   WHERE UA.IsActive = 0 AND UA.IsLost = 0 AND UA.IsCollected = 0
		   GROUP BY UD.EmployeeName, UD.UserId

		;WITH UserLaptopAsset AS
		(
		   SELECT UT.*,
				 ROW_NUMBER() OVER (PARTITION BY UT.UserId ORDER BY UT.CreatedDate DESC) AS rn
		   FROM UsersAssetDetail  UT
		   INNER JOIN [dbo].[AssetsMaster] AM  ON UT.AssetId = AM.AssetId
		   INNER JOIN [dbo].[AssetType] T ON AM.AssetTypeId = T.TypeId
		  WHERE UT.IsActive = 0 AND T.[Type] = 'Laptop' AND UT.IsLost = 0 AND UT.IsCollected = 0
		)

		INSERT INTO #TempUserAssets(AssetsRequestId, UserId, AssetId, AllocatedFrom, AllocatedTill, Remarks, IsActive, CreatedDate
                                    ,CreatedBy, ModifiedDate, ModifiedBy, IsLost, IsCollected, DeAllocationRemarks, StatusCode, [Status])

		SELECT AssetsRequestId, UserId, AssetId, AllocatedFrom, AllocatedTill, Remarks, IsActive, CreatedDate
                                    ,CreatedBy, ModifiedDate, ModifiedBy, IsLost, IsCollected, DeAllocationRemarks
										,CAST('DA' AS VARCHAR(20)), CAST('Pending for collection' AS VARCHAR(100))
	    FROM UserLaptopAsset WHERE rn = 1


		;WITH UserAsset AS
		(
		   SELECT UT.*,
				 ROW_NUMBER() OVER (PARTITION BY UT.UserId ORDER BY UT.CreatedDate DESC) AS un
		   FROM UsersAssetDetail  UT
		   INNER JOIN [dbo].[AssetsMaster] AM  ON UT.AssetId = AM.AssetId
		   INNER JOIN [dbo].[AssetType] T ON AM.AssetTypeId = T.TypeId
		  WHERE UT.IsActive = 0 AND T.[Type] != 'Laptop' AND UT.IsLost = 0 AND UT.IsCollected = 0
		)

	    INSERT INTO #TempUserAssets(AssetsRequestId, UserId, AssetId, AllocatedFrom, AllocatedTill, Remarks, IsActive, CreatedDate
                                    ,CreatedBy, ModifiedDate, ModifiedBy, IsLost, IsCollected, DeAllocationRemarks, StatusCode, [Status])

		SELECT U.AssetsRequestId, U.UserId, U.AssetId, U.AllocatedFrom, U.AllocatedTill, U.Remarks, U.IsActive, U.CreatedDate
                                    ,U.CreatedBy, U.ModifiedDate, U.ModifiedBy, U.IsLost, U.IsCollected, U.DeAllocationRemarks
										,CAST('DA' AS VARCHAR(20)), CAST('Pending for collection' AS VARCHAR(100))
	    FROM UserAsset U LEFT JOIN #TempUserAssets T ON U.UserId = T.UserId
		WHERE un = 1 AND T.UserId IS NULL

   END
   ELSE 
   BEGIN
	      
		INSERT INTO #TempAssetGroupedByUser([EmployeeName], [UserId], [AssetCount])
		   SELECT UD.EmployeeName, UD.UserId, Count(UA.AssetsRequestId) AS AssetCount
		   FROM UsersAssetDetail UA JOIN vwAllUsers UD ON UA.UserId = UD.UserId
		   WHERE UA.IsActive = 0 AND (UA.IsLost = 1 OR UA.IsCollected = 1)
		   GROUP BY UD.EmployeeName, UD.UserId

		;WITH UserLaptopAsset AS
		(
		   SELECT UT.*,
				 ROW_NUMBER() OVER (PARTITION BY UT.UserId ORDER BY UT.CreatedDate DESC) AS rn
		   FROM UsersAssetDetail  UT
		   INNER JOIN [dbo].[AssetsMaster] AM  ON UT.AssetId = AM.AssetId
		   INNER JOIN [dbo].[AssetType] T ON AM.AssetTypeId = T.TypeId
		  WHERE UT.IsActive = 0 AND T.[Type] = 'Laptop' AND (UT.IsLost = 1 OR UT.IsCollected = 1)
		)

		INSERT INTO #TempUserAssets(AssetsRequestId, UserId, AssetId, AllocatedFrom, AllocatedTill, Remarks, IsActive, CreatedDate
                                    ,CreatedBy, ModifiedDate, ModifiedBy, IsLost, IsCollected, DeAllocationRemarks, StatusCode, [Status])

		SELECT AssetsRequestId, UserId, AssetId, AllocatedFrom, AllocatedTill, Remarks, IsActive, CreatedDate
                                    ,CreatedBy, ModifiedDate, ModifiedBy, IsLost, IsCollected, DeAllocationRemarks
										,CASE WHEN IsLost = 1 THEN CAST('LA' AS VARCHAR(20)) 
										      WHEN IsCollected = 1 THEN CAST('CA' AS VARCHAR(20))
											   ELSE CAST('' AS VARCHAR(20)) 
											  END AS StatusCode ,

											  CASE WHEN IsLost = 1 THEN CAST('Lost' AS VARCHAR(100)) 
										      WHEN IsCollected = 1 THEN CAST('Collected' AS VARCHAR(100))
											   ELSE CAST('' AS VARCHAR(100)) 
											  END  AS Status
	    FROM UserLaptopAsset WHERE rn = 1


		;WITH UserAsset AS
		(
		   SELECT UT.*,
				 ROW_NUMBER() OVER (PARTITION BY UT.UserId ORDER BY UT.CreatedDate DESC) AS un
		   FROM UsersAssetDetail  UT
		   INNER JOIN [dbo].[AssetsMaster] AM  ON UT.AssetId = AM.AssetId
		   INNER JOIN [dbo].[AssetType] T ON AM.AssetTypeId = T.TypeId
		  WHERE UT.IsActive = 0 AND T.[Type] != 'Laptop' AND (UT.IsLost = 1 OR UT.IsCollected = 1)
		)

	    INSERT INTO #TempUserAssets(AssetsRequestId, UserId, AssetId, AllocatedFrom, AllocatedTill, Remarks, IsActive, CreatedDate
                                    ,CreatedBy, ModifiedDate, ModifiedBy, IsLost, IsCollected, DeAllocationRemarks, StatusCode, [Status])

		SELECT U.AssetsRequestId, U.UserId, U.AssetId, U.AllocatedFrom, U.AllocatedTill, U.Remarks, U.IsActive, U.CreatedDate
                                    ,U.CreatedBy, U.ModifiedDate, U.ModifiedBy, U.IsLost, U.IsCollected, U.DeAllocationRemarks
									,CASE WHEN U.IsLost = 1 THEN CAST('LA' AS VARCHAR(20)) 
										      WHEN U.IsCollected = 1 THEN CAST('CA' AS VARCHAR(20))
											   ELSE CAST('' AS VARCHAR(20)) 
											  END AS StatusCode ,

											  CASE WHEN U.IsLost = 1 THEN CAST('Lost' AS VARCHAR(100)) 
										      WHEN U.IsCollected = 1 THEN CAST('Collected' AS VARCHAR(100))
											  ELSE CAST('' AS VARCHAR(100)) 
											  END  AS [Status]
	    FROM UserAsset U LEFT JOIN #TempUserAssets T ON U.UserId = T.UserId
		WHERE un = 1 AND T.UserId IS NULL

  END

        INSERT INTO #TempUsersAssetDetail([AssetsRequestId], [EmployeeName], [EmployeeCode], [UserId], [AllocateFrom],[AllocateTill],  
		            [AssetId], [TypeId], [Type], [BrandId], [BrandName], [Remarks], [Model], [Description], [SerialNo], [Status], [CreatedDate], 
					[CreatedBy], [ModifiedBy], [ModifiedDate], [AssetCount], [DeAllocationRemarks], [ImagePath], [Gender]
				)
           
		SELECT  UA.AssetsRequestId, 
		        UD.EmployeeName, UD.EmployeeCode, UA.UserId, CONVERT(VARCHAR(11),UA.[AllocatedFrom],106) AS AllocateFrom, 
				ISNULL(CONVERT(VARCHAR(11),UA.[AllocatedTill],106), '') AS AllocateTill, AM.AssetId, 
				T.[TypeId], T.[Type], AB.[BrandId], AB.[BrandName], 
				ISNULL(UA.Remarks, '') AS Remarks, 
				AM.[Model], AM.[Description], AM.[SerialNo], ISNULL(UA.[Status],'') AS [Status],
				CONVERT(VARCHAR(11), UA.CreatedDate ,106)+' '+ FORMAT(UA.CreatedDate, 'hh:mm tt') AS [CreatedDate],
				C.EmployeeName AS [CreatedBy], 
				ISNULL(M.EmployeeName, '') AS [ModifiedBy], 
				CASE WHEN UA.ModifiedDate IS NULL THEN '' 
					ELSE CONVERT(VARCHAR(11), UA.ModifiedDate ,106)+' '+ FORMAT(UA.ModifiedDate, 'hh:mm tt') 
				END AS ModifiedDate, ISNULL(TG.AssetCount, 0), ISNULL(UA.DeAllocationRemarks, ''),
				UD.ImagePath, UD.Gender
		FROM #TempUserAssets UA 
		JOIN vwAllUsers UD ON UA.UserId = UD.UserId
		INNER JOIN [dbo].[AssetsMaster] AM  ON UA.AssetId = AM.AssetId
		INNER JOIN [dbo].[AssetType] T ON AM.AssetTypeId = T.TypeId
		INNER JOIN [dbo].[AssetsBrand] AB ON AM.BrandId = AB.BrandId
		INNER JOIN [dbo].[vwAllUsers] C ON UA.CreatedBy = C.UserId
		LEFT JOIN [dbo].[vwAllUsers] M ON UA.ModifiedBy = M.UserId
		LEFT JOIN #TempAssetGroupedByUser TG ON UA.UserId = TG.UserId
		ORDER BY UA.CreatedDate DESC, UA.ModifiedDate DESC


   SELECT * FROM #TempUsersAssetDetail

END





GO
/****** Object:  StoredProcedure [dbo].[Proc_GetAssetsDetailsByRequestId]    Script Date: 25-11-2019 14:06:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAssetsDetailsByRequestId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetAssetsDetailsByRequestId] AS' 
END
GO
/***
   Created Date :  10-July-2019
   Created By   :  Kanchan Kumari
   Purpose      :  Get assets detail
   Usage        :  EXEC [dbo].[Proc_GetAssetsDetailsByRequestId] @AssetRequestIds = '22'
***/
ALTER PROCEDURE [dbo].[Proc_GetAssetsDetailsByRequestId] 
(
  @AssetRequestIds VARCHAR(8000)
)
AS
BEGIN
		   SELECT UA.AssetsRequestId, UD.EmployeeName, UD.EmployeeCode, UD.ReportingManagerName, 
		          UA.UserId, CONVERT(VARCHAR(11),UA.[AllocatedFrom],106) AS AllocateFrom, 
				  ISNULL(CONVERT(VARCHAR(11),UA.[AllocatedTill],106), '') AS AllocateTill, AM.AssetId, 
				  T.[TypeId], T.[Type], AB.[BrandId], AB.[BrandName], ISNULL(UA.Remarks, '') AS Remarks, 
				  AM.[Model], AM.[Description], AM.[SerialNo],
				  CONVERT(VARCHAR(11), UA.CreatedDate ,106)+' '+ FORMAT(UA.CreatedDate, 'hh:mm tt') AS [CreatedDate],
				   C.EmployeeName AS [CreatedBy], 
				  ISNULL(M.EmployeeName, '') AS [ModifiedBy], 
				  CASE WHEN UA.ModifiedDate IS NULL THEN '' 
					   ELSE CONVERT(VARCHAR(11), UA.ModifiedDate ,106)+' '+ FORMAT(UA.ModifiedDate, 'hh:mm tt') 
				  END AS ModifiedDate,
				  ISNULL(UA.DeAllocationRemarks,'') AS DeAllocationRemarks,
				  UD.ImagePath,
				  UD.MobileNumber
		   FROM UsersAssetDetail UA 
		   JOIN vwAllUsers UD ON UA.UserId = UD.UserId
		   INNER JOIN [dbo].[AssetsMaster] AM  ON UA.AssetId = AM.AssetId
		   INNER JOIN [dbo].[AssetType] T ON AM.AssetTypeId = T.TypeId
		   INNER JOIN [dbo].[AssetsBrand] AB ON AM.BrandId = AB.BrandId
		   INNER JOIN [dbo].[vwAllUsers] C ON UA.CreatedBy = C.UserId
		   LEFT JOIN [dbo].[vwAllUsers] M ON UA.ModifiedBy = M.UserId
		   WHERE UA.AssetsRequestId IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt](@AssetRequestIds, ','))
END






GO
/****** Object:  StoredProcedure [dbo].[Proc_GetCabReviewRequest]    Script Date: 25-11-2019 14:06:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetCabReviewRequest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetCabReviewRequest] AS' 
END
GO
/*  
   Created Date      :    15-Mar-2019
   Created By        :    Kanchan Kumari
   Purpose           :    To review cab request 
   --------------------------------------------------------------------------
   Test Case: 
	EXEC [dbo].[Proc_GetCabReviewRequest]
    @LoginUserId = 1108
*/

ALTER PROC [dbo].[Proc_GetCabReviewRequest](
@LoginUserId INT
)
AS 
BEGIN
SELECT R.CabRequestId, UD.EmployeeName, S.StatusCode, S.[Status], DM.[Date],
			CONVERT(VARCHAR(15), R.CreatedDate, 106)+' '+FORMAT(R.CreatedDate, 'hh:mm tt') AS CreatedDate,
			CS.CabShiftName AS [Shift], CS.CabShiftId,
		    R.DropLocationId, DL.DropLocation, CR.CabRouteId, CR.CabRoute, R.LocationDetail
		FROM CabRequest R
		JOIN DropLocation DL ON R.DropLocationId = DL.DropLocationId
		JOIN CabRoute CR ON DL.CabRouteId = CR.CabRouteId
		JOIN CabStatusMaster S ON R.StatusId = S.StatusId
		JOIN CabShiftMaster CS ON R.CabShiftId = CS.CabShiftId 
		JOIN DateMaster DM ON R.DateId = DM.DateId
		JOIN vwAllUsers UD ON R.CreatedBy = UD.UserId
		WHERE R.ApproverId = @LoginUserId OR (R.ApproverId IS NULL AND R.LastModifiedBy = @LoginUserId AND R.CreatedBy != @LoginUserId) 
		ORDER BY CreatedDate desc
END


GO
/****** Object:  StoredProcedure [dbo].[Proc_VerifyUserRegDetails]    Script Date: 25-11-2019 14:06:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_VerifyUserRegDetails]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_VerifyUserRegDetails] AS' 
END
GO
/***
   Created Date      :     2016-09-27
   Created By        :     Shubhra Upadhyay
   Purpose           :     This stored proc is used to add new access cardtus
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By           Change Description
   2018-05-04        kanchan kumari       for staff access card mapping
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
        DECLARE @Result int
		EXEC [dbo].[Proc_VerifyUserRegDetails]
		 @RegistrationId=543
	    ,@accessCardId = 284
        ,@userId = 4
        ,@IsPimcoUserCardMapping = 0
        ,@createdBy = 2167
		,@IsStaff = 0
		,@fromDate='2018-05-14'
		,@success=@Result output
		SELECT @Result AS RESULT
***/
ALTER Proc [dbo].[Proc_VerifyUserRegDetails]
  (
    @RegistrationId bigint,
	@AccessCardId int,
	@UserId int,
	@IsPimcoUserCardMapping bit,
	@CreatedBy [int],
	@IsStaff  bit,
	@FromDate date,
	@success tinyint output
  )
  AS
  BEGIN TRY
     SET NOCOUNT ON;

	   DECLARE @result int, @MappedUserCardId bigint;
	   EXEC [dbo].[spAddUserAccessCardMapping] @AccessCardId,@UserId,@IsPimcoUserCardMapping,@CreatedBy,@IsStaff,@FromDate,@MappedUserCardId OUTPUT, @result OUTPUT
	   
	   BEGIN TRANSACTION;
	   IF(@result=1)
	   BEGIN
	       UPDATE  [UserAccessCard] SET IsFinalised=1 WHERE UserId=@UserId
		   UPDATE [UserDetail] SET IsUserVerified = 1 WHERE UserId = @UserId
	       DELETE FROM [dbo].[TempUserAddressDetail] WHERE [RegistrationId] = @RegistrationId
           DELETE FROM [dbo].[TempUserRegistration]  WHERE [RegistrationId] = @RegistrationId
		   SET @success=@result 
	   END
	  ELSE 
	  BEGIN
	  SET @success=@result
	  END
	    COMMIT;
 END TRY
     BEGIN CATCH
	 IF(@@TRANCOUNT>0)
	 BEGIN
        ROLLBACK TRANSACTION;
	 END
    DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
	 SET @Success=0;
    EXEC [spInsertErrorLog]
	     @ModuleName = 'ManageUser'
        ,@Source = 'Proc_VerifyUserRegDetails'
        ,@ErrorMessage = @ErrorMessage
        ,@ErrorType = 'SP'
        ,@ReportedByUserId = @CreatedBy

		 SET @success=0
   END CATCH
GO
/****** Object:  StoredProcedure [dbo].[spFetchAllAccessCards]    Script Date: 25-11-2019 14:06:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spFetchAllAccessCards]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spFetchAllAccessCards] AS' 
END
GO
/***
   Created Date      :     2016-09-27
   Created By        :     Shubhra Upadhyay
   Purpose           :     This stored proc is used to get all access card
   Usage			 :	   EXEC [dbo].[spFetchAllAccessCards]
   --------------------------------------------------------------------------
***/
ALTER PROCEDURE [dbo].[spFetchAllAccessCards] 
AS
BEGIN
	SET NOCOUNT ON;

	IF OBJECT_ID('tempdb..#TempUserAccessCard') IS NOT NULL
	DROP TABLE #TempUserAccessCard

	CREATE TABLE #TempUserAccessCard
	( 
	   AccessCardId BIGINT NOT NULL,
	   AccessCardNo VARCHAR(100) NOT NULL,
	   IsPimco BIT NOT NULL,
	   IsTemporary BIT NOT NULL,
	   IsActive BIT NOT NULL,
	   EmployeeName VARCHAR(100) NOT NULL,
	   IsMapped BIT NOT NULL DEFAULT(0),
	)
   INSERT INTO #TempUserAccessCard([AccessCardId], [AccessCardNo], [IsPimco], [IsTemporary], [IsActive], [EmployeeName], [IsMapped])
   SELECT
       A.[AccessCardId]  AS [AccessCardId]
      ,A.[AccessCardNo]  AS [AccessCardNo]
      ,A.[IsPimco]       AS [IsPimcoCard]
      ,A.[IsTemporary]   AS [IsTemporaryCard]
      ,A.[IsActive]      AS [IsActive]
	  ,CASE
         WHEN VA.[UserId] IS NOT NULL THEN CAST (VA.EmployeeName AS VARCHAR(100))
		 ELSE CAST('NA' AS VARCHAR(5))
      END AS [EmployeeName]
      ,CASE
         WHEN VA.[UserId] IS NULL THEN CAST(0 AS [bit])
         ELSE CAST(1 AS [bit])
      END AS [IsMapped]
   FROM [dbo].[AccessCard] A WITH (NOLOCK)
      LEFT JOIN (
	      SELECT UC.[AccessCardId], UC.UserId
		  FROM [dbo].[UserAccessCard] UC WITH (NOLOCK) 
		  WHERE UC.[IsDeleted] = 0 AND UC.IsActive = 1 AND UC.UserId IS NOT NULL
	   ) T ON A.[AccessCardId] = T.[AccessCardId]
	  LEFT JOIN [vwActiveUsers] VA  ON T.UserId= VA.UserId
   WHERE A.[IsDeleted] = 0 

   UPDATE T SET T.[EmployeeName] = SM.[EmployeeName],
    T.IsMapped = CASE
         WHEN SM.[RecordId] IS NULL THEN CAST(0 AS [bit])
         ELSE CAST(1 AS [bit])
      END 
   FROM #TempUserAccessCard T 
   JOIN(  
          SELECT UC.[AccessCardId], UC.StaffUserId
		  FROM [dbo].[UserAccessCard] UC WITH (NOLOCK) 
		  WHERE UC.[IsDeleted] = 0 AND UC.IsActive = 1 AND UC.StaffUserId IS NOT NULL
		   ) A ON T.[AccessCardId] = A.[AccessCardId]
  LEFT JOIN [SupportingStaffMember] SM ON A.StaffUserId = SM.RecordId 

  SELECT [AccessCardId], [AccessCardNo], [IsPimco], [IsTemporary], [IsActive], [EmployeeName], [IsMapped]
  FROM #TempUserAccessCard 
  
END
GO
/****** Object:  StoredProcedure [dbo].[spFetchAllEmployeesByStatus]    Script Date: 25-11-2019 14:06:16 ******/
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
	WHERE U.[RoleId]<>1 AND  UD.IsUserVerified = 1 AND
	(((UD.[TerminateDate] IS NULL AND U.[IsActive]=1) AND @Status = 1) OR ((UD.[TerminateDate] IS NOT NULL OR U.[IsActive]=0) AND @Status = 2))
	ORDER BY LTRIM(RTRIM(REPLACE(REPLACE(REPLACE((UD.[FirstName] + ' ' + UD.[MiddleName] + ' ' + UD.[LastName]), ' ', '{}'), '}{',''), '{}', ' ')))
END
GO
