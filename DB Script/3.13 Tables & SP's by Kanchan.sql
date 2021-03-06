
/****** Object:  StoredProcedure [dbo].[spTakeActionOnAppliedLeave]    Script Date: 09-08-2018 18:45:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spTakeActionOnAppliedLeave]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spTakeActionOnAppliedLeave]
GO
/****** Object:  StoredProcedure [dbo].[spRequestWorkFromHome]    Script Date: 09-08-2018 18:45:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spRequestWorkFromHome]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spRequestWorkFromHome]
GO
/****** Object:  StoredProcedure [dbo].[spGetDateForWorkFromHome]    Script Date: 09-08-2018 18:45:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetDateForWorkFromHome]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetDateForWorkFromHome]
GO
/****** Object:  StoredProcedure [dbo].[spGetApproverRemarks]    Script Date: 09-08-2018 18:45:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetApproverRemarks]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetApproverRemarks]
GO
/****** Object:  StoredProcedure [dbo].[spFetchWeekMap]    Script Date: 09-08-2018 18:45:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spFetchWeekMap]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spFetchWeekMap]
GO
/****** Object:  StoredProcedure [dbo].[spFetchAllPendingLnsaRequestByManagerId]    Script Date: 09-08-2018 18:45:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spFetchAllPendingLnsaRequestByManagerId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spFetchAllPendingLnsaRequestByManagerId]
GO
/****** Object:  StoredProcedure [dbo].[spFetchAllLnsaRequestStatusByUserId]    Script Date: 09-08-2018 18:45:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spFetchAllLnsaRequestStatusByUserId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spFetchAllLnsaRequestStatusByUserId]
GO
/****** Object:  StoredProcedure [dbo].[spApplyLeave]    Script Date: 09-08-2018 18:45:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spApplyLeave]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spApplyLeave]
GO
/****** Object:  StoredProcedure [dbo].[Proc_TakeActionOnOutingRequest]    Script Date: 09-08-2018 18:45:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TakeActionOnOutingRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TakeActionOnOutingRequest]
GO
/****** Object:  StoredProcedure [dbo].[Proc_TakeActionOnMapLnsaShift]    Script Date: 09-08-2018 18:45:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TakeActionOnMapLnsaShift]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TakeActionOnMapLnsaShift]
GO
/****** Object:  StoredProcedure [dbo].[Proc_TakeActionOnLegitimateLeave]    Script Date: 09-08-2018 18:45:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TakeActionOnLegitimateLeave]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TakeActionOnLegitimateLeave]
GO
/****** Object:  StoredProcedure [dbo].[Proc_MapLnsaShift]    Script Date: 09-08-2018 18:45:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_MapLnsaShift]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_MapLnsaShift]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetShiftMappingDetails]    Script Date: 09-08-2018 18:45:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetShiftMappingDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetShiftMappingDetails]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetOutingReviewRequest]    Script Date: 09-08-2018 18:45:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetOutingReviewRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetOutingReviewRequest]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetLegitimateLeave]    Script Date: 09-08-2018 18:45:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetLegitimateLeave]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetLegitimateLeave]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetGeminiUsers]    Script Date: 09-08-2018 18:45:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetGeminiUsers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetGeminiUsers]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetApproverDetails]    Script Date: 09-08-2018 18:45:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetApproverDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetApproverDetails]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetAllLnsaShiftReviewRequest]    Script Date: 09-08-2018 18:45:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAllLnsaShiftReviewRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetAllLnsaShiftReviewRequest]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetAllLnsaShiftRequest]    Script Date: 09-08-2018 18:45:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAllLnsaShiftRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetAllLnsaShiftRequest]
GO
/****** Object:  StoredProcedure [dbo].[Proc_FetchPendingLnsaShiftRequest]    Script Date: 09-08-2018 18:45:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_FetchPendingLnsaShiftRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_FetchPendingLnsaShiftRequest]
GO
/****** Object:  StoredProcedure [dbo].[PROC_BookCab]    Script Date: 09-08-2018 18:45:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROC_BookCab]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PROC_BookCab]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__TempUserS__TempU__6FC1191B]') AND parent_object_id = OBJECT_ID(N'[dbo].[TempUserShiftHistory]'))
ALTER TABLE [dbo].[TempUserShiftHistory] DROP CONSTRAINT [FK__TempUserS__TempU__6FC1191B]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__TempUserS__Statu__70B53D54]') AND parent_object_id = OBJECT_ID(N'[dbo].[TempUserShiftHistory]'))
ALTER TABLE [dbo].[TempUserShiftHistory] DROP CONSTRAINT [FK__TempUserS__Statu__70B53D54]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__TempUserS__TempU__69141B8C]') AND parent_object_id = OBJECT_ID(N'[dbo].[TempUserShiftDetail]'))
ALTER TABLE [dbo].[TempUserShiftDetail] DROP CONSTRAINT [FK__TempUserS__TempU__69141B8C]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__TempUserS__Statu__6AFC63FE]') AND parent_object_id = OBJECT_ID(N'[dbo].[TempUserShiftDetail]'))
ALTER TABLE [dbo].[TempUserShiftDetail] DROP CONSTRAINT [FK__TempUserS__Statu__6AFC63FE]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__TempUserS__DateI__6A083FC5]') AND parent_object_id = OBJECT_ID(N'[dbo].[TempUserShiftDetail]'))
ALTER TABLE [dbo].[TempUserShiftDetail] DROP CONSTRAINT [FK__TempUserS__DateI__6A083FC5]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__TempUserS__UserI__62671DFD]') AND parent_object_id = OBJECT_ID(N'[dbo].[TempUserShift]'))
ALTER TABLE [dbo].[TempUserShift] DROP CONSTRAINT [FK__TempUserS__UserI__62671DFD]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__TempUserS__Statu__644F666F]') AND parent_object_id = OBJECT_ID(N'[dbo].[TempUserShift]'))
ALTER TABLE [dbo].[TempUserShift] DROP CONSTRAINT [FK__TempUserS__Statu__644F666F]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__TempUserS__Shift__635B4236]') AND parent_object_id = OBJECT_ID(N'[dbo].[TempUserShift]'))
ALTER TABLE [dbo].[TempUserShift] DROP CONSTRAINT [FK__TempUserS__Shift__635B4236]
GO
/****** Object:  Table [dbo].[TempUserShiftHistory]    Script Date: 09-08-2018 18:45:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TempUserShiftHistory]') AND type in (N'U'))
DROP TABLE [dbo].[TempUserShiftHistory]
GO
/****** Object:  Table [dbo].[TempUserShiftDetail]    Script Date: 09-08-2018 18:45:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TempUserShiftDetail]') AND type in (N'U'))
DROP TABLE [dbo].[TempUserShiftDetail]
GO
/****** Object:  Table [dbo].[TempUserShift]    Script Date: 09-08-2018 18:45:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TempUserShift]') AND type in (N'U'))
DROP TABLE [dbo].[TempUserShift]
GO
/****** Object:  UserDefinedFunction [dbo].[fnGetSecondReportingManagerByUserId]    Script Date: 09-08-2018 18:45:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnGetSecondReportingManagerByUserId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fnGetSecondReportingManagerByUserId]
GO
/****** Object:  UserDefinedFunction [dbo].[fnGetReportingManagerByUserId]    Script Date: 09-08-2018 18:45:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnGetReportingManagerByUserId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fnGetReportingManagerByUserId]
GO
/****** Object:  UserDefinedFunction [dbo].[fnGetHRDetail]    Script Date: 09-08-2018 18:45:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnGetHRDetail]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fnGetHRDetail]
GO
/****** Object:  UserDefinedFunction [dbo].[fnGetDepartmentHeadIdByUserId]    Script Date: 09-08-2018 18:45:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnGetDepartmentHeadIdByUserId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fnGetDepartmentHeadIdByUserId]
GO
/****** Object:  UserDefinedFunction [dbo].[fnGetDepartmentHeadIdByUserId]    Script Date: 09-08-2018 18:45:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnGetDepartmentHeadIdByUserId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
/***
   Created Date      :     27-01-2017
   Created By        :     Shubhra Upadhyay
   Purpose           :     To get departmentHeadId for particular userId
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   27-01-2017		Sudhanshu Shekhar	Removed DepartmentId reference from UserDetail and referenced with Team
   --------------------------------------------------------------------------

   Test Cases        :
   --------------------------------------------------------------------------   
   --- Test Case 1
   SELECT [dbo].[fnGetDepartmentHeadIdByUserId](84)
   --- Test Case 2
   SELECT [dbo].[fnGetDepartmentHeadIdByUserId](4)

***/

CREATE FUNCTION [dbo].[fnGetDepartmentHeadIdByUserId]
(   
     @UserId int
)
RETURNS int
AS
BEGIN 
   DECLARE @DepartmentHeadId bigint
   DECLARE @RMId int = (SELECT [dbo].[fnGetReportingManagerByUserId](@UserId))
   DECLARE @SRMId int = (SELECT [dbo].[fnGetSecondReportingManagerByUserId](@UserId))
   IF (@RMId > 0 AND @RMId NOT IN (3, 4, 2203, 2167) AND @SRMId > 0 AND @SRMId NOT IN (3, 4, 2203, 2167))
   BEGIN
      SET @DepartmentHeadId = ISNULL( 
                           (SELECT TOP 1 DV.[DivisionHeadId]--D.[DepartmentHeadId] 
                           FROM [dbo].[UserTeamMapping] UTM WITH (NOLOCK)
									INNER JOIN [dbo].[Team] T WITH (NOLOCK) ON UTM.[TeamId] = T.[TeamId]
									INNER JOIN [dbo].[Department] D WITH (NOLOCK) ON T.[DepartmentId] = D.[DepartmentId]
                           INNER JOIN [dbo].[Division] DV WITH (NOLOCK) ON D.[DivisionId] = DV.[DivisionId]
									WHERE UTM.[UserId] = @UserId 
                           AND D.[DepartmentHeadId] != @UserId)
                           ,0) 
		IF(@DepartmentHeadId=3)
		BEGIN
		SET @DepartmentHeadId=0
		END


   END
   ELSE
   BEGIN
      SET @DepartmentHeadId = 0
   END
   RETURN @DepartmentHeadId
END


' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[fnGetHRDetail]    Script Date: 09-08-2018 18:45:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnGetHRDetail]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/***
   Created Date      :    7-08-2018
   Created By        :     kanchan kumari
   Purpose           :     To get Login User detail
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By          Change Description
   --------------------------------------------------------------------------
 
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------   
   --- Test Case 1
   SELECT * FROM [dbo].[fnGetHRDetail](2153)
***/
CREATE FUNCTION [dbo].[fnGetHRDetail]
(   
   @LoginUserId INT
)
RETURNS @HRDetails TABLE 
(	UserId INT, 
	DesignationId INT, 
	DesignationName VARCHAR(200),
	DesignationGrpId INT,
	DesignationGrpName VARCHAR(200),
	RoleId INT,
	RoleName VARCHAR(200),
	IsHRVerifier BIT
 )
AS
BEGIN 
INSERT INTO @HRDetails
  SELECT  U.UserId, 
		  D.DesignationId,
		  D.DesignationName,
		  DG.DesignationGroupId,
		  DG.DesignationGroupName,
		  U.RoleId, 
		  R.RoleName, 
		  CASE WHEN U.UserId=2166 THEN 1
		  ELSE 0 END AS IsHRVerifier 
  FROM dbo.[User] U
  LEFT JOIN [Role] R ON U.RoleId = R.RoleId
  JOIN UserDetail UD ON U.UserId = UD.UserId
  LEFT JOIN Designation D ON UD.DesignationId = D.DesignationId 
  JOIN DesignationGroup DG ON D.DesignationGroupId = DG.DesignationGroupId
  WHERE D.IsActive=1 AND U.UserId = @LoginUserId

  RETURN 
END' 
END

GO

/****** Object:  UserDefinedFunction [dbo].[fnGetReportingManagerByUserId]    Script Date: 09-08-2018 18:45:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnGetReportingManagerByUserId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
/***
   Created Date      :     27-01-2017
   Created By        :     Shubhra Upadhyay
   Purpose           :     To get reporting manager for userId
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   
   --------------------------------------------------------------------------

   Test Cases        :
   --------------------------------------------------------------------------   
   --- Test Case 1
   SELECT [dbo].[fnGetReportingManagerByUserId](2309)

   --- Test Case 2
   SELECT [dbo].[fnGetReportingManagerByUserId](4)

   --- Test Case 3
   SELECT [dbo].[fnGetReportingManagerByUserId](22)

***/

CREATE FUNCTION [dbo].[fnGetReportingManagerByUserId]
(   
     @UserId int
)
RETURNS int
AS
BEGIN 
   DECLARE @RMId int

   IF EXISTS(
            SELECT 1
            FROM [dbo].[UserDetail] U WITH (NOLOCK)
               INNER JOIN [dbo].[UserDetail] UD WITH (NOLOCK)
                  ON U.[UserId] = UD.[ReportTo]
            WHERE
               UD.[UserId] = @UserId
               AND U.[UserId] > 0 
               AND UD.[UserId] > 0              
            )
   BEGIN
      SET @RMId = (SELECT CASE WHEN UD.ReportTo=3 THEN 0 ELSE U.[UserId] END AS [UserId]--- VM id should not be there as reporting manager id
                       FROM [dbo].[UserDetail] U WITH (NOLOCK)
                           INNER JOIN [dbo].[UserDetail] UD WITH (NOLOCK)
                              ON U.[UserId] = UD.[ReportTo]
                       WHERE
                           UD.[UserId] = @UserId
                           AND U.[UserId] > 0 
                           AND UD.[UserId] > 0
                       )
   END      
   ELSE
   BEGIN
      SET @RMId = 0
   END
   
   RETURN @RMId
END


' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[fnGetSecondReportingManagerByUserId]    Script Date: 09-08-2018 18:45:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnGetSecondReportingManagerByUserId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
/***
   Created Date      :     27-01-2017
   Created By        :     Shubhra Upadhyay
   Purpose           :     To get reporting manager of reporting manager for userId
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   
   --------------------------------------------------------------------------

   Test Cases        :
   --------------------------------------------------------------------------   
   --- Test Case 1
   SELECT [dbo].[fnGetSecondReportingManagerByUserId](84)

   --- Test Case 2
   SELECT [dbo].[fnGetSecondReportingManagerByUserId](4)

   --- Test Case 3
   SELECT [dbo].[fnGetSecondReportingManagerByUserId](22)

***/

CREATE FUNCTION [dbo].[fnGetSecondReportingManagerByUserId]
(   
     @UserId int
)
RETURNS int
AS
BEGIN 
   DECLARE @ResultId int

   IF EXISTS(
            SELECT 1
            FROM [dbo].[UserDetail] U WITH (NOLOCK)
               INNER JOIN [dbo].[UserDetail] UD WITH (NOLOCK)
                  ON U.[UserId] = UD.[ReportTo]
               INNER JOIN [dbo].[UserDetail] UD1 WITH (NOLOCK)
                  ON UD.[UserId] = UD1.[ReportTo]
            WHERE
               UD1.[UserId] = @UserId
               AND U.[UserId] > 0 
               AND UD.[UserId] > 0
               AND (SELECT [dbo].[fnGetReportingManagerByUserId](@UserId)) NOT IN (3, 4, 2203, 2167)
            )
   BEGIN
      SET @ResultId = (SELECT CASE WHEN U.UserId=3 THEN 0 ELSE U.[UserId] END AS UserId---VM should not be the 2nd rm
                       FROM [dbo].[UserDetail] U WITH (NOLOCK)
                           INNER JOIN [dbo].[UserDetail] UD WITH (NOLOCK)
                              ON U.[UserId] = UD.[ReportTo]
                           INNER JOIN [dbo].[UserDetail] UD1 WITH (NOLOCK)
                              ON UD.[UserId] = UD1.[ReportTo]
                       WHERE
                           UD1.[UserId] = @UserId
                           AND U.[UserId] > 0 
                           AND UD.[UserId] > 0
                       )
   END      
   ELSE
   BEGIN
      SET @ResultId = 0
   END
   
   RETURN @ResultId
END


' 
END

GO
/****** Object:  Table [dbo].[TempUserShift]    Script Date: 09-08-2018 18:45:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TempUserShift]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TempUserShift](
	[TempUserShiftId] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[ShiftId] [bigint] NOT NULL,
	[ApproverId] [int] NULL,
	[StatusId] [bigint] NOT NULL DEFAULT ((2)),
	[CreatedDate] [datetime] NOT NULL DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[LastModifiedDate] [datetime] NULL,
	[LastModifiedBy] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[TempUserShiftId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TempUserShiftDetail]    Script Date: 09-08-2018 18:45:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TempUserShiftDetail]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TempUserShiftDetail](
	[TempUserShiftDetailId] [bigint] IDENTITY(1,1) NOT NULL,
	[TempUserShiftId] [bigint] NOT NULL,
	[DateId] [bigint] NOT NULL,
	[StatusId] [bigint] NOT NULL DEFAULT ((2)),
	[Remarks] [varchar](500) NULL,
	[CreatedDate] [datetime] NOT NULL DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[LastModifiedDate] [datetime] NULL,
	[LastModifiedBy] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[TempUserShiftDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TempUserShiftHistory]    Script Date: 09-08-2018 18:45:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TempUserShiftHistory]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TempUserShiftHistory](
	[TempUserShiftHistoryId] [bigint] IDENTITY(1,1) NOT NULL,
	[TempUserShiftId] [bigint] NOT NULL,
	[StatusId] [bigint] NOT NULL DEFAULT ((1)),
	[Remarks] [varchar](500) NULL,
	[CreatedDate] [datetime] NOT NULL DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[TempUserShiftHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__TempUserS__Shift__635B4236]') AND parent_object_id = OBJECT_ID(N'[dbo].[TempUserShift]'))
ALTER TABLE [dbo].[TempUserShift]  WITH CHECK ADD FOREIGN KEY([ShiftId])
REFERENCES [dbo].[ShiftMaster] ([ShiftId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__TempUserS__Statu__644F666F]') AND parent_object_id = OBJECT_ID(N'[dbo].[TempUserShift]'))
ALTER TABLE [dbo].[TempUserShift]  WITH CHECK ADD FOREIGN KEY([StatusId])
REFERENCES [dbo].[OutingRequestStatus] ([StatusId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__TempUserS__UserI__62671DFD]') AND parent_object_id = OBJECT_ID(N'[dbo].[TempUserShift]'))
ALTER TABLE [dbo].[TempUserShift]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([UserId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__TempUserS__DateI__6A083FC5]') AND parent_object_id = OBJECT_ID(N'[dbo].[TempUserShiftDetail]'))
ALTER TABLE [dbo].[TempUserShiftDetail]  WITH CHECK ADD FOREIGN KEY([DateId])
REFERENCES [dbo].[DateMaster] ([DateId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__TempUserS__Statu__6AFC63FE]') AND parent_object_id = OBJECT_ID(N'[dbo].[TempUserShiftDetail]'))
ALTER TABLE [dbo].[TempUserShiftDetail]  WITH CHECK ADD FOREIGN KEY([StatusId])
REFERENCES [dbo].[OutingRequestStatus] ([StatusId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__TempUserS__TempU__69141B8C]') AND parent_object_id = OBJECT_ID(N'[dbo].[TempUserShiftDetail]'))
ALTER TABLE [dbo].[TempUserShiftDetail]  WITH CHECK ADD FOREIGN KEY([TempUserShiftId])
REFERENCES [dbo].[TempUserShift] ([TempUserShiftId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__TempUserS__Statu__70B53D54]') AND parent_object_id = OBJECT_ID(N'[dbo].[TempUserShiftHistory]'))
ALTER TABLE [dbo].[TempUserShiftHistory]  WITH CHECK ADD FOREIGN KEY([StatusId])
REFERENCES [dbo].[OutingRequestStatus] ([StatusId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__TempUserS__TempU__6FC1191B]') AND parent_object_id = OBJECT_ID(N'[dbo].[TempUserShiftHistory]'))
ALTER TABLE [dbo].[TempUserShiftHistory]  WITH CHECK ADD FOREIGN KEY([TempUserShiftId])
REFERENCES [dbo].[TempUserShift] ([TempUserShiftId])
GO
/****** Object:  StoredProcedure [dbo].[PROC_BookCab]    Script Date: 09-08-2018 18:45:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROC_BookCab]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PROC_BookCab] AS' 
END
GO

/*  
   Created Date      :     2018-06-25
   Created By        :     Kanchan Kumari
   Purpose           :     This stored procedure is used to book cab
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   Test Case: 
   DECLARE @Result int 
   EXEC [dbo].[PROC_BookCab]
   @EmployeeId = 2432
  ,@FromDate = '2018-06-27'
  ,@TillDate = '2018-06-27'
  ,@CabId = 1
  ,@ShiftId = 1
  ,@Success = @Result output
  SELECT @Result AS [RESULT]

*/

ALTER PROC [dbo].[PROC_BookCab](
 @EmployeeId INT
,@FromDate DATE
,@TillDate DATE
,@CabId INT
,@ShiftId INT
,@Success tinyInt=0 output
)
AS

BEGIN TRY

BEGIN TRAN

