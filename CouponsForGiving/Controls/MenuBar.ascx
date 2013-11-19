<%@ Control Language="C#" AutoEventWireup="true" CodeFile="MenuBar.ascx.cs" Inherits="Controls_MenuBar" %>
<style type="text/css">
    #MenuBarControl_Menu {
        margin: inherit !important;
        float: inherit !important;
    }

    #MenuBarControl_Menu ul {
        float: inherit !important;
        margin: inherit !important;
        padding: inherit !important;
    }
</style>
<nav>
    <div class="HeaderContent">
        <asp:Menu ID="Menu" runat="server" BackColor="#22BFE8" Orientation="Horizontal" StaticEnableDefaultPopOutImage="False" DataSourceID="SiteMapDataSource" IncludeStyleBlock="True" EnableTheming="False">
        </asp:Menu>
        <asp:SiteMapDataSource ID="SiteMapDataSource" runat="server" ShowStartingNode="False" />
    </div>
</nav>