using CouponsForGiving.Data;
using GoogleQRGenerator;
using iTextSharp.text;
using iTextSharp.text.html.simpleparser;
using iTextSharp.text.pdf;
//using iTextSharp.text;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Configuration;
using System.Web.Script.Serialization;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

namespace CouponsForGiving
{
    public enum MenuBarType
    {
        HomePage, Admin, Anonymous, Supporter, NPO, Merchant
    }

    public enum ShareType
    {
        Campaign, Profile, Generic
    }

    public enum CampaignType
    {
        Campaign, Offer
    }

    public enum RegisterEmailType
    {
        User,
        Merchant,
        NPO
    }

    public class StringUtils
    {
        public static string FormatPhoneNumber(string phoneNumber)
        {
            string result = "";

            int length = phoneNumber.Trim().Length;

            switch (length)
            {
                case 7:
                    result = Convert.ToInt64(phoneNumber).ToString("###-####");
                    break;

                case 10:
                    result = Convert.ToInt64(phoneNumber).ToString("(###) ###-####");
                    break;

                case 11:
                    result = Convert.ToInt64(phoneNumber).ToString("# (###) ###-####");
                    break;

                default:
                    result = phoneNumber;
                    break;
            }

            return result;
        }
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

    public class WebServices
    {
        public static string GetGoogleURL(string urlToShorten)
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create("https://www.googleapis.com/urlshortener/v1/url/");
            request.Method = "POST";
            request.ContentType = "application/json";
            string data = "{ \"longUrl\" : \"" + urlToShorten + "\"}";
            StreamWriter sw = new StreamWriter(request.GetRequestStream());
            sw.Write(data);
            sw.Close();

            HttpWebResponse response = (HttpWebResponse)request.GetResponse();

            using (StreamReader sr = new StreamReader(request.GetResponse().GetResponseStream()))
            {
                data = "";
                data = sr.ReadToEnd();
            }

            JavaScriptSerializer jss = new JavaScriptSerializer();
            dynamic d = jss.Deserialize<dynamic>(data);
            object value = ((Dictionary<string, object>)d)["id"].ToString();

            return value.ToString();
        }
    }

    public class HttpRendering
    {
        /// <summary>
        /// Outputs a string for user on the NPO Campaign Page.
        /// </summary>
        /// <param name="deals">The list of deals to show.</param>
        /// <returns>An http string</returns>
        public static string ListCampaignDeals(List<DealInstance> deals)
        {
            string result = "";

            if (deals != null)
                if (deals.Count > 0)
                {
                    foreach (DealInstance item in deals)
                    {
		                result += "<div class=\"thirds\"><!-- Wrap with a third to control size/spacing of tiles -->";
                        result += "<article class=\"c4g-coupon-tile\">";
                        result += "<img src=\"../../Images/c4g_coupon_logo.png\" class=\"coupon_c4g_logo\" /></a>";
                        result += "<div class=\"coupon-title-tile\">";
                        result += "<h2><a href=\"../../Default/DealPage.aspx?merchantname=" + item.Deal.Merchant.Name + "&deal=" + item.Deal.Name + "\">" + item.Deal.Name + "</a></h2><!-- Merchant Offer -->";
                        result += "<h3><a href=\"../../Default/MerchantPage.aspx?MerchantName=" + item.Deal.Merchant.Name + "\">" + item.Deal.Merchant.Name + "</a></h3><!-- Merchant Name -->";
                        result += "<span class=\"campaign-frame\">";
                        result += "<a href=\"../../Default/DealPage.aspx?merchantname=" + item.Deal.Merchant.Name + "&deal=" + item.Deal.Name + "\"><img src=\"../../" + item.Deal.ImageURL + "\" /></a>";
                        result += "</span>";
                        result +="<div class=\"campaign-details-tile\">";
                        result += "<p>" + item.Deal.DealDescription + "</p><!-- Merchant Offer Description -->";
                        result += "<p><strong>Price You Pay:</strong> <span>$80</span><br /> <!-- Offer Price -->";
                        result += "<strong>Value of Deal:</strong> <em>$" + ((int)(item.Deal.Prices.FirstOrDefault<Price>().RetailValue)).ToString("D") + "</em><!-- Offer Value --> <br />";
                        result += "<strong>You're Giving:</strong> <span>$" + ((int)(item.Deal.Prices.FirstOrDefault<Price>().NPOSplit)).ToString("D") + "</span><!-- Donation Value --> <br />";
                        result += "<strong>Discount:</strong> <span>$" + (1 - (item.Deal.Prices.FirstOrDefault<Price>().GiftValue / item.Deal.Prices.FirstOrDefault<Price>().RetailValue)).ToString("0%") + "</span><!-- Discount Value --> <br />";
                        result += "<strong>Coupons Left :</strong>" + (item.Deal.AbsoluteCouponLimit - item.PurchaseOrders.Count()) + "<span></span></p>";
                        result += "</div><!--Close Coupon Details Title -->";
                        result += "<a href=\"../../Offers/" + item.Deal.Merchant.Name + "/" + item.Deal.Name + "\" class=\"btn-coupon\"><i class=\"fa fa-shopping-cart\"></i> BUY NOW</a>";
                        result += "</article>";
                        result += "</div><!-- First Coupon -->";
                    }
                }
                else
                    result = "<p>We currently have no Merchant Offers. <strong>Please check back soon.</strong></p>";

            return result;
        }

        public static string ListCampaignDealsForNPO(List<DealInstance> deals)
        {
            string result = "";

            if (deals != null)
                if (deals.Count > 0)
                {
                    foreach (DealInstance item in deals)
                    {
                        result += "<div class=\"thirds\"><!-- Wrap with a third to control size/spacing of tiles -->";
                        result += "<article class=\"c4g-coupon-tile\">";
                        result += "<img src=\"../../Images/c4g_coupon_logo.png\" class=\"coupon_c4g_logo\" />";
                        result += "<div class=\"coupon-title-tile\">";
                        result += "<h2><a href=\"DealPage.aspx?merchantname=" + item.Deal.Merchant.Name + "&deal=" + item.Deal.Name + "\">" + item.Deal.Name + "</a></h2><!-- Merchant Offer -->";
                        result += "<h3><a href=\"MerchantPage.aspx?MerchantName=" + item.Deal.Merchant.Name + "\">" + item.Deal.Merchant.Name + "</a></h3><!-- Merchant Name -->";
                        result += "<span class=\"campaign-frame\">";
                        result += "<a href=\"DealPage.aspx?merchantname=" + item.Deal.Merchant.Name + "&deal=" + item.Deal.Name + "\" class=\"btn-coupon\"><img src=\"../../" + item.Deal.ImageURL + "\" /></a>";
                        result += "</span>";
                        result +="<div class=\"campaign-details-tile\">";
                        result += "<p>" + item.Deal.DealDescription + "</p><!-- Merchant Offer Description -->";
                        result += "<p><strong>Price You Pay:</strong> <span>$80</span><br /> <!-- Offer Price -->";
                        result += "<strong>Value of Deal:</strong> <em>$" + ((int)(item.Deal.Prices.FirstOrDefault<Price>().RetailValue)).ToString("D") + "</em><!-- Offer Value --> <br />";
                        result += "<strong>You're Giving:</strong> <span>$" + ((int)(item.Deal.Prices.FirstOrDefault<Price>().NPOSplit)).ToString("D") + "</span><!-- Donation Value --> <br />";
                        result += "<strong>Discount:</strong> <span>$" + (1 - (item.Deal.Prices.FirstOrDefault<Price>().GiftValue / item.Deal.Prices.FirstOrDefault<Price>().RetailValue)).ToString("0%") + "</span><!-- Discount Value --> <br />";
                        result += "<strong>Coupons Left :</strong>" + (item.Deal.AbsoluteCouponLimit - item.PurchaseOrders.Count()) + "<span></span></p>";
                        result += "</div><!--Close Coupon Details Title -->";
                        result += "<a href=\"DealPage.aspx?merchantname=" + item.Deal.Merchant.Name + "&deal=" + item.Deal.Name + "\" class=\"btn-coupon\"><i class=\"fa fa-arrow-circle-o-right\"></i> More Details</a>";
                        result += "</article>";
                        result += "</div><!-- First Coupon -->";
                    }
                }
                else
                    result = "<p>We currently have no Merchant Offers. <strong>Please check back soon.</strong></p>";

            return result;
        }

        /// <summary>
        /// Outputs a string for use on the NPO Profile Page.
        /// </summary>
        /// <param name="campaigns">The list of campaigns to show.</param>
        /// <returns>An http string.</returns>
        public static string ListNPOCampaigns(List<Campaign> campaigns)
        {
            string result = "";

            if (campaigns != null)
                if (campaigns.Count > 0)
                    foreach (Campaign item in campaigns)
                    {
                        result += "<div class=\"thirds\"><!-- Wrap with a third to control size/spacing of tiles -->";
                        result += "<article class=\"c4g-campaign-tile\"><!-- New Class Campaign Title -->";
                        result += "<img src=\"../../Images/c4g_campaign_logo.png\" class=\"coupon_c4g_logo\" />";
                        result += "<div class=\"coupon-title-tile\">";
                        result += "<h2><a href=\"../../Causes/" + item.NPO.Name + "/" + item.Name + "\">" + item.Name + "</a></h2><!-- Campaign Title -->";
                        result += "<h3><a href=\"NPOPage.aspx?name=" + item.NPO.Name + "\">" + item.NPO.Name + "</a></h3><!-- NPO Name -->";
                        result += "<span class=\"campaign-frame\">";
                        result += "<a href=\"CampaignPage.aspx?nponame=" + item.NPO.Name + "&campaign=" + item.Name + "\"><img src=\"../" + item.CampaignImage + "\" /></a>";
                        result += "</span>"; 
                        result += "<div class=\"campaign-details-tile\">";
                        result += "<p>" + item.CampaignDescription + "</p><!-- Coupon Description (limited to 200 characters if possible -->"; 
                        result += "<p><strong>Number of Offers:</strong> <span>" + item.DealInstances.Count + "</span><!-- Number of Merchant Offers in Camapign--> <br />";
                        result += "<strong>Campaign Goal:</strong> <span>$" + item.FundraisingGoal + "</span><!-- Campaign Goal--> ";                      
                        result += "<strong>Campaign Dates:</strong> <em>" + (item.StartDate != null ? item.StartDate.Value.ToString("MMMM dd, yyyy") : "") + " - " + (item.EndDate != null ? item.EndDate.Value.ToString("MMMM dd, yyyy") : "") + "</em><!-- Campaign Dates --> </p>";
                        result += "</div><!--Close Coupon Title -->";
                        result += "<a href=\"../../Causes/" + item.NPO.Name + "/" + item.Name + "\" class=\"btn-coupon\"><i class=\"fa fa-arrow-circle-o-right\"></i> Campaign Details</a><!-- Link To Campaign Page -->";
                        result += "</article>";
                        result += "</div>";
                    }
                else
                    result = "<p>We currently aren't running any campaigns in your city. <strong>Please check back soon!</strong></p><br /><a href=\"AllCauses.aspx\" class=\"btn-large\">See all our Campaigns!</a>";

            return result;
        }

