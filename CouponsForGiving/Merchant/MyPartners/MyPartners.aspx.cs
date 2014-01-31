﻿using CouponsForGiving;
using CouponsForGiving.Data;
using CouponsForGiving.Data.Classes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Transactions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Merchant_MyPartners_MyPartners : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Controls_MenuBar control = (Controls_MenuBar)Master.FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.Merchant;

        if (!IsPostBack)
        {
            BindData();
        }
    }

    private void BindData()
    {
        RequestsGV.DataSource =
        (
            from npo
            in Merchants.ListNPORequests(User.Identity.Name)
            select new
            {
                npo.NPOID,
                npo.Name,
                npo.NPODescription,
                npo.PhoneNumber,
                npo.URL,
                npo.Logo,
                npo.Email,
                City = npo.City.Name + ", " + npo.City.PoliticalDivision.Name
            }
        );
        RequestsGV.DataBind();

        if (RequestsGV.Rows.Count == 0)
        {
            PendingRequestsPanel.Visible = false;
            PendingRequestsPanel.Enabled = false;
        }
        else
        {
            PendingRequestsPanel.Visible = true;
            PendingRequestsPanel.Enabled = true;
        }

        List<NPO> npos = NPOs.ListPartnersByMerchant(User.Identity.Name);
        NPOGV.DataSource =
            (
                from n
                in npos
                select new
                {
                    NPOID = n.NPOID,
                    Name = n.Name,
                    City = n.City.Name,
                    Province = n.City.PoliticalDivision.Name,
                    Campaigns = (from c in n.Campaigns where c.CampaignStatusID == 2 select c).Count()
                }
            );
        NPOGV.DataBind();
        ErrorLabel.Text = "";
    }

    //private void BindData(string city, string province)
    //{
    //    List<NPO> npos = NPOMerchants.ListEligiblePartnersByMerchant(User.Identity.Name);

    //    NPOGV.DataSource =
    //        (
    //            from n
    //            in npos
    //            where n.City.Name == city
    //            && n.City.PoliticalDivision.Name == province
    //            select new
    //            {
    //                Name = n.Name,
    //                City = n.City.Name,
    //                Province = n.City.PoliticalDivision.Name,
    //                NoOfCampaigns = (from c in n.Campaigns where c.CampaignStatusID == 2 select c).Count()
    //            }
    //        );
    //    NPOGV.DataBind();
    //}

    private void BindData(string Name)
    {
        List<NPO> npos = NPOMerchants.ListEligiblePartnersByMerchant(User.Identity.Name);

        NPOGV.DataSource =
            (
                from n
                in npos
                where n.Name.Contains(Name)
                select new
                {
                    NPOID = n.NPOID,
                    Name = n.Name,
                    City = n.City.Name,
                    Province = n.City.PoliticalDivision.Name,
                    NoOfCampaigns = (from c in n.Campaigns where c.CampaignStatusID == 2 select c).Count()
                }
            );
        NPOGV.DataBind();
    }

    //private void BindData(string city, string province, string Name)
    //{
    //    List<NPO> npos = NPOMerchants.ListEligiblePartnersByMerchant(User.Identity.Name);

    //    NPOGV.DataSource =
    //        (
    //            from n
    //            in npos
    //            where n.City.Name == city
    //            && n.City.PoliticalDivision.Name == province
    //            && n.Name.Contains(Name)
    //            select new
    //            {
    //                Name = n.Name,
    //                City = n.City.Name,
    //                Province = n.City.PoliticalDivision.Name,
    //                NoOfCampaigns = (from c in n.Campaigns where c.CampaignStatusID == 2 select c).Count()
    //            }
    //        );
    //    NPOGV.DataBind();
    //}


    protected void NPOGV_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        try
        {
            SysData.RemovePartnership(SysDatamk.Merchant_GetByUsername(User.Identity.Name).MerchantID,
                int.Parse(e.Keys[0].ToString()));

            BindData();
        }
        catch (Exception ex)
        {
            ErrorLabel.Text = "Something went wrong! The partnership wasn't removed. Please use the Contact Us button above and retain the following error message: " + ex.Message;
        }
    }

    protected void AcceptAll_Click(object sender, EventArgs e)
    {
        using (TransactionScope ts = new TransactionScope())
        {
            try
            {
                foreach (NPO n in (from npo in Merchants.ListNPORequests(User.Identity.Name) select npo))
                    Merchants.ApproveNPORequest(User.Identity.Name, n.NPOID);

                ts.Complete();
                BindData();
            }
            catch (Exception ex)
            {
                ErrorLabel.Text = "Approving all requests failed. Please try accepting them individually.";
                try
                {
                    ex.ToString();
                    ts.Dispose();
                }
                catch (Exception ex2)
                {
                    ts.Dispose();
                    ex2.ToString();
                }
            }
        }
    }

    protected void RequestsGV_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {
        try
        {
            Merchants.ApproveNPORequest(User.Identity.Name, int.Parse(RequestsGV.SelectedDataKey.Value.ToString()));
            BindData();
        }
        catch (Exception ex)
        {
            ErrorLabel.Text = "Something went wrong. We're sorry, but the request wasn't approved. Please contact our help desk, and retain this error message: " + ex.Message;
        }
    }

    protected void SearchButton_Click(object sender, EventArgs e)
    {
        //string city = "", province = "", name = "";
        //name = NameTextBox.Text.Trim();

        //string cityValue = CityTextBox.Text.Trim();

        //try
        //{
        //    city = cityValue.Split(new char[] { ',' })[0].Trim();
        //    province = cityValue.Split(new char[] { ',' })[1].Trim();
        //}
        //catch (Exception ex)
        //{
        //    ErrorLabel.Text = "There was a problem retrieving your selected city. Please choose one from the autocomplete list.";
        //    ex.ToString();
        //}

        //if (city == "")
        //    if (name == "")
        //        BindData();
        //    else
        //        BindData(name);
        //else
        //    if (name == "")
        //        BindData(city, province);
        //    else
        //        BindData(city, province, name);
    }

    protected void NPOGV_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {
        int NPOID = int.Parse(NPOGV.DataKeys[e.NewSelectedIndex].Value.ToString());

        Merchant merch = SysDatamk.Merchant_GetByUsername(User.Identity.Name);
        NPO npo = SysData.NPO_Get(NPOID);

        MailMessage mm = new MailMessage();
        mm.IsBodyHtml = true;

        if (NPOSettings.Get(NPOID).AutoAcceptMerchantRequests)
        {
            try
            {
                SysData.AddPartnership(SysDatamk.Merchant_GetByUsername(User.Identity.Name).MerchantID, NPOID);

                mm.To.Add(npo.Email);
                mm.Subject = "C4G: " + merch.Name + " Has Partnered with You!";
                mm.Body = @"
                            <style type='text/css'>
                                h1, a, p {
                                    font-family: Corbel, Arial, sans-serif;
                                }
                            </style>
                            <p>Congratulations! Our merchant partner '" + merch.Name + @"' has partnered with you to offer great deals!</p>
                            <p>If you have any questions, contact us at <a href='mailto:team@coupons4giving.ca'>team@coupons4giving.ca</a></p>
                            <p>Cheers!</p>
                            <p>The Coupons4Giving Team</p>
                           ";

                ErrorLabel.Text = "Congratulations! You are now partnered with that NPO!";
            }
            catch (Exception ex)
            {
                ErrorLabel.Text = "Something went wrong. Your partnership was not created. Please use the Contact Us button above, and retain this error message: " + ex.Message;
            }
        }
        else
        {
            try
            {
                SysData.NPO_InsertMerchantPartner(npo.NPOID, User.Identity.Name);
                mm.To.Add(npo.Email);

                //Add to db record, send email request to merchant
                string request = String.Format("mid={0}&npoid={1}", merch.MerchantID, npo.NPOID);
                request = CouponsForGiving.EncryptionUtils.Encrypt(request);

                mm.Subject = String.Format("C4G: New Request from {0}", merch.Name);
                mm.Body = @"
                            <style type='text/css'>
                                h1, a, p {
                                    font-family: Corbel, Arial, sans-serif;
                                }
                            </style>
                            <h1>You have a New Request from Coupons4Giving!</h1>
                            <p>" + merch.Name + @" has requested to partner with you!</p>
                            <p><a href='https://www.coupons4giving.ca/'" + merch.Name + @">Click here</a> to view their page!</p>
                            <p><a href='https://www.coupons4giving.ca/NPO/Partners/Requests.aspx'>Click here to log in and accept the request!</a>
                            ";
                ErrorLabel.Text = "A request has been sent to that Merchant!";
            }
            catch (Exception ex)
            {
                ErrorLabel.Text = "Something's gone wrong. Your request to partner has not been submitted. Please use the contact us button above, and retain the following error message: " + ex.Message;
            }
        }

        new SmtpClient().Send(mm);
        SearchButton_Click(this, e);
    }

    [System.Web.Services.WebMethodAttribute(), System.Web.Script.Services.ScriptMethodAttribute()]
    public static string[] GetCompletionList(string prefixText, int count, string contextKey)
    {
        return (from c in SysDatamk.ListCitiesWithDivisionCode() where c.Name.ToLower().Contains(prefixText.ToLower()) select c.Name).ToArray<string>();
    }

    [System.Web.Services.WebMethodAttribute(), System.Web.Script.Services.ScriptMethodAttribute()]
    public static string[] GetCompletionList2(string prefixText, int count, string contextKey)
    {
        return (from n in NPOs.List() where n.Name.Contains(prefixText) select n.Name).ToArray<string>();
    }

}