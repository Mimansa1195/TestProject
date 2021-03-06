
/****** Object:  StoredProcedure [dbo].[spSubmitGoals]    Script Date: 30-07-2020 15:32:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spSubmitGoals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spSubmitGoals]
GO
/****** Object:  StoredProcedure [dbo].[spGetGoalHistoryById]    Script Date: 30-07-2020 15:32:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetGoalHistoryById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetGoalHistoryById]
GO
/****** Object:  StoredProcedure [dbo].[spGetAllUserGoals]    Script Date: 30-07-2020 15:32:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetAllUserGoals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetAllUserGoals]
GO
/****** Object:  StoredProcedure [dbo].[spDraftGoals]    Script Date: 30-07-2020 15:32:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spDraftGoals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spDraftGoals]
GO
/****** Object:  StoredProcedure [dbo].[spAddGoals]    Script Date: 30-07-2020 15:32:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spAddGoals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spAddGoals]
GO
/****** Object:  StoredProcedure [dbo].[Proc_SubmitTeamGoals]    Script Date: 30-07-2020 15:32:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SubmitTeamGoals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SubmitTeamGoals]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetTeamsToReviewGoals]    Script Date: 30-07-2020 15:32:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetTeamsToReviewGoals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetTeamsToReviewGoals]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetTeamsToAddGoals]    Script Date: 30-07-2020 15:32:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetTeamsToAddGoals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetTeamsToAddGoals]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetTeamGoalHistoryById]    Script Date: 30-07-2020 15:32:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetTeamGoalHistoryById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetTeamGoalHistoryById]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetAllTeamGoals]    Script Date: 30-07-2020 15:32:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAllTeamGoals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetAllTeamGoals]
GO
/****** Object:  StoredProcedure [dbo].[Proc_DraftTeamGoals]    Script Date: 30-07-2020 15:32:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DraftTeamGoals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DraftTeamGoals]
GO
/****** Object:  StoredProcedure [dbo].[Proc_AddTeamGoals]    Script Date: 30-07-2020 15:32:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddTeamGoals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AddTeamGoals]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_GetUserPrevilegesForTeamGoal]    Script Date: 30-07-2020 15:32:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetUserPrevilegesForTeamGoal]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GetUserPrevilegesForTeamGoal]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_GetUserPrevilegesForTeamGoal]    Script Date: 30-07-2020 15:32:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetUserPrevilegesForTeamGoal]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/***
   Created Date      :  29 July 2020
   Created By        :  Kanchan Kumari
   Purpose           :  This stored procedure is to fetch team
   Usage             :  SELECT * FROM [dbo].Fun_GetUserPrevilegesForTeamGoal(1108,10)
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
***/
CREATE FUNCTION [dbo].[Fun_GetUserPrevilegesForTeamGoal]
(
@UserId INT,
@TeamId INT
)
RETURNS @UserPrevileges TABLE(TeamId BIGINT NOT NULL, TeamName VARCHAR(100), HasViewRights BIT NOT NULL DEFAULT(0), HasAddRights BIT NOT NULL DEFAULT(0), HasEditRights BIT NOT NULL DEFAULT(0), HasReviewRights BIT NOT NULL DEFAULT(0))
AS
BEGIN
         DECLARE @UserTeamId BIGINT;
	     SELECT @UserTeamId = TeamId FROM vwActiveUsers WHERE UserId = @UserId

         INSERT INTO @UserPrevileges
	     SELECT T.TeamId, 
		        T.TeamName, 
				CASE WHEN @UserTeamId = @TeamId OR T.TeamHeadId = @UserId OR D.DepartmentHeadId = @UserId  THEN 1 ELSE 0 END, 
				CASE WHEN T.TeamHeadId = @UserId THEN 1 ELSE 0 END,
				CASE WHEN T.TeamHeadId = @UserId THEN 1 ELSE 0 END,
				CASE WHEN D.DepartmentHeadId = @UserId THEN 1 ELSE 0 END
		 FROM Team T JOIN Department D ON T.DepartmentId = D.DepartmentId 
		 WHERE T.TeamId = @TeamId 
	 RETURN
