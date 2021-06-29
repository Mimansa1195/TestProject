ALTER TABLE UserDetail Add IsEligibleForLeave BIT NULL
GO
UPDATE UserDetail SET IsEligibleForLeave = 1 
GO
ALTER TABLE UserDetail ALTER COLUMN  IsEligibleForLeave BIT NOT NULL 
GO
ALTER TABLE UserDetail ADD CONSTRAINT DF_UserDetail_IsEligibleForLeave DEFAULT(1) FOR IsEligibleForLeave


