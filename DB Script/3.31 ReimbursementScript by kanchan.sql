/****** Object:  StoredProcedure [dbo].[Proc_TakeActionOnReimbursementRequest]    Script Date: 10-10-2018 14:40:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TakeActionOnReimbursementRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TakeActionOnReimbursementRequest]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetReimbursementListToReview]    Script Date: 10-10-2018 14:40:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetReimbursementListToReview]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetReimbursementListToReview]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetReimbursementList]    Script Date: 10-10-2018 14:40:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetReimbursementList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetReimbursementList]
GO
/****** Object:  StoredProcedure [dbo].[Proc_AddUpdateReimbursementRequest]    Script Date: 10-10-2018 14:40:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddUpdateReimbursementRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AddUpdateReimbursementRequest]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ReimbursementRequest_User_UserId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReimbursementRequest]'))
ALTER TABLE [dbo].[ReimbursementRequest] DROP CONSTRAINT [FK_ReimbursementRequest_User_UserId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ReimbursementRequest_User_NextApproverId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReimbursementRequest]'))
ALTER TABLE [dbo].[ReimbursementRequest] DROP CONSTRAINT [FK_ReimbursementRequest_User_NextApproverId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ReimbursementRequest_ReimbursementType]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReimbursementRequest]'))
ALTER TABLE [dbo].[ReimbursementRequest] DROP CONSTRAINT [FK_ReimbursementRequest_ReimbursementType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ReimbursementRequest_ReimbursementStatus]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReimbursementRequest]'))
ALTER TABLE [dbo].[ReimbursementRequest] DROP CONSTRAINT [FK_ReimbursementRequest_ReimbursementStatus]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ReimbursementHistory_ReimbursementStatus]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReimbursementHistory]'))
ALTER TABLE [dbo].[ReimbursementHistory] DROP CONSTRAINT [FK_ReimbursementHistory_ReimbursementStatus]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ReimbursementHistory_ReimbursementRequest]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReimbursementHistory]'))
ALTER TABLE [dbo].[ReimbursementHistory] DROP CONSTRAINT [FK_ReimbursementHistory_ReimbursementRequest]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ReimbursementDetail_ReimbursementRequest]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReimbursementDetail]'))
ALTER TABLE [dbo].[ReimbursementDetail] DROP CONSTRAINT [FK_ReimbursementDetail_ReimbursementRequest]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ReimbursementDetail_ReimbursementCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReimbursementDetail]'))
ALTER TABLE [dbo].[ReimbursementDetail] DROP CONSTRAINT [FK_ReimbursementDetail_ReimbursementCategory]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_ReimbursementRequest_CreatedDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ReimbursementRequest] DROP CONSTRAINT [DF_ReimbursementRequest_CreatedDate]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_ReimbursementRequest_IsActive]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ReimbursementRequest] DROP CONSTRAINT [DF_ReimbursementRequest_IsActive]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_ReimbursementRequest_IsReferredBack]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ReimbursementRequest] DROP CONSTRAINT [DF_ReimbursementRequest_IsReferredBack]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_ReimbursementHistory_CreatedDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ReimbursementHistory] DROP CONSTRAINT [DF_ReimbursementHistory_CreatedDate]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_ReimbursementDetail_CreatedDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ReimbursementDetail] DROP CONSTRAINT [DF_ReimbursementDetail_CreatedDate]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_ReimbursementDetail_IsActive]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ReimbursementDetail] DROP CONSTRAINT [DF_ReimbursementDetail_IsActive]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_ReimbursementDetail_IsDocumentValid]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ReimbursementDetail] DROP CONSTRAINT [DF_ReimbursementDetail_IsDocumentValid]
END

GO
/****** Object:  Table [dbo].[ReimbursementRequest]    Script Date: 10-10-2018 14:40:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReimbursementRequest]') AND type in (N'U'))
DROP TABLE [dbo].[ReimbursementRequest]
GO
/****** Object:  Table [dbo].[ReimbursementHistory]    Script Date: 10-10-2018 14:40:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReimbursementHistory]') AND type in (N'U'))
DROP TABLE [dbo].[ReimbursementHistory]
GO
/****** Object:  Table [dbo].[ReimbursementDetail]    Script Date: 10-10-2018 14:40:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReimbursementDetail]') AND type in (N'U'))
DROP TABLE [dbo].[ReimbursementDetail]
GO
/****** Object:  Table [dbo].[ReimbursementDetail]    Script Date: 10-10-2018 14:40:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReimbursementDetail]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ReimbursementDetail](
	[ReimbursementDetailId] [bigint] IDENTITY(1,1) NOT NULL,
	[ReimbursementRequestId] [bigint] NOT NULL,
	[ReimbursementCategoryId] [int] NOT NULL,
	[DocumentPath] [varchar](100) NOT NULL,
	[DocumentName] [varchar](500) NOT NULL,
	[BillNo] [varchar](100) NOT NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[Date] [date] NOT NULL,
	[Remarks] [varchar](500) NULL,
	[IsDocumentValid] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedById] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedById] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ReimbursementDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ReimbursementHistory]    Script Date: 10-10-2018 14:40:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReimbursementHistory]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ReimbursementHistory](
	[ReimbursementHistoryId] [bigint] IDENTITY(1,1) NOT NULL,
	[ReimbursementRequestId] [bigint] NOT NULL,
	[StatusId] [int] NOT NULL,
	[Remarks] [varchar](500) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedById] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ReimbursementHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ReimbursementRequest]    Script Date: 10-10-2018 14:40:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReimbursementRequest]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ReimbursementRequest](
	[ReimbursementRequestId] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[ReimbursementTypeId] [int] NOT NULL,
	[Month] [int] NOT NULL,
	[Year] [int] NOT NULL,
	[ReimbRequestedAmt] [decimal](18, 2) NOT NULL,
	[ReimbApprovedAmt] [decimal](18, 2) NULL,
	[NextApproverId] [int] NULL,
	[Remarks] [varchar](500) NULL,
	[StatusId] [int] NOT NULL,
	[IsReferredBack] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[SubmittedDate] [datetime] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedById] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedById] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ReimbursementRequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_ReimbursementDetail_IsDocumentValid]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ReimbursementDetail] ADD  CONSTRAINT [DF_ReimbursementDetail_IsDocumentValid]  DEFAULT ((1)) FOR [IsDocumentValid]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_ReimbursementDetail_IsActive]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ReimbursementDetail] ADD  CONSTRAINT [DF_ReimbursementDetail_IsActive]  DEFAULT ((1)) FOR [IsActive]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_ReimbursementDetail_CreatedDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ReimbursementDetail] ADD  CONSTRAINT [DF_ReimbursementDetail_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_ReimbursementHistory_CreatedDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ReimbursementHistory] ADD  CONSTRAINT [DF_ReimbursementHistory_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_ReimbursementRequest_IsReferredBack]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ReimbursementRequest] ADD  CONSTRAINT [DF_ReimbursementRequest_IsReferredBack]  DEFAULT ((0)) FOR [IsReferredBack]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_ReimbursementRequest_IsActive]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ReimbursementRequest] ADD  CONSTRAINT [DF_ReimbursementRequest_IsActive]  DEFAULT ((1)) FOR [IsActive]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_ReimbursementRequest_CreatedDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ReimbursementRequest] ADD  CONSTRAINT [DF_ReimbursementRequest_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ReimbursementDetail_ReimbursementCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReimbursementDetail]'))
ALTER TABLE [dbo].[ReimbursementDetail]  WITH CHECK ADD  CONSTRAINT [FK_ReimbursementDetail_ReimbursementCategory] FOREIGN KEY([ReimbursementCategoryId])
REFERENCES [dbo].[ReimbursementCategory] ([ReimbursementCategoryId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ReimbursementDetail_ReimbursementCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReimbursementDetail]'))
ALTER TABLE [dbo].[ReimbursementDetail] CHECK CONSTRAINT [FK_ReimbursementDetail_ReimbursementCategory]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ReimbursementDetail_ReimbursementRequest]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReimbursementDetail]'))
ALTER TABLE [dbo].[ReimbursementDetail]  WITH CHECK ADD  CONSTRAINT [FK_ReimbursementDetail_ReimbursementRequest] FOREIGN KEY([ReimbursementRequestId])
REFERENCES [dbo].[ReimbursementRequest] ([ReimbursementRequestId])
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ReimbursementDetail_ReimbursementRequest]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReimbursementDetail]'))
ALTER TABLE [dbo].[ReimbursementDetail] CHECK CONSTRAINT [FK_ReimbursementDetail_ReimbursementRequest]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ReimbursementHistory_ReimbursementRequest]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReimbursementHistory]'))
ALTER TABLE [dbo].[ReimbursementHistory]  WITH CHECK ADD  CONSTRAINT [FK_ReimbursementHistory_ReimbursementRequest] FOREIGN KEY([ReimbursementRequestId])
REFERENCES [dbo].[ReimbursementRequest] ([ReimbursementRequestId])
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ReimbursementHistory_ReimbursementRequest]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReimbursementHistory]'))
ALTER TABLE [dbo].[ReimbursementHistory] CHECK CONSTRAINT [FK_ReimbursementHistory_ReimbursementRequest]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ReimbursementHistory_ReimbursementStatus]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReimbursementHistory]'))
ALTER TABLE [dbo].[ReimbursementHistory]  WITH CHECK ADD  CONSTRAINT [FK_ReimbursementHistory_ReimbursementStatus] FOREIGN KEY([StatusId])
REFERENCES [dbo].[ReimbursementStatus] ([StatusId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ReimbursementHistory_ReimbursementStatus]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReimbursementHistory]'))
ALTER TABLE [dbo].[ReimbursementHistory] CHECK CONSTRAINT [FK_ReimbursementHistory_ReimbursementStatus]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ReimbursementRequest_ReimbursementStatus]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReimbursementRequest]'))
ALTER TABLE [dbo].[ReimbursementRequest]  WITH CHECK ADD  CONSTRAINT [FK_ReimbursementRequest_ReimbursementStatus] FOREIGN KEY([StatusId])
REFERENCES [dbo].[ReimbursementStatus] ([StatusId])
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ReimbursementRequest_ReimbursementStatus]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReimbursementRequest]'))
ALTER TABLE [dbo].[ReimbursementRequest] CHECK CONSTRAINT [FK_ReimbursementRequest_ReimbursementStatus]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ReimbursementRequest_ReimbursementType]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReimbursementRequest]'))
ALTER TABLE [dbo].[ReimbursementRequest]  WITH CHECK ADD  CONSTRAINT [FK_ReimbursementRequest_ReimbursementType] FOREIGN KEY([ReimbursementTypeId])
REFERENCES [dbo].[ReimbursementType] ([ReimbursementTypeId])
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ReimbursementRequest_ReimbursementType]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReimbursementRequest]'))
ALTER TABLE [dbo].[ReimbursementRequest] CHECK CONSTRAINT [FK_ReimbursementRequest_ReimbursementType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ReimbursementRequest_User_NextApproverId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReimbursementRequest]'))
ALTER TABLE [dbo].[ReimbursementRequest]  WITH CHECK ADD  CONSTRAINT [FK_ReimbursementRequest_User_NextApproverId] FOREIGN KEY([NextApproverId])
REFERENCES [dbo].[User] ([UserId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ReimbursementRequest_User_NextApproverId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReimbursementRequest]'))
ALTER TABLE [dbo].[ReimbursementRequest] CHECK CONSTRAINT [FK_ReimbursementRequest_User_NextApproverId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ReimbursementRequest_User_UserId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReimbursementRequest]'))
ALTER TABLE [dbo].[ReimbursementRequest]  WITH CHECK ADD  CONSTRAINT [FK_ReimbursementRequest_User_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([UserId])
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ReimbursementRequest_User_UserId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReimbursementRequest]'))
ALTER TABLE [dbo].[ReimbursementRequest] CHECK CONSTRAINT [FK_ReimbursementRequest_User_UserId]
GO
/****** Object:  StoredProcedure [dbo].[Proc_AddUpdateReimbursementRequest]    Script Date: 10-10-2018 14:40:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddUpdateReimbursementRequest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_AddUpdateReimbursementRequest] AS' 
END
GO
/***
   Created Date      :     2018-08-24
   Created By        :     Kanchan Kumari
   Purpose           :     This stored procedure is to draft Reimbursement data
   --------------------------------------------------------------------------
   Usage             :
   ---
   -----------------------------------------------------------------------
    DECLARE @Result tinyint, @NewRequestId int
         EXEC [dbo].[Proc_AddUpdateReimbursementRequest]
          @UserId = 2432
		  ,@ReimbursementRequestId=0
		  ,@ReimbursementTypeId=2
		  ,,@ReimbusrementRequestedAmt='90987.00'
         ,@ReimbursementXmlString ='<Root>
   <Row ReimbursementDetailId="21" ImageName="blue.jpg" ImagePath="OT_201807_42ef6019-364b-4c08-9b3c-538a33e855b7.jpg" CategoryId="9" Date="09/17/2018" BillNo="jhu678" Amount="768" />
   <Row ReimbursementDetailId="0" ImageName="blue.jpg" ImagePath="OT_201807_42ef6019-364b-4c08-9b3c-538a33e855b7.jpg" CategoryId="9" Date="09/17/2018" BillNo="jhu678" Amount="768" />

</Root>'
		 ,@Month = 7
         ,@Year = 2018
		 ,@Remarks ='Drafted'
		 ,@NewReimbursementRequestId = @NewRequestId out
		 ,@Success = @Result out
       
   SELECT @Result AS Result, @NewRequestId AS RequestId
***/
ALTER PROC [dbo].[Proc_AddUpdateReimbursementRequest]
(
	 @UserId INT 
	,@ReimbursementRequestId BIGINT
	,@ReimbursementTypeId INT
	,@ReimbusrementRequestedAmt DECIMAL(18,2)
	,@ReimbursementXmlString xml
	,@Month INT
	,@Year INT
	,@Remarks VARCHAR(500)
	,@NewReimbursementRequestId INT output
	,@Success tinyint output
)
AS
 BEGIN TRY
	 SET NOCOUNT ON;
	 SET FMTONLY OFF;
  BEGIN TRANSACTION
   DECLARE @Result INT, @NewRequestId INT, @DuplicateCount INT;
			IF OBJECT_ID('tempdb..#TempCheckDuplicateData') IS NOT NULL
			DROP TABLE #TempCheckDuplicateData
		  
			CREATE TABLE #TempCheckDuplicateData(UserId INT, [ReimbursementCategoryId] INT, [BillNo] VARCHAR(50), [Date] DATE, [Amount] DECIMAL(18,2))
			INSERT INTO #TempCheckDuplicateData 
			SELECT CreatedById, ReimbursementCategoryId, BillNo, [Date], [Amount] FROM ReimbursementDetail WHERE IsActive = 1 
	                                  
			IF OBJECT_ID('tempdb..#TempReimbursement') IS NOT NULL
			DROP TABLE #TempReimbursement

		    CREATE TABLE #TempReimbursement([ReimbursementDetailId] BIGINT, ImageName VARCHAR(500), [ImagePath] VARCHAR(200), [Date] DATE, [ReimbursementCategoryId] INT,
	                                    [BillNo] VARCHAR(50), [Amount] DECIMAL(18,2))
            INSERT INTO #TempReimbursement([ReimbursementDetailId],[ImageName], [ImagePath],[ReimbursementCategoryId], [Date], [BillNo], [Amount])
			SELECT 
			    T.Item.value('@ReimbursementDetailId', 'BIGINT'),
			    T.Item.value('@ImageName', 'VARCHAR(200)'),
				T.Item.value('@ImagePath', 'VARCHAR(200)'),
				T.Item.value('@CategoryId','INT'),
				T.Item.value('@Date', 'DATE'),
				T.Item.value('@BillNo', 'VARCHAR(50)'),
				T.Item.value('@Amount','DECIMAL(18,2)')
			FROM @ReimbursementXmlString.nodes('/Root/Row')AS T(Item)
       
			DECLARE @MonthlyReimbursementTypeId INT =0
			SELECT @MonthlyReimbursementTypeId= ReimbursementTypeId FROM ReimbursementType WITH (NOLOCK) WHERE UPPER(ReimbursementTypeName)='MONTHLY'
	          
         IF(@ReimbursementRequestId > 0) --Edit reimbursement form
         BEGIN
		          DECLARE @DuplicateCountForNewDocument INT, @DuplicateCountForExistingDocument INT

		          SELECT @DuplicateCountForNewDocument = COUNT(TR.BillNo) FROM #TempReimbursement TR JOIN #TempCheckDuplicateData TRD 
		                                    ON LOWER(TR.BillNo) = LOWER(TRD.BillNo) AND TR.ReimbursementCategoryId = TRD.ReimbursementCategoryId  
											WHERE TR.Amount = TRD.Amount AND TR.[Date] = TRD.[Date] AND TR.[ReimbursementDetailId] = 0

                  SELECT @DuplicateCountForExistingDocument = COUNT(TR.BillNo) FROM #TempReimbursement TR JOIN #TempCheckDuplicateData TRD 
		                                    ON LOWER(TR.BillNo) = LOWER(TRD.BillNo) AND TR.ReimbursementCategoryId = TRD.ReimbursementCategoryId  
											WHERE TR.Amount = TRD.Amount AND TR.[Date] = TRD.[Date] AND TR.[ReimbursementDetailId] !=0 AND TRD.UserId != @UserId

		          IF(@DuplicateCountForNewDocument > 0 OR @DuplicateCountForExistingDocument > 0)
		          BEGIN
						SET @Result = 3 ----document already exists(duplicate documents)
						SET @NewRequestId = 0
		          END
				  ELSE
				  BEGIN
						 --Deactivate all old form data 
						 UPDATE ReimbursementDetail
						  SET IsActive = 0, Remarks ='Deleted', ModifiedDate = GETDATE(), ModifiedById = @UserId  
						 WHERE ReimbursementRequestId = @ReimbursementRequestId AND IsActive = 1 AND IsDocumentValid = 1
 
					    --update all old form data 
						 UPDATE RD SET
							RD.[ReimbursementCategoryId] = T.[ReimbursementCategoryId],
							RD.BillNo = T.BillNo, RD.Amount = T.Amount,
							RD.[Date] = T.[Date], RD.IsActive = 1, 
							RD.Remarks ='Drafted',
							RD.ModifiedById = @UserId, RD.ModifiedDate =GETDATE()
						  FROM ReimbursementDetail RD
						  INNER JOIN #TempReimbursement T WITH (NOLOCK) 
						  ON RD.ReimbursementDetailId = T.ReimbursementDetailId 
						  WHERE T.ReimbursementDetailId != 0

						 --insert new form data
						 INSERT INTO ReimbursementDetail (ReimbursementRequestId, ReimbursementCategoryId, DocumentName, DocumentPath, BillNo, Amount, [Date]
															,Remarks, CreatedById)
						 SELECT @ReimbursementRequestId, T.[ReimbursementCategoryId],T.ImageName, T.ImagePath, T.BillNo ,T.Amount,T.[Date], 'Drafted',@UserId
						 FROM #TempReimbursement T WITH (NOLOCK)  WHERE T.ReimbursementDetailId =0

						 --update reimbusrement request
						   UPDATE ReimbursementRequest SET [ReimbRequestedAmt] = @ReimbusrementRequestedAmt WHERE ReimbursementRequestId = @ReimbursementRequestId

						 --DECLARE @Count INT  = (SELECT COUNT(ReimbursementDetailId) FROM ReimbursementDetail
						 --           WHERE ReimbursementRequestId = @ReimbursementRequestId AND IsActive = 1 AND IsDocumentValid = 1)

							--		IF(@Count = 0)
							--		BEGIN
							--		UPDATE ReimbursementRequest SET IsActive = 0 , StatusId = (SELECT StatusId FROM ReimbursementStatus WHERE StatusCode = 'CA')
							--		,Remarks ='Cancelled', ModifiedDate = GETDATE() , ModifiedById = @UserId
							--		WHERE ReimbursementRequestId = @ReimbursementRequestId
							--		END
						 SET @Result=1;
	                SET @NewRequestId = @ReimbursementRequestId
                  END
        END
		ELSE --Insert new reimbursement form
		BEGIN
		          SELECT @DuplicateCount = COUNT(TR.BillNo) FROM #TempReimbursement TR JOIN #TempCheckDuplicateData TRD 
		                                    ON LOWER(TR.BillNo) = LOWER(TRD.BillNo) AND TR.ReimbursementCategoryId = TRD.ReimbursementCategoryId  
											WHERE TR.Amount = TRD.Amount AND TR.[Date] = TRD.[Date]
		          IF(@DuplicateCount>0)
		          BEGIN
						SET @Result = 3 ----document already exists(duplicate documents)
						SET @NewRequestId = 0
		          END
                  ELSE
				  BEGIN
						IF((SELECT COUNT(*) FROM ReimbursementRequest RR WHERE RR.UserId = @UserId AND RR.[Month] = @Month
						    AND RR.[Year] = @Year AND RR.StatusId<=7 --referred back
							AND RR.ReimbursementTypeId=@ReimbursementTypeId AND @ReimbursementTypeId = @MonthlyReimbursementTypeId) >= 1)
						BEGIN
							  SET @Result = 2 ----monthly reimbursement for the applied month already exist
							  SET @NewRequestId = 0
						END
						ELSE 
						BEGIN
							DECLARE @StatusId INT
							SELECT @StatusId = StatusId FROM ReimbursementStatus WHERE StatusCode='DF' --1(Draft)
				            -------------------------insert into ReimbursementRequest---------------------
						    INSERT INTO ReimbursementRequest([UserId],[ReimbursementTypeId], [ReimbRequestedAmt], [Month], [Year], [Remarks],[StatusId],[CreatedById])
						           VALUES(@UserId, @ReimbursementTypeId, @ReimbusrementRequestedAmt, @Month, @Year, 'Drafted', @StatusId, @UserId)
					
						    --------------------------insert into ReimbursementDetail--------------------
							 DECLARE @ReimbRequestId BIGINT= SCOPE_IDENTITY();
							 	 	 	 INSERT INTO ReimbursementDetail([ReimbursementRequestId], [ReimbursementCategoryId], [DocumentName], [DocumentPath], [BillNo], [Amount], 
			  						  [Remarks], [Date], [IsDocumentValid], [CreatedById])
						 SELECT @ReimbRequestId, [ReimbursementCategoryId], [ImageName], [ImagePath], [BillNo],
								[Amount],'Drafted', [Date], 1, @UserId FROM #TempReimbursement WITH (NOLOCK) WHERE ReimbursementDetailId = 0
							 SET @Result=1; --successfully inserted
							 SET @NewRequestId = @ReimbRequestId
			            END
			      END
	    END
	SET @Success = @Result;
	SET @NewReimbursementRequestId = @NewRequestId;
