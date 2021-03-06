GO
/****** Object:  StoredProcedure [dbo].[spGetEmployeeAttendance]    Script Date: 24-01-2019 17:17:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetEmployeeAttendance]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetEmployeeAttendance]
GO
/****** Object:  StoredProcedure [dbo].[spGetAttendanceForUserOnDashboard]    Script Date: 24-01-2019 17:17:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetAttendanceForUserOnDashboard]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGetAttendanceForUserOnDashboard]
GO
/****** Object:  StoredProcedure [dbo].[Proc_RequestInvoice]    Script Date: 24-01-2019 17:17:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_RequestInvoice]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_RequestInvoice]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetEmployeeWeekData]    Script Date: 24-01-2019 17:17:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetEmployeeWeekData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetEmployeeWeekData]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetCalendarForWeekOff]    Script Date: 24-01-2019 17:17:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetCalendarForWeekOff]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetCalendarForWeekOff]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GenerateInvoice]    Script Date: 24-01-2019 17:17:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GenerateInvoice]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GenerateInvoice]
GO
/****** Object:  StoredProcedure [dbo].[Proc_CheckIfEligibleToRequestInvoice]    Script Date: 24-01-2019 17:17:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_CheckIfEligibleToRequestInvoice]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_CheckIfEligibleToRequestInvoice]
GO
/****** Object:  StoredProcedure [dbo].[Proc_AddWeekOffUsers]    Script Date: 24-01-2019 17:17:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddWeekOffUsers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AddWeekOffUsers]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__InvoiceRe__Invoi__4794C2DE]') AND parent_object_id = OBJECT_ID(N'[dbo].[InvoiceRequestDetail]'))
ALTER TABLE [dbo].[InvoiceRequestDetail] DROP CONSTRAINT [FK__InvoiceRe__Invoi__4794C2DE]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__InvoiceRe__Clien__4888E717]') AND parent_object_id = OBJECT_ID(N'[dbo].[InvoiceRequestDetail]'))
ALTER TABLE [dbo].[InvoiceRequestDetail] DROP CONSTRAINT [FK__InvoiceRe__Clien__4888E717]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__InvoiceRe__UserI__2A6E744B]') AND parent_object_id = OBJECT_ID(N'[dbo].[InvoiceRequest]'))
ALTER TABLE [dbo].[InvoiceRequest] DROP CONSTRAINT [FK__InvoiceRe__UserI__2A6E744B]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Invoice__Invoice__54EEBDFC]') AND parent_object_id = OBJECT_ID(N'[dbo].[Invoice]'))
ALTER TABLE [dbo].[Invoice] DROP CONSTRAINT [FK__Invoice__Invoice__54EEBDFC]
GO
/****** Object:  Table [dbo].[InvoiceRequestDetail]    Script Date: 24-01-2019 17:17:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InvoiceRequestDetail]') AND type in (N'U'))
DROP TABLE [dbo].[InvoiceRequestDetail]
GO
/****** Object:  Table [dbo].[InvoiceRequest]    Script Date: 24-01-2019 17:17:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InvoiceRequest]') AND type in (N'U'))
DROP TABLE [dbo].[InvoiceRequest]
GO
/****** Object:  Table [dbo].[Invoice]    Script Date: 24-01-2019 17:17:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Invoice]') AND type in (N'U'))
DROP TABLE [dbo].[Invoice]
GO
/****** Object:  Table [dbo].[Invoice]    Script Date: 24-01-2019 17:17:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Invoice]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Invoice](
	[InvoiceId] [bigint] IDENTITY(1,1) NOT NULL,
	[InvoiceRequestDetailId] [bigint] NOT NULL,
	[InvoiceNumber] [varchar](20) NOT NULL,
	[IsActive] [bit] NOT NULL DEFAULT ((1)),
	[IsCancelled] [bit] NOT NULL DEFAULT ((0)),
	[Reason] [varchar](100) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL DEFAULT (getdate()),
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[InvoiceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[InvoiceRequest]    Script Date: 24-01-2019 17:17:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InvoiceRequest]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[InvoiceRequest](
	[InvoiceRequestId] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[IsApproved] [bit] NOT NULL DEFAULT ((0)),
	[IsRejected] [bit] NOT NULL DEFAULT ((0)),
	[Comments] [varchar](500) NULL,
	[CreatedDate] [datetime] NOT NULL DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[InvoiceRequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[InvoiceRequestDetail]    Script Date: 24-01-2019 17:17:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InvoiceRequestDetail]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[InvoiceRequestDetail](
	[InvoiceRequestDetailId] [bigint] IDENTITY(1,1) NOT NULL,
	[InvoiceRequestId] [bigint] NOT NULL,
	[ClientId] [int] NOT NULL,
	[RequestedCount] [int] NOT NULL,
	[AvailableCount] [int] NOT NULL,
	[IsActive] [bit] NOT NULL DEFAULT ((1)),
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL DEFAULT (getdate()),
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[InvoiceRequestDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Invoice__Invoice__54EEBDFC]') AND parent_object_id = OBJECT_ID(N'[dbo].[Invoice]'))
ALTER TABLE [dbo].[Invoice]  WITH CHECK ADD FOREIGN KEY([InvoiceRequestDetailId])
REFERENCES [dbo].[InvoiceRequestDetail] ([InvoiceRequestDetailId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__InvoiceRe__UserI__2A6E744B]') AND parent_object_id = OBJECT_ID(N'[dbo].[InvoiceRequest]'))
ALTER TABLE [dbo].[InvoiceRequest]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([UserId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__InvoiceRe__Clien__4888E717]') AND parent_object_id = OBJECT_ID(N'[dbo].[InvoiceRequestDetail]'))
ALTER TABLE [dbo].[InvoiceRequestDetail]  WITH CHECK ADD FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([ClientId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__InvoiceRe__Invoi__4794C2DE]') AND parent_object_id = OBJECT_ID(N'[dbo].[InvoiceRequestDetail]'))
ALTER TABLE [dbo].[InvoiceRequestDetail]  WITH CHECK ADD FOREIGN KEY([InvoiceRequestId])
REFERENCES [dbo].[InvoiceRequest] ([InvoiceRequestId])
GO
/****** Object:  StoredProcedure [dbo].[Proc_AddWeekOffUsers]    Script Date: 24-01-2019 17:17:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddWeekOffUsers]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_AddWeekOffUsers] AS' 
END
GO
/***
   Created Date      :     2019-01-21
   Created By        :     Mimansa Agrawal
   Purpose           :     This stored procedure adds user week off data
   
   Change History    :
   -------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   
   --------------------------------------------------------------------------

   Test Cases        :
   --------------------------------------------------------------------------
   
   --- Test Case 1
      DECLARE @Result int
         EXEC [dbo].[Proc_AddWeekOffUsers]
          @UserIds = '2431'
         ,@DateIds = '11236,11237,11238,11239'
         ,@LoginUserId = 1108
		 ,@Success = @Result OUTPUT
		 SELECT @Result AS [Result]
***/
ALTER PROCEDURE [dbo].[Proc_AddWeekOffUsers]
(
	@UserIds varchar(4000) NULL
  ,@DateIds varchar(4000) NULL
  ,@LoginUserId INT 
  ,@Success TINYINT = 0 OUTPUT
)
AS
BEGIN TRY
IF ((SELECT COUNT(SplitData) FROM [dbo].[Fun_SplitStringInt] (@DateIds,',')) > 3)
BEGIN 
SET @Success=3 ----------cannot insert more than 3 days at a time
END
ELSE IF EXISTS(SELECT 1 FROM [dbo].[EmployeeWiseWeekOff] WHERE [UserId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@UserIds,',')) AND
WeekOffDateId IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@DateIds,','))) -- check if already exists
		BEGIN
			 SET @Success=2 --already exists
		END
		ELSE
		BEGIN
