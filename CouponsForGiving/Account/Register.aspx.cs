﻿using System;
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

public partial class Account_Register : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        RegisterUser.ContinueDestinationPageUrl = "../redirect.aspx";
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
        mm.To.Add((new MailAddress(RegisterUser.Email)));
        mm.IsBodyHtml = true;
        mm.Subject = "Welcome to Coupons4Giving!";
        
        switch (role)
        {
            case "Customer":
                Response.Redirect("../Default/MyHome.aspx", false);
                mm.Body = "<h1>Welcome to Coupons4Giving!<h1><p>Thanks for registering with Coupons4Giving. Once you login to your account you can start supporting your favorite causes and purchasing great deals from a wide range of merchants and E-tailers (online only merchants).</p><p>Please contact us at <a href='mailto:teamc4g@coupons4giving.ca'>teamc4g@coupons4giving.ca</a> with any questions!</p><p>Click <a href='https://www.coupons4giving.ca/Default/CausesInMyArea.aspx'>here</a> to check out Coupons & Causes!</p><p>Cheers!</p><p>The Coupons4Giving Team</p>";
                break;

            case "NPO":
                Response.Redirect("../NPO/Signup.aspx", false);
                mm.Body = "<h1>Welcome to Coupons4Giving!</h1><p>Thanks for registering with Coupons4Giving. Once you login to your account you can get started. You can set up a campaign and start fundraising. You can support your favorite causes by purchasing great deals from a wide range of Merchants and E-Tailers (online-only merchants). You can set up merchant offers to support your favourite Not-For-Profits.</p><p><a href='https://www.coupons4giving.ca/Account/Login.aspx'>Click here</a> to go to your account.</p><p>Please contact us at <a href='mailto:teamc4g@coupons4giving.ca'>teamc4g@coupons4giving.ca</a> with any questions!</p><p>Cheers!</p><p>The Coupons4Giving Team</p>";
                break;

            case "Merchant":
                Response.Redirect("../Merchant/Signup.aspx", false);
                mm.Body = "<h1>Welcome to Coupons4Giving!</h1><p>Thanks for registering with Coupons4Giving. Once you login to your account you can get started. You can set up a campaign and start fundraising. You can support your favorite causes by purchasing great deals from a wide range of Merchants and E-Tailers (online-only merchants). You can set up merchant offers to support your favourite Not-For-Profits.</p><p><a href='https://www.coupons4giving.ca/Account/Login.aspx'>Click here</a> to go to your account.</p><p>Please contact us at <a href='mailto:teamc4g@coupons4giving.ca'>teamc4g@coupons4giving.ca</a> with any questions!</p><p>Cheers!</p><p>The Coupons4Giving Team</p>";
                break;
        }       

        new SmtpClient().Send(mm);
    }
}