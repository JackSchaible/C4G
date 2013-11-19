using CouponsForGiving;
using CouponsForGiving.Data;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Newsletter : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Controls_MenuBar control = (Controls_MenuBar)Master.FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.Anonymous;

        if (!Page.IsPostBack)
        {
            ErrorLabel.Text = "";
            ErrorLabel.ForeColor = Color.Black;

            if (Request.QueryString["Email"] != null)
                Signup(Request.QueryString["Email"]);
        }
    }

    protected void SubmitButton_Click(object sender, EventArgs e)
    {
        string email = EmailTextbox.Text.Trim();

        Signup(email);
    }

    private void Signup(string email)
    {
        if (!(new RegexUtils()).IsValidEmail(email))
        {
            ErrorLabel.Text = "Email is not valid";
            ErrorLabel.ForeColor = Color.Red;
        }
        else
        {
            try
            {
                SysData.NewsletterUser_Signup(email);
                ErrorLabel.Text = "You have successfully signed up!";
            }
            catch (Exception ex)
            {
                ErrorLabel.Text = ex.Message;
                ErrorLabel.ForeColor = Color.Red;
            }
        }
    }
}