DECLARE @FromDateId BIGINT, @HRId INT,@TillDateId BIGINT, @ReportingManagerId INT,@StatusId INT=(SELECT StatusId FROM CabStatusMaster WHERE StatusCode='PA')
	    DECLARE @CabRequestId BIGINT
		SET @ReportingManagerId = (SELECT [dbo].[fnGetReportingManagerByUserId](@EmployeeId)) 
		SET @HRId = (SELECT [dbo].[fnGetHRIdByUserId](@EmployeeId));
	SELECT @FromDateId = MIN(DM.[DateId])
		  ,@TillDateId = MAX(DM.[DateId])
	FROM [dbo].[DateMaster] DM WITH (NOLOCK)
	WHERE DM.[Date] BETWEEN  @FromDate AND  @TillDate

	
	
	IF OBJECT_ID('tempdb..#TempCabDate') IS NOT NULL
	DROP TABLE #TempCabDate

		CREATE TABLE #TempCabDate
		(
			TempDate INT
		)

		WHILE (@FromDateId <= @TillDateId)
		BEGIN

			INSERT INTO #TempCabDate(TempDate) VALUES(@FromDateId)
			SET @FromDateId = @FromDateId +1;

		END
		
		IF(@ReportingManagerId=0 OR @ReportingManagerId=1)
		BEGIN
		SET @ReportingManagerId=@HRId
		END

	IF EXISTS(SELECT 1 FROM [dbo].CabRequestDetail
			  WHERE [CreatedBy] = @EmployeeId
			  AND [StatusId] <=2
			  AND (DateId IN (SELECT TempDate FROM #TempCabDate))
			  )	  
	BEGIN
	
		SET @Success = 2 --Already exists
	END
	ELSE
	BEGIN
		
	SELECT @FromDateId = MIN(DM.[DateId])
		  ,@TillDateId = MAX(DM.[DateId])
	FROM [dbo].[DateMaster] DM WITH (NOLOCK)
	WHERE DM.[Date] BETWEEN  @FromDate AND  @TillDate

	INSERT INTO CabRequest (FromDateId, TillDateId, CabId, CabShiftId, StatusId, ApproverId, CreatedBy )
				              VALUES(@FromDateId, @TillDateId, @CabId,@ShiftId, @StatusId, @ReportingManagerId,@EmployeeId)
		SET @CabRequestId= (SELECT SCOPE_IDENTITY())
		WHILE (@FromDateId <= @TillDateId)
		BEGIN
			INSERT INTO CabRequestDetail(CabRequestId, DateId,CabId,CabShiftId,StatusId, CreatedBy )
				            VALUES(@CabRequestId, @FromDateId,@CabId,@ShiftId,@StatusId, @EmployeeId)
							 
		     SET @FromDateId = @FromDateId +1;
				 
		END
		SET @Success=1 --------booked successfully
	END
   COMMIT;
    
END TRY

BEGIN CATCH

IF @@TRANCOUNT>0
BEGIN
ROLLBACK TRANSACTION;

 END
     SET @Success = 0 -- Error occurred
	 DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
	 --Log Error
	 EXEC [spInsertErrorLog]
			 @ModuleName = 'Cab Request'
			,@Source = 'PROC_BookCab'
			,@ErrorMessage = @ErrorMessage
			,@ErrorType = 'SP'
			,@ReportedByUserId = @EmployeeId
   
END CATCH



GO
/****** Object:  StoredProcedure [dbo].[Proc_FetchPendingLnsaShiftRequest]    Script Date: 09-08-2018 18:45:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_FetchPendingLnsaShiftRequest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_FetchPendingLnsaShiftRequest] AS' 
END
GO
/***
Created Date      :     2018-07-20
Created By        :     Kanchan Kumari
Purpose           :     This stored procedure is to get pending lnsa shift request
Change History    :
--------------------------------------------------------------------------
Modify Date       Edited By            Change Description
--------------------------------------------------------------------------
--------------------------------------------------------------------------
Test Cases        :
--------------------------------------------------------------------------
--- Test Case 1
EXEC [dbo].[Proc_FetchPendingLnsaShiftRequest]
  @FromDate= '2018-07-23'
 ,@TillDate ='2018-07-25'
 ,@RMId = 2203 
***/
ALTER PROCEDURE [dbo].[Proc_FetchPendingLnsaShiftRequest]
   @FromDate Date
  ,@TillDate DATE
  ,@RMId [int]
AS
BEGIN
  SELECT 
       UD.EmployeeName AS EmployeeName,
	   UDM.EmployeeName AS ReportingManagerName
  FROM TempUserShift TS JOIN TempUserShiftDetail TD ON TS.TempUserShiftId=TD.TempUserShiftId
	JOIN vwActiveUsers UD ON TS.UserId=UD.UserId 
	JOIN vwActiveUsers UDM ON TS.ApproverId = UDM.UserId 
	JOIN DateMaster DM ON DM.DateId = TD.DateId 
	JOIN [User] UM ON UDM.[UserId] = UM.[UserId]
  WHERE DM.[Date] BETWEEN @FromDate AND @TillDate
	AND TS.ApproverId= @RMId
	AND TS.StatusId=2 ORDER BY UD.EmployeeName
   END

GO
/****** Object:  StoredProcedure [dbo].[Proc_GetAllLnsaShiftRequest]    Script Date: 09-08-2018 18:45:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAllLnsaShiftRequest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetAllLnsaShiftRequest] AS' 
END
GO
 /***
Created Date      :     2018-07-20
Created By        :     Kanchan Kumari
Purpose           :     This stored procedure is used to get LNSA shift request to view
Change History    :
--------------------------------------------------------------------------
Modify Date       Edited By            Change Description
--------------------------------------------------------------------------
--------------------------------------------------------------------------
Test Cases        :
--------------------------------------------------------------------------
--- Test Case 1
EXEC [dbo].[Proc_GetAllLnsaShiftRequest]
   @UserId =2166
***/
 
 ALTER PROC [dbo].[Proc_GetAllLnsaShiftRequest](
 @UserId INT
 )
 AS
 BEGIN
SELECT 
      OS.[StatusCode] AS [StatusCode],
	  CASE WHEN (OS.StatusCode='CA' OR  OS.StatusCode='RJM' OR OS.StatusCode='RJH' OR OS.StatusCode='AP') THEN 
	  OS.[Status]+' by '+UM.FirstName+' '+UM.LastName ELSE 
	  OS.[Status]+' with '+AM.FirstName+' '+AM.LastName END AS [Status],
	  TS.TempUserShiftId,
	  UDM.FirstName+' '+UDM.LastName+': '+TEM.Remarks AS Remarks,
	  CONVERT(VARCHAR(15),TS.CreatedDate,106)+' '+FORMAT(TS.CreatedDate ,'hh:mm tt')  AS CreatedDate
      FROM TempUserShift TS 
	   LEFT JOIN UserDetail AM ON TS.ApproverId=AM.UserId
	   LEFT JOIN UserDetail UM ON TS.LastModifiedBy=UM.UserId
	  JOIN OutingRequestStatus OS ON TS.StatusId=OS.StatusId
	  JOIN(SELECT TempUserShiftId, MAX(TempUserShiftHistoryId) AS TempHistoryId FROM TempUserShiftHistory GROUP BY TempUserShiftId) TUH
	  ON TUH.TempUserShiftId=TS.TempUserShiftId 
	  JOIN TempUserShiftHistory TEM ON TEM.TempUserShiftHistoryId=TUH.TempHistoryId
	  JOIN UserDetail UDM ON UDM.UserId=TEM.CreatedBy
	  WHERE TS.UserId=@UserId  ORDER BY TS.CreatedDate DESC
 END
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetAllLnsaShiftReviewRequest]    Script Date: 09-08-2018 18:45:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAllLnsaShiftReviewRequest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetAllLnsaShiftReviewRequest] AS' 
END
GO
/***
Created Date      :     2018-07-20
Created By        :     Kanchan Kumari
Purpose           :     This stored procedure is used to get LNSA shift request to review
Change History    :
--------------------------------------------------------------------------
Modify Date       Edited By            Change Description
--------------------------------------------------------------------------
--------------------------------------------------------------------------
Test Cases        :
--------------------------------------------------------------------------
--- Test Case 1
EXEC [dbo].[Proc_GetAllLnsaShiftReviewRequest]
   @UserId =2166
***/
 

ALTER PROC [dbo].[Proc_GetAllLnsaShiftReviewRequest]
( @UserId INT 
)
AS
BEGIN
SET FMTONLY OFF;
	IF OBJECT_ID('tempdb..#TempShiftReview') IS NOT NULL
	    DROP TABLE #TempShiftReview

	 CREATE TABLE #TempShiftReview(
	 EmployeeName VARCHAR(500) NOT NULL,
	 [Status] VARCHAR(100) NOT NULL,
	 StatusCode VARCHAR(10) NOT NULL,
     TempUserShiftId INT NOT NULL,
     Remarks VARCHAR(100) NOT NULL,
	 CreatedDate VARCHAR(30) NOT NULL

	 )
	 INSERT INTO #TempShiftReview
      SELECT
      UD.FirstName+' '+UD.LastName AS EmployeeName,
	  OS.[Status]+' with '+UM.FirstName+' '+UM.LastName AS [Status],
	  OS.StatusCode AS StatusCode,
	  TS.TempUserShiftId ,
	  UDM.FirstName+' '+UDM.LastName+': '+TEM.Remarks AS Remarks,
	  CONVERT(VARCHAR(15),TS.CreatedDate,106)+' '+FORMAT(TS.CreatedDate ,'hh:mm tt')  AS CreatedDate
      FROM TempUserShift TS JOIN UserDetail UD ON TS.UserId=UD.UserId
	  LEFT JOIN UserDetail UM ON TS.ApproverId=UM.UserId
	  JOIN OutingRequestStatus OS ON TS.StatusId=OS.StatusId
	  JOIN(SELECT TempUserShiftId, MAX(TempUserShiftHistoryId) AS TempHistoryId FROM TempUserShiftHistory GROUP BY TempUserShiftId) TUH
	  ON TUH.TempUserShiftId=TS.TempUserShiftId 
	  JOIN TempUserShiftHistory TEM ON TEM.TempUserShiftHistoryId=TUH.TempHistoryId
	  JOIN UserDetail UDM ON UDM.UserId=TEM.CreatedBy
	  WHERE TS.ApproverId=@UserId  ORDER BY TS.CreatedDate DESC

	  INSERT INTO #TempShiftReview
	  SELECT
      UD.FirstName+' '+UD.LastName AS EmployeeName,
	  CASE WHEN (OS.StatusCode='CA' OR  OS.StatusCode='RJM' OR OS.StatusCode='RJH' OR OS.StatusCode='AP') THEN 
	  OS.[Status]+' by '+UM.FirstName+' '+UM.LastName ELSE 
	  OS.[Status]+' with '+AM.FirstName+' '+AM.LastName END AS [Status],
	  OS.StatusCode AS StatusCode,
	  TS.TempUserShiftId,
	  UDM.FirstName+' '+UDM.LastName+': '+TEM.Remarks AS Remarks,
	  CONVERT(VARCHAR(15),TS.CreatedDate,106)+' '+FORMAT(TS.CreatedDate ,'hh:mm tt')  AS CreatedDate
      FROM TempUserShift TS JOIN TempUserShiftHistory TH 
	  ON TS.TempUserShiftId=TH.TempUserShiftId JOIN UserDetail UD ON TS.UserId=UD.UserId
	  LEFT JOIN UserDetail UM ON TS.LastModifiedBy=UM.UserId
	  JOIN(SELECT TempUserShiftId, MAX(TempUserShiftHistoryId) AS TempHistoryId FROM TempUserShiftHistory GROUP BY TempUserShiftId) TUH
	  ON TUH.TempUserShiftId=TS.TempUserShiftId 
	  JOIN TempUserShiftHistory TEM ON TEM.TempUserShiftHistoryId=TUH.TempHistoryId
	  JOIN UserDetail UDM ON UDM.UserId=TEM.CreatedBy
	  LEFT JOIN UserDetail AM ON TS.ApproverId=AM.UserId
	  JOIN OutingRequestStatus OS ON TS.StatusId=OS.StatusId
	  WHERE TH.CreatedBy=@UserId  AND TS.UserId != @UserId ORDER BY TH.CreatedDate DESC
	
	  SELECT  * FROM #TempShiftReview

END
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetApproverDetails]    Script Date: 09-08-2018 18:45:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetApproverDetails]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetApproverDetails] AS' 
END
GO
/***
Created Date      :     2018-07-20
Created By        :     Kanchan Kumari
Purpose           :     This stored procedure is to ger approver's details
Change History    :
--------------------------------------------------------------------------
Modify Date       Edited By            Change Description
--------------------------------------------------------------------------
--------------------------------------------------------------------------
Test Cases        :
--------------------------------------------------------------------------
--- Test Case 1
EXEC Proc_GetApproverDetails @UserId=2432
***/
ALTER PROC [dbo].[Proc_GetApproverDetails](
@UserId INT
)
AS 
BEGIN
       SET FMTONLY OFF;
        DECLARE  @ReportingManagerId INT, @HRId INT, @StatusId INT=2
		SET @ReportingManagerId = (SELECT [dbo].[fnGetReportingManagerByUserId](@UserId)) 
		SET @HRId=(SELECT [dbo].[fnGetHRIdByUserId](@UserId))

			IF(@ReportingManagerId=1 OR @ReportingManagerId=0)
			BEGIN
			SET @ReportingManagerId=@HRId
			END
				IF OBJECT_ID('tempdb..#Result') IS NOT NULL
	            DROP TABLE #Result
		
               CREATE TABLE #Result(               
               [UserId] int
              ,[FirstName] [varchar](100)
              ,[LastName] [varchar](100)
              ,[EmailId] [varchar](200)
               )
			INSERT INTO #Result
            SELECT M.[UserId], M.[FirstName], M.[LastName], M.[EmailId]
            FROM [dbo].[UserDetail] M WITH (NOLOCK) 
            INNER JOIN [dbo].[UserDetail] U WITH (NOLOCK) ON M.[UserId] = @ReportingManagerId----change so that vm shoud not get mail
            WHERE U.[UserId] = @ReportingManagerId   

			SELECT * FROM #Result
END
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetGeminiUsers]    Script Date: 09-08-2018 18:45:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetGeminiUsers]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetGeminiUsers] AS' 
END
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
ALTER PROC [dbo].[Proc_GetGeminiUsers]
AS
BEGIN
SELECT U.UserId,
       UD.ExtensionNumber AS ExtNo,
	   U.EmailId,
       U.EmployeeName,
	   U.ReportingManagerName AS Manager,
	   D.DepartmentName AS Department
      FROM vwActiveUsers U
	  JOIN UserDetail UD ON U.UserId = UD.UserId
	  JOIN UserTeamMapping UTM ON U.UserId=UTM.UserId
	  JOIN Team T ON T.TeamId=UTM.TeamId 
	  JOIN Department D ON D.DepartmentId=T.DepartmentId
END
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetLegitimateLeave]    Script Date: 09-08-2018 18:45:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetLegitimateLeave]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetLegitimateLeave] AS' 
END
GO
/***
	Created Date      :     2018-05-1
	Created By        :     Kanchan Kumari
	Purpose           :     This stored procedure Get leave Deatils According to User status 
   
	Change History    :
	--------------------------------------------------------------------------
	Modify Date       Edited By            Change Description
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	Test Cases        :
	--------------------------------------------------------------------------
	EXEC [dbo].[Proc_GetLegitimateLeave] @UserId = 2166
***/
ALTER PROCEDURE [dbo].[Proc_GetLegitimateLeave] 
   @UserId [int]
AS
BEGIN
	SET NOCOUNT ON;
    SET FMTONLY OFF;
	DECLARE @AdminId int = 1;

IF OBJECT_ID('tempdb..#TempDataNew') IS NOT NULL
	DROP TABLE #TempDataNew

	CREATE TABLE #TempDataNew
	(
		[RequestId] INT NOT NULL,
		[EmployeeName] VARCHAR(100),
		[Date] VARCHAR(100),
		[Reason] VARCHAR(500),
		[ApplyDate] VARCHAR(20),
		[Status] VARCHAR(100),
		[LeaveInfo] VARCHAR(20),
		[Remarks] varchar(500),
		[StatusCode] VARCHAR(10)
	)

	--Fetch pending request
		INSERT INTO #TempDataNew([RequestId], [EmployeeName], [Date], [Reason], [ApplyDate], [Status],[LeaveInfo],[Remarks],[StatusCode])
		SELECT  LR.LegitimateLeaveRequestId AS [RequestId],
			UD.[FirstName] + ' ' + UD.[LastName] AS [EmployeeName],
			CONVERT(VARCHAR(20),DM.[Date] ,106) AS [Date],
			LR.[Reason] AS [Reason],
			CONVERT(VARCHAR(20), LR.CreatedDate,106) + ' ' + FORMAT(LR.CreatedDate,'hh:mm tt') AS [ApplyDate],
			(CASE WHEN S.StatusCode='PA' OR S.StatusCode='PV' THEN
			S.[Status]+' with '+ UDT.FirstName+' '+ UDT.LastName END) AS [Status],
			LR.LeaveCombination AS [LeaveInfo],
			APR.FirstName + ' ' + APR.LastName + ': ' +  REM.[Remarks] AS [Remarks],
			S.StatusCode AS [StatusCode]
		FROM LegitimateLeaveRequest LR 
		INNER JOIN  UserDetail UD WITH (NOLOCK) ON UD.UserId=LR.UserId 
		LEFT JOIN UserDetail UDT WITH (NOLOCK) ON UDT.UserId=LR.NextApproverId
		INNER JOIN  DateMaster DM WITH (NOLOCK) ON LR.DateId=DM.DateId   
		INNER JOIN LegitimateLeaveStatus S WITH (NOLOCK) ON LR.StatusId=S.StatusId
		JOIN (SELECT LegitimateLeaveRequestId, MAX(LegitimateLeaveRequestHistoryId) AS LegitimateLeaveRequestHistoryId FROM LegitimateLeaveRequestHistory GROUP BY LegitimateLeaveRequestId) ORH
			ON LR.LegitimateLeaveRequestId=ORH.LegitimateLeaveRequestId 
		INNER JOIN LegitimateLeaveRequestHistory REM WITH (NOLOCK) ON ORH.LegitimateLeaveRequestHistoryId=REM.LegitimateLeaveRequestHistoryId
		INNER JOIN UserDetail APR WITH (NOLOCK) ON REM.CreatedBy=APR.UserId
		WHERE LR.NextApproverId=@UserId order by LR.CreatedDate	DESC
		
		INSERT INTO #TempDataNew([RequestId], [EmployeeName], [Date], [Reason], [ApplyDate], [Status],[LeaveInfo],[Remarks],[StatusCode])
		SELECT  LR.LegitimateLeaveRequestId AS [RequestId],
			UD.[FirstName] + ' ' + UD.[LastName] AS [EmployeeName],
			CONVERT(VARCHAR(20),DM.[Date] ,106) AS [Date],
			LR.[Reason] AS [Reason],
			CONVERT(VARCHAR(20), LR.CreatedDate,106) + ' ' + FORMAT(LR.CreatedDate,'hh:mm tt') AS [ApplyDate],
			(CASE WHEN S.StatusCode='PA' OR S.StatusCode='PV' THEN S.[Status]+' with '+ UDT.FirstName+' '+ UDT.LastName END) AS [Status],
			LR.LeaveCombination AS [LeaveInfo],
			APR.FirstName + ' ' + APR.LastName + ': ' +  REM.[Remarks] AS [Remarks],
			SC.StatusCode AS [StatusCode]
				
			FROM LegitimateLeaveRequest LR 
		INNER JOIN  UserDetail UD WITH (NOLOCK) ON UD.UserId=LR.UserId 
		LEFT JOIN UserDetail UDT WITH (NOLOCK) ON UDT.UserId=LR.NextApproverId
		INNER JOIN  DateMaster DM WITH (NOLOCK) ON LR.DateId=DM.DateId   
		JOIN (SELECT LegitimateLeaveRequestId, MAX(LegitimateLeaveRequestHistoryId) AS LegitimateLeaveRequestHistoryId FROM LegitimateLeaveRequestHistory GROUP BY LegitimateLeaveRequestId) ORH
			ON LR.LegitimateLeaveRequestId=ORH.LegitimateLeaveRequestId 
		INNER JOIN LegitimateLeaveRequestHistory REM WITH (NOLOCK) ON ORH.LegitimateLeaveRequestHistoryId=REM.LegitimateLeaveRequestHistoryId
		INNER JOIN UserDetail APR WITH (NOLOCK) ON REM.CreatedBy=APR.UserId
		JOIN (SELECT LegitimateLeaveRequestId, MAX(StatusId) AS StatusId, MAX(CreatedDate) AS CreatedDate FROM LegitimateLeaveRequestHistory WITH (NOLOCK)  WHERE CreatedBy=@UserId
			GROUP BY LegitimateLeaveRequestId ) ACT
			ON ACT.LegitimateLeaveRequestId=LR.LegitimateLeaveRequestId
			INNER JOIN LegitimateLeaveStatus SC ON SC.StatusId=ACT.StatusId
			INNER JOIN LegitimateLeaveStatus S ON S.StatusId=LR.StatusId
		WHERE (ACT.StatusId<>1) AND LR.StatusId<=3 	AND LR.UserId!=@UserId ORDER BY REM.CreatedDate DESC
    
		INSERT INTO #TempDataNew([RequestId], [EmployeeName], [Date], [Reason], [ApplyDate], [Status],[LeaveInfo],[Remarks],[StatusCode])
		SELECT  LR.LegitimateLeaveRequestId AS [RequestId],
			UD.[FirstName] + ' ' + UD.[LastName] AS [EmployeeName],
			CONVERT(VARCHAR(20),DM.[Date] ,106) AS [Date],
			LR.[Reason] AS [Reason],
			CONVERT(VARCHAR(20), LR.CreatedDate,106) + ' ' + FORMAT(LR.CreatedDate,'hh:mm tt') AS [ApplyDate],
			S.[Status] +' by '+  UDTV.FirstName+' '+ UDTV.LastName  AS [Status],
			LR.LeaveCombination AS [LeaveInfo],
			APR.FirstName + ' ' + APR.LastName + ': ' +  REM.[Remarks] AS [Remarks],
			S.StatusCode AS [StatusCode]
		FROM LegitimateLeaveRequest LR 
		INNER JOIN  UserDetail UD WITH (NOLOCK) ON UD.UserId=LR.UserId 
		LEFT JOIN UserDetail UDT WITH (NOLOCK) ON UDT.UserId=LR.NextApproverId
		INNER JOIN  DateMaster DM WITH (NOLOCK) ON LR.DateId=DM.DateId   
		JOIN (SELECT LegitimateLeaveRequestId, MAX(LegitimateLeaveRequestHistoryId) AS LegitimateLeaveRequestHistoryId FROM LegitimateLeaveRequestHistory GROUP BY LegitimateLeaveRequestId) ORH
			ON LR.LegitimateLeaveRequestId=ORH.LegitimateLeaveRequestId 
		INNER JOIN LegitimateLeaveRequestHistory REM WITH (NOLOCK) ON ORH.LegitimateLeaveRequestHistoryId=REM.LegitimateLeaveRequestHistoryId
		INNER JOIN UserDetail APR WITH (NOLOCK) ON REM.CreatedBy=APR.UserId
		JOIN (SELECT LegitimateLeaveRequestId, MAX(StatusId) AS StatusId, MAX(CreatedDate) AS CreatedDate FROM LegitimateLeaveRequestHistory WITH (NOLOCK)  WHERE CreatedBy=@UserId
			GROUP BY LegitimateLeaveRequestId ) ACT
			ON ACT.LegitimateLeaveRequestId=LR.LegitimateLeaveRequestId
		INNER JOIN LegitimateLeaveStatus SC WITH (NOLOCK) ON ACT.StatusId=SC.StatusId
		INNER JOIN LegitimateLeaveStatus S WITH (NOLOCK) ON LR.StatusId=S.StatusId
		INNER JOIN UserDetail UDTV WITH (NOLOCK) ON (UDTV.UserId=LR.LastModifiedBy)
		WHERE (ACT.StatusId<>1)	AND LR.StatusId>=5 AND LR.UserId!=@UserId ORDER BY REM.CreatedDate DESC
		
