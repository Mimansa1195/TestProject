GO
/****** Object:  StoredProcedure [dbo].[Proc_GetGoalReport]    Script Date: 25-09-2018 17:18:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetGoalReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetGoalReport]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetGoalReport]    Script Date: 25-09-2018 17:18:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetGoalReport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetGoalReport] AS' 
END
GO
/***
   Created Date      :     2018-09-24
   Created By        :     Mimansa Agrawal
   Purpose           :     This stored procedure is to get goal status report
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   
   --------------------------------------------------------------------------

   Test Cases        :
   --------------------------------------------------------------------------
   
   --- Test Case 1
         EXEC [dbo].[Proc_GetGoalReport]
         @AppraisalCycleId=7,
		 @StatusId=100
   --- Test Case 2
         EXEC [dbo].[Proc_GetGoalReport]
         @AppraisalCycleId=7,
		 @StatusId=1
***/
ALTER PROCEDURE [dbo].[Proc_GetGoalReport]
   @AppraisalCycleId INT,
   @StatusId INT
AS
BEGIN
	IF(@AppraisalCycleId!=0 AND @StatusId!=100)
	BEGIN
		SELECT
		V.[EmployeeName],V.[ReportingManagerName],V.[Division],V.[Department],V.[Team],V.[Designation]
		FROM [dbo].[UserGoal] G WITH (NOLOCK)
		INNER JOIN [dbo].[vwActiveUsers] V WITH (NOLOCK) ON G.[UserId] = V.[UserId]
		WHERE G.GoalStatusId=@StatusId AND G.AppraisalCycleId=@AppraisalCycleId
		ORDER BY V.[EmployeeName]
	END
	ELSE IF(@AppraisalCycleId!=0 AND @StatusId=100)
	BEGIN
		SELECT
		V.[EmployeeName],V.[ReportingManagerName],V.[Division],V.[Department],V.[Team],V.[Designation]
		FROM [dbo].[vwActiveUsers] V WITH (NOLOCK)
		LEFT JOIN [dbo].[UserGoal] G WITH (NOLOCK) ON  V.[UserId]=G.[UserId] AND G.AppraisalCycleId=@AppraisalCycleId
		WHERE G.UserId IS NULL 
		ORDER BY V.[EmployeeName]
	END 
END
GO
---------------------inserting menu for goal report----------------
INSERT INTO Menu (ParentMenuId,MenuName,ControllerName,ActionName,[Sequence],IsLinkEnabled,IsVisible,CreatedById)
VALUES(26,'Goal Status','Reports','Goals',11,1,1,1)
