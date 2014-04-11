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
        <p><a href="<%: npo.Website %>" target="_blank"><img alt="Our Logo" class="npo_logo" src="../../<%: npo.Logo %>" /></a><%: npo.NPODescription %></p><!-- This should be the NPO Profile -->
        <div class="clear"></div>
        <div class="half charity-info">
            <h4>Address</h4>
            <p><%: npo.cAddress %></p> <!-- Pulls The NPO Address -->
            <p><%: npo.City.Name + ", " + npo.City.PoliticalDivision.Name %></p> <!-- Pulls The NPO City and Province -->
        </div>
        <div class="half charity-info">
            <h4>Contact Info</h4>
            <p><strong>Phone</strong>: <%: CouponsForGiving.StringUtils.FormatPhoneNumber(npo.PhoneNumber) %></p> <!-- Pulls The NPO Phone Number -->
            <p><strong>Website</strong>: <a href="<%: npo.Website %>" target="_blank"><%: npo.Website %></a></p> <!-- Pulls The NPO Web Site Address -->
        </div>
    </div>
    <div class="one-quarters">
        <div class="SocialSidebar">
            <h3>Share this NPO on social media!</h3>
            <div class="SidebarShare">
                <img src="../../images/c4g_action_link.png" class="left" />
                <p>Copy & Paste <span class="btn-url"><%: URL %></span></p>
            </div>
            <div class="SidebarShare" onclick="shareOnFB('<%: URL %>', 'I discovered a great cause on Coupons4Giving. Help support <%: npo.Name %>! Buy Great Deals and Share Great Causes <%: URL %>', 'https://www.coupons4giving.ca/<%: npo.Logo %>', '<%: npo.Name %>', '')">
                <img src="../../Images/c4g_action_facebook.png" class="left" />       
                <span class="btn-facebook-share">Share on Facebook</span>
                <p id="FBMsg"></p>
            </div>
            <div class="SidebarShare">
                <img src="../../images/c4g_action_twitter.png" class="left" />
                <p><a href="https://twitter.com/share" class="twitter-share-button" data-url="<%: URL %>"
                data-text="I discovered a great cause @coupons4giving. Buy Great Deals and Share Great Causes!" data-hashtags="DealsThatMakeADifference">Tweet</a></p>
            </div>
            <div class="SidebarShare">
                <img src="../../images/c4g_action_linkedin.png" class="left" />
                <a href="http://www.linkedin.com/shareArticle?mini=true&url=<%: URL %>&title=<%: npo.Name %>&summary=<%: "I discovered a great cause on Coupons4Giving. Help support " + npo.Name + "! Buy Great Deals and Share Great Causes " + URL %>&source=Coupons4Giving" rel="nofollow" onclick="window.open(this.href,'_blank','location=yes,height=570,width=520,scrollbars=yes,status=yes');return false" onfocus="this.blur()"><span class="btn-facebook-share">Share on LinkedIn</span></a>
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