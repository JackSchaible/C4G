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
using System.Globalization;

public partial class NPO_newCampaign : System.Web.UI.Page
{
    public NPO npo;
    public List<string> Errors;

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

    }

    private void BindData()
    {
        npo = SysDatamk.NPO_GetByUsername(User.Identity.Name);
        Username.Value = User.Identity.Name;

        ((DropDownList)EndDate.FindControl("DayDDL")).Enabled = true;
        ((DropDownList)EndDate.FindControl("MonthDDL")).Enabled = true;
        ((DropDownList)EndDate.FindControl("YearDDL")).Enabled = true;

        int campaignID = -1;

        if (CampaignID.Value != "")
            campaignID = int.Parse(CampaignID.Value);

        Campaign campaign = SysData.Campaign_Get(campaignID);

        //if (campaign != null)
        //{
        //    if (campaign.DealInstances.Count > 0)
        //    {
        //        ((DropDownList)EndDate.FindControl("DayDDL")).Enabled = false;
        //        ((DropDownList)EndDate.FindControl("MonthDDL")).Enabled = false;
        //        ((DropDownList)EndDate.FindControl("YearDDL")).Enabled = false;
        //    }
        //}

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

            DateTime? startDate = StartDate.Date, endDate = EndDate.Date;
            int? fundraisingGoal = null;
            int campaignID = -1;

            if (CampaignID.Value != "")
            {
                campaignID = int.Parse(CampaignID.Value);
                endDate = SysData.Campaign_Get(campaignID).EndDate;
            }


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
                    ex.ToString();
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
                        <p>Congratulations! Your campaign " + name + @" has been set up! Here is your unique campaign URL: <a href='https://www.coupons4giving.ca/Causes/" + npo.Name + "/" + name + @"'>www.coupons4giving.ca/" + npo.Name + "/" + name + @"</a></p>
                        <p>If you need any help, don't hesitate to contact our support team at <a href='mailto:support@coupons4giving.ca'>support@coupons4giving.ca</a></p>
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
        //EligibleDeals_GV.PageIndex = e.NewPageIndex;
        BindData();
    }

    [WebMethod]
    [ScriptMethod]
    public static string SaveCampaign(string campaignID, string username, string name, string description,
        string startdate, string enddate, string goal, string showonhome, string campaigngoal)
    {
        int result = -1;

        string startDateDay, startDateMonth, startDateYear, endDateDay, endDateMonth, endDateYear;

        char[] split = new char[] { '-' };

        startDateDay = startdate.Split(split)[0];
        startDateMonth = startdate.Split(split)[1];
        startDateYear = startdate.Split(split)[2];

        endDateDay = enddate.Split(split)[0];
        endDateMonth = enddate.Split(split)[1];
        endDateYear = enddate.Split(split)[2];

        DateTime startDate = new DateTime(int.Parse(startDateYear), DateTime.ParseExact(startDateMonth, "MMMM", CultureInfo.CurrentCulture).Month, int.Parse(startDateDay));
        DateTime endDate = new DateTime(int.Parse(endDateYear), DateTime.ParseExact(endDateMonth, "MMMM", CultureInfo.CurrentCulture).Month, int.Parse(endDateDay));

        try
        {
            bool featured = (showonhome == "on") ? true : false;
            int cID = -1;
            int? goalValue = null;

            if (campaignID != "")
                cID = int.Parse(campaignID);

            if (goal != "")
                goalValue = int.Parse(goal);

            if (cID == -1)
                result = Campaigns.Save(username, name, startDate, endDate, description, goalValue,
                    "", featured, 1, campaigngoal);
            else
            {
                Campaigns.Save(cID, username, name, startDate, endDate, description, goalValue,
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

    [WebMethod]
    [ScriptMethod]
    public static string GetGridView(string endDate)
    {
        string result = "";
        DateTime date = DateTime.Parse(endDate);

        List<Deal_GetEligibleByUsername_Result> offers = Deals.GetEligibleByUsername(HttpContext.Current.User.Identity.Name, date);

        if (offers.Count > 0)
        {
            result = "<div><table cellspacing=\"0\" rules=\"all\" border=\"1\" id=\"Main_Content_EligibleDeals_GV\" style=\"width:530px;border-collapse:collapse;\"><tr><th scope=\"col\">&nbsp;</th><th scope=\"col\">&nbsp;</th><th scope=\"col\">Merchant</th><th scope=\"col\">Deal</th><th scope=\"col\">Start Date</th><th scope=\"col\">End Date</th></tr>";

            string row;

            foreach (Deal_GetEligibleByUsername_Result item in offers)
            {
                row = "";
                row = "<tr>";
                row += String.Format("<td><input style=\"cursor: pointer;\" type=\"button\" onclick=\"addDeal({0}, '{1}')\" value=\"Add Deal\" />", item.DealInstanceID, HttpContext.Current.Server.UrlEncode(item.Name).Replace("+", "%20"));
                row += String.Format("<td><a href=\"../../Default/DealPage.aspx?merchantname={0}&deal={1}\">View</a></td>", item.MerchantName, item.Name);
                row += String.Format("<td>{0}</td><td>{1}</td><td>{2}</td><td>{3}</td>", item.MerchantName, item.Name, item.StartDate.ToString("MMM dd, yyyy"), item.EndDate.ToString("MMM dd, yyyy"));
                row += "</tr>";

                result += row;
            }

            result += "</tr></table></div>";
        }
        else
            result = "<p>" + (CouponsForGiving.Data.Classes.NPOs.HasMerchantPartners(HttpContext.Current.User.Identity.Name) ? "There are no deals from your merchant partners whose dates coincide with yours. Consider revising the End Date of your campaign." : "You have not yet added any Merchant partners! <a href='../Partners/Add.aspx'>Click here</a> to add some to see their great deals.") + "</p>";

        return result;
    }
}