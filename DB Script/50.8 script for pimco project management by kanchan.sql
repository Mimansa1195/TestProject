/****** Object:  Table [dbo].[PimcoProjectVertical]    Script Date: 17-12-2019 14:17:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[PimcoProjectVertical](
	[VerticalId] [bigint] IDENTITY(1,1) NOT NULL,
	[Vertical] [varchar](200) NOT NULL,
	[OwnerId] [int] NOT NULL CONSTRAINT [DF_PimcoProjectVertical_OwnerId]  DEFAULT ((0)),
	[IsActive] [bit] NOT NULL CONSTRAINT [DF_PimcoProjectVertical_IsActive]  DEFAULT ((1)),
	[IsDeleted] [bit] NOT NULL CONSTRAINT [DF_PimcoProjectVertical_IsDeleted]  DEFAULT ((0)),
	[CreatedDate] [date] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[LastModifiedDate] [date] NULL,
	[LastModifiedBy] [int] NULL,
 CONSTRAINT [PK_PimcoProjectVertical] PRIMARY KEY CLUSTERED 
(
	[VerticalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[PimcoProjectVertical]  WITH CHECK ADD  CONSTRAINT [FK_PimcoProjectVertical_User_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[User] ([UserId])
GO

ALTER TABLE [dbo].[PimcoProjectVertical] CHECK CONSTRAINT [FK_PimcoProjectVertical_User_CreatedBy]
GO

INSERT INTO PimcoProjectVertical(Vertical, OwnerId, CreatedBy, CreatedDate)
SELECT DISTINCT TechTeam, 1,1, GETDATE() FROM PimcoProjects

----------ParentProjectId

ALTER TABLE [PimcoProjects] ADD [ParentProjectId] INT NULL 
GO

UPDATE [PimcoProjects] SET [ParentProjectId] = 0 
GO

ALTER TABLE [PimcoProjects] ALTER COLUMN [ParentProjectId] INT NOT NULL 
GO

ALTER TABLE [PimcoProjects] ADD CONSTRAINT DF_PimcoProjects_ParentProjectId DEFAULT(0) FOR ParentProjectId
GO
--------[StartDate], [EndDate]

ALTER TABLE [PimcoProjects] ADD [StartDate] DATE  NULL 
GO

UPDATE [PimcoProjects] SET [StartDate] = DATEADD(m,-1,GETDATE())
GO

ALTER TABLE [PimcoProjects] ALTER COLUMN [StartDate] DATE NOT NULL 
GO

ALTER TABLE [PimcoProjects] ADD [EndDate] DATE NULL 
GO


--------[VerticalId]

ALTER TABLE [PimcoProjects] ADD [VerticalId] BIGINT NULL 
GO

UPDATE P  SET P.[VerticalId] = V.VerticalId FROM [PimcoProjects] P JOIN PimcoProjectVertical V ON P.[TechTeam] = V.[Vertical]
GO

ALTER TABLE [PimcoProjects] ALTER COLUMN [VerticalId] BIGINT NOT NULL 
GO

ALTER TABLE [dbo].[PimcoProjects]  WITH CHECK ADD  CONSTRAINT [FK_PimcoProjects_PimcoProjectVertical_VerticalId] FOREIGN KEY([VerticalId])
REFERENCES [dbo].[PimcoProjectVertical] ([VerticalId])
GO

ALTER TABLE [dbo].[PimcoProjects] CHECK CONSTRAINT [FK_PimcoProjects_PimcoProjectVertical_VerticalId]
GO

---StatusId

ALTER TABLE [PimcoProjects] ADD [StatusId] BIGINT NULL 
GO
UPDATE [PimcoProjects]  SET [StatusId] = 1
GO
ALTER TABLE [PimcoProjects] ALTER COLUMN [StatusId] BIGINT NOT NULL 
GO
ALTER TABLE [dbo].[PimcoProjects]  WITH CHECK ADD  CONSTRAINT [FK_PimcoProjects_ProjectStatus_StatusId] FOREIGN KEY([StatusId])
REFERENCES [dbo].[ProjectStatus] ([ProjectStatusId])
GO

ALTER TABLE [dbo].[PimcoProjects] CHECK CONSTRAINT [FK_PimcoProjects_ProjectStatus_StatusId]
GO
 

/***
   Created Date      :    17-Dec-2019
   Created By        :    Kanchan Kumari
   Purpose           :    This stored procedure retrives root pimcp projects for a user
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   --- Test Case 1
         EXEC [dbo].[spFetchPimcoRootProjects] @UserId = 22
***/
CREATE PROCEDURE [dbo].[spFetchPimcoRootProjects]
   @UserId [int]
