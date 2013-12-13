<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeFile="CampaignPage.aspx.cs" Inherits="Default_NpoPage" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>
<%@ Reference Control="~/Controls/ShareControl.ascx" %>

<!DOCTYPE html>
<html lang="en">
<head id="Head1" runat="server" prefix="og: http://ogp.me/ns#">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width" />

    <title><%: Page.Title %> - Coupons4Giving</title>

    <asp:PlaceHolder ID="PlaceHolder1" runat="server">      
        <%: Scripts.Render("~/bundles/modernizr") %>
    </asp:PlaceHolder>

    <link href="~/Images/favicon-1.ico" rel="shortcut icon" type="image/x-icon" />
    
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
    <script type="text/javascript">
        function shareOnFB() {
            FB.login(function (response) {
                if (response.authResponse) {
                    FB.ui({
                        display: 'iframe',
                        method: 'feed',
                        link: '<%: "https://www.coupons4giving.ca/Causes/" + campaign.NPO.Name + "/" + campaign.Name %>',
                        picture: '<%: "https://www.coupons4giving.ca/" + campaign.CampaignImage %>',
                        caption: '<%: System.Web.Configuration.WebConfigurationManager.AppSettings["CampaignPostTitle"] %>',
                        name: '<%: campaign.Name %> - C4G',
                        description: '<%: campaign.CampaignDescription %>',
                    },
                    function (response) {
                        if (response && response.post_id) {
                        }
                        else {
                            $("#FBMsg").val("Something went wrong. Your campaign was not shared.");
                        }
                    });
                }
                else {
                    $("#FBMsg").val("You must log in to Facebook in order to post your campaign there.");
                }
            });
        }

        function shareOnLinkedIn() {
            var xml = "<share><comment><%: Caption %></comment><content><title><%: campaign.Name %> - C4G</title><description><%: campaign.CampaignDescription %></description><submitted-url><%: "https://www.coupons4giving.ca/Causes/" + npo.Name + "/" + campaign.Name %></submitted-url><submitted-image-url><%: "https://www.coupons4giving.ca/" + campaign.CampaignImage %></submitted-image-url></content><visibility><code>anyone</code></visibility></share>";
            $.ajax({
                type: "POST",
                url: "http://api.linkedin.com/v1/people/~/shares",
                data: xml,
                success: function () {
                    alert();
                },
                dataType: "xml"
            })
            .fail(function () {
                alert("Fail");
            });
        }
    </script>
    <script src="https://platform.linkedin.com/in.js" type="text/javascript">
        lang: en_US
        api_key: <%: System.Web.Configuration.WebConfigurationManager.AppSettings["LinkedIn_API_Key"] %>
        authorize: true
    </script>
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
                            <a id="homeLink" runat="server" href="~/Home.aspx"><img id="Img1" alt="Logo" src="~/Images/logo_beta.png" runat="server"/>
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
                    <div id="content" class="no-sidebar">
                        <div class="two-thirds"><!-- Removed the div #text and also the #NPO-->
                            <h1><%: campaign.Name %></h1> <!-- Campaing Name -->
                            <h3 class="npo-name"><%: npo.Name %></h3><!-- This should be the Charity Name -->
                            <h2>About the Campaign</h2>
                            <p><img alt="Our Logo" class="campaign_logo" src="../../<%: npo.Logo %>" /><%: campaign.CampaignDescription %></p> <!-- Campaing Description -->
                            <p><strong>Date Running</strong>: <%: campaign.StartDate.Value.ToString("MMMM dd, yyyy") %> - <%: campaign.EndDate.Value.ToString("MMMM dd, yyyy") %></p>
                            <hr>
                            <h2>Campaign Details</h2>
                            <div class="three-quarters charity-info">
                                <h4>The Funds Will Be Used For</h4>
                                <p><%: campaign.CampaignGoal %></p><!-- Fund Description -->
                                <h4>Target Goal</h4> 
                                <p class="campaign-goal"><%: ((decimal)(campaign.FundraisingGoal)).ToString("C") %></p> <!-- Fund Goal -->
                            </div>
                            <div class="thermometer-wrap"> 
                                <span class="thermometer"></span><span class="thermometer-raised"><%: (from po in campaign.PurchaseOrders where po.OrderStatusID != 3 select po.NPOSplit).Sum().ToString("C") %></span>
                            </div><!-- Progress Meter --> 
                        </div>
                        <div class="thirds">
                            <div class="SocialSidebar">
                                <h3>Share this NPO on social media!</h3>
                                <div class="SidebarShare">
                                    <img src="../../images/c4g_action_link.png" class="left" />
                                    <p>Copy & Paste <%: URL %></p>
                                </div>
                                <div class="SidebarShare">
                                    <img src="../../images/c4g_action_facebook.png" class="left" />       
                                    <p class="btw" onclick="shareOnFB()">Share on Facebook</p>
                                    <p id="FBMsg"></p>
                                </div>
                                <div class="SidebarShare">
                                    <img src="../../images/c4g_action_twitter.png" class="left" />
                                    <p><a href="https://twitter.com/share" class="twitter-share-button" data-url="<%: URL %>"
                                    data-text="<%: Caption %>" data-hashtags="C4G, DealsThatMakeADifference">Tweet</a></p>
                                </div>
                                <div class="SidebarShare">
                                    <img src="../../images/c4g_action_linkedin.png" class="left" />
                                    <p onclick="shareOnLinkedIn()">Share on LinkedIn</p>
                                </div>
                            </div>
                        </div>
                        <hr>
                        <div id="Campaigns">
                            <h2>Campaign Deals</h2>
                            <p>Want to support our campaign, then have a look at the deals from these great <strong>Merchants</strong>.</p>
                            <% Response.Write(CouponsForGiving.HttpRendering.ListCampaignDeals(deals)); %>
                        </div>
                        <hr>
                    </div><!-- Close Content--> 
                </section>
            </div>
            <div class="push"></div>
        </form>
    </div>
    <footer>
        <div id="Div1">
    	    <img id="Img2" src="~/images/logo_footer.png" alt="Coupons4Giving" runat="server"/>
		    <ul class="footer-nav">
			    <li><a id="A3" runat="server" href="~/">Home</a></li>
			    <li><a id="A4" runat="server" href="~/AboutUs.aspx?c=WhoWeAre">Who We Are</a></li>
			    <li><a id="A5" runat="server" href="~/AboutUs.aspx?c=OurTeam">Our Team</a></li>
			    <li><a id="A6" runat="server" href="~/InTheCommunity.aspx">In The Community</a></li>
			    <li><a id="A7" runat="server" href="~/Default/Home.aspx">My Coupons</a></li>
			    <li><a id="A8" runat="server" href="~/NPO/Home.aspx">My Campaigns</a></li>
			    <li><a id="A9" runat="server" href="~/Merchant/Home.aspx">For Merchants</a></li>
			    <li><a id="A10" runat="server" href="~/Blog.aspx">Blog</a></li>
		    </ul>
            <ul>
                <li><a id="A11" runat="server" href="~/Content/Terms/PrivacyPolicy.pdf">Privacy Policy</a></li>
                <li><a id="A12" runat="server" href="~/Content/Terms/TermsOfUse.pdf">Terms of Use</a></li>
                <li><a id="A13" runat="server" href="~/FAQ.aspx">FAQs</a></li>
                <li><a id="A14" runat="server" href="~/Careers.aspx">Careers</a></li>
            </ul>
            <p>&copy; <%:DateTime.Now.Year%> - GenerUS Marketing Solutions</p>
        </div>
    </footer>
</body>
</html>
