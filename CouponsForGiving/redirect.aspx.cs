using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class redirect : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (User.Identity.IsAuthenticated)
        {
            if (User.IsInRole("Admin"))
                Response.Redirect("Admin/MyDashboard.aspx");
            else if (User.IsInRole("NPO"))
                Response.Redirect("NPO/MyDashboard.aspx");
            else if (User.IsInRole("Merchant"))
                Response.Redirect("Merchant/MyDashboard.aspx");
            else if (User.IsInRole("User"))
                    Response.Redirect("Default/Home.aspx");
        }
        else
            Response.Redirect("Default.aspx");
    }
}