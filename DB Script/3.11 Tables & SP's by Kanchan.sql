GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PimcoUser_PimcoUserExpiration_PimcoUserId]') AND parent_object_id = OBJECT_ID(N'[dbo].[PimcoUserExpiration]'))
ALTER TABLE [dbo].[PimcoUserExpiration] DROP CONSTRAINT [FK_PimcoUser_PimcoUserExpiration_PimcoUserId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PimcoUser_User_GeminiUserId]') AND parent_object_id = OBJECT_ID(N'[dbo].[PimcoUser]'))
ALTER TABLE [dbo].[PimcoUser] DROP CONSTRAINT [FK_PimcoUser_User_GeminiUserId]
GO
/****** Object:  Table [dbo].[PimcoUserExpiration]    Script Date: 11-07-2018 20:55:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PimcoUserExpiration]') AND type in (N'U'))
DROP TABLE [dbo].[PimcoUserExpiration]
GO
/****** Object:  Table [dbo].[PimcoUser]    Script Date: 11-07-2018 20:55:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PimcoUser]') AND type in (N'U'))
DROP TABLE [dbo].[PimcoUser]
GO
/****** Object:  Table [dbo].[PimcoUser]    Script Date: 11-07-2018 20:55:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PimcoUser]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PimcoUser](
	[PimcoUserId] [bigint] IDENTITY(1,1) NOT NULL,
	[GeminiUserId] [int] NOT NULL,
	[PimcoEmployeeId] [varchar](30) NULL,
	[PimcoManagerName] [varchar](100) NULL,
	[IsActive] [bit] NOT NULL CONSTRAINT [DF_PimcoUser_IsActive]  DEFAULT ((1)),
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_PimcoUser_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_PimcoUser] PRIMARY KEY CLUSTERED 
(
	[PimcoUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PimcoUserExpiration]    Script Date: 11-07-2018 20:55:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PimcoUserExpiration]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PimcoUserExpiration](
	[PimcoUserExpirationId] [bigint] IDENTITY(1,1) NOT NULL,
	[PimcoUserId] [bigint] NOT NULL,
	[UserValidFromDate] [date] NOT NULL,
	[UserValidToDate] [date] NOT NULL,
	[IsAcknowledged] [bit] NOT NULL DEFAULT ((0)),
	[AcknowledgedBy] [int] NULL,
	[AcknowledgedDate] [datetime] NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_PimcoUserExpiration_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_PimcoUserExpiration] PRIMARY KEY CLUSTERED 
(
	[PimcoUserExpirationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PimcoUser_User_GeminiUserId]') AND parent_object_id = OBJECT_ID(N'[dbo].[PimcoUser]'))
ALTER TABLE [dbo].[PimcoUser]  WITH CHECK ADD  CONSTRAINT [FK_PimcoUser_User_GeminiUserId] FOREIGN KEY([GeminiUserId])
REFERENCES [dbo].[User] ([UserId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PimcoUser_User_GeminiUserId]') AND parent_object_id = OBJECT_ID(N'[dbo].[PimcoUser]'))
ALTER TABLE [dbo].[PimcoUser] CHECK CONSTRAINT [FK_PimcoUser_User_GeminiUserId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PimcoUser_PimcoUserExpiration_PimcoUserId]') AND parent_object_id = OBJECT_ID(N'[dbo].[PimcoUserExpiration]'))
ALTER TABLE [dbo].[PimcoUserExpiration]  WITH CHECK ADD  CONSTRAINT [FK_PimcoUser_PimcoUserExpiration_PimcoUserId] FOREIGN KEY([PimcoUserId])
REFERENCES [dbo].[PimcoUser] ([PimcoUserId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PimcoUser_PimcoUserExpiration_PimcoUserId]') AND parent_object_id = OBJECT_ID(N'[dbo].[PimcoUserExpiration]'))
ALTER TABLE [dbo].[PimcoUserExpiration] CHECK CONSTRAINT [FK_PimcoUser_PimcoUserExpiration_PimcoUserId]
GO

GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__CabShiftM__CabSh__5B651AB3]') AND parent_object_id = OBJECT_ID(N'[dbo].[CabShiftMapping]'))
ALTER TABLE [dbo].[CabShiftMapping] DROP CONSTRAINT [FK__CabShiftM__CabSh__5B651AB3]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__CabShiftM__CabId__5A70F67A]') AND parent_object_id = OBJECT_ID(N'[dbo].[CabShiftMapping]'))
ALTER TABLE [dbo].[CabShiftMapping] DROP CONSTRAINT [FK__CabShiftM__CabId__5A70F67A]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__CabReques__Statu__7DBA32B7]') AND parent_object_id = OBJECT_ID(N'[dbo].[CabRequestDetail]'))
ALTER TABLE [dbo].[CabRequestDetail] DROP CONSTRAINT [FK__CabReques__Statu__7DBA32B7]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__CabReques__DateI__7CC60E7E]') AND parent_object_id = OBJECT_ID(N'[dbo].[CabRequestDetail]'))
ALTER TABLE [dbo].[CabRequestDetail] DROP CONSTRAINT [FK__CabReques__DateI__7CC60E7E]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__CabReques__CabSh__79E9A1D3]') AND parent_object_id = OBJECT_ID(N'[dbo].[CabRequestDetail]'))
ALTER TABLE [dbo].[CabRequestDetail] DROP CONSTRAINT [FK__CabReques__CabSh__79E9A1D3]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__CabReques__CabRe__7BD1EA45]') AND parent_object_id = OBJECT_ID(N'[dbo].[CabRequestDetail]'))
ALTER TABLE [dbo].[CabRequestDetail] DROP CONSTRAINT [FK__CabReques__CabRe__7BD1EA45]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__CabReques__CabId__78F57D9A]') AND parent_object_id = OBJECT_ID(N'[dbo].[CabRequestDetail]'))
ALTER TABLE [dbo].[CabRequestDetail] DROP CONSTRAINT [FK__CabReques__CabId__78F57D9A]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__CabReques__Statu__69B33A0A]') AND parent_object_id = OBJECT_ID(N'[dbo].[CabRequest]'))
ALTER TABLE [dbo].[CabRequest] DROP CONSTRAINT [FK__CabReques__Statu__69B33A0A]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__CabReques__CabSh__68BF15D1]') AND parent_object_id = OBJECT_ID(N'[dbo].[CabRequest]'))
ALTER TABLE [dbo].[CabRequest] DROP CONSTRAINT [FK__CabReques__CabSh__68BF15D1]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__CabReques__CabId__67CAF198]') AND parent_object_id = OBJECT_ID(N'[dbo].[CabRequest]'))
ALTER TABLE [dbo].[CabRequest] DROP CONSTRAINT [FK__CabReques__CabId__67CAF198]
GO
/****** Object:  Table [dbo].[CabShiftMapping]    Script Date: 11-07-2018 20:52:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CabShiftMapping]') AND type in (N'U'))
DROP TABLE [dbo].[CabShiftMapping]
GO
/****** Object:  Table [dbo].[CabRequestDetail]    Script Date: 11-07-2018 20:52:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CabRequestDetail]') AND type in (N'U'))
DROP TABLE [dbo].[CabRequestDetail]
GO
/****** Object:  Table [dbo].[CabRequest]    Script Date: 11-07-2018 20:52:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CabRequest]') AND type in (N'U'))
DROP TABLE [dbo].[CabRequest]
GO
/****** Object:  Table [dbo].[CabMaster]    Script Date: 11-07-2018 20:52:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CabMaster]') AND type in (N'U'))
DROP TABLE [dbo].[CabMaster]
GO

/****** Object:  Table [dbo].[CabStatusMaster]    Script Date: 11-07-2018 20:52:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CabStatusMaster]') AND type in (N'U'))
DROP TABLE [dbo].[CabStatusMaster]
GO
/****** Object:  Table [dbo].[CabShiftMaster]    Script Date: 11-07-2018 20:52:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CabShiftMaster]') AND type in (N'U'))
DROP TABLE [dbo].[CabShiftMaster]
GO
/****** Object:  Table [dbo].[CabMaster]    Script Date: 11-07-2018 20:52:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CabMaster]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CabMaster](
	[CabId] [int] IDENTITY(1,1) NOT NULL,
	[CabRegistrationNo] [varchar](50) NOT NULL,
	[ModelName] [varchar](50) NOT NULL,
	[CabDescription] [varchar](50) NOT NULL,
	[NoOfSeats] [int] NOT NULL,
	[IsActive] [bit] NOT NULL DEFAULT ((1)),
	[IsDeleted] [bit] NOT NULL DEFAULT ((0)),
	[CreatedDate] [datetime] NOT NULL DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[LastModifiedDate] [datetime] NULL,
	[LastModifiedBy] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[CabId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CabRequest]    Script Date: 11-07-2018 20:52:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CabRequest]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CabRequest](
	[CabRequestId] [bigint] IDENTITY(1,1) NOT NULL,
	[FromDateId] [bigint] NOT NULL,
	[TillDateId] [bigint] NOT NULL,
	[CabId] [int] NOT NULL,
	[CabShiftId] [int] NOT NULL,
	[StatusId] [int] NOT NULL,
	[ApproverId] [bigint] NULL,
	[CreatedDate] [datetime] NOT NULL DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[LastModifiedDate] [datetime] NULL,
	[LastModifiedBy] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[CabRequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[CabRequestDetail]    Script Date: 11-07-2018 20:52:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CabRequestDetail]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CabRequestDetail](
	[CabRequestDetailId] [bigint] IDENTITY(1,1) NOT NULL,
	[CabRequestId] [bigint] NOT NULL,
	[DateId] [bigint] NOT NULL,
	[CabId] [int] NOT NULL,
	[CabShiftId] [int] NOT NULL,
	[StatusId] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[LastModifiedDate] [datetime] NULL,
	[LastModifiedBy] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[CabRequestDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[CabShiftMapping]    Script Date: 11-07-2018 20:52:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CabShiftMapping]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CabShiftMapping](
	[CabShiftMappingId] [int] IDENTITY(1,1) NOT NULL,
	[CabId] [int] NOT NULL,
	[CabShiftId] [int] NOT NULL,
	[IsActive] [bit] NOT NULL DEFAULT ((1)),
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NULL DEFAULT (getdate()),
	[LastModifiedDate] [datetime] NULL,
	[LastModifiedBy] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[CabShiftMappingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[CabShiftMaster]    Script Date: 11-07-2018 20:52:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CabShiftMaster]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CabShiftMaster](
	[CabShiftId] [int] IDENTITY(1,1) NOT NULL,
	[CabShiftName] [varchar](20) NOT NULL,
	[IsActive] [bit] NOT NULL DEFAULT ((1)),
	[IsDeleted] [bit] NOT NULL DEFAULT ((0)),
	[CreatedDate] [datetime] NOT NULL DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[LastModifiedDate] [datetime] NULL,
	[LastModifiedBy] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[CabShiftId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CabStatusMaster]    Script Date: 11-07-2018 20:52:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CabStatusMaster]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CabStatusMaster](
	[StatusId] [int] IDENTITY(1,1) NOT NULL,
	[StatusCode] [varchar](5) NOT NULL,
	[Status] [varchar](20) NOT NULL,
	[IsActive] [bit] NOT NULL DEFAULT ((1)),
	[IsDeleted] [bit] NOT NULL DEFAULT ((0)),
	[CreatedDate] [datetime] NOT NULL DEFAULT (getdate()),
	[CreatedBy] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[StatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__CabReques__CabId__67CAF198]') AND parent_object_id = OBJECT_ID(N'[dbo].[CabRequest]'))
ALTER TABLE [dbo].[CabRequest]  WITH CHECK ADD FOREIGN KEY([CabId])
REFERENCES [dbo].[CabMaster] ([CabId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__CabReques__CabSh__68BF15D1]') AND parent_object_id = OBJECT_ID(N'[dbo].[CabRequest]'))
ALTER TABLE [dbo].[CabRequest]  WITH CHECK ADD FOREIGN KEY([CabShiftId])
REFERENCES [dbo].[CabShiftMaster] ([CabShiftId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__CabReques__Statu__69B33A0A]') AND parent_object_id = OBJECT_ID(N'[dbo].[CabRequest]'))
ALTER TABLE [dbo].[CabRequest]  WITH CHECK ADD FOREIGN KEY([StatusId])
REFERENCES [dbo].[CabStatusMaster] ([StatusId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__CabReques__CabId__78F57D9A]') AND parent_object_id = OBJECT_ID(N'[dbo].[CabRequestDetail]'))
ALTER TABLE [dbo].[CabRequestDetail]  WITH CHECK ADD FOREIGN KEY([CabId])
REFERENCES [dbo].[CabMaster] ([CabId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__CabReques__CabRe__7BD1EA45]') AND parent_object_id = OBJECT_ID(N'[dbo].[CabRequestDetail]'))
ALTER TABLE [dbo].[CabRequestDetail]  WITH CHECK ADD FOREIGN KEY([CabRequestId])
REFERENCES [dbo].[CabRequest] ([CabRequestId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__CabReques__CabSh__79E9A1D3]') AND parent_object_id = OBJECT_ID(N'[dbo].[CabRequestDetail]'))
ALTER TABLE [dbo].[CabRequestDetail]  WITH CHECK ADD FOREIGN KEY([CabShiftId])
REFERENCES [dbo].[CabShiftMaster] ([CabShiftId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__CabReques__DateI__7CC60E7E]') AND parent_object_id = OBJECT_ID(N'[dbo].[CabRequestDetail]'))
ALTER TABLE [dbo].[CabRequestDetail]  WITH CHECK ADD FOREIGN KEY([DateId])
REFERENCES [dbo].[DateMaster] ([DateId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__CabReques__Statu__7DBA32B7]') AND parent_object_id = OBJECT_ID(N'[dbo].[CabRequestDetail]'))
ALTER TABLE [dbo].[CabRequestDetail]  WITH CHECK ADD FOREIGN KEY([StatusId])
REFERENCES [dbo].[CabStatusMaster] ([StatusId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__CabShiftM__CabId__5A70F67A]') AND parent_object_id = OBJECT_ID(N'[dbo].[CabShiftMapping]'))
ALTER TABLE [dbo].[CabShiftMapping]  WITH CHECK ADD FOREIGN KEY([CabId])
REFERENCES [dbo].[CabMaster] ([CabId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__CabShiftM__CabSh__5B651AB3]') AND parent_object_id = OBJECT_ID(N'[dbo].[CabShiftMapping]'))
ALTER TABLE [dbo].[CabShiftMapping]  WITH CHECK ADD FOREIGN KEY([CabShiftId])
REFERENCES [dbo].[CabShiftMaster] ([CabShiftId])
GO

GO
/****** Object:  StoredProcedure [dbo].[spUpdateContactDetails]    Script Date: 11-07-2018 20:49:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spUpdateContactDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spUpdateContactDetails]
GO
/****** Object:  StoredProcedure [dbo].[spLapseCompOff]    Script Date: 11-07-2018 20:49:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spLapseCompOff]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spLapseCompOff]
GO
/****** Object:  StoredProcedure [dbo].[spGetShiftUserMappingList]    Script Date: 11-07-2018 20:49:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetShiftUserMappingList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetShiftUserMappingList]
GO
/****** Object:  StoredProcedure [dbo].[Proc_TakeActionOnCabRequest]    Script Date: 11-07-2018 20:49:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TakeActionOnCabRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TakeActionOnCabRequest]
GO
/****** Object:  StoredProcedure [dbo].[Proc_TakeActionOnCabBulkApprove]    Script Date: 11-07-2018 20:49:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TakeActionOnCabBulkApprove]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TakeActionOnCabBulkApprove]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetPimcoUsers]    Script Date: 11-07-2018 20:49:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetPimcoUsers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetPimcoUsers]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetPimcoIdExpirationData]    Script Date: 11-07-2018 20:49:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetPimcoIdExpirationData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetPimcoIdExpirationData]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetGeminiUsers]    Script Date: 11-07-2018 20:49:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetGeminiUsers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetGeminiUsers]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetDesignationListByDesignationGroup]    Script Date: 11-07-2018 20:49:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROC_GetDesignationListByDesignationGroup]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PROC_GetDesignationListByDesignationGroup]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetCabReviewRequest]    Script Date: 11-07-2018 20:49:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROC_GetCabReviewRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PROC_GetCabReviewRequest]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetCabRequestToView]    Script Date: 11-07-2018 20:49:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetCabRequestToView]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetCabRequestToView]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetCabRequestDetail]    Script Date: 11-07-2018 20:49:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROC_GetCabRequestDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PROC_GetCabRequestDetail]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetCabRequestByCabId]    Script Date: 11-07-2018 20:49:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetCabRequestByCabId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetCabRequestByCabId]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetAvailabeCab]    Script Date: 11-07-2018 20:49:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROC_GetAvailabeCab]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PROC_GetAvailabeCab]
GO
/****** Object:  StoredProcedure [dbo].[PROC_BookCab]    Script Date: 11-07-2018 20:49:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROC_BookCab]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PROC_BookCab]
GO
/****** Object:  StoredProcedure [dbo].[PROC_BookCab]    Script Date: 11-07-2018 20:49:16 ******/
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

