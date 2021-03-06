GO
/****** Object:  StoredProcedure [dbo].[Proc_ForwardReferees]    Script Date: 04-09-2018 12:46:33 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_ForwardReferees]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_ForwardReferees]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__ReferralR__Refer__0E1B8309]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReferralReview]'))
ALTER TABLE [dbo].[ReferralReview] DROP CONSTRAINT [FK__ReferralR__Refer__0E1B8309]
GO
/****** Object:  Table [dbo].[ReferralReview]    Script Date: 04-09-2018 12:46:33 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReferralReview]') AND type in (N'U'))
DROP TABLE [dbo].[ReferralReview]
GO
/****** Object:  Table [dbo].[ReferralReview]    Script Date: 04-09-2018 12:46:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReferralReview]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ReferralReview](
	[ReferralReviewId] [int] IDENTITY(1,1) NOT NULL,
	[ReferralDetailId] [int] NOT NULL,
	[ForwardedToId] [int] NOT NULL,
	[CommentsByReviewer] [varchar](500) NULL,
	[ReferredById] [int] NOT NULL,
	[IsRelevant] [int] NULL,
	[Message] [varchar](500) NOT NULL,
	[CreatedDate] [datetime] NOT NULL DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[LastModifiedBy] [int] NULL,
	[LastModifiedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ReferralReviewId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__ReferralR__Refer__0E1B8309]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReferralReview]'))
ALTER TABLE [dbo].[ReferralReview]  WITH CHECK ADD FOREIGN KEY([ReferralDetailId])
REFERENCES [dbo].[ReferralDetail] ([ReferralDetailId])
GO
/****** Object:  StoredProcedure [dbo].[Proc_ForwardReferees]    Script Date: 04-09-2018 12:46:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_ForwardReferees]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_ForwardReferees] AS' 
END
GO
/**
Created Date      :     2018-08-22
Created By        :     Mimansa Agrawal
Purpose           :     This stored procedure is used to forward referees
Change History    :
--------------------------------------------------------------------------
Modify Date       Edited By            Change Description
--------------------------------------------------------------------------
--------------------------------------------------------------------------
Test Cases        :
--------------------------------------------------------------------------
--- Test Case 1
DECLARE @Result int 
EXEC [dbo].[Proc_ForwardReferees]
 @DetailId = 6
,@ReferredById = 2434
,@EmpIds = '1108,24'
,@Message  = 'Testing'
,@UserId = 2166
,@Success = @Result output
SELECT @Result AS [RESULT]
***/
ALTER PROCEDURE [dbo].[Proc_ForwardReferees]
(
@DetailId INT,
@ReferredById INT,
@EmpIds VARCHAR(MAX),
@Message VARCHAR(500),
@UserId INT,
@Success tinyint = 0 output
)
AS
BEGIN TRY
BEGIN TRAN
INSERT INTO [dbo].[ReferralReview]
([ReferralDetailId],[ForwardedToId],[ReferredById],[Message],CreatedBy)
SELECT @DetailId,U.[UserId],@ReferredById,@Message,@UserId
FROM UserDetail U
INNER JOIN ReferralDetail R ON R.[ReferredById]=@ReferredById
WHERE U.UserId IN (SELECT SplitData FROM [dbo].[Fun_SplitStringInt] (@EmpIds,','))
AND R.[ReferralDetailId]=@DetailId
SET @Success=1;--------------------------inserted successfully
 COMMIT
END TRY	
BEGIN CATCH
   --On Error
   IF @@TRANCOUNT > 0
   BEGIN
     SET @Success = 0; -- Error occurred
	 ROLLBACK TRANSACTION;
	 
	 DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
	 --Log Error
	 EXEC [spInsertErrorLog]
			 @ModuleName = 'Forward Referrals'
			,@Source = 'Proc_ForwardReferees'
			,@ErrorMessage = @ErrorMessage
			,@ErrorType = 'SP'
			,@ReportedByUserId = @UserId
   END
