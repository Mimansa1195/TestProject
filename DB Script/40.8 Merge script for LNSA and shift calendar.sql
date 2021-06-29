
-------------------------------------------------------- insert into datewise lnsa --------------------------------------------------------
--IF OBJECT_ID('TempRequestLnsaDetail') IS NOT NULL
--	DROP TABLE TempRequestLnsaDetail
--GO

CREATE TABLE TempRequestLnsaDetail
(
RequestId BIGINT ,
DateId BIGINT,
IsApprovedBySystem BIT NOT NULL,
StatusId BIGINT NOT NULL,
Remarks VARCHAR(500),
CreatedBy INT NOT NULL,
CreatedDate DATETIME NOT NULL,
LastModifedBy INT NULL,
LastModifedDate DATETIME NULL
)
GO
INSERT INTO TempRequestLnsaDetail 
SELECT R.RequestId, D.DateId, 
CASE WHEN R.StatusId = 3 THEN 1 ELSE 0 END AS IsApprovedBySystem,
R.StatusId,
R.ApproverRemarks AS Remarks, R.CreatedBy, R.CreatedDate, R.LastModifiedBy, R.LastModifiedDate
FROM RequestLNSA R 
CROSS JOIN DateMaster D WHERE D.DateId BETWEEN R.FromDateId AND R.TillDateId AND R.StatusId <= 6
GO


--select * INTO DateWiseLnsa_Bkp_13_Dec_2018 from DateWiseLnsa
INSERT INTO DateWiseLnsa
SELECT T.RequestId, T.DateId, T.IsApprovedBySystem, T.StatusId, T.Remarks, T.CreatedBy, T.CreatedDate, T.LastModifedBy, T.LastModifedDate
FROM TempRequestLnsaDetail T 
LEFT JOIN  DateWiseLnsa D ON T.RequestId = D.RequestId AND T.DateId = D.DateId AND  T.StatusId = D.StatusId
WHERE D.RecordId IS NULL 
GO
---------------------------------- insert into Lnsa History -------------------------------------
IF OBJECT_ID('TempLnsaRequestHistory') IS NOT NULL
	DROP TABLE TempLnsaRequestHistory
GO

CREATE TABLE TempLnsaRequestHistory
(
 RequestId BIGINT NOT NULL,
 StatusId BIGINT NOT NULL,
 Remarks VARCHAR(500),
 CreatedBy INT,
 CreatedDate DATETIME
)
GO
-------------user applied request ---------------
INSERT INTO TempLnsaRequestHistory(RequestId, StatusId, Remarks, CreatedBy, CreatedDate)
SELECT RequestId, 1, 'Applied', CreatedBy, CreatedDate 
FROM RequestLnsa 

GO
------------user applied and approved by rm1 and pending for approval with rm2 -----
INSERT INTO TempLnsaRequestHistory(RequestId, StatusId, Remarks, CreatedBy, CreatedDate)
SELECT RequestId, 3, 'ok', LastModifiedBy, LastModifiedDate 
FROM RequestLnsa 
WHERE StatusId = 2 AND ApproverId IS NOT NULL
AND LastModifiedBy IS NOT NULL AND LastModifiedDate Is NOT NULL
GO
------------user applied and approved by rm1 and approved by  rm2 -----
INSERT INTO TempLnsaRequestHistory(RequestId, StatusId, Remarks, CreatedBy, CreatedDate)
SELECT RequestId, 3, 'ok', LastModifiedBy, LastModifiedDate 
FROM RequestLnsa 
WHERE StatusId = 3 AND ApproverId IS NULL
AND LastModifiedBy IS NOT NULL AND LastModifiedDate Is NOT NULL
GO
------------user applied and rejected by manager(RJ) -----
INSERT INTO TempLnsaRequestHistory(RequestId, StatusId, Remarks, CreatedBy, CreatedDate)
SELECT RequestId, 6 AS StatusId, ApproverRemarks, LastModifiedBy, LastModifiedDate FROM RequestLnsa 
WHERE StatusId = 6 AND ApproverId IS NULL
AND LastModifiedBy IS NOT NULL AND LastModifiedDate Is NOT NULL
GO

------------insert into RequestLnsaHistory-----
INSERT INTO RequestLnsaHistory(RequestId, StatusId, Remarks, CreatedBy, CreatedDate) 
SELECT T.RequestId, T.StatusId, T.Remarks, T.CreatedBy, T.CreatedDate 
FROM TempLnsaRequestHistory T LEFT JOIN RequestLnsaHistory R 
ON T.RequestId = R.RequestId AND T.CreatedBy = R.CreatedBy AND T.StatusId = R.StatusId
WHERE R.RequestLnsaHistoryId IS NULL
GO



---------------insert not inserted data into RequestLNsa from tempusershift only approved----------------------------10

