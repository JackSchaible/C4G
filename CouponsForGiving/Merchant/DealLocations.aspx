<%@ Page Title="Deal Location Management" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Add.aspx.cs" Inherits="Merchant_DealLocations_Add" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content4" ContentPlaceHolderID="Main_Content" Runat="Server">

    <h1>Add Merchant Locations to Your Offer!</h1>
    
    <h2>Select From Your Available Locations:</h2>
    
    <asp:GridView ID="LocationsGV" AutoGenerateColumns="False" runat="server" DataKeyNames="MerchantLocationID" 
        OnSelectedIndexChanging="LocationsGV_SelectedIndexChanging">
        <Columns>
            <asp:CommandField SelectText="Add" ShowSelectButton="True" />
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
            <p>
                <%
                    if (merchant.MerchantLocations.Where(x => x.StatusID == 2).Count() == 0)
                        Response.Write("As an online-only merchant, you do not have merchant locations to add to offers. <a href=\"../MyHome.aspx\">Click here</a> to go back to your profile.");
                    else
                        if (deal.Deal.MerchantLocations.Count > 0)
                            Response.Write("You have already added all your available merchant locations to this deal.");
                        else
                            Response.Write("You have no merchant locations on your account. <a href=\"Add.aspx\">Click here</a> to add some!");
                %>
            </p>
        </EmptyDataTemplate>
    </asp:GridView>
    <asp:Label ID="ErrorLabel" runat="server"></asp:Label>
    <asp:Button ID="AddAllButton" runat="server" Text="Add All!" OnClick="AddAllButton_Click" />

    <asp:Panel ID="DealLocationsPanel" runat="server">
        <h2>Locations Already Added to this Offer:</h2>
    
        <asp:GridView ID="CurrentLocationsGV" AutoGenerateColumns="False" runat="server" DataKeyNames="MerchantLocationID" 
            OnSelectedIndexChanging="CurrentLocationsGV_SelectedIndexChanging">
            <Columns>
                <asp:CommandField SelectText="Remove" ShowSelectButton="True" />
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
                <p>There are no merchant locations added to this deal. Use the table above to add some!</p>
            </EmptyDataTemplate>
        </asp:GridView>
        <asp:Button ID="RemoveAllButton" runat="server" Text="Remove All" OnClick="RemoveAllButton_Click" />
    </asp:Panel>

    <asp:Button ID="ContinueButton" runat="server" Text="Finish" OnClick="ContinueButton_Click" />
</asp:Content>