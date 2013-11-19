using CouponsForGiving;
using CouponsForGiving.Data;
using CouponsForGiving.Data.Classes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Transactions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Merchant_MyPartners_Requests : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Controls_MenuBar control = (Controls_MenuBar)Master.FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.Merchant;

        if (!IsPostBack)
            BindData();
    }

    private void BindData()
    {
        RequestsGV.DataSource = 
            (
                from npo 
                in Merchants.ListNPORequests(User.Identity.Name) 
                select new 
                { 
                    npo.NPOID, npo.Name, npo.NPODescription, npo.PhoneNumber, 
                    npo.URL, npo.Logo, npo.Email, City = npo.City.Name + ", " + npo.City.PoliticalDivision.Name
                }
            );
        RequestsGV.DataBind();

        if (RequestsGV.Rows.Count < 1)
            AcceptAll.Visible = false;
        else
            AcceptAll.Visible = true;

        ErrorLabel.Text = "";
    }

    protected void AcceptAll_Click(object sender, EventArgs e)
    {
        using (TransactionScope ts = new TransactionScope())
        {
            try
            {
                foreach (NPO n in (from npo in Merchants.ListNPORequests(User.Identity.Name) select npo))
                    Merchants.ApproveNPORequest(User.Identity.Name, n.NPOID);

                ts.Complete();
                BindData();
            }
            catch (Exception ex)
            {
                ErrorLabel.Text = "Approving all requests failed. Please try accepting them individually.";
                try
                {
                    ex.ToString();
                    ts.Dispose();
                }
                catch (Exception ex2)
                {
                    ts.Dispose();
                    ex2.ToString();
                }
            }
        }
    }

    protected void RequestsGV_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {
        try
        {
            Merchants.ApproveNPORequest(User.Identity.Name, int.Parse(RequestsGV.SelectedDataKey.Value.ToString()));
            BindData();
        }
        catch (Exception ex)
        {
            ErrorLabel.Text = "Something went wrong. We're sorry, but the request wasn't approved. Please contact our help desk, and retain this error message: " + ex.Message;
        }
    }
}