AS
BEGIN
   DECLARE @UserRoleId INT = (SELECT [RoleId] FROM [User] WHERE [UserId]= @UserId)

   IF(@UserRoleId = 1)--Web Administrator
   BEGIN
	    ;WITH ProjectTree([ProjectId], [ProjectName],  [Role], [Level])
	   AS
	   (
		  SELECT 
			P.[PimcoProjectId] AS [ProjectId]
		   ,P.[Name]      AS [ProjectName]
		   ,PT.[ProjectRole]     AS [Role]
		   ,0             AS [Level]
		  FROM [dbo].[PimcoProjects] P WITH (NOLOCK)
		  INNER JOIN [dbo].[PimcoProjectTeamMembers] PT WITH (NOLOCK) ON P.[PimcoProjectId] = PT.[PimcoProjectId]
		  WHERE 
			  PT.[ProjectRole] ='Project Owner'
			 AND PT.[IsActive] = 1
		  GROUP BY P.[PimcoProjectId], P.[Name], PT.[ProjectRole]
		  UNION ALL
		  SELECT 
			P.[PimcoProjectId] AS [ProjectId]
		   ,P.[Name]      AS [ProjectName]
		   ,PT.[Role] AS [Role]
		   ,[Level] + 1   AS [Level]
		  FROM [dbo].[PimcoProjects] P WITH (NOLOCK)
		  INNER JOIN [ProjectTree] PT ON P.[ParentProjectId] = PT.[ProjectId]
	   )
	   SELECT 
		  PT.[ProjectId]
		 ,PT.[ProjectName]
		 ,PT.[Role]
	   FROM [ProjectTree] PT
			 INNER JOIN
			 (
				SELECT
				   PT.[ProjectId]  AS [ProjectId]
				  ,MAX(PT.[Level]) AS [Level]
				FROM [ProjectTree] PT
				GROUP BY PT.[ProjectId]
			 ) MPT 
				ON PT.[ProjectId] = MPT.[ProjectId]
				AND PT.[Level] = MPT.[Level]
	   WHERE PT.[Level] = 0
	   ORDER BY PT.[ProjectName]
   END

   ELSE
   BEGIN
	   ;WITH ProjectTree([ProjectId], [ProjectName],  [Role], [Level])
	   AS
	   (
		  SELECT 
			P.[PimcoProjectId] AS [ProjectId]
		   ,P.[Name]      AS [ProjectName]
		   ,PT.[ProjectRole]     AS [Role]
		   ,0             AS [Level]
		  FROM [dbo].[PimcoProjects] P WITH (NOLOCK)
		  INNER JOIN [dbo].[PimcoProjectTeamMembers] PT WITH (NOLOCK) ON P.[PimcoProjectId] = PT.[PimcoProjectId]
		  INNER JOIN [dbo].[User] U WITH (NOLOCK) ON PT.[UserId] = U.[UserId]
		  WHERE 
			 (PT.[UserId] = @UserId)
			 AND PT.[ProjectRole] IN ('Project Owner', 'Team Leader')
			 AND PT.[IsActive] = 1
		  UNION ALL
		  SELECT 
			P.[PimcoProjectId] AS [ProjectId]
		   ,P.[Name]      AS [ProjectName]
		   ,PT.[Role]     AS [Role]
		   ,[Level] + 1   AS [Level]
		  FROM [dbo].[PimcoProjects] P WITH (NOLOCK)
		  INNER JOIN [ProjectTree] PT ON P.[ParentProjectId] = PT.[ProjectId]
	   )
	   SELECT 
		  PT.[ProjectId]
		 ,PT.[ProjectName]
		 ,PT.[Role]
	   FROM [ProjectTree] PT
			 INNER JOIN
			 (
				SELECT
				   PT.[ProjectId]  AS [ProjectId]
				  ,MAX(PT.[Level]) AS [Level]
				FROM [ProjectTree] PT
				GROUP BY PT.[ProjectId]
			 ) MPT 
				ON PT.[ProjectId] = MPT.[ProjectId]
				AND PT.[Level] = MPT.[Level]
	   WHERE PT.[Level] = 0
	   ORDER BY PT.[ProjectName]
   END
END