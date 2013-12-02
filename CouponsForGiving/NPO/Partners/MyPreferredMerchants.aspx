<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="MyPreferredMerchants.aspx.cs" Inherits="NPO_Partners_MyPreferredMerchants" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <h1>My Preferred Merchants</h1>
    <asp:GridView ID="MyPrefferedMerchantsGV" runat="server" AutoGenerateColumns="false">
        <EmptyDataTemplate>
            <p>You have no preferred merchants in your My Merchant List. Click below to add some!</p>
            <a href="Add.aspx" class="btn">ADD A NEW MERCHANT</a>
        </EmptyDataTemplate>
    </asp:GridView>
</asp:Content>