        public static string ListNPOCampaignsForNPO(List<Campaign> campaigns)
        {
            string result = "";

            if (campaigns != null)
                if (campaigns.Count > 0)
                    foreach (Campaign item in campaigns)
                    {
                        result += "<div class=\"thirds\"><!-- Wrap with a third to control size/spacing of tiles -->";
                        result += "<article class=\"c4g-campaign-tile\"><!-- New Class Campaign Title -->";
                        result += "<img src=\"../../Images/c4g_campaign_logo.png\" class=\"coupon_c4g_logo\" />";
                        result += "<div class=\"coupon-title-tile\">";
                        result += "<h2><a href=\"CampaignPage.aspx?nponame=" + item.NPO.Name + "&campaign=" + item.Name + "\">" + item.Name + "</a></h2><!-- Campaign Title -->";
                        result += "<h3><a href=\"NPOPage.aspx?name=" + item.NPO.Name + "\">NPO Name</a></h3><!-- NPO Name -->";
                        result += "<span class=\"campaign-frame\">";
                        result += "<a href=\"CampaignPage.aspx?nponame=" + item.NPO.Name + "&campaign=" + item.Name + "\"><img src=\"../" + item.CampaignImage +  "\" /></a>";
                        result += "</span>"; 
                        result += "<div class=\"campaign-details-tile\">";
                     	result += "<p></p><!-- Merchant Offer Description -->";
                        result += "<p><strong>Number of Offers:</strong> <span> </span><!-- Number of Merchant Offers in Camapign--> <br />";
                        result += "<strong>Campaign Goal:</strong> <span> </span><!-- Campaign Goal--> ";                      
                        result += "<strong>Campaign Dates:</strong> <em>" + (item.StartDate != null ? item.StartDate.Value.ToString("MMMM dd, yyyy") : "") + " - " + (item.EndDate != null ? item.EndDate.Value.ToString("MMMM dd, yyyy") : "") + "</em><!-- Campaign Dates --> </p>";
                        result += "</div><!--Close Coupon Title -->";                        result += "<a href=\"Campaigns/Edit.aspx?cid=" + item.CampaignID + "\" class=\"btn-coupon\"><i class=\"fa fa-arrow-circle-o-right\"></i> Edit</a><!-- Link To Campaign Page -->";
                        result += "</article>";
                        result += "</div>";
                    }
                else
                    result = "<p>We currently aren't running any campaigns in your city. <strong>Please check back soon!</strong></p><br /><a href=\"AllCauses.aspx\" class=\"btn-large\">See all our Campaigns!</a>";

            return result;
        }

        public static string ListMerchantOffers(List<DealInstance> deals)
        {
            string result = "";

            if (deals != null)
                if (deals.Count > 0)
                    foreach (DealInstance item in deals)
                    {
                        result += "<div class=\"thirds\"><!-- Wrap with a third to control size/spacing of tiles -->";
                        result += "<article class=\"c4g-campaign-tile\"><!-- New Class Campaign Title -->";
                        result += "<img src=\"../../Images/c4g_campaign_logo.png\" class=\"coupon_c4g_logo\" />";
                        result += "<div class=\"coupon-title-tile\">";
                        result += "<h2><a href=\"DealPage.aspx?merchantname=" + item.Deal.Merchant.Name + "&deal=" + item.Deal.Name + "\">" + item.Deal.Name + "</a></h2><!-- Offer Title -->";
                        result += "<h3><a href=\"MerchantPage.aspx?MerchantName=" + item.Deal.Merchant.Name + "\">" + item.Deal.Merchant.Name + "</a></h3><!-- Merchant Name -->";
                        result += "<span class=\"company-frame\">";
                        result += "<a href=\"DealPage.aspx?merchantname=" + item.Deal.Merchant.Name + "&deal=" + item.Deal.Name + "\"><img src=\"../" + item.Deal.ImageURL + "\" /></a>";
                        result += "</span>"; 
                        result += "<div class=\"campaign-details-tile\">";
                        result += "<p>" + item.Deal.DealDescription + "</p><!-- Coupon Description (limited to 200 characters if possible -->"; 
                        result += "<p><strong>Price You Pay:</strong> <span>" + item.Deal.Prices.FirstOrDefault<Price>().GiftValue.ToString("C") + "</span><!-- Number of Merchant Offers in Camapign--> <br />";
                        result += "<strong>Discount:</strong> <em>" + (int)((1M - (item.Deal.Prices.FirstOrDefault<Price>().GiftValue / item.Deal.Prices.FirstOrDefault<Price>().RetailValue)) * 100) + "%</em><!-- Campaign Dates --> </p>";
                        result += "<p><strong>Value of Deal:</strong> <span>" + item.Deal.Prices.FirstOrDefault<Price>().RetailValue.ToString("C") + "</span><!-- Number of Merchant Offers in Camapign--> <br />";
                        result += "<p><strong>You're Giving:</strong> <span>" + item.Deal.Prices.FirstOrDefault<Price>().NPOSplit.ToString("C") + "</span><!-- Number of Merchant Offers in Camapign--><br />";
                        result += "<strong>Coupons Left :</strong>" + (item.Deal.AbsoluteCouponLimit - item.PurchaseOrders.Count()) + "<span></span></p>";
                        result += "</div><!--Close Coupon Title -->";
                        result += "</div><!-- Close Details -->";
                        result += "<a href=\"DealPage.aspx?merchantname=" + item.Deal.Merchant.Name + "&deal=" + item.Deal.Name + "\" class=\"btn-coupon\"><i class=\"fa fa-arrow-circle-o-right\"></i> Offer Details</a><!-- Link To Campaign Page -->";
                        result += "</article>";
                        result += "</div>";
                        
                    }
                else
                    result = "<p>We currently aren't running any offers. <strong>Please check back soon!</strong></p>";

            return result;
        }

        public static string GetMerchantOffer(DealInstance deal)
        {
            string result = "";

            result += "<div class=\"thirds\">";
            result += "<article class=\"c4g-coupon-tile\">";
            result += "<img src=\"../Images/c4g_coupon_logo.png\" class=\"coupon_c4g_logo\" />";
            result += "<div class=\"coupon-title-tile\">";
            result += "<h2><a href=\"DealPage.aspx?merchantname=" + deal.Deal.Merchant.Name + "&deal=" + deal.Deal.Name + "\">" + deal.Deal.Name + "</a></h2><!-- Merchant Offer -->";
            result += "<h3><a href=\"MerchantPage.aspx?Name=" + deal.Deal.Merchant.Name + "\"></a></h3><!-- Merchant Name -->";
            result += "<span class=\"campaign-frame\">";
            result += "<a href=\"DealPage.aspx?merchantname=" + deal.Deal.Merchant.Name + "&deal=" + deal.Deal.Name + "\" ><img src=\"../../" + deal.Deal.ImageURL + "\" /></a>";
            result += "</span>";
            result += "<div class=\"campaign-details-tile\">";
            result += "<p></p><!-- Merchant Offer Description -->";
            result += "<p><strong>Price You Pay:</strong> <span>" + deal.Deal.Prices.FirstOrDefault<Price>().GiftValue.ToString("C") + "</span><br /> <!-- Offer Price -->";
            result += "<strong>Value of Deal:</strong> <em>" + deal.Deal.Prices.FirstOrDefault<Price>().RetailValue.ToString("C") + "</em><!-- Offer Value --> <br />";
            result += "<strong>You're Giving:</strong> <span>" + deal.Deal.Prices.FirstOrDefault<Price>().NPOSplit.ToString("C") + "</span><!-- Donation Value --> <br />";
            result += "<strong>Discount:</strong> <span>" + (int)((1M - (deal.Deal.Prices.FirstOrDefault<Price>().GiftValue / deal.Deal.Prices.FirstOrDefault<Price>().RetailValue)) * 100) + "%</span><!-- Discount Value --> <br />";
            result += "<strong>Coupons Left :</strong>" + (deal.Deal.AbsoluteCouponLimit - deal.PurchaseOrders.Count()) + "<span></span></p>";

            result += "</div><!--Close Coupon Details Title -->";
            result += "<a href=\"DealPage.aspx?merchantname=" + deal.Deal.Merchant.Name + "&deal=" + deal.Deal.Name + "\" class=\"btn-coupon\"><i class=\"fa fa-arrow-circle-o-right\"></i> More Details</a>";
            result += "</article>";
            result += "</div>";

            return result;
        }

        public static string GetNPOCampaign(Campaign campaign, DealInstance deal)
        {
            string result = "";

            result += "<div class=\"thirds\">";
            result += "<article class=\"c4g-coupon-tile\">";
            result += "<img src=\"../../Images/c4g_coupon_logo.png\" class=\"coupon_c4g_logo\" />";
            result += "<h2><a href=\"CampaignPage.aspx?nponame=" + campaign.NPO.Name + "&campaign=" + campaign.Name + "\">" + campaign.Name + "</a></h2><!-- Merchant Offer -->";
            result += "<h3><a href=\"NPOPage.aspx?name=" + campaign.NPO.Name + "\">" + campaign.NPO.Name + "</a></h3>";
            result += "<span class=\"campaign-frame\">";
            result += "<a href=\"CampaignPage.aspx?nponame=" + campaign.NPO.Name + "&campaign=" + campaign.Name + "\"><img src=\"../" + campaign.CampaignImage + "\"></a>";
            result += "</span>";
            result += "<div class=\"campaign-details-tile\">";
            result += "<p>" + campaign.CampaignDescription + "</p>";
            result += "<p>";
            result += "<strong>Number of Offers:</strong>";
            result += "<span>" + campaign.DealInstances.Count + "</span>";
            result += "<br><strong>Campaign Goal:</strong>";
            result += "<span>$" + campaign.FundraisingGoal + "</span><br>";
            result += "<strong>Campaign Dates:</strong>";
            result += "<em>" + campaign.StartDate.Value.ToString("MMMM dd yyyy") + "-" + campaign.EndDate.Value.ToString("MMMM dd yyyy") + "</em>";
            result += "</p>";            
            result += "</div>";
            result += "<a href=\"javascript:addToCart(" + deal.DealInstanceID + ", " + campaign.CampaignID + ")\" class=\"btn-coupon\"><i class=\"fa fa-arrow-circle-o-right\"></i> Buy Now</a>";
            result += "<a href=\"../../Default/CampaignPage.aspx?nponame=" + campaign.NPO.Name + "&campaign=" + campaign.Name + "\" class=\"btn-coupon\"><i class=\"fa fa-arrow-circle-o-right\"></i> About This Campaign</a>";
            result += "</article>";
            result += "</div>";

            return result;

        }

        public static string GetNPOCampaignForMerchant(Campaign campaign, Deal deal)
        {
            string result = "";

            result += "<div class=\"thirds\">";
            result += "<article class=\"c4g-coupon-tile\">";
            result += "<img src=\"../../Images/c4g_coupon_logo.png\" class=\"coupon_c4g_logo\" />";
            result += "<div class=\"coupon-title-tile\">";
            result += "<h2><a href=\"CampaignPage.aspx?nponame=" + campaign.NPO.Name + "&campaign=" + campaign.Name + "\">" + campaign.Name + "</a></h2><!-- Campaign -->";
            result += "<h3><a href=NPOPage.aspx?name=\"" + campaign.NPO.Name + "\">NPO Name</a>";
            result += "<div class=\"campaign-details-tile\">";
            result += "<p>" + campaign.CampaignDescription + "</p><!-- Campaign Offer Description -->";
            result += "</div>";
            result += "</div><!--Close Coupon Title -->";
            result += "<div class=\"clear\"></div>";
            result += "<div class=\"clear\"></div>";
            result += "<a href=\"CampaignPage.aspx?nponame=" + campaign.NPO.Name + "&campaign=" + campaign.Name + "\" class=\"btn-coupon\"><i class=\"fa fa-arrow-circle-o-right\"></i> Buy Now</a>";
            result += "</article>";
            result += "</div>";

            return result;
        }

