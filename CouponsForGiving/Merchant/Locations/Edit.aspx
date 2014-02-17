<%@ Page Title="Edit A Location" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Edit.aspx.cs" Inherits="Merchant_Locations_Edit" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content4" ContentPlaceHolderID="Main_Content" Runat="Server">
        <h1>Edit a Merchant Location</h1>
    <% 
        if (merchant.MerchantLocations.Where(x => x.StatusID == 2).Count() == 0)
            Response.Write("<p>Warning: Adding a merchant location will remove you from the Global Marketplace.</p>");
    %>
    <asp:Panel ID="EditPanel" runat="server">
        <div class="Form">
            <div class="FormRow">
                <label>Select a Country</label>
                <asp:DropDownList ID="CountryDDL" runat="server" AutoPostBack="true"
                    DataTextField="Name" DataValueField="CountryCode">
                </asp:DropDownList>
            </div>
            <div class="FormRow">
                <label>Select a Province or State</label>
                <asp:DropDownList ID="PDDDL" runat="server" AutoPostBack="true"
                    DataTextField="Name" DataValueField="PoliticalDivisionID">
                </asp:DropDownList>
            </div>
            <div class="FormRow">
                <label>Select a City</label>
                <asp:DropDownList ID="CityDDL" runat="server"
                    DataTextField="Name" DataValueField="CityID">
                </asp:DropDownList>
            </div>
            <div class="FormRow">
                <label>Location Description</label>
                <asp:TextBox ID="DescriptionTextBox" runat="server" 
                    TextMode="MultiLine">
                </asp:TextBox>
            </div>
            <div class="FormRow">
                <label>Address</label>
                <asp:TextBox ID="AddressTextBox" runat="server"
                    placeholder="1234, 5th Street">
                </asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" 
                    runat="server" ErrorMessage="Address is required."
                    ControlToValidate="AddressTextBox">
                </asp:RequiredFieldValidator>
            </div>
            <div class="FormRow">
                <label>Postal Code</label>
                <asp:TextBox ID="PostalCodeTextBox" runat="server"
                    placeholder="T6L2M9, 90210, or 90210-1234">
                </asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" 
                    runat="server" ErrorMessage="Postal Code is required."
                    ControlToValidate="PostalCodeTextBox">
                </asp:RequiredFieldValidator>
            </div>
            <div class="FormRow">
                <label>Phone Number</label>
                <asp:TextBox ID="PhoneNumberTextBox" runat="server"
                    placeholder="555-123-4567">
                </asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" 
                    runat="server" ErrorMessage="Phone Number is required."
                    ControlToValidate="PhoneNumberTextBox">
                </asp:RequiredFieldValidator>
            </div>
            <div class="FormRow">
                <% 
                    if (merchant.MerchantLocations.Where(x => x.StatusID == 2).Count() == 0)
                        Response.Write("<p>Warning: Adding a merchant location will remove you from the Global Marketplace.</p>");
                %>
                <asp:Label ID="ErrorLabel" runat="server"></asp:Label>
                <asp:Button ID="SubmitButton" runat="server" 
                    Text="Submit" OnClick="SubmitButton_Click" />
            </div>
        </div>
    </asp:Panel>
    <asp:Panel ID="LockedPanel" runat="server" Visible="false">
        <p>Unfortunately, this merchant location may not be edited, as it is, or was in use by an offer. You may deactivate this location by clicking the button below.</p>
        <asp:Button ID="DeactivateButton" runat="server" Text="Deactivate" OnClick="DeactivateButton_Click" />
    </asp:Panel>
</asp:Content>