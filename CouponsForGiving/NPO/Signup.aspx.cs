using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Drawing;
using CouponsForGiving.Data;
using System.IO;
using System.Web.Security;
using CouponsForGiving;
using System.Transactions;
using System.Text;
using System.Net.Mail;
using CouponsForGiving.Data.Classes;

public partial class NPO_newNPO : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Controls_MenuBar control = (Controls_MenuBar)Master.FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.Anonymous;

        try
        {
            string thisUser = User.Identity.Name;
            if(thisUser == "")
            {
                Response.Redirect("../Account/Login.aspx", true);
            }
        }
        catch (Exception ex)
        {
            newNPOMessage.Text = ex.ToString();
            newNPOMessage.ForeColor = Color.Red;
        }
    }

    protected void newNPOSubmit_Click(object sender, EventArgs e)
    {
        if (TermsCheckbox.Checked)
        {
            try
            {
                bool valid = true;

                string newName = newNPOName.Text.Trim();
                string newLogo = newNPOLogo.FileName.ToString();
                string newAddress = newNPOAddress.Text.Trim();
                string cityValue = CityTextBox.Text.Trim();
                string city = "", province = "", country = "";
                try
                {
                    city = cityValue.Split(new char[] { ',' })[0].Trim();
                    province = cityValue.Split(new char[] { ',' })[1].Trim();
                    country = cityValue.Split(new char[] { ',' })[2].Trim();
                }
                catch (Exception ex)
                {
                    newNPOMessage.Text = "There was a problem retrieving your selected city. Please choose one from the autocomplete list.";
                    ex.ToString();
                }
                string newPostalCode = newNPOPostalCode.Text.Trim().ToUpper();
                newPostalCode = newPostalCode.Replace(" ", string.Empty);
                string newPhoneNumber = newNPOPhoneNumber.Text.Trim();
                string newWebsite = newNPOWebsite.Text.Trim();
                string newDescription = newNPODescription.Text.Trim();
                string newEmail = newNPOEmail.Text.Trim();

                if (newEmail == "")
                    newEmail = Membership.GetUser().Email;

                string newURL = newName;

                if ((newName == "") || (newLogo == "") || (newAddress == "") || (newPostalCode == "") || (newPhoneNumber == "") || (newWebsite == "") || (newDescription == "") || (newEmail == "") || (newURL == ""))
                {
                    valid = false;
                    newNPOMessage.Text = "All fields are required.";
                    newNPOMessage.ForeColor = Color.Red;
                }

                int urlunique = SysDatamk.IsURLUnique(newURL);

                if (urlunique != 1)
                {
                    valid = false;
                    newNPOMessage.Text = "We're sorry, but somebody else is using that name. Please select another (this is used for your unique Coupons4Giving URL.";
                    newNPOMessage.ForeColor = Color.Red;
                }

                if (!(Utilsmk.ValidUrl(newWebsite)))
                {
                    valid = false;
                    newNPOMessage.Text = "Website invalid. (Ex. 'www.website.com')";
                    newNPOMessage.ForeColor = Color.Red;
                }
                else
                    newWebsite = "http://" + newWebsite;

                if (!(Utilsmk.ValidPostal(newPostalCode)))
                {
                    valid = false;
                    newNPOMessage.Text = "Postal / Zip Code invalid. (Ex. '90210', '90210-1234' or 'T6L2M9')";
                    newNPOMessage.ForeColor = Color.Red;
                }

                if (!(Utilsmk.ValidPhone(newPhoneNumber)))
                {
                    valid = false;
                    newNPOMessage.Text = "Please enter a valid, 10-digit phone number. (ex. 7809980120)";
                    newNPOMessage.ForeColor = Color.Red;
                }

                if (!(Utilsmk.ValidEmail(newEmail)))
                {
                    valid = false;
                    newNPOMessage.Text = "EMail invalid. (Ex. 'name@mail.com')";
                    newNPOMessage.ForeColor = Color.Red;
                }

                if (newNPOLogo.HasFile)
                {
                    if (!(Utilsmk.ValidImage(newNPOLogo.PostedFile.InputStream)))
                    {
                        valid = false;
                        newNPOMessage.Text = "Logo is not a valid image file type. (Ex. .png, .jpeg, .png, .gif)";
                        newNPOMessage.ForeColor = Color.Red;
                    }
                }

                if ((newNPOLogo.HasFile) && valid)
                {
                    if (!(Utilsmk.ValidLogoSize(newNPOLogo.PostedFile.ContentLength)))
                    {
                        valid = false;
                        newNPOMessage.Text = "Logo file size must be less than 4MB.";
                        newNPOMessage.ForeColor = Color.Red;
                    }
                }

                if (User.Identity.Name == "")
                {
                    valid = false;
                    newNPOMessage.Text = "No User Logged in.";
                    newNPOMessage.ForeColor = Color.Red;
                }

                if (valid)
                {
                    try
                    {
                        string tempLogo = "temp";
                        int newStatusID = 2;
                        int newNPOID = -1;
                        string thisusername = User.Identity.Name;
                        bool useall = true;

                        using (TransactionScope ts = new TransactionScope())
                        {
                            try
                            {
                                City dbCity = Cities.GetByName(city, province, country);

                                if (dbCity == null)
                                    newNPOMessage.Text = "The selected city does not exist. Please choose one from the autocomplete menu that drops down.";
                                else
                                {
                                    newNPOID = SysDatamk.AddNPO(newName, newDescription, newAddress, dbCity.CityID, newPostalCode, newWebsite, newPhoneNumber, newEmail, newStatusID, tempLogo, newURL, useall);
                                    if (newNPOID > -1)
                                    {
                                        newLogo = Utilsmk.SaveNewLogo(newNPOLogo.PostedFile, newNPOID, Server, "NPO");
                                        string virtualPath = newLogo.Replace(Request.ServerVariables["APPL_PHYSICAL_PATH"], String.Empty);
                                        SysDatamk.UpdateNPO(newNPOID, newName, newDescription, newAddress, dbCity.CityID, newPostalCode, newWebsite, newPhoneNumber, newEmail, newStatusID, virtualPath, newURL, useall);
                                        SysDatamk.NPOcUser_Insert(thisusername, newNPOID);
                                        ts.Complete();

                                        clearForm();
                                        newNPOMessage.Text = "Success! NPO has been submitted for approval.";
                                        newNPOMessage.ForeColor = Color.DarkGreen;
                                    }
                                    else
                                    {
                                        newNPOMessage.Text = "Error! NPO was not submitted.";
                                        newNPOMessage.ForeColor = Color.Red;
                                        ts.Dispose();
                                    }
                                }
                            }
                            catch (Exception ex)
                            {
                                newNPOMessage.Text = ex.ToString();
                                newNPOMessage.ForeColor = Color.Red;
                                ts.Dispose();
                            }
                        }

                        if (newNPOID > -1)
                        {
                            if (!User.IsInRole("NPO"))
                            {
                                Roles.AddUserToRole(thisusername, "NPO");
                            }

                            string name = User.Identity.Name;
                            string org = newName;
                            string email = Membership.GetUser(name).Email;

                            MailMessage mm = new MailMessage();

                            mm.To.Add(new MailAddress(email));

                            mm.Subject = "C4G: Your New Profile";
                            mm.IsBodyHtml = true;
                            mm.Body = @"
                                   <style type='text/css'>
                                        h1, a, p {
                                            font-family: Corbel, Arial, sans-serif;
                                        }
                                    </style>
                                    <p>Congratulations! You have just set up your Coupons4Giving Profile page. Now you can get started and set up your campaigns. A team member will be in touch shortly with some tips on how to get started! In the meantime if you have any questions, please contact us at <a href='mailto:teamc4g@coupons4giving.ca'>teamc4g@coupons4giving.ca</a>.</p>
                                    <p>Your unique Coupons4Giving profile page is <a href='https://www.coupons4giving.ca/" + name + @"'>www.coupons4giving.ca/" + newName + @"</a><p>
                                    <p><a href='https://www.coupons4giving.ca/NPO/Campaigns/New.aspx'>Click here</a> to set up a campaign!</p>
                                    <p>Cheers!</p>
                                    <p>The Coupons4Giving Team</p>
                                   ";

                            SmtpClient client = new SmtpClient();
                            client.Send(mm);

                            Response.Redirect("Confirmation.aspx");
                        }

                    }
                    catch (Exception ex)
                    {
                        newNPOMessage.Text = ex.ToString();
                        newNPOMessage.ForeColor = Color.Red;
                    }
                }
            }
            catch (Exception ex)
            {
                newNPOMessage.Text = ex.ToString();
                newNPOMessage.ForeColor = Color.Red;
            }
        }
        else
            newNPOMessage.Text = "You must read and agree to the Terms & Conditions.";
    }

    protected void clearForm()
    {
        newNPOName.Text = "";
        newNPOLogo = new FileUpload();
        newNPOAddress.Text = "";
        CityTextBox.Text = "";
        newNPOPostalCode.Text = "";
        newNPOPhoneNumber.Text = "";
        newNPOWebsite.Text = "";
        newNPOMessage.Text = "";
        newNPODescription.Text = "";
        newNPOEmail.Text = "";
    }

    protected void newNPOClear_Click(object sender, EventArgs e)
    {
        clearForm();
    }

    [System.Web.Services.WebMethodAttribute(), System.Web.Script.Services.ScriptMethodAttribute()]
    public static string[] GetCompletionList(string prefixText, int count, string contextKey)
    {
        string[] result;

        result = (from c in SysDatamk.ListCitiesWithDivisionCode() where c.Name.ToLower().Contains(prefixText.ToLower()) select c.Name).ToArray<string>();

        return result;
    }
}