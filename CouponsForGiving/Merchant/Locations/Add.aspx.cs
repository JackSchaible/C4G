using CouponsForGiving;
using CouponsForGiving.Data;
using CouponsForGiving.Data.Classes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Merchant_Locations_Add : System.Web.UI.Page
{
    public Merchant merchant;

    protected void Page_Load(object sender, EventArgs e)
    {
        Controls_MenuBar control = (Controls_MenuBar)Master.FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.Merchant;
        merchant = Merchants.GetByUsername(User.Identity.Name);

        if (!IsPostBack)
        {
            CountryDDL.DataSource = Countries.List().OrderBy(x => x.Name);
            CountryDDL.DataBind();

            PDDDL.DataSource = Provinces.List(CountryDDL.SelectedValue).OrderBy(x => x.Name);
            PDDDL.DataBind();

            CityDDL.DataSource = Cities.ListByProvince(int.Parse(PDDDL.SelectedValue)).OrderBy(x => x.Name);
            CityDDL.DataBind();
        }
        else
        {
            if (Request.Form["__EVENTTARGET"].EndsWith("CountryDDL"))
            {
                PDDDL.DataSource = Provinces.List(CountryDDL.SelectedValue).OrderBy(x => x.Name);
                PDDDL.DataBind();

                CityDDL.DataSource = Cities.ListByProvince(int.Parse(PDDDL.SelectedValue)).OrderBy(x => x.Name);
                CityDDL.DataBind();
            }
            else if (Request.Form["__EVENTTARGET"].EndsWith("PDDDL"))
            {
                CityDDL.DataSource = Cities.ListByProvince(int.Parse(PDDDL.SelectedValue)).OrderBy(x => x.Name);
                CityDDL.DataBind();
            }
        }
    }

    protected void SubmitButton_Click(object sender, EventArgs e)
    {
        int cityID = int.Parse(CityDDL.SelectedValue);
        string description = DescriptionTextBox.Text.Trim();
        string address = AddressTextBox.Text.Trim();
        string postal = PostalCodeTextBox.Text.Trim();
        string phoneNumber = PhoneNumberTextBox.Text.Trim();

        if (merchant.MerchantLocations.Count == 0)
        {
            try
            {
                MerchantLocations.Insert(User.Identity.Name, "Default Address", merchant.cAddress, merchant.PhoneNumber, merchant.CityID,
                    merchant.PostalCode);

                MerchantLocations.Insert(User.Identity.Name, description, address, phoneNumber, cityID, postal);

                Response.Redirect("Confirmation.aspx?q=1");
            }
            catch (Exception ex)
            {
                ErrorLabel.Text = "Something went wrong and your merchant location was not saved.";
                ex.ToString();
            }
        }
        else
        {
            try
            {
                MerchantLocations.Insert(User.Identity.Name, description, address, phoneNumber, cityID, postal);

                Response.Redirect("Confirmation.aspx?q=1");
            }
            catch (Exception ex)
            {
                ErrorLabel.Text = "Something went wrong and your merchant location was not saved.";
                ex.ToString();
            }
        }
    }
}