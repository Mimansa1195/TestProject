--INSERT INTO Location(LocationName, CompanyId,CityId,StateId,CountryId,CreatedById,[Address])
--SELECT 'Saint Louis, Missouri', 1, 45501, 3947, 231, 1, 'Saint Louis, Missouri, US'

--GO

--IF OBJECT_ID('UserLocationHistory') IS NOT NULL
--DROP TABLE UserLocationHistory

--CREATE TABLE UserLocationHistory
--(
-- UserLocationHistoryId BIGINT NOT NULL IDENTITY(1,1),
-- UserId INT NOT NULL,
-- NewCompanyLocationId VARCHAR(100) NOT NULL,
-- NewEmployeeCode VARCHAR(20) NULL,
-- IsActive BIT NOT NULL,
-- CreatedDate DATETIME NOT NULL,
-- CreatedBy INT NOT NULL,
-- CONSTRAINT [PK_UserLocationHistory_UserLocationHistoryId] PRIMARY KEY CLUSTERED 
--(
--	[UserLocationHistoryId] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
--) ON [PRIMARY]

--GO
--ALTER TABLE UserLocationHistory ADD CONSTRAINT DF_UserLocationHistory_IsActive DEFAULT(1) FOR IsActive
--GO
--ALTER TABLE UserLocationHistory ADD CONSTRAINT DF_UserLocationHistory_CreatedDate DEFAULT(GETDATE()) FOR CreatedDate
--GO
--ALTER TABLE UserLocationHistory WITH CHECK ADD CONSTRAINT FK_UserLocationHistory_User_UserId
--FOREIGN KEY (UserId) REFERENCES [User](UserId)
--GO
--ALTER TABLE UserLocationHistory CHECK CONSTRAINT FK_UserLocationHistory_User_UserId
--GO


/****** Object:  StoredProcedure [dbo].[Proc_FetchOnshoreUsers]    Script Date: 16-01-2020 16:32:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_FetchOnshoreUsers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_FetchOnshoreUsers]
GO
/****** Object:  StoredProcedure [dbo].[Proc_FetchOffshoreUsers]    Script Date: 16-01-2020 16:32:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_FetchOffshoreUsers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_FetchOffshoreUsers]
GO
/****** Object:  StoredProcedure [dbo].[Proc_ChangeUserLocationAndMapUserOnshore]    Script Date: 16-01-2020 16:32:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_ChangeUserLocationAndMapUserOnshore]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_ChangeUserLocationAndMapUserOnshore]
GO
/****** Object:  StoredProcedure [dbo].[Proc_ChangeUserLocationAndMapUserOnshore]    Script Date: 16-01-2020 16:32:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_ChangeUserLocationAndMapUserOnshore]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_ChangeUserLocationAndMapUserOnshore] AS' 
END
GO
/*  
   Created Date : 15-Jan-2020
   Created By   : Kanchan Kumari
   Purpose      : To change user location
   -----------------------------
   Test Case    : 
   DECLARE @Result int 
   EXEC [dbo].[Proc_ChangeUserLocationAndMapUserOnshore]
      @UserId = 2432
     ,@NewCmpnyLocationId  = 3 
     ,@NewEmployeeCode= 'GSI G 098'
     ,@NewExtensionNumber = '098'
	 ,@WorkStationNo = 'G098'
     ,@LoginUserId = 2
	 ,@Action = 'EDIT'
     ,@Success  = @Result out
   SELECT @Result AS [RESULT]

*/
ALTER PROC [dbo].[Proc_ChangeUserLocationAndMapUserOnshore]
(
  @UserId INT,
  @NewCmpnyLocationId INT,
  @NewEmployeeCode VARCHAR(20),
  @NewExtensionNumber VARCHAR(10),
  @WorkStationNo VARCHAR(10),
  @LoginUserId INT,
  @Action VARCHAR(20),
  @Success tinyint = 0 output
)
AS
BEGIN TRY
    BEGIN TRANSACTION

	IF EXISTS(SELECT 1 FROM UserDetail 
	WHERE REPLACE(LTRIM(REPLACE(REPLACE(EmployeeId,' ',''), '0', ' ')), ' ', '0') = REPLACE(LTRIM(REPLACE(REPLACE(@NewEmployeeCode,' ',''), '0', ' ')), ' ', '0'))
	BEGIN
		SET @Success = 2; -- employeeid exists
	END
    ELSE
	BEGIN 
		UPDATE [UserDetail] SET ExtensionNumber = ISNULL(@NewExtensionNumber,ExtensionNumber)
		, WorkStationNo = ISNULL(@WorkStationNo, WorkStationNo), EmployeeId = ISNULL(@NewEmployeeCode,EmployeeId),
			IsEligibleForLeave = CASE WHEN @Action = 'EDIT' THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END,
			LastModifiedBy = @LoginUserId, LastModifiedDate = GETDATE()
		WHERE UserId = @UserId

		UPDATE [User] SET LocationId = @NewCmpnyLocationId, 
		LastModifiedBy = @LoginUserId, LastModifiedDate = GETDATE()
		WHERE UserId = @UserId 

		INSERT INTO UserLocationHistory(UserId, NewCompanyLocationId, NewEmployeeCode, CreatedBy)
		SELECT @UserId, @NewCmpnyLocationId, @NewEmployeeCode, @LoginUserId  

		SET @Success = 1
   END
	COMMIT;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
	ROLLBACK TRANSACTION;

		DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
	--Log Error
	EXEC [spInsertErrorLog]
			@ModuleName = 'Abroad User'
		,@Source = 'Proc_ChangeUserLocationAndMapUserOnshore'
		,@ErrorMessage = @ErrorMessage
		,@ErrorType = 'SP'
		,@ReportedByUserId = @UserId
   
		SET @Success = 0;
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[Proc_FetchOffshoreUsers]    Script Date: 16-01-2020 16:32:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_FetchOffshoreUsers]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_FetchOffshoreUsers] AS' 
END
GO
/***
   Created Date      : 10-Jan-2020
   Created By        : Kanchan Kumari
   Purpose           : To get offshore user details
   Usage             : EXEC Proc_FetchOffshoreUsers 
***/
ALTER PROC [dbo].[Proc_FetchOffshoreUsers]
AS 
BEGIN
     SELECT V.UserId, V.EmployeeName, V.EmployeeCode, V.ReportingManagerName, ISNULL(V.Department,'') AS Department, 
	        ISNULL(V.Team,'') AS Team, L.LocationName AS CompanyLocation, UD.ExtensionNumber, 
			ISNULL(UD.WorkStationNo,'') AS WorkStationNo, L.CountryId, C.CountryName
	 FROM vwActiveUsers V 
	 JOIN [User] U ON V.UserId = U.UserId 
	 JOIN [UserDetail] UD ON U.UserId = UD.UserId
	 JOIN Location L ON U.LocationId = L.LocationId 
	 JOIN Country C ON L.CountryId = C.CountryId
	 WHERE V.IsEligibleForLeave = 1
