using OfficeOpenXml;
using OfficeOpenXml.Style;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;

namespace MIS.Utilities.Helpers
{
    public static class ExportHelper
    {
        /// <summary>
        /// Convert multiple datatable into an excel file with grouped row captions and style and return in memory stream for sending to email
        /// </summary>
        /// <param name="tables">DataTables</param>
        /// <param name="columnCaptions">columnCaptions</param>
        /// <param name="fileName">fileName</param>
        /// <param name="sheetName">sheetName</param>
        /// <param name="isTitle">isTitle</param>
        /// <param name="fitWidthToContent">fitWidthToContent</param>
        /// <returns>Byte Stream</returns>
        public static MemoryStream ToExcelWithStyle(this Dictionary<string, DataTable> tables, Dictionary<string, string> columnCaptions = null, string fileName = "Report", string sheetName = "Sheet1", bool isTitle = true, bool isTableCaption = true, bool fitWidthToContent = true)
        {
            var first = tables.First();
            var columnCount = (columnCaptions != null && columnCaptions.Any()) ? columnCaptions.Count : first.Value.Columns.Count;

            var cssKey = (columnCaptions != null && columnCaptions.Any()) ? columnCaptions.FirstOrDefault(p => p.Value.ToLower() == "css").Key : "";
            if (!string.IsNullOrEmpty(cssKey))
                columnCount = columnCaptions.Count - 1;

            byte[] fileContents = null;

            using (var package = new ExcelPackage())
            {
                //File Summary
                package.Workbook.Properties.Author = "Gemini MIS";
                package.Workbook.Properties.Title = fileName;
                package.Workbook.Properties.Company = "Gemini Solutions Pvt. Ltd.";

                //Add sheet
                ExcelWorksheet ws = package.Workbook.Worksheets.Add(sheetName); //Sheet Name
                ws.Protection.AllowFormatColumns = true;
                ws.Protection.AllowFormatRows = true;
                //ws.View.ShowGridLines = true;

                //If you want to merge cells dynamically, you can also use:
                //worksheet.Cells[FromRow, FromColumn, ToRow, ToColumn].Merge = true; //Ok

                var row = 1;
                if (isTitle)
                {
                    using (ExcelRange title = ws.Cells[row, 1, row, columnCount])
                    {
                        title.Merge = true;
                        title.Style.Font.SetFromFont(new Font("Arial", 13, FontStyle.Bold));
                        title.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                        title.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                        title.Style.Fill.PatternType = ExcelFillStyle.Solid;
                        //title.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(216, 149, 81));
                        Color titleBgColFromHex = ColorTranslator.FromHtml("#487186");
                        title.Style.Fill.BackgroundColor.SetColor(titleBgColFromHex);
                        title.Style.Font.Color.SetColor(Color.White);

                        title.Style.Border.Top.Style = ExcelBorderStyle.Thin;
                        title.Style.Border.Left.Style = ExcelBorderStyle.Thin;
                        title.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                        title.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
                        //title.Style.TextRotation = 90;
                        title.Value = fileName.ToUpper();
                    }
                    //ws.View.FreezePanes(row, columnCount); // horizontal freeze
                    row++;
                }
                //To Freeze: ws.View.FreezePanes(noOfRows, noOfColumns), 
                //Eg: freeze only first row completely you can now call ws.View.FreezePanes(2, 1) 
                //i.e. row no. starts with 2
                ws.View.FreezePanes((row + 1), 1);

                var t = 0;
                foreach (var item in tables)
                {
                    var tableCaption = item.Key;
                    var dataTable = item.Value;

                    if (t == 0)
                    {
                        //Table Heading/Column Heading
                        var colNo = 1;
                        foreach (var column in dataTable.Columns)
                        {
                            var caption = column.ToString();
                            if (columnCaptions != null && columnCaptions.Any() && columnCaptions.TryGetValue(column.ToString(), out caption))
                                caption = columnCaptions[column.ToString()];

                            if (string.IsNullOrEmpty(caption) || caption.ToLower() == "css")
                                continue;

                            using (ExcelRange title = ws.Cells[row, colNo])
                            {
                                title.Style.Font.SetFromFont(new Font("Arial", 10, FontStyle.Bold));
                                title.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                                title.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                                title.Style.Fill.PatternType = ExcelFillStyle.Solid;
                                //title.Style.Fill.BackgroundColor.SetColor(System.Drawing.Color.FromArgb(216, 149, 81));
                                Color titleBgColFromHex = ColorTranslator.FromHtml("#487186");
                                title.Style.Fill.BackgroundColor.SetColor(titleBgColFromHex);
                                title.Style.Font.Color.SetColor(Color.White);

                                title.Style.Border.Top.Style = ExcelBorderStyle.Thin;
                                title.Style.Border.Left.Style = ExcelBorderStyle.Thin;
                                title.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                                title.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
                                //title.Style.TextRotation = 90;
                                title.Value = caption;
                            }
                            if (fitWidthToContent)
                                ws.Column(colNo).AutoFit();
                            else
                                ws.Column(colNo).Width = caption.Length + 8;
                            colNo++;
                        }
                        row++;
                    }

                    //Tables caption
                    if (isTableCaption)
                    {
                        using (ExcelRange caption = ws.Cells[row, 1, row, columnCount])
                        {
                            caption.Merge = true;
                            caption.Style.Font.SetFromFont(new Font("Arial", 10, FontStyle.Bold));
                            caption.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                            caption.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                            caption.Style.Fill.PatternType = ExcelFillStyle.Solid;
                            //title.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(216, 149, 81));
                            Color titleBgColFromHex = ColorTranslator.FromHtml("#EBEFF1");
                            caption.Style.Fill.BackgroundColor.SetColor(titleBgColFromHex);
                            Color titleColFromHex = ColorTranslator.FromHtml("#434D52");
                            caption.Style.Font.Color.SetColor(titleColFromHex);

                            caption.Style.Border.Top.Style = ExcelBorderStyle.Thin;
                            caption.Style.Border.Left.Style = ExcelBorderStyle.Thin;
                            caption.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                            caption.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
                            caption.Value = tableCaption;
                        }
                        row++;
                    }

                    //Table Value
                    if (dataTable.Rows.Count > 0)
                    {
                        foreach (DataRow dr in dataTable.Rows)
                        {
                            var bgColor = string.Empty;
                            var colNo = 1;
                            foreach (DataColumn col in dataTable.Columns)
                            {
                                var caption = col.ToString();
                                if (columnCaptions != null && columnCaptions.Any() && columnCaptions.TryGetValue(col.ToString(), out caption))
                                    caption = columnCaptions[col.ToString()];

                                if (string.IsNullOrEmpty(caption))
                                    continue;

                                if (!string.IsNullOrEmpty(cssKey) && cssKey.ToLower() == caption.ToLower())
                                {
                                    if (!string.IsNullOrEmpty(dr[col].ToString()))
                                    {
                                        var css = dr[col].ToString().TrimEnd(';');
                                        Dictionary<string, string> cssProperties = css.Split(';').Select(property => property.Split(':')).ToDictionary(pair => pair[0].Trim(), pair => pair[1].Trim());
                                        bgColor = cssProperties.FirstOrDefault(p => p.Key.ToLower() == "background-color" && p.Value.Contains("#")).Value;
                                    }
                                    continue;
                                }

                                //using (ExcelRange data = ws.Cells[row, 1, row, columnCount])
                                using (ExcelRange data = ws.Cells[row, colNo])
                                {
                                    data.Style.Font.SetFromFont(new Font("Arial", 10, FontStyle.Regular));
                                    data.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                                    data.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                                    if (!string.IsNullOrEmpty(bgColor))
                                    {
                                        data.Style.Fill.PatternType = ExcelFillStyle.Solid;
                                        var dataBgColFromHex = ColorTranslator.FromHtml(bgColor);
                                        data.Style.Fill.BackgroundColor.SetColor(dataBgColFromHex);
                                    }

                                    data.Style.Border.Top.Style = ExcelBorderStyle.Thin;
                                    data.Style.Border.Left.Style = ExcelBorderStyle.Thin;
                                    data.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                                    data.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
                                    data.Value = dr[col];
                                }
                                if (fitWidthToContent)
                                    ws.Column(colNo).AutoFit();
                                else
                                    ws.Column(colNo).Style.WrapText = true;
                                colNo++;
                            }
                            row++;
                        }
                    }
                    else
                    {
                        using (ExcelRange data = ws.Cells[row, 1, row, columnCount])
                        {
                            data.Merge = true;
                            data.Style.Font.SetFromFont(new Font("Arial", 10, FontStyle.Regular));
                            data.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                            data.Style.VerticalAlignment = ExcelVerticalAlignment.Center;

                            data.Style.Border.Top.Style = ExcelBorderStyle.Thin;
                            data.Style.Border.Left.Style = ExcelBorderStyle.Thin;
                            data.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                            data.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;

                            data.Value = "No records found";
                        }
                        row++;
                    }
                    t++;
                }
                fileContents = package.GetAsByteArray();
            }
            return new MemoryStream(fileContents);
        }

