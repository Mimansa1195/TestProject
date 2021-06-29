-- =============================================
-- Author:		Sudhanshu Shekhar
-- Create date: 22-Mar-2018
-- Description:	To get current appraisal cycle
-- SELECT * FROM [dbo].[Fun_GetCurrentAppraisalCycle]()
-- =============================================
CREATE FUNCTION [dbo].[Fun_GetCurrentAppraisalCycle]()
RETURNS @AppraisalCycleDetails TABLE (
		AppraisalCycleId INT,
		CountryId INT,
		AppraisalCycleName VARCHAR(40),
		AppraisalMonth INT,
		AppraisalYear INT,
		AppraisalStartDate DATE,
		AppraisalEndDate DATE,
		GoalCycleId INT,
		FYStartDate DATE,
		FYEndDate DATE
)
AS
BEGIN
   DECLARE 
          @AppraisalEndDate DATE = '31 Mar ' +CAST(YEAR(DATEADD(Month,-((DATEPART(Month,GETDATE())+8) %12),GETDATE()))+1 AS VARCHAR(4))
		 ,@FYStartDate DATE = '01 Apr '+CAST(YEAR(DATEADD(Month,-((DATEPART(Month,GETDATE())+8) %12),GETDATE())) AS VARCHAR(4))
         ,@FYEndDate DATE = '31 Mar '+CAST(YEAR(DATEADD(Month,-((DATEPART(Month,GETDATE())+8) %12),GETDATE()))+1 AS VARCHAR(4))
	INSERT INTO @AppraisalCycleDetails(AppraisalCycleId, CountryId, AppraisalCycleName, AppraisalMonth, AppraisalYear, 
				AppraisalStartDate, AppraisalEndDate, GoalCycleId, FYStartDate, FYEndDate )
	SELECT AppraisalCycleId, CountryId, AppraisalCycleName, AppraisalMonth, AppraisalYear, 
		   '01 '+ CAST(LEFT(DATENAME(MONTH, DATEADD(MONTH, AppraisalMonth, 0) - 1),3) AS VARCHAR(3)) 
			+ ' ' + CAST((YEAR(DATEADD(Month,-((DATEPART(Month,GETDATE())+8) %12),GETDATE()))-1) AS VARCHAR(4)) AS AppraisalStartDate,
			
			'31 '+ CAST(LEFT(DATENAME(MONTH, DATEADD(MONTH, (AppraisalMonth-1), 0) - 1),3) AS VARCHAR(3)) 
			+ ' ' +CAST(YEAR(DATEADD(Month,-((DATEPART(Month,GETDATE())+8) %12),GETDATE())) AS VARCHAR(4)) AS AppraisalEndDate,
		   (AppraisalCycleId + 1) AS GoalCycleId, @FYStartDate, @FYEndDate
	FROM AppraisalCycle WITH (NOLOCK) 
	WHERE AppraisalYear = CASE 
							WHEN DATEPART(YY,GETDATE())=DATEPART(YY,@FYStartDate) THEN DATEPART(YY,@FYStartDate)
							ELSE DATEPART(YY,@FYEndDate) END --AND AppraisalMonth=DATEPART(MM,@FYEndDate)
	
	RETURN 
END