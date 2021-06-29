ALTER TABLE UserDetail ADD IsUserVerified BIT NULL 
GO
UPDATE UserDetail SET IsUserVerified = 1 
GO
ALTER TABLE UserDetail ALTER COLUMN IsUserVerified BIT NOT NULL 
GO
ALTER TABLE UserDetail ADD CONSTRAINT DF_UserDetail_IsUserVerified DEFAULT(0) FOR IsUserVerified
GO
-------------------------------------------

ALTER TABLE UsersAssetDetail ADD IsLost BIT NULL 
GO
UPDATE UsersAssetDetail SET IsLost = 0
GO
ALTER TABLE UsersAssetDetail ALTER COLUMN IsLost BIT NOT NULL 
GO
ALTER TABLE UsersAssetDetail ADD CONSTRAINT DF_UsersAssetDetail_IsLost DEFAULT(0) FOR IsLost
GO

--------------------------------

ALTER TABLE UsersAssetDetail ADD IsCollected BIT NULL 
GO
UPDATE UsersAssetDetail SET IsCollected =  CASE WHEN  AllocatedTill IS NULL THEN CAST(0 AS BIT) ELSE CAST(1 AS BIT) END
GO
ALTER TABLE UsersAssetDetail ALTER COLUMN IsCollected BIT NOT NULL 
GO
ALTER TABLE UsersAssetDetail ADD CONSTRAINT DF_UsersAssetDetail_IsCollected DEFAULT(0) FOR IsCollected
GO

------------------------------

ALTER TABLE UsersAssetDetail ADD DeAllocationRemarks VARCHAR(500) NULL 
GO