BEGIN TRANSACTION
INSERT INTO [dbo].[EmployeeWiseWeekOff]([UserId],[WeekOffDateId],[CreatedBy])
SELECT U.[UserId],D.[DateId],@LoginUserId
FROM [dbo].[DateMaster] D WITH (NOLOCK)
CROSS JOIN [dbo].[UserDetail] U WITH (NOLOCK)
WHERE U.[UserId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@UserIds,',')) AND
D.[DateId] IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@DateIds,','))
COMMIT
SET @Success= 1------------added successfully
END
END TRY
BEGIN CATCH
	--On Error
	IF @@TRANCOUNT > 0
	 ROLLBACK TRANSACTION;
     SET @Success = 0; -- Error occurred
	 DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
	 --Log Error
	 EXEC [spInsertErrorLog]
			 @ModuleName = 'LNSA'
			,@Source = 'Proc_AddWeekOffUsers'
			,@ErrorMessage = @ErrorMessage
			,@ErrorType = 'SP'
			,@ReportedByUserId = @LoginUserId
END CATCH
	
  



GO
/****** Object:  StoredProcedure [dbo].[Proc_CheckIfEligibleToRequestInvoice]    Script Date: 24-01-2019 17:17:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_CheckIfEligibleToRequestInvoice]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_CheckIfEligibleToRequestInvoice] AS' 
END
GO

/***
   Created Date      :     2018-12-28
   Created By        :     Mimansa Agrawal
   Purpose           :     This procedure checks if user can request for new invoices
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
DECLARE @Result int
EXEC Proc_CheckIfEligibleToRequestInvoice
@UserId=2166,
@Success = @Result output
SELECT @Result AS [RESULT]
**/
ALTER PROCEDURE [dbo].[Proc_CheckIfEligibleToRequestInvoice]
(
@UserId INT,
@Success TINYINT = 0 OUTPUT 
)
AS
BEGIN TRY
DECLARE @InvoiceRequestId INT = (SELECT TOP 1 InvoiceRequestId FROM [dbo].[InvoiceRequest] WHERE UserId = @UserId ORDER BY InvoiceRequestId DESC)
DECLARE @CurrentCount INT=(SELECT  SUM(AvailableCount) FROM [dbo].[InvoiceRequestDetail] WHERE InvoiceRequestId=@InvoiceRequestId)
DECLARE @IsApproved INT=(SELECT TOP 1 IsApproved FROM [dbo].[InvoiceRequest] WHERE UserId = @UserId ORDER BY InvoiceRequestId DESC)
DECLARE @IsRejected INT=(SELECT TOP 1 IsRejected FROM [dbo].[InvoiceRequest] WHERE UserId = @UserId ORDER BY InvoiceRequestId DESC)
IF (@CurrentCount > 0 AND @IsApproved = 1)
		BEGIN
			 SET @Success=3 --approved and count exists (not eligible)
		END
ELSE IF (@CurrentCount > 0 AND @IsApproved = 0 AND @IsRejected=0)
BEGIN
SET @Success = 2 --------------count exists but not approved (not eligible)
END
ELSE
BEGIN
SET @Success= 1------------eligible to request
END
END TRY
BEGIN CATCH
	--On Error
     SET @Success = 0; -- Error occurred
	 DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
	 --Log Error
	 EXEC [spInsertErrorLog]
			 @ModuleName = 'Accounts'
			,@Source = 'Proc_CheckIfEligibleToRequestInvoice'
			,@ErrorMessage = @ErrorMessage
			,@ErrorType = 'SP'
			,@ReportedByUserId = @UserId
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[Proc_GenerateInvoice]    Script Date: 24-01-2019 17:17:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GenerateInvoice]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GenerateInvoice] AS' 
END
GO
/***
   Created Date      :     2018-12-17
   Created By        :     Mimansa Agrawal
   Purpose           :     This procedure generates invoice for clients
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
EXEC Proc_GenerateInvoice
@ClientId=7,
@UserId=2203
**/
ALTER PROCEDURE [dbo].[Proc_GenerateInvoice]
(
@ClientId INT,
@UserId INT
)
AS
BEGIN TRY
DECLARE @InvoiceNumber BIGINT = (SELECT TOP 1 [InvoiceNumber] FROM [dbo].[Invoice] ORDER BY [InvoiceId] DESC)
DECLARE @InvoiceRequestDetailId BIGINT = (SELECT TOP 1 [InvoiceRequestDetailId] FROM [dbo].[InvoiceRequestDetail] WHERE CreatedBy=@UserId AND ClientId=@ClientId AND IsActive=1 ORDER BY [InvoiceRequestDetailId] DESC)
DECLARE @AvailableCount INT = (SELECT TOP 1 [AvailableCount] FROM [dbo].[InvoiceRequestDetail] WHERE CreatedBy=@UserId AND ClientId=@ClientId AND IsActive=1 ORDER BY [InvoiceRequestDetailId] DESC)
DECLARE @NewInvoiceNumber BIGINT 
IF(@InvoiceNumber > 0)	
BEGIN 
SET @NewInvoiceNumber = @InvoiceNumber + 1
END	
ELSE
BEGIN
SET @NewInvoiceNumber = 1000000001
END
IF (@AvailableCount > 0)
BEGIN
BEGIN TRANSACTION
INSERT INTO [dbo].[Invoice] (InvoiceRequestDetailId, InvoiceNumber, CreatedBy)
SELECT @InvoiceRequestDetailId,@NewInvoiceNumber,@UserId
UPDATE IR
SET IR.[AvailableCount] = @AvailableCount - 1
FROM
(
   SELECT TOP 1 [AvailableCount]
   FROM [InvoiceRequestDetail] WHERE CreatedBy=@UserId AND ClientId=@ClientId AND IsActive=1 ORDER BY [InvoiceRequestDetailId] DESC
) IR
COMMIT
SELECT TOP 1 * FROM [dbo].[Invoice] ORDER BY [InvoiceId] DESC
END
ELSE
BEGIN
 SELECT TOP 1 * FROM [dbo].[Invoice]  WHERE 1 = 0 ORDER BY [InvoiceId] DESC