        public static string WriteErrorList(List<string> Errors) {
            string result = "";

            if (Errors.Count < 1)
                throw new ArgumentException("Errors must have more than one string.");
            else
            {
                result += "<ul>";
                foreach (string item in Errors)
                    result += String.Format("<li>{0}</li>", item);
                result += "</ul>";
            }

            return result;
        }
    }

    public class JSONUtils
    {
        public static string ToJSON(object obj)
        {
            string result = "";

            JavaScriptSerializer serializer = new JavaScriptSerializer();
            result = serializer.Serialize(obj);

            return result;
        }
    }

    public class EmailUtils
    {
        /// <summary>
        /// Writes a generic Email.
        /// </summary>
        /// <param name="To">A list of emails to send the message to.</param>
        /// <param name="type">The type of new user registration email to send. Permitted values: User, NPO, and Merchant.</param>
        /// <returns>An xml string to send via email</returns>
        public static void SendUserRegistrationEmail(List<string> To, RegisterEmailType type)
        {
            MailMessage mm = new MailMessage();

            foreach (string item in To)
                mm.To.Add(item);

            XmlDocument doc = new XmlDocument();
            doc.Load(HttpContext.Current.Server.MapPath(String.Format("~/App_Code/EmailText ({0}).xml", WebConfigurationManager.AppSettings["Language"])));
            string Title = doc.SelectSingleNode("/EmailText/UserSignup/Title").InnerText;
            string EmailContent = "";

            switch (type)
            {
                case RegisterEmailType.User:
                    EmailContent = doc.SelectSingleNode("/EmailText/UserSignup/UserContent").InnerText;
                    break;

                case RegisterEmailType.NPO:
                    EmailContent = doc.SelectSingleNode("/EmailText/UserSignup/NPOContent").InnerText;
                    break;

                case RegisterEmailType.Merchant:
                    EmailContent = doc.SelectSingleNode("/EmailText/UserSignup/MerchantContent").InnerText;
                    break;

                default:
                    throw new ArgumentException("RegisterEmailType is invalid. RegisterEmailType must be one of the following: User, NPO, or Merchant.");
            }
            
            string LinkURL = doc.SelectSingleNode("/EmailText/UserSignup/LinkURL").InnerText;
            string LinkContent = doc.SelectSingleNode("/EmailText/UserSignup/LinkContent").InnerText;
            string LinkSuffix = doc.SelectSingleNode("/EmailText/UserSignup/LinkSuffix").InnerText;
            string ContactTextPrefix = doc.SelectSingleNode("/EmailText/ContactTextPrefix").InnerText;
            string ContactEmail = doc.SelectSingleNode("/EmailText/ContactEmail").InnerText;
            string ContactTextSuffix = doc.SelectSingleNode("/EmailText/ContactTextSuffix").InnerText;
            string Subject = doc.SelectSingleNode("/EmailText/UserSignup/Subject").InnerText;

            mm.Subject = Subject;
            mm.IsBodyHtml = true;
            
            string message = "";

            message += "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">";
            message += "<html>";
            message += "<head>";
            message += "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">";
            message += String.Format("<meta property=\"og:title\" content=\"{0}\">", Title);
            message += String.Format("<title>[0]</title>", Title);
            message += "</head>";
            message += "<body leftmargin=\"0\" marginwidth=\"0\" topmargin=\"0\" marginheight=\"0\" offset=\"0\" style=\"-webkit-text-size-adjust: none;margin: 0;padding: 0;background-color: #FAFAFA;width: 100%;\">";
            message += "<center>";
            message += "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" height=\"100%\" width=\"100%\" id=\"backgroundTable\" style=\"margin: 0;padding: 0;background-color: #FAFAFA;height: 100%;width: 100%;\">";
            message += "<tr>";
            message += "<td align=\"center\" valign=\"top\" style=\"border-collapse: collapse;\">";
            message += "<table border=\"0\" cellpadding=\"10\" cellspacing=\"0\" width=\"600\" id=\"templatePreheader\" style=\"background-color: #FAFAFA;\">";
            message += "<tr>";
            message += "<td valign=\"top\" class=\"preheaderContent\" style=\"border-collapse: collapse;\">";
            message += "<table border=\"0\" cellpadding=\"10\" cellspacing=\"0\" width=\"100%\">";
            message += "<tr>";
            message += "<td valign=\"top\" style=\"border-collapse: collapse;\">";
            message += "<div style=\"color: #505050;font-family: Arial;font-size: 10px;line-height: 100%;text-align: center;\">Thank you for registering with Coupons4Giving.ca. Click on the link below to access your new account.";
            message += "</div>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"600\" id=\"templateContainer\" style=\"border: 1px solid #DDD;background-color: #FFFFFF;\">";
            message += "<tr>";
            message += "<td align=\"center\" valign=\"top\" style=\"border-collapse: collapse;\">";
            message += "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"600\" id=\"templateHeader\" style=\"background-color: #FFFFFF;border-bottom: 0;\">";
            message += "<tr>";
            message += "<td class=\"headerContent\" style=\"border-collapse: collapse;color: #202020;font-family: Arial;font-size: 34px;font-weight: bold;line-height: 100%;padding: 0;text-align: center;vertical-align: middle;\">";
            message += "<img src=\"http://www.coupons4giving.ca/Images/c4g_email_header.png\" style=\"max-width: 600px;border: 0;height: auto;line-height: 100%;outline: none;text-decoration: none; padding-top: 20px;\" id=\"headerImage campaign-icon\">";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</td>";
            message += "</tr>";
            message += "<tr>";
            message += "<td align=\"center\" valign=\"top\" style=\"border-collapse: collapse;\">";
            message += "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"600\" id=\"templateBody\">";
            message += "<tr>";
            message += "<td valign=\"top\" class=\"bodyContent\" style=\"border-collapse: collapse;background-color: #FFFFFF;\">";
            message += "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">";
            message += "<tr>";
            message += "<td valign=\"top\" style=\"border-collapse: collapse;\">";
            message += "<table border=\"0\" cellpadding=\"20\" cellspacing=\"0\" width=\"100%\">";
            message += "<tr>";
            message += "<td valign=\"top\" style=\"border-collapse: collapse;\">";
            message += "<div style=\"color: #5e5e5e;font-family: Arial;font-size: 14px;line-height: 150%;text-align: center;\"><h1 class=\"h1\" style=\"color: #22bfe8;display: block;font-family: Arial;font-size: 28px;font-weight: bold;line-height: 100%;margin-top: 0;margin-right: 0;margin-bottom: 10px;margin-left: 0;text-align: center;\">Welcome To Coupons4Giving</h1>";
            message += "</div>";
            message += "<img src=\"http://www.coupons4giving.ca/Images/c4g_email_template_header1.png\" style=\"max-width: 560px;border: 0;height: auto;line-height: 100%;outline: none;text-decoration: none;display: inline; padding-bottom: 30px;\">";
            message += String.Format("<div style=\"color: #5e5e5e;font-family: Arial;font-size: 14px;line-height: 150%;text-align: center;\">{0}", EmailContent);
            message += "<h4 class=\"null tpl-content-highlight\" style=\"text-align: center;color: #5e5e5e;display: block;font-family: Arial;font-size: 22px;font-weight: bold;line-height: 100%;margin-top: 0;margin-right: 0;margin-bottom: 10px;margin-left: 0;\"><br>";
            message += String.Format("<strong><a href=\"{1}\" target=\"_blank\" style=\"color: #22bfe8;font-weight: normal;text-decoration: underline;\">{0}</a>&nbsp;{2}</strong></h4>", LinkContent, LinkURL, LinkSuffix);
            message += String.Format("<p style=\"text-align: center;\"><strong>{0}&nbsp;<a href=\"mailto:{1}\" target=\"_blank\" style=\"color: #22bfe8;font-weight: normal;text-decoration: underline;\">{1}</a>&nbsp;{2}</strong></p>", ContactTextPrefix, ContactEmail, ContactTextSuffix);
            message += "<p style=\"text-align: center;\">Cheers!</p>";
            message += "</div>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</td>";
            message += "</tr>";
            message += "<tr>";
            message += "<td align=\"center\" valign=\"top\" style=\"border-collapse: collapse;\">";
            message += "<table border=\"0\" cellpadding=\"10\" cellspacing=\"0\" width=\"600\" id=\"templateFooter\" style=\"background-color: #FFFFFF;border-top: 0;\">";
            message += "<tr>";
            message += "<td valign=\"top\" class=\"footerContent\" style=\"border-collapse: collapse;\">";
            message += "<table border=\"0\" cellpadding=\"10\" cellspacing=\"0\" width=\"100%\">";
            message += "<tr>";
            message += "<td colspan=\"2\" valign=\"middle\" id=\"social\" style=\"border-collapse: collapse;background-color: #ecebe9;border: 0;\">";
            message += "<div style=\"color: #5e5e5e;font-family: Arial;font-size: 12px;line-height: 125%;text-align: center;\"><h3 class=\"null\" style=\"text-align: center;color: #202020;display: block;font-family: Arial;font-size: 26px;font-weight: bold;line-height: 100%;margin-top: 0;margin-right: 0;margin-bottom: 10px;margin-left: 0;\"><span style=\"font-size:18px;\"><span style=\"color:#ff9900;\">Connect with us on Social Media</span></span></h3>";
            message += "&nbsp;<a href=\"https://twitter.com/Coupons4Giving\" target=\"_blank\" style=\"color: #22bfe8;font-weight: normal;text-decoration: underline;\"><img align=\"none\" height=\"84\" src=\"http://www.coupons4giving.ca/Images/c4g_email_twitter.png\" style=\"width: 84px;height: 84px;border: 0;line-height: 100%;outline: none;text-decoration: none;display: inline;\" width=\"84\"></a><a href=\"http://www.facebook.com/Coupons4Giving\" target=\"_blank\" style=\"color: #22bfe8;font-weight: normal;text-decoration: underline;\"><img align=\"none\" height=\"84\" src=\"http://www.coupons4giving.ca/Images/c4g_email_facebook.png\" style=\"width: 84px;height: 84px;border: 0;line-height: 100%;outline: none;text-decoration: none;display: inline;\" width=\"84\"></a><a href=\"https://www.coupons4giving.ca/Home.aspx#\" target=\"_blank\" style=\"color: #22bfe8;font-weight: normal;text-decoration: underline;\"><img align=\"none\" height=\"84\" src=\"http://www.coupons4giving.ca/Images/c4g_email_linkedin.png\" style=\"width: 84px;height: 84px;border: 0;line-height: 100%;outline: none;text-decoration: none;display: inline;\" width=\"84\"></a></div>";
            message += "</td>";
            message += "</tr>";
            message += "<tr>";
            message += "<td valign=\"top\" width=\"550\" style=\"border-collapse: collapse;\">";
            message += "<div style=\"color: #5e5e5e;font-family: Arial;font-size: 12px;line-height: 125%;text-align: center;\">&copy; 2013 - GenerUS Marketing Solutions | Edmonton, Alberta, Canada</div>";
            message += "</td>";
            message += "</tr>";
            message += "<tr>";
            message += "<td colspan=\"2\" valign=\"middle\" id=\"utility\" style=\"border-collapse: collapse;background-color: #FFFFFF;border: 0;\">";
            //Replace with link to settings page to disable email notifications
            message += String.Format("<div style=\"color: #5e5e5e;font-family: Arial;font-size: 12px;line-height: 125%;text-align: center;\">To unsubscribe please contact us at&nbsp;<a href=\"mailto:{0}\" target=\"_blank\" style=\"color: #22bfe8;font-weight: normal;text-decoration: underline;\">{0}</a>.</div>", ContactEmail);
            message += "</td>";
            message += "</tr>";
            message += "</table>";           
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "<br>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</center>";
            message += "</body>";
            message += "</html>";

            mm.Body = message;
            new SmtpClient().Send(mm);
        }

