GO
/****** Object:  StoredProcedure [dbo].[Proc_PromoteUsers]    Script Date: 04-10-2018 14:45:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_PromoteUsers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_PromoteUsers]
GO
/****** Object:  StoredProcedure [dbo].[Proc_AddTraining]    Script Date: 04-10-2018 14:45:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddTraining]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AddTraining]
GO
/****** Object:  StoredProcedure [dbo].[Proc_AddTraining]    Script Date: 04-10-2018 14:45:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddTraining]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_AddTraining] AS' 
END
GO
/***
   Created Date      :     2018-09-05
   Created By        :     Mimansa Agrawal
   Purpose           :     This procedure adds training sessions by HR 
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
DECLARE @Result int
EXEC Proc_AddTraining
@Title='Finance'
@Description=Finance,
@TentativeDate='',
@FromDate='',
@EndDate='',
@Document='',
@UserId='',
@Success = @Result output
SELECT @Result AS [RESULT]
**/
ALTER PROCEDURE [dbo].[Proc_AddTraining]
(
@Title VARCHAR(1000),
@Description VARCHAR(2000),
@TentativeDate DATE,
@FromDate DATE,
@EndDate DATE,
@Document VARCHAR(500),
@UserId INT,
@Success TINYINT = 0 OUTPUT 
)
AS
BEGIN TRY
IF EXISTS(SELECT 1 FROM [dbo].[Training] WHERE [Title] = @Title AND [TentativeDate]=@TentativeDate) -- check if already exists
		BEGIN
			 SET @Success=2 --already exists
		END
ELSE 
BEGIN
BEGIN TRANSACTION
INSERT INTO [dbo].[Training]([Title],[Description],[TentativeDate],[NominationStartDate],[NominationEndDate],[CreatedBy])
SELECT @Title,@Description,@TentativeDate,@FromDate,@EndDate,@UserId
IF (@Document!='' OR @Document!=NULL)
BEGIN
UPDATE [dbo].[Training] 
SET Document=@Document,IsDocumented=1 WHERE [Title] = @Title AND [TentativeDate]=@TentativeDate
END
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
			 @ModuleName = 'HRPortal'
			,@Source = 'Proc_AddTraining'
			,@ErrorMessage = @ErrorMessage
			,@ErrorType = 'SP'
			,@ReportedByUserId = @UserId
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[Proc_PromoteUsers]    Script Date: 04-10-2018 14:45:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_PromoteUsers]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_PromoteUsers] AS' 
END
GO
/***
   Created Date      :     2018-08-08
   Created By        :     Mimansa Agrawal
   Purpose           :     This stored proc is used to promote employees
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
   --- Test Case 1
   DECLARE @Result int 
         EXEC [dbo].[Proc_PromoteUsers]
         @EmployeeId=2434
		,@NewDesignationId=3
        ,@PromotionDate='2018-08-08'
	    ,@NewEmpCode='GSI G 111'
        ,@UserId=1108
        ,@Success = @Result output
	    SELECT @Result AS [RESULT]
   ***/
ALTER PROCEDURE [dbo].[Proc_PromoteUsers]
(
	@EmployeeId INT,
	@NewDesignationId INT,
	@PromotionDate DATE,
	@NewEmpCode VARCHAR(100),
	@UserId INT,
	@Success tinyint = 0 output
)
AS
BEGIN TRY
SET NOCOUNT ON;
IF EXISTS(SELECT 1 FROM [dbo].[UserDetail] WHERE [EmployeeId] = @NewEmpCode AND [UserId]!=@EmployeeId) -- check if already exists
		BEGIN
			 SET @Success=4 --this employeecode already exists
		END
