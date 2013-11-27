using CouponsForGiving;
using CouponsForGiving.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class NPO_Confirmation : System.Web.UI.Page
{
    public NPO npo;

    protected void Page_Load(object sender, EventArgs e)
    {
        Controls_MenuBar control = (Controls_MenuBar)Master.FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.NPO;

        try
        {
            npo = SysDatamk.NPO_GetByUsername(User.Identity.Name);
        }
        catch (Exception ex)
        {
            ex.ToString();
        }

        if (npo == null)
        {
            Response.Redirect("../Default.aspx");
        }
    }
}