        /// <summary>
        /// Convert multiple datatable into an excel file with grouped row captions and save in local folder
        /// </summary>
        /// <param name="tables">DataTables</param>
        /// <param name="columnCaptions">columnCaptions</param>
        /// <param name="fileName">fileName</param>
        /// <param name="sheetName">sheetName</param>
        /// <param name="downloadPath">downloadPath</param>
        /// <param name="isTitle">isTitle</param>
        /// <param name="fitWidthToContent">fitWidthToContent</param>
        public static void ToExcelWithStyleAndSaveFile(this Dictionary<string, DataTable> tables, Dictionary<string, string> columnCaptions = null, string fileName = "Report", string sheetName = "Sheet1", string downloadPath = "", bool isTitle = true, bool isTableCaption = true, bool fitWidthToContent = true)
        {
            var first = tables.First();
            var columnCount = (columnCaptions != null && columnCaptions.Any()) ? columnCaptions.Count : first.Value.Columns.Count;
            var cssKey = (columnCaptions != null && columnCaptions.Any()) ? columnCaptions.FirstOrDefault(p => p.Value.ToLower() == "css").Key : "";
            if (!string.IsNullOrEmpty(cssKey))
                columnCount = columnCaptions.Count - 1;

            byte[] fileContents = null;

            using (var package = new ExcelPackage())
            {
                //File Summary
                package.Workbook.Properties.Author = "Gemini MIS";
                package.Workbook.Properties.Title = fileName;
                package.Workbook.Properties.Company = "Gemini Solutions Pvt. Ltd.";

                //Add sheet
                ExcelWorksheet ws = package.Workbook.Worksheets.Add(sheetName); //Sheet Name
                ws.Protection.AllowFormatColumns = true;
                ws.Protection.AllowFormatRows = true;
                //ws.View.ShowGridLines = true;

                //If you want to merge cells dynamically, you can also use:
                //worksheet.Cells[FromRow, FromColumn, ToRow, ToColumn].Merge = true; //Ok

                var row = 1;
                if (isTitle)
                {
                    using (ExcelRange title = ws.Cells[row, 1, row, columnCount])
                    {
                        title.Merge = true;
                        title.Style.Font.SetFromFont(new Font("Arial", 13, FontStyle.Bold));
                        title.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                        title.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                        title.Style.Fill.PatternType = ExcelFillStyle.Solid;
                        //title.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(216, 149, 81));
                        Color titleBgColFromHex = ColorTranslator.FromHtml("#487186");
                        title.Style.Fill.BackgroundColor.SetColor(titleBgColFromHex);
                        title.Style.Font.Color.SetColor(Color.White);

                        title.Style.Border.Top.Style = ExcelBorderStyle.Thin;
                        title.Style.Border.Left.Style = ExcelBorderStyle.Thin;
                        title.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                        title.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
                        //title.Style.TextRotation = 90;
                        title.Value = fileName.ToUpper();
                    }
                    //ws.View.FreezePanes(row, columnCount); // horizontal freeze
                    row++;
                }
                //To Freeze: ws.View.FreezePanes(noOfRows, noOfColumns), 
                //Eg: freeze only first row completely you can now call ws.View.FreezePanes(2, 1) 
                //i.e. row no. starts with 2
                ws.View.FreezePanes((row + 1), 1);

                var t = 0;
                foreach (var item in tables)
                {
                    var tableCaption = item.Key;
                    var dataTable = item.Value;

                    if (t == 0)
                    {
                        //Table Heading/Column Heading
                        var colNo = 1;
                        foreach (var column in dataTable.Columns)
                        {
                            var caption = column.ToString();
                            if (columnCaptions != null && columnCaptions.Any() && columnCaptions.TryGetValue(column.ToString(), out caption))
                                caption = columnCaptions[column.ToString()];

                            if (string.IsNullOrEmpty(caption) || caption.ToLower() == "css")
                                continue;

                            using (ExcelRange title = ws.Cells[row, colNo])
                            {
                                title.Style.Font.SetFromFont(new Font("Arial", 10, FontStyle.Bold));
                                title.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                                title.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                                title.Style.Fill.PatternType = ExcelFillStyle.Solid;
                                //title.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(216, 149, 81));
                                Color titleBgColFromHex = ColorTranslator.FromHtml("#487186");
                                title.Style.Fill.BackgroundColor.SetColor(titleBgColFromHex);
                                title.Style.Font.Color.SetColor(Color.White);

                                title.Style.Border.Top.Style = ExcelBorderStyle.Thin;
                                title.Style.Border.Left.Style = ExcelBorderStyle.Thin;
                                title.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                                title.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
                                //title.Style.TextRotation = 90;
                                title.Value = caption;
                            }
                            if (fitWidthToContent)
                                ws.Column(colNo).AutoFit();
                            else
                                ws.Column(colNo).Width = caption.Length + 8;

                            colNo++;
                        }
                        row++;
                    }


                    //Tables caption
                    if (isTableCaption)
                    {
                        using (ExcelRange caption = ws.Cells[row, 1, row, columnCount])
                        {
                            caption.Merge = true;
                            caption.Style.Font.SetFromFont(new Font("Arial", 10, FontStyle.Bold));
                            caption.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                            caption.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                            caption.Style.Fill.PatternType = ExcelFillStyle.Solid;
                            //title.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(216, 149, 81));
                            Color titleBgColFromHex = ColorTranslator.FromHtml("#EBEFF1");
                            caption.Style.Fill.BackgroundColor.SetColor(titleBgColFromHex);
                            Color titleColFromHex = ColorTranslator.FromHtml("#434D52");
                            caption.Style.Font.Color.SetColor(titleColFromHex);

                            caption.Style.Border.Top.Style = ExcelBorderStyle.Thin;
                            caption.Style.Border.Left.Style = ExcelBorderStyle.Thin;
                            caption.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                            caption.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
                            caption.Value = tableCaption;
                        }
                        row++;
                    }

                    //Table Value
                    if (dataTable.Rows.Count > 0)
                    {
                        foreach (DataRow dr in dataTable.Rows)
                        {
                            var bgColor = string.Empty;
                            var colNo = 1;
                            foreach (DataColumn col in dataTable.Columns)
                            {
                                var caption = col.ToString();
                                if (columnCaptions != null && columnCaptions.Any() && columnCaptions.TryGetValue(col.ToString(), out caption))
                                    caption = columnCaptions[col.ToString()];

                                if (string.IsNullOrEmpty(caption))
                                    continue;

                                if (!string.IsNullOrEmpty(cssKey) && cssKey.ToLower() == caption.ToLower())
                                {
                                    if (!string.IsNullOrEmpty(dr[col].ToString()))
                                    {
                                        var css = dr[col].ToString().TrimEnd(';');
                                        Dictionary<string, string> cssProperties = css.Split(';').Select(property => property.Split(':')).ToDictionary(pair => pair[0].Trim(), pair => pair[1].Trim());
                                        bgColor = cssProperties.FirstOrDefault(p => p.Key.ToLower() == "background-color" && p.Value.Contains("#")).Value;
                                    }
                                    continue;
                                }

                                //using (ExcelRange data = ws.Cells[row, 1, row, columnCount])
                                using (ExcelRange data = ws.Cells[row, colNo])
                                {
                                    data.Style.Font.SetFromFont(new Font("Arial", 10, FontStyle.Regular));
                                    data.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                                    data.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                                    if (!string.IsNullOrEmpty(bgColor))
                                    {
                                        data.Style.Fill.PatternType = ExcelFillStyle.Solid;
                                        var dataBgColFromHex = ColorTranslator.FromHtml(bgColor);
                                        data.Style.Fill.BackgroundColor.SetColor(dataBgColFromHex);
                                    }

                                    data.Style.Border.Top.Style = ExcelBorderStyle.Thin;
                                    data.Style.Border.Left.Style = ExcelBorderStyle.Thin;
                                    data.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                                    data.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
                                    data.Value = dr[col];
                                }
                                if (fitWidthToContent)
                                    ws.Column(colNo).AutoFit();
                                else
                                    ws.Column(colNo).Style.WrapText = true;

                                colNo++;
                            }
                            row++;
                        }
                    }
                    else
                    {
                        using (ExcelRange data = ws.Cells[row, 1, row, columnCount])
                        {
                            data.Merge = true;
                            data.Style.Font.SetFromFont(new Font("Arial", 10, FontStyle.Regular));
                            data.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                            data.Style.VerticalAlignment = ExcelVerticalAlignment.Center;

                            data.Style.Border.Top.Style = ExcelBorderStyle.Thin;
                            data.Style.Border.Left.Style = ExcelBorderStyle.Thin;
                            data.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                            data.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;

                            data.Value = "No records found";
                        }
                        row++;
                    }
                    t++;
                }
                fileContents = package.GetAsByteArray();
            }

            //downloadPath = downloadPath + "\\" + fileName + ".xlsx";
            downloadPath = Path.Combine(downloadPath, fileName.Replace(":", "-") + ".xlsx");

            //Write it back to the client    
            if (File.Exists(downloadPath))
            {
                var filestream = new FileStream(downloadPath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
                filestream.Close();
                File.Delete(downloadPath);
            }

            //Create excel file on physical disk    
            FileStream objFileStrm = File.Create(downloadPath);
            objFileStrm.Close();

            //Write content to excel file    
            File.WriteAllBytes(downloadPath, fileContents);
        }

        /// <summary>
        /// Convert DataTable To Excel and return in memory stream for sending to email
        /// </summary>
        /// <param name="dataTable"></param>
        /// <param name="fileName"></param>
        /// <param name="sheetName"></param>
        /// <returns></returns>
        public static MemoryStream DataTableToExcelXlsx(DataTable dataTable, string fileName, string sheetName) //OK
        {
            MemoryStream stream = new MemoryStream();
            ExcelPackage package = new ExcelPackage();

            //File Summary
            package.Workbook.Properties.Author = "Gemini MIS";
            package.Workbook.Properties.Title = fileName;
            package.Workbook.Properties.Company = "Gemini Solutions Pvt. Ltd.";

            //Add sheet
            ExcelWorksheet sheet = package.Workbook.Worksheets.Add(sheetName); //Sheet Name

            //Use LoadFromCollection or LoadFromDatatable
            /*
            int col = 1;
            int row = 1;
            foreach (DataRow rw in table.Rows)
            {
                foreach (DataColumn cl in table.Columns)
                {
                    if (rw[cl.ColumnName] != DBNull.Value)
                        ws.Cells[row, col].Value = rw[cl.ColumnName].ToString();
                    col++;
                }
                row++;
                col = 1;
            }
            */
            sheet.Cells["A1"].LoadFromDataTable(dataTable, true); //true generates headers
            //sheet.Cells["A1"].LoadFromDataTable(dataTable, true, OfficeOpenXml.Table.TableStyles.Medium6);

            package.SaveAs(stream);
            return stream;
        }

        /// <summary>
        /// Convert DataTable into excel and write file to local directory
        /// </summary>
        /// <param name="dataTable"></param>
        /// <param name="fileName"></param>
        /// <param name="sheetName"></param>
        /// <param name="downloadPath"></param>
        public static void ConvertToExcelAndSaveFile(DataTable dataTable, string fileName, string sheetName, string downloadPath) //OK
        {
            byte[] fileContents = null;
            using (var package = new ExcelPackage())
            {
                //File Summary
                package.Workbook.Properties.Author = "Gemini MIS";
                package.Workbook.Properties.Title = fileName;
                package.Workbook.Properties.Company = "Gemini Solutions Pvt. Ltd.";

                //Add sheet
                ExcelWorksheet sheet = package.Workbook.Worksheets.Add(sheetName); //Sheet Name
                sheet.Cells["A1"].LoadFromDataTable(dataTable, true); //true generates headers
                //sheet.Cells["A1"].LoadFromDataTable(dataTable, true, OfficeOpenXml.Table.TableStyles.Medium6);
                fileContents = package.GetAsByteArray();
            }

            //downloadPath = downloadPath + "\\" + fileName + ".xlsx";
            downloadPath = Path.Combine(downloadPath, fileName.Replace(":", "-") + ".xlsx");

            //Write it back to the client    
            if (File.Exists(downloadPath))
                File.Delete(downloadPath);

            //Create excel file on physical disk    
            FileStream objFileStrm = File.Create(downloadPath);
            objFileStrm.Close();

            //Write content to excel file    
            File.WriteAllBytes(downloadPath, fileContents);
        }

        /// <summary>
        /// Download Excel file
        /// </summary>
        /// <param name="dataTable"></param>
        /// <param name="fileName"></param>
        /// <param name="sheetName"></param>
        /// <returns></returns>
        public static byte[] DownloadExcelXlsx(DataTable dataTable, string fileName, string sheetName)
        {
            byte[] fileContents = null;
            using (var package = new ExcelPackage())
            {
                //File Summary
                package.Workbook.Properties.Author = "Gemini MIS";
                package.Workbook.Properties.Title = fileName;
                package.Workbook.Properties.Company = "Gemini Solutions Pvt. Ltd.";

                //Add sheet
                ExcelWorksheet sheet = package.Workbook.Worksheets.Add(sheetName); //Sheet Name
                //true generates headers
                sheet.Cells["A1"].LoadFromDataTable(dataTable, true);
                //sheet.Cells["A1"].LoadFromDataTable(dataTable, true, OfficeOpenXml.Table.TableStyles.Medium6);
                //sheet.Cells["A1"].LoadFromDataTable(dataTable, true); //true generates headers
                //sheet.Cells["A1"].LoadFromDataTable(dataTable, true, OfficeOpenXml.Table.TableStyles.Medium6);
                fileContents = package.GetAsByteArray();
            }

            return fileContents;
        }

        /// <summary>
        /// Download Excel file
        /// </summary>
        /// <param name="dataTable"></param>
        /// <param name="fileName"></param>
        /// <param name="sheetName"></param>
        /// <returns></returns>
        public static byte[] ExportExcel(DataTable dataTable, string fileName, string sheetName)
        {
            var ms = new MemoryStream();
            using (var xlPackage = new ExcelPackage(ms))
            {
                //File Summary
                xlPackage.Workbook.Properties.Author = "Gemini MIS";
                xlPackage.Workbook.Properties.Title = fileName;
                xlPackage.Workbook.Properties.Company = "Gemini Solutions Pvt. Ltd.";

                var wb = xlPackage.Workbook;
                var ws = wb.Worksheets.Add(sheetName);
                ws.Cells.LoadFromDataTable(dataTable, true);

                xlPackage.Save();
                return ms.ToArray();
            }
            return null;
        }

        /// <summary>
        /// Converts simple excel sheet containing text and number into DataTable.
        /// </summary>
        /// <param name="oSheet"></param>
        /// <returns></returns>
        public static DataTable WorksheetToDataTable(ExcelWorksheet oSheet)
        {
            int totalRows = oSheet.Dimension.End.Row;
            int totalCols = oSheet.Dimension.End.Column;
            DataTable dt = new DataTable(oSheet.Name);
            DataRow dr = null;
            for (int i = 1; i <= totalRows; i++)
            {
                if (i > 1) dr = dt.Rows.Add();
                for (int j = 1; j <= totalCols; j++)
                {
                    if (i == 1)
                        dt.Columns.Add(oSheet.Cells[i, j].Value.ToString());
                    else
                        dr[j - 1] = oSheet.Cells[i, j].Value.ToString();
                }
            }
            return dt;
        }

        //public static MemoryStream DataTableToExcelXlsx(DataTable dataTable, string fileName, string sheetName)
        //{
        //    using (ExcelPackage package = new ExcelPackage())
        //    {
        //        //File Summary
        //        package.Workbook.Properties.Author = "Gemini MIS";
        //        package.Workbook.Properties.Title = fileName;
        //        package.Workbook.Properties.Company = "Gemini Solutions Pvt. Ltd.";

        //        var ws = package.Workbook.Worksheets.Add(sheetName); //Sheet Name

        //        //Use LoadFromCollection or LoadFromDatatable
        //        ws.Cells["A1"].LoadFromDataTable(dataTable, true); //true generates headers

        //        var stream = new MemoryStream();
        //        package.SaveAs(stream);

        //        var excelFileName = fileName+ ".xlsx";
        //        string contentType = MediaTypes.Excel;
        //        stream.Position = 0;

        //        return File.File(stream, contentType, fileName);

        //        //SendExcel(server, recipientList);
        //    }
        //}

        //static void SendExcel(string server, string recipientList)
        //{
        //    //Send the file
        //    var message = new MailMessage("logMailer@contoso.com", recipientList);
        //    message.Subject = "Some Data";
        //    Attachment data = new Attachment(stream, name, contentType);
        //    // Add the attachment to the message.
        //    message.Attachments.Add(data);
        //    // Send the message.
        //    // Include credentials if the server requires them.
        //    var client = new SmtpClient(server);
        //    client.Credentials = CredentialCache.DefaultNetworkCredentials;
        //    client.Send(message);
        //}

        //public void SaveToExcel(List<Response> responses)
        //{
        //    string responsePath = Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().Location) + "\\Responses";

        //    DataTable table = new DataTable();
        //    table.Columns.Add("Response", typeof(string));
        //    table.Columns.Add("ResponseDate", typeof(DateTime));
        //    table.Columns.Add("CellNumber", typeof(string));

        //    foreach (var response in responses)
        //        table.Rows.Add(response.Response, response.ResponseDate, response.CellNumber);

        //    string filename = DateTime.Now.ToString("yyyy-MM-dd HHmmssfff") + ".xlsx";
        //    filename = Path.Combine(responsePath, filename);
        //    Directory.CreateDirectory(responsePath);

        //    using (var stream = new FileStream(filename, FileMode.Create, FileAccess.Write, FileShare.None, 0x2000, false))
        //    {
        //        using (ExcelPackage pck = new ExcelPackage(stream))
        //        {
        //            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("Responses");
        //            ws.Cells["A1"].LoadFromDataTable(table, true);
        //            pck.Save();
        //        }
        //    }
        //}


        ///// <summary>
        ///// Transforms a dataTable into Excel (xls). Requires Excel Library
        ///// </summary>
        ///// Usage: byte[] excel_sales = dataTable.CreateExcel("Sales");
        /////        byte[] excel_customer = dataTable.CreateExcel("Customer");
        ///// <param name="workSheetName">Set a name for the WorkSheet. If not given, the same name of the DataTable is set</param>
        ///// <returns></returns>
        //public static byte[] CreateExcel(this System.Data.DataTable dt, string workSheetName)
        //{
        //    byte[] excel = null;

        //    if (dt != null && dt.Rows.Count > 0)
        //    {
        //        // If a name has not been set for the WorkSheet, the name of the DataTable is set
        //        if (string.IsNullOrEmpty(workSheetName)) workSheetName = dt.TableName;

        //        // Create a new Workbook
        //        ExcelLibrary.SpreadSheet.Workbook workbook = new ExcelLibrary.SpreadSheet.Workbook();
        //        // Creates a new Worksheet
        //        ExcelLibrary.SpreadSheet.Worksheet worksheet = new ExcelLibrary.SpreadSheet.Worksheet(workSheetName);

        //        // Generates the columns excel according to the columns of the DataTable
        //        for (int i = 0; i < dt.Columns.Count; i++)
        //        {
        //            // The first line will contain excel column names of DataTable
        //            worksheet.Cells[0, i] = new ExcelLibrary.SpreadSheet.Cell(dt.Columns[i].ColumnName);
        //            // Sets the column width
        //            worksheet.Cells.ColumnWidth[0, (ushort)i] = 3000;
        //        }

        //        // Generates rows with records from DataTable
        //        for (int i = 0; i < dt.Rows.Count; i++)
        //        {
        //            for (int j = 0; j < dt.Columns.Count; j++)
        //            {
        //                // Inserts the data in the DataTable rows and columns in Excel
        //                worksheet.Cells[i + 1, j] = new ExcelLibrary.SpreadSheet.Cell(dt.Rows[i][j].ToString());
        //            }
        //        }

        //        // Insert blank lines to avoid error in excel file when the number of records is very small
        //        if (dt.Rows.Count < 100)
        //        {
        //            for (int i = dt.Rows.Count + 1; i < (100 + dt.Rows.Count); i++)
        //            {
        //                worksheet.Cells[i, 0] = new ExcelLibrary.SpreadSheet.Cell("");
        //            }
        //        }

        //        // Adds the Worksheet to Workbook
        //        workbook.Worksheets.Add(worksheet);

        //        // Generates the file in memory
        //        MemoryStream stream = new MemoryStream();
        //        workbook.Save(stream);

        //        // Returns a byte array of Excel
        //        excel = stream.ToArray();
        //    }

        //    return excel;
        //}

        ///// <summary>
        ///// Transforms a dataTable into Excel (xls). Requires Excel Library
        ///// </summary>
        ///// <returns></returns>
        //public static byte[] CreateExcel(this System.Data.DataTable dt)
        //{
        //    return CreateExcel(dt, string.Empty);
        //}

        /*
         * Excel conversion to HTML

            int colSpan = 1;
            int rowSpan = 1;

            //check if this is the start of a merged cell
            ExcelAddress cellAddress = new ExcelAddress(currentCell.Address);

            var mCellsResult = (from c in worksheet.MergedCells 
                        let addr = new ExcelAddress(c)
                            where cellAddress.Start.Row >= addr.Start.Row &&
                            cellAddress.End.Row <= addr.End.Row &&
                            cellAddress.Start.Column >= addr.Start.Column &&
                            cellAddress.End.Column <= addr.End.Column 
                        select addr);

            if (mCellsResult.Count() >0)
            {
            var mCells = mCellsResult.First();

            //if the cell and the merged cell do not share a common start address then skip this cell as it's already been covered by a previous item
            if (mCells.Start.Address != cellAddress.Start.Address)
                continue;

            if(mCells.Start.Column != mCells.End.Column) {
                colSpan += mCells.End.Column - mCells.Start.Column;
            }

            if (mCells.Start.Row != mCells.End.Row)
            {
                rowSpan += mCells.End.Row - mCells.Start.Row;
            }
            }

            //load up data
            html += String.Format("<td colspan={0} rowspan={1}>{2}</td>", colSpan, rowSpan, currentCell.Value);

        */

        /*
        public void WriteExcelWithNPOI(DataTable dt, String extension)
      {
           
          IWorkbook workbook;          
 
          if (extension == "xlsx") {
              workbook = new XSSFWorkbook();                
          }
          else if (extension == "xls")
          {
              workbook = new HSSFWorkbook();
          }
          else {
              throw new Exception("This format is not supported");
          }
           
          ISheet sheet1 = workbook.CreateSheet("Sheet 1");
           
          //make a header row
          IRow row1 = sheet1.CreateRow(0);
 
          for (int j = 0; j < dt.Columns.Count; j++)
          {
 
              ICell cell = row1.CreateCell(j);
              String columnName = dt.Columns[j].ToString();
              cell.SetCellValue(columnName);
          }
 
          //loops through data
          for (int i = 0; i < dt.Rows.Count; i++)
          {
              IRow row = sheet1.CreateRow(i + 1);
              for (int j = 0; j < dt.Columns.Count; j++)
              {
 
                  ICell cell = row.CreateCell(j);
                  String columnName = dt.Columns[j].ToString();
                  cell.SetCellValue(dt.Rows[i][columnName].ToString());
              }
          }
 
          using (var exportData = new MemoryStream())
          { 
              Response.Clear();                
              workbook.Write(exportData);
              if (extension == "xlsx") //xlsx file format
              {
                  Response.ContentType = MediaTypes.Excel;
                  Response.AddHeader("Content-Disposition", string.Format("attachment;filename={0}", "ContactNPOI.xlsx"));                   
                  Response.BinaryWrite(exportData.ToArray());             
              }
              else if (extension == "xls")  //xls file format
              { 
                  Response.ContentType = "application/vnd.ms-excel";
                  Response.AddHeader("Content-Disposition", string.Format("attachment;filename={0}", "ContactNPOI.xls"));
                  Response.BinaryWrite(exportData.GetBuffer());
              }   
              Response.End();
          }
      }
        */
    }
}
