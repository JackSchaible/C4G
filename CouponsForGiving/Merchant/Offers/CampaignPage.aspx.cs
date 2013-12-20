using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CouponsForGiving;
using CouponsForGiving.Data;
using System.IO;
using System.Web.UI.HtmlControls;
using System.Web.Configuration;

public partial class Default_NpoPage : System.Web.UI.Page
{
    public NPO npo;
    public Campaign campaign;
    public List<DealInstance> deals;
    //public System.Drawing.Image Image;
    public string Caption
    {
        get
        {
            return WebConfigurationManager.AppSettings["CampaignPostTitle"];
        }
    }
    public string URL { get; set; }

    protected override void OnPreInit(EventArgs e)
    {
        base.OnPreInit(e);

        if (Page.RouteData.Values["nponame"] == null || Page.RouteData.Values["campaignname"] == null)
        {
            if (Request.QueryString["nponame"] == null || Request.QueryString["campaign"] == null)
                Response.Redirect("~/Default/MyHome.aspx", true);
            else
            {
                string npoName = "";
                string campaignName = "";

                npoName = Request.QueryString["nponame"];
                campaignName = Request.QueryString["campaign"];

                campaign = SysData.Campaign_GetByName(campaignName, npoName);

                if (campaign == null)
                    Response.Redirect("../Causes/" + npoName);

                npo = campaign.NPO;
                Title = String.Format("{1} - {0}", campaign.Name, npo.Name);
            }
        }
        else
        {
            string npoName = "";
            string campaignName = "";

            npoName = Page.RouteData.Values["nponame"].ToString();
            campaignName = Page.RouteData.Values["campaignname"].ToString();

            campaign = SysData.Campaign_GetByName(campaignName, npoName);

            if (campaign == null)
                Response.Redirect("../Causes/" + npoName);

            npo = campaign.NPO;
            Title = String.Format("{1} - {0}", campaign.Name, npo.Name);
        }

        deals = (
            from
                d
            in
                campaign.DealInstances
            where
                d.EndDate > DateTime.Now && d.DealStatusID == 2 && d.Deal.Merchant.cUser.Username == User.Identity.Name
            select
                d
                ).ToList<DealInstance>();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        Controls_MenuBar control = (Controls_MenuBar)Master.FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.Supporter;
        Master.SideBar = false;

        //PG.Style["height"] = (((from po in campaign.PurchaseOrders select po.NPOSplit).Sum() / campaign.FundraisingGoal ?? 0) * 233).ToString() + "px";

        URL = WebServices.GetGoogleURL("https://www.coupons4giving.ca/Causes/" + npo.Name + "/" + campaign.Name);

        if (!IsPostBack)
            BindData();
    }

    private void BindData()
    {
        //DealsGV.DataSource = (
        //    from
        //        d 
        //    in
        //        campaign.DealInstances
        //    where
        //        d.EndDate > DateTime.Now && d.DealStatusID == 2
        //    select
        //        new
        //        { 
        //            MerchantID = d.Deal.MerchantID,
        //            DealInstanceID = d.DealInstanceID,
        //            CampaignID = campaign.CampaignID,
        //            MerchantName = d.Deal.Merchant.Name, 
        //            SmallLogo = d.Deal.Merchant.SmallLogo,
        //            DealName = d.Deal.Name,
        //            DealImage = d.Deal.ImageURL,
        //            Savings = (d.Deal.Prices.FirstOrDefault<Price>().RetailValue - d.Deal.Prices.FirstOrDefault<Price>().GiftValue),
        //            Price = d.Deal.Prices.FirstOrDefault<Price>().GiftValue
        //        }
        //    );
    }

    //protected void AddToCart(int dealInstanceID, int campaignID)
    //{
    //    Deals_ListforSearchGrid_Result order = new Deals_ListforSearchGrid_Result();
    //    DealInstance deal = (from d in campaign.DealInstances where d.DealInstanceID == dealInstanceID select d).FirstOrDefault<DealInstance>();
    //    Merchant merchant = deal.Deal.Merchant;
    
    //    order.CampaignID = campaign.CampaignID;
    //    order.CampaignName = campaign.Name;
    //    order.DealInstanceID = deal.DealInstanceID;
    //    order.DealName = deal.Deal.Name;
    //    order.GiftValue = deal.Deal.Prices.FirstOrDefault<Price>().GiftValue;
    //    order.Logo = campaign.CampaignImage;
    //    order.MerchantName = merchant.Name;
    //    order.NPOName = npo.Name;
    //    order.NPOSplit = deal.Deal.Prices.FirstOrDefault<Price>().NPOSplit;
    //    order.RetailValue = deal.Deal.Prices.FirstOrDefault<Price>().RetailValue;
    //    order.MerchantSplit = deal.Deal.Prices.FirstOrDefault<Price>().MerchantSplit;
    //    order.OurSplit = deal.Deal.Prices.FirstOrDefault<Price>().OurSplit;

    //    if (Session["Cart"] == null)
    //    {
    //        List<Deals_ListforSearchGrid_Result> orders = new List<Deals_ListforSearchGrid_Result>() { order };
    //        Session["Cart"] = orders;
    //        ErrorLabel.Text = "Your coupons has been added to your cart.";
    //    }
    //    else
    //    {
    //        List<Deals_ListforSearchGrid_Result> orders = (List<Deals_ListforSearchGrid_Result>)Session["Cart"];
    //        bool found = false;
    //        int curQTY = 0;

    //        foreach (Deals_ListforSearchGrid_Result item in orders)
    //        {
    //            if (item.CampaignID == order.CampaignID && item.DealInstanceID == order.DealInstanceID)
    //            {
    //                found = true;
    //                curQTY++;
    //            }
    //        }

    //        if (found)
    //            if (1 + curQTY > deal.Deal.LimitPerCustomer)
    //                ErrorLabel.Text = String.Format("You have exceeded the limit of coupons per customer ({0}).", deal.Deal.LimitPerCustomer);
    //            else
    //            {
    //                orders.Add(order);
    //                ErrorLabel.Text = "Your coupon has been added to your cart!";
    //            }
    //        else
    //        {
    //            orders.Add(order);
    //            ErrorLabel.Text = "Your coupon has been added to your cart!";
    //        }

    //        Session["Cart"] = orders;
    //    }
    //}

    //protected void DealsGV_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    //{
    //    string dealInstanceID = DealsGV.DataKeys[e.NewSelectedIndex].Values[1].ToString();
    //    string campaignID = DealsGV.DataKeys[e.NewSelectedIndex].Values[0].ToString();

    //    AddToCart(int.Parse(dealInstanceID), int.Parse(campaignID));
    //}
}