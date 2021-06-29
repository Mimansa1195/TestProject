using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace MIS.Utilities
{
    public static class CustomExtensions
    {
        /// <summary>
        ///  Static Method to determines whether an expression evaluates to a valid numeric type
        /// </summary>
        /// <param name="input">string value</param>
        /// <returns>True or False</returns>
        public static bool IsInteger(this String input)
        {
            int temp;
            return int.TryParse(input, out temp);
        }

        /// <summary>
        /// Static method to convert a string to lower after trimming white spaces
        /// </summary>
        /// <param name="inputString">InputString</param>
        /// <returns>trimmed, lowercaes string</returns>
        public static string TrimAndLower(this String inputString)
        {
            return inputString.Trim().ToLower();
        }

        /// <summary>
        ///  Static Method to determines whether an expression is null
        /// </summary>
        /// <typeparam name="T">Type</typeparam>
        /// <param name="obj">object</param>
        /// <returns>True or False</returns>
        public static bool IsNull<T>(this T obj) where T : class
        {
            return (object)obj == null || obj == DBNull.Value;
        }

        /// <summary>
        ///  Static Method to convert string array to integer list
        /// </summary>
        /// <param name="list">Character separated list</param>
        /// <param name="separator">Separator Character</param>
        /// <returns>Integer List</returns>
        public static List<int> SplitToIntList(this string list, char separator = ',')
        {
            int result = 0;
            if (!string.IsNullOrEmpty(list))
                return (from s in list.Split(',')
                        let isInt = int.TryParse(s, out result)
                        let val = result
                        where isInt
                        select val).ToList();
            else
                return new List<int>();
        }


        /// <summary>
        ///  Static Method to convert string array to integer list
        /// </summary>
        /// <param name="list">Character separated list</param>
        /// <param name="separator">Separator Character</param>
        /// <returns>Integer List</returns>
        public static List<int> SplitUseridsToIntList(this string list, char separator = ',')
        {
            int result = 0;
            if (!string.IsNullOrEmpty(list))
                return (from s in list.Split(',')
                        let isInt = int.TryParse(CryptoHelper.Decrypt(s), out result)
                        let val = result
                        where isInt
                        select val).ToList();
            else
                return new List<int>();
        }


        /// <summary>
        /// Static Method to convert string array to long list
        /// </summary>
        /// <param name="list">Character separated list</param>
        /// <param name="separator">Separator Character</param>
        /// <returns>long List</returns>
        public static List<long> SplitToLongList(this string list, char separator = ',')
        {
            long result = 0;
            if (!string.IsNullOrEmpty(list))
                return (from s in list.Split(',')
                        let isInt = long.TryParse(s, out result)
                        let val = result
                        where isInt
                        select val).ToList();
            else
                return new List<long>();
        }

        public static string ReplaceFirstOccurence(this string originalValue, string occurenceValue, string newValue)
        {
            if (string.IsNullOrEmpty(originalValue))
                return string.Empty;
            if (string.IsNullOrEmpty(occurenceValue))
                return originalValue;
            int startindex = originalValue.IndexOf(occurenceValue);
            return originalValue.Remove(startindex, occurenceValue.Length).Insert(startindex, newValue);
        }

        public static string ReplaceLastOccurence(this string originalValue, string occurenceValue, string newValue)
        {
            if (string.IsNullOrEmpty(originalValue))
                return string.Empty;
            if (string.IsNullOrEmpty(occurenceValue))
                return originalValue;
            int startindex = originalValue.LastIndexOf(occurenceValue);
            return originalValue.Remove(startindex, occurenceValue.Length).Insert(startindex, newValue);
        }

        public static bool ScrambledEquals<T>(IEnumerable<T> list1, IEnumerable<T> list2)
        {
            var cnt = new Dictionary<T, int>();
            foreach (T s in list1)
            {
                if (cnt.ContainsKey(s))
                {
                    cnt[s]++;
                }
                else
                {
                    cnt.Add(s, 1);
                }
            }
            foreach (T s in list2)
            {
                if (cnt.ContainsKey(s))
                {
                    cnt[s]--;
                }
                else
                {
                    return false;
                }
            }
            return cnt.Values.All(c => c == 0);
        }

        public static bool ScrambledEquals<T>(IEnumerable<T> list1, IEnumerable<T> list2, IEqualityComparer<T> comparer)
        {
            var cnt = new Dictionary<T, int>(comparer);
            return cnt.Any();
        }

        /// <summary>
        /// Method to check if two list is equal irrespective of sequence
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="list1">List 1</param>
        /// <param name="list2">List 2</param>
        /// <returns>True/False</returns>
        public static bool CheckEquality<T>(IEnumerable<T> list1, IEnumerable<T> list2)
        {
            var set1 = new HashSet<T>(list1);
            var set2 = new HashSet<T>(list2);
            return set1.SetEquals(set2);
        }

        #region Randomize

        /// <summary>
        /// Method to shuffle a list in random sequence using Random class
        /// Usage:
        /// Eg:1 List<Product> products = GetProducts(); products.Shuffle();
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="list"></param>
        public static void Shuffle<T>(this IList<T> list)
        {
            Random rng = new Random();

            int n = list.Count;
            while (n > 1)
            {
                n--;
                int k = rng.Next(n + 1);
                T value = list[k];
                list[k] = list[n];
                list[n] = value;
            }
        }

        /// <summary>
        /// Method to shuffle a list in random sequence using RNGCryptoServiceProvider class
        /// Usage:
        /// Eg:1 List<Product> products = GetProducts(); products.Shuffle();
        /// Eg:2 var numbers = new List<int>(Enumerable.Range(1, 100)); numbers.Shuffle();
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="list"></param>
        public static void PerfectShuffle<T>(this IList<T> list)
        {
            RNGCryptoServiceProvider provider = new RNGCryptoServiceProvider();
            int n = list.Count;
            while (n > 1)
            {
                byte[] box = new byte[1];
                do provider.GetBytes(box);
                while (!(box[0] < n * (Byte.MaxValue / n)));
                int k = (box[0] % n);
                n--;
                T value = list[k];
                list[k] = list[n];
                list[n] = value;
            }
        }
        #endregion

    }

    public static class HtmlExtensions
    {
        /// <summary>
        /// Convert datatable to html table
        /// </summary>
        /// <param name="dataTable"></param>
        /// <param name="columnCaptions"></param>
        /// <returns></returns>
        public static string ToHtmlTable(this DataTable dataTable, bool isHeaderVisible = true, Dictionary<string, string> columnCaptions = null)
        {
            var htmlTable = new StringBuilder();
            
            if (isHeaderVisible)
            {
                htmlTable.Append("<table border='0' cellpadding='4' style='color:#000000;font:normal 11px arial,sans-serif;border:1px solid #abb2b7;width:100%'>");
                htmlTable.Append("<tr>");
                foreach (var column in dataTable.Columns)
                {
                    htmlTable.Append("<th style='color:#434d52;font:bold 13px arial,sans-serif;white-space:nowrap;background-color:#ebeff1;border:1px solid #abb2b7;text-align:center; width:2%;'>");
                    var caption = column.ToString();
                    if (columnCaptions != null && columnCaptions.Any() && columnCaptions.TryGetValue(column.ToString(), out caption))
                        caption = columnCaptions[column.ToString()];

                    htmlTable.Append(caption);
                    htmlTable.Append("</th>");
                }
                htmlTable.Append("</tr>");
            
            foreach (DataRow dr in dataTable.Rows)
            {
                htmlTable.Append("<tr>");
                foreach (DataColumn col in dataTable.Columns)
                {
                    htmlTable.Append("<td style='border:1px solid #abb2b7;'>");
                    htmlTable.Append(dr[col]);
                    htmlTable.Append("</td>");
                }
                htmlTable.Append("</tr>");
            }
            }
            else
            {
                htmlTable.Append("<table border='0' cellpadding='4' style='color:#000000;font:normal 13px arial,sans-serif;width:100%'>");
                foreach (DataRow dr in dataTable.Rows)
                {
                    htmlTable.Append("<tr>");
                    foreach (DataColumn col in dataTable.Columns)
                    {
                        htmlTable.Append("<td>");
                        htmlTable.Append(dr[col]);
                        htmlTable.Append("</td>");
                    }
                    htmlTable.Append("</tr>");
                }
            }
            htmlTable.Append("</table>");
            return htmlTable.ToString();
        }

        /// <summary>
        /// Convert multiple datatable to html table with table captions
        /// </summary>
        /// <param name="tables">DataTable</param>
        /// <param name="columnCaptions"></param>
        /// <returns>HTML Table string</returns>
        public static string ToHtmlTable(this Dictionary<string, DataTable> tables, Dictionary<string, string> columnCaptions = null)
        {
            var htmlTable = new StringBuilder();
            htmlTable.Append("<table border='0' cellpadding='4' style='color:#000000;font:normal 11px arial,sans-serif;border:1px solid #abb2b7;width:100%'>");

            var i = 0;
            foreach (var item in tables)
            {
                var tableCaption = item.Key;
                var dataTables = item.Value;

                if (i == 0)
                {
                    htmlTable.Append("<tr>");
                    foreach (var column in dataTables.Columns)
                    {
                        htmlTable.Append("<th style='color:#ffffff;font:bold 13px arial,sans-serif;white-space:nowrap;background-color:#7a8d96;border:1px solid #abb2b7;text-align:center'>");
                        var caption = column.ToString();
                        if (columnCaptions != null && columnCaptions.Any() && columnCaptions.TryGetValue(column.ToString(), out caption))
                            caption = columnCaptions[column.ToString()];

                        htmlTable.Append(caption);
                        htmlTable.Append("</th>");
                    }
                    htmlTable.Append("</tr>");
                }

                var columnCount = (columnCaptions != null && columnCaptions.Any()) ? columnCaptions.Count : dataTables.Columns.Count;

                //Tables caption
                htmlTable.Append("<tr>");
                htmlTable.Append("<th colspan='" + columnCount + "' style='color:#434d52;font:bold 13px arial,sans-serif;white-space:nowrap;background-color:#ebeff1;border:1px solid #abb2b7;text-align:center'>");
                htmlTable.Append(tableCaption);
                htmlTable.Append("</th>");
                htmlTable.Append("</tr>");

                if (dataTables.Rows.Count > 0)
                {
                    foreach (DataRow dr in dataTables.Rows)
                    {
                        htmlTable.Append("<tr>");
                        foreach (DataColumn col in dataTables.Columns)
                        {
                            htmlTable.Append("<td style='border:1px solid #abb2b7;'>");
                            htmlTable.Append(dr[col]);
                            htmlTable.Append("</td>");
                        }
                        htmlTable.Append("</tr>");
                    }
                }
                else
                {
                    htmlTable.Append("<tr><td colspan='" + columnCount + "' style='text-align:center;border:1px solid #abb2b7;'>No records found</td></tr>");
                }

                i++;
            }
            htmlTable.Append("</table>");

            return htmlTable.ToString();
        }

        /// <summary>
        /// Convert multiple datatable to html table with table captions
        /// </summary>
        /// <param name="tables">DataTable</param>
        /// <param name="columnCaptions"></param>
        /// <returns>HTML Table string</returns>
        public static string ToHtmlTableWithHeader(this Dictionary<string, DataTable> tables, Dictionary<string, string> columnCaptions = null)
        {
            var htmlTable = new StringBuilder();
            htmlTable.Append("<table border='0' cellpadding='4' style='color:#000000;font:normal 11px arial,sans-serif;border:1px solid #abb2b7;width:100%'>");

            var i = 0;
            foreach (var item in tables)
            {
                var tableCaption = item.Key;
                var dataTables = item.Value;
                var columnCount = (columnCaptions != null && columnCaptions.Any()) ? columnCaptions.Count : dataTables.Columns.Count;

                var tableHead = string.Format("<th colspan='{0}' style='color:white;font:bold 13px arial,sans-serif;white-space:nowrap;background-color:#7a8d96; border:1px solid #abb2b7;text-align:center'>", columnCount);

                //Tables caption
                htmlTable.Append("<tr>");
                htmlTable.Append(tableHead);
                htmlTable.Append(tableCaption);
                htmlTable.Append("</th>");
                htmlTable.Append("</tr>");
                if (i == 0)
                {
                    htmlTable.Append("<tr>");
                    foreach (var column in dataTables.Columns)
                    {
                        htmlTable.Append("<th style='color:#616567; font:bold 13px arial,sans-serif;white-space:nowrap;background-color:#d3d6d8; border:1px solid #abb2b7;text-align:center; width:2%;'>");
                        var caption = column.ToString();
                        if (columnCaptions != null && columnCaptions.Any() && columnCaptions.TryGetValue(column.ToString(), out caption))
                            caption = columnCaptions[column.ToString()];

                        htmlTable.Append(caption);
                        htmlTable.Append("</th>");
                    }
                    htmlTable.Append("</tr>");
                }

                if (dataTables.Rows.Count > 0)
                {
                    foreach (DataRow dr in dataTables.Rows)
                    {
                        htmlTable.Append("<tr>");
                        foreach (DataColumn col in dataTables.Columns)
                        {
                            htmlTable.Append("<td style='border:1px solid #abb2b7;'>");
                            htmlTable.Append(dr[col]);
                            htmlTable.Append("</td>");
                        }
                        htmlTable.Append("</tr>");
                    }
                }
                else
                {
                    htmlTable.Append("<tr><td colspan='" + columnCount + "' style='text-align:center;border:1px solid #abb2b7;'>No records found</td></tr>");
                }

                i++;
            }
            htmlTable.Append("</table>");

            return htmlTable.ToString();
        }

        /// <summary>
        /// Convert multiple datatable to html table with table captions
        /// </summary>
        /// <param name="tables">DataTable</param>
        /// <param name="columnCaptions"></param>
        /// <returns>HTML Table string</returns>
        public static string ToHtmlTableWithStyle(this Dictionary<string, DataTable> tables, Dictionary<string, string> columnCaptions = null, bool isTableCaption = true)
        {
            try
            {
                var columnCount = 0;
                var cssKey = "";

                var htmlTable = new StringBuilder();

                htmlTable.Append("<table border='0' cellpadding='4' style='color:#000000;font:normal 11px arial,sans-serif;border:1px solid #abb2b7;width:100%'>");

                var i = 0;
                foreach (var item in tables)
                {
                    var tableCaption = item.Key;
                    var dataTable = item.Value;

                    if (i == 0)
                    {
                        columnCount = (columnCaptions != null && columnCaptions.Any()) ? columnCaptions.Count : dataTable.Columns.Count;
                        cssKey = (columnCaptions != null && columnCaptions.Any()) ? columnCaptions.FirstOrDefault(p => p.Value.ToLower() == "css").Key : "";
                        if (!string.IsNullOrEmpty(cssKey))
                            columnCount = columnCaptions.Count - 1;

                        htmlTable.Append("<tr>");
                        foreach (var column in dataTable.Columns)
                        {
                            var caption = column.ToString();
                            if (columnCaptions != null && columnCaptions.Any() && columnCaptions.TryGetValue(column.ToString(), out caption))
                                caption = columnCaptions[column.ToString()];

                            if (string.IsNullOrEmpty(caption) || caption.ToLower() == "css")
                                continue;

                            htmlTable.Append("<th style='color:#ffffff;font:bold 13px arial,sans-serif;white-space:nowrap;background-color:#7a8d96;border:1px solid #abb2b7;text-align:center'>");
                            htmlTable.Append(caption);
                            htmlTable.Append("</th>");
                        }
                        htmlTable.Append("</tr>");
                    }

                    //Tables caption
                    if (isTableCaption)
                    {
                        htmlTable.Append("<tr>");
                        htmlTable.Append("<th colspan='" + columnCount + "' style='color:#434d52;font:bold 13px arial,sans-serif;white-space:nowrap;background-color:#ebeff1;border:1px solid #abb2b7;text-align:center'>");
                        htmlTable.Append(tableCaption);
                        htmlTable.Append("</th>");
                        htmlTable.Append("</tr>");
                    }

                    //Table Data
                    if (dataTable.Rows.Count > 0)
                    {
                        foreach (DataRow dr in dataTable.Rows)
                        {
                            htmlTable.Append("<tr>");
                            var css = string.Empty;
                            foreach (DataColumn col in dataTable.Columns)
                            {
                                var caption = col.ToString();
                                if (columnCaptions != null && columnCaptions.Any() && columnCaptions.TryGetValue(col.ToString(), out caption))
                                    caption = columnCaptions[col.ToString()];

                                if (string.IsNullOrEmpty(caption))
                                    continue;

                                if (!string.IsNullOrEmpty(cssKey) && cssKey.ToLower() == caption.ToLower())
                                //if (cssKey != null && cssKey == col.ToString())
                                {
                                    if (!string.IsNullOrEmpty(dr[col].ToString()))
                                        css = dr[col].ToString();
                                    continue;
                                }
                                htmlTable.Append("<td style='border:1px solid #abb2b7;" + css + "'>");
                                htmlTable.Append(dr[col]);
                                htmlTable.Append("</td>");
                            }
                            htmlTable.Append("</tr>");
                        }
                    }
                    else
                    {
                        htmlTable.Append("<tr><td colspan='" + columnCount + "' style='text-align:center;border:1px solid #abb2b7;'>No records found</td></tr>");
                    }

                    i++;
                }
                htmlTable.Append("</table>");

                return htmlTable.ToString();
            }
            catch (Exception)
            {

                throw;
            }
        }

    }

    public static class AttributesHelper
    {
        /// <summary>
        /// Method to stringify Emum value
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="value"></param>
        /// <returns></returns>
        public static string ToStringOfEnum<T>(this Enum value) where T : struct
        {
            if (Enum.IsDefined(typeof(T), value))
            {
                return ((T)(object)value).ToString();
            }
            return string.Empty;
        }

        /// <summary>
        /// Method to stringify Emum description
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static string ToDescription(this Enum value)
        {
            DescriptionAttribute[] da = (DescriptionAttribute[])(value.GetType().GetField(value.ToString())).GetCustomAttributes(typeof(DescriptionAttribute), false);
            return da.Length > 0 ? da[0].Description : value.ToString();
        }

        /// <summary>
        /// Method to convert value to enum
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="stringValue"></param>
        /// <param name="defaultValue"></param>
        /// <returns></returns>
        public static T ToEnum<T>(this string stringValue, T defaultValue)
        {
            foreach (T enumValue in Enum.GetValues(typeof(T)))
            {
                DescriptionAttribute[] da = (DescriptionAttribute[])(typeof(T).GetField(enumValue.ToString())).GetCustomAttributes(typeof(DescriptionAttribute), false);
                if (da.Length > 0 && da[0].Description == stringValue)
                    return enumValue;
            }
            return defaultValue;
        }
    }

    public static class StringExtension
    {
        /// <summary>
        /// Use the current thread's culture info for conversion
        /// </summary>
        public static string ToTitleCase(this string str)
        {
            if (string.IsNullOrEmpty(str))
                return string.Empty;
            var cultureInfo = System.Threading.Thread.CurrentThread.CurrentCulture;
            return cultureInfo.TextInfo.ToTitleCase(str.TrimAndLower());
        }

        /// <summary>
        /// Overload which uses the culture info with the specified name
        /// </summary>
        public static string ToTitleCase(this string str, string cultureInfoName)
        {
            if (string.IsNullOrEmpty(str))
                return string.Empty;
            var cultureInfo = new CultureInfo(cultureInfoName);
            return cultureInfo.TextInfo.ToTitleCase(str.TrimAndLower());
        }

        /// <summary>
        /// Overload which uses the specified culture info
        /// </summary>
        public static string ToTitleCase(this string str, CultureInfo cultureInfo)
        {
            if (string.IsNullOrEmpty(str))
                return string.Empty;
            return cultureInfo.TextInfo.ToTitleCase(str.TrimAndLower());
        }

        /// <summary>
        /// Method to get correct timestamp in the format - yyyyMMddHHmmssffff
        /// </summary>
        /// <param name="value"></param>
        /// <returns>timestamp</returns>
        public static string ToTimestamp(this DateTime value)
        {
            return value.ToString("yyyyMMddHHmmssffff");
        }
    }

    public static class DataTableExtensions
    {
        /// <summary>
        ///  Returns a data table created from data available in list
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="inputList"></param>
        /// <returns>DataTable</returns>
        public static DataTable ToDataTable<T>(this List<T> inputList)
        {
            var dataTable = new DataTable(typeof(T).Name);
            //Get all the properties
            var props = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance);
            foreach (var prop in props)
            {
                //Setting column names as Property names
                dataTable.Columns.Add(prop.Name);
            }
            foreach (var item in inputList)
            {
                var values = new object[props.Length];
                for (var i = 0; i < props.Length; i++)
                {
                    //inserting property values to data table rows
                    values[i] = props[i].GetValue(item, null);
                }
                dataTable.Rows.Add(values);
            }
            //put a breakpoint here and check data table
            return dataTable;
        }


        /// <summary>
        /// Method to convert dictionary to datatable
        /// </summary>
        /// <param name="parents"></param>
        /// <returns></returns>
        public static DataTable ToDataTable(this IDictionary<string, object> parents)
        {
            var table = new DataTable();

            table.Columns.Add("Key");
            table.Columns.Add("Value");
            foreach (KeyValuePair<string, object> item in parents)
            {
                DataRow row = table.NewRow();
                row["Key"] = item.Key;
                row["Value"] = item.Value;
                table.Rows.Add(row);
            }
            return table;
        }

        ///// <summary>
        /////  Returns a data table created from data available in dictionary
        ///// </summary>
        ///// <param name="parents"></param>
        ///// <returns>DataTable</returns>
        //public static DataTable ToDataTables(this IEnumerable<IDictionary<string, object>> parents)
        //{
        //    var table = new DataTable();

        //    foreach (var parent in parents)
        //    {
        //        var children = parent.Values
        //                             .OfType<IEnumerable<IDictionary<string, object>>>()
        //                             .ToArray();

        //        var length = children.Any() ? children.Length : 1;

        //        var parentEntries = parent.Where(x => x.Value is string)
        //                                  .Repeat(length)
        //                                  .ToLookup(x => x.Key, x => x.Value);
        //        var childEntries = children.SelectMany(x => x.First())
        //                                   .ToLookup(x => x.Key, x => x.Value);

        //        var allEntries = parentEntries.Concat(childEntries)
        //                                      .ToDictionary(x => x.Key, x => x.ToArray());

        //        var headers = allEntries.Select(x => x.Key)
        //                                .Except(table.Columns
        //                                             .Cast<DataColumn>()
        //                                             .Select(x => x.ColumnName))
        //                                .Select(x => new DataColumn(x))
        //                                .ToArray();

        //        table.Columns.AddRange(headers);

        //        var addedRows = new int[length];
        //        for (int i = 0; i < length; i++)
        //            addedRows[i] = table.Rows.IndexOf(table.Rows.Add());

        //        foreach (DataColumn col in table.Columns)
        //        {
        //            object[] columnRows;
        //            if (!allEntries.TryGetValue(col.ColumnName, out columnRows))
        //                continue;

        //            for (int i = 0; i < addedRows.Length; i++)
        //                table.Rows[addedRows[i]][col] = columnRows[i];
        //        }
        //    }

        //    return table;
        //}

        //public static IEnumerable<T> Repeat<T>(this IEnumerable<T> source, int times)
        //{
        //    source = source.ToArray();
        //    return Enumerable.Range(0, times).SelectMany(_ => source);
        //}

    }
}