END CATCH

GO
--------------INSERT INTO EMAILTEMPLATES---------------------------------
INSERT INTO [dbo].[EmailTemplates](TemplateName,Template,IsHTML,CreatedBy)
VALUES
('Forward Referrals','<!-- [if mso]><xml> <o:OfficeDocumentSettings> <o:AllowPNG/> <o:PixelsPerInch>96</o:PixelsPerInch> </o:OfficeDocumentSettings></xml><![endif]--><!-- [if lte mso 11]><style type="text/css"> .outlook-group-fix{width:100% !important;}</style><![endif]-->
<script src="~/Scripts/app/Referral/addReferral.js?v=9.0"></script>
<div>
    <!-- [if mso | IE]> <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="600" align="center" style="width:600px;"> <tr> <td style="line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
    <div style="margin: 0px auto; max-width: 600px;">
        <table style="font-size: 0px; width: 100%;" role="presentation" border="0" cellspacing="0" cellpadding="0" align="center">
            <tbody>
                <tr>
                    <td style="text-align: center; vertical-align: top; direction: ltr; font-size: 0px; padding: 20px 0px; padding-bottom: 24px; padding-top: 0px;">&nbsp;</td>
                </tr>
            </tbody>
        </table>
    </div>
    <!-- [if mso | IE]> </td></tr></table><![endif]--><!-- [if mso | IE]> <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="600" align="center" style="width:600px;"> <tr> <td style="line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
    <div style="margin: 0px auto; max-width: 600px; background: #d8e2e7;">
        <table style="font-size: 0px; width: 100%; background: #d8e2e7;" role="presentation" border="0" cellspacing="0" cellpadding="0" align="center">
            <tbody>
                <tr>
                    <td style="text-align: center; vertical-align: top; direction: ltr; font-size: 0px; padding: 20px 0px;">
                        <!-- [if mso | IE]> <table role="presentation" border="0" cellpadding="0" cellspacing="0"><tr><td style="vertical-align:top;width:600px;"><![endif]-->
                        <div class="mj-column-per-100 outlook-group-fix" style="vertical-align: top; display: inline-block; direction: ltr; font-size: 13px; text-align: left; width: 100%;">
                            <table role="presentation" border="0" width="100%" cellspacing="0" cellpadding="0">
                                <tbody>
                                    <tr>
                                        <td style="word-break: break-word; font-size: 0px; padding: 0px;" align="center">
                                            <div class="" style="cursor: auto; color: #000000; font-family: Proxima Nova, Arial, Arial, Helvetica, sans-serif; font-size: 16px; line-height: 22px; text-align: center; text-transform: uppercase;">[HEADING]</div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <!-- [if mso | IE]> </td></tr></table><![endif]-->
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
    <!-- [if mso | IE]> </td></tr></table><![endif]--><!-- [if mso | IE]> <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="600" align="center" style="width:600px;"> <tr> <td style="line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
    <div style="margin: 0px auto; max-width: 600px; background: #d8e2e7;">
        <table style="font-size: 0px; width: 100%; background: #d8e2e7;" role="presentation" border="0" cellspacing="0" cellpadding="0" align="center">
            <tbody>
                <tr>
                    <td style="text-align: center; vertical-align: top; direction: ltr; font-size: 0px; padding: 0px 1px 1px;">
                        <!-- [if mso | IE]> <table role="presentation" border="0" cellpadding="0" cellspacing="0"><tr><td style="vertical-align:top;width:600px;"><![endif]-->
                        <div class="mj-column-per-100 outlook-group-fix" style="vertical-align: top; display: inline-block; direction: ltr; font-size: 13px; text-align: left; width: 100%;">
                            <table style="background: white;" role="presentation" border="0" width="100%" cellspacing="0" cellpadding="0">
                                <tbody>
                                    <tr>
                                        <td style="word-break: break-word; font-size: 0px; padding: 15px 30px 6px;" align="left">
                                            <div class="" style="cursor: auto; color: #000000; font-family: Proxima Nova, Arial, Arial, Helvetica, sans-serif; font-size: 15px; line-height: 22px; text-align: left;">Dear [NAME],</div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="word-break: break-word; font-size: 0px; padding: 15px 30px 5px;" align="left">
                                            <div class="" style="cursor: auto; color: #000000; font-family: Proxima Nova, Arial, Arial, Helvetica, sans-serif; font-size: 14px; line-height: 22px; text-align: left;">[MESSAGE]</div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="word-break: break-word; font-size: 0px; padding: 10px 30px 16px 30px;" align="left">
                                            <table style="border-collapse: separate;" role="presentation" border="0" cellspacing="0" cellpadding="0" align="left">
                                                <tbody>
                                                    <tr>
                                                       <td style="border:none;border-radius:25px;color:#fff;cursor:auto;padding:10px 25px"align=center valign=middle bgcolor=#00a8ff><a href=[LINKAPPROVE] style="text-decoration:none;line-height:100%;background:#00a8ff;color:#fff;font-family:Proxima Nova,Arial,Arial,Helvetica,sans-serif;font-size:15px;font-weight:400;text-transform:none;margin:0"target=_blank>Relevant</a>  <td style="padding:10px 25px"align=center valign=middle>  <td style="border:none;border-radius:25px;color:#fff;cursor:auto;padding:10px 25px"align=center valign=middle bgcolor=#FF5722><a href=[LINKREJECT] style="text-decoration:none;line-height:100%;background:#ff5722;color:#fff;font-family:Proxima Nova,Arial,Arial,Helvetica,sans-serif;font-size:15px;font-weight:400;text-transform:none;margin:0"target=_blank>Irrelevant</a>  
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="word-break: break-word; font-size: 0px; padding: 15px 30px 6px;" align="left">
                                            <div class="" style="cursor: auto; color: #607d8b; font-family: Proxima Nova, Arial, Arial, Helvetica, sans-serif; font-size: 14px; line-height: 22px; text-align: left;">For any query please send an email to <a style="text-decoration: none; color: #00a8ff;" href="mailto:misteam@geminisolutions">misteam@geminisolutions</a> or contact to HR team. Please ignore this email if you have already responded.</div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="word-break: break-word; font-size: 0px; padding: 15px 30px 0px;" align="left">
                                            <div class="" style="cursor: auto; color: #607d8b; font-family: Proxima Nova, Arial, Arial, Helvetica, sans-serif; font-size: 15px; line-height: 22px; text-align: left;">Thanks,</div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="word-break: break-word; font-size: 0px; padding: 0px 30px 10px;" align="left">
                                            <div class="" style="cursor: auto; color: #607d8b; font-family: Proxima Nova, Arial, Arial, Helvetica, sans-serif; font-size: 15px; line-height: 22px; text-align: left;">[SenderName]</div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="word-break: break-word; font-size: 0px; padding: 10px 25px;">&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td style="word-break: break-word; font-size: 0px; padding: 15px 30px 6px;" align="left">
                                            <div class="" style="cursor: auto; color: #607d8b; font-family: Proxima Nova, Arial, Arial, Helvetica, sans-serif; font-size: 12px; line-height: 22px; text-align: left;">If you are having trouble with the button above, copy and paste the URL below into your web browser.</div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="word-break: break-word; font-size: 0px; padding: 0px 30px 10px;" align="left">&nbsp;</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <!-- [if mso | IE]> </td></tr></table><![endif]-->
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
    <!-- [if mso | IE]> </td></tr></table><![endif]--><!-- [if mso | IE]> <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="600" align="center" style="width:600px;"> <tr> <td style="line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
    <div style="margin: 0px auto; max-width: 600px;">
        <table style="font-size: 0px; width: 100%;" role="presentation" border="0" cellspacing="0" cellpadding="0" align="center">
            <tbody>
                <tr>
                    <td style="text-align: center; vertical-align: top; direction: ltr; font-size: 0px; padding: 10px 0px;">
                        <!-- [if mso | IE]> <table role="presentation" border="0" cellpadding="0" cellspacing="0"><tr><td style="vertical-align:top;width:600px;"><![endif]-->
                        <div class="mj-column-per-100 outlook-group-fix" style="vertical-align: top; display: inline-block; direction: ltr; font-size: 13px; text-align: left; width: 100%;">
                            <table role="presentation" border="0" width="100%" cellspacing="0" cellpadding="0">
                                <tbody>
                                    <tr>
                                        <td style="word-break: break-word; font-size: 0px; padding: 0px;" align="center">
                                            <div class="" style="cursor: auto; color: #607d8b; font-family: Proxima Nova, Arial, Arial, Helvetica, sans-serif; font-size: 13px; line-height: 22px; text-align: center;"><a style="text-decoration: none; color: inherit;" href="http://geminisolutions.in"> <span style="border-bottom: dotted 1px #b3bac1;">Gemini Solutions Pvt. Ltd.</span> </a> | All Rights Reserved</div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <!-- [if mso | IE]> </td></tr></table><![endif]-->
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
    <!-- [if mso | IE]> </td></tr></table><![endif]--><!-- [if mso | IE]> <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="600" align="center" style="width:600px;"> <tr> <td style="line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
    <div style="margin: 0px auto; max-width: 600px;">
        <table style="font-size: 0px; width: 100%;" role="presentation" border="0" cellspacing="0" cellpadding="0" align="center">
            <tbody>
                <tr>
                    <td style="text-align: center; vertical-align: top; direction: ltr; font-size: 0px; padding: 20px 0px; padding-bottom: 24px; padding-top: 0px;">&nbsp;</td>
                </tr>
            </tbody>
        </table>
    </div>
',1,2434),
('Action On Referral','<html xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office"><head> <title></title> <meta http-equiv="X-UA-Compatible" content="IE=edge"> <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"> <style type="text/css"> #outlook a{padding: 0;}.ReadMsgBody{width: 100%;}.ExternalClass{width: 100%;}.ExternalClass *{line-height: 100%;}body{margin: 0; padding: 0; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%;}table, td{border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt;}img{border: 0; height: auto; line-height: 100%; outline: none; text-decoration: none; -ms-interpolation-mode: bicubic;}p{display: block; margin: 13px 0;}</style> <style type="text/css"> @media only screen and (max-width:480px){@-ms-viewport{width: 320px;}@viewport{width: 320px;}}</style><!--[if mso]><xml> <o:OfficeDocumentSettings> <o:AllowPNG/> <o:PixelsPerInch>96</o:PixelsPerInch> </o:OfficeDocumentSettings></xml><![endif]--><!--[if lte mso 11]><style type="text/css"> .outlook-group-fix{width:100% !important;}</style><![endif]--> <style type="text/css"> @media only screen and (min-width:480px){.mj-column-per-100{width: 100%!important;}}</style></head><body> <div><!--[if mso | IE]> <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="600" align="center" style="width:600px;"> <tr> <td style="line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]--> <div style="margin:0px auto;max-width:600px;"> <table role="presentation" cellpadding="0" cellspacing="0" style="font-size:0px;width:100%;" align="center" border="0"> <tbody> <tr> <td style="text-align:center;vertical-align:top;direction:ltr;font-size:0px;padding:20px 0px;padding-bottom:24px;padding-top:0px;"></td></tr></tbody> </table> </div><!--[if mso | IE]> </td></tr></table><![endif]--><!--[if mso | IE]> <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="600" align="center" style="width:600px;"> <tr> <td style="line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]--> <div style="margin:0px auto;max-width:600px;background:#d8e2e7;"> <table role="presentation" cellpadding="0" cellspacing="0" style="font-size:0px;width:100%;background:#d8e2e7;" align="center" border="0"> <tbody> <tr> <td style="text-align:center;vertical-align:top;direction:ltr;font-size:0px;padding:20px 0px;"><!--[if mso | IE]> <table role="presentation" border="0" cellpadding="0" cellspacing="0"><tr><td style="vertical-align:top;width:600px;"><![endif]--> <div class="mj-column-per-100 outlook-group-fix" style="vertical-align:top;display:inline-block;direction:ltr;font-size:13px;text-align:left;width:100%;"> <table role="presentation" cellpadding="0" cellspacing="0" width="100%" border="0"> <tbody> <tr> <td style="word-break:break-word;font-size:0px;padding:0px;" align="center"> <div class="" style="cursor:auto;color:#000000;font-family:Proxima Nova, Arial, Arial, Helvetica, sans-serif;font-size:16px;line-height:22px;text-align:center;text-transform:uppercase;">[Heading]</div></td></tr></tbody> </table> </div><!--[if mso | IE]> </td></tr></table><![endif]--> </td></tr></tbody> </table> </div><!--[if mso | IE]> </td></tr></table><![endif]--><!--[if mso | IE]> <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="600" align="center" style="width:600px;"> <tr> <td style="line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]--> <div style="margin:0px auto;max-width:600px;background:#d8e2e7;"> <table role="presentation" cellpadding="0" cellspacing="0" style="font-size:0px;width:100%;background:#d8e2e7;" align="center" border="0"> <tbody> <tr> <td style="text-align:center;vertical-align:top;direction:ltr;font-size:0px;padding:0px 1px 1px;"><!--[if mso | IE]> <table role="presentation" border="0" cellpadding="0" cellspacing="0"><tr><td style="vertical-align:top;width:600px;"><![endif]--> <div class="mj-column-per-100 outlook-group-fix" style="vertical-align:top;display:inline-block;direction:ltr;font-size:13px;text-align:left;width:100%;"> <table role="presentation" cellpadding="0" cellspacing="0" style="background:white;" width="100%" border="0"> <tbody><tr> <td style="word-break:break-word;font-size:0px;padding:15px 30px 5px;" align="left"> <div class="" style="cursor:auto;color:#000000;font-family:Proxima Nova, Arial, Arial, Helvetica, sans-serif;font-size:14px;line-height:22px;text-align:left;">Dear [Name], </div></td><tr> <td style="word-break:break-word;font-size:0px;padding:15px 30px 5px;" align="left"> <div class="" style="cursor:auto;color:#000000;font-family:Proxima Nova, Arial, Arial, Helvetica, sans-serif;font-size:14px;line-height:22px;text-align:left;">Referral review of [RefereeName] has been marked <span style="color:[COLOR];font-weight:bold">[ACTION]</span> by [ActionByName] and below are the comments given on the same.</div></td></tr><tr> <td style="word-break:break-word;font-size:0px;padding:15px 30px 5px;" align="left"> <div class="" style="cursor:auto;color:#000000;font-family:Proxima Nova, Arial, Arial, Helvetica, sans-serif;font-size:14px;line-height:22px;text-align:left;">[COMMENTS]</div></td></tr><tr> <td style="word-break:break-word;font-size:0px;padding:15px 30px 5px;" align="left"></td></tr><tr> <td style="word-break:break-word;font-size:0px;padding:15px 30px 0px;" align="left"> <div class="" style="cursor:auto;color:#607D8B;font-family:Proxima Nova, Arial, Arial, Helvetica, sans-serif;font-size:15px;line-height:22px;text-align:left;">Regards,</div></td></tr><tr> <td style="word-break:break-word;font-size:0px;padding:0px 30px 10px;" align="left"> <div class="" style="cursor:auto;color:#607D8B;font-family:Proxima Nova, Arial, Arial, Helvetica, sans-serif;font-size:15px;line-height:22px;text-align:left;">Team MIS</div></td></tr><tr> <td style="word-break:break-word;font-size:0px;padding:10px 25px;"> <p style="font-size:1px;margin:0px auto;border-top:1px solid #eee;width:100%;"></p></td></tr><tr> <td style="word-break:break-word;font-size:0px;padding:15px 30px 6px;" align="left"> <div class="" style="cursor:auto;color:#607D8B;font-family:Proxima Nova, Arial, Arial, Helvetica, sans-serif;font-size:12px;line-height:22px;text-align:left;">If you are having trouble or questions please send an email to misteam@geminisolutions.in or contact to MIS team.</div></td></tr></tbody> </table> </div><!--[if mso | IE]> </td></tr></table><![endif]--> </td></tr></tbody> </table> </div><!--[if mso | IE]> </td></tr></table><![endif]--><!--[if mso | IE]> <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="600" align="center" style="width:600px;"> <tr> <td style="line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]--> <div style="margin:0px auto;max-width:600px;"> <table role="presentation" cellpadding="0" cellspacing="0" style="font-size:0px;width:100%;" align="center" border="0"> <tbody> <tr> <td style="text-align:center;vertical-align:top;direction:ltr;font-size:0px;padding:10px 0px;"><!--[if mso | IE]> <table role="presentation" border="0" cellpadding="0" cellspacing="0"><tr><td style="vertical-align:top;width:600px;"><![endif]--> <div class="mj-column-per-100 outlook-group-fix" style="vertical-align:top;display:inline-block;direction:ltr;font-size:13px;text-align:left;width:100%;"> <table role="presentation" cellpadding="0" cellspacing="0" width="100%" border="0"> <tbody> <tr> <td style="word-break:break-word;font-size:0px;padding:0px;" align="center"> <div class="" style="cursor:auto;color:#607D8B;font-family:Proxima Nova, Arial, Arial, Helvetica, sans-serif;font-size:13px;line-height:22px;text-align:center;"> <a href="http://geminisolutions.in" style="text-decoration: none; color: inherit;"> <span style="border-bottom: dotted 1px #b3bac1">Gemini Solutions Pvt. Ltd.</span> </a> | All Rights Reserved</div></td></tr></tbody> </table> </div><!--[if mso | IE]> </td></tr></table><![endif]--> </td></tr></tbody> </table> </div><!--[if mso | IE]> </td></tr></table><![endif]--><!--[if mso | IE]> <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="600" align="center" style="width:600px;"> <tr> <td style="line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]--> <div style="margin:0px auto;max-width:600px;"> <table role="presentation" cellpadding="0" cellspacing="0" style="font-size:0px;width:100%;" align="center" border="0"> <tbody> <tr> <td style="text-align:center;vertical-align:top;direction:ltr;font-size:0px;padding:20px 0px;padding-bottom:24px;padding-top:0px;"></td></tr></tbody> </table> </div><!--[if mso | IE]> </td></tr></table><![endif]--> </div></body></html>',1,2434),
('Referral Review Reminder','<!doctype html><html xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office"><head> <title></title> <meta http-equiv="X-UA-Compatible" content="IE=edge"> <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"> <style type="text/css"> #outlook a{padding: 0;}.ReadMsgBody{width: 100%;}.ExternalClass{width: 100%;}.ExternalClass *{line-height: 100%;}body{margin: 0; padding: 0; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%;}table, td{border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt;}img{border: 0; height: auto; line-height: 100%; outline: none; text-decoration: none; -ms-interpolation-mode: bicubic;}p{display: block; margin: 13px 0;}</style> <style type="text/css"> @media only screen and (max-width:480px){@-ms-viewport{width: 320px;}@viewport{width: 320px;}}</style><!--[if mso]><xml> <o:OfficeDocumentSettings> <o:AllowPNG/> <o:PixelsPerInch>96</o:PixelsPerInch> </o:OfficeDocumentSettings></xml><![endif]--><!--[if lte mso 11]><style type="text/css"> .outlook-group-fix{width:100% !important;}</style><![endif]--> <style type="text/css"> @media only screen and (min-width:480px){.mj-column-per-100{width: 100%!important;}}</style></head><body> <div><!--[if mso | IE]> <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="600" align="center" style="width:600px;"> <tr> <td style="line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]--> <div style="margin:0px auto;max-width:600px;"> <table role="presentation" cellpadding="0" cellspacing="0" style="font-size:0px;width:100%;" align="center" border="0"> <tbody> <tr> <td style="text-align:center;vertical-align:top;direction:ltr;font-size:0px;padding:20px 0px;padding-bottom:24px;padding-top:0px;"></td></tr></tbody> </table> </div><!--[if mso | IE]> </td></tr></table><![endif]--><!--[if mso | IE]> <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="600" align="center" style="width:600px;"> <tr> <td style="line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]--> <div style="margin:0px auto;max-width:600px;background:#d8e2e7;"> <table role="presentation" cellpadding="0" cellspacing="0" style="font-size:0px;width:100%;background:#d8e2e7;" align="center" border="0"> <tbody> <tr> <td style="text-align:center;vertical-align:top;direction:ltr;font-size:0px;padding:20px 0px;"><!--[if mso | IE]> <table role="presentation" border="0" cellpadding="0" cellspacing="0"><tr><td style="vertical-align:top;width:600px;"><![endif]--> <div class="mj-column-per-100 outlook-group-fix" style="vertical-align:top;display:inline-block;direction:ltr;font-size:13px;text-align:left;width:100%;"> <table role="presentation" cellpadding="0" cellspacing="0" width="100%" border="0"> <tbody> <tr> <td style="word-break:break-word;font-size:0px;padding:0px;" align="center"> <div class="" style="cursor:auto;color:#000000;font-family:Proxima Nova, Arial, Arial, Helvetica, sans-serif;font-size:16px;line-height:22px;text-align:center;text-transform:uppercase;">[HEADING]</div></td></tr></tbody> </table> </div><!--[if mso | IE]> </td></tr></table><![endif]--> </td></tr></tbody> </table> </div><!--[if mso | IE]> </td></tr></table><![endif]--><!--[if mso | IE]> <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="600" align="center" style="width:600px;"> <tr> <td style="line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]--> <div style="margin:0px auto;max-width:600px;background:#d8e2e7;"> <table role="presentation" cellpadding="0" cellspacing="0" style="font-size:0px;width:100%;background:#d8e2e7;" align="center" border="0"> <tbody> <tr> <td style="text-align:center;vertical-align:top;direction:ltr;font-size:0px;padding:0px 1px 1px;"><!--[if mso | IE]> <table role="presentation" border="0" cellpadding="0" cellspacing="0"><tr><td style="vertical-align:top;width:600px;"><![endif]--> <div class="mj-column-per-100 outlook-group-fix" style="vertical-align:top;display:inline-block;direction:ltr;font-size:13px;text-align:left;width:100%;"> <table role="presentation" cellpadding="0" cellspacing="0" style="background:white;" width="100%" border="0"> <tbody><tr> <td style="word-break:break-word;font-size:0px;padding:15px 30px 5px;" align="left"> <div class="" style="cursor:auto;color:#000000;font-family:Proxima Nova, Arial, Arial, Helvetica, sans-serif;font-size:14px;line-height:22px;text-align:left;">Dear [Name], </div></td><tr> <td style="word-break:break-word;font-size:0px;padding:15px 30px 5px;" align="left"> <div class="" style="cursor:auto;color:#000000;font-family:Proxima Nova, Arial, Arial, Helvetica, sans-serif;font-size:14px;line-height:22px;text-align:left;">We have not received your response on referral review of <B>[RefereeName]</B>. Please submit it ASAP. </div></td></tr><tr> <td style="word-break:break-word;font-size:0px;padding:15px 30px 5px;" align="left"></td></tr><tr> <td style="word-break:break-word;font-size:0px;padding:15px 30px 0px;" align="left"> <div class="" style="cursor:auto;color:#607D8B;font-family:Proxima Nova, Arial, Arial, Helvetica, sans-serif;font-size:15px;line-height:22px;text-align:left;">Regards,</div></td></tr><tr> <td style="word-break:break-word;font-size:0px;padding:0px 30px 10px;" align="left"> <div class="" style="cursor:auto;color:#607D8B;font-family:Proxima Nova, Arial, Arial, Helvetica, sans-serif;font-size:15px;line-height:22px;text-align:left;">HR Department</div></td></tr><tr> <td style="word-break:break-word;font-size:0px;padding:10px 25px;"> <p style="font-size:1px;margin:0px auto;border-top:1px solid #eee;width:100%;"></p></td></tr><tr> <td style="word-break:break-word;font-size:0px;padding:15px 30px 6px;" align="left"> <div class="" style="cursor:auto;color:#607D8B;font-family:Proxima Nova, Arial, Arial, Helvetica, sans-serif;font-size:12px;line-height:22px;text-align:left;">If you are having trouble or questions please send an email to misteam@geminisolutions.in or contact to MIS team.</div></td></tr></tbody> </table> </div><!--[if mso | IE]> </td></tr></table><![endif]--> </td></tr></tbody> </table> </div><!--[if mso | IE]> </td></tr></table><![endif]--><!--[if mso | IE]> <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="600" align="center" style="width:600px;"> <tr> <td style="line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]--> <div style="margin:0px auto;max-width:600px;"> <table role="presentation" cellpadding="0" cellspacing="0" style="font-size:0px;width:100%;" align="center" border="0"> <tbody> <tr> <td style="text-align:center;vertical-align:top;direction:ltr;font-size:0px;padding:10px 0px;"><!--[if mso | IE]> <table role="presentation" border="0" cellpadding="0" cellspacing="0"><tr><td style="vertical-align:top;width:600px;"><![endif]--> <div class="mj-column-per-100 outlook-group-fix" style="vertical-align:top;display:inline-block;direction:ltr;font-size:13px;text-align:left;width:100%;"> <table role="presentation" cellpadding="0" cellspacing="0" width="100%" border="0"> <tbody> <tr> <td style="word-break:break-word;font-size:0px;padding:0px;" align="center"> <div class="" style="cursor:auto;color:#607D8B;font-family:Proxima Nova, Arial, Arial, Helvetica, sans-serif;font-size:13px;line-height:22px;text-align:center;"> <a href="http://geminisolutions.in" style="text-decoration: none; color: inherit;"> <span style="border-bottom: dotted 1px #b3bac1">Gemini Solutions Pvt. Ltd.</span> </a> | All Rights Reserved</div></td></tr></tbody> </table> </div><!--[if mso | IE]> </td></tr></table><![endif]--> </td></tr></tbody> </table> </div><!--[if mso | IE]> </td></tr></table><![endif]--><!--[if mso | IE]> <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="600" align="center" style="width:600px;"> <tr> <td style="line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]--> <div style="margin:0px auto;max-width:600px;"> <table role="presentation" cellpadding="0" cellspacing="0" style="font-size:0px;width:100%;" align="center" border="0"> <tbody> <tr> <td style="text-align:center;vertical-align:top;direction:ltr;font-size:0px;padding:20px 0px;padding-bottom:24px;padding-top:0px;"></td></tr></tbody> </table> </div><!--[if mso | IE]> </td></tr></table><![endif]--> </div></body></html>',1,2434)