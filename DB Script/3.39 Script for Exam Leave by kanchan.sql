INSERT INTO LeaveTypeMaster
(
 ShortName
,[Description]
,[Priority]
,IsAvailableForMarriedOnly
,IsAvailableForMale
,IsAvailableForFemale
,IsAutoIncremented
,AutoIncrementPeriod
,IsAutoExpire
,AutoExpirePeriod
,CreatedBy
)
VALUES ('EL','Exam Leave For Technical Trainee',1,0,1,1,0,0,0,0,1)

-------------------------------------------------------
INSERT INTO LeaveBalance(
 UserId
,LeaveTypeId
,[Count]
,CreatedBy
)
SELECT UserId,(select TypeId FROM LeaveTypeMaster where ShortName = 'EL'),0,1
FROM vwActiveUsers WHERE [Role] = 'Trainee' AND DesignationGroup = 'Technical' AND IsIntern = 1

-------------------------------------------------------

--select * from LeaveBalance  where UserId = 2432
--select * from LeaveRequestApplication where LeaveRequestApplicationId = 8953
--select * from DateWiseLeaveType where LeaveRequestApplicationId = 8953
