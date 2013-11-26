using CouponsForGiving;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Configuration;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Controls_SocialShare : System.Web.UI.UserControl
{
    //Input Parameters
    public ShareType Share { get; set; }
    public CampaignType CType { get; set; }
    public string Name { get; set; }
    public string Campaign { get; set; }
    public string ImageURL { get; set; }
    public string Description { get; set; }

    public string URL { get; set; }

    //Derived Values
    public string Caption 
    {
        get
        {
            string result = "";

            switch (Share)
            { 
                case ShareType.Campaign:
                    result = WebConfigurationManager.AppSettings["CampaignPostTitle"];
                    break;

                case ShareType.Profile:
                    result = WebConfigurationManager.AppSettings["ProfilePostTitle"];
                    break;

                case ShareType.Generic:
                    result = WebConfigurationManager.AppSettings["GenericPostTitle"];
                    break;
            }

            return result;
        }
    }
    public string LinkedInURL
    {
        get
        {
            string result = "";

            result = String.Format("http://www.linkedin.com/shareArticle?mini=true&url={0}&title={1}&summary={2}&source={3}", 
                URL, Uri.EscapeDataString(Name + " - C4G"), Uri.EscapeDataString(Description), "Coupons4Giving");

            return result;
        }
    }

    public Controls_SocialShare()
    {
        Share = ShareType.Generic;
        CType = CampaignType.Campaign;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        DataBind();

        switch (Share)
        {
            case ShareType.Campaign:
                URL = String.Format("https://www.coupons4giving.ca/{0}/{1}/{2}", CType == CampaignType.Campaign ? "Causes" : "Offers", Uri.EscapeDataString(Name), Uri.EscapeDataString(Campaign));
                break;

            case ShareType.Profile:
                URL = String.Format("https://www.coupons4giving.ca/{0}/{1}", (CType == CampaignType.Campaign ? "Causes" : "Offers"), Uri.EscapeDataString(Name));
                break;
        }

        HttpWebRequest request = (HttpWebRequest)WebRequest.Create("https://www.googleapis.com/urlshortener/v1/url/");
        request.Method = "POST";
        request.ContentType = "application/json";
        string data = "{ \"longUrl\" : \"" + URL + "\"}";
        StreamWriter sw = new StreamWriter(request.GetRequestStream());
        sw.Write(data);
        sw.Close();

        HttpWebResponse response = (HttpWebResponse)request.GetResponse();

        using (StreamReader sr = new StreamReader(request.GetResponse().GetResponseStream()))
        {
            data = "";
            data = sr.ReadToEnd();
        }

        JavaScriptSerializer jss = new JavaScriptSerializer();
        dynamic d = jss.Deserialize<dynamic>(data);
        object value = ((Dictionary<string, object>)d)["id"].ToString();

        URL = value.ToString();
    }
}