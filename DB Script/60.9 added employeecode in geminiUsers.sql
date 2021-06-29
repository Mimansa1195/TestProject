USE [MIS]
GO

/****** Object:  StoredProcedure [dbo].[Proc_GetGeminiUsers]    Script Date: 10-02-2021 11:13:45 ******/
DROP PROCEDURE [dbo].[Proc_GetGeminiUsers]
GO

/****** Object:  StoredProcedure [dbo].[Proc_GetGeminiUsers]    Script Date: 10-02-2021 11:13:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*  
   Created Date      :     2018-07-10
   Created By        :     Kanchan Kumari
   Purpose           :     This stored procedure is used to get gemini user data
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   
   Test Case: 

   EXEC Proc_GetGeminiUsers

   --------------------------------------------------------------------------
   */
CREATE PROC [dbo].[Proc_GetGeminiUsers]
AS
BEGIN
	  SELECT
		 U.[UserId] 
		,U.[EmployeeName]
		,U.[EmployeeCode]
		,U.[EmailId]
		,ISNULL(U.[Designation],'') AS [Designation]
		,ISNULL(U.[Department], '') AS [Department]
		,U.[MobileNumber] AS [MobileNo]
		,UD.[ExtensionNumber] AS [ExtensionNo]
		,CD.[LocationName] AS [Location]
		,U.[ImagePath]
		,U.ReportingManagerName AS Manager
		,U.Team
		,U.JoiningDate
		,ISNULL(UD.WorkStationNo, 'NA') AS WSNo
		,U.Gender
	FROM 
	[dbo].[vwActiveUsers] U 
	JOIN [User] UR WITH (NOLOCK) ON U.UserId = UR.UserId
	JOIN [UserDetail] UD WITH (NOLOCK) ON UD.UserId = U.UserId
	INNER JOIN [dbo].[Location] CD WITH (NOLOCK) ON UR.[LocationId] = CD.[LocationId]
	INNER JOIN [dbo].[Country] C WITH (NOLOCK) ON CD.[CountryId] = C.[CountryId]
	INNER JOIN [dbo].[City] CY WITH (NOLOCK) ON CD.[CityId] = CY.[CityId]
	INNER JOIN [dbo].[State] S WITH (NOLOCK) ON CD.[StateId] = S.[StateId]         
	WHERE  U.[RoleId] <> 1 --escape Web Admin
	ORDER BY U.EmployeeName
END

GO


