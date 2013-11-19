using CouponsForGiving;
using CouponsForGiving.Data;
using CouponsForGiving.Data.Classes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Merchant_MyPartners_MyPartners : System.Web.UI.Page
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

    private void BindData()
    {
        List<NPO> npos = NPOs.ListPartnersByMerchant(User.Identity.Name);
        NPOGV.DataSource =
            (
                from n
                in npos
                select new
                {
                    Name = n.Name,
                    City = n.City.Name,
                    Province = n.City.PoliticalDivision.Name,
                    NoOfCampaigns = (from c in n.Campaigns where c.CampaignStatusID == 2 select c).Count()
                }
            );
        NPOGV.DataBind();
        ErrorLabel.Text = "";
    }

    protected void NPOGV_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        try
        {
            SysData.RemovePartnership(SysDatamk.Merchant_GetByUsername(User.Identity.Name).MerchantID,
                int.Parse(e.Keys[0].ToString()));

            BindData();
        }
        catch (Exception ex)
        {
            ErrorLabel.Text = "Something went wrong! The partnership wasn't removed. Please use the Contact Us button above and retain the following error message: " + ex.Message;
        }
    }
}