using CouponsForGiving;
using CouponsForGiving.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Transactions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Default_My_Cart : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Controls_MenuBar control = (Controls_MenuBar)Master.FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.Supporter;

        if (!IsPostBack)
            BindData();
    }

    private void BindData()
    {
        List<ShoppingCart> cart = (List<ShoppingCart>)Session["Cart"];
        CartGV.DataSource = cart;
        CartGV.DataBind();

        if (cart != null)
        {
            decimal subtotal = cart.Sum(item => item.GiftValue);
            SubtotalLabel.Text = String.Format("{0:C}", subtotal);

            //Replace with localized tax
            TotalLabel.Text = String.Format("{0:C}", subtotal);
        }
        else
        {
            SubtotalLabel.Text = "$0.00";
            TotalLabel.Text = "$0.00";
        }
    }

    protected void Cart_SelectedIndexChanged(object sender, EventArgs e)
    {
        DataKey key = CartGV.SelectedDataKey;
        Response.Redirect(String.Format("../DealPage.aspx?did={0}&cid={1}", CartGV.SelectedDataKey.Values[0], CartGV.SelectedDataKey.Values[1]));
    }

    protected void Cart_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        List<ShoppingCart> cart = (List<ShoppingCart>)Session["Cart"];
        DataKey key = CartGV.DataKeys[e.RowIndex];
        int dealID = int.Parse(key.Values[0].ToString());
        int campaignID = int.Parse(key.Values[1].ToString());

        for (int i = 0; i < cart.Count; i++)
            if (cart[i].CampaignID == campaignID && cart[i].DealInstanceID == dealID)
                cart.RemoveAt(i);

        Session["Cart"] = cart;
        BindData();
    }

    protected void ClearButton_Click(object sender, EventArgs e)
    {
        Session["Cart"] = null;
        BindData();
    }
    
    protected void CheckoutButton_Click(object sender, EventArgs e)
    {
        List<ShoppingCart> cart = (List<ShoppingCart>)Session["Cart"];

        if (cart != null)
            if (cart.Count > 0)
                try
                {
                    Response.Redirect("PaymentOptions.aspx");
                }
                catch (Exception ex)
                {
                    ErrorLabel.Text = ex.Message;
                }
            else
                ErrorLabel.Text = "Your cart is currently empty.";
        else
            ErrorLabel.Text = "Your cart is currently empty.";
    }
}