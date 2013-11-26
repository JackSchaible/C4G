<%@ Page Title="Thank You" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Confirmation.aspx.cs" Inherits="Merchant_Confirmation" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <h1>Thank You for Signing up with Coupons4Giving!</h1>
    <p>Thanks for registering with Coupons4Giving. A team member will be in touch with shortly with some tips on how to get started! In the meantime if you have any questions, please contact us at <a href="mailto:support@couponsforgiving.ca">support@coupons4giving.ca.</a></p> 
    <p>Your unique Coupons4Giving profile page is <a href='www.coupons4giving.ca/Default/MerchantPage.aspx?MerchantName=<%: Server.UrlEncode(merchant.Name) %>'>coupons4giving.ca/<%: merchant.Name %></a></p>
    <UC:ShareControl ID='ShareControl' runat='server' Share='Profile' CType="Offer"
        Name='<%# merchant.Name %>' ImageURL='<%# "https://www.coupons4giving.ca/" + merchant.LargeLogo %>' 
        Description='<%# merchant.cUser.MerchantInfoes.First<CouponsForGiving.Data.MerchantInfo>().MerchantDescription %>' />
    <p>Now you are ready for step 2: set up offers with Coupons4Giving!</p>
    <a class="HeaderButton" href="Offers/New.aspx">Get Started!</a>
    <p>If you have any Not-For-Profits you'd like to partner with, or invite to join Coupons4Giving, <a href="Partners/Add.aspx" class="btn">click here</a> to add or invite them!</p>
</asp:Content>