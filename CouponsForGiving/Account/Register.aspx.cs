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
using CouponsForGiving;

public partial class Account_Register : Page
{
    public static List<string> Users;
    public static List<string> Emails;
    public XmlDocument strings;

    protected void Page_Load(object sender, EventArgs e)
    {
        RegisterUser.ContinueDestinationPageUrl = "../redirect.aspx";

        Users = new List<string>();
        Emails = new List<string>();

        foreach (MembershipUser item in Membership.GetAllUsers())
        {
            Users.Add(item.UserName);
            Emails.Add(item.Email);
        }

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
        List<string> To = new List<string>();
        To.Add(RegisterUser.Email);
        To.Add("michelle.a.sklar@gmail.com");
        To.Add("thompson@vaangels.com");
        
        switch (role)
        {
            case "Customer":
                EmailUtils.SendUserRegistrationEmail(To, RegisterEmailType.User);
                Response.Redirect("../Default/MyHome.aspx", false);
                break;

            case "NPO":
                EmailUtils.SendUserRegistrationEmail(To, RegisterEmailType.NPO);
                Roles.AddUserToRole(RegisterUser.UserName, "IncompleteNPO");
                Response.Redirect("../NPO/Signup.aspx", false);
                break;

            case "Merchant":
                EmailUtils.SendUserRegistrationEmail(To, RegisterEmailType.Merchant);
                Roles.AddUserToRole(RegisterUser.UserName, "IncompleteMerchant");
                Response.Redirect("../Merchant/Signup.aspx", false);
                break;
        }       
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
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Register/ErrorMessages/UsernameTooShort").InnerText);

        if (validation.IsStringTooLong(username, 32))
            errors.Add(strings.SelectSingleNode("/SiteText/Pages/Register/ErrorMessages/UsernameTooLong").InnerText);

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

    [WebMethod]
    [ScriptMethod]
    public static bool? EmailTaken(string email)
    {
        bool result = false;

        if (email != null)
            result = Emails.Contains(email);

        return result;
    }
}