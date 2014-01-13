using CouponsForGiving;
using CouponsForGiving.Data;
using CouponsForGiving.Data.Classes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Merchant_Offers_MyOffers : System.Web.UI.Page
{    
    protected void Page_Load(object sender, EventArgs e)
    {
        Controls_MenuBar control = (Controls_MenuBar)Master.FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.Merchant;

        if (!IsPostBack)
            BindData();
    }

    private void BindData()
    {
        Merchant merchant = Merchants.GetByUsername(User.Identity.Name);

        if (merchant == null)
            Response.Redirect("../MyHome.aspx");

        List<DealInstance> deals = SysData.DealInstance_ListByMerchant(merchant.MerchantID);

        UpcomingOffersGV.DataSource =
        (
            from
                d
            in
                deals
            where
                d.StartDate > DateTime.Now
            select
                new
                {
                    DealID = d.DealInstanceID,
                    Name = d.Deal.Name,
                    StartDate = d.StartDate.ToString("dd MMM yyyy"),
                    EndDate = d.EndDate.ToString("dd MMM yyyy")
                }
        );

        CurrentOffersGV.DataSource =
        (
            from
                d
            in
                deals
            where
                d.StartDate < DateTime.Now
                && d.EndDate > DateTime.Now
            select new
            {
                DealID = d.DealID,
                Name = d.Deal.Name,
                Purchases = d.PurchaseOrders.Count,
                Revenue = d.PurchaseOrders.Count * d.Deal.Prices.FirstOrDefault<Price>().MerchantSplit
            }
        );

        PastOffersGV.DataSource =
        (
            from
                d
            in
                deals
            where
                d.EndDate < DateTime.Now
            select new
            {
                DealID = d.DealID,
                Name = d.Deal.Name,
                Purchases = d.PurchaseOrders.Count,
                Revenue = d.PurchaseOrders.Count * d.Deal.Prices.FirstOrDefault<Price>().MerchantSplit,
                StartDate = d.StartDate.ToString("dd MMM yyyy"),
                EndDate = d.EndDate.ToString("dd MMM yyyy")
            }
        );

        UpcomingOffersGV.DataBind();
        CurrentOffersGV.DataBind();
        PastOffersGV.DataBind();
    }
}