DECLARE @FromDateId BIGINT, @TillDateId BIGINT, @ReportingManagerId INT,@StatusId INT=(SELECT StatusId FROM CabStatusMaster WHERE StatusCode='PA')
	    DECLARE @CabRequestId BIGINT
		SET @ReportingManagerId = (SELECT [dbo].[fnGetReportingManagerByUserId](@EmployeeId)) 
		
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
/****** Object:  StoredProcedure [dbo].[PROC_GetAvailabeCab]    Script Date: 11-07-2018 20:49:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROC_GetAvailabeCab]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PROC_GetAvailabeCab] AS' 
END
GO
/*  
   Created Date      :     2018-06-25
   Created By        :     Kanchan Kumari
   Purpose           :     This stored procedure is used to get available cabs
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   Test Case: 

	  EXEC [dbo].[PROC_GetAvailabeCab]
	  @FromDate ='2018-06-29', 
	  @TillDate ='2018-06-29', 
	  @CabId =1, 
	  @ShiftId =1

*/

ALTER PROC [dbo].[PROC_GetAvailabeCab]
(
@FromDate [Date], 
@TillDate [Date], 
@CabId INT, 
@ShiftId INT
)
AS
BEGIN
DECLARE @FromDateId BIGINT, @TillDateId BIGINT
    SELECT @FromDateId = MIN(DM.[DateId])
		  ,@TillDateId = MAX(DM.[DateId])
	FROM [dbo].[DateMaster] DM WITH (NOLOCK) WHERE DM.[Date] BETWEEN  @FromDate AND  @TillDate
	SET FMTONLY OFF;
	IF OBJECT_ID('tempdb..#TempCabDetail') IS NOT NULL
	DROP TABLE #TempCabDetail

		CREATE TABLE #TempCabDetail
		(
			[DateId] BIGINT,
			AvailableSeat INT
		)

		WHILE (@FromDateId <= @TillDateId)
		BEGIN
		 DECLARE @SEATCOUNT INT =0;
		 SELECT  @SEATCOUNT = COUNT(CD.CabRequestDetailId) FROM CabRequestDetail CD  
		 WHERE  CD.StatusId<=2 AND CD.CabShiftId=@ShiftId AND CD.CabId=@CabId AND CD.DateId=@FromDateId GROUP BY CD.[DateId]

		 IF(@SEATCOUNT =0)
		 BEGIN
		   INSERT INTO #TempCabDetail([DateId],AvailableSeat) 
		   VALUES (@FromDateId,(select NoOfSeats from CabMaster where CabId=@CabId));
		 END
		 ELSE
		 BEGIN 
		   INSERT INTO #TempCabDetail([DateId],AvailableSeat) 
		   VALUES (@FromDateId,(select (NoOfSeats -@SEATCOUNT) from CabMaster where CabId=@CabId));
		 END
			SET @FromDateId = @FromDateId +1;
			PRINT @FromDateId;
		END
		SELECT DM.[Date] AS [Date] ,TD.AvailableSeat FROM #TempCabDetail TD JOIN DateMaster DM ON DM.DateId=TD.DateId
