<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeFile="MyHome.aspx.cs" Inherits="Default_MyHome" %>

<!DOCTYPE html>
<html lang="en">
<head id="Head1" runat="server">
    <meta charset="utf-8" />
    <title>My Home - Coupons4Giving</title>
    <asp:PlaceHolder ID="PlaceHolder1" runat="server">      
        <%: Scripts.Render("~/bundles/modernizr") %>
    </asp:PlaceHolder>
    <link href="Images/favicon-1.ico" rel="shortcut icon" type="image/x-icon" />
    <meta name="viewport" content="width=device-width" />
    <link href="~/Content/style.css" rel="stylesheet"/>
    <link href='https://fonts.googleapis.com/css?family=Lato:300,400,700' rel='stylesheet' type='text/css'>
    <link href='https://fonts.googleapis.com/css?family=Ubuntu:400,500,700' rel='stylesheet' type='text/css'>
    <link href="https://netdna.bootstrapcdn.com/font-awesome/4.0.1/css/font-awesome.css" rel="stylesheet" type="text/css">
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
                        <h2>Whether you search by deals or by Not-For-Profits you can support great causes in just one click. </h2>
                        <img src="../images/c4g_heartinhand_home.png" class="right-heartinhand" />
                    </div>
                    <div id="content" class="no-sidebar">
                        <h1>Take a Look Around</h1>
                        <p>Browse our local deals as well as our <strong>Global Marketplace of E-tailers</strong> (online only merchants)</p>
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
                            <a href="DealsInMyArea.aspx" class="btn">MORE CAUSES</a> </div>
                        </div>
                    </div>
                </section><!-- Close Main Content -->
                <div class="HowItWorksBanner">
                    <section id="Section1">
                        <div id="Div1" class="no-sidebar">
                            <h1>Support Your Favorite Not-For-Profit</h1>
                            <div style="padding: 10px;">

                            </div>
                            <div class="quarter">
                                <h4>STEP 1</h4>
                                <img src="../images/c4g_home_step1.png" alt="Coupons 4 Giving" />
                                <p><strong>Choose</strong> your favorite organization</p>
                            </div>
                            <div class="quarter">
                                <h4>STEP 2</h4>
                                <img src="../images/c4g_home_step2.png" alt="Coupons 4 Giving" />
                                <p><strong>Select</strong> the restaurant or business that is fundraising for your group</p>
                            </div>
                            <div class="quarter">
                                <h4>STEP 3</h4>
                                <img src="../images/c4g_home_step3.png" alt="Coupons 4 Giving" />
                                <p><strong>Purchase</strong> the deal – a coupon or discount</p>
                            </div>
                            <div class="quarter">
                                <h4>STEP 4</h4>
                                <img src="../images/c4g_home_step4.png" alt="Coupons 4 Giving" />
                                <p><strong>Redeem</strong> the offer on your next visit or directly online from our Global Marketplace of E-tailers</p>
                            </div>
                            <h4 class="centered">Whether you are raising money, looking for a great restaurant or you are a merchant who wants to support local community groups, Coupons4Giving makes it easy!</h4>
                            <div class="clear"></div>
                            <div class="FormRow" style="padding-top: 20px;">
                                <a href="DealsInMyArea.aspx" style="margin-top: 10px;" class="HeaderButton">GET STARTED TODAY!</a>
                            </div>
                        </div>
                    </section> <!-- Close How It Works Content Section -->
                </div>
            </div>
            <div class="push"></div>
        </form>
    </div>
    <footer>
        <div id="Div2">
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
                <li><a href="privacyPolicy.aspx">Privacy Policy</a></li>
                <li><a href="Content/Terms/TermsOfUse.pdf">Terms of Use</a></li>
                <li><a href="faq.aspx">FAQs</a></li>
                <li><a href="Careers.aspx">Careers</a></li>
            </ul>
            <p>&copy; <%:DateTime.Now.Year%> - GenerUS Marketing Solutions</p>
        </div>
    </footer>
</body>
</html>