END
END TRY
BEGIN CATCH
	--On Error
	IF @@TRANCOUNT > 0
	 ROLLBACK TRANSACTION;
	 DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
	 --Log Error
	 EXEC [spInsertErrorLog]
			 @ModuleName = 'Accounts'
			,@Source = 'Proc_GenerateInvoice'
			,@ErrorMessage = @ErrorMessage
			,@ErrorType = 'SP'
			,@ReportedByUserId = @UserId
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetCalendarForWeekOff]    Script Date: 24-01-2019 17:17:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetCalendarForWeekOff]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetCalendarForWeekOff] AS' 
END
GO
/***
    Created Date      :     2019-01-09
   Created By        :     Mimansa Agrawal
   Purpose           :     This stored procedure retrives calendar based on month
   Change History    :
   --------------------------------------------------------------------------
	   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
      EXEC Proc_GetCalendarForWeekOff @UserId=2421,@Month= 12,@Year= 2019
	 
***/
ALTER PROC [dbo].[Proc_GetCalendarForWeekOff]
(
  @UserId INT
 ,@Month INT
 ,@Year INT
 
)
AS
BEGIN
SET FMTONLY OFF;
	IF OBJECT_ID('tempdb..#TempWeek') IS NOT NULL
	DROP TABLE #TempWeek
	IF OBJECT_ID('tempdb..#TempShiftCalender') IS NOT NULL
	DROP TABLE #TempShiftCalender
	CREATE TABLE #TempWeek
	(
	 [StartDate] [date] NOT NULL
	,[EndDate] [date] NOT NULL
	,[WeekNo] [int] NOT NULL
	,DateInfo DATE NULL
	)
	CREATE TABLE #TempShiftCalender
   (  
	  [DateId] BIGINT NOT NULL
	 ,[Week] INT NOT NULL
	 ,[Month] VARCHAR(20) NOT NULL
	 ,[Year] INT NOT NULL
	 ,[DateInt] INT NOT NULL
	 ,[Day] VARCHAR(20) NOT NULL
	 ,FullDate VARCHAR(50) NOT NULL
	 ,StartDate VARCHAR(50) NOT NULL
	 ,EndDate VARCHAR(50) NOT NULL
	 ,IsCurrentMonthYear BIT NOT NULL
   )
	DECLARE @StartDate DATE , @EndDate DATE, @NewStartDate DATE , @NewEndDate DATE, @FixedStartDate DATE , @FixedEndDate DATE--, @DateId BIGINT, @Day VARCHAR(30)
	SET @StartDate = (SELECT DATEADD(month,@Month-1,DATEADD(year,@Year-1900,0))) /*First*/
	SET @EndDate = (SELECT DATEADD(day,-1,DATEADD(month,@Month,DATEADD(year,@Year-1900,0))))/*Last*/
	WHILE(@StartDate<=@EndDate)
	BEGIN
		INSERT INTO #TempWeek([StartDate],[EndDate],[WeekNo])
		EXEC [spFetchWeekMap] @UserId,@StartDate
		UPDATE #TempWeek SET DateInfo=@StartDate WHERE DateInfo IS NULL
		SET @StartDate = (SELECT DATEADD(d,1,@StartDate))
	END
	SET @NewStartDate = (SELECT TOP 1 StartDate FROM #TempWeek)
    SET @NewEndDate = (SELECT TOP 1 EndDate FROM #TempWeek ORDER BY EndDate DESC)
	SET @FixedStartDate = (SELECT TOP 1 StartDate FROM #TempWeek)
    SET @FixedEndDate = (SELECT TOP 1 EndDate FROM #TempWeek ORDER BY EndDate DESC)
	WHILE(@NewStartDate<=@NewEndDate)
	BEGIN
   INSERT INTO #TempShiftCalender([DateId],[Week],[Month],[Year],[DateInt],[Day],FullDate,StartDate,EndDate,IsCurrentMonthYear)
   SELECT  DISTINCT
           D.[DateId]                                        AS [DateId],
		       T.[WeekNo]                                            AS [Week],
           CAST(DATENAME(mm,@NewStartDate) AS VARCHAR(20))		AS [Month] , 
		   CAST(DATEPART(yyyy,@NewStartDate) AS INT)			AS [Year],
		   CAST(DATEPART(d,@NewStartDate) AS INT)				AS [DateInt], 
		   D.[Day]                                        AS [Day],
		   CONVERT(VARCHAR(15),@NewStartDate,106)              AS FullDate,
		   CONVERT(VARCHAR(15),@FixedStartDate,106)              AS StartDate,
		   CONVERT(VARCHAR(15),@FixedEndDate,106)              AS EndDate,
		   CASE 
		   WHEN DATEPART(m,@NewStartDate)=@Month THEN 1      
		   ELSE 0    END                                       AS IsCurrentMonthYear
		   FROM #TempWeek T
		   JOIN DateMaster D ON D.[Date]=@NewStartDate
		   WHERE @NewStartDate BETWEEN T.[StartDate] AND T.[EndDate]
		SET @NewStartDate = (SELECT DATEADD(d,1,@NewStartDate))
END
		  
		  SELECT [DateId],[Week],[Month],[Year],[DateInt],[Day],FullDate,StartDate,EndDate,IsCurrentMonthYear
	      FROM #TempShiftCalender
END





GO
/****** Object:  StoredProcedure [dbo].[Proc_GetEmployeeWeekData]    Script Date: 24-01-2019 17:17:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetEmployeeWeekData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetEmployeeWeekData] AS' 
END
GO
/***
    Created Date      :     2019-01-15
   Created By        :     Mimansa Agrawal
   Purpose           :     This stored procedure fetches employee's week off detail
   Change History    :
   --------------------------------------------------------------------------
	   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
      EXEC Proc_GetEmployeeWeekData @LoginUserId=1108,@FromDate='2018-12-31',@TillDate='2019-02-03'
***/
ALTER PROC [dbo].[Proc_GetEmployeeWeekData]
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
	)
	
	INSERT INTO #UserDateMapping([UserId],[DateId],[Date],[IsWeekend],[WeekNo])
	SELECT  U.[UserId], D.[DateId], D.[Date], D.[IsWeekend], (SELECT WeekNo FROM [dbo].[FetchDateAndWeekNo](D.[Date]))
	FROM [dbo].[DateMaster] D WITH (NOLOCK)
	CROSS JOIN [dbo].[UserDetail] U WITH (NOLOCK)
	WHERE U.ReportTo = @LoginUserId AND D.[Date] BETWEEN @FromDate AND @TillDate 

	 ----update [IsNormalWeek] of #UserDateMapping -------------------
	  UPDATE U SET U.[IsNormalWeek] = 0 FROM #UserDateMapping U 
	  INNER JOIN (
	             SELECT Q.[WeekNo], T.[UserId] 
				 FROM EmployeeWiseWeekOff T WITH (NOLOCK)
				 JOIN #UserDateMapping Q ON T.[UserId] = Q.[UserId] AND T.[WeekOffDateId] = Q.[DateId] 
				 GROUP BY T.[UserId], Q.[WeekNo]
				 ) N ON U.[UserId] = N.[UserId] AND U.[WeekNo] = N.[WeekNo]
    -------delete data where normal week----------------
				 ;WITH ExcludedUsers AS
				(
				 select * from #UserDateMapping
				 WHERE IsNormalWeek = 1
				 )
				DELETE FROM
				ExcludedUsers
     --delete entries of employees for which data is available in #TempCalenderRoaster-----
	DELETE U 
	FROM #UserDateMapping U WITH (NOLOCK) JOIN EmployeeWiseWeekOff T 
	ON U.[UserId] = T.[UserId] AND U.[DateId] = T.[WeekOffDateId] 
	-----select week days of employees----------
    SELECT DateId,[Date],IsWeekend,UserId,WeekNo,IsNormalWeek FROM #UserDateMapping 
	--WHERE UserId IN (SELECT UserId FROM EmployeeWiseWeekOff WHERE WeekOffDateId BETWEEN @FromDateId AND @TillDateId)
END


GO
/****** Object:  StoredProcedure [dbo].[Proc_RequestInvoice]    Script Date: 24-01-2019 17:17:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_RequestInvoice]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_RequestInvoice] AS' 
END
GO
/***
   Created Date      :     2018-12-27
   Created By        :     Mimansa Agrawal
   Purpose           :     This procedure requests for invoice by users
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
DECLARE @Result int
  EXEC [dbo].[Proc_RequestInvoice]
         @RequestXmlString = '<Root>
                <Row ClientId = "1" NoOfInvoices = "3"></Row>
                <Row ClientId = "2" NoOfInvoices = "4"></Row>
               </Root>'
         ,@UserId = 1108
,@Success = @Result output
SELECT @Result AS [RESULT]
**/
ALTER PROCEDURE [dbo].[Proc_RequestInvoice]
(
 @RequestXmlString XML
,@UserId INT
,@Success TINYINT = 0 OUTPUT 
)
AS
BEGIN
SET NOCOUNT ON;
--BEGIN TRY
DECLARE @RequestDetailId BIGINT
IF OBJECT_ID('tempdb..#Requests') IS NOT NULL
DROP TABLE #Requests
CREATE TABLE #Requests (RequestId INT IDENTITY(1,1), ClientId INT, NoOfInvoices INT)
--BEGIN TRANSACTION
INSERT INTO #Requests(ClientId, NoOfInvoices)
       SELECT T.Item.value('@ClientId', 'varchar(25)'),
           T.Item.value('@NoOfInvoices', 'varchar(25)')
       FROM @RequestXmlString.nodes('/Root/Row') AS T(Item)
INSERT INTO [dbo].[InvoiceRequest]([UserId],[CreatedBy])
SELECT @UserId,@UserId 
SET @RequestDetailId = SCOPE_IDENTITY()
INSERT INTO [dbo].[InvoiceRequestDetail](InvoiceRequestId,ClientId,RequestedCount,AvailableCount,CreatedBy)
SELECT @RequestDetailId,T.[ClientId],T.[NoOfInvoices],t.[NoOfInvoices],@UserId
FROM #Requests T
--COMMIT
SET @Success= 1------------added successfully
--END TRY
--BEGIN CATCH
--	--On Error
--	IF @@TRANCOUNT > 0
--	 ROLLBACK TRANSACTION;

--     SET @Success = 0; -- Error occurred
--	 DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
--	 --Log Error
--	 EXEC [spInsertErrorLog]
--			 @ModuleName = 'Accounts'
--			,@Source = 'Proc_RequestInvoice'
--			,@ErrorMessage = @ErrorMessage
--			,@ErrorType = 'SP'
--			,@ReportedByUserId = @UserId
--END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[spGetAttendanceForUserOnDashboard]    Script Date: 24-01-2019 17:17:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetAttendanceForUserOnDashboard]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGetAttendanceForUserOnDashboard] AS' 
END
GO
/***
   Created Date      :    2018-12-10
   Created By        :    Kanchan Kumari
   Purpose           :    To get user attendance
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   10 dec 2018      kanchan kumari        get attendance datewise
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   EXEC  [dbo].[spGetAttendanceForUserOnDashboard]
	 @UserId = 57
	,@StartDate = '2019-01-01'
   ,@EndDate = '2019-01-31'
***/
ALTER PROCEDURE [dbo].[spGetAttendanceForUserOnDashboard]  
    @UserId [int]
   ,@StartDate [date]
   ,@EndDate [date]
AS
BEGIN
	SET FMTONLY OFF;
	SET NOCOUNT ON ;

	IF OBJECT_ID('tempdb..#UserDateMapping') IS NOT NULL
	DROP TABLE #UserDateMapping

	IF OBJECT_ID('tempdb..#NightShiftUsers') IS NOT NULL
	DROP TABLE #NightShiftUsers

	IF OBJECT_ID('tempdb..#FinalAttendanceData') IS NOT NULL
	DROP TABLE #FinalAttendanceData

	IF OBJECT_ID('tempdb..#UserDateMapping') IS NOT NULL
	DROP TABLE #UserDateMapping

	 -- For Old Building Machine Data. 
	CREATE TABLE #UserDateMapping (
		[UserId] [int] NOT NULL
		,[DateId] [bigint] NOT NULL
		,[Date] [date] NOT NULL
		,[Day] [varchar](20) NOT NULL
	)
	 
	CREATE TABLE #FinalAttendanceData (
		[UserId] [int] NOT NULL
		,[DateId] [bigint] NOT NULL
		,[Date] [date] NOT NULL
		,[DisplayDate] [varchar](20) NOT NULL
		,[InTime] VARCHAR(50) NULL
		,[OutTime] VARCHAR(50) NULL
		,[TotalTime] VARCHAR(50) NULL
		,[IsNightShift] BIT  NULL
		,[IsApproved] BIT NULL
		,[IsPending] BIT NULL
	)

	INSERT INTO #UserDateMapping
	(
		[UserId],[DateId],[Date],[Day]
	)
	SELECT @UserId, [DateId], [Date], [Day]
	FROM [dbo].[DateMaster] WHERE [Date] BETWEEN @StartDate AND @EndDate

	INSERT INTO #FinalAttendanceData
	(
		[UserId],[DateId],[Date],[DisplayDate],[InTime],[OutTime],[TotalTime],[IsNightShift]
	)
	SELECT @UserId, M.[DateId], M.[Date]
		,CONVERT ([varchar](11), M.[Date], 106) + ' (' + SUBSTRING(M.[Day], 1, 3) + ')'
		,CONVERT(VARCHAR(20),ISNULL(A.[UserGivenInTime], A.[SystemGeneratedInTime]),106)+' '+FORMAT(ISNULL(A.[UserGivenInTime], A.[SystemGeneratedInTime]),'hh:mm tt') AS [InTime]
		,CONVERT(VARCHAR(20),ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]),106)+' '+FORMAT(ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]),'hh:mm tt') AS [OutTime]
		,CONVERT(VARCHAR(5), ISNULL(A.[UserGivenTotalWorkingHours], A.[SystemGeneratedTotalWorkingHours]), 108) AS [TotalTime]
		,A.IsNightShift
	FROM [dbo].[DateWiseAttendance] A WITH (NOLOCK)
	RIGHT JOIN #UserDateMapping M ON M.[DateId] = A.[DateId] AND M.[UserId] = A.[UserId] AND  A.IsActive = 1 AND A.IsDeleted = 0
	
	  ------- update --------------
	UPDATE #FinalAttendanceData SET IsNightShift = 0 WHERE IsNightShift IS NULL

	CREATE TABLE #NightShiftUsers
	(
		[UserId] INT,
		[Pin] VARCHAR(20) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
		[Date] DATE NOT NULL,
		[IsPending] BIT NOT NULL,
		[IsApproved] BIT NOT NULL
	)
	 ---------insert night shift user ----------------------
	INSERT INTO #NightShiftUsers ([UserId], [Date],[IsPending], [IsApproved])
	SELECT U.CreatedBy, D.[Date], 
		CASE WHEN U.StatusId = 2 AND U.LastModifiedBy IS NULL AND U.LastModifiedDate IS NULL THEN 1
		ELSE 0 END AS [IsPending],
		CASE WHEN U.StatusId = 3 OR (U.StatusId = 2 AND U.LastModifiedBy IS NOT NULL AND U.LastModifiedDate IS NOT NULL)  
		THEN 1 ELSE 0 END AS [IsApproved]
	FROM DateWiseLnsa U JOIN DateMaster D WITH (NOLOCK) ON U.DateId= D.DateId
	WHERE U.StatusId = 3 OR U.StatusId = 2  AND D.[Date] BETWEEN @StartDate AND @EndDate
	GROUP BY U.CreatedBy, D.[Date], U.StatusId,  U.LastModifiedBy, U.LastModifiedDate 

	UPDATE F SET F.IsNightShift = 1, F.[IsPending] = N.[IsPending], F.[IsApproved] = N.[IsApproved]
	FROM #FinalAttendanceData F
	JOIN #NightShiftUsers N ON F.UserId = N.UserId AND F.[Date] = N.[Date]

	UPDATE #FinalAttendanceData SET [IsPending] = 0 WHERE [IsPending] IS NULL
	UPDATE #FinalAttendanceData SET [IsApproved] = 0 WHERE [IsApproved] IS NULL
	UPDATE #FinalAttendanceData SET IsNightShift = 0 WHERE [IsNightShift] IS NULL

	UPDATE T SET
		T.[InTime] = 'Holiday'
		,T.[OutTime] = 'Holiday'
		,T.[TotalTime] = H.[Holiday]
	FROM #FinalAttendanceData T
	INNER JOIN [dbo].[ListofHoliday] H WITH (NOLOCK) ON H.[DateId] = T.[DateId]
	WHERE T.[InTime] IS NULL 

	UPDATE T SET
		T.[InTime] = CASE  WHEN LT.[ShortName] = 'WFH' THEN 'WFH' WHEN LT.[ShortName] = 'LWP' THEN 'LWP' ELSE 'Leave' END
		,T.[OutTime] = CASE  WHEN LT.[ShortName] = 'WFH' THEN 'WFH'WHEN LT.[ShortName] = 'LWP' THEN 'LWP' ELSE 'Leave' END
		,T.[TotalTime] = CASE  WHEN LT.[ShortName] = 'WFH' THEN 'WFH' WHEN LT.[ShortName] = 'LWP' THEN 'LWP' ELSE 'Leave' END--LT.[ShortName]
	FROM #FinalAttendanceData T
	INNER JOIN [dbo].[DateWiseLeaveType] L WITH (NOLOCK) ON L.[DateId] = T.[DateId]         
	INNER JOIN [dbo].[LeaveRequestApplication] A WITH (NOLOCK) ON A.[LeaveRequestApplicationId] = L.[LeaveRequestApplicationId] AND A.[UserId] = T.[UserId]
	INNER JOIN [dbo].[LeaveTypeMaster] LT WITH (NOLOCK) ON LT.[TypeId] = L.[LeaveTypeId]
	WHERE T.[InTime] IS NULL AND A.[IsActive] = 1 AND A.[IsDeleted] = 0 AND A.[StatusId] > 0
	   UPDATE T SET
      T.[InTime] = 'Outing'
     ,T.[OutTime] = 'Outing'
     ,T.[TotalTime] = LT.[OutingTypeName]
   FROM
      #FinalAttendanceData T
         INNER JOIN [dbo].[OutingRequestDetail] L WITH (NOLOCK) ON L.[DateId] = T.[DateId]         
         INNER JOIN [dbo].[OutingRequest] A WITH (NOLOCK) ON A.[OutingRequestId] = L.[OutingRequestId] AND A.[UserId] = T.[UserId]
         INNER JOIN [dbo].[OutingType] LT WITH (NOLOCK) ON LT.[OutingTypeId] = A.[OutingTypeId]
   WHERE T.[InTime] IS NULL AND A.[IsActive] = 1 AND A.[IsDeleted] = 0 AND A.[StatusId] < 6
	SELECT 
		F.[DisplayDate] AS [Date]
		,ISNULL(F.[InTime], 'NA') AS [InTime]
		,ISNULL(F.[OutTime], 'NA') AS [OutTime]
		,ISNULL(F.[TotalTime], 'NA') AS [LoggedInHours]
		,IsNightShift, IsApproved, IsPending
	FROM #FinalAttendanceData F
	Group by F.[InTime],F.[OutTime],F.[DisplayDate], F.[TotalTime],IsNightShift,IsApproved,IsPending,F.[Date]
	ORDER BY F.[Date], F.[InTime] DESC
