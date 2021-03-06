---------added column in leavebalance---------
ALTER TABLE [dbo].[LeaveBalance]
ADD [AllocationFrequency] INT NOT NULL DEFAULT(0);
---------update allocationfrequency of already updated leaves---------
UPDATE [dbo].[Leavebalance]
SET AllocationFrequency=1 WHERE LeaveTypeId IN (6,7) AND [Count]> 0
------------updated proc---------
GO
/****** Object:  StoredProcedure [dbo].[spUpdateEmployeeLeaveBalanceByHR]    Script Date: 11-12-2018 20:02:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spUpdateEmployeeLeaveBalanceByHR]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spUpdateEmployeeLeaveBalanceByHR]
GO
/****** Object:  StoredProcedure [dbo].[spGetLeaveBalanceForAllUser]    Script Date: 11-12-2018 20:02:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetLeaveBalanceForAllUser]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetLeaveBalanceForAllUser]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_GetUserConsecutiveLeaves]    Script Date: 11-12-2018 20:02:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetUserConsecutiveLeaves]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GetUserConsecutiveLeaves]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_GetUserConsecutiveLeaves]    Script Date: 11-12-2018 20:02:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetUserConsecutiveLeaves]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/***
   Created Date      :     07-12-2018
   Created By        :     Mimansa Agrawal
   Purpose           :     This function return user''s leave if not consecutively applied
   Usage			 :	   SELECT * FROM [dbo].[Fun_GetUserConsecutiveLeaves](2434,''2018-12-17'',''2018-12-17'')
   --------------------------------------------------------------------------
***/
CREATE FUNCTION [dbo].[Fun_GetUserConsecutiveLeaves]
(
	@UserId int,
	@FromDate date,
	@TillDate date
)
RETURNS @LeaveTable TABLE (
	[FromDate] DATE,
	[TillDate] DATE 	
	)
AS BEGIN
DECLARE @PrevWorkingDateId BIGINT=(SELECT TOP 1 [DateId] FROM datemaster WHERE [date]<@FromDate and IsWeekend=0 and IsHoliday=0 ORDER BY [date] DESC),
@NextWorkingDateId BIGINT=(SELECT TOP 1 [DateId] FROM datemaster where [date]>@TillDate and IsWeekend=0 and IsHoliday=0 )
DECLARE @Count INT=(SELECT Count(*) FROM LeaveRequestApplication Where UserId=@UserId AND IsActive=1 AND StatusId NOT IN (-1,0) 
AND (TillDateId=@PrevWorkingDateId OR FromDateId=@NextWorkingDateId))
IF (@Count!=0)
BEGIN
INSERT INTO @LeaveTable([FromDate],[TillDate])
SELECT D.[Date],DT.[Date] FROM LeaveRequestApplication L
JOIN DateMaster D ON D.[DateId]=L.[FromDateId] 
JOIN DateMaster DT ON DT.[DateId]=L.[TillDateId]
WHERE UserId=@UserId AND IsActive=1 AND StatusId NOT IN (-1,0) AND (TillDateId=@PrevWorkingDateId OR FromDateId=@NextWorkingDateId)
END
RETURN
END' 
END

