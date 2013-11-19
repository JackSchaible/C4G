using CouponsForGiving;
using CouponsForGiving.Data;
using CouponsForGiving.Data.Classes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class NPO_Campaigns_MyCampaigns : System.Web.UI.Page
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
        List<Campaign> incomplete = Campaigns.ListInactiveByUsername(User.Identity.Name);

        if (incomplete.Count > 0)
        {
            IncompleteCampaignsPanel.Enabled = true;
            IncompleteCampaignsPanel.Visible = true;
            IncompleteCampaignsGV.DataSource = incomplete;
        }
        else
        {
            IncompleteCampaignsPanel.Enabled = false;
            IncompleteCampaignsPanel.Visible = false;
        }

        CurrentCampaignsGV.DataSource = Campaigns.ListActiveByUsername(User.Identity.Name);

        IncompleteCampaignsGV.DataBind();
        CurrentCampaignsGV.DataBind();
    }
}