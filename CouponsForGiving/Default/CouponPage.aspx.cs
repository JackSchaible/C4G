using CouponsForGiving;
using CouponsForGiving.Data;
using CouponsForGiving.Data.Classes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Default_CouponPage : System.Web.UI.Page
{
    public string URL { get; set; }
    public Campaign campaign { get; set; }
    public NPO npo { get; set; }
    public Merchant merchant { get; set; }
    public DealInstance deal { get; set; }

    protected override void OnInit(EventArgs e)
    {
        if (Request.QueryString["merchant"] == null || Request.QueryString["npo"] == null || Request.QueryString["deal"] == null || Request.QueryString["campaign"] == null)
            Response.Redirect("DealsInMyArea.aspx");
        else
        {
            campaign = SysData.Campaign_GetByName(Request.QueryString["campaign"], Request.QueryString["npo"]);
            merchant = SysData.Merchant_GetByName(Request.QueryString["merchant"]);
            deal = SysData.DealInstance_GetByDealName(Request.QueryString["deal"], merchant.MerchantID);

            if (campaign == null || merchant == null || deal == null || CampaignDealInstances.Exists(campaign.CampaignID, deal.DealInstanceID) == false)
                Response.Redirect("DealsInMyArea.aspx", true);

            npo = campaign.NPO;
        }

        base.OnInit(e);
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        URL = WebServices.GetGoogleURL("https://www.coupons4giving.ca/Default/CouponPage.aspx?merchant=" + merchant.Name + "&deal=" + deal.Deal.Name + "&npo=" + npo + "&campaign=" + campaign);
        Title = deal.Deal.Name + " : " + campaign.Name + " - Coupons4Giving";
        Master.SideBar = false;
    }
}