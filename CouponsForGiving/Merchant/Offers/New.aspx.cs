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
            newDealMessage.Text = ex.ToString();
            newDealMessage.ForeColor = Color.Red;
        }

        if (!IsPostBack)
            BindData();
    }

    private void BindData()
    {
        List<object> locations =
            (
                from m
                in merch.MerchantLocations
                select new
                {
                    LocationID = m.MerchantLocationID,
                    Address = m.cAddress,
                    LocationCity = m.City.Name,
                    Province = m.City.PoliticalDivision.Name,
                    Country = m.City.Country.Name,
                    Phone = Convert.ToInt64(m.PhoneNumber).ToString("(###) ###-####"),
                    ShortProvince = m.City.PoliticalDivision.DivisionCode,
                    ShortCountry = m.City.Country.CountryCode
                }
            ).ToList<object>();

        if (locations.Count == 0)
        {
            LocationsPanel.Visible = false;
            LocationsPanel.Enabled = false;
        }
        else
        {
            LocationsPanel.Visible = false;
            LocationsPanel.Enabled = false;

            LocationsGV.DataSource = locations;
            LocationsGV.DataBind();
        }
    }

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

    [WebMethod]
    [ScriptMethod]
    public static string CheckOfferName(string name)
    {
        return Deals.ListNamesByMerchant(HttpContext.Current.User.Identity.Name).Contains(name).ToString();
    }

    [ScriptMethod]
    [WebMethod]
    public static string AddLocation(string locationID)
    {
        string result = "OK";

        int location = int.Parse(locationID);

        List<int> locations = (List<int>)HttpContext.Current.Session["Locations"];
        locations.Add(location);
        HttpContext.Current.Session["Locations"] = locations;
        
        return result;
    }

    [ScriptMethod]
    [WebMethod]
    public static string RemoveLocation(string locationID)
    {
        string result = "OK";

        List<int> locations = (List<int>)HttpContext.Current.Session["Locations"];
        locations.Remove(int.Parse(locationID));
        HttpContext.Current.Session["Locations"] = locations;

        return result;
    }
}