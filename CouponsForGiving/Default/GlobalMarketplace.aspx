<%@ Page Title="Global Marketplace" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="GlobalMarketplace.aspx.cs" Inherits="Default_GlobalMarketplace" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            $("#showContent").hide();
            $("#state").val("hidden");
        });

        function showHide() {
            if ($("#state").val() == "hidden") {
                $("#showContent").slideDown(400);
                $("#LinkText").text('Hide');
                $("#state").val("shown");
            }
            else if ($("#state").val() == "shown"){
                $("#showContent").slideUp(400);
                $("#state").val("hidden");
                $("#LinkText").text('Read More');
            }
        }
    </script>
    <h1>Global Marketplace</h1>
    
    <h2>Welcome to the Coupons4Giving Global Marketplace!</h2>

<p>Our goal is to provide online merchants from around the globe the opportunity to support great causes with offers and discounts on unique products and services. Not-For-Profits can select Global Marketplace merchants to add to their Merchant Partner list. This is a great way to empower both merchants and not-for-profits with new opportunities and new connections.</p>

<a id="showButton" href="javascript:showHide()" class="btn-xsmall"> <i class="fa-arrow-circle-o-down fa"></i> <span id="LinkText">Read More</span></a>

<p id="state" class="hide"></p>
<div id="showContent" class="more-content">
<p>Customers can purchase coupons that are redeemable for a wide range of products and services from global merchants. As Coupons4Giving only sells coupons, we will connect you directly with a global merchant to redeem your coupon. </p>

<p>Many of our global merchants have been sourced in areas of the world where fair trade, environmental best practices and economic sustainability are essential to both community values and business models. By supporting your favorite not-for-profit cause with a coupon from a global marketplace merchant you are getting a double-wammy on greatness! <strong>We call this cause-for-cause marketing</strong>.</p>

<p>If you have any suggestions for online retailers we should meet and add to our marketplace please email us at <a href="mailto:info@coupons4giving.ca" target="_blank">info@coupons4giving.ca</a>.</p>
</div>

<hr />
    <div id="Deals">
        <% Response.Write(CouponsForGiving.HttpRendering.ListMerchantOffers(DIs)); %>
    </div>
</asp:Content>