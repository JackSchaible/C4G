using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.AspNet.Membership.OpenAuth;
using CouponsForGiving.Data;
using Stripe;
using System.Net.Mail;
using System.Web.Services;
using System.Web.Script.Services;
using System.Xml;
using System.Web.Configuration;

public partial class Account_Register : Page
{
    public static List<string> Users;
    public XmlDocument strings;

    protected void Page_Load(object sender, EventArgs e)
    {
        RegisterUser.ContinueDestinationPageUrl = "../redirect.aspx";

        Users = new List<string>();
        foreach (MembershipUser item in Membership.GetAllUsers())
            Users.Add(item.UserName);

        ServerErrorDiv.Visible = false;
        strings = new XmlDocument();
        strings.Load(Server.MapPath(String.Format("Text ({0}).xml", WebConfigurationManager.AppSettings["Language"])));

        if (IsPostBack)
            ValidateData();
    }

    protected void RegisterUser_CreatedUser(object sender, EventArgs e)
    {
        FormsAuthentication.SetAuthCookie(RegisterUser.UserName, createPersistentCookie: false);

        string continueUrl = RegisterUser.ContinueDestinationPageUrl;
        if (!OpenAuth.IsLocalUrl(continueUrl))
        {
            continueUrl = "~/";
        }

        StripeCustomerCreateOptions options = new StripeCustomerCreateOptions();
        options.Email = RegisterUser.Email;
        options.Description = RegisterUser.UserName;

        Roles.AddUserToRole(RegisterUser.UserName, "User");
        SysData.cUser_Insert(RegisterUser.UserName, (new StripeCustomerService().Create(options)).Id);

        string role = ((RadioButtonList)this.RegisterUser.CreateUserStep.ContentTemplateContainer.FindControl("RoleRBL")).SelectedValue;
        MailMessage mm = new MailMessage();
        //mm.To.Add((new MailAddress(RegisterUser.Email)));
        mm.To.Add(new MailAddress("michelle.a.sklar@gmail.com"));
        mm.To.Add(new MailAddress("thompson@vaangels.com"));
        mm.IsBodyHtml = true;
        mm.Subject = "New User Signup: " + RegisterUser.Email + " - ";
        
        switch (role)
        {
            case "Customer":
                Response.Redirect("../Default/MyHome.aspx", false);
                //mm.Body = "<h1>Welcome to Coupons4Giving! - User<h1><p>Thanks for registering with Coupons4Giving. Once you login to your account you can start supporting your favorite causes and purchasing great deals from a wide range of merchants and E-tailers (online only merchants).</p><p>Please contact us at <a href='mailto:teamc4g@coupons4giving.ca'>teamc4g@coupons4giving.ca</a> with any questions!</p><p>Click <a href='https://www.coupons4giving.ca/Default/CausesInMyArea.aspx'>here</a> to check out Coupons & Causes!</p><p>Cheers!</p><p>The Coupons4Giving Team</p>";
                mm.Subject += "Supporter";
                break;

            case "NPO":
                Roles.AddUserToRole(RegisterUser.UserName, "IncompleteNPO");
                Response.Redirect("../NPO/Signup.aspx", false);
                //mm.Body = "<h1>Welcome to Coupons4Giving! - NPO</h1><p>Thanks for registering with Coupons4Giving. Once you login to your account you can get started. You can set up a campaign and start fundraising. You can support your favorite causes by purchasing great deals from a wide range of Merchants and E-Tailers (online-only merchants). You can set up merchant offers to support your favourite Not-For-Profits.</p><p><a href='https://www.coupons4giving.ca/Account/Login.aspx'>Click here</a> to go to your account.</p><p>Please contact us at <a href='mailto:teamc4g@coupons4giving.ca'>teamc4g@coupons4giving.ca</a> with any questions!</p><p>Cheers!</p><p>The Coupons4Giving Team</p>";
                mm.Subject += "NPO";
                break;

            case "Merchant":
                Roles.AddUserToRole(RegisterUser.UserName, "IncompleteMerchant");
                Response.Redirect("../Merchant/Signup.aspx", false);
                //mm.Body = "<h1>Welcome to Coupons4Giving! - Merchant</h1><p>Thanks for registering with Coupons4Giving. Once you login to your account you can get started. You can set up a campaign and start fundraising. You can support your favorite causes by purchasing great deals from a wide range of Merchants and E-Tailers (online-only merchants). You can set up merchant offers to support your favourite Not-For-Profits.</p><p><a href='https://www.coupons4giving.ca/Account/Login.aspx'>Click here</a> to go to your account.</p><p>Please contact us at <a href='mailto:teamc4g@coupons4giving.ca'>teamc4g@coupons4giving.ca</a> with any questions!</p><p>Cheers!</p><p>The Coupons4Giving Team</p>";
                mm.Subject += "Merchant";
                break;
        }       

        new SmtpClient().Send(mm);
    }