SELECT [RequestId], [EmployeeName], [Date], [Reason], [ApplyDate], [Status],[LeaveInfo],[Remarks], [StatusCode]
FROM #TempDataNew 
END
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetOutingReviewRequest]    Script Date: 09-08-2018 18:45:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetOutingReviewRequest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetOutingReviewRequest] AS' 
END
GO
----------------------------------------------------------------------------
--Created Date      : 2018-03-21
--Created By        : Kanchan Kumari
--Purpose           : This stored procedure is used to apply outing request
--Usage				: EXEC [Proc_GetOutingReviewRequest] 2166
----------------------------------------------------------------------------
ALTER PROC [dbo].[Proc_GetOutingReviewRequest]
@LoginUserId [INT]
AS
BEGIN
	SET NOCOUNT ON;
	SET FMTONLY OFF;
	
	IF OBJECT_ID('tempdb..#TempDataNew') IS NOT NULL
	DROP TABLE #TempDataNew

	CREATE TABLE #TempDataNew
	(
		[OutingRequestId] INT NOT NULL,
		[EmployeeName] VARCHAR(100),
		[Period] VARCHAR(100),
		[Reason] VARCHAR(500),
		[ApplyDate] VARCHAR(20),
		[Status] VARCHAR(100),
		[DutyType] VARCHAR(50),
		[Remarks] varchar(500),
		[StatusCode] VARCHAR(10)
	)

	DECLARE @IsHR BIT=0
	SELECT @IsHR = 1 FROM UserDetail UD WITH (NOLOCK) 
				 JOIN Designation D ON UD.DesignationId=D.DesignationId 
				 JOIN DesignationGroup DG WITH (NOLOCK) ON D.DesignationGroupId = DG.DesignationGroupId 
				 WHERE UD.[UserId]=@LoginUserId AND DG.DesignationGroupId=5 --5: Human Resource
			
	--Fetch pending request
		INSERT INTO #TempDataNew([OutingRequestId], [EmployeeName], [Period], [Reason], [ApplyDate], [Status],[DutyType],[Remarks],[StatusCode])
		--Pending request
			SELECT  R.OutingRequestId AS [OutingRequestId],
				UD.[FirstName] + ' ' + UD.[LastName] AS [EmployeeName],
				CASE WHEN R.FromDateId=R.TillDateId THEN CAST(CONVERT(VARCHAR(20),DM1.[Date],106) AS Varchar(20)) 
							ELSE  CAST(CONVERT(VARCHAR(20),DM1.[Date],106) AS Varchar(20)) + '  To  ' + CAST(CONVERT(VARCHAR(20),DM2.[Date],106) AS Varchar(20) ) END AS [Period],
				R.[Reason] AS [Reason],
				CONVERT(VARCHAR(20), R.CreatedDate,106) + ' ' + FORMAT(R.CreatedDate,'hh:mm tt') AS [ApplyDate],
				(CASE WHEN S.StatusId=2 OR S.StatusId=3 THEN
				S.[Status]+' with '+ UDT.FirstName+' '+ UDT.LastName 
				ELSE S.[Status]+' by '+ UDT.FirstName+' '+ UDT.LastName END) AS [Status],
				OT.OutingTypeName AS [DutyType],
				APR.FirstName + ' ' + APR.LastName + ': ' +  REM.[Remarks] AS [Remarks],
				S.StatusCode
			FROM OutingRequest R 
			INNER JOIN  UserDetail UD WITH (NOLOCK) ON UD.UserId=R.UserId 
			INNER JOIN UserDetail UDT WITH (NOLOCK) ON UDT.UserId=R.NextApproverId
			INNER JOIN  DateMaster DM1 WITH (NOLOCK) ON R.FromDateId=DM1.DateId   
			INNER JOIN DateMaster DM2 WITH (NOLOCK) ON R.TillDateId=DM2.DateId
			INNER JOIN OutingRequestStatus S WITH (NOLOCK) ON R.StatusId=S.StatusId
			INNER JOIN OutingType OT WITH (NOLOCK) ON R.OutingTypeId=OT.OutingTypeId
			JOIN (SELECT OutingRequestId, MAX(OutingRequestHistoryId) AS OutingRequestHistoryId FROM OutingRequestHistory GROUP BY OutingRequestId) ORH
				ON R.OutingRequestId=ORH.OutingRequestId 
			INNER JOIN OutingRequestHistory REM WITH (NOLOCK) ON ORH.OutingRequestHistoryId=REM.OutingRequestHistoryId
			INNER JOIN UserDetail APR WITH (NOLOCK) ON REM.CreatedById=APR.UserId
			WHERE R.NextApproverId=@LoginUserId order by R.CreatedDate DESC

			INSERT INTO #TempDataNew([OutingRequestId], [EmployeeName], [Period], [Reason], [ApplyDate], [Status],[DutyType],[Remarks],[StatusCode])
			SELECT  R.OutingRequestId AS [OutingRequestId],
				UD.[FirstName] + ' ' + UD.[LastName] AS [EmployeeName],
				CASE WHEN R.FromDateId=R.TillDateId THEN CAST(CONVERT(VARCHAR(20),DM1.[Date],106) AS Varchar(20)) 
							ELSE  CAST(CONVERT(VARCHAR(20),DM1.[Date],106) AS Varchar(20)) + '  To  ' + CAST(CONVERT(VARCHAR(20),DM2.[Date],106) AS Varchar(20) ) END AS [Period],
				R.[Reason] AS [Reason],
				CONVERT(VARCHAR(20), R.CreatedDate,106) + ' ' + FORMAT(R.CreatedDate,'hh:mm tt') AS [ApplyDate],
				 S.[Status]+' with '+ UDT.FirstName+' '+ UDT.LastName AS [Status],
				OT.OutingTypeName AS [DutyType],
				APR.FirstName + ' ' + APR.LastName + ': ' +  REM.[Remarks] AS [Remarks],
				SC.[StatusCode] AS [StatusCode]
				
			FROM OutingRequest R 
			INNER JOIN  UserDetail UD WITH (NOLOCK) ON UD.UserId=R.UserId 
			INNER JOIN  DateMaster DM1 WITH (NOLOCK) ON R.FromDateId=DM1.DateId  
			INNER JOIN DateMaster DM2 WITH (NOLOCK) ON R.TillDateId=DM2.DateId
			INNER JOIN OutingType OT WITH (NOLOCK) ON R.OutingTypeId=OT.OutingTypeId
			JOIN (SELECT OutingRequestId, MAX(OutingRequestHistoryId) AS OutingRequestHistoryId FROM OutingRequestHistory GROUP BY OutingRequestId) ORH
				ON R.OutingRequestId=ORH.OutingRequestId 
			INNER JOIN OutingRequestHistory REM WITH (NOLOCK) ON ORH.OutingRequestHistoryId=REM.OutingRequestHistoryId
			INNER JOIN UserDetail APR WITH (NOLOCK) ON REM.CreatedById=APR.UserId

			JOIN (SELECT OutingRequestId, MAX(StatusId) AS StatusId, MAX(CreatedDate) AS CreatedDate FROM OutingRequestHistory WITH (NOLOCK)  WHERE CreatedById=@LoginUserId
			 GROUP BY OutingRequestId ) ACT
				ON ACT.OutingRequestId=R.OutingRequestId
			INNER JOIN OutingRequestStatus SC WITH (NOLOCK) ON ACT.StatusId=SC.StatusId
			INNER JOIN OutingRequestStatus S WITH (NOLOCK) ON R.StatusId=S.StatusId
			INNER JOIN UserDetail UDT WITH (NOLOCK) ON (UDT.UserId=R.NextApproverId)
			WHERE (ACT.StatusId<>1) AND R.StatusId<=3 AND R.UserId!=@LoginUserId order by REM.CreatedDate DESC 

			INSERT INTO #TempDataNew([OutingRequestId], [EmployeeName], [Period], [Reason], [ApplyDate], [Status],[DutyType],[Remarks],[StatusCode])
			SELECT  R.OutingRequestId AS [OutingRequestId],
				UD.[FirstName] + ' ' + UD.[LastName] AS [EmployeeName],
				CASE WHEN R.FromDateId=R.TillDateId THEN CAST(CONVERT(VARCHAR(20),DM1.[Date],106) AS Varchar(20)) 
							ELSE  CAST(CONVERT(VARCHAR(20),DM1.[Date],106) AS Varchar(20)) + '  To  ' + CAST(CONVERT(VARCHAR(20),DM2.[Date],106) AS Varchar(20) ) END AS [Period],
				R.[Reason] AS [Reason],
				CONVERT(VARCHAR(20), R.CreatedDate,106) + ' ' + FORMAT(R.CreatedDate,'hh:mm tt') AS [ApplyDate],
				 S.[Status]+' by '+UDTV.FirstName+' '+UDTV.LastName AS [Status],
				 OT.OutingTypeName AS [DutyType],
				APR.FirstName + ' ' + APR.LastName + ': ' +  REM.[Remarks] AS [Remarks],
				S.[StatusCode] AS [StatusCode]
				
			FROM OutingRequest R 
			INNER JOIN  UserDetail UD WITH (NOLOCK) ON UD.UserId=R.UserId 
			INNER JOIN  DateMaster DM1 WITH (NOLOCK) ON R.FromDateId=DM1.DateId  
			INNER JOIN DateMaster DM2 WITH (NOLOCK) ON R.TillDateId=DM2.DateId
			INNER JOIN OutingType OT WITH (NOLOCK) ON R.OutingTypeId=OT.OutingTypeId
			JOIN (SELECT OutingRequestId, MAX(OutingRequestHistoryId) AS OutingRequestHistoryId FROM OutingRequestHistory GROUP BY OutingRequestId) ORH
				ON R.OutingRequestId=ORH.OutingRequestId 
			INNER JOIN OutingRequestHistory REM WITH (NOLOCK) ON ORH.OutingRequestHistoryId=REM.OutingRequestHistoryId
			INNER JOIN UserDetail APR WITH (NOLOCK) ON REM.CreatedById=APR.UserId

			JOIN (SELECT OutingRequestId, MAX(StatusId) AS StatusId, MAX(CreatedDate) AS CreatedDate FROM OutingRequestHistory WITH (NOLOCK)  WHERE CreatedById=@LoginUserId
			 GROUP BY OutingRequestId ) ACT
				ON ACT.OutingRequestId=R.OutingRequestId
			INNER JOIN OutingRequestStatus SC WITH (NOLOCK) ON ACT.StatusId=SC.StatusId
			INNER JOIN OutingRequestStatus S WITH (NOLOCK) ON R.StatusId=S.StatusId
			INNER JOIN UserDetail UDTV WITH (NOLOCK) ON (UDTV.UserId=R.ModifiedById)
			WHERE (ACT.StatusId<>1)	AND R.StatusId>=5 AND R.UserId!=@LoginUserId  order by REM.CreatedDate DESC 
			
		
	SELECT [OutingRequestId], [EmployeeName], [Period], [Reason], [ApplyDate], [Status],[DutyType],[Remarks], [StatusCode]
	FROM #TempDataNew 
END

GO
/****** Object:  StoredProcedure [dbo].[Proc_GetShiftMappingDetails]    Script Date: 09-08-2018 18:45:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetShiftMappingDetails]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetShiftMappingDetails] AS' 
END
GO
/***
   Created Date      :     2018-07-25
   Created By        :     Kanchan kumari
   Purpose           :     This stored procedure retrives current week and week details
   Change History    :
   --------------------------------------------------------------------------
	   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
      EXEC Proc_GetShiftMappingDetails @UserId=24, @StartDate='2018-07-25',@EndDate='2018-08-24'
***/
/***
   Created Date      :     2018-07-25
   Created By        :     Kanchan kumari
   Purpose           :     This stored procedure retrives current week and week details
   Change History    :
   --------------------------------------------------------------------------
	   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
      EXEC Proc_GetShiftMappingDetails @UserId=4, @StartDate='2018-07-25',@EndDate='2018-08-24'
***/
ALTER PROC [dbo].[Proc_GetShiftMappingDetails]
(
  @UserId INT
 ,@StartDate DATE
 ,@EndDate DATE
)
AS
BEGIN
SET FMTONLY OFF;
	IF OBJECT_ID('tempdb..#TempWeek') IS NOT NULL
	DROP TABLE #TempWeek

	IF OBJECT_ID('tempdb..#TempUserData') IS NOT NULL
	DROP TABLE #TempUserData 
		
	IF OBJECT_ID('tempdb..#TempShiftCalender') IS NOT NULL
	DROP TABLE #TempShiftCalender

	CREATE TABLE #TempWeek
	(
	 [StartDate] [date] NOT NULL
	,[EndDate] [date] NOT NULL
	,[WeekNo] [int] NOT NULL
	,DateInfo DATE NULL
	)

	DECLARE @NewStartDate DATE , @NewEndDate DATE
	SET @NewStartDate = @StartDate
	SET @NewEndDate = @EndDate

	WHILE(@StartDate<=@EndDate)
	BEGIN
		INSERT INTO #TempWeek([StartDate],[EndDate],[WeekNo])
		EXEC [spFetchWeekMap] @UserId,@StartDate
		UPDATE #TempWeek SET DateInfo=@StartDate WHERE DateInfo IS NULL
		SET @StartDate = (SELECT DATEADD(d,1,@StartDate))
	END

	CREATE TABLE #TempUserData
	(
	UserId INT,
	DateId BIGINT,
	StatusId INT,
	StatusCode VARCHAR(10) 
	)
	INSERT INTO #TempUserData
		SELECT  TD.CreatedBy AS UserId,
				TD.DateId,
				TD.StatusId,
				OS.StatusCode
				FROM TempUserShiftDetail TD 
				INNER JOIN OutingRequestStatus OS ON TD.StatusId =OS.StatusId
				WHERE TD.CreatedBy = @UserId AND OS.StatusCode='PA'

	INSERT INTO #TempUserData
		SELECT  USM.UserId AS UserId,
				USM.DateId,
			    (SELECT StatusId FROM OutingRequestStatus WHERE StatusCode='AP') AS StatusId,
				'AP'
				FROM  UserShiftMapping USM 
				WHERE USM.UserId =@UserId AND USM.IsActive=1

  CREATE TABLE #TempShiftCalender
   (  
      [MappingStartDate] VARCHAR(20) NOT NULL,
	  [MappingEndDate] VARCHAR(20) NOT NULL,
	  [DateId] BIGINT NOT NULL
	 ,[WeekNo] BIGINT NOT NULL
	 ,[Month] VARCHAR(20) NOT NULL
	 ,[Year] INT NOT NULL
	 ,[DateInt] INT NOT NULL
	 ,[Day] VARCHAR(20) NOT NULL
	 ,FullDate VARCHAR(50) NOT NULL
	 ,IsApplied BIT NOT NULL
	 ,IsApproved BIT NOT NULL
   )
   INSERT INTO #TempShiftCalender([MappingStartDate],[MappingEndDate],[DateId],[WeekNo],[Month],[Year],[DateInt],[Day],FullDate,
                            IsApplied,IsApproved)
   SELECT  
           CONVERT(VARCHAR(15),@NewStartDate,106)              AS [MappingStartDate],
           CONVERT(VARCHAR(15),@NewEndDate,106)                AS [MappingEndDate],
           DM.DateId                                        AS [DateId],
           T.WeekNo                                         AS  WeekNo,
           CAST(DATENAME(mm,T.DateInfo) AS VARCHAR(20))		AS [Month] , 
		   CAST(DATEPART(yyyy,T.DateInfo) AS INT)			AS [Year],
		   CAST(DATEPART(d,T.DateInfo) AS INT)				AS [DateInt], 
		   DM.[Day]                                         AS [Day],
		   CONVERT(VARCHAR(15),T.DateInfo,106)              AS FullDate,
		   CASE WHEN TD.StatusCode='PA' OR TD.StatusCode='AP' THEN 1
		        ELSE 0 END                                  AS IsApplied,
           CASE WHEN TD.StatusCode ='AP' THEN 1
		       ELSE 0 END                                   AS IsApproved
		 FROM #TempWeek T
		 JOIN DateMaster DM ON T.DateInfo=DM.[Date]
		 LEFT JOIN #TempUserData TD ON DM.[DateId]=TD.DateId 
		 ORDER BY DM.DateId
		 

	SELECT [DateId],[WeekNo],[Month],[Year],[DateInt],[Day],FullDate,IsApplied,
         IsApproved,[MappingStartDate],[MappingEndDate]
	FROM #TempShiftCalender
		
END