ELSE
BEGIN
BEGIN TRANSACTION
	DECLARE @OldDesignationId INT,@OldIsIntern BIT,@NewIsIntern BIT,@CLCount INT,@CurrentMonth INT,@OldEmpCode VARCHAR(50)
	SELECT @OldDesignationId=[DesignationId],@OldEmpCode=[EmployeeId] FROM [dbo].[UserDetail] WHERE [UserId]=@EmployeeId
	SET @OldIsIntern=(SELECT [IsIntern] FROM [dbo].[Designation] WHERE [DesignationId]=@OldDesignationId)
	SELECT @NewIsIntern=[IsIntern] FROM [dbo].[Designation] WHERE [DesignationId]=@NewDesignationId
	SET @CurrentMonth=(SELECT DATEPART(mm, GETDATE()))
	DECLARE @CurrentYear INT=(SELECT DATEPART(YYYY, GETDATE()))
	DECLARE @PYear INT=(SELECT DATEPART(YYYY, @PromotionDate))
	IF(@NewDesignationId=@OldDesignationId)
	BEGIN
	SET @Success=3     ------------------old and new designations can't be same
	END
	-------------update users details for interns promoted to non interns------------------
	ELSE IF(@OldIsIntern=1 AND @NewIsIntern=0)
	BEGIN
	 DECLARE @PDate int = (SELECT DATEPART(dd, @PromotionDate))
				DECLARE @PMonth int = (SELECT DATEPART(mm, @PromotionDate))         
				SET @CLCount = CASE
								  WHEN @PMonth BETWEEN 4 AND 12 THEN (16 - @PMonth)
								  ELSE (4 - @PMonth)
							   END
				IF(@PDate > 10)
				   SET @CLCount = @CLCount - 1
	--------------------insert into leave balance history------------------------
	  INSERT INTO [dbo].[LeaveBalanceHistory]
			 (
				[RecordId],[Count],[CreatedDate],[CreatedBy]
			 )
			  SELECT B.[RecordId], B.[Count], GETDATE(), @UserId
			 FROM [dbo].[UserDetail] U WITH (NOLOCK)
			 INNER JOIN [dbo].[LeaveBalance] B WITH (NOLOCK) ON B.[UserId] = U.[UserId] 
			 INNER JOIN [dbo].[LeaveTypeMaster] T WITH (NOLOCK) ON T.[TypeId]=B.[LeaveTypeId]
			 INNER JOIN [dbo].[Designation] D WITH (NOLOCK) ON D.[DesignationId] = U.[DesignationId] AND D.[IsIntern]=1
			 WHERE
				ISNULL(U.[TerminateDate], '2999-12-31') > GETDATE()
				AND U.[UserId]=@EmployeeId
	------------------update CLT balance to zero--------------
		UPDATE [dbo].[LeaveBalance]
		SET [Count]=0,
		[LastModifiedDate]=GETDATE(),
		[LastModifiedBy]=@UserId
		WHERE [UserId]=@EmployeeId AND [LeaveTypeId]=9
	--------------update CL for interns turning non interns--------------
		UPDATE [dbo].[LeaveBalance]
		SET [Count]=@CLCount,
		[LastModifiedDate]=GETDATE(),
		[LastModifiedBy]=@UserId
		WHERE [UserId]=@EmployeeId AND [LeaveTypeId]=1		
	----------------update PL----------
		UPDATE [dbo].[LeaveBalance]
		SET [Count]=CASE
		WHEN @PDate > 15 AND @CurrentYear=@PYear  THEN  @CurrentMonth-@PMonth
		WHEN @PDate > 15 AND @CurrentYear!=@PYear  THEN 12 + @CurrentMonth-@PMonth
		WHEN @PDate <= 15 AND @CurrentYear!=@PYear  THEN 13 + @CurrentMonth-@PMonth
		ELSE @CurrentMonth-@PMonth+1 
		END,
		[LastModifiedDate]=GETDATE(),
		[LastModifiedBy]=@UserId
		WHERE [UserId]=@EmployeeId AND [LeaveTypeId]=2
	---------------update 5CLOY flag-----------
		UPDATE [dbo].[LeaveBalance]
		SET [Count]=1,
		[LastModifiedDate]=GETDATE(),
		[LastModifiedBy]=@UserId
		WHERE [UserId]=@EmployeeId AND [LeaveTypeId]=8
	--------------------update userdetail table for interns--------------		
		UPDATE [dbo].[UserDetail]
		SET [DesignationId]=@NewDesignationId,
		[EmployeeId]=@NewEmpCode,
		[LastModifiedBy]=@UserId,
		[LastModifiedDate]=GETDATE()
		WHERE [UserId]=@EmployeeId
		------------------update user table for interns to non-interns-------------
		UPDATE [dbo].[User]
		SET [RoleId]=(SELECT RoleId From [dbo].[Role] WHERE UPPER(RoleName)='USER'),
		[LastModifiedBy]=@UserId,
		[LastModifiedDate]=GETDATE()
		WHERE [UserId]=@EmployeeId
	----------- insert into user promotion history table----------
		INSERT INTO [dbo].[UserPromotionHistory]
		([UserId],[OldDesignationId],[NewDesignationId],[PromotionDate],[CreatedBy],[OldEmployeeCode],[NewEmployeeCode])
		VALUES
		(@EmployeeId,@OldDesignationId,@NewDesignationId,@PromotionDate,@UserId,@OldEmpCode,@NewEmpCode)
		SET @Success=2 ------------interns promoted successfully
	END
	ELSE
	BEGIN
	------------update user detail for rest cases-----------
		UPDATE [dbo].[UserDetail]
		SET [DesignationId]=@NewDesignationId,
		[EmployeeId]=@NewEmpCode,
		[LastModifiedBy]=@UserId,
		[LastModifiedDate]=GETDATE()
		WHERE [UserId]=@EmployeeId
	----------- insert into user promotion history table----------
		INSERT INTO [dbo].[UserPromotionHistory]
		([UserId],[OldDesignationId],[NewDesignationId],[PromotionDate],[CreatedBy],[OldEmployeeCode],[NewEmployeeCode])
		VALUES
		(@EmployeeId,@OldDesignationId,@NewDesignationId,@PromotionDate,@UserId,@OldEmpCode,@NewEmpCode)
		SET @Success=1 -----------------------other users promoted successfully
	END
