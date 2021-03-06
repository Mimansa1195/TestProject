ALTER TABLE UsersAssetDetail ADD CollectedOn DATETIME NULL 
GO
ALTER TABLE UsersAssetDetail ADD CollectedBy INT NULL 
GO

/****** Object:  StoredProcedure [dbo].[Proc_GetAssetsDetailsByRequestId]    Script Date: 29-11-2019 10:31:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAssetsDetailsByRequestId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetAssetsDetailsByRequestId]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetAllAssetsDetail]    Script Date: 29-11-2019 10:31:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAllAssetsDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetAllAssetsDetail]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetAllAssetsByUserId]    Script Date: 29-11-2019 10:31:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAllAssetsByUserId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetAllAssetsByUserId]
GO
/****** Object:  StoredProcedure [dbo].[Proc_AddUpdateUsersAsset]    Script Date: 29-11-2019 10:31:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddUpdateUsersAsset]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AddUpdateUsersAsset]
GO
/****** Object:  StoredProcedure [dbo].[Proc_AddUpdateAssetsDetail]    Script Date: 29-11-2019 10:31:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddUpdateAssetsDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AddUpdateAssetsDetail]
GO
/****** Object:  StoredProcedure [dbo].[Proc_AddUpdateAssetsDetail]    Script Date: 29-11-2019 10:31:09 ******/
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
	 @AssetTypeId  = 7,
	 @BrandId = 2 ,
	 @Model = '6470',
	 @SerialNumber = 'Test1234' ,
	 @Description = '',
	 @IsActive = 1,
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
	 ELSE
	 BEGIN
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
/****** Object:  StoredProcedure [dbo].[Proc_AddUpdateUsersAsset]    Script Date: 29-11-2019 10:31:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddUpdateUsersAsset]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_AddUpdateUsersAsset] AS' 
END
GO
/*  
   Created Date : 10-July-2019
   Created By   : Kanchan Kumari
   Purpose      : To add or update users assigned asset  
   -----------------------------
   Test Case    : 
   DECLARE @Result int , @AssetReqId varchar(50)
   EXEC [dbo].[Proc_AddUpdateUsersAsset]
     @UserId = 2432,
	 @AssetRequestIds = '0',
     @AssetIds = '5',
	 @FromDate  = '2019-06-01',
	 @TillDate  = null,
	 @Remarks = '',
	 @ActionCode = 'DL',
	 @IsActive = 1,
	 @loginUserId = 1 ,
	 @Success = @Result output,
	 @NewAssetRequestIds = @AssetReqId output
	 SELECT @Result AS [RESULT], @AssetReqId AS AssetRequestId
*/
ALTER PROC [dbo].[Proc_AddUpdateUsersAsset]
(
 @UserId INT,
 @AssetRequestIds VARCHAR(8000),
 @AssetIds VARCHAR(8000),
 @FromDate VARCHAR(15),
 @TillDate VARCHAR(15) = null,
 @Remarks VARCHAR(500),
 @ActionCode VARCHAR(50),
 @IsActive BIT,
 @loginUserId INT,
 @Success tinyint out,
 @NewAssetRequestIds VARCHAR(8000) out
)
AS
BEGIN TRY
     SET NOCOUNT ON;
     BEGIN TRANSACTION

	 --DECLARE @FromDateId BIGINT, @TillDateId BIGINT
	 
	 --SELECT @FromDateId = DateId FROM DateMaster WHERE [Date] = @FromDate

	 --SELECT @TillDateId = DateId FROM DateMaster WHERE [Date] = @TillDate AND @TillDate IS NOT NULL

	 /*
	   AL - Asset Lost, AC - Asset Collected
	  */
	  IF OBJECT_ID('tempdb..#TempAssetRequestId') IS NOT NULL
	  DROP TABLE #TempAssetRequestId

	  IF OBJECT_ID('tempdb..#TempAssetId') IS NOT NULL
	  DROP TABLE #TempAssetId

	  IF OBJECT_ID('tempdb..#TempNewAssetRequestId') IS NOT NULL
	  DROP TABLE #TempNewAssetRequestId

	  CREATE TABLE #TempAssetRequestId
	  (
	   AssetRequestId BIGINT
	  )

	  CREATE TABLE #TempAssetId
	  (
	   Id INT NOT NULL IDENTITY(1,1),
	   AssetId BIGINT
	  )
	 
	  CREATE TABLE #TempNewAssetRequestId
	  (
	   AssetRequestId BIGINT
	  )

	  INSERT INTO #TempAssetRequestId(AssetRequestId)
	  SELECT SplitData FROM [dbo].[Fun_SplitStringInt](@AssetRequestIds, ',') 

	  INSERT INTO #TempAssetId(AssetId)
	  SELECT SplitData FROM [dbo].[Fun_SplitStringInt](@AssetIds, ',') 

     IF EXISTS(SELECT 1 FROM UsersAssetDetail AM INNER JOIN #TempAssetId TA ON AM.AssetId = TA.AssetId 
	                      WHERE AM.UserId = @UserId 
			              AND AM.AllocatedFrom = @FromDate
						  AND AM.IsActive = 1 AND @IsActive = 1
						  )
     BEGIN 
	    
	      SET @Success = 2 --duplicate
	 END
	 ELSE 
	 BEGIN
				 IF((SELECT COUNT(*) FROM #TempAssetRequestId WHERE AssetRequestId > 0) = 0)
				 BEGIN 
				       DECLARE @Id INT= 1;

				        WHILE(@Id <= (SELECT MAX(Id) FROM #TempAssetId) )
						BEGIN
						INSERT INTO UsersAssetDetail(UserId, AssetId, AllocatedFrom, Remarks, CreatedBy)
						SELECT @UserId, AssetId, @FromDate, @Remarks, @loginUserId FROM #TempAssetId WHERE Id = @Id

						INSERT INTO #TempNewAssetRequestId(AssetRequestId)
						SELECT SCOPE_IDENTITY()

						SET @Id = @Id+1;

						END
						
						SET @Success = 1 --success
				 END
				 ELSE
				 BEGIN 
						IF(@ActionCode = 'AC')
						BEGIN
						        UPDATE AM SET  AM.IsCollected  = 1 , AM.CollectedOn = GETDATE(), AM.CollectedBy = @loginUserId
						        FROM UsersAssetDetail AM JOIN #TempAssetRequestId TR 
								     WITH (NOLOCK) ON AM.AssetsRequestId = TR.AssetRequestId
								WHERE @IsActive = 0
								SET @Success = 1 --success
						END

						IF(@ActionCode = 'AL' OR @ActionCode = 'DA')
						BEGIN
						        UPDATE AM SET AM.IsActive = 0, AM.AllocatedTill = @TillDate, AM.DeAllocationRemarks = @Remarks,
						        AM.IsLost = CASE WHEN @ActionCode = 'AL' THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END,
						        AM.ModifiedDate = GETDATE(), AM.ModifiedBy = @loginUserId
						        FROM UsersAssetDetail AM JOIN #TempAssetRequestId TR 
								WITH (NOLOCK) ON AM.AssetsRequestId = TR.AssetRequestId
								WHERE @IsActive = 0

								SET @Success = 1 --success
						END
						
				 END
    END
	
	 SELECT @NewAssetRequestIds = STUFF( (SELECT ','+ CAST(AssetRequestId AS VARCHAR(8000))  FROM #TempNewAssetRequestId FOR XML PATH('')),  1,1,'' )
										 
	 COMMIT;
     
END TRY
BEGIN CATCH
    IF @@TRANCOUNT>0
	ROLLBACK TRANSACTION;

	  SET @Success = 0 -- Error occurred
    
	  SELECT @NewAssetRequestIds = STUFF( (SELECT ','+ '0' FOR XML PATH('')),  1,1,'' )

	DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
	--Log Error
	EXEC [spInsertErrorLog]
			@ModuleName = 'Asset Allocation'
		,@Source = 'Proc_AddUpdateUsersAsset'
		,@ErrorMessage = @ErrorMessage
		,@ErrorType = 'SP'
		,@ReportedByUserId = @LoginUserId
END CATCH 
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetAllAssetsByUserId]    Script Date: 29-11-2019 10:31:09 ******/
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
   Usage        :  EXEC [dbo].[Proc_GetAllAssetsByUserId] @ActionCode = 'GG', @UserId = 2395
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
		[DeAllocationRemarks] VARCHAR(500) NOT NULL DEFAULT(CAST('' AS VARCHAR(500))),
		[CollectedOn] VARCHAR(20),
		[CollectedBy] VARCHAR(200)
	)
	IF(@ActionCode = 'AA') -- active assets
	BEGIN   

	       INSERT INTO #TempUsersAssetDetail([AssetsRequestId], [EmployeeName], [EmployeeCode], [UserId], [AllocateFrom],[AllocateTill],  
		                  [AssetId], [TypeId], [Type], [BrandId], [BrandName], [Remarks], [Model], [Description], [SerialNo], [Status], [CreatedDate], 
					      [CreatedBy], [ModifiedBy], [ModifiedDate],[CollectedOn], [CollectedBy]
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
				  END AS ModifiedDate, 
				  CASE WHEN UA.CollectedOn IS NULL THEN '' 
					   ELSE CONVERT(VARCHAR(11), UA.CollectedOn ,106)+' '+ FORMAT(UA.CollectedOn, 'hh:mm tt') 
				  END AS CollectedOn, 
				  ISNULL(CU.EmployeeName,'') AS CollectedBy
		   FROM UsersAssetDetail UA 
		   JOIN vwAllUsers UD ON UA.UserId = UD.UserId
		   INNER JOIN [dbo].[AssetsMaster] AM  ON UA.AssetId = AM.AssetId
		   INNER JOIN [dbo].[AssetType] T ON AM.AssetTypeId = T.TypeId
		   INNER JOIN [dbo].[AssetsBrand] AB ON AM.BrandId = AB.BrandId
		   INNER JOIN [dbo].[vwAllUsers] C ON UA.CreatedBy = C.UserId
		   LEFT JOIN [dbo].[vwAllUsers] M ON UA.ModifiedBy = M.UserId
		   LEFT JOIN [dbo].[vwAllUsers] CU ON UA.CollectedBy = CU.UserId
		   WHERE UA.IsActive = 1 AND UA.UserId = @UserId
		   ORDER BY UA.CreatedDate DESC, UA.ModifiedDate DESC
		  
    END
	ELSE IF(@ActionCode = 'DA') -- deallocated asset (not collected, not lost)
	BEGIN

	       INSERT INTO #TempUsersAssetDetail([AssetsRequestId], [EmployeeName], [EmployeeCode], [UserId], [AllocateFrom],[AllocateTill],  
		                  [AssetId], [TypeId], [Type], [BrandId], [BrandName], [Remarks], [Model], [Description], [SerialNo], [Status], [CreatedDate], 
					  [CreatedBy], [ModifiedBy], [ModifiedDate],[CollectedOn], [CollectedBy]
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
				  END AS ModifiedDate,
				  CASE WHEN UA.CollectedOn IS NULL THEN '' 
					   ELSE CONVERT(VARCHAR(11), UA.CollectedOn ,106)+' '+ FORMAT(UA.CollectedOn, 'hh:mm tt') 
				  END AS CollectedOn, 
				  ISNULL(CU.EmployeeName,'') AS CollectedBy
		FROM UsersAssetDetail UA 
		   JOIN vwAllUsers UD ON UA.UserId = UD.UserId
		   INNER JOIN [dbo].[AssetsMaster] AM  ON UA.AssetId = AM.AssetId
		   INNER JOIN [dbo].[AssetType] T ON AM.AssetTypeId = T.TypeId
		   INNER JOIN [dbo].[AssetsBrand] AB ON AM.BrandId = AB.BrandId
		   INNER JOIN [dbo].[vwAllUsers] C ON UA.CreatedBy = C.UserId
		   LEFT JOIN [dbo].[vwAllUsers] M ON UA.ModifiedBy = M.UserId
		   LEFT JOIN [dbo].[vwAllUsers] CU ON UA.CollectedBy = CU.UserId
		   WHERE UA.IsActive = 0 AND UA.IsLost = 0 AND UA.IsCollected = 0 AND UA.UserId = @UserId
		   ORDER BY UA.CreatedDate DESC, UA.ModifiedDate DESC
   END
    ELSE 
	BEGIN --(collected or lost)

	       INSERT INTO #TempUsersAssetDetail([AssetsRequestId], [EmployeeName], [EmployeeCode], [UserId], [AllocateFrom],[AllocateTill],  
		                  [AssetId], [TypeId], [Type], [BrandId], [BrandName], [Remarks], [Model], [Description], [SerialNo], [Status], [CreatedDate], 
					      [CreatedBy], [ModifiedBy], [ModifiedDate],[DeAllocationRemarks], [CollectedOn], [CollectedBy]
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
				  END AS ModifiedDate, CAST(ISNULL(UA.DeAllocationRemarks,'') AS VARCHAR(500)),
				   CASE WHEN UA.CollectedOn IS NULL THEN '' 
					   ELSE CONVERT(VARCHAR(11), UA.CollectedOn ,106)+' '+ FORMAT(UA.CollectedOn, 'hh:mm tt') 
				  END AS CollectedOn, 
				  ISNULL(CU.EmployeeName,'') AS CollectedBy
		  FROM  UsersAssetDetail UA 
		   JOIN vwAllUsers UD ON UA.UserId = UD.UserId
		   INNER JOIN [dbo].[AssetsMaster] AM  ON UA.AssetId = AM.AssetId
		   INNER JOIN [dbo].[AssetType] T ON AM.AssetTypeId = T.TypeId
		   INNER JOIN [dbo].[AssetsBrand] AB ON AM.BrandId = AB.BrandId
		   INNER JOIN [dbo].[vwAllUsers] C ON UA.CreatedBy = C.UserId
		   LEFT JOIN [dbo].[vwAllUsers] M ON UA.ModifiedBy = M.UserId
		   LEFT JOIN [dbo].[vwAllUsers] CU ON UA.CollectedBy = CU.UserId
		   WHERE UA.IsActive = 0 AND UA.UserId = @UserId --AND (UA.IsLost = 1 AND UA.IsCollected = 1)
		   ORDER BY UA.CreatedDate DESC, UA.ModifiedDate DESC
   END

   SELECT * FROM #TempUsersAssetDetail
END






GO
/****** Object:  StoredProcedure [dbo].[Proc_GetAllAssetsDetail]    Script Date: 29-11-2019 10:31:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAllAssetsDetail]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetAllAssetsDetail] AS' 
END
GO
/***
   Created Date :    10-July-2019
   Created By   :   Kanchan Kumari
   Purpose      :   Get all assets detail
   Usage        :  EXEC [dbo].[Proc_GetAllAssetsDetail]
***/

ALTER PROCEDURE [dbo].[Proc_GetAllAssetsDetail] 
AS
BEGIN
	SET NOCOUNT ON;
	SET FMTONLY OFF;
  CREATE TABLE #TempUsersAssets
  (
    AssetId INT,
	IsLost BIT,
	UserId INT,
	CreatedDate DATETIME
  )
  INSERT INTO #TempUsersAssets(AssetId, IsLost, UserId, CreatedDate)
  SELECT AssetId, IsLost, UserId, CreatedDate FROM UsersAssetDetail WHERE IsActive = 1 OR (IsActive = 0 AND IsCollected = 0 AND IsLost = 0) OR 
                                              (IsActive = 0 AND IsCollected = 0 AND IsLost = 1)
  

   SELECT AM.AssetId, T.[TypeId], T.[Type], AB.[BrandId], AB.[BrandName], 
          AM.[Model], AM.[Description], AM.[SerialNo], AM.IsActive, 
		  CONVERT(VARCHAR(11),AM.CreatedDate,106)+' '+ FORMAT(AM.CreatedDate, 'hh:mm tt') AS CreatedDate, C.EmployeeName AS CreatedBy, 
		 CASE WHEN AM.ModifiedDate IS NULL THEN '' 
		      ELSE CONVERT(VARCHAR(11), AM.ModifiedDate,106)+' '+ FORMAT(AM.ModifiedDate, 'hh:mm tt') 
	     END AS ModifiedDate, M.EmployeeName AS ModifiedBy,

		 CASE WHEN US.AssetId IS NOT NULL THEN  CAST(0 AS BIT)  
	          ELSE  CAST(1 AS BIT)
		 END AS IsFree,

		  CASE WHEN US.AssetId IS NOT NULL AND US.IsLost = 0 THEN  V.EmployeeName 
	          ELSE ''
		  END AS AssignedTo,

		 CASE WHEN US.AssetId IS NOT NULL AND US.IsLost = 0 THEN CONVERT(VARCHAR(15), US.CreatedDate, 106)+' '+FORMAT(US.CreatedDate, 'hh:mm tt') 
		  ELSE '' END AS AssignedOn,

		 ISNULL(US.IsLost, CAST(0 AS BIT)) AS IsLost

   FROM [dbo].[AssetsMaster] AM WITH (NOLOCK)
   INNER JOIN [dbo].[AssetType] T WITH (NOLOCK)
         ON AM.AssetTypeId = T.TypeId
   INNER JOIN [dbo].[AssetsBrand] AB
         ON AM.BrandId = AB.BrandId
   INNER JOIN [dbo].[vwAllUsers] C 
         ON AM.CreatedBy = C.UserId
   LEFT JOIN #TempUsersAssets US 
         ON AM.AssetId = US.AssetId 
   LEFT JOIN [dbo].[vwAllUsers] V ON US.UserId = V.UserId
   LEFT JOIN [dbo].[vwAllUsers] M 
        ON AM.ModifiedBy = M.UserId
   GROUP BY AM.AssetId, T.[TypeId], T.[Type], AB.[BrandId], AB.[BrandName], 
          AM.[Model], AM.[Description], AM.[SerialNo], AM.IsActive, AM.CreatedDate, C.EmployeeName, AM.ModifiedDate,
		   M.EmployeeName, US.IsLost, V.EmployeeName, US.CreatedDate , US.AssetId
   ORDER BY AM.CreatedDate DESC, AM.ModifiedDate DESC
END





GO
/****** Object:  StoredProcedure [dbo].[Proc_GetAssetsDetailsByRequestId]    Script Date: 29-11-2019 10:31:09 ******/
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
				  UD.MobileNumber,
				   CASE WHEN UA.CollectedOn IS NULL THEN '' 
					   ELSE CONVERT(VARCHAR(11), UA.CollectedOn ,106)+' '+ FORMAT(UA.CollectedOn, 'hh:mm tt') 
				  END AS CollectedOn, 
				  ISNULL(CU.EmployeeName,'') AS CollectedBy
		   FROM UsersAssetDetail UA 
		   JOIN vwAllUsers UD ON UA.UserId = UD.UserId
		   INNER JOIN [dbo].[AssetsMaster] AM  ON UA.AssetId = AM.AssetId
		   INNER JOIN [dbo].[AssetType] T ON AM.AssetTypeId = T.TypeId
		   INNER JOIN [dbo].[AssetsBrand] AB ON AM.BrandId = AB.BrandId
		   INNER JOIN [dbo].[vwAllUsers] C ON UA.CreatedBy = C.UserId
		   LEFT JOIN [dbo].[vwAllUsers] M ON UA.ModifiedBy = M.UserId
		   LEFT JOIN [dbo].[vwAllUsers] CU ON UA.CollectedBy = CU.UserId
		   WHERE UA.AssetsRequestId IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt](@AssetRequestIds, ','))
END






GO
