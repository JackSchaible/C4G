using CouponsForGiving;
using CouponsForGiving.Data;
using CouponsForGiving.Data.Classes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Merchant_My_Coupons_Redeem : System.Web.UI.Page
{
    private List<PurchaseOrder> orders;

    protected void Page_Load(object sender, EventArgs e)
    {
        Controls_MenuBar control = (Controls_MenuBar)Master.FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.Merchant;

        if (!IsPostBack)
            BindData();
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

    protected void CouponsGV_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        CouponsGV.PageIndex = e.NewPageIndex;
        BindData();
    }

    protected void CouponsGV_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {
        try
        {
            PurchaseOrders.Redeem(int.Parse(CouponsGV.DataKeys[e.NewSelectedIndex].ToString()));
            BindData();
        }
        catch (Exception ex)
        {
            ErrorLabel.Text = "Something went wrong. Your coupon was not redeemed. Please contact us using the button above, and retain this error message: " + ex.Message;
        }
    }

    protected void RedeemButton_Click(object sender, EventArgs e)
    {
        if (orders.Contains(new PurchaseOrder { PurchaseOrderID = int.Parse(CouponCodeTextBox.Text.Trim()) }))
        {
            try
            {
                PurchaseOrders.Redeem(int.Parse(CouponCodeTextBox.Text.Trim()));
            }
            catch (Exception ex)
            {
                ErrorLabel.Text = "Something went wrong. Your coupon was not redeemed. Please contact us using the button above and retain this error message: " + ex.Message;
            }
        }
        else
            ErrorLabel.Text = "We were unable to find that coupon code. Please try again."; 
        
        BindData();
    }

    [System.Web.Services.WebMethodAttribute(), System.Web.Script.Services.ScriptMethodAttribute()]
    public static string[] GetCompletionList(string prefixText, int count, string contextKey)
    {
        List<PurchaseOrder> pos = PurchaseOrders.ListActiveByMerchant(HttpContext.Current.User.Identity.Name);

        return (from po in pos select po.PurchaseOrderID.ToString()).ToArray<string>();
    }
}