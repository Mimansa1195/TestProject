
/****** Object:  StoredProcedure [dbo].[spSaveNewUser]    Script Date: 23-01-2020 16:25:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spSaveNewUser]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spSaveNewUser]
GO
/****** Object:  StoredProcedure [dbo].[spGetAllUserRegistrations]    Script Date: 23-01-2020 16:25:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetAllUserRegistrations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetAllUserRegistrations]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetEmployeeWeekData]    Script Date: 23-01-2020 16:25:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetEmployeeWeekData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetEmployeeWeekData]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetAssetsDetailsByRequestId]    Script Date: 23-01-2020 16:25:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAssetsDetailsByRequestId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetAssetsDetailsByRequestId]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetAllUsersAssets]    Script Date: 23-01-2020 16:25:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAllUsersAssets]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetAllUsersAssets]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetAllAssetsByUserId]    Script Date: 23-01-2020 16:25:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAllAssetsByUserId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetAllAssetsByUserId]
GO
/****** Object:  StoredProcedure [dbo].[Proc_BulkAllocateAssets]    Script Date: 23-01-2020 16:25:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BulkAllocateAssets]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BulkAllocateAssets]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_GetAssetsTypeRoleWise]    Script Date: 23-01-2020 16:25:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetAssetsTypeRoleWise]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GetAssetsTypeRoleWise]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_GetAssetsTypeRoleWise]    Script Date: 23-01-2020 16:25:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetAssetsTypeRoleWise]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/***
   Created Date      :    21-Jan-2020
   Created By        :    Kanchan Kumari
   Purpose           :    Gets permission for assets
    Usage            :    SELECT * FROM [dbo].[Fun_GetAssetsTypeRoleWise](2432)
***/
CREATE FUNCTION [dbo].[Fun_GetAssetsTypeRoleWise]
(
 @LoginUserId INT
)
RETURNS @TempAssetTypePermission TABLE(
            AssetTypeId BIGINT,
			HasAllocateRights BIT,
			HasDeleteRights BIT,
			HasViewRights BIT,
			HasCollectRights BIT
          )
AS 
BEGIN
	  DECLARE @DesignationGrp VARCHAR(100)
	  SELECT @DesignationGrp = DesignationGroup FROM vwAllUsers WHERE UserId = @LoginUserId

	 IF(@DesignationGrp = ''Administration'')
	 BEGIN
	      INSERT INTO @TempAssetTypePermission(AssetTypeId, HasAllocateRights, HasDeleteRights, HasViewRights, HasCollectRights)
		  SELECT TypeId, 1, 1, 1, 0 FROM AssetType WHERE [Type] = ''Mobile''

		  INSERT INTO @TempAssetTypePermission(AssetTypeId, HasAllocateRights, HasDeleteRights, HasViewRights, HasCollectRights)
		  SELECT TypeId, 0, 0, 1, 1 FROM AssetType WHERE [Type] != ''Mobile''
	 END

	 IF(@DesignationGrp IN( ''IT/Network'', ''IT/Systems''))
	 BEGIN
	       INSERT INTO @TempAssetTypePermission(AssetTypeId, HasAllocateRights, HasDeleteRights, HasViewRights, HasCollectRights)
		  SELECT TypeId, 1, 1, 1, 0 FROM AssetType WHERE [Type] != ''Mobile''

		  INSERT INTO @TempAssetTypePermission(AssetTypeId, HasAllocateRights, HasDeleteRights, HasViewRights, HasCollectRights)
		  SELECT TypeId, 0, 0, 1, 0 FROM AssetType WHERE [Type] = ''Mobile''
	 END
	 RETURN 
END' 
END

