--INSERT INTO AssetType(Type, IsForTemporaryBasis, CreatedBy)
--VALUES('Mouse', 0, '1'), ('Laptop',0,'1'), ('Mobile',0, '1')

--ALTER TABLE AssetType ADD CONSTRAINT DF_AssetType_IsTemporaryBasis DEFAULT(0) FOR IsForTemporaryBasis
--GO
--ALTER TABLE AssetType DROP CONSTRAINT DF_AssetType_IsActive 
--GO
--ALTER TABLE AssetType ADD CONSTRAINT DF_AssetType_IsActive DEFAULT(1) FOR ISActive
--GO

IF OBJECT_ID('UsersAssetDetail') IS NOT NULL
DROP TABLE UsersAssetDetail

IF OBJECT_ID('AssetsMaster') IS NOT NULL
DROP TABLE AssetsMaster

IF OBJECT_ID('AssetsBrand') IS NOT NULL
DROP TABLE AssetsBrand


----------------------------------------------------------------------------
CREATE TABLE AssetsBrand
(
 BrandId INT IDENTITY(1,1) NOT NULL,
 BrandName VARCHAR(50) NOT NULL,
 IsActive BIT NOT NULL,
 CreatedDate DATETIME NOT NULL,
 CreatedBy INT NOT NULL,
 ModifiedDate DATETIME NULL,
 ModifiedBy INT NULL
,
 CONSTRAINT [PK_AssetsBrand_BrandId] PRIMARY KEY CLUSTERED 
(
	[BrandId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE AssetsBrand ADD CONSTRAINT DF_AssetsBrand_IsActive DEFAULT(1) FOR IsActive
GO
ALTER TABLE AssetsBrand ADD CONSTRAINT DF_AssetsBrand_CreatedDate DEFAULT(GETDATE()) FOR CreatedDate

-----------------------------------------------------------------------------

CREATE TABLE AssetsMaster
(
 AssetId BIGINT IDENTITY(1,1) NOT NULL,
 AssetTypeId BIGINT NOT NULL,
 BrandId INT NOT NULL,
 Model VARCHAR(100) NOT NULL,
 SerialNo VARCHAR(100) NOT NULL,
 [Description] VARCHAR(100) NOT NULL,
 IsActive BIT NOT NULL,
 CreatedDate DATETIME NOT NULL,
 CreatedBy INT NOT NULL,
 ModifiedDate DATETIME NULL,
 ModifiedBy INT NULL
,
 CONSTRAINT [PK_AssetsMaster_AssetId] PRIMARY KEY CLUSTERED 
(
	[AssetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE AssetsMaster WITH CHECK ADD CONSTRAINT FK_AssetsMaster_AssetType_AssetTypeId 
FOREIGN KEY (AssetTypeId) REFERENCES AssetType(TypeId)

GO

ALTER TABLE [AssetsMaster] CHECK CONSTRAINT [FK_AssetsMaster_AssetType_AssetTypeId]
GO

ALTER TABLE AssetsMaster WITH CHECK ADD CONSTRAINT FK_AssetsMaster_AssetsBrand_BrandId 
FOREIGN KEY (BrandId) REFERENCES AssetsBrand(BrandId)

ALTER TABLE [AssetsMaster] CHECK CONSTRAINT [FK_AssetsMaster_AssetsBrand_BrandId]
GO

ALTER TABLE AssetsMaster ADD CONSTRAINT DF_AssetsMaster_IsActive DEFAULT(1) FOR IsActive
GO

ALTER TABLE AssetsMaster ADD CONSTRAINT DF_AssetsMaster_CreatedDate DEFAULT(GETDATE()) FOR CreatedDate


--------------------------------------------------------------------------------------------------

CREATE TABLE UsersAssetDetail
(
 AssetsRequestId BIGINT IDENTITY(1,1) NOT NULL,
 UserId INT NOT NULL,
 AssetId BIGINT NOT NULL,
 AllocateFrom BIGINT NOT NULL,
 AllocateTill BIGINT NULL,
 Remarks VARCHAR(500) NULL,
 IsActive BIT NOT NULL,
 CreatedDate DATETIME NOT NULL,
 CreatedBy INT NOT NULL,
 ModifiedDate DATETIME NULL,
 ModifiedBy INT NULL,
 CONSTRAINT [PK_UsersAssetDetail_AssetsRequestId] PRIMARY KEY CLUSTERED 
(
	[AssetsRequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE UsersAssetDetail WITH CHECK ADD CONSTRAINT FK_UsersAssetDetail_AssetsMaster_AssetId
FOREIGN KEY (AssetId) REFERENCES AssetsMaster(AssetId)

GO

ALTER TABLE [UsersAssetDetail] CHECK CONSTRAINT [FK_UsersAssetDetail_AssetsMaster_AssetId]
GO

ALTER TABLE [UsersAssetDetail] WITH CHECK ADD CONSTRAINT FK_UsersAssetDetail_DateMaster_AllocateFrom
FOREIGN KEY (AllocateFrom) REFERENCES DateMaster([DateId])

ALTER TABLE [UsersAssetDetail] CHECK CONSTRAINT [FK_UsersAssetDetail_DateMaster_AllocateFrom]
GO

ALTER TABLE [UsersAssetDetail] WITH CHECK ADD CONSTRAINT FK_UsersAssetDetail_User_UserId
FOREIGN KEY (UserId) REFERENCES [User](UserId)

ALTER TABLE [UsersAssetDetail] CHECK CONSTRAINT FK_UsersAssetDetail_User_UserId
GO


ALTER TABLE [UsersAssetDetail] WITH CHECK ADD CONSTRAINT FK_UsersAssetDetail_DateMaster_AllocateTill
FOREIGN KEY (AllocateTill) REFERENCES DateMaster([DateId])

ALTER TABLE [UsersAssetDetail] CHECK CONSTRAINT [FK_UsersAssetDetail_DateMaster_AllocateTill]
GO

ALTER TABLE [UsersAssetDetail] ADD CONSTRAINT DF_UsersAssetDetail_IsActive DEFAULT(1) FOR IsActive
GO

ALTER TABLE [UsersAssetDetail] ADD CONSTRAINT DF_UsersAssetDetail_CreatedDate DEFAULT(GETDATE()) FOR CreatedDate


SELECT * FROM [UsersAssetDetail]
SELECT * FROM AssetsMaster
SELECT * FROM AssetsBrand

INSERT INTO AssetsBrand(BrandName, CreatedBy)
VALUES('Apple', 1),('HP', 1),('DELL',1),('NOKIA',1)