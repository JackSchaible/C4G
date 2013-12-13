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
    public static void SaveCampaign(string id, string name, string description,
            string showonhome, string campaigngoal)
    {
        if (id == null)
            throw new ArgumentNullException("Campaign ID is missing.");

        if (name == null)
            throw new ArgumentNullException("Your campaign needs a name.");

        if (description == null)
            throw new ArgumentNullException("Your campaign needs to have a description.");

        if (showonhome == null)
            throw new ArgumentNullException("Featured Campaign is missing.");

        if (campaigngoal == null)
            throw new ArgumentNullException("Your campaign needs to have a goal.");

        string username = HttpContext.Current.User.Identity.Name;
        string campaignName = HttpUtility.UrlDecode(name).Trim();
        string campaignDescription = HttpUtility.UrlDecode(description).Trim();
        int campaignGoal = int.Parse(HttpUtility.UrlDecode(campaigngoal).Trim());
        int campaignID = int.Parse(HttpUtility.UrlDecode(id).Trim());
        bool featured = (showonhome == "on") ? true : false;

        Campaign campaign = SysData.Campaign_Get(campaignID);
        
        Campaigns.Save(campaignID, username, campaignName, campaign.StartDate, campaign.EndDate,
            campaignDescription, campaignGoal, campaign.CampaignImage, featured, 1, campaigngoal);
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