GO
/****** Object:  StoredProcedure [dbo].[spGetLeaveBalanceForAllUser]    Script Date: 11-12-2018 20:02:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetLeaveBalanceForAllUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGetLeaveBalanceForAllUser] AS' 
END
GO
/***
   Created Date      :     2015-12-24
   Created By        :     Nishant Srivastava
   Purpose           :     This stored procedure return leave balance of all User
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   EXEC [spGetLeaveBalanceForAllUser]
***/
ALTER PROCEDURE [dbo].[spGetLeaveBalanceForAllUser] 
AS
BEGIN          

		IF 1 = 2 
		BEGIN
				SELECT
					CAST(NULL AS [varchar] (100)) AS [UserName]
					,CAST(NULL AS [Int])          AS [UserId]
					,CAST(NULL AS [Int])          AS [GenderId]
					,CAST(NULL AS [Float])        AS [CL]
					,CAST(NULL AS [Float])        AS [PL]
					,CAST(NULL AS [Float])        AS [LWP]
					,CAST(NULL AS [float])        AS [CompOff]
					,CAST(NULL AS [float])        AS [ML]
					,CAST(NULL AS [float])        AS [PL(M)]
					,CAST(NULL AS [float])        AS [CloyAvailable]
				WHERE
				1 = 2
		END 
        ELSE
        BEGIN
          ;WITH CET AS 
            (
               SELECT
					 LTRIM(RTRIM(REPLACE(REPLACE(REPLACE((UD.[FirstName] + ' ' + UD.[MiddleName] + ' ' + UD.[LastName]), ' ', '{}'), '}{',''), '{}', ' '))) [UserName]      
                    ,UD.[UserId]                                                    AS [UserId],UD.[GenderId] 
                    ,CASE WHEN L.[ShortName] = 'CL' THEN LB.[Count] END              AS [CL]	
                    ,CASE WHEN L.[ShortName] = 'PL' THEN LB.[Count] END              AS [PL]
                    ,CASE WHEN L.[ShortName] = '5CLOY' THEN LB.[Count] END           AS [CloyAvailable] 
                    ,CASE WHEN L.[ShortName] = 'LWP' THEN ISNULL(LB.[Count],0) END   AS [LWP]
                    ,CASE WHEN L.[ShortName] = 'COFF' THEN LB.[Count] END            AS [CompOff]
					,CASE WHEN L.[ShortName] = 'ML' THEN LB.[Count] END	             AS [ML]
					,CASE WHEN L.[ShortName] = 'PL(M)' THEN LB.[Count] END	         AS [PL(M)]
                    ,LB.[Count]                                                      AS [NoOfLeaves]
                    ,LB.[LeaveTypeId]                                                AS [LeaveTypeId]                                                                                                       
          FROM 
			[dbo].[LeaveBalance] LB WITH (NOLOCK)  
			INNER JOIN 
			[dbo].[LeaveTypeMaster] L WITH (NOLOCK)
			ON LB.[LeaveTypeId] = L.[TypeId]
			INNER JOIN [dbo].[UserDetail] UD  WITH (NOLOCK)  ON UD.[UserId]=LB.[UserId]
			INNER JOIN [dbo].[User] U  WITH (NOLOCK)  ON UD.[UserId]=U.[UserId]
		  WHERE LB.IsActive = 1 AND L.IsDeleted = 0 AND UD.[TerminateDate] IS NULL AND U.IsActive=1
              )
         SELECT 
               [UserName]                 AS [UserName]
               , [UserId]                 AS [UserId]
			   ,GenderId                  AS [GenderId]
               , MAX (CL)                 AS [CL]
               , MAX([PL])                AS [PL]
               , ISNULL (MAX([LWP]),0)    AS [LWP]
               , MAX([CompOff])     AS [CompOff]
			   , MAX([ML]) AS [ML]
			   , MAX([PL(M)]) AS [PL(M)]
               , MAX([CloyAvailable])     AS [CloyAvailable]
         FROM CET 
         GROUP by [UserName],[UserId],[GenderId]
      END
 END

GO
/****** Object:  StoredProcedure [dbo].[spUpdateEmployeeLeaveBalanceByHR]    Script Date: 11-12-2018 20:02:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spUpdateEmployeeLeaveBalanceByHR]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spUpdateEmployeeLeaveBalanceByHR] AS' 
END
GO

/***
   Created Date      :     2016-01-20
   Created By        :     Shubhra Upadhyay
   Purpose           :     This stored procedure Update employee Leave Balance
      
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   
   --------------------------------------------------------------------------

   Test Cases        :
   --------------------------------------------------------------------------
   EXEC [dbo].[spUpdateEmployeeLeaveBalanceByHR]   
   @Type=1,
   @UserId = 24,
	@ClCount = 100,
	@PlCount = 100,
	@CompOffCount = 100,
	@LwpCount = 100,
	@Cloy = 1,
	@MlCount=1,
	@AllocationCount=0,
	@UpdatedBy = 2
            
***/

ALTER PROCEDURE [dbo].[spUpdateEmployeeLeaveBalanceByHR]
(
    @Type int,
	@UserId bigint,
	@ClCount float,
	@PlCount float,
	@CompOffCount float,
	@LwpCount float,
	@Cloy bit,
	@MlCount float,
	@AllocationCount int,
	@UpdatedBy bigint
)  