END



GO
/****** Object:  StoredProcedure [dbo].[Proc_GetCabRequestByCabId]    Script Date: 11-07-2018 20:49:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetCabRequestByCabId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetCabRequestByCabId] AS' 
END
GO
/*  
   Created Date      :     2018-06-25
   Created By        :     Kanchan Kumari
   Purpose           :     This stored procedure is used to get the cab request by cabId
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   Test Case: 
	   EXEC [dbo].[Proc_GetCabRequestByCabId]
       @Date='2018-06-29',
       @CabId=1
*/

ALTER PROC [dbo].[Proc_GetCabRequestByCabId](
@Date [Date],
@CabId INT
)
AS 
BEGIN
SET FMTONLY OFF;
IF OBJECT_ID('tempdb..#TempDataByCabId') IS NOT NULL
	DROP TABLE #TempDataByCabId
CREATE TABLE #TempDataByCabId(
CabRequestId BIGINT NOT NULL,
EmployeeName VARCHAR(100) NOT NULL,
StatusCode VARCHAR(10) NOT NULL,
[Status] VARCHAR(50) NOT NULL,
Period VARCHAR(100) NOT NULL,
CreatedDate VARCHAR(50) NOT NULL,
[Shift] VARCHAR(10) NOT NULL,
Cab VARCHAR(10) NOT NULL
)