END
GO
/****** Object:  StoredProcedure [dbo].[Proc_FetchOnshoreUsers]    Script Date: 16-01-2020 16:32:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_FetchOnshoreUsers]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_FetchOnshoreUsers] AS' 
END
GO
/***
   Created Date      : 10-Jan-2020
   Created By        : Kanchan Kumari
   Purpose           : To get onshore user details
   Usage             : EXEC Proc_FetchOnshoreUsers 
***/
ALTER PROC [dbo].[Proc_FetchOnshoreUsers]
AS 
BEGIN
     SELECT  V.UserId, V.EmployeeName, V.EmployeeCode, V.ReportingManagerName, V.Department, V.Team, 
	         L.LocationName AS CompanyLocation, ISNULL(UH.NewEmployeeCode,'') AS NewEmployeeCode, 
			 UH.CreatedBy , CONVERT(VARCHAR(20),UH.CreatedDate,106) AS CreatedDate, C.CountryName
	 FROM vwActiveUsers V 
	 LEFT JOIN(SELECT UserId, MAX(UserLocationHistoryId) AS LocationHistoryId
	       FROM [UserLocationHistory] WHERE IsActive = 1 GROUP BY UserId
		 )N ON V.UserId = N.UserId
     JOIN [UserLocationHistory] UH ON N.LocationHistoryId = UH.UserLocationHistoryId
	 JOIN Location L ON UH.NewCompanyLocationId = L.LocationId
	  JOIN Country C ON L.CountryId = C.CountryId 
	 WHERE V.IsEligibleForLeave = 0
END
GO
