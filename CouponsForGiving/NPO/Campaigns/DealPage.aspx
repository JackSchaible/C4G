<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeFile="DealPage.aspx.cs" Inherits="Default_DealPage" MasterPageFile="~/Site.master" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>
<%@ MasterType VirtualPath="~/Site.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BannerContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Main_Content" Runat="Server">
        <div class="two-thirds">             
            <article class="c4g-coupon">
                <img src="../../Images/c4g_coupon_logo.png" class="coupon_c4g_logo" /> 
                <div class="coupon-title">
                    <h2><%: deal.Name %></h2><!-- Merchant Offer -->
                    <h3><%: deal.Merchant.Name %></h3><!-- Merchant Name -->
                    <p><%: deal.DealDescription %></p><!-- Merchant Offer Description -->
                </div><!--Close Coupon Title -->
                <div class="coupon-image-block">
                    <img src="../../<%: deal.ImageURL %>" /> <!-- Pulled From Merchant Profile -->
                </div><!-- Close Image Block-->
                <div class="clear"></div>
                <div class="coupon-details">
                    <div class="coupon-value">
                        <h4>Value</h4>
                        <p><span>$<%: ((int)(deal.Prices.FirstOrDefault<CouponsForGiving.Data.Price>().RetailValue)).ToString("D") %></span></p> <!-- Coupon Value -->
                    </div> <!-- Close Coupon Value-->
                    <div class="coupon-discount">
                        <h4>Discount</h4> 
                        <p><span><%: (1 - (deal.Prices.FirstOrDefault<CouponsForGiving.Data.Price>().GiftValue / deal.Prices.FirstOrDefault<CouponsForGiving.Data.Price>().RetailValue)).ToString("0%") %></span></p> <!-- Coupon Savings/Discount -->
                    </div> <!-- Close Coupon Value-->
                    <div class="coupon-giving">
                        <h4>You're Giving</h4>
                        <p><span>$<%: ((int)(deal.Prices.FirstOrDefault<CouponsForGiving.Data.Price>().NPOSplit)).ToString("D") %></span></p> <!-- NPO Return or portion -->
                    </div> <!-- Close Coupon Value-->
                </div><!-- Close Details -->
                <div class="coupon-info">
                    <p class="coupon-date"><span>Dates:</span> <%: deal.DealInstances.FirstOrDefault < CouponsForGiving.Data.DealInstance>().StartDate.ToString("MMMM dd, yyyy") %> - <%: deal.DealInstances.FirstOrDefault < CouponsForGiving.Data.DealInstance>().EndDate.ToString("MMMM dd, yyyy") %> </p> <!-- Dates of Campaign/Offer -->
                </div><!-- Close Coupon Info-->
                <div class="clear"></div>
            </article><!-- Close Full Coupon Details Div -->
            <hr>
            <%
                foreach (CouponsForGiving.Data.Campaign c in (from c in deal.DealInstances.FirstOrDefault<CouponsForGiving.Data.DealInstance>().Campaigns where c.CampaignStatusID == 2 && c.NPOID == CouponsForGiving.Data.Classes.NPOs.NPO_GetByUser(User.Identity.Name).NPOID select c))
                {
                    Response.Write(CouponsForGiving.HttpRendering.GetNPOCampaign(c, deal.DealInstances.FirstOrDefault<CouponsForGiving.Data.DealInstance>()));
                }
            %>
            <h2>Fine Print</h2> 
            <ul>
                <%
                    foreach (CouponsForGiving.Data.FinePrint item in deal.FinePrints)
                        Response.Write("<li>" + item.Content + "</li>");
                %>
            </ul>
            <h4>Restrictions</h4>
            <p><%: deal.RedeemDetails.FirstOrDefault<CouponsForGiving.Data.RedeemDetail>().AdditionalDetails %></p>
            <hr>
            <h1><%: deal.Merchant.Name %></h1>
            <img alt="Our Logo" class="merchant_logo" src="../../<%: deal.Merchant.LargeLogo %>" />
            <h3 class="merchant-address"><%: deal.Merchant.cAddress + ", " + deal.Merchant.MerchantLocations.FirstOrDefault<CouponsForGiving.Data.MerchantLocation>().City.Name + ", " + deal.Merchant.MerchantLocations.FirstOrDefault<CouponsForGiving.Data.MerchantLocation>().City.PoliticalDivision.Name %></h3><!-- I figure we can populate this content with Merchant Address -->
            <h4 class="merchant-website"><a href="<%: deal.Merchant.Website %>" target="_blank"><%: merchant.Website %></a><!-- This can be populated with the company url --></h4>
            <p><%: deal.Merchant.cUser.MerchantInfoes.FirstOrDefault<CouponsForGiving.Data.MerchantInfo>().MerchantDescription %></p><!-- This Can be populated with the Merchant Profile -->
    </div><!-- Close Two-Thirds Wrapper -->
    <div class="thirds">
        <div class="SocialSidebar">
            <h3>Share this Deal on social media!</h3>
            <div class="SidebarShare">
                <img src="../../Images/c4g_action_link.png" class="left" />
                <p>Copy & Paste <%: URL %></p>
            </div>
            <div class="SidebarShare">
                <img src="../../Images/c4g_action_facebook.png" class="left" />       
                <p class="btw" onclick="shareOnFB()">Share on Facebook</p>
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
        </div>    
    </div>    
</asp:Content>