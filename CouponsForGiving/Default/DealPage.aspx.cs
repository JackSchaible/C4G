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

        merchant = SysData.Merchant_GetByName(merchantName);
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
        control.MenuBar = MenuBarType.Supporter;

        URL = WebServices.GetGoogleURL("https://www.coupons4giving.ca/Offers/" + merchant.Name + "/" + deal.Name);
        Master.SideBar = false;
    }

    [WebMethod]
    [ScriptMethod]
    public static void AddToCart(int dealInstanceID)
    {
        DealInstance deal = SysData.DealInstance_GetByID(dealInstanceID); ;
        Merchant merchant = deal.Deal.Merchant;
        ShoppingCart order = new ShoppingCart("", -1, "", dealInstanceID,
            deal.Deal.Name, deal.Deal.MerchantID, deal.Deal.Merchant.Name, deal.Deal.Prices.FirstOrDefault<Price>().GiftValue,
            deal.Deal.Prices.FirstOrDefault<Price>().RetailValue);

        if (HttpContext.Current.Session["Cart"] == null)
        {
            List<ShoppingCart> orders = new List<ShoppingCart>() { order };
            HttpContext.Current.Session["Cart"] = orders;
        }
        else
        {
            List<ShoppingCart> orders = (List<ShoppingCart>)HttpContext.Current.Session["Cart"];
            bool found = false;
            int curQTY = 0;

            foreach (ShoppingCart item in orders)
            {
                if (item.CampaignID == order.CampaignID && item.DealInstanceID == order.DealInstanceID)
                {
                    found = true;
                    curQTY++;
                }
            }

            if (found)
                if (1 + curQTY > deal.Deal.LimitPerCustomer)
                    throw new Exception(String.Format("You have exceeded the limit of coupons per customer ({0}).", deal.Deal.LimitPerCustomer));
                else
                {
                    orders.Add(order);
                }
            else
                orders.Add(order);

            HttpContext.Current.Session["Cart"] = orders;
        }
    }

    [WebMethod]
    [ScriptMethod]
    public static void AddToCart(int dealInstanceID, int campaignID)
    {
        Campaign campaign = SysData.Campaign_Get(campaignID);
        NPO npo = campaign.NPO;
        DealInstance deal = (from d in campaign.DealInstances where d.DealInstanceID == dealInstanceID select d).FirstOrDefault<DealInstance>();
        Merchant merchant = deal.Deal.Merchant;
        ShoppingCart order = new ShoppingCart(npo.Name, campaign.CampaignID, campaign.Name, dealInstanceID, 
            deal.Deal.Name, deal.Deal.MerchantID, deal.Deal.Merchant.Name, deal.Deal.Prices.FirstOrDefault<Price>().GiftValue, 
            deal.Deal.Prices.FirstOrDefault<Price>().RetailValue);

        if (HttpContext.Current.Session["Cart"] == null)
        {
            List<ShoppingCart> orders = new List<ShoppingCart>() { order };
            HttpContext.Current.Session["Cart"] = orders;
        }
        else
        {
            List<ShoppingCart> orders = (List<ShoppingCart>)HttpContext.Current.Session["Cart"];
            bool found = false;
            int curQTY = 0;

            foreach (ShoppingCart item in orders)
            {
                if (item.CampaignID == order.CampaignID && item.DealInstanceID == order.DealInstanceID)
                {
                    found = true;
                    curQTY++;
                }
            }

            if (found)
                if (1 + curQTY > deal.Deal.LimitPerCustomer)
                    throw new Exception(String.Format("You have exceeded the limit of coupons per customer ({0}).", deal.Deal.LimitPerCustomer));
                else
                {
                    orders.Add(order);
                }
            else
                orders.Add(order);

            HttpContext.Current.Session["Cart"] = orders;
        }
    }
}