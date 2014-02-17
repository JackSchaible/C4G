<%@ Page Title="My Locations" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Merchant_Locations_Default" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content4" ContentPlaceHolderID="Main_Content" Runat="Server">
    <h1>Merchant Locations</h1>
    <a href="Add.aspx">Add a New Location</a>
    <h2>Active Merchant Locations</h2>
    <asp:Panel ID="DeletePanel" runat="server" Visible="false">
        <p>Warning: Deleting the Default Address for your business will add you to the Global Marketplace? Are you sure you want to do this?</p>
        <asp:Button ID="NoButton" runat="server" OnClick="ButtonClick" Text="No" />
        <asp:Button ID="YesButton" runat="server" OnClick="ButtonClick" Text="Yes" />
        <asp:HiddenField ID="MLID" runat="server" />
        <div class="clear"></div>
    </asp:Panel>
    <asp:GridView ID="LocationsGV" AutoGenerateColumns="False" runat="server" DataKeyNames="MerchantLocationID" OnSelectedIndexChanging="LocationsGV_SelectedIndexChanging">
        <Columns>
            <asp:CommandField SelectText="Deactivate" ShowSelectButton="True" />
            <asp:HyperLinkField DataNavigateUrlFields="MerchantLocationID" DataNavigateUrlFormatString="Edit.aspx?mlid={0}" Text="Edit" />
            <asp:TemplateField HeaderText="Location Description">
                <ItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("LocationDescription") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="cAddress" HeaderText="Address" />
            <asp:BoundField DataField="PhoneNumber" HeaderText="Phone Number" />
            <asp:BoundField DataField="City" HeaderText="City" />
            <asp:BoundField DataField="PostalCode" HeaderText="Postal Code" />
        </Columns>
        <EmptyDataTemplate>
            <p>You have no merchant locations on your account. <a href="Add.aspx">Click here</a> to add some!</p>
        </EmptyDataTemplate>
    </asp:GridView>
    <h2>Inactive Merchant Locations</h2>
    <asp:GridView ID="InactiveLocationsGV" AutoGenerateColumns="false" runat="server" 
        OnSelectedIndexChanging="InactiveLocationsGV_SelectedIndexChanging" DataKeyNames="MerchantLocationID">
        <Columns>
            <asp:CommandField SelectText="Reactivate" ShowSelectButton="True" />
            <asp:TemplateField HeaderText="Location Description">
                <ItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("LocationDescription") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="cAddress" HeaderText="Address" />
            <asp:BoundField DataField="PhoneNumber" HeaderText="Phone Number" />
            <asp:BoundField DataField="City" HeaderText="City" />
            <asp:BoundField DataField="PostalCode" HeaderText="Postal Code" />
        </Columns>
        <EmptyDataTemplate>
            <p>There are no inactive locations on your account.</p>
        </EmptyDataTemplate>
    </asp:GridView>
</asp:Content>