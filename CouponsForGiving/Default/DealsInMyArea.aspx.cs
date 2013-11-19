﻿using CouponsForGiving;
using CouponsForGiving.Data;
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
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;

public partial class Default_DealsInMyArea : System.Web.UI.Page
{
    public string City { get; set; }
    public string Province { get; set; }
    public string Country { get; set; }

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

        if (!IsPostBack)
            BindData();
    }

    private void BindData()
    {
        DealsGV.DataSource = SysData.DealInstance_ListByCity(City, Province, Country);
        DealsGV.DataBind();
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

        }
        finally
        {
            objWebReq = null;
        }
    }

    protected void CitiesGV_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {

    }

    protected void DealsGV_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {
        string uri = String.Format("DealPage.aspx?did={0}&cid={1}",
            DealsGV.DataKeys[e.NewSelectedIndex].Values[0].ToString(),
            DealsGV.DataKeys[e.NewSelectedIndex].Values[1].ToString());
        Response.Redirect(uri);
    }
}