        public static void SendOfferCreationEmail(List<string> To, string Name, string OfferName)
        {
            MailMessage mm = new MailMessage();

            foreach (string item in To)
                mm.To.Add(item);

            XmlDocument doc = new XmlDocument();
            doc.Load(HttpContext.Current.Server.MapPath(String.Format("~/App_Code/EmailText ({0}).xml", WebConfigurationManager.AppSettings["Language"])));

            string Title = doc.SelectSingleNode("/EmailText/OfferCreation/TitlePrefix").InnerText;
            string ContentPrefix = doc.SelectSingleNode("/EmailText/OfferCreation/ContentPrefix").InnerText;
            string ContentSuffix = doc.SelectSingleNode("/EmailText/OfferCreation/ContentSuffix").InnerText;
            string LinkURL = String.Format("http://www.coupons4giving.ca/Offers/{0}/{1}", Name, OfferName);
            string LinkContent = doc.SelectSingleNode("/EmailText/OfferCreation/LinkContent").InnerText;
            string LinkSuffix = doc.SelectSingleNode("/EmailText/OfferCreation/LinkSuffix").InnerText;
            string ContactTextPrefix = doc.SelectSingleNode("/EmailText/ContactTextPrefix").InnerText;
            string ContactEmail = doc.SelectSingleNode("/EmailText/ContactEmail").InnerText;
            string ContactTextSuffix = doc.SelectSingleNode("/EmailText/ContactTextSuffix").InnerText;
            string Subject = doc.SelectSingleNode("/EmailText/OfferCreation/Subject").InnerText;

            mm.Subject = Subject;
            mm.IsBodyHtml = true;

            string message = "";

            message += "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">";
            message += "<html>";
            message += "<head>";
            message += "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">";
            message += String.Format("<meta property=\"og:title\" content=\"{0}\">", Title);
            message += String.Format("<title>[0]</title>", Title);
            message += "</head>";
            message += "<body leftmargin=\"0\" marginwidth=\"0\" topmargin=\"0\" marginheight=\"0\" offset=\"0\" style=\"-webkit-text-size-adjust: none;margin: 0;padding: 0;background-color: #FAFAFA;width: 100%;\">";
            message += "<center>";
            message += "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" height=\"100%\" width=\"100%\" id=\"backgroundTable\" style=\"margin: 0;padding: 0;background-color: #FAFAFA;height: 100%;width: 100%;\">";
            message += "<tr>";
            message += "<td align=\"center\" valign=\"top\" style=\"border-collapse: collapse;\">";
            message += "<table border=\"0\" cellpadding=\"10\" cellspacing=\"0\" width=\"600\" id=\"templatePreheader\" style=\"background-color: #FAFAFA;\">";
            message += "<tr>";
            message += "<td valign=\"top\" class=\"preheaderContent\" style=\"border-collapse: collapse;\">";
            message += "<table border=\"0\" cellpadding=\"10\" cellspacing=\"0\" width=\"100%\">";
            message += "<tr>";
            message += "<td valign=\"top\" style=\"border-collapse: collapse;\">";
            message += "</div>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"600\" id=\"templateContainer\" style=\"border: 1px solid #DDD;background-color: #FFFFFF;\">";
            message += "<tr>";
            message += "<td align=\"center\" valign=\"top\" style=\"border-collapse: collapse;\">";
            message += "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"600\" id=\"templateHeader\" style=\"background-color: #FFFFFF;border-bottom: 0;\">";
            message += "<tr>";
            message += "<td class=\"headerContent\" style=\"border-collapse: collapse;color: #202020;font-family: Arial;font-size: 34px;font-weight: bold;line-height: 100%;padding: 0;text-align: center;vertical-align: middle;\">";
            message += "<img src=\"http://www.coupons4giving.ca/Images/c4g_email_header.png\" style=\"max-width: 600px;border: 0;height: auto;line-height: 100%;outline: none;text-decoration: none; padding-top: 20px;\" id=\"headerImage campaign-icon\">";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</td>";
            message += "</tr>";
            message += "<tr>";
            message += "<td align=\"center\" valign=\"top\" style=\"border-collapse: collapse;\">";
            message += "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"600\" id=\"templateBody\">";
            message += "<tr>";
            message += "<td valign=\"top\" class=\"bodyContent\" style=\"border-collapse: collapse;background-color: #FFFFFF;\">";
            message += "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">";
            message += "<tr>";
            message += "<td valign=\"top\" style=\"border-collapse: collapse;\">";
            message += "<table border=\"0\" cellpadding=\"20\" cellspacing=\"0\" width=\"100%\">";
            message += "<tr>";
            message += "<td valign=\"top\" style=\"border-collapse: collapse;\">";
            message += "<div style=\"color: #5e5e5e;font-family: Arial;font-size: 14px;line-height: 150%;text-align: center;\"><h1 class=\"h1\" style=\"color: #22bfe8;display: block;font-family: Arial;font-size: 28px;font-weight: bold;line-height: 100%;margin-top: 0;margin-right: 0;margin-bottom: 10px;margin-left: 0;text-align: center;\">Welcome To Coupons4Giving</h1>";
            message += "</div>";
            message += "<img src=\"http://www.coupons4giving.ca/Images/c4g_email_template_header1.png\" style=\"max-width: 560px;border: 0;height: auto;line-height: 100%;outline: none;text-decoration: none;display: inline; padding-bottom: 30px;\">";
            message += String.Format("<div style=\"color: #5e5e5e;font-family: Arial;font-size: 14px;line-height: 150%;text-align: center;\">{0}", ContentPrefix + Name + ContentSuffix);
            message += "<h4 class=\"null tpl-content-highlight\" style=\"text-align: center;color: #5e5e5e;display: block;font-family: Arial;font-size: 22px;font-weight: bold;line-height: 100%;margin-top: 0;margin-right: 0;margin-bottom: 10px;margin-left: 0;\"><br>";
            message += String.Format("<strong><a href=\"{1}\" target=\"_blank\" style=\"color: #22bfe8;font-weight: normal;text-decoration: underline;\">{0}</a>&nbsp;{2}</strong></h4>", LinkContent, LinkURL, LinkSuffix);
            message += String.Format("<p style=\"text-align: center;\"><strong>{0}&nbsp;<a href=\"mailto:{1}\" target=\"_blank\" style=\"color: #22bfe8;font-weight: normal;text-decoration: underline;\">{1}</a>&nbsp;{2}</strong></p>", ContactTextPrefix, ContactEmail, ContactTextSuffix);
            message += "<p style=\"text-align: center;\">Cheers!</p>";
            message += "</div>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</td>";
            message += "</tr>";
            message += "<tr>";
            message += "<td align=\"center\" valign=\"top\" style=\"border-collapse: collapse;\">";
            message += "<table border=\"0\" cellpadding=\"10\" cellspacing=\"0\" width=\"600\" id=\"templateFooter\" style=\"background-color: #FFFFFF;border-top: 0;\">";
            message += "<tr>";
            message += "<td valign=\"top\" class=\"footerContent\" style=\"border-collapse: collapse;\">";
            message += "<table border=\"0\" cellpadding=\"10\" cellspacing=\"0\" width=\"100%\">";
            message += "<tr>";
            message += "<td colspan=\"2\" valign=\"middle\" id=\"social\" style=\"border-collapse: collapse;background-color: #ecebe9;border: 0;\">";
            message += "<div style=\"color: #5e5e5e;font-family: Arial;font-size: 12px;line-height: 125%;text-align: center;\"><h3 class=\"null\" style=\"text-align: center;color: #202020;display: block;font-family: Arial;font-size: 26px;font-weight: bold;line-height: 100%;margin-top: 0;margin-right: 0;margin-bottom: 10px;margin-left: 0;\"><span style=\"font-size:18px;\"><span style=\"color:#ff9900;\">Connect with us on Social Media</span></span></h3>";
            message += "&nbsp;<a href=\"https://twitter.com/Coupons4Giving\" target=\"_blank\" style=\"color: #22bfe8;font-weight: normal;text-decoration: underline;\"><img align=\"none\" height=\"84\" src=\"http://www.coupons4giving.ca/Images/c4g_email_twitter.png\" style=\"width: 84px;height: 84px;border: 0;line-height: 100%;outline: none;text-decoration: none;display: inline;\" width=\"84\"></a><a href=\"http://www.facebook.com/Coupons4Giving\" target=\"_blank\" style=\"color: #22bfe8;font-weight: normal;text-decoration: underline;\"><img align=\"none\" height=\"84\" src=\"http://www.coupons4giving.ca/Images/c4g_email_facebook.png\" style=\"width: 84px;height: 84px;border: 0;line-height: 100%;outline: none;text-decoration: none;display: inline;\" width=\"84\"></a><a href=\"https://www.coupons4giving.ca/Home.aspx#\" target=\"_blank\" style=\"color: #22bfe8;font-weight: normal;text-decoration: underline;\"><img align=\"none\" height=\"84\" src=\"http://www.coupons4giving.ca/Images/c4g_email_linkedin.png\" style=\"width: 84px;height: 84px;border: 0;line-height: 100%;outline: none;text-decoration: none;display: inline;\" width=\"84\"></a></div>";
            message += "</td>";
            message += "</tr>";
            message += "<tr>";
            message += "<td valign=\"top\" width=\"550\" style=\"border-collapse: collapse;\">";
            message += "<div style=\"color: #5e5e5e;font-family: Arial;font-size: 12px;line-height: 125%;text-align: center;\">&copy; 2013 - GenerUS Marketing Solutions | Edmonton, Alberta, Canada</div>";
            message += "</td>";
            message += "</tr>";
            message += "<tr>";
            message += "<td colspan=\"2\" valign=\"middle\" id=\"utility\" style=\"border-collapse: collapse;background-color: #FFFFFF;border: 0;\">";
            //Replace with link to settings page to disable email notifications
            message += String.Format("<div style=\"color: #5e5e5e;font-family: Arial;font-size: 12px;line-height: 125%;text-align: center;\">To unsubscribe please contact us at&nbsp;<a href=\"mailto:{0}\" target=\"_blank\" style=\"color: #22bfe8;font-weight: normal;text-decoration: underline;\">{0}</a>.</div>", ContactEmail);
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "<br>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</center>";
            message += "</body>";
            message += "</html>";

            mm.Body = message;
            new SmtpClient().Send(mm);
        }

