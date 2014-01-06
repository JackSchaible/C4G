<%@ Page Title="My Home" MasterPageFile="~/Site.master" Language="C#" AutoEventWireup="true" CodeFile="MyHome.aspx.cs" Inherits="Default_My_MyHome" %>
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
    <script type="text/javascript">
        function edit() {
        }

        function cancel() {
        }
    </script>
	<div class="">
        <div class="profile-edit">
      	    <div id="profile-edit-name">
                <h1>My Profile</h1>
            </div>
            <span id="ErrorMessages"></span>
            <h2 class="my-profile">My Info</h2>
            <h3 class="profile-icon"><i class="fa fa-user"></i></h3>
       	</div><!-- Close Profile Edit Block-->
       	<div class="clear"></div>
       	<div class="half">
       	    <h2 class="my-profile">Manage My Deals</h2>
       	    <h3 class="profile-icon"><i class="fa fa-file-text-o"></i></h3>
       	    <p>Manage and maintain the deals that you've already purchased.</p>
       	    <a href="My/PurchaseHistory.aspx" class="btn-small"><i class="fa fa-file-text-o"></i> Manage My Deals</a>       	
       	</div>
		<div class="half">
       	    <h2 class="my-profile">Deals in My Area</h2>
       	    <h3 class="profile-icon"><i class="fa fa-search "></i></h3>
       	    <p><strong>Find</strong> featured deals in your area.</p>
       	    <a href="DealsInMyArea.aspx" class="btn-small"><i class="fa fa-search "></i> Deals In My area</a>
		</div>
       	<div class="clear"></div>
       	<div class="half">
       	    <h2 class="my-profile">Search for Causes</h2>
       	    <h3 class="profile-icon"><i class="fa fa-search "></i></h3>
       	    <p>Search our featured and local causes for an NPO to support</p>
       	    <a href="CausesInMyArea.aspx" class="btn-small"><i class="fa fa-search "></i> Search Causes</a>       	
       	</div>
		<div class="half">
       	    <h2 class="my-profile">My Preferred Causes</h2>
       	    <p><img src="images/c4g_comingsoon.png" width="300px"/>		
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
</asp:Content>