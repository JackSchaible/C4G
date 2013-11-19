using CouponsForGiving;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Controls_MenuBar : System.Web.UI.UserControl
{
    public MenuBarType MenuBar { get; set; }

    protected override void OnPreRender(EventArgs e)
    {
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        switch(MenuBar)
        {
            case MenuBarType.HomePage:
                SiteMapDataSource.SiteMapProvider = "Home";
                
                Menu.Style["margin"] = "0 20px 0 20px";
                break;

            case MenuBarType.Anonymous:
                SiteMapDataSource.SiteMapProvider = "Anonymous";
                break;

            case MenuBarType.Admin:
                SiteMapDataSource.SiteMapProvider = "Admin";
                break;

            case MenuBarType.Supporter:
                SiteMapDataSource.SiteMapProvider = "Supporter";
                break;

            case MenuBarType.Merchant:
                SiteMapDataSource.SiteMapProvider = "Merchant";
                break;

            case MenuBarType.NPO:
                SiteMapDataSource.SiteMapProvider = "NPO";
                break;
        }
        
    }
}