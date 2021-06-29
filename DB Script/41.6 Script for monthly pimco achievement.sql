GO
/****** Object:  StoredProcedure [dbo].[Proc_CheckValidityForMonthlyAchievements]    Script Date: 28-05-2019 18:56:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_CheckValidityForMonthlyAchievements]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_CheckValidityForMonthlyAchievements]
GO
/****** Object:  StoredProcedure [dbo].[Proc_SubmitUserMonthlyAchievement]    Script Date: 28-05-2019 18:56:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SubmitUserMonthlyAchievement]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SubmitUserMonthlyAchievement]
GO

/****** Object:  StoredProcedure [dbo].[Proc_CheckValidityForMonthlyAchievements]    Script Date: 28-05-2019 18:56:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_CheckValidityForMonthlyAchievements]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_CheckValidityForMonthlyAchievements] AS' 
END
GO
/***
   Created Date      :    28-May-2019
   Created By        :    Kanchan Kumari
   Purpose           :    To check if user can add monthly pimco achievements
-----------------------------------------------------------------------------
DECLARE @Result int
EXEC Proc_CheckValidityForMonthlyAchievements
@UserId = 2166,
@Year = 2018,
@MNumber = 3,
@Success = @Result output
SELECT @Result AS [RESULT]
**/
ALTER PROCEDURE [dbo].[Proc_CheckValidityForMonthlyAchievements]
(
@UserId INT,
@Year INT,
@MNumber INT,
@Success TINYINT = 0 OUTPUT 
)
AS
BEGIN TRY
DECLARE @PimcoAchievementId INT = (SELECT COUNT(*) FROM [dbo].[PimcoMonthlyAchievement] WHERE UserId = @UserId AND FYStartYear = @Year AND [Month]= @MNumber)
print @PimcoAchievementId;
DECLARE @CurrtMonth INT, @CurrtYear INT, @CurrDate DATE = GETDATE(), @PrevMonth INT, @PrevYear INT;

SELECT @CurrtMonth = MONTH(@CurrDate), @CurrtYear =  YEAR(@CurrDate), 
       @PrevMonth = MONTH(DATEADD(m,-1,@CurrDate)), @PrevYear = YEAR(DATEADD(m,-1,@CurrDate))

IF (@PimcoAchievementId = 0)
BEGIN
	    IF((@MNumber = @CurrtMonth AND @Year = @CurrtYear) OR (@MNumber = @PrevMonth AND @Year = @PrevYear))
		BEGIN
			 SET @Success=3 --can apply
		END
        ELSE
        BEGIN
             SET @Success= 2------------cannot apply
        END
END
ELSE
BEGIN
SET @Success= 1------------cannot apply
END
END TRY
BEGIN CATCH
	--On Error
     SET @Success = 0; -- Error occurred
	 DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
	 --Log Error
	 EXEC [spInsertErrorLog]
			 @ModuleName = 'Pimco Achievements'
			,@Source = 'Proc_CheckValidityForMonthlyAchievements'
			,@ErrorMessage = @ErrorMessage
			,@ErrorType = 'SP'
			,@ReportedByUserId = @UserId
END CATCH

GO

/****** Object:  StoredProcedure [dbo].[Proc_SubmitUserMonthlyAchievement]    Script Date: 28-05-2019 18:56:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SubmitUserMonthlyAchievement]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_SubmitUserMonthlyAchievement] AS' 
END
GO


/***
   Created Date      :   28-May-2019
   Created By        :   Kanchan Kumari
   Purpose           :   To submit User monthly pimco Achievement 
   --------------------------------------------------------------------------
    DECLARE @Result tinyint
         EXEC [dbo].[Proc_SubmitUserMonthlyAchievement]
            @UserId = 2432
		   ,@Year = 2018
		   ,@MNumber = 1
		   ,@Comments = 'abcd'
           ,@AchievementXmlString ='<Root> <Row Achievement="test" ProjectId="1" />
		                                   <Row Achievement="test" ProjectId="2"></Row>
			                        </Root>'
		   ,@Success = @Result out
           SELECT @Result AS Result
***/
ALTER PROC [dbo].[Proc_SubmitUserMonthlyAchievement]
(
 @UserId INT,
 @Year INT,
 @MNumber INT,
 @Comments VARCHAR(500),
 @AchievementXmlString xml,
 @Success tinyint=0 output
)
AS
BEGIN TRY
  SET NOCOUNT ON;
  BEGIN TRANSACTION
    DECLARE @DetailId BIGINT;

	IF OBJECT_ID('tempdb..##TempMonthlyAchievement') IS NOT NULL
	DROP TABLE #TempMonthlyAchievement
	CREATE TABLE #TempMonthlyAchievement([Achievement] VARCHAR(500),[ProjectId] VARCHAR(500))

    INSERT INTO #TempMonthlyAchievement
	SELECT T.Item.value('@Achievement','VARCHAR(500)'),
			T.Item.value('@ProjectId', 'int')
	FROM @AchievementXmlString.nodes('/Root/Row')AS T(Item)

    IF EXISTS(SELECT 1 FROM [PimcoMonthlyAchievement] WHERE UserId = @UserId AND FYStartYear = @Year AND [Month] = @MNumber)
	BEGIN
	     SET @Success = 2; --already submitted
	END
	ELSE
	BEGIN
		INSERT INTO [dbo].[PimcoMonthlyAchievement](UserId, FYStartYear, [Month], EmpComments, CreatedBy)
		SELECT @UserId, @Year, @MNumber, @Comments, @UserId 
 
		SET @DetailId = SCOPE_IDENTITY()
 
		INSERT INTO [dbo].[PimcoMonthlyAchievementDetail](PimcoAchievementId, Achievement, PimcoProjectId, CreatedBy)
		SELECT @DetailId, [Achievement], [ProjectId], @UserId FROM #TempMonthlyAchievement
		SET @Success = 1; -- submitted successfully
	END
 COMMIT;
