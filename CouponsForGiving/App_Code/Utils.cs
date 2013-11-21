using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CouponsForGiving
{
    public enum MenuBarType
    {
        HomePage, Admin, Anonymous, Supporter, NPO, Merchant
    }

    public class EncryptionUtils
    {
        public static string Encrypt(string strToEncrypt)
        {
            string result = "";
            string unEnckey = WebConfigurationManager.AppSettings["EncKey"].ToString();
            string unEnckey2 = WebConfigurationManager.AppSettings["EncKey2"].ToString();

            byte[] bytes = Encoding.UTF8.GetBytes(strToEncrypt);
            SymmetricAlgorithm algo = SymmetricAlgorithm.Create();

            MemoryStream ms = new MemoryStream();
            byte[] rgbiv = Encoding.ASCII.GetBytes(unEnckey);
            byte[] key = Encoding.ASCII.GetBytes(unEnckey2);

            CryptoStream cs = new CryptoStream(ms, algo.CreateEncryptor(key, rgbiv), CryptoStreamMode.Write);
            cs.Write(bytes, 0, bytes.Length);
            cs.Close();

            result = Convert.ToBase64String(ms.ToArray());

            return result;
        }

        public static string Decrypt(string strToDecrypt)
        {
            string result = "";

            byte[] textBytes = Convert.FromBase64String(strToDecrypt);

            MemoryStream ms = new MemoryStream();
            SymmetricAlgorithm sa = SymmetricAlgorithm.Create();

            byte[] rgbiv = Encoding.ASCII.GetBytes(WebConfigurationManager.AppSettings["EncKey"].ToString());
            byte[] key = Encoding.ASCII.GetBytes(WebConfigurationManager.AppSettings["EncKey2"].ToString());

            CryptoStream cs = new CryptoStream(ms, sa.CreateDecryptor(key, rgbiv), CryptoStreamMode.Write);
            cs.Write(textBytes, 0, textBytes.Length);
            cs.Close();

            result = Encoding.UTF8.GetString(ms.ToArray());

            return result;
        }
    }

    public class RegexUtils
    {
        bool invalid = false;

        public bool IsValidEmail(string strIn)
        {
            invalid = false;
            if (String.IsNullOrEmpty(strIn))
                return false;

            // Use IdnMapping class to convert Unicode domain names. 
            try
            {
                strIn = Regex.Replace(strIn, @"(@)(.+)$", this.DomainMapper,
                                      RegexOptions.None, TimeSpan.FromMilliseconds(200));
            }
            catch (RegexMatchTimeoutException)
            {
                return false;
            }

            if (invalid)
                return false;

            // Return true if strIn is in valid e-mail format. 
            try
            {
                return Regex.IsMatch(strIn,
                      @"^(?("")(""[^""]+?""@)|(([0-9a-z]((\.(?!\.))|[-!#\$%&'\*\+/=\?\^`\{\}\|~\w])*)(?<=[0-9a-z])@))" +
                      @"(?(\[)(\[(\d{1,3}\.){3}\d{1,3}\])|(([0-9a-z][-\w]*[0-9a-z]*\.)+[a-z0-9]{2,17}))$",
                      RegexOptions.IgnoreCase, TimeSpan.FromMilliseconds(250));
            }
            catch (RegexMatchTimeoutException)
            {
                return false;
            }
        }

        private string DomainMapper(Match match)
        {
            // IdnMapping class with default property values.
            IdnMapping idn = new IdnMapping();

            string domainName = match.Groups[2].Value;
            try
            {
                domainName = idn.GetAscii(domainName);
            }
            catch (ArgumentException)
            {
                invalid = true;
            }
            return match.Groups[1].Value + domainName;
        }
    }
}