END

' 
END

GO
/****** Object:  StoredProcedure [dbo].[Proc_AddTeamGoals]    Script Date: 30-07-2020 15:32:39 ******/
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
              T.Item.value('@Goal', 'varchar(max)')
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
/****** Object:  StoredProcedure [dbo].[Proc_DraftTeamGoals]    Script Date: 30-07-2020 15:32:39 ******/
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
               T.Item.value('@Goal', 'varchar(max)')
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
		,@Source = 'spDraftGoals'
		,@ErrorMessage = @ErrorMessage
		,@ErrorType = 'SP'
		,@ReportedByUserId = @UserId

    SELECT CAST(0 AS [bit]) AS [Result]
END CATCH

GO
/****** Object:  StoredProcedure [dbo].[Proc_GetAllTeamGoals]    Script Date: 30-07-2020 15:32:39 ******/
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
	SELECT * FROM #TempTeamGoal WHERE (HasViewRights = 1 AND [Status] IN('Approved','Achieved')) OR HasAddRights = 1 OR HasApproverRights = 1
END
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetTeamGoalHistoryById]    Script Date: 30-07-2020 15:32:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetTeamGoalHistoryById]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetTeamGoalHistoryById] AS' 
END
GO
/***
   Created Date      :    28 July 2020
   Created By        :    Kanchan Kumari
   Purpose           :    This stored procedure gets goal history info on basis of goalId
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   --- Test Case 1
         EXEC [dbo].[Proc_GetTeamGoalHistoryById]
         @GoalId = 14
***/
ALTER PROCEDURE [dbo].[Proc_GetTeamGoalHistoryById]
@GoalId INT
AS
BEGIN	
	SET NOCOUNT ON;
   SELECT                         
       FORMAT(SD.[Date], 'dd-MMM-yyyy')            AS [StartDate]
      ,FORMAT(ED.[Date], 'dd-MMM-yyyy')            AS [EndDate]
      ,GH.[Goal]
	  ,GC.[Category]
      ,GS.[Status]
      ,GH.[Remarks]
      ,GH.[CreatedDate]
      ,UD.[FirstName] + ' ' + UD.[LastName]              AS [CreatedBy]            
   FROM
      [dbo].[TeamGoalHistory] GH WITH (NOLOCK)      
      INNER JOIN       
	   [dbo].[GoalCategory] GC WITH (NOLOCK)    
	   ON  GH.GoalCategoryId = GC.GoalCategoryId
	    INNER JOIN       
         [dbo].[DateMaster] SD WITH (NOLOCK)
            ON GH.[StartDateId] = SD.[DateId]
      INNER JOIN
         [dbo].[DateMaster] ED WITH (NOLOCK)
            ON GH.[EndDateId] = ED.[DateId]
      INNER JOIN
         [dbo].[GoalStatus] GS WITH (NOLOCK)
            ON GH.[GoalStatusId] = GS.[GoalStatusId]
      INNER JOIN
         [dbo].[UserDetail] UD WITH (NOLOCK)
            ON GH.[CreatedBy] = UD.[UserId]
   WHERE GH.[TeamGoalId] = @GoalId
   ORDER BY GH.[CreatedDate]
