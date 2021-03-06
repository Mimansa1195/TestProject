
/****** Object:  StoredProcedure [dbo].[Proc_FetchUsersOnshoreManagerData]    Script Date: 14-03-2019 19:11:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_FetchUsersOnshoreManagerData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_FetchUsersOnshoreManagerData]
GO
/****** Object:  StoredProcedure [dbo].[Proc_AddOrUpdateUsersOnshoreMgr]    Script Date: 14-03-2019 19:11:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddOrUpdateUsersOnshoreMgr]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AddOrUpdateUsersOnshoreMgr]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_FetchUsersOnshoreMgr]    Script Date: 14-03-2019 19:11:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_FetchUsersOnshoreMgr]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_FetchUsersOnshoreMgr]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_FetchUsersOnshoreMgr]    Script Date: 14-03-2019 19:11:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_FetchUsersOnshoreMgr]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/***
Created Date      : 11-Mar-2019
Created By        : Kanchan Kumari
Purpose           : To fetch user''s Onshore manager details
--------------------------------------------------------------------------
Usage             : SELECT * FROM [dbo].Fun_FetchUsersOnshoreMgr (2432, 2)
--------------------------------------------------------------------------
***/

CREATE FUNCTION [dbo].[Fun_FetchUsersOnshoreMgr]
(
 @UserId INT,
 @ForClientId INT = 0
)
RETURNS @UserOnshoreMgr TABLE (OnshoreMgrName VARCHAR(200), EmailId VARCHAR(100)) 
AS
BEGIN
	 INSERT INTO @UserOnshoreMgr(OnshoreMgrName, EmailId)
	 SELECT ManagerName, EmailId 
	 FROM UsersOnshoreMgrMapping U 
	 JOIN OnshoreManager M ON U.OnshoreMgrId = M.OnshoreMgrId AND M.IsActive = 1
	 WHERE (M.ClientId = @ForClientId OR @ForClientId = 0)
	 AND U.UserId = @UserId AND U.IsActive = 1 AND U.NotifyOnshoreMgr = 1
RETURN 
END

' 
END

GO
/****** Object:  StoredProcedure [dbo].[Proc_AddOrUpdateUsersOnshoreMgr]    Script Date: 14-03-2019 19:11:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddOrUpdateUsersOnshoreMgr]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_AddOrUpdateUsersOnshoreMgr] AS' 
END
GO
/***
   Created Date      : 12-Mar-2019
   Created By        : Kanchan Kumari
   Purpose           : This stored procedure is to draft Reimbursement data
   --------------------------------------------------------------------------
  DECLARE @Res INT, @NewMappingId BIGINT
  EXEC Proc_AddOrUpdateUsersOnshoreMgr
  @UserId = 2432
 ,@MappingId = 0
 ,@ClientSideEmpId = 'KAN4756'
 ,@OnshoreMgrId  = 3
 ,@UserValidFromDate = '2019-04-01'
 ,@UserValidTillDate = '2019-06-30'
 ,@NotifyOnshoreMgr = 1
 ,@LoginUserId = 2166
 ,@Success = @Res OUTPUT
 ,@NewCreatedMappingId = @NewMappingId OUTPUT
 SELECT @Res AS RESULT, @NewMappingId AS NewMappingId

 errorLog order by 1 desc

***/
ALTER PROC [dbo].[Proc_AddOrUpdateUsersOnshoreMgr]
(
 @UserId INT
,@MappingId BIGINT
,@ClientSideEmpId VARCHAR(100)
,@OnshoreMgrId INT
,@UserValidFromDate VARCHAR(20)
,@UserValidTillDate VARCHAR(20)
,@NotifyOnshoreMgr BIT
,@LoginUserId INT
,@Success tinyint = 0 output
,@NewCreatedMappingId BIGINT = 0 output
)
AS
BEGIN TRY
    SET NOCOUNT ON;
     DECLARE @NewMappingId BIGINT;
     IF EXISTS(SELECT 1 FROM UsersOnshoreMgrMapping
	            WHERE UserId = @UserId AND OnshoreMgrId = @OnshoreMgrId AND
					   IsActive = 1 AND @MappingId = 0)
     BEGIN
	     SET @Success = 2 --duplicate
	 END
	 ELSE
	 BEGIN
	     BEGIN TRANSACTION
			IF(@MappingId = 0)--Add new Record
			BEGIN 
				INSERT INTO UsersOnshoreMgrMapping
				(
					UserId, ClientSideEmpId, OnshoreMgrId, UserValidFromDate, UserValidTillDate, NotifyOnshoreMgr, CreatedBy
				)
				VALUES
				(
				@UserId, @ClientSideEmpId, @OnshoreMgrId, @UserValidFromDate, @UserValidTillDate, @NotifyOnshoreMgr, @LoginUserId 
				)

				SET @Success = 1 --sucessfully mapped new data
				SET @NewMappingId = SCOPE_IDENTITY();
			END	
			ELSE
			BEGIN
				DECLARE @NewOnShoreMgrId INT 
				SELECT @NewOnShoreMgrId = OnshoreMgrId FROM UsersOnshoreMgrMapping WHERE MappingId = @MappingId
				IF(@OnshoreMgrId = @NewOnShoreMgrId) --update other data
				BEGIN
					UPDATE UsersOnshoreMgrMapping 
					SET ClientSideEmpId = @ClientSideEmpId, NotifyOnshoreMgr = @NotifyOnshoreMgr,
					UserValidFromDate = @UserValidFromDate, UserValidTillDate = @UserValidTillDate
					WHERE MappingId = @MappingId

					SET @Success = 1  --sucessfully updated existing data
				END
				ELSE
				BEGIN
					--deactivate previous mapping
					UPDATE UsersOnshoreMgrMapping 
					SET IsActive = 0
					WHERE MappingId = @MappingId

					--insert into mapping
					INSERT INTO UsersOnshoreMgrMapping
					(
						UserId, ClientSideEmpId, OnshoreMgrId, UserValidFromDate, UserValidTillDate, NotifyOnshoreMgr, CreatedBy
					)
					VALUES
					(
					@UserId, @ClientSideEmpId, @OnshoreMgrId, @UserValidFromDate, @UserValidTillDate, @NotifyOnshoreMgr, @LoginUserId 
					)

					SET @Success = 1 --sucessfully de-activated and inserted new data
					SET @NewMappingId = SCOPE_IDENTITY();
				END
			END	
		COMMIT;	 
		SET @NewCreatedMappingId = @NewMappingId
	 END	  
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
    ROLLBACK TRANSACTION;
   
    DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
    --Log Error
    EXEC [spInsertErrorLog]
    @ModuleName = 'PimcoUserManagement'
    ,@Source = 'Proc_AddOrUpdateUsersOnshoreMgr'
    ,@ErrorMessage = @ErrorMessage
    ,@ErrorType = 'SP'
    ,@ReportedByUserId = @LoginUserId

   SET @Success = 0 --Error Ocurred
   SET @NewCreatedMappingId = 0;  
