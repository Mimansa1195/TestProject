using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
using System.IO;
using System.Web.Script.Serialization;

namespace MIS.Utilities.Helpers
{
    public static class EInvoiceHelper
    {
        public static string PrintElementsOfList<T>(List<T> data)
        {
            try
            {
                var stringToReturn = string.Empty;
                for (var i = 0; i < data.Count; i++)
                {
                    stringToReturn = stringToReturn + "( " + (i + 1) + " )" + new JavaScriptSerializer().Serialize(data[i]) + Environment.NewLine;
                }
                return stringToReturn;
            }
            catch (Exception)
            {
                return null;
            }
        }
    }
}