COMMIT;
END TRY
BEGIN CATCH
		SET @Success = 0;
	SET @NewReimbursementRequestId = 0;
    IF(@@TRANCOUNT>0)
    ROLLBACK TRANSACTION;
    DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
--Log Error
    EXEC [spInsertErrorLog]
    @ModuleName = 'Reimbursement'
    ,@Source = 'Proc_AddUpdateReimbursementRequest'
    ,@ErrorMessage = @ErrorMessage
    ,@ErrorType = 'SP'
    ,@ReportedByUserId = @UserId
END CATCH 

--select * from ErrorLog order by 1 desc



GO
/****** Object:  StoredProcedure [dbo].[Proc_GetReimbursementList]    Script Date: 10-10-2018 14:40:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetReimbursementList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetReimbursementList] AS' 
END
GO
/***
   Created Date      :     2018-08-24
   Created By        :     Kanchan Kumari
   Purpose           :     To get the applied reimbursement request
   --------------------------------------------------------------------------
   Usage             : Proc_GetReimbursementList @UserId = 2432, @ReimbursementTypeId=1, @Year = 0
   --------------------------------------------------------------------------
***/
ALTER PROC [dbo].[Proc_GetReimbursementList]
(
@UserId INT,
@ReimbursementTypeId INT = 0,
@Year INT = 0
)
AS
BEGIN
	     DECLARE @StartDate DATE, @EndDate DATE;

	    IF(@Year!=0)
	    BEGIN
		     SELECT @StartDate = datefromparts(@Year,4, 1),
			        @EndDate = datefromparts(@Year+1, 3, 31)
	    END
		SELECT RT.ReimbursementTypeName, R.ReimbursementRequestId, R.ReimbApprovedAmt AS ApprovedAmount, R.ReimbRequestedAmt AS RequestedAmount,
			   R.[Month], R.[Year], R.IsActive,
			    CASE WHEN S.StatusCode = 'DF' THEN S.[Status] +' by '+ UR.EmployeeFirstName +' '+UR.EmployeeLastName
				     WHEN S.StatusCode IN('PA','PV') THEN S.[Status] +' with '+ VP.EmployeeFirstName +' '+VP.EmployeeLastName
					 ELSE  S.[Status] +' by '+ VD.EmployeeFirstName + ' ' + VD.EmployeeLastName END AS [Status],
			   CONVERT(VARCHAR(20),R.CreatedDate,106)+' '+FORMAT(R.CreatedDate, 'hh:mm tt') AS CreatedDate,
			   CONVERT(VARCHAR(20),R.SubmittedDate,106)+' '+FORMAT(R.CreatedDate, 'hh:mm tt') AS SubmittedDate,
			   CASE WHEN S.StatusCode = 'DF' THEN  UR.EmployeeFirstName + ' ' + UR.EmployeeLastName + ': ' +  R.[Remarks] 
			        ELSE VD.EmployeeFirstName + ' ' + VD.EmployeeLastName + ': ' +  R.[Remarks] END AS [Remarks],
			   CASE WHEN S.StatusCode IN('SD', 'PA', 'AP', 'PV', 'VD') THEN 1 ELSE 0 END AS IsSubmitted,
			   MT.[MonthYear],
			   S.StatusCode
		FROM ReimbursementRequest R JOIN ReimbursementType RT WITH(NOLOCK) ON  R.ReimbursementTypeId = RT.ReimbursementTypeId
			JOIN ReimbursementStatus S WITH(NOLOCK) ON R.StatusId = S.StatusId 
			LEFT JOIN vwActiveUsers VD WITH(NOLOCK) ON R.ModifiedById = VD.UserId
			LEFT JOIN vwActiveUsers VP WITH(NOLOCK) ON R.NextApproverId = VP.UserId
			JOIN vwActiveUsers UR WITH(NOLOCK) ON R.CreatedById = UR.UserId
			JOIN (SELECT * FROM dbo.[Fun_GetReimbursementMonthYearToViewAndApprove]()) MT 
			             ON MT.[MonthNumber] = R.[Month] AND MT.[Year] = R.[Year]
		WHERE R.UserId = @UserId  				 
		      AND (datefromparts(R.[Year], R.[Month], 1) BETWEEN @StartDate AND @EndDate OR @Year = 0) 
		      AND (R.ReimbursementTypeId = @ReimbursementTypeId OR @ReimbursementTypeId = 0) 
        ORDER BY  R.[Year] DESC, R.[Month] DESC, R.SubmittedDate DESC