INSERT INTO #TempDataByCabId

SELECT CD.CabRequestDetailId AS CabRequestDetailId,
       UD.FirstName+ ' '+UD.LastName AS EmployeeName,
       CSM.StatusCode AS StatusCode,
	   CSM.[Status]  AS   [Status],
	   CAST(CONVERT(VARCHAR(20),DM1.[Date],106) AS Varchar(20))  AS [Period],
      Convert(VARCHAR(20), CD.CreatedDate,106)+' '+FORMAT( CD.CreatedDate, 'hh:mm tt') AS CreatedDate,
	   CS.CabShiftName AS [Shift],
	   CM.CabRegistrationNo AS Cab
 FROM CabRequestDetail CD
 JOIN CabStatusMaster CSM ON CSM.StatusId=CD.StatusId
 JOIN CabShiftMaster CS ON CS.CabShiftId=CD.CabShiftId 
 JOIN DateMaster DM1 ON DM1.DateId=CD.DateId
 JOIN DateMaster DM2 ON DM2.[Date]=@Date
 JOIN CabMaster CM ON CM.CabId=CD.CabId
 JOIN UserDetail UD ON UD.UserId=CD.CreatedBy
 WHERE CD.[DateId]=DM2.DateId AND CD.CabId=@CabId
 SELECT * FROM #TempDataByCabId where StatusCode!='CA' order by CreatedDate desc

END

GO
/****** Object:  StoredProcedure [dbo].[PROC_GetCabRequestDetail]    Script Date: 11-07-2018 20:49:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROC_GetCabRequestDetail]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PROC_GetCabRequestDetail] AS' 
END
GO
--EXEC PROC_GetCabRequestDetail @EmployeeId=2432 ,@Month=06,@Year=2018
/*  
   Created Date      :     2018-06-25
   Created By        :     Kanchan Kumari
   Purpose           :     This stored procedure is used to get the cab request detail
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   Test Case: 
	   EXEC [dbo].[PROC_GetCabRequestDetail]
	   @EmployeeId=2432,
       @Month=4,
       @Year=2018
*/
ALTER PROC [dbo].[PROC_GetCabRequestDetail](
@EmployeeId INT, 
@Month INT,
@Year INT
)
AS
BEGIN 
 DECLARE 
      @StartDate [date]
     ,@EndDate [date]
	 
   SELECT 
      @StartDate = DATEADD(MONTH, @Month - 1, DATEADD(YEAR, @Year - 1900, 0)) 
     ,@EndDate = DATEADD(DAY ,-1, DATEADD(MONTH, @Month, DATEADD(YEAR, @Year - 1900, 0))) 

SELECT CD.CabRequestDetailId AS [CabRequestDetailId],
       CD.CabId            AS [CabId],
	   CSM.[Status]        AS [Status],
	   CD.[StatusId]      AS [StatusId],
	   CSM.[StatusCode]    AS [StatusCode],
	   CM.CabRegistrationNo  AS [CabModel],
       DM.[Date]           AS [Date],
	   CD.CabShiftId       AS [CabShiftId],
	   CS.CabShiftName     AS [CabShift]
	FROM CabRequestDetail CD 
	JOIN CabRequest CR ON CD.CabRequestId=CR.CabRequestId
	JOIN CabMaster CM ON CM.CabId=CD.CabId
	JOIN CabShiftMaster CS ON CD.CabShiftId=CS.CabShiftId
	JOIN CabStatusMaster CSM ON CSM.StatusId=CD.StatusId
	JOIN DateMaster DM ON DM.DateId=CD.DateId
	WHERE CD.CreatedBy=@EmployeeId AND DM.[Date] BETWEEN @StartDate AND @EndDate order by CD.[DateId] DESC ,CD.CreatedDate DESC
END
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetCabRequestToView]    Script Date: 11-07-2018 20:49:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetCabRequestToView]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetCabRequestToView] AS' 
END
GO
/*  
   Created Date      :     2018-06-25
   Created By        :     Kanchan Kumari
   Purpose           :     This stored procedure is used to get the cab request 
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   Test Case: 
	  EXEC [dbo].[Proc_GetCabRequestToView]
      @Date='2018-06-29',
      @ShiftId=1
*/

ALTER PROC [dbo].[Proc_GetCabRequestToView](
@Date [Date],
@ShiftId INT
)
AS 
BEGIN
SET FMTONLY OFF;
IF OBJECT_ID('tempdb..#TempviewCabdata') IS NOT NULL
	DROP TABLE #TempviewCabdata
CREATE TABLE #TempviewCabdata(
CabRequestId BIGINT NOT NULL,
EmployeeName VARCHAR(100) NOT NULL,
StatusCode VARCHAR(10) NOT NULL,
[Status] VARCHAR(50) NOT NULL,
Period VARCHAR(100) NOT NULL,
CreatedDate VARCHAR(50) NOT NULL,
[Shift] VARCHAR(10) NOT NULL,
Cab VARCHAR(10) NOT NULL
)
IF(@ShiftId=0)
BEGIN
INSERT INTO #TempviewCabdata

SELECT CD.CabRequestDetailId AS CabRequestDetailId,
       UD.FirstName+ ' '+UD.LastName AS EmployeeName,
       CSM.StatusCode AS StatusCode,
	   CSM.[Status]  AS   [Status],
	   CAST(CONVERT(VARCHAR(20),DM1.[Date],106) AS Varchar(20))  AS [Period],
      Convert(VARCHAR(20), CD.CreatedDate,106)+' '+FORMAT( CD.CreatedDate, 'hh:mm tt') AS CreatedDate,
	   CS.CabShiftName AS [Shift],
	   CM.CabRegistrationNo AS Cab
 FROM CabRequestDetail CD
 JOIN CabStatusMaster CSM ON CSM.StatusId=CD.StatusId
 JOIN CabShiftMaster CS ON CS.CabShiftId=CD.CabShiftId 
 JOIN DateMaster DM1 ON DM1.DateId=CD.DateId
 JOIN DateMaster DM2 ON DM2.[Date]=@Date
 JOIN CabMaster CM ON CM.CabId=CD.CabId
 JOIN UserDetail UD ON UD.UserId=CD.CreatedBy
 WHERE CD.[DateId]=DM2.DateId 

 END
 ELSE
 BEGIN
 INSERT INTO #TempviewCabdata
 SELECT CD.CabRequestDetailId AS CabRequestDetailId,
       UD.FirstName+ ' '+UD.LastName AS EmployeeName,
       CSM.StatusCode AS StatusCode,
	   CSM.[Status]  AS   [Status],
	   CAST(CONVERT(VARCHAR(20),DM1.[Date],106) AS Varchar(20))  AS [Period],
      Convert(VARCHAR(20), CD.CreatedDate,106)+' '+FORMAT( CD.CreatedDate, 'hh:mm tt') AS CreatedDate,
	   CS.CabShiftName AS [Shift],
	   CM.CabRegistrationNo AS Cab
 FROM CabRequestDetail CD
 JOIN CabStatusMaster CSM ON CSM.StatusId=CD.StatusId
 JOIN CabShiftMaster CS ON CS.CabShiftId=CD.CabShiftId 
 JOIN DateMaster DM1 ON DM1.DateId=CD.DateId
 JOIN DateMaster DM2 ON DM2.[Date]=@Date
 JOIN CabMaster CM ON CM.CabId=CD.CabId
 JOIN UserDetail UD ON UD.UserId=CD.CreatedBy
 WHERE CD.[DateId]=DM2.DateId AND CD.[CabShiftId]=@ShiftId 
 END

 SELECT * FROM #TempviewCabdata where StatusCode!='CA' order by CreatedDate desc
