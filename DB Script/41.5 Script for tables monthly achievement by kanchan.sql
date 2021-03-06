IF OBJECT_ID('PimcoMonthlyAchievementDetail') IS NOT NULL
DROP TABLE PimcoMonthlyAchievementDetail

IF OBJECT_ID('PimcoMonthlyAchievement') IS NOT NULL
DROP TABLE PimcoMonthlyAchievement

IF OBJECT_ID('PimcoProjects') IS NOT NULL
DROP TABLE PimcoProjects

CREATE TABLE PimcoProjects
(
PimcoProjectId INT IDENTITY(1,1) NOT NULL,
Name VARCHAR(100) NOT NULL,
[Description] VARCHAR(200) NULL,
[TechTeam] VARCHAR(100) NULL,
IsActive BIT NOT NULL,
CreatedDate DATETIME NOT NULL,
CreatedBy INT NOT NULL,
ModifiedDate DATETIME NULL,
ModifiedBy INT NULL,
PRIMARY KEY CLUSTERED 
(
	[PimcoProjectId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE PimcoProjects ADD CONSTRAINT DF_PimcoProjects_IsActive DEFAULT(1) FOR IsActive
GO
ALTER TABLE PimcoProjects ADD CONSTRAINT DF_PimcoProjects_CreatedDate DEFAULT(GETDATE()) FOR CreatedDate
GO


/****** Object:  Table [dbo].[PimcoMonthlyAchievement]    Script Date: 28-05-2019 14:26:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PimcoMonthlyAchievement](
	[PimcoAchievementId] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[FYStartYear] [int] NOT NULL,
	[Month] [int] NOT NULL,
	[IsActive] [bit] NOT NULL DEFAULT ((1)),
	[ToBeDiscussedWithHR] [bit] NOT NULL DEFAULT ((0)),
	[EmpComments] [varchar](500) NULL,
	[RMComments] [varchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL DEFAULT (getdate()),
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[PimcoAchievementId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PimcoMonthlyAchievementDetail]    Script Date: 28-05-2019 14:26:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PimcoMonthlyAchievementDetail](
	[PimcoAchievementDetailId] [bigint] IDENTITY(1,1) NOT NULL,
	[PimcoProjectId] INT NOT NULL,
	[PimcoAchievementId] [bigint] NOT NULL,
	[Achievement] [varchar](500) NOT NULL,
	[IsActive] [bit] NOT NULL DEFAULT ((1)),
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL DEFAULT (getdate()),
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[PimcoAchievementDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PimcoMonthlyAchievementDetail]  WITH CHECK ADD CONSTRAINT FK_PimcoMonthlyAchievementDetail_PimcoProjects_PimcoProjectId FOREIGN KEY(PimcoProjectId)
REFERENCES [dbo].[PimcoProjects] (PimcoProjectId)
GO
ALTER TABLE [dbo].[PimcoMonthlyAchievement]  WITH CHECK ADD CONSTRAINT FK_PimcoMonthlyAchievement_User_UserId FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([UserId])
GO
ALTER TABLE [dbo].[PimcoMonthlyAchievementDetail]  WITH CHECK ADD CONSTRAINT FK_PimcoMonthlyAchievementDetail_PimcoMonthlyAchievement_PimcoAchievementId FOREIGN KEY([PimcoAchievementId])
REFERENCES [dbo].[PimcoMonthlyAchievement] ([PimcoAchievementId])
GO

ALTER TABLE [PimcoAchievementDetail] ADD ProjectId INT NULL 
GO
ALTER TABLE [PimcoAchievementDetail] ADD CONSTRAINT FK_PimcoAchievementDetail_ProjectId 
FOREIGN KEY(ProjectId) REFERENCES PimcoProjects(PimcoProjectId) 
