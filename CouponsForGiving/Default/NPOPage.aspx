<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeFile="NPOPage.aspx.cs" Inherits="Default_NpoPage" MasterPageFile="~/Site.master" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>
<%@ MasterType VirtualPath="~/Site.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BannerContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Main_Content" Runat="Server"> 
    <div class="three-quarters">             
        <!-- Removed the div #text and also the #NPO-->
        <h1><%: npo.Name %></h1> <!-- Charity/NPO Name --> 
        <p><img alt="Our Logo" class="npo_logo" src="../../<%: npo.Logo %>" /><%: npo.NPODescription %></p><!-- This should be the NPO Profile -->
        <div class="clear"></div>
        <div class="half charity-info">
            <h4>Address</h4>
            <p><%: npo.cAddress %></p> <!-- Pulls The NPO Address -->
            <p><%: npo.City.Name + ", " + npo.City.PoliticalDivision.Name %></p> <!-- Pulls The NPO City and Province -->
        </div>
        <div class="half charity-info">
            <h4>Contact Info</h4>
            <p><strong>Phone</strong>: <%: CouponsForGiving.StringUtils.FormatPhoneNumber(npo.PhoneNumber) %></p> <!-- Pulls The NPO Phone Number -->
            <p><strong>Website</strong>: <a href="<%: npo.Website %>"><%: npo.Website %></a></p> <!-- Pulls The NPO Web Site Address -->
        </div>
    </div>
    <div class="one-quarters">
        <div class="SocialSidebar">
            <h3>Share this NPO on social media!</h3>
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
        <h2>Current Campaigns</h2>
        <p>Want to support our cause, then have a look at the <strong>current campaigns</strong> that we are running.</p>
        <% Response.Write(CouponsForGiving.HttpRendering.ListNPOCampaigns(campaigns));%>
    </div>
    <hr>
</asp:Content>