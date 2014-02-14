using CouponsForGiving;
using CouponsForGiving.Data;
using CouponsForGiving.Data.Classes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

public partial class Merchant_Offers_DealPage : System.Web.UI.Page
{
    public Deal deal;
    public DealInstance dealInstance;
    public Merchant merchant;
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
        if (Page.RouteData.Values["MerchantName"] == null || Page.RouteData.Values["OfferName"] == null)
            if (Request.QueryString["merchantname"] == null || Request.QueryString["deal"] == null)
                Response.Redirect("~/Default/MyHome.aspx", true);

        string merchantName = "";
        string dealName = "";

        if (Page.RouteData.Values["MerchantName"] == null || Page.RouteData.Values["OfferName"] == null)
        {
            merchantName = Request.QueryString["merchantname"];
            dealName = Request.QueryString["deal"];
        }
        else
        {
            merchantName = Page.RouteData.Values["MerchantName"].ToString();
            dealName = Page.RouteData.Values["OfferName"].ToString();
        }


        merchant = Merchants.GetByUsername(User.Identity.Name);
        dealInstance = SysData.DealInstance_GetByDealName(dealName, merchant.MerchantID);
        deal = dealInstance.Deal;

        if (deal == null)
            Response.Redirect("~/Default/MyHome.aspx" + merchantName);

        merchant = deal.Merchant;
        Title = String.Format("{1} - {0}", deal.Name, merchant.Name);

        base.OnPreInit(e);
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        Controls_MenuBar control = (Controls_MenuBar)Master.FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.Merchant;
        Master.SideBar = false;

        URL = WebServices.GetGoogleURL("https://www.coupons4giving.ca/Offers/" + merchant.Name + "/" + deal.Name);
    }
}