END

GO
/****** Object:  StoredProcedure [dbo].[PROC_GetCabReviewRequest]    Script Date: 11-07-2018 20:49:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROC_GetCabReviewRequest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PROC_GetCabReviewRequest] AS' 
END
GO
/*  
   Created Date      :     2018-06-25
   Created By        :     Kanchan Kumari
   Purpose           :     This stored procedure is used to get the cab request 
                           for manager
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   Test Case: 
	EXEC [dbo].[PROC_GetCabReviewRequest]
    @LoginUserId=1108
*/

ALTER PROC [dbo].[PROC_GetCabReviewRequest](
@LoginUserId INT
)
AS 
BEGIN
SET FMTONLY OFF;
IF OBJECT_ID('tempdb..#TempCabReviewdata') IS NOT NULL
	DROP TABLE #TempCabReviewdata
CREATE TABLE #TempCabReviewdata(
CabRequestId BIGINT NOT NULL,
EmployeeName VARCHAR(100) NOT NULL,
StatusCode VARCHAR(10) NOT NULL,
[Status] VARCHAR(50) NOT NULL,
Period VARCHAR(100) NOT NULL,
CreatedDate VARCHAR(50) NOT NULL,
[Shift] VARCHAR(10) NOT NULL,
Cab VARCHAR(10) NOT NULL
)

INSERT INTO #TempCabReviewdata

SELECT CR.CabRequestId AS CabRequestId,
       UD.FirstName+ ' '+UD.LastName AS EmployeeName,
       CSM.StatusCode AS StatusCode,
	   CSM.[Status]  AS   [Status],
	 CASE WHEN CR.FromDateId=CR.TillDateId THEN CAST(CONVERT(VARCHAR(20),DM1.[Date],106) AS Varchar(20)) 
							ELSE  CAST(CONVERT(VARCHAR(20),DM1.[Date],106) AS Varchar(20)) + '  To  ' + CAST(CONVERT(VARCHAR(20),DM2.[Date],106) AS Varchar(20) ) END AS [Period],
      Convert(VARCHAR(20), CR.CreatedDate,106)+' '+FORMAT( CR.CreatedDate, 'hh:mm tt') AS CreatedDate,
	   CS.CabShiftName AS [Shift],
	   CM.CabRegistrationNo AS Cab
 FROM CabRequest CR
 JOIN CabStatusMaster CSM ON CSM.StatusId=CR.StatusId
 JOIN CabShiftMaster CS ON CS.CabShiftId=CR.CabShiftId
 JOIN DateMaster DM1 ON DM1.DateId=CR.FromDateId
 JOIN DateMaster DM2 ON DM2.DateId=CR.TillDateId
 JOIN CabMaster CM ON CM.cabId=CR.CabId
 JOIN UserDetail UD ON UD.UserId=CR.CreatedBy
 WHERE CR.ApproverId=@LoginUserId order by CreatedDate desc

INSERT INTO #TempCabReviewdata
 SELECT CR.CabRequestId AS CabRequestId,
       UD.FirstName+ ' '+UD.LastName AS EmployeeName,
       CSM.StatusCode AS StatusCode,
	   CSM.[Status]  AS   [Status],
	 CASE WHEN CR.FromDateId=CR.TillDateId THEN CAST(CONVERT(VARCHAR(20),DM1.[Date],106) AS Varchar(20)) 
							ELSE  CAST(CONVERT(VARCHAR(20),DM1.[Date],106) AS Varchar(20)) + '  To  ' + CAST(CONVERT(VARCHAR(20),DM2.[Date],106) AS Varchar(20) ) END AS [Period],
      Convert(VARCHAR(20), CR.CreatedDate,106)+' '+FORMAT( CR.CreatedDate, 'hh:mm tt') AS CreatedDate,
	   CS.CabShiftName AS [Shift],
	   CM.CabRegistrationNo AS Cab
 FROM CabRequest CR
 JOIN CabStatusMaster CSM ON CSM.StatusId=CR.StatusId
 JOIN CabShiftMaster CS ON CS.CabShiftId=CR.CabShiftId
 JOIN DateMaster DM1 ON DM1.DateId=CR.FromDateId
 JOIN DateMaster DM2 ON DM2.DateId=CR.TillDateId
 JOIN CabMaster CM ON CM.cabId=CR.CabId
 JOIN UserDetail UD ON UD.UserId=CR.CreatedBy
 WHERE CR.LastModifiedBy=@LoginUserId AND CR.CreatedBy !=@LoginUserId order by CR.LastModifiedDate desc
 SELECT * FROM #TempCabReviewdata 
END

GO
/****** Object:  StoredProcedure [dbo].[PROC_GetDesignationListByDesignationGroup]    Script Date: 11-07-2018 20:49:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROC_GetDesignationListByDesignationGroup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PROC_GetDesignationListByDesignationGroup] AS' 
END
GO
/*  
   Created Date      :     2018-07-10
   Created By        :     Kanchan Kumari
   Purpose           :     This stored procedure is used to get designation
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   
   Test Case: 

   EXEC [PROC_GetDesignationListByDesignationGroup] @DesignationGroupIds='1,2'

   --------------------------------------------------------------------------
   */

ALTER PROC [dbo].[PROC_GetDesignationListByDesignationGroup]
(
	@DesignationGroupIds VARCHAR(500) = null
)

AS
BEGIN
SET FMTONLY OFF;

IF OBJECT_ID('tempdb..#TempDesignationList') IS NOT NULL
	DROP TABLE #TempDesignationList
 
CREATE TABLE #TempDesignationList(
DesignationId INT NOT NULL,
DesignationName VARCHAR(500) NOT NULL
)
		INSERT INTO	#TempDesignationList (DesignationId, DesignationName)
		SELECT D.DesignationId, D.DesignationName
			FROM DesignationGroup DG
			INNER JOIN dbo.[Designation] D ON DG.DesignationGroupId = D.DesignationGroupId
			WHERE DG.IsActive = 1 AND D.IsActive = 1
			AND (DG.DesignationGroupId IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt](@DesignationGroupIds, ','))  OR @DesignationGroupIds IS NULL OR @DesignationGroupIds = '')
		GROUP BY D.DesignationId, D.DesignationName
	
	SELECT * FROM #TempDesignationList
