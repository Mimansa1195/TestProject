IF OBJECT_ID('TeamGoalComment') IS NOT NULL
DROP TABLE TeamGoalComment
GO

IF OBJECT_ID('TeamGoalHistory') IS NOT NULL
DROP TABLE TeamGoalHistory
GO

IF OBJECT_ID('TeamGoal') IS NOT NULL
DROP TABLE TeamGoal

/****** Object:  Table [dbo].[TeamGoal]    Script Date: 28-07-2020 12:02:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TeamGoal](
	[TeamGoalId] [bigint] IDENTITY(1,1) NOT NULL,
	[TeamId] [bigint] NOT NULL,
	[AppraisalCycleId] [int] NULL,
	[StartDateId] [bigint] NOT NULL,
	[EndDateId] [bigint] NOT NULL,
	[Goal] [varchar](max) NOT NULL,
	[IsActive] [bit] NOT NULL CONSTRAINT [DF_TeamGoal_IsActive]  DEFAULT ((1)),
	[OtherRemark] [varchar](4000) NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_TeamGoal_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[LastModifiedDate] [datetime] NULL,
	[LastModifiedBy] [int] NULL,
	[GoalStatusId] [bigint] NOT NULL,
	[GoalCategoryId] [int] NOT NULL,
 CONSTRAINT [PK_TeamGoal] PRIMARY KEY CLUSTERED 
(
	[TeamGoalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TeamGoal]  WITH CHECK ADD  CONSTRAINT [FK_TeamGoal_AppraisalCycle_AppraisalCycleId] FOREIGN KEY([AppraisalCycleId])
REFERENCES [dbo].[AppraisalCycle] ([AppraisalCycleId])
GO

ALTER TABLE [dbo].[TeamGoal] CHECK CONSTRAINT [FK_TeamGoal_AppraisalCycle_AppraisalCycleId]
GO

ALTER TABLE [dbo].[TeamGoal]  WITH CHECK ADD  CONSTRAINT [FK_TeamGoal_DateMaster_EndDateId] FOREIGN KEY([EndDateId])
REFERENCES [dbo].[DateMaster] ([DateId])
GO

ALTER TABLE [dbo].[TeamGoal] CHECK CONSTRAINT [FK_TeamGoal_DateMaster_EndDateId]
GO

ALTER TABLE [dbo].[TeamGoal]  WITH CHECK ADD  CONSTRAINT [FK_TeamGoal_DateMaster_StartDateId] FOREIGN KEY([StartDateId])
REFERENCES [dbo].[DateMaster] ([DateId])
GO

ALTER TABLE [dbo].[TeamGoal] CHECK CONSTRAINT [FK_TeamGoal_DateMaster_StartDateId]
GO

ALTER TABLE [dbo].[TeamGoal]  WITH CHECK ADD  CONSTRAINT [FK_TeamGoal_GoalCategory_GoalCategoryId] FOREIGN KEY([GoalCategoryId])
REFERENCES [dbo].[GoalCategory] ([GoalCategoryId])
GO

ALTER TABLE [dbo].[TeamGoal] CHECK CONSTRAINT [FK_TeamGoal_GoalCategory_GoalCategoryId]
GO

ALTER TABLE [dbo].[TeamGoal]  WITH CHECK ADD  CONSTRAINT [FK_TeamGoal_User_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[User] ([UserId])
GO

ALTER TABLE [dbo].[TeamGoal] CHECK CONSTRAINT [FK_TeamGoal_User_CreatedBy]
GO

ALTER TABLE [dbo].[TeamGoal]  WITH CHECK ADD  CONSTRAINT [FK_TeamGoal_Team_TeamId] FOREIGN KEY([TeamId])
REFERENCES [dbo].[Team] ([TeamId])
GO

ALTER TABLE [dbo].[TeamGoal] CHECK CONSTRAINT [FK_TeamGoal_Team_TeamId]
GO



/****** Object:  Table [dbo].[TeamGoalComment]    Script Date: 28-07-2020 12:07:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TeamGoalComment](
	[TeamGoalCommentId] [bigint] IDENTITY(1,1) NOT NULL,
	[TeamGoalId] [bigint] NOT NULL,
	[SelfComment] [varchar](5000) NULL,
	[AppraiserComment] [varchar](5000) NULL,
	[ApproverComment] [varchar](5000) NULL,
	[CreatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_TeamGoalComment] PRIMARY KEY CLUSTERED 
(
	[TeamGoalCommentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TeamGoalComment] ADD  CONSTRAINT [DF_TeamGoalComment_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[TeamGoalComment]  WITH CHECK ADD  CONSTRAINT [FK_TeamGoalComment_TeamGoal_TeamGoalId] FOREIGN KEY([TeamGoalId])
REFERENCES [dbo].[TeamGoal] ([TeamGoalId])
GO

ALTER TABLE [dbo].[TeamGoalComment] CHECK CONSTRAINT [FK_TeamGoalComment_TeamGoal_TeamGoalId]
GO



/****** Object:  Table [dbo].[TeamGoalHistory]    Script Date: 28-07-2020 12:08:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TeamGoalHistory](
	[TeamGoalHistoryId] [bigint] IDENTITY(1,1) NOT NULL,
	[TeamGoalId] [bigint] NOT NULL,
	[StartDateId] [bigint] NOT NULL,
	[EndDateId] [bigint] NOT NULL,
	[Goal] [varchar](max) NOT NULL,
	[GoalStatusId] [bigint] NOT NULL,
	[Remarks] [varchar](4000) NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_TeamGoalHistory_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[GoalCategoryId] [int] NOT NULL,
 CONSTRAINT [PK_TeamGoalHistory] PRIMARY KEY CLUSTERED 
(
	[TeamGoalHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TeamGoalHistory]  WITH CHECK ADD  CONSTRAINT [FK_TeamGoalHistory_DateMaster_EndDateId] FOREIGN KEY([EndDateId])
REFERENCES [dbo].[DateMaster] ([DateId])
GO

ALTER TABLE [dbo].[TeamGoalHistory] CHECK CONSTRAINT [FK_TeamGoalHistory_DateMaster_EndDateId]
GO

ALTER TABLE [dbo].[TeamGoalHistory]  WITH CHECK ADD  CONSTRAINT [FK_TeamGoalHistory_DateMaster_StartDateId] FOREIGN KEY([StartDateId])
REFERENCES [dbo].[DateMaster] ([DateId])
GO

ALTER TABLE [dbo].[TeamGoalHistory] CHECK CONSTRAINT [FK_TeamGoalHistory_DateMaster_StartDateId]
GO

ALTER TABLE [dbo].[TeamGoalHistory]  WITH CHECK ADD  CONSTRAINT [FK_TeamGoalHistory_GoalCategory_GoalCategoryId] FOREIGN KEY([GoalCategoryId])
REFERENCES [dbo].[GoalCategory] ([GoalCategoryId])
GO

ALTER TABLE [dbo].[TeamGoalHistory] CHECK CONSTRAINT [FK_TeamGoalHistory_GoalCategory_GoalCategoryId]
GO

ALTER TABLE [dbo].[TeamGoalHistory]  WITH CHECK ADD  CONSTRAINT [FK_TeamGoalHistory_GoalStatus_GoalStatusId] FOREIGN KEY([GoalStatusId])
REFERENCES [dbo].[GoalStatus] ([GoalStatusId])
GO

ALTER TABLE [dbo].[TeamGoalHistory] CHECK CONSTRAINT [FK_TeamGoalHistory_GoalStatus_GoalStatusId]
GO

ALTER TABLE [dbo].[TeamGoalHistory]  WITH CHECK ADD  CONSTRAINT [FK_TeamGoalHistory_User_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[User] ([UserId])
GO

ALTER TABLE [dbo].[TeamGoalHistory] CHECK CONSTRAINT [FK_TeamGoalHistory_User_CreatedBy]
GO


