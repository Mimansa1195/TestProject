ALTER TABLE RequestCompOffDetail ALTER COLUMN LeaveRequestApplicationId BIGINT NULL
GO
ALTER TABLE RequestCompOffDetail ADD LegitimateLeaveRequestId BIGINT NULL
GO
ALTER TABLE [dbo].[RequestCompOffDetail]  WITH CHECK ADD  CONSTRAINT [FK_RequestCompOffDetail_LegitimateLeaveRequest_LegitimateLeaveRequestId] FOREIGN KEY(LegitimateLeaveRequestId)
REFERENCES [dbo].LegitimateLeaveRequest (LegitimateLeaveRequestId)
GO
