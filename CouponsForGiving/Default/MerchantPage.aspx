<%@ Page Title="" MasterPageFile="~/Site.master" Language="C#" AutoEventWireup="true" CodeFile="MerchantPage.aspx.cs" Inherits="Default_MerchantPage" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>
<%@ MasterType VirtualPath="~/Site.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BannerContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Main_Content" Runat="Server">
    <div class="three-quarters">
        <h1><%: merchant.Name %></h1>
        <a href="<%: merchant.Website %>" target="_blank"><img alt="Our Logo" class="merchant_logo" src="../../<%: merchant.LargeLogo %>" /></a>
        <h3 class="merchant-address"><%: merchant.cAddress + ", " + CouponsForGiving.Data.Classes.Cities.Get(merchant.CityID).Name %></h3>
        <h4 class="merchant-website"><a href="<%: merchant.Website %>" target="_blank"><%: merchant.Website %></a><!-- This can be populated with the company url --></h4>
        <p><%: merchant.cUser.MerchantInfoes.FirstOrDefault<CouponsForGiving.Data.MerchantInfo>().MerchantDescription %></p><!-- This Can be populated with the Merchant Profile -->
    </div>
    <div class="one-quarters">
	    <div class="SocialSidebar">
       	    <h3>Share this Merchant on social media!</h3>
		    <div class="SidebarShare">
		        <img src="../Images/c4g_action_link.png" class="left" />
                <p>Copy & Paste <span class="btn-url"><%: URL %></span></p>
            </div>
		    <div class="SidebarShare" onclick="<%
                if (User.Identity.IsAuthenticated && (merchant.MerchantID == CouponsForGiving.Data.Classes.Merchants.GetByUsername(User.Identity.Name).MerchantID))
                    Response.Write("shareOnFB('" + URL + "', 'Check out our great offer on Coupons4Giving! Buy Great Deals and Share Great Causes " + URL + "', 'https://www.coupons4giving.ca/" + merchant.LargeLogo + "', '" + merchant.Name + "', '')");
                else
                    Response.Write("shareOnFB('" + URL + "', 'I discovered a great offer on Coupons4Giving from " + merchant.Name + "! Buy Great Deals and Share Great Causes " + URL + "', 'https://www.coupons4giving.ca/" + merchant.LargeLogo + "', '" + merchant.Name + "', '')");
            %>">
                <img src="../../Images/c4g_action_facebook.png" class="left" />       
                <span class="btn-facebook-share">Share on Facebook</span>
                <p id="FBMsg"></p>
            </div>
		    <div class="SidebarShare">
		        <img src="../../Images/c4g_action_twitter.png" class="left" />
                <p><a href="https://twitter.com/share" class="twitter-share-button" data-url="<%: URL %>"
                    data-text="<%
                       if (User.Identity.IsAuthenticated && (merchant.MerchantID == CouponsForGiving.Data.Classes.Merchants.GetByUsername(User.Identity.Name).MerchantID))
                           Response.Write("Check out our offers @Coupons4Giving!");
                       else
                           Response.Write("Check out offers from " + merchant.Name + " @Coupons4Giving!");
                       %>" data-hashtags="DealsThatMakeADifference">Tweet</a></p>
            </div>
		    <div class="SidebarShare">
		        <img src="../../Images/c4g_action_linkedin.png" class="left" />
                <%
                    if (User.Identity.IsAuthenticated && (merchant.MerchantID == CouponsForGiving.Data.Classes.Merchants.GetByUsername(User.Identity.Name).MerchantID))
                        Response.Write("<a href=\"http://www.linkedin.com/shareArticle?mini=true&url=" + URL + "&title=" + merchant.Name + "&summary=Check out our great offer on Coupons4Giving! Buy Great Deals and Share Great Causes " + URL + "&source=Coupons4Giving\" rel=\"nofollow\" onclick=\"window.open(this.href,'_blank','location=yes,height=570,width=520,scrollbars=yes,status=yes');return false\" onfocus=\"this.blur()\"><span class=\"btn-facebook-share\">Share on LinkedIn</span></a>");
                    else
                        Response.Write("<a href=\"http://www.linkedin.com/shareArticle?mini=true&url=" + URL + "&title=" + merchant.Name + "&summary=I discovered a great offer on Coupons4Giving from " + Server.UrlEncode(merchant.Name) + "! Buy Great Deals and Share Great Causes " + URL + "&source=Coupons4Giving\" rel=\"nofollow\" onclick=\"window.open(this.href,'_blank','location=yes,height=570,width=520,scrollbars=yes,status=yes');return false\" onfocus=\"this.blur()\"><span class=\"btn-facebook-share\">Share on LinkedIn</span></a>");
                %>
   		    </div>
   	    </div><!-- Close Social Sidebar -->    
    </div><!-- Close On-Quarter Wrapper -->
    <hr>
    <%
                            
        foreach (CouponsForGiving.Data.DealInstance item in deals)
        {
            Response.Write(CouponsForGiving.HttpRendering.GetMerchantOffer(item));
        }
                                    
    %>
</asp:Content>