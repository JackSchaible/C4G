<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeFile="CampaignPage.aspx.cs" Inherits="Default_NpoPage"  MasterPageFile="~/Site.master"%>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>
<%@ MasterType VirtualPath="~/Site.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BannerContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Main_Content" Runat="Server">
    <div class="two-thirds"><!-- Removed the div #text and also the #NPO-->
        <h1><%: campaign.Name %></h1> <!-- Campaing Name -->
        <h3 class="npo-name"><%: npo.Name %></h3><!-- This should be the Charity Name -->
        <h2>About the Campaign</h2>
        <p><img alt="Our Logo" class="campaign_logo" src="../../<%: npo.Logo %>" /><%: campaign.CampaignDescription %></p> <!-- Campaing Description -->
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
    <div class="thirds">
        <div class="SocialSidebar">
            <h3>Share this NPO on social media!</h3>
            <div class="SidebarShare">
                <img src="../../images/c4g_action_link.png" class="left" />
                <p>Copy & Paste <%: URL %></p>
            </div>
            <div class="SidebarShare">
                <img src="../../images/c4g_action_facebook.png" class="left" />       
                <p class="btw" onclick="shareOnFB('<%: URL %>', 'Help support our cause <%: npo.Name %> <%: campaign.Name %> and buy a great deal from Coupons4Giving!', 'https://www.coupons4giving.ca/<%: campaign.CampaignImage %>', '<%: campaign.Name %>', '<%: campaign.CampaignDescription %>')">Share on Facebook</p>
                <p id="FBMsg"></p>
            </div>
            <div class="SidebarShare">
                <img src="../../images/c4g_action_twitter.png" class="left" />
                <p><a href="https://twitter.com/share" class="twitter-share-button" data-url="<%: URL %>"
                data-text="Help us reach our <%: campaign.Name %> goals and buy a great deal on @Coupons4Giving!" data-hashtags="DealsThatMakeADifference">Tweet</a></p>
            </div>
            <div class="SidebarShare">
                <img src="../../images/c4g_action_linkedin.png" class="left" />
                <p onclick="shareOnLinkedIn()">Share on LinkedIn</p>
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