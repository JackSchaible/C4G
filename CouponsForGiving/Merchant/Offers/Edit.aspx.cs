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

public partial class Merchant_Offers_Edit : System.Web.UI.Page
{
    public Merchant merch;
    public XmlDocument strings;
    public static bool locked;
    public static DealInstance di;
    public List<string> checkBoxes;

    protected void Page_Load(object sender, EventArgs e)
    {
        Controls_MenuBar control = (Controls_MenuBar)Master.FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.Merchant;

        strings = new XmlDocument();
        strings.Load(Server.MapPath(String.Format("Text ({0}).xml", WebConfigurationManager.AppSettings["Language"])));

        int id = -1;

        if (Request.QueryString["diid"] != null)
            id = int.Parse(Request.QueryString["diid"]);
        else
            Response.Redirect("MyOffers.aspx");

        try
        {
            merch = SysDatamk.Merchant_GetByUsername(User.Identity.Name);
            di = SysData.DealInstance_GetByID(id);

            List<int> dealIDs = (from d in merch.Deals select d.DealID).ToList<int>();

            if (!dealIDs.Contains(di.Deal.DealID))
                Response.Redirect("MyOffers.aspx");

            if (di.PurchaseOrders.Count > 0 || di.Campaigns.Count > 0)
                locked = true;
            else
                locked = false;

            //DirectoryInfo root = new DirectoryInfo(HttpContext.Current.Server.MapPath("~/tmp/Images/Offers"));
            //FileInfo[] listFiles = root.GetFiles(HttpContext.Current.User.Identity.Name + "logo.*");

            //if (di.Deal.ImageURL != "Images\c4g_home_npos_step4.png")
            //    if (File.Exists(Server.MapPath("../../" + di.Deal.ImageURL)))
            //        File.Move(Server.MapPath("../../" + di.Deal.ImageURL), Server.MapPath("../../tmp/Images/Offers/" + merch.Name + "/Offers/" + di.Deal.ImageURL);

            if (locked)
            {
                //StartDateRow.Enabled = false;
                //StartDateRow.Visible = false;
                //EndDateRow.Enabled = false;
                //EndDateRow.Visible = false;
                //RedeemDetailsRow.Enabled = false;
                //RedeemDetailsRow.Visible = false;

            }
            else
            {
                //StartDateRow.Enabled = true;
                //StartDateRow.Visible = true;
                ////Set start date
                //EndDateRow.Enabled = true;
                //EndDateRow.Visible = true;
                //Set end date
                //RedeemDetailsRow.Enabled = true;
                //RedeemDetailsRow.Visible = true;
                //Check the applicable redeem details

                //List<FinePrint> finePrints = FinePrints.List();
                //List<int> finePrintIDs = (from f in finePrints select f.FinePrintID).ToList<int>();
                //List<int> dealPrints = (from f in di.Deal.FinePrints select f.FinePrintID).ToList<int>();

                //checkBoxes = new List<string>();

                //for (int i = 0; i < finePrintIDs.Count; i++)
                //{
                //    //If, add a checked box, else don't
                //    if (dealPrints.Contains(finePrintIDs[i]))
                //        checkBoxes.Add("<tr><td><input checked=\"checked\" id=\"FinePrintList_" + i + "\" type=\"checkbox\" name=\"ct100$Main_Content$FinePrintList$FinePrintList_" + i + "\" value=\"" + finePrints[i].FinePrintID + "\"><label for=\"FinePrintList_" + i + "\">" + finePrints[i].Content + "</label></td></tr>");
                //    else
                //        checkBoxes.Add("<tr><td><input id=\"FinePrintList_" + i + "\" type=\"checkbox\" name=\"ct100$Main_Content$FinePrintList$FinePrintList_" + i + "\" value=\"" + finePrints[i].FinePrintID + "\"><label for=\"FinePrintList_" + i + "\">" + finePrints[i].Content + "</label></td></tr>");
                //}
            }
        }
        catch (Exception ex)
        {
            ex.ToString();
            Response.Redirect("MyOffers.aspx");
        }
    }

    [WebMethod]
    [ScriptMethod]
    public static string CheckName(string name)
    {
        List<string> deals = Deals.ListNamesByMerchant(HttpContext.Current.User.Identity.Name);
        deals.Remove(di.Deal.Name);

        return deals.Contains(name).ToString();
    }

