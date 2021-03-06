/****** Object:  StoredProcedure [dbo].[Proc_GetAllUsersAssets]    Script Date: 15-07-2019 17:15:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAllUsersAssets]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetAllUsersAssets]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetAllAssetsDetail]    Script Date: 15-07-2019 17:15:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAllAssetsDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetAllAssetsDetail]
GO
/****** Object:  StoredProcedure [dbo].[Proc_AddUpdateUsersAsset]    Script Date: 15-07-2019 17:15:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddUpdateUsersAsset]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AddUpdateUsersAsset]
GO
/****** Object:  StoredProcedure [dbo].[Proc_AddUpdateAssetsDetail]    Script Date: 15-07-2019 17:15:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddUpdateAssetsDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AddUpdateAssetsDetail]
GO
/****** Object:  StoredProcedure [dbo].[Proc_AddUpdateAssetsDetail]    Script Date: 15-07-2019 17:15:30 ******/
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
						  AND IsActive = 1 AND @IsActive = 1
						  )
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
/****** Object:  StoredProcedure [dbo].[Proc_AddUpdateUsersAsset]    Script Date: 15-07-2019 17:15:30 ******/
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
   DECLARE @Result int 
   EXEC [dbo].[Proc_AddUpdateUsersAsset]
     @UserId = 2432,
	 @AssetRequestId = 0,
     @AssetId = 0,
	 @FromDate  = '2019-06-01',
	 @TillDate  = null,
	 @Remarks = '',
	 @IsActive = 1,
	 @loginUserId = 1 ,
	 @Success = @Result output
	 SELECT @Result AS [RESULT]
*/
ALTER PROC [dbo].[Proc_AddUpdateUsersAsset]
(
 @UserId INT,
 @AssetRequestId BIGINT,
 @AssetId BIGINT,
 @FromDate VARCHAR(15),
 @TillDate VARCHAR(15) = null,
 @Remarks VARCHAR(500),
 @IsActive BIT,
 @loginUserId INT,
 @Success tinyint out
)
AS
BEGIN TRY
     BEGIN TRANSACTION

	 DECLARE @FromDateId BIGINT, @TillDateId BIGINT
	 
	 SELECT @FromDateId = DateId FROM DateMaster WHERE [Date] = @FromDate

	 SELECT @TillDateId = DateId FROM DateMaster WHERE [Date] = @TillDate AND @TillDate IS NOT NULL

     IF EXISTS(SELECT 1 FROM UsersAssetDetail AM 
	                      WHERE AM.UserId = @UserId AND AM.AssetId = @AssetId
			              AND AM.AllocateFrom = @FromDateId 
						  AND AM.IsActive = 1 AND @IsActive = 1
						  )
     BEGIN 
	      SET @Success = 2 --duplicate
	 END
	 ELSE
	 BEGIN
			 IF(@AssetRequestId = 0)
			 BEGIN
					INSERT INTO UsersAssetDetail(UserId, AssetId, AllocateFrom, Remarks, CreatedBy)
					VALUES(@UserId, @AssetId, @FromDateId, @Remarks, @loginUserId)
			
					SET @Success = 1 --success
			 END
			 ELSE
			 BEGIN
					UPDATE AM SET AM.AssetId = @AssetId, AM.AllocateFrom = @FromDateId, AM.AllocateTill = @TillDateId,    
								  AM.Remarks = @Remarks, AM.ModifiedDate = GETDATE(), AM.ModifiedBy = @loginUserId
					FROM UsersAssetDetail AM WHERE AM.AssetsRequestId = @AssetRequestId AND @IsActive = 1

					UPDATE AM SET AM.IsActive = 0, AM.AllocateTill = @TillDateId, AM.ModifiedDate = GETDATE(), AM.ModifiedBy = @loginUserId
					FROM UsersAssetDetail AM WHERE AM.AssetsRequestId = @AssetRequestId AND @IsActive = 0

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
		,@Source = 'Proc_AddUpdateUsersAsset'
		,@ErrorMessage = @ErrorMessage
		,@ErrorType = 'SP'
		,@ReportedByUserId = @LoginUserId
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetAllAssetsDetail]    Script Date: 15-07-2019 17:15:30 ******/
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
   SELECT AM.AssetId, T.[TypeId], T.[Type], AB.[BrandId], AB.[BrandName], 
          AM.[Model], AM.[Description], AM.[SerialNo], AM.IsActive, 
		  CONVERT(VARCHAR(11),AM.CreatedDate,106)+' '+ FORMAT(AM.CreatedDate, 'hh:mm tt') AS CreatedDate, C.EmployeeName AS CreatedBy, 
		 CASE WHEN AM.ModifiedDate IS NULL THEN '' 
		      ELSE CONVERT(VARCHAR(11), AM.ModifiedDate,106)+' '+ FORMAT(AM.ModifiedDate, 'hh:mm tt') 
	     END AS ModifiedDate, M.EmployeeName AS ModifiedBy,
		 CASE WHEN US.AssetsRequestId IS NULL THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END AS IsFree,
		 CASE WHEN US.AssetsRequestId IS NOT NULL THEN V.EmployeeName ELSE '' END AS AssignedTo,
		 CASE WHEN US.AssetsRequestId IS NOT NULL THEN CONVERT(VARCHAR(15), US.CreatedDate, 106)+' '+FORMAT(US.CreatedDate, 'hh:mm tt') 
		  ELSE '' END AS AssignedOn
   FROM [dbo].[AssetsMaster] AM WITH (NOLOCK)
   INNER JOIN [dbo].[AssetType] T WITH (NOLOCK)
         ON AM.AssetTypeId = T.TypeId
   INNER JOIN [dbo].[AssetsBrand] AB
         ON AM.BrandId = AB.BrandId
   INNER JOIN [dbo].[vwAllUsers] C 
         ON AM.CreatedBy = C.UserId
   LEFT JOIN [dbo].UsersAssetDetail US 
         ON AM.AssetId = US.AssetId AND US.IsActive = 1
   LEFT JOIN [dbo].[vwAllUsers] V ON US.UserId = V.UserId

   LEFT JOIN [dbo].[vwAllUsers] M 
        ON AM.ModifiedBy = M.UserId
  ORDER BY AM.CreatedDate DESC, AM.ModifiedDate DESC
