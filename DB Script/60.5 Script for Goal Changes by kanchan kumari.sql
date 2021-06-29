IF OBJECT_ID('GoalCategory') IS NOT NULL
DROP TABLE [GoalCategory]
GO

/****** Object:  Table [dbo].[GoalCategory]    Script Date: 27-07-2020 11:54:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[GoalCategory](
	[GoalCategoryId] [int] IDENTITY(1,1) NOT NULL,
	[Category] [varchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL CONSTRAINT [DF_GoalCategory_IsActive]  DEFAULT ((1)),
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_GoalCategory_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[LastModifiedDate] [datetime] NULL,
	[LastModifiedBy] [int] NULL,
 CONSTRAINT [PK_GoalCategory_GoalCategoryId] PRIMARY KEY CLUSTERED 
(
	[GoalCategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[GoalCategory]  WITH CHECK ADD  CONSTRAINT [FK_GoalCategory_User_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[User] ([UserId])
GO

ALTER TABLE [dbo].[GoalCategory] CHECK CONSTRAINT [FK_GoalCategory_User_CreatedBy]
GO

ALTER TABLE [dbo].[GoalCategory]  WITH CHECK ADD  CONSTRAINT [FK_GoalCategory_User_LastModifiedBy] FOREIGN KEY([LastModifiedBy])
REFERENCES [dbo].[User] ([UserId])
GO

ALTER TABLE [dbo].[GoalCategory] CHECK CONSTRAINT [FK_GoalCategory_User_LastModifiedBy]
GO

INSERT INTO [GoalCategory]([Category], [CreatedBy])
VALUES('Work Related', 1),('Learning', 1),('Creative/ Developmental', 1)
GO

ALTER TABLE UserGoal ADD [GoalCategoryId] INT NULL ;
GO

UPDATE UserGoal SET [GoalCategoryId] = 1 
GO

ALTER TABLE UserGoal ADD CONSTRAINT FK_UserGoal_GoalCategory_GoalCategoryId 
FOREIGN KEY (GoalCategoryId) REFERENCES GoalCategory(GoalCategoryId) 
GO

ALTER TABLE [dbo].[UserGoal] CHECK CONSTRAINT [FK_UserGoal_GoalCategory_GoalCategoryId]
GO

ALTER TABLE UserGoal ALTER COLUMN [GoalCategoryId] INT NOT NULL;
GO

ALTER TABLE UserGoalHistory ADD [GoalCategoryId] INT NULL ;
GO

UPDATE UserGoalHistory SET [GoalCategoryId] = 1 
GO

ALTER TABLE UserGoalHistory ADD CONSTRAINT FK_UserGoalHistory_GoalCategory_GoalCategoryId 
FOREIGN KEY (GoalCategoryId) REFERENCES GoalCategory(GoalCategoryId) 
GO

ALTER TABLE [dbo].[UserGoalHistory] CHECK CONSTRAINT [FK_UserGoalHistory_GoalCategory_GoalCategoryId]
GO

ALTER TABLE UserGoalHistory ALTER COLUMN [GoalCategoryId] INT NOT NULL;


