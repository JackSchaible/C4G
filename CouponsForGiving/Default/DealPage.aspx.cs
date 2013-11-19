using CouponsForGiving.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Default_DealPage : System.Web.UI.Page
{
    public Deal deal;
    public DealInstance dealInstance;
    public Merchant merchant;

    protected override void OnPreInit(EventArgs e)
    {
        if (Page.RouteData.Values["merchantname"] == null || Page.RouteData.Values["dealname"] == null)
            if (Request.QueryString["merchantname"] == null || Request.QueryString["deal"] == null)
                Response.Redirect("~/Default/Home.aspx", true);
            else
            {
                string merchantName = "";
                string dealName = "";

                if (Page.RouteData.Values["merchantname"] == null || Page.RouteData.Values["dealname"] == null)
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
                    Response.Redirect("../" + merchantName);

                merchant = deal.Merchant;
                Title = String.Format("{1} - {0}", deal.Name, merchant.Name);
            }

        base.OnPreInit(e);
    }

    protected void Page_Load(object sender, EventArgs e)
    {

    }
}