END




GO
/****** Object:  StoredProcedure [dbo].[Proc_GetAllUsersAssets]    Script Date: 15-07-2019 17:15:30 ******/
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
   Usage        :  EXEC [dbo].[Proc_GetAllUsersAssets]
***/

ALTER PROCEDURE [dbo].[Proc_GetAllUsersAssets] 
AS
BEGIN
	SET NOCOUNT ON;
   SELECT UA.AssetsRequestId, UD.EmployeeName, UD.EmployeeCode, UD.UserId, CONVERT(VARCHAR(11),DM.[Date],106) AS AllocateFrom, 
          CONVERT(VARCHAR(11),TM.[Date],106) AS AllocateTill, AM.AssetId, 
          T.[TypeId], T.[Type], AB.[BrandId], AB.[BrandName], UA.Remarks, 
          AM.[Model], AM.[Description], AM.[SerialNo], UA.IsActive, 
		  CONVERT(VARCHAR(11), UA.CreatedDate ,106)+' '+ FORMAT(UA.CreatedDate, 'hh:mm tt') AS CreatedDate,
		   C.EmployeeName AS CreatedBy, 
		  M.EmployeeName AS ModifiedBy, 
		  CASE WHEN UA.ModifiedDate IS NULL THEN '' 
		       ELSE CONVERT(VARCHAR(11), UA.ModifiedDate ,106)+' '+ FORMAT(UA.ModifiedDate, 'hh:mm tt') 
		  END AS ModifiedDate
   FROM UsersAssetDetail UA JOIN vwAllUsers UD ON UA.UserId = UD.UserId
   INNER JOIN [dbo].[AssetsMaster] AM  ON UA.AssetId = AM.AssetId
   INNER JOIN [dbo].[AssetType] T ON AM.AssetTypeId = T.TypeId
   INNER JOIN [dbo].[AssetsBrand] AB ON AM.BrandId = AB.BrandId
   INNER JOIN [dbo].[vwAllUsers] C ON UA.CreatedBy = C.UserId
   INNER JOIN [dbo].[DateMaster] DM ON UA.AllocateFrom = DM.[DateId]
   LEFT JOIN [dbo].[DateMaster] TM ON UA.AllocateFrom = TM.[DateId]
   LEFT JOIN [dbo].[vwAllUsers] M ON UA.CreatedBy = M.UserId
   ORDER BY UA.CreatedDate DESC, UA.ModifiedDate DESC
END




GO