END


GO
/****** Object:  StoredProcedure [dbo].[Proc_GetReimbursementListToReview]    Script Date: 10-10-2018 14:40:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetReimbursementListToReview]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_GetReimbursementListToReview] AS' 
END
GO
/***
   Created Date      :     2018-08-24
   Created By        :     Kanchan Kumari
   Purpose           :     To get the applied reimbursement request to review 
   --------------------------------------------------------------------------
   Usage             :
   --------------------------------------------------------------------------
        Proc_GetReimbursementListToReview @LoginUserId = 1108, @Year = 2018, @ReimbursementTypeId=0
***/
ALTER PROC [dbo].[Proc_GetReimbursementListToReview]
(
@LoginUserId INT,
@Year INT = 0,
@ReimbursementTypeId INT = 0
)
AS
BEGIN
	SET FMTONLY OFF;
	   DECLARE @StartDate DATE, @EndDate DATE;

	    IF(@Year!=0)
	    BEGIN
		     SELECT @StartDate = datefromparts(@Year,4, 1),
			        @EndDate = datefromparts(@Year+1, 3, 31)
	    END

	IF OBJECT_ID('tempdb..#TempReimbursementData') IS NOT NULL
	DROP TABLE #TempReimbursementData

	CREATE TABLE #TempReimbursementData
	(
		ReimbursementRequestId INT NOT NULL,
		UserId INT NOT NULL,
		EmployeeName VARCHAR(100),
		ReimbursementTypeName VARCHAR(50),
		Department VARCHAR(100),
		ApprovedAmount DECIMAL(18,2),
		RequestedAmount DECIMAL(18,2),
		StatusId INT,
		StatusCode VARCHAR(5),
		[Status] VARCHAR(100),
		[Remarks] varchar(500),
		SubmittedDate VARCHAR(30),
		MonthYear VARCHAR(100)
	)  
		  INSERT INTO #TempReimbursementData -----fetch pending request
		  SELECT RR.ReimbursementRequestId, RR.UserId, UD.EmployeeName, RT.ReimbursementTypeName, UD.Department,
		         RR.ReimbApprovedAmt AS ApprovedAmount,
				 RR.ReimbRequestedAmt AS RequestedAmount, 
				 RS.StatusId,RS.StatusCode, 
				 CASE WHEN RS.StatusCode IN('PA','PV') THEN RS.[Status] +' with '+ VP.EmployeeFirstName +' '+VP.EmployeeLastName
					  ELSE  RS.[Status] +' by '+ VD.EmployeeFirstName + ' ' + VD.EmployeeLastName END AS [Status],
			     VD.EmployeeFirstName + ' ' + VD.EmployeeLastName + ': ' +  RR.[Remarks] AS [Remarks],
			   CONVERT(VARCHAR(20),RR.SubmittedDate,106)+' '+FORMAT(RR.SubmittedDate, 'hh:mm tt') AS SubmittedDate,
			   MT.[MonthYear] 
		  FROM ReimbursementRequest RR JOIN vwActiveUsers UD ON RR.UserId = UD.UserId 
			   JOIN ReimbursementStatus RS ON RR.StatusId = RS.StatusId 
			   JOIN ReimbursementType RT ON RR.ReimbursementTypeId = RT.ReimbursementTypeId 
			   LEFT JOIN vwActiveUsers VD ON RR.ModifiedById = VD.UserId
			   LEFT JOIN vwActiveUsers VP ON RR.NextApproverId = VP.UserId
			  JOIN (SELECT * FROM dbo.[Fun_GetReimbursementMonthYearToViewAndApprove]()) MT
			             ON MT.[MonthNumber] = RR.[Month] AND MT.[Year] = RR.[Year]
		    WHERE RR.NextApproverId = @LoginUserId  
				 AND (datefromparts(RR.[Year], RR.[Month], 1) BETWEEN @StartDate AND @EndDate OR @Year = 0) 
				 AND (RR.ReimbursementTypeId = @ReimbursementTypeId OR @ReimbursementTypeId = 0)
				 AND RS.StatusCode != 'RB'
				 ORDER BY  RR.[Year] DESC, RR.[Month] DESC, RR.SubmittedDate DESC
				 
			 INSERT INTO #TempReimbursementData -----fetch approved or rejected request or cancelled request
		   	 SELECT RR.ReimbursementRequestId,RR.UserId, UD.EmployeeName, RT.ReimbursementTypeName, UD.Department,
			     RR.ReimbApprovedAmt AS ApprovedAmount,
				 RR.ReimbRequestedAmt AS RequestedAmount, 
				  RS.StatusId,SH.StatusCode,
			      CASE WHEN SH.StatusCode = 'RB' THEN SH.[Status] +' by '+  VH.EmployeeFirstName + ' ' + VH.EmployeeLastName 
				       WHEN ND.UserId IS NULL THEN RS.[Status] +' by '+  VD.EmployeeFirstName + ' ' + VD.EmployeeLastName 
				       ELSE RS.[Status] +' with '+ ND.EmployeeFirstName + ' ' + ND.EmployeeLastName END AS [Status],
				  VD.EmployeeFirstName + ' ' + VD.EmployeeLastName + ': ' +  RR.[Remarks] AS [Remarks],
				  CONVERT(VARCHAR(20),RR.SubmittedDate,106)+' '+FORMAT(RR.SubmittedDate, 'hh:mm tt') AS SubmittedDate,
				    MT.[MonthYear] 
		  FROM ReimbursementRequest RR JOIN vwActiveUsers UD ON RR.UserId = UD.UserId 
			   JOIN ReimbursementStatus RS ON RR.StatusId = RS.StatusId 
			   JOIN ReimbursementType RT ON RR.ReimbursementTypeId = RT.ReimbursementTypeId 
			   LEFT JOIN vwActiveUsers ND ON RR.NextApproverId = ND.UserId
			   LEFT JOIN vwActiveUsers VD ON RR.ModifiedById = VD.UserId
			   JOIN ReimbursementHistory RH ON RR.ReimbursementRequestId = RH.ReimbursementRequestId
			   JOIN vwActiveUsers VH ON RH.CreatedById = VH.UserId 
			   JOIN ReimbursementStatus SH ON RH.StatusId = SH.StatusId
			      JOIN (SELECT * FROM dbo.[Fun_GetReimbursementMonthYearToViewAndApprove]()) MT
			             ON MT.[MonthNumber] = RR.[Month] AND MT.[Year] = RR.[Year]
		  WHERE RH.CreatedById = @LoginUserId  AND RH.CreatedById != RR.UserId				
				AND (datefromparts(RR.[Year], RR.[Month], 1) BETWEEN @StartDate AND @EndDate OR @Year = 0)
				AND (RR.ReimbursementTypeId = @ReimbursementTypeId OR @ReimbursementTypeId = 0)
				AND SH.StatusCode != 'RB'
		  ORDER BY  RR.[Year] DESC, RR.[Month] DESC, RH.CreatedDate DESC

	   SELECT * FROM #TempReimbursementData 
	   GROUP BY  ReimbursementRequestId, EmployeeName, ReimbursementTypeName, Department,
	              StatusId, StatusCode, [Status], [Remarks], SubmittedDate, MonthYear, UserId, ApprovedAmount, RequestedAmount
