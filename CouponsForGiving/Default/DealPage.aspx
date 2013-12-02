<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeFile="DealPage.aspx.cs" Inherits="Default_DealPage" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
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
    <script type="text/javascript">
        function shareOnFB() {
            FB.login(function (response) {
                if (response.authResponse) {
                    FB.ui({
                        display: 'iframe',
                        method: 'feed',
                        link: '<%: "https://www.coupons4giving.ca/Offers/" + merchant.Name %>',
                        picture: '<%: "https://www.coupons4giving.ca/" + merchant.LargeLogo %>',
                        caption: '<%: System.Web.Configuration.WebConfigurationManager.AppSettings["ProfilePostTitle"] %>',
                        name: '<%: merchant.Name %> - C4G',
                        description: '<%: merchant.cUser.MerchantInfoes.FirstOrDefault<CouponsForGiving.Data.MerchantInfo>().MerchantDescription %>',
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
            var xml = "<share><comment><%: Caption %></comment><content><title><%: merchant.Name %> - C4G</title><description><%: merchant.cUser.MerchantInfoes.FirstOrDefault<CouponsForGiving.Data.MerchantInfo>().MerchantDescription %></description><submitted-url><%: "https://www.coupons4giving.ca/Merchants/" + merchant.Name %></submitted-url><submitted-image-url><%: "https://www.coupons4giving.ca/" + merchant.LargeLogo %></submitted-image-url></content><visibility><code>anyone</code></visibility></share>";
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
                        <div class="two-thirds">             
                            <article class="c4g-coupon">
                                <img src="../Images/c4g_coupon_logo.png" class="coupon_c4g_logo" /> 
                                <div class="coupon-title">
                                    <h2><%: deal.Name %></h2><!-- Merchant Offer -->
                                    <h3><%: deal.Merchant.Name %></h3><!-- Merchant Name -->
                                    <p><%: deal.DealDescription %></p><!-- Merchant Offer Description -->
                                </div><!--Close Coupon Title -->
                                <div class="coupon-image-block">
                                    <img src="../<%: deal.ImageURL %>" /> <!-- Pulled From Merchant Profile -->
                                </div><!-- Close Image Block-->
                                <div class="clear"></div>
                                <div class="coupon-details">
                                    <div class="coupon-value">
                                        <h4>Value</h4>
                                        <p><span>$<%: ((int)(deal.Prices.FirstOrDefault<CouponsForGiving.Data.Price>().RetailValue)).ToString("D") %></span></p> <!-- Coupon Value -->
                                    </div> <!-- Close Coupon Value-->
                                    <div class="coupon-discount">
                                        <h4>Discount</h4> 
                                        <p><span><%: (1 - (deal.Prices.FirstOrDefault<CouponsForGiving.Data.Price>().GiftValue / deal.Prices.FirstOrDefault<CouponsForGiving.Data.Price>().RetailValue)).ToString("0%") %></span></p> <!-- Coupon Savings/Discount -->
                                    </div> <!-- Close Coupon Value-->
                                    <div class="coupon-giving">
                                        <h4>You're Giving</h4>
                                        <p><span>$<%: ((int)(deal.Prices.FirstOrDefault<CouponsForGiving.Data.Price>().NPOSplit)).ToString("D") %></span></p> <!-- NPO Return or portion -->
                                    </div> <!-- Close Coupon Value-->
                                </div><!-- Close Details -->
                                <div class="coupon-info">
                                    <p class="coupon-date"><span>Dates:</span> <%: deal.DealInstances.FirstOrDefault < CouponsForGiving.Data.DealInstance>().StartDate.ToString("MMMM dd, yyyy") %> - <%: deal.DealInstances.FirstOrDefault < CouponsForGiving.Data.DealInstance>().EndDate.ToString("MMMM dd, yyyy") %> </p> <!-- Dates of Campaign/Offer -->
                                </div><!-- Close Coupon Info-->
                                <div class="clear"></div>
                            </article><!-- Close Full Coupon Details Div -->
                            <hr>
                            <%
                                foreach (CouponsForGiving.Data.Campaign c in (from c in deal.DealInstances.FirstOrDefault<CouponsForGiving.Data.DealInstance>().Campaigns where c.CampaignStatusID == 2 select c))
                                {
                                    Response.Write(CouponsForGiving.HttpRendering.GetNPOCampaign(c, deal));
                                }
                            %>
                            <h2>Fine Print</h2> 
                            <ul>
                                <%
                                    foreach (CouponsForGiving.Data.FinePrint item in deal.FinePrints)
                                        Response.Write("<li>" + item.Content + "</li>");
                                %>
                            </ul>
                            <h4>Restrictions</h4>
                            <p><%: deal.RedeemDetails.FirstOrDefault<CouponsForGiving.Data.RedeemDetail>().AdditionalDetails %></p>
                            <hr>
                            <h1><%: deal.Merchant.Name %></h1>
                            <img alt="Our Logo" class="merchant_logo" src="../<%: deal.Merchant.LargeLogo %>" />
                            <h3 class="merchant-address"><%: deal.Merchant.cAddress + ", " + deal.Merchant.MerchantLocations.FirstOrDefault<CouponsForGiving.Data.MerchantLocation>().City.Name + ", " + deal.Merchant.MerchantLocations.FirstOrDefault<CouponsForGiving.Data.MerchantLocation>().City.PoliticalDivision.Name %></h3><!-- I figure we can populate this content with Merchant Address -->
                            <p><%: deal.Merchant.cUser.MerchantInfoes.FirstOrDefault<CouponsForGiving.Data.MerchantInfo>().MerchantDescription %></p><!-- This Can be populated with the Merchant Profile -->
                            <a href="<%: deal.Merchant.Website %>" target="_blank" class="btn-large" />Company Web Site</a><!-- This can be populated with the company url -->
                    </div><!-- Close Two-Thirds Wrapper -->
                    <div class="thirds">
                        <div class="SocialSidebar">
                            <h3>Share this Deal on social media!</h3>
                            <div class="SidebarShare">
                                <img src="../Images/c4g_action_link.png" class="left" />
                                <p>URL <%: URL %></p>
                            </div>
                            <div class="SidebarShare">
                                <img src="../Images/c4g_action_facebook.png" class="left" />       
                                <p class="btw" onclick="shareOnFB()">Share on Facebook</p>
                                <p id="FBMsg"></p>
                            </div>
                            <div class="SidebarShare">
                                <img src="../Images/c4g_action_twitter.png" class="left" />
                                <p><a href="https://twitter.com/share" class="twitter-share-button" data-url="<%: URL %>"
                                    data-text="<%: Caption %>" data-hashtags="C4G, DealsThatMakeADifference">Tweet</a></p>
                            </div>
                            <div class="SidebarShare">
                                <img src="../Images/c4g_action_linkedin.png" class="left" />
                                <p onclick="shareOnLinkedIn()">Share on LinkedIn</p>
                            </div>
                        </div>    
                    </div>    
                </div><!-- Close Content-->         
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
			    <li><a runat="server" href="~/Default/Home.aspx">My Coupons</a></li>
			    <li><a runat="server" href="~/NPO/Home.aspx">My Campaigns</a></li>
			    <li><a runat="server" href="~/Merchant/Home.aspx">For Merchants</a></li>
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
