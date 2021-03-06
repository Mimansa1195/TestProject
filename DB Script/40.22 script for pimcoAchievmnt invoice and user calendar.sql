GO
/****** Object:  StoredProcedure [dbo].[Proc_SubmitUserQuarterlyAchievement]    Script Date: 07-02-2019 17:51:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SubmitUserQuarterlyAchievement]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SubmitUserQuarterlyAchievement]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetUserWiseWeekDataInCalendar]    Script Date: 07-02-2019 17:51:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetUserWiseWeekDataInCalendar]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetUserWiseWeekDataInCalendar]
GO
/****** Object:  StoredProcedure [dbo].[Proc_CheckIfAllowedToFillPimcoAchievements]    Script Date: 07-02-2019 17:51:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_CheckIfAllowedToFillPimcoAchievements]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_CheckIfAllowedToFillPimcoAchievements]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__PimcoAchi__Pimco__3E956889]') AND parent_object_id = OBJECT_ID(N'[dbo].[PimcoAchievementDetail]'))
ALTER TABLE [dbo].[PimcoAchievementDetail] DROP CONSTRAINT [FK__PimcoAchi__Pimco__3E956889]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__PimcoAchi__UserI__39D0B36C]') AND parent_object_id = OBJECT_ID(N'[dbo].[PimcoAchievement]'))
ALTER TABLE [dbo].[PimcoAchievement] DROP CONSTRAINT [FK__PimcoAchi__UserI__39D0B36C]
GO
/****** Object:  Table [dbo].[PimcoAchievementDetail]    Script Date: 07-02-2019 17:51:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PimcoAchievementDetail]') AND type in (N'U'))
DROP TABLE [dbo].[PimcoAchievementDetail]
GO
/****** Object:  Table [dbo].[PimcoAchievement]    Script Date: 07-02-2019 17:51:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PimcoAchievement]') AND type in (N'U'))
DROP TABLE [dbo].[PimcoAchievement]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_GetQuartersForFY]    Script Date: 07-02-2019 17:51:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetQuartersForFY]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GetQuartersForFY]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_GetFinancialYearForInvoice]    Script Date: 07-02-2019 17:51:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetFinancialYearForInvoice]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GetFinancialYearForInvoice]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_GetFinancialYearForInvoice]    Script Date: 07-02-2019 17:51:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetFinancialYearForInvoice]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Mimansa Agrawal
-- Create date: 05-Feb-2019
-- Description:	To get financial year drop down for invoice
-- SELECT * FROM [dbo].[Fun_GetFinancialYearForInvoice]()
-- =============================================
CREATE FUNCTION [dbo].[Fun_GetFinancialYearForInvoice]()
RETURNS @FinancialYear TABLE (
		StartYear INT,
		EndYear INT,
		FYStartDate DATE,
		FYEndDate DATE
)
AS
BEGIN
	DECLARE	 @CurrentYear INT = (SELECT DATEPART(year, GETDATE())),
	@StartYear INT = 2018
		WHILE @StartYear <= @CurrentYear
		BEGIN
			DECLARE @FYStartDate DATE = ''01 Apr ''+CAST((@StartYear) AS VARCHAR(4)),
			@FYEndDate DATE = ''31 Mar '' +CAST((@StartYear + 1) AS VARCHAR(4))
			INSERT  INTO @FinancialYear ([StartYear],[EndYear],[FYStartDate],[FYEndDate])
			VALUES (@StartYear,@StartYear+1,@FYStartDate , @FYEndDate)
			SET @StartYear = @StartYear + 1;
		END
	DELETE FROM @FinancialYear WHERE FYStartDate > GETDATE()
	RETURN 
END' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[Fun_GetQuartersForFY]    Script Date: 07-02-2019 17:51:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetQuartersForFY]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Mimansa Agrawal
-- Create date: 04-Feb-2019
-- Description:	To get quarters for financial year
-- SELECT * FROM [dbo].[Fun_GetQuartersForFY](2018)
-- =============================================
CREATE FUNCTION [dbo].[Fun_GetQuartersForFY](@Year INT)
RETURNS @Quarters TABLE (
		StartYear INT,
		EndYear INT,
		QStartDate DATE,
		QEndDate DATE,
		QNumber INT
)
AS
	BEGIN
	DECLARE @QStartNo INT, @TotalQuarters INT,@FYStartDate DATE,@FYEndDate DATE 
	SET @QStartNo = 1 ;
	SET @TotalQuarters = 4;
		WHILE @QStartNo <= @TotalQuarters
		BEGIN
		IF (@QStartNo=1)
		BEGIN
			SET @FYStartDate = ''01 Apr ''+CAST((@Year) AS VARCHAR(4))
			SET @FYEndDate = ''30 Jun '' +CAST((@Year) AS VARCHAR(4))
	    END
		ELSE IF (@QStartNo=2)
		BEGIN
			SET @FYStartDate = ''01 Jul ''+CAST((@Year) AS VARCHAR(4))
			SET @FYEndDate = ''30 Sep  '' +CAST((@Year) AS VARCHAR(4))
	    END
		ELSE IF (@QStartNo=3)
		BEGIN
			SET @FYStartDate = ''01 Oct ''+CAST((@Year) AS VARCHAR(4))
			SET @FYEndDate = ''31 Dec'' +CAST((@Year) AS VARCHAR(4))
	    END
		ELSE IF (@QStartNo=4)
		BEGIN
			SET @FYStartDate = ''01 Jan ''+CAST((@Year+1) AS VARCHAR(4))
			SET @FYEndDate = ''31 Mar'' +CAST((@Year+1) AS VARCHAR(4))
	    END
			INSERT  INTO @Quarters ([StartYear],[EndYear],[QStartDate],[QEndDate],[QNumber])
			VALUES (@Year,@Year+1,@FYStartDate , @FYEndDate,@QStartNo)
			SET @QStartNo = @QStartNo + 1;
		END
	RETURN 
END' 
END

GO
/****** Object:  Table [dbo].[PimcoAchievement]    Script Date: 07-02-2019 17:51:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PimcoAchievement]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PimcoAchievement](
	[PimcoAchievementId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[FYStartYear] [int] NOT NULL,
	[QuarterNo] [int] NOT NULL,
	[QuarterStartDate] [date] NOT NULL,
	[QuarterEndDate] [date] NOT NULL,
	[IsActive] [bit] NOT NULL DEFAULT ((1)),
	[EmpComments] [varchar](500) NULL,
	[RMComments] [varchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL DEFAULT (getdate()),
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[PimcoAchievementId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PimcoAchievementDetail]    Script Date: 07-02-2019 17:51:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PimcoAchievementDetail]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PimcoAchievementDetail](
	[PimcoAchievementDetailId] [int] IDENTITY(1,1) NOT NULL,
	[PimcoAchievementId] [int] NOT NULL,
	[Achievement] [varchar](500) NOT NULL,
	[Purpose] [varchar](500) NOT NULL,
	[IsActive] [bit] NOT NULL DEFAULT ((1)),
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL DEFAULT (getdate()),
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[PimcoAchievementDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__PimcoAchi__UserI__39D0B36C]') AND parent_object_id = OBJECT_ID(N'[dbo].[PimcoAchievement]'))
ALTER TABLE [dbo].[PimcoAchievement]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([UserId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__PimcoAchi__Pimco__3E956889]') AND parent_object_id = OBJECT_ID(N'[dbo].[PimcoAchievementDetail]'))
ALTER TABLE [dbo].[PimcoAchievementDetail]  WITH CHECK ADD FOREIGN KEY([PimcoAchievementId])
REFERENCES [dbo].[PimcoAchievement] ([PimcoAchievementId])
GO
/****** Object:  StoredProcedure [dbo].[Proc_CheckIfAllowedToFillPimcoAchievements]    Script Date: 07-02-2019 17:51:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_CheckIfAllowedToFillPimcoAchievements]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_CheckIfAllowedToFillPimcoAchievements] AS' 
END
GO

/***
   Created Date      :     2018-02-04
   Created By        :     Mimansa Agrawal
   Purpose           :     This procedure checks if user can add pimco achievements
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
DECLARE @Result int
EXEC Proc_CheckIfAllowedToFillPimcoAchievements
@UserId=2166,
@Year = 2018,
@QNumber = 4,
@Success = @Result output
SELECT @Result AS [RESULT]
**/
ALTER PROCEDURE [dbo].[Proc_CheckIfAllowedToFillPimcoAchievements]
(
@UserId INT,
@Year INT,
@QNumber INT,
@Success TINYINT = 0 OUTPUT 
)
AS
BEGIN TRY
DECLARE @PimcoAchievementId INT = (SELECT COUNT(*) FROM [dbo].[PimcoAchievement] WHERE UserId = @UserId AND FYStartYear=@Year AND QuarterNo=@QNumber)
print @PimcoAchievementId;
DECLARE @CurrentMonth INT,@CurrentYear INT,@CurrentQuarter INT
SET @CurrentMonth = MONTH(getdate())
SET @CurrentYear = YEAR(getdate())
IF (@CurrentMonth < 4)
BEGIN
			 SET @CurrentQuarter=4
			 SET @CurrentYear = @CurrentYear - 1
		END
		ELSE IF (@CurrentMonth >3 AND @CurrentMonth < 7)
