using AjaxControlToolkit;
using CouponsForGiving;
using CouponsForGiving.Data;
using CouponsForGiving.Data.Classes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class NPO_Campaigns_Edit : System.Web.UI.Page
{
    public NPO npo;
    public Campaign campaign;
    public List<DealInstance> deals;
    public string Caption
    {
        get
        {
            return WebConfigurationManager.AppSettings["CampaignPostTitle"];
        }
    }
    public string URL { get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        Controls_MenuBar control = (Controls_MenuBar)Master.FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.NPO;
        ((SiteMaster)Page.Master).SideBar = false;

        if (Request.QueryString["cid"] == null)
            Response.Redirect("../MyHome.aspx", true);

        campaign = SysData.Campaign_Get(int.Parse(Request["cid"]));
        npo = campaign.NPO;
        Page.Title = String.Format("Editing Campaign \"{0}\" - {1}", campaign.Name, npo.Name);
        deals = campaign.DealInstances.ToList<DealInstance>();
    }

    [WebMethod]
    [ScriptMethod]
    public static string SaveCampaign(string campaignID, string name, string startdate, string enddate, string description,
            string goal, string image, string showonhome, string campaigngoal)
    {
        string result = "OKAY";
        try
        {
            bool featured = (showonhome == "true") ? true : false;
            int cID = -1;
            int? goalValue = null;
            DateTime? sDate = null, eDate = null;

            string username = HttpContext.Current.User.Identity.Name;
            name = HttpUtility.UrlDecode(name);
            description = HttpUtility.UrlDecode(description);
            campaigngoal = HttpUtility.UrlDecode(campaigngoal);
            image = HttpUtility.UrlDecode(image);

            if (campaignID != "")
                cID = int.Parse(HttpUtility.UrlDecode(campaignID));

            if (startdate != "")
                sDate = DateTime.Parse(HttpUtility.UrlDecode(startdate));

            if (enddate != "")
                eDate = DateTime.Parse(HttpUtility.UrlDecode(enddate));

            if (goal != "")
                goalValue = int.Parse(HttpUtility.UrlDecode(goal));

            Campaigns.Save(cID, username, name, sDate, eDate, description, goalValue,
                image, featured, 1, campaigngoal);
        }
        catch (Exception ex)
        {
            return ex.Message;
        }

        return result;
    }

    [WebMethod]
    [ScriptMethod]
    public static void AddDealInstance(string CampaignID, string DealInstanceID)
    {
        int cid, did;

        cid = int.Parse(CampaignID);
        did = int.Parse(DealInstanceID);

        CampaignDealInstances.InsertIfNotExists(cid, did);
    }

    [WebMethod]
    [ScriptMethod]
    public static void RemoveDealInstance(string CampaignID, string DealInstanceID)
    {
        CampaignDealInstances.Remove(int.Parse(CampaignID), int.Parse(DealInstanceID));
    }
}