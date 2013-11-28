<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Home.cs" Inherits="Home" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<!DOCTYPE html>
<html lang="en">
    <head id="Head1" runat="server">
        <meta charset="utf-8" />
        <title>Home - Coupons4Giving</title>
        <asp:PlaceHolder ID="PlaceHolder1" runat="server">      
            <%: Scripts.Render("~/bundles/modernizr") %>
        </asp:PlaceHolder>
        <link href="Images/favicon-1.ico" rel="shortcut icon" type="image/x-icon" />
        <meta name="viewport" content="width=device-width" />
        <link href="~/Content/style.css" rel="stylesheet"/>
        <link href='https://fonts.googleapis.com/css?family=Lato:300,400,700' rel='stylesheet' type='text/css'>
        <link href='https://fonts.googleapis.com/css?family=Ubuntu:400,500,700' rel='stylesheet' type='text/css'>
        <link href="https://netdna.bootstrapcdn.com/font-awesome/4.0.1/css/font-awesome.css" rel="stylesheet" type="text/css">
        <!--Additional head content-->
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
        <div id="wrapper">
            <form id="Form1" runat="server">
                <ajaxToolkit:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" EnablePageMethods="true">
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
                                        <a runat="server" ID="ProfileButton" class="HeaderButton" href="redirect.aspx">My Profile</a>
                                    </LoggedInTemplate>
                                </asp:LoginView>
                                <a href="~/ContactUs.aspx" class="HeaderButton" runat="server" id="contactUs">Contact Us</a>
                            </div>
                        </div>
                    </div>
                </header>
                <div id="container" style="min-height: 430px;">
                    <UC:MenuBar ID="MenuBarControl" runat="server" />
                    <section id="LandingCarousel">
                      <div class="SlideBanners">
                        <ul>
                          <li class="customers">
                            <div class="content">
                              <div class="two-thirds">
                                <h2><strong>Coupons4Giving</strong> is an fundraising tool
                                  that allows you to support 
                                  your favourite <strong>not-for-profit organization 
                                  in just one click!</strong></h2>
                                <a href="Default/CausesInMyArea.aspx" class="btn">SUPPORT A CAUSE</a> </div>
                            </div>
                          </li>
                          <li class="marketplace">
                            <div class="content">
                              <div class="two-thirds">
                                <h2>Remember those days of selling chocolate almonds 
                                  door-to-door? Managing those volunteers, 
                                  keeping track of all those quarters, dimes and nickels, 
                                  checks are a pain! <br />
                                  <strong>Coupons4Giving makes fundraising easy and secure.</strong></h2>
                                <a href="<%: User.Identity.IsAuthenticated ? (User.IsInRole("NPO") ? "NPO/MyHome.aspx" : "NPO/Signup.aspx") : "Account/Register.aspx" %>" class="btn">START A CAMPAIGN</a> </div>
                            </div>
                          </li>
                          <li class="fundraising">
                            <div class="content">
                              <div class="two-thirds">
                                <h2>Be effective and target the right customers while supporting local charities and community groups.<br />
                                  <strong>Coupons4Giving makes fundraising easy and secure.</strong></h2>
                                <a href="<%: User.Identity.IsAuthenticated ? (User.IsInRole("Merchant") ? "Merchant/MyHome.aspx" : "Merchant/Signup.aspx") : "Account/Register.aspx" %>" class="btn">BECOME A MERCHANT</a> </div>
                            </div>
                          </li>
                        </ul>
                      </div>
                    </section>
                    <section id="MainContent">
                      <div id="content" class="no-sidebar">
                        <h1>What is Coupons4Giving?</h1>
                        <div class="two-thirds">
                          <p>Coupons4Giving is a fundraising tool that allows you to support your favourite Not-For-Profit organization in just one click! </p>
                          <p>Choose your organization and support them by purchasing a coupon to your favourite restaurant, retailer or E-tailer. As a Not-For-Profit you can create and manage successful fundraising campaigns. As a merchant or online retailer you can support your favourite causes by offering great deals with coupons.</p>
                        </div>
                        <div class="one-thirds"> <img src="images/c4g_landing_logo.png" alt="Coupons4Giving" class="centered LandingLogo" /> 
                            <a class="btn-large" href="Default/CausesInMyArea.aspx">Buy Deals Now</a>
                            <a class="btn-large" href="Default/CausesInMyArea.aspx">Discover Causes</a>
                        </div>
                      </div>
                    </section>
                    <!-- Close About Banner Content Section -->
    
                    <div class="HowItWorksBanner">
                      <section id="MainContent">
                        <div id="content" class="no-sidebar">
                          <h1>How It Works?</h1>
                          <div class="thirds">
                            <h4>NON-PROFITS</h4>
                            <img src="images/c4g_main_npo.png" alt="Coupons 4 Giving" />
                            <p class="centered">If you are a <strong>Not-For-Profit</strong>, 
                              you can build simple & effective campaigns</p>
                            <a class="btn" href="Account/Register.aspx">START A CAMPAIGN</a> </div>
                          <div class="thirds">
                            <h4>CUSTOMERS</h4>
                            <img src="images/c4g_main_customers.png" alt="Coupons 4 Giving" />
                            <p class="centered">If you want to <strong>support your favourite
                              causes you can buy great deals!</strong></p>
                            <a class="btn" href="Default/CausesInMyArea.aspx">SUPPORT A CAUSE</a> </div>
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
                        <a href="" class="btn">MORE MERCHANTS</a>
                        <h4 class="centered">OUR FEATURED CAUSES</h4>
                        <div class="nposList">
                            <ul>
                                <li><img src="../images/c4g_comingsoon_small.png" class="centered" /></li>
                            </ul>
                            <a href="CausesInMyArea.aspx" class="btn">MORE CAUSES</a> </div>
                        </div>
                      </div>
                    </section>
                    <!-- Close Merchants & NPOs Content Section --> 
                  </div>
                  <div class="push"></div>
            </form>
        </div>
        <footer>
            <div id="wrapper">
    	        <img src="images/logo_footer.png" alt="Coupons4Giving" />
		        <ul class="footer-nav">
			        <li><a href="/">Home</a></li>
			        <li><a href="/AboutUs.aspx?c=WhoWeAre">Who We Are</a></li>
			        <li><a href="/AboutUs.aspx?c=OurTeam">Our Team</a></li>
			        <li><a href="/InTheCommunity.aspx">In The Community</a></li>
			        <li><a href="/Default/Home.aspx">My Coupons</a></li>
			        <li><a href="/NPO/Home.aspx">My Campaigns</a></li>
			        <li><a href="/Merchant/Home.aspx">For Merchants</a></li>
			        <li><a href="/Blog.aspx">Blog</a></li>
		        </ul>
                <ul>
                    <li><a href="Content/Terms/PrivacyPolicy.pdf">Privacy Policy</a></li>
                    <li><a href="Content/Terms/TermsOfUse.pdf">Terms of Use</a></li>
                    <li><a href="faq.aspx">FAQs</a></li>
                    <li><a href="Careers.aspx">Careers</a></li>
                </ul>
                <p>&copy; <%:DateTime.Now.Year%> - GenerUS Marketing Solutions</p>
            </div>
        </footer>
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
    </body>
</html>