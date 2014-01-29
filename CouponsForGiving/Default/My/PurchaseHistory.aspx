<%@ Page Title="My Purchase History" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="PurchaseHistory.aspx.cs" Inherits="Default_My_PurchaseHistory" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <h1>Purchase History</h1>
    <h2>Unredeemed Orders</h2>
    <asp:GridView ID="UnredeemedGV" runat="server" AutoGenerateColumns="False" OnSelectedIndexChanging="UnredeemedGV_SelectedIndexChanging">
        <Columns>
            <asp:CommandField SelectText="Get Coupon!" ShowSelectButton="True" />
            <asp:BoundField DataField="Deal" HeaderText="Offer" />
            <asp:BoundField DataField="Merchant" HeaderText="Merchant" />
            <asp:BoundField DataField="Campaign" HeaderText="Campaign" />
            <asp:BoundField DataField="NPO" HeaderText="Not-For-Profit" />
            <asp:BoundField DataField="Price" DataFormatString="{0:c}" HeaderText="Price" />
        </Columns>
        <EmptyDataTemplate>
            <p>You don't have any purchases at this time. <a href="../Search.aspx" class="btn">Search for a deal.</a></p>
        </EmptyDataTemplate>
    </asp:GridView>
    
</asp:Content>