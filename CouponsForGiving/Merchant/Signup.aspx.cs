using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using CouponsForGiving;
using CouponsForGiving.Data;
using System.Transactions;
using System.Text;
using System.Net.Mail;
using System.IO;
using CouponsForGiving.Data.Classes;
using System.Xml;
using System.Web.Configuration;
using System.Web.Services;
using System.Web.Script.Services;
using System.Collections.Specialized;

public partial class Merchant_Signup : System.Web.UI.Page
{
    public bool hasLargeLogo { get; set; }
    public bool hasSmallLogo { get; set; }
    public static XmlDocument strings;
    public static List<City> CitiesList;
    public static List<string> BusinessNames;

    protected void Page_Load(object sender, EventArgs e)
    {
        Controls_MenuBar control = (Controls_MenuBar)Master.FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.Anonymous;
        strings = new XmlDocument();

        try
        {
            CitiesList = Cities.ListAll();
            BusinessNames = Merchants.ListNames();
            string lang = WebConfigurationManager.AppSettings["Language"];
            strings.Load(Server.MapPath(String.Format("Text ({0}).xml", lang)));

            try
            {
                NotificationcUsers.Insert(String.Format("ProfileNotComplete({0})", lang), User.Identity.Name);
            }
            catch (Exception ex)
            {
                if (ex.InnerException == null)
                    throw ex;
                else
                    if (ex.InnerException.Message != "Violation of PRIMARY KEY constraint 'PK_NotificationcUser'. Cannot insert duplicate key in object 'Database_User.NotificationcUser'. The duplicate key value is (ProfileNotComplete(EN-US), 4174).\r\nThe statement has been terminated.")
                        throw ex;
                        
            }
        }
        catch (Exception ex)
        {
            newMerchantMessage.Text = ex.ToString();
        }
    }

    [WebMethod]
    [ScriptMethod]
    public static string GetCities(string text)
    {
        string result;

        result = String.Join(";", (from c in CitiesList where c.Name.ToLower().Contains(text.ToLower()) orderby c.Name select c.Name + ", " + c.PoliticalDivision.Name + ", " + c.Country.Name));

        return result;
    }

    [WebMethod]
    [ScriptMethod]
    public static string IsNameTaken(string BusinessName)
    {
        string result = "false";

        BusinessNames = Merchants.ListNames();

        foreach (string item in BusinessNames)
            if (item.ToLower() == BusinessName.ToLower())
                result = "true";

        return result;
    }

