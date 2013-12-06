﻿<%@ Page Title="My Home" Language="C#" AutoEventWireup="true" CodeFile="MyHome.aspx.cs" Inherits="Default_My_MyHome" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server" prefix="og: http://ogp.me/ns#">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width" />

    <title><%: Page.Title %> - Coupons4Giving</title>

    <asp:PlaceHolder runat="server">      
        <%: Scripts.Render("~/bundles/modernizr") %>
    </asp:PlaceHolder>

    <link href="../Images/favicon-1.ico" rel="shortcut icon" type="image/x-icon" />
    
    <link href="~/Content/style.css" rel="stylesheet"/>
    <link href='https://fonts.googleapis.com/css?family=Lato:300,400,700' rel='stylesheet' type='text/css'>
    <link href='https://fonts.googleapis.com/css?family=Ubuntu:400,500,700' rel='stylesheet' type='text/css'>
    <link href="https://netdna.bootstrapcdn.com/font-awesome/4.0.1/css/font-awesome.css" rel="stylesheet" type="text/css">
    <script>
        (function (i, s, o, g, r, a, m) {
            i['GoogleAnalyticsObject'] = r; i[r] = i[r] || function () {
                (i[r].q = i[r].q || []).push(arguments)
            }, i[r].l = 1 * new Date(); a = s.createElement(o),
            m = s.getElementsByTagName(o)[0]; a.async = 1; a.src = g; m.parentNode.insertBefore(a, m)
        })(window, document, 'script', '//www.google-analytics.com/analytics.js', 'ga');

        ga('create', 'UA-45976939-1', 'coupons4giving.ca');
        ga('send', 'pageview');

    </script>
