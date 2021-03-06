--------------------------------------alter table------------------------------------
DROP TABLE [UsersAssetDetail]

CREATE TABLE [dbo].[UsersAssetDetail](
	[AssetsRequestId] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[AssetId] [bigint] NOT NULL,
	[AllocatedFrom] [date] NOT NULL,
	[AllocatedTill] [date] NULL,
	[Remarks] [varchar](500) NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_UsersAssetDetail_AssetsRequestId] PRIMARY KEY CLUSTERED 
(
	[AssetsRequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[UsersAssetDetail] ADD  CONSTRAINT [DF_UsersAssetDetail_AllocatedFrom]  DEFAULT (getdate()) FOR [AllocatedFrom]
GO

ALTER TABLE [dbo].[UsersAssetDetail] ADD  CONSTRAINT [DF_UsersAssetDetail_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO

ALTER TABLE [dbo].[UsersAssetDetail] ADD  CONSTRAINT [DF_UsersAssetDetail_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO

----------------------------------------------altered sps-----------------------------------------------

/****** Object:  StoredProcedure [dbo].[spChangeUserStatus]    Script Date: 02-08-2019 15:10:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spChangeUserStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spChangeUserStatus]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetAllUsersAssets]    Script Date: 02-08-2019 15:10:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAllUsersAssets]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetAllUsersAssets]
GO
/****** Object:  StoredProcedure [dbo].[Proc_AddUpdateUsersAsset]    Script Date: 02-08-2019 15:10:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddUpdateUsersAsset]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AddUpdateUsersAsset]
GO
/****** Object:  StoredProcedure [dbo].[Proc_AddUpdateUsersAsset]    Script Date: 02-08-2019 15:10:26 ******/
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

	 --DECLARE @FromDateId BIGINT, @TillDateId BIGINT
	 
	 --SELECT @FromDateId = DateId FROM DateMaster WHERE [Date] = @FromDate

	 --SELECT @TillDateId = DateId FROM DateMaster WHERE [Date] = @TillDate AND @TillDate IS NOT NULL

     IF EXISTS(SELECT 1 FROM UsersAssetDetail AM 
	                      WHERE AM.UserId = @UserId AND AM.AssetId = @AssetId
			              AND AM.AllocatedFrom = @FromDate
						  AND AM.IsActive = 1 AND @IsActive = 1
						  )
     BEGIN 
	      SET @Success = 2 --duplicate
	 END
	 ELSE
	 BEGIN
			 IF(@AssetRequestId = 0)
			 BEGIN
					INSERT INTO UsersAssetDetail(UserId, AssetId, AllocatedFrom, Remarks, CreatedBy)
					VALUES(@UserId, @AssetId, @FromDate, @Remarks, @loginUserId)
			
					SET @Success = 1 --success
			 END
			 ELSE
			 BEGIN
					UPDATE AM SET AM.AssetId = @AssetId, AM.AllocatedFrom = @FromDate, AM.AllocatedTill = @TillDate,    
								  AM.Remarks = @Remarks, AM.ModifiedDate = GETDATE(), AM.ModifiedBy = @loginUserId
					FROM UsersAssetDetail AM WHERE AM.AssetsRequestId = @AssetRequestId AND @IsActive = 1

					UPDATE AM SET AM.IsActive = 0, AM.AllocatedTill = @TillDate, AM.ModifiedDate = GETDATE(), AM.ModifiedBy = @loginUserId
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
/****** Object:  StoredProcedure [dbo].[Proc_GetAllUsersAssets]    Script Date: 02-08-2019 15:10:26 ******/
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
   SELECT UA.AssetsRequestId, UD.EmployeeName, UD.EmployeeCode, UD.UserId, CONVERT(VARCHAR(11),UA.[AllocatedFrom],106) AS AllocateFrom, 
          CONVERT(VARCHAR(11),UA.[AllocatedTill],106) AS AllocateTill, AM.AssetId, 
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
   --INNER JOIN [dbo].[DateMaster] DM ON UA.AllocateFrom = DM.[DateId]
   --LEFT JOIN [dbo].[DateMaster] TM ON UA.AllocateFrom = TM.[DateId]
   LEFT JOIN [dbo].[vwAllUsers] M ON UA.ModifiedBy = M.UserId
   ORDER BY UA.CreatedDate DESC, UA.ModifiedDate DESC
END





GO
/****** Object:  StoredProcedure [dbo].[spChangeUserStatus]    Script Date: 02-08-2019 15:10:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spChangeUserStatus]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spChangeUserStatus] AS' 
END
GO
/***
   Created Date      :     2016-09-27
   Created By        :     Shubhra Upadhyay
   Purpose           :     This stored proc is used to get all access card with a particular status
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   6 may 2018        Kanchan kumari       when user is deactivated then unmap user access card as well
   --------------------------------------------------------------------------
   20 Dec 2018       Kanchan kumari       when user is deactivated then unmap user from project as well
    --------------------------------------------------------------------------
   16 July 2019       Kanchan kumari      when user is deactivated then de-allocate user's assets
   Test Cases        :
   --------------------------------------------------------------------------
   --- Test Case 1
         EXEC [dbo].[spChangeUserStatus]
          @employeeId = 84
	      ,@state = 1
         ,@userId = 42

   --- Test Case 2
         EXEC [dbo].[spChangeUserStatus]
			 @employeeId = 84
	      ,@state = 2
         ,@userId = 79
***/
ALTER PROCEDURE [dbo].[spChangeUserStatus] 
(
     @EmployeeId [int]
	,@State [int] 
	,@TerminationDate [DateTime]=null                --state: 1-activate, 2-deactivate
    ,@UserId [int]
)
AS
BEGIN
	
	SET NOCOUNT ON;
   
   BEGIN TRY
   BEGIN TRANSACTION
      IF(@state = 1)            --activate employee
      BEGIN
		UPDATE [dbo].[UserDetail]
		SET
			[TerminateDate] = NULL
			,[LastModifiedBy] = @UserId
			,[LastModifiedDate] = GETDATE()
		WHERE [UserId] = @EmployeeId

		UPDATE [dbo].[User] 
		SET [IsActive] = 1, 
			LastModifiedDate = GETDATE(), 
			LastModifiedBy=@UserId 
		WHERE [UserId] = @EmployeeId
      END
      ELSE IF(@state = 2)     --deactivate employee
      BEGIN         
		UPDATE [dbo].[UserDetail]
		SET [TerminateDate] = @TerminationDate
			,[LastModifiedBy] = @UserId
			,[LastModifiedDate] = GETDATE()
		WHERE [UserId] = @EmployeeId

		UPDATE [dbo].[User] 
		SET [IsActive] = 0, 
			LastModifiedDate = GETDATE(), 
			LastModifiedBy=@UserId 
		WHERE [UserId] = @EmployeeId

		--unmap user access card of deactivated employee
		UPDATE [dbo].[UserAccessCard]
		SET [IsActive]=0,
			[IsDeleted]=1,
			[LastModifiedDate]=GETDATE(),
			[LastModifiedBy]=@UserId,
			[AssignedTillDate]=@TerminationDate
		WHERE [UserId]=@EmployeeId AND IsActive=1 AND LastModifiedDate IS NULL

		--unmap user from all project assigned
		UPDATE [dbo].[ProjectTeamMembers] SET IsActive = 0, AllocatedTill = @TerminationDate, 
		       LastModifiedDate = GETDATE(),[LastModifiedBy]= @UserId
			   WHERE UserId = @EmployeeId AND IsActive = 1  
        
		DECLARE @TillDateId BIGINT;
		SELECT @TillDateId = DateId FROM DateMaster WHERE [Date] = @TerminationDate

			   --de-allocate users all assets
		UPDATE [dbo].[UsersAssetDetail] SET IsActive = 0, AllocatedTill = @TerminationDate, 
		       ModifiedDate = GETDATE(), [ModifiedBy]= @UserId
			   WHERE UserId = @EmployeeId AND IsActive = 1  
      END 
      SELECT CAST(1 AS [bit])  AS [Result]
   COMMIT TRANSACTION
   END TRY
   BEGIN CATCH
      ROLLBACK TRANSACTION
      
      DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))

      EXEC [spInsertErrorLog]
	         @ModuleName = 'UserManagement'
         ,@Source = 'spChangeUserStatus'
         ,@ErrorMessage = @ErrorMessage
         ,@ErrorType = 'SP'
         ,@ReportedByUserId = @UserId       

           SELECT CAST(0 AS [bit]) AS [Result]
   END CATCH
END
GO
