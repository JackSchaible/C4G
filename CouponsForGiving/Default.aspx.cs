using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.Cookies["IsUserLoggedIn"] != null)
            Response.Redirect("Home.aspx", false);
    }

    protected void SubmitButton_Click(object sender, EventArgs e)
    {
        string username = "", password = "";

        username = UsernameTextBox.Text.Trim();
        password = PasswordTextBox.Text.Trim();

       

        if (username != "Beta")
            LoginErrorLabel.Text = "Username is wrong. ";
        else if (password != "generus123")
            LoginErrorLabel.Text += "Password is wrong.";
        else
        {
            HttpCookie userCookie = new HttpCookie("IsUserLoggedIn", "1");
            Response.AppendCookie(userCookie);
            Response.Redirect("Home.aspx", false);
        }
    }

    protected void EmailButton_Click(object sender, EventArgs e)
    {

    }
}