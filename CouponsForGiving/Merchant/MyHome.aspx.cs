using CouponsForGiving;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Merchant_Home : System.Web.UI.Page
{
    protected override void OnInit(EventArgs e)
    {
        if (!User.IsInRole("Merchant"))
            Response.Redirect("Anon.aspx", true);
        base.OnInit(e);
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        Controls_MenuBar control = (Controls_MenuBar)Master.FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.Merchant;
    }
}