
ALTER TABLE RequestCompOff ADD IsAvailed BIT NULL
GO 
UPDATE  RequestCompOff SET IsAvailed=0 
GO
ALTER TABLE RequestCompOff ALTER COLUMN IsAvailed BIT NOT NULL
GO
ALTER TABLE RequestCompOff ADD CONSTRAINT DF_RequestCompOff_IsAvailed DEFAULT 0 FOR IsAvailed
GO

ALTER TABLE RequestCompOffDetail ADD IsActive BIT NULL
GO
UPDATE RequestCompOffDetail SET IsActive = 1 
GO
ALTER TABLE RequestCompOffDetail ALTER COLUMN IsActive BIT NOT NULL
GO
ALTER TABLE RequestCompOffDetail ADD CONSTRAINT DF_RequestCompOffDetail_IsActive DEFAULT 1 FOR IsActive



ALTER TABLE RequestCompOffDetail ADD CreatedDate DATETIME NULL 
GO
UPDATE RequestCompOffDetail SET CreatedDate = GETDATE()
GO 
ALTER TABLE RequestCompOffDetail ALTER COLUMN CreatedDate DATETIME NOT NULL
GO
ALTER TABLE RequestCompOffDetail ADD CONSTRAINT DF_RequestCompOffDetail_CreatedDate DEFAULT GETDATE() FOR CreatedDate
GO

ALTER TABLE RequestCompOffDetail ADD CreatedById int NULL
GO

ALTER TABLE RequestCompOffDetail ADD [ModifiedDate] DATETIME NULL
GO

ALTER TABLE RequestCompOffDetail ADD [ModifiedById] [int] NULL
GO