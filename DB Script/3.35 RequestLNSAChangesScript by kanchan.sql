IF OBJECT_ID('RequestLnsaHistory') IS NOT NULL
	DROP TABLE RequestLnsaHistory
GO
IF OBJECT_ID('LNSAStatusMaster') IS NOT NULL
	DROP TABLE LNSAStatusMaster
GO

CREATE TABLE [dbo].[LNSAStatusMaster](
	[StatusId] [bigint] IDENTITY(1,1) NOT NULL CONSTRAINT PK_LNSAStatusMaster_StatusId PRIMARY KEY,
	[Status] [varchar](50) NOT NULL,
	[StatusCode] [varchar](20) NOT NULL,
	[IsActive] [bit] NOT NULL CONSTRAINT DF_LNSAStatusMaster_IsActive DEFAULT (1),
	[CreatedDate] [datetime] NOT NULL CONSTRAINT DF_LNSAStatusMaster_CreatedDate DEFAULT GETDATE(),
	[CreatedById] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedById] [int] NULL
) 

INSERT INTO [LNSAStatusMaster]([Status], [StatusCode], [CreatedById])
VALUES
('Applied','AD',1),
('Pending for approval','PA',1),
('Approved','AP',1),
('Pending for verification','PV',1),
('Verified','VD',1),
('Rejected','RJ',1),
('Cancelled','CA',1)

CREATE TABLE RequestLnsaHistory 
(
 RequestLnsaHistoryId BIGINT IDENTITY(1,1),
 RequestId BIGINT NOT NULL,
 StatusId BIGINT NOT NULL,
 Remarks VARCHAR(500) NULL,
 CreatedBy INT NOT NULL,
 CreatedDate DATETIME NOT NULL CONSTRAINT DF_RequestLnsaHistory_CreatedDate DEFAULT GETDATE()
)
ALTER TABLE [dbo].[RequestLnsaHistory]  WITH CHECK ADD  CONSTRAINT [PK_RequestLnsaHistory_RequestLnsaHistoryId] PRIMARY KEY(RequestLnsaHistoryId)
GO

ALTER TABLE [dbo].[RequestLnsaHistory]  WITH CHECK ADD  CONSTRAINT [FK_RequestLnsaHistory_RequestLnsa_RequestLnsaId] FOREIGN KEY(RequestId)
REFERENCES RequestLnsa(RequestId)
GO

ALTER TABLE [dbo].[RequestLnsaHistory] CHECK CONSTRAINT [FK_RequestLnsaHistory_RequestLnsa_RequestLnsaId]
GO

ALTER TABLE [dbo].[RequestLnsaHistory]  WITH CHECK ADD  CONSTRAINT [FK_RequestLnsaHistory_LNSAStatusMaster_StatusId] FOREIGN KEY(StatusId)
REFERENCES LNSAStatusMaster(StatusId)
GO

ALTER TABLE [dbo].[RequestLnsaHistory] CHECK CONSTRAINT [FK_RequestLnsaHistory_LNSAStatusMaster_StatusId]
GO

-----------------------------------------------------------------------------------------------------------
ALTER TABLE RequestLnsa add ApproverId INT NULL, StatusId INT NULL 

-------update approver id and status id---------------
UPDATE RequestLnsa SET [StatusId] = 2, ApproverId = CASE WHEN (SELECT [dbo].[fnGetReportingManagerByUserId](CreatedBy)) = 0 THEN (SELECT [dbo].[fnGetHRIdByUserId](CreatedBy))
                                 ELSE (SELECT [dbo].[fnGetReportingManagerByUserId](CreatedBy))
								 END 
         WHERE [Status] = 0 AND LastModifiedBy Is NULL AND LastModifiedDate IS NULL

UPDATE RequestLnsa SET [StatusId] = 6  WHERE [Status] = -1 

UPDATE RequestLnsa SET [StatusId] = 3 WHERE [Status] = 1 
       
----------insert into requestlnsahistory ----------------

INSERT INTO RequestLnsaHistory (RequestId, StatusId, Remarks, CreatedBy, CreatedDate)
SELECT RequestId, 1, 'Applied', CreatedBy, CreatedDate FROM RequestLnsa 

INSERT INTO RequestLnsaHistory (RequestId, StatusId, Remarks, CreatedBy, CreatedDate)
SELECT RequestId, StatusId, ApproverRemarks, LastModifiedBy, LastModifiedDate FROM RequestLnsa WHERE [StatusId] != 2

------------alter status id not null --------------------
ALTER TABLE RequestLnsa alter column StatusId BIGINT not null

ALTER TABLE RequestLnsa ADD  CONSTRAINT FK_RequestLnsa_StatusId FOREIGN KEY(StatusId) REFERENCES LNSAStatusMaster(StatusId) 
------------------------------------------------------------