GO
/****** Object:  StoredProcedure [dbo].[Proc_BulkAllocateAssets]    Script Date: 23-01-2020 16:25:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BulkAllocateAssets]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_BulkAllocateAssets] AS' 
END
GO
/***
   Created Date      :     2018-08-24
   Created By        :     Kanchan Kumari
   Purpose           :     This stored procedure is to draft Reimbursement data
   --------------------------------------------------------------------------
   Usage             :
   ---
   -----------------------------------------------------------------------
    DECLARE @Result tinyint, @NewRequestIds VARCHAR(500)
          EXEC [dbo].[Proc_BulkAllocateAssets]
           @LoginUserId = 2432
          ,@XmlString ='<Root>
						<Row UserId="21" AssetId="blue.jpg" FromDate="" Remarks = "ok"/>
						<Row UserId="21" AssetId="blue.jpg" FromDate="" Remarks = "ok"/>
						<Row UserId="21" AssetId="blue.jpg" FromDate="" Remarks = "ok"/>
						</Root>'
		 ,@NewAssetRequestIds = @NewRequestIds out
		 ,@Success = @Result out
   SELECT @Result AS Result, @NewRequestIds AS RequestId
***/
ALTER PROC [dbo].[Proc_BulkAllocateAssets]
(
 @LoginUserId INT,
 @XmlString XML,
 @Success tinyint = 0 output,
 @NewAssetRequestIds VARCHAR(500) = '' output
)
AS
BEGIN TRY
			IF OBJECT_ID('tempdb..#TempUserAssets') IS NOT NULL
			DROP TABLE #TempUserAssets

			IF OBJECT_ID('tempdb..#TempNewAssetRequestId') IS NOT NULL
			DROP TABLE #TempNewAssetRequestId

			CREATE TABLE #TempNewAssetRequestId
			(
			AssetRequestId BIGINT
			)

		    CREATE TABLE #TempUserAssets(Id INT IDENTITY(1,1), [UserId] INT, AssetId BIGINT, FromDate DATE, Remarks VARCHAR(500))
            INSERT INTO #TempUserAssets([UserId], AssetId, FromDate, Remarks)
			SELECT 
			    T.Item.value('@UserId', 'INT'),
			    T.Item.value('@AssetId', 'BIGINT'),
				T.Item.value('@FromDate', 'DATE'),
				T.Item.value('@Remarks', 'VARCHAR(500)')
			FROM @XmlString.nodes('/Root/Row')AS T(Item)


			IF EXISTS(SELECT 1 FROM UsersAssetDetail U 
			           JOIN #TempUserAssets T ON U.UserId = T.UserId AND U.AssetId = T.AssetId AND (U.IsActive = 1 OR (U.IsActive = 0 AND U.IsCollected = 0)))
            BEGIN
			     SET @Success = 2 --duplicate entry
			END
			ELSE
			BEGIN
			        DECLARE @Id INT= 1;
					WHILE(@Id <= (SELECT MAX(Id) FROM #TempUserAssets) )
					BEGIN
						INSERT INTO UsersAssetDetail(UserId, AssetId, AllocatedFrom, Remarks, CreatedBy)
						SELECT UserId, AssetId, FromDate, Remarks, @loginUserId FROM #TempUserAssets WHERE Id = @Id

						INSERT INTO #TempNewAssetRequestId(AssetRequestId)
						SELECT SCOPE_IDENTITY()
						SET @Id = @Id+1;
					END
						
					SET @Success = 1 --success
			END
	    SELECT @NewAssetRequestIds = STUFF( (SELECT ','+ CAST(AssetRequestId AS VARCHAR(8000))  FROM #TempNewAssetRequestId FOR XML PATH('')),  1,1,'' )
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
		,@Source = 'Proc_BulkAllocateAssets'
		,@ErrorMessage = @ErrorMessage
		,@ErrorType = 'SP'
		,@ReportedByUserId = @LoginUserId
END CATCH 
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetAllAssetsByUserId]    Script Date: 23-01-2020 16:25:06 ******/
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
   Usage        :  EXEC [dbo].[Proc_GetAllAssetsByUserId] @ActionCode = 'GG', @UserId = 2395, @LoginUserId = 2456
***/
ALTER PROCEDURE [dbo].[Proc_GetAllAssetsByUserId] 
(
  @ActionCode VARCHAR(20),
  @UserId INT,
  @LoginUserId INT
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
  
   SELECT T.*, N.HasAllocateRights, N.HasDeleteRights, N.HasViewRights, N.HasCollectRights 
   FROM #TempUsersAssetDetail T
   JOIN (SELECT * FROM [dbo].[Fun_GetAssetsTypeRoleWise](@LoginUserId)) N ON T.TypeId = N.AssetTypeId 
END






GO
/****** Object:  StoredProcedure [dbo].[Proc_GetAllUsersAssets]    Script Date: 23-01-2020 16:25:06 ******/
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
   Usage        :  EXEC [dbo].[Proc_GetAllUsersAssets] @ActionCode = 'GG', @LoginUserId = 2432
***/
ALTER PROCEDURE [dbo].[Proc_GetAllUsersAssets] 
(
  @ActionCode VARCHAR(20),
  @LoginUserId INT
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

	   SELECT T.*, N.HasAllocateRights, N.HasDeleteRights, N.HasViewRights, N.HasCollectRights 
	   FROM #TempUsersAssetDetail T
	   JOIN (SELECT * FROM [dbo].[Fun_GetAssetsTypeRoleWise](@LoginUserId)) N ON T.TypeId = N.AssetTypeId 
   
END





GO
/****** Object:  StoredProcedure [dbo].[Proc_GetAssetsDetailsByRequestId]    Script Date: 23-01-2020 16:25:06 ******/
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
   Usage        :  EXEC [dbo].[Proc_GetAssetsDetailsByRequestId] @AssetRequestIds = '496,497,498,499,500'
***/
ALTER PROCEDURE [dbo].[Proc_GetAssetsDetailsByRequestId] 
(
  @AssetRequestIds VARCHAR(8000)
)
AS
BEGIN
		   SELECT UA.AssetsRequestId, UD.EmployeeName, UD.EmployeeCode, UD.MobileNumber, UD.ReportingManagerName, 
		          UA.UserId, CONVERT(VARCHAR(11),UA.[AllocatedFrom],106) AS AllocateFrom, 
				  ISNULL(CONVERT(VARCHAR(11),UA.[AllocatedTill],106), '') AS AllocateTill, AM.AssetId, 
				  T.[TypeId], T.[Type], AB.[BrandId], AB.[BrandName],AM.[Model], AM.[SerialNo], 
				  AM.[Description], ISNULL(UA.Remarks, '') AS Remarks,
				  CONVERT(VARCHAR(11), UA.CreatedDate ,106)+' '+ FORMAT(UA.CreatedDate, 'hh:mm tt') AS [CreatedDate],
				   C.EmployeeName AS [CreatedBy], 
				  ISNULL(M.EmployeeName, '') AS [ModifiedBy], 
				  CASE WHEN UA.ModifiedDate IS NULL THEN '' 
					   ELSE CONVERT(VARCHAR(11), UA.ModifiedDate ,106)+' '+ FORMAT(UA.ModifiedDate, 'hh:mm tt') 
				  END AS ModifiedDate,
				  ISNULL(UA.DeAllocationRemarks,'') AS DeAllocationRemarks,
				  UD.ImagePath,
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
/****** Object:  StoredProcedure [dbo].[Proc_GetEmployeeWeekData]    Script Date: 23-01-2020 16:25:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetEmployeeWeekData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetEmployeeWeekData] AS' 
END
GO
/***
    Created Date      :     2019-01-15
   Created By        :     Mimansa Agrawal
   Purpose           :     This stored procedure fetches employee's week off detail
   Change History    :
   --------------------------------------------------------------------------
	   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
      EXEC Proc_GetEmployeeWeekData @LoginUserId=1108, @FromDate='2019-12-30',@TillDate='2020-02-02'
***/
ALTER PROC [dbo].[Proc_GetEmployeeWeekData]
(
 @LoginUserId INT 
,@FromDate DATE 
,@TillDate DATE 
)
AS
BEGIN
	SET FMTONLY OFF;
	SET NOCOUNT ON;

	DECLARE @FromDateId BIGINT, @TillDateId BIGINT

	SET @FromDateId = (SELECT DateId FROM DateMaster WHERE [Date]=@FromDate)
	SET @TillDateId = (SELECT DateId FROM DateMaster WHERE [Date]=@TillDate)

	IF OBJECT_ID('tempdb..#UserDateMapping') IS NOT NULL
	DROP TABLE #UserDateMapping
	IF OBJECT_ID('tempdb..#Emp') IS NOT NULL
    DROP TABLE #Emp
	CREATE TABLE #Emp(
      EmpId INT,
	  ManagerId INT
		)
	CREATE TABLE #UserDateMapping
	(
	 [DateId] [bigint] NOT NULL
	,[Date] [date] NOT NULL
	,[IsWeekend] BIT NOT NULL 
	,[UserId] [int] NOT NULL
	,[WeekNo] [INT] NOT NULL
	,[IsNormalWeek] BIT NOT NULL DEFAULT(1)
	)

 --Delegation in screen

  DECLARE  @NewUserId INT
  DECLARE @MenuId INT

  SELECT @MenuId = MenuId FROM Menu WHERE MenuName = 'Weekly Roster'

  SELECT @NewUserId = DelegatedFromUserId FROM MenusUserDelegation 
  WHERE MenuId = @MenuId AND DelegatedToUserId = @LoginUserId 
  AND CAST(GETDATE() AS DATE) BETWEEN DelegatedFromDate AND DelegatedTillDate
  AND IsActive = 1
  -----------------------
   
	INSERT INTO #Emp ([EmpId],[ManagerId])
    EXEC [dbo].[spGetEmployeesReportingToUser] @LoginUserId, 0, 0;
	--delegated users
	IF(@NewUserId > 0)
	BEGIN
		INSERT INTO #Emp ([EmpId],[ManagerId])
		EXEC [dbo].[spGetEmployeesReportingToUser] @NewUserId, 0, 0;
	END
	INSERT INTO #UserDateMapping([UserId],[DateId],[Date],[IsWeekend],[WeekNo])
	SELECT  U.[UserId], D.[DateId], D.[Date], D.[IsWeekend], (SELECT WeekNo FROM [dbo].[FetchDateAndWeekNo](D.[Date]))
	FROM [dbo].[DateMaster] D WITH (NOLOCK)
	CROSS JOIN [dbo].[UserDetail] U WITH (NOLOCK) 
	WHERE U.[UserId] IN (SELECT EmpId From #Emp) AND D.[Date] BETWEEN @FromDate AND @TillDate 

	 ----update [IsNormalWeek] of #UserDateMapping -------------------
	  UPDATE U SET U.[IsNormalWeek] = 0 FROM #UserDateMapping U 
	  INNER JOIN (
	             SELECT Q.[WeekNo], T.[UserId] 
				 FROM EmployeeWiseWeekOff T WITH (NOLOCK)
				 JOIN #UserDateMapping Q ON T.[UserId] = Q.[UserId] AND T.[WeekOffDateId] = Q.[DateId] 
				 WHERE T.[IsActive] = 1
				 GROUP BY T.[UserId], Q.[WeekNo]
				 ) N ON U.[UserId] = N.[UserId] AND U.[WeekNo] = N.[WeekNo]
    -------delete data where normal week----------------
				 ;WITH ExcludedUsers AS
				(
				 select * from #UserDateMapping
				 WHERE IsNormalWeek = 1
				 )
				DELETE FROM
				ExcludedUsers
     --delete entries of employees for which data is available in #TempCalenderRoaster-----
	DELETE U 
	FROM #UserDateMapping U WITH (NOLOCK) JOIN EmployeeWiseWeekOff T 
	ON U.[UserId] = T.[UserId] AND U.[DateId] = T.[WeekOffDateId] AND T.[IsActive]=1
	-----select week days of employees----------
    SELECT DateId,[Date],IsWeekend,UserId,WeekNo,IsNormalWeek FROM #UserDateMapping 
	--WHERE UserId IN (SELECT UserId FROM EmployeeWiseWeekOff WHERE WeekOffDateId BETWEEN @FromDateId AND @TillDateId)
END


GO
/****** Object:  StoredProcedure [dbo].[spGetAllUserRegistrations]    Script Date: 23-01-2020 16:25:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetAllUserRegistrations]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGetAllUserRegistrations] AS' 
END
GO
/***
   Created Date      :     2016-11-
   Created By        :     Shubhra Upadhyay
   Purpose           :     This stored proc is used to fetch all user registration profiles for HR verification
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   
   --------------------------------------------------------------------------

   Test Cases        :
   --------------------------------------------------------------------------
   
   --- Test Case 1
         EXEC [dbo].[spGetAllUserRegistrations]
***/

ALTER PROCEDURE [dbo].[spGetAllUserRegistrations] 
AS
BEGIN

   SET NOCOUNT ON

	SELECT
       T.[RegistrationId] AS [RegistrationId]
      ,T.[EmailId] AS [EmailId]
      ,T.[GuidExpiryDate] AS [GuidExpiryDate]  
      ,T.[IsSubmitted] AS [IsSubmitted]
      ,T.[IsVerified]  AS [IsVerified]
	  ,ISNULL(T.[ADUserName],'') AS ADUserName
	  ,CONVERT(VARCHAR(11),T.CreatedDate,106)+' '+FORMAT(T.CreatedDate, 'hh:mm tt') AS [CreatedOn]
	  ,V.EmployeeName 
	FROM [dbo].[TempUserRegistration] T WITH (NOLOCK)
		  JOIN vwAllUsers V ON T.CreatedBy = V.UserId
	WHERE T.[IsActive] = 1
END



GO
/****** Object:  StoredProcedure [dbo].[spSaveNewUser]    Script Date: 23-01-2020 16:25:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spSaveNewUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spSaveNewUser] AS' 
END
GO
/***
   Created Date      :     2016-11-30
   Created By        :     Shubhra Upadhyay
   Purpose           :     This stored procedure is to save a new user (result -> true: success, false: failure)
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   
   --------------------------------------------------------------------------

   Test Cases        :
   --------------------------------------------------------------------------

   --- Test Case 1
         DECLARE @Usr INT, @res int
         EXEC [dbo].[spSaveNewUser]
             @RegistrationId = 3
             ,@UserName = 'v7dBXhOXkXyqYlDwYki3Fw==' 
             ,@Dob = '4Ea8CbheEbabfwRC/9EUxQB97nHAZ6ND'
             ,@BloodGroup = 'KxWIFmk5Oc+58NhL+KlXOw=='
             ,@EmailId = 'v7dBXhOXkXyPPlWRVWaXi8F8MiKkCki2Ej5ibLBVUVGXqN75EJ7HNA=='
             ,@MobileNumber = 'z/c9Ya2bHtYKHnJGdmBAgw=='
             ,@EmployeeId = 'GSI G 038'
             ,@DepartmentId = 2
             ,@DesignationId = 1
			 ,@ProbationPeriod = 6
             ,@TeamId = 3
             ,@WsNo = 'wsno'
             ,@ExtensionNo = 'ex'
             --,@AccCardNo = 'acc'
             ,@Doj = '12/21/2016'
             ,@RoleId = 3
             ,@ReportingManagerId = 0
             ,@UserId = 84
             ,@PasswordResetCode = '5TUWKYCQ1L'
			 ,@Success = @res output
			 ,@NewUser = @Usr output
			 SELECT @res AS RESULT, @Usr AS USERNEW
              
***/
ALTER PROCEDURE [dbo].[spSaveNewUser]
(
     @RegistrationId bigint
    ,@UserName varchar(100)
    ,@Dob varchar(50)
    ,@BloodGroup varchar(50)
    ,@EmailId varchar(150)
    ,@MobileNumber varchar(50)
    ,@EmployeeId varchar(50)
    ,@DepartmentId int
    ,@DesignationId int
	,@ProbationPeriod int
    ,@TeamId bigint
    ,@WsNo varchar(20)
    ,@ExtensionNo varchar(10)
    --,@AccCardNo varchar(50)
    ,@Doj varchar(20)
    ,@RoleId int
    ,@ReportingManagerId int
    ,@UserId int
    ,@PasswordResetCode varchar(15)
	,@Success tinyint = 0 output
	,@NewUser int = 0 output
) 
AS
BEGIN TRY 
	SET NOCOUNT ON;

	IF EXISTS(SELECT 1 FROM UserDetail 
	WHERE REPLACE(LTRIM(REPLACE(REPLACE(EmployeeId,' ',''), '0', ' ')), ' ', '0') = REPLACE(LTRIM(REPLACE(REPLACE(@EmployeeId,' ',''), '0', ' ')), ' ', '0'))
	BEGIN
		SET @Success = 2; -- employeeid exists
		SET @NewUser = 0;
	END
    ELSE
	BEGIN 
         BEGIN TRANSACTION
         INSERT INTO [dbo].[User]
         (
             [LocationId]
            ,[RoleId]
            ,[UserName]
            ,[IsActive]
            ,[UnsuccessfulLoginAttempt]
            ,[IsLocked]
            ,[IsSuspended]
            ,[IsPasswordResetRequired]
            ,[CreatedDate]
            ,[CreatedBy]
            ,[PasswordResetCode]
            ,[IsPasswordResetCodeExpired]
			,[ADUserName]
         )
        SELECT
             1
            ,@RoleId
            ,@UserName
            ,1
            ,0
            ,0
            ,0
            ,1
            ,GETDATE()
            ,@UserId
            ,@PasswordResetCode
            ,0
			,ADUserName
         FROM [dbo].[TempUserRegistration]  WITH (NOLOCK) WHERE [RegistrationId] = @RegistrationId
		 GROUP BY ADUserName

         DECLARE @NewUserId int = SCOPE_IDENTITY() --new UserId
           
         INSERT INTO [dbo].[UserDetail]   -- insert in UserDetail table
         (
             [UserId]
            ,[FirstName]
            ,[MiddleName]
            ,[LastName]
            ,[DOB]
            ,[GenderId]
            ,[MaritalStatusId]
            ,[BloodGroup]
            ,[MobileNumber]
            ,[EmailId]
            ,[EmployeeId]
            ,[JoiningDate]
            ,[DesignationId]
            --,[CreatedBy]
            ,[ReportTo]
            ,[EmergencyContactNumber]
            ,[PersonalEmailId]
            --,[DepartmentId]
            --,[AssignedWorkStation]
            ,[ExtensionNumber]
            ,[InsuranceAmount]
            ,[PanCardId]
            ,[AadhaarCardId]
            ,[VoterCardId]
            ,[DrivingLicenseId]
            ,[PassportId]
            ,[LastEmployerName]
            ,[LastEmployerLocation]
            ,[LastJobTenure]
            ,[JobLeavingReason]
            ,[UAN]
            ,[IsFresher]
            ,[LastJobDesignation]
            ,[ImagePath]
			,[ProbationPeriodMonths]
            --,[PhotoFileName]
         )
         SELECT
           @NewUserId
           ,UR.[FirstName]
           ,ISNULL(UR.[MiddleName], '')
           ,UR.[LastName]
           ,@Dob
           ,UR.[GenderId]
           ,UR.[MaritalStatusId]
           ,@BloodGroup
           ,@MobileNumber
           ,@EmailId
           ,@EmployeeId
           ,@Doj
           ,@DesignationId
           --,UR.[CreatedBy]
           ,@ReportingManagerId
           ,UR.[EmergencyContactNumber]
           ,UR.[PersonalEmailId]
           --,@DepartmentId
           --,@WsNo
           ,@ExtensionNo
           ,UR.[InsuranceAmount]
           ,UR.[PanCardId]
           ,UR.[AadhaarCardId]
           ,UR.[VoterCardId]
           ,UR.[DrivingLicenseId]
           ,UR.[PassportId]
           ,UR.[LastEmployerName]
           ,UR.[LastEmployerLocation]
           ,UR.[LastJobTenure]
           ,UR.[JobLeavingReason]
           ,UR.[LastJobUAN]
           ,UR.[IsFresher]
           ,UR.[LastJobDesignation]
           ,UR.[PhotoFileName]
		   ,@ProbationPeriod
         FROM [dbo].[TempUserRegistration] UR WITH (NOLOCK) WHERE UR.[RegistrationId] = @RegistrationId
         
         INSERT INTO [dbo].[UserAddressDetail]  --insert in UserAddressDetail table
         (
             [UserId]
            ,[Address]
            ,[CountryId]
            ,[StateId]
            ,[CityId]
            ,[PinCode]
            ,[IsAddressPermanent]
            ,[IsActive]
         )
         SELECT
             @NewUserId
            ,UA.[Address]
            ,UA.[CountryId]
            ,UA.[StateId]
            ,UA.[CityId]
            ,UA.[PinCode]
            ,UA.[IsAddressPermanent]
            ,1
         FROM [dbo].[TempUserAddressDetail] UA WITH (NOLOCK) WHERE UA.[RegistrationId] = @RegistrationId
         
         ------------------insert into [UserTeamMapping] starts------------------
         INSERT INTO [dbo].[UserTeamMapping]  
         (
             [UserId]
            ,[TeamId]
            ,[CreatedBy]
            ,[TeamRoleId]
            ,[ConsiderInClientReports]
         )
         SELECT
               @NewUserId
            ,@TeamId
            ,@UserId
            ,7 --set default role as General
            ,0     
         ------------------insert into [UserTeamMapping] ends------------------

         ------------------insert into [LeaveBalance] starts------------------
         IF( (SELECT [IsIntern] FROM [dbo].[Designation] WHERE [DesignationId] = @DesignationId) = 0) --credit leaves for non intern designations
         BEGIN
            DECLARE @JoiningDate int = (SELECT DATEPART(dd, @Doj))
            DECLARE @JoiningMonth int = (SELECT DATEPART(mm, @Doj))  
		    DECLARE @CurrentMonth INT=(SELECT DATEPART(mm, GETDATE()))
            DECLARE @CurrentYear INT=(SELECT DATEPART(YYYY, GETDATE()))  
			DECLARE @JoiningYear INT=(SELECT DATEPART(YYYY, @Doj))   
            DECLARE @CLCount int,@PLCount int
			SET @CLCount = CASE
                              WHEN @JoiningMonth BETWEEN 4 AND 12 THEN (16 - @JoiningMonth)
                              ELSE (4 - @JoiningMonth)
                           END
            IF(@JoiningDate > 10)
               SET @CLCount = @CLCount - 1
            SET @PLCount=CASE
				WHEN @JoiningDate > 15 AND @CurrentYear=@JoiningYear  THEN  @CurrentMonth-@JoiningMonth
				WHEN @JoiningDate > 15 AND @CurrentYear!=@JoiningYear  THEN 12 + @CurrentMonth-@JoiningMonth
				WHEN @JoiningDate <= 15 AND @CurrentYear!=@JoiningYear  THEN 13 + @CurrentMonth-@JoiningMonth
				ELSE @CurrentMonth-@JoiningMonth+1 
				END     
            INSERT INTO [dbo].[LeaveBalance]
            (
               [UserId]
              ,[LeaveTypeId]
,[Count]
              ,[CreatedBy]
            )
            SELECT
               @NewUserId
              ,M.[TypeId]
              ,CASE
                  WHEN M.[ShortName] = 'PL' THEN @PLCount
                  WHEN M.[ShortName] = 'CL' THEN @CLCount
                  WHEN M.[ShortName] = '5CLOY' THEN 1
                  ELSE 0
               END
              ,@UserId
            FROM [dbo].[LeaveTypeMaster] M WITH (NOLOCK)
         END
         ELSE  --credit 3 CL for interns quarterly
         BEGIN
		 DECLARE @JDate int = (SELECT DATEPART(dd, @Doj))
            DECLARE @JMonth int = (SELECT DATEPART(mm, @Doj))         
            DECLARE @CLCountInterns int

            SET @CLCountInterns = CASE
                              WHEN @JMonth IN (1,4,7,10) THEN 3
							  WHEN @JMonth IN (2,5,8,11) THEN 2
                              ELSE 1
                           END
            IF(@JDate > 15)          ----if date greater than 15 then reduce CL by 1
               SET @CLCountInterns = @CLCountInterns - 1
            INSERT INTO [dbo].[LeaveBalance]
            (
               [UserId]
              ,[LeaveTypeId]
              ,[Count]
              ,[CreatedBy]
            )
            SELECT
               @NewUserId
              ,M.[TypeId]
              ,CASE
			  WHEN M.[ShortName]='CL' THEN @CLCountInterns
			  ELSE 0
			  END
              ,@UserId
   FROM [dbo].[LeaveTypeMaster] M WITH (NOLOCK)
         END
         
         ------------------insert into [LeaveBalance] ends------------------

         --DELETE FROM [dbo].[TempUserAddressDetail] WHERE [RegistrationId] = @RegistrationId
         --DELETE FROM [dbo].[TempUserRegistration] WHERE [RegistrationId] = @RegistrationId
		  
		  SET @Success = 1; -- duplicate user
	      SET @NewUser = @NewUserId;

         COMMIT TRANSACTION;
   END       
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
    ROLLBACK TRANSACTION;

	SET @Success = 0; -- duplicate user
	SET @NewUser = 0;

    DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
    EXEC [spInsertErrorLog]
	    @ModuleName = 'UserManagement'
    ,@Source = 'spSaveNewUser'
    ,@ErrorMessage = @ErrorMessage
    ,@ErrorType = 'SP'
    ,@ReportedByUserId = @UserId   
	     
END CATCH
GO
