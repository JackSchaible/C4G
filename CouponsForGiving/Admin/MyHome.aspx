<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="MyHome.aspx.cs" Inherits="Admin_Home" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <h1>Admin Functions</h1>
    <p>Use the links below to access the various Administrator reports.</p>
    <hr />
    <a href="Users.aspx" class="btn"><i class="fa fa-group"></i> Users Reports</a>
    <a href="Financial.aspx" class="btn"><i class="fa fa-credit-card"></i> Financial Report</a>
</asp:Content>