using CouponsForGiving;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class NPO_Anon : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Controls_MenuBar control = (Controls_MenuBar)Master.FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.NPO;

        if (User.IsInRole("NPO") || User.IsInRole("IncompleteNPO"))
            Response.Redirect("MyHome.aspx");
    }
}