/****** Object:  StoredProcedure [dbo].[Proc_EditTeamGoal]    Script Date: 31-07-2020 10:59:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_EditTeamGoal]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_EditTeamGoal]
GO

/****** Object:  StoredProcedure [dbo].[Proc_GetAllTeamGoals]    Script Date: 31-07-2020 10:59:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAllTeamGoals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetAllTeamGoals]
GO

/****** Object:  StoredProcedure [dbo].[Proc_DraftTeamGoals]    Script Date: 31-07-2020 10:59:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DraftTeamGoals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DraftTeamGoals]
GO
/****** Object:  StoredProcedure [dbo].[Proc_ApproveTeamGoal]    Script Date: 31-07-2020 10:59:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_ApproveTeamGoal]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_ApproveTeamGoal]
GO
/****** Object:  StoredProcedure [dbo].[Proc_AddTeamGoals]    Script Date: 31-07-2020 10:59:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddTeamGoals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AddTeamGoals]
GO

/****** Object:  StoredProcedure [dbo].[Proc_GetAllTeamGoals]    Script Date: 31-07-2020 10:59:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAllTeamGoals]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetAllTeamGoals] AS' 
END
GO
/***
   Created Date      : 28 July 2020
   Created By        : Kanchan Kumari
   Purpose           : This stored procedure is to get all active forms
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   --- Test Case 1
         EXEC [dbo].[Proc_GetAllTeamGoals]
          @TeamIds = '0'
		 ,@AppraisalCycleId=10
		 ,@UserId = 2165
***/
ALTER PROCEDURE [dbo].[Proc_GetAllTeamGoals] 
  @TeamIds VARCHAR(MAX)
  ,@AppraisalCycleId INT
  ,@UserId INT
