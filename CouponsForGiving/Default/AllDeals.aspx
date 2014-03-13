<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="AllDeals.aspx.cs" Inherits="Default_AllDeals" %>

<asp:Content ID="Content4" ContentPlaceHolderID="Main_Content" Runat="Server">
    <h1>Our Offers</h1>
    <% Response.Write(CouponsForGiving.HttpRendering.ListMerchantOffers(DIs)); %>
</asp:Content>