INSERT INTO  RequestLnsa (FromDateId, TillDateId, TotalNoOfDays, Reason, ApproverRemarks, [Status], CreatedDate, CreatedBy, LastModifiedDate, LastModifiedBy, ApproverId, StatusId )
SELECT  MIN(TD.DateId) AS FromDate, MAX(TD.DateId) AS TillDate, COUNT(*) AS NoOfDays,'night shift' AS Reason ,'OK' AS ApproverRemarks,
 1 AS [Status],T.CreatedDate,T.CreatedBy,T.LastModifiedDate, T.LastModifiedBy,null AS ApproverId,3 AS StatusId
from TempUserShift T JOIN TempUserShiftDetail TD ON T.TempUserShiftId = TD.TempUserShiftId
LEFT JOIN (SELECT DW.RecordId,R.StatusId, DW.DateId, R.CreatedBy FROM RequestLnsa R JOIN DateWiseLnsa DW ON R.RequestId = DW.RequestId) M 
ON TD.DateId = M.DateId AND TD.CreatedBy = M.CreatedBy 
WHERE M.RecordId IS NULL AND TD.TempUserShiftId IN 
(
SELECT DISTINCT D.TempUserShiftId AS TempUserShiftId
	FROM TempUserShiftDetail D LEFT JOIN
    (
		SELECT DW.RecordId, R.RequestId, R.StatusId, DW.DateId, R.CreatedBy 
		FROM RequestLnsa R JOIN DateWiseLnsa DW ON R.RequestId = DW.RequestId
	) M 
ON D.DateId = M.DateId AND D.CreatedBy  = M.CreatedBy 
WHERE D.StatusId = 4 AND M.RequestId IS NULL
  )
GROUP BY TD.TempUserShiftId,T.CreatedDate,T.CreatedBy,T.LastModifiedDate, T.LastModifiedBy,T.StatusId

GO
---------------insert not inserted data into RequestLNsa from tempusershift only pending----------------------------17
INSERT INTO  RequestLnsa (FromDateId, TillDateId, TotalNoOfDays, Reason,  [Status], CreatedDate, CreatedBy,  ApproverId, StatusId )
SELECT  MIN(TD.DateId) AS FromDate, MAX(TD.DateId) AS TillDate, COUNT(*) AS NoOfDays,'night shift' AS Reason,
1 AS [Status],T.CreatedDate,T.CreatedBy, T.ApproverId AS ApproverId, 2 AS StatusId
from TempUserShift T JOIN TempUserShiftDetail TD ON T.TempUserShiftId = TD.TempUserShiftId
LEFT JOIN (SELECT DW.RecordId,R.StatusId, DW.DateId, R.CreatedBy FROM RequestLnsa R JOIN DateWiseLnsa DW ON R.RequestId = DW.RequestId) M 
ON TD.DateId = M.DateId AND TD.CreatedBy = M.CreatedBy 
WHERE M.RecordId IS NULL AND TD.TempUserShiftId IN (
SELECT DISTINCT D.TempUserShiftId AS TempUserShiftId
	FROM TempUserShiftDetail D LEFT JOIN
    (
		SELECT DW.RecordId, R.RequestId, R.StatusId, DW.DateId, R.CreatedBy 
		FROM RequestLnsa R JOIN DateWiseLnsa DW ON R.RequestId = DW.RequestId
	) M 
ON D.DateId = M.DateId AND D.CreatedBy  = M.CreatedBy 
WHERE D.StatusId = 2 AND M.RequestId IS NULL
  )
GROUP BY TD.TempUserShiftId,T.CreatedDate,T.CreatedBy,T.LastModifiedDate, T.LastModifiedBy,T.StatusId, T.ApproverId

GO



------------------------------------------------------ insert into datewise lnsa --------------------------------------------------------
IF OBJECT_ID('TempRequestLnsaDetailForDateWise') IS NOT NULL
	DROP TABLE TempRequestLnsaDetailForDateWise
GO

CREATE TABLE TempRequestLnsaDetailForDateWise
(
RequestId BIGINT ,
DateId BIGINT,
IsApprovedBySystem BIT NOT NULL,
StatusId BIGINT NOT NULL,
Remarks VARCHAR(500),
CreatedBy INT NOT NULL,
CreatedDate DATETIME NOT NULL,
LastModifedBy INT NULL,
LastModifedDate DATETIME NULL
)
GO
INSERT INTO TempRequestLnsaDetailForDateWise 
SELECT R.RequestId, D.DateId, 
CASE WHEN R.StatusId = 3 THEN 1 ELSE 0 END AS IsApprovedBySystem,
R.StatusId,
R.ApproverRemarks AS Remarks, R.CreatedBy, R.CreatedDate, R.LastModifiedBy, R.LastModifiedDate
FROM RequestLNSA R 
CROSS JOIN DateMaster D WHERE D.DateId BETWEEN R.FromDateId AND R.TillDateId AND R.StatusId <= 6
GO

--91
INSERT INTO DateWiseLnsa
SELECT T.RequestId, T.DateId, T.IsApprovedBySystem, T.StatusId, T.Remarks, T.CreatedBy, T.CreatedDate, T.LastModifedBy, T.LastModifedDate
FROM TempRequestLnsaDetailForDateWise T 
LEFT JOIN  DateWiseLnsa D ON T.RequestId = D.RequestId AND T.DateId = D.DateId AND  T.StatusId = D.StatusId
WHERE D.RecordId IS NULL 
GO
---------------------------------- insert into Lnsa History -------------------------------------
IF OBJECT_ID('TempLnsaRequestHistoryForReqLNSAHistory') IS NOT NULL
	DROP TABLE TempLnsaRequestHistoryForReqLNSAHistory
GO

CREATE TABLE TempLnsaRequestHistoryForReqLNSAHistory
(
 RequestId BIGINT NOT NULL,
 StatusId BIGINT NOT NULL,
 Remarks VARCHAR(500),
 CreatedBy INT,
 CreatedDate DATETIME
)
GO
-------------user applied request ---------------
INSERT INTO TempLnsaRequestHistoryForReqLNSAHistory(RequestId, StatusId, Remarks, CreatedBy, CreatedDate)
SELECT RequestId, 1, 'Applied', CreatedBy, CreatedDate FROM RequestLnsa 

GO
------------user applied and approved by rm1 and pending for approval with rm2 -----
INSERT INTO TempLnsaRequestHistoryForReqLNSAHistory(RequestId, StatusId, Remarks, CreatedBy, CreatedDate)
SELECT RequestId, 3, 'ok', LastModifiedBy, LastModifiedDate FROM RequestLnsa 
WHERE StatusId = 2 AND ApproverId IS NOT NULL
AND LastModifiedBy IS NOT NULL AND LastModifiedDate Is NOT NULL
GO
------------user applied and approved by rm1 and approved by  rm2 -----
INSERT INTO TempLnsaRequestHistoryForReqLNSAHistory(RequestId, StatusId, Remarks, CreatedBy, CreatedDate)
SELECT RequestId, 3, 'ok', LastModifiedBy, LastModifiedDate FROM RequestLnsa 
WHERE StatusId = 3 AND ApproverId IS NULL
AND LastModifiedBy IS NOT NULL AND LastModifiedDate Is NOT NULL
GO
------------user applied and rejected by manager(RJ) -----
INSERT INTO TempLnsaRequestHistoryForReqLNSAHistory(RequestId, StatusId, Remarks, CreatedBy, CreatedDate)
SELECT RequestId, 6 AS StatusId, ApproverRemarks, LastModifiedBy, LastModifiedDate FROM RequestLnsa 
WHERE StatusId = 6 AND ApproverId IS NULL
AND LastModifiedBy IS NOT NULL AND LastModifiedDate Is NOT NULL
GO
------------insert into RequestLnsaHistory-----37
INSERT INTO RequestLnsaHistory(RequestId, StatusId, Remarks, CreatedBy, CreatedDate) 
SELECT T.RequestId, T.StatusId, T.Remarks, T.CreatedBy, T.CreatedDate 
FROM TempLnsaRequestHistoryForReqLNSAHistory T LEFT JOIN RequestLnsaHistory R 
ON T.RequestId = R.RequestId AND T.CreatedBy = R.CreatedBy AND T.StatusId = R.StatusId
WHERE R.RequestLnsaHistoryId IS NULL
GO




----LNSAStatusMaster
--select * from TempUserShift
--select * from TempUserShiftDetail

--select * from RequestLnsa
--select * from [DateWiseLNSA]

--ALTER TABLE RequestLnsa DROP COLUMN TempUserShiftId
--ALTER TABLE RequestLnsa DROP CONSTRAINT RequestLnsa_TempUserShift_TempUserShiftId

--select T.*, DM.[Date] from DateWiseLnsa T JOIN DateMaster DM ON T.DateId = DM.DateId where  CreatedBy = 2227 and DM.[Date] = '2018-12-02'

--vwActiveUsers where EmployeeFirstName = 'Abhishek' -----2227



--select * from RequestLNSA WHERE CreatedBy = 2227 AND FromDateId = 11178
--select * from DateWiseLnsa WHERE RequestId = 2119

--SELECT DW.RecordId, R.RequestId, R.StatusId, DW.DateId, R.CreatedBy 
--		FROM RequestLnsa R JOIN DateWiseLnsa DW ON R.RequestId = DW.RequestId WHERE DW.CreatedBy = 2227 AND DW.DateId = 11178


--		TempUserShiftDetail WHERE CreatedBy = 2227 AND DateId = 11178