GO
/****** Object:  StoredProcedure [dbo].[Proc_MapLnsaShift]    Script Date: 09-08-2018 18:45:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_MapLnsaShift]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_MapLnsaShift] AS' 
END
GO
/***
Created Date      :     2018-07-20
Created By        :     Kanchan Kumari
Purpose           :     This stored procedure is to map night shift by user
Change History    :
--------------------------------------------------------------------------
Modify Date       Edited By            Change Description
--------------------------------------------------------------------------
--------------------------------------------------------------------------
Test Cases        :
--------------------------------------------------------------------------
--- Test Case 1
DECLARE @Res tinyint=0, @Output varchar(max)
EXEC [dbo].[Proc_MapLnsaShift]
  @EmployeeId = 84
 ,@DateId ='11024,11025,11026,11027,11028,11029,11030,11031,11032,11033,11034,11035,11036'
 ,@Success = @Res output 
 ,@Result = @Output output
SELECT @Res AS Status, @Output AS Result

SELECT * from TempUserShift
SELECT * from TempUserShiftHistory
SELECT * from TempUserShiftDetail

***/
ALTER PROC [dbo].[Proc_MapLnsaShift] 
(
@EmployeeId INT,
@DateId VARCHAR(500),
@Success tinyint out,
@Result VARCHAR(MAX) = '' OUT
)
AS 
BEGIN TRY
SET NOCOUNT ON;
     IF(@DateId='' OR @DateId IS NULL)
	 BEGIN
	 SET @Success=3;----date is empty or null
	 END
     ELSE
	 BEGIN
    BEGIN TRANSACTION;
	IF OBJECT_ID('tempdb..#TempShiftMap') IS NOT NULL
	    DROP TABLE #TempShiftMap
		
		IF OBJECT_ID('tempdb..#Result') IS NOT NULL
	    DROP TABLE #Result
		
            CREATE TABLE #Result(               
               [UserId] int
              ,[FirstName] [varchar](100)
              ,[LastName] [varchar](100)
              ,[EmailId] [varchar](200)
			  --,[Status] INT NOT NULL
              )
	 CREATE TABLE #TempShiftMap(
	 IdentityId INT,
	 DateId INT
	 )
        DECLARE  @ReportingManagerId INT, @HRId INT, @StatusId INT=2
		SET @ReportingManagerId = (SELECT [dbo].[fnGetReportingManagerByUserId](@EmployeeId)) 
		SET @HRId=(SELECT [dbo].[fnGetHRIdByUserId](@EmployeeId))

		INSERT INTO #TempShiftMap 

		SELECT * FROM Fun_SplitStringInt(@DateId,',')

        IF EXISTS(SELECT 1 FROM TempUserShiftDetail 
                  WHERE CreatedBy=@EmployeeId
				  AND StatusId<6
				  AND (DateId IN(SELECT DateId FROM #TempShiftMap)))
		BEGIN
				SET @Success=2---already exist
		END
		ELSE
		BEGIN
			IF(@ReportingManagerId=1 OR @ReportingManagerId=0)
			BEGIN
			SET @ReportingManagerId=@HRId
			END
        --------------------------insert into TempUserShift------------------------------
	         INSERT INTO TempUserShift ( UserId, ShiftId, ApproverId, StatusId, CreatedBy)
             VALUES( @EmployeeId,( SELECT ShiftId FROM ShiftMaster where [ShiftName]='C'), 
			                  @ReportingManagerId, @StatusId, @EmployeeId )
		
		 -------------------------insert into TempUserShiftDetail-----------------------
			 DECLARE @TempUserShiftId INT =(SELECT  SCOPE_IDENTITY())

			 DECLARE @count INT=(SELECT COUNT(DateId) FROM #TempShiftMap), @i INT=1

			 WHILE(@i <= @count)
			 BEGIN
				 INSERT INTO TempUserShiftDetail (TempUserShiftId, DateId, StatusId, Remarks, CreatedBy)
				 VALUES( @TempUserShiftId, (SELECT DateId FROM #TempShiftMap where IdentityId=@i), @StatusId,'Applied', @EmployeeId)
				 SET @i = @i + 1;
			 END
        --------------------------insert into TempUserShiftHistory---------------------

			 INSERT INTO TempUserShiftHistory (TempUserShiftId, Remarks, CreatedBy)
			 VALUES( @TempUserShiftId,'Applied', @EmployeeId)
			
			INSERT INTO #Result
            SELECT M.[UserId], M.[FirstName], M.[LastName], M.[EmailId]
            FROM [dbo].[UserDetail] M WITH (NOLOCK) 
            INNER JOIN [dbo].[UserDetail] U WITH (NOLOCK) ON M.[UserId] = @ReportingManagerId----change so that vm shoud not get mail
            WHERE U.[UserId] = @ReportingManagerId    

			SET @Success=1  	
		END
		--shift mapped successfully
		COMMIT;
		SELECT @Result = [dbo].[Fun_ConvertXmlToJson]((select * from #Result FOR XML PATH, root))
    END
END TRY

BEGIN CATCH
	 IF(@@TRANCOUNT>0)
	 ROLLBACK TRANSACTION;

	 SET @Success=0;  ---error occurred
	 
	 DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
	 --Log Error
	 EXEC [spInsertErrorLog]
			 @ModuleName = 'LNSA'
			,@Source = 'Proc_MapLnsaShift'
			,@ErrorMessage = @ErrorMessage
			,@ErrorType = 'SP'
			,@ReportedByUserId = @EmployeeId
END CATCH
--select * from errorlog order by 1 desc

GO
/****** Object:  StoredProcedure [dbo].[Proc_TakeActionOnLegitimateLeave]    Script Date: 09-08-2018 18:45:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TakeActionOnLegitimateLeave]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_TakeActionOnLegitimateLeave] AS' 
END
GO
/***
Created Date      : 2018-03-21
Created By        : Kanchan Kumari
Description       : To approve/reject Legitimate Leave
Change History    :
	--------------------------------------------------------------------------
	Modify Date       Edited By            Change Description
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	Test Cases        :
	--------------------------------------------------------------------------
	DECLARE @Result INT
	EXEC [Proc_TakeActionOnLegitimateLeave]
		  @LegitimateLeaveRequestId =73,
		  @StatusCode='RJM',
		  @Remarks='cant',
		  @LoginUserId=3,
		  @LoginUserType='MGR',
		  @Success=@Result output
	SELECT @Result As [RESULT]
***/
ALTER PROC [dbo].[Proc_TakeActionOnLegitimateLeave]
@LegitimateLeaveRequestId BIGINT,
@StatusCode VARCHAR(20),
@Remarks VARCHAR(500) = NULL,
@LoginUserId BIGINT,
@LoginUserType VARCHAR(200) = NULL,
@Success TINYINT = 0 Output
AS
BEGIN TRY
BEGIN TRAN

	DECLARE @StatusId INT, @StatusIdNew INT, @EmployeeId BIGINT,@FirstReportingId BIGINT , @SecondReportingId BIGINT, @HRId BIGINT,@DateId BIGINT,@Reason VARCHAR(500)

	DECLARE @count INT,@FromDateId INT,@TillDateId INT,@CountDate INT=0,@HRHeadId INT=2166,@StatusIdForHR INT
	SELECT @EmployeeId=[UserId] FROM [dbo].LegitimateLeaveRequest WITH (NOLOCK) WHERE LegitimateLeaveRequestId=@LegitimateLeaveRequestId
	SET @SecondReportingId= (SELECT [dbo].[fnGetSecondReportingManagerByUserId](@EmployeeId))
	SET @HRId=(SELECT [dbo].[fnGetHRIdByUserId](@EmployeeId))
	SET @FirstReportingId=(SELECT [dbo].[fnGetReportingManagerByUserId](@EmployeeId))
	SET @DateId=(SELECT DateId From LegitimateLeaveRequest where LegitimateLeaveRequestId=@LegitimateLeaveRequestId)
	SET @Reason=(SELECT Reason From LegitimateLeaveRequest where LegitimateLeaveRequestId=@LegitimateLeaveRequestId)

	DECLARE @LeaveRequestApplicationId BIGINT
					SET @LeaveRequestApplicationId=(SELECT LeaveRequestApplicationId FROM LegitimateLeaveRequest WHERE LegitimateLeaveRequestId=@LegitimateLeaveRequestId)
	
		SET @StatusIdForHR=(SELECT [StatusId] FROM [dbo].LegitimateLeaveRequest WITH (NOLOCK) WHERE LegitimateLeaveRequestId=@LegitimateLeaveRequestId)
		IF(@LoginUserId=@HRHeadId AND @StatusCode='AP' AND @StatusIdForHR!=2)
		BEGIN
		SET @StatusCode='VD'
		END
		SELECT @StatusId = [StatusId] FROM [dbo].[LegitimateLeaveStatus] WITH (NOLOCK) WHERE [StatusCode]=@StatusCode
	--Approved By first level Manager
	 IF(@StatusCode='AP')
	BEGIN
	     --VM-3
		 --PC-4
		 --AS -2203
		 --AP-2167
		  IF(@LoginUserId=@FirstReportingId)
		 BEGIN
			 IF(@SecondReportingId=0)
			 BEGIN
			 SET @SecondReportingId=@HRId
			 SET @StatusIdNew=(SELECT StatusId From OutingRequestStatus where StatusCode='PV')
			 END
			 ELSE
			 BEGIN
			  SET @StatusIdNew=(SELECT StatusId From OutingRequestStatus where StatusCode='PA')
			 END
		
			INSERT INTO LegitimateLeaveRequestHistory(LegitimateLeaveRequestId,DateId,Reason,StatusId,Remarks,CreatedBy)
	                  VALUES( @LegitimateLeaveRequestId,@DateId,@Reason, @StatusId, @Remarks,@LoginUserId)
			-- Request Table
			UPDATE LegitimateLeaveRequest set NextApproverId=@SecondReportingId,StatusId=@StatusIdNew,LastModifiedBy=@LoginUserId, LastModifiedDate=GETDATE()
			WHERE LegitimateLeaveRequestId=@LegitimateLeaveRequestId
		 END
			--Approved by Second level Manager
		  ELSE IF(@LoginUserId=@SecondReportingId)
			BEGIN
				SET @StatusIdNew=(SELECT StatusId From OutingRequestStatus where StatusCode='PV')
			    INSERT INTO LegitimateLeaveRequestHistory(LegitimateLeaveRequestId,DateId,Reason,StatusId,Remarks,CreatedBy)
	              			VALUES( @LegitimateLeaveRequestId,@DateId,@Reason, @StatusId, @Remarks,@LoginUserId)
			    UPDATE LegitimateLeaveRequest set NextApproverId=@HRId,StatusId=@StatusIdNew,LastModifiedBy=@LoginUserId, LastModifiedDate=GETDATE()
				   WHERE LegitimateLeaveRequestId=@LegitimateLeaveRequestId
		
	          END
       END

	-- Verififed by HR
	ELSE IF(@StatusCode='VD')
	BEGIN
		INSERT INTO LegitimateLeaveRequestHistory(LegitimateLeaveRequestId,DateId,Reason,StatusId,Remarks,CreatedBy)
	              	VALUES( @LegitimateLeaveRequestId,@DateId,@Reason, @StatusId, @Remarks,@LoginUserId)
	    UPDATE LegitimateLeaveRequest set NextApproverId=NULL,StatusId=@StatusId,LastModifiedBy=@LoginUserId, LastModifiedDate=GETDATE()
		            WHERE LegitimateLeaveRequestId=@LegitimateLeaveRequestId
					
					Update LeaveRequestApplication SET StatusId=0,LastModifiedBy=@LoginUserId,LastModifiedDate=GETDATE()
					                             WHERE LeaveRequestApplicationId=@LeaveRequestApplicationId

					INSERT INTO LeaveHistory(LeaveRequestApplicationId,StatusId,ApproverId,ApproverRemarks,CreatedBy)
					VALUES (@LeaveRequestApplicationId,0,@LoginUserId,'LWP change request approved',@LoginUserId)


					UPDATE A SET A.[Count] =  A.[Count] - 1 FROM [dbo].[LeaveBalance] A WITH (NOLOCK)
					INNER JOIN LeaveTypeMaster B ON B.TypeId=A.LeaveTypeId
					WHERE B.ShortName='LWP' AND A.UserId=@EmployeeId
    END
	--Rejected by Manager
	ELSE IF(@StatusCode='RJM' OR @StatusCode='RJH')
	BEGIN
	

	 ----------------update RequestCompOffDetail table starts---------------------------------------
	    UPDATE RequestCompOffDetail SET IsActive=0, ModifiedDate=GETDATE(), ModifiedById=@LoginUserId 
		            WHERE LegitimateLeaveRequestId=@LegitimateLeaveRequestId

  --------------update RequestCompOffDetail table ends-------------------------------------------
	   

  ----------------update RequestCompOff table starts----------------------------------------------

       DECLARE @RequestId INT
	   SET @RequestId=(SELECT RequestId FROM RequestCompOffDetail WHERE LegitimateLeaveRequestId=@LegitimateLeaveRequestId)
	    UPDATE RequestCompOff SET IsAvailed=0 WHERE RequestId=@RequestId

  --------------update RequestCompOff table ends---------------------------------------

	INSERT INTO LegitimateLeaveRequestHistory(LegitimateLeaveRequestId,DateId,Reason,StatusId,Remarks,CreatedBy)
	              	VALUES( @LegitimateLeaveRequestId,@DateId,@Reason, @StatusId, @Remarks,@LoginUserId)
		  UPDATE LegitimateLeaveRequest set NextApproverId=NULL,StatusId=@StatusId,LastModifiedBy=@LoginUserId, LastModifiedDate=GETDATE()
		            WHERE LegitimateLeaveRequestId=@LegitimateLeaveRequestId
      
	    DECLARE @LeaveCombination VARCHAR(10),@Id VARCHAR(10)
		SET @LeaveCombination=(SELECT LeaveCombination From LegitimateLeaveRequest WHERE LegitimateLeaveRequestId=@LegitimateLeaveRequestId)
		SET @Id=(SELECT [Character] FROM [dbo].[fnSplitWord](@LeaveCombination, ' ') where Id=2)
		
      INSERT INTO [dbo].[LeaveBalanceHistory]
      (
         [RecordId]
        ,[Count]
        ,[CreatedBy]
      )
	
	SELECT A.RecordId ,A.[Count],@EmployeeId
	    FROM LeaveBalance A INNER JOIN LeaveTypeMaster B ON B.TypeId= A.LeaveTypeId 
		WHERE B.ShortName=@Id AND A.UserId=@EmployeeId
	  UPDATE A
      SET A.[Count] = A.[Count] + 1
	  FROM [dbo].[LeaveBalance] A WITH (NOLOCK)
      INNER JOIN LeaveTypeMaster B ON B.TypeId=A.LeaveTypeId
	  WHERE B.ShortName=@Id AND A.UserId=@EmployeeId
	          END
	SET @Success=1
	COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0
SET @Success=0
	ROLLBACK TRANSACTION
	DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
        EXEC [spInsertErrorLog]
	        @ModuleName = 'LeaveManagement'
        ,@Source = '[Proc_TakeActionOnLegitimateLeave]'
        ,@ErrorMessage = @ErrorMessage
        ,@ErrorType = 'SP'
        ,@ReportedByUserId = @LoginUserId
END CATCH

GO
/****** Object:  StoredProcedure [dbo].[Proc_TakeActionOnMapLnsaShift]    Script Date: 09-08-2018 18:45:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TakeActionOnMapLnsaShift]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_TakeActionOnMapLnsaShift] AS' 
END
GO
/***
Created Date      :     2018-07-20
Created By        :     Kanchan Kumari
Purpose           :     This stored procedure is used to take action on LNSA shift request
Change History    :
--------------------------------------------------------------------------
Modify Date       Edited By            Change Description
--------------------------------------------------------------------------
--------------------------------------------------------------------------
Test Cases        :
--------------------------------------------------------------------------
--- Test Case 1
DECLARE @Result int 
EXEC [dbo].[Proc_TakeActionOnMapLnsaShift]
  @LoginUserId =2432
  ,@RequestId =3
  ,@Remarks='ok done'
  ,@StatusCode = 'AP' 
  ,@ActionCode = 'ALL'
  ,@Success = @Result output
SELECT @Result AS [RESULT]

SELECT * from TempUserShift
SELECT * from TempUserShiftHistory
SELECT * from TempUserShiftDetail

***/
ALTER PROC [dbo].[Proc_TakeActionOnMapLnsaShift]
(
 @LoginUserId INT,
 @RequestId INT,
 @Remarks VARCHAR(500),
 @StatusCode VARCHAR(5),
 @ActionCode VARCHAR(5),
 @Success TINYINT output
)
AS 
BEGIN TRY
        BEGIN TRANSACTION
		 DECLARE @StatusId INT, @TempUserShiftId INT, @ActualCount INT, @Count INT, @UserId INT

		 IF(@StatusCode='CA' )
		 BEGIN
			 SET @StatusId  = ( SELECT StatusId FROM OutingRequestStatus WHERE StatusCode=@StatusCode)
	          
			  IF( @ActionCode='ALL')
			  BEGIN
			           --@RequestId AS TempUserShiftId
     
			   ---------------------update TempUserShift---------------

						UPDATE TempUserShift 
						   SET StatusId = @StatusId,
							   ApproverId = NULL,
							   LastModifiedBy = @LoginUserId,
							   LastModifiedDate = GETDATE() WHERE TempUserShiftId = @RequestId
	  
			  ----------------------update TempUserShiftDetail---------

						UPDATE TempUserShiftDetail
						   SET StatusId = @StatusId,
						       Remarks=@Remarks,
							   LastModifiedBy = @LoginUserId,
							   LastModifiedDate = GETDATE() WHERE TempUserShiftId = @RequestId

			  ----------------------Insert into TempUserShiftHistory--------
				 INSERT INTO TempUserShiftHistory (TempUserShiftId, Remarks,StatusId,CreatedBy)
		   	     VALUES( @RequestId,@Remarks,@StatusId, @LoginUserId)
				END
				ELSE
			    BEGIN
			                    
								  --@RequestId AS TempUserShiftDetailId

	            ---------------------update TempUserShiftDetail---------------
				     	UPDATE TempUserShiftDetail
				    
						   SET StatusId = @StatusId,
						       Remarks=@Remarks,
							   LastModifiedBy = @LoginUserId,
							   LastModifiedDate = GETDATE() WHERE TempUserShiftDetailId = @RequestId
                
				                   SET @TempUserShiftId  = ( SELECT TempUserShiftId FROM TempUserShiftDetail
						                                          WHERE TempUserShiftDetailId = @RequestId)

                                   SET @Count  = (SELECT Count(TempUserShiftDetailId) FROM TempUserShiftDetail
						                                     WHERE TempUserShiftId = @TempUserShiftId  AND StatusId = @StatusId )

                                   SET @ActualCount =  (SELECT Count(TempUserShiftDetailId) FROM TempUserShiftDetail
						                                     WHERE TempUserShiftId = @TempUserShiftId)
                                    IF (@ActualCount = @Count)
									BEGIN
									     -------------------update TempUserShift---------------
										  UPDATE TempUserShift 
										  SET StatusId = @StatusId,
											   ApproverId = NULL,
											   LastModifiedBy = @LoginUserId,
											   LastModifiedDate = GETDATE() WHERE TempUserShiftId = @TempUserShiftId

                                               ----------------------Insert into TempUserShiftHistory--------
			                     	           INSERT INTO TempUserShiftHistory (TempUserShiftId, Remarks,StatusId,CreatedBy)
		   	                                   VALUES( @TempUserShiftId,@Remarks,@StatusId, @LoginUserId)
								    END

             END
         END
		 ELSE IF(@StatusCode='RJM' OR @StatusCode='RJH')
		 BEGIN
		           --@RequestId AS TempUserShiftId
		          SET @StatusId = ( SELECT StatusId FROM OutingRequestStatus WHERE StatusCode=@StatusCode)
	          
				  IF( @ActionCode='ALL' )
			      BEGIN
				         ---------------------update TempUserShift---------------

						   UPDATE TempUserShift 
						   SET StatusId = @StatusId,
							   ApproverId = NULL,
							   LastModifiedBy = @LoginUserId,
							   LastModifiedDate = GETDATE() WHERE TempUserShiftId = @RequestId
 
                           ----------------------update TempUserShiftDetail---------
					 	   UPDATE TempUserShiftDetail
						   SET StatusId = @StatusId,
						       Remarks=@Remarks,
							   LastModifiedBy = @LoginUserId,
							   LastModifiedDate = GETDATE() WHERE TempUserShiftId = @RequestId
							      ----------------------Insert into TempUserShiftHistory--------
			                     	           INSERT INTO TempUserShiftHistory (TempUserShiftId, Remarks,StatusId,CreatedBy)
		   	                                   VALUES( @RequestId, @Remarks, @StatusId, @LoginUserId)
				  END
				  ELSE 
				  BEGIN
				    --@RequestId AS TempUserShiftDetailId

	            ---------------------update TempUserShiftDetail---------------
				     	   UPDATE TempUserShiftDetail
						   SET StatusId = @StatusId,
						       Remarks=@Remarks,
							   LastModifiedBy = @LoginUserId,
							   LastModifiedDate = GETDATE() WHERE TempUserShiftDetailId = @RequestId
                
				                SET @TempUserShiftId = ( SELECT TempUserShiftId FROM TempUserShiftDetail
						                                          WHERE TempUserShiftDetailId = @RequestId)

                                SET  @Count = (SELECT Count(TempUserShiftDetailId) FROM TempUserShiftDetail
						                                     WHERE TempUserShiftId = @TempUserShiftId  AND StatusId = @StatusId)

                                SET  @ActualCOunt =  (SELECT Count(TempUserShiftDetailId) FROM TempUserShiftDetail
						                                     WHERE TempUserShiftId = @TempUserShiftId)
                                    IF (@ActualCount = @Count)
									BEGIN
									  -------------------update TempUserShift---------------
										  UPDATE TempUserShift 
										  SET StatusId = @StatusId,
											   ApproverId = NULL,
											   LastModifiedBy = @LoginUserId,
											   LastModifiedDate = GETDATE() WHERE TempUserShiftId = @TempUserShiftId

									  ----------------------Insert into TempUserShiftHistory--------
			                     	           INSERT INTO TempUserShiftHistory (TempUserShiftId, Remarks,StatusId,CreatedBy)
		   	                                   VALUES( @TempUserShiftId, @Remarks, @StatusId, @LoginUserId)
								    END
				  END
		END
		 ELSE IF(@StatusCode='AP')
		 BEGIN   
				SET @StatusId = (SELECT StatusId FROM OutingRequestStatus WHERE StatusCode='AP')
                                    --@RequestId AS TempUserShiftId

			   ---------------------update TempUserShift---------------      
			           SET @UserId  = (SELECT [UserId] FROM TempUserShift WHERE TempUserShiftId = @RequestId)
						UPDATE TempUserShift 
						   SET StatusId = @StatusId,
							   ApproverId = null,	
							   LastModifiedBy = @LoginUserId,
							   LastModifiedDate = GETDATE() WHERE TempUserShiftId = @RequestId
	  
			  ----------------------update TempUserShiftDetail---------------

						UPDATE TempUserShiftDetail
						   SET StatusId =@StatusId,
						       Remarks=@Remarks,
							   LastModifiedBy = @LoginUserId,
							   LastModifiedDate = GETDATE() WHERE TempUserShiftId = @RequestId AND StatusId=2

				----------------------Insert into TempUserShiftHistory--------
						INSERT INTO TempUserShiftHistory (TempUserShiftId, Remarks,StatusId,CreatedBy)
		   				VALUES( @RequestId, @Remarks, @StatusId, @LoginUserId)
         
	         	----------------------Insert into UserShiftMapping--------
                                INSERT INTO UserShiftMapping(DateId, UserId, ShiftId, IsActive, IsDeleted ,CreatedDate,
								                                           CreatedBy,LastModifiedDate, LastModifiedBy)
								SELECT DateId, TS.UserId, 3, 1, 0, TSD.CreatedDate, TSD.CreatedBy, TSD.LastModifiedDate, TSD.LastModifiedBy
								FROM TempUserShiftDetail TSD JOIN TempUserShift TS ON TSD.TempUserShiftId=TS.TempUserShiftId
								WHERE TSD.TempUserShiftId = @RequestId AND TSD.StatusId = @StatusId 
	    END 

	    SET @Success=1;

	   COMMIT;

 END TRY
 BEGIN CATCH
  IF(@@TRANCOUNT>0)
  SET @Success=0;

   DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
	 --Log Error
	 EXEC [spInsertErrorLog]
			 @ModuleName = 'LNSA'
			,@Source = 'Proc_TakeActionOnMapLnsaShift'
			,@ErrorMessage = @ErrorMessage
			,@ErrorType = 'SP'
			,@ReportedByUserId = @LoginUserId
 END CATCH

 --select * from errorlog order by 1 desc
   


GO
/****** Object:  StoredProcedure [dbo].[Proc_TakeActionOnOutingRequest]    Script Date: 09-08-2018 18:45:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TakeActionOnOutingRequest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_TakeActionOnOutingRequest] AS' 
END
GO
/***
--Created Date      : 2018-03-21
--Created By        : Kanchan Kumari
--Description       : To approve/reject/cancel outing request
--Usage		        :

DECLARE @Result INT
EXEC [Proc_TakeActionOnOutingRequest]
	  @OutingRequestId =11,
	  @StatusCode='VD',
	  @Remarks='OK',
	  @LoginUserId=2153,
	  @LoginUserType='HR',
	  @OutingRequestDetailId=0,
	  @Success=@Result output
SELECT @Result As [RESULT]
***/
ALTER PROC [dbo].[Proc_TakeActionOnOutingRequest]
@OutingRequestId BIGINT,
@StatusCode VARCHAR(20),
@Remarks VARCHAR(500) = NULL,
@LoginUserId BIGINT,
@LoginUserType VARCHAR(200) = NULL,
@OutingRequestDetailId BIGINT=NULL,
@Success TINYINT = 0 Output
AS
BEGIN TRY
BEGIN TRAN

	DECLARE @StatusId INT, @StatusIdNew INT, @EmployeeId BIGINT,@FirstReportingId BIGINT , @SecondReportingId BIGINT, @HRId BIGINT,@DepartmentHeadId BIGINT ,@HRHeadId INT=2166
	DECLARE @count INT,@FromDateId INT,@TillDateId INT,@CountDate INT=0,@StatusIdForHR INT
	SELECT @EmployeeId=[UserId] FROM [dbo].[OutingRequest] WITH (NOLOCK) WHERE [OutingRequestId]=@OutingRequestId
	SET @SecondReportingId= (SELECT [dbo].[fnGetSecondReportingManagerByUserId](@EmployeeId))
	SET @HRId=(SELECT [dbo].[fnGetHRIdByUserId](@EmployeeId))
	SET @FirstReportingId=(SELECT [dbo].[fnGetReportingManagerByUserId](@EmployeeId))
	SET @DepartmentHeadId= (SELECT [dbo].[fnGetDepartmentHeadIdByUserId](@EmployeeId))
		SET @StatusIdForHR=(SELECT [StatusId] FROM [dbo].[OutingRequest] WITH (NOLOCK) WHERE OutingRequestId=@OutingRequestId)

		IF(@StatusCode = 'VD' AND @LoginUserId != @HRHeadId)
		SET @StatusCode = 'AP'

		IF(@StatusCode = 'VD' AND @LoginUserId = @HRHeadId AND @StatusIdForHR = 2)
		SET @StatusCode = 'AP'

		SELECT @StatusId = [StatusId] FROM [dbo].[OutingRequestStatus] WITH (NOLOCK) WHERE [StatusCode]=@StatusCode

	WHILE(@FromDateId<=@TillDateId)
	BEGIN
		SET @CountDate=@CountDate+1
		SET @FromDateId=@FromDateId+1
	END
	--Cancel by user it self
	IF(@LoginUserId=@EmployeeId AND @StatusCode='CA' AND @Remarks='Cancel')
	BEGIN
		 UPDATE OutingRequestDetail SET StatusId=@StatusId ,ModifiedById=@LoginUserId ,ModifiedDate=GETDATE()
		 WHERE  OutingRequestDetailId=@OutingRequestDetailId  
		 SET @count=(SELECT Count(DateId) From OutingRequestDetail Where StatusId=8 
	              group by OutingRequestId having OutingRequestId=@OutingRequestId)
			SET @FromDateId=(SELECT FromDateId from OutingRequest where OutingRequestId=@OutingRequestId)
			SET @TillDateId=(SELECT TillDateId from OutingRequest where OutingRequestId=@OutingRequestId)
				WHILE(@FromDateId<=@TillDateId)
				BEGIN
					SET @CountDate=@CountDate+1
					SET @FromDateId=@FromDateId+1
				END

		IF(@Count=@CountDate)
		 BEGIN
			INSERT INTO OutingRequestHistory(OutingRequestId,StatusId,Remarks,CreatedById)
			SELECT @OutingRequestId, @StatusId AS StatusId,'Cancelled' AS Remarks, @LoginUserId
			UPDATE OutingRequest SET StatusId=@StatusId, NextApproverId=NULL, ModifiedById=@LoginUserId, ModifiedDate=GETDATE()
			WHERE OutingRequestId=@OutingRequestId
         END
		
	END
	--Cancel All request by User and HR
	ELSE IF((@LoginUserId=@EmployeeId OR @LoginUserId=@HRId) AND @StatusCode='CA' AND @Remarks='CancelAll')
	BEGIN
		 UPDATE OutingRequestDetail SET StatusId=@StatusId ,ModifiedById=@LoginUserId, ModifiedDate=GETDATE()
		 WHERE  OutingRequestId=@OutingRequestId 
		 SET @count=(SELECT Count(DateId) From OutingRequestDetail Where StatusId=8 
	              group by OutingRequestId having OutingRequestId=@OutingRequestId)
			SET @FromDateId=(SELECT FromDateId from OutingRequest where OutingRequestId=@OutingRequestId)
			SET @TillDateId=(SELECT TillDateId from OutingRequest where OutingRequestId=@OutingRequestId)
				WHILE(@FromDateId<=@TillDateId)
				BEGIN
					SET @CountDate=@CountDate+1
					SET @FromDateId=@FromDateId+1
				END

		IF(@Count=@CountDate)
		 BEGIN
			INSERT INTO OutingRequestHistory(OutingRequestId,StatusId,Remarks,CreatedById)
			SELECT @OutingRequestId, @StatusId AS StatusId,'Cancelled' AS Remarks, @LoginUserId
			UPDATE OutingRequest SET StatusId=@StatusId, NextApproverId=NULL, ModifiedById=@LoginUserId, ModifiedDate=GETDATE()
			WHERE OutingRequestId=@OutingRequestId
         END
	END
	
	--Approved By first level Manager
	ELSE IF(@StatusCode='AP')
	BEGIN
	     --VM-3, PC-4, AS-2203, AP-2167
		 IF(@LoginUserId=@FirstReportingId)
		 BEGIN

			 IF(@SecondReportingId=0 OR @FirstReportingId = @DepartmentHeadId)
			 BEGIN
			 SET @SecondReportingId=@HRId 
			 SET @StatusIdNew=(SELECT StatusId From OutingRequestStatus where StatusCode='PV')
			 END
			 ELSE
			 BEGIN
			  SET @StatusIdNew=(SELECT StatusId From OutingRequestStatus where StatusCode='PA')
			 END

			INSERT INTO OutingRequestHistory(OutingRequestId,StatusId,Remarks,CreatedById)
			SELECT @OutingRequestId,@StatusId AS StatusId,@Remarks,@LoginUserId
			--update outing Request detail table
			UPDATE OutingRequestDetail SET StatusId=@StatusIdNew, ModifiedById=@LoginUserId,ModifiedDate=GETDATE() 
			WHERE OutingRequestId=@OutingRequestId AND StatusId != 8
			--update Outing Request Table
			UPDATE OutingRequest set NextApproverId=@SecondReportingId,StatusId=@StatusIdNew,ModifiedById=@LoginUserId, ModifiedDate=GETDATE()
			WHERE OutingRequestId=@OutingRequestId
	     END
	   --Approved by Second level Manager
	      ELSE IF(@LoginUserId=@SecondReportingId)
	      BEGIN
			    IF(@DepartmentHeadId=0 OR @SecondReportingId = @DepartmentHeadId)
			    BEGIN
			       SET @DepartmentHeadId=@HRId
			       SET @StatusIdNew=(SELECT StatusId From OutingRequestStatus where StatusCode='PV')
			    END
			    ELSE
			    BEGIN
			      SET @StatusIdNew=(SELECT StatusId From OutingRequestStatus where StatusCode='PA')
			    END

			      INSERT INTO OutingRequestHistory(OutingRequestId,StatusId,Remarks,CreatedById)
			      SELECT @OutingRequestId,@StatusId AS StatusId,@Remarks,@LoginUserId
			      --update outing Request detail table
			      UPDATE OutingRequestDetail SET StatusId=@StatusIdNew, ModifiedById=@LoginUserId,ModifiedDate=GETDATE() 
			      WHERE OutingRequestId=@OutingRequestId AND StatusId != 8
			      --update Outing Request Table
			      UPDATE OutingRequest set StatusId=@StatusIdNew, NextApproverId=@DepartmentHeadId, ModifiedById=@LoginUserId, ModifiedDate=GETDATE()
			      WHERE OutingRequestId=@OutingRequestId
         END
	     --Approved by Department head
			ELSE IF(@LoginUserId=@DepartmentHeadId AND @DepartmentHeadId != @FirstReportingId AND @DepartmentHeadId != @SecondReportingId)
			BEGIN
			   SET @StatusIdNew=(SELECT StatusId From OutingRequestStatus where StatusCode='PV')
			   INSERT INTO OutingRequestHistory(OutingRequestId,StatusId,Remarks,CreatedById)
			   SELECT @OutingRequestId,@StatusId AS StatusId,@Remarks,@LoginUserId
			   --update outing Request detail table
			   UPDATE OutingRequestDetail SET StatusId=@StatusIdNew, ModifiedById=@LoginUserId,ModifiedDate=GETDATE() 
			   WHERE OutingRequestId=@OutingRequestId AND StatusId != 8
			   --update Outing Request Table
			   UPDATE OutingRequest set StatusId=@StatusIdNew, NextApproverId=@HRId, ModifiedById=@LoginUserId, ModifiedDate=GETDATE()
			   WHERE OutingRequestId=@OutingRequestId
		    END
   END
	-- Verififed by HR
	ELSE IF(@StatusCode='VD')
	BEGIN
		INSERT INTO OutingRequestHistory(OutingRequestId,StatusId,Remarks,CreatedById)
		SELECT @OutingRequestId,@StatusId AS StatusId,@Remarks,@LoginUserId
		--update outing Request detail table
		UPDATE OutingRequestDetail SET StatusId=@StatusId, ModifiedById=@LoginUserId,ModifiedDate=GETDATE() 
		WHERE OutingRequestId=@OutingRequestId AND StatusId != 8
		--update Outing Request Table
		UPDATE OutingRequest set StatusId=@StatusId, NextApproverId=NULL, ModifiedById=@LoginUserId, ModifiedDate=GETDATE() 
		WHERE OutingRequestId=@OutingRequestId
	END
	ELSE IF(@StatusCode='RJM' )
	BEGIN
		INSERT INTO OutingRequestHistory(OutingRequestId,StatusId,Remarks,CreatedById)
		SELECT @OutingRequestId,@StatusId AS StatusId,@Remarks,@LoginUserId
		--update outing Request detail table
		UPDATE OutingRequestDetail SET StatusId=@StatusId, ModifiedById=@LoginUserId,ModifiedDate=GETDATE() 
		WHERE OutingRequestId=@OutingRequestId AND StatusId != 8
		--update Outing Request Table
		UPDATE OutingRequest set StatusId=@StatusId, NextApproverId=NULL, ModifiedById=@LoginUserId, ModifiedDate=GETDATE()
		WHERE OutingRequestId=@OutingRequestId
	END
	--Rejected by HR
	ELSE IF(@StatusCode='RJH' )
	BEGIN
		INSERT INTO OutingRequestHistory(OutingRequestId,StatusId,Remarks,CreatedById)
		SELECT @OutingRequestId,@StatusId AS StatusId,@Remarks,@LoginUserId
		--update outing Request detail table
		UPDATE OutingRequestDetail SET StatusId=@StatusId, ModifiedById=@LoginUserId,ModifiedDate=GETDATE() 
		WHERE OutingRequestId=@OutingRequestId AND StatusId != 8
		--update Outing Request Table
		UPDATE OutingRequest set StatusId=@StatusId, NextApproverId=NULL, ModifiedById=@LoginUserId, ModifiedDate=GETDATE()
		WHERE OutingRequestId=@OutingRequestId
	END
	SET @Success=1
	COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0
SET @Success=0
	ROLLBACK TRANSACTION
	DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
        EXEC [spInsertErrorLog]
	        @ModuleName = 'LeaveManagement'
        ,@Source = '[Proc_TakeActionOnOutingRequest]'
        ,@ErrorMessage = @ErrorMessage
        ,@ErrorType = 'SP'
        ,@ReportedByUserId = @LoginUserId
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[spApplyLeave]    Script Date: 09-08-2018 18:45:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spApplyLeave]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spApplyLeave] AS' 
END
GO
/***
   Created Date      :     2017-01-12
   Created By        :     Shubhra Upadhyay
   Purpose           :     This stored procedure Apply New Leave
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   
   --------------------------------------------------------------------------

   Test Cases        :
   --------------------------------------------------------------------------
   
   --- Test Case 1
       DECLARE @Result [INT]
         EXEC  [dbo].[spApplyLeave]
             @EmployeeId = 2203
            ,@LoginUserId = 2203
            ,@FromDate = '2018-08-12'
            ,@TillDate = '2018-08-16'
            ,@Reason = 'testing'
            ,@LeaveCombination= '2 COFF + 1PL'
            ,@PrimaryContactNo = '223344244'
            ,@AlternateContactNo = '2233443322'
            ,@IsAvailableOnMobile = 0
            ,@IsAvailableOnEmail = 0
            ,@IsFirstDayHalfDay = 0
            ,@IsLastDayHalfDay = 0
			,@Success=@Result output
			SELECT @Result AS [RESULT]
select * from errorlog order by 1 desc

***/
 ALTER PROCEDURE [dbo].[spApplyLeave]
   (
       @EmployeeId [int]
      ,@LoginUserId [int]
      ,@FromDate [date]
      ,@TillDate [date]
      ,@Reason [varchar](500)
      ,@LeaveCombination [varchar](100)
      ,@PrimaryContactNo [varchar](15)
      ,@AlternateContactNo [varchar](15)
      ,@IsAvailableOnMobile [bit]
      ,@IsAvailableOnEmail [bit]
      ,@IsFirstDayHalfDay [bit]
      ,@IsLastDayHalfDay [bit]
       ,@Success [tinyint] output
      
      --@FromDateId bigint, @TillDateId bigint, @LeaveTypeId int, @StatusId int, @LwpId int, @LoopCount float ,@TotalCount float, @Date date
   )
   AS
BEGIN TRY
      SET NOCOUNT ON;  
      SET FMTONLY OFF;
	 IF OBJECT_ID('tempdb..#TempCoffAvailed') IS NOT NULL
     DROP TABLE #TempCoffAvailed 

	  IF OBJECT_ID('tempdb..#TempLeaveComb') IS NOT NULL
      DROP TABLE #TempLeaveComb
	  
	  CREATE TABLE #TempLeaveComb(
                            [Id] int IDENTITY(1, 1)
                           ,[LeaveCount] float NOT NULL
                           ,[LeaveType] varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL
						   ,[LeaveTypeId] INT 
                        )

	                SELECT * INTO #Combination FROM [dbo].[fnSplitWord](@LeaveCombination, '+')

	                DECLARE @Temp int = 1, @CoffCount INT
				
                    WHILE(@Temp <= (SELECT COUNT(*) FROM #Combination))
                    BEGIN
                        INSERT INTO #TempLeaveComb([LeaveCount], [LeaveType])
                        SELECT (SELECT [Character] FROM [dbo].[fnSplitWord](C.[Character], ' ') WHERE [Id] = 1)
                                ,(SELECT [Character] FROM [dbo].[fnSplitWord](C.[Character], ' ') WHERE [Id] = 2)
                        FROM #Combination C 
                        WHERE C.[Id] = @Temp
						        --set leaveTypeId
                        UPDATE T
                        SET T.[LeaveTypeId] = M.[TypeId]
                        FROM #TempLeaveComb T
                        INNER JOIN [dbo].[LeaveTypeMaster] M WITH (NOLOCK)
                            ON T.[LeaveType] = M.[ShortName]

						SET @Temp = @Temp+1
					END
	    SELECT @CoffCount = [LeaveCount] FROM #TempLeaveComb WHERE LeaveTypeId = 4 -- coff count to be applied
			
	 DECLARE @PreviousMonthLastDate date = (SELECT DATEADD(DAY, -1, DATEADD(DAY, 1 - DAY(@FromDate ), @FromDate ))) 

	 IF(@LeaveCombination LIKE '%COFF%' AND (SELECT count(RequestId) From RequestCompOff where IsLapsed=0 AND StatusId>2 
	                   AND IsAvailed=0 AND CreatedBy=@EmployeeId AND LapseDate>@PreviousMonthLastDate) < @CoffCount)
	  BEGIN
		SET @Success=6--no valid compoff
	  END
	  ELSE
	  BEGIN
	      
         --DECLARE @LeaveCombo varchar(50) = '1CL + 1LWP';
         --split leave combination and     
         --DROP TABLE #TempDays
         CREATE TABLE #TempDays(
             [Status] varchar(5)
            ,[TotalDays] float
            ,[WorkingDays] float 
         )
         --DECLARE @FromDate [date] = '2016-04-13', @TillDate [date] = '2016-04-14', @EmployeeId [int] = 84; --to be deleted
         INSERT INTO #TempDays
         EXEC spGetTotalWorkingDays @Fromdate = @FromDate, @ToDate = @TillDate, @UserId = @EmployeeId, @LeaveApplicationId = 0
         --SELECT * FROM #TempDays
      
         IF((SELECT [Status] FROM #TempDays) = 'NA')
         BEGIN
            --SET @Status =  1 --date collision
            SET @Success=1
         END
         ELSE
         BEGIN
            --DECLARE @IsFirstDayHalfDay [bit] = 0, @IsLastDayHalfDay [bit] = 0, @EmployeeId [int] = 84; --to be deleted
            DECLARE @NoOfWorkingDays [float] = (SELECT [WorkingDays] FROM #TempDays)
                   ,@NoOfTotalDays [float] = (SELECT [TotalDays] FROM #TempDays)
                 
            IF(@IsFirstDayHalfDay = 1)
            BEGIN
               SET @NoOfWorkingDays = @NoOfWorkingDays - 0.5
            END
            IF(@IsLastDayHalfDay = 1)
            BEGIN
               SET @NoOfWorkingDays = @NoOfWorkingDays - 0.5
            END
         
        CREATE TABLE #TempLeaveCombination(
             [LeaveCombination] varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL
            )
            INSERT INTO #TempLeaveCombination
            EXEC spGetAvailableLeaveCombination @NoOfWorkingDays = @NoOfWorkingDays, @UserId = @EmployeeId, @LeaveApplicationId = 0
            --SELECT * FROM #TempLeaveCombination
            --DROP TABLE #TempLeaveCombination
            IF((SELECT COUNT(*) FROM #TempLeaveCombination) > 0)
            BEGIN
               --DECLARE @LeaveCombination varchar(50) = '1 COFF + 1 LWP' --to be deleted
               IF((SELECT COUNT(*) from #TempLeaveCombination WHERE [LeaveCombination] = @LeaveCombination) > 0)
               BEGIN
               --success logic goes here
     BEGIN TRANSACTION
                     
                     DECLARE @FromDateId Bigint ,@TillDateId bigint;
                     SELECT 
                         @FromDateId = MIN(DM.[DateId])
                        ,@TillDateId = MAX(DM.[DateId])
                     FROM 
                        [dbo].[DateMaster] DM WITH (NOLOCK)
                     WHERE 
                        DM.[Date] BETWEEN  @FromDate	AND  @TillDate

---------------------------------------Insert into LeaveRequestApplication starts---------------------------------------
                        
                        DECLARE @ApproverId int
                              ,@StatusId int = 1
                              ,@ReportingManagerId int = (SELECT [dbo].[fnGetReportingManagerByUserId](@EmployeeId))
                              ,@HRId int = (SELECT [dbo].[fnGetHRIdByUserId](@EmployeeId));

                        SET @ApproverId = @ReportingManagerId
                        IF(@ReportingManagerId = 0 OR @ReportingManagerId = @HRId)
                        BEGIN
                           SET @ApproverId = @HRId;
                           SET @StatusId = (SELECT [StatusId] FROM [dbo].[LeaveStatusMaster] WHERE [StatusCode] = 'PV')
                        END
                        INSERT INTO [dbo].[LeaveRequestApplication] 
                        ([UserId],[FromDateId],[TillDateId],[NoOfTotalDays],[NoOfWorkingDays],[Reason],[PrimaryContactNo],
						 [IsAvailableOnMobile],[IsAvailableOnEmail],[StatusId],[ApproverId],[CreatedBy],[AlternativeContactNo],[LeaveCombination])
                        SELECT @EmployeeId,@FromDateId, @TillDateId, @NoOfTotalDays,@NoOfWorkingDays,@Reason,@PrimaryContactNo
                           ,@IsAvailableOnMobile,@IsAvailableOnEmail,@StatusId,@ApproverId,@LoginUserId,@AlternateContactNo,@LeaveCombination
                        --FROM
                        --   [dbo].[UserDetail] U  WITH (NOLOCK)
                        --WHERE U.UserId = @EmployeeId 
                        --AND U.[IsDeleted] = 0 
                        --AND U.[TerminateDate] IS NULL

---------------------------------------Insert into LeaveRequestApplication ends---------------------------------------
                        
                        DECLARE @LeaveRequestApplicationId [bigint]
                        SET @LeaveRequestApplicationId = SCOPE_IDENTITY() 

               
                     DECLARE @NoOfLeavesInCombination int, @IsLWP [bit], @LeaveType [varchar](10), @LeaveCount [float]
                        CREATE TABLE #TempLeaveDetail(
                            [Id] int IDENTITY(1, 1)
                           ,[LeaveCount] float
                           ,[LeaveType] varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL
                           ,[LeaveTypeId] int
                        )
                  
       
---------------------------------------Insert into LeaveRequestApplicationDetail starts---------------------------------------
		               
                       
					    DECLARE @Count int = 1, @LastLeaveDateId bigint = 0, @IsHalfDay bit = 0
                        WHILE(@Count <= (SELECT COUNT(*) FROM #Combination))
                        BEGIN
                            INSERT INTO #TempLeaveDetail([LeaveCount], [LeaveType])
                           SELECT  (SELECT [Character] FROM [dbo].[fnSplitWord](C.[Character], ' ') WHERE [Id] = 1)
                                  ,(SELECT [Character] FROM [dbo].[fnSplitWord](C.[Character], ' ') WHERE [Id] = 2)
                           FROM #Combination C 
                           WHERE C.[Id] = @Count
                     
                           --set leaveTypeId
                           UPDATE T
                           SET T.[LeaveTypeId] = M.[TypeId]
                           FROM #TempLeaveDetail T
                           INNER JOIN [dbo].[LeaveTypeMaster] M WITH (NOLOCK)
                              ON T.[LeaveType] = M.[ShortName]
                        

                           INSERT INTO [dbo].[LeaveRequestApplicationDetail] 
                           SELECT @LeaveRequestApplicationId, T.[LeaveTypeId], T.[LeaveCount]
                           FROM #TempLeaveDetail T
                           WHERE T.[Id] = @Count

                           --fetch dateid
                           SET @Count = @Count + 1
                        END 
---------------------------------------Insert into LeaveRequestApplicationDetail ends----------------------------------

---------------------------------------Insert into [RequestCompOffDetail] starts---------------------------------------
                   IF(@LeaveCombination  LIKE '%COFF%')
				   BEGIN

				    CREATE TABLE #TempCoffAvailed(
					Id INT IDENTITY(1,1),
					RequestId INT,
					LapseDate DATE
					)
                   DECLARE @AvailedRequestId INT,@LapseDateToBeAvailed DATE, @J INT = 1

                   INSERT INTO #TempCoffAvailed(RequestId,LapseDate) 
				   SELECT TOP (@CoffCount) RequestId,LapseDate FROM RequestCompOff
		                     WHERE IsLapsed=0 AND StatusId>2 AND IsAvailed=0 AND CreatedBy=@EmployeeId 
							 AND LapseDate>@PreviousMonthLastDate ORDER BY LapseDate ASC,RequestId ASC

                        WHILE(@J<=(SELECT COUNT(Id) FROM #TempCoffAvailed))
						BEGIN
								SET @LapseDateToBeAvailed=(SELECT LapseDate FROM #TempCoffAvailed WHERE Id=@J)
								SET @AvailedRequestId=(SELECT RequestId FROM #TempCoffAvailed WHERE Id=@J)

							   INSERT INTO [dbo].[RequestCompOffDetail](RequestId,LeaveRequestApplicationId,CreatedById)
								   VALUES( @AvailedRequestId, @LeaveRequestApplicationId, @EmployeeId )

							   UPDATE [dbo].[RequestCompOff] 
							   SET [IsAvailed] = 1 
							   WHERE [RequestId]= @AvailedRequestId 
							   SET @J = @J + 1
						END

                   END
---------------------------------------Insert into [RequestCompOffDetail] ends---------------------------------------


---------------------------------------Insert into LeaveHistory table starts---------------------------------------
						
                        INSERT INTO [dbo].[LeaveHistory]
                        (
                            [LeaveRequestApplicationId]
                           ,[StatusId]
                           ,[ApproverId]
                           ,[ApproverRemarks]
                           ,[CreatedBy]
                        )
                        SELECT
                           @LeaveRequestApplicationId
                          ,@StatusId
                          ,@ApproverId
                          ,'Applied'
                          ,@EmployeeId
---------------------------------------Insert into LeaveHistory table ends---------------------------------------

---------------------------------------Insert into DateWiseLeaveType table starts---------------------------------------

                        DECLARE @StartDateId bigint = (SELECT [dbo].[fnGetNextDateId](@FromDateId-1))
                        WHILE (@StartDateId <= @TillDateId)
                        BEGIN
                           PRINT 'Enter outer most while loop : @StartDateId - ' + CAST(@StartDateId as VARCHAR) + ' @TillDateId - ' + CAST(@TillDateId as VARCHAR)
         DECLARE @TotalNoOfLeavesCounter float = (SELECT SUM([LeaveCount]) FROM #TempLeaveDetail)
                                 ,@TotalNoOfDays int = (@TillDateId - @FromDateId) + 1
                                 ,@NoOfTypeOfLeaves int = (SELECT COUNT(*) FROM #TempLeaveDetail)
                                 ,@DateWiseLeaveCounter int = 1
                                 ,@TempDateWiseLeaveCounter int
                                 ,@LoopCount float
                           --IF(@TotalNoOfLeavesCounter = @TotalNoOfDays)--ie no half days are present
                           IF(@IsFirstDayHalfDay = 0 AND @IsLastDayHalfDay = 0)--ie no half days are present
                           BEGIN
                              PRINT 'Enter If condition - no half days are present'
                              WHILE(@DateWiseLeaveCounter <= @NoOfTypeOfLeaves) --while loop from 1 till number of type leaves present
                              BEGIN
                                 SET @LoopCount = (SELECT [LeaveCount] FROM #TempLeaveDetail WHERE [Id] = @DateWiseLeaveCounter)
                                 SET @TempDateWiseLeaveCounter = 1
                                 WHILE(@TempDateWiseLeaveCounter <= CEILING(@LoopCount))--while loop individual leave wise
                                 BEGIN
                                    IF(@LoopCount = CEILING(@LoopCount))--leave count is whole number
                                    BEGIN
                                       INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay])
                                       SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 0
                                       FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                       --SET @StartDateId = @StartDateId + 1
                                       SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                    END
                                    ELSE--leave count is fractional
                                    BEGIN
                                       DECLARE @CheckPreviousData float = (SELECT SUM([LeaveCount]) FROM #TempLeaveDetail WHERE [Id] < @DateWiseLeaveCounter)

                                       IF(@CheckPreviousData = CEILING(@CheckPreviousData) OR @CheckPreviousData IS NULL)
                                       BEGIN
                                          IF(@TempDateWiseLeaveCounter = CEILING(@LoopCount))
                                          BEGIN
                                             print 'y'
                                             INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay], [IsLastDayHalfDay])
                                             SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 1, 1
                                             FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                          END
                                          ELSE
                                          BEGIN
                                             print 'z'
                                             INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay])
                                             SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 0
                                             FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                        PRINT 'Increase startdate 6'
                                             --SET @StartDateId = @StartDateId + 1
                                             SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                          END
                  END
                       ELSE
                                       BEGIN
                                          IF(@TempDateWiseLeaveCounter = 1)
                                          BEGIN
                                          INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay], [IsFirstDayHalfDay])
                                          SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 1, 1
                                          FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                          PRINT 'Increase startdate 5'
                                          --SET @StartDateId = @StartDateId + 1
                                          SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                 END
                                          ELSE
                                          BEGIN
                                             print 'a'
                                             INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay])
                                             SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 0
                                             FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                             PRINT 'Increase startdate 4'
                                             --SET @StartDateId = @StartDateId + 1
                                             SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                          END
                              END
                                    END
                                    SET @TempDateWiseLeaveCounter = @TempDateWiseLeaveCounter + 1
                                 END
                                 SET @DateWiseLeaveCounter = @DateWiseLeaveCounter + 1
                              END
                           END
                           ELSE--logic to handle half days
                           BEGIN 
                              DECLARE @LeaveDaysDiff float = @TotalNoOfDays - @TotalNoOfLeavesCounter
                              IF(@IsFirstDayHalfDay = 1 AND @IsLastDayHalfDay = 1) --both firstday and lastday are marked as half day leave
                              BEGIN
                                 PRINT 'Enter condition - both half days are present'
                                 PRINT 'Enter data for - @StartDateId = @FromDateId'
                                 INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay], [IsLastDayHalfDay])
                                 SELECT @LeaveRequestApplicationId, @FromDateId, T.[LeaveTypeId], 1, 1
              FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                 PRINT 'Increase startdate 3'
                                 --SET @StartDateId = @StartDateId + 1
                                 SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                 WHILE(@DateWiseLeaveCounter <= @NoOfTypeOfLeaves) --while loop from 1 till number of type leaves present
                                 BEGIN         
                                    SET @LoopCount = (SELECT [LeaveCount] FROM #TempLeaveDetail WHERE [Id] = @DateWiseLeaveCounter)
                                    SET @TempDateWiseLeaveCounter = 1
                WHILE(@TempDateWiseLeaveCounter <= CEILING(@LoopCount))--while loop individual leave wise CEILING(@LoopCount)
                                    BEGIN               
               IF(@StartDateId > @FromDateId AND @StartDateId < @TillDateId)
                                       BEGIN
                                          IF(@LoopCount = CEILING(@LoopCount)) --leave count is whole number
                                          BEGIN
                                             BEGIN
                                                DECLARE @CheckPreviousData1 float = (SELECT SUM([LeaveCount]) FROM #TempLeaveDetail WHERE [Id] < @DateWiseLeaveCounter)
                     
                                                IF(@CheckPreviousData1 != CEILING(@CheckPreviousData1) OR @CheckPreviousData1 IS NULL)
                                                BEGIN
                                                   IF(@TempDateWiseLeaveCounter = CEILING(@LoopCount))
                                                   BEGIN
                                                      print 'y'
                                                      INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay], [IsLastDayHalfDay])
                                                      SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 1, 1
                                                      FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                                   END
                                                   ELSE
                                                   BEGIN
                                                      print 'z'
                                                      INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay])
                                                      SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 0
                                                      FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                                      PRINT 'Increase startdate 6'
                                                      --SET @StartDateId = @StartDateId + 1
                                                      SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                                   END
                                                END
                                                ELSE
                                                BEGIN
                                                   IF(@TempDateWiseLeaveCounter = 1)
                                                   BEGIN
                                                      INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay], [IsFirstDayHalfDay])
                                                      SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 1, 1
                                                      FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                   PRINT 'Increase startdate 5'
                                                      --SET @StartDateId = @StartDateId + 1
                                                      SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                                   END
                                                   ELSE
                                                   BEGIN
                                                      print 'a'
                                                      INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay])
            SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 0
                                                      FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                     PRINT 'Increase startdate 4'
                                                      --SET @StartDateId = @StartDateId + 1
                                                      SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                          END
                                                END
                                             END
                                          END
                                          ELSE  --leave count is fractional
                                          BEGIN
                                             IF(@TempDateWiseLeaveCounter = 1)
              BEGIN
                                                SET @TempDateWiseLeaveCounter = @TempDateWiseLeaveCounter + 1
                                             END                     
                                             IF(@TempDateWiseLeaveCounter <= CEILING(@LoopCount))
                                             BEGIN
                                                INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay])
                                                SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 0
                                                FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                                PRINT 'Increase startdate 3.2'
                                                --SET @StartDateId = @StartDateId + 1
                                                SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                             END
                                          END
                               END
                                       print '@TempDateWiseLeaveCounter: ' + cast(@TempDateWiseLeaveCounter as varchar(10)) 
                                       SET @TempDateWiseLeaveCounter = @TempDateWiseLeaveCounter + 1
                                    END
                                    SET @DateWiseLeaveCounter = @DateWiseLeaveCounter + 1
                                 END
                                    PRINT 'Enter data for - @StartDateId =  @TillDateId'
                                    INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay], [IsFirstDayHalfDay])
                                    SELECT @LeaveRequestApplicationId, @TillDateId, T.[LeaveTypeId], 1, 1
                                    FROM #TempLeaveDetail T WHERE [Id] = (@DateWiseLeaveCounter-1)
                                    PRINT 'Increase startdate 3.1'
                                    --SET @StartDateId = @StartDateId + 1
                                    SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                              END
                              ELSE--this means either firstday or lastday are marked as half day
                              BEGIN
                                 IF(@IsFirstDayHalfDay = 1)--firstday marked as half day
                                 BEGIN
                                    PRINT 'Enter condition - first day half day'

                                    PRINT 'Enter data for - @StartDateId = @FromDateId'
                                    INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay], [IsFirstDayHalfDay])
                                    SELECT @LeaveRequestApplicationId, @FromDateId, T.[LeaveTypeId], 1, 1
                                    FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                    PRINT 'Increase startdate 3'
                                    --SET @StartDateId = @StartDateId + 1
                   SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                    WHILE(@DateWiseLeaveCounter <= @NoOfTypeOfLeaves) --while loop from 1 till number of type leaves present
                                    BEGIN         
                                       SET @LoopCount = (SELECT [LeaveCount] FROM #TempLeaveDetail WHERE [Id] = @DateWiseLeaveCounter)
                                       SET @TempDateWiseLeaveCounter = 1
                                       WHILE(@TempDateWiseLeaveCounter <= CEILING(@LoopCount))--while loop individual leave wise
                                       BEGIN               
                                          IF(@StartDateId > @FromDateId AND @StartDateId <= @TillDateId)
                                          BEGIN
                                             IF(@LoopCount = CEILING(@LoopCount)) --leave count is whole number
                                             BEGIN
                                         BEGIN
                                                   DECLARE @CheckPreviousData2 float = (SELECT SUM([LeaveCount]) FROM #TempLeaveDetail WHERE [Id] < @DateWiseLeaveCounter)
                        
                                                   IF(@CheckPreviousData2 = CEILING(@CheckPreviousData) OR @CheckPreviousData2 IS NULL)
                                                   BEGIN
                                                      IF(@TempDateWiseLeaveCounter = CEILING(@LoopCount))
                                                      BEGIN
                                                         print 'y'
                                                         INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay], [IsFirstDayHalfDay])
                                                         SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 1, 1
                                                         FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                                      END
                                                      ELSE
                                                      BEGIN
                                                         print 'z'
                                                         INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay])
                                                         SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 0
                                                         FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                                         PRINT 'Increase startdate 6'
                                                         --SET @StartDateId = @StartDateId + 1
                                                         SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                                      END
                                                   END
                                             ELSE
                                                   BEGIN
                                                      INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay])
                                                      SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 0
                                                      FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                                      PRINT 'Increase startdate 4'
                                                      --SET @StartDateId = @StartDateId + 1
    SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                             END
                                                END
                                             END
                                             ELSE  --leave count is fractional
                                             BEGIN
                                                DECLARE @TempCheckPreviousData float = (SELECT SUM([LeaveCount]) FROM #TempLeaveDetail WHERE [Id] < @DateWiseLeaveCounter) 
                                                IF(@TempCheckPreviousData IS NULL)
                                                BEGIN
                                                   IF(@TempDateWiseLeaveCounter = 1)
                                                   BEGIN
                                                      SET @TempDateWiseLeaveCounter = @TempDateWiseLeaveCounter + 1
                                                   END
                                                   IF(@TempDateWiseLeaveCounter <= CEILING(@LoopCount))
                                                   BEGIN
                                                      INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay])
                                                      SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 0
                                                      FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                                      PRINT 'Increase startdate 3.2'
                                                      --SET @StartDateId = @StartDateId + 1
                                                      SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                                   END
                      END
                                                ELSE
                                                BEGIN
                                                   IF(@TempDateWiseLeaveCounter = 1)
                                                   BEGIN
                                                      INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay], [IsLastDayHalfDay])
                                                      SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 1, 1
                                                      FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                                      PRINT 'Increase startdate 3.3'
                                                      --SET @StartDateId = @StartDateId + 1
                                                      SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                                   END                     
                                                   ELSE
                                                   BEGIN
                                                      INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay])
                                                      SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 0
                                                      FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                                      PRINT 'Increase startdate 3.2'
                                                      --SET @StartDateId = @StartDateId + 1
                                                      SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                                   END
                                                END
                  END
                                          END
           print '@TempDateWiseLeaveCounter: ' + cast(@TempDateWiseLeaveCounter as varchar(10)) 
                                          SET @TempDateWiseLeaveCounter = @TempDateWiseLeaveCounter + 1
                                       END
                                       SET @DateWiseLeaveCounter = @DateWiseLeaveCounter + 1
                                    END
                                 END
                                 ELSE IF(@IsLastDayHalfDay = 1)--lastday marked as half day
                 BEGIN
                                    PRINT 'Enter condition - last day half day'
                                    WHILE(@DateWiseLeaveCounter <= @NoOfTypeOfLeaves) --while loop from 1 till number of type leaves present
                                    BEGIN
                                       SET @LoopCount = (SELECT [LeaveCount] FROM #TempLeaveDetail WHERE [Id] = @DateWiseLeaveCounter)
                                       SET @TempDateWiseLeaveCounter = 1
                       WHILE(@TempDateWiseLeaveCounter <= CEILING(@LoopCount))--while loop individual leave wise
                                       BEGIN               
                                          IF(@StartDateId >= @FromDateId AND @StartDateId < @TillDateId)
                                          BEGIN
                                             IF(@LoopCount = CEILING(@LoopCount)) --leave count is whole number
                                             BEGIN
                                                DECLARE @CheckPreviousData3 float = (SELECT SUM([LeaveCount]) FROM #TempLeaveDetail WHERE [Id] < @DateWiseLeaveCounter)
                        
                                                IF(@CheckPreviousData3 IS NULL)
                                                BEGIN
                                                INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay])
                                                   SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 0
                                                   FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                                   PRINT 'Increase startdate 6'
                                                   --SET @StartDateId = @StartDateId + 1
                                                   SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                                END
                                                ELSE
                                                BEGIN
                                                   IF(@TempDateWiseLeaveCounter = 1)
                                                   BEGIN
                                                         INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay], [IsLastDayHalfDay])
                                                         SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 1, 1
                                                         FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                                         PRINT 'Increase startdate 3.5'
                                                         --SET @StartDateId = @StartDateId + 1
                                                         SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                                   END
                                                   ELSE
                                                   BEGIN
                                                      INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay])
                                                      SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 0
                                     FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                                      PRINT 'Increase startdate 4'
                                                      --SET @StartDateId = @StartDateId + 1
                                                      SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                                   END
                                    END
                                   END
                                             ELSE  --leave count is fractional
                                             BEGIN
                                                DECLARE @TempCheckPreviousData1 float = (SELECT SUM([LeaveCount]) FROM #TempLeaveDetail WHERE [Id] < @DateWiseLeaveCounter) 
   IF(@TempCheckPreviousData1 IS NULL OR @TempCheckPreviousData1 = CEILING(@TempCheckPreviousData1))
                                                BEGIN
                                                   IF(@NoOfTypeOfLeaves > 1)
                                                   BEGIN
                                                      IF(@TempDateWiseLeaveCounter = CEILING(@LoopCount))
                                                      BEGIN
                                                         INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay], [IsFirstHalfDay])
                                                         SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 1, 1
                                                         FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                       PRINT 'Increase startdate 3.5'
                                                      END
                                                      ELSE
                                                      BEGIN
                                                         INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay])
                                                         SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 0
                                                         FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                                         PRINT 'Increase startdate 3.6'
                                                         --SET @StartDateId = @StartDateId + 1
                                                         SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                                      END
                                                   END
                                                   ELSE
                                                   BEGIN
                                                      IF(@TempDateWiseLeaveCounter = 1)
                                                      BEGIN
                                                         SET @TempDateWiseLeaveCounter = @TempDateWiseLeaveCounter + 1
                                                      END
                                                   IF(@TempDateWiseLeaveCounter <= CEILING(@LoopCount))
                                                      BEGIN
                                                         INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay])
                                                         SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 0
                                                         FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                                         PRINT 'Increase startdate 3.2'
                                       --SET @StartDateId = @StartDateId + 1
                                                  SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                                      END
                                                   END
                                                END
                                                ELSE
                                                BEGIN
                                                   INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay])
                                                   SELECT @LeaveRequestApplicationId, @StartDateId, T.[LeaveTypeId], 0
                                                   FROM #TempLeaveDetail T WHERE [Id] = @DateWiseLeaveCounter
                                                   PRINT 'Increase startdate 3.2'
                --SET @StartDateId = @StartDateId + 1
                                                   SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                                END
                                             END
                                          END
                                          print '@TempDateWiseLeaveCounter: ' + cast(@TempDateWiseLeaveCounter as varchar(10)) 
                                          SET @TempDateWiseLeaveCounter = @TempDateWiseLeaveCounter + 1
                                       END
                                       SET @DateWiseLeaveCounter = @DateWiseLeaveCounter + 1
                                    END
                                       PRINT 'Enter data for - @StartDateId = @TillDateId'
                                       INSERT INTO [dbo].[DateWiseLeaveType]([LeaveRequestApplicationId], [DateId], [LeaveTypeId], [IsHalfDay], [IsLastDayHalfDay])
                                       SELECT @LeaveRequestApplicationId, @TillDateId, T.[LeaveTypeId], 1, 1
                                       FROM #TempLeaveDetail T WHERE [Id] = (@DateWiseLeaveCounter-1)
                                       PRINT 'Increase startdate 3'
                                       --SET @StartDateId = @StartDateId + 1
                                       SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                                 END
                                 ELSE
                                 BEGIN                                    
                                   SET @Success=5--data supplied is incorrect
                                    ROLLBACK TRANSACTION
                                 END
                              END
                           END
                           PRINT 'Increase startdate 1'
                           --SET @StartDateId = @StartDateId + 1
                           SET @StartDateId = (SELECT [dbo].[fnGetNextDateId](@StartDateId))
                        END

