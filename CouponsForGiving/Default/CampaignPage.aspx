﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="CampaignPage.aspx.cs" Inherits="Default_NpoPage" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>
<%@ MasterType VirtualPath="~/Site.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BannerContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Main_Content" Runat="Server">
    <div class="three-quarters"><!-- Removed the div #text and also the #NPO-->
        <h1><%: campaign.Name %></h1> <!-- Campaing Name -->
        <h3 class="npo-name"><%: npo.Name %><img alt="Our Logo" class="campaign_logo" src="../../<%: npo.Logo %>" /></h3>
        <h2>About the Campaign</h2>
        <p><%: campaign.CampaignDescription %></p> <!-- Campaing Description -->
        <p><strong>Date Running</strong>: <%: campaign.StartDate.Value.ToString("MMMM dd, yyyy") %> - <%: campaign.EndDate.Value.ToString("MMMM dd, yyyy") %></p>
        <hr>
        <h2>Campaign Details</h2>
        <div class="three-quarters charity-info">
            <h4>The Funds Will Be Used For</h4>
            <p><%: campaign.CampaignGoal %></p><!-- Fund Description -->
            <h4>Target Goal</h4> 
            <p class="campaign-goal"><%: ((decimal)(campaign.FundraisingGoal)).ToString("C") %></p> <!-- Fund Goal -->
        </div>
        <div class="thermometer-wrap"> 
            <span class="thermometer"></span><span class="thermometer-raised"><%: (from po in campaign.PurchaseOrders where po.OrderStatusID != 3 select po.NPOSplit).Sum().ToString("C") %></span>
        </div><!-- Progress Meter --> 
    </div>
    <div class="one-quarters">
        <div class="SocialSidebar">
            <h3>Share this Campaign on social media!</h3>
            <div class="SidebarShare">
                <img src="../../images/c4g_action_link.png" class="left" />
                <p>Copy & Paste <span class="btn-url"><%: URL %></span></p>
            </div>
            <div class="SidebarShare">
                <img src="../../images/c4g_action_facebook.png" class="left" />  
                <%
                    if (User.Identity.IsAuthenticated && (npo.NPOID == CouponsForGiving.Data.Classes.NPOs.NPO_GetByUser(User.Identity.Name).NPOID))
                        Response.Write("<span class=\"btn-facebook-share\" onclick=\"shareOnFB('" + URL + "', 'Check out our campaign on Coupons4Giving! Buy Great Deals and Share Great Causes " + URL + "', 'https://www.coupons4giving.ca/" + campaign.CampaignImage + "', '" + campaign.Name + "', '')\">Share on Facebook</span>");
                    else
                        Response.Write("<span class=\"btn-facebook-share\" onclick=\"shareOnFB('" + URL + "', 'I discovered a great cause on Coupons4Giving. Help support " + npo.Name + ". Buy Great Deals and Share Great Causes " + URL + "', 'https://www.coupons4giving.ca/" + campaign.CampaignImage + "', '" + campaign.Name + "', '')\">Share on Facebook</span>");
                %>     
                <p id="FBMsg"></p>
            </div>
            <div class="SidebarShare">
                <img src="../../images/c4g_action_twitter.png" class="left" />
                <p><a href="https://twitter.com/share" class="twitter-share-button" data-url="<%: URL %>"
                data-text="<% 
                    if (User.Identity.IsAuthenticated && (npo.NPOID == CouponsForGiving.Data.Classes.NPOs.NPO_GetByUser(User.Identity.Name).NPOID))
                    {
                        Response.Write("Check out our campaign on @Coupons4Giving! Buy Great Deals and Share Great Causes!");
                    }
                    else
                        Response.Write("I discovered a great cause @Coupons4giving. Buy Great Deals and Share Great Causes!");%>" data-hashtags="DealsThatMakeADifference">Tweet</a></p>
            </div>
            <div class="SidebarShare">
                <img src="../../images/c4g_action_linkedin.png" class="left" />
                <% 
                    if (User.Identity.IsAuthenticated && (npo.NPOID == CouponsForGiving.Data.Classes.NPOs.NPO_GetByUser(User.Identity.Name).NPOID))
                        Response.Write("<a href=\"http://www.linkedin.com/shareArticle?mini=true&url=" + URL + "&title=" + campaign.Name + "&summary=\"Check out our campaign on Coupons4Giving! Buy Great Deals and Share Great Causes " + URL + "&source=Coupons4Giving\" rel=\"nofollow\" onclick=\"window.open(this.href,'_blank','location=yes,height=570,width=520,scrollbars=yes,status=yes');return false\" onfocus=\"this.blur()\"><span class=\"btn-facebook-share\">Share on LinkedIn</span></a>");
                    else
                        Response.Write("<a href=\"http://www.linkedin.com/shareArticle?mini=true&url=" + URL + "&title=" + campaign.Name + "&summary=\"I discovered a great cause on Coupons4Giving. Help support " + npo.Name + ". Buy Great Deals and Share Great Causes " + URL + "&source=Coupons4Giving\" rel=\"nofollow\" onclick=\"window.open(this.href,'_blank','location=yes,height=570,width=520,scrollbars=yes,status=yes');return false\" onfocus=\"this.blur()\"><span class=\"btn-facebook-share\">Share on LinkedIn</span></a>");
                %>
            </div>
        </div>
    </div>
    <hr>
    <div id="Campaigns">
        <h2>Campaign Deals</h2>
        <p>Want to support our campaign, then have a look at the deals from these great <strong>Merchants</strong>.</p>
        <% Response.Write(CouponsForGiving.HttpRendering.ListCampaignDeals(deals)); %>
    </div>
    <hr>
</asp:Content>