END TRY
BEGIN CATCH
	SET @Success = 0; -- Error Occured
    IF(@@TRANCOUNT>0)
    ROLLBACK TRANSACTION;

    DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
--Log Error
    EXEC [spInsertErrorLog]
    @ModuleName = 'PimcoAchievement'
    ,@Source = 'Proc_SubmitUserMonthlyAchievement'
    ,@ErrorMessage = @ErrorMessage
    ,@ErrorType = 'SP'
    ,@ReportedByUserId = @UserId
END CATCH 


GO
--------------Quarterly--------------------

/***
   Created Date      :     2019-02-05
   Created By        :     Mimansa Agrawal
   Purpose           :    To submit User quarterly pimco Achievement 
   Change History:
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   3-Apr-2019        Kanchan Kumari       Checked if achievement already exists for
                                          the given input parameter
   --------------------------------------------------------------------------
   -----------------------------------------------------------------------
    DECLARE @Result tinyint
         EXEC [dbo].[Proc_SubmitUserQuarterlyAchievement]
            @UserId = 2432
		   ,@Year = 2018
		   ,@QNumber = 1
		   ,@Comments = 'abcd'
           ,@AchievementXmlString ='<Root> <Row ProjectId =1 Achievement="test" Purpose="test" />
		                                   <Row ProjectId =1 Achievement="test" Purpose="test"></Row>
			                        </Root>'
		   ,@Success = @Result out
           SELECT @Result AS Result
***/
ALTER PROC [dbo].[Proc_SubmitUserQuarterlyAchievement]
(
 @UserId INT,
 @Year INT,
 @QNumber INT,
 @Comments VARCHAR(500),
 @AchievementXmlString xml,
 @Success tinyint=0 output
)
AS
BEGIN TRY
  SET NOCOUNT ON;
  BEGIN TRANSACTION
	DECLARE @QStartDate DATE, @QEndDate DATE, @DetailId INT
	SET @QStartDate = (SELECT QStartDate FROM [dbo].[Fun_GetQuartersForFY](@Year) WHERE QNumber=@QNumber)
	SET @QEndDate = (SELECT QEndDate FROM [dbo].[Fun_GetQuartersForFY](@Year) WHERE QNumber=@QNumber)
           IF OBJECT_ID('tempdb..##TempAchievement') IS NOT NULL
           DROP TABLE #TempAchievement

		   CREATE TABLE #TempAchievement([ProjectId] int, [Achievement] VARCHAR(500),[Purpose] VARCHAR(500))
           INSERT INTO #TempAchievement
		   SELECT T.Item.value('@ProjectId','int'),
		          T.Item.value('@Achievement','VARCHAR(500)'),
			      T.Item.value('@Purpose', 'varchar(500)')
		   FROM @AchievementXmlString.nodes('/Root/Row')AS T(Item)

    IF EXISTS(SELECT 1 FROM [PimcoAchievement] WHERE UserId = @UserId AND FYStartYear = @Year AND QuarterNo = @QNumber)
	BEGIN
	     SET @Success = 2; --already submitted
	END
	ELSE
	BEGIN
		INSERT INTO [dbo].[PimcoAchievement](UserId, FYStartYear, QuarterNo, QuarterStartDate, QuarterEndDate, EmpComments, CreatedBy)
		SELECT @UserId, @Year, @QNumber, @QStartDate, @QEndDate, @Comments, @UserId 
 
		SET @DetailId = SCOPE_IDENTITY()
 
		INSERT INTO [dbo].[PimcoAchievementDetail](PimcoAchievementId, [ProjectId], Achievement, Purpose,CreatedBy)
		SELECT @DetailId, [ProjectId], [Achievement], [Purpose], @UserId FROM #TempAchievement
		SET @Success = 1; -- submitted successfully
	END
 COMMIT;
END TRY
BEGIN CATCH
	SET @Success = 0; -- Error Occured
    IF(@@TRANCOUNT>0)
    ROLLBACK TRANSACTION;

    DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
