-------------add columns in table---------------
ALTER TABLE TempCardIssueDetail
ADD IsActive Bit NOT NULL DEFAULT (1) 
ALTER TABLE TempCardIssueDetail
ADD ModifiedDate DATETIME NULL 
ALTER TABLE TempCardIssueDetail
ADD ModifiedBy INT NULL 
----------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectTempCardDetailsForMIS]    Script Date: 11-03-2019 15:45:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SelectTempCardDetailsForMIS]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SelectTempCardDetailsForMIS]
GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectIssuedTempCardDetails]    Script Date: 11-03-2019 15:45:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SelectIssuedTempCardDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SelectIssuedTempCardDetails]
GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertTempCardIssueDetails]    Script Date: 11-03-2019 15:45:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_InsertTempCardIssueDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_InsertTempCardIssueDetails]
GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertTempCardIssueDetails]    Script Date: 11-03-2019 15:45:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_InsertTempCardIssueDetails]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_InsertTempCardIssueDetails] AS' 
END
GO
-- =============================================
-- Author       :   CHANDRA PRAKASH
-- ALTER date	:   5 OCT 2016
-- Description  :   INSERT Temp card Details
-- exec [dbo].[Proc_InsertTempCardIssueDetails]
-- =============================================
ALTER PROCEDURE [dbo].[Proc_InsertTempCardIssueDetails]
@EmployeeId int,
@AccessCardId int,
@Reason nvarchar(500),
@Succes tinyint output
AS
BEGIN
 
INSERT INTO [dbo].[TempCardIssueDetail]
                       (
                          [EmployeeId]
						 ,[AccessCardId]
                         ,[IssueDate]
                         ,[Reason]
						 ,[IsActive]
                       )
     VALUES
           (@EmployeeId,@AccessCardId,Getdate(),@Reason,1)
            SET @Succes=1;
 
END




GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectIssuedTempCardDetails]    Script Date: 11-03-2019 15:45:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SelectIssuedTempCardDetails]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_SelectIssuedTempCardDetails] AS' 
END
GO
-- =============================================
-- Author       :   CHANDRA PRAKASH
-- ALTER date	:   5 OCT 2016
-- Description  :   INSERT Temp card Details
-- exec [dbo].[Proc_SelectIssuedTempCardDetails] 
-- =============================================
ALTER PROCEDURE [dbo].[Proc_SelectIssuedTempCardDetails] 

AS
BEGIN
SELECT     
      [IssueId]
	 ,[TCID].[EmployeeId]
	 ,UD.[FirstName] + ' ' + UD.[LastName] as [EmpName]
	 ,TCID.[AccessCardId]
	 ,AC.[AccessCardNo]
	 ,convert(varchar,[IssueDate],20) as [IssueDate]
	 ,[Reason]
 FROM [dbo].[TempCardIssueDetail] TCID 
 left join [dbo].[AccessCard] AC on TCID.AccessCardId= AC.AccessCardId
 left join [dbo].[UserDetail] UD on TCID.EmployeeId=UD.UserId
 WHERE IsReturn=0 AND TCID.[IsActive]=1
END




GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectTempCardDetailsForMIS]    Script Date: 11-03-2019 15:45:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SelectTempCardDetailsForMIS]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_SelectTempCardDetailsForMIS] AS' 
END
GO
-- =============================================
-- Author        :		 CHANDRA PRAKASH
-- ALTER date	 :		 30 March 2016
-- Description	 :       SELECT Temp Card Details
--- EXEC [dbo].[Proc_SelectTempCardDetailsForMIS]  '01-Apr-2016','15-Apr-2017'
-- =============================================
ALTER PROCEDURE [dbo].[Proc_SelectTempCardDetailsForMIS] 
@From [Date] =null, 
@To [Date] =null
AS
BEGIN
SET NOCOUNT ON;
SELECT [IssueId]
	  ,LTRIM(RTRIM(REPLACE(REPLACE(REPLACE((UD.[FirstName] + ' ' + UD.[MiddleName] + ' ' + UD.[LastName]), ' ', '{}'), '}{',''), '{}', ' '))) [EmployeeName]
      ,ac.[AccessCardNo]
      ,[IssueDate]
      ,[ReturnDate]
      ,[Reason]
      ,[IsReturn]
  FROM [dbo].[TempCardIssueDetail] vd 
  join [dbo].[UserDetail] ud on vd.EmployeeId = ud.UserId
  join [dbo].[AccessCard] ac on vd.AccessCardId=ac.AccessCardId
  WHERE CONVERT(DATE, vd.[IssueDate], 106)   >=CONVERT(DATE,  isnull(@From,getdate()), 106) and  CONVERT(DATE, vd.[IssueDate], 106)   <= CONVERT(DATE,  isnull(@To,getdate()), 106) AND vd.IsActive=1
END




GO
