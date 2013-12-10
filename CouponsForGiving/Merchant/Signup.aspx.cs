using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using CouponsForGiving;
using CouponsForGiving.Data;
using System.Transactions;
using System.Text;
using System.Net.Mail;
using System.IO;
using CouponsForGiving.Data.Classes;

public partial class Merchant_Signup : System.Web.UI.Page
{
    public bool hasLargeLogo { get; set; }
    public bool hasSmallLogo { get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        Controls_MenuBar control = (Controls_MenuBar)Master.FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.Anonymous;

        try
        {
            string thisUser = User.Identity.Name;
            if (thisUser == "")
            {
                Response.Redirect("../Account/Login.aspx", true);
            }
        }
        catch (Exception ex)
        {
            newMerchantMessage.Text = ex.ToString();
        }

        hasLargeLogo = false;
        hasSmallLogo = false;

        if (newMerchantLargeLogo.HasFile)
        {
            HttpPostedFile file = newMerchantLargeLogo.PostedFile;
            string folderPath = Server.MapPath("..\\tmp\\Images\\Signup\\");
            string fileName = User.Identity.Name + "--" + file.FileName;

            string physPath = folderPath + @"\" + fileName;

            file.SaveAs(physPath);
            Session["LargeLogoPath"] = folderPath;
            Session["LargeLogoFileName"] = fileName;
        }

        if (Session["LargeLogoPath"] != null)
            hasLargeLogo = true;

        if (Session["SmallLogoPath"] != null)
            hasSmallLogo = true;
    }

