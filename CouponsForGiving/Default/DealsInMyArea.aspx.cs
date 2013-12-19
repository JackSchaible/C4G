﻿using CouponsForGiving;
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

public partial class Default_DealsInMyArea : System.Web.UI.Page
{
    public string City { get; set; }
    public string Province { get; set; }
    public string Country { get; set; }
    public List<DealInstance> DIs { get; set; }

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
            DIs = Deals.ListByCity(City, Province).OrderByDescending(x => x.Deal.MerchantID).ToList<DealInstance>();
        else
        {
            string city = CitiesDDL.SelectedValue.Split(new char[] { ',' })[0].Trim(), province = CitiesDDL.SelectedValue.Split(new char[] { ',' })[1].Trim();
            DIs = Deals.ListByCity(city, province);
            City = city;
            Province = province;
        }

        List<string> cities = 
            (
                from c
                in Cities.List()
                orderby c.Country.Name, c.PoliticalDivision.Name, c.Name
                select c.Name + ", " + c.PoliticalDivision.Name
            ).ToList<string>();

        CityObj current = GetLocation(Request.ServerVariables["REMOTE_ADDR"]);
        cities.Insert(0, current.City + ", " + current.Province);

        CitiesDDL.DataSource = cities;
        CitiesDDL.DataBind();
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
            Country = "Canada";
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

        List<DealInstance> deals = Deals.ListByCity(city, province);

        result = HttpRendering.ListMerchantOffers(deals);

        return result;
    }
}