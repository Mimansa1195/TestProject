//using Microsoft.Office.Interop.Word;
//using System;
//using System.IO;
//using WordToPDF;


//namespace MIS.Utilities.Helpers
//{
//    public static class WordToPDFConverter
//    {
//        /// <summary>
//        /// Method to convert word(doc or docs) file into PDF file
//        /// </summary>
//        /// <param name="fileNameWithExtn"></param>
//        /// <param name="sourceFilePath"></param>
//        /// <param name="destinationFilePath"></param>
//        public static string ConvertWordToPDF(string fileNameWithExtn,string sourceFilePath,string destinationFilePath)
//        {

//            Word2Pdf objWorPdf = new Word2Pdf();
//            var fromLocation = sourceFilePath +  fileNameWithExtn;
//            string fileExtension = Path.GetExtension(fileNameWithExtn);
//            string changeExtension = fileNameWithExtn.Replace(fileExtension, ".pdf");
//            if (fileExtension == ".doc" || fileExtension == ".docx")
//            {
//                object toLocation = destinationFilePath + changeExtension;
//                objWorPdf.InputLocation = fromLocation;
//                objWorPdf.OutputLocation = toLocation;
//                objWorPdf.Word2PdfCOnversion();
//                //Microsoft.Office.Interop.Word.Application word = new Microsoft.Office.Interop.Word.Application();

//                //object oMissing = System.Reflection.Missing.Value;

//                //// Get list of Word files in specified directory
//                //DirectoryInfo dirInfo = new DirectoryInfo(fromLocation);
//                ////FileInfo[] wordFiles = dirInfo.GetFiles("*.doc");

//                //word.Visible = false;
//                //word.ScreenUpdating = false;

//                ////foreach (FileInfo wordFile in wordFiles)
//                ////{
//                //    // Cast as Object for word Open method
//                //    Object filename = (Object)dirInfo.FullName;

//                //    // Use the dummy value as a placeholder for optional arguments
//                //    Document doc = word.Documents.Open(ref filename, ref oMissing,
//                //        ref oMissing, ref oMissing, ref oMissing, ref oMissing, ref oMissing,
//                //        ref oMissing, ref oMissing, ref oMissing, ref oMissing, ref oMissing,
//                //        ref oMissing, ref oMissing, ref oMissing, ref oMissing);
//                //    doc.Activate();

//                //    object outputFileName = dirInfo.FullName.Replace(".doc", ".pdf");
//                //    object fileFormat = WdSaveFormat.wdFormatPDF;

//                //    // Save document into PDF Format
//                //    doc.SaveAs(ref outputFileName,
//                //        ref fileFormat, ref oMissing, ref oMissing,
//                //        ref oMissing, ref oMissing, ref oMissing, ref oMissing,
//                //        ref oMissing, ref oMissing, ref oMissing, ref oMissing,
//                //        ref oMissing, ref oMissing, ref oMissing, ref oMissing);

//                // Close the Word document, but leave the Word application open.
//                // doc has to be cast to type _Document so that it will find the
//                // correct Close method.                
//                //                    object saveChanges = WdSaveOptions.wdDoNotSaveChanges;
//                //                    ((_Document)doc).Close(ref saveChanges, ref oMissing, ref oMissing);
//                //                    doc = null;


//                //// word has to be cast to type _Application so that it will find
//                //// the correct Quit method.
//                //((_Application)word).Quit(ref oMissing, ref oMissing, ref oMissing);
//                //                word = null;
//            }

//            return changeExtension;
//        }
//    }
//}
