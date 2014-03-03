using CouponsForGiving;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ContactUs : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Controls_MenuBar control = (Controls_MenuBar)Master.FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.Anonymous;
    }

    protected void SubmitButton_Click(object sender, EventArgs e)
    {
        string name = "", org = "", email = "", content = "";

        name = NameTextBox.Text;
        org = NameTextBox.Text;
        email = EmailTextBox.Text;
        content = ContentTextBox.Text;

        MailMessage mm = new MailMessage();

        //mm.To.Add(new MailAddress("support@coupons4giving.ca"));
        //mm.To.Add(new MailAddress("michelle@coupons4giving.ca"));
        mm.To.Add(new MailAddress("jack@coupons4giving.ca"));
        //mm.To.Add(new MailAddress("thompson@coupons4giving.ca"));
        mm.Subject = String.Format("Coupons4Giving Help: {0}", name);
        mm.IsBodyHtml = true;

        mm.Body = @"<style> h1, p { font-family: Corbel, Arial, sans-serif; } span { font-weight: bold; } </style>"
            + "<h1>Request for Help from Coupons4Giving</h1>"
            + "<p><span>Name:</span>" +  name + "</p>"
            + "<p><span>Organization:</span>" +  org + "</p>"
            + "<p><span>Email:</span>" + email + "</p>"
            + "<p><span>Content:</span>" +  content + "</p>";

        try
        {
            SmtpClient client = new SmtpClient();
            client.Send(mm);
            Response.Redirect("ThankYou.aspx");
            ErrorLabelcontact.Text = "Thank you for your input. A representative will contact you shortly!";
        }
        catch (Exception ex)
        {
            ErrorLabelcontact.Text = ex.Message;
        }
    }
}