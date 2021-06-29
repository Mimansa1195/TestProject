IF OBJECT_ID('CabRequestDetail') IS NOT NULL
DROP TABLE [dbo].[CabRequestDetail]

IF OBJECT_ID('CabRequest') IS NOT NULL
DROP TABLE [dbo].[CabRequest]

IF OBJECT_ID('CabShiftMapping') IS NOT NULL
DROP TABLE [dbo].[CabShiftMapping]

IF OBJECT_ID('CabMaster') IS NOT NULL
DROP TABLE [dbo].[CabMaster]

IF OBJECT_ID('CabShiftMaster') IS NOT NULL
DROP TABLE [dbo].[CabShiftMaster]

IF OBJECT_ID('CabStatusMaster') IS NOT NULL
DROP TABLE [dbo].[CabStatusMaster]

IF OBJECT_ID('DropLocation') IS NOT NULL
DROP TABLE [dbo].[DropLocation]

IF OBJECT_ID('CabRoute') IS NOT NULL
DROP TABLE [dbo].[CabRoute]

------------------------------
CREATE TABLE CabRoute
(
 CabRouteId INT IDENTITY(1,1),
 CabRoute VARCHAR(100) NOT NULL,
 IsActive BIT NOT NULL,
 CreatedDate DATETIME NOT NULL,
 CreatedBy INT NOT NULL,
 ModifiedDate DATETIME NULL,
 ModifiedBy INT NULL,
CONSTRAINT [PK_CabRouteId] PRIMARY KEY CLUSTERED 
(
	[CabRouteId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE CabRoute ADD CONSTRAINT DF_CabRoute_IsActive DEFAULT(1) FOR [IsActive]
GO

ALTER TABLE CabRoute ADD CONSTRAINT DF_CabRoute_CreatedDate DEFAULT(GETDATE()) FOR [CreatedDate]
GO
-----------------------------
CREATE TABLE DropLocation
(
 DropLocationId INT IDENTITY(1,1),
 DropLocation VARCHAR(200) NOT NULL,
 CabRouteId INT NOT NULL,
 IsActive BIT NOT NULL,
 CreatedDate DATETIME NOT NULL,
 CreatedBy INT NOT NULL,
 ModifiedDate DATETIME NULL,
 ModifiedBy INT NULL,
CONSTRAINT [PK_DropLocationId] PRIMARY KEY CLUSTERED 
(
	[DropLocationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE DropLocation WITH CHECK ADD CONSTRAINT FK_DropLocation_CabRoute_CabRouteId FOREIGN KEY ([CabRouteId]) REFERENCES CabRoute(CabRouteId)
GO
ALTER TABLE DropLocation  CHECK CONSTRAINT FK_DropLocation_CabRoute_CabRouteId
GO

ALTER TABLE DropLocation  ADD CONSTRAINT DF_DropLocation_IsActive DEFAULT(1) FOR [IsActive]
GO

ALTER TABLE DropLocation  ADD CONSTRAINT DF_DropLocation_CreatedDate DEFAULT(GETDATE()) FOR [CreatedDate]
GO

--------CabShiftMaster
CREATE TABLE CabShiftMaster(
	[CabShiftId] [int] IDENTITY(1,1) NOT NULL,
	[CabShiftName] [varchar](20) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[LastModifiedDate] [datetime] NULL,
	[LastModifiedBy] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[CabShiftId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE CabShiftMaster  ADD CONSTRAINT DF_CabShiftMaster_IsActive DEFAULT(1) FOR [IsActive]
GO

ALTER TABLE CabShiftMaster  ADD CONSTRAINT DF_CabShiftMaster_CreatedDate DEFAULT(GETDATE()) FOR [CreatedDate]
GO

---------CabStatusMaster
CREATE TABLE CabStatusMaster(
	[StatusId] [int] IDENTITY(1,1) NOT NULL,
	[StatusCode] [varchar](5) NOT NULL,
	[Status] [varchar](20) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[StatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE CabStatusMaster  ADD CONSTRAINT DF_CabStatusMaster_IsActive DEFAULT(1) FOR [IsActive]
GO

ALTER TABLE CabStatusMaster  ADD CONSTRAINT DF_CabStatusMaster_CreatedDate DEFAULT(GETDATE()) FOR [CreatedDate]
GO


-------CabRequest

CREATE TABLE [dbo].[CabRequest](
	[CabRequestId] [bigint] IDENTITY(1,1) NOT NULL,
	[DateId] [bigint] NOT NULL,
	[CabShiftId] [int] NOT NULL,
	[DropLocationId] [int] NOT NULL,
	[LocationDetail] VARCHAR(500) NULL,
	[StatusId] [int] NOT NULL,
	[ApproverId] [bigint] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[LastModifiedDate] [datetime] NULL,
	[LastModifiedBy] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[CabRequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[CabRequest]  WITH CHECK ADD CONSTRAINT FK_CabRequest_DropLocation_DropLocationId FOREIGN KEY([DropLocationId])
REFERENCES [dbo].[DropLocation] ([DropLocationId])
GO

ALTER TABLE [dbo].[CabRequest] CHECK CONSTRAINT FK_CabRequest_DropLocation_DropLocationId
GO

ALTER TABLE [dbo].[CabRequest]  WITH CHECK ADD CONSTRAINT FK_CabRequest_CabShiftMaster_CabShiftId FOREIGN KEY([CabShiftId])
REFERENCES [dbo].[CabShiftMaster] ([CabShiftId])
GO

ALTER TABLE [dbo].[CabRequest] CHECK CONSTRAINT FK_CabRequest_CabShiftMaster_CabShiftId
GO

ALTER TABLE [dbo].[CabRequest]  WITH CHECK ADD CONSTRAINT FK_CabRequest_CabStatusMaster_StatusId FOREIGN KEY([StatusId])
REFERENCES [dbo].[CabStatusMaster] ([StatusId])
GO

ALTER TABLE [dbo].[CabRequest] CHECK CONSTRAINT FK_CabRequest_CabStatusMaster_StatusId
GO

ALTER TABLE [dbo].[CabRequest]  ADD CONSTRAINT DF_CabRequest_CreatedDate DEFAULT(GETDATE()) FOR [CreatedDate]
GO


INSERT INTO [CabStatusMaster](StatusCode, [Status], CreatedBy)
VALUES('AD','Applied',1), ('PA','Pending for approval',1), 
      ('AP','Approved',1), ('RJ','Rejected',1), ('CA','Cancelled',1) 

INSERT INTO [CabShiftMaster](CabShiftName, CreatedBy)
VALUES('9:30 PM', 1), ('10:30 PM',1)

INSERT INTO [CabRoute](CabRoute, CreatedBy)
VALUES('Sector 21 > Sectro 22 B > Sector 22 A > Sector 23', 1)
     ,('Dlf phase 3> Dronacharya > Sikanderpur > Dlf phase 2 > Sector 31 > sector 14',1)

INSERT INTO [DropLocation](DropLocation, CabRouteId, CreatedBy)
VALUES('Sector 21', 1 ,1), ('Sectro 22 B', 1, 1), ('Sector 22 A', 1, 1), ('Sector 23', 1, 1)
     ,('Dlf phase 3',2,1), ('Dronacharya', 2, 1), ('Sikanderpur', 2, 1), ('Dlf phase 2', 2, 1)
	 ,('Sector 31', 2, 1), ('sector 14', 2, 1)





