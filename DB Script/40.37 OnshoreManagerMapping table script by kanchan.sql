CREATE TABLE OnshoreManager
(
 OnshoreMgrId BIGINT NOT NULL IDENTITY(1,1),
 ManagerName VARCHAR(200) NOT NULL,
 EmailId VARCHAR(100) NOT NULL,
 ClientId INT NOT NULL,
 IsActive BIT NOT NULL,
 CreatedDate DATETIME NOT NULL,
 CreatedBy INT NOT NULL,
 ModifiedDate DATETIME NULL,
 ModifiedBy INT NULL,

PRIMARY KEY CLUSTERED 
(
	[OnshoreMgrId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE OnshoreManager WITH CHECK ADD CONSTRAINT FK_OnshoreManager_Client_ClientId FOREIGN KEY(ClientId) REFERENCES Client(ClientId)
GO
ALTER TABLE OnshoreManager CHECK CONSTRAINT FK_OnshoreManager_Client_ClientId
GO
ALTER TABLE OnshoreManager ADD CONSTRAINT DF_OnshoreManager_IsActive DEFAULT(1) FOR IsActive
GO
ALTER TABLE OnshoreManager ADD CONSTRAINT DF_OnshoreManager_CreatedDate DEFAULT(GETDATE()) FOR CreatedDate
GO

CREATE TABLE UsersOnshoreMgrMapping
(
 MappingId BIGINT NOT NULL IDENTITY(1,1),
 UserId INT NOT NULL,
 ClientSideEmpId VARCHAR(100) NULL,
 OnshoreMgrId BIGINT NOT NULL,
 UserValidFromDate DATE NULL,
 UserValidTillDate DATE NULL,
 NotifyOnshoreMgr BIT NOT NULL,
 IsActive BIT NOT NULL,
 CreatedDate DATETIME NOT NULL,
 CreatedBy INT NOT NULL,
 ModifiedDate DATETIME NULL,
 ModifiedBy INT NULL,

PRIMARY KEY CLUSTERED 
(
	[MappingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE UsersOnshoreMgrMapping WITH CHECK ADD CONSTRAINT FK_UsersOnshoreMgrMapping_User_UserId 
FOREIGN KEY(UserId) REFERENCES [User](UserId)
GO
ALTER TABLE UsersOnshoreMgrMapping CHECK CONSTRAINT FK_UsersOnshoreMgrMapping_User_UserId
GO
ALTER TABLE UsersOnshoreMgrMapping WITH CHECK ADD CONSTRAINT FK_UsersOnshoreMgrMapping_OnshoreManager_OnshoreMgrId
FOREIGN KEY(OnshoreMgrId) REFERENCES [OnshoreManager](OnshoreMgrId)
GO
ALTER TABLE UsersOnshoreMgrMapping CHECK CONSTRAINT FK_UsersOnshoreMgrMapping_OnshoreManager_OnshoreMgrId
GO
ALTER TABLE UsersOnshoreMgrMapping ADD CONSTRAINT DF_UsersOnshoreMgrMapping_NotifyOnshoreMgr DEFAULT(0) FOR NotifyOnshoreMgr
GO
ALTER TABLE UsersOnshoreMgrMapping ADD CONSTRAINT DF_UsersOnshoreMgrMapping_IsActive DEFAULT(1) FOR IsActive
GO
ALTER TABLE UsersOnshoreMgrMapping ADD CONSTRAINT DF_UsersOnshoreMgrMapping_CreatedDate DEFAULT(GETDATE()) FOR CreatedDate
GO

--INSERT INTO Client(ClientName, IsActive, CreatedDate, CreatedBy)
--VALUES('Pimco', 1, GETDATE(), 1)

--INSERT INTO Client(ClientName, IsActive, CreatedBy)
--VALUES('Pimco',1,1),('Survey2Connect',1,1)

--INSERT INTO OnshoreManager (ManagerName, EmailId, ClientId, IsActive, CreatedBy)
--VALUES('Anil Kumar Singh', 'Anil.Kumar@GeminiSolutions.in', 1, 1, 1)
--,('Arpit Chaudhary', 'Arpit.Chaudhary@GeminiSolutions.in', 2, 1, 1)

--INSERT INTO UsersOnshoreMgrMapping(UserId, ClientSideEmpId, OnshoreMgrId, NotifyOnshoreMgr, CreatedBy)
--VALUES(2432, 'KAN7689', 3, 1, 1),(2432, 'KAN8907', 4, 1, 1), (2432, 'UHFTY', 3, 0, 1),(2434, 'MIMHJKI', 3, 1, 1)  

