using CouponsForGiving;
using CouponsForGiving.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

public partial class Default_DealPage : System.Web.UI.Page
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

    protected override void OnPreInit(EventArgs e)
    {
        if (Page.RouteData.Values["MerchantName"] == null || Page.RouteData.Values["OfferName"] == null)
            if (Request.QueryString["merchantname"] == null || Request.QueryString["deal"] == null)
                Response.Redirect("~/Default/MyHome.aspx", true);
            else
            {
                string merchantName = "";
                string dealName = "";

                if (Page.RouteData.Values["MerchantName"] == null || Page.RouteData.Values["OfferName"] == null)
                {
                    merchantName = Request.QueryString["merchantname"];
                    dealName = Request.QueryString["deal"];
                }
                else
                {
                    merchantName = Page.RouteData.Values["merchantname"].ToString();
                    dealName = Page.RouteData.Values["dealname"].ToString();
                }

                merchant = SysData.Merchant_GetByName(merchantName);
                dealInstance = SysData.DealInstance_GetByDealName(dealName, merchant.MerchantID);
                deal = dealInstance.Deal;

                if (deal == null)
                    Response.Redirect("~/Default/MyHome.aspx" + merchantName);

                merchant = deal.Merchant;
                Title = String.Format("{1} - {0}", deal.Name, merchant.Name);
            }

        base.OnPreInit(e);
    }

    protected void Page_Load(object sender, EventArgs e)
    {
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

        Controls_MenuBar control = (Controls_MenuBar)FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.Supporter;

        URL = WebServices.GetGoogleURL("https://www.coupons4giving.ca/Offers/" + merchant.Name + "/" + deal.Name);
    }
}