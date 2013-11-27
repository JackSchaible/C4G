<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Anon.aspx.cs" Inherits="NPO_Anon" %>
<!DOCTYPE html>
<html lang="en">
<head id="Head1" runat="server">
    <meta charset="utf-8" />
    <title>My Home - Coupons4Giving</title>
    <asp:PlaceHolder ID="PlaceHolder1" runat="server">      
        <%: Scripts.Render("~/bundles/modernizr") %>
    </asp:PlaceHolder>
    <link href="../Images/favicon-1.ico" rel="shortcut icon" type="image/x-icon" />
    <meta name="viewport" content="width=device-width" />
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
                        <h2>Coupons4Giving is a fundraising tool that is easy to use! Share great deals to support your cause!</h2>
                        <h3>Register for a Coupons4Giving account and get started right away!</h3>
                        <img src="../Images/c4g_fundraising_home.png" class="right-fundraising" />
                    </div>
                    <div id="content">
                        <p><strong>Coupons4Giving</strong> allows you to create and manage successful fundraising campaigns in just a few simple clicks. You do not need to be a registered charity but you do have to have a Not-For-Profit that is looking to raise money for a cause.</p>
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
                                <p><strong>Engage</strong> your local supporters – use our simple social media toolkit to help promote your campaign.</p>
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
                        <a href="../Default/CausesInMyArea.aspx" class="btn">MORE MERCHANTS</a>
                        <h4 class="centered">OUR FEATURED CAUSES</h4>
                        <div class="nposList">
                            <ul>
                                <li><img src="../Images/c4g_comingsoon_small.png" class="centered" /></li>
                            </ul>
                        <a href="../Default/CausesInMyArea.aspx" class="btn">MORE CAUSES</a>
                        </div>
                    </div>
                </section>
            </div>
            <div class="push"></div>
        </form>
    </div>
    <footer>
        <div id="wrapper">
    	    <img id="Img2" src="~/images/logo_footer.png" alt="Coupons4Giving" runat="server"/>
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
</body>
</html>