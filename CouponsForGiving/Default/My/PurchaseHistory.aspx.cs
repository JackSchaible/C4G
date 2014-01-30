using CouponsForGiving;
using CouponsForGiving.Data;
using CouponsForGiving.Data.Classes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Default_My_PurchaseHistory : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Controls_MenuBar control = (Controls_MenuBar)Master.FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.Supporter;

        UnredeemedGV.DataSource =
        (
            from po
            in PurchaseOrders.ListUnredeemedByUser(User.Identity.Name)
            select new
            {
                POID = po.PurchaseOrderID,
                Deal = po.DealInstance.Deal.Name,
                Merchant = po.DealInstance.Deal.Merchant.Name,
                Campaign = po.Campaign.Name,
                NPO = po.Campaign.NPO.Name,
                Price = po.DealInstance.Deal.Prices.FirstOrDefault<Price>().GiftValue
            }
        );
        UnredeemedGV.DataBind();

       RedeemedGV.DataSource =
       (
           from po
           in PurchaseOrders.ListRedeemedByUser(User.Identity.Name)
           select new
           {
               POID = po.PurchaseOrderID,
               Deal = po.DealInstance.Deal.Name,
               Merchant = po.DealInstance.Deal.Merchant.Name,
               Campaign = po.Campaign.Name,
               NPO = po.Campaign.NPO.Name,
               Price = po.DealInstance.Deal.Prices.FirstOrDefault<Price>().GiftValue
           }
       );
       RedeemedGV.DataBind();
    }

    protected void UnredeemedGV_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {
        //Magic?
        PurchaseOrder item = (
            from po
            in PurchaseOrders.ListUnredeemedByUser(User.Identity.Name)
            where po.PurchaseOrderID == int.Parse(UnredeemedGV.DataKeys[e.NewSelectedIndex].Value.ToString())
            select po
        ).FirstOrDefault<PurchaseOrder>();

        string url = "../../" + PDFUtils.CreateCouponPDF(item).Replace(Request.ServerVariables["APPL_PHYSICAL_PATH"], String.Empty);
        Response.Redirect(url);
    }
}