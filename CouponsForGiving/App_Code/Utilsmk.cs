using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.IO;
using System.Drawing;
using System.Drawing.Imaging;

namespace CouponsForGiving
{
    public class Utilsmk
    {
        public static string SaveNewLogo(HttpPostedFile file, int newid, HttpServerUtility server, string subdir)
        {
            string folderPath = server.MapPath("..\\Images\\" + subdir + "\\");
            folderPath = GetOrCreateFolder(folderPath + newid);

            // Get the name of the file to upload.
            string fileName = file.FileName;

            // Append the name of the file to upload to the path.
            string physPath = folderPath + @"\" + fileName;

            // Call the SaveAs method to save the uploaded
            // file to the specified directory.
            file.SaveAs(physPath);

            return ResolveVirtualPath(physPath);
        }

        public static string SaveNewCampaignImage(HttpPostedFile file, int npoid, HttpServerUtility server, int newid)
        {
            string folderPath = server.MapPath("~\\Images\\NPO\\");

            folderPath = GetOrCreateFolder(folderPath + npoid + "\\Campaigns\\" + newid);

            // Get the name of the file to upload.
            string fileName = file.FileName;

            // Append the name of the file to upload to the path.
            string physPath = folderPath + @"\" + fileName;

            // Call the SaveAs method to save the uploaded
            // file to the specified directory.
            file.SaveAs(physPath);
            return ResolveVirtualPath(physPath);
        }

        public static string SaveNewDealImage(HttpPostedFile file, int merchantid, HttpServerUtility server, string dealName)
        {
            string folderPath = server.MapPath("~\\Images\\Merchant\\");

            folderPath = GetOrCreateFolder(folderPath + merchantid + "\\Deals\\" + dealName);

            // Get the name of the file to upload.
            string fileName = file.FileName;

            // Append the name of the file to upload to the path.
            string physPath = folderPath + @"\" + fileName;

            // Call the SaveAs method to save the uploaded
            // file to the specified directory.
            file.SaveAs(physPath);
            return ResolveVirtualPath(physPath);
        }

        public static string ResolveVirtualPath(string physicalPath)
        {
            string virtualPath = "";

            string applicationPath = System.Web.Hosting.HostingEnvironment.MapPath("~/");
            virtualPath = physicalPath.Substring(applicationPath.Length).Replace(@"\", @"/");
            virtualPath = virtualPath.Replace(@"//", @"/");
            return virtualPath;
        }

        public static string GetOrCreateFolder(string folderPath)
        {
            string returnValue = "";

            if (Directory.Exists(folderPath))
                returnValue = folderPath;
            else
                returnValue = Directory.CreateDirectory(folderPath + @"\").FullName;

            return returnValue;
        }

        public static bool ValidUrl(string url)
        {
            try
            {
                return Regex.IsMatch(url,
                    @"(https:[/][/]|http:[/][/]|www.)[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(:[a-zA-Z0-9]*)?/?([a-zA-Z0-9\-\._\?\,\'/\\\+&amp;%\$#\=~])*$",
                    RegexOptions.IgnoreCase, TimeSpan.FromMilliseconds(250));
            }
            catch (RegexMatchTimeoutException)
            {
                return false;
            }
        }

        public static bool ValidPostal(string postal)
        {
            try
            {
                return Regex.IsMatch(postal,
                      @"(^\d{5}(-\d{4})?$)|(^[ABCEGHJKLMNPRSTVXYabceghjklmnprstvxy]{1}\d{1}[A-Za-z]{1} *\d{1}[A-Za-z]{1}\d{1}$)",
                      RegexOptions.IgnoreCase, TimeSpan.FromMilliseconds(250));
            }
            catch (RegexMatchTimeoutException)
            {
                return false;
            }
        }

        public static bool ValidImage(Stream image)
        {
            ImageFormat[] ValidFormats = new[] { ImageFormat.Jpeg, ImageFormat.Png, ImageFormat.Bmp, ImageFormat.Gif };

            try
            {
                using (var img = Image.FromStream(image))
                {
                    return ValidFormats.Contains(img.RawFormat);
                }
            }
            catch
            {
                return false;
            }
        }

        public static bool ValidLogoSize(int filesize)
        {
            int maxLogoSize = 4096; //kb
            filesize = filesize / 1024; //convert to kb
            if ((filesize < maxLogoSize) && (filesize > 0))
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        public static bool ValidPhone(string phone)
        {
            try
            {
                return Regex.IsMatch(phone,
                      @"^[0-9]{10,11}$",
                      RegexOptions.IgnoreCase, TimeSpan.FromMilliseconds(250));
            }
            catch (RegexMatchTimeoutException)
            {
                return false;
            }
        }

        public static bool ValidEmail(string email)
        {
            try
            {
                return Regex.IsMatch(email,
                      @"\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*",
                      RegexOptions.IgnoreCase, TimeSpan.FromMilliseconds(250));
            }
            catch (RegexMatchTimeoutException)
            {
                return false;
            }
        }
    }
}