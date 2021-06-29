IF OBJECT_ID('CabRequestDetail') IS NOT NULL
DROP TABLE [dbo].[CabRequestDetail]

IF OBJECT_ID('CabShiftMapping') IS NOT NULL
DROP TABLE [dbo].[CabShiftMapping]

IF OBJECT_ID('CabMaster') IS NOT NULL
DROP TABLE [dbo].[CabMaster]

IF OBJECT_ID('DropLocation') IS NOT NULL
DROP TABLE [dbo].[DropLocation]

IF OBJECT_ID('CabRoute') IS NOT NULL
DROP TABLE [dbo].[CabRoute]

IF OBJECT_ID('CabRequestHistory') IS NOT NULL
DROP TABLE [dbo].[CabRequestHistory]

IF OBJECT_ID('CabRequest') IS NOT NULL
DROP TABLE [dbo].[CabRequest]

IF OBJECT_ID('CabPickDropLocation') IS NOT NULL
DROP TABLE [dbo].[CabPickDropLocation]

IF OBJECT_ID('CabShiftMaster') IS NOT NULL
DROP TABLE [dbo].[CabShiftMaster]

IF OBJECT_ID('CabServiceType') IS NOT NULL
DROP TABLE [dbo].[CabServiceType]

IF OBJECT_ID('CabStatusMaster') IS NOT NULL
DROP TABLE [dbo].[CabStatusMaster]

IF OBJECT_ID('FinalizedCabRequest') IS NOT NULL
DROP TABLE [dbo].[FinalizedCabRequest]

IF OBJECT_ID('VehicleDetails') IS NOT NULL
DROP TABLE [dbo].[VehicleDetails]


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

