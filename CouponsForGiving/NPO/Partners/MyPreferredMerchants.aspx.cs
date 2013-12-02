using CouponsForGiving;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class NPO_Partners_MyPreferredMerchants : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Controls_MenuBar control = (Controls_MenuBar)Master.FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.NPO;

        BindData();
    }

    private void BindData()
    {
        MyPrefferedMerchantsGV.DataSource = null;
        MyPrefferedMerchantsGV.DataBind();
    }
}