        public static void SendMerchantSignupEmail(List<string> To, string Name, string MerchantName)
        {
            MailMessage mm = new MailMessage();

            foreach (string item in To)
                mm.To.Add(item);

            XmlDocument doc = new XmlDocument();
            doc.Load(HttpContext.Current.Server.MapPath(String.Format("~/App_Code/EmailText ({0}).xml", WebConfigurationManager.AppSettings["Language"])));

            string Title = doc.SelectSingleNode("/EmailText/MerchantSignup/Title").InnerText;
            string Content = doc.SelectSingleNode("/EmailText/MerchantSignup/Content").InnerText;
            string LinkURL = "<a href=\"" + String.Format("http://www.coupons4giving.ca/Offers/{0}", Name) + "\">" + String.Format("http://www.coupons4giving.ca/Offers/{0}", Name) + "</a>";
            string Content2 = doc.SelectSingleNode("/EmailText/MerchantSignup/Content2").InnerText;
            string ContactTextPrefix = doc.SelectSingleNode("/EmailText/ContactTextPrefix").InnerText;
            string ContactEmail = doc.SelectSingleNode("/EmailText/ContactEmail").InnerText;
            string ContactTextSuffix = doc.SelectSingleNode("/EmailText/ContactTextSuffix").InnerText;
            string Subject = doc.SelectSingleNode("/EmailText/MerchantSignup/Subject").InnerText;
            string LinkContent = doc.SelectSingleNode("/EmailText/MerchantSignup/LinkContent").InnerText;
            string LinkSuffix = doc.SelectSingleNode("/EmailText/MerchantSignup/LinkSuffix").InnerText;

            mm.Subject = Subject;
            mm.IsBodyHtml = true;

            string message = "";

            message += "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">";
            message += "<html>";
            message += "<head>";
            message += "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">";
            message += String.Format("<meta property=\"og:title\" content=\"{0}\">", Title);
            message += String.Format("<title>[0]</title>", Title);
            message += "</head>";
            message += "<body leftmargin=\"0\" marginwidth=\"0\" topmargin=\"0\" marginheight=\"0\" offset=\"0\" style=\"-webkit-text-size-adjust: none;margin: 0;padding: 0;background-color: #FAFAFA;width: 100%;\">";
            message += "<center>";
            message += "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" height=\"100%\" width=\"100%\" id=\"backgroundTable\" style=\"margin: 0;padding: 0;background-color: #FAFAFA;height: 100%;width: 100%;\">";
            message += "<tr>";
            message += "<td align=\"center\" valign=\"top\" style=\"border-collapse: collapse;\">";
            message += "<table border=\"0\" cellpadding=\"10\" cellspacing=\"0\" width=\"600\" id=\"templatePreheader\" style=\"background-color: #FAFAFA;\">";
            message += "<tr>";
            message += "<td valign=\"top\" class=\"preheaderContent\" style=\"border-collapse: collapse;\">";
            message += "<table border=\"0\" cellpadding=\"10\" cellspacing=\"0\" width=\"100%\">";
            message += "<tr>";
            message += "<td valign=\"top\" style=\"border-collapse: collapse;\">";
            message += "<div style=\"color: #505050;font-family: Arial;font-size: 10px;line-height: 100%;text-align: center;\">Thank you for registering with Coupons4Giving.ca. Click on the link below to access your new account.";
            message += "</div>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"600\" id=\"templateContainer\" style=\"border: 1px solid #DDD;background-color: #FFFFFF;\">";
            message += "<tr>";
            message += "<td align=\"center\" valign=\"top\" style=\"border-collapse: collapse;\">";
            message += "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"600\" id=\"templateHeader\" style=\"background-color: #FFFFFF;border-bottom: 0;\">";
            message += "<tr>";
            message += "<td class=\"headerContent\" style=\"border-collapse: collapse;color: #202020;font-family: Arial;font-size: 34px;font-weight: bold;line-height: 100%;padding: 0;text-align: center;vertical-align: middle;\">";
            message += "<img src=\"http://www.coupons4giving.ca/Images/c4g_email_header.png\" style=\"max-width: 600px;border: 0;height: auto;line-height: 100%;outline: none;text-decoration: none; padding-top: 20px;\" id=\"headerImage campaign-icon\">";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</td>";
            message += "</tr>";
            message += "<tr>";
            message += "<td align=\"center\" valign=\"top\" style=\"border-collapse: collapse;\">";
            message += "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"600\" id=\"templateBody\">";
            message += "<tr>";
            message += "<td valign=\"top\" class=\"bodyContent\" style=\"border-collapse: collapse;background-color: #FFFFFF;\">";
            message += "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">";
            message += "<tr>";
            message += "<td valign=\"top\" style=\"border-collapse: collapse;\">";
            message += "<table border=\"0\" cellpadding=\"20\" cellspacing=\"0\" width=\"100%\">";
            message += "<tr>";
            message += "<td valign=\"top\" style=\"border-collapse: collapse;\">";
            message += "<div style=\"color: #5e5e5e;font-family: Arial;font-size: 14px;line-height: 150%;text-align: center;\"><h1 class=\"h1\" style=\"color: #22bfe8;display: block;font-family: Arial;font-size: 28px;font-weight: bold;line-height: 100%;margin-top: 0;margin-right: 0;margin-bottom: 10px;margin-left: 0;text-align: center;\">Welcome To Coupons4Giving</h1>";
            message += "</div>";
            message += "<img src=\"http://www.coupons4giving.ca/Images/c4g_email_template_header1.png\" style=\"max-width: 560px;border: 0;height: auto;line-height: 100%;outline: none;text-decoration: none;display: inline; padding-bottom: 30px;\">";
            message += String.Format("<div style=\"color: #5e5e5e;font-family: Arial;font-size: 14px;line-height: 150%;text-align: center;\">{0}", Content + "<a href='mailto:" + ContactEmail + "'>" + ContactEmail + "</a>. " + LinkContent );
            message += "<h4 class=\"null tpl-content-highlight\" style=\"text-align: center;color: #5e5e5e;display: block;font-family: Arial;font-size: 22px;font-weight: bold;line-height: 100%;margin-top: 0;margin-right: 0;margin-bottom: 10px;margin-left: 0;\"><br>";
            message += String.Format("<strong><a href=\"{1}\" target=\"_blank\" style=\"color: #22bfe8;font-weight: normal;text-decoration: underline;\">{0}</a>&nbsp;{1}</strong></h4>", LinkContent, "http://www.coupons4giving.ca/Offers/New.aspx", LinkSuffix);
            message += String.Format("<p style=\"text-align: center;\"><strong>{0}&nbsp;<a href=\"mailto:{1}\" target=\"_blank\" style=\"color: #22bfe8;font-weight: normal;text-decoration: underline;\">{1}</a>&nbsp;{2}</strong></p>", ContactTextPrefix, ContactEmail, ContactTextSuffix);
            message += "<p style=\"text-align: center;\">Cheers!</p>";
            message += "</div>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</td>";
            message += "</tr>";
            message += "<tr>";
            message += "<td align=\"center\" valign=\"top\" style=\"border-collapse: collapse;\">";
            message += "<table border=\"0\" cellpadding=\"10\" cellspacing=\"0\" width=\"600\" id=\"templateFooter\" style=\"background-color: #FFFFFF;border-top: 0;\">";
            message += "<tr>";
            message += "<td valign=\"top\" class=\"footerContent\" style=\"border-collapse: collapse;\">";
            message += "<table border=\"0\" cellpadding=\"10\" cellspacing=\"0\" width=\"100%\">";
            message += "<tr>";
            message += "<td colspan=\"2\" valign=\"middle\" id=\"social\" style=\"border-collapse: collapse;background-color: #ecebe9;border: 0;\">";
            message += "<div style=\"color: #5e5e5e;font-family: Arial;font-size: 12px;line-height: 125%;text-align: center;\"><h3 class=\"null\" style=\"text-align: center;color: #202020;display: block;font-family: Arial;font-size: 26px;font-weight: bold;line-height: 100%;margin-top: 0;margin-right: 0;margin-bottom: 10px;margin-left: 0;\"><span style=\"font-size:18px;\"><span style=\"color:#ff9900;\">Connect with us on Social Media</span></span></h3>";
            message += "&nbsp;<a href=\"https://twitter.com/Coupons4Giving\" target=\"_blank\" style=\"color: #22bfe8;font-weight: normal;text-decoration: underline;\"><img align=\"none\" height=\"84\" src=\"http://www.coupons4giving.ca/Images/c4g_email_twitter.png\" style=\"width: 84px;height: 84px;border: 0;line-height: 100%;outline: none;text-decoration: none;display: inline;\" width=\"84\"></a><a href=\"http://www.facebook.com/Coupons4Giving\" target=\"_blank\" style=\"color: #22bfe8;font-weight: normal;text-decoration: underline;\"><img align=\"none\" height=\"84\" src=\"http://www.coupons4giving.ca/Images/c4g_email_facebook.png\" style=\"width: 84px;height: 84px;border: 0;line-height: 100%;outline: none;text-decoration: none;display: inline;\" width=\"84\"></a><a href=\"https://www.coupons4giving.ca/Home.aspx#\" target=\"_blank\" style=\"color: #22bfe8;font-weight: normal;text-decoration: underline;\"><img align=\"none\" height=\"84\" src=\"http://www.coupons4giving.ca/Images/c4g_email_linkedin.png\" style=\"width: 84px;height: 84px;border: 0;line-height: 100%;outline: none;text-decoration: none;display: inline;\" width=\"84\"></a></div>";
            message += "</td>";
            message += "</tr>";
            message += "<tr>";
            message += "<td valign=\"top\" width=\"550\" style=\"border-collapse: collapse;\">";
            message += "<div style=\"color: #5e5e5e;font-family: Arial;font-size: 12px;line-height: 125%;text-align: center;\">&copy; 2013 - GenerUS Marketing Solutions | Edmonton, Alberta, Canada</div>";
            message += "</td>";
            message += "</tr>";
            message += "<tr>";
            message += "<td colspan=\"2\" valign=\"middle\" id=\"utility\" style=\"border-collapse: collapse;background-color: #FFFFFF;border: 0;\">";
            //Replace with link to settings page to disable email notifications
            message += String.Format("<div style=\"color: #5e5e5e;font-family: Arial;font-size: 12px;line-height: 125%;text-align: center;\">To unsubscribe please contact us at&nbsp;<a href=\"mailto:{0}\" target=\"_blank\" style=\"color: #22bfe8;font-weight: normal;text-decoration: underline;\">{0}</a>.</div>", ContactEmail);
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "<br>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</center>";
            message += "</body>";
            message += "</html>";

            mm.Body = message;
            new SmtpClient().Send(mm);
        }