COMMIT TRANSACTION
END
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0
	  BEGIN
         ROLLBACK TRANSACTION;
	  END
     SET @Success=0 ------------------error occured 
DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
	EXEC [spInsertErrorLog]
	     @ModuleName = 'UserManagement'
        ,@Source = 'Proc_PromoteUsers'
        ,@ErrorMessage = @ErrorMessage
        ,@ErrorType = 'SP'
        ,@ReportedByUserId = @UserId       
	END CATCH
GO
-------------------altered training table--------------
ALTER TABLE Training
ADD Document Varchar(500) NULL

ALTER TABLE Training 
Add IsDocumented BIT DEFAULT(0) NOT NULL
------------------email template for pending approvals----------
insert into emailtemplates(TemplateName,Template,IsHTML,CreatedBy)
values ('Pending Approvals','<html xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office"><head> <title></title> <meta http-equiv="X-UA-Compatible" content="IE=edge"> <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"> <style type="text/css"> #outlook a{padding: 0;}.ReadMsgBody{width: 100%;}.ExternalClass{width: 100%;}.ExternalClass *{line-height: 100%;}body{margin: 0; padding: 0; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%;}table, td{border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt;}img{border: 0; height: auto; line-height: 100%; outline: none; text-decoration: none; -ms-interpolation-mode: bicubic;}p{display: block; margin: 13px 0;}</style> <style type="text/css"> @media only screen and (max-width:480px){@-ms-viewport{width: 320px;}@viewport{width: 320px;}}</style><!--[if mso]> <xml> <o:OfficeDocumentSettings> <o:AllowPNG/> <o:PixelsPerInch>96</o:PixelsPerInch> </o:OfficeDocumentSettings> </xml><![endif]--><!--[if lte mso 11]> <style type="text/css"> .outlook-group-fix{width:100% !important;}</style><![endif]--> <style type="text/css"> @media only screen and (min-width:480px){.mj-column-per-100{width: 100% !important;}}</style></head><body> <div><!--[if mso | IE]> <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="600" align="center" style="width:600px;"> <tr> <td style="line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]--> <div style="margin:0px auto;max-width:600px;"> <table role="presentation" cellpadding="0" cellspacing="0" style="font-size:0px;width:100%;" align="center" border="0"> <tbody> <tr> <td style="text-align:center;vertical-align:top;direction:ltr;font-size:0px;padding:20px 0px;padding-bottom:24px;padding-top:0px;"></td></tr></tbody> </table> </div><!--[if mso | IE]> </td></tr></table><![endif]--><!--[if mso | IE]> <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="600" align="center" style="width:600px;"> <tr> <td style="line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]--> <div style="margin:0px auto;max-width:900px;background:#d8e2e7;"> <table role="presentation" cellpadding="0" cellspacing="0" style="font-size:0px;width:100%;background:#d8e2e7;" align="center" border="0"> <tbody> <tr> <td style="text-align:center;vertical-align:top;direction:ltr;font-size:0px;padding:20px 0px;"><!--[if mso | IE]> <table role="presentation" border="0" cellpadding="0" cellspacing="0"> <tr> <td style="vertical-align:top;width:600px;"><![endif]--> <div class="mj-column-per-100 outlook-group-fix" style="vertical-align:top;display:inline-block;direction:ltr;font-size:13px;text-align:left;width:100%;"> <table role="presentation" cellpadding="0" cellspacing="0" width="100%" border="0"> <tbody> <tr> <td style="word-break:break-word;font-size:0px;padding:0px;" align="center"> <div class="" style="cursor:auto;color:#000000;font-family:Proxima Nova, Arial, Arial, Helvetica, sans-serif;font-size:16px;line-height:22px;text-align:center;text-transform:uppercase;">[Title]</div></td></tr></tbody> </table> </div><!--[if mso | IE]> </td></tr></table><![endif]--> </td></tr></tbody> </table> </div><!--[if mso | IE]> </td></tr></table><![endif]--><!--[if mso | IE]> <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="600" align="center" style="width:600px;"> <tr> <td style="line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]--> <div style="margin:0px auto;max-width:900px;background:#d8e2e7;"> <table role="presentation" cellpadding="0" cellspacing="0" style="font-size:0px;width:100%;background:#d8e2e7;" align="center" border="0"> <tbody> <tr> <td style="text-align:center;vertical-align:top;direction:ltr;font-size:0px;padding:0px 1px 1px;"><!--[if mso | IE]> <table role="presentation" border="0" cellpadding="0" cellspacing="0"> <tr> <td style="vertical-align:top;width:600px;"><![endif]--> <div class="mj-column-per-100 outlook-group-fix" style="vertical-align:top;display:inline-block;direction:ltr;font-size:13px;text-align:left;width:100%;"> <table role="presentation" cellpadding="0" cellspacing="0" style="background:white;" width="100%" border="0"> <tbody> <tr> <td style="word-break:break-word;font-size:0px;padding:15px 30px 6px;" align="left"> <div class="" style="cursor:auto;color:#000000;font-family:Proxima Nova, Arial, Arial, Helvetica, sans-serif;font-size:15px;line-height:22px;text-align:left;">Dear [Name],</div></td></tr><tr> <td style="word-break:break-word;font-size:0px;padding:15px 30px 5px;" align="left"> <div class="" style="cursor:auto;color:#000000;font-family:Proxima Nova, Arial, Arial, Helvetica, sans-serif;font-size:14px;line-height:22px;text-align:left;">[Line1] </div></td></tr><tr> <td style="word-break:break-word;font-size:0px;padding:15px 30px 5px;" align="left"> <div class="" style="cursor:auto;color:#000000;font-family:Proxima Nova, Arial, Arial, Helvetica, sans-serif;font-size:14px;line-height:22px;text-align:left;">[Data] </div></td></tr><tr> <td style="word-break:break-word;font-size:0px;padding:15px 30px 0px;" align="left"> <div class="" style="cursor:auto;color:#607D8B;font-family:Proxima Nova, Arial, Arial, Helvetica, sans-serif;font-size:15px;line-height:22px;text-align:left;">Regards,</div></td></tr><tr> <td style="word-break:break-word;font-size:0px;padding:0px 30px 10px;" align="left"> <div class="" style="cursor:auto;color:#607D8B;font-family:Proxima Nova, Arial, Arial, Helvetica, sans-serif;font-size:15px;line-height:22px;text-align:left;">HR Department</div></td></tr><tr> <td style="word-break:break-word;font-size:0px;padding:10px 25px;"> <p style="font-size:1px;margin:0px auto;border-top:1px solid #eee;width:100%;"></p></td></tr><tr> <td style="word-break:break-word;font-size:0px;padding:15px 30px 6px;" align="left"> <div class="" style="cursor:auto;color:#607D8B;font-family:Proxima Nova, Arial, Arial, Helvetica, sans-serif;font-size:12px;line-height:22px;text-align:left;">If you are having trouble or questions please send an email to misteam@geminisolutions.in or contact to MIS team.</div></td></tr></tbody> </table> </div><!--[if mso | IE]> </td></tr></table><![endif]--> </td></tr></tbody> </table> </div><!--[if mso | IE]> </td></tr></table><![endif]--><!--[if mso | IE]> <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="600" align="center" style="width:600px;"> <tr> <td style="line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]--> <div style="margin:0px auto;max-width:600px;"> <table role="presentation" cellpadding="0" cellspacing="0" style="font-size:0px;width:100%;" align="center" border="0"> <tbody> <tr> <td style="text-align:center;vertical-align:top;direction:ltr;font-size:0px;padding:10px 0px;"><!--[if mso | IE]> <table role="presentation" border="0" cellpadding="0" cellspacing="0"> <tr> <td style="vertical-align:top;width:600px;"><![endif]--> <div class="mj-column-per-100 outlook-group-fix" style="vertical-align:top;display:inline-block;direction:ltr;font-size:13px;text-align:left;width:100%;"> <table role="presentation" cellpadding="0" cellspacing="0" width="100%" border="0"> <tbody> <tr> <td style="word-break:break-word;font-size:0px;padding:0px;" align="center"> <div class="" style="cursor:auto;color:#607D8B;font-family:Proxima Nova, Arial, Arial, Helvetica, sans-serif;font-size:13px;line-height:22px;text-align:center;"> <a href="http://geminisolutions.in" style="text-decoration: none; color: inherit;"> <span style="border-bottom: dotted 1px #b3bac1">Gemini Solutions Pvt. Ltd.</span> </a> | All Rights Reserved</div></td></tr></tbody> </table> </div><!--[if mso | IE]> </td></tr></table><![endif]--> </td></tr></tbody> </table> </div><!--[if mso | IE]> </td></tr></table><![endif]--><!--[if mso | IE]> <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="600" align="center" style="width:600px;"> <tr> <td style="line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]--> <div style="margin:0px auto;max-width:600px;"> <table role="presentation" cellpadding="0" cellspacing="0" style="font-size:0px;width:100%;" align="center" border="0"> <tbody> <tr> <td style="text-align:center;vertical-align:top;direction:ltr;font-size:0px;padding:20px 0px;padding-bottom:24px;padding-top:0px;"></td></tr></tbody> </table> </div><!--[if mso | IE]> </td></tr></table><![endif]--> </div></body></html>',1,2434)