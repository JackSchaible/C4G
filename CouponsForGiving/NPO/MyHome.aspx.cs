using AjaxControlToolkit;
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
using System.Web.UI.WebControls;

public partial class Merchant_Home : System.Web.UI.Page
{
    public NPO npo;
    public Campaign featured;

    protected override void OnPreInit(EventArgs e)
    {
        if (!User.IsInRole("NPO"))
            Response.Redirect("Anon.aspx");

        base.OnPreInit(e);
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        Controls_MenuBar control = (Controls_MenuBar)Master.FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.NPO;

        npo = NPOs.NPO_GetByUser(User.Identity.Name);

        if (npo.Campaigns.Count == 0)
        {
            Campaigns.Enabled = false;
            Campaigns.Visible = false;
        }
        else
        {
            featured = (from ca in npo.Campaigns where ca.ShowOnHome == true && ca.StartDate < DateTime.Now && ca.EndDate > DateTime.Now select ca).FirstOrDefault<CouponsForGiving.Data.Campaign>();

            if (featured == null)
            {
                FeaturedCampaign.Visible = false;
                FeaturedCampaign.Enabled = false;
            }
        }

        if (!IsPostBack)
            BindData();
    }

    private void BindData()
    {
        Logo.ImageUrl = "../" + npo.Logo;
    }

    [WebMethod]
    [ScriptMethod]
    public static void Save(string npoid, string name, string description, string address, string cityID, 
        string postalcode, string website, string phoneNumber, string email, string statusid,
        string logo, string url)
    {
        npoid = HttpUtility.UrlDecode(npoid);
        name = HttpUtility.UrlDecode(name);
        description = HttpUtility.UrlDecode(description);
        address = HttpUtility.UrlDecode(address);
        cityID = HttpUtility.UrlDecode(cityID);
        postalcode = HttpUtility.UrlDecode(postalcode);
        website = HttpUtility.UrlDecode(website);
        phoneNumber = HttpUtility.UrlDecode(phoneNumber);
        email = HttpUtility.UrlDecode(email);
        statusid = HttpUtility.UrlDecode(statusid);
        logo = HttpUtility.UrlDecode(logo);
        url = HttpUtility.UrlDecode(url);

        SysDatamk.UpdateNPO(int.Parse(npoid), name, description, address, int.Parse(cityID), postalcode, website,
            phoneNumber, email, int.Parse(statusid), logo, url, false);
    }

    protected void fileUploadComplete(object sender, AsyncFileUploadEventArgs e)
    {
        string newLogo = Utilsmk.SaveNewLogo(ImageUpload.PostedFile, npo.NPOID, Server, "NPO");
        string virtualPath = newLogo.Replace(Request.ServerVariables["APPL_PHYSICAL_PATH"], String.Empty);
        SysDatamk.UpdateNPO(npo.NPOID, npo.Name, npo.NPODescription, npo.cAddress, npo.CityID, npo.PostalCode, npo.Website, npo.PhoneNumber, npo.Email, npo.StatusID, virtualPath, npo.URL, npo.UseAllMerchants);

        Response.Redirect(Request.Url.ToString(), true);
    }

    protected void EditImageButton_Click(object sender, ImageClickEventArgs e)
    {
        EditImageButton.ImageUrl = "~/Images/save.jpg";
        Logo.Visible = false;
        ImageUpload.Visible = true;
    }

    protected void FBConnect_Click(object sender, EventArgs e)
    {
        Response.Redirect(String.Format("https://www.facebook.com/dialog/oauth?clientid={0}&redirecturi={1}&response_type=token&scope=",
            WebConfigurationManager.AppSettings["FB_App_ID"],
            Request.Url.AbsoluteUri));
    }
}