        public static void SendNPOSignupEmail(List<string> To, string Name)
        {
            MailMessage mm = new MailMessage();

            foreach (string item in To)
                mm.To.Add(item);

            XmlDocument doc = new XmlDocument();
            doc.Load(String.Format("EmailText ({0}).xml", WebConfigurationManager.AppSettings["Language"]));

            string Title = doc.SelectSingleNode("/EmailText/NPOSignup/Title").InnerText;
            string Content = doc.SelectSingleNode("/EmailText/NPOSignup/ContentPrefix").InnerText;
            string LinkURL = "<a href=\"" + String.Format("http://www.coupons4giving.ca/Offers/{0}", Name) + "\">" + String.Format("http://www.coupons4giving.ca/Offers/{0}", Name) + "</a>";
            string Content2 = doc.SelectSingleNode("/EmailText/NPOSignup/Content2").InnerText;
            string ContactTextPrefix = doc.SelectSingleNode("/EmailText/ContactTextPrefix").InnerText;
            string ContactEmail = doc.SelectSingleNode("/EmailText/ContactEmail").InnerText;
            string ContactTextSuffix = doc.SelectSingleNode("/EmailText/ContactTextSuffix").InnerText;
            string Subject = doc.SelectSingleNode("/EmailText/NPOSignup/Subject").InnerText;
            string LinkContent = doc.SelectSingleNode("/EmailText/NPOSignup/LinkContent").InnerText;
            string LinkSuffix = doc.SelectSingleNode("/EmailText/NPOSignup/LinkSuffix").InnerText;

            mm.Subject = Subject;
            mm.IsBodyHtml = true;

            string message = "";

            message += "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">";
            message += "<html>";
            message += "<head>";
            message += "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">";
            message += String.Format("<meta property=\"og:title\" content=\"{0}\">", Title);
            message += String.Format("<title>[0]</title>", Title);
            message += "</head>";
            message += "<body leftmargin=\"0\" marginwidth=\"0\" topmargin=\"0\" marginheight=\"0\" offset=\"0\" style=\"-webkit-text-size-adjust: none;margin: 0;padding: 0;background-color: #FAFAFA;width: 100%;\">";
            message += "<center>";
            message += "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" height=\"100%\" width=\"100%\" id=\"backgroundTable\" style=\"margin: 0;padding: 0;background-color: #FAFAFA;height: 100%;width: 100%;\">";
            message += "<tr>";
            message += "<td align=\"center\" valign=\"top\" style=\"border-collapse: collapse;\">";
            message += "<table border=\"0\" cellpadding=\"10\" cellspacing=\"0\" width=\"600\" id=\"templatePreheader\" style=\"background-color: #FAFAFA;\">";
            message += "<tr>";
            message += "<td valign=\"top\" class=\"preheaderContent\" style=\"border-collapse: collapse;\">";
            message += "<table border=\"0\" cellpadding=\"10\" cellspacing=\"0\" width=\"100%\">";
            message += "<tr>";
            message += "<td valign=\"top\" style=\"border-collapse: collapse;\">";
            message += "<div style=\"color: #505050;font-family: Arial;font-size: 10px;line-height: 100%;text-align: center;\">Thank you for registering with Coupons4Giving.ca. Click on the link below to access your new account.";
            message += "</div>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"600\" id=\"templateContainer\" style=\"border: 1px solid #DDD;background-color: #FFFFFF;\">";
            message += "<tr>";
            message += "<td align=\"center\" valign=\"top\" style=\"border-collapse: collapse;\">";
            message += "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"600\" id=\"templateHeader\" style=\"background-color: #FFFFFF;border-bottom: 0;\">";
            message += "<tr>";
            message += "<td class=\"headerContent\" style=\"border-collapse: collapse;color: #202020;font-family: Arial;font-size: 34px;font-weight: bold;line-height: 100%;padding: 0;text-align: center;vertical-align: middle;\">";
            message += "<img src=\"http://www.coupons4giving.ca/Images/c4g_email_header.png\" style=\"max-width: 600px;border: 0;height: auto;line-height: 100%;outline: none;text-decoration: none; padding-top: 20px;\" id=\"headerImage campaign-icon\">";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</td>";
            message += "</tr>";
            message += "<tr>";
            message += "<td align=\"center\" valign=\"top\" style=\"border-collapse: collapse;\">";
            message += "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"600\" id=\"templateBody\">";
            message += "<tr>";
            message += "<td valign=\"top\" class=\"bodyContent\" style=\"border-collapse: collapse;background-color: #FFFFFF;\">";
            message += "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">";
            message += "<tr>";
            message += "<td valign=\"top\" style=\"border-collapse: collapse;\">";
            message += "<table border=\"0\" cellpadding=\"20\" cellspacing=\"0\" width=\"100%\">";
            message += "<tr>";
            message += "<td valign=\"top\" style=\"border-collapse: collapse;\">";
            message += "<div style=\"color: #5e5e5e;font-family: Arial;font-size: 14px;line-height: 150%;text-align: center;\"><h1 class=\"h1\" style=\"color: #22bfe8;display: block;font-family: Arial;font-size: 28px;font-weight: bold;line-height: 100%;margin-top: 0;margin-right: 0;margin-bottom: 10px;margin-left: 0;text-align: center;\">Welcome To Coupons4Giving</h1>";
            message += "</div>";
            message += "<img src=\"http://www.coupons4giving.ca/Images/c4g_email_template_header1.png\" style=\"max-width: 560px;border: 0;height: auto;line-height: 100%;outline: none;text-decoration: none;display: inline; padding-bottom: 30px;\">";
            message += String.Format("<div style=\"color: #5e5e5e;font-family: Arial;font-size: 14px;line-height: 150%;text-align: center;\">{0}", Content + "<a href='mailto:" + ContactEmail + "'>" + ContactEmail + "</a>. " + LinkContent);
            message += "<h4 class=\"null tpl-content-highlight\" style=\"text-align: center;color: #5e5e5e;display: block;font-family: Arial;font-size: 22px;font-weight: bold;line-height: 100%;margin-top: 0;margin-right: 0;margin-bottom: 10px;margin-left: 0;\"><br>";
            message += String.Format("<strong><a href=\"{1}\" target=\"_blank\" style=\"color: #22bfe8;font-weight: normal;text-decoration: underline;\">{0}</a>&nbsp;{1}</strong></h4>", LinkContent, "http://www.coupons4giving.ca/Offers/New.aspx", LinkSuffix);
            message += String.Format("<p style=\"text-align: center;\"><strong>{0}&nbsp;<a href=\"mailto:{1}\" target=\"_blank\" style=\"color: #22bfe8;font-weight: normal;text-decoration: underline;\">{1}</a>&nbsp;{2}</strong></p>", ContactTextPrefix, ContactEmail, ContactTextSuffix);
            message += "<p style=\"text-align: center;\">Cheers!</p>";
            message += "</div>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</td>";
            message += "</tr>";
            message += "<tr>";
            message += "<td align=\"center\" valign=\"top\" style=\"border-collapse: collapse;\">";
            message += "<table border=\"0\" cellpadding=\"10\" cellspacing=\"0\" width=\"600\" id=\"templateFooter\" style=\"background-color: #FFFFFF;border-top: 0;\">";
            message += "<tr>";
            message += "<td valign=\"top\" class=\"footerContent\" style=\"border-collapse: collapse;\">";
            message += "<table border=\"0\" cellpadding=\"10\" cellspacing=\"0\" width=\"100%\">";
            message += "<tr>";
            message += "<td colspan=\"2\" valign=\"middle\" id=\"social\" style=\"border-collapse: collapse;background-color: #ecebe9;border: 0;\">";
            message += "<div style=\"color: #5e5e5e;font-family: Arial;font-size: 12px;line-height: 125%;text-align: center;\"><h3 class=\"null\" style=\"text-align: center;color: #202020;display: block;font-family: Arial;font-size: 26px;font-weight: bold;line-height: 100%;margin-top: 0;margin-right: 0;margin-bottom: 10px;margin-left: 0;\"><span style=\"font-size:18px;\"><span style=\"color:#ff9900;\">Connect with us on Social Media</span></span></h3>";
            message += "&nbsp;<a href=\"https://twitter.com/Coupons4Giving\" target=\"_blank\" style=\"color: #22bfe8;font-weight: normal;text-decoration: underline;\"><img align=\"none\" height=\"84\" src=\"http://www.coupons4giving.ca/Images/c4g_email_twitter.png\" style=\"width: 84px;height: 84px;border: 0;line-height: 100%;outline: none;text-decoration: none;display: inline;\" width=\"84\"></a><a href=\"http://www.facebook.com/Coupons4Giving\" target=\"_blank\" style=\"color: #22bfe8;font-weight: normal;text-decoration: underline;\"><img align=\"none\" height=\"84\" src=\"http://www.coupons4giving.ca/Images/c4g_email_facebook.png\" style=\"width: 84px;height: 84px;border: 0;line-height: 100%;outline: none;text-decoration: none;display: inline;\" width=\"84\"></a><a href=\"https://www.coupons4giving.ca/Home.aspx#\" target=\"_blank\" style=\"color: #22bfe8;font-weight: normal;text-decoration: underline;\"><img align=\"none\" height=\"84\" src=\"http://www.coupons4giving.ca/Images/c4g_email_linkedin.png\" style=\"width: 84px;height: 84px;border: 0;line-height: 100%;outline: none;text-decoration: none;display: inline;\" width=\"84\"></a></div>";
            message += "</td>";
            message += "</tr>";
            message += "<tr>";
            message += "<td valign=\"top\" width=\"550\" style=\"border-collapse: collapse;\">";
            message += "<div style=\"color: #5e5e5e;font-family: Arial;font-size: 12px;line-height: 125%;text-align: center;\">&copy; 2013 - GenerUS Marketing Solutions | Edmonton, Alberta, Canada</div>";
            message += "</td>";
            message += "</tr>";
            message += "<tr>";
            message += "<td colspan=\"2\" valign=\"middle\" id=\"utility\" style=\"border-collapse: collapse;background-color: #FFFFFF;border: 0;\">";
            //Replace with link to settings page to disable email notifications
            message += String.Format("<div style=\"color: #5e5e5e;font-family: Arial;font-size: 12px;line-height: 125%;text-align: center;\">To unsubscribe please contact us at&nbsp;<a href=\"mailto:{0}\" target=\"_blank\" style=\"color: #22bfe8;font-weight: normal;text-decoration: underline;\">{0}</a>.</div>", ContactEmail);
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "<br>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</center>";
            message += "</body>";
            message += "</html>";

            mm.Body = message;
            new SmtpClient().Send(mm);
        }

