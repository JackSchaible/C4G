using CouponsForGiving;
using CouponsForGiving.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Default_MerchantPage : System.Web.UI.Page
{
    public Merchant merchant;

    protected override void OnPreInit(EventArgs e)
    {
        if (Page.RouteData.Values["MerchantName"] == null)
            if (Request.QueryString["MerchantName"] == null)
                Response.Redirect("Home.aspx");

        if (Page.RouteData.Values["MerchantName"] == null)
            merchant = SysData.Merchant_GetByName(Request.QueryString["MerchantName"]);
        else
            merchant = SysData.Merchant_GetByName(Page.RouteData.Values["MerchantName"].ToString());

        if (merchant == null)
            Response.Redirect("Home.aspx");

        Title = merchant.Name + " - Coupons4Giving";

        base.OnPreInit(e);
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        Controls_MenuBar control = (Controls_MenuBar)Master.FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.Supporter;

        if (merchant.Deals.Count == 0)
        {
            Campaigns.Enabled = false;
            Campaigns.Visible = false;
        }
    }
}