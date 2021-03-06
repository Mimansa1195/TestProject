GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GSOCProjectSubscriber_User]') AND parent_object_id = OBJECT_ID(N'[dbo].[GSOCProjectSubscriber]'))
ALTER TABLE [dbo].[GSOCProjectSubscriber] DROP CONSTRAINT [FK_GSOCProjectSubscriber_User]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GSOCProjectSubscriber_GSOCProject]') AND parent_object_id = OBJECT_ID(N'[dbo].[GSOCProjectSubscriber]'))
ALTER TABLE [dbo].[GSOCProjectSubscriber] DROP CONSTRAINT [FK_GSOCProjectSubscriber_GSOCProject]
GO
/****** Object:  Table [dbo].[GSOCProjectSubscriber]    Script Date: 19-07-2019 16:49:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GSOCProjectSubscriber]') AND type in (N'U'))
DROP TABLE [dbo].[GSOCProjectSubscriber]
GO
/****** Object:  Table [dbo].[GSOCProject]    Script Date: 19-07-2019 16:49:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GSOCProject]') AND type in (N'U'))
DROP TABLE [dbo].[GSOCProject]
GO
/****** Object:  Table [dbo].[GSOCProject]    Script Date: 19-07-2019 16:49:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GSOCProject]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[GSOCProject](
	[GSOCProjectId] [int] IDENTITY(1,1) NOT NULL,
	[ProjectName] [varchar](500) NOT NULL,
	[Description] [varchar](500) NOT NULL,
	[FilePath] [varchar](500) NOT NULL,
	[IsActive] [bit] NOT NULL CONSTRAINT [DF_GSOCProject_IsActive]  DEFAULT ((1)),
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_GSOCProject_CreatedDate]  DEFAULT (getdate()),
	[CreatedById] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedById] [int] NULL,
 CONSTRAINT [PK_GSOCProject] PRIMARY KEY CLUSTERED 
(
	[GSOCProjectId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[GSOCProjectSubscriber]    Script Date: 19-07-2019 16:49:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GSOCProjectSubscriber]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[GSOCProjectSubscriber](
	[GSOCProjectSubscriberId] [int] IDENTITY(1,1) NOT NULL,
	[GSOCProjectId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[Comments] [varchar](500) NOT NULL,
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


----------------------------------------
ALTER TABLE news
ADD Link VARCHAR(500) NULL;

ALTER TABLE news
ADD IsPublic BIT DEFAULT(1) NOT NULL;


INSERT INTO Menu (ParentMenuId,MenuName,ControllerName,ActionName,[Sequence],IsLinkEnabled,IsVisible,CssClass)
values(0,'Techno Club','TechnoClub','Index',1,1,1,'fa fa-lightbulb')
--SELECT MenuId from Menu where ControllerName='TechnoClub' and parentmenuid=0
INSERT INTO Menu (ParentMenuId,MenuName,ControllerName,ActionName,[Sequence],IsLinkEnabled,IsVisible)
values((SELECT MenuId from Menu where ControllerName='TechnoClub' and parentmenuid=0),'GSOC','TechnoClub','GSOC',1,1,1)