<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Anon.aspx.cs" Inherits="NPO_Anon" MasterPageFile="~/Site.master" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="BannerContent" runat="server">
    <div class="homeBanners">
        <h2>Coupons4Giving is a fundraising tool that is easy to use! Share great deals to support your cause!</h2><h3>Register for a Coupons4Giving account and get started right away!</h3>
        <img src="../Images/c4g_fundraising_home.png" class="right-fundraising" />
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" runat="server">
    <blockquote><img src="../Images/c4g_npos.png" class="bio_head">Remember those days of selling chocolate almonds door-to-door? Managing those volunteers, keeping track of all those quarters, dimes and nickels! Coupons4Giving makes fundraising easy and secure.</blockquote>
    <hr>
    <h3>It’s easy to build simple and effective campaigns.</h3>
    <p>As a <strong>Not-for-Profit with Coupons4Giving</strong> you will receive up to <strong>25%</strong> from every offer purchased from the Coupons4Giving offers registered to your campaign.</p>
    <div class="tipList">
        <ul>
            <li class="npohomestep1">
                <h4>STEP 1</h4>
                <p><strong>Setup</strong> your <strong>profile page</strong> and fundraising <strong>campaign</strong> with Coupons4Giving</p>
            </li>
            <li class="npohomestep2">
                <h4>STEP 2</h4>
                <p><strong>Select</strong> partners to participate. Select from a list of local merchants or from our Global Marketplace.</p>
            </li>
            <li class="npohomestep3">
                <h4>STEP 3</h4>
                <p><strong>Engage</strong> your local supporters – use our simple social media toolkit to help promote your campaign </p>
            </li>
            <li class="npohomestep4">
            <h4>STEP 4</h4>
            <p><strong>Save</strong> time and reach your goals!</p>
            </li>
        </ul>
    </div>
    <div class="clear"></div>
    <a href="../Account/Register.aspx" class="btn-center">GET STARTED TODAY!</a>
    <hr>
    <h3>Take a Look Around</h3>
    <p>Browse our local deals as well as our <strong>Global Marketplace of E-tailers</strong> (online only merchants)</p>
    <div class="merchantsList">
        <ul>
            <li><img src="../Images/c4g_comingsoon_small.png" class="centered" /></li>
        </ul>
    </div>
    <a href="../Default/DealsInMyArea.aspx" class="btn">MORE MERCHANTS</a>
    <h4 class="centered">OUR FEATURED CAUSES</h4>
    <div class="nposList">
        <ul>
            <li><img src="../Images/c4g_comingsoon_small.png" class="centered" /></li>
        </ul>
        <a href="../Default/CausesInMyArea.aspx" class="btn">MORE CAUSES</a> 
    </div>
</asp:Content>