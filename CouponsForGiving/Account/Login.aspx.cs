using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Account_Login : Page
{
    string request;

    protected void Page_Load(object sender, EventArgs e)
    {
        RegisterHyperLink.NavigateUrl = "Register.aspx";
        OpenAuthLogin.ReturnUrl = "../redirect.aspx";

        request = "../redirect.aspx";

        RegisterHyperLink.NavigateUrl += "?ReturnUrl=" + "redirect.aspx";
    }

    protected override void OnUnload(EventArgs e)
    {
        base.OnUnload(e);

        if (User.Identity.IsAuthenticated)
        {
            if (User.IsInRole("Admin"))
                HttpContext.Current.Response.Redirect("../Admin/MyHome.aspx", true);
            else
            {
                if (User.IsInRole("NPO"))
                    HttpContext.Current.Response.Redirect("../NPO/MyHome.aspx", true);

                if (User.IsInRole("Merchant"))
                    HttpContext.Current.Response.Redirect("../Merchant/MyHome.aspx", true);

                HttpContext.Current.Response.Redirect("../Default/MyHome.aspx", true);
            }
        }
    }
}