END
GO
/****** Object:  StoredProcedure [dbo].[spGetEmployeeAttendance]    Script Date: 24-01-2019 17:17:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetEmployeeAttendance]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGetEmployeeAttendance] AS' 
END
GO
/***
   Created Date      :     08-May-2017
   Created By        :     Chandra Prakash
   Purpose           :     This stored procedure retrives user attendance based on filter condition
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   2018-12-02         kanchan kumari       get flag for night shift user 
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------   
   --- Test Case 1
         EXEC [dbo].[spGetEmployeeAttendance]
            @FromDate = '2019-01-01'
           ,@EndDate = '2019-01-31'
           ,@DepartmentId = 0
           ,@ForEmployeeIds = '57'
           ,@RMId = '2203'
		   ,@FetchDataForEntireOrg = 0

***/
ALTER PROCEDURE [dbo].[spGetEmployeeAttendance]
      @FromDate [date]
     ,@EndDate [date]
     ,@DepartmentId [int] = NULL
     ,@ForEmployeeIds varchar(2000) = NULL
     ,@RMId [int] = NULL
     ,@FetchDataForEntireOrg [bit] = 0
AS
BEGIN
  SET NOCOUNT ON;
  SET FMTONLY OFF;
   IF OBJECT_ID('tempdb..#UserDateMapping') IS NOT NULL
	DROP TABLE #UserDateMapping

	IF OBJECT_ID('tempdb..#NightShiftUsers') IS NOT NULL
	DROP TABLE #NightShiftUsers

	IF OBJECT_ID('tempdb..#FinalAttendanceData') IS NOT NULL
	DROP TABLE #FinalAttendanceData

   IF OBJECT_ID('tempdb..#FinalAttendanceData2') IS NOT NULL
   DROP TABLE #FinalAttendanceData2

    IF OBJECT_ID('tempdb..#UserDateMapping') IS NOT NULL
   DROP TABLE #UserDateMapping

   IF OBJECT_ID('tempdb..#Users') IS NOT NULL
   DROP TABLE #Users

    DECLARE @DepartmentName [varchar](50)
   CREATE TABLE #UserDateMapping(
      [UserId] [int] NOT NULL
     ,[DateId] [bigint] NOT NULL
     ,[Date] [date] NOT NULL
     ,[Day] [varchar](20) NOT NULL)

   CREATE TABLE #FinalAttendanceData(
      [UserId] [int] NOT NULL
     ,[EmployeeName] [varchar](100) NOT NULL
     ,[DateId] [bigint] NOT NULL
     ,[Date] [date] NOT NULL
     ,[DisplayDate] [varchar](20) NOT NULL
     ,[InTime] VARCHAR(50) NULL
     ,[OutTime] VARCHAR(50) NULL
     ,[TotalTime] VARCHAR(50) NULL
	 ,[IsNightShift] BIT  NULL
	 ,[IsApproved] BIT NULL
	 ,[IsPending] BIT NULL
	 )

	  CREATE TABLE #FinalAttendanceData2(
      [UserId] [int] NOT NULL
     ,[EmployeeName] [varchar](100) NOT NULL
     ,[DateId] [bigint] NOT NULL
     ,[Date] [date] NOT NULL
     ,[DisplayDate] [varchar](20) NOT NULL
     ,[InTime] varchar(50) NULL
     ,[OutTime] varchar(50) NULL
     ,[TotalTime] varchar(50) NULL
	 ,[IsNightShift] BIT NOT NULL
	 ,[IsApproved] BIT NOT NULL
	 ,[IsPending] BIT NOT NULL
	 )
   
   CREATE TABLE #Users(
      [EmployeeId] [int]
     ,[ManagerId] [int])   

   IF(@RMId IS NOT NULL)   
      INSERT INTO #Users
         EXEC [dbo].[spGetEmployeesReportingToUser]
            @UserId = @RMId
           ,@IncludeUser = 0
           ,@FetchDataForEntireOrg = @FetchDataForEntireOrg
   ELSE
      INSERT INTO #Users 
         SELECT [SplitData]
               ,NULL 
         FROM [dbo].[Fun_SplitStringInt](@ForEmployeeIds, ',')

   INSERT INTO #UserDateMapping
   (
       [UserId],[DateId],[Date],[Day]
   )
   SELECT
       UTM.[UserId],D.[DateId],D.[Date],D.[Day]
   FROM
      [dbo].[UserTeamMapping] UTM WITH (NOLOCK)
      INNER JOIN [dbo].[Team] T WITH (NOLOCK) 
         ON UTM.[TeamId] = T.[TeamId]
      CROSS JOIN [dbo].[DateMaster] D WITH (NOLOCK)
      INNER JOIN [dbo].[UserDetail] UD WITH (NOLOCK) 
         ON UD.[UserId] = UTM.[UserId] 
         AND ISNULL(UD.[TerminateDate], '2999-12-31') > D.[Date] 
         --AND UD.[JoiningDate] < D.[Date]
      INNER JOIN #Users U ON U.[EmployeeId] = UTM.[UserId]          
   WHERE
      T.[DepartmentId] = CASE WHEN @DepartmentId > 0 THEN @DepartmentId ELSE T.[DepartmentId] END
      AND D.[Date] BETWEEN @FromDate AND @EndDate AND UTM.[IsActive] = 1

   IF @ForEmployeeIds != ''
   BEGIN
      DELETE FROM #UserDateMapping WHERE  [UserId] NOT IN (SELECT [SplitData] FROM [dbo].[Fun_SplitStringInt](@ForEmployeeIds, ','))
   END

   --SELECT * FROM #UserDateMapping
   -- From Old Building Data
   INSERT INTO #FinalAttendanceData
   (
      [UserId],[EmployeeName],[DateId],[Date],[DisplayDate],[InTime],[OutTime],[TotalTime],[IsNightShift]
   )
   SELECT 
      U.[UserId],U.[FirstName] + ' ' + U.[LastName],M.[DateId],M.[Date]
     ,CONVERT ([varchar](11), M.[Date], 106) + ' (' + SUBSTRING(M.[Day], 1, 3) + ')'
	 ,CONVERT(VARCHAR(20),ISNULL(A.[UserGivenInTime], A.[SystemGeneratedInTime]),106)+' '+FORMAT(ISNULL(A.[UserGivenInTime], A.[SystemGeneratedInTime]),'hh:mm tt') AS [InTime]
	 ,CONVERT(VARCHAR(20),ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]),106)+' '+FORMAT(ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]),'hh:mm tt') AS [OutTime]
	 ,CONVERT(VARCHAR(5), ISNULL(A.[UserGivenTotalWorkingHours], A.[SystemGeneratedTotalWorkingHours]), 108) AS [TotalTime]
    -- ,CASE 
    --     WHEN CONVERT(datetime, M.[Date], 106) = CONVERT(datetime, ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]), 106) THEN CONVERT(datetime ,CAST(ISNULL(A.[UserGivenInTime], A.[SystemGeneratedInTime]) AS [time]), 100)
    --     ELSE CONVERT(datetime ,CAST(ISNULL(A.[UserGivenInTime], A.[SystemGeneratedInTime]) AS [time]), 100) --+ ' (' + CONVERT ([varchar](11), ISNULL(A.[UserGivenInTime], A.[SystemGeneratedInTime]), 106) + ')'
    --END
    -- ,CASE
    --     WHEN CONVERT(datetime, M.[Date], 106) = CONVERT(datetime, ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]), 106) THEN CONVERT(datetime ,CAST(ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]) AS [time]), 100)
    --     ELSE CONVERT(datetime ,CAST(ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]) AS [time]), 100) --+ ' (' + CONVERT ([varchar](11), ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]), 106) + ')'
    --  END
    -- ,CONVERT(datetime, ISNULL(A.[UserGivenTotalWorkingHours], A.[SystemGeneratedTotalWorkingHours]), 108)
	 ,A.IsNightShift
   FROM
      [dbo].[DateWiseAttendance] A WITH (NOLOCK)
      RIGHT JOIN #UserDateMapping M ON M.[DateId] = A.[DateId] AND M.[UserId] = A.[UserId] AND A.IsActive = 1 AND A.IsDeleted = 0
      INNER JOIN [dbo].[UserDetail] U WITH (NOLOCK) ON M.[UserId] = U.[UserId]

	  --select * from #FinalAttendanceData WHERE UserId = 2421 ORDER BY [Date] DESC

 --  ---- From New Bulding Data.
	--INSERT INTO #FinalAttendanceData
 --  (
 --     [UserId],[EmployeeName],[DateId],[Date],[DisplayDate],[InTime],[OutTime],[TotalTime]
 --  )
 --  SELECT 
 --     U.[UserId],U.[FirstName] + ' ' + U.[LastName],M.[DateId],M.[Date]
 --    ,CONVERT ([varchar](11), M.[Date], 106) + ' (' + SUBSTRING(M.[Day], 1, 3) + ')'
	-- ,CONVERT(VARCHAR(20),ISNULL(A.[UserGivenInTime], A.[SystemGeneratedInTime]),106)+' '+FORMAT(ISNULL(A.[UserGivenInTime], A.[SystemGeneratedInTime]),'hh:mm tt') AS [InTime]
	-- ,CONVERT(VARCHAR(20),ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]),106)+' '+FORMAT(ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]),'hh:mm tt') AS [OutTime]
	-- ,CONVERT(VARCHAR(5), ISNULL(A.[UserGivenTotalWorkingHours], A.[SystemGeneratedTotalWorkingHours]), 108) AS [TotalTime]
 --   -- ,CASE 
 --   --     WHEN CONVERT(datetime, M.[Date], 106) = CONVERT(datetime, ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]), 106) THEN CONVERT(datetime ,CAST(ISNULL(A.[UserGivenInTime], A.[SystemGeneratedInTime]) AS [time]), 100)
 --   --     ELSE CONVERT(datetime ,CAST(ISNULL(A.[UserGivenInTime], A.[SystemGeneratedInTime]) AS [time]), 100) --+ ' (' + CONVERT ([varchar](11), ISNULL(A.[UserGivenInTime], A.[SystemGeneratedInTime]), 106) + ')'
 --   --END
 --   -- ,CASE
 --   -- WHEN CONVERT(datetime, M.[Date], 106) = CONVERT(datetime, ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]), 106) THEN CONVERT(datetime ,CAST(ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]) AS [time]), 100)
 --   --     ELSE CONVERT(datetime ,CAST(ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]) AS [time]), 100) --+ ' (' + CONVERT ([varchar](11), ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]), 106) + ')'
 --   --  END
 --   -- ,CONVERT(datetime, ISNULL(A.[UserGivenTotalWorkingHours], A.[SystemGeneratedTotalWorkingHours]), 108)
	
 --  FROM
 --     [dbo].[DateWiseAttendanceAsquare] A WITH (NOLOCK)
 --     RIGHT JOIN #UserDateMapping M ON M.[DateId] = A.[DateId] AND M.[UserId] = A.[UserId] AND A.IsActive = 1 AND A.IsDeleted = 0
 --     INNER JOIN [dbo].[UserDetail] U WITH (NOLOCK) ON M.[UserId] = U.[UserId]


   --INSERT INTO #FinalAttendanceData
   --(
   --   [UserId],[EmployeeName],[DateId],[Date],[DisplayDate],[InTime],[OutTime],[TotalTime]
   --)
   --SELECT 
   --   U.[UserId],U.[FirstName] + ' ' + U.[LastName],M.[DateId],M.[Date]
   --  ,CONVERT ([varchar](11), M.[Date], 106) + ' (' + SUBSTRING(M.[Day], 1, 3) + ')'
   -- ,CASE 
   --      WHEN CONVERT(datetime, M.[Date], 106) = CONVERT(datetime, ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]), 106) THEN CONVERT(datetime ,CAST(ISNULL(A.[UserGivenInTime], A.[SystemGeneratedInTime]) AS [time]), 100)
   --      ELSE CONVERT(datetime ,CAST(ISNULL(A.[UserGivenInTime], A.[SystemGeneratedInTime]) AS [time]), 100) --+ ' (' + CONVERT ([varchar](11), ISNULL(A.[UserGivenInTime], A.[SystemGeneratedInTime]), 106) + ')'
   --   END
   --  ,CASE
   --      WHEN CONVERT(datetime, M.[Date], 106) = CONVERT(datetime, ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]), 106) THEN CONVERT(datetime ,CAST(ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]) AS [time]), 100)
   --      ELSE CONVERT(datetime ,CAST(ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]) AS [time]), 100) --+ ' (' + CONVERT ([varchar](11), ISNULL(A.[UserGivenOutTime], A.[SystemGeneratedOutTime]), 106) + ')'
   --   END
   --  ,CONVERT(datetime, ISNULL(A.[UserGivenTotalWorkingHours], A.[SystemGeneratedTotalWorkingHours]), 108)
   --FROM
   --   [dbo].[DateWiseAttendanceAsquare] A WITH (NOLOCK)
   --   RIGHT JOIN #UserDateMapping M ON M.[DateId] = A.[DateId] AND M.[UserId] = A.[UserId]
   --   INNER JOIN [dbo].[UserDetail] U WITH (NOLOCK) ON M.[UserId] = U.[UserId]
   
    ---update isnight shiift where null--------
	  UPDATE #FinalAttendanceData SET IsNightShift = 0 WHERE IsNightShift IS NULL

	  ---------------------------------------night shift user---------------
   	 CREATE TABLE #NightShiftUsers
	 (
		 [UserId] INT,
		 [Pin] VARCHAR(20) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
		 [Date] DATE NOT NULL,
		 [FromDateTime] DATETIME,
		 [TillDateTime] DATETIME,
		 [IsPending] BIT NOT NULL,
		 [IsApproved] BIT NOT NULL
	 )
	 ---------insert night shift user ----------------------
	 INSERT INTO #NightShiftUsers ([UserId], [Date],[IsPending], [IsApproved])
	 SELECT U.CreatedBy, D.[Date], 
		 CASE WHEN U.StatusId = 2 AND U.LastModifiedBy IS NULL AND U.LastModifiedDate IS NULL THEN 1
		 ELSE 0 END AS [IsPending],
		 CASE WHEN U.StatusId = 3 OR (U.StatusId = 2 AND U.LastModifiedBy IS NOT NULL AND U.LastModifiedDate IS NOT NULL)  
		 THEN 1 ELSE 0 END AS [IsApproved]
	 FROM DateWiseLnsa U JOIN DateMaster D WITH (NOLOCK) ON U.DateId= D.DateId
     WHERE U.StatusId = 3 OR U.StatusId = 2  AND D.[Date] BETWEEN @FromDate AND @EndDate
	 GROUP BY U.CreatedBy, D.[Date], U.StatusId,  U.LastModifiedBy, U.LastModifiedDate 

	 UPDATE F SET F.IsNightShift = 1, F.[IsPending] = N.[IsPending], F.[IsApproved] = N.[IsApproved]
	 FROM #FinalAttendanceData F
	 JOIN #NightShiftUsers N ON F.UserId = N.UserId AND F.[Date] = N.[Date]

	 UPDATE #FinalAttendanceData SET [IsPending] = 0 WHERE [IsPending] IS NULL
	 UPDATE #FinalAttendanceData SET [IsApproved] = 0 WHERE [IsApproved] IS NULL
	 UPDATE #FinalAttendanceData SET IsNightShift = 0 WHERE [IsNightShift] IS NULL

 ---------------------------------------------------------

   INSERT INTO #FinalAttendanceData2
   (
      [UserId],[EmployeeName],[DateId],[Date],[DisplayDate],[InTime],[OutTime],[TotalTime],[IsNightShift],[IsPending],[IsApproved]
   )
     SELECT    
	   DW1.[UserId],DW1.[EmployeeName],DW1.[DateId],DW1.[Date],DW1.[DisplayDate]  
	  ,DW1.[InTime] AS [InTime]
	  ,DW1.[OutTime] AS [OutTime]
	  ,DW1.[TotalTime]           
	 --,CONVERT([varchar](7),CAST( MIN(DW1.[InTime]) AS time), 100) AS [InTime]
	 --,CONVERT([varchar](7),CAST( MAX(DW1.[OutTime]) AS time), 100) AS [OutTime]
	 --,CONVERT([varchar](5),(MAX(DW1.[OutTime]) - MIN(DW1.[InTime])), 108) AS [TotalTime]
	 ,DW1.[IsNightShift]
	 ,DW1.IsPending
	 ,DW1.IsApproved
   FROM  #FinalAttendanceData DW1 
   
   --select * from #FinalAttendanceData2 WHERE UserId = 2421 ORDER BY [Date] DESC

   UPDATE T SET
      T.[InTime] = 'Holiday'
     ,T.[OutTime] = 'Holiday'
     ,T.[TotalTime] = H.[Holiday]
   FROM
      #FinalAttendanceData2 T
         INNER JOIN [dbo].[ListofHoliday] H WITH (NOLOCK) ON H.[DateId] = T.[DateId]
   WHERE T.[InTime] IS NULL 

   UPDATE T SET
      T.[InTime] = CASE  WHEN LT.[ShortName] = 'WFH' THEN 'WFH' WHEN LT.[ShortName] = 'LWP' THEN 'LWP' ELSE 'Leave' END
     ,T.[OutTime] = CASE  WHEN LT.[ShortName] = 'WFH' THEN 'WFH'WHEN LT.[ShortName] = 'LWP' THEN 'LWP' ELSE 'Leave' END
     ,T.[TotalTime] = CASE  WHEN LT.[ShortName] = 'WFH' THEN 'WFH' WHEN LT.[ShortName] = 'LWP' THEN 'LWP' ELSE 'Leave' END--LT.[ShortName]
   FROM
      #FinalAttendanceData2 T
         INNER JOIN [dbo].[DateWiseLeaveType] L WITH (NOLOCK) ON L.[DateId] = T.[DateId]         
         INNER JOIN [dbo].[LeaveRequestApplication] A WITH (NOLOCK) ON A.[LeaveRequestApplicationId] = L.[LeaveRequestApplicationId] AND A.[UserId] = T.[UserId]
         INNER JOIN [dbo].[LeaveTypeMaster] LT WITH (NOLOCK) ON LT.[TypeId] = L.[LeaveTypeId]
   WHERE T.[InTime] IS NULL AND A.[IsActive] = 1 AND A.[IsDeleted] = 0 AND A.[StatusId] > 0
   
   
     UPDATE T SET
      T.[InTime] = 'Outing'
     ,T.[OutTime] = 'Outing'
     ,T.[TotalTime] = LT.[OutingTypeName]
   FROM
      #FinalAttendanceData2 T
         INNER JOIN [dbo].[OutingRequestDetail] L WITH (NOLOCK) ON L.[DateId] = T.[DateId]         
         INNER JOIN [dbo].[OutingRequest] A WITH (NOLOCK) ON A.[OutingRequestId] = L.[OutingRequestId] AND A.[UserId] = T.[UserId]
         INNER JOIN [dbo].[OutingType] LT WITH (NOLOCK) ON LT.[OutingTypeId] = A.[OutingTypeId]
   WHERE T.[InTime] IS NULL AND A.[IsActive] = 1 AND A.[IsDeleted] = 0 AND A.[StatusId] < 6
   SELECT 
      F.[UserId]
     ,F.[DisplayDate] AS [Date]
     ,F.[EmployeeName] AS [EmployeeName]
     ,D.[DepartmentName] AS [Department]
     ,ISNULL(F.[InTime], 'NA') AS [InTime]
     ,ISNULL(F.[OutTime], 'NA') AS [OutTime]
     ,ISNULL(F.[TotalTime], 'NA') AS [LoggedInHours]
	 ,IsNightShift
	 ,IsApproved
	 ,IsPending
   FROM #FinalAttendanceData2 F
         INNER JOIN [dbo].[UserTeamMapping] UTM WITH (NOLOCK) ON F.[UserId] = UTM.[UserId] AND UTM.[IsActive] = 1
         INNER JOIN [dbo].[Team] T WITH (NOLOCK) ON UTM.[TeamId] = T.[TeamId]
         INNER JOIN [dbo].[Department] D WITH (NOLOCK) ON D.[DepartmentId] = T.[DepartmentId]  
   GROUP BY  F.[UserId], F.[DisplayDate],F.[EmployeeName],D.[DepartmentName], F.[InTime],F.[OutTime],F.[TotalTime],IsNightShift,IsApproved,IsPending,F.[Date]
   ORDER BY       
      F.[EmployeeName]
     ,F.[Date]
     ,F.[InTime] DESC
END
GO
