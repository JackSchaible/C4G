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
using System.Net;
using CouponsForGiving.Data.Classes;
using System.Web.Configuration;
using System.Web.UI.HtmlControls;

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
                d.EndDate > DateTime.Now && d.DealStatusID == 2
            select
                d
                ).ToList<DealInstance>();
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
        control.MenuBar = MenuBarType.NPO;

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
}