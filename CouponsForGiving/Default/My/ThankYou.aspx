<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="ThankYou.aspx.cs" Inherits="Default_My_ThankYou" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <p>Thank you for your purchase. Your items can be found under "My Purchase History" or by clicking <a href="PurchaseHistory.aspx">here</a>.</p>
</asp:Content>