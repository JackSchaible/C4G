<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Home" MasterPageFile="~/Site.master" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>
<%@ MasterType VirtualPath="~/Site.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="LandingBanner" Runat="Server">
    <section id="LandingCarousel">
        <div class="SlideBanners">
            <ul>
                <li class="coupons">
                    <div class="content">
                        <div class="two-thirds"><h2><strong>Coupons4Giving</strong> is an fundraising tool that allows you to support your favourite <strong>not-for-profit organization in just one click!</strong></h2>
                            <a href="Default/CausesInMyArea.aspx" class="btn"><i class="fa fa-arrow-circle-o-right"></i> SUPPORT A CAUSE</a>
                        </div>
                    </div>
                </li>
                <li class="customers">
                    <div class="content">
                        <div class="two-thirds">
                            <h2>It's free to sign up. <strong>Support great causes and share great deals!</strong></h2>
                            <a href="Account/Register.aspx" class="btn"><i class="fa fa-arrow-circle-o-right"></i> CREATE AN ACCOUNT</a>
                        </div>
                    </div>
                </li>
                <li class="marketplace">
                    <div class="content">
                        <div class="two-thirds"><h2>Remember those days of selling chocolate almonds 
                            door-to-door? Managing those volunteers, 
                            keeping track of all those quarters, dimes and nickels, 
                            checks are a pain! <br />
                            <strong>Coupons4Giving makes fundraising easy and secure.</strong></h2>
                            <a href="<%: User.Identity.IsAuthenticated ? "NPO/Campaigns/New.aspx" : "Account/Register.aspx" %>" class="btn"><i class="fa fa-arrow-circle-o-right"></i> START A CAMPAIGN</a>
                        </div>
                    </div>
                </li>
                <li class="fundraising">
                    <div class="content">
                        <div class="two-thirds"><h2>Be effective and target the right customers while supporting local charities and community groups.<br />
                            <strong>Coupons4Giving makes fundraising easy and secure.</strong></h2>
                            <a href="Account/Register.aspx" class="btn"><i class="fa fa-arrow-circle-o-right"></i> BECOME A MERCHANT</a>
                        </div>
                    </div>
                </li>
            </ul>
        </div>
    </section>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Main_Content" Runat="Server">
    <div class="two-thirds">
        <h1>What is Coupons4Giving?</h1>
        <p><strong>Coupons4Giving is a fundraising tool</strong> that allows you to support your favourite Not-For-Profit organization in just one click!</p>
        <p>Choose your organization and support them by purchasing a coupon to your favourite restaurant, retailer or E-tailer. As a Not-For-Profit you can create and manage successful fundraising campaigns. As a merchant or online retailer you can support your favourite causes by offering great deals with coupons.</p>
        <h4>It's <strong>Free</strong> to <a href="Account/Register.aspx">sign up with Coupons4Giving!</a></h4>
    </div>
    <div class="one-thirds LandingButtons">
        <a class="btn-large" href="Default/DealsInMyArea.aspx">Buy Deals Now</a>
        <a class="btn-large" href="Default/CausesInMyArea.aspx">Discover Causes</a>
        <a class="btn-large" href="Default/GlobalMarketplace.aspx">OUR global MARKETPLACE</a>
        <img src="images/c4g_landing_logo.png" alt="Coupons4Giving" class="centered LandingLogo" />
    </div>
    </section>
    <div class="HowItWorksBanner">
        <section id="MainContent">
            <div id="content" class="no-sidebar">
                <h1>How It Works?</h1>
                <div class="thirds">
                    <h4>NON-PROFITS</h4>
                    <img src="images/c4g_main_npo.png" alt="Coupons 4 Giving" />
                    <p class="centered">If you are a <strong>Not-For-Profit</strong>, you can build simple & effective campaigns</p>
                    <a class="btn" href="Account/Register.aspx">START A CAMPAIGN</a> 
                </div>
                <div class="thirds">
                    <h4>CUSTOMERS</h4>
                    <img src="images/c4g_main_customers.png" alt="Coupons 4 Giving" />
                    <p class="centered">If you want to <strong>support your favourite
                        causes you can buy great deals!</strong></p>
                    <a class="btn" href="Default/CausesInMyArea.aspx">SUPPORT A CAUSE</a> 
                </div>
                <div class="thirds">
                    <h4 class="centred">MERCHANTS</h4>
                    <img src="images/c4g_main_market.png" alt="Coupons 4 Giving" />
                    <p class="centered">If you are a <strong>Merchant or E-tailer</strong>, set up your offers with Coupons4Giving</p>
                    <a class="btn" href="<%: (User.IsInRole("Merchant")) ? "Merchant/MyHome.aspx" : "Account/Register.aspx" %>">BECOME A MERCHANT</a>
                </div>
            </div>
        </section>
        <!-- Close How It Works Content Section --> 
    </div>
    <section id="MainContent">
        <div id="content" class="no-sidebar">
            <h4 class="centered">OUR FEATURED DEALS</h4>
            <div class="merchantsList">
                <ul>
                    <li><img src="../images/c4g_comingsoon_small.png" class="centered" /></li>
                </ul>
            </div>
            <a href="Default/DealsInMyArea.aspx" class="btn">MORE MERCHANTS</a>
            <h4 class="centered">OUR FEATURED CAUSES</h4>
            <div class="nposList">
                <ul>
                    <li><img src="../images/c4g_comingsoon_small.png" class="centered" /></li>
                </ul>
                <a href="CausesInMyArea.aspx" class="btn">MORE CAUSES</a>
            </div>
        </div>
    </section>
    <script src="Scripts/unslider.js"></script> 
    <script>
        $(function () {
            $('.SlideBanners').unslider({
                speed: 2350,
                delay: 6000,
                keys: true,
                dots: true,
            });
        });
    </script>
</asp:Content>