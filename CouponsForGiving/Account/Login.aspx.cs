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
        OpenAuthLogin.ReturnUrl = Request.QueryString["ReturnUrl"];

        request = Request.QueryString["ReturnUrl"];

        RegisterHyperLink.NavigateUrl += "?ReturnUrl=" + "redirect.aspx";
    }

    protected override void OnUnload(EventArgs e)
    {
        base.OnUnload(e);

        if (User.Identity.IsAuthenticated)
        {
            if (User.IsInRole("Admin"))
                Response.Redirect("../Admin/MyHome.aspx", true);
            else
            {
                if (User.IsInRole("NPO"))
                    Response.Redirect("../NPO/MyHome.aspx", true);

                if (User.IsInRole("Merchant"))
                    Response.Redirect("../Merchant/MyHome.aspx", true);

                Response.Redirect("../Default/MyHome.aspx", true);
            }
        }
    }
}