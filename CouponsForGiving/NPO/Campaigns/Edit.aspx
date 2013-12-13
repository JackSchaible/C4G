<%@ Page Title="Edit a Campaign" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Edit.aspx.cs" Inherits="NPO_Campaigns_Edit" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>
<%@ MasterType virtualPath="~/Site.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <div class="two-thirds"> 
        <h1><%: npo.Name %></h1>
        <h3 class="merchant-address"><%: campaign.Name %></h3>
        <h2>About the Campaign</h2>
        <p><img alt="Our Logo" class="merchant_logo" src="../../<%: campaign.CampaignImage %>" /><%: campaign.CampaignDescription %></p> <!-- Campaing Description -->
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
            <h3>Share this Campaign on social media!</h3>
            <div class="SidebarShare">
                <img src="../../images/c4g_action_link.png" class="left" />
                <p>Copy & Paste <%: URL %></p>
            </div>
            <div class="SidebarShare">
                <img src="../../images/c4g_action_facebook.png" class="left" />       
                <p class="btw" onclick="shareOnFB()">Share on Facebook</p>
                <p id="FBMsg"></p>
            </div>
            <div class="SidebarShare">
                <img src="../../images/c4g_action_twitter.png" class="left" />
                <p><a href="https://twitter.com/share" class="twitter-share-button" data-url="<%: URL %>"
                data-text="<%: Caption %>" data-hashtags="C4G, DealsThatMakeADifference">Tweet</a></p>
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
        <% Response.Write(CouponsForGiving.HttpRendering.ListCampaignDealsForNPO(deals)); %>
    </div>
    <hr>
</asp:Content>