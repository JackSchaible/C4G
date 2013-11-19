<%@ Page Title="Nearly There" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="NearlyThere.aspx.cs" Inherits="Merchant_NearlyThere" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <h1>...Almost There!</h1>
    <p>You should be redirected shortly...</p>
    <asp:Label ID="ErrorLabel" ClientIDMode="Static" runat="server"></asp:Label>
</asp:Content>