    [WebMethod]
    [ScriptMethod]
    public static string ConnectToStripe(string FirstName, string LastName, string PhoneNumber, string BusinessName, string Description,
        string Address, string City, string Postal, string ContactPhoneNumber, string ContactEmail, string Website, string GlobalMerchant,
        string AutoAcceptRequests, string BusinessType, string BirthDate, string PhysicalProduct, string ProductType, string Currency)
    {
        string result = "";
        strings = new XmlDocument();
        strings.Load(HttpContext.Current.Server.MapPath(String.Format("Text ({0}).xml", WebConfigurationManager.AppSettings["Language"])));
        List<string> errors = new List<string>();
        Validation validation = null;
        int CityID = -1;
        DateTime birthDate = DateTime.Parse(BirthDate);

        //Convert to useful variables
        bool globalMerchant = GlobalMerchant.ToLower() == "true" ? true : false;
        bool autoAcceptRequests = AutoAcceptRequests.ToLower() == "true" ? true : false;
        string[] location = null;
        string[] seperator = {","};

        try
        {
            location = City.Replace("<p>", "").Replace("</p>", "").Split(seperator, StringSplitOptions.RemoveEmptyEntries);
        }
        catch (Exception ex)
        {
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/CityError").InnerText);
        }

        string city = location[0].Trim();
        string province = location[1].Trim();
        string country = location[2].Trim();
        bool physicalProduct = PhysicalProduct.ToLower() == "true" ? true : false;
        string lang = WebConfigurationManager.AppSettings["Language"];

        switch (lang)
        {
            case "EN-US":
                validation = new Validation_EN_US();
                break;
        }

        //Validation functions
        if (validation.IsStringBlank(FirstName))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/NullFirstName").InnerText);

        if (validation.IsStringTooLong(FirstName, 64))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/FirstNameTooLong").InnerText);

        if (validation.ContainsCode(FirstName))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/FirstNameInvalidCharacters").InnerText);

        if (validation.IsStringBlank(LastName))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/NullLastName").InnerText);

        if (validation.IsStringTooLong(LastName, 64))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/LastNameTooLong").InnerText);

        if (validation.ContainsCode(LastName))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/LastNameInvalidCharacters").InnerText);

        if (validation.IsStringBlank(PhoneNumber))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/NullPhoneNumber").InnerText);

        if (!validation.ValidPhoneNumber(PhoneNumber))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/InvalidPhoneNumber").InnerText);

        if (validation.IsStringTooLong(PhoneNumber, 20))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/PhoneNumberTooLong").InnerText);

        if (validation.ContainsCode(PhoneNumber))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/PhoneNumberInvalidCharacters").InnerText);

        if (validation.IsStringBlank(BusinessName))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/NullBusinessName").InnerText);

        if (validation.IsStringTooLong(BusinessName, 64))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/BusinessNameTooLong").InnerText);

        if (validation.ContainsCode(BusinessName))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/BusinessNameInvalidCharacters").InnerText);

        if (bool.Parse(IsNameTaken(BusinessName)))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/BusinessNameTaken").InnerText);

        if (validation.IsStringBlank(Description))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/NullDescription").InnerText);

        if (validation.IsStringTooLong(Description, 160))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/DescriptionTooLong").InnerText);

        if (validation.IsStringTooShort(Description, 10))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/DescriptionTooShort").InnerText);

        if (validation.ContainsCode(Description))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/DescriptionInvalidCharacters").InnerText);

        if (!validation.ContainsSpaces(Description))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/DescriptionOneWord").InnerText);

        if (validation.IsStringBlank(Address))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/NullAddress").InnerText);

        if (validation.IsStringBlank(City))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/NullCity").InnerText);
        else
        {
            try
            {
                CityID = Cities.GetByNameWithProvinceAndCountry(city, province, country).CityID;
            }
            catch (Exception ex)
            {
                errors.Add(strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/CityError").InnerText);
            }
        }

        if (validation.IsStringBlank(Postal))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/NullPostal").InnerText);

        if (validation.IsStringTooShort(Postal, 5))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/PostalTooShort").InnerText);

        if (!validation.IsStringBlank(ContactPhoneNumber))
        {
            if (validation.IsStringBlank(ContactPhoneNumber))
                errors.Add(strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/NullPhoneNumber").InnerText);

            if (!validation.ValidPhoneNumber(ContactPhoneNumber))
                errors.Add(strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/InvalidPhoneNumber").InnerText);

            if (validation.IsStringTooLong(ContactPhoneNumber, 20))
                errors.Add(strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/PhoneNumberTooLong").InnerText);

            if (validation.ContainsCode(ContactPhoneNumber))
                errors.Add(strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/PhoneNumberInvalidCharacters").InnerText);
        }
        else
            ContactPhoneNumber = PhoneNumber;

        if (!validation.IsStringBlank(ContactEmail))
        {
            if (validation.IsStringBlank(ContactEmail))
                errors.Add(strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/NullEmail").InnerText);

            if (validation.IsStringTooShort(ContactEmail, 6))
                errors.Add(strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/EmailTooShort").InnerText);

            if (validation.IsStringTooLong(ContactEmail, 64))
                errors.Add(strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/EmailTooLong").InnerText);

            if (validation.ContainsCode(ContactEmail))
                errors.Add(strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/EmailInvalidCharacters").InnerText);
        }
        else
            ContactEmail = Membership.GetUser().Email;

        //Ensure website starts with 'http://'
        Website = (Website.StartsWith("http") ? Website : "http://" + Website);

        if (validation.IsStringBlank(Website))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/NullWebsite").InnerText);

        if (validation.IsStringTooShort(Website, 8))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/WebsiteTooShort").InnerText);

        if (errors.Count == 0)
        {
            try
            {
                int defaultStatusID = 2;
                int merchantID = -1;
                string username = HttpContext.Current.User.Identity.Name;
                string logoPath = "";

                //Check to see if there's a temp image, assign default if not
                DirectoryInfo root = new DirectoryInfo(HttpContext.Current.Server.MapPath("~/tmp/Images/Signup"));
                FileInfo[] listFiles = root.GetFiles(HttpContext.Current.User.Identity.Name + "logo.*");

                if (listFiles.Length > 0)
                {
                    logoPath = HttpContext.Current.Server.MapPath("..\\Images\\Merchant\\" + BusinessName);
                    logoPath = Utilsmk.GetOrCreateFolder(logoPath) + listFiles[0].Name;
                    listFiles[0].MoveTo(logoPath);
                    NotificationcUsers.Delete(String.Format("NoProfileImage({0})", WebConfigurationManager.AppSettings["Language"]), username);
                }
                else
                {
                    logoPath = HttpContext.Current.Server.MapPath("~/Images/c4g_home_npos_step4.png");

                    try
                    {
                        NotificationcUsers.Insert(String.Format("NoProfileImage({0})", WebConfigurationManager.AppSettings["Language"]), username);
                    }
                    catch (Exception ex)
                    {
                        ex.ToString();
                    }
                }

                using (TransactionScope ts = new TransactionScope())
                {
                    try
                    {
                        merchantID = SysDatamk.AddMerchant(BusinessName, logoPath, logoPath, Address,
                            CityID, Postal, PhoneNumber, Website, defaultStatusID, username, ContactEmail);

                        if (merchantID > -1)
                        {
                            if (!globalMerchant)
                                SysDatamk.AddMerchantLocation(merchantID, Address, CityID, PhoneNumber);

                            SysData.MerchantInfo_Insert(username, FirstName + LastName, ContactPhoneNumber, Description);
                            MerchantSettings.Insert(merchantID, autoAcceptRequests);

                            string vars = String.Format("stripe_user[email]={0}&stripe_user[url]={1}&stripe_user[phone_number]={2}&stripe_user[business_name]={3}&stripe_user[business_type]={4}&stripe_user[first_name]={5}&stripe_user[last_name]={6}&stripe_user[dob_day]={7}&stripe_user[dob_month]={8}&stripe_user[dob_year]={9}&stripe_user[street_address]={10}&stripe_user[city]={11}&stripe_user[state]={12}&stripe_user[zip]={13}&stripe_user[physical_product]={14}&stripe_user[product_category]={15}&stripe_user[country]={16}&stripe_user[currency]={17}", 
                                HttpContext.Current.Server.UrlEncode(ContactEmail), HttpContext.Current.Server.UrlEncode(Website), HttpContext.Current.Server.UrlEncode(PhoneNumber), 
                                HttpContext.Current.Server.UrlEncode(BusinessName), HttpContext.Current.Server.UrlEncode(BusinessType), HttpContext.Current.Server.UrlEncode(FirstName),
                                HttpContext.Current.Server.UrlEncode(LastName), HttpContext.Current.Server.UrlEncode(birthDate.ToString("dd")),
                                HttpContext.Current.Server.UrlEncode(birthDate.ToString("MM")), HttpContext.Current.Server.UrlEncode(birthDate.ToString("yyyy")), 
                                HttpContext.Current.Server.UrlEncode(Address), HttpContext.Current.Server.UrlEncode(city), HttpContext.Current.Server.UrlEncode(province), 
                                HttpContext.Current.Server.UrlEncode(Postal), HttpContext.Current.Server.UrlEncode(physicalProduct.ToString()), HttpContext.Current.Server.UrlEncode(ProductType), 
                                HttpContext.Current.Server.UrlEncode(country), HttpContext.Current.Server.UrlEncode(Currency));

                            result = String.Format("https://connect.stripe.com/oauth/authorize?response_type=code&client_id=ca_2dcruIQ1MEWM9BfJot2jJUPvKqJGofMU&scope=read_write&{0}", vars);

                            NotificationcUsers.Delete(String.Format("ProfileNotComplete({0})", lang), HttpContext.Current.User.Identity.Name);
                            NotificationcUsers.Insert(String.Format("StripeNotConnected({0})", lang), HttpContext.Current.User.Identity.Name);
                            ts.Complete();
                        }
                        else
                        {
                            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/ServerError").InnerText);
                            ts.Dispose();
                        }
                    }
                    catch (Exception ex)
                    {
                        errors.Add(strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/ServerError").InnerText);
                        ts.Dispose();
                        ex.ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                errors.Add(strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/ServerError").InnerText);
                ex.ToString();
            }
        }

        if (errors.Count > 0)
            throw new Exception(validation.WriteClientErrorsList(errors));

        return result;
    }
}