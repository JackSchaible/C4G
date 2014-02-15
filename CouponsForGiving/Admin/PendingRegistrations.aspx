<%@ Page Title="Account Requests" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="PendingRegistrations.aspx.cs" Inherits="Admin_PendingRegistrations" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>
<%@ MasterType VirtualPath="~/Site.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <h1>Pending Account Requests</h1>
    <asp:Label ID="ErrorLabel" runat="server"></asp:Label>
    <asp:Button ID="ApproveAllButton" runat="server" Text="Approve ALL Requests" OnClick="ApproveAllButton_Click" />
    <div class="clear"></div>
    <h2>Pending Not-For-Profit Organizations</h2>
    <asp:Button ID="ApproveAllNPOs" runat="server" Text="Approve ALL Not-for-Profit Requests" OnClick="ApproveAllNPOs_Click" />
    <div class="clear"></div>
    <asp:GridView ID="NPOGV" runat="server" AutoGenerateColumns="False" DataKeyNames="NPOID" DataSourceID="NPOODS" OnSelectedIndexChanging="NPOGV_SelectedIndexChanging">
        <Columns>
            <asp:CommandField SelectText="Approve" ShowSelectButton="True" />
            <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
            <asp:BoundField DataField="cAddress" HeaderText="Address" SortExpression="cAddress" />
            <asp:BoundField DataField="City" HeaderText="City" SortExpression="City" />
            <asp:BoundField DataField="Province_State" HeaderText="Province/State" SortExpression="Province_State" />
            <asp:BoundField DataField="Country" HeaderText="Country" SortExpression="Country" />
            <asp:BoundField DataField="PostalCode" HeaderText="Postal Code" SortExpression="PostalCode" />
            <asp:BoundField DataField="PhoneNumber" HeaderText="Phone Number" SortExpression="PhoneNumber" />
            <asp:BoundField DataField="Email" HeaderText="Email" SortExpression="Email" />
            <asp:BoundField DataField="URL" HeaderText="URL" SortExpression="URL" />
            <asp:BoundField DataField="Username" HeaderText="Username" SortExpression="Username" />
        </Columns>
        <EmptyDataTemplate>
            <p>There are no pending not-for-profit requests.</p>
        </EmptyDataTemplate>
    </asp:GridView>
    <asp:ObjectDataSource ID="NPOODS" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="ListPendingNPOs" TypeName="CouponsForGiving.Data.SysData"></asp:ObjectDataSource>
    <h2>Pending Merchants</h2>
    <asp:Button ID="ApproveAllMerchants" runat="server" Text="Approve ALL Merchant Requests" OnClick="ApproveAllMerchants_Click" />
    <asp:GridView ID="MerchantGV" runat="server" AutoGenerateColumns="False" DataSourceID="MerchantODS" OnSelectedIndexChanging="MerchantGV_SelectedIndexChanging">
        <Columns>
            <asp:CommandField SelectText="Approve" ShowSelectButton="True" />
            <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
            <asp:BoundField DataField="Username" HeaderText="User" SortExpression="Username" />
            <asp:BoundField DataField="cAddress" HeaderText="Address" SortExpression="cAddress" />
            <asp:BoundField DataField="City" HeaderText="City" SortExpression="City" />
            <asp:BoundField DataField="Province_State" HeaderText="Province/State" SortExpression="Province_State" />
            <asp:BoundField DataField="PostalCode" HeaderText="Postal Code" SortExpression="PostalCode" />
            <asp:BoundField DataField="Country" HeaderText="Country" SortExpression="Country" />
            <asp:BoundField DataField="PhoneNumber" HeaderText="Phone Number" SortExpression="PhoneNumber" />
            <asp:BoundField DataField="Website" HeaderText="Website" SortExpression="Website" />
        </Columns>
        <EmptyDataTemplate>
            <p>There are no pending merchant requests.</p>
        </EmptyDataTemplate>
    </asp:GridView>
    <asp:ObjectDataSource ID="MerchantODS" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="ListPendingMerchants" TypeName="CouponsForGiving.Data.SysData"></asp:ObjectDataSource>
</asp:Content>