<%@ Page Title="My Home" MasterPageFile="~/Site.master" Language="C#" AutoEventWireup="true" CodeFile="MyHome.aspx.cs" Inherits="Default_My_MyHome" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>
<%@ MasterType VirtualPath="~/Site.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BannerContent" Runat="Server">
    <div class="homeBanners">
        <h2>Whether you search by deals or Not-For-Profits you can support great causes in just one click.</h2>
        <img src="../Images/c4g_heartinhand_home.png" class="right-heartinhand" /> 
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Main_Content" Runat="Server">
    <h3>Take a Look Around</h3>
    <p>Browse our local deals as well as our Global Marketplace of Online Merchants </p>
    <h4 class="centered">OUR FEATURED DEALS</h4>
    <div class="merchantsList">
        <ul>
            <li><img src="../Images/c4g_comingsoon_small.png" class="centered" /></li>
        </ul>
    </div>
    <a href="DealsInMyArea.aspx" class="btn-blue">MORE MERCHANTS</a>
    <h4 class="centered">OUR FEATURED CAUSES</h4>
    <div class="nposList">
        <ul>
            <li><img src="../Images/c4g_comingsoon_small.png" class="centered" /></li>
        </ul>
        <a href="CausesInMyArea.aspx" class="btn-blue">MORE CAUSES</a>
    </div>
    <hr>
    <h3>Support Your Favorite Not-For-Profit</h3>
    <ul class="tipList">
        <li class="homestep1">
            <h4>STEP 1:</h4>
            <p><strong>Choose</strong> your favourite organization.</p>
        </li>
        <li class="homestep2">
            <h4>STEP 2</h4>
            <p><strong>Select</strong> the restaurant or business that is fundraising for your group.</p>
        </li>
        <li class="homestep3">
            <h4>STEP 3</h4>
            <p><strong>Purchase</strong> the deal – a coupon or discount.</p>
        </li>
        <li class="homestep4">
            <h4>STEP 4</h4>
            <p><strong>Redeem</strong> the offer in-store on your next visit or directly online from our Global Marketplace.</p>
        </li>
    </ul>
    <blockquote>Whether you are raising money, looking for a great restaurant or you are a merchant who wants to support local community groups, <strong>Coupons4Giving makes it easy!</strong></blockquote>
    <div class="clear"></div>
    <a href="../Account/Register.aspx" class="btn-center">GET STARTED TODAY!</a>

</asp:Content>