</head>
<body>
    <script>!function (d, s, id) { var js, fjs = d.getElementsByTagName(s)[0], p = /^http:/.test(d.location) ? 'http' : 'https'; if (!d.getElementById(id)) { js = d.createElement(s); js.id = id; js.src = p + '://platform.twitter.com/widgets.js'; fjs.parentNode.insertBefore(js, fjs); } }(document, 'script', 'twitter-wjs');</script>
    <div id="fb-root"></div>
    <script>
        window.fbAsyncInit = function () {
            // init the FB JS SDK
            FB.init({
                appId: '<%:System.Web.Configuration.WebConfigurationManager.AppSettings["FB_App_ID"]%>', // App ID from the app dashboard
                status: true,                                 // Check Facebook Login status
                xfbml: true                                  // Look for social plugins on the page
            });

            // Additional initialization code such as adding Event Listeners goes here
        };

        // Load the SDK asynchronously
        (function (d, s, id) {
            var js, fjs = d.getElementsByTagName(s)[0];
            if (d.getElementById(id)) { return; }
            js = d.createElement(s); js.id = id;
            js.src = "//connect.facebook.net/en_US/all.js";
            fjs.parentNode.insertBefore(js, fjs);
        }(document, 'script', 'facebook-jssdk'));


    </script>
    <div id="wrapper">
        <form runat="server">
            <ajaxToolkit:ToolkitScriptManager runat="server" EnablePageMethods="true">
                <Scripts>
                    <%--To learn more about bundling scripts in ScriptManager see http://go.microsoft.com/fwlink/?LinkID=272931&clcid=0x409 --%>
                    <%--Framework scripts--%>
                    <asp:ScriptReference Name="jquery" />
                    <asp:ScriptReference Name="jquery.ui.combined" />
                    <asp:ScriptReference Name="WebForms.js" Path="~/Scripts/WebForms/WebForms.js" />
                    <asp:ScriptReference Name="WebUIValidation.js" Path="~/Scripts/WebForms/WebUIValidation.js" />
                    <asp:ScriptReference Name="MenuStandards.js" Path="~/Scripts/WebForms/MenuStandards.js" />
                    <asp:ScriptReference Name="GridView.js" Path="~/Scripts/WebForms/GridView.js" />
                    <asp:ScriptReference Name="DetailsView.js" Path="~/Scripts/WebForms/DetailsView.js" />
                    <asp:ScriptReference Name="TreeView.js" Path="~/Scripts/WebForms/TreeView.js" />
                    <asp:ScriptReference Name="WebParts.js" Path="~/Scripts/WebForms/WebParts.js" />
                    <asp:ScriptReference Name="Focus.js" Path="~/Scripts/WebForms/Focus.js" />
                    <asp:ScriptReference Name="WebFormsBundle" />
                    <%--Site scripts--%>
                </Scripts>
            </ajaxToolkit:ToolkitScriptManager>
            <header>
                <div id="mainHeader">
                    <div class="headerWrap">
                        <div class="header-logo">
                            <a id="homeLink" runat="server" href="~/Home.aspx"><img id="Img1" alt="Logo" src="~/Images/logo_2_color.png" runat="server"/>
                                <h2 class="tagLine">Share Great Deals! Support Great Causes!</h2>
                            </a>
                        </div>
                        <div class="header-social">
                            <a href="http://www.facebook.com/Coupons4Giving"><i class="fa fa-facebook"></i></a>
                            <a href="https://twitter.com/Coupons4Giving"><i class="fa fa-twitter"></i></a>
                            <a href="#"><i class="fa fa-linkedin"></i></a>
                        </div>
                        <div class="header-login">
                            <asp:LoginView ID="LoginView1" runat="server" ViewStateMode="Disabled">
                                <AnonymousTemplate>
                                    <a id="lbutton" runat="server" class="HeaderButton" href="~/Account/Login.aspx">Log in</a>
                                    <a id="signupButton" runat="server" class="HeaderButton" href="~/Account/Register.aspx">Register</a>
                                </AnonymousTemplate>
                                <LoggedInTemplate>
                                    <asp:LoginStatus ID="signupButton" CssClass="HeaderButton" runat="server" LogoutAction="Redirect" LogoutText="Log off" LogoutPageUrl="~/" />
                                    <a runat="server" ID="ProfileButton" class="HeaderButton">My Profile</a>
                                </LoggedInTemplate>
                            </asp:LoginView>
                            <a href="~/ContactUs.aspx" class="HeaderButton" runat="server" id="contactUs">Contact Us</a>
                        </div>
                    </div>
                </div>
            </header>
            <div id="container" style="min-height: 430px;">
                <UC:MenuBar ID="MenuBarControl" runat="server" />
                <section id="MainContent">
                    <div class="homeBanners">
                        <h2>Whether you search by deals or Not-For-Profits you can support great causes in just one click. </h2>
                        <img src="../Images/c4g_heartinhand_home.png" class="right-heartinhand" /> </div>
                        <div id="content">
                            <h3>Support Your Favorite Not-For-Profit</h3>
                            <ul class="tipList">
                                <li class="homestep1">
                                    <h4>STEP 1:</h4>
                                    <p><strong>Choose</strong> your favorite organization</p>
                                </li>
                                <li class="homestep2">
                                    <h4>STEP 2</h4>
                                    <p><strong>Select</strong> the restaurant or business that is fundraising for your group</p>
                                </li>
                                <li class="homestep3">
                                    <h4>STEP 3</h4>
                                    <p><strong>Purchase</strong> the deal – a coupon or discount</p>
                                </li>
                                <li class="homestep4">
                                    <h4>STEP 4</h4>
                                    <p><strong>Redeem</strong> the offer on your next visit or directly online from our Global Marketplace of E-tailers</p>
                                </li>
                            </ul>
                            <blockquote>Whether you are raising money, looking for a great restaurant or you are a merchant who wants to support local community groups, Coupons4Giving makes it easy!</blockquote>
                            <div class="clear"></div>
                            <a href="../Account/Register.aspx" class="btn-center">GET STARTED TODAY!</a>
                            <hr>
                            <h3>Take a Look Around</h3>
                            <p>Browse our local deals as well as our <strong>Global Marketplace of E-tailers</strong> (online only merchants)</p>
                            <h4 class="centered">OUR FEATURED DEALS</h4>
                            <div class="merchantsList">
                                <ul>
                                    <li><img src="../Images/c4g_comingsoon_small.png" class="centered" /></li>
                                </ul>
                            </div>
                            <a href="DealsInMyArea.aspx" class="btn">MORE MERCHANTS</a>
                                <h4 class="centered">OUR FEATURED CAUSES</h4>
                                <div class="nposList">
                                    <ul>
                                        <li><img src="../Images/c4g_comingsoon_small.png" class="centered" /></li>
                                    </ul>
                                    <a href="CausesInMyArea.aspx" class="btn">MORE CAUSES</a>
                                </div>
                            </div>
                    <div id="FeaturedMerchants" class="Sidebar">
                        <h1>Discover Coupons & Causes</h1>
                        <asp:GridView ID="FeaturedMerchantGV" runat="server" AutoGenerateColumns="False" DataSourceID="FMerchantsODS">
                            <Columns>
                                <asp:HyperLinkField DataNavigateUrlFields="Name" DataNavigateUrlFormatString="~/Default/MerchantPage.aspx?MerchantName={0}" DataTextField="Name" HeaderText="Our Featured Merchants" />
                            </Columns>
                        </asp:GridView>
                        <a class="btn" href="~/Account/Register.aspx" runat="server">Become a Merchant</a>
                        <asp:GridView ID="FeaturedNPOGV" runat="server" AutoGenerateColumns="False" DataSourceID="FNPOODS">
                            <Columns>
                                <asp:HyperLinkField DataNavigateUrlFields="URL" DataNavigateUrlFormatString="~/Default/NPOPage.aspx?name={0}" DataTextField="Name" HeaderText="Our Featured NPOs" />
                            </Columns>
                        </asp:GridView>
                        <a class="btn" href="~/Account/Register.aspx" runat="server">Sign up to Become an npo</a>
                        <asp:ObjectDataSource ID="FNPOODS" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="NPO_GetFeatured" TypeName="CouponsForGiving.Data.SysData"></asp:ObjectDataSource>
                        <asp:ObjectDataSource ID="FMerchantsODS" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="Merchant_GetFeatured" TypeName="CouponsForGiving.Data.SysData"></asp:ObjectDataSource>
                    </div>
                </section>
            </div>
            <div class="push"></div>
        </form>
    </div>
    <footer>
        <div id="wrapper">
    	    <img src="~/images/logo_footer.png" alt="Coupons4Giving" runat="server"/>
		    <ul class="footer-nav">
			    <li><a runat="server" href="~/">Home</a></li>
			    <li><a runat="server" href="~/AboutUs.aspx?c=WhoWeAre">Who We Are</a></li>
			    <li><a runat="server" href="~/AboutUs.aspx?c=OurTeam">Our Team</a></li>
			    <li><a runat="server" href="~/InTheCommunity.aspx">In The Community</a></li>
			    <li><a runat="server" href="~/Default/MyHome.aspx">My Coupons</a></li>
			    <li><a runat="server" href="~/NPO/MyHome.aspx">My Campaigns</a></li>
			    <li><a runat="server" href="~/Merchant/MyHome.aspx">For Merchants</a></li>
			    <li><a runat="server" href="~/Blog.aspx">Blog</a></li>
		    </ul>
            <ul>
                <li><a runat="server" href="~/Content/Terms/PrivacyPolicy.pdf">Privacy Policy</a></li>
                <li><a runat="server" href="~/Content/Terms/TermsOfUse.pdf">Terms of Use</a></li>
                <li><a runat="server" href="~/FAQ.aspx">FAQs</a></li>
                <li><a runat="server" href="~/Careers.aspx">Careers</a></li>
            </ul>
            <p>&copy; <%:DateTime.Now.Year%> - GenerUS Marketing Solutions</p>
        </div>
    </footer>
</body>
</html>
