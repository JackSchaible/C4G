<%@ Page Title="Home" Language="C#" AutoEventWireup="true" CodeFile="MyHome.aspx.cs" Inherits="Merchant_Home" MasterPageFile="~/Site.master" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>
<%@ MasterType VirtualPath="~/Site.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BannerContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Main_Content" Runat="Server">
        <script type="text/javascript">
            var name = '<%# (npo == null) ? "0" : npo.Name %>';
            var description = '<%# (npo == null) ? "0" : Uri.EscapeDataString(npo.NPODescription)%>';
            var address = '<%# (npo == null) ? "0" : npo.cAddress%>';
            var postalcode = '<%# (npo == null) ? "0" : npo.PostalCode%>';
            var website = '<%# (npo == null) ? "0" : npo.Website%>';
            var phoneNumber = '<%# (npo == null) ? "0" : npo.PhoneNumber%>';
            var email = '<%# (npo == null) ? "0" : npo.Email%>';
            var statusid = '<%# (npo == null) ? 0 : npo.StatusID%>';
            var logo = '<%# (npo == null) ? "0" : npo.Logo%>';
            var url = '<%# (npo == null) ? "0" : npo.URL%>';
            var imageFile = "";
            var imageType = "";
            var city = '<%# npo.City.Name %>';
            var province = '<%# npo.City.PoliticalDivision.Name %>';
            var country = '<%# npo.City.Country.Name %>';
            var autoAcceptMerchantRequests = '<%# npo.NPOSettings.FirstOrDefault<CouponsForGiving.Data.NPOSetting>().AutoAcceptMerchantRequests ? "true": "false" %>';

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
                $("#profile-edit-description").html('<div id="profile-edit-image" class="right"><!-- Added a Right Image class--><img src="../<%# npo.Logo %>" /><div id="LoadImg"></div><div class="ClearFix"></div></div><textarea id="DescriptionTextBox">' + decodeURIComponent(description) + '</textarea>');
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
                    $("#profile-edit-description").html('<div id="profile-edit-image" class="right"><!-- Added a Right Image class--><img src="../<%# npo.Logo %>" /><div id="LoadImg"></div><div class="ClearFix"></div></div><p id="DescriptionText">' + decodeURIComponent(description) + '</p>');
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
                <h1><%# npo.Name %></h1>
            </div>
            <div id="profile-edit-description">
                <div id="profile-edit-image" class="right"><!-- Added a Right Image class-->
                    <img src="../<%# npo.Logo %>" />
                    <div id="LoadImg"></div>
                    <div class="ClearFix"></div>
                </div>
                <p id="DescriptionText"><%# npo.NPODescription %></p>
            </div>
            <div><%--Campaigns go here --%>
                <div id="Campaigns">
                    <h2>Current Campaigns</h2>
                    <p>Want to support our cause, then have a look at the <strong>current campaigns</strong> that we are running.</p>
                    <% Response.Write(CouponsForGiving.HttpRendering.ListNPOCampaignsForNPO(campaigns));%>
                </div>
            </div>   
            <div id="profile-edit-address">
                <label>Address</label>
                <p><%# npo.cAddress %></p>
            </div>
            <div id="profile-edit-postal-code">
                <label>Postal Code</label>
                <p><%# npo.PostalCode %></p>
            </div>
            <div id="profile-edit-email">
                <label>Email</label>
                <p><%# npo.Email %></p>
            </div>
            <div id="profile-edit-phone-number">
                <label>Phone</label>
                <p><%# npo.PhoneNumber %></p>       
            </div>
            <div id="profile-edit-city">
                <label>City</label>
                <p><%# npo.City.Name %></p>         
            </div>
            <div id="profile-edit-province">
                <label>Province</label>
                <p><%# npo.City.PoliticalDivision.Name %></p>
            </div>
            <div id="profile-edit-country">
                <label>Country</label>
                <p><%# npo.City.Country.Name %></p>
            </div>
            <div class="FormRow">
                <label for="">Auto-Accept Merchant Requests</label>
                <input type="checkbox" checked="<%# npo.NPOSettings.FirstOrDefault<CouponsForGiving.Data.NPOSetting>().AutoAcceptMerchantRequests ? "checked": "" %>" />
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
</asp:Content>