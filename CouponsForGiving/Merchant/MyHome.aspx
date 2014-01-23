<%@ Page Title="Home" Language="C#" AutoEventWireup="true" CodeFile="MyHome.aspx.cs" Inherits="Merchant_Home" MasterPageFile="~/Site.master" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>
<%@ MasterType VirtualPath="~/Site.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Main_Content" Runat="Server">
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
        var city = '<%# city.Name %>';
        var province = '<%# city.PoliticalDivision.Name %>';
        var country = '<%# city.Country.Name %>';
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
            $("#Mode").html('<a id="modeButton" href="javascript:save()" class="btn-profile"><i class="fa fa-pencil-square-o"></i> Save</a><a id="A2" href="javascript:cancel()" class="btn-profile"><i class="fa fa-pencil-square-o"></i> Cancel</a>');

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
            $("#Mode").html('<a id="modeButton" href="javascript:edit()" class="btn-profile"><i class="fa fa-pencil-square-o"></i> Edit</a>');

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
    <style type="text/css">
        /*Controls*/
        .ImgEdit {
            margin: 30px 10% 0 0;
        }

        .Uploader {
            margin: 100px 0 0 0;
            position: absolute;
            top: 0;
            right: 0;
        }
    </style>
    <div class="">
	    <div class="profile-edit">
            <div id="profile-edit-name">
                <div id="Mode">
                    <a id="modeButton" href="javascript:edit()" class="btn-profile"><i class="fa fa-pencil-square-o"></i> Edit</a>
                </div>
                <h1>My Profile</h1>
            </div>
            <span id="ErrorMessages"></span>
            <h2 class="my-profile">Merchant Information</h2>
            <h3 class="profile-icon"><i class="fa fa-user"></i></h3>
            <div class="profile-edit">
                <div class="two-thirds">
        	        <div id="profile-edit-name">
                        <h3><%# merchant.Name %></h3>
                    </div>
                    <div id="profile-edit-description">
                        <p id="DescriptionText"><%# merchant.cUser.MerchantInfoes.FirstOrDefault<CouponsForGiving.Data.MerchantInfo>().MerchantDescription %></p>
                    </div>  
                </div>
                <div class="thirds">
                    <div id="profile-edit-image">
                        <img src="../<%# merchant.LargeLogo %>" class="npo_logo" />
                        <div id="LoadImg"></div>
                        <div class="ClearFix"></div>
                    </div>
                </div>
                <div class="half">     
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
                    <div class="FormRow">
                        <label for="">Auto-Accept Merchant Requests</label>
                        <input type="checkbox" checked="<%# merchant.MerchantSettings.FirstOrDefault<CouponsForGiving.Data.MerchantSetting>().AutoAcceptRequests.Value ? "checked": "" %>" />
                    </div>
                </div>
                <div class="half">
                    <div id="profile-edit-city">
                        <label>City</label>
                        <p><%# CouponsForGiving.Data.Classes.Cities.Get(merchant.CityID).Name %></p>
                    </div>
                    <div id="profile-edit-province">
                        <label>Province</label>
                        <p><%# CouponsForGiving.Data.Classes.Cities.Get(merchant.CityID).PoliticalDivision.Name %></p>
                    </div>
                    <div id="profile-edit-country">
                        <label>Country</label>
                        <p><%# CouponsForGiving.Data.Classes.Cities.Get(merchant.CityID).Country.Name %></p>
                    </div>
                    <label>Receive E-Mail Notifications</label>
                    <asp:RadioButtonList ID="RecieveEmails" runat="server">
                        <asp:ListItem Text="Yes" Value="Yes"></asp:ListItem>
                        <asp:ListItem Text="No" Value="No"></asp:ListItem>
                    </asp:RadioButtonList>
                </div>
            </div>
       	</div>
       	<div class="clear"></div>
        <div class="half">
       	    <h2 class="my-profile">Set-up An Offer</h2>
       	    <h3 class="profile-icon"><i class="fa fa-plus"></i></h3>
       	    <p>Create a brand new Coupons4Giving campaign to raise funds for your organization.</p>
       	    <a href="Offers/New.aspx" class="btn-small"><i class="fa fa-arrow-circle-o-right"></i> Set-up Offer</a>
       	</div>
        <div class="half">
       	    <h2 class="my-profile">Manage My Offers</h2>
       	    <h3 class="profile-icon"><i class="fa fa-cog"></i></h3>
       	    <p>Manage and Edit your current Coupons4Giving offers. See reports of your previous and current offers.</p>
       	    <a href="Offers/MyOffers.aspx" class="btn-small"><i class="fa fa-pencil-square-o"></i> Edit Offers</a> <a href="Reports.aspx" class="btn-small"><i class="fa fa-file-text-o"></i> Offer Reports</a>
		</div>
       	<div class="clear"></div>
        <div class="half">
       	    <h2 class="my-profile">Add NPO Partners</h2>
       	    <h3 class="profile-icon"><i class="fa fa-plus"></i></h3>
       	    <p><strong>Add</strong> a NPO Partner to an existing offer.</p>
       	    <a href="MyPartners/Search.aspx" class="btn-small"><i class="fa fa-arrow-circle-o-right"></i> Add Partners</a>
       	</div>
        <div class="half">
       	    <h2 class="my-profile">Manage NPO Partners</h2>
       	    <h3 class="profile-icon"><i class="fa fa-cog"></i></h3>
       	    <p><strong>Manage, Edit and set</strong> the notification of accepted requests for NPO Partners.</p>
            <%--Set Notifications?--%>
       	    <a href="MyPartners/MyPartners.aspx" class="btn-small"><i class="fa fa-pencil-square-o"></i> Edit Partners</a> <a href="" class="btn-small"><i class="fa fa-pencil-square-o"></i> Set Notifications</a>
		</div>
        <div class="clear"></div>
        <h2 class="my-profile">Notifications</h2>
        <h3 class="profile-icon"><i class="fa fa-envelope"></i></h3>
        <%
            string notifications = "<ul>";
            foreach (CouponsForGiving.Data.Notification item in CouponsForGiving.Data.Classes.NotificationcUsers.ListByUser(HttpContext.Current.User.Identity.Name))
                notifications += String.Format("<li>{0}</li>", item.Value);
            notifications += "</ul>";

            Response.Write(notifications);
        %>
        <div class="clear"></div>
        <div class="half">
       	    <h2 class="my-profile">Reports</h2>
       	    <h3 class="profile-icon"><i class="fa fa-file-text"></i></h3>
       	    <p><strong>View</strong> current Campaign Reports</p>
       	    <a href="Reports.aspx" class="btn-small"><i class="fa fa-file-text-o"></i> View Reports</a>
       	</div>
        <div class="half">
       	    <h2 class="my-profile">Support Causes</h2>
       	    <h3 class="profile-icon"><i class="fa fa-shopping-cart"></i></h3>
       	    <p><strong>Support</strong> current offers from NPOs.</p>
       	    <a href="../Default/DealsInMyArea.aspx" class="btn-small"><i class="fa fa-shopping-cart"></i> Purchase Deals</a>
		</div>
       	<div class="clear"></div>
    </div>
</asp:Content>