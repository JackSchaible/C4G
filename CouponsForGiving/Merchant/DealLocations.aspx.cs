using CouponsForGiving;
using CouponsForGiving.Data;
using CouponsForGiving.Data.Classes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Merchant_DealLocations_Add : System.Web.UI.Page
{
    public Merchant merchant;
    public DealInstance deal;

    protected void Page_Load(object sender, EventArgs e)
    {
        Controls_MenuBar control = (Controls_MenuBar)Master.FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.Merchant;
        
        if (Request.QueryString["diid"] == null)
            Response.Redirect("Result.aspx?q=1", true);

        merchant = Merchants.GetByUsername(User.Identity.Name);
        deal = DealInstances.Get(int.Parse(Request.QueryString["diid"]));

        if (deal == null)
            Response.Redirect("Result.aspx?q=3");

        if ((merchant.Deals.Where(x => x.DealID == deal.DealID).Count() == 0))
            Response.Redirect("Result.aspx?q=2");

        if (!IsPostBack)
            BindData();
    }

    private void BindData()
    {
        if (merchant.MerchantLocations.Where(x => x.StatusID == 2).Count() == 0)
            DealLocationsPanel.Visible = false;
        else
        {
            DealLocationsPanel.Visible = true;
            List<MerchantLocation> locations = MerchantLocations.ListByMerchant(User.Identity.Name);

            LocationsGV.DataSource =
            (
                from l
                in locations
                where l.StatusID == 2 && !deal.Deal.MerchantLocations.Any(ml => ml.MerchantLocationID == l.MerchantLocationID)
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

            CurrentLocationsGV.DataSource =
            (
                from l
                in deal.Deal.MerchantLocations
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
            CurrentLocationsGV.DataBind();
        }
    }

    protected void AddAllButton_Click(object sender, EventArgs e)
    {
        foreach (GridViewRow item in LocationsGV.Rows)
        {
            try
            {
                MerchantLocations.AddToDeal(int.Parse(LocationsGV.DataKeys[item.RowIndex].Value.ToString()), deal.DealID);
            }
            catch
            {
                ErrorLabel.Text = "Something went wrong and we were unable to add one or all of your merchant locations to this deal.";
            }
        }

        BindData();
    }

    protected void RemoveAllButton_Click(object sender, EventArgs e)
    {
        foreach (GridViewRow item in CurrentLocationsGV.Rows)
        {
            try
            {
                MerchantLocations.RemoveFromDeal(int.Parse(CurrentLocationsGV.DataKeys[item.RowIndex].Value.ToString()), deal.DealID);
            }
            catch
            {
                ErrorLabel.Text = "Something went wrong and we were unable to remove one or all of your merchant locations from this deal.";
            }
        }

        BindData();
    }

    protected void LocationsGV_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {
        try
        {
            MerchantLocations.AddToDeal(int.Parse(LocationsGV.DataKeys[e.NewSelectedIndex].Value.ToString()), deal.DealID);
            BindData();
        }
        catch
        {
            ErrorLabel.Text = "Something went wrong and we were unable to add that merchant location to this deal.";
        }
    }

    protected void CurrentLocationsGV_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {
        try
        {
            MerchantLocations.RemoveFromDeal(int.Parse(CurrentLocationsGV.DataKeys[e.NewSelectedIndex].Value.ToString()), deal.DealID);
            BindData();
        }
        catch
        {
            ErrorLabel.Text = "Something went wrong and we were unable to remove that merchant location from this deal.";
        }
    }

    protected void ContinueButton_Click(object sender, EventArgs e)
    {
        Response.Redirect(String.Format("Offers/DealPage.aspx?merchantname={0}&deal={1}", 
            HttpUtility.UrlEncode(merchant.Name), HttpUtility.UrlEncode(deal.Deal.Name)));
    }
}