using CouponsForGiving;
using CouponsForGiving.Data;
using CouponsForGiving.Data.Classes;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.Configuration;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;

public partial class Default_DealsInMyArea : System.Web.UI.Page
{
    public string City { get; set; }
    public string Province { get; set; }
    public string Country { get; set; }
    public List<Campaign> LocalCampaigns { get; set; }

    private struct CityObj
    {
        public string City { get; set; }
        public string Province { get; set; }
    }

    protected override void OnPreInit(EventArgs e)
    {
        string ip = Request.ServerVariables["REMOTE_ADDR"];
        SetLocation(ip);

        base.OnPreInit(e);
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        Controls_MenuBar control = (Controls_MenuBar)Master.FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.Supporter;

        BindData();
    }

    private void BindData()
    {
        if (CitiesDDL.SelectedIndex == 0)
            LocalCampaigns = Campaigns.ListByCity(City, Province).OrderByDescending(x => x.NPOID).ToList<Campaign>();
        else
        {
            string city = CitiesDDL.SelectedValue.Split(new char[] { ',' })[0].Trim(), province = CitiesDDL.SelectedValue.Split(new char[] { ',' })[1].Trim();
            LocalCampaigns = Campaigns.ListByCity(city, province).OrderByDescending(x => x.NPOID).ToList<Campaign>();
            City = city;
            Province = province;
        }

        List<string> cities =
            (
                from c
                in Cities.ListWhereActiveCampaigns()
                orderby c.Country.Name, c.PoliticalDivision.Name, c.Name
                select c.Name + ", " + c.PoliticalDivision.Name
            ).ToList<string>();

        CityObj current = GetLocation(Request.ServerVariables["REMOTE_ADDR"]);
        cities.Insert(0, current.City + ", " + current.Province);

        string selected = CitiesDDL.SelectedItem.Text;

        CitiesDDL.DataSource = cities;
        CitiesDDL.DataBind();

        if (selected != "Select a City")
            CitiesDDL.Items.FindByText(selected).Selected = true;

    }


    private void SetLocation(string IP)
    {
        System.Uri objUrl = new System.Uri(String.Format("http://geoip.maxmind.com/e?l={0}&i={1}", WebConfigurationManager.AppSettings["GeoIPLicense"].ToString(), IP));
        System.Net.WebRequest objWebReq;
        System.Net.WebResponse objResp;
        System.IO.StreamReader sReader;
        string strReturn = string.Empty;

        try
        {
            objWebReq = System.Net.WebRequest.Create(objUrl);
            objResp = objWebReq.GetResponse();

            sReader = new System.IO.StreamReader(objResp.GetResponseStream());
            strReturn = sReader.ReadToEnd();

            sReader.Close();
            objResp.Close();

            string[] returnedValues = strReturn.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            City = returnedValues[4]; //4
            Province = returnedValues[3]; //3
            Country = returnedValues[1]; //1
        }
        catch (Exception ex)
        {
            //Set to edmonton by default if lookup fails; replace with getting user's preferred location
            City = "Edmonton";
            Province = "Alberta";
            ex.ToString();
        }
        finally
        {
            objWebReq = null;
        }
    }

    private CityObj GetLocation(string IP)
    {
        CityObj result = new CityObj();
        System.Uri objUrl = new System.Uri(String.Format("http://geoip.maxmind.com/e?l={0}&i={1}", WebConfigurationManager.AppSettings["GeoIPLicense"].ToString(), IP));
        System.Net.WebRequest objWebReq;
        System.Net.WebResponse objResp;
        System.IO.StreamReader sReader;
        string strReturn = string.Empty;

        try
        {
            objWebReq = System.Net.WebRequest.Create(objUrl);
            objResp = objWebReq.GetResponse();

            sReader = new System.IO.StreamReader(objResp.GetResponseStream());
            strReturn = sReader.ReadToEnd();

            sReader.Close();
            objResp.Close();

            string[] returnedValues = strReturn.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            result = new CityObj()
            {
                City = returnedValues[4],
                Province = returnedValues[3]
            };

            Country = returnedValues[1];
        }
        catch (Exception ex)
        {
            //Set to edmonton by default if lookup fails; replace with getting user's preferred location
            result = new CityObj()
            {
                City = "Edmonton",
                Province = "Alberta"
            };
            ex.ToString();
        }
        finally
        {
            objWebReq = null;
        }

        return result;
    }

    /// <summary>
    /// Returns the HTML for displaying a list of deals
    /// </summary>
    /// <param name="location">A string containing the location (must in the format "<City>, <Province/State>", for example, "Edmonton, Alberta")</param>
    /// <returns>The HTML for displaying a list of deals</returns>
    [WebMethod]
    [ScriptMethod]
    public static string ChangeCity(string location)
    {
        string result = "";

        string city = location.Split(new char[] { ',' })[0].Trim();
        string province = location.Split(new char[] { ',' })[1].Trim();

        List<Campaign> campaigns = Campaigns.ListByCity(city, province);

        result = HttpRendering.ListNPOCampaigns(campaigns);

        return result;
    }
}