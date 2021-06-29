INSERT INTO DashboardWidget
(
 DashboardWidgetName
,CreatedById
)
VALUES('Health Insurance', 1)
-----------------------------------------



CREATE TABLE [UsersHealthInsurance]
(
 [UsersHealthInsuranceId] BIGINT NOT NULL IDENTITY(1,1),
 [UserId] INT NOT NULL,
 [InsurancePdfPath] VARCHAR(500) NOT NULL,
 [IsActive] BIT,
 CreatedDate DATETIME NOT NULL,
 CreatedBy INT NOT NULL,
 CONSTRAINT [PK_UsersHealthInsurance_UsersHealthInsuranceId] PRIMARY KEY CLUSTERED 
(
	[UsersHealthInsuranceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [UsersHealthInsurance] WITH CHECK ADD CONSTRAINT FK_UsersHealthInsurance_User_UserId
FOREIGN KEY(UserId) REFERENCES [User](UserId)
GO
ALTER TABLE [UsersHealthInsurance] CHECK CONSTRAINT FK_UsersHealthInsurance_User_UserId
GO 
ALTER TABLE [UsersHealthInsurance] ADD CONSTRAINT DF_UsersHealthInsurance_IsActive DEFAULT(1) FOR IsActive
GO 
ALTER TABLE [UsersHealthInsurance] ADD CONSTRAINT DF_UsersHealthInsurance_CreatedDate DEFAULT(GETDATE()) FOR CreatedDate
GO
-----------------------------------------------------------------------------------------------------------------------------