------------------------------------------Insert into DateWiseLeaveType table ends------------------------------------------
------------------------------------------Insert into LeaveBalanceHistory table starts------------------------------------------

                        INSERT INTO [dbo].[LeaveBalanceHistory]([RecordId], [Count], [CreatedBy])
                        SELECT B.[RecordId], B.[Count], @LoginUserId
                        FROM
                           #TempLeaveDetail T
                           INNER JOIN
                              [dbo].[LeaveBalance] B WITH (NOLOCK)
                                 ON T.[LeaveTypeId] = B.[LeaveTypeId]
                           WHERE
                              B.[UserId] = @EmployeeId
                  
                        --update LeaveBalance Table(not for LWP)
                        UPDATE [dbo].[LeaveBalance]
                        SET [Count] = B.[Count] - T.[LeaveCount]
                           ,[LastModifiedDate] = GETDATE()
                           ,[LastModifiedBy] = @LoginUserId
                        FROM
                           #TempLeaveDetail T
                           INNER JOIN
                              [dbo].[LeaveBalance] B WITH (NOLOCK)
                                 ON T.[LeaveTypeId] = B.[LeaveTypeId]
                        WHERE
                           B.[UserId] = @EmployeeId AND T.[LeaveType] != 'LWP'
                  
                        --update LeaveBalance Table(for LWP)
                        UPDATE [dbo].[LeaveBalance]
                        SET [Count] = B.[Count] + T.[LeaveCount]
                           ,[LastModifiedDate] = GETDATE()
                           ,[LastModifiedBy] = @LoginUserId
                        FROM
                           #TempLeaveDetail T
         INNER JOIN
                              [dbo].[LeaveBalance] B WITH (NOLOCK)
                                 ON T.[LeaveTypeId] = B.[LeaveTypeId]
                        WHERE
                           B.[UserId] = @EmployeeId AND T.[LeaveType] = 'LWP'
                  
                        --update LeaveBalance(for 5CLOY flag)
                        IF((SELECT COUNT(*) FROM #TempLeaveDetail WHERE [LeaveType] = 'CL' AND [LeaveCount] > 2 ) > 0)
                        BEGIN
                           UPDATE [dbo].[LeaveBalance]
                        SET [Count] = 0
                           ,[LastModifiedDate] = GETDATE()
                           ,[LastModifiedBy] = @LoginUserId
                        WHERE
                           [UserId] = @EmployeeId AND [LeaveTypeId] = 8 --id for 5CLOY
                        END
------------------------------------------Insert into LeaveBalanceHistory table ends------------------------------------------                  
                         SET @Success=4 --success
                     COMMIT TRANSACTION
                     
                     DROP TABLE #TempLeaveDetail
                     DROP TABLE #Combination
               END
               ELSE
               BEGIN
                  --SET @Status = 3 --combination supplied is invalid
                   SET @Success=3
               END
            END
            ELSE
            BEGIN
               --SET @Status = 2 --no combination present
                SET @Success=2
            END
         END

	  END
END TRY
BEGIN CATCH
	-- On Error
	IF @@TRANCOUNT > 0
	BEGIN
		ROLLBACK TRANSACTION;
	END

	SET @Success = 0;
	DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
	--Log Error
	EXEC [spInsertErrorLog]
		@ModuleName = 'LeaveManagement'
	,@Source = 'spApplyLeave'
	,@ErrorMessage = @ErrorMessage
	,@ErrorType = 'SP'
	,@ReportedByUserId = @EmployeeId
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[spFetchAllLnsaRequestStatusByUserId]    Script Date: 09-08-2018 18:45:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spFetchAllLnsaRequestStatusByUserId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spFetchAllLnsaRequestStatusByUserId] AS' 
END
GO
/***
   Created Date      :     2016-07-11
   Created By        :     Shubhra Upadhyay
   Purpose           :     This stored proc is used to get status of all LNSA request on basis of userId
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   2018-08-09         Kanchan Kumari       remove VM id 
   --------------------------------------------------------------------------

   Test Cases        :
   --------------------------------------------------------------------------
   
   --- Test Case 1
         EXEC [dbo].[spFetchAllLnsaRequestStatusByUserId]
        @UserId = 1

   --- Test Case 2
         EXEC [dbo].[spFetchAllLnsaRequestStatusByUserId]
         @UserId = 2166
***/

ALTER PROCEDURE [dbo].[spFetchAllLnsaRequestStatusByUserId] 
   @UserId [int]
AS
BEGIN
	
SET NOCOUNT ON;
      SELECT 
         D.[Date]                                                                                        AS [FromDate]
        ,M.[Date]                                                                                        AS [TillDate]
        ,R.[TotalNoOfDays]                                                                               AS [NoOfDays]
        ,R.[Reason]                                                                                      AS [Reason]
		,R.[ApproverRemarks]																			 AS [Remarks]
        ,CASE R.[Status]
            WHEN 0 THEN 'Pending for Appoval with ' + UD.[FirstName] + ' ' + UD.[LastName]
            WHEN -1 THEN 'Rejected By ' + UD.[FirstName] + ' ' + UD.[LastName]
            WHEN 1 THEN 'Approved By ' + UD.[FirstName] + ' ' + UD.[LastName] 
         END                                                                                             AS [Status]
      FROM
         [dbo].[RequestLnsa] R WITH (NOLOCK)
            INNER JOIN
               [dbo].[DateMaster] D WITH (NOLOCK)
                  ON D.[DateId] = R.[FromDateId]
            INNER JOIN
               [dbo].[DateMaster] M WITH (NOLOCK)
                  ON M.[DateId] = R.[TillDateId]
            INNER JOIN
               [dbo].[UserDetail] U WITH (NOLOCK)
                  ON U.[UserId] = R.[CreatedBy]
            INNER JOIN
               [dbo].[UserDetail] UD WITH (NOLOCK)
                  ON UD.[UserId] = CASE WHEN (select [dbo].[fnGetReportingManagerByUserId](@UserId))=0 THEN [dbo].[fnGetHRIdByUserId](@UserId) 
									  ELSE (select [dbo].[fnGetReportingManagerByUserId](@UserId))
								 END
      WHERE
         R.[CreatedBy] = @UserId
      ORDER BY D.[Date] DESC
END




GO
/****** Object:  StoredProcedure [dbo].[spFetchAllPendingLnsaRequestByManagerId]    Script Date: 09-08-2018 18:45:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spFetchAllPendingLnsaRequestByManagerId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spFetchAllPendingLnsaRequestByManagerId] AS' 
END
GO
/***
   Created Date      :     2016-07-11
   Created By        :     Shubhra Upadhyay
   Purpose           :     This stored proc is used to get all pending LNSA request by reporting manager Id 
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   2018-08-09         Kanchan Kumari       remove VM id 
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   --- Test Case 1
         EXEC [dbo].[spFetchAllPendingLnsaRequestByManagerId]
        @UserId = 2166
***/
ALTER PROCEDURE [dbo].[spFetchAllPendingLnsaRequestByManagerId] 
   @UserId [int]
AS
BEGIN
SET NOCOUNT ON;
	  --DECLARE --CASE WHEN U.[ReportTo]=3 THEN 2166 ELSE U.[ReportTo]
      SELECT 
		 R.[RequestId] AS [RequestId]
		,U.[FirstName] + ' ' + U.[LastName]	AS [EmployeeName]
        ,D.[Date] AS [FromDate]
        ,M.[Date] AS [TillDate]
        ,R.[TotalNoOfDays] AS [NoOfDays]
        ,R.[Reason] AS [Reason]
      FROM
         [dbo].[RequestLnsa] R WITH (NOLOCK)
         INNER JOIN [dbo].[DateMaster] D WITH (NOLOCK) ON D.[DateId] = R.[FromDateId]
         INNER JOIN [dbo].[DateMaster] M WITH (NOLOCK) ON M.[DateId] = R.[TillDateId]
         INNER JOIN [dbo].[UserDetail] U WITH (NOLOCK) ON U.[UserId] = R.[CreatedBy]
         INNER JOIN [dbo].[UserDetail] UD WITH (NOLOCK) 
				ON UD.[UserId] = CASE WHEN (select [dbo].[fnGetReportingManagerByUserId](R.CreatedBy))=0 THEN [dbo].[fnGetHRIdByUserId](R.CreatedBy) 
									  ELSE (select [dbo].[fnGetReportingManagerByUserId](R.CreatedBy))
								 END
      WHERE UD.[UserId] = @UserId AND R.[Status] = 0
      ORDER BY D.[Date] DESC
END
GO
/****** Object:  StoredProcedure [dbo].[spFetchWeekMap]    Script Date: 09-08-2018 18:45:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spFetchWeekMap]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spFetchWeekMap] AS' 
END
GO
/***
   Created Date      :     2018-07-25
   Created By        :     Kanchan kumari
   Purpose           :     This stored procedure retrives current week no
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   
   --------------------------------------------------------------------------

   Test Cases        :
   --------------------------------------------------------------------------
   
   --- Test Case 1
         EXEC [dbo].[spFetchWeekMap]
            @UserId = 7
           ,@StartDate = '2018-07-25'
            
              
***/
ALTER PROCEDURE [dbo].[spFetchWeekMap]
   @UserId [int]
  ,@StartDate [date]
AS
BEGIN   
   SET FMTONLY OFF;
   DECLARE 
      @WeekStartDate [date]
     ,@WeekEndDate [date]
     ,@CurrentDate [date]
     ,@WeekNo [int]

   CREATE TABLE #WeekMaster
   (
      [Date] [date]
     ,[WeekNo] [int]
   )

   CREATE TABLE #TempHack
   (
      [StartDate] [date]
     ,[EndDate] [date]
     ,[WeekNo] [int]
   )

   CREATE TABLE #WeekCount
   (
     [WeekNo] [int]
    ,[Count] [int]
   )

   SELECT TOP 1
      @WeekStartDate = D.[Date]
     ,@WeekEndDate = DATEADD(dd, 6, D.[Date])
     ,@CurrentDate = D.[Date]
   FROM
      [dbo].[DateMaster] D WITH (NOLOCK)
         INNER JOIN
            [dbo].[WeekDay] W WITH (NOLOCK)
               ON D.[Day] = W.[WeekDayName]
         INNER JOIN
            [dbo].[Team] T WITH (NOLOCK)
               ON W.[WeekDayId] = T.[WeekDayId]
         INNER JOIN
            [dbo].[UserTeamMapping] U WITH (NOLOCK)
               ON U.[TeamId] = T.[TeamId]
   WHERE
      D.[Date] <= @StartDate
   ORDER BY
      D.[Date] DESC

   WHILE @CurrentDate <= @WeekEndDate
   BEGIN
      INSERT INTO #WeekMaster
      (
         [Date]
        ,[WeekNo]
      )
      SELECT
         @CurrentDate
        ,DATEPART(WEEK, @CurrentDate)

      SET @CurrentDate = DATEADD(dd, 1, @CurrentDate)
   END
   
   INSERT INTO #WeekCount
   (
      [WeekNo]
     ,[Count]
   )
   SELECT
      [WeekNo]
      ,COUNT(WeekNo) AS [Count]
   FROM
      #WeekMaster
   GROUP BY
      [WeekNo]

   SELECT TOP 1
      @WeekNo = WM.[WeekNo]
   FROM
      #WeekCount WM
   ORDER BY
      WM.[Count] DESC
   

   IF(@WeekStartDate IS NOT NULL)
   BEGIN
      INSERT INTO #TempHack VALUES(@WeekStartDate, @WeekEndDate, @WeekNo)
   END
   --SELECT
   --   @WeekStartDate                         AS [StartDate]
   --  ,@WeekEndDate                           AS [EndDate]
   --  ,@WeekNo                                AS [WeekNo]
   SELECT * FROM #TempHack

   DROP TABLE #WeekMaster
END

GO
/****** Object:  StoredProcedure [dbo].[spGetApproverRemarks]    Script Date: 09-08-2018 18:45:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetApproverRemarks]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGetApproverRemarks] AS' 
END
GO
/***
   Created Date      :     2016-03-06
   Created By        :     Narender Singh
   Purpose           :     This stored procedure Returns remarks by Approvers
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   --- Test Case 1
      EXEC [dbo].[spGetApproverRemarks] 
         @RequestId = 4404
        ,@Type = 'LEAVE'
        
   --  Test Case 2
      EXEC [dbo].[spGetApproverRemarks] 
         @RequestId = 12
        ,@Type = 'WFH'
        
   --  Test Case 3
      EXEC [dbo].[spGetApproverRemarks] 
         @RequestId = 1
        ,@Type = 'COFF'
        
   --  Test Case 4
      EXEC [dbo].[spGetApproverRemarks] 
         @RequestId = 1
        ,@Type = 'DATACHANGE'
       
***/
ALTER PROCEDURE [dbo].[spGetApproverRemarks]
(
   @RequestId [bigint]
  ,@Type [varchar] (10)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @AdminId int = 1

   IF(@Type = 'WFH' OR @Type = 'LEAVE')
	BEGIN
		SELECT 
		CASE
			WHEN LTRIM(RTRIM(LH.[ApproverRemarks])) = '' THEN CONVERT (VARCHAR(19),LH.[CreatedDate]) + ' | ' + UD.[FirstName] + ' ' + UD.[LastName] + ' : Approved'
			WHEN (LH.[ApproverId] = @AdminId AND LH.[CreatedBy] = @AdminId) THEN CONVERT (VARCHAR(19),LH.[CreatedDate],106)+' '+FORMAT(LH.CreatedDate,'hh:mm tt')  + ' | ' + LH.[ApproverRemarks]
			ELSE CONVERT (VARCHAR(19),LH.[CreatedDate],106) +' '+FORMAT(LH.CreatedDate,'hh:mm tt') + ' | ' + UD.[FirstName] + ' ' + UD.[LastName] + ' : ' + LH.[ApproverRemarks] 	
			END																																																		AS [Result]
		FROM [dbo].[LeaveHistory] LH
		INNER JOIN [dbo].[UserDetail] UD ON UD.[UserId] = LH.[CreatedBy]
		WHERE LH.[LeaveRequestApplicationId] =@RequestId 
		ORDER BY LH.[CreatedDate] DESC

	END
	ELSE IF(@Type = 'LGT' OR @Type = 'LEGITIMATE')
	BEGIN
		SELECT 
		CASE
			WHEN LTRIM(RTRIM(LH.[Remarks])) = '' THEN CONVERT (VARCHAR(19),LH.[CreatedDate]) + ' | ' + UD.[FirstName] + ' ' + UD.[LastName] + ' : Approved'
			WHEN ( LH.[CreatedBy] = @AdminId) THEN CONVERT (VARCHAR(19),LH.[CreatedDate],106) +' ' + FORMAT(LH.CreatedDate,'hh:mm tt')  + ' | ' + LH.[Remarks]
			ELSE CONVERT (VARCHAR(19),LH.[CreatedDate],106) +' ' + FORMAT(LH.CreatedDate,'hh:mm tt') + ' | ' + UD.[FirstName] + ' ' + UD.[LastName] + ' : ' + LH.[Remarks] 	
			END																																																		AS [Result]
			FROM [dbo].[LegitimateLeaveRequestHistory] LH
			INNER JOIN [dbo].[UserDetail] UD ON UD.[UserId] = LH.[CreatedBy]
			WHERE LH.[LegitimateLeaveRequestId] =@RequestId 
			ORDER BY LH.[CreatedDate] DESC

	END
	
	ELSE IF(@Type = 'COFF')
	BEGIN
		SELECT
		CASE
			WHEN LTRIM(RTRIM(RC.[ApproverRemarks])) = '' THEN CONVERT (VARCHAR(19),RC.[CreatedDate]) + ' : ' + UD.[FirstName] + ' ' + UD.[LastName] + ' : Approved'
			ELSE CONVERT (VARCHAR(19),RC.[CreatedDate]) + ' : ' + UD.[FirstName] + ' ' + UD.[LastName] + ' : ' + RC.[ApproverRemarks]			
		END																																																			AS [Result]
		FROM
			[dbo].[RequestCompOffHistory] RC
			INNER JOIN  [dbo].[UserDetail] UD ON UD.[UserId] = RC.[CreatedBy]
		WHERE RC.[RequestId] = @RequestId
		ORDER BY RC.[CreatedDate] DESC							
	END
	
	ELSE IF(@Type = 'DATACHANGE')
	BEGIN
		SELECT
		CASE
			WHEN LTRIM(RTRIM(DC.[ApproverRemarks])) = '' THEN CONVERT (VARCHAR(19), DC.[CreatedDate]) + ' : ' + UD.[FirstName] + ' ' + UD.[LastName] + ' : Approved'
			ELSE CONVERT (VARCHAR(19),DC.[CreatedDate]) + ' : ' + UD.[FirstName] + ' ' + UD.[LastName] + ' : ' + DC.[ApproverRemarks]
		END																																																			AS	[Result]
		FROM [dbo].[AttendanceDataChangeRequestHistory] DC 
			INNER JOIN [dbo].[UserDetail] UD ON UD.[UserId] = DC.[ApproverId]
		WHERE DC.[RequestId] = @RequestId
		ORDER BY DC.[CreatedDate] DESC

	END
	--for outing request approver remarks
	ELSE  IF(@Type = 'OR' OR @Type = 'OUTING')
	BEGIN
		SELECT 
		CASE
			WHEN LTRIM(RTRIM(H.[Remarks])) = '' THEN CONVERT (VARCHAR(19),H.[CreatedDate],106)+ ' ' + FORMAT(H.CreatedDate,'hh:mm tt') + ' | ' + UD.[FirstName] + ' ' + UD.[LastName] + ' : Approved'
			WHEN (H.[CreatedById] =  @AdminId AND R.[CreatedById] = @AdminId) THEN CONVERT (VARCHAR(19),H.[CreatedDate],106)+ ' ' + FORMAT(H.CreatedDate,'hh:mm tt') + ' | ' + H.[Remarks]
			ELSE CONVERT (VARCHAR(19),H.[CreatedDate],106)+ ' ' + FORMAT(H.CreatedDate,'hh:mm tt') + ' | ' + UD.[FirstName] + ' ' + UD.[LastName] + ' : ' + H.[Remarks] 	
			END	 AS [Result]																																																	
		FROM [dbo].[OutingRequestHistory] H
		INNER JOIN [dbo].[OutingRequest] R ON R.OutingRequestId=H.OutingRequestId
		INNER JOIN [dbo].[UserDetail] UD ON UD.[UserId] = H.[CreatedById]
		WHERE H.[OutingRequestId] = @RequestId
		ORDER BY H.[CreatedDate] DESC
	END
		ELSE  IF(@Type = 'LNSA' OR @Type = 'LNSASHIFT')
	BEGIN
		SELECT 
		CASE
			WHEN LTRIM(RTRIM(H.[Remarks])) = '' AND H.StatusId=4 THEN CONVERT (VARCHAR(19),H.[CreatedDate],106)+ ' ' + FORMAT(H.CreatedDate,'hh:mm tt') + ' | ' + UD.[FirstName] + ' ' + UD.[LastName] + ' : Approved'
			WHEN LTRIM(RTRIM(H.[Remarks])) = '' AND ( H.StatusId=6 OR H.StatusId=7) THEN CONVERT (VARCHAR(19),H.[CreatedDate],106)+ ' ' + FORMAT(H.CreatedDate,'hh:mm tt') + ' | ' + UD.[FirstName] + ' ' + UD.[LastName] + ' : Rejected'
			WHEN (H.[CreatedBy] =  @AdminId AND R.[CreatedBy] = @AdminId) THEN CONVERT (VARCHAR(19),H.[CreatedDate],106)+ ' ' + FORMAT(H.CreatedDate,'hh:mm tt') + ' | ' + H.[Remarks]
			ELSE CONVERT (VARCHAR(19),H.[CreatedDate],106)+ ' ' + FORMAT(H.CreatedDate,'hh:mm tt') + ' | ' + UD.[FirstName] + ' ' + UD.[LastName] + ' : ' + H.[Remarks] 	
			END	 AS [Result]																																																	
		FROM [dbo].[TempUserShiftHistory] H
		INNER JOIN [dbo].[TempUserShift] R ON R.TempUserShiftId=H.TempUserShiftId
		INNER JOIN [dbo].[UserDetail] UD ON UD.[UserId] = H.[CreatedBy]
		WHERE H.[TempUserShiftId] = @RequestId
		ORDER BY H.[CreatedDate] DESC, H.TempUserShiftHistoryId DESC
	END
	
	ELSE
	 SELECT 'ERROR'  AS	[Result]
END






GO
/****** Object:  StoredProcedure [dbo].[spGetDateForWorkFromHome]    Script Date: 09-08-2018 18:45:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetDateForWorkFromHome]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGetDateForWorkFromHome] AS' 
END
GO
/***
   Created Date      :     2015-10-08
   Created By        :     Nishant Srivastava
   Purpose           :     This stored procedure to Check  apply leaves Status for a user
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   2018-08-09         Kanchan Kumari     if user is in night shift on a date then that date
                                         should be availble next day for WFM
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   
   --- Test Case 1
         EXEC [dbo].[spGetDateForWorkFromHome]
            @UserId = 22

   --- Test Case 2
         EXEC [dbo].[spGetDateForWorkFromHome]
            @UserId = 2166

***/
ALTER PROCEDURE [dbo].[spGetDateForWorkFromHome]
   @UserId [int]
AS
BEGIN
	SET NOCOUNT ON;
   SET FMTONLY OFF;

    IF OBJECT_ID('tempdb..#FinalValues') IS NOT NULL
     DROP TABLE #FinalValues

	  IF OBJECT_ID('tempdb..#FinalValues') IS NOT NULL
     DROP TABLE #FinalValues
	
   CREATE TABLE #FinalValues
   (
      [DateId] [bigint] NOT NULL
     ,[Date] [date] NOT NULL
   )

   INSERT INTO #FinalValues
   (
      [DateId] 
     ,[Date] 
   )
   SELECT TOP 2
      D.[DateId]
     ,D.[Date]
   FROM
      [dbo].[DateMaster] D WITH (NOLOCK) 
   WHERE
      D.[Date] >=CAST(GETDATE() AS DATE)
				
      --AND D.[IsHoliday] = 0
      --AND D.[IsWeekend] = 0

-----------add date for night shift user------------
CREATE TABLE #TempUserData
	(
	UserId INT,
	DateId BIGINT,
	)
	INSERT INTO #TempUserData
		SELECT  TD.CreatedBy AS UserId,
				TD.DateId
				FROM TempUserShiftDetail TD 
				INNER JOIN OutingRequestStatus OS ON TD.StatusId =OS.StatusId
				WHERE TD.CreatedBy = @UserId AND OS.StatusCode='PA'

	INSERT INTO #TempUserData
		SELECT  USM.UserId AS UserId,
				USM.DateId
				FROM  UserShiftMapping USM 
				JOIN ShiftMaster SM ON USM.ShiftId = SM.ShiftId
				WHERE USM.UserId =@UserId AND USM.IsActive=1 AND SM.IsNight = 1

  INSERT INTO #FinalValues
   (
      [DateId] 
     ,[Date] 
   )
   SELECT TOP 1
      D.[DateId]
     ,D.[Date]
   FROM
      [dbo].[DateMaster] D WITH (NOLOCK) 
	   JOIN #TempUserData TUD ON D.DateId =TUD.DateId 
   WHERE
      D.[Date] >= CASE
	                WHEN CAST(GETDATE() AS DATE) = DATEADD(dd,1,D.[Date])
					THEN DATEADD(dd, -1, CAST(GETDATE() AS DATE))
					END
   DELETE 
     T
   FROM
      #FinalValues T
         INNER JOIN
            (
               SELECT
                  L.[FromDateId]
               FROM
                  [dbo].[LeaveRequestApplication] L WITH (NOLOCK)
                     INNER JOIN
                        [dbo].[LeaveRequestApplicationDetail] D WITH (NOLOCK)
                           ON D.[LeaveRequestApplicationId] = L.[LeaveRequestApplicationId]
                     INNER JOIN
                        [dbo].[LeaveTypeMaster] T WITH (NOLOCK)
                           ON T.[TypeId] = D.[LeaveTypeId]
               WHERE
                  L.[UserId] = @UserId      
                  AND T.[ShortName] = 'WFH'
                  AND L.[IsActive] = 1
                  AND L.[IsDeleted] = 0
                  AND L.[StatusId] > -1
            ) M
               ON M.[FromDateId] = T.[DateId]
   SELECT
      T.[DateId]                                 AS [DateId]
     ,CONVERT([varchar](10), T.[Date], 101)      AS [Date]
   FROM
      #FinalValues T ORDER BY T.[DateId] ASC
END

GO
/****** Object:  StoredProcedure [dbo].[spRequestWorkFromHome]    Script Date: 09-08-2018 18:45:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spRequestWorkFromHome]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spRequestWorkFromHome] AS' 
END
GO
/***
   Created Date      :     2016-01-25
   Created By        :     Nishant Srivastava
   Purpose           :     This stored procedure Apply Work From Home 
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   
   --------------------------------------------------------------------------

   Test Cases        :
   --------------------------------------------------------------------------
   
   --- Test Case 1
         EXEC  [dbo].[spRequestWorkFromHome]
                @Userid = 42
               ,@Date ='2016-01-29'
               ,@Reason= 'Test'
               ,@MobileNo = '12345678900'
               ,@LeaveType='WFH'
               ,@NoOfTotalDays=1
               ,@NoOfWorkingDays = 1
               ,@IsFirstHalfWfh = 0
               ,@IsLastHalfWfh = 0 

   --- Test Case 2
         EXEC  [dbo].[spRequestWorkFromHome]
                @Userid = 79
               ,@Date ='2017-05-16'
               ,@Reason= 'Test'
               ,@MobileNo = '7856346677'
               ,@LeaveType='WFH'
               ,@NoOfTotalDays = 1
               ,@NoOfWorkingDays = 1
               ,@IsFirstHalfWfh = 0
               ,@IsLastHalfWfh = 0
              
***/

ALTER PROCEDURE [dbo].[spRequestWorkFromHome]
 @UserId [int]
,@Date [Date]
,@Reason [varchar](500)
,@NoOfTotalDays [float]
,@NoOfWorkingDays [float]
,@MobileNo [varchar](15)
,@LeaveType [varchar](3)
,@IsFirstHalfWfh [bit]
,@IsLastHalfWfh [bit]
AS
BEGIN
   SET NOCOUNT ON;
   SET FMTONLY OFF;
      BEGIN TRY                     
         BEGIN TRANSACTION         
            DECLARE @DateId Bigint ,@TypeId Int
            SELECT   @DateId  = [DateId]  FROM [dbo].[DateMaster] WITH (NOLOCK) WHERE [Date] = @Date
            SELECT   @TypeId  = [TypeId]  FROM [dbo].[LeaveTypeMaster] WITH (NOLOCK) WHERE [ShortName] = @LeaveType 

            CREATE TABLE #Result(               
               [UserId] int
              ,[FirstName] [varchar](100)
              ,[LastName] [varchar](100)
              ,[EmailId] [varchar](200)
              )
            ------Check if WFH already applied by user for same date------
            IF NOT EXISTS(SELECT 1 FROM [dbo].[LeaveRequestApplication] WHERE [FromDateId] = @DateId 
                                                                    AND [StatusId] > 0 AND [UserId] = @UserId AND [LeaveCombination] IS NULL)            
            ------Insert into [LeaveRequestApplication] starts------            
         BEGIN
               DECLARE @ApproverId int
                  ,@StatusId int = 1
                  ,@ReportingManagerId int = (SELECT [dbo].[fnGetReportingManagerByUserId](@UserId))
                  ,@DepartmentHeadId int = (SELECT [dbo].[fnGetDepartmentHeadIdByUserId](@UserId))
                  ,@HRId int = (SELECT [dbo].[fnGetHRIdByUserId](@UserId))
               SET @ApproverId = @ReportingManagerId
               IF(@ReportingManagerId = 0 OR @ReportingManagerId = @HRId)
               BEGIN
                  IF(@DepartmentHeadId = 0)
                  BEGIN
                  SET @ApproverId = @HRId;
                  SET @StatusId = (SELECT [StatusId] FROM [dbo].[LeaveStatusMaster] WHERE [StatusCode] = 'PV')
               END
                  ELSE
                  BEGIN
                  SET @ApproverId = @DepartmentHeadId
                  SET @StatusId = (SELECT [StatusId] FROM [dbo].[LeaveStatusMaster] WHERE [StatusCode] = 'AP')
               END
               END

               INSERT INTO [LeaveRequestApplication] 
               (
                   [UserId]
                  ,[FromDateId]
                  ,[TillDateId]
                  ,[NoOfTotalDays]
                  ,[NoOfWorkingDays]
                  ,[Reason]
                  ,[PrimaryContactNo]
                  ,[IsAvailableOnMobile]
                  ,[IsAvailableOnEmail]
                  ,[StatusId]
                  ,[ApproverId]
                  ,[CreatedBy]
               )
               SELECT 
                      @UserId
                     ,@DateId                               AS FromDateId
                     ,@DateId                               AS TillDateId
                     ,@NoOfTotalDays                        AS NoOfTotalDays
                     ,@NoOfWorkingDays                      AS NoOfWorkingDays
                     ,@Reason                               AS [Reason]
                     ,@MobileNo                             AS [PrimaryContactNo]
                     ,1                                     AS IsAvailableOnMobile
                     ,1        
                     ,@StatusId                             AS IsAvailableOnEmail
                     ,@ApproverId                           AS ApproverId
                     ,@UserId                               AS [CreatedBy]                           
                  ------Insert into [LeaveRequestApplication] ends------

            ------Insert into [LeaveRequestApplicationDetail] starts------
               DECLARE @LeaveRequestApplicationId [bigint]
               SET @LeaveRequestApplicationId = SCOPE_IDENTITY () 
               INSERT INTO [dbo].[LeaveRequestApplicationDetail]
               SELECT 
                     L.[LeaveRequestApplicationId]          AS LeaveRequestApplicationId
                     ,@TypeId                               AS [LeaveTypeId]
                     ,@NoOfWorkingDays                      AS [Count]             
               FROM 
                     [dbo].[LeaveRequestApplication] L WITH (NOLOCK) 
               WHERE 
                     [LeaveRequestApplicationId] = @LeaveRequestApplicationId
                     AND [UserId] = @UserId
               ------Insert into [LeaveRequestApplicationDetail] ends------

---------------------------------------Insert into LeaveHistory table starts---------------------------------------

               INSERT INTO [dbo].[LeaveHistory]
               (
                  [LeaveRequestApplicationId]
                  ,[StatusId]
                  ,[ApproverId]
                  ,[ApproverRemarks]
                  ,[CreatedBy]
               )
               SELECT
                  @LeaveRequestApplicationId
                  ,@StatusId
                  ,@ApproverId
                  ,'Applied'
                  ,@UserId

            ---------------------------------------Insert into LeaveHistory table ends---------------------------------------

            ------Insert into [DateWiseLeaveType] starts------
            IF(@IsFirstHalfWfh = 1)
            BEGIN
               INSERT INTO [dbo].[DateWiseLeaveType](
                     [LeaveRequestApplicationId]
                  ,[DateId]
                  ,[LeaveTypeId]
                  ,[IsHalfDay]
                  ,[IsFirstDayHalfDay]
                  )
               VALUES(
                  @LeaveRequestApplicationId
                  ,@DateId
                  ,@TypeId
                  ,1
                  ,1
                  )
            END
            ELSE IF(@IsLastHalfWfh = 1)
            BEGIN
               INSERT INTO [dbo].[DateWiseLeaveType](
                     [LeaveRequestApplicationId]
                  ,[DateId]
                  ,[LeaveTypeId]
                  ,[IsHalfDay]
                  ,[IsLastDayHalfDay]
                  )
               VALUES(
                  @LeaveRequestApplicationId
                  ,@DateId
                  ,@TypeId
                  ,1
                  ,1
                  )
            END
            ELSE  --WFH is for full day
            BEGIN
               INSERT INTO [dbo].[DateWiseLeaveType](
                     [LeaveRequestApplicationId]
                  ,[DateId]
                  ,[LeaveTypeId]
                  ,[IsHalfDay]
                  )
               VALUES(
                  @LeaveRequestApplicationId
                  ,@DateId
                  ,@TypeId
                  ,0
                  )
            END
          ------Insert into [DateWiseLeaveType] ends------         
          INSERT INTO #Result
            SELECT M.[UserId], M.[FirstName], M.[LastName], M.[EmailId]
            FROM [dbo].[UserDetail] M WITH (NOLOCK) 
            INNER JOIN [dbo].[UserDetail] U WITH (NOLOCK) ON M.[UserId] = @ApproverId----change so that vm shoud not get mail
            WHERE U.[UserId] = @ApproverId    
         END         
      COMMIT TRANSACTION      
      SELECT * FROM #Result
                  
      END TRY
      BEGIN CATCH
         ROLLBACK TRANSACTION         
         DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
         EXEC [spInsertErrorLog]
	       @ModuleName = 'WorkFromHome'
         ,@Source = 'spRequestWorkFromHome'
         ,@ErrorMessage = @ErrorMessage
         ,@ErrorType = 'SP'
         ,@ReportedByUserId = @UserId
      END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[spTakeActionOnAppliedLeave]    Script Date: 09-08-2018 18:45:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spTakeActionOnAppliedLeave]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spTakeActionOnAppliedLeave] AS' 
