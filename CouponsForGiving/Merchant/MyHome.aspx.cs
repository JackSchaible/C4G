using CouponsForGiving;
using CouponsForGiving.Data;
using CouponsForGiving.Data.Classes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

public partial class Merchant_Home : System.Web.UI.Page
{
    public Merchant merchant;
    public List<DealInstance> deals;
    public string Caption
    {
        get
        {
            return WebConfigurationManager.AppSettings["ProfilePostTitle"];
        }
    }
    public string URL { get; set; }

    protected override void OnInit(EventArgs e)
    {
        if (!User.IsInRole("Merchant"))
            Response.Redirect("Anon.aspx", true);

        base.OnInit(e);
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        Controls_MenuBar control = (Controls_MenuBar)FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.Merchant;

        if (Page.User.Identity.IsAuthenticated)
        {
            HtmlAnchor button = (HtmlAnchor)LoginView1.FindControl("manageButton");
            HtmlAnchor profileButton = (HtmlAnchor)LoginView1.FindControl("ProfileButton");
            string path = "";

            if (Page.User.IsInRole("NPO"))
                path = Server.MapPath("~/NPO/MyHome.aspx").Replace(Request.ServerVariables["APPL_PHYSICAL_PATH"], String.Empty).Replace("~", String.Empty);
            else if (Page.User.IsInRole("Merchant"))
                path = Server.MapPath("~/Merchant/MyHome.aspx").Replace(Request.ServerVariables["APPL_PHYSICAL_PATH"], String.Empty).Replace("~", String.Empty);
            else if (Page.User.IsInRole("User"))
                path = Server.MapPath("~/Default/MyHome.aspx").Replace(Request.ServerVariables["APPL_PHYSICAL_PATH"], String.Empty).Replace("~", String.Empty);

            profileButton.HRef = path;
        }

        merchant = SysDatamk.Merchant_GetByUsername(User.Identity.Name);

        URL = WebServices.GetGoogleURL("https://www.coupons4giving.ca/Causes/" + merchant.Name);

        if (!IsPostBack)
            BindData();
    }

    private void BindData()
    {
        DataBind();
    }

    [WebMethod]
    [ScriptMethod]
    public static void Save(string name, string description, string address, string city,
        string province, string country, string postalcode, string website, string phoneNumber, string email, string statusid,
        string logo, string autoAcceptMerchantRequests)
    {
        name = HttpUtility.UrlDecode(name).Trim();
        description = HttpUtility.UrlDecode(description).Trim();
        address = HttpUtility.UrlDecode(address).Trim();
        city = HttpUtility.UrlDecode(city).Trim();
        province = HttpUtility.UrlDecode(province).Trim();
        country = HttpUtility.UrlDecode(country).Trim();
        postalcode = HttpUtility.UrlDecode(postalcode).Trim();
        website = HttpUtility.UrlDecode(website).Trim();
        phoneNumber = HttpUtility.UrlDecode(phoneNumber).Trim();
        email = HttpUtility.UrlDecode(email).Trim();
        int statusID = int.Parse(HttpUtility.UrlDecode(statusid).Trim());
        logo = HttpUtility.UrlDecode(logo).Trim();
        string url = name;
        int cityID = -1;
        bool AutoAcceptMerchantRequests = bool.Parse(autoAcceptMerchantRequests);

        if (name == null)
            throw new ArgumentNullException("name", "An NPO name is required.");

        if (description == null)
            throw new ArgumentNullException("description", "A description for your NPO is required.");

        if (description == null)
            throw new ArgumentNullException("address", "An adddress for your NPO is required.");

        if (description == null)
            throw new ArgumentNullException("city", "A city for your NPO is required.");

        if (description == null)
            throw new ArgumentNullException("province", "A province for your NPO is required.");

        if (description == null)
            throw new ArgumentNullException("country", "A country for your NPO is required.");

        if (description == null)
            throw new ArgumentNullException("postalcode", "A postal code for your NPO is required.");

        if (description == null)
            throw new ArgumentNullException("phoneNumber", "A phone number for your NPO is required.");

        if (description == null)
            throw new ArgumentNullException("email", "An email for your NPO is required.");

        try
        {
            cityID = Cities.GetByNameWithProvinceAndCountry(city, province, country).CityID;
        }
        catch (Exception ex)
        {
            ex.ToString();
        }

        if (cityID == -1)
            throw new Exception("Your city could not be found. Please ensure that the city, province, and country were spelt correctly and try again.");

        if (description.Length < 5)
            throw new Exception("The description for your NPO must be at least 5 characters long.");

        Merchant merchObject = SysDatamk.Merchant_GetByUsername(HttpContext.Current.User.Identity.Name);
        SysDatamk.UpdateMerchant(merchObject.MerchantID, name, logo, logo, address, cityID,
            postalcode, phoneNumber, website, statusID);

        MerchantSettings.Update(merchObject.MerchantID, AutoAcceptMerchantRequests);
    }
}