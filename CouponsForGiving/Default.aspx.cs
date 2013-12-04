using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
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
        string name = UsernameTextBox.Text.Trim();
        string org = OrganizationTextBox.Text.Trim();
        string email = EmailTextBox.Text.Trim();

        MailMessage mm = new MailMessage();

        //mm.To.Add(new MailAddress("michelle@coupons4giving.ca"));
        //mm.To.Add(new MailAddress("thompson@coupons4giving.ca"));
        //mm.To.Add(new MailAddress("jack@coupons4giving.ca"));
        mm.To.Add(new MailAddress("jack.schaible@hotmail.com"));
        mm.To.Add(new MailAddress("michelle.a.sklar@gmail.com"));

        mm.IsBodyHtml = true;

        if (org == "")
        {
            mm.Subject = "Email Signup: " + name + ", " + email;
            mm.Body = @"
                <style type='text/css'>
                    h1, a, p {
                        font-family: Corbel, Arial, sans-serif;
                    }
                </style>
                <p>Email signup</p>
                <p>Name: " + name + @"</p>
                <p>Email: " + email + @"</p>
            ";
        }
        else
        {
            mm.Subject = "Beta Signup: " + name + ", " + email + ", " + org;
            mm.Body = @"
                <style type='text/css'>
                    h1, a, p {
                        font-family: Corbel, Arial, sans-serif;
                    }
                </style>
                <h1>New Beta Signup</h1>
                <p>Name: " + name + @"</p>
                <p>Email: " + email + @"</p>
                <p>Organization: " + org + @"</p>
            ";
        }
        SmtpClient client = new SmtpClient();
        client.Send(mm);

        SignupLabel.Text = "Your request has been sent. A Coupons4Giving team member will respond to you shortly.";
    }
}