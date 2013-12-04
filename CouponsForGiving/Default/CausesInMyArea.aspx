<%@ Page Title="Deals in my Area" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="CausesInMyArea.aspx.cs" Inherits="Default_DealsInMyArea" EnableViewStateMac="False" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server" EnableViewState="True" ViewStateMode="Inherit" ValidateRequestMode="Inherit">
    <h1>Causes in <%:City %></h1>
    <% Response.Write(CouponsForGiving.HttpRendering.ListNPOCampaigns(LocalCampaigns)); %>
</asp:Content>