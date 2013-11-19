using CouponsForGiving;
using CouponsForGiving.Data;
using CouponsForGiving.Data.Classes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class NPO_Partners_AllPartners : System.Web.UI.Page
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
        PartnersGV.DataSource =
            (
                from m
                in Merchants.ListPartnersByNPO(User.Identity.Name)
                select new
                {
                    m.MerchantID,
                    m.Name,
                    m.SmallLogo,
                    Offers = m.Deals.Count()
                }
            );
        PartnersGV.DataBind();
        ErrorLabel.Text = "";
    }

    protected void PartnersGV_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        try
        {
            Merchants.RemoveNPOPartner(User.Identity.Name, int.Parse(e.Keys[0].ToString()));
        }
        catch (Exception ex)
        {
            ErrorLabel.Text = ex.Message;
        }
    }

}