END
GO
/***
   Created Date      :     2016-02-08
   Created By        :     Nishant Srivastava
   Purpose           :     This stored procedure to Tacke Action On Apply Leave By User,Manager,HR 
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   2016-5-18         Narender Singh       Handling for Cancel leave after availing
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   --- Test Case 1
      EXEC [dbo].[spTakeActionOnAppliedLeave] 
         @LeaveRequestApplicationId = 10019
        ,@Status = 'PV'
        ,@Remarks = 'Approved'
        ,@UserId = 2166
        ,@ForwardedId = 0 -- take care of 5CL in a year

   --  Test Case 2
      EXEC [dbo].[spTakeActionOnAppliedLeave] 
         @LeaveRequestApplicationId = 8686
        ,@Status = 'PV' -- pending for verification
        ,@Remarks = 'OK'
        ,@UserId = 2432
        ,@ForwardedId = 0 --or some other id

   --  Test Case 3
      EXEC [dbo].[spTakeActionOnAppliedLeave] 
         @LeaveRequestApplicationId = 1
        ,@Status = 'AP' -- pending for verification
        ,@Remarks = 'Approved by Amit Handa'
        ,@UserId = 4
        ,@ForwardedId = 0 or some other id

   --  Test Case 4
      EXEC [dbo].[spTakeActionOnAppliedLeave] 
         @LeaveRequestApplicationId = 8847
        ,@Status = 'CA' -- pending for verification
        ,@Remarks = 'Cancelled'
        ,@UserId = 2166
        ,@ForwardedId = 0 or some other id
***/
ALTER PROCEDURE [dbo].[spTakeActionOnAppliedLeave] 
   @LeaveRequestApplicationId [bigint]
  ,@Status [varchar] (2)
  ,@Remarks [Varchar] (500)
  ,@UserId [int]
  ,@ForwardedId [int]
