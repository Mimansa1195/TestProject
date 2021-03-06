
GO
ALTER TABLE [dbo].[OutingRequestStatus] DROP CONSTRAINT [FK_[OutingRequestStatus_User_ModifiedById]
GO
ALTER TABLE [dbo].[OutingRequestStatus] DROP CONSTRAINT [FK_[OutingRequestStatus_User_CreatedById]
GO
ALTER TABLE [dbo].[OutingRequestHistory] DROP CONSTRAINT [FK_OutingRequestHistory_User_CreatedById]
GO
ALTER TABLE [dbo].[OutingRequestHistory] DROP CONSTRAINT [FK_OutingRequestHistory_OutingRequestStatus_StatusId]
GO
ALTER TABLE [dbo].[OutingRequestHistory] DROP CONSTRAINT [FK_OutingRequestHistory_OutingRequest_OutingRequestId]
GO
ALTER TABLE [dbo].[OutingRequestDetail] DROP CONSTRAINT [FK_OutingRequestDetail_OutingRequestStatus_StatusId]
GO
ALTER TABLE [dbo].[OutingRequestDetail] DROP CONSTRAINT [FK_OutingRequestDetail_OutingRequest_OutingRequestId]
GO
ALTER TABLE [dbo].[OutingRequest] DROP CONSTRAINT [FK_OutingRequest_User_NextApproverId]
GO
ALTER TABLE [dbo].[OutingRequest] DROP CONSTRAINT [FK_OutingRequest_User_CreatedById]
GO
ALTER TABLE [dbo].[OutingRequest] DROP CONSTRAINT [FK_OutingRequest_User]
GO
ALTER TABLE [dbo].[OutingRequest] DROP CONSTRAINT [FK_OutingRequest_OutingType_OutingTypeId]
GO
ALTER TABLE [dbo].[OutingRequest] DROP CONSTRAINT [FK_OutingRequest_OutingRequestStatus_StatusId]
GO
ALTER TABLE [dbo].[OutingRequest] DROP CONSTRAINT [FK_OutingRequest_DateMaster_TillDateId]
GO
ALTER TABLE [dbo].[OutingRequest] DROP CONSTRAINT [FK_OutingRequest_DateMaster_FromDateId]
GO
ALTER TABLE [dbo].[LegitimateLeaveStatus] DROP CONSTRAINT [FK_LegitimateLeaveStatus_User_ModifiedById]
GO
ALTER TABLE [dbo].[LegitimateLeaveStatus] DROP CONSTRAINT [FK_LegitimateLeaveStatus_User_CreatedById]
GO
ALTER TABLE [dbo].[LegitimateLeaveRequestHistory] DROP CONSTRAINT [FK_LegitimateLeaveRequestHistory_User_CreatedBy]
GO
ALTER TABLE [dbo].[LegitimateLeaveRequestHistory] DROP CONSTRAINT [FK_LegitimateLeaveRequestHistory_LegitimateLeaveStatus_StatusId]
GO
ALTER TABLE [dbo].[LegitimateLeaveRequestHistory] DROP CONSTRAINT [FK_LegitimateLeaveRequestHistory_LegitimateLeaveRequest_LegitimateLeaveRequestId]
GO
ALTER TABLE [dbo].[LegitimateLeaveRequestHistory] DROP CONSTRAINT [FK_LegitimateLeaveRequestHistory_DateMaster_DateId]
GO
ALTER TABLE [dbo].[LegitimateLeaveRequest] DROP CONSTRAINT [FK_LegitimateLeaveRequestHistory_User_LastModifiedBy]
GO
ALTER TABLE [dbo].[LegitimateLeaveRequest] DROP CONSTRAINT [FK_LegitimateLeaveRequest_User_UserId]
GO
ALTER TABLE [dbo].[LegitimateLeaveRequest] DROP CONSTRAINT [FK_LegitimateLeaveRequest_User_NextApproverId]
GO
ALTER TABLE [dbo].[LegitimateLeaveRequest] DROP CONSTRAINT [FK_LegitimateLeaveRequest_User_LastModifiedBy]
GO
ALTER TABLE [dbo].[LegitimateLeaveRequest] DROP CONSTRAINT [FK_LegitimateLeaveRequest_User_CreatedBy]
GO
ALTER TABLE [dbo].[LegitimateLeaveRequest] DROP CONSTRAINT [FK_LegitimateLeaveRequest_LegitimateLeaveStatus_StatusId]
GO
ALTER TABLE [dbo].[LegitimateLeaveRequest] DROP CONSTRAINT [FK_LegitimateLeaveRequest_LeaveRequestApplication_LeaveRequestApplicationId]
GO
ALTER TABLE [dbo].[LegitimateLeaveRequest] DROP CONSTRAINT [FK_LegitimateLeaveRequest_DateMaster_DateId]
GO
/****** Object:  Table [dbo].[OutingType]    Script Date: 2/5/18 12:01:49 PM ******/
DROP TABLE [dbo].[OutingType]
GO
/****** Object:  Table [dbo].[OutingRequestStatus]    Script Date: 2/5/18 12:01:49 PM ******/
DROP TABLE [dbo].[OutingRequestStatus]
GO
/****** Object:  Table [dbo].[OutingRequestHistory]    Script Date: 2/5/18 12:01:49 PM ******/
DROP TABLE [dbo].[OutingRequestHistory]
GO
/****** Object:  Table [dbo].[OutingRequestDetail]    Script Date: 2/5/18 12:01:49 PM ******/
DROP TABLE [dbo].[OutingRequestDetail]
GO
/****** Object:  Table [dbo].[OutingRequest]    Script Date: 2/5/18 12:01:49 PM ******/
DROP TABLE [dbo].[OutingRequest]
GO
/****** Object:  Table [dbo].[LegitimateLeaveStatus]    Script Date: 2/5/18 12:01:49 PM ******/
DROP TABLE [dbo].[LegitimateLeaveStatus]
GO
/****** Object:  Table [dbo].[LegitimateLeaveRequestHistory]    Script Date: 2/5/18 12:01:49 PM ******/
DROP TABLE [dbo].[LegitimateLeaveRequestHistory]
GO
/****** Object:  Table [dbo].[LegitimateLeaveRequest]    Script Date: 2/5/18 12:01:49 PM ******/
DROP TABLE [dbo].[LegitimateLeaveRequest]
GO
/****** Object:  Table [dbo].[LegitimateLeaveRequest]    Script Date: 2/5/18 12:01:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LegitimateLeaveRequest](
	[LegitimateLeaveRequestId] [bigint] IDENTITY(1,1) NOT NULL,
	[LeaveRequestApplicationId] [bigint] NOT NULL,
	[UserId] [int] NOT NULL,
	[DateId] [bigint] NOT NULL,
	[Reason] [varchar](500) NOT NULL,
	[LeaveCombination] [varchar](100) NULL,
	[StatusId] [bigint] NOT NULL CONSTRAINT [DF_LegitimateLeaveRequest_StatusId]  DEFAULT ((2)),
	[NextApproverId] [int] NULL,
	[Remarks] [varchar](500) NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_LegitimateLeaveRequest_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[LastModifiedDate] [datetime] NULL,
	[LastModifiedBy] [int] NULL,
 CONSTRAINT [PK_LegitimateLeaveRequest] PRIMARY KEY CLUSTERED 
(
	[LegitimateLeaveRequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LegitimateLeaveRequestHistory]    Script Date: 2/5/18 12:01:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LegitimateLeaveRequestHistory](
	[LegitimateLeaveRequestHistoryId] [bigint] IDENTITY(1,1) NOT NULL,
	[LegitimateLeaveRequestId] [bigint] NOT NULL,
	[DateId] [bigint] NOT NULL,
	[Reason] [varchar](500) NOT NULL,
	[StatusId] [bigint] NOT NULL CONSTRAINT [DF_LegitimateLeaveRequestHistory_StatusId]  DEFAULT ((1)),
	[Remarks] [varchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_LegitimateLeaveRequestHistory_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_LegitimateLeaveRequestHistory] PRIMARY KEY CLUSTERED 
(
	[LegitimateLeaveRequestHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LegitimateLeaveStatus]    Script Date: 2/5/18 12:01:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LegitimateLeaveStatus](
	[StatusId] [bigint] IDENTITY(1,1) NOT NULL,
	[Status] [varchar](50) NOT NULL,
	[StatusCode] [varchar](20) NOT NULL,
	[Description] [varchar](500) NOT NULL,
	[IsActive] [bit] NOT NULL CONSTRAINT [DF_LegitimateLeaveStatus_IsActive]  DEFAULT ((1)),
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_LegitimateLeaveStatus_CreatedDate]  DEFAULT (getdate()),
	[CreatedById] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedById] [int] NULL,
 CONSTRAINT [PK_LegitimateLeaveStatus] PRIMARY KEY CLUSTERED 
(
	[StatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[OutingRequest]    Script Date: 2/5/18 12:01:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[OutingRequest](
	[OutingRequestId] [bigint] IDENTITY(1,1) NOT NULL,
	[OutingTypeId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[FromDateId] [bigint] NOT NULL,
	[TillDateId] [bigint] NOT NULL,
	[Reason] [varchar](500) NULL,
	[PrimaryContactNo] [varchar](15) NULL,
	[AlternativeContactNo] [varchar](15) NULL,
	[StatusId] [bigint] NOT NULL CONSTRAINT [DF_OutingRequest_StatusId]  DEFAULT ((2)),
	[NextApproverId] [int] NULL,
	[IsActive] [bit] NOT NULL CONSTRAINT [DF_OutingRequest_IsActive]  DEFAULT ((1)),
	[IsDeleted] [bit] NOT NULL CONSTRAINT [DF_OutingRequest_IsDeleted]  DEFAULT ((0)),
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_OutingRequest_CreatedDate]  DEFAULT (getdate()),
	[CreatedById] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedById] [int] NULL,
 CONSTRAINT [PK_OutingRequest] PRIMARY KEY CLUSTERED 
(
	[OutingRequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[OutingRequestDetail]    Script Date: 2/5/18 12:01:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OutingRequestDetail](
	[OutingRequestDetailId] [bigint] IDENTITY(1,1) NOT NULL,
	[OutingRequestId] [bigint] NOT NULL,
	[DateId] [int] NULL,
	[StatusId] [bigint] NOT NULL CONSTRAINT [DF_OutingRequestDetail_StatusId]  DEFAULT ((2)),
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_OutingRequestDetail_CreatedDate]  DEFAULT (getdate()),
	[CreatedById] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedById] [int] NULL,
 CONSTRAINT [PK_OutingRequestDetail] PRIMARY KEY CLUSTERED 
(
	[OutingRequestDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OutingRequestHistory]    Script Date: 2/5/18 12:01:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[OutingRequestHistory](
	[OutingRequestHistoryId] [bigint] IDENTITY(1,1) NOT NULL,
	[OutingRequestId] [bigint] NOT NULL,
	[StatusId] [bigint] NOT NULL CONSTRAINT [DF_OutingRequestHistory_StatusId]  DEFAULT ((1)),
	[Remarks] [varchar](500) NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_OutingRequestHistory_CreatedDate]  DEFAULT (getdate()),
	[CreatedById] [int] NOT NULL,
 CONSTRAINT [PK_OutingRequestHistory] PRIMARY KEY CLUSTERED 
(
	[OutingRequestHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[OutingRequestStatus]    Script Date: 2/5/18 12:01:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[OutingRequestStatus](
	[StatusId] [bigint] IDENTITY(1,1) NOT NULL,
	[Status] [varchar](50) NOT NULL,
	[StatusCode] [varchar](20) NOT NULL,
	[Description] [varchar](500) NOT NULL,
	[IsActive] [bit] NOT NULL CONSTRAINT [DF_[OutingRequestStatus_IsActive]  DEFAULT ((1)),
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_[OutingRequestStatus_CreatedDate]  DEFAULT (getdate()),
	[CreatedById] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedById] [int] NULL,
 CONSTRAINT [PK_[OutingRequestStatus] PRIMARY KEY CLUSTERED 
(
	[StatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[OutingType]    Script Date: 2/5/18 12:01:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[OutingType](
	[OutingTypeId] [int] IDENTITY(1,1) NOT NULL,
	[OutingTypeName] [varchar](100) NOT NULL,
	[IsActive] [bit] NOT NULL CONSTRAINT [DF_OutingType_IsActive]  DEFAULT ((1)),
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_OutingType_CreatedDate]  DEFAULT (getdate()),
	[CreatedById] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedById] [int] NULL,
 CONSTRAINT [PK_OutingType] PRIMARY KEY CLUSTERED 
(
	[OutingTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[LegitimateLeaveRequest]  WITH CHECK ADD  CONSTRAINT [FK_LegitimateLeaveRequest_DateMaster_DateId] FOREIGN KEY([DateId])
REFERENCES [dbo].[DateMaster] ([DateId])
GO
ALTER TABLE [dbo].[LegitimateLeaveRequest] CHECK CONSTRAINT [FK_LegitimateLeaveRequest_DateMaster_DateId]
GO
ALTER TABLE [dbo].[LegitimateLeaveRequest]  WITH CHECK ADD  CONSTRAINT [FK_LegitimateLeaveRequest_LeaveRequestApplication_LeaveRequestApplicationId] FOREIGN KEY([LeaveRequestApplicationId])
REFERENCES [dbo].[LeaveRequestApplication] ([LeaveRequestApplicationId])
GO
ALTER TABLE [dbo].[LegitimateLeaveRequest] CHECK CONSTRAINT [FK_LegitimateLeaveRequest_LeaveRequestApplication_LeaveRequestApplicationId]
GO
ALTER TABLE [dbo].[LegitimateLeaveRequest]  WITH CHECK ADD  CONSTRAINT [FK_LegitimateLeaveRequest_LegitimateLeaveStatus_StatusId] FOREIGN KEY([StatusId])
REFERENCES [dbo].[LegitimateLeaveStatus] ([StatusId])
GO
ALTER TABLE [dbo].[LegitimateLeaveRequest] CHECK CONSTRAINT [FK_LegitimateLeaveRequest_LegitimateLeaveStatus_StatusId]
GO
ALTER TABLE [dbo].[LegitimateLeaveRequest]  WITH CHECK ADD  CONSTRAINT [FK_LegitimateLeaveRequest_User_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[User] ([UserId])
GO
ALTER TABLE [dbo].[LegitimateLeaveRequest] CHECK CONSTRAINT [FK_LegitimateLeaveRequest_User_CreatedBy]
GO
ALTER TABLE [dbo].[LegitimateLeaveRequest]  WITH CHECK ADD  CONSTRAINT [FK_LegitimateLeaveRequest_User_LastModifiedBy] FOREIGN KEY([LastModifiedBy])
REFERENCES [dbo].[User] ([UserId])
GO
ALTER TABLE [dbo].[LegitimateLeaveRequest] CHECK CONSTRAINT [FK_LegitimateLeaveRequest_User_LastModifiedBy]
GO
ALTER TABLE [dbo].[LegitimateLeaveRequest]  WITH CHECK ADD  CONSTRAINT [FK_LegitimateLeaveRequest_User_NextApproverId] FOREIGN KEY([NextApproverId])
REFERENCES [dbo].[User] ([UserId])
GO
ALTER TABLE [dbo].[LegitimateLeaveRequest] CHECK CONSTRAINT [FK_LegitimateLeaveRequest_User_NextApproverId]
GO
ALTER TABLE [dbo].[LegitimateLeaveRequest]  WITH CHECK ADD  CONSTRAINT [FK_LegitimateLeaveRequest_User_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([UserId])
GO
ALTER TABLE [dbo].[LegitimateLeaveRequest] CHECK CONSTRAINT [FK_LegitimateLeaveRequest_User_UserId]
GO
ALTER TABLE [dbo].[LegitimateLeaveRequest]  WITH CHECK ADD  CONSTRAINT [FK_LegitimateLeaveRequestHistory_User_LastModifiedBy] FOREIGN KEY([LastModifiedBy])
REFERENCES [dbo].[User] ([UserId])
GO
ALTER TABLE [dbo].[LegitimateLeaveRequest] CHECK CONSTRAINT [FK_LegitimateLeaveRequestHistory_User_LastModifiedBy]
GO
ALTER TABLE [dbo].[LegitimateLeaveRequestHistory]  WITH CHECK ADD  CONSTRAINT [FK_LegitimateLeaveRequestHistory_DateMaster_DateId] FOREIGN KEY([DateId])
REFERENCES [dbo].[DateMaster] ([DateId])
GO
ALTER TABLE [dbo].[LegitimateLeaveRequestHistory] CHECK CONSTRAINT [FK_LegitimateLeaveRequestHistory_DateMaster_DateId]
GO
ALTER TABLE [dbo].[LegitimateLeaveRequestHistory]  WITH CHECK ADD  CONSTRAINT [FK_LegitimateLeaveRequestHistory_LegitimateLeaveRequest_LegitimateLeaveRequestId] FOREIGN KEY([LegitimateLeaveRequestId])
REFERENCES [dbo].[LegitimateLeaveRequest] ([LegitimateLeaveRequestId])
GO
ALTER TABLE [dbo].[LegitimateLeaveRequestHistory] CHECK CONSTRAINT [FK_LegitimateLeaveRequestHistory_LegitimateLeaveRequest_LegitimateLeaveRequestId]
GO
ALTER TABLE [dbo].[LegitimateLeaveRequestHistory]  WITH CHECK ADD  CONSTRAINT [FK_LegitimateLeaveRequestHistory_LegitimateLeaveStatus_StatusId] FOREIGN KEY([StatusId])
REFERENCES [dbo].[LegitimateLeaveStatus] ([StatusId])
GO
ALTER TABLE [dbo].[LegitimateLeaveRequestHistory] CHECK CONSTRAINT [FK_LegitimateLeaveRequestHistory_LegitimateLeaveStatus_StatusId]
GO
ALTER TABLE [dbo].[LegitimateLeaveRequestHistory]  WITH CHECK ADD  CONSTRAINT [FK_LegitimateLeaveRequestHistory_User_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[User] ([UserId])
GO
ALTER TABLE [dbo].[LegitimateLeaveRequestHistory] CHECK CONSTRAINT [FK_LegitimateLeaveRequestHistory_User_CreatedBy]
GO
ALTER TABLE [dbo].[LegitimateLeaveStatus]  WITH CHECK ADD  CONSTRAINT [FK_LegitimateLeaveStatus_User_CreatedById] FOREIGN KEY([CreatedById])
REFERENCES [dbo].[User] ([UserId])
GO
ALTER TABLE [dbo].[LegitimateLeaveStatus] CHECK CONSTRAINT [FK_LegitimateLeaveStatus_User_CreatedById]
GO
ALTER TABLE [dbo].[LegitimateLeaveStatus]  WITH CHECK ADD  CONSTRAINT [FK_LegitimateLeaveStatus_User_ModifiedById] FOREIGN KEY([ModifiedById])
REFERENCES [dbo].[User] ([UserId])
GO
ALTER TABLE [dbo].[LegitimateLeaveStatus] CHECK CONSTRAINT [FK_LegitimateLeaveStatus_User_ModifiedById]
GO
ALTER TABLE [dbo].[OutingRequest]  WITH CHECK ADD  CONSTRAINT [FK_OutingRequest_DateMaster_FromDateId] FOREIGN KEY([FromDateId])
REFERENCES [dbo].[DateMaster] ([DateId])
GO
ALTER TABLE [dbo].[OutingRequest] CHECK CONSTRAINT [FK_OutingRequest_DateMaster_FromDateId]
GO
ALTER TABLE [dbo].[OutingRequest]  WITH CHECK ADD  CONSTRAINT [FK_OutingRequest_DateMaster_TillDateId] FOREIGN KEY([TillDateId])
REFERENCES [dbo].[DateMaster] ([DateId])
GO
ALTER TABLE [dbo].[OutingRequest] CHECK CONSTRAINT [FK_OutingRequest_DateMaster_TillDateId]
GO
ALTER TABLE [dbo].[OutingRequest]  WITH CHECK ADD  CONSTRAINT [FK_OutingRequest_OutingRequestStatus_StatusId] FOREIGN KEY([StatusId])
REFERENCES [dbo].[OutingRequestStatus] ([StatusId])
GO
ALTER TABLE [dbo].[OutingRequest] CHECK CONSTRAINT [FK_OutingRequest_OutingRequestStatus_StatusId]
GO
ALTER TABLE [dbo].[OutingRequest]  WITH CHECK ADD  CONSTRAINT [FK_OutingRequest_OutingType_OutingTypeId] FOREIGN KEY([OutingTypeId])
REFERENCES [dbo].[OutingType] ([OutingTypeId])
GO
ALTER TABLE [dbo].[OutingRequest] CHECK CONSTRAINT [FK_OutingRequest_OutingType_OutingTypeId]
GO
ALTER TABLE [dbo].[OutingRequest]  WITH CHECK ADD  CONSTRAINT [FK_OutingRequest_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([UserId])
GO
ALTER TABLE [dbo].[OutingRequest] CHECK CONSTRAINT [FK_OutingRequest_User]
GO
ALTER TABLE [dbo].[OutingRequest]  WITH CHECK ADD  CONSTRAINT [FK_OutingRequest_User_CreatedById] FOREIGN KEY([CreatedById])
REFERENCES [dbo].[User] ([UserId])
GO
ALTER TABLE [dbo].[OutingRequest] CHECK CONSTRAINT [FK_OutingRequest_User_CreatedById]
GO
ALTER TABLE [dbo].[OutingRequest]  WITH CHECK ADD  CONSTRAINT [FK_OutingRequest_User_NextApproverId] FOREIGN KEY([NextApproverId])
REFERENCES [dbo].[User] ([UserId])
GO
ALTER TABLE [dbo].[OutingRequest] CHECK CONSTRAINT [FK_OutingRequest_User_NextApproverId]
GO
ALTER TABLE [dbo].[OutingRequestDetail]  WITH CHECK ADD  CONSTRAINT [FK_OutingRequestDetail_OutingRequest_OutingRequestId] FOREIGN KEY([OutingRequestId])
REFERENCES [dbo].[OutingRequest] ([OutingRequestId])
GO
ALTER TABLE [dbo].[OutingRequestDetail] CHECK CONSTRAINT [FK_OutingRequestDetail_OutingRequest_OutingRequestId]
GO
ALTER TABLE [dbo].[OutingRequestDetail]  WITH CHECK ADD  CONSTRAINT [FK_OutingRequestDetail_OutingRequestStatus_StatusId] FOREIGN KEY([StatusId])
REFERENCES [dbo].[OutingRequestStatus] ([StatusId])
GO
ALTER TABLE [dbo].[OutingRequestDetail] CHECK CONSTRAINT [FK_OutingRequestDetail_OutingRequestStatus_StatusId]
GO
ALTER TABLE [dbo].[OutingRequestHistory]  WITH CHECK ADD  CONSTRAINT [FK_OutingRequestHistory_OutingRequest_OutingRequestId] FOREIGN KEY([OutingRequestId])
REFERENCES [dbo].[OutingRequest] ([OutingRequestId])
GO
ALTER TABLE [dbo].[OutingRequestHistory] CHECK CONSTRAINT [FK_OutingRequestHistory_OutingRequest_OutingRequestId]
GO
ALTER TABLE [dbo].[OutingRequestHistory]  WITH CHECK ADD  CONSTRAINT [FK_OutingRequestHistory_OutingRequestStatus_StatusId] FOREIGN KEY([StatusId])
REFERENCES [dbo].[OutingRequestStatus] ([StatusId])
GO
ALTER TABLE [dbo].[OutingRequestHistory] CHECK CONSTRAINT [FK_OutingRequestHistory_OutingRequestStatus_StatusId]
GO
ALTER TABLE [dbo].[OutingRequestHistory]  WITH CHECK ADD  CONSTRAINT [FK_OutingRequestHistory_User_CreatedById] FOREIGN KEY([CreatedById])
REFERENCES [dbo].[User] ([UserId])
GO
ALTER TABLE [dbo].[OutingRequestHistory] CHECK CONSTRAINT [FK_OutingRequestHistory_User_CreatedById]
GO
ALTER TABLE [dbo].[OutingRequestStatus]  WITH CHECK ADD  CONSTRAINT [FK_[OutingRequestStatus_User_CreatedById] FOREIGN KEY([CreatedById])
REFERENCES [dbo].[User] ([UserId])
GO
ALTER TABLE [dbo].[OutingRequestStatus] CHECK CONSTRAINT [FK_[OutingRequestStatus_User_CreatedById]
GO
ALTER TABLE [dbo].[OutingRequestStatus]  WITH CHECK ADD  CONSTRAINT [FK_[OutingRequestStatus_User_ModifiedById] FOREIGN KEY([ModifiedById])
REFERENCES [dbo].[User] ([UserId])
GO
ALTER TABLE [dbo].[OutingRequestStatus] CHECK CONSTRAINT [FK_[OutingRequestStatus_User_ModifiedById]
GO



--Data---------------------
---------------------------
SET IDENTITY_INSERT [dbo].[LegitimateLeaveStatus] ON 

GO
INSERT [dbo].[LegitimateLeaveStatus] ([StatusId], [Status], [StatusCode], [Description], [IsActive], [CreatedDate], [CreatedById], [ModifiedDate], [ModifiedById]) VALUES (1, N'Applied', N'AD', N'User has applied', 1, CAST(N'2018-03-28 15:17:48.210' AS DateTime), 2434, NULL, NULL)
GO
INSERT [dbo].[LegitimateLeaveStatus] ([StatusId], [Status], [StatusCode], [Description], [IsActive], [CreatedDate], [CreatedById], [ModifiedDate], [ModifiedById]) VALUES (2, N'Pending for approval', N'PA', N'Managers approval pending', 1, CAST(N'2018-03-28 15:17:48.210' AS DateTime), 2434, NULL, NULL)
GO
INSERT [dbo].[LegitimateLeaveStatus] ([StatusId], [Status], [StatusCode], [Description], [IsActive], [CreatedDate], [CreatedById], [ModifiedDate], [ModifiedById]) VALUES (3, N'Pending for verification', N'PV', N'HR verification pending', 1, CAST(N'2018-03-28 15:17:48.210' AS DateTime), 2434, NULL, NULL)
GO
INSERT [dbo].[LegitimateLeaveStatus] ([StatusId], [Status], [StatusCode], [Description], [IsActive], [CreatedDate], [CreatedById], [ModifiedDate], [ModifiedById]) VALUES (4, N'Approved', N'AP', N'Approved by manager', 1, CAST(N'2018-03-28 15:17:48.210' AS DateTime), 2434, NULL, NULL)
GO
INSERT [dbo].[LegitimateLeaveStatus] ([StatusId], [Status], [StatusCode], [Description], [IsActive], [CreatedDate], [CreatedById], [ModifiedDate], [ModifiedById]) VALUES (5, N'Verified', N'VD', N'Verified by HR', 1, CAST(N'2018-03-28 15:17:48.210' AS DateTime), 2434, NULL, NULL)
GO
INSERT [dbo].[LegitimateLeaveStatus] ([StatusId], [Status], [StatusCode], [Description], [IsActive], [CreatedDate], [CreatedById], [ModifiedDate], [ModifiedById]) VALUES (6, N'Rejected', N'RJM', N'Rejected by manager', 1, CAST(N'2018-03-28 15:17:48.210' AS DateTime), 2434, NULL, NULL)
GO
INSERT [dbo].[LegitimateLeaveStatus] ([StatusId], [Status], [StatusCode], [Description], [IsActive], [CreatedDate], [CreatedById], [ModifiedDate], [ModifiedById]) VALUES (7, N'Rejected', N'RJH', N'Rejected by HR', 1, CAST(N'2018-03-28 15:17:48.210' AS DateTime), 2434, NULL, NULL)
GO
INSERT [dbo].[LegitimateLeaveStatus] ([StatusId], [Status], [StatusCode], [Description], [IsActive], [CreatedDate], [CreatedById], [ModifiedDate], [ModifiedById]) VALUES (8, N'Cancelled', N'CA', N'Cancelled by user', 1, CAST(N'2018-03-28 15:17:48.210' AS DateTime), 2434, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[LegitimateLeaveStatus] OFF
GO
SET IDENTITY_INSERT [dbo].[OutingRequestStatus] ON 

GO
INSERT [dbo].[OutingRequestStatus] ([StatusId], [Status], [StatusCode], [Description], [IsActive], [CreatedDate], [CreatedById], [ModifiedDate], [ModifiedById]) VALUES (1, N'Applied', N'AD', N'User has applied', 1, CAST(N'2018-03-28 15:17:48.210' AS DateTime), 2434, NULL, NULL)
GO
INSERT [dbo].[OutingRequestStatus] ([StatusId], [Status], [StatusCode], [Description], [IsActive], [CreatedDate], [CreatedById], [ModifiedDate], [ModifiedById]) VALUES (2, N'Pending for approval', N'PA', N'Managers approval pending', 1, CAST(N'2018-03-28 15:17:48.210' AS DateTime), 2434, NULL, NULL)
GO
INSERT [dbo].[OutingRequestStatus] ([StatusId], [Status], [StatusCode], [Description], [IsActive], [CreatedDate], [CreatedById], [ModifiedDate], [ModifiedById]) VALUES (3, N'Pending for verification', N'PV', N'HR verification pending', 1, CAST(N'2018-03-28 15:17:48.210' AS DateTime), 2434, NULL, NULL)
GO
INSERT [dbo].[OutingRequestStatus] ([StatusId], [Status], [StatusCode], [Description], [IsActive], [CreatedDate], [CreatedById], [ModifiedDate], [ModifiedById]) VALUES (4, N'Approved', N'AP', N'Approved by manager', 1, CAST(N'2018-03-28 15:17:48.210' AS DateTime), 2434, NULL, NULL)
GO
INSERT [dbo].[OutingRequestStatus] ([StatusId], [Status], [StatusCode], [Description], [IsActive], [CreatedDate], [CreatedById], [ModifiedDate], [ModifiedById]) VALUES (5, N'Verified', N'VD', N'Verified by HR', 1, CAST(N'2018-03-28 15:17:48.210' AS DateTime), 2434, NULL, NULL)
GO
INSERT [dbo].[OutingRequestStatus] ([StatusId], [Status], [StatusCode], [Description], [IsActive], [CreatedDate], [CreatedById], [ModifiedDate], [ModifiedById]) VALUES (6, N'Rejected', N'RJM', N'Rejected by manager', 1, CAST(N'2018-03-28 15:17:48.210' AS DateTime), 2434, NULL, NULL)
GO
INSERT [dbo].[OutingRequestStatus] ([StatusId], [Status], [StatusCode], [Description], [IsActive], [CreatedDate], [CreatedById], [ModifiedDate], [ModifiedById]) VALUES (7, N'Rejected', N'RJH', N'Rejected by HR', 1, CAST(N'2018-03-28 15:17:48.210' AS DateTime), 2434, NULL, NULL)
GO
INSERT [dbo].[OutingRequestStatus] ([StatusId], [Status], [StatusCode], [Description], [IsActive], [CreatedDate], [CreatedById], [ModifiedDate], [ModifiedById]) VALUES (8, N'Cancelled', N'CA', N'Cancelled by user', 1, CAST(N'2018-03-28 15:17:48.210' AS DateTime), 2434, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[OutingRequestStatus] OFF
GO
SET IDENTITY_INSERT [dbo].[OutingType] ON 

GO
INSERT [dbo].[OutingType] ([OutingTypeId], [OutingTypeName], [IsActive], [CreatedDate], [CreatedById], [ModifiedDate], [ModifiedById]) VALUES (1, N'Duty', 1, CAST(N'2017-05-25 17:37:25.630' AS DateTime), 1, NULL, NULL)
GO
INSERT [dbo].[OutingType] ([OutingTypeId], [OutingTypeName], [IsActive], [CreatedDate], [CreatedById], [ModifiedDate], [ModifiedById]) VALUES (2, N'Tour', 1, CAST(N'2017-05-25 17:37:25.630' AS DateTime), 1, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[OutingType] OFF
GO