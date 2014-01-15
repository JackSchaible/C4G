<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Anon.aspx.cs" Inherits="NPO_Anon" MasterPageFile="~/Site.master" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="BannerContent" runat="server">
    <div class="homeBanners">
        <h2>Coupons4Giving is a fundraising tool that is easy to use! Share great deals to support your cause!</h2>
        <h3><a href="../Account/Register.aspx" class="btn-get-started" title="Start Here"><i class="fa fa-arrow-circle-o-right"></i>START HERE</a> <a href="../Account/Register.aspx" title="Register Today!">Register for a Coupons4Giving account and get started right away!</a></h3>
        <img src="../Images/c4g_fundraising_home.png" class="right-fundraising" />
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" runat="server">
    <blockquote><img src="../Images/c4g_npos.png" class="bio_head">Remember those days of selling chocolate almonds door-to-door? Managing those volunteers, keeping track of all those quarters, dimes and nickels! Coupons4Giving makes fundraising easy and secure.</blockquote>
    <hr>
    <h3>It’s easy to build simple and effective campaigns. It's FREE to register!</h3>
    <p>As a <strong>Not-for-Profit with Coupons4Giving</strong>, you will receive <strong>up to 25%</strong> from every offer purchased from the Coupons4Giving offers (coupons) registered to your campaign.</p>
    <div class="tipList">
        <ul>
            <li class="npohomestep1">
                <h4>STEP 1</h4>
                <p><strong>Set up a campaign</strong> with Coupons4Giving.</p>
            </li>
            <li class="npohomestep2">
                <h4>STEP 2</h4>
                <p><strong>Select</strong> from a list of merchant offers or invite your preferred merchants to register with Coupons4Giving and include them in your campaign.</p>
            </li>
            <li class="npohomestep3">
                <h4>STEP 3</h4>
                <p><strong>Engage</strong> your local supporters by using our social media toolkit to help promote your campaign.</p>
            </li>
            <li class="npohomestep4">
            <h4>STEP 4</h4>
            <p><strong>Save time and reach your goals!</strong></p>
            </li>
        </ul>
    </div>
    <div class="clear"></div>
    <a href="../Account/Register.aspx" class="btn-center"><i class="fa fa-arrow-circle-o-right"></i> GET STARTED TODAY!</a>
</asp:Content>