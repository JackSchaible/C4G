using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CouponsForGiving.Data;
using CouponsForGiving;
using System.Drawing;
using System.Transactions;
using System.Globalization;
using System.Xml.Linq;
using System.Web.Script.Services;
using System.Web.Services;
using CouponsForGiving.Data.Classes;
using System.Net.Mail;
using System.Web.Security;
using System.Web.Configuration;
using System.Xml;
using System.IO;

public partial class Merchant_Deals_New : System.Web.UI.Page
{
    public Merchant merch;
    public XmlDocument strings;

    protected void Page_Load(object sender, EventArgs e)
    {
        Controls_MenuBar control = (Controls_MenuBar)Master.FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.Merchant;

        strings = new XmlDocument();
        strings.Load(Server.MapPath(String.Format("Text ({0}).xml", WebConfigurationManager.AppSettings["Language"])));

        try
        {
            merch = SysDatamk.Merchant_GetByUsername(User.Identity.Name);
        }
        catch (Exception ex)
        {
            ex.ToString();
            Response.Redirect("../Signup.aspx");
        }
    }

    [WebMethod]
    [ScriptMethod]
    public static string CheckName(string name)
    {
        return Deals.ListNamesByMerchant(HttpContext.Current.User.Identity.Name).Contains(name).ToString();
    }

    [WebMethod]
    [ScriptMethod]
    public static string CreateOffer(string Name, string Description, string sDate, string eDate, string AbsCouponLimit, string PCLimit,
        string rValue, string gValue, string[] rDetails, string AdditionalRedeemDetails)
    {
        string result = "";
        List<string> errors = new List<string>();
        XmlDocument strings = new XmlDocument();
        strings.Load(HttpContext.Current.Server.MapPath(String.Format("Text ({0}).xml", WebConfigurationManager.AppSettings["Language"])));
        Validation validation = null;
        switch (WebConfigurationManager.AppSettings["Language"])
        {
            case "EN-US":
                validation = new Validation_EN_US();
                break;
        }
        DateTime StartDate = DateTime.Parse(sDate);
        DateTime EndDate = DateTime.Parse(eDate);
        int AbsoluteCouponLimit = -1;
        int LimitPerCustomer = -1;
        decimal RetailValue = -1M;
        decimal GiftValue = -1M;
        string logoPath = "";
        List<string> RedeemDetails = rDetails.ToList<string>();

        for (int i = 0; i < RedeemDetails.Count; i++)
            RedeemDetails[i] = RedeemDetails[i].Trim();

        try
        {
            AbsoluteCouponLimit = int.Parse(AbsCouponLimit);
        }
        catch(Exception ex)
        {
            ex.ToString();
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/CouponLimitNAN").InnerText);
        }

        try
        {
            LimitPerCustomer = int.Parse(PCLimit);
        }
        catch (Exception ex)
        {
            ex.ToString();
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/PCCouponLimitNAN").InnerText);
        }

        try
        {
            RetailValue = decimal.Parse(rValue);
        }
        catch(Exception ex)
        {
            ex.ToString();
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/RetailValueNAN").InnerText);
        }

        try
        {
            GiftValue = decimal.Parse(gValue);
        }
        catch(Exception ex)
        {
            ex.ToString();
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/GiftValueNAN").InnerText);
        }

        decimal mSplit = decimal.Parse(WebConfigurationManager.AppSettings["MerchantSplit"]);
        decimal nSplit = decimal.Parse(WebConfigurationManager.AppSettings["NPOSplit"]);
        decimal oSplit = decimal.Parse(WebConfigurationManager.AppSettings["OurSplit"]);
        
        decimal vat = (GiftValue * 0.029M) + 0.3M;
        decimal tax = (GiftValue * 0.2M) * 0.05M;
        decimal split = (GiftValue * 0.55M) - (tax);

        decimal MerchantSplit = (GiftValue * 0.55M) - (tax);
        decimal NPOSplit = GiftValue * nSplit;
        decimal OurSplit = (GiftValue * oSplit) + tax;

        //Validate
        if (validation.IsStringBlank(Name))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/NullOfferName").InnerText);

        if (validation.IsStringTooShort(Name, 5))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/OfferNameTooShort").InnerText);

        if (validation.IsStringTooLong(Name, 50))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/OfferNameTooLong").InnerText);

        if (validation.ContainsCode(Name))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/OfferNameInvalidCharacters").InnerText);

        if (bool.Parse(CheckName(Name)))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/OfferNameTaken").InnerText);

        if (validation.IsStringBlank(Description))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/NullDescription").InnerText);

        if (!validation.ContainsSpaces(Description))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/DescriptionOneWord").InnerText);

        if (validation.IsStringTooLong(Description, 200))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/DescriptionTooLong").InnerText);

        if (validation.IsStringTooShort(Description, 10))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/DescriptionTooShort").InnerText);

        if (validation.ContainsCode(Description))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/DescriptionInvalidCharacters").InnerText);

        if (StartDate >= EndDate)
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/StartDateLaterThanEndDate").InnerText);

        if (StartDate >= EndDate)
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/EndDateEarlierThanStartDate").InnerText);

        if (EndDate < DateTime.Now)
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/EndDateBeforeToday").InnerText);

        if (validation.IsStringBlank(AbsCouponLimit))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/NullAbsoluteCouponLimit").InnerText);

        if (!validation.IsNumberLarger(AbsoluteCouponLimit, 0))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/CouponLimitLT0").InnerText);

        if (LimitPerCustomer != -1)
            if (!validation.IsNumberLargerOrEqual(AbsoluteCouponLimit, LimitPerCustomer))
                errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/CouponLimitLessThanCustomerLimit").InnerText);

        if (validation.IsStringBlank(PCLimit))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/NullPCCouponLimit").InnerText);

        if (!validation.IsNumberLarger(LimitPerCustomer, 0))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/PCCouponLimitLT0").InnerText);

        if (AbsoluteCouponLimit != -1)
            if (!validation.IsNumberLargerOrEqual(AbsoluteCouponLimit, LimitPerCustomer))
                errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/PCCouponLimitGreaterThanAbsoluteLimit").InnerText);

        if (validation.IsStringBlank(rValue))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/NullRetailValue").InnerText);

        if (!validation.IsNumberLarger(RetailValue, 1))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/RetailValueLT1").InnerText);

        if (GiftValue != -1)
            if (!validation.IsNumberLargerOrEqual(RetailValue, GiftValue))
                errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/RetailValueLessThanGiftValue").InnerText);

        if (validation.IsStringBlank(gValue))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/NullGiftValue").InnerText);

        if (!validation.IsNumberLarger(GiftValue, 1))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/GiftValueLT1").InnerText);

        if (RetailValue != -1)
            if (validation.IsNumberLargerOrEqual(GiftValue, RetailValue))
                errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/GiftValueGreaterThanRetailValue").InnerText);

        if (validation.IsStringTooLong(AdditionalRedeemDetails, 500))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/GiftValueGreaterThanRetailValue").InnerText);

        if (validation.ContainsCode(AdditionalRedeemDetails))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/GiftValueGreaterThanRetailValue").InnerText);

        Merchant merchant = Merchants.GetByUsername(HttpContext.Current.User.Identity.Name);
        string username = HttpContext.Current.User.Identity.Name;

        //If there're no errors, commit to db
        if (errors.Count == 0)
        {
            int dealID = -1;
            int dealInstanceID = -1;

            //Save image
            //Check to see if there's a temp image, assign default if not
            DirectoryInfo root = new DirectoryInfo(HttpContext.Current.Server.MapPath("~/tmp/Images/Offers"));
            FileInfo[] listFiles = root.GetFiles(HttpContext.Current.User.Identity.Name + "logo.*");

            if (listFiles.Length > 0)
            {
                logoPath = HttpContext.Current.Server.MapPath("..\\Images\\Merchant\\" + merchant.Name + "\\Offers");
                logoPath = Utilsmk.GetOrCreateFolder(logoPath) + listFiles[0].Name;
                listFiles[0].MoveTo(logoPath);
                logoPath = logoPath.Replace(HttpContext.Current.Request.ServerVariables["APPL_PHYSICAL_PATH"], String.Empty);
            }
            else
                logoPath = "Images/c4g_home_npos_step4.png";

            using (TransactionScope ts = new TransactionScope())
            {
                try
                {
                    //Create deal
                    dealID = Deals.Insert(merchant.MerchantID, Name, Description, AbsoluteCouponLimit, LimitPerCustomer, logoPath);

                    //Add extra deal stuff
                    //Add deal instance
                    dealInstanceID = SysDatamk.AddDealInstance(dealID, StartDate, EndDate, DateTime.Now, DateTime.Now, 2);

                    //Add pricing
                    int newPriceID = SysDatamk.AddPrice(dealID, RetailValue, GiftValue, MerchantSplit, NPOSplit, OurSplit);

                    //Add deal locations
                    if (merchant.MerchantLocations.Count > 0)
                        SysDatamk.AddDealMerchantLocation(dealID, merchant.MerchantLocations.FirstOrDefault<MerchantLocation>().MerchantLocationID);

                    //Add redeem details
                    foreach (string item in RedeemDetails)
                            FinePrints.Add(dealID, int.Parse(item));

                    SysDatamk.AddRedeemDetails(dealID, AdditionalRedeemDetails, "", "", "");

                    ts.Complete();
                }
                catch (Exception ex)
                {
                    ex.ToString();
                    errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/ServerError").InnerText);

                    try
                    {
                        ts.Dispose();
                    }
                    catch (Exception ex2)
                    {
                        ex2.ToString();
                        errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/ServerError").InnerText);
                        ts.Dispose();
                    }
                }
            }

            //Send email
            List<string> to = new List<string>();
            to.Add(Membership.GetUser(HttpContext.Current.User.Identity.Name).Email);
            EmailUtils.SendOfferCreationEmail(to, merchant.Name, Name);
            result = "DealPage.aspx?deal=" + Name + "&merchantname=" + merchant.Name;
        }

        if (errors.Count > 0)
            throw new Exception(validation.WriteClientErrorsList(errors));

        return result;
    }

    //[ScriptMethod]
    //[WebMethod]
    //public static string AddLocation(string locationID)
    //{
    //    string result = "OK";

    //    int location = int.Parse(locationID);
    //    List<int> locations = new List<int>();

    //    if (HttpContext.Current.Session["Locations"] != null)
    //        locations = (List<int>)HttpContext.Current.Session["Locations"];

    //    locations.Add(location);
    //    HttpContext.Current.Session["Locations"] = locations;
        
    //    return result;
    //}

    //[ScriptMethod]
    //[WebMethod]
    //public static string RemoveLocation(string locationID)
    //{
    //    string result = "OK";

    //    List<int> locations = (List<int>)HttpContext.Current.Session["Locations"];
    //    locations.Remove(int.Parse(locationID));
    //    HttpContext.Current.Session["Locations"] = locations;

    //    return result;
    //}
}