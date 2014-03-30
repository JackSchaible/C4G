using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CouponsForGiving;
using CouponsForGiving.Data;
using System.Web.Configuration;

public partial class Default_NpoPage : System.Web.UI.Page
{
    public NPO npo;
    public Campaign featured;
    public List<Campaign> campaigns;
    public string Caption
    {
        get
        {
            return WebConfigurationManager.AppSettings["ProfilePostTitle"];
        }
    }
    public string URL { get; set; }


    protected override void OnPreInit(EventArgs e)
    {
        base.OnPreInit(e);

        if (Page.RouteData.Values["nponame"] == null)
            if (Request.QueryString["name"] == null)
                Response.Redirect("~/Default/MyHome.aspx", true);

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
                        Response.Redirect("MyHome.aspx");
                        ex2.ToString();
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
                    Response.Redirect("MyHome.aspx");
                    ex.ToString();
                }
            }
        }

        if (npo == null)
            Response.Redirect("MyHome.aspx", true);

        Title = npo.Name + " - Coupons4Giving";
        URL = WebServices.GetGoogleURL("https://www.coupons4giving.ca/Causes/" + npo.Name);

        campaigns = 
            (
                from
                    c
                in 
                    npo.Campaigns
                where
                    c.CampaignStatusID == 2
                    && c.EndDate >= DateTime.Now
                select
                    c
            ).ToList<Campaign>();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        Controls_MenuBar control = (Controls_MenuBar)Master.FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.Supporter;
        Master.SideBar = false;
    }
}