        public static void SendPurchaseEmail(PurchaseOrder item)
        {
            MailMessage mm = new MailMessage();

            mm.To.Add(Membership.GetUser().Email);

            mm.Subject = "Your Recent Coupons4Giving Purchase";
            mm.IsBodyHtml = true;
            Attachment pdf = new Attachment(PDFUtils.CreateCouponPDF(item));
            mm.Attachments.Add(pdf);

            string message = "";

            message += "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">";
            message += "<html>";
            message += "<head>";
            message += "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">";
            message += String.Format("<meta property=\"og:title\" content=\"{0}\">", "New Purchase");
            message += String.Format("<title>[0]</title>", "New Purchase");
            message += "</head>";
            message += "<body leftmargin=\"0\" marginwidth=\"0\" topmargin=\"0\" marginheight=\"0\" offset=\"0\" style=\"-webkit-text-size-adjust: none;margin: 0;padding: 0;background-color: #FAFAFA;width: 100%;\">";
            message += "<center>";
            message += "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" height=\"100%\" width=\"100%\" id=\"backgroundTable\" style=\"margin: 0;padding: 0;background-color: #FAFAFA;height: 100%;width: 100%;\">";
            message += "<tr>";
            message += "<td align=\"center\" valign=\"top\" style=\"border-collapse: collapse;\">";
            message += "<table border=\"0\" cellpadding=\"10\" cellspacing=\"0\" width=\"600\" id=\"templatePreheader\" style=\"background-color: #FAFAFA;\">";
            message += "<tr>";
            message += "<td valign=\"top\" class=\"preheaderContent\" style=\"border-collapse: collapse;\">";
            message += "<table border=\"0\" cellpadding=\"10\" cellspacing=\"0\" width=\"100%\">";
            message += "<tr>";
            message += "<td valign=\"top\" style=\"border-collapse: collapse;\">";
            message += "<div style=\"color: #505050;font-family: Arial;font-size: 10px;line-height: 100%;text-align: center;\">Thank you for registering with Coupons4Giving.ca. Click on the link below to access your new account.";
            message += "</div>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"600\" id=\"templateContainer\" style=\"border: 1px solid #DDD;background-color: #FFFFFF;\">";
            message += "<tr>";
            message += "<td align=\"center\" valign=\"top\" style=\"border-collapse: collapse;\">";
            message += "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"600\" id=\"templateHeader\" style=\"background-color: #FFFFFF;border-bottom: 0;\">";
            message += "<tr>";
            message += "<td class=\"headerContent\" style=\"border-collapse: collapse;color: #202020;font-family: Arial;font-size: 34px;font-weight: bold;line-height: 100%;padding: 0;text-align: center;vertical-align: middle;\">";
            message += "<img src=\"http://www.coupons4giving.ca/Images/c4g_email_header.png\" style=\"max-width: 600px;border: 0;height: auto;line-height: 100%;outline: none;text-decoration: none; padding-top: 20px;\" id=\"headerImage campaign-icon\">";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</td>";
            message += "</tr>";
            message += "<tr>";
            message += "<td align=\"center\" valign=\"top\" style=\"border-collapse: collapse;\">";
            message += "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"600\" id=\"templateBody\">";
            message += "<tr>";
            message += "<td valign=\"top\" class=\"bodyContent\" style=\"border-collapse: collapse;background-color: #FFFFFF;\">";
            message += "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">";
            message += "<tr>";
            message += "<td valign=\"top\" style=\"border-collapse: collapse;\">";
            message += "<table border=\"0\" cellpadding=\"20\" cellspacing=\"0\" width=\"100%\">";
            message += "<tr>";
            message += "<td valign=\"top\" style=\"border-collapse: collapse;\">";
            message += "<div style=\"color: #5e5e5e;font-family: Arial;font-size: 14px;line-height: 150%;text-align: center;\"><h1 class=\"h1\" style=\"color: #22bfe8;display: block;font-family: Arial;font-size: 28px;font-weight: bold;line-height: 100%;margin-top: 0;margin-right: 0;margin-bottom: 10px;margin-left: 0;text-align: center;\">Your Coupons4Giving Purchase</h1>";
            message += "</div>";
            message += "<img src=\"http://www.coupons4giving.ca/Images/c4g_email_template_header1.png\" style=\"max-width: 560px;border: 0;height: auto;line-height: 100%;outline: none;text-decoration: none;display: inline; padding-bottom: 30px;\">";
            message += "<div style=\"color: #5e5e5e;font-family: Arial;font-size: 14px;line-height: 150%;text-align: center;\"><p>Dear " + item.PurchaseTransaction.cUser.Username + "</p><p>Thanks for purchasing a coupon for " + item.DealInstance.Deal.Name + ". Attached is a pdf of your coupon with the details of your purchase and cause you supported. We have notified the merchant of your coupon purchase and they are standing by waiting to process your order. <a href='mailto:" + item.DealInstance.Deal.Merchant.Email + "'>Click here</a> to be connected to them directly.</p></div>";
            message += "<div style=\"color: #5e5e5e;font-family: Arial;font-size: 14px;line-height: 150%;text-align: center;\"><p>Please note that taxes and shipping may be extra.</div>";
            message += "<div style=\"color: #5e5e5e;font-family: Arial;font-size: 14px;line-height: 150%;text-align: center;\"><p>Thanks for using Coupons4Giving and supporting great causes!</div>";
            message += "<div style=\"color: #5e5e5e;font-family: Arial;font-size: 14px;line-height: 150%;text-align: center;\"><p>Cheers,</div>";
            message += "<div style=\"color: #5e5e5e;font-family: Arial;font-size: 14px;line-height: 150%;text-align: center;\"><p>The Coupons4Giving Team</div>";
            message += "<h4 class=\"null tpl-content-highlight\" style=\"text-align: center;color: #5e5e5e;display: block;font-family: Arial;font-size: 22px;font-weight: bold;line-height: 100%;margin-top: 0;margin-right: 0;margin-bottom: 10px;margin-left: 0;\"><br>";
            message += "</div>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</td>";
            message += "</tr>";
            message += "<tr>";
            message += "<td align=\"center\" valign=\"top\" style=\"border-collapse: collapse;\">";
            message += "<table border=\"0\" cellpadding=\"10\" cellspacing=\"0\" width=\"600\" id=\"templateFooter\" style=\"background-color: #FFFFFF;border-top: 0;\">";
            message += "<tr>";
            message += "<td valign=\"top\" class=\"footerContent\" style=\"border-collapse: collapse;\">";
            message += "<table border=\"0\" cellpadding=\"10\" cellspacing=\"0\" width=\"100%\">";
            message += "<tr>";
            message += "<td colspan=\"2\" valign=\"middle\" id=\"social\" style=\"border-collapse: collapse;background-color: #ecebe9;border: 0;\">";
            message += "<div style=\"color: #5e5e5e;font-family: Arial;font-size: 12px;line-height: 125%;text-align: center;\"><h3 class=\"null\" style=\"text-align: center;color: #202020;display: block;font-family: Arial;font-size: 26px;font-weight: bold;line-height: 100%;margin-top: 0;margin-right: 0;margin-bottom: 10px;margin-left: 0;\"><span style=\"font-size:18px;\"><span style=\"color:#ff9900;\">Connect with us on Social Media</span></span></h3>";
            message += "&nbsp;<a href=\"https://twitter.com/Coupons4Giving\" target=\"_blank\" style=\"color: #22bfe8;font-weight: normal;text-decoration: underline;\"><img align=\"none\" height=\"84\" src=\"http://www.coupons4giving.ca/Images/c4g_email_twitter.png\" style=\"width: 84px;height: 84px;border: 0;line-height: 100%;outline: none;text-decoration: none;display: inline;\" width=\"84\"></a><a href=\"http://www.facebook.com/Coupons4Giving\" target=\"_blank\" style=\"color: #22bfe8;font-weight: normal;text-decoration: underline;\"><img align=\"none\" height=\"84\" src=\"http://www.coupons4giving.ca/Images/c4g_email_facebook.png\" style=\"width: 84px;height: 84px;border: 0;line-height: 100%;outline: none;text-decoration: none;display: inline;\" width=\"84\"></a><a href=\"https://www.coupons4giving.ca/Home.aspx#\" target=\"_blank\" style=\"color: #22bfe8;font-weight: normal;text-decoration: underline;\"><img align=\"none\" height=\"84\" src=\"http://www.coupons4giving.ca/Images/c4g_email_linkedin.png\" style=\"width: 84px;height: 84px;border: 0;line-height: 100%;outline: none;text-decoration: none;display: inline;\" width=\"84\"></a></div>";
            message += "</td>";
            message += "</tr>";
            message += "<tr>";
            message += "<td valign=\"top\" width=\"550\" style=\"border-collapse: collapse;\">";
            message += "<div style=\"color: #5e5e5e;font-family: Arial;font-size: 12px;line-height: 125%;text-align: center;\">&copy; 2013 - GenerUS Marketing Solutions | Edmonton, Alberta, Canada</div>";
            message += "</td>";
            message += "</tr>";
            message += "<tr>";
            message += "<td colspan=\"2\" valign=\"middle\" id=\"utility\" style=\"border-collapse: collapse;background-color: #FFFFFF;border: 0;\">";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "<br>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</center>";
            message += "</body>";
            message += "</html>";

            mm.Body = message;
            new SmtpClient().Send(mm);

            MailMessage merchantMessage = new MailMessage();
            merchantMessage.To.Add(item.DealInstance.Deal.Merchant.Email);

            merchantMessage.Subject = "A New Coupons4Giving Purchase";
            merchantMessage.IsBodyHtml = true;
            merchantMessage.Attachments.Add(pdf);

            message = "";

            message += "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">";
            message += "<html>";
            message += "<head>";
            message += "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">";
            message += String.Format("<meta property=\"og:title\" content=\"{0}\">", "New Purchase");
            message += String.Format("<title>[0]</title>", "New Purchase");
            message += "</head>";
            message += "<body leftmargin=\"0\" marginwidth=\"0\" topmargin=\"0\" marginheight=\"0\" offset=\"0\" style=\"-webkit-text-size-adjust: none;margin: 0;padding: 0;background-color: #FAFAFA;width: 100%;\">";
            message += "<center>";
            message += "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" height=\"100%\" width=\"100%\" id=\"backgroundTable\" style=\"margin: 0;padding: 0;background-color: #FAFAFA;height: 100%;width: 100%;\">";
            message += "<tr>";
            message += "<td align=\"center\" valign=\"top\" style=\"border-collapse: collapse;\">";
            message += "<table border=\"0\" cellpadding=\"10\" cellspacing=\"0\" width=\"600\" id=\"templatePreheader\" style=\"background-color: #FAFAFA;\">";
            message += "<tr>";
            message += "<td valign=\"top\" class=\"preheaderContent\" style=\"border-collapse: collapse;\">";
            message += "<table border=\"0\" cellpadding=\"10\" cellspacing=\"0\" width=\"100%\">";
            message += "<tr>";
            message += "<td valign=\"top\" style=\"border-collapse: collapse;\">";
            message += "<div style=\"color: #505050;font-family: Arial;font-size: 10px;line-height: 100%;text-align: center;\">Thank you for registering with Coupons4Giving.ca. Click on the link below to access your new account.";
            message += "</div>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"600\" id=\"templateContainer\" style=\"border: 1px solid #DDD;background-color: #FFFFFF;\">";
            message += "<tr>";
            message += "<td align=\"center\" valign=\"top\" style=\"border-collapse: collapse;\">";
            message += "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"600\" id=\"templateHeader\" style=\"background-color: #FFFFFF;border-bottom: 0;\">";
            message += "<tr>";
            message += "<td class=\"headerContent\" style=\"border-collapse: collapse;color: #202020;font-family: Arial;font-size: 34px;font-weight: bold;line-height: 100%;padding: 0;text-align: center;vertical-align: middle;\">";
            message += "<img src=\"http://www.coupons4giving.ca/Images/c4g_email_header.png\" style=\"max-width: 600px;border: 0;height: auto;line-height: 100%;outline: none;text-decoration: none; padding-top: 20px;\" id=\"headerImage campaign-icon\">";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</td>";
            message += "</tr>";
            message += "<tr>";
            message += "<td align=\"center\" valign=\"top\" style=\"border-collapse: collapse;\">";
            message += "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"600\" id=\"templateBody\">";
            message += "<tr>";
            message += "<td valign=\"top\" class=\"bodyContent\" style=\"border-collapse: collapse;background-color: #FFFFFF;\">";
            message += "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">";
            message += "<tr>";
            message += "<td valign=\"top\" style=\"border-collapse: collapse;\">";
            message += "<table border=\"0\" cellpadding=\"20\" cellspacing=\"0\" width=\"100%\">";
            message += "<tr>";
            message += "<td valign=\"top\" style=\"border-collapse: collapse;\">";
            message += "<div style=\"color: #5e5e5e;font-family: Arial;font-size: 14px;line-height: 150%;text-align: center;\"><h1 class=\"h1\" style=\"color: #22bfe8;display: block;font-family: Arial;font-size: 28px;font-weight: bold;line-height: 100%;margin-top: 0;margin-right: 0;margin-bottom: 10px;margin-left: 0;text-align: center;\">Your Coupons4Giving Purchase</h1>";
            message += "</div>";
            message += "<img src=\"http://www.coupons4giving.ca/Images/c4g_email_template_header1.png\" style=\"max-width: 560px;border: 0;height: auto;line-height: 100%;outline: none;text-decoration: none;display: inline; padding-bottom: 30px;\">";
            message += "<div style=\"color: #5e5e5e;font-family: Arial;font-size: 14px;line-height: 150%;text-align: center;\"><p>Dear " + item.DealInstance.Deal.Merchant.Name + "</p><p>A coupon for " + item.DealInstance.Deal.Name + " has been purchased by " + Membership.GetUser(item.PurchaseTransaction.cUser.Username).Email + ". We have notified them that you are ready to process their order.</p></div>";
            message += "<div style=\"color: #5e5e5e;font-family: Arial;font-size: 14px;line-height: 150%;text-align: center;\"><p>Thanks for using Coupons4Giving and helping us to support great causes!</div>";
            message += "<div style=\"color: #5e5e5e;font-family: Arial;font-size: 14px;line-height: 150%;text-align: center;\"><p>Cheers,</div>";
            message += "<div style=\"color: #5e5e5e;font-family: Arial;font-size: 14px;line-height: 150%;text-align: center;\"><p>The Coupons4Giving Team</div>";
            message += "<h4 class=\"null tpl-content-highlight\" style=\"text-align: center;color: #5e5e5e;display: block;font-family: Arial;font-size: 22px;font-weight: bold;line-height: 100%;margin-top: 0;margin-right: 0;margin-bottom: 10px;margin-left: 0;\"><br>";
            message += "<div style=\"color: #5e5e5e;font-family: Arial;font-size: 14px;line-height: 150%;text-align: center;\"><h1 class=\"h1\" style=\"color: #22bfe8;display: block;font-family: Arial;font-size: 28px;font-weight: bold;line-height: 100%;margin-top: 0;margin-right: 0;margin-bottom: 10px;margin-left: 0;text-align: center;\">Customer's Coupons4Giving Purchase Message</h1>";
            message += "<div style=\"color: #5e5e5e;font-family: Arial;font-size: 14px;line-height: 150%;text-align: center;\"><h1 class=\"h1\" style=\"color: #22bfe8;display: block;font-family: Arial;font-size: 28px;font-weight: bold;line-height: 100%;margin-top: 0;margin-right: 0;margin-bottom: 10px;margin-left: 0;text-align: center;\">Your Coupons4Giving Purchase</h1>";
            message += "</div>";
            message += "<img src=\"http://www.coupons4giving.ca/Images/c4g_email_template_header1.png\" style=\"max-width: 560px;border: 0;height: auto;line-height: 100%;outline: none;text-decoration: none;display: inline; padding-bottom: 30px;\">";
            message += "<div style=\"color: #5e5e5e;font-family: Arial;font-size: 14px;line-height: 150%;text-align: center;\"><p>Dear " + item.PurchaseTransaction.cUser.Username + "</p><p>Thanks for purchasing a coupon for " + item.DealInstance.Deal.Name + ". Attached is a pdf of your coupon with the details of your purchase and cause you supported. We have notified the merchant of your coupon purchase and they are standing by waiting to process your order. <a href='mailto:" + item.DealInstance.Deal.Merchant.Email + "'>Click here</a> to be connected to them directly.</p></div>";
            message += "<div style=\"color: #5e5e5e;font-family: Arial;font-size: 14px;line-height: 150%;text-align: center;\"><p>Please note that taxes and shipping may be extra.</div>";
            message += "<div style=\"color: #5e5e5e;font-family: Arial;font-size: 14px;line-height: 150%;text-align: center;\"><p>Thanks for using Coupons4Giving and supporting great causes!</div>";
            message += "<div style=\"color: #5e5e5e;font-family: Arial;font-size: 14px;line-height: 150%;text-align: center;\"><p>Cheers,</div>";
            message += "<div style=\"color: #5e5e5e;font-family: Arial;font-size: 14px;line-height: 150%;text-align: center;\"><p>The Coupons4Giving Team</div>";
            message += "<h4 class=\"null tpl-content-highlight\" style=\"text-align: center;color: #5e5e5e;display: block;font-family: Arial;font-size: 22px;font-weight: bold;line-height: 100%;margin-top: 0;margin-right: 0;margin-bottom: 10px;margin-left: 0;\"><br>";
            message += "</div>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</td>";
            message += "</tr>";
            message += "<tr>";
            message += "<td align=\"center\" valign=\"top\" style=\"border-collapse: collapse;\">";
            message += "<table border=\"0\" cellpadding=\"10\" cellspacing=\"0\" width=\"600\" id=\"templateFooter\" style=\"background-color: #FFFFFF;border-top: 0;\">";
            message += "<tr>";
            message += "<td valign=\"top\" class=\"footerContent\" style=\"border-collapse: collapse;\">";
            message += "<table border=\"0\" cellpadding=\"10\" cellspacing=\"0\" width=\"100%\">";
            message += "<tr>";
            message += "<td colspan=\"2\" valign=\"middle\" id=\"social\" style=\"border-collapse: collapse;background-color: #ecebe9;border: 0;\">";
            message += "<div style=\"color: #5e5e5e;font-family: Arial;font-size: 12px;line-height: 125%;text-align: center;\"><h3 class=\"null\" style=\"text-align: center;color: #202020;display: block;font-family: Arial;font-size: 26px;font-weight: bold;line-height: 100%;margin-top: 0;margin-right: 0;margin-bottom: 10px;margin-left: 0;\"><span style=\"font-size:18px;\"><span style=\"color:#ff9900;\">Connect with us on Social Media</span></span></h3>";
            message += "&nbsp;<a href=\"https://twitter.com/Coupons4Giving\" target=\"_blank\" style=\"color: #22bfe8;font-weight: normal;text-decoration: underline;\"><img align=\"none\" height=\"84\" src=\"http://www.coupons4giving.ca/Images/c4g_email_twitter.png\" style=\"width: 84px;height: 84px;border: 0;line-height: 100%;outline: none;text-decoration: none;display: inline;\" width=\"84\"></a><a href=\"http://www.facebook.com/Coupons4Giving\" target=\"_blank\" style=\"color: #22bfe8;font-weight: normal;text-decoration: underline;\"><img align=\"none\" height=\"84\" src=\"http://www.coupons4giving.ca/Images/c4g_email_facebook.png\" style=\"width: 84px;height: 84px;border: 0;line-height: 100%;outline: none;text-decoration: none;display: inline;\" width=\"84\"></a><a href=\"https://www.coupons4giving.ca/Home.aspx#\" target=\"_blank\" style=\"color: #22bfe8;font-weight: normal;text-decoration: underline;\"><img align=\"none\" height=\"84\" src=\"http://www.coupons4giving.ca/Images/c4g_email_linkedin.png\" style=\"width: 84px;height: 84px;border: 0;line-height: 100%;outline: none;text-decoration: none;display: inline;\" width=\"84\"></a></div>";
            message += "</td>";
            message += "</tr>";
            message += "<tr>";
            message += "<td valign=\"top\" width=\"550\" style=\"border-collapse: collapse;\">";
            message += "<div style=\"color: #5e5e5e;font-family: Arial;font-size: 12px;line-height: 125%;text-align: center;\">&copy; 2013 - GenerUS Marketing Solutions | Edmonton, Alberta, Canada</div>";
            message += "</td>";
            message += "</tr>";
            message += "<tr>";
            message += "<td colspan=\"2\" valign=\"middle\" id=\"utility\" style=\"border-collapse: collapse;background-color: #FFFFFF;border: 0;\">";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "<br>";
            message += "</td>";
            message += "</tr>";
            message += "</table>";
            message += "</center>";
            message += "</body>";
            message += "</html>";

            merchantMessage.Body = message;
            new SmtpClient().Send(merchantMessage);
        }
    }