--Log Error
    EXEC [spInsertErrorLog]
    @ModuleName = 'PimcoAchievement'
    ,@Source = 'Proc_SubmitUserQuarterlyAchievement'
    ,@ErrorMessage = @ErrorMessage
    ,@ErrorType = 'SP'
    ,@ReportedByUserId = @UserId
END CATCH 

GO
-------PIMCO API------------

---- =============================================
---- Author	  :	Kanchan Kumari
---- Create date: 24-May-2019
---- Description:	To fetch pimco org data 
---- Usage: EXEC [dbo].[Proc_FetchAllGeminiUsersForPimco] 
---- =============================================
ALTER PROC Proc_FetchAllGeminiUsersForPimco
AS
BEGIN
SET FMTONLY OFF;
SET NOCOUNT ON;

	IF OBJECT_ID('tempdb..#TempPimcoUserData') IS NOT NULL
	DROP TABLE #TempPimcoUserData

	CREATE TABLE #TempPimcoUserData
	(
	Id INT IDENTITY(1,1),
	UserId BIGINT,
	EmployeeName VARCHAR(200) NOT NULL,
	EmployeeCode VARCHAR(100),
	IsActive BIT NOT NULL,
	DOL VARCHAR(15) NULL,
	IsPimcoUser BIT NOT NULL,
	PimcoId VARCHAR(20),
	MonthsOfExperience VARCHAR(8) NOT NULL,
	Designation VARCHAR(100) NOT NULL,
	RMId VARCHAR(100) NOT NULL,
	Department VARCHAR(50) NOT NULL,
	Team VARCHAR(50) NOT NULL,
	JoiningDate VARCHAR(15) NOT NULL,
	GeminiEmailId VARCHAR(150) NOT NULL,
	DOB VARCHAR(100) NOT NULL,
	EXT VARCHAR(15) NOT NULL,
	WS VARCHAR(15) NOT NULL,
	MobileNumber VARCHAR(50) NOT NULL,
	Skills VARCHAR(2000)
	)
	INSERT INTO #TempPimcoUserData(
	 UserId, EmployeeName, EmployeeCode, PimcoId, IsActive, DOL, IsPimcoUser, MonthsOfExperience, Designation,
	 RMId, Department, Team, JoiningDate, GeminiEmailId, DOB, EXT, WS, MobileNumber) 

	SELECT UD.UserId, UD.EmployeeName, UD.EmployeeCode, ISNULL(P.PimcoId,'') AS PimcoId, UD.IsActive,
			CASE WHEN U.TerminateDate IS NOT NULL THEN CONVERT(VARCHAR(11), U.TerminateDate, 106) 
			ELSE '' END AS DOL,
		   CASE WHEN P.UserId IS NULL THEN CAST(0 AS BIT) ELSE CAST(1 AS BIT) END AS IsPimcoUser,
		   ISNULL(P.TotalExperience,'') AS MonthsOfExperience,
		   UD.Designation, RM.EmployeeCode AS RMId, ISNULL(UD.Department,''), ISNULL(UD.Team,''),  
		   CONVERT(VARCHAR(11), UD.JoiningDate,106) AS  JoiningDate,
		   U.EmailId AS GeminiEmailId, 
		    U.DOB,
			ISNULL(U.ExtensionNumber,'') AS EXT, 
		   ISNULL(U.WorkStationNo,'') AS WS, ISNULL(U.MobileNumber,'') 
	FROM vwAllUsers UD JOIN UserDetail U ON UD.UserId = U.UserId 
	JOIN vwAllUsers RM ON UD.RMId = RM.UserId
	LEFT JOIN PimcoOrgUser P ON P.Name = UD.EmployeeName

	DECLARE @i INT= 1;

	WHILE(@i <= (SELECT COUNT(*) FROM #TempPimcoUserData))
	BEGIN
		DECLARE @UserId INT ;
		SELECT @UserId = UserId FROM #TempPimcoUserData WHERE Id = @i
		UPDATE #TempPimcoUserData SET Skills = ISNULL( 
					 STUFF(
					 (
					  SELECT ','+ ISNULL(S.SkillName,'')
					  FROM UserSkill US 
					  LEFT JOIN Skill S ON US.SkillId = S.SkillId  AND S.IsActive = 1
					  WHERE US.UserId = @UserId AND US.IsActive = 1 AND S.SkillName != '' AND S.SkillName != 'N/A'
					  FOR XML PATH('')), 
					 1,1,'') 
					 ,'')
					 WHERE UserId = @UserId
	   SET @i = @i+1;
	END

	SELECT EmployeeName, EmployeeCode, IsActive, DOL, IsPimcoUser, PimcoId, MonthsOfExperience, Designation,
		   RMId, Department, Team, JoiningDate, GeminiEmailId, DOB, EXT, WS, MobileNumber, Skills
	FROM #TempPimcoUserData
	GROUP BY EmployeeName, EmployeeCode, IsActive, DOL, IsPimcoUser, PimcoId, MonthsOfExperience, Designation,
			RMId, Department, Team, JoiningDate, GeminiEmailId, DOB, EXT, WS, MobileNumber, Skills
 END 