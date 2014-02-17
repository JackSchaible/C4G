using CouponsForGiving;
using CouponsForGiving.Data;
using CouponsForGiving.Data.Classes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Merchant_Locations_Default : System.Web.UI.Page
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

    void BindData()
    {
        List<MerchantLocation> locations = MerchantLocations.ListByMerchant(User.Identity.Name);

        LocationsGV.DataSource =
        (
            from l
            in locations
            where l.StatusID == 2
            select new
            {
                l.MerchantLocationID,
                LocationDescription = l.LocationDescription.Length > 100 ? l.LocationDescription.Substring(0, 97) + "..." : l.LocationDescription,
                l.cAddress,
                l.PhoneNumber,
                City = l.City.Name + ", " + l.City.PoliticalDivision.DivisionCode + ", " + l.City.CountryCode,
                l.PostalCode
            }
        );
        LocationsGV.DataBind();

        InactiveLocationsGV.DataSource =
        (
            from l
            in locations
            where l.StatusID == 3
            select new
            {
                l.MerchantLocationID,
                LocationDescription = l.LocationDescription.Length > 100 ? l.LocationDescription.Substring(0, 97) + "..." : l.LocationDescription,
                l.cAddress,
                l.PhoneNumber,
                City = l.City.Name + ", " + l.City.PoliticalDivision.DivisionCode + ", " + l.City.CountryCode,
                l.PostalCode
            }
        );
        InactiveLocationsGV.DataBind();
    }

    protected void LocationsGV_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {
        if ((LocationsGV.Rows[e.NewSelectedIndex].Cells[2].FindControl("Label1") as Label).Text == "Default Address")
        {
            DeletePanel.Visible = true;
            MLID.Value = LocationsGV.DataKeys[e.NewSelectedIndex].Value.ToString();
        }
        else
        {
            MerchantLocations.Deactivate(int.Parse(LocationsGV.DataKeys[e.NewSelectedIndex].Value.ToString()));
            BindData();
        }
    }

    protected void InactiveLocationsGV_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {
        MerchantLocations.Activate(int.Parse(InactiveLocationsGV.DataKeys[e.NewSelectedIndex].Value.ToString()));
        BindData();
    }

    protected void ButtonClick(object sender, EventArgs e)
    {
        string button = ((Button)sender).Text;

        if (button == "Yes")
        {
            MerchantLocations.Deactivate(int.Parse(MLID.Value));
            BindData();
        }

        DeletePanel.Visible = false;
    }
}