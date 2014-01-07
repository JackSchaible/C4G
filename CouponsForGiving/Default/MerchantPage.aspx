<%@ Page Title="" MasterPageFile="~/Site.master" Language="C#" AutoEventWireup="true" CodeFile="MerchantPage.aspx.cs" Inherits="Default_MerchantPage" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>
<%@ MasterType VirtualPath="~/Site.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BannerContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Main_Content" Runat="Server">
    <%--<div class="three-quarters">--%>
        <h1><%: merchant.Name %></h1>
        <img alt="Our Logo" class="merchant_logo" src="../../<%: merchant.LargeLogo %>" />
        <h3 class="merchant-address"><%: merchant.cAddress + ", " + CouponsForGiving.Data.Classes.Cities.Get(merchant.CityID).Name %></h3>
        <h4 class="merchant-website"><a href="<%: merchant.Website %>" target="_blank">Company Web Site</a><!-- This can be populated with the company url --></h4>
        <p><%: merchant.cUser.MerchantInfoes.FirstOrDefault<CouponsForGiving.Data.MerchantInfo>().MerchantDescription %></p><!-- This Can be populated with the Merchant Profile -->
    </div>
    <div class="one-quarters">
	    <div class="SocialSidebar">
       	    <h3>Share this Merchant on social media!</h3>
		    <div class="SidebarShare">
		        <img src="../Images/c4g_action_link.png" class="left" />
                <p>Copy & Paste <%: URL %></p>
            </div>
		    <div class="SidebarShare" onclick="shareOnFB()">
                <img src="../../Images/c4g_action_facebook.png" class="left" />       
                <p class="btw" >Share on Facebook</p>
                <p id="FBMsg"></p>
            </div>
		    <div class="SidebarShare">
		        <img src="../../Images/c4g_action_twitter.png" class="left" />
                <p><a href="https://twitter.com/share" class="twitter-share-button" data-url="<%: URL %>"
                    data-text="<%: Caption %>" data-hashtags="C4G, DealsThatMakeADifference">Tweet</a></p>
            </div>
		    <div class="SidebarShare">
		        <img src="../../Images/c4g_action_linkedin.png" class="left" />
                <p onclick="shareOnLinkedIn()">Share on LinkedIn</p>
   		    </div>
   	    </div><!-- Close Social Sidebar -->    
    </div><!-- Close On-Quarter Wrapper -->
    <hr>
    <%
                            
        foreach (CouponsForGiving.Data.DealInstance item in deals)
        {
            Response.Write(CouponsForGiving.HttpRendering.GetMerchantOffer(item.Deal));
        }
                                    
    %>
</asp:Content>