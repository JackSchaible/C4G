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

        //if (Request.QueryString["
    }

    protected void ClearButton_Click(object sender, EventArgs e)
    {
        Session["Cart"] = null;
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