    //[WebMethod]
    //[ScriptMethod]
    //public static string SaveOffer(int diID, string Name, string Description, string sDate, string eDate, string AbsCouponLimit, string PCLimit,
    //    string rValue, string gValue, string[] rDetails, string AdditionalRedeemDetails)
    [WebMethod]
    [ScriptMethod]
    public static string SaveOffer(int diID, string Name, string Description, string AbsCouponLimit, string PCLimit, string rValue, string gValue)
    {
        DealInstance dealInstance = SysData.DealInstance_GetByID(diID);
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

        //DateTime StartDate = DateTime.Parse(sDate);
        DateTime StartDate = dealInstance.StartDate;
        //DateTime EndDate = DateTime.Parse(eDate);
        DateTime EndDate = dealInstance.EndDate;
        int AbsoluteCouponLimit = -1;
        int LimitPerCustomer = -1;
        decimal RetailValue = -1M;
        decimal GiftValue = -1M;
        string logoPath = "";
        //List<string> RedeemDetails = rDetails.ToList<string>();
        
        //for (int i = 0; i < RedeemDetails.Count; i++)
        //    RedeemDetails[i] = RedeemDetails[i].Trim();

        try
        {
            AbsoluteCouponLimit = int.Parse(AbsCouponLimit);
        }
        catch (Exception ex)
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
        catch (Exception ex)
        {
            ex.ToString();
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/RetailValueNAN").InnerText);
        }

        try
        {
            GiftValue = decimal.Parse(gValue);
        }
        catch (Exception ex)
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

        //if (validation.IsStringTooLong(AdditionalRedeemDetails, 500))
        //    errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/GiftValueGreaterThanRetailValue").InnerText);

        //if (validation.ContainsCode(AdditionalRedeemDetails))
        //    errors.Add(strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/GiftValueGreaterThanRetailValue").InnerText);

        Merchant merchant = Merchants.GetByUsername(HttpContext.Current.User.Identity.Name);
        string username = HttpContext.Current.User.Identity.Name;

        if (dealInstance.PurchaseOrders.Count > 0 || dealInstance.Campaigns.Count > 0)
            locked = true;

        if (locked)
        {
            if (AbsoluteCouponLimit < dealInstance.Deal.AbsoluteCouponLimit)
                errors.Add(strings.SelectSingleNode("/SiteText/Pages/Edit/ErrorMessages/NewAbsLimitLowerThanOld").InnerText);

            if (LimitPerCustomer < dealInstance.Deal.LimitPerCustomer)
                errors.Add(strings.SelectSingleNode("/SiteText/Pages/Edit/ErrorMessages/NewPCCouponLimitLowerThanOld").InnerText);
        }

        //If there're no errors, commit to db
        if (errors.Count == 0)
        {
            //Save image
            //Check to see if there's a temp image, assign default if not
            //DirectoryInfo root = new DirectoryInfo(HttpContext.Current.Server.MapPath("~/tmp/Images/Offers"));
            //FileInfo[] listFiles = root.GetFiles(HttpContext.Current.User.Identity.Name + "DealImage.*");

            //if (listFiles.Length > 0)
            //{
            //    logoPath = HttpContext.Current.Server.MapPath("..\\Images\\Merchant\\" + merchant.Name + "\\Offers");
            //    logoPath = Utilsmk.GetOrCreateFolder(logoPath) + listFiles[0].Name;
            //    listFiles[0].MoveTo(logoPath);
            //    logoPath = logoPath.Replace(HttpContext.Current.Request.ServerVariables["APPL_PHYSICAL_PATH"], String.Empty);
            //}
            //else
            //    logoPath = "Images/c4g_home_npos_step4.png";

            using (TransactionScope ts = new TransactionScope())
            {
                try
                {
                    //If deal is locked, then only update the coupon limit, and only if those are increases
                    if (!locked)
                        Deals.Update(dealInstance.DealID, merchant.MerchantID, Name, Description, AbsoluteCouponLimit, LimitPerCustomer, dealInstance.Deal.ImageURL);
                    else
                        Deals.Update(dealInstance.DealID, merchant.MerchantID, di.Deal.Name, di.Deal.DealDescription, AbsoluteCouponLimit, LimitPerCustomer, dealInstance.Deal.ImageURL);

                    //Add extra deal stuff
                    
                    //Add pricing
                    if (!locked)
                        SysDatamk.UpdatePrice(di.Deal.Prices.FirstOrDefault<Price>().PriceID, di.Deal.DealID, RetailValue, GiftValue, MerchantSplit, NPOSplit, OurSplit);

                    //Don't touch deal locations
                    //if (merchant.MerchantLocations.Count > 0)
                      //  SysDatamk.AddDealMerchantLocation(dealID, merchant.MerchantLocations.FirstOrDefault<MerchantLocation>().MerchantLocationID);

                    if (!locked)
                    {
                        //foreach (FinePrint fp in di.Deal.FinePrints)
                        //    FinePrints.Remove(di.Deal.DealID, fp.FinePrintID);

                        ////Add redeem details
                        //foreach (string item in RedeemDetails)
                        //    FinePrints.Add(di.Deal.DealID, int.Parse(item));

                        //SysDatamk.UpdateRedeemDetails(di.Deal.RedeemDetails.FirstOrDefault<RedeemDetail>().RedeemDetailsID, di.DealID, AdditionalRedeemDetails, "", "", "");
                    }

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

            result = "DealPage.aspx?deal=" + HttpContext.Current.Server.UrlEncode(Name) + "&merchantname=" + HttpContext.Current.Server.UrlEncode(merchant.Name);
        }

        if (errors.Count > 0)
            throw new Exception(validation.WriteClientErrorsList(errors));

        return result;
    }

}