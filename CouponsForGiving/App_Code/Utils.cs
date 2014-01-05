using CouponsForGiving.Data;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Configuration;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;

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
                        result += "<img src=\"../../Images/c4g_coupon_logo.png\" class=\"coupon_c4g_logo\" />";
                        result += "<div class=\"coupon-title-tile\">";
                        result += "<h2>" + item.Deal.Name + "</h2><!-- Merchant Offer -->";
                        result += "<h3><a href=\"MerchantPage.aspx?MerchantName=" + item.Deal.Merchant.Name + "\">" + item.Deal.Merchant.Name + "</a></h3><!-- Merchant Name -->";
                        result += "<p>" + item.Deal.DealDescription + "</p><!-- Merchant Offer Description -->";
                        result += "</div><!--Close Coupon Title -->";
                        result += "<div class=\"clear\"></div>";
                        result += "<div class=\"coupon-details-tile\">";
                        result += "<div class=\"coupon-value\">";
                        result += "<h4>Value</h4>";
                        result += "<p><span>$" + ((int)(item.Deal.Prices.FirstOrDefault<Price>().RetailValue)).ToString("D") + "</span></p> <!-- Coupon Value -->";
                        result += "</div> <!-- Close Coupon Value-->";
                        result += "<div class=\"coupon-discount\">";
                        result += "<h4>Discount</h4>";
                        result += "<p><span>" + (1 - (item.Deal.Prices.FirstOrDefault<Price>().GiftValue / item.Deal.Prices.FirstOrDefault<Price>().RetailValue)).ToString("0%") + "</span></p> <!-- Coupon Savings/Discount -->";
                        result += "</div> <!-- Close Coupon Value-->";
                        result += "<div class=\"coupon-giving\">";
                        result += "<h4>You're Giving</h4>";
                        result += "<p><span>$" + ((int)(item.Deal.Prices.FirstOrDefault<Price>().NPOSplit)).ToString("D") + "</span></p> <!-- NPO Return or portion -->";
                        result += "</div> <!-- Close Coupon Value-->";
                        result += "</div><!-- Close Details -->";
                        result += "<div class=\"clear\"></div>";
                        result += "<a href=\"../../Offers/" + item.Deal.Merchant.Name + "/" + item.Deal.Name + "\" class=\"btn-coupon\"><i class=\"fa fa-arrow-circle-o-right\"></i> More Details</a>";
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
                        result += "<h2>" + item.Deal.Name + "</h2><!-- Merchant Offer -->";
                        result += "<h3><a href=\"MerchantPage.aspx?MerchantName=" + item.Deal.Merchant.Name + "\">" + item.Deal.Merchant.Name + "</a></h3><!-- Merchant Name -->";
                        result += "<p>" + item.Deal.DealDescription + "</p><!-- Merchant Offer Description -->";
                        result += "</div><!--Close Coupon Title -->";
                        result += "<div class=\"clear\"></div>";
                        result += "<div class=\"coupon-details-tile\">";
                        result += "<div class=\"coupon-value\">";
                        result += "<h4>Value</h4>";
                        result += "<p><span>$" + ((int)(item.Deal.Prices.FirstOrDefault<Price>().RetailValue)).ToString("D") + "</span></p> <!-- Coupon Value -->";
                        result += "</div> <!-- Close Coupon Value-->";
                        result += "<div class=\"coupon-discount\">";
                        result += "<h4>Discount</h4>";
                        result += "<p><span>" + (1 - (item.Deal.Prices.FirstOrDefault<Price>().GiftValue / item.Deal.Prices.FirstOrDefault<Price>().RetailValue)).ToString("0%") + "</span></p> <!-- Coupon Savings/Discount -->";
                        result += "</div> <!-- Close Coupon Value-->";
                        result += "<div class=\"coupon-giving\">";
                        result += "<h4>You're Giving</h4>";
                        result += "<p><span>$" + ((int)(item.Deal.Prices.FirstOrDefault<Price>().NPOSplit)).ToString("D") + "</span></p> <!-- NPO Return or portion -->";
                        result += "</div> <!-- Close Coupon Value-->";
                        result += "</div><!-- Close Details -->";
                        result += "<div class=\"clear\"></div>";
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
                        result += "<h2>" + item.Name + "</h2><!-- Camapign Title -->";
                        result += "<h3>" + (item.StartDate != null ? item.StartDate.Value.ToString("MMMM dd, yyyy") : "") + " - " + (item.EndDate != null ? item.EndDate.Value.ToString("MMMM dd, yyyy") : "") + "</h3><!-- Campaign Dates Format in anyway that works for you-->";
                        result += "</div><!--Close Coupon Title -->";
                        result += "<div class=\"clear\"></div>";
                        result += "<div class=\"campaign-details-tile\">";
                        result += "<p>" + item.CampaignDescription + "</p><!-- Coupon Description (limited to 200 characters if possible -->";
                        result += "</div><!-- Close Details -->";
                        result += "<div class=\"clear\"></div>";
                        result += "<a href=\"../../Causes/" + item.NPO.Name + "/" + item.Name + "\" class=\"btn-coupon\"><i class=\"fa fa-arrow-circle-o-right\"></i> Campaign Details</a><!-- Link To Campaign Page -->";
                        result += "</article>";
                        result += "</div>";
                    }
                else
                    result = "<p>We currently aren't running any campaigns in your city. <strong>Please check back soon!</strong></p><br /><a href=\"AllCauses.aspx\" class=\"btn\">See all our Campaigns!</a>";

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
                        result += "<h2>" + item.Name + "</h2><!-- Camapign Title -->";
                        result += "<h3>" + (item.StartDate != null ? item.StartDate.Value.ToString("MMMM dd, yyyy") : "") + " - " + (item.EndDate != null ? item.EndDate.Value.ToString("MMMM dd, yyyy") : "") + "</h3><!-- Campaign Dates Format in anyway that works for you-->";
                        result += "</div><!--Close Coupon Title -->";
                        result += "<div class=\"clear\"></div>";
                        result += "<div class=\"campaign-details-tile\">";
                        result += "<p>" + item.CampaignDescription + "</p><!-- Coupon Description (limited to 200 characters if possible -->";
                        result += "</div><!-- Close Details -->";
                        result += "<div class=\"clear\"></div>";
                        result += "<a href=\"Campaigns/Edit.aspx?cid=" + item.CampaignID + "\" class=\"btn-coupon\"><i class=\"fa fa-arrow-circle-o-right\"></i> Edit</a><!-- Link To Campaign Page -->";
                        result += "</article>";
                        result += "</div>";
                    }
                else
                    result = "<p>We currently aren't running any campaigns in your city. <strong>Please check back soon!</strong></p><br /><a href=\"AllCauses.aspx\" class=\"btn\">See all our Campaigns!</a>";

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
                        result += "<h2>" + (item.Deal.Name.Length > 15 ? item.Deal.Name.Substring(0, 12) + "..." : item.Deal.Name) + "</h2><!-- Camapign Title -->";
                        result += "<h3>" + (item.StartDate != null ? item.StartDate.ToString("MMMM dd, yyyy") : "") + " - " + (item.EndDate != null ? item.EndDate.ToString("MMMM dd, yyyy") : "") + "</h3><!-- Campaign Dates Format in anyway that works for you-->";
                        result += "</div><!--Close Coupon Title -->";
                        result += "<div class=\"clear\"></div>";
                        result += "<div class=\"campaign-details-tile\">";
                        result += "<p>" + (item.Deal.DealDescription.Length > 30 ? item.Deal.DealDescription.Substring(0, 27) + "..." : item.Deal.DealDescription) + "</p><!-- Coupon Description (limited to 200 characters if possible -->";
                        result += "</div><!-- Close Details -->";
                        result += "<div class=\"clear\"></div>";
                        result += "<a href=\"DealPage.aspx?merchantname=" + item.Deal.Merchant.Name + "&deal=" + item.Deal.Name + "\" class=\"btn-coupon\"><i class=\"fa fa-arrow-circle-o-right\"></i> Offer Details</a><!-- Link To Campaign Page -->";
                        result += "</article>";
                        result += "</div>";
                    }
                else
                    result = "<p>We currently aren't running any offers. <strong>Please check back soon!</strong></p>";

            return result;
        }

        public static string GetMerchantOffer(Deal deal)
        {
            string result = "";

            result += "<div class=\"thirds\">";
            result += "<article class=\"c4g-coupon-tile\">";
            result += "<img src=\"../Images/c4g_coupon_logo.png\" class=\"coupon_c4g_logo\" />";
            result += "<div class=\"coupon-title-tile\">";
            result += "<h2>" + deal.Name + "</h2><!-- Merchant Offer -->";
            result += "<p>" + deal.DealDescription + "</p><!-- Merchant Offer Description -->";
            result += "</div><!--Close Coupon Title -->";
            result += "<div class=\"clear\"></div>";
            result += "<div class=\"coupon-details-tile\">";
            result += "<div class=\"coupon-value\">";
            result += "<h4>Value</h4>";
            result += "<p><span>$" + ((int)(deal.Prices.FirstOrDefault<Price>().RetailValue)).ToString("D") + "</span></p> <!-- Coupon Value -->";
            result += "</div> <!-- Close Coupon Value-->";
            result += "<div class=\"coupon-discount\">";
            result += "<h4>Discount</h4>";
            result += "<p><span>" + (1 - (deal.Prices.FirstOrDefault<Price>().GiftValue / deal.Prices.FirstOrDefault<Price>().RetailValue)).ToString("0%") + "</span></p> <!-- Coupon Savings/Discount -->";
            result += "</div> <!-- Close Coupon Value-->";
            result += "<div class=\"coupon-giving\">";
            result += "<h4>You're Giving</h4>";
            result += "<p><span>$" + ((int)(deal.Prices.FirstOrDefault<Price>().NPOSplit)).ToString("D") + "</span></p> <!-- NPO Return or portion -->";
            result += "</div> <!-- Close Coupon Value-->";
            result += "</div><!-- Close Details -->";
            result += "<div class=\"clear\"></div>";
            result += "<a href=\"DealPage.aspx?merchantname=" + deal.Merchant.Name + "&deal=" + deal.Name + "\" class=\"btn-coupon\"><i class=\"fa fa-arrow-circle-o-right\"></i> More Details</a>";
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
            result += "<div class=\"coupon-title-tile\">";
            result += "<h2><a href=\"NPOPage.aspx?nponame=" + campaign.NPO.URL + "\"> " + campaign.Name + "</a></h2><!-- Merchant Offer -->";
            result += "<div class=\"campaign-details-tile\">";
            result += "<p>" + campaign.CampaignDescription + "</p><!-- Merchant Offer Description -->";
            result += "</div>";
            result += "</div><!--Close Coupon Title -->";
            result += "<div class=\"clear\"></div>";
            result += "<div class=\"clear\"></div>";
            result += "<a href=\"javascript:AddToCart(" + deal.DealInstanceID + ", " + campaign.CampaignID + ")\" class=\"btn-coupon\"><i class=\"fa fa-arrow-circle-o-right\"></i> Buy Now</a>";
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
            result += "<h2>" + campaign.Name + "</h2><!-- Merchant Offer -->";
            result += "<div class=\"campaign-details-tile\">";
            result += "<p>" + campaign.CampaignDescription + "</p><!-- Merchant Offer Description -->";
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
}