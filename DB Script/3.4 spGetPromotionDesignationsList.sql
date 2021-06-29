/***
   Created Date      :     2016-03-27
   Created By        :     Shubhra Upadhyay
   Purpose           :     This stored procedure is to next designations for which employee is eligible for promotion
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   3-Apr-2018		 Sudhanshu Shekhar	  Corrected sp to fetch designations list
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   --- Test Case 1
         EXEC [dbo].[spGetPromotionDesignationsList] @EmpAppraisalSettingId = 157
***/
ALTER PROCEDURE [dbo].[spGetPromotionDesignationsList]
(
   @EmpAppraisalSettingId INT
)
AS
BEGIN	
SET NOCOUNT ON;
SET FMTONLY OFF;	

   CREATE TABLE #TempPromotionDesignation(
      [DesignationId] int
   )

   DECLARE @UserDesignationGroupId int
   SELECT @UserDesignationGroupId = D.[DesignationGroupId] 
									FROM [EmpAppraisalSetting] UD WITH (NOLOCK) 
									JOIN [Designation] D WITH (NOLOCK) ON UD.[DesignationId] = D.[DesignationId] 
									WHERE UD.[EmpAppraisalSettingId] = @EmpAppraisalSettingId

   INSERT INTO #TempPromotionDesignation
   SELECT PD.[DesignationId]
   FROM [dbo].[EmpAppraisalSetting] U WITH (NOLOCK)
   INNER JOIN [dbo].[Designation] UD WITH (NOLOCK) ON U.[DesignationId] = UD.[DesignationId]            
   INNER JOIN [dbo].[Designation] PD WITH (NOLOCK) ON PD.[Sequence] BETWEEN (UD.[Sequence] + 1) AND (UD.[Sequence] + 3) --fetch next 3 sequecnce designations
   AND PD.[DesignationGroupId] = UD.[DesignationGroupId]
   WHERE U.[EmpAppraisalSettingId] = @EmpAppraisalSettingId

   IF(@UserDesignationGroupId != (SELECT [DesignationGroupId] FROM [DesignationGroup] WITH (NOLOCK) WHERE [DesignationGroupName] = 'General'))
   BEGIN
      INSERT INTO #TempPromotionDesignation
      SELECT [DesignationId]
      FROM [dbo].[Designation]            
      WHERE 
         [DesignationGroupId] = (SELECT [DesignationGroupId] FROM [DesignationGroup] WITH (NOLOCK) WHERE [DesignationGroupName] = 'General')
         AND [SpecialDesignationGropupId] IS NULL OR [SpecialDesignationGropupId] = @UserDesignationGroupId
   END

   SELECT TOP 3 
   D.[DesignationId], D.[DesignationName]
   FROM #TempPromotionDesignation TD 
   INNER JOIN [dbo].[Designation] D WITH (NOLOCK) ON TD.[DesignationId] = D.[DesignationId]

   DROP TABLE #TempPromotionDesignation
END