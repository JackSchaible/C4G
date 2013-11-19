using CouponsForGiving;
using CouponsForGiving.Data;
using CouponsForGiving.Data.Classes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class NPO_Partners_MyGlobalMerchants : System.Web.UI.Page
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
        GlobalMerchantsGV.DataSource =
            (
                from m
                in SysData.ListGlobalPartnersByNPO(User.Identity.Name)
                select new
                {
                    m.MerchantID, m.Name, m.SmallLogo, Offers = m.Deals.Count()
                }
            );
        GlobalMerchantsGV.DataBind();
        ErrorLabel.Text = "";
    }

    protected void GlobalMerchantsGV_RowDeleting(object sender, GridViewDeleteEventArgs e)
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