END
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetTeamsToAddGoals]    Script Date: 30-07-2020 15:32:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetTeamsToAddGoals]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetTeamsToAddGoals] AS' 
END
GO
/***
   Created Date      : 29 July 2020
   Created By        : Kanchan Kumari
   Purpose           : This stored procedure is to fetch team
   Usage             : EXEC Proc_GetTeamsToAddGoals @UserId = 1108, @Type = 'V'
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
***/
ALTER PROC [dbo].[Proc_GetTeamsToAddGoals]
(
@UserId INT,
@Type VARCHAR(5)
)
AS
BEGIN 
    SET FMTONLY OFF;
	SET NOCOUNT ON;

	IF OBJECT_ID('tempdb..#TempTeam') IS NOT NULL
	DROP TABLE #TempTeam

	IF OBJECT_ID('tempdb..#TempTeamList') IS NOT NULL
	DROP TABLE #TempTeamList

	CREATE TABLE #TempTeam
	(
	  TeamId BIGINT NOT NULL,
	  TeamName VARCHAR(100)  COLLATE SQL_Latin1_General_CP1_CI_AS,
	  TeamHeadId INT,
	  DepartmentId INT
	)

	INSERT INTO #TempTeam
	SELECT TeamId, TeamName, TeamHeadId, DepartmentId  FROM Team  WHERE TeamHeadId = @UserId AND IsActive = 1
	UNION
	SELECT V.TeamId, T.TeamName, T.TeamHeadId, T.DepartmentId FROM vwActiveUsers V JOIN Team T ON V.TeamId = T.TeamId WHERE V.UserId = @UserId

	DECLARE @UserTeamId BIGINT;
	SELECT @UserTeamId = TeamId FROM vwActiveUsers WHERE UserId = @UserId

	CREATE TABLE #TempTeamList
	(
	  TeamId BIGINT NOT NULL,
	  TeamName VARCHAR(100) NOT NULL, 
	  TeamHeadId INT  NOT NULL,
	  TeamHead VARCHAR(100) NOT NULL,
	  [DisplayTeam] VARCHAR(100) NOT NULL,
	  IsSelected BIT NOT NULL DEFAULT(0),
	  HasAddRights BIT NOT NULL DEFAULT(0)
	)

	INSERT INTO #TempTeamList(TeamId, TeamName, TeamHeadId, TeamHead, [DisplayTeam], IsSelected, HasAddRights)
	SELECT T.TeamId, T.TeamName, T.TeamHeadId, V.EmployeeName AS TeamHead, 
	       T.TeamName+'(Dept: '+ D.DepartmentName +')' AS [DisplayTeam],
		    CASE WHEN T.TeamId = @UserTeamId THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END AS IsSelected,
			CASE WHEN T.TeamHeadId = @UserId THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END AS HasAddRights 
	FROM #TempTeam T 
	JOIN Department D ON T.DepartmentId = D.DepartmentId 
	JOIN vwActiveUsers V ON T.TeamHeadId = V.UserId 
	
	IF(@Type = 'A')
	SELECT * FROM #TempTeamList WHERE HasAddRights = 1
	ELSE
	SELECT * FROM #TempTeamList
END


GO
/****** Object:  StoredProcedure [dbo].[Proc_GetTeamsToReviewGoals]    Script Date: 30-07-2020 15:32:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetTeamsToReviewGoals]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetTeamsToReviewGoals] AS' 
END
GO
/***
   Created Date      : 29 July 2020
   Created By        : Kanchan Kumari
   Purpose           : This stored procedure is to fetch team
   Usage             : EXEC Proc_GetTeamsToReviewGoals @UserId = 58
   Change History    : 
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
***/
ALTER PROC [dbo].[Proc_GetTeamsToReviewGoals]
(
@UserId INT
)
AS
BEGIN
	SELECT T.TeamId, T.TeamName, T.TeamHeadId, V.EmployeeName AS TeamHead, 
	       T.TeamName+'(Team Head: '+ V.EmployeeName+')' AS DisplayTeam
	FROM Team T JOIN Department D ON T.DepartmentId = D.DepartmentId AND T.IsActive = 1
	JOIN vwActiveUsers V ON T.TeamHeadId = V.UserId 
	WHERE D.DepartmentHeadId = @UserId AND T.TeamHeadId != @UserId AND D.IsActive = 1
END
GO
/****** Object:  StoredProcedure [dbo].[Proc_SubmitTeamGoals]    Script Date: 30-07-2020 15:32:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SubmitTeamGoals]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_SubmitTeamGoals] AS' 
END
GO
/***
   Created Date      :   29 July 2020
   Created By        :   Kanchan Kumari
   Purpose           :   This stored procedure is to add team goals
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
          EXEC [dbo].[Proc_SubmitTeamGoals]
          @GoalIds = '1,2,3'
         ,@UserId = 84
***/