    private void ValidateData()
    {
        ServerErrorDiv.Visible = false;
        string username = (RegisterUser.FindControl("RegisterUserWizardStep").Controls[0].FindControl("UserName") as TextBox).Text;
        string email = (RegisterUser.FindControl("RegisterUserWizardStep").Controls[0].FindControl("Email") as TextBox).Text;
        string password = (RegisterUser.FindControl("RegisterUserWizardStep").Controls[0].FindControl("Password") as TextBox).Text;
        string confirmPassword = (RegisterUser.FindControl("RegisterUserWizardStep").Controls[0].FindControl("ConfirmPassword") as TextBox).Text;
        bool terms = (RegisterUser.FindControl("RegisterUserWizardStep").Controls[0].FindControl("TermsCheckbox") as CheckBox).Checked;
        List<string> errors = new List<string>();

        Validation validation = null;

        switch (WebConfigurationManager.AppSettings["Language"])
        {
            case "EN-US":
                validation = new Validation_EN_US();
                break;
        }

        if (validation.IsStringBlank(username))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Register/ErrorMessages/NullUsername").InnerText);

        if (validation.IsStringTooShort(username, 6))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Register/ErrorMessages/ShortUsername").InnerText);

        if (validation.IsStringTooLong(username, 32))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Register/ErrorMessages/LongUsername").InnerText);

        if (validation.ContainsCode(username))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Register/ErrorMessages/UsernameInvalidCharacters").InnerText);

        if (Users.Contains(username))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Register/ErrorMessages/UsernameInvalidCharacters").InnerText);

        if (validation.IsStringBlank(email))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Register/ErrorMessages/NullEmail").InnerText);

        if (validation.IsStringTooLong(email, 64))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Register/ErrorMessages/EmailTooLong").InnerText);

        if (validation.IsStringTooShort(email, 6))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Register/ErrorMessages/EmailTooShort").InnerText);

        if (validation.ContainsCode(email))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Register/ErrorMessages/EmailInvalidCharacters").InnerText);

        if (validation.IsValidEmail(email))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Register/ErrorMessages/InvalidEmail").InnerText);

        if (validation.IsStringBlank(password))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Register/ErrorMessages/NullPassword").InnerText);

        if (validation.IsStringTooShort(password, 6))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Register/ErrorMessages/PasswordLength").InnerText);

        if (validation.IsStringTooLong(password, 32))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Register/ErrorMessages/PasswordTooLong").InnerText);

        if (validation.ContainsCode(password))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Register/ErrorMessages/PasswordInvalidCharacters").InnerText);

        if (validation.IsStringBlank(confirmPassword))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Register/ErrorMessages/NullConfirmPassword").InnerText);

        if (validation.IsStringTooShort(confirmPassword, 6))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Register/ErrorMessages/ConfirmPasswordTooLong").InnerText);

        if (validation.IsStringTooLong(confirmPassword, 32))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Register/ErrorMessages/ConfirmPasswordTooShort").InnerText);

        if (validation.ContainsCode(confirmPassword))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Register/ErrorMessages/ConfirmPasswordInvalidCharacters").InnerText);

        if (confirmPassword != password)
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Register/ErrorMessages/ConfirmPasswordMatch").InnerText);

        if (!terms)
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Register/ErrorMessages/AgreeToTerms").InnerText);

        if (errors.Count > 0)
        {
            ServerErrorDiv.Visible = true;
            ServerErrorDiv.Controls.Add(validation.WriteErrorsList(errors));
        }
        else
            ServerErrorDiv.Visible = false;
    }

    [WebMethod]
    [ScriptMethod]
    public static bool? UsernameTaken(string username)
    {
        if (Users != null)
            return Users.Contains(username);
        else
            return null;
    }
}