<%@ Page Title="Home" Language="C#" AutoEventWireup="true" CodeFile="MyHome.aspx.cs" Inherits="Merchant_Home" MasterPageFile="~/Site.master" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>
<%@ MasterType VirtualPath="~/Site.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Main_Content" Runat="Server">
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
                <%--<div id="EditMode">
                    <a id="modeButton" href="javascript:edit()" class="btn-profile"><i class="fa fa-pencil-square-o"></i> Edit</a>
                </div>--%>
                <h1>My <%: merchant == null ? "" : merchant.Name %> Dashboard</h1>
            </div>
            <span id="ErrorMessages"></span>
            <div class="profile-edit">
                <div class="three-quarters">
        	        <div id="profile-edit-name">
                        <h3><%# merchant == null ? "" : merchant.Name %></h3>
                    </div>
                    <div id="profile-edit-description">
                        <p id="DescriptionText"><%# merchant == null ? "" : merchant.cUser.MerchantInfoes.FirstOrDefault<CouponsForGiving.Data.MerchantInfo>().MerchantDescription %></p>
                    </div>  
                </div>
                <div class="quarter">
                    <div id="profile-edit-image">
                        <img src="../<%# merchant == null ? "Images/c4g_home_npos_step4.png" : merchant.LargeLogo %>" class="npo_logo" />
                        <div id="LoadImg"></div>
                        <div class="ClearFix"></div>
                    <a id="modeButton" href="Edit.aspx" class="btn-profile"><i class="fa fa-pencil-square-o"></i> Edit My Profile</a>

                    </div>
                </div>
                <h3 class="profile-icon"><i class="fa fa-envelope"></i></h3>
                <div class="clear"></div>
                <%--<div class="half">     
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
                </div>--%>
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
       	    <a href="Offers/MyOffers.aspx" class="btn-small"><i class="fa fa-pencil-square-o"></i> Edit Offers</a> 
            <a href="Reports/MyReports.aspx" class="btn-small"><i class="fa fa-file-text-o"></i> Offer Reports</a>
            <a href="Locations/Default.aspx" class="btn-small"><i class="fa fa-file-text-o"></i> Manage My Locations</a>
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
       	    <a href="MyPartners/MyPartners.aspx" class="btn-small"><i class="fa fa-pencil-square-o"></i> Edit Partners</a> <a href="MyPartners/MyPartners.aspx" class="btn-small"><i class="fa fa-pencil-square-o"></i> Set Notifications</a>
		</div>
        <div class="clear"></div>
        <h2 class="my-profile">Notifications</h2>
        <%
            string notifications = "<ul>";
            //notifications += !User.IsInRole("Merchant") ? "Your profile has not been completed! <a href=\"Signup.aspx\">Click here</a> to complete your profile." : "";
            notifications += merchant == null ? "" : (merchant.MerchantStripeInfoes.Count == 0 ? "Something went wrong when connecting to Stripe. Until you do, you won't be able to accept payments, set up offers, or partner with not-for-profits, <a href=\"ConnectToStripe.aspx\">Click here</a> to set up your Stripe account!" : "");
            /*
            foreach (CouponsForGiving.Data.Notification item in CouponsForGiving.Data.Classes.NotificationcUsers.ListByUser(HttpContext.Current.User.Identity.Name))
                notifications += String.Format("<li>{0}</li>", item.Value);
            notifications += "</ul>";
            */
            
            Response.Write(notifications);
        %>
        <div class="clear"></div>
        <div class="half">
       	    <h2 class="my-profile">Reports</h2>
       	    <h3 class="profile-icon"><i class="fa fa-file-text"></i></h3>
       	    <p><strong>View</strong> current Campaign Reports</p>
       	    <a href="Reports/MyReports.aspx" class="btn-small"><i class="fa fa-file-text-o"></i> View Reports</a>
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