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

    }
}