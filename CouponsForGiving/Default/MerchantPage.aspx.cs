using CouponsForGiving;
using CouponsForGiving.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Default_MerchantPage : System.Web.UI.Page
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

    protected override void OnPreInit(EventArgs e)
    {
        if (Page.RouteData.Values["MerchantName"] == null)
            if (Request.QueryString["MerchantName"] == null)
                Response.Redirect("MyHome.aspx");

        if (Page.RouteData.Values["MerchantName"] == null)
            merchant = SysData.Merchant_GetByName(Request.QueryString["MerchantName"]);
        else
            merchant = SysData.Merchant_GetByName(Page.RouteData.Values["MerchantName"].ToString());

        if (merchant == null)
            Response.Redirect("MyHome.aspx");

        Title = merchant.Name + " - Coupons4Giving";

        URL = WebServices.GetGoogleURL("https://www.coupons4giving.ca/Offers/" + merchant.Name);

        base.OnPreInit(e);
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        Controls_MenuBar control = (Controls_MenuBar)Master.FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.Supporter;
        Master.SideBar = false;
        BindData();
    }

    private void BindData()
    {
        deals = SysData.DealInstance_ListByMerchant(merchant.MerchantID);
    }
}