AS
BEGIN
    SET FMTONLY OFF;
	SET NOCOUNT ON;

    DECLARE @UserTeamId BIGINT;
	SELECT @UserTeamId = TeamId FROM vwActiveUsers WHERE UserId = @UserId

	IF OBJECT_ID('tempdb..#TempTeamGoal') IS NOT NULL
	DROP TABLE #TempTeamGoal

	IF OBJECT_ID('tempdb..#TempTeams') IS NOT NULL
	DROP TABLE #TempTeams

	CREATE TABLE #TempTeamGoal
	(
	  [GoalId] BIGINT NOT NULL,
	  [AppraisalCycleName] VARCHAR(70),
	  [TeamName] VARCHAR(100),
	  [DepartmentName] VARCHAR(100),
	  [DepartmentHead] VARCHAR(100),
	  [StartDate] DATE NOT NULL,
	  [EndDate] DATE NOT NULL,
	  [Goal] VARCHAR(100) NOT NULL,
	  [Category] VARCHAR(100) NOT NULL,
	  [CreatedDate] DATETIME NOT NULL,
	  [Status] VARCHAR(100) NOT NULL,
	  [LastModifiedDate] DATETIME ,
	  [IsActive] BIT NOT NULL,
	  [AppraisalYear] INT NOT NULL,
	  HasViewRights BIT NOT NULL,
	  HasAddRights BIT NOT NULL,
	  HasApproverRights BIT NOT NULL
	)
	CREATE TABLE #TempTeams
	(
		TeamId BIGINT NOT NULL,
		TeamName VARCHAR(100) NOT NULL, 
		TeamHeadId INT NOT NULL,
		TeamHead VARCHAR(100) NOT NULL,
		[DisplayTeam] VARCHAR(100) NOT NULL,
		IsSelected BIT NOT NULL DEFAULT(0),
		HasAddRights BIT NOT NULL DEFAULT(0)
	)
   IF(@AppraisalCycleId!=0 AND @TeamIds != '0') 
   BEGIN
        INSERT INTO #TempTeamGoal([GoalId], [AppraisalCycleName], [TeamName], [DepartmentName],  [DepartmentHead], [StartDate], [EndDate], [Goal], [Category],
		       [CreatedDate], [Status], [LastModifiedDate], [IsActive], [AppraisalYear], HasViewRights, HasAddRights, HasApproverRights)
		SELECT G.[TeamGoalId]  AS [GoalId], ISNULL(AC.[AppraisalCycleName], 'NA') AS [AppraisalCycleName]
			  ,T.[TeamName], D.DepartmentName, DH.[EmployeeName], SD.[Date] AS [StartDate], ED.[Date] AS [EndDate], G.[Goal], GC.[Category]
			  ,G.[CreatedDate], GS.[Status], G.[LastModifiedDate], G.[IsActive], AC.AppraisalYear AS [AppraisalYear],
			    CASE WHEN (@UserTeamId = T.TeamId OR T.TeamHeadId = @UserId OR D.DepartmentHeadId = @UserId) THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END AS HasViewRights, 
				CASE WHEN T.TeamHeadId = @UserId THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT)END AS HasAddRights, 
				CASE WHEN D.DepartmentHeadId = @UserId THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END AS HasApproverRights
		FROM
		  [dbo].[TeamGoal] G WITH (NOLOCK)
		  INNER JOIN [dbo].[Team] T WITH (NOLOCK)
			   ON  G.TeamId = T.TeamId  
		  INNER JOIN [dbo].[Department] D WITH (NOLOCK)
			   ON  T.DepartmentId = D.DepartmentId  
		  INNER JOIN [dbo].[vwAllUsers] DH WITH (NOLOCK)
			   ON  D.DepartmentHeadId = DH.UserId  
		  INNER JOIN       
			   [dbo].[GoalCategory] GC WITH (NOLOCK)    
			   ON  G.GoalCategoryId = GC.GoalCategoryId
		  INNER JOIN
			 [dbo].[AppraisalCycle] AC WITH (NOLOCK)
				ON G.[AppraisalCycleId] = AC.[AppraisalCycleId]
		  INNER JOIN
			 [dbo].[DateMaster] SD WITH (NOLOCK)
				ON G.[StartDateId] = SD.[DateId]
		  INNER JOIN
			 [dbo].[DateMaster] ED WITH (NOLOCK)
				ON G.[EndDateId] = ED.[DateId]
		  INNER JOIN
			 [dbo].[GoalStatus] GS WITH (NOLOCK)
				ON G.[GoalStatusId] = GS.[GoalStatusId]
		 WHERE T.[TeamId] IN(SELECT splitData FROM Fun_SplitStringInt(@TeamIds,','))     
			 AND G.AppraisalCycleId = @AppraisalCycleId
	  END
	 ELSE IF(@AppraisalCycleId=0 AND @TeamIds != '0')
	 BEGIN
	    INSERT INTO #TempTeamGoal([GoalId], [AppraisalCycleName], [TeamName], [DepartmentName], [DepartmentHead], [StartDate], [EndDate], [Goal], [Category],
		[CreatedDate], [Status], [LastModifiedDate], [IsActive], [AppraisalYear], HasViewRights, HasAddRights, HasApproverRights)
		 SELECT
		   G.[TeamGoalId] AS [GoalId], ISNULL(AC.[AppraisalCycleName], 'NA') AS [AppraisalCycleName]
		  ,T.TeamName, D.DepartmentName, DH.[EmployeeName], SD.[Date] AS [StartDate], ED.[Date] AS [EndDate], G.[Goal], GC.[Category], G.[CreatedDate], 
		   GS.[Status], G.[LastModifiedDate], G.[IsActive], AC.AppraisalYear AS [AppraisalYear],
		    CASE WHEN @UserTeamId = T.TeamId OR T.TeamHeadId = @UserId OR D.DepartmentHeadId = @UserId THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END AS HasViewRights, 
				CASE WHEN T.TeamHeadId = @UserId THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END AS HasAddRights, 
				CASE WHEN D.DepartmentHeadId = @UserId THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END AS HasApproverRights
	     FROM
		  [dbo].[TeamGoal] G WITH (NOLOCK)
		  INNER JOIN [dbo].[Team] T WITH (NOLOCK) ON  G.TeamId = T.TeamId  
		  INNER JOIN [dbo].[Department] D WITH (NOLOCK) ON  T.DepartmentId = D.DepartmentId  
		  INNER JOIN [dbo].[vwAllUsers] DH WITH (NOLOCK) ON  D.DepartmentHeadId = DH.UserId 
		  INNER JOIN [dbo].[GoalCategory] GC WITH (NOLOCK) ON  G.GoalCategoryId = GC.GoalCategoryId         
		  INNER JOIN [dbo].[AppraisalCycle] AC WITH (NOLOCK) ON G.[AppraisalCycleId] = AC.[AppraisalCycleId]
		  INNER JOIN [dbo].[DateMaster] SD WITH (NOLOCK) ON G.[StartDateId] = SD.[DateId]
		  INNER JOIN [dbo].[DateMaster] ED WITH (NOLOCK) ON G.[EndDateId] = ED.[DateId]
		  INNER JOIN [dbo].[GoalStatus] GS WITH (NOLOCK) ON G.[GoalStatusId] = GS.[GoalStatusId]
	    WHERE T.[TeamId] IN (SELECT splitData FROM Fun_SplitStringInt(@TeamIds,','))
	END
	ELSE IF(@AppraisalCycleId!=0 AND @TeamIds= '0')
	BEGIN
		
		INSERT INTO #TempTeams
		EXEC Proc_GetTeamsToAddGoals @UserId, 'V'

		INSERT INTO #TempTeamGoal([GoalId], [AppraisalCycleName], [TeamName], [DepartmentName], [DepartmentHead], [StartDate], [EndDate], [Goal], [Category],
		[CreatedDate], [Status], [LastModifiedDate], [IsActive], [AppraisalYear], HasViewRights, HasAddRights, HasApproverRights)
			SELECT
			G.[TeamGoalId] AS [GoalId], ISNULL(AC.[AppraisalCycleName], 'NA') AS [AppraisalCycleName]
			,T.TeamName, D.DepartmentName, DH.[EmployeeName], SD.[Date] AS [StartDate], ED.[Date] AS [EndDate], G.[Goal], GC.[Category], G.[CreatedDate], 
			GS.[Status], G.[LastModifiedDate], G.[IsActive], AC.AppraisalYear AS [AppraisalYear],
			CASE WHEN @UserTeamId = T.TeamId OR T.TeamHeadId = @UserId OR D.DepartmentHeadId = @UserId THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END AS HasViewRights, 
			CASE WHEN T.TeamHeadId = @UserId THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END AS HasAddRights,
			CASE WHEN D.DepartmentHeadId = @UserId THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END AS HasApproverRights
			FROM
			[dbo].[TeamGoal] G WITH (NOLOCK)
			INNER JOIN [dbo].[#TempTeams] TT WITH (NOLOCK) ON  G.TeamId = TT.TeamId  
			INNER JOIN [dbo].[Team] T WITH (NOLOCK) ON  TT.TeamId = T.TeamId  
			INNER JOIN [dbo].[Department] D WITH (NOLOCK) ON  T.DepartmentId = D.DepartmentId  
			INNER JOIN [dbo].[vwAllUsers] DH WITH (NOLOCK) ON  D.DepartmentHeadId = DH.UserId 
			INNER JOIN [dbo].[GoalCategory] GC WITH (NOLOCK) ON  G.GoalCategoryId = GC.GoalCategoryId         
			INNER JOIN [dbo].[AppraisalCycle] AC WITH (NOLOCK) ON G.[AppraisalCycleId] = AC.[AppraisalCycleId]
			INNER JOIN [dbo].[DateMaster] SD WITH (NOLOCK) ON G.[StartDateId] = SD.[DateId]
			INNER JOIN [dbo].[DateMaster] ED WITH (NOLOCK) ON G.[EndDateId] = ED.[DateId]
			INNER JOIN [dbo].[GoalStatus] GS WITH (NOLOCK) ON G.[GoalStatusId] = GS.[GoalStatusId]
			WHERE G.AppraisalCycleId = @AppraisalCycleId
	END
	ELSE
	BEGIN
	  
		INSERT INTO #TempTeams
		EXEC Proc_GetTeamsToAddGoals @UserId, 'V'

		INSERT INTO #TempTeamGoal([GoalId], [AppraisalCycleName], [TeamName], [DepartmentName], [DepartmentHead], [StartDate], [EndDate], [Goal], [Category],
		[CreatedDate], [Status], [LastModifiedDate], [IsActive], [AppraisalYear], HasViewRights, HasAddRights, HasApproverRights)
			SELECT
			G.[TeamGoalId] AS [GoalId], ISNULL(AC.[AppraisalCycleName], 'NA') AS [AppraisalCycleName]
			,T.TeamName, D.DepartmentName, DH.[EmployeeName], SD.[Date] AS [StartDate], ED.[Date] AS [EndDate], G.[Goal], GC.[Category], G.[CreatedDate], 
			GS.[Status], G.[LastModifiedDate], G.[IsActive], AC.AppraisalYear AS [AppraisalYear],
			CASE WHEN @UserTeamId = T.TeamId OR T.TeamHeadId = @UserId OR D.DepartmentHeadId = @UserId THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END AS HasViewRights, 
			CASE WHEN T.TeamHeadId = @UserId THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END AS HasAddRights,
			CASE WHEN D.DepartmentHeadId = @UserId THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END AS HasApproverRights
			FROM
			[dbo].[TeamGoal] G WITH (NOLOCK)
			INNER JOIN [dbo].[#TempTeams] TT WITH (NOLOCK) ON  G.TeamId = TT.TeamId  
			INNER JOIN [dbo].[Team] T WITH (NOLOCK) ON  TT.TeamId = T.TeamId  
			INNER JOIN [dbo].[Department] D WITH (NOLOCK) ON  T.DepartmentId = D.DepartmentId  
			INNER JOIN [dbo].[vwAllUsers] DH WITH (NOLOCK) ON  D.DepartmentHeadId = DH.UserId 
			INNER JOIN [dbo].[GoalCategory] GC WITH (NOLOCK) ON  G.GoalCategoryId = GC.GoalCategoryId         
			INNER JOIN [dbo].[AppraisalCycle] AC WITH (NOLOCK) ON G.[AppraisalCycleId] = AC.[AppraisalCycleId]
			INNER JOIN [dbo].[DateMaster] SD WITH (NOLOCK) ON G.[StartDateId] = SD.[DateId]
			INNER JOIN [dbo].[DateMaster] ED WITH (NOLOCK) ON G.[EndDateId] = ED.[DateId]
			INNER JOIN [dbo].[GoalStatus] GS WITH (NOLOCK) ON G.[GoalStatusId] = GS.[GoalStatusId]
	END
	SELECT * FROM #TempTeamGoal 
	WHERE (HasViewRights = 1 AND [Status] IN('Approved','Achieved')) OR HasAddRights = 1 OR HasApproverRights = 1
	ORDER BY [CreatedDate] DESC, [LastModifiedDate] DESC
END
GO

/****** Object:  StoredProcedure [dbo].[Proc_EditTeamGoal]    Script Date: 31-07-2020 10:59:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_EditTeamGoal]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_EditTeamGoal] AS' 
END
GO
/***
   Created Date      :   28 July 2020
   Created By        :   Kanchan Kumari
   Purpose           :   To edit team goal
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   
   --- Test Case 1
         DECLARE @Res int
         EXEC [dbo].[Proc_EditTeamGoal]
            @TeamGoalId = 1 ,
			@StartDate = '2020-01-02',
			@EndDate ='2020-01-02',
			@Goal ='ddd',
			@GoalCategoryId =1,
			@UserId =1,
		 @Success = @Res output
		 SELECT @Res AS RESULT
***/
ALTER PROCEDURE [dbo].[Proc_EditTeamGoal]
(
    @TeamGoalId BIGINT,
	@StartDate DATE,
	@EndDate DATE,
	@Goal VARCHAR(MAX),
	@GoalCategoryId INT,
    @UserId INT,
    @Success tinyint = 0 output
)
AS
BEGIN TRY
    SET NOCOUNT ON;
    BEGIN TRANSACTION

	DECLARE @SDateId BIGINT, @EDateId BIGINT, @CreatedById INT;

	SELECT @SDateId = MIN(DateId), @EDateId = MAX(DateId) FROM DateMaster WHERE [Date] BETWEEN @StartDate AND @EndDate
	SELECT @CreatedById = CreatedBy FROM TeamGoal WHERE TeamGoalId = @TeamGoalId

	IF EXISTS(SELECT 1 FROM TeamGoal WHERE TeamGoalId = @TeamGoalId)
	BEGIN
		UPDATE [TeamGoal] SET StartDateId = @SDateId, EndDateId= @EDateId, 
		Goal = [dbo].[Fun_StripCharacters](@Goal, default), 
		GoalCategoryId = @GoalCategoryId, 
		LastModifiedBy = @UserId, LastModifiedDate = GETDATE()
		WHERE [TeamGoalId] = @TeamGoalId

		IF(@CreatedById != @UserId)
		BEGIN
			INSERT INTO [dbo].[TeamGoalHistory]
			SELECT 
			 [TeamGoalId]
			,[StartDateId]
			,[EndDateId]
			,[Goal]
			,[GoalStatusId]
			,'Edited'
			,GETDATE()
			,@UserId
			,[GoalCategoryId]
			FROM [dbo].[TeamGoal]
			WHERE [TeamGoalId] = @TeamGoalId
		END
	END
	ELSE
	BEGIN
	     SET @Success = 2;
	END
    COMMIT TRANSACTION;

  SET @Success = 1;
END TRY
BEGIN CATCH
      IF @@TRANCOUNT > 0
      ROLLBACK TRANSACTION;

      DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
    --Log Error
    EXEC [spInsertErrorLog]
      @ModuleName = 'AppraisalManagement'
     ,@Source = 'Proc_EditTeamGoal'
     ,@ErrorMessage = @ErrorMessage
     ,@ErrorType = 'SP'
     ,@ReportedByUserId = @UserId
      
  SET @Success = 0;
END CATCH 
GO

/****** Object:  StoredProcedure [dbo].[Proc_AddTeamGoals]    Script Date: 31-07-2020 10:59:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddTeamGoals]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_AddTeamGoals] AS' 
END
GO
/***
   Created Date      :   28 July 2020
   Created By        :   Kanchan Kumari
   Purpose           :   This stored procedure is to add goals
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   
   --------------------------------------------------------------------------

   Test Cases        :
   --------------------------------------------------------------------------
   
   --- Test Case 1
         EXEC [dbo].[Proc_AddTeamGoals]
         @EmployeeId = 22
         ,@GoalXmlString = '<Root>
                <Row StartDate = "03/10/2017" EndDate = "03/10/2017" GoalCategoryId = 1 Goal = "Goal1"></row>
                <Row StartDate = "02/10/2017" EndDate = "02/12/2017" GoalCategoryId = 1 Goal = "Goal2"></row>
                <Row StartDate = "03/10/2017" EndDate = "03/09/2017" GoalCategoryId = 1 Goal = "Goal3"></row>
               </Root>'
         ,@UserId = 84
***/
ALTER PROCEDURE [dbo].[Proc_AddTeamGoals]
(
    @TeamId BIGINT
   ,@GoalXmlString XML
   ,@UserId INT
   ,@GoalCycleId INT
)
AS
BEGIN 
 SET NOCOUNT ON;
 BEGIN TRY
      IF OBJECT_ID('tempdb..#TempGoal') IS NOT NULL
       DROP TABLE #TempGoal
      
      CREATE TABLE #TempGoal (TempGoalId INT IDENTITY(1,1), StartDate datetime, EndDate DATETIME,  GoalCategoryId INT, Goal VARCHAR(max))
      
      BEGIN TRANSACTION
         INSERT INTO #TempGoal(StartDate, EndDate, GoalCategoryId, Goal)
       SELECT T.Item.value('@StartDate', 'varchar(25)'),
              T.Item.value('@EndDate', 'varchar(25)'),
		      T.Item.value('@GoalCategoryId', 'int'),
			  [dbo].[Fun_StripCharacters](T.Item.value('@Goal', 'varchar(max)'), default)
       FROM @GoalXmlString.nodes('/Root/Row') AS T(Item)
         
         DECLARE @ApprovedGoalStatus int = (SELECT [GoalStatusId] FROM [dbo].[GoalStatus] WHERE [Status] = 'Approved')
                ,@NoOfRecords int = (SELECT COUNT(*) FROM #TempGoal)
                  
         INSERT INTO [dbo].[TeamGoal]
         (
             [TeamId]
            ,[AppraisalCycleId]
            ,[StartDateId]
            ,[EndDateId]
            ,[Goal]
			,[GoalCategoryId]
            ,[GoalStatusId]
            ,[CreatedBy]
         )
         SELECT
            @TeamId
           ,@GoalCycleId
           ,SD.[DateId]
           ,ED.[DateId]
           ,T.[Goal]
		   ,T.[GoalCategoryId]
           ,@ApprovedGoalStatus
           ,@UserId
         FROM
            #TempGoal T
            INNER JOIN
               [dbo].[DateMaster] SD WITH (NOLOCK)
               ON T.[StartDate] = SD.[Date]
            INNER JOIN
               [dbo].[DateMaster] ED WITH (NOLOCK)
               ON T.[EndDate] = ED.[Date]

         INSERT INTO [dbo].[TeamGoalHistory]
         SELECT TOP (@NoOfRecords)
             [TeamGoalId]
            ,[StartDateId]
            ,[EndDateId]
            ,[Goal]
			,[GoalStatusId]
            ,'Submitted and Approved'
            ,GETDATE()
            ,@UserId
			,[GoalCategoryId]
         FROM [dbo].[TeamGoal]
         ORDER BY 1 DESC         
      COMMIT TRANSACTION
      SELECT CAST(1 AS [bit])  AS [Result]
   END TRY
   BEGIN CATCH
      ROLLBACK TRANSACTION
      DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
    --Log Error
    EXEC [spInsertErrorLog]
      @ModuleName = 'AppraisalManagement'
     ,@Source = 'Proc_AddTeamGoals'
     ,@ErrorMessage = @ErrorMessage
     ,@ErrorType = 'SP'
     ,@ReportedByUserId = @UserId

      SELECT CAST(0 AS [bit])  AS [Result]
         
   END CATCH 
END

GO

/****** Object:  StoredProcedure [dbo].[Proc_ApproveTeamGoal]    Script Date: 31-07-2020 10:59:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_ApproveTeamGoal]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_ApproveTeamGoal] AS' 
END
GO
/***
   Created Date      :   28 July 2020
   Created By        :   Kanchan Kumari
   Purpose           :   To approve team goal
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   
   --------------------------------------------------------------------------

   Test Cases        :
   --------------------------------------------------------------------------
   
   --- Test Case 1
         DECLARE @Res int
         EXEC [dbo].[Proc_ApproveTeamGoal]
          @TeamGoalIds = ''
         ,@UserId = 84,
		 @Success = @Res output
		 SELECT @Res AS RESULT
***/
ALTER PROCEDURE [dbo].[Proc_ApproveTeamGoal]
(
    @TeamGoalIds VARCHAR(MAX)
   ,@UserId INT
   ,@Success tinyint = 0 output
)
AS
BEGIN TRY
    SET NOCOUNT ON;
    BEGIN TRANSACTION

	UPDATE TeamGoal SET GoalStatusId = 3, LastModifiedBy = @UserId, LastModifiedDate = GETDATE()
	WHERE [TeamGoalId] IN (SELECT splitData FROM Fun_SplitStringInt(@TeamGoalIds,','))

    INSERT INTO [dbo].[TeamGoalHistory]
    SELECT 
        [TeamGoalId]
    ,[StartDateId]
    ,[EndDateId]
    ,[Goal]
	,[GoalStatusId]
    ,'Approved'
    ,GETDATE()
    ,@UserId
	,[GoalCategoryId]
    FROM [dbo].[TeamGoal]
	WHERE [TeamGoalId] IN (SELECT splitData FROM Fun_SplitStringInt(@TeamGoalIds,','))
    COMMIT TRANSACTION;

  SET @Success = 1;
END TRY
BEGIN CATCH
      IF @@TRANCOUNT > 0
      ROLLBACK TRANSACTION;

      DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
    --Log Error
    EXEC [spInsertErrorLog]
      @ModuleName = 'AppraisalManagement'
     ,@Source = 'Proc_ApproveTeamGoal'
     ,@ErrorMessage = @ErrorMessage
     ,@ErrorType = 'SP'
     ,@ReportedByUserId = @UserId
      
  SET @Success = 0;
END CATCH 


GO
/****** Object:  StoredProcedure [dbo].[Proc_DraftTeamGoals]    Script Date: 31-07-2020 10:59:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DraftTeamGoals]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_DraftTeamGoals] AS' 
END
GO
/***
   Created Date      :     29 July 2020
   Created By        :     Kanchan Kumari
   Purpose           :     This stored procedure is to add team goals
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   --- Test Case 1
         EXEC [dbo].[Proc_DraftTeamGoals]
          @TeamId = 22
         ,@GoalXmlString = '<Root>
							         <Row StartDate = "03/10/2017" EndDate = "03/10/2017" GoalCategoryId = 1 Goal = "Goal1"></row>
							         <Row StartDate = "02/10/2017" EndDate = "02/12/2017" GoalCategoryId = 1 Goal = "Goal2"></row>
							         <Row StartDate = "03/10/2017" EndDate = "03/09/2017" GoalCategoryId = 1 Goal = "Goal3"></row>
						         </Root>'
         ,@UserId = 84
***/
ALTER PROCEDURE [dbo].[Proc_DraftTeamGoals]
(
    @TeamId INT
   ,@GoalXmlString XML
   ,@UserId INT
   ,@GoalCycleId INT
) 
AS
BEGIN TRY
	SET NOCOUNT ON;

      IF OBJECT_ID('tempdb..#TempGoal') IS NOT NULL
	      DROP TABLE #TempGoal
      
      CREATE TABLE #TempGoal (TempGoalId INT IDENTITY(1,1), StartDate datetime, EndDate DATETIME, GoalCategoryId INT, Goal VARCHAR(max))
      
      BEGIN TRANSACTION
         INSERT INTO #TempGoal( StartDate, EndDate, GoalCategoryId, Goal)
	      SELECT T.Item.value('@StartDate', 'varchar(25)'),
		         T.Item.value('@EndDate', 'varchar(25)'),  
				 T.Item.value('@GoalCategoryId', 'int'),
                 [dbo].[Fun_StripCharacters](T.Item.value('@Goal', 'varchar(max)'), default)
	      FROM @GoalXmlString.nodes('/Root/Row') AS T(Item)

         DECLARE @DraftGoalStatus int = (SELECT [GoalStatusId] FROM [dbo].[GoalStatus] WHERE [Status] = 'Drafted')

         INSERT INTO [dbo].[TeamGoal]
         ( 
             [TeamId]
            ,[AppraisalCycleId]
            ,[StartDateId]
            ,[EndDateId]
            ,[Goal]
			,[GoalCategoryId]
            ,[GoalStatusId]
            ,[CreatedBy]
         )
         SELECT
            @TeamId
           ,@GoalCycleId
           ,SD.[DateId]
           ,ED.[DateId]
           ,T.[Goal]
		   ,T.[GoalCategoryId]
           ,@DraftGoalStatus
           ,@UserId
         FROM
            #TempGoal T
            INNER JOIN
               [dbo].[DateMaster] SD WITH (NOLOCK)
               ON T.[StartDate] = SD.[Date]
            INNER JOIN
               [dbo].[DateMaster] ED WITH (NOLOCK)
               ON T.[EndDate] = ED.[Date]
      COMMIT TRANSACTION      
      SELECT CAST(1 AS [bit]) AS [Result]
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
    ROLLBACK TRANSACTION

    DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
	--Log Error
	EXEC [spInsertErrorLog]
		 @ModuleName = 'AppraisalManagement'
		,@Source = 'Proc_DraftTeamGoals'
		,@ErrorMessage = @ErrorMessage
		,@ErrorType = 'SP'
		,@ReportedByUserId = @UserId

    SELECT CAST(0 AS [bit]) AS [Result]
END CATCH

GO