AS
BEGIN
SET NOCOUNT ON
DECLARE @GenderId INT
SET @GenderId=(SELECT GenderId FROM [dbo].[UserDetail] WHERE UserId=@UserId)
DECLARE @ExiClCount float,@ExiPlCount float,@ExiCompOffCount float,@ExiLwpCount float,@ExiCloy bit,@ExiMlCount float,@ExiPLMCount float
SET @ExiClCount= (SELECT [Count] FROM [dbo].[LeaveBalance] WHERE UserId=@UserId AND LeaveTypeId=1)
SET @ExiPlCount= (SELECT [Count] FROM [dbo].[LeaveBalance] WHERE UserId=@UserId AND LeaveTypeId=2)
SET @ExiCompOffCount= (SELECT [Count] FROM [dbo].[LeaveBalance] WHERE UserId=@UserId AND LeaveTypeId=4)
SET @ExiLwpCount= (SELECT [Count] FROM [dbo].[LeaveBalance] WHERE UserId=@UserId AND LeaveTypeId=3)
SET @ExiCloy= (SELECT [Count] FROM [dbo].[LeaveBalance] WHERE UserId=@UserId AND LeaveTypeId=8)
SET @ExiMlCount= (SELECT [Count] FROM [dbo].[LeaveBalance] WHERE UserId=@UserId AND LeaveTypeId=6)
SET @ExiPLMCount= (SELECT [Count] FROM [dbo].[LeaveBalance] WHERE UserId=@UserId AND LeaveTypeId=7)
IF(@ExiClCount!=@ClCount AND @Type=1)
BEGIN
INSERT INTO [dbo].[LeaveBalanceHistory] (RecordId,[Count],CreatedBy) SELECT L.RecordId,@ExiClCount,@UpdatedBy FROM [LeaveBalance] L WHERE UserId=@UserId AND LeaveTypeId=1
END
IF(@ExiPlCount!=@PlCount AND @Type=1)
BEGIN
INSERT INTO [dbo].[LeaveBalanceHistory] (RecordId,[Count],CreatedBy) SELECT L.RecordId,@ExiPlCount,@UpdatedBy FROM [LeaveBalance] L WHERE UserId=@UserId AND LeaveTypeId=2
END
IF(@ExiCompOffCount!=@CompOffCount AND @Type=1)
BEGIN
INSERT INTO [dbo].[LeaveBalanceHistory] (RecordId,[Count],CreatedBy) SELECT L.RecordId,@ExiCompOffCount,@UpdatedBy FROM [LeaveBalance] L WHERE UserId=@UserId AND LeaveTypeId=4
END
IF(@ExiLwpCount!=@LwpCount AND @Type=1)
BEGIN
INSERT INTO [dbo].[LeaveBalanceHistory] (RecordId,[Count],CreatedBy) SELECT L.RecordId,@ExiLwpCount,@UpdatedBy FROM [LeaveBalance] L WHERE UserId=@UserId AND LeaveTypeId=3
END
IF(@ExiCloy!=@Cloy AND @Type=1)
BEGIN
INSERT INTO [dbo].[LeaveBalanceHistory] (RecordId,[Count],CreatedBy) SELECT L.RecordId,@ExiCloy,@UpdatedBy FROM [LeaveBalance] L WHERE UserId=@UserId AND LeaveTypeId=8
END
IF(@ExiMlCount!=@MlCount AND @GenderId=2 AND @Type=2)
BEGIN
INSERT INTO [dbo].[LeaveBalanceHistory] (RecordId,[Count],CreatedBy) SELECT L.RecordId,@ExiMlCount,@UpdatedBy FROM [LeaveBalance] L WHERE UserId=@UserId AND LeaveTypeId=6
END
IF(@ExiPLMCount!=@MlCount AND @GenderId=1 AND @Type=2)
BEGIN
INSERT INTO [dbo].[LeaveBalanceHistory] (RecordId,[Count],CreatedBy) SELECT L.RecordId,@ExiPLMCount,@UpdatedBy FROM [LeaveBalance] L WHERE UserId=@UserId AND LeaveTypeId=7
END
IF(@Type=1)
BEGIN
UPDATE LB      
	SET         
      LB.[Count] = CASE
                     WHEN LM.[ShortName] = 'CL'  THEN @ClCount
                     WHEN LM.[ShortName] = 'PL' THEN @PlCount
                     WHEN LM.[ShortName] = 'COFF'  THEN @CompOffCount
                     WHEN LM.[ShortName] = 'LWP'  THEN @LwpCount
                     WHEN LM.[ShortName] = '5CLOY' AND @Cloy = 1  THEN 1
                     ELSE LB.[Count]
                   END
     ,LB.[LastModifiedBy] = @UpdatedBy
     ,LB.[LastModifiedDate] = GETDATE()

	FROM [dbo].[LeaveBalance] LB
      INNER JOIN [dbo].[LeaveTypeMaster] LM
         ON LB.[LeaveTypeId] = LM.[TypeId]
	WHERE LB.[UserId] = @UserId
   SELECT 1 AS Result
END
IF(@Type=2)
BEGIN
	UPDATE LB      
	SET         
      LB.[Count] = CASE
                     WHEN LM.[ShortName] = 'ML' AND @GenderId= 2  AND @AllocationCount<2 THEN @MlCount
					 WHEN LM.[ShortName] = 'PL(M)' AND @GenderId=1 AND @AllocationCount<2  THEN @MlCount
					 ELSE LB.[Count]
                   END
     ,LB.[LastModifiedBy] = @UpdatedBy
	 ,LB.[AllocationFrequency]= CASE
	                            WHEN @AllocationCount<2 AND LM.[ShortName] = 'ML' AND @GenderId=2 
								THEN @AllocationCount + 1
								WHEN @AllocationCount<2 AND LM.[ShortName] = 'PL(M)' AND @GenderId=1 
								THEN @AllocationCount + 1
	                            ELSE
                                LB.[AllocationFrequency]
								END
     ,LB.[LastModifiedDate] = GETDATE()

	FROM [dbo].[LeaveBalance] LB
      INNER JOIN [dbo].[LeaveTypeMaster] LM
         ON LB.[LeaveTypeId] = LM.[TypeId]
	WHERE LB.[UserId] = @UserId
   SELECT 1 AS Result
END
END

GO
