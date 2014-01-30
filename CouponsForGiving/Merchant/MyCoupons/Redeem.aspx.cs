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

        if (Request["cid"] != null)
        {
            try
            {
                Guid couponID = Guid.Parse(Request["cid"]);
                PurchaseOrder po = PurchaseOrders.Get(couponID);

                if (po == null)
                    ErrorLabel.Text = "That coupon does not exist.";
                else if (po.OrderStatusID != 1)
                    ErrorLabel.Text = "That coupon has already been redeemed.";
                else
                {
                    List<PurchaseOrder> orders = PurchaseOrders.ListActiveByMerchant(User.Identity.Name);
                    bool orderExists = (from o in orders where o.CouponCode == couponID select o).Count() == 1;

                    if (orderExists)
                    {
                        PurchaseOrders.RedeemByCouponCode(couponID);
                        ErrorLabel.Text = "Coupon has been redeemed!";
                    }
                    else
                    {
                        ErrorLabel.Text = "The specified coupon does not belong to this merchant account.";
                    }
                }
            }
            catch (Exception ex)
            {
                ErrorLabel.Text = ex.Message;
            }
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
                CouponID = po.PurchaseOrderID,
                CouponCode = po.CouponCode,
                MerchantName = po.DealInstance.Deal.Merchant.Name,
                DealName = po.DealInstance.Deal.Name,
                Customer = po.PurchaseTransaction.cUser.Username,
                NPOName = po.Campaign.NPO.Name,
                CampaignName = po.Campaign.Name,
                StartDate = po.DealInstance.StartDate.ToString("dd MMM yyyy"),
                EndDate = po.DealInstance.EndDate.ToString("dd MMM yyyy")
            }
        ).ToList();

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
            int couponID = int.Parse(CouponsGV.DataKeys[e.NewSelectedIndex].Value.ToString());
            PurchaseOrder po = PurchaseOrders.Get(couponID);

            if (po == null)
                ErrorLabel.Text = "Coupon does not exist.";
            else if (po.OrderStatusID != 1)
                ErrorLabel.Text = "Coupon has already been redeemed.";
            else
            {
                List<PurchaseOrder> orders = PurchaseOrders.ListActiveByMerchant(User.Identity.Name);
                bool orderExists = (from o in orders where o.PurchaseOrderID == couponID select o).Count() == 1;

                if (orderExists)
                {
                    PurchaseOrders.Redeem(couponID);
                    BindData(); 
                    ErrorLabel.Text = "Coupon has been redeemed!";
                }
                else
                {
                    ErrorLabel.Text = "The specified coupon does not belong to this merchant account.";
                }
            }
        }
        catch (Exception ex)
        {
            ErrorLabel.Text = "Something went wrong. Your coupon was not redeemed. Please contact us using the button above, and retain this error message: " + ex.Message;
        }
    }

    protected void RedeemButton_Click(object sender, EventArgs e)
    {
        string couponCode = CouponCodeTextBox.Text.Trim().Replace("-", "");
        if (couponCode.Length != 32)
        {
            int id = -1;

            try
            {
                id = int.Parse(couponCode);
            }
            catch (Exception ex)
            {
                ErrorLabel.Text = "The coupon code is a valid number (i.e., 44)";
            }

            if (id != -1)
            {
                PurchaseOrder po = PurchaseOrders.Get(id);

                if (po == null)
                    ErrorLabel.Text = "Coupon does not exist.";
                else if (po.OrderStatusID != 1)
                    ErrorLabel.Text = "Coupon has already been redeemed.";
                else
                {
                    List<PurchaseOrder> orders = PurchaseOrders.ListActiveByMerchant(User.Identity.Name);
                    bool orderExists = (from o in orders where o.PurchaseOrderID == id select o).Count() == 1;

                    if (orderExists)
                    {
                        PurchaseOrders.Redeem(id);
                        BindData();
                        ErrorLabel.Text = "Coupon has been redeemed!";
                    }
                    else
                    {
                        ErrorLabel.Text = "The specified coupon does not belong to this merchant account.";
                    }
                }
            }
            else
            {
                ErrorLabel.Text = "Something went wrong. We were unable to get the coupon code.";
            }

        }
        else
        {
            Guid id = Guid.Empty;

            try
            {
                id = Guid.Parse(couponCode);
            }
            catch (Exception ex)
            {
                ErrorLabel.Text = "The coupon code is not in a valid format (i.e., '1a3b5c7d-e2f4-1a3b-1a3b-1a3b5c7d9ebc')";
            }

            if (id != Guid.Empty)
            {
                PurchaseOrder po = PurchaseOrders.Get(id);

                if (po == null)
                    ErrorLabel.Text = "That coupon does not exist.";
                else if (po.OrderStatusID != 1)
                    ErrorLabel.Text = "That coupon has already been redeemed.";
                else
                {
                    List<PurchaseOrder> orders = PurchaseOrders.ListActiveByMerchant(User.Identity.Name);
                    bool orderExists = (from o in orders where o.CouponCode == id select o).Count() == 1;

                    if (orderExists)
                    {
                        PurchaseOrders.RedeemByCouponCode(id);
                        ErrorLabel.Text = "Coupon has been redeemed!";
                    }
                    else
                    {
                        ErrorLabel.Text = "The specified coupon does not belong to this merchant account.";
                    }
                }
            }
            else
            {
                ErrorLabel.Text = "Something went wrong. We were unable to get the coupon code.";
            }
        }
        
        BindData();
    }
}