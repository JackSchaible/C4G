using CouponsForGiving;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Merchant_Home : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Controls_MenuBar control = (Controls_MenuBar)Master.FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.Anonymous;

        if (User.IsInRole("Merchant"))
            control.MenuBar = MenuBarType.Merchant;

        if (User.Identity.IsAuthenticated)
        {
            AnonPanel.Visible = false;
            LoggedInPanel.Visible = true;
        }
        else
        {
            LoggedInPanel.Visible = false;
            AnonPanel.Visible = true;
        }
    }
}