END CATCH		   
				   
				 
				 
GO
/****** Object:  StoredProcedure [dbo].[Proc_FetchUsersOnshoreManagerData]    Script Date: 14-03-2019 19:11:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_FetchUsersOnshoreManagerData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_FetchUsersOnshoreManagerData] AS' 
END
GO
/***
   Created Date      : 13-Mar-2019
   Created By        : Kanchan Kumari
   Purpose           : To fetch users onshore amanger mapping
   Usage             : EXEC Proc_FetchUsersOnshoreManagerData @UserIds = '3,2180,2509,2511,2167,2203'
***/

ALTER PROC [dbo].[Proc_FetchUsersOnshoreManagerData]
(
@UserIds VARCHAR(5000)
)
AS
BEGIN
    SELECT U.MappingId, U.UserId, V.EmployeeName, U.ClientSideEmpId,
	       CASE WHEN U.UserValidFromDate  IS NOT NULL
		        THEN CONVERT(VARCHAR(13),U.UserValidFromDate, 106)
				ELSE 'NA'END AS ValidFrom,
		   CASE WHEN  U.UserValidTillDate  IS NOT NULL
		        THEN CONVERT(VARCHAR(13), U.UserValidTillDate, 106)
				ELSE 'NA'END AS ValidTill,
           U.UserValidFromDate, U.UserValidTillDate,
	       U.NotifyOnshoreMgr, M.ManagerName, M.OnshoreMgrId, 
	       M.EmailId AS ManagerEmailId, M.ClientId, 
		   CONVERT(VARCHAR(13),U.CreatedDate,106)+' '+ FORMAT(U.CreatedDate, 'hh:mm tt')  AS CreatedDate
	FROM UsersOnshoreMgrMapping U JOIN OnshoreManager M 
	     ON U.OnshoreMgrId = M.OnshoreMgrId
	JOIN vwActiveUsers V ON U.UserId = V.UserId
	WHERE U.UserId IN(SELECT SplitData FROM [dbo].Fun_SplitStringInt(@UserIds,',')) 
	      AND U.IsActive = 1
END
GO