BEGIN
			 SET @CurrentQuarter=1
		END
	ELSE IF (@CurrentMonth > 6 AND @CurrentMonth < 10)
BEGIN
			 SET @CurrentQuarter=2
		END
	ELSE IF (@CurrentMonth > 9)
BEGIN
			 SET @CurrentQuarter=3
		END
IF (@PimcoAchievementId = 0)
BEGIN
IF (@CurrentQuarter = @QNumber AND @CurrentYear=@Year)
		BEGIN
			 SET @Success=3 --can apply
		END
ELSE
BEGIN
SET @Success= 2------------cannot apply
END
		END
ELSE
BEGIN
SET @Success= 1------------cannot apply
END
END TRY
BEGIN CATCH
	--On Error
     SET @Success = 0; -- Error occurred
	 DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
	 --Log Error
	 EXEC [spInsertErrorLog]
			 @ModuleName = 'Pimco Achievements'
			,@Source = 'Proc_CheckIfAllowedToFillPimcoAchievements'
			,@ErrorMessage = @ErrorMessage
			,@ErrorType = 'SP'
			,@ReportedByUserId = @UserId
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetUserWiseWeekDataInCalendar]    Script Date: 07-02-2019 17:51:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetUserWiseWeekDataInCalendar]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetUserWiseWeekDataInCalendar] AS' 
END
GO
/***
    Created Date      :     2019-02-01
   Created By        :     Mimansa Agrawal
   Purpose           :     This stored procedure fetches employee's weekdays detail monthly
   Change History    :
   --------------------------------------------------------------------------
	   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
      EXEC [Proc_GetUserWiseWeekDataInCalendar] @LoginUserId=1108,@FromDate='2019-01-01',@TillDate='2019-01-31'
***/
ALTER PROC [dbo].[Proc_GetUserWiseWeekDataInCalendar]
(
 @LoginUserId INT 
,@FromDate DATE 
,@TillDate DATE 
)
AS
BEGIN
	SET FMTONLY OFF;
	SET NOCOUNT ON;

	DECLARE @FromDateId BIGINT, @TillDateId BIGINT
	
	SET @FromDateId = (SELECT DateId FROM DateMaster WHERE [Date]=@FromDate)
	SET @TillDateId = (SELECT DateId FROM DateMaster WHERE [Date]=@TillDate)

	IF OBJECT_ID('tempdb..#UserDateMapping') IS NOT NULL
	DROP TABLE #UserDateMapping
	
	CREATE TABLE #UserDateMapping
	(
	 [DateId] [bigint] NOT NULL
	,[Date] [date] NOT NULL
	,[IsWeekend] BIT NOT NULL 
	,[UserId] [int] NOT NULL
	,[WeekNo] [INT] NOT NULL
	,[IsNormalWeek] BIT NOT NULL DEFAULT(1)
	,[ISMarked] BIT NOT NULL DEFAULT(0)
	)
	INSERT INTO #UserDateMapping([UserId],[DateId],[Date],[IsWeekend],[WeekNo])
	SELECT  U.[UserId], D.[DateId], D.[Date], D.[IsWeekend], (SELECT WeekNo FROM [dbo].[FetchDateAndWeekNo](D.[Date]))
	FROM [dbo].[DateMaster] D WITH (NOLOCK)
	CROSS JOIN [dbo].[UserDetail] U WITH (NOLOCK) 
	WHERE U.[UserId]=@LoginUserId AND D.[Date] BETWEEN @FromDate AND @TillDate 

	 ----update [IsNormalWeek] of #UserDateMapping -------------------
	  UPDATE U SET U.[IsNormalWeek] = 0 FROM #UserDateMapping U 
	  INNER JOIN (
	             SELECT Q.[WeekNo], T.[UserId] 
				 FROM EmployeeWiseWeekOff T WITH (NOLOCK)
				 JOIN #UserDateMapping Q ON T.[UserId] = Q.[UserId] AND T.[WeekOffDateId] = Q.[DateId] 
				 WHERE T.[IsActive] = 1
				 GROUP BY T.[UserId], Q.[WeekNo]
				 ) N ON U.[UserId] = N.[UserId] AND U.[WeekNo] = N.[WeekNo]
 -------UPDATE IsMarked flag for normal week-----------------------------
 UPDATE U SET U.[IsMarked]=1 FROM #UserDateMapping U  WHERE U.[IsNormalWeek]=1 AND U.[IsWeekend]=1
 --------UPDATE IsMarked flag for abnormal week------------
 UPDATE U SET U.[IsMarked]=1 
 FROM #UserDateMapping U 
 JOIN [dbo].[EmployeeWiseWeekOff] E ON E.[WeekOffDateId]=U.DateId
 WHERE U.[IsNormalWeek]=0 
 ----------------select userwise data---------------------
    SELECT DateId,[Date],IsWeekend,UserId,WeekNo,IsNormalWeek,IsMarked FROM #UserDateMapping WHERE IsMarked=1
