using CouponsForGiving;
using CouponsForGiving.Data;
using CouponsForGiving.Data.Classes;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Merchant_Edit : System.Web.UI.Page
{
    public Merchant merchant;

    protected void Page_Load(object sender, EventArgs e)
    {
        Controls_MenuBar control = (Controls_MenuBar)Master.FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.Merchant;
        merchant = Merchants.GetByUsername(User.Identity.Name);

        if (!IsPostBack)
            BindData();

        ProfileImage.ImageUrl = ImageURL.Value;
    }

    private void BindData()
    {
        City city = Cities.Get(merchant.CityID);
        CountryDDL.DataSource = Countries.List().OrderBy(x => x.Name);
        CountryDDL.DataBind();
        CountryDDL.Items.FindByValue(city.CountryCode).Selected = true;

        PDDDL.DataSource = Provinces.List(CountryDDL.SelectedValue).OrderBy(x => x.Name);
        PDDDL.DataBind();
        PDDDL.Items.FindByValue(city.PoliticalDivisionID.ToString()).Selected = true;

        CityDDL.DataSource = Cities.ListByProvince(int.Parse(PDDDL.SelectedValue)).OrderBy(x => x.Name);
        CityDDL.DataBind();
        CityDDL.Items.FindByValue(city.CityID.ToString()).Selected = true;

        NameTextBox.Text = merchant.Name;
        AddressTextBox.Text = merchant.cAddress;
        PostalTextBox.Text = merchant.PostalCode;
        PhoneNumberTextBox.Text = merchant.PhoneNumber;
        WebsiteTextBox.Text = merchant.Website;
        EmailTextBox.Text = merchant.Email;
        ImageURL.Value = "../" + merchant.LargeLogo;
    }

    protected void SubmitButton_Click(object sender, EventArgs e)
    {
        string name = NameTextBox.Text.Trim();
        string address = AddressTextBox.Text.Trim();
        string postalCode = PostalTextBox.Text.Trim();
        string phoneNumber = PhoneNumberTextBox.Text.Trim();
        string website = WebsiteTextBox.Text.Trim();
        string email = EmailTextBox.Text.Trim();
        string image = ImageURL.Value;
        int cityid = int.Parse(CityDDL.SelectedValue);
        string logoPath = "";

        try
        {
            if (image.Contains("tmp"))
            {
                DirectoryInfo root = new DirectoryInfo(Server.MapPath("~/tmp/Images/Signup"));
                FileInfo[] listFiles = root.GetFiles(User.Identity.Name + "logo.*");
                logoPath = HttpContext.Current.Server.MapPath("..\\Images\\Merchant\\" + name);
                logoPath = Utilsmk.GetOrCreateFolder(logoPath) + "\\" + listFiles[0].Name;
                listFiles[0].MoveTo(logoPath);
                logoPath = logoPath.Replace(HttpContext.Current.Request.ServerVariables["APPL_PHYSICAL_PATH"], String.Empty);
                ImageURL.Value = logoPath;
            }
        }
        catch (Exception ex)
        {
            ex.ToString();
            ErrorLabel.Text = "Something went wrong and your profile image was not saved.";
        }

        try
        {
            SysDatamk.UpdateMerchant(merchant.MerchantID, name, logoPath, logoPath, address, cityid, postalCode,
                phoneNumber, website, 2);
            Response.Redirect("Result.aspx?q=4");
        }
        catch (Exception ex)
        {
            ErrorLabel.Text = "Something went wrong and the changes to your profile have not been saved.";
            ex.ToString();
        }
    }
}