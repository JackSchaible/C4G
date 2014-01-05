﻿using CouponsForGiving.Data;
using CouponsForGiving.Data.Classes;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Web;
using System.Web.Configuration;
using System.Web.Script.Serialization;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class OpenAuth_Stripe : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["code"] == null)
        {
            try
            {
                NotificationcUsers.Insert(String.Format("StripeNotConnected({0})", WebConfigurationManager.AppSettings["Language"]), User.Identity.Name);
            }
            catch (Exception ex)
            {
                ex.ToString();
            }
        }
        else
        {
            try
            {
                Merchant merch = SysDatamk.Merchant_GetByUsername(HttpContext.Current.User.Identity.Name);

                if (merch == null)
                    ErrorLabel.Text = "There was no merchant account found with your username: " + HttpContext.Current.User.Identity.Name;
                else
                {
                    string postData = (String.Format("client_secret={0}&grant_type={1}&code={2}", WebConfigurationManager.AppSettings["StripeApiKey"], "authorization_code", Request.QueryString["Code"]));

                    // create the POST request
                    HttpWebRequest webRequest = (HttpWebRequest)WebRequest.Create("https://connect.stripe.com/oauth/token");
                    webRequest.Method = "POST";
                    webRequest.ContentType = "application/x-www-form-urlencoded";
                    webRequest.ContentLength = postData.Length;

                    // POST the data
                    using (StreamWriter requestWriter2 = new StreamWriter(webRequest.GetRequestStream()))
                    {
                        requestWriter2.Write(postData);
                    }

                    //  This actually does the request and gets the response back
                    HttpWebResponse resp = (HttpWebResponse)webRequest.GetResponse();

                    string responseData = string.Empty;

                    using (StreamReader responseReader = new StreamReader(webRequest.GetResponse().GetResponseStream()))
                    {
                        // dumps the HTML from the response into a string variable
                        responseData = responseReader.ReadToEnd();
                    }

                    var jss = new JavaScriptSerializer();
                    dynamic data = jss.Deserialize<dynamic>(responseData);
                    string value = ((Dictionary<string, object>)data)["access_token"].ToString();

               
                    SysData.MerchantStripeInfo_Insert(merch.MerchantID, value);
                    Roles.AddUserToRole(HttpContext.Current.User.Identity.Name, "Merchant");
                    Roles.RemoveUserFromRole(User.Identity.Name, "IncompleteMerchant");
                    MailMessage mm = new MailMessage();
                    mm.To.Add(new MailAddress(Membership.GetUser().Email));

                    mm.Subject = "C4G: Your New Account";
                    mm.IsBodyHtml = true;
                    mm.Body = @"
                            <style type='text/css'>
                                h1, a, p {
                                    font-family: Corbel, Arial, sans-serif;
                                }
                            </style>
                            <p>Congratulations! You have just set up your Coupons4Giving Profile page. Now you can get started and set up your offers. A team member will be in touch with you shortly with some tips on how to get started. In the meantime, if you have any questions, please contact us at <a href='mailto:teamc4g@coupons4giving.ca'>teamc4g@coupons4giving.ca</a>.</p>
                            <p>Your unique Coupons4Giving company profile page is <a href='https://www.coupons4giving.ca/" + merch.Name + @"'>www.coupons4giving.ca/" + merch.Name + @"</a></p>
                            <p>Click <a href='https://www.couponsforgiving.ca/Merchant/Deals/New.aspx'>here</a> to set up an offer.</p>
                            <p>Cheers!</p>
                            <p>The Coupons4Giving.ca Team</p>
                            ";

                    SmtpClient client = new SmtpClient();
                    client.Send(mm);
                    Response.Redirect("../Merchant/Confirmation.aspx", false);
                }
            }
            catch (Exception ex)
            {
                NotificationcUsers.Insert(String.Format("StripeNotConnected({0})", WebConfigurationManager.AppSettings["Language"]), User.Identity.Name);
                ex.ToString();
            }
        }
    }
}