END
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetGeminiUsers]    Script Date: 11-07-2018 20:49:16 ******/
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
       U.EmployeeName,
	   U.ReportingManagerName AS Manager,
	   D.DepartmentName AS Department
      FROM vwActiveUsers U
	  JOIN UserTeamMapping UTM ON U.UserId=UTM.UserId
	  JOIN Team T ON T.TeamId=UTM.TeamId 
	  JOIN Department D ON D.DepartmentId=T.DepartmentId
END
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetPimcoIdExpirationData]    Script Date: 11-07-2018 20:49:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetPimcoIdExpirationData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetPimcoIdExpirationData] AS' 
END
GO
/*  
   Created Date      :     2018-07-10
   Created By        :     Kanchan Kumari
   Purpose           :     This stored procedure is used to get pimco id expiration data
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   
   Test Case: 

   Proc_GetPimcoIdExpirationData 1
   --------------------------------------------------------------------------
   */
  
ALTER PROC [dbo].[Proc_GetPimcoIdExpirationData]
@PimcoUserId BIGINT
AS
BEGIN
		SELECT 
			 CONVERT(VARCHAR(15),PU.UserValidFromDate,106) AS ValidFromDate
			,CONVERT(VARCHAR(15),PU.UserValidToDate,106) AS ValidTillDate
			,CONVERT(VARCHAR(15),PU.CreatedDate,106)+' '+FORMAT(PU.CreatedDate,'hh:mm tt') AS CreatedDate
			,UDT.EmployeeName AS AcknowledgedBy
			,PU.IsAcknowledged AS IsAcknowledged
            ,CONVERT(VARCHAR(15),PU.AcknowledgedDate,106)+' '+FORMAT(PU.AcknowledgedDate,'hh:mm tt') AS AcknowledgedDate
			,UDC.EmployeeName AS CreatedBy
			,CONVERT(VARCHAR(15),PU.ModifiedDate,106)+' '+FORMAT(PU.ModifiedDate,'hh:mm tt') AS ModifiedDate
			,UDMB.EmployeeName AS ModifiedBy
           FROM PimcoUserExpiration PU 
		  LEFT JOIN vwActiveUsers UDT ON PU.AcknowledgedBy=UDT.UserId
		  LEFT JOIN vwActiveUsers UDC ON PU.CreatedBy=UDC.UserId
		  LEFT JOIN vwActiveUsers UDMB ON PU.ModifiedBy = UDMB.UserId
		  WHERE PU.PimcoUserId=@PimcoUserId
		
END
  

GO
/****** Object:  StoredProcedure [dbo].[Proc_GetPimcoUsers]    Script Date: 11-07-2018 20:49:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetPimcoUsers]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetPimcoUsers] AS' 
END
GO
/*  
   Created Date      :     2018-07-10
   Created By        :     Kanchan Kumari
   Purpose           :     This stored procedure is used to get pimco user data
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   
   Test Case: 

   EXEC Proc_GetPimcoUsers
   --------------------------------------------------------------------------
   */


ALTER PROC [dbo].[Proc_GetPimcoUsers]
AS
BEGIN
		SELECT UD.EmployeeName
			,PU.PimcoEmployeeId AS PimcoEmpId
			,PU.PimcoUserId 
			,UD.ReportingManagerName AS GeminiManager
			,PU.PimcoManagerName AS PimcoManager
			,CONVERT(VARCHAR(15),PU.CreatedDate,106)+' '+FORMAT(PU.CreatedDate,'hh:mm tt') AS CreatedDate
			,UD.EmployeeName AS CreatedBy
			,CONVERT(VARCHAR(15),PU.ModifiedDate,106)+' '+FORMAT(PU.ModifiedDate,'hh:mm tt') AS ModifiedDate
			,UD.EmployeeName AS ModifiedBy
           FROM [PimcoUser] PU  
		  JOIN vwActiveUsers UD ON PU.GeminiUserId=UD.UserId 
		
END
GO

/****** Object:  StoredProcedure [dbo].[Proc_TakeActionOnCabRequest]    Script Date: 11-07-2018 20:49:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TakeActionOnCabRequest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_TakeActionOnCabRequest] AS' 
END
GO
/*  
   Created Date      :     2018-06-25
   Created By        :     Kanchan Kumari
   Purpose           :     This stored procedure is used take action on cab 
                           request
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   Test Case: 
	 DECLARE @Result int 
     EXEC [dbo].[Proc_TakeActionOnCabRequest]
	 @UserId=1108
	,@RequestId=28
	,@ActionCode='CA'
	,@Success = @Result output
    SELECT @Result AS [RESULT]
*/

ALTER PROCEDURE  [dbo].[Proc_TakeActionOnCabRequest]
(	 @UserId INT
	,@RequestId BIGINT
	,@ActionCode VARCHAR(5)
    ,@Success tinyInt=0 output
)
AS
BEGIN
BEGIN TRY	
	SET NOCOUNT ON;
	BEGIN TRANSACTION
	IF(@ActionCode='CA')
	BEGIN
		IF NOT EXISTS( SELECT 1 FROM [dbo].[CabRequestDetail] WHERE [CabRequestDetailId] = @RequestId)
		BEGIN
			SET @Success=0;
		END
		ELSE 
		BEGIN
		     
					DECLARE @Count INT, @NoOfDaysCount INT=0,@CabRequestId BIGINT,@FromDateId BIGINT,@TillDateId BIGINT
					SET @CabRequestId=(SELECT CabRequestId FROM CabRequestDetail WHERE CabRequestDetailId=@RequestId)
					 SET @FromDateId=(SELECT FromDateId FROM CabRequest WHERE CabRequestId=@CabRequestId)
					 SET @TillDateId=(SELECT TillDateId FROM CabRequest WHERE CabRequestId=@CabRequestId)
				
					UPDATE [dbo].[CabRequestDetail] SET
						[StatusId] = (SELECT StatusId FROM CabStatusMaster WHERE StatusCode = @ActionCode),
						[LastModifiedDate] = GETDATE(),
						[LastModifiedBy] = @UserId
						WHERE [CabRequestDetailId] = @RequestId	

				   SET @Count=(SELECT COUNT(CabRequestDetailId) FROM CabRequestDetail where CabRequestId=@CabRequestId AND StatusId=4)
				   WHILE(@FromDateId<=@TillDateId)
				   BEGIN
				   SET @NoOfDaysCount=@NoOfDaysCount+1;
				   SET @FromDateId=@FromDateId+1;
				   END

			  
				   IF(@Count=@NoOfDaysCount)
				   BEGIN
					UPDATE [dbo].[CabRequest] SET
						[StatusId] = (SELECT StatusId FROM CabStatusMaster WHERE StatusCode = @ActionCode),
						[ApproverId]=NULL,
						[LastModifiedDate] = GETDATE(),
						[LastModifiedBy] = @UserId
						WHERE [CabRequestId] = @CabRequestId	
					
				   END
				 SET @Success=1;
		END

	 END
	 ELSE IF( @ActionCode IN ('RJ', 'AP') )
	 BEGIN
		IF NOT EXISTS( SELECT 1 FROM [dbo].[CabRequest] WHERE [CabRequestId] = @RequestId)
		BEGIN
			SET @Success=0;
		END
		ELSE 
		BEGIN
			UPDATE [dbo].[CabRequest]
			SET [StatusId] = (SELECT StatusId FROM CabStatusMaster WHERE StatusCode=@ActionCode),
			ApproverId=null,
			[LastModifiedDate] = getdate(),
			[LastModifiedBy] = @UserId
			WHERE CabRequestId = @RequestId

			UPDATE [dbo].[CabRequestDetail]
			SET
			[StatusId] = (SELECT StatusId FROM CabStatusMaster WHERE StatusCode=@ActionCode),
			[LastModifiedDate] = GETDATE(),
			[LastModifiedBy] = @UserId
			WHERE [CabRequestId] = @RequestId

			 SET @Success=1;
		END
		
	 END
		
		COMMIT TRANSACTION;
	
