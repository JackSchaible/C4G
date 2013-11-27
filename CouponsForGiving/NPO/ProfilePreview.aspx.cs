using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CouponsForGiving;
using CouponsForGiving.Data;

public partial class Default_NpoPage : System.Web.UI.Page
{
    public NPO npo;
    public Campaign featured;

    protected override void OnPreInit(EventArgs e)
    {
        base.OnPreInit(e);

        if (Page.RouteData.Values["nponame"] == null)
            if (Request.QueryString["name"] == null)
                Response.Redirect("~/Default/Home.aspx", true);

        if (Page.RouteData.Values["nponame"] != null)
        {
            string name = Page.RouteData.Values["nponame"].ToString();

            try
            {
                npo = SysData.NPO_GetByUrl(name);
            }
            catch (Exception ex)
            {
                if (Request.QueryString["name"] != null)
                {
                    name = Request.QueryString["name"];

                    try
                    {
                        npo = SysData.NPO_GetByUrl(name);
                    }
                    catch (Exception ex2)
                    {
                        ex2.ToString();
                        Response.Redirect("MyHome.aspx");
                    }
                }

                ex.ToString();
            }
        }
        else
        {
            if (Request.QueryString["name"] != null)
            {
                string name = Request.QueryString["name"];

                try
                {
                    npo = SysData.NPO_GetByUrl(name);
                }
                catch (Exception ex)
                {
                    ex.ToString();
                    Response.Redirect("MyHome.aspx");
                }
            }
        }

        if (npo == null)
            Response.Redirect("MyHome.aspx", true);

        Title = npo.Name + " - Coupons4Giving";
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        featured = (from ca in npo.Campaigns where ca.ShowOnHome == true && ca.StartDate < DateTime.Now && ca.EndDate > DateTime.Now select ca).FirstOrDefault<CouponsForGiving.Data.Campaign>();

        if (featured == null)
        {
            FeaturedCampaign.Visible = false;
            FeaturedCampaign.Enabled = false;
        }

        Controls_MenuBar control = (Controls_MenuBar)Master.FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.Supporter;

        if (npo.Campaigns.Count == 0)
        {
            Campaigns.Enabled = false;
            Campaigns.Visible = false;
        }

    }
}