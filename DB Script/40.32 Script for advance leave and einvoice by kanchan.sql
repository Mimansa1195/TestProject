 EXEC sp_RENAME 'AdvanceLeaveDetail.AdjustedLeaveTypeId' , 'AdjustedLeaveReqAppId', 'COLUMN'
 GO
 ALTER TABLE AdvanceLeaveDetail ALTER COLUMN AdjustedLeaveReqAppId BIGINT NULL 
 GO
 ALTER TABLE AdvanceLeaveDetail WITH CHECK ADD CONSTRAINT FK_AdvanceLeaveDetail_LeaveRequestApplication_AdjustedLeaveReqAppId
 FOREIGN KEY (AdjustedLeaveReqAppId) REFERENCES LeaveRequestApplication(LeaveRequestApplicationId)
 GO
 ALTER TABLE AdvanceLeaveDetail CHECK CONSTRAINT FK_AdvanceLeaveDetail_LeaveRequestApplication_AdjustedLeaveReqAppId
 GO
 DROP trigger  [trgVerifyUpdateUserClientProjectMapping]
 GO