END

GO
/****** Object:  StoredProcedure [dbo].[Proc_TakeActionOnReimbursementRequest]    Script Date: 10-10-2018 14:40:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TakeActionOnReimbursementRequest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_TakeActionOnReimbursementRequest] AS' 
END
GO
/***
   Created Date      :     2018-08-24
   Created By        :     Kanchan Kumari
   Purpose           :     To take action on Reimbursement Request
   --------------------------------------------------------------------------
   Usage             :
   --------------------------------------------------------------------------
         DECLARE @result INT
         EXEC [dbo].[Proc_TakeActionOnReimbursementRequest]
		   @ReimbursementRequestId = 20
          ,@ReimbursementDetailId = 0
          ,@ReimbApprovedAmt = 980.00,
		  ,@ActionType = 'AP'
		  ,@Remarks = 'ok'
		  ,@ReimbursementTypeId = 2
		  ,@LoginUserId = 2166
		  ,@Success = @result output
		  SELECT @result AS RESULT
***/
ALTER PROC [dbo].[Proc_TakeActionOnReimbursementRequest]
(
@ReimbursementRequestId INT,
@ReimbursementDetailId INT,
@ReimbApprovedAmt DECIMAL(18,2),
@ActionType VARCHAR(10),
@Remarks VARCHAR(500),
@ReimbursementTypeId INT,
@LoginUserId INT,
@Success tinyint = 0 output
)
AS
BEGIN TRY
	BEGIN TRANSACTION
	       DECLARE @ReimbursementTypeName VARCHAR(10) = (SELECT ReimbursementTypeName FROM ReimbursementType 
		            WHERE ReimbursementTypeId = @ReimbursementTypeId),
			@StatusId INT= (SELECT StatusId FROM ReimbursementStatus WHERE StatusCode  = @ActionType), 
			@Result INT, @AccountantId INT = (SELECT UserId FROM [dbo].[Fun_GetAccountApproverId]()),
			@UserId INT = (SELECT UserId FROM ReimbursementRequest WHERE ReimbursementRequestId = @ReimbursementRequestId)
            DECLARE @FirstRMId INT = (SELECT [dbo].[fnGetReportingManagerByUserId](@UserId)),
			@DepartmentHeadId INT = (SELECT [dbo].[fnGetDepartmentHeadIdByUserId](@UserId))

	IF(@ActionType = 'INVALID') --mark invalid
	BEGIN      
	          UPDATE ReimbursementDetail SET Remarks = @Remarks, IsDocumentValid = 0,
				     ModifiedById = @LoginUserId, ModifiedDate = GETDATE()
		             WHERE  ReimbursementDetailId = @ReimbursementDetailId AND IsActive = 1 AND IsDocumentValid = 1
               DECLARE @Count INT 
			   SELECT @Count = Count(ReimbursementDetailId) FROM ReimbursementDetail WHERE ReimbursementRequestId = @ReimbursementRequestId 
			                                  AND IsActive = 1 AND IsDocumentValid = 1
              IF(@Count = 0)--if valid count 0 then request will get rejected
			  BEGIN
			         SELECT @StatusId = StatusId FROM ReimbursementStatus WHERE StatusCode  = 'RJ'

			         UPDATE ReimbursementRequest SET ReimbApprovedAmt = 0.00, NextApproverId = null, StatusId = @StatusId,
		             Remarks = @Remarks, ModifiedDate = GETDATE(), ModifiedById = @LoginUserId
		             WHERE ReimbursementRequestId = @ReimbursementRequestId AND IsActive = 1
       
		             INSERT INTO ReimbursementHistory (ReimbursementRequestId, StatusId, Remarks, CreatedDate, CreatedById)
		             VALUES(@ReimbursementRequestId, @StatusId, @Remarks, GETDATE(), @LoginUserId)
			 END
			SET @Result = 1;
	END
	ELSE IF(@ActionType = 'RB') --refer back
	BEGIN
	       UPDATE ReimbursementRequest SET 
		   ReimbApprovedAmt = @ReimbApprovedAmt,
		   NextApproverId = null, IsReferredBack = 1,
		   StatusId = @StatusId,
		   Remarks = @Remarks, ModifiedDate = GETDATE(), ModifiedById = @LoginUserId
		   WHERE ReimbursementRequestId = @ReimbursementRequestId AND IsActive = 1
       
	       -- UPDATE ReimbursementDetail SET Remarks = @Remarks, 
				    -- ModifiedById = @LoginUserId, ModifiedDate = GETDATE()
		      --WHERE  ReimbursementRequestId = @ReimbursementRequestId AND IsActive = 1 AND IsDocumentValid = 1 --to update remarks

		   INSERT INTO ReimbursementHistory (ReimbursementRequestId, StatusId, Remarks, CreatedDate, CreatedById)
		   VALUES(@ReimbursementRequestId, @StatusId, @Remarks, GETDATE(), @LoginUserId)
		   SET @Result = 1;
	END
	ELSE IF(@ActionType = 'RJ')--reject
	BEGIN
		   UPDATE ReimbursementRequest SET ReimbApprovedAmt = @ReimbApprovedAmt, NextApproverId = null, StatusId = @StatusId,
		   Remarks = @Remarks, ModifiedDate = GETDATE(), ModifiedById = @LoginUserId
		   WHERE ReimbursementRequestId = @ReimbursementRequestId AND IsActive = 1

		   --UPDATE ReimbursementDetail SET  Remarks = @Remarks, 
				 -- ModifiedById = @LoginUserId , ModifiedDate = GETDATE()
				 -- WHERE ReimbursementRequestId = @ReimbursementRequestId AND IsActive = 1 AND IsDocumentValid = 1
       
		   INSERT INTO ReimbursementHistory (ReimbursementRequestId, StatusId, Remarks, CreatedDate, CreatedById)
		   VALUES(@ReimbursementRequestId, @StatusId, @Remarks, GETDATE(), @LoginUserId)
		   SET @Result = 1;
	END
	ELSE IF(@ActionType = 'AP')--approve
	BEGIN
	      IF(@ReimbursementTypeName = 'Monthly')
		  BEGIN
		        SELECT @StatusId = StatusId FROM ReimbursementStatus WHERE StatusCode = 'VD'
			   UPDATE ReimbursementRequest SET ReimbApprovedAmt = @ReimbApprovedAmt, NextApproverId = null, StatusId = @StatusId,
			   Remarks = @Remarks, ModifiedDate = GETDATE(), ModifiedById = @LoginUserId
			   WHERE ReimbursementRequestId = @ReimbursementRequestId AND IsActive = 1 

			   --UPDATE ReimbursementDetail SET Remarks = @Remarks,
					 -- ModifiedById = @LoginUserId , ModifiedDate = GETDATE()
					 -- WHERE ReimbursementRequestId = @ReimbursementRequestId AND IsActive = 1 AND IsDocumentValid = 1
       
			   INSERT INTO ReimbursementHistory (ReimbursementRequestId, StatusId, Remarks, CreatedDate, CreatedById)
			   VALUES(@ReimbursementRequestId, @StatusId, @Remarks, GETDATE(), @LoginUserId)
			   SET @Result = 1;
		  END
		  ELSE
		  BEGIN
		       IF(@LoginUserId = @FirstRMId)
			   BEGIN
						  IF(@DepartmentHeadId = 0)
						  BEGIN
						  SET @DepartmentHeadId = @AccountantId
							  SELECT @StatusId  = StatusId FROM ReimbursementStatus WHERE StatusCode = 'PV'
						  END
						  ELSE
						  BEGIN
							  SELECT @StatusId  = StatusId FROM ReimbursementStatus WHERE StatusCode = 'PA'
						  END
				   UPDATE ReimbursementRequest SET ReimbApprovedAmt = @ReimbApprovedAmt, NextApproverId = @DepartmentHeadId, StatusId = @StatusId,
				   Remarks = @Remarks, ModifiedDate = GETDATE(), ModifiedById = @LoginUserId
				   WHERE ReimbursementRequestId = @ReimbursementRequestId AND IsActive = 1

				   --UPDATE ReimbursementDetail SET Remarks = @Remarks, 
						 -- ModifiedById = @LoginUserId , ModifiedDate = GETDATE()
						 -- WHERE ReimbursementRequestId = @ReimbursementRequestId AND IsActive = 1 AND IsDocumentValid = 1
       
				   INSERT INTO ReimbursementHistory (ReimbursementRequestId, StatusId, Remarks, CreatedDate, CreatedById)
				   VALUES(@ReimbursementRequestId, (SELECT StatusId FROM ReimbursementStatus WHERE StatusCode = 'AP'),
							  @Remarks, GETDATE(), @LoginUserId)
				   SET @Result = 1;
			   END
			   ELSE IF(@LoginUserId = @DepartmentHeadId AND @DepartmentHeadId != @AccountantId)
			   BEGIN
					   SELECT @StatusId  = StatusId FROM ReimbursementStatus WHERE StatusCode = 'PV'

					   UPDATE ReimbursementRequest SET ReimbApprovedAmt = @ReimbApprovedAmt, NextApproverId = @AccountantId, StatusId = @StatusId,
					   Remarks = @Remarks, ModifiedDate = GETDATE(), ModifiedById = @LoginUserId
					   WHERE ReimbursementRequestId = @ReimbursementRequestId AND IsActive = 1

					   --UPDATE ReimbursementDetail SET Remarks = @Remarks, 
							 -- ModifiedById = @LoginUserId , ModifiedDate = GETDATE()
							 -- WHERE ReimbursementRequestId = @ReimbursementRequestId AND IsActive = 1 AND IsDocumentValid = 1
       
					   INSERT INTO ReimbursementHistory (ReimbursementRequestId, StatusId, Remarks, CreatedDate, CreatedById)
					   VALUES(@ReimbursementRequestId, (SELECT StatusId FROM ReimbursementStatus WHERE StatusCode = 'AP'),
								  @Remarks, GETDATE(), @LoginUserId)
					   SET @Result = 1;
			   END
			    ELSE IF(@LoginUserId = @AccountantId OR (@LoginUserId = @DepartmentHeadId AND @DepartmentHeadId = @AccountantId))
			    BEGIN
				   SELECT @StatusId  = StatusId FROM ReimbursementStatus WHERE StatusCode = 'VD'

				   UPDATE ReimbursementRequest SET ReimbApprovedAmt = @ReimbApprovedAmt, NextApproverId = null, StatusId = @StatusId,
				   Remarks = @Remarks, ModifiedDate = GETDATE(), ModifiedById = @LoginUserId
				   WHERE ReimbursementRequestId = @ReimbursementRequestId AND IsActive = 1

				   --UPDATE ReimbursementDetail SET Remarks = @Remarks, 
						 -- ModifiedById = @LoginUserId , ModifiedDate = GETDATE()
						 -- WHERE ReimbursementRequestId = @ReimbursementRequestId AND IsActive = 1 AND IsDocumentValid = 1
       
				   INSERT INTO ReimbursementHistory (ReimbursementRequestId, StatusId, Remarks, CreatedDate, CreatedById)
				   VALUES(@ReimbursementRequestId, @StatusId, @Remarks, GETDATE(), @LoginUserId)
				   SET @Result = 1;
			   END

		  END
	END
	COMMIT;
	SET @Success = @Result
END TRY
BEGIN CATCH
    SET @Success=0
    IF @@TRANCOUNT>0
	ROLLBACK TRANSACTION
	DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
        EXEC [spInsertErrorLog]
	        @ModuleName = 'Reimbursement'
        ,@Source = '[Proc_TakeActionOnReimbursementRequest]'
        ,@ErrorMessage = @ErrorMessage
        ,@ErrorType = 'SP'
        ,@ReportedByUserId = @LoginUserId
END CATCH

GO