--CabServiceType
CREATE TABLE CabServiceType
(
 [ServiceTypeId] INT IDENTITY(1,1) NOT NULL,
 [ServiceType] VARCHAR(20) NOT NULL,
 IsActive BIT NOT NULL,
 CreatedDate DATETIME NOT NULL,
 CreatedBy INT NOT NULL,
 ModifiedDate DATETIME NULL,
 ModifiedBy INT NULL,
PRIMARY KEY CLUSTERED 
(
	[ServiceTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE CabServiceType  ADD CONSTRAINT DF_CabServiceType_IsActive DEFAULT(1) FOR [IsActive]
GO
ALTER TABLE CabServiceType  ADD CONSTRAINT DF_CabServiceType_CreatedDate DEFAULT(GETDATE()) FOR [CreatedDate]
GO

--------CabShiftMaster
CREATE TABLE CabShiftMaster(
	[CabShiftId] [int] IDENTITY(1,1) NOT NULL,
	[ServiceTypeId] INT NOT NULL,
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

--CabPickDropLocation

CREATE TABLE CabPickDropLocation
(
 CabPDLocationId INT IDENTITY(1,1) NOT NULL,
 LocationId INT NOT NULL,
 [RouteNo] INT NOT NULL,
 [RouteLocation] VARCHAR(200) NOT NULL,
 [Sequence] INT NOT NULL,
 [IsActive] BIT NOT NULL,
 CreatedDate DATETIME NOT NULL,
 CreatedBy INT NOT NULL,
 ModifiedDate DATETIME NULL,
 ModifiedBy INT NULL,
PRIMARY KEY CLUSTERED 
(
	[CabPDLocationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE CabPickDropLocation WITH CHECK ADD CONSTRAINT FK_CabPickDropLocation_Location_LocationId
  FOREIGN KEY ([LocationId]) REFERENCES Location(LocationId)
GO
ALTER TABLE CabPickDropLocation  CHECK CONSTRAINT FK_CabPickDropLocation_Location_LocationId
GO

ALTER TABLE CabPickDropLocation  ADD CONSTRAINT DF_CabPickDropLocation_IsActive DEFAULT(1) FOR [IsActive]
GO
ALTER TABLE CabPickDropLocation  ADD CONSTRAINT DF_CabPickDropLocation_CreatedDate DEFAULT(GETDATE()) FOR [CreatedDate]
GO


-------CabRequest

CREATE TABLE [dbo].[CabRequest](
	[CabRequestId] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[DateId] [BIGINT] NOT NULL,
	[EmpContactNo] VARCHAR(15) NOT NULL,
	[CabShiftId] [int] NOT NULL,
	[CabPDLocationId] [int] NOT NULL,
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


ALTER TABLE [dbo].[CabRequest]  WITH CHECK ADD CONSTRAINT FK_CabRequest_User_UserId FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([UserId])
GO

ALTER TABLE [dbo].[CabRequest] CHECK CONSTRAINT FK_CabRequest_User_UserId
GO

ALTER TABLE [dbo].[CabRequest]  WITH CHECK ADD CONSTRAINT FK_CabRequest_CabPickDropLocation_CabPDLocationId FOREIGN KEY([CabPDLocationId])
REFERENCES [dbo].[CabPickDropLocation] ([CabPDLocationId])
GO

ALTER TABLE [dbo].[CabRequest] CHECK CONSTRAINT FK_CabRequest_CabPickDropLocation_CabPDLocationId
GO

ALTER TABLE [dbo].[CabRequest]  WITH CHECK ADD CONSTRAINT FK_CabRequest_CabShiftMaster_CabShiftId FOREIGN KEY([CabShiftId])
REFERENCES [dbo].[CabShiftMaster] ([CabShiftId])
GO

ALTER TABLE [dbo].[CabRequest] CHECK CONSTRAINT FK_CabRequest_CabShiftMaster_CabShiftId
GO

ALTER TABLE [dbo].[CabRequest]  WITH CHECK ADD CONSTRAINT FK_CabRequest_DateMaster_Date FOREIGN KEY([DateId])
REFERENCES [dbo].[DateMaster] ([DateId])
GO

ALTER TABLE [dbo].[CabRequest] CHECK CONSTRAINT FK_CabRequest_DateMaster_Date
GO

ALTER TABLE [dbo].[CabRequest]  WITH CHECK ADD CONSTRAINT FK_CabRequest_CabStatusMaster_StatusId FOREIGN KEY([StatusId])
REFERENCES [dbo].[CabStatusMaster] ([StatusId])
GO

ALTER TABLE [dbo].[CabRequest] CHECK CONSTRAINT FK_CabRequest_CabStatusMaster_StatusId
GO

ALTER TABLE [dbo].[CabRequest]  ADD CONSTRAINT DF_CabRequest_CreatedDate DEFAULT(GETDATE()) FOR [CreatedDate]
GO

--CabRequestHistory

CREATE TABLE CabRequestHistory
(
    [CabRequestHistoryId] [int] IDENTITY(1,1) NOT NULL,
	[CabRequestId] [bigint] NOT NULL,
	[Remarks] VARCHAR(500) NULL,
	[StatusId] INT NOT NULL,
	[Status] VARCHAR(20) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CabRequestHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[CabRequestHistory]  WITH CHECK ADD CONSTRAINT FK_CabRequestHistory_CabRequest_CabRequestId FOREIGN KEY([CabRequestId])
REFERENCES [dbo].[CabRequest] ([CabRequestId])
GO

ALTER TABLE [dbo].[CabRequestHistory] CHECK CONSTRAINT FK_CabRequestHistory_CabRequest_CabRequestId
GO

ALTER TABLE [dbo].[CabRequestHistory]  WITH CHECK ADD CONSTRAINT FK_CabRequestHistory_CabStatusMaster_StatusId FOREIGN KEY([StatusId])
REFERENCES [dbo].[CabStatusMaster] ([StatusId])
GO

ALTER TABLE [dbo].[CabRequestHistory] CHECK CONSTRAINT FK_CabRequestHistory_CabStatusMaster_StatusId
GO

ALTER TABLE [CabRequestHistory]  ADD CONSTRAINT DF_CabRequestHistory_CreatedDate DEFAULT(GETDATE()) FOR [CreatedDate]
GO

-----------------------------------------------
CREATE TABLE VehicleDetails
(
 VehicleId INT NOT NULL IDENTITY(1,1),
 Vehicle VARCHAR(100) NOT NULL,
 LocationId INT NOT NULL,
 IsActive BIT NOT NULL,
 [CreatedDate] [datetime] NOT NULL,
 [CreatedBy] [int] NOT NULL,
 [LastModifiedDate] [datetime] NULL,
 [LastModifiedBy] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[VehicleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[VehicleDetails]  WITH CHECK ADD CONSTRAINT FK_VehicleDetails_Location_LocationId FOREIGN KEY([LocationId])
REFERENCES [dbo].[Location] ([LocationId])
GO

ALTER TABLE [dbo].[VehicleDetails] CHECK CONSTRAINT FK_VehicleDetails_Location_LocationId
GO

ALTER TABLE [VehicleDetails]  ADD CONSTRAINT DF_VehicleDetails_IsActive DEFAULT(1) FOR [IsActive]
GO

ALTER TABLE [VehicleDetails]  ADD CONSTRAINT DF_VehicleDetails_CreatedDate DEFAULT(GETDATE()) FOR [CreatedDate]
GO


CREATE TABLE FinalizedCabRequest
(
    [FCRequestId] [bigint] IDENTITY(1,1) NOT NULL,
	[CabRequestIds] VARCHAR(1000) NOT NULL,
	[VehicleId] INT NOT NULL,
	[StaffId] BIGINT NULL,
	[StaffName] VARCHAR(100) NULL,
	[StaffContactNo] VARCHAR(20) NULL,
	[IsActive] BIT NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[LastModifiedDate] [datetime] NULL,
	[LastModifiedBy] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[FCRequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[FinalizedCabRequest]  WITH CHECK ADD CONSTRAINT FK_FinalizedCabRequest_SupportingStaffMember_StaffId FOREIGN KEY([StaffId])
REFERENCES [dbo].[SupportingStaffMember] ([RecordId])
GO

ALTER TABLE [dbo].[FinalizedCabRequest] CHECK CONSTRAINT FK_FinalizedCabRequest_SupportingStaffMember_StaffId
GO

ALTER TABLE [dbo].[FinalizedCabRequest]  WITH CHECK ADD CONSTRAINT FK_FinalizedCabRequest_VehicleDetails_VehicleId FOREIGN KEY([VehicleId])
REFERENCES [dbo].[VehicleDetails] ([VehicleId])
GO

ALTER TABLE [dbo].[FinalizedCabRequest] CHECK CONSTRAINT FK_FinalizedCabRequest_VehicleDetails_VehicleId
GO

ALTER TABLE [FinalizedCabRequest]  ADD CONSTRAINT DF_FinalizedCabRequest_IsActive DEFAULT(1) FOR [IsActive]
GO

ALTER TABLE [FinalizedCabRequest]  ADD CONSTRAINT DF_FinalizedCabRequest_CreatedDate DEFAULT(GETDATE()) FOR [CreatedDate]
GO


INSERT INTO CabServiceType(ServiceType, CreatedBy)
VALUES('Pick Up',1), ('Drop',1)
   
INSERT INTO [CabStatusMaster](StatusCode, [Status], CreatedBy)
VALUES('AD','Applied',1), ('PA','Pending for approval',1), 
      ('AP','Approved',1),('PF','Pending finalization',1),('FD','Finalized',1), ('RJ','Rejected',1), ('CA','Cancelled',1) 

INSERT INTO [CabShiftMaster](ServiceTypeId, CabShiftName, CreatedBy)
VALUES (1, '6:30 AM', 1), (1, '8:00 PM',1), (2, '7:00 AM', 1), (2, '9:45 PM',1),  (2, '10:45 PM',1)

INSERT INTO [CabPickDropLocation](LocationId, RouteNo, RouteLocation, [Sequence], CreatedBy)
VALUES(1,1, 'Sector 21', 1 ,1), (1,1,'Sectro 22 B', 2, 1), (1,1,'Sector 22 A', 3, 1), (1,1,'Sector 23', 4, 1)
     ,(1,2,'DLF phase 3',1,1), (1,2, 'Dronacharya', 2, 1), (1,2, 'Sikanderpur',3, 1), (1,2,'DLF phase 2', 4, 1)
	 ,(1,2,'Sector 31', 5, 1),  (1,2,'sector 17', 6, 1), (1,2,'sector 14', 7, 1)
	 ,(6,3,'Panchkula Sector 12', 1, 1),(6,3,'Sector 20', 2, 1),(6,3,'Sector 7', 3, 1),
	 (6,3,'Chandhigarh Sector 50', 4, 1)

INSERT INTO VehicleDetails(Vehicle, LocationId, CreatedBy)
VALUES('Xylo HR26BD 9523', 1, 1),( 'Ertiga HR26CR 0889', 1, 1), ( 'Ertiga HR26DV 9167', 1 ,1),
( 'Scorpio HR76A9431', 1 ,1), ('Honda City HR26CW 7536',6,1), ('New Ertiga HR26DV 5427',6,1)
      
---------------------------------------------------------------------------------

ALTER TABLE SupportingStaffMember ADD MobileNo VARCHAR(100) NULL

ALTER TABLE SupportingStaffMember ADD LocationId INT NULL

UPDATE SupportingStaffMember SET LocationId = 1 

ALTER TABLE SupportingStaffMember ALTER COLUMN LocationId INT NOT NULL

ALTER TABLE [dbo].[SupportingStaffMember]  WITH CHECK ADD CONSTRAINT FK_SupportingStaffMember_Location_LocationId FOREIGN KEY([LocationId])
REFERENCES [dbo].[Location] ([LocationId])
GO

ALTER TABLE [dbo].[SupportingStaffMember] CHECK CONSTRAINT FK_SupportingStaffMember_Location_LocationId
GO

--IF OBJECT_ID('tempdb..#TempSTaffMember') IS NOT NULL
--DROP TABLE #TempSTaffMember

--CREATE TABLE #TempSTaffMember
--(
--Name VARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS,
--MobileNo VARCHAR(100)
--)
--INSERT INTO #TempSTaffMember(Name, MobileNo)
--VALUES
--('DINESH KORI (Driver)',	'7895972588'),
--('Vikas Tanwar (Driver)',	'9560883560'),
--('Raju (Driver)',	'7503452999'),
--('Ashok Kumar (Driver)',	'9810382102'),
--('Gaurav Singh (Driver)',	'9718310320'),
--('Mandeep Lakra (Driver)',	'8860966545'),
--('Sanjay (Driver)',	'9996385211'),
--('Sunder Lal (Driver)',	'9868732526'),
--('Gurdeep Singh (Driver)',	'7837364438'),
--('Jasbir (Driver)',	'8360210844')


--UPDATE S SET S.MobileNo = N.MobileNo 
--FROM SupportingStaffMember S INNER JOIN
--(
--	SELECT T.Name, T.MobileNo
--	FROM  #TempSTaffMember T 
--	LEFT JOIN SupportingStaffMember ST ON T.Name = ST.EmployeeName
--	WHERE ST.EmployeeName IS NOT NULL
--) N ON S.EmployeeName = N.Name


--INSERT INTO SupportingStaffMember(EmployeeName, MobileNo, LocationId, CreatedBy)
--SELECT T.Name, T.MobileNo, 1, 1 
--FROM  #TempSTaffMember T 
--LEFT JOIN SupportingStaffMember ST ON T.Name = ST.EmployeeName
--WHERE ST.EmployeeName IS NULL


--IF OBJECT_ID('tempdb..#TempStffMember') IS NOT NULL
--DROP TABLE #TempStffMember

--CREATE TABLE #TempStffMember
--(
--Name VARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS,
--)
--INSERT INTO #TempStffMember(Name)
--VALUES('Rekha'), ('Kesar'), ('Sukhdev (Guard)'), ('Karan')


--INSERT INTO SupportingStaffMember(EmployeeName, LocationId, CreatedBy)
--SELECT T.Name, 1, 1 
--FROM  #TempStffMember T 
--LEFT JOIN SupportingStaffMember ST ON T.Name = ST.EmployeeName
--WHERE ST.EmployeeName IS NULL
