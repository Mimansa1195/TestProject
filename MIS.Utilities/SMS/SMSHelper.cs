using System;
using System.Collections.Generic;
using System.Net;
using BO = MIS.BO;

namespace MIS.Utilities
{
    public static class SMSHelper
    {
        public static BO.ServiceResult<bool> SendSMSToSelectedEmp(string msg, List<int> userIdList)
        {

            try
            {
                var mobileNumberList = new List<string>();
                if (userIdList.Count <= 0)
                {
                    return BO.ServiceReturnType.FailureBoolResult;
                }
                else
                {
                    //using (var context = new MISEntities())
                    //{
                    //    mobileNumberList =
                    //       (from a in context.UserDetails where userIdList.Contains(a.UserId) select a.MobileNumber).
                    //           ToList();

                    //}
                }
                if (mobileNumberList.Count > 0)
                {
                    foreach (var mobNumber in mobileNumberList)
                    {


                        string uid = "XXXXXXXXXX";
                        string password = "XXXXXXXXXX";;
                        string provider = "XXXXXXXXXX";
                        HttpWebRequest myReq = (HttpWebRequest)WebRequest.Create("XXXXXXXXXXXXX?uid=" + uid + "&pwd=" + password + "&msg=" + msg + "&phone=" + mobNumber + "&provider=" + provider);
                        HttpWebResponse myResp = (HttpWebResponse)myReq.GetResponse();
                        System.IO.StreamReader respStreamReader = new System.IO.StreamReader(myResp.GetResponseStream());
                        string responseString = respStreamReader.ReadToEnd();
                        respStreamReader.Close();
                        myResp.Close();
                    }

                }


                return BO.ServiceReturnType.SuccessBoolResult;
            }
            catch (Exception)
            {

                return BO.ServiceReturnType.FailureBoolResult;
            }





        }
        public static BO.ServiceResult<bool> SendSMSToMobileNumber(string msg, List<string> mobileNumberList)
        {

            try
            {
                if (mobileNumberList.Count > 0)
                {
                    foreach (var mobNumber in mobileNumberList)
                    {


                        string uid = "9313342443";
                        string password = "70506";//"12345";
                        string provider = "fullonsms";// "way2sms";
                        HttpWebRequest myReq = (HttpWebRequest)WebRequest.Create("http://ubaid.tk/sms/sms.aspx?uid=" + uid + "&pwd=" + password + "&msg=" + msg + "&phone=" + mobNumber + "&provider=" + provider);
                        HttpWebResponse myResp = (HttpWebResponse)myReq.GetResponse();
                        System.IO.StreamReader respStreamReader = new System.IO.StreamReader(myResp.GetResponseStream());
                        string responseString = respStreamReader.ReadToEnd();
                        respStreamReader.Close();
                        myResp.Close();
                    }

                }


                return BO.ServiceReturnType.SuccessBoolResult;
            }
            catch (Exception)
            {

                return BO.ServiceReturnType.FailureBoolResult;
            }





        }
    }
}
