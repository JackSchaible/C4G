<%@ Page Title="Global Marketplace" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="GlobalMarketplace.aspx.cs" Inherits="Default_GlobalMarketplace" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <h1>Global Marketplace</h1>
    <div id="Deals">
        <% Response.Write(CouponsForGiving.HttpRendering.ListMerchantOffers(DIs)); %>
    </div>
</asp:Content>