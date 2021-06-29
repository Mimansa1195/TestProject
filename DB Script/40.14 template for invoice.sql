insert into EmailTemplates(TemplateName,Template,IsHTML,CreatedBy)
values('Requested Invoice Action',
'<!doctype html>
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office">
   <head>
      <title></title>
      <meta http-equiv="X-UA-Compatible" content="IE=edge">
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
      <style type="text/css"> #outlook a{padding: 0;}.ReadMsgBody{width: 100%;}.ExternalClass{width: 100%;}.ExternalClass *{line-height: 100%;}body{margin: 0; padding: 0; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%;}table, td{border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt;}img{border: 0; height: auto; line-height: 100%; outline: none; text-decoration: none; -ms-interpolation-mode: bicubic;}p{display: block; margin: 13px 0;}</style>
      <style type="text/css"> @media only screen and (max-width:480px){@-ms-viewport{width: 320px;}@viewport{width: 320px;}}</style>
      <style type="text/css"> @media only screen and (min-width:480px){.mj-column-per-100{width: 100%!important;}}</style>
   </head>
   <body>
      <div>
         <div style="margin:0px auto;max-width:600px;">
            <table role="presentation" cellpadding="0" cellspacing="0" style="font-size:0px;width:100%;" 
               align="center" border="0">
               <tbody>
                  <tr>
                     <td style="text-align:center;vertical-align:top;direction:ltr;font-size:0px;padding:20px 0px;padding-bottom:24px;padding-top:0px;"></td>
                  </tr>
               </tbody>
            </table>
         </div>
         <div style="margin:0px auto;max-width:600px;background:#d8e2e7;">
            <table role="presentation" cellpadding="0" cellspacing="0" style="font-size:0px;width:100%;background:#d8e2e7;" align="center" border="0">
               <tbody>
                  <tr>
                     <td style="text-align:center;vertical-align:top;direction:ltr;font-size:0px;padding:20px 0px;">
                        <div class="mj-column-per-100 outlook-group-fix" style="vertical-align:top;display:inline-block;direction:ltr;font-size:13px;text-align:left;width:100%;">
                           <table role="presentation" cellpadding="0" cellspacing="0" width="100%" border="0">
                              <tbody>
                                 <tr>
                                    <td style="word-break:break-word;font-size:0px;padding:0px;" align="center">
                                       <div class="" style="cursor:auto;color:#000000;font-family:Proxima Nova, Arial, Arial, Helvetica, sans-serif;font-size:16px;line-height:22px;text-align:center;text-transform:uppercase;">
                                          [HEADING]
                                       </div>
                                    </td>
                                 </tr>
                              </tbody>
                           </table>
                        </div>
                     </td>
                  </tr>
               </tbody>
            </table>
         </div>
         <div style="margin:0px auto;max-width:600px;background:#d8e2e7;">
            <table role="presentation" cellpadding="0" cellspacing="0" style="font-size:0px;width:100%;background:#d8e2e7;" align="center" border="0">
               <tbody>
                  <tr>
                     <td style="text-align:center;vertical-align:top;direction:ltr;font-size:0px;padding:0px 1px 1px;">
                        <div class="mj-column-per-100 outlook-group-fix" style="vertical-align:top;display:inline-block;direction:ltr;font-size:13px;text-align:left;width:100%;">
                           <table role="presentation" cellpadding="0" cellspacing="0" style="background:white;" width="100%" border="0">
                              <tbody>
                                 <tr>
                                    <td style="word-break:break-word;font-size:0px;padding:15px 30px 6px;" align="left">
                                       <div class="" style="cursor:auto;color:#000000;font-family:Proxima Nova, Arial, Arial, Helvetica, sans-serif;font-size:15px;line-height:22px;text-align:left;">
                                          Dear [NAME],
                                       </div>
                                    </td>
                                 </tr>
                                 <tr>
                                    <td style="word-break:break-word;font-size:0px;padding:15px 30px 5px;" align="left">
                                       <div class="" style="cursor:auto;color:#000000;font-family:Proxima Nova, Arial, Arial, Helvetica, sans-serif;font-size:14px;line-height:22px;text-align:left;">[MESSAGE]</div>
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="" style="cursor:auto;color:#000000;font-family:Proxima Nova, Arial, Arial, Helvetica, sans-serif;font-size:14px;line-height:22px;padding:15px 30px 5px">[DATA] </td>
                                 </tr>
                                 <tr>
                                    <td style="word-break:break-word;font-size:0px;padding:8px 16px 10px;padding-top:10px;padding-bottom:16px;padding-right:30px;padding-left:30px;" align="left">
                                       <table style="border-collapse: separate;" role="presentation" border="0" cellspacing="0" cellpadding="0" align="left">
                                          <tbody>
                                             <tr>
                                                <td style="border:none;border-radius:25px;color:#fff;cursor:auto;padding:10px 25px"align=center valign=middle bgcolor=#00a8ff><a id="btnApprove" href=[LINKAPPROVE] style="text-decoration:none;line-height:100%;background:#00a8ff;color:#fff;font-family:Proxima Nova,Arial,Arial,Helvetica,sans-serif;font-size:15px;font-weight:400;text-transform:none;margin:0"target=_blank>Approve</a>
                                                <td style="padding:10px 25px" align=center valign=middle>
                                                <td style="border:none;border-radius:25px;color:#fff;cursor:auto;padding:10px 25px"align=center valign=middle bgcolor=#FF5722><a href=[LINKREJECT] style="text-decoration:none;line-height:100%;background:#ff5722;color:#fff;font-family:Proxima Nova,Arial,Arial,Helvetica,sans-serif;font-size:15px;font-weight:400;text-transform:none;margin:0"target=_blank>Reject</a></td>
                                             </tr>
                                          </tbody>
                                       </table>
                                    </td>
                                 </tr>
                                 <tr>
                                    <td style="word-break:break-word;font-size:0px;padding:15px 30px 6px;" align="left">
                                       <div class="" style="cursor:auto;color:#607D8B;font-family:Proxima Nova, Arial, Arial, Helvetica, sans-serif;font-size:14px;line-height:22px;text-align:left;"></div>
                                    </td>
                                 </tr>
                                 <tr>
                                    <td style="word-break:break-word;font-size:0px;padding:15px 30px 0px;" align="left">
                                       <div class="" style="cursor:auto;color:#607D8B;font-family:Proxima Nova, Arial, Arial, Helvetica, sans-serif;font-size:15px;line-height:22px;text-align:left;">Regards,</div>
                                    </td>
                                 </tr>
                                 <tr>
                                    <td style="word-break:break-word;font-size:0px;padding:0px 30px 10px;" align="left">
                                       <div class="" style="cursor:auto;color:#607D8B;font-family:Proxima Nova, Arial, Arial, Helvetica, sans-serif;font-size:15px;line-height:22px;text-align:left;">[SenderName]</div>
                                    </td>
                                 </tr>
                                 <tr>
                                    <td style="word-break:break-word;font-size:0px;padding:10px 25px;">
                                       <p style="font-size:1px;margin:0px auto;border-top:1px solid #eee;width:100%;"></p>
                                    </td>
                                 </tr>
                                 <tr>
                                    <td style="word-break:break-word;font-size:0px;padding:15px 30px 6px;" align="left">
                                       <div class="" style="cursor:auto;color:#607D8B;font-family:Proxima Nova, Arial, Arial, Helvetica, sans-serif;font-size:12px;line-height:22px;text-align:left;">If you are having trouble with the button above, please send an email to <a href="mailto:misteam@geminisolutions" style="text-decoration:none;color:#00a8ff">misteam@geminisolutions</a> or contact to MIS team.</div>
                                    </td>
                                 </tr>
                              </tbody>
                           </table>
                        </div>
                     </td>
                  </tr>
               </tbody>
            </table>
         </div>
         <div style="margin:0px auto;max-width:600px;">
            <table role="presentation" cellpadding="0" cellspacing="0" style="font-size:0px;width:100%;" align="center" border="0">
               <tbody>
                  <tr>
                     <td style="text-align:center;vertical-align:top;direction:ltr;font-size:0px;padding:10px 0px;">
                        <div class="mj-column-per-100 outlook-group-fix" style="vertical-align:top;display:inline-block;direction:ltr;font-size:13px;text-align:left;width:100%;">
                           <table role="presentation" cellpadding="0" cellspacing="0" width="100%" border="0">
                              <tbody>
                                 <tr>
                                    <td style="word-break:break-word;font-size:0px;padding:0px;" align="center">
                                       <div class="" style="cursor:auto;color:#607D8B;font-family:Proxima Nova, Arial, Arial, Helvetica, sans-serif;font-size:13px;line-height:22px;text-align:center;"><a href="http://geminisolutions.in" style="text-decoration: none; color: inherit;"><span style="border-bottom: dotted 1px #b3bac1">Gemini Solutions Pvt. Ltd.</span></a> | All Rights Reserved</div>
                                    </td>
                                 </tr>
                              </tbody>
                           </table>
                        </div>
                     </td>
                  </tr>
               </tbody>
            </table>
         </div>
         <div style="margin:0px auto;max-width:600px;">
            <table role="presentation" cellpadding="0" cellspacing="0" style="font-size:0px;width:100%;" align="center" border="0">
               <tbody>
                  <tr>
                     <td style="text-align:center;vertical-align:top;direction:ltr;font-size:0px;padding:20px 0px;padding-bottom:24px;padding-top:0px;"></td>
                  </tr>
               </tbody>
            </table>
         </div>
      </div>
   </body>
</html>',1,2434)