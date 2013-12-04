<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="DealsInMyArea.aspx.cs" Inherits="Default_DealsInMyArea" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <h1>Deals in <%: City %>, <%: Province %></h1>
    <% Response.Write(CouponsForGiving.HttpRendering.ListMerchantOffers(DIs)); %>
</asp:Content>