END TRY
BEGIN CATCH
	IF @@TRANCOUNT>0
	ROLLBACK TRANSACTION         
		DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
		EXEC [spInsertErrorLog]
		@ModuleName = 'CabRequest'
		,@Source = '[Proc_TakeActionOnCabRequest]'
		,@ErrorMessage = @ErrorMessage
		,@ErrorType = 'SP'
		,@ReportedByUserId=@UserId  
	SET @Success=0;----successfully updated
END CATCH
END
GO

/****** Object:  StoredProcedure [dbo].[Proc_TakeActionOnCabBulkApprove]    Script Date: 11-07-2018 20:49:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TakeActionOnCabBulkApprove]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_TakeActionOnCabBulkApprove] AS' 
END
GO
/*  
   Created Date      :     2018-06-25
   Created By        :     Kanchan Kumari
   Purpose           :     This stored procedure is used for bulk cab approve
                           for manager
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   Test Case: 
	EXEC [dbo].[Proc_TakeActionOnCabBulkApprove]
	 @userId=1108
	,@requestId='28,39'
	,@statusCode='AP'
*/

ALTER PROC [dbo].[Proc_TakeActionOnCabBulkApprove](
 @UserId INT
,@RequestId varchar(200)
,@StatusCode VARCHAR(5)
)
AS
BEGIN
 SET NOCOUNT ON;  
      SET FMTONLY OFF;

	   IF OBJECT_ID('tempdb..#CabStatus') IS NOT NULL
		DROP TABLE #CabStatus

	   IF OBJECT_ID('tempdb..#TempCabTable') IS NOT NULL
		DROP TABLE #TempCabTable

		DECLARE @Id int

		
		create table #CabStatus(
		[Id] int IDENTITY(1, 1),
		Msg INT,
		CabRequestId BIGINT 
		)
		create table #TempCabTable(
		     [Id] int IDENTITY(1, 1),
			 [CabRequestId] BIGINT
			 )

		 insert INTO #TempCabTable([CabRequestId]) SELECT SplitData as [CabRequestId] FROM [dbo].[Fun_SplitStringInt] (@requestId,',')
		
		 DECLARE @Count int = 1
                        WHILE(@Count <= (SELECT COUNT(*) FROM #TempCabTable))
                        BEGIN
						  DECLARE @CabRequestId BIGINT 
						     SELECT  @CabRequestId = CabRequestId FROM #TempCabTable C WHERE C.[Id] = @Count
							  DECLARE @result INT
						    EXEC [dbo].[Proc_TakeActionOnCabRequest] @UserId, @CabRequestId, @StatusCode, @result OUTPUT
							INSERT INTO #CabStatus (Msg) VALUES( @result)
							
							UPDATE #CabStatus SET CabRequestId = @CabRequestId WHERE Id = SCOPE_IDENTITY();

                        SET @Count = @Count + 1
						END

		SELECT Msg, CabRequestId from #CabStatus
END

GO
/****** Object:  StoredProcedure [dbo].[spGetShiftUserMappingList]    Script Date: 11-07-2018 20:49:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetShiftUserMappingList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGetShiftUserMappingList] AS' 
END
GO

/***
   Created Date      :     2017-02-08
   Created By        :     Jitender Kumar
   Purpose           :     stored procedure to get Shift User Mapping List
   Change History    :
   -------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   
   --------------------------------------------------------------------------

   Test Cases        :
   --------------------------------------------------------------------------
   
   --- Test Case 1
         EXEC [dbo].[spGetShiftUserMappingList]
		  @TeamIds  = ''
		  ,@ShiftIds  = '3'		 
		  ,@StartDate = '2017-02-06'
		  ,@EndDate  = '2017-02-12'		  
		  ,@LoginUserId  =1109
***/
--DECLARE
--		   @TeamIds varchar(4000) = '36'
--		  ,@ShiftIds varchar(4000) = '3'		 
--		  ,@StartDate DATE = '2017-02-06'
--		  ,@EndDate DATE = '2017-02-12'		  
--		  ,@LoginUserId [int] =1109

ALTER PROCEDURE [dbo].[spGetShiftUserMappingList]
(
   @TeamIds varchar(4000) = NULL
  ,@ShiftIds varchar(4000) = NULL
  ,@StartDate DATETIME
  ,@EndDate DATETIME  
  ,@LoginUserId [int]
)
AS
BEGIN      
SET NOCOUNT ON;
SET FMTONLY OFF;

   IF OBJECT_ID('tempdb..#TeampShiftUserMappingList') IS NOT NULL
   DROP TABLE #TeampShiftUserMappingList

    CREATE TABLE #TeampShiftUserMappingList (MappingId BIGINT,TeamId Int, TeamName VARCHAR(100),UserName VARCHAR(100), ShiftName VARCHAR(100), DateId BIGINT,DateValue VARCHAR(30),
	             [Day] VARCHAR(20),InTime VARCHAR(10),OutTime VARCHAR(10),IsWeekEnd [bit],IsNight [bit],UserId Int,ShiftId Int,ShiftType VARCHAR(30),)

	INSERT Into #TeampShiftUserMappingList (MappingId,TeamId, TeamName, UserName,ShiftName,DateId,DateValue,[Day],InTime,OutTime,IsWeekEnd,IsNight,UserId,ShiftId,ShiftType)
	SELECT USM.MappingId,T.TeamId, T.TeamName, US.FirstName+' '+US.LastName, SM.ShiftName,USM.DateId,convert(VARCHAR(30),DM.[Date],106),DM.[Day],SM.InTime,SM.OutTime,SM.IsWeekEnd,SM.IsNight,USM.UserId,USM.ShiftId,
	CASE WHEN (SM.IsNight = 1 AND SM.IsWeekEnd = 1) THEN 'Night || Weekend' WHEN (SM.IsNight = 1 AND SM.IsWeekEnd = 0) THEN 'Night || Weekday' 
		WHEN (SM.IsNight = 0 AND SM.IsWeekEnd = 1) THEN 'Day || Weekend' WHEN (SM.IsNight = 0 AND SM.IsWeekEnd = 0) THEN 'Day || Weekday' ELSE 'NA' END as ShiftType
	FROM UserShiftMapping USM WITH (NOLOCK)
    INNER JOIN [dbo].[ShiftMaster] SM WITH (NOLOCK) ON USM.ShiftId = SM.ShiftId
    INNER JOIN [dbo].[UserTeamMapping] UTM WITH (NOLOCK) ON USM.UserId = UTM.UserId
    INNER JOIN [dbo].[Team] T WITH (NOLOCK) ON UTM.TeamId = T.TeamId
    INNER JOIN [dbo].[DateMaster] DM WITH (NOLOCK) ON USM.DateId = DM.DateId
	INNER JOIN [dbo].[UserDetail] US WITH (NOLOCK) ON USM.UserId = US.UserId 
	WHERE USM.IsActive=1 AND
	USM.DateId IN (SELECT DateId FROM DateMaster WHERE ([Date] >=@StartDate AND [Date]<=@EndDate) )	
	AND USM.[ShiftId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@ShiftIds,',')) OR @ShiftIds IS NULL
	
	select T.MappingId, T.TeamName, T.UserName,T.ShiftName,T.DateId,T.DateValue,T.[Day],T.InTime,T.OutTime,T.IsWeekEnd,T.IsNight,T.ShiftType,T.UserId,T.ShiftId
	from #TeampShiftUserMappingList T WHERE T.[TeamId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@TeamIds,',')) OR @TeamIds IS NULL OR @TeamIds = ''
	ORDER BY T.TeamName
      
