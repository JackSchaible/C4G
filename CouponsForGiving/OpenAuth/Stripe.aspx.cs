using CouponsForGiving;
using CouponsForGiving.Data;
using CouponsForGiving.Data.Classes;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
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
                NotificationcUsers.Insert(String.Format("StripeNotConnected({0})",
                    WebConfigurationManager.AppSettings["Language"]), Request["state"]);
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
                Merchant merch = null;

                if (User.Identity.IsAuthenticated)
                    merch = SysDatamk.Merchant_GetByUsername(User.Identity.Name);
                else
                    ErrorLabel.Text = "User is not logged in.";

                if (merch == null)
                    ErrorLabel.Text = "There was no merchant account found with your username: " + User.Identity.Name;
                else
                {
                    string postData = (String.Format("client_secret={0}&grant_type={1}&code={2}", 
                        WebConfigurationManager.AppSettings["StripeApiKey"], 
                        "authorization_code", Request.QueryString["Code"]));

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

                    string Name = User.Identity.Name;
                    SysData.MerchantStripeInfo_Insert(merch.MerchantID, value);

                    if (!Roles.IsUserInRole(Name, "Merchant"))
                        Roles.AddUserToRole(Name, "Merchant");

                    if (Roles.IsUserInRole(Name, "IncompleteMerchant"))
                        Roles.RemoveUserFromRole(Name, "IncompleteMerchant");

                    List<string> To = new List<string>();
                    To.Add(Membership.GetUser(Name).Email);

                    NotificationcUsers.Delete(String.Format("StripeNotConnected({0})", WebConfigurationManager.AppSettings["Language"]), Name);
                    EmailUtils.SendMerchantSignupEmail(To, Name, merch.Name);

                    Response.Redirect("../Merchant/MyHome.aspx");
                }
            }
            catch (Exception ex)
            {
                try
                {
                    Response.Write(ex.Message);
                    NotificationcUsers.Insert(String.Format("StripeNotConnected({0})", WebConfigurationManager.AppSettings["Language"]), User.Identity.Name);
                }
                catch (Exception ex2)
                {
                    ex2.ToString();
                }

                ex.ToString();
            }
        }
    }
}