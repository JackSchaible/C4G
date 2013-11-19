<%@ Page Title="My Merchant Partners" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="MyPartners.aspx.cs" Inherits="NPO_MyPartners_MyPartners" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <h1>My Merchant Partners</h1>
    <p><img src="../../images/c4g_merchantpartners.png" class="circle_image_right" />Coupons4Giving allows you to build a custom list of Merchant Partners. These partners are providing offers for you to add to your campaign. You can add as many merchant offers as you like to your campaigns to help you reach your goals. In order for you to activate a merchant offer for you campaign, that merchant must have offers available that match your campaign timelines. </p>
    <p>Our goal is to provide you with a robust list of exciting merchants to help you run successful campaigns. Adding or refreshing your list of merchants will keep your supporters wanting to come back for more great deals, which in turn helps you make more money. </p>
    <div class="tipList">
        <ul>
            <li class="merchantstep1">
            <h4>Tip 1:</h4>
            Check back frequently for updates to our local and Global Marketplace of E-tailers</li>
            <li class="merchantstep2">
            <h4>Tip 2:</h4>
            Inviting your preferred merchants to sign up for Coupons4Giving enables you to keep connected to merchants who want to support your causes</li>
            <li class="merchantstep3">
            <h4>Tip 3:</h4>
            When you set up your campaigns, you will only see merchant offers that are available for the duration of your campaign. The offers that match are based on when a merchant offer ends. Remember if you are selecting from the list of Local Merchants, to ensure they are servicing your region/city.</li>
            <li class="merchantstep4">
            <h4>Tip 4:</h4>
            You can have as many merchant offers as you want to help you reach your goals. The more the merrier, right? To start with, we recommend about 3-5 merchants per campaign. This way you are giving your supporters choices of coupons to purchase to support your cause.</li>
        </ul>
    </div>
    <h2>See All of Your Merchants</h2>
    <div class="half"> 
        <a class="btn-blue" href="AllPartners.aspx">All Merchants</a> 
        <a class="btn" href="MyGlobalMerchants.aspx">Global Merchants</a>
        <a href="../Campaigns/New.aspx" class="btn">Setup A Campaign</a>
    </div>
    <div class="half">
        <a class="btn" href="MyLocalMerchants.aspx">Local Merchants</a> 
        <a class="btn" href="MyPreferredMerchants.aspx">Preferred Merchants</a>
    </div>
</asp:Content>