ALTER PROCEDURE [dbo].[Proc_SubmitTeamGoals]
(
    @GoalIds varchar(1000)
   ,@UserId INT
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY                        
      BEGIN TRANSACTION
      
         DECLARE @SubmitGoalStatus int = (SELECT [GoalStatusId] FROM [dbo].[GoalStatus] WHERE [Status] = 'Submitted')

         UPDATE [dbo].[TeamGoal]
         SET
             [GoalStatusId] = @SubmitGoalStatus
            ,[LastModifiedBy] = @UserId
            ,[LastModifiedDate] = GETDATE()
         WHERE 
            [TeamGoalId] IN (SELECT [SplitData] FROM [dbo].[Fun_SplitStringInt](@GoalIds, ','))
            AND [IsActive] = 1

         INSERT INTO [dbo].[TeamGoalHistory]         
         SELECT
             [TeamGoalId]
            ,[StartDateId]
            ,[EndDateId]
            ,[Goal]
            ,[GoalStatusId]
            ,'Submitted'
            ,GETDATE()
            ,@UserId
			,GoalCategoryId
         FROM [TeamGoal]
         WHERE [TeamGoalId] IN (SELECT [SplitData] FROM [dbo].[Fun_SplitStringInt](@GoalIds, ',')) AND [IsActive] = 1                                          
      
      COMMIT TRANSACTION      
      SELECT CAST(1 AS [bit])                                         AS [Result]
   END TRY
   BEGIN CATCH
      ROLLBACK TRANSACTION
      DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
	   --Log Error
	   EXEC [spInsertErrorLog]
			   @ModuleName = 'AppraisalManagement'
		   ,@Source = 'Proc_SubmitTeamGoals'
		   ,@ErrorMessage = @ErrorMessage
		   ,@ErrorType = 'SP'
		   ,@ReportedByUserId = @UserId

      SELECT CAST(0 AS [bit])                                         AS [Result]         
   END CATCH 
END
GO
/****** Object:  StoredProcedure [dbo].[spAddGoals]    Script Date: 30-07-2020 15:32:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spAddGoals]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spAddGoals] AS' 
END
GO
/***
   Created Date      :     2016-11-10
   Created By        :     Shubhra Upadhyay
   Purpose           :     This stored procedure is to add goals
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   
   --------------------------------------------------------------------------

   Test Cases        :
   --------------------------------------------------------------------------
   
   --- Test Case 1
         EXEC [dbo].[spAddGoals]
         @EmployeeId = 22
         ,@GoalXmlString = '<Root>
                <Row StartDate = "03/10/2017" EndDate = "03/10/2017" GoalCategoryId = 1 Goal = "Goal1"></row>
                <Row StartDate = "02/10/2017" EndDate = "02/12/2017" GoalCategoryId = 1 Goal = "Goal2"></row>
                <Row StartDate = "03/10/2017" EndDate = "03/09/2017" GoalCategoryId = 1 Goal = "Goal3"></row>
               </Root>'
         ,@UserId = 84
***/
ALTER PROCEDURE [dbo].[spAddGoals]
(
    @EmployeeId INT
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
              T.Item.value('@Goal', 'varchar(max)')
       FROM @GoalXmlString.nodes('/Root/Row') AS T(Item)
         
         DECLARE @ApprovedGoalStatus int = (SELECT [GoalStatusId] FROM [dbo].[GoalStatus] WHERE [Status] = 'Approved')
                ,@NoOfRecords int = (SELECT COUNT(*) FROM #TempGoal)
                  
         INSERT INTO [dbo].[UserGoal]
         (
             [UserId]
            ,[AppraisalCycleId]
            ,[StartDateId]
            ,[EndDateId]
            ,[Goal]
			,[GoalCategoryId]
            ,[GoalStatusId]
            ,[CreatedBy]
         )
         SELECT
            @EmployeeId
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

         INSERT INTO [dbo].[UserGoalHistory]
         SELECT TOP (@NoOfRecords)
             [UserGoalId]
            ,[StartDateId]
            ,[EndDateId]
            ,[Goal]
			,[GoalStatusId]
            ,'Submitted and Approved'
            ,GETDATE()
            ,@UserId
			,[GoalCategoryId]
         FROM [dbo].[UserGoal]
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
     ,@Source = 'spAddGoals'
     ,@ErrorMessage = @ErrorMessage
     ,@ErrorType = 'SP'
     ,@ReportedByUserId = @UserId

      SELECT CAST(0 AS [bit])  AS [Result]
         
   END CATCH 
END
GO
/****** Object:  StoredProcedure [dbo].[spDraftGoals]    Script Date: 30-07-2020 15:32:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spDraftGoals]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spDraftGoals] AS' 
END
GO
/***
   Created Date      :     2016-11-10
   Created By        :     Shubhra Upadhyay
   Purpose           :     This stored procedure is to add goals
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   --- Test Case 1
         EXEC [dbo].[spDraftGoals]
         @EmployeeId = 22
         ,@GoalXmlString = '<Root>
							         <Row StartDate = "03/10/2017" EndDate = "03/10/2017" GoalCategoryId = 1 Goal = "Goal1"></row>
							         <Row StartDate = "02/10/2017" EndDate = "02/12/2017" GoalCategoryId = 1 Goal = "Goal2"></row>
							         <Row StartDate = "03/10/2017" EndDate = "03/09/2017" GoalCategoryId = 1 Goal = "Goal3"></row>
						         </Root>'
         ,@UserId = 84
***/
ALTER PROCEDURE [dbo].[spDraftGoals]
(
    @EmployeeId INT
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
               T.Item.value('@Goal', 'varchar(max)')
	      FROM @GoalXmlString.nodes('/Root/Row') AS T(Item)

         DECLARE @DraftGoalStatus int = (SELECT [GoalStatusId] FROM [dbo].[GoalStatus] WHERE [Status] = 'Drafted')

         INSERT INTO [dbo].[UserGoal]
         ( 
             [UserId]
            ,[AppraisalCycleId]
            ,[StartDateId]
            ,[EndDateId]
            ,[Goal]
			,[GoalCategoryId]
            ,[GoalStatusId]
            ,[CreatedBy]
         )
         SELECT
            @EmployeeId
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
		,@Source = 'spDraftGoals'
		,@ErrorMessage = @ErrorMessage
		,@ErrorType = 'SP'
		,@ReportedByUserId = @UserId

    SELECT CAST(0 AS [bit]) AS [Result]
END CATCH

GO
/****** Object:  StoredProcedure [dbo].[spGetAllUserGoals]    Script Date: 30-07-2020 15:32:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetAllUserGoals]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGetAllUserGoals] AS' 
END
GO
/***
   Created Date      :     2016-11-10
   Created By        :     Shubhra Upadhyay
   Purpose           :     This stored procedure is to get all active forms
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   10-JAN-2019       Kanchan  Kumari         get goals for multiple users
   --------------------------------------------------------------------------

   Test Cases        :
   --------------------------------------------------------------------------
   
   --- Test Case 1
         EXEC [dbo].[spGetAllUserGoals]
         @UserIds= '1108,098,097'
		 ,@AppraisalCycleId=0
***/
ALTER PROCEDURE [dbo].[spGetAllUserGoals] 
   @UserIds VARCHAR(MAX)
  ,@AppraisalCycleId INT
AS
BEGIN
   IF(@AppraisalCycleId!=0)
   BEGIN
	SELECT
       G.[UserGoalId]                              AS [GoalId]
      ,ISNULL(AC.[AppraisalCycleName], 'NA')       AS [AppraisalCycleName]
	  ,LTRIM(RTRIM(REPLACE(REPLACE(REPLACE((ISNULL(U.[FirstName],'') + ' ' + ISNULL(U.[MiddleName],'') + ' ' + ISNULL(U.[LastName],'')), ' ', '{}'), '}{',''), '{}', ' '))) AS [Employee]
      ,SD.[Date]                                   AS [StartDate]
      ,ED.[Date]                                   AS [EndDate]
      ,G.[Goal]
	  ,GC.[Category]
      ,G.[CreatedDate]
      ,GS.[Status]
      ,G.[LastModifiedDate]
      ,G.[IsActive]      
	  ,AC.AppraisalYear                           AS [AppraisalYear]
   FROM
      [dbo].[UserGoal] G WITH (NOLOCK)
	  INNER JOIN       
	   [dbo].[GoalCategory] GC WITH (NOLOCK)    
	   ON  G.GoalCategoryId = GC.GoalCategoryId
      INNER JOIN
         [dbo].[UserDetail] U WITH (NOLOCK)
            ON G.[UserId] = U.[UserId]
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
   WHERE      
      G.[UserId] IN(SELECT splitData FROM Fun_SplitStringInt(@UserIds,','))
	  AND G.AppraisalCycleId=@AppraisalCycleId
	  END
	 ELSE 
	 BEGIN
	 SELECT
       G.[UserGoalId]                              AS [GoalId]
      ,ISNULL(AC.[AppraisalCycleName], 'NA')       AS [AppraisalCycleName]
	  ,LTRIM(RTRIM(REPLACE(REPLACE(REPLACE((ISNULL(U.[FirstName],'') + ' ' + ISNULL(U.[MiddleName],'') + ' ' + ISNULL(U.[LastName],'')), ' ', '{}'), '}{',''), '{}', ' '))) AS [Employee]
      ,SD.[Date]                                   AS [StartDate]
      ,ED.[Date]                                   AS [EndDate]
      ,G.[Goal]
	  ,GC.[Category]
      ,G.[CreatedDate]
      ,GS.[Status]
      ,G.[LastModifiedDate]
      ,G.[IsActive]      
	  ,AC.AppraisalYear                           AS [AppraisalYear]
   FROM
      [dbo].[UserGoal] G WITH (NOLOCK)
	  INNER JOIN[dbo].[GoalCategory] GC WITH (NOLOCK) ON  G.GoalCategoryId = GC.GoalCategoryId         
      INNER JOIN [dbo].[UserDetail] U WITH (NOLOCK) ON G.[UserId] = U.[UserId]
      INNER JOIN [dbo].[AppraisalCycle] AC WITH (NOLOCK) ON G.[AppraisalCycleId] = AC.[AppraisalCycleId]
      INNER JOIN [dbo].[DateMaster] SD WITH (NOLOCK) ON G.[StartDateId] = SD.[DateId]
      INNER JOIN [dbo].[DateMaster] ED WITH (NOLOCK) ON G.[EndDateId] = ED.[DateId]
      INNER JOIN [dbo].[GoalStatus] GS WITH (NOLOCK) ON G.[GoalStatusId] = GS.[GoalStatusId]
   WHERE G.[UserId] IN (SELECT splitData FROM Fun_SplitStringInt(@UserIds,','))
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spGetGoalHistoryById]    Script Date: 30-07-2020 15:32:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetGoalHistoryById]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGetGoalHistoryById] AS' 
END
GO
/***
   Created Date      :     2017-07-07
   Created By        :     Shubhra Upadhyay
   Purpose           :     This stored procedure gets goal history info on basis of goalId
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   
   --------------------------------------------------------------------------

   Test Cases        :
   --------------------------------------------------------------------------
      
   --- Test Case 1
         EXEC [dbo].[spGetGoalHistoryById]
         @GoalId = 14
***/
ALTER PROCEDURE [dbo].[spGetGoalHistoryById]
@GoalId INT
AS
BEGIN	
	SET NOCOUNT ON;
   SELECT                         
       FORMAT(SD.[Date], 'dd-MMM-yyyy')            AS [StartDate]
      ,FORMAT(ED.[Date], 'dd-MMM-yyyy')            AS [EndDate]
      ,GH.[Goal]
	  ,GC.[Category]
      ,GS.[Status]
      ,GH.[Remarks]
      ,GH.[CreatedDate]
      ,UD.[FirstName] + ' ' + UD.[LastName]              AS [CreatedBy]            
   FROM
      [dbo].[UserGoalHistory] GH WITH (NOLOCK)      
      INNER JOIN       
	   [dbo].[GoalCategory] GC WITH (NOLOCK)    
	   ON  GH.GoalCategoryId = GC.GoalCategoryId
	    INNER JOIN       
         [dbo].[DateMaster] SD WITH (NOLOCK)
            ON GH.[StartDateId] = SD.[DateId]
      INNER JOIN
         [dbo].[DateMaster] ED WITH (NOLOCK)
            ON GH.[EndDateId] = ED.[DateId]
      INNER JOIN
         [dbo].[GoalStatus] GS WITH (NOLOCK)
            ON GH.[GoalStatusId] = GS.[GoalStatusId]
      INNER JOIN
         [dbo].[UserDetail] UD WITH (NOLOCK)
            ON GH.[CreatedBy] = UD.[UserId]
   WHERE GH.[UserGoalId] = @GoalId
   ORDER BY GH.[CreatedDate]
END
GO
/****** Object:  StoredProcedure [dbo].[spSubmitGoals]    Script Date: 30-07-2020 15:32:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spSubmitGoals]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spSubmitGoals] AS' 
END
GO
/***
   Created Date      :     2016-11-10
   Created By        :     Shubhra Upadhyay
   Purpose           :     This stored procedure is to add goals
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   
   --------------------------------------------------------------------------

   Test Cases        :
   --------------------------------------------------------------------------
   
   --- Test Case 1
         EXEC [dbo].[spSubmitGoals]
          @GoalIds = '1,2,3'
         ,@UserId = 84
***/

ALTER PROCEDURE [dbo].[spSubmitGoals]
(
    @GoalIds varchar(1000)
   ,@UserId INT
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY                        
      BEGIN TRANSACTION
      
         DECLARE @SubmitGoalStatus int = (SELECT [GoalStatusId] FROM [dbo].[GoalStatus] WHERE [Status] = 'Submitted')

         UPDATE [dbo].[UserGoal]
         SET
             [GoalStatusId] = @SubmitGoalStatus
            ,[LastModifiedBy] = @UserId
            ,[LastModifiedDate] = GETDATE()
         WHERE 
            [UserGoalId] IN (SELECT [SplitData] FROM [dbo].[Fun_SplitStringInt](@GoalIds, ','))
            AND [IsActive] = 1

         INSERT INTO [dbo].[UserGoalHistory]         
         SELECT
             [UserGoalId]
            ,[StartDateId]
            ,[EndDateId]
            ,[Goal]
            ,[GoalStatusId]
            ,'Submitted'
            ,GETDATE()
            ,@UserId
			,GoalCategoryId
         FROM [UserGoal]
         WHERE [UserGoalId] IN (SELECT [SplitData] FROM [dbo].[Fun_SplitStringInt](@GoalIds, ',')) AND [IsActive] = 1                                          
      
      COMMIT TRANSACTION      
      SELECT CAST(1 AS [bit])                                         AS [Result]
   END TRY
   BEGIN CATCH
      ROLLBACK TRANSACTION
      DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
	   --Log Error
	   EXEC [spInsertErrorLog]
			   @ModuleName = 'AppraisalManagement'
		   ,@Source = 'spSubmitGoals'
		   ,@ErrorMessage = @ErrorMessage
		   ,@ErrorType = 'SP'
		   ,@ReportedByUserId = @UserId

      SELECT CAST(0 AS [bit])                                         AS [Result]         
   END CATCH 
END
GO
