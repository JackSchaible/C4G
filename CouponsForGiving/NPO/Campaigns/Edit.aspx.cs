using AjaxControlToolkit;
using CouponsForGiving;
using CouponsForGiving.Data;
using CouponsForGiving.Data.Classes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class NPO_Campaigns_Edit : System.Web.UI.Page
{
    public NPO npo;
    public Campaign campaign;
    public List<object> deals;

    protected void Page_Load(object sender, EventArgs e)
    {
        Controls_MenuBar control = (Controls_MenuBar)Master.FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.NPO;

        campaign = SysData.Campaign_Get(int.Parse(Request["cid"]));
        npo = campaign.NPO;
        Page.Title = String.Format("Editing Campaign \"{0}\" - {1}", campaign.Name, npo.Name);
        deals = (
                    from
                        d
                    in
                        campaign.DealInstances
                    where
                        d.StartDate < DateTime.Now && d.EndDate > DateTime.Now && d.DealStatusID == 2
                    select
                        new
                        {
                            MerchantID = d.Deal.MerchantID,
                            DealInstanceID = d.DealInstanceID,
                            CampaignID = campaign.CampaignID,
                            MerchantName = d.Deal.Merchant.Name,
                            SmallLogo = d.Deal.Merchant.SmallLogo,
                            DealName = d.Deal.Name,
                            DealImage = d.Deal.ImageURL,
                            Savings = (d.Deal.Prices.FirstOrDefault<Price>().RetailValue - d.Deal.Prices.FirstOrDefault<Price>().GiftValue),
                            Price = d.Deal.Prices.FirstOrDefault<Price>().GiftValue
                        }
                    ).ToList<object>();

        if (!IsPostBack)
        {
            if (Request["cid"] == null)
                Response.Redirect("../Home.aspx");
            else
            {
                BindData();
            }
        }
    }

    private void BindData()
    {
        CampaignImage.ImageUrl = "../../" + campaign.CampaignImage;
        DealsGV.DataSource = deals;
        DealsGV.DataBind();
    }

    [WebMethod]
    [ScriptMethod]
    public static string SaveCampaign(string campaignID, string username, string name, string startdate, string enddate, string description,
            string goal, string image, string showonhome, string campaigngoal)
    {
        string result = "OKAY";
        try
        {
            bool featured = (showonhome == "true") ? true : false;
            int cID = -1;
            int? goalValue = null;
            DateTime? sDate = null, eDate = null;

            username = HttpUtility.UrlDecode(username);
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
    public static string AddDealInstance(string CampaignID, string DealInstanceID)
    {
        string result = "Success!";

        try
        {
            int cid, did;

            cid = int.Parse(CampaignID);
            did = int.Parse(DealInstanceID);

            if (!CampaignDealInstances.InsertIfNotExists(cid, did))
                result = "false";
        }
        catch (Exception ex)
        {
            result = ex.Message;
        }

        return result;
    }

    protected void fileUploadComplete(object sender, AsyncFileUploadEventArgs e)
    {
        string vPath = Utilsmk.SaveNewCampaignImage(ImageUpload.PostedFile, npo.NPOID, Server, campaign.CampaignID).Replace(Request.ServerVariables["APPL_PHYSICAL_PATH"], String.Empty);
        Campaigns.UpdateImage(campaign.CampaignID, vPath);
        Response.Redirect(Request.Url.ToString(), true);
    }

    protected void EditImageButton_Click(object sender, ImageClickEventArgs e)
    {
        EditImageButton.ImageUrl = "~/Images/save.jpg";
        CampaignImage.Visible = false;
        ImageUpload.Visible = true;
    }
}