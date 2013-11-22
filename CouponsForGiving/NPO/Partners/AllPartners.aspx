<%@ Page Title="All Partners" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="AllPartners.aspx.cs" Inherits="NPO_Partners_AllPartners" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <asp:GridView ID="PartnersGV" runat="server" AutoGenerateColumns="False">
        <Columns>
            <asp:ImageField DataImageUrlField="SmallLogo" DataImageUrlFormatString="../../{0}">
            </asp:ImageField>
            <asp:BoundField DataField="Name" />
            <asp:BoundField DataFormatString="Global E-Tailer" />
            <asp:HyperLinkField Text="Click to View Offers" DataNavigateUrlFields="Name" DataNavigateUrlFormatString="../../Default/MerchantPage.aspx?MerchantName={0}" />
            <asp:BoundField DataField="Offers" DataFormatString="{0} Offers Available" />
            <asp:CommandField DeleteText="Remove" ShowDeleteButton="True" />
        </Columns>
        <EmptyDataTemplate>
            <p>You have not added any merchant partners. <a href="Add.aspx" class="btn">Add a Merchant</a></p>
        </EmptyDataTemplate>
    </asp:GridView>
    <asp:Label ID="ErrorLabel" runat="server"></asp:Label>
</asp:Content>