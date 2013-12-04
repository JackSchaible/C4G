<%@ Page Title="Home" Language="C#" AutoEventWireup="true" CodeFile="MyHome.aspx.cs" Inherits="Merchant_Home" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<!DOCTYPE html>
<html lang="en">
<head id="Head1" runat="server" prefix="og: http://ogp.me/ns#">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width" />

    <title><%: Page.Title %> - Coupons4Giving</title>

    <asp:PlaceHolder ID="PlaceHolder1" runat="server">      
        <%: Scripts.Render("~/bundles/modernizr") %>
    </asp:PlaceHolder>

    <link href="Images/favicon-1.ico" rel="shortcut icon" type="image/x-icon" />
    
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
                appId: '<%#System.Web.Configuration.WebConfigurationManager.AppSettings["FB_App_ID"]%>', // App ID from the app dashboard
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
                            <script type="text/javascript">
                                var name = '<%# (merchant == null) ? "0" : merchant.Name %>';
                                var description = '<%# (merchant == null) ? "0" : Uri.EscapeDataString(merchant.cUser.MerchantInfoes.FirstOrDefault<CouponsForGiving.Data.MerchantInfo>().MerchantDescription)%>';
                                var address = '<%# (merchant == null) ? "0" : merchant.cAddress%>';
                                var postalcode = '<%# (merchant == null) ? "0" : merchant.PostalCode%>';
                                var website = '<%# (merchant == null) ? "0" : merchant.Website%>';
                                var phoneNumber = '<%# (merchant == null) ? "0" : merchant.PhoneNumber%>';
                                var email = '<%# (merchant == null) ? "0" : merchant.Email%>';
                                var statusid = '<%# (merchant == null) ? 0 : merchant.StatusID%>';
                                var logo = '<%# (merchant == null) ? "0" : merchant.LargeLogo%>';
                                var url = '<%# (merchant == null) ? "0" : merchant.Name%>';
                                var imageFile = "";
                                var imageType = "";
                                var city = '<%# merchant.MerchantLocations.FirstOrDefault<CouponsForGiving.Data.MerchantLocation>().City.Name %>';
                                var province = '<%# merchant.MerchantLocations.FirstOrDefault<CouponsForGiving.Data.MerchantLocation>().City.PoliticalDivision.Name %>';
                                var country = '<%# merchant.MerchantLocations.FirstOrDefault<CouponsForGiving.Data.MerchantLocation>().City.Country.Name %>';
                                var autoAcceptMerchantRequests = '<%# merchant.MerchantSettings.FirstOrDefault<CouponsForGiving.Data.MerchantSetting>().AutoAcceptRequests.Value ? "true": "false" %>';

                                function imgUploadStarted() {
                                    $("#LoadImg").html('<img alt="Loading" src="../Images/loading.gif" />');
                                }

                                function fileUploadComplete() {
                                    $("#LoadImg").html('');
                                }

                                //Switches the form to view mode and saves
                                function save() {
                                    name = $("#NameTextBox").val();
                                    description = $("#DescriptionTextBox").val();
                                    address = $("#AddressTextBox").val();
                                    postalcode = $("#PostalCodeTextBox").val();
                                    phoneNumber = $("#PhoneTextBox").val();
                                    city = $("#CityTextBox").val();
                                    province = $("#ProvinceTextBox").val();
                                    country = $("#CountryTextBox").val();
                                    email = $("#EmailTextBox").val();

                                    PageMethods.Save(encodeURIComponent(name), encodeURIComponent(description), encodeURIComponent(address), encodeURIComponent(city), encodeURIComponent(province), encodeURIComponent(country), encodeURIComponent(postalcode), encodeURIComponent(website), encodeURIComponent(phoneNumber), encodeURIComponent(email), encodeURIComponent(statusid), encodeURIComponent(logo), encodeURIComponent(autoAcceptMerchantRequests), onSuccess, onError);

                                    function onError(errors) {
                                        console.log(errors._message);
                                        $("#ErrorMessages").text(errors._message);
                                    }

                                    function onSuccess(response) {
                                        $("#ErrorMessages").text("Your profile has been updated.");
                                        cancel();
                                    }
                                };

                                //Switches the form to edit mode
                                function edit() {
                                    $("#modeButton").text("Save");
                                    $("#modeButton").attr('href', 'javascript:save()');
                                    $("#cancelButton").css("display", "inherit");

                                    $("#profile-edit-name").html("<input type=\"text\" id=\"NameTextBox\" value=\"" + decodeURIComponent(name) + "\"/>");
                                    $("#profile-edit-description").html('<div id="profile-edit-image" class="right"><!-- Added a Right Image class--><img src="../<%# merchant.LargeLogo %>" /><div id="LoadImg"></div><div class="ClearFix"></div></div><textarea id="DescriptionTextBox">' + decodeURIComponent(description) + '</textarea>');
                                    $("#profile-edit-address").html('<label>Address</label><input type="text" id="AddressTextBox" value="' + address + '" />');
                                    $("#profile-edit-postal-code").html('<label>Postal Code</label><input type="text" id="PostalCodeTextBox" value="' + postalcode + '" />');
                                    $("#profile-edit-email").html('<label>Email</label><input type="text" id="EmailTextBox" value="' + email + '" />');
                                    $("#profile-edit-phone-number").html('<label>Phone</label><input type="text" id="PhoneTextBox" value="' + phoneNumber + '" />');
                                    $("#profile-edit-city").html('<label>City</label><input type="text" id="CityTextBox" value="' + city + '" />');
                                    $("#profile-edit-province").html('<label>Province</label><input type="text" id="ProvinceTextBox" value="' + province + '" />');
                                    $("#profile-edit-country").html('<label>Country</label><input type="text" id="CountryTextBox" value="' + country + '" />');

                                }

                                //Switched the form to view mode without saving
                                function cancel() {
                                    $("#modeButton").text("Edit");
                                    $("#modeButton").attr('href', 'javascript:edit()');
                                    $("#cancelButton").css("display", "none");

                                    $("#profile-edit-name").html("<h1>" + decodeURIComponent(name) + "</h1>");
                                    $("#profile-edit-description").html('<div id="profile-edit-image" class="right"><!-- Added a Right Image class--><img src="../<%# merchant.LargeLogo %>" /><div id="LoadImg"></div><div class="ClearFix"></div></div><p id="DescriptionText">' + decodeURIComponent(description) + '</p>');
                                        $("#profile-edit-address").html('<label>Address</label><p>' + address + '</p>');
                                        $("#profile-edit-postal-code").html('<label>Postal Code</label><p>' + postalcode + '</p>');
                                        $("#profile-edit-email").html('<label>Email</label><p>' + email + '</p>');
                                        $("#profile-edit-phone-number").html('<label>Phone</label><p>' + phoneNumber + '</p>');
                                        $("#profile-edit-city").html('<label>City</label><p>' + city + '</p>');
                                        $("#profile-edit-province").html('<label>Province</label><p>' + province + '</p>');
                                        $("#profile-edit-country").html('<label>Country</label><p>' + country + '</p>');
                                    }
                            </script>
                        <div class="two-thirds">
                            <br />
                            <a id="modeButton" href="javascript:edit()" class="btn">Edit</a>
                            <a style="display: none;" id="cancelButton" href="javascript:cancel()" class="btn">Cancel</a>
                            <span id="ErrorMessages"></span>
                            <div class="profile-edit">
                                <div id="profile-edit-name">
                                    <h1><%# merchant.Name %></h1>
                                </div>
                                <div id="profile-edit-description">
                                    <div id="profile-edit-image" class="right"><!-- Added a Right Image class-->
                                        <img src="../<%# merchant.LargeLogo %>" />
                                        <div id="LoadImg"></div>
                                        <div class="ClearFix"></div>
                                    </div>
                                    <p id="DescriptionText"><%# merchant.cUser.MerchantInfoes.FirstOrDefault<CouponsForGiving.Data.MerchantInfo>().MerchantDescription %></p>
                                </div>       
                                <div id="profile-edit-address">
                                    <label>Address</label>
                                    <p><%# merchant.cAddress %></p>
                                </div>
                                <div id="profile-edit-postal-code">
                                    <label>Postal Code</label>
                                    <p><%# merchant.PostalCode %></p>
                                </div>
                                <div id="profile-edit-email">
                                    <label>Email</label>
                                    <p><%# merchant.Email %></p>
                                </div>
                                <div id="profile-edit-phone-number">
                                    <label>Phone</label>
                                    <p><%# merchant.PhoneNumber %></p>       
                                </div>
                                <div id="profile-edit-city">
                                    <label>City</label>
                                    <p><%# merchant.MerchantLocations.FirstOrDefault<CouponsForGiving.Data.MerchantLocation>().City.Name %></p>         
                                </div>
                                <div id="profile-edit-province">
                                    <label>Province</label>
                                    <p><%# merchant.MerchantLocations.FirstOrDefault<CouponsForGiving.Data.MerchantLocation>().City.PoliticalDivision.Name %></p>
                                </div>
                                <div id="profile-edit-country">
                                    <label>Country</label>
                                    <p><%# merchant.MerchantLocations.FirstOrDefault<CouponsForGiving.Data.MerchantLocation>().City.Country.Name %></p>
                                </div>
                                <div class="FormRow">
                                    <label for="">Auto-Accept Merchant Requests</label>
                                    <input type="checkbox" checked="<%# merchant.MerchantSettings.FirstOrDefault<CouponsForGiving.Data.MerchantSetting>().AutoAcceptRequests.Value ? "checked": "" %>" />
                                </div>
                                <%--<div class="FormRow">
                                    <label>Receive E-Mail Notifications</label>
                                    <asp:RadioButtonList ID="RecieveEmails" runat="server">
                                        <asp:ListItem Text="Yes" Value="Yes"></asp:ListItem>
                                        <asp:ListItem Text="No" Value="No"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </div>--%>
                            </div><!-- Close Profile Edit Block-->
                        </div>
                        <div class="thirds">
                            <div class="SocialSidebar">
                                <h3>Share this NPO on social media!</h3>
                                <div class="SidebarShare">
                                    <img src="../images/c4g_action_link.png" class="left" />
                                    <p>Copy & Paste <%: URL %></p>
                                </div>
                                <div class="SidebarShare">
                                    <img src="../images/c4g_action_facebook.png" class="left" />       
                                    <p class="btw" onclick="shareOnFB()">Share on Facebook</p>
                                    <p id="FBMsg"></p>
                                </div>
                                <div class="SidebarShare">
                                    <img src="../images/c4g_action_twitter.png" class="left" />
                                    <p><a href="https://twitter.com/share" class="twitter-share-button" data-url="<%: URL %>"
                                    data-text="<%: Caption %>" data-hashtags="C4G, DealsThatMakeADifference">Tweet</a></p>
                                </div>
                                <div class="SidebarShare">
                                    <img src="../images/c4g_action_linkedin.png" class="left" />
                                    <p onclick="shareOnLinkedIn()">Share on LinkedIn</p>
                                </div>
                            </div>    
                        </div>
                        <hr>
                        <a href="Campaigns/New.aspx" class="btn">New Campaign</a>
                    </div>
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
			    <li><a id="A7" runat="server" href="~/Default/MyHome.aspx">My Coupons</a></li>
			    <li><a id="A8" runat="server" href="~/NPO/MyHome.aspx">My Campaigns</a></li>
			    <li><a id="A9" runat="server" href="~/Merchant/MyHome.aspx">For Merchants</a></li>
			    <li><a id="A10" runat="server" href="~/Blog.aspx">Blog</a></li>
		    </ul>
            <ul>
                <li><a id="A11" runat="server" href="~/Content/Terms/PrivacyPolicy.pdf">Privacy Policy</a></li>
                <li><a id="A12" runat="server" href="~/LegalAgreements.aspx">Legal Agreements</a></li>
                <li><a id="A13" runat="server" href="~/FAQ.aspx">FAQs</a></li>
                <li><a id="A14" runat="server" href="~/Careers.aspx">Careers</a></li>
            </ul>
            <p>&copy; <%:DateTime.Now.Year%> - GenerUS Marketing Solutions</p>
        </div>
    </footer>
</body>
</html>