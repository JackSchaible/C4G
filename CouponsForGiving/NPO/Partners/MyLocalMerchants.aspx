<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="MyLocalMerchants.aspx.cs" Inherits="NPO_Partners_MyLocalMerchants" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <h1>My Local Merchants List</h1>
    <asp:GridView ID="LocalMerchantsGV" runat="server" AutoGenerateColumns="False" DataKeyNames="MerchantID" OnRowDeleting="LocalMerchantsGV_RowDeleting">
        <Columns>
            <asp:ImageField DataImageUrlField="SmallLogo" DataImageUrlFormatString="../../{0}">
            </asp:ImageField>
            <asp:BoundField DataField="Name" />
            <asp:BoundField DataField="City" />
            <asp:BoundField DataField="Province" />
            <asp:HyperLinkField DataNavigateUrlFields="Name" DataNavigateUrlFormatString="../../Default/MerchantPage.aspx?MerchantName={0}" Text="Click to View Offers" />
            <asp:BoundField DataField="Offers" DataFormatString="{0} Offers Available" />
            <asp:CommandField DeleteText="Remove" ShowDeleteButton="True" />
        </Columns>
        <EmptyDataTemplate>
            <p>You have no local merchant partners in your My Merchant List! Click below to add some!</p>
        </EmptyDataTemplate>
    </asp:GridView>
    <asp:Label ID="ErrorLabel" runat="server"></asp:Label>
    <a href="Add.aspx" class="btn">Add A New Merchant</a>
    <a href="../Campaigns/New.aspx" class="btn">Setup A Campaign</a>
</asp:Content>