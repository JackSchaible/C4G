using CouponsForGiving.Data;
using CouponsForGiving.Data.Classes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Controls_LocationGV : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            BindData();
    }

    private void BindData()
    {
        List<Country> countries = Countries.List();
        List<PoliticalDivision> provinces = Provinces.List(countries.FirstOrDefault<Country>().Name);

        CountriesDDL.DataSource = countries;
        CountriesDDL.DataBind();

        ProvinceDDL.DataSource = provinces;
        ProvinceDDL.DataBind();

        CitiesGV.DataSource = provinces.FirstOrDefault<PoliticalDivision>().Cities;
        CitiesGV.DataBind();
    }

    protected void CountriesDDL_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
}