AS
BEGIN
	SET NOCOUNT ON
   
   IF OBJECT_ID('tempdb..#TempCoffCount') IS NOT NULL
     DROP TABLE #TempCoffCount 

   BEGIN TRY
      DECLARE @Date [date] = GETDATE()
	
      IF EXISTS (SELECT 1 FROM [dbo].[LeaveRequestApplication] WITH (NOLOCK) WHERE [LeaveRequestApplicationId] = @LeaveRequestApplicationId AND [LastModifiedBy] = @UserId)
      BEGIN
         SELECT 'DUPLICATE' AS [Result]
         RETURN
      END
      ELSE IF EXISTS (SELECT 1 FROM [dbo].[LeaveRequestApplication] L WITH (NOLOCK) INNER JOIN [dbo].[DateMaster] D WITH (NOLOCK) ON L.[FromDateId] = D.[DateId] 
					  WHERE L.[LeaveRequestApplicationId] = @LeaveRequestApplicationId AND L.[UserId] = @UserId AND D.[Date] <= @Date AND L.[StatusId] = 0)--@Status = 'CA')
      BEGIN
         SELECT 'CANCELLED'                                                                                   AS [Result]
         RETURN
      END

      BEGIN TRANSACTION
      -- create history of existing record

	INSERT INTO [dbo].[LeaveHistory] 
	(
		[LeaveRequestApplicationId]
		,[StatusId]
		,[ApproverId]
		,[ApproverRemarks]
		,[CreatedDate]
		,[CreatedBy]
	)
     SELECT 
           @LeaveRequestApplicationId
          ,[Statusid]
          ,@UserID
          ,@Remarks
          ,GETDATE ()
          ,@UserID
     FROM [dbo].[LeaveStatusMaster] LS WITH (NOLOCK) 
	 WHERE LS.StatusCode = @Status
   
      --declarations
   
      DECLARE @EmployeeId int = (SELECT [UserId] FROM [LeaveRequestApplication] WHERE [LeaveRequestApplicationId] = @LeaveRequestApplicationId)
      DECLARE @FirstReportingManagerId int = (SELECT [dbo].[fnGetReportingManagerByUserId](@EmployeeId))
             ,@SecondReportingManagerId int = (SELECT [dbo].[fnGetSecondReportingManagerByUserId](@EmployeeId))
             ,@HRId int = (SELECT [dbo].[fnGetHRIdByUserId](@EmployeeId))
             ,@DepartmentHeadId int = (SELECT [dbo].[fnGetDepartmentHeadIdByUserId](@EmployeeId))
      DECLARE @NoOfActionsOnRequest int = (SELECT COUNT(*) FROM [LeaveHistory] WHERE [LeaveRequestApplicationId] = @LeaveRequestApplicationId AND [StatusId] > 0 AND [ApproverId] IN (@FirstReportingManagerId, @SecondReportingManagerId))
      DECLARE @IsForwardToDepartmentHead bit = 0
   
      -- set forwaded id to departmentHeadId id if 5 CL in a year and approver is other than departmentHead

      IF EXISTS (SELECT 1 FROM [dbo].[LeaveRequestApplication] A WITH (NOLOCK)
                 INNER JOIN [dbo].[LeaveRequestApplicationDetail] D WITH (NOLOCK) ON A.[LeaveRequestApplicationId] = D.[LeaveRequestApplicationId]
				 INNER JOIN [dbo].[LeaveTypeMaster] M WITH (NOLOCK) ON D.[LeaveTypeId] = M.[TypeId] 								
			     WHERE 
                  A.[LeaveRequestApplicationId] = @LeaveRequestApplicationId 
                  AND M.[ShortName] = 'CL'
                  AND D.[Count] > 2
                  AND A.[ApproverId] != @DepartmentHeadId --4
                  AND A.[UserId] != @DepartmentHeadId --4 
                  AND @ForwardedId = 0
				  AND NOT EXISTS (SELECT 1 FROM [dbo].[LeaveHistory] LH 
				  WHERE LH.[LeaveRequestApplicationId] = A.[LeaveRequestApplicationId]
				  AND LH.ApproverId = @DepartmentHeadId)) --4
   BEGIN
      IF(@EmployeeId != @DepartmentHeadId AND @DepartmentHeadId != 0 AND (@UserId = @SecondReportingManagerId OR (@UserId = @FirstReportingManagerId AND @SecondReportingManagerId = 0)))
         SET @IsForwardToDepartmentHead = 1
      --SELECT @ForwardedId = @DepartmentHeadId--4
   END
      -- change status of leave ie UPDATE [LeaveRequestApplication] table
       UPDATE M
       SET M.[StatusId] = 
		   CASE
				WHEN @Status = 'PV' AND @ForwardedId > 0 THEN S1.[StatusId]
				WHEN @Status = 'PV' AND @UserId = @FirstReportingManagerId AND (@SecondReportingManagerId != 0 OR @SecondReportingManagerId != @HRId) AND @SecondReportingManagerId != 0 THEN S1.[StatusId]
				WHEN @Status = 'PV' AND @UserId = @FirstReportingManagerId AND (@SecondReportingManagerId = 0 OR @SecondReportingManagerId = @HRId) AND @IsForwardToDepartmentHead = 1 THEN S1.[StatusId]
				WHEN @Status = 'PV' AND @UserId = @FirstReportingManagerId AND (@SecondReportingManagerId = 0 OR @SecondReportingManagerId = @HRId) AND @IsForwardToDepartmentHead = 0 THEN S.[StatusId]
				WHEN @Status = 'PV' AND @UserId = @SecondReportingManagerId AND @IsForwardToDepartmentHead = 0 THEN S.[StatusId]
				WHEN @Status = 'PV' AND @UserId = @SecondReportingManagerId AND @DepartmentHeadId != @HRId AND @SecondReportingManagerId != @DepartmentHeadId AND @FirstReportingManagerId != @DepartmentHeadId 
									AND @IsForwardToDepartmentHead = 1 THEN S1.[StatusId]                        
				WHEN @Status = 'PV' AND @UserId = @DepartmentHeadId THEN S.[StatusId]
				
                      
			--WHEN @Status = 'PV' AND @UserId = @FirstReportingManagerId AND (@SecondReportingManagerId != 0 OR @SecondReportingManagerId != @HRId) THEN S1.[StatusId]-- pending for approval
			--WHEN @Status = 'PV' AND @UserId = @FirstReportingManagerId AND (@SecondReportingManagerId = 0 OR @SecondReportingManagerId = @HRId) AND @ForwardedId = 0 THEN S.[StatusId]
			--WHEN @Status = 'PV' AND @UserId = @SecondReportingManagerId AND @ForwardedId > 0 THEN S1.[StatusId]-- pending for approval
			--WHEN @Status = 'PV' AND @UserId = @SecondReportingManagerId AND @ForwardedId = 0 THEN S.[StatusId]
			--WHEN @Status = 'PV' AND @UserId NOT IN (@FirstReportingManagerId, @SecondReportingManagerId, @HRId) AND @ForwardedId = 0 AND @NoOfActionsOnRequest = 1 AND (@SecondReportingManagerId != 0 OR @SecondReportingManagerId != @HRId) THEN S1.[StatusId]
			--WHEN @Status = 'PV' AND @UserId NOT IN (@FirstReportingManagerId, @SecondReportingManagerId, @HRId) AND @ForwardedId = 0 AND @NoOfActionsOnRequest = 1 AND (@SecondReportingManagerId = 0 OR @SecondReportingManagerId = @HRId) THEN S.[StatusId]

				WHEN @Status = 'PV' AND @UserId NOT IN (@FirstReportingManagerId, @SecondReportingManagerId, @DepartmentHeadId, @HRId) AND 
				@NoOfActionsOnRequest = 1 AND (@SecondReportingManagerId != 0 OR @SecondReportingManagerId != @HRId) AND @SecondReportingManagerId != 0 THEN S1.[StatusId]
				WHEN @Status = 'PV' AND @UserId NOT IN (@FirstReportingManagerId, @SecondReportingManagerId, @DepartmentHeadId, @HRId) AND @NoOfActionsOnRequest = 1 AND
					(@SecondReportingManagerId = 0 OR @SecondReportingManagerId = @HRId) AND @IsForwardToDepartmentHead = 1 THEN S1.[StatusId]
				WHEN @Status = 'PV' AND @UserId NOT IN (@FirstReportingManagerId, @SecondReportingManagerId, @DepartmentHeadId, @HRId) AND @NoOfActionsOnRequest = 1 AND 
				(@SecondReportingManagerId = 0 OR @SecondReportingManagerId = @HRId) AND @IsForwardToDepartmentHead = 0 THEN S.[StatusId]
				WHEN @Status = 'PV' AND @UserId NOT IN (@FirstReportingManagerId, @SecondReportingManagerId, @DepartmentHeadId, @HRId) AND @NoOfActionsOnRequest = 2 AND @IsForwardToDepartmentHead = 1 THEN S1.[StatusId]
				WHEN @Status = 'PV' AND @UserId NOT IN (@FirstReportingManagerId, @SecondReportingManagerId, @DepartmentHeadId, @HRId) AND @NoOfActionsOnRequest = 2 THEN S.[StatusId]
                        
				--WHEN @Status = 'PV' AND @ForwardedId = 0 THEN S.[StatusId]
				--WHEN @Status = 'PV' AND @ForwardedId > 0 THEN S1.[StatusId] -- pending for approval                        
				ELSE S.[StatusId]
				END
           ,M.[ApproverRemarks] = @Remarks
           ,M.[ApproverId] = 
		   CASE
				WHEN @Status = 'PV' AND @ForwardedId > 0 THEN @ForwardedId
				WHEN @Status = 'PV' AND @UserId = @FirstReportingManagerId AND (@SecondReportingManagerId != 0 OR @SecondReportingManagerId != @HRId) AND
					 @SecondReportingManagerId != 0 THEN @SecondReportingManagerId -- pending for approval
				WHEN @Status = 'PV' AND @UserId = @FirstReportingManagerId AND (@SecondReportingManagerId = 0 OR @SecondReportingManagerId = @HRId) AND 
				@IsForwardToDepartmentHead = 1 THEN @DepartmentHeadId
				WHEN @Status = 'PV' AND @UserId = @FirstReportingManagerId AND (@SecondReportingManagerId = 0 OR @SecondReportingManagerId = @HRId) AND 
				@IsForwardToDepartmentHead = 0 THEN @HRId
				WHEN @Status = 'PV' AND @UserId = @SecondReportingManagerId AND @IsForwardToDepartmentHead = 0 THEN @HRId
				WHEN @Status = 'PV' AND @UserId = @SecondReportingManagerId AND @DepartmentHeadId != @HRId AND @SecondReportingManagerId != @DepartmentHeadId AND 
				@FirstReportingManagerId != @DepartmentHeadId AND @IsForwardToDepartmentHead = 1 THEN @DepartmentHeadId                           
				WHEN @Status = 'PV' AND @UserId = @DepartmentHeadId THEN @HRId
				WHEN @Status = 'PV' AND @ForwardedId > 0 THEN @ForwardedId

				--WHEN @Status = 'PV' AND @UserId = @FirstReportingManagerId AND (@SecondReportingManagerId != 0 OR @SecondReportingManagerId != @HRId) AND @ForwardedId = 0 THEN @SecondReportingManagerId -- pending for approval
				--WHEN @Status = 'PV' AND @UserId = @FirstReportingManagerId AND (@SecondReportingManagerId != 0 OR @SecondReportingManagerId != @HRId) AND @ForwardedId > 0 THEN @ForwardedId -- pending for approval
				--WHEN @Status = 'PV' AND @UserId = @FirstReportingManagerId AND (@SecondReportingManagerId = 0 OR @SecondReportingManagerId = @HRId) AND @ForwardedId = 0 THEN @HRId
				--WHEN @Status = 'PV' AND @UserId = @SecondReportingManagerId AND @ForwardedId > 0 THEN @ForwardedId-- pending for approval
				--WHEN @Status = 'PV' AND @UserId = @SecondReportingManagerId AND @ForwardedId = 0 THEN @HRId

				WHEN @Status = 'PV' AND @UserId NOT IN (@FirstReportingManagerId, @SecondReportingManagerId, @DepartmentHeadId, @HRId) AND @NoOfActionsOnRequest = 1 AND
					(@SecondReportingManagerId != 0 OR @SecondReportingManagerId != @HRId) AND @SecondReportingManagerId != 0 THEN @SecondReportingManagerId
				WHEN @Status = 'PV' AND @UserId NOT IN (@FirstReportingManagerId, @SecondReportingManagerId, @DepartmentHeadId, @HRId) AND @NoOfActionsOnRequest = 1 AND
					(@SecondReportingManagerId = 0 OR @SecondReportingManagerId = @HRId) AND @IsForwardToDepartmentHead = 1 THEN @DepartmentHeadId
				WHEN @Status = 'PV' AND @UserId NOT IN (@FirstReportingManagerId, @SecondReportingManagerId, @DepartmentHeadId, @HRId) AND @NoOfActionsOnRequest = 1 AND 
				(@SecondReportingManagerId = 0 OR @SecondReportingManagerId = @HRId) AND @IsForwardToDepartmentHead = 0 THEN @HRId
				WHEN @Status = 'PV' AND @UserId NOT IN (@FirstReportingManagerId, @SecondReportingManagerId, @DepartmentHeadId, @HRId) AND @NoOfActionsOnRequest = 2 AND
					@IsForwardToDepartmentHead = 1 THEN @DepartmentHeadId WHEN @Status = 'PV' AND 
					@UserId NOT IN (@FirstReportingManagerId, @SecondReportingManagerId, @DepartmentHeadId, @HRId) AND @NoOfActionsOnRequest = 2 AND @IsForwardToDepartmentHead = 0
					THEN @HRId
                           
				--WHEN @Status = 'PV' AND @ForwardedId = 0 THEN 2166
				--WHEN @Status = 'PV' AND @ForwardedId > 0 THEN @ForwardedId
				WHEN @Status = 'CA' THEN NULL
						ELSE M.[ApproverId]
				END
     ,M.[IsActive] = CASE WHEN @Status = 'CA' THEN 0 ELSE 1 END
      ,M.[IsDeleted] = CASE WHEN @Status = 'CA' THEN 1 ELSE 0 END
      ,M.[LastModifiedBy] = @UserId
      ,M.[LastModifiedDate] = GETDATE()
   FROM [dbo].[LeaveRequestApplication] M
   INNER JOIN [dbo].[LeaveStatusMaster] S WITH (NOLOCK) ON S.[StatusCode] = @Status
   INNER JOIN [dbo].[LeaveStatusMaster] S1 WITH (NOLOCK) ON S1.[StatusCode] = 'PA'
   
   WHERE M.[LeaveRequestApplicationId] = @LeaveRequestApplicationId
  
      IF (@Status = 'CA' OR @Status = 'RJ')
      BEGIN      
      INSERT INTO [dbo].[LeaveBalanceHistory]
      (
         [RecordId]
        ,[Count]
        ,[CreatedBy]
      )
		SELECT B.[RecordId],B.[Count],@UserId
		FROM [dbo].[LeaveBalance] B WITH (NOLOCK)
		INNER JOIN [dbo].[LeaveRequestApplication] A WITH (NOLOCK) ON A.[UserId] = B.[UserId]
		INNER JOIN [dbo].[LeaveRequestApplicationDetail] D WITH (NOLOCK) ON B.[LeaveTypeId] = D.[LeaveTypeId]
					AND A.[LeaveRequestApplicationId] = D.[LeaveRequestApplicationId]
		WHERE D.[LeaveRequestApplicationId] = @LeaveRequestApplicationId   
		      
  ----------------update RequestCompOffDetail table starts---------------------------------------

	    UPDATE RequestCompOffDetail SET IsActive=0, ModifiedDate=GETDATE(), ModifiedById=@UserId 
		            WHERE LeaveRequestApplicationId=@LeaveRequestApplicationId

  --------------update RequestCompOffDetail table ends-------------------------------------------

  ----------------update RequestCompOff table starts----------------------------------------------
       CREATE TABLE #TempCoffCount 
	   (
	   Id INT IDENTITY(1,1),
	   RequestId INT,
	   )
		   DECLARE @J INT = 1;
		   INSERT INTO #TempCoffCount
		   SELECT RequestId FROM RequestCompOffDetail WHERE LeaveRequestApplicationId=@LeaveRequestApplicationId
	   
		WHILE(@J <= (SELECT COUNT(Id) FROM #TempCoffCount))
		BEGIN
			UPDATE RequestCompOff SET IsAvailed=0 
			   WHERE RequestId=(SELECT RequestId FROM #TempCoffCount WHERE Id = @J)
			SET @J = @J + 1
		END
  --------------update RequestCompOff table ends---------------------------------------------------
	  UPDATE B
      SET B.[Count] = CASE
                        WHEN M.[ShortName] = 'LWP' THEN B.[Count] - D.[Count]
                        ELSE B.[Count] + D.[Count]
                      END
	  FROM [dbo].[LeaveBalance] B WITH (NOLOCK)
	  INNER JOIN [dbo].[LeaveRequestApplication] L WITH (NOLOCK) ON L.[UserId] = B.[UserId]
      INNER JOIN [dbo].[LeaveRequestApplicationDetail] D WITH (NOLOCK) ON B.[LeaveTypeId] = D.[LeaveTypeId] AND L.[LeaveRequestApplicationId] = D.[LeaveRequestApplicationId]
      INNER JOIN [dbo].[LeaveTypeMaster] M WITH (NOLOCK) ON M.[TypeId] = D.[LeaveTypeId]
      WHERE D.[LeaveRequestApplicationId] = @LeaveRequestApplicationId		
	   
			-- make 5 CL in a year available to user
			IF EXISTS (SELECT 1 FROM [dbo].[LeaveRequestApplicationDetail] D WITH (NOLOCK) 
							INNER JOIN [dbo].[LeaveTypeMaster] M WITH (NOLOCK) ON D.[LeaveTypeId] = M.[TypeId] 
							WHERE D.[LeaveRequestApplicationId] = @LeaveRequestApplicationId AND M.[ShortName] = 'CL' AND D.[Count] > 2 )
			BEGIN
				INSERT INTO [dbo].[LeaveBalanceHistory]
				(
				[RecordId]
				,[Count]
				,[CreatedBy]
				)
				SELECT B.[RecordId],B.[Count],@UserId
				FROM [dbo].[LeaveBalance] B WITH (NOLOCK)
				INNER JOIN [dbo].[LeaveRequestApplication] A WITH (NOLOCK) ON A.[UserId] = B.[UserId]
				INNER JOIN [dbo].[LeaveTypeMaster] M WITH (NOLOCK) ON B.[LeaveTypeId] = M.[TypeId] 
				WHERE M.[ShortName] = '5CLOY' AND A.[LeaveRequestApplicationId] = @LeaveRequestApplicationId
         
				UPDATE B
				SET B.[Count] = 1
				FROM [dbo].[LeaveBalance] B
				INNER JOIN [dbo].[LeaveRequestApplication] A WITH (NOLOCK) ON A.[UserId] = B.[UserId]
				INNER JOIN [dbo].[LeaveTypeMaster] M WITH (NOLOCK) ON B.[LeaveTypeId] = M.[TypeId] 
				WHERE M.[ShortName] = '5CLOY' AND A.[LeaveRequestApplicationId] = @LeaveRequestApplicationId
			END
      END

      SELECT 'SUCCEED' AS [Result]

      COMMIT TRANSACTION;
   END TRY
  BEGIN CATCH      
      ROLLBACK TRANSACTION
      DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
      EXEC [spInsertErrorLog]
	      @ModuleName = 'LeaveManagement'
         ,@Source = 'spTakeActionOnAppliedLeave'
         ,@ErrorMessage = @ErrorMessage
         ,@ErrorType = 'SP'
         ,@ReportedByUserId = @UserId

      SELECT 'FAILURE' AS [Result]
	 
   END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[Proc_GetOutingRequestByUserId]    Script Date: 10-08-2018 17:40:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetOutingRequestByUserId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetOutingRequestByUserId]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetOutingRequestByUserId]    Script Date: 10-08-2018 17:40:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetOutingRequestByUserId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetOutingRequestByUserId] AS' 