END


GO
/****** Object:  StoredProcedure [dbo].[spLapseCompOff]    Script Date: 11-07-2018 20:49:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spLapseCompOff]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spLapseCompOff] AS' 
END
GO
/**

EXEC [dbo].[spLapseCompOff]
**/

ALTER PROCEDURE [dbo].[spLapseCompOff]
AS
SET NOCOUNT ON;
SET FMTONLY OFF;
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
		CREATE TABLE #TempCompOffCount([UserId] int, [Count] int)

		--mark IsLapsed = 1
		UPDATE [dbo].[RequestCompOff] 
		SET IsLapsed =1
		WHERE 
		[LapseDate] < GETDATE()
		AND [StatusId] > 0
		AND [IsAvailed] = 0
		AND [RequestId] NOT IN (SELECT C.[RequestId] FROM [dbo].[RequestCompOffDetail] C
											   INNER JOIN [dbo].[LeaveRequestApplication] L ON C.[LeaveRequestApplicationId] = L.[LeaveRequestApplicationId]
											   AND L.[StatusId] > 0)

		--insert all active userIds and theird current comp off count
		INSERT INTO #TempCompOffCount
		SELECT
			LB.[UserId]
		   ,LB.[Count]
		FROM [dbo].[LeaveBalance] LB
		  INNER JOIN
			 [dbo].[UserDetail] UD
			 ON LB.[UserId] = UD.[UserId]
			 AND UD.[TerminateDate] IS NULL
		WHERE [LeaveTypeId] = 4

		--update #TempCompOffCount table with correct comp off count
		UPDATE T
		SET 
		  T.[Count] = RC.[Count]
		FROM #TempCompOffCount T
		  INNER JOIN
			 (
			 SELECT 
				SUM(R.[NoOfDays]) AS [Count]
				,R.[CreatedBy]
			 FROM
				[dbo].[RequestCompOff] R
			 WHERE
				R.[IsAvailed] = 0
				AND R.[IsLapsed] = 0
				AND R.[LapseDate] > GETDATE()
				AND R.[StatusId] > 2
			 GROUP BY R.[CreatedBy]
			 ) RC
		  ON T.[UserId] = RC.[CreatedBy]

		--update #TempCompOffCount set comp off count = 0 for users who dont have any comp off
		DELETE FROM #TempCompOffCount WHERE [Count] IS NULL

	    --Insert into [Leave Balance History]-----------
		INSERT INTO dbo.[LeaveBalanceHistory]([RecordId],[Count],[CreatedDate],[CreatedBy])
		SELECT LB.[RecordId],LB.[Count],GETDATE(), 1 
		FROM LeaveBalance LB 
		JOIN #TempCompOffCount TC ON LB.[UserId]=TC.[UserId]
		WHERE LB.[LeaveTypeId]=4


		--update [Levae Balance] with corerct comp off count
		UPDATE LB 
		SET 
			LB.[Count] = LBD.[Count] 
		FROM [dbo].[LeaveBalance] LB 
			INNER JOIN #TempCompOffCount LBD 
			ON LB.UserId=LBD.UserId
		WHERE  LB.[LeaveTypeId] = 4

		COMMIT TRANSACTION
		
		--drop temp table
		DROP TABLE #TempCompOffCount
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION
	END CATCH	
END
GO
/****** Object:  StoredProcedure [dbo].[spUpdateContactDetails]    Script Date: 11-07-2018 20:49:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spUpdateContactDetails]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spUpdateContactDetails] AS' 
END
GO
-- =============================================
-- Author		:	CHANDRA PRAKASH
-- Create date	:   03 AUGUST 2016
-- Description	:	UPDATE Employee Contact Details.
-- EXEC [dbo].[spUpdateContactDetails] 15,1109
-- =============================================
ALTER PROCEDURE [dbo].[spUpdateContactDetails]
@RequestId int,
@UserId int,
@hrID int 
AS
BEGIN
SET NOCOUNT ON;

DECLARE @MobileNo VARCHAR(50),
		@ExtnNo VARCHAR(50),
		@UPDATEFLAG INT

   SELECT @UPDATEFLAG=IsActionPerformed FROM [DBO].[ChangeExtnRequest] WHERE RequestId=@RequestId;
   PRINT @UPDATEFLAG
   IF(@UPDATEFLAG=0)
	   BEGIN
				   SELECT @MobileNo=NewMobileNo FROM [DBO].[ChangeExtnRequest] WHERE RequestId=@RequestId and IsActionPerformed=0;
				   SELECT @ExtnNo=NewExtnNo FROM [DBO].[ChangeExtnRequest] WHERE RequestId=@RequestId and IsActionPerformed=0;
	
				   UPDATE [DBO].[ChangeExtnRequest] SET IsActionPerformed=1,ActionTakenById=@hrID,ActionDate=getdate() WHERE RequestId=@RequestId;
				   --Update Mobile No
				   IF @MobileNo IS NOT NULL AND @MobileNo !='' 
					   BEGIN
					   UPDATE [dbo].[UserDetail] SET MobileNumber=@MobileNo where UserId=@UserId;
					   END

				   --Update Extn. No
					IF @ExtnNo IS NOT NULL AND @ExtnNo !=''
						BEGIN
						UPDATE [dbo].[UserDetail] SET ExtensionNumber=@ExtnNo where UserId=@UserId;
						END

					 SELECT 1  AS [Result]
		END
	ELSE
		SELECT 0  AS [Result]
END




GO
