<%@ Page Title="Edit a Campaign" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Edit.aspx.cs" Inherits="NPO_Campaigns_Edit" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>
<%@ MasterType virtualPath="~/Site.master" %>

<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <script type="text/javascript">
        var campaignID = <%: campaign.CampaignID%>;
        var campaignName = "<%: Uri.EscapeDataString(campaign.Name) %>";
        var startDate = "<%: campaign.StartDate %>";
        var endDate = "<%: campaign.EndDate %>";
        var description = "<%: Uri.EscapeDataString(campaign.CampaignDescription) %>";
        var campaignImage = "<%: campaign.CampaignImage %>";
        var goal = <%: campaign.FundraisingGoal %>;
        var imageFile = "";
        var imageType = "";
        var featured = <%: campaign.ShowOnHome.Value ? "true" : "false" %>;
        var campaignGoal = "<%: Uri.EscapeDataString(campaign.CampaignGoal) %>";

        function imgUploadStarted() {
            $("#LoadingImg").html('<img alt="Loading" src="../../Images/loading.gif" />');
        }

        function fileUploadComplete() {
            $("#LoadingImg").html('');
        }

        function edit() {
            $("#ModeButton").text("Save");
            $("#ModeButton").attr('href', 'javascript:Save()');
            $("#CancelButton").css("display", "inherit");

            $("#EditCampaignName").html('<input type="text" maxLength="256" id="NameTextBox" value="' + decodeURIComponent(campaignName) + '" />');
            $("#EditCampaignDescription").html('<textarea id="DescriptionTextBox">' + decodeURIComponent(description) + '</textarea>');
            $("#EditCampaignGoal").html('<textarea id="CampaignGoal" maxLength="256">' + decodeURIComponent(campaignGoal) + '</textarea>');
        }

        function save() {
        }

        function cancel() {
        }
    </script>
    <div class="two-thirds"> 
        <a href="javascript:edit()" class="btn-center" id="ModeButton">Edit</a>
        <a href="javascript:cancel()" class="btn-center" id="CancelButton" style="display: none;">Cancel</a>
        <span id="ErrorMessages"></span>
        <h1><%: npo.Name %></h1>
        <div id="EditCampaignName">
            <h3 class="merchant-address"><%: campaign.Name %></h3>
        </div>
        <h2>About the Campaign</h2>
        <p>
            <div id="EditImage">
                <img alt="Our Logo" class="merchant_logo" src="../../<%: campaign.CampaignImage %>" />
                <div id="LoadingImg"></div>
            </div>
            <div id="EditCampaignDescription">
                <%: campaign.CampaignDescription %>
            </div>
        </p> <!-- Campaing Description -->
        <p><strong>Date Running</strong>: <%: campaign.StartDate.Value.ToString("MMMM dd, yyyy") %> - <%: campaign.EndDate.Value.ToString("MMMM dd, yyyy") %></p>
        <hr>
        <h2>Campaign Details</h2>
        <div class="three-quarters charity-info">
            <h4>The Funds Will Be Used For</h4>
            <div id="EditCampaignGoal">
                <p><%: campaign.CampaignGoal %></p><!-- Fund Description -->
            </div>
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