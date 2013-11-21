using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CouponsForGiving.Data;
using CouponsForGiving;
using System.Transactions;
using System.Net.Mail;
using System.Web.Security;
using CouponsForGiving.Data.Classes;
using System.Web.Services;
using System.Web.Script.Services;
using System.IO;

public partial class NPO_newCampaign : System.Web.UI.Page, ICallbackEventHandler
{
    public NPO npo;
    public List<string> Errors;

    public string GetCallbackResult()
    {
        return _Callback;
    }

    private string _Callback;


    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.Params["__EVENTTARGET"] == "PageLeave")
            newCampaignSubmit_Click(this, e);

        Controls_MenuBar control = (Controls_MenuBar)Master.FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.NPO;

        try
        {
            BindData();
        }
        catch (Exception ex)
        {
            ErrorLabel.Text = ex.ToString();
            ErrorLabel.ForeColor = Color.Red;
        }

        if (!IsCallback)
            ltCallback.Text = ClientScript.GetCallbackEventReference(this, "'bindgrid'", "EndGetData", "'asyncgrid'", false);
    }

    private void BindData()
    {
        npo = SysDatamk.NPO_GetByUsername(User.Identity.Name);
        Username.Value = User.Identity.Name;

        EligibleDeals_GV.DataSource = Deals.GetEligibleByUsername(User.Identity.Name, EndDate.Date);
        EligibleDeals_GV.DataBind();

        ErrorLabel.Text = "";
        Errors = new List<string>();
    }

    protected void newCampaignSubmit_Click(object sender, EventArgs e)
    {
        try
        {
            bool valid = true;
            string thisUser = User.Identity.Name;
            NPO thisNPO = SysDatamk.NPO_GetByUsername(thisUser);
            
            string name = newCampaignName.Text.Trim();
            string description = newCampaignDescription.Text.Trim();
            string goal = newCampaignGoal.Text.Trim();
            string fGoal = newCampaignFundraisingGoal.Text.Trim();
            string image = newCampaignImage.FileName.ToString();
            bool showOnHome = newCampaignShowOnHome.Checked;

            DateTime? startDate = null, endDate = null;
            int? fundraisingGoal = null;
            int campaignID = -1;

            if (CampaignID.Value != "")
                campaignID = int.Parse(CampaignID.Value);

            startDate = StartDate.Date;
            endDate = EndDate.Date;

            if (startDate != null && endDate != null)
                if (endDate < startDate)
                {
                    valid = false;
                    ErrorLabel.Text = "End date must be after start date.";
                }

            if (fGoal != "")
            {
                try
                {
                    fundraisingGoal = int.Parse(fGoal);
                }
                catch (Exception ex)
                {
                    valid = false;
                    ErrorLabel.Text = "Fundraising goal is not a valid number.";
                }
            }

            if (newCampaignImage.HasFile)
            {
                if (!(Utilsmk.ValidImage(newCampaignImage.PostedFile.InputStream)))
                {
                    valid = false;
                    ErrorLabel.Text = "Image is not a valid image file type. (Ex. .png, .jpeg, .png, .gif)";
                }
            }

            if ((newCampaignImage.HasFile) && valid)
            {
                if (!(Utilsmk.ValidLogoSize(newCampaignImage.PostedFile.ContentLength)))
                {
                    valid = false;
                    ErrorLabel.Text = "Image file size must be less than 4MB.";
                }
            }

            if (valid)
            {
                bool isComplete = false;
                List<string> errors = new List<string>();

                using (TransactionScope ts = new TransactionScope())
                {
                    try
                    {
                        if (!newCampaignImage.HasFile)
                            image = null;
                        else
                            image = Utilsmk.SaveNewCampaignImage(newCampaignImage.PostedFile, thisNPO.NPOID, Server, campaignID).Replace(Request.ServerVariables["APPL_PHYSICAL_PATH"], String.Empty);

                        if (campaignID != -1)
                            Campaigns.Save(campaignID, User.Identity.Name, name, startDate, endDate, description, fundraisingGoal, image, showOnHome, 1, goal);
                        else
                            campaignID = Campaigns.Save(User.Identity.Name, name, startDate, endDate, description, fundraisingGoal, image, showOnHome, 1, goal);

                        errors = Campaigns.IsComplete(campaignID);
                        isComplete = errors.Count == 0;

                        ts.Complete();
                    }
                    catch (Exception ex)
                    {
                        ErrorLabel.Text = ex.ToString();
                        ErrorLabel.ForeColor = Color.Red;
                    }
                }

                if (campaignID == -1)
                    ErrorLabel.Text = "Something's gone wrong. Your campaign wasn't saved.";
                else if (isComplete)
                {
                    string uname = User.Identity.Name;
                    string org = thisNPO.Name;
                    string email = Membership.GetUser(uname).Email;

                    MailMessage mm = new MailMessage();

                    mm.To.Add(new MailAddress(email));

                    mm.IsBodyHtml = true;
                    mm.Subject = "C4G: New Campaign";

                    mm.Body = @"
                        <style type='text/css'>
                            h1, a, p
                                font-family: Corbel, Arial, sans-serif;
                            }
                        </style>
                        <p>Congratulations! Your campaign " + name + @" has been set up! Here is your unique campaign URL: <a href='https://www.coupons4giving.ca/" + npo.Name + "/" + name + @"'>www.coupons4giving.ca/" + npo.Name + "/" + name + @"</a></p>
                        <p>If you need any help, don't hesitate to contact our support team at <a href='mailto:teamc4g@coupons4giving.ca'>teamc4g@coupons4giving.ca</a></p>
                        <p>Cheers!</p>
                        <p>The Coupons4Giving Team</p>
                        ";

                    SmtpClient client = new SmtpClient();
                    client.Send(mm);

                    Campaigns.MarkAsActive(campaignID);

                    Response.Redirect(String.Format("CampaignPage.aspx?nponame={0}&campaign={1}", npo.Name, name));
                }
                else
                {
                    ErrorLabel.Text = "Your campaign was saved. In order to publish it, you still need a few things: ";
                    Errors = errors;
                }
            }
        }
        catch (Exception ex)
        {
            ErrorLabel.Text = ex.ToString();
            ErrorLabel.ForeColor = Color.Red;
        }
    }

    protected void EligibleDeals_GV_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        EligibleDeals_GV.PageIndex = e.NewPageIndex;
        BindData();
    }

    [WebMethod]
    [ScriptMethod]
    public static string SaveCampaign(string campaignID, string username, string name, string startdate, string enddate, string description,
        string goal, string showonhome, string campaigngoal)
    {
        int result = -1;

        try
        {
            bool featured = (showonhome == "on") ? true : false;
            int cID = -1;
            int? goalValue = null;
            DateTime? sDate = null, eDate = null;

            if (campaignID != "")
                cID = int.Parse(campaignID);

            if (goal != "")
                goalValue = int.Parse(goal);

            if (cID == -1)
                result = Campaigns.Save(username, name, sDate, eDate, description, goalValue,
                    "", featured, 1, campaigngoal);
            else
            {
                Campaigns.Save(cID, username, name, sDate, eDate, description, goalValue,
                    "", featured, 1, campaigngoal);
                result = cID;
            }
        }
        catch (Exception ex)
        {
            return ex.Message;
        }

        return result.ToString();
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

    [WebMethod]
    [ScriptMethod]
    public static string RemoveDealInstance(string dealInstanceID, string campaignID)
    {
        string result = "Success!";

        int cid = 0;
        int did= 0;

        try
        {
            cid = int.Parse(campaignID);
            did = int.Parse(dealInstanceID);

            CampaignDealInstances.Remove(cid, did);
        }
        catch (Exception ex)
        {
            result = ex.Message;
        }

        return result;
    }

    public void RaiseCallbackEvent(string arg)
    {
        EligibleDeals_GV.DataSource = Deals.GetEligibleByUsername(User.Identity.Name, EndDate.Date);
        EligibleDeals_GV.DataBind();

        using (StringWriter sw = new StringWriter())
        {
            EligibleDeals_GV.RenderControl(new HtmlTextWriter(sw));
            _Callback = sw.ToString();
        }
    }
}