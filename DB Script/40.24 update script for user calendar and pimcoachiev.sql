GO
/****** Object:  StoredProcedure [dbo].[Proc_GetUserWiseWeekDataInCalendar]    Script Date: 13-02-2019 13:44:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetUserWiseWeekDataInCalendar]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetUserWiseWeekDataInCalendar]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__PimcoAchi__Pimco__2F1E1ACF]') AND parent_object_id = OBJECT_ID(N'[dbo].[PimcoAchievementDetail]'))
ALTER TABLE [dbo].[PimcoAchievementDetail] DROP CONSTRAINT [FK__PimcoAchi__Pimco__2F1E1ACF]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__PimcoAchi__UserI__29654179]') AND parent_object_id = OBJECT_ID(N'[dbo].[PimcoAchievement]'))
ALTER TABLE [dbo].[PimcoAchievement] DROP CONSTRAINT [FK__PimcoAchi__UserI__29654179]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__PimcoAchi__Creat__31066341]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PimcoAchievementDetail] DROP CONSTRAINT [DF__PimcoAchi__Creat__31066341]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__PimcoAchi__IsAct__30123F08]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PimcoAchievementDetail] DROP CONSTRAINT [DF__PimcoAchi__IsAct__30123F08]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__PimcoAchi__Creat__2C41AE24]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PimcoAchievement] DROP CONSTRAINT [DF__PimcoAchi__Creat__2C41AE24]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__PimcoAchi__ToBeD__2B4D89EB]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PimcoAchievement] DROP CONSTRAINT [DF__PimcoAchi__ToBeD__2B4D89EB]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__PimcoAchi__IsAct__2A5965B2]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PimcoAchievement] DROP CONSTRAINT [DF__PimcoAchi__IsAct__2A5965B2]
END

GO
/****** Object:  Table [dbo].[PimcoAchievementDetail]    Script Date: 13-02-2019 13:44:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PimcoAchievementDetail]') AND type in (N'U'))
DROP TABLE [dbo].[PimcoAchievementDetail]
GO
/****** Object:  Table [dbo].[PimcoAchievement]    Script Date: 13-02-2019 13:44:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PimcoAchievement]') AND type in (N'U'))
DROP TABLE [dbo].[PimcoAchievement]
GO
/****** Object:  Table [dbo].[PimcoAchievement]    Script Date: 13-02-2019 13:44:07 ******/
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
	[IsActive] [bit] NOT NULL,
	[ToBeDiscussedWithHR] [bit] NOT NULL,
	[EmpComments] [varchar](500) NULL,
	[RMComments] [varchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
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
/****** Object:  Table [dbo].[PimcoAchievementDetail]    Script Date: 13-02-2019 13:44:07 ******/
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
	[IsActive] [bit] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
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
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__PimcoAchi__IsAct__2A5965B2]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PimcoAchievement] ADD  DEFAULT ((1)) FOR [IsActive]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__PimcoAchi__ToBeD__2B4D89EB]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PimcoAchievement] ADD  DEFAULT ((0)) FOR [ToBeDiscussedWithHR]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__PimcoAchi__Creat__2C41AE24]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PimcoAchievement] ADD  DEFAULT (getdate()) FOR [CreatedDate]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__PimcoAchi__IsAct__30123F08]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PimcoAchievementDetail] ADD  DEFAULT ((1)) FOR [IsActive]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__PimcoAchi__Creat__31066341]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PimcoAchievementDetail] ADD  DEFAULT (getdate()) FOR [CreatedDate]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__PimcoAchi__UserI__29654179]') AND parent_object_id = OBJECT_ID(N'[dbo].[PimcoAchievement]'))
ALTER TABLE [dbo].[PimcoAchievement]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([UserId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__PimcoAchi__Pimco__2F1E1ACF]') AND parent_object_id = OBJECT_ID(N'[dbo].[PimcoAchievementDetail]'))
ALTER TABLE [dbo].[PimcoAchievementDetail]  WITH CHECK ADD FOREIGN KEY([PimcoAchievementId])
REFERENCES [dbo].[PimcoAchievement] ([PimcoAchievementId])
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetUserWiseWeekDataInCalendar]    Script Date: 13-02-2019 13:44:07 ******/
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
      EXEC [Proc_GetUserWiseWeekDataInCalendar] @LoginUserId=2434,@StartDate='2019-01-28',@EndDate='2019-03-10'
***/
ALTER PROC [dbo].[Proc_GetUserWiseWeekDataInCalendar]
(
 @LoginUserId INT 
,@StartDate DATE 
,@EndDate DATE 
)
AS
BEGIN
	SET FMTONLY OFF;
	SET NOCOUNT ON;
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
	WHERE U.[UserId]=@LoginUserId AND D.[Date] BETWEEN @StartDate AND @EndDate 

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
 JOIN [dbo].[EmployeeWiseWeekOff] E ON E.[WeekOffDateId]=U.DateId AND E.[UserId]=U.[UserId]
 WHERE U.[IsNormalWeek]=0 
 ----------------select userwise data---------------------
    SELECT DateId,[Date],IsWeekend,UserId,WeekNo,IsNormalWeek,IsMarked FROM #UserDateMapping WHERE IsMarked=1
END


GO

--------------------------menu add----------------
INSERT INTO Menu (ParentMenuId,MenuName,ControllerName,ActionName,[Sequence],CreatedById)
SELECT M.[MenuId],'Team Pimco Achievements',M.[ControllerName],'TeamPimcoAchievements',16,2434
FROM Menu M WHERE M.[ParentMenuId]=0 AND MenuName='Appraisal Management'