END


GO
/****** Object:  StoredProcedure [dbo].[Proc_SubmitUserQuarterlyAchievement]    Script Date: 07-02-2019 17:51:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SubmitUserQuarterlyAchievement]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_SubmitUserQuarterlyAchievement] AS' 
END
GO
/***
   Created Date      :     2019-02-05
   Created By        :     Mimansa Agrawal
   Purpose           :    To submit User quarterly pimco Achievement 
   -----------------------------------------------------------------------
   Usage             :
   -----------------------------------------------------------------------
    DECLARE @Result tinyint
         EXEC [dbo].[Proc_SubmitUserQuarterlyAchievement]
            @UserId = 2432
		   ,@Year = 2018
		   ,@QNumber = 1
		   ,@Comments = 'abcd'
           ,@AchievementXmlString ='<Root> <Row Achievement="test" Purpose="test" />
		                                   <Row Achievement="test" Purpose="test"></Row>
			                        </Root>'
		   ,@Success = @Result out
           SELECT @Result AS Result
***/
ALTER PROC [dbo].[Proc_SubmitUserQuarterlyAchievement]
(
 @UserId INT,
 @Year INT,
 @QNumber INT,
 @Comments VARCHAR(500),
 @AchievementXmlString xml,
 @Success tinyint=0 output
)
AS
BEGIN TRY
    SET NOCOUNT ON;
    BEGIN TRANSACTION
	DECLARE @QStartDate DATE,@QEndDate DATE,@DetailId INT
	SET @QStartDate = (SELECT QStartDate FROM [dbo].[Fun_GetQuartersForFY](@Year) WHERE QNumber=@QNumber)
	SET @QEndDate = (SELECT QEndDate FROM [dbo].[Fun_GetQuartersForFY](@Year) WHERE QNumber=@QNumber)
           IF OBJECT_ID('tempdb..##TempAchievement') IS NOT NULL
           DROP TABLE #TempAchievement

		   CREATE TABLE #TempAchievement([Achievement] VARCHAR(500),[Purpose] VARCHAR(500))
           INSERT INTO #TempAchievement
		   SELECT T.Item.value('@Achievement','VARCHAR(500)'),
			      T.Item.value('@Purpose', 'varchar(500)')
		   FROM @AchievementXmlString.nodes('/Root/Row')AS T(Item)
    INSERT INTO [dbo].[PimcoAchievement](UserId, FYStartYear, QuarterNo,QuarterStartDate,QuarterEndDate,EmpComments, CreatedBy)
    SELECT @UserId, @Year, @QNumber,@QStartDate,@QEndDate,@Comments,@UserId 
 
    SET @DetailId = SCOPE_IDENTITY()
 
    INSERT INTO [dbo].[PimcoAchievementDetail](PimcoAchievementId, Achievement, Purpose,CreatedBy)
    SELECT @DetailId, [Achievement], [Purpose], @UserId FROM #TempAchievement
    SET @Success = 1;
    COMMIT;
END TRY
BEGIN CATCH
	SET @Success = 0;
    IF(@@TRANCOUNT>0)
    ROLLBACK TRANSACTION;
    DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
--Log Error
    EXEC [spInsertErrorLog]
    @ModuleName = 'PimcoAchievement'
    ,@Source = 'Proc_SubmitUserQuarterlyAchievement'
    ,@ErrorMessage = @ErrorMessage
    ,@ErrorType = 'SP'
    ,@ReportedByUserId = @UserId
END CATCH 
GO
