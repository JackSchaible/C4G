using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.AspNet.Membership.OpenAuth;
using System.Web.Routing;
using Microsoft.AspNet.FriendlyUrls;

namespace CouponsForGiving
{
    public static class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.Ignore("{resource}.axd/{*pathInfo}");
            routes.MapPageRoute("DefaultPage", "Causes/{nponame}", "~/Default/NPOPage.aspx");
            routes.MapPageRoute("CampaignPage", "Causes/{nponame}/{campaignname}", "~/Default/CampaignPage.aspx"); //This one routes a lot of other requests
            routes.EnableFriendlyUrls();
        }
    }
}