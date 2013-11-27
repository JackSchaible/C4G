<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="MyGlobalMerchants.aspx.cs" Inherits="NPO_Partners_MyGlobalMerchants" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <h1>My Global Merchants</h1>
    <asp:GridView ID="GlobalMerchantsGV" runat="server" AutoGenerateColumns="False" OnRowDeleting="GlobalMerchantsGV_RowDeleting">
        <Columns>
            <asp:ImageField DataImageUrlField="SmallLogo" DataImageUrlFormatString="../../{0}">
            </asp:ImageField>
            <asp:BoundField DataField="Name" />
            <asp:BoundField DataFormatString="Global E-Tailer" />
            <asp:HyperLinkField DataTextField="Name" DataTextFormatString="../../Default/MerchantPage.aspx?MerchantName={0}" Text="Click to View Offers" />
            <asp:BoundField DataField="Offers" DataFormatString="{0} Offers Available" />
            <asp:CommandField DeleteText="Remove" ShowDeleteButton="True" />
        </Columns>
        <EmptyDataTemplate>
            <p>You have no global merchants in your My Merchant List. Click below to add some!</p>
        </EmptyDataTemplate>
    </asp:GridView>
    <asp:Label ID="ErrorLabel" runat="server"></asp:Label>
    <a class="btn" href="Add.aspx">Add A New Merchant</a>
</asp:Content>