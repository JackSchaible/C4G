using CouponsForGiving;
using CouponsForGiving.Data;
using CouponsForGiving.Data.Classes;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Net.Mail;
using System.Security.Cryptography;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class NPO_Partners_Add : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Controls_MenuBar control = (Controls_MenuBar)Master.FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.NPO;

        if (!IsPostBack)
        {
            CitiesDDL.DataSource = SysData.ListCities();
            CitiesDDL.DataBind();
            BindData();
        }
        else
        {
            BindData();

            if (LocalMerchantsGV.Rows.Count == 0)
                ErrorLabel.Text = "Either we were unable to locate any merchants in your selected city, or you are already partnered with all of them.";
        }
    }

    private void BindData()
    {
        List<Merchant> local = MerchantNPO.ListEligiblePartnersByNPO(User.Identity.Name, int.Parse(CitiesDDL.SelectedValue));

        LocalMerchantsGV.DataSource = local;
        LocalMerchantsGV.DataBind();

        List<Merchant> global = MerchantNPO.ListEligibleGlobalPartnersByNPO(User.Identity.Name);
        GlobalMarketplaceGV.DataSource = global;
        GlobalMarketplaceGV.DataBind();
    }

    protected void GlobalMarketplaceGV_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {
        try
        {
            Merchant merch = SysData.Merchant_Get(int.Parse(GlobalMarketplaceGV.DataKeys[e.NewSelectedIndex].Value.ToString()));
            SysData.NPO_InsertMerchantPartner(merch.MerchantID, User.Identity.Name);
            NPO npo = SysDatamk.NPO_GetByUsername(User.Identity.Name);
            MailMessage mm = new MailMessage();
            mm.IsBodyHtml = true;

            if (MerchantSettings.AcceptsAllRequests(merch.MerchantID))
            {
                mm.To.Add(merch.Email);
                Merchants.AddNPOPartner(npo.NPOID, merch.MerchantID);
                mm.Subject = "C4G: " + npo.Name + " Has Partnered with You!";
                mm.Body = @"
                            <style type='text/css'>
                                h1, a, p {
                                    font-family: Corbel, Arial, sans-serif;
                                }
                            </style>
                            <p>Congratulations! The not-for-profit organization '" + npo.Name + @"' has partnered with you to offer great deals!</p>
                            <p>If you have any questions, contact us at <a href='mailto:team@coupons4giving.ca'>team@coupons4giving.ca</a></p>
                            <p>Cheers!</p>
                            <p>The Coupons4Giving Team</p>
                           ";

                GlobalError.Text = "Congratulations! You are now partnered with that Merchant!";
                GlobalError.Style.Add("display", "block");
            }
            else
            {
                mm.To.Add(merch.Email);
                //Add to db record, send email request to merchant
                string request = String.Format("mid={0}&npoid={1}", merch.MerchantID, npo.NPOID);
                request = CouponsForGiving.EncryptionUtils.Encrypt(request);

                mm.Subject = String.Format("C4G: New Request from {0}", npo.Name);
                mm.Body = @"
                            <style type='text/css'>
                                h1, a, p {
                                    font-family: Corbel, Arial, sans-serif;
                                }
                            </style>
                            <h1>You have a New Request from Coupons4Giving!</h1>
                            <p>" + npo.Name + @" has requested to partner with you!</p>
                            <p><a href='https://www.coupons4giving.ca/'" + npo.Name + @">Click here</a> to view their page!</p>
                            <p><a href='https://www.coupons4giving.ca/Merchant/Partners/Requests.aspx'>Click here to log in and accept the request!</a>
                            ";
                GlobalError.Text = "A request has been sent to that Merchant!";
                GlobalError.ForeColor = Color.Black;
            }

            SmtpClient c = new SmtpClient();
            c.Send(mm);
            BindData();
        }
        catch (Exception ex)
        {
            GlobalError.Text = ex.Message;
            GlobalError.ForeColor = Color.Red;
        }
    }

    protected void LocalMerchantsGV_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {
        try
        {               
            Merchant merch = SysData.Merchant_Get(int.Parse(LocalMerchantsGV.DataKeys[e.NewSelectedIndex].Value.ToString()));
            SysData.NPO_InsertMerchantPartner(merch.MerchantID, User.Identity.Name);
            NPO npo = SysDatamk.NPO_GetByUsername(User.Identity.Name);
            MailMessage mm = new MailMessage();
            mm.IsBodyHtml = true;

            if (MerchantSettings.AcceptsAllRequests(merch.MerchantID))
            {
                mm.To.Add(merch.Email);
                Merchants.AddNPOPartner(npo.NPOID, merch.MerchantID);
                mm.Subject = "C4G: " + npo.Name + " Has Partnered with You!";
                mm.Body = @"
                            <style type='text/css'>
                                h1, a, p {
                                    font-family: Corbel, Arial, sans-serif;
                                }
                            </style>
                            <p>Congratulations! The not-for-profit organization '" + npo.Name + @"' has partnered with you to offer great deals!</p>
                            <p>If you have any questions, contact us at <a href='mailto:team@coupons4giving.ca'>team@coupons4giving.ca</a></p>
                            <p>Cheers!</p>
                            <p>The Coupons4Giving Team</p>
                           ";

                ErrorLabel.Text = "Congratulations! You are now partnered with that Merchant!";
                ErrorLabel.Style.Add("display", "block");
            }
            else
            {
                mm.To.Add(merch.Email);
                //Add to db record, send email request to merchant
                string request = String.Format("mid={0}&npoid={1}", merch.MerchantID, npo.NPOID);
                request = CouponsForGiving.EncryptionUtils.Encrypt(request);

                mm.Subject = String.Format("C4G: New Request from {0}", npo.Name);
                mm.Body = @"
                            <style type='text/css'>
                                h1, a, p {
                                    font-family: Corbel, Arial, sans-serif;
                                }
                            </style>
                            <h1>You have a New Request from Coupons4Giving!</h1>
                            <p>" + npo.Name + @" has requested to partner with you!</p>
                            <p><a href='https://www.coupons4giving.ca/'" + npo.Name + @">Click here</a> to view their page!</p>
                            <p><a href='https://www.coupons4giving.ca/Merchant/Partners/Requests.aspx'>Click here to log in and accept the request!</a>
                            ";
                ErrorLabel.Text = "A request has been sent to that Merchant!";
                ErrorLabel.ForeColor = Color.Black;
            }

            SmtpClient c = new SmtpClient();
            c.Send(mm);
            BindData();
        }
        catch (Exception ex)
        {
            ErrorLabel.Text = ex.Message;
            ErrorLabel.ForeColor = Color.Red;
        }
    }

    protected void EmailSubmit_Click(object sender, EventArgs e)
    {
        MailMessage mm = new MailMessage();
        NPO npo = SysDatamk.NPO_GetByUsername(User.Identity.Name);

        string name = NameTextBox.Text.Trim();
        string email = EmailTextBox.Text.Trim();
        string company = CompanyNameTextBox.Text.Trim();

        mm.To.Add(new MailAddress(email));

        mm.Subject = String.Format("New Request from {0}", npo.Name); 
        mm.IsBodyHtml = true;
        mm.Body = @"
            <style type='text/css'>
                h1, a, p {
                    font-family: Corbel, Arial, sans-serif;
                }
            </style>
            <p>Dear " + name + @"</p>
            <p>My not-for-profit " + npo.Name + @" is running a campaign on Coupons4Giving to raise funds for our organization. We would like to partner with you to help ur reach our goals. To learn more about Coupons4Giving, or to register your company and set up offers, <a href='https://www.coupons4giving.ca/Account/Register.aspx'>Click Here</a></p>
            <p>Thanks in Advance For Your Support,</p>
            <p>" + npo.cUsers.FirstOrDefault<cUser>().Username +  " - " + npo.Name + "</p>";

        SmtpClient client = new SmtpClient();

        MailMessage confirmationEmail = new MailMessage();
        confirmationEmail.IsBodyHtml = true;

        confirmationEmail.To.Add(npo.Email);

        confirmationEmail.Subject = "Coupons4Giving Preferred Merchant Invitation";
        confirmationEmail.Body = @"
            <style type='text/css'>
                h1, a, p {
                    font-family: Corbel, Arial, sans-serif;
                }
            </style>
            <h1>Merchant Partner Invite</h1>
            <p>Your invitation to " + name + " from " + company + " at " + email + @" has been sent! If you have any questions, please contact <a href='mailto:team@coupons4giving.ca'>team@coupons4giving.ca</a>.</p>
            <p>Cheers!</p>
            <p>The Coupons4Giving Team</p>
            ";

        client.Send(confirmationEmail);
        client.Send(mm);

        ResultLabel.Text = "Your invite has been sent!";
        NameTextBox.Text = "";
        EmailTextBox.Text = "";
        CompanyNameTextBox.Text = "";
    }
}