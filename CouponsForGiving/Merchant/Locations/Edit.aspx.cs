using CouponsForGiving;
using CouponsForGiving.Data;
using CouponsForGiving.Data.Classes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Merchant_Locations_Edit : System.Web.UI.Page
{
    public Merchant merchant;
    public MerchantLocation location;

    protected void Page_Load(object sender, EventArgs e)
    {
        Controls_MenuBar control = (Controls_MenuBar)Master.FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.Merchant;
        merchant = Merchants.GetByUsername(User.Identity.Name);

        if (Request.QueryString["mlid"] == null)
            Response.Redirect("Confirmation.aspx?q=2", true);

        location = MerchantLocations.Get(int.Parse(Request.QueryString["mlid"]));

        if (location.Deals.Count > 0)
        {
            EditPanel.Visible = false;
            LockedPanel.Visible = true;
        }
        else
        {
            EditPanel.Visible = true;
            LockedPanel.Visible = false;
            if (!IsPostBack)
            {
                CountryDDL.DataSource = Countries.List().OrderBy(x => x.Name);
                CountryDDL.DataBind();

                PDDDL.DataSource = Provinces.List(CountryDDL.SelectedValue).OrderBy(x => x.Name);
                PDDDL.DataBind();

                CityDDL.DataSource = Cities.ListByProvince(int.Parse(PDDDL.SelectedValue)).OrderBy(x => x.Name);
                CityDDL.DataBind();

                BindData();
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
    }

    private void BindData()
    {
        CountryDDL.DataSource = Countries.List().OrderBy(x => x.Name);
        CountryDDL.DataBind();
        CountryDDL.Items.FindByValue(location.City.CountryCode).Selected = true;

        PDDDL.DataSource = Provinces.List(CountryDDL.SelectedValue).OrderBy(x => x.Name);
        PDDDL.DataBind();
        PDDDL.Items.FindByValue(location.City.PoliticalDivisionID.ToString()).Selected = true;

        CityDDL.DataSource = Cities.ListByProvince(int.Parse(PDDDL.SelectedValue)).OrderBy(x => x.Name);
        CityDDL.DataBind();
        CityDDL.Items.FindByValue(location.City.CityID.ToString()).Selected = true;

        DescriptionTextBox.Text = location.LocationDescription;
        AddressTextBox.Text = location.cAddress;
        PostalCodeTextBox.Text = location.PostalCode;
        PhoneNumberTextBox.Text = location.PhoneNumber;
    }

    protected void SubmitButton_Click(object sender, EventArgs e)
    {
        int merchantLocationID = location.MerchantLocationID;
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

                MerchantLocations.Update(merchantLocationID, User.Identity.Name, description, address, phoneNumber, cityID, postal);

                Response.Redirect("Confirmation.aspx?q=4");
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
                MerchantLocations.Update(merchantLocationID, User.Identity.Name, description, address, phoneNumber, cityID, postal);

                Response.Redirect("Confirmation.aspx?q=4");
            }
            catch (Exception ex)
            {
                ErrorLabel.Text = "Something went wrong and your merchant location was not saved.";
                ex.ToString();
            }
        }
    }

    protected void DeactivateButton_Click(object sender, EventArgs e)
    {
        try
        {
            MerchantLocations.Deactivate(location.MerchantLocationID);
            Response.Redirect("Confirmation.aspx?q=3");
        }
        catch (Exception ex)
        {
            ErrorLabel.Text = "Something went wrong and we were unable to deactivate your merchant location.";
            ex.ToString();
        }
    }
}