    public class PDFUtils
    {
        public static string CreateCouponPDF(PurchaseOrder item)
        {
            string result = "";
            Utilsmk.GetOrCreateFolder(HttpContext.Current.Request.PhysicalApplicationPath + "tmp\\" + HttpContext.Current.User.Identity.Name + "\\PDFs\\");

            string filePath = HttpContext.Current.Server.MapPath("~/tmp/" + HttpContext.Current.User.Identity.Name + "/PDFs/" + item.PurchaseOrderID + ".pdf");

            if (!File.Exists(filePath))
            {
                var googleQr = new GoogleQr("http://www.coupons4giving.ca/Merchant/MyCoupons/Redeem.aspx?cid=" + item.CouponCode.ToString("D"), "100x100", true);
                string qrText = googleQr.ToString();
                var qrImage = googleQr.Render();

                string htmlText = "<!DOCTYPE html lang='en'>";
                htmlText += "<head>";
                htmlText += "<meta charset='utf-8'>";
                htmlText += "<title>Your Coupon</title>";
                htmlText += "<link href='http://www.coupons4giving.ca/Content/style.css' rel='stylesheet'>";
                htmlText += "<link href='http://fonts.googleapis.com/css?family=Lato:300,400,700' rel='stylesheet' type='text/css'><link href='http://fonts.googleapis.com/css?family=Ubuntu:400,500,700' rel='stylesheet' type='text/css'><link href='http://netdna.bootstrapcdn.com/font-awesome/4.0.1/css/font-awesome.css' rel='stylesheet' type='text/css'>";
                //htmlText += "<style type='text/css'>#MainContent .coupon-image-block .qrImage img { width: auto; }</style>";
                htmlText += "</head>";
                htmlText += "<body>";
                htmlText += "<section id='MainContent'>";
                htmlText += "<div id='content' class='no-sidebar'>";
                htmlText += "<article class='c4g-coupon'>";
                //htmlText += "<img src='http://www.coupons4giving.ca/Images/c4g_coupon_logo.png' class='coupon_c4g_logo'>";
                htmlText += "<div class='coupon-title'>";
                htmlText += "<h2>" + item.DealInstance.Deal.Name + "</h2>";
                htmlText += "<h3>" + item.DealInstance.Deal.Merchant.Name + "</h3>";
                htmlText += "<h3 class='coupon-cost'>" + item.DealInstance.Deal.Prices.FirstOrDefault<Price>().GiftValue.ToString("C") + "</h3>";
                htmlText += "<span class='coupon-description'>";
                htmlText += "<p>" + item.DealInstance.Deal.DealDescription + "</p>";
                htmlText += "</span>";
                htmlText += "<div class='coupon-details'>";
                htmlText += "<div class='coupon-value'>";
                htmlText += "<h4>Value</h4>";
                htmlText += "<p><span>" + item.DealInstance.Deal.Prices.FirstOrDefault<Price>().RetailValue.ToString("C") + "</span></p>";
                htmlText += "</div>";
                htmlText += "<div class='coupon-discount'>";
                htmlText += "<h4>Discount</h4>";
                htmlText += "<p><span>" + (int)((1M - (item.DealInstance.Deal.Prices.FirstOrDefault<Price>().GiftValue / item.DealInstance.Deal.Prices.FirstOrDefault<Price>().RetailValue)) * 100) + "</span></p>";
                htmlText += "</div>";
                htmlText += "<div class='coupon-giving'>";
                htmlText += "<h4>You're Giving</h4>";
                htmlText += "<p><span>" + item.DealInstance.Deal.Prices.FirstOrDefault<Price>().NPOSplit.ToString("C") + "</span></p>";
                htmlText += "</div>";
                htmlText += "<div class='coupon-left'>";
                htmlText += "<h4>Coupons Left</h4>";
                htmlText += "<p><span>15</span></p>";
                htmlText += "</div>";
                htmlText += "</div>";
                htmlText += "</div>";
                htmlText += "<div class='coupon-image-block'>";
                htmlText += "<img src='http://www.coupons4giving.ca/" + item.DealInstance.Deal.ImageURL + "'>";
                htmlText += "<div class='coupon-info'>";
                htmlText += "<p class='coupon-date'><span>Dates:</span> " + item.DealInstance.StartDate.ToString("MMMM dd, yyyy") + " - " + item.DealInstance.EndDate.ToString("MMMM dd, yyy") + " </p>";
                htmlText += "<div class='qrImage'>";
                htmlText += qrImage;
                htmlText += "</div>";
                htmlText += "<p><strong>Your Coupon Code</strong></p>";
                htmlText += "<p>" + item.CouponCode + "</p>";
                htmlText += "</div>";
                htmlText += "</div>";
                htmlText += "<div class='clear'></div>";
                htmlText += "</article>";
                htmlText += "</div>";
                htmlText += "</section>";
                htmlText += "</body>";
                htmlText += "</html>";

                Document document = new Document();
                PdfWriter.GetInstance(document, new FileStream(filePath, FileMode.Create));
                document.Open();
                iTextSharp.text.html.simpleparser.HTMLWorker hw = new iTextSharp.text.html.simpleparser.HTMLWorker(document);
                hw.Parse(new StringReader(htmlText));
                document.Close();
            }

            result = HttpContext.Current.Server.MapPath("~/tmp/" + HttpContext.Current.User.Identity.Name + "/PDFs/" + item.PurchaseOrderID + ".pdf");

            return filePath;
        }
    }
}