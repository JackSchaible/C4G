<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="PurchaseHistory.aspx.cs" Inherits="Default_My_PurchaseHistory" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <h1>Purchase History</h1>
    <p>You don't have any purchases at this time. <a href="../Search.aspx" class="btn">Search for a deal.</a></p>
</asp:Content>