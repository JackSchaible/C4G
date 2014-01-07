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

    private void BindData()
    {
        //List<object> locations =
        //    (
        //        from m
        //        in merch.MerchantLocations
        //        select new
        //        {
        //            LocationID = m.MerchantLocationID,
        //            Address = m.cAddress,
        //            LocationCity = m.City.Name,
        //            Province = m.City.PoliticalDivision.Name,
        //            Country = m.City.Country.Name,
        //            Phone = Convert.ToInt64(m.PhoneNumber).ToString("(###) ###-####"),
        //            ShortProvince = m.City.PoliticalDivision.DivisionCode,
        //            ShortCountry = m.City.Country.CountryCode
        //        }
        //    ).ToList<object>();

        //if (locations.Count == 0)
        //{
        //    LocationsPanel.Visible = false;
        //    LocationsPanel.Enabled = false;
        //}
        //else
        //{
        //    LocationsPanel.Visible = true;
        //    LocationsPanel.Enabled = true;

        //    LocationsGV.DataSource = locations;
        //    LocationsGV.DataBind();
        //}
    }
    /*
    protected void newDealSubmit_Click(object sender, EventArgs e)
    {
        try
        {
            bool valid = true;

            //Form variable declarations
            string newName = newDealName.Text.Trim();

            string newDescription = newDealDescription.Text.Trim();
            string testnewAbsoluteCouponLimit = newDealAbsoluteCouponLimit.Text.Trim();
            string testnewLimitPerCustomer = newDealLimitPerCustomer.Text.Trim();

            string testRetail = newDealRetailValue.Text.Trim().Replace(",", "").Replace(" ", "").Replace("$", "");
            string testGift = newDealGiftValue.Text.Trim().Replace(",", "").Replace(" ", "").Replace("$", "");

            //Assign default values to optional fields
            if (testnewLimitPerCustomer == "")
                testnewLimitPerCustomer = "0";

            if (testnewAbsoluteCouponLimit == "")
                testnewAbsoluteCouponLimit = "0";

            //Check for nulls
            if ((newName == "") || (newDescription == "") || (testnewAbsoluteCouponLimit == "") 
                || (testnewLimitPerCustomer == "") || (testRetail == "") || (testGift == ""))
            {
                valid = false;
                newDealMessage.Text = "All fields are required.";
            }

            //Placeholder variables
            DateTime startDate = DateTime.Now, endDate = DateTime.Now;

            decimal newRetailValue = -1M;
            decimal newGiftValue = -1M;

            int newAbsoluteCouponLimit = -1;
            int newLimitPerCustomer = -1;

            decimal newMerchantSplit = -1M;
            decimal newNPOSplit = -1M;
            decimal newOurSplit = -1M;

            List<int> DealLocationIDs = new List<int>();

            //Assign values, check for invalid data
            startDate = StartDate.Date;
            endDate = EndDate.Date;

            if (startDate != null && endDate != null)
            {
                if (endDate < startDate)
                {
                    valid = false;
                    newDealMessage.Text = "The End date of your offer must be after its Start Date.";
                }
            }
            else
            {
                valid = false;
                newDealMessage.Text = "Something's gone wrong. Please try again, and make sure the Offer Start and Offer End Dates are correct.";
            }

            try
            {
                newAbsoluteCouponLimit = int.Parse(testnewAbsoluteCouponLimit);
            }
            catch (Exception ex)
            {
                valid = false;
                newDealMessage.Text = "The Absolute Coupon Limit of your offer is not a valid number (i.e., 3000).";
                ex.ToString();
            }

            try
            {
                newLimitPerCustomer = int.Parse(testnewLimitPerCustomer);
            }
            catch (Exception ex)
            {
                valid = false;
                newDealMessage.Text = "The Coupon Limit Per Customer of your offer is not a valid number (i.e., 3000).";
                ex.ToString();
            }

            try
            {
                newRetailValue = Decimal.Parse(testRetail);
            }
            catch (Exception ex)
            {
                newDealMessage.Text = "The regular Retail Value of your offer is invalid. (i.e., 15.00)";
                ex.ToString();
                valid = false;
            }

            try
            {
                newGiftValue = Decimal.Parse(testGift);
            }
            catch (Exception ex)
            {
                newDealMessage.Text = "The Gift Value of your offer is invalid. (i.e., 15.00)";
                ex.ToString();
                valid = false;
            }

            if (newGiftValue >= newRetailValue)
            {
                valid = false;
                newDealMessage.Text = "The Gift value of your offer must be less than its regular Retail value.";
            }

            try
            {
                decimal mSplit = decimal.Parse(WebConfigurationManager.AppSettings["MerchantSplit"]);
                decimal nSplit = decimal.Parse(WebConfigurationManager.AppSettings["NPOSplit"]);
                decimal oSplit = decimal.Parse(WebConfigurationManager.AppSettings["OurSplit"]);
                newMerchantSplit = newGiftValue * mSplit;
                newNPOSplit = newGiftValue * nSplit;
                newOurSplit = newGiftValue * oSplit;
            }
            catch (Exception ex)
            {
                valid = false;
                newDealMessage.Text = String.Format("Something has gone wrong. Please use the Contact Us button above, and retain this error message: {0}", ex.Message);
            }

            try
            {
                List<int> locations =
                    (
                        from m
                        in merch.MerchantLocations
                        select m.MerchantLocationID
                    ).ToList<int>();

                if (locations.Count < 2)
                {
                    if (locations.Count > 0)
                        DealLocationIDs.Add(merch.MerchantLocations.FirstOrDefault<MerchantLocation>().MerchantLocationID);
                }
                else
                {
                    DealLocationIDs = (List<int>)Session["Locations"];
                }
            }
            catch(Exception ex)
            {
                valid = false;
                newDealMessage.Text = String.Format("Something has gone wrong. Please use the Contact Us button above, and retain this error message: {0}", ex.Message);
            }

            if (!dealImage.HasFile)
            {
                valid = false;
                newDealMessage.Text = "You must upload an image of your offer. This is what people will see when they browser your offer.";
            }
            else
            {
                if (!(Utilsmk.ValidImage(dealImage.PostedFile.InputStream)))
                {
                    valid = false;
                    newDealMessage.Text = "Your offer image is not a valid file type. Accepted types are .png, .jpeg, .png, and .gif.";
                }
                else
                {
                    if (!(Utilsmk.ValidLogoSize(dealImage.PostedFile.ContentLength)))
                    {
                        valid = false;
                        newDealMessage.Text = "Your offer image must be smaller than 4 MB.";
                    }
                }
            }

            //If there're no errors, commit to db
            if (valid)
            {
                int newDealID = -1;
                int newInstanceID = -1;

                //Save image
                string virtualPath = Utilsmk.SaveNewDealImage(dealImage.PostedFile, merch.MerchantID, Server, newName).Replace(Request.ServerVariables["APPL_PHYSICAL_PATH"], String.Empty);

                using (TransactionScope ts = new TransactionScope())
                {
                    try
                    {
                        //Create deal
                        newDealID = Deals.Insert(merch.MerchantID, newName, newDescription, newAbsoluteCouponLimit, newLimitPerCustomer, virtualPath);

                        //Add extra deal stuff
                        //Add deal instance
                        newInstanceID = SysDatamk.AddDealInstance(newDealID, startDate, endDate, DateTime.Now, DateTime.Now, 2);

                        //Add pricing
                        int newPriceID = SysDatamk.AddPrice(newDealID, newRetailValue, newGiftValue, newMerchantSplit, newNPOSplit, newOurSplit);

                        //Add deal locations
                        foreach (int item in DealLocationIDs)
                            SysDatamk.AddDealMerchantLocation(newDealID, item);

                        //Add redeem details
                        foreach (ListItem item in FinePrintList.Items)
                            if (item.Selected)
                                FinePrints.Add(newDealID, int.Parse(item.Value));

                        SysDatamk.AddRedeemDetails(newDealID, AdditionalDetailsTextBox.Text.Trim(), "", "", "");

                        ts.Complete();
                    }
                    catch (Exception ex)
                    {
                        newDealMessage.Text = String.Format("Something's gone wrong. Please use the Contact Us button above, and retain this error message: {0}", ex.Message);

                        try
                        {
                            ts.Dispose();
                        }
                        catch (Exception ex2)
                        {
                            newDealMessage.Text = String.Format("Something's gone wrong. Please use the Contact Us button above, and retain this error message: Error rolling back transaction: ORIGINAL ERROR || {0} || INNER ERROR || {1}", ex.Message, ex2.Message);
                            ts.Dispose();
                        }
                    }
                }

                MailMessage mm = new MailMessage();
                mm.To.Add(new MailAddress(Membership.GetUser().Email));

                mm.Subject = "C4G: Your New Account";
                mm.IsBodyHtml = true;
                mm.Body = @"
                            <style type='text/css'>
                                h1, a, p {
                                    font-family: Corbel, Arial, sans-serif;
                                }
                            </style>
                            <p>Congratulations! Your offer " + newName + @" has been created! Here is your unique offer URL: <a href='https://www.coupons4giving.ca/Offers/" + merch.Name + "/" + newName + @"'>www.coupons4giving.ca/" + merch.Name + "/" + newName + @"</a></p>
                            <p>If you need any help, don't hesitate to contact our support team at <a href='mailto:support@coupons4giving.ca'>support@coupons4giving.ca</a>.</p>
                            <p>Cheers!</p>
                            <p>The Coupons4Giving.ca Team</p>
                            ";
                new SmtpClient().Send(mm);

                //Redirect
                Response.Redirect("DealPage.aspx?deal=" + newName + "&merchantname=" + merch.Name, false);
            }
        }
        catch (Exception ex)
        {
            newDealMessage.Text = ex.ToString();
            newDealMessage.ForeColor = Color.Red;
        }
    }
    */


    [WebMethod]
    [ScriptMethod]
    public static string CheckName(string name)
    {
        return Deals.ListNamesByMerchant(HttpContext.Current.User.Identity.Name).Contains(name).ToString();
    }

    [WebMethod]
    [ScriptMethod]
    public static string CreateOffer(string Name, string Description, string sDate, string eDate, string AbsCouponLimit, string PCLimit,
        string rValue, string gValue, string rDetails, string AdditionalRedeemDetails, string OfferImage)
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
        List<string> RedeemDetails = rDetails.Split(new string[] {";"}, StringSplitOptions.RemoveEmptyEntries).ToList<string>();

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
        decimal MerchantSplit = GiftValue * mSplit;
        decimal NPOSplit = GiftValue * nSplit;
        decimal OurSplit = GiftValue * oSplit;

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

        if (validation.ContainsSpaces(Description))
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

        if (validation.IsNumberLarger(AbsoluteCouponLimit, 0))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/CouponLimitLT0").InnerText);

        if (LimitPerCustomer != -1)
            if (!validation.IsNumberLargerOrEqual(AbsoluteCouponLimit, LimitPerCustomer))
                errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/CouponLimitLessThanCustomerLimit").InnerText);

        if (validation.IsStringBlank(PCLimit))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/NullPCCouponLimit").InnerText);

        if (validation.IsNumberLarger(LimitPerCustomer, 0))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/PCCouponLimitLT0").InnerText);

        if (AbsoluteCouponLimit != -1)
            if (!validation.IsNumberLargerOrEqual(LimitPerCustomer, AbsoluteCouponLimit))
                errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/PCCouponLimitGreaterThanAbsoluteLimit").InnerText);

        if (validation.IsStringBlank(rValue))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/NullRetailValue").InnerText);

        if (validation.IsNumberLarger(RetailValue, 1))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/RetailValueLT1").InnerText);

        if (GiftValue != -1)
            if (!validation.IsNumberLargerOrEqual(RetailValue, GiftValue))
                errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/RetailValueLessThanGiftValue").InnerText);

        if (validation.IsStringBlank(gValue))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/NullGiftValue").InnerText);

        if (validation.IsNumberLarger(GiftValue, 1))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/GiftValueLT1").InnerText);

        if (RetailValue != -1)
            if (!validation.IsNumberLargerOrEqual(GiftValue, RetailValue))
                errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/GiftValueGreaterThanRetailValue").InnerText);

        if (validation.IsStringTooLong(AdditionalRedeemDetails, 500))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/GiftValueGreaterThanRetailValue").InnerText);

        if (validation.ContainsCode(AdditionalRedeemDetails))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/GiftValueGreaterThanRetailValue").InnerText);

        //If there're no errors, commit to db
        if (errors.Count == 0)
        {
            int dealID = -1;
            int dealInstanceID = -1;

            Merchant merchant = Merchants.GetByUsername(HttpContext.Current.User.Identity.Name);

            //Save image
            //Check to see if there's a temp image, assign default if not
            DirectoryInfo root = new DirectoryInfo(HttpContext.Current.Server.MapPath("~/tmp/Images/Offers"));
            FileInfo[] listFiles = root.GetFiles(HttpContext.Current.User.Identity.Name + "logo.*");

            if (listFiles.Length > 0)
            {
                logoPath = HttpContext.Current.Server.MapPath("..\\Images\\Merchant\\" + merchant.Name + "\\Offers");
                logoPath = Utilsmk.GetOrCreateFolder(logoPath) + listFiles[0].Name;
                listFiles[0].MoveTo(logoPath);
            }
            else
                logoPath = HttpContext.Current.Server.MapPath("~/Images/c4g_home_npos_step4.png");

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
                    errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/ServerError").InnerText);

                    try
                    {
                        ts.Dispose();
                    }
                    catch (Exception ex2)
                    {
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