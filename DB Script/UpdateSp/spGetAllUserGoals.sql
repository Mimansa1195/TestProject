/***
   Created Date      :     2016-11-10
   Created By        :     Shubhra Upadhyay
   Purpose           :     This stored procedure is to get all active forms
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   
   --------------------------------------------------------------------------

   Test Cases        :
   --------------------------------------------------------------------------
   
   --- Test Case 1
         EXEC [dbo].[spGetAllUserGoals]
         @UserId = 1108
		 ,@AppraisalCycleId=0
   --- Test Case 2
         EXEC [dbo].[spGetAllUserGoals]
         @UserId = 1108
		,@AppraisalCycleId=1
***/

CREATE PROCEDURE [dbo].[spGetAllUserGoals] 
   @UserId int
  ,@AppraisalCycleId INT
AS
BEGIN
   IF(@AppraisalCycleId!=0)
   BEGIN
	SELECT
       G.[UserGoalId]                              AS [GoalId]
      ,ISNULL(AC.[AppraisalCycleName], 'NA')       AS [AppraisalCycleName]
      ,SD.[Date]                                   AS [StartDate]
      ,ED.[Date]                                   AS [EndDate]
      ,G.[Goal]
      ,G.[CreatedDate]
      ,GS.[Status]
      ,G.[LastModifiedDate]
      ,G.[IsActive]      
	  ,AC.AppraisalYear                           AS [AppraisalYear]
   FROM
      [dbo].[UserGoal] G WITH (NOLOCK)
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
      G.[UserId] = @UserId
	  AND G.AppraisalCycleId=@AppraisalCycleId
	  END
	 ELSE 
	 BEGIN
	 SELECT
       G.[UserGoalId]                              AS [GoalId]
      ,ISNULL(AC.[AppraisalCycleName], 'NA')       AS [AppraisalCycleName]
      ,SD.[Date]                                   AS [StartDate]
      ,ED.[Date]                                   AS [EndDate]
      ,G.[Goal]
      ,G.[CreatedDate]
      ,GS.[Status]
      ,G.[LastModifiedDate]
      ,G.[IsActive]      
	  ,AC.AppraisalYear                           AS [AppraisalYear]
   FROM
      [dbo].[UserGoal] G WITH (NOLOCK)
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
      G.[UserId] = @UserId
	  END
END

  
