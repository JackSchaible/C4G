using CouponsForGiving;
using CouponsForGiving.Data;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_PendingRegistrations : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Controls_MenuBar control = (Controls_MenuBar)Master.FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.Admin;
    }

    protected void ApproveAllButton_Click(object sender, EventArgs e)
    {
        try
        {
            SysData.ApproveAllPending();
        }
        catch (Exception ex)
        {
            ErrorLabel.Text = ex.Message;
            ErrorLabel.ForeColor = Color.Red;
        }
    }

    protected void ApproveAllMerchants_Click(object sender, EventArgs e)
    {
        try
        {
            SysData.Merchant_ApproveAllPending();
        }
        catch (Exception ex)
        {
            ErrorLabel.Text = ex.Message;
            ErrorLabel.ForeColor = Color.Red;
        }
    }

    protected void ApproveAllNPOs_Click(object sender, EventArgs e)
    {
        try
        {
            SysData.NPO_ApproveAllPending();
        }
        catch (Exception ex)
        {
            ErrorLabel.Text = ex.Message;
            ErrorLabel.ForeColor = Color.Red;
        }
    }

    protected void NPOGV_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {
        try
        {
            SysData.NPO_Approve(int.Parse(NPOGV.DataKeys[e.NewSelectedIndex].Value.ToString()));
        }
        catch (Exception ex)
        {
            ErrorLabel.Text = ex.Message;
            ErrorLabel.ForeColor = Color.Red;
        }
    }

    protected void MerchantGV_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {
        try
        {
            SysData.Merchant_Approve(int.Parse(MerchantGV.DataKeys[e.NewSelectedIndex].Value.ToString()));
        }
        catch (Exception ex)
        {
            ErrorLabel.Text = ex.Message;
            ErrorLabel.ForeColor = Color.Red;
        }
    }
}