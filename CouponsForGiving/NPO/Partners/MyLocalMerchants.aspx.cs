using CouponsForGiving;
using CouponsForGiving.Data;
using CouponsForGiving.Data.Classes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class NPO_Partners_MyLocalMerchants : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Controls_MenuBar control = (Controls_MenuBar)Master.FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.NPO;

        if (!IsPostBack)
            BindData();
    }

    private void BindData()
    {
        LocalMerchantsGV.DataSource = 
            (
                from m
                in SysData.ListLocalPartnersByNPO(User.Identity.Name) 
                select new
                { 
                    m.MerchantID, m.LargeLogo, m.Name, 
                    City = m.MerchantLocations.FirstOrDefault<MerchantLocation>().City.Name,
                    Province = (m.MerchantLocations.FirstOrDefault<MerchantLocation>().City.PoliticalDivision == null) ? "" : m.MerchantLocations.FirstOrDefault<MerchantLocation>().City.PoliticalDivision.Name,
                    Offers = m.Deals.Count
                }
            );
        LocalMerchantsGV.DataBind();
        ErrorLabel.Text = "";
    }

    protected void LocalMerchantsGV_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        try
        {
            Merchants.RemoveNPOPartner(User.Identity.Name, int.Parse(e.Keys[0].ToString()));
            BindData();
        }
        catch (Exception ex)
        {
            ErrorLabel.Text = ex.Message;
        }
    }
}