<%@ Page Title="Thank You" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Confirmation.aspx.cs" Inherits="Merchant_Confirmation" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <h1>Congratulations, You've Just Created Your Profile With Coupons4Giving!</h1>
    <div class="actionList">
        <ul>
            <li class="thumb">Your unique <strong>Coupons4Giving profile page</strong> is <strong><a href='https://www.coupons4giving.ca/Causes/<%: merchant.Name %>'>coupons4giving.ca/Causes/<%: merchant.Name %></a></strong></li>
        </ul>
    </div>
    <hr>
        <UC:ShareControl ID='ShareControl1' runat='server' Share='Profile' CType='Campaign'
            Name='<%# merchant.Name %>' ImageURL='<%# "https://www.coupons4giving.ca/" + merchant.LargeLogo %>' Description='<%# merchant.cUser.MerchantInfoes.FirstOrDefault<CouponsForGiving.Data.MerchantInfo>().MerchantDescription %>' />
    <hr>
    <p>If you have any questions, please contact us at <a href="mailto:support@coupons4giving.ca">support@coupons4giving.ca.</a></p>
    <p>Now you are ready for <strong>Step 2: set up your offers with Coupons4Giving!</strong></p>
    <a class="btn-center" href="Offers/New.aspx">Get Started!</a>
</asp:Content>