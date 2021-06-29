CREATE TABLE StaffAttendanceForDate 
(
 [Date] DATE NOT NULL
,[StaffUserId] INT
,[InTime] [datetime] NULL
,[OutTime] [datetime] NULL
,[IsNightShift] [BIT] NOT NULL 
,[Duration]  DATETIME 
)

ALTER TABLE [DateWiseAttendance] ADD IsNightShift BIT NOT NULL DEFAULT (0)
ALTER TABLE DateWiseAttendanceMergeHistory ADD OldIsNightShift BIT  NULL , NewIsNightShift BIT  NULL