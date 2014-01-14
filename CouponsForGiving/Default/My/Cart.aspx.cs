using CouponsForGiving;
using CouponsForGiving.Data;
using CouponsForGiving.Data.Classes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Transactions;
using System.Web;
using System.Web.Configuration;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

public partial class Default_My_Cart : System.Web.UI.Page
{
    public static XmlDocument strings;

    protected void Page_Load(object sender, EventArgs e)
    {
        Controls_MenuBar control = (Controls_MenuBar)Master.FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.Supporter;

        strings = new XmlDocument();
        strings.Load(Server.MapPath(String.Format("Text ({0}).xml", WebConfigurationManager.AppSettings["Language"])));

        
        //Process cart and make sure a campaign is attached to each deal
        if (Session["Cart"] != null)
            foreach (ShoppingCart item in (List<ShoppingCart>)Session["Cart"])
            {
                if (item.CampaignID == -1)
                {
                    Campaign defaultCampaign = SysData.DealInstance_GetByID(item.DealInstanceID).Campaigns.FirstOrDefault<Campaign>();
                    item.CampaignID = defaultCampaign.CampaignID;
                    item.NPOName = defaultCampaign.NPO.Name;
                }
            }
    }

    protected void ClearButton_Click(object sender, EventArgs e)
    {
        Session["Cart"] = null;
    }
    
    protected void CheckoutButton_Click(object sender, EventArgs e)
    {
        List<ShoppingCart> cart = (List<ShoppingCart>)Session["Cart"];

        if (cart != null)
            if (cart.Count > 0)
                try
                {
                    Response.Redirect("PaymentOptions.aspx");
                }
                catch (Exception ex)
                {
                    ErrorLabel.Text = ex.Message;
                }
            else
                ErrorLabel.Text = "Your cart is currently empty.";
        else
            ErrorLabel.Text = "Your cart is currently empty.";
    }

    [WebMethod]
    [ScriptMethod]
    public static void ChangeCampaign(int DealInstanceID, int CampaignID)
    {
        List<ShoppingCart> cart = (List<ShoppingCart>)HttpContext.Current.Session["Cart"];

        if (cart.Count > 0)
        {
            foreach (ShoppingCart item in cart)
            {
                if (item.DealInstanceID == DealInstanceID)
                {
                    Campaign campaign = SysData.Campaign_Get(CampaignID);

                    item.CampaignID = campaign.CampaignID;
                    item.CampaignName = campaign.Name;
                    item.NPOName = campaign.NPO.Name;
                }
            }
        }

        HttpContext.Current.Session["Cart"] = cart;
    }

    [WebMethod]
    [ScriptMethod]
    public static void DeleteDeal(int DealInstanceID, int CampaignID)
    {
        List<ShoppingCart> cart = null;

        if (HttpContext.Current.Session["Cart"] != null)
            cart = (List<ShoppingCart>)HttpContext.Current.Session["Cart"];

        ShoppingCart item = (from c in cart where c.DealInstanceID == DealInstanceID && c.CampaignID == CampaignID select c).FirstOrDefault<ShoppingCart>();

        if (item == null)
            throw new Exception("Item could not be found");
        else
        {
            cart.Remove(item);
            HttpContext.Current.Session["Cart"] = cart;
        }
    }
}