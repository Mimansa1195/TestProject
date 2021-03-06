GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GSOCProjectSubscriber_User]') AND parent_object_id = OBJECT_ID(N'[dbo].[GSOCProjectSubscriber]'))
ALTER TABLE [dbo].[GSOCProjectSubscriber] DROP CONSTRAINT [FK_GSOCProjectSubscriber_User]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GSOCProjectSubscriber_GSOCProject]') AND parent_object_id = OBJECT_ID(N'[dbo].[GSOCProjectSubscriber]'))
ALTER TABLE [dbo].[GSOCProjectSubscriber] DROP CONSTRAINT [FK_GSOCProjectSubscriber_GSOCProject]
GO
/****** Object:  Table [dbo].[GSOCProjectSubscriber]    Script Date: 25-07-2019 15:13:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GSOCProjectSubscriber]') AND type in (N'U'))
DROP TABLE [dbo].[GSOCProjectSubscriber]
GO
/****** Object:  Table [dbo].[GSOCProjectSubscriber]    Script Date: 25-07-2019 15:13:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GSOCProjectSubscriber]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[GSOCProjectSubscriber](
	[GSOCProjectSubscriberId] [int] IDENTITY(1,1) NOT NULL,
	[GSOCProjectId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[ProjectTitle] [varchar](100) NOT NULL,
	[Brief] [varchar](1000) NOT NULL,
	[ExpectedResult] [varchar](1000) NOT NULL,
	[Solution] [varchar](1000) NOT NULL,
	[TimelineDistribution] [varchar](1000) NOT NULL,
	[FuturePlans] [varchar](1000) NULL,
	[IsActive] [bit] NOT NULL CONSTRAINT [DF_GSOCProjectSubscriber_IsActive]  DEFAULT ((1)),
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_GSOCProjectSubscriber_CreatedDate]  DEFAULT (getdate()),
	[CreatedById] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedById] [int] NULL,
 CONSTRAINT [PK_GSOCProjectSubscriber] PRIMARY KEY CLUSTERED 
(
	[GSOCProjectSubscriberId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GSOCProjectSubscriber_GSOCProject]') AND parent_object_id = OBJECT_ID(N'[dbo].[GSOCProjectSubscriber]'))
ALTER TABLE [dbo].[GSOCProjectSubscriber]  WITH CHECK ADD  CONSTRAINT [FK_GSOCProjectSubscriber_GSOCProject] FOREIGN KEY([GSOCProjectId])
REFERENCES [dbo].[GSOCProject] ([GSOCProjectId])
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GSOCProjectSubscriber_GSOCProject]') AND parent_object_id = OBJECT_ID(N'[dbo].[GSOCProjectSubscriber]'))
ALTER TABLE [dbo].[GSOCProjectSubscriber] CHECK CONSTRAINT [FK_GSOCProjectSubscriber_GSOCProject]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GSOCProjectSubscriber_User]') AND parent_object_id = OBJECT_ID(N'[dbo].[GSOCProjectSubscriber]'))
ALTER TABLE [dbo].[GSOCProjectSubscriber]  WITH CHECK ADD  CONSTRAINT [FK_GSOCProjectSubscriber_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([UserId])
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GSOCProjectSubscriber_User]') AND parent_object_id = OBJECT_ID(N'[dbo].[GSOCProjectSubscriber]'))
ALTER TABLE [dbo].[GSOCProjectSubscriber] CHECK CONSTRAINT [FK_GSOCProjectSubscriber_User]
GO


---------------------------------
ALTER TABLE GSOCProject ALTER COLUMN FilePath VARCHAR(500) NULL