END
GO
--Created Date      : 2018-03-21
--Created By        : Kanchan Kumari
--Purpose           : This stored procedure is used to view outing request status
--Usage				: EXEC [Proc_GetOutingRequestByUserId] 2432,2018
----------------------------------------------------------------------------
ALTER PROCEDURE [dbo].[Proc_GetOutingRequestByUserId] 
   @EmployeeId [int],
   @Year [int]=NULL
AS
BEGIN
	SET NOCOUNT ON;
	SET FMTONLY OFF;
	IF OBJECT_ID('tempdb..#OutingTable') IS NOT NULL
	DROP TABLE #OutingTable
	
	DECLARE @StartDate [date], @EndDate [date],@JoiningDate [date]
	 
	IF (@Year IS NULL OR @Year =0)
	SET @Year = DATEPART(YYYY, GETDATE())

	SELECT @StartDate=dateadd(Month,0,cast(concat(@Year,'-04-01') as date))  ,
		  @EndDate = dateadd(Year,1,cast(concat(@Year,'-03-31') as date)) ,
		  @JoiningDate= JoiningDate FROM UserDetail WHERE UserId=@EmployeeId
		 IF(DATEPART(YYYY,@JoiningDate)=DATEPART(YYYY, @StartDate) AND DATEPART(mm,@JoiningDate)<DATEPART(mm,@StartDate))
		  SELECT @StartDate=@JoiningDate

CREATE TABLE #OutingTable
(
[OutingRequestId] BIGINT NOT NULL,
[Period] VARCHAR(80),
[FromDate] DATE,
[TillDate] DATE,
[OutingType] VARCHAR(50),
[Reason] VARCHAR(500),
[StatusCode] VARCHAR(10),
[Status] VARCHAR(150),
[Remarks] VARCHAR(250),
[ApplyDate] VARCHAR(50)
)
  INSERT INTO #OutingTable ([OutingRequestId],[Period],[FromDate],[TillDate],[OutingType],[Reason],[StatusCode],[Status],[Remarks],[ApplyDate])
	SELECT 
		R.[OutingRequestId] AS [OutingRequestId]
		,CASE WHEN R.FromDateId=R.TillDateId THEN CAST(CONVERT(VARCHAR(20),DM1.[Date],106) AS Varchar(30)) 
			ELSE  CAST(CONVERT(VARCHAR(20),DM1.[Date],106) AS Varchar(30)) + '  To  ' + CAST(CONVERT(VARCHAR(20),DM2.[Date],106) AS Varchar(30) )
		 END AS [Period],
		 DM1.[Date] AS [FromDate]
		 ,DM2.[Date] AS [TillDate]
      ,T.[OutingTypeName] AS [OutingType]
	  ,R.[Reason] AS [Reason]	  
	  ,S.[StatusCode] AS [StatusCode]
	  ,S.[Status] + ' with ' + UD.[FirstName] + ' ' + UD.[LastName] AS [Status]
	  ,APR.FirstName + ' ' + APR.LastName + ': ' +  REM.[Remarks] AS [Remarks]                                                                                                                 
	  ,CONVERT(VARCHAR(20), R.CreatedDate,106) + ' ' + FORMAT(R.CreatedDate,'hh:mm tt') AS [ApplyDate]
	FROM [dbo].[OutingRequest] R WITH (NOLOCK)
	INNER JOIN [dbo].[OutingRequestStatus] S WITH (NOLOCK) ON R.[StatusId] = S.StatusId
	INNER JOIN [dbo].[OutingType] T WITH (NOLOCK) ON R.[OutingTypeId] = T.[OutingTypeId]
	INNER JOIN [dbo].[DateMaster] DM1 WITH (NOLOCK) ON R.[FromDateId] = DM1.DateId
	INNER JOIN [dbo].[DateMaster] DM2 WITH (NOLOCK) ON R.[TillDateId] = DM2.[DateId]
	INNER JOIN [dbo].[UserDetail] UD WITH (NOLOCK) ON R.[NextApproverId] = UD.[UserId] 
	INNER JOIN (SELECT OutingRequestId, MAX(OutingRequestHistoryId) AS OutingRequestHistoryId FROM OutingRequestHistory GROUP BY OutingRequestId) ORH
			ON R.OutingRequestId=ORH.OutingRequestId	
	INNER JOIN [dbo].[OutingRequestHistory] REM WITH (NOLOCK) ON ORH.OutingRequestHistoryId=REM.OutingRequestHistoryId
	INNER JOIN [dbo].[UserDetail] APR WITH (NOLOCK) ON REM.CreatedById=APR.UserId 
	WHERE R.[UserId] = @EmployeeId AND DM1.[Date] BETWEEN @StartDate AND @EndDate ORDER BY R.CreatedDate DESC

	INSERT INTO #OutingTable ([OutingRequestId],[Period],[FromDate],[TillDate],[OutingType],[Reason],[StatusCode],[Status],[Remarks],[ApplyDate])
	SELECT 
		R.[OutingRequestId] AS [OutingRequestId]
		,CASE WHEN R.FromDateId=R.TillDateId THEN CAST(CONVERT(VARCHAR(20),DM1.[Date],106) AS Varchar(30)) 
			ELSE  CAST(CONVERT(VARCHAR(20),DM1.[Date],106) AS Varchar(30)) + '  To  ' + CAST(CONVERT(VARCHAR(20),DM2.[Date],106) AS Varchar(30) )
		 END AS [Period],
		 DM1.[Date] AS [FromDate]
		 ,DM2.[Date] AS [TillDate]
      ,T.[OutingTypeName] AS [OutingType]
	  ,R.[Reason] AS [Reason]	
	  ,S.[StatusCode] AS [StatusCode]  
	  ,S.[Status] + ' by ' + UD.[FirstName] + ' ' + UD.[LastName] AS [Status]
	  ,APR.FirstName + ' ' + APR.LastName + ': ' +  REM.[Remarks] AS [Remarks]                  
	  ,CONVERT(VARCHAR(20), R.CreatedDate,106) + ' ' + FORMAT(R.CreatedDate,'hh:mm tt') AS [ApplyDate]
	FROM [dbo].[OutingRequest] R WITH (NOLOCK)
	INNER JOIN [dbo].[OutingRequestStatus] S WITH (NOLOCK) ON R.[StatusId] = S.StatusId
	INNER JOIN [dbo].[OutingType] T WITH (NOLOCK) ON R.[OutingTypeId] = T.[OutingTypeId]
	INNER JOIN [dbo].[DateMaster] DM1 WITH (NOLOCK) ON R.[FromDateId] = DM1.DateId
	INNER JOIN [dbo].[DateMaster] DM2 WITH (NOLOCK) ON R.[TillDateId] = DM2.[DateId]
	INNER JOIN [dbo].[UserDetail] UD WITH (NOLOCK) ON R.[ModifiedById] = UD.[UserId] 
	INNER JOIN (SELECT OutingRequestId, MAX(OutingRequestHistoryId) AS OutingRequestHistoryId FROM OutingRequestHistory GROUP BY OutingRequestId) ORH
			ON R.OutingRequestId=ORH.OutingRequestId	
	INNER JOIN [dbo].[OutingRequestHistory] REM WITH (NOLOCK) ON ORH.OutingRequestHistoryId=REM.OutingRequestHistoryId
	INNER JOIN [dbo].[UserDetail] APR WITH (NOLOCK) ON REM.CreatedById=APR.UserId 
	WHERE R.[UserId] = @EmployeeId  AND R.StatusId>=5 AND DM1.[Date] BETWEEN @StartDate AND @EndDate ORDER BY R.CreatedDate DESC

	SELECT [OutingRequestId],[Period],[FromDate],[TillDate],[OutingType],[Reason],[StatusCode],[Status],[Remarks],[ApplyDate] 
	FROM #OutingTable 
END
GO

