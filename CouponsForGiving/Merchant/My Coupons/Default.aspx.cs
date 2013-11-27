using CouponsForGiving.Data;
using CouponsForGiving.Data.Classes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Merchant_My_Coupons_Coupons : System.Web.UI.Page
{
    private List<PurchaseOrder> orders;
    public string EmptyMessage { get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            BindData();

        switch (FilterDDL.SelectedValue)
        {
            case "All":
                EmptyMessage = "You currently have no coupons.";
                ((CommandField)CouponsGV.Columns[0]).ShowSelectButton = false;
                break;

            case "Unredeemed":
                EmptyMessage = "You currently have no unredeemed coupons.";
                ((CommandField)CouponsGV.Columns[0]).ShowSelectButton = true;
                ((CommandField)CouponsGV.Columns[0]).SelectText = "Redeem";
                break;

            case "Redeemed":
                EmptyMessage = "You currently have no redeemed coupons.";
                ((CommandField)CouponsGV.Columns[0]).ShowSelectButton = true;
                ((CommandField)CouponsGV.Columns[0]).SelectText = "Unredeem";
                break;
        }
    }

    private void BindData()
    {
        List<PurchaseOrder> pos = PurchaseOrders.ListActiveByMerchant(User.Identity.Name);
        orders = pos;
        ErrorLabel.Text = "";
        CouponsGV.DataSource =
            (
                from
                    po
                in
                    pos
                orderby
                    po.PurchaseDate
                select new
                {
                    CouponCode = po.PurchaseOrderID,
                    MerchantName = po.DealInstance.Deal.Merchant.Name,
                    DealName = po.DealInstance.Deal.Name,
                    Customer = po.PurchaseTransaction.cUser.Username,
                    NPOName = po.Campaign.NPO.Name,
                    CampaignName = po.Campaign.Name,
                    StartDate = po.DealInstance.StartDate.ToString("dd MMM yyyy"),
                    EndDate = po.DealInstance.EndDate.ToString("dd MMM yyyy")
                }
            );

        CouponsGV.DataBind();
    }

    protected void CouponsGV_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {
        switch (FilterDDL.SelectedValue)
        {
            case "All":
                break;

            case "Unredeemed":
                try
                {
                    PurchaseOrders.Redeem(int.Parse(CouponsGV.DataKeys[e.NewSelectedIndex].ToString()));
                }
                catch (Exception ex)
                {
                    ErrorLabel.Text = "Something went wrong. Your coupon was not redeemed. Please contact us using the button above, and retain this error message: " + ex.Message;
                }
                break;

            case "Redeemed":
                try
                {
                    PurchaseOrders.Unredeem(int.Parse(CouponsGV.DataKeys[e.NewSelectedIndex].ToString()));
                }
                catch (Exception ex)
                {
                    ErrorLabel.Text = "Something went wrong. Your coupon was not unredeemed. Please contact us using the button above, and retain this error message: " + ex.Message;
                }

                break;
        }

    }

    protected void CouponsGV_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        CouponsGV.PageIndex = e.NewPageIndex;
        BindData();
    }
}