    protected void SubmitButton_Click(object sender, EventArgs e)
    {
        if (TermsCheckBox.Checked)
        {
            string email = "", url = "", yourPhoneNumber = "", businessName = "", businessType = "", firstName = "",
                lastName = "", address = "", city = "",
                state = "", zipCode = "", physicalProduct = "", productType = "",
                country = "", currency = "", largeLogo = "", businessPhoneNumber = "";

            DateTime birthdate = BirthDate.Date;
            email = YourEmailTextBox.Text.Trim();
            url = URLTextBox.Text.Trim();
            url = (url.StartsWith("http") ? url : "http://" + url);
            yourPhoneNumber = YourPhoneNumberTextBox.Text.Trim();

            businessName = BusinessNameTextBox.Text.Trim();

            businessType = BusinessTypeDDL.SelectedValue;
            firstName = FirstNameTextBox.Text.Trim();
            lastName = LastNameTextBox.Text.Trim();
            address = AddressTextBox.Text.Trim();

            int cityID = -1;
            string cityValue = CityTextBox.Text;
            City dbCity = null;

            try
            {
                city = cityValue.Split(new char[] { ',' })[0].Trim();
                state = cityValue.Split(new char[] { ',' })[1].Trim();
                country = cityValue.Split(new char[] { ',' })[2].Trim();
                dbCity = Cities.GetByName(city, state, country);
                city = dbCity.Name;
                state = dbCity.PoliticalDivision.Name;
                country = dbCity.Country.Name;
                cityID = dbCity.CityID;

            }
            catch (Exception ex)
            {
                newMerchantMessage.Text = "There was a problem retrieving your selected city. Please choose one from the autocomplete list.";
                ex.ToString();
            }

            zipCode = ZipCodeTextBox.Text.Trim().ToUpper();
            zipCode = zipCode.Replace(" ", string.Empty);
            physicalProduct = PhysicalProductRBL.SelectedValue;
            productType = ProductTypesDDL.SelectedValue;
            currency = CurrencyRBL.SelectedValue;
            largeLogo = newMerchantLargeLogo.FileName;
            businessPhoneNumber = PhoneNumberTextBox.Text.Trim();

            string vars = String.Format("stripe_user[email]={0}&stripe_user[url]={1}&stripe_user[phone_number]={2}&stripe_user[business_name]={3}&stripe_user[business_type]={4}&stripe_user[first_name]={5}&stripe_user[last_name]={6}&stripe_user[dob_day]={7}&stripe_user[dob_month]={8}&stripe_user[dob_year]={9}&stripe_user[street_address]={10}&stripe_user[city]={11}&stripe_user[state]={12}&stripe_user[zip]={13}&stripe_user[physical_product]={14}&stripe_user[product_category]={15}&stripe_user[country]={16}&stripe_user[currency]={17}", Server.UrlEncode(email), Server.UrlEncode(url), Server.UrlEncode(businessPhoneNumber), Server.UrlEncode(businessName), Server.UrlEncode(businessType), Server.UrlEncode(firstName), Server.UrlEncode(lastName), Server.UrlEncode(birthdate.ToString("dd")), Server.UrlEncode(birthdate.ToString("MM")), Server.UrlEncode(birthdate.ToString("yyyy")), Server.UrlEncode(address), Server.UrlEncode(city), Server.UrlEncode(state), Server.UrlEncode(zipCode), Server.UrlEncode(physicalProduct), Server.UrlEncode(productType), Server.UrlEncode(country), Server.UrlEncode(currency));
            string queryString = String.Format("https://connect.stripe.com/oauth/authorize?response_type=code&client_id=ca_2dcruIQ1MEWM9BfJot2jJUPvKqJGofMU&scope=read_write&{0}", vars);

            bool valid = true;


            if (businessPhoneNumber == "")
                businessPhoneNumber = yourPhoneNumber;

            try
            {
                if ((businessName == "") || (address == "") || (zipCode == "") || (businessPhoneNumber == "") || (url == ""))
                {
                    valid = false;
                    newMerchantMessage.Text = "All fields are required.";
                }

                int urlunique = SysDatamk.IsURLUnique(businessName);

                if (urlunique != 1)
                {
                    valid = false;
                    newMerchantMessage.Text = "We're sorry, but somebody else is using that name. Please select another (this is used for your unique Coupons4Giving URL).";
                }

                if (!(Utilsmk.ValidUrl(url)))
                {
                    valid = false;
                    newMerchantMessage.Text = "Website invalid. (Ex. 'http://www.website.com')";

                }

                if (!(Utilsmk.ValidPostal(zipCode)))
                {
                    valid = false;
                    newMerchantMessage.Text = "Postal / Zip Code invalid. (Ex. '90210', '90210-1234' or 'T6L2M9')";

                }

                if (!(Utilsmk.ValidPhone(yourPhoneNumber)))
                {
                    valid = false;
                    newMerchantMessage.Text = "Please enter a valid, 10-digit phone number. (ex. 7809980120)";

                }

                if (!Utilsmk.ValidPhone(businessPhoneNumber))
                {
                    valid = false;
                    newMerchantMessage.Text = "Your phone number is not valid. (ex. 7805556677)";
                }

                if (newMerchantLargeLogo.HasFile)
                {
                    if (!(Utilsmk.ValidImage(newMerchantLargeLogo.PostedFile.InputStream)))
                    {
                        valid = false;
                        newMerchantMessage.Text = "Large Logo is not a valid image file type. (Ex. .png, .jpeg, .png, .gif)";

                    }
                }

                if ((newMerchantLargeLogo.HasFile) && valid)
                {
                    if (!(Utilsmk.ValidLogoSize(newMerchantLargeLogo.PostedFile.ContentLength)))
                    {
                        valid = false;
                        newMerchantMessage.Text = "Large Logo file size must be less than 4MB.";

                    }
                }

                if (email == "")
                    email = Membership.GetUser().Email;

                if (valid)
                {
                    try
                    {
                        string tempLogo = "temp";
                        int newStatusID = 2;
                        int newMerchantID = -1;
                        string thisusername = User.Identity.Name;

                        using (TransactionScope ts = new TransactionScope())
                        {
                            try
                            {
                                newMerchantID = SysDatamk.AddMerchant(businessName, tempLogo, tempLogo, address, cityID, zipCode, businessPhoneNumber, url, newStatusID, thisusername, email);

                                if (newMerchantID > -1)
                                {
                                    string virtualPathL = "";
                                    string virtualPathS = "";

                                    if (Session["LargeLogoPath"] != null)
                                    {
                                        string newPath = Server.MapPath("..\\Images\\NPO\\" + newMerchantID);
                                        newPath = Utilsmk.GetOrCreateFolder(newPath) + Session["LargeLogoFileName"].ToString();

                                        string oldPath = Session["LargeLogoPath"].ToString() + Session["LargeLogoFileName"].ToString();

                                        File.Move(oldPath, newPath);

                                        virtualPathL = Utilsmk.ResolveVirtualPath(newPath);
                                    }
                                    else
                                    {
                                        if (newMerchantLargeLogo.HasFile)
                                        { 
                                            largeLogo = Utilsmk.SaveNewLogo(newMerchantLargeLogo.PostedFile, newMerchantID, Server, "Merchant");
                                            virtualPathL = largeLogo.Replace(Request.ServerVariables["APPL_PHYSICAL_PATH"], String.Empty);
                                            virtualPathS = virtualPathL;
                                        }
                                        else
                                            virtualPathL = "Images/c4g_logo_temporary_profile.png";
                                    }

                                    SysDatamk.UpdateMerchant(newMerchantID, businessName, virtualPathL, virtualPathS, address, cityID, zipCode, businessPhoneNumber, url, newStatusID);
                                    SysDatamk.AddMerchantLocation(newMerchantID, address, cityID, businessPhoneNumber);
                                    SysData.MerchantInfo_Insert(User.Identity.Name, FirstNameTextBox.Text.Trim() + LastNameTextBox.Text.Trim(), yourPhoneNumber, DescriptionTextBox.Text.Trim());
                                    MerchantSettings.Insert(newMerchantID, AutoAcceptRequestsCheckBox.Checked);

                                    ts.Complete();
                                    Response.Redirect(queryString, false);
                                }
                                else
                                {
                                    newMerchantMessage.Text = "Oops! Something went wrong with the submission...";
                                    ts.Dispose();
                                }
                            }
                            catch (Exception ex)
                            {
                                newMerchantMessage.Text = ex.ToString();
                                ts.Dispose();
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        newMerchantMessage.Text = ex.ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                newMerchantMessage.Text = "Something went wrong. Please send a report to our help team, and include this message: " + ex.ToString();
            }
        }
        else
            newMerchantMessage.Text = "You must read and agree to the Terms & Conditions.";
    }

    [System.Web.Services.WebMethodAttribute(), System.Web.Script.Services.ScriptMethodAttribute()]
    public static string[] GetCompletionList(string prefixText, int count, string contextKey)
    {
        string[] result;

        result = (from c in SysDatamk.ListCitiesWithDivisionCode() where c.Name.ToLower().Contains(prefixText.ToLower()) orderby c.Name select c.Name).ToArray<string>();

        return result;
    }

}