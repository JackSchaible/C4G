<%@ Page Title="Deals in my Area" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="CausesInMyArea.aspx.cs" Inherits="Default_DealsInMyArea" EnableViewStateMac="False" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server" EnableViewState="True" ViewStateMode="Inherit" ValidateRequestMode="Inherit">
    <style type="text/css">
        #content img {
            width: 100px;
        }
    </style>
    <h1>Causes in <%:City %></h1>
    <asp:gridview runat="server" ID="DealsGV" AutoGenerateColumns="False" DataKeyNames="CampaignID">
        <Columns>
            <asp:HyperLinkField DataNavigateUrlFields="NPO,Campaign" DataNavigateUrlFormatString="../Causes/{0}/{1}" Text="View Campaign" />
            <asp:BoundField DataField="NPO" HeaderText="Fundraiser" />
            <asp:ImageField DataImageUrlField="NPOLogo" DataImageUrlFormatString="../{0}">
            </asp:ImageField>
            <asp:BoundField DataField="Campaign" HeaderText="Campaign" />
            <asp:ImageField DataImageUrlField="CampaignImage" DataImageUrlFormatString="../{0}">
            </asp:ImageField>
            <asp:BoundField DataField="NoOfOffers" HeaderText="Offers in Your Area" />
        </Columns>
        <EmptyDataTemplate>
            <p>We were unable to locate any causes in your city. <a href="Search.aspx">Click here</a> to search for causes in a different city!</p>
        </EmptyDataTemplate>
    </asp:gridview>
    <asp:Label ID="ErrorLabel" runat="server"></asp:Label>
</asp:Content>