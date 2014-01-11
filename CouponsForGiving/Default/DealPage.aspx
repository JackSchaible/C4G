<%@ Page Title="" MasterPageFile="~/Site.master" Language="C#" AutoEventWireup="true" CodeFile="DealPage.aspx.cs" Inherits="Default_DealPage" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>
<%@ MasterType VirtualPath="~/Site.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BannerContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Main_Content" Runat="Server">  
    <script type="text/javascript">
        function addToCart(dealID, campaignID) {
            if (arguments.length == 1) {
                PageMethods.AddDealToCart(dealID, function () {
                    window.location.replace("My/Cart.aspx");
                }, function () {
                    window.location.replace("My/Cart.aspx");
                });
            }
            else if (arguments.length == 2) {
                PageMethods.AddToCart(dealID, campaignID, function () {
                    window.location.replace("My/Cart.aspx");
                }, function () {
                    window.location.replace("My/Cart.aspx");
                });
            }
        }
    </script>
        <article class="c4g-coupon">
            <img src="../../Images/c4g_coupon_logo.png" class="coupon_c4g_logo" /> 
            <div class="coupon-title">
                <h2><%: deal.Name %></h2><!-- Merchant Offer -->
                <h3><a href="" target="_blank"><%: deal.Merchant.Name %></a></h3><!-- Merchant Name -->
                <span class="coupon-description">
                <p><%: deal.DealDescription %></p><!-- Merchant Offer Description -->
                </span>
		            <div class="coupon-details">
        	            <div class="coupon-value">
            	        <h4>Value</h4>
                	    <p><span>$<%: ((int)(deal.Prices.FirstOrDefault<CouponsForGiving.Data.Price>().RetailValue)).ToString("D") %></span></p> <!-- Coupon Value -->
               		</div> <!-- Close Coupon Value-->
                
                	<div class="coupon-discount">
                    	<h4>Discount</h4> 
                    	<p><span><%: (1 - (deal.Prices.FirstOrDefault<CouponsForGiving.Data.Price>().GiftValue / deal.Prices.FirstOrDefault<CouponsForGiving.Data.Price>().RetailValue)).ToString("0%") %></span></p> <!-- Coupon Savings/Discount -->
               		</div> <!-- Close Coupon Discount-->
               		
                	<div class="coupon-giving">
                    	<h4>You're Giving</h4>
                    	<p><span>$<%: ((int)(deal.Prices.FirstOrDefault<CouponsForGiving.Data.Price>().NPOSplit)).ToString("D") %></span></p> <!-- NPO Return or portion -->
                	</div> <!-- Close Coupon Giving Amount-->
                	<div class="coupon-left">
                         <h4>Coupons Left</h4>
                         <p><span><%: deal.AbsoluteCouponLimit - dealInstance.PurchaseOrders.Count %></span></p>
                    </div>
                   </div>
             
            <h5>Share this Deal on social media!</h5>
                <div class="coupon-social">
                 	<img src="../../Images/c4g_action_link.png" />
               		<p>Copy & Paste <%: URL %></p>
                 </div>
                 <div class="coupon-social">
               		<img src="../../Images/c4g_action_facebook.png" />       
                	<p class="btn" onclick="shareOnFB()">Share on Facebook</p>
                	<p id="FBMsg"></p>
                 </div>
                 <div class="coupon-social">                
                 	<img src="../../Images/c4g_action_twitter.png" />
                	<p><a href="https://twitter.com/share" class="twitter-share-button" data-url="<%: URL %>"
                    data-text="<%: Caption %>" data-hashtags="C4G, DealsThatMakeADifference">Tweet</a></p>
                 </div>
                 <div class="coupon-social">
                	<img src="../../Images/c4g_action_linkedin.png" />
                	<p onclick="shareOnLinkedIn()">Share on LinkedIn</p>
                </div>

			</div><!-- Close Details -->            
            
           	<div class="coupon-image-block">
                <img src="../../<%: deal.ImageURL %>" /> <!-- Pulled From Merchant Profile -->
	            <a href="javascript:addToCart(<%:dealInstance.DealInstanceID%>)" class="btn-buy-now"><i class="fa fa-shopping-cart"></i> BUY NOW!</a>
            
        	    <div class="coupon-info">
    	        	<p class="coupon-date"><span>Dates:</span> <%: deal.DealInstances.FirstOrDefault<CouponsForGiving.Data.DealInstance>().StartDate.ToString("MMMM dd, yyyy") %> - <%: deal.DealInstances.FirstOrDefault < CouponsForGiving.Data.DealInstance>().EndDate.ToString("MMMM dd, yyyy") %> </p> <!-- Dates of Campaign/Offer -->
           		</div><!-- Close Coupon Info-->
            </div><!-- Close Image Block-->
           
            <div class="clear"></div>
        </article><!-- Close Full Coupon Details Div -->
        <hr>
        <%
            foreach (CouponsForGiving.Data.Campaign c in (from c in deal.DealInstances.FirstOrDefault<CouponsForGiving.Data.DealInstance>().Campaigns where c.CampaignStatusID == 2 select c))
            {
                Response.Write(CouponsForGiving.HttpRendering.GetNPOCampaign(c, deal.DealInstances.FirstOrDefault<CouponsForGiving.Data.DealInstance>()));
            }
            
            if (deal.FinePrints.Count > 0)
            {
                Response.Write("<h2>Fine Print</h2><ul>");
                foreach (CouponsForGiving.Data.FinePrint item in deal.FinePrints)
                    Response.Write("<li>" + item.Content + "</li>");
                Response.Write("</ul>");
            }       
            
            if (deal.MerchantLocations.Count > 0)
            {
                Response.Write("<h2>Fine Print</h2><h4>Participating Merchant Locations</h4>");
                Response.Write("<ul>");
                foreach (CouponsForGiving.Data.MerchantLocation ml in deal.MerchantLocations)
                {
                    Response.Write(String.Format("<div><li class=\"Location-Address\">{0}<br />{1}, {2}</li></div>", ml.cAddress, ml.City.Name, ml.City.PoliticalDivision.Name));
                }
                Response.Write("</ul>");
            }
        %>
        <h4>Restrictions</h4>
        <p><%: deal.RedeemDetails.FirstOrDefault<CouponsForGiving.Data.RedeemDetail>().AdditionalDetails %></p>
        <hr>
        <h1><%: deal.Merchant.Name %></h1>
        <img alt="Our Logo" class="merchant_logo" src="../../<%: deal.Merchant.LargeLogo %>" />
        <h3 class="merchant-address"><%: deal.Merchant.cAddress + ", " + CouponsForGiving.Data.Classes.Cities.Get(deal.Merchant.CityID).Name + ", " +  CouponsForGiving.Data.Classes.Cities.Get(deal.Merchant.CityID).PoliticalDivision.Name %></h3><!-- I figure we can populate this content with Merchant Address -->
        <h4 class="merchant-website"><a href="<%: deal.Merchant.Website %>" target="_blank"><%: merchant.Website %></a><!-- This can be populated with the company url --></h4>
        <p><%: deal.Merchant.cUser.MerchantInfoes.FirstOrDefault<CouponsForGiving.Data.MerchantInfo>().MerchantDescription %></p><!-- This Can be populated with the Merchant Profile -